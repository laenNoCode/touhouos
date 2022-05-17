#ifndef K_MMU_C
#define K_MMU_C
#define K_BASIC_MMAP_POS 0x502
typedef struct k_memory_entry{
	unsigned long long base_memory;
	unsigned long long length;
	int memory_type;
	int ACPI_30;
} k_memory_entry;

typedef struct k_memory_map_entry_PMODE{
	unsigned int v_ptr;
	unsigned int p_ptr;
	unsigned int size;
	int is_free  : 1;
	int is_exec  : 1;
	int is_uland : 1;
} k_memory_map_entry_PMODE;

void relocate_memory_table(void* newLocation);

#endif