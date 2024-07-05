; ==================================================================================================
; INTERAC_TOKAY
; ==================================================================================================
interactionCode48:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw tokayState1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2

	ld a,>TX_0a00
	call interactionSetHighTextIndex

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
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @initSubid0d
	.dw @initSubid0e
	.dw @initSubid0f
	.dw @initSubid10
	.dw @initSubid11
	.dw @initSubid12
	.dw @initSubid13
	.dw @initSubid14
	.dw @initSubid15
	.dw @initSubid16
	.dw @initSubid17
	.dw @initSubid18
	.dw @initSubid19
	.dw @initSubid1a
	.dw @initSubid1b
	.dw @initSubid1c
	.dw @initSubid1d
	.dw @initSubid1e
	.dw @initSubid1f


; Subid $00-$04: Tokays who rob Link

@initSubid00:
@initSubid03:
	ld a,$01
	jr @initLinkRobberyTokay

@initSubid01:
@initSubid04:
	ld a,$03
	jr @initLinkRobberyTokay

@initSubid02:
	call getThisRoomFlags
	bit 6,a
	jp nz,@deleteSelf

	xor a
	call interactionSetAnimation
	call tokayLoadScript

	; Set the Link object to run the cutscene where he gets mugged
	ld a,SPECIALOBJECT_LINK_CUTSCENE
	call setLinkIDOverride
	ld l,<w1Link.subid
	ld (hl),$07

	ld e,Interaction.var38
	ld a,$46
	ld (de),a

	ld a,SNDCTRL_STOPMUSIC
	jp playSound

@initLinkRobberyTokay:
	call interactionSetAnimation
	call getThisRoomFlags
	bit 6,a
	jp nz,@deleteSelf
	jp tokayLoadScript


