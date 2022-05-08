#include "head/k_stdio.h"
void k_putc(char c){
	k_put_c_pos(c, 2, 1);
}

void k_put_c_pos(char c, char color, int pos){
	k_graphic_print* printing_pos = (k_graphic_print*) (0xb8000 + pos);
	printing_pos -> text = c;
	printing_pos -> color = color;
}
void print_ull(int pos, char color, unsigned long long toPrint){
	for (int i = 0; i < 16; i++){
		k_put_c_pos("0123456789ABCDEF"[toPrint % 16], color ,pos);
		pos += 2;
		toPrint /= 16;
	}
}
void k_print_usable_memory(int pos){
	k_memory_entry* mem_ptr = *((k_memory_entry**) (0x502));
	char color = 0x04;
	while (mem_ptr -> base_memory || mem_ptr -> length || mem_ptr -> memory_type)
	{
		print_ull(pos, color ,mem_ptr -> base_memory);
		pos += 32;
		k_put_c_pos('|', color, pos);
		pos += 2;
		print_ull(pos, color ,mem_ptr -> length);
		pos += 32;
		k_put_c_pos('|', color, pos);
		pos += 2;
		print_ull(pos, color ,mem_ptr -> memory_type);
		pos += 32;
		k_put_c_pos('|', color, pos);
		pos += 160 - 100;
		mem_ptr ++;
		/* code */
	}
	
}