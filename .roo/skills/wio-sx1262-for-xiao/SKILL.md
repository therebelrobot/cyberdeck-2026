---
name: wio-sx1262-for-xiao
description: >
  Provides comprehensive reference for using the Wio-SX1262 LoRa module with Seeed Studio XIAO
  microcontrollers. Covers SX1262 chip, SPI communication, frequency bands (433/868/915MHz),
  transmit power, receive sensitivity, antenna connections, and RadioLib integration. Includes
  Arduino and TinyGo setup, wiring, pin usage, and code examples. Use when integrating LoRa
  communication for long-range sensors, mesh networks, remote control, or IoT applications on
  any XIAO board.
  Keywords: Wio-SX1262, XIAO, LoRa, SX1262, SPI, long-range, 433MHz, 868MHz, 915MHz, radio,
  wireless, mesh, sensor, remote, IoT, Seeed Studio, RadioLib.
---

# Wio-SX1262 for XIAO — Accessory Guide

Provides comprehensive reference for using the Wio-SX1262 LoRa module with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the Wio-SX1262 LoRa module for long-range wireless communication
- Looking up which XIAO pins the Wio-SX1262 module occupies
- Writing Arduino or TinyGo firmware for LoRa send/receive operations
- Configuring SX1262 via SPI using RadioLib
- Checking pin conflicts with other XIAO accessories
- Setting up LoRa for sensor networks, remote control, or mesh networking

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | LoRa transceiver module |
| **Chip** | Semtech SX1262 |
| **Interface** | SPI |
| **Frequency Bands** | 433MHz, 868MHz, 915MHz (region-dependent) |
| **Max Tx Power** | Up to +22dBm (160mW) |
| **Receive Sensitivity** | Down to -148dBm |
| **Communication Range** | Up to 10km (line of sight, with good antenna) |
| **Antenna** | IPEX/u.FL connector (external antenna required) |
| **Logic Voltage** | 3.3V (compatible with XIAO 3.3V logic) |

### Compatible XIAO Boards

All Seeed Studio XIAO boards with SPI support are compatible:
- XIAO SAMD21
- XIAO RP2040
- XIAO RP2350
- XIAO nRF52840
- XIAO nRF54L15
- XIAO ESP32C3
- XIAO ESP32C5
- XIAO ESP32C6
- XIAO ESP32S3
- XIAO RA4M1
- XIAO MG24

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D8          | SPI Clock (SCK)          | SPI
D9          | SPI Data In (MISO)       | SPI
D10         | SPI Data Out (MOSI)      | SPI
D7          | Chip Select (CS)         | SPI
D3          | Reset (RST)              | GPIO
D2          | Busy Indicator (BUSY)    | GPIO (interrupt capable)
```

> **Note:** Pin assignments may vary slightly depending on the specific Wio-SX1262 board version. Always verify with the board's pinout diagram.

### Antenna Connection

```
Antenna Port | Type
-------------|------------------
ANT          | IPEX/u.FL connector for external LoRa antenna
```

---

## Pin Conflict Warning

### Pins OCCUPIED by Wio-SX1262
- **D7** — SPI Chip Select (CS)
- **D8** — SPI Clock (SCK)
- **D9** — SPI Data In (MISO)
- **D10** — SPI Data Out (MOSI)
- **D3** — Reset (RST)
- **D2** — Busy Indicator (BUSY)

### Pins remaining FREE
- D0, D1, D4, D5, D6, A0

### Conflicts with other accessories
- **CAN Bus** — conflicts on D7, D8, D9, D10 ❌
- **ePaper Breakout** — conflicts on D8 and D10 (SPI) ❌
- **L76K GNSS** — no conflict ✅ (uses D0/D1)
- **Logger HAT** — no conflict ✅ (uses D1/D2/D4/D5/A0)
- **mmWave 24GHz** — conflicts on D2 (BUSY) ❌
- **reSpeaker Lite** — no conflict ✅ (separate board)

> **Note:** The SPI bus (D8/D9/D10) can be shared with other SPI devices using different CS pins. The Wio-SX1262 only occupies D7 as its dedicated CS.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | Via XIAO 3.3V |
| Supply Voltage | 3.3V |
| Current Consumption | ~120mA during transmit (max), ~5mA during receive |
| Low Power Mode | Supported (sleep current < 1μA) |

---

## Arduino Setup & Usage

### Required Libraries

The recommended library for SX1262 is **RadioLib**:

```bash
# Install via Arduino Library Manager:
# Sketch → Include Library → Manage Libraries → search "RadioLib" → Install

