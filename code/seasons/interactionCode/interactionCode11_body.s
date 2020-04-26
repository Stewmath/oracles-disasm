; ==============================================================================
; INTERACID_11
;
; Variables:
;   varxx: ???
; ==============================================================================
interactionCode11_body:
	ld e,Interaction.subid	; $59b7
	ld a,(de)		; $59b9
	and $0f			; $59ba
	rst_jumpTable			; $59bc
	.dw @subid0
	.dw @subid1
@subid0:
	ld e,Interaction.state		; $59c1
	ld a,(de)		; $59c3
	rst_jumpTable			; $59c4
	.dw @subid0state0
	.dw @subid0state1
	.dw @subid0state2
	.dw @subid0state3
	.dw @subid0state4
	.dw @subid0state5
	.dw @subid0state6
	.dw @subid0state7
	.dw @subid0state8
	.dw @subid0state9
	.dw @subid0statea
@subid0state0:
	ld a,$30		; $59db
	ld ($cfd8),a		; $59dd
	xor a			; $59e0
	ld ($cfd9),a		; $59e1
	call setCameraFocusedObject		; $59e4
	ld e,$46		; $59e7
	ld a,$5a		; $59e9
	ld (de),a		; $59eb
	call darkenRoomLightly		; $59ec
	jp interactionIncState		; $59ef
@subid0state1:
	call interactionDecCounter1		; $59f2
	ret nz			; $59f5
	ld (hl),$30		; $59f6
	ld hl,$4000		; $59f8
	call parseGivenObjectData		; $59fb
	jp interactionIncState		; $59fe
@subid0state2:
	call interactionDecCounter1		; $5a01
	ret nz			; $5a04
	ld (hl),$1e		; $5a05
	jp interactionIncState		; $5a07
@subid0state3:
	call interactionDecCounter1		; $5a0a
	ret nz			; $5a0d
	ld (hl),$50		; $5a0e
	jp interactionIncState		; $5a10
@subid0state4:
	ld a,(wFrameCounter)		; $5a13
	rrca			; $5a16
	jr c,+			; $5a17
	ld hl,$cfd8		; $5a19
	dec (hl)		; $5a1c
+
	call interactionDecCounter1		; $5a1d
	ret nz			; $5a20
	ld (hl),$28		; $5a21
	jp interactionIncState		; $5a23
@subid0state5:
	call interactionDecCounter1		; $5a26
	ret nz			; $5a29
	ld (hl),$08		; $5a2a
	ld a,$01		; $5a2c
	ld ($cfd9),a		; $5a2e
	ld bc,$8404		; $5a31
	call objectCreateInteraction		; $5a34
	ld l,$56		; $5a37
	ld (hl),$40		; $5a39
	inc l			; $5a3b
	ld (hl),d		; $5a3c
	call objectCreatePuff		; $5a3d
	ld a,$f1		; $5a40
	ld c,$75		; $5a42
	call setTile		; $5a44
	jp interactionIncState		; $5a47
@subid0state6:
@subid0state7:
@subid0state8:
	call interactionDecCounter1		; $5a4a
	ret nz			; $5a4d
	ld (hl),$10		; $5a4e
	call fadeinFromWhite		; $5a50
-
	; subrosia transition sound
	ld a,SND_FADEOUT		; $5a53
	call playSound		; $5a55
	jp interactionIncState		; $5a58
@subid0state9:
	call interactionDecCounter1		; $5a5b
	ret nz			; $5a5e
	ld a,$04		; $5a5f
	call fadeinFromWhiteWithDelay		; $5a61
	jr -		; $5a64
@subid0statea:
	ld a,(wPaletteThread_mode)		; $5a66
	or a			; $5a69
	ret nz			; $5a6a
	ld a,$01		; $5a6b
	ld ($cfc0),a		; $5a6d
	xor a			; $5a70
	ld (wPaletteThread_parameter),a		; $5a71
	call setCameraFocusedObjectToLink		; $5a74
	jp interactionDelete		; $5a77

@subid1:
	ld e,Interaction.state		; $5a7a
	ld a,(de)		; $5a7c
	rst_jumpTable			; $5a7d
	.dw @subid1state0
	.dw @subid1state1
	.dw @subid1state2
	.dw @subid1state3
@subid1state0:
	ld e,Interaction.subid			; $5a86
	ld a,(de)		; $5a88
	swap a			; $5a89
	and $0f			; $5a8b
	ld hl,@subid1state0table		; $5a8d
	rst_addAToHl			; $5a90
	ld a,(hl)		; $5a91
	ld e,$49		; $5a92
	ld (de),a		; $5a94
	ld e,$50		; $5a95
	ld a,$28		; $5a97
	ld (de),a		; $5a99
	ld e,$46		; $5a9a
	ld a,$30		; $5a9c
	ld (de),a		; $5a9e
	call interactionInitGraphics		; $5a9f
	call objectSetVisible80		; $5aa2
	jp interactionIncState		; $5aa5
@subid1state0table:
	.db $02 $06 $0a $0e $12 $16 $1a $1e

@subid1state1:
	call objectApplySpeed		; $5ab0
	call interactionAnimate		; $5ab3
	call interactionDecCounter1		; $5ab6
	ret nz			; $5ab9
	jp interactionIncState		; $5aba
@subid1state2:
	call @func_3f_5ada		; $5abd
	ld a,($cfd9)		; $5ac0
	or a			; $5ac3
	ret z			; $5ac4
	ld e,$50		; $5ac5
	ld a,$50		; $5ac7
	ld (de),a		; $5ac9
	jp interactionIncState		; $5aca
@subid1state3:
	call objectApplySpeed		; $5acd
	call interactionAnimate		; $5ad0
	call objectCheckWithinScreenBoundary		; $5ad3
	ret c			; $5ad6
	jp interactionDelete		; $5ad7

@func_3f_5ada:
	ld a,(wFrameCounter)		; $5ada
	rrca			; $5add
	jr c,+	; $5ade
	ld h,d			; $5ae0
	ld l,$49		; $5ae1
	inc (hl)		; $5ae3
	ld a,(hl)		; $5ae4
	and $1f			; $5ae5
	ld (hl),a		; $5ae7
	ld a,SND_CIRCLING		; $5ae8
	call z,playSound		; $5aea
+
	ld e,$49		; $5aed
	ld bc,$7858		; $5aef
	ld a,($cfd8)		; $5af2
	call objectSetPositionInCircleArc		; $5af5
	jp interactionAnimate		; $5af8