// helper.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<List<List<double>>> readData(String file) async {
  String data = await rootBundle.loadString(file);
  var lines = data.split('\n');
  return lines.map((line) => line.trim().split(' ').map((item) => double.parse(item)).toList()).toList();
}

List<List<List<double>>> transpose3d(List<List<List<double>>> data) {
  List<List<List<double>>> transposed = [];
  for (int i = 0; i < data[0].length; i++) {
    transposed.add([]);
    for (int j = 0; j < data[0][0].length; j++) {
      transposed[i].add([]);
      for (int k = 0; k < data.length; k++) {
        transposed[i][j].add(data[k][i][j]);
      }
    }
  }
  return transposed;
}

Future<Iterable<List<List<double>>>> buildData(String subset) async {
  List<String> validSubsets = ["train", "val", "test"];
  if (!validSubsets.contains(subset)) {
    throw Exception("Invalid subset: $subset");
  }

  String folderPath = "UCI_HAR_Dataset/UCI_HAR_Dataset/$subset/Inertial Signals/";

  List<String> signalOrder = [
    "body_acc_x_",
    "body_acc_y_",
    "body_acc_z_",
    "body_gyro_x_",
    "body_gyro_y_",
    "body_gyro_z_",
    "total_acc_x_",
    "total_acc_y_",
    "total_acc_z_",
  ];

  List<String> signalFiles = signalOrder.map((x) => "$folderPath${x}$subset.txt").toList();

  List<List<List<double>>> signalsData = [];
  for (String signalFile in signalFiles) {
    signalsData.add(await readData(signalFile));
  }

  int numSamples = signalsData.length;
  int numTimesteps = signalsData[0].length;
  int numSignals = signalsData[0][0].length;
  debugPrint("Shape before transpose: $numSamples, $numTimesteps, $numSignals");

  signalsData = transpose3d(signalsData);

  numSamples = signalsData.length;
  numTimesteps = signalsData[0].length;
  numSignals = signalsData[0][0].length;
  debugPrint("Shape after transpose: $numSamples, $numTimesteps, $numSignals");

  List<int> expectedShape = subset == "train" ? [7352, 128, signalFiles.length] : [2947, 128, signalFiles.length];

  if (numSamples != expectedShape[0] || numTimesteps != expectedShape[1] || numSignals != expectedShape[2]) {
    throw Exception("Instead of shape $expectedShape, shape is actually $numSamples, $numTimesteps, $numSignals");
  }

  return signalsData;
}

Future<Iterable<List<double>>> loadY(String subset) async {
  String path = "UCI_HAR_Dataset/UCI_HAR_Dataset/$subset/y_$subset.txt";

  String fileContent = await rootBundle.loadString(path);
  List<int> y = fileContent.split('\n').map((line) => int.parse(line.trim())).toList();

  List<List<double>> oneHotLabels = [];
  for (var j in y) {
    oneHotLabels.add(List<double>.generate(6, (i) => (i + 1) == j ? 1.0 : 0.0));
  }

  if (subset == "train") {
    assert(oneHotLabels.length == 7352 && oneHotLabels[0].length == 6, "Wrong dimensions: ${oneHotLabels.length}, ${oneHotLabels[0].length} should be (7352, 6)");
  }
  
  if (subset == "test") {
    assert(oneHotLabels.length == 2947 && oneHotLabels[0].length == 6, "Wrong dimensions: ${oneHotLabels.length}, ${oneHotLabels[0].length} should be (2947, 6)");
  }
  
  assert((y[0] - 1) == oneHotLabels[0].indexWhere((j) => j == 1.0), "Value mismatch ${oneHotLabels[0].indexWhere((j) => j == 1.0)} vs ${y[0] - 1}");

  return oneHotLabels;
}

// void main() {
//   List<String> listA = ['a', 'b', 'c'];
//   List<int> listB = [1, 2, 3];

//   var zipped = zipLists(listA, listB);

//   for (var item in zipped) {
//     var itemA = item[0];
//     var itemB = item[1];

//     print('$itemA$itemB');
//   }
// }

Iterable<List<dynamic>> zipLists(List<dynamic> list1, List<dynamic> list2) sync* {
  var minLength = list1.length < list2.length ? list1.length : list2.length;

  for (var i = 0; i < minLength; i++) {
    yield [list1[i], list2[i]];
  }
}
