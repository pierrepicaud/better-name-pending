// ignore_for_file: unused_element

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;
StreamSubscription<UserAccelerometerEvent>? userAccelerometerSubscription;

// Sampling
final sampling = <Float64List>[];

List<List<Float64List>> wrapList(List<Float64List> data) {
  return [data];
}

void dispose() {
  accelerometerSubscription?.cancel();
  gyroscopeSubscription?.cancel();
  userAccelerometerSubscription?.cancel();
}

void addSignals(List<double> data, int offset) {
  final signals = Float64List(9);
  signals[0 + offset] = data[0];
  signals[1 + offset] = data[1];
  signals[2 + offset] = data[2];
  sampling.add(signals);
}

List<List<Float64List>> getSensorsData() {
  while (sampling.length < 128) {
    accelerometerSubscription = accelerometerEvents.listen((event) {
      addSignals([event.x, event.y, event.z], 0);
    });

    userAccelerometerSubscription = userAccelerometerEvents.listen((event) {
      addSignals([event.x, event.y, event.z], 3);
    });

    gyroscopeSubscription = gyroscopeEvents.listen((event) {
      addSignals([event.x, event.y, event.z], 6);
    });
  }
  // debugPrint('The length of the list is ${sampling.length}');
  return wrapList(sampling);
}
