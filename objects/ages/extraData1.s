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
	obj_Interaction $ad $00 $42 $78
	obj_Interaction $a9 $03
	obj_Interaction $a9 $04
	obj_Interaction $a9 $05
	obj_End

; twinrovaCutscene_loadAngryFlames
objectData402f:
	obj_Interaction $a9 $06
	obj_Interaction $a9 $07
	obj_Interaction $a9 $08
	obj_End

; ???
objectData4037:
	obj_Interaction $75 $00 $a0 $70
	obj_Interaction $75 $05 $90 $50
	obj_Interaction $75 $06 $80 $c8
	obj_End

; Unused
objectData4045:
	obj_RandomEnemy $24 $32 $00
	obj_EndPointer

; Replenishable bombs
objectData_respawningBushBombs:
	obj_Interaction $c7 $04 $0f $14
	obj_EndPointer

; Replenishable ember seeds (unused)
objectData_respawningBushEmberSeeds:
	obj_Interaction $c7 $04 $0f $15
	obj_EndPointer

; Replenishable scent seeds
objectData_respawningBushScentSeeds:
	obj_Interaction $c7 $04 $0f $16
	obj_EndPointer

; Replenishable mystery seeds (unused)
objectData_respawningBushMysterySeeds:
	obj_Interaction $c7 $04 $0f $19
	obj_EndPointer

; Unused
objectData4062:
	obj_Interaction $c7 $a0 $06 $10
	obj_EndPointer

; Lightable torches
objectData_makeAllTorchesLightable:
	obj_Interaction $c7 $08 $06 $10
	obj_EndPointer
