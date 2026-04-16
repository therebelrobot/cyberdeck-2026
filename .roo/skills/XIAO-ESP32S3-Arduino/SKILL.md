---
name: xiao-esp32s3-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO ESP32-S3 microcontroller. Use when writing Arduino firmware for the
  XIAO ESP32-S3, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-S3, Arduino,
  Espressif, Xtensa, dual-core, WiFi, BLE, Bluetooth, PSRAM, USB OTG, pinout, GPIO, I2C, SPI,
  UART, analog, digital, PWM, touch, deep sleep, battery, ESP-IDF.
---

# XIAO ESP32-S3 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO ESP32-S3.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO ESP32-S3
- Looking up XIAO ESP32-S3 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-S3 and need GPIO reference
- Configuring I2C, SPI, UART, WiFi, BLE, or analog I/O on the XIAO ESP32-S3 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO ESP32-S3 → use the `XIAO-ESP32S3-TinyGo` skill
- For the XIAO ESP32-S3 Sense variant (with camera/mic) → use the `XIAO-ESP32S3-Sense-Arduino` skill
- For other XIAO boards (SAMD21, RP2040, nRF52840, ESP32-C3) → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-S3R8 |
| **Architecture** | Xtensa LX7 dual-core, 32-bit |
| **Clock Speed** | Up to 240 MHz |
| **Flash** | 8 MB |
| **PSRAM** | 8 MB |
| **RAM** | On-chip SRAM (part of ESP32-S3R8) |
| **Wireless** | 2.4 GHz WiFi 802.11 b/g/n, Bluetooth 5.0 (BLE), Bluetooth Mesh |
| **USB** | USB Type-C (native USB OTG) |
| **Operating Voltage** | 3.3V logic; 5V input (Type-C), 3.7V (BAT) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -20°C to 65°C |
| **GPIO Count** | 11 digital/PWM, 9 analog/ADC |
| **Deep Sleep** | ~14 μA |
| **Touch Pins** | 9 (D0–D5, D8–D10) |
| **Antenna** | Onboard ceramic + U.FL connector |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT pads) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/A6/MOSI
    D4/SDA/A4 ──┤ 5          10 ├── D9/A5/MISO
    D5/SCL/A5 ──┤ 6           9 ├── D8/A4/SCK
      D6/TX   ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: BAT+, BAT-, GND
         JTAG pads: MTDO(GPIO40), MTDI(GPIO41),
                    MTCK(GPIO39), MTMS(GPIO42)
         U.FL antenna connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH1 |
| D1  | GPIO2    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH2 |
| D2  | GPIO3    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH3 |
| D3  | GPIO4    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH4 |
| D4  | GPIO5    | ✓       | ADC    | ✓   | **SDA** | — | —  | TOUCH5 |
| D5  | GPIO6    | ✓       | ADC    | ✓   | **SCL** | — | —  | TOUCH6 |
| D6  | GPIO43   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO44   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO7    | ✓       | ADC    | ✓   | —   | **SCK** | — | TOUCH7 |
| D9  | GPIO8    | ✓       | ADC    | ✓   | —   | **MISO** | — | TOUCH8 |
| D10 | GPIO9    | ✓       | ADC    | ✓   | —   | **MOSI** | — | TOUCH9 |

### Bottom JTAG Pads

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MTDO | GPIO40 | JTAG |
| MTDI | GPIO41 | JTAG, ADC |
| MTCK | GPIO39 | JTAG, ADC |
| MTMS | GPIO42 | JTAG, ADC |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_PU | Reset |
| Boot | GPIO0 | Enter bootloader |
| USER_LED | GPIO21 | User LED |
| CHG LED | — | Charge indicator |
| U.FL Antenna | LNA_IN | External antenna connector |

> **Note:** D11 (GPIO42) and D12 (GPIO41) are assigned but do NOT support ADC despite being labeled "Analog" in some documentation.

---

## Arduino Setup

### Board Manager URL

```
https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
```

### Installation

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"esp32"** by Espressif Systems and install it
5. Select **Tools** → **Board** → **ESP32 Arduino** → **XIAO_ESP32S3**
6. Set **Tools** → **USB CDC On Boot** → **Enabled** (for Serial Monitor over USB)

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install esp32:esp32

