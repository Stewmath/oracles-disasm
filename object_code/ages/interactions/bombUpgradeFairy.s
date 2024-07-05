; ==================================================================================================
; INTERAC_BOMB_UPGRADE_FAIRY
; ==================================================================================================
interactionCode83:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw bombUpgradeFairy_subid00
	.dw bombUpgradeFairy_subid01
	.dw bombUpgradeFairy_subid02

bombUpgradeFairy_subid00:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY
	call checkGlobalFlag
	jp nz,interactionDelete

	call getThisRoomFlags
	bit 0,a
	jp z,interactionDelete

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	ld l,Interaction.collisionRadiusY
	inc (hl)
	inc l
	ld (hl),$12

	ld hl,wTextNumberSubstitution
	ld a,(wMaxBombs)
	cp $10
	ld a,$30
	jr z,+
	ld a,$50
+
	ldi (hl),a
	xor a
	ld (hl),a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a
	ld ($cfd0),a
	ret

@state1:
	; Bombs are hardcoded to set this variable to $01 when it falls into water on this
	; screen. Hold execution until that happens.
	ld a,(wTmpcfc0.bombUpgradeCutscene.state)
	dec a
	ret nz

	ld a,(w1Link.zh)
	or a
	ret nz

	; Check that Link's in position
	ldh a,(<hEnemyTargetY)
	sub $41
	cp $06
	ret nc
	ldh a,(<hEnemyTargetX)
	sub $58
	cp $21
	ret nc

	call checkLinkVulnerable
	ret nc

	ldbc INTERAC_PUFF, $02
	call objectCreateInteraction
	ret nz
	ld e,Interaction.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a

	call clearAllParentItems
	call dropLinkHeldItem

	xor a
	ld (w1Link.direction),a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a

	ld a,$80
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	call setLinkForceStateToState08
	jp interactionIncState

@state2:
	; Wait for signal to spawn in silver and gold bombs?
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	call interactionIncState
	ld l,Interaction.yh
	ld (hl),$28

	ldbc INTERAC_SPARKLE, $0e
	call objectCreateInteraction

	call objectSetVisible81
	ld hl,mainScripts.bombUpgradeFairyScript
	call interactionSetScript

	ld b,$00
	call @spawnSubid2Instance

	ld b,$01

@spawnSubid2Instance:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_BOMB_UPGRADE_FAIRY
	inc l
	ld (hl),$02
	inc l
	ld (hl),b
	ret

@state3:
	call interactionAnimate
	ld a,(wTextIsActive)
	or a
	ret nz
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionRunScript
	ret nc

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a

	call objectCreatePuff
	jp interactionDelete


; Bombs that surround Link (depending on his answer)
bombUpgradeFairy_subid01:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.var03
	ld a,(hl)
	add a
	add (hl)

	ld hl,@bombPositions
	rst_addAToHl
	ld e,Interaction.yh
	ldh a,(<hEnemyTargetY)
	add (hl)
	ld (de),a
	ld e,Interaction.xh
	inc hl
	ldh a,(<hEnemyTargetX)
	add (hl)
	ld (de),a

	ld e,Interaction.counter1
	inc hl
	ld a,(hl)
	ld (de),a
	ret

@bombPositions:
	.db $00 $f0 $01
	.db $10 $00 $0f
	.db $00 $10 $1e
	.db $f0 $00 $2d

@state1:
	call interactionDecCounter1
	ret nz
	ld l,e
	inc (hl)
	call objectCreatePuff
	jp objectSetVisible82

@state2:
	ld a,($cfd0)
	inc a
	jp z,interactionDelete

	; Flash the bomb between blue and red palettes
	call interactionDecCounter1
	ld a,(hl)
	and $03
	ret nz

	ld l,Interaction.oamFlagsBackup
	ld a,(hl)
	xor $01
	ldi (hl),a
	ld (hl),a
	ret


; Gold/silver bombs
bombUpgradeFairy_subid02:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	ld a,PALH_80
	call loadPaletteHeader
	call interactionIncState

	ld e,Interaction.var03
	ld a,(de)
	or a
	ld b,$5a
	jr z,++
	ld l,Interaction.oamFlagsBackup
	ld a,$06
	ldi (hl),a
	ld (hl),a
	ld b,$76
++
	ld l,Interaction.yh
	ld (hl),$3c
	ld l,Interaction.xh
	ld (hl),b

	ldbc INTERAC_PUFF, $02
	call objectCreateInteraction
	ret nz
	ld e,Interaction.relatedObj2
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

@state1:
	; Wait for the puff to finish, then make self visible
	ld a,Object.animParameter
	call objectGetRelatedObject1Var
	bit 7,(hl)
	ret nz
	call interactionIncState
	jp objectSetVisible82

@state2:
	ld a,($cfd0)
	or a
	ret z
	call objectCreatePuff
	jp interactionDelete
