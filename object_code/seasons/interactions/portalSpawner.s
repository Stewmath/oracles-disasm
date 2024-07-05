; ==================================================================================================
; INTERAC_PORTAL_SPAWNER
; ==================================================================================================
interactionCodee1:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw interactionAnimate
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
@state1:
	ld a,(wActiveGroup)
	or a
	jr nz,+
	call objectGetTileAtPosition
	cp $e6
	ret nz
+
	call func_6e06
	ld a,$02
	ld e,$44
	ld (de),a
	jp objectSetVisible83
func_6e06:
	ld e,$42
	ld a,(de)
	or a
	ret nz
	call getThisRoomFlags
	ld a,(wActiveGroup)
	cp $02
	jr c,+
	cp $03
	ret nz
	ld a,(wActiveRoom)
	cp $a8
	ld hl,wOverworldRoomFlags + (<ROOM_SEASONS_004)
	jr z,+
	ld hl,wOverworldRoomFlags + (<ROOM_SEASONS_0f7)
+
	set 3,(hl)
	ret
