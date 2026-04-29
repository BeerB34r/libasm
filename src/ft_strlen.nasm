section .text
global ft_strlen
ft_strlen:
	enter 0, 0
	mov rax, 0
	.start:
		cmp byte [rdi], 0
		jz .end
		inc rdi
		inc rax
		jmp .start
	.end:
	leave
	ret
