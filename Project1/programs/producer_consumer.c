#include <mipsfpga.h>

volatile unsigned int buffer = 0;

void CPU0()
{
    while (1) {
        *LEDR = buffer;
    }
}

void CPU1()
{
    while (1) {
        buffer++;
    }
}

