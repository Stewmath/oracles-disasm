 m_section_free Bank_1_Code_1 NAMESPACE bank1

;;
func_4000:
	ld a,(wScrollMode)
	or a
	call nz,func_400b
	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
func_400b:
	ld a,(wScreenTransitionState)
	rst_jumpTable
	.dw screenTransitionState0
	.dw screenTransitionState1
	.dw screenTransitionState2
	.dw screenTransitionState3
	.dw screenTransitionState4
	.dw screenTransitionState5

;;
; State 0: Entering a room from scratch (after entering/exiting a building, fadeout
; transition, etc)
;
screenTransitionState0:
	xor a
	ld (wPaletteThread_parameter),a
	call checkDarkenRoom
	ld a,$01
	ld (wScreenTransitionState),a

;;
initializeRoomBoundaryAndLoadAnimations:
	call setCameraFocusedObjectToLink
	ld b,$01
	ld a,(wActiveGroup)
	and NUM_SMALL_GROUPS
	jr z,+
	ld b,$00
+
	ld a,b
	ld (wcd01),a
	xor $01
	ld (wRoomIsLarge),a

	ld a,(wcd01)
	add a
	ld hl,@data_406d
	rst_addDoubleIndex

	; Load values of wRoomWidth, wRoomHeight, wScreenTransitionBoundaryX,
	; wScreenTransitionBoundaryY
	ld de,wRoomWidth
	ld b,$04
--
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,--

	ld a,(wRoomWidth)
	sub 20
	add a
	add a
	add a
	ld (wMaxCameraY),a
	ld a,(wRoomHeight)
	sub 16
	add a
	add a
	add a
	ld (wMaxCameraX),a
	call calculateRoomEdge
	jp loadTilesetAnimation

; Format:
; b0: wRoomWidth (measured in 8x8 tiles)
; b1: wRoomHeight
; b2: wScreenTransitionBoundaryX
; b3: wScreenTransitionBoundaryY
@data_406d:
	.db LARGE_ROOM_WIDTH*2      LARGE_ROOM_HEIGHT*2   ; Large rooms
	.db LARGE_ROOM_WIDTH*16-6   LARGE_ROOM_HEIGHT*16-7
	.db SMALL_ROOM_WIDTH*2      SMALL_ROOM_HEIGHT*2   ; Small rooms
	.db SMALL_ROOM_WIDTH*16-6   SMALL_ROOM_HEIGHT*16-7

;;
; State 1: Waiting a bit before giving control to return to Link.
;
screenTransitionState1:
	ld a,(wcd03)
	inc a
	ld (wcd03),a
	ld a,(wScreenTransitionState2)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw setScreenTransitionState02

;;
; Initializing
;
@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,$02
	ld (wScrollMode),a
	ld a,$01
	ld (wScreenTransitionState2),a
	xor a
	ld (wScreenTransitionState3),a
	ld (wcd03),a
	jp resetCamera

;;
; More initializing?
;
@substate1:
	ld a,(wScreenOffsetX)
	ld b,a
	ldh a,(<hCameraX)
	add b
	add $50
	rrca
	rrca
	rrca
	dec a
	and $1f
	ld (wScreenScrollRow),a
	inc a
	ld (wScreenScrollDirection),a
	xor a
	ld (wScreenScrollCounter),a
	ld a,$02
	ld (wScreenTransitionState2),a
	ret

;;
; The game is in this state while the screen is scrolling
;
@substate2:
	ld a,(wScreenScrollCounter)
	cp $20
	jr z,setScreenTransitionState02

	inc a
	ld (wScreenScrollCounter),a
	ld a,(wcd03)
	rrca
	jr c,+

	ld a,(wScreenScrollRow)
	ldh (<hFF8B),a
	ld b,a
	dec a
	and $1f
	ld (wScreenScrollRow),a
	jr ++
+
	ld a,(wScreenScrollDirection)
	ldh (<hFF8B),a
	ld b,a
	inc a
	and $1f
	ld (wScreenScrollDirection),a
++
	ld e,b
	call func_46ca
	ldh a,(<hFF8B)
	jp addFunctionsToVBlankQueue

;;
setScreenTransitionState02:
	call setInstrumentsDisabledCounterAndScrollMode
	ld a,$02
	ld (wScreenTransitionState),a
	xor a
	ld (wScreenTransitionState2),a
	ld (wScreenTransitionState3),a
	ret

;;
; State 2: no screen transition is active; check whether one should be activated.
;
; Called every frame.
;
screenTransitionState2:
	ld a,(wLinkInAir)
	add a
	jr c,+
	jr z,+

	ld a,$04
	ld (wScreenTransitionDelay),a
+
	; Check for a "forced" screen transition from bit 7
	ld a,(wScreenTransitionDirection)
	bit 7,a
	jr z,+

	and $7f
	ld c,a
	jp @startTransition
+
	; Check for screen-edge transitions
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.yh
	ld a,$05
	cp (hl)
	jr nc,@transitionUp

	ld a,(wScreenTransitionBoundaryY)
	cp (hl)
	jr c,@transitionDown
--
	ld l,<w1Link.xh
	ld a,$05
	cp (hl)
	jr nc,@transitionLeft
	ld a,(wScreenTransitionBoundaryX)
	cp (hl)
	jr c,@transitionRight
	ret

@transitionUp:
	inc a
	ld (hl),a
	ld b,BTN_UP
	ld c,DIR_UP
	call @transition
	jr --

@transitionDown:
	ld (hl),a
	ld b,BTN_DOWN
	ld c,DIR_DOWN
	call @transition
	jr --

@transitionLeft:
	inc a
	ld (hl),a
	ld b,BTN_LEFT
	ld c,DIR_LEFT
	jr @transition

@transitionRight:
	ld (hl),a
	ld b,BTN_RIGHT
	ld c,DIR_RIGHT

;;
; @param	b	Direction button to check
; @param	c	Direction of transition (see constants/directions.s)
@transition:
	ld a,(w1Link.enabled)
	or a
	ret z

	ld a,(wDisableScreenTransitions)
	or a
	ret nz

	; Don't transition until this counter reaches 0
	ld a,(wScreenTransitionDelay)
	or a
	jr z,+
	dec a
	ld (wScreenTransitionDelay),a
	ret
+
	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_MINECART
	jr z,@startTransition

	; Don't allow transitions over holes
	ld a,(wcc92)
	add a
	ret c

	; Do something if jumping down a ledge
	ld a,(wLinkInAir)
	add a
	jr c,@startTransition

	; Don't transition while experiencing knockback
	ld a,(w1Link.knockbackCounter)
	or a
	ret nz

	; Check the lower 7 bits; allows transitions to occur if on a conveyor and not
	; moving toward the screen edge?
	ld a,(wcc92)
	add a
	jr nz,+

	; Check that Link is moving toward the boundary
	call convertLinkAngleToDirectionButtons
	and b
	ret z
+
.ifdef ROM_AGES
	; Ages only: forbid looping around the overworld map in any direction, except up.
	ld a,(wTilesetFlags)
	and TILESETFLAG_OUTDOORS
	jr z,@doneBoundaryChecks

	; Check rightmost map boundary
	ld a,(wActiveRoom)
	ld e,a
	and $0f
	cp OVERWORLD_WIDTH-1
	jr nz,+
	ld a,c
	cp DIR_RIGHT
	ret z
+
	; Check bottom-most map boundary
	ld a,e
	cp (OVERWORLD_HEIGHT-1)*16
	jr c,+
	ld a,c
	cp DIR_DOWN
	ret z
+
	; Check leftmost map boundary
	ld a,e
	and $0f
	jr nz,@doneBoundaryChecks
	ld a,c
	cp DIR_LEFT
	ret z

@doneBoundaryChecks:
	; Skip hazard checks if underwater
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr nz,@startTransition

	; Also skip checks if on a conveyor? (Or on the raft, apparently?)
	ld a,(wcc92)
	and $08
	jr nz,@startTransition

.endif ; ROM_AGES

	; Return if Link is over a hole/lava, or over water without flippers?
	call checkLinkIsOverHazard
	rrca
	call c,@checkCanTransitionOverWater
	and $03
	ret nz


@startTransition:
	ld a,$04
	ld (wScrollMode),a
	ld a,$03
	ld (wScreenTransitionState),a
	ld a,c
	ld (wScreenTransitionDirection),a
	ret

;;
; @param[out]	a	One of bits 0/1 set if Link is forbidden to transition over water.
@checkCanTransitionOverWater:
	; Return false if Link is riding something? (apparently code execution doesn't
	; reach here if Link is riding the raft, perhaps Dimitri as well?)
	ld a,(wLinkObjectIndex)
	rrca
	jr c,@fail

.ifdef ROM_AGES
	ld a,TREASURE_MERMAID_SUIT
	call checkTreasureObtained
	ret c
	ld a,(wObjectTileIndex)
	cp TILEINDEX_DEEP_WATER
	jr z,@fail
.endif

	ld a,TREASURE_FLIPPERS
	call checkTreasureObtained
	ret c

@fail:
	ld a,$ff
	ret

;;
; Updates the values for hCameraY/X. They get updated one pixel at a time in each
; direction.
;
updateCameraPosition:
	ld hl,wScrollMode
	res 7,(hl)
	ld a,(wActiveGroup)
	cp NUM_SMALL_GROUPS
	jr nc,@largeRoom

@smallRoom:
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ret

@largeRoom:
	ld a,(wCameraFocusedObject)
	ld d,a
	ld a,(wCameraFocusedObjectType)
	add Object.yh
	ld e,a

	; Update Y
	ld hl,hCameraY
	ld a,(de)
	sub SCREEN_HEIGHT*16/2
	jr nc,+
	xor a
+
	cp (LARGE_ROOM_HEIGHT-SCREEN_HEIGHT)*16
	jr c,+
	ld a,(LARGE_ROOM_HEIGHT-SCREEN_HEIGHT)*16
+
	call @updateComponent

	; Update X
	ld hl,hCameraX
	inc de
	inc de
	ld a,(de)
	sub SCREEN_WIDTH*16/2
	jr nc,+
	xor a
+
	cp (LARGE_ROOM_WIDTH-SCREEN_WIDTH)*16
	jr c,@updateComponent
	ld a,(LARGE_ROOM_WIDTH-SCREEN_WIDTH)*16

;;
; @param	a	Target value for the position component
; @param	hl	Position component
@updateComponent:
	ld b,a
	ld a,(wTextIsActive)
	or a
	jr nz,@smBit7

	ld a,(hl)
	cp b
	ret z
	jr c,+

	dec (hl)
	jr @smBit7
+
	inc (hl)

@smBit7:
	ld hl,wScrollMode
	set 7,(hl)
	ret

;;
; Sets hCameraY/X to the correct values immediately. Differs from "updateCameraPosition"
; since that function updates it one pixel at a time.
;
; Called when loading a screen.
;
calculateCameraPosition:
	ld a,(wLinkObjectIndex)
	ld d,a
	ld e,<w1Link.yh
	ld a,(de)
	sub SCREEN_HEIGHT*16/2
	jr nc,+
	xor a
+
	ld hl,wMaxCameraX
	cp (hl)
	jr c,+
	ld a,(hl)
+
	ldh (<hCameraY),a
	ld e,<w1Link.xh
	ld a,(de)
	sub SCREEN_WIDTH*16/2
	jr nc,+
	xor a
+
	ld hl,wMaxCameraY
	cp (hl)
	jr c,+
	ld a,(hl)
+
	ldh (<hCameraX),a
	ret

;;
; Adjusts wGfxRegs2.SCY and SCX if the screen should be shaking.
;
updateScreenShake:
	ld a,(wMenuDisabled)
	or a
	jr nz,++

	ld a,(wLinkPlayingInstrument)
	or a
	ret nz
++
	ld a,(wScreenShakeCounterY)
	or a
	jr z,++

	call @getShakeAmount
	ld a,(wGfxRegs2.SCY)
	add (hl)
	ld (wGfxRegs2.SCY),a
	ld hl,wScreenShakeCounterY
	dec (hl)
++
	ld a,(wScreenShakeCounterX)
	or a
	ret z

	call @getShakeAmount
	ld a,(wGfxRegs2.SCX)
	add (hl)
	ld (wGfxRegs2.SCX),a
	ld hl,wScreenShakeCounterX
	dec (hl)
	ret

;;
; @param[out]	hl	Pointer to amount to offset the screen by
@getShakeAmount:
	ld a,(wScreenShakeMagnitude)
	add a
	ld hl,@data
	rst_addDoubleIndex
	call getRandomNumber
	and $03
	rst_addAToHl
	ret

@data:
	.db $fe $ff $01 $02 ; [wScreenShakeMagnitude] == 0
	.db $ff $ff $01 $01 ; 1
	.db $fd $fd $03 $03 ; 2

;;
; Sets wGfxRegs2.SCY and SCX based on wScreenOffsetY/X and hCameraY/X.
;
updateGfxRegs2Scroll:
	ldh a,(<hCameraY)
	ld b,a
	ld a,(wScreenOffsetY)
	add b
	sub $10
	ld (wGfxRegs2.SCY),a
	ldh a,(<hCameraX)
	ld b,a
	ld a,(wScreenOffsetX)
	add b
	ld (wGfxRegs2.SCX),a
	ret

;;
; State 3: the edge of the screen has just been touched
;
screenTransitionState3:
	ld a,(wScrollMode)
	bit 7,a
	ret nz

	cp $08
	ret nz

	call loadTilesetAnimation
	call checkDarkenRoom

	; Decide whether to proceed to state 4 or 5
	ld b,$05
	ld a,(wTilesetUniqueGfx)
	bit 7,a
	jr nz,+
	or a
	jr z,+

	call loadUniqueGfxHeader
	ld b,$04
+
	ld hl,wScreenTransitionState
	ld a,b
	ldi (hl),a

	; [wScreenTransitionState2] = 0
	xor a
	ld (hl),a

	ld (wScreenTransitionState3),a
	ret

;;
checkDarkenRoomAndClearPaletteFadeState:
	xor a
	ld (wPaletteThread_parameter),a

;;
checkDarkenRoom:
	ld a,(wDungeonIndex)
	cp $ff
	ret z

.ifdef ROM_SEASONS
	; Hardcoded check for snake's remains entrance
	ld a,(wActiveGroup)
	cp $04
	jr nz,++
	ld a,(wActiveRoom)
	cp $39
	jr nz,++
	call getThisRoomFlags
	and $80
	ret nz
++

.endif

	call getThisRoomDungeonProperties
	ld a,(wDungeonRoomProperties)
	bit DUNGEONROOMPROPERTY_DARK_BIT,a
	ret z
	jp darkenRoom

;;
checkBrightenRoom:
	ld a,(wDungeonIndex)
	cp $ff
	ret z

	call getThisRoomDungeonProperties
	ld a,(wDungeonRoomProperties)
	bit DUNGEONROOMPROPERTY_DARK_BIT,a
	ret nz

	ld a,(wPaletteThread_parameter)
	or a
	ret z
	jp brightenRoom

;;
; State 4: reload unique gfx / palettes, then proceed to state 5?
;
screenTransitionState4:
	call updateTilesetUniqueGfx
	ret c

	ld a,(wTilesetUniqueGfx)
	ld (wLoadedTilesetUniqueGfx),a
	xor a
	ld (wTilesetUniqueGfx),a

	call func_47fc
	call nc,updateTilesetPalette
	ld hl,wScreenTransitionState
	ld a,$05
	ldi (hl),a
	xor a
	ld (hl),a
	ld (wScreenTransitionState3),a
	ret

;;
; State 5: Scrolling between 2 screens
;
screenTransitionState5:
	ld a,(wScreenTransitionState2)
	rst_jumpTable
	.dw screenTransitionState5Substate0
	.dw screenTransitionState5Substate1
	.dw screenTransitionState5Substate2

;;
screenTransitionState5Substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_OUTDOORS
	call nz,checkAndApplyPaletteFadeTransition
.else; ROM_SEASONS
	ld a,(wActiveGroup)
	or a
	call z,checkAndApplyPaletteFadeTransition
