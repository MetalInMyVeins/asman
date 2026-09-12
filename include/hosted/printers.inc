; %1 = format spec
; %2 = init value
; %3 = < x
; %4 = array (register)
%macro looper_printer_bottomup_less_db2dd 4
	push	rbx
	sub	rsp, 8
	mov	rbx, %2
.looper_printer_bottomup_less_db2dd:
	cmp	rbx, %3
	jge	.looper_printer_bottomup_less_db2dd_end

	lea	rdi, [rel %1]
	movzx	esi, byte [%4 + rbx]
	xor	eax, eax
	call	printf

	inc	rbx
	jmp	.looper_printer_bottomup_less_db2dd
.looper_printer_bottomup_less_db2dd_end:
	add	rsp, 8
	pop	rbx
%endmacro
