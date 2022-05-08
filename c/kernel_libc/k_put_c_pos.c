#include "head/k_stdio.h"
int truc;
void k_putc(char c){
	k_put_c_pos(c, 2, 1);
	truc = 0xDEAD;
}

void k_put_c_pos(char c, char color, int pos){
	k_graphic_print* printing_pos = (k_graphic_print*) (0xb8000 + pos);
	printing_pos -> text = c;
	printing_pos -> color = color;
}