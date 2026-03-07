; These are 8 "sparkles" created for the cutscene where a chest appears after telling
; a secret to Farore.
objectData_faroreSparkle:
	obj_Interaction $11 $01 $78 $58
	obj_Interaction $11 $11 $78 $58
	obj_Interaction $11 $21 $78 $58
	obj_Interaction $11 $31 $78 $58
	obj_Interaction $11 $41 $78 $58
	obj_Interaction $11 $51 $78 $58
	obj_Interaction $11 $61 $78 $58
	obj_Interaction $11 $71 $78 $58
	obj_End

; twinrovaCutscene_state1
objectData4022:
	obj_Interaction $44 $00 $42 $78
	obj_Interaction $b0 $08
	obj_Interaction $b0 $09
	obj_Interaction $b0 $0a
	obj_End

; twinrovaCutscene_loadAngryFlames
objectData402f:
	obj_Interaction $b0 $0b
	obj_Interaction $b0 $0c
	obj_Interaction $b0 $0d
	obj_End

; ???
objectData4037:
	obj_RandomEnemy $24 $32 $00
	obj_EndPointer

; Replenishable bombs
objectData_respawningBushBombs:
	obj_Interaction $c7 $04 $0f $14
	obj_EndPointer

; Replenishable ember seeds
objectData_respawningBushEmberSeeds:
	obj_Interaction $c7 $04 $0f $15
	obj_EndPointer

; Replenishable mystery seeds
objectData_respawningBushMysterySeeds:
	obj_Interaction $c7 $04 $0f $19
	obj_EndPointer


; Damaging cacti
objectData_makeCactiDamaging:
	obj_Interaction $c7 $bc $2f $10
	obj_EndPointer

; Unused
objectData4054:
	obj_Interaction $c7 $a0 $06 $10
	obj_EndPointer

; Lightable torches
objectData_makeAllTorchesLightable:
	obj_Interaction $c7 $08 $06 $10
	obj_EndPointer
