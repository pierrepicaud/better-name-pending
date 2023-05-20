import 'dart:async';
import './helper.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsData {
  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;
  StreamSubscription<UserAccelerometerEvent>? userAccelerometerSubscription;

  late List<double>? _accelerometerValues;
  late List<double>? _gyroscopeValues;
  late List<double>? _userAccelerometerValues;

  final List<List<double>?> _recordedAccelerometerValues = [];
  final List<List<double>?> _recordedUserAccelerometerValues = [];
  final List<List<double>?> _recoreddGyroscopeValues = [];
  List<List<double>>? sensorData;

  SensorsData();

  Future<void> init() async {
    sensorData = await getData();
  }

  void dispose() {
    accelerometerSubscription?.cancel();
    userAccelerometerSubscription?.cancel();
    gyroscopeSubscription?.cancel();
  }

  Future<List<List<double>>> getData() async {
    // Your async operation here.
    accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometerValues = <double>[event.x, event.y, event.z];
      _recordedAccelerometerValues.add(_accelerometerValues);
      if (_recordedAccelerometerValues.length >= 64) {
        accelerometerSubscription?.cancel();
      }
    });

    userAccelerometerSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _userAccelerometerValues = <double>[event.x, event.y, event.z];
      _recordedUserAccelerometerValues.add(_userAccelerometerValues);
      if (_recordedUserAccelerometerValues.length >= 64) {
        userAccelerometerSubscription?.cancel();
      }
    });

    int count = 0;
    gyroscopeSubscription = gyroscopeEvents.listen((event) {
      count++;
      if (count % 2 == 0) {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
        _recoreddGyroscopeValues.add(_gyroscopeValues);
      }
      if (_recordedUserAccelerometerValues.length < 128) {
        gyroscopeSubscription?.cancel();
      }
    });

    var splAcc = splitList(_recordedAccelerometerValues);
    var splUser = splitList(_recordedUserAccelerometerValues);
    var splGyro = splitList(_recoreddGyroscopeValues);

    var interpolatedSplAcc = splAcc.map((list) => interpolate(list)).toList();
    var interpolatedSplUser = splUser.map((list) => interpolate(list)).toList();

    sensorData =
        dataWrangling(interpolatedSplAcc, interpolatedSplUser, splGyro);

    // Check if sensorData is null, if so, throw an exception or return an empty list
    if (sensorData == null) {
      throw Exception("Failed to get sensor data");
    }

    return sensorData!;
  }
}
