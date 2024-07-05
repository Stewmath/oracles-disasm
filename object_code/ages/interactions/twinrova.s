; ==================================================================================================
; INTERAC_TWINROVA
;
; Variables:
;   var3a: Index for "loadAngleAndCounterPreset" function
; ==================================================================================================
interactionCode93:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw twinrova_state1

@state0:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	jr nc,@subid2AndUp

@subid0Or1:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $08
	ret nz
	call twinrova_loadGfx
	jr ++

@subid2AndUp:
	cp $06
	call nz,interactionLoadExtraGraphics
++
	call interactionIncState
	call interactionInitGraphics
	call objectSetVisiblec1
	ld a,>TX_2800
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw twinrova_initSubid00
	.dw twinrova_initOtherHalf
	.dw twinrova_initSubid02
	.dw twinrova_initOtherHalf
	.dw twinrova_initSubid04
	.dw twinrova_initOtherHalf
	.dw twinrova_initSubid06
	.dw twinrova_initOtherHalf

;;
twinrova_loadGfx:
	ld hl,wLoadedObjectGfx+10
	ld b,$03
	ld a,AGES_OBJ_GFXH_2c
--
	ldi (hl),a
	inc a
	ld (hl),$01
	inc l
	dec b
	jr nz,--
	push de
	call reloadObjectGfx
	pop de
	ret

twinrova_initSubid06:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),$00
	call twinrova_loadScript
	ld bc,$4234
	jr twinrova_genericInitialize

twinrova_initSubid02:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),$04
	ld l,Interaction.var38
	ld (hl),$02
	call objectSetInvisible
	ld bc,$3850
	jr twinrova_genericInitialize

twinrova_initSubid04:
	ld h,d
	ld l,Interaction.var38
	ld (hl),$1e

twinrova_initSubid00:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),$00
	ld bc,$f888

twinrova_genericInitialize:
	call interactionSetPosition
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.zh
	ld (hl),-$08

	; Spawn the other half ([subid]+1)
	call getFreeInteractionSlot
	jr nz,++
	ld (hl),INTERAC_TWINROVA
	inc l
	ld e,l
	ld a,(de)
	inc a
	ld (hl),a
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.start
	inc l
	ld (hl),d
++
	call twinrova_loadAngleAndCounterPreset
	call twinrova_updateDirectionFromAngle
	ld a,SND_BEAM2
	call playSound
	jpab scriptHelp.objectWritePositionTocfd5

;;
twinrova_loadAngleAndCounterPreset:
	ld e,Interaction.var3a
	ld a,(de)
	ld b,a

;;
; Loads preset values for angle and counter1 variables for an interaction. The values it
; loads depends on parameter 'b' (the preset index) and 'Interaction.counter2' (the index
; in the preset to use).
;
; Generally used to make an object move around in circular-ish patterns?
;
; @param	b	Preset to use
; @param[out]	b	Zero if end of data reached; nonzero otherwise.
loadAngleAndCounterPreset:
	ld a,b
	ld hl,presetInteractionAnglesAndCounters
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld e,Interaction.counter2
	ld a,(de)
	rst_addDoubleIndex

	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a
	ld a,(hl)
	or a
	ld b,a
	ret z

	ld h,d
	ld l,Interaction.counter1
	ldi (hl),a
	inc (hl) ; [counter2]++
	or $01
	ret

;;
twinrova_updateDirectionFromAngle:
	ld e,Interaction.angle
	call convertAngleDeToDirection
	and $03
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation


; Initialize odd subids (the half of twinrova that just follows along)
twinrova_initOtherHalf:
	call interactionSetAlwaysUpdateBit
	ld l,Interaction.oamFlags
	ld (hl),$01

	; Copy position & stuff from other half, inverted if necessary
	ld a,Object.enabled
	call objectGetRelatedObject1Var

;;
; @param	h	Object to copy visiblility, direction, position from
twinrova_takeInvertedPositionFromObject:
	ld l,Interaction.visible
	ld e,l
	ld a,(hl)
	ld (de),a

	call objectTakePosition
	ld l,Interaction.xh
	ld b,(hl)
	ld a,$50
	sub b
	add $50
	ld e,Interaction.xh
	ld (de),a

	ld l,Interaction.direction
	ld a,(hl)
	ld b,a
	and $01
	jr z,++

	ld a,b
	ld b,$01
	cp $03
	jr z,++
	ld b,$03
