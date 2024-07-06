; ==================================================================================================
; INTERAC_MAKU_SPROUT
;
; Variables:
;   var3b: Animation
;   var3d: 0 for present maku tree, 1 for past?
;   var3e: "Script mode"; mainly determines animation (see makuSprout_subid00Script_body)
;   var3f: Text index to show for (sometimes shows the one after it as well)
; ==================================================================================================
interactionCode88:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	call checkInteractionState
	jr nz,@subid0State1

	ld a,$01
	ld e,Interaction.var3d
	ld (de),a

	call @initSubid0
	call @initializeMakuSprout

@subid0State1:
	call interactionAnimateAsNpc
	ld e,Interaction.visible
	ld a,(de)
	and $8f
	ld (de),a
	jp interactionRunScript

@subid1:
	call checkInteractionState
	jr nz,@subid1State1
	call @initializeMakuSprout
	call interactionRunScript

@subid1State1:
	jr @subid0State1

@subid2:
	call checkInteractionState
	jr nz,@subid2State1

	call @initializeMakuSprout
	ld a,$01
	jp interactionSetAnimation

@subid2State1:
	call checkInteractionSubstate
	jp nz,interactionAnimate

	ld a,(wTmpcfc0.genericCutscene.state)
	cp $06
	ret nz

	call interactionIncSubstate
	jp objectSetVisible82


@initSubid0:
	ld a,(wMakuTreeState)
	rst_jumpTable
	.dw @state00
	.dw @state01
	.dw @state02
	.dw @state03
	.dw @state04
	.dw @state05
	.dw @state06
	.dw @state07
	.dw @state08
	.dw @state09
	.dw @state0a
	.dw @state0b
	.dw @state0c
	.dw @state0d
	.dw @state0e
	.dw @state0f
	.dw @state10

@state01:
@state02:
	ld a,$01
	jr @runSubidCode

@state03:
@state04:
@state05:
	ldbc $01, <TX_0570
	jr @runSubid0ScriptMode

@state06:
	ldbc $00, <TX_0576
	jr @runSubid0ScriptMode

@state07:
	ldbc $00, <TX_0578
	jr @runSubid0ScriptMode

@state08:
	ldbc $02, <TX_057a
	jr @runSubid0ScriptMode

@state09:
	ldbc $01, <TX_057c
	jr @runSubid0ScriptMode

@state0a:
	ldbc $01, <TX_057e
	jr @runSubid0ScriptMode

@state0b:
	ldbc $00, <TX_0580
	jr @runSubid0ScriptMode

@state0c:
	ldbc $00, <TX_0582
	jr @runSubid0ScriptMode

@state0d:
	ldbc $01, <TX_0584
	jr @runSubid0ScriptMode

@state0e:
	ldbc $01, <TX_0586
	jr @runSubid0ScriptMode

@state0f:
	ldbc $02, <TX_0588
	jr @runSubid0ScriptMode

@state10:
	call checkIsLinkedGame
	jr z,++

	ldbc $00, <TX_058a
	jr @runSubid0ScriptMode
++
	ldbc $01, <TX_058c
	jr @runSubid0ScriptMode

@runSubidCode:
	ld e,Interaction.subid
	ld (de),a
	pop af
	jp interactionCode88

@runSubid0ScriptMode:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),b
	inc l
	ld (hl),c

@state00:
	ret


@initializeMakuSprout:
	call @loadScriptAndInitGraphics
	jp interactionSetAlwaysUpdateBit


@initGraphics: ; unused
	call interactionInitGraphics
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld a,>TX_0500
	call interactionSetHighTextIndex
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
	.dw mainScripts.makuSprout_subid00Script
	.dw mainScripts.makuSprout_subid01Script
	.dw mainScripts.stubScript
