.section	.bss
	buf:	.zero	5

.section	.text
.globl	_start


_start:
	movq	$69443, %rax
	leaq	buf(%rip), %rsi
	movq	$0, %rcx
loop:
	cmpq	$3, %rcx
	je	end
	movq	$10, %rbx
	idivq	%rbx
	addq	$'0', %rdx
	movb	%dl, (%rsi)
	incq	%rsi
	incq	%rcx
	jmp	loop


end:
	movq	$1, %rax
	movq	$1, %rdi
	leaq	buf(%rip), %rsi
	movq	$5, %rdx
	syscall

	movq	$60, %rax
	movq	$60, %rdi
	syscall
