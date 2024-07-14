.section	.text

.globl	is_lower
.globl	is_upper

.globl	is_digit
.globl	is_xdigit

.globl	is_alpha
.globl	is_alnum
.globl	is_space

.globl	to_lower
.globl	to_upper

is_lower:
	movl	$0, %eax
	cmpb	$'a', %dil
	jl	.is_lower_end
	cmpb	$'z', %dil
	jg	.is_lower_end
	movl	$1, %eax
.is_lower_end:
	ret

is_upper:
	movl	$0, %eax
	cmpb	$'A', %dil
	jl	.is_upper_end
	cmpb	$'Z', %dil
	jg	.is_upper_end
	movl	$1, %eax
.is_upper_end:
	ret

is_digit:
	movl	$0, %eax
	cmpb	$'0', %dil
	jl	.is_digit_end
	cmpb	$'9', %dil
	jg	.is_digit_end
	movl	$1, %eax
.is_digit_end:
	ret

is_xdigit:
	call	is_digit
	testl	%eax, %eax
	jnz	.is_xdigit_yes
	call	to_lower
	cmpb	$'a', %al
	jl	.is_xdigit_no
	cmpb	$'f', %al
	jle	.is_xdigit_yes
.is_xdigit_no:
	movl	$0, %eax
	jmp	.is_xdigit_end
.is_xdigit_yes:
	movl	$1, %eax
.is_xdigit_end:
	ret

is_alpha:
	call	is_lower
	testl	%eax, %eax
	jnz	.is_alpha_yes
	call	is_upper
	testl	%eax, %eax
	jnz	.is_alpha_yes
	movl	$0, %eax
	jmp	.is_digit_end
.is_alpha_yes:
	movl	$1, %eax
.is_alpha_end:
	ret

is_alnum:
	call	is_alpha
	testl	%eax, %eax
	jnz	.is_alnum_yes
	call	is_digit
	testl	%eax, %eax
	jnz	.is_alnum_yes
	movl	$0, %eax
	jmp	.is_alnum_end
.is_alnum_yes:
	movl	$1, %eax
.is_alnum_end:
	ret

is_space:
	cmpb	$0x20, %dil
	je	.is_space_yes
	cmpb	$0x09, %dil
	jl	.is_space_no
	cmpb	$0x0d, %dil
	jg	.is_space_no
	jmp	.is_space_yes
.is_space_no:
	movl	$0, %eax
	jmp	.is_space_end
.is_space_yes:
	movl	$1, %eax
.is_space_end:
	ret

to_lower:	
	call	is_upper
	testl	%eax, %eax
	jz	.to_lower_mov
	subb	$32, %dil
.to_lower_mov:
	movb	%dil, %al
.to_lower_end:
	ret

to_upper:	
	call	is_lower
	testl	%eax, %eax
	jz	.to_upper_mov
	addb	$32, %dil
.to_upper_mov:
	movb	%dil, %al
.to_upper_end:
	ret
