---
name: xiao-esp32c6-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO ESP32-C6 microcontroller. Use when writing Arduino firmware for the
  XIAO ESP32-C6, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-C6, Arduino,
  Espressif, RISC-V, WiFi 6, BLE, Bluetooth, Zigbee, Thread, Matter, 802.15.4, pinout, GPIO,
  I2C, SPI, UART, analog, digital, PWM, deep sleep, battery, low-power, ESP-IDF, smart home.
---

# XIAO ESP32-C6 — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO ESP32-C6.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO ESP32-C6
- Looking up XIAO ESP32-C6 pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the XIAO ESP32-C6 and need GPIO reference
- Configuring I2C, SPI, UART, WiFi 6, BLE, Zigbee, Thread, or analog I/O in Arduino

## When NOT to Use

- For TinyGo development on the XIAO ESP32-C6 → use the `XIAO-ESP32C6-TinyGo` skill
- For the XIAO ESP32-C3 (different MCU) → use the `XIAO-ESP32C3-Arduino` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-C6 |
| **Architecture** | Dual 32-bit RISC-V (HP: up to 160 MHz, LP: up to 20 MHz) |
| **Clock Speed** | 160 MHz (HP core), 20 MHz (LP core) |
| **Flash** | 4 MB |
| **RAM** | 512 KB SRAM |
| **Wireless** | WiFi 6 (802.11ax), Bluetooth 5.0 (BLE), Zigbee, Thread (IEEE 802.15.4) |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V logic; 5V input (Type-C), 3.7V (BAT) |
| **Dimensions** | 21 × 17.8 mm |
| **Working Temp** | -40°C to 85°C |
| **GPIO Count** | 11 digital/PWM, 7 analog/ADC |
| **Deep Sleep** | ~15 μA |
| **Antenna** | Onboard ceramic + U.FL connector (RF switch via GPIO14/GPIO3) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT pads) |
| **Security** | Secure boot, encryption, Trusted Execution Environment (TEE) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
        D3    ──┤ 4          11 ├── D10/MOSI
     D4/SDA   ──┤ 5          10 ├── D9/MISO
     D5/SCL   ──┤ 6           9 ├── D8/SCK
      D6/TX   ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: BAT+, BAT-, GND
         JTAG pads: MTDO(GPIO7), MTDI(GPIO5),
                    MTCK(GPIO6), MTMS(GPIO4)
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO0    | ✓       | ADC    | ✓   | —   | —   | —    | LP_GPIO0 |
| D1  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | LP_GPIO1 |
| D2  | GPIO2    | ✓       | ADC    | ✓   | —   | —   | —    | LP_GPIO2 |
| D3  | GPIO21   | ✓       | —      | ✓   | —   | —   | —    | SDIO_DATA1 |
| D4  | GPIO22   | ✓       | —      | ✓   | **SDA** | — | —  | SDIO_DATA2 |
| D5  | GPIO23   | ✓       | —      | ✓   | **SCL** | — | —  | SDIO_DATA3 |
| D6  | GPIO16   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO17   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO19   | ✓       | —      | ✓   | —   | **SCK** | — | SPI_CLK |
| D9  | GPIO20   | ✓       | —      | ✓   | —   | **MISO** | — | SPI_MISO |
| D10 | GPIO18   | ✓       | —      | ✓   | —   | **MOSI** | — | SPI_MOSI |

### Bottom JTAG Pads

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MTDO | GPIO7 | JTAG |
| MTDI | GPIO5 | JTAG, ADC |
| MTCK | GPIO6 | JTAG, ADC |
| MTMS | GPIO4 | JTAG, ADC |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_PU | Reset |
| Boot | GPIO9 | Enter bootloader |
| USER_LED | GPIO15 | User LED |
| RF Switch Select | GPIO14 | Toggle onboard/UFL antenna |
| RF Switch Power | GPIO3 | Power for RF switch (set LOW first) |

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
4. Search for **"esp32"** by Espressif Systems and install it (≥ 3.0.0 for C6 support)
5. Select **Tools** → **Board** → **ESP32 Arduino** → **XIAO_ESP32C6**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install esp32:esp32

# Compile
arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32C6 ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn esp32:esp32:XIAO_ESP32C6 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
esp32:esp32:XIAO_ESP32C6
```

### Example: Blink (Arduino)

```cpp
const int LED_PIN = 15; // GPIO15 — User LED

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

### Example: WiFi 6 Station

```cpp
#include <WiFi.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

void setup() {
    Serial.begin(115200);

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

    BLEDevice::init("XIAO-ESP32C6");
    pServer = BLEDevice::createServer();

    BLEService* pService = pServer->createService(SERVICE_UUID);
    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE
    );
    pCharacteristic->setValue("Hello from XIAO ESP32-C6");
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

- **SDA:** D4 (GPIO22)
- **SCL:** D5 (GPIO23)
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

- **SCK:** D8 (GPIO19)
- **MISO:** D9 (GPIO20)
- **MOSI:** D10 (GPIO18)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = D3; // GPIO21

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

- **TX:** D6 (GPIO16)
- **RX:** D7 (GPIO17)
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
    int value = analogRead(A0); // D0 / GPIO0
    Serial.println(value);
    delay(100);
}
```

> **Note:** Only D0–D2 (GPIO0–2) have ADC on edge pins. Additional ADC channels on bottom JTAG pads (GPIO4–6). D3–D10 edge pins are digital only.

