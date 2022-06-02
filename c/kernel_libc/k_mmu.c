#include "head/k_mmu.h"
#include "head/k_stdio.h"
void relocate_memory_table(void* newLocation){
	k_memory_entry* actual_location = *((k_memory_entry**) (K_BASIC_MMAP_POS));
	k_memory_entry* new_location = (k_memory_entry*) newLocation;
	while(actual_location -> base_memory || actual_location -> length || actual_location -> memory_type)
	{
		*new_location = *actual_location;
		actual_location++;
		new_location++;
	}
	*((k_memory_entry**) (K_BASIC_MMAP_POS)) = (k_memory_entry*) (newLocation);
}
void relocate_kernel(void* actualLocation, int k_size_bytes){
	k_memory_entry* availibleLocations = *((k_memory_entry**) K_BASIC_MMAP_POS);
	int location = 0;
	int k_size_int = k_size_bytes / 4 + ((k_size_bytes % 4) > 0);
	int* actualLocationInt = (int*) actualLocation;
	
	//requires at least 10MB in order to load itself, this will be corrected later
	while (availibleLocations[location].length < 10000000 || availibleLocations[location].base_memory< 0x10000 || availibleLocations->memory_type != 1)
	{
		location++;
	}
	print_ull((3 + location)*160, 0x02, availibleLocations[location].base_memory);
	print_ull((3 + location)*160 + 34, 0x02, availibleLocations[location].length);
	k_print_s((3 + location)*160 + 68, "SELECTED" ,0x02);
	
	int* targetLocation = ((int*) ((long)availibleLocations[location].base_memory));
	for (int i = 0; i < k_size_int; i++)
	{
		targetLocation[i] = actualLocationInt[i];
	}
	*((void**) K_MEMORY_BASE_PTR) = (void*) targetLocation;
}
void k_reloaction_acknowledge(){
	k_print_s(160*12, "relocated kernel at position\0", 0x05);
	print_ull(160*12 + 32*2, 0x05, (int)*((void**) K_MEMORY_BASE_PTR));
}