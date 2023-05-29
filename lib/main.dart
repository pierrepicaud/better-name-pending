// main.dart
// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors

import 'package:app/data_processing_screen/data_processing_screen.dart';
import 'package:app/prediction_screen/prediction_screen.dart';
import 'package:app/testing_screen/testing_screen.dart';
import 'sensor_display/sensor_data_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    SensorDataScreen(),
    DataPreparation(),
    PredictionScreen(),
    TestingScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sensors,
                color: _selectedIndex == 0 ? Colors.blue : Colors.lightBlue,
              ),
              label: 'Sensor Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.scatter_plot,
                color: _selectedIndex == 1 ? Colors.blue : Colors.lightBlue,
              ),
              label: 'Data Preprocessing',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.lightbulb_outline,
                color: _selectedIndex == 2 ? Colors.blue : Colors.lightBlue,
                size: 32.0,
              ),
              label: "Prediction",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outline,
                color: _selectedIndex == 3 ? Colors.blue : Colors.lightBlue,
                size: 32.0,
              ),
              label: "Testing",
            )
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
