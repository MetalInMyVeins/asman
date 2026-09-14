; MACRO_PRINTERS_1
%macro printer_dd 1
section .text
	lea	rdi, [rel fmt_dd]
	mov	esi, %1
	xor	eax, eax
	call	printf
%endmacro

; MACRO_PRINTERS_2
%macro printer_ld 1
section .text
	lea	rdi, [rel fmt_ld]
	mov	rsi, %1
	xor	eax, eax
	call	printf
%endmacro

; MACRO_PRINTERS_3
%macro printer_c 1
section .text
	lea	rdi, [rel fmt_c]
	mov	sil, %1
	xor	eax, eax
	call	printf
%endmacro

; MACRO_PRINTERS_4
%macro printer_str 1
section .text
	lea	rdi, [rel fmt_str]
	mov	rsi, %1
	xor	eax, eax
	call	printf
%endmacro

; MACRO_PRINTERS_5
%macro printer_strn 1
section .text
	lea	rdi, [rel fmt_strn]
	mov	rsi, %1
	xor	eax, eax
	call	printf
%endmacro
