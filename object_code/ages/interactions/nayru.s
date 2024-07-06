; ==================================================================================================
; INTERAC_NAYRU
; ==================================================================================================
interactionCode36:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw nayruState0
	.dw nayruState1

;;
nayruState0:
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
	.dw @init00
	.dw @init01
	.dw @init02
	.dw @init03
	.dw @init04
	.dw @init05
	.dw @init06
	.dw @init07
	.dw @init08
	.dw @init09
	.dw @init0a
	.dw @init0b
	.dw @init0c
	.dw @init0d
	.dw @init0e
	.dw @init0f
	.dw @init10
	.dw @init11
	.dw @init12
	.dw @init13

@init00:
	ld a,$03
	call setMusicVolume
	call @loadEvilPalette

@setSingingAnimation:
	ld a,$04
	call interactionSetAnimation
	jp interactionLoadExtraGraphics

@init01:
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete

	call objectSetInvisible

	ld hl,mainScripts.nayruScript01
	call interactionSetScript

@init0e: ; This is also called from ambi subids 4 and 5 (to initialize possessed palettes)
	ld a,$06
	ld e,Interaction.oamFlags
	ld (de),a

@loadEvilPalette:
	; Load the possessed version of her palette into palette 6.
	ld a,PALH_97
	jp loadPaletteHeader

@init02:
	ld a,($cfd0)
	cp $03
	jr z,++

	ld a,$05
	call interactionSetAnimation
	ld hl,mainScripts.nayruScript02_part1
	call interactionSetScript
	jp objectSetInvisible
++
	ld a,$02
	call interactionSetAnimation

	ld hl,mainScripts.nayruScript02_part2
	jp interactionSetScript

@init04:
	ld hl,mainScripts.nayruScript04_part1
	ld a,($cfd0)
	cp $0b
	jr nz,++

	ld bc,$4840
	call interactionSetPosition
	call checkIsLinkedGame
	jr nz,@init03

	ld hl,mainScripts.nayruScript04_part2
++
	call interactionSetScript

@init03:
	xor a
	jp interactionSetAnimation

@init05:
	ld a,$05
	call interactionSetAnimation
	ld hl,mainScripts.nayruScript05
	call interactionSetScript
	jp objectSetInvisible

@init06:
	ld a,$07
	jp interactionSetAnimation

@init07:
	ld e,Interaction.counter1
	ld a,$1e
	ld (de),a
	call interactionLoadExtraGraphics
	jp interactionSetAlwaysUpdateBit

@init08:
	ld hl,mainScripts.nayruScript08
	call interactionSetScript
	call objectSetVisible82
	ld a,$03
	jp interactionSetAnimation

@init09:
	ld hl,mainScripts.nayruScript09
	jp interactionSetScript

@init0a:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,$01
	call interactionSetAnimation
	ld hl,mainScripts.nayruScript0a
	jp interactionSetScript

@init0b:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp c,interactionDelete

	ld a,<TX_1d14

@runGenericNpc:
	ld e,Interaction.textID
	ld (de),a
	inc e
	ld a,>TX_1d00
	ld (de),a
	ld hl,mainScripts.genericNpcScript
	jp interactionSetScript

@init0c:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,<TX_1d15
	jr @runGenericNpc

@init0d:
	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,<TX_1d17
	jr @runGenericNpc

@init0f:
	ld a,TREASURE_MAKU_SEED
	call checkTreasureObtained
	jp nc,interactionDelete

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call checkGlobalFlag
	jp nz,interactionDelete

	call checkIsLinkedGame
	ld c,$32
	call nz,objectSetShortPosition
	ld a,<TX_1d20
	jr @runGenericNpc

@init10:
	ld a,>TX_1d00
	call interactionSetHighTextIndex
	ld e,Interaction.var3f
	ld a,$ff
	ld (de),a
	ld hl,mainScripts.nayruScript10
	jp interactionSetScript

@init11:
	xor a
	call interactionSetAnimation
	callab scriptHelp.objectWritePositionTocfd5
	ld a,>TX_1d00
	call interactionSetHighTextIndex
	ld hl,mainScripts.nayruScript11
	jp interactionSetScript

@init12:
	call interactionSetAlwaysUpdateBit
	ld bc,$4870
	jp interactionSetPosition

