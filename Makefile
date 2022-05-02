all: bin/os.bin
	@echo build successfull
bin/os.bin: bin/bootloader/first_stage.bin bin/bootloader/second_stage.bin
	@echo creating empty disk
	dd conv=notrunc if=/dev/zero of=bin/os.bin conv=notrunc bs=512 count=2880 2>/dev/null
	@echo copying first stage bootloader
	dd conv=notrunc if=bin/bootloader/first_stage.bin of=bin/os.bin bs=512 count=1 2>/dev/null
	@echo copying second stage bootloader
	dd conv=notrunc if=bin/bootloader/second_stage.bin of=bin/os.bin bs=512 count=1 seek=1 2>/dev/null
bin/bootloader/first_stage.bin: nasm/bootloader/first_stage.nasm
	nasm -f bin nasm/bootloader/first_stage.nasm -o bin/bootloader/first_stage.bin
bin/bootloader/second_stage.bin: nasm/bootloader/second_stage.nasm
	nasm -f bin nasm/bootloader/second_stage.nasm -o bin/bootloader/second_stage.bin
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