; ==================================================================================================
; INTERAC_SMALL_KEY_ON_ENEMY
; ==================================================================================================
interactionCode77:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags
	and ROOMFLAG_ITEM
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	ld b,a
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextEnemy:
	ld a,(hl)
	cp b
	jr z,@foundMatch
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1

	; BUG: Original game does "jp c", meaning this only works if the enemy in
	; question is in the first enemy slot.
.ifdef ENABLE_BUGFIXES
	jp nc,interactionDelete
.else
	jp c,interactionDelete
.endif
	jr @nextEnemy

; Found the enemy to attach the key to
@foundMatch:
	dec l
	ld a,l
	ld e,Interaction.relatedObj2
	ld (de),a
	ld a,h
	inc e
	ld (de),a
	call interactionInitGraphics
	call objectSetVisible80
	call interactionIncState

@takeRelatedObj2Position:
	ld a,Object.y
	call objectGetRelatedObject2Var
	jp objectTakePosition

@state1: ; Copies the position of relatedObj2
	ld a,Object.enabled
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	jp z,interactionIncState

	call @takeRelatedObj2Position
	ld a,Object.visible
	call objectGetRelatedObject2Var
	ld b,$01
	jp objectFlickerVisibility

@state2: ; relatedObj2 is gone, fall to the ground and create a key
	call objectSetVisible
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ldbc TREASURE_SMALL_KEY,$00
	call createTreasure
	call objectCopyPosition
	jp interactionDelete
