; ==================================================================================================
; INTERAC_COMPANION_SCRIPTS
; ==================================================================================================
interactionCode71:
	ld a,(wLinkDeathTrigger)
	or a
	jr z,++
	xor a
	ld (wDisabledObjects),a
	jp interactionDelete
++
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw companionScript_subid00
	.dw companionScript_subid01
	.dw companionScript_subid02
	.dw companionScript_subid03
	.dw companionScript_subid04
	.dw companionScript_subid05
	.dw companionScript_subid06
	.dw companionScript_subid07
	.dw companionScript_subid08
	.dw companionScript_subid09
	.dw companionScript_subid0a
	.dw companionScript_subid0b
	.dw companionScript_subid0c
	.dw companionScript_subid0d


companionScript_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_subid00_state1

@state0:
	ld a,$01
	ld (de),a
	ld a,(wEssencesObtained)
	bit 1,a
	jp z,companionScript_deleteSelf

	ld a,(wPastRoomFlags+$79)
	bit 6,a
	jp z,companionScript_deleteSelf

	ld a,(wMooshState)
	and $60
	jp nz,companionScript_deleteSelf

	ld a,$01
	ld (wDisableScreenTransitions),a
	ld (wDiggingUpEnemiesForbidden),a
	ld hl,mainScripts.companionScript_subid00Script
	jp interactionSetScript


companionScript_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictHigherX

companionScript_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictLowerY

companionScript_subid04:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictHigherY

companionScript_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw companionScript_genericState0
	.dw companionScript_restrictLowerX


; Delete self if game is completed; otherwise, stay in state 0 until Link mounts the
; companion.
companionScript_genericState0:
	ld a,(wFileIsCompleted)
	or a
	jp nz,companionScript_deleteSelf
	ld a,(wLinkObjectIndex)
	rrca
	ret nc

	ld a,$01
	ld (de),a

	ld a,(w1Companion.id)
	sub SPECIALOBJECT_RICKY
	ld e,Interaction.var30
	ld (de),a
	add <wRickyState
	ld l,a
	ld h,>wRickyState
	bit 7,(hl)
	jp nz,companionScript_deleteSelf
	ret

companionScript_restrictHigherX:
	call companionScript_cpXToCompanion
	ret c
	inc a
	jr ++

companionScript_restrictLowerX:
	call companionScript_cpXToCompanion
	ret nc
	jr ++

companionScript_restrictLowerY:
	call companionScript_cpYToCompanion
	ret nc
	jr ++

companionScript_restrictHigherY:
	call companionScript_cpYToCompanion
	ret c
	inc a
	jr ++

++
	ld c,a
	ld a,(wLinkObjectIndex)
	rrca
	ret nc

	ld a,c
	ld (hl),a

	ld l,SpecialObject.speed
	ld (hl),SPEED_0

	ld e,Interaction.var30
	ld a,(de)
	ld hl,companionScript_companionBarrierText
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	jp showText

companionScript_cpYToCompanion:
	ld e,Interaction.yh
	ld a,(de)
	ld hl,w1Companion.yh
	cp (hl)
	ret

companionScript_cpXToCompanion:
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Companion.xh
	cp (hl)
	ret

; Text to show when you try to pass the "barriers" imposed.
companionScript_companionBarrierText:
	.dw TX_2007 ; Ricky
	.dw TX_2105 ; Dimitri
	.dw TX_2209 ; Moosh


; Companion barrier to Symmetry City, until the tuni nut is restored
companionScript_subid0d:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jp nz,companionScript_deleteSelf

	ld a,(wScrollMode)
	and (SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02)
	ret nz
	ld hl,w1Companion.enabled
	ldi a,(hl)
	or a
	ret z

	ldi a,(hl)
	cp SPECIALOBJECT_FIRST_COMPANION
	ret c
	cp SPECIALOBJECT_LAST_COMPANION+1
	ret nc

	; Check if the companion is roughly at this object's position
.ifndef REGION_JP
	ld l,SpecialObject.xh
	ld e,Interaction.xh
	ld a,(de)
	sub (hl)
	add $05
	cp $0b
	ret nc
.endif
	ld l,SpecialObject.yh
	ld e,Interaction.yh
	ld a,(de)
	cp (hl)
	ret c

	; If so, prevent companion from moving any further up
	inc a
	ld (hl),a
	ld l,SpecialObject.speed
	ld (hl),$00
	ld l,SpecialObject.state
	ldi a,(hl)

	; If it's Dimitri being held, make Link drop him
	cp $02
	jr nz,+
	ld (hl),$03
	call dropLinkHeldItem
+
	ld a,(wAnimalCompanion)
	sub SPECIALOBJECT_FIRST_COMPANION
	ld hl,@textIndices
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	jp showText

; Text to show as the excuse why they can't go into Symmetry City
@textIndices:
	.dw TX_200a
	.dw TX_2109
	.dw TX_220a


