.ifdef INCLUDE_GARBAGE

.ifdef REGION_US
; Garbage function here (partial repeat of the above function)

;;
func_7fa1:
	call $258f
	ret nc
	jp $3b5c
.endif ; REGION_US

.ifdef REGION_JP
	; TODO : analyze this garbage data.
	.db $b0 $80 $64 $7f $98 $04 $7f $5b
	.db $98 $07 $97 $07 $83 $14 $78 $4b
	.db $d7 $32 $00
.endif ; REGION_JP

.endif