; NPC holding shield upgrade
@initSubid1d:
	call tokayLoadScript
	call getThisRoomFlags
	bit 6,a
	ld a,$02
	jp nz,interactionSetAnimation

	; Set up an "accessory" object (the shield he's holding)
	ld b,$14
	ld a,(wShieldLevel)
	cp $02
	jr c,+
	ld b,$15
+
	ld a,b
	ld e,Interaction.var03
	ld (de),a
	call getFreeInteractionSlot
	ret nz

	inc l
	ld (hl),b ; [subid] = b (graphic for the accessory)
	dec l
	call tokayInitAccessory

	ld a,$06
	jp interactionSetAnimation


; Past NPC holding shovel
@initSubid07:
	call checkIsLinkedGame
	jp nz,interactionDelete

; Past NPC holding something (sword, harp, etc)
@initSubid06:
@initSubid08:
@initSubid09:
@initSubid0a:
	call tokayLoadScript

	; Set var03 to the item being held
	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	sub $06
	ld bc,tokayIslandStolenItems
	call addAToBc
	ld a,(bc)
	ld l,Interaction.var03
	ld (hl),a

	; Check if the item has been retrieved already
	ld c,$00
	call getThisRoomFlags
	bit 6,a
	jr z,@@endLoop

	; Check if Link is still missing any items.
	inc c
	ld b,$09
@@nextItem:
	ld a,b
	dec a

	ld hl,tokayIslandStolenItems
	rst_addAToHl
	ld a,(hl)
	cp TREASURE_SHIELD
	jr z,+

	call checkTreasureObtained
	jp nc,@@endLoop
+
	dec b
	jr nz,@@nextItem
	inc c

@@endLoop:
	; var3c gets set to:
	; * 0 if Link hasn't retrieved this tokay's item yet;
	; * 1 if Link has retrieved the item, but others are still missing;
	; * 2 if Link has retrieved all of his items from the tokays.
	ld a,c
	ld e,Interaction.var3c
	ld (de),a
	or a
	jr nz,@@retrievedItem

; Link has not retrieved this tokay's item yet.

	ld a,$06
	call interactionSetAnimation

	ld e,Interaction.subid
	ld a,(de)
	ld b,<TX_0a0a

	; Shovel NPC says something a bit different
	cp $07
	jr z,+
	ld b,<TX_0a0b
+
	ld h,d
	ld l,Interaction.textID
	ld (hl),b
	sub $06
	ld b,a
	jp tokayInitHeldItem

@@retrievedItem:
	ld a,$02
	jp interactionSetAnimation


; Past NPC looking after scent seedling
@initSubid11:
	call getThisRoomFlags
	bit 7,a
	jr z,@initSubid0e

	; Seedling has been planted
	ld e,Interaction.xh
	ld a,(de)
	add $10
	ld (de),a
	call objectMarkSolidPosition
	jr @initSubid0e


; Present NPC who talks to you after climbing down vine
@initSubid1e:
	call objectMakeTileSolid
	ld h,>wRoomLayout
	ld (hl),$00
	jr @initSubid0e


; Subid $0f-$10: Tokays who try to eat Dimitri
@initSubid0f:
	ld a,$01
	jr ++

@initSubid10:
	xor a
++
	call interactionSetAnimation

	ld hl,wDimitriState
	bit 1,(hl)
	jr nz,@deleteSelf

	ld l,<wEssencesObtained
	bit 2,(hl)
	jr z,@deleteSelf

	ld e,Interaction.speed
	ld a,SPEED_200
	ld (de),a
	; Fall through


; Shopkeeper (trades items)
@initSubid0e:
	ld a,$06
	call objectSetCollideRadius
	; Fall through


; NPC who trades meat for stink bag
@initSubid05:
	call interactionSetAlwaysUpdateBit
	call tokayLoadScript
	jp tokayState1


@deleteSelf:
	jp interactionDelete


; Linked game cutscene where tokay runs away from Rosa
@initSubid0b:
	call checkIsLinkedGame
	jp z,interactionDelete

	ld a,TREASURE_SHOVEL
	call checkTreasureObtained
	jp c,interactionDelete

	call getThisRoomFlags
	bit 7,a
	jp nz,interactionDelete

	ld a,$01
	ld (wDiggingUpEnemiesForbidden),a
	jp tokayLoadScript


; Participant in Wild Tokay game
@initSubid0c:
	; If this is the last tokay, make it red
	ld h,d
	ld a,(wTmpcfc0.wildTokay.cfdf)
	or a
	jr z,+
	ld l,Interaction.oamFlags
	ld (hl),$02
+
	ld l,Interaction.angle
	ld (hl),$10
	ld l,Interaction.counter2
	inc (hl)

	ld l,Interaction.xh
	ld a,(hl)
	cp $88
	jr z,+

	; Direction variable functions to determine what side he's on?
	; 0 for right side, 1 for left side?
	ld l,Interaction.direction
	inc (hl)
+
	ld a,(wWildTokayGameLevel)
	ld hl,@speedTable
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.speed
	ld (de),a
	ret

@speedTable:
	.db SPEED_80
	.db SPEED_80
	.db SPEED_80
	.db SPEED_a0
	.db SPEED_a0


; Past NPC in charge of wild tokay game
@initSubid0d:
	call getThisRoomFlags
	bit 6,a
	jr z,@@gameNotActive

	ld a,$81
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld hl,w1Link.yh
	ld (hl),$48
	ld l,<w1Link.xh
	ld (hl),$50
	xor a
	ld l,<w1Link.direction
	ld (hl),a

@@gameNotActive:
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$03
	jp tokayLoadScript


; Generic NPCs
@initSubid12:
@initSubid13:
@initSubid14:
@initSubid15:
@initSubid16:
@initSubid17:
@initSubid18:
	ld e,Interaction.subid
	ld a,(de)
	sub $12
	ld hl,@textIndices
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a
	jp tokayLoadScript

@textIndices:
	.db <TX_0a64 ; Subid $12
	.db <TX_0a65 ; Subid $13
	.db <TX_0a66 ; Subid $14
	.db <TX_0a60 ; Subid $15
	.db <TX_0a61 ; Subid $16
	.db <TX_0a62 ; Subid $17
	.db <TX_0a63 ; Subid $18


; Present NPC in charge of the wild tokay museum
@initSubid19:
	call @initSubid0d
	jp tokayLoadScript


; Subid $1a-$ac: Tokay "statues" in the wild tokay museum

@initSubid1a:
	ld e,Interaction.oamFlags
	ld a,$02
	ld (de),a
	ld e,Interaction.animCounter
	ld a,$01
	ld (de),a
	jp interactionAnimate

@initSubid1c:
	ld a,$09
	call interactionSetAnimation
	call tokayInitMeatAccessory

@initSubid1b:
	ret


; Past NPC standing on cliff at north shore
@initSubid1f:
	ld e,Interaction.textID
	ld a,<TX_0a6c
	ld (de),a
	jp tokayLoadScript




tokayState1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw tokayRunSubid00
	.dw tokayRunSubid01
	.dw tokayRunSubid02
	.dw tokayRunSubid03
	.dw tokayRunSubid04
	.dw tokayRunSubid05
	.dw tokayRunSubid06
	.dw tokayRunSubid07
	.dw tokayRunSubid08
	.dw tokayRunSubid09
	.dw tokayRunSubid0a
	.dw tokayRunSubid0b
	.dw tokayRunSubid0c
	.dw tokayRunSubid0d
	.dw tokayRunSubid0e
	.dw tokayRunSubid0f
	.dw tokayRunSubid10
	.dw tokayRunSubid11
	.dw tokayRunSubid12
	.dw tokayRunSubid13
	.dw tokayRunSubid14
	.dw tokayRunSubid15
	.dw tokayRunSubid16
	.dw tokayRunSubid17
	.dw tokayRunSubid18
	.dw tokayRunSubid19
	.dw tokayRunSubid1a
	.dw tokayRunSubid1b
	.dw tokayRunSubid1c
	.dw tokayRunSubid1d
	.dw tokayRunSubid1e
	.dw tokayRunSubid1f


; Tokays in cutscene who steal your stuff
tokayRunSubid00:
tokayRunSubid01:
tokayRunSubid02:
tokayRunSubid03:
tokayRunSubid04:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw tokayThiefSubstate0
	.dw tokayThiefSubstate1
	.dw tokayThiefSubstate2
	.dw tokayThiefSubstate3
	.dw tokayThiefSubstate4
	.dw tokayThiefSubstate5
	.dw tokayThiefSubstate6


; Substate 0: In the process of removing items from Link's inventory
tokayThiefSubstate0:
	ld e,Interaction.subid
	ld a,(de)
	cp $02
	call z,tokayThief_countdownToStealNextItem

	ld e,Interaction.var39
	ld a,(de)
	or a
	call z,interactionAnimateBasedOnSpeed
	call interactionRunScript
	ret nc

; Script finished; the tokay will now raise the item over its head.

	ld a,$05
	call interactionSetAnimation
	call interactionIncSubstate
	ld l,Interaction.subid
	ld a,(hl)
	ld b,a

	; Only one of them plays the sound effect
	or a
	jr nz,+
	ld a,SND_GETITEM
	call playSound
	ld h,d
+
	ld l,Interaction.counter1
	ld (hl),$5a

;;
; Sets up the graphics for the item that the tokay is holding (ie. shovel, sword)
;
; @param	b	Held item index (0-4)
tokayInitHeldItem:
	call getFreeInteractionSlot
	ret nz
	inc l
	ld a,b
	ld bc,tokayItemGraphics
	call addAToBc
	ld a,(bc)
	ldd (hl),a

;;
; @param	hl	Pointer to an object which will be set to type
;			INTERAC_ACCESSORY.
tokayInitAccessory:
	ld (hl),INTERAC_ACCESSORY
	ld l,Interaction.relatedObj1
	ld (hl),Interaction.enabled
	inc l
	ld (hl),d
	ret

tokayItemGraphics:
	.db $10 $1b $68 $31 $20


;;
; This function counts down a timer in var38, and removes the next item from Link's
; inventory once it hits zero. The next item index to steal is var3a.
tokayThief_countdownToStealNextItem:
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	ld (hl),$0a
	ld l,Interaction.var3a
	ld a,(hl)
	cp $09
	ret z

	inc (hl)
	ld hl,tokayIslandStolenItems
	rst_addAToHl
	ld a,(hl)

	cp TREASURE_SEED_SATCHEL
	jr nz,+
	call loseTreasure
	ld a,TREASURE_EMBER_SEEDS
	call loseTreasure
	ld a,TREASURE_MYSTERY_SEEDS
+
	call loseTreasure
	ld a,SND_UNKNOWN5
	jp playSound


tokayThiefSubstate1:
	call interactionDecCounter1
	ret nz

	; Set how long to wait before jumping based on subid
	ld l,Interaction.subid
	ld a,(hl)
	swap a
	add $14
	ld l,Interaction.counter1
	ld (hl),a

	jp interactionIncSubstate


tokayThiefSubstate2:
	call interactionAnimate3Times
	call interactionDecCounter1
	ret nz

	; Jump away
	ld l,Interaction.angle
	ld (hl),$06
	ld l,Interaction.speed
	ld (hl),SPEED_280

tokayThief_jump:
	call interactionIncSubstate

	ld bc,-$1c0
	call objectSetSpeedZ

	ld a,$05
	call specialObjectSetAnimation
	ld e,Interaction.animCounter
	ld a,$01
	ld (de),a
	call specialObjectAnimate

	ld a,SND_JUMP
	jp playSound


tokayThiefSubstate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$06
	ld a,$05
	jp interactionSetAnimation


tokayThiefSubstate4:
	call interactionDecCounter1
	ret nz
	jr tokayThief_jump


; Wait for tokay to exit screen
tokayThiefSubstate5:
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jr c,@updateSpeedZ

	ld e,Interaction.subid
	ld a,(de)
	cp $03
	jr nz,@delete

	; Only the tokay with subid $03 goes to state 6
	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c
	ret

@delete:
	jp interactionDelete

@updateSpeedZ:
	ld c,$20
	jp objectUpdateSpeedZ_paramC


; Wait for a bit before restoring control to Link
tokayThiefSubstate6:
	call interactionDecCounter1
	ret nz

	xor a
	ld (wDisabledObjects),a
	ld (wUseSimulatedInput),a
	ld (wMenuDisabled),a
	call getThisRoomFlags
	set 6,(hl)

	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound

	call setDeathRespawnPoint
	jp interactionDelete



; NPC who trades meat for stink bag
tokayRunSubid05:
	call interactionRunScript
	jp c,interactionDelete

	ld e,Interaction.var3f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate

	call tokayRunStinkBagCutscene
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; NPC holding something (ie. shovel, harp, shield upgrade).
tokayRunSubid06:
tokayRunSubid07:
tokayRunSubid08:
tokayRunSubid09:
tokayRunSubid0a:
tokayRunSubid1d:
	call interactionRunScript
	ld e,Interaction.var3b
	ld a,(de)
	or a
	jp z,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate


; Linked game cutscene where tokay runs away from Rosa
tokayRunSubid0b:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateBasedOnSpeed


; Participant in Wild Tokay game
tokayRunSubid0c:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw wildTokayParticipantSubstate0
	.dw wildTokayParticipantSubstate1
	.dw wildTokayParticipantSubstate2


wildTokayParticipantSubstate0:
	call wildTokayParticipant_checkGrabMeat

wildTokayParticipantSubstate2:
	call objectApplySpeed
	ld e,Interaction.yh
	ld a,(de)
	add $08
	cp $90
	jp c,interactionAnimateBasedOnSpeed

; Tokay has just left the screen

	; Is he holding meat?
	ld e,Interaction.var3c
	ld a,(de)
	or a
	jr nz,+

	; If so, set failure flag?
	ld a,$ff
	ld ($cfde),a
	jr @delete
+
	; Delete "meat" accessory
	ld e,Interaction.relatedObj2+1
	ld a,(de)
	push de
	ld d,a
	call objectDelete_de

	; If this is the last tokay (colored red), mark "success" condition in $cfde
	pop de
	ld e,Interaction.oamFlags
	ld a,(de)
	cp $02
	jr nz,@delete

	ld a,$01
	ld ($cfde),a
@delete:
	jp interactionDelete

;;
wildTokayParticipant_checkGrabMeat:
	; Check that Link's throwing an item
	ld a,(w1ReservedItemC.enabled)
	or a
	ret z
	ld a,(wLinkGrabState)
	or a
	ret nz

	; Check if the meat has collided with self
	ld a,$0a
	ld hl,w1ReservedItemC.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)
	ld h,d
	ld l,Interaction.yh
	call checkObjectIsCloseToPosition
	ret nc

	call interactionIncSubstate
	ld l,Interaction.var3c
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),$06

	ld a,$07
	ld l,Interaction.direction
	add (hl)
	call interactionSetAnimation
	push de

	; Delete thrown meat
	ld de,w1ReservedItemC.enabled
	call objectDelete_de

	; Delete something?
	ld hl,$cfda
	ldi a,(hl)
	ld e,(hl)
	ld d,a
	call objectDelete_de

	pop de
	ld a,SND_OPENCHEST
	call playSound
	; Fall through

