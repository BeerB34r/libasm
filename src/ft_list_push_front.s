extern malloc

struc	t_list
	.data:	resq 1
	.next:	resq 1
endstruc

section .text
global ft_list_push_front
%define data [rbp - 8]
%define head [rbp - 16]
ft_list_push_front:
	enter 16, 0
	mov head, rdi
	mov data, rsi
	mov rdi, t_list_size
	call malloc
	cmp rax, 0
	je .exit
	mov rdi, head				; t_list **
	mov rsi, data				; void *
	mov [rax + t_list.data], rsi; new->data = data
	mov rsi, [rdi]				; t_list *
	mov [rax + t_list.next], rsi; new->next = *head
	mov [rdi], rax				; *head = new
.exit:
	leave
	ret
