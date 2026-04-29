section .text
global ft_strcmp
ft_strcmp:
	enter 0, 0
	.loop:
		movsx rax, byte [rdi] ; mov + Sign Xtension
		movsx rcx, byte [rsi]
		sub rax, rcx
		jnz .end
		cmp byte [rdi], 0
		jz .equal
		inc rdi
		inc rsi
		jmp .loop
	.equal:
		mov rax, 0
	.end:
	leave
	ret
