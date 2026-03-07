; ==================================================================================================
; INTERAC_AMBI
; ==================================================================================================
interactionCodeb8:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call checkIsLinkedGame
	jp z,interactionDelete
	call func_740a
	ld e,$42
	ld a,(de)
	cp $03
	jr z,@subid3
	ld hl,@var3eVals
	rst_addAToHl
	ld e,$7e
	ld a,(de)
	cp (hl)
	jp nz,interactionDelete
	jr ++
@subid3:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jp nz,interactionDelete
++
	call interactionInitGraphics
	call interactionIncState
	ld e,$42
	ld a,(de)
	ld hl,table_7432
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,>TX_3a00
	call interactionSetHighTextIndex
	call objectSetVisible80
	ld a,$02
	call interactionSetAnimation
	jp @animate
@var3eVals:
	.db $00 $01 $02 $00 $03
@state1:
	call interactionRunScript
	ld e,$7f
	ld a,(de)
	or a
	jr nz,@animate
	jp npcFaceLinkAndAnimate
@animate:
	jp interactionAnimate

; Stores into var3e, in this order:
;   $03 - if pirates left for the ship
;   $02 - if 5th+ essence gotten
;   $01 - if 3rd+ essence gotten
;   $00 - otherwise
func_740a:
	ld a,GLOBALFLAG_PIRATES_LEFT_FOR_SHIP
	call checkGlobalFlag
	jr nz,@piratesLeftForShip
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,@haveEssence
	xor a
@haveEssence:
	cp $10
	jr nc,@atLeast5thEssence
	cp $04
	jr nc,@atLeast3rdEssence
	xor a
	jr @storeIntoVar3e
@atLeast3rdEssence:
	ld a,$01
	jr @storeIntoVar3e
@atLeast5thEssence:
	ld a,$02
	jr @storeIntoVar3e
@piratesLeftForShip:
	ld a,$03
@storeIntoVar3e:
	ld e,$7e
	ld (de),a
	ret

table_7432:
	.dw mainScripts.ambiScript_mrsRuulsHouse
	.dw mainScripts.ambiScript_outsideSyrupHut
	.dw mainScripts.ambiScript_samasaShore
	.dw mainScripts.ambiScript_enteringPirateHouseBeforePiratesLeave
	.dw mainScripts.ambiScript_pirateHouseAfterTheyLeft
