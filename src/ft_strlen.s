section .text
global ft_strlen
ft_strlen:
	enter 0, 0
	mov rax, -1
	.loop:
		inc rax	; incrementing the accumulator register? crazy
		cmp byte [rdi + rax], 0
		jne .loop
	leave
	ret
