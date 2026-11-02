.text
main:
    li   $t0, 11
    li   $t1, 22
    li   $t2, 33
    addi $sp, $sp, -4
    sw   $t0, 0($sp)       # push 11
    addi $sp, $sp, -4
    sw   $t1, 0($sp)       # push 22
    addi $sp, $sp, -4
    sw   $t2, 0($sp)       # push 33
    lw   $t3, 0($sp)       # pop
    addi $sp, $sp, 4
    lw   $t4, 0($sp)       # pop
    addi $sp, $sp, 4
    lw   $t5, 0($sp)       # pop
    addi $sp, $sp, 4
    li   $v0, 10
    syscall