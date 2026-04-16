---
name: xiao-accessory-canbus
description: >
  Provides comprehensive reference for using the CAN Bus Breakout Board with Seeed Studio XIAO
  microcontrollers. Covers MCP2515 CAN controller, SN65HVD230 transceiver, SPI communication,
  CAN message send/receive, and bus termination. Includes Arduino and TinyGo setup, wiring,
  pin usage, and code examples. Use when integrating CAN bus communication for automotive,
  industrial, robotics, or IoT applications on any XIAO board.
  Keywords: XIAO, CAN, CAN bus, MCP2515, SN65HVD230, SPI, transceiver, automotive, industrial,
  robotics, OBD, vehicle, breakout, termination, 120 ohm.
---

# CAN Bus Breakout Board — XIAO Accessory Guide

Provides comprehensive reference for using the CAN Bus Breakout Board with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the CAN Bus Breakout Board for CAN communication
- Looking up which XIAO pins the CAN Bus board occupies
- Writing Arduino or TinyGo firmware to send/receive CAN messages
- Configuring MCP2515 CAN controller via SPI
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | CAN bus communication breakout board |
| **CAN Controller** | MCP2515 |
| **CAN Transceiver** | SN65HVD230 |
| **Interface** | SPI (XIAO to MCP2515) |
| **Terminal Connection** | 2-pin screw terminal for CAN-H and CAN-L |
| **Supported Baud Rates** | 5Kbps to 1000Kbps |
| **LED Indicators** | RX/TX activity LEDs |
| **Termination Resistor** | 120Ω (optional, via P1 solder pad on back) |
| **Power** | Via XIAO USB or XIAO power supply |

### Compatible XIAO Boards

All Seeed Studio XIAO boards are compatible (demonstrated with XIAO ESP32C3).

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D7          | SPI Chip Select (CS)     | SPI
D8          | SPI Clock (SCK)          | SPI
D9          | SPI Data In (MISO)       | SPI
D10         | SPI Data Out (MOSI)      | SPI
```

### CAN Bus Terminal Connections

```
Terminal    | Function
------------|------------------
CAN-H       | CAN bus high line
CAN-L       | CAN bus low line
GND         | Ground reference
```

---

## Pin Conflict Warning

### Pins OCCUPIED by CAN Bus Board
- **D7** — SPI Chip Select (CS)
- **D8** — SPI Clock (SCK)
- **D9** — SPI Data In (MISO)
- **D10** — SPI Data Out (MOSI)

### Pins remaining FREE
- D0, D1, D2, D3, D4, D5, D6, A0

### Conflicts with other accessories
- **L76K GNSS** — conflicts on D7 ❌
- **ePaper Breakout** — conflicts on D8 and D10 (SPI) ❌
- **Logger HAT** — no conflict ✅ (uses D1/D2/D4/D5/A0)
- **mmWave 24GHz** — no conflict ✅ (uses D2/D3)
- **reSpeaker Lite** — no conflict ✅ (separate board)

> **Note:** The SPI bus (D8/D9/D10) could theoretically be shared with other SPI devices using different CS pins, but the CAN Bus board uses D7 as CS and does not expose the SPI bus for sharing.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | Via XIAO USB or XIAO power supply |
| CAN Bus Voltage | Differential signaling (CAN-H/CAN-L) |

---

## Arduino Setup & Usage

### Required Libraries

```bash
# Download from GitHub and install manually:
# https://github.com/Seeed-Studio/Seeed_Arduino_CAN
#
# In Arduino IDE:
# Sketch → Include Library → Add .ZIP Library → select downloaded ZIP
```

### Initialization

```cpp
#include <mcp_can.h>
#include <SPI.h>

#define SPI_CS_PIN D7

MCP_CAN CAN(SPI_CS_PIN);

void setup() {
    Serial.begin(115200);

    // Initialize CAN bus at 500Kbps
    while (CAN_OK != CAN.begin(CAN_500KBPS)) {
        Serial.println("CAN BUS init failed, retrying...");
        delay(100);
    }
    Serial.println("CAN BUS initialized OK!");
}
```

### Complete Working Example — Send CAN Message

```cpp
#include <mcp_can.h>
#include <SPI.h>

#define SPI_CS_PIN D7

MCP_CAN CAN(SPI_CS_PIN);

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(100);

    while (CAN_OK != CAN.begin(CAN_500KBPS)) {
        Serial.println("CAN BUS FAIL! Retrying...");
        delay(100);
    }
    Serial.println("CAN BUS OK!");
}

void loop() {
    // Send a standard CAN message
    unsigned char data[8] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};

    // sendMsgBuf(ID, extended frame, data length, data)
    // ID=0x100, standard frame (0), 8 bytes
    byte result = CAN.sendMsgBuf(0x100, 0, 8, data);

    if (result == CAN_OK) {
        Serial.println("Message sent successfully");
    } else {
        Serial.println("Error sending message");
    }

    delay(1000);
}
```

### Complete Working Example — Receive CAN Message

```cpp
#include <mcp_can.h>
#include <SPI.h>

