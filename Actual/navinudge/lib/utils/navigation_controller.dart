import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import '../strings.dart';

class DecodedLeg {
  String stepInstructions;
  List<num> startCoordinate;
  List<num> endCoordinate;
  TravelMode travelMode;
  String? transitLineName; // Aka bus number or MRT line
  num? headway; // Headway in seconds
  String? headsign; // E.g. 'Woodlands', where is the transit moving towards
  String? startStop; // Name of the originating stop
  String? endStop; // Name of the alighting stop
  
  DecodedLeg(this.stepInstructions, this.startCoordinate, this.endCoordinate, this.travelMode); // Please inject the public transport information after calling this constructor!

  String generateReadableString() {
    if (travelMode == TravelMode.walking) {
      return 'Walking, please use guidance from NaviNudge';
    } else if (travelMode == TravelMode.transit) {
      // Determine bus or MRT
      if (stepInstructions.startsWith('Bus')) {
        // bus
        return 'Please take bus $transitLineName towards $headsign.\nThe bus comes every ${headway!/60} minutes.';
      } else if (stepInstructions.startsWith('Subway')) {
        return 'Please take $transitLineName towards $headsign.\nThe train comes every ${headway!/60} minutes.';
      }
    }
    return 'Error, please contact helpdesk for more info.';
  }
}

class NavigationController extends GetxController {
  // Private variables
  // Position? _currentPosition; // NOTE: this object also bundles position accuracy inside
  StreamSubscription<Position>? _positionStream;
  var _originLocation = '';
  var _destinationLocation = ''; //NOTE: do we just encode locations as strings?
  DirectionsService? directionsService;
  Leg? routingResult; // NOTE: yes it's a bit strange to use Leg as the routed result, but it's because Singapore-directions only have 1 leg of journey. Use routingResult.steps if you want to enumerate through all the steps

  // Observable variables
  var locationServiceActive = false.obs;  // This shows whether the location service is current receiving GPS coordinate updates. This is NOT the same as whether location services are enabled
  var gpsAccuracy = 0.obs;                // The radius of position estimate
  var currentCoordinates = [0.0,0.0].obs; // Format: Lat, Lon
  var futureCoordinates = [0.0,0.0].obs;
  var desiredBearing = 0.0.obs;           // This is the desired bearing to the target, from our current location
  var onRoute = false.obs;                // This shows whether the system has successfully computed the route
  var currentPathStep = (-1).obs;         // The current step of the path, 0 indexed. -1 means path not routed.
  var totalPathStepCount = -1;            // Total number of "steps" in the entire journey

  @override
  void onInit() {
    super.onInit();
    // Start the location controller over here
    DirectionsService.init(apiKey);
    directionsService = DirectionsService();
  }

  // Start the geolocation service
  Future<void> startLocationStream() async {
    if (_positionStream != null) {
      // Already have a position stream, no need to start location stream again
      return;
    }

    // Test if location services are enabled.
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      // Location services are not enabled, open settings
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(locationUpdatedListener);
  }

  // Stop the geolocation service
  void endLocationStream() {
    if (_positionStream != null) {
      _positionStream?.cancel();
    } else {
      print("Position stream already does not exist!");
    }
  }

  // TODO: turn all those prints into actual error throws so whoever calls this function can be informed about the errors
  void beginRouting(String destination) {
    _destinationLocation = destination;
    if (locationServiceActive.value) {
      final request = DirectionsRequest(
        origin: _originLocation,
        destination: destination,
        travelMode: TravelMode.transit,
        region: "sg",
        transitOptions: TransitOptions(modes: [TransitMode.bus])
      );
      directionsService!.route(request, (DirectionsResult response, DirectionsStatus? status) {
        if (status == DirectionsStatus.ok) {
          // do something with successful response
          final routes = response.routes;
          if (routes != null && routes.isNotEmpty) {
            print("Successful routing:");
            totalPathStepCount = 0;
            // We give only 1 solution out of all the routes and legs because we don't really want to give user choices...too many choices = confusion
            final route = routes[0];

            final legs = route.legs;
            if (legs != null && legs.isNotEmpty) {
              final leg = legs[0]; // Same thing here, only offer the first solution
              routingResult = leg;
              print('=============================');
              print('Departure time: ${leg.departureTime}');
              print('Arrival time: ${leg.arrivalTime}');
              print('Start location: ${leg.startLocation}');
              print('End location: ${leg.endLocation}');
              for (final step in leg.steps!){                 // Step. Each step refers to something like bus route, walking, etc.
                print('------------------------------');
                totalPathStepCount++;
                print('Step instructions: ${step.instructions}');
                print('Start location: ${step.startLocation}');
                print('End location: ${step.endLocation}');
                print('Travel mode: ${step.travelMode}');

                final pathPolyline = step.polyline?.points;
                if (step.travelMode == TravelMode.walking && pathPolyline != null) {
                  final polylineArray = decodePolyline(pathPolyline);
                  print('Path: $polylineArray');
                }
                if (step.transit != null) { // This step is a transit step
                  print('Transit short name: ${step.transit?.tripShortName}');
                  print('Departure stop: ${step.transit?.departureStop?.name}');
                  print('Arrival stop: ${step.transit?.arrivalStop?.name}');
                  print('Number of stops: ${step.transit?.numStops}');
                  print('Headway: ${step.transit?.headway}');
                  print('Headsign: ${step.transit?.headsign}');
                  if (step.transit!.line != null) {
                    print('Transit line name: ${step.transit!.line!.name}, Short name: ${step.transit!.line!.shortName}');
                  }
                }
              }
            }
             
            if (totalPathStepCount > 0) {
              // Confirm routing is a success
              onRoute.value = true;
            } else {
              print('Error in routing! Error message: route has no steps');
              routingResult = null;
              onRoute.value = false;
              totalPathStepCount = -1;
            }
          } else {
            print('Error in routing! Error message: No routes available');
          }
        } else {
          // do something with error response
          print('Error in routing! Error message: $response');
        }
      });
    } else {
      print('Location service not active!! Routing cannot proceed');
    }
  }

