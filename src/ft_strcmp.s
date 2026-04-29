section .text
global ft_strcmp
ft_strcmp:
	enter 0, 0
	.loop:
		mov al, [rdi]	; al => lowest byte of rax
		mov cl, [rsi]	; cl => lowest byte of rcx
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
