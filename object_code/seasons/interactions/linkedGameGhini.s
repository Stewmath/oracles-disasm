; ==================================================================================================
; INTERAC_LINKED_GAME_GHINI
;
; Variables:
;   For subid 0 (secret ghini)
;   var39: Counter before going to the next substate
;   var3a: Current stage of the secret
;   var3c: Correct answer
; ==================================================================================================
interactionCodecb:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
@@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.var39
	ld (hl),120
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld a,GLOBALFLAG_DONE_GRAVEYARD_SECRET
	call checkGlobalFlag
	jr z,@@notDoneSecret
	ld hl,mainScripts.linkedGhiniScript_doneSecret
	jr @@setScript
@@notDoneSecret:
	ld a,GLOBALFLAG_BEGAN_GRAVEYARD_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.linkedGhiniScript_beginningSecret
	jr z,@@setScript
	ld hl,mainScripts.linkedGhiniScript_begunSecret
@@setScript:
	call interactionSetScript
	jp objectSetVisible81
@@subid1:
@@subid2:
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.subid
	ld a,(hl)
	ld l,Interaction.oamFlags
	ld (hl),a
	ld l,Interaction.state
	ld (hl),$02
	ld l,Interaction.counter1
	ld (hl),$1e
	ld l,Interaction.yh
	ld a,(hl)
	ld l,Interaction.var3b
	ld (hl),a
	ld l,Interaction.xh
	ld a,(hl)
	ld l,Interaction.var3c
	ld (hl),a
	call getRandomNumber
	and $02
	dec a
	ld e,Interaction.var3e
	ld (de),a
	call getRandomNumber
	and $1f
	ld e,Interaction.angle
	ld (de),a
	call getRandomNumber
	and $03
	ld hl,@@table_7b4d
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3d
	ld (de),a
	call @setRoundTimer
	jp objectSetVisible81
@@table_7b4d:
	.db $03 $04 $05 $06

@@subid3:
	call checkIsLinkedGame
	jp z,interactionDelete
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.oamFlags
	ld (hl),$02
	ld l,Interaction.state
	ld (hl),$03
	ld l,Interaction.var3e
	ld (hl),GLOBALFLAG_BEGAN_LIBRARY_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	jp interactionAnimateAsNpc

@state1:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call interactionRunScript
	ret nc
	call interactionIncSubstate
	jp @func_7c0f
@@substate1:
	call @waitVar39
	ret nz
	ld l,Interaction.substate
	inc (hl)
	ld l,Interaction.var39
	ld (hl),60
	ret
@@substate2:
	call @waitVar39
	ret nz
	ld l,Interaction.substate
	inc (hl)
	ld hl,mainScripts.linkedGhiniScript_startRound
	call interactionSetScript
@@substate3:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call interactionRunScript
	ret nc
	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.var3f
	ld a,(hl)
	cp $00
	jp z,@func_71c5
	jp @func_7c0f
@state2:
	call interactionAnimate
	call @func_7be1
	call @waitVar39
	jp z,interactionDelete
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	ret nz
	ld l,Interaction.var3d
	ld a,(hl)
	ld l,Interaction.var3b
	ld b,(hl)
	ld l,Interaction.var3c
	ld c,(hl)
	ld e,Interaction.var3f
	call objectSetPositionInCircleArc
	jp @func_7bfe

@func_7be1:
	ld h,d
	ld l,Interaction.counter1
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ld a,(wFrameCounter)
	rrca
	jp nc,objectSetInvisible
+
	jp objectSetVisible
@state3:
	call interactionRunScript
	jp interactionAnimateAsNpc

@waitVar39:
	ld h,d
	ld l,Interaction.var39
	dec (hl)
	ret

@func_7bfe:
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld h,d
	ld l,Interaction.var3e
	ld b,(hl)
	ld l,Interaction.var3f
	ld a,(hl)
	add b
	and $1f
	ld (hl),a
	ret
@func_7c0f:
	ld e,Interaction.var3a
	xor a
	ld (de),a
	jr ++
@func_71c5:
	ld e,Interaction.var3a
	ld a,(de)
	inc a
	cp $03
	jr c,+
	xor a
+
	ld (de),a
++
	call @setRoundTimer

	; Choose the correct answer
	call getRandomNumber
	and $01
	ld e,Interaction.var3c
	ld (de),a

	push de
	call clearEnemies
	call clearItems
	call clearParts
	pop de
	xor a
	ld ($cc30),a
	call @func_7c50
	jp @spawnGhinis

@setRoundTimer:
	ld e,Interaction.var3a
	ld a,(de)
	ld bc,@roundTimerTable
	call addAToBc
	ld a,(bc)
	ld e,Interaction.var39
	ld (de),a
	ret
@roundTimerTable:
	.db 240 180 120

@func_7c50:
	ld hl,$cee0
	xor a
-
	ldi (hl),a
	inc a
	cp $0d
	jr nz,-
	ld e,Interaction.var3d
	ld (de),a
	xor a
	ld e,Interaction.var3b
	ld (de),a
	ret
@func_7c62:
	ld e,Interaction.var3d
	ld a,(de)
	ld b,a
	dec a
	ld (de),a
	call getRandomNumber
-
	sub b
	jr nc,-
	add b
	ld c,a
	ld hl,$cee0
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var3e
	ld (de),a
	push de
	ld d,c
	ld e,b
	dec e
	ld b,h
	ld c,l
-
	ld a,d
	cp e
	jr z,+
	inc bc
	ld a,(bc)
	ldi (hl),a
	inc d
	jr -
+
	pop de
	ret

;;
; @param[in]	d	Address of the secret ghini (subid 0)
; @param[out]	a	Color of the ghini to be spawned (0 for blue, 1 for red)
@getColor:
	ld h,d
	ld l,Interaction.var3a
	ld a,(hl)
	swap a
	ld l,Interaction.var3b
	add (hl)
	ld bc,@colorTable
	call addAToBc
	ld a,(bc)
	ld l,Interaction.var3c
	xor (hl)
	ret

@colorTable:
	; Stage 1 : 3 not matching
	.db $01 $01 $01 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	; Stage 2 : 5 not matching
	.db $01 $01 $01 $01 $01 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	; Stage 3 : 6 not matching
	.db $01 $01 $01 $01 $01 $01 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00

@spawnGhinis:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_LINKED_GAME_GHINI
	inc hl
	push hl
	call @getColor
	pop hl
	inc a
	ld (hl),a
	ld e,Interaction.var3a
	ld a,(de)
	ld l,Interaction.var3a
	ld (hl),a
	push hl
	call @func_7c62
	pop hl
	ld e,Interaction.var3e
	ld a,(de)
	ld bc,@ghiniPositions
	call addDoubleIndexToBc
	ld l,Interaction.yh
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	ld (hl),a
	ld e,Interaction.var3b
	ld a,(de)
	inc a
	ld (de),a
	cp $0d
	jr nz,@spawnGhinis
	ret
@ghiniPositions:
	.db $1c $20 $1c $40 $1c $60 $1c $80
	.db $34 $30 $34 $50 $34 $70 $4c $20
	.db $4c $40 $4c $60 $4c $80 $64 $30
	.db $64 $70
