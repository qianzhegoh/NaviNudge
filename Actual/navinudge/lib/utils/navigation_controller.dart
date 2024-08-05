import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import '../strings.dart';

class NavigationController extends GetxController {
  // Private variables
  Position? _currentPosition; // NOTE: this object also bundles position accuracy inside
  
  var _originLocation = '';
  var _destinationLocation = ''; //NOTE: do we just encode locations as strings?
  DirectionsService? directionsService;
  DirectionsResult? directionsResult;

  // Observable variables
  var locationServiceActive = false.obs; // This shows whether the location service is current receiving GPS coordinate updates. This is NOT the same as whether location services are enabled
  var gpsAccuracy = (0.0).obs; // The radius of position estimate
  var currentCoordinates = [0.0,0.0].obs; // Lat, Lon
  var futureCoordinates = [0.0,0.0].obs;
  var desiredBearing = 0.0.obs; // This is the desired bearing to the target, from our current location

  @override
  void onInit() {
    super.onInit();
    // Start the location controller over here
    DirectionsService.init(apiKey);
    directionsService = DirectionsService();
  }

  Future<void> startLocationStream() async {
    LocationPermission permission;

    // Test if location services are enabled.
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      // Location services are not enabled, open settings
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
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
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(locationUpdatedListener);
  }

  // TODO: turn all those prints into actual error throws so whoever calls this function can be informed about the errors
  void beginRouting(String destination) {
    if (locationServiceActive.value) {
      final request = DirectionsRequest(
        origin: _originLocation,
        destination: destination,
        travelMode: TravelMode.transit,
      );
      directionsService!.route(request, (DirectionsResult response, DirectionsStatus? status) {
        if (status == DirectionsStatus.ok) {
          // do something with successful response
          if (response.routes != null) {
            directionsResult = response;
            if (response.routes!.isNotEmpty) {
              print("Successful routing: $response");
            } else {
              print("Error in routing! Error message: Route is null");
            }
          } else {
            print("Error in routing! Error message: No routes available");
          }
        } else {
          // do something with error response
          print("Error in routing! Error message: $response");
        }
      });
    } else {
      print("Location service not active!! Routing cannot proceed");
    }
  }

  void locationUpdatedListener(Position position) {
    _currentPosition = position;
    _originLocation = "${position.latitude},${position.longitude}";
    gpsAccuracy.value = position.accuracy;
    currentCoordinates.value = [position.latitude, position.longitude];
    if (!locationServiceActive.value) {
      locationServiceActive.value = true;
    }
    //TODO: further processing to be done here to retrieve bearing
    // Current positon can be fed into a bearing calculation algo
    desiredBearing.value = Geolocator.bearingBetween(position.latitude, position.longitude, 1.338148121952961, 103.96811479790857);
    // update();
    print("Current location: $_originLocation");
    print("Desired bearing: ${desiredBearing.value}");
  }
}
