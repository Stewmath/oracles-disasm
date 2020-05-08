; ==============================================================================
; INTERACID_WOODEN_TUNNEL
; ==============================================================================
interactionCode98:
	ld e,Interaction.state		; $4000
	ld a,(de)		; $4002
	rst_jumpTable			; $4003
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4008
	ld (de),a		; $400a
	call interactionInitGraphics		; $400b
	ld a,$07		; $400e
	call objectSetCollideRadius		; $4010

	; Set animation (direction of tunnel) based on subid
	ld e,Interaction.subid		; $4013
	ld a,(de)		; $4015
	jr +			; $4016
+
	call interactionSetAnimation		; $4018
	jp objectSetVisible81		; $401b

@state1:
	; Make solid if Link's grabbing something or is on the companion
	ld a,(wLinkGrabState)		; $401e
	or a			; $4021
	jr nz,@makeSolid	; $4022
	ld a,(wLinkObjectIndex)		; $4024
	bit 0,a			; $4027
	jr nz,@makeSolid	; $4029
	ld a,(w1ReservedItemC.enabled)		; $402b
	or a			; $402e
	jr nz,@makeSolid	; $402f

	; Allow Link to pass, but set solidity so he can only pass through the center
	ld e,Interaction.subid		; $4031
	ld a,(de)		; $4033
	cp $02			; $4034
	ld c,SPECIALCOLLISION_VERTICAL_BRIDGE		; $4036
	jr c,@setSolidity	; $4038
	ld c,SPECIALCOLLISION_HORIZONTAL_BRIDGE		; $403a
	jr @setSolidity		; $403c

@makeSolid:
	ld c,$0f		; $403e
@setSolidity:
	call objectGetShortPosition		; $4040
	ld h,>wRoomCollisions		; $4043
	ld l,a			; $4045
	ld (hl),c		; $4046
	ret			; $4047


; ==============================================================================
; INTERACID_EXCLAMATION_MARK
; ==============================================================================
interactionCode9f:
	ld e,Interaction.state		; $4048
	ld a,(de)		; $404a
	rst_jumpTable			; $404b
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4050
	ld (de),a		; $4052
	ld h,d			; $4053

	; Always update, even when textboxes are up
	ld l,Interaction.enabled		; $4054
	set 7,(hl)		; $4056

	call interactionInitGraphics		; $4058
	jp objectSetVisible80		; $405b

@state1:
	ld h,d			; $405e
	ld l,Interaction.counter1		; $405f
	ld a,(hl)		; $4061
	inc a			; $4062
	jp z,interactionAnimate		; $4063
	dec (hl)		; $4066
	jp nz,interactionAnimate		; $4067
	jp interactionDelete		; $406a

;;
; Called from "objectCreateExclamationMark" in bank 0.
; Creates an "exclamation mark" interaction, complete with sound effect.
;
; @param	a	How long to show the exclamation mark for (0 or $ff for
;                       indefinitely).
; @param	bc	Offset from the object to create the exclamation mark at.
; @param	d	The object to use for the base position of the exclamation mark.
; @addr{406d}
objectCreateExclamationMark_body:
	ldh (<hFF8B),a	; $406d
	call getFreeInteractionSlot		; $406f
	ret nz			; $4072

	ld (hl),INTERACID_EXCLAMATION_MARK		; $4073
	ld l,Interaction.counter1		; $4075
	ldh a,(<hFF8B)	; $4077
	ld (hl),a		; $4079
	call objectCopyPositionWithOffset		; $407a

	push hl			; $407d
	ld a,SND_CLINK		; $407e
	call playSound		; $4080
	pop hl			; $4083
	ret			; $4084

;;
; Create an interaction with id $a0 (INTERACID_FLOATING_IMAGE). Its position will be
; placed at the current object's position + bc.
;
; @param	bc	Offset relative to object to place the interaction at
; @param	hFF8D	Interaction.subid (0 for snore, 1 for music note)
; @param	hFF8B	Interaction.var03 (0 to float left, 1 to float right)
; @addr{4085}
objectCreateFloatingImage:
	call getFreeInteractionSlot		; $4085
	ret nz			; $4088
	ld (hl),INTERACID_FLOATING_IMAGE		; $4089
	inc l			; $408b
	ldh a,(<hFF8D)	; $408c
	ldi (hl),a		; $408e
	ldh a,(<hFF8B)	; $408f
	ld (hl),a		; $4091
	jp objectCopyPositionWithOffset		; $4092


; ==============================================================================
; INTERACID_FLOATING_IMAGE
; ==============================================================================
interactionCodea0:
	ld e,Interaction.state		; $4095
	ld a,(de)		; $4097
	rst_jumpTable			; $4098
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $409d
	ld (de),a		; $409f

	call interactionSetAlwaysUpdateBit		; $40a0
	call interactionInitGraphics		; $40a3

	; Set 'b' to the angle to veer off toward (left or right, depending on var03)
	ld h,d			; $40a6
	ld b,$03		; $40a7
	ld l,Interaction.var03		; $40a9
	ld a,(hl)		; $40ab
	or a			; $40ac
	jr nz,+			; $40ad
	ld b,$1d		; $40af
+
	ld l,Interaction.angle		; $40b1
	ld (hl),b		; $40b3
	ld l,Interaction.speed		; $40b4
	ld (hl),SPEED_60		; $40b6

	; Delete after 70 frames
	ld l,Interaction.counter1		; $40b8
	ld (hl),70		; $40ba

	jp objectSetVisible80		; $40bc

@state1:
	; Check whether it's a snore or a music note (but the behaviour is the same)
	ld e,Interaction.subid		; $40bf
	ld a,(de)		; $40c1
	or a			; $40c2
	jr nz,+			; $40c3
+
	; Delete after 70 frames
	call interactionDecCounter1		; $40c5
	jp z,interactionDelete		; $40c8

	call objectApplySpeed		; $40cb
	ld e,Interaction.var30		; $40ce
	ld (de),a		; $40d0

	; Update x position every 8 frames based on wFrameCounter
	ld a,(wFrameCounter)		; $40d1
	and $07			; $40d4
	ret nz			; $40d6

	push de			; $40d7
	ld h,d			; $40d8
	ld a,(wFrameCounter)		; $40d9
	and $38			; $40dc
	swap a			; $40de
	rlca			; $40e0
	ld de,@xOffsets		; $40e1
	call addAToDe		; $40e4
	ld a,(de)		; $40e7
	ld l,Interaction.var30		; $40e8
	add (hl)		; $40ea
	ld l,Interaction.xh		; $40eb
	ld (hl),a		; $40ed
	pop de			; $40ee
	ret			; $40ef

@xOffsets:
	.db $ff $fe $ff $00
	.db $01 $02 $01 $00


