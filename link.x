OUTPUT_FORMAT (elf32-i386)
ENTRY (start)			/* in mch.s */

SECTIONS
{
	/*
	 * begin at 1MB
	 * GNU Grub doesn't support loading below 1MB
	 */
	. = 0x100000;

	/*
	 * Multiboot header
	 * Required to be aligned at 4KB boundary.
	 */

	. = ALIGN(4);	/* no reason for having this here, 1MB is at 4KB b. */
	.multiboot_header :
	{
		*(.multiboot_header)
	}

	.text :
	{
		*(.text)
	}

	.data :
	{
		*(.data)
	}

	/*
	 * symbols bss_start and bss_end are required when blankning bss
	 * in machdep.c
	 */

	bss_start = .;
	.bss :
	{
		*(.bss)
	}
	bss_end = .;

	/DISCARD/ :	/* XXX: is this needed? */
	{
		*(.comment)
		*(.note)
	}

	stack_bottom = .;
	. += 1024;	/* is this enough? */
	stack_top = .;
}
