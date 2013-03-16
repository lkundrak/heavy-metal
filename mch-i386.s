#

/*
 * lowlevel library
 */


/* entry point (see unix.x)*/
.globl	start
start:
	movl	$stack_top, %esp
	pushl	$0x0
	popf
	jmp	main

/*
 * outb (port, int);
 * char inb (port);
 */
.globl	outb, inb
outb:
	movw	0x4(%esp), %dx
	movb	0x8(%esp), %al
	out	%al, %dx
	ret
inb:
	xor	%eax, %eax
	movw	0x4(%esp), %dx
	in	%dx, %al
	ret

/*
 * outw (port, short);
 * short inw (port);
 */
.globl	outw, inw
outw:
	movw	0x4(%esp), %dx
	movw	0x8(%esp), %ax
	out	%ax, %dx
	ret
inw:
	xor	%eax, %eax
	movw	0x4(%esp), %dx
	in	%dx, %ax
	ret


/*
 * outl (port, int);
 * int inl (port);
 */
.globl	outl, inl
outl:
	movw	0x4(%esp), %dx
	movl	0x8(%esp), %eax
	out	%eax, %dx
	ret
inl:
	movw	0x4(%esp), %dx
	in	%dx, %eax
	ret
