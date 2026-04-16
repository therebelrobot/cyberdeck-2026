---
name: xiao-esp32c3-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO ESP32-C3 microcontroller. Use when writing Arduino firmware for the
  XIAO ESP32-C3, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-C3, Arduino,
  Espressif, RISC-V, WiFi, BLE, Bluetooth, pinout, GPIO, I2C, SPI, UART, analog, digital,
  PWM, battery, deep sleep, antenna, ESP-IDF.
---

# XIAO ESP32-C3 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO ESP32-C3.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO ESP32-C3
- Looking up XIAO ESP32-C3 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-C3 and need GPIO reference
- Configuring I2C, SPI, UART, WiFi, BLE, or analog I/O on the XIAO ESP32-C3 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO ESP32-C3 → use the `XIAO-ESP32C3-TinyGo` skill
- For other XIAO boards (SAMD21, RP2040, nRF52840) → use the corresponding board skill
- For other ESP32 variants (ESP32-S3, ESP32-C6) → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C3 |
| **Architecture** | 32-bit RISC-V single-core |
| **Clock Speed** | Up to 160 MHz |
| **Flash** | 4 MB onboard |
| **RAM** | 400 KB SRAM |
| **Wireless** | WiFi 802.11 b/g/n (2.4 GHz), Bluetooth 5.0 (BLE), Bluetooth Mesh |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Max 3.3V Output** | 500 mA |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 11 digital/PWM, 4 analog/ADC |
| **Deep Sleep** | ~44 μA |
| **WiFi Active** | ~75 mA |
| **Antenna** | External U.FL antenna (included) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT input) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
    D4/SDA    ──┤ 5          10 ├── D9/MISO
    D5/SCL    ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: GND, RST, BAT+, BAT-
         U.FL antenna connector on top edge
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO2    | ✓       | ADC1_2 | ✓   | —   | —   | —    | **⚠ Strapping** |
| D1  | GPIO3    | ✓       | ADC1_3 | ✓   | —   | —   | —    | — |
| D2  | GPIO4    | ✓       | ADC1_4 | ✓   | —   | —   | —    | MTMS/JTAG |
| D3  | GPIO5    | ✓       | ADC2_0 | ✓   | —   | —   | —    | MTDI/JTAG |
| D4  | GPIO6    | ✓       | —      | ✓   | **SDA** | — | —  | MTCK/JTAG |
| D5  | GPIO7    | ✓       | —      | ✓   | **SCL** | — | —  | MTDO/JTAG |
| D6  | GPIO21   | ✓       | —      | ✓   | —   | —   | **TX** | U0TXD |
| D7  | GPIO20   | ✓       | —      | ✓   | —   | —   | **RX** | U0RXD |
| D8  | GPIO8    | ✓       | —      | ✓   | —   | **SCK** | — | **⚠ Strapping** |
| D9  | GPIO9    | ✓       | —      | ✓   | —   | **MISO** | — | **⚠ Strapping/Boot** |
| D10 | GPIO10   | ✓       | —      | ✓   | —   | **MOSI** | — | FSPICS0 |

### Strapping Pins Warning

| Pin | GPIO | Boot Effect |
|-----|------|-------------|
| D0  | GPIO2 | Must be floating or HIGH at boot |
| D8  | GPIO8 | Must be HIGH at boot (has internal pull-up) |
| D9  | GPIO9 | Boot button — LOW enters download mode |

**⚠ Do NOT place external pull-downs on D0, D8, or D9** — this can prevent the board from booting.

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_EN | Enable/Reset |
| Boot | GPIO9 | Enter bootloader (same as D9) |
| U.FL Antenna | LNA_IN | External antenna connector |
| CHG LED | VCC_3V3 | Charge indicator |

> **Note:** There is NO built-in user LED on the XIAO ESP32-C3. `LED_BUILTIN` is not defined.

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
5. Select **Tools** → **Board** → **ESP32 Arduino** → **XIAO_ESP32C3**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install esp32:esp32

# Compile
arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32C3 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn esp32:esp32:XIAO_ESP32C3 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
esp32:esp32:XIAO_ESP32C3
```

### Example: Blink External LED (Arduino)

```cpp
// No built-in LED — use an external LED on D0
const int LED_PIN = D0; // GPIO2

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
    // Your application code
    delay(1000);
}
```

### Example: WiFi Access Point

```cpp
#include <WiFi.h>

const char* ap_ssid = "XIAO-ESP32C3-AP";
const char* ap_password = "12345678";

