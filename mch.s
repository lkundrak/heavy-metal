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
	call	vgaclear	/* move this to startup ()? */
	jmp	main

.globl	cli, sti
cli:
	cli
	ret
sti:
	sti			/* enable ints at cpu */
	ret


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

#if 0
/*
 * load_idt (tbl);
 * load_gdt (tbl);
 *	struct region *tbl;
 */

.globl	load_idt, load_gdt
load_idt:
	mov	0x4(%esp), %eax
	lidt	(%eax)
	ret
load_gdt:
	mov	0x4(%esp), %eax
	lgdt	(%eax)
	mov	$0x8, %eax
	mov	%eax, %ds
	mov	%eax, %es
	mov	%eax, %ss
	mov	%eax, %fs
	mov	%eax, %gs
	jmp	$0x10,$newseg
	newseg:
	ret

/*
 * int cpuid (buf);
 *	char buf[13];
 */

.globl	cpuid
cpuid:
	xor	%eax, %eax
	cpuid
	push	%eax
	mov	0x8(%esp), %eax
	mov	%ebx, (%eax)
	mov	%edx, 0x4(%eax)
	mov	%ecx, 0x8(%eax)
	movb	$0, 0xc(%eax)
	pop	%eax
	ret

/*
 * save (buf)
 * restore (buf)
 *	struct regs buf;
 */

.globl	save, resume
save:
	pushf
	push	%ebx

	mov	0x0c(%esp), %ebx	/* arg1: where to save */
	mov	%edi, 0x00(%ebx)
	mov	%esi, 0x04(%ebx)
	mov	%ebp, 0x08(%ebx)
	mov	%edx, 0x14(%ebx)
	mov	%ecx, 0x18(%ebx)
	mov	%eax, 0x1c(%ebx)

	pop	%eax			/* ebx */
	mov	%eax, 0x10(%ebx)

	pop	%eax			/* eflags */
	mov	%eax, 0x24(%ebx)

	pop	%ecx			/* retval -> eip */
	mov	%ecx, 0x20(%ebx)

	mov	%esp, 0x0c(%ebx)
	xor	%eax, %eax
	jmp	*%ecx

resume:
	pop	%ecx			/* return address */ /* sub? */
	mov	0x00(%esp), %ebx	/* arg1: where to restore from */
	mov	0x0c(%ebx), %esp

	mov	0x00(%ebx), %edi
	mov	0x04(%ebx), %esi
	mov	0x08(%ebx), %ebp
	mov	0x14(%ebx), %edx
	mov	0x18(%ebx), %ecx
	mov	0x1c(%ebx), %eax
	push	0x24(%ebx)		/* eflags */
	push	%cs
	push	0x20(%ebx)		/* eip */
	mov	0x10(%ebx), %ebx
	iret

.globl eflags
eflags:
	pushf
	pop	%eax
	ret

#endif
