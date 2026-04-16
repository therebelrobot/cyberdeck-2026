---
name: xiao-esp32c5-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO ESP32-C5 microcontroller. Use when writing Arduino firmware for the
  XIAO ESP32-C5, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-C5, Arduino,
  Espressif, RISC-V, WiFi 6, dual-band, 5GHz, 2.4GHz, BLE 5.0, Bluetooth, pinout, GPIO, I2C,
  SPI, UART, analog, digital, PWM, battery, deep sleep, PSRAM, 8MB, ESP-IDF.
---

# XIAO ESP32-C5 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO ESP32-C5.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO ESP32-C5
- Looking up XIAO ESP32-C5 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-C5 and need GPIO reference
- Configuring I2C, SPI, UART, WiFi 6, BLE, or analog I/O on the XIAO ESP32-C5 in Arduino

## When NOT to Use

- For TinyGo development on the XIAO ESP32-C5 → use the `XIAO-ESP32C5-TinyGo` skill
- For the XIAO ESP32-C3 (older single-band WiFi) → use the `XIAO-ESP32C3-Arduino` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C5 |
| **Architecture** | 32-bit RISC-V single-core |
| **Clock Speed** | 240 MHz |
| **Flash** | 8 MB |
| **PSRAM** | 8 MB |
| **On-chip SRAM** | 384 KB |
| **On-chip ROM** | 320 KB |
| **Wireless** | WiFi 6 (802.11 a/b/g/n/ac/ax) dual-band 2.4 GHz + 5 GHz, BLE 5.0, Bluetooth Mesh |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic |
| **Dimensions** | 21 × 17.8 mm |
| **GPIO Count** | 11 (all PWM-capable) |
| **Analog Pins** | 5 (D0 + JTAG pads) |
| **Battery Charge Chip** | SGM40567 |
| **Antenna** | External RF antenna (U.FL connector) |
| **Buttons** | 1× RESET, 1× BOOT (GPIO28) |

---

## Pinout Diagram

```
            XIAO ESP32-C5 (Top View)
                ┌─────────────────┐
                │    [USB-C]      │
       D0/A0 ──┤ GPIO1   GPIO12 ├── D7 (RX)
          D1 ──┤ GPIO0   GPIO11 ├── D6 (TX)
          D2 ──┤ GPIO25  GPIO24 ├── D5 (SCL)
          D3 ──┤ GPIO7   GPIO23 ├── D4 (SDA)
         GND ──┤                 ├── D10 (MOSI)
          5V ──┤                 ├── D9 (MISO)
         3V3 ──┤                 ├── D8 (SCK)
                └─────────────────┘
  Bottom pads: JTAG (MTDO/MTDI/MTCK/MTMS), Boot
  External antenna: U.FL connector
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | LP_UART_DSRN, LP_GPIO1 |
| D1  | GPIO0    | ✓       | —      | ✓   | —   | —   | —    | LP_UART_DTRN, LP_GPIO0 |
| D2  | GPIO25   | ✓       | —      | ✓   | —   | —   | —    | — |
| D3  | GPIO7    | ✓       | —      | ✓   | —   | —   | —    | SDIO_DATA1 |
| D4  | GPIO23   | ✓       | —      | ✓   | **SDA** | — | — | — |
| D5  | GPIO24   | ✓       | —      | ✓   | **SCL** | — | — | — |
| D6  | GPIO11   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO12   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO8    | ✓       | —      | ✓   | —   | **SCK** | — | TOUCH7 |
| D9  | GPIO9    | ✓       | —      | ✓   | —   | **MISO** | — | TOUCH8 |
| D10 | GPIO10   | ✓       | —      | ✓   | —   | **MOSI** | — | TOUCH9 |

### Bottom Pads (JTAG / Debug)

| Name | Chip Pin | Analog | Other |
|------|----------|--------|-------|
| MTDO | GPIO5    | —      | LP_UART_TXD, LP_GPIO5, JTAG |
| MTDI | GPIO3    | ADC    | LP_I2C_SCL, LP_GPIO3, JTAG |
| MTCK | GPIO4    | ADC    | LP_UART_RXD, LP_GPIO4, JTAG |
| MTMS | GPIO2    | ADC    | LP_I2C_SDA, LP_GPIO2, JTAG |
| ADC_BAT | GPIO6 | —      | Battery voltage measurement |
| ADC_CRL | GPIO26 | —     | Enable/disable battery measurement circuit |
| Boot | GPIO28   | —      | Enter Boot Mode |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| USER_LED | GPIO27 | User LED (Yellow) |
| CHARGE_LED | VCC_3V3 | Charge LED (Red) |
| Boot | GPIO28 | Boot button |

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
4. Search for **"esp32"** by Espressif Systems and install it (version 3.x+ required for C5 support)
5. Select **Tools** → **Board** → **ESP32 Arduino** → **XIAO_ESP32C5**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install esp32:esp32

# Compile
arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32C5 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn esp32:esp32:XIAO_ESP32C5 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
esp32:esp32:XIAO_ESP32C5
```

