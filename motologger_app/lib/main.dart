import 'package:flutter/material.dart';
import 'screens/monitor_screen.dart';

void main() {
  runApp(const MotoLoggerApp());
}

class MotoLoggerApp extends StatelessWidget {
  const MotoLoggerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoLogger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MonitorScreen(),
    );
  }
}
