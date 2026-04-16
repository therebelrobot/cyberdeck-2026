---
name: raspberrypi-4b
description: >
  Provides comprehensive GPIO pinout reference, board specifications, and Python/Go development
  guide for the Raspberry Pi 4 Model B single-board computer. Use when writing GPIO code for
  the RPi 4B, wiring peripherals, configuring I2C/SPI/UART/PWM, or integrating with XIAO
  microcontroller nodes. Keywords: Raspberry Pi, RPi 4, BCM2711, GPIO, pinout, I2C, SPI, UART,
  PWM, gpiozero, RPi.GPIO, periph.io, Python, Go, SBC, 40-pin header, sensor network.
---

# Raspberry Pi 4 Model B — GPIO & Development Guide

Provides comprehensive reference for GPIO programming and hardware interfacing on the Raspberry Pi 4 Model B.

## When to Use

- Writing Python or Go GPIO code targeting the Raspberry Pi 4 Model B
- Looking up RPi 4B pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the RPi 4B 40-pin header
- Configuring I2C, SPI, UART, or PWM on the RPi 4B
- Designing multi-board systems with RPi 4B as the controller and XIAO boards as peripheral nodes

## When NOT to Use

- For Raspberry Pi 5 → use the `raspberrypi-5` skill (different I/O controller: RP1)
- For XIAO microcontroller boards → use the corresponding XIAO board skill
- For Arduino/TinyGo microcontroller firmware → use the corresponding MCU skill
- For general Linux system administration on RPi (not GPIO-related)

---

## Board Overview

| Parameter | Value |
|---|---|
| **SoC** | Broadcom BCM2711 |
| **Architecture** | ARM Cortex-A72 (ARMv8-A, 64-bit) |
| **Cores** | 4 (quad-core) |
| **Clock Speed** | 1.5 GHz (B0 stepping) / 1.8 GHz (C0 stepping, mid-2021+) |
| **L1 Cache** | 32 KB data + 48 KB instruction per core |
| **L2 Cache** | 1 MB shared |
| **GPU** | VideoCore VI @ 500 MHz (OpenGL ES 3.1, Vulkan 1.2) |
| **RAM Options** | 1 GB / 2 GB / 4 GB / 8 GB LPDDR4 @ 3200 MHz |
| **WiFi** | 802.11ac dual-band (2.4 GHz + 5 GHz, Wi-Fi 5) |
| **Bluetooth** | 5.0, BLE |
| **Ethernet** | Gigabit (true gigabit, dedicated PCIe bus) |
| **USB** | 2 × USB 3.0 + 2 × USB 2.0 |
| **HDMI** | 2 × micro-HDMI (up to 4Kp60 single / 4Kp30 dual) |
| **DSI** | 1 × 2-lane MIPI DSI display port |
| **CSI** | 1 × 2-lane MIPI CSI camera port |
| **Storage** | MicroSD slot, USB boot supported, no native NVMe |
| **Power** | USB-C, 5V/3A recommended |
| **PoE** | Supported with PoE+ HAT |
| **Dimensions** | 85.6 mm × 56.5 mm |
| **GPIO Header** | 40-pin standard Raspberry Pi header |
| **GPIO Logic** | 3.3V (NOT 5V tolerant) |
| **Released** | June 24, 2019 |
| **End of Life** | January 2034 |

### Key Differences from RPi 5

- GPIO managed directly by BCM2711 SoC (RPi 5 uses separate RP1 chip)
- No PCIe 2.0 exposed (used internally for USB 3.0)
- No onboard RTC, power button, or fan header
- No NVMe support
- Lower power requirement (5V/3A vs 5V/5A)
- Max 8 GB RAM (RPi 5 supports up to 16 GB)
- Has 3.5mm A/V jack (composite video + analog audio)

---

## 40-Pin GPIO Header Pinout

