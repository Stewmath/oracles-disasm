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
	res 1,(hl)		; $410c
	jp interactionDelete		; $410e


; Check whether the player has been gone long enough for the child to proceed to the next
; stage of development (uses wSeedTreeRefilledBitset to ensure that Link's been off
; somewhere else for a while).
; Also checks that Link has enough essences for certain stages of development.
@checkUpdateState:
	ld a,(wSeedTreeRefilledBitset)		; $4111
	bit 1,a			; $4114
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
	jp interactionDelete		; $46e8

@tileReplacements:
	.db $3a $1b $1b $3a $3a $bf $3a $bf
	.db $1b $3a $3a $1b $3a $3a $3a $bf


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
	.db GFXH_3d GFXH_3f GFXH_3f GFXH_3d GFXH_3d GFXH_3e GFXH_3d GFXH_3e
	.db GFXH_3f GFXH_3d GFXH_3d GFXH_3f GFXH_3d GFXH_3d GFXH_3d GFXH_3e


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


; ==============================================================================
; INTERACID_BUSINESS_SCRUB
;
; Variables:
;   var38: Number of rupees to spent (1-byte value, converted with "rupeeValue" methods)
;   var39: Set when Link is close to the scrub (he pops out of his bush)
; ==============================================================================
interactionCodece:
	ld e,Interaction.state		; $495d
	ld a,(de)		; $495f
	rst_jumpTable			; $4960
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4967
	ld (de),a		; $4969
	call interactionSetAlwaysUpdateBit		; $496a

	ld e,Interaction.subid		; $496d
	ld a,(de)		; $496f
	bit 7,a			; $4970
	jr nz,@mimicBush	; $4972

	cp $00			; $4974
	jr z,@sellingShield	; $4976
	cp $03			; $4978
	jr z,@sellingShield	; $497a
	cp $06			; $497c
	jr nz,+++		; $497e

@sellingShield:
	ld c,a			; $4980
	ld a,(wShieldLevel)		; $4981
	or a			; $4984
	jr z,+			; $4985
	dec a			; $4987
+
	add c			; $4988
	ld (de),a		; $4989
	ld hl,@itemPrices		; $498a
	rst_addDoubleIndex			; $498d
	ldi a,(hl)		; $498e
	ld b,(hl)		; $498f
	ld hl,wTextNumberSubstitution		; $4990
	ldi (hl),a		; $4993
	ld (hl),b		; $4994
+++
	ld e,Interaction.collisionRadiusY		; $4995
	ld a,$06		; $4997
	ld (de),a		; $4999
	inc e			; $499a
	ld (de),a		; $499b

	call interactionInitGraphics		; $499c
	call objectMakeTileSolid		; $499f
	ld h,>wRoomLayout		; $49a2
	ld (hl),$00		; $49a4
	call objectSetVisible80		; $49a6
	ld e,Interaction.pressedAButton		; $49a9
	call objectAddToAButtonSensitiveObjectList		; $49ab

	call getFreeInteractionSlot		; $49ae
	ld a,INTERACID_BUSINESS_SCRUB		; $49b1
	ldi (hl),a		; $49b3
	ld a,$80		; $49b4
	ldi (hl),a		; $49b6
	ld l,Interaction.relatedObj2		; $49b7
	ld (hl),d		; $49b9
	jp objectCopyPosition		; $49ba

; Subid $80 initialization (the bush above the scrub)
@mimicBush:
	ld a,(wActiveGroup)		; $49bd
	or a			; $49c0
	ld a,TILEINDEX_OVERWORLD_BUSH_1		; $49c1
	jr z,+			; $49c3
	ld a,TILEINDEX_OVERWORLD_BUSH_1		; $49c5
+
	call objectMimicBgTile		; $49c7
	ld a,$05		; $49ca
	call interactionSetAnimation		; $49cc
	jp objectSetVisible80		; $49cf

@state1:
	ld a,(wScrollMode)		; $49d2
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02			; $49d5
	ret nz			; $49d7

	ld e,Interaction.subid		; $49d8
	ld a,(de)		; $49da
	bit 7,a			; $49db
	jr nz,@subid80State1	; $49dd

	call objectSetPriorityRelativeToLink_withTerrainEffects		; $49df
	call interactionAnimate		; $49e2
	ld c,$20		; $49e5
	call objectCheckLinkWithinDistance		; $49e7
	ld e,Interaction.var39		; $49ea
	jr c,@linkIsClose	; $49ec

	; Link not close
	ld a,(de)		; $49ee
	or a			; $49ef
	ret z			; $49f0
	xor a			; $49f1
	ld (de),a		; $49f2
	ld a,$03		; $49f3
	jp interactionSetAnimation		; $49f5

@linkIsClose:
	ld a,(de)		; $49f8
	or a			; $49f9
	jr nz,++		; $49fa
	inc a			; $49fc
	ld (de),a		; $49fd
	ld a,$01		; $49fe
	jp interactionSetAnimation		; $4a00
++
	ld e,Interaction.pressedAButton		; $4a03
	ld a,(de)		; $4a05
	or a			; $4a06
	ret z			; $4a07

	; Link talked to the scrub
	call interactionIncState		; $4a08
	ld a,$02		; $4a0b
	call interactionSetAnimation		; $4a0d
	ld e,Interaction.subid		; $4a10
	ld a,(de)		; $4a12
	ld hl,@offerItemTextIndices		; $4a13
	rst_addAToHl			; $4a16
	ld c,(hl)		; $4a17
	ld b,>TX_4500		; $4a18
	jp showTextNonExitable		; $4a1a

; Subid $80: the bush above the scrub
@subid80State1:
	ld e,Interaction.relatedObj2		; $4a1d
	ld a,(de)		; $4a1f
	ld h,a			; $4a20
	ld l,Interaction.visible		; $4a21
	ld a,(hl)		; $4a23
	ld e,Interaction.visible		; $4a24
	ld (de),a		; $4a26
	ld l,Interaction.yh		; $4a27
	ld b,(hl)		; $4a29
	ld l,Interaction.animParameter		; $4a2a
	ld a,(hl)		; $4a2c
	ld hl,@bushYOffsets		; $4a2d
	rst_addAToHl			; $4a30
	ld e,Interaction.yh		; $4a31
	ldi a,(hl)		; $4a33
	add b			; $4a34
	ld (de),a		; $4a35
	ret			; $4a36

@state2:
	call interactionAnimate		; $4a37
	ld a,(wTextIsActive)		; $4a3a
	and $7f			; $4a3d
	ret nz			; $4a3f

	; Link just finished talking to the scrub
	ld a,(wSelectedTextOption)		; $4a40
	bit 7,a			; $4a43
	jr z,@label_0b_103	; $4a45

	ld e,Interaction.state		; $4a47
	ld a,$01		; $4a49
	ld (de),a		; $4a4b
	xor a			; $4a4c
	ld (wTextIsActive),a		; $4a4d
	ld e,Interaction.pressedAButton		; $4a50
	ld (de),a		; $4a52
	dec a			; $4a53
	ld (wSelectedTextOption),a		; $4a54
	ld a,$04		; $4a57
	jp interactionSetAnimation		; $4a59

@label_0b_103:
	ld a,(wSelectedTextOption)		; $4a5c
	or a			; $4a5f
	jr z,@agreedToBuy	; $4a60

	; Declined to buy
	ld bc,TX_4506		; $4a62
	jr @showText		; $4a65

@agreedToBuy:
	ld e,Interaction.subid		; $4a67
	ld a,(de)		; $4a69
	ld hl,@rupeeValues		; $4a6a
	rst_addAToHl			; $4a6d
	ld a,(hl)		; $4a6e
	ld e,Interaction.var38		; $4a6f
	ld (de),a		; $4a71
	call cpRupeeValue		; $4a72
	jr z,@enoughRupees	; $4a75

	; Not enough rupees
	ld bc,TX_4507		; $4a77
	jr @showText		; $4a7a

@enoughRupees:
	ld e,Interaction.subid		; $4a7c
	ld a,(de)		; $4a7e
	ld hl,@treasuresToSell		; $4a7f
	rst_addDoubleIndex			; $4a82
	ld a,(hl)		; $4a83
	cp TREASURE_BOMBS			; $4a84
	jr z,@giveBombs	; $4a86
	cp TREASURE_EMBER_SEEDS			; $4a88
	jr nz,@giveShield	; $4a8a

@giveEmberSeeds:
	ld a,(wSeedSatchelLevel)		; $4a8c
	ld bc,@maxSatchelCapacities-1		; $4a8f
	call addAToBc		; $4a92
	ld a,(bc)		; $4a95
	ld c,a			; $4a96
	ld a,(wNumEmberSeeds)		; $4a97
	cp c			; $4a9a
	jr nz,@giveTreasure	; $4a9b
	jr @alreadyHaveTreasure		; $4a9d

@giveBombs:
	ld bc,wNumBombs		; $4a9f
	ld a,(bc)		; $4aa2
	inc c			; $4aa3
	ld e,a			; $4aa4
	ld a,(bc)		; $4aa5
	cp e			; $4aa6
	jr nz,@giveTreasure	; $4aa7
	jr @alreadyHaveTreasure		; $4aa9

@giveShield:
	call checkTreasureObtained		; $4aab
	jr nc,@giveTreasure	; $4aae

@alreadyHaveTreasure:
	ld bc,TX_4508		; $4ab0
	jr @showText		; $4ab3

@giveTreasure:
	ldi a,(hl)		; $4ab5
	ld c,(hl)		; $4ab6
	call giveTreasure		; $4ab7
	ld e,Interaction.var38		; $4aba
	ld a,(de)		; $4abc
	call removeRupeeValue		; $4abd
	ld a,SND_GETSEED		; $4ac0
	call playSound		; $4ac2
	ld bc,TX_4505		; $4ac5
@showText:
	jp showText		; $4ac8

@maxSatchelCapacities:
	.db $20 $50 $99

@offerItemTextIndices:
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509
	.db <TX_4509

@bushYOffsets:
	.db $00 ; Normally
	.db $f8 ; When Link approaches
	.db $f5 ; When Link is talking to him

; This should match with "@itemPrices" below
@rupeeValues:
	.db RUPEEVAL_50
	.db RUPEEVAL_100
	.db RUPEEVAL_150
	.db RUPEEVAL_30
	.db RUPEEVAL_50
	.db RUPEEVAL_80
	.db RUPEEVAL_10
	.db RUPEEVAL_20
	.db RUPEEVAL_40

@treasuresToSell:
	.db TREASURE_SHIELD      $01
	.db TREASURE_SHIELD      $02
	.db TREASURE_SHIELD      $03
	.db TREASURE_SHIELD      $01
	.db TREASURE_SHIELD      $02
	.db TREASURE_SHIELD      $03
	.db TREASURE_SHIELD      $01
	.db TREASURE_SHIELD      $02
	.db TREASURE_SHIELD      $03
	.db TREASURE_BOMBS       $10
	.db TREASURE_EMBER_SEEDS $10

; This should match with "@rupeeValues" above
@itemPrices:
	.dw $0050
	.dw $0100
	.dw $0150
	.dw $0030
	.dw $0050
	.dw $0080
	.dw $0010
	.dw $0020
	.dw $0040


; ==============================================================================
; INTERACID_cf
; ==============================================================================
interactionCodecf:
	ld e,Interaction.state		; $4b0b
	ld a,(de)		; $4b0d
	rst_jumpTable			; $4b0e
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4b13
	ld (de),a		; $4b15
	call interactionInitGraphics		; $4b16
	ld e,Interaction.subid		; $4b19
	ld a,(de)		; $4b1b
	ld hl,@positions		; $4b1c
	rst_addDoubleIndex			; $4b1f
	ldi a,(hl)		; $4b20
	ld e,Interaction.yh		; $4b21
	ld (de),a		; $4b23
	inc e			; $4b24
	inc e			; $4b25
	ld a,(hl)		; $4b26
	ld (de),a		; $4b27
	jp objectSetVisible82		; $4b28

@positions:
	.db $18 $5c ; 0 == [subid]
	.db $40 $40 ; 1
	.db $38 $88 ; 2

@state1:
	jp interactionAnimate		; $4b31


; ==============================================================================
; INTERACID_COMPANION_TUTORIAL
; ==============================================================================
interactionCoded0:
	ld e,Interaction.state		; $4b34
	ld a,(de)		; $4b36
	rst_jumpTable			; $4b37
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $4b3e
	ld (de),a		; $4b40
	ret			; $4b41

@state1:
	ld a,$02		; $4b42
	ld (de),a		; $4b44
	ld a,(w1Companion.enabled)		; $4b45
	or a			; $4b48
	jr z,@deleteIfSubid2Or5	; $4b49

	; Verify that the correct companion is on-screen, otherwise delete self
	ld e,Interaction.subid		; $4b4b
	ld a,(de)		; $4b4d
	srl a			; $4b4e
	add SPECIALOBJECTID_FIRST_COMPANION			; $4b50
	cp SPECIALOBJECTID_LAST_COMPANION+1			; $4b52
	jr c,+			; $4b54
	ld a,SPECIALOBJECTID_MOOSH		; $4b56
+
	ld hl,w1Companion.id		; $4b58
	cp (hl)			; $4b5b
	jr nz,@delete	; $4b5c

	; Delete self if tutorial text was already shown
	ld a,(de)		; $4b5e
	ld hl,@flagNumbers		; $4b5f
	rst_addAToHl			; $4b62
	ld a,(hl)		; $4b63
	ld hl,wCompanionTutorialTextShown		; $4b64
	call checkFlag		; $4b67
	jr nz,@delete	; $4b6a

	; Check whether to dismount? (subid 2 only)
	ld a,(de)		; $4b6c
	cp $02			; $4b6d
	jr nz,++		; $4b6f
	ld a,(wLinkObjectIndex)		; $4b71
	rra			; $4b74
	ld a,(de)		; $4b75
	jr nc,++		; $4b76
	ld (wForceCompanionDismount),a		; $4b78
++
	ld hl,@tutorialTextToShow		; $4b7b
	rst_addDoubleIndex			; $4b7e
	ldi a,(hl)		; $4b7f
	ld c,a			; $4b80
	ld b,(hl)		; $4b81
	ld a,(wLinkObjectIndex)		; $4b82
	bit 0,a			; $4b85
	call nz,showText		; $4b87

@deleteIfSubid2Or5:
	ld e,Interaction.subid		; $4b8a
	ld a,(de)		; $4b8c
	cp $02			; $4b8d
	jr z,@delete	; $4b8f
	cp $05			; $4b91
	ret nz			; $4b93
@delete:
	jp interactionDelete		; $4b94

@state2:
	ld a,(w1Companion.enabled)		; $4b97
	or a			; $4b9a
	ret z			; $4b9b
	ld e,Interaction.subid		; $4b9c
	ld a,(de)		; $4b9e
	rst_jumpTable			; $4b9f
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5

@subid2:
@subid5:
	ld e,Interaction.yh		; $4bac
	ld a,(de)		; $4bae
	ld hl,w1Companion.yh		; $4baf
	cp (hl)			; $4bb2
	ret nc			; $4bb3
	jr @setFlagAndDelete		; $4bb4

@func_4bb6: ; unused
	ld a,(w1Companion.var38)		; $4bb6
	or a			; $4bb9
	ret z			; $4bba

@subid1:
@setFlagAndDeleteWhenCompanionIsAbove:
	call @cpYToCompanion		; $4bbb
	ret c			; $4bbe

@setFlagAndDelete:
	ld e,Interaction.subid		; $4bbf
	ld a,(de)		; $4bc1
	ld hl,@flagNumbers		; $4bc2
	rst_addAToHl			; $4bc5
	ld a,(hl)		; $4bc6
	ld hl,wCompanionTutorialTextShown		; $4bc7
	call setFlag		; $4bca
	jr @delete		; $4bcd

@subid3:
	call @checkLinkInXRange		; $4bcf
	ret nz			; $4bd2
	jr @setFlagAndDeleteWhenCompanionIsAbove		; $4bd3

@subid4:
	ld e,Interaction.xh		; $4bd5
	ld a,(de)		; $4bd7
	ld hl,w1Companion.xh		; $4bd8
	cp (hl)			; $4bdb
	ret nc			; $4bdc
	jr @setFlagAndDelete		; $4bdd

@subid0:
	call @cpYToCompanion		; $4bdf
	jr c,@setFlagAndDelete	; $4be2
	ld e,Interaction.xh		; $4be4
	ld a,(de)		; $4be6
	ld hl,w1Companion.xh		; $4be7
	cp (hl)			; $4bea
	ret c			; $4beb
	jr @setFlagAndDelete		; $4bec

;;
; @addr{4bee}
@cpYToCompanion:
	ld e,Interaction.yh		; $4bee
	ld a,(de)		; $4bf0
	ld hl,w1Companion.yh		; $4bf1
	cp (hl)			; $4bf4
	ret			; $4bf5

;;
; @param[out]	zflag	z if Link is within a certain range of X-positions for certain
;			rooms?
; @addr{4bf6}
@checkLinkInXRange:
	ld a,(wActiveRoom)		; $4bf6
	ld hl,@rooms		; $4bf9
	ld b,$00		; $4bfc
--
	cp (hl)			; $4bfe
	jr z,++			; $4bff
	inc b			; $4c01
	inc hl			; $4c02
	jr --			; $4c03
++
	ld a,b			; $4c05
	ld hl,@xRanges		; $4c06
	rst_addDoubleIndex			; $4c09
	ld a,(w1Link.xh)		; $4c0a
	cp (hl)			; $4c0d
	jr c,++			; $4c0e
	inc hl			; $4c10
	cp (hl)			; $4c11
	jr nc,++		; $4c12
	xor a			; $4c14
	ret			; $4c15
++
	or d			; $4c16
	ret			; $4c17

@rooms:
	.db <ROOM_AGES_036
	.db <ROOM_AGES_037
	.db <ROOM_AGES_027

@xRanges:
	.db $40 $70
	.db $10 $30
	.db $40 $80

@tutorialTextToShow:
	.dw TX_2008
	.dw TX_2009
	.dw TX_0000
	.dw TX_2108
	.dw TX_2207
	.dw TX_2206

@flagNumbers:
	.db $00 $01 $00 $03 $04 $00


; ==============================================================================
; INTERACID_GAME_COMPLETE_DIALOG
; ==============================================================================
interactionCoded1:
	ld e,Interaction.state		; $4c33
	ld a,(de)		; $4c35
	rst_jumpTable			; $4c36
	.dw @state0
	.dw interactionRunScript

@state0:
	ld a,$01		; $4c3b
	ld (de),a		; $4c3d
	ld c,a			; $4c3e
	callab bank1.loadDeathRespawnBufferPreset		; $4c3f
	ld hl,gameCompleteDialogScript		; $4c47
	jp interactionSetScript		; $4c4a


; ==============================================================================
; INTERACID_TITLESCREEN_CLOUDS
; ==============================================================================
interactionCoded2:
	ld e,Interaction.state		; $4c4d
	ld a,(de)		; $4c4f
	rst_jumpTable			; $4c50
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4c55
	ld (de),a		; $4c57
	call interactionInitGraphics		; $4c58
	ld e,Interaction.subid		; $4c5b
	ld a,(de)		; $4c5d
	ld hl,@positions		; $4c5e
	rst_addDoubleIndex			; $4c61
	ldi a,(hl)		; $4c62
	ld b,(hl)		; $4c63
	ld h,d			; $4c64
	ld l,Interaction.var37		; $4c65
	ld (hl),a		; $4c67
	ld l,Interaction.yh		; $4c68
	ldi (hl),a		; $4c6a
	inc l			; $4c6b
	ld (hl),b		; $4c6c

	ld l,Interaction.angle		; $4c6d
	ld (hl),ANGLE_DOWN		; $4c6f
	ld l,Interaction.speed		; $4c71
	ld (hl),SPEED_20		; $4c73
	ret			; $4c75

@positions:
	.db $bf $7c ; 0 == [subid]
	.db $bf $2a ; 1
	.db $9f $94 ; 2
	.db $a3 $10 ; 3


@state1:
	ld a,(wGfxRegs1.SCY)		; $4c7e
	ld b,a			; $4c81
	ld e,Interaction.var37		; $4c82
	ld a,(de)		; $4c84
	sub b			; $4c85
	inc e			; $4c86
	ld e,Interaction.yh		; $4c87
	ld (de),a		; $4c89

	call checkInteractionState2		; $4c8a
	jr nz,@substate1	; $4c8d

@substate0:
	ld a,(wGfxRegs1.SCY)		; $4c8f
	cp $e0			; $4c92
	ret nz			; $4c94
	call interactionIncState2		; $4c95
	call objectSetVisible82		; $4c98

@substate1:
	ld a,(wGfxRegs1.SCY)		; $4c9b
	cp $88			; $4c9e
	ret z			; $4ca0

;;
; This is used by INTERACID_TITLESCREEN_CLOUDS and INTERACID_INTRO_BIRD.
; @param[out]	a	X position
; @addr{4ca1}
_introObject_applySpeed:
	ld h,d			; $4ca1
	ld l,Interaction.angle		; $4ca2
	ld c,(hl)		; $4ca4
	ld l,Interaction.speed		; $4ca5
	ld b,(hl)		; $4ca7
	call getPositionOffsetForVelocity		; $4ca8
	ret z			; $4cab

	ld e,Interaction.var36		; $4cac
	ld a,(de)		; $4cae
	add (hl)		; $4caf
	ld (de),a		; $4cb0
	inc e			; $4cb1
	inc l			; $4cb2
	ld a,(de)		; $4cb3
	adc (hl)		; $4cb4
	ld (de),a		; $4cb5

	ld e,Interaction.x		; $4cb6
	inc l			; $4cb8
	ld a,(de)		; $4cb9
	add (hl)		; $4cba
	ld (de),a		; $4cbb
	inc e			; $4cbc
	inc l			; $4cbd
	ld a,(de)		; $4cbe
	adc (hl)		; $4cbf
	ld (de),a		; $4cc0
	ret			; $4cc1


; ==============================================================================
; INTERACID_INTRO_BIRD
; ==============================================================================
interactionCoded3:
	ld e,Interaction.state		; $4cc2
	ld a,(de)		; $4cc4
	rst_jumpTable			; $4cc5
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4cca
	ld (de),a		; $4ccc
	call interactionInitGraphics		; $4ccd

	; counter2: How long the bird should remain (it will respawn if it goes off-screen
	; before counter2 reaches 0)
	ld h,d			; $4cd0
	ld l,Interaction.counter2		; $4cd1
	ld (hl),45		; $4cd3

	; Determine direction to move in based on subid
	ld l,Interaction.subid		; $4cd5
	ld a,(hl)		; $4cd7
	ld b,$00		; $4cd8
	ld c,$1a		; $4cda
	cp $04			; $4cdc
	jr c,+			; $4cde
	inc b			; $4ce0
	ld c,$06		; $4ce1
+
	ld l,Interaction.angle		; $4ce3
	ld (hl),c		; $4ce5
	ld l,Interaction.speed		; $4ce6
	ld (hl),SPEED_140		; $4ce8

	push af			; $4cea
	ld a,b			; $4ceb
	call interactionSetAnimation		; $4cec

	pop af			; $4cef

@initializePositionAndCounter1:
	ld b,a			; $4cf0
	add a			; $4cf1
	add b			; $4cf2
	ld hl,@birdPositionsAndAppearanceDelays		; $4cf3
	rst_addAToHl			; $4cf6
	ldi a,(hl)		; $4cf7
	ld b,(hl)		; $4cf8
	inc l			; $4cf9
	ld c,(hl)		; $4cfa
	ld h,d			; $4cfb
	ld l,Interaction.var37		; $4cfc
	ld (hl),a		; $4cfe
	ld l,Interaction.yh		; $4cff
	ldi (hl),a		; $4d01
	inc l			; $4d02
	ld (hl),b		; $4d03
	ld l,Interaction.counter1		; $4d04
	ld (hl),c		; $4d06
	ret			; $4d07

@state1:
	; Update Y
	ld a,(wGfxRegs1.SCY)		; $4d08
	ld b,a			; $4d0b
	ld e,Interaction.var37		; $4d0c
	ld a,(de)		; $4d0e
	sub b			; $4d0f
	inc e			; $4d10
	ld e,Interaction.yh		; $4d11
	ld (de),a		; $4d13

	ld e,Interaction.state2		; $4d14
	ld a,(de)		; $4d16
	rst_jumpTable			; $4d17
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wGfxRegs1.SCY)		; $4d1e
	cp $10			; $4d21
	ret nz			; $4d23
	jp interactionIncState2		; $4d24

@substate1:
	call interactionDecCounter1		; $4d27
	ret nz			; $4d2a
	call interactionIncState2		; $4d2b
	jp objectSetVisible82		; $4d2e

@substate2:
	ld e,Interaction.counter2		; $4d31
	ld a,(de)		; $4d33
	or a			; $4d34
	jr z,+			; $4d35
	dec a			; $4d37
	ld (de),a		; $4d38
+
	call interactionAnimate		; $4d39
	call _introObject_applySpeed		; $4d3c
	cp $b0			; $4d3f
	ret c			; $4d41

	; Bird is off-screen; check whether to "reset" the bird or just delete it.
	ld h,d			; $4d42
	ld l,Interaction.counter2		; $4d43
	ld a,(hl)		; $4d45
	or a			; $4d46
	jp z,interactionDelete		; $4d47

	ld l,Interaction.state2		; $4d4a
	dec (hl)		; $4d4c
	ld l,Interaction.subid		; $4d4d
	ld a,(hl)		; $4d4f
	call @initializePositionAndCounter1		; $4d50

	; Set counter1 (the delay before reappearing) randomly
	call getRandomNumber_noPreserveVars		; $4d53
	and $0f			; $4d56
	ld h,d			; $4d58
	ld l,Interaction.counter1		; $4d59
	ld (hl),a		; $4d5b
	jp objectSetInvisible		; $4d5c


; Data format:
;   b0: Y
;   b1: X
;   b2: counter1 (delay before appearing)
@birdPositionsAndAppearanceDelays:
	.db $4c $18 $01 ; 0 == [subid]
	.db $58 $20 $10 ; 1
	.db $5a $30 $14 ; 2
	.db $50 $28 $16 ; 3
	.db $50 $74 $04 ; 4
	.db $4c $84 $0a ; 5
	.db $5c $8c $12 ; 6
	.db $58 $7c $17 ; 7


; ==============================================================================
; INTERACID_LINK_SHIP
; ==============================================================================
interactionCoded4:
	ld e,Interaction.state		; $4d77
	ld a,(de)		; $4d79
	rst_jumpTable			; $4d7a
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4d7f
	ld (de),a		; $4d81
	ld h,d			; $4d82
	ld l,Interaction.subid		; $4d83
	ld a,(hl)		; $4d85
	ld b,a			; $4d86
	and $0f			; $4d87
	ld (hl),a		; $4d89

	ld a,b			; $4d8a
	swap a			; $4d8b
	and $0f			; $4d8d
	add a			; $4d8f
	add a			; $4d90
	ld l,Interaction.counter1		; $4d91
	ld (hl),a		; $4d93

	call interactionInitGraphics		; $4d94
	jp objectSetVisible82		; $4d97

@state1:
	ld e,Interaction.subid		; $4d9a
	ld a,(de)		; $4d9c
	cp $02			; $4d9d
	ret z			; $4d9f

	call interactionDecCounter1		; $4da0
	ld e,Interaction.subid		; $4da3
	ld a,(de)		; $4da5
	or a			; $4da6
	jr nz,@seagull	; $4da7

@ship:
	; Update the "bobbing" of the ship using the Z position (every 32 frames)
	ld a,(wFrameCounter)		; $4da9
	ld b,a			; $4dac
	and $1f			; $4dad
	ret nz			; $4daf

	ld a,b			; $4db0
	and $e0			; $4db1
	swap a			; $4db3
	rrca			; $4db5
	ld hl,@zPositions		; $4db6
	rst_addAToHl			; $4db9
	ld e,Interaction.zh		; $4dba
	ld a,(hl)		; $4dbc
	ld (de),a		; $4dbd
	ret			; $4dbe

@zPositions:
	.db $00 $ff $ff $00 $00 $01 $01 $00


@seagull:
	; Similarly update the "bobbing" of the seagull, but more frequently
	ld a,(hl) ; [counter1]
	and $07			; $4dc8
	ret nz			; $4dca

	ld a,(hl)		; $4dcb
	and $38			; $4dcc
	swap a			; $4dce
	rlca			; $4dd0
	ld hl,@zPositions		; $4dd1
	rst_addAToHl			; $4dd4
	ld e,Interaction.zh		; $4dd5
	ld a,(hl)		; $4dd7
	ld (de),a		; $4dd8
	ret			; $4dd9


; ==============================================================================
; INTERACID_FARORE_GIVEITEM
; ==============================================================================
interactionCoded9:
	ld e,Interaction.state		; $4dda
	ld a,(de)		; $4ddc
	rst_jumpTable			; $4ddd
	.dw _interactiond9_state0
	.dw _interactiond9_state1
	.dw _interactiond9_state2

_interactiond9_state0:
	ld a,$01		; $4de4
	ld (wLoadedTreeGfxIndex),a		; $4de6

	; Check if the secret has been told already
	ld e,Interaction.subid		; $4de9
	ld a,(de)		; $4deb
	ld b,a			; $4dec
	add GLOBALFLAG_FIRST_AGES_DONE_SECRET			; $4ded
	call checkGlobalFlag		; $4def
	jr z,@secretNotTold			; $4df2

	ld bc,TX_550c ; "You told me this secret already"
	call showText		; $4df7

	; Bit 1 is a signal for Farore to continue talking
	ld a,$02		; $4dfa
	ld (wTmpcfc0.genericCutscene.state),a		; $4dfc

	jp interactionDelete		; $4dff

@secretNotTold:
	; Decide whether to go to state 1 or 2 based on the secret told.
	ld a,b			; $4e02
	ld hl,@bits		; $4e03
	call checkFlag		; $4e06
	ld a,$02		; $4e09
	jr nz,+			; $4e0b
	dec a			; $4e0d
+
	ld e,Interaction.state		; $4e0e
	ld (de),a		; $4e10
	ret			; $4e11

; If a bit is set for a corresponding secret, it's an upgrade (go to state 2); otherwise,
; it's a new item (go to state 1).
@bits:
	dbrev %10001101 %01000000

;;
; @param[out]	bc	The item ID.
;			If this is an upgrade, 'c' is a value from 0-4 indicating the
;			behaviour (ie. compare with current ring box level, sword level)
; @addr{4e14}
_interactiond9_getItemID:
	ld e,Interaction.subid		; $4e14
	ld a,(de)		; $4e16
	ld hl,@chestContents		; $4e17
	rst_addDoubleIndex			; $4e1a
	ld b,(hl)		; $4e1b
	inc l			; $4e1c
	ld c,(hl)		; $4e1d
	ret			; $4e1e

@chestContents:
	.db  TREASURE_SWORD,           $00 ; upgrade
	dwbe TREASURE_HEART_CONTAINER_SUBID_01
	dwbe TREASURE_BOMBCHUS_SUBID_01
	dwbe TREASURE_RING_SUBID_0c
	.db  TREASURE_SHIELD,          $01 ; upgrade
	.db  TREASURE_BOMB_UPGRADE,    $02 ; upgrade
	dwbe TREASURE_RING_SUBID_0d
	.db  TREASURE_SATCHEL_UPGRADE, $03 ; upgrade
	dwbe TREASURE_BIGGORON_SWORD_SUBID_01
	.db  TREASURE_RING_BOX,        $04 ; upgrade


; State 1: it's a new item, not an upgrade
_interactiond9_state1:
	ld e,Interaction.state2		; $4e33
	ld a,(de)		; $4e35
	rst_jumpTable			; $4e36
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld a,$01		; $4e41
	ld (de),a		; $4e43
	xor a			; $4e44
	ld ($cca2),a		; $4e45

	call _interactiond9_getItemID		; $4e48
	ld a,b			; $4e4b
	ld (wChestContentsOverride),a		; $4e4c
	ld a,c			; $4e4f
	ld (wChestContentsOverride+1),a		; $4e50

	ld b,INTERACID_FARORE_MAKECHEST		; $4e53
	jp objectCreateInteractionWithSubid00		; $4e55

@substate1:
	ld a,(wTmpcfc0.genericCutscene.state)		; $4e58
	or a			; $4e5b
	ret z			; $4e5c

	ld e,Interaction.counter1		; $4e5d
	ld a,$3c		; $4e5f
	ld (de),a		; $4e61
	jp interactionIncState2		; $4e62

@substate2:
	call interactionDecCounter1		; $4e65
	ret nz			; $4e68

	ld a,GLOBALFLAG_SECRET_CHEST_WAITING		; $4e69
	call setGlobalFlag		; $4e6b

	; Bit 1 of $cfc0 is a signal for Farore to continue talking
	ld a,$02		; $4e6e
	ld ($cfc0),a		; $4e70

	ld bc,TX_5509 ; "Your secrets have called forth power"
	call showText		; $4e76
	jp interactionIncState2		; $4e79

@substate3:
	; Wait for the chest to be opened
	ld a,($cca2)		; $4e7c
	or a			; $4e7f
	ret z			; $4e80

	call _interactiond9_markSecretAsTold		; $4e81
	ld e,Interaction.counter1		; $4e84
	ld a,$1e		; $4e86
	ld (de),a		; $4e88
	jp interactionIncState2		; $4e89

@substate4:
	call interactionDecCounter1		; $4e8c
	ret nz			; $4e8f

	; Remove the chest
	call objectCreatePuff		; $4e90
	call objectGetShortPosition		; $4e93
	ld c,a			; $4e96
	ld a,$ac		; $4e97
	call setTile		; $4e99
	jp interactionDelete		; $4e9c


; State 2: it's an upgrade; it doesn't go in a chest.
_interactiond9_state2:
	ld e,Interaction.state2		; $4e9f
	ld a,(de)		; $4ea1
	rst_jumpTable			; $4ea2
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	call interactionIncState2		; $4eb5
	ld l,Interaction.counter1		; $4eb8
	ld (hl),30		; $4eba
	ld hl,w1Link		; $4ebc
	jp objectTakePosition		; $4ebf

@substate1:
	call interactionDecCounter1		; $4ec2
	ret nz			; $4ec5
	ld (hl),60		; $4ec6

	call getFreeInteractionSlot		; $4ec8
	ret nz			; $4ecb
	ld (hl),INTERACID_SPARKLE		; $4ecc
	ld l,Interaction.yh		; $4ece
	ld (hl),$28		; $4ed0
	ld l,Interaction.xh		; $4ed2
	ld (hl),$58		; $4ed4
	jp interactionIncState2		; $4ed6

@substate2:
	call interactionDecCounter1		; $4ed9
	ret nz			; $4edc
	ld (hl),20		; $4edd

	ld a,(w1Link.yh)		; $4edf
	ld b,a			; $4ee2
	ld a,(w1Link.xh)		; $4ee3
	ld c,a			; $4ee6
	ld a,$78		; $4ee7
	call createEnergySwirlGoingIn		; $4ee9
	jp interactionIncState2		; $4eec

@substate3:
@substate4:
	call interactionDecCounter1		; $4eef
	ret nz			; $4ef2
	ld (hl),$14		; $4ef3
	call fadeinFromWhite		; $4ef5

@playFadeOutSoundAndIncState:
	ld a,SND_FADEOUT		; $4ef8
	call playSound		; $4efa
	jp interactionIncState2		; $4efd

@substate5:
	call interactionDecCounter1		; $4f00
	ret nz			; $4f03
	ld a,$02		; $4f04
	call fadeinFromWhiteWithDelay		; $4f06
	jr @playFadeOutSoundAndIncState		; $4f09

@substate6:
	ld a,(wPaletteThread_mode)		; $4f0b
	or a			; $4f0e
	ret nz			; $4f0f
	call _interactiond9_getItemID		; $4f10
	ld a,c			; $4f13
	rst_jumpTable			; $4f14
	.dw @swordUpgrade
	.dw @shieldUpgrade
	.dw @bombUpgrade
	.dw @satchelUpgrade
	.dw @ringBoxUpgrade

@ringBoxUpgrade:
	ld a,(wRingBoxLevel)		; $4f1f
	and $03			; $4f22
	ld hl,@ringBoxSubids		; $4f24
	rst_addAToHl			; $4f27
	ld c,(hl)		; $4f28
	ld b,TREASURE_RING_BOX		; $4f29
	jr @createTreasureAndIncState2		; $4f2b

@ringBoxSubids:
	.db $03 $03 $04 $04

