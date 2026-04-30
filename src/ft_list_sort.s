
; 1 rcx, 2 rdi, 3 rsi
; 1->2->3 => 1->3->2
%macro swap 0
	mov rdx, [rsi + t_list.next]
	mov [rdi + t_list.next], rdx
	mov [rsi + t_list.next], rdi
	mov [rcx + t_list.next], rsi
	mov rax, rsi
%endmacro
%macro swap_if 0
	mov current, rsi
	mov prev, rdi
	mov prevprev, rcx
	mov rsi, [rsi]		;get to the data
	mov rdi, [rdi]		;get to the data
	call fn
	mov rsi, current
	mov rdi, prev
	mov rcx, prevprev
	cmp rax, 0
	jle %%no_swap
	swap
	jmp %%done
	%%no_swap:
		mov rax, 0
	%%done:
%endmacro

%macro shift 0
	mov rcx, rdi
	mov rdi, rsi
	mov rsi, [rsi + t_list.next]
%endmacro

struc	t_list
	.data:	resq 1
	.next:	resq 1
endstruc
section .text
global ft_list_sort
ft_list_sort:
%define head [rbp - 8]
%define fn [rbp - 16]
%define prevprev [rbp - 24]
%define prev [rbp - 32]
%define current [rbp - 40]
%define did_sort [rbp - 41]
	enter 41,0
	cmp dword [rdi], 0
	je .exit			; no elements, nothing to sort
	cmp dword [rsi], 0
	je .exit			; no function, cannot sort
	sub rdi, t_list.next; offset so **t_node looks like a regular node
	mov head, rdi		; store head
	mov fn, rsi			; store comparison function
	mov byte did_sort, 0
	mov rdi, [rdi + t_list.next]; deref head
	mov rsi, [rdi + t_list.next]
	cmp rsi, 0
	je .exit			; one element, nothing to sort
	mov rcx, head
	.outer:
		.inner:
			swap_if
			cmp rax, 0
			je .no_swap
			mov byte did_sort, 1
			.no_swap:
			shift
			cmp rsi, 0
			jne .inner
		cmp byte did_sort, 0
		je .exit
		mov byte did_sort, 0
		mov rcx, head
		mov rdi, [rcx + t_list.next]
		mov rsi, [rdi + t_list.next]
		jmp .inner

.exit:
	leave
	ret
