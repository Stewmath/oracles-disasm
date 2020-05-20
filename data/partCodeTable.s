partCodeTable:
.ifdef ROM_AGES
	.dw partCode00 ; 0x00
	.dw partCode01 ; 0x01
	.dw partCode02 ; 0x02
	.dw partCode03 ; 0x03
	.dw partCode04 ; 0x04
	.dw partCode05 ; 0x05
	.dw partCode06 ; 0x06
	.dw partCode07 ; 0x07
	.dw partCode08 ; 0x08
	.dw partCode09 ; 0x09
	.dw partCodeNil ; 0x0a
	.dw partCode0b ; 0x0b
	.dw partCode0c ; 0x0c
	.dw partCodeNil ; 0x0d
	.dw partCode0e ; 0x0e
	.dw partCode0f ; 0x0f
	.dw partCode10 ; 0x10
	.dw partCode11 ; 0x11
	.dw partCode12 ; 0x12
	.dw partCode13 ; 0x13
	.dw partCode14 ; 0x14
	.dw partCode15 ; 0x15
	.dw partCode16 ; 0x16
	.dw partCode17 ; 0x17
	.dw partCode18 ; 0x18
	.dw partCode19 ; 0x19
	.dw partCode1a ; 0x1a
	.dw partCode1b ; 0x1b
	.dw partCode1c ; 0x1c
	.dw partCode1d ; 0x1d
	.dw partCode1e ; 0x1e
	.dw partCode1f ; 0x1f
	.dw partCode20 ; 0x20
	.dw partCode21 ; 0x21
	.dw partCode22 ; 0x22
	.dw partCode23 ; 0x23
	.dw partCode24 ; 0x24
	.dw partCode25 ; 0x25
	.dw partCode26 ; 0x26
	.dw partCode27 ; 0x27
	.dw partCode28 ; 0x28
	.dw partCode29 ; 0x29
	.dw partCode2a ; 0x2a
	.dw partCode2b ; 0x2b
	.dw partCode2c ; 0x2c
	.dw partCode2d ; 0x2d
	.dw partCode2e ; 0x2e
	.dw partCode2f ; 0x2f
	.dw partCode30 ; 0x30
	.dw partCode31 ; 0x31
	.dw partCode32 ; 0x32
	.dw partCode33 ; 0x33
	.dw partCode34 ; 0x34
	.dw partCode35 ; 0x35
	.dw partCode36 ; 0x36
	.dw partCode37 ; 0x37
	.dw partCode38 ; 0x38
	.dw partCode39 ; 0x39
	.dw partCode3a ; 0x3a
	.dw partCode3b ; 0x3b
	.dw partCode3c ; 0x3c
	.dw partCode3d ; 0x3d
	.dw partCode3e ; 0x3e
	.dw partCode3f ; 0x3f
	.dw partCode40 ; 0x40
	.dw partCode41 ; 0x41
	.dw partCode42 ; 0x42
	.dw partCode43 ; 0x43
	.dw partCode44 ; 0x44
	.dw partCode45 ; 0x45
	.dw partCode46 ; 0x46
	.dw partCode47 ; 0x47
	.dw partCode48 ; 0x48
	.dw partCode49 ; 0x49
	.dw partCode4a ; 0x4a
	.dw partCode4b ; 0x4b
	.dw partCode4c ; 0x4c
	.dw partCode4d ; 0x4d
	.dw partCode4e ; 0x4e
	.dw partCode4f ; 0x4f
	.dw partCode50 ; 0x50
	.dw partCode51 ; 0x51
	.dw partCode52 ; 0x52
	.dw partCode53 ; 0x53
	.dw partCode54 ; 0x54
	.dw partCode55 ; 0x55
	.dw partCode56 ; 0x56
	.dw partCode57 ; 0x57
	.dw partCode58 ; 0x58
	.dw partCode59 ; 0x59
	.dw partCode5a ; 0x5a
.else
	.dw partCode00
	.dw partCode01
	.dw partCode02
	.dw partCode03
	.dw partCode04
	.dw partCode05
	.dw partCode06
	.dw partCode07
	.dw partCode08
	.dw partCode09
	.dw partCode0a
	.dw partCode0b
	.dw partCode0c
	.dw partCode0d
	.dw partCode0e
	.dw partCode0f
	.dw partCode10
	.dw partCode11
	.dw partCode12
	.dw partCode13
	.dw partCode14
	.dw partCode15
	.dw partCode16
	.dw partCode17
	.dw partCode18
	.dw partCode19
	.dw partCode1a
	.dw partCode1b
	.dw partCode1c
	.dw partCode1d
	.dw partCode1e
	.dw partCode1f
	.dw partCode20
	.dw partCode21
	.dw partCode22
	.dw partCode23
	.dw partCode24
	.dw partCode25
	.dw partCode26
	.dw partCode27
	.dw partCode28
	.dw partCode29
	.dw partCode2a
	.dw partCode2b
	.dw partCode2c
	.dw partCode2d
	.dw partCode2e
	.dw partCode2f
	.dw partCode30
	.dw partCode31
	.dw partCode32
	.dw partCode33
	.dw partCodeNil
	.dw partCodeNil
	.dw partCodeNil
	.dw partCodeNil
	.dw partCode38
	.dw partCode39
	.dw partCode3a
	.dw partCode3b
	.dw partCode3c
	.dw partCode3d
	.dw partCode3e
	.dw partCode3f
	.dw partCode40
	.dw partCode41
	.dw partCode42
	.dw partCode43
	.dw partCode44
	.dw partCode45
	.dw partCode46
	.dw partCode47
	.dw partCode48
	.dw partCode49
	.dw partCode4a
	.dw partCode4b
	.dw partCode4c
	.dw partCode4d
	.dw partCode4e
	.dw partCode4f
	.dw partCode50
	.dw partCode51
	.dw partCode52
	.dw partCode53
.endif

;;
partCodeNil:
	ret

;;
partCode00:
	jp partDelete