; ==============================================================================
; INTERACID_BIPIN_BLOSSOM_FAMILY_SPAWNER
; ==============================================================================
interactionCodeac:
	ld a,GLOBALFLAG_FINISHEDGAME		; $40f8
	call checkGlobalFlag		; $40fa
	jp nz,interactionDelete		; $40fd

	call _childSetVar38ToNumEssencesObtained		; $4100
	call @checkUpdateState		; $4103
	call _spawnBipinBlossomFamilyObjects		; $4106
	ld hl,wSeedTreeRefilledBitset		; $4109
.ifdef ROM_AGES
	res 1,(hl)		; $410c
.else
	res 0,(hl)		; $410c
.endif
	jp interactionDelete		; $410e


; Check whether the player has been gone long enough for the child to proceed to the next
; stage of development (uses wSeedTreeRefilledBitset to ensure that Link's been off
; somewhere else for a while).
; Also checks that Link has enough essences for certain stages of development.
@checkUpdateState:
	ld a,(wSeedTreeRefilledBitset)		; $4111
.ifdef ROM_AGES
	bit 1,a			; $4114
.else
	bit 0,a			; $4114
.endif
	ret z			; $4116

	ld hl,wNextChildStage		; $4117
	ld a,(hl)		; $411a
	ld a,(hl)		; $411b
	rst_jumpTable			; $411c
	.dw @gotoNextState
	.dw @need2Essences
	.dw @gotoNextState_2
	.dw @need4Essences
	.dw @need6Essences
	.dw @gotoNextState_2
	.dw @gotoNextState_2
	.dw @need2Essences
	.dw @need4Essences
	.dw @need6Essences

@gotoNextState:
	ld a,(wNextChildStage)		; $4131
	ld (wChildStage),a		; $4134
	cp $04			; $4137
	jp z,_decideInitialChildPersonality		; $4139
	cp $07			; $413c
	jp z,_decideFinalChildPersonality		; $413e
	ret			; $4141

@need2Essences:
	ld e,Interaction.var38		; $4142
	ld a,(de)		; $4144
	cp $02			; $4145
	ret c			; $4147
	jr @gotoNextState		; $4148

@gotoNextState_2:
	jr @gotoNextState		; $414a

@need4Essences:
	ld e,Interaction.var38		; $414c
	ld a,(de)		; $414e
	cp $04			; $414f
	ret c			; $4151
	jr @gotoNextState		; $4152

@need6Essences:
	ld e,Interaction.var38		; $4154
	ld a,(de)		; $4156
	cp $06			; $4157
	ret c			; $4159
	jr @gotoNextState		; $415a

;;
; This is called on file initialization. In a linked game, wChildStatus will be nonzero if
; he was given a name, so he will start at stage 5.
; @addr{415c}
initializeChildOnGameStart:
	ld hl,wChildStatus		; $415c
	ld a,(hl)		; $415f
	or a			; $4160
	ret z			; $4161

	ld a,$05		; $4162
	ld l,<wChildStage		; $4164
	ldi (hl),a		; $4166
	ldi (hl),a		; $4167

;;
; @addr{4168}
_decideInitialChildPersonality:
	ld hl,_initialChildPersonalityTable		; $4168
	jr _label_0b_006		; $416b

;;
; @addr{416d}
_decideFinalChildPersonality:
	; a = [wChildPersonality] * 6
	ld a,(wChildPersonality)		; $416d
	add a			; $4170
	ld b,a			; $4171
	add a			; $4172
	add b			; $4173

	ld hl,_finalChildPersonalityTable		; $4174
	rst_addAToHl			; $4177
_label_0b_006:
	ld a,(wChildStatus)		; $4178
@label_0b_007:
	cp (hl)			; $417b
	jr nc,@label_0b_008	; $417c
	inc hl			; $417e
	inc hl			; $417f
	jr @label_0b_007		; $4180
@label_0b_008:
	inc hl			; $4182
	ld a,(hl)		; $4183
	ld (wChildPersonality),a		; $4184
	ret			; $4187

_initialChildPersonalityTable:
	.db $0b $00 ; status >= 11: Hyperactive
	.db $06 $01 ; status >= 6:  Shy
	.db $00 $02 ; status >= 0:  Curious

_finalChildPersonalityTable:
	; Hyperactive
	.db $1a $02 ; status >= 26: Arborist
	.db $15 $01 ; status >= 21: Warrior
	.db $00 $00 ; status >= 0:  Slacker

	; Shy
	.db $13 $02 ; status >= 19: Arborist
	.db $0f $00 ; status >= 15: Slacker
	.db $00 $03 ; status >= 0:  Singer

	; Curious
	.db $0e $01 ; status >= 14: Warrior
	.db $0a $00 ; status >= 10: Slacker
	.db $00 $03 ; status >= 0:  Singer

;;
; @addr{41a0}
_childSetVar38ToNumEssencesObtained:
	ld a,TREASURE_ESSENCE		; $41a0
	call checkTreasureObtained		; $41a2
	jr c,+			; $41a5
	xor a			; $41a7
+
	ld h,d			; $41a8
	ld l,Interaction.var38		; $41a9
	ld (hl),$00		; $41ab
@nextBit:
	add a			; $41ad
	jr nc,+			; $41ae
	inc (hl)		; $41b0
+
	or a			; $41b1
	jr nz,@nextBit		; $41b2
	ret			; $41b4

;;
; Spawn bipin, blossom, and child objects depending on the stage of the child's
; development, which part of the house this is, and the child's personality.
;
; @addr{41b5}
_spawnBipinBlossomFamilyObjects:
	ld e,Interaction.subid		; $41b5
	ld a,(de)		; $41b7
	or a			; $41b8
	ld hl,@leftHouseInteractions		; $41b9
	jr z,+			; $41bc
	ld hl,@rightHouseInteractions		; $41be
+
	ld a,(wChildStage)		; $41c1
	cp $04			; $41c4
	jr c,++			; $41c6

	rst_addDoubleIndex			; $41c8
	ldi a,(hl)		; $41c9
	ld h,(hl)		; $41ca
	ld l,a			; $41cb
	ld a,(wChildPersonality)		; $41cc
++
	rst_addDoubleIndex			; $41cf
	ldi a,(hl)		; $41d0
	ld b,(hl)		; $41d1
	ld c,a			; $41d2

