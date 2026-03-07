; ==================================================================================================
; INTERAC_PIRATIAN
; INTERAC_PIRATIAN_CAPTAIN
; ==================================================================================================
interactionCode40:
interactionCode41:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
	.dw @@subid7
	.dw @@subid8
	.dw @@subid9
	.dw @@subidA
	.dw @@subidB
	.dw @@subidC
	.dw @@subidD
	.dw @@subidE
@@subid0:
	call func_6c3c

@@subid1:
@@subid2:
@@subid3:
@@subid4:
@@subid5:
@@subid6:
@@subid9:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jp nz,interactionDelete
	call objectGetTileAtPosition
	ld (hl),$00
@@subid7:
@@subid8:
	call @func_6b91
	ld a,$04
	jr @func_6b8b
@@subidB:
@@subidC:
@@subidD:
@@subidE:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call checkGlobalFlag
	jp nz,interactionDelete
	call @func_6b91
	ld e,$42
	ld a,(de)
	cp $0d
	ld a,$00
	jr z,+
	ld a,$04
+
	jr @func_6b8b
@@subidA:
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,interactionDelete
	call @func_6b91
	ld a,$04
@func_6b8b:
	call interactionSetAnimation
	jp func_6bc4
@func_6b91:
	call interactionInitGraphics
	ld h,d
	ld l,$44
	ld (hl),$01
	ld a,>TX_3a00
	call interactionSetHighTextIndex
	call func_6c29
	ld e,$42
	ld a,(de)
	ld hl,table_6cbf
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionRunScript
@state1:
	ld e,$42
	ld a,(de)
	cp $08
	jr nz,+
	call func_6c51
+
	call interactionRunScript
	jp c,interactionDelete
	jp func_6bc4
func_6bc4:
	call interactionAnimate
	ld e,$7c
	ld a,(de)
	or a
	jr nz,func_6be9
	ld e,$60
	ld a,(de)
	dec a
	jr nz,+
	call getRandomNumber_noPreserveVars
	and $1f
	ld hl,table_6c09
	rst_addAToHl
	ld a,(hl)
	or a
	jr z,+
	ld e,$60
	ld (de),a
+
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
func_6be9:
	ld e,$50
	ld a,(de)
	cp $28
	jr z,+
	cp $50
	jr z,++
	ret
+
	ld e,$60
	ld a,(de)
	cp $09
	ret nz
	jr +++
++
	ld e,$60
	ld a,(de)
	cp $0c
	ret nz
+++
	ld e,$60
	ld a,$01
	ld (de),a
	ret
table_6c09:
	.db $00 $00 $04 $04 $00 $00 $08 $08
	.db $00 $00 $00 $00 $04 $04 $00 $00
	.db $00 $08 $08 $00 $00 $00 $10 $10
	.db $00 $00 $00 $20 $20 $00 $00 $00
func_6c29:
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,+
	xor a
+
	cp $20
	ld a,$01
	jr nc,+
	xor a
+
	ld e,$7a
	ld (de),a
	ret
func_6c3c:
	ld a,TREASURE_PIRATES_BELL
	call checkTreasureObtained
	jr c,+
	xor a
	jr ++
+
	or a
	ld a,$01
	jr z,++
	ld a,$02
++
	ld e,$7b
	ld (de),a
	ret
func_6c51:
	call func_6c8b
	jr z,++
	ld a,($cc46)
	bit 6,a
	jr z,+
	ld c,$01
	ld b,$db
	jp func_6c78
+
	ld a,($cc45)
	bit 6,a
	ret nz
++
	ld h,d
	ld l,$7e
	ld a,$00
	cp (hl)
	ret z
	ld c,$00
	ld b,$d9
	jp func_6c78
func_6c78:
	ld h,d
	ld l,$7e
	ld (hl),c
	ld a,$05
	ld l,$7f
	add (hl)
	ld c,a
	ld a,b
	call setTile
	ld a,$70
	jp playSound
func_6c8b:
	ld hl,table_6cb2
	ld a,($d00b)
	ld c,a
	ld a,($d00d)
	ld b,a
---
	ldi a,(hl)
	or a
	ret z
	add $04
	sub c
	cp $09
	jr nc,+
	ldi a,(hl)
	add $03
	sub b
	cp $07
	jr nc,++
	ld a,(hl)
	ld e,$7f
	ld (de),a
	or d
	ret
+
	inc hl
++
	inc hl
	jr ---
table_6cb2:
	.db $18 $58 $00 $18
	.db $68 $01 $18 $78
	.db $02 $18 $88 $03
	.db $00

table_6cbf:
	.dw mainScripts.piratianCaptainScript_inHouse
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text1BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text2BasedOnD6Beaten
	.dw mainScripts.piratian1FScript_text2BasedOnD6Beaten
	.dw mainScripts.unluckySailorScript
	.dw mainScripts.piratian2FScript_textBasedOnD6Beaten
	.dw mainScripts.piratianRoofScript
	.dw mainScripts.samasaGatePiratianScript
	.dw mainScripts.piratianCaptainByShipScript
	.dw mainScripts.piratianFromShipScript
	.dw mainScripts.piratianByCaptainWhenDeparting1Script
	.dw mainScripts.piratianByCaptainWhenDeparting2Script
