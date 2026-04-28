; nasm includes
%include "sys.mac.nasm"

; main routine
section .text
global ft_write
ft_write:
	enter 0, 0			; save stack frame
	mov rax, SYS_WRITE
	syscall
	leave 				; restore stack frame
	ret
