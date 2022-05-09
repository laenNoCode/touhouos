#include "head/k_mmu.h"

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