```
                    ┌─────────┐
      3.3V Power  1 │●       ○│ 2   5V Power
   GPIO2 (SDA1)  3 │●       ○│ 4   5V Power
   GPIO3 (SCL1)  5 │●       ○│ 6   Ground
  GPIO4 (GPCLK0) 7 │●       ○│ 8   GPIO14 (TXD0)
         Ground  9 │●       ○│ 10  GPIO15 (RXD0)
        GPIO17  11 │●       ○│ 12  GPIO18 (PCM_CLK/PWM0)
        GPIO27  13 │●       ○│ 14  Ground
        GPIO22  15 │●       ○│ 16  GPIO23
      3.3V Power 17 │●       ○│ 18  GPIO24
 GPIO10 (MOSI0) 19 │●       ○│ 20  Ground
 GPIO9  (MISO0) 21 │●       ○│ 22  GPIO25
 GPIO11 (SCLK0) 23 │●       ○│ 24  GPIO8 (CE0)
         Ground 25 │●       ○│ 26  GPIO7 (CE1)
  GPIO0 (ID_SD) 27 │●       ○│ 28  GPIO1 (ID_SC)
         GPIO5  29 │●       ○│ 30  Ground
         GPIO6  31 │●       ○│ 32  GPIO12 (PWM0)
  GPIO13 (PWM1) 33 │●       ○│ 34  Ground
 GPIO19 (PCM_FS) 35 │●       ○│ 36  GPIO16
        GPIO26  37 │●       ○│ 38  GPIO20 (PCM_DIN)
         Ground 39 │●       ○│ 40  GPIO21 (PCM_DOUT)
                    └─────────┘
```

---

## Pin Reference Table

| Physical | BCM GPIO | WiringPi | Function | Alt Functions |
|:---:|:---:|:---:|:---|:---|
| 1 | — | — | 3.3V Power | Power |
| 2 | — | — | 5V Power | Power |
| 3 | 2 | 8 | GPIO 2 | I2C1 SDA, SMI SA3 |
| 4 | — | — | 5V Power | Power |
| 5 | 3 | 9 | GPIO 3 | I2C1 SCL, SMI SA2 |
| 6 | — | — | Ground | GND |
| 7 | 4 | 7 | GPIO 4 | GPCLK0, SMI SA1 |
| 8 | 14 | 15 | GPIO 14 | UART0 TXD, SMI SD6 |
| 9 | — | — | Ground | GND |
| 10 | 15 | 16 | GPIO 15 | UART0 RXD, SMI SD7 |
| 11 | 17 | 0 | GPIO 17 | SPI1 CE1, SMI SD9 |
| 12 | 18 | 1 | GPIO 18 | PCM CLK, SPI1 CE0, PWM0 |
| 13 | 27 | 2 | GPIO 27 | SMI SD13 |
| 14 | — | — | Ground | GND |
| 15 | 22 | 3 | GPIO 22 | SMI SD14 |
| 16 | 23 | 4 | GPIO 23 | SMI SD15 |
| 17 | — | — | 3.3V Power | Power |
| 18 | 24 | 5 | GPIO 24 | SMI SD16 |
| 19 | 10 | 12 | GPIO 10 | SPI0 MOSI, SMI SD2 |
| 20 | — | — | Ground | GND |
| 21 | 9 | 13 | GPIO 9 | SPI0 MISO, SMI SD1 |
| 22 | 25 | 6 | GPIO 25 | SMI SD17 |
| 23 | 11 | 14 | GPIO 11 | SPI0 SCLK, SMI SD3 |
| 24 | 8 | 10 | GPIO 8 | SPI0 CE0, SMI SD0 |
| 25 | — | — | Ground | GND |
| 26 | 7 | 11 | GPIO 7 | SPI0 CE1, SMI SWE_N/SRW_N |
| 27 | 0 | 30 | GPIO 0 | I2C0 SDA (EEPROM), SMI SA5 |
| 28 | 1 | 31 | GPIO 1 | I2C0 SCL (EEPROM), SMI SA4 |
| 29 | 5 | 21 | GPIO 5 | GPCLK1, SMI SA0 |
| 30 | — | — | Ground | GND |
| 31 | 6 | 22 | GPIO 6 | GPCLK2, SMI SOE_N/SE |
| 32 | 12 | 26 | GPIO 12 | PWM0 |
| 33 | 13 | 23 | GPIO 13 | PWM1 |
| 34 | — | — | Ground | GND |
| 35 | 19 | 24 | GPIO 19 | PCM FS, SPI1 MISO, PWM1 |
| 36 | 16 | 27 | GPIO 16 | SPI1 CE2 |
| 37 | 26 | 25 | GPIO 26 | — |
| 38 | 20 | 28 | GPIO 20 | PCM DIN, SPI1 MOSI, GPCLK0 |
| 39 | — | — | Ground | GND |
| 40 | 21 | 29 | GPIO 21 | PCM DOUT, SPI1 SCLK, GPCLK1 |

