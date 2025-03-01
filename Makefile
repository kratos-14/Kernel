assemble:
	i686-elf-as src/boot.s -o build/boot.o

kernel:
	i686-elf-gcc -c src/kernel.c -o build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

linker: build/kernel.o build/boot.o
	i686-elf-gcc -T src/linker.ld -o build/myos.bin -ffreestanding -O2 -nostdlib build/boot.o build/kernel.o -lgcc
	cp build/myos.bin isodir/boot/myos.bin

iso: isodir/boot/myos.bin isodir/boot/grub/grub.cfg
	grub-mkrescue -o build/myos.iso isodir

all: src/kernel.c src/boot.s src/linker.ld
	make assemble && make kernel && make linker && make iso

run-kernel-vm: build/myos.bin
	qemu-system-i386 -kernel build/myos.bin

run-iso-vm: build/myos.iso
	qemu-system-i386 -cdrom build/myos.iso
