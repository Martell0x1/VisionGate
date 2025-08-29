# VISION Gate – End-to-End IoT & AI Solution

## Overview
Developed a **smart parking system** where users register their data through the **app**. When they approach the garage, the camera scans the car’s license plate and checks it against the system for **secure entry**.

---

## Backend & Hardware
Designed and implemented the full end-to-end system following clean code and software engineering best principles — including a well-structured software architecture with a **NestJS backend**, **AI model integration**, and a **Flutter mobile application**, as well as fully developing the **ESP32 firmware** to manage sensors, servo motor control, and LED feedback, while establishing **MQTT-based real-time communication** between the backend, the ESP device, and the user application, complemented with a custom camera detection app and a clear architectural design for seamless integration.

Dockorized backend component and pushed the image to docker hub - create Azure container service and linked it to docker hub image outcomes: - fully operated backend component remotely.

---

## Wiring & Electronics
Designed and connected circuits with sensors and actuators.  
**Components Used:**

1. **LDR (Light Dependent Resistor):** for light sensing.  
2. **IR Sensor:** for object detection.  
3. **Buzzer:** for alerts/notifications.  
4. **Servo Motor:** for mechanical movement (e.g., opening/closing).  
5. **LCD:** for printing status to the user.  
6. **LEDs (3):** for status indicators and feedback.  

---

## IoT & Communication
- Integrated **MQTT** for real-time communication and remote control.  
- Implemented API Client for RESTful interaction with backend services.  

---

## Software & Architecture
- Developed with **Platform IO**, structuring the project into modules (peripheral classes like IR Sensor, LED, Servomotor, MQTT, etc.).  
- Applied modern software development principles:  
  - **Dependency Injection (DI):** decoupled components for easier testing and flexibility.  
  - **Single Responsibility Principle (SRP):** each module/class handles only one responsibility.  
- Achieved clean, maintainable, and reusable code.  

---

## Database
A Schema is the first step in organizing your database:  
- Acts like a namespace that groups related tables, views, and functions.  
- Helps keep the database structured and manageable.  
- Allows separation of different parts of the application (Cars, Plans, Users).  

**Users Table**: first_name, last_name, address, phone, DOB, user_id, email, image_link, password  
**Cars Table**: car_id, company, car_model, user_id, plan_id, subscription_start  
**Plans Table**: plan_id, value, unit, price  

---

## AI Model
**Objectives:**  
- Detect license plates from vehicle images.  
- Extract plate numbers accurately as text.  
- Build an API for easy integration with apps.  

**Tools & Technologies:**  
- YOLO → License plate detection  
- OpenCV → Image preprocessing  
- EasyOCR → Text recognition  
- Flask API → Receive images & return text  
- Python → Development  

**System Architecture:**  
1. Receive vehicle image (via API)  
2. YOLO detects bounding box  
3. OpenCV crops the license plate region  
4. EasyOCR extracts text  
5. Flask API returns license number  

> YOLO finds the plate → OpenCV prepares the plate → EasyOCR reads the text.

---

## Flutter Mobile Application
1. Created the initial design using **Flutter Flow**.  
2. Added an animation to the loading screen to make the app feel more realistic.  
3. Built 11 pages, and allowed the user to choose between light or dark mode starting from the login page, applied across the entire app.  
4. Implemented the logic and navigation between pages.  
5. Integrated the app with the backend using APIs & performed testing to ensure the application runs smoothly.

