#ifndef WIFICONFIG_H
#define WIFICONFIG_H

#include <WiFi.h>
class WifiConfig{
    private:
        const char* ssid = "";
        const char* password = "";
    public:
        WifiConfig(const char* ssid, const char* password): ssid(ssid), password(password) {}

        const char* getSsid() const {
            return ssid;
        }

        const char* getPassword() const {
            return password;
        }

        int Connect(){
            WiFi.begin(this->ssid, this->password);
            while(WiFi.status() != WL_CONNECTED) {
                // Serial.print(".");
                delay(1000);
            }
            return 1;
        }

};
#endif