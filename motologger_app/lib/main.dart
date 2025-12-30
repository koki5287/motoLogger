import 'package:flutter/material.dart';
import 'ble_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BLE Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              connectAndRead();
            },
            child: const Text('Connect & Read'),
          ),
        ),
      ),
    );
  }
}