@swordShieldSubids:
	.db $03 $01
	.db $03 $01
	.db $05 $02
	.db $05 $02

@swordUpgrade:
	ld a,(wSwordLevel)		; $4f39
	jr ++			; $4f3c

@shieldUpgrade:
	ld a,(wShieldLevel)		; $4f3e
++
	ld hl,@swordShieldSubids		; $4f41
	rst_addDoubleIndex			; $4f44
	inc hl			; $4f45
	ld a,(hl)		; $4f46
	jr @label_0b_135		; $4f47

@bombUpgrade:
	ldbc TREASURE_BOMB_UPGRADE, $00		; $4f49
	call @createTreasureAndIncState2		; $4f4c
	ld hl,wMaxBombs		; $4f4f
	ld a,(hl)		; $4f52
	add $20			; $4f53
	ldd (hl),a		; $4f55
	ld (hl),a		; $4f56
	jp setStatusBarNeedsRefreshBit1		; $4f57

@satchelUpgrade:
	ld a,(wSeedSatchelLevel)		; $4f5a
	ldbc TREASURE_SEED_SATCHEL, $04		; $4f5d
	jr @createTreasureAndIncState2		; $4f60

@label_0b_135:
	and $03			; $4f62
	ld c,a			; $4f64

@createTreasureAndIncState2:
	call @createTreasure		; $4f65
	ld e,Interaction.counter1		; $4f68
	ld a,30		; $4f6a
	ld (de),a		; $4f6c
	jp interactionIncState2		; $4f6d

@substate7:
	call retIfTextIsActive		; $4f70
	call interactionDecCounter1		; $4f73
	ret nz			; $4f76

	ld e,Interaction.subid		; $4f77
	ld a,(de)		; $4f79
	cp $07			; $4f7a
	jr z,@fillSatchel	; $4f7c
	or a			; $4f7e
	jr nz,@cleanup	; $4f7f

	; The sword upgrade acts differently? Maybe due to Link doing a spin slash?
	ld a,(wSwordLevel)		; $4f81
	add $02			; $4f84
	ld c,a			; $4f86
	ld b,TREASURE_SWORD		; $4f87
	call @createTreasure		; $4f89
	call interactionIncState2		; $4f8c
	ld l,Interaction.counter1		; $4f8f
	ld (hl),$5a		; $4f91
	ret			; $4f93

@fillSatchel:
	call refillSeedSatchel		; $4f94

@cleanup:
	; Bit 1 of $cfc0 is a signal for Farore to continue talking
	ld a,$02		; $4f97
	ld ($cfc0),a		; $4f99

	ld bc,TX_5509		; $4f9c
	call showText		; $4f9f
	call _interactiond9_markSecretAsTold		; $4fa2
	jp interactionDelete		; $4fa5

@substate8:
	call interactionDecCounter1		; $4fa8
	ret nz			; $4fab
	jr @cleanup		; $4fac

;;
; @param	bc	The treasure to create
@createTreasure:
	call createTreasure		; $4fae
	ret nz			; $4fb1
	jp objectCopyPosition		; $4fb2

;;
; @addr{4fb5}
_interactiond9_markSecretAsTold:
	ld e,Interaction.subid		; $4fb5
	ld a,(de)		; $4fb7
	add GLOBALFLAG_FIRST_AGES_DONE_SECRET			; $4fb8
	call setGlobalFlag		; $4fba
	ld a,GLOBALFLAG_SECRET_CHEST_WAITING		; $4fbd
	jp unsetGlobalFlag		; $4fbf



; ==============================================================================
; INTERACID_ZELDA_APPROACH_TRIGGER
; ==============================================================================
interactionCodeda:
	ld e,Interaction.state		; $4fc2
	ld a,(de)		; $4fc4
	rst_jumpTable			; $4fc5
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4fca
	ld (de),a		; $4fcc
	call getThisRoomFlags		; $4fcd
	and ROOMFLAG_80			; $4fd0
	jp nz,interactionDelete		; $4fd2
	ld a,PALH_ac		; $4fd5
	jp loadPaletteHeader		; $4fd7

@state1:
	call checkLinkVulnerable		; $4fda
	ret nc			; $4fdd
	ld a,(wScrollMode)		; $4fde
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02			; $4fe1
	ret nz			; $4fe3

	ld hl,w1Link.yh		; $4fe4
	ld e,Interaction.yh		; $4fe7
	ld a,(de)		; $4fe9
	cp (hl)			; $4fea
	ret c			; $4feb

	ld l,<w1Link.xh		; $4fec
	ld e,Interaction.xh		; $4fee
	ld a,(de)		; $4ff0
	sub (hl)		; $4ff1
	jr nc,+			; $4ff2
	cpl			; $4ff4
	inc a			; $4ff5
+
	cp $09			; $4ff6
	ret nc			; $4ff8

	; Link has approached, start the cutscene
	ld a,CUTSCENE_WARP_TO_TWINROVA_FIGHT		; $4ff9
	ld (wCutsceneTrigger),a		; $4ffb
	ld (wMenuDisabled),a		; $4ffe

	; Make the flames invisible
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled		; $5001
--
	ld l,Interaction.enabled		; $5004
	ldi a,(hl)		; $5006
	or a			; $5007
	jr z,++			; $5008
	ldi a,(hl)		; $500a
	cp INTERACID_TWINROVA_FLAME			; $500b
	jr nz,++		; $500d
	ld l,Interaction.visible		; $500f
	res 7,(hl)		; $5011
++
	inc h			; $5013
	ld a,h			; $5014
	cp LAST_INTERACTION_INDEX+1			; $5015
	jr c,--			; $5017
	jp interactionDelete		; $5019


; ==============================================================================
; INTERACID_EXPLOSION_WITH_DEBRIS
; ==============================================================================
interactionCode99:
	ld e,Interaction.state		; $501c
	ld a,(de)		; $501e
	rst_jumpTable			; $501f
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $5024
	ld (de),a		; $5026
	call interactionInitGraphics		; $5027
	call objectSetVisible81		; $502a
	ld e,Interaction.subid		; $502d
	ld a,(de)		; $502f
	rst_jumpTable			; $5030
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02

@initSubid00:
	inc e			; $5037
	ld a,(de) ; [var03]
	or a			; $5039
	ret z			; $503a

	call getRandomNumber_noPreserveVars		; $503b
	and $03			; $503e
	ld hl,@subid0Positions		; $5040
	rst_addDoubleIndex			; $5043
	call getRandomNumber		; $5044
	and $07			; $5047
	sub $03			; $5049
	add (hl)		; $504b
	ld b,a			; $504c
	inc hl			; $504d
	call getRandomNumber		; $504e
	and $07			; $5051
	sub $03			; $5053
	add (hl)		; $5055
	ld c,a			; $5056
	jp interactionSetPosition		; $5057

@initSubid02:
	ld e,Interaction.var38		; $505a
	ld a,(de)		; $505c
	res 6,a			; $505d
	ld e,Interaction.visible		; $505f
	ld (de),a		; $5061

@initSubid01:
	; Determine angle based on var03 with a small random element
	call getRandomNumber_noPreserveVars		; $5062
	and $03			; $5065
	add $02			; $5067
	ld c,a			; $5069
	ld h,d			; $506a
	ld l,Interaction.var03		; $506b
	ld a,(hl)		; $506d
	add a			; $506e
	add a			; $506f
	add a			; $5070
	add c			; $5071
	and $1f			; $5072
	ld l,Interaction.angle		; $5074
	ld (hl),a		; $5076

	; Set speed randomly
	call getRandomNumber		; $5077
	and $03			; $507a
	ld bc,@subid1And2Speeds		; $507c
	call addAToBc		; $507f
	ld a,(bc)		; $5082
	ld l,Interaction.speed		; $5083
	ld (hl),a		; $5085
	ld l,Interaction.speedZ		; $5086
	ld (hl),<(-$180)		; $5088
	inc l			; $508a
	ld (hl),>(-$180)		; $508b
	ret			; $508d

@state1:
	ld e,Interaction.subid		; $508e
	ld a,(de)		; $5090
	rst_jumpTable			; $5091
	.dw @runSubid0
	.dw @runSubid1Or2
	.dw @runSubid1Or2

@runSubid0:
	call interactionAnimate		; $5098
	ld e,Interaction.animParameter		; $509b
	ld a,(de)		; $509d
	or a			; $509e
	ret z			; $509f
	inc a			; $50a0
	jp z,interactionDelete		; $50a1

	xor a			; $50a4
	ld (de),a		; $50a5
	ldh (<hFF8B),a	; $50a6
	ldh (<hFF8D),a	; $50a8
	ldh (<hFF8C),a	; $50aa

	; Spawn 4 pieces of debris
	ld b,$04		; $50ac
--
	call getFreeInteractionSlot		; $50ae
	ret nz			; $50b1
	ld (hl),INTERACID_EXPLOSION_WITH_DEBRIS		; $50b2
	inc l			; $50b4
	inc (hl)		; $50b5
	inc l			; $50b6
	ld (hl),b		; $50b7
	call objectCopyPosition		; $50b8
	dec b			; $50bb
	jr nz,--		; $50bc
	ret			; $50be

@subid1And2Speeds:
	.db SPEED_180
	.db SPEED_1c0
	.db SPEED_200
	.db SPEED_240

@runSubid1Or2:
	call objectApplySpeed		; $50c3
	ld c,$28		; $50c6
	call objectUpdateSpeedZ_paramC		; $50c8
	jp z,interactionDelete		; $50cb
	ret			; $50ce

; One of these positions is picked at random
@subid0Positions:
	.db $48 $48
	.db $48 $58
	.db $58 $48
	.db $58 $58


; ==============================================================================
; INTERACID_CARPENTER
;
; Variables:
;   var3f: Nonzero if the carpenter has returned to the boss
; ==============================================================================
interactionCode9a:
	ld e,Interaction.state		; $50d7
	ld a,(de)		; $50d9
	rst_jumpTable			; $50da
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld e,Interaction.subid		; $50e1
	ld a,(de)		; $50e3
	cp $09			; $50e4
	jr z,@initialize	; $50e6

	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT		; $50e8
	call checkGlobalFlag		; $50ea
	jp nz,@delete		; $50ed

	; Carpenters don't appear in linked game until Zelda's saved
	call checkIsLinkedGame		; $50f0
	jr z,++			; $50f3
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA		; $50f5
	call checkGlobalFlag		; $50f7
	jr z,@delete	; $50fa
++
	ld e,Interaction.subid		; $50fc
	ld a,(de)		; $50fe
	inc a			; $50ff
	jr z,@runSubidFF	; $5100

@initialize:
	call interactionIncState		; $5102
	call interactionInitGraphics		; $5105
	call objectSetVisiblec2		; $5108
	ld a,>TX_2300		; $510b
	call interactionSetHighTextIndex		; $510d
	ld e,Interaction.subid		; $5110
	ld a,(de)		; $5112
	and $0f			; $5113
	rst_jumpTable			; $5115
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @initSubid04
	.dw $0000
	.dw $0000
	.dw $0000
	.dw $0000
	.dw @initSubid09


; Checks if you leave the area without finding all the carpenters
@runSubidFF:
	ld a,(wTmpcfc0.carpenterSearch.cfd0)		; $512a
	or a			; $512d
	ret z			; $512e
	ld a,(wScrollMode)		; $512f
	and SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02			; $5132
	ret nz			; $5134

	ld e,Interaction.var3f		; $5135
	ld a,(de)		; $5137
	or a			; $5138
	jr z,++			; $5139
	dec a			; $513b
	ld (de),a		; $513c
	ld (wDisallowMountingCompanion),a		; $513d
++
	ld e,Interaction.state2		; $5140
	ld a,(de)		; $5142
	dec a			; $5143
	jr z,@@substate1	; $5144

@@substate0:
	ld a,(wLinkObjectIndex)		; $5146
	ld h,a			; $5149
	ld l,SpecialObject.xh		; $514a
	ld a,$10		; $514c
	cp (hl)			; $514e
	ret c			; $514f
	ld a,$01 ; [state2] = $01
	ld (de),a		; $5152
	ld bc,TX_2307		; $5153
	jp showText		; $5156

@@substate1:
	call retIfTextIsActive		; $5159
	ld a,(wSelectedTextOption)		; $515c
	dec a			; $515f
	jr z,++			; $5160
	ld hl,wTmpcfc0.carpenterSearch.cfd0		; $5162
	ld b,$10		; $5165
	call clearMemory		; $5167
@delete:
	jp interactionDelete		; $516a

++
	call resetLinkInvincibility		; $516d
	ld a,-60		; $5170
	ld (w1Link.invincibilityCounter),a		; $5172
	ld a,$78		; $5175
	ld (wDisallowMountingCompanion),a		; $5177
	ld e,Interaction.var3f		; $517a
	ld (de),a		; $517c
	ld a,ANGLE_RIGHT		; $517d
	ld (w1Link.angle),a		; $517f
	ld e,Interaction.state2		; $5182
	xor a			; $5184
	ld (de),a		; $5185
	ld a,(wLinkObjectIndex)		; $5186
	ld h,a			; $5189
	ld l,SpecialObject.xh		; $518a
	ld (hl),$12		; $518c
	rrca			; $518e
	ret nc			; $518f

	ld l,SpecialObject.id		; $5190
	ld a,(hl)		; $5192
	ld l,SpecialObject.state		; $5193
	cp SPECIALOBJECTID_RICKY			; $5195
	jr nz,++		; $5197

	; Do something with Ricky's state?
	ldi a,(hl)		; $5199
	cp $05			; $519a
	ret nz			; $519c
	ld a,$03		; $519d
	ld (hl),a		; $519f
	ret			; $51a0
++
	cp SPECIALOBJECTID_DIMITRI			; $51a1
	ret nz			; $51a3

	; Do something with Dimitri's state?
	ld a,(hl)		; $51a4
	cp $08			; $51a5
	ret nz			; $51a7
	ld (hl),$0d		; $51a8
	ret			; $51aa

@initSubid01:
	xor a			; $51ab
	ld e,Interaction.oamFlags		; $51ac
	ld (de),a		; $51ae
	call objectMakeTileSolid		; $51af
	ld h,>wRoomLayout		; $51b2
	ld (hl),$00		; $51b4
	jr @checkDoBridgeBuildingCutscene		; $51b6

@initSubid02:
@initSubid03:
@initSubid04:
	ld a,(wActiveRoom)		; $51b8
	cp <ROOM_AGES_025			; $51bb
	jr z,@@inBridgeRoom	; $51bd

	ld a,(de)		; $51bf
	swap a			; $51c0
	and $0f			; $51c2
	ld hl,wAnimalCompanion		; $51c4
	cp (hl)			; $51c7
	jr nz,@delete	; $51c8
	ld a,(de)		; $51ca
	and $0f			; $51cb
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound		; $51cd
	call checkFlag		; $51d0
	jr nz,@delete2	; $51d3
	jr @checkDoBridgeBuildingCutscene		; $51d5

@@inBridgeRoom:
	ld a,(de)		; $51d7
	and $0f			; $51d8
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound		; $51da
	call checkFlag		; $51dd
	ld e,Interaction.var3f		; $51e0
	ld (de),a		; $51e2
	jr z,@delete2	; $51e3

	; Check if all 3 have been found
	ld a,(hl)		; $51e5
	cp $1c			; $51e6
	jr nz,@checkDoBridgeBuildingCutscene	; $51e8

	ld e,Interaction.subid		; $51ea
	ld a,(de)		; $51ec
	add $04			; $51ed
	ld (de),a		; $51ef
	jr @checkDoBridgeBuildingCutscene		; $51f0

@initSubid00:
	ld a,$03		; $51f2
	ld e,Interaction.oamFlags		; $51f4
	ld (de),a		; $51f6
	ld a,(wTmpcfc0.carpenterSearch.carpentersFound)		; $51f7
	cp $1c			; $51fa
	jr nz,@checkDoBridgeBuildingCutscene	; $51fc
	ld e,Interaction.subid		; $51fe
	ld a,$05		; $5200
	ld (de),a		; $5202
	ld a,$58		; $5203
	ld e,Interaction.xh		; $5205
	ld (de),a		; $5207

@checkDoBridgeBuildingCutscene:
	ld a,GLOBALFLAG_SYMMETRY_BRIDGE_BUILT		; $5208
	call checkGlobalFlag		; $520a
	jr nz,@delete2	; $520d

@initSubid09:
	call objectMarkSolidPosition		; $520f
	ld e,Interaction.subid		; $5212
	ld a,(de)		; $5214
	and $0f			; $5215
	ld hl,@animationsForBridgeBuildCutsceneStart		; $5217
	rst_addAToHl			; $521a
	ld a,(hl)		; $521b
	call interactionSetAnimation		; $521c
	ld a,$06		; $521f
	call objectSetCollideRadius		; $5221
	call interactionSetAlwaysUpdateBit		; $5224
	jp @loadScript		; $5227


@state1:
	ld e,Interaction.subid		; $522a
	ld a,(de)		; $522c
	and $0f			; $522d
	rst_jumpTable			; $522f
	.dw @runSubid
	.dw @runSubid01
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid
	.dw @runSubid

@runSubid:
	call interactionAnimateAsNpc		; $5244
	ld c,$40		; $5247
	call objectUpdateSpeedZ_paramC		; $5249
	call interactionRunScript		; $524c
	ret nc			; $524f
@delete2:
	jp interactionDelete		; $5250

@runSubid01:
	ld a,(wTmpcfc0.carpenterSearch.cfd0)		; $5253
	cp $0b			; $5256
	ret nz			; $5258
	ld a,$3a		; $5259
	ld c,$55		; $525b
	call setTile		; $525d
	jr @delete2		; $5260

; State 2: carpender jumping away until he goes off-screen
@state2:
	call interactionAnimate		; $5262
	ld h,d			; $5265
	ld l,Interaction.angle		; $5266
	ld (hl),ANGLE_LEFT		; $5268
	ld l,Interaction.speed		; $526a
	ld (hl),SPEED_100		; $526c
	call objectApplySpeed		; $526e
	call objectCheckWithinScreenBoundary		; $5271
	jr nc,@@leftScreen	; $5274

	ld c,$10		; $5276
	call objectUpdateSpeedZ_paramC		; $5278
	ret nz			; $527b
	ld bc,-$200		; $527c
	call objectSetSpeedZ		; $527f
	ld a,SND_JUMP		; $5282
	jp playSound		; $5284

@@leftScreen:
	; If that was the last carpenter, warp Link to the bridge screen
	ld e,Interaction.subid		; $5287
	ld a,(de)		; $5289
	and $0f			; $528a
	ld hl,wTmpcfc0.carpenterSearch.carpentersFound		; $528c
	call setFlag		; $528f
	ld a,(hl)		; $5292
	cp $1c			; $5293
	ld hl,@warpDest		; $5295
	jp z,setWarpDestVariables		; $5298
	xor a			; $529b
	ld (wMenuDisabled),a		; $529c
	ld (wDisabledObjects),a		; $529f
	jr @delete2		; $52a2

@warpDest:
	m_HardcodedWarpA ROOM_AGES_025, $00, $48, $03


@loadScript:
	ld e,Interaction.subid		; $52a9
	ld a,(de)		; $52ab
	and $0f			; $52ac
	ld hl,@scriptTable		; $52ae
	rst_addDoubleIndex			; $52b1
	ldi a,(hl)		; $52b2
	ld h,(hl)		; $52b3
	ld l,a			; $52b4
	jp interactionSetScript		; $52b5

@scriptTable:
	.dw carpenter_subid00Script
	.dw carpenter_subid00Script
	.dw carpenter_subid02Script
	.dw carpenter_subid03Script
	.dw carpenter_subid04Script
	.dw carpenter_subid05Script
	.dw carpenter_subid06Script
	.dw carpenter_subid07Script
	.dw carpenter_subid08Script
	.dw carpenter_subid09Script

; Animations for each subid
@animationsForBridgeBuildCutsceneStart:
	.db $04 $06 $02 $02 $02 $05 $03 $02
	.db $02 $00


; ==============================================================================
; INTERACID_RAFTWRECK_CUTSCENE
; ==============================================================================
interactionCode9b:
	ld e,Interaction.state		; $52d6
	ld a,(de)		; $52d8
	rst_jumpTable			; $52d9
	.dw @state0
	.dw @state1

@state0:
	call getThisRoomFlags		; $52de
	bit ROOMFLAG_BIT_40,a			; $52e1
	jp nz,interactionDelete		; $52e3

	ld a,$01		; $52e6
	ld (wDisabledObjects),a		; $52e8
	ld (wMenuDisabled),a		; $52eb
	ld a,(wLinkObjectIndex)		; $52ee
	ld h,a			; $52f1
	ld l,SpecialObject.xh		; $52f2
	ld c,(hl)		; $52f4
	ld b,$76		; $52f5
	call interactionSetPosition		; $52f7
	call setLinkForceStateToState08		; $52fa
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $52fd
	jp interactionIncState		; $5300

@state1:
	call @updateSubstate		; $5303
	ld a,(wLinkObjectIndex)		; $5306
	ld h,a			; $5309
	ld l,SpecialObject.yh		; $530a
	jp objectCopyPosition		; $530c

@updateSubstate:
	ld e,Interaction.state2		; $530f
	ld a,(de)		; $5311
	cp $02			; $5312
	call nc,interactionRunScript		; $5314
	ld e,Interaction.state2		; $5317
	ld a,(de)		; $5319
	rst_jumpTable			; $531a
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	ld a,(wScrollMode)		; $532d
	and SCROLLMODE_01			; $5330
	ret z			; $5332

	; Initialize Link's speed/direction to move to the center of the screen
	call interactionIncState2		; $5333
	ld l,Interaction.speed		; $5336
	ld (hl),SPEED_80		; $5338
	ld l,Interaction.xh		; $533a
	ld a,(hl)		; $533c
	sub $50			; $533d
	ld c,DIR_LEFT		; $533f
	ld b,ANGLE_LEFT		; $5341
	jr nc,++		; $5343
	ld c,DIR_RIGHT		; $5345
	ld b,ANGLE_RIGHT		; $5347
	cpl			; $5349
	inc a			; $534a
++
	ld l,Interaction.angle		; $534b
	ld (hl),b		; $534d
	ld l,Interaction.counter1		; $534e
	add a			; $5350
	ld (hl),a		; $5351
	ld a,c			; $5352
	jp setLinkDirection		; $5353

@substate1:
	ld h,d			; $5356
	ld l,Interaction.counter1		; $5357
	ld a,(hl)		; $5359
	or a			; $535a
	jr z,++			; $535b
	dec (hl)		; $535d
	jp objectApplySpeed		; $535e
++
	; Begin the script
	call interactionIncState2		; $5361
	ld hl,raftwreckCutsceneScript		; $5364
	jp interactionSetScript		; $5367

@substate2:
	ld a,(wTmpcfc0.genericCutscene.state)		; $536a
	cp $01			; $536d
	ret nz			; $536f

@initScreenFlashing:
	ld hl,wGenericCutscene.cbb3		; $5370
	ld (hl),$00		; $5373
	ld hl,wGenericCutscene.cbba		; $5375
	ld (hl),$ff		; $5378
	jp interactionIncState2		; $537a

@substate3:
@substate5:
	ld hl,wGenericCutscene.cbb3		; $537d
	ld b,$01		; $5380
	call flashScreen		; $5382
	ret z			; $5385

	call interactionIncState2		; $5386
	ldi a,(hl)		; $5389
	cp $03			; $538a
	ld a,$5a		; $538c
	jr z,+			; $538e
	ld a,$78		; $5390
+
	ld (hl),a		; $5392
	ld a,$f1		; $5393
	ld (wPaletteThread_parameter),a		; $5395
	jp darkenRoom		; $5398

@substate4:
	call interactionDecCounter1		; $539b
	ret nz			; $539e
	jr @initScreenFlashing		; $539f

@substate6:
	call interactionDecCounter1		; $53a1
	ret nz			; $53a4
	ld a,$02		; $53a5
	ld (wTmpcfc0.genericCutscene.state),a		; $53a7
	jp interactionIncState2		; $53aa

@substate7:
	ld a,(wTmpcfc0.genericCutscene.state)		; $53ad
	cp $03			; $53b0
	jr nz,++		; $53b2

	call interactionIncState2		; $53b4
	ld l,Interaction.counter1		; $53b7
	ld (hl),20		; $53b9
	ret			; $53bb
++
	ld e,Interaction.var38		; $53bc
	ld a,(de)		; $53be
	or a			; $53bf
	ret z			; $53c0
	jp @oscillateY		; $53c1

@substate8:
	call interactionDecCounter1		; $53c4
	ret nz			; $53c7
	ld a,SNDCTRL_FAST_FADEOUT		; $53c8
	call playSound		; $53ca
	call getThisRoomFlags		; $53cd
	set ROOMFLAG_BIT_40,(hl)		; $53d0
	ld hl,w1Companion.enabled		; $53d2
	res 1,(hl)		; $53d5
	ld a,>w1Link		; $53d7
	ld (wLinkObjectIndex),a		; $53d9
	ld hl,@tokayWarpDest		; $53dc
	jp setWarpDestVariables		; $53df

@tokayWarpDest:
	m_HardcodedWarpA ROOM_AGES_1aa, $00, $42, $03

@oscillateY:
	ld a,(wFrameCounter)		; $53e7
	and $07			; $53ea
	ret nz			; $53ec
	ld a,(wFrameCounter)		; $53ed
	and $38			; $53f0
	swap a			; $53f2
	rlca			; $53f4
	ld hl,@yOscillation		; $53f5
	rst_addAToHl			; $53f8
	ld e,Interaction.yh		; $53f9
	ld a,(de)		; $53fb
	add (hl)		; $53fc
	ld (de),a		; $53fd
	ret			; $53fe

@yOscillation:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; ==============================================================================
; INTERACID_KING_ZORA
; ==============================================================================
interactionCode9c:
	ld e,Interaction.subid		; $5407
	ld a,(de)		; $5409
	ld e,Interaction.state		; $540a
	rst_jumpTable			; $540c
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Present King Zora
@subid0:
	ld a,(de)		; $5413
	or a			; $5414
	jr z,@subid0State0	; $5416

@state1:
	call interactionRunScript		; $5417
	jp interactionAnimate		; $541a

@subid0State0:
	ld a,GLOBALFLAG_KING_ZORA_CURED		; $541d
	call checkGlobalFlag		; $541f
	jp z,interactionDelete		; $5422
	call @choosePresentKingZoraScript		; $5425

@setScriptAndInit:
	call interactionSetScript		; $5428
	ld e,Interaction.pressedAButton		; $542b
	call objectAddToAButtonSensitiveObjectList		; $542d
	call interactionInitGraphics		; $5430
	call interactionSetAlwaysUpdateBit		; $5433
	call interactionIncState		; $5436
	ld a,$0a		; $5439
	call objectSetCollideRadius		; $543b
	jp objectSetVisible82		; $543e


; Past King Zora
@subid1:
	ld a,(de)		; $5441
	or a			; $5442
	jr nz,@state1	; $5443

	call @choosePastKingZoraScript		; $5445
	jr @setScriptAndInit		; $5448


; Potion sprite
@subid2:
	ld a,(de)		; $544a
	or a			; $544b
	jr z,@subid2State0	; $544c

@subid2State1:
	call interactionDecCounter1		; $544e
	ret nz			; $5451
	jp interactionDelete		; $5452

@subid2State0:
	call interactionInitGraphics		; $5455
	call interactionIncState		; $5458
	ld l,Interaction.counter1		; $545b
	ld (hl),$24		; $545d
	jp objectSetVisible81		; $545f


@choosePresentKingZoraScript:
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $5462
	call checkGlobalFlag		; $5464
	jr z,@@pollutionNotFixed	; $5467

	ld a,TREASURE_ESSENCE		; $5469
	call checkTreasureObtained		; $546b
	bit 6,a			; $546e
	jr z,@@justCleanedWater	; $5470

	ld a,GLOBALFLAG_FINISHEDGAME		; $5472
	call checkGlobalFlag		; $5474
	ld hl,kingZoraScript_present_afterD7		; $5477
	ret z			; $547a

	ld a,TREASURE_SWORD		; $547b
	call checkTreasureObtained		; $547d
	and $01			; $5480
	ld e,Interaction.var03		; $5482
	ld (de),a		; $5484
	ld hl,kingZoraScript_present_postGame		; $5485
	ret			; $5488

@@pollutionNotFixed:
	ld a,TREASURE_LIBRARY_KEY		; $5489
	call checkTreasureObtained		; $548b
	ld hl,kingZoraScript_present_acceptedTask		; $548e
	ret c			; $5491

	call getThisRoomFlags		; $5492
	bit 6,(hl)		; $5495
	ld hl,kingZoraScript_present_firstTime		; $5497
	ret z			; $549a
	ld hl,kingZoraScript_present_giveKey		; $549b
	ret			; $549e

@@justCleanedWater:
	ld a,GLOBALFLAG_GOT_PERMISSION_TO_ENTER_JABU		; $549f
	call checkGlobalFlag		; $54a1
	ld hl,kingZoraScript_present_justCleanedWater		; $54a4
	ret z			; $54a7
	ld hl,kingZoraScript_present_cleanedWater		; $54a8
	ret			; $54ab

@choosePastKingZoraScript:
	ld a,GLOBALFLAG_KING_ZORA_CURED		; $54ac
	call checkGlobalFlag		; $54ae
	jr z,@@notCured	; $54b1

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $54b3
	call checkGlobalFlag		; $54b5
	ld hl,kingZoraScript_past_justCured		; $54b8
	ret z			; $54bb

	ld a,TREASURE_ESSENCE		; $54bc
	call checkTreasureObtained		; $54be
	bit 6,a			; $54c1
	ld hl,kingZoraScript_past_cleanedWater		; $54c3
	ret z			; $54c6
	ld hl,kingZoraScript_past_afterD7		; $54c7
	ret			; $54ca

@@notCured:
	ld a,TREASURE_POTION		; $54cb
	call checkTreasureObtained		; $54cd
	ld hl,kingZoraScript_past_dontHavePotion		; $54d0
	ret nc			; $54d3
	ld hl,kingZoraScript_past_havePotion		; $54d4
	ret			; $54d7


; ==============================================================================
; INTERACID_TOKKEY
; ==============================================================================
interactionCode9d:
	ld e,Interaction.state		; $54d8
	ld a,(de)		; $54da
	rst_jumpTable			; $54db
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call interactionInitGraphics		; $54e6
	ld a,>TX_2c00		; $54e9
	call interactionSetHighTextIndex		; $54eb
	ld hl,tokkeyScript		; $54ee
	call interactionSetScript		; $54f1
	call objectSetVisible82		; $54f4
	jp interactionIncState		; $54f7


@state1:
	; Check that Link's talked to the guy once
	ld a,(wTmpcfc0.genericCutscene.state)		; $54fa
	bit 0,a			; $54fd
	jr z,@runScript	; $54ff

	ld a,(wLinkPlayingInstrument)		; $5501
	cp $01			; $5504
	jr nz,@runScript	; $5506

	call checkLinkCollisionsEnabled		; $5508
	ret nc			; $550b

	ld a,(wActiveTilePos)		; $550c
	cp $32			; $550f
	jr z,++			; $5511
	ld bc,TX_2c05		; $5513
	jp showText		; $5516
++
	ld a,60		; $5519
	ld bc,$f810		; $551b
	call objectCreateExclamationMark		; $551e
	ld hl,tokkeyScript_justHeardTune		; $5521
	call interactionSetScript		; $5524
	jp interactionIncState		; $5527

@runScript:
	ld c,$20		; $552a
	call objectUpdateSpeedZ_paramC		; $552c
	call interactionRunScript		; $552f
	jp c,interactionDelete		; $5532
	jp npcFaceLinkAndAnimate		; $5535


@state2:
	call @checkCreateMusicNote		; $5538
	call interactionAnimate		; $553b

@state4:
	call interactionRunScript		; $553e
	ld c,$20		; $5541
	jp objectUpdateSpeedZ_paramC		; $5543

@state3:
	call @checkCreateMusicNote		; $5546
	call interactionRunScript		; $5549
	call interactionAnimate		; $554c
	call interactionAnimate		; $554f
	ld c,$60		; $5552
	call objectUpdateSpeedZ_paramC		; $5554
	ret nz			; $5557
	ld bc,-$200		; $5558
	jp objectSetSpeedZ		; $555b


@checkCreateMusicNote:
	ld a,(wTmpcfc0.genericCutscene.state)		; $555e
	bit 1,a			; $5561
	ret z			; $5563
	ld a,(wFrameCounter)		; $5564
	and $0f			; $5567
	ret nz			; $5569
	call getRandomNumber		; $556a
	and $01			; $556d
	ld bc,$f808		; $556f
	jp objectCreateFloatingMusicNote		; $5572


; ==============================================================================
; INTERACID_WATER_PUSHBLOCK
; ==============================================================================
interactionCode9e:
	ld e,Interaction.subid		; $5575
	ld a,(de)		; $5577
	rst_jumpTable			; $5578
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,Interaction.state		; $557d
	ld a,(de)		; $557f
	rst_jumpTable			; $5580
	.dw @subid0State0
	.dw @state1
	.dw @state2
	.dw @subid0State3
	.dw objectPreventLinkFromPassing

@subid0State0:
	call getThisRoomFlags		; $558b
	and $01			; $558e
	jp nz,interactionDelete		; $5590

@initialize:
	call interactionInitGraphics		; $5593
	call objectMarkSolidPosition		; $5596
	ld a,$06		; $5599
	call objectSetCollideRadius		; $559b

	ld l,Interaction.speed		; $559e
	ld (hl),SPEED_80		; $55a0
	ld l,Interaction.counter1		; $55a2
	ld (hl),30		; $55a4

	call objectSetVisible82		; $55a6
	jp interactionIncState		; $55a9


; Check if Link is pushing against the block
@state1:
	call objectPreventLinkFromPassing		; $55ac
	jr nc,@@notPushing	; $55af
	call objectCheckLinkPushingAgainstCenter		; $55b1
	jr nc,@@notPushing	; $55b4

	; Link is pushing against in
	ld a,$01		; $55b6
	ld (wForceLinkPushAnimation),a		; $55b8
	call interactionDecCounter1		; $55bb
	ret nz			; $55be
	jr @@pushedLongEnough			; $55bf

@@notPushing:
	ld e,Interaction.counter1		; $55c1
	ld a,30		; $55c3
	ld (de),a		; $55c5
	ret			; $55c6

@@pushedLongEnough:
	ld c,$28		; $55c7
	call objectCheckLinkWithinDistance		; $55c9
	ld b,a			; $55cc
	ld e,Interaction.subid		; $55cd
	ld a,(de)		; $55cf
	or a			; $55d0
	ld c,$02		; $55d1
	jr z,+			; $55d3
	ld c,$06		; $55d5
+
	ld a,b			; $55d7
	cp c			; $55d8
	ret nz			; $55d9
	ld e,Interaction.direction		; $55da
	xor $04			; $55dc
	ld (de),a		; $55de

	ld h,d			; $55df
	ld l,Interaction.direction		; $55e0
	ld a,(hl)		; $55e2
	add a			; $55e3
	add a			; $55e4
	ld l,Interaction.angle		; $55e5
	ld (hl),a		; $55e7

	ld l,Interaction.counter1		; $55e8
	ld (hl),$40		; $55ea

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $55ec
	ld (wDisabledObjects),a		; $55ee
	ld (wMenuDisabled),a		; $55f1
	ld a,SNDCTRL_STOPMUSIC		; $55f4
	call playSound		; $55f6
	ld a,SND_MOVEBLOCK		; $55f9
	call playSound		; $55fb
	jp interactionIncState		; $55fe


; Link has pushed the block; waiting for it to move to the other side
@state2:
	call objectApplySpeed		; $5601
	call objectPreventLinkFromPassing		; $5604
	call interactionDecCounter1		; $5607
	ret nz			; $560a
	ld (hl),70		; $560b
	jp interactionIncState		; $560d


; Pushed block from right to left
@subid0State3:
	ld e,Interaction.state2		; $5610
	ld a,(de)		; $5612
	rst_jumpTable			; $5613
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4
	.dw @subid0Substate5
	.dw @subid0Substate6
	.dw @subid0Substate7
	.dw @subid0Substate8
	.dw @subid0Substate9
	.dw @substateA
	.dw @substateB

@subid0Substate0:
	call interactionDecCounter1		; $562c
	ret nz			; $562f
	ld (hl),$08		; $5630
	ld a,SND_FLOODGATES		; $5632
	call playSound		; $5634
	ld a,$63		; $5637
	call @setInterleavedHoleGroundTile		; $5639
	ld a,$65		; $563c
	call @setInterleavedHoleGroundTile		; $563e
	jp interactionIncState2		; $5641

