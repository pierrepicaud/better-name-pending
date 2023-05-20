import 'package:flutter/material.dart';
import '../sensor_data/data.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Data is loaded:\n${sensorDataValues?.sublist(0, 10).toString()}',
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Define your action here
                  },
                  child: const Text('Your Button Text'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