  // This function decodes the leg into its start point, end point, travel mode, bus number/train line and more.
  DecodedLeg? decodeNextWaypoint(Leg routingResult, int currentStep) {
    final steps = routingResult.steps;
    if (steps == null) {
      print("Steps is null!");
      return null;
    }
    final step = currentStep < steps.length ? steps[currentStep] : null;
    if (step == null) {
      print("Single step is null!");
      return null;
    }

    // Decode step instructions
    final stepInstructions = step.instructions;
    if (stepInstructions == null) {
      print("Step instructions is null!");
      return null;
    }

    // Find out the type of step
    final stepTravelMode = step.travelMode;
    if (stepTravelMode == null) {
      print("Step travel mode is null!");
      return null;
    }
    
    // Decode polyline
    final polyline = step.polyline?.points;
    if (polyline == null) {
      print("Polyline is null!");
      return null;
    }
    final polylineDecoded = decodePolyline(polyline);
    final startCoordinate = polylineDecoded.first;
    final endCoordinate = polylineDecoded.last;

    final returnValue = DecodedLeg(stepInstructions, startCoordinate, endCoordinate, stepTravelMode);
    if (stepTravelMode == TravelMode.transit) {
      // Decode transit line name
      final transitLineName = step.transit?.line?.name;
      if (transitLineName == null) {
        print("Transit line name is null!");
        return null;
      }
      returnValue.transitLineName = transitLineName;

      final headway = step.transit?.headway;
      if (headway == null) {
        print("Headway is null!");
        return null;
      }
      returnValue.headway = headway;

      final headsign = step.transit?.headsign;
      if (headsign == null) {
        print("Headsign is null!");
        return null;
      }
      returnValue.headsign = headsign;

      final startStop = step.transit?.departureStop?.name;
      if (startStop == null) {
        print("Start stop is null!");
        return null;
      }
      returnValue.startStop = startStop;

      final endStop = step.transit?.arrivalStop?.name;
      if (endStop == null) {
        print("End stop is null!");
        return null;
      }
      returnValue.endStop = endStop;
    }

    return returnValue;
  }

  // This function is called when the system detects the user can move on to the next stage of the path. 
  void advancePath() {
    if (currentPathStep.value < 0 || onRoute.value == false) {
      print("Error advancing path, controller has not started route!");
      return;
    }

    currentPathStep++;
    if (currentPathStep < totalPathStepCount) {
      // clear to advance
      
    } else {
      // yay user has reached!!
      // TODO: some sort of notification system to tell the user has reached
      endRouting();
      // endLocationStream(); //TODO: might not want to end location stream, since you do need to retrigger location
    }
  }

  void endRouting(){
    onRoute.value = false;
    currentPathStep.value = -1;
  }

  void locationUpdatedListener(Position position) {
    // _currentPosition = position;
    _originLocation = "${position.latitude},${position.longitude}";
    gpsAccuracy.value = position.accuracy.round();
    currentCoordinates.value = [position.latitude, position.longitude];
    if (!locationServiceActive.value) {
      locationServiceActive.value = true;
    }
    //TODO: further processing to be done here to retrieve bearing
    // Current positon can be fed into a bearing calculation algo
    desiredBearing.value = Geolocator.bearingBetween(position.latitude, position.longitude, futureCoordinates[0], futureCoordinates[1]);
  }
}
