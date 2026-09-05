section .rodata

section .data

section .text
	global main
	extern printf, scanf

main:
	push	rbp
	mov	rbp, rsp

.done:
	xor	eax, eax
	leave
	ret
