; ==============================================================================
;INTERACID_BOOMERANG_SUBROSIAN
; ==============================================================================
interactionCodec8:
	ld e,$44		; $7884
	ld a,(de)		; $7886
	rst_jumpTable			; $7887
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $788c
	ld (de),a		; $788e
	ld a,$28		; $788f
	ld e,$78		; $7891
	ld (de),a		; $7893
	call interactionInitGraphics		; $7894
	call objectGetTileAtPosition		; $7897
	ld (hl),$00		; $789a
	ld hl,boomerangSubrosianScript		; $789c
	call interactionSetScript		; $789f
	call @func_78cc		; $78a2
@state1:
	call interactionRunScript		; $78a5
	call interactionPushLinkAwayAndUpdateDrawPriority		; $78a8
	ld e,$45		; $78ab
	ld a,(de)		; $78ad
	rst_jumpTable			; $78ae
	.dw @substate0
	.dw @substate1
@substate0:
	ld h,d			; $78b3
	ld l,$78		; $78b4
	dec (hl)		; $78b6
	ret nz			; $78b7
	call interactionIncState2		; $78b8
	ld b,INTERACID_BOOMERANG		; $78bb
	call objectCreateInteractionWithSubid00		; $78bd
	jr nz,+			; $78c0
	ld l,$56		; $78c2
	ld (hl),e		; $78c4
	inc l			; $78c5
	ld (hl),d		; $78c6
+
	ld h,d			; $78c7
	ld l,$77		; $78c8
	ld (hl),$01		; $78ca
@func_78cc:
	ld l,$60		; $78cc
	ld (hl),$01		; $78ce
	jp interactionAnimate		; $78d0
@substate1:
	ld e,$77		; $78d3
	ld a,(de)		; $78d5
	or a			; $78d6
	ret nz			; $78d7
	ld h,d			; $78d8
	ld l,$45		; $78d9
	dec (hl)		; $78db
	call @func_78cc		; $78dc
	call getRandomNumber_noPreserveVars		; $78df
	and $3f			; $78e2
	add $3c			; $78e4
	ld e,$78		; $78e6
	ld (de),a		; $78e8
	ret			; $78e9


; ==============================================================================
; INTERACID_BOOMERANG
; ==============================================================================
interactionCodec9:
	ld e,$44		; $78ea
	ld a,(de)		; $78ec
	rst_jumpTable			; $78ed
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $78f2
	ld (de),a		; $78f4
	call interactionInitGraphics		; $78f5
	ld h,d			; $78f8
	ldbc $41 $28		; $78f9
	ld l,$50		; $78fc
	ld (hl),b		; $78fe
	ld l,$46		; $78ff
	ld (hl),c		; $7901
	ld l,$49		; $7902
	ld (hl),$18		; $7904
	jp objectSetVisible82		; $7906
@state1:
	ld e,$45		; $7909
	ld a,(de)		; $790b
	rst_jumpTable			; $790c
	.dw @substate0
	.dw @substate1
@substate0:
	call interactionDecCounter1		; $7911
	jr nz,+			; $7914
	ld l,$49		; $7916
	ld (hl),$08		; $7918
	call interactionIncState2		; $791a
+
	call objectApplySpeed		; $791d
--
	ld h,d			; $7920
	ld l,$61		; $7921
	ld a,(hl)		; $7923
	or a			; $7924
	ld (hl),$00		; $7925
	ld a,$78		; $7927
	call nz,playSound		; $7929
	jp interactionAnimate		; $792c
@substate1:
	call objectApplySpeed		; $792f
	call objectGetRelatedObject1Var		; $7932
	ld l,$4d		; $7935
	ld e,l			; $7937
	ld a,(de)		; $7938
	add $08			; $7939
	cp (hl)			; $793b
	jr c,--			; $793c
	ld l,$77		; $793e
	ld (hl),$00		; $7940
	jp interactionDelete		; $7942


; ==============================================================================
; INTERACID_TROY
; ==============================================================================
interactionCodeca:
	ld e,$44		; $7945
	ld a,(de)		; $7947
	rst_jumpTable			; $7948
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $794f
	call checkGlobalFlag		; $7951
	jp z,interactionDelete		; $7954
	call interactionInitGraphics		; $7957
	call interactionIncState		; $795a
	call _func_7aa7		; $795d
	ld a,>TX_4c00		; $7960
	call interactionSetHighTextIndex		; $7962
	ld a,GLOBALFLAG_DONE_CLOCK_SHOP_SECRET		; $7965
	call checkGlobalFlag		; $7967
	jr z,+			; $796a
	ld hl,troyScript_doneSecret		; $796c
	jr ++			; $796f
