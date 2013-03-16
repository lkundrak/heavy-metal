#include <lib.h>

#define BASE	0x20000000
#define RSTC	0x1c
#define WDOG	0x24

#define PM(n)	*(unsigned int *)(BASE + 0x100000 + (n))

#define PASSWORD		0x5a000000
#define WDOG_TIME_SET		0x000fffff
#define RSTC_WRCFG_CLR		0xffffffcf
#define RSTC_WRCFG_FULL_RESET	0x00000020

void
reboot ()
{
	int rstc;

	rstc = PM(RSTC);
	PM(WDOG) = PASSWORD | (10 & WDOG_TIME_SET);
	PM(RSTC) = PASSWORD | (rstc & RSTC_WRCFG_CLR) | RSTC_WRCFG_FULL_RESET;
}
