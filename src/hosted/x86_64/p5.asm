section .rodata

section .data

section .text
	global main
	extern printf

main:
	push	rbp
	mov	rbp, rsp

	xor	eax, eax
	leave
	ret
