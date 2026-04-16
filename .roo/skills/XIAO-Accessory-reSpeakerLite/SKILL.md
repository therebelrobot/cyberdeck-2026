---
name: xiao-accessory-respeakerlite
description: >
  Provides comprehensive reference for using the reSpeaker Lite voice/audio processing board
  with Seeed Studio XIAO microcontrollers. Covers XMOS XU316 AI audio chipset, dual microphone
  array, I2S and USB audio modes, firmware flashing, and speaker/headphone output. Includes
  Arduino and TinyGo setup, wiring, and code examples. Use when integrating the reSpeaker Lite
  for voice capture, audio processing, smart speaker, or voice assistant applications.
  Keywords: XIAO, reSpeaker, Lite, audio, voice, microphone, speaker, I2S, USB, UAC2,
  XMOS, XU316, far-field, echo cancellation, noise suppression, DFU, ESP32S3.
---

# reSpeaker Lite — XIAO Accessory Guide

Provides comprehensive reference for using the reSpeaker Lite voice/audio processing board with Seeed Studio XIAO microcontrollers.

## When to Use

- Integrating the reSpeaker Lite for voice capture or audio processing
- Setting up I2S audio between XIAO ESP32S3 and the reSpeaker Lite
- Using the reSpeaker Lite as a USB audio device
- Flashing I2S or USB firmware via DFU-Util
- Building voice assistant or smart speaker applications

## When NOT to Use

- For standalone XIAO board pinouts → use the corresponding board skill
- For other XIAO accessories → use the corresponding accessory skill

---

## Accessory Overview

| Parameter | Value |
|---|---|
| **Type** | Voice/audio processing board with AI chipset |
| **Core Chip** | XMOS XU316 |
| **Microphones** | 2× high-performance digital (far-field up to 3m) |
| **Mic Sensitivity** | -26 dBFS |
| **Acoustic Overload Point** | 120 dBL |
| **SNR** | 64 dBA |
| **Max Sampling Rate** | 16kHz |
| **Speaker Support** | 5W amplifier |
| **Dimensions** | 35 × 86 mm |
| **Power** | USB 5V or External 5V |

### AI Audio Features

- Interference cancellation
- Acoustic echo cancellation (AEC)
- Noise suppression
- Automatic gain control (AGC)

### Board Components

| Component | Description |
|-----------|-------------|
| Dual Microphone Array | Audio input (far-field up to 3m) |
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

| Board | Connection | Notes |
|-------|------------|-------|
| XIAO ESP32S3 (Sense) | I2S (plugs into socket) | Primary supported board |
| Adafruit QT Py | I2S | Also compatible |
| Any XIAO | N/A | reSpeaker works standalone via USB |

> **Important:** The XIAO plugs INTO the reSpeaker Lite board — it is NOT a hat that plugs onto XIAO. The reSpeaker Lite is a larger board with its own USB-C port.

---

## Pin Usage Diagram

The reSpeaker Lite does NOT use individual XIAO pins like a traditional hat. Instead, the XIAO ESP32S3 plugs into a dedicated socket on the reSpeaker board, which connects via I2S internally.

### I2S Connection (Internal via Socket)

```
XIAO ESP32S3   | reSpeaker Function     | Protocol
---------------|------------------------|----------
I2S BCLK       | Bit Clock              | I2S
I2S LRCLK      | Word Select            | I2S
I2S DIN        | Audio Data In          | I2S
I2S DOUT       | Audio Data Out         | I2S
3V3             | Power                  | Power
GND             | Ground                 | Power
```

### USB Connection (Standalone)

When used as a USB audio device, no XIAO is needed:

```
reSpeaker USB-C → PC/Raspberry Pi (UAC2 audio device)
```

---

## Pin Conflict Warning

### No pin conflicts

The reSpeaker Lite is a **separate board** — the XIAO plugs into it rather than the reSpeaker plugging onto XIAO pins. When used via USB, no XIAO pins are consumed at all.

When used with XIAO ESP32S3 via I2S, the XIAO is dedicated to the reSpeaker board and its remaining pins are accessible through the reSpeaker's breakout headers.

### Compatible with ALL other accessories
- reSpeaker Lite can be used alongside any other XIAO accessory (on a different XIAO board)

---

## Power Requirements

| Parameter | Value |
|-----------|-------|
| Power Supply | USB 5V or External 5V |
| Speaker Amplifier | 5W max |

---

## Firmware Modes

The reSpeaker Lite has **two firmware versions**:

| Firmware | Default | Use Case |
|----------|---------|----------|
| **USB (UAC2)** | ✅ Yes | Plug-and-play USB audio device for PC/Raspberry Pi |
| **I2S** | No | For XIAO ESP32S3 integration via I2S socket |

### Firmware Flashing via DFU-Util

```bash
# Install DFU-Util
# macOS:
brew install dfu-util

# Linux:
sudo apt-get install dfu-util

# Enter DFU mode:
# 1. Hold the DFU button on the reSpeaker Lite
# 2. Connect USB-C cable
# 3. Release DFU button

# Flash I2S firmware:
dfu-util -e -a 1 -D i2s_firmware.bin

# Flash USB firmware:
dfu-util -e -a 1 -D usb_firmware.bin

# Verify device is in DFU mode:
dfu-util -l
```

---

## Arduino Setup & Usage (I2S with XIAO ESP32S3)

### Prerequisites