### Pin Summary

| Pin Type | Count | Physical Pins |
|---|---|---|
| 3.3V Power | 2 | 1, 17 |
| 5V Power | 2 | 2, 4 |
| Ground | 8 | 6, 9, 14, 20, 25, 30, 34, 39 |
| GPIO | 26 | 3, 5, 7–8, 10–13, 15–16, 18–19, 21–24, 26–29, 31–33, 35–38, 40 |
| ID EEPROM | 2 | 27 (GPIO 0), 28 (GPIO 1) — reserved for HAT identification |

---

## Communication Interfaces

### I2C (Inter-Integrated Circuit)

| Bus | SDA Pin | SCL Pin | BCM GPIO | Physical Pins | Notes |
|---|---|---|---|---|---|
| **I2C1** | SDA1 | SCL1 | GPIO 2, GPIO 3 | 3, 5 | Primary bus. Fixed 1.8 kΩ pull-up to 3.3V. |
| **I2C0** | SDA0 | SCL0 | GPIO 0, GPIO 1 | 27, 28 | Reserved for HAT EEPROM. Can be used as alternate bus. |

> **Detect devices:** `sudo i2cdetect -y 1`

**Python (smbus2):**

```python
import smbus2

bus = smbus2.SMBus(1)  # I2C1
addr = 0x48  # Device address

# Read 1 byte from register 0x00
data = bus.read_byte_data(addr, 0x00)

# Write 1 byte to register 0x01
bus.write_byte_data(addr, 0x01, 0xFF)

# Read block of bytes
block = bus.read_i2c_block_data(addr, 0x00, 4)

bus.close()
```

**Go (periph.io):**

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/conn/v3/i2c/i2creg"
    "periph.io/x/host/v3"
)

func main() {
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }
    bus, err := i2creg.Open("1")
    if err != nil {
        log.Fatal(err)
    }
    defer bus.Close()

    dev := &i2c.Dev{Bus: bus, Addr: 0x48}
    write := []byte{0x00}
    read := make([]byte, 2)
    if err := dev.Tx(write, read); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Read: %v\n", read)
}
```

### SPI (Serial Peripheral Interface)

| Bus | Pin Function | BCM GPIO | Physical Pin |
|---|---|---|:---:|
| **SPI0** | MOSI | GPIO 10 | 19 |
| **SPI0** | MISO | GPIO 9 | 21 |
| **SPI0** | SCLK | GPIO 11 | 23 |
| **SPI0** | CE0 | GPIO 8 | 24 |
| **SPI0** | CE1 | GPIO 7 | 26 |
| **SPI1** | CE0 | GPIO 18 | 12 |
| **SPI1** | CE1 | GPIO 17 | 11 |
| **SPI1** | CE2 | GPIO 16 | 36 |
| **SPI1** | MISO | GPIO 19 | 35 |
| **SPI1** | MOSI | GPIO 20 | 38 |
| **SPI1** | SCLK | GPIO 21 | 40 |

> SPI0 enabled by default. SPI1 requires: `dtoverlay=spi1-3cs` in `/boot/firmware/config.txt`.

**Python (spidev):**

```python
import spidev