void setup() {
    Serial.begin(115200);

    WiFi.softAP(ap_ssid, ap_password);
    Serial.print("AP IP: ");
    Serial.println(WiFi.softAPIP());
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

    BLEDevice::init("XIAO-ESP32C3");
    pServer = BLEDevice::createServer();

    BLEService* pService = pServer->createService(SERVICE_UUID);
    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE
    );
    pCharacteristic->setValue("Hello from XIAO ESP32-C3");
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

---

## Communication Protocols

### I2C

- **SDA:** D4 (GPIO6)
- **SCL:** D5 (GPIO7)
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

- **SCK:** D8 (GPIO8)
- **MISO:** D9 (GPIO9)
- **MOSI:** D10 (GPIO10)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = D7; // GPIO20

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

> **⚠ Warning:** D8 (GPIO8) and D9 (GPIO9) are strapping pins. SPI devices connected to these pins must not pull them LOW during boot.

### UART

- **TX:** D6 (GPIO21)
- **RX:** D7 (GPIO20)
- **Arduino object:** `Serial0` or `Serial1` (configurable)
- **USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
// USB Serial uses the built-in USB-CDC
// Hardware UART on D6/D7 uses Serial1

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
    int value = analogRead(A0); // D0 / GPIO2
    Serial.println(value);
    delay(100);
}
```

> **Note:** Only D0–D3 support analog input. D3 (GPIO5/ADC2) may give unreliable readings when WiFi is active; prefer D0–D2 (ADC1 channels).

### WiFi

See the WiFi Station and Access Point examples above. The ESP32-C3 Arduino core provides full WiFi support including:
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
- **3.3V output:** Up to 500 mA
- **WiFi active:** ~75 mA
- **Deep sleep:** ~44 μA

### Battery Support

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

The ESP32-C3 supports deep sleep with ~44 μA current draw:

```cpp
#include <esp_sleep.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Going to sleep in 5 seconds...");
    delay(5000);

    // Timer wake-up: sleep for 10 seconds
    esp_sleep_enable_timer_wakeup(10 * 1000000); // microseconds

    // Or GPIO wake-up (D0–D3 only):
    // esp_sleep_enable_ext0_wakeup(GPIO_NUM_2, 1); // D0, wake on HIGH

    Serial.println("Entering deep sleep...");
    esp_deep_sleep_start();
    // Code after this line will not execute
}

void loop() {
    // This runs after wake-up (setup() runs again)
}
```

**Wake-up sources:**
- **Timer:** `esp_sleep_enable_timer_wakeup(us)`
- **GPIO:** `esp_sleep_enable_ext0_wakeup(pin, level)` — D0–D3 only
- **UART:** `esp_sleep_enable_uart_wakeup(0)`

> **Note:** After deep sleep wake-up, the ESP32-C3 restarts from `setup()`. Use RTC memory to persist data across sleep cycles.

```cpp
// Persist data across deep sleep
RTC_DATA_ATTR int bootCount = 0;

void setup() {
    bootCount++;
    Serial.begin(115200);
    Serial.printf("Boot count: %d\n", bootCount);
}
```

---

## Common Gotchas / Notes

1. **No built-in LED** — There is no user LED on the XIAO ESP32-C3; connect an external LED for blink tests
2. **Strapping pins** — D0 (GPIO2), D8 (GPIO8), D9 (GPIO9) affect boot mode; do NOT pull them LOW externally
3. **D9 is the Boot button** — Holding D9 LOW during reset enters download mode
4. **Only 4 analog pins** — D0–D3 have ADC; D4–D10 are digital only
5. **ADC2 unreliable with WiFi** — D3 (GPIO5/ADC2_CH0) may give unreliable readings when WiFi is active; prefer D0–D2 (ADC1)
6. **External antenna required** — Uses U.FL connector; the included antenna must be connected for WiFi/BLE
7. **JTAG on D2–D5** — These pins double as JTAG (MTMS, MTDI, MTCK, MTDO); avoid conflicts during debugging
8. **Deep sleep wake** — Only D0–D3 support deep sleep GPIO wake-up
9. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART (must specify pins)
10. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
11. **WiFi + BLE coexistence** — Both can run simultaneously but share the radio; throughput may be reduced

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/
- **Board package (Espressif):** https://github.com/espressif/arduino-esp32
- **ESP32-C3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-c3_datasheet_en.pdf
- **ESP32-C3 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-c3_technical_reference_manual_en.pdf
- **Arduino-ESP32 docs:** https://docs.espressif.com/projects/arduino-esp32/
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO_WiFi/Resources/Seeed-Studio-XIAO-ESP32C3-v1.2.pdf
