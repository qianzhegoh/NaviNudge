import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import '../strings.dart';

class NavigationController extends GetxController {
  // Private variables
  // Position? _currentPosition; // NOTE: this object also bundles position accuracy inside
  StreamSubscription<Position>? _positionStream;
  var _originLocation = '';
  var _destinationLocation = ''; //NOTE: do we just encode locations as strings?
  DirectionsService? directionsService;
  DirectionsResult? routingResult;

  // Observable variables
  var locationServiceActive = false.obs; // This shows whether the location service is current receiving GPS coordinate updates. This is NOT the same as whether location services are enabled
  var gpsAccuracy = 0.obs; // The radius of position estimate
  var currentCoordinates = [0.0,0.0].obs; // Lat, Lon
  var futureCoordinates = [0.0,0.0].obs;
  var desiredBearing = 0.0.obs; // This is the desired bearing to the target, from our current location
  var onRoute = false.obs; // This shows whether the system has successfully computed the route
  var currentPathStep = (-1).obs; // The current step of the path, 0 indexed. -1 means path not routed.
  var totalPathStepCount = -1;

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
                  print('Transit short name: ${step.transit!.tripShortName}');
                  print('Departure stop: ${step.transit!.departureStop?.name}');
                  print('Arrival stop: ${step.transit!.arrivalStop?.name}');
                  print('Number of stops: ${step.transit!.numStops}');
                  print('Headway: ${step.transit!.headway}');
                  if (step.transit!.line != null) {
                    print('Transit line name: ${step.transit!.line!.name}, Short name: ${step.transit!.line!.shortName}');
                  }
                }
              }
            }
             
            if (totalPathStepCount > 0) {
              routingResult = response; // Confirm routing is a success
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
      endLocationStream();
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
    desiredBearing.value = Geolocator.bearingBetween(position.latitude, position.longitude, 1.338148121952961, 103.96811479790857);
  }
}