;;
; Creates a graphic of "held meat" for a tokay.
tokayInitMeatAccessory:
	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERAC_ACCESSORY
	inc l
	ld (hl),$73
	inc l
	inc (hl)

	ld l,Interaction.relatedObj1
	ld (hl),Interaction.enabled
	inc l
	ld (hl),d

	ld e,Interaction.relatedObj2+1
	ld a,h
	ld (de),a
	ret


wildTokayParticipantSubstate1:
	call interactionDecCounter1
	ret nz
	jp interactionIncSubstate



; Past and present NPCs in charge of wild tokay game
tokayRunSubid0d:
tokayRunSubid19:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Not running game
@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call interactionRunScript
	jp nc,interactionAnimateAsNpc

; Script ended; that means the game should begin.

	; Create meat spawner?
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_WILD_TOKAY_CONTROLLER
	call interactionIncSubstate
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	jp fadeoutToWhite

; Beginning game (will delete self when the game is initialized)
@substate1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	push de
	call clearAllItemsAndPutLinkOnGround
	pop de
	ld e,Interaction.subid
	ld a,(de)

	; Check if in present or past
	cp $19
	jr nz,++
	ld a,$01
	ld ($cfc0),a
++
	jp interactionDelete


; Subids $0f-$10: Tokays who try to eat Dimitri
tokayRunSubid0f:
	ld a,(wScrollMode)
	and $0e
	ret nz