; Ricky script when he loses his gloves
companionScript_subid03:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,$01
	ld (de),a
	ld hl,wRickyState
	ld a,(hl)
	and $20
	jr nz,companionScript_deleteSelf
	ld hl,mainScripts.companionScript_subid03Script
	jp interactionSetScript


; Dimitri script where he's harrassed by tokays
companionScript_subid07:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,(wDimitriState)
	and $20
	jr nz,companionScript_deleteSelf
	ld a,$01
	ld (de),a
	ld hl,mainScripts.companionScript_subid07Script
	jp interactionSetScript


; Dimitri script where he leaves Link after bringing him to the mainland
companionScript_subid06:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	; Delete self if dimitri isn't here or the event has happened already
	ld a,(wDimitriState)
	and $40
	jr nz,companionScript_deleteSelf
	ld hl,w1Companion.id
	ld a,(hl)
	cp SPECIALOBJECT_DIMITRI
	jr nz,companionScript_deleteSelf

	; Return if Dimitri's still in the water
	ld l,SpecialObject.var38
	ld a,(hl)
	or a
	ret nz

	ld a,$01
	ld (de),a

.ifdef ENABLE_US_BUGFIXES
	; This is supposed to prevent a softlock that occurs by doing a screen transition before
	; Dimitri talks. But it doesn't work! Something else resets this back to 0.
	ld (wDisableScreenTransitions),a
.endif

	; Manipulate Dimitri's state to force a dismount
	ld l,SpecialObject.var03
	ld (hl),$02
	inc l
	ld (hl),$0a

	ld hl,mainScripts.companionScript_subid06Script
	jp interactionSetScript

companionScript_deleteSelf:
	jp interactionDelete


; A fairy appears to tell you about the animal companion in the forest
companionScript_subid08:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw companionScript_runScript

@state0:
	; Clear $10 bytes starting at $cfd0
	ld hl,wTmpcfc0.fairyHideAndSeek.active
	ld b,$10
	call clearMemory

	ld a,GLOBALFLAG_CAN_BUY_FLUTE
	call unsetGlobalFlag

	ld l,<wAnimalCompanion
	ld a,(hl)
	or a
	jr nz,+
	ld a,SPECIALOBJECT_MOOSH
	ld (hl),a
+
	sub SPECIALOBJECT_FIRST_COMPANION
	add <TX_1123
	ld (wTextSubstitutions),a

	ld a,(wScreenTransitionDirection)
	cp DIR_LEFT
	jr nz,companionScript_deleteSelf

	ld a,GLOBALFLAG_TALKED_TO_HEAD_CARPENTER
	call checkGlobalFlag
	jr z,companionScript_deleteSelf

	call getThisRoomFlags
	bit 6,a
	jr nz,companionScript_deleteSelf
	jp interactionIncState

@state1:
	; Wait for Link to trigger the fairy
	ld a,(w1Link.xh)
	cp $50
	ret nc

	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	call putLinkOnGround

	ldbc INTERAC_FOREST_FAIRY, $03
	call objectCreateInteraction
	ld l,Interaction.var03
	ld (hl),$0f
	ld hl,mainScripts.companionScript_subid08Script
	call interactionSetScript
	jp interactionIncState


; Companion script where they're found in the fairy forest
companionScript_subid09:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,$01
	ld (de),a

	xor a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a

	; Check whether the event is applicable right now
	ld a,GLOBALFLAG_TALKED_TO_HEAD_CARPENTER
	call checkGlobalFlag
	jr z,companionScript_deleteSelf

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jp nz,companionScript_deleteSelf

	; Put companion index (0-2) in var39
	ld hl,wAnimalCompanion
	ld a,(hl)
	sub SPECIALOBJECT_FIRST_COMPANION
	ld e,Interaction.var39
	ld (de),a

	ld c,a
	ld hl,@animationWhenNoticingLink
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var38
	ld (de),a

	ld a,c
	add a
	ld hl,@data1
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wTextSubstitutions),a
	call checkIsLinkedGame
	jr z,+
	ldi a,(hl)
+
	ldi a,(hl)
	ld (wTextSubstitutions+1),a
	ld hl,mainScripts.companionScript_subid09Script
	jp interactionSetScript


; b0: first text to show
; b1: text to show after that (unlinked)
; b2: text to show after that (linked)
@data1:
	.db <TX_1133, <TX_1134, <TX_1135, $00
	.db <TX_113a, <TX_113b, <TX_113c, $00
	.db <TX_1141, <TX_1142, <TX_1143, $00

@animationWhenNoticingLink:
	.db $00 ; Ricky
	.db $1e ; Dimitri
	.db $03 ; Moosh


; Script just outside the forest, where you get the flute
companionScript_subid0a:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript
	.dw companionScript_subid0a_state2
	.dw companionScript_subid0a_state3

