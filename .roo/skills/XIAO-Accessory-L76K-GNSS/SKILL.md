---
name: xiao-accessory-l76k-gnss
description: >
  Provides comprehensive reference for using the L76K GNSS Module with Seeed Studio XIAO
  microcontrollers. Covers multi-GNSS positioning (GPS, BeiDou, GLONASS, QZSS), UART serial
  communication, NMEA sentence parsing, and active antenna usage. Includes Arduino and TinyGo
  setup, wiring, pin usage, and code examples. Use when integrating the L76K GNSS module for
  GPS/GNSS positioning, navigation, or location tracking on any XIAO board.
  Keywords: XIAO, L76K, GNSS, GPS, BeiDou, GLONASS, QZSS, NMEA, positioning, navigation,
  location, latitude, longitude, satellite, antenna, UART, serial, TinyGPSPlus.
---

# L76K GNSS Module — XIAO Accessory Guide

Provides comprehensive reference for using the L76K GNSS Module with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the L76K GNSS module for GPS/GNSS positioning
- Looking up which XIAO pins the GNSS module occupies
- Writing Arduino or TinyGo firmware to parse NMEA sentences
- Configuring multi-GNSS constellation support
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Multi-GNSS positioning module |
| **Interface** | Software Serial (UART) on D6/D7 |
| **GNSS Bands** | GPS L1 C/A (1575.42MHz), GLONASS L1 (1602MHz), BeiDou B1 (1561.098MHz) |
| **Channels** | 32 tracking / 72 acquisition |
| **TTFF Cold Start** | 30s (w/o AGNSS), 5.5s (w/ AGNSS) |
| **TTFF Hot Start** | 5.5s (w/o AGNSS), 2s (w/ AGNSS) |
| **Position Accuracy** | 2.0m CEP |
| **Velocity Accuracy** | 0.1m/s |
| **Update Rate** | 1Hz (default), 5Hz (max) |
| **Sensitivity (Tracking)** | -162dBm |
| **Sensitivity (Re-acquisition)** | -160dBm |
| **Antenna** | Active antenna, U.FL connector, RF1.13 cable 10cm |
| **Dimensions** | 18 × 21 mm |

### Compatible XIAO Boards

| XIAO Board | Status |
|------------|--------|
| XIAO SAMD21 | ✅ |
| XIAO RP2040 | ✅ (special pin setup needed) |
| XIAO nRF52840 (Sense) | ✅ |
| XIAO ESP32C3 | ✅ |
| XIAO ESP32S3 (Sense) | ✅ |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D6          | GNSS Module TX           | Soft Serial
D7          | GNSS Module RX           | Soft Serial
3V3         | Power Supply             | Power
GND         | Ground                   | Power
```

### RP2040 Special Configuration

On XIAO RP2040, the example code sets D2 and D0 as HIGH outputs:

```
XIAO Pin    | RP2040 Special           | Notes
------------|--------------------------|----------
D0          | Set HIGH (output)        | Required for RP2040
D2          | Set HIGH (output)        | Required for RP2040
D6          | GNSS TX                  | Soft Serial
D7          | GNSS RX                  | Soft Serial
```

---

## Pin Conflict Warning

### Pins OCCUPIED by L76K GNSS
- **D6** — GNSS module TX (soft serial)
- **D7** — GNSS module RX (soft serial)
- On RP2040: also **D0** and **D2** (set HIGH)

### Pins remaining FREE
- D0, D1, D2, D3, D4, D5, D8, D9, D10, A0 (standard boards)
- On RP2040: D1, D3, D4, D5, D8, D9, D10

### Conflicts with other accessories
- **CAN Bus** — conflicts on D7 (SPI CS) ❌
- **Logger HAT** — no conflict ✅ (uses D1/D2/D4/D5/A0)
- **mmWave 24GHz** — no conflict ✅ (uses D2/D3)
- **ePaper Breakout** — no conflict ✅ (uses D0/D1/D3/D5/D8/D10)
- **reSpeaker Lite** — no conflict ✅ (separate board)

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Current (Acquisition/Tracking) | 41mA (with active antenna) |
| Standby Current | 360µA |

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Via Arduino Library Manager:
# - Search "TinyGPSPlus" → install (by Mikal Hart)
# SoftwareSerial is built-in
```

