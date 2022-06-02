#ifndef K_MMU_C
#define K_MMU_C
#define K_BASIC_MMAP_POS 0x502
//letting a bit of empty space just in case, could be 0x50A
#define K_MEMORY_BASE_PTR 0x510
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
void relocate_kernel(void* actualLocation, int k_size);//this is really like k_memmove, but k_libc will be implemented later
void k_reloaction_acknowledge();
#endif