@init13:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld hl,mainScripts.nayruScript13
	call interactionSetScript

	ld a,>TX_1d00
	call interactionSetHighTextIndex

	ld a,MUS_OVERWORLD
	ld (wActiveMusic2),a
	ld a,$ff
	ld (wActiveMusic),a
	jp @setSingingAnimation

;;
nayruState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw nayruSubid00
	.dw nayruSubid01
	.dw nayruSubid02
	.dw nayruSubid03
	.dw nayruSubid04
	.dw nayruSubid05
	.dw nayruSubid00
	.dw nayruSubid07
	.dw nayruAnimateAndRunScript
	.dw nayruSubid09
	.dw nayruSubid0a
	.dw nayruAsNpc
	.dw nayruAsNpc
	.dw nayruAsNpc
	.dw interactionAnimate
	.dw nayruAsNpc
	.dw nayruSubid10
	.dw nayruAnimateAndRunScript
	.dw interactionAnimate
	.dw nayruSubid13


; Subid $00: cutscene at the beginning of the game (Nayru talks, gets possessed, goes back
; in time).
; Variables:
;   var38:    "Status" of possession flickering
;   var39:    Counter for number of times to flicker palette while being possessed.
;   var3a/3b: Number of frames to stay in her "unpossessed" (var3a) or "possessed" (var3b)
;             palette. These are copied to var39. Her "possessed" counter gets longer while
;             the other gets shorter.
nayruSubid00:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

; Waiting for Link to approach (signal in $cfd0)
@substate0:
	call interactionAnimate
	ld a,($cfd0)
	cp $09
	jp nz,@createMusicNotes

	call interactionIncSubstate
	ld a,$0f
	ld l,Interaction.var39
	ldi (hl),a
	ldi (hl),a
	ld (hl),$01
	ld hl,mainScripts.nayruScript00_part1
	jp interactionSetScript

; This is also called from outside subid 0
@createMusicNotes:
	ld h,d
	ld l,Interaction.animParameter
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	dec a
	ld c,-6
	jr z,+
	ld c,8
+
	ld b,$fc
	jp objectCreateFloatingMusicNote


; Palette is flickering while being possessed
@substate1:
	call interactionAnimate
	call interactionRunScript
	ld a,($cfd0)
	cp $16
	ret nz

	; Sway horizontally while moving
	ld e,Interaction.counter2
	ld a,(de)
	or a
	call nz,@swayHorizontally

	; Flip the OAM flags when var39 reaches 0
	ld h,d
	ld l,Interaction.var39
	dec (hl)
	ret nz
	ld l,Interaction.oamFlags
	ld a,(hl)
	dec a
	xor $05
	inc a
	ld (hl),a

	call nayruUpdatePossessionPaletteDurations
	jr nz,++

	; Done flickering with possession
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$06
	ret
++
	ld l,Interaction.var3a
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,Interaction.oamFlags
	ld a,(hl)
	cp $06
	ld a,b
	jr nz,+
	ld a,c
+
	ld l,Interaction.var39
	ld (hl),a
	ret

;;
; Nayru sways horizontally (3 pixels left, 3 pixels right, repeat)
@swayHorizontally:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wFrameCounter)
	and $38
	swap a
	rlca
	ld hl,@@xOffsets
	rst_addAToHl
	ld e,Interaction.xh
	ld a,(hl)
	ld b,a
	ld a,(de)
	add b
	ld (de),a
	ret

@@xOffsets:
	.db $ff $ff $ff $00 $01 $01 $01 $00


; Waiting for script to end
@substate2:
	call interactionRunScript
	ret nc
	jp interactionIncSubstate


; Waiting for some kind of signal?
@substate3:
	ld a,($cfd0)
	cp $1a
	ret nz
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),60
	ret


; Waiting 60 frames before jumping
@substate4:
	call interactionAnimate
	call interactionDecCounter1
	ret nz

	call interactionIncSubstate
	ld bc,-$400
	call objectSetSpeedZ
	ld a,SND_SWORDSPIN
	call playSound
	ld a,$05
	jp interactionSetAnimation


