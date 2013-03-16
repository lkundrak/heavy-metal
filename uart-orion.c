#include <lib.h>

#define BASE	0xf1000000
#define THR	0x00000000
#define DLL	0x00000000
#define DLH	0x00000004
#define LCR	0x0000000c
#define LSR	0x00000014

#define TCLK	200000000L
#define BAUD	115200L

#define DLRW	0x80
#define P8N1	0x03

#define UART1(n) *(unsigned int *)(BASE + 0x00012000 + (n))

void
consinit ()
{
	UART1(LCR) = DLRW;
	UART1(DLL) = TCLK / (BAUD * 16);
	UART1(DLH) = 0x00;
	UART1(LCR) = P8N1;
}

void
flush ()
{
	while (!(UART1(LSR) & 0x40));
}

void
putchar (c)
	char c;
{
	if (c == '\n')
		putchar ('\r');
	flush ();
	UART1(THR) = c;
	flush ();
}
