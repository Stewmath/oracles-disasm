; ==================================================================================================
; INTERAC_KING_MOBLIN_DEFEATED
; ==================================================================================================
interactionCode72:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Subid 0: King moblin / "parent" for other subids
@subid0:
	ld a,(de)
	or a
	jr z,@subid0State0

@subid0State1:
	call interactionRunScript
	jp nc,interactionAnimate
	call getFreeInteractionSlot
	ret nz

	; Spawn instance of this object with subid 2
	ld (hl),INTERAC_KING_MOBLIN_DEFEATED
	inc l
	ld (hl),$02
	ld l,Interaction.yh
	ld (hl),$68
	jp interactionDelete

@subid0State0:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,interactionDelete

	call setDeathRespawnPoint
	ld a,$80
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	call @spawnSubservientMoblin
	ld (hl),$38
	call @spawnSubservientMoblin
	ld (hl),$78

	ld hl,$cfd0
	ld b,$04
	call clearMemory

	ld a,$02
	call fadeinFromWhiteWithDelay
	ld hl,mainScripts.kingMoblinDefeated_kingScript

@setScriptAndInitStuff:
	call interactionSetScript
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld l,Interaction.angle
	ld (hl),ANGLE_DOWN
	jp objectSetVisible82


; Spawn an instance of subid 1, the normal moblins
@spawnSubservientMoblin:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_KING_MOBLIN_DEFEATED
	inc l
	inc (hl)
	ld l,Interaction.yh
	ld (hl),$68
	ld l,Interaction.xh
	ret


; Subid 1: Normal moblin following him
@subid1:
	ld a,(de)
	or a
	jr z,@subid1State0

@runScriptAndAnimate:
	call interactionRunScript
	jp nc,interactionAnimate
	jp interactionDelete

@subid1State0:
	ld hl,mainScripts.kingMoblinDefeated_helperMoblinScript
	jr @setScriptAndInitStuff


; Subid 2: Gorons who approach after he leaves (var03 = index)
@subid2:
	ld a,(de)
	or a
	jr nz,@runScriptAndAnimate

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80

	; Load script
	ld e,Interaction.var03
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	call objectSetVisible82

	; Load data from table
	ld e,Interaction.var03
	ld a,(de)
	add a
	ld hl,@goronData
	rst_addDoubleIndex
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.xh
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.angle
	ldi a,(hl)
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation

	; If [var03] == 0, spawn the other gorons
	ld e,Interaction.var03
	ld a,(de)
	or a
	ret nz

	ld b,$01
	call @spawnGoronInstance
	inc b
	call @spawnGoronInstance
	inc b

@spawnGoronInstance:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_KING_MOBLIN_DEFEATED
	inc l
	ld (hl),$02
	inc l
	ld (hl),b
	ret

@scriptTable:
	.dw mainScripts.kingMoblinDefeated_goron0
	.dw mainScripts.kingMoblinDefeated_goron1
	.dw mainScripts.kingMoblinDefeated_goron2
	.dw mainScripts.kingMoblinDefeated_goron3

; b0: Y
; b1: X
; b2: angle
; b3: animation
@goronData:
	.db $88 $38 $00 $04 ; $00 == [var03]
	.db $58 $a8 $18 $07 ; $01
	.db $88 $90 $00 $04 ; $02
	.db $88 $58 $00 $04 ; $03
