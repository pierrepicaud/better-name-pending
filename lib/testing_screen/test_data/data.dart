// data.dart
import 'dart:async';
import './helper.dart';

class TestData {
  Iterable<List<List<double>>>? xTest;
  Iterable<List<double>>? yTest;

  TestData();

  Future<Iterable<List<List<double>>>> initXTest() async {
    return await buildData('test');
  }

  Future<Iterable<List<double>>> initYTest() async {
    return await loadY('test');
  }
}