++
	ld a,b
	ld h,d
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	jp interactionSetAnimation


; This data contains "presets" for an interacton's angle and counter1.
presetInteractionAnglesAndCounters:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5

; Data format:
;   b0: Value for Interaction.angle
;   b1: Value for Interaction.counter1 (or $00 for end)

@data0: ; Used by Twinrova
	.db $11 $28
	.db $12 $10
	.db $13 $07
	.db $15 $05
	.db $17 $04
	.db $19 $04
	.db $1a $05
	.db $1d $07
	.db $1f $12
	.db $00 $00

@data1:
@data5:
	.db $03 $06
	.db $04 $06
	.db $06 $06
	.db $07 $06
	.db $08 $04
	.db $09 $06
	.db $0a $06
	.db $0c $04
	.db $0e $04
	.db $0f $04
	.db $10 $04
	.db $11 $04
	.db $13 $06
	.db $14 $0c
	.db $15 $30
	.db $00 $00

@data2: ; Ralph spinning his sword in credits cutscene
	.db $1a $12
	.db $1e $12
	.db $02 $12
	.db $06 $12
	.db $0a $12
	.db $0e $12
	.db $12 $12
	.db $16 $12
	.db $16 $12
	.db $12 $12
	.db $0e $12
	.db $0a $12
	.db $04 $12
	.db $02 $12
	.db $1e $10
	.db $1a $04
	.db $00 $00

@data3: ; INTERAC_RAFTWRECK_CUTSCENE_HELPER
	.db $15 $0c
	.db $16 $0c
	.db $17 $12
	.db $18 $14
	.db $19 $14
	.db $1a $20
	.db $00 $00

@data4: ; Used by Twinrova
	.db $0e $03
	.db $0c $03
	.db $0a $03
	.db $08 $03
	.db $06 $03
	.db $04 $03
	.db $02 $03
	.db $00 $03
	.db $1e $06
	.db $1c $06
	.db $1a $06
	.db $18 $06
	.db $16 $06
	.db $14 $06
	.db $12 $06
	.db $0f $08
	.db $00 $00


twinrova_state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runOtherHalf
	.dw @runSubid02
	.dw @runOtherHalf
	.dw @runSubid04
	.dw @runOtherHalf
	.dw @runSubid06
	.dw @runOtherHalf

@runSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid00State0
	.dw @subid00State1
	.dw @subid00State2

@subid00State0:
	callab scriptHelp.objectWritePositionTocfd5
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	call z,twinrova_loadAngleAndCounterPreset
	jp nz,twinrova_updateDirectionFromAngle
	call interactionIncSubstate
	jp twinrova_loadScript

@subid00State1:
	call interactionAnimate
	call objectOscillateZ
	call interactionRunScript
	ret nc

	ld a,SND_BEAM2
	call playSound
	callab scriptHelp.objectWritePositionTocfd5
	call interactionIncSubstate
	ld l,Interaction.counter2
	ld (hl),$00
	ld l,Interaction.var3a
	inc (hl)
	jp twinrova_loadAngleAndCounterPreset

@subid00State2:
	callab scriptHelp.objectWritePositionTocfd5
	call interactionAnimate
	call objectApplySpeed
	call interactionDecCounter1
	call z,twinrova_loadAngleAndCounterPreset
	jp nz,twinrova_updateDirectionFromAngle
	ld a,$09
	ld (wTmpcfc0.genericCutscene.cfd0),a
	jp interactionDelete

@runOtherHalf:
	call interactionAnimate
	ld a,Object.enabled
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jp z,interactionDelete
	jp twinrova_takeInvertedPositionFromObject

@runSubid02:
@runSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid02State0
	.dw @subid00State0
	.dw @subid00State1
	.dw @subid00State2

@subid02State0:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz
	call objectSetVisiblec1
	jp interactionIncSubstate

@runSubid06:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid00State1
	.dw @subid00State2

;;
twinrova_loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.twinrova_subid00Script
	.dw mainScripts.stubScript
	.dw mainScripts.twinrova_subid02Script
	.dw mainScripts.stubScript
	.dw mainScripts.twinrova_subid04Script
	.dw mainScripts.stubScript
	.dw mainScripts.twinrova_subid06Script

;;
; Gets a position stored in $cfd5/$cfd6?
;
; @param[out]	bc	Position
func_0a_7877:
	ld hl,wTmpcfc0.genericCutscene.cfd5
	ld b,(hl)
	inc l
	ld c,(hl)
	ret
