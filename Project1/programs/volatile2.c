#include <mipsfpga.h>

void CPU0()
{
    int i;
    for (i = 0; i < 1024; i++) {
        *LEDG = i;
    }
}

void CPU1()
{
    volatile int i;
    for (i = 0; i < 1024; i++) {
        *LEDG = i;
    }
}

