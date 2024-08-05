import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as platform_interface; 

class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  geolocator.Position? _currentPosition;
  String _currentAddress = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, open settings
      await geolocator.Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    geolocator.Geolocator.getPositionStream(
      locationSettings: geolocator.LocationSettings(
        accuracy: platform_interface.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((geolocator.Position position) {
      setState(() {
        _currentPosition = position;
        _currentAddress =
            'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Get User Location"), 
        centerTitle: true,
      ), 
      body: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Location Coordinates: $_currentAddress", 
          style: TextStyle(fontSize: 24,
          fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height:6,
        ), 
        SizedBox(
          height: 30.0, 
        ), 
        Text("Location Address", 
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold, 
          ),
        ), 
        SizedBox(
          height:6, 
        ), 
        Text("Address"), 
        SizedBox(
          height:50.0, 
        ),
        ElevatedButton(
          onPressed:() async {
            setState(() {});
            print("Latitude: ${_currentPosition?.latitude} Longitude: ${_currentPosition?.longitude} ");
          }, child: null,),     
      ],
        )), 
    );
   }
  }
