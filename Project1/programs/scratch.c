#include <mipsfpga.h>

void CPU0()
{
    *SCRATCH0 = 0;
    *SCRATCH1 = 1;
    *SCRATCH2 = 2;
    *SCRATCH3 = 3;
    
    while (1) {
        *SCRATCH0 = *SCRATCH0 + 1;
        *SCRATCH1 = *SCRATCH1 + 1;
        *SCRATCH2 = *SCRATCH2 + 1;
        *SCRATCH3 = *SCRATCH3 + 1;
    }
}

void CPU1()
{
    *SCRATCH4 = 4;
    *SCRATCH5 = 5;
    *SCRATCH6 = 6;
    *SCRATCH7 = 7;
    
    while (1) {
        *SCRATCH4 = *SCRATCH4 + 1;
        *SCRATCH5 = *SCRATCH5 + 1;
        *SCRATCH6 = *SCRATCH6 + 1;
        *SCRATCH7 = *SCRATCH7 + 1;
    }
}