@subid0Substate1:
	ldbc $63,$65		; $5644
@setGroundTilesWhenCounterIsZero:
	call interactionDecCounter1		; $5647
	ret nz			; $564a
	ld (hl),$08		; $564b
	ld a,b			; $564d
	call @setGroundTile		; $564e
	ld a,c			; $5651
	call @setPuddleTile		; $5652
	jp interactionIncState2		; $5655

@subid0Substate2:
	ldbc $62,$66		; $5658
@setHoleTilesWhenCounterIsZero:
	call interactionDecCounter1		; $565b
	ret nz			; $565e
	ld (hl),$08		; $565f
	ld a,b			; $5661
	call @setInterleavedHoleGroundTile		; $5662
	ld a,c			; $5665
	call @setInterleavedHoleGroundTile		; $5666
	jp interactionIncState2		; $5669

@subid0Substate3:
	ldbc $62,$66		; $566c
	jr @setGroundTilesWhenCounterIsZero		; $566f

@subid0Substate4:
	ldbc $61,$67		; $5671
	jr @setHoleTilesWhenCounterIsZero		; $5674

@subid0Substate5:
	ldbc $61,$67		; $5676
	jr @setGroundTilesWhenCounterIsZero		; $5679

@subid0Substate6:
	call interactionDecCounter1		; $567b
	ret nz			; $567e
	ld (hl),$08		; $567f
	ld a,$60		; $5681
	call @setInterleavedPuddleHoleTile		; $5683
	ld a,$68		; $5686
	call @setInterleavedHoleGroundTile		; $5688
	jp interactionIncState2		; $568b

@subid0Substate7:
	call interactionDecCounter1		; $568e
	ret nz			; $5691
	ld (hl),$08		; $5692
	ld a,$60		; $5694
	call @setHoleTile		; $5696
	ld a,$68		; $5699
	call @setPuddleTile		; $569b
	jp interactionIncState2		; $569e

@subid0Substate8:
	call interactionDecCounter1		; $56a1
	ret nz			; $56a4
	ld (hl),$08		; $56a5
	ld a,$69		; $56a7
	call @setInterleavedPuddleHoleTile		; $56a9
	jp interactionIncState2		; $56ac

@subid0Substate9:
	call interactionDecCounter1		; $56af
	ret nz			; $56b2
	ld (hl),90		; $56b3
	ld c,$69		; $56b5

@setWaterTileAndIncState2:
	ld a,TILEINDEX_WATER		; $56b7
	call setTile		; $56b9
	jp interactionIncState2		; $56bc

@substateA:
	call interactionDecCounter1		; $56bf
	ret nz			; $56c2
	ld (hl),$48		; $56c3
	ld a,SNDCTRL_STOPSFX		; $56c5
	call playSound		; $56c7
	ld a,SND_SOLVEPUZZLE		; $56ca
	call playSound		; $56cc
	jp interactionIncState2		; $56cf

@substateB:
	call interactionDecCounter1		; $56d2
	ret nz			; $56d5
	ld a,(wActiveMusic)		; $56d6
	call playSound		; $56d9
	xor a			; $56dc
	ld (wDisabledObjects),a		; $56dd
	ld (wMenuDisabled),a		; $56e0
	call @swapRoomLayouts		; $56e3
	jp interactionIncState		; $56e6

;;
; @param	a	Position
; @addr{56e9}
@setHoleTile:
	ld c,a			; $56e9
	ld a,TILEINDEX_HOLE		; $56ea
	jp setTile		; $56ec

;;
; @param	a	Position
; @addr{56ef}
@setInterleavedPuddleHoleTile:
	ld hl,@@data		; $56ef
	jr @setInterleavedTile			; $56f2

@@data:
	.db $f3 $f9 $03

;;
; @param	a	Position
; @addr{56ef}
@setInterleavedHolePuddleTile:
	ld hl,@@data		; $56f7
	jr @setInterleavedTile			; $56fa

@@data:
	.db $f3 $f9 $01

;;
; @param	a	Position
; @addr{56ff}
@setGroundTile:
	push bc			; $56ff
	ld c,a			; $5700
	ld a,$1b		; $5701
	call setTile		; $5703
	pop bc			; $5706
	ret			; $5707

;;
; @param	a	Position
; @addr{5708}
@setPuddleTile:
	push bc			; $5708
	ld c,a			; $5709
	ld a,TILEINDEX_PUDDLE		; $570a
	call setTile		; $570c
	pop bc			; $570f
	ret			; $5710

;;
; @param	a	Position
; @addr{5711}
@setInterleavedHoleGroundTile:
	ld hl,@@data		; $5711
	jr @setInterleavedTile			; $5714

@@data:
	.db $1b $f9 $03

@setInterleavedGroundHoleTile:
	ld hl,@@data		; $5719
	jr @setInterleavedTile			; $571b

@@data:
	.db $1b $f9 $01

;;
; @param	a	Position
; @param	hl	Interleaved tile data
; @addr{5721}
@setInterleavedTile:
	ldh (<hFF8C),a	; $5721
	ldi a,(hl)		; $5723
	ldh (<hFF8F),a	; $5724
	ldi a,(hl)		; $5726
	ldh (<hFF8E),a	; $5727
	ldi a,(hl)		; $5729
	jp setInterleavedTile		; $572a

@subid1:
	ld e,Interaction.state		; $572d
	ld a,(de)		; $572f
	rst_jumpTable			; $5730
	.dw @subid1State0
	.dw @state1
	.dw @state2
	.dw @subid1State3
	.dw objectPreventLinkFromPassing

@subid1State0:
	call getThisRoomFlags		; $573b
	and $01			; $573e
	jp z,interactionDelete		; $5740
	jp @initialize		; $5743

; Pushed block from left to right
@subid1State3:
	ld e,Interaction.state2		; $5746
	ld a,(de)		; $5748
	rst_jumpTable			; $5749
	.dw @subid1Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3
	.dw @subid1Substate4
	.dw @subid1Substate5
	.dw @subid1Substate6
	.dw @subid1Substate7
	.dw @subid1Substate8
	.dw @subid1Substate9
	.dw @substateA
	.dw @substateB

@subid1Substate0:
	call interactionDecCounter1		; $5762
	ret nz			; $5765
	ld (hl),$08		; $5766
	ld a,SND_FLOODGATES		; $5768
	call playSound		; $576a
	ld a,$63		; $576d
	call @setInterleavedGroundHoleTile		; $576f
	ld a,$65		; $5772
	call @setInterleavedGroundHoleTile		; $5774
	jp interactionIncState2		; $5777

@subid1Substate1:
	ldbc $65,$63		; $577a
	jp @setGroundTilesWhenCounterIsZero		; $577d

@subid1Substate2:
	ldbc $66,$62		; $5780
@setHoleTilesWhenCounterZero_2:
	call interactionDecCounter1		; $5783
	ret nz			; $5786
	ld (hl),$08		; $5787
	ld a,b			; $5789
	call @setInterleavedGroundHoleTile		; $578a
	ld a,c			; $578d
	call @setInterleavedGroundHoleTile		; $578e
	jp interactionIncState2		; $5791

@subid1Substate3:
	ldbc $66,$62		; $5794
	jp @setGroundTilesWhenCounterIsZero		; $5797

@subid1Substate4:
	ldbc $61,$67		; $579a
	jp @setHoleTilesWhenCounterZero_2		; $579d

@subid1Substate5:
	ldbc $67,$61		; $57a0
	jp @setGroundTilesWhenCounterIsZero		; $57a3

@subid1Substate6:
	call interactionDecCounter1		; $57a6
	ret nz			; $57a9
	ld (hl),$08		; $57aa
	ld a,$60		; $57ac
	call @setInterleavedHolePuddleTile		; $57ae
	ld a,$68		; $57b1
	call @setInterleavedGroundHoleTile		; $57b3
	jp interactionIncState2		; $57b6

@subid1Substate7:
	call interactionDecCounter1		; $57b9
	ret nz			; $57bc
	ld (hl),$08		; $57bd
	ld a,$68		; $57bf
	call @setGroundTile		; $57c1
	ld c,$60		; $57c4
	jp @setWaterTileAndIncState2		; $57c6

@subid1Substate8:
	call interactionDecCounter1		; $57c9
	ret nz			; $57cc
	ld (hl),$08		; $57cd
	ld a,$69		; $57cf
	call @setInterleavedHolePuddleTile		; $57d1
	jp interactionIncState2		; $57d4

@subid1Substate9:
	call interactionDecCounter1		; $57d7
	ret nz			; $57da
	ld (hl),$5a		; $57db
	ld a,$69		; $57dd
	call @setHoleTile		; $57df
	jp interactionIncState2		; $57e2

;;
; Swap the room layouts in all rooms affected by the flooding.
; @addr{57e5}
@swapRoomLayouts:
	call getThisRoomFlags		; $57e5
	ld l,<ROOM_AGES_140		; $57e8
	call @@xor		; $57ea
	call @@xor		; $57ed
	call @@xor		; $57f0
	ld l,<ROOM_AGES_150		; $57f3
	call @@xor		; $57f5
	call @@xor		; $57f8
	call @@xor		; $57fb
	dec h			; $57fe
	ld l,<ROOM_AGES_040		; $57ff
	call @@xor		; $5801
	call @@xor		; $5804
	call @@xor		; $5807
	ld l,<ROOM_AGES_050		; $580a
	call @@xor		; $580c
	call @@xor		; $580f

@@xor:
	ld a,(hl)		; $5812
	xor $01			; $5813
	ldi (hl),a		; $5815
	ret			; $5816


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea1:
	call _sidescrollPlatform_checkLinkOnPlatform		; $5817
	call @updateSubid		; $581a
	jp _sidescrollingPlatformCommon		; $581d

@updateSubid:
	ld e,Interaction.state		; $5820
	ld a,(de)		; $5822
	sub $08			; $5823
	jr c,@state0To7		; $5825
	rst_jumpTable			; $5827
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw _movingPlatform_stateC

@state0To7:
	ld hl,bank0e.movingSidescrollPlatformScriptTable		; $5832
	call objectLoadMovementScript		; $5835
	call interactionInitGraphics		; $5838
	ld e,Interaction.direction		; $583b
	ld a,(de)		; $583d
	ld hl,@collisionRadii		; $583e
	rst_addDoubleIndex			; $5841
	ld e,Interaction.collisionRadiusY		; $5842
	ldi a,(hl)		; $5844
	ld (de),a		; $5845
	inc e			; $5846
	ld a,(hl)		; $5847
	ld (de),a		; $5848
	ld e,Interaction.direction		; $5849
	ld a,(de)		; $584b
	call interactionSetAnimation		; $584c
	jp objectSetVisible82		; $584f

@collisionRadii:
	.db $09 $0f
	.db $09 $17
	.db $19 $07
	.db $19 $0f
	.db $09 $07

@state8:
	ld e,Interaction.var32		; $585c
	ld a,(de)		; $585e
	ld h,d			; $585f
	ld l,Interaction.yh		; $5860
	cp (hl)			; $5862
	jr nc,+			; $5863
	jp objectApplySpeed		; $5865
+
	ld a,(de)		; $5868
	ld (hl),a		; $5869
	jp _sidescrollPlatformFunc_5bfc		; $586a

@state9:
	ld e,Interaction.xh		; $586d
	ld a,(de)		; $586f
	ld h,d			; $5870
	ld l,Interaction.var33		; $5871
	cp (hl)			; $5873
	jr nc,++		; $5874
	ld l,Interaction.speed		; $5876
	ld b,(hl)		; $5878
	ld c,ANGLE_RIGHT		; $5879
	ld a,(wLinkRidingObject)		; $587b
	cp d			; $587e
	call z,updateLinkPositionGivenVelocity		; $587f
	jp objectApplySpeed		; $5882
++
	ld a,(hl)		; $5885
	ld (de),a		; $5886
	jp _sidescrollPlatformFunc_5bfc		; $5887

@stateA:
	ld e,Interaction.yh		; $588a
	ld a,(de)		; $588c
	ld h,d			; $588d
	ld l,Interaction.var32		; $588e
	cp (hl)			; $5890
	jr nc,++		; $5891
	ld l,Interaction.speed		; $5893
	ld b,(hl)		; $5895
	ld c,ANGLE_DOWN		; $5896
	ld a,(wLinkRidingObject)		; $5898
	cp d			; $589b
	call z,updateLinkPositionGivenVelocity		; $589c
	jp objectApplySpeed		; $589f
++
	ld a,(hl)		; $58a2
	ld (de),a		; $58a3
	jp _sidescrollPlatformFunc_5bfc		; $58a4

@stateB:
	ld e,Interaction.var33		; $58a7
	ld a,(de)		; $58a9
	ld h,d			; $58aa
	ld l,Interaction.xh		; $58ab
	cp (hl)			; $58ad
	jr nc,++		; $58ae
	ld l,Interaction.speed		; $58b0
	ld b,(hl)		; $58b2
	ld c,ANGLE_LEFT		; $58b3
	ld a,(wLinkRidingObject)		; $58b5
	cp d			; $58b8
	call z,updateLinkPositionGivenVelocity		; $58b9
	jp objectApplySpeed		; $58bc
++
	ld a,(de)		; $58bf
	ld (hl),a		; $58c0
	jp _sidescrollPlatformFunc_5bfc		; $58c1


_movingPlatform_stateC:
	call interactionDecCounter1		; $58c4
	ret nz			; $58c7
	jp _sidescrollPlatformFunc_5bfc		; $58c8


; ==============================================================================
; INTERACID_MOVING_SIDESCROLL_CONVEYOR
; ==============================================================================
interactionCodea2:
	call interactionAnimate		; $58cb
	call _sidescrollPlatform_checkLinkOnPlatform		; $58ce
	call nz,_sidescrollPlatform_updateLinkKnockbackForConveyor		; $58d1
	call @updateState		; $58d4
	jp _sidescrollingPlatformCommon		; $58d7

@updateState:
	ld e,Interaction.state		; $58da
	ld a,(de)		; $58dc
	sub $08			; $58dd
	jr c,@state0To7		; $58df
	rst_jumpTable			; $58e1
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw _movingPlatform_stateC

@state0To7:
	ld hl,bank0e.movingSidescrollConveyorScriptTable		; $58ec
	call objectLoadMovementScript		; $58ef
	call interactionInitGraphics		; $58f2
	ld h,d			; $58f5
	ld l,Interaction.collisionRadiusY		; $58f6
	ld (hl),$08		; $58f8
	inc l			; $58fa
	ld (hl),$0c		; $58fb
	ld e,Interaction.direction		; $58fd
	ld a,(de)		; $58ff
	call interactionSetAnimation		; $5900
	jp objectSetVisible82		; $5903

@state8:
	ld e,Interaction.var32		; $5906
	ld a,(de)		; $5908
	ld h,d			; $5909
	ld l,Interaction.yh		; $590a
	cp (hl)			; $590c
	jr c,@applySpeed	; $590d
	ld a,(de)		; $590f
	ld (hl),a		; $5910
	jp _sidescrollPlatformFunc_5bfc		; $5911

@state9:
	ld e,Interaction.xh		; $5914
	ld a,(de)		; $5916
	ld h,d			; $5917
	ld l,Interaction.var33		; $5918
	cp (hl)			; $591a
	jr c,@applySpeed	; $591b
	ld a,(hl)		; $591d
	ld (de),a		; $591e
	jp _sidescrollPlatformFunc_5bfc		; $591f

@stateA:
	ld e,Interaction.yh		; $5922
	ld a,(de)		; $5924
	ld h,d			; $5925
	ld l,Interaction.var32		; $5926
	cp (hl)			; $5928
	jr nc,++		; $5929
	ld l,Interaction.speed		; $592b
	ld b,(hl)		; $592d
	ld c,ANGLE_DOWN		; $592e
	ld a,(wLinkRidingObject)		; $5930
	cp d			; $5933
	call z,updateLinkPositionGivenVelocity		; $5934
	jr @applySpeed		; $5937
++
	ld a,(hl)		; $5939
	ld (de),a		; $593a
	jp _sidescrollPlatformFunc_5bfc		; $593b

@stateB:
	ld e,Interaction.var33		; $593e
	ld a,(de)		; $5940
	ld h,d			; $5941
	ld l,Interaction.xh		; $5942
	cp (hl)			; $5944
	jr c,@applySpeed	; $5945
	ld a,(de)		; $5947
	ld (hl),a		; $5948
	jp _sidescrollPlatformFunc_5bfc		; $5949

@applySpeed:
	call objectApplySpeed		; $594c
	ld a,(wLinkRidingObject)		; $594f
	cp d			; $5952
	ret nz			; $5953

	ld e,Interaction.angle		; $5954
	ld a,(de)		; $5956
	rrca			; $5957
	rrca			; $5958
	ld b,a			; $5959
	ld e,Interaction.direction		; $595a
	ld a,(de)		; $595c
	add b			; $595d
	ld hl,@directions		; $595e
	rst_addDoubleIndex			; $5961
	ldi a,(hl)		; $5962
	ld c,a			; $5963
	ld b,(hl)		; $5964
	jp updateLinkPositionGivenVelocity		; $5965

@directions:
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_100
	.db ANGLE_LEFT,  SPEED_060
	.db ANGLE_RIGHT, SPEED_080
	.db ANGLE_LEFT,  SPEED_080
	.db ANGLE_RIGHT, SPEED_060
	.db ANGLE_LEFT,  SPEED_100


; ==============================================================================
; INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea3:
	ld e,Interaction.state		; $5978
	ld a,(de)		; $597a
	cp $03			; $597b
	jr z,++			; $597d

	; Only do this if the platform isn't invisible
	call _sidescrollPlatform_checkLinkOnPlatform		; $597f
	call _sidescrollingPlatformCommon		; $5982
++
	ld e,Interaction.state		; $5985
	ld a,(de)		; $5987
	rst_jumpTable			; $5988
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid		; $5993
	ld a,(de)		; $5995
	ld hl,@subidData		; $5996
	rst_addDoubleIndex			; $5999

	ld e,Interaction.state		; $599a
	ldi a,(hl)		; $599c
	ld (de),a		; $599d
	ld e,Interaction.counter1		; $599e
	ld a,(hl)		; $59a0
	ld (de),a		; $59a1

	ld e,Interaction.collisionRadiusY		; $59a2
	ld a,$08		; $59a4
	ld (de),a		; $59a6
	inc e			; $59a7
	ld (de),a		; $59a8
	call interactionInitGraphics		; $59a9
	ld e,Interaction.subid		; $59ac
	ld a,(de)		; $59ae
	cp $02			; $59af
	jp z,objectSetVisible83		; $59b1
	ret			; $59b4

@subidData:
	.db $04,  60
	.db $03, 120
	.db $01,  60

@state1:
	call _sidescrollPlatform_decCounter1		; $59bb
	ret nz			; $59be
	ld (hl),30		; $59bf
	ld l,e			; $59c1
	inc (hl)		; $59c2
	xor a			; $59c3
	ret			; $59c4

@state2:
	call _sidescrollPlatform_decCounter1		; $59c5
	jr nz,@flickerVisibility		; $59c8
	ld (hl),150		; $59ca
	ld l,e			; $59cc
	inc (hl)		; $59cd
	jp objectSetInvisible		; $59ce

@flickerVisibility
	ld e,Interaction.visible		; $59d1
	ld a,(de)		; $59d3
	xor $80			; $59d4
	ld (de),a		; $59d6
	ret			; $59d7

@state3:
	call @state1		; $59d8
	ret nz			; $59db
	ld a,SND_MYSTERY_SEED		; $59dc
	jp playSound		; $59de

@state4:
	call _sidescrollPlatform_decCounter1		; $59e1
	jr nz,@flickerVisibility	; $59e4
	ld (hl),120		; $59e6
	ld l,e			; $59e8
	ld (hl),$01		; $59e9
	jp objectSetVisible83		; $59eb


; ==============================================================================
; INTERACID_CIRCULAR_SIDESCROLL_PLATFORM
; ==============================================================================
interactionCodea4:
	call _sidescrollPlatform_checkLinkOnPlatform		; $59ee
	call @updateState		; $59f1
	jp _sidescrollingPlatformCommon		; $59f4

@updateState:
	ld e,Interaction.state		; $59f7
	ld a,(de)		; $59f9
	rst_jumpTable			; $59fa
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics		; $59ff
	ld h,d			; $5a02
	ld l,Interaction.state		; $5a03
	inc (hl)		; $5a05

	ld l,Interaction.collisionRadiusY		; $5a06
	ld a,$08		; $5a08
	ldi (hl),a		; $5a0a
	ld (hl),a		; $5a0b

	ld l,Interaction.speed		; $5a0c
	ld (hl),SPEED_c0		; $5a0e
	ld l,Interaction.counter1		; $5a10
	ld (hl),$07		; $5a12

	ld e,Interaction.subid		; $5a14
	ld a,(de)		; $5a16
	ld hl,@angles		; $5a17
	rst_addAToHl			; $5a1a
	ld e,Interaction.angle		; $5a1b
	ld a,(hl)		; $5a1d
	ld (de),a		; $5a1e

	ld bc,$5678		; $5a1f
	ld a,$35		; $5a22
	call objectSetPositionInCircleArc		; $5a24

	ld e,Interaction.angle		; $5a27
	ld a,(de)		; $5a29
	add $08			; $5a2a
	and $1f			; $5a2c
	ld (de),a		; $5a2e
	call @func_5a67		; $5a2f
	jp objectSetVisible82		; $5a32

@angles:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN

@state1:
	call interactionDecCounter1		; $5a38
	jr nz,++		; $5a3b
	ld (hl),$0e		; $5a3d
	ld l,Interaction.angle		; $5a3f
	ld a,(hl)		; $5a41
	inc a			; $5a42
	and $1f			; $5a43
	ld (hl),a		; $5a45
++
	call objectApplySpeed		; $5a46

	ld e,Interaction.var34		; $5a49
	ld a,(de)		; $5a4b
	or a			; $5a4c
	jr z,@func_5a67	; $5a4d

	ld h,d			; $5a4f
	ld l,Interaction.var36		; $5a50
	ld e,Interaction.yh		; $5a52
	ld a,(de)		; $5a54
	sub (hl)		; $5a55
	ld b,a			; $5a56

	inc l			; $5a57
	ld e,Interaction.xh		; $5a58
	ld a,(de)		; $5a5a
	sub (hl)		; $5a5b
	ld c,a			; $5a5c
	ld hl,w1Link.yh		; $5a5d
	ld a,(hl)		; $5a60
	add b			; $5a61
	ldi (hl),a		; $5a62
	inc l			; $5a63
	ld a,(hl)		; $5a64
	add c			; $5a65
	ld (hl),a		; $5a66

@func_5a67:
	ld h,d			; $5a67
	ld l,Interaction.var36		; $5a68
	ld e,Interaction.yh		; $5a6a
	ld a,(de)		; $5a6c
	ldi (hl),a		; $5a6d
	ld e,Interaction.xh		; $5a6e
	ld a,(de)		; $5a70
	ld (hl),a		; $5a71
	ret			; $5a72

;;
; Used by:
; * INTERACID_MOVING_SIDESCROLL_PLATFORM
; * INTERACID_MOVING_SIDESCROLL_CONVEYOR
; * INTERACID_DISAPPEARING_SIDESCROLL_PLATFORM
; * INTERACID_CIRCULAR_SIDESCROLL_PLATFORM
; @addr{5a73}
_sidescrollingPlatformCommon:
	ld a,(w1Link.state)		; $5a73
	cp LINK_STATE_NORMAL			; $5a76
	ret nz			; $5a78
	call objectCheckCollidedWithLink		; $5a79
	ret nc			; $5a7c

	; Platform has collided with Link.

	call _sidescrollPlatform_checkLinkIsClose		; $5a7d
	jr c,@label_0b_183	; $5a80
	call _sidescrollPlatform_getTileCollisionBehindLink		; $5a82
	jp z,_sidescrollPlatform_pushLinkAwayHorizontal		; $5a85

	call _sidescrollPlatform_checkLinkSquished		; $5a88
	ret c			; $5a8b

	ld e,Interaction.yh		; $5a8c
	ld a,(de)		; $5a8e
	ld b,a			; $5a8f
	ld a,(w1Link.yh)		; $5a90
	cp b			; $5a93
	ld c,ANGLE_UP		; $5a94
	jr nc,@moveLinkAtAngle	; $5a96
	ld c,ANGLE_DOWN		; $5a98
	jr @moveLinkAtAngle		; $5a9a

@label_0b_183:
	call _sidescrollPlatformFunc_5b51		; $5a9c
	ld a,(hl)		; $5a9f
	or a			; $5aa0
	jp z,_sidescrollPlatform_pushLinkAwayVertical		; $5aa1

	call _sidescrollPlatform_checkLinkSquished		; $5aa4
	ret c			; $5aa7
	ld a,(wLinkRidingObject)		; $5aa8
	cp d			; $5aab
	jr nz,@label_0b_184	; $5aac
	ldh a,(<hFF8B)	; $5aae
	cp $03			; $5ab0
	jr z,@label_0b_184	; $5ab2

	push af			; $5ab4
	call _sidescrollPlatform_pushLinkAwayVertical		; $5ab5
	pop af			; $5ab8
	rrca			; $5ab9
	jr ++			; $5aba

@label_0b_184:
	ld e,Interaction.xh		; $5abc
	ld a,(de)		; $5abe
	ld b,a			; $5abf
	ld a,(w1Link.xh)		; $5ac0
	cp b			; $5ac3
++
	ld c,ANGLE_RIGHT		; $5ac4
	jr nc,@moveLinkAtAngle	; $5ac6
	ld c,ANGLE_LEFT		; $5ac8

;;
; @param	c	Angle
; @addr{5aca}
@moveLinkAtAngle:
	ld b,SPEED_80		; $5aca
	jp updateLinkPositionGivenVelocity		; $5acc

;;
; @param[out]	cflag	c if Link got squished
; @addr{5acf}
_sidescrollPlatform_checkLinkSquished:
	ld h,d			; $5acf
	ld l,Interaction.collisionRadiusY		; $5ad0
	ld a,(hl)		; $5ad2
	ld b,a			; $5ad3
	add a			; $5ad4
	inc a			; $5ad5
	ld c,a			; $5ad6
	ld l,Interaction.yh		; $5ad7
	ld a,(w1Link.yh)		; $5ad9
	sub (hl)		; $5adc
	add b			; $5add
	cp c			; $5ade
	ret nc			; $5adf

	ld l,Interaction.collisionRadiusX		; $5ae0
	ld a,(hl)		; $5ae2
	add $02			; $5ae3
	ld b,a			; $5ae5
	add a			; $5ae6
	inc a			; $5ae7
	ld c,a			; $5ae8
	ld l,Interaction.xh		; $5ae9
	ld a,(w1Link.xh)		; $5aeb
	sub (hl)		; $5aee
	add b			; $5aef
	cp c			; $5af0
	ret nc			; $5af1

	xor a			; $5af2
	ld l,Interaction.angle		; $5af3
	bit 3,(hl)		; $5af5
	jr nz,+			; $5af7
	inc a			; $5af9
+
	ld (wcc50),a		; $5afa
	ld a,LINK_STATE_SQUISHED		; $5afd
	ld (wLinkForceState),a		; $5aff
	scf			; $5b02
	ret			; $5b03

;;
; @param[out]	cflag	c if Link's close enough to the platform?
; @addr{5b04}
_sidescrollPlatform_checkLinkIsClose:
	ld a,(wLinkInAir)		; $5b04
	or a			; $5b07
	ld b,$05		; $5b08
	jr z,+			; $5b0a
	dec b			; $5b0c
+
	ld h,d			; $5b0d
	ld l,Interaction.collisionRadiusX		; $5b0e
	ld a,(hl)		; $5b10
	add b			; $5b11

	ld b,a			; $5b12
	add a			; $5b13
	inc a			; $5b14
	ld c,a			; $5b15
	ld l,Interaction.xh		; $5b16
	ld a,(w1Link.xh)		; $5b18
	sub (hl)		; $5b1b
	add b			; $5b1c
	cp c			; $5b1d
	ret nc			; $5b1e

	ld l,Interaction.collisionRadiusY		; $5b1f
	ld a,(hl)		; $5b21
	sub $02			; $5b22
	ld b,a			; $5b24
	add a			; $5b25
	inc a			; $5b26
	ld c,a			; $5b27
	ld l,Interaction.yh		; $5b28
	ld a,(w1Link.yh)		; $5b2a
	sub (hl)		; $5b2d
	add b			; $5b2e
	cp c			; $5b2f
	ccf			; $5b30
	ret			; $5b31

;;
; @param[out]	a	Collision value
; @param[out]	zflag	nz if a valid collision value is returned
; @addr{5b32}
_sidescrollPlatform_getTileCollisionBehindLink:
	ld l,Interaction.xh		; $5b32
	ld a,(w1Link.xh)		; $5b34
	cp (hl)			; $5b37
	ld b,-$05		; $5b38
	jr c,+			; $5b3a
	ld b,$04		; $5b3c
+
	add b			; $5b3e
	ld c,a			; $5b3f
	ld a,(w1Link.yh)		; $5b40
	sub $04			; $5b43
	ld b,a			; $5b45
	call getTileCollisionsAtPosition		; $5b46
	ret nz			; $5b49
	ld a,b			; $5b4a
	add $08			; $5b4b
	ld b,a			; $5b4d
	jp getTileCollisionsAtPosition		; $5b4e

;;
; @param[out]	hl
; @addr{5b51}
_sidescrollPlatformFunc_5b51:
	ld h,d			; $5b51
	ld l,Interaction.yh		; $5b52
	ld a,(w1Link.yh)		; $5b54
	cp (hl)			; $5b57
	ld b,-$06		; $5b58
	jr c,+			; $5b5a
	ld b,$09		; $5b5c
+
	add b			; $5b5e
	ld b,a			; $5b5f
	ld a,(w1Link.xh)		; $5b60
	sub $03			; $5b63
	ld c,a			; $5b65
	call getTileCollisionsAtPosition		; $5b66
	ld hl,hFF8B		; $5b69
	ld (hl),$00		; $5b6c
	jr z,+			; $5b6e
	set 1,(hl)		; $5b70
+
	ld a,c			; $5b72
	add $05			; $5b73
	ld c,a			; $5b75
	call getTileCollisionsAtPosition		; $5b76
	ld hl,hFF8B		; $5b79
	ret z			; $5b7c
	inc (hl)		; $5b7d
	ret			; $5b7e

;;
; Checks if Link's on the platform, updates wLinkRidingObject if so.
;
; @param[out]	zflag	nz if Link is standing on the platform
; @addr{5b7f}
_sidescrollPlatform_checkLinkOnPlatform:
	call objectCheckCollidedWithLink		; $5b7f
	jr nc,@notOnPlatform	; $5b82

	ld h,d			; $5b84
	ld l,Interaction.yh		; $5b85
	ld a,(hl)		; $5b87
	ld l,Interaction.collisionRadiusY		; $5b88
	sub (hl)		; $5b8a
	sub $02			; $5b8b
	ld b,a			; $5b8d
	ld a,(w1Link.yh)		; $5b8e
	cp b			; $5b91
	jr nc,@notOnPlatform	; $5b92

	call _sidescrollPlatform_checkLinkIsClose		; $5b94
	jr nc,@notOnPlatform	; $5b97

	ld e,Interaction.var34		; $5b99
	ld a,(de)		; $5b9b
	or a			; $5b9c
	jr nz,@onPlatform		; $5b9d
	ld a,$01		; $5b9f
	ld (de),a		; $5ba1
	call _sidescrollPlatform_updateLinkSubpixels		; $5ba2

@onPlatform:
	ld a,d			; $5ba5
	ld (wLinkRidingObject),a		; $5ba6
	xor a			; $5ba9
	ret			; $5baa

@notOnPlatform:
	ld e,Interaction.var34		; $5bab
	ld a,(de)		; $5bad
	or a			; $5bae
	ret z			; $5baf
	ld a,$00		; $5bb0
	ld (de),a		; $5bb2
	ret			; $5bb3

;;
; @addr{5bb4}
_sidescrollPlatform_updateLinkKnockbackForConveyor:
	ld e,Interaction.angle		; $5bb4
	ld a,(de)		; $5bb6
	bit 3,a			; $5bb7
	ret z			; $5bb9

	ld hl,w1Link.knockbackAngle		; $5bba
	ld e,Interaction.direction		; $5bbd
	ld a,(de)		; $5bbf
	swap a			; $5bc0
	add $08			; $5bc2
	ld (hl),a		; $5bc4
	ld l,<w1Link.invincibilityCounter		; $5bc5
	ld (hl),$fc		; $5bc7
	ld l,<w1Link.knockbackCounter		; $5bc9
	ld (hl),$0c		; $5bcb
	ret			; $5bcd

;;
; @param[out]	hl	counter1
; @addr{5bce}
_sidescrollPlatform_decCounter1:
	ld h,d			; $5bce
	ld l,Interaction.counter1		; $5bcf
	ld a,(hl)		; $5bd1
	or a			; $5bd2
	ret z			; $5bd3
	dec (hl)		; $5bd4
	ret			; $5bd5

;;
; @addr{5bd6}
_sidescrollPlatform_pushLinkAwayVertical:
	ld hl,w1Link.collisionRadiusY		; $5bd6
	ld e,Interaction.collisionRadiusY		; $5bd9
	ld a,(de)		; $5bdb
	add (hl)		; $5bdc
	ld b,a			; $5bdd
	ld l,<w1Link.yh		; $5bde
	ld e,Interaction.yh		; $5be0
	jr +++			; $5be2

;;
; @addr{5be4}
_sidescrollPlatform_pushLinkAwayHorizontal:
	ld hl,w1Link.collisionRadiusX		; $5be4
	ld e,Interaction.collisionRadiusX		; $5be7
	ld a,(de)		; $5be9
	add (hl)		; $5bea
	ld b,a			; $5beb
	ld l,<w1Link.xh		; $5bec
	ld e,Interaction.xh		; $5bee
+++
	ld a,(de)		; $5bf0
	cp (hl)			; $5bf1
	jr c,++			; $5bf2
	ld a,b			; $5bf4
	cpl			; $5bf5
	inc a			; $5bf6
	ld b,a			; $5bf7
++
	ld a,(de)		; $5bf8
	add b			; $5bf9
	ld (hl),a		; $5bfa
	ret			; $5bfb

;;
; @addr{5bfc}
_sidescrollPlatformFunc_5bfc:
	call objectRunMovementScript		; $5bfc
	ld a,(wLinkRidingObject)		; $5bff
	cp d			; $5c02
	ret nz			; $5c03

;;
; @addr{5c04}
_sidescrollPlatform_updateLinkSubpixels:
	ld e,Interaction.y		; $5c04
	ld a,(de)		; $5c06
	ld (w1Link.y),a		; $5c07
	ld e,Interaction.x		; $5c0a
	ld a,(de)		; $5c0c
	ld (w1Link.x),a		; $5c0d
	ret			; $5c10


; ==============================================================================
; INTERACID_TOUCHING_BOOK
; ==============================================================================
interactionCodea5:
	ld e,Interaction.state		; $5c11
	ld a,(de)		; $5c13
	rst_jumpTable			; $5c14
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8

@state0:
	ld a,$01		; $5c27
	ld (wMenuDisabled),a		; $5c29
	ld hl,w1Link.knockbackCounter		; $5c2c
	ld a,(hl)		; $5c2f
	or a			; $5c30
	ret nz			; $5c31

	ld a,$01		; $5c32
	ld (de),a ; [state]

	call objectTakePosition		; $5c35
	ld bc,$3850		; $5c38
	call objectGetRelativeAngle		; $5c3b
	and $1c			; $5c3e
	ld e,Interaction.angle		; $5c40
	ld (de),a		; $5c42

	ld bc,-$100		; $5c43
	call objectSetSpeedZ		; $5c46

	ld l,Interaction.speed		; $5c49
	ld (hl),SPEED_100		; $5c4b

	call interactionInitGraphics		; $5c4d
	call interactionSetAlwaysUpdateBit		; $5c50

	ld a,(w1Link.visible)		; $5c53
	ld e,Interaction.visible		; $5c56
	ld (de),a		; $5c58

	ld a,SND_GAINHEART		; $5c59
	jp playSound		; $5c5b

@state1:
	ld c,$20		; $5c5e
	call objectUpdateSpeedZ_paramC		; $5c60
	jp nz,objectApplySpeed		; $5c63
	jp interactionIncState		; $5c66

