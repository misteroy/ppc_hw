
# Makefile for a "hello world" program on qemu -M ppce500

# The gnu toolchain is assumed to be in your path.
# Modify $(QEMU) to where your qemu is located

PROC=powerpc
#TYPE=eabi
TYPE=linux-gnu
PREFIX=$(PROC)-$(TYPE)-
#PATH:=/usr/local/bin:$(PATH)
GCC_VERSION=11
CFLAGS=-Iinc

#CC=$(PREFIX)gcc
CC=$(PREFIX)gcc-$(GCC_VERSION)
#AS=$(PREFIX)as
#AS=$(PREFIX)as
#AR=$(PREFIX)ar
LD=$(PREFIX)ld
NM=$(PREFIX)nm
OBJDUMP=$(PREFIX)objdump
OBJCOPY=$(PREFIX)objcopy

#QEMU=~/qemu/ppc-softmmu/qemu-system-ppc
QEMU=/usr/bin/qemu-system-ppc

.PHONY: all

all : test.bin

startup.o : startup.S
	$(CC) -mbig-endian -g -c -gstabs+ -Wa,-alh=startup.lst,-L -o $@ $<

test.o : test.c
	$(CC) $(CFLAGS) -c -mcpu=8540 -g $< -o $@


test.elf : test.o startup.o  test.ld
	$(LD) -T test.ld test.o startup.o -o $@


test.bin : test.elf
	 $(OBJCOPY) -O binary  $< $@

nm_test:
	$(NM) test.elf
dis_test:
	$(OBJDUMP) --disassemble test.elf

clean :
	rm -f -v *.o *.elf *.bin *.lst

run:
	$(QEMU) -cpu e500 -d guest_errors,unimp,mmu,int -M ppce500 -nographic -bios test.elf  -s


debug:
	$(QEMU) -cpu e500 -d guest_errors,unimp -M ppce500 -nographic -bios test.elf  -s -S
