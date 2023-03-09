import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;

  @override
  void initState() {
    super.initState();
    _accelerometerValues = <double>[0, 0, 0];
    _gyroscopeValues = <double>[0, 0, 0];
    _activateSensors();
  }

  @override
  void dispose() {
    super.dispose();
    _deactivateSensors();
  }

  void _activateSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    });
  }

  void _deactivateSensors() {
    accelerometerEvents.drain();
    gyroscopeEvents.drain();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sensor Data'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accelerometer:'),
            Text('x: ${_accelerometerValues?[0] ?? 'N/A'}'),
            Text('y: ${_accelerometerValues?[1] ?? 'N/A'}'),
            Text('z: ${_accelerometerValues?[2] ?? 'N/A'}'),
            SizedBox(height: 20),
            Text('Gyroscope:'),
            Text('x: ${_gyroscopeValues?[0] ?? 'N/A'}'),
            Text('y: ${_gyroscopeValues?[1] ?? 'N/A'}'),
            Text('z: ${_gyroscopeValues?[2] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
