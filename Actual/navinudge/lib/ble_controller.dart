import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBluePlus ble = FlutterBluePlus();
  var scanResults = <ScanResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    FlutterBluePlus.scanResults.listen((results) {
      scanResults.value = results;
    });
  }

  Future<void> scanDevices() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      FlutterBluePlus.startScan(timeout: Duration(seconds: 15));
    } else {
      Get.snackbar("Permission Denied", "Bluetooth and Location permissions are required to scan for devices.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(timeout: Duration(seconds: 15));
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.connected) {
          print("Device connected: ${device.platformName}");
        } else {
          print("Device disconnected: ${device.platformName}");
        }
      });
    } catch (e) {
      print("Failed to connect: $e");
    }
  }
}