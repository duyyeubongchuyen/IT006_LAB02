.data
ChuoiHello: .asciiz"Xin chao Mars"

.text
li $v0, 4
la $a0, ChuoiHello
syscall


