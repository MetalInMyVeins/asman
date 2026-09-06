; the problem is to take one string from stdin, and another from
; argv, concatenate them, store them, and print them.

; formats
section .rodata
	fmt_d db "%d", 0
	fmt_ld db "%ld", 0
	fmt_c db "%c", 0
	fmt_str db "%s", 0
	fmt_strn db "%s", 10, 0

; prompts
section .rodata
	prompt_fgetsfailed db "fgets failed", 10, 0
	prompt_strlen_zero db "String length = 0", 10, "Abort", 10, 0
	prompt_mallocfailed db "malloc failed", 10, 0

section .data

section .text
	global main
	extern printf
	extern fgets, strlen
	extern stdin
	extern malloc, free

main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16

	push	rbx
	push	r12			; RSP => 16 + 16 = 32

	; we'd store one string in [rbp - 8] and another in [rbp - 16].
	; first we'd take from argv. we consider only the first
	; argument as the provided string so the index for accession
	; can be hardcoded.
	mov	[rbp - 8], rsi
	mov	rax, [rbp - 8]
	mov	rbx, [rax + 8]
	mov	[rbp - 16], rbx

	; the program shouldn't continue if input string length is zero.
	; so do a check.
	cmp	[rbp - 16], 0
	je	.strlen_zero

	; at this point, [rbp - 16] contains the string from argv.
	; now we'd take a string from stdin and store in [rbp - 8].
	; we'd use fgets.
	; $1 = const char *buf
	; $2 = int size
	; $3 = FILE *stream
	; create the 256 bytes buffer first.
	sub	rsp, 256		; RSP => 32 + 256 = 288
	; VALID LOCAL STACK RANGE: 32 - 288
	; USAGE: buffer allocation
	lea	rdi, [rbp - 256]
	mov	esi, 256
	mov	rdx, [rel stdin]
	call	fgets
	; store the pointer in [rbp - 8].
	mov	[rbp - 8], rax

	; abort if fgets failed.
	cmp	[rbp - 8], 0
	je	.fgets_failed

	; we have to handle another case. the argv string is devoid of
	; any newline character. if in range, fgets string contains
	; newline by design. we have to get rid of that too. in stdin,
	; if user presses only enter, newline is considered the input
	; string. we have to handle that case as well.
	; call strlen and determine length.
	mov	rdi, [rbp - 8]
	call	strlen

	; rax being 1 means it's only the newline. abort if so.
	; otherwise just decrement 1 to keep track of the newline-less
	; index range.
	cmp	rax, 1
	je	.strlen_zero
	dec	rax

	; FREE REGISTERS => RBX, R12
	; RSP => 288
	sub	rsp, 32			; RSP => 288 + 32 = 320
	; VALID LOCAL STACK RANGE: 288 - 320

	; now we have two valid strings in:
	; [rbp - 8]
	; [rbp - 16]
	; the new concatenated string would be placed at [rbp - 320].
	; at this point, rax contains the length of string in [rbp - 8].
	; calculate strlen of [rbp - 16] and store each one on stack.
	; store stdin string length in [rbp - 296].
	; store argv string length in [rbp - 304].
	mov	[rbp - 296], rax
	mov	rdi, [rbp - 16]
	call	strlen
	mov	[rbp - 304], rax
	; store the combined length on [rbp - 312].
	mov	rax, [rbp - 296]
	add	rax, [rbp - 304]
	mov	[rbp - 312], rax

	; combined string length is now stored in [rbp - 312].
	; we have to malloc the required amount of bytes to store the
	; concatenated string. malloc one extra byte for storing NUL
	; byte.
	mov	rdi, [rbp - 312]
	inc	rdi
	call	malloc
	mov	[rbp - 320], rax

	; check if malloc failed
	cmp	[rbp - 320], 0
	je	.malloc_failed
	
	; STATE REPORT:
	; [rbp - 320] => malloc'd pointer
	; [rbp - 312] => combined length of string
	; [rbp - 296] => stdin string length
	; [rbp - 304] => argv string length
	; [rbp - 8] => stdin string
	; [rbp - 16] => argv string
	; RBX => master index
	; get it to 0 and loop over the two strings.
	mov	rbx, 0
	mov	rax, [rbp - 8]
	push	r13
	push	r14			; RSP => 320 + 16 = 336

	; FREE REGISTERS => R12, R13, R14
	mov	r12, [rbp - 8]
	mov	r13, [rbp - 320]
.string1:
	cmp	rbx, [rbp - 296]
	je	.string1_end

	mov	al, [r12 + rbx]
	mov	[r13 + rbx], al
	inc	rbx
	jmp	.string1

.string1_end:
	mov	r14, rbx
	mov	rbx, 0
	mov	r12, [rbp - 16]

.string2:
	cmp	rbx, [rbp - 304]
	je	.string2_end
	
	mov	al, [r12 + rbx]
	mov	[r13 + r14], al
	inc	rbx
	inc	r14
	jmp	.string2

.string2_end:
	mov	[r13 + r14], 0

	lea	rdi, [rel fmt_strn]
	mov	rsi, r13
	xor	eax, eax
	call	printf

	jmp	.unalloc_stack_regs

.strlen_zero:
	lea	rdi, [rel prompt_strlen_zero]
	xor	eax, eax
	call	printf
	jmp	.unalloc_stack_regs

.fgets_failed:
	lea	rdi, [rel prompt_fgetsfailed]
	xor	eax, eax
	call	printf
	jmp	.unalloc_stack_regs

.malloc_failed:
	lea	rdi, [rel prompt_mallocfailed]
	xor	eax, eax
	call	printf
	jmp	.unalloc_stack_regs

.unalloc_stack_regs:
	pop	r14
	pop	r13
	pop	r12
	pop	rbx
	jmp	.done

.done:
	xor	eax, eax
	leave
	ret
