section .text
	global main

main:
	push	rbp
	mov	rbp, rsp

	xor	eax, eax
	leave
	ret
