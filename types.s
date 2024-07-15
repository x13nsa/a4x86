.section	.text

.globl	is_lower_
.globl	is_upper_

.globl	is_digit_
.globl	is_xdigit_

.globl	is_alpha_
.globl	is_alnum_
.globl	is_space_

.globl	to_lower_
.globl	to_upper_

is_lower_:
	movl	$0, %eax
	cmpb	$'a', %dil
	jl	.is_lower_end
	cmpb	$'z', %dil
	jg	.is_lower_end
	movl	$1, %eax
.is_lower_end:
	ret

is_upper_:
	movl	$0, %eax
	cmpb	$'A', %dil
	jl	.is_upper_end
	cmpb	$'Z', %dil
	jg	.is_upper_end
	movl	$1, %eax
.is_upper_end:
	ret

is_digit_:
	movl	$0, %eax
	cmpb	$'0', %dil
	jl	.is_digit_end
	cmpb	$'9', %dil
	jg	.is_digit_end
	movl	$1, %eax
.is_digit_end:
	ret

is_xdigit_:
	call	is_digit_
	testl	%eax, %eax
	jnz	.is_xdigit_yes
	call	to_lower_
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

is_alpha_:
	call	is_lower_
	testl	%eax, %eax
	jnz	.is_alpha_yes
	call	is_upper_
	testl	%eax, %eax
	jnz	.is_alpha_yes
	movl	$0, %eax
	jmp	.is_digit_end
.is_alpha_yes:
	movl	$1, %eax
.is_alpha_end:
	ret

is_alnum_:
	call	is_alpha_
	testl	%eax, %eax
	jnz	.is_alnum_yes
	call	is_digit_
	testl	%eax, %eax
	jnz	.is_alnum_yes
	movl	$0, %eax
	jmp	.is_alnum_end
.is_alnum_yes:
	movl	$1, %eax
.is_alnum_end:
	ret

is_space_:
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

to_lower_:
	call	is_upper_
	testl	%eax, %eax
	jz	.to_lower_mov
	addb	$32, %dil
.to_lower_mov:
	movb	%dil, %al
.to_lower_end:
	ret

to_upper_:
	call	is_lower_
	testl	%eax, %eax
	jz	.to_upper_mov
	subb	$32, %dil
.to_upper_mov:
	movb	%dil, %al
.to_upper_end:
	ret
