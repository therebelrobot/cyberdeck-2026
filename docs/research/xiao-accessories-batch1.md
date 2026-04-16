# XIAO Accessories Research - Batch 1

> Research compiled from Seeed Studio Wiki and product pages on 2026-03-22

## Table of Contents

1. [XIAO Logger HAT](#1-xiao-logger-hat)
2. [24GHz mmWave Human Static Presence Sensor for XIAO](#2-24ghz-mmwave-human-static-presence-sensor-for-xiao)
3. [L76K GNSS Module for XIAO](#3-l76k-gnss-module-for-xiao)
4. [reSpeaker Lite](#4-respeaker-lite)
5. [CAN Bus Breakout Board for XIAO](#5-can-bus-breakout-board-for-xiao)
6. [XIAO 6-Channel Wi-Fi 5V DC Relay](#6-xiao-6-channel-wi-fi-5v-dc-relay)
7. [ePaper Breakout Board for XIAO](#7-epaper-breakout-board-for-xiao)

---

## 1. XIAO Logger HAT

**Source:** [Product Page](https://www.seeedstudio.com/XIAO-LOG-p-6341.html) | [GitHub Repo](https://github.com/) (linked from product page)
**SKU:** 114993446

### Description
A tiny temperature, humidity, and light add-on module for XIAO with RTC and battery voltage monitoring. Co-created with Westlake University's Marcel. Fully open-source on GitHub.

### Communication Interface
- **I2C** for all three sensors (SHT40, BH1750, PCF8563)
- **ADC** for battery voltage reading (via enableable voltage divider)

### Pin Usage
| Function | XIAO Pin | Notes |
|----------|----------|-------|
| I2C SDA | D4 (SDA) | Shared bus for SHT40, BH1750, PCF8563 |
| I2C SCL | D5 (SCL) | Shared bus for SHT40, BH1750, PCF8563 |
| INT | D2 | RTC interrupt for deep sleep wakeup |
| ADC | A0 | Battery voltage monitoring (via voltage divider) |
| EN | D1 | GPIO-powered sensor enable pin |

### Compatible XIAO Boards

| XIAO Board | I2C | INT | ADC | EN | BAT |
|------------|-----|-----|-----|-----|-----|
| XIAO SAMD21 | ✅ | ✅ | ✅ | ✅ | ❌ |
| XIAO nRF52840 (Sense) | ✅ | ✅ | ✅ | ✅ | ✅ |
| XIAO RP2040 | ✅ | ✅ | ✅ | ✅ | ❌ |
| XIAO RP2350 | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO ESP32C3 | ✅ | ✅ | ✅ | ✅ | ✅ |
| XIAO ESP32S3 (Sense) | ✅ | ✅ | ✅ | ✅ | ✅ |
| XIAO ESP32C6 | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO RA4M1 | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO MG24 (Sense) | ✅ | ✅ | ✅ | ✅ | ⚠️ not aligned |
| XIAO nRF54L15 | ❌ | ❌ | ❌ | ❌ | ❌ (Arduino not supported) |

### Key Specifications
- **SHT40 Temperature Sensor:** ±0.2°C accuracy, ~2ms read time
- **SHT40 Humidity Sensor:** ±1.8%RH accuracy
- **BH1750 Ambient Light Sensor:** ~120ms read time
- **PCF8563 RTC:** <1µA consumption, 7-minute drift/year
- **Dimensions:** 21 × 17.8 mm

### Power Requirements
- **Operating Voltage:** 2.4V–3.6V
- **Active Current:** ~500µA
- **Idle Current:** ~0.25µA (GPIO-powered sensors allow near-zero sleep)
- **Operating Temperature:** -40°C to 85°C

### Required Libraries
- SHT40 library (Sensirion)
- BH1750 library
- PCF8563 RTC library
- Available via Arduino Library Manager

### Special Notes
- **Battery:** Compatible with EEMB 3.7V 500mAh LiPo (not included)
- XIAO SAMD21 and RP2040 do NOT support battery charging — do not use battery monitoring
- XIAO RP2350, ESP32C6, RA4M1, MG24 support battery charging but need additional wiring
- XIAO nRF52840, ESP32C3, ESP32S3 fully support battery monitoring with 2-pin header
- **Pin Conflict:** Uses I2C bus (D4/D5) — other I2C devices can share the bus
- **No wiki page** — documentation is on the product page and GitHub repo

---

## 2. 24GHz mmWave Human Static Presence Sensor for XIAO

**Source:** [Wiki Page](https://wiki.seeedstudio.com/mmwave_for_xiao/)

### Description
An antenna-integrated, high-sensitivity mmWave radar sensor based on FMCW principle. Combined with radar signal processing and accurate human body sensing algorithms, it can identify human bodies in motion and stationary states.

### Communication Interface
- **Soft Serial (UART):** D2 (TX), D3 (RX)
- **Bluetooth:** For configuration via HLKRadarTool app
- **GPIO:** IO level 3.3V

### Pin Usage
| Function | XIAO Pin | Notes |
|----------|----------|-------|
| TX (Soft Serial) | D2 | Sensor transmit |
| RX (Soft Serial) | D3 | Sensor receive |
| 3.3V | 3V3 | Power supply |
| GND | GND | Ground |

> **Note:** Only D2, D3, 3V3, and GND are used. All other XIAO pins remain free.

### Compatible XIAO Boards
All XIAO boards are compatible (plugs directly onto XIAO headers).

### Key Specifications
| Parameter | Value |
|-----------|-------|
| Operating Frequency | 24GHz–24.25GHz |
| Modulation | FMCW |
| Detection Distance | 0.75m–6m (adjustable) |
| Detection Angle | ±60° |
| Distance Resolution | 0.75m |
| Sweep Bandwidth | 250MHz |
| Ambient Temperature | -40°C to 85°C |
| Dimensions | 18 × 22 mm |

### Power Requirements
- **Operating Voltage:** DC 5V
- **Power Supply Capacity:** >200mA
- **Average Operating Current:** 79mA

### Required Libraries
- No Arduino library required for basic operation
- HLKRadarTool app (iOS/Android/Windows) for configuration
- Serial communication for secondary development

### Basic Usage
The sensor plugs directly onto XIAO. The antenna must face outward. Configuration is done via Bluetooth using the HLKRadarTool app, or via UART serial commands.

### Special Notes
- **CAUTION:** Antenna must face outward when plugging in — incorrect orientation can burn the sensor or XIAO
- Supports Bluetooth parameter adjustment (no serial port needed)
- Supports OTA firmware upgrade via Bluetooth
- Firmware recovery available via mobile app (Initialize function)
- **Pin Conflict:** Uses D2/D3 for soft serial — these pins cannot be used for other purposes

---

## 3. L76K GNSS Module for XIAO

**Source:** [Wiki Page](https://wiki.seeedstudio.com/get_start_l76k_gnss/)

### Description
Multi-GNSS module compatible with all XIAO boards. Supports GPS, BeiDou (BDS), GLONASS, and QZSS systems. Allows multi-system combined or single-system independent positioning. Includes a high-performance active GNSS antenna and 1PPS LED indicator.

### Communication Interface
- **Software Serial (UART):** D6 (TX), D7 (RX)
- Default baud rate: 9600bps (configurable 9600–115200bps)
- Protocol: NMEA 0183, CASIC proprietary protocol

### Pin Usage
| Function | XIAO Pin | Notes |
|----------|----------|-------|
| TX (Soft Serial) | D6 | GNSS module transmit |
| RX (Soft Serial) | D7 | GNSS module receive |
| 3V3 | 3V3 | Power supply |
| GND | GND | Ground |

> **RP2040 Special:** On XIAO RP2040, D2 and D0 are set HIGH as outputs in the example code.

### Compatible XIAO Boards
- Seeed Studio XIAO SAMD21
- Seeed Studio XIAO RP2040
- Seeed Studio XIAO nRF52840 (Sense)
- Seeed Studio XIAO ESP32C3
- Seeed Studio XIAO ESP32S3 (Sense)

### Key Specifications
| Parameter | Value |
|-----------|-------|
| GNSS Bands | GPS L1 C/A (1575.42MHz), GLONASS L1 (1602MHz), BeiDou B1 (1561.098MHz) |
| Channels | 32 tracking / 72 acquisition |
| TTFF Cold Start | 30s (w/o AGNSS), 5.5s (w/ AGNSS) |
| TTFF Hot Start | 5.5s (w/o AGNSS), 2s (w/ AGNSS) |
| Sensitivity (Tracking) | -162dBm |
| Sensitivity (Re-acquisition) | -160dBm |
| Position Accuracy | 2.0m CEP |
| Velocity Accuracy | 0.1m/s |
| Update Rate | 1Hz (default), 5Hz (max) |
| Antenna Type | Active antenna, U.FL connector, RF1.13 cable 10cm |
| Dimensions | 18 × 21 mm |

### Power Requirements
- **Current (Acquisition/Tracking):** 41mA (with active antenna)
- **Standby Current:** 360µA

### Required Libraries
- **TinyGPSPlus** (Arduino Library Manager)
- **SoftwareSerial** (built-in)

### Basic Usage Example
```cpp
#include <TinyGPSPlus.h>
#include <SoftwareSerial.h>

static const int RXPin = D7, TXPin = D6;
static const uint32_t GPSBaud = 9600;

TinyGPSPlus gps;
SoftwareSerial ss(RXPin, TXPin);

void setup() {
  Serial.begin(115200);
  ss.begin(GPSBaud);
}

void loop() {
  while (ss.available() > 0)
    if (gps.encode(ss.read()))
      displayInfo();
}
```

### Special Notes
- **CAUTION:** Do not plug in backwards — can burn module or XIAO
- Must be placed outdoors for GNSS signal reception
- Active antenna connects via U.FL connector
- **Pin Conflict:** Uses D6/D7 for soft serial — these pins cannot be used for other purposes

---

## 4. reSpeaker Lite

**Source:** [Wiki Page](https://wiki.seeedstudio.com/reSpeaker_usb_v3/)

### Description
Voice/audio processing board powered by XMOS XU316 AI Sound and Audio chipset. Features dual microphone array for far-field voice capture (up to 3m), with onboard AI algorithms for interference cancellation, acoustic echo cancellation, noise suppression, and automatic gain control.

### Communication Interface
- **I2S:** For connection to XIAO ESP32S3 (Sense) or Adafruit QT Py
- **USB (UAC2):** Audio Class 2.0 for connection to Raspberry Pi or PC
- Two firmware versions: USB version (default) and I2S version (for XIAO)

### Pin Usage
The reSpeaker Lite is NOT a hat that plugs onto XIAO pins. Instead, the XIAO ESP32S3 plugs into a socket on the reSpeaker Lite board. The board has its own USB-C port.

| Component | Description |
|-----------|-------------|
| Dual Microphone Array | Audio input |
| USB Type-C Port | Power and data |
| Speaker Connector | 5W amplifier speaker output |
| 3.5mm Headphone Jack | Audio output |
| XIAO ESP32S3 Socket | Optional XIAO integration |
| External Power Pads | 5V external power |
| JTAG | XU316 debugging |
| WS2812 RGB LED | Programmable visual indicator |
| USR Button | User-defined |
| Mute Button | Mutes audio input |

### Compatible XIAO Boards
- **Primary:** XIAO ESP32S3 (Sense) via I2S
- Also compatible with Adafruit QT Py via I2S
- Compatible with Raspberry Pi and PC via USB

### Key Specifications
| Parameter | Value |
|-----------|-------|
| Core Chip | XMOS XU316 |
| Microphones | 2× high-performance digital |
| Mic Sensitivity | -26 dBFS |
| Acoustic Overload Point | 120 dBL |
| SNR | 64 dBA |
| Max Sampling Rate | 16kHz |
| Speaker Support | 5W amplifier |
| Dimensions | 35 × 86 mm |

### Power Requirements
- **Power Supply:** USB 5V or External 5V

### Required Libraries/Tools
- **DFU-Util** for firmware updates
- USB firmware (default) or I2S firmware (for XIAO)
- No Arduino library needed — works as USB audio device

### Special Notes
- **Plug-and-play** as USB audio device (no driver required)
- Two firmware versions: USB (default) and I2S (for XIAO ESP32S3)
- Firmware update via DFU-Util command line tool
- The XIAO plugs INTO the reSpeaker board (not the other way around)
- **Not a traditional XIAO hat** — it's a larger board with XIAO socket

---

## 5. CAN Bus Breakout Board for XIAO

**Source:** [Wiki Page](https://wiki.seeedstudio.com/xiao-can-bus-expansion/)

### Description
Expansion board providing CAN bus communication via MCP2515 controller and SN65HVD230 transceiver. Enables reliable data exchange over CAN bus for automotive, industrial, robotics, and IoT applications.

### Communication Interface
- **SPI:** XIAO communicates with MCP2515 via SPI
- **CAN Bus:** MCP2515 + SN65HVD230 transceiver for CAN-H/CAN-L differential signaling

### Pin Usage
| Function | XIAO Pin | Notes |
|----------|----------|-------|
| SPI CS | D7 | Chip select for MCP2515 |
| SPI SCK | D8 | SPI clock |
| SPI MOSI | D10 | SPI data out |
| SPI MISO | D9 | SPI data in |
| CAN-H | Terminal | CAN bus high line |
| CAN-L | Terminal | CAN bus low line |
| GND | Terminal | Ground reference |

### Compatible XIAO Boards
All Seeed Studio XIAO boards (demonstrated with XIAO ESP32C3).

### Key Specifications
| Parameter | Value |
|-----------|-------|
| CAN Controller | MCP2515 |
| CAN Transceiver | SN65HVD230 |
| Terminal Connection | 2-pin for CANH and CANL |
| Supported Baud Rates | 5Kbps to 1000Kbps |
| LED Indicators | RX/TX activity LEDs |
| Termination Resistor | 120Ω (optional, via P1 solder pad on back) |

### Power Requirements
- Powered via XIAO USB or XIAO power supply

### Required Libraries
- **mcp_can** library ([GitHub](https://github.com/Seeed-Studio/Seeed_Arduino_CAN))
- Download from GitHub and install via Arduino IDE

### Basic Usage Example
```cpp
#include <mcp_can.h>
#include <SPI.h>

#define SPI_CS_PIN D7

MCP_CAN CAN(SPI_CS_PIN);

void setup() {
  Serial.begin(115200);
  while (CAN_OK != CAN.begin(CAN_500KBPS)) {
    Serial.println("CAN BUS FAIL!");
    delay(100);
  }
  Serial.println("CAN BUS OK!");
}

unsigned char stmp[8] = {0, 1, 2, 3, 4, 5, 6, 7};
void loop() {
  CAN.sendMsgBuf(0x00, 0, 8, stmp);
  delay(100);
}
```

### Special Notes
- **Termination Resistor:** P1 pad on back of board — short it to add 120Ω termination resistor if CAN communication fails
- **Pin Conflict:** Uses SPI pins (D7, D8, D9, D10) — these cannot be used for other SPI devices simultaneously
- Supports standard and extended CAN frames
- Includes mask and filter registers for targeted message reception

---

## 6. XIAO 6-Channel Wi-Fi 5V DC Relay

**Source:** [Wiki Page](https://wiki.seeedstudio.com/6_channel_wifi_relay/)

### Description
Smart relay module with six independently controllable channels for DC loads (NOT for AC). Features Wi-Fi connectivity for Home Assistant integration via ESPHome. Includes two Grove expansion interfaces (I2C and UART).

### Communication Interface
- **Wi-Fi:** For Home Assistant / ESPHome control
- **GPIO:** Direct relay control via XIAO GPIO pins
- **Grove I2C × 1:** Expansion port
- **Grove UART × 1:** Expansion port

### Pin Usage
| Function | XIAO GPIO | Relay Channel |
|----------|-----------|---------------|
| Relay 1 | GPIO2 | Channel 1 |
| Relay 2 | GPIO21 | Channel 2 |
| Relay 3 | GPIO1 | Channel 3 |
| Relay 4 | GPIO0 | Channel 4 |
| Relay 5 | GPIO19 | Channel 5 |
| Relay 6 | GPIO18 | Channel 6 |

### Compatible XIAO Boards
- **Primary:** XIAO ESP32C6 (pre-flashed with ESPHome firmware)
- Requires Wi-Fi capable XIAO for wireless control

### Key Specifications
| Parameter | Value |
|-----------|-------|
| Input Voltage | DC 5V (for XIAO) |
| DC Withstand Voltage | DC 0–30V |
| Maximum Load | 10A per channel |
| Channels | 6 (independent control) |
| Connection Type | Wi-Fi |
| Electrical Ports | NO (Normally Open), COM (Common), NC (Normally Closed) |
| Grove Expansion | I2C × 1, UART × 1 |

### Power Requirements
- **Input:** DC 5V via USB for XIAO
- **Relay Load:** DC 0–30V, max 10A per channel

### Required Libraries/Tools
- **ESPHome** add-on for Home Assistant
- Pre-flashed firmware (can be re-flashed via Web Tool or ESPHome Web)
- **DFU:** Firmware update via Chrome/Edge browser (Firefox not supported)

### Basic Usage
1. Power up → module creates Wi-Fi AP (SSID: `seeedstudio-6-channel-relay`)
2. Connect to AP, navigate to `http://192.168.4.1`
3. Enter home Wi-Fi credentials
4. Module appears in Home Assistant under Settings → Devices & Services
5. Control 6 switches individually from Home Assistant dashboard

### Special Notes
- **SAFETY WARNING:** DC operation ONLY — do NOT connect to AC power
- Voltages exceeding 24V may cause electric shock
- Always disconnect power before wiring
- Pre-flashed with ESPHome firmware for XIAO ESP32C6
- **Pin Conflict:** Uses 6 GPIO pins — most XIAO pins are occupied
- Firmware can be flashed via web tool (Chrome/Edge only, not Firefox)

---

## 7. ePaper Breakout Board for XIAO

**Source:** [Wiki Page](https://wiki.seeedstudio.com/XIAO-eInk-Expansion-Board/)

### Description
Breakout board for driving eInk/ePaper displays with XIAO. Features a 24-pin FPC connector for eInk displays and an 8-pin 2.54mm header for alternative microcontroller connections. Display NOT included — must be purchased separately.

### Communication Interface
- **SPI:** For eInk display communication

### Pin Usage
| Function | XIAO Pin | Notes |
|----------|----------|-------|
| RST | D0 | Display reset |
| CS | D1 | Chip select |
| DC | D3 | Data/Command select |
| BUSY | D5 | Display busy signal |
| SCK | D8 | SPI clock |
| MOSI | D10 | SPI data out |

### Compatible XIAO Boards
- Seeed Studio XIAO SAMD21
- Seeed Studio XIAO RP2040
- Seeed Studio XIAO nRF52840 (Sense)
- Seeed Studio XIAO ESP32C3
- Seeed Studio XIAO ESP32S3 (Sense)

### Key Specifications
| Parameter | Value |
|-----------|-------|
| FPC Connector | 24-pin |
| Alt Header | 8-pin 2.54mm |
| Interface | SPI |

### Supported eInk Displays
| Display | Resolution |
|---------|------------|
| 1.54-inch Dotmatrix | 200 × 200 |
| 2.13-inch Flexible Monochrome | 212 × 104 |
| 2.13-inch Quadruple | 212 × 104 |
| 2.9-inch Monocolor | 128 × 296 |
| 2.9-inch Quadruple color | 128 × 296 |
| 4.2-inch Monocolor | 400 × 300 |
| 4.26-inch Monocolor | 800 × 480 |
| 5.65-inch Sevencolor | 600 × 480 |
| 5.83-inch Monocolor | 648 × 480 |
| 7.5-inch Monocolor | 800 × 480 |
| 7.5-inch Tri-Color | 800 × 480 |

### Power Requirements
- Powered via XIAO USB or XIAO power supply

### Required Libraries
- **Seeed GFX Library** ([GitHub](https://github.com/Seeed-Studio/Seeed_Arduino_LCD))
  - **Note:** Incompatible with TFT library — uninstall TFT library first
- Device-specific driver code generated via online tool

### Basic Usage
1. Install Seeed GFX Library
2. Use online tool to select display type and generate driver code
3. Create `driver.h` file with generated code
4. Upload example sketch (Bitmap, Clock, Shape, etc.)

### Special Notes
- **Display NOT included** — must be purchased separately
- **Pin Conflict:** Uses SPI pins (D8, D10) plus D0, D1, D3, D5 — heavy pin usage
- 1.54-inch and 2.9-inch screens may flicker with dynamic effects (driver chip limitation)
- 5.83-inch and 7.5-inch screens do not flicker
- Not recommended to run dynamic effects for extended periods on small screens
- Seeed GFX Library is NOT compatible with TFT library — must uninstall TFT first
- 8-pin header allows use with non-XIAO microcontrollers

---

## Pin Conflict Summary

| Accessory | Pins Used | Interface | Conflicts With |
|-----------|-----------|-----------|----------------|
| Logger HAT | D4 (SDA), D5 (SCL), D2 (INT), A0 (ADC), D1 (EN) | I2C + ADC + GPIO | ePaper (D1), mmWave (D2) |
| mmWave Sensor | D2 (TX), D3 (RX) | Soft Serial | Logger HAT (D2), ePaper (D3) |
| L76K GNSS | D6 (TX), D7 (RX) | Soft Serial | CAN Bus (D7) |
| reSpeaker Lite | N/A (XIAO plugs into board) | I2S/USB | N/A (separate board) |
| CAN Bus | D7 (CS), D8 (SCK), D9 (MISO), D10 (MOSI) | SPI | L76K (D7), ePaper (D8, D10) |
| 6-Ch Relay | GPIO0, GPIO1, GPIO2, GPIO18, GPIO19, GPIO21 | GPIO | Most pins occupied |
| ePaper Breakout | D0 (RST), D1 (CS), D3 (DC), D5 (BUSY), D8 (SCK), D10 (MOSI) | SPI + GPIO | Logger HAT (D1, D5), mmWave (D3), CAN Bus (D8, D10) |

### Compatible Combinations (no pin conflicts)
- **Logger HAT + L76K GNSS** — I2C (D4/D5) + Soft Serial (D6/D7) ✅
- **Logger HAT + CAN Bus** — I2C (D4/D5) + SPI (D7-D10) ✅ (if Logger INT moved from D2)
- **mmWave + CAN Bus** — Soft Serial (D2/D3) + SPI (D7-D10) ✅
- **mmWave + L76K GNSS** — Soft Serial (D2/D3) + Soft Serial (D6/D7) ✅
- **reSpeaker Lite** — Compatible with anything (separate board)

### Incompatible Combinations (pin conflicts)
- **CAN Bus + ePaper** — Both use SPI (D8, D10) ❌
- **CAN Bus + L76K GNSS** — Both use D7 ❌
- **Logger HAT + ePaper** — Both use D1, D5 ❌
- **mmWave + ePaper** — Both use D3 ❌
- **6-Ch Relay** — Uses most GPIO pins, conflicts with nearly everything ❌
