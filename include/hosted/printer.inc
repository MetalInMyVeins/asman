%macro printer 2
section .text
	lea	rdi, [rel %1]
	mov	rsi, %2
	xor	eax, eax
	call	printf
%endmacro
