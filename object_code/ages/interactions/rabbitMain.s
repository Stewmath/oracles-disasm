; ==================================================================================================
; INTERAC_RABBIT
; ==================================================================================================
interactionCode4b_body:
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
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5
	.dw @initSubid6
	.dw @initSubid7

@initSubid0:
	ld hl,mainScripts.rabbitScript_listeningToNayruGameStart
	jp interactionSetScript

; This is also called from outside this interaction's code
@initSubid1:
	ld h,d
	ld l,Interaction.angle
	ld (hl),$18
	ld l,Interaction.speed
	ld (hl),SPEED_180

@setJumpAnimation:
	ld a,$05
	call interactionSetAnimation

	ld bc,-$180
	jp objectSetSpeedZ

@initSubid2:
	ld e,Interaction.counter1
	ld a,180
	ld (de),a
	callab agesInteractionsBank08.loadStoneNpcPalette
	jp rabbitSubid2SetRandomSpawnDelay

@initSubid6:
	; Delete if veran defeated
	ld hl,wGroup4RoomFlags+$fc
	bit 7,(hl)
	jp nz,interactionDelete

	; Delete if haven't beaten Jabu
	ld a,(wEssencesObtained)
	bit 6,a
	jp z,interactionDelete

	callab agesInteractionsBank08.loadStoneNpcPalette
	ld a,$06
	call objectSetCollideRadius

@initSubid3:
	ld a,120
	ld e,Interaction.counter1
	ld (de),a

@setStonePaletteAndAnimation:
	ld a,$06
	ld e,Interaction.oamFlags
	ld (de),a
	jp interactionSetAnimation

@initSubid5:
	call interactionLoadExtraGraphics
	ld h,d
	ld l,Interaction.counter1
	ld (hl),$0e
	inc l
	ld (hl),$01
	jr @setStonePaletteAndAnimation

@initSubid4:
	call interactionLoadExtraGraphics
	jp rabbitJump

@initSubid7:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_MAKU_TREE_SAVED
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_SAVED_NAYRU
	call checkGlobalFlag
	ld hl,mainScripts.rabbitScript_waitingForNayru1
	jp z,+
	ld hl,mainScripts.rabbitScript_waitingForNayru2
+
	call interactionSetScript

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw rabbitSubid0
	.dw rabbitSubid1
	.dw rabbitSubid2
	.dw rabbitSubid3
	.dw rabbitSubid4
	.dw rabbitSubid5
	.dw interactionPushLinkAwayAndUpdateDrawPriority
	.dw rabbitSubid7


; Listening to Nayru at the start of the game
rabbitSubid0:
	call interactionAnimateAsNpc
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)
	cp $0e
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld a,$02
	jp interactionSetAnimation

@substate1:
	ld a,($cfd0)
	cp $10
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),40
	ret

@substate2:
	call interactionDecCounter1
	jp nz,interactionAnimate

	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$06
	ld l,Interaction.speed
	ld (hl),SPEED_180

@jump:
	ld bc,-$200
	call objectSetSpeedZ
	ld a,$04
	jp interactionSetAnimation

@substate3:
	call objectCheckWithinScreenBoundary
	jp nc,interactionDelete
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	jr @jump


rabbitSubid1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,@updateSubstate
	dec (hl)
	jr nz,@updateSubstate

	inc l
	ld a,30 ; [counter2] = 30

	ld (hl),a
	ld l,Interaction.substate
	ld (hl),$02
	ld bc,$f000
	call objectCreateExclamationMark

@updateSubstate:
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

; This is also called by subids 1 and 3
@substate0:
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	ld a,SND_JUMP
	call playSound
	jp interactionIncSubstate

; This is also called by subids 1 and 3
@substate1:
	ld e,Interaction.xh
	ld a,(de)
	cp $d0
	jp nc,interactionDelete

	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,Interaction.substate
	dec (hl)
	jp interactionCode4b_body@setJumpAnimation

@substate2:
	call interactionDecCounter2
	ret nz

	ld (hl),60
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3d
	ld (hl),a
	jp interactionIncSubstate

@substate3:
	callab agesInteractionsBank08.interactionOscillateXRandomly
	call interactionDecCounter2
	ret nz
	ld (hl),20

	; Set stone color
	ld l,Interaction.oamFlags
	ld (hl),$06

	jp interactionIncSubstate

@substate4:
	call interactionDecCounter2
	ret nz

	ld bc,$0000
	call objectSetSpeedZ
	jp interactionIncSubstate

@substate5:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	call interactionIncSubstate
	ld l,Interaction.counter2
	ld (hl),240
	ld a,$04
	jp setScreenShakeCounter

@substate6:
	call interactionDecCounter2
	ret nz
	ld a,$ff
	ld ($cfdf),a
	ret


; "Controller" for the cutscene where rabbits turn to stone? (spawns subid $01)
rabbitSubid2:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	call z,spawnNextRabbitThatTurnsToStone
+
	; After a random delay, spawn a rabbit that just runs across the screen (doesn't
	; turn to stone)
	ld h,d
	ld l,Interaction.var38
	dec (hl)
	ret nz

	call getRandomNumber_noPreserveVars
	and $07
	ld hl,rabbitSubid2YPositions
	rst_addAToHl
	ld b,(hl)
	call getRandomNumber
	and $0f
	cpl
	inc a
	add $b0
	ld c,a
	call spawnRabbitWithSubid1
	jp rabbitSubid2SetRandomSpawnDelay


