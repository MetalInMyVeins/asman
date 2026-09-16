; the target is to concatenate two strings and store it then
; print it. one string has to be accepted from stdin, and
; another from command line arguments.
%include "hosted/fmt.inc"
%include "hosted/printer.inc"

section .rodata
	abort1 db "No arguments provided. ABORT.", 10, 0
	abort2 db "fgets failed. ABORT.", 10, 0
	abort3 db "malloc failed. ABORT.", 10, 0

section .data

section .text
	global main
	extern fgets
	extern malloc, free
	extern printf
	extern stdin
	extern strlen

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	; as the command line string, we'd take the first
	; argument provided after executable path. so it's
	; basically just argv[1], and we can hardcode it.
	mov	eax, edi
	cmp	eax, 2
	jl	.done_abort1

	mov	rax, rsi
	add	rax, 8
	mov	[rbp - 8], rax
	; [rbp - 8]: 8B: stores pointer to command line
	; argument.
	
	push	rbx
	push	r12		; RSP => 16 + 16 = 32
	sub	rsp, 16		; RSP => 32 + 16 = 48
	; buffer range: 32 - 48: 16B
	
	lea	rdi, [rbp - 48]
	mov	esi, 16
	mov	rdx, [rel stdin]
	call	fgets
	mov	[rbp - 16], rax
	; [rbp - 16]: 8B: stores pointer to string returned
	; by fgets.
 
	; abort if fgets returned nullptr.
	cmp	[rbp - 16], 0
	je	.done_abort2
	
	sub	rsp, 32		; RSP => 48 + 32 = 80
	; range: 48 - 80: 32B

	; calculate length of each strings. both are NUL terminated.
	mov	rdi, [rbp - 8]
	mov	rdi, [rdi]
	call	strlen
	mov	rbx, rax
	mov	[rbp - 56], rax
	; [rbp - 56] = length of [rbp - 8]

	mov	rdi, [rbp - 16]
	call	strlen
	add	rbx, rax
	mov	[rbp - 64], rax
	; [rbp - 64] = length of [rbp - 16]
	mov	[rbp - 72], rbx
	; [rbp - 72] = lenght of [rbp - 8] + [rbp - 16]

	mov	rdi, [rbp - 72]
	inc	rdi
	call	malloc
	mov	[rbp - 80], rax
	; [rbp - 80] = malloc'd address
	cmp	[rbp - 80], 0
	je	.done_abort3
	
	push	r13
	push	r14		; RSP => 80 + 16 = 96
	xor	rbx, rbx
	xor	r12, r12
	xor	r13, r13
	xor	r14, r14

	; FREE REGS: rbx, r12, r13, r14
	mov	rax, [rbp - 80]
	mov	r12, [rbp - 8]
	mov	r12, [r12]
.loop1:
	cmp	rbx, [rbp - 56]
	je	.loop1_end

	mov	r13b, [r12 + rbx]
	mov	[rax + rbx], r13b
	inc	rbx
	jmp	.loop1

.loop1_end:
	mov	rax, [rbp - 80]
	mov	r12, [rbp - 16]
	xor	r13, r13

.loop2:
	cmp	r13, [rbp - 64]
	je	.loop2_end

	mov	r14b, [r12 + r13]
	mov	[rax + rbx], r14b
	inc	rbx
	inc	r13
	jmp	.loop2

.loop2_end:
	mov	[rax + rbx], 0
	printer fmt_s, [rbp - 80]

	mov	rdi, [rbp - 80]
	call	free

	jmp	.unalloc_all_stack_regs

.done_abort1:
	lea	rax, [rel abort1]
	printer fmt_s_nl, rax
	jmp	.done

.done_abort2:
	lea	rax, [rel abort2]
	printer fmt_s_nl, rax
	pop	r12
	pop	rbx
	jmp	.done

.done_abort3:
	lea	rax, [rel abort3]
	printer fmt_s_nl, rax
	pop	r12
	pop	rbx
	jmp	.done

.unalloc_all_stack_regs:
	pop	r14
	pop	r13
	pop	r12
	pop	rbx
	jmp	.done

.done:
	xor	eax, eax
	leave
	ret
