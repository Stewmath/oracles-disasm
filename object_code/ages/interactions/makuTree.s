; ==================================================================================================
; INTERAC_MAKU_TREE
;
; Variables:
;   var3b: Animation
;   var3d: 0 for present maku tree, 1 for past?
;   var3e: "Script mode"; mainly determines animation (see makuTree_subid00Script_body)
;   var3f: Text index to show for (sometimes shows the one after it as well)
; ==================================================================================================
interactionCode87:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06

@subid00:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	xor a
	ld e,Interaction.var3d
	ld (de),a
	call @initSubid00
	call @initializeMakuTree
	jr @runScriptAndAnimate

@subid01:
@subid02:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	call @initializeMakuTree
	call interactionRunScript
	ld e,Interaction.subid
	ld a,(de)
	dec a
	jr nz,@runScriptAndAnimate

	; Subid 1 only: make Link move right/up to approach the maku tree, starting the
	; "maku tree disappearance" cutscene

	ld a,PALH_8f
	call loadPaletteHeader

	ld hl,@simulatedInput
	ld a,:@simulatedInput
	push de
	call setSimulatedInputAddress
	pop de

	xor a
	ld (w1Link.direction),a
	jr @runScriptAndAnimate

@simulatedInput:
	dwb 60 $00
	dwb 48 BTN_RIGHT
	dwb  4 $00
	dwb 14 BTN_UP
	dwb 60 $00
	.dw $ffff

@runScriptAndAnimate:
	call interactionRunScript
	jp interactionAnimate

@subid03:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	ld b,$01
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $03
	jr z,+
	call interactionLoadExtraGraphics
	ld b,$00
+
	ld a,b
	call interactionSetAnimation
	call interactionInitGraphics
	call @loadScript
	jp @setVisibleAndSpawnFlower

@subid04:
@subid05:
	call checkInteractionState
	jr nz,@runScriptAndAnimate
	call @initializeMakuTree
	jr @runScriptAndAnimate

@subid06:
	call checkInteractionState
	jr nz,@runScriptAndAnimate

	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME
	call checkGlobalFlag
	jp nz,@initializeMakuTree
	ld hl,w1Link.direction
	ld (hl),$00
	call setLinkForceStateToState08
	call @initGraphicsAndIncState
	call @setVisibleAndSpawnFlower

	ld b,$00
	ld hl,mainScripts.makuTree_subid06Script_part1
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	push hl
	call checkGlobalFlag
	pop hl
	jr z,+
	ld b,$04
	ld hl,mainScripts.makuTree_subid06Script_part2
+
	call interactionSetScript
	ld a,>TX_0500
	call interactionSetHighTextIndex
	ld a,b
	call interactionSetAnimation
	jp @runScriptAndAnimate

@initSubid00:
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

@state00:
	ld a,GLOBALFLAG_0c
	call checkGlobalFlag
	jr nz,@ret
	ld a,$01
	jr @runSubidCode

@state02:
	ld a,$02
	jr @runSubidCode

@state03:
	ldbc $02, <TX_0500
	jr @runSubid0ScriptMode

@state04:
	ldbc $00, <TX_0503
	jr @runSubid0ScriptMode

@state05:
	ldbc $00, <TX_0505
	jr @runSubid0ScriptMode

@state06:
	ldbc $00, <TX_0507
	jr @runSubid0ScriptMode

@state07:
	ldbc $04, <TX_0509
	jr @runSubid0ScriptMode

@state08:
	ldbc $04, <TX_050b
	jr @runSubid0ScriptMode

@state09:
	ldbc $02, <TX_050d
	jr @runSubid0ScriptMode

@state0a:
	ldbc $00, <TX_0510
	jr @runSubid0ScriptMode

@state0b:
	ldbc $05, <TX_0512
	jr @runSubid0ScriptMode

@state0c:
	ldbc $04, <TX_0514
	jr @runSubid0ScriptMode

@state0d:
	ldbc $00, <TX_0516
	jr @runSubid0ScriptMode

@state0e:
	ld a,$06
	jr @runSubidCode

@state0f:
	ldbc $00, <TX_0518
	jr @runSubid0ScriptMode

@state10:
	call checkIsLinkedGame
	jr z,++
	ldbc $00, <TX_051a
	jr @runSubid0ScriptMode
++
	ldbc $01, <TX_051c
	jr @runSubid0ScriptMode

@state01:
	pop af
	jp interactionDelete

@runSubidCode:
	ld e,Interaction.subid
	ld (de),a
	pop af
	jp interactionCode87

@runSubid0ScriptMode:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),b
	inc l
	ld (hl),c
@ret:
	ret


@initializeMakuTree:
	call @initGraphicsAndLoadScript

@setVisibleAndSpawnFlower:
	call objectSetVisible83
	call interactionSetAlwaysUpdateBit
	jp @spawnMakuFlower

@initGraphicsAndIncState:
	call @initGraphics
	jp interactionIncState

@initGraphicsAndLoadScript:
	call @initGraphics
	jr @loadScript

@initGraphics:
	call interactionLoadExtraGraphics
	jp interactionInitGraphics

@loadScript:
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

@spawnMakuFlower:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_MAKU_FLOWER
	ld l,Interaction.relatedObj2
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	ld e,Interaction.relatedObj1
	ld a,Interaction.start
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	jp objectCopyPosition

@scriptTable:
	.dw mainScripts.makuTree_subid00Script
	.dw mainScripts.makuTree_subid01Script
	.dw mainScripts.makuTree_subid02Script
	.dw mainScripts.makuTree_subid03Script
	.dw mainScripts.makuTree_subid04Script
	.dw mainScripts.makuTree_subid05Script
	.dw mainScripts.makuTree_subid06Script_part3