### Example: Blink LED (Arduino)

```cpp
// Built-in User LED is on GPIO27 (Yellow)

void setup() {
    pinMode(LED_BUILTIN, OUTPUT); // GPIO27
}

void loop() {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
}
```

### Example: WiFi 6 Station (Dual-Band)

```cpp
#include <WiFi.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

void setup() {
    Serial.begin(115200);

    // WiFi 6 dual-band — connects to 2.4 GHz or 5 GHz automatically
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    Serial.print("Connecting to WiFi 6");
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

### Example: WiFi Access Point

```cpp
#include <WiFi.h>

const char* ap_ssid = "XIAO-ESP32C5-AP";
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

    BLEDevice::init("XIAO-ESP32C5");
    pServer = BLEDevice::createServer();

    BLEService* pService = pServer->createService(SERVICE_UUID);
    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE
    );
    pCharacteristic->setValue("Hello from XIAO ESP32-C5");
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

- **SDA:** D4 (GPIO23)
- **SCL:** D5 (GPIO24)
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

const int CS_PIN = D0; // GPIO1

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

- **TX:** D6 (GPIO11)
- **RX:** D7 (GPIO12)
- **USB Serial:** `Serial` (USB CDC — for Serial Monitor)
- **Hardware UART:** `Serial1`

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
    analogReadResolution(12); // 12-bit resolution (0-4095)
    Serial.begin(115200);
}

void loop() {
    int value = analogRead(A0); // D0 / GPIO1
    Serial.println(value);
    delay(100);
}
```

> **Note:** Only D0 (GPIO1) has ADC on the edge pins. Additional ADC channels are on the bottom JTAG pads (MTDI/GPIO3, MTCK/GPIO4, MTMS/GPIO2).

### WiFi 6 (Dual-Band)

See the WiFi Station and Access Point examples above. The ESP32-C5 Arduino core provides full WiFi 6 support including:
- `WiFi.h` — Station and AP modes (2.4 GHz + 5 GHz)
- `WiFiClient.h` / `WiFiServer.h` — TCP client/server
- `HTTPClient.h` — HTTP requests
- `WebServer.h` — HTTP server
- `WiFiClientSecure.h` — HTTPS/TLS
- Concurrent SoftAP + Station mode
- Promiscuous (monitor) mode

### Touch Sensing

```cpp
void setup() {
    Serial.begin(115200);
}

void loop() {
    int touchValue = touchRead(D8); // GPIO8 / TOUCH7
    Serial.print("Touch D8: ");
    Serial.println(touchValue);
    delay(100);
}
```

> **Note:** D8 (TOUCH7), D9 (TOUCH8), D10 (TOUCH9) support capacitive touch sensing.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **Battery charge chip:** SGM40567

### Battery Support

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Red LED indicates charging status
- **Battery voltage:** Read via ADC_BAT (GPIO6)
- **Battery measurement control:** ADC_CRL (GPIO26) enables/disables the measurement circuit

```cpp
void setup() {
    Serial.begin(115200);
    pinMode(26, OUTPUT);      // ADC_CRL — GPIO26
    digitalWrite(26, HIGH);   // Enable battery measurement circuit
}