.endif

	ld a,(wcd01)
	swap a
	ld l,a
	ld a,(wScreenTransitionDirection)
	add a
	add a
	add l
	ld hl,@data
	rst_addAToHl

	ldi a,(hl)
	ld (wScreenScrollRow),a
	ldi a,(hl)
	ld (wScreenScrollVramRow),a
	ldi a,(hl)
	ld (wScreenScrollDirection),a
	ldi a,(hl)
	ld (wcd14),a
	call resetCamera

	xor a
	ld (wScreenTransitionState3),a
	call setScreenShakeCounter

	ld a,(wScreenTransitionDirection)
	and $01
	jr z,@vertical

@horizontal:
	ld a,$14
	ld (wScreenScrollCounter),a
	ld a,$02
	ld (wScreenTransitionState2),a
	ret

@vertical:
	ld a,$10
	ld (wScreenScrollCounter),a
	ld a,$01
	ld (wScreenTransitionState2),a
	ret

; Data format:
; b0: Tile (8x8) to start the scroll at
; b1: # of tiles (8x8) to scroll through
; b2: Direction of transition (incrementing or decrementing)
; b3: Value to add to screen offset each frame

@data:
	; Large rooms
	.db  LARGE_ROOM_HEIGHT*2-1  $ff                  $ff  $fc  ;  DIR_UP
	.db  $00                    LARGE_ROOM_WIDTH*2   $01  $04  ;  DIR_RIGHT
	.db  $00                    LARGE_ROOM_HEIGHT*2  $01  $04  ;  DIR_DOWN
	.db  LARGE_ROOM_WIDTH*2-1   $ff                  $ff  $fc  ;  DIR_LEFT

	; Small rooms
	.db  SMALL_ROOM_HEIGHT*2-1  $ff                  $ff  $fc  ;  DIR_UP
	.db  $00                    SMALL_ROOM_WIDTH*2   $01  $04  ;  DIR_RIGHT
	.db  $00                    SMALL_ROOM_HEIGHT*2  $01  $04  ;  DIR_DOWN
	.db  SMALL_ROOM_WIDTH*2-1   $ff                  $ff  $fc  ;  DIR_LEFT

;;
; During a scrolling screen transition, this is called to update the screen scroll and
; Link's position.
;
; @param	cflag	Set for horizontal transition, unset for vertical
transitionUpdateScrollAndLinkPosition:
	ld de,wGfxRegs2.SCY
	ld hl,hCameraY
	jr nc,+

	; Horizontal transition (set de and hl to respective horizontal vars)
	inc e
	inc l
	inc l
+
	ld b,$00
	ld a,(wcd14)
	ld c,a
	rlca
	jr nc,+
	dec b
+
	; Increment/decrement SCY or SCX
	ld a,(de)
	add c
	ld (de),a

	; Increment/decrement hCameraY/X
	ld a,(hl)
	add c
	ldi (hl),a
	ld a,(hl)
	adc b
	ld (hl),a

	call cpLinkState0e
	ret z

	ld a,(wScreenTransitionDirection)
	add a
	ld de,@linkSpeeds
	call addDoubleIndexToDe
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.y
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc de
	ld a,(de)
	adc (hl)
	ldi (hl),a
	inc de
	ld a,(de)
	add (hl)
	ldi (hl),a
	inc de
	ld a,(de)
	adc (hl)
	ldi (hl),a
	ret

; Values to add to Link's position each frame
;
@linkSpeeds:
	.dw -$80, $00 ; DIR_UP
	.dw  $00, $60 ; DIR_RIGHT
	.dw  $80, $00 ; DIR_DOWN
	.dw  $00,-$60 ; DIR_LEFT

;;
; Wrap everything up after a scrolling screen transition.
;
; Updates Link's position after a completed screen transition, and updates his local
; respawn position.
;
finishScrollingTransition:
	call cpLinkState0e
	ret z

	ld a,(wcd01)
	swap a
	rrca
	ld e,a
	ld a,(wScreenTransitionDirection)
	add a
	add e
	ld de,label_01_037@positionOffsets
	call addAToDe

