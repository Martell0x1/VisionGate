#ifndef _BUZZER_H
#define _BUZZER_H

#include <Arduino.h>

class Buzzer {
private:
    int pin;
public:
    Buzzer(int pin) {
        this->pin = pin;
        pinMode(pin, OUTPUT);
    }
    void buzz(int duration) {
        digitalWrite(pin, HIGH);
        delay(duration);
        digitalWrite(pin, LOW);
    }
};

#endif