#include "head/k_stdio.h"
void k_putc(char c){
}

void k_put_c_pos(int pos, char color, char c){
	k_graphic_print* printing_pos = (k_graphic_print*) (0xb8000 + pos);
	printing_pos -> text = c;
	printing_pos -> color = color;
}
void print_ull(int pos, char color, unsigned long long toPrint){
	pos += 30;
	for (int i = 0; i < 16; i++){
		k_put_c_pos(pos, color, "0123456789ABCDEF"[toPrint % 16]);
		pos -= 2;
		toPrint /= 16;
	}
}
int k_print_s(int pos, char* toPrint, char color){
	while(*toPrint){
		k_put_c_pos(pos,color, *toPrint);
		pos += 2;
		toPrint++;
	}
}

void k_fill(int pos, char color, char c, int count){
	for (int i = 0; i < count; i++){
		k_put_c_pos(pos, color, c);
		pos += 2;
		} 
}

void k_print_usable_memory(int pos){
	k_memory_entry* mem_ptr = *((k_memory_entry**) (0x502));
	char color = 0x04;
	while (mem_ptr -> base_memory || mem_ptr -> length || mem_ptr -> memory_type)
	{
		k_fill(pos, 0x00, ' ', 80);
		print_ull(pos, color ,mem_ptr -> base_memory);
		pos += 32;
		k_put_c_pos(pos, color, '|');
		pos += 2;
		print_ull(pos, color ,mem_ptr -> length);
		pos += 32;
		k_put_c_pos(pos, color, '|');
		pos += 2;
		switch (mem_ptr -> memory_type)
		{
		case 1:
			k_print_s(pos, "USABLE\0", color);
			break;
		case 2:
			k_print_s(pos, "RESERVED\0", color);
			break;
		case 3:
			k_print_s(pos, "ACPI CLAIMABLE\0", color);
			break;
		case 4:
			k_print_s(pos, "ACPI NVS\0", color);
			break;
		case 5:
			k_print_s(pos, "BAD MEMORY\0", color);
			break;
		default:
			break;
		}
		pos += 32;
		k_put_c_pos(pos, color, '|');
		pos += 160 - 100;
		mem_ptr ++;
		/* code */
	}
	
}