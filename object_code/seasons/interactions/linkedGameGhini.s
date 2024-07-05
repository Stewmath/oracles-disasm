; ==================================================================================================
; INTERAC_LINKED_GAME_GHINI
; ==================================================================================================
interactionCodecb:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld e,$42
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
	ld l,$79
	ld (hl),$78
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
	ld l,$42
	ld a,(hl)
	ld l,$5c
	ld (hl),a
	ld l,$44
	ld (hl),$02
	ld l,$46
	ld (hl),$1e
	ld l,$4b
	ld a,(hl)
	ld l,$7b
	ld (hl),a
	ld l,$4d
	ld a,(hl)
	ld l,$7c
	ld (hl),a
	call getRandomNumber
	and $02
	dec a
	ld e,$7e
	ld (de),a
	call getRandomNumber
	and $1f
	ld e,$49
	ld (de),a
	call getRandomNumber
	and $03
	ld hl,@@table_7b4d
	rst_addAToHl
	ld a,(hl)
	ld e,$7d
	ld (de),a
	call func_7c3f
	jp objectSetVisible81
@@table_7b4d:
	.db $03 $04 $05 $06

@@subid3:
	call checkIsLinkedGame
	jp z,interactionDelete
	call interactionInitGraphics
	ld h,d
	ld l,$5c
	ld (hl),$02
	ld l,$44
	ld (hl),$03
	ld l,$7e
	ld (hl),GLOBALFLAG_BEGAN_LIBRARY_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld hl,mainScripts.linkedGameNpcScript
	call interactionSetScript
	jp interactionAnimateAsNpc

@state1:
	ld e,$45
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
	jp func_7c0f
@@substate1:
	call func_7bf9
	ret nz
	ld l,$45
	inc (hl)
	ld l,$79
	ld (hl),$3c
	ret
@@substate2:
	call func_7bf9
	ret nz
	ld l,$45
	inc (hl)
	ld hl,mainScripts.linkedGhiniScript_startRound
	call interactionSetScript
@@substate3:
	call interactionAnimate
	call objectPreventLinkFromPassing
	call interactionRunScript
	ret nc
	ld h,d
	ld l,$45
	ld (hl),$01
	ld l,$7f
	ld a,(hl)
	cp $00
	jp z,func_71c5
	jp func_7c0f
@state2:
	call interactionAnimate
	call @func_7be1
	call func_7bf9
	jp z,interactionDelete
	ld l,$46
	ld a,(hl)
	or a
	ret nz
	ld l,$7d
	ld a,(hl)
	ld l,$7b
	ld b,(hl)
	ld l,$7c
	ld c,(hl)
	ld e,$7f
	call objectSetPositionInCircleArc
	jp func_7bfe

@func_7be1:
	ld h,d
	ld l,$46
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
func_7bf9:
	ld h,d
	ld l,$79
	dec (hl)
	ret
func_7bfe:
	ld a,(wFrameCounter)
	rrca
	ret nc
	ld h,d
	ld l,$7e
	ld b,(hl)
	ld l,$7f
	ld a,(hl)
	add b
	and $1f
	ld (hl),a
	ret
func_7c0f:
	ld e,$7a
	xor a
	ld (de),a
	jr ++
func_71c5:
	ld e,$7a
	ld a,(de)
	inc a
	cp $03
	jr c,+
	xor a
+
	ld (de),a
++
	call func_7c3f
	call getRandomNumber
	and $01
	ld e,$7c
	ld (de),a
	push de
	call clearEnemies
	call clearItems
	call clearParts
	pop de
	xor a
	ld ($cc30),a
	call func_7c50
	jp func_7cce
func_7c3f:
	ld e,$7a
	ld a,(de)
	ld bc,table_7c4d
	call addAToBc
	ld a,(bc)
	ld e,$79
	ld (de),a
	ret
table_7c4d:
	.db $f0 $b4 $78

func_7c50:
	ld hl,$cee0
	xor a
-
	ldi (hl),a
	inc a
	cp $0d
	jr nz,-
	ld e,$7d
	ld (de),a
	xor a
	ld e,$7b
	ld (de),a
	ret
func_7c62:
	ld e,$7d
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
	ld e,$7e
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
func_7c8a:
	ld h,d
	ld l,$7a
	ld a,(hl)
	swap a
	ld l,$7b
	add (hl)
	ld bc,table_7c9e
	call addAToBc
	ld a,(bc)
	ld l,$7c
	xor (hl)
	ret
table_7c9e:
	.db $01 $01 $01 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $01 $01 $01 $01 $01 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $01 $01 $01 $01 $01 $01 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00

func_7cce:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_LINKED_GAME_GHINI
	inc hl
	push hl
	call func_7c8a
	pop hl
	inc a
	ld (hl),a
	ld e,$7a
	ld a,(de)
	ld l,$7a
	ld (hl),a
	push hl
	call func_7c62
	pop hl
	ld e,$7e
	ld a,(de)
	ld bc,table_7d03
	call addDoubleIndexToBc
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	ld e,$7b
	ld a,(de)
	inc a
	ld (de),a
	cp $0d
	jr nz,func_7cce
	ret
table_7d03:
	.db $1c $20 $1c $40 $1c $60 $1c $80
	.db $34 $30 $34 $50 $34 $70 $4c $20
	.db $4c $40 $4c $60 $4c $80 $64 $30
	.db $64 $70
