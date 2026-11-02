.data
w1:   .word 0
.text
main:
    move $a0, $sp
    li   $v0, 34
    syscall
    li   $a0, 10
    li   $v0, 11
    syscall
    la   $a0, w1
    li   $v0, 34
    syscall
    li   $v0, 10
    syscall