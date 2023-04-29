// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

void main() async {
  List<List<double>> accelerometerData = [];
  List<List<double>> gyroscopeData = [];

  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;

  void activateSensors() {
    accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      accelerometerData.add([event.x, event.y, event.z]);
    });

    gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      gyroscopeData.add([event.x, event.y, event.z]);
    });
  }

  Future<void> deactivateSensors() async {
    accelerometerSubscription?.cancel();
    gyroscopeSubscription?.cancel();
    await accelerometerEvents.drain();
    await gyroscopeEvents.drain();
  }

  Future<List<List<double>>> sampleSensorSignal(List<List<double>> data, double windowDuration, double overlap) async {
    List<List<double>> windowedData = [];
    int windowSize = (windowDuration * 1000 ~/ (1000 / 64)).ceil(); // 64 readings per second
    int stepSize = (windowSize * (1 - overlap)).floor();
    int startIndex = 0;
    int endIndex = windowSize;
    while (endIndex <= data.length) {
      List<List<double>> window = data.sublist(startIndex, endIndex);
      windowedData.add(window);
      startIndex += stepSize;
      endIndex = startIndex + windowSize;
    }
    return windowedData;
  }

  activateSensors();
  await Future.delayed(Duration(seconds: 5)); // Wait for 5 seconds
  await deactivateSensors();

  List<List<double>> windowedAccelerometerData = await sampleSensorSignal(accelerometerData, 2.56, 0.5);
  List<List<double>> windowedGyroscopeData = await sampleSensorSignal(gyroscopeData, 2.56, 0.5);

  // Use windowedAccelerometerData and windowedGyroscopeData for further processing or passing to your machine learning model
}
