section  .data
bad_param	db	"Bad number of parameters", 0xa, "Usage: <program> <num1> <num2>", 0xa, 0
bad_param_len	equ	$ - bad_param

section .text
global _start

; RAX 	-> 	ARG0
; RDI 	-> 	ARG1
; RSI 	-> 	ARG2
; RDX 	-> 	ARG3

; RETURN 	-> 	RAX
; COUNTER 	-> 	RCX
; DATA		->	RDX

; ERROR CODES
; BAD NUMBER	->	1
; BAD CHAR	->	2

_start:
	push	rbp, 				; save rbp
	mov	rbp, rsp			; set stack
	
	; if argc != 3 exit_error
	mov	dil, [rbp + 0x8]		; argc
	cmp	dil, 3
	jnz	print_params_and_exit

	lea	rdx, [rbp + 0x10]		; load argv[0] index			; get address of argv[0]
	add	rdx, 0x8			; next param -> argv[1]			; inc address to argv[1]
	;add	rdx, 0x8			; next param -> argv[2]
	push	qword [rdx]			; char* of argv[1] on stack		; push char* to stack
	call	check_valid_number
	jmp	exit_rax
	;call	get_len				; get len into rax
	jmp	exit_rax			; return code is input len argv[1]

; number = [rbp + 0x10]
; return 0 -> success
; return 1 -> error
check_valid_number:
	; set stack
	push	rbp
	mov	rbp, rsp

	; validation
	mov	rdi, [rbp + 0x10]		; rbp + 0x8 -> rip	; + 0x10 -> 8 byte
	;xor	rdx, rdx			; set 0
	mov	rdx, [rdi]			; rbp + 0x8 -> rip	; + 0x10 -> 8 byte
	cmp	dl, 0x30			; '0'
	jl	return_error			; < '0'
	cmp	dl, 0x39			; '9'
	jg	return_error			; > '9'
	mov	rax, 0				; return success

	; reset stack
	mov	rsp, rbp
	pop	rbp
	ret
return_error:
	mov	rax, 1				; return error

	mov	rsp, rbp
	pop	rbp
	ret

get_len:
	push	rbp
	mov	rbp, rsp

	mov	rdx, [rbp + 0x10]		; load address of string
	xor	rcx, rcx
loop_count:
	; rdi -> data index
	mov	dil, [rdx + rcx]
	cmp	dil, 0x0
	inc	rcx
	jne	loop_count
	;end_loop
	mov	rax, rcx			; return code (rax) is len
	mov	rsp, rbp
	pop	rbp
	ret
	

atoi:
	push	rbp
	mov	rbp, rsp

	; convert single position
	mov	rdx, [rbp + 0x10]		; load value from stck
	sub	rdx, 0x30			; convert to ascii int byte 0x30 = 0 to 0x39 = 9
	mov	rax, rdx

	; multi position idea
	; rcx = 1
	; rdx = 
	; rdi = rcx * rdx
	; mul	rcx, 10
	
	mov	rsp, rbp
	pop	rbp
	ret

print_params_and_exit:
	mov	rax, 0x1
	mov	rdi, 0x1
	mov	rsi, bad_param
	mov	rdx, bad_param_len
	syscall
	jmp	exit_error

exit_error:
	mov	rax, 0x3c			; syscall(exit)
	; mov 	rdi, 0				; ERROR_CODE
	syscall

exit_success:
	mov	rax, 0x3c			; syscall(exit)
	mov 	rdi, 0				; EXIT_SUCCESS
	syscall

exit_rax:
	mov	rdi, rax
	mov	rax, 0x3c			; syscall(exit)
	syscall