+
	ld a,GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET		; $7971
	call checkGlobalFlag		; $7973
	ld hl,troyScript_beginningSecret		; $7976
	jr z,++			; $7979
	ld hl,troyScript_beganSecret		; $797b
++
	call interactionSetScript		; $797e
	ld a,$02		; $7981
	call interactionSetAnimation		; $7983
	jp interactionAnimateAsNpc		; $7986
@state1:
	call interactionRunScript		; $7989
	ld e,$7b		; $798c
	ld a,(de)		; $798e
	or a			; $798f
	ret nz			; $7990
	jp npcFaceLinkAndAnimate		; $7991
@state2:
	call _func_79df		; $7994
	call interactionDecCounter1		; $7997
	jr nz,+			; $799a
	ld (hl),$b4		; $799c
	call _func_7a0d		; $799e
+
	ld hl,$ccf8		; $79a1
	ldi a,(hl)		; $79a4
	cp $30			; $79a5
	jr nz,+			; $79a7
	ld a,(hl)		; $79a9
	cp $00			; $79aa
	jr nz,+			; $79ac
	ld a,$01		; $79ae
	jr ++			; $79b0
+
	ld h,d			; $79b2
	ld l,$78		; $79b3
	ld a,(hl)		; $79b5
	cp $0c			; $79b6
	ret nz			; $79b8
	ld a,(wNumEnemies)		; $79b9
	or a			; $79bc
	ret nz			; $79bd
	ld a,$00		; $79be
++
	ld h,d			; $79c0
	ld l,$7a		; $79c1
	ld (hl),a		; $79c3
	ld l,$44		; $79c4
	ld (hl),$01		; $79c6
	callab scriptHlp.linkedFunc_15_6430
	ld hl,troyScript_gameBegun		; $79d0
	call interactionSetScript		; $79d3
	ret			; $79d6
	ld hl,$ccf7		; $79d7
	xor a			; $79da
	ldi (hl),a		; $79db
	ldi (hl),a		; $79dc
	ld (hl),a		; $79dd
	ret			; $79de
_func_79df:
	ld hl,$ccf7		; $79df
	ldi a,(hl)		; $79e2
	cp $59			; $79e3
	jr nz,+			; $79e5
	ldi a,(hl)		; $79e7
	cp $59			; $79e8
	jr nz,+			; $79ea
	ld a,(hl)		; $79ec
	cp $99			; $79ed
	ret z			; $79ef
+
	ld hl,$ccf7		; $79f0
	call _func_7a01		; $79f3
	ret nz			; $79f6
	inc hl			; $79f7
	call _func_7a01		; $79f8
	ret nz			; $79fb
	inc hl			; $79fc
	ld b,$00		; $79fd
	jr +			; $79ff
_func_7a01:
	ld b,$60		; $7a01
+
	ld a,(hl)		; $7a03
	add $01			; $7a04
	daa			; $7a06
	cp b			; $7a07
	jr nz,+			; $7a08
	xor a			; $7a0a
+
	ld (hl),a		; $7a0b
	ret			; $7a0c
_func_7a0d:
	ld a,$04		; $7a0d
	ld hl,$cc30		; $7a0f
	sub (hl)		; $7a12
	ret z			; $7a13
	ldh (<hFF8D),a	; $7a14
	call getRandomNumber		; $7a16
	and $03			; $7a19
	ld e,$79		; $7a1b
	ld (de),a		; $7a1d
	xor a			; $7a1e
--
	inc a			; $7a1f
	ldh (<hFF8B),a	; $7a20
	ld h,d			; $7a22
	ld l,$78		; $7a23
	ld a,(hl)		; $7a25
	cp $0c			; $7a26
	jr z,+			; $7a28
	inc a			; $7a2a
	ld (hl),a		; $7a2b
	ld hl,_table_7a3d-1		; $7a2c
	rst_addAToHl			; $7a2f
	ld a,(hl)		; $7a30
	call _func_7a49		; $7a31
	ldh a,(<hFF8B)	; $7a34
	ld hl,$ff8d		; $7a36
	cp (hl)			; $7a39
_func_7a3a:
	jr nz,--			; $7a3a
+
	ret			; $7a3c

_table_7a3d:
	; lookup into enemy table below
	.db $00 $00
	.db $00 $00
	.db $01 $01
	.db $02 $03
	.db $04 $05
	.db $06 $07
