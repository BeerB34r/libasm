%include "sys.mac.nasm"

section .text
global hello_asm
hello_asm:
	sys_write 1, msg, msg_len
	ret

section .data
	msg db "Hello, assembler!", 0xA, 0
	msg_len equ $ - msg
