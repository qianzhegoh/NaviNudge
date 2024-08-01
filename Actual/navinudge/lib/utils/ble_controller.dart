import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBluePlus ble = FlutterBluePlus();
  var scanResults = <ScanResult>[].obs;
  BluetoothDevice? leftNode;
  BluetoothDevice? rightNode;

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
      FlutterBluePlus.startScan(withNames:["NaviNudge Node Left", "NaviNudge Node Right", "NaviNudge Node"], timeout: Duration(seconds: 15));
    } else {
      Get.snackbar("Permission Denied", "Bluetooth and Location permissions are required to scan for devices.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  // This method is called by a GUI menu to connect to the Device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(timeout: Duration(seconds: 15));
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.connected) {
          print("Device connected: ${device.platformName}");
          if (device.advName.contains("Left")) {
            leftNode = device;
          } else if (device.advName.contains("Right")) {
            rightNode = device;
          }
          
          // Once device is connected, open up the "firehose" stream
        } else {
          print("Device disconnected: ${device.platformName}");
          leftNode = null;
        }
      });
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

  Future<void> readCharacteristic(BluetoothDevice device, Guid characteristicId) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          List<int> value = await characteristic.read();
          print('Read value: $value');
        }
      }
    }
  }

  Future<void> writeCharacteristic(BluetoothDevice device, Guid characteristicId, List<int> data) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          await characteristic.write(data);
          print('Data written successfully.');
        }
      }
    }
  }

  // void enableIMULeft() {
  //   if (leftNode != null) {
  //     // Start the device's IMU data "firehose" by switching characteristic 0x2A3F (mode) to 2
  //   }
  // }
}