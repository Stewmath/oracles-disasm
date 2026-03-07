; ==================================================================================================
; INTERAC_PICKAXE_WORKER
; ==================================================================================================
interactionCode57:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03

; Subid 0: Worker below Maku Tree screen in past
; Subid 3: Worker in black tower.
@subid00:
@subid03:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit

@@state1:
	call interactionRunScript
	jp c,interactionDelete

	call interactionAnimateAsNpc
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z

	; animParameter is nonzero; just struck the ground.
	ld a,SND_CLINK
	call playSound
	ld a,(wScrollMode)
	and $01
	ret z
	ld a,$03
	jp @createDirtChips


; Credits cutscene guy making Link statue?
@subid01:
	call checkInteractionState
	jr nz,@subid1State1

@subid1And2State0:
	ld e,Interaction.subid
	ld a,(de)
	dec a
	ld a,$0c
	jr z,+
	ld a,$f4
+
	ld e,Interaction.var38
	ld (de),a
	call @loadScriptAndInitGraphics

@subid1State1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1And2Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3
	.dw @updateAnimationAndRunScript


@subid1And2Substate0:
	ld a,($cfc0)
	cp $01
	jr nz,@label_09_221

	call interactionIncSubstate
	ld l,Interaction.subid
	ld a,(hl)
	dec a
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@label_09_221:
	call interactionAnimateBasedOnSpeed
	call interactionRunScript
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	jr z,@doneSpawningObjects

	; Spawn in some objects when pickaxe hits statue?
	ld (hl),$00
	ld b,$04
@nextObject:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_EXPLOSION_WITH_DEBRIS
	inc l
	ld (hl),$02
	inc l
	ld (hl),b
	ld e,Interaction.visible
	ld a,(de)
	ld l,Interaction.var38
	ld (hl),a
	push bc
	ld e,Interaction.var38
	ld a,(de)
	ld b,$00
	ld c,a
	call objectCopyPositionWithOffset
	pop bc
	dec b
	jr nz,@nextObject

@doneSpawningObjects:
	ld l,Interaction.yh
	ld a,(hl)
	cp $50
	jp nc,objectSetVisiblec1
	jp objectSetVisiblec3

@subid1Substate1:
	call @updateAnimationAndRunScript
	ret nc
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),210
	ret

@updateAnimationAndRunScript:
	ld e,Interaction.var3f
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	jp interactionRunScript

@subid1Substate2:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	jp fadeoutToWhite

@subid1Substate3:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call interactionIncSubstate
	ld a,$06
	ld ($cfc0),a
	call disableLcd
	push de

	; Force-reload maku tree screen?
	ld bc,ROOM_AGES_138
	ld a,$00
	call forceLoadRoom

	ld a,UNCMP_GFXH_2d
	call loadUncompressedGfxHeader
	ld a,PALH_TILESET_MAKU_TREE
	call loadPaletteHeader
	ld a,GFXH_CREDITS_SCENE_MAKU_TREE_PAST
	call loadGfxHeader

	ld a,$ff
	ld (wTilesetAnimation),a
	ld a,$04
	call loadGfxRegisterStateIndex

	pop de
	ld bc,$427e
	call interactionSetPosition
	ld a,$02
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp fadeinFromWhite


; Credits cutscene guy making Link statue?
@subid02:
	call checkInteractionState
	jr nz,++
	jp @subid1And2State0
++
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @subid1And2Substate0
	.dw @subid2Substate1
	.dw @subid2Substate2
	.dw @updateAnimationAndRunScript

@subid2Substate1:
	call @updateAnimationAndRunScript
	ret nc
	call interactionIncSubstate

@subid2Substate2:
	call interactionAnimateBasedOnSpeed
	call objectApplySpeed
	ld a,($cfc0)
	cp $06
	ret nz
	call interactionIncSubstate
	ld bc,$388a
	call interactionSetPosition
	ld a,$03
	ld hl,@subid1And2ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript


@unusedFunc_6a80:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_1b00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
; Create the debris that comes out when the pickaxe hits the ground.
@createDirtChips:
	ld c,a
	ld b,$02

; b = number of objects to create
; c = var03
@next:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_FALLING_ROCK
	inc l
	ld (hl),$06 ; [new.subid] = $06
	inc l
	ld (hl),c   ; [new.var03] = c

	ld e,Interaction.visible
	ld a,(de)
	and $03
	ld l,Interaction.counter2
	ld (hl),a
	ld l,Interaction.angle
	ld (hl),b
	dec (hl)

	push bc
	call objectCopyPosition
	pop bc

	; [new.yh] = [this.yh]+4
	ld l,Interaction.yh
	ld a,(hl)
	add $04

	; [new.xh] = [this.xh]-$0e if [this.animParameter] == $01, otherwise [this.xh]+$0e
	ld (hl),a
	ld e,Interaction.animParameter
	ld a,(de)
	cp $01
	ld l,Interaction.xh
	ld a,(hl)
	jr z,+
	add $0e*2
+
	sub $0e
	ld (hl),a

	dec b
	jr nz,@next
	ret


@scriptTable:
	.dw mainScripts.pickaxeWorkerSubid00Script
	.dw mainScripts.pickaxeWorkerSubid01Script_part1
	.dw mainScripts.pickaxeWorkerSubid02Script_part1
	.dw mainScripts.pickaxeWorkerSubid03Script

@subid1And2ScriptTable:
	.dw mainScripts.pickaxeWorkerSubid01Script_part2
	.dw mainScripts.pickaxeWorkerSubid02Script_part2
	.dw mainScripts.pickaxeWorkerSubid01Script_part3
	.dw mainScripts.pickaxeWorkerSubid02Script_part3
