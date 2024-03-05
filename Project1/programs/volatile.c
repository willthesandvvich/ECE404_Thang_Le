#include <mipsfpga.h>


void CPU0()
{
    int a = 1;
    int b = 2;
    
    if (a > b) {
        *LEDG = a + b;
    }
}

void CPU1()
{
    volatile int a = 1;
    int b = 2;
    
    if (a > b) {
        *LEDG = a + b;
    }
}

