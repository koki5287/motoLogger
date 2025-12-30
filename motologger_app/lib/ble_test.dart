import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<void> connectAndRead() async {
  await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

  FlutterBluePlus.scanResults.listen((results) async {
    for (final r in results) {
      if (r.device.platformName == "MotoLogger") {
        final device = r.device;

        await FlutterBluePlus.stopScan();
        await device.connect();

        final services = await device.discoverServices();

        for (final service in services) {
          if (service.uuid.toString() ==
              "12345678-1234-1234-1234-1234567890ab") {
            for (final c in service.characteristics) {
              if (c.uuid.toString() == "abcd1234-5678-90ab-cdef-1234567890ab") {
                final value = await c.read();
                print("read value = $value");
                return;
              }
            }
          }
        }
      }
    }
  });
}
