List<double> interpolate(List<double> data) {
  List<double> interpolatedData = [];

  for (int i = 0; i < data.length - 1; i++) {
    interpolatedData.add(data[i]);

    // Add a new point that is the average of the current point and the next point
    double interpolatedPoint = (data[i] + data[i + 1]) / 2;
    interpolatedData.add(interpolatedPoint);
  }

  interpolatedData.add(data.last);

  var extraPoint = data.last + (data.last - data[data.length - 2]).abs();

  interpolatedData.add(extraPoint);

  if (interpolatedData.length != data.length * 2) {
    throw Exception(
        "Failed interpolation before: ${data.length} after ${interpolatedData.length}");
  }

  return interpolatedData;
}

List<List<double>> splitList(List<List<double>?> data) {
  List<double> xData = [];
  List<double> yData = [];
  List<double> zData = [];

  for (List<double>? point in data) {
    if (point?.length != 3) {
      throw Exception('Each inner list must have exactly 3 elements');
    }

    if (point == null) {
      throw Exception('Null in splitList, there is nothing to split');
    }

    xData.add(point[0]);
    yData.add(point[1]);
    zData.add(point[2]);
  }

  return [xData, yData, zData];
}

List<List<double>> concatenate(List<List<double>> data1,
    List<List<double>> data2, List<List<double>> data3) {
  List<List<double>> concatenatedData = [];

  if (data1.length != data2.length || data2.length != data3.length) {
    throw Exception('All data lists must be of the same length');
  }

  for (int i = 0; i < data1.length; i++) {
    List<double> dataPoint = [];
    dataPoint.addAll(data1[i]);
    dataPoint.addAll(data2[i]);
    dataPoint.addAll(data3[i]);
    concatenatedData.add(dataPoint);
  }

  return concatenatedData;
}

List<List<double>> dataWrangling(List<List<double>> list1,
    List<List<double>> list2, List<List<double>> list3) {
  if (list1.length != list2.length || list2.length != list3.length) {
    throw Exception('All data lists must be of the same length');
  }
  int timeSteps = list1[0].length;
  int numSensors = list1.length + list2.length + list3.length;

  List<List<double>> result =
      List.generate(timeSteps, (_) => List<double>.filled(numSensors, 0));

  for (int i = 0; i < timeSteps; i++) {
    for (int j = 0; j < numSensors; j++) {
      if (j < list1.length) {
        result[i][j] = list1[j][i];
      } else if (j < list1.length + list2.length) {
        result[i][j] = list2[j - list1.length][i];
      } else {
        result[i][j] = list3[j - list1.length - list2.length][i];
      }
    }
  }

  return result;
}
