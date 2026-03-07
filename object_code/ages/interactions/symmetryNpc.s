; ==================================================================================================
; INTERAC_SYMMETRY_NPC
; ==================================================================================================
interactionCodebf:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @runScriptAndAnimate
	.dw @state2

@state0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionIncState
	ld a,>TX_2d00
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @loadScript
	.dw @subid0cInit

@subid0cInit:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED
	call checkGlobalFlag
	jp z,interactionDelete

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

@scriptTable:
	.dw mainScripts.symmetryNpcSubid0And1Script
	.dw mainScripts.symmetryNpcSubid0And1Script
	.dw mainScripts.symmetryNpcSubid2And3Script
	.dw mainScripts.symmetryNpcSubid2And3Script
	.dw mainScripts.symmetryNpcSubid4And5Script
	.dw mainScripts.symmetryNpcSubid4And5Script
	.dw mainScripts.symmetryNpcSubid6And7Script
	.dw mainScripts.symmetryNpcSubid6And7Script
	.dw mainScripts.symmetryNpcSubid8And9Script
	.dw mainScripts.symmetryNpcSubid8And9Script
	.dw mainScripts.symmetryNpcSubidAScript
	.dw mainScripts.symmetryNpcSubidBScript
	.dw mainScripts.symmetryNpcSubidCScript


; For subids 8/9 (sisters in the tuni nut building)...
; Listen for a signal from the tuni nut object; change the script when it's placed.
@state2:
	ld hl,wTmpcfc0.genericCutscene.state
	bit 0,(hl)
	jr z,@runScriptAndAnimate

	ld hl,mainScripts.symmetryNpcSubid8And9Script_afterTuniNutRestored
	call interactionSetScript
	ld e,Interaction.state
	ld a,$01
	ld (de),a

@runScriptAndAnimate:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
