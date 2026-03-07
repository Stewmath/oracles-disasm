; ==================================================================================================
; INTERAC_SUNKEN_CITY_BULLIES
; ==================================================================================================
interactionCode76:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld a,$01
	ld (de),a
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,@delete
	ld a,(wDimitriState)
	and $40
	jr z,@func_7375
	ld a,$03
	ld (de),a
	call func_745b
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld c,a
	ld hl,table_748f
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	ld a,c
	ld hl,table_7483
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,c
	ld hl,table_7495
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation
@func_7375:
	ld hl,$d101
	ld a,(hl)
	cp SPECIALOBJECT_DIMITRI
	jr nz,@delete
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_DIMITRI
	jr z,@delete
	ld a,(wDimitriState)
	bit 5,a
	jr z,@delete
	bit 4,a
	jr nz,@delete
	call func_745b
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld c,a
	ld hl,table_7489
	rst_addDoubleIndex
	ld e,$4b
	ldi a,(hl)
	ld (de),a
	ld e,$4d
	ldi a,(hl)
	ld (de),a
	ld a,c
	ld hl,table_7477
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	call z,func_743e
	ld a,$78
	ld ($cc85),a
	ret
@state2:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,+
	ld a,$01
+
	ld e,$77
	ld (de),a
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call interactionRunScript
	ld e,$4b
	ld a,(de)
	bit 7,a
	ret z
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	cp $01
	jr nz,@delete
	xor a
	ld ($cba0),a
	ld ($cca4),a
	ld ($cc02),a
@delete:
	jp interactionDelete
@state3:
	ld a,($cd00)
	and $0e
	ret nz
	call interactionAnimateAsNpc
	jr ++
@state1:
	ld a,($cd00)
	and $0e
	ret nz
	call interactionAnimateAsNpc
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	call z,func_743e
	ld a,(wDimitriState)
	and $08
	jr nz,func_742a
++
	ld a,($c4ab)
	or a
	ret nz
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,++
	ld a,$c0
	ld e,$5a
	ld (de),a
	ld a,$01
++
	ld e,$77
	ld (de),a
	jp interactionRunScript
func_742a:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	ld hl,table_747d
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
func_743e:
	xor a
	ld e,$78
	ld (de),a
	ld hl,wNumBombs
	ld a,(hl)
	or a
	jr z,+
	ld a,$01
	ld e,$78
	ld (de),a
+
	ld e,$79
	ld a,(de)
	or a
	ret z
	xor a
	ld (de),a
	xor a
	ld (hl),a
	call setStatusBarNeedsRefreshBit1
	ret
func_745b:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionAnimateAsNpc
	ld h,d
	ld l,$66
	ld a,$06
	ldi (hl),a
	ld a,$06
	ld (hl),a
	ld l,$50
	ld a,$32
	ld (hl),a
	ld a,>TX_2100
	jp interactionSetHighTextIndex
table_7477:
	.dw mainScripts.sunkenCityBulliesScript1_bully1
	.dw mainScripts.sunkenCityBulliesScript1_bully2
	.dw mainScripts.sunkenCityBulliesScript1_bully3
table_747d:
	.dw mainScripts.sunkenCityBulliesScript2_bully1
	.dw mainScripts.sunkenCityBulliesScript2_bully2
	.dw mainScripts.sunkenCityBulliesScript2_bully3
table_7483:
	.dw mainScripts.sunkenCityBulliesScript3_bully1
	.dw mainScripts.sunkenCityBulliesScript3_bully2
	.dw mainScripts.sunkenCityBulliesScript3_bully3
table_7489:
	.db $38 $58
	.db $38 $68
	.db $28 $48
table_748f:
	.db $38 $48
	.db $38 $58
	.db $58 $48
table_7495:
	; animation
	.db $02 $02 $00
