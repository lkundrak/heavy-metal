#include <lib.h>

#define BASE 	0x20200000
#define DR	0x00000000
#define FR	0x00000018
#define IBRD	0x00000024
#define FBRD	0x00000028
#define LCRH	0x0000002c
#define CR	0x00000030
#define IMSC	0x00000038
#define ICR	0x00000044

#define TCLK    3000000L
#define BAUD    115200L

#define F8N1	0x70
#define ALLINT	0x7f2
#define RXTXE	0x301

#define GPPUD		*(unsigned int *)(BASE + 0x94)
#define GPPUDCLK0	*(unsigned int *)(BASE + 0x98)
#define UART0(n)	*(unsigned int *)(BASE + 0x0001000 + (n))
 
void
delay ()
{
	int count = 150;
	while ((volatile int)count--);
}
 
void
consinit ()
{
	UART0(CR) = 0x00;

	GPPUD = 0x00000000;
	delay ();
	GPPUDCLK0 = 0x0000c000;
	delay ();
	GPPUDCLK0 = 0x00000000;
 
	UART0(ICR) = ALLINT;
	UART0(IBRD) = TCLK / (BAUD * 16);
	UART0(FBRD) = (unsigned int)(((float)TCLK / (BAUD * 16) - TCLK / (BAUD * 16)) * 64 + 0.5);
	UART0(LCRH) = F8N1;
	UART0(IMSC) = ALLINT;
	UART0(CR) = RXTXE;
}

void
flush ()
{
	while (UART0(FR) & 0x20);
}
 
void
putchar (c)
	char c;
{
	if (c == '\n')
		putchar ('\r');

	flush ();
	UART0(DR) = c;
	flush ();
}
