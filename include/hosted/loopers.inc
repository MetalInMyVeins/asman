; MACRO_LOOPERS_1
; %1 = format spec
; %2 = init value
; %3 = comparison instruction
; %4 = compare with x
; %5 = array (register)
%macro looper_printer_bottomup_db2dd 5
	push	rbx
	sub	rsp, 8
	mov	rbx, %2
.looper_printer_bottomup_db2dd:
	cmp	rbx, %4
	%3	.looper_printer_bottomup_db2dd_end

	lea	rdi, [rel %1]
	movzx	esi, byte [%5 + rbx]
	xor	eax, eax
	call	printf

	inc	rbx
	jmp	.looper_printer_bottomup_db2dd
.looper_printer_bottomup_db2dd_end:
	add	rsp, 8
	pop	rbx
%endmacro

