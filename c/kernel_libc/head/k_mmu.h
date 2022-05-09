#ifndef K_MMU_C
#define K_MMU_C
#define K_BASIC_MMAP_POS 0x502
typedef struct k_memory_entry{
	unsigned long long base_memory;
	unsigned long long length;
	int memory_type;
	int ACPI_30;
} k_memory_entry;

void relocate_memory_table(void* newLocation);

#endif