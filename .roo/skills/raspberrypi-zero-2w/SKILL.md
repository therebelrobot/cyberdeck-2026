---
name: raspberrypi-zero-2w
description: >
  Provides comprehensive GPIO pinout reference, board specifications, and Python/Go development
  guide for the Raspberry Pi Zero 2 W single-board computer. Use when writing GPIO code for
  the RPi Zero 2W, wiring peripherals, configuring I2C/SPI/UART/PWM, or integrating with XIAO
  microcontroller nodes. Keywords: Raspberry Pi, RPi Zero 2W, BCM2710A1, ARM Cortex-A53, GPIO,
  pinout, I2C, SPI, UART, PWM, gpiozero, libgpiod, periph.io, Python, Go, SBC, 40-pin header,
  sensor network, compact, low-power, battery projects.
---

# Raspberry Pi Zero 2 W — GPIO & Development Guide

Provides comprehensive reference for GPIO programming and hardware interfacing on the Raspberry Pi Zero 2 W.

## When to Use

- Writing Python or Go GPIO code targeting the Raspberry Pi Zero 2 W
- Looking up RPi Zero 2W pin assignments, alternate functions, or peripheral mappings
- Wiring sensors/actuators to the RPi Zero 2W 40-pin header
- Configuring I2C, SPI, UART, or PWM on the RPi Zero 2W
- Designing compact or battery-powered projects with RPi Zero 2W as the controller and XIAO boards as peripheral nodes
- Projects requiring the smallest Raspberry Pi with full compute capability (4-core @ 1GHz, 512MB RAM)

## When NOT to Use

- For Raspberry Pi 4 Model B → use the `raspberrypi-4b` skill (different SoC, more GPIO options)
- For Raspberry Pi 5 → use the `raspberrypi-5` skill (different I/O controller: RP1, faster CPU)
- For XIAO microcontroller boards → use the corresponding XIAO board skill
- For Arduino/TinyGo microcontroller firmware → use the corresponding MCU skill
- For projects requiring 5V-tolerant GPIO (RPi Zero 2W GPIO is 3.3V only like all RPi models)
- For general Linux system administration on RPi (not GPIO-related)

---

## Board Overview

| Parameter | Value |
|---|---|
| **SoC** | Broadcom BCM2710A1 |
| **Architecture** | ARM Cortex-A53 (ARMv8-A, 64-bit) |
| **Cores** | 4 (quad-core) |
| **Clock Speed** | 1 GHz |
| **GPU** | VideoCore IV @ 400 MHz |
| **RAM** | 512 MB LPDDR2 |
| **WiFi** | 802.11n (2.4 GHz, single-band) |
| **Bluetooth** | 4.2, BLE |
| **Ethernet** | None (USB adapter required) |
| **USB** | 1 × micro-USB (OTG) |
| **Camera** | CSI-2 (22-pin) |
| **Storage** | MicroSD slot |
| **Power** | 5V via micro-USB, ~2.5W under load |
| **PoE** | Not supported |
| **Dimensions** | 65 mm × 30 mm |
| **Weight** | ~17g |
| **GPIO Header** | 40-pin standard Raspberry Pi header (unpopulated, requires soldering) |
| **GPIO Logic** | 3.3V (NOT 5V tolerant) |
| **Released** | March 2021 |
| **Price** | ~$15 |

### Key Differences from RPi 4B/5

- **Smaller form factor** — 65mm × 30mm vs 85mm × 56mm (about half the size)
- **Unpopulated GPIO header** — Ships without pins soldered; requires manual soldering
- **Less RAM** — 512 MB vs 1–16 GB on RPi 4B/5
- **No Ethernet** — Requires USB adapter or WiFi
- **Single-band WiFi** — 2.4 GHz only (vs dual-band 2.4/5 GHz on 4B/5)
- **Lower power** — ~2.5W under load vs 5-15W on 4B/5
- **BCM2710A1** — Different SoC generation (Cortex-A53 vs A72/A76)
- **No PCIe** — No NVMe support (none of the Zero series has PCIe)
- **Micro-USB (OTG)** — Single USB port with OTG capability vs USB-C on 4B/5

### When to Choose Zero 2W Over 4B/5

| Scenario | Recommendation |
|---|---|
| Battery-powered projects | ✅ Zero 2W (2.5W vs 5-15W) |
| Size-constrained enclosures | ✅ Zero 2W (65×30mm vs 85×56mm) |
| Cost-sensitive projects | ✅ Zero 2W (~$15 vs ~$35-80) |
| Network-heavy applications | ❌ RPi 4B/5 (Ethernet + dual-band WiFi) |
| RAM-intensive workloads | ❌ RPi 4B/5 (up to 16GB vs 512MB) |
| High-performance computing | ❌ RPi 5 (2.4GHz A76 vs 1GHz A53) |

