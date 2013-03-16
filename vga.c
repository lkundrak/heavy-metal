/*
 * Routines handling PC terminal's screen
 */

#include <lib.h>

#define	COLS		80
#define ROWS		25

#define CURSOR		(vgacols+(vgarows*COLS))

#define VGA_IDX		0x3d4
#define VGA_VAL		0x3d5
#define VGA_FRM		((struct vgachar *)0xB8000)

struct vgachar {
	char	character;
	char	attr;
} *vgaframe = VGA_FRM;

char vgacols = 0, vgarows = 0;

void
vgascroll ()
{
	int i;

	for (i=80; i<COLS*ROWS; i++)
		vgaframe[i-80].character = vgaframe[i].character;
	for (; i<COLS*(ROWS+1); i++)
		vgaframe[i-80].character = 0;

	vgarows--;
}

/*
 * move hardware cursor to specified position
 */

void
vgacursor ()
{
	outb (VGA_IDX, 0x0f);
	outb (VGA_VAL, CURSOR & 0xff);
	outb (VGA_IDX, 0x0e);
	outb (VGA_VAL, CURSOR >> 8 & 0xff);
}

/*
 * clear the screen and put cursor in upper left corner
 */

void
consinit ()
{
	int i;

	for (i=0; i<COLS*ROWS; i++){
		vgaframe[i].character = ' ';
		vgaframe[i].attr = 0x02;
	}

	vgacols = 0;
	vgarows = 0;
	vgacursor ();
}

/*
 * write single character on the screen,
 * move cursor and scroll if necessary
 * todo: \t, backspace,... ansi escapes?
 */

void
putchar (c)
	char c;
{
	switch (c) {
		case '\n':
			vgarows++;
		case '\r':
			vgacols = 0; break;
		case '\t':
			vgacols |= 0x7; vgacols++; break;
		case '\b':
			vgacols--; vgaframe[CURSOR].character = ' '; break;
		default:
			vgaframe[CURSOR].character = c;
			vgacols++;
			break;
	}

	if (vgacols < 0) {		/* effect of backspace */
		vgarows--;
		vgacols = COLS-1;
	}

	if (vgarows < 0)		/* stay in frame buffer :) */
		vgarows = vgacols = 0;

	if (vgacols >= COLS) {		/* end of line reached */
		vgacols = 0;
		vgarows++;
	}
	if (vgarows >= ROWS)		/* end of page reached */
		vgascroll ();

	vgacursor ();
}
