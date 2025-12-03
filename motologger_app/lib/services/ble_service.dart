import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BluetoothDevice? connectedDevice;

  Future<void> scanAndConnect(Function(String) onData) async {
    // スキャン開始
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // スキャン結果取得
    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        print("Found device: ${r.device.name}, ID: ${r.device.id}");


        // ←ここで条件セット（例: デバイス名一致）
        if (r.device.name.contains("ESP")) {
          FlutterBluePlus.stopScan();

          connectedDevice = r.device;

          await connectedDevice!.connect();
          print("Connected!");

          // サービス・キャラクタリスティック探索
          var services = await connectedDevice!.discoverServices();
          for (var service in services) {
            for (var characteristic in service.characteristics) {
              if (characteristic.properties.notify) {
                await characteristic.setNotifyValue(true);
                characteristic.value.listen((data) {
                  onData(String.fromCharCodes(data));
                });
              }
            }
          }
        }
      }
    });
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }
}