;;
; @param	de	Pointer to 2 bytes (values to add to Link's Y/X)
label_01_037:
	ld a,(wLinkObjectIndex)
	ld h,a

	ld l,<w1Link.yh
	ld a,(de)
	add (hl)
	ldi (hl),a
	ld (wLinkLocalRespawnY),a

	inc de
	inc l
	ld a,(de)
	add (hl)
	ld (hl),a
	ld (wLinkLocalRespawnX),a

	ld l,<w1Link.direction
	ld a,(hl)
	ld (wLinkLocalRespawnDir),a
	srl h
	jr nc,+

	ld hl,wLastAnimalMountPointY
	ld a,(wLinkLocalRespawnY)
	ldi (hl),a
	ld a,(wLinkLocalRespawnX)
	ld (hl),a
+
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ldh (<hCameraY+1),a
	ldh (<hCameraX+1),a

	call resetFollowingLinkObjectPosition
	call clearObjectsWithEnabled2

	ld a,TREE_GFXH_01
	ld (wLoadedTreeGfxIndex),a

	call calculateCameraPosition
	jp updateGfxRegs2Scroll

; Data format:
; b0: Value to add to w1Link.yh
; b1: Value to add to w1Link.xh

@positionOffsets:
	; Large rooms
	.db LARGE_ROOM_HEIGHT*16        $00                  ; DIR_UP
	.db $00                      <(-LARGE_ROOM_WIDTH*16) ; DIR_RIGHT
	.db <(-LARGE_ROOM_HEIGHT*16)    $00                  ; DIR_DOWN
	.db $00                         LARGE_ROOM_WIDTH*16  ; DIR_LEFT

	; Small rooms
	.db SMALL_ROOM_HEIGHT*16        $00                  ; DIR_UP
	.db $00                      <(-SMALL_ROOM_WIDTH*16) ; DIR_RIGHT
	.db <(-SMALL_ROOM_HEIGHT*16)    $00                  ; DIR_DOWN
	.db $00                         SMALL_ROOM_WIDTH*16  ; DIR_LEFT

;;
func_4493:
	ld a,(wScreenTransitionDirection)
	ld de,@positionOffsets
	call addDoubleIndexToDe
	jr label_01_037

@positionOffsets:
	.db $70 $00 ; DIR_UP
	.db $00 $70 ; DIR_RIGHT
	.db $90 $00 ; DIR_DOWN
	.db $00 $90 ; DIR_LEFT

;;
; Reset w2LinkWalkPath such that it's as if Link walked out from the screen's edge.
; Called after screen transitions.
;
resetFollowingLinkObjectPosition:
	ld a,(wFollowingLinkObject)
	or a
	ret z

	ld a,(w1Link.yh)
	ld d,a
	ld a,(w1Link.xh)
	ld e,a

	ld a,(wScreenTransitionDirection)
	and $03
	ld c,a
	ld hl,@movementOffsets
	rst_addDoubleIndex

	ldi a,(hl)
	ldh (<hFF8D),a
	ld a,(hl)
	ldh (<hFF8C),a

	ld a,:w2LinkWalkPath
	ld ($ff00+R_SVBK),a

	; Fill w2LinkWalkPath with the correct values to move out from the screen edge
	ld hl,w2LinkWalkPath + $2f
	ld b,$10
--
	ldh a,(<hFF8C)
	add e
	ld e,a
	ldd (hl),a
	ldh a,(<hFF8D)
	add d
	ld d,a
	ldd (hl),a
	ld a,c
	ldd (hl),a
	dec b
	jr nz,--

	xor a
	ld ($ff00+R_SVBK),a

	; Initialize the object's position
	ld a,(wFollowingLinkObjectType)
	add Object.yh
	ld l,a
	ld a,(wFollowingLinkObject)
	ld h,a
	ld (hl),d
	inc l
	inc l
	ld (hl),e

	ld a,$0f
	ld (wLinkPathIndex),a
	ret

@movementOffsets:
	.db $01 $00 ; DIR_UP
	.db $00 $ff ; DIR_RIGHT
	.db $ff $00 ; DIR_DOWN
	.db $00 $01 ; DIR_LEFT

;;
; State 5 substate 2: horizontal scrolling transition. Very similar to the vertical
; scrolling code below (state 5 substate 1).
;
screenTransitionState5Substate2:
	ld a,(wScreenTransitionState3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

;;
@state0:
	ld a,(wScreenOffsetX)
	swap a
	rlca
	ld b,a
	ld a,(wScreenScrollVramRow)
	add b
	and $1f
	ld (wScreenScrollVramRow),a

	ld a,$01
	ld (wScreenTransitionState3),a
	ret

;;
@state1:
	ld a,$02
	ld (wScreenTransitionState3),a
	jp @drawNextRow

;;
; This state causes the actual scrolling.
;
; When this state ends, anything just outside the screen won't have been drawn yet; that's
; handled in state 3.
;
@state2:
	scf
	call transitionUpdateScrollAndLinkPosition

	; Return unless aligned at the start of a tile
	ld a,(wGfxRegs2.SCX)
	and $07
	ret nz

	ld a,(wScreenScrollCounter)
	or a
	jr nz,@drawNextRow

	; wScreenScrollCounter has reached 0; go to state 3.

	ld hl,wScreenTransitionState3
	inc (hl)

	; Calculate how many more columns state 3 needs to draw
	ld a,(wMaxCameraY)
	swap a
	rlca
	ld (wScreenScrollCounter),a

	ret

;;
; This state draws anything remaining past the edge of the screen.
;
@state3:
	; Draw any remaining columns
	ld a,(wScreenScrollCounter)
	or a
	jr nz,@drawNextRow

	; All columns drawn

	; Increment state once, then decide whether to increment it again
	ld hl,wScreenTransitionState3
	inc (hl)

	; Go to state 4 if wTilesetUniqueGfx is nonzero, otherwise go to state 5
	ld a,(wTilesetUniqueGfx)
	or a
	jp nz,loadUniqueGfxHeader
	inc (hl)
	ret

;;
@state4:
	; Load one entry from the unique gfx per frame
	call updateTilesetUniqueGfx
	ret c

	; Finished loading unique gfx

	ld a,(wTilesetUniqueGfx)
	ld (wLoadedTilesetUniqueGfx),a
	xor a
	ld (wTilesetUniqueGfx),a
;;
@state5:
	call checkBrightenRoom
	call updateTilesetPalette
	call setInstrumentsDisabledCounterAndScrollMode

	; Return to screenTransitionState2 (no active transition)
	xor a
	ld (wScreenTransitionState2),a
	ld (wScreenTransitionState3),a
	ld a,$02
	ld (wScreenTransitionState),a

	; Update wScreenOffsetX. hCameraX will be updated after the jump below (unless
	; w1Link.state == LINK_STATE_0e?).
	ld a,(wRoomWidth)
	add a
	add a
	add a
	ld b,a
	ld a,(wScreenTransitionDirection)
	and $02
	jr z,+

	ld a,b
	cpl
	inc a
	ld b,a
+
	ld a,(wScreenOffsetX)
	add b
	ld (wScreenOffsetX),a

	jp finishScrollingTransition

;;
@drawNextRow:
	ld a,(wScreenScrollRow)
	ld e,a
	call func_46ca
	ld a,(wScreenScrollVramRow)
	call addFunctionsToVBlankQueue

;;
incrementScreenScrollRowVars:
	ld a,(wScreenScrollRow)
	ld b,a
	ld a,(wScreenScrollDirection)
	ld c,a

	; Increment wScreenScrollRow and wScreenScrollVramRow
	add b
	and $1f
	ld (wScreenScrollRow),a
	ld a,(wScreenScrollVramRow)
	add c
	and $1f
	ld (wScreenScrollVramRow),a

	ld a,(wScreenScrollCounter)
	dec a
	ld (wScreenScrollCounter),a
	ret

;;
addFunctionsToVBlankQueue:
	ld b,a
	ld c,$01
	ld e,$60
	call @locFunc
	ld c,$00
	ld e,$40
@locFunc:
	ldh a,(<hVBlankFunctionQueueTail)
	ld l,a
	ld h,>wVBlankFunctionQueue
	ld a,(vblankRunBank4FunctionOffset)
	ldi (hl),a
	ld a,c
	ldi (hl),a
	ld a,e
	ldi (hl),a
	ld a,b
	ld de,data_0bfd
	call addDoubleIndexToDe
	ld a,(de)
	ldi (hl),a
	inc de
	ld a,(de)
	ldi (hl),a
	ld a,l
	ldh (<hVBlankFunctionQueueTail),a
	ret

;;
; State 5 substate 1: vertical scrolling transition. Practically a copy of the horizontal
; transition code above.
;
screenTransitionState5Substate1:
	ld a,(wScreenTransitionState3)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

;;
@state0:
	ld a,(wScreenOffsetY)
	swap a
	rlca
	ld b,a
	ld a,(wScreenScrollVramRow)
	add b
	and $1f
	ld (wScreenScrollVramRow),a

	ld a,$01
	ld (wScreenTransitionState3),a
	ret

;;
@state1:
	ld a,$02
	ld (wScreenTransitionState3),a
	jp @drawNextRow

;;
; This state causes the actual scrolling.
;
; When this state ends, anything just outside the screen won't have been drawn yet; that's
; handled in state 3.
;
@state2:
	xor a
	call transitionUpdateScrollAndLinkPosition

	; Return unless aligned at the start of a tile
	ld a,(wGfxRegs2.SCY)
	and $07
	ret nz

	ld a,(wScreenScrollCounter)
	or a
	jr nz,@drawNextRow

	; wScreenScrollCounter has reached 0; go to state 3.

	ld hl,wScreenTransitionState3
	inc (hl)

	; Calculate how many more rows state 3 needs to draw
	ld a,(wMaxCameraX)
	swap a
	rlca
	ld (wScreenScrollCounter),a

	ret

;;
; This state draws anything remaining past the edge of the screen.
;
@state3:
	; Draw any remaining rows
	ld a,(wScreenScrollCounter)
	or a
	jr nz,@drawNextRow

	; All rows drawn

	; Increment state once, then decide whether to increment it again
	ld hl,wScreenTransitionState3
	inc (hl)

	; Go to state 4 if wTilesetUniqueGfx is nonzero, otherwise go to state 5
	ld a,(wTilesetUniqueGfx)
	or a
	jp nz,loadUniqueGfxHeader
	inc (hl)
	ret

;;
@state4:
	; Load one entry from the unique gfx per frame
	call updateTilesetUniqueGfx
	ret c

	; Finished loading unique gfx

	ld a,(wTilesetUniqueGfx)
	ld (wLoadedTilesetUniqueGfx),a
	xor a
	ld (wTilesetUniqueGfx),a
;;
@state5:
	call checkBrightenRoom
	call updateTilesetPalette
	call setInstrumentsDisabledCounterAndScrollMode

	; Return to screenTransitionState2 (no active transition)
	xor a
	ld (wScreenTransitionState2),a
	ld (wScreenTransitionState3),a
	ld a,$02
	ld (wScreenTransitionState),a

	; Update hCameraY and wScreenOffsetY with the table below.
	; Note: The new value for hCameraY is going to get overwritten after the jump
	; (unless w1Link.state == LINK_STATE_0e?).
	ld a,(wcd01)
	add a
	add a
	ld l,a
	ld a,(wScreenTransitionDirection)
	add l
	ld hl,@offsetVariables
	rst_addAToHl

	ldi a,(hl)
	ldh (<hCameraY),a
	ld a,(hl)
	ld b,a
	ld a,(wScreenOffsetY)
	add b
	ld (wScreenOffsetY),a

	jp finishScrollingTransition

; Data format:
; b0: New value for hCameraY
; b1: Value to add to wScreenOffsetY

@offsetVariables: ; DIR_UP
	; Large rooms
	.db (LARGE_ROOM_HEIGHT-SCREEN_HEIGHT)*16   <(-LARGE_ROOM_HEIGHT*16) ; DIR_UP
	.db $00                                       LARGE_ROOM_HEIGHT*16  ; DIR_DOWN

	; Small rooms
	.db $00                                    <(-SMALL_ROOM_HEIGHT*16) ; DIR_UP
	.db $00                                       SMALL_ROOM_HEIGHT*16  ; DIR_DOWN

;;
@drawNextRow:
	; Load tiles and attributes to wTmpVramBuffer
	ld a,(wScreenScrollRow)
	ld e,a
	call copyTileRowToVramBuffer

	; DMA attributes
	ld c,$01
	call @queueRowDmaTransfer

	; DMA tiles
	ld c,$00
	call @queueRowDmaTransfer

	; Go to the next row
	jp incrementScreenScrollRowVars

;;
; @param	c	Tiles (0) or attributes (1)
@queueRowDmaTransfer:
	ld a,(wScreenScrollVramRow)
	ld b,a
	and $18
	rlca
	swap a
	add $98
	ld d,a

	ld a,b
	and $07
	swap a
	rlca
	or c
	ld e,a

	ld hl,wTmpVramBuffer
	srl c
	jr nc,+
	ld l,<wTmpVramBuffer+$20
+
	; b = $01 corresponds to $20 bytes copied.
	ld b,$01
	jp queueDmaTransfer

;;
func_46ca:
	ld a,(wScreenOffsetY)
	cpl
	inc a
	rrca
	rrca
	rrca
	ld hl,vramBgMapTable
	rst_addAToHl
	ldi a,(hl)
	add e
	ld e,a
	ld a,(hl)
	add $40
	ld d,a
	ld a,($ff00+R_SVBK)
	push af
	ld a,$03
	ld ($ff00+R_SVBK),a
	push de
	ld hl,wTmpVramBuffer
	ld b,$20
	ld c,$dc
	call func_46ff
	pop de
	ld a,$04
	add d
	ld d,a
	ld b,$20
	ld c,$e0
	call func_46ff
	pop af
	ld ($ff00+R_SVBK),a
	ret
;;
func_46ff:
	ld a,(de)
	ldi (hl),a
	ld a,$20
	add e
	ld e,a
	ld a,d
	adc $00
	cp c
	jr nz,+
	sub $04
+
	ld d,a
	dec b
	jr nz,func_46ff
	ret

;;
; Loads a row of tiles from w3VramTiles and w3VramAttributes into wTmpVramBuffer+$00 and
; wTmpVramBuffer+$20, respectively.
;
copyTileRowToVramBuffer:
	; Calculate the address of the row in w3VramTiles through black magic
	ld a,(wScreenOffsetX)
	cpl
	inc a
	swap a
	rlca
	ld c,a
	ld a,(wScreenScrollRow)
	rlca
	swap a
	ld b,a
	and $0f
	ld d,a
	ld a,b
	and $f0
	ld e,a
	ld hl,w3VramTiles
	add hl,de
	ld b,$00
	add hl,bc

	; Load wram bank
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a

	; Copy tiles to wTmpVramBuffer+$00
	push hl
	ld b,$20
	ld de,wTmpVramBuffer
	call @copyFunc

	; Copy attributes (w3VramAttributes) to wTmpVramBuffer+$20
	pop hl
	ld b,$20
	ld a,h
	add $04
	ld h,a
	ld de,wTmpVramBuffer+$20
	call @copyFunc

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; Copy bytes from a vram row; this means looping the source every $20 bytes.
;
; @param	b	Number of bytes to copy
; @param	de	Destination
; @param	hl	Source
@copyFunc:
	ld a,(hl)
	ld (de),a
	inc de
	inc l
	ld a,l
	and $1f
	jr nz,+

	ld a,l
	sub $20
	ld l,a
+
	dec b
	jr nz,@copyFunc
	ret

;;
; Check if the newly loaded tileset has a different palette than before, update accordingly
updateTilesetPalette:
	ld a,(wLoadedTilesetPalette)
	ld b,a
	ld a,(wTilesetPalette)
	cp b
	ret z

	ld (wLoadedTilesetPalette),a
	jp loadPaletteHeader

;;
cpLinkState0e:
	ld a,(wLinkObjectIndex)
	cp LINK_OBJECT_INDEX
	ret nz

	ld hl,w1Link.state
	ld a,LINK_STATE_0e
	cp (hl)
	ret

;;
; Loads w2WaveScrollValues to make the screen sway in a sine wave.
;
; @param	c	Amplitude
initWaveScrollValues_body:
	ld a,:w2WaveScrollValues
	ld ($ff00+R_SVBK),a
	ld de,@sineWave
	ld hl,w2WaveScrollValues
--
	push hl
	push de
	ld a,(de)
	call multiplyAByC
	ld a,h
	pop de
	pop hl
	ldi (hl),a
	inc de
	ld a,l
	cp <w2WaveScrollValues+$20
	jr c,--

	ld hl,w2WaveScrollValues+$1f
	ld de,w2WaveScrollValues+$20
	ld b,$20
-
	ldd a,(hl)
	ld (de),a
	inc e
	dec b
	jr nz,-

	ld hl,w2WaveScrollValues+$3f
	ld de,w2WaveScrollValues+$40
	ld b,$40
-
	ldd a,(hl)
	cpl
	inc a
	ld (de),a
	inc e
	dec b
	jr nz,-

	xor a
	ld ($ff00+R_SVBK),a
	ret

@sineWave:
	.db $00 $0d $19 $26 $32 $3e $4a $56
	.db $62 $6d $79 $84 $8e $98 $a2 $ac
	.db $b5 $be $c6 $ce $d5 $dc $e2 $e7
	.db $ed $f1 $f5 $f8 $fb $fd $ff $ff

; This almost works to replace the above, just a few values are off-by-1 for some reason.
;	.dbsin 0, 31, 90/32, $100, 0


;;
; Loads wBigBuffer with the values from w2WaveScrollValues (offset based on
; wFrameCounter). The LCD interrupt will read from here when configured properly.
;
; @param	b	Affects the frequency of the wave?
loadBigBufferScrollValues_body:
	ld a,:w2WaveScrollValues
	ld ($ff00+R_SVBK),a
	ld a,(wFrameCounter)
	and $7f
	ld c,a
	ld de,w2WaveScrollValues
	call addAToDe
	ld hl,wBigBuffer
--
	ld a,(de)
	ldi (hl),a
	ld a,e
	add b
	and $7f
	ld e,a
	ld a,l
	or a
	jr nz,--

	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
func_47fc:
	call getPaletteFadeTransitionData
	jr c,+

	xor a
	ret
+
	scf
	ret

;;
checkAndApplyPaletteFadeTransition:
	call getPaletteFadeTransitionData
	call c,applyPaletteFadeTransitionData
	ret


; "getPaletteFadeTransitionData" and "applyPaletteFadeTransitionData" functions have
; differing implementations in ages and seasons.
.ifdef ROM_AGES

;;
; Check if a room has a smooth palette transition (ie. entrance to Yoll Graveyard).
;
; @param[out]	cflag	Set if the active room has palette transition data
; @param[out]	hl	Address of palette fade data (if it has one)
getPaletteFadeTransitionData:
	; Don't do a transition in symmetry city if the tuni nut was fixed
	call checkSymmetryCityPaletteTransition
	ret nc

	ld a,(wActiveGroup)
	ld hl,paletteTransitionData
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	ld a,(wActiveRoom)
	ld b,a
	ld a,(wScreenTransitionDirection)
	ld c,a
--
	ldi a,(hl)
	cp $ff
	ret z

	cp c
	jr nz,+

	ld a,(hl)
	cp b
	jr z,++
+
	ld a,$05
	rst_addAToHl
	jr --
++
	inc hl
	scf
	ret

;;
; @param	hl	Address of palette fade transition data (starting at byte 2)
applyPaletteFadeTransitionData:
	ld a,(wLoadedTilesetPalette)
	ld b,a
	ld a,(wTilesetPalette)
	cp b
	ret z

	ld a,:w2ColorComponentBuffer1
	ld ($ff00+R_SVBK),a

	push hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,w2ColorComponentBuffer1
	call extractColorComponents

	pop hl
	inc hl
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,w2ColorComponentBuffer2
	call extractColorComponents

	xor a
	ld ($ff00+R_SVBK),a

	ld a,$ff
	ld (wLoadedTilesetPalette),a
	jp startFadeBetweenTwoPalettes

;;
; @param[out]	cflag	Set if the game should transition the palette between the symmetry
;			city exits (this gets unset when the tuni nut is replaced).
checkSymmetryCityPaletteTransition:
	ld a,(wActiveGroup)
	or a
	jr nz,@ok

	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jr z,@ok

	ld a,(wActiveRoom)
	cp $12
	jr z,@notOk
	cp $22
	jr z,@notOk
	cp $14
	jr z,@notOk
	cp $24
	jr z,@notOk
@ok:
	scf
	ret
@notOk:
	xor a
	ret


.else ; ROM_SEASONS

;;
; Check if a room has a smooth palette transition (ie. entrance to Yoll Graveyard).
;
; @param[out]	cflag	Set if the active room has palette transition data
; @param[out]	hl	Address of palette fade data (if it has one)
getPaletteFadeTransitionData:
	ld a,(wActiveGroup)
	ld b,a
	rrca
	and $7f
	ret nz

	ld a,b
	ld hl,paletteTransitionIndexData
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld b,a
--
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	cp $ff
	ret z
	ld a,(wScreenTransitionDirection)
	cp (hl)
	jr nz,+
	ld a,c
	cp b
	jr z,++
+
	inc hl
	inc hl
	inc hl
	jr --
++
	scf
	ret

;;
; @param	hl	Address of palette fade transition data (starting at byte 1)
applyPaletteFadeTransitionData:
	inc hl
	ld a,:w2ColorComponentBuffer1
	ld ($ff00+R_SVBK),a
	ldi a,(hl)
	push hl
	swap a
	rrca

	ld hl,paletteTransitionSeasonData
	rst_addAToHl
	ld a,(wRoomStateModifier)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,w2ColorComponentBuffer1
	call extractColorComponents

	pop hl
	ld a,(hl)
	swap a
	rrca

	ld hl,paletteTransitionSeasonData
	rst_addAToHl
	ld a,(wRoomStateModifier)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld de,w2ColorComponentBuffer2
	call extractColorComponents

	ld a,$00
	ld ($ff00+R_SVBK),a

	ld a,$ff
	ld (wLoadedTilesetPalette),a
	jp startFadeBetweenTwoPalettes

.endif ; ROM_SEASONS

.include "build/data/paletteTransitions.s"


;;
; Used by Impa, Rosa when following Link.
;
makeActiveObjectFollowLink:
	ld hl,wFollowingLinkObjectType
	ldh a,(<hActiveObjectType)
	ldi (hl),a
	ldh a,(<hActiveObject)
	ldi (hl),a

;;
; Reset the contents of w2LinkWalkPath to equal Link's position.
;
resetFollowingLinkPath:
	push de
	ld a,(w1Link.direction)
	ld c,a
	ld a,(w1Link.yh)
	ld d,a
	ld a,(w1Link.xh)
	ld e,a

	ld a,:w2LinkWalkPath
	ld ($ff00+R_SVBK),a

	; Fill each entry in w2LinkWalkPath with Link's position/direction
	ld hl,w2LinkWalkPath
	ld a,$10
--
	ld (hl),c
	inc l
	ld (hl),d
	inc l
	ld (hl),e
	inc l
	dec a
	jr nz,--

	; Set both to 0
	ld (wLinkPathIndex),a
	ld ($ff00+R_SVBK),a

	; Initialize object position
	ld a,(wFollowingLinkObjectType)
	add Object.yh
	ld l,a
	ld a,(wFollowingLinkObject)
	ld h,a
	ld (hl),d
	inc l
	inc l
	ld (hl),e

	pop de
	ret

;;
; Updates the "FollowingLinkObject" and w2LinkWalkPath if necessary.
;
checkUpdateFollowingLinkObject:
	ld a,(wFollowingLinkObject)
	or a
	ret z

	call @update
	xor a
	ld ($ff00+R_SVBK),a
	ret

@update:
	; Reset everything if [wLinkPathIndex] >= $80
	ld a,(wLinkPathIndex)
	ld b,a
	add a
	jr c,resetFollowingLinkPath

	; hl = w2LinkWalkPath + [wLinkPathIndex]*3
	add b
	ld hl,w2LinkWalkPath
	rst_addAToHl

	ld a,(w1Link.direction)
	ld c,a
	ld a,(w1Link.yh)
	ld d,a
	ld a,(w1Link.xh)
	ld e,a

	ld a,:w2LinkWalkPath
	ld ($ff00+R_SVBK),a

	; Return if Link's position/direction has not changed
	ldi a,(hl)
	cp c
	jr nz,+
	ldi a,(hl)
	cp d
	jr nz,+
	ldi a,(hl)
	cp e
	ret z
+
	; Increment wLinkPathIndex
	ld a,(wLinkPathIndex)
	inc a
	and $0f
	ld (wLinkPathIndex),a

	; hl = w2LinkWalkPath + [wLinkPathIndex]*3
	ld b,a
	add a
	add b
	ld hl,w2LinkWalkPath
	rst_addAToHl

	; Load recorded position values into c/d/e while updating them with Link's new
	; position
	ld a,c
	ld c,(hl)
	ldi (hl),a
	ld a,d
	ld d,(hl)
	ldi (hl),a
	ld a,e
	ld e,(hl)
	ldi (hl),a

	xor a
	ld ($ff00+R_SVBK),a

	; Update object's position
	ld a,(wFollowingLinkObject)
	ld h,a
	ld a,(wFollowingLinkObjectType)
	add Object.direction
	ld l,a
	ld (hl),c
	inc l
	inc l
	inc l
	ld (hl),d
	inc l
	inc l
	ld (hl),e
	ret

;;
; Clears memory from cc5c-cce9, initializes wLinkObjectIndex, focuses camera on Link...
;
clearMemoryOnScreenReload:
	ld hl,wLinkInAir
	ld b,wcce9-wLinkInAir
	call clearMemory

	; Initialize wLinkObjectIndex (set it to >w1Link unless it's already set to
	; >w1Companion).
	ld hl,wLinkObjectIndex
	ld a,>w1Companion
	cp (hl)
	jr z,+
	dec a
	ld (hl),a
+
	call setCameraFocusedObjectToLink
	call clearItems
	jr ++

;;
func_49c9:
	ld hl,wDisabledObjects
	ld b,wcce1-wDisabledObjects
	call clearMemory
++
	ld a,$ff
	ld (wccaa),a
	ret

;;
; Set the lower 2 bits of each object's Object.enabled to 2.
setObjectsEnabledTo2:
	call setInteractionsEnabledTo2
	call setEnemiesEnabledTo2
	call setPartsEnabledTo2
	call setItemsEnabledTo2
	ld hl,$d000
	ld c,$d2
	jr setObjectsEnabledTo2_hlpr

;;
setItemsEnabledTo2:
	ld hl,(FIRST_ITEM_INDEX<<8) + $00
	ld c,$e0
	jr setObjectsEnabledTo2_hlpr
;;
setInteractionsEnabledTo2:
	ld hl,$d040
	ld c,$e0
	jr setObjectsEnabledTo2_hlpr
;;
setEnemiesEnabledTo2:
	ld hl,$d080
	ld c,$e0
	jr setObjectsEnabledTo2_hlpr
;;
setPartsEnabledTo2:
	ld hl,$d0c0
	ld c,$e0

setObjectsEnabledTo2_hlpr:
	ld a,(hl)
	and $03
	cp $01
	jr nz,+

	ld a,(hl)
	and $fc
	or $02
	ld (hl),a
+
	inc h
	ld a,h
	cp c
	jr c,setObjectsEnabledTo2_hlpr
	ret

;;
clearObjectsWithEnabled2:
	call clearInteractionsWithEnabled2
	call clearEnemiesWithEnabled2
	call clearPartsWithEnabled2
	call clearItemsWithEnabled2
	ld hl,$d000
	ld c,$d2
	jr clearObjectsWithEnabled2_hlpr

;;
clearItemsWithEnabled2:
	ld hl,(FIRST_ITEM_INDEX<<8) + $00
	ld c,$e0
	jr clearObjectsWithEnabled2_hlpr

;;
clearInteractionsWithEnabled2:
	ld hl,$d040
	ld c,$e0
	jr clearObjectsWithEnabled2_hlpr

;;
clearEnemiesWithEnabled2:
	ld hl,$d080
	ld c,$e0
	jr clearObjectsWithEnabled2_hlpr

;;
clearPartsWithEnabled2:
	ld hl,$d0c0
	ld c,$e0

clearObjectsWithEnabled2_hlpr:
	ld a,(hl)
	and $03
	cp $02
	jr nz,+

	push hl
	ld b,$40
	call clearMemory
	pop hl
+
	inc h
	ld a,h
	cp c
	jr c,clearObjectsWithEnabled2_hlpr
	ret
;;
playCompassSoundIfKeyInRoom:
	ld a,(wMenuDisabled)
	or a
	ret nz
	ld a,(wDungeonIndex)
	cp $ff
	ret z

	ld hl,wDungeonCompasses
	call checkFlag
	ret z
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	ret nz

.ifdef ROM_SEASONS
	; Hardcoded to play compass sound in d5 boss key room
	ld a,(wActiveGroup)
	cp $06
	jr nz,+
	ld a,(wActiveRoom)
	cp $8b
	jr z,@playSound
+
.endif

	ld a,(wDungeonRoomProperties)
	and $70
	cp (DUNGEONROOMPROPERTY_CHEST | DUNGEONROOMPROPERTY_KEY)
	jr z,@playSound

	cp DUNGEONROOMPROPERTY_KEY
	ret nz

@playSound:
	ld a,SND_COMPASS
	jp playSound

updateLinkBeingShocked:
	ld de,wIsLinkBeingShocked
	ld a,(de)
	rst_jumpTable
	.dw @val00
	.dw @val01
	.dw @val02

@val00:
	ret

@val01:
	ld h,d
	ld l,e
	inc (hl)
	inc l
	ld (hl),$2d
	ld a,SND_SHOCK
	call playSound
	ld hl,wDisabledObjects
	ld a,$21
	or (hl)
	ld (hl),a
	ld hl,wDisableLinkCollisionsAndMenu
	set 0,(hl)
	jp copyW2TilesetBgPalettesToW4PaletteData

@val02:
	ld h,d
	ld l,e
	inc l
	dec (hl)
	jr z,++

	ld a,(hl)
	and $07
	ret nz

	bit 3,(hl)
	jp z,copyW4PaletteDataToW2TilesetBgPalettes

	ld a,$08
	call setScreenShakeCounter

	ld a,PALH_0c
	jp loadPaletteHeader
++
	xor a
	ldd (hl),a
	ld (hl),a
	ld hl,wDisabledObjects
	ld a,$de
	and (hl)
	ld (hl),a
	ld hl,wDisableLinkCollisionsAndMenu
	res 0,(hl)
	jp copyW4PaletteDataToW2TilesetBgPalettes

;;
; This is called when Link falls into a hole tile that goes a level down.
initiateFallDownHoleWarp:
	ld a,(wDungeonFloor)
	dec a
	ld (wDungeonFloor),a

	call getActiveRoomFromDungeonMapPosition
	ld (wWarpDestRoom),a

	call objectGetShortPosition
	ld (wWarpDestPos),a

	ld a,(wActiveGroup)
	or $80
	ld (wWarpDestGroup),a
	ld a,TRANSITION_DEST_FALL
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ret

;;
; CUTSCENE_WARP_TO_TWINROVA_FIGHT
cutscene17:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call reloadTileMap
	ld a,$01
	ld (wCutsceneState),a
	ld hl,(FIRST_DYNAMIC_INTERACTION_INDEX<<8) + Interaction.enabled
--
	ld l,Interaction.enabled
	ldi a,(hl)
	or a
	jr z,+

	ldi a,(hl)
.ifdef ROM_AGES
	cp INTERACID_ZELDA
.else
	cp INTERACID_S_ZELDA
.endif
	jr z,++
+
	inc h
	ld a,h
	cp $e0
	jr c,--
++
	ld a,h
	ld (wGenericCutscene.cbb5),a
	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	xor a
	ld (wGenericCutscene.cbb7),a
	call initWaveScrollValuesForEverySecondLine
	ld a,SND_ENDLESS
	jp playSound

@state1:
	ld a,$02
	call loadBigBufferScrollValues
	ld hl,wGenericCutscene.cbb7
	inc (hl)
	ld a,(hl)
	jp nz,initWaveScrollValuesForEverySecondLine

	ld a,$02
	ld (wCutsceneState),a
	ld a,$1e
	ld (wGenericCutscene.cbb3),a
	ret

@state2:
	call updateInteractionsAndDrawAllSprites
	ld a,$02
	call loadBigBufferScrollValues
	ld a,(wGenericCutscene.cbb4)
	inc a
	and $03
	ld (wGenericCutscene.cbb4),a
	ret nz

	ld a,(wGenericCutscene.cbb5)
	ld h,a
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ld a,(wGenericCutscene.cbb3)
	dec a
	ld (wGenericCutscene.cbb3),a
	ret nz

	res 7,(hl)
	ld a,$14
	ld (wGenericCutscene.cbb4),a
	ld a,$05
	ld (wGenericCutscene.cbb3),a
	ld a,$03
	ld (wCutsceneState),a

@state3:
	call updateInteractionsAndDrawAllSprites
	ld a,$02
	call loadBigBufferScrollValues
	ld hl,wGenericCutscene.cbb4
	dec (hl)
	ret nz

	ld (hl),$14
	call fadeoutToWhite
	ld hl,wGenericCutscene.cbb3
	dec (hl)
	ret nz

	ld a,$04
	ld (wCutsceneState),a
	ret

@state4:
	ld a,$02
	call loadBigBufferScrollValues
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld hl,@warpDestVariables
	call setWarpDestVariables
	xor a
	ld (wcc50),a
	ld (wMenuDisabled),a
	ld a,CUTSCENE_03
	ld (wCutsceneIndex),a
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$01
	ld (wScrollMode),a
	ld a,SNDCTRL_STOPSFX
	call playSound
	ld a,SND_FADEOUT
	jp playSound


@warpDestVariables:
	m_HardcodedWarpA ROOM_TWINROVA_FIGHT, $05, $77, $00

;;
; Calls initWaveScrollValues, then sets every other line to have a normal scroll value.
;
; @param	a	Amplitude
initWaveScrollValuesForEverySecondLine:
	call initWaveScrollValues
	ld a,:w2WaveScrollValues
	ld ($ff00+R_SVBK),a
	ld hl,w2WaveScrollValues
	ld b,$80
-
	ldh a,(<hCameraX)
	ldi (hl),a
	inc hl
	dec b
	jr nz,-

	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
; CUTSCENE_15
cutscene15:
	call @update
	call updateStatusBar
	jp updateSpecialObjectsAndInteractions

@update:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

;;
; Unused?
@func_4c03:
	ld hl,wGenericCutscene.cbb4
	dec (hl)
	ret nz

	ld (hl),$1e
	ret

;;
@incTmpcbb3:
	ld hl,wGenericCutscene.cbb3
	inc (hl)
	ret


@state0:
	call reloadTileMap
	ld a,CUTSCENE_INGAME
	ld (wCutsceneState),a
	xor a
	ld (wGenericCutscene.cbb3),a
	ld (wGenericCutscene.cbb4),a
	ld (wGenericCutscene.cbb5),a
	ld (wGenericCutscene.cbb6),a
	ret


@state1:
	ld a,(wGenericCutscene.cbb3)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,$04
	ld (wGenericCutscene.cbbb),a
	xor a
	ld (wGenericCutscene.cbbc),a
	call @@initWaveScrollValuesInverted
	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	jp @incTmpcbb3

;;
; Calls initWaveScrollValues, then inverts every other line.
;
; @param	a	Amplitude
@@initWaveScrollValuesInverted:
	call initWaveScrollValues
	ld a,:w2WaveScrollValues
	ld ($ff00+R_SVBK),a
	ld hl,w2WaveScrollValues
	ld b,$80
-
	ld a,(hl)
	cpl
	inc a
	ldi (hl),a
	inc hl
	dec b
	jr nz,-

	xor a
	ld ($ff00+R_SVBK),a
	ret

@@substate1:
	ld a,(wGenericCutscene.cbbd)
	ld b,a
	ld a,(wGenericCutscene.cbbc)
	cp b
	ld (wGenericCutscene.cbbd),a
	call nz,@@initWaveScrollValuesInverted
	ld a,(wGenericCutscene.cbbb)
	jp loadBigBufferScrollValues

@@substate2:
	call disableLcd
	call clearOam
	xor a
	ld ($ff00+R_SVBK),a

	; Clear all objects except Link
	ld hl,$d040
	ld bc,$e000-$d040
	call clearMemoryBc

	call clearScreenVariables
	call clearMemoryOnScreenReload
	call stopTextThread
	call applyWarpDest
	call loadTilesetData
	call loadTilesetGraphics
	call loadDungeonLayout
	call func_131f
	call clearEnemiesKilledList
	call func_5c6b
	ld a,(wActiveGroup)
	cp $03
	jr nz,++

	xor a
	ld (wMinimapGroup),a
	ld a,(wActiveRoom)
	cp $ab
	ld a,$f7
	jr z,+
	ld a,$04
+
	ld (wMinimapRoom),a
++
	call loadCommonGraphics
	callab updateInteractions
	ld a,$02
	call loadGfxRegisterStateIndex
	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$f0
	ld (wGfxRegs2.SCY),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	ld hl,wCutsceneState
	inc (hl)
	xor a
	ld (wGenericCutscene.cbb3),a
	ld (wLinkForceState),a
	ld a,$08
	ld (wWarpTransition),a
	ld a,$81
	ld (wDisabledObjects),a
	ret


@state2:
	ld a,(wGenericCutscene.cbb3)
	rst_jumpTable
	.dw @state1@substate1
	.dw @@substate1

@@substate1:
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$c7
	ld (wGfxRegs2.LYC),a
	xor a
	ld (wCutsceneIndex),a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,$01
	ld (wScrollMode),a
	ld a,SNDCTRL_STOPSFX
	jp playSound

;;
; CUTSCENE_FLAMES_FLICKERING
cutscene18:
	ld c,$00
	jr ++

;;
; CUTSCENE_TWINROVA_SACRIFICE
cutscene19:
	ld c,$01
++
	callab bank3Cutscenes.twinrovaCutsceneCaller
	call func_1613
	jp updateAllObjects

.ENDS

 m_section_free Bank_1_Data_1 NAMESPACE bank1

.include "build/data/dungeonData.s"
.include "data/dungeonProperties.s"
.include "build/data/dungeonLayouts.s"

.ends

 m_section_free Bank_1_Code_2 NAMESPACE bank1

;;
; Load 8 bytes into wDungeonMapData and up to $100 bytes into w2DungeonLayout.
loadDungeonLayout_b01:
	ld a,$02
	ld ($ff00+R_SVBK),a
	call clearDungeonLayout
	ld a,(wDungeonIndex)
	ld hl, dungeonDataTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld b,$08
	ld de, wDungeonMapData
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz, -

	call findActiveRoomInDungeonLayout
	xor a
	call getFirstDungeonLayoutAddress
	ld de, w2DungeonLayout
	ld a,(wDungeonNumFloors)
	ld c,a
@nextFloor:
	ld b,$40
@nextByte:
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,@nextByte
	dec c
	jr nz,@nextFloor

	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_SIDESCROLL,a
	jr nz,@end

	ld a,(wDungeonFloor)
	ld hl,bitTable
	add l
	ld l,a
	ld b,(hl)
	ld a,(wDungeonIndex)
	ld hl,wDungeonVisitedFloors
	rst_addAToHl
	ld a,(hl)
	or b
	ld (hl),a
@end:
	xor a
	ld ($ff00+R_SVBK),a
	jp setVisitedRoomFlag

;;
clearDungeonLayout:
	ld hl,w2DungeonLayout
	ld bc,$0200
	jp clearMemoryBc


.ifdef ROM_AGES
;;
findActiveRoomInDungeonLayoutWithPointlessBankSwitch:
	ld a,:CADDR
	setrombank
.endif

;;
; Finds the active room in the dungeon layout and sets wDungeonFloor and
; wDungeonMapPosition accordingly.
findActiveRoomInDungeonLayout:
	xor a
	call getFirstDungeonLayoutAddress
	ld a,(wActiveRoom)
	ld c,$00
--
	ld b,$40
-
	cp (hl)
	jr z, +
	inc hl
	dec b
	jr nz, -
	inc c
	jr --
+
	ld a,c
	ld (wDungeonFloor),a
	ld a,$40
	sub b
	ld (wDungeonMapPosition),a
	ret

;;
; Get the address of the layout data for the first floor
getFirstDungeonLayoutAddress:
	ld c,a
	ld a,(wDungeonFirstLayout)
	add c
	call multiplyABy16
	ld hl,dungeonLayoutDataStart
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc
	ret

;;
paletteFadeHandler:
	ld a,(wPaletteThread_mode)
	rst_jumpTable
	.dw paletteFadeHandler00
	.dw paletteFadeHandler01
	.dw paletteFadeHandler02
	.dw paletteFadeHandler03
	.dw paletteFadeHandler04
	.dw paletteFadeHandler05
	.dw paletteFadeHandler06
	.dw paletteFadeHandler07
	.dw paletteFadeHandler08
	.dw paletteFadeHandler09
	.dw paletteFadeHandler0a
	.dw paletteFadeHandler0b
	.dw paletteFadeHandler0c

.ifdef ROM_AGES
	.dw paletteFadeHandler0d
	.dw paletteFadeHandler0e
.endif


;;
paletteFadeHandler09:
	call paletteThread_decCounter
	ret nz

;;
; Fade out to white
paletteFadeHandler01:
	ld a,$1f
	ldh (<hFF8B),a

	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_fadeOffset)
	add c
	cp $20
	jp nc,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a

	; Fall through

;;
; Updates the "fading" palettes based on the "base" palettes, and copies over
; "wDirtyFadeBgPalettes" etc. to "hDirtyFadeBgPalettes", slating them for updating?
;
; @param	c	Value to add to each color component
; @param	hFF8B	Intensity of a color component after overflowing ($00 or $1f?)
updateFadingPalettes:
	call paletteThread_calculateFadingPalettes

	ld hl,wDirtyFadeBgPalettes
	ldh a,(<hDirtyBgPalettes)
	or (hl)
	ldh (<hDirtyBgPalettes),a
	inc hl
	ldh a,(<hDirtySprPalettes)
	or (hl)
	ldh (<hDirtySprPalettes),a
	inc hl
	ldi a,(hl)
	ldh (<hBgPaletteSources),a
	ld a,(hl)
	ldh (<hSprPaletteSources),a
;;
paletteFadeHandler00:
	ret

;;
paletteFadeHandler0a:
	call paletteThread_decCounter
	ret nz

;;
; Fade in from white
paletteFadeHandler02:
	ld a,$1f
	ldh (<hFF8B),a
	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_fadeOffset)
	sub c
	jr c,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jr updateFadingPalettes

