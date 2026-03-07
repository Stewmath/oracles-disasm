; ==================================================================================================
; INTERAC_ZELDA
; ==================================================================================================
interactionCode44:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw zelda_state0
	.dw zelda_state1

zelda_state0:
	ld a,$01
	ld (de),a
	ld e,$42
	ld a,(de)
	ld b,a
	ld hl,table_6ea3
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld a,b
	or a
	jr z,@subid0
	cp $08
	jr z,@subid8
	cp $09
	jr z,@subid9

@setVisibleInitGraphicsIncState:
	call objectSetVisible82
	call interactionInitGraphics
	jr zelda_state1

@subid0:
	ld a,$b0
	ld ($cc1d),a
	ld (wLoadedTreeGfxIndex),a
	
	call getThisRoomFlags
	bit 7,a
	jr z,+
	ld a,$01
	ld ($ccab),a
	ld a,(wActiveMusic)
	or a
	jr z,+
	xor a
	ld (wActiveMusic),a
	ld a,$38
	call playSound
+
	ld hl,$cbb3
	ld b,$10
	call clearMemory
	jr @setVisibleInitGraphicsIncState
@subid8:
	call checkGotMakuSeedDidNotSeeZeldaKidnapped
	bit 7,c
	jp nz,interactionDelete
	jr @setVisibleInitGraphicsIncState
@subid9:
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	jp nz,interactionDelete
	jr @setVisibleInitGraphicsIncState

zelda_state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @runSubid5
	.dw @runSubid6
	.dw @faceLinkAndRunScript
	.dw @runSubid8
	.dw @faceLinkAndRunScript

@animateAndRunScript:
	call interactionRunScript
	jp interactionAnimate

@runSubid5:
	call interactionRunScript
	ld e,$47
	ld a,(de)
	or a
	jp nz,interactionAnimate
	ret

@runSubid6:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimate

@faceLinkAndRunScript:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@runSubid8:
	ld a,GLOBALFLAG_TALKED_TO_ZELDA_BEFORE_ONOX_FIGHT
	call checkGlobalFlag
	jr nz,@faceLinkAndRunScript
	jr @animateAndRunScript

table_6ea3:
	.dw mainScripts.zeldaScript_ganonBeat
	.dw mainScripts.zeldaScript_afterEscapingRoomOfRites
	.dw mainScripts.zeldaScript_zeldaKidnapped
	.dw mainScripts.script5fe6
	.dw mainScripts.script5fe6
	.dw mainScripts.script5fea
	.dw mainScripts.script5fee
	.dw mainScripts.zeldaScript_withAnimalsHopefulText
	.dw mainScripts.zeldaScript_blessingBeforeFightingOnox
	.dw mainScripts.zeldaScript_healLinkIfNeeded
