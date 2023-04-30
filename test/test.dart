import 'dart:async';
import 'dart:typed_data';
import 'package:sensors_plus/sensors_plus.dart';

void main() async {
  // Sampling
  final sampling = <Float64List>[];

  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;
  StreamSubscription<UserAccelerometerEvent>? userAccelerometerSubscription;

  void addSignals(List<double> data) {
    final signals = Float64List(9);
    signals[0] = data[0];
    signals[1] = data[1];
    signals[2] = data[2];
    sampling.add(signals);
  }

  void activateSensors() {
    accelerometerSubscription = accelerometerEvents.listen((event) {
      addSignals([event.x, event.y, event.z]);
    });

    userAccelerometerSubscription = userAccelerometerEvents.listen((event) {
      addSignals([event.x, event.y, event.z]);
    });

    gyroscopeSubscription = gyroscopeEvents.listen((event) {
      addSignals([event.x, event.y, event.z]);
    });
  }

  activateSensors();

  while (sampling.length < 128) {
    await Future.delayed(const Duration(milliseconds: 10));
  }

  accelerometerSubscription?.cancel();
  gyroscopeSubscription?.cancel();
  userAccelerometerSubscription?.cancel();
}
