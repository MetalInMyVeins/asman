section .text
	global _start

_start:
	mov	rax, 60
	mov	edi, 0
	syscall