@state2:
	call @updateMapleAngle		; $5c69
	ret nz			; $5c6c
	ld a,$ff		; $5c6d
	ld (w1Companion.angle),a		; $5c6f
	call interactionIncState		; $5c72
	call objectSetInvisible		; $5c75
	ld a,SND_GETSEED		; $5c78
	call playSound		; $5c7a
	ld bc,TX_070e		; $5c7d
	jp showText		; $5c80

@state3:
	call retIfTextIsActive		; $5c83
	ld hl,w1Link.xh		; $5c86
	ldd a,(hl)		; $5c89
	ld b,$f0		; $5c8a
	cp $58			; $5c8c
	jr nc,+			; $5c8e
	ld b,$10		; $5c90
+
	add b			; $5c92
	ld e,Interaction.xh		; $5c93
	ld (de),a		; $5c95
	dec l			; $5c96
	ld a,(hl) ; [w1Link.yh]
	ld e,Interaction.yh		; $5c98
	ld (de),a		; $5c9a
	xor a			; $5c9b
	ld (w1Companion.angle),a		; $5c9c
	jp interactionIncState		; $5c9f

@state4:
	call @updateMapleAngle		; $5ca2
	ret nz			; $5ca5
	ld hl,w1Companion.angle		; $5ca6
	ld a,$ff		; $5ca9
	ldd (hl),a		; $5cab
	ld a,(hl) ; [w1Companion.direction]
	xor $02			; $5cad
	dec h			; $5caf
	ld (hl),a ; [w1Link.direction]
	call interactionIncState		; $5cb1
	ld bc,TX_070f		; $5cb4
	jp showText		; $5cb7

@state5:
	call retIfTextIsActive		; $5cba
	ld a,(w1Companion.direction)		; $5cbd
	xor $02			; $5cc0
	set 7,a			; $5cc2
	ld (w1Companion.direction),a		; $5cc4
	call interactionIncState		; $5cc7
	ld bc,TX_0710		; $5cca
	jp showText		; $5ccd

@state6:
	call retIfTextIsActive		; $5cd0
	ld a,(w1Companion.direction)		; $5cd3
	res 7,a			; $5cd6
	ld (w1Companion.direction),a		; $5cd8
	jp interactionIncState		; $5cdb

@state7:
	ldbc TREASURE_TRADEITEM, TRADEITEM_MAGIC_OAR		; $5cde
	call createTreasure		; $5ce1
	ret nz			; $5ce4
	ld e,Interaction.counter1		; $5ce5
	ld a,$02		; $5ce7
	ld (de),a		; $5ce9
	push de			; $5cea
	ld de,w1Link.yh		; $5ceb
	call objectCopyPosition_rawAddress		; $5cee
	pop de			; $5cf1
	jp interactionIncState		; $5cf2

@state8:
	ld e,Interaction.counter1		; $5cf5
	ld a,(de)		; $5cf7
	or a			; $5cf8
	jr z,++			; $5cf9
	dec a			; $5cfb
	ld (de),a		; $5cfc
	ret			; $5cfd
++
	call retIfTextIsActive		; $5cfe

	ld a,DISABLE_LINK		; $5d01
	ld (wDisabledObjects),a		; $5d03

	ld a,$02		; $5d06
	ld (w1Companion.state2),a		; $5d08
	jp interactionDelete		; $5d0b

;;
; @param[out]	zflag	z if reached touching book
; @addr{5d0e}
@updateMapleAngle:
	ld hl,w1Companion.yh		; $5d0e
	ldi a,(hl)		; $5d11
	ld b,a			; $5d12
	inc l			; $5d13
	ld c,(hl)		; $5d14

	ld a,(wMapleState)		; $5d15
	and $20			; $5d18
	jr z,++			; $5d1a
	ld e,Interaction.yh		; $5d1c
	ld a,(de)		; $5d1e
	cp b			; $5d1f
	jr nz,++		; $5d20
	ld e,Interaction.xh		; $5d22
	ld a,(de)		; $5d24
	cp c			; $5d25
	ret z			; $5d26
++
	call objectGetRelativeAngle		; $5d27
	xor $10			; $5d2a
	ld (w1Companion.angle),a		; $5d2c
	or d			; $5d2f
	ret			; $5d30


; ==============================================================================
; INTERACID_MAKU_SEED
;
; Variables:
;   var38: ?
; ==============================================================================
interactionCodea6:
	ld e,Interaction.state		; $5d31
	ld a,(de)		; $5d33
	rst_jumpTable			; $5d34
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState		; $5d39
	ld a,PALH_ab		; $5d3c
	call loadPaletteHeader		; $5d3e
	call interactionInitGraphics		; $5d41

	ld hl,w1Link.yh		; $5d44
	ld b,(hl)		; $5d47
	ld l,<w1Link.xh		; $5d48
	ld c,(hl)		; $5d4a
	call interactionSetPosition		; $5d4b
	ld l,Interaction.zh		; $5d4e
	ld (hl),$8b		; $5d50

	ld a,(wFrameCounter)		; $5d52
	cpl			; $5d55
	inc a			; $5d56
	ld e,Interaction.var38		; $5d57
	ld (de),a		; $5d59
	call objectSetVisible82		; $5d5a
	call @createSparkle		; $5d5d

@state1:
	ld h,d			; $5d60
	ld l,Interaction.zh		; $5d61
	ldd a,(hl)		; $5d63
	cp $f3			; $5d64
	jr c,++			; $5d66
	ld a,$01		; $5d68
	ld (wTmpcfc0.genericCutscene.state),a		; $5d6a
	jp interactionDelete		; $5d6d
++
	ld bc,$0080		; $5d70
	ld a,c			; $5d73
	add (hl) ; [zh]
	ldi (hl),a		; $5d75
	ld a,b			; $5d76
	adc (hl)		; $5d77
	ld (hl),a		; $5d78

	ld a,(wFrameCounter)		; $5d79
	ld l,Interaction.var38		; $5d7c
	add (hl)		; $5d7e
	and $3f			; $5d7f
	ld a,SND_MAGIC_POWDER		; $5d81
	call z,playSound		; $5d83
	ret			; $5d86

;;
; Unused function?
; @addr{5d87}
@func_5d87:
	ldbc INTERACID_SPARKLE,$0b		; $5d87
	call objectCreateInteraction		; $5d8a
	ret nz			; $5d8d
	ld l,Interaction.counter1		; $5d8e
	ld (hl),$c2		; $5d90
	call objectCopyPosition		; $5d92

	call getRandomNumber		; $5d95
	and $07			; $5d98
	add a			; $5d9a
	ld bc,@offsets		; $5d9b
	call addAToBc		; $5d9e
	ld a,(bc)		; $5da1
	ld l,Interaction.yh		; $5da2
	add (hl)		; $5da4
	ld (hl),a		; $5da5
	inc bc			; $5da6
	ld a,(bc)		; $5da7
	ld l,Interaction.xh		; $5da8
	add (hl)		; $5daa
	ld (hl),a		; $5dab
	ret			; $5dac

@offsets:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

;;
; @addr{5dbd}
@createSparkle:
	ldbc INTERACID_SPARKLE,$0f		; $5dbd
	call objectCreateInteraction		; $5dc0
	ret nz			; $5dc3
	ld l,Interaction.relatedObj1		; $5dc4
	ld a,Interaction.start		; $5dc6
	ldi (hl),a		; $5dc8
	ld (hl),d		; $5dc9
	ret			; $5dca


; ==============================================================================
; INTERACID_a7
; ==============================================================================
interactionCodea7:
	ld e,Interaction.state		; $5dcb
	ld a,(de)		; $5dcd
	rst_jumpTable			; $5dce
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $5dd3
	ld (de),a ; [state]
	call interactionInitGraphics		; $5dd6
	call objectSetVisible82		; $5dd9

	ld e,Interaction.subid		; $5ddc
	ld a,(de)		; $5dde
	cp $02			; $5ddf
	ret nz			; $5de1

	ld a,(wChildStage)		; $5de2
	cp $04			; $5de5
	ret c			; $5de7

	ld a,$04		; $5de8
	call interactionSetAnimation		; $5dea
	call getFreeInteractionSlot		; $5ded
	ret nz			; $5df0
	ld (hl),INTERACID_CHILD		; $5df1
	inc l			; $5df3
	ld a,(wChildStage)		; $5df4
	ld b,$00		; $5df7
	cp $07			; $5df9
	jr c,+			; $5dfb
	ld b,$03		; $5dfd
+
	ld a,(wChildPersonality)		; $5dff
	add b			; $5e02
	ldi (hl),a ; [child.subid]
	add $16			; $5e04
	ld (hl),a		; $5e06
	ld l,Interaction.yh		; $5e07
	ld (hl),$38		; $5e09
	inc l			; $5e0b
	inc l			; $5e0c
	ld (hl),$28		; $5e0d
	ret			; $5e0f

@state1:
	ld e,Interaction.state2		; $5e10
	ld a,(de)		; $5e12
	rst_jumpTable			; $5e13
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wTmpcfc0.genericCutscene.state)		; $5e1a
	or a			; $5e1d
	jr z,++			; $5e1e
	call interactionIncState2		; $5e20
	ld bc,-$100		; $5e23
	call objectSetSpeedZ		; $5e26
++
	jp interactionAnimate		; $5e29

@substate1:
	ld c,$20		; $5e2c
	call objectUpdateSpeedZ_paramC		; $5e2e
	ret nz			; $5e31
	call interactionIncState2		; $5e32
	ld l,Interaction.counter1		; $5e35
	ld (hl),10		; $5e37
	ret			; $5e39

@substate2:
	call interactionDecCounter1		; $5e3a
	ret nz			; $5e3d
	ld a,$03		; $5e3e
	jp interactionSetAnimation		; $5e40


; ==============================================================================
; INTERACID_a8
; ==============================================================================
interactionCodea8:
	ld e,Interaction.subid		; $5e43
	ld a,(de)		; $5e45
	and $0f			; $5e46
	rst_jumpTable			; $5e48
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid0:
@subid1:
@subid2:
@subid3:
	ld a,(de)		; $5e53
	and $0f			; $5e54
	add SPECIALOBJECTID_RICKY_CUTSCENE			; $5e56
	ld b,a			; $5e58
	ld a,(de)		; $5e59
	swap a			; $5e5a
	and $0f			; $5e5c
	ld hl,w1Companion.enabled		; $5e5e
	ld (hl),$01		; $5e61
	inc l			; $5e63
	ld (hl),b ; [w1Companion.id]
	inc l			; $5e65
	ld (hl),a ; [w1Companion.subid]
	call objectCopyPosition		; $5e67
	jp interactionDelete		; $5e6a

@subid4:
	ld hl,w1Link.enabled		; $5e6d
	ld (hl),$03		; $5e70
	call objectCopyPosition		; $5e72
	call @handleSubidHighNibble		; $5e75
	jp interactionDelete		; $5e78

@handleSubidHighNibble:
	ld e,Interaction.subid		; $5e7b
	ld a,(de)		; $5e7d
	swap a			; $5e7e
	and $0f			; $5e80
	ld b,a			; $5e82
	rst_jumpTable			; $5e83
	.dw @thing0
	.dw @thing1
	.dw @thing2
	.dw @thing3
	.dw @thing4
	.dw @thing5
	.dw @thing6

@thing2:
@thing3:
@thing4:
	ld a,b			; $5e92

@initLinkInCutscene:
	ld hl,w1Link.id		; $5e93
	ld (hl),SPECIALOBJECTID_LINK_CUTSCENE		; $5e96
	inc l			; $5e98
	ld (hl),a		; $5e99
	ret			; $5e9a

@thing5:
	ld a,d			; $5e9b
	ld (wLinkObjectIndex),a		; $5e9c
	ld hl,wActiveRing		; $5e9f
	ld (hl),FIST_RING		; $5ea2
	xor a			; $5ea4
	ld l,<wInventoryB		; $5ea5
	ldi (hl),a		; $5ea7
	ld (hl),a		; $5ea8

	ld hl,@simulatedInput_5eea		; $5ea9
	ld a,:@simulatedInput_5eea		; $5eac

@beginSimulatedInput:
	push de			; $5eae
	call setSimulatedInputAddress		; $5eaf
	pop de			; $5eb2
	xor a			; $5eb3
	ld (wDisabledObjects),a		; $5eb4
	ld hl,w1Link.id		; $5eb7
	ld (hl),SPECIALOBJECTID_LINK		; $5eba
	ret			; $5ebc

@thing6:
	ld a,$09		; $5ebd
	jp @initLinkInCutscene		; $5ebf

@thing1:
	ld a,$0a		; $5ec2
	jp @initLinkInCutscene		; $5ec4

@thing0:
	ld hl,w1Link.direction		; $5ec7
	ld (hl),DIR_DOWN		; $5eca
	ld a,h			; $5ecc
	ld (wLinkObjectIndex),a		; $5ecd
	ld hl,wInventoryB		; $5ed0
	ld (hl),ITEMID_SWORD		; $5ed3
	inc l			; $5ed5
	ld (hl),$00 ; [wInventoryA]
	ld hl,@linkSwordDemonstrationInput		; $5ed8
	ld a,:@linkSwordDemonstrationInput		; $5edb
	jr @beginSimulatedInput		; $5edd


; Unused? (address $5edf)
@unusedInputData:
	dwb 60 $00
	dwb 32 BTN_DOWN
	dwb 48 $00
	.dw $ffff


@simulatedInput_5eea:
	dwb 124 $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 46  $00
	dwb 1   BTN_RIGHT
	dwb 46  $00
	dwb 1   BTN_UP
	dwb 46  $00
	dwb 1   BTN_LEFT
	dwb 46  $00
	dwb 1   BTN_DOWN
	dwb 104 $00
	dwb 1   BTN_UP
	dwb 56  $00
	dwb 1   BTN_RIGHT
	dwb 464 $00
	dwb 1   BTN_LEFT
	dwb 160 $00
	dwb 1   BTN_A
	dwb 48  $00
	.dw $ffff

; Demonstrating sword to Ralph in credits
@linkSwordDemonstrationInput:
	dwb 60  $00
	dwb 1   BTN_LEFT
	dwb 58  BTN_B
	dwb 60  $00
	dwb 1   BTN_RIGHT|BTN_B
	dwb 20  $00
	dwb 1   BTN_DOWN
	dwb 120 BTN_B
	dwb 50  $00
	dwb 1   BTN_RIGHT
	dwb 30  $00
	.dw $ffff


; ==============================================================================
; INTERACID_TWINROVA_FLAME
; ==============================================================================
interactionCodea9:
	ld e,Interaction.state		; $5f4e
	ld a,(de)		; $5f50
	rst_jumpTable			; $5f51
	.dw @state0
	.dw interactionAnimate
	.dw @state2

@state0:
	ld a,$01		; $5f58
	ld (de),a ; [state]

	ld e,Interaction.subid		; $5f5b
	ld a,(de)		; $5f5d
	cp $06			; $5f5e
	call nc,interactionIncState		; $5f60

	call interactionInitGraphics		; $5f63
	call interactionSetAlwaysUpdateBit		; $5f66

	ld l,Interaction.subid		; $5f69
	ld a,(hl)		; $5f6b
	ld b,a			; $5f6c
	cp $03			; $5f6d
	jr c,++			; $5f6f
	call getThisRoomFlags		; $5f71
	and $80			; $5f74
	jp nz,interactionDelete		; $5f76

	ld a,(de) ; [subid]
++
	and $03			; $5f7a
	add a			; $5f7c
	add a			; $5f7d
	add a			; $5f7e
	ld l,Interaction.animCounter ; BUG(?): Won't point to the object after "getThisRoomFlags" call?
	add (hl)		; $5f81
	ld (hl),a		; $5f82
	ld a,b			; $5f83
	ld hl,@positions		; $5f84
	rst_addDoubleIndex			; $5f87
	ldi a,(hl)		; $5f88
	ld c,(hl)		; $5f89
	ld b,a			; $5f8a
	call interactionSetPosition		; $5f8b
	jp objectSetVisiblec2		; $5f8e

@positions:
	.db $40 $a8
	.db $40 $48
	.db $10 $78

	.db $50 $a8
	.db $50 $48
	.db $20 $78

	.db $50 $a8
	.db $50 $48
	.db $20 $78

@state2:
	call interactionAnimate		; $5fa3
	ld a,(wFrameCounter)		; $5fa6
	rrca			; $5fa9
	jp c,objectSetVisible		; $5faa
	jp objectSetInvisible		; $5fad


; ==============================================================================
; INTERACID_DIN
; ==============================================================================
interactionCodeaa:
	ld e,Interaction.state		; $5fb0
	ld a,(de)		; $5fb2
	rst_jumpTable			; $5fb3
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $5fb8
	ld (de),a ; [state]
	call interactionInitGraphics		; $5fbb
	call objectSetVisible82		; $5fbe
	ld e,Interaction.subid		; $5fc1
	ld a,(de)		; $5fc3
	rst_jumpTable			; $5fc4
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2

@initSubid0:
@initSubid1:
	ret			; $5fcb

@initSubid2:
	call interactionSetAlwaysUpdateBit		; $5fcc
	ld bc,$4830		; $5fcf
	jp interactionSetPosition		; $5fd2


@state1:
	ld e,Interaction.subid		; $5fd5
	ld a,(de)		; $5fd7
	rst_jumpTable			; $5fd8
	.dw @runSubid0
	.dw interactionAnimate
	.dw interactionAnimate

@runSubid0:
	call @runSubid0Substates		; $5fdf
	ld e,Interaction.zh		; $5fe2
	ld a,(de)		; $5fe4
	or a			; $5fe5
	jp nz,objectSetVisiblec2		; $5fe6
	jp objectSetVisible82		; $5fe9

@runSubid0Substates:
	ld e,Interaction.state2		; $5fec
	ld a,(de)		; $5fee
	rst_jumpTable			; $5fef
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw interactionAnimate

@substate0:
	call interactionAnimate		; $5ffa
	ld a,(wTmpcfc0.genericCutscene.state)		; $5ffd
	cp $04			; $6000
	ret nz			; $6002
	call interactionIncState2		; $6003
	ld l,Interaction.counter1		; $6006
	ld (hl),120		; $6008
	ld a,$05		; $600a
	call interactionSetAnimation		; $600c
	jp @beginJump		; $600f

@substate1:
	call interactionDecCounter1		; $6012
	jp nz,@updateSpeedZ		; $6015
	call interactionIncState2		; $6018
	xor a			; $601b
	ld l,Interaction.zh		; $601c
	ld (hl),a		; $601e
	ld l,Interaction.counter1		; $601f
	ld (hl),30		; $6021
	jp interactionAnimate		; $6023

@substate2:
	call interactionDecCounter1		; $6026
	jr nz,++		; $6029
	call interactionIncState2		; $602b
	ld l,Interaction.counter1		; $602e
	ld (hl),60		; $6030
	ld bc,TX_3d09		; $6032
	call showText		; $6035
++
	jp interactionAnimate		; $6038

@substate3:
	call interactionDecCounter1IfTextNotActive		; $603b
	jr nz,++		; $603e
	call interactionIncState2		; $6040
	ld hl,wTmpcfc0.genericCutscene.state		; $6043
	ld (hl),$05		; $6046
++
	jp interactionAnimate		; $6048


; Scripts unused?
@loadScript:
	ld e,Interaction.subid		; $604b
	ld a,(de)		; $604d
	ld hl,@scriptTable		; $604e
	rst_addDoubleIndex			; $6051
	ldi a,(hl)		; $6052
	ld h,(hl)		; $6053
	ld l,a			; $6054
	jp interactionSetScript		; $6055

@scriptTable:
	.dw dinScript


@updateSpeedZ:
	ld c,$20		; $605a
	call objectUpdateSpeedZ_paramC		; $605c
	ret nz			; $605f
	ld h,d			; $6060

@beginJump:
	ld bc,-$100		; $6061
	jp objectSetSpeedZ		; $6064


; ==============================================================================
; INTERACID_ZORA
;
; Variables:
;   var03: ?
;   var38: ?
; ==============================================================================
interactionCodeab:
	ld e,Interaction.subid		; $6067
	ld a,(de)		; $6069
	rst_jumpTable			; $606a
	.dw _zora_subid00
	.dw _zora_subid01
	.dw _zora_subid02
	.dw _zora_subid03
	.dw _zora_subid04
	.dw _zora_subid05
	.dw _zora_subid06
	.dw _zora_subid07
	.dw _zora_subid08
	.dw _zora_subid09
	.dw _zora_subid0A
	.dw _zora_subid0B
	.dw _zora_subid0C
	.dw _zora_subid0D
	.dw _zora_subid0E
	.dw _zora_subid0F
	.dw _zora_subid10
	.dw _zora_subid11
	.dw _zora_subid12
	.dw _zora_subid13
	.dw _zora_subid14
	.dw _zora_subid15
	.dw _zora_subid16
	.dw _zora_subid17
	.dw _zora_subid18
	.dw _zora_subid19
	.dw _zora_subid1A
	.dw _zora_subid1B


_zora_subid00:
_zora_subid01:
_zora_subid02:
_zora_subid03:
_zora_subid04:
_zora_subid05:
_zora_subid06:
_zora_subid07:
_zora_subid08:
_zora_subid09:
_zora_subid0F:
	call checkInteractionState		; $60a3
	jr z,@state0	; $60a6

@state1:
	call _zora_getWorldState		; $60a8
	ld e,Interaction.subid		; $60ab
	ld a,(de)		; $60ad
	add a			; $60ae
	add a			; $60af
	add b			; $60b0
	ld hl,_zora_textIndices		; $60b1
	rst_addAToHl			; $60b4
	ld e,Interaction.textID		; $60b5
	ld a,(hl)		; $60b7
	ld (de),a		; $60b8
	call interactionRunScript		; $60b9
	jp npcFaceLinkAndAnimate		; $60bc

@state0:
	call _zora_getWorldState		; $60bf
	ld a,b			; $60c2
	or a			; $60c3
	ld e,Interaction.subid		; $60c4
	ld a,(de)		; $60c6
	jr nz,++		; $60c7
	cp $06			; $60c9
	jp nc,interactionDelete		; $60cb
++
	ld hl,genericNpcScript		; $60ce

_zora_commonInitWithScript:
	call interactionSetScript		; $60d1

_zora_commonInit:
	call interactionInitGraphics		; $60d4
	call interactionSetAlwaysUpdateBit		; $60d7
	call interactionIncState		; $60da
	ld l,Interaction.textID+1		; $60dd
	ld (hl),>TX_3400		; $60df
	jp objectSetVisiblec2		; $60e1


_zora_subid0C:
_zora_subid0D:
	call checkInteractionState		; $60e4
	jr z,@state0	; $60e7

@state1:
	ld c,$20		; $60e9
	call objectUpdateSpeedZ_paramC		; $60eb
	ret nz			; $60ee
	call interactionRunScript		; $60ef
	jr nc,++	; $60f2
	ld hl,wTmpcfc0.genericCutscene.state		; $60f4
	set 7,(hl)		; $60f7
++
	jp interactionAnimate		; $60f9

@state0:
	ld e,Interaction.speed		; $60fc
	ld a,SPEED_180		; $60fe
	ld (de),a		; $6100
	ld e,Interaction.subid		; $6101
	ld a,(de)		; $6103
	cp $0c			; $6104
	ld hl,zoraSubid0cScript		; $6106
	jr z,_zora_commonInitWithScript	; $6109
	ld hl,zoraSubid0dScript		; $610b
	jr _zora_commonInitWithScript		; $610e


_zora_subid0A:
_zora_subid0B:
	ld e,Interaction.state		; $6110
	ld a,(de)		; $6112
	rst_jumpTable			; $6113
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call _zora_commonInit		; $611c
	ld l,Interaction.counter1		; $611f
	ld (hl),30		; $6121
	ld l,Interaction.subid		; $6123
	ldi a,(hl)		; $6125
	sub $0a			; $6126
	swap a			; $6128
	rrca			; $612a
	ld (hl),a ; [var03]
	ret			; $612c

@state1:
	call interactionDecCounter1		; $612d
	ret nz			; $6130
	ld (hl),120 ; [counter1]
	inc l			; $6133
	inc (hl) ; [counter2]
	jp interactionIncState		; $6135

@state2:
	call interactionDecCounter1		; $6138
	jr nz,++		; $613b
	ld (hl),90		; $613d
	ld a,$02		; $613f
	call interactionSetAnimation		; $6141
	jp interactionIncState		; $6144
++
	inc l			; $6147
	dec (hl) ; [counter2]
	ret nz			; $6149

	ld (hl),20		; $614a

	ld l,Interaction.var38		; $614c
	ld a,(hl)		; $614e
	inc a			; $614f
	and $07			; $6150
	ld (hl),a		; $6152

	ld l,Interaction.var03		; $6153
	add (hl)		; $6155
	ld hl,@animationTable		; $6156
	rst_addAToHl			; $6159
	ld a,(hl)		; $615a
	jp interactionSetAnimation		; $615b

@animationTable:
	.db $00 $03 $01 $02 $00 $01 $03 $02
	.db $03 $01 $03 $00 $03 $02 $00 $01

@state3:
	call interactionDecCounter1		; $616e
	jr nz,++		; $6171
	ld hl,wTmpcfc0.genericCutscene.state		; $6173
	set 7,(hl)		; $6176
++
	ld c,$20		; $6178
	call objectUpdateSpeedZ_paramC		; $617a
	ret nz			; $617d
	ld l,Interaction.speedZ		; $617e
	ld a,<(-$180)		; $6180
	ldi (hl),a		; $6182
	ld (hl),>(-$180)		; $6183
	ret			; $6185


_zora_subid10:
_zora_subid11:
_zora_subid12:
	ld e,Interaction.state		; $6186
	ld a,(de)		; $6188
	rst_jumpTable			; $6189
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $6190
	call objectSetVisible82		; $6193
	call interactionIncState		; $6196

	ld e,Interaction.subid		; $6199
	ld a,(de)		; $619b
	sub $10			; $619c
	ld b,a			; $619e
	ld hl,@scriptTable		; $619f
	rst_addDoubleIndex			; $61a2
	ldi a,(hl)		; $61a3
	ld h,(hl)		; $61a4
	ld l,a			; $61a5
	call interactionSetScript		; $61a6

	ld a,b			; $61a9
	rst_jumpTable			; $61aa
	.dw @subid10
	.dw @subid11
	.dw @subid12

@subid10:
	call getThisRoomFlags		; $61b1
	and $20			; $61b4
	jp nz,interactionDelete		; $61b6
	ld a,(wEssencesObtained)		; $61b9
	bit 6,a			; $61bc
	jp z,interactionDelete		; $61be
	ld a,$03		; $61c1
	call interactionSetAnimation		; $61c3
	jp interactionIncState		; $61c6

@subid11:
	call checkIsLinkedGame		; $61c9
	jp nz,interactionDelete		; $61cc
	jr @deleteIfFlagSet		; $61cf

@subid12:
	call checkIsLinkedGame		; $61d1
	jp z,interactionDelete		; $61d4

@deleteIfFlagSet:
	call getThisRoomFlags		; $61d7
	and $40			; $61da
	jp nz,interactionDelete		; $61dc
	ret			; $61df

@scriptTable:
	.dw zoraSubid10Script
	.dw zoraSubid11And12Script
	.dw zoraSubid11And12Script

@state1:
	call interactionRunScript		; $61e6
	jp c,interactionDelete		; $61e9
	jp npcFaceLinkAndAnimate		; $61ec

@state2:
	call interactionRunScript		; $61ef
	jp c,interactionDelete		; $61f2
	jp interactionAnimate		; $61f5


_zora_subid0E:
	call checkInteractionState		; $61f8
	jr z,@state0	; $61fb

@state1:
	call interactionRunScript		; $61fd
	jp interactionAnimateAsNpc		; $6200

@state0:
	call interactionInitGraphics		; $6203
	call interactionIncState		; $6206
	ld l,Interaction.textID+1		; $6209
	ld (hl),>TX_3400		; $620b
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $620d
	call checkGlobalFlag		; $620f
	ld a,<TX_3433		; $6212
	jr z,+			; $6214
	ld a,<TX_3434		; $6216
+
	ld e,Interaction.textID		; $6218
	ld (de),a		; $621a
	xor a			; $621b
	call interactionSetAnimation		; $621c
	call objectSetVisiblec2		; $621f
	ld hl,zoraSubid0eScript		; $6222
	jp interactionSetScript		; $6225


_zora_subid13:
_zora_subid14:
_zora_subid15:
_zora_subid16:
_zora_subid17:
_zora_subid18:
_zora_subid19:
_zora_subid1A:
_zora_subid1B:
	call checkInteractionState		; $6228
	jr z,@state0	; $622b

@state1:
	call interactionRunScript		; $622d
	jp npcFaceLinkAndAnimate		; $6230

@state0:
	call _zora_commonInit		; $6233
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $6236
	call checkGlobalFlag		; $6238
	ld b,$00		; $623b
	jr z,+			; $623d
	inc b			; $623f
+
	ld e,Interaction.subid		; $6240
	ld a,(de)		; $6242
	sub $13			; $6243
	add a			; $6245
	add b			; $6246
	ld hl,@textTable		; $6247
	rst_addAToHl			; $624a
	ld e,Interaction.textID		; $624b
	ld a,(hl)		; $624d
	ld (de),a		; $624e
	ld hl,genericNpcScript		; $624f
	jp interactionSetScript		; $6252


; Table of text to show before/after water pollution is fixed for each zora
@textTable:
	.db <TX_3447, <TX_3448 ; $13 == [subid]
	.db <TX_3449, <TX_344a ; $14
	.db <TX_344b, <TX_344c ; $15
	.db <TX_3446, <TX_3446 ; $16
	.db <TX_3440, <TX_3441 ; $17
	.db <TX_3442, <TX_3443 ; $18
	.db <TX_3444, <TX_3445 ; $19
	.db <TX_344d, <TX_344d ; $1a
	.db <TX_344e, <TX_344e ; $1b

;;
; @param[out]	b	0 if king zora is uncured;
;			1 if he's cured;
;			2 if pollution is fixed;
;			3 if beat Jabu (except it's bugged and this doesn't happen)
; @addr{6267}
_zora_getWorldState:
	ld a,GLOBALFLAG_KING_ZORA_CURED		; $6267
	call checkGlobalFlag		; $6269
	ld b,$00		; $626c
	ret z			; $626e

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED		; $626f
	call checkGlobalFlag		; $6271
	ld b,$01		; $6274
	ret z			; $6276

	ld a,(wEssencesObtained)		; $6277
	bit 6,a			; $627a
	ld b,$02		; $627c
	ret nc			; $627e
	; BUG: this should be "ret z"

	inc b			; $627f
	ret			; $6280


; Text 0: Before healing king
; Text 1: After healing king
; Text 2: After fixing pollution
; Text 3: After beating jabu (bugged to never have this text read)
_zora_textIndices:
	.db <TX_3410, <TX_3411, <TX_3412, <TX_3412 ; 0 == [subid]
	.db <TX_3413, <TX_3414, <TX_3414, <TX_3414 ; 1
	.db <TX_3415, <TX_3416, <TX_3416, <TX_3416 ; 2
	.db <TX_3417, <TX_3418, <TX_3419, <TX_3419 ; 3
	.db <TX_341a, <TX_341b, <TX_341b, <TX_341b ; 4
	.db <TX_3420, <TX_3421, <TX_3422, <TX_3423 ; 5
	.db <TX_3424, <TX_3424, <TX_3424, <TX_3424 ; 6
	.db <TX_3425, <TX_3425, <TX_3426, <TX_3426 ; 7
	.db <TX_3427, <TX_3427, <TX_3427, <TX_3427 ; 8
	.db <TX_3428, <TX_3428, <TX_3429, <TX_3429 ; 9


; ==============================================================================
; INTERACID_ZELDA
; ==============================================================================
interactionCodead:
	ld e,Interaction.state		; $62a9
	ld a,(de)		; $62ab
	rst_jumpTable			; $62ac
	.dw _zelda_state0
	.dw _zelda_state1

_zelda_state0:
	ld a,$01		; $62b1
	ld (de),a ; [state]
	call interactionInitGraphics		; $62b4
	call objectSetVisiblec2		; $62b7

	ld e,Interaction.subid		; $62ba
	ld a,(de)		; $62bc
	rst_jumpTable			; $62bd
	.dw @initSubid00
	.dw @commonInit
	.dw @commonInit
	.dw @initSubid03
	.dw @initSubid04
	.dw @commonInitWithExtraGraphics
	.dw @commonInit
	.dw @initSubid07
	.dw @initSubid08
	.dw @commonInit
	.dw @initSubid0a

@initSubid04:
	call checkIsLinkedGame		; $62d4
	jp z,interactionDeleteAndUnmarkSolidPosition		; $62d7

	ld a,TREASURE_MAKU_SEED		; $62da
	call checkTreasureObtained		; $62dc
	jp nc,interactionDeleteAndUnmarkSolidPosition		; $62df

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $62e2
	call checkGlobalFlag		; $62e4
	jp nz,interactionDeleteAndUnmarkSolidPosition		; $62e7

	ld h,d			; $62ea
	ld l,Interaction.speed		; $62eb
	ld (hl),SPEED_100		; $62ed
	ld l,Interaction.angle		; $62ef
	ld (hl),$08		; $62f1
	jp @commonInit		; $62f3

@initSubid03:
	ld bc,$4820		; $62f6
	call interactionSetPosition		; $62f9
	ld a,$01		; $62fc
	call interactionSetAnimation		; $62fe
	jp @commonInit		; $6301

@initSubid07:
	ld a,GLOBALFLAG_GOT_RING_FROM_ZELDA		; $6304
	call checkGlobalFlag		; $6306
	jp z,interactionDeleteAndUnmarkSolidPosition		; $6309

	ld a,TREASURE_MAKU_SEED		; $630c
	call checkTreasureObtained		; $630e
	jp c,interactionDeleteAndUnmarkSolidPosition		; $6311

	ld a,GLOBALFLAG_SAVED_NAYRU		; $6314
	call checkGlobalFlag		; $6316
	ld a,<TX_0606		; $6319
	jr nz,@actAsGenericNpc			; $631b
	ld a,<TX_0605		; $631d

@actAsGenericNpc:
	ld e,Interaction.textID		; $631f
	ld (de),a		; $6321
	inc e			; $6322
	ld a,>TX_0600		; $6323
	ld (de),a		; $6325
	ld hl,genericNpcScript		; $6326
	jp interactionSetScript		; $6329

@initSubid08:
	call checkIsLinkedGame		; $632c
	jp z,interactionDeleteAndUnmarkSolidPosition		; $632f

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $6332
	call checkGlobalFlag		; $6334
	jp z,interactionDeleteAndUnmarkSolidPosition		; $6337

	ld a,GLOBALFLAG_FLAME_OF_DESPAIR_LIT		; $633a
	call checkGlobalFlag		; $633c
	jp nz,interactionDeleteAndUnmarkSolidPosition		; $633f

	ld a,<TX_060b		; $6342
	jr @actAsGenericNpc		; $6344

@initSubid0a:
	call checkIsLinkedGame		; $6346
	jp z,interactionDeleteAndUnmarkSolidPosition		; $6349

	ld a,TREASURE_MAKU_SEED		; $634c
	call checkTreasureObtained		; $634e
	jp nc,interactionDeleteAndUnmarkSolidPosition		; $6351

	ld a,GLOBALFLAG_PRE_BLACK_TOWER_CUTSCENE_DONE		; $6354
	call checkGlobalFlag		; $6356
	jp nz,interactionDeleteAndUnmarkSolidPosition		; $6359

	ld a,<TX_060a		; $635c
	jr @actAsGenericNpc		; $635e

@initSubid00:
	call getThisRoomFlags		; $6360
	bit 7,a			; $6363
	jr z,@commonInitWithExtraGraphics	; $6365
	ld a,$01		; $6367
	ld (wDisableScreenTransitions),a		; $6369
	ld a,(wActiveMusic)		; $636c
	or a			; $636f
	jr z,@commonInitWithExtraGraphics	; $6370
	xor a			; $6372
	ld (wActiveMusic),a		; $6373
	ld a,MUS_ZELDA_SAVED		; $6376
	call playSound		; $6378

@commonInitWithExtraGraphics:
	call interactionLoadExtraGraphics		; $637b

@commonInit:
	call _zelda_loadScript		; $637e