tokayRunSubid10:
	ld a,(w1Companion.var3e)
	and $04
	jr nz,++
	; Fall through


; Shopkeeper, and past NPC looking after scent seedling
tokayRunSubid0e:
tokayRunSubid11:
	call interactionAnimateAsNpc
++
	call interactionRunScript
	ret nc
	jp interactionDelete


; Present NPC who talks to you after climbing down vine
tokayRunSubid1e:
	ld c,$10
	call objectUpdateSpeedZ_paramC
	call interactionAnimateAsNpc
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionRunScript

	ld c,$18
	call objectCheckLinkWithinDistance
	ret nc

	ld e,Interaction.var31
	ld (de),a
	jp interactionRunScript


; Subids $12-$18 and $1f: Generic NPCs
tokayRunSubid12:
tokayRunSubid13:
tokayRunSubid14:
tokayRunSubid15:
tokayRunSubid16:
tokayRunSubid17:
tokayRunSubid18:
tokayRunSubid1f:
	call interactionRunScript
	jp npcFaceLinkAndAnimate


; Subids $1a-$1c: Tokay "statues" in the wild tokay museum
tokayRunSubid1a:
tokayRunSubid1b:
tokayRunSubid1c:
	ld a,(wTmpcfc0.wildTokay.inPresent)
	or a
	ret z
	jp interactionDelete


