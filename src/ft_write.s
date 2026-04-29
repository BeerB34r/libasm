; nasm includes
%include "sys.mac"

extern __errno_location

; main routine
section .text
global ft_write
ft_write:
		enter 0, 0	; save stack frame
		mov rax, SYS_WRITE
		syscall
		mov rdi, rax
		call __errno_location
		cmp rdi, 0
		jge .ok
		.err:
			neg rdi
			mov [rax], rdi
			mov rax, -1
			jmp .exit
		.ok:
			mov word [rax], 0
			mov rax, rdi
		.exit:
			leave		; restore stack frame
			ret
