# Chuong trinh: Tinh tien dien
# Bang thanh ghi $s:
#   $s0: So kWh dien nang tieu thu (x)
#   $s1: Tong tien dien tich luy
#   $s2: Can duoi cua bac hien tai (kWh, khoi tao = 0)
#   $s3: Con tro don_gia
#   $s4: Con tro muc_bac

        .data
don_gia:    .word 1740, 1800, 2090, 2640, 2990, 3140
muc_bac:    .word 50, 100, 200, 300, 400, 9999
msg_nhap:   .asciiz "Nhap so kWh (0..9999): "
msg_loi:    .asciiz "Gia tri khong hop le, nhap lai.\n"
msg_kq1:    .asciiz "Tien dien: "
msg_kq2:    .asciiz " dong\n"

        .text
        .globl main
main:
nhap_lai:
        la      $a0, msg_nhap           # In loi nhac nhap
        li      $v0, 4
        syscall

        li      $v0, 5                  # Doc so nguyen co dau x
        syscall
        move    $s0, $v0                # Luu x vao $s0

        sltiu   $t0, $s0, 10000         # Kiem tra mien 0 <= x <= 9999 bang 1 lenh so sanh
        bne     $t0, $zero, khoi_tao    # Neu hop le ($t0 == 1) thi chuyen sang tinh toan

        la      $a0, msg_loi            # Neu khong hop le, in thong bao loi
        li      $v0, 4
        syscall
        j       nhap_lai

khoi_tao:
        li      $s1, 0                  # Tong tien = 0
        li      $s2, 0                  # Can duoi ban dau = 0
        la      $s3, don_gia            # Con tro mang don gia
        la      $s4, muc_bac            # Con tro mang nguong bac

vong_lap:
        lw      $t0, 0($s4)             # $t0 = nguong tren cua bac hien tai
        lw      $t1, 0($s3)             # $t1 = don gia cua bac hien tai
        slt     $t2, $t0, $s0           # $t2 = 1 neu nguong < x (x vuot qua bac nay)
        beq     $t2, $zero, bac_cuoi    # Neu x <= nguong thi xu ly bac cuoi

        subu    $t3, $t0, $s2           # So kWh tinh tron trong bac = nguong - can_duoi
        mul     $t4, $t3, $t1           # Tien cua bac = so_kWh * don_gia
        addu    $s1, $s1, $t4           # Cong don vao tong tien
        move    $s2, $t0                # Cap nhat can_duoi = nguong hien tai
        addiu   $s3, $s3, 4             # Tang con tro don_gia sang bac tiep theo
        addiu   $s4, $s4, 4             # Tang con tro muc_bac sang bac tiep theo
        j       vong_lap

bac_cuoi:
        subu    $t3, $s0, $s2           # So kWh con lai = x - can_duoi
        mul     $t4, $t3, $t1           # Tien o bac cuoi = so_kWh_con_lai * don_gia
        addu    $s1, $s1, $t4           # Cong vao tong tien

in_ket_qua:
        la      $a0, msg_kq1            # In "Tien dien: "
        li      $v0, 4
        syscall

        move    $a0, $s1                # In tong so tien
        li      $v0, 1
        syscall

        la      $a0, msg_kq2            # In " dong\n"
        li      $v0, 4
        syscall

        li      $v0, 10                 # Ket thuc chuong trinh
        syscall