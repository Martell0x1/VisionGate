#ifndef _MQTT
#define _MQTT
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include "cert.h"

class MQttClient {
public:
    MQttClient(const char* broker, int port) 
        : _mqttClient(_client) 
    {
        _mqttClient.setServer(broker, port);
        this->_client.setCACert(root_ca);
    }

    void setCallback(MQTT_CALLBACK_SIGNATURE) {
        _mqttClient.setCallback(callback);
    }

    void connect() {
        Serial.println("Connecting to MQTT...");
        while (!_mqttClient.connected()) {
            Serial.println("Reconnecting...");
            String clientId = "ESP32CLIENT-";
            clientId += String(random(0xfffff), HEX);

            if (_mqttClient.connect(clientId.c_str(), mqtt_username, mqtt_password)) {
                Serial.println("✅ Connected To Mqtt Server (Broker)");
                // Subscribe to correct topic
                _mqttClient.subscribe("esp/servo");  
            } else {
                Serial.print("❌ Failed rc=");
                Serial.println(_mqttClient.state());
                delay(5000);
            }
        }
    }

    void loop() {
        _mqttClient.loop();
    }

    void publish(const char* topic, const char* payload) {
        _mqttClient.publish(topic, payload);
    }

    void subscribe(const char* topic) {
        if (_mqttClient.subscribe(topic)) {
            Serial.print("📡 Subscribed to topic: ");
            Serial.println(topic);
        } else {
            Serial.print("❌ Failed to subscribe to topic: ");
            Serial.println(topic);
        }
    }

private:
    const char* mqtt_username = "Maro1234";
    const char* mqtt_password = "Maro@012";

    WiFiClientSecure _client;
    PubSubClient _mqttClient;
};

#endif