;;
paletteFadeHandler0b:
	call paletteThread_decCounter
	ret nz

;;
; Fade out to black
paletteFadeHandler03:
	xor a
	ldh (<hFF8B),a
	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_fadeOffset)
	sub c
	cp $e0
	jr c,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jr updateFadingPalettes

;;
paletteFadeHandler0c:
	call paletteThread_decCounter
	ret nz

;;
; Fade in from black
paletteFadeHandler04:
	xor a
	ldh (<hFF8B),a
	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_fadeOffset)
	add c
	jr c,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jp updateFadingPalettes


.ifdef ROM_AGES
;;
; @param	b	"inverted" value for wPaletteThread_fadeOffset?
paletteThread_setFadeOffsetAndStop:
	ld a,b
	sub $1f
	ld (wPaletteThread_fadeOffset),a
.endif

;;
; Clears some variables and stops operation (goes to mode 0).
paletteThread_stop:
	xor a
	ld (wPaletteThread_updateRate),a
	ld (wPaletteThread_mode),a
	jp clearPaletteFadeVariables

;;
; Like above, but also marks all palettes as dirty.
paletteThread_refreshPalettesAndStop:
	xor a
	ld (wPaletteThread_updateRate),a
	ld (wPaletteThread_mode),a
	jp clearPaletteFadeVariablesAndRefreshPalettes


