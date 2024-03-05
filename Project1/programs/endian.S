# CPU 0 will start executing here
CPU0:
    #
    # Your code
    #
    
DONE:
    j   DONE
    nop

# CPU 1 will start executing here
CPU1:
    # Just keep it busy
    j   CPU1
    nop

