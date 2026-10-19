
.data
# Cao do goc cua 15 not Ode to Joy
pitches:     .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62

# Do dai cua tung not, tinh theo don vi nhip
durations:   .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4

note_count:  .word 15

# 0 = A: syscall 33
# 1 = B: syscall 31
# 2 = C: syscall 31 + syscall 32
mode:        .word 2

space:       .asciiz " "
newline:     .asciiz "\n"
expected_msg:.asciiz "Tong du kien (ms): "
measured_msg:.asciiz "\nThoi gian do duoc (ms): "

.text
.globl main

main:
    la   $s0, pitches
    la   $s1, durations
    lw   $s2, note_count

    li   $s3, 0              # Chi so not i
    li   $s4, 0              # Tong thoi luong du kien
    li   $s7, 180            # 1 don vi nhip = 180 ms
    lw   $s6, mode           # Che do phat

    # Lay thoi diem bat dau
    li   $v0, 30
    syscall
    move $s5, $a0            # Luu 32 bit thap cua thoi gian

play_loop:
    # Neu i >= note_count thi ket thuc vong lap
    slt  $t0, $s3, $s2
    beq  $t0, $zero, finish

    # Dia chi pitches[i] = base + i * 4
    sll  $t1, $s3, 2
    addu $t2, $s0, $t1
    lw   $t3, 0($t2)

    # Cao do thuc = cao do goc + a = cao do goc + 7
    addiu $t3, $t3, 7

    # Doc durations[i]
    addu $t2, $s1, $t1
    lw   $t4, 0($t2)

    # Thoi luong ms = don vi nhip * 180
    mul  $t5, $t4, $s7

    # Cong don tong thoi luong du kien
    addu $s4, $s4, $t5

    # In: cao_do ms
    move $a0, $t3
    li   $v0, 1
    syscall

    la   $a0, space
    li   $v0, 4
    syscall

    move $a0, $t5
    li   $v0, 1
    syscall

    la   $a0, newline
    li   $v0, 4
    syscall

    # Tham so MIDI: pitch, duration, instrument, volume
    move $a0, $t3
    move $a1, $t5
    li   $a2, 73
    li   $a3, 100

    # Mode 0: syscall 33, cho not phat xong
    beq  $s6, $zero, play_33

    # Mode 1 hoac 2: bat dau phat khong dong bo bang syscall 31
    li   $v0, 31
    syscall

    # Chi mode 2 moi cho them bang syscall 32
    li   $t7, 2
    beq  $s6, $t7, wait_32

    j    next_note

play_33:
    li   $v0, 33
    syscall
    j    next_note

wait_32:
    move $a0, $t5            # So ms can cho
    li   $v0, 32
    syscall

next_note:
    addiu $s3, $s3, 1
    j    play_loop

finish:
    # Lay thoi diem ket thuc
    li   $v0, 30
    syscall

    # Thoi gian do = ket thuc - bat dau
    subu $t2, $a0, $s5

    # In tong du kien
    la   $a0, expected_msg
    li   $v0, 4
    syscall

    move $a0, $s4
    li   $v0, 1
    syscall

    # In thoi gian do duoc
    la   $a0, measured_msg
    li   $v0, 4
    syscall

    move $a0, $t2
    li   $v0, 1
    syscall

    li   $v0, 10
    syscall
