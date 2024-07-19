.section	.bss
	.buffer:	.zero	2048

.section	.rodata
	# error messages.
	.err_unknw_fmt_msg:	.string "printf_: unknown fmt.\n"
	.err_unknw_fmt_len:	.long	22

	.err_overflow_msg:	.string "printf_: fmt overflow.\n"
	.err_overflow_len:	.long	23

	.buffer_cap:	.quad	2048
	.laradio:	.string "la radio!"
	.test:		.string "hola como estas subeme %s %s %s %s\n"

.section	.text
.globl		printf_
.globl		_start


.macro	EXIT_, a
	movq	\a, %rdi
	movq	$60, %rax
	syscall
.endm

.macro	ERROR_, a, b
	leaq	\a, %rsi
	movl	\b, %edx
	movl	$1, %eax
	movl	$2, %edi
	syscall
.endm

.macro	CHECK_FOR_SPACE
	movq	-36(%rbp), %rcx
	cmpq	%rcx, .buffer_cap(%rip)
	je	.printf_err_overflow
.endm

_start:
	movl	$1, %edi
	leaq	.test(%rip), %rsi
	leaq	.laradio(%rip), %rax
	pushq	%rax
	pushq	%rsi
	pushq	%rax
	pushq	%rax
	call	printf_
	EXIT_	%rax


# arguments:	fd (edi) ; fmt (rsi) ; arguments (pushed into the stack)
# return:	number of bytes written.
# regs:		rax, rdi, rsi, rcx, rbx
printf_:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$36, %rsp
	# stack distribution.
	# -8(%rbp):	index of the current argument.
	# -12(%rbp):	write to (fd).
	# -20(%rbp):	format.
	# -28(%rbp):	pointer to the buffer.
	# -36(%rbp):	number of bytes written so far (into the buffer).
	movq	$0, -8(%rbp)
	movq	$0, -36(%rbp)
	movl	%edi, -12(%rbp)
	movq	%rsi, -20(%rbp)
	leaq	.buffer(%rip), %rax
	movq	%rax, -28(%rbp)
.printf_loop:
	movq	-20(%rbp), %rax
	movzbl	(%rax), %edi
	testl	%edi, %edi
	jz	.printf_goodbye
	# cheking for space.
	CHECK_FOR_SPACE
	# is it format?
	cmpb	$'%', %dil
	je	.printf_fmt_found
	# storing current non-formated-characer into the buffer.
	movq	-28(%rbp), %rax
	movb	%dil, (%rax)
	# go for the next character in the fmt.
	# prepare the next byte in the buffer.
	# increase the number of bytes stored into the buffer.
	incq	-20(%rbp)
	incq	-28(%rbp)
	incq	-36(%rbp)
	jmp	.printf_loop
.printf_fmt_found:
	# getting the format.
	# "this is the fmt (%c).\n"
	#                    ` now here not at %.
	incq	-20(%rbp)
	movzbl	1(%rax), %eax
	# may this is not a format.
	cmpb	$'%', %al
	je	.printf_fmt_skip
	# getting the value for this format; stored into rbx.
	movq	-8(%rbp), %rbx
	movq	16(%rbp, %rbx, 8), %rbx
	incq	-8(%rbp)
	# -*-
	cmpb	$'d', %al
	je	.printf_fmt_number
	cmpb	$'s', %al
	je	.printf_fmt_string
	cmpb	$'c', %al
	je	.printf_fmt_character
	jmp	.printf_err_unknown_fmt

.printf_fmt_number:

.printf_fmt_string:
	movzbl	(%rbx), %edi
	testl	%edi, %edi
	jz	.printf_fmt_done
	CHECK_FOR_SPACE
	# storing character from the string.
	movq	-28(%rbp), %rax
	movb	%dil, (%rax)
	# keep going my bby.
	incq	-28(%rbp)
	incq	-36(%rbp)
	incq	%rbx
	jmp	.printf_fmt_string

.printf_fmt_character:
	movq	-28(%rbp), %rax
	movb	%bl, (%rax)
	incq	-28(%rbp)
	incq	-36(%rbp)
	jmp	.printf_fmt_done

.printf_fmt_skip:
	movq	-28(%rbp), %rax
	movb	$'%', (%rax)
	incq	-28(%rbp)
	incq	-36(%rbp)
	jmp	.printf_fmt_done

.printf_fmt_done:
	incq	-20(%rbp)
	jmp	.printf_loop

.printf_goodbye:
	leaq	.buffer(%rip), %rsi
	movq	-36(%rbp), %rdx
	movq	$1, %rax
	movq	$1, %rdi
	syscall
	movq	-36(%rbp), %rax
	leave
	ret

#  ___________________
# < errors damnnnnnnn >
#  -------------------
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||
.printf_err_unknown_fmt:
	ERROR_	.err_unknw_fmt_msg(%rip), .err_unknw_fmt_len(%rip)
	EXIT_	$1

.printf_err_overflow:
	ERROR_	.err_overflow_msg(%rip), .err_overflow_len(%rip)
	EXIT_	$1
