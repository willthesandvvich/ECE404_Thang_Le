ENTRY(_start)

SECTIONS
{
    . = __PROGRAM_BASE__;
    __start = .;
    
    __text_start = .;
    .text : {
        KEEP(*(.text.cstart));
        *(.text);
    }
    __text_end = .;
    
    __rodata_start = .;
    .rodata :
    {
        *(.rodata)
    }
    __rodata_end = .;
    
    __data_start = .;
    .data :
    {
        *(.data)
    }
    __data_end = .;

    __bss_start = .;
    .bss  :
    {
        *(.bss)
    }
    __bss_end = .;
    
    /* Main program ends here */
    . = ALIGN(4096) - 4;
    .program_marker :
    {
        LONG(0xece404cc);
    }
    __program_end = .;
    
    /* Core0 stack */
    . = __program_end + 16384;
    __stack_top0 = .;
    .stack0_marker :
    {
        LONG(0xece404c0);
    }
    
    /* Core1 stack */
    . = __program_end + 32768;
    __stack_top1 = .;
    .stack1_marker :
    {
        LONG(0xece404c1);
    }
    
    /* Scratch memory */
    __scratch_start = .;
    . = __program_end + 65536 - 4;
    .scratch_marker :
    {
        LONG(0xece404aa);
    }
    __scratch_end = .;
    
    /* Discard */
    /DISCARD/ :
    {
        *(.gnu.*);
        *(.mdebug*);
        *(.pdr);
        *(.comment);
        *(.note.*);
    }
    
    __end = .;
}
