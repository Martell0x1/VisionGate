#ifndef H_APICLIENT_
#define H_APICLIENT_

#include <HTTPClient.h>

enum HTTPMethod {
    GET,
    POST,
    PUT,
    DELETE_REQ
};

class APIClient {
private:
    const char* baseUrl;

public:
    APIClient(const char* url) : baseUrl(url) {}

    String sendRequest(HTTPMethod method, const char* endpoint, const char* data = nullptr) {
        HTTPClient http;
        String url = String(baseUrl) + String(endpoint);
        http.begin(url);

        int httpCode = 0;
        String payload = "";

        if(method == GET) {
            httpCode = http.GET();
        } else if(method == POST) {
            http.addHeader("Content-Type", "application/json");
            httpCode = http.POST(data);
        } else if(method == PUT) {
            http.addHeader("Content-Type", "application/json");
            httpCode = http.PUT(data);
        } else if(method == DELETE_REQ) {
            httpCode = http.sendRequest("DELETE");
        }

        if(httpCode > 0) {
            payload = http.getString();
        }

        http.end();
        return payload;
    }

    bool connect() {
        HTTPClient http;
        String url = String(baseUrl);
        http.begin(url); 

        int httpCode = http.GET();
        http.end();

        if (httpCode > 0) {
            Serial.printf("Connection OK, HTTP code: %d\n", httpCode);
            return true;
        } else {
            Serial.printf("Connection FAILED, error: %d\n", httpCode);
            return false;
        }
    }
};

#endif
