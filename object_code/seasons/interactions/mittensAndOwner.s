; ==================================================================================================
; INTERAC_MITTENS
; INTERAC_MITTENS_OWNER
; ==================================================================================================
interactionCode25:
interactionCode26:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	call interactionInitGraphics
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld e,$41
	ld a,(de)
	cp INTERAC_MITTENS_OWNER
	jr z,@mittensOwner
	call getThisRoomFlags
	and $40
	ld e,$42
	ld a,(de)
	jr nz,@@savedMittens
	or a
	jp nz,interactionDelete
	jr @incStateSetScript
@@savedMittens:
	or a
	jp z,interactionDelete
	jr @incStateSetScript
@mittensOwner:
	call getThisRoomFlags
	and $40
	ld e,$42
	ld a,(de)
	jr nz,@@savedMittens
	or a
	jp nz,interactionDelete
	call @func_5a78
	ld a,$00
	call interactionSetAnimation
	jp @animate
@@savedMittens:
	or a
	jp z,interactionDelete
	call @func_5a78
	ld a,$02
	call interactionSetAnimation
	jp @animate
@incStateSetScript:
	ld h,d
	ld l,$44
	ld (hl),$01
	ld hl,mainScripts.mittensScript
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
	jp @animate
@func_5a78:
	ld h,d
	ld l,$44
	ld (hl),$02
	ld hl,mainScripts.mittensOwnerScript
	jp interactionSetScript
@state1:
	call interactionRunScript
	ld a,($cceb)
	or a
	jp z,npcFaceLinkAndAnimate
	call func_5a99
	jp @animate
@state2:
	call interactionRunScript
@animate:
	jp interactionAnimateAsNpc
	
func_5a99:
	ld e,$78
	ld a,(de)
	rst_jumpTable
	.dw @var38_00
	.dw @var38_01
	.dw @var38_02
	.dw @var38_03
@var38_00:
	ld h,d
	ld l,$78
	ld (hl),$01
	ld l,$49
	ld (hl),$08
	ld l,$50
	ld (hl),$28
	ld l,$54
	ld (hl),$00
	inc hl
	ld (hl),$fe
	ld l,$79
	ld (hl),$04
	ld a,$07
	jp interactionSetAnimation
@var38_01:
	ld h,d
	ld l,$79
	dec (hl)
	ret nz
	ld l,$78
	inc (hl)
	ld a,$08
	call interactionSetAnimation
	ld a,$53
	jp playSound
@var38_02:
	ld c,$28
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	ld h,d
	ld l,$78
	inc (hl)
	ld l,$79
	ld (hl),$04
	ld a,$07
	call interactionSetAnimation
	ld a,$57
	jp playSound
@var38_03:
	ld h,d
	ld l,$79
	dec (hl)
	ret nz
	xor a
	ld ($cceb),a
	ld a,$02
	jp interactionSetAnimation
