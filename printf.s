.section	.rodata
	.buffer_sz:		.long	1024

	.overflow_msg:		.string "printf: overflow.\n"
	.overflow_len:		.long	18

	.null_msg:		.string "printf: null %d fmt.\n"
	.null_len:		.long	18
	
	.unknown_fmt_msg:	.string	"printf: unknown format\n"
	.unknown_fmt_len:	.long	23

.section	.bss
	.buffer:	.zero	1024

.section	.text
.globl		printf_
.globl		_start

.macro	FATAL_, a, b
	leaq	\a, %rsi
	movl	\b, %edx
	movq	$1, %rax
	movq	$2, %rdi
	syscall
	movq	$60, %rax
	movq	$1, %rdi
	syscall
.endm

_start:
	leaq	.null_msg(%rip), %rdi
	call	printf_

	movq	$60, %rax
	movq	$60, %rdi
	syscall

printf_:
	cmpq	$0, %rdi
	je	.printf_null_fmt
	pushq	%rbp
	movq	%rsp, %rbp
	# r8 will point to the last argument
	# pushed onto the stack.
	movq	%rsp, %r8
	addq	$16, %r8
	# stack distribution
	#  -8(%rbp): number of bytes written.
	# -16(%rbp): pointer to the buffer.
	# -24(%rbp): pointer to the format message.
	# -28(%rbp): write to (fd).
	subq	$32, %rsp
	movq	$0, -8(%rbp)
	leaq	.buffer(%rip), %rax
	movq	%rax, -16(%rbp)
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
.printf_loop:
	movq	-24(%rbp), %rbx
	movzbl	(%rbx), %eax
	testl	%eax, %eax
	jz	.printf_end
	# make sure ain't overflow
	movq	-8(%rbp), %rcx
	cmpq	%rcx, .buffer_sz(%rip)
	je	.printf_err_overflow
	cmpb	$'%', %al
	je	.printf_format
	movq	-16(%rbp), %rbx
	movb	%al, (%rbx)
	jmp	.printf_continue
.printf_format:
	incq	-24(%rbp)
	movq	-24(%rbp), %rbx
	movzbl	(%rbx), %eax	
	cmpb	$'%', %al
	je	.printf_fmt_fmt_none
	cmpb	$'d', %al
	je	.printf_fmt_fmt_number
	cmpb	$'s', %al
	je	.printf_fmt_fmt_string
	FATAL_	.unknown_fmt_msg(%rip), .unknown_fmt_len(%rip)

.printf_fmt_fmt_none:	
	movq	-16(%rbp), %rbx
	movb	$'%', (%rbx)
	jmp	.printf_continue

.printf_fmt_fmt_string:
	jmp	.printf_next_arg

.printf_fmt_fmt_number:
	# r9 holds the number
	movq	(%r8), %r9
	cmpb	$0, %bl
	jl	.printf_fmt_fmt_nun_skip_sign
	movq	-16(%rbp), %rdx
	movb	$'-', (%rdx)
.printf_fmt_fmt_nun_skip_sign:
	# TODO
	jmp	.printf_next_arg

.printf_next_arg:
	addq	$8, %r8

.printf_continue:
	incq	-16(%rbp)
	incq	-24(%rbp)
	incq	-8(%rbp)
	jmp	.printf_loop

.printf_end:
	FATAL_	.buffer(%rip), -8(%rbp)
	movq	-8(%rbp), %rax
	# TODO: make sure it cleans the stack completely
	leave
	ret
























.printf_err_overflow:
	FATAL_	.overflow_msg(%rip), .overflow_len(%rip)
.printf_null_fmt:
	FATAL_	.null_msg(%rip), .null_len(%rip)