@loop:
	ld a,(bc)		; $41d3
	or a			; $41d4
	ret z			; $41d5
	call getFreeInteractionSlot		; $41d6
	ret nz			; $41d9

	; id
	ld a,(bc)		; $41da
	ldi (hl),a		; $41db

	; subid
	inc bc			; $41dc
	ld a,(bc)		; $41dd
	ldi (hl),a		; $41de

	; var03
	inc bc			; $41df
	ld a,(bc)		; $41e0
	ldi (hl),a		; $41e1

	; yh
	inc bc			; $41e2
	ld l,Interaction.yh		; $41e3
	ld a,(bc)		; $41e5
	ld (hl),a		; $41e6

	; xh
	inc bc			; $41e7
	ld l,Interaction.xh		; $41e8
	ld a,(bc)		; $41ea
	ld (hl),a		; $41eb
	inc bc			; $41ec
	jr @loop		; $41ed

@leftHouseInteractions:
	.dw @leftStage0
	.dw @leftStage1
	.dw @leftStage2
	.dw @leftStage3
	.dw @@stage4
	.dw @@stage5
	.dw @@stage6
	.dw @@stage7
	.dw @@stage8
	.dw @@stage9

@@stage4:
	.dw @leftStage4_hyperactive
	.dw @leftStage4_shy
	.dw @leftStage4_curious
@@stage5:
	.dw @leftStage5_hyperactive
	.dw @leftStage5_shy
	.dw @leftStage5_curious
@@stage6:
	.dw @leftStage6_hyperactive
	.dw @leftStage6_shy
	.dw @leftStage6_curious
@@stage7:
	.dw @leftStage7_slacker
	.dw @leftStage7_warrior
	.dw @leftStage7_arborist
	.dw @leftStage7_singer
@@stage8:
	.dw @leftStage8_slacker
	.dw @leftStage8_warrior
	.dw @leftStage8_arborist
	.dw @leftStage8_singer
@@stage9:
	.dw @leftStage9_slacker
	.dw @leftStage9_warrior
	.dw @leftStage9_arborist
	.dw @leftStage9_singer

@rightHouseInteractions:
	.dw @rightStage0
	.dw @rightStage1
	.dw @rightStage2
	.dw @rightStage3
	.dw @@stage4
	.dw @@stage5
	.dw @@stage6
	.dw @@stage7
	.dw @@stage8
	.dw @@stage9

@@stage4:
	.dw @rightStage4_hyperactive
	.dw @rightStage4_shy
	.dw @rightStage4_curious
@@stage5:
	.dw @rightStage5_hyperactive
	.dw @rightStage5_shy
	.dw @rightStage5_curious
@@stage6:
	.dw @rightStage6_hyperactive
	.dw @rightStage6_shy
	.dw @rightStage6_curious
@@stage7:
	.dw @rightStage7_slacker
	.dw @rightStage7_warrior
	.dw @rightStage7_arborist
	.dw @rightStage7_singer
@@stage8:
	.dw @rightStage8_slacker
	.dw @rightStage8_warrior
	.dw @rightStage8_arborist
	.dw @rightStage8_singer
@@stage9:
	.dw @rightStage9_slacker
	.dw @rightStage9_warrior
	.dw @rightStage9_arborist
	.dw @rightStage9_singer


; Data format:
;   b0: Interaction ID to spawn (or $00 to stop loading)
;   b1: subid
;   b2: var03
;   b3: Y position
;   b4: X position

@leftStage0:
	.db INTERACID_BIPIN   $00 $00 $48 $48
	.db INTERACID_BLOSSOM $00 $00 $38 $78
@rightStage0:
	.db $00

@leftStage1:
	.db INTERACID_BLOSSOM $01 $00 $18 $48
	.db $00
@rightStage1:
	.db INTERACID_BIPIN   $01 $00 $38 $58
	.db $00

@leftStage2:
	.db INTERACID_BLOSSOM $02 $00 $18 $48
	.db INTERACID_CHILD   $07 $00 $10 $38
	.db $00
@rightStage2:
	.db INTERACID_BIPIN   $02 $00 $38 $58
	.db $00

@leftStage3:
	.db INTERACID_BLOSSOM $03 $00 $38 $78
	.db $00
@rightStage3:
	.db INTERACID_BIPIN   $03 $00 $38 $58
	.db $00

@leftStage4_hyperactive:
	.db INTERACID_BLOSSOM $04 $00 $38 $78
	.db INTERACID_CHILD   $00 $01 $38 $68
	.db $00
@leftStage4_shy:
	.db INTERACID_BLOSSOM $04 $00 $38 $78
	.db INTERACID_CHILD   $01 $02 $38 $18
	.db $00
@leftStage4_curious:
	.db INTERACID_BLOSSOM $04 $00 $38 $78
	.db INTERACID_CHILD   $02 $03 $20 $38
	.db $00

@rightStage4_hyperactive:
@rightStage4_shy:
@rightStage4_curious:
	.db INTERACID_BIPIN   $04 $00 $38 $58
	.db $00

@leftStage5_hyperactive:
	.db INTERACID_BLOSSOM $05 $00 $38 $78
	.db INTERACID_BIPIN   $05 $00 $58 $88
	.db INTERACID_CHILD   $00 $04 $38 $68
	.db $00
@leftStage5_shy:
	.db INTERACID_BLOSSOM $05 $00 $38 $78
	.db INTERACID_BIPIN   $05 $00 $58 $88
	.db INTERACID_CHILD   $01 $05 $38 $18
	.db $00
@leftStage5_curious:
	.db INTERACID_BLOSSOM $05 $00 $38 $78
	.db INTERACID_BIPIN   $05 $00 $58 $88
	.db INTERACID_CHILD   $02 $06 $20 $38
	.db $00

@rightStage5_hyperactive:
@rightStage5_shy:
@rightStage5_curious:
	.db $00

@leftStage6_hyperactive:
@leftStage6_shy:
	.db $00
@leftStage6_curious:
	.db INTERACID_CHILD   $02 $09 $20 $38
	.db $00

@rightStage6_hyperactive:
	.db INTERACID_BLOSSOM $06 $00 $22 $58
	.db INTERACID_BIPIN   $06 $00 $38 $58
	.db INTERACID_CHILD   $00 $07 $38 $48
	.db $00
@rightStage6_shy:
	.db INTERACID_BLOSSOM $06 $01 $22 $58
	.db INTERACID_BIPIN   $06 $00 $38 $58
	.db INTERACID_CHILD   $01 $08 $18 $48
	.db $00
@rightStage6_curious:
	.db INTERACID_BLOSSOM $06 $02 $22 $58
	.db INTERACID_BIPIN   $06 $00 $38 $58
	.db $00

@leftStage7_slacker:
	.db INTERACID_CHILD   $03 $0a $24 $38
	.db $00
@leftStage7_warrior:
	.db INTERACID_CHILD   $04 $0b $48 $40
	.db $00
@leftStage7_arborist:
	.db $00
@leftStage7_singer:
	.db INTERACID_BLOSSOM $07 $03 $58 $88
	.db INTERACID_CHILD   $06 $0d $38 $76
	.db $00

