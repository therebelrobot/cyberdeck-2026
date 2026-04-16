---
name: xiao-accessory-rs485
description: >
  Provides comprehensive reference for using the RS485 Breakout Board with Seeed Studio XIAO
  microcontrollers. Covers UART-based RS485 half-duplex communication, 120Ω termination switch,
  5V IN/OUT switch, enable pin direction control, and HardwareSerial usage. Includes Arduino and
  TinyGo setup, wiring, pin usage, and code examples. Use when integrating industrial RS485
  serial communication on any XIAO board.
  Keywords: XIAO, RS485, serial, UART, half-duplex, industrial, Modbus, transceiver, termination,
  120 ohm, breakout, enable, direction, differential.
---

# RS485 Breakout Board — XIAO Accessory Guide

Provides comprehensive reference for using the RS485 Breakout Board with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the RS485 Breakout Board for industrial serial communication
- Looking up which XIAO pins the RS485 board occupies
- Writing Arduino or TinyGo firmware for RS485 half-duplex send/receive
- Configuring enable pin direction control (transmit vs receive)
- Checking pin conflicts with other XIAO accessories

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill
- For CAN bus communication → use the CAN Bus accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | RS485 serial communication breakout board |
| **Protocol** | RS485 half-duplex |
| **Interface** | UART (via RS485 transceiver) |
| **Baud Rate** | Up to 115200 (documented) |
| **Termination** | 120Ω switchable resistor |
| **5V Port** | Switchable IN/OUT |
| **INT Port** | Reserved interrupt port |
| **Dimensions** | Not specified |

### Compatible XIAO Boards

| Board | Status | Notes |
|-------|--------|-------|
| XIAO ESP32-C3 | ✅ | Documented example board |
| Other XIAO boards | ✅ | Modify pin configurations for UART mapping |

---

## Pin Usage Diagram

```
XIAO Pin    | Accessory Function       | Protocol
------------|--------------------------|----------
D2          | Enable Pin               | GPIO (HIGH=TX, LOW=RX)
D4 (GPIO6)  | RS485 Receive (RX)       | UART
D5 (GPIO7)  | RS485 Transmit (TX)      | UART
```

> **Note:** GPIO numbers shown are for ESP32-C3. Other XIAO boards may have different GPIO mappings for D4/D5.

### RS485 Terminal Connections

```
Terminal    | Function
------------|------------------
A (+)       | RS485 non-inverting
B (-)       | RS485 inverting
GND         | Ground reference
```

---

## Pin Conflict Warning

### Pins OCCUPIED by RS485 Board
- **D2** — Enable pin (direction control)
- **D4** — UART RX
- **D5** — UART TX

### Pins remaining FREE
- D0, D1, D3, D6, D7, D8, D9, D10, A0

### Conflicts with other accessories
- **COB LED Driver** — conflicts on D2 (PWM port) ❌
- **ePaper Driver Board** — conflicts on D2 (BUSY) ❌
- **Expansion Board Base** — conflicts on D2 (SD CS), D4/D5 (I2C SDA/SCL) ❌
- **CAN Bus Board** — no conflict ✅ (uses D7/D8/D9/D10)
- **Grove Vision AI V2** — conflicts on D4/D5 if using default I2C ❌

> **Note:** D2 is a major conflict point — used by multiple accessories. The RS485 board uses only 3 pins, leaving most GPIO free.

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Source | Via XIAO USB-C |
| 5V Port | Switchable IN/OUT for external power/sensor supply |

> ⚠️ **5V IN/OUT switch must be set correctly** — IN for input mode, OUT for output mode, to prevent damage.

---

## Arduino Setup & Usage

### Required Libraries

```bash
# HardwareSerial (built-in for ESP32)
# No additional libraries needed
```

### Initialization

```cpp
#include <HardwareSerial.h>

HardwareSerial mySerial(1);  // Use UART1
#define ENABLE_PIN D2

void setup() {
    Serial.begin(115200);
    // RX=D4(GPIO6), TX=D5(GPIO7) for ESP32-C3
    mySerial.begin(115200, SERIAL_8N1, 7, 6);
    while (!mySerial);
    while (!Serial);

    pinMode(ENABLE_PIN, OUTPUT);
    // Set direction:
    // HIGH = Transmit mode
    // LOW  = Receive mode
}
```

### Complete Working Example — RS485 Sender (Master)

```cpp
#include <HardwareSerial.h>

HardwareSerial mySerial(1);
#define ENABLE_PIN D2

void setup() {
    Serial.begin(115200);
    mySerial.begin(115200, SERIAL_8N1, 7, 6);  // RX=GPIO6, TX=GPIO7
    while (!mySerial);
    while (!Serial);

    pinMode(ENABLE_PIN, OUTPUT);
    digitalWrite(ENABLE_PIN, HIGH);  // Transmit mode
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

### Complete Working Example — RS485 Receiver (Slave)

```cpp
#include <HardwareSerial.h>

HardwareSerial mySerial(1);
#define ENABLE_PIN D2

void setup() {
    Serial.begin(115200);
    mySerial.begin(115200, SERIAL_8N1, 7, 6);  // RX=GPIO6, TX=GPIO7
    while (!Serial);
    while (!mySerial);

    pinMode(ENABLE_PIN, OUTPUT);
    digitalWrite(ENABLE_PIN, LOW);  // Receive mode
}

void loop() {
    if (mySerial.available()) {
        String receivedData = mySerial.readStringUntil('\n');
        Serial.print("Received data: ");
        Serial.println(receivedData);
    }
}
```

### Half-Duplex Transceiver Example

```cpp
#include <HardwareSerial.h>

