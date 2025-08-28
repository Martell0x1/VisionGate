#ifndef _LCDADDRESSSCAN_
#define _LCDADDRESSSCAN_

#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Arduino.h>
#include "ILCD.h"

class LCDAddressScan {
public:
    static byte init() {
        byte error, address;
        byte foundAddress = 0; 
        Serial.println("Scanning...");
        
        for (address = 1; address < 127; address++) {
            Wire.beginTransmission(address);
            error = Wire.endTransmission();
            if (error == 0) {
                Serial.print("✅ I2C device found at address 0x");
                if (address < 16) Serial.print("0");
                Serial.println(address, HEX);
                foundAddress = address;
            }
            else if (error == 4) {
                Serial.print("❌ Unknown error at address 0x");
                if (address < 16) Serial.print("0");
                Serial.println(address, HEX);
                return address;
            }
        }

        if (foundAddress == 0) {
            Serial.println("⚠️ No I2C devices found");
        } else {
            Serial.println("done\n");
        }

        delay(5000);
        return foundAddress; // always return something
    }
    static String transform(byte address){
        String hexAddress = String(address, HEX);
        return hexAddress;
    }
};

#endif