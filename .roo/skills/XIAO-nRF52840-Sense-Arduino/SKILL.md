---
name: xiao-nrf52840-sense-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO nRF52840 Sense microcontroller. Use when writing Arduino firmware for the
  XIAO nRF52840 Sense, wiring peripherals, or configuring pins. Keywords: XIAO, nRF52840, Sense,
  Arduino, Nordic, Cortex-M4, BLE, Bluetooth, NFC, IMU, accelerometer, gyroscope, microphone, PDM,
  LSM6DS3TR, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, battery, mbed.
---

# XIAO nRF52840 Sense — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO nRF52840 Sense.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO nRF52840 Sense
- Looking up XIAO nRF52840 Sense pin assignments, alternate functions, or peripheral mappings
- Using the onboard IMU (accelerometer/gyroscope) or PDM microphone in Arduino
- Configuring I2C, SPI, UART, BLE, or analog I/O on the XIAO nRF52840 Sense in Arduino

## When NOT to Use

- For TinyGo development on the XIAO nRF52840 Sense → use the `XIAO-nRF52840-Sense-TinyGo` skill
- For the base XIAO nRF52840 (without IMU/mic) → use the `XIAO-nRF52840-Arduino` skill
- For other XIAO boards (SAMD21, RP2040, ESP32-C3) → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Nordic nRF52840 |
| **Architecture** | ARM Cortex-M4 32-bit with FPU |
| **Clock Speed** | 64 MHz |
| **Flash** | 1 MB internal + 2 MB onboard |
| **RAM** | 256 KB |
| **Wireless** | Bluetooth Low Energy 5.4, Bluetooth Mesh, NFC |
| **USB** | USB Type-C |
| **Operating Voltage** | 3.3V MCU / 5V input |
| **Dimensions** | 21 × 17.8 mm |
| **GPIO Count** | 14 pads (11 digital/PWM, 6 analog/ADC) |
| **IMU** | LSM6DS3TR-C 6-axis (accelerometer + gyroscope) |
| **Microphone** | PDM digital microphone (MSM261D3526H1CPM) |
| **Onboard** | 3-in-one RGB LED, Charge LED, Reset Button |
| **Battery** | BQ25101 charge chip, supports LiPo charge/discharge |
| **Standby Power** | < 5 μA |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
      D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/MOSI
   D4/A4/SDA  ──┤ 5          10 ├── D9/MISO
   D5/A5/SCL  ──┤ 6           9 ├── D8/SCK
     D6/TX    ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: GND, RST, NFC1, NFC2, 3V3, BAT

    Internal (not on pads):
      IMU (LSM6DS3TR-C) on internal I2C
      PDM Microphone on internal PDM bus
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | P0.02    | ✓       | AIN0   | ✓   | —   | —   | —    | — |
| D1  | P0.03    | ✓       | AIN1   | ✓   | —   | —   | —    | — |
| D2  | P0.28    | ✓       | AIN4   | ✓   | —   | —   | —    | — |
| D3  | P0.29    | ✓       | AIN5   | ✓   | —   | —   | —    | — |
| D4  | P0.04    | ✓       | AIN2   | ✓   | **SDA** | — | —  | — |
| D5  | P0.05    | ✓       | AIN3   | ✓   | **SCL** | — | —  | — |
| D6  | P1.11    | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | P1.12    | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | P1.13    | ✓       | —      | ✓   | —   | **SCK** | — | — |
| D9  | P1.14    | ✓       | —      | ✓   | —   | **MISO** | — | — |
| D10 | P1.15    | ✓       | —      | ✓   | —   | **MOSI** | — | — |

### Internal / LED / Sensor Pins

| Name | Chip Pin | Arduino Constant | Description |
|------|----------|------------------|-------------|
| USER_LED_R | P0.26 | `LED_RED` / `LEDR` | Red RGB LED — active LOW |
| USER_LED_G | P0.30 | `LED_GREEN` / `LEDG` | Green RGB LED — active LOW |
| USER_LED_B | P0.06 | `LED_BLUE` / `LEDB` / `LED_BUILTIN` | Blue RGB LED — active LOW |
| CHARGE_LED | P0.17 | — | Charge indicator (Red) |
| NFC1 | P0.09 | — | NFC antenna pad (bottom) |
| NFC2 | P0.10 | — | NFC antenna pad (bottom) |
| ADC_BAT | P0.14 | `PIN_VBAT` | Battery voltage sense |
| CHG_RATE | P0.13 | — | Charge rate: HIGH=50mA, LOW=100mA |
| IMU_PWR | P1.08 | `IMU_PWR` | Power switch for IMU module |
| IMU_INT1 | P0.11 | `IMU_INT1` | Interrupt signal from IMU |
| PDM_DATA | P0.16 | `PIN_PDM_DIN` | PDM microphone data input |
| PDM_CLK | P1.00 | `PIN_PDM_CLK` | PDM microphone clock output |

---

## Arduino Setup

### Board Manager URL

```
https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
```

### Installation — Two Library Options

