---
name: xiao-esp32s3-sense-arduino
description: >
  Provides comprehensive pinout reference, board specifications, and Arduino C++ development guide
  for the Seeed Studio XIAO ESP32-S3 Sense microcontroller. Use when writing Arduino firmware for the
  XIAO ESP32-S3 Sense, wiring peripherals, or configuring pins. Keywords: XIAO, ESP32-S3, Sense,
  Arduino, Espressif, Xtensa, dual-core, WiFi, BLE, Bluetooth, PSRAM, camera, OV3660, OV5640,
  microphone, PDM, SD card, I2S, pinout, GPIO, I2C, SPI, UART, analog, digital, PWM, touch,
  deep sleep, battery, ESP-IDF, USB OTG.
---

# XIAO ESP32-S3 Sense — Arduino Development Guide

Provides comprehensive reference for developing Arduino C++ firmware for the Seeed Studio XIAO ESP32-S3 Sense.

## When to Use

- Writing Arduino C++ firmware targeting the XIAO ESP32-S3 Sense
- Looking up XIAO ESP32-S3 Sense pin assignments, alternate functions, or peripheral mappings
- Working with the camera (OV3660), microphone, or SD card on the Sense expansion board
- Configuring I2C, SPI, UART, WiFi, BLE, or analog I/O on the XIAO ESP32-S3 Sense in Arduino

## When NOT to Use

- For TinyGo development on the XIAO ESP32-S3 Sense → use the `XIAO-ESP32S3-Sense-TinyGo` skill
- For the base XIAO ESP32-S3 (without camera/mic) → use the `XIAO-ESP32S3-Arduino` skill
- For other XIAO boards → use the corresponding board skill

---

## Board Overview

| Parameter | Value |
|---|---|
| **MCU** | Espressif ESP32-S3R8 |
| **Architecture** | Xtensa LX7 dual-core, 32-bit |
| **Clock Speed** | Up to 240 MHz |
| **Flash** | 8 MB |
| **PSRAM** | 8 MB |
| **RAM** | On-chip SRAM (part of ESP32-S3R8) |
| **Wireless** | 2.4 GHz WiFi 802.11 b/g/n, Bluetooth 5.0 (BLE), Bluetooth Mesh |
| **Camera** | OV3660 (also compatible with OV5640) |
| **Microphone** | Digital PDM microphone |
| **Storage** | Onboard SD card slot (supports 32 GB FAT) |
| **USB** | USB Type-C (native USB OTG) |
| **Operating Voltage** | 3.3V logic; 5V input (Type-C), 3.7V (BAT) |
| **Dimensions** | 21 × 17.8 × 15 mm (with expansion board) |
| **Working Temp** | -20°C to 65°C |
| **GPIO Count** | 11 digital/PWM, 9 analog/ADC (+2 via B2B connector) |
| **Deep Sleep** | ~3 mA (with expansion board) |
| **Touch Pins** | 9 (D0–D5, D8–D10) |
| **Battery** | Supports LiPo charge/discharge (3.7V BAT pads) |

---

## Pinout Diagram

```
                      [USB-C]
                ┌───────────────┐
      D0/A0   ──┤ 1          14 ├── 5V
      D1/A1   ──┤ 2          13 ├── GND
   ⚠ D2/A2   ──┤ 3          12 ├── 3V3
      D3/A3   ──┤ 4          11 ├── D10/A6/MOSI
    D4/SDA/A4 ──┤ 5          10 ├──⚠D9/A5/MISO
    D5/SCL/A5 ──┤ 6           9 ├──⚠D8/A4/SCK
      D6/TX   ──┤ 7           8 ├── D7/RX
                └───────────────┘
         Bottom pads: BAT+, BAT-, GND
         JTAG pads: MTDO(GPIO40), MTDI(GPIO41),
                    MTCK(GPIO39), MTMS(GPIO42)
         ⚠ = shared with SD card / microphone
         Camera via B2B connector (internal)
```

---

## Pin Reference Table

