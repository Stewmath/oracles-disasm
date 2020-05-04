; ==============================================================================
; INTERACID_TREASURE
;
; State $04 is used as a way to delete a treasure? (Bomb flower cutscene with goron elder
; sets the bomb flower to state 4 to delete it.)
;
; Variables:
;   subid: overwritten by call to "interactionLoadTreasureData" to correspond to a certain
;          graphic.
;   var30: former value of subid (treasure index)
;
;   var31-var35 based on data from "treasureObjectData.s":
;     var31: spawn mode
;     var32: collect mode
;     var33: a boolean?
;     var34: parameter (value of 'c' for "giveTreasure" function)
;     var35: low text ID
;   var39: If set, this is part of the chest minigame? Gets written to "wDisabledObjects"?
; ==============================================================================
interactionCode60:
	ld e,Interaction.state		; $4973
	ld a,(de)		; $4975
	rst_jumpTable			; $4976
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw interactionDelete

@state0:
	ld a,$01		; $4981
	ld (de),a		; $4983
.ifdef ROM_AGES
	callab bank16.interactionLoadTreasureData		; $4984
.else
	callab scriptHlp.interactionLoadTreasureData		; $4984
.endif
	ld a,$06		; $498c
	call objectSetCollideRadius		; $498e

	; Check whether to overwrite the "parameter" for the treasure?
	ld l,Interaction.var38		; $4991
	ld a,(hl)		; $4993
	or a			; $4994
	jr z,+			; $4995
	cp $ff			; $4997
	jr z,+			; $4999
	ld l,Interaction.var34		; $499b
	ld (hl),a		; $499d
+
	call interactionInitGraphics		; $499e

	ld e,Interaction.var31		; $49a1
	ld a,(de)		; $49a3
	or a			; $49a4
	ret nz			; $49a5
	jp objectSetVisiblec2		; $49a6


; State 1: spawning in; goes to state 2 when finished spawning.
@state1:
	ld e,Interaction.var31		; $49a9
	ld a,(de)		; $49ab
	rst_jumpTable			; $49ac
	.dw @spawnMode0
	.dw @spawnMode1
	.dw @spawnMode2
	.dw @spawnMode3
	.dw @spawnMode4
	.dw @spawnMode5
	.dw @spawnMode6

; Spawns instantly
@spawnMode0:
	ld h,d			; $49bb
	ld l,Interaction.state		; $49bc
	ld (hl),$02		; $49be
	inc l			; $49c0
	ld (hl),$00		; $49c1
	call @checkLinkTouched		; $49c3
	jp c,@gotoState3		; $49c6
	jp objectSetVisiblec2		; $49c9

; Appears with a poof
@spawnMode1:
	ld e,Interaction.state2		; $49cc
	ld a,(de)		; $49ce
	or a			; $49cf
	jr nz,++		; $49d0

	ld a,$01		; $49d2
	ld (de),a		; $49d4
	ld e,Interaction.counter1		; $49d5
	ld a,$1e		; $49d7
	ld (de),a		; $49d9
	call objectCreatePuff		; $49da
	ret nz			; $49dd
++
	call interactionDecCounter1		; $49de
	ret nz			; $49e1
	jr @spawnMode0			; $49e2

; Falls from top of screen
@spawnMode2:
	ld e,Interaction.state2		; $49e4
	ld a,(de)		; $49e6
	rst_jumpTable			; $49e7
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	ld a,$01		; $49ee
	ld (de),a		; $49f0
	ld h,d			; $49f1
	ld l,Interaction.counter1		; $49f2
	ld (hl),$28		; $49f4
	ld a,SND_SOLVEPUZZLE	; $49f6
	jp playSound		; $49f8

@@substate1:
	call interactionDecCounter1		; $49fb
	ret nz			; $49fe
	ld (hl),$02		; $49ff
	inc l			; $4a01
	ld (hl),$02		; $4a02

	ld l,Interaction.state2		; $4a04
	inc (hl)		; $4a06

	call objectGetZAboveScreen		; $4a07
	ld h,d			; $4a0a
	ld l,Interaction.zh		; $4a0b
	ld (hl),a		; $4a0d

	call objectSetVisiblec0		; $4a0e
	jp @setVisibleIfWithinScreenBoundary		; $4a11

