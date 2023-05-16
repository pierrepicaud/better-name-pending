// ignore_for_file: avoid_print

import 'package:sensors_plus/sensors_plus.dart';

bool thereIsStillTime = false;
List<AccelerometerEvent> recordedAccelerometerEvent = [];
List<UserAccelerometerEvent> recordedUserAccelerometerEvent = [];
List<GyroscopeEvent> recoreddGyroscopeEvent = [];

Future<void> countDown() async {
  print('Countdown started');
  thereIsStillTime = true;
  await Future.delayed(const Duration(milliseconds: 2560));
  thereIsStillTime = false;
  print('Countdown finished');
}

void activateSensors() {
  accelerometerEvents.listen((AccelerometerEvent event) {
    recordedAccelerometerEvent.add(event);
  });
// [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]

  userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    recordedUserAccelerometerEvent.add(event);
  });
// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

  gyroscopeEvents.listen((GyroscopeEvent event) {
    recoreddGyroscopeEvent.add(event);
  });
}

void deactivateSensors() {
  accelerometerEvents.drain();
  userAccelerometerEvents.drain();
  gyroscopeEvents.drain();
}

void dummyFunction() {
  countDown();
  while (thereIsStillTime) {
    activateSensors();
  }
  deactivateSensors();
  print('recordedAccelerometerEvent: ${recordedAccelerometerEvent.length}');
  print(
      'recordedUserAccelerometerEvent: ${recordedUserAccelerometerEvent.length}');
  print('recoreddGyroscopeEvent: ${recoreddGyroscopeEvent.length}');
}

double calculateSamplingRate(int numberOfSamples, [int timeInMilliseconds = 2560]) {
  double timeInSeconds = timeInMilliseconds / 1000.0;
  return numberOfSamples / timeInSeconds;
}
