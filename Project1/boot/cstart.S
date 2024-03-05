.set noreorder

.global _start

.extern __stack_top0
.extern __stack_top1

.extern CPU0
.extern CPU1

.section ".text.cstart"

_start:
    /* CPU0 */
    bal _start0
    li $sp, __stack_top0

    /* CPU1 */
    bal _start1
    li $sp, __stack_top1

_start0:
    subu $ra, $ra, 8
    bal CPU0
    addu $sp, $sp, $ra
    
    b .
    nop

_start1:
    subu $ra, $ra, 8 + 8
    bal CPU1
    addu $sp, $sp, $ra
    
    b .
    nop