@@substate2:
	call @checkLinkTouched		; $4a14
	jr c,@gotoState3		; $4a17
	call @setVisibleIfWithinScreenBoundary		; $4a19
	ld c,$10		; $4a1c
	call objectUpdateSpeedZ_paramC		; $4a1e
	ret nz			; $4a21
	call objectCheckIsOnHazard		; $4a22
	jr nc,+			; $4a25

	dec a			; $4a27
	jr z,@landedOnWater		; $4a28
	jp objectReplaceWithFallingDownHoleInteraction		; $4a2a
+
.ifdef ROM_AGES
	ld a,SND_DROPESSENCE		; $4a2d
	call playSound		; $4a2f
.else
	ld e,Interaction.var30		; $40ba
	ld a,(de)		; $40bc
	cp $30			; $40bd
	ld a,SND_DROPESSENCE		; $40bf
	call z,playSound		; $40c1
.endif
	call interactionDecCounter1		; $4a32
	jr z,@gotoState2			; $4a35

	ld bc,$ff56		; $4a37
	jp objectSetSpeedZ		; $4a3a

@gotoState2:
	call objectSetVisible		; $4a3d
	call objectSetVisiblec2		; $4a40
	ld a,$02		; $4a43
	jr @gotoStateAndAlwaysUpdate			; $4a45

@setVisibleIfWithinScreenBoundary:
	call objectCheckWithinScreenBoundary		; $4a47
	jp nc,objectSetInvisible		; $4a4a
	jp objectSetVisible		; $4a4d

@gotoState3:
	call @giveTreasure		; $4a50
	ld a,$03		; $4a53

@gotoStateAndAlwaysUpdate:
	ld h,d			; $4a55
	ld l,Interaction.state		; $4a56
	ldi (hl),a		; $4a58
	xor a			; $4a59
	ld (hl),a		; $4a5a

	ld l,Interaction.z		; $4a5b
	ldi (hl),a		; $4a5d
	ld (hl),a		; $4a5e

	jp interactionSetAlwaysUpdateBit		; $4a5f

; If the treasure fell into the water, "reset" this object to state 0, increment var03.
@landedOnWater:
	ld h,d			; $4a62
	ld l,Interaction.var30		; $4a63
	ld a,(hl)		; $4a65
	ld l,Interaction.subid		; $4a66
	ldi (hl),a		; $4a68

	inc (hl) ; [var03]++ (use the subsequent entry in treasureObjectData)

	; Clear state
	inc l			; $4a6a
	xor a			; $4a6b
	ldi (hl),a		; $4a6c
	ld (hl),a		; $4a6d

	ld l,Interaction.visible		; $4a6e
	res 7,(hl)		; $4a70
	ld b,INTERACID_SPLASH		; $4a72
	jp objectCreateInteractionWithSubid00		; $4a74


; Spawns from a chest
@spawnMode3:
	ld a,$80		; $4a77
	ld (wForceLinkPushAnimation),a		; $4a79
	ld e,Interaction.state2		; $4a7c
	ld a,(de)		; $4a7e
	rst_jumpTable			; $4a7f
	.dw @m3State0
	.dw @m3State1
	.dw @m3State2

@m3State0:
	ld a,$01		; $4a86
	ld (de),a		; $4a88
	ld (wDisableLinkCollisionsAndMenu),a		; $4a89
	call interactionSetAlwaysUpdateBit		; $4a8c

	; Angle is already $00 (up), so don't need to set it
	ld l,Interaction.speed		; $4a8f
	ld (hl),SPEED_40		; $4a91

	ld l,Interaction.counter1		; $4a93
	ld (hl),$20		; $4a95
	jp objectSetVisible80		; $4a97

