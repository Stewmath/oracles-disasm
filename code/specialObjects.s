;;
updateSpecialObjects:
	ld hl,wLinkIDOverride
	ld a,(hl)
	ld (hl),$00
	or a
	jr z,+
	and $7f
	ld (w1Link.id),a
+
.ifdef ROM_AGES
	ld hl,w1Link.var2f
	ld a,(hl)
	and $3f
	ld (hl),a

	ld a,TREASURE_MERMAID_SUIT
	call checkTreasureObtained
	jr nc,+
	set 6,(hl)
+
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,+
	set 7,(hl)
+
.endif

	xor a
	ld (wBraceletGrabbingNothing),a
	ld (wcc92),a
	ld (wForceLinkPushAnimation),a

	ld hl,wcc95
	ld a,(hl)
	or $7f
	ld (hl),a

	ld hl,wLinkTurningDisabled
	res 7,(hl)

	call updateGameKeysPressed

	ld hl,w1Companion
	call @updateSpecialObject

	xor a
	ld (wLinkClimbingVine),a
.ifdef ROM_AGES
	ld (wDisallowMountingCompanion),a
.endif

	ld hl,w1Link
	call @updateSpecialObject

	call updateLinkInvincibilityCounter

	ld a,(wLinkPlayingInstrument)
	ld (wLinkRidingObject),a

	ld hl,wLinkImmobilized
	ld a,(hl)
	and $0f
	ld (hl),a

	xor a
	ld (wcc67),a
	ld (w1Link.var2a),a
	ld (wccd8),a

	ld hl,wInstrumentsDisabledCounter
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
+
	ld hl,wGrabbableObjectBuffer
	ld b,$10
	jp clearMemory

;;
; @param hl Object to update (w1Link or w1Companion)
@updateSpecialObject:
	ld a,(hl)
	or a
	ret z

	ld a,l
	ldh (<hActiveObjectType),a
	ld a,h
	ldh (<hActiveObject),a
	ld d,h

	ld l,Object.id
	ld a,(hl)
	rst_jumpTable
	.dw specialObjectCode_link
.ifdef ROM_AGES
	.dw specialObjectCode_transformedLink
.else
	.dw specialObjectCode_subrosiaDanceLink
.endif
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_transformedLink
	.dw specialObjectCode_linkInCutscene
	.dw specialObjectCode_linkRidingAnimal
	.dw specialObjectCode_minecart
	.dw specialObjectCode_ricky
	.dw specialObjectCode_dimitri
	.dw specialObjectCode_moosh
	.dw specialObjectCode_maple
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_companionCutscene
	.dw specialObjectCode_raft

;;
; Updates wGameKeysPressed based on wKeysPressed, and updates wLinkAngle based on
; direction buttons pressed.
updateGameKeysPressed:
	ld a,(wKeysPressed)
	ld c,a

	ld a,(wUseSimulatedInput)
	or a
	jr z,@updateKeysPressed_c

	cp $02
	jr z,@reverseMovement

	call getSimulatedInput
	jr @updateKeysPressed_a

	; This code is used in the Ganon fight where he reverses Link's movement?
@reverseMovement:
	xor a
	ld (wUseSimulatedInput),a
	ld a,BTN_DOWN | BTN_LEFT
	and c
	rrca
	ld b,a

	ld a,BTN_UP | BTN_RIGHT
	and c
	rlca
	or b
	ld b,a

	ld a,$0f
	and c
	or b

@updateKeysPressed_a:
	ld c,a
@updateKeysPressed_c:
	ld a,(wLinkDeathTrigger)
	or a
	ld hl,wGameKeysPressed
	jr nz,@dying

	; Update wGameKeysPressed, wGameKeysJustPressed based on the value of 'c'.
	ld a,(hl)
	cpl
	ld b,a
	ld a,c
	ldi (hl),a
	and b
	ldi (hl),a

	; Update Link's angle based on the direction buttons pressed.
	ld a,c
	and $f0
	swap a
	ld hl,@directionButtonToAngle
	rst_addAToHl
	ld a,(hl)
	ld (wLinkAngle),a
	ret

@dying:
	; Clear wGameKeysPressed, wGameKeysJustPressed
	xor a
	ldi (hl),a
	ldi (hl),a

	; Set wLinkAngle to $ff
	dec a
	ldi (hl),a
	ret

; Index is direction buttons pressed, value is the corresponding angle.
@directionButtonToAngle:
	.db $ff $08 $18 $ff $00 $04 $1c $ff
	.db $10 $0c $14 $ff $ff $ff $ff

;;
; This is called when Link is riding something (wLinkObjectIndex == $d1).
;
func_410d:
	xor a
	ldh (<hActiveObjectType),a
	ld de,w1Companion.id
	ld a,d
	ldh (<hActiveObject),a
	ld a,(de)
	sub SPECIALOBJECT_MINECART
	rst_jumpTable

	.dw @ridingMinecart
	.dw @ridingRicky
	.dw @ridingDimitri
	.dw @ridingMoosh
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @invalid
	.dw @ridingRaft