; Jumping until off-screen
@substate5:
	xor a
	call objectUpdateSpeedZ
	ld e,Interaction.zh
	ld a,(de)
	cp $80
	ret nc

	; Set position to land at
	ld bc,$3828
	call interactionSetPosition
	ld l,Interaction.zh
	ld (hl),$80

	ld l,Interaction.counter1
	ld (hl),$1e

	jp interactionIncSubstate


; Brief delay before falling back down
@substate6:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld bc,$0040
	jp objectSetSpeedZ


; Falling back down
@substate7:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld a,$1b
	ld ($cfd0),a

	; Start next script
	ld hl,mainScripts.nayruScript00_part2
	call interactionSetScript
	ld a,SND_SLASH
	call playSound
	jp interactionIncSubstate


; Next script running; make Nayru transparent when signal is given. Delete self when the
; script finishes.
@substate8:
	call interactionAnimate
	call interactionRunScript
	jr nc,++
	jp interactionDelete
++
	; Wait for signal from script to make her transparent
	ld e,Interaction.var3d
	ld a,(de)
	or a
	ret z
	ld b,$01
	jp objectFlickerVisibility


; Subid $01: Cutscene in Ambi's palace after getting bombs
nayruSubid01:
	call nayruAnimateAndRunScript
	ret nc

; Script finished; load the next room.

	push de
	ld bc,$0146
	call disableLcdAndLoadRoom
	call resetCamera

	; Need to load the guards since the "disableLcdAndLoadRoom" function call doesn't
	; load the room's objects
	ld hl,objectData.ambisPalaceEntranceGuards
	call parseGivenObjectData

	; Need to re-initialize the link object
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$38
	ld l,<w1Link.xh
	ld (hl),$50

	; Need to re-enable the LCD
	ld a,$02
	call loadGfxRegisterStateIndex

	pop de
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	jp clearPaletteFadeVariablesAndRefreshPalettes


; Subid $02: Cutscene on maku tree screen after being saved
nayruSubid02:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw nayruSubid02Substate0
	.dw nayruSubid02Substate1
	.dw nayruSubid02Substate2

;;
nayruSubid02Substate0: ; This is also called by Ralph in the same cutscene
	ld a,($cfd0)
	cp $07
	jr nz,@createNotes

	; When signal is received from $cfd0, choose direction randomly (left/right) and
	; go to substate 1
	call getRandomNumber
	and $02
	or $01
	ld e,Interaction.direction
	ld (de),a

	call nayruSetCounter1Randomly
	jp interactionIncSubstate

@createNotes:
	call nayruSubid00@createMusicNotes

;;
nayruAnimateAndRunScript:
	call interactionAnimateBasedOnSpeed
	jp interactionRunScript

;;
nayruSubid02Substate1:
	ld a,($cfd0)
	cp $08
	jr nz,nayruFlipDirectionAtRandomIntervals

	call interactionIncSubstate

	ld hl,mainScripts.nayruScript02_part3
	call interactionSetScript

	ld a,$01
	jp interactionSetAnimation

;;
; This is also called by Ralph in the same cutscene
nayruFlipDirectionAtRandomIntervals:
	call interactionDecCounter1
	ret nz
	ld l,Interaction.direction
	ld a,(hl)
	xor $02
	ld (hl),a
	call interactionSetAnimation

;;
nayruSetCounter1Randomly:
	call getRandomNumber_noPreserveVars
	and $03
	add a
	add a
	add $10
	ld e,Interaction.counter1
	ld (de),a
	ret

nayruSubid02Substate2:
	call nayruAnimateAndRunScript
	ret nc
	jp interactionDelete


; Subid $03: Cutscene with Nayru and Ralph when Link exits the black tower
nayruSubid03:
	call interactionAnimateBasedOnSpeed
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd0)
	cp $01
	ret nz
	call startJump
	jp interactionIncSubstate

@substate1:
	ld c,$24
	call objectUpdateSpeedZ_paramC
	ret nz
	ld hl,mainScripts.nayruScript03
	call interactionSetScript
	jp interactionIncSubstate

@substate2:
	jp interactionRunScript


;;
; Subid $04: Cutscene at end of game with Ambi and her guards
nayruSubid04:
	call checkIsLinkedGame
	jp z,nayruAnimateAndRunScript

	ld a,($cfd0)
	cp $0b
	jr c,nayruAnimateAndRunScript
	call interactionAnimate
	jpab scriptHelp.turnToFaceSomething