### Initialization

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
    Serial.println("L76K GNSS Module initialized");
}
```

### Complete Working Example — GPS Position

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
    Serial.println("L76K GNSS Module - Position Example");
    Serial.println("Waiting for GPS fix...");
}

void loop() {
    // Feed GPS data
    while (ss.available() > 0) {
        if (gps.encode(ss.read())) {
            displayInfo();
        }
    }

    // Check for timeout
    if (millis() > 5000 && gps.charsProcessed() < 10) {
        Serial.println("ERROR: No GPS data received. Check wiring.");
        while (true);
    }
}

void displayInfo() {
    // Location
    if (gps.location.isValid()) {
        Serial.print("Lat: ");
        Serial.print(gps.location.lat(), 6);
        Serial.print("  Lng: ");
        Serial.print(gps.location.lng(), 6);
    } else {
        Serial.print("Location: INVALID (waiting for fix)");
    }

    // Date/Time
    if (gps.date.isValid() && gps.time.isValid()) {
        Serial.print("  Date: ");
        Serial.print(gps.date.month());
        Serial.print("/");
        Serial.print(gps.date.day());
        Serial.print("/");
        Serial.print(gps.date.year());
        Serial.print(" ");
        if (gps.time.hour() < 10) Serial.print("0");
        Serial.print(gps.time.hour());
        Serial.print(":");
        if (gps.time.minute() < 10) Serial.print("0");
        Serial.print(gps.time.minute());
        Serial.print(":");
        if (gps.time.second() < 10) Serial.print("0");
        Serial.print(gps.time.second());
    }

    // Satellites
    if (gps.satellites.isValid()) {
        Serial.print("  Sats: ");
        Serial.print(gps.satellites.value());
    }

    // Altitude
    if (gps.altitude.isValid()) {
        Serial.print("  Alt: ");
        Serial.print(gps.altitude.meters());
        Serial.print("m");
    }

    // Speed
    if (gps.speed.isValid()) {
        Serial.print("  Speed: ");
        Serial.print(gps.speed.kmph());
        Serial.print("km/h");
    }

    Serial.println();
}
```

### RP2040 Special Setup

```cpp
#include <TinyGPSPlus.h>
#include <SoftwareSerial.h>

static const int RXPin = D7, TXPin = D6;
static const uint32_t GPSBaud = 9600;

TinyGPSPlus gps;
SoftwareSerial ss(RXPin, TXPin);

void setup() {
    Serial.begin(115200);

    // RP2040 special: set D0 and D2 HIGH
    pinMode(D0, OUTPUT);
    pinMode(D2, OUTPUT);
    digitalWrite(D0, HIGH);
    digitalWrite(D2, HIGH);

    ss.begin(GPSBaud);
    Serial.println("L76K GNSS on XIAO RP2040");
}

void loop() {
    while (ss.available() > 0) {
        if (gps.encode(ss.read())) {
            if (gps.location.isValid()) {
                Serial.print("Lat: ");
                Serial.print(gps.location.lat(), 6);
                Serial.print("  Lng: ");
                Serial.println(gps.location.lng(), 6);
            }
        }
    }
}
```

### Raw NMEA Output Example

```cpp
#include <SoftwareSerial.h>

SoftwareSerial ss(D7, D6);

void setup() {
    Serial.begin(115200);
    ss.begin(9600);
    Serial.println("Raw NMEA output:");
}

void loop() {
    while (ss.available()) {
        Serial.write(ss.read());
    }
}
```

---

## TinyGo Setup & Usage

### TinyGo GNSS Example

There is no dedicated TinyGo GNSS driver for L76K. Use UART to read raw NMEA sentences and parse manually or use a Go NMEA parsing library:

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // Configure UART for GNSS module
    uart := machine.UART1
    uart.Configure(machine.UARTConfig{
        BaudRate: 9600,
        TX:       machine.D6,
        RX:       machine.D7,
    })

    // USB serial for output
    machine.Serial.Configure(machine.UARTConfig{
        BaudRate: 115200,
    })

    println("L76K GNSS Module (TinyGo)")
    println("Reading NMEA sentences...")

    buf := make([]byte, 256)
    for {
        n, err := uart.Read(buf)
        if err == nil && n > 0 {
            // Output raw NMEA data
            print(string(buf[:n]))
        }
        time.Sleep(10 * time.Millisecond)
    }
}
```

### Simple NMEA Parser (TinyGo)

```go
package main

import (
    "machine"
    "strconv"
    "strings"
    "time"
    "fmt"
)

