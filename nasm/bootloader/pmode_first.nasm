[BITS 32]
extern k_print_usable_memory
extern relocate_memory_table
extern print_ull
section .kernel_code
mov eax, 0x10
mov ss, eax
mov ds, eax
mov es, eax
mov esp, 0x0007FFFF
mov ebp, 0x0007FFFF;new stack in the same place as older rmode, before having a proper memap setted up
mov ebx, hello
mov edx, 160
mov al, 0x03
call print_string
mov eax, 0x100000
push eax
call relocate_memory_table
pop eax
mov eax, [0x100000]
push eax
mov eax, 0x03
push eax
mov eax, 480
push eax
call print_ull

pop eax
pop eax
pop eax

mov eax, 480
push eax
call k_print_usable_memory
pop eax
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