Seeed provides **two** Arduino board packages for the nRF52840:

| Package | Use Case | BLE | Low Power | IMU/PDM |
|---------|----------|-----|-----------|---------|
| **Seeed nRF52 Boards** | BLE apps, low power | ✓ (Adafruit BLE) | ✓ | ❌ |
| **Seeed nRF52 mbed-enabled Boards** | ML, IMU, PDM mic | ✓ (ArduinoBLE) | Limited | ✓ |

**For the Sense variant, use "Seeed nRF52 mbed-enabled Boards"** (IMU and PDM support):

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"Seeed nRF52 mbed"** and install **"Seeed nRF52 mbed-enabled Boards"**
5. Select **Tools** → **Board** → **Seeed nRF52 mbed-enabled Boards** → **Seeed XIAO BLE Sense - nRF52840**

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install Seeeduino:mbed

# Compile
arduino-cli compile --fqbn Seeeduino:mbed:xiaonRF52840Sense ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn Seeeduino:mbed:xiaonRF52840Sense -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
Seeeduino:mbed:xiaonRF52840Sense
```

### Required Libraries

Install via Arduino Library Manager:
- **LSM6DS3** — for IMU access (Seeed provides a fork)
- **ArduinoBLE** — for Bluetooth Low Energy (mbed package)
- **PDM** — included with mbed-enabled board package

### Example: Blink (Arduino)

```cpp
void setup() {
    pinMode(LED_BUILTIN, OUTPUT); // P0.06 — blue LED
}

void loop() {
    digitalWrite(LED_BUILTIN, LOW);  // LED on (active LOW)
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
    delay(500);
}
```

### Example: IMU (Accelerometer + Gyroscope)

```cpp
#include <LSM6DS3.h>
#include <Wire.h>

LSM6DS3 imu(I2C_MODE, 0x6A); // I2C address 0x6A

void setup() {
    Serial.begin(115200);
    while (!Serial);

    if (imu.begin() != 0) {
        Serial.println("IMU init failed!");
        while (1);
    }
    Serial.println("IMU initialized");
}

void loop() {
    Serial.print("Accel X: "); Serial.print(imu.readFloatAccelX(), 4);
    Serial.print("  Y: ");     Serial.print(imu.readFloatAccelY(), 4);
    Serial.print("  Z: ");     Serial.println(imu.readFloatAccelZ(), 4);

    Serial.print("Gyro X: ");  Serial.print(imu.readFloatGyroX(), 4);
    Serial.print("  Y: ");     Serial.print(imu.readFloatGyroY(), 4);
    Serial.print("  Z: ");     Serial.println(imu.readFloatGyroZ(), 4);

    Serial.println();
    delay(500);
}
```

### Example: PDM Microphone

```cpp
#include <PDM.h>

static const int BUFFER_SIZE = 256;
short sampleBuffer[BUFFER_SIZE];
volatile int samplesRead = 0;

void onPDMdata() {
    int bytesAvailable = PDM.available();
    PDM.read(sampleBuffer, bytesAvailable);
    samplesRead = bytesAvailable / 2; // 16-bit samples
}

void setup() {
    Serial.begin(115200);
    while (!Serial);

    PDM.onReceive(onPDMdata);
    if (!PDM.begin(1, 16000)) { // Mono, 16 kHz
        Serial.println("PDM init failed!");
        while (1);
    }
    Serial.println("PDM microphone initialized");
}

void loop() {
    if (samplesRead > 0) {
        for (int i = 0; i < samplesRead; i++) {
            Serial.println(sampleBuffer[i]);
        }
        samplesRead = 0;
    }
}
```

### Example: BLE Peripheral (ArduinoBLE — mbed package)

```cpp
#include <ArduinoBLE.h>

BLEService ledService("19B10000-E8F2-537E-4F6C-D104768A1214");
BLEByteCharacteristic switchChar("19B10001-E8F2-537E-4F6C-D104768A1214",
                                  BLERead | BLEWrite);

void setup() {
    Serial.begin(115200);
    pinMode(LED_BUILTIN, OUTPUT);

    if (!BLE.begin()) {
        Serial.println("BLE init failed!");
        while (1);
    }

    BLE.setLocalName("XIAO-Sense");
    BLE.setAdvertisedService(ledService);
    ledService.addCharacteristic(switchChar);
    BLE.addService(ledService);
    switchChar.writeValue(0);
    BLE.advertise();

    Serial.println("BLE advertising...");
}

