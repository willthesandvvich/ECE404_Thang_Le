# Initialize Registers
# Sets up $sp, $fp, $gp
# Upper address in $a0
#   i.e. CPU1 in uncached: 0xa0020000
# Segment of halt in $a1 (0x9fc0 for cacheable, 0xbfc0 for uncacheable)
$init-registers:
    # heap 0x....0000-0x....efef
    ori $gp, $a0, 0xc000
    # stack 0x....eff0-0x....fff0
    ori $sp, $a0, 0xfff0
    move $fp, $sp
    # Save $ra
    move $t0, $ra
    # Get $halt into $ra (either in kseg0 or kseg1)
    sll $ra, $a1, 16
    jr $t0
    ori $ra, $ra, %lo($halt)

