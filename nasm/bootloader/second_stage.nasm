[BITS 16]
;first, let's set the segment so that the code variables are properly located
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
	jmp hang
	;TODO : Jump to PMODE

hang: jmp hang