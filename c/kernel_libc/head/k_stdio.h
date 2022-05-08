typedef struct k_graphic_print
{
	char text;
	char color;
} k_graphic_print;
typedef struct k_memory_entry{
	unsigned long long base_memory;
	unsigned long long length;
	int memory_type;
	int ACPI_30;
} k_memory_entry;
void k_put_c_pos(char c, char color, int pos);
void k_putc(char c);