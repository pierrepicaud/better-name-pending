import 'package:flutter/material.dart';

import '../data_processing_screen/sensor_data/data.dart';
import 'classifier/classifier.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({Key? key}) : super(key: key);

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String prediction = 'Move to start';

  late Classifier interpretper;

  List<List<double>>? sensorDataValues;
  var sensorsDataInstance = SensorsData();

  bool _dataIsLoading = true;
  bool _modelIsLoading = true;

  @override
  void initState() {
    super.initState();
    interpretper = Classifier();
    _initModelAndData();
  }

  Future<void> _initModelAndData() async {
    await _loadSensorData();
    await _loadModel();
    _predict();
  }

  Future<void> _loadSensorData() async {
    try {
      await sensorsDataInstance.init();
      sensorDataValues = sensorsDataInstance.sensorData;
    } catch (error) {
      debugPrint('Error initializing sensor data: $error');
    } finally {
      setState(() {
        _dataIsLoading = false;
      });
    }
  }

  Future<void> _loadModel() async {
    try {
      await interpretper.init();
    } catch (error) {
      debugPrint('Error loading model: $error');
    } finally {
      setState(() {
        _modelIsLoading = false;
      });
    }
  }

  List<String> activities = [
    "WALKING",
    "WALKING_UPSTAIRS",
    "WALKING_DOWNSTAIRS",
    "SITTING",
    "STANDING",
    "LAYING"
  ];

  Future<void> _predict() async {
    if (!_dataIsLoading && !_modelIsLoading) {
      var pred = interpretper.predict(sensorDataValues!);
      debugPrint('pred: $pred predType: ${pred.runtimeType}');
      int predictedIndex = interpretper.postprocess(pred[0].cast<double>());
      setState(() {
        prediction =
            activities[predictedIndex]; // or whatever you want to display here
      });

      // Load new sensor data and make another prediction
      await _loadSensorData();
      await _predict();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    prediction,
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
