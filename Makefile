FILES := $(wildcard src/lib/*.c)

assemble: src/boot.s
	i686-elf-as src/boot.s -o build/boot.o

kernel: $(FILES:.c=.o)
	i686-elf-gcc -c src/kernel.c -o build/pre_kernel.o -std=gnu99 -nostartfiles -ffreestanding -O2 -Wall -Wextra
	@echo $(FILES:.c=.o)
	mv src/lib/*.o build/

%.o: %.c
	i686-elf-gcc -c $< -o $@ -std=gnu99 -nostartfiles -ffreestanding -O2 -Wall -Wextra

linker: build/pre_kernel.o build/boot.o
	i686-elf-gcc -T src/linker.ld -o isodir/boot/myos.bin -ffreestanding -O2 -nostdlib build/*.o -lgcc

iso: isodir/boot/myos.bin isodir/boot/grub/grub.cfg
	grub-mkrescue -o build/myos.iso isodir

all: src/kernel.c src/boot.s src/linker.ld
	make assemble && make kernel && make linker && make iso

run-kernel-vm: isodir/boot/myos.bin
	qemu-system-i386 -kernel isodir/boot/myos.bin

run-iso-vm: build/myos.iso
	qemu-system-i386 -cdrom build/myos.iso
