; ==================================================================================================
; INTERAC_MALE_VILLAGER
;
; Variables:
;   var03: Nonzero if he's turned to stone
;   var39: For some subids, animations only update when var39 is zero
;   var3d: Saved X position?
; ==================================================================================================
interactionCode3a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	call interactionInitGraphics
	call objectSetVisiblec2
	call @initSubid

	ld e,Interaction.enabled
	ld a,(de)
	or a
	jp nz,objectMarkSolidPosition
	ret

@initSubid:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw @initSubid05
	.dw @initSubid06
	.dw @initSubid07
	.dw @initSubid08
	.dw @initAnimationAndLoadScript
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e

@initSubid00:
	ld a,$03
	jp interactionSetAnimation

@initSubid02:
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList

	ld e,Interaction.speed
	ld a,SPEED_100
	ld (de),a

@saveXAndLoadScript:
	ld e,Interaction.xh
	ld a,(de)
	ld e,Interaction.var3d
	ld (de),a

@initSubid01:
	jp @loadScript

@initSubid03:
	callab agesInteractionsBank09.getGameProgress_1
	ld a,b
	ld hl,@subid03ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid04:
@initSubid05:
	ld a,$02
	ld e,Interaction.oamFlags
	ld (de),a

	callab agesInteractionsBank09.getGameProgress_1
	ld c,$04
	ld a,$03
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid4And5ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid06:
@initSubid07:
	callab agesInteractionsBank09.getGameProgress_2
	ld c,$06
	ld a,$04
	call checkNpcShouldExistAtGameStage
	jp nz,interactionDelete

	ld a,b
	ld hl,@subid6And7ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid08:
	ld a,$03
	ld e,Interaction.oamFlags
	ld (de),a

	; Delete if you haven't beaten d7 yet?
	callab agesInteractionsBank09.getGameProgress_2
	ld a,b
	cp $04
	jp c,interactionDelete

	sub $04
	ld hl,@subid08ScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@initSubid0a:
	ld h,d
	jr @loadStoneAnimation

@initAnimationAndLoadScript:
	ld a,$01
	call interactionSetAnimation
	jp @loadScript

@initSubid0c:
	; Check whether the villager should be stone right now

	; Have we beaten Veran?
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	jr nz,@initAnimationAndLoadScript

	ld a,(wEssencesObtained)
	bit 6,a
	jr z,@initAnimationAndLoadScript

	ld h,d
	ld l,Interaction.var03
	inc (hl)

@loadStoneAnimation:
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld a,$06
	call objectSetCollideRadius
	ld a,$0d
	jp interactionSetAnimation

@initSubid0b:
	ld h,d
	call @loadStoneAnimation
	ld e,Interaction.counter1
	ld a,$3c
	ld (de),a
	jr @state1

@initSubid0d:
	call @loadScript
	jr @state1

@initSubid0e:
	call loadStoneNpcPalette
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$06
	ld a,$0d
	call interactionSetAnimation

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runScriptAndFaceLink
	.dw @runSubid09
	.dw @ret
	.dw @runSubid0b
	.dw @runSubid0c
	.dw @runSubid0d
	.dw @runSubid0e


; Cutscene where guy is struck by lightning in intro
@runSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,($cfd1)
	cp $02
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3d
	ld (hl),a
	ret

@@substate1:
	callab interactionOscillateXRandomly
	ld a,($cfd1)
	cp $03
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$10

	call getFreePartSlot
	ret nz
	ld (hl),PART_LIGHTNING

	; Write something to subid? This shouldn't matter, this lightning object doesn't
	; seem to use subid anyway.
	inc l
	ld (hl),e

	; [var03] = 1
	inc l
	inc (hl)

	jp objectCopyPosition

@@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$04
	ld ($cfd1),a
	jp interactionDelete


; Past villager?
@runSubid01:
	call interactionRunScript
	jp interactionAnimateAsNpc


; Construction worker blocking path to upper part of black tower.
@runSubid02:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call npcFaceLinkAndAnimate
	call interactionRunScript
	ld bc,$0503
	call objectSetCollideRadii

	; Temporarily overwrite the worker's X position to check for "collision" at the
	; position he's left open. His position will be reverted before returning.
	ld b,$11
	ld e,Interaction.direction
	ld a,(de)
	or a
	jr z,+
	ld b,$ef