@rightStage7_slacker:
	.db INTERACID_BLOSSOM $07 $00 $22 $58
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db $00
@rightStage7_warrior:
	.db INTERACID_BLOSSOM $07 $01 $22 $58
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db $00
@rightStage7_arborist:
	.db INTERACID_BLOSSOM $07 $02 $48 $30
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db INTERACID_CHILD   $05 $0c $22 $58
	.db $00
@rightStage7_singer:
	.db INTERACID_BIPIN   $07 $00 $38 $58
	.db $00

@leftStage8_slacker:
	.db INTERACID_BLOSSOM $08 $00 $58 $88
	.db INTERACID_CHILD   $03 $0e $44 $78
	.db $00
@leftStage8_warrior:
	.db INTERACID_BLOSSOM $08 $01 $38 $78
	.db $00
@leftStage8_arborist:
	.db INTERACID_BLOSSOM $08 $02 $38 $78
	.db $00
@leftStage8_singer:
	.db INTERACID_CHILD   $06 $11 $14 $26
	.db $00

@rightStage8_slacker:
	.db INTERACID_BIPIN   $08 $00 $38 $58
	.db $00
@rightStage8_warrior:
	.db INTERACID_BIPIN   $08 $00 $38 $58
	.db INTERACID_CHILD   $04 $0f $18 $48
	.db $00
@rightStage8_arborist:
	.db INTERACID_BIPIN   $08 $00 $32 $58
	.db INTERACID_CHILD   $05 $10 $48 $58
	.db $00
@rightStage8_singer:
	.db INTERACID_BIPIN   $08 $00 $38 $58
	.db INTERACID_BLOSSOM $08 $03 $48 $28
	.db $00

@leftStage9_slacker:
	.db INTERACID_BLOSSOM $09 $00 $58 $88
	.db INTERACID_CHILD   $03 $12 $44 $78
	.db $00
@leftStage9_warrior:
	.db INTERACID_BLOSSOM $09 $01 $38 $78
	.db INTERACID_CHILD   $04 $13 $48 $40
	.db $00
@leftStage9_arborist:
	.db INTERACID_BLOSSOM $09 $02 $38 $78
	.db $00
@leftStage9_singer:
	.db INTERACID_BLOSSOM $09 $03 $58 $78
	.db INTERACID_CHILD   $06 $15 $36 $68
	.db $00

@rightStage9_slacker:
	.db INTERACID_BIPIN   $09 $00 $38 $58
	.db $00
@rightStage9_warrior:
	.db INTERACID_BIPIN   $09 $00 $38 $58
	.db $00
@rightStage9_arborist:
	.db INTERACID_BIPIN   $09 $00 $32 $58
	.db INTERACID_CHILD   $05 $14 $48 $58
	.db $00
@rightStage9_singer:
	.db INTERACID_BIPIN   $09 $00 $38 $58
	.db $00


; ==============================================================================
; INTERACID_GASHA_SPOT
; ==============================================================================
.enum 0
	GASHATREASURE_HEART_PIECE	db ; $00
	GASHATREASURE_TIER0_RING	db ; $01
	GASHATREASURE_TIER1_RING	db ; $02
	GASHATREASURE_TIER2_RING	db ; $03
	GASHATREASURE_TIER3_RING	db ; $04
	GASHATREASURE_TIER4_RING	db ; $05
	GASHATREASURE_POTION		db ; $06
	GASHATREASURE_200_RUPEES	db ; $07
	GASHATREASURE_FAIRY		db ; $08
	GASHATREASURE_5_HEARTS		db ; $09
.ende

interactionCodeb6:
	ld e,Interaction.state	; $43f5
	ld a,(de)		; $43f7
	rst_jumpTable			; $43f8
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7

; Initialization
@state0:
	ld e,Interaction.subid	; $4409
	ld a,(de)		; $440b
	inc e			; $440c
	ld (de),a		; $440d
	ld hl,wGashaSpotsPlantedBitset		; $440e
	call checkFlag		; $4411
	jr nz,@seedPlanted	; $4414

	ld e,Interaction.var3c		; $4416
	ld a,(de)		; $4418
	or a			; $4419
	jr nz,+			; $441a

	ld a,DISCOVERY_RING		; $441c
	call cpActiveRing		; $441e
	jr nz,+			; $4421

	ld a,SND_COMPASS	; $4423
	ld e,Interaction.var3c		; $4425
	ld (de),a		; $4427
	call playSound		; $4428
+
	call objectGetTileAtPosition	; $442b
	cp TILEINDEX_SOFT_SOIL	; $442e
	ret nz			; $4430
@unearthed:
	call interactionIncState		; $4431
	ld a,$0a		; $4434
	call objectSetCollideRadius		; $4436
	ld e,Interaction.pressedAButton		; $4439
	jp objectAddToAButtonSensitiveObjectList		; $443b

@seedPlanted:
	ld a,(de)		; $443e
	ld hl,wGashaSpotKillCounters		; $443f
	rst_addAToHl			; $4442
	ld a,(hl)		; $4443
	cp 40			; $4444
	jr c,@delete		; $4446

@killedEnoughEnemies:
	call getFreePartSlot		; $4448
	ret nz			; $444b

	ld (hl),PARTID_GASHA_TREE	; $444c
	inc l			; $444e
	ld (hl),$01		; $444f
	ld l,Part.relatedObj1	; $4451
	ld a,Interaction.start	; $4453
	ldi (hl),a		; $4455
	ld (hl),d		; $4456

	; This interaction will now act as the nut.
	; Adjust x,y positions to be in the center of the tree
	ld h,d			; $4457
	ld l,Interaction.var37		; $4458
	ld e,Interaction.yh		; $445a
	ld a,(de)		; $445c
	ldi (hl),a		; $445d
	add $f8			; $445e
	ld (de),a		; $4460
	ld e,Interaction.xh		; $4461
	ld a,(de)		; $4463
	ldi (hl),a		; $4464
	add $08			; $4465
	ld (de),a		; $4467

	ld a,$04		; $4468
	call objectSetCollideRadius		; $446a

	; Set state 3
	ld l,Interaction.state	; $446d
	ld (hl),$03		; $446f

	; Load graphics for the nut
	ld l,Interaction.subid	; $4471
	ld (hl),$0a		; $4473
	call interactionInitGraphics		; $4475
	jp objectSetVisible83		; $4478

; Wait for player to press A button
@state1:
	ld e,Interaction.pressedAButton	; $447b
	ld a,(de)		; $447d
	or a			; $447e
	ret z			; $447f

@pressedAButton:
	xor a			; $4480
	ld (de),a		; $4481
	ld bc,TX_3509		; $4482
	ld a,(wNumGashaSeeds)		; $4485
	or a			; $4488
	jr z,+			; $4489

	; To state 2
	call interactionIncState		; $448b
	ld c,<TX_3500		; $448e
