import 'package:sensors_plus/sensors_plus.dart';

void main() {
  // Get the sampling rate for the accelerometer
  final accelerometerSamplingRate = Sensor(
    sensorId: Sensors.accelerometer,
    sensorType: SensorType.accelerometer,
  ).samplingRate;

  print('Accelerometer sampling rate: $accelerometerSamplingRate');
}