_func_7a49:
	ld bc,_table_7a76		; $7a49
	call addDoubleIndexToBc		; $7a4c
	call getFreeEnemySlot		; $7a4f
	ret nz			; $7a52
	ld a,(bc)		; $7a53
	ldi (hl),a		; $7a54
	inc bc			; $7a55
	ld a,(bc)		; $7a56
	ldi (hl),a		; $7a57
	ld e,$79		; $7a58
	ld a,(de)		; $7a5a
	inc a			; $7a5b
	and $03			; $7a5c
	ld (de),a		; $7a5e
	ld bc,_table_7a86		; $7a5f
	call addDoubleIndexToBc		; $7a62
	ld l,$8b		; $7a65
	ld a,(bc)		; $7a67
	ld (hl),a		; $7a68
	inc bc			; $7a69
	ld l,$8d		; $7a6a
	ld a,(bc)		; $7a6c
	ld (hl),a		; $7a6d
	ld l,$81		; $7a6e
	ld a,(hl)		; $7a70
	cp $10			; $7a71
	ret z			; $7a73
	jr _func_7a8e		; $7a74
_table_7a76:
	.db ENEMYID_ROPE $01
	.db ENEMYID_MASKED_MOBLIN $00
	.db ENEMYID_SWORD_DARKNUT $00
	.db ENEMYID_SWORD_DARKNUT $01
	.db ENEMYID_WIZZROBE $01
	.db ENEMYID_WIZZROBE $02
	.db ENEMYID_LYNEL $00
	.db ENEMYID_LYNEL $01
_table_7a86:
	.db $30 $40
	.db $30 $b0
	.db $80 $40
	.db $80 $b0
_func_7a8e:
	ld e,$79		; $7a8e
	ld a,(de)		; $7a90
	ld bc,_table_7a86		; $7a91
	call addDoubleIndexToBc		; $7a94
	call getFreeInteractionSlot		; $7a97
	ret nz			; $7a9a
	ld (hl),INTERACID_PUFF		; $7a9b
	ld l,$4b		; $7a9d
	ld a,(bc)		; $7a9f
	ld (hl),a		; $7aa0
	inc bc			; $7aa1
	ld l,$4d		; $7aa2
	ld a,(bc)		; $7aa4
	ld (hl),a		; $7aa5
	ret			; $7aa6
_func_7aa7:
	ld a,TREASURE_SWORD		; $7aa7
	call checkTreasureObtained		; $7aa9
	jr nc,@nobleSword	; $7aac
	cp $03			; $7aae
	jp nc,@nobleSword		; $7ab0
	sub $01			; $7ab3
-
	ld e,Interaction.var03		; $7ab5
	ld (de),a		; $7ab7
	ret			; $7ab8
@nobleSword:
	ld a,$01		; $7ab9
	jr -			; $7abb


; ==============================================================================
; INTERACID_S_LINKED_GAME_GHINI
; ==============================================================================
interactionCodecb:
	ld e,$44		; $7abd
	ld a,(de)		; $7abf
	rst_jumpTable			; $7ac0
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld e,$42		; $7ac9
	ld a,(de)		; $7acb
	rst_jumpTable			; $7acc
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
@@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7ad5
	call checkGlobalFlag		; $7ad7
	jp z,interactionDelete		; $7ada
	call interactionInitGraphics		; $7add
	call interactionIncState		; $7ae0
	ld l,$79		; $7ae3
	ld (hl),$78		; $7ae5
	ld a,>TX_4c00		; $7ae7
	call interactionSetHighTextIndex		; $7ae9
	ld a,GLOBALFLAG_DONE_GRAVEYARD_SECRET		; $7aec
	call checkGlobalFlag		; $7aee
	jr z,@@notDoneSecret	; $7af1
	ld hl,linkedGhiniScript_doneSecret		; $7af3
	jr @@setScript		; $7af6
@@notDoneSecret:
	ld a,GLOBALFLAG_BEGAN_GRAVEYARD_SECRET		; $7af8
	call checkGlobalFlag		; $7afa
	ld hl,linkedGhiniScript_beginningSecret		; $7afd
	jr z,@@setScript	; $7b00
	ld hl,linkedGhiniScript_begunSecret		; $7b02
@@setScript:
	call interactionSetScript		; $7b05
	jp objectSetVisible81		; $7b08
@@subid1:
@@subid2:
	call interactionInitGraphics		; $7b0b
	ld h,d			; $7b0e
	ld l,$42		; $7b0f
	ld a,(hl)		; $7b11
	ld l,$5c		; $7b12
	ld (hl),a		; $7b14
	ld l,$44		; $7b15
	ld (hl),$02		; $7b17
	ld l,$46		; $7b19
	ld (hl),$1e		; $7b1b
	ld l,$4b		; $7b1d
	ld a,(hl)		; $7b1f
	ld l,$7b		; $7b20
	ld (hl),a		; $7b22
	ld l,$4d		; $7b23
	ld a,(hl)		; $7b25
	ld l,$7c		; $7b26
	ld (hl),a		; $7b28
	call getRandomNumber		; $7b29
	and $02			; $7b2c
	dec a			; $7b2e
	ld e,$7e		; $7b2f
	ld (de),a		; $7b31
	call getRandomNumber		; $7b32
	and $1f			; $7b35
	ld e,$49		; $7b37
	ld (de),a		; $7b39
	call getRandomNumber		; $7b3a
	and $03			; $7b3d
	ld hl,@@table_7b4d		; $7b3f
	rst_addAToHl			; $7b42
	ld a,(hl)		; $7b43
	ld e,$7d		; $7b44
	ld (de),a		; $7b46
	call _func_7c3f		; $7b47
	jp objectSetVisible81		; $7b4a
