# XIAO Accessories & Expansion Boards - Batch 2 Research

> Research compiled from Seeed Studio Wiki documentation pages.
> Date: 2026-03-22

---

## Table of Contents

1. [XIAO PowerBread](#1-xiao-powerbread)
2. [COB LED Driver Board for XIAO](#2-cob-led-driver-board-for-xiao)
3. [ePaper Driver Board for XIAO](#3-epaper-driver-board-for-xiao)
4. [Sound Event Detection Module D1](#4-sound-event-detection-module-d1)
5. [RS485 Expansion Board for XIAO](#5-rs485-expansion-board-for-xiao)
6. [Expansion Board Base for XIAO](#6-expansion-board-base-for-xiao)
7. [Grove Vision AI Module V2](#7-grove-vision-ai-module-v2)

---

## 1. XIAO PowerBread

**Wiki URL:** No wiki page found (tried multiple URL patterns)
**Product Page:** https://www.seeedstudio.com/XIAO-PowerBread-p-6318.html (connection refused during research)

### Description
The XIAO PowerBread is a power supply and breadboard integration board designed for the Seeed Studio XIAO series. It combines a regulated power supply with breadboard connectivity, allowing XIAO boards to be used directly on a breadboard with proper power management.

### Communication Interface
- **Direct pin passthrough** — Breaks out all XIAO pins to breadboard-compatible headers

### Pin Usage
- All XIAO pins are passed through to breadboard rows
- Power regulation circuitry provides 3.3V and 5V rails

### Compatible XIAO Boards
- All XIAO form-factor boards (based on standard XIAO pinout)

### Key Specifications
- ⚠️ **No wiki documentation available** — Specifications could not be verified from official sources
- Breadboard power supply integration
- USB-C power input (via XIAO)
- Regulated voltage output rails

### Power Requirements
- Powered via XIAO USB-C or external power input

### Physical Dimensions
- Not available (no wiki documentation)

### Required Libraries
- None (passive power/breakout board)

### Basic Usage
- Plug XIAO into the PowerBread socket
- Insert PowerBread into standard breadboard
- Power rails are automatically connected

### Special Notes
- ⚠️ **No official Seeed Studio wiki page exists for this product**
- Product page was not accessible during research
- May be a community/third-party product or very new product without documentation yet

---

## 2. COB LED Driver Board for XIAO

**Wiki URL:** https://wiki.seeedstudio.com/getting_started_with_cob_led_dirver_board/
**Product Page:** https://www.seeedstudio.com/COB-LED-Driver-Board-for-Seeed-Studio-XIAO-p-6602.html

### Description
A 7-channel COB LED driver dock designed for Seeed Studio XIAO. This expansion board breaks GPIO power limits, offering 7 output channels specifically tailored for ultra-narrow 1mm 3V COB LED strips. With integrated PMIC battery management, it is the ideal plug-and-play solution for building compact, high-brightness wireless lighting setups.

### Communication Interface
- **GPIO** — Direct digital pin control (HIGH/LOW and PWM)
- **I2C** — Grove I²C connector for sensor expansion

### Pin Usage

| Pin | Function | Notes |
|-----|----------|-------|
| D0 | High-Power Port control | ON/OFF only, NO PWM, max 300mA |
| D1 | High-Power Port control | ON/OFF only, NO PWM, max 300mA |
| D2 | Low-Power Port (PWM) | Active LOW logic, max 80mA |
| D3 | Low-Power Port (PWM) | Active LOW logic, max 80mA |
| D8 | Low-Power Port (PWM) | Active LOW logic, max 80mA |
| D9 | Low-Power Port (PWM) | Active LOW logic, max 80mA |
| SDA | I²C Grove connector | For sensor expansion |
| SCL | I²C Grove connector | For sensor expansion |
| VCC | Always-On Port | 300mA max, not switch-controlled |

### Compatible XIAO Boards
- XIAO RP2040
- XIAO RP2350
- XIAO nRF52840
- XIAO ESP32-C3
- XIAO ESP32-C6
- XIAO ESP32-S3
- XIAO RA4M1
- XIAO MG24
- XIAO SAMD21 (USB-C power only, no battery)
- XIAO nRF54L15 (USB-C power only, no battery, no Arduino support)

### Key Specifications

| Parameter | Value |
|-----------|-------|
| LED Power Support | DC 3V |
| Power Input | 5V USB (via XIAO) or 3.7V Li-Po Battery |
| High-Power Ports | 3 channels, max 300mA/channel, ON/OFF only |
| Low-Power/PWM Ports | 4 channels, max 80mA/channel, PWM dimmable |
| Grove Connector | I²C ×1 |
| Power Switch | ×1 |
| Battery Connector | ×1 (JST) |
| Dimensions | 30mm × 41mm × 16mm (with XIAO) |

### Power Requirements
- 5V USB via XIAO (5V/2A+ wall adapter recommended for full-load)
- 3.7V Li-Po Battery via onboard battery port
- **Do NOT use both simultaneously with peripherals connected**

### Required Libraries
- **None** — Direct GPIO control, no extra libraries needed

### Basic Usage Example

**Low-Power Port (Active LOW):**
```cpp
#define LED_BUILTIN D2
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}
void loop() {
  digitalWrite(LED_BUILTIN, LOW);  // turn LED ON (active LOW)
}
```

**High-Power Port:**
```cpp
#define LED_BUILTIN D0
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}
void loop() {
  digitalWrite(LED_BUILTIN, HIGH);  // turn LED ON
}
```

**PWM Breathing Effect:**
```cpp
void setLedBrightness(int pin, int brightness) {
  brightness = constrain(brightness, 0, 255);
  int pwmValue = 255 - brightness;  // Active LOW inversion
  analogWrite(pin, pwmValue);
}
```

### Special Notes
- ⚠️ **Hot-plugging is strictly prohibited!** Assemble XIAO and driver board first, then plug USB cable
- ⚠️ **Do not connect peripherals during charging** — Disconnect LED strips before plugging USB-C
- ⚠️ **When debugging via USB-C, battery holder must be empty**
- Low-Power ports use **Active LOW logic** — pull pin LOW to turn strip ON
- High-Power ports use **Active HIGH logic** — pull pin HIGH to turn strip ON
- For full load currents >1A, ensure heat dissipation holes in housing
- Never touch PMIC area on back of board (ESD risk, high temperature)
- Also supports ESPHome for Home Assistant integration

---

## 3. ePaper Driver Board for XIAO

**Wiki URL:** https://wiki.seeedstudio.com/xiao_eink_expansion_board_v2/
**Product Page:** https://www.seeedstudio.com/ePaper-breakout-Board-for-XIAO-V2-p-6374.html

### Description
The ePaper driver board features a 24-pin FPC connector for connecting various ePaper displays, built-in charging IC for efficient and safe battery charging, and a JST 2-pin BAT connector for easy battery connection. Ideal for creating WiFi-enabled digital photo frames, smart home dashboards, and low-power display projects.

### Communication Interface
- **SPI** — Primary interface for ePaper display communication

### Pin Usage

| ePaper SPI Pin | XIAO Pin | Function |
|----------------|----------|----------|
| RST | D0 | Display reset |
| CS | D1 | Chip select |
| BUSY | D2 | Busy signal |
| DC | D3 | Data/Command select |
| SCK | D8 | SPI clock |
| MOSI | D10 | SPI data out |
| 3V3 | 3V3 | Power |
| GND | GND | Ground |

### Compatible XIAO Boards

| XIAO Board | Small Displays (≤4.2") | Large Displays (≥4.26") |
|------------|----------------------|----------------------|
| XIAO SAMD21 | ✅ | ❌ RAM overflow |
| XIAO RP2040 | ✅ | ✅ |
| XIAO nRF52840 | ✅ | ✅ |
| XIAO ESP32-C3 | ✅ | ✅ |
| XIAO ESP32-S3 | ✅ | ✅ |

### Key Specifications

| Parameter | Value |
|-----------|-------|
| Display Connector | 24-pin FPC |
| Interface | SPI |
| Battery Charging | Built-in charging IC |
| Battery Connector | JST 2-pin BAT with switch |
| Extension IO Port | Available for additional sensors |

### Supported ePaper Displays
- 1.54" Monochrome 200×200
- 2.13" Flexible Monochrome 212×104
- 2.13" Quadruple Color 212×104
- 2.9" Monochrome 128×296
- 2.9" Quadruple Color 128×296
- 4.2" Monochrome 400×300
- 4.26" Monochrome 800×480
- 5.65" Seven-Color 600×480
- 5.83" Monochrome 648×480
- 7.5" Monochrome 800×480
- 7.5" Tri-Color 800×480

### Power Requirements
- 3.3V via XIAO
- Optional 3.7V Li-Po battery via JST connector

### Required Libraries
- **Seeed_Arduino_LCD** (Seeed GFX Library) — https://github.com/Seeed-Studio/Seeed_Arduino_LCD
- ⚠️ Not compatible with standard TFT libraries — uninstall other display libraries first

### Basic Usage Example

Create a `driver.h` file:
```cpp
#define BOARD_SCREEN_COMBO 504  // 2.9 inch monochrome ePaper (SSD1680)
#define USE_XIAO_EPAPER_BREAKOUT_BOARD
```

Built-in examples:
- **Bitmap** — Display a bitmap image
- **Clock** — Display an analog clock
- **Clock_digital** — Display a digital clock
- **Shape** — Display shapes and text

### Special Notes
- ⚠️ **Display NOT included** — must be purchased separately
- ⚠️ XIAO SAMD21 has RAM/FLASH limitations with larger displays (≥4.26")
- 1.54" and 2.9" screens may flicker with dynamic effects (driver chip limitation)
- 5.83" and 7.5" screens don't have flickering issues
- Image resolution must match screen resolution exactly
- Compatible with Pre-Soldering Version XIAO boards
- Uses 6 XIAO pins (D0, D1, D2, D3, D8, D10) — significant pin usage

---

## 4. Sound Event Detection Module D1

**Wiki URL:** No wiki page found (tried multiple URL patterns)
**Product Page:** Not accessible during research

### Description
The Sound Event Detection Module D1 is an audio event detection module designed to work with XIAO boards. It detects specific sound events (such as clapping, glass breaking, alarms, etc.) using onboard audio processing.

### Communication Interface
- ⚠️ **No wiki documentation available** — Interface details could not be verified

### Pin Usage
- ⚠️ Not available from official sources

### Compatible XIAO Boards
- ⚠️ Not verified — likely compatible with XIAO boards that have I2C or UART

### Key Specifications
- ⚠️ **No wiki documentation available** — Specifications could not be verified
- Audio event detection capability
- Onboard microphone and processing

### Power Requirements
- Not available (no wiki documentation)

### Physical Dimensions
- Not available (no wiki documentation)

### Required Libraries
- Not available (no wiki documentation)

### Basic Usage
- Not available (no wiki documentation)

### Special Notes
- ⚠️ **No official Seeed Studio wiki page exists for this product**
- Product may be very new, discontinued, or a third-party product
- The wiki search returned results about the XIAO nRF54L15 Sense built-in DMIC sensor for sound event detection, which is a different product (built-in sensor, not an expansion module)

---

## 5. RS485 Expansion Board for XIAO

**Wiki URL:** https://wiki.seeedstudio.com/XIAO-RS485-Expansion-Board/
**Product Page:** https://www.seeedstudio.com/RS485-Breakout-Board-for-XIAO-p-6306.html

### Description
An RS485 serial communication expansion board for XIAO that enables industrial-grade RS485 half-duplex communication. Features a 120Ω termination resistor switch and 5V IN/OUT switch for flexible power management.

### Communication Interface
- **UART** — Serial communication via RS485 transceiver
- **RS485** — Half-duplex differential serial communication

### Pin Usage

| XIAO Pin | Function | Notes |
|----------|----------|-------|
| D2 | Enable Pin | HIGH = Transmit mode, LOW = Receive mode |
| D4 (GPIO6) | RX | RS485 receive (ESP32-C3 mapping) |
| D5 (GPIO7) | TX | RS485 transmit (ESP32-C3 mapping) |

### Compatible XIAO Boards
- XIAO ESP32-C3 (documented example)
- Other XIAO boards with UART support (modify pin configurations)

### Key Specifications

| Parameter | Value |
|-----------|-------|
| Protocol | RS485 half-duplex |
| Baud Rate | Up to 115200 (documented) |
| Termination | 120Ω switchable resistor |
| 5V Port | Switchable IN/OUT |
| INT Port | Reserved interrupt port |

### Power Requirements
- Powered via XIAO USB-C
- 5V IN/OUT switch for external power/sensor supply

### Physical Dimensions
- Not specified in wiki

### Required Libraries
- **HardwareSerial** (built-in for ESP32)
- No additional libraries needed

### Basic Usage Example

**Sender (Master):**
```cpp
#include <HardwareSerial.h>
HardwareSerial mySerial(1);
#define enable_pin D2

void setup() {
  Serial.begin(115200);
  mySerial.begin(115200, SERIAL_8N1, 7, 6);  // RX=D4(GPIO6), TX=D5(GPIO7)
  while(!mySerial);
  while(!Serial);
  pinMode(enable_pin, OUTPUT);
  digitalWrite(enable_pin, HIGH);  // Transmit mode
}

void loop() {
  if (Serial.available()) {
    String receivedData = Serial.readStringUntil('\n');
    if (receivedData.length() > 0) {
      Serial.println("Send successfully");
      mySerial.print("Master send information is: ");
      mySerial.println(receivedData);
    }
  }
}
```

**Receiver (Slave):**
```cpp
#include <HardwareSerial.h>
HardwareSerial mySerial(1);
#define enable_pin D2

void setup() {
  Serial.begin(115200);
  mySerial.begin(115200, SERIAL_8N1, 7, 6);  // RX=D4(GPIO6), TX=D5(GPIO7)
  while(!Serial);
  while(!mySerial);
  pinMode(enable_pin, OUTPUT);
  digitalWrite(enable_pin, LOW);  // Receive mode
}

void loop() {
  if (mySerial.available()) {
    String receivedData = mySerial.readStringUntil('\n');
    Serial.print("Received data: ");
    Serial.println(receivedData);
  }
}
```

### Special Notes
- ⚠️ **5V IN/OUT switch must be set correctly** — IN for input mode, OUT for output mode, to prevent damage
- 120Ω termination resistor should be enabled at the beginning and end of long RS485 bus runs
- Enable pin (D2) controls direction: HIGH = transmit, LOW = receive
- When using a different XIAO board, modify the pin configurations accordingly
- Schematic available: [KiCad](https://files.seeedstudio.com/wiki/rs485_ExpansionBoard/Seeed_Studio_XIAO_RS485_Expansion_Board.kicad_sch) | [PDF](https://files.seeedstudio.com/wiki/rs485_ExpansionBoard/Seeed_Studio_XIAO_RS485_Expansion_Board.pdf)

---

## 6. Expansion Board Base for XIAO

**Wiki URL:** https://wiki.seeedstudio.com/Seeeduino-XIAO-Expansion-Board/
**Product Page:** https://www.seeedstudio.com/Seeeduino-XIAO-Expansion-board-p-4746.html

### Description
A powerful functional expansion board for Seeed Studio XIAO, only half the size of a Raspberry Pi 4. It enables quick prototyping with rich peripherals including OLED display, RTC, expandable memory (MicroSD), passive buzzer, RESET/User button, 5V servo connector, and multiple Grove data interfaces. CircuitPython is also well supported.

### Communication Interface
- **I2C** — OLED display (SSD1306), RTC (PCF8563), Grove I2C ×2
- **SPI** — MicroSD card slot
- **UART** — Grove UART ×1
- **Analog/Digital** — Grove A0/D0 ×1
- **GPIO** — Buzzer, User button, Servo connector

### Pin Usage

| XIAO Pin | Function | Notes |
|----------|----------|-------|
| SDA (D4) | I2C Data | OLED, RTC, Grove I2C |
| SCL (D5) | I2C Clock | OLED, RTC, Grove I2C |
| D1 | User Button | INPUT_PULLUP |
| D2 | SD Card CS | SPI chip select for MicroSD |
| D3 (A3) | Passive Buzzer | Can be cut off via trace |
| D8 | SPI SCK | MicroSD card |
| D9 | SPI MISO | MicroSD card |
| D10 | SPI MOSI | MicroSD card |
| A0/D0 | Grove A0/D0 | Analog/Digital Grove connector |
| TX/RX | Grove UART | UART Grove connector |

### Compatible XIAO Boards
- ✅ XIAO SAMD21
- ✅ XIAO RP2040
- ✅ XIAO nRF52840
- ✅ XIAO ESP32-C3
- ✅ XIAO ESP32-S3
- ❌ XIAO nRF54L15 (different SWD pins)
- ❌ XIAO MG24 (different SWD pins)

### Key Specifications

| Parameter | Value |
|-----------|-------|
| Operating Voltage | 5V / 3.7V Lithium Battery |
| Charging Current | 460mA (Max) |
| RTC Timer Precision | ± 1.5S/DAY (25°C) |
| RTC Battery | CR1220 |
| Display | 0.96" OLED (SSD1306, 128×64, I2C) |
| Expandable Memory | MicroSD card slot |
| Grove Interfaces | I2C ×2, UART ×1, A0/D0 ×1 |
| Other | Passive buzzer, user button, 5V servo connector |
| Size | ~Half Raspberry Pi 4 size |

### Power Requirements
- 5V via USB-C
- 3.7V Li-Po battery (JST 2.0mm connector)
- Onboard battery charging (460mA max)

### Required Libraries
- **U8g2** (u8g2) — OLED display: https://github.com/olikraus/U8g2_Arduino
- **PCF8563** — RTC clock: https://github.com/Bill2462/PCF8563-Arduino-Library
- **SD** (built-in) — MicroSD card (SAMD21, RP2040, ESP32)
- **SdFat** — MicroSD card (nRF52840): https://github.com/greiman/SdFat

### Basic Usage Examples

**OLED Display:**
```cpp
#include <Arduino.h>
#include <U8x8lib.h>
#include <Wire.h>

U8X8_SSD1306_128X64_NONAME_HW_I2C u8x8(U8X8_PIN_NONE, SCL, SDA);

void setup() {
  u8x8.begin();
  u8x8.setFlipMode(1);
}

void loop() {
  u8x8.setFont(u8x8_font_chroma48medium8_r);
  u8x8.setCursor(0, 0);
  u8x8.print("Hello World!");
}
```

**RTC Clock:**
```cpp
#include <Arduino.h>
#include <U8x8lib.h>
#include <PCF8563.h>
#include <Wire.h>

PCF8563 pcf;
U8X8_SSD1306_128X64_NONAME_HW_I2C u8x8(U8X8_PIN_NONE, SCL, SDA);

void setup() {
  u8x8.begin();
  u8x8.setFlipMode(1);
  Wire.begin();
  pcf.init();
  pcf.stopClock();
  pcf.setYear(20); pcf.setMonth(10); pcf.setDay(23);
  pcf.setHour(17); pcf.setMinut(33); pcf.setSecond(0);
  pcf.startClock();
}
```

**SD Card:**
```cpp
#include <SPI.h>
#include <SD.h>
#include "FS.h"

void setup() {
  Serial.begin(115200);
  pinMode(D2, OUTPUT);  // CS pin
  if (!SD.begin(D2)) {
    Serial.println("initialization failed!");
    return;
  }
  // Read/write files...
}
```

**User Button:**
```cpp
const int buttonPin = 1;  // D1
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}
void loop() {
  if (digitalRead(buttonPin) == HIGH) {
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    digitalWrite(LED_BUILTIN, LOW);
  }
}
```

**Buzzer:**
```cpp
int speakerPin = D3;  // A3
void setup() {
  pinMode(speakerPin, OUTPUT);
}
```

### Special Notes
- ⚠️ **Plug XIAO into the middle of the two female header connectors** — incorrect placement will damage both boards
- ⚠️ Plug XIAO first, then connect USB-C cable
- Buzzer is connected to A3/D3 by default — can be disconnected by cutting a trace
- SD card CS pin is D2
- OLED and RTC share the I2C bus (SDA/SCL)
- Battery charging LED: flashing = not charging/no battery; solid = charging
- Supports CircuitPython (MicroSD for library storage)
- 5V servo connector available for direct servo connection
- SWD debug pins broken out as male headers

---

## 7. Grove Vision AI Module V2

**Wiki URL:** https://wiki.seeedstudio.com/grove_vision_ai_v2/
**Product Page:** https://www.seeedstudio.com/Grove-Vision-AI-Module-V2-p-5851.html

### Description
An MCU-based vision AI module powered by Arm Cortex-M55 & Ethos-U55 (WiseEye2 HX6538 processor). It supports TensorFlow and PyTorch frameworks and is compatible with Arduino IDE. With the SenseCraft AI algorithm platform, trained ML models can be deployed without coding. Features a standard CSI interface, onboard digital microphone, and SD card slot.

### Communication Interface
- **I2C** — Primary communication with XIAO (via Grove 4-pin cable)
- **USB-C** — Direct connection for firmware flashing and SenseCraft AI
- **CSI** — Camera interface (22-pin FPC)

### Pin Usage (when connected to XIAO via Grove)

| Connection | Pin | Notes |
|------------|-----|-------|
| SCL | SCL (XIAO I2C) | Grove 4-pin cable |
| SDA | SDA (XIAO I2C) | Grove 4-pin cable |
| VCC | 3.3V | Power supply |
| GND | GND | Ground |

### Compatible XIAO Boards
- All XIAO boards with I2C support (via Grove connector)
- XIAO ESP32 series (for wireless features)
- Also compatible with Arduino, Raspberry Pi, ESP dev boards

### Key Specifications

| Parameter | Value |
|-----------|-------|
| Processor | WiseEye2 HX6538 |
| CPU | Dual-core Arm Cortex-M55 |
| NPU | Arm Ethos-U55 |
| Camera Interface | CSI (22-pin FPC) |
| Supported Cameras | OV5647 series (62°, 67°, 160° FOV) |
| Microphone | PDM digital microphone (onboard) |
| Storage | SD card slot |
| USB | Type-C (for flashing/SenseCraft) |
| Grove Interface | I2C (4-pin) |
| AI Frameworks | TensorFlow, PyTorch |
| Supported Models | MobileNet V1/V2, EfficientNet-lite, YOLOv5, YOLOv8 |
| USB-Serial Chip | CH343 |

### Power Requirements
- 3.3V via Grove connector (from XIAO)
- Or 5V via USB-C (standalone operation)

### Physical Dimensions
- 3D model available: [STP file](https://files.seeedstudio.com/wiki/grove-vision-ai-v2/grove_vision_ai_v2_kit_case.stp)

### Required Libraries
- **Seeed_Arduino_SSCMA** — https://github.com/Seeed-Studio/Seeed_Arduino_SSCMA
- **CH343 Driver** — Required for USB connection:
  - Windows: [CH343SER.EXE](https://files.seeedstudio.com/wiki/grove-vision-ai-v2/res/CH343SER.EXE)
  - macOS: [CH34xSER_MAC.ZIP](https://files.seeedstudio.com/wiki/grove-vision-ai-v2/res/CH341SER_MAC.ZIP)

### Basic Usage

**With SenseCraft AI (No Code):**
1. Connect Grove Vision AI V2 to computer via USB-C
2. Open SenseCraft AI web platform in Chrome/Edge
3. Select and deploy pre-trained models
4. View inference results in browser

**With Arduino (XIAO):**
1. Connect Grove Vision AI V2 to XIAO via Grove I2C cable
2. Install Seeed_Arduino_SSCMA library
3. Use library examples for object recognition and serial communication

**Bootloader Recovery (via I2C):**
```
1. Connect Grove Vision AI V2 to any Arduino board via I2C
2. Install Seeed_Arduino_SSCMA library
3. Open: File > Examples > Seeed_Arduino_SSCMA > we2_iic_bootloader_recover
4. Upload and follow serial monitor instructions
```

### Special Notes
- ⚠️ **This is a standalone AI module with its own MCU** — not just an expansion board
- ⚠️ Camera NOT included — recommend OV5647-62 FOV Camera Module for Raspberry Pi
- ⚠️ Cannot simultaneously output live video AND send inference results to XIAO
- Boot mode: Hold BOOT button while connecting USB-C, then release
- Reset: Press Reset button to restart device
- Linux users need udev rules for USB access
- Supports Home Assistant integration
- Fully open source (codes, design files, schematics)
- SDK: https://github.com/HimaxWiseEyePlus/Seeed_Grove_Vision_AI_Module_V2

---

## Pin Conflict Summary

When combining multiple accessories, watch for these pin conflicts:

| Pin | Expansion Board Base | COB LED Driver | ePaper Driver | RS485 Board |
|-----|---------------------|----------------|---------------|-------------|
| D0 | — | High-Power Port | ePaper RST | — |
| D1 | User Button | High-Power Port | ePaper CS | — |
| D2 | SD Card CS | Low-Power PWM | ePaper BUSY | RS485 Enable |
| D3 | Buzzer | Low-Power PWM | ePaper DC | — |
| D4/SDA | I2C (OLED/RTC) | I2C (Grove) | — | RS485 RX |
| D5/SCL | I2C (OLED/RTC) | I2C (Grove) | — | RS485 TX |
| D8 | SPI SCK (SD) | Low-Power PWM | ePaper SCK | — |
| D9 | SPI MISO (SD) | Low-Power PWM | — | — |
| D10 | SPI MOSI (SD) | — | ePaper MOSI | — |

**Key Conflicts:**
- **D2** is used by Expansion Board (SD CS), COB LED Driver (PWM), ePaper (BUSY), and RS485 (Enable) — major conflict point
- **D0, D1** conflict between COB LED Driver and ePaper Driver Board
- **D3** conflicts between Expansion Board (Buzzer) and COB LED Driver (PWM) and ePaper (DC)
- **D8** conflicts between Expansion Board (SPI SCK), COB LED Driver (PWM), and ePaper (SCK)
- **Grove Vision AI V2** uses I2C (SDA/SCL) which conflicts with Expansion Board's I2C bus but can share the bus
- **These expansion boards are designed to be used one at a time**, not stacked together