.ifdef ROM_AGES
;;
paletteFadeHandler0d:
	call paletteThread_decCounter
	ret nz
.endif

;;
; Fade out to black, stop eventually depending on wPaletteThread_parameter
paletteFadeHandler05:

.ifdef ROM_AGES
	xor a
	ldh (<hFF8B),a
	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_parameter)
	dec a
	ld b,a
	ld a,(wPaletteThread_fadeOffset)
	sub c
	cp b
	jr z,paletteThread_stop
	jr c,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jp updateFadingPalettes

.else ; ROM_SEASONS

	xor a
	ldh (<hFF8B),a
	ld a,(wPaletteThread_parameter)
	dec a
	ld b,a
	ld a,(wPaletteThread_fadeOffset)
	dec a
	cp b
	jr z,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jp updateFadingPalettes
.endif


.ifdef ROM_AGES
;;
paletteFadeHandler0e:
	call paletteThread_decCounter
	ret nz
.endif

;;
; Fade in from black, stop eventually depending on wPaletteThread_parameter
paletteFadeHandler06:

.ifdef ROM_AGES
	xor a
	ldh (<hFF8B),a
	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_parameter)
	add $1f
	ld b,a
	ld a,(wPaletteThread_fadeOffset)
	add $1f
	add c
	cp b
	jr z,paletteThread_stop
	jp nc,paletteThread_setFadeOffsetAndStop

	sub $1f
	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jp updateFadingPalettes

.else ; ROM_SEASONS

	xor a
	ldh (<hFF8B),a
	ld a,(wPaletteThread_parameter)
	inc a
	ld b,a
	ld a,(wPaletteThread_fadeOffset)
	inc a
	cp b
	jr z,paletteThread_stop

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jp updateFadingPalettes

.endif


;;
; Fade in from white for a dark room
paletteFadeHandler07:
	ld a,$1f
	ldh (<hFF8B),a
	ld a,(wPaletteThread_speed)
	ld c,a
	ld a,(wPaletteThread_fadeOffset)
	sub c
	jr c,+

	ld (wPaletteThread_fadeOffset),a
	ld c,a
	jp updateFadingPalettes
+
	; The room's completely faded in now

	ld a,$ff
	ldh (<hDirtyBgPalettes),a
	ldh (<hDirtySprPalettes),a

	; Check if the room should be darkened
	ld a,(wPaletteThread_parameter)
	or a
	jr z,paletteThread_refreshPalettesAndStop

	ld b,a
	xor a
	ld (wPaletteThread_parameter),a
	ld a,b
	cp $f0
	jp z,darkenRoom
	jp darkenRoomLightly

;;
; Fade between two palettes
paletteFadeHandler08:
	ld hl,wPaletteThread_fadeOffset
	dec (hl)
	jr z,@stop

@seasonsFunc_01_5816:
	; Get bits 1-4 in 'b'
	ld a,(hl)
	rrca
	and $0f
	ld b,a
	swap a
	ldh (<hFF91),a

	ld a,$10
	sub b
	swap a
	ldh (<hFF90),a
	ld a,(hl)
	rrca
	jp c,paletteThread_mixBG234Palettes

	call paletteThread_mixBG567Palettes

	; Mark BG palettes 2-7 as needing refresh
	ldh a,(<hDirtyBgPalettes)
	or $fc
	ldh (<hDirtyBgPalettes),a
	ld a,$fc
	ldh (<hBgPaletteSources),a
	ret

@stop:
	jp paletteThread_stop

;;
; Adds the given value to each color in w2TilesetBgPalettes/w2TilesetSprPalettes, and stores the
; result into w2FadingBgPalettes/w2FadingSprPalettes.
;
; @param	c	Value to add to each color component
; @param	hFF8B	Intensity of a color component after overflowing ($00 or $1f)
paletteThread_calculateFadingPalettes:
	ld hl,w2TilesetBgPalettes
	ld b,$40

@nextColor:
	; Extract green color component
	ld e,(hl)
	inc l
	ld a,(hl)
	sla e
	rla
	rl e
	rla
	rl e
	rla
	and $1f

	; Add given value, check if it overflowed
	add c
	bit 5,a
	jr z,+
	ldh a,(<hFF8B)
+
	; Encode new green component into 'de'
	ld e,$00
	srl a
	rr e
	rra
	rr e
	rra
	rr e
	ld d,a

	; Extract blue color component
	ldd a,(hl)
	rra
	rra
	and $1f

	; Add given value, check if it overflowed
	add c
	bit 5,a
	jr z,+
	ldh a,(<hFF8B)
+
	; Encode new blue component into 'de'
	rlca
	rlca
	or d
	ld d,a

	; Extract red color component
	ld a,(hl)
	and $1f

	; Add given value, check if it overflowed
	add c
	bit 5,a
	jr z,+
	ldh a,(<hFF8B)
+
	; Store new color value into w2FadingBgPalettes/w2FadingSprPalettes
	or e
	inc h
	ldi (hl),a
	ld (hl),d
	inc l
	dec h

	dec b
	jr nz,@nextColor
	ret

;;
; Mix BG2-4 palettes between w2ColorComponentBuffer1 and 2. Results go to
; w2FadingBgPalettes.
;
; Game alternates between calling this and the below function when fading between
; palettes.
;
paletteThread_mixBG234Palettes:
	ld hl,w2TilesetBgPalettes+2*8
	ld e,<w2ColorComponentBuffer1+$00
	ld b,3*4
	jr ++

;;
; Mix BG5-7 palettes.
;
paletteThread_mixBG567Palettes:
	ld hl,w2TilesetBgPalettes+5*8
	ld e,<w2ColorComponentBuffer1+$24
	ld b,3*4
++
	ld a,:w2TilesetBgPalettes
	ld ($ff00+R_SVBK),a

@nextColor:
	push bc
	push hl

	; Mix the two colors; result is stored in hl = value<<4, so we still need to
	; extract the final value we want
	call @mixColors
	inc e
	swap l
	ld a,l
	and $0f
	ld l,a
	ld a,h
	swap a
	or l
	ldh (<hFF8B),a

	; Mix the next component
	call @mixColors
	inc e
	swap l
	ld a,l
	and $0f
	ld l,a
	ld a,h
	swap a
	or l
	ldh (<hFF8D),a

	; Mix the next component
	call @mixColors
	inc e
	swap l
	ld a,l
	and $0f
	ld l,a
	ld a,h
	swap a
	or l
	ldh (<hFF8C),a

	; Write the color components to the corresponding color
	pop hl
	call @writeToFadingBgPalettes

	pop bc
	dec b
	jr nz,@nextColor

	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
; Mixes two color components in w2ColorComponentBuffer1 and w2ColorComponentBuffer2.
;
; The "weighting" values are put into h, and l is set to 0. hl is then added to itself
; repeatedly. Every time hl overflows, the value of the color component is added to hl as
; well. This will happen up to 4 times. So, higher weighting values will cause this
; overflow to happen more often. In the end, the weighting for the color component is
; stored in bits 4-11 of hl.
;
; @param	e	Low byte of address in w2ColorComponentBuffer1/2
; @param	hFF91	Weighting for w2ColorComponentBuffer1 ($00-$f0, upper nibble)
; @param	hFF90	Weighting for w2ColorComponentBuffer2 ($00-$f0, upper nibble)
; @param[out]	hl	Shift this value right by 4 to get the final intensity to use
@mixColors:
	; Calculate intensity to add for first component
	ldh a,(<hFF91)
	ld h,a
	ld d,>w2ColorComponentBuffer1
	ld a,(de)
	ld c,a

	ld b,$00
	ld l,b
	ld a,$04
--
	add hl,hl
	jr nc,+
	add hl,bc
+
	dec a
	jr nz,--

	; Calculate intensity to add for second component
	push hl
	ldh a,(<hFF90)
	ld h,a
	ld d,>w2ColorComponentBuffer2
	ld a,(de)
	ld c,a
	ld b,$00
	ld l,b
	ld a,$04
--
	add hl,hl
	jr nc,+
	add hl,bc
+
	dec a
	jr nz,--

	; Add the two intensities together
	pop bc
	add hl,bc
	ret

;;
; Takes color components (stored in hFF8B, hFF8C, hFF8D) and writes them to
; the color in w2FadingBgPalettes.
@writeToFadingBgPalettes:
	inc h
	ldh a,(<hFF8B)
	ld c,$00
	srl a
	rr c
	rra
	rr c
	rra
	rr c
	ld b,a
	ldh a,(<hFF8C)
	or c
	ldi (hl),a
	ldh a,(<hFF8D)
	rlca
	rlca
	or b
	ldi (hl),a
	dec h
	ret

;;
checkLockBG7Color3ToBlack:
	ld a,(wLockBG7Color3ToBlack)
	rst_jumpTable
	.dw @thing0
	.dw @thing1

@thing1:
	xor a
	ld (w2FadingBgPalettes+$3e),a
	ld (w2FadingBgPalettes+$3f),a
@thing0:
	ret

;;
; @param[out]	zflag	Set if wPaletteThread_counter reached 0
paletteThread_decCounter:
	ld hl,wPaletteThread_counter
	dec (hl)
	ret nz
	ld a,(wPaletteThread_counterRefill)
	ld (wPaletteThread_counter),a
	ret

;;
func_593a:
	call updateLinkLocalRespawnPosition
	call loadCommonGraphics
	ld a,$02
	jp loadGfxRegisterStateIndex

;;
checkUpdateDungeonMinimap:

.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_LARGE_INDOORS,a
	ret nz

	bit TILESETFLAG_BIT_SIDESCROLL,a
	ret nz

	bit TILESETFLAG_BIT_OUTDOORS,a
	jr nz,@setMinimapRoom

	bit TILESETFLAG_BIT_DUNGEON,a
	ret z

.else ; ROM_SEASONS

	ld a,(wActiveGroup)
	cp $03
	jr c,@setMinimapRoom
	bit 1,a
	ret nz
	ld a,(wDungeonIndex)
	inc a
	ret z
.endif

@setMinimapRoom:
	ld hl,wMinimapDungeonFloor
	ld a,(wDungeonFloor)
	ldd (hl),a ; wMinimapDungeonFloor
	ld a,(wDungeonMapPosition)
	ldd (hl),a ; wMinimapDungeonMapPosition
	ld a,(wActiveRoom)
	ldd (hl),a ; wMinimapRoom
	ld a,(wActiveGroup)
	ld c,(hl)  ; wMinimapGroup
	ld (hl),a
	ret

;;
; This function is called from the main thread.
; Runs the game for a frame.
runGameLogic:
	ld a,(wGameState)
	rst_jumpTable
	.dw initializeGame
	.dw loadingRoom
	.dw standardGameState
	.dw linkSummonedCutscene

;;
; Clears a lot of memory, loads common palette header $0f,
initializeGame:
	ld hl,wOamEnd
	ld bc,$d000-wOamEnd
	call clearMemoryBc
	call clearScreenVariablesAndWramBank1
	call initializeSeedTreeRefillData
	ld a,PALH_0f
	call loadPaletteHeader

	; This code might be checking if you saved in the advance shop?
	ldh a,(<hGameboyType)
	rlca
	jr c,+++
@notGbaMode:
	ld hl,wDeathRespawnBuffer.group
	ldi a,(hl)
	ld l,(hl)
	ld h,a

.ifdef ROM_AGES
	ld bc,$03fe
.else
	ld bc,$03af
.endif
	call compareHlToBc
	jr z,@fixRespawnForGbc

.ifdef ROM_AGES
	ld bc,$0158
.else
	ld bc,$00c5
.endif
	call compareHlToBc
	jr nz,+++

	ld a,(wDeathRespawnBuffer.x)
	cp $40
	jr c,+++
@fixRespawnForGbc:
	ld c,$03
	call loadDeathRespawnBufferPreset
+++
	ld a,(wFileIsLinkedGame)
	ld (wIsLinkedGame),a
	ld hl,wDeathRespawnBuffer
	ldi a,(hl)
	ld (wActiveGroup),a
	ldi a,(hl)
	ld (wActiveRoom),a
	ldi a,(hl)
	ld (wRoomStateModifier),a
	ld a,$03
	ld (w1Link.enabled),a
	ldi a,(hl)
	ld (w1Link.direction),a
	ld (wLinkLocalRespawnDir),a
	ldi a,(hl)
	ld (w1Link.yh),a
	ld (wLinkLocalRespawnY),a
	ldi a,(hl)
	ld (w1Link.xh),a
	ld (wLinkLocalRespawnX),a
	ldi a,(hl)
	ld (wRememberedCompanionId),a
	ldi a,(hl)
	ld (wRememberedCompanionGroup),a
	ldi a,(hl)
	ld (wRememberedCompanionRoom),a
	inc l
	inc l
	ldi a,(hl)
	ld (wRememberedCompanionY),a
	ldi a,(hl)
	ld (wRememberedCompanionX),a

	; Reset health if it's zero...
	ld l,<wLinkHealth
	ld a,(hl)
	or a
	jr z,@resetHealth

	; ...or negative.
	bit 7,a
	jr z,++

@resetHealth:
	; Get wLinkMaxHealth
	inc l
	ldd a,(hl)
	; Set health to wLinkMaxHealth/2 (or 3 hearts minumum)
	srl a
	and $fc
	cp $0c
	jr nc,++
	ld a,$0c
++
	ld (hl),a
	ld (wDisplayedHearts),a
	ld a,$88
	ld (w1Link.invincibilityCounter),a

.ifdef ROM_AGES
	ld l,<wNumRupees
	ldi a,(hl)
	ld (wDisplayedRupees),a
	ld a,(hl)
	ld (wDisplayedRupees+1),a
	call loadScreenMusicAndSetRoomPack

	ld a,$ff
	ld (wActiveMusic),a
	ld (wcc05),a

.else ; ROM_SEASONS

	ld de,w1Link.yh
	call getShortPositionFromDE
	ld (wWarpDestPos),a
	call loadScreenMusicAndSetRoomPack

	ld a,$ff
	ld (wActiveMusic),a
.endif

	ld a,GLOBALFLAG_PREGAME_INTRO_DONE
	call checkGlobalFlag
	jr nz,func_5a60

	ld a,GLOBALFLAG_3d
	call checkGlobalFlag
	jr nz,@summonLinkCutscene

	ld a,$02
	ld (wGameState),a
	ld a,CUTSCENE_PREGAME_INTRO
	ld (wCutsceneIndex),a
	jp cutscene0d

; The first time the game is opened, this cutscene plays
@summonLinkCutscene:
	ld a,$03
	ld (wGameState),a
	xor a
	ld (w1Link.enabled),a
	ret

;;
loadingRoom:
	call clearScreenVariablesAndWramBank1
	call clearStaticObjects
	call stopTextThread
	ld a,$ff
	ld (wActiveMusic),a
	call applyWarpDest

;;
func_5a60:
	call clearOam
	call initializeVramMaps
	call clearMemoryOnScreenReload
	call clearScreenVariables
	call clearEnemiesKilledList
	call clearAllParentItems
	call dropLinkHeldItem
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics

.ifdef ROM_AGES
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
.endif
	call loadDungeonLayout

	ld a,$02
	ld (wGameState),a
	xor a
	ld (wCutsceneIndex),a
	ld (wWarpTransition2),a
	ld (wSwitchState),a
	ld (wToggleBlocksState),a
	ld a,$02
	ld (wScrollMode),a
	call loadTilesetAndRoomLayout
	call loadRoomCollisions
	call generateVramTilesWithRoomChanges
	call setEnteredWarpPosition
	call initializeRoom
	call checkDisplayEraOrSeasonInfo
	call updateGrassAnimationModifier
	call checkPlayRoomMusic
	call checkUpdateDungeonMinimap
	jp func_593a