; Rabbit being restored from stone cutscene (gets restored and jumps away)
rabbitSubid3:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw rabbitSubid1@substate0
	.dw rabbitSubid1@substate1

@substate0:
	call interactionDecCounter1
	ret nz
	ld (hl),$5a
	ld a,$01
	ld ($cfd1),a
	ld a,SND_RESTORE
	call playSound
	jp interactionIncSubstate

; This is also called from subid 5
@substate1:
	call interactionDecCounter1
	jr z,+
	jpab agesInteractionsBank08.childFlickerBetweenStone
+
	call interactionIncSubstate
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.var38
	ld (hl),$20
	jp interactionCode4b_body@initSubid1


; Rabbit being restored from stone cutscene (the one that wasn't stone)
rabbitSubid4:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw rabbitSubid4Substate2
	.dw rabbitSubid5@substate3
	.dw rabbitSubid5@ret

@substate0:
	ld a,($cfd1)
	cp $01
	jr nz,++

	ld h,d
	ld l,Interaction.substate
	ld (hl),$02
	ld hl,mainScripts.rabbitSubid4Script
	jp interactionSetScript
++
	call interactionAnimate
	ld e,Interaction.animParameter
	ld a,(de)
	or a
	ret z
	jp interactionIncSubstate

@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz

	ld h,d
	ld l,Interaction.substate
	dec (hl)

;;
rabbitJump:
	ld a,$07
	call interactionSetAnimation
	ld bc,-$e0
	jp objectSetSpeedZ


rabbitSubid4Substate2:
	ld a,($cfd1)
	cp $02
	jp nz,interactionRunScript

	call interactionIncSubstate
	ld l,Interaction.angle
	ld (hl),$18

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	ld bc,-$180
	call objectSetSpeedZ

	ld a,$09
	jp interactionSetAnimation

rabbitSubid5:
	ld h,d
	ld l,Interaction.var38
	ld a,(hl)
	or a
	jr z,@updateSubstate
	dec (hl)
	jr nz,@updateSubstate

	; Just collided with another rabbit?

	ld l,Interaction.substate
	ld (hl),$04
	ld l,Interaction.angle
	ld (hl),$08

	ld l,Interaction.speed
	ld (hl),SPEED_a0
	ld bc,-$1e0
	call objectSetSpeedZ

	ldbc INTERAC_CLINK,$80
	call objectCreateInteraction
	jr nz,@label_3f_367

	ld a,SND_DAMAGE_ENEMY
	call playSound
	ld a,$02
	ld ($cfd1),a

@label_3f_367:
	ld a,$08
	call interactionSetAnimation

@updateSubstate:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw rabbitSubid3@substate1
	.dw rabbitSubid1@substate0
	.dw rabbitSubid1@substate1
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d
	ld l,Interaction.counter1
	call decHlRef16WithCap
	ret nz

	ld (hl),$5a
	call interactionIncSubstate
	ld a,SND_RESTORE
	jp playSound

; Also called from subid 4
@substate3:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	ret nc

	call interactionIncSubstate
	ld l,Interaction.counter1
	ld (hl),$3c

@ret:
	ret

@substate4:
	call interactionDecCounter1
	ret nz

	ld a,$ff
	ld ($cfdf),a
	ret


; Generic NPC waiting around in the spot Nayru used to sing
rabbitSubid7:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

;;
; This might be setting one of 4 possible speed values to var38?
rabbitSubid2SetRandomSpawnDelay:
	call getRandomNumber_noPreserveVars
	and $03
	ld bc,rabbitSubid2SpawnDelays
	call addAToBc
	ld a,(bc)
	ld e,Interaction.var38
	ld (de),a
	ret

;;
; hl should point to "counter1".
spawnNextRabbitThatTurnsToStone:
	; Increment counter2, the index of the rabbit to spawn (0-2)
	inc l
	ld a,(hl)
	inc (hl)

	ld b,a
	add a
	add b
	ld hl,@data
	rst_addAToHl
	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld b,(hl)
	inc hl
	ld c,(hl)

	; Spawn a rabbit that will turn to stone after 95 frames
	call spawnRabbitWithSubid1
	ld l,Interaction.counter1
	ld (hl),95
	ret

; Data for the rabbits that turn to stone in a cutscene. Format:
;   b0: Frames until next rabbit is spawned?
;   b1: Y position
;   b2: X position
@data:
	.db $5a $28 $b8
	.db $1e $40 $a8
	.db $00 $50 $c8

;;
; Spawns a rabbit for the cutscene where a bunch of rabbits turn to stone
;
; @param	bc	Position
spawnRabbitWithSubid1;
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_RABBIT
	inc l
	inc (hl)
	jp interactionHSetPosition


; A byte from here is chosen randomly to spawn a rabbit at.
rabbitSubid2YPositions:
	.db $66 $5e $58 $46 $3a $30 $20 $18

; A byte from here is chosen randomly as a delay before spawning another rabbit.
rabbitSubid2SpawnDelays:
	.db $1e $3c $50 $78
