; ==================================================================================================
; INTERAC_OLD_MAN
; ==================================================================================================
interactionCode52:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06

; Old man who takes a secret to give you the shield (same spot as subid $02)
@runSubid00:
	call checkInteractionState
	jr nz,@@state1


@@state0:
	call @loadScriptAndInitGraphics
@@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate


; Old man who gives you book of seals
@runSubid01:
	call checkInteractionState
	call z,@loadScriptAndInitGraphics
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc


; Old man guarding fairy powder in past (same spot as subid $00)
@runSubid02:
	call checkInteractionState
	jr nz,@@state1

@@state0:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	call @loadScriptAndInitGraphics

@@state1:
	call interactionAnimateAsNpc
	call interactionRunScript
	ret nc
	ld a,SND_TELEPORT
	call playSound
	ld hl,@warpDest
	jp setWarpDestVariables

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5ec, $00, $17, $03


; Generic NPCs in the past library
@runSubid03:
@runSubid04:
@runSubid05:
@runSubid06:
	call checkInteractionState
	jr z,@@state0

@@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.textID+1
	ld (hl),>TX_3300

	ld l,Interaction.collisionRadiusX
	ld (hl),$06
	ld l,Interaction.direction
	dec (hl)

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld b,$00
	jr z,+
	inc b
+
	ld e,Interaction.subid
	ld a,(de)
	sub $03
	ld c,a
	add a
	add b
	ld hl,@textIndices
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a

	ld a,c
	add a
	add c
	ld hl,@baseVariables
	rst_addAToHl
	ld e,Interaction.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.oamFlagsBackup
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ld e,Interaction.var38
	ld a,(hl)
	ld (de),a
	call interactionSetAnimation
	call objectSetVisiblec2

	ld hl,mainScripts.oldManScript_generic
	jp interactionSetScript


; b0: collisionRadiusY
; b1: oamFlagsBackup
; b2: animation (can be thought of as direction to face?)
@baseVariables:
	.db $12 $02 $02
	.db $06 $00 $00
	.db $06 $00 $00
	.db $06 $01 $02

; The first and second columns are the text to show before and after the water pollution
; is fixed, respectively.
@textIndices:
	.db <TX_3300, <TX_3301
	.db <TX_3302, <TX_3303
	.db <TX_3304, <TX_3305
	.db <TX_3306, <TX_3307

@func_669d: ; Unused?
	call interactionInitGraphics
	jp interactionIncState

@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.oldManScript_givesShieldUpgrade
	.dw mainScripts.oldManScript_givesBookOfSeals
	.dw mainScripts.oldManScript_givesFairyPowder
