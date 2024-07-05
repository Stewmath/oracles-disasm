; ==================================================================================================
; INTERAC_TROY
; ==================================================================================================
interactionCodeca:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	call interactionInitGraphics
	call interactionIncState
	call func_7aa7
	ld a,>TX_4c00
	call interactionSetHighTextIndex
	ld a,GLOBALFLAG_DONE_CLOCK_SHOP_SECRET
	call checkGlobalFlag
	jr z,+
	ld hl,mainScripts.troyScript_doneSecret
	jr ++
+
	ld a,GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET
	call checkGlobalFlag
	ld hl,mainScripts.troyScript_beginningSecret
	jr z,++
	ld hl,mainScripts.troyScript_beganSecret
++
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@state1:
	call interactionRunScript
	ld e,$7b
	ld a,(de)
	or a
	ret nz
	jp npcFaceLinkAndAnimate
@state2:
	call func_79df
	call interactionDecCounter1
	jr nz,+
	ld (hl),$b4
	call func_7a0d
+
	ld hl,$ccf8
	ldi a,(hl)
	cp $30
	jr nz,+
	ld a,(hl)
	cp $00
	jr nz,+
	ld a,$01
	jr ++
+
	ld h,d
	ld l,$78
	ld a,(hl)
	cp $0c
	ret nz
	ld a,(wNumEnemies)
	or a
	ret nz
	ld a,$00
++
	ld h,d
	ld l,$7a
	ld (hl),a
	ld l,$44
	ld (hl),$01
	callab scriptHelp.linkedFunc_15_6430
	ld hl,mainScripts.troyScript_gameBegun
	call interactionSetScript
	ret
	ld hl,$ccf7
	xor a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ret
func_79df:
	ld hl,$ccf7
	ldi a,(hl)
	cp $59
	jr nz,+
	ldi a,(hl)
	cp $59
	jr nz,+
	ld a,(hl)
	cp $99
	ret z
+
	ld hl,$ccf7
	call func_7a01
	ret nz
	inc hl
	call func_7a01
	ret nz
	inc hl
	ld b,$00
	jr +
func_7a01:
	ld b,$60
+
	ld a,(hl)
	add $01
	daa
	cp b
	jr nz,+
	xor a
+
	ld (hl),a
	ret
func_7a0d:
	ld a,$04
	ld hl,$cc30
	sub (hl)
	ret z
	ldh (<hFF8D),a
	call getRandomNumber
	and $03
	ld e,$79
	ld (de),a
	xor a
--
	inc a
	ldh (<hFF8B),a
	ld h,d
	ld l,$78
	ld a,(hl)
	cp $0c
	jr z,+
	inc a
	ld (hl),a
	ld hl,table_7a3d-1
	rst_addAToHl
	ld a,(hl)
	call func_7a49
	ldh a,(<hFF8B)
	ld hl,$ff8d
	cp (hl)
func_7a3a:
	jr nz,--
+
	ret

table_7a3d:
	; lookup into enemy table below
	.db $00 $00
	.db $00 $00
	.db $01 $01
	.db $02 $03
	.db $04 $05
	.db $06 $07
func_7a49:
	ld bc,table_7a76
	call addDoubleIndexToBc
	call getFreeEnemySlot
	ret nz
	ld a,(bc)
	ldi (hl),a
	inc bc
	ld a,(bc)
	ldi (hl),a
	ld e,$79
	ld a,(de)
	inc a
	and $03
	ld (de),a
	ld bc,table_7a86
	call addDoubleIndexToBc
	ld l,$8b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$8d
	ld a,(bc)
	ld (hl),a
	ld l,$81
	ld a,(hl)
	cp $10
	ret z
	jr func_7a8e
table_7a76:
	.db ENEMY_ROPE $01
	.db ENEMY_MASKED_MOBLIN $00
	.db ENEMY_SWORD_DARKNUT $00
	.db ENEMY_SWORD_DARKNUT $01
	.db ENEMY_WIZZROBE $01
	.db ENEMY_WIZZROBE $02
	.db ENEMY_LYNEL $00
	.db ENEMY_LYNEL $01
table_7a86:
	.db $30 $40
	.db $30 $b0
	.db $80 $40
	.db $80 $b0
func_7a8e:
	ld e,$79
	ld a,(de)
	ld bc,table_7a86
	call addDoubleIndexToBc
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,$4b
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,$4d
	ld a,(bc)
	ld (hl),a
	ret
func_7aa7:
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	jr nc,@nobleSword
	cp $03
	jp nc,@nobleSword
	sub $01
-
	ld e,Interaction.var03
	ld (de),a
	ret
@nobleSword:
	ld a,$01
	jr -
