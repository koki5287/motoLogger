#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// BLE UUID
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-5678-90ab-cdef-1234567890ab"

// LEDピン
#define LED_PIN 2

BLEServer* pServer = nullptr;
BLECharacteristic* pCharacteristic = nullptr;

// Firebase接続状態（デモ用）
bool firebaseConnected = false;

// LED状態
bool ledState = false;

// BLEコールバッククラス
class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pChar) override {
    std::string value = pChar->getValue();
    if (value.length() > 0) {
      Serial.print("Received command: ");
      Serial.println(value.c_str());

      if (value == "start") {
        Serial.println("Start operation");
        ledState = true;        // LED ON
        digitalWrite(LED_PIN, HIGH);
      } else if (value == "stop") {
        Serial.println("Stop operation");
        ledState = false;       // LED OFF
        digitalWrite(LED_PIN, LOW);
      }
    }
  }
};

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // BLE初期化
  BLEDevice::init("ESP32_Controller");
  pServer = BLEDevice::createServer();
  
  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_WRITE
                    );

  pCharacteristic->setCallbacks(new MyCallbacks());

  BLE2902 *desc = new BLE2902();
  desc->setNotifications(true);
  pCharacteristic->addDescriptor(desc);

  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();

  Serial.println("BLE Peripheral is running...");
}

void loop() {
  // デモ用: Firebase接続状態を通知
  firebaseConnected = !firebaseConnected; // ダミーでON/OFF切替
  String status = "{\"firebase\":\"" + String(firebaseConnected ? "connected" : "disconnected") + "\"}";
  pCharacteristic->setValue(status.c_str());
  pCharacteristic->notify();

  Serial.println(status); // シリアルにも出力

  delay(2000); // 2秒ごとに通知
}