func main() {
    uart := machine.UART1
    uart.Configure(machine.UARTConfig{
        BaudRate: 9600,
        TX:       machine.D6,
        RX:       machine.D7,
    })

    println("L76K GNSS - NMEA Parser (TinyGo)")

    var line string
    buf := make([]byte, 1)

    for {
        n, _ := uart.Read(buf)
        if n > 0 {
            ch := buf[0]
            if ch == '\n' {
                parseNMEA(line)
                line = ""
            } else if ch != '\r' {
                line += string(ch)
            }
        }
        time.Sleep(1 * time.Millisecond)
    }
}

func parseNMEA(sentence string) {
    if !strings.HasPrefix(sentence, "$GNGGA") && !strings.HasPrefix(sentence, "$GPGGA") {
        return
    }

    fields := strings.Split(sentence, ",")
    if len(fields) < 10 {
        return
    }

    // fields[2] = latitude, fields[3] = N/S
    // fields[4] = longitude, fields[5] = E/W
    // fields[7] = satellites, fields[9] = altitude
    if fields[2] != "" && fields[4] != "" {
        fmt.Printf("Lat: %s %s  Lng: %s %s  Sats: %s  Alt: %sm\n",
            fields[2], fields[3], fields[4], fields[5], fields[7], fields[9])
    }
}
```

> **⚠ TinyGo Limitation:** Software serial is not available in TinyGo. You must use a hardware UART. Verify that D6/D7 can be mapped to a hardware UART on your specific XIAO board.

---

## Communication Protocol Details

### UART Configuration

| Parameter | Value |
|-----------|-------|
| Default Baud Rate | 9600bps |
| Configurable Range | 9600–115200bps |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |
| Protocol | NMEA 0183, CASIC proprietary |

### NMEA Sentence Types

The L76K outputs standard NMEA 0183 sentences:

| Sentence | Description |
|----------|-------------|
| `$GNGGA` | Global positioning fix data (lat, lng, alt, sats) |
| `$GNRMC` | Recommended minimum (lat, lng, speed, course, date) |
| `$GNGSA` | DOP and active satellites |
| `$GNGSV` | Satellites in view |
| `$GNVTG` | Track made good and ground speed |
| `$GNGLL` | Geographic position (lat/lng) |

### Example NMEA Sentence

```
$GNGGA,123519.00,4807.038,N,01131.000,E,1,08,0.9,545.4,M,47.0,M,,*47
```

| Field | Value | Meaning |
|-------|-------|---------|
| Time | 123519.00 | 12:35:19 UTC |
| Latitude | 4807.038,N | 48°07.038'N |
| Longitude | 01131.000,E | 11°31.000'E |
| Fix Quality | 1 | GPS fix |
| Satellites | 08 | 8 satellites tracked |
| HDOP | 0.9 | Horizontal dilution |
| Altitude | 545.4,M | 545.4 meters |

### CASIC Proprietary Protocol

The L76K also supports CASIC proprietary protocol for advanced configuration (constellation selection, update rate, power modes). Refer to the Quectel L76K protocol specification for CASIC command details.

---

## Common Gotchas / Notes

1. **⚠ CRITICAL: Do not plug in backwards** — Incorrect orientation can burn the module or XIAO
2. **Outdoor use required** — GNSS signals cannot penetrate buildings; place the antenna outdoors with clear sky view
3. **Active antenna** — The included antenna connects via U.FL connector; ensure it is properly seated
4. **Cold start time** — First fix after power-on takes ~30 seconds (cold start); subsequent fixes are faster (~5.5s hot start)
5. **Software serial baud rate** — Default 9600bps works reliably with software serial on all boards
6. **RP2040 special pins** — On XIAO RP2040, D0 and D2 must be set HIGH as outputs for proper operation
7. **Multi-constellation** — Supports GPS + BeiDou + GLONASS simultaneously for better accuracy and faster fix
8. **1PPS LED** — The module has a 1PPS (pulse per second) LED that blinks when a fix is acquired
9. **Pin D6/D7** — On ESP32C3, D6 is TX (GPIO21) and D7 is RX (GPIO20) — these are the hardware UART pins

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/get_start_l76k_gnss/
- **TinyGPSPlus Library:** https://github.com/mikalhart/TinyGPSPlus
- **Quectel L76K Datasheet:** https://www.quectel.com/product/gnss-l76k
- **NMEA 0183 Reference:** https://www.nmea.org/content/STANDARDS/NMEA_0183_Standard
