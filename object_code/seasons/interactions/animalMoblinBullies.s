; ==================================================================================================
; INTERAC_ANIMAL_MOBLIN_BULLIES
; ==================================================================================================
interactionCode73:
	ld h,d
	ld l,$42
	ldi a,(hl)
	or a
	jr nz,@func_7078
	inc l
	ld a,(hl)
	or a
	jr z,@func_7078
	ld a,($cd00)
	and $0e
	jr z,@func_7078
	ld a,$3c
	ld (wInstrumentsDisabledCounter),a
	ret
@func_7078:
	ld e,$44
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_RICKY
	or a
	jr z,@func_70fd_delete
	cp SPECIALOBJECT_MOOSH
	jr z,@moosh
	ld a,(de)
	rst_jumpTable
	; Dimitri
	.dw @state0
	.dw @dimitriState1
	.dw @dimitriState2
@moosh:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @mooshState1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld hl,$d101
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_MOOSH
	jr z,@func_70c1
	cp SPECIALOBJECT_DIMITRI
	jr nz,@func_70fd_delete
	; companion is dimitri
	cp (hl)
	jr nz,@func_70fd_delete
	ld a,(wDimitriState)
	and $88
	jr nz,@func_70fd_delete
	call @func_71ac
	ld hl,@table_71cd
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jr @func_70f3
@func_70c1:
	cp (hl)
	jr nz,@func_70fd_delete
	ld a,(wMooshState)
	bit 5,a
	jr nz,@func_70fd_delete
	bit 7,a
	jr nz,@func_70fd_delete
	bit 2,a
	jr nz,@func_70fd_delete
	and $03
	jr z,+
	ld h,d
	ld l,$42
	ld a,(hl)
	or a
	jr nz,+
	ld l,$4b
	ld (hl),$28
	ld l,$4d
	ld (hl),$a8
+
	call @func_71ac
	ld hl,@table_71d9
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
@func_70f3:
	call interactionAnimateAsNpc
	call objectCheckWithinScreenBoundary
	ret c
	jp objectSetInvisible
@func_70fd_delete:
	jp interactionDelete
@dimitriState1:
	call interactionAnimateAsNpc
	ld e,Interaction.subid
	ld a,(de)
	and $1f
	call z,@func_7183
	ld a,(wDimitriState)
	and $08
	jr nz,@func_7131
	ld a,($c4ab)
	or a
	ret nz
	call @func_71c0
	ld e,$71
	ld a,(de)
	or a
	jr z,+
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	dec e
	ld (de),a
	call interactionSetAnimation
+
	jp interactionRunScript
@func_7131:
	ld a,$01
	ld ($cca4),a
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@table_71d3
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
@dimitriState2:
	call @func_71c0
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	call interactionRunScript
	ret nc
@func_7155:
	jr @func_70fd_delete
@mooshState1:
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	ld a,($c4ab)
	or a
	ret nz
	ld a,(wNumEnemies)
	or a
	jr z,+
	ld a,$01
+
	ld e,$7b
	ld (de),a
	call @func_71c0
	call objectCheckWithinScreenBoundary
	jr nc,+
	call objectSetVisible
	jr ++
+
	call objectSetInvisible
++
	call interactionRunScript
	jr c,@func_7155
	ret
@func_7183:
	xor a
	ld e,$78
	ld (de),a
	inc e
	ld (de),a
	ld a,RUPEEVAL_030
	call cpRupeeValue
	jr nz,+
	ld e,$78
	ld a,$01
	ld (de),a
	ld a,RUPEEVAL_050
	call cpRupeeValue
	jr nz,+
	ld e,$79
	ld a,$01
	ld (de),a
+
	ld h,d
	ld l,$7a
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	jp removeRupeeValue
@func_71ac:
	call interactionSetAlwaysUpdateBit
	ld l,$66
	ld a,$06
	ldi (hl),a
	ld a,$06
	ld (hl),a
	ld l,$50
	ld a,$32
	ld (hl),a
	ld e,Interaction.subid
	ld a,(de)
	ret
@func_71c0:
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jr z,+
	ld a,$01
+
	ld e,$77
	ld (de),a
	ret
@table_71cd:
	; Dimitri
	.dw mainScripts.moblinBulliesScript_dimitriBully1BeforeSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully2BeforeSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully3BeforeSaving
@table_71d3:
	; Dimitri
	.dw mainScripts.moblinBulliesScript_dimitriBully1AfterSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully2AfterSaving
	.dw mainScripts.moblinBulliesScript_dimitriBully3AfterSaving
@table_71d9:
	.dw mainScripts.moblinBulliesScript_mooshBully1
	.dw mainScripts.moblinBulliesScript_mooshBully2
	.dw mainScripts.moblinBulliesScript_mooshBully3
	.dw mainScripts.moblinBulliesScript_maskedMoblin1MovingUp
	.dw mainScripts.moblinBulliesScript_maskedMoblin2MovingUp
	.dw mainScripts.moblinBulliesScript_maskedMoblinMovingLeft
