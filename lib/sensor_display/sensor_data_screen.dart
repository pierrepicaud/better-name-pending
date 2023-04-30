import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:sensors_plus/sensors_plus.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({Key? key}) : super(key: key);

  @override
  _SignalsScreenState createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  // Sampling
  final sampling = <Float64List>[];

  StreamSubscription<AccelerometerEvent>? accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;
  StreamSubscription<UserAccelerometerEvent>? userAccelerometerSubscription;

  void addSignals(List<double> data, int offset) {
    final signals = Float64List(9);
    signals[0 + offset] = data[0];
    signals[1 + offset] = data[1];
    signals[2 + offset] = data[2];
    sampling.add(signals);
    setState(() {}); // Update the UI when new signals are added
  }

  void activateSensors() {
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
  }

  @override
  void initState() {
    super.initState();
    activateSensors();
  }

  @override
  void dispose() {
    accelerometerSubscription?.cancel();
    gyroscopeSubscription?.cancel();
    userAccelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sampling.length,
          itemBuilder: (BuildContext context, int index) {
            final signals = sampling[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Signal #$index',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Acc X: ${signals[0]}'),
                    Text('Acc Y: ${signals[1]}'),
                    Text('Acc Z: ${signals[2]}'),
                    Text('User Acc X: ${signals[3]}'),
                    Text('User Acc Y: ${signals[4]}'),
                    Text('User Acc Z: ${signals[5]}'),
                    Text('Gyro X: ${signals[6]}'),
                    Text('Gyro Y: ${signals[7]}'),
                    Text('Gyro Z: ${signals[8]}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
