struc	t_list
	.data:	resq 1
	.next:	resq 1
endstruc

section .text
global ft_list_size
ft_list_size:
	enter 0,0
	mov rax, 0
	.loop:
		cmp rdi, 0
		je .exit
		mov rdi, [rdi + t_list.next]
		inc rax
		jmp .loop
.exit:
	leave
	ret
