#ifndef K_STDIO_H
#define K_STDIO_H
#include "k_mmu.h"
typedef struct k_graphic_print
{
	char text;
	char color;
} k_graphic_print;

void k_put_c_pos(int pos, char color, char c);
void print_ull(int pos, char color, unsigned long long toPrint);
int k_print_s(int pos, char* toPrint, char color);
void k_print_usable_memory(int pos);
void k_putc(char c);
#endif