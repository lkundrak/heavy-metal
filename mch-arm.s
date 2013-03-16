#

.globl start
start:
	ldr	sp, stack
	bl main

.globl xputchar
xputchar:
	push	{fp, lr}
	add	fp, sp, #4

	ldr	r0, RSTOUTn_mask
	mov	r1, #4
	str	r1, [r0]

	ldr	r0, rst_register
	mov	r1, #1
	str	r1, [r0]

	sub	sp, fp, #4
	pop	{fp, lr}
	bx	lr

RSTOUTn_mask: .word 0xf1020108
rst_register: .word 0xf102010c
stack: .word stack_top
