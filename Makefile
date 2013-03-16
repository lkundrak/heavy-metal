ARCH = $(shell uname -i |sed 's/v[0-9].*//;s/x86_64/i386/')
CROSS_arm=  armv5tel-redhat-linux-gnueabi-
CFLAGS_i386 = -m32
ASFLAGS_i386 = -32
LDFLAGS_i386 = -m elf_i386
CROSS = $(CROSS_$(ARCH))
ARM_PLATFORM = orion

IMAGE = kernel
LINK = link-$(ARCH).x
OBJS_i386 += vga.o
OBJS_i386 += reboot-$(ARCH).o
OBJS_arm += uart-$(ARM_PLATFORM).o
OBJS_arm += reboot-$(ARM_PLATFORM).o
OBJS += $(OBJS_$(ARCH))
OBJS += mch-$(ARCH).o
OBJS += prf.o
OBJS += main.o

AS	= $(CROSS)as
LD	= $(CROSS)ld
CC	= $(CROSS)gcc
GCC	= $(CROSS)gcc

CFLAGS ?= -Wall -g
INCLUDES = -I.
override CFLAGS += $(INCLUDES) -ffreestanding
override LDFLAGS += -T$(LINK)

override CFLAGS += $(CFLAGS_$(ARCH))
override ASFLAGS += $(ASFLAGS_$(ARCH))
override LDFLAGS += $(LDFLAGS_$(ARCH))

QEMUFLAGS = -M pc
override QEMUFLAGS += -net nic,model=ne2k_pci -net user,tftp=.
override QEMUFLAGS += -fda grub.ok

# targets

build: $(IMAGE)

$(IMAGE): $(OBJS)
	$(LD) $(LDFLAGS) -o $(IMAGE)  $(OBJS)

all: install snapshot

clean:
	rm -f *.o
	rm -f $(IMAGE)
	rm -f snapshot.tar

kernel: $(LINK)

depend:
	makedepend $(INCLUDES) *.c

# Autogenrated stuff below
# DO NOT DELETE THIS LINE -- make depend depends on it.

main.o: ./lib.h
prf.o: ./lib.h
vga.o: ./lib.h
