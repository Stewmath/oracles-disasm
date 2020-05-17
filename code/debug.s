; Code jumps here when something unexpected happens
panic:
	ld bc,TX_0a04
	jp showText
