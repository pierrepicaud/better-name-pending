import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
    try{
      if (modelFile != null) {
        _interpreter = await Interpreter.fromAsset(modelFile);
        _isReady = true;

        // Get input and output shape from the model
        inputShape = _interpreter.getInputTensor(0).shape;
        outputShape = _interpreter.getOutputTensor(0).shape;

        // Get input and output type from the model
        inputType = _interpreter.getInputTensor(0).type;
        outputType = _interpreter.getOutputTensor(0).type;

        debugPrint(
          'Interpreter loaded successfully'
          'Input shape: $inputShape'
          'Input type: $inputType'
          'Output type: $outputType'
          'Output shape: $outputShape');
      }
    } catch(e) {
      debugPrint('Failed to load model.');
      debugPrint(e.toString());
    }
  }

  Future<List?> predict(List input) async {
    if (!_isReady) throw StateError("Model not loaded yet");

    var output = List.filled(1, 0).reshape([1]);
    _interpreter.run(input, output);
    return output;
  }
}
