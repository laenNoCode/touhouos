%define BASE_OFFSET 0
;offset before sceond stage, maybe for FAT info
%define SECOND_STAGE_COUNT 100
;number of sectors to load
[BITS 16]
;initializing the stack
mov ax, 0x7000
mov ss, ax
mov sp, 0xFFFF
mov bp, 0xFFFF

;initializing data segment
mov ax, 0x7c0
mov ds,ax
;saving the disk id we booted from, will be usefull later
mov bx,booting_slot
mov [bx], dl

reset_disk_state:
	mov ah,00
	mov dl, [booting_slot]
	int 0x13
	jc reset_disk_state;error was found
;then we will load data until finding the boot sector with the signature, 1 chunk at a time
mov cx, 0
find_booting_sector:
	mov si, dis_addr_packet
	mov dl, [booting_slot]
	mov ah, 0x42
	int 0x13
	jc find_booting_sector; if error, retry
	mov cx, [to_read_l]
	add cx, 1
	mov [to_read_l], cx
	call check_signature
	cmp ax,0
	jne find_booting_sector
	;signature detected. From there, we will add BASE_OFFSET before reading
	;SECOND_STAGE_COUNT sectors and jumping there 
	mov ax, [to_read_l]
	add ax, BASE_OFFSET
	mov [to_read_l], ax
	mov dword [sector_count], SECOND_STAGE_COUNT
LOAD_SECOND_STAGE_DATA:
	mov dl, [booting_slot]
	mov si,dis_addr_packet
	mov ah,0x42
	int 0x13
	jc LOAD_SECOND_STAGE_DATA
	jmp 0x800:0
	jne hang
check_signature:
	mov ax,0x800
	mov es, ax
	mov bx,signature
	mov cx, 6
	cs_check_loop:
		mov dx,[bx]
		mov ax,[es:bx]
		cmp ax,dx
		jne cs_not_correct
		inc bx
	loop cs_check_loop
	mov ax,0
	jmp cs_end
	cs_not_correct:
		mov ax, cx
		add ax, 1
	cs_end:
	ret

call print_register



hang:jmp hang
hex_charset:db "0123456789ABCDEF"
print_register:;ax is the register to print, bx is the position to print to
	push es
	mov cx,4
	mov dx, ax
	mov ax, 0xb800
	mov es, ax
	mov ax, dx
	add bx,6
	print_register_loop:
		push bx
		mov bx,16
		mov dx, 0
		div bx
		mov bx, dx
		mov bl,[bx + hex_charset]
		mov dx, bx
		pop bx
		mov byte [es:bx], dl
		sub bx, 2
	loop print_register_loop
	pop es
	ret
dis_addr_packet:
	size:         db 0x10
	unused:       db 0
	sector_count: dw 0x0001
	offset:       dw 0
	segmt:        dw 0x800
	to_read_l:    dd 0
	to_read_h:    dd 0

TIMES(503 - ($ - $$)) db 0
signature:
db "scarlet"
booting_slot:
db 0x55
db 0xAA