# Compile
arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32S3 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn esp32:esp32:XIAO_ESP32S3 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
esp32:esp32:XIAO_ESP32S3
```

### Example: Blink (Arduino)

```cpp
const int LED_PIN = 21; // GPIO21 — User LED

void setup() {
    pinMode(LED_PIN, OUTPUT);
}

void loop() {
    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
    delay(500);
}
```

### Example: WiFi Station

```cpp
#include <WiFi.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

void setup() {
    Serial.begin(115200);

    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Connected! IP: ");
    Serial.println(WiFi.localIP());
}

void loop() {
    delay(1000);
}
```

### Example: BLE Peripheral

```cpp
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

void setup() {
    Serial.begin(115200);

    BLEDevice::init("XIAO-ESP32S3");
    pServer = BLEDevice::createServer();

    BLEService* pService = pServer->createService(SERVICE_UUID);
    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE
    );
    pCharacteristic->setValue("Hello from XIAO ESP32-S3");
    pService->start();

    BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->start();

    Serial.println("BLE advertising started");
}

void loop() {
    delay(2000);
}
```

### Example: Touch Sensing

```cpp
void setup() {
    Serial.begin(115200);
}

void loop() {
    int touchValue = touchRead(T1); // D0 / GPIO1 / TOUCH1
    Serial.printf("Touch value: %d\n", touchValue);
    delay(200);
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (GPIO5)
- **SCL:** D5 (GPIO6)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin(); // Uses default SDA=D4, SCL=D5
    // Wire.setClock(400000); // Optional: 400 kHz fast mode
}

void loop() {
    Wire.beginTransmission(0x3C);
    Wire.write(0x00);
    Wire.endTransmission();

    Wire.requestFrom(0x3C, 1);
    if (Wire.available()) {
        uint8_t data = Wire.read();
    }
}
```

### SPI

- **SCK:** D8 (GPIO7)
- **MISO:** D9 (GPIO8)
- **MOSI:** D10 (GPIO9)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = D3; // GPIO4

void setup() {
    pinMode(CS_PIN, OUTPUT);
    digitalWrite(CS_PIN, HIGH);
    SPI.begin(D8, D9, D10, CS_PIN); // SCK, MISO, MOSI, SS
}

void loop() {
    SPI.beginTransaction(SPISettings(4000000, MSBFIRST, SPI_MODE0));
    digitalWrite(CS_PIN, LOW);
    uint8_t result = SPI.transfer(0x00);
    digitalWrite(CS_PIN, HIGH);
    SPI.endTransaction();
}
```

### UART

- **TX:** D6 (GPIO43)
- **RX:** D7 (GPIO44)
- **Arduino object:** `Serial1`
- **USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
void setup() {
    Serial.begin(115200);    // USB serial (Serial Monitor)
    Serial1.begin(9600, SERIAL_8N1, D7, D6); // RX=D7, TX=D6
}

void loop() {
    if (Serial1.available()) {
        char c = Serial1.read();
        Serial.print(c);
    }
}
```

### Analog Read (ADC)

```cpp
void setup() {
    analogReadResolution(12); // 12-bit resolution (0–4095)
    Serial.begin(115200);
}

void loop() {
    int value = analogRead(A0); // D0 / GPIO1
    Serial.println(value);
    delay(100);
}
```

> **Note:** 9 ADC channels on D0–D5 and D8–D10. D6 and D7 (UART TX/RX) do not have ADC.

### WiFi

See the WiFi Station example above. The ESP32-S3 Arduino core provides full WiFi support including:
- `WiFi.h` — Station and AP modes
- `WiFiClient.h` / `WiFiServer.h` — TCP client/server
- `HTTPClient.h` — HTTP requests
- `WebServer.h` — HTTP server
- `WiFiClientSecure.h` — HTTPS/TLS

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Up to 700 mA
- **Deep sleep:** ~14 μA

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

The ESP32-S3 supports deep sleep with ~14 μA current draw:

```cpp
#include <esp_sleep.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Going to sleep in 5 seconds...");
    delay(5000);

    // Timer wake-up: sleep for 10 seconds
    esp_sleep_enable_timer_wakeup(10 * 1000000); // microseconds

    // Or GPIO wake-up:
    // esp_sleep_enable_ext0_wakeup(GPIO_NUM_1, 1); // D0, wake on HIGH

    Serial.println("Entering deep sleep...");
    esp_deep_sleep_start();
}

