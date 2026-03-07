; ==================================================================================================
; INTERAC_9b
; ==================================================================================================
interactionCode9b:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	xor a
	ld ($cfd0),a
	ld ($cfd1),a
@state1:
	ld a,($cfd0)
	cp $02
	jr nz,func_5b49
	ld hl,$cfd1
	ld a,(hl)
	cp $03
	ret nz
	ld ($cc02),a
	ld hl,$cc63
	ld a,$80
	ldi (hl),a
	ld a,$6f
	ldi (hl),a
	ld a,$0f
	ldi (hl),a
	ld a,$55
	ldi (hl),a
	ld (hl),$03
	jp interactionDelete
func_5b49:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld a,($cfd0)
	or a
	ret z
	xor a
	ld ($cbb3),a
	dec a
	ld ($cbba),a
	jp interactionIncSubstate
@func_5b65:
	bit 6,a
	set 6,(hl)
	ret z
	res 6,(hl)
	set 7,(hl)
	ret
@substate1:
	ld hl,$cbb3
	ld b,$02
	call flashScreen
	ret z
	ld hl,$cfd0
	ld (hl),$ff
	push de
	call hideStatusBar
	call clearItems
	pop de
	xor a
	ld ($d01a),a
	call clearPaletteFadeVariablesAndRefreshPalettes
	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hBgPaletteSources),a
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ret
@substate2:
	ld a,$01
	call func_5a82
	ret nz
	ld a,$40
	ld (w1Link.yh),a
	ld a,$50
	ld (w1Link.xh),a
	ld a,$80
	ld ($d01a),a
	ld a,$02
	ld ($d008),a
	call setLinkForceStateToState08
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld c,$02
	jpab bank1.loadDeathRespawnBufferPreset
@substate3:
	call interactionDecCounter1
	ret nz
	ld a,GLOBALFLAG_DESTROYED_MOBLIN_HOUSE_REPAIRED
	call unsetGlobalFlag
	call getThisRoomFlags
	call @func_5b65
	ld c,(hl)
	ld a,>ROOM_SEASONS_06f
	ld b,<ROOM_SEASONS_06f
	call getRoomFlags
	ld (hl),c
	ld a,$03
	ld ($cc6a),a
	xor a
	ld (wLinkHealth),a
	jp interactionDelete