@@table_7b4d:
	.db $03 $04 $05 $06

@@subid3:
	call checkIsLinkedGame		; $7b51
	jp z,interactionDelete		; $7b54
	call interactionInitGraphics		; $7b57
	ld h,d			; $7b5a
	ld l,$5c		; $7b5b
	ld (hl),$02		; $7b5d
	ld l,$44		; $7b5f
	ld (hl),$03		; $7b61
	ld l,$7e		; $7b63
	ld (hl),GLOBALFLAG_BEGAN_LIBRARY_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET		; $7b65
	ld hl,linkedGameNpcScript		; $7b67
	call interactionSetScript		; $7b6a
	jp interactionAnimateAsNpc		; $7b6d

@state1:
	ld e,$45		; $7b70
	ld a,(de)		; $7b72
	rst_jumpTable			; $7b73
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	call interactionAnimate		; $7b7c
	call objectPreventLinkFromPassing		; $7b7f
	call interactionRunScript		; $7b82
	ret nc			; $7b85
	call interactionIncState2		; $7b86
	jp _func_7c0f		; $7b89
@@substate1:
	call _func_7bf9		; $7b8c
	ret nz			; $7b8f
	ld l,$45		; $7b90
	inc (hl)		; $7b92
	ld l,$79		; $7b93
	ld (hl),$3c		; $7b95
	ret			; $7b97
@@substate2:
	call _func_7bf9		; $7b98
	ret nz			; $7b9b
	ld l,$45		; $7b9c
	inc (hl)		; $7b9e
	ld hl,linkedGhiniScript_startRound		; $7b9f
	call interactionSetScript		; $7ba2
@@substate3:
	call interactionAnimate		; $7ba5
	call objectPreventLinkFromPassing		; $7ba8
	call interactionRunScript		; $7bab
	ret nc			; $7bae
	ld h,d			; $7baf
	ld l,$45		; $7bb0
	ld (hl),$01		; $7bb2
	ld l,$7f		; $7bb4
	ld a,(hl)		; $7bb6
	cp $00			; $7bb7
	jp z,_func_71c5		; $7bb9
	jp _func_7c0f		; $7bbc
@state2:
	call interactionAnimate		; $7bbf
	call @func_7be1		; $7bc2
	call _func_7bf9		; $7bc5
	jp z,interactionDelete		; $7bc8
	ld l,$46		; $7bcb
	ld a,(hl)		; $7bcd
	or a			; $7bce
	ret nz			; $7bcf
	ld l,$7d		; $7bd0
	ld a,(hl)		; $7bd2
	ld l,$7b		; $7bd3
	ld b,(hl)		; $7bd5
	ld l,$7c		; $7bd6
	ld c,(hl)		; $7bd8
	ld e,$7f		; $7bd9
	call objectSetPositionInCircleArc		; $7bdb
	jp _func_7bfe		; $7bde

@func_7be1:
	ld h,d			; $7be1
	ld l,$46		; $7be2
	ld a,(hl)		; $7be4
	or a			; $7be5
	jr z,+			; $7be6
	dec (hl)		; $7be8
	ld a,(wFrameCounter)		; $7be9
	rrca			; $7bec
	jp nc,objectSetInvisible		; $7bed
+
	jp objectSetVisible		; $7bf0
@state3:
	call interactionRunScript		; $7bf3
	jp interactionAnimateAsNpc		; $7bf6
_func_7bf9:
	ld h,d			; $7bf9
	ld l,$79		; $7bfa
	dec (hl)		; $7bfc
	ret			; $7bfd
_func_7bfe:
	ld a,(wFrameCounter)		; $7bfe
	rrca			; $7c01
	ret nc			; $7c02
	ld h,d			; $7c03
	ld l,$7e		; $7c04
	ld b,(hl)		; $7c06
	ld l,$7f		; $7c07
	ld a,(hl)		; $7c09
	add b			; $7c0a
	and $1f			; $7c0b
	ld (hl),a		; $7c0d
	ret			; $7c0e
_func_7c0f:
	ld e,$7a		; $7c0f
	xor a			; $7c11
	ld (de),a		; $7c12
	jr ++			; $7c13
