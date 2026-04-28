; nasm includes
%include "sys.mac.nasm"

; main routine
section .text
global ft_write
ft_write:
	mov rdi, 1
	mov rsi, msg
	mov rdx, msg_len
	mov rax, SYS_WRITE	; sys_write
	syscall
	ret

; consts
section .data
	msg db "work in progress", 0xA, 0
	msg_len equ $ - msg
