.data
scores:     .word 2, 10, 4, 5, 9, 1, 3, 9, 2, 5, 0, 10
n_scores:   .word 12
grade_tab:  .byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
            .align 2
hist:       .word 0, 0, 0, 0

str_min:    .asciiz "min="
str_max:    .asciiz " max="
str_g0:     .asciiz "\ng0="
str_g1:     .asciiz " g1="
str_g2:     .asciiz " g2="
str_g3:     .asciiz " g3="
str_nl:     .asciiz "\n"

# Chuoi ca nhan P (k = 10 cap ngoac long nhau hoan toan)
str_P:      .asciiz "([{([{([{( )}])}])}])"

.text
.globl main
main:
    # 1. Goi stats
    la   $a0, scores
    lw   $a1, n_scores
    jal  stats
    move $s0, $v0           # luu min
    move $s1, $v1           # luu max

    # 2. Goi histogram
    la   $a0, scores
    lw   $a1, n_scores
    la   $a2, grade_tab
    la   $a3, hist
    jal  histogram

    # In dong 1: min=<gia tri> max=<gia tri>
    la   $a0, str_min
    li   $v0, 4
    syscall
    move $a0, $s0
    li   $v0, 1
    syscall
    la   $a0, str_max
    li   $v0, 4
    syscall
    move $a0, $s1
    li   $v0, 1
    syscall

    # In dong 2: g0=<so> g1=<so> g2=<so> g3=<so>
    la   $t0, hist
    la   $a0, str_g0
    li   $v0, 4
    syscall
    lw   $a0, 0($t0)
    li   $v0, 1
    syscall

    la   $a0, str_g1
    li   $v0, 4
    syscall
    lw   $a0, 4($t0)
    li   $v0, 1
    syscall

    la   $a0, str_g2
    li   $v0, 4
    syscall
    lw   $a0, 8($t0)
    li   $v0, 1
    syscall

    la   $a0, str_g3
    li   $v0, 4
    syscall
    lw   $a0, 12($t0)
    li   $v0, 1
    syscall

    la   $a0, str_nl
    li   $v0, 4
    syscall

    # 3. Goi draw_hist (Phan mo rong)
    la   $a0, hist
    li   $a1, 4
    jal  draw_hist

    # 4. Goi check_brackets voi chuoi ca nhan P
    la   $a0, str_P
    jal  check_brackets

    li   $v0, 10
    syscall

# ---------------------------------------------------------
# stats: tim gia tri nho nhat va lon nhat cua mang word
# Tham so : $a0 = dia chi mang, $a1 = n (n >= 1)
# Tra ve  : $v0 = min, $v1 = max
# Su dung : $t0, $t1
# ---------------------------------------------------------
stats:
    lw   $v0, 0($a0)
    move $v1, $v0
    addi $a0, $a0, 4
    addi $a1, $a1, -1
stats_loop:
    beq  $a1, $zero, stats_done
    lw   $t0, 0($a0)
    slt  $t1, $t0, $v0
    beq  $t1, $zero, stats_chk_max
    move $v0, $t0
stats_chk_max:
    slt  $t1, $v1, $t0
    beq  $t1, $zero, stats_next
    move $v1, $t0
stats_next:
    addi $a0, $a0, 4
    addi $a1, $a1, -1
    j    stats_loop
stats_done:
    jr   $ra

# ---------------------------------------------------------
# histogram: dem so phan tu thuoc tung nhom xep loai
# Tham so : $a0 = dia chi mang diem, $a1 = n,
#           $a2 = dia chi grade_tab, $a3 = dia chi hist
# Tra ve  : khong
# Su dung : $t0, $t1, $t2, $t3
# ---------------------------------------------------------
histogram:
hist_loop:
    beq  $a1, $zero, hist_done
    lw   $t0, 0($a0)
    add  $t1, $a2, $t0
    lbu  $t1, 0($t1)
    sll  $t1, $t1, 2
    add  $t2, $a3, $t1
    lw   $t3, 0($t2)
    addi $t3, $t3, 1
    sw   $t3, 0($t2)
    addi $a0, $a0, 4
    addi $a1, $a1, -1
    j    hist_loop
