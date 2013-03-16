#include <lib.h>

void
puts (string)
	char *string;
{
	while (*string)
		putchar (*string++);
}
