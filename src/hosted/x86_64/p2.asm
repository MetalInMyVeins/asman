section .rodata
	fdd db "%d", 0
	prompt1 db "z = %d", 10, 0
	prompt2 db "x: ", 0
	prompt3 db "y: ", 0
	prompt_less db "x + y < z", 10, 0
	prompt_greater db "x + y > z", 10, 0
	prompt_equ db "x + y = z", 10, 0

section .data
	z dd 67

section .text
	global main
	extern printf, scanf

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	lea	rdi, [rel prompt1]
	mov	esi, [rel z]
	xor	eax, eax
	call	printf

	lea	rdi, [rel prompt2]
	call	printf

	lea	rdi, [rel fdd]
	lea	rsi, [rbp - 4]
	call	scanf
	
	lea	rdi, [rel prompt3]
	call	printf

	lea	rdi, [rel fdd]
	lea	rsi, [rbp - 8]
	call	scanf

	mov	eax, [rbp - 4]
	add	eax, [rbp - 8]

	cmp	eax, [rel z]
	jl	.less
	jg	.greater
	jmp	.equ

.less:
	lea	rdi, [rel prompt_less]
	call	printf
	jmp	.done

.greater:
	lea	rdi, [rel prompt_greater]
	call	printf
	jmp	.done

.equ:
	lea	rdi, [rel prompt_equ]
	call	printf

.done:
	xor	eax, eax
	leave
	ret
