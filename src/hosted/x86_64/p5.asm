section .rodata
	fmt_dd db "%d", 0
	fmt_ddn db "%d", 10, 0
	fmt_ddspc db "%d ", 0
	prompt1 db "Length: ", 0
	prompt2 db "Enter %d integers:", 10, 0
	prompt3 db "Doubled integers:", 10, 0
	ro_newline db 10, 0

section .data
	align 4
	size_int32 dd 4

section .text
	global main
	extern printf, scanf
	extern malloc, free

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	lea	rdi, [rel prompt1]
	xor	eax, eax
	call	printf

	lea	rdi, [rel fmt_dd]
	lea	rsi, [rbp - 4]
	xor	eax, eax
	call	scanf

	lea	rdi, [rel prompt2]
	mov	esi, [rbp - 4]
	xor	eax, eax
	call	printf

	mov	edi, [rbp - 4]
	imul	edi, size_int32
	call	malloc

	mov	[rbp - 12], rax

	push	rbx
	push	r12

	mov	rbx, [rbp - 12]
	mov	r12d, 0

.loop_inp:
	cmp	r12d, [rbp - 4]
	jge	.loop_inp_end

	lea	rdi, [rel fmt_dd]
	lea	rsi, [rbp - 16]
	xor	eax, eax
	call	scanf

	mov	eax, [rbp - 16]
	imul	eax, 2
	mov	[rbx + 4 * r12], eax

	inc	r12d
	jmp	.loop_inp

.loop_inp_end:
	cmp	r12d, 0
	je	.done
	mov	r12d, 0

	lea	rdi, [rel prompt3]
	xor	eax, eax
	call	printf

.loop_prt:
	cmp	r12d, [rbp - 4]
	jge	.loop_prt_end

	lea	rdi, [rel fmt_ddspc]
	mov	esi, [rbx + 4 * r12]
	xor	eax, eax
	call	printf

	inc	r12d
	jmp	.loop_prt

.loop_prt_end:
	lea	rdi, [rel ro_newline]
	xor	eax, eax
	call	printf

	mov	rdi, [rbp - 12]
	call	free

.done:
	pop	r12
	pop	rbx
	xor	eax, eax
	leave
	ret
