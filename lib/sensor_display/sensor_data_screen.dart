import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
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
    return Scaffold(
      // appBar: AppBar(
      // title: Text('Sensor Data'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Accelerometer',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSensorValue('X', _accelerometerValues?[0]),
                      const SizedBox(width: 20),
                      _buildSensorValue('Y', _accelerometerValues?[1]),
                      const SizedBox(width: 20),
                      _buildSensorValue('Z', _accelerometerValues?[2]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Gyroscope',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSensorValue('X', _gyroscopeValues?[0]),
                      const SizedBox(width: 20),
                      _buildSensorValue('Y', _gyroscopeValues?[1]),
                      const SizedBox(width: 20),
                      _buildSensorValue('Z', _gyroscopeValues?[2]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorValue(String label, double? value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          value?.toStringAsFixed(2) ?? 'N/A',
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