_zelda_state1:
	ld e,$42		; $6381
	ld a,(de)		; $6383
	rst_jumpTable			; $6384
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @runSubid2
	.dw @animateAndRunScript
	.dw @runSubid4
	.dw @animateAndRunScript
	.dw @animateAndRunScript
	.dw @faceLinkAndRunScript
	.dw @faceLinkAndRunScript
	.dw @animateAndRunScript
	.dw @faceLinkAndRunScript

@animateAndRunScript:
	call interactionAnimate		; $639b
	jp interactionRunScript		; $639e

@runSubid2:
	ld e,Interaction.var39		; $63a1
	ld a,(de)		; $63a3
	or a			; $63a4
	call z,interactionAnimate		; $63a5
	jp interactionRunScript		; $63a8

@runSubid4:
	call interactionRunScript		; $63ab
	jp nc,interactionAnimateBasedOnSpeed		; $63ae
	jp interactionDeleteAndUnmarkSolidPosition		; $63b1

@faceLinkAndRunScript:
	call interactionRunScript		; $63b4
	jp npcFaceLinkAndAnimate		; $63b7

;;
; @addr{63ba}
_zelda_loadScript:
	ld e,Interaction.subid		; $63ba
	ld a,(de)		; $63bc
	ld hl,@scriptTable		; $63bd
	rst_addDoubleIndex			; $63c0
	ldi a,(hl)		; $63c1
	ld h,(hl)		; $63c2
	ld l,a			; $63c3
	jp interactionSetScript		; $63c4

@scriptTable:
	.dw zeldaSubid00Script
	.dw zeldaSubid01Script
	.dw zeldaSubid02Script
	.dw zeldaSubid03Script
	.dw zeldaSubid04Script
	.dw zeldaSubid05Script
	.dw zeldaSubid06Script
	.dw stubScript
	.dw stubScript
	.dw zeldaSubid09Script
	.dw stubScript


; ==============================================================================
; INTERACID_CREDITS_TEXT_HORIZONTAL
;
; Variables:
;   var03: ?
;   var30: ?
;   var31: ?
;   var32: ?
;   var33: ?
; ==============================================================================
interactionCodeae:
	ld e,Interaction.state		; $63dd
	ld a,(de)		; $63df
	rst_jumpTable			; $63e0
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $63e5
	ld (de),a ; [state]
	ld e,Interaction.var03		; $63e8
	ld a,(de)		; $63ea
	or a			; $63eb
	jr nz,@var03Nonzero	; $63ec

	ld h,d			; $63ee
	ld l,Interaction.subid		; $63ef
	ld a,(hl)		; $63f1
	ld hl,_horizontalCreditsText_scriptTable		; $63f2
	rst_addDoubleIndex			; $63f5
	ldi a,(hl)		; $63f6
	ld h,(hl)		; $63f7
	ld l,a			; $63f8
	call _creditsTextHorizontal_6559		; $63f9

	ld e,Interaction.subid		; $63fc
	ld a,(de)		; $63fe
	ld hl,_horizontalCreditsText_65b1		; $63ff
	rst_addDoubleIndex			; $6402
	ldi a,(hl)		; $6403
	ld e,Interaction.var32		; $6404
	ld (de),a		; $6406
	ldi a,(hl)		; $6407
	ld e,Interaction.counter2		; $6408
	ld (de),a		; $640a
	ret			; $640b

@var03Nonzero:
	call interactionInitGraphics		; $640c
	ld h,d			; $640f
	ld l,Interaction.var30		; $6410
	ld (hl),$14		; $6412
	ld l,Interaction.speed		; $6414
	ld (hl),SPEED_200		; $6416

	ld l,Interaction.counter2		; $6418
	ld a,(hl)		; $641a
	call interactionSetAnimation		; $641b

	ld h,d			; $641e
	ld l,Interaction.subid		; $641f
	ld a,(hl)		; $6421
	or a			; $6422
	ld bc,$f018		; $6423
	jr z,+			; $6426
	ld bc,$0008		; $6428
+
	ld l,Interaction.xh		; $642b
	ld (hl),b		; $642d
	ld l,Interaction.angle		; $642e
	ld (hl),c		; $6430
	jp objectSetVisible82		; $6431

@state1:
	ld a,$01		; $6434
	ld (de),a ; [state]
	ld e,Interaction.var03		; $6437
	ld a,(de)		; $6439
	or a			; $643a
	jp nz,_horizontalCreditsText_var03Nonzero		; $643b

	ld a,(wPaletteThread_mode)		; $643e
	or a			; $6441
	ret nz			; $6442
	ld e,Interaction.state2		; $6443
	ld a,(de)		; $6445
	rst_jumpTable			; $6446
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $644d
	ld l,Interaction.var30		; $644e
	call decHlRef16WithCap		; $6450
	ret nz			; $6453
	call _creditsTextHorizontal_6537		; $6454

@func_6457:
	ld e,Interaction.var30		; $6457
	ld a,(de)		; $6459
	rlca			; $645a
	ret nc			; $645b

	ld b,$01		; $645c
	rlca			; $645e
	jr nc,+			; $645f
	ld b,$02		; $6461
+
	ld h,d			; $6463
	ld l,Interaction.counter1		; $6464
	ld (hl),180		; $6466
	ld l,Interaction.state2		; $6468
	ld (hl),b		; $646a
	ret			; $646b

@substate1:
	ld e,Interaction.var33		; $646c
	ld a,(de)		; $646e
	rst_jumpTable			; $646f
	.dw @subsubstate0
	.dw @subsubstate1
	.dw @subsubstate2
	.dw @subsubstate3

@subsubstate0:
	call interactionDecCounter1		; $6478
	ret nz			; $647b
	ld h,d			; $647c
	ld l,Interaction.var33		; $647d
	inc (hl)		; $647f
	ret			; $6480

@subsubstate1:
	ld a,(wFrameCounter)		; $6481
	and $03			; $6484
	ret nz			; $6486

	ld h,d			; $6487
	ld l,Interaction.counter1		; $6488
	ld a,(hl)		; $648a
	cp $10			; $648b
	jr nz,@label_0b_234	; $648d

	ld l,Interaction.var33		; $648f
	inc (hl)		; $6491

	ld l,Interaction.scriptPtr		; $6492
	ld a,(hl)		; $6494
	sub $03			; $6495
	ldi (hl),a		; $6497
	ld a,(hl)		; $6498
	sbc $00			; $6499
	ld (hl),a		; $649b

	call _creditsTextHorizontal_6554		; $649c
	ld h,d			; $649f
	ld l,Interaction.counter1		; $64a0
	ld (hl),30		; $64a2
	ret			; $64a4

@label_0b_234:
	ld a,($ff00+R_SVBK)	; $64a5
	push af			; $64a7
	ld l,Interaction.counter1		; $64a8
	ld a,(hl)		; $64aa
	ld b,a			; $64ab
	ld a,:w4TileMap		; $64ac
	ld ($ff00+R_SVBK),a	; $64ae
	ld a,b			; $64b0
	ld hl,w4TileMap		; $64b1
	rst_addDoubleIndex			; $64b4
	ld b,$30		; $64b5
@loop:
	xor a			; $64b7
	ldi (hl),a		; $64b8
	ld (hl),a		; $64b9
	ld a,$1f		; $64ba
	rst_addAToHl			; $64bc
	dec b			; $64bd
	jr nz,@loop	; $64be

	push de			; $64c0
	ld a,UNCMP_GFXH_09		; $64c1
	call loadUncompressedGfxHeader		; $64c3
	pop de			; $64c6
	pop af			; $64c7
	ld ($ff00+R_SVBK),a	; $64c8

	ld h,d			; $64ca
	ld l,Interaction.counter1		; $64cb
	inc (hl)		; $64cd
	ret			; $64ce

@subsubstate2:
	call interactionDecCounter1		; $64cf
	ret nz			; $64d2
	ld l,Interaction.var33		; $64d3
	inc (hl)		; $64d5
	ld l,Interaction.counter1		; $64d6
	ld (hl),$10		; $64d8
	ret			; $64da

@subsubstate3:
	ld a,(wFrameCounter)		; $64db
	and $03			; $64de
	ret nz			; $64e0
	call interactionDecCounter1		; $64e1
	jr nz,@label_0b_236	; $64e4

	xor a			; $64e6
	ld l,Interaction.state2		; $64e7
	ld (hl),a		; $64e9
	ld l,Interaction.var33		; $64ea
	ld (hl),a		; $64ec
	jp @func_6457		; $64ed

@label_0b_236:
	push de			; $64f0
	ld a,($ff00+R_SVBK)	; $64f1
	push af			; $64f3
	ld a,(hl) ; [counter1]
	ld b,a			; $64f5

	ld a,b			; $64f6
	ld hl,w4TileMap		; $64f7
	rst_addDoubleIndex			; $64fa
	ld a,b			; $64fb
	ld de,w3VramTiles		; $64fc
	call addDoubleIndexToDe		; $64ff
	ld b,$30		; $6502
@tileLoop:
	push bc			; $6504
	ld a,:w3VramTiles		; $6505
	ld ($ff00+R_SVBK),a	; $6507
	ld a,(de)		; $6509
	ld b,a			; $650a
	inc de			; $650b
	ld a,(de)		; $650c
	ld c,a			; $650d
	ld a,:w4TileMap		; $650e
	ld ($ff00+R_SVBK),a	; $6510
	ld (hl),b		; $6512
	inc hl			; $6513
	ld (hl),c		; $6514
	ld a,$1f		; $6515
	ld c,a			; $6517
	rst_addAToHl			; $6518
	ld a,c			; $6519
	call addAToDe		; $651a
	pop bc			; $651d
	dec b			; $651e
	jr nz,@tileLoop	; $651f

	ld a,UNCMP_GFXH_09		; $6521
	call loadUncompressedGfxHeader		; $6523
	pop af			; $6526
	ld ($ff00+R_SVBK),a	; $6527
	pop de			; $6529
	ret			; $652a

@substate2:
	call interactionDecCounter1		; $652b
	ret nz			; $652e
	ld hl,wTmpcfc0.genericCutscene.cfdf		; $652f
	ld (hl),$ff		; $6532
	jp interactionDelete		; $6534

;;
; @addr{6537}
_creditsTextHorizontal_6537:
	call getFreeInteractionSlot		; $6537
	jr nz,++		; $653a
	ld (hl),INTERACID_CREDITS_TEXT_HORIZONTAL		; $653c
	inc l			; $653e
	ld e,Interaction.var32		; $653f
	ld a,(de)		; $6541
	ldi (hl),a  ; [child.subid]
	ld (hl),$01 ; [child.var03]

	ld l,Interaction.counter1		; $6545
	ld e,l			; $6547
	ld a,(de)		; $6548
	inc e			; $6549
	ldi (hl),a		; $654a
	ld a,(de) ; [counter2]
	ld (hl),a		; $654c
	call objectCopyPosition		; $654d
++
	ld h,d			; $6550
	ld l,Interaction.counter2		; $6551
	inc (hl)		; $6553

;;
; @addr{6554}
_creditsTextHorizontal_6554:
	ld l,Interaction.scriptPtr		; $6554
	ldi a,(hl)		; $6556
	ld h,(hl)		; $6557
	ld l,a			; $6558

;;
; @param	hl	Script pointer
; @addr{6559}
_creditsTextHorizontal_6559:
	ldi a,(hl)		; $6559
	ld e,Interaction.var30		; $655a
	ld (de),a		; $655c

	inc e			; $655d
	ldi a,(hl)		; $655e
	ld (de),a ; [var31]

	ldi a,(hl)		; $6560
	ld e,Interaction.counter1		; $6561
	ld (de),a		; $6563

	ldi a,(hl)		; $6564
	ld e,Interaction.yh		; $6565
	ld (de),a		; $6567

	ld e,Interaction.scriptPtr		; $6568
	ld a,l			; $656a
	ld (de),a		; $656b
	inc e			; $656c
	ld a,h			; $656d
	ld (de),a		; $656e

	ld e,Interaction.var31		; $656f
	ld a,(de)		; $6571
	or a			; $6572
	ret nz			; $6573

	dec e			; $6574
	ld a,(de) ; [var30]
	or a			; $6576
	ret nz			; $6577
	jp _creditsTextHorizontal_6537		; $6578

;;
; @addr{657b}
_horizontalCreditsText_var03Nonzero:
	ld a,(wPaletteThread_mode)		; $657b
	or a			; $657e
	ret nz			; $657f
	ld e,Interaction.state2		; $6580
	ld a,(de)		; $6582
	rst_jumpTable			; $6583
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d			; $6588
	ld l,Interaction.var30		; $6589
	dec (hl)		; $658b
	jr nz,@applySpeed	; $658c

	call interactionIncState2		; $658e
	ld b,$a0		; $6591
	ld l,Interaction.subid		; $6593
	ld a,(hl)		; $6595
	or a			; $6596
	jr z,+			; $6597
	ld b,$50		; $6599
+
	ld l,Interaction.xh		; $659b
	ld (hl),b		; $659d
	ret			; $659e

@applySpeed:
	call objectApplySpeed		; $659f
	jp objectApplySpeed		; $65a2

@substate1:
	ld e,Interaction.counter1		; $65a5
	ld a,(de)		; $65a7
	inc a			; $65a8
	ret z			; $65a9
	call interactionDecCounter1		; $65aa
	jp z,interactionDelete		; $65ad
	ret			; $65b0

_horizontalCreditsText_65b1:
	.db $00 $00 $01 $04 $00 $0b $01 $13
	.db $00 $00 $01 $04 $00 $0b $01 $13


; Custom script format? TODO: figure this out
_horizontalCreditsText_scriptTable:
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3
	.dw @script0
	.dw @script1
	.dw @script2
	.dw @script3

@script0:
	.db $20 $00 $ff $f8
	.db $30 $00 $f0 $18
	.db $20 $00 $f0 $38
	.db $20 $00 $f0 $50
	.db $ff

@script1:
	.db $20 $00 $ff $f8
	.db $20 $00 $f8 $18
	.db $10 $00 $e8 $38
	.db $10 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $10 $00 $00 $ff
	.db $28 $00 $00 $ff
	.db $50 $ff

@script2:
	.db $20 $00 $fe $f8
	.db $10 $00 $e8 $18
	.db $0a $00 $d8 $38
	.db $0a $00 $c8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff

@script3:
	.db $20 $00 $f8 $f8
	.db $20 $00 $d8 $18
	.db $00 $00 $d8 $38
	.db $00 $00 $d8 $58
	.db $80 $00 $00 $ff
	.db $f8 $00 $00 $ff
	.db $18 $00 $00 $ff
	.db $38 $00 $00 $ff
	.db $58 $ff


; ==============================================================================
; INTERACID_CREDITS_TEXT_VERTICAL
;
; Variables:
;   var30/var31: 16-bit counter?
; ==============================================================================
interactionCodeaf:
	ld e,Interaction.state		; $6644
	ld a,(de)		; $6646
	rst_jumpTable			; $6647
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $664c
	ld (de),a ; [state]
	ld e,Interaction.subid		; $664f
	ld a,(de)		; $6651
	or a			; $6652
	jr nz,+			; $6653
	ld hl,@data_66bc		; $6655
	jp @storeVar30Value		; $6658
+
	ld h,d			; $665b
	ld l,Interaction.speed		; $665c
	ld (hl),SPEED_80		; $665e
	ret			; $6660

@state1:
	ld e,Interaction.subid		; $6661
	ld a,(de)		; $6663
	or a			; $6664
	jr nz,@subid1	; $6665

	ld a,(wPaletteThread_mode)		; $6667
	or a			; $666a
	ret nz			; $666b

	ld h,d			; $666c
	ld l,Interaction.var30		; $666d
	call decHlRef16WithCap		; $666f
	ret nz			; $6672

	call @spawnChild		; $6673
	ld e,Interaction.var30		; $6676
	ld a,(de)		; $6678
	inc a			; $6679
	ret nz			; $667a

	ld hl,wTmpcfc0.genericCutscene.cfdf		; $667b
	ld (hl),$ff		; $667e
	jp interactionDelete		; $6680

@spawnChild:
	call getFreeInteractionSlot		; $6683
	jr nz,++		; $6686
	ld (hl),INTERACID_CREDITS_TEXT_VERTICAL		; $6688
	inc l			; $668a
	ld (hl),$01 ; [child.subid] = 1
	inc l			; $668d
	ld e,Interaction.counter1		; $668e
	ld a,(de)		; $6690
	ld (hl),a ; [child.var03]
	call objectCopyPosition		; $6692
++
	ld h,d			; $6695
	ld l,Interaction.counter1		; $6696
	inc (hl)		; $6698
	ld a,(hl)		; $6699
	ld hl,@data_66bc		; $669a
	rst_addDoubleIndex			; $669d

@storeVar30Value:
	ldi a,(hl)		; $669e
	ld e,Interaction.var30		; $669f
	ld (de),a		; $66a1
	inc e			; $66a2
	ldi a,(hl)		; $66a3
	ld (de),a		; $66a4
	ret			; $66a5

@subid1:
	ld a,(wPaletteThread_mode)		; $66a6
	or a			; $66a9
	ret nz			; $66aa
	call objectApplySpeed		; $66ab
	ld h,d			; $66ae
	ld l,Interaction.yh		; $66af
	ldi a,(hl)		; $66b1
	ld b,a			; $66b2
	or a			; $66b3
	jp z,interactionDelete		; $66b4
	inc l			; $66b7
	ld c,(hl) ; [xh]
	jp interactionFunc_3e6d		; $66b9

@data_66bc:
	.dw $0020
	.dw $00e0
	.dw $0120
	.dw $0110
	.dw $00f0
	.dw $0160
	.dw $00f0
	.dw $0120
	.dw $0170
	.dw $0150
	.dw $0160
	.dw $0140
	.dw $0140
	.dw $0160
	.dw $0110
	.dw $0160
	.dw $01a0
	.db $ff


; ==============================================================================
; INTERACID_TWINROVA_IN_CUTSCENE
; ==============================================================================
interactionCodeb0:
	ld e,Interaction.state		; $66df
	ld a,(de)		; $66e1
	rst_jumpTable			; $66e2
	.dw _twinrovaInCutscene_state0
	.dw _twinrovaInCutscene_state1


_twinrovaInCutscene_state0:
	ld a,$01		; $66e7
	ld (de),a ; [state]
	call interactionInitGraphics		; $66ea
	call objectSetVisiblec2		; $66ed
	ld a,>TX_2800		; $66f0
	call interactionSetHighTextIndex		; $66f2
	ld e,Interaction.subid		; $66f5
	ld a,(de)		; $66f7
	rst_jumpTable			; $66f8
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	ld a,$01		; $6701
	call @commonInit1		; $6703
	jr _twinrovaInCutscene_loadScript		; $6706

@subid1:
	ld a,$02		; $6708

@commonInit1:
	ld e,Interaction.oamFlags		; $670a
	ld (de),a		; $670c
	ld e,Interaction.subid		; $670d
	ld a,(de)		; $670f
	jp interactionSetAnimation		; $6710


@subid2:
	ld a,$01		; $6713
	jr @commonInit2		; $6715

@subid3:
	ld a,$01		; $6717
	call interactionSetAnimation		; $6719
	ld a,$02		; $671c

@commonInit2:
	ld e,Interaction.oamFlags		; $671e
	ld (de),a		; $6720
	jp interactionSetAlwaysUpdateBit		; $6721


_twinrovaInCutscene_state1:
	ld e,Interaction.subid		; $6724
	ld a,(de)		; $6726
	rst_jumpTable			; $6727
	.dw @subid0
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate

@subid0:
	call checkInteractionState2		; $6730
	jr nz,@substate1	; $6733

@substate0:
	call interactionAnimate		; $6735
	call interactionRunScript		; $6738
	ret nc			; $673b
	ld a,SND_LIGHTNING		; $673c
	call playSound		; $673e
	xor a			; $6741
	ld (wGenericCutscene.cbb3),a		; $6742
	dec a			; $6745
	ld (wGenericCutscene.cbba),a		; $6746
	jp interactionIncState2		; $6749

@substate1:
	ld hl,wGenericCutscene.cbb3		; $674c
	ld b,$02		; $674f
	call flashScreen		; $6751
	ret z			; $6754
	ld a,$02		; $6755
	ld (wGenericCutscene.cbb8),a		; $6757
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION		; $675a
	ld (wCutsceneTrigger),a		; $675c
	ret			; $675f

_twinrovaInCutscene_loadScript:
	ld e,Interaction.subid		; $6760
	ld a,(de)		; $6762
	ld hl,@scriptTable		; $6763
	rst_addDoubleIndex			; $6766
	ldi a,(hl)		; $6767
	ld h,(hl)		; $6768
	ld l,a			; $6769
	jp interactionSetScript		; $676a

@scriptTable:
	.dw twinrovaInCutsceneScript
	.dw stubScript


; ==============================================================================
; INTERACID_TUNI_NUT
; ==============================================================================
interactionCodeb1:
	ld hl,bank3f.interactionCodeb1_body		; $6771
	ld e,:bank3f.interactionCodeb1_body		; $6774
	jp interBankCall		; $6776


; ==============================================================================
; INTERACID_VOLCANO_HANDLER
; ==============================================================================
interactionCodeb2:
	call checkInteractionState		; $6779
	jr z,@state0	; $677c

@state1:
	ld a,(wFrameCounter)		; $677e
	and $0f			; $6781
	ld a,SND_RUMBLE		; $6783
	call z,playSound		; $6785

	ld a,(wScreenShakeCounterY)		; $6788
	or a			; $678b
	jr nz,++		; $678c
	ld a,(wScreenShakeCounterX)		; $678e
	or a			; $6791
	call z,@runScript		; $6792
++
	call interactionDecCounter1		; $6795
	ret nz			; $6798
	call @setRandomCounter1		; $6799

	ld c,$0f		; $679c
	call getRandomNumber		; $679e
	and c			; $67a1
	srl c			; $67a2
	inc c			; $67a4
	sub c			; $67a5
	ld c,a			; $67a6
	call getFreePartSlot		; $67a7
	ret nz			; $67aa
	ld (hl),PARTID_VOLCANO_ROCK		; $67ab
	inc l			; $67ad
	ld (hl),$01 ; [subid]
	ld b,$00		; $67b0
	jp objectCopyPositionWithOffset		; $67b2

@state0:
	inc a			; $67b5
	ld (de),a ; [state]
	ld (wScreenShakeMagnitude),a		; $67b7
	ld hl,@script		; $67ba
	jp interactionSetMiniScript		; $67bd

@runScript:
	call interactionGetMiniScript		; $67c0
	ldi a,(hl)		; $67c3
	cp $ff			; $67c4
	jr nz,@handleOpcode	; $67c6
	ld hl,@script		; $67c8
	call interactionSetMiniScript		; $67cb
	jr @runScript		; $67ce

@handleOpcode:
	ld (wScreenShakeCounterY),a		; $67d0
	ldi a,(hl)		; $67d3
	ld (wScreenShakeCounterX),a		; $67d4

	ld e,Interaction.var30		; $67d7
	ldi a,(hl)		; $67d9
	ld (de),a		; $67da
	inc e			; $67db
	ldi a,(hl)		; $67dc
	ld (de),a		; $67dd

	call interactionSetMiniScript		; $67de

@setRandomCounter1:
	call getRandomNumber_noPreserveVars		; $67e1
	ld h,d			; $67e4
	ld l,Interaction.var30		; $67e5
	and (hl)		; $67e7
	inc l			; $67e8
	add (hl)		; $67e9
	ld l,Interaction.counter1		; $67ea
	ld (hl),a		; $67ec
	ret			; $67ed


; "Script" format per line:
;   b0: wScreenShakeCounterY
;   b1: wScreenShakeCounterX
;   b2: ANDed with a random number and added to...
;   b3: Base value for counter1 (time until a rock spawns)
@script:
	.db 0  , 30 , $00, $ff
	.db 30 , 0  , $00, $ff
	.db 180, 180, $0f, $08
	.db 60 , 60 , $1f, $10
	.db 30 , 0  , $00, $ff
	.db 0  , 120, $00, $ff
	.db 15 , 15 , $00, $ff
	.db $ff


; ==============================================================================
; INTERACID_HARP_OF_AGES_SPAWNER
; ==============================================================================
interactionCodeb3:
	ld e,Interaction.state		; $680b
	ld a,(de)		; $680d
	rst_jumpTable			; $680e
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call getThisRoomFlags		; $6819
	bit ROOMFLAG_BIT_ITEM,(hl)		; $681c
	jp nz,interactionDelete ; Already got harp

	xor a			; $6821
	ld (wTmpcfc0.genericCutscene.state),a		; $6822

	call getFreeInteractionSlot		; $6825
	ret nz			; $6828
	ld (hl),INTERACID_TREASURE		; $6829
	inc l			; $682b
	ld (hl),TREASURE_HARP		; $682c

	ld l,Interaction.yh		; $682e
	ld (hl),$38		; $6830
	ld l,Interaction.xh		; $6832
	ld (hl),$58		; $6834
	ld b,h			; $6836

	; Spawn a sparkle object attached to the harp of ages object we just spawned
	call getFreeInteractionSlot		; $6837
	jr nz,@incState	; $683a
	ld (hl),INTERACID_SPARKLE		; $683c
	inc l			; $683e
	ld (hl),$0c ; [subid]
	ld l,Interaction.relatedObj1		; $6841
	ld a,Interaction.start		; $6843
	ldi (hl),a		; $6845
	ld (hl),b		; $6846

@incState:
	call interactionSetAlwaysUpdateBit		; $6847
	jp interactionIncState		; $684a


@state1:
	call getThisRoomFlags		; $684d
	bit ROOMFLAG_BIT_ITEM,(hl)		; $6850
	ret z			; $6852

	; Got harp; start cutscene
	ld a,SNDCTRL_STOPMUSIC		; $6853
	call playSound		; $6855

	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $6858
	ld (wDisabledObjects),a		; $685a
	ld (wMenuDisabled),a		; $685d

	call interactionIncState		; $6860


@state2:
	ld a,(wTextIsActive)		; $6863
	or a			; $6866
	ret z			; $6867

	xor a			; $6868
	ld (w1Link.direction),a		; $6869
	jp interactionIncState		; $686c


@state3:
	ld a,(wTextIsActive)		; $686f
	or a			; $6872
	ret nz			; $6873

	ld hl,wTmpcfc0.genericCutscene.state		; $6874
	set 0,(hl)		; $6877
	call interactionIncState		; $6879

	ld l,Interaction.counter1		; $687c
	ld (hl),40		; $687e

	ld a,$02		; $6880
	call fadeoutToBlackWithDelay		; $6882

	ld a,$ff		; $6885
	ld (wDirtyFadeBgPalettes),a		; $6887
	ld (wFadeBgPaletteSources),a		; $688a
	ld a,$01		; $688d
	ld (wDirtyFadeSprPalettes),a		; $688f
	ld a,$fe		; $6892
	ld (wFadeSprPaletteSources),a		; $6894

	call hideStatusBar		; $6897
	ldh a,(<hActiveObject)	; $689a
	ld d,a			; $689c
	ret			; $689d

@state4:
	ld a,(wPaletteThread_mode)		; $689e
	or a			; $68a1
	ret nz			; $68a2
	call interactionDecCounter1		; $68a3
	ret nz			; $68a6

	inc (hl) ; [counter1] = 1

	call getFreeInteractionSlot		; $68a8
	ret nz			; $68ab
	ld (hl),INTERACID_NAYRU		; $68ac
	inc l			; $68ae
	ld (hl),$07 ; [subid]
	call objectCopyPosition		; $68b1

	jp interactionDelete		; $68b4


; ==============================================================================
; INTERACID_BOOK_OF_SEALS_PODIUM
;
; Variables:
;   var03: Tile index to replace path with?
; ==============================================================================
interactionCodeb4:
	ld e,Interaction.state		; $68b7
	ld a,(de)		; $68b9
	rst_jumpTable			; $68ba
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01		; $68c5
	ld (de),a ; [state]

	ld a,$06		; $68c8
	call objectSetCollideRadius		; $68ca
	call interactionInitGraphics		; $68cd
	call interactionSetAlwaysUpdateBit		; $68d0

	ld a,>TX_1200		; $68d3
	call interactionSetHighTextIndex		; $68d5

	ld e,Interaction.pressedAButton		; $68d8
	call objectAddToAButtonSensitiveObjectList		; $68da

	ld e,Interaction.subid		; $68dd
	ld a,(de)		; $68df
	or a			; $68e0
	ret nz			; $68e1

	; Subid 0
	ld hl,wTmpcfc0.genericCutscene.cfd0		; $68e2
	ld b,$10		; $68e5
	call z,clearMemory		; $68e7
	call getThisRoomFlags		; $68ea
	bit 6,a			; $68ed
	ret nz			; $68ef
	call interactionIncState		; $68f0
	ld hl,bookOfSealsPodiumScript		; $68f3
	jp interactionSetScript		; $68f6

@state1:
	inc e			; $68f9
	ld a,(de) ; [state2]
	or a			; $68fb
	call z,@spawnAllPodiums		; $68fc
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $68ff
	ld e,Interaction.pressedAButton		; $6902
	ld a,(de)		; $6904
	or a			; $6905
	ret z			; $6906

@activatedBook:
	ld a,$01		; $6907
	call interactionSetAnimation		; $6909
	call @func_69ce		; $690c
	ld a,c			; $690f
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $6910

	ld hl,@textTable		; $6913
	rst_addAToHl			; $6916
	ld c,(hl)		; $6917
	ld b,>TX_1200		; $6918
	call showText		; $691a

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $691d
	ld (wMenuDisabled),a		; $691f
	ld (wDisabledObjects),a		; $6922

	ld h,d			; $6925
	ld l,Interaction.var03		; $6926
	ld a,$d3		; $6928
	ldi (hl),a		; $692a
	ld a,$03		; $692b
	ldi (hl),a ; [state]
	inc l			; $692e
	ld (hl),$02 ; [state2]
	ret			; $6931

@textTable:
	.db <TX_120b, <TX_120c, <TX_120d, <TX_120e, <TX_120f, <TX_1210

@state2:
	inc e			; $6938
	ld a,(de) ; [state2]
	or a			; $693a
	call z,@spawnAllPodiums		; $693b
	call interactionRunScript		; $693e
	ret nc			; $6941

	; Placed book on podium
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $6942
	ld a,SND_SOLVEPUZZLE		; $6945
	call playSound		; $6947
	ld a,TREASURE_BOOK_OF_SEALS		; $694a
	call loseTreasure		; $694c
	jr @activatedBook		; $694f

@state3:
	call retIfTextIsActive		; $6951
	call @replaceTiles		; $6954
	ld a,(wDisabledObjects)		; $6957
	or a			; $695a
	ret nz			; $695b
	ld e,Interaction.var03		; $695c
	ld a,$f4		; $695e
	ld (de),a		; $6960
	jp @func_69ce		; $6961

;;
; @addr{6964}
@replaceTiles:
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $6964
	ld (wDisabledObjects),a		; $6966
	call interactionDecCounter1		; $6969
	ret nz			; $696c
	ld (hl),$02 ; [counter1]
	ld l,Interaction.scriptPtr		; $696f
	ldi a,(hl)		; $6971
	ld h,(hl)		; $6972
	ld l,a			; $6973

	ldi a,(hl)		; $6974
	or a			; $6975
	jr z,@label_0b_273	; $6976

	ld c,a			; $6978
	ld e,Interaction.var03		; $6979
	ld a,(de)		; $697b
	push hl			; $697c
	call setTile		; $697d
	pop hl			; $6980
	ret z			; $6981
	ld e,Interaction.scriptPtr		; $6982
	ld a,l			; $6984
	ld (de),a		; $6985
	inc e			; $6986
	ld a,h			; $6987
	ld (de),a		; $6988
	ret			; $6989

@label_0b_273:
	; a == 0 here
	ld (wDisabledObjects),a		; $698a
	ld (wMenuDisabled),a		; $698d
	ld e,Interaction.pressedAButton		; $6990
	ld (de),a		; $6992
	jp interactionIncState		; $6993


@state4:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $6996
	ld e,Interaction.pressedAButton		; $6999
	ld a,(de)		; $699b
	or a			; $699c
	jr z,++			; $699d

	xor a			; $699f
	ld (de),a		; $69a0
	ld e,Interaction.subid		; $69a1
	ld a,(de)		; $69a3
	ld hl,@textTable		; $69a4
	rst_addAToHl			; $69a7
	ld c,(hl)		; $69a8
	ld b,>TX_1200		; $69a9
	jp showText		; $69ab
++
	ld hl,wTmpcfc0.genericCutscene.cfd0		; $69ae
	ld e,Interaction.subid		; $69b1
	ld a,(de)		; $69b3
	cp (hl)			; $69b4
	ret z			; $69b5

	call retIfTextIsActive		; $69b6
	call @replaceTiles		; $69b9
	ld a,(wDisabledObjects)		; $69bc
	or a			; $69bf
	ret nz			; $69c0

	call interactionSetAnimation		; $69c1
	ld e,Interaction.state		; $69c4
	ld a,$01		; $69c6
	ld (de),a		; $69c8
	ld e,Interaction.pressedAButton		; $69c9
	xor a			; $69cb
	ld (de),a		; $69cc
	ret			; $69cd

;;
; @param[out]	c	Subid
; @addr{69ce}
@func_69ce:
	ld e,Interaction.subid		; $69ce
	ld a,(de)		; $69d0
	ld c,a			; $69d1
	ld hl,@bookPathLists		; $69d2
	rst_addAToHl			; $69d5
	ld a,(hl)		; $69d6
	rst_addAToHl			; $69d7
	ld e,Interaction.scriptPtr		; $69d8
	ld a,l			; $69da
	ld (de),a		; $69db
	inc e			; $69dc
	ld a,h			; $69dd
	ld (de),a		; $69de
	ret			; $69df

@spawnAllPodiums:
	call returnIfScrollMode01Unset		; $69e0
	ld a,$01		; $69e3
	ld (de),a		; $69e5
	ld e,Interaction.subid		; $69e6
	ld a,(de)		; $69e8
	or a			; $69e9
	ret nz			; $69ea

	ld bc,@podiumPositions		; $69eb
	ld e,$05		; $69ee

@next:
	call getFreeInteractionSlot		; $69f0
	ret nz			; $69f3
	ld (hl),INTERACID_BOOK_OF_SEALS_PODIUM		; $69f4
	inc l			; $69f6
	ld (hl),e ; [subid]
	ld l,Interaction.yh		; $69f8
	ld a,(bc)		; $69fa
	ldi (hl),a		; $69fb
	inc l			; $69fc
	inc bc			; $69fd
	ld a,(bc)		; $69fe
	ld (hl),a		; $69ff
	inc bc			; $6a00
	dec e			; $6a01
	jr nz,@next	; $6a02
	ret			; $6a04


; List of tiles to become solid for each book
@bookPathLists:
	.db @subid0 - CADDR
	.db @subid1 - CADDR
	.db @subid2 - CADDR
	.db @subid3 - CADDR
	.db @subid4 - CADDR
	.db @subid5 - CADDR
@subid0:
	.db $99 $9a $9b $8b $7b $7c
	.db $00
@subid1:
	.db $6d $5d $5c $4c $3c $3d
	.db $00
@subid2:
	.db $2c $2b $1b $1a $19
	.db $00
@subid3:
	.db $28 $27 $26 $25 $15 $14 $13
	.db $00
@subid4:
	.db $22 $23 $33 $43 $42 $41 $51 $61
	.db $00
@subid5:
	.db $72 $82 $83 $84 $74 $75 $65 $66 $67
	.db $00

@podiumPositions:
	.db $84 $18
	.db $14 $18
	.db $14 $78
	.db $14 $d8
	.db $84 $d8


; ==============================================================================
; INTERACID_FINAL_DUNGEON_ENERGY
; ==============================================================================
interactionCodeb5:
	ld e,Interaction.state		; $6a44
	ld a,(de)		; $6a46
	rst_jumpTable			; $6a47
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6a4c
	ld (de),a ; [state]

	call getThisRoomFlags		; $6a4f
	bit 6,a			; $6a52
	jp nz,interactionDelete		; $6a54

	set 6,(hl) ; [room flags]
	call setDeathRespawnPoint		; $6a59
	xor a			; $6a5c
	ld (wTextIsActive),a		; $6a5d

	ld a,120		; $6a60
	ld e,Interaction.counter1		; $6a62
	ld (de),a		; $6a64

	ld bc,$5878		; $6a65
	jp createEnergySwirlGoingIn		; $6a68