| Pin | Chip Pin | Digital | Analog | PWM | I2C | SPI | UART | Other |
|-----|----------|---------|--------|-----|-----|-----|------|-------|
| D0  | GPIO1    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH1 |
| D1  | GPIO2    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH2 |
| D2  | GPIO3    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH3, **⚠ SD_CS** |
| D3  | GPIO4    | ✓       | ADC    | ✓   | —   | —   | —    | TOUCH4 |
| D4  | GPIO5    | ✓       | ADC    | ✓   | **SDA** | — | —  | TOUCH5 |
| D5  | GPIO6    | ✓       | ADC    | ✓   | **SCL** | — | —  | TOUCH6 |
| D6  | GPIO43   | ✓       | —      | ✓   | —   | —   | **TX** | — |
| D7  | GPIO44   | ✓       | —      | ✓   | —   | —   | **RX** | — |
| D8  | GPIO7    | ✓       | ADC    | ✓   | —   | **SCK** | — | TOUCH7, **⚠ SD_SCK** |
| D9  | GPIO8    | ✓       | ADC    | ✓   | —   | **MISO** | — | TOUCH8, **⚠ SD_MISO** |
| D10 | GPIO9    | ✓       | ADC    | ✓   | —   | **MOSI** | — | TOUCH9 |

### ⚠ Pin Conflicts (Sense Expansion Board)

| Peripheral | Pins Used | Conflicts With |
|------------|-----------|----------------|
| **SD Card** | GPIO3 (CS), GPIO7 (SCK), GPIO8 (MISO), GPIO10 (MOSI) | D2, D8, D9 external pins |
| **Microphone** | GPIO42 (CLK), GPIO41 (DATA) | D11, D12 bottom JTAG pads |
| **Camera** | GPIO10–18, GPIO38–40, GPIO47–48 | Internal B2B connector only |

> **⚠ Critical:** When using the SD card, external pins D2 (GPIO3), D8 (GPIO7), and D9 (GPIO8) are unavailable. When using the microphone, bottom pads D11 (GPIO42) and D12 (GPIO41) are unavailable.

### Digital Microphone Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| MIC_CLK | GPIO42 | PDM clock pin |
| MIC_DATA | GPIO41 | PDM data pin |

### SD Card Pins

| Pin | Chip Pin | Description |
|-----|----------|-------------|
| SD_CS | GPIO3 | SD card chip select (shared with D2) |
| SD_SCK | GPIO7 | SD card clock (shared with D8) |
| SD_MISO | GPIO8 | SD card data input (shared with D9) |
| SD_MOSI | GPIO10 | SD card data output |

### Camera Pins (internal, via B2B connector)

| Chip Pin | Description |
|----------|-------------|
| GPIO10 | Camera clock (XCLK) |
| GPIO11 | Camera Y8 |
| GPIO12 | Camera Y7 |
| GPIO13 | Camera pixel clock (PCLK) |
| GPIO14 | Camera Y6 |
| GPIO15 | Camera Y2 |
| GPIO16 | Camera Y5 |
| GPIO17 | Camera Y3 |
| GPIO18 | Camera Y4 |
| GPIO40 | Camera I2C data (SIOD) |
| GPIO39 | Camera I2C clock (SIOC) |
| GPIO38 | Camera VSYNC |
| GPIO47 | Camera HREF |
| GPIO48 | Camera Y9 |

### Internal / Special Pins

| Name | Chip Pin | Description |
|------|----------|-------------|
| Reset | CHIP_PU | Reset |
| Boot | GPIO0 | Enter bootloader |
| USER_LED | GPIO21 | User LED |
| CHG LED | — | Charge indicator |
| U.FL Antenna | LNA_IN | External antenna connector |

---

## Arduino Setup

### Board Manager URL

```
https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
```

### Installation

1. Open Arduino IDE → **File** → **Preferences**
2. Add the URL above to **Additional Board Manager URLs**
3. Open **Tools** → **Board** → **Board Manager**
4. Search for **"esp32"** by Espressif Systems and install it
5. Select **Tools** → **Board** → **ESP32 Arduino** → **XIAO_ESP32S3**
6. Set **Tools** → **USB CDC On Boot** → **Enabled** (for Serial Monitor over USB)
7. Set **Tools** → **PSRAM** → **OPI PSRAM** (required for camera)