+
	jp showText		; $4490

; After text box has been shown, selected yes or no
@state2:
	ld a,(wSelectedTextOption)		; $4493
	or a			; $4496
	jr z,+			; $4497

	; Back to state 1
	ld a,$01		; $4499
	ld (de),a		; $449b
	ret			; $449c
+
	call objectGetTileAtPosition		; $449d
	ld c,l			; $44a0
	ld a,TILEINDEX_SOFT_SOIL_PLANTED	; $44a1
	call setTile		; $44a3

	ld e,Interaction.var03		; $44a6
	ld a,(de)		; $44a8
	ld hl,wGashaSpotsPlantedBitset		; $44a9
	call setFlag		; $44ac

	ld a,(de)		; $44af
	ld l,<wGashaSpotKillCounters		; $44b0
	rst_addAToHl			; $44b2
	ld (hl),$00		; $44b3

	ld l,<wNumGashaSeeds	; $44b5
	ld a,(hl)		; $44b7
	sub $01			; $44b8
	daa			; $44ba
	ld (hl),a		; $44bb
	ld a,SND_GETSEED	; $44bc
	call playSound		; $44be
@delete:
	jp interactionDelete		; $44c1

; Wait for link to slash the nut, then drop it
@state3:
	ld e,Interaction.var2a		; $44c4
	ld a,(de)		; $44c6
	cp $ff			; $44c7
	ret nz			; $44c9

	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $44ca
	ld (wDisabledObjects),a		; $44cc
	ld (wMenuDisabled),a		; $44cf

	; To state 4
	ld h,d			; $44d2
	ld l,Interaction.state	; $44d3
	ld (hl),$04		; $44d5

	ld a,$06		; $44d7
	call objectSetCollideRadius		; $44d9
	ld bc,-$140		; $44dc
	call objectSetSpeedZ		; $44df

	ld l,Interaction.speed	; $44e2
	ld (hl),SPEED_100		; $44e4

	call objectGetAngleTowardLink		; $44e6
	ld e,Interaction.angle	; $44e9
	ld (de),a		; $44eb
	jp objectSetVisible80		; $44ec

; Wait for the nut to collide with link, show corresponding text
@state4:
	; Dunno why this is necessary
	ld a,(wLinkDeathTrigger)		; $44ef
	or a			; $44f2
	jp nz,interactionDelete		; $44f3

	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $44f6
	jr c,+			; $44f9

	; Hasn't collided with link yet
	call objectApplySpeed		; $44fb
	ld c,$20		; $44fe
	jp objectUpdateSpeedZ_paramC		; $4500
+
	; To state 5
	call interactionIncState		; $4503

	ld l,Interaction.visible	; $4506
	res 7,(hl)		; $4508
	ld bc,TX_3501		; $450a
	jp showText		; $450d

@state5:
	; Check if this is the first gasha nut harvested ever
	ld hl,wGashaSpotFlags		; $4510
	bit 0,(hl)		; $4513
	jr nz,+			; $4515
	set 0,(hl)		; $4517
	ld b,GASHATREASURE_TIER3_RING		; $4519
	jr @spawnTreasure		; $451b
+
	; Get a value of 0-4 in 'c', based on the range of wGashaMaturity (0 = best
	; prizes, 4 = worst prizes)
	ld c,$00		; $451d
	ld hl,wGashaMaturity+1		; $451f
	ldd a,(hl)		; $4522
	srl a			; $4523
	jr nz,++		; $4525
	ld a,(hl)		; $4527
	rra			; $4528
	ld hl,@gashaMaturityValues		; $4529
--
	cp (hl)			; $452c
	jr nc,++		; $452d
	inc hl			; $452f
	inc c			; $4530
	jr --			; $4531
++
	; Get the probability distribution to use, based on 'c' (above) and which gasha
	; spot this is (var03)
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	ld hl,@gashaSpotRanks		; $4536
	rst_addAToHl			; $4539
	ld a,(hl)		; $453a
	rst_addAToHl			; $453b

	; a = c*10
	ld a,c			; $453c
	add a			; $453d
	ld c,a			; $453e
	add a			; $453f
	add a			; $4540
	add c			; $4541

	rst_addAToHl			; $4542
	call getRandomIndexFromProbabilityDistribution		; $4543

	; If it would be a potion, but he has one already, just refill his health
	ld a,b			; $4546
	cp GASHATREASURE_POTION			; $4547
	jr nz,@notPotion	; $4549

	ld a,TREASURE_POTION		; $454b
	call checkTreasureObtained		; $454d
	jr nc,@decGashaMaturity		; $4550

	ld hl,wLinkMaxHealth		; $4552
	ldd a,(hl)		; $4555
	ld (hl),a		; $4556
	jr @decGashaMaturity			; $4557

@notPotion:
	; If it would ba a heart piece, but he got it already, give tier 0 ring instead
	cp GASHATREASURE_HEART_PIECE			; $4559
	jr nz,@decGashaMaturity		; $455b
	ld hl,wGashaSpotFlags		; $455d
	bit 1,(hl)		; $4560
	jr z,+			; $4562
	inc b			; $4564
+
	set 1,(hl)		; $4565

@decGashaMaturity
	; BUG: no bounds checking here; you could underflow wGashaMaturity.
	ld hl,wGashaMaturity		; $4567
	ld a,(hl)		; $456a
	sub 200			; $456b
	ldi (hl),a		; $456d
	ld a,(hl)		; $456e
	sbc $00			; $456f
	ld (hl),a		; $4571

	jr nc,@spawnTreasure	; $4572
	xor a			; $4574
	ldd (hl),a		; $4575
	ld (hl),a		; $4576

@spawnTreasure:
	; This object, which was previously the nut, will now become the item sprite being
	; held over Link's head; set the subid accordingly.
	ld a,b			; $4577
	ld e,Interaction.subid	; $4578
	ld (de),a		; $457a
	ld hl,@gashaTreasures		; $457b
	rst_addDoubleIndex			; $457e
	ldi a,(hl)		; $457f
	ld c,(hl)		; $4580
	cp TREASURE_RING			; $4581
	jr nz,+			; $4583
	call getRandomRingOfGivenTier		; $4585
