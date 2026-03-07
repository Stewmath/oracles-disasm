; ==================================================================================================
; INTERAC_DIN
; ==================================================================================================
interactionCodea5:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw dinState0
	.dw dinState1
dinState0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	call objectSetVisiblec2
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subidStub
	.dw @subid4
	.dw @subidStub
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9
@subid0:
	ld h,d
	ld l,$4b
	ld (hl),$00
	inc l
	inc l
	ld (hl),$a0
	ld l,$66
	ld (hl),$20
	inc l
	ld (hl),$08
	ld l,$49
	ld (hl),$10
	ld l,$50
	ld (hl),$14
	jp setCameraFocusedObject
@subid1:
	ld h,d
	ld l,$4b
	ld (hl),$98
	inc l
	inc l
	ld (hl),$a0
	ret
@subid2:
	ld hl,mainScripts.dinScript_subid2Init
	jp interactionSetScript
@subid4:
	ld hl,mainScripts.dinScript_subid4Init
	jp interactionSetScript
@subid6:
	ld h,d
	ld l,$4b
	ld (hl),$48
	inc l
	inc l
	ld (hl),$80
@subidStub:
	ret
@subid7:
	ld hl,mainScripts.dinScript_stubInit
	jp interactionSetScript
@subid8:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete
	ld a,$06
	call interactionSetAnimation
	ld a,INTERAC_DIN
	ld (wInteractionIDToLoadExtraGfx),a
	ld (wLoadedTreeGfxIndex),a
	ld hl,mainScripts.dinScript_subid8Init
	jp interactionSetScript
@subid9:
	call getThisRoomFlags
	bit 6,a
	jp nz,interactionDelete
	ld hl,mainScripts.dinScript_discoverLinkCollapsed
	jp interactionSetScript

dinState1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw dinState1_subid0
	.dw dinState1_subid0@ret
	.dw dinState1_subid2
	.dw dinState1_subid3
	.dw dinState1_subid4
	.dw interactionAnimate
	.dw dinState1_subid6
	.dw dinState1_subid7
	.dw dinState1_subid8
	.dw dinState1_subid9

dinState1_subid0:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
@substate0:
	call interactionAnimate
	ld a,(wFrameCounter)
	and $0f
	call z,@func_6521
	call objectApplySpeed
	ld e,$4b
	ld a,(de)
	cp $90
	ret nz
	call interactionIncSubstate
	xor a
	ld (wDisabledObjects),a
	inc a
	ld ($ccab),a
	jp setCameraFocusedObjectToLink
@func_6521:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_SPARKLE
	inc l
	ld (hl),$05
	call getRandomNumber
	and $1f
	sub $10
	ld b,$00
	ld c,a
	jp objectCopyPositionWithOffset
@substate1:
	call objectOscillateZ
	call objectPreventLinkFromPassing
	ld c,$20
	call objectCheckLinkWithinDistance
	jp nc,interactionAnimate
	ld a,(wLinkInAir)
	or a
	ret nz
	call interactionIncSubstate
	ld a,$80
	ld (wDisabledObjects),a
	ld l,$46
	ld (hl),$32
	ld l,$4d
	ldd a,(hl)
	ld (hl),a
	ld hl,$d008
	ld (hl),$03
	call setLinkForceStateToState08
@ret:
	ret
@substate2:
	call interactionDecCounter1
	jr nz,@func_6576
	call interactionIncSubstate
	ld hl,$cbb3
	ld (hl),$00
	ld hl,$cbba
	ld (hl),$ff
	ret
@func_6576:
	call getRandomNumber_noPreserveVars
	and $03
	sub $02
	ld h,d
	ld l,$4c
	add (hl)
	inc l
	ld (hl),a
	jp interactionAnimate
@substate3:
	ld hl,$cbb3
	ld b,$01
	call flashScreen
	ret z
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	ld b,$04
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_DINS_CRYSTAL_FADING
	inc l
	ld (hl),b
	dec (hl)
	call objectCopyPosition
	dec b
	jr nz,-
+
	ld a,$05
	call interactionSetAnimation
	ld a,$8a
	call playSound
	jp clearPaletteFadeVariablesAndRefreshPalettes
@substate4:
	call interactionDecCounter1
	ret nz
	call interactionIncSubstate
	ld l,$50
	ld (hl),$28
	ld l,$60
	ld (hl),$01
	jp interactionAnimate
@substate5:
	call objectApplySpeed
	ld h,d
	ld l,$4b
	ld a,(hl)
	sub $98
	ret nz
	call interactionIncSubstate
	ld l,$4f
	ld (hl),a
	ld l,$60
	ld (hl),$01
	jp interactionAnimate
@substate6:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	or a
	ret z
	call interactionIncSubstate
	ld l,$46
	ld (hl),$1e
	jp npcFaceLinkAndAnimate
@substate7:
	call interactionDecCounter1
	ret nz
	ld a,$01
	ld ($cfdf),a
	ret

dinState1_subid2:
	ld a,($c4ab)
	or a
	ret nz
	call interactionAnimate
	jp interactionRunScript

dinState1_subid3:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	ld a,($cfc0)
	or a
	jr z,+
	call interactionIncSubstate
	ld bc,$ff00
	call objectSetSpeedZ
+
	jp interactionAnimate
@substate1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$0a
	ret
@substate2:
	call interactionDecCounter1
	ret nz
	ld a,$06
	jp interactionSetAnimation

dinState1_subid4:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
@substate0:
	ld a,($c4ab)
	or a
	ret nz
	call interactionAnimate
	call interactionRunScript
	ret nc
	ld bc,$ff20
	call objectSetSpeedZ
	ld l,$49
	ld (hl),$08
	ld l,$50
	ld (hl),$37
	jp interactionIncSubstate
@substate1:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionIncSubstate
	ld l,$60
	ld (hl),$20
@substate2:
	jp interactionAnimate

dinState1_subid6:
	call objectOscillateZ
	jp interactionAnimate

dinState1_subid7:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw interactionAnimate
@substate0:
	call interactionAnimate
	ld a,($cfc0)
	cp $04
	ret nz
	call interactionIncSubstate
	ld l,$46
	ld (hl),$78
	ld a,$08
	call interactionSetAnimation
	jp seasonsFunc_0a_6717
@substate1:
	call interactionDecCounter1
	jp nz,seasonsFunc_0a_6710
	call interactionIncSubstate
	xor a
	ld l,$4f
	ld (hl),a
	ld l,$46
	ld (hl),$1e
	jp interactionAnimate
@substate2:
	call interactionDecCounter1
	jr nz,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$3c
	ld bc,TX_3d09
	call showText
+
	jp interactionAnimate
@substate3:
	ld a,($cba0)
	or a
	jr nz,+
	call interactionDecCounter1
	jr nz,+
	call interactionIncSubstate
	ld hl,$cfc0
	ld (hl),$05
+
	jp interactionAnimate
	
dinState1_subid8:
	call interactionRunScript
	ld e,$78
	ld a,(de)
	or a
	call z,interactionAnimate
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
	
dinState1_subid9:
	ld e,$78
	ld a,(de)
	bit 7,a
	jr nz,+
	and $7f
	call nz,interactionAnimate
	call interactionAnimate
+
	call interactionRunScript
	ret nc
	ld a,GLOBALFLAG_SEASON_ALWAYS_SPRING
	call setGlobalFlag
	ld hl,@warpDestVariables
	jp setWarpDestVariables

@warpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_097 $00 $44 $83

seasonsFunc_0a_6710:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
seasonsFunc_0a_6717:
	ld bc,$ff00
	jp objectSetSpeedZ
