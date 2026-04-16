# Makefile for XIAO SAMD21 HID Bridge Firmware

BOARD ?= seeed-xiao
PORT  ?= /dev/ttyACM0

.PHONY: all firmware.bin flash debug clean

all: firmware.bin

firmware.bin:
	tinygo build -target=$(BOARD) -o firmware.bin ./main.go

flash: firmware.bin
	bossac -d --port=$(PORT) -U true -w firmware.bin -R

debug:
	screen $(PORT) 115200

clean:
	rm -f firmware.bin *.elf *.hex

# Alternative flash using Arduino CLI
flash-arduino: firmware.bin
	arduino-cli upload -b seeed:avr:xiaosamd21 -p $(PORT) --input-file firmware.bin