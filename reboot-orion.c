#include <lib.h>

#define BASE(n) *(unsigned int *)(0xf1000000 + (n))
#define RSTOUTn BASE(0x00020108)
#define RESET BASE(0x0002010c)

#define SOFT_RESET 4
#define DO_SOFT_RESET 1

void
reboot ()
{
	RSTOUTn = SOFT_RESET;
	RESET = DO_SOFT_RESET;
}
