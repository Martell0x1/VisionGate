#ifndef H_IRSENSOR_
#define H_IRSENSOR_

#include <Arduino.h>

class IRSensor {
    public:
        IRSensor(int pin) : pin(pin) {
            pinMode(pin, INPUT);
        }

        int readDigital() {
            return digitalRead(pin);
        }

        int readAnalog() {
            return analogRead(pin);
        }

    private:
        int pin;
};

#endif