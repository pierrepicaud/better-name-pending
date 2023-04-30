// Import tflite_flutter
// ignore_for_file: unused_element, unused_import
// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// name of the model file
const String _modelFile = 'assets/model.tflite';

// TensorFlow Lite Interpreter object
Interpreter? _interpreter;

void loadTFLiteModel() async {
  _interpreter = await Interpreter.fromAsset(_modelFile);
  print('Interpreter loaded successfully');
  _interpreter?.allocateTensors();
  print(_interpreter?.getInputTensors());
  print(_interpreter?.getOutputTensors());
}

void main() {
  loadTFLiteModel();
}
