; ==================================================================================================
; INTERAC_SHIP_PIRATIAN
; ==================================================================================================
interactionCodeb1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw piratian_state0
	.dw piratian_state1
	.dw piratian_state2
	.dw piratian_state3
	.dw piratian_state4
	.dw piratian_state5
	.dw piratian_state6

; ==================================================================================================
; INTERAC_SHIP_PIRATIAN_CAPTAIN
; ==================================================================================================
interactionCodeb2:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw piratianCaptain_state0
	.dw piratian_state2
	.dw piratian_state1

piratian_state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld e,$42
	ld a,(de)
	ld b,a
	cp $18
	; subid_00-17
	ld a,>TX_4e00
	jr c,+
	; subid_18-1a
	ld a,>TX_4d00
+
	call interactionSetHighTextIndex
	ld a,b
	ld hl,table_6f4b
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectSetVisiblec2
	call interactionRunScript
	call interactionRunScript
	jp c,interactionDelete
	ret

piratianCaptain_state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	ld hl,table_6f81
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	call objectSetVisiblec2
	ld a,>TX_4e00
	call interactionSetHighTextIndex
	call interactionRunScript
	jp interactionRunScript

piratian_state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

piratian_state2:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimate

piratian_state3:
	ld a,$10
	call setScreenShakeCounter
	call interactionRunScript
	jp c,interactionDelete
	ret

piratian_state4:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld e,$48
	ld a,(de)
	inc a
	and $03
	ld (de),a
	jp interactionSetAnimation

piratian_state5:
	call objectPreventLinkFromPassing
	call interactionAnimate
	call interactionRunScript
	jp c,interactionDelete
	ld a,(wFrameCounter)
	rrca
	jp c,objectSetInvisible
	jp objectSetVisible

piratian_state6:
	ld a,($cfc0)
	or a
	jp nz,interactionDelete
	call interactionRunScript
	jp c,interactionDelete
	jp objectSetInvisible

table_6f4b:
	.dw mainScripts.stubScript
	.dw mainScripts.shipPirationScript_piratianComingDownHandler
	.dw mainScripts.shipPiratianScript_piratianFromAbove
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPirationScript_inShipLeavingSubrosia
	.dw mainScripts.shipPiratianScript_leavingSamasaDesert
	.dw mainScripts.shipPiratianScript_dizzyPirate1Spawner
	.dw mainScripts.shipPiratianScript_swapShip
	.dw mainScripts.shipPiratianScript_1stDizzyPirateDescending
	.dw mainScripts.shipPirationScript_2ndDizzyPirateDescending
	.dw mainScripts.shipPirationScript_3rdDizzyPirateDescending
	.dw mainScripts.shipPiratianScript_dizzyPiratiansAlreadyInside
	.dw mainScripts.shipPiratianScript_dizzyPiratiansAlreadyInside
	.dw mainScripts.stubScript
	.dw mainScripts.shipPiratianScript_landedInWestCoast_shipTopHalf
	.dw mainScripts.shipPiratianScript_landedInWestCoast_shipBottomHalf
	.dw mainScripts.shipPiratianScript_insideDockedShip1
	.dw mainScripts.shipPiratianScript_insideDockedShip2
	.dw mainScripts.shipPiratianScript_insideDockedShip3
	.dw mainScripts.shipPiratianScript_insideDockedShip4
	.dw mainScripts.shipPiratianScript_insideDockedShip5
	.dw mainScripts.stubScript
	.dw mainScripts.shipPiratianScript_ghostPiratian
	.dw mainScripts.shipPiratianScript_NWofGhostPiration
	.dw mainScripts.shipPiratianScript_NEofGhostPiration
table_6f81:
	.dw mainScripts.shipPiratianCaptainScript_leavingSubrosia
	.dw mainScripts.shipPiratianCaptainScript_gettingSick
	.dw mainScripts.shipPiratianCaptainScript_arrivingInWestCoast
	.dw mainScripts.shipPiratianCaptainScript_inWestCoast
