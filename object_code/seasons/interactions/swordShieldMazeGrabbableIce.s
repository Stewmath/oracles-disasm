; ==================================================================================================
; INTERAC_D8_GRABBABLE_ICE
; ==================================================================================================
interactionCode68:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	jp objectSetVisiblec2
@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ld a,($cc77)
	or a
	jr nz,+
	ld a,($cc48)
	rrca
	call nc,objectPushLinkAwayOnCollision
+
	call objectAddToGrabbableObjectBuffer
@func_5833:
	call objectCheckIsOnHazard
	ret nc
	bit 6,a
	jr nz,+
	dec a
	jp z,objectReplaceWithSplash
	jp objectReplaceWithFallingDownHoleInteraction
+
	call getThisRoomFlags
	bit 6,(hl)
	jp nz,objectReplaceWithFallingDownHoleInteraction
	call objectSetInvisible
	ld l,$44
	ld (hl),$03
	ld l,$46
	ld (hl),$1e
	ld b,INTERAC_FALLDOWNHOLE
	jp objectCreateInteractionWithSubid00
@state2:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
@@substate0:
	ld h,d
	ld l,e
	inc (hl)
	xor a
	ld (wLinkGrabState2),a
	jp objectSetVisible81
@@substate1:
	ret
@@substate2:
	call objectCheckWithinRoomBoundary
	jp nc,interactionDelete
	call objectSetVisiblec1
	ld h,d
	ld l,$40
	res 1,(hl)
	ld e,$4f
	ld a,(de)
	or a
	jr z,@func_5833
	ret
@@substate3:
	ld h,d
	ld l,$40
	res 1,(hl)
	ld l,$45
	xor a
	ldd (hl),a
	inc a
	ld (hl),a
	jp objectSetVisible82
@state3:
	call interactionDecCounter1
	ret nz
	ld a,($d004)
	cp $01
	jr nz,delete
	ld a,($cc34)
	or a
	jr nz,delete
	ld a,($cc48)
	cp $d0
	jr nz,delete
	call resetLinkInvincibility
	ld a,$80
	ld ($cc02),a
	ld (wDisableWarpTiles),a
	ld ($ccab),a
	call getThisRoomFlags
	set 6,(hl)
	call func_58e4
	ldh a,(<hActiveObject)
	ld d,a
	ld a,(wDungeonFloor)
	dec a
	ld (wDungeonFloor),a
	call getActiveRoomFromDungeonMapPosition
	ld (wWarpDestRoom),a
	ld a,$85
	ld (wWarpDestGroup),a
	ld a,$0f
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
delete:
	jp interactionDelete
func_58e4:
	call objectGetTileAtPosition
	dec h
	ld b,l
	ld a,(wActiveTileIndex)
	cp $d0
	ld a,(wActiveTilePos)
	jr nz,func_590c
	ld a,b
	sub $10
	call func_5907
	jr z,func_590b
	ld a,b
	inc a
	call func_5907
	jr z,func_590b
	ld a,b
	add $10
	jr func_590c
func_5907:
	ld l,a
	ld a,(hl)
	or a
	ret
func_590b:
	ld a,l
func_590c:
	ld ($cfd0),a
	ld a,(wActiveRoom)
	cp $7f
	jr nz,+
	ld b,$27
+
	ld a,b
	ld (wWarpDestPos),a
	ret
