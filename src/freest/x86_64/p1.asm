section .rodata
	txt db "Hello world", 10, 0
	txt_len equ $ - txt

section .data

section .text
	global _start

_start:
	mov	rax, 1
	mov	edi, 1
	lea	rsi, [rel txt]
	mov	edx, txt_len
	syscall
	mov	rax, 60
	mov	edi, 0
	syscall
