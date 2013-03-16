#include <lib.h>

#define KBD_DATA        0x60
#define KBD_CMD         0x64
#define KBD_STAT        0x64

void
reboot ()
{
	int i;

	while (inb (KBD_STAT) & 0x2);
	i = inb (KBD_DATA);
	while (i == inb (KBD_DATA))
	while (inb (KBD_STAT) & 0x2);
	while (1) {
		outb(KBD_CMD, 0xFE);
	}
}
