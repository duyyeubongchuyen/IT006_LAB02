.data
w1:  .word 0x8A7B6C5D
b1:  .byte 0x80, 0x7F, 0xFF
     .align 2
w2:  .word 1
s1:  .asciiz "IT012"
.text
main:
    la   $s0, w1
    lw   $t0, 0($s0)      # (a)
    lb   $t0, 0($s0)      # (b)
    lb   $t0, 3($s0)      # (c)
    lbu  $t0, 3($s0)      # (d)
    lb   $t0, 4($s0)      # (e)
    lbu  $t0, 4($s0)      # (f)
    lw   $t0, 4($s0)      # (g)
    li   $t1, 0xAB
    sb   $t1, 1($s0)      # (h)
    lw   $t0, 0($s0)      # (i)
    lw   $t0, 1($s0)
    li   $v0, 10
    syscall