#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>

#include "i2c.h"
#include "usi.h"
#include "bmp180.h"

void delay_ms(uint16_t);

int main(void)
{
    char output[100];
    struct bmp180_measurements measurements = {0};
    while (1) {
	bmp180_measure(&measurements);
	sprintf(output, "Temperature: %ld\tPressure: %ld\n", measurements.temperature, measurements.pressure);
	usi_send_data(output);
	delay_ms(2000);
    }
}

void delay_ms(uint16_t ms)
{
    while (--ms > 0)
        _delay_ms(1);
}
