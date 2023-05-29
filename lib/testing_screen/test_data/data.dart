// data.dart
import 'dart:async';
import './helper.dart';

class TestData {
  Iterable<List<List<double>>>? xTest;
  Iterable<List<double>>? yTest;

  TestData();

  Future<void> initXTest() async {
    xTest = await buildData('test');
  }

  Future<void> initYTest() async {
    yTest = await loadY('test');
  }
}
