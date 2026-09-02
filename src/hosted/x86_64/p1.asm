section .rodata
	; string literals go in the read-only data section.
	; 10 is the newline character in ascii while 0 is the NUL character.
	txt db "Hello world", 10, 0

section .data

section .text
	; to make the main symbol visible to linker.
	global main
	; for using printf from libc.
	extern printf

main:
	; function prologue.
	; basically it first pushes the base pointer on the stack to save its previous value.
	; where did the previous value come from? from _start, which is defined in the runtime provided by libc.
	; it is _start which calls main.
	; then the value of stack pointer is stored in rbp register.
	; so from that point on, rbp acts as the base of the current stack frame.
	; rsp denotes the top of the stack.
	push	rbp
	mov	rbp, rsp
	; rsp is decremented by 16 bytes to conform to the SysV ABI requirement of stack frame
	; being 16 bytes aligned before any call instruction.
	; 128 bytes below rsp is called red zone which can be used as temporary storage.
	; but they're guaranteed to be clobbered if a call instruction executes before moving rsp down.
	sub	rsp, 16

	; SysV calling convention.
	lea	rdi, [rel txt]
	; printf is a variadic function.
	; floating point arguments pass in specialized registers. but printf has no way to tell beforehand
	; how many floating point arguments are passed. to denote this number, al is used.
	; setting eax to 0 zero-extends and sets the entire rax to 0 which means no floating point
	; arguments are being passed.
	xor	eax, eax
	call	printf

	; setting all 32 bits of eax to zero which zero extends and makes the entire rax 0.
	; this is basically setting return code to 0 by setting eax to by convention.
	; but note that in this specific case, this is unneeded because we had already
	; set eax to 0 before calling printf.
	xor	eax, eax
	; it does two things.
	; first it moves the value of rbp to rsp.
	; then it pops the saved rbp from stack and stores in itself.
	; so basically after this instruction, rsp and rbp both are back where they started.
	leave
	; resumes execution to the return address of caller.
	ret