# Or install via platform.txt/board_manager JSON (if available)
```

### RadioLib Installation Steps

1. Open Arduino IDE
2. Go to **Sketch → Include Library → Manage Libraries**
3. Search for "RadioLib" by @jgromes
4. Click "Install"
5. Wait for installation to complete

### Initialization

```cpp
#include <RadioLib.h>

//SX1262 has the following connections:
//CS pin:    D7
//RST pin:   D3
//BUSY pin:  D2
//SPI:       default SPI (D8=SCK, D9=MISO, D10=MOSI)

SX1262 radio = new Module(D7, D3, D2);

void setup() {
    Serial.begin(115200);

    // Initialize SX1262
    int state = radio.begin(868.0);  // 868MHz for Europe
    // For US: 915.0, for Asia: 433.0

    if (state == ERR_NONE) {
        Serial.println("SX1262 initialized successfully!");
    } else {
        Serial.print("Initialization failed, code: ");
        Serial.println(state);
    }

    // Set transmit power (0 to +22dBm, in dBm steps)
    radio.setOutputPower(22);

    // Set spreading factor (7-12, higher = slower but longer range)
    radio.setSpreadingFactor(12);

    // Set bandwidth (7.8kHz to 500kHz, higher = faster but less range)
    radio.setBandwidth(125.0);

    // Set coding rate (5-8, higher = more error correction, slower)
    radio.setCodingRate(8);

    Serial.println("LoRa Radio Configured:");
    Serial.print("Frequency: 868.0 MHz\n");
    Serial.print("Power: +22 dBm\n");
    Serial.print("SF: 12, BW: 125kHz, CR: 8\n");
}

void loop() {
    // See example code below
}
```

### Complete Working Example — LoRa Transmitter

```cpp
#include <RadioLib.h>

// XIAO ESP32C3 connections
#define LORA_CS    D7
#define LORA_RST   D3
#define LORA_BUSY  D2

SX1262 radio = new Module(LORA_CS, LORA_RST, LORA_BUSY);

void setup() {
    Serial.begin(115200);
    delay(100);

    // Initialize LoRa at 868MHz
    int state = radio.begin(868.0);
    if (state != ERR_NONE) {
        Serial.print("LoRa init failed: ");
        Serial.println(state);
        while (true);
    }

    // Configure for long range
    radio.setSpreadingFactor(12);
    radio.setBandwidth(125.0);
    radio.setCodingRate(8);
    radio.setOutputPower(22);

    Serial.println("LoRa Transmitter Ready");
}

void loop() {
    // Create message
    String message = "Hello from XIAO! Counter: ";
    static int counter = 0;
    message += String(counter++);

    // Send packet
    Serial.print("Sending: ");
    Serial.println(message);

    int state = radio.startTransmit(message.c_str());
    if (state == ERR_NONE) {
        Serial.println("Transmit complete!");
    } else {
        Serial.print("Transmit failed, code: ");
        Serial.println(state);
    }

    // Wait before next transmission
    delay(5000);
}
```

### Complete Working Example — LoRa Receiver

```cpp
#include <RadioLib.h>

#define LORA_CS    D7
#define LORA_RST   D3
#define LORA_BUSY  D2

SX1262 radio = new Module(LORA_CS, LORA_RST, LORA_BUSY);

void setup() {
    Serial.begin(115200);
    delay(100);

    // Initialize LoRa at 868MHz
    int state = radio.begin(868.0);
    if (state != ERR_NONE) {
        Serial.print("LoRa init failed: ");
        Serial.println(state);
        while (true);
    }

    // Configure matching settings as transmitter
    radio.setSpreadingFactor(12);
    radio.setBandwidth(125.0);
    radio.setCodingRate(8);

    Serial.println("LoRa Receiver Ready");
}

