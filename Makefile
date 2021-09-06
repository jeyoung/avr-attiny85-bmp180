AVRDUDE_PATH = avrdude

SRC_DIR = ./src
INCLUDE_DIRS = -I./include -I/usr/lib/avr/include

CC = avr-gcc
OBJCOPY = avr-objcopy

AVRDUDE = $(AVRDUDE_PATH)
PORT = usb
PROGRAMMER = avrispmkII
MCU = attiny85
PART = t85

ATTINY_I2C = -DI2C=DDRB -DI2C_READ=PINB -DSCL=PB2 -DSDA=PB3 -DBAUD_RATE=9600

CFLAGS = -Os $(ATTINY_I2C) -DF_CPU=1000000UL $(INCLUDE_DIRS) -std=c11 -mmcu=$(MCU) -Wall
LDFLAGS = -L/usr/lib/avr/lib -mmcu=$(MCU)
OBJECTS = $(TARGET).o usi.o i2c.o bmp180.o

TARGET = main

all: clean upload

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(TARGET).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

upload: $(TARGET).hex
	$(AVRDUDE) -v -F -c $(PROGRAMMER) -p $(PART) -P $(PORT) -U flash:w:$<:i -U lfuse:w:0x62:m -U hfuse:w:0xDF:m -U efuse:w:0xFF:m

clean:
	-rm -f $(TARGET).hex $(TARGET).elf $(OBJECTS)
