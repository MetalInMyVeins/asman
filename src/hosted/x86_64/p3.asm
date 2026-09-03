section .rodata
	fdd db "%d", 0

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

	mov	ebx, 0
	mov	r12d, [rbp - 8]

.loop:
	cmp	ebx, r12d
	jge	.done

	lea	rdi, [rel fdd]
	mov	esi, ebx
	xor	eax, eax
	call	printf

	inc	ebx
	jmp	.loop

.done:
	pop	r12
	pop	rbx
	xor	eax, eax
	leave
	ret
