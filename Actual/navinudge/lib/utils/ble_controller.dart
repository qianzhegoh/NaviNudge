import 'dart:convert';
import 'dart:math';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math.dart';

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
  var leftQuality = 0.obs; // Quality describes the quality of the positioning data given by the IMU. 0 is worst and 3 is best.
  var rightQuality = 0.obs;
  // var leftQuaternion = <double>[].obs; // The format for position quaternions are: Quality of signal, Real, i, j ,k
  // var rightQuaternion = <double>[].obs;
  var leftQuaternion = Quaternion(0, 0, 0, 1).obs; // The format for position quaternions is: i, j ,k, real
  var rightQuaternion = Quaternion(0, 0, 0, 1).obs;
  var quaternionDifference = Quaternion(0, 0, 0, 1).obs;
  var quaternionDifferenceAngles = [0.0,0.0,0.0].obs; // The format is yaw, pitch, roll
  var acceptableGait = false.obs; // When the gait is acceptable for a bearing reading
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
            leftQuality.value = -1;
            leftMode.value = -1;
            leftQuaternion.value.setValues(0, 0, 0, 1);
          } else if (device.advName.contains("Right")) {
            _rightNode = null;
            _rightNodeIMU = null;
            rightConnected.value = false;
            rightQuality.value = -1;
            rightMode.value = -1;
            rightQuaternion.value.setValues(0, 0, 0, 1);
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

  Future<void> readMode() async {
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

  List<double> quaternionToEuler(Quaternion q, bool degrees) {
    final qr = q.w; final qi = q.x; final qj = q.y; final qk = q.z;
    final sqr = pow(qr,2);
    final sqi = pow(qi,2);
    final sqj = pow(qj,2);
    final sqk = pow(qk,2);

    var returnValue = [0.0,0.0,0.0];

    if (degrees) {
      returnValue = [
        atan2(2.0 * (qi * qj + qk * qr), (sqi - sqj - sqk + sqr)) * radians2Degrees,
        asin(-2.0 * (qi * qk - qj * qr) / (sqi + sqj + sqk + sqr)) * radians2Degrees,
        atan2(2.0 * (qj * qk + qi * qr), (-sqi - sqj + sqk + sqr)) * radians2Degrees
      ];
    } else {
      returnValue = [
        atan2(2.0 * (qi * qj + qk * qr), (sqi - sqj - sqk + sqr)),
        asin(-2.0 * (qi * qk - qj * qr) / (sqi + sqj + sqk + sqr)),
        atan2(2.0 * (qj * qk + qi * qr), (-sqi - sqj + sqk + sqr))
      ];
    }
    quaternionDifferenceAngles.value = returnValue;
    return returnValue;
  }

  void computeQuaternionDiff(Quaternion q1, Quaternion q2) {
    quaternionDifference.value.setFrom(q1 * q2.conjugated());
    final anglesArray = quaternionToEuler(quaternionDifference.value, true);
    acceptableGait.value = (anglesArray[0] > 130 || anglesArray[0] < -130) && (anglesArray[1] > -25 || anglesArray[1] < 25) && (anglesArray[2] > -25 || anglesArray[2] < 25);
  }

  Future<void> enableIMUBoth() async {
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
            leftQuality.value = arrayValues[0]!.toInt();
            leftQuaternion.value.setValues(arrayValues[2]!, arrayValues[3]!, arrayValues[4]!, arrayValues[1]!);
          } else {
            print("BLE transmission fault! IMU data is not 5 segments");
          }
        } catch (e) {
          print("BLE transmission fault! Unable to decode IMU data: $e");
        }

        // Another opportunity here at (onValueReceived) is to compute the difference every time the left side receives a computation
        if (leftQuaternion.value != Quaternion(0, 0, 0, 1) && rightQuaternion.value != Quaternion(0, 0, 0, 1)) {
          computeQuaternionDiff(leftQuaternion.value, rightQuaternion.value);
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
            rightQuality.value = arrayValues[0]!.toInt();
            // = Quaternion(arrayValues[2]!, arrayValues[3]!, arrayValues[4]!, arrayValues[1]!)
            rightQuaternion.value.setValues(arrayValues[2]!, arrayValues[3]!, arrayValues[4]!, arrayValues[1]!);
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