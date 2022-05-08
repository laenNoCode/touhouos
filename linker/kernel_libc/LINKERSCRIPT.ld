SECTIONS{
	. = 0x8400;
	.kernel_code : {
		*(.kernel_code)
	}
	.text :{
		*(.text)
	} 
}
OUTPUT_FORMAT(binary)

