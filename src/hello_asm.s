section .text
global hello_asm
hello_asm:
	mov rdi, 1
	mov rsi, msg
	mov rdx, msg_len
	mov rax, 1
	syscall
	ret

section .data
	msg db "Hello, assembler!", 0xA, 0
	msg_len equ $ - msg