;;
standardGameState:
	ld a,(wLinkDeathTrigger)
	cp $ff
	jr nz,+

	ld a,SNDCTRL_SLOW_FADEOUT
	call playSound
	ld a,$e7
	ld (wLinkDeathTrigger),a
+
	ld a,(wGameOverScreenTrigger)
	or a
	jr z,+

	ld a,THREAD_0
	ld bc,thread_1b10
	call threadRestart
	jp stubThreadStart
+
	ld a,(wCutsceneIndex)
	rst_jumpTable

	.dw cutscene00
	.dw cutscene01
	.dw cutscene02
	.dw cutscene03
	.dw cutscene04
	.dw cutscene05
	.dw cutscene06
	.dw cutscene07
	.dw cutscene08
	.dw cutscene09
	.dw cutscene0a
	.dw cutscene0b
	.dw cutscene0c
	.dw cutscene0d
	.dw cutscene0e
	.dw cutscene0f
	.dw cutscene10
	.dw cutscene11
	.dw cutscene12
	.dw cutscene13
	.dw cutscene14
	.dw cutscene15
	.dw cutscene16
	.dw cutscene17
	.dw cutscene18
	.dw cutscene19

.ifdef ROM_AGES
	.dw cutscene1a
	.dw cutscene1b
	.dw cutscene1c
	.dw cutscene1d
	.dw cutscene1e
	.dw cutscene1f
	.dw cutscene20
	.dw cutscene21
.endif


;;
; Cutscene 0 = not in a cutscene; loading a room
;
cutscene00:
	call updateStatusBar
	call updateAllObjects
	call func_1613
	ld a,(wScrollMode)
	cp $01
	ret nz
	call setInstrumentsDisabledCounterAndScrollMode
	xor a
	ld (wDisableLinkCollisionsAndMenu),a

.ifdef ROM_AGES
	ld a,(wcc05)
	bit 7,a
	jr z,+
	ld a,$ff
	ld (wcc05),a
+
.endif

	call clearObjectsWithEnabled2
	call refreshObjectGfx
	call setVisitedRoomFlag
	call checkUpdateDungeonMinimap
	ld a,CUTSCENE_INGAME
	ld (wCutsceneIndex),a
	call playCompassSoundIfKeyInRoom

.ifdef ROM_AGES
	call updateLastToggleBlocksState
	call checkInitUnderwaterWaves
.endif

	jp updateGrassAnimationModifier

;;
; Cutscene 1 = not in a cutscene; game running normally
;
cutscene01:
	call func_1613
	call updateLinkBeingShocked
	call updateMenus
	ret nz
	; Returns if a menu is being displayed

.ifdef ROM_AGES
	call updatePirateShip
	call updateAllObjects
	call checkUpdateUnderwaterWaves
	callab roomInitialization.func_02_7a3a

.else; ROM_SEASONS
	call updateAllObjects
.endif

	call updateStatusBar

.ifdef ROM_AGES
	call checkUpdateToggleBlocks
.endif

	ld a,(wCutsceneTrigger)
	or a
	jp nz,setCutsceneIndexIfCutsceneTriggerSet

	call func_60e9
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2

.ifdef ROM_SEASONS
	ld a,(wcc4c)
	or a
	jp nz,triggerFadeoutTransition
.endif

	call getNextActiveRoom
	jp nc,checkEnemyAndPartCollisionsIfTextInactive

.ifdef ROM_AGES
	call checkDisableUnderwaterWaves
.endif
	call updateSeedTreeRefillData
	ld a,$05
	call addToGashaMaturity
	call func_49c9
	call setObjectsEnabledTo2
	call loadScreenMusic
	call loadTilesetData

	call checkRoomPack
	jp nz,triggerFadeoutTransition

.ifdef ROM_SEASONS
	call checkPlayRoomMusic
.endif
	ld a,(wActiveRoom)
	ld (wLoadingRoom),a
	ld a,$08
	ld (wScrollMode),a
	lda CUTSCENE_LOADING_ROOM
	ld (wCutsceneIndex),a
	call loadTilesetAndRoomLayout
	call loadRoomCollisions
	call generateVramTilesWithRoomChanges

.ifdef ROM_AGES
	call initializeRoom
	jp checkPlayRoomMusic
.else
	jp initializeRoom
.endif


.ifdef ROM_SEASONS

;;
; CUTSCENE_TOGGLE_BLOCKS (does nothing in Seasons)
cutscene02:
	ret
.endif


;;
cutscene03:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call disableLcd
	call clearOam
	call clearScreenVariablesAndWramBank1
	call clearMemoryOnScreenReload
	call stopTextThread
	ld a,PALH_0f
	call loadPaletteHeader
	call applyWarpDest
	call loadTilesetData
	call loadTilesetGraphics
	call loadDungeonLayout
	call func_131f
	call reloadObjectGfx
	ld a,LINK_STATE_WARPING
	ld (wLinkForceState),a
	ld a,(wWarpTransition)
	or $80
	ld (wWarpTransition),a
	ld a,(wDungeonIndex)
	cp $ff
	call z,clearEnemiesKilledList

func_5c18:

.ifdef ROM_AGES
	call checkUpdateDungeonMinimap
	ld hl,w1Companion.id
	ldd a,(hl)
	cp SPECIALOBJECTID_RAFT
	jr nz,++

	bit 1,(hl)
	jr nz,++

	ld b,$40
	call clearMemory
	ld a,LINK_OBJECT_INDEX
	ld (wLinkObjectIndex),a
++
.endif

	ld a,(wLinkGrabState2)
	and $f0
	cp $40
	jr z,+
	call dropLinkHeldItem
	call clearAllParentItems
+
.ifdef ROM_AGES
	ld a,(wLoadingRoomPack)
	ld (wRoomPack),a
.endif
	call setInstrumentsDisabledCounterAndScrollMode
	call setEnteredWarpPosition
	call calculateRoomEdge
	call initializeRoom
	call checkDisplayEraOrSeasonInfo
	call checkDarkenRoomAndClearPaletteFadeState
	call fadeinFromWhiteToRoom
	call checkPlayRoomMusic
	xor a
	ld (wCutsceneIndex),a
.ifdef ROM_AGES
	ld (wDontUpdateStatusBar),a
.endif
	call func_593a
	jp resetCamera

;;
func_5c6b:
	call setEnteredWarpPosition
	call calculateRoomEdge
	call initializeRoom
	call checkDisplayEraOrSeasonInfo
	call checkDarkenRoomAndClearPaletteFadeState
	ld a,$02
	call fadeinFromWhiteWithDelay
	jp resetCamera

;;
; Sets wEnteredWarpPosition to Link's position, which prevents him from activating a warp
; tile if he spawns on one.
setEnteredWarpPosition:
	ld de,w1Link.yh
	call getShortPositionFromDE
	ld (wEnteredWarpPosition),a
	ret

;;
cutscene04:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call disableLcd
	ld a,(wWarpDestGroup)
	and $07
	ld (wActiveGroup),a
	ld a,(wWarpDestRoom)
	ld (wActiveRoom),a
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.yh
	ld a,(wWarpDestPos)
	call setShortPosition
.ifdef ROM_AGES
	call disableLcd
	call clearOam
.endif
	jr ++

;;
cutscene05:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call disableLcd
	call clearOam
	call func_5cfe
++
	call setInteractionsEnabledTo2
	call clearObjectsWithEnabled2
	call clearItems
	call clearEnemies
	call clearParts
	call clearReservedInteraction0

.ifdef ROM_AGES
	ld a,(wScreenTransitionDirection)
	ldh (<hFF92),a
	call clearScreenVariables
	ldh a,(<hFF92)
	ld (wScreenTransitionDirection),a

.else; ROM_SEASONS
	call clearScreenVariables
.endif

	call clearMemoryOnScreenReload
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	ld de,w1Link.yh
	call getShortPositionFromDE
	ld (wWarpDestPos),a
	jp func_5c18

;;
func_5cfe:
	ld a,(wcc4c)
	or a
	jr z,+++

.ifdef ROM_SEASONS
	ld a,TILEINDEX_STUMP
	call findTileInRoom
	jr nz,@clearCompanion

	ld h,>wRoomCollisions
	dec l
	ld a,(hl)
	or a
	jr z,+
	inc l
	inc l
	ld a,(hl)
	or a
	jr z,+
	ld a,$0f
	add l
	ld l,a
	ld a,(hl)
	or a
	jr z,+
	ld a,l
	sub $20
	ld l,a
+
	ld c,l
	call convertShortToLongPosition_paramC
	ld a,b
	ld (wRememberedCompanionY),a
	ld a,c
	ld (wRememberedCompanionX),a
.endif

	ld a,(w1Companion.enabled)
	or a
	jr z,@clearCompanion
	ld a,(w1Companion.id)
	cp SPECIALOBJECTID_MINECART
	jr z,@clearCompanion
	cp SPECIALOBJECTID_MAPLE
	jr z,@clearCompanion

.ifdef ROM_SEASONS
	ld hl,w1Companion.state
	xor a
	ld (hl),a
	ld l,SpecialObject.var03
	ld (hl),a

	; Set Y/X
	ld a,b
	ld l,SpecialObject.yh
	ldi (hl),a
	inc l
	ld a,c
	ldi (hl),a

	; Clear Z
	inc l
	xor a
	ld (hl),a
	jr @end
.endif

+++
	call func_4493
	ld a,(wLinkGrabState2)
	and $f0
	cp $40
	jr z,@end

	ld a,(wLinkObjectIndex)
	bit 0,a
	jr nz,@end

@clearCompanion:
	xor a
	ld (wRememberedCompanionId),a

@end:
	xor a
	ld (wcc4c),a
	ret


.ifdef ROM_SEASONS

;;
; CUTSCENE_S_ONOX_FINAL_FORM
; Falling into final battle with onox (in the sidescrolling area)
cutscene13:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (wCutsceneState),a
	ld hl,wTmpcfc0+$8
	ld b,$18
	call clearMemory
	ld a,$07
	ld (wActiveGroup),a
	ld a,$ff
	ld (wActiveRoom),a
	ld a,$77
	ld (wDungeonMapPosition),a
	ld a,TILESETFLAG_SIDESCROLL | TILESETFLAG_DUNGEON
	ld (wTilesetFlags),a

	ld a,:w2DungeonLayout
	ld ($ff00+R_SVBK),a
	ld hl,w2DungeonLayout+$3f
	ld (hl),$ff
	xor a
	ld ($ff00+R_SVBK),a

	ld a,$04
	jp fadeoutToWhiteWithDelay

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$02
	ld (wCutsceneState),a

@state2:
	call func_1613
	call updateMenus
	ret nz
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2

	call seasonsFunc_331b
	call seasonsFunc_34a0
	call updateStatusBar
	ld a,(wCutsceneTrigger)
	or a
	jp z,checkEnemyAndPartCollisionsIfTextInactive
	jp setCutsceneIndexIfCutsceneTriggerSet

.endif

;;
; Seasons-only
func_5d31:
	call func_1613
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2

	call updateStatusBar
	jp updateAllObjects

;;
func_5d41:
	call func_1613
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2

	jp updateAllObjects


.ifdef ROM_AGES
	.include "code/ages/cutscenes.s"
.else; ROM_SEASONS
	.include "code/seasons/cutscenes.s"
.endif


;;
; CUTSCENE_IN_GALE_SEED_MENU
cutscene16:
	call updateMenus
	ret nz

	ld hl,wWarpTransition2
	ld a,(hl)
	ld (hl),$00
	inc a
	ld a,CUTSCENE_03
	jr nz,+

	call updateAllObjects
	ld a,CUTSCENE_INGAME
+
	ld (wCutsceneIndex),a
	xor a
	ld (wMenuDisabled),a
	ld (wLinkCanPassNpcs),a
	ld (wDisableScreenTransitions),a
	ret

.ifdef ROM_SEASONS

;;
; For some reason, Ages's version of this function is further down than Season's version.
checkDisplayEraOrSeasonInfo:
	ld a,GLOBALFLAG_DONT_DISPLAY_SEASON_INFO
	call checkGlobalFlag
	jr z,+
	ld a,GLOBALFLAG_DONT_DISPLAY_SEASON_INFO
	jp unsetGlobalFlag
+
	ld a,(wActiveGroup)
	or a
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_ERA_OR_SEASON_INFO
	ret
.endif

;;
; Called when a fadeout transition must occur between two screens.
triggerFadeoutTransition:
	ld a,CUTSCENE_05
	ld (wCutsceneIndex),a
	jp fadeoutToWhite

;;
applyWarpTransition2:
	ld hl,wWarpTransition2
	ld a,(hl)
	ld b,a
	ld (hl),$00
	and $0f
	cp $02
	jr nc,++

	ld a,$01
	ld (wGameState),a
	lda CUTSCENE_LOADING_ROOM
	ld (wCutsceneIndex),a
	ret
++
	ld a,(wLinkObjectIndex)
	cp $d1
	jr nz,+
	inc b
+
	ld a,b
	and $0f
	ld (wCutsceneIndex),a
	bit 7,b
	jp z,fadeoutToWhite

	ld a,$04
	jp fadeoutToWhiteWithDelay

;;
setCutsceneIndexIfCutsceneTriggerSet:
	ld a,(wCutsceneTrigger)
	and $7f
	ld (wCutsceneIndex),a
	xor a
	ld (wCutsceneTrigger),a
	ld (wCutsceneState),a
	ret

;;
checkPlayRoomMusic:
	ld a, GLOBALFLAG_INTRO_DONE
	call checkGlobalFlag
	ret z

.ifdef ROM_SEASONS
	; Override subrosia music if on a date with Rosa
	ld a,GLOBALFLAG_DATING_ROSA
	call checkGlobalFlag
	jr z,+

	ld a,(wActiveMusic2)
	cp MUS_SUBROSIA
	jr nz,+
	dec a ; MUS_ROSA_DATE
	jr @setMusic
+
.endif

	ld a,(wActiveMusic)
	or a
	ret z

.ifdef ROM_AGES
	; Override symmetry city present music if it hasn't been restored yet
	ld a,(wActiveMusic2)
	cp MUS_SYMMETRY_PRESENT
	jr nz,++

	ld a,(wActiveGroup)
	or a
	jr nz,++

	ld a,(wPresentRoomFlags+$03)
	bit 0,a
	jr nz,++

	ld a, MUS_SADNESS
	ld (wActiveMusic2),a
++
.endif

	ld a,(wActiveMusic2)

@setMusic:
	ld hl,wActiveMusic
	cp (hl)
	ret z

	ld (hl),a
	jp playSound


.ifdef ROM_AGES
;;
; Seasons has a version of this function a bit higher up.
checkDisplayEraOrSeasonInfo:
	ld a,GLOBALFLAG_16
	call checkGlobalFlag
	jr z,+

	ld a,GLOBALFLAG_16
	jp unsetGlobalFlag
+
	ld a,(wSentBackByStrangeForce)
	dec a
	ret z

	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_LARGE_INDOORS,a
	ret nz

	bit 0,a
	ret z

	call getFreeInteractionSlot
	ret nz

	ld (hl),INTERACID_ERA_OR_SEASON_INFO
	ret

.endif

;;
; Updates wGrassAnimationModifier to determine what color the grass should be.
;
; In Ages, it's always $00 (green).
;
updateGrassAnimationModifier:

.ifdef ROM_AGES
	ld a,$00
	ld (wGrassAnimationModifier),a
	ret

.else; ROM_SEASONS

	ld a,(wLoadingRoomPack)
	inc a
	ld a,$00
	jr z,+
	ld a,(wRoomStateModifier)
+
	ld b,a
	ld a,(wActiveGroup)
	or a
	ld a,b
	jr z,+
	xor a
+
	ld hl,@grassAnimationValues
	rst_addAToHl
	ld a,(hl)
	ld (wGrassAnimationModifier),a
	ret

@grassAnimationValues:

.db terrainEffects.greenGrassAnimationFrame0  - terrainEffects.greenGrassAnimationFrame0
.db terrainEffects.greenGrassAnimationFrame0  - terrainEffects.greenGrassAnimationFrame0
.db terrainEffects.orangeGrassAnimationFrame0 - terrainEffects.greenGrassAnimationFrame0
.db terrainEffects.blueGrassAnimationFrame0   - terrainEffects.greenGrassAnimationFrame0

