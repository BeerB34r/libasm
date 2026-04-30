extern malloc

section .text
global ft_strdup
%define str [rbp - 8] 	; offset for string parameter
%define len [rbp - 16]	; offset for length, so as to not do work twice
ft_strdup:
	enter 16, 0			; put up enough stack space for a ptr + size_t
	mov str, rdi		; store string for later
	mov rcx, 0
	.loop:
		inc rcx
		cmp byte [rdi + rcx - 1], 0
		jne .loop
	mov len, rcx
	mov rdi, rcx
	call malloc
	cmp rax, 0			; malloc failed?
	jz .end
	mov rdi, rax
	mov rsi, str
	mov rcx, len
	rep movsb
.end:
	leave
	ret
