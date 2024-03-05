# Exception Handler
# Place Exception Code in $k0 and PC of instruction that caused exception in $k1
.excvector 0x380
.label Exception Handler
# Place CAUSE in $k0
mfc0 $k0, $13, 0
# Extract ExcCode (bits 6:2)
ext $k0, $k0, 2, 5
# Place Exception Program Counter (EPC) in $k1
mfc0 $k1, $14, 0

