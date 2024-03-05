#include <mipsfpga.h>

void CPU0()
{
    while (1) {
        *LEDR = 1;
    }
}

void CPU1()
{
    while (1) {
        *LEDR = 0;
    }
}

