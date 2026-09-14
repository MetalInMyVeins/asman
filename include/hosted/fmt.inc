%ifndef HOSTED_FMT_INC
%define HOSTED_FMT_INC

section .rodata
	fmt_hd db "%hd", 0
	fmt_hu db "%hu", 0
	fmt_d db "%d", 0
	fmt_u db "%u", 0
	fmt_ld db "%ld", 0
	fmt_f db "%f", 0
	fmt_lf db "%lf", 0
	fmt_Lf db "%Lf", 0
	fmt_c db "%c", 0
	fmt_s db "%s", 0
	fmt_p db "%p", 0
	fmt_hd_nl db "%hd", 10, 0
	fmt_hu_nl db "%hu", 10, 0
	fmt_d_nl db "%d", 10, 0
	fmt_u_nl db "%u", 10, 0
	fmt_ld_nl db "%ld", 10, 0
	fmt_f_nl db "%f", 10, 0
	fmt_lf_nl db "%lf", 10, 0
	fmt_Lf_nl db "%Lf", 10, 0
	fmt_c_nl db "%c", 10, 0
	fmt_s_nl db "%s", 10, 0
	fmt_hd_spc db "%hd ", 0
	fmt_hu_spc db "%hu ", 0
	fmt_d_spc db "%d ", 0
	fmt_u_spc db "%u ", 0
	fmt_ld_spc db "%ld ", 0
	fmt_f_spc db "%f ", 0
	fmt_lf_spc db "%lf ", 0
	fmt_Lf_spc db "%Lf ", 0
	fmt_c_spc db "%c ", 0
	fmt_s_spc db "%s ", 0

%endif ; HOSTED_FMT_INC
