import 'package:flutter/material.dart';
import '../utils/navigation_controller.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as platform_interface;

class LocationTracker extends StatelessWidget {
  final NavigationController navController =
      Get.put(NavigationController(), permanent: true);

  // geolocator.Position? _currentPosition;
  // String _currentAddress = 'Fetching location...';

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get User Location"),
        centerTitle: true,
      ),
      body: Obx(() {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Current coordinates: ${navController.currentCoordinates}\nGPS accuracy: ${navController.gpsAccuracy}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Desired bearing: ${navController.desiredBearing}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text("Address"),
                SizedBox(
                  height: 50.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await navController.startLocationStream();
                    await Future.delayed(const Duration(seconds: 3));
                    navController.beginRouting("730612");
                  },
                  child: Text("Start location updates"),
                ),
              ],
            ));
          }),
    );
  }
}
