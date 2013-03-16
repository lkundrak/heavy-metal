#include <lib.h>

/*
 * This code is reached from asm routine start (in mch.s)
 */

void
main ()
{
	consinit ();
	puts ("Hello World!\n");
	reboot ();
	puts ("Failed to reboot.\n");
	while (1);
}