spi = spidev.SpiDev()
spi.open(0, 0)  # Bus 0, CE0
spi.max_speed_hz = 1000000
spi.mode = 0

# Transfer data
response = spi.xfer2([0x01, 0x80, 0x00])
print(f"Response: {response}")

spi.close()
```

**Go (periph.io):**

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/conn/v3/spi"
    "periph.io/x/conn/v3/spi/spireg"
    "periph.io/x/host/v3"
)

func main() {
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }
    port, err := spireg.Open("SPI0.0")
    if err != nil {
        log.Fatal(err)
    }
    defer port.Close()

    conn, err := port.Connect(1000000, spi.Mode0, 8)
    if err != nil {
        log.Fatal(err)
    }

    write := []byte{0x01, 0x80, 0x00}
    read := make([]byte, 3)
    if err := conn.Tx(write, read); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Read: %v\n", read)
}
```

### UART (Universal Asynchronous Receiver/Transmitter)

| Bus | Pin Function | BCM GPIO | Physical Pin |
|---|---|---|:---:|
| **UART0** | TXD | GPIO 14 | 8 |
| **UART0** | RXD | GPIO 15 | 10 |

> RPi 4 has additional UARTs (uart2–uart5) available via device tree overlays.
> **Warning:** UART0 conflicts with Bluetooth. To use UART0 for serial, either disable Bluetooth (`dtoverlay=disable-bt`) or use the mini UART for Bluetooth (`dtoverlay=miniuart-bt`).

**Python (pyserial):**

```python
import serial

ser = serial.Serial('/dev/ttyAMA0', baudrate=9600, timeout=1)

# Write data
ser.write(b'Hello from RPi 4!\n')

# Read data
data = ser.readline()
print(f"Received: {data.decode()}")

ser.close()
```

**Go (periph.io):**

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/conn/v3/uart"
    "periph.io/x/host/v3"
    "periph.io/x/host/v3/serial"
)

func main() {
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }
    port, err := serial.Open("/dev/ttyAMA0", 9600)
    if err != nil {
        log.Fatal(err)
    }
    defer port.Close()

    _, err = port.Write([]byte("Hello from RPi 4!\n"))
    if err != nil {
        log.Fatal(err)
    }

    buf := make([]byte, 64)
    n, err := port.Read(buf)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Received: %s\n", buf[:n])
}
```

### PWM (Pulse-Width Modulation)

| Channel | BCM GPIO Options | Physical Pin Options |
|---|---|:---:|
| **PWM0** | GPIO 12 or GPIO 18 | 32 or 12 |
| **PWM1** | GPIO 13 or GPIO 19 | 33 or 35 |

> Hardware PWM limited to 4 pins above. Software PWM available on all GPIO pins.
> Enable with: `dtoverlay=pwm` in `/boot/firmware/config.txt`.

**Python (gpiozero):**

```python
from gpiozero import PWMOutputDevice
from time import sleep

pwm = PWMOutputDevice(18, frequency=1000)  # GPIO 18, 1 kHz

pwm.value = 0.5  # 50% duty cycle
sleep(2)

# Fade in/out
for duty in range(0, 101, 5):
    pwm.value = duty / 100
    sleep(0.05)
for duty in range(100, -1, -5):
    pwm.value = duty / 100
    sleep(0.05)

pwm.close()
```

### 1-Wire

| Pin Function | BCM GPIO | Physical Pin |
|---|---|:---:|
| 1-Wire Data | GPIO 4 | 7 |

> Enable with: `dtoverlay=w1-gpio` in `/boot/firmware/config.txt`.

**Python:**

```python
import glob
import time

# After enabling 1-Wire overlay and connecting DS18B20 sensor
base_dir = '/sys/bus/w1/devices/'
device_folder = glob.glob(base_dir + '28*')[0]
device_file = device_folder + '/w1_slave'