void loop() {
    // Check for incoming packets
    int state = radio.receive();

    if (state == ERR_NONE) {
        // Packet received successfully
        String message;
        radio.getData(message);

        Serial.print("Received: ");
        Serial.println(message);

        // Print RSSI (signal strength)
        Serial.print("RSSI: ");
        Serial.print(radio.getRSSI());
        Serial.println(" dBm");

        // Print SNR (signal-to-noise ratio)
        Serial.print("SNR: ");
        Serial.print(radio.getSNR());
        Serial.println(" dB");
    } else if (state == ERR_RX_TIMEOUT) {
        // No packet received within timeout
        // This is normal, just wait
    } else {
        Serial.print("Receive failed, code: ");
        Serial.println(state);
    }
}
```

### LoRa Chat Example (Bidirectional)

```cpp
#include <RadioLib.h>

#define LORA_CS    D7
#define LORA_RST   D3
#define LORA_BUSY  D2

SX1262 radio = new Module(LORA_CS, LORA_RST, LORA_BUSY);

bool transmitting = false;
unsigned long lastAction = 0;

void setup() {
    Serial.begin(115200);

    int state = radio.begin(868.0);
    if (state != ERR_NONE) {
        Serial.print("Init failed: ");
        Serial.println(state);
    }

    radio.setSpreadingFactor(12);
    radio.setBandwidth(125.0);
    radio.setCodingRate(8);
    radio.setOutputPower(22);

    Serial.println("LoRa Bidirectional Ready");
}

void loop() {
    unsigned long now = millis();

    // Toggle between TX and RX every 10 seconds
    if (now - lastAction > 10000) {
        transmitting = !transmitting;
        lastAction = now;

        if (transmitting) {
            radio.startTransmit("PING");
            Serial.println("Sent: PING");
        }
    }

    if (!transmitting) {
        int state = radio.receive();
        if (state == ERR_NONE) {
            String msg;
            radio.getData(msg);
            Serial.print("Received: ");
            Serial.println(msg);
        }
    }
}
```

### Frequency Bands by Region

| Region | Frequency | Common Use |
|--------|-----------|------------|
| Europe | 863-870MHz (typically 868MHz) | Short Range Devices (SRD) |
| US | 902-928MHz (typically 915MHz) | ISM band |
| Asia | 433MHz, 470-510MHz | Various ISM allocations |
| Japan | 429-433MHz, 920-925MHz | ARIB STD-T108 |

### LoRa Parameters Explained

| Parameter | Options | Effect |
|-----------|---------|--------|
| Spreading Factor (SF) | 7-12 | Higher = longer range, slower |
| Bandwidth (BW) | 7.8-500kHz | Higher = faster, less range |
| Coding Rate (CR) | 5-8 | Higher = more error correction |
| Output Power | 0 to +22dBm | Higher = longer range, more power |

---

## TinyGo Setup & Usage

### RadioLib for TinyGo

RadioLib support in TinyGo varies by platform. Check the latest status at:
- https://github.com/astrocrafter/RadioLib
- https://github.com/nicholaskuechler/tinygo-sx126x

### Basic TinyGo Example (for ESP32-C3)

```go
package main

import (
    "fmt"
    "machine"
    "time"

    "github.com/nicholaskuechler/tinygo-sx126x"
)

