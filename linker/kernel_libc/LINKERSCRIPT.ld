SECTIONS{
	. = 0x8200;
	.text :{
		*(.text)
	} 
}
OUTPUT_FORMAT(binary)