def read_temp():
    with open(device_file, 'r') as f:
        lines = f.readlines()
    equals_pos = lines[1].find('t=')
    if equals_pos != -1:
        temp_c = float(lines[1][equals_pos + 2:]) / 1000.0
        return temp_c

while True:
    print(f"Temperature: {read_temp():.1f}°C")
    time.sleep(1)
```

### PCM / I2S (Audio Interface)

| Pin Function | BCM GPIO | Physical Pin |
|---|---|:---:|
| PCM CLK | GPIO 18 | 12 |
| PCM FS (Frame Sync) | GPIO 19 | 35 |
| PCM DIN (Data In) | GPIO 20 | 38 |
| PCM DOUT (Data Out) | GPIO 21 | 40 |

---

## Python GPIO Programming

### Installation

```bash
# gpiozero (recommended — high-level, beginner-friendly)
sudo apt install python3-gpiozero
# or: pip install gpiozero

# RPi.GPIO (legacy — low-level, direct register access)
sudo apt install python3-rpi.gpio
# or: pip install RPi.GPIO

# I2C support
pip install smbus2

# SPI support
pip install spidev

# Serial/UART support
pip install pyserial
```

### Digital Output — LED Blink (gpiozero)

```python
from gpiozero import LED
from time import sleep

led = LED(17)  # BCM GPIO 17 (physical pin 11)

while True:
    led.on()
    sleep(0.5)
    led.off()
    sleep(0.5)
```

### Digital Output — LED Blink (RPi.GPIO)

```python
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.OUT)

try:
    while True:
        GPIO.output(17, GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(17, GPIO.LOW)
        time.sleep(0.5)
finally:
    GPIO.cleanup()
```

### Digital Input — Button Read (gpiozero)

```python
from gpiozero import Button
from signal import pause

button = Button(27)  # BCM GPIO 27 (physical pin 13)

button.when_pressed = lambda: print("Button pressed!")
button.when_released = lambda: print("Button released!")

pause()
```

### Digital Input — Button Read (RPi.GPIO)

```python
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)
GPIO.setup(27, GPIO.IN, pull_up_down=GPIO.PUD_UP)

try:
    while True:
        if GPIO.input(27) == GPIO.LOW:
            print("Button pressed!")
        GPIO.wait_for_edge(27, GPIO.FALLING)
finally:
    GPIO.cleanup()
```

---

## Go GPIO Programming

### Installation

```bash
# periph.io — comprehensive hardware abstraction
go get periph.io/x/host/v3
go get periph.io/x/conn/v3

# go-rpio — lightweight alternative
go get github.com/stianeikeland/go-rpio/v4
```

### Digital Output — LED Blink (periph.io)

```go
package main

import (
    "log"
    "time"

    "periph.io/x/conn/v3/gpio"
    "periph.io/x/conn/v3/gpio/gpioreg"
    "periph.io/x/host/v3"
)

func main() {
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    pin := gpioreg.ByName("GPIO17")
    if pin == nil {
        log.Fatal("Failed to find GPIO17")
    }

    for {
        pin.Out(gpio.High)
        time.Sleep(500 * time.Millisecond)
        pin.Out(gpio.Low)
        time.Sleep(500 * time.Millisecond)
    }
}
```

### Digital Input — Button Read (periph.io)

```go
package main

import (
    "fmt"
    "log"

    "periph.io/x/conn/v3/gpio"
    "periph.io/x/conn/v3/gpio/gpioreg"
    "periph.io/x/host/v3"
)

func main() {
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }

    pin := gpioreg.ByName("GPIO27")
    if pin == nil {
        log.Fatal("Failed to find GPIO27")
    }

    if err := pin.In(gpio.PullUp, gpio.FallingEdge); err != nil {
        log.Fatal(err)
    }

    for {
        pin.WaitForEdge(-1)
        fmt.Println("Button pressed!")
    }
}
```

### Digital Output — LED Blink (go-rpio)

```go
package main

