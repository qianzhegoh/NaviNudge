import 'dart:ffi';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  // Constants
  final modeGUID = Guid.fromString("2A3F");
  final posGUID = Guid.fromString("2A30");
  final currentBearingGUID = Guid.fromString("2A5D");
  final futureBearingGUID = Guid.fromString("2A68");

  // Observable variables
  var scanResults = <ScanResult>[].obs;
  var leftConnected = false.obs;
  var rightConnected = false.obs;
  var leftQuaternion = <Float>[].obs;
  var rightQuaternion = <Float>[].obs;
  var leftMode = (-1).obs;
  var rightMode = (-1).obs;

  // Private variables
  BluetoothDevice? _leftNode;
  BluetoothDevice? _rightNode;

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
  // When the connection is called, each device gets its own connection state listener, which will mutate the variables in this class based on connection state
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(timeout: Duration(seconds: 15));
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.connected) {
          print("Device connected: ${device.platformName}");
          if (device.advName.contains("Left")) {
            _leftNode = device;
            leftConnected.value = true;
          } else if (device.advName.contains("Right")) {
            _rightNode = device;
            rightConnected.value = true;
          }
          // Once device is connected, read the full list of services and characteristics
        } else {
          if (device.advName.contains("Left")) {
            _leftNode = null;
            leftConnected.value = false;
          } else if (device.advName.contains("Right")) {
            _rightNode = null;
            rightConnected.value = false;
          }
          print("Device disconnected: ${device.platformName}");
        }
      });
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

  Future<List<int>?> _readCharacteristic(BluetoothDevice device, Guid characteristicId) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          List<int> value = await characteristic.read();
          return value;
        }
      }
    }
    return null;
  }

  Future<void> _writeCharacteristic(BluetoothDevice device, Guid characteristicId, List<int> data) async {
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

  void readMode() async {
    if (_leftNode != null) {
      final modeVal = (await _readCharacteristic(_leftNode!, modeGUID));
      if (modeVal != null) {
        leftMode.value = modeVal[0];
      }
    }
    if (_rightNode != null) {
      final modeVal = (await _readCharacteristic(_rightNode!, modeGUID));
      if (modeVal != null) {
        rightMode.value = modeVal[0];
      }
    }
  }

  void enableIMULeft() async {
    if (_leftNode != null) {
      // Start the device's IMU data "firehose" by switching characteristic 0x2A3F (mode) to 2
      _writeCharacteristic(_leftNode!, modeGUID, [2]);
    }
    if (_rightNode != null) {
      // Start the device's IMU data "firehose" by switching characteristic 0x2A3F (mode) to 2
      _writeCharacteristic(_rightNode!, modeGUID, [2]);
    }
  }
}