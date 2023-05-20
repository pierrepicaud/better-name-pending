// ignore_for_file: unused_field, unused_element, prefer_final_fields, avoid_print, use_function_type_syntax_for_parameters

// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:typed_data';
// import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../classifier/classifier_category.dart';
import 'package:flutter/material.dart';
import '../classifier/classifier.dart';
import '../sensor_data/data.dart';

class ActivitiesRecognizer extends StatefulWidget {
  const ActivitiesRecognizer({super.key});

  @override
  State<ActivitiesRecognizer> createState() => _ActivitiesRecognizerState();
}

class _ActivitiesRecognizerState extends State<ActivitiesRecognizer> {
  
  late Classifier _classifier;
  String dummyText = 'WIP';

  // late SensorData sensorData;
  List<List<double>>? sensorDataValues;
  var sensorsDataInstance = SensorsData();

  @override
  void initState() {
    super.initState();
    sensorsDataInstance.init().then((_) {
      // Your sensor data is ready here.
      sensorDataValues = sensorsDataInstance.sensorData;
      print(sensorDataValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'Accuracy: $dummyText',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