_func_71c5:
	ld e,$7a		; $7c15
	ld a,(de)		; $7c17
	inc a			; $7c18
	cp $03			; $7c19
	jr c,+			; $7c1b
	xor a			; $7c1d
+
	ld (de),a		; $7c1e
++
	call _func_7c3f		; $7c1f
	call getRandomNumber		; $7c22
	and $01			; $7c25
	ld e,$7c		; $7c27
	ld (de),a		; $7c29
	push de			; $7c2a
	call clearEnemies		; $7c2b
	call clearItems		; $7c2e
	call clearParts		; $7c31
	pop de			; $7c34
	xor a			; $7c35
	ld ($cc30),a		; $7c36
	call _func_7c50		; $7c39
	jp _func_7cce		; $7c3c
_func_7c3f:
	ld e,$7a		; $7c3f
	ld a,(de)		; $7c41
	ld bc,_table_7c4d		; $7c42
	call addAToBc		; $7c45
	ld a,(bc)		; $7c48
	ld e,$79		; $7c49
	ld (de),a		; $7c4b
	ret			; $7c4c
_table_7c4d:
	.db $f0 $b4 $78

_func_7c50:
	ld hl,$cee0		; $7c50
	xor a			; $7c53
-
	ldi (hl),a		; $7c54
	inc a			; $7c55
	cp $0d			; $7c56
	jr nz,-			; $7c58
	ld e,$7d		; $7c5a
	ld (de),a		; $7c5c
	xor a			; $7c5d
	ld e,$7b		; $7c5e
	ld (de),a		; $7c60
	ret			; $7c61
_func_7c62:
	ld e,$7d		; $7c62
	ld a,(de)		; $7c64
	ld b,a			; $7c65
	dec a			; $7c66
	ld (de),a		; $7c67
	call getRandomNumber		; $7c68
-
	sub b			; $7c6b
	jr nc,-			; $7c6c
	add b			; $7c6e
	ld c,a			; $7c6f
	ld hl,$cee0		; $7c70
	rst_addAToHl			; $7c73
	ld a,(hl)		; $7c74
	ld e,$7e		; $7c75
	ld (de),a		; $7c77
	push de			; $7c78
	ld d,c			; $7c79
	ld e,b			; $7c7a
	dec e			; $7c7b
	ld b,h			; $7c7c
	ld c,l			; $7c7d
-
	ld a,d			; $7c7e
	cp e			; $7c7f
	jr z,+			; $7c80
	inc bc			; $7c82
	ld a,(bc)		; $7c83
	ldi (hl),a		; $7c84
	inc d			; $7c85
	jr -				; $7c86
+
	pop de			; $7c88
	ret			; $7c89
_func_7c8a:
	ld h,d			; $7c8a
	ld l,$7a		; $7c8b
	ld a,(hl)		; $7c8d
	swap a			; $7c8e
	ld l,$7b		; $7c90
	add (hl)		; $7c92
	ld bc,_table_7c9e		; $7c93
	call addAToBc		; $7c96
	ld a,(bc)		; $7c99
	ld l,$7c		; $7c9a
	xor (hl)		; $7c9c
	ret			; $7c9d
_table_7c9e:
	.db $01 $01 $01 $00 $00 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $01 $01 $01 $01 $01 $00 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00
	.db $01 $01 $01 $01 $01 $01 $00 $00
	.db $00 $00 $00 $00 $00 $00 $00 $00

_func_7cce:
	call getFreeInteractionSlot		; $7cce
	ret nz			; $7cd1
	ld (hl),INTERACID_S_LINKED_GAME_GHINI		; $7cd2
	inc hl			; $7cd4
	push hl			; $7cd5
	call _func_7c8a		; $7cd6
	pop hl			; $7cd9
	inc a			; $7cda
	ld (hl),a		; $7cdb
	ld e,$7a		; $7cdc
	ld a,(de)		; $7cde
	ld l,$7a		; $7cdf
	ld (hl),a		; $7ce1
	push hl			; $7ce2
	call _func_7c62		; $7ce3
	pop hl			; $7ce6
	ld e,$7e		; $7ce7
	ld a,(de)		; $7ce9
	ld bc,_table_7d03		; $7cea
	call addDoubleIndexToBc		; $7ced
	ld l,$4b		; $7cf0
	ld a,(bc)		; $7cf2
	ld (hl),a		; $7cf3
	inc bc			; $7cf4
	ld l,$4d		; $7cf5
	ld a,(bc)		; $7cf7
	ld (hl),a		; $7cf8
	ld e,$7b		; $7cf9
	ld a,(de)		; $7cfb
	inc a			; $7cfc
	ld (de),a		; $7cfd
	cp $0d			; $7cfe
	jr nz,_func_7cce	; $7d00
	ret			; $7d02
