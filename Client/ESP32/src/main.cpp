#include <Arduino.h>
#include <WiFi.h>

#include "config/WifiConfig.h"
#include "modules/APIClient/APIClient.h"
#include "modules/IRSensor/IRSensor.h"
#include "modules/LED/LED.h"

WifiConfig wifiConfig("Martell", "MarwanMartell@04");
APIClient apiClient("http://192.168.1.4:8080");
IRSensor irSensor(19);
LEDModule WaitingLED(21, WAITING);
LEDModule DeniedLED(22, DENIED);
LEDModule ApprovedLED(23, APPROVED);


void setup() {
  Serial.begin(115200);
  while(wifiConfig.Connect() != 1) {
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi!");
  DeniedLED.turnOn();
}

void loop() {
  int ir = irSensor.readDigital();
  if(!ir) {
    Serial.println("vehicle detected!");
    String response = apiClient.sendRequest(GET, "/take_pic");
    if(response.length() > 1) {
      WaitingLED.turnOn();
      DeniedLED.turnOff();
      Serial.println("Response: " + response);
    }
  }
  delay(1000);
}