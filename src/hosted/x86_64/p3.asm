section .rodata
	fstrn db "%s", 10, 0

section .data

section .text
	global main
	extern printf

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	mov	[rbp - 4], 0
	mov	[rbp - 8], edi
	mov	[rbp - 16], rsi

	push	rbx
	push	r12
	push	r13
	sub	rsp, 8

	mov	ebx, 1
	mov	r12d, [rbp - 8]
	mov	r13, [rbp - 16]

.loop:
	cmp	ebx, r12d
	jge	.done

	lea	rdi, [rel fstrn]
	mov	rsi, [r13 + 8 * rbx]
	xor	eax, eax
	call	printf

	inc	ebx
	jmp	.loop

.done:
	pop	r13
	pop	r12
	pop	rbx
	xor	eax, eax
	leave
	ret
