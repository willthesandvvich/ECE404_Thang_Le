#include <mipsfpga.h>


void CPU0()
{
    int big_endian = 0;
    
    /*
     * Your code
     */
    
    *LEDR = big_endian;
    
    while (1);
}

void CPU1()
{
    /* Just keep it busy */
    while (1);
}