.endif


;;
; @param c Index of preset to load into wDeathRespawnBuffer
loadDeathRespawnBufferPreset:
	push de
	ld a,c
	call multiplyABy8
	ld hl,@respawnBuffers
	add hl,bc
	ld de,wDeathRespawnBuffer-1
	ldi a,(hl)
	ld b,a
--
	inc de
	ldi a,(hl)
	sla b
	jr nc,+
	ld (de),a
+
	jr nz,--
	pop de
	ret

@respawnBuffers:

.ifdef ROM_AGES
	.db $fe $00 $b6 $03 $02 $48 $78 $00
	.db $fe $00 $38 $00 $02 $68 $50 $00
	.db $dc $00 $6f $ff $02 $58 $78 $ff
	.db $dc $01 $58 $ff $02 $48 $58 $ff
.else; ROM_SEASONS
	.db $fe $00 $b6 $03 $02 $48 $78 $00
	.db $fe $02 $5d $00 $02 $68 $50 $00
	.db $dc $00 $6f $ff $02 $58 $78 $ff
	.db $dc $00 $c5 $ff $02 $28 $48 $ff
.endif


.ifdef ROM_AGES

;;
; Checks room packs to see whether "fadeout" transition should occur. In Seasons this
; also deals with setting the season.
;
; Seasons puts its implementation of this function at the end of the bank.
;
; @param[out]	zflag	nz if fadeout transition should occur
checkRoomPack:
	ld a,(wActiveGroup)
	cp $02
	jr c,+

	xor a
	ret
+
	ld a,(wRoomPack)
	and $7f
	ld c,a
	ld a,(wLoadingRoomPack)
	ld b,a
	and $7f
	cp c
	ret z

	ld a,(wRoomPack)
	ld c,a
	ld a,b
	ld (wRoomPack),a
	or c
	bit 7,a
	ret
.endif

;;
; Note: this function sets the room height to be 1 higher than it should be for large
; rooms. This is probably on purpose, so objects don't disappear right away, but it's
; inconsistent.
;
calculateRoomEdge:
	ldbc SMALL_ROOM_HEIGHT*16, SMALL_ROOM_WIDTH*16
	ld a,(wRoomIsLarge)
	or a
	jr z,+
	ldbc (LARGE_ROOM_HEIGHT+1)*16, LARGE_ROOM_WIDTH*16
+
	ld hl,wRoomEdgeY
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
; Called after a screen transition, this calculates the new value for
; wActiveRoom.
updateActiveRoom:
	ld a,(wDungeonIndex)
	inc a
	jr nz,@dungeon

	ld a,(wScreenTransitionDirection)
	ld hl,@smallMapDirectionTable
	rst_addAToHl
	ld a,(wActiveRoom)
	add (hl)
	jr @gotRoom
@dungeon:
	ld a,(wScreenTransitionDirection)
	ld hl,@largeMapDirectionTable
	rst_addAToHl
	ld a,(wDungeonMapPosition)
	add (hl)
	ld (wDungeonMapPosition),a
	call getActiveRoomFromDungeonMapPosition
@gotRoom:
	ld (wActiveRoom),a
	jp setVisitedRoomFlag

@smallMapDirectionTable:
	.db $f0 $01 $10 $ff

@largeMapDirectionTable:
	.db $f8 $01 $08 $ff


;;
; Will update the value of wActiveRoom according to the direction of the
; current screen transition.
;
; @param[out]	cflag	Set on success.
getNextActiveRoom:
	ld a,(wScrollMode)
	and $04
	ret z
	ld a,(wActiveRoom)
	ld hl,mapTransitionGroupTable
	call findRoomSpecificData
	jr nc,screenTransitionStandard
	rst_jumpTable

.ifdef ROM_AGES
	.dw screenTransitionForestScrambler
	.dw clearEyePuzzleVars
	.dw clearEyePuzzleVars
	.dw screenTransitionEyePuzzle
.else
	.dw screenTransitionLostWoods
	.dw screenTransitionSwordUpgrade
	.dw screenTransitionOnoxDungeon
	.dw screenTransitionEyePuzzle
.endif

;;
screenTransitionStandard:
	call clearEyePuzzleVars
	call updateActiveRoom
	scf
	ret

;;
clearEyePuzzleVars:
	xor a
	ld (wLostWoodsTransitionCounter1),a
	ld (wLostWoodsTransitionCounter2),a
	ret


.ifdef ROM_AGES

	mapTransitionGroupTable:
		.dw mapTransitionGroup0Data
		.dw mapTransitionGroup1Data
		.dw mapTransitionGroup2Data
		.dw mapTransitionGroup3Data
		.dw mapTransitionGroup4Data
		.dw mapTransitionGroup5Data
		.dw mapTransitionGroup6Data
		.dw mapTransitionGroup7Data

	mapTransitionGroup0Data:
		.db $70 $00 ; ForestScrambler
		.db $71 $00 ; ForestScrambler
		.db $72 $00 ; ForestScrambler
		.db $80 $00 ; ForestScrambler
		.db $81 $00 ; ForestScrambler
		.db $82 $00 ; ForestScrambler
		.db $90 $00 ; ForestScrambler
		.db $91 $00 ; ForestScrambler
		.db $92 $00 ; ForestScrambler
		.db $00

	mapTransitionGroup1Data:
	mapTransitionGroup2Data:
	mapTransitionGroup3Data:
	mapTransitionGroup4Data:
	mapTransitionGroup6Data:
	mapTransitionGroup7Data:
		.db $00

	mapTransitionGroup5Data:
		.db $f3 $03 ; EyePuzzle
		.db $00

.else; ROM_SEASONS

	mapTransitionGroupTable:
		.dw mapTransitionGroup0Data
		.dw mapTransitionGroup1Data
		.dw mapTransitionGroup2Data
		.dw mapTransitionGroup3Data
		.dw mapTransitionGroup4Data
		.dw mapTransitionGroup5Data
		.dw mapTransitionGroup6Data
		.dw mapTransitionGroup7Data

	mapTransitionGroup0Data:
		.db $40 $00 ; LostWoods
		.db $c9 $01 ; SwordUpgrade

	mapTransitionGroup1Data:
	mapTransitionGroup2Data:
	mapTransitionGroup3Data:
	mapTransitionGroup4Data:
	mapTransitionGroup6Data:
	mapTransitionGroup7Data:
		.db $00

	mapTransitionGroup5Data:
		.db $93 $02 ; OnoxDungeon
		.db $94 $02 ; OnoxDungeon
		.db $95 $02 ; OnoxDungeon
		.db $9c $03 ; EyePuzzle
		.db $00

.endif



.ifdef ROM_AGES

;;
; Forest scrambler code
screenTransitionForestScrambler:
	ld a, GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp nz,screenTransitionStandard

	ld a,(wActiveRoom)
	sub $70
	ld b,a
	and $f0
	swap a
	ld c,a
	add a
	add c
	ld c,a
	ld a,b
	and $0f
	add c
	add a
	add a
	ld b,a
	ld a,(wScreenTransitionDirection)
	and $03
	add b
	ld hl,@forestScramblerTable
	rst_addAToHl
	ld a,(hl)
	or a
	jp z,screenTransitionStandard

	ld (wActiveRoom),a
	scf
	ret

@forestScramblerTable:
	.db $00 $71 $90 $00
	.db $00 $82 $91 $80
	.db $00 $00 $92 $82
	.db $72 $82 $80 $00
	.db $80 $82 $82 $71
	.db $70 $71 $82 $71
	.db $81 $92 $00 $00
	.db $72 $91 $00 $92
	.db $82 $00 $00 $92


.else; ROM_SEASONS


;;
screenTransitionLostWoods:
	call @checkMoveNorthTransitions
	ret c
	call @checkSwordUpgradeTransitions
	ret c
	ld a,(wScreenTransitionDirection)
	dec a
	jr nz,+
	ld a,(wLostWoodsTransitionCounter1)
	cp $03
	jr nz,screenTransitionStandard
+
	ld a,$40
	ld (wActiveRoom),a
	scf
	ret

;;
; Check for the sequence of transitions needed to move north.
; @param[out]	cflag	Set if the north transition succeeded.
@checkMoveNorthTransitions:
	ld a,(wLostWoodsTransitionCounter1)
	rst_jumpTable
	.dw @transition0
	.dw @transition1
	.dw @transition2
	.dw @transition3

@transition0:
	ldbc DIR_LEFT, SEASON_WINTER

@checkTransitionForNorth:
	ld hl,wLostWoodsTransitionCounter1

; b = expected direction of transition
; c = expected season
; Increments [hl] if the above checks out, or sets it to 0 otherwise
@checkTransition:
	ld a,(wScreenTransitionDirection)
	cp b
	jr nz,@wrongWay
	ld a,(wRoomStateModifier)
	cp c
	jr nz,@wrongWay
	inc (hl)
	jr +++

@wrongWay:
	xor a
	ld (hl),a
+++
	xor a
	ret

@transition1:
	ldbc DIR_DOWN, SEASON_AUTUMN
	jr @checkTransitionForNorth

@transition2:
	ldbc DIR_RIGHT, SEASON_SPRING
	jr @checkTransitionForNorth

@transition3:
	ldbc DIR_UP, SEASON_SUMMER
	call @checkTransitionForNorth
	ld a,(hl)
	cp $04
	ret nz
	ld (hl),$00
	ld a,$30
	ld (wActiveRoom),a
	scf
	ret

;;
; Check for the sequence of transitions needed to move west (sword upgrade).

; @param[out]	cflag	Set if the west transition succeeded.
@checkSwordUpgradeTransitions:
	ld a,(wLostWoodsTransitionCounter2)
	rst_jumpTable
	.dw @@transition0
	.dw @@transition1
	.dw @@transition2
	.dw @@transition3

@@transition0:
	ldbc DIR_LEFT, SEASON_WINTER
	ld hl,wLostWoodsTransitionCounter2
	jr @checkTransition

@@transition1:
	ldbc DIR_LEFT, SEASON_AUTUMN
	ld hl,wLostWoodsTransitionCounter2
	jr @checkTransition

@@transition2:
	ldbc DIR_LEFT, SEASON_SPRING
	ld hl,wLostWoodsTransitionCounter2
	jr @checkTransition

@@transition3:
	ldbc DIR_LEFT, SEASON_SUMMER
	ld hl,wLostWoodsTransitionCounter2
	call @checkTransition
	ld a,(hl)
	cp $04
	ret nz

	; Success, warp to sword upgrade screen
	ld (hl),$00
	ld a,$c9
	ld (wActiveRoom),a
	scf
	ret

;;
; The sword upgrade screen is actually located where you'd expect the maku tree to be, so
; override the destination room.
screenTransitionSwordUpgrade:
	call clearEyePuzzleVars
	ld a,$40
	ld (wActiveRoom),a
	scf
	ret

;;
; Can't proceed in onox's dungeon until enemies are dead. Also, going to the left or right
; rooms always send you back near the entrance.
screenTransitionOnoxDungeon:
	ld a,(wScreenTransitionDirection)
	and $03
	rst_jumpTable
	.dw @up
	.dw @right
	.dw screenTransitionStandard ; down
	.dw @left

@up:
	call getThisRoomFlags
	and $40
	jp nz,screenTransitionStandard
	ld a,(wActiveRoom)
	ld b,a
	jr +++

@right:
	ld bc,$9834
	jr ++

@left:
	ld bc,$9632
++
	ld a,c
	ld (wDungeonMapPosition),a
+++
	ld a,b
	ld (wActiveRoom),a
	scf
	ret

.endif ; ROM_SEASONS


;;
screenTransitionEyePuzzle:
	ld a,(wScreenTransitionDirection)
	and $03
	ld b,a
	ld a,(wEyePuzzleCorrectDirection)
	cp b
	jr z,+
	call clearEyePuzzleVars
	jr ++
+
	ld hl,wEyePuzzleTransitionCounter
	inc (hl)
++
	ld a,b
	rst_jumpTable
	.dw @up
	.dw @rightOrLeft
	.dw screenTransitionStandard
	.dw @rightOrLeft

@up:
	ld a,(wEyePuzzleTransitionCounter)
	cp $06
	jr c,@rightOrLeft
	jp screenTransitionStandard

@rightOrLeft:
	scf
	ret

;;
updateSeedTreeRefillData:

.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_OUTDOORS
	ret z

.else; ROM_SEASONS

	ld a,(wActiveGroup)
	or a
	ret nz
.endif

	ld a,:wxSeedTreeRefillData
	ld ($ff00+R_SVBK),a
	ld hl,seedTreeRefillLocations
	ld b,NUM_SEED_TREES
--
	push bc
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	ld e,a
	call checkSeedTreeRefillIndex
	inc hl
	pop bc
	dec b
	jr nz,--

	xor a
	ld ($ff00+R_SVBK),a
	ret

.include "build/data/seedTreeRefillData.s"

;;
; Season's implementation of this function is quite different. It appears that they
; originally assumed a maximum of 8 seed trees, but expanded that to 16 for Ages.
;
; @param	b	Seed tree index (actually NUM_SEED_TREES - index)
; @param	c	Screen the seed tree is on
; @param	e	Group?
checkSeedTreeRefillIndex:
	ld a,b
	ldh (<hFF8D),a

.ifdef ROM_AGES
	ld a,e
	res 0,e
	and $01
	ld b,a
	ld a,(wActiveGroup)
	cp b
	ld d,>wxSeedTreeRefillData
	jr nz,+
	ld a,(wActiveRoom)
	cp c
	jr z,@treeScreen
+
	ldh a,(<hFF8D)
	ld b,a
	ld a,$10
	sub b
	push hl
	ld hl,wSeedTreeRefilledBitset
	call checkFlag
	pop hl
	ret nz

.else ; ROM_SEASONS
	ld a,(wActiveRoom)
	cp c
	ld d,>wxSeedTreeRefillData
	jr z,@treeScreen

	ldh a,(<hFF8D)
	dec a
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld b,a
	ld a,(wSeedTreeRefilledBitset)
	and b
	ret nz
.endif

	ld a,(wActiveRoom)
	ld b,a
	ld c,$08
--
	ld a,(de)
	or a
	jr z,@addRoom

	cp b
	ret z

	inc e
	dec c
	jr nz,--

	ret

@addRoom:
	ld a,b
	ld (de),a
	ret

; This screen contains the tree we're checking
@treeScreen:

.ifdef ROM_AGES
	push hl
	push de
	ld c,$08
--
	ld a,(de)
	or a
	jr z,+
	inc e
	dec c
	jr nz,--
	or d
+
	jr z,+

	ldh a,(<hFF8D)
	ld b,a
	ld a,$10
	sub b
	ld hl,wSeedTreeRefilledBitset
	call setFlag
+
	; Clear the buffer... even if we didn't set the bit?
	; So visiting a tree which hasn't regrown yet will reset the counter...

	pop de
	ld l,e
	ld h,d
	ld b,$08
	call clearMemory
	pop hl
	ret

.else; ROM_SEASONS

	ld c,$08
--
	ld a,(de)
	or a
	jr z,+
	inc e
	dec c
	jr nz,--
	or d
+
	jr z,+

	ld a,b
	dec a
	ld de,bitTable
	add e
	ld e,a
	ld a,(de)
	ld d,a
	ld a,(wSeedTreeRefilledBitset)
	or d
	ld (wSeedTreeRefilledBitset),a
+
	push hl
	ld l,(hl)
	ld h,>wxSeedTreeRefillData
	ld b,$08
	call clearMemory
	pop hl
	ret

.endif

;;
initializeSeedTreeRefillData:

.ifdef ROM_AGES
	ld hl,wSeedTreeRefilledBitset
	ld (hl),$f0
	inc l
	ld (hl),$ff

.else; ROM_SEASONS

	ld a,$fc
	ld (wSeedTreeRefilledBitset),a