+
	ld b,a			; $4588
	call giveTreasure		; $4589

	; Set Link's animation
	ld hl,wLinkForceState		; $458c
	ld a,LINK_STATE_04		; $458f
	ldi (hl),a		; $4591
	ld (hl),$01 ; [wcc50]

	; Set position above Link
	ld hl,w1Link.yh		; $4594
	ld bc,$f300		; $4597
	call objectTakePositionWithOffset		; $459a

	call interactionIncState		; $459d
	ld l,Interaction.visible		; $45a0
	set 7,(hl)		; $45a2

	ld e,Interaction.subid		; $45a4
	ld a,(de)		; $45a6
	cp GASHATREASURE_HEART_PIECE			; $45a7
	ld a,SND_GETITEM	; $45a9
	call nz,playSound		; $45ab

	; Load graphics, show text
	call interactionInitGraphics		; $45ae
	ld e,Interaction.subid		; $45b1
	ld a,(de)		; $45b3
	ld hl,@lowTextIndices	; $45b4
	rst_addAToHl			; $45b7
	ld c,(hl)		; $45b8
	ld b,>TX_3500		; $45b9
	jp showText		; $45bb

; Text to show upon getting each respective item
@lowTextIndices:
	.db <TX_3503 <TX_3504 <TX_3504 <TX_3504 <TX_3504 <TX_3504 <TX_3505 <TX_3506
	.db <TX_3508 <TX_3507

; Obtained the item and exited the textbox; wait for link's hearts or rupee
; count to update fully, then make the tree disappear
@state6:
	ld hl,wNumRupees		; $45c8
	ld a,(wDisplayedRupees)		; $45cb
	cp (hl)			; $45ce
	ret nz			; $45cf
	inc l			; $45d0
	ld a,(wDisplayedRupees+1)		; $45d1
	cp (hl)			; $45d4
	ret nz			; $45d5

	ld l,<wLinkHealth		; $45d6
	ld a,(wDisplayedHearts)		; $45d8
	cp (hl)			; $45db
	ret nz			; $45dc

	ld a,SND_FAIRYCUTSCENE	; $45dd
	call playSound		; $45df

	ld e,Interaction.var03		; $45e2
	ld a,(de)		; $45e4
	ld hl,@gfxHeaderToLoadWhenTreeDisappears		; $45e5
	rst_addAToHl			; $45e8
	ld a,(hl)		; $45e9
	push af			; $45ea
	sub GFXH_39			; $45eb
	ld (wLoadedTreeGfxActive),a		; $45ed

	ld a,GFXH_3d		; $45f0
	call loadGfxHeader		; $45f2
	pop af			; $45f5
	cp GFXH_3d			; $45f6
	call nz,loadGfxHeader		; $45f8

	ldh a,(<hActiveObject)	; $45fb
	ld d,a			; $45fd
	ld h,d			; $45fe
	ld l,Interaction.var37		; $45ff
	ld e,Interaction.yh		; $4601
	ldi a,(hl)		; $4603
	ld (de),a ; [yh] = [var37] (original Y position)
	ld e,Interaction.xh		; $4605
	ldi a,(hl)		; $4607
	ld (de),a ; [xh] = [var38] (original X position)

	ld l,Interaction.visible		; $4609
	res 7,(hl)		; $460b

	; Make tiles walkable again
	call objectGetTileCollisions		; $460d
	xor a			; $4610
	ldi (hl),a		; $4611
	ldd (hl),a		; $4612
	ld a,l			; $4613
	sub $10			; $4614
	ld l,a			; $4616
	xor a			; $4617
	ldi (hl),a		; $4618
	ldd (hl),a		; $4619

	; Calculate position in w3VramTiles?
	ld h,a			; $461a
	ld e,l			; $461b
	ld a,l			; $461c
	and $f0			; $461d
	ld l,a			; $461f
	ld a,e			; $4620
	and $0f			; $4621
	sla l			; $4623
	rl h			; $4625
	add l			; $4627
	ld l,a			; $4628
	sla l			; $4629
	rl h			; $462b
	ld bc,w3VramTiles		; $462d
	add hl,bc		; $4630

	; Write calculated position to var3a
	ld e,Interaction.var3a		; $4631
	ld a,l			; $4633
	ld (de),a		; $4634
	inc e			; $4635
	ld a,h			; $4636
	ld (de),a		; $4637

	; Do something with w3VramAttributes ($400 bytes ahead)?
	ld bc,$0400		; $4638
	add hl,bc		; $463b
	ld a,($ff00+R_SVBK)	; $463c
	push af			; $463e
	ld a,:w3VramAttributes		; $463f
	ld ($ff00+R_SVBK),a	; $4641
	ld b,$04		; $4643
---
	ld c,$04		; $4645
	push bc			; $4647
--
	ld a,(hl)		; $4648
	and $f0			; $4649
	or $04			; $464b
	ldi (hl),a		; $464d
	dec c			; $464e
	jr nz,--		; $464f

	ld bc,$001c		; $4651
	add hl,bc		; $4654
	pop bc			; $4655
	dec b			; $4656
	jr nz,---		; $4657

	pop af			; $4659
	ld ($ff00+R_SVBK),a	; $465a
	call interactionIncState		; $465c
	ld l,Interaction.counter1		; $465f
	ld (hl),$08		; $4661

; Shrinking the tree (cycling through each frame of the animation)
@state7:
	ld h,d			; $4663
	ld l,Interaction.counter1	; $4664
	ld a,(hl)		; $4666
	or a			; $4667
	jr z,@counter1Done	; $4668

	dec a			; $466a
	ld (hl),a		; $466b
	ret nz			; $466c

@counter1Done:
	ld a,$08		; $466d
	ldi (hl),a		; $466f
	ld a,(hl)		; $4670
	inc a			; $4671
	ld (hl),a		; $4672
	cp $0a			; $4673
	jr nc,@counter2Done	; $4675

	ld hl,@treeDisappearanceFrames-1		; $4677
	rst_addAToHl			; $467a
	ld a,(hl)		; $467b
	rst_addAToHl			; $467c

	; Retrieve position in w3VramTiles from var3a
	ld e,Interaction.var3a		; $467d
	ld a,(de)		; $467f
	ld c,a			; $4680
	inc e			; $4681
	ld a,(de)		; $4682
	ld d,a			; $4683
	ld e,c			; $4684

	push hl			; $4685
	push de			; $4686
	pop hl			; $4687
	pop de			; $4688

	; Draw the next frame of the tree's disappearance
	ld a,($ff00+R_SVBK)	; $4689
	push af			; $468b
	ld a,:w3VramTiles	; $468c
	ld ($ff00+R_SVBK),a	; $468e
	ld b,$04		; $4690
---
	ld c,$04		; $4692
	push bc			; $4694
