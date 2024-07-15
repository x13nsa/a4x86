.section	.text

.globl	strlen_

strlen_:
	movq	$0, %rcx
	cmpq	$0, %rdi
	je	.strlen_end
.strlen_loop:
	movzbl	(%rdi), %eax
	cmpl	$0, %eax
	je	.strlen_end
	incq	%rdi
	incq	%rcx
	jmp	.strlen_loop
.strlen_end:
	movq	%rcx, %rax
	ret
