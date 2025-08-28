// ILcd.h
#ifndef _ILCD_H
#define _ILCD_H

class ILcd {
public:
    virtual void begin() = 0;
    virtual void print(const char* message) = 0;
    virtual void clear() = 0;
    virtual ~ILcd() {}
};

#endif
