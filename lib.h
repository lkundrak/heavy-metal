#ifdef __i386__
/* Bus I/O */
unsigned char inb (unsigned short);
unsigned int inl (unsigned short);
unsigned char outb (unsigned short, unsigned char);
unsigned int outl (unsigned short, unsigned int);

#endif

/* Driver functions */
void consinit ();
void reboot ();

/* Utility functions */
void puts (char *);
void putchar (char);