#define SPI_CS_PIN D7

MCP_CAN CAN(SPI_CS_PIN);

void setup() {
    Serial.begin(115200);
    while (!Serial) delay(100);

    while (CAN_OK != CAN.begin(CAN_500KBPS)) {
        Serial.println("CAN BUS FAIL! Retrying...");
        delay(100);
    }
    Serial.println("CAN BUS OK! Waiting for messages...");
}

void loop() {
    unsigned char len = 0;
    unsigned char buf[8];

    // Check if data is available
    if (CAN_MSGAVAIL == CAN.checkReceive()) {
        CAN.readMsgBuf(&len, buf);

        unsigned long canId = CAN.getCanId();

        Serial.print("ID: 0x");
        Serial.print(canId, HEX);
        Serial.print("  Len: ");
        Serial.print(len);
        Serial.print("  Data: ");

        for (int i = 0; i < len; i++) {
            Serial.print("0x");
            if (buf[i] < 0x10) Serial.print("0");
            Serial.print(buf[i], HEX);
            Serial.print(" ");
        }
        Serial.println();
    }
}
```

### CAN Message with Mask and Filter

```cpp
#include <mcp_can.h>
#include <SPI.h>

#define SPI_CS_PIN D7

MCP_CAN CAN(SPI_CS_PIN);

void setup() {
    Serial.begin(115200);

    while (CAN_OK != CAN.begin(CAN_500KBPS)) {
        delay(100);
    }

    // Set mask and filter to only receive messages with ID 0x100-0x1FF
    // Mask: bits that must match
    CAN.init_Mask(0, 0, 0x700); // Mask 0: check upper 3 bits of ID
    CAN.init_Mask(1, 0, 0x700);

    // Filter: expected values for masked bits
    CAN.init_Filt(0, 0, 0x100); // Accept IDs 0x100-0x1FF
    CAN.init_Filt(1, 0, 0x100);
    CAN.init_Filt(2, 0, 0x100);
    CAN.init_Filt(3, 0, 0x100);
    CAN.init_Filt(4, 0, 0x100);
    CAN.init_Filt(5, 0, 0x100);

    Serial.println("CAN filter set: accepting 0x100-0x1FF only");
}

void loop() {
    unsigned char len = 0;
    unsigned char buf[8];

    if (CAN_MSGAVAIL == CAN.checkReceive()) {
        CAN.readMsgBuf(&len, buf);
        unsigned long canId = CAN.getCanId();

        Serial.print("Filtered ID: 0x");
        Serial.println(canId, HEX);
    }
}
```

### Extended CAN Frame Example

```cpp
// Send extended CAN frame (29-bit ID)
unsigned char data[8] = {0xAA, 0xBB, 0xCC, 0xDD, 0x00, 0x00, 0x00, 0x00};

// sendMsgBuf(ID, extended frame (1), data length, data)
CAN.sendMsgBuf(0x18DAF110, 1, 8, data); // Extended frame with 29-bit ID
```

### API Reference

| Function | Description |
|----------|-------------|
| `CAN.begin(baudrate)` | Initialize CAN bus at specified baud rate |
| `CAN.sendMsgBuf(id, ext, len, data)` | Send CAN message (ext=0 standard, ext=1 extended) |
| `CAN.checkReceive()` | Check if message is available (returns `CAN_MSGAVAIL`) |
| `CAN.readMsgBuf(&len, buf)` | Read received message into buffer |
| `CAN.getCanId()` | Get ID of last received message |
| `CAN.init_Mask(num, ext, mask)` | Set acceptance mask |
| `CAN.init_Filt(num, ext, filter)` | Set acceptance filter |

### Supported Baud Rates

| Constant | Baud Rate |
|----------|-----------|
| `CAN_5KBPS` | 5 Kbps |
| `CAN_10KBPS` | 10 Kbps |
| `CAN_20KBPS` | 20 Kbps |
| `CAN_25KBPS` | 25 Kbps |
| `CAN_31K25BPS` | 31.25 Kbps |
| `CAN_33KBPS` | 33 Kbps |
| `CAN_40KBPS` | 40 Kbps |
| `CAN_50KBPS` | 50 Kbps |
| `CAN_80KBPS` | 80 Kbps |
| `CAN_100KBPS` | 100 Kbps |
| `CAN_125KBPS` | 125 Kbps |
| `CAN_200KBPS` | 200 Kbps |
| `CAN_250KBPS` | 250 Kbps |
| `CAN_500KBPS` | 500 Kbps |
| `CAN_1000KBPS` | 1000 Kbps |

---

## TinyGo Setup & Usage

### TinyGo MCP2515 Driver

TinyGo has an MCP2515 driver in the drivers package:

```bash
go get tinygo.org/x/drivers/mcp2515
```

### TinyGo CAN Bus Example

```go
package main

import (
    "fmt"
    "machine"
    "time"

    "tinygo.org/x/drivers/mcp2515"
)

