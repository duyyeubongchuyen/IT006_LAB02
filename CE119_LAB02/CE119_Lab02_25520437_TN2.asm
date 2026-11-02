.text
main:
    li   $a0, 17
    li   $a1, 25
    jal  max2
    move $a0, $v0
    li   $v0, 1
    syscall
    li   $v0, 10
    syscall
 
# max2: tra ve so lon hon trong hai so nguyen co dau
# Tham so : $a0 = a, $a1 = b
# Tra ve  : $v0 = max(a, b)
max2:
    move $v0, $a0
    slt  $t0, $a0, $a1
    beq  $t0, $zero, max2_end
    move $v0, $a1
max2_end:
    jr   $ra