@state1:
	ld e,Interaction.state2		; $6a6b
	ld a,(de)		; $6a6d
	rst_jumpTable			; $6a6e
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1		; $6a75
	ret nz			; $6a78

	call interactionIncState2		; $6a79

	ld l,Interaction.counter1		; $6a7c
	ld (hl),$08		; $6a7e

	ld hl,wGenericCutscene.cbb3		; $6a80
	ld (hl),$00		; $6a83
	ld hl,wGenericCutscene.cbba		; $6a85
	ld (hl),$ff		; $6a88
	ret			; $6a8a

@substate1:
	ld e,Interaction.counter1		; $6a8b
	ld a,(de)		; $6a8d
	or a			; $6a8e
	jr nz,++		; $6a8f
	call setLinkForceStateToState08		; $6a91
	ld hl,w1Link.visible		; $6a94
	set 7,(hl)		; $6a97
++
	call interactionDecCounter1		; $6a99
	ld hl,wGenericCutscene.cbb3		; $6a9c
	ld b,$01		; $6a9f
	call flashScreen		; $6aa1
	ret z			; $6aa4
	call interactionIncState2		; $6aa5
	ld a,$03		; $6aa8
	jp fadeinFromWhiteWithDelay		; $6aaa

@substate2:
	ld a,(wPaletteThread_mode)		; $6aad
	or a			; $6ab0
	ret nz			; $6ab1
	xor a			; $6ab2
	ld (wDisabledObjects),a		; $6ab3
	ld (wMenuDisabled),a		; $6ab6
	ld (wUseSimulatedInput),a		; $6ab9
	jp interactionDelete		; $6abc


; ==============================================================================
; INTERACID_VIRE
;
; Variables:
;   relatedObj1: Zelda object (for vire subid 2 only)
;   var38: If nonzero, the script is run (subids 0 and 1 only)
; ==============================================================================
interactionCodeb8:
	ld e,Interaction.subid		; $6abf
	ld a,(de)		; $6ac1
	rst_jumpTable			; $6ac2
	.dw _vire_subid0
	.dw _vire_subid1
	.dw _vire_subid2


; Vire at black tower entrance
_vire_subid0:
	call checkInteractionState		; $6ac9
	jr z,@state0	; $6acc

@state1:
	ld e,Interaction.var38		; $6ace
	ld a,(de)		; $6ad0
	or a			; $6ad1
	jr nz,@runScript	; $6ad2

	call _vire_disableObjectsIfLinkIsReady		; $6ad4
	jr nc,@animate	; $6ad7
	xor a			; $6ad9
	ld (w1Link.direction),a		; $6ada

@runScript:
	call interactionRunScript		; $6add
	jp c,_vire_deleteAndReturnControl		; $6ae0
@animate:
	jp interactionAnimate		; $6ae3

@state0:
	call getThisRoomFlags		; $6ae6
	bit 6,(hl)		; $6ae9
	jp nz,interactionDelete		; $6aeb

	ld a,MUS_GREAT_MOBLIN		; $6aee
	call playSound		; $6af0
	ld hl,vireSubid0Script		; $6af3

_vire_setScript:
	call interactionSetScript		; $6af6
	call interactionInitGraphics		; $6af9
	call interactionIncState		; $6afc

	ld l,Interaction.speed		; $6aff
	ld (hl),SPEED_200		; $6b01

	xor a			; $6b03
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $6b04
	jp objectSetVisiblec2		; $6b07


; Vire in donkey kong minigame (lower level)
_vire_subid1:
	ld e,Interaction.state		; $6b0a
	ld a,(de)		; $6b0c
	rst_jumpTable			; $6b0d
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wGroup5Flags+(<ROOM_AGES_5e7))		; $6b14
	bit 6,a			; $6b17
	jp nz,interactionDelete		; $6b19

	call getThisRoomFlags		; $6b1c
	bit 6,(hl)		; $6b1f
	ld hl,vireSubid1Script		; $6b21
	jr z,_vire_setScript	; $6b24

	ld a,(wActiveMusic)		; $6b26
	or a			; $6b29
	ld a,MUS_MINIBOSS		; $6b2a
	call nz,playSound		; $6b2c
	jr @gotoState2		; $6b2f

@state1:
	ld e,Interaction.var38		; $6b31
	ld a,(de)		; $6b33
	or a			; $6b34
	jr nz,@runScript	; $6b35

	ld a,(w1Link.yh)		; $6b37
	cp $9b			; $6b3a
	jp nc,interactionAnimate		; $6b3c

	call _vire_disableObjectsIfLinkIsReady		; $6b3f
	jp nc,interactionAnimate		; $6b42

@runScript:
	call interactionRunScript		; $6b45
	jp nc,interactionAnimate		; $6b48
	call objectSetInvisible		; $6b4b
	call _vire_returnControl		; $6b4e

@gotoState2:
	ld h,d			; $6b51
	ld l,Interaction.state		; $6b52
	ld (hl),$02		; $6b54
	ld l,Interaction.counter1		; $6b56
	ld (hl),$08		; $6b58
	ret			; $6b5a

@state2:
	call interactionDecCounter1		; $6b5b
	ret nz			; $6b5e

	ld hl,w1Link.yh		; $6b5f
	ldi a,(hl)		; $6b62
	cp $10			; $6b63
	jr nc,@spawnFireball	; $6b65

	inc l			; $6b67
	ld a,(hl) ; [w1Link.xh]
	cp $a0			; $6b69
	jr nc,_vire_setRandomCounter1	; $6b6b

@spawnFireball:
	call getFreePartSlot		; $6b6d
	jr nz,_vire_setRandomCounter1	; $6b70
	ld (hl),PARTID_2c		; $6b72
	inc l			; $6b74
	inc (hl) ; [subid] = 1

_vire_setRandomCounter1:
	call getRandomNumber_noPreserveVars		; $6b76
	and $03			; $6b79
	ld hl,@counter1Vals		; $6b7b
	rst_addAToHl			; $6b7e
	ld e,Interaction.counter1		; $6b7f
	ld a,(hl)		; $6b81
	ld (de),a		; $6b82
	ret			; $6b83

@counter1Vals:
	.db 120, 160, 200, 240


; Vire in donkey kong minigame (upper level)
_vire_subid2:
	ld e,Interaction.state		; $6b88
	ld a,(de)		; $6b8a
	rst_jumpTable			; $6b8b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call getThisRoomFlags		; $6b94
	bit 6,(hl)		; $6b97
	jp nz,interactionDelete		; $6b99

	ldbc INTERACID_ZELDA, $03		; $6b9c
	call objectCreateInteraction		; $6b9f
	ret nz			; $6ba2

	ld e,Interaction.relatedObj1		; $6ba3
	ld a,Interaction.start		; $6ba5
	ld (de),a		; $6ba7
	inc e			; $6ba8
	ld a,h			; $6ba9
	ld (de),a		; $6baa

	ld hl,vireSubid2Script		; $6bab
	call _vire_setScript		; $6bae
	ld l,Interaction.counter1		; $6bb1
	ld (hl),$08		; $6bb3
	ret			; $6bb5

@state1:
	ld hl,w1Link.yh		; $6bb6
	ldi a,(hl)		; $6bb9
	cp $40			; $6bba
	jr nc,@gameStillGoing	; $6bbc
	inc l			; $6bbe
	ld a,(hl) ; [w1Link.xh]
	cp $58			; $6bc0
	jr nc,@gameStillGoing	; $6bc2

	call _vire_disableObjectsIfLinkIsReady		; $6bc4
	jr nc,@gameStillGoing	; $6bc7

	; Link reached the top
	ld a,DISABLE_LINK		; $6bc9
	ld (wDisabledObjects),a		; $6bcb
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $6bce
	ld a,DIR_LEFT		; $6bd1
	ld (w1Link.direction),a		; $6bd3
	jp interactionIncState		; $6bd6

@gameStillGoing:
	ld h,d			; $6bd9
	ld l,Interaction.counter2		; $6bda
	ld a,(hl)		; $6bdc
	or a			; $6bdd
	jr z,++	; $6bde
	dec (hl) ; [counter2]
	jr nz,++	; $6be1

	ld e,Interaction.direction		; $6be3
	xor a			; $6be5
	ld (de),a		; $6be6
	call interactionSetAnimation		; $6be7
++
	call interactionDecCounter1		; $6bea
	jr nz,@animate	; $6bed

	call getFreePartSlot		; $6bef
	jr nz,++		; $6bf2
	ld (hl),PARTID_2c		; $6bf4
	call objectCopyPosition		; $6bf6
	ld e,Interaction.direction		; $6bf9
	ld a,$01		; $6bfb
	ld (de),a		; $6bfd
	call interactionSetAnimation		; $6bfe
	ld e,Interaction.counter2		; $6c01
	ld a,$18		; $6c03
	ld (de),a		; $6c05
++
	call _vire_setRandomCounter1		; $6c06
@animate:
	jp interactionAnimate		; $6c09

; Fight ended
@state2:
	call interactionIncState		; $6c0c
	ld l,Interaction.counter1		; $6c0f
	xor a			; $6c11
	ldi (hl),a		; $6c12
	ld (hl),a ; [counter2]
	ld e,Interaction.direction		; $6c14
	ld a,(de)		; $6c16
	dec a			; $6c17
	call z,interactionSetAnimation		; $6c18
	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $6c1b
	ld (wDisabledObjects),a		; $6c1d
	ld a,SNDCTRL_STOPMUSIC		; $6c20
	call playSound		; $6c22

@state3:
	call interactionRunScript		; $6c25
	jr nc,@animate	; $6c28

	; Increment Zelda's state
	ld a,Object.state2		; $6c2a
	call objectGetRelatedObject1Var		; $6c2c
	inc (hl)		; $6c2f

	jp interactionDelete		; $6c30

;;
; @param[out]	cflag	c if successfully disabled objects
; @addr{6c33}
_vire_disableObjectsIfLinkIsReady:
	ld a,(wLinkInAir)		; $6c33
	or a			; $6c36
	ret nz			; $6c37
	call checkLinkVulnerable		; $6c38
	ret nc			; $6c3b

	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $6c3c
	ld (wDisabledObjects),a		; $6c3e
	ld (wMenuDisabled),a		; $6c41
	ld e,Interaction.var38		; $6c44
	ld (de),a		; $6c46

	call clearAllParentItems		; $6c47
	call dropLinkHeldItem		; $6c4a
	scf			; $6c4d
	ret			; $6c4e

;;
; @addr{6c4f}
_vire_deleteAndReturnControl:
	call interactionDelete		; $6c4f

;;
; @addr{6c52}
_vire_returnControl:
	xor a			; $6c52
	ld (wDisabledObjects),a		; $6c53
	ld (wMenuDisabled),a		; $6c56
	ret			; $6c59


; ==============================================================================
; INTERACID_HORON_DOG
;
; Variables:
;   subid: Used as a sort of "state" variable?
;   var36: Target x-position
;   var37: ?
; ==============================================================================
interactionCodeb9:
	ld e,Interaction.state		; $6c5a
	ld a,(de)		; $6c5c
	rst_jumpTable			; $6c5d
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6c62
	ld (de),a		; $6c64
	call interactionInitGraphics		; $6c65
	call objectSetVisiblec2		; $6c68
	call objectSetInvisible		; $6c6b

	ld e,Interaction.subid		; $6c6e
	ld a,(de)		; $6c70
	ld b,a			; $6c71
	ld hl,@counter1Vals		; $6c72
	rst_addAToHl			; $6c75
	ld a,(hl)		; $6c76
	ld e,Interaction.counter1		; $6c77
	ld (de),a		; $6c79

	ld a,b			; $6c7a
	ld hl,@positions		; $6c7b
	rst_addDoubleIndex			; $6c7e
	ld b,(hl)		; $6c7f
	inc hl			; $6c80
	ld a,(hl)		; $6c81
	ld c,a			; $6c82
	ld e,Interaction.var36		; $6c83
	ld (de),a		; $6c85

	call objectGetRelativeAngle		; $6c86
	ld e,Interaction.angle		; $6c89
	ld (de),a		; $6c8b
	ld e,Interaction.speed		; $6c8c
	ld a,SPEED_100		; $6c8e
	ld (de),a		; $6c90

	ld e,Interaction.subid		; $6c91
	ld a,(de)		; $6c93
	rst_jumpTable			; $6c94
	.dw @subid0Init
	.dw @jump
	.dw @jump
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	ld e,Interaction.angle		; $6ca5
	ld a,$04		; $6ca7
	ld (de),a		; $6ca9
	ld h,d			; $6caa
	ld l,Interaction.counter1		; $6cab
	ld (hl),$e0		; $6cad
	inc hl			; $6caf
	ld (hl),$01 ; [counter2]

@jump:
	ld e,Interaction.subid		; $6cb2
	ld a,(de)		; $6cb4
	ld hl,@speedZVals		; $6cb5
	rst_addDoubleIndex			; $6cb8
	ld c,(hl)		; $6cb9
	inc hl			; $6cba
	ld b,(hl)		; $6cbb
	jp objectSetSpeedZ		; $6cbc

@subid3Init:
	call @jump		; $6cbf
	ld e,Interaction.speed		; $6cc2
	ld a,SPEED_180		; $6cc4
	ld (de),a		; $6cc6
	jp @setZPosition		; $6cc7

@subid4Init:
@subid5Init:
@subid6Init:
	call @jump		; $6cca
	ld e,Interaction.speed		; $6ccd
	ld a,SPEED_40		; $6ccf
	ld (de),a		; $6cd1

@setZPosition:
	ld e,Interaction.subid		; $6cd2
	ld a,(de)		; $6cd4
	sub $03			; $6cd5
	ld hl,@zPositions		; $6cd7
	rst_addDoubleIndex			; $6cda
	ld e,Interaction.zh		; $6cdb
	ldi a,(hl)		; $6cdd
	ld (de),a		; $6cde
	dec e			; $6cdf
	ld a,(hl)		; $6ce0
	ld (de),a		; $6ce1
	ret			; $6ce2

@subid7Init:
	ld hl,horonDogScript		; $6ce3
	jp interactionSetScript		; $6ce6


@counter1Vals:
	.db 230, 90, 120, 190, 200, 210, 220, 250

@positions:
	.db $58 $38
	.db $48 $40
	.db $4c $60
	.db $48 $78
	.db $1a $2c
	.db $10 $38
	.db $0a $44
	.db $18 $a0

@speedZVals:
	.dw $ff40
	.dw $fee0
	.dw $ff00
	.dw $ffc0
	.dw $0036
	.dw $0036
	.dw $0036

@zPositions:
	.dw $ffe8 ; 3 == [subid]
	.dw $ffc8 ; 4
	.dw $ffc8 ; 5
	.dw $ffc8 ; 6

@state1:
	ld e,Interaction.state2		; $6d17
	ld a,(de)		; $6d19
	rst_jumpTable			; $6d1a
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1		; $6d21
	ret nz			; $6d24
	call objectSetVisible		; $6d25
	jp interactionIncState2		; $6d28


@substate1:
	call interactionAnimate		; $6d2b
	call objectApplySpeed		; $6d2e

	ld h,d			; $6d31
	ld l,Interaction.xh		; $6d32
	ld a,(hl)		; $6d34
	ld l,Interaction.var36		; $6d35
	cp (hl)			; $6d37
	jr nz,@reachedTargetXPosition	; $6d38

	call interactionIncState2		; $6d3a
	ld l,Interaction.zh		; $6d3d
	ld (hl),$00		; $6d3f
	ld l,Interaction.subid		; $6d41
	ld a,(hl)		; $6d43
	add a			; $6d44
	inc a			; $6d45
	jp interactionSetAnimation		; $6d46

@reachedTargetXPosition:
	ld e,Interaction.subid		; $6d49
	ld a,(de)		; $6d4b
	rst_jumpTable			; $6d4c
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

@subid0:
@subid1:
@subid2:
	ld c,$20		; $6d5d
	call objectUpdateSpeedZ_paramC		; $6d5f
	ret nz			; $6d62
	ld e,Interaction.subid		; $6d63
	jp @jump		; $6d65

@subid3:
	ld c,$10		; $6d68

@label_0b_293:
	ld e,Interaction.var37		; $6d6a
	ld a,(de)		; $6d6c
	or a			; $6d6d
	ret nz			; $6d6e
	call objectUpdateSpeedZ_paramC		; $6d6f
	ret nz			; $6d72

	ld h,d			; $6d73
	ld l,Interaction.var37		; $6d74
	inc (hl)		; $6d76

@subid7:
	ret			; $6d77

@subid4:
@subid5:
@subid6:
	ld c,$01		; $6d78
	jr @label_0b_293		; $6d7a


@substate2:
	ld e,Interaction.subid		; $6d7c
	ld a,(de)		; $6d7e
	or a			; $6d7f
	jr nz,@substate2_subidNot0	; $6d80

@substate2_subid0:
	ld b,a			; $6d82
	ld h,d			; $6d83
	ld l,Interaction.counter1		; $6d84
	call decHlRef16WithCap		; $6d86
	jr nz,@animate	; $6d89
	ld hl,wTmpcfc0.genericCutscene.cfdf		; $6d8b
	ld (hl),$01		; $6d8e
	ret			; $6d90

@substate2_subidNot0:
	cp $07			; $6d91
	jr nz,@animate	; $6d93

	call interactionRunScript		; $6d95
	ld e,Interaction.counter2		; $6d98
	ld a,(de)		; $6d9a
	or a			; $6d9b
	ret z			; $6d9c

@animate:
	jp interactionAnimate		; $6d9d


; ==============================================================================
; INTERACID_CHILD_JABU
; ==============================================================================
interactionCodeba:
	call checkInteractionState		; $6da0
	jr nz,@state0	; $6da3

@state1:
	call interactionInitGraphics		; $6da5
	call interactionSetAlwaysUpdateBit		; $6da8
	call interactionIncState		; $6dab
	ld bc,$0e06		; $6dae
	call objectSetCollideRadii		; $6db1
	ld hl,childJabuScript		; $6db4
	call interactionSetScript		; $6db7
	jp objectSetVisible82		; $6dba

@state0:
	call interactionAnimateAsNpc		; $6dbd
	jp interactionRunScript		; $6dc0


; ==============================================================================
; INTERACID_HUMAN_VERAN
; ==============================================================================
interactionCodebb:
	ld e,Interaction.state		; $6dc3
	ld a,(de)		; $6dc5
	rst_jumpTable			; $6dc6
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState	; $6dcb
	call interactionInitGraphics		; $6dce
	ld hl,humanVeranScript		; $6dd1
	call interactionSetScript		; $6dd4
	jp objectSetVisible82		; $6dd7

@state1:
	ld a,Object.visible		; $6dda
	call objectGetRelatedObject1Var		; $6ddc
	ld a,(hl)		; $6ddf
	xor $80			; $6de0
	ld e,l			; $6de2
	ld (de),a		; $6de3
	call interactionRunScript		; $6de4
	ret nc			; $6de7
	jp interactionDelete		; $6de8


; ==============================================================================
; INTERACID_TWINROVA_3
;
; Variables:
;   var3c: A target position index for the data in var3e/var3f.
;   var3d: # of values in the position list (var3c must stop here).
;   var3e/var3f: A pointer to a list of target positions.
; ==============================================================================
interactionCodebc:
	ld e,Interaction.state		; $6deb
	ld a,(de)		; $6ded
	rst_jumpTable			; $6dee
	.dw @state0
	.dw @state1

@state0:
	ld e,Interaction.subid		; $6df3
	ld a,(de)		; $6df5
	rst_jumpTable			; $6df6
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3

@initSubid0:
@initSubid1:
	call @commonInit		; $6dff
	ld l,Interaction.zh		; $6e02
	ld (hl),$fb		; $6e04
	ld l,Interaction.subid		; $6e06
	ld a,(hl)		; $6e08
	call @readPositionTable		; $6e09
	jp @state1		; $6e0c

@initSubid2:
	call @commonInit		; $6e0f
	ld l,Interaction.zh		; $6e12
	ld (hl),$f0		; $6e14
	ld a,$02		; $6e16
	call @readPositionTable		; $6e18
	ld a,$04		; $6e1b
	call interactionSetAnimation		; $6e1d
	jp @state1		; $6e20

@initSubid3:
	call @commonInit		; $6e23
	ld a,$02		; $6e26
	call @readPositionTable		; $6e28
	ld a,$01		; $6e2b
	call interactionSetAnimation		; $6e2d
	jp @state1		; $6e30

@commonInit:
	call interactionInitGraphics		; $6e33
	call objectSetVisiblec0		; $6e36
	call interactionSetAlwaysUpdateBit		; $6e39
	call @loadOamFlags		; $6e3c
	call interactionIncState		; $6e3f
	ld l,Interaction.speed		; $6e42
	ld (hl),SPEED_200		; $6e44
	ld l,Interaction.zh		; $6e46
	ld (hl),$f8		; $6e48
	ld l,Interaction.direction		; $6e4a
	ld (hl),$ff		; $6e4c
	ret			; $6e4e


@state1:
	ld e,Interaction.subid		; $6e4f
	ld a,(de)		; $6e51
	rst_jumpTable			; $6e52
	.dw @subid0State1
	.dw @subid0State1
	.dw @subid2State1
	.dw @subid2State1


@subid0State1:
	ld e,Interaction.state2		; $6e5b
	ld a,(de)		; $6e5d
	rst_jumpTable			; $6e5e
	.dw @subid0Substate0
	.dw @subid0Substate1
	.dw @subid0Substate2
	.dw @subid0Substate3
	.dw @subid0Substate4

@subid0Substate0:
	call @moveTowardTargetPosition		; $6e69
	call @updateAnimationIndex		; $6e6c

	call @checkReachedTargetPosition		; $6e6f
	call c,@nextTargetPosition		; $6e72
	jp nc,@animate		; $6e75

	; Exhausted position list
	ld h,d			; $6e78
	ld l,Interaction.state2		; $6e79
	ld (hl),$01		; $6e7b
	ld l,Interaction.counter2		; $6e7d
	ld (hl),40		; $6e7f

	ld l,Interaction.subid		; $6e81
	ld a,(hl)		; $6e83
	or a			; $6e84
	jr nz,+			; $6e85

	ld a,$00		; $6e87
	jr +++			; $6e89
+
	cp $01			; $6e8b
	jr nz,++		; $6e8d

	ld a,$01		; $6e8f
	jr +++			; $6e91
++
	ld a,$02		; $6e93
+++
	call interactionSetAnimation		; $6e95
	jp @animate		; $6e98

@subid0Substate1:
	call @updateFloating		; $6e9b
	call @animate		; $6e9e
	call interactionDecCounter2		; $6ea1
	ret nz			; $6ea4

	ld l,Interaction.state2		; $6ea5
	inc (hl)		; $6ea7
	ld l,Interaction.counter2		; $6ea8
	ld (hl),40		; $6eaa

@func_6eac:
	ld hl,wTmpcfc0.genericCutscene.cfc6		; $6eac
	inc (hl)		; $6eaf
	ld a,(hl)		; $6eb0
	cp $02			; $6eb1
	ret nz			; $6eb3
	ld (hl),$00		; $6eb4
	ld hl,wTmpcfc0.genericCutscene.state		; $6eb6
	set 0,(hl)		; $6eb9
	ret			; $6ebb

@subid0Substate2:
	call @updateFloating		; $6ebc
	call @animate		; $6ebf
	ld a,(wTmpcfc0.genericCutscene.state)		; $6ec2
	bit 0,a			; $6ec5
	ret nz			; $6ec7
	call interactionDecCounter2		; $6ec8
	ret nz			; $6ecb

	ld l,Interaction.state2		; $6ecc
	inc (hl)		; $6ece
	ld l,Interaction.direction		; $6ecf
	ld (hl),$ff		; $6ed1
	ld l,Interaction.subid		; $6ed3
	ld a,(hl)		; $6ed5
	add $04			; $6ed6
	jp @readPositionTable		; $6ed8

@subid0Substate3:
	call @moveTowardTargetPosition		; $6edb
	call @checkReachedTargetPosition		; $6ede
	call c,@nextTargetPosition		; $6ee1
	jr c,@@looped	; $6ee4

	call @moveTowardTargetPosition		; $6ee6
	ld e,Interaction.subid		; $6ee9
	ld a,(de)		; $6eeb
	cp $02			; $6eec
	call nz,@updateAnimationIndex		; $6eee
	call @checkReachedTargetPosition		; $6ef1
	call c,@nextTargetPosition		; $6ef4
	jr nc,@animate	; $6ef7

@@looped:
	ld e,Interaction.subid		; $6ef9
	ld a,(de)		; $6efb
	cp $02			; $6efc
	jr c,++			; $6efe

	call @func_6eac		; $6f00
	jp interactionDelete		; $6f03
++
	call @func_6eac		; $6f06
	ld h,d			; $6f09
	ld l,Interaction.state2		; $6f0a
	inc (hl)		; $6f0c
	ret			; $6f0d

@subid0Substate4:
	jp @animate		; $6f0e


@subid2State1:
	call checkInteractionState2		; $6f11
	jr nz,++		; $6f14
	call @updateFloating		; $6f16
	call @animate		; $6f19
	ld a,(wTmpcfc0.genericCutscene.state)		; $6f1c
	bit 0,a			; $6f1f
	ret z			; $6f21
	call interactionIncState2		; $6f22
	ld l,Interaction.direction		; $6f25
	ld (hl),$ff		; $6f27
	ret			; $6f29
++
	jr @subid0Substate3		; $6f2a

@animate:
	jp interactionAnimate		; $6f2c

@loadOamFlags:
	ld e,Interaction.subid		; $6f2f
	ld a,(de)		; $6f31
	ld hl,@oamFlags		; $6f32
	rst_addAToHl			; $6f35
	ld a,(hl)		; $6f36
	ld e,Interaction.oamFlags		; $6f37
	ld (de),a		; $6f39
	ret			; $6f3a

@oamFlags:
	.db $02 $01 $00 $01

;;
; Updates z values to "float" up and down?
; @addr{6f3f}
@updateFloating:
	ld a,(wFrameCounter)		; $6f3f
	and $07			; $6f42
	ret nz			; $6f44
	ld a,(wFrameCounter)		; $6f45
	and $38			; $6f48
	swap a			; $6f4a
	rlca			; $6f4c
	ld hl,@zValues		; $6f4d
	rst_addAToHl			; $6f50
	ld e,Interaction.zh		; $6f51
	ld a,(de)		; $6f53
	add (hl)		; $6f54
	ld (de),a		; $6f55
	ret			; $6f56

@zValues:
	.db $ff $fe $ff $00 $01 $02 $01 $00

;;
; @addr{6f5f}
@moveTowardTargetPosition:
	ld h,d			; $6f5f
	ld l,Interaction.var3c		; $6f60
	ld a,(hl)		; $6f62
	add a			; $6f63
	ld b,a			; $6f64

	ld e,Interaction.var3f		; $6f65
	ld a,(de)		; $6f67
	ld l,a			; $6f68
	ld e,Interaction.var3e		; $6f69
	ld a,(de)		; $6f6b
	ld h,a			; $6f6c

	ld a,b			; $6f6d
	rst_addAToHl			; $6f6e
	ld b,(hl)		; $6f6f
	inc hl			; $6f70
	ld c,(hl)		; $6f71
	call objectGetRelativeAngle		; $6f72
	ld e,Interaction.angle		; $6f75
	ld (de),a		; $6f77
	jp objectApplySpeed		; $6f78

;;
; @param	bc	Pointer to position data (Y, X values)
; @param[out]	cflag	c if reached target position
; @addr{6f7b}
@checkReachedTargetPosition:
	call @getCurrentPositionPointer		; $6f7b
	ld l,Interaction.yh		; $6f7e
	ld a,(bc)		; $6f80
	sub (hl)		; $6f81
	add $01			; $6f82
	cp $05			; $6f84
	ret nc			; $6f86
	inc bc			; $6f87
	ld l,Interaction.xh		; $6f88
	ld a,(bc)		; $6f8a
	sub (hl)		; $6f8b
	add $01			; $6f8c
	cp $05			; $6f8e
	ret			; $6f90

;;
; @addr{6f91}
@updateAnimationIndex:
	ld h,d			; $6f91
	ld l,Interaction.angle		; $6f92
	ld a,(hl)		; $6f94
	swap a			; $6f95
	and $01			; $6f97
	xor $01			; $6f99
	ld l,Interaction.direction		; $6f9b
	cp (hl)			; $6f9d
	ret z			; $6f9e
	ld (hl),a		; $6f9f
	jp interactionSetAnimation		; $6fa0

;;
; @param[out]	cflag	c if we've exhausted the position list and we're looping
; @addr{6fa3}
@nextTargetPosition:
	call @@setPositionToPointerData		; $6fa3
	ld h,d			; $6fa6
	ld l,Interaction.var3d		; $6fa7
	ld a,(hl)		; $6fa9
	ld l,Interaction.var3c		; $6faa
	inc (hl)		; $6fac
	cp (hl)			; $6fad
	ret nc			; $6fae
	ld (hl),$00		; $6faf
	scf			; $6fb1
	ret			; $6fb2

;;
; @addr{6fb3}
@@setPositionToPointerData:
	call @getCurrentPositionPointer		; $6fb3
	ld l,Interaction.y		; $6fb6
	xor a			; $6fb8
	ldi (hl),a		; $6fb9
	ld a,(bc)		; $6fba
	ld (hl),a		; $6fbb
	inc bc			; $6fbc
	ld l,Interaction.x		; $6fbd
	xor a			; $6fbf
	ldi (hl),a		; $6fc0
	ld a,(bc)		; $6fc1
	ld (hl),a		; $6fc2
	ret			; $6fc3

;;
; @param[out]	bc	Pointer to position data
; @addr{6fc4}
@getCurrentPositionPointer:
	ld h,d			; $6fc4
	ld l,Interaction.var3c		; $6fc5
	ld a,(hl)		; $6fc7
	add a			; $6fc8
	push af			; $6fc9
	ld e,Interaction.var3f		; $6fca
	ld a,(de)		; $6fcc
	ld c,a			; $6fcd
	ld e,Interaction.var3e		; $6fce
	ld a,(de)		; $6fd0
	ld b,a			; $6fd1
	pop af			; $6fd2
	call addAToBc		; $6fd3
	ret			; $6fd6

;;
; Read values for var3f, var3e, var3d based on parameter
;
; @param	a	Index for table
; @addr{6fd7}
@readPositionTable:
	add a			; $6fd7
	ld hl,@table		; $6fd8
	rst_addDoubleIndex			; $6fdb
	ld e,Interaction.var3f		; $6fdc
	ldi a,(hl)		; $6fde
	ld (de),a		; $6fdf
	ld e,Interaction.var3e		; $6fe0
	ldi a,(hl)		; $6fe2
	ld (de),a		; $6fe3
	ld e,Interaction.var3d		; $6fe4
	ldi a,(hl)		; $6fe6
	ld (de),a		; $6fe7
	ret			; $6fe8

@table:
	dwbb @positions0, $0b, $00
	dwbb @positions1, $0b, $00
	dwbb @positions2, $09, $00
	dwbb @positions3, $09, $00
	dwbb @positions4, $04, $00
	dwbb @positions5, $04, $00

@positions2:
	.db $54 $18
	.db $58 $0e
	.db $60 $08
	.db $68 $0c
	.db $72 $18
	.db $78 $28
	.db $80 $48
	.db $88 $68
	.db $90 $80
	.db $a0 $a0

@positions3:
	.db $54 $88
	.db $58 $92
	.db $60 $98
	.db $68 $94
	.db $72 $88
	.db $78 $78
	.db $80 $58
	.db $88 $38
	.db $90 $20
	.db $a0 $00

@positions0:
	.db $01 $40
	.db $29 $18
	.db $39 $10
	.db $45 $0c
	.db $51 $10
	.db $61 $18
	.db $71 $28
	.db $77 $38
	.db $79 $48
	.db $77 $58
	.db $71 $68
	.db $61 $78

@positions1:
	.db $01 $60
	.db $29 $88
	.db $39 $90
	.db $45 $94
	.db $51 $90
	.db $61 $88
	.db $71 $78
	.db $77 $68
	.db $79 $58
	.db $77 $48
	.db $71 $38
	.db $61 $28

@positions4:
	.db $5d $90
	.db $4d $98
	.db $39 $90
	.db $2d $78
	.db $29 $60

@positions5:
	.db $5d $10
	.db $4d $08
	.db $39 $10
	.db $2d $28
	.db $29 $40

; ==============================================================================
; INTERACID_PUSHBLOCK_SYNCHRONIZER
; ==============================================================================
interactionCodebd:
	ld e,Interaction.state		; $706d
	ld a,(de)		; $706f
	rst_jumpTable			; $7070
	.dw interactionIncState
	.dw @state1
	.dw @state2

@state1:
	; Wait for a block to be pushed
	ld a,(w1ReservedInteraction1.enabled)		; $7077
	or a			; $707a
	ret z			; $707b

	ld a,(w1ReservedInteraction1.var31) ; Tile index of block being pushed
	ldh (<hFF8B),a	; $707f
	call findTileInRoom		; $7081
	jr nz,@incState	; $7084

	; Found another tile of the same type; push it, then search for more tiles of that type
	call @pushBlockAt		; $7086
--
	ldh a,(<hFF8B)	; $7089
	call backwardsSearch		; $708b
	jr nz,@incState	; $708e
	call @pushBlockAt		; $7090
	jr --		; $7093

@incState:
	jp interactionIncState		; $7095

@state2:
	ld e,Interaction.state		; $7098
	ld a,$01		; $709a
	ld (de),a		; $709c
	ret			; $709d

;;
; @param	hl	Position of block to push in wRoomLayuut
; @param	hFF8B	Index of tile to push
; @addr{709e}
@pushBlockAt:
	push hl			; $709e
	ldh a,(<hFF8B)	; $709f
	cp TILEINDEX_SOMARIA_BLOCK			; $70a1
	jr z,@return	; $70a3

	ld a,l			; $70a5
	ldh (<hFF8D),a	; $70a6
	ld h,d			; $70a8
	ld l,Interaction.yh		; $70a9
	call setShortPosition		; $70ab

	ld l,Interaction.angle		; $70ae
	ld a,(wBlockPushAngle)		; $70b0
	and $1f			; $70b3
	ld (hl),a		; $70b5

	call interactionCheckAdjacentTileIsSolid		; $70b6
	jr nz,@return	; $70b9
	call getFreeInteractionSlot		; $70bb
	jr nz,@return	; $70be

	ld (hl),INTERACID_PUSHBLOCK		; $70c0
	ld l,Interaction.angle		; $70c2
	ld e,l			; $70c4
	ld a,(de)		; $70c5
	ld (hl),a		; $70c6
	ldbc -$02, $00		; $70c7
	call objectCopyPositionWithOffset		; $70ca

	; [pushblock.var30] = tile position
	ld l,Interaction.var30		; $70cd
	ldh a,(<hFF8D)	; $70cf
	ld (hl),a		; $70d1
@return:
	pop hl			; $70d2
	dec l			; $70d3
	ret			; $70d4


; ==============================================================================
; INTERACID_AMBIS_PALACE_BUTTON
; ==============================================================================
interactionCodebe:
	ld e,Interaction.state		; $70d5
	ld a,(de)		; $70d7
	rst_jumpTable			; $70d8
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags		; $70df
	and ROOMFLAG_80			; $70e2
	jp nz,interactionDelete		; $70e4
	ld a,$02		; $70e7
	call objectSetCollideRadius		; $70e9
	jp interactionIncState		; $70ec

@state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $70ef
	ret nc			; $70f2
	call objectGetTileAtPosition		; $70f3
	ld a,(wActiveTilePos)		; $70f6
	cp l			; $70f9
	ret nz			; $70fa
	ld a,(wLinkInAir)		; $70fb
	or a			; $70fe
	ret nz			; $70ff
	call checkLinkVulnerable		; $7100
	ret nc			; $7103

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $7104
	ld (wDisabledObjects),a		; $7106
	ld (wMenuDisabled),a		; $7109
	ld e,Interaction.counter1		; $710c
	ld a,45		; $710e
	ld (de),a		; $7110
	call objectGetTileAtPosition		; $7111
	ld c,l			; $7114
	ld a,$9e		; $7115
	call setTile		; $7117
	ld a,SND_OPENCHEST		; $711a
	call playSound		; $711c
	jp interactionIncState		; $711f

@state2:
	call interactionDecCounter1		; $7122
	ret nz			; $7125
	ld a,CUTSCENE_AMBI_PASSAGE_OPEN		; $7126
	ld (wCutsceneTrigger),a		; $7128
	ld a,(wActiveRoom)		; $712b
	ld (wTmpcbbb),a		; $712e
	ld a,(wActiveTilePos)		; $7131
	ld (wTmpcbbc),a		; $7134
	ld e,Interaction.subid		; $7137
	ld a,(de)		; $7139
	ld (wTmpcbbd),a		; $713a
	call fadeoutToWhite		; $713d
	jp interactionDelete		; $7140