_table_7d03:
	.db $1c $20 $1c $40 $1c $60 $1c $80
	.db $34 $30 $34 $50 $34 $70 $4c $20
	.db $4c $40 $4c $60 $4c $80 $64 $30
	.db $64 $70


; ==============================================================================
; INTERACID_GOLDEN_CAVE_SUBROSIAN
; ==============================================================================
interactionCodecc:
	ld e,$44		; $7d1d
	ld a,(de)		; $7d1f
	rst_jumpTable			; $7d20
	.dw @state0
	.dw @state1
@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7d25
	call checkGlobalFlag		; $7d27
	jp z,interactionDelete		; $7d2a
	ld a,$01		; $7d2d
	ld (de),a		; $7d2f
	ld a,>TX_4c00		; $7d30
	call interactionSetHighTextIndex		; $7d32
	call getThisRoomFlags		; $7d35
	and $03			; $7d38
	or a			; $7d3a
	jr z,+			; $7d3b
	ld hl,seasonsTable_0f_7dc7		; $7d3d
	rst_addDoubleIndex			; $7d40
	ldi a,(hl)		; $7d41
	ld h,(hl)		; $7d42
	ld l,a			; $7d43
	jr @setScript		; $7d44
+
	ld a,GLOBALFLAG_DONE_SUBROSIAN_SECRET		; $7d46
	call checkGlobalFlag		; $7d48
	jr z,@notDoneSubrosianScript	; $7d4b
	ld hl,script7dac		; $7d4d
	jr @setScript		; $7d50
@notDoneSubrosianScript:
	call getThisRoomFlags		; $7d52
	bit 7,a			; $7d55
	jr z,@notGivenSecret	; $7d57
	ld hl,goldenCaveSubrosianScript_givenSecret		; $7d59
	jr @setScript		; $7d5c
@notGivenSecret:
	ld hl,goldenCaveSubrosianScript_beginningSecret		; $7d5e
@setScript:
	call interactionSetScript		; $7d61
	call interactionInitGraphics		; $7d64
	call seasonsFunc_0f_7dc1		; $7d67
	call interactionSetAlwaysUpdateBit		; $7d6a
@state1:
	call interactionAnimateAsNpc		; $7d6d
	call interactionRunScript		; $7d70
	call seasonsFunc_0f_7dac		; $7d73
	call checkInteractionState2		; $7d76
	ret nz			; $7d79
	call _func_7d95		; $7d7a
	ld a,TILEINDEX_GRASS		; $7d7d
	call findTileInRoom		; $7d7f
	ret z			; $7d82
	call interactionIncState2		; $7d83
	ld l,$78		; $7d86
	ld a,(hl)		; $7d88
	ld b,$02		; $7d89
	cp $04			; $7d8b
	jr nc,+			; $7d8d
	ld b,$03		; $7d8f
+
	ld l,$79		; $7d91
	ld (hl),b		; $7d93
	ret			; $7d94
_func_7d95:
	ld c,TREASURE_BOOMERANG		; $7d95
	call findItemWithID		; $7d97
	ld h,d			; $7d9a
	jr z,@failed	; $7d9b
	ld l,$77		; $7d9d
	ld (hl),$00		; $7d9f
	ret			; $7da1
@failed:
	ld l,$77		; $7da2
	ld a,(hl)		; $7da4
	or a			; $7da5
	ret nz			; $7da6
	ld (hl),$01		; $7da7
	inc l			; $7da9
	inc (hl)		; $7daa
	ret			; $7dab

seasonsFunc_0f_7dac:
	call getThisRoomFlags		; $7dac
	and $03			; $7daf
	or a			; $7db1
	and $01			; $7db2
	ret z			; $7db4
	ld e,$79		; $7db5
	ld a,(de)		; $7db7
	cp $03			; $7db8
	ret nz			; $7dba
	ld c,$20		; $7dbb
	call objectUpdateSpeedZ_paramC		; $7dbd
	ret nz			; $7dc0

seasonsFunc_0f_7dc1:
	ld bc,$ff40		; $7dc1
	jp objectSetSpeedZ		; $7dc4

seasonsTable_0f_7dc7:
	.dw goldenCaveSubrosianScript_beginningSecret
	.dw goldenCaveSubrosianScript_7d00
	.dw goldenCaveSubrosianScript_7d87
	.dw goldenCaveSubrosianScript_7d00