@m3State1:
	; Move up
	call objectApplySpeed		; $4a9a
	call interactionDecCounter1		; $4a9d
	ret nz			; $4aa0

	; Finished moving up
	ld l,Interaction.state2		; $4aa1
	inc (hl)		; $4aa3
	ld l,Interaction.var39		; $4aa4
	ld a,(hl)		; $4aa6
	or a			; $4aa7
	call z,@giveTreasure		; $4aa8
	ld a,SND_GETITEM	; $4aab
	call playSound		; $4aad

	; Wait for player to close text
@m3State2:
	ld a,(wTextIsActive)		; $4ab0
	and $7f			; $4ab3
	ret nz			; $4ab5

	xor a			; $4ab6
	ld (wDisableLinkCollisionsAndMenu),a		; $4ab7
	ld e,Interaction.var39		; $4aba
	ld a,(de)		; $4abc
	ld (wDisabledObjects),a		; $4abd
	jp interactionDelete		; $4ac0


; Appears at Link's position after a short delay
@spawnMode6:
	ld e,Interaction.state2		; $4ac3
	ld a,(de)		; $4ac5
	rst_jumpTable			; $4ac6
	.dw @m6State0
	.dw @m6State1
	.dw @m6State2

@m6State0:
	ld a,$01		; $4acd
	ld (de),a		; $4acf
	ld (wDisableLinkCollisionsAndMenu),a		; $4ad0
	call interactionSetAlwaysUpdateBit		; $4ad3
	ld l,Interaction.counter1		; $4ad6
	ld (hl),$0f		; $4ad8
@m6State1:
	call interactionDecCounter1		; $4ada
	ret nz			; $4add

	; Delay done, give treasure to Link

	call interactionIncState2		; $4ade
	call objectSetVisible80		; $4ae1
	call @giveTreasure		; $4ae4
	ldbc $81,$00		; $4ae7
	call @setLinkAnimationAndDeleteIfTextClosed		; $4aea
	ld a,SND_GETITEM	; $4aed
	jp playSound		; $4aef

@m6State2:
	ld a,(wTextIsActive)		; $4af2
	and $7f			; $4af5
	ret nz			; $4af7
	xor a			; $4af8
	ld (wDisableLinkCollisionsAndMenu),a		; $4af9
	ld (wDisabledObjects),a		; $4afc
	jp interactionDelete		; $4aff


; Item that's underwater, must dive to get it (only used in seasons dungeon 4)
@spawnMode4:
	call @checkLinkTouched		; $4b02
	ret nc			; $4b05
	ld a,(wLinkSwimmingState)		; $4b06
	bit 7,a			; $4b09
	ret z			; $4b0b
	call objectSetVisible82		; $4b0c
	call @giveTreasure		; $4b0f
	ld a,SND_GETITEM		; $4b12
	call playSound		; $4b14
	ld a,$03		; $4b17
	jp @gotoStateAndAlwaysUpdate		; $4b19


; Item that falls to Link's position when [wccaa]=$ff?
@spawnMode5:
	ld e,Interaction.state2		; $4b1c
	ld a,(de)		; $4b1e
	rst_jumpTable			; $4b1f
	.dw @m5State0
	.dw @m5State1
	.dw @m5State2

@m5State0:
	ld a,$01		; $4b26
	ld (de),a		; $4b28
	call objectGetShortPosition		; $4b29
	ld (wccaa),a		; $4b2c
	ret			; $4b2f

@m5State1:
	ld a,(wScrollMode)		; $4b30
	and $0c			; $4b33
	jp nz,interactionDelete		; $4b35

	ld a,(wccaa)		; $4b38
	inc a			; $4b3b
	ret nz			; $4b3c

	ld bc,$ff00		; $4b3d
	call objectSetSpeedZ		; $4b40
	ld l,Interaction.state2		; $4b43
	inc (hl)		; $4b45
	ld a,(w1Link.direction)		; $4b46
	swap a			; $4b49
	rrca			; $4b4b
	ld l,$49		; $4b4c
	ld (hl),a		; $4b4e
	ld l,$50		; $4b4f
	ld (hl),$14		; $4b51
	jp objectSetVisiblec2		; $4b53

