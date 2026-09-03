section .rodata
	prompt_equ db "1st pair = 2nd pair", 10, 0
	prompt_less db "1st pair < 2nd pair", 10, 0
	prompt_greater db "1st pair > 2nd pair", 10, 0

section .data

section .text
	global main
	extern printf, atoi

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	mov	[rbp - 4], edi
	mov	[rbp - 12], rsi

	cmp	dword [rbp - 4], 5
	jne	.abort

	push	rbx
	push	r12	; rsp offset = 32
	push	r13
	sub	rsp, 8	; rsp offset = 48

	mov	r13, [rbp - 12]

	mov	rdi, [r13 + 8]
	call	atoi
	mov	ebx, eax

	mov	rdi, [r13 + 8 * 2]
	call	atoi
	add	ebx, eax
	
	mov	rdi, [r13 + 8 * 3]
	call	atoi
	mov	r12d, eax

	mov	rdi, [r13 + 8 * 4]
	call	atoi
	add	r12d, eax

	cmp	ebx, r12d
	je	.equ
	jl	.less
	jg	.greater

.equ:
	lea	rdi, [rel prompt_equ]
	xor	eax, eax
	call	printf
	jmp	.done

.less:
	lea	rdi, [rel prompt_less]
	xor	eax, eax
	call	printf
	jmp	.done

.greater:
	lea	rdi, [rel prompt_greater]
	xor	eax, eax
	call	printf

.done:
	add	rsp, 8
	pop	r13
	pop	r12
	pop	rbx
	xor	eax, eax
	leave
	ret

.abort:
	mov	eax, 1
	leave
	ret
