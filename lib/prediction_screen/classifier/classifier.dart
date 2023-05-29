import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  late Interpreter interpreter;
  late List<int> inputShape;
  late List<int> outputShape;
  late TfLiteType inputType;
  late TfLiteType outputType;

  // There is a file that contain the model that I want to read from

  Classifier();

  Future<String> loadModelPath() async {
    String modelPath = '';
    try {
      modelPath = await rootBundle.loadString('assets/model.txt');
    } catch (e) {
      debugPrint("Couldn't read file: $e");
    }
    return modelPath;
  }

  Future<void> init() async {
    try {
      String modelPath = await loadModelPath();
      interpreter = await Interpreter.fromAsset(modelPath);

      inputShape = interpreter.getInputTensor(0).shape;
      outputShape = interpreter.getOutputTensor(0).shape;

      inputType = interpreter.getInputTensor(0).type;
      outputType = interpreter.getOutputTensor(0).type;

      debugPrint('Interpreter loaded successfully\n'
          'Input shape: $inputShape\n'
          'Input type: $inputType\n'
          'Output type: $outputType\n'
          'Output shape: $outputShape Ouput shape type: ${outputShape.runtimeType}\n');
    } catch (e) {
      debugPrint('Failed to load model. $e');
    }
  }

  List<dynamic> predict(List<dynamic> input) {
    var outputSize = outputShape.reduce((value, element) => value * element);
    var output = List<dynamic>.filled(outputSize, 0, growable: false)
        // var output = List<dynamic>.filled(6, 0, growable: false)
        .reshape(outputShape);
    interpreter.run(input.reshape(inputShape), output); // Flatten?
    return output;
  }

  //
  int postprocess(List<double> output) {
    return output.indexOf(
        output.reduce((value, element) => value > element ? value : element));
  }

  List<List<double>> nonMaxSuppression(List<List<double>> input) {
    return input.map((sublist) {
      double maxVal = sublist.reduce((a, b) => a > b ? a : b);
      return sublist.map((val) => val == maxVal ? 1.0 : 0.0).toList();
    }).toList();
  }
}
