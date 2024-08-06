import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/ble_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'homepage_screen.dart';

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
      Get.snackbar("Permission Denied",
          "Bluetooth and Location permissions are required to scan for devices.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect NaviNudge"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                if (bleController.leftConnected.value &&
                    bleController.rightConnected.value) {
                } else {
                  final snackBar = SnackBar(content: const Text('NaviNudge devices not connected!'),);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
              },
              icon: Icon(
                Icons.arrow_forward,
              ))
        ],
      ),
      body: GetBuilder<BleController>(
        init: bleController,
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (controller.scanResults.isEmpty) {
                    return Center(
                        child: Text("No Device Found",
                            style: TextStyle(fontSize: 20)));
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
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await _requestPermissions();
            bleController.scanDevices();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh')),
    );
  }
}