1. Flash the **I2S firmware** onto the reSpeaker Lite (see Firmware section above)
2. Plug XIAO ESP32S3 into the reSpeaker Lite socket
3. Connect USB to the XIAO ESP32S3 (not the reSpeaker USB-C)

### Required Libraries

```bash
# ESP32 I2S support is built into the ESP32 Arduino core
# No additional library installation needed
```

### I2S Audio Capture Example

```cpp
#include <driver/i2s.h>

// I2S configuration for reSpeaker Lite
#define I2S_PORT        I2S_NUM_0
#define I2S_SAMPLE_RATE 16000
#define I2S_BCLK        -1  // Auto-configured via socket
#define I2S_LRCLK       -1  // Auto-configured via socket
#define I2S_DIN         -1  // Auto-configured via socket

#define BUFFER_SIZE 1024

int16_t audioBuffer[BUFFER_SIZE];

void setup() {
    Serial.begin(115200);

    // Configure I2S
    i2s_config_t i2s_config = {
        .mode = (i2s_mode_t)(I2S_MODE_MASTER | I2S_MODE_RX),
        .sample_rate = I2S_SAMPLE_RATE,
        .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,
        .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
        .communication_format = I2S_COMM_FORMAT_STAND_I2S,
        .intr_alloc_flags = ESP_INTR_FLAG_LEVEL1,
        .dma_buf_count = 4,
        .dma_buf_len = BUFFER_SIZE,
        .use_apll = false,
    };

    i2s_driver_install(I2S_PORT, &i2s_config, 0, NULL);

    Serial.println("reSpeaker Lite I2S audio capture ready");
}

void loop() {
    size_t bytesRead = 0;
    i2s_read(I2S_PORT, audioBuffer, sizeof(audioBuffer), &bytesRead, portMAX_DELAY);

    int samplesRead = bytesRead / sizeof(int16_t);

    // Calculate RMS volume level
    long sum = 0;
    for (int i = 0; i < samplesRead; i++) {
        sum += (long)audioBuffer[i] * audioBuffer[i];
    }
    float rms = sqrt((float)sum / samplesRead);

    Serial.print("Audio RMS: ");
    Serial.println(rms);
}
```

### USB Audio Mode (No Arduino Code Needed)

When using USB firmware (default), the reSpeaker Lite appears as a standard USB audio device:

1. Connect reSpeaker Lite USB-C to PC/Raspberry Pi
2. Device appears as "XMOS USB Audio" in system audio settings
3. Select as input (microphone) and/or output (speaker) device
4. No driver installation required (UAC2 standard)

---

## TinyGo Setup & Usage

### TinyGo I2S Support

TinyGo has limited I2S support. For XIAO ESP32S3 with reSpeaker Lite:

```go
package main

import (
    "machine"
    "time"
)

func main() {
    // TinyGo I2S support for ESP32S3 is experimental
    // Check tinygo.org/x/drivers for latest I2S driver availability

    println("reSpeaker Lite - TinyGo")
    println("Note: I2S support in TinyGo for ESP32S3 is limited")
    println("Consider using USB audio mode instead")

    for {
        time.Sleep(1 * time.Second)
    }
}
```

> **⚠ TinyGo Limitation:** I2S driver support in TinyGo for ESP32S3 is experimental and may not be fully functional. For audio applications, the USB audio mode (no XIAO needed) is recommended, or use Arduino for I2S integration.

---

## Communication Protocol Details

### I2S Configuration

| Parameter | Value |
|-----------|-------|
| Sample Rate | 16kHz (max) |
| Bit Depth | 16-bit |
| Channels | 2 (dual microphone) |
| Format | I2S standard |
| Mode | Master (XIAO) / Slave (XU316) |

### USB Audio (UAC2)

| Parameter | Value |
|-----------|-------|
| Standard | USB Audio Class 2.0 |
| Sample Rate | Up to 16kHz |
| Channels | 2 input (mic), 2 output (speaker/headphone) |
| Driver | Driverless (OS native UAC2 support) |
| Compatible OS | Windows 10+, macOS, Linux, Raspberry Pi OS |

---

## Common Gotchas / Notes

1. **Not a traditional XIAO hat** — The reSpeaker Lite is a larger board (35×86mm) with its own USB-C port; the XIAO plugs INTO it
2. **Two firmware versions** — USB firmware (default, plug-and-play) and I2S firmware (for XIAO ESP32S3 integration); must flash correct firmware for your use case
3. **DFU-Util required** — Firmware updates require DFU-Util command line tool; cannot be done via Arduino IDE
4. **XIAO ESP32S3 only for I2S** — Only the XIAO ESP32S3 (Sense) is supported for I2S audio via the socket
5. **USB mode needs no XIAO** — In USB mode, the reSpeaker Lite works standalone as a USB audio device
6. **5W speaker amplifier** — Connect a compatible speaker to the speaker connector for audio output
7. **Mute button** — Physical mute button on the board mutes microphone input
8. **WS2812 RGB LED** — Programmable LED for visual feedback (voice activity indicator, etc.)
9. **16kHz max sampling rate** — Sufficient for voice applications but not for music-quality audio

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/reSpeaker_usb_v3/
- **DFU-Util:** https://dfu-util.sourceforge.net/
- **XMOS XU316:** https://www.xmos.com/
- **Seeed Product Page:** https://www.seeedstudio.com/reSpeaker-Lite-p-5928.html
