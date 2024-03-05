#ifndef __MIPSFPGA_H__
#define __MIPSFPGA_H__


// I/O

// Red LEDs
static volatile unsigned int * const LEDR = (unsigned int *)0xbf800000ul;
// Green LEDs
static volatile unsigned int * const LEDG = (unsigned int *)0xbf800004ul;
// Switches
static volatile unsigned int * const SW = (unsigned int *)0xbf800008ul;
// Pushbuttons
static volatile unsigned int * const PB = (unsigned int *)0xbf80000cul;


// Scratch registers
static volatile unsigned int * const SCRATCH0 = (unsigned int *)0xbf800010ul;
static volatile unsigned int * const SCRATCH1 = (unsigned int *)0xbf800014ul;
static volatile unsigned int * const SCRATCH2 = (unsigned int *)0xbf800018ul;
static volatile unsigned int * const SCRATCH3 = (unsigned int *)0xbf80001cul;
static volatile unsigned int * const SCRATCH4 = (unsigned int *)0xbf800020ul;
static volatile unsigned int * const SCRATCH5 = (unsigned int *)0xbf800024ul;
static volatile unsigned int * const SCRATCH6 = (unsigned int *)0xbf800028ul;
static volatile unsigned int * const SCRATCH7 = (unsigned int *)0xbf80002cul;


// Scratch memory
extern int __scratch_start;
extern int __scratch_end;


// SYNC
#ifdef __sync
#undef __sync
#endif
#define __sync() __asm__ __volatile__ ( "sync;" : : : "memory" )


// Compiler barrier
#ifdef __ccbarrier
#undef __ccbarrier
#endif
#define __ccbarrier __asm__ __volatile__ ( : : : "memory" )


// Prevent name mangling of CPU0/CPU1 labels
#ifdef __cplusplus
extern "C" void CPU0();
extern "C" void CPU1();
#endif


#endif