void loop() {
    // Runs after wake-up (setup() runs again)
}
```

**Wake-up sources:**
- **Timer:** `esp_sleep_enable_timer_wakeup(us)`
- **GPIO:** `esp_sleep_enable_ext0_wakeup(pin, level)`
- **Touch:** `esp_sleep_enable_touchpad_wakeup()`
- **UART:** `esp_sleep_enable_uart_wakeup(0)`

> **Note:** After deep sleep wake-up, the ESP32-S3 restarts from `setup()`. Use RTC memory to persist data across sleep cycles.

```cpp
RTC_DATA_ATTR int bootCount = 0;

void setup() {
    bootCount++;
    Serial.begin(115200);
    Serial.printf("Boot count: %d\n", bootCount);
}
```

---

## Special Features

### USB OTG

The ESP32-S3 has native USB OTG support. In Arduino, this enables:
- USB CDC serial (default)
- USB HID (keyboard, mouse, gamepad)
- USB MSC (mass storage)

```cpp
#include "USB.h"
#include "USBHIDKeyboard.h"

USBHIDKeyboard Keyboard;

void setup() {
    Keyboard.begin();
    USB.begin();
}

void loop() {
    Keyboard.print("Hello from XIAO ESP32-S3!");
    delay(5000);
}
```

### PSRAM (8 MB)

The ESP32-S3R8 includes 8 MB of PSRAM. Enable it in Arduino IDE:
- **Tools** → **PSRAM** → **OPI PSRAM**

```cpp
void setup() {
    Serial.begin(115200);

    // Allocate memory from PSRAM
    uint8_t* buffer = (uint8_t*)ps_malloc(1024 * 1024); // 1 MB
    if (buffer) {
        Serial.println("PSRAM allocation successful!");
        free(buffer);
    }

    Serial.printf("Total PSRAM: %d bytes\n", ESP.getPsramSize());
    Serial.printf("Free PSRAM: %d bytes\n", ESP.getFreePsram());
}
```

### Dual-Core

The ESP32-S3 has dual Xtensa LX7 cores. Use FreeRTOS tasks to leverage both:

```cpp
void task1(void* parameter) {
    for (;;) {
        Serial.println("Task 1 on core " + String(xPortGetCoreID()));
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
}

void setup() {
    Serial.begin(115200);
    xTaskCreatePinnedToCore(task1, "Task1", 4096, NULL, 1, NULL, 0); // Core 0
}

void loop() {
    Serial.println("Loop on core " + String(xPortGetCoreID()));
    delay(1000);
}
```

### Touch Sensing

9 capacitive touch pins available (D0–D5, D8–D10):

```cpp
void setup() {
    Serial.begin(115200);
}

void loop() {
    Serial.printf("T1=%d T2=%d T3=%d\n",
        touchRead(T1),  // D0 / GPIO1
        touchRead(T2),  // D1 / GPIO2
        touchRead(T3)); // D2 / GPIO3
    delay(200);
}
```

---

## Common Gotchas / Notes

1. **Enable USB CDC On Boot** — Set **Tools** → **USB CDC On Boot** → **Enabled** for Serial Monitor to work over USB
2. **User LED on GPIO21** — Active HIGH
3. **9 ADC channels** — D0–D5 and D8–D10 all support analog input
4. **D6/D7 no ADC** — UART TX/RX pins (GPIO43/44) do not support analog input
5. **JTAG pads on bottom** — GPIO39–42 accessible via bottom solder pads; D11/D12 do NOT support ADC
6. **Boot mode** — Hold BOOT, press RESET, release BOOT to enter bootloader
7. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
8. **PSRAM must be enabled** — Select OPI PSRAM in Tools menu to use the 8 MB PSRAM
9. **WiFi + BLE coexistence** — Both can run simultaneously but share the radio; throughput may be reduced
10. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/
- **Board package (Espressif):** https://github.com/espressif/arduino-esp32
- **ESP32-S3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf
- **ESP32-S3 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf
- **Arduino-ESP32 docs:** https://docs.espressif.com/projects/arduino-esp32/
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/XIAO_ESP32S3_SCH_v1.2.pdf