; ==============================================================================
; INTERACID_SYMMETRY_NPC
; ==============================================================================
interactionCodebf:
	ld e,Interaction.state		; $7143
	ld a,(de)		; $7145
	rst_jumpTable			; $7146
	.dw @state0
	.dw @runScriptAndAnimate
	.dw @state2

@state0:
	call interactionInitGraphics		; $714d
	call objectSetVisible82		; $7150
	call interactionIncState		; $7153
	ld a,>TX_2d00		; $7156
	call interactionSetHighTextIndex		; $7158
	ld e,Interaction.subid		; $715b
	ld a,(de)		; $715d
	rst_jumpTable			; $715e
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
	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7179
	call checkGlobalFlag		; $717b
	jp z,interactionDelete		; $717e

@loadScript:
	ld e,Interaction.subid		; $7181
	ld a,(de)		; $7183
	ld hl,@scriptTable		; $7184
	rst_addDoubleIndex			; $7187
	ldi a,(hl)		; $7188
	ld h,(hl)		; $7189
	ld l,a			; $718a
	jp interactionSetScript		; $718b

@scriptTable:
	.dw symmetryNpcSubid0And1Script
	.dw symmetryNpcSubid0And1Script
	.dw symmetryNpcSubid2And3Script
	.dw symmetryNpcSubid2And3Script
	.dw symmetryNpcSubid4And5Script
	.dw symmetryNpcSubid4And5Script
	.dw symmetryNpcSubid6And7Script
	.dw symmetryNpcSubid6And7Script
	.dw symmetryNpcSubid8And9Script
	.dw symmetryNpcSubid8And9Script
	.dw symmetryNpcSubidAScript
	.dw symmetryNpcSubidBScript
	.dw symmetryNpcSubidCScript


; For subids 8/9 (sisters in the tuni nut building)...
; Listen for a signal from the tuni nut object; change the script when it's placed.
@state2:
	ld hl,wTmpcfc0.genericCutscene.state		; $71a8
	bit 0,(hl)		; $71ab
	jr z,@runScriptAndAnimate	; $71ad

	ld hl,symmetryNpcSubid8And9Script_afterTuniNutRestored		; $71af
	call interactionSetScript		; $71b2
	ld e,Interaction.state		; $71b5
	ld a,$01		; $71b7
	ld (de),a		; $71b9

@runScriptAndAnimate:
	call interactionRunScript		; $71ba
	jp npcFaceLinkAndAnimate		; $71bd


; ==============================================================================
; INTERACID_c1
;
; Variables:
;   counter1/counter2: 16-bit counter
;   var36: Counter for sparkle spawning
; ==============================================================================
interactionCodec1:
	ld e,Interaction.state		; $71c0
	ld a,(de)		; $71c2
	rst_jumpTable			; $71c3
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $71c8
	ld (de),a		; $71ca
	call interactionInitGraphics		; $71cb
	ld h,d			; $71ce
	ld l,Interaction.counter1		; $71cf
	ld (hl),<390		; $71d1
	inc l			; $71d3
	ld (hl),>390 ; [counter2]
	ld l,Interaction.var36		; $71d6
	ld (hl),$06		; $71d8
	ld l,Interaction.angle		; $71da
	ld (hl),$15		; $71dc
	ld l,Interaction.speed		; $71de
	ld (hl),SPEED_300		; $71e0
	jp objectSetVisible82		; $71e2

@state1:
	ld e,Interaction.state2		; $71e5
	ld a,(de)		; $71e7
	rst_jumpTable			; $71e8
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $71ef
	ld l,Interaction.counter1		; $71f0
	call decHlRef16WithCap		; $71f2
	ret nz			; $71f5
	ld l,Interaction.counter1		; $71f6
	ld (hl),40		; $71f8
	jp interactionIncState2		; $71fa

@substate1:
	call @updateMovementAndSparkles		; $71fd
	jr nz,@ret	; $7200
	ld l,Interaction.animCounter		; $7202
	ld (hl),$01		; $7204
	jp interactionIncState2		; $7206

@substate2:
	call interactionAnimate		; $7209
	call @updateSparkles		; $720c
	call objectApplySpeed		; $720f
	ld e,Interaction.animParameter		; $7212
	ld a,(de)		; $7214
	inc a			; $7215
	jp z,interactionDelete		; $7216
	ret			; $7219

;;
; @param[out]	zflag	z if [counter1] == 0
; @addr{721a}
@updateMovementAndSparkles:
	call @updateSparkles		; $721a
	call objectApplySpeed		; $721d
	jp interactionDecCounter1		; $7220

@ret:
	ret			; $7223

;;
; Unused
; @addr{7224}
@func_7224:
	ld a,(wFrameCounter)		; $7224
	and $01			; $7227
	jp z,objectSetInvisible		; $7229
	jp objectSetVisible		; $722c

;;
; @addr{722f}
@updateSparkles:
	ld h,d			; $722f
	ld l,Interaction.var36		; $7230
	dec (hl)		; $7232
	ret nz			; $7233
	ld (hl),$06 ; [var36]
	ldbc INTERACID_SPARKLE, $09		; $7236
	jp objectCreateInteraction		; $7239


; ==============================================================================
; INTERACID_PIRATE_SHIP
; ==============================================================================
interactionCodec2:
	ld e,Interaction.subid		; $723c
	ld a,(de)		; $723e
	rst_jumpTable			; $723f
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	ld e,Interaction.state		; $7246
	ld a,(de)		; $7248
	rst_jumpTable			; $7249
	.dw @subid0State0
	.dw @subid0State1
	.dw interactionAnimate

@subid0State0:
	call interactionInitGraphics	; $7250
	call objectSetVisible82		; $7253
	ld a,(wPirateShipAngle)		; $7256
	and $03			; $7259
	ld e,Interaction.direction		; $725b
	ld (de),a		; $725d
	call interactionSetAnimation		; $725e
	ld a,$06		; $7261
	call objectSetCollideRadius		; $7263
	jp interactionIncState		; $7266

@subid0State1:
	; Update position based on "wPirateShipRoom" and other variables
	ld hl,wPirateShipRoom		; $7269
	ld a,(wActiveRoom)		; $726c
	cp (hl)			; $726f
	jp nz,interactionDelete		; $7270
	inc l			; $7273
	ldi a,(hl) ; [wPirateShipY]
	ld e,Interaction.yh		; $7275
	ld (de),a		; $7277
	ldi a,(hl) ; [wPirateShipX]
	ld e,Interaction.xh		; $7279
	ld (de),a		; $727b

	ld e,Interaction.direction		; $727c
	ld a,(de)		; $727e
	cp (hl) ; [wPirateShipAngle]			; $727f
	ld a,(hl)		; $7280
	ld (de),a		; $7281
	call nz,interactionSetAnimation		; $7282

	; Check if Link touched the ship
	call objectCheckCollidedWithLink_notDead		; $7285
	jr nc,@animate	; $7288
	call checkLinkVulnerable		; $728a
	jr nc,@animate	; $728d

	ld hl,@warpDest		; $728f
	call setWarpDestVariables		; $7292
	jp interactionIncState		; $7295

@animate:
	jp interactionAnimate		; $7298

@warpDest:
	m_HardcodedWarpA ROOM_AGES_5f8, $01, $56, $03


; Unlinked cutscene of ship leaving
@subid1:
	ld e,Interaction.state		; $72a0
	ld a,(de)		; $72a2
	rst_jumpTable			; $72a3
	.dw @subid1State0
	.dw @subid1And2State1
	.dw @subid1State2

@subid1State0:
	call checkIsLinkedGame		; $72aa
	jp nz,interactionDelete		; $72ad

	ld a,GLOBALFLAG_PIRATES_GONE		; $72b0
	call checkGlobalFlag		; $72b2
	jp z,interactionDelete		; $72b5

	call getThisRoomFlags		; $72b8
	and ROOMFLAG_40			; $72bb
	jp nz,interactionDelete		; $72bd

	call interactionInitGraphics		; $72c0
	ld a,$03		; $72c3
	call interactionSetAnimation		; $72c5
	xor a ; DIR_UP
	ld (w1Link.direction),a		; $72c9

@subid1And2State0Common:
	call objectSetVisible82		; $72cc
	ld e,Interaction.counter1		; $72cf
	ld a,60		; $72d1
	ld (de),a		; $72d3
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $72d4
	ld (wDisabledObjects),a		; $72d6
	ld (wMenuDisabled),a		; $72d9
	jp interactionIncState		; $72dc

@subid1And2State1:
	call interactionAnimate		; $72df
	call interactionDecCounter1		; $72e2
	ret nz			; $72e5
	ld (hl),$80		; $72e6
	ld bc,TX_360c		; $72e8
	call showText		; $72eb
	jp interactionIncState		; $72ee

@subid1State2:
	ld c,ANGLE_LEFT		; $72f1

@moveOffScreen:
	ld b,SPEED_100		; $72f3
	ld e,Interaction.angle		; $72f5
	call objectApplyGivenSpeed		; $72f7
	call interactionAnimate		; $72fa
	call interactionDecCounter1		; $72fd
	ret nz			; $7300

	call getThisRoomFlags		; $7301
	set ROOMFLAG_BIT_40,(hl)		; $7304
	xor a			; $7306
	ld (wDisabledObjects),a		; $7307
	ld (wMenuDisabled),a		; $730a
	jp interactionDelete		; $730d


; Linked cutscene of ship leaving
@subid2:
	ld e,Interaction.state		; $7310
	ld a,(de)		; $7312
	rst_jumpTable			; $7313
	.dw @subid2State0
	.dw @subid1And2State1
	.dw @subid2State2

@subid2State0:
	call checkIsLinkedGame		; $731a
	jp z,interactionDelete		; $731d

	ld a,GLOBALFLAG_PIRATES_GONE		; $7320
	call checkGlobalFlag		; $7322
	jp z,interactionDelete		; $7325

	call getThisRoomFlags		; $7328
	and ROOMFLAG_40			; $732b
	jp nz,interactionDelete		; $732d

	call interactionInitGraphics		; $7330
	xor a			; $7333
	call interactionSetAnimation		; $7334
	ld a,$01		; $7337
	ld (w1Link.direction),a		; $7339
	jp @subid1And2State0Common		; $733c

@subid2State2:
	ld c,ANGLE_UP		; $733f
	jr @moveOffScreen		; $7341


; ==============================================================================
; INTERACID_PIRATE_CAPTAIN
; ==============================================================================
interactionCodec3:
	call checkInteractionState		; $7343
	jr z,@state0	; $7346

@state1:
	call objectPreventLinkFromPassing		; $7348
	call interactionRunScript		; $734b
	jp interactionAnimate		; $734e

@state0:
	call interactionInitGraphics		; $7351
	call objectSetVisible82		; $7354
	call checkIsLinkedGame		; $7357
	jr nz,++		; $735a

	; Unlinked: mark room as in the past (for the minimap probably)
	ld hl,wTilesetFlags		; $735c
	set TILESETFLAG_BIT_PAST,(hl)		; $735f
++
	ld hl,pirateCaptainScript		; $7361
	call interactionSetScript		; $7364
	jp interactionIncState		; $7367


; ==============================================================================
; INTERACID_PIRATE
;
; Variables:
;   var3f: Push counter for subid 4 (tokay eyeball is inserted when it reached 0)
; ==============================================================================
interactionCodec4:
	ld e,Interaction.state		; $736a
	ld a,(de)		; $736c
	rst_jumpTable			; $736d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid		; $7378
	ld a,(de)		; $737a
	rst_jumpTable			; $737b
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init

@subid0Init:
@subid1Init:
@subid2Init:
@subid3Init:
	ld a,(de)		; $7386
	ld hl,@scriptTable		; $7387
	rst_addDoubleIndex			; $738a
	ldi a,(hl)		; $738b
	ld h,(hl)		; $738c
	ld l,a			; $738d
	call interactionSetScript		; $738e
	call interactionInitGraphics		; $7391
	call objectSetVisiblec2		; $7394
	jp interactionIncState		; $7397

@subid4Init:
	call getThisRoomFlags		; $739a
	and ROOMFLAG_80			; $739d
	jp nz,interactionDelete		; $739f

	call @resetPushCounter		; $73a2
	ld e,Interaction.state		; $73a5
	ld a,$03		; $73a7
	ld (de),a		; $73a9

	ld e,Interaction.subid		; $73aa
	ld a,(de)		; $73ac
	ld hl,@scriptTable		; $73ad
	rst_addDoubleIndex			; $73b0
	ldi a,(hl)		; $73b1
	ld h,(hl)		; $73b2
	ld l,a			; $73b3
	jp interactionSetScript		; $73b4

@scriptTable:
	.dw pirateSubid0Script
	.dw pirateSubid1Script
	.dw pirateSubid2Script
	.dw pirateSubid3Script
	.dw pirateSubid4Script


; Subids 0-3: waiting for signal from piration captain to jump in excitement
@state1:
	ld a,(wTmpcfc0.genericCutscene.state)		; $73c1
	bit 0,a			; $73c4
	jp nz,@jump		; $73c6
	call interactionRunScript		; $73c9
	jp npcFaceLinkAndAnimate		; $73cc

@jump:
	ld a,$02		; $73cf
	call interactionSetAnimation		; $73d1
	ld bc,-$200		; $73d4
	call objectSetSpeedZ		; $73d7
	jp interactionIncState		; $73da


; Subids 0-3: will set a signal when they're done jumping
@state2:
	ld c,$28		; $73dd
	call objectUpdateSpeedZ_paramC		; $73df
	ret nz			; $73e2
	ld hl,wTmpcfc0.genericCutscene.state		; $73e3
	set 1,(hl)		; $73e6
	jp interactionAnimate		; $73e8


;;
; @param[out]	cflag	c if Link is pushing up towards this object
; @addr{73eb}
@checkCenteredWithLink:
	ld a,(wLinkDeathTrigger)		; $73eb
	or a			; $73ee
	ret nz			; $73ef
	ld a,(wLinkPushingDirection)		; $73f0
	or a ; DIR_UP
	ret nz			; $73f4
	ld a,(wGameKeysPressed)		; $73f5
	and BTN_A | BTN_B			; $73f8
	ret nz			; $73fa
	ld b,$05		; $73fb
	jp objectCheckCenteredWithLink		; $73fd


; Subid 4: tokay eyeball slot, waiting to be put in
@state3:
	call objectCheckCollidedWithLink_notDead		; $7400
	call nc,@resetPushCounter		; $7403
	call @checkCenteredWithLink		; $7406
	call nc,@resetPushCounter		; $7409
	ld h,d			; $740c
	ld l,Interaction.var3f		; $740d
	dec (hl)		; $740f
	jr nz,@state4	; $7410

	ld a,TREASURE_TOKAY_EYEBALL		; $7412
	call checkTreasureObtained		; $7414
	jr c,@haveEyeball	; $7417

	ld bc,TX_360d		; $7419
	call showText		; $741c
	jr @resetPushCounter		; $741f

@haveEyeball:
	call checkLinkCollisionsEnabled		; $7421
	jr nc,@resetPushCounter	; $7424

	; Putting eyeball in
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $7426
	ld (wDisabledObjects),a		; $7428
	ld (wMenuDisabled),a		; $742b
	ld a,SNDCTRL_STOPMUSIC		; $742e
	call playSound		; $7430
	ld hl,pirateSubid4Script_insertEyeball		; $7433
	call interactionSetScript		; $7436

@state4:
	call interactionRunScript		; $7439
	ret nc			; $743c
	jp interactionDelete		; $743d

@resetPushCounter:
	ld e,Interaction.var3f		; $7440
	ld a,10		; $7442
	ld (de),a		; $7444
	ret			; $7445


; ==============================================================================
; INTERACID_PLAY_HARP_SONG
; ==============================================================================
interactionCodec5:
	ld e,Interaction.state		; $7446
	ld a,(de)		; $7448
	rst_jumpTable			; $7449
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call setLinkForceStateToState08		; $7458
	ld hl,w1Link.yh		; $745b
	call objectTakePosition		; $745e
	ld e,Interaction.counter1		; $7461
	ld a,$04		; $7463
	ld (de),a		; $7465
	jp interactionIncState		; $7466

@state1:
	call interactionDecCounter1		; $7469
	ret nz			; $746c
	ld (hl),52 ; [counter1]

	ld a,LINK_ANIM_MODE_HARP_2		; $746f
	ld (wcc50),a		; $7471

	call interactionIncState		; $7474

	ld e,Interaction.subid		; $7477
	ld a,(de)		; $7479
	ld hl,@sounds		; $747a
	rst_addAToHl			; $747d
	ld a,(hl)		; $747e
	jp playSound		; $747f

@sounds:
	.db SND_ECHO
	.db SND_CURRENT
	.db SND_AGES


; Facing left
@state2:
@state4:
	ld a,(wFrameCounter)		; $7485
	and $1f			; $7488
	jr nz,@stateCommon	; $748a
	xor a			; $748c
	ld bc,$f8f8		; $748d
	call objectCreateFloatingMusicNote		; $7490

@stateCommon:
	push de			; $7493
	ld de,w1Link		; $7494
	callab specialObjectAnimate		; $7497
	pop de			; $749f
	call interactionDecCounter1		; $74a0
	ret nz			; $74a3
	ld (hl),52 ; [counter1]
	jp interactionIncState		; $74a6


; Facing right
@state3:
@state5:
	ld a,(wFrameCounter)		; $74a9
	and $1f			; $74ac
	jr nz,@stateCommon	; $74ae

	ld a,$01		; $74b0
	ld bc,$f808		; $74b2
	call objectCreateFloatingMusicNote		; $74b5
	jr @stateCommon		; $74b8


; Signal to a "cutscene handler" that we're done, then delete self
@state6:
	ld hl,wTmpcfc0.genericCutscene.state		; $74ba
	set 7,(hl)		; $74bd
	ld a,LINK_ANIM_MODE_WALK		; $74bf
	ld (wcc50),a		; $74c1
	jp interactionDelete		; $74c4


; ==============================================================================
; INTERACID_BLACK_TOWER_DOOR_HANDLER
; ==============================================================================
interactionCodec6:
	ld e,Interaction.state		; $74c7
	ld a,(de)		; $74c9
	rst_jumpTable			; $74ca
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	call getThisRoomFlags		; $74d1
	and ROOMFLAG_40			; $74d4
	jr z,@cutsceneNotDone	; $74d6

	; Already did the cutscene. Replace the door with a staircase (functionally, not visually)
	; for some reason...
	ld hl,wRoomLayout+$47		; $74d8
	ld (hl),$44		; $74db
	jp interactionDelete		; $74dd

@cutsceneNotDone:
	ld a,TREASURE_MAKU_SEED		; $74e0
	call checkTreasureObtained		; $74e2
	jr nc,@noMakuSeed	; $74e5

	; Time to start the cutscene.
	call clearAllItemsAndPutLinkOnGround		; $74e7
	call resetLinkInvincibility		; $74ea

	ld a,LINK_STATE_FORCE_MOVEMENT		; $74ed
	ld (wLinkForceState),a		; $74ef
	ld a,$70		; $74f2
	ld (wLinkStateParameter),a		; $74f4

	ld e,Interaction.counter1		; $74f7
	ld (de),a		; $74f9
	ld hl,w1Link.direction		; $74fa
	ld (hl),$01		; $74fd
	inc l			; $74ff
	ld (hl),$08 ; [w1Link.angle]

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $7502
	ld (wDisabledObjects),a		; $7504
	ld (wMenuDisabled),a		; $7507

	call interactionIncState		; $750a
	ld a,PALH_ab		; $750d
	call loadPaletteHeader		; $750f
	jp restartSound		; $7512

@noMakuSeed:
	; Replace door tiles with staircase tiles? This will only affect behaviour (not appearance),
	; so this might be because the door tiles are actually fake for some reason?
	ld a,$44		; $7515
	ld hl,wRoomLayout+$44		; $7517
	ld (hl),a		; $751a
	ld l,$47		; $751b
	ld (hl),a		; $751d
	ld l,$4a		; $751e
	ld (hl),a		; $7520

	; Prevent them from sending you anywhere
	ld (wDisableWarps),a		; $7521

	jp interactionDelete		; $7524


; Delay before making Link face up
@state1:
	call interactionDecCounter1		; $7527
	ret nz			; $752a
	ld (hl),30		; $752b
	xor a ; DIR_UP
	ld hl,w1Link.direction		; $752e
	ldi (hl),a		; $7531
	ld (hl),a		; $7532
	jp interactionIncState		; $7533


; Delay before starting cutscene
@state2:
	call interactionDecCounter1		; $7536
	ret nz			; $7539
	ld b,INTERACID_MAKU_SEED_AND_ESSENCES		; $753a
	call objectCreateInteractionWithSubid00		; $753c
	jp interactionDelete		; $753f


; ==============================================================================
; INTERACID_TINGLE
;
; Variables:
;   var3d: Satchel level (minus one); used by script.
;   var3e: Nonzero if Link has 3 seed types or more
;   var3f: Signal for the script, set to 1 when his "kooloo-limpah" animation ends
; ==============================================================================
interactionCodec8:
	ld e,Interaction.state		; $7542
	ld a,(de)		; $7544
	rst_jumpTable			; $7545
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01		; $7550
	ld (de),a ; [state]

	call interactionInitGraphics		; $7553
	call interactionSetAlwaysUpdateBit		; $7556
	call objectSetVisiblec0		; $7559
	ld a,>TX_1e00		; $755c
	call interactionSetHighTextIndex		; $755e
	ld a,$06		; $7561
	call objectSetCollideRadius		; $7563

	; Count number of seed types Link has
	ldbc TREASURE_EMBER_SEEDS, 00		; $7566
@checkNextSeed:
	ld a,b			; $7569
	call checkTreasureObtained		; $756a
	ld a,$00		; $756d
	rla			; $756f
	add c			; $7570
	ld c,a			; $7571
	inc b			; $7572
	ld a,b			; $7573
	cp TREASURE_MYSTERY_SEEDS+1			; $7574
	jr nz,@checkNextSeed	; $7576

	ld a,c			; $7578
	cp $03			; $7579
	jr c,++			; $757b
	ld e,Interaction.var3e		; $757d
	ld (de),a		; $757f
++
	call getFreePartSlot		; $7580
	ret nz			; $7583
	ld (hl),PARTID_TINGLE_BALLOON		; $7584
	call objectCopyPosition		; $7586
	ld l,Part.relatedObj1		; $7589
	ld a,Interaction.start		; $758b
	ldi (hl),a		; $758d
	ld (hl),d		; $758e


; Tingle's balloon will change the state to 2 when it gets popped
@state1:
	ret			; $758f


; Falling from the air
@state3:
	ld e,Interaction.counter1		; $7590
	ld a,(de)		; $7592
	or a			; $7593
	jp nz,interactionDecCounter1		; $7594

	ld c,$10		; $7597
	call objectUpdateSpeedZ_paramC		; $7599
	ret nz			; $759c

	ld e,Interaction.pressedAButton		; $759d
	call objectAddToAButtonSensitiveObjectList		; $759f
	ld hl,tingleScript		; $75a2
	call interactionSetScript		; $75a5
	ld a,$04		; $75a8
	ld e,Interaction.state		; $75aa
	ld (de),a		; $75ac
	ld a,$01		; $75ad
	jr @setAnimation		; $75af


; Balloon just popped
@state2:
	ld a,$03		; $75b1
	ld (de),a ; [state]
	ld a,15		; $75b4
	ld e,Interaction.counter1		; $75b6
	ld (de),a		; $75b8
	ld a,$02		; $75b9

@setAnimation:
	jp interactionSetAnimation		; $75bb


; On the ground
@state4:
	ld a,TREASURE_SEED_SATCHEL		; $75be
	call checkTreasureObtained		; $75c0
	ld e,Interaction.var3d		; $75c3
	dec a			; $75c5
	ld (de),a		; $75c6
	call interactionRunScript		; $75c7
	call interactionAnimateAsNpc		; $75ca
	ld e,Interaction.animParameter		; $75cd
	ld a,(de)		; $75cf
	rrca			; $75d0
	jr nc,@label_0b_330	; $75d1

	ld bc,-$200		; $75d3
	call objectSetSpeedZ		; $75d6

	ld bc,$e800		; $75d9
	call objectCreateSparkle		; $75dc
	ld l,Interaction.angle		; $75df
	ld (hl),$10		; $75e1

	ld bc,$f008		; $75e3
	call objectCreateSparkle		; $75e6
	ld l,Interaction.angle		; $75e9
	ld (hl),$10		; $75eb

	ld bc,$f0f8		; $75ed
	call objectCreateSparkle		; $75f0
	ld l,Interaction.angle		; $75f3
	ld (hl),$10		; $75f5

@label_0b_330:
	ld c,$20		; $75f7
	call objectUpdateSpeedZ_paramC		; $75f9
	ret nz			; $75fc

	ld e,Interaction.animParameter		; $75fd
	ld a,(de)		; $75ff
	rlca			; $7600
	ret nc			; $7601

	xor a			; $7602
	ld e,Interaction.var3f		; $7603
	ld (de),a		; $7605
	ld a,$01		; $7606
	jr @setAnimation		; $7608


; ==============================================================================
; INTERACID_SYRUP_CUCCO
;
; Variables:
;   var3c: $00 normally, $01 while cucco is chastizing Link
;   var3d: Animation index?
;   var3e: Also an animation index?
; ==============================================================================
interactionCodec9:
	call @runState		; $760a
	jp @updateAnimation		; $760d

@runState:
	ld e,Interaction.state		; $7610
	ld a,(de)		; $7612
	rst_jumpTable			; $7613
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@updateAnimation:
	ld e,Interaction.var3d		; $761e
	ld a,(de)		; $7620
	or a			; $7621
	ret z			; $7622
	jp interactionAnimate		; $7623

@state0:
	ld a,$01		; $7626
	ld (de),a ; [state]
	call interactionInitGraphics		; $7629

	ld h,d			; $762c
	ld l,Interaction.collisionRadiusY		; $762d
	ld (hl),$06		; $762f
	inc l			; $7631
	ld (hl),$06 ; [collisionRadiusX]

	ld l,Interaction.speed		; $7634
	ld (hl),SPEED_a0		; $7636
	call @beginHop		; $7638
	ld e,Interaction.pressedAButton		; $763b
	call objectAddToAButtonSensitiveObjectList		; $763d
	call objectSetVisible80		; $7640
	jp @func_7710		; $7643

@state1:
	call @updateHopping		; $7646
	call @updateMovement		; $7649

	; Return if [w1Link.yh] < $69
	ld hl,w1Link.yh		; $764c
	ld c,$69		; $764f
	ld b,(hl)		; $7651
	ld a,$69		; $7652
	ld l,a			; $7654
	ld a,c			; $7655
	cp b			; $7656
	ret nc			; $7657

	; Check if he's holding something
	ld a,(wLinkGrabState)		; $7658
	or a			; $765b
	ret z			; $765c

	; Freeze Link
	ld e,Interaction.var3c		; $765d
	ld a,$02		; $765f
	ld (de),a		; $7661
	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $7662
	ld (wDisabledObjects),a		; $7664

	ld a,l			; $7667
	ld hl,w1Link.yh		; $7668
	ld (hl),a		; $766b
	jp @initState2		; $766c

; Unused?
@func_766f:
	xor a			; $766f
	ld (de),a ; ?
	ld e,Interaction.var3d		; $7671
	ld (de),a		; $7673
	ld e,Interaction.var3c		; $7674
	ld a,$01		; $7676
	ld (de),a		; $7678
	ld a,(wLinkGrabState)		; $7679
	or a			; $767c
	jr z,@gotoState4	; $767d

	; Do something with the item Link's holding?
	ld a,(w1Link.relatedObj2+1)		; $767f
	ld h,a			; $7682
	ld e,Interaction.var3a		; $7683
	ld (de),a		; $7685
	ld hl,syrupCuccoScript_triedToSteal		; $7686
	jp @setScriptAndGotoState4			; $7689

@gotoState4:
	ld hl,syrupCuccoScript_triedToSteal		; $768c

@setScriptAndGotoState4:
	ld e,Interaction.state		; $768f
	ld a,$04		; $7691
	ld (de),a		; $7693
	jp interactionSetScript		; $7694


; Moving toward Link after he tried to steal something
@state2:
	call @updateHopping		; $7697
	call objectApplySpeed		; $769a
	ld e,Interaction.xh		; $769d
	ld a,(de)		; $769f
	sub $0c			; $76a0
	ld hl,w1Link.xh		; $76a2
	cp (hl)			; $76a5
	ret nc			; $76a6

	; Reached Link
	ld e,Interaction.var3d		; $76a7
	xor a			; $76a9
	ld (de),a		; $76aa
	ld hl,syrupCuccoScript_triedToSteal		; $76ab
	jp @setScriptAndGotoState4		; $76ae


; Moving back to normal position
@state3:
	call @updateHopping		; $76b1
	call objectApplySpeed		; $76b4
	ld e,Interaction.xh		; $76b7
	ld a,(de)		; $76b9
	cp $78			; $76ba
	ret c			; $76bc

	xor a			; $76bd
	ld (wDisabledObjects),a		; $76be
	ld e,Interaction.state		; $76c1
	ld a,$01		; $76c3
	ld (de),a		; $76c5
	jp @func_7710		; $76c6


@state4:
	call interactionRunScript		; $76c9
	ret nc			; $76cc

	ld e,Interaction.var3c		; $76cd
	ld a,(de)		; $76cf
	cp $02			; $76d0
	jr z,@beginMovingBack	; $76d2

	ld h,d			; $76d4
	ld l,Interaction.state		; $76d5
	ld (hl),$01		; $76d7
	ld l,Interaction.var3c		; $76d9
	ld (hl),$00		; $76db
	ld l,Interaction.var3d		; $76dd
	ld (hl),$01		; $76df
	xor a			; $76e1
	ld (wDisabledObjects),a		; $76e2
	ret			; $76e5

@beginMovingBack:
	jp @initState3		; $76e6

;;
; @addr{76e9}
@updateHopping:
	ld c,$20		; $76e9
	call objectUpdateSpeedZ_paramC		; $76eb
	ret nz			; $76ee
	ld h,d			; $76ef

;;
; @addr{76f0}
@beginHop:
	ld bc,-$c0		; $76f0
	jp objectSetSpeedZ		; $76f3

;;
; @addr{76f6}
@updateMovement:
	call objectApplySpeed		; $76f6
	ld e,Interaction.xh		; $76f9
	ld a,(de)		; $76fb
	sub $68			; $76fc
	cp $20			; $76fe
	ret c			; $7700

	; Reverse direction
	ld e,Interaction.angle		; $7701
	ld a,(de)		; $7703
	xor $10			; $7704
	ld (de),a		; $7706

	ld e,Interaction.var3e		; $7707
	ld a,(de)		; $7709
	xor $01			; $770a
	ld (de),a		; $770c
	jp interactionSetAnimation		; $770d

;;
; @addr{7710}
@func_7710:
	ld h,d			; $7710
	ld l,Interaction.var3c		; $7711
	ld (hl),$00		; $7713
	ld l,Interaction.speed		; $7715
	ld (hl),SPEED_80		; $7717
	jr +++			; $7719

;;
; @addr{771b}
@initState2:
	ld h,d			; $771b
	ld l,Interaction.state		; $771c
	ld (hl),$02		; $771e
	ld l,Interaction.speed		; $7720
	ld (hl),SPEED_200		; $7722
+++
	ld l,Interaction.var3d		; $7724
	ld (hl),$01		; $7726
	ld l,Interaction.angle		; $7728
	ld (hl),$18		; $772a
	xor a			; $772c
	ld l,Interaction.z		; $772d
	ldi (hl),a		; $772f
	ld (hl),a		; $7730
	ld l,Interaction.var3e		; $7731
	ld a,$00		; $7733
	ld (hl),a		; $7735
	jp interactionSetAnimation		; $7736

;;
; @addr{7739}
@initState3:
	ld h,d			; $7739
	ld l,Interaction.state		; $773a
	ld (hl),$03		; $773c
	ld l,Interaction.speed		; $773e
	ld (hl),SPEED_200		; $7740
	ld l,Interaction.var3d		; $7742
	ld (hl),$01		; $7744
	ld l,Interaction.angle		; $7746
	ld (hl),$08		; $7748
	xor a			; $774a
	ld l,Interaction.z		; $774b
	ldi (hl),a		; $774d
	ld (hl),a		; $774e
	ld l,Interaction.var3e		; $774f
	ld a,$01		; $7751
	ld (hl),a		; $7753
	jp interactionSetAnimation		; $7754


; ==============================================================================
; INTERACID_TROY
; ==============================================================================
interactionCodeca:
	ld e,Interaction.subid		; $7757
	ld a,(de)		; $7759
	rst_jumpTable			; $775a
	.dw @subid0
	.dw @subid1


@subid0:
	call checkInteractionState		; $775f
	jr nz,@state1	; $7762

	; State 0
	call @initialize		; $7764
	ld a,(wScreenTransitionDirection)		; $7767
	or a			; $776a
	jr nz,@state1			; $776b
	ld (wTmpcfc0.targetCarts.beganGameWithTroy),a		; $776d

@state1:
	call interactionRunScript		; $7770
	jp c,interactionDelete		; $7773
	jp interactionAnimateAsNpc		; $7776


@subid1:
	call checkInteractionState		; $7779
	jr nz,@state1	; $777c

	; State 0
	jp @initialize		; $777e


; Unused
@func_7781:
	call interactionInitGraphics		; $7781
	jp interactionIncState		; $7784


@initialize:
	call interactionInitGraphics		; $7787
	ld e,Interaction.subid		; $778a
	ld a,(de)		; $778c
	ld hl,@scriptTable		; $778d
	rst_addDoubleIndex			; $7790
	ldi a,(hl)		; $7791
	ld h,(hl)		; $7792
	ld l,a			; $7793
	call interactionSetScript		; $7794
	jp interactionIncState		; $7797

@scriptTable:
	.dw troySubid0Script
	.dw troySubid1Script


; ==============================================================================
; INTERACID_LINKED_GAME_GHINI
;
; Variables:
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCodecb:
	call checkInteractionState		; $779e
	jr nz,@state1	; $77a1

@state0:
	call @initialize		; $77a3
	ld h,d			; $77a6
	ld l,Interaction.oamFlags		; $77a7
	ld (hl),$02		; $77a9
	ld l,Interaction.var3f		; $77ab
	ld (hl),GRAVEYARD_SECRET & $0f		; $77ad
	ld hl,linkedGameNpcScript		; $77af
	call interactionSetScript		; $77b2

@state1:
	call interactionRunScript		; $77b5
	jp c,interactionDeleteAndUnmarkSolidPosition		; $77b8
	jp interactionAnimateAsNpc		; $77bb

@initialize:
	call interactionInitGraphics		; $77be
	call objectMarkSolidPosition		; $77c1
	jp interactionIncState		; $77c4

; Unused
@func_77c7:
	call interactionInitGraphics		; $77c7
	call objectMarkSolidPosition		; $77ca
	ld a,>TX_4d00		; $77cd
	call interactionSetHighTextIndex		; $77cf
	ld e,Interaction.subid		; $77d2
	ld a,(de)		; $77d4
	ld hl,@scriptTable		; $77d5
	rst_addDoubleIndex			; $77d8
	ldi a,(hl)		; $77d9
	ld h,(hl)		; $77da
	ld l,a			; $77db
	call interactionSetScript		; $77dc
	jp interactionIncState		; $77df

@scriptTable:
	.dw linkedGameNpcScript


; ==============================================================================
; INTERACID_PLEN
; ==============================================================================
interactionCodecc:
	ld e,Interaction.subid		; $77e4
	ld a,(de)		; $77e6
	rst_jumpTable			; $77e7
	.dw @subid0

@subid0:
	call checkInteractionState		; $77ea
	jr nz,@state1	; $77ed

@state0:
	call @initialize		; $77ef
	call interactionSetAlwaysUpdateBit		; $77f2

@state1:
	call interactionRunScript		; $77f5
	jp c,interactionDelete		; $77f8
	jp interactionAnimateAsNpc		; $77fb
	call interactionInitGraphics		; $77fe
	jp interactionIncState		; $7801

@initialize:
	call interactionInitGraphics		; $7804
	ld e,Interaction.subid		; $7807
	ld a,(de)		; $7809
	ld hl,@scriptTable		; $780a
	rst_addDoubleIndex			; $780d
	ldi a,(hl)		; $780e
	ld h,(hl)		; $780f
	ld l,a			; $7810
	call interactionSetScript		; $7811
	jp interactionIncState		; $7814

