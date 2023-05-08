// ignore_for_file: unused_field, unused_element, unused_import, prefer_final_fields

import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'package:flutter/material.dart';
import '../get_sensors_data.dart';
// import '../classifier/classifier.dart.old';

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

  List<List<Float64List>> sensorData = getSensorsData();

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  // late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    // debugPrint(
    //   'Start loading of Classifier with '
    //   'labels at $_labelsFileName, '
    //   'model at $_modelFileName',
    // );

    // final classifier = await Classifier.loadWith(
    //   labelsFileName: _labelsFileName,
    //   modelFileName: _modelFileName,
    // );
    // _classifier = classifier!;
    final interpreter = await Interpreter.fromAsset('simple_ffnn_model.tflite');
    print('Interpreter loaded successfully');

    final inputShape = interpreter.getInputTensor(0).shape;
    final inputType = interpreter.getInputTensor(0).type;

    print('Input Type: $inputType');
    print('Input Shape: $inputShape');
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