hist_done:
    jr   $ra

# ---------------------------------------------------------
# draw_hist: ve bieu do cot ngang pho diem bang ky tu '|'
# Tham so : $a0 = dia chi mang hist, $a1 = so nhom (4)
# Tra ve  : khong
# Su dung : $t0, $t1, $t2, $t3
# ---------------------------------------------------------
draw_hist:
    move $t0, $a0
    move $t1, $a1
    li   $t2, 0
dh_group_loop:
    beq  $t2, $t1, dh_done
    li   $a0, 103           # 'g'
    li   $v0, 11
    syscall
    move $a0, $t2
    li   $v0, 1
    syscall
    li   $a0, 58            # ':'
    li   $v0, 11
    syscall
    li   $a0, 32            # ' '
    li   $v0, 11
    syscall
    lw   $t3, 0($t0)
dh_bar_loop:
    beq  $t3, $zero, dh_next_group
    li   $a0, 124           # '|'
    li   $v0, 11
    syscall
    addi $t3, $t3, -1
    j    dh_bar_loop
dh_next_group:
    li   $a0, 10            # '\n'
    li   $v0, 11
    syscall
    addi $t0, $t0, 4
    addi $t2, $t2, 1
    j    dh_group_loop
dh_done:
    jr   $ra

# ---------------------------------------------------------
# check_brackets: kiem tra cap ngoac can bang bang ngan xep
# Tham so : $a0 = dia chi chuoi .asciiz
# Tra ve  : $v0 = vi tri (hoac 0), $v1 = ma loi (0..3)
# Su dung : $t0, $t1, $t2, $t3, $t9
# ---------------------------------------------------------
check_brackets:
    move $t9, $sp           # luu $sp goc de khoi phuc khi return
    li   $t0, 0             # vi tri ky tu (dem tu 1)
cb_loop:
    lbu  $t1, 0($a0)
    beq  $t1, $zero, cb_end_str
    addi $t0, $t0, 1
    addi $a0, $a0, 1

    li   $t2, 40            # '('
    beq  $t1, $t2, cb_push
    li   $t2, 91            # '['
    beq  $t1, $t2, cb_push
    li   $t2, 123           # '{'
    beq  $t1, $t2, cb_push

    li   $t2, 41            # ')'
    li   $t3, 40            # cap voi '('
    beq  $t1, $t2, cb_close
    li   $t2, 93            # ']'
    li   $t3, 91            # cap voi '['
    beq  $t1, $t2, cb_close
    li   $t2, 125           # '}'
    li   $t3, 123           # cap voi '{'
    beq  $t1, $t2, cb_close

    j    cb_loop

cb_push:
    addi $sp, $sp, -4
    sw   $t1, 0($sp)
    j    cb_loop

cb_close:
    beq  $sp, $t9, cb_err2  # ngan xep rong -> ma loi 2
    lw   $t2, 0($sp)        # pop ngoac mo o dinh
    addi $sp, $sp, 4
    bne  $t2, $t3, cb_err1  # khong cung loai -> ma loi 1
    j    cb_loop

cb_end_str:
    bne  $sp, $t9, cb_err3  # con ngoac mo -> ma loi 3
    li   $v0, 0
    li   $v1, 0
    j    cb_exit

cb_err1:
    move $v0, $t0
    li   $v1, 1
    j    cb_exit

cb_err2:
    move $v0, $t0
    li   $v1, 2
    j    cb_exit

cb_err3:
    addi $v0, $t0, 1
    li   $v1, 3

cb_exit:
    move $sp, $t9           # dam bao can bang $sp tren moi duong thoat
    jr   $ra