### Arduino CLI Setup

```bash
# Add board index
arduino-cli config add board_manager.additional_urls \
  https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

# Update index and install core
arduino-cli core update-index
arduino-cli core install esp32:esp32

# Compile (enable PSRAM for camera)
arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32S3:PSRAMMode=opi ./sketch

# Upload (replace /dev/ttyACM0 with your port)
arduino-cli upload --fqbn esp32:esp32:XIAO_ESP32S3 -p /dev/ttyACM0 ./sketch
```

### Board FQBN

```
esp32:esp32:XIAO_ESP32S3
```

> **Note:** The Sense variant uses the same FQBN as the base ESP32-S3. Enable PSRAM in board options for camera use.

### Example: Blink (Arduino)

```cpp
const int LED_PIN = 21; // GPIO21 — User LED

void setup() {
    pinMode(LED_PIN, OUTPUT);
}

void loop() {
    digitalWrite(LED_PIN, HIGH);
    delay(500);
    digitalWrite(LED_PIN, LOW);
    delay(500);
}
```

### Example: Camera Capture

```cpp
#include "esp_camera.h"

// XIAO ESP32-S3 Sense camera pin definitions
#define PWDN_GPIO_NUM  -1
#define RESET_GPIO_NUM -1
#define XCLK_GPIO_NUM  10
#define SIOD_GPIO_NUM  40
#define SIOC_GPIO_NUM  39

#define Y9_GPIO_NUM    48
#define Y8_GPIO_NUM    11
#define Y7_GPIO_NUM    12
#define Y6_GPIO_NUM    14
#define Y5_GPIO_NUM    16
#define Y4_GPIO_NUM    18
#define Y3_GPIO_NUM    17
#define Y2_GPIO_NUM    15
#define VSYNC_GPIO_NUM 38
#define HREF_GPIO_NUM  47
#define PCLK_GPIO_NUM  13

void setup() {
    Serial.begin(115200);

    camera_config_t config;
    config.ledc_channel = LEDC_CHANNEL_0;
    config.ledc_timer = LEDC_TIMER_0;
    config.pin_d0 = Y2_GPIO_NUM;
    config.pin_d1 = Y3_GPIO_NUM;
    config.pin_d2 = Y4_GPIO_NUM;
    config.pin_d3 = Y5_GPIO_NUM;
    config.pin_d4 = Y6_GPIO_NUM;
    config.pin_d5 = Y7_GPIO_NUM;
    config.pin_d6 = Y8_GPIO_NUM;
    config.pin_d7 = Y9_GPIO_NUM;
    config.pin_xclk = XCLK_GPIO_NUM;
    config.pin_pclk = PCLK_GPIO_NUM;
    config.pin_vsync = VSYNC_GPIO_NUM;
    config.pin_href = HREF_GPIO_NUM;
    config.pin_sccb_sda = SIOD_GPIO_NUM;
    config.pin_sccb_scl = SIOC_GPIO_NUM;
    config.pin_pwdn = PWDN_GPIO_NUM;
    config.pin_reset = RESET_GPIO_NUM;
    config.xclk_freq_hz = 20000000;
    config.frame_size = FRAMESIZE_UXGA;
    config.pixel_format = PIXFORMAT_JPEG;
    config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;
    config.fb_location = CAMERA_FB_IN_PSRAM;
    config.jpeg_quality = 12;
    config.fb_count = 1;

    // Init camera
    esp_err_t err = esp_camera_init(&config);
    if (err != ESP_OK) {
        Serial.printf("Camera init failed: 0x%x\n", err);
        return;
    }
    Serial.println("Camera initialized!");
}

void loop() {
    camera_fb_t* fb = esp_camera_fb_get();
    if (fb) {
        Serial.printf("Captured image: %dx%d, %d bytes\n",
            fb->width, fb->height, fb->len);
        esp_camera_fb_return(fb);
    }
    delay(5000);
}
```

### Example: Microphone (PDM/I2S)

