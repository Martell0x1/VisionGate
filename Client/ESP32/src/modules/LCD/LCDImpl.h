#ifndef _LCD_H
#define _LCD_H

#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Arduino.h>
#include "ILCD.h"

class LCDImpl: public ILcd {
private:
    LiquidCrystal_I2C *lcd;
public:
    LCDImpl(LiquidCrystal_I2C& lcd){ 
        this->lcd = &lcd;
    }
    void begin() override{
        this->lcd->init();
        this->lcd->backlight();
        this->lcd->setCursor(0, 0);
        this->lcd->print("Init.....");
    }
    void print(const char* message) override{
        // this->lcd->clear();
        this->lcd->print(message);
    }
    void clear() override{
        this->lcd->clear();
    }
};

#endif