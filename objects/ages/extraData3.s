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
	.dw blackTowerEscape_ambiAndGuards
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
	obj_Interaction $3a00 $42 $78
	obj_Interaction $4401 $42 $78
	obj_Interaction $3b00 $42 $68
	obj_Interaction $6b05 $48 $88
	obj_End

objectData7717:
	obj_Interaction $3901
	obj_End

objectData771b:
	obj_Interaction $3c01 $48 $78
	obj_Interaction $3d01 $28 $68
	obj_End

objectData7725:
	obj_Interaction $3702 $28 $48
	obj_Interaction $3101 $68 $38
	obj_Interaction $e140 $28 $28
	obj_End

objectData7733:
	obj_Interaction $8703 $40 $50
	obj_Interaction $3704 $56 $38
	obj_Interaction $3602 $48 $50
	obj_End

objectData7741:
	obj_Interaction $3c05 $48 $38
	obj_Interaction $3d03 $48 $48
	obj_End

objectData774b:
	obj_Interaction $3904
	obj_End

objectData774f:
	obj_Interaction $3c06 $48 $78
	obj_Interaction $9500 $4a $75
	obj_Interaction $3a09 $48 $38
	obj_Interaction $4303 $28 $78
	obj_End

objectData7761:
	obj_Interaction $4b02
	obj_End

objectData7765:
	obj_Interaction $4d04 $4f $78
	obj_Interaction $8408 $4f $78
	obj_End

objectData776f:
	obj_Interaction $b000 $60 $88
	obj_Interaction $b001 $60 $68
	obj_Interaction $a904
	obj_End

objectData777c:
	obj_Interaction $3c0a $48 $48
	obj_Interaction $3a0a $48 $38
	obj_Interaction $4304 $28 $78
	obj_Interaction $ad05 $e8 $58
	obj_Interaction $3106 $e8 $68
	obj_End

objectData7792:
	obj_Interaction $9306 $43 $2d
	obj_End

objectData7798:
	obj_Interaction $dc09
	obj_Interaction $dc0a
	obj_Interaction $8a00 $00 $00 $09
	obj_End

objectData77a5:
	obj_Part $2700 $24 $50 $00
	obj_Interaction $8d02 $28 $50
	obj_End

objectData77b2:
	obj_Interaction $9304
	obj_End

objectData77b6:
	obj_Interaction $b002 $50 $80
	obj_Interaction $b003 $50 $70
	obj_Interaction $a901
	obj_End

moonlitGrotto_orb:
	obj_Part $0304 $75
	obj_End

moonlitGrotto_onOrbActivation:
	obj_Interaction $1202 $68 $98
	obj_SpecificEnemyA $00 $1d00 $26 $a0
	obj_End

objectData77d4:
	obj_Interaction $1e06 $a3 $00
	obj_End

moonlitGrotto_onArmosSwitchPressed:
	obj_Interaction $1201 $58 $58
	obj_SpecificEnemyA $00 $1d00 $26 $a0
	obj_End

impaOctoroks:
	obj_Interaction $3200 $18 $48 $00
	obj_Interaction $3200 $38 $38 $01
	obj_Interaction $3200 $38 $58 $02
	obj_End

ambisPalaceEntranceGuards:
	obj_Interaction $4007 $28 $48
	obj_Interaction $4002 $28 $58
	obj_End

; Spawned in with the bear (ID $5d02, var03=0); animals on screen where Nayru is
; kidnapped, waiting for her to return.
animalsWaitingForNayru:
	obj_Interaction $3907 $28 $88 $00
	obj_Interaction $4b07 $48 $78 $00
	obj_Interaction $3907 $38 $58 $02
	obj_End

goronDancers:
	obj_Interaction $6601 $40 $28 $00
	obj_Interaction $6601 $40 $78 $01
	obj_Interaction $6601 $68 $28 $02
	obj_Interaction $6601 $28 $28 $03
	obj_Interaction $6601 $28 $50 $04
	obj_Interaction $6601 $28 $78 $05
	obj_Interaction $6601 $68 $78 $06
	obj_End

; Subrosians take the place of goron dancers in the past (linked game)
subrosianDancers:
	obj_Interaction $4e01 $40 $28 $00
	obj_Interaction $4e01 $40 $78 $01
	obj_Interaction $4e01 $68 $28 $02
	obj_Interaction $4e01 $28 $28 $03
	obj_Interaction $4e01 $28 $50 $04
	obj_Interaction $4e01 $28 $78 $05
	obj_Interaction $4e01 $68 $78 $06
	obj_End

targetCartCrystals:
	obj_Pointer @crystals
	obj_End

@crystals:
	obj_SpecificEnemyA $00 $6300 $00 $00
	obj_SpecificEnemyA     $6301 $00 $00
	obj_SpecificEnemyA     $6302 $00 $00
	obj_SpecificEnemyA     $6303 $00 $00
	obj_SpecificEnemyA     $6304 $00 $00
	obj_EndPointer

nayruAndAnimalsInIntro:
	obj_Interaction $3600 $18 $78
	obj_Interaction $3700 $30 $88
	obj_Interaction $5d00 $28 $58
	obj_Interaction $3900 $50 $78
	obj_Interaction $4b00 $50 $88
	obj_Interaction $3c00 $48 $68
	obj_Interaction $4c00 $2c $48
	obj_End

moblinsAttackingMakuSprout:
	obj_Interaction $9600 $30 $68
	obj_Interaction $9601 $30 $38
	obj_End

ambiAndNayruInPostD3Cutscene:
	obj_Interaction $4d08 $28 $48
	obj_Interaction $360e $28 $58
	obj_End

wildTokayObjectTable:
	.dw @tokayFromLeft
	.dw @tokayFromLeft
	.dw @tokayFromRight
	.dw @tokayOnBothSides

@tokayFromLeft:
	obj_Interaction $480c $f8 $18
	obj_End

@tokayFromRight:
	obj_Interaction $480c $f8 $88
	obj_End

@tokayOnBothSides:
	obj_Interaction $480c $f8 $18
	obj_Interaction $480c $f8 $88
	obj_End

objectData78db:
	obj_RandomEnemy $81 $1001
	obj_End

objectData_makeTorchesLightableForD6Room:
	obj_Pointer objectData_makeAllTorchesLightable
	obj_End