void loop() {
    BLEDevice central = BLE.central();
    if (central) {
        while (central.connected()) {
            if (switchChar.written()) {
                if (switchChar.value()) {
                    digitalWrite(LED_BUILTIN, LOW); // LED on
                } else {
                    digitalWrite(LED_BUILTIN, HIGH); // LED off
                }
            }
        }
    }
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (P0.04)
- **SCL:** D5 (P0.05)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin();
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

> **Note:** The onboard IMU uses an internal I2C connection. External I2C devices connect to D4/D5.

### SPI

- **SCK:** D8 (P1.13)
- **MISO:** D9 (P1.14)
- **MOSI:** D10 (P1.15)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

```cpp
#include <SPI.h>

const int CS_PIN = 7; // D7

void setup() {
    pinMode(CS_PIN, OUTPUT);
    digitalWrite(CS_PIN, HIGH);
    SPI.begin();
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

- **TX:** D6 (P1.11)
- **RX:** D7 (P1.12)
- **Arduino object:** `Serial1` (hardware UART on D6/D7)
- **USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
void setup() {
    Serial.begin(115200);   // USB serial (Serial Monitor)
    Serial1.begin(9600);    // Hardware UART on D6(TX)/D7(RX)
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
    int value = analogRead(A0); // D0 / P0.02
    Serial.println(value);
    delay(100);
}
```

> **Note:** 6 analog pins available: D0–D5 (AIN0–AIN5).

---

## Onboard Sensors

### IMU — LSM6DS3TR-C (6-axis)

- **Type:** 3-axis accelerometer + 3-axis gyroscope
- **Interface:** Internal I2C (not on external GPIO pads)
- **I2C Address:** 0x6A
- **Power control:** P1.08 (IMU_PWR — set HIGH to power on; mbed library handles this automatically)
- **Interrupt:** P0.11 (IMU_INT1)
- **Arduino library:** LSM6DS3 (install via Library Manager)

**Important:** The mbed-enabled board package handles IMU power automatically. If using the non-mbed package, you must manually set P1.08 HIGH.

### PDM Microphone — MSM261D3526H1CPM

- **Type:** Digital PDM microphone
- **Data pin:** P0.16 (PDM_DATA)
- **Clock pin:** P1.00 (PDM_CLK)
- **Arduino library:** PDM (included with mbed-enabled board package)
- **Sample rates:** 16 kHz recommended; up to 41.667 kHz
- **Channels:** Mono (1 channel)

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Regulated from onboard LDO
- **Standby power:** < 5 μA

### Battery Support

The XIAO nRF52840 Sense has a built-in BQ25101 charge chip:

- **Battery pad:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge rate:** 50 mA (P0.13 HIGH) or 100 mA (P0.13 LOW, default)
- **Charge LED:** Red LED (P0.17) indicates charging status

```cpp
// Read battery voltage
void setup() {
    analogReadResolution(12);
    pinMode(PIN_VBAT, INPUT);
    Serial.begin(115200);
}

void loop() {
    int rawValue = analogRead(PIN_VBAT);
    float voltage = rawValue * 3.3 / 4095.0 * 2.0; // Voltage divider factor
    Serial.print("Battery: ");
    Serial.print(voltage);
    Serial.println("V");
    delay(1000);
}
```

### Deep Sleep

```cpp
void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, HIGH); // LED off
}

void loop() {
    // Do work...

    // Enter System OFF mode (< 5 μA)
    // Wake via reset pin or NFC field
    NRF_POWER->SYSTEMOFF = 1;
}
```

> **Note:** The mbed-enabled package has limited low-power support compared to the non-mbed "Seeed nRF52 Boards" package. For deep sleep applications without IMU/PDM, consider using the non-mbed package instead.

---

## Common Gotchas / Notes

1. **Use mbed-enabled package for Sense** — The non-mbed "Seeed nRF52 Boards" package does NOT support IMU or PDM microphone
2. **IMU power pin** — The mbed library handles P1.08 automatically; manual control needed with non-mbed package
3. **Same GPIO as base nRF52840** — D0–D10 pin mapping is identical to the non-Sense variant
4. **Sensors are internal** — IMU and microphone are on internal pins, not exposed on GPIO pads
5. **6 analog pins** — D0–D5 all have ADC (AIN0–AIN5); D6–D10 are digital only
6. **LEDs are active LOW** — `digitalWrite(pin, LOW)` turns the LED ON
7. **Battery charging** — Default charge rate is 100 mA; set P0.13 HIGH for 50 mA
8. **Bootloader mode** — Double-tap the reset pad; board appears as "XIAO-SENSE" USB drive
9. **Serial vs Serial1** — `Serial` is USB CDC (Serial Monitor); `Serial1` is hardware UART on D6/D7
10. **No WiFi** — This board has BLE only; use ESP32-C3 for WiFi
11. **BLE library difference** — mbed package uses ArduinoBLE; non-mbed uses Adafruit Bluefruit — APIs are different

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO_BLE/
- **Board package:** https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json
- **nRF52840 datasheet:** https://infocenter.nordicsemi.com/pdf/nRF52840_PS_v1.1.pdf
- **LSM6DS3TR-C datasheet:** https://www.st.com/resource/en/datasheet/lsm6ds3tr-c.pdf
- **ArduinoBLE library:** https://github.com/arduino-libraries/ArduinoBLE
- **Schematic:** https://files.seeedstudio.com/wiki/XIAO-BLE/Seeed-Studio-XIAO-nRF52840-Sense-v1.1.pdf