--
	ld a,(de)		; $4695
	ldi (hl),a		; $4696
	inc de			; $4697
	dec c			; $4698
	jr nz,--		; $4699

	ld bc,$001c		; $469b
	add hl,bc		; $469e
	pop bc			; $469f
	dec b			; $46a0
	jr nz,---		; $46a1

	pop af			; $46a3
	ld ($ff00+R_SVBK),a	; $46a4
	ld a,UNCMP_GFXH_29	; $46a6
	call loadUncompressedGfxHeader		; $46a8

	ldh a,(<hActiveObject)	; $46ab
	ld d,a			; $46ad
	ld e,Interaction.counter2	; $46ae
	ld a,(de)		; $46b0
	add UNCMP_GFXH_1f			; $46b1
	call loadUncompressedGfxHeader		; $46b3

	call reloadTileMap		; $46b6
	ldh a,(<hActiveObject)	; $46b9
	ld d,a			; $46bb
	ret			; $46bc

@counter2Done:
	xor a			; $46bd
	ld (wDisabledObjects),a		; $46be
	ld (wMenuDisabled),a		; $46c1

	ld e,Interaction.var03		; $46c4
	ld a,(de)		; $46c6
	ld hl,wGashaSpotsPlantedBitset		; $46c7
	call unsetFlag		; $46ca

.ifdef ROM_AGES
	; Overwrite the 4 tiles making up the gasha tree in wRoomLayout
	ld a,TILEINDEX_GASHA_TREE_TL	; $46cd
	call findTileInRoom		; $46cf
	ret nz			; $46d2

	ld e,Interaction.var03		; $46d3
	ld a,(de)		; $46d5
	ld bc,@tileReplacements	; $46d6
	call addAToBc		; $46d9
	ld a,(bc)		; $46dc
	ld b,a			; $46dd
	ld a,b			; $46de
	ldi (hl),a		; $46df
	ld (hl),a		; $46e0
	ld a,$0f		; $46e1
	add l			; $46e3
	ld l,a			; $46e4
	ld a,b			; $46e5
	ldi (hl),a		; $46e6
	ld (hl),a		; $46e7
.endif
	jp interactionDelete		; $46e8

.ifdef ROM_AGES
@tileReplacements:
	.db $3a $1b $1b $3a $3a $bf $3a $bf
	.db $1b $3a $3a $1b $3a $3a $3a $bf
.endif


; These are values compared with "wGashaMaturity" which set the ranges for gasha prize
; "levels". A value of 300 or higher will give you the highest level prizes.
@gashaMaturityValues:
	.db 300/2
	.db 200/2
	.db 120/2
	.db  40/2
	.db   0/2


@gashaTreasures:
	.db TREASURE_HEART_PIECE, $01
	.db TREASURE_RING, RING_TIER_0
	.db TREASURE_RING, RING_TIER_1
	.db TREASURE_RING, RING_TIER_2
	.db TREASURE_RING, RING_TIER_3
	.db TREASURE_RING, RING_TIER_4
	.db TREASURE_POTION, $01
	.db TREASURE_RUPEES, RUPEEVAL_200
	.db TREASURE_HEART_REFILL, $18
	.db TREASURE_HEART_REFILL, $14


; Each row defines which type of gasha spot each subid is (rank 0 = best).
@gashaSpotRanks:
.ifdef ROM_AGES
	.db @rank1Spot-CADDR ; $00
	.db @rank2Spot-CADDR ; $01
	.db @rank2Spot-CADDR ; $02
	.db @rank1Spot-CADDR ; $03
	.db @rank4Spot-CADDR ; $04
	.db @rank1Spot-CADDR ; $05
	.db @rank1Spot-CADDR ; $06
	.db @rank0Spot-CADDR ; $07
	.db @rank3Spot-CADDR ; $08
	.db @rank2Spot-CADDR ; $09
	.db @rank2Spot-CADDR ; $0a
	.db @rank1Spot-CADDR ; $0b
	.db @rank4Spot-CADDR ; $0c
	.db @rank3Spot-CADDR ; $0d
	.db @rank1Spot-CADDR ; $0e
	.db @rank0Spot-CADDR ; $0f
.else
	.db @rank1Spot-CADDR ; $4991
	.db @rank0Spot-CADDR ; $4992
	.db @rank0Spot-CADDR ; $4993
	.db @rank3Spot-CADDR ; $4994
	.db @rank2Spot-CADDR ; $4995
	.db @rank3Spot-CADDR ; $4996
	.db @rank2Spot-CADDR ; $4997
	.db @rank4Spot-CADDR ; $4998
	.db @rank1Spot-CADDR ; $4999
	.db @rank2Spot-CADDR ; $499a
	.db @rank4Spot-CADDR ; $499b
	.db @rank3Spot-CADDR ; $499c
	.db @rank2Spot-CADDR ; $499d
	.db @rank2Spot-CADDR ; $499e
	.db @rank3Spot-CADDR ; $499f
	.db @rank4Spot-CADDR ; $49a0
.endif


; Each row corresponds to a certain range for "wGashaMaturity". The first row is the most
; "mature" (occurs later in the game), while the later rows occur earlier in the game.
; Prizes get better as the game goes on.
;
; Each row is a "probability distribution" that adds up to 256. Each byte is a weighting
; for the corresponding treasure (GASHATREASURE_X).

@rank0Spot: ; Best type of spot
	.db $5a $40 $26 $00 $00 $1a $0d $0d $0c $00
	.db $40 $26 $26 $00 $00 $00 $40 $26 $0e $00
	.db $26 $33 $33 $00 $00 $00 $40 $26 $0e $00
	.db $1a $26 $26 $00 $00 $00 $40 $34 $26 $00
	.db $0c $1a $1a $00 $00 $00 $4d $33 $33 $0d
@rank1Spot:
	.db $1a $26 $5a $33 $00 $00 $19 $0d $0d $00
	.db $0d $1a $33 $40 $00 $00 $26 $33 $0d $00
	.db $08 $12 $33 $33 $00 $00 $26 $33 $1a $0d
	.db $05 $0d $1a $3b $00 $00 $26 $33 $26 $1a
	.db $03 $08 $0f $19 $00 $00 $1a $40 $4d $26
@rank2Spot:
	.db $00 $00 $26 $4d $66 $00 $0d $0d $0d $00
	.db $00 $00 $1a $32 $4d $00 $33 $1a $1a $00
	.db $00 $00 $0d $1a $26 $00 $40 $33 $33 $0d
	.db $00 $00 $08 $12 $1a $00 $40 $33 $33 $26
	.db $00 $00 $03 $0d $0d $00 $1a $4b $4b $33
@rank3Spot:
	.db $00 $00 $00 $5a $5a $00 $1a $1a $0c $0c
	.db $00 $00 $00 $33 $33 $00 $33 $33 $1a $1a
	.db $00 $00 $00 $26 $26 $00 $26 $33 $34 $27
	.db $00 $00 $00 $1a $1a $00 $1a $4d $32 $33
	.db $00 $00 $00 $0d $0d $00 $1a $40 $40 $4c
