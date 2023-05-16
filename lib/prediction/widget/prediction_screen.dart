// ignore_for_file: unused_field, unused_element, unused_import, prefer_final_fields, avoid_print

import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../classifier/classifier_category.dart';
// import '../classifier/get_sensors_data.dart';
import 'package:flutter/material.dart';
import '../classifier/classifier.dart';
import 'dart:typed_data';
import 'dart:io';

const _labelsFileName = 'labels.txt';
const _modelFileName = 'simple_ffnn_model.tflite';

class ActivitiesRecognizer extends StatefulWidget {
  const ActivitiesRecognizer({super.key});

  @override
  State<ActivitiesRecognizer> createState() => _ActivitiesRecognizerState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _ActivitiesRecognizerState extends State<ActivitiesRecognizer> {
  final bool _isAnalysing = false;

  // Being reworked
  // List<List<Float64List>> sensorData = getSensorsData();

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
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
              'Accuracy: $_accuracy',
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
