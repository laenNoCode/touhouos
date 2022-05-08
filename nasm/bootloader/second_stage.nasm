[BITS 16]
;first, let's set the segment so that the code variables are properly located
%define PMODE_0_Location 0x1000	
mov ax, 0x800
mov ds, ax
;then, let's activate the A20 line
call check_a20
cmp al,1
je A20_end
call enable_A20
call check_a20

A20_end:

	jmp A20_enabled
enable_A20:
	cli

	call    a20wait
	mov     al,0xAD
	out     0x64,al

	call    a20wait
	mov     al,0xD0
	out     0x64,al

	call    a20wait2
	in      al,0x60
	push    ax

	call    a20wait
	mov     al,0xD1
	out     0x64,al

	call    a20wait
	pop     ax
	or      al,2
	out     0x60,al

	call    a20wait
	mov     al,0xAE
	out     0x64,al

	call    a20wait
	sti
	ret
 
a20wait:
	in      al,0x64
	test    al,2
	jnz     a20wait
	ret
 
 
a20wait2:
	in      al,0x64
	test    al,1
	jz      a20wait2
	ret
check_a20:
	push ds
	push es
	push di
	push si
	cli

	xor ax, ax ; ax = 0
	mov es, ax

	not ax ; ax = 0xFFFF
	mov ds, ax

	mov di, 0x0500
	mov si, 0x0510

	mov al, byte [es:di]
	push ax

	mov al, byte [ds:si]
	push ax

	mov byte [es:di], 0x00
	mov byte [ds:si], 0xFF

	cmp byte [es:di], 0xFF

	pop ax
	mov byte [ds:si], al

	pop ax
	mov byte [es:di], al

	mov ax, 0
	je check_a20__exit

	mov ax, 1
 
check_a20__exit:

	pop si
	pop di
	pop es
	pop ds
	ret

A20_enabled:
	lgdt [BASIC_GDT_POINTER]
	mov al, 0x03
	mov bx, hello
	mov dx, 0
	call print_string
	call load_memory_map
	call jump_to_pmode_0
	jmp hang
	;TODO : Jump to PMODE
print_string:
	push ax
	mov ax, 0xB800
	mov es, ax
	pop ax
	mov ah, al
	loop_print_string:
		mov al, [bx]
		cmp al,0
		je ret_print_string
		push bx
			mov bx, dx
			mov [es : bx], ax
		pop bx
		add bx, 1
		add dx, 2
	jmp loop_print_string
	ret_print_string:
	ret
hello: db "hello, wellcome to TouhouOS ", VERSION ,", currently in second stage Bootloader",0
hang: jmp hang

BASIC_GDT:
db 0, 0, 0, 0, 0, 0, 0, 0
db 0xff, 0xff, 0, 0, 0, 0b10011010, 0b11001111, 0; code segment, 0x08, ring 0
db 0xff, 0xff, 0, 0, 0, 0b10010010, 0b11001111, 0; data segment, 0x10, ring 0
db 0xff, 0xff, 0, 0, 0, 0b11111010, 0b11001111, 0; code segment, 0x18, ring 3 HAS TO BE UPDATED so user can't modify kernel at runtime
db 0xff, 0xff, 0, 0, 0, 0b11110010, 0b11001111, 0; data segment, 0x20, ring 3 or paging must be put in place
BASIC_GDT_POINTER:
	dw BASIC_GDT_POINTER - BASIC_GDT - 1
	dd BASIC_GDT + 0x8000
jump_to_pmode_0:
	mov eax, cr0
	or eax,1
	mov cr0, eax
	jmp 0x08:0x8400
load_memory_map:
	mov ax, 0x60
	mov es, ax
	mov di, 0
	mov eax, 0xE820
	mov ebx, 0
	mov ecx, 24
	mov edx, 0x534D4150
	int 0x15
	load_memory_map_loop:
		add di, 24
		jc load_memory_map_end
		cmp ebx, 0
		je load_memory_map_end
		mov eax, 0xE820
		mov ecx, 24
		int 0x15
		jmp load_memory_map_loop
	load_memory_map_end:
	mov cx, 24
	load_memory_map_fill_null:
		mov byte [es:di], 0
		add di,1
	loop load_memory_map_fill_null
	mov ax, 0x50
	mov es, ax
	mov word [es:0x02], 0x600
	ret
TIMES(1024 - ($ - $$)) db 0