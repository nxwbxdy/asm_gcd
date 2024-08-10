section .bss
	str_len	db ?				; where length of parameter is written

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
	mov	rdx, [rbp + 0x18] + 0x8		; argv[1] index
	jmp	exit_rax

; number = [rbp + 0x10]
; return 0 -> success
; return 1 -> error
check_valid_number:
	; set stack
	push	rbp
	mov	rbp, rsp

	; validation
	mov	rdx, [rbp + 0x10]		; rbp + 0x8 -> rip	; + 0x10 -> 8 byte
	cmp	rdx, 0x30			; '0'
	jl	return_error			; < '0'
	cmp	rdx, 0x39			; '9'
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

	lea	rdx, [rbp + 0x10]		; load address of string
	xor	rcx, rcx
loop_count:
	; rdi -> data index
	mov	rdi, [rdx + rcx]
	cmp	rdi, 0x0
	inc	rcx
	jne	loop_count
	;end_loop
	mov	rax, rcx
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