@rank4Spot: ; Worst type of spot
	.db $00 $00 $00 $40 $34 $00 $26 $26 $26 $1a
	.db $00 $00 $00 $26 $26 $00 $26 $33 $34 $27
	.db $00 $00 $00 $1a $26 $00 $26 $33 $34 $33
	.db $00 $00 $00 $12 $1a $00 $21 $33 $40 $40
	.db $00 $00 $00 $0d $0d $00 $0d $40 $4c $4d


; Each entry consists of a 4x4 block of subtiles (8x8 tiles) to draw while the tree is
; disappearing.
@treeDisappearanceFrames:
	.db @frame1-CADDR
	.db @frame1-CADDR
	.db @frame2-CADDR
	.db @frame3-CADDR
	.db @frame4-CADDR
	.db @frame5-CADDR
	.db @frame5-CADDR
	.db @frame6-CADDR
	.db @frame7-CADDR

@frame1:
	.db $20 $21 $22 $23
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $2c $2d $2e $2f
@frame2:
	.db $20 $21 $20 $21
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $20 $2c $2d $2e
@frame3:
	.db $20 $21 $20 $21
	.db $24 $25 $26 $27
	.db $28 $29 $2a $2b
	.db $22 $2c $2d $23
@frame4:
	.db $20 $21 $20 $21
	.db $22 $24 $25 $23
	.db $20 $26 $27 $21
	.db $22 $28 $29 $23
@frame5:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $24 $25 $21
	.db $22 $26 $27 $23
@frame6:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $21 $20 $21
	.db $22 $24 $25 $23
@frame7:
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23
	.db $20 $21 $20 $21
	.db $22 $23 $22 $23


; Each subid loads one of 3 gfx headers while the tree disappears.
@gfxHeaderToLoadWhenTreeDisappears:
.ifdef ROM_AGES
	.db GFXH_3d GFXH_3f GFXH_3f GFXH_3d GFXH_3d GFXH_3e GFXH_3d GFXH_3e
	.db GFXH_3f GFXH_3d GFXH_3d GFXH_3f GFXH_3d GFXH_3d GFXH_3d GFXH_3e
.else
	.db GFXH_3d GFXH_3d GFXH_3d GFXH_3d GFXH_3f GFXH_3d GFXH_3d GFXH_3d
	.db GFXH_3d GFXH_3d GFXH_3d GFXH_3d GFXH_3d GFXH_3e GFXH_3d GFXH_3d
.endif


; ==============================================================================
; INTERACID_KISS_HEART
; ==============================================================================
interactionCodeb7:
	ld e,Interaction.state		; $48a7
	ld a,(de)		; $48a9
	rst_jumpTable			; $48aa
	.dw @state1
	.dw interactionAnimate

@state1:
	ld a,$01		; $48af
	ld (de),a		; $48b1
	call interactionInitGraphics	; $48b2
	jp objectSetVisible82		; $48b5


; ==============================================================================
; INTERACID_BANANA
; ==============================================================================
interactionCodec0:
	ld e,Interaction.state		; $48b8
	ld a,(de)		; $48ba
	rst_jumpTable			; $48bb
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $48c0
	ld (de),a		; $48c2
	call interactionInitGraphics		; $48c3
	jp objectSetVisible80		; $48c6

@state1:
	call interactionAnimate		; $48c9
	ld a,Object.enabled		; $48cc
	call objectGetRelatedObject1Var		; $48ce
	ld l,SpecialObject.id		; $48d1
	ld a,(hl)		; $48d3
	cp SPECIALOBJECTID_MOOSH_CUTSCENE			; $48d4
	jp nz,interactionDelete		; $48d6

	ld e,Interaction.direction		; $48d9
	ld a,(de)		; $48db
	ld l,SpecialObject.direction		; $48dc
	cp (hl)			; $48de
	ld a,(hl)		; $48df
	jr z,@updatePosition	; $48e0

	; Direction changed

	ld (de),a		; $48e2
	push af			; $48e3
	ld hl,@visibleValues		; $48e4
	rst_addAToHl			; $48e7
	ldi a,(hl)		; $48e8
	ld e,Interaction.visible		; $48e9
	ld (de),a		; $48eb
	pop af			; $48ec
	call interactionSetAnimation		; $48ed

	ld a,Object.enabled		; $48f0
	call objectGetRelatedObject1Var		; $48f2
	ld l,SpecialObject.direction		; $48f5
	ld a,(hl)		; $48f7

@updatePosition:
	push hl			; $48f8
	ld hl,@xOffsets		; $48f9
	rst_addAToHl			; $48fc
	ld b,$00		; $48fd
	ld c,(hl)		; $48ff
	pop hl			; $4900
	jp objectTakePositionWithOffset		; $4901

@visibleValues:
	.db $83 $83 $80 $83

@xOffsets:
	.db $00 $05 $00 $fb



; ==============================================================================
; INTERACID_CREATE_OBJECT_AT_EACH_TILEINDEX
; ==============================================================================
interactionCodec7:
	ld e,Interaction.subid		; $490c
	ld a,(de)		; $490e
	ld c,a			; $490f
	ld hl,wRoomLayout		; $4910
	ld b,LARGE_ROOM_HEIGHT*$10		; $4913
--
	ld a,(hl)		; $4915
	cp c			; $4916
	call z,@createObject		; $4917
	inc l			; $491a
	dec b			; $491b
	jr nz,--		; $491c
	jp interactionDelete		; $491e

@createObject:
	push hl			; $4921
	push bc			; $4922
	ld b,l			; $4923
	ld e,Interaction.xh		; $4924
	ld a,(de)		; $4926
	and $f0			; $4927
	swap a			; $4929
	call @spawnObjectType		; $492b
	jr nz,@ret	; $492e

	ld e,Interaction.yh		; $4930
	ld a,(de)		; $4932
	ldi (hl),a		; $4933
	ld e,Interaction.xh		; $4934
	ld a,(de)		; $4936
	and $0f			; $4937
	ld (hl),a		; $4939

	ld a,l			; $493a
	add Object.yh-Object.subid			; $493b
	ld l,a			; $493d
	ld a,b			; $493e
	and $f0			; $493f
	add $08			; $4941
	ldi (hl),a		; $4943
	inc l			; $4944
	ld a,b			; $4945
	and $0f			; $4946
	swap a			; $4948
	add $08			; $494a
	ld (hl),a		; $494c

@ret:
	pop bc			; $494d
	pop hl			; $494e
	ret			; $494f

;;
; @param	a	0 for enemy; 1 for part; 2 for interaction
; @param[out]	hl	Spawned object
; @addr{4950}
@spawnObjectType:
	or a			; $4950
	jp z,getFreeEnemySlot		; $4951
	dec a			; $4954
	jp z,getFreePartSlot		; $4955
	dec a			; $4958
	jp z,getFreeInteractionSlot		; $4959
	ret			; $495c
