#ifndef _H_LEDMODULE_
#define _H_LEDMODULE_

#include <Arduino.h>

enum LEDStatus {
    OFF,
    ON,
    BLINKING
};

enum LEDMode {
    WAITING,
    APPROVED,
    DENIED
};

class LEDModule {
private:
    int pin;
    LEDStatus status;
    LEDMode mode;

public:
    LEDModule(int pin , LEDMode mode) : pin(pin), status(OFF), mode(mode) {
        pinMode(pin, OUTPUT);
    }

    void turnOn() {
        digitalWrite(pin, HIGH);
        status = ON;
    }

    void turnOff() {
        digitalWrite(pin, LOW);
        status = OFF;
    }

    void blink(int duration) {
        turnOn();
        delay(duration);
        turnOff();
    }
};

#endif
