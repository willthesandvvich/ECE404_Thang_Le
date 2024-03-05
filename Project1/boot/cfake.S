# CPU0
CPU0:
    b _stop
    nop

# CPU1
CPU1:
    b _stop
    nop

_stop:
    b _stop
    nop