```cpp
#include <I2S.h>

void setup() {
    Serial.begin(115200);

    // Configure I2S for PDM microphone
    I2S.setAllPins(-1, 42, 41, -1, -1); // BCLK=-1, WS=GPIO42, SDOUT=GPIO41
    if (!I2S.begin(PDM_MONO_MODE, 16000, 16)) {
        Serial.println("I2S init failed!");
        return;
    }
    Serial.println("Microphone initialized!");
}

void loop() {
    int sample = I2S.read();
    if (sample != 0 && sample != -1) {
        Serial.println(sample);
    }
}
```

### Example: SD Card

```cpp
#include "FS.h"
#include "SD.h"
#include "SPI.h"

void setup() {
    Serial.begin(115200);

    // SD card uses shared SPI pins
    SPI.begin(7, 8, 10, 3); // SCK=GPIO7, MISO=GPIO8, MOSI=GPIO10, CS=GPIO3
    if (!SD.begin(3)) { // CS = GPIO3 (D2)
        Serial.println("SD card mount failed!");
        return;
    }

    Serial.printf("SD Card Type: %d\n", SD.cardType());
    Serial.printf("SD Card Size: %lluMB\n", SD.cardSize() / (1024 * 1024));

    // Write a file
    File file = SD.open("/test.txt", FILE_WRITE);
    if (file) {
        file.println("Hello from XIAO ESP32-S3 Sense!");
        file.close();
        Serial.println("File written!");
    }
}

void loop() {
    delay(1000);
}
```

---

## Communication Protocols

### I2C

- **SDA:** D4 (GPIO5)
- **SCL:** D5 (GPIO6)
- **Arduino object:** `Wire`

```cpp
#include <Wire.h>

void setup() {
    Wire.begin(); // Uses default SDA=D4, SCL=D5
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

### SPI

- **SCK:** D8 (GPIO7)
- **MISO:** D9 (GPIO8)
- **MOSI:** D10 (GPIO9)
- **CS:** Any GPIO (user-defined)
- **Arduino object:** `SPI`

> **⚠ Warning:** SD card shares SCK (GPIO7), MISO (GPIO8), and CS (GPIO3/D2) with external SPI. Do not use external SPI devices on these pins simultaneously with the SD card.

```cpp
#include <SPI.h>

const int CS_PIN = D3; // GPIO4

