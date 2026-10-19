	.data
msg:	.asciiz "Ket qua: "
	.text
main:	li $t0, 25
	li $t1,70000
	add $t2, $t0, $t1
	blt $t0, $t1, small
	li $t2, 0
small:	la $a0, msg
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	li $v0, 10
	syscall