@scriptTable:
	.dw plenSubid0Script


; ==============================================================================
; INTERACID_MASTER_DIVER
;
; Variables:
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCodecd:
	call checkInteractionState		; $7819
	jr nz,@state1	; $781c

@state0:
	call @initialize		; $781e
	ld l,Interaction.var3f		; $7821
	ld (hl),DIVER_SECRET & $0f		; $7823
	ld hl,linkedGameNpcScript		; $7825
	call interactionSetScript		; $7828
	call interactionRunScript		; $782b

@state1:
	call interactionRunScript		; $782e
	jp c,interactionDeleteAndUnmarkSolidPosition		; $7831
	jp interactionAnimateAsNpc		; $7834

@initialize:
	call interactionInitGraphics		; $7837
	call objectMarkSolidPosition		; $783a
	jp interactionIncState		; $783d

;;
; Unused
; @addr{7840}
@func_7840:
	call interactionInitGraphics		; $7840
	call objectMarkSolidPosition		; $7843
	ld e,Interaction.subid		; $7846
	ld a,(de)		; $7848
	ld hl,@scriptTable		; $7849
	rst_addDoubleIndex			; $784c
	ldi a,(hl)		; $784d
	ld h,(hl)		; $784e
	ld l,a			; $784f
	call interactionSetScript		; $7850
	jp interactionIncState		; $7853

@scriptTable:
	; Apparently this is empty


; ==============================================================================
; INTERACID_GREAT_FAIRY
;
; Variables:
;   var3e: ?
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCoded5:
	ld e,Interaction.subid		; $7856
	ld a,(de)		; $7858
	rst_jumpTable			; $7859
	.dw _greatFairy_subid0
	.dw _greatFairy_subid1


; Linked game NPC
_greatFairy_subid0:
	call checkInteractionState		; $785e
	jr nz,@state1	; $7861

@state0:
	call _greatFairy_initialize		; $7863
	call interactionSetAlwaysUpdateBit		; $7866
	ld l,Interaction.zh		; $7869
	ld (hl),$f0		; $786b
	ld l,Interaction.var3f		; $786d
	ld (hl),TEMPLE_SECRET & $0f		; $786f
	call interactionRunScript		; $7871

@state1:
	call returnIfScrollMode01Unset		; $7874
	call interactionRunScript		; $7877
	jp c,interactionDeleteAndUnmarkSolidPosition		; $787a

	ld e,Interaction.var3e		; $787d
	ld a,(de)		; $787f
	or a			; $7880
	ret nz			; $7881
	call interactionAnimateAsNpc		; $7882

	; Update Z position every 8 frames (floats up and down)
	ld a,(wFrameCounter)		; $7885
	and $07			; $7888
	ret nz			; $788a
	ld a,(wFrameCounter)		; $788b
	and $38			; $788e
	swap a			; $7890
	rlca			; $7892
	ld hl,@zPositions		; $7893
	rst_addAToHl			; $7896
	ld e,Interaction.zh		; $7897
	ld a,(de)		; $7899
	add (hl)		; $789a
	ld (de),a		; $789b
	ret			; $789c

@zPositions:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; Cutscene after being healed from being an octorok
_greatFairy_subid1:
	call checkInteractionState		; $78a5
	jr nz,@state1	; $78a8

@state0:
	ld a,SND_POP		; $78aa
	call playSound		; $78ac

	call _greatFairy_initialize		; $78af
	call objectSetVisiblec1		; $78b2
	call interactionSetAlwaysUpdateBit		; $78b5

	ld l,Interaction.zh		; $78b8
	ld (hl),$f0		; $78ba
	ld l,Interaction.counter1		; $78bc
	ld a,180		; $78be
	ldi (hl),a		; $78c0
	ld (hl),$02 ; [counter2]

	ldbc INTERACID_SPARKLE, $04		; $78c3
	call objectCreateInteraction		; $78c6
	ld l,Interaction.counter1		; $78c9
	ld (hl),120		; $78cb

	; Create sparkles
	ld b,$00		; $78cd
--
	push bc			; $78cf
	ldbc INTERACID_SPARKLE, $0a		; $78d0
	call objectCreateInteraction		; $78d3
	pop bc			; $78d6
	ld l,Interaction.angle		; $78d7
	ld (hl),b		; $78d9
	ld a,b			; $78da
	add $04			; $78db
	ld b,a			; $78dd
	bit 5,a			; $78de
	jr z,--			; $78e0
	ret			; $78e2

@state1:
	call interactionAnimate		; $78e3
	ld e,Interaction.state2		; $78e6
	ld a,(de)		; $78e8
	rst_jumpTable			; $78e9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call interactionDecCounter1		; $78f2
	ret nz			; $78f5
	ld (hl),$40		; $78f6
	ld l,Interaction.angle		; $78f8
	ld (hl),$08		; $78fa
	ld l,Interaction.speed		; $78fc
	ld (hl),SPEED_300		; $78fe
	ld bc,TX_4109		; $7900
	call showText		; $7903
	jp interactionIncState2		; $7906

@substate1:
	call retIfTextIsActive		; $7909
	call objectApplySpeed		; $790c

	; Update angle (moving in a circle)
	call interactionDecCounter2		; $790f
	jr nz,@updateSparklesAndSoundEffect		; $7912
	ld (hl),$02		; $7914
	ld l,Interaction.angle		; $7916
	ld a,(hl)		; $7918
	inc a			; $7919
	and $1f			; $791a
	ld (hl),a		; $791c
	call interactionDecCounter1		; $791d
	jp z,interactionIncState2		; $7920

@updateSparklesAndSoundEffect:
	ld a,(wFrameCounter)		; $7923
	and $07			; $7926
	ret nz			; $7928
	ldbc INTERACID_SPARKLE, $02		; $7929
	call objectCreateInteraction		; $792c
	ld a,(wFrameCounter)		; $792f
	and $1f			; $7932
	ld a,SND_MAGIC_POWDER		; $7934
	call z,playSound		; $7936
	ret			; $7939

; Moving up out of the screen
@substate2:
	call @updateSparklesAndSoundEffect		; $793a
	ld h,d			; $793d
	ld l,Interaction.zh		; $793e
	ld a,(hl)		; $7940
	sub $02			; $7941
	ld (hl),a		; $7943
	cp $b0			; $7944
	ret nc			; $7946
	call fadeoutToWhite		; $7947
	jp interactionIncState2		; $794a

; Transition to next part of cutscene
@substate3:
	ld a,(wPaletteThread_mode)		; $794d
	or a			; $7950
	ret nz			; $7951
	ld a,CUTSCENE_CLEAN_SEAS		; $7952
	ld (wCutsceneTrigger),a		; $7954
	jp interactionDelete		; $7957

;;
; Unused
; @addr{795a}
@func_795a:
	call interactionInitGraphics		; $795a
	call objectMarkSolidPosition		; $795d
	jp interactionIncState		; $7960


_greatFairy_initialize:
	call interactionInitGraphics		; $7963
	call objectMarkSolidPosition		; $7966
	ld e,Interaction.subid		; $7969
	ld a,(de)		; $796b
	ld hl,@scriptTable		; $796c
	rst_addDoubleIndex			; $796f
	ldi a,(hl)		; $7970
	ld h,(hl)		; $7971
	ld l,a			; $7972
	call interactionSetScript		; $7973
	jp interactionIncState		; $7976

@scriptTable:
	.dw greatFairySubid0Script


; ==============================================================================
; INTERACID_DEKU_SCRUB
;
; Variables:
;   var3e: 0 if the deku scrub is hiding, 1 if not
;   var3f: Secret index (for "linkedGameNpcScript")
; ==============================================================================
interactionCoded6:
	call checkInteractionState		; $797b
	jr nz,@state1	; $797e

@state0:
	call @initialize		; $7980
	call interactionSetAlwaysUpdateBit		; $7983
	ld l,Interaction.var3f		; $7986
	ld (hl),DEKU_SECRET & $0f		; $7988
	ld hl,linkedGameNpcScript		; $798a
	call interactionSetScript		; $798d
	call interactionRunScript		; $7990

@state1:
	call interactionRunScript		; $7993
	jp c,interactionDeleteAndUnmarkSolidPosition		; $7996

	call interactionAnimateAsNpc		; $7999
	ld c,$20		; $799c
	call objectCheckLinkWithinDistance		; $799e
	ld h,d			; $79a1
	ld l,Interaction.var3e		; $79a2
	jr c,@linkIsClose	; $79a4

	ld a,(hl) ; [var3e]
	or a			; $79a7
	ret z			; $79a8
	xor a			; $79a9
	ld (hl),a		; $79aa
	ld a,$03		; $79ab
	jp interactionSetAnimation		; $79ad

@linkIsClose:
	ld a,(hl) ; [var3e]
	or a			; $79b1
	ret nz			; $79b2
	inc (hl) ; [var3e]
	ld a,$01		; $79b4
	jp interactionSetAnimation		; $79b6

@initialize:
	call interactionInitGraphics		; $79b9
	call objectMarkSolidPosition		; $79bc
	jp interactionIncState		; $79bf


; ==============================================================================
; INTERACID_MAKU_SEED_AND_ESSENCES
;
; Variables:
;   counter1: Essence index (for the maku seed / spawner object)
; ==============================================================================
interactionCoded7:
	ld e,Interaction.subid		; $79c2
	ld a,(de)		; $79c4
	rst_jumpTable			; $79c5
	.dw interactiond7_makuSeed
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence
	.dw interactiond7_essence


interactiond7_makuSeed:
	ld e,Interaction.state		; $79d8
	ld a,(de)		; $79da
	rst_jumpTable			; $79db
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,$01		; $79e6
	ld (de),a		; $79e8
	call interactionInitGraphics		; $79e9

	ld a,(w1Link.yh)		; $79ec
	sub $0e			; $79ef
	ld e,Interaction.yh		; $79f1
	ld (de),a		; $79f3
	ld a,(w1Link.xh)		; $79f4
	ld e,Interaction.xh		; $79f7
	ld (de),a		; $79f9

	call setLinkForceStateToState08		; $79fa

	ld a,SNDCTRL_STOPSFX		; $79fd
	call playSound		; $79ff
	ld a,SND_DROPESSENCE		; $7a02
	call playSound		; $7a04

	ldbc INTERACID_SPARKLE, $04		; $7a07
	call objectCreateInteraction		; $7a0a
	ret nz			; $7a0d
	ld l,Interaction.counter1		; $7a0e
	ld e,l			; $7a10
	ld a,120		; $7a11
	ld (hl),a		; $7a13
	ld (de),a		; $7a14
	jp objectSetVisible82		; $7a15

@state1:
	ld a,LINK_ANIM_MODE_GETITEM2HAND		; $7a18
	ld (wcc50),a		; $7a1a

	call interactionDecCounter1		; $7a1d
	ret nz			; $7a20
	ld (hl),$40 ; [counter1]
	ld l,Interaction.speed		; $7a23
	ld (hl),SPEED_80		; $7a25
	jp interactionIncState		; $7a27

@state2:
	call objectApplySpeed		; $7a2a
	call _interactiond7_updateSmallSparkles		; $7a2d
	call interactionDecCounter1		; $7a30
	ret nz			; $7a33

	ld (hl),120 ; [counter1]
	ld a,LINK_ANIM_MODE_WALK		; $7a36
	ld (wcc50),a		; $7a38
	ld l,Interaction.yh		; $7a3b
	ld (hl),$58		; $7a3d
	ld l,Interaction.xh		; $7a3f
	ld (hl),$78		; $7a41
	ld a,SND_POP		; $7a43
	call playSound		; $7a45
	ld a,$03		; $7a48
	call fadeinFromWhiteWithDelay		; $7a4a
	jp interactionIncState		; $7a4d

@state3:
	call _interactiond7_updateSmallSparkles		; $7a50
	call _interactiond7_updateFloating		; $7a53
	ld e,Interaction.state2		; $7a56
	ld a,(de)		; $7a58
	rst_jumpTable			; $7a59
	.dw @state3Substate0
	.dw @state3Substate1
	.dw @state3Substate2
	.dw @state3Substate3
	.dw @state3Substate4
	.dw @state3Substate5
	.dw @state3Substate6
	.dw @state3Substate7
	.dw @state3Substate8
	.dw @state3Substate9

@state3Substate0:
	call interactionDecCounter1		; $7a6e
	ret nz			; $7a71
	ld (hl),20		; $7a72
	inc l			; $7a74
	ld (hl),$08		; $7a75
	jp interactionIncState2		; $7a77


; Spawning the essences
@state3Substate1:
	call interactionDecCounter1		; $7a7a
	ret nz			; $7a7d
	ld (hl),20		; $7a7e
	inc l			; $7a80
	dec (hl)		; $7a81
	ld b,(hl)		; $7a82

	; Spawn next essence
	call getFreeInteractionSlot		; $7a83
	ret nz			; $7a86
	ld (hl),INTERACID_MAKU_SEED_AND_ESSENCES		; $7a87
	call objectCopyPosition		; $7a89
	ld a,b			; $7a8c
	ld bc,@essenceSpawnerData		; $7a8d
	call addDoubleIndexToBc		; $7a90

	ld a,(bc)		; $7a93
	ld l,Interaction.subid		; $7a94
	ld (hl),a		; $7a96
	ld l,Interaction.angle		; $7a97
	inc bc			; $7a99
	ld a,(bc)		; $7a9a
	ld (hl),a		; $7a9b
	ld e,Interaction.counter2		; $7a9c
	ld a,(de)		; $7a9e
	or a			; $7a9f
	ret nz			; $7aa0

	call interactionIncState2		; $7aa1
	ld l,Interaction.counter1		; $7aa4
	ld (hl),120		; $7aa6
	ret			; $7aa8

; b0: subid
; b1: angle (the direction it moves out from the maku seed)
@essenceSpawnerData:
	.db $08 $1a
	.db $07 $16
	.db $06 $12
	.db $05 $0e
	.db $04 $0a
	.db $03 $06
	.db $02 $02
	.db $01 $1e


; All essences spawned. Delay before next state.
@state3Substate2:
	call interactionDecCounter1		; $7ab9
	ret nz			; $7abc
	ld (hl),60 ; [counter1]
	ld a,$01		; $7abf
	ld (wTmpcfc0.genericCutscene.state),a		; $7ac1
	ld a,$20		; $7ac4
	ld (wTmpcfc0.genericCutscene.cfc1),a		; $7ac6
	jp interactionIncState2		; $7ac9


; Essences rotating & moving in
@state3Substate3:
@state3Substate5:
@state3Substate7:
	ld a,(wFrameCounter)		; $7acc
	and $03			; $7acf
	jr nz,@essenceRotationCommon	; $7ad1
	ld hl,wTmpcfc0.genericCutscene.cfc1		; $7ad3
	dec (hl)		; $7ad6
	jr @essenceRotationCommon		; $7ad7


; Essences rotating & moving out
@state3Substate4:
@state3Substate6:
	ld a,(wFrameCounter)		; $7ad9
	and $03			; $7adc
	jr nz,@essenceRotationCommon	; $7ade
	ld hl,wTmpcfc0.genericCutscene.cfc1		; $7ae0
	inc (hl)		; $7ae3

@essenceRotationCommon:
	call interactionDecCounter1		; $7ae4
	ret nz			; $7ae7
	ld (hl),60		; $7ae8
	jp interactionIncState2		; $7aea


; Fadeout as the essences leave the screen
@state3Substate8:
	ld hl,wTmpcfc0.genericCutscene.cfc1		; $7aed
	inc (hl)		; $7af0
	ld a,SND_FADEOUT		; $7af1
	call playSound		; $7af3
	ld a,$04		; $7af6
	call fadeoutToWhiteWithDelay		; $7af8
	jp interactionIncState2		; $7afb


; Waiting for fadeout to end
@state3Substate9:
	ld hl,wTmpcfc0.genericCutscene.cfc1		; $7afe
	inc (hl)		; $7b01
	ld a,(wPaletteThread_mode)		; $7b02
	or a			; $7b05
	ret nz			; $7b06
	call interactionIncState		; $7b07
	inc l			; $7b0a
	ld (hl),$00		; $7b0b
	jp objectSetInvisible		; $7b0d


@state4:
	ld e,Interaction.state2		; $7b10
	ld a,(de)		; $7b12
	rst_jumpTable			; $7b13
	.dw @state4Substate0
	.dw @state4Substate1
	.dw @state4Substate2
	.dw @state4Substate3
	.dw @state4Substate4


; Modifying the room layout so only 1 door remains.
@state4Substate0:
	ld hl,@tileReplacements		; $7b1e
--
	ldi a,(hl)		; $7b21
	or a			; $7b22
	jr z,++			; $7b23
	ld c,(hl)		; $7b25
	inc hl			; $7b26
	push hl			; $7b27
	call setTile		; $7b28
	pop hl			; $7b2b
	jr --		; $7b2c
++
	ld e,Interaction.counter1		; $7b2e
	ld a,30		; $7b30
	ld (de),a		; $7b32
	jp interactionIncState2		; $7b33

; b0: tile position
; b1: tile index
@tileReplacements:
	.db $a3 $33
	.db $a3 $34
	.db $a3 $35
	.db $b7 $43
	.db $b7 $44
	.db $b7 $45
	.db $88 $53
	.db $88 $54
	.db $88 $55
	.db $a3 $39
	.db $a3 $3a
	.db $a3 $3b
	.db $b7 $49
	.db $b7 $4a
	.db $b7 $4b
	.db $88 $59
	.db $88 $5a
	.db $88 $5b
	.db $00


; Delay before fading back in
@state4Substate1:
	call interactionDecCounter1		; $7b5b
	ret nz			; $7b5e
	ld (hl),120		; $7b5f
	ld a,$08		; $7b61
	call fadeinFromWhiteWithDelay		; $7b63
	jp interactionIncState2		; $7b66


; Fading back in
@state4Substate2:
	ld a,(wPaletteThread_mode)		; $7b69
	or a			; $7b6c
	ret nz			; $7b6d
	ld a,SND_SOLVEPUZZLE_2		; $7b6e
	call playSound		; $7b70
	jp interactionIncState2		; $7b73


@state4Substate3:
	call interactionDecCounter1		; $7b76
	ret nz			; $7b79
	call getThisRoomFlags		; $7b7a
	set 6,(hl)		; $7b7d

	; Change the door tile?
	ld hl,wRoomLayout+$47		; $7b7f
	ld (hl),$44		; $7b82

	call checkIsLinkedGame		; $7b84
	jr z,@@unlinkedGame			; $7b87

	call fadeoutToBlack		; $7b89
	jp interactionIncState2		; $7b8c

@@unlinkedGame:
	xor a			; $7b8f
	ld (wMenuDisabled),a		; $7b90
	ld (wDisabledObjects),a		; $7b93
	ld a,(wActiveMusic)		; $7b96
	call playSound		; $7b99
	jp interactionDelete		; $7b9c


; Linked game only: trigger cutscene
@state4Substate4:
	ld a,(wPaletteThread_mode)		; $7b9f
	or a			; $7ba2
	ret nz			; $7ba3
	ld a,CUTSCENE_FLAME_OF_SORROW		; $7ba4
	ld (wCutsceneTrigger),a		; $7ba6
	jp interactionDelete		; $7ba9


interactiond7_essence:
	ld e,Interaction.state		; $7bac
	ld a,(de)		; $7bae
	rst_jumpTable			; $7baf
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $7bb8
	ld (de),a ; [state]
	ld h,d			; $7bbb
	ld l,Interaction.counter1		; $7bbc
	ld (hl),$10		; $7bbe
	ld l,Interaction.speed		; $7bc0
	ld (hl),SPEED_200		; $7bc2
	ld a,SND_POOF		; $7bc4
	call playSound		; $7bc6
	call objectCenterOnTile		; $7bc9
	ld l,Interaction.z		; $7bcc
	xor a			; $7bce
	ldi (hl),a		; $7bcf
	ld (hl),a		; $7bd0
	call interactionInitGraphics		; $7bd1
	jp objectSetVisible80		; $7bd4

@state1:
	call objectApplySpeed		; $7bd7
	call interactionDecCounter1		; $7bda
	ret nz			; $7bdd
	jp interactionIncState		; $7bde

@state2:
	ld a,(wTmpcfc0.genericCutscene.state)		; $7be1
	or a			; $7be4
	ret z			; $7be5
	jp interactionIncState		; $7be6

@state3:
	call objectCheckWithinScreenBoundary		; $7be9
	jp nc,interactionDelete		; $7bec
	ld a,(wFrameCounter)		; $7bef
	rrca			; $7bf2
	ret c			; $7bf3
	ld h,d			; $7bf4
	ld l,Interaction.angle		; $7bf5
	inc (hl)		; $7bf7
	ld a,(hl)		; $7bf8
	and $1f			; $7bf9
	ld (hl),a		; $7bfb
	ld e,l			; $7bfc
	or a			; $7bfd
	call z,@playCirclingSound		; $7bfe
	ld bc,$5878		; $7c01
	ld a,(wTmpcfc0.genericCutscene.cfc1)		; $7c04
	jp objectSetPositionInCircleArc		; $7c07

@playCirclingSound:
	ld a,SND_CIRCLING		; $7c0a
	jp playSound		; $7c0c

;;
; @addr{7c0f}
_interactiond7_updateSmallSparkles:
	ld a,(wFrameCounter)		; $7c0f
	and $07			; $7c12
	ret nz			; $7c14

	ldbc INTERACID_SPARKLE, $03		; $7c15
	call objectCreateInteraction		; $7c18
	ret nz			; $7c1b

	ld a,(wFrameCounter)		; $7c1c
	and $38			; $7c1f
	swap a			; $7c21
	rlca			; $7c23
	ld bc,@sparklePositionOffsets		; $7c24
	call addDoubleIndexToBc		; $7c27
	ld l,Interaction.yh		; $7c2a
	ld a,(bc)		; $7c2c
	add (hl)		; $7c2d
	ld (hl),a		; $7c2e
	inc bc			; $7c2f
	ld l,Interaction.xh		; $7c30
	ld a,(bc)		; $7c32
	add (hl)		; $7c33
	ld (hl),a		; $7c34
	ret			; $7c35

@sparklePositionOffsets:
	.db $10 $02
	.db $10 $fe
	.db $08 $05
	.db $08 $fb
	.db $0c $08
	.db $0c $f8
	.db $06 $0b
	.db $06 $f5

;;
; Updates Z-position based on frame counter.
; @addr{7c46}
_interactiond7_updateFloating:
	ld a,(wFrameCounter)		; $7c46
	and $07			; $7c49
	ret nz			; $7c4b
	ld a,(wFrameCounter)		; $7c4c
	and $38			; $7c4f
	swap a			; $7c51
	rlca			; $7c53
	ld hl,@zPositions		; $7c54
	rst_addAToHl			; $7c57
	ld e,Interaction.zh		; $7c58
	ld a,(hl)		; $7c5a
	ld (de),a		; $7c5b
	ret			; $7c5c

@zPositions:
	.db $ff $fe $ff $00 $01 $02 $01 $00


; ==============================================================================
; INTERACID_LEVER_LAVA_FILLER
;
; Variables:
;   counter2: Number of frames between two lava tiles being filled. Effectively this sets the
;             "speed" of the lava filler (lower is faster).
; ==============================================================================
interactionCoded8:
	ld e,Interaction.state		; $7c65
	ld a,(de)		; $7c67
	rst_jumpTable			; $7c68
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld e,Interaction.subid		; $7c73
	ld a,(de)		; $7c75
	ld hl,@counter2Vals		; $7c76
	rst_addAToHl			; $7c79
	ld a,(hl)		; $7c7a
	ld e,Interaction.counter2		; $7c7b
	ld (de),a		; $7c7d
	jp interactionIncState		; $7c7e

@counter2Vals:
	.db $04 $06 $06 $06 $06 $06 $06 $06


; Waiting for lever to be pulled
@state1:
	ld a,(wLever1PullDistance)		; $7c89
	bit 7,a			; $7c8c
	ret z			; $7c8e

	; Lever has been pulled all the way.

	call interactionIncState		; $7c8f
	ld l,Interaction.counter1		; $7c92
	ld (hl),30		; $7c94

	ld a,SND_SOLVEPUZZLE		; $7c96
	call playSound		; $7c98

	call @loadScriptForSubid		; $7c9b

@toggleLavaSource:
	ld b,$06		; $7c9e
	ld a,TILEINDEX_LAVA_SOURCE_UP_LEFT		; $7ca0
	call findTileInRoom		; $7ca2
	jr z,@setOrUnsetLavaSource	; $7ca5

	ld a,TILEINDEX_LAVA_SOURCE_DOWN_LEFT		; $7ca7
	call findTileInRoom		; $7ca9
	jr z,@setOrUnsetLavaSource	; $7cac

	ld b,$fa		; $7cae
	ld a,TILEINDEX_LAVA_SOURCE_UP_LEFT_EMPTY		; $7cb0
	call findTileInRoom		; $7cb2
	jr z,@setOrUnsetLavaSource	; $7cb5

	ld a,TILEINDEX_LAVA_SOURCE_DOWN_LEFT_EMPTY		; $7cb7
	call findTileInRoom		; $7cb9

; Turns the lava source "on" or "off", visually (by adding or subtracting 6 from the tile index).
@setOrUnsetLavaSource:
	ld a,b			; $7cbc
	ldh (<hFF8D),a	; $7cbd
	call @updateTile		; $7cbf
--
	inc l			; $7cc2
	ld a,(hl)		; $7cc3
	sub TILEINDEX_LAVA_SOURCE_UP_LEFT			; $7cc4
	cp $0c			; $7cc6
	ret nc			; $7cc8
	call @updateTile		; $7cc9
	jr --			; $7ccc

@updateTile:
	ldh a,(<hFF8D)	; $7cce
	ld b,(hl)		; $7cd0
	add b			; $7cd1
	ld c,l			; $7cd2
	push hl			; $7cd3
	call setTile		; $7cd4
	pop hl			; $7cd7
	ret			; $7cd8

@loadScriptForSubid:
	ld e,Interaction.subid		; $7cd9
	ld a,(de)		; $7cdb
	ld hl,@scriptTable		; $7cdc
	rst_addDoubleIndex			; $7cdf
	ldi a,(hl)		; $7ce0
	ld h,(hl)		; $7ce1
	ld l,a			; $7ce2
	jp interactionSetMiniScript		; $7ce3


; Floor is being filled
@state2:
	call interactionDecCounter1		; $7ce6
	ret nz			; $7ce9

	; Fill next group of tiles
	inc l			; $7cea
	ldd a,(hl)
	ld (hl),a  ; [counter1] = [counter2]
	call interactionGetMiniScript		; $7ced
	ldi a,(hl)		; $7cf0
	or a			; $7cf1
	jp z,interactionIncState		; $7cf2

--
	ld c,a			; $7cf5
	ld a,TILEINDEX_DRIED_LAVA		; $7cf6
	push hl			; $7cf8
	call setTileInAllBuffers		; $7cf9
	pop hl			; $7cfc
	ldi a,(hl)		; $7cfd
	or a			; $7cfe
	jr nz,--		; $7cff

	call interactionSetMiniScript		; $7d01
	jp @playRumbleSound		; $7d04


; Tiles have been filled. Waiting for lever to revert to starting position.
@state3:
	ld a,(wLever1PullDistance)		; $7d07
	or a			; $7d0a
	ret nz			; $7d0b

	call interactionIncState		; $7d0c
	call @loadScriptForSubid		; $7d0f
	call @toggleLavaSource		; $7d12
	ld a,SND_DOORCLOSE		; $7d15
	jp playSound		; $7d17


; Tiles are being filled with lava again.
@state4:
	call interactionDecCounter1		; $7d1a
	ret nz			; $7d1d
	inc l			; $7d1e
	ldd a,(hl)		; $7d1f
	ld (hl),a  ; [counter1] = [counter2]
	call interactionGetMiniScript		; $7d21
	ldi a,(hl)		; $7d24
	or a			; $7d25
	jr nz,@fillNextGroupWithLava	; $7d26

	; Done filling the lava back.
	ld e,Interaction.state		; $7d28
	ld a,$01		; $7d2a
	ld (de),a		; $7d2c
	ret			; $7d2d

@fillNextGroupWithLava:
	ld c,a			; $7d2e

	; Random lava tile
	call getRandomNumber		; $7d2f
	and $03			; $7d32
	add TILEINDEX_DUNGEON_LAVA_1			; $7d34

	push hl			; $7d36
	call setTileInAllBuffers		; $7d37
	pop hl			; $7d3a
	ldi a,(hl)		; $7d3b
	or a			; $7d3c
	jr nz,@fillNextGroupWithLava	; $7d3d

	call interactionSetMiniScript		; $7d3f
	jp @playRumbleSound		; $7d42

@playRumbleSound:
	ld a,SND_RUMBLE2		; $7d45
	jp playSound		; $7d47


; "Script" format:
;   A string of bytes, ending with "$00", is a list of tile positions to fill with lava on a frame.
;   The data following the "$00" bytes will be read on a later frame. The gap between frames depends
;   on the value of [counter2].
;   If data starts with "$00", the list is done being read.
@scriptTable:
	.dw @subid0Script
	.dw @subid1Script
	.dw @subid2Script
	.dw @subid3Script
	.dw @subid4Script
	.dw @subid5Script

; D4, 1st lava-filler room
@subid0Script:
	.db $2a $00
	.db $2b $00
	.db $29 $00
	.db $3b $00
	.db $39 $00
	.db $4b $00
	.db $4a $00
	.db $49 $00
	.db $5b $00
	.db $5a $00
	.db $59 $00
	.db $6b $00
	.db $6a $00
	.db $7b $00
	.db $8b $00
	.db $7a $00
	.db $8a $00
	.db $9a $00
	.db $69 $00
	.db $99 $00
	.db $89 $00
	.db $79 $00
	.db $98 $00
	.db $88 $00
	.db $97 $00
	.db $78 $00
	.db $96 $00
	.db $88 $00
	.db $87 $00
	.db $95 $00
	.db $86 $00
	.db $85 $00
	.db $77 $00
	.db $76 $00
	.db $75 $00
	.db $66 $00
	.db $65 $00
	.db $56 $00
	.db $55 $00
	.db $45 $00
	.db $35 $00
	.db $00

; D4, 2 rooms before boss key
@subid1Script:
	.db $77 $78 $79 $00
	.db $7a $69 $68 $67 $66 $76 $00
	.db $6a $65 $75 $00
	.db $64 $74 $00
	.db $84 $85 $00
	.db $94 $95 $00
	.db $83 $93 $00
	.db $82 $92 $00
	.db $81 $91 $00
	.db $71 $72 $00
	.db $61 $62 $00
	.db $51 $52 $00
	.db $41 $42 $00
	.db $31 $32 $00
	.db $21 $22 $00
	.db $11 $12 $00
	.db $13 $23 $00
	.db $14 $24 $00
	.db $34 $00
	.db $44 $00
	.db $35 $45 $00
	.db $36 $00
	.db $46 $00
	.db $47 $26 $00
	.db $16 $27 $48 $00
	.db $28 $38 $49 $00
	.db $29 $39 $00
	.db $00

; D4, 1 room before boss key
@subid2Script:
	.db $37 $38 $39 $00
	.db $47 $48 $49 $00
	.db $58 $59 $00
	.db $68 $00
	.db $67 $00
	.db $77 $00
	.db $87 $00
	.db $96 $00
	.db $85 $00
	.db $75 $00
	.db $55 $64 $00
	.db $56 $00
	.db $73 $45 $00
	.db $83 $35 $00
	.db $25 $00
	.db $92 $15 $00
	.db $81 $00
	.db $71 $00
	.db $61 $00
	.db $51 $00
	.db $42 $00
	.db $33 $00
	.db $13 $22 $00
	.db $21 $00
	.db $00

; D8, lava room with keyblock
@subid3Script:
	.db $24 $25 $26 $00
	.db $34 $35 $36 $00
	.db $44 $45 $46 $00
	.db $54 $55 $00
	.db $64 $65 $00
	.db $73 $74 $75 $00
	.db $83 $00
	.db $81 $82 $00
	.db $91 $92 $00
	.db $93 $00
	.db $94 $00
	.db $95 $00
	.db $96 $00
	.db $86 $00
	.db $77 $87 $97 $00
	.db $78 $88 $00
	.db $79 $89 $99 $00
	.db $7a $8a $9a $00
	.db $6a $00
	.db $5a $00
	.db $59 $00
	.db $58 $00
	.db $48 $00
	.db $00

; D8, other lava room
@subid4Script:
	.db $24 $25 $26 $00
	.db $34 $35 $17 $27 $00
	.db $36 $37 $00
	.db $44 $45 $46 $47 $00
	.db $18 $28 $38 $48 $00
	.db $57 $58 $39 $49 $00
	.db $55 $56 $19 $29 $00
	.db $54 $59 $00
	.db $68 $69 $4a $5a $00
	.db $67 $3a $6a $00
	.db $65 $66 $1a $2a $00
	.db $64 $6b $7a $7b $00
	.db $78 $79 $4b $5b $00
	.db $76 $77 $2b $3b $00
	.db $74 $75 $1b $00
	.db $8a $8b $5c $6c $00
	.db $88 $89 $3c $4c $00
	.db $86 $87 $1c $2c $00
	.db $84 $85 $5d $6d $00
	.db $73 $83 $4d $00
	.db $1d $2d $3d $00
	.db $71 $72 $82 $00
	.db $81 $97 $99 $9b $00
	.db $91 $92 $93 $95 $00
	.db $94 $96 $98 $9a $00
	.db $00

; Hero's Cave lava room
@subid5Script:
	.db $26 $28 $27 $00
	.db $25 $00
	.db $35 $00
	.db $34 $00
	.db $44 $54 $43 $00
	.db $42 $64 $00
	.db $52 $74 $00
	.db $84 $00
	.db $93 $94 $95 $00
	.db $92 $96 $00
	.db $82 $91 $97 $00
	.db $81 $87 $00
	.db $77 $88 $00
	.db $78 $89 $00
	.db $8a $00
	.db $7a $8b $00
	.db $6a $7b $8c $00
	.db $5a $8d $9c $00
	.db $5b $9d $00
	.db $5c $00
	.db $4c $5d $6c $00
	.db $6d $00
	.db $3c $00
	.db $3d $00
	.db $2b $2d $00
	.db $1b $1d $00
	.db $00


; ==============================================================================
; INTERACID_SLATE_SLOT
;
; Variables:
;   var3f: Counter to push against this object until the slate will be placed
; ==============================================================================
interactionCodedb:
	ld e,Interaction.state		; $7f3d
	ld a,(de)		; $7f3f
	rst_jumpTable			; $7f40
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Check if slate already placed
	ld e,Interaction.subid		; $7f47
	ld a,(de)		; $7f49
	ld bc,bitTable		; $7f4a
	add c			; $7f4d
	ld c,a			; $7f4e
	call getThisRoomFlags		; $7f4f
	ld a,(bc)		; $7f52
	and (hl)		; $7f53
	jp nz,interactionDelete		; $7f54

	ld hl,slateSlotScript		; $7f57
	call interactionSetScript		; $7f5a
	jp interactionIncState		; $7f5d

@state1:
	call objectCheckCollidedWithLink_notDead		; $7f60
	call nc,@resetCounter		; $7f63
	call objectCheckLinkPushingAgainstCenter		; $7f66
	call nc,@resetCounter		; $7f69

	ld h,d			; $7f6c
	ld l,Interaction.var3f		; $7f6d
	dec (hl)		; $7f6f
	jr nz,@state2	; $7f70

	; Time to place the slate, if available
	ld a,(wNumSlates)		; $7f72
	or a			; $7f75
	jr nz,@placeSlate	; $7f76

	; Not enough slates
	ld bc,TX_5111		; $7f78
	call showText		; $7f7b

@resetCounter:
	ld e,Interaction.var3f		; $7f7e
	ld a,$0a		; $7f80
	ld (de),a		; $7f82
	ret			; $7f83

@placeSlate:
	call checkLinkVulnerable		; $7f84
	jr nc,@resetCounter	; $7f87

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $7f89
	ld (wDisabledObjects),a		; $7f8b
	ld (wMenuDisabled),a		; $7f8e

	ld hl,slateSlotScript_placeSlate		; $7f91
	call interactionSetScript		; $7f94
	call interactionIncState		; $7f97

@state2:
	call interactionRunScript		; $7f9a
	ret nc			; $7f9d
	jp interactionDelete		; $7f9e

; ==============================================================================