func main() {
    // Configure SPI
    spi := machine.SPI0
    spi.Configure(machine.SPIConfig{
        SCK:       machine.D8,
        SDO:       machine.D10, // MOSI
        SDI:       machine.D9,  // MISO
        Frequency: 1000000,     // 1MHz
        Mode:      0,
    })

    // Configure CS pin
    cs := machine.D7
    cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
    cs.High()

    // Initialize MCP2515
    can := mcp2515.New(spi, cs)
    err := can.Configure()
    if err != nil {
        println("CAN init failed:", err.Error())
        return
    }

    // Set baud rate to 500Kbps
    can.SetBitRate(500000)

    println("CAN Bus initialized (TinyGo)")

    // Send a message
    msg := mcp2515.Frame{
        ID:   0x100,
        Data: [8]byte{0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08},
        Len:  8,
    }

    for {
        err := can.Transmit(msg)
        if err != nil {
            fmt.Printf("Send error: %s\n", err.Error())
        } else {
            println("Message sent: ID=0x100")
        }
        time.Sleep(1 * time.Second)
    }
}
```

### TinyGo CAN Receive Example

```go
package main

import (
    "fmt"
    "machine"
    "time"

    "tinygo.org/x/drivers/mcp2515"
)

func main() {
    spi := machine.SPI0
    spi.Configure(machine.SPIConfig{
        SCK:       machine.D8,
        SDO:       machine.D10,
        SDI:       machine.D9,
        Frequency: 1000000,
        Mode:      0,
    })

    cs := machine.D7
    cs.Configure(machine.PinConfig{Mode: machine.PinOutput})
    cs.High()

    can := mcp2515.New(spi, cs)
    can.Configure()
    can.SetBitRate(500000)

    println("CAN Bus receiver ready (TinyGo)")

    for {
        frame, err := can.Receive()
        if err == nil {
            fmt.Printf("ID: 0x%X  Len: %d  Data: ", frame.ID, frame.Len)
            for i := 0; i < int(frame.Len); i++ {
                fmt.Printf("0x%02X ", frame.Data[i])
            }
            println()
        }
        time.Sleep(10 * time.Millisecond)
    }
}
```

> **Note:** Verify the TinyGo MCP2515 driver API against the latest version at `tinygo.org/x/drivers`. The API shown above is representative but may differ in newer releases.

---

## Communication Protocol Details

### SPI Configuration (XIAO ↔ MCP2515)

| Parameter | Value |
|-----------|-------|
| SPI Mode | Mode 0 (CPOL=0, CPHA=0) |
| Clock Speed | Up to 10MHz |
| CS Pin | D7 |
| SCK Pin | D8 |
| MISO Pin | D9 |
| MOSI Pin | D10 |
| Byte Order | MSB first |

### CAN Bus Physical Layer

| Parameter | Value |
|-----------|-------|
| Transceiver | SN65HVD230 |
| Signaling | Differential (CAN-H, CAN-L) |
| Dominant Level | CAN-H ≈ 3.5V, CAN-L ≈ 1.5V |
| Recessive Level | CAN-H ≈ CAN-L ≈ 2.5V |
| Max Bus Length | Depends on baud rate (40m at 1Mbps, 1km at 50Kbps) |
| Termination | 120Ω at each end of bus |

### CAN Frame Format

| Field | Standard Frame | Extended Frame |
|-------|---------------|----------------|
| ID | 11 bits (0x000–0x7FF) | 29 bits (0x00000000–0x1FFFFFFF) |
| Data | 0–8 bytes | 0–8 bytes |
| RTR | Remote request bit | Remote request bit |

---

## Common Gotchas / Notes

1. **120Ω Termination** — The P1 solder pad on the back of the board enables a 120Ω termination resistor. Short it if CAN communication fails or if this board is at the end of the CAN bus. A CAN bus requires exactly two 120Ω terminators (one at each end).
2. **SPI strapping pins** — On ESP32-C3, D8 (GPIO8) and D9 (GPIO9) are strapping pins. SPI devices must not pull these LOW during boot.
3. **CAN bus requires two nodes** — You need at least two CAN devices on the bus to communicate. A single node cannot send messages without acknowledgment from another node.
4. **Ground reference** — Always connect GND between CAN nodes for reliable communication.
5. **Bus length vs speed** — Higher baud rates require shorter bus lengths. 500Kbps is reliable up to ~100m.
6. **RX/TX LEDs** — The board has activity LEDs that blink during CAN communication — useful for debugging.
7. **MCP2515 crystal** — The onboard crystal frequency affects baud rate accuracy. The Seeed board uses an 8MHz crystal.
8. **No CAN FD support** — MCP2515 supports classic CAN only (not CAN FD).

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao-can-bus-expansion/
- **mcp_can Library:** https://github.com/Seeed-Studio/Seeed_Arduino_CAN
- **MCP2515 Datasheet:** https://ww1.microchip.com/downloads/en/DeviceDoc/MCP2515-Stand-Alone-CAN-Controller-with-SPI-20001801J.pdf
- **SN65HVD230 Datasheet:** https://www.ti.com/lit/ds/symlink/sn65hvd230.pdf
- **CAN Bus Specification:** ISO 11898
