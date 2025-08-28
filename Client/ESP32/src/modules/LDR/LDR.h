#ifndef _LDR_H
#define _LDR_H

#include <Arduino.h>

class LDR {
private:
    int pin;
public:
    LDR(int pin) {
        this->pin = pin;
        pinMode(pin, INPUT);
    }
    int read() {
        return analogRead(pin);
    }
    int trigger(){
        return this->read() < 500 ? 1: 0;
    }
};

#endif