import (
    "fmt"
    "os"
    "time"

    "github.com/stianeikeland/go-rpio/v4"
)

func main() {
    if err := rpio.Open(); err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
    defer rpio.Close()

    pin := rpio.Pin(17)
    pin.Output()

    for {
        pin.High()
        time.Sleep(500 * time.Millisecond)
        pin.Low()
        time.Sleep(500 * time.Millisecond)
    }
}
```

> **Note:** `periph.io` is recommended for production use — it supports I2C, SPI, UART, and PWM with a unified API. `go-rpio` is simpler but limited to basic GPIO.

---

## Integration with Microcontroller Projects

The RPi 4B serves as the **central controller** ("brain") in multi-board projects, running high-level logic, data processing, networking, and UI, while XIAO microcontroller boards act as peripheral sensor/actuator nodes.

### Architecture Pattern

```
┌─────────────────────────────────┐
│     Raspberry Pi 4 Model B      │
│  (Python/Go — high-level logic) │
│                                 │
│  ┌──────┐ ┌──────┐ ┌────────┐  │
│  │ I2C  │ │ SPI  │ │ UART   │  │
│  │ bus  │ │ bus  │ │ serial │  │
│  └──┬───┘ └──┬───┘ └───┬────┘  │
└─────┼────────┼─────────┼───────┘
      │        │         │
      ▼        ▼         ▼
┌─────────┐ ┌────────┐ ┌─────────┐
│ XIAO #1 │ │XIAO #2 │ │ XIAO #3 │
│ (I2C    │ │(SPI    │ │ (UART   │
│  slave) │ │ slave) │ │  serial)│
│ Sensors │ │ Motor  │ │ GPS     │
└─────────┘ └────────┘ └─────────┘
```

### Communication Options

| Method | RPi Role | XIAO Role | Use Case |
|---|---|---|---|
| **I2C** | Master | Slave | Multiple sensor nodes on shared bus |
| **SPI** | Master | Slave | High-speed data (displays, fast ADC) |
| **UART** | Host | Device | Point-to-point serial (GPS, debug) |
| **USB Serial** | Host | Device | Easy prototyping, no wiring needed |
| **WiFi/MQTT** | Broker/Sub | Publisher | Wireless sensor network |

### I2C Multi-Node Example (Python)

```python
import smbus2
import time

bus = smbus2.SMBus(1)

# XIAO nodes at different I2C addresses
TEMP_NODE = 0x48   # XIAO #1: temperature sensor
LIGHT_NODE = 0x23  # XIAO #2: light sensor

while True:
    temp_raw = bus.read_i2c_block_data(TEMP_NODE, 0x00, 2)
    temp_c = ((temp_raw[0] << 8) | temp_raw[1]) / 256.0

    light = bus.read_word_data(LIGHT_NODE, 0x10)

    print(f"Temp: {temp_c:.1f}°C, Light: {light} lux")
    time.sleep(1)
```

### USB Serial Example (Python)

```python
import serial
import json

ser = serial.Serial('/dev/ttyACM0', 115200, timeout=1)

while True:
    line = ser.readline().decode().strip()
    if line:
        data = json.loads(line)
        print(f"Sensor: {data}")
```

### WiFi/MQTT Example (Python)

```python
import paho.mqtt.client as mqtt

def on_message(client, userdata, msg):
    print(f"{msg.topic}: {msg.payload.decode()}")

