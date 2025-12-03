import 'package:flutter/material.dart';
import '../services/ble_service.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final BleService bleService = BleService();
  String data = "";

  @override
  void initState() {
    super.initState();
    // ← 自動スキャン部分は削除しました！
  }

  @override
  void dispose() {
    bleService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Monitor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.isEmpty ? 'No data yet' : data),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await bleService.scanAndConnect((received) {
                  setState(() {
                    data = received;
                  });
                });
              },
              child: const Text('Scan BLE'),
            ),
          ],
        ),
      ),
    );
  }
}
