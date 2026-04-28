%ifndef SYS_MAC
	%define SYS_MAC
	%macro	_arg_1 1
		mov rdi, %1
	%endmacro
	%macro	_arg_2 2
		mov rdi, %1
		mov rsi, %2
	%endmacro
	%macro	_arg_3 3
		mov rdi, %1
		mov rsi, %2
		mov rdx, %3
	%endmacro
	%macro	_arg_4 4
		mov rdi, %1
		mov rsi, %2
		mov rdx, %3
		mov r10, %4
	%endmacro
	%macro	_arg_5 5
		mov rdi, %1
		mov rsi, %2
		mov rdx, %3
		mov r10, %4
	%endmacro
	%define SYS_READ 0
	%define SYS_WRITE 1
	%macro	sys_write 3
		_arg_3 %1, %2, %3
		mov rax, SYS_WRITE
		syscall
	%endmacro
%endif