void loop() {
    int raw = analogRead(6);  // ADC_BAT — GPIO6
    float voltage = raw * (3.3 / 4095.0) * 2.0; // Voltage divider factor
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");
    delay(1000);
}
```

### Deep Sleep

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
    // This runs after wake-up (setup() runs again)
}
```

**Wake-up sources:**
- **Timer:** `esp_sleep_enable_timer_wakeup(us)`
- **GPIO:** `esp_sleep_enable_ext0_wakeup(pin, level)`
- **UART:** `esp_sleep_enable_uart_wakeup(0)`

> **⚠ Warning:** Do NOT use JTAG pins (MTDO/MTDI/MTCK/MTMS on bottom pads) as deep sleep wake-up sources.

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

## Special Features

### First Dual-Band WiFi 6 XIAO

The XIAO ESP32-C5 is the first XIAO board with dual-band WiFi 6 support:
- **2.4 GHz** — Compatible with existing networks, better range
- **5 GHz** — Less interference, higher throughput
- **802.11ax (WiFi 6)** — Improved efficiency, OFDMA, Target Wake Time

### 8 MB PSRAM

Large external PSRAM (8 MB) enables memory-intensive applications:

```cpp
// PSRAM is automatically available when enabled in board settings
// Use ps_malloc() for PSRAM allocation
void* buffer = ps_malloc(1024 * 1024); // Allocate 1 MB from PSRAM
if (buffer) {
    Serial.println("PSRAM allocation successful");
    free(buffer);
}
```

### 8 MB Flash

Generous flash storage for firmware, file systems, and OTA:

```cpp
#include <LittleFS.h>

void setup() {
    Serial.begin(115200);
    if (!LittleFS.begin(true)) {
        Serial.println("LittleFS mount failed");
        return;
    }
    Serial.println("LittleFS mounted — 8 MB flash available");
}
```

### RISC-V @ 240 MHz

The fastest RISC-V XIAO board at 240 MHz clock speed.

### Touch Pins

D8 (TOUCH7), D9 (TOUCH8), D10 (TOUCH9) support capacitive touch sensing.

### Low-Power Peripherals

LP_UART, LP_I2C, and LP_GPIO available for ultra-low-power operation.

### Security Features

- AES-128/256 hardware acceleration
- SHA family hardware acceleration
- HMAC
- Digital signature peripheral
- Secure Boot V2

---

## Common Gotchas / Notes

1. **JTAG pin restrictions** — Bottom pad pins (MTDO/MTDI/MTCK/MTMS) are JTAG; do NOT use as deep sleep wake-up sources
2. **External antenna only** — Uses U.FL connector; an external antenna must be connected for WiFi/BLE
3. **Limited analog pins on edges** — Only D0 (GPIO1) has ADC on the edge pins; additional ADC on bottom JTAG pads
4. **Boot button** — GPIO28 is the BOOT button; hold during reset to enter download mode
5. **Strapping pins** — Some GPIO pins affect boot behavior; check ESP32-C5 datasheet
6. **SDIO on D3** — GPIO7 (D3) has SDIO_DATA1 alternate function; avoid conflicts if using SDIO
7. **ESP32 Arduino core v3+** — Requires version 3.x or later of the ESP32 Arduino core for C5 support
8. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART (must specify pins)
9. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
10. **WiFi + BLE coexistence** — Both can run simultaneously but share the radio; throughput may be reduced
11. **PSRAM** — 8 MB PSRAM available; use `ps_malloc()` for large allocations
12. **Dual-band WiFi** — The board automatically selects 2.4 GHz or 5 GHz based on the network

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32c5_getting_started/
- **Board package (Espressif):** https://github.com/espressif/arduino-esp32
- **ESP32-C5 Datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-c5_datasheet_en.pdf
- **ESP32-C5 Technical Reference:** https://www.espressif.com/sites/default/files/documentation/esp32-c5_technical_reference_manual_en.pdf
- **Arduino-ESP32 docs:** https://docs.espressif.com/projects/arduino-esp32/
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C5/res/XIAO_ESP32-C5_Schematic.pdf
