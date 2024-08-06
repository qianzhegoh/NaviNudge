import 'package:flutter/material.dart';
import '../utils/navigation_controller.dart';
import '../utils/ble_controller.dart';
import 'package:get/get.dart';
import 'package:geofence_service/geofence_service.dart';

//QZ: I am not too sure how to integrate the steps (which part of the journey, wether if its bus mode or walking mode).
//Hence, I have created 3 different screens instead.

// Note: by the time this screen fires, the destination picker should have picked by the previous view and sent to this screen
// for now, this is hardcoded

class Directions extends StatefulWidget {
  @override
  State<Directions> createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  final NavigationController navController = Get.put(NavigationController(), permanent: true);
  final BleController bleController = Get.put(BleController(), permanent: true);
  // Create a [GeofenceService] instance and set options.
  final _geofenceService = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: true,
      allowMockLocations: true,
      printDevLog: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);


  final _geofenceList = <Geofence>[
    Geofence(
      id: 'place_1',
      latitude: 35.103422,
      longitude: 129.036023,
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
    Geofence(
      id: 'place_2',
      latitude: 35.104971,
      longitude: 129.034851,
      radius: [
        GeofenceRadius(id: 'radius_100m', length: 100),
      ],
    ),
  ];

  // This function is to be called when the geofence status is changed.
// Future<void> _onGeofenceStatusChanged(
//       Geofence geofence,
//       GeofenceRadius geofenceRadius,
//       GeofenceStatus geofenceStatus,
//       Location location) async {
//     print('geofence: ${geofence.toJson()}');
//     print('geofenceRadius: ${geofenceRadius.toJson()}');
//     print('geofenceStatus: ${geofenceStatus.toString()}');
//     _geofenceStreamController.sink.add(geofence);
//   }

//   // This function is to be called when the activity has changed.
//   void _onActivityChanged(Activity prevActivity, Activity currActivity) {
//     print('prevActivity: ${prevActivity.toJson()}');
//     print('currActivity: ${currActivity.toJson()}');
//     _activityStreamController.sink.add(currActivity);
//   }

//   // This function is to be called when the location has changed.
//   void _onLocationChanged(Location location) {
//     print('location: ${location.toJson()}');
//   }

//   // This function is to be called when a location services status change occurs
//   // since the service was started.
//   void _onLocationServicesStatusChanged(bool status) {
//     print('isLocationServicesEnabled: $status');
//   }

//   // This function is used to handle errors that occur in the service.
//   void _onError(error) {
//     final errorCode = getErrorCodesFromError(error);
//     if (errorCode == null) {
//       print('Undefined error: $error');
//       return;
//     }
    
//     print('ErrorCode: $errorCode');
//   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions'),
        centerTitle: true,
      ),
      body: Obx(() {        
        if (bleController.leftConnected.value == false || bleController.rightConnected.value == false) {
          return Center(child: Text('Please connect to both devices before beginning your journey.\n Left device connected: ${bleController.leftConnected.value}.\nRight device connected: ${bleController.rightConnected.value}'));
        }
        bleController.readMode();
        if (navController.imageURL.value.contains('bus') && bleController.leftMode.value == 2) {
          // Disable at the public transport step
          bleController.disableIMUBoth();
        } else if (navController.imageURL.value.contains('walk') && bleController.leftMode.value != 2) {
          // Reenable at the walking directions step
          bleController.enableIMUBoth();
        }
        if (bleController.leftQuality.value < 2 || bleController.rightQuality.value < 2) {
          return Center(child: Text('Please swing your arms in all directions before starting your journey to calibrate the compass.\n Left device compass accuracy: ${bleController.leftQuality.value}.\nRight device compass accuracy: ${bleController.rightQuality.value}'));
        }
        if (bleController.currentBearing.value != 0 && navController.imageURL.value.contains('walking')) {
          bleController.writeFutureBearing(navController.desiredBearing.value);
        }
        
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('${navController.imageURL}'),
            ),
            SizedBox(height: 20),
            Text(
              '${navController.userReadableInstructions}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  navController.advancePath();
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => DirectionsBus()));
                },
                child: Text(
                    'Debug info:\nOn route: ${navController.onRoute}\nCurrent coordinates: ${navController.currentCoordinates}\nTarget coordinates: ${navController.futureCoordinates}\nBearing to walk towards: ${navController.desiredBearing}\nCurrent bearing: ${bleController.currentBearing.value}\nGPS accuracy: ${navController.gpsAccuracy}\nCurrent path step: ${navController.currentPathStep}\nTotal steps: ${navController.totalPathStepCount}\nWithin desired positions: ${bleController.acceptableGait.value}\n',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                    ))),
          ],
        ));
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    bleController.enableIMUBoth();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    //   _geofenceService.addLocationChangeListener(_onLocationChanged);
    //   _geofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
    //   _geofenceService.addActivityChangeListener(_onActivityChanged);
    //   _geofenceService.addStreamErrorListener(_onError);
    //   _geofenceService.start(_geofenceList).catchError(_onError);
    // });
  }

  @override
  void dispose() {
    bleController.disableIMUBoth();
    navController.endRouting();
    super.dispose();
  }
}
