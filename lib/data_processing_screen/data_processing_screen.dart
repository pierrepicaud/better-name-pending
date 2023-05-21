import 'package:flutter/material.dart';
import 'sensor_data/data.dart';

class DataPreparation extends StatefulWidget {
  const DataPreparation({Key? key}) : super(key: key);

  @override
  _DataPreparationState createState() => _DataPreparationState();
}

class _DataPreparationState extends State<DataPreparation> {
  List<List<double>>? sensorDataValues;
  var sensorsDataInstance = SensorsData();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSensorData();
  }

  Future<void> _loadSensorData() async {
    try {
      await sensorsDataInstance.init();
      sensorDataValues = sensorsDataInstance.sensorData;
    } catch (error) {
      print('Error initializing sensor data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    await _loadSensorData();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    await _loadSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Preparation'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                child: Text(sensorDataValues.toString()),
              ),
            ),
    );
  }
}