HardwareSerial mySerial(1);
#define ENABLE_PIN D2

void setTransmitMode() {
    digitalWrite(ENABLE_PIN, HIGH);
    delayMicroseconds(100);  // Allow transceiver to switch
}

void setReceiveMode() {
    digitalWrite(ENABLE_PIN, LOW);
    delayMicroseconds(100);  // Allow transceiver to switch
}

void sendRS485(String message) {
    setTransmitMode();
    mySerial.println(message);
    mySerial.flush();  // Wait for transmission to complete
    setReceiveMode();  // Switch back to receive
}

void setup() {
    Serial.begin(115200);
    mySerial.begin(115200, SERIAL_8N1, 7, 6);
    pinMode(ENABLE_PIN, OUTPUT);
    setReceiveMode();  // Default to receive mode
}

void loop() {
    // Send a message every 2 seconds
    sendRS485("Hello from RS485");
    delay(2000);

    // Check for incoming messages
    if (mySerial.available()) {
        String data = mySerial.readStringUntil('\n');
        Serial.print("Received: ");
        Serial.println(data);
    }
}
```

---

## TinyGo Setup & Usage

### TinyGo UART Example

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // Configure enable pin
    enablePin := machine.D2
    enablePin.Configure(machine.PinConfig{Mode: machine.PinOutput})

    // Configure UART for RS485
    uart := machine.UART1
    uart.Configure(machine.UARTConfig{
        BaudRate: 115200,
        TX:       machine.D5,
        RX:       machine.D4,
    })

    // Set to transmit mode
    enablePin.High()

    println("RS485 initialized (TinyGo)")

    for {
        // Send message
        enablePin.High() // Transmit mode
        uart.Write([]byte("Hello from TinyGo RS485\r\n"))
        time.Sleep(10 * time.Millisecond) // Wait for TX to complete
        enablePin.Low() // Switch to receive mode

        time.Sleep(1 * time.Second)

        // Check for received data
        for uart.Buffered() > 0 {
            b, err := uart.ReadByte()
            if err == nil {
                print(string(b))
            }
        }
    }
}
```

### TinyGo RS485 Receiver

```go
package main

import (
    "machine"
    "time"
)

func main() {
    enablePin := machine.D2
    enablePin.Configure(machine.PinConfig{Mode: machine.PinOutput})
    enablePin.Low() // Receive mode

    uart := machine.UART1
    uart.Configure(machine.UARTConfig{
        BaudRate: 115200,
        TX:       machine.D5,
        RX:       machine.D4,
    })

    println("RS485 receiver ready (TinyGo)")

    buf := make([]byte, 256)
    for {
        if uart.Buffered() > 0 {
            n, _ := uart.Read(buf)
            if n > 0 {
                print("Received: ")
                print(string(buf[:n]))
            }
        }
        time.Sleep(10 * time.Millisecond)
    }
}
```

> **Note:** UART pin assignments may vary by XIAO board. Check the board-specific skill for correct UART peripheral and pin mappings.

---

## Communication Protocol Details

### RS485 Configuration

| Parameter | Value |
|-----------|-------|
| Protocol | RS485 half-duplex |
| Baud Rate | Up to 115200 (documented) |
| Data Format | 8N1 (8 data bits, no parity, 1 stop bit) |
| Direction Control | D2 enable pin (HIGH=TX, LOW=RX) |
| Signaling | Differential (A/B lines) |
| Termination | 120Ω switchable |

### Enable Pin Direction Control

| D2 State | Mode | Description |
|----------|------|-------------|
| `HIGH` | Transmit | XIAO sends data to RS485 bus |
| `LOW` | Receive | XIAO receives data from RS485 bus |

### UART Pin Mapping (ESP32-C3)

| XIAO Pin | GPIO | Function |
|----------|------|----------|
| D4 | GPIO6 | UART RX |
| D5 | GPIO7 | UART TX |

---

## Common Gotchas / Notes

1. **5V IN/OUT switch** — Must be set correctly. IN for receiving external 5V power, OUT for supplying 5V to external sensors. Wrong setting can damage the board.
2. **120Ω termination** — Enable the termination resistor switch at the beginning and end of long RS485 bus runs. Not needed for short point-to-point connections.
3. **Enable pin timing** — After switching the enable pin, add a small delay (~100µs) before sending/receiving to allow the transceiver to settle.
4. **Half-duplex** — RS485 is half-duplex. You cannot send and receive simultaneously. Always switch back to receive mode after transmitting.
5. **Flush before switching** — Call `mySerial.flush()` (Arduino) or add a delay after writing (TinyGo) to ensure all data is transmitted before switching to receive mode.
6. **Pin mapping varies** — The documented example uses ESP32-C3 GPIO numbers. When using a different XIAO board, modify the UART pin configurations accordingly.
7. **Bus requires two nodes** — RS485 communication requires at least two devices on the bus.

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/XIAO-RS485-Expansion-Board/
- **Product Page:** https://www.seeedstudio.com/RS485-Breakout-Board-for-XIAO-p-6306.html
- **Schematic (KiCad):** https://files.seeedstudio.com/wiki/rs485_ExpansionBoard/Seeed_Studio_XIAO_RS485_Expansion_Board.kicad_sch
- **Schematic (PDF):** https://files.seeedstudio.com/wiki/rs485_ExpansionBoard/Seeed_Studio_XIAO_RS485_Expansion_Board.pdf
