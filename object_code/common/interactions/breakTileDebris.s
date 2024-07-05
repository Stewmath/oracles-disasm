; ==================================================================================================
; INTERAC_GRASSDEBRIS (and other animations)
; ==================================================================================================

interactionCode00:
interactionCode01:
interactionCode02:
interactionCode03:
interactionCode04:
interactionCode05:
interactionCode06:
interactionCode07:
interactionCode08:
interactionCode09:
interactionCode0a:
interactionCode0b:
interactionCode0c:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.subid
	bit 1,(hl)
	call z,interactionSetAlwaysUpdateBit

	call @doSpecializedInitialization

	ld e,Interaction.id
	ld a,(de)
	ld hl,@soundAndPriorityTable
	rst_addDoubleIndex
	ld e,Interaction.subid
	ld a,(de)
	rlca
	ldi a,(hl)
	ld e,(hl)
	call nc,playSound
	ld a,e
	rst_jumpTable
	.dw objectSetVisible80
	.dw objectSetVisible81
	.dw objectSetVisible82
	.dw objectSetVisible83

@soundAndPriorityTable: ; $4037
	.db SND_CUTGRASS	$03	; 0x00
	.db SND_CUTGRASS	$03	; 0x01
	.db SND_NONE		$00	; 0x02
	.db SND_SPLASH		$03	; 0x03
	.db SND_SPLASH		$03	; 0x04
	.db SND_POOF		$00	; 0x05
	.db SND_BREAK_ROCK	$00	; 0x06
	.db SND_CLINK		$00	; 0x07
	.db SND_KILLENEMY	$00	; 0x08
	.db SND_NONE		$03	; 0x09
	.db SND_NONE		$03	; 0x0a
	.db SND_UNKNOWN5	$02	; 0x0b
	.db SND_BREAK_ROCK	$00	; 0x0c

@state1:
	ld h,d
	ld l,Interaction.animParameter
	bit 7,(hl)
	jp nz,interactionDelete

	ld l,Interaction.subid
	bit 0,(hl)
	jr z,++

	ld a,(wFrameCounter)
	xor d
	rrca
	ld l,Interaction.visible
	set 7,(hl)
	jr nc,++

	res 7,(hl)
++
	ld e,Interaction.id
	ld a,(de)
	cp INTERAC_SHOVELDEBRIS
	jr nz,+

	ld c,$60
	call objectUpdateSpeedZ_paramC
	call objectApplySpeed
+
	jp interactionAnimate

;;
; Does specific things for interactions 0 (underwater bush breaking) and $0a (shovel
; debris)
@doSpecializedInitialization:
	ld e,Interaction.id
	ld a,(de)
	or a
	jr z,@interac00

	cp INTERAC_SHOVELDEBRIS
	ret nz

@interac0A:
	ld bc,-$240
	call objectSetSpeedZ
	ld e,Interaction.direction
	ld a,(de)
	jp interactionSetAnimation

@interac00:
.ifdef ROM_AGES
	ld a,(wTilesetFlags)
	and TILESETFLAG_UNDERWATER
	jr z,+

	ld a,$0e
	jr ++
.endif
+
	ld a,(wGrassAnimationModifier)
	and $03
	or $08
++
	ld e,Interaction.oamFlagsBackup
	ld (de),a
	inc e
	ld (de),a
	ret

