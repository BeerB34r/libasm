; nasm includes
%include "sys.mac"

extern __errno_location

; main routine
section .text
global ft_read
ft_read:
	enter 0, 0				; save stack frame
	mov rax, SYS_READ
	syscall
	mov rdi, rax			; store rv
	call __errno_location	; plop pointer to errno into rax
	cmp rdi, 0				; check if syscall errored
	jge .ok
	.err:					; set errno appropriately
		neg rdi
		mov [rax], rdi
		mov rax, -1
		jmp .exit
	.ok:					; set errno appropriately
		mov word [rax], 0
		mov rax, rdi
.exit:
	leave					; restore stack frame
	ret
