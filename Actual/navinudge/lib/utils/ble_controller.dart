import 'dart:convert';

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
  var leftQuaternion = <double>[].obs; // The format for position quaternions are: Quality of signal, Real, i, j ,k
  var rightQuaternion = <double>[].obs;
  var leftMode = (-1).obs;
  var rightMode = (-1).obs;

  // Private variables
  BluetoothDevice? _leftNode;
  BluetoothDevice? _rightNode;
  BluetoothCharacteristic? _leftNodeIMU;
  BluetoothCharacteristic? _rightNodeIMU;

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

  Future<void> storeCharacteristics(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == posGUID) {
          if (device.advName.isCaseInsensitiveContains("Left")) {
            _leftNodeIMU = characteristic;
          } else if (device.advName.isCaseInsensitiveContains("Right")) {
            _rightNodeIMU = characteristic;
          }
        }
      }
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
          // Once device is connected, read the full list of services and characteristics, and store them
          storeCharacteristics(device);
        } else {
          if (device.advName.contains("Left")) {
            _leftNode = null;
            _leftNodeIMU = null;
            leftConnected.value = false;
          } else if (device.advName.contains("Right")) {
            _rightNode = null;
            _rightNodeIMU = null;
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

  void enableIMUBoth() async {
    if (_leftNode != null) {
      // Start the device's IMU data "firehose" by switching characteristic 0x2A3F (mode) to 2
      _writeCharacteristic(_leftNode!, modeGUID, [2]);
      _leftNodeIMU!.onValueReceived.listen((value) {
        final decodedValue = utf8.decode(value).split(',');
        // Reject the value if it does not have 5 segments (just in case the BLE transmission messes up)
        try {
          final Map<int, double> arrayValues = {
            for (int i = 0; i < decodedValue.length; i++)
              i: double.parse(decodedValue[i])
          };
          if (arrayValues.length == 5) {
            leftQuaternion.value = [arrayValues[0]!, arrayValues[1]!, arrayValues[2]!, arrayValues[3]!, arrayValues[4]!];
          } else {
            print("BLE transmission fault! IMU data is not 5 segments");
          }
        } catch (e) {
          print("BLE transmission fault! Unable to decode IMU data: $e");
        }
      });
      await _leftNodeIMU!.setNotifyValue(true);
    }
    if (_rightNode != null) {
      // Start the device's IMU data "firehose" by switching characteristic 0x2A3F (mode) to 2
      _writeCharacteristic(_rightNode!, modeGUID, [2]);
      _rightNodeIMU!.onValueReceived.listen((value) {
        final decodedValue = utf8.decode(value).split(',');
        // Reject the value if it does not have 5 segments (just in case the BLE transmission messes up)
        try {
          final Map<int, double> arrayValues = {
            for (int i = 0; i < decodedValue.length; i++)
              i: double.parse(decodedValue[i])
          };
          if (arrayValues.length == 5) {
            rightQuaternion.value = [arrayValues[0]!, arrayValues[1]!, arrayValues[2]!, arrayValues[3]!, arrayValues[4]!];
          } else {
            print("BLE transmission fault! IMU data is not 5 segments");
          }
        } catch (e) {
          print("BLE transmission fault! Unable to decode IMU data: $e");
        }
      });
      await _rightNodeIMU!.setNotifyValue(true);
    }
  }
}