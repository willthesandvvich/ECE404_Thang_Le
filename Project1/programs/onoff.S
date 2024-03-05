# CPU 0 will start executing here
CPU0:
    addiu   $s0, $0, 1
    lui     $s1, 0xbf80      # LEDR addr
LEDR_ON:
    sw      $s0, 0($s1)      # Turn on LEDR
    j       LEDR_ON          # Loop
    nop

# CPU 1 will start executing here
CPU1:
    lui     $s1, 0xbf80      # LEDR addr
LEDR_OFF:
    sw      $0, 0($s1)       # Turn off LEDR
    j       LEDR_OFF         # Loop
    nop