---

## 40-Pin GPIO Header Pinout

> **Note:** The 40-pin header pinout is **physically and electrically identical** to RPi 4B/5. Same BCM numbering, same pin functions, same 3.3V logic. The header ships unpopulated and requires soldering.

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

> RPi Zero 2W has additional UARTs (uart2–uart5) available via device tree overlays.
> **Warning:** UART0 conflicts with Bluetooth. To use UART0 for serial, either disable Bluetooth (`dtoverlay=disable-bt`) or use the mini UART for Bluetooth (`dtoverlay=miniuart-bt`).

**Python (pyserial):**

```python
import serial

ser = serial.Serial('/dev/ttyAMA0', baudrate=9600, timeout=1)

# Write data
ser.write(b'Hello from RPi Zero 2W!\n')

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

    _, err = port.Write([]byte("Hello from RPi Zero 2W!\n"))
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

---

## Wiring XIAO Microcontrollers to RPi Zero 2W

The RPi Zero 2W communicates with XIAO microcontrollers via I2C, SPI, or UART. Here are common wiring patterns:

### I2C Wiring (Recommended for sensor data collection)

```
RPi Zero 2W          XIAO Board
---------            ---------
Pin 1 (3.3V)   ──→   3.3V (if 3.3V logic) or VCC
Pin 3 (SDA1)   ──→   SDA (Wire 3)
Pin 5 (SCL1)   ──→   SCL (Wire 4)
Pin 6 (GND)    ──→   GND (Wire 1)
```

> **Note:** Some XIAO boards (like ESP32 series) operate at 3.3V and can share the RPi's I2C bus directly. Others (like Arduino-compatible) may need level shifting or operate at 5V. Check your XIAO board's voltage before wiring.

**Python reading from XIAO via I2C:**

```python
import smbus2

bus = smbus2.SMBus(1)

# Read sensor data from XIAO at I2C address 0x42
try:
    data = bus.read_i2c_block_data(0x42, 0x00, 8)
    print(f"Sensor values: {data}")
except IOError:
    print("Device not found or communication error")

bus.close()
```

### SPI Wiring (Recommended for high-speed data transfer)

```
RPi Zero 2W          XIAO Board
---------            ---------
Pin 1 (3.3V)   ──→   3.3V or VCC
Pin 6 (GND)    ──→   GND
Pin 19 (MOSI)  ──→   MOSI
Pin 21 (MISO)  ──→   MISO
Pin 23 (SCLK)  ──→   SCLK
Pin 24 (CE0)  ──→   CS/SS
```

### UART Wiring (Recommended for serial debug)

```
RPi Zero 2W          XIAO Board
---------            ---------
Pin 6 (GND)    ──→   GND
Pin 8 (TXD0)   ──→   RX (Wire 1)
Pin 10 (RXD0)  ──→   TX (Wire 0)
```

> **Note:** If using 5V XIAO boards, use a voltage divider or logic level converter to protect the RPi's 3.3V inputs.

---

## GPIO Input Example (Python gpiozero)

```python
from gpiozero import Button, LED
from signal import pause

# Button on GPIO17 (pin 11), normally closed to ground
button = Button(17, pull_up=True)

# LED on GPIO14 (pin 8)
led = LED(14)

# Toggle LED when button pressed
button.when_pressed = led.on
button.when_released = led.off

pause()
```

---

## Safe Shutdown Script for Battery Projects

For battery-powered RPi Zero 2W projects, implement a safe shutdown script triggered by a button press:

```bash
#!/bin/bash
# safe_shutdown.sh - Safe shutdown for battery-powered RPi Zero 2W

# Configuration
SHUTDOWN_PIN=21  # GPIO 21 (physical pin 40)
HOLD_TIME=3      # Seconds to hold for shutdown

# Export GPIO and set as input with pull-up
echo "$SHUTDOWN_PIN" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio${SHUTDOWN_PIN}/direction

echo "Safe shutdown button initialized on GPIO ${SHUTDOWN_PIN}"
echo "Press and hold for ${HOLD_TIME} seconds to safely shutdown..."

# Monitor button and trigger shutdown if held
python3 << EOF
import RPi.GPIO as GPIO
import subprocess
import time

SHUTDOWN_PIN = ${SHUTDOWN_PIN}
HOLD_TIME = ${HOLD_TIME}

