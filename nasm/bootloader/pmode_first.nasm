[BITS 32]
section .text
mov eax, 0x10
mov ss, eax
mov ds, eax
mov es, eax
mov esp, 0x0007FFFF
mov ebp, 0x0007FFFF;new stack in the same place as older rmode, before having a proper memap setted up
mov ebx, hello + 0x8400
mov edx, 160
mov al, 0x03
call print_string
jmp hang

;eax will contain the pointer to the memory map
print_memory_map:

print_number:


print_string:
	push ebx
	push edx
	add edx, 0xb8000
	mov ah, al
	loop_print_string:
		mov al, [ebx]
		cmp al,0
		je ret_print_string
		push ebx
			mov ebx, edx
			mov [ebx], ax
		pop ebx
		add ebx, 1
		add edx, 2
	jmp loop_print_string
	ret_print_string:
	pop edx
	pop ebx
	ret
hello: db "hello, wellcome to TouhouOS ", VERSION ,", currently in first pmode stage",0
hang: jmp hang
TIMES(2048 - ($ - $$)) db 0