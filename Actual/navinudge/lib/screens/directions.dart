import 'package:flutter/material.dart';
import '../utils/navigation_controller.dart';
import '../utils/ble_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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
        if (bleController.leftQuality.value < 2 || bleController.rightQuality.value < 2) {
          return Center(child: Text('Please swing your arms in all directions before starting your journey to calibrate the compass.\n Left device compass accuracy: ${bleController.leftQuality.value}.\nRight device compass accuracy: ${bleController.rightQuality.value}'));
        }
        if (bleController.currentBearing.value != 0) {
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
  }

  @override
  void dispose() {
    navController.endRouting();
    super.dispose();
  }
}
