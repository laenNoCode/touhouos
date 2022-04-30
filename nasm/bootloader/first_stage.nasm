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
	mov bx, booting_slot
	mov dl, [bx]
	int 0x13
	jc reset_disk_state;error was found
;then we will load data until finding the boot sector with the signature, 1 chunk at a time
mov cx, 0
find_booting_sector:
	mov si, dis_addr_packet
	mov bx, booting_slot
	mov dl, [bx]
	mov ah, 0x42
	int 0x13
	jc find_booting_sector; if error, retry

	call print_signature
	;cmp ax,0
	;je find_booting_sector
	jne hang
print_signature:
	mov ax, 0xb800
	mov es, ax
	mov bx, 0x400
	mov dx, bx
	mov cx, 512
	mov bx, 0
	print_signature_loop:
		push bx
		mov bx, dx
		mov al, [bx]
		pop bx
		mov byte [es:bx], al
		add bx, 2
		add dx, 1
	loop print_signature_loop
	mov ax, 0
	ret

call print_register



hang:jmp hang
hex_charset:db "0123456789ABCDEF"
print_register:;ax is the register to print, bx is the position to print to
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
	ret
dis_addr_packet:
	size:         db 0x10
	unused:       db 0
	sector_count: dw 0x0001
	offset:       dw 0
	segmt:        dw 0x800
	to_read_l:    dd 1
	to_read_h:    dd 0

TIMES(503 - ($ - $$)) db 0
signature:
db "scarlet"
booting_slot:
db 0x55
db 0xAA