;;
; Cutscene where tokay smells stink bag and jumps around like a madman.
;
; On return, var3e will be 0 if he's currently at his starting position, otherwise it will
; be 1.
tokayRunStinkBagCutscene:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_300

@beginNextJump:
	ld h,d
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.var39
	ld (hl),a

	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3a
	ld (hl),a

	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.var3e
	ld (hl),$01

	call @initJumpVariables

	ld a,SND_JUMP
	jp playSound

; Set angle, speedZ, and var3c (gravity) for the next jump.
@initJumpVariables:
	ld h,d
	ld l,Interaction.var3b
	ld a,(hl)
	add a
	ld bc,@jumpPaths
	call addDoubleIndexToBc

	ld a,(bc)
	inc bc
	ld l,Interaction.angle
	ld (hl),a
	ld a,(bc)
	inc bc
	ld l,Interaction.speedZ
	ldi (hl),a
	ld a,(bc)
	inc bc
	ld (hl),a
	ld a,(bc)
	ld l,Interaction.var3c
	ld (hl),a
	ret

; Data format:
;   byte: angle
;   word: speedZ
;   byte: var3c (gravity)
@jumpPaths:
	dbwb $18, -$800, -$08
	dbwb $0a, -$c00, -$08
	dbwb $02, -$800, -$08
	dbwb $14, -$c00, -$08
	dbwb $06, -$e00, -$08
	dbwb $18, -$a00, -$08

