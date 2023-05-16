// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../prediction/classifier/sensors_data.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _userAccelerometerValues;

  List<AccelerometerEvent> recordedAccelerometerEvent = [];
  List<UserAccelerometerEvent> recordedUserAccelerometerEvent = [];
  List<GyroscopeEvent> recoreddGyroscopeEvent = [];

  late double accelerometerSamplingRate;
  late double userAccelerometerSamplingRate;
  late double gyroscopeSamplingRate;

  bool thereIsStillTime = false;

  @override
  void initState() {
    super.initState();
    _accelerometerValues = <double>[0, 0, 0];
    _gyroscopeValues = <double>[0, 0, 0];
    _userAccelerometerValues = <double>[0, 0, 0];
    accelerometerSamplingRate = 0;
    userAccelerometerSamplingRate = 0;
    gyroscopeSamplingRate = 0;
    _activateSensors();
  }

  @override
  void dispose() {
    super.dispose();
    _deactivateSensors();
    _updateSamplingRate();
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

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    });
  }

  void _deactivateSensors() {
    accelerometerEvents.drain();
    gyroscopeEvents.drain();
  }

  double calculateSamplingRate(int numberOfSamples, int timeInMilliseconds) {
    double timeInSeconds = timeInMilliseconds / 1000.0;
    return numberOfSamples / timeInSeconds;
  }

  void _updateSamplingRate() {
    countDown();
    while (thereIsStillTime) {
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

    setState(() {
      accelerometerSamplingRate =
          calculateSamplingRate(recordedAccelerometerEvent.length, 2560);
    });
    setState(() {
      userAccelerometerSamplingRate =
          calculateSamplingRate(recordedUserAccelerometerEvent.length, 2560);
    });
    setState(() {
      gyroscopeSamplingRate =
          calculateSamplingRate(recoreddGyroscopeEvent.length, 2560);
    });
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
                      _buildSensorValue('X', _userAccelerometerValues?[0]),
                      const SizedBox(width: 20),
                      _buildSensorValue('Y', _userAccelerometerValues?[1]),
                      const SizedBox(width: 20),
                      _buildSensorValue('Z', _userAccelerometerValues?[2]),
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
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sampling Rates',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSensorValue('Acc', accelerometerSamplingRate),
                      const SizedBox(width: 20),
                      _buildSensorValue(
                          'UserAcc', userAccelerometerSamplingRate),
                      const SizedBox(width: 20),
                      _buildSensorValue('Gyro', gyroscopeSamplingRate),
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
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          value?.toStringAsFixed(2) ?? 'N/A',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
