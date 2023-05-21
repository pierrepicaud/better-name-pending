// ignore_for_file: avoid_print

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'get_sensors_data.dart';

class Classifier {
  late Interpreter _interpreter;
  late List<int> inputShape;
  late List<int> outputShape;
  late TfLiteType inputType;
  late TfLiteType outputType;

  bool _isReady = false;

  // There is a file that contain the model
  Future<String?> readMyFile() async {
    try {
      final fileContent = await rootBundle.loadString('assets/model.txt');
      return fileContent;
    } catch (e) {
      debugPrint("Couldn't read file: $e");
      return null;
    }
  }

  Classifier() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    final modelFile = await readMyFile();

    debugPrint(
      'Start loading of Classifier with '
      // 'labels at $_labelsFileName, '
      'Using model $modelFile',
    );
    try {
      if (modelFile != null) {
        _interpreter = await Interpreter.fromAsset(modelFile);
        _isReady = true;

        // Get input and output shape from the model
        inputShape = _interpreter.getInputTensor(0).shape;
        outputShape = _interpreter.getOutputTensor(0).shape;

        // Get input and output type from the model
        inputType = _interpreter.getInputTensor(0).type;
        outputType = _interpreter.getOutputTensor(0).type;

        debugPrint('Interpreter loaded successfully'
            'Input shape: $inputShape'
            'Input type: $inputType'
            'Output type: $outputType'
            'Output shape: $outputShape');
      }
    } catch (e) {
      debugPrint('Failed to load model.');
      debugPrint(e.toString());
    }
  }

  // Get the data from the sensors, we know the sampling rate so just run a loop
  // get enough 128 data points
  // For the accelerators just get enough 128, that would need 2,56 * 2 = 5,12s
  // time it
  // store it in the decompsed form

  Future<List?> _predict() async {
    try {
      // Get sensor data
      // List<List<Float64List>> input = getSensorsData();
      List<List<Float64List>> input = []; // Dummy values

      // Flatten the input data
      var flatInput = input
          .expand((element) => element)
          .expand((element) => element)
          .toList();

      // Prepare the output buffer
      var outputBuffer;

      if (outputType == TfLiteType.float32) {
        outputBuffer = List.filled(
                outputShape.reduce((value, element) => value * element), 0.0)
            .reshape(outputShape);
      } else if (outputType == TfLiteType.uint8) {
        outputBuffer = List.filled(
                outputShape.reduce((value, element) => value * element), 0)
            .reshape(outputShape);
      } else {
        throw Exception('Output type $outputType is not supported');
      }

      // Predict
      _interpreter.run(flatInput, outputBuffer);

      // debugPrint(outputBuffer);
      print(outputBuffer.toString());
    } catch (e) {
      debugPrint('Something went wrong: ${e.toString()}');
    }
  }
}
