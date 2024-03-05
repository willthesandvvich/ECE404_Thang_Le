CPU0:   lui     $8, 0xbf80     	# LEDR addr (so we can see current count)
        li      $9, LOC         # Location in unmapped, uncached memory
L:      lw      $10, 0($9)      # Read location
        b       L               # Loop
        sw      $10, 0($8)      # Store to LEDR (in delay slot)
CPU1:   add     $11, $0, $0     # Clear register 11 (counter)
        li      $8, LOC         # Location in unmapped, uncached memory
L2:     addiu   $11, $11, 1     # Increment
        sw      $11, 0($8)      # Store to memory slot
        b       L2              # Loop
        nop

        .data
LOC:    .word 0x0

