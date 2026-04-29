section .text
global ft_strcpy
ft_strcpy:
	enter 0, 0
	mov rax, rdi
	mov rcx, 0
	.loop:
		inc rcx
		cmp byte [rsi + rcx], 0
		jne .loop
	rep movsb
	leave
	ret