@substate1:
	; Apply gravity and update speed
	ld e,Interaction.var3c
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call interactionIncSubstate
	ld l,Interaction.var3b
	ld a,(hl)
	cp $05
	ret nz

	; He's completed one loop. Restore y/x to precise values to prevent "drifting" off
	; course?
	ld l,Interaction.y
	ld (hl),$00
	inc l
	ld (hl),$28
	ld l,Interaction.x
	ld (hl),$00
	inc l
	ld (hl),$48

	ld l,Interaction.var3e
	ld (hl),$00
	ret

@substate2:
	; Increment "jump index", and loop back to 0 when appropriate.
	ld h,d
	ld l,Interaction.var3b
	inc (hl)
	ld a,(hl)
	cp $06
	jr c,+
	ld (hl),$00
+
	jp @beginNextJump

;;
tokayLoadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,tokayScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

tokayScriptTable:
	/* $00 */ .dw mainScripts.tokayThiefScript
	/* $01 */ .dw mainScripts.tokayThiefScript
	/* $02 */ .dw mainScripts.tokayMainThiefScript
	/* $03 */ .dw mainScripts.tokayThiefScript
	/* $04 */ .dw mainScripts.tokayThiefScript
	/* $05 */ .dw mainScripts.tokayCookScript
	/* $06 */ .dw mainScripts.tokayHoldingItemScript
	/* $07 */ .dw mainScripts.tokayHoldingItemScript
	/* $08 */ .dw mainScripts.tokayHoldingItemScript
	/* $09 */ .dw mainScripts.tokayHoldingItemScript
	/* $0a */ .dw mainScripts.tokayHoldingItemScript
	/* $0b */ .dw mainScripts.tokayRunningFromRosaScript
	/* $0c */ .dw mainScripts.stubScript
	/* $0d */ .dw mainScripts.tokayGameManagerScript_past
	/* $0e */ .dw mainScripts.tokayShopkeeperScript
	/* $0f */ .dw mainScripts.tokayWithDimitri1Script
	/* $10 */ .dw mainScripts.tokayWithDimitri2Script
	/* $11 */ .dw mainScripts.tokayAtSeedlingPlotScript
	/* $12 */ .dw mainScripts.genericNpcScript
	/* $13 */ .dw mainScripts.genericNpcScript
	/* $14 */ .dw mainScripts.genericNpcScript
	/* $15 */ .dw mainScripts.genericNpcScript
	/* $16 */ .dw mainScripts.genericNpcScript
	/* $17 */ .dw mainScripts.genericNpcScript
	/* $18 */ .dw mainScripts.genericNpcScript
	/* $19 */ .dw mainScripts.tokayGameManagerScript_present
	/* $1a */ .dw $0000
	/* $1b */ .dw $0000
	/* $1c */ .dw $0000
	/* $1d */ .dw mainScripts.tokayWithShieldUpgradeScript
	/* $1e */ .dw mainScripts.tokayExplainingVinesScript
	/* $1f */ .dw mainScripts.genericNpcScript