.endif

	ld a,:wxSeedTreeRefillData
	ld ($ff00+R_SVBK),a
	ld hl,wxSeedTreeRefillData
	ld b,NUM_SEED_TREES*8
	call clearMemory
	xor a
	ld ($ff00+R_SVBK),a
	ret

;;
func_60cd:
	ld a,(wLinkObjectIndex)
	rrca
	ret nc

	ld a,(wScrollMode)
	and $04
	ret z

	ld a,(w1Link.state)
	cp LINK_STATE_WARPING
	ret z

	ld a,(wTextIsActive)
	or a
	ret nz

	call checkScreenEdgeWarps
	ret nc
	jr initiateScreenEdgeWarp

;;
; Checks for warps?
func_60e9:
	ld a,(wScrollMode)
	or a
	ret z

	call func_60cd
	ret c

	ld a,(wLinkInAir)
	and $7f
	ret nz

	ld a,(wWarpsDisabled)
	or a
	ret nz

	ld a,(w1Link.state)
	cp LINK_STATE_WARPING
	ret z

	ld a,(wTextIsActive)
	or a
	ret nz

	ld a,(wDisableWarpTiles)
	or a
	ret nz

	; Get tile (-> FF8C) and position of tile (-> FF8D) that Link is standing on
	ld hl,w1Link.yh
	ldi a,(hl)
	add $04
	ld b,a
	inc l
	ld c,(hl)
	call getTileAtPosition
	ldh (<hFF8C),a
	ld b,a
	ld a,l
	ldh (<hFF8D),a

	ld a,(wScrollMode)
	and $04
	jr nz,+

	call checkStandingOnDeactivatedWarpTile
	ret nc
+
	ld a,$ff
	ld (wEnteredWarpPosition),a
	ld a,(wActiveGroup)
	rst_jumpTable
	.dw checkWarpsTopDown
	.dw checkWarpsTopDown
	.dw checkWarpsTopDown
	.dw checkWarpsTopDown
	.dw checkWarpsTopDown
	.dw checkWarpsTopDown
	.dw checkWarpsSidescrolling
	.dw checkWarpsSidescrolling

;;
; @param	hFF8C	Tile Link is on
; @param	hFF8D	Position of tile Link is on
checkWarpsTopDown:
	call checkTileWarps
	ret c

	call checkScreenEdgeWarps
	ret nc
	jr initiateScreenEdgeWarp

;;
; @param	hFF8C	Tile Link is on
; @param	hFF8D	Position of tile Link is on
checkWarpsSidescrolling:
	call checkScreenEdgeWarps
	ret nc

	ld a,(wWarpTransition)
	or $30
	ld (wWarpTransition),a
	jr initiateWarp

initiateScreenEdgeWarp:
	ld a,(wWarpTransition)
	or $10
	ld (wWarpTransition),a

;;
initiateWarp:
	ld a,$00
	ld (wScrollMode),a
	ld a,$1e
	ld (wDisabledObjects),a
	ld a,LINK_STATE_WARPING
	ld (wLinkForceState),a
	jr warpInitiated

;;
; Checks if Link is within the appropriate bounds of a warp tile to initiate a warp?
;
; So, touching the tile is not quite enough; Link needs to be close enough to the center?
;
; @param[out]	cflag	Set if Link's close enough to the tile's center.
checkLinkCloseEnoughToWarpTileCenter:
	ld h,LINK_OBJECT_INDEX
	ldh a,(<hFF8D)
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ld l,<w1Link.yh
	jr nz,@tileSolid

	ld b,$04
	call @func_618f
	ret nc

	ld b,$00
	ld l,<w1Link.xh
	jr @func_618f

@tileSolid:
	; If the tile's partially solid, change the bounds of the check (and only check
	; the Y position)?
	ld b,$02

;;
; @param[out]	cflag
@func_618f:
	ld a,(hl)
	add b
	and $0f
	sub $04
	cp $0a
	ret

;;
; @param[out]	cflag	Set to indicate a warp has occurred.
warpInitiated:
	ld a,$01
	ld (wDisableLinkCollisionsAndMenu),a
	scf
	ret

;;
; @param[out]	cflag	Unset to indicate no warp has occurred.
noWarpInitiated:
	xor a
	ret

;;
; Check for warps initiated by touching certain tiles (ie. stairs).
;
; @param[out]	cflag	Set if a warp has occurred.
checkTileWarps:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.zh
	ld a,(hl)
	or a
	ret nz

	ld a,(wMenuDisabled)
	or a
	jr nz,noWarpInitiated

	ldh a,(<hFF8C)
	call checkTileIsWarpTile
	jr nc,noWarpInitiated

.ifdef ROM_SEASONS
	dec a
	jr z,@chimney
.endif

	ld a,(wLinkGrabState)
	or a
	jr nz,noWarpInitiated

	call @checkAdjacentTileIsWarpTile
	jr c,@checkLinkCloseEnoughToWarpTileCenter_multiTileDoor
	call checkLinkCloseEnoughToWarpTileCenter
	jr nc,noWarpInitiated

@initiateWarp:
	callab bank4.findWarpSourceAndDest
	jp initiateWarp

.ifdef ROM_SEASONS

; Apparently, the chimney in Seasons ignores any checks for held items or proper
; centering.
@chimney:
	ld hl,w1Link.zh
	ld a,(hl)
	or a
	ret nz
	call clearAllParentItems
	call dropLinkHeldItem
	call resetLinkInvincibility
	jr @initiateWarp

.endif ; ROM_SEASONS

;;
; Checks if a tile to the left or right is a warp tile.
;
; @param[out]	cflag	Set if one of the adjacent tiles (left/right) is a warp tile
@checkAdjacentTileIsWarpTile:
	ldh a,(<hFF8D)
	inc a
	call @@checkIsWarpTile
	ret c

	ldh a,(<hFF8D)
	dec a

@@checkIsWarpTile:
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	jr checkTileIsWarpTile

;;
; This is similar to "checkLinkCloseEnoughToWarpTileCenter", but this is used when there
; are multiple door tiles lined up horizontally. So, it skips the check for being close
; enough to the horizontal center of the tile.
;
; @param[out]	cflag	Set if Link is close enough to the center of the tile
@checkLinkCloseEnoughToWarpTileCenter_multiTileDoor:
	ldh a,(<hFF8D)
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)

; Ages & Seasons have different criteria for when to change the bounds on partially-solid
; tiles...

.ifdef ROM_AGES
	or a
	ld b,$02
	jr nz,+
	ld b,$04
+
.else; ROM_SEASONS

	cp $0c
	ld b,$02
	jr z,+
	ld b,$04
+
.endif

	ld hl,w1Link.yh
	ld a,(hl)
	add b
	and $0f
	sub $04
	cp $0a
	ret nc
	jr @initiateWarp

;;
; This checks if Link is already standing on a warp tile (from entering the room) and
; prevents warps from occurring if this is the case.
;
; @param[out]	cflag	Set if the game may proceed to check for warps
checkStandingOnDeactivatedWarpTile:
	scf
	ld a,(wEnteredWarpPosition)
	inc a
	ret z

	; Check if Link's standing on the deactivated warp tile
	ld a,(wEnteredWarpPosition)
	ld b,a
	ldh a,(<hFF8D)
	cp b
	ret z

	; Check for 2-tile-wide doors (by checking one tile to the left)
	dec b
	cp b
	jr z,++
--
	scf
	ret
++
	ldh a,(<hFF8C)
	call checkTileIsWarpTile
	jr nc,--

	xor a
	ret

;;
; @param[out]	cflag	Set if warp activated
checkScreenEdgeWarps:
	ld a,$ff
	ld (wTmpcec0),a
	callab bank4.findScreenEdgeWarpSource
	ld a,(wTmpcec0)
	cp $ff
	jp z,noWarpInitiated
	jp warpInitiated

;;
; @param	a	Tile index
; @param[out]	cflag	Set if this tile is a warp tile.
checkTileIsWarpTile:
	ld hl,warpTileTable
	jp lookupCollisionTable

; This is a list of tiles that initiate warps when touched.
warpTileTable:
	.dw @collisions0
	.dw @collisions1
	.dw @collisions2
	.dw @collisions3
	.dw @collisions4
	.dw @collisions5

.ifdef ROM_AGES

	@collisions0:
	@collisions4:
		.db $dc $00
		.db $dd $00
		.db $de $00
		.db $df $00
		.db $ed $00
		.db $ee $00
		.db $ef $00
		.db $00
	@collisions1:
		.db $34 $00
		.db $36 $00
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $af $00
		.db $00
	@collisions2:
	@collisions5:
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $4f $00
		.db $00
	@collisions3:
		.db $00


.else; ROM_SEASONS

	@collisions0:
		.db $e6 $00
		.db $e7 $00
		.db $e8 $00
		.db $e9 $00
		.db $ea $00
		.db $eb $01 ; Chimney gets special treatment?
		.db $ed $00
		.db $ee $00
		.db $ef $00
		.db $00
	@collisions1:
		.db $e6 $00
		.db $e7 $00
		.db $e8 $00
		.db $ed $00
		.db $ee $00
		.db $ef $00
		.db $00
	@collisions2:
		.db $ea $00
		.db $eb $00
		.db $ec $00
		.db $ed $00
		.db $e8 $00
		.db $00
	@collisions3:
		.db $34 $00
		.db $36 $00
		.db $4f $00
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $00
	@collisions4:
		.db $44 $00
		.db $45 $00
		.db $46 $00
		.db $47 $00
		.db $4f $00
		.db $00
	@collisions5:
		.db $00

.endif ; ROM_SEASONS


.ifdef ROM_AGES

	.include "code/ages/underwaterWaves.s"
	.include "code/ages/timewarpTileSolidityCheck.s"

.else; ROM_SEASONS

	.include "code/seasons/onoxCastleEssenceCutscene.s"

.endif ; ROM_SEASONS

.ENDS


; This is superfree (bank can change) so namespace should be different from the others
 m_section_superfree Bank_1_Data_2 NAMESPACE bank1Moveable

	.include "build/data/paletteHeaders.s"
	.include "build/data/uncmpGfxHeaders.s"
	.include "build/data/gfxHeaders.s"
	.include "build/data/tilesetHeaders.s"

.ends


 m_section_free Bank_1_Code_3 NAMESPACE bank1

.ifdef ROM_AGES
;;
; CUTSCENE_FAIRIES_HIDE
cutscene13:
	callab bank3Cutscenes.func_03_6103
	call func_1613
	jp updateAllObjects

;;
; CUTSCENE_BOOTED_FROM_PALACE
cutscene14:
	callab bank3Cutscenes.func_03_6275
	call func_1613
	call updateAllObjects
	jp updateStatusBar

.endif

;;
linkSummonedCutscene:
	call func_7b93
	jp updateAllObjects

;;
func_7b93:
	ld a,(wCutsceneIndex)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld hl,wCutsceneIndex
	inc (hl)
	call disableLcd
	call clearOam
	call clearMemoryOnScreenReload
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	call func_131f
	call loadDungeonLayout
	ld a,$01
	ld (wScrollMode),a
	call calculateRoomEdge
	call updateLinkLocalRespawnPosition
	call loadCommonGraphics
	ld a,$02
	call fadeinFromWhiteWithDelay
	ld a,$02
	call loadGfxRegisterStateIndex
	ld a,$10
	ld (wGfxRegs2.LYC),a
	ld a,$02
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,SND_WARP_START
	call playSound
	ld a,$ff
	jp initWaveScrollValues

@state1:
	ld a,$01
	call loadBigBufferScrollValues
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld hl,wCutsceneIndex
	inc (hl)
	ld a,$81
	ld (wDisabledObjects),a
	ld a,$ff
	ld (wGenericCutscene.cbb4),a
	xor a
	ld (wGenericCutscene.cbb3),a
	ret

@state2:
	ld a,(wGenericCutscene.cbb3)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,$01
	call loadBigBufferScrollValues
	ld hl,wGenericCutscene.cbb4
	dec (hl)
	dec (hl)
	ld a,(hl)
	call initWaveScrollValues
	ld a,(wGenericCutscene.cbb4)
	cp $80
	ret nc

	ld hl,wGenericCutscene.cbb3
	inc (hl)
	ld a,$03
	ld ($d000),a
	ld a,LINK_STATE_WARPING
	ld (wLinkForceState),a
	ld a,$0b
	ld (wWarpTransition),a
	ret

@substate1:
	ld a,$01
	call loadBigBufferScrollValues
	ld hl,wGenericCutscene.cbb4
	dec (hl)
	jr z,+
	dec (hl)
+
	ld a,(hl)
	call initWaveScrollValues
	ld a,(wGenericCutscene.cbb4)
	or a
	ret nz

	ld hl,wGenericCutscene.cbb3
	inc (hl)
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ret

@substate2:
	ld a,$02
	ld (wGameState),a
	lda CUTSCENE_LOADING_ROOM
	ld (wCutsceneIndex),a
	ld (wDisabledObjects),a
	ld a,GLOBALFLAG_PREGAME_INTRO_DONE
	call setGlobalFlag
	jp initializeRoom


.ifdef ROM_SEASONS

;;
; Checks room packs to see whether "fadeout" transition should occur, and determines
; what the season for the next room should be. Only called on normal screen transitions
; (not when warping directly into a screen).
;
; Ages's version of this function is higher up.
;
; @param[out]	zflag	nz if fadeout transition should occur
checkRoomPack:
	ld a,(wActiveGroup)
	or a
	jr z,+
	xor a
	ret
+
	; Check for change in room pack
	ld a,(wRoomPack)
	ld c,a
	ld a,(wLoadingRoomPack)
	ld b,a
	ld a,(wRoomPack)
	cp b
	ret z

	ld c,a
	ld a,b
	ld (wRoomPack),a
	or a
	jr z,setHoronVillageSeason

;;
; @param	a	Room pack value
determineSeasonForRoomPack:
	cp $f0
	jr nc,determineCompanionRegionSeason

	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	ld a,(wLoadingRoomPack)
	jr z,+
	and $0f
+
	ld hl,roomPackSeasonTable
	rst_addAToHl
	ld a,(hl)

;;
setSeason:
	ld (wRoomStateModifier),a
	or $01
	ret


	; Unused code snipped?
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	ret z
	scf
	ret

;;
; Set a random season for horon village (unless it's spring).
setHoronVillageSeason:
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	ld a,$00
	jr nz,setSeason
	call getRandomNumber
	and $03
	jr setSeason

;;
; @param	a
determineCompanionRegionSeason:
	cp $ff
	jr z,@companionRegion
	ld a,$01
	jr setSeason

@companionRegion:
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECTID_RICKY-1
	and $03
	ld (wRoomStateModifier),a
	jr setSeason


.include "data/seasons/roomPackSeasonTable.s"

;;
; Similar to "checkRoomPack" function, but called after a "warp" transition (ie. exited
; building or subrosia portal).
checkRoomPackAfterWarp_body:
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call checkGlobalFlag
	ld a,(wRoomPack)
	jp nz,determineSeasonForRoomPack

	cp $f0
	jp nc,determineCompanionRegionSeason

	; Horon village: don't calculate anything (season stays the same as last area)
	or a
	ret z

	ld hl,roomPackSeasonTable
	rst_addAToHl
	ld a,(hl)
	ld (wRoomStateModifier),a
	ret

.else ; ROM_AGES

;;
updateLastToggleBlocksState:
	ld a,(wToggleBlocksState)
	ld (wLastToggleBlocksState),a
	ret

;;
checkUpdateToggleBlocks:
	call checkDungeonUsesToggleBlocks
	ret z

	ld a,(wToggleBlocksState)
	ld b,a
	ld a,(wLastToggleBlocksState)
	xor b
	rrca
	ret nc
	ld a,CUTSCENE_TOGGLE_BLOCKS
	ld (wCutsceneTrigger),a
	ret

	.include "code/ages/cutscenes2.s"
	.include "code/ages/pirateShip.s"

;;
; CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT
cutscene1f:
	callab bank3Cutscenes.func_03_7cb7
	call updateStatusBar
	jp updateAllObjects

.endif ; ROM_AGES

.ends
