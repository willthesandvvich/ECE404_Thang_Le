# from: http://cdn.imgtec.com/mips-training/mips-basic-training-course/slides/Caches.pdf
.label Initialize Caches

# Initialize Caches, then jump to the cacheable equivalent of the address in
# $ra (if the instruction cache could be initialized), otherwise jumps to $ra
$init-cache:
    # Init I$
    mfc0 $t2, $16, 1 # get icache line size from config1 cp0 register
    # Isolate I$ line size
    # extract IL bits 19-21
    ext $t3, $t2, 19, 3
    # if line size is 0, we have no I$ - skip
    beqz $t3, $init-dcache
    nop
    li $t6, 2
    sllv $t3, $t6, $t3 # I$ line size in $t3
    # Isolate I$ sets (number of lines, and tags per way)
    # extract IS bits 22-24
    ext $t4, $t2, 22, 3
    # Compute sets per way (power of 2 starting w/ 64)
    li $t6, 64
    sllv $t4, $t6, $t4 # I$ sets per way in $t4
    # Get the number of ways
    ext $t5, $t2, 16, 3
    addi $t5, $t5, 1
    mul $t4, $t4, $t5 # I$ number of sets in $t4
    # Neet to start from kseg0
    li $t6, 0x80000000
    # Clear TagLo/TagHi registers
    # These are written to the cache tag by the CACHE instruction
    mtc0 $0, $28 # TagLo
    mtc0 $0, $29 # TagHi
    # Use $t7 as loop counter
    move $t7, $t4
# Invalidation loop for I$
$inv-i:
    cache 0x8, 0($t6) # Invalidate entry
    addi $t7, $t7, -1
    bnez $t7, $inv-i
    add $t6, $t6, $t3 # increment by line size


    # Since the I$ is set up, jump to cacheable region
    # Enable caching in kseg0
    mfc0 $t2, $16, 0
    li $t3, 3
    ins $t2, $t3, 0, 3
    mtc0 $t2, $16, 0
    # Jump to kseg0
    # Also, make return address also in cacheable region
    lui $s0, 0x9fc0
    andi $ra, $ra, 0xffff
    or $ra, $ra, $s0
    ori $s0, $s0, %lo($init-dcache)
    jr.hb $s0 # Clear all hazards and jump
    nop


# Init the dcache
$init-dcache:
    # Put config1 cp0 in $t2
    mfc0 $t2, $16, 1
    # extract bits 10-12
    ext $t3, $t2, 10, 3 # get dcache line size
    # if line size is 0, no D$ - skip
    beqz $t3, $done-cache-init
    nop
    li $t6, 2
    sllv $t3, $t6, $t3 # D$ line size in $t3
    # Isolate D$ sets
    # extract bits 13-15
    ext $t4, $t2, 13, 3
    # Compute sets per way (power of 2 starting w/64)
    li $t6, 64
    sllv $t4, $t6, $t4 # D$ sets per wat in $t4
    # Get the number of ways
    ext $t5, $t2, 7, 3
    addi $t5, $t5, 1
    mul $t4, $t4, $t5 # D$ number of sets in $t4
    # Need to start from kseg0
    li $t6, 0x80000000
    # Clear TagLo/TagHi registers
    # These are written to the cache tag by the CACHE instruction
    mtc0 $0, $28 # TagLo
    mtc0 $0, $29 # TagHi
    mtc0 $0, $28, 2 # DTagLo
    mtc0 $0, $29, 2 # DTagHi
    # Use $t7 as loop counter
    move $t7, $t4
# Invalidation loop for D$
$inv-d:
    cache 0x9, 0($t6) # invalidate entry
    addi $t7, $t7, -1
    bnez $t7, $inv-d
    add $t6, $t6, $t3 # increment by line size

# Caches should be ready to go: return
$done-cache-init:
    jr $ra
    nop

