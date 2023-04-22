import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

// Define window parameters
final double windowDuration = 2.56; // Window duration in seconds
final double overlapRatio = 0.5; // Overlap ratio (50% overlap)
final int readingsPerWindow = 128; // Number of readings per window

class SensorSegmentScreen extends StatefulWidget {
  @override
  _SensorSegmentScreenState createState() => _SensorSegmentScreenState();
}

class _SensorSegmentScreenState extends State<SensorSegmentScreen> {
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<List<double>> windowedAccelerometerValues = [];
  List<List<double>> windowedGyroscopeValues = [];
  int windowStartIndex = 0;

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

        // Add readings to the windowed values list
        windowedAccelerometerValues.add(_accelerometerValues!);

        // Check if the window is complete
        if (windowedAccelerometerValues.length == readingsPerWindow) {
          // Process the windowed data (e.g., store it in a variable)
          List<List<double>> windowedData =
              windowedAccelerometerValues.sublist(windowStartIndex);
          // Perform desired operations on the windowed data (e.g., store in a variable)

          // Update the window start index for the next window
          windowStartIndex += (readingsPerWindow * (1 - overlapRatio)).round();
          // Remove the overlapped data
          windowedAccelerometerValues =
              windowedAccelerometerValues.sublist(windowStartIndex);
        }
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];

        // Add readings to the windowed values list
        windowedGyroscopeValues.add(_gyroscopeValues!);

        // Check if the window is complete
        if (windowedGyroscopeValues.length == readingsPerWindow) {
          // Process the windowed data (e.g., store it in a variable)
          List<List<double>> windowedData =
              windowedGyroscopeValues.sublist(windowStartIndex);
          // Perform desired operations on the windowed data (e.g., store in a variable)

          // Update the window start index for the next window
          windowStartIndex += (readingsPerWindow * (1 - overlapRatio)).round();
          // Remove the overlapped data
          windowedGyroscopeValues =
              windowedGyroscopeValues.sublist(windowStartIndex);
        }
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
      appBar: AppBar(
        title: Text('Sensor Segment Data'),
      ),
      body: Column(
        children: [
          Text('Accelerometer Values: $_accelerometerValues'),
          Text('Gyroscope Values: $_gyroscopeValues'),
          Text('Windowed Accelerometer Values: $windowedAccelerometerValues'),
          Text('Windowed Gyroscope Values: $windowedGyroscopeValues'),
        ],
      ),
    );
  }
}