GPIO.setmode(GPIO.BCM)
GPIO.setup(SHUTDOWN_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
    if GPIO.input(SHUTDOWN_PIN) == GPIO.LOW:
        start_time = time.time()
        while GPIO.input(SHUTDOWN_PIN) == GPIO.LOW:
            if time.time() - start_time >= HOLD_TIME:
                print("Shutdown triggered!")
                subprocess.run(['sudo', 'shutdown', '-h', 'now'])
                break
            time.sleep(0.1)
    time.sleep(0.1)
EOF
```

**Installation:**

```bash
# Copy script to /usr/local/bin/
sudo cp safe_shutdown.sh /usr/local/bin/safe_shutdown.sh
sudo chmod +x /usr/local/bin/safe_shutdown.sh

# Run at boot (add to /etc/rc.local or create systemd service)
sudo systemctl enable safe-shutdown
```

---

## Library Setup

### Python (gpiozero)

```bash
# Install gpiozero
sudo apt update
sudo apt install python3-gpiozero

# For I2C support
sudo apt install python3-smbus2
```

** gpiozero usage example:**

```python
from gpiozero import LED, Button, PWMOutputDevice

# Simple LED control
led = LED(14)
led.on()
led.off()

# Button with callback
button = Button(17)
button.when_pressed = lambda: print("Pressed!")
button.when_released = lambda: print("Released!")

# PWM dimming
pwm = PWMOutputDevice(18, frequency=1000)
pwm.value = 0.5  # 50% brightness
```

### Go (periph.io)

```bash
# Install periph.io
go get periph.io/x/conn/v3
go get periph.io/x/host/v3
```

** periph.io initialization:**

```go
import "periph.io/x/host/v3"

func main() {
    // Initialize all availablenative drivers
    if _, err := host.Init(); err != nil {
        log.Fatal(err)
    }
    // Now use i2c, spi, uart, gpio etc.
}
```

---

## Troubleshooting

### Header Soldering Issues

| Problem | Solution |
|---|---|
| Pins not aligned | Use a header spacer to hold pins in place while soldering |
| Cold joints | Apply fresh solder with clean iron tip, preheat pad |
| Solder bridges | Use solder wick or desoldering pump to remove excess |
| Headers tilted | Reheat joints one at a time, adjust while molten |

> **Tip:** If new to soldering, consider purchasing a Zero 2W with pre-soldered header (some vendors offer this).

### Power Issues

| Problem | Cause | Solution |
|---|---|---|
| Random shutdowns | Insufficient power supply | Use 5V/2.5A power supply (not phone charger) |
| Undervoltage warnings | Cable resistance too high | Use high-quality USB cable with thick conductors |
| No power LED | Faulty cable or port | Try different cable or power supply |
| Throttling | Thermal issues | Add heatsink, improve ventilation |

> **Note:** The RPi Zero 2W draws up to 2.5W under load. Ensure your power supply can deliver this current continuously.

### I2C Problems

| Symptom | Cause | Solution |
|---|---|---|
| `i2cdetect` shows no devices | I2C not enabled | Run `sudo raspi-config` → Interface Options → I2C → Enable |
| Erratic readings | Loose wires | Check all four connections (SDA, SCL, VCC, GND) |
| Devices at wrong address | Address conflict | Ensure each device has unique I2C address |
| Pull-up resistors needed | Long wires | Add 1.8kΩ resistors from SDA/SCL to 3.3V |

### WiFi/Bluetooth Issues

| Symptom | Solution |
|---|---|
| WiFi disconnected | Check `/etc/wpa_supplicant/wpa_supplicant.conf` for correct SSID/passphrase |
| WiFi not connecting | Run `sudo rfkill unblock wifi` to unblock |
| Bluetooth not discovering | Run `sudo btmgmt find` to scan |
| Bluetooth audio issues | Ensure no conflicting audio services |

### GPIO Permission Errors

```bash
# Add user to gpio group
sudo usermod -a -G gpio $USER

# Log out and back in for changes to take effect
# Or use gpiozero without sudo (it handles permissions)
```

### SD Card Issues

| Symptom | Solution |
|---|---|
| Boot problems | Re-flash image with Raspberry Pi Imager |
| Read-only filesystem | Check power supply voltage (low voltage causes fs corruption) |
| Slow performance | Use high-quality Class 10 SD card |

---

## See Also

- [Raspberry Pi 4B Skill](../raspberrypi-4b/SKILL.md) — For RPi 4B-specific features
- [Raspberry Pi 5 Skill](../raspberrypi-5/SKILL.md) — For RPi 5-specific features (RP1, PCIe, RTC)
- [XIAO Board Skills](../../skills/) — For wiring XIAO microcontrollers to RPi
- [RPi GPIO Documentation](https://www.raspberrypi.com/documentation/io_raspberry_pi/) — Official Raspberry Pi GPIO documentation
- [BCM2710 Datasheet](https://datasheets.raspberrypi.com/) — SoC specifications