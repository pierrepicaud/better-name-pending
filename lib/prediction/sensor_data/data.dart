// ignore_for_file: unnecessary_cast

import 'dart:async';
import './helper.dart';
import 'package:collection/collection.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsData {
  List<List<double>> _recordedAccelerometerValues = [];
  List<List<double>> _recordedUserAccelerometerValues = [];
  List<List<double>> _recoreddGyroscopeValues = [];
  List<List<double>>? sensorData;

  SensorsData();

  Future<List<List<double>>> init() async {
    return await getData();
  }

  Future<List<List<double>>> getData() async {
    var accelerometerStream = accelerometerEvents.take(64).toList();
    var userAccelerometerStream = userAccelerometerEvents.take(64).toList();

    // TODO: Need to double and drop half
    var gyroscopeStream = gyroscopeEvents.take(256).toList();

    var results = await Future.wait(
        [accelerometerStream, userAccelerometerStream, gyroscopeStream]);


    _recordedAccelerometerValues = (results[0] as List)
        .map((event) => <double>[event.x, event.y, event.z])
        .toList();
    _recordedUserAccelerometerValues = (results[1] as List)
        .map((event) => <double>[event.x, event.y, event.z])
        .toList();
    _recoreddGyroscopeValues = (results[2] as List).asMap()
        .entries.where((element) => element.key % 2 == 1).map((e) => e.value)
        .toList()
        .map((event) => <double>[event.x, event.y, event.z])
        .toList();

    var splAcc = splitList(_recordedAccelerometerValues);
    var splUser = splitList(_recordedUserAccelerometerValues);
    var splGyro = splitList(_recoreddGyroscopeValues);

    var interpolatedSplAcc = splAcc.map((list) => interpolate(list)).toList();
    var interpolatedSplUser = splUser.map((list) => interpolate(list)).toList();

    sensorData =
        dataWrangling(interpolatedSplAcc, interpolatedSplUser, splGyro);

    // Check if sensorData is null, if so, throw an exception or return an empty list
    if (sensorData == null) {
      return [];
    }
    return sensorData!;
  }
}
