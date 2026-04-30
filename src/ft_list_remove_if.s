extern free

%macro pop_current 0
	mov rdi, prev
	mov rsi, current
	mov rax, [rsi + t_list.next]
	mov [rdi + t_list.next], rax
	mov rsi, [rdi + t_list.next]
	mov rdi, current
	mov current, rsi
	call free
%endmacro
%macro should_pop 0
	mov rdi, current
	mov rdi, [rdi] ; get to the data
	mov rsi, ref
	call cfn
	cmp rax, 0
%endmacro
struc	t_list
	.data:	resq 1
	.next:	resq 1
endstruc
section .text
global ft_list_remove_if
ft_list_remove_if:
%define head [rbp - 8]
%define ref [rbp - 16]
%define cfn [rbp - 24]
%define ffn [rbp - 32]
%define prev [rbp - 40]
%define current [rbp - 48]
	enter 48, 0
	;	input validation
	cmp rdi, 0	; head
	je .exit
	cmp rdx, 0	; cmp()
	je .exit
	cmp rcx, 0	; free_fct()
	je .exit
	;	shovel onto the stack
	sub rdi, t_list.next	; OFFSETS BABY
	mov head, rdi
	mov prev, rdi
	mov ref, rsi
	mov cfn, rdx
	mov ffn, rcx
	;	start da loop cronk
	.loop:
		mov rax, prev
		mov rdi, [rax + t_list.next]
		mov current, rdi
		cmp rdi, 0
		je .exit
		should_pop
		jne .no_pop
		mov rdi, current
		mov rdi, [rdi]
		call ffn
		pop_current
		jmp .loop
		.no_pop:
			mov rax, current
			mov prev, rax
		jmp .loop
.exit:
	leave
	ret