; ==============================================================================
; INTERACID_LINKED_MASTER_DIVER
; ==============================================================================
interactionCodecd:
	ld e,$44		; $7dcf
	ld a,(de)		; $7dd1
	rst_jumpTable			; $7dd2
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld e,$42		; $7dd9
	ld a,(de)		; $7ddb
	rst_jumpTable			; $7ddc
	.dw @subid0
	.dw @subid1
	.dw @subid2
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7de3
	call checkGlobalFlag		; $7de5
	jp z,interactionDelete		; $7de8
	call interactionInitGraphics		; $7deb
	call interactionIncState		; $7dee
	ld a,$4c		; $7df1
	call interactionSetHighTextIndex		; $7df3
	ld a,GLOBALFLAG_DONE_DIVER_SECRET		; $7df6
	call checkGlobalFlag		; $7df8
	jp z,@notDoneDiverSecret		; $7dfb
	ld hl,masterDiverScript_secretDone		; $7dfe
	jr @setScript		; $7e01
@notDoneDiverSecret:
	ld a,$07		; $7e03
	ld b,$ea		; $7e05
	call getRoomFlags		; $7e07
	and $40			; $7e0a
	jr z,+			; $7e0c
	res 6,(hl)		; $7e0e
	ld hl,masterDiverScript_swimmingChallengeDone		; $7e10
	jr @setScript		; $7e13
+
	ld a,GLOBALFLAG_BEGAN_DIVER_SECRET		; $7e15
	call checkGlobalFlag		; $7e17
	ld hl,masterDiverScript_beginningSecret		; $7e1a
	jr z,@setScript	; $7e1d
	ld hl,masterDiverScript_begunSecret		; $7e1f
@setScript:
	call interactionSetScript		; $7e22
	xor a			; $7e25
	ld hl,$cfd0		; $7e26
	ldi (hl),a		; $7e29
	ldi (hl),a		; $7e2a
	ldi (hl),a		; $7e2b
	ld a,$02		; $7e2c
	call interactionSetAnimation		; $7e2e
	jp interactionAnimateAsNpc		; $7e31
@subid1:
	ld hl,$cfd1		; $7e34
	ld a,(hl)		; $7e37
	or a			; $7e38
	jp nz,interactionDelete		; $7e39
	inc (hl)		; $7e3c
	ld h,d			; $7e3d
	ld l,$44		; $7e3e
	ld (hl),$02		; $7e40
	ld a,GLOBALFLAG_SWIMMING_CHALLENGE_SUCCEEDED		; $7e42
	call unsetGlobalFlag		; $7e44
	ld a,>TX_4c00		; $7e47
	call interactionSetHighTextIndex		; $7e49
	ld hl,masterDiverScript_swimmingChallengeText		; $7e4c
	call interactionSetScript		; $7e4f
	call objectSetReservedBit1		; $7e52
	jr @state2		; $7e55
@subid2:
	ld h,d			; $7e57
	ld l,$44		; $7e58
	ld (hl),$02		; $7e5a
	ld a,>TX_4c00		; $7e5c
	call interactionSetHighTextIndex		; $7e5e
	ld hl,masterDiverScript_spawnFakeStarOre		; $7e61
	call interactionSetScript		; $7e64
	jr @state2		; $7e67
@state1:
	call interactionRunScript		; $7e69
	ld e,$7f		; $7e6c
	ld a,(de)		; $7e6e
	or a			; $7e6f
	ret nz			; $7e70
	jp interactionAnimateAsNpc		; $7e71
@state2:
	ld e,$42		; $7e74
	ld a,(de)		; $7e76
	dec a			; $7e77
	jr nz,+			; $7e78
	; Inside waterfall cave
	callab _func_79df
+
	call interactionRunScript		; $7e82
	jp c,interactionDelete		; $7e85
	ret			; $7e88


; ==============================================================================
; INTERACID_S_GREAT_FAIRY
; ==============================================================================
interactionCoded5:
	ld e,$44		; $7e89
	ld a,(de)		; $7e8b
	rst_jumpTable			; $7e8c
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)		; $7e96
	or a			; $7e97
	jr z,@subid0	; $7e98
	call checkIsLinkedGame		; $7e9a
	jp z,interactionDelete		; $7e9d
	jr @subid1		; $7ea0
@subid0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7ea2
	call checkGlobalFlag		; $7ea4
	jp z,interactionDelete		; $7ea7
@subid1:
	call interactionInitGraphics		; $7eaa
	call interactionSetAlwaysUpdateBit		; $7ead
	ld h,d			; $7eb0
	ld l,e			; $7eb1
	inc (hl)		; $7eb2
	ld l,$4f		; $7eb3
	ld (hl),$f0		; $7eb5
	ld l,$77		; $7eb7
	ld (hl),$36		; $7eb9
	ld a,>TX_4100		; $7ebb
	call interactionSetHighTextIndex		; $7ebd
	xor a			; $7ec0
	ld (wActiveMusic),a		; $7ec1
	ld a,$0f		; $7ec4
	call playSound		; $7ec6
	jp objectCreatePuff		; $7ec9
