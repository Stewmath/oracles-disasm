; ==================================================================================================
; INTERAC_MAMAMU_DOG
;
; Variables (for subid $01):
;   var3a: Target position index
;   var3b: Highest valid value for "var3a" (before looping?)
;   var3c/3d: Address of "position data" to get target position from
;   var3e: Used as a counter in script
;   var3f: Animation index
; ==================================================================================================
interactionCode54:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw dog_subid00
	.dw dog_subid01

; Dog in mamamu's house
dog_subid00:
	call checkInteractionState
	jr nz,@state1

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr z,@dontDelete

	ld a,GLOBALFLAG_RETURNED_DOG
	call checkGlobalFlag
	jp nz,@dontDelete

	call getThisRoomFlags
	bit 5,(hl)
	jp nz,interactionDelete

@dontDelete:
	call dog_initGraphicsLoadScriptAndIncState
	ld h,d
	ld l,Interaction.angle
	ld (hl),$18
	ld l,Interaction.speed
	ld (hl),SPEED_100

	ld a,$02
	ld l,Interaction.var3f
	ld (hl),a
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp c,interactionDelete
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects


; Dog outside that Link needs to find for a "sidequest"
dog_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,GLOBALFLAG_RETURNED_DOG
	call checkGlobalFlag
	jp nz,interactionDelete
	ld hl,wPresentRoomFlags+$e7
	bit 7,(hl)
	jp z,interactionDelete

	; Check if the dog's location corresponds to this object; if not, delete self.
	ld a,(wMamamuDogLocation)
	ld h,d
	ld l,Interaction.var03
	cp (hl)
	jp nz,interactionDelete

	call dog_initGraphicsLoadScriptAndIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld l,Interaction.direction
	ld (hl),$ff

	; a==0 here, which is important. It was set to 0 by the call to
	; "interactionSetScript", and wasn't changed after that...
	; It's probably supposed to equal "var03" here. Bug?
	call dog_setTargetPositionIndex

	ld hl,wMamamuDogLocation
@tryAgain:
	call getRandomNumber
	and $03
	cp (hl)
	jr z,@tryAgain
	ld (hl),a

@state1:
	call dog_moveTowardTargetPosition
	call dog_checkCloseToTargetPosition
	call c,dog_incTargetPositionIndex
	jr c,@delete

	call dog_moveTowardTargetPosition
	call dog_updateDirection
	call dog_checkCloseToTargetPosition
	call c,dog_incTargetPositionIndex
	jr c,@delete

	callab scriptHelp.mamamuDog_updateSpeedZ
	call interactionAnimate
	call objectSetPriorityRelativeToLink_withTerrainEffects
	jp objectAddToGrabbableObjectBuffer

@delete:
	jp interactionDelete


; State 2: grabbed by Link (will cause Link to warp to mamamu's house)
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

; Just grabbed
@substate0:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	ld a,GLOBALFLAG_RETURNED_DOG
	call setGlobalFlag
	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisableScreenTransitions),a
	jp objectSetVisiblec1

; Being lifted
@substate1:
	ld e,Interaction.var39
	ld a,(de)
	rst_jumpTable
	.dw @@minorState0
	.dw @@minorState1
	.dw @@minorState2

@@minorState0:
	ld a,(wLinkGrabState)
	cp $83
	ret nz

	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	ld h,d
	ld l,Interaction.var39
	inc (hl)
	ld l,Interaction.counter1
	ld (hl),40

@@minorState1:
	call interactionDecCounter1
	ret nz

	ld h,d
	ld l,Interaction.var39
	inc (hl)
	ld bc,TX_007f
	jp showText

@@minorState2:
	ld a,(wTextIsActive)
	or a
	ret nz
	ld hl,@warpDest
	call setWarpDestVariables
	ld a,SND_TELEPORT
	jp playSound

@warpDest:
	m_HardcodedWarpA ROOM_AGES_2e7, $00, $25, $83

@substate2:
	ret

@substate3:
	jp objectSetVisiblec2


@initGraphicsAndIncState: ; Unused?
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState


dog_initGraphicsLoadScriptAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld e,Interaction.subid
	ld a,(de)
	ld hl,dog_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

;;
dog_moveTowardTargetPosition:
	ld h,d
	ld l,Interaction.var3a
	ld a,(hl)
	add a
	ld b,a

	ld e,Interaction.var3d
	ld a,(de)
	ld l,a
	ld e,Interaction.var3c
	ld a,(de)
	ld h,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	jp objectApplySpeed

;;
; @param[out]	cflag	Set if close to target position
dog_checkCloseToTargetPosition:
	call dog_getTargetPositionAddress
	ld l,Interaction.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret nc
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $05
	ret

;;
; Update direction based on angle.
dog_updateDirection:
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	add $02
	jp interactionSetAnimation

;;
; @param[out]	cflag	Set if the position index "looped" (dog went off-screen)
dog_incTargetPositionIndex:
	call dog_snapToTargetPosition
	ld h,d
	ld l,Interaction.var3b
	ld a,(hl)
	ld l,Interaction.var3a
	inc (hl)

	; Check whether to loop back around
	cp (hl)
	ret nc
	ld (hl),$00
	scf
	ret

;;
dog_snapToTargetPosition:
	call dog_getTargetPositionAddress
	ld l,Interaction.y
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	inc bc
	ld l,Interaction.x
	xor a
	ldi (hl),a
	ld a,(bc)
	ld (hl),a
	ret

;;
; @param[out]	bc	Address of target position (2 bytes, Y and X)
dog_getTargetPositionAddress:
	ld e,Interaction.var3d
	ld a,(de)
	ld c,a
	ld e,Interaction.var3c
	ld a,(de)
	ld b,a
	ld h,d
	ld l,Interaction.var3a
	ld a,(hl)
	call addDoubleIndexToBc
	ret

;;
; This function is supposed to return the address of a "position list" for a map; however,
; due to an apparent issue with the caller, the data for the first map is always used.
;
; @param	a	Index of data to read (0-3 for corresponding maps)
dog_setTargetPositionIndex:
	ld hl,@dogPositionLists
	rst_addDoubleIndex
	ld e,Interaction.var3d
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3c
	ldi a,(hl)
	ld (de),a

	ld e,Interaction.var3b
	ld a,$06
	ld (de),a
	ret

@dogPositionLists:
	.dw @map0
	.dw @map1
	.dw @map2
	.dw @map3

@map0:
	.db $68 $68
	.db $48 $48
	.db $68 $18
	.db $68 $48
	.db $48 $28
	.db $68 $58
	.db $48 $00
@map1:
	.db $38 $78
	.db $68 $28
	.db $68 $88
	.db $68 $38
	.db $28 $68
	.db $58 $48
	.db $48 $b0
@map2:
	.db $68 $28
	.db $48 $08
	.db $58 $58
	.db $28 $18
	.db $18 $68
	.db $48 $38
	.db $00 $68
@map3:
	.db $18 $38
	.db $68 $78
	.db $68 $28
	.db $38 $78
	.db $38 $38
	.db $58 $68
	.db $58 $00


dog_scriptTable:
	.dw mainScripts.dogInMamamusHouseScript