+
	ld e,Interaction.xh
	ld a,(de)
	add b
	ld (de),a
	push bc
	call objectCheckCollidedWithLink_ignoreZ
	pop bc
	jr nc,++

	; Link tried to approach; move over to block his path
	call interactionIncSubstate
	ld hl,mainScripts.villagerSubid02Script_part2
	call interactionSetScript
++
	ld hl,w1Link.yh
	ld e,Interaction.var39
	ld a,(hl)
	ld (de),a
	ld bc,$0606
	call objectSetCollideRadii

	ld e,Interaction.var3d
	ld a,(de)
	ld e,Interaction.xh
	ld (de),a
	ret

@@substate1:
	call interactionAnimateAsNpc
	call interactionRunScript
	jp nc,interactionAnimateBasedOnSpeed

	call @saveXAndLoadScript
	ld h,d
	ld l,Interaction.direction
	ld a,(hl)
	xor $01
	ld (hl),a
	ld l,Interaction.substate
	ld (hl),$00
	jp @loadScript


@runScriptAndFaceLink:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


@runSubid09:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @ret

@@substate0:
	call interactionRunScript
	ld a,($cfd1)
	cp $01
	ret nz
	jp interactionIncSubstate

@@substate1:
	ld a,($cfd1)
	cp $02
	ret nz
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$06

@ret:
	ret


; Villager being restored from stone, resumes playing catch
@runSubid0b:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call interactionDecCounter1IfPaletteNotFading
	ret nz

	ld a,$01
	ld ($cfd1),a
	ld a,SND_RESTORE
	call playSound
	jpab setCounter1To120AndPlaySoundEffectAndIncSubstate

@@substate1:
	call interactionDecCounter1
	jr nz,++

	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$01
	jp @loadScript
++
	; Flicker palette every 8 frames
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,Interaction.oamFlags
	ld a,(de)
	dec a
	xor $05
	inc a
	ld (de),a
	ret

@@substate2:
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	jp interactionRunScript


; Villager playing catch with son
@runSubid0c:
	call interactionPushLinkAwayAndUpdateDrawPriority
	ld e,Interaction.var03
	ld a,(de)
	or a
	ret nz

	call interactionRunScript

	; If you press the A button, show text
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	ret z

	xor a
	ld (de),a
	ld bc,TX_1442
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl) ; Has Veran been beaten?
	jr z,+
	ld c,<TX_1443
+
	jp showText


; Cutscene when you first enter the past
@runSubid0d:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimateBasedOnSpeed
	jp interactionPushLinkAwayAndUpdateDrawPriority


; Stone villager? Not much to do.
@runSubid0e:
	ret


@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript


@scriptTable:
	.dw mainScripts.stubScript
	.dw mainScripts.villagerSubid01Script
	.dw mainScripts.villagerSubid02Script_part1
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.stubScript
	.dw mainScripts.villagerSubid09Script
	.dw mainScripts.stubScript
	.dw mainScripts.villagerSubid0bScript
	.dw mainScripts.villagerSubid0cScript
	.dw mainScripts.villagerSubid0dScript


@subid03ScriptTable:
	.dw mainScripts.villagerSubid03Script_befored3
	.dw mainScripts.villagerSubid03Script_afterd3
	.dw mainScripts.villagerSubid03Script_afterNayruSaved
	.dw mainScripts.villagerSubid03Script_afterd7
	.dw mainScripts.villagerSubid03Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid03Script_postGame


@subid4And5ScriptTable:
	.dw mainScripts.villagerSubid4And5Script_befored3
	.dw mainScripts.villagerSubid4And5Script_afterd3
	.dw mainScripts.villagerSubid4And5Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid4And5Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid4And5Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid4And5Script_postGame

@subid6And7ScriptTable:
	.dw mainScripts.villagerSubid6And7Script_befored2
	.dw mainScripts.villagerSubid6And7Script_afterd2
	.dw mainScripts.villagerSubid6And7Script_afterd4
	.dw mainScripts.villagerSubid6And7Script_afterNayruSaved
	.dw mainScripts.villagerSubid6And7Script_afterd7
	.dw mainScripts.villagerSubid6And7Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid6And7Script_twinrovaKidnappedZelda
	.dw mainScripts.villagerSubid6And7Script_postGame

@subid08ScriptTable:
	.dw mainScripts.villagerSubid08Script_afterd7
	.dw mainScripts.villagerSubid08Script_afterGotMakuSeed
	.dw mainScripts.villagerSubid08Script_twinrovaKidnappedZelda
	.dw mainScripts.villagerSubid08Script_postGame
