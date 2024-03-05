#include <mipsfpga.h>


static volatile int counter __attribute__ ((aligned (4)));


/*
 * Your variables
 */


static void peterson_lock(int cpu)
{
    /*
     * Your code
     */
}

static void peterson_unlock(int cpu)
{
    /*
     * Your code
     */
}


static void count(int cpu)
{
    peterson_lock(cpu);
    
    *LEDG = cpu;
    counter++;
    *LEDR = counter;
    
    peterson_unlock(cpu);
}

void CPU0()
{
    while (1) {
        count(0);
    }
}

void CPU1()
{
    while (1) {
        count(1);
    }
}

