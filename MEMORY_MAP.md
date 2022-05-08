### Important, this memory map is theoric, but can and will change in during the evolution of touhouOS

# what will not change
0x7c00 is the basic sector in which the code will boot (no choice for that anyway)

# important 

# ideas:

dump the gdt before unreal bios calls (i guess i will do that a lot before i actually bother having a proper implementation of usb/floppy disk/cd/sata controllers), and even then that will remain the first way of loading data before having drivers initialized. I guess memory_load_bios will still be a routine for legacy method of loading data. it will dump idt and GDT in a specified memory zone before doing real mode syscall and reinitializing them

memory before boot sector will be allocated to be the memory exchange place between the real mode and protected mode (0x500 -> 0x7BFF)
0x500 -> will store the drive index of the boot sector
0x502 -> pointer to the memory map

the idiotic way the data is going to be loaded is as follows :
-a program will be put in real mode address 0x7C00 (bootsector )
-the GDT, IDT, and all the required struff will be stored in let say 0x600
-switchity switch to real mode
-loady load at 0x2000 : 0000 (0x20000),100kiB at a time
-switch to pmode, restore the context (i guess PC will be stored at a fix place)
-copy newliy acquired data to the good place => if protected, don't copy the undesired data
-call as many times as needed




a real mode place will be located in (idea) 0x7E00. this programs will 1) load data keeping ES unreal mode addresses in order to perform the syscall.
the sector right after it will be a program which aims to go back to protected mode
A set number of sectors after this program the real mode program space will begin.

allocated memory to the idt/gdt setup will be determined later.

In this memory address space the actual memory map will be stored and get back using a "protected real syscall" in order to get the memory availible to the device and be able to make the MMU/memmap/pagination working

TOHOU OS will be located using special signature 'scarlet' before the end of the sector in its first stage bootloader
