[BITS 16]
mov ax, 0x800
mov ds, ax

print_hello:
	mov ax, 0xb800
	mov es, ax
	mov bx, 0
	push bx
	mov cx, 13
	mov bx, hello
	loop_print_hello:
		mov ax, [bx]
		mov dx, bx
		pop bx 
		mov [es:bx], al
		add bx, 2
		push bx
		mov bx, dx
		add bx, 1
	loop loop_print_hello
	jmp hang
hello: db "hello world !"

hang: jmp hang