@m5State2:
	call objectCheckTileCollision_allowHoles		; $4b56
	call nc,objectApplySpeed		; $4b59
	ld c,$10		; $4b5c
	call objectUpdateSpeedZAndBounce		; $4b5e
	ret nz			; $4b61
	push af			; $4b62
	call objectReplaceWithAnimationIfOnHazard		; $4b63
	pop bc			; $4b66
	jp c,interactionDelete		; $4b67

	ld a,SND_DROPESSENCE		; $4b6a
	call playSound		; $4b6c
	bit 4,c			; $4b6f
	ret z			; $4b71
	jp @gotoState2		; $4b72


; State 2: done spawning, waiting for Link to grab it
@state2:
	call returnIfScrollMode01Unset		; $4b75
	call @checkLinkTouched		; $4b78
	ret nc			; $4b7b
	jp @gotoState3		; $4b7c


; State 3: Link just grabbed it
@state3:
	ld e,Interaction.var32		; $4b7f
	ld a,(de)		; $4b81
	rst_jumpTable			; $4b82
	.dw interactionDelete
	.dw @grabMode1
	.dw @grabMode2
	.dw @grabMode3
	.dw @grabMode1
	.dw @grabMode2

; Hold over head with 1 hand
@grabMode1:
	ldbc $80,$fc		; $4b8f
	jr +			; $4b92

; Hold over head with 2 hands
@grabMode2:
	ldbc $81,$00		; $4b94
+
	ld e,Interaction.state2		; $4b97
	ld a,(de)		; $4b99
	or a			; $4b9a
	jr nz,++		; $4b9b

	inc a			; $4b9d
	ld (de),a		; $4b9e

;;
; @param	b	Animation to do (0 = 1-hand grab, 1 = 2-hand grab)
; @param	c	x-offset to put item relative to Link
; @addr{4b9f}
@setLinkAnimationAndDeleteIfTextClosed:
	ld a,LINK_STATE_04		; $4b9f
	ld (wLinkForceState),a		; $4ba1
	ld a,b			; $4ba4
	ld (wcc50),a		; $4ba5
	ld hl,wDisabledObjects		; $4ba8
	set 0,(hl)		; $4bab
	ld hl,w1Link		; $4bad
	ld b,$f2		; $4bb0
	call objectTakePositionWithOffset		; $4bb2
	call objectSetVisible80		; $4bb5
	ld a,SND_GETITEM		; $4bb8
	call playSound		; $4bba
++
	call retIfTextIsActive		; $4bbd
	ld hl,wDisabledObjects		; $4bc0
	res 0,(hl)		; $4bc3
	ld a,$0f		; $4bc5
	ld (wInstrumentsDisabledCounter),a		; $4bc7
	jp interactionDelete		; $4bca


; Performs a spin slash upon obtaining the item
@grabMode3:
	ld a,Interaction.var38		; $4bcd
	ld (wInstrumentsDisabledCounter),a		; $4bcf
	ld e,Interaction.state2		; $4bd2
	ld a,(de)		; $4bd4
	rst_jumpTable			; $4bd5
	.dw @gm3State0
	.dw @gm3State1
	.dw @gm3State2
	.dw @gm3State3

@gm3State0:
	ld a,$01		; $4bde
	ld (de),a		; $4be0
	inc e			; $4be1

	ld a,$04		; $4be2
	ld (de),a ; [counter1] = $04

	ld a,$81		; $4be5
	ld (wDisabledObjects),a		; $4be7
	ld a,$ff		; $4bea
	call setLinkForceStateToState08_withParam		; $4bec
	ld hl,wLinkForceState		; $4bef
	jp objectSetInvisible		; $4bf2

@gm3State1:
	call interactionDecCounter1		; $4bf5
	ret nz			; $4bf8

	ld l,Interaction.state2		; $4bf9
	inc (hl)		; $4bfb

	; Forces spinslash animation
	ld a,$ff		; $4bfc
	ld (wcc63),a		; $4bfe
	ret			; $4c01

