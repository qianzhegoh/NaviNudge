import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/ble_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothSetup extends StatefulWidget {
  const BluetoothSetup({super.key});

  @override
  State<BluetoothSetup> createState() => _BluetoothSetupState();
}

class _BluetoothSetupState extends State<BluetoothSetup> {
  final BleController bleController = Get.put(BleController(), permanent: true);

  Future<void> _requestPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      // Permissions are granted
    } else {
      Get.snackbar("Permission Denied", "Bluetooth and Location permissions are required to scan for devices.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Debug")),
      body: GetBuilder<BleController>(
        init: bleController,
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (controller.scanResults.isEmpty) {
                    return Center(child: Text("No Device Found"));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.scanResults.length,
                        itemBuilder: (context, index) {
                          final data = controller.scanResults[index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(data.device.platformName),
                              subtitle: Text(data.device.remoteId.toString()),
                              trailing: Text(data.rssi.toString()),
                              onTap: () {
                                controller.connectToDevice(data.device);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DebugIMUData()));
                                },
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _requestPermissions();
                    controller.scanDevices();
                  },
                  child: Text("Scan for NaviNudge Devices"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DebugIMUData extends StatelessWidget {
  final BleController bleController = Get.put(BleController(), permanent: true);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Device Debug Screen'),
        ),
      body:
        Obx(() {
          if (bleController.leftConnected.value == false) {
            return Text('No device connected');
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(child: Text('Left node quality: ${bleController.leftQuality.value}')),
                  Center(child: Text('Right node quality: ${bleController.rightQuality.value}')),
                  Center(child: Text('Within desired positions: ${bleController.acceptableGait.value}')),
                  Center(child: Text('Computed angle difference: ${bleController.quaternionDifferenceAngles.value}')),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        bleController.readMode();
                        bleController.enableIMUBoth();
                      },
                      child: Text('Turn on both IMUs'),
                    ),
                  ),
                ],
              ),
            );
          }
        })
    );
  }
}
