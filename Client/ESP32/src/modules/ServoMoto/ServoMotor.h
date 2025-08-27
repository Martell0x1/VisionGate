#ifndef _SERVOMOTOR_H
#define _SERVOMOTOR_H
#include <Arduino.h>

class ServoMotor {
public:
    ServoMotor(int pin): _pin(pin), _angle(0) {
        ledcSetup(this->PWM, this->PWM_F, this->PWM_R);
        ledcAttachPin(this->_pin, this->PWM);
        this->setAngle(0); // Start at 0 degrees
    }

    void setAngle(int angle) {
        _angle = constrain(angle, 0, 180);
        // Map 0–180° to duty cycle (500µs–2500µs pulse at 50Hz)
        int duty = map(angle, 0, 180, 3277, 6553);
        ledcWrite(this->PWM, duty);
        Serial.println("Servo angle set to: " + String(_angle) + " (duty=" + String(duty) + ")");
    }

    int getAngle() {
        return this->_angle;
    }

private:
    int _pin;
    int _angle;
    const int PWM = 0;     // channel
    const int PWM_F = 50;  // frequency 50Hz
    const int PWM_R = 16;  // resolution 16-bit
};

#endif
