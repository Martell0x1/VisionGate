#include <Arduino.h>
#include <WiFi.h>

#include "config/WifiConfig.h"
#include "modules/APIClient/APIClient.h"
#include "modules/IRSensor/IRSensor.h"
#include "modules/LED/LED.h"
#include "modules/ServoMoto/ServoMotor.h"
#include "modules/Mqtt/Mqtt.h"

WifiConfig wifiConfig("Martell", "MarwanMartell@04");
APIClient apiClient("http://192.168.1.3:8080");
IRSensor irSensor(19);
LEDModule WaitingLED(21, WAITING);
LEDModule DeniedLED(22, DENIED);
LEDModule ApprovedLED(23, APPROVED);
ServoMotor servoMotor(13);
MQttClient mqttClient("5965aa9309824cb48daa5da0a2083f47.s1.eu.hivemq.cloud", 8883);


// track servo state
bool servoOpen = false;
unsigned long servoOpenedAt = 0;
const unsigned long SERVO_OPEN_DURATION = 15000; // 15 sec

void onMqttMessage(String topic, String payload) {
  Serial.printf("📥 MQTT Message on %s: %s\n", topic.c_str(), payload.c_str());

  if (topic == "esp/servo") {
    ApprovedLED.turnOn();   // 🟢 approved
    WaitingLED.turnOff();   // 🟡 off
    DeniedLED.turnOff();    // 🔴 off

    servoMotor.setAngle(180);   // open gate
    servoOpen = true;
    servoOpenedAt = millis();  // remember when opened
  }
}
void setup() {
  Serial.begin(115200);
  while(wifiConfig.Connect() != 1) {
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi!");
  DeniedLED.turnOn();
  mqttClient.setCallback([](char* topic, byte* payload, unsigned int length) {
    String message;
    for (unsigned int i = 0; i < length; i++) {
      message += (char)payload[i];
    }
    onMqttMessage(String(topic), message);  // call your handler
  });
  mqttClient.connect();
  apiClient.connect();
}


void loop() {
  mqttClient.loop();  // keep MQTT alive

  int ir = irSensor.readDigital();
  if (!ir) {
    Serial.println("vehicle detected!");

    // 🟡 Immediately show waiting state
    WaitingLED.turnOn();
    DeniedLED.turnOff();
    ApprovedLED.turnOff();

    String response = apiClient.sendRequest(GET, "/take_pic");

    if (response.length() > 1) {
      Serial.println("Response: " + response);
      // 👉 Keep yellow ON until MQTT message arrives
    } else {
      // ❌ No response from API → red LED
      WaitingLED.turnOff();
      DeniedLED.turnOn();
      Serial.println("❌ Error: No response from server");
    }
  }
    if (servoOpen && (millis() - servoOpenedAt >= SERVO_OPEN_DURATION)) {
    servoMotor.setAngle(0);    // close gate
    ApprovedLED.turnOff();
    DeniedLED.turnOn();        // red LED ON
    servoOpen = false;         // reset state
    Serial.println("⏱️ Servo auto-closed after 15s");
  }
}

