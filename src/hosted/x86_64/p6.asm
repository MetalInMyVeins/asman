; the target is to take a string from stdin, reverse it
; and print the reversed string.
; it's not specified whether to store the reversed string
; or not. but we'd go the hard way.
; we'd create a 256 bytes buffer, store the temporary string
; there calling fgets.
; we'd validate the fgets return address and store in stack
; if valid, otherwise abort.
; we'd call strlen on fgets return address and calculate the
; string length.
; we'd run a reverse loop on the stored string and print it.
; that's all.

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
	; create 256 bytes stack buffer
	; 256 = 16 * 16, so 16 bytes aligned
	sub	rsp, 256

	; fgets
	; $1 = char s[size]
	; $2 = int size
	; $3 = FILE *stream
	lea	rdi, [rbp - 256]
	mov	esi, 256
	mov	rdx, [rel stdin]
	call	fgets

	; at this point, rax contains the pointer returned
	; by fgets. store it in a dedicated register.
	push	rbx
	push	r12		; rsp offset = 256 + 16 = 272
	mov	rbx, rax
	
	; fgets might return a nulltr, do a check
	cmp	rbx, 0
	jne	.fgets_not_failed

.fgets_failed:
	lea	rdi, [rel prompt_fgetsfailed]
	xor	eax, eax
	call	printf
	jmp	.done

.fgets_not_failed:
	; allocate more stack space.
	sub	rsp, 16		; rsp offset = 272 + 16 = 288

	; call strlen to calculate the length of the return
	; string.
	mov	rdi, rbx
	call	strlen
	; store the length in newly allocated stack space.
	mov	[rbp - 280], rax
	; strlen might return 0 if string length is 0.
	; in that case, no point in continuing.
	cmp	[rbp - 280], 0
	je	.unallocate_stack_regs

	; depending on the length of input, the returned string
	; might contain newlines as well. we'll print the bytes
	; in reverse order and at the end, we'd add the newline.
	; we'd run a reverse loop where r12 would be the index.
	; store strlen value in r12 and decrement by 1 to match
	; array index.
	mov	r12, [rbp - 280]
	dec	r12
	
	; now we have to check if we have newline as the last
	; character of the return string. if newline exists, we
	; have to decrement r12 by 1 again.
	; so at this point, the last newline possible byte is:
	; rbx[r12]
	; calculate it and store in a byte.
	mov	al, [rbx + r12]
	; check if it's a newline, decrement 1 if so.
	cmp	al, 10
	je	.if_newl
	jmp	.ifnot_newl

.if_newl:
	dec	r12

.ifnot_newl:

.loop1: ; idx = r12, cond = qword [rbp - 280]
	cmp	r12, -1
	je	.loop1_end

	lea	rdi, [rel fmt_c]
	movzx	esi, byte [rbx + r12]
	xor	eax, eax
	call	printf

	dec	r12
	jmp	.loop1

.loop1_end:
	; print the newline whatever.
	lea	rdi, [rel fmt_c]
	mov	esi, 10
	xor	eax, eax
	call	printf

.unallocate_stack_regs:
	pop	r12
	pop	rbx
	jmp	.done

.done:
	xor	eax, eax
	leave
	ret
