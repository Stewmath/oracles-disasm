objectTable2:
.dw objectData7705
.dw objectData7717
.dw objectData771b
.dw objectData7725
.dw objectData7733
.dw objectData7741
.dw objectData774b
.dw objectData7733
.dw objectData5462
.dw objectData5470
.dw objectData5416
.dw objectData55a2
.dw objectData543c
.dw objectData774f
.dw objectData7761
.dw objectData7765
.dw objectData776f
.dw objectData5492
.dw objectData777c
.dw objectData7792

objectData7705:
	obj_DoubleValue $3a00 $42 $78
	obj_DoubleValue $4401 $42 $78
	obj_DoubleValue $3b00 $42 $68
	obj_DoubleValue $6b05 $48 $88
	obj_End

objectData7717:
	obj_NoValue $3901
	obj_End

objectData771b:
	obj_DoubleValue $3c01 $48 $78
	obj_DoubleValue $3d01 $28 $68
	obj_End

objectData7725:
	obj_DoubleValue $3702 $28 $48
	obj_DoubleValue $3101 $68 $38
	obj_DoubleValue $e140 $28 $28
	obj_End

objectData7733:
	obj_DoubleValue $8703 $40 $50
	obj_DoubleValue $3704 $56 $38
	obj_DoubleValue $3602 $48 $50
	obj_End

objectData7741:
	obj_DoubleValue $3c05 $48 $38
	obj_DoubleValue $3d03 $48 $48
	obj_End

objectData774b:
	obj_NoValue $3904
	obj_End

objectData774f:
	obj_DoubleValue $3c06 $48 $78
	obj_DoubleValue $9500 $4a $75
	obj_DoubleValue $3a09 $48 $38
	obj_DoubleValue $4303 $28 $78
	obj_End

objectData7761:
	obj_NoValue $4b02
	obj_End

objectData7765:
	obj_DoubleValue $4d04 $4f $78
	obj_DoubleValue $8408 $4f $78
	obj_End

objectData776f:
	obj_DoubleValue $b000 $60 $88
	obj_DoubleValue $b001 $60 $68
	obj_NoValue $a904
	obj_End

objectData777c:
	obj_DoubleValue $3c0a $48 $48
	obj_DoubleValue $3a0a $48 $38
	obj_DoubleValue $4304 $28 $78
	obj_DoubleValue $ad05 $e8 $58
	obj_DoubleValue $3106 $e8 $68
	obj_End

objectData7792:
	obj_DoubleValue $9306 $43 $2d
	obj_End

objectData7798:
	obj_NoValue $dc09
	obj_NoValue $dc0a
	obj_WithParam $00 $8a00 $09 $00 $00
	obj_End

objectData77a5:
	obj_WithParam $02 $2700 $00 $24 $50
	obj_DoubleValue $8d02 $28 $50
	obj_End

objectData77b2:
	obj_NoValue $9304
	obj_End

objectData77b6:
	obj_DoubleValue $b002 $50 $80
	obj_DoubleValue $b003 $50 $70
	obj_NoValue $a901
	obj_End

moonlitGrotto_orb:
	obj_Part $0304 $75
	obj_End

moonlitGrotto_onOrbActivation:
	obj_DoubleValue $1202 $68 $98
	obj_SpecificEnemy $00 $1d00 $26 $a0
	obj_End

objectData77d4:
	obj_DoubleValue $1e06 $a3 $00
	obj_End

moonlitGrotto_onArmosSwitchPressed:
	obj_DoubleValue $1201 $58 $58
	obj_SpecificEnemy $00 $1d00 $26 $a0
	obj_End

impaOctoroks:
	obj_WithParam $00 $3200 $00 $18 $48
	obj_WithParam $00 $3200 $01 $38 $38
	obj_WithParam $00 $3200 $02 $38 $58
	obj_End

ambisPalaceEntranceGuards:
	obj_DoubleValue $4007 $28 $48
	obj_DoubleValue $4002 $28 $58
	obj_End

; Spawned in with the bear (ID $5d02, var03=0); animals on screen where Nayru is
; kidnapped, waiting for her to return.
animalsWaitingForNayru:
	obj_WithParam $00 $3907 $00 $28 $88
	obj_WithParam $00 $4b07 $00 $48 $78
	obj_WithParam $00 $3907 $02 $38 $58
	obj_End

objectData7818:
	obj_WithParam $00 $6601 $00 $40 $28
	obj_WithParam $00 $6601 $01 $40 $78
	obj_WithParam $00 $6601 $02 $68 $28
	obj_WithParam $00 $6601 $03 $28 $28
	obj_WithParam $00 $6601 $04 $28 $50
	obj_WithParam $00 $6601 $05 $28 $78
	obj_WithParam $00 $6601 $06 $68 $78
	obj_End

objectData7844:
	obj_WithParam $00 $4e01 $00 $40 $28
	obj_WithParam $00 $4e01 $01 $40 $78
	obj_WithParam $00 $4e01 $02 $68 $28
	obj_WithParam $00 $4e01 $03 $28 $28
	obj_WithParam $00 $4e01 $04 $28 $50
	obj_WithParam $00 $4e01 $05 $28 $78
	obj_WithParam $00 $4e01 $06 $68 $78
	obj_End

objectData7870:
	obj_Pointer objectData7874
	obj_End

objectData7874:
	obj_SpecificEnemy $00 $6300 $00 $00
	obj_SpecificEnemy     $6301 $00 $00
	obj_SpecificEnemy     $6302 $00 $00
	obj_SpecificEnemy     $6303 $00 $00
	obj_SpecificEnemy     $6304 $00 $00
	obj_EndPointer

objectData788b:
	obj_DoubleValue $3600 $18 $78
	obj_DoubleValue $3700 $30 $88
	obj_DoubleValue $5d00 $28 $58
	obj_DoubleValue $3900 $50 $78
	obj_DoubleValue $4b00 $50 $88
	obj_DoubleValue $3c00 $48 $68
	obj_DoubleValue $4c00 $2c $48
	obj_End

objectData78a9:
	obj_DoubleValue $9600 $30 $68
	obj_DoubleValue $9601 $30 $38
	obj_End

objectData78b3:
	obj_DoubleValue $4d08 $28 $48
	obj_DoubleValue $360e $28 $58
	obj_End

objectTable3:
.dw objectData78c5
.dw objectData78c5
.dw objectData78cb
.dw objectData78d1

objectData78c5:
	obj_DoubleValue $480c $f8 $18
	obj_End

objectData78cb:
	obj_DoubleValue $480c $f8 $88
	obj_End

objectData78d1:
	obj_DoubleValue $480c $f8 $18
	obj_DoubleValue $480c $f8 $88
	obj_End

objectData78db:
	obj_RandomEnemy $81 $1001
	obj_End

objectData78e0:
	obj_Pointer objectData4068
	obj_End

