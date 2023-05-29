// testing_screen.dart

import 'package:app/testing_screen/test_data/data.dart';
import 'package:flutter/material.dart';
import '../prediction_screen/classifier/classifier.dart';
import 'package:quiver/iterables.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  double accuracy = 0.0;
  String prediction = 'Move to start';

  late Classifier interpreter;
  // List<List<double>>? sensorDataValues; is because it's just one sample in more
  // more than 200 sample the whole xTest is 3d array so List<List<double>> is not enough
  // it should be Iterable<List<List<double>>>

  Iterable<List<List<double>>>? xTest;
  Iterable<List<double>>? yTest;

  var testDataInstance = TestData();

  bool _dataIsLoading = true;
  bool _modelIsLoading = true;

  @override
  void initState() {
    super.initState();
    interpreter = Classifier();
    _initModelAndData();
  }

  Future<void> _initModelAndData() async {
    debugPrint('Initializing model and data...');
    await _loadTestData();
    await _loadModel();
    await _evaluate();
    debugPrint('Model and data initialized.');
  }

  Future<void> _loadTestData() async {
    try {
      await testDataInstance.initXTest();
      setState(() {
        xTest = testDataInstance.xTest; // List<List<double>>?
        debugPrint('xTest loaded: ${xTest?.toList()[0][0]}');
      });
      await testDataInstance.initYTest();
      setState(() {
        yTest = testDataInstance.yTest; // Iterable<List<double>>?
        debugPrint('yTest loaded: ${yTest?.toList()[0]}');
      });
    } catch (error) {
      debugPrint('Error initializing test data: $error');
      debugPrint('Stack trace: ${StackTrace.current}');
    } finally {
      setState(() {
        _dataIsLoading = false;
      });
    }
  }

  Future<void> _loadModel() async {
    try {
      await interpreter.init();
    } catch (error) {
      debugPrint('Error loading model: $error');
    } finally {
      setState(() {
        _modelIsLoading = false;
      });
    }
  }

  Future<void> _evaluate() async {
    try {
      if (_dataIsLoading || _modelIsLoading || xTest == null || yTest == null) {
        return;
      }

      int totalSamples = 0;
      int correctPredictions = 0;

      for (var pair in zip([xTest!, yTest!])) {
        var xTestSample = pair[0];
        var yTestSample = pair[1];

        var pred = interpreter.predict(xTestSample);
        pred = interpreter.nonMaxSuppression(
            pred.map((e) => (e as List).cast<double>()).toList());
        pred = pred.expand((i) => i).toList();

        totalSamples++;

        int maxPredIndex = pred.indexOf(1.0);
        int maxYTestSampleIndex = yTestSample.indexOf(1.0);

        if (maxPredIndex == maxYTestSampleIndex) {
          correctPredictions++;
          debugPrint('Correct prediction! Total correct: $correctPredictions');
          debugPrint('pred: $pred predType: ${pred.runtimeType}');
          debugPrint(
              'ground: $yTestSample groundType: ${yTestSample.runtimeType}');
        } else {
          debugPrint('Test Failed');
        }
        setState(() {
          accuracy = (correctPredictions / totalSamples) * 100;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error during evaluation: $e');
      debugPrint('$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building widget...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Screen'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: _dataIsLoading || _modelIsLoading
            ? const CircularProgressIndicator() // Show loading spinner when data or model is loading
            : Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 10,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "$accuracy%",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