@state1:
	ld e,$45		; $7ecc
	ld a,(de)		; $7ece
	rst_jumpTable			; $7ecf
	.dw @substate0
	.dw @substate1
@substate0:
	ld h,d			; $7ed4
	ld l,$77		; $7ed5
	dec (hl)		; $7ed7
	ret nz			; $7ed8
	ld l,$45		; $7ed9
	inc (hl)		; $7edb
	xor a			; $7edc
	call interactionSetAnimation		; $7edd
	call objectSetVisiblec2		; $7ee0
	ld e,Interaction.var3e		; $7ee3
	ld a,GLOBALFLAG_BEGAN_TINGLE_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET		; $7ee5
	ld (de),a		; $7ee7
	ld e,$42		; $7ee8
	ld a,(de)		; $7eea
	or a			; $7eeb
	ld hl,linkedGameNpcScript		; $7eec
	jr nz,@setScript	; $7eef

	ld a,GLOBALFLAG_DONE_TEMPLE_SECRET		; $7ef1
	call checkGlobalFlag		; $7ef3
	ld hl,templeGreatFairyScript_beginningSecret		; $7ef6
	jr z,@setScript	; $7ef9

	ld hl,templeGreatFairyScript_doneSecret		; $7efb
@setScript:
	jp interactionSetScript		; $7efe
@substate1:
	call interactionRunScript		; $7f01
	call interactionAnimateAsNpc		; $7f04
	ld a,(wFrameCounter)		; $7f07
	and $07			; $7f0a
	ret nz			; $7f0c
	ld a,(wFrameCounter)		; $7f0d
	and $38			; $7f10
	swap a			; $7f12
	rlca			; $7f14
	ld hl,_table_7f1f		; $7f15
	rst_addAToHl			; $7f18
	ld e,$4f		; $7f19
	ld a,(de)		; $7f1b
	add (hl)		; $7f1c
	ld (de),a		; $7f1d
	ret			; $7f1e
_table_7f1f:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00


; ==============================================================================
; INTERACID_DEKU_SCRUB
; ==============================================================================
interactionCoded6:
	ld e,$44		; $7f27
	ld a,(de)		; $7f29
	rst_jumpTable			; $7f2a
	.dw @state0
	.dw @state1
@state0:
	ld a,$01		; $7f2f
	ld (de),a		; $7f31
	ld e,$42		; $7f32
	ld a,(de)		; $7f34
	ld hl,@table_7f74		; $7f35
	rst_addAToHl			; $7f38
	ld a,(wAnimalCompanion)		; $7f39
	cp (hl)			; $7f3c
	jp nz,interactionDelete		; $7f3d
	ld a,$86		; $7f40
	call loadPaletteHeader		; $7f42
	call interactionInitGraphics		; $7f45
	call interactionSetAlwaysUpdateBit		; $7f48
	ld a,>TX_4c00		; $7f4b
	call interactionSetHighTextIndex		; $7f4d

	ld a,GLOBALFLAG_FINISHEDGAME		; $7f50
	call checkGlobalFlag		; $7f52
	ld hl,dekuScrubScript_notFinishedGame		; $7f55
	jr z,@setScript	; $7f58

	ld a,GLOBALFLAG_DONE_DEKU_SECRET		; $7f5a
	call checkGlobalFlag		; $7f5c
	ld hl,dekuScrubScript_doneSecret		; $7f5f
	jr nz,@setScript	; $7f62

	call getThisRoomFlags		; $7f64
	bit 7,a			; $7f67
	ld hl,dekuScrubScript_gaveSecret		; $7f69
	jr nz,@setScript	; $7f6c

	ld hl,dekuScrubScript_beginningSecret		; $7f6e
@setScript:
	jp interactionSetScript		; $7f71
@table_7f74:
	.db SPECIALOBJECTID_RICKY
	.db SPECIALOBJECTID_DIMITRI
	.db SPECIALOBJECTID_MOOSH
@state1:
	call interactionRunScript		; $7f77
	call interactionAnimateAsNpc		; $7f7a
	ld c,$20		; $7f7d
	call objectCheckLinkWithinDistance		; $7f7f
	ld h,d			; $7f82
	ld l,$77		; $7f83
	jr c,+			; $7f85
	ld a,(hl)		; $7f87
	or a			; $7f88
	ret z			; $7f89
	xor a			; $7f8a
	ld (hl),a		; $7f8b
	ld a,$03		; $7f8c
	jp interactionSetAnimation		; $7f8e
+
	ld a,(hl)		; $7f91
	or a			; $7f92
	ret nz			; $7f93
	inc (hl)		; $7f94
	ld a,$01		; $7f95
	jp interactionSetAnimation		; $7f97

interactionCoded7:
	jp interactionDelete		; $7f9a