client = mqtt.Client()
client.on_message = on_message
client.connect("localhost", 1883)
client.subscribe("sensors/#")
client.loop_forever()
```

> **Voltage compatibility:** Both RPi 4B and XIAO boards use 3.3V GPIO logic — they can be connected directly without level shifting.

---

## Power & Electrical Notes

| Parameter | Value |
|---|---|
| **GPIO Logic Level** | 3.3V |
| **5V Tolerant** | **NO** — applying 5V to GPIO will damage the board |
| **Max Current per GPIO** | ~16 mA recommended |
| **Total GPIO Current** | 50 mA absolute max across all pins |
| **3.3V Rail** | From onboard regulator |
| **5V Rail** | Direct from USB-C input (pins 2, 4) |
| **Board Power** | 5V / 3A recommended via USB-C |

### Level Shifting

When connecting 5V devices (e.g., Arduino Uno, some sensors):
- Use a **bidirectional logic level converter** (3.3V ↔ 5V)
- Or use a **voltage divider** (5V → 3.3V, input only)
- **Never** connect 5V signals directly to RPi GPIO pins

---

## RPi 4B-Specific Features

### VideoCore VI GPU
- OpenGL ES 3.1, Vulkan 1.2
- Hardware H.265 decode @ 4Kp60
- Hardware H.264 decode @ 1080p60, encode @ 1080p30

### Dual Micro-HDMI
- 2 × micro-HDMI outputs
- Up to 4Kp60 (single display) or 4Kp30 (dual display)

### USB 3.0
- 2 × USB 3.0 ports (5 Gbps, shared bandwidth)
- 2 × USB 2.0 ports

### Gigabit Ethernet
- True Gigabit via dedicated PCIe bus (not shared with USB like RPi 3)

### PoE Header
- 4-pin PoE header for Power over Ethernet
- Requires separate PoE+ HAT accessory

### 3.5mm A/V Jack
- 4-pole stereo audio and composite video output
- Not available on RPi 5

---

## Common Gotchas

1. **GPIO numbering confusion** — Three numbering schemes exist: BCM (recommended), physical pin number, and WiringPi. Always use BCM numbering in code (`GPIO.setmode(GPIO.BCM)`)
2. **3.3V logic only** — GPIO pins are NOT 5V tolerant. Applying 5V will permanently damage the SoC
3. **I2C pull-ups built-in** — GPIO 2/3 (I2C1) have fixed 1.8 kΩ pull-ups to 3.3V. Do not add external pull-ups
4. **UART/Bluetooth conflict** — UART0 (GPIO 14/15) is used by Bluetooth by default. Disable BT (`dtoverlay=disable-bt`) or swap to mini UART (`dtoverlay=miniuart-bt`)
5. **SPI CE pins** — SPI0 has CE0 (GPIO 8) and CE1 (GPIO 7). For more chip selects, use SPI1 or manage CS manually
6. **ID EEPROM pins** — GPIO 0/1 (physical 27/28) are reserved for HAT EEPROM identification. Avoid using for general I/O
7. **Max current** — Do not draw more than 16 mA per GPIO pin. Use transistors/MOSFETs for higher-current loads
8. **Device tree overlays** — Many alternate functions (SPI1, additional UARTs, PWM, 1-Wire) require enabling overlays in `/boot/firmware/config.txt`
9. **RPi 4 vs RPi 5 GPIO driver** — Code written for RPi 4 (BCM2711 direct register access) may not work on RPi 5 (RP1 chip). Use `gpiozero` or `libgpiod` for portable code
10. **Power supply** — Insufficient power (< 3A) causes undervoltage warnings (lightning bolt icon) and unstable behavior

---

## Reference Links

- **Official documentation:** https://www.raspberrypi.com/documentation/computers/raspberry-pi.html
- **GPIO pinout reference:** https://pinout.xyz/
- **gpiozero docs:** https://gpiozero.readthedocs.io/
- **RPi.GPIO docs:** https://sourceforge.net/projects/raspberry-gpio-python/
- **periph.io (Go):** https://periph.io/
- **smbus2 (Python I2C):** https://pypi.org/project/smbus2/
- **spidev (Python SPI):** https://pypi.org/project/spidev/
- **pyserial (Python UART):** https://pypi.org/project/pyserial/
- **BCM2711 datasheet:** https://datasheets.raspberrypi.com/bcm2711/bcm2711-peripherals.pdf
