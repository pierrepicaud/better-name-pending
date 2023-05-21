// ignore_for_file: unnecessary_cast

import 'dart:async';
import './helper.dart';
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
    int accSamples = 64; // We'll interpolate it be cause the sensors are slow
    int gyroSamples =
        256; // We'll half it because the sensors are twice as fast

    var accelerometerStream = accelerometerEvents.take(accSamples).toList();
    var userAccelerometerStream =
        userAccelerometerEvents.take(accSamples).toList();

    var gyroscopeStream = gyroscopeEvents.take(gyroSamples).toList();

    var results = await Future.wait(
        [accelerometerStream, userAccelerometerStream, gyroscopeStream]);

    _recordedAccelerometerValues = (results[0] as List)
        .map((event) => <double>[event.x, event.y, event.z])
        .toList();
    _recordedUserAccelerometerValues = (results[1] as List)
        .map((event) => <double>[event.x, event.y, event.z])
        .toList();
    _recoreddGyroscopeValues = (results[2] as List)
        .asMap()
        .entries
        .where((element) => element.key % 2 == 1)
        .map((e) => e.value)
        .toList()
        .map((event) => <double>[event.x, event.y, event.z])
        .toList();

    var splAcc = splitList(_recordedAccelerometerValues);
    var splUser = splitList(_recordedUserAccelerometerValues);
    var splGyro = splitList(_recoreddGyroscopeValues);

    var interpolatedSplAcc = splAcc.map((list) => interpolate(list)).toList();
    var interpolatedSplUser = splUser.map((list) => interpolate(list)).toList();

    // Sanity check
    if (interpolatedSplAcc[0].length != accSamples * 2) {
      throw Exception(
          'Shape of accelerometer samples are not valid: ${interpolatedSplAcc.length} x ${interpolatedSplAcc[0].length}');
    }

    if (interpolatedSplUser[0].length != accSamples * 2) {
      throw Exception(
          'Shape of User Accelerometer samples are not valid: ${interpolatedSplUser.length} x ${interpolatedSplUser[0].length}');
    }

    if (splGyro[0].length != gyroSamples / 2) {
      throw Exception(
          'Shape of gryro samples are not valid: ${splGyro.length} x ${splGyro[0].length}');
    }

    sensorData =
        dataWrangling(interpolatedSplAcc, interpolatedSplUser, splGyro);

    // Check if sensorData is null, if so, throw an exception or return an empty list
    if (sensorData == null) {
      return [];
    }
    return sensorData!;
  }
}