;;
; Subid $05: ?
nayruSubid05:
	call nayruAnimateAndRunScript

	ld a,($cfc0)
	cp $03
	ret c
	cp $05
	ret nc

	jpab scriptHelp.turnToFaceSomething

;;
; For Nayru subid 0 (getting possessed cutscene), this updates var3a, var3b representing
; how long Nayru's palette should be "normal" or "possessed".
;
; @param[out]	zflag	Set when Nayru is fully possessed
nayruUpdatePossessionPaletteDurations:
	ld a,(wFrameCounter)
	and $01
	ret nz
	ld e,Interaction.var38
	ld a,(de)
	rst_jumpTable
	.dw @var38_0
	.dw @var38_1
	.dw @var38_2
	.dw @var38_3
	.dw @var38_4

@var38_0:
	; Decrement var3a (unpossessed palette duration), increment var3b (possessed
	; palette duration) until the two are equal, then increment var38.
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	inc (hl)
	ldd a,(hl)
	cp (hl)
	ret nz

@incVar38:
	ld l,Interaction.var38
	inc (hl)
	ret

@var38_1:
	; Decrement both var3a and var3b until they're both 2
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	dec (hl)
	ld a,(hl)
	cp $02
	ret nz

	ld l,Interaction.var3c
	ld (hl),$10
	jr @incVar38

@var38_2:
	; Wait 32 frames
	ld h,d
	ld l,Interaction.var3c
	dec (hl)
	ret nz
	jr @incVar38

@var38_3:
	; Increment both var3a and var3b until they're both 8
	ld h,d
	ld l,Interaction.var3a
	inc (hl)
	inc l
	inc (hl)
	ld a,(hl)
	cp $08
	ret nz
	jr @incVar38

@var38_4:
	; Decrement var3a, increment var3b until it's 16
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	inc (hl)
	ld a,(hl)
	cp $10
	ret nz
	ret

;;
; Subid $07: Cutscene with the vision of Nayru teaching you Tune of Echoes
nayruSubid07:
	call checkInteractionSubstate
	jr nz,@substate1

@substate0:
	call interactionDecCounter1
	jr z,++

	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret
++
	xor a
	ld ($cfc0),a
	call interactionIncSubstate
	call objectSetVisible82

	ld a,MUS_NAYRU
	ld (wActiveMusic),a
	call playSound

	ld hl,mainScripts.nayruScript07
	jp interactionSetScript

@substate1:
	call interactionRunScript
	jr c,@scriptDone

	ld a,($cfc0)
	rrca
	ret c
	ld e,Interaction.direction
	ld a,(de)
	cp $07
	call z,nayruSubid00@createMusicNotes
	jp interactionAnimate

@scriptDone:
	ld a,(wTextIsActive)
	or a
	ret nz

	; Re-enable objects, menus
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound

	ld a,$04
	call fadeinFromWhiteWithDelay
	call showStatusBar
	ldh a,(<hActiveObject)
	ld d,a
	jp interactionDelete

;;
nayruAsNpc:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

;;
; Subid $09: Cutscene where Ralph's heritage is revealed (unlinked?)
nayruSubid09:
	call nayruAnimateAndRunScript
	ret nc

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE
	call setGlobalFlag
	jp interactionDelete

;;
; Subid $10: Cutscene in black tower where Nayru/Ralph meet you to try to escape
nayruSubid10:
	ld a,(wScreenShakeCounterY)
	cp $5a
	jr nc,nayruSubid0a
	or a
	jr z,nayruSubid0a
	ld a,(w1Link.direction)
	dec a
	and $03
	ld h,d
	ld l,Interaction.var3f
	cp (hl)
	jr z,nayruSubid0a
	ld (hl),a
	call interactionSetAnimation

;;
; Subid $0a: Cutscene where Ralph's heritage is revealed (linked?)
nayruSubid0a:
	call nayruAnimateAndRunScript
	ret nc
	jp interactionDelete

;;
; Subid $13: NPC after completing game (singing to animals)
nayruSubid13:
	call nayruSubid00@createMusicNotes

;;
; This is called by Ralph as well
nayruRunScriptWithConditionalAnimation:
	call interactionRunScript
	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimate
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
