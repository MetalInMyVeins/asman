; formats
section .rodata
	fmt_d db "%d", 0
	fmt_ld db "%ld", 0
	fmt_c db "%c", 0

; prompts
section .rodata
	prompt_fgetsfailed db "fgets failed", 10, 0

section .data

section .text
	global main
	extern printf
	extern fgets, strlen
	extern stdin

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

.done:
	xor	eax, eax
	leave
	ret