void setup() {
    pinMode(CS_PIN, OUTPUT);
    digitalWrite(CS_PIN, HIGH);
    SPI.begin(D8, D9, D10, CS_PIN);
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

- **TX:** D6 (GPIO43)
- **RX:** D7 (GPIO44)
- **Arduino object:** `Serial1`
- **USB Serial:** `Serial` (USB CDC — for Serial Monitor)

```cpp
void setup() {
    Serial.begin(115200);    // USB serial (Serial Monitor)
    Serial1.begin(9600, SERIAL_8N1, D7, D6); // RX=D7, TX=D6
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
    analogReadResolution(12);
    Serial.begin(115200);
}

void loop() {
    int value = analogRead(A0); // D0 / GPIO1
    Serial.println(value);
    delay(100);
}
```

### WiFi

The ESP32-S3 Arduino core provides full WiFi support:

```cpp
#include <WiFi.h>

const char* ssid = "YOUR_SSID";
const char* password = "YOUR_PASSWORD";

void setup() {
    Serial.begin(115200);
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Connected! IP: ");
    Serial.println(WiFi.localIP());
}

void loop() {
    delay(1000);
}
```

---

## Power Management

### Voltage and Current

- **Logic level:** 3.3V on all GPIO pins
- **5V output:** From USB VBUS
- **3.3V output:** Up to 700 mA
- **Deep sleep:** ~3 mA (with expansion board attached)

### Battery Support

- **Battery pads:** Solder LiPo battery to BAT+ and BAT- pads on the bottom
- **Charge LED:** Indicates charging status
- **Input:** 3.7V LiPo battery

### Deep Sleep

```cpp
#include <esp_sleep.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Going to sleep...");
    delay(1000);

    esp_sleep_enable_timer_wakeup(10 * 1000000); // 10 seconds
    esp_deep_sleep_start();
}

void loop() {}
```

> **Note:** Deep sleep current is ~3 mA with the Sense expansion board (camera/mic circuits draw standby power). For lowest power consumption, consider the base ESP32-S3 variant (~14 μA).

**Wake-up sources:**
- **Timer:** `esp_sleep_enable_timer_wakeup(us)`
- **GPIO:** `esp_sleep_enable_ext0_wakeup(pin, level)`
- **Touch:** `esp_sleep_enable_touchpad_wakeup()`

```cpp
RTC_DATA_ATTR int bootCount = 0;

void setup() {
    bootCount++;
    Serial.begin(115200);
    Serial.printf("Boot count: %d\n", bootCount);
}
```

---

## Special Features (Sense-Specific)

### Camera (OV3660)

The Sense variant includes an OV3660 camera sensor (OV5640 also compatible; OV2640 discontinued). See the Camera Capture example above.

Key camera settings:
- **Resolution:** Up to UXGA (1600×1200)
- **Format:** JPEG, RGB565, YUV422, Grayscale
- **PSRAM required:** Enable OPI PSRAM in board settings for frame buffers
- Camera pins are internal via B2B connector — no external pin conflicts

### Digital Microphone (PDM)

PDM digital microphone via I2S interface. See the Microphone example above.
- **MIC_CLK:** GPIO42 (shared with D11/MTMS bottom pad)
- **MIC_DATA:** GPIO41 (shared with D12/MTDI bottom pad)

### SD Card

SPI-based SD card slot (supports up to 32 GB FAT). See the SD Card example above.
- Shares SPI pins with external D2, D8, D9

### USB OTG

Native USB OTG support enables USB HID, MSC, and CDC:

```cpp
#include "USB.h"
#include "USBHIDKeyboard.h"

USBHIDKeyboard Keyboard;

void setup() {
    Keyboard.begin();
    USB.begin();
}

void loop() {
    Keyboard.print("Hello!");
    delay(5000);
}
```

### PSRAM (8 MB)

Enable in **Tools** → **PSRAM** → **OPI PSRAM**. Required for camera frame buffers.

```cpp
void setup() {
    Serial.begin(115200);
    Serial.printf("Total PSRAM: %d bytes\n", ESP.getPsramSize());
    Serial.printf("Free PSRAM: %d bytes\n", ESP.getFreePsram());

    uint8_t* buf = (uint8_t*)ps_malloc(1024 * 1024);
    if (buf) {
        Serial.println("1MB PSRAM allocated!");
        free(buf);
    }
}
```

### Touch Sensing

9 capacitive touch pins (D0–D5, D8–D10):

```cpp
void loop() {
    Serial.printf("Touch: %d\n", touchRead(T1)); // D0/GPIO1
    delay(200);
}
```

---

## Common Gotchas / Notes

1. **Enable PSRAM for camera** — Set **Tools** → **PSRAM** → **OPI PSRAM**; camera will fail without it
2. **SD card shares pins with D2, D8, D9** — Cannot use these external pins when SD card is active
3. **Microphone shares pins with JTAG pads** — GPIO41/42 (D11/D12) unavailable when mic is active
4. **Higher deep sleep current** — ~3 mA with expansion board vs ~14 μA for base ESP32-S3
5. **Enable USB CDC On Boot** — Required for Serial Monitor over USB
6. **OV2640 discontinued** — Camera is now OV3660; OV5640 also compatible
7. **Same FQBN as base ESP32-S3** — Uses `esp32:esp32:XIAO_ESP32S3`
8. **Camera + SD card simultaneously** — Possible but requires careful SPI bus management; camera uses internal pins, SD uses shared SPI
9. **3.3V logic only** — Do NOT connect 5V signals directly to GPIO pins
10. **WiFi + BLE coexistence** — Both can run simultaneously but share the radio

---

## Reference Links

- **Seeed Wiki:** https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/
- **Board package (Espressif):** https://github.com/espressif/arduino-esp32
- **ESP32-S3 datasheet:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf
- **ESP32-S3 technical reference:** https://www.espressif.com/sites/default/files/documentation/esp32-s3_technical_reference_manual_en.pdf
- **Arduino-ESP32 docs:** https://docs.espressif.com/projects/arduino-esp32/
- **Schematic:** https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/XIAO_ESP32S3_SCH_v1.2.pdf
