
section .text
global ft_atoi_base
ft_atoi_base:
%define a			r8
%define b			r9
%define i			rcx
%define j			rdx
%define sign		r11
%define str			rdi
%define base		rsi
%define base_len	r10
	enter 0, 0
	mov rax, 0
	; im leaving rax untouched throughout all of this so that i don't have to
	; set its value on the error branch.
	.validate_base:
		.length:
			mov i, -1
			.length.loop:
				inc i
				cmp byte [base + i], 0
				jne .length.loop
			mov base_len, i
			cmp base_len, byte 1
			jle .exit
		.invalid_characters:
			mov i, -1
			.invalid_characters.loop:
				inc i
				%macro check_exit 2
					cmp byte %1, %2
					je .exit
				%endmacro
				check_exit [base + i], 0x20	; space
				check_exit [base + i], 0x09	; '\t'
				check_exit [base + i], 0x0A	; '\n'
				check_exit [base + i], 0x0B	; '\v'
				check_exit [base + i], 0x0C	; '\f'
				check_exit [base + i], 0x0D	; '\r'
				check_exit [base + i], '+'
				check_exit [base + i], '-'
				cmp byte [base + i], 0
				jne .invalid_characters.loop
		.duplicate_characters:
			mov i, 0
			.duplicate_characters.outer:
				mov j, i
				inc j
				cmp j, base_len
				je .valid
				.duplicate_characters.inner:
					movsx b, byte [base + i]
					movsx a, byte [base + j]
					cmp a, b
					je .exit
					inc j
					cmp byte [base + j], 0
					jne .duplicate_characters.inner
				inc i
				cmp byte [base + i], 0
				jne .duplicate_characters.outer
	.valid:
	mov rax, 0
	mov i, 0
	mov sign, 1
	.skip_whitespace:
		%macro ws_check 2
			cmp byte %1, %2
			jne %%not_found
			inc i
			jmp .skip_whitespace
			%%not_found:
		%endmacro
		ws_check [str + i], 0x20	; space
		ws_check [str + i], 0x09	; '\t'
		ws_check [str + i], 0x0A	; '\n'
		ws_check [str + i], 0x0B	; '\v'
		ws_check [str + i], 0x0C	; '\f'
		ws_check [str + i], 0x0D	; '\r'
	.check_sign:
		.check_sign.pos:
			cmp byte [str + i], '+'
			jne .check_sign.neg
			inc i
			jmp .parse_number
		.check_sign.neg:
			cmp byte [str + i], '-'
			jne .parse_number
			inc i
			neg sign
	.parse_number:
		cmp byte [str + i], 0
		je .exit
		mov j, 0
		.parse_number.in_base:
			movsx a, byte [str + i]
			movsx b, byte [base + j]
			cmp a, b
			je .parse_number.arithmetic
			inc j
			cmp j, base_len
			je .exit
			jmp .parse_number.in_base
		.parse_number.arithmetic:
			imul rax, base_len
			mov a, j
			imul a, sign
			add rax, a
		inc i
		jmp .parse_number
.exit:
	leave
	ret