### WiFi

See the WiFi 6 Station example above. The ESP32-C6 Arduino core provides full WiFi support:
- `WiFi.h` — Station and AP modes (WiFi 6 / 802.11ax)
- `WiFiClient.h` / `WiFiServer.h` — TCP client/server
- `HTTPClient.h` — HTTP requests
- `WebServer.h` — HTTP server
- `WiFiClientSecure.h` — HTTPS/TLS

### Zigbee / Thread / Matter

The ESP32-C6 supports IEEE 802.15.4 for Zigbee and Thread, enabling Matter smart home interoperability:

```cpp
// Zigbee/Thread requires the ESP-Zigbee-SDK or ESP-Thread libraries
// These are available through the ESP-IDF framework
// Arduino support is evolving — check Espressif's Arduino-ESP32 releases

// For Matter development, see:
// https://github.com/espressif/esp-matter
// https://github.com/espressif/arduino-esp32/tree/master/libraries/Zigbee
```

> **Note:** Zigbee/Thread/Matter support in Arduino is evolving. For production Matter devices, consider using ESP-IDF directly.

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Deep sleep:** ~15 μA

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

The ESP32-C6 supports deep sleep with ~15 μA current draw:

```cpp
#include <esp_sleep.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Going to sleep in 5 seconds...");
    delay(5000);

    // Timer wake-up: sleep for 10 seconds
    esp_sleep_enable_timer_wakeup(10 * 1000000); // microseconds

    // Or GPIO wake-up (D0/GPIO0 supports external wake-up):
    // esp_sleep_enable_ext0_wakeup(GPIO_NUM_0, 1); // D0, wake on HIGH

    Serial.println("Entering deep sleep...");
    esp_deep_sleep_start();
}

void loop() {}
```

**Wake-up sources:**
- **Timer:** `esp_sleep_enable_timer_wakeup(us)`
- **GPIO:** `esp_sleep_enable_ext0_wakeup(pin, level)` — D0 (GPIO0) recommended
- **UART:** `esp_sleep_enable_uart_wakeup(0)`

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

### WiFi 6 (802.11ax)

The ESP32-C6 supports WiFi 6 for improved power efficiency, better performance in congested networks, and Target Wake Time (TWT) for IoT devices. The WiFi API is the same as other ESP32 variants.

### Zigbee / Thread / Matter

Native IEEE 802.15.4 support enables:
- **Zigbee:** Direct communication with Zigbee devices (lights, sensors, switches)
- **Thread:** Mesh networking protocol for IoT
- **Matter:** Cross-platform smart home standard (over Thread or WiFi)

### Dual RISC-V Processors

- **HP core:** Up to 160 MHz — main application processor
- **LP core:** Up to 20 MHz — can run independently during deep sleep for sensor monitoring

```cpp
// LP core programming requires ESP-IDF ULP (Ultra Low Power) framework
// Not directly available through Arduino API
// See: https://docs.espressif.com/projects/esp-idf/en/latest/esp32c6/api-reference/system/ulp.html
```

### Low-Power Peripherals

- **LP_UART:** Low-power UART that can operate during deep sleep
- **LP_I2C:** Low-power I2C that can operate during deep sleep

These require ESP-IDF APIs and are not directly available through the Arduino framework.

### RF Switch (Antenna Selection)

Toggle between onboard ceramic antenna and external U.FL antenna:

```cpp
void setup() {
    // Enable RF switch
    pinMode(3, OUTPUT);   // GPIO3 — RF switch power
    digitalWrite(3, LOW); // Power on RF switch

    // Select antenna
    pinMode(14, OUTPUT);    // GPIO14 — RF switch select
    digitalWrite(14, HIGH); // HIGH = external U.FL antenna
    // digitalWrite(14, LOW); // LOW = onboard ceramic antenna
}
```

> **⚠ Important:** Set GPIO3 LOW before changing GPIO14. The RF switch must be powered before selecting an antenna.

---

## Common Gotchas / Notes

1. **Only 3 analog pins on edge** — D0–D2 (GPIO0–2) have ADC; additional ADC on bottom JTAG pads
2. **D3 is digital only** — Unlike other XIAO boards, D3 (GPIO21) has no ADC
3. **Arduino-ESP32 ≥ 3.0.0 required** — ESP32-C6 support was added in version 3.0.0
4. **RF switch pins** — GPIO3 and GPIO14 are used internally for antenna selection; avoid using them for other purposes
5. **Boot mode** — Hold BOOT, press RESET, release BOOT to enter bootloader
6. **User LED on GPIO15** — Check active level for your board revision
7. **Zigbee/Thread evolving** — Arduino support for 802.15.4 protocols is still maturing
8. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
9. **Wide temperature range** — -40°C to 85°C (wider than most XIAO boards)
10. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7
11. **WiFi + BLE coexistence** — Both can run simultaneously but share the radio

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/
- **Board package (Espressif):** https://github.com/espressif/arduino-esp32
- **ESP32-C6 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-c6_datasheet_en.pdf
- **ESP32-C6 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-c6_technical_reference_manual_en.pdf
- **Arduino-ESP32 docs:** https://docs.espressif.com/projects/arduino-esp32/
- **ESP-Zigbee-SDK:** https://github.com/espressif/esp-zigbee-sdk
- **ESP-Matter:** https://github.com/espressif/esp-matter
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C6/XIAO_ESP32-C6_v1.0_SCH.pdf
