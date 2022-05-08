VERSION_STRING = "\"v0.1\""
NASMFLAG = -dVERSION=$(VERSION_STRING)
NASMFLAG32BIT = -f elf32
CFLAGS = -m32 -fno-pic
all: bin/os.bin
	@echo build successfull
bin/os.bin: bin/bootloader/first_stage.bin bin/bootloader/second_stage.bin bin/bootloader/pmode_first.bin
	@echo creating empty disk
	dd conv=notrunc if=/dev/zero of=bin/os.bin conv=notrunc bs=512 count=2880 2>/dev/null
	@echo copying first stage bootloader
	dd conv=notrunc if=bin/bootloader/first_stage.bin of=bin/os.bin bs=512 count=1 2>/dev/null
	@echo copying second stage bootloader
	dd conv=notrunc if=bin/bootloader/second_stage.bin of=bin/os.bin bs=512 count=2 seek=1 2>/dev/null
	@echo copying the first pmode code
	dd conv=notrunc if=bin/bootloader/pmode_first.bin of=bin/os.bin bs=512 count=4 seek=3 2>/dev/null
bin/bootloader/first_stage.bin: nasm/bootloader/first_stage.nasm
	nasm -f bin nasm/bootloader/first_stage.nasm -o bin/bootloader/first_stage.bin $(NASMFLAG)
bin/bootloader/second_stage.bin: nasm/bootloader/second_stage.nasm
	nasm -f bin nasm/bootloader/second_stage.nasm -o bin/bootloader/second_stage.bin $(NASMFLAG)
bin/bootloader/pmode_first.bin: nasm/bootloader/pmode_first.nasm
	nasm -f bin nasm/bootloader/pmode_first.nasm -o bin/bootloader/pmode_first.bin $(NASMFLAG)
o/bootloader/pmode_first.o: nasm/bootloader/pmode_first.nasm
	nasm -o o/bootloader/pmode_first.o nasm/bootloader/pmode_first.nasm $(NASMFLAG) $(NASMFLAG32BIT)
o/kernel_libc/k_put_c_pos.o: c/kernel_libc/head/k_stdio.h c/kernel_libc/k_put_c_pos.c 
	gcc -c c/kernel_libc/k_put_c_pos.c -o o/kernel_libc/k_put_c_pos.o $(CFLAGS)
o:
	@mkdir o
o/bootloader:o
	@mkdir o/bootloader
raw:
	@mkdir raw
bin: 
	@mkdir bin
bin/bootloader:
	@mkdir bin/bootloader
folders: o o/bootloader raw bin bin/bootloader

#ld -o test.bin o/kernel_libc/k_put_c_pos.o -T linker/kernel_libc/LINKERSCRIPT.ld -melf_i386