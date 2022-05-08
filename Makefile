VERSION_STRING = "\"v0.1\""
NASMFLAG = -dVERSION=$(VERSION_STRING)
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
	dd conv=notrunc if=bin/bootloader/pmode_first.bin of=bin/os.bin bs=512 count=1 seek=3 2>/dev/null
bin/bootloader/first_stage.bin: nasm/bootloader/first_stage.nasm
	nasm -f bin nasm/bootloader/first_stage.nasm -o bin/bootloader/first_stage.bin $(NASMFLAG)
bin/bootloader/second_stage.bin: nasm/bootloader/second_stage.nasm
	nasm -f bin nasm/bootloader/second_stage.nasm -o bin/bootloader/second_stage.bin $(NASMFLAG)
bin/bootloader/pmode_first.bin: nasm/bootloader/pmode_first.nasm
	nasm -f bin nasm/bootloader/pmode_first.nasm -o bin/bootloader/pmode_first.bin $(NASMFLAG)
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