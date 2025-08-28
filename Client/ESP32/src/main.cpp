#include <Arduino.h>
#include <WiFi.h>
#include <LiquidCrystal_I2C.h>
#include <ArduinoJson.h>


#include "config/WifiConfig.h"
#include "modules/APIClient/APIClient.h"
#include "modules/IRSensor/IRSensor.h"
#include "modules/LED/LED.h"
#include "modules/ServoMoto/ServoMotor.h"
#include "modules/LCD/LCDImpl.h"
#include "modules/Mqtt/Mqtt.h"
#include "modules/LDR/LDR.h"
#include "modules/Buzzer/Buzzer.h"

WifiConfig wifiConfig("Martell", "MarwanMartell@04");
APIClient apiClient("http://192.168.1.3:8080");
IRSensor irSensor(19);
LEDModule WaitingLED(5, WAITING);
Buzzer buzzer(33);
LDR ldr(34);

LEDModule DeniedLED(18, DENIED);
LEDModule ApprovedLED(23, APPROVED);
ServoMotor servoMotor(13);

LiquidCrystal_I2C lcd(0x27, 16, 2);
LCDImpl lcdImpl(lcd);

MQttClient mqttClient("5965aa9309824cb48daa5da0a2083f47.s1.eu.hivemq.cloud", 8883);


// track servo state
bool servoOpen = false;
unsigned long servoOpenedAt = 0;
const unsigned long SERVO_OPEN_DURATION = 15000; // 15 sec

void onMqttMessage(String topic, String payload) {
  Serial.printf("📥 MQTT Message on %s: %s\n", topic.c_str(), payload.c_str());

  if (topic == "esp/servo") {

    // Parse JSON payload
    StaticJsonDocument<256> doc;   // adjust size if payload grows
    DeserializationError error = deserializeJson(doc, payload);

    if (!error) {
      const char* plate = doc["plate"];  
      const char* username = doc["username"];     // get plate string
      long timestamp = doc["timestamp"];      // get timestamp


      if(!plate || strlen(plate) == 0) {
        DeniedLED.turnOn();    
        lcdImpl.clear();
        lcdImpl.print("Plate Not Found");
        buzzer.buzz(500);
      } else {
        ApprovedLED.turnOn();   
        WaitingLED.turnOff();   
        DeniedLED.turnOff();    
        lcdImpl.clear();
        lcdImpl.print("Hello: ");
        lcdImpl.print(username);   // first line: plate
        servoMotor.setAngle(180);   // open gate
        servoOpen = true;
        servoOpenedAt = millis();   // remember when opened
      }

      // lcdImpl.clear();
      // lcdImpl.print("Time: ");
      // lcdImpl.print(timestamp.toString());
    } else {
      Serial.println("❌ Failed to parse JSON!");
    }
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
  lcdImpl.begin();
  lcdImpl.clear();
  lcdImpl.print("System Ready");

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
  
  int t = ldr.trigger();
  if (t) {
    // Serial.println("LDR Triggered!");
    delay(200);
    WaitingLED.turnOn();
  }
  else{
    delay(200);
    WaitingLED.turnOff();
  }
  // Serial.println(ldr.read());

}

/*********
  Rui Santos
  Complete project details at https://randomnerdtutorials.com  
*********/

// #include <LiquidCrystal_I2C.h>

// // set the LCD number of columns and rows
// int lcdColumns = 16;
// int lcdRows = 2;

// // set LCD address, number of columns and rows
// // if you don't know your display address, run an I2C scanner sketch
// LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows);  

// void setup(){
//   // initialize LCD
//   lcd.init();
//   // turn on LCD backlight                      
//   lcd.backlight();
// }

// void loop(){
//   // set cursor to first column, first row
//   lcd.setCursor(0, 0);
//   // print message
//   lcd.print("Hello, World!");
//   delay(1000);
//   // clears the display to print new message
//   lcd.clear();
//   // set cursor to first column, second row
//   lcd.setCursor(0,1);
//   lcd.print("Hello, World!");
//   delay(1000);
//   lcd.clear(); 
// }