@invalid:
	ret

@ridingRicky:
	ld bc,$0000
	jr @companion

@ridingDimitri:
	ld e,<w1Companion.direction
	ld a,(de)
	rrca
	ld bc,$f600
	jr nc,@companion

	ld c,$fb
	rrca
	jr nc,@companion

	ld c,$05
	jr @companion

@ridingMoosh:
	ld e,SpecialObject.direction
	ld a,(de)
	rrca
	ld bc,$f200
	jr nc,@companion
	ld b,$f0

;;
; @param	bc	Position offset relative to companion to place Link at
@companion:
	ld hl,w1Link.yh
	call objectCopyPositionWithOffset

	ld e,<w1Companion.direction
	ld l,<w1Link.direction
	ld a,(de)
	ld (hl),a
	ld a,$01
	ld (wDisableWarpTiles),a

	ld l,<w1Link.var2a
	ldi a,(hl)
	or (hl)
	ld l,<w1Link.knockbackCounter
	or (hl)
	jr nz,@noDamage
	ld l,<w1Link.damageToApply
	ld e,l
	ld a,(de)
	or a
	jr z,@noDamage

	ldi (hl),a ; [w1Link.damageToApply] = [w1Companion.damageToApply]

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from companion to Link.
	ld l,<w1Link.health
	ld e,l
	ld b,$06
	call copyMemoryReverse
	jr @label_05_010

@noDamage:
	ld l,<w1Link.damageToApply
	ld e,l
	ld a,(hl)
	ld (de),a

	; Copy health, var2a, invincibilityCounter, knockbackAngle, knockbackCounter,
	; stunCounter from Link to companion.
	ld d,>w1Link
	ld h,>w1Companion
	ld l,SpecialObject.health
	ld e,l
	ld b,$06
	call copyMemoryReverse

@label_05_010:
	ld h,>w1Link
	ld d,>w1Companion
	ld l,<w1Link.oamFlags
	ld a,(hl)
	ld l,<w1Link.oamFlagsBackup
	cp (hl)
	jr nz,+
	ld e,<w1Companion.oamFlagsBackup
	ld a,(de)
+
	ld e,<w1Companion.oamFlags
	ld (de),a
	ld l,<w1Link.visible
	ld e,l
	ld a,(de)
	and $83
	ld (hl),a
	ret

@ridingMinecart:
	ld h,d
	ld l,<w1Companion.direction
	ld a,(hl)
	ld l,<w1Companion.animParameter
	add (hl)
	ld hl,@linkOffsets
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	ld hl,w1Link.yh
	call objectCopyPositionWithOffset

	; Disable terrain effects on Link
	ld l,<w1Link.visible
	res 6,(hl)

	ret


; Data structure:
;   Each row corresponds to a frame of the minecart animation.
;   Each column corresponds to a direction.
;   Each 2 bytes are a position offset for Link relative to the minecart.
@linkOffsets:
;           --Up--   --Right-- --Down-- --Left--
	.db $f7 $00  $f7 $00   $f7 $00  $f7 $00
	.db $f7 $ff  $f8 $00   $f7 $ff  $f8 $00

;;
@ridingRaft:
.ifdef ROM_AGES
	ld a,(wLinkForceState)
	cp LINK_STATE_RESPAWNING
	ret z

	ld hl,w1Link.state
	ldi a,(hl)
	cp LINK_STATE_RESPAWNING
	jr nz,++
	ldi a,(hl) ; Check w1Link.substate
	cp $03
	ret c
++
	; Disable terrain effects on Link
	ld l,<w1Link.visible
	res 6,(hl)

	; Set Link's position to be 5 or 6 pixels above the raft, depending on the frame
	; of animation
	ld bc,$fb00
	ld e,<w1Companion.animParameter
	ld a,(de)
	or a
	jr z,+
	dec b
+
	call objectCopyPositionWithOffset
	jp objectSetVisiblec3
.endif


.include "object_code/common/specialObjects/commonCode.s"
.include "object_code/common/specialObjects/link.s"
.include "object_code/common/specialObjects/transformedLink.s"
.include "object_code/common/specialObjects/linkRidingAnimal.s"


specialObjectCode_minecart:
	; Jump to code in bank 6 to handle it
	jpab bank6.specialObjectCode_minecart


.include "object_code/common/specialObjects/maple.s"
.include "object_code/common/specialObjects/ricky.s"
.include "object_code/common/specialObjects/dimitri.s"
.include "object_code/common/specialObjects/moosh.s"


specialObjectCode_raft:
.ifdef ROM_AGES
	jpab bank6.specialObjectCode_raft
.endif