func main() {
    // Configure SPI
    spi := machine.SPI0
    err := spi.Configure(machine.SPIConfig{
        SCK:       machine.D8,
        SDO:       machine.D10, // MOSI
        SDI:       machine.D9,  // MISO
        Frequency: 1000000,     // 1MHz
        Mode:      0,
    })
    if err != nil {
        fmt.Printf("SPI config failed: %v\n", err)
        return
    }

    // Configure control pins
    cs := machine.D7
    cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
    cs.High()

    rst := machine.D3
    rst.Configure(machine.PinConfig{Mode: machine.PinOutput})

    busy := machine.D2
    busy.Configure(machine.PinConfig{Mode: machine.PinInput})

    println("Initializing SX1262...")

    // Initialize radio
    radio := sx126x.New(spi, cs, rst, busy)
    err = radio.Init()
    if err != nil {
        fmt.Printf("Radio init failed: %v\n", err)
        return
    }

    // Set frequency
    err = radio.SetFrequency(868000000) // 868MHz
    if err != nil {
        fmt.Printf("SetFrequency failed: %v\n", err)
        return
    }

    // Set output power
    err = radio.SetOutputPower(22)
    if err != nil {
        fmt.Printf("SetOutputPower failed: %v\n", err)
        return
    }

    println("SX1262 initialized successfully")

    // Send a packet
    msg := []byte("Hello from TinyGo!")
    err = radio.Transmit(msg)
    if err != nil {
        fmt.Printf("Transmit failed: %v\n", err)
    } else {
        println("Message transmitted!")
    }

    // Receive mode
    radio.SetRxMode()
    println("Listening for packets...")

    for {
        if !busy.Get() {
            data, err := radio.Receive()
            if err == nil && len(data) > 0 {
                fmt.Printf("Received: %s\n", string(data))
            }
        }
        time.Sleep(10 * time.Millisecond)
    }
}
```

> **Note:** TinyGo support for SX1262 is less mature than Arduino. Check the GitHub repository for the latest API and supported platforms.

---

## Communication Protocol Details

### SPI Configuration (XIAO ↔ SX1262)

| Parameter | Value |
|-----------|-------|
| SPI Mode | Mode 0 (CPOL=0, CPHA=0) |
| Clock Speed | Up to 10MHz (typically 1-8MHz) |
| CS Pin | D7 |
| SCK Pin | D8 |
| MISO Pin | D9 |
| MOSI Pin | D10 |
| Byte Order | MSB first |

### GPIO Pins

| Pin | Function | Direction |
|-----|----------|-----------|
| D3 | Reset | Output (active low) |
| D2 | Busy | Input (indicates radio is busy) |

### LoRa Radio Parameters

| Parameter | Value |
|-----------|-------|
| Chip | Semtech SX1262 |
| Frequency Range | 150-960MHz (model dependent) |
| Max Power | +22dBm (160mW) |
| Receive Sensitivity | -148dBm |
| Sleep Current | < 1μA |
| Operating Temperature | -40°C to +85°C |

---

## Common Gotchas / Notes

1. **Antenna Required** — Never operate the LoRa module without an appropriate antenna connected to the IPEX/u.FL connector. Operating without antenna may damage the radio.
2. **Frequency Compliance** — Ensure the LoRa frequency settings comply with local regulations for your region. The 868MHz band is for Europe, 915MHz is for US, 433MHz is common in Asia.
3. **Matching Parameters** — Transmitter and receiver must use identical LoRa parameters (SF, BW, CR) to communicate successfully.
4. **Busy Pin** — Always check the BUSY pin before issuing commands. The radio cannot accept new commands while processing.
5. **SPI Speed** — While the SX1262 supports up to 10MHz SPI, start with lower speeds (1MHz) for reliability, then increase if stable.
6. **Power Supply** — The SX1262 can draw up to 120mA during transmit at maximum power. Ensure XIAO's 3.3V supply can handle this. Consider an external power supply for battery applications.
7. **Line of Sight** — LoRa range is significantly affected by obstacles. For maximum range, ensure line of sight between antennas.
8. **Busy conflicts** — The mmWave 24GHz sensor also uses D2 for interrupt, creating a conflict if both are needed.
9. **Software Reset** — If communication fails, toggling the RST pin low for 100ms then releasing can recover the radio to a known state.

---

## Reference Links

- **RadioLib Library:** https://github.com/astrocrafter/RadioLib
- **TinyGo SX1262 Driver:** https://github.com/nicholaskuechler/tinygo-sx126x
- **SX1262 Datasheet:** https://www.semtech.com/products/wireless-rf/lora-core/sx1262
- **Seeed Studio Wiki:** https://wiki.seeedstudio.com/ (search Wio-SX1262)
- **LoRa Calculator:** https://www.loratrack.dk/ (for range estimation)
- **Regional Frequencies:** https://www.thethingsnetwork.org/wiki/technical-guides/frequencies-by-country