@state0:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST
	call checkGlobalFlag
	jp z,companionScript_delete

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jp nz,companionScript_delete

	ld a,$01
	ld (de),a ; [state] = 1
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a

	ld a,DIR_UP
	ld (w1Link.direction),a

	; Put companion index (0-2) in var39
	ld hl,wAnimalCompanion
	ld a,(hl)
	sub SPECIALOBJECT_FIRST_COMPANION
	ld e,Interaction.var39
	ld (de),a

	; Determine text to show for this companion
	add a
	ld hl,@textIndices
	rst_addDoubleIndex
	ldi a,(hl)
	ld (wTextSubstitutions+1),a
	call checkIsLinkedGame
	jr z,+
	ldi a,(hl)
+
	ldi a,(hl)
	ld (wTextSubstitutions),a

	; Spawn in the fairies
	ld bc,$1103
@nextFairy:
	push bc
	ldbc INTERAC_FOREST_FAIRY, $04
	call objectCreateInteraction
	pop bc
	ld l,Interaction.var03
	ld (hl),b
	inc b
	dec c
	jr nz,@nextFairy

	ld hl,mainScripts.companionScript_subid0aScript
	jp interactionSetScript


; b0: Second text to show (after giving you the flute)
; b1: First text to show (unlinked)
; b2: First text to show (linked)
@textIndices:
	.db <TX_1139, <TX_1136, <TX_1137, $00 ; Ricky
	.db <TX_1140, <TX_113d, <TX_113e, $00 ; Dimitri
	.db <TX_1147, <TX_1144, <TX_1145, $00 ; Moosh


; Script in first screen of forest, where fairy leads you to the companion
companionScript_subid0b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScript

@state0:
	ld a,(wScreenTransitionDirection)
	cp DIR_DOWN
	jr nz,companionScript_delete
	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST
	call checkGlobalFlag
	jr z,companionScript_delete

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jr nz,companionScript_delete

	ldbc INTERAC_FOREST_FAIRY, $03
	call objectCreateInteraction
	ld l,Interaction.var03
	ld (hl),$14

	ld a,$81
	ld (wMenuDisabled),a
	ld (wDisabledObjects),a

	xor a
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a

	ld hl,mainScripts.companionScript_subid0bScript
	call interactionSetScript
	jp interactionIncState


; Sets bit 6 of wDimitriState so he disappears from Tokay Island
companionScript_subid0c:
	ld a,(wDimitriState)
	bit 5,a
	jr z,companionScript_delete
	or $40
	ld (wDimitriState),a
	jr companionScript_delete

;;
companionScript_subid00_state1:
	; If var3a is nonzero, make Moosh shake in fear
	ld e,Interaction.var3a
	ld a,(de)
	or a
	jr z,companionScript_runScript

	dec a
	ld (de),a
	and $03
	jr nz,companionScript_runScript
	ld a,(w1Companion.xh)
	xor $02
	ld (w1Companion.xh),a

companionScript_runScript:
	call interactionRunScript
	ret nc
	call setStatusBarNeedsRefreshBit1
companionScript_delete:
	jp interactionDelete


; This is the part which gives Link the flute.
companionScript_subid0a_state2:
	ld a,TREASURE_FLUTE
	call checkTreasureObtained
	ld c,<TX_0038
	jr nc,+
	ld c,<TX_0069
+
	ld e,Interaction.var39 ; Companion index
	ld a,(de)
	add c
	ld c,a
	ld b,>TX_0038
	call showText

	ld a,$01
	ld (wMenuDisabled),a
	call interactionIncState

	; Set wFluteIcon
	ld e,Interaction.var39
	ld a,(de)
	ld c,a
	inc a
	ld (de),a
	ld hl,wFluteIcon
	ld (hl),a

	; Set bit 7 of wRickyState / wDimitriState / wMooshState
	add <wCompanionStates - 1
	ld l,a
	set 7,(hl)

	; Give flute
	ld a,TREASURE_FLUTE
	call giveTreasure
	ld hl,wStatusBarNeedsRefresh
	set 0,(hl)

	; Turn this object into the flute graphic?
	ld e,Interaction.subid
	xor a
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,$0a
	ld (de),a

	; Set this object's palette
	ld e,Interaction.var39
	ld a,(de)
	ld c,a
	and $01
	add a
	xor c
	ld e,Interaction.oamFlags
	ld (de),a

	; Set this object's position
	ld hl,w1Link
	ld bc,$f200
	call objectTakePositionWithOffset

	; Make Link hold it over his head
	ld hl,wLinkForceState
	ld a,LINK_STATE_04
	ldi (hl),a
	ld (hl),$01 ; [wcc50] = $01
	call objectSetVisible80
	jp interactionRunScript


companionScript_subid0a_state3:
	call retIfTextIsActive

	; ??
	ld a,(wLinkObjectIndex)
	and $0f
	add a
	swap a
	ld (wDisabledObjects),a

	; Make flute disappear, wait for script to end
	call objectSetInvisible
	call interactionRunScript
	ret nc

	; Clean up, delete self
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	jp companionScript_delete
