// ignore_for_file: unused_field, unused_element, unused_import, prefer_final_fields

import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../classifier/classifier.dart';
import '../get_sensors_data.dart';

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = 'assets/model_lstm.tflite';

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

  List<List<Float64List>> sensorData = getSensorsData();

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
