// Reset this to the initial state
import 'package:flutter/material.dart';
import 'sensor_display/sensor_data_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Text('Work in progress'),
    const Text('Work in progress'),
    const Text('Work in progress'),
    // SensorDataScreen(),
    // SensorSegmentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.lightbulb_outline,
                color: Colors.yellow,
                size: 32.0,
              ),
              label: 'Prediction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sensors),
              label: 'Sensor Data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Data Segment',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