@gm3State2:
	; Wait for spin to finish
	ld a,(wcc63)		; $4c02
	or a			; $4c05
	ret nz			; $4c06

	ld a,LINK_ANIM_MODE_GETITEM1HAND		; $4c07
	ld (wcc50),a		; $4c09

	; Calculate x/y position just above Link
	ld e,Interaction.yh		; $4c0c
	ld a,(w1Link.yh)		; $4c0e
	sub $0e			; $4c11
	ld (de),a		; $4c13
	ld e,Interaction.xh		; $4c14
	ld a,(w1Link.xh)		; $4c16
	sub $04			; $4c19
	ld (de),a		; $4c1b

	call objectSetVisible		; $4c1c
	call objectSetVisible80		; $4c1f
	call interactionIncState2		; $4c22
	ld a,SND_SWORD_OBTAINED		; $4c25
	jp playSound		; $4c27

@gm3State3:
	ld a,(wDisabledObjects)		; $4c2a
	or a			; $4c2d
	ret nz			; $4c2e
	jp interactionDelete		; $4c2f

@giveTreasure:
	ld e,Interaction.var34		; $4c32
	ld a,(de)		; $4c34
	ld c,a			; $4c35
	ld e,Interaction.var30		; $4c36
	ld a,(de)		; $4c38
	ld b,a			; $4c39

	; If this is ore chunks, double the value if wearing an appropriate ring?
	cp TREASURE_ORE_CHUNKS			; $4c3a
	jr nz,++		; $4c3c

	ld a,GOLD_JOY_RING		; $4c3e
	call cpActiveRing		; $4c40
	jr z,+			; $4c43

	ld a,GREEN_JOY_RING		; $4c45
	call cpActiveRing		; $4c47
	jr nz,++		; $4c4a
+
	inc c			; $4c4c
++
	ld a,b			; $4c4d
	call giveTreasure		; $4c4e
	ld b,a			; $4c51

	ld e,Interaction.var32		; $4c52
	ld a,(de)		; $4c54
	cp $03			; $4c55
	jr z,+			; $4c57

	ld a,b			; $4c59
	call playSound		; $4c5a
+
	ld e,Interaction.var35		; $4c5d
	ld a,(de)		; $4c5f
	cp $ff			; $4c60
	jr z,++			; $4c62

	ld c,a			; $4c64
	ld b,>TX_0000		; $4c65
	call showText		; $4c67

	; Determine textbox position (after showText call...?)
	ldh a,(<hCameraY)	; $4c6a
	ld b,a			; $4c6c
	ld a,(w1Link.yh)		; $4c6d
	sub b			; $4c70
	sub $10			; $4c71
	cp $48			; $4c73
	ld a,$02		; $4c75
	jr c,+			; $4c77
	xor a			; $4c79
+
	ld (wTextboxPosition),a		; $4c7a
++
	ld e,Interaction.var33		; $4c7d
	ld a,(de)		; $4c7f
	or a			; $4c80
	ret z			; $4c81

	; Mark item as obtained
	call getThisRoomFlags		; $4c82
	set ROOMFLAG_BIT_ITEM,(hl)		; $4c85
	ret			; $4c87

;;
; @param[out]	cflag	Set if Link's touched this object so he should collect it
; @addr{4c88}
@checkLinkTouched:
	ld a,(wLinkForceState)		; $4c88
	or a			; $4c8b
	ret nz			; $4c8c

	ld a,(wLinkPlayingInstrument)		; $4c8d
	or a			; $4c90
	ret nz			; $4c91

	ld a,(w1Link.state)		; $4c92
	cp LINK_STATE_NORMAL			; $4c95
	jr z,+			; $4c97
	cp LINK_STATE_08			; $4c99
	jr nz,++		; $4c9b
+
	ld a,(wLinkObjectIndex)		; $4c9d
	rrca			; $4ca0
	jr c,++			; $4ca1

	; Check if Link's touched this
	ld e,Interaction.var2a		; $4ca3
	ld a,(de)		; $4ca5
	or a			; $4ca6
	jp z,objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $4ca7
	scf			; $4caa
	ret			; $4cab
++
	xor a			; $4cac
	ret			; $4cad
