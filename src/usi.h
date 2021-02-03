#include <avr/io.h>

#ifndef USI_H
#define USI_H

#ifndef RX
#define RX  PB0
#endif

#ifndef TX
#define TX  PB1
#endif

#define STATUS  USISR
#define CONTROL USICR
#define DATA    USIDR

static uint8_t reverse(char b);

static void usi_init(void);

static void usi_send_byte(char byte);

void usi_send_data(const char *str);

#endif
