.include "code/interactionCode/group3.s"


; ==============================================================================
; INTERACID_VASU
;
; Variables:
;   var36: Nonzero if TREASURE_RING_BOX is obtained
;   var37: Nonzero if Link has unappraised rings?
;   var38: Nonzero if Link has rings in the ring list?
; ==============================================================================
interactionCode89:
	ld a,(wTextIsActive)		; $47b5
	or a			; $47b8
	jr nz,++		; $47b9

	; Textboxes are always on the bottom in Vasu's shop
	ld a,$02		; $47bb
	ld (wTextboxPosition),a		; $47bd
	ld a,TEXTBOXFLAG_DONTCHECKPOSITION		; $47c0
	ld (wTextboxFlags),a		; $47c2
++
	call @updateState		; $47c5
	ld e,Interaction.subid		; $47c8
	ld a,(de)		; $47ca
	or a			; $47cb
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects		; $47cc
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $47cf

@updateState:
	ld e,Interaction.state		; $47d2
	ld a,(de)		; $47d4
	rst_jumpTable			; $47d5
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5


; State 0: Initialization of vasu or snake
@state0:
	ld a,$01		; $47e2
	ld (de),a		; $47e4
	call interactionInitGraphics		; $47e5
	call interactionSetAlwaysUpdateBit		; $47e8
	ld a,>TX_3000		; $47eb
	call interactionSetHighTextIndex		; $47ed
	ld e,Interaction.subid		; $47f0
	ld a,(de)		; $47f2
	or a			; $47f3
	jr z,@@initVasu	; $47f4

@@initSnake:
	ld a,$06		; $47f6
	call objectSetCollideRadius		; $47f8
	call objectGetTileCollisions		; $47fb
	ld (hl),$0f		; $47fe
	ld a,(de)		; $4800
	call interactionSetAnimation		; $4801
	ld e,Interaction.pressedAButton		; $4804
	jp objectAddToAButtonSensitiveObjectList		; $4806

@@initVasu:
	ld a,$04		; $4809
	ld e,Interaction.state		; $480b
	ld (de),a		; $480d
	ld hl,vasuScript		; $480e
	jp interactionSetScript		; $4811


; State 1: Snake waiting for Link to talk?
@state1:
	; Hide snake if Link is within a certain distance
	ld c,$18		; $4814
	call objectCheckLinkWithinDistance		; $4816
	ld e,Interaction.subid		; $4819
	ld a,(de)		; $481b
	jp nc,interactionSetAnimation		; $481c

	call interactionAnimate		; $481f
	ld h,d			; $4822
	ld l,Interaction.pressedAButton		; $4823
	ld a,(hl)		; $4825
	or a			; $4826
	ret z			; $4827

	; Linked talked to snake
	xor a			; $4828
	ld (hl),a		; $4829
	inc a			; $482a
	ld (wMenuDisabled),a		; $482b
	ld (wDisabledObjects),a		; $482e

	ld e,l			; $4831
	call objectRemoveFromAButtonSensitiveObjectList		; $4832

	ld h,d			; $4835
	ld l,Interaction.state		; $4836
	ld a,$02		; $4838
	ldd (hl),a		; $483a
	dec l			; $483b
	ld a,(hl)		; $483c
	inc a			; $483d
	jp interactionSetAnimation		; $483e


; State 2: Just talked to snake
@state2:
	call @checkRingBoxAndRingsObtained		; $4841
	call interactionAnimate		; $4844
	ld e,Interaction.subid		; $4847
	ld a,(de)		; $4849
	and $04			; $484a
	ld b,a			; $484c
	ld c,$00		; $484d
	ld e,Interaction.var36		; $484f
	ld a,(de)		; $4851
	or a			; $4852
	jr z,@loadPrelinkedScript	; $4853

	ld a,GLOBALFLAG_FINISHEDGAME		; $4855
	call checkGlobalFlag		; $4857
	jr nz,@loadLinkedScript	; $485a

	ld hl,wFileIsLinkedGame		; $485c
	ldi a,(hl)		; $485f
	or (hl)			; $4860
	jr nz,@loadLinkedScript	; $4861

@loadPrelinkedScript:
	ld c,$02		; $4863
@loadLinkedScript:
	ld a,b			; $4865
	add c			; $4866
	ld hl,@scriptTable		; $4867
	rst_addAToHl			; $486a
	ldi a,(hl)		; $486b
	ld h,(hl)		; $486c
	ld l,a			; $486d

@setScriptAndGotoState4:
	call interactionSetScript		; $486e
	ld e,Interaction.state		; $4871
	ld a,$04		; $4873
	ld (de),a		; $4875
	ret			; $4876

@scriptTable:
	.dw blueSnakeScript_linked
	.dw blueSnakeScript_preLinked
	.dw redSnakeScript_linked
	.dw redSnakeScript_preLinked


; State 3: Cleaning up after a script?
@state3:
	call interactionAnimate		; $487f
	ld e,Interaction.animParameter		; $4882
	ld a,(de)		; $4884
	or a			; $4885
	ret z			; $4886

	xor a			; $4887
	ld (wMenuDisabled),a		; $4888
	ld e,Interaction.state		; $488b
	ld a,$01		; $488d
	ld (de),a		; $488f
	ld e,Interaction.subid		; $4890

	; For snakes only, reset animation, do stuff with A button?
	ld a,(de)		; $4892
	or a			; $4893
	ret z			; $4894
	call interactionSetAnimation		; $4895
	ld e,Interaction.pressedAButton		; $4898
	jp objectAddToAButtonSensitiveObjectList		; $489a


; State 4: Running script for Vasu or snake
@state4:
	call @checkRingBoxAndRingsObtained		; $489d
	call interactionAnimate		; $48a0
	call interactionRunScript		; $48a3
	ret nc			; $48a6

	; Script finished
	xor a			; $48a7
	ld (wMenuDisabled),a		; $48a8
	ld (wDisabledObjects),a		; $48ab

	; If this is a snake, set the animation, revert to state 3?
	ld e,Interaction.subid		; $48ae
	ld a,(de)		; $48b0
	or a			; $48b1
	ret z			; $48b2

	add $02			; $48b3
	call interactionSetAnimation		; $48b5

	ld e,Interaction.state		; $48b8
	ld a,$03		; $48ba
	ld (de),a		; $48bc
	ret			; $48bd


; State 5: Linking with blue snake?
@state5:
	call interactionAnimate		; $48be
	ld e,Interaction.state2		; $48c1
	ld a,(de)		; $48c3
	rst_jumpTable			; $48c4
	.dw @state5Substate0
	.dw @state5Substate1
	.dw @state5Substate2
	.dw @state5Substate3
	.dw @state5Substate4

@state5Substate0:
	call retIfTextIsActive		; $48cf
	call interactionIncState2		; $48d2
	xor a			; $48d5
	ld l,Interaction.counter1		; $48d6
	ld (hl),a		; $48d8
	ld l,Interaction.counter2		; $48d9
	ld (hl),$02		; $48db
	ld a,$04		; $48dd
	jp interactionSetAnimation		; $48df

@state5Substate1:
	call interactionDecCounter1		; $48e2
	jr nz,@label_0a_036	; $48e5
	inc l			; $48e7
	dec (hl)		; $48e8
	jr nz,@label_0a_036	; $48e9
	xor a			; $48eb
	ld ($ff00+R_SB),a	; $48ec
	ld hl,blueSnakeExitScript_cableNotConnected		; $48ee
	ld b,$80		; $48f1
	jr @setBlueSnakeExitScript		; $48f3

@label_0a_036:
	ldh a,(<hSerialInterruptBehaviour)	; $48f5
	or a			; $48f7
	jp z,serialFunc_0c73		; $48f8

	and $01			; $48fb
	add $01			; $48fd
	ldh (<hFFBE),a	; $48ff
	call interactionIncState2		; $4901

	ld l,Interaction.counter1		; $4904
	ld (hl),180		; $4906
	ld bc,TX_3030		; $4908
	jp showTextNonExitable		; $490b

@state5Substate2:
	call serialFunc_0c8d		; $490e
	ldh a,(<hSerialInterruptBehaviour)	; $4911
	or a			; $4913
	ret nz			; $4914

	ld a,($ff00+R_SVBK)	; $4915
	push af			; $4917
	ld a,:w4RingFortuneStuff		; $4918
	ld ($ff00+R_SVBK),a	; $491a
	ldh a,(<hFFBD)	; $491c
	ld b,a			; $491e
	ld a,($cbc2)		; $491f
	ld e,a			; $4922
	ld a,(w4RingFortuneStuff)		; $4923
	ld c,a			; $4926

	pop af			; $4927
	ld ($ff00+R_SVBK),a	; $4928

	ld a,b			; $492a
	or e			; $492b
	jr nz,@blueSnakeErrorCondition	; $492c

	; Put 'c' into var3a (ring to get from fortune)
	ld e,Interaction.var3a		; $492e
	ld a,c			; $4930
	ld (de),a		; $4931
	call interactionDecCounter1		; $4932
	ret nz			; $4935
	ld hl,blueSnakeScript_successfulFortune		; $4936
	jr @setBlueSnakeExitScript		; $4939

@blueSnakeErrorCondition:
	ld hl,blueSnakeScript_doNotRemoveCable		; $493b
	ld a,e			; $493e
	cp $8f			; $493f
	jr z,@setBlueSnakeExitScript	; $4941
	ld hl,blueSnakeExitScript_noValidFile		; $4943
	cp $85			; $4946
	jr z,@setBlueSnakeExitScript	; $4948
	ld hl,blueSnakeExitScript_linkFailed		; $494a

@setBlueSnakeExitScript:
	xor a			; $494d
	ld (wDisabledObjects),a		; $494e
	call @setScriptAndGotoState4		; $4951
	ld a,$02		; $4954
	jp interactionSetAnimation		; $4956

@state5Substate3:
	call retIfTextIsActive		; $4959

	; Open linking menu
	ld a,$08		; $495c
	call openMenu		; $495e
	jp interactionIncState2		; $4961

@state5Substate4:
	ld a,($ff00+R_SVBK)	; $4964
	push af			; $4966
	ld a,:w4RingFortuneStuff		; $4967
	ld ($ff00+R_SVBK),a	; $4969

	ldh a,(<hFFBD)	; $496b
	ld b,a			; $496d
	ld a,($cbc2)		; $496e
	ld e,a			; $4971

	pop af			; $4972
	ld ($ff00+R_SVBK),a	; $4973

	ld a,b			; $4975
	or e			; $4976
	jr nz,@blueSnakeErrorCondition	; $4977

	ld hl,blueSnakeScript_successfulRingTransfer		; $4979
	jr @setBlueSnakeExitScript		; $497c


; Populates var36, var37, var38 as described in the variable list.
@checkRingBoxAndRingsObtained:
	ld a,TREASURE_RING_BOX		; $497e
	call checkTreasureObtained		; $4980
	ld a,$00		; $4983
	rla			; $4985
	ld e,Interaction.var36		; $4986
	ld (de),a		; $4988

	ld a,(wNumUnappraisedRingsBcd)		; $4989
	inc e			; $498c
	ld (de),a		; $498d
	ld hl,wRingsObtained		; $498e
	ld b,$08		; $4991
	xor a			; $4993
@@nextRing:
	or (hl)			; $4994
	inc l			; $4995
	dec b			; $4996
	jr nz,@@nextRing	; $4997
	inc e			; $4999
	ld (de),a		; $499a
	ret			; $499b


; ==============================================================================
; INTERACID_BUBBLE
;
; Variables:
;   var30: Value to add to angle
;   var31: Number of times to add [var30] to angle before switching direction
; ==============================================================================
interactionCode91:
	ld e,Interaction.subid		; $499c
	ld a,(de)		; $499e
	or a			; $499f
	ld e,Interaction.state		; $49a0
	ld a,(de)		; $49a2
	jp nz,@subid01		; $49a3

@subid00:
	or a			; $49a6
	jr z,@@state0		; $49a7

@@state1:
	call @checkDelete		; $49a9
	jp c,interactionDelete		; $49ac

	call objectApplySpeed		; $49af
	ld e,Interaction.yh		; $49b2
	ld a,(de)		; $49b4
	cp $f0			; $49b5
	jp nc,interactionDelete		; $49b7

	call interactionDecCounter1		; $49ba
	ret nz			; $49bd

	ld (hl),$04		; $49be
	ld l,Interaction.var31		; $49c0
	dec (hl)		; $49c2
	jr nz,++		; $49c3

	ld (hl),$08		; $49c5
	ld l,Interaction.var30		; $49c7
	ld a,(hl)		; $49c9
	cpl			; $49ca
	inc a			; $49cb
	ld (hl),a		; $49cc
++
	ld e,Interaction.angle		; $49cd
	ld a,(de)		; $49cf
	ld l,Interaction.var30		; $49d0
	add (hl)		; $49d2
	and $1f			; $49d3
	ld (de),a		; $49d5
	ret			; $49d6

@@state0:
	call @checkDelete		; $49d7
	jp c,interactionDelete		; $49da

	call interactionInitGraphics		; $49dd
	call interactionIncState		; $49e0
	ld l,Interaction.speed		; $49e3
	ld (hl),SPEED_80		; $49e5

	ld l,Interaction.counter1		; $49e7
	ld a,$04		; $49e9
	ldi (hl),a		; $49eb
	ld (hl),180 ; [counter2] = 180

	ld l,Interaction.var31		; $49ee
	inc a			; $49f0
	ldd (hl),a		; $49f1
	call getRandomNumber		; $49f2
	and $01			; $49f5
	jr nz,+			; $49f7
	dec a			; $49f9
+
	ld (hl),a		; $49fa
	ld a,(wTilesetFlags)		; $49fb
	and TILESETFLAG_SIDESCROLL			; $49fe
	jp nz,objectSetVisible83		; $4a00

@randomNumberFrom0To4:
	call getRandomNumber_noPreserveVars		; $4a03
	and $07			; $4a06
	cp $05			; $4a08
	jr nc,@randomNumberFrom0To4	; $4a0a

	; Set random initial angle
	sub $02			; $4a0c
	and $1f			; $4a0e
	ld e,Interaction.angle		; $4a10
	ld (de),a		; $4a12
	jp objectSetVisible81		; $4a13

@subid01:
	or a			; $4a16
	jr z,@@state0		; $4a17

@@state1:
	ld a,Object.collisionType		; $4a19
	call objectGetRelatedObject1Var		; $4a1b
	bit 7,(hl)		; $4a1e
	jp z,interactionDelete		; $4a20
	call objectTakePosition		; $4a23
	call interactionDecCounter1		; $4a26
	ret nz			; $4a29
	ld (hl),90		; $4a2a
	ld b,INTERACID_BUBBLE		; $4a2c
	jp objectCreateInteractionWithSubid00		; $4a2e

@@state0:
	call interactionIncState		; $4a31
	ld l,Interaction.counter1		; $4a34
	ld (hl),30		; $4a36
	ret			; $4a38

;;
; @param[out]	cflag	c if bubble should be deleted (no longer in water)
; @addr{4a39}
@checkDelete:
	ld a,(wTilesetFlags)		; $4a39
	and TILESETFLAG_SIDESCROLL			; $4a3c
	jp nz,@@sidescrolling		; $4a3e

@@topDown:
	call interactionDecCounter2		; $4a41
	ld a,(hl)		; $4a44
	cp 60			; $4a45
	ret nc			; $4a47
	or a			; $4a48
	scf			; $4a49
	ret z			; $4a4a

	; In last 60 frames, flicker
	ld l,Interaction.visible		; $4a4b
	ld a,(hl)		; $4a4d
	xor $80			; $4a4e
	ld (hl),a		; $4a50
	ret			; $4a51

@@sidescrolling:
	; Check if it's still in water
	call objectGetTileAtPosition		; $4a52
	ld hl,hazardCollisionTable		; $4a55
	call lookupCollisionTable		; $4a58
	ccf			; $4a5b
	ret			; $4a5c


; ==============================================================================
; INTERACID_COMPANION_SPAWNER
; ==============================================================================
interactionCode67:
	ld e,Interaction.subid		; $4a5d
	ld a,(de)		; $4a5f
	cp $06			; $4a60
	jr z,@label_0a_045	; $4a62
	ld a,(de)		; $4a64
	rlca			; $4a65
	jr c,@fluteCall	; $4a66
	ld a,(w1Companion.enabled)		; $4a68
	or a			; $4a6b
	jp nz,@deleteSelf		; $4a6c

@label_0a_045:
	ld a,(de)		; $4a6f
	rst_jumpTable			; $4a70
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05

@fluteCall:
	ld a,(w1Companion.enabled)		; $4a7d
	or a			; $4a80
	jr z,@label_0a_047	; $4a81

	; If there's already something in the companion slot, continue if it's the
	; minecart or anything past moosh (maple, raft).
	; But there's a check later that will prevent the companion from spawning if this
	; slot is in use...
	ld a,(w1Companion.id)		; $4a83
	cp SPECIALOBJECTID_MOOSH+1			; $4a86
	jr nc,@label_0a_047	; $4a88
	cp SPECIALOBJECTID_MINECART			; $4a8a
	jp nz,@deleteSelf		; $4a8c

@label_0a_047:
	ld a,(wTilesetFlags)		; $4a8f
	and (TILESETFLAG_PAST | TILESETFLAG_OUTDOORS)			; $4a92
	cp TILESETFLAG_OUTDOORS			; $4a94
	jp nz,@deleteSelf		; $4a96

	; In the past or indoors; "Your song just echoes..."
	ld bc,TX_510f		; $4a99
	ld a,(wFluteIcon)		; $4a9c
	or a			; $4a9f
	jp z,@showTextAndDelete		; $4aa0

	; If in the present, check if companion is callable in this room
	ld a,(wActiveRoom)		; $4aa3
	ld hl,companionCallableRooms		; $4aa6
	call checkFlag		; $4aa9
	jp z,@fluteSongFellFlat		; $4aac

	; Don't call companion if the slot is in use already
	ld a,(w1Companion.enabled)		; $4aaf
	or a			; $4ab2
	jp nz,@deleteSelf		; $4ab3

	; [var3e/var3f] = Link's position
	ld e,Interaction.var3e		; $4ab6
	ld hl,w1Link.yh		; $4ab8
	ldi a,(hl)		; $4abb
	and $f0			; $4abc
	ld (de),a		; $4abe
	inc l			; $4abf
	inc e			; $4ac0
	ld a,(hl)		; $4ac1
	swap a			; $4ac2
	and $0f			; $4ac4
	ld (de),a		; $4ac6

	; Try various things to determine where companion should enter from?

	; Try from top at Link's x position
	ld hl,wRoomCollisions		; $4ac7
	rst_addAToHl			; $4aca
	call @checkVerticalCompanionSpawnPosition		; $4acb
	ld b,-$08		; $4ace
	ld l,c			; $4ad0
	ld h,$10		; $4ad1
	ld a,DIR_DOWN		; $4ad3
	jr z,@setCompanionDestination	; $4ad5

	; Try from bottom at Link's x
	ld e,Interaction.var3f		; $4ad7
	ld a,(de)		; $4ad9
	ld hl,wRoomCollisions+$60		; $4ada
	rst_addAToHl			; $4add
	call @checkVerticalCompanionSpawnPosition		; $4ade
	ld b,SMALL_ROOM_HEIGHT*$10+8		; $4ae1
	ld l,c			; $4ae3
	ld h,SMALL_ROOM_HEIGHT*$10-$10		; $4ae4
	ld a,DIR_UP		; $4ae6
	jr z,@setCompanionDestination	; $4ae8

	; Try from right at Link's y
	ld e,Interaction.var3e		; $4aea
	ld a,(de)		; $4aec
	ld hl,wRoomCollisions+$08		; $4aed
	rst_addAToHl			; $4af0
	call @checkHorizontalCompanionSpawnPosition		; $4af1
	ld c,SMALL_ROOM_WIDTH*$10+8		; $4af4
	ld h,b			; $4af6
	ld l,SMALL_ROOM_WIDTH*$10-$10		; $4af7
	ld a,DIR_LEFT		; $4af9
	jr z,@setCompanionDestination	; $4afb

	; Try from left at Link's y
	ld e,Interaction.var3e		; $4afd
	ld a,(de)		; $4aff
	ld hl,wRoomCollisions		; $4b00
	rst_addAToHl			; $4b03
	call @checkHorizontalCompanionSpawnPosition		; $4b04
	ld c,-$08		; $4b07
	ld h,b			; $4b09
	ld l,$10		; $4b0a
	ld a,DIR_RIGHT		; $4b0c
	jr z,@setCompanionDestination	; $4b0e

	; Try from top at range of x positions
	ld hl,wRoomCollisions+$03		; $4b10
	call @checkCompanionSpawnColumnRange		; $4b13
	ld b,-$08		; $4b16
	ld l,c			; $4b18
	ld h,$10		; $4b19
	ld a,DIR_DOWN		; $4b1b
	jr nz,@setCompanionDestination	; $4b1d

	; Try from bottom at range of x positions
	ld hl,wRoomCollisions+$63		; $4b1f
	call @checkCompanionSpawnColumnRange		; $4b22
	ld b,SMALL_ROOM_HEIGHT*$10+8		; $4b25
	ld l,c			; $4b27
	ld h,SMALL_ROOM_HEIGHT*$10-$10		; $4b28
	ld a,DIR_UP		; $4b2a
	jr nz,@setCompanionDestination	; $4b2c

	; Try from right at range of y positions
	ld hl,wRoomCollisions+$28		; $4b2e
	call @checkCompanionSpawnRowRange		; $4b31
	ld c,SMALL_ROOM_WIDTH*$10+8		; $4b34
	ld h,b			; $4b36
	ld l,SMALL_ROOM_WIDTH*$10-$10		; $4b37
	ld a,DIR_LEFT		; $4b39
	jr nz,@setCompanionDestination	; $4b3b

	; Try from left at range of y positions
	ld hl,wRoomCollisions+$20		; $4b3d
	call @checkCompanionSpawnRowRange		; $4b40
	ld c,$f8		; $4b43
	ld h,b			; $4b45
	ld l,$10		; $4b46
	ld a,DIR_RIGHT		; $4b48
	jr z,@fluteSongFellFlat	; $4b4a


; @param	a	Direction companion should move in
; @param	bc	Initial Y/X position
; @param	hl	Y/X destination
@setCompanionDestination:
	push de			; $4b4c
	push hl			; $4b4d
	pop de			; $4b4e
	ld hl,wLastAnimalMountPointY		; $4b4f
	ld (hl),d		; $4b52
	inc l			; $4b53
	ld (hl),e		; $4b54
	pop de			; $4b55

	ld hl,w1Companion.direction		; $4b56
	ldi (hl),a		; $4b59
	swap a			; $4b5a
	rrca			; $4b5c
	ldi (hl),a		; $4b5d

	inc l			; $4b5e
	ld (hl),b		; $4b5f
	ld l,SpecialObject.xh		; $4b60
	ld (hl),c		; $4b62

	ld l,SpecialObject.enabled		; $4b63
	inc (hl)		; $4b65
	inc l			; $4b66
	ld a,(wAnimalCompanion)		; $4b67
	ldi (hl),a ; [SpecialObject.id]

	; State $0c = entering screen from flute call
	ld l,SpecialObject.state		; $4b6b
	ld a,$0c		; $4b6d
	ld (hl),a		; $4b6f
	jr @deleteSelf		; $4b70


@fluteSongFellFlat:
	ld bc,TX_510c		; $4b72

@showTextAndDelete:
	ld a,(wTextIsActive)		; $4b75
	or a			; $4b78
	call z,showText		; $4b79

@deleteSelf:
	jp interactionDelete		; $4b7c


; Moosh being attacked by ghosts
@subid00:
	ld hl,wMooshState		; $4b7f
	ld a,(wEssencesObtained)		; $4b82
	bit 1,a			; $4b85
	jr z,@deleteSelf	; $4b87
	ld a,(wPastRoomFlags+$79)		; $4b89
	bit 6,a			; $4b8c
	jr z,@deleteSelf	; $4b8e
	ld a,TREASURE_CHEVAL_ROPE		; $4b90
	call checkTreasureObtained		; $4b92
	jr nc,@loadCompanionPresetIfHasntLeft	; $4b95
	jr @deleteSelf		; $4b97


; Moosh saying goodbye after getting cheval rope
@subid01:
	ld hl,wMooshState		; $4b99
	ld a,$40		; $4b9c
	and (hl)		; $4b9e
	jr nz,@deleteSelf	; $4b9f
	ld a,TREASURE_CHEVAL_ROPE		; $4ba1
	call checkTreasureObtained		; $4ba3
	jr c,@loadCompanionPresetIfHasntLeft	; $4ba6

@deleteSelf2:
	jr @deleteSelf		; $4ba8


; Dimitri being attacked by hungry tokays
@subid03:
	ld hl,wDimitriState		; $4baa
	ld a,(wEssencesObtained)		; $4bad
	bit 2,a			; $4bb0
	jr z,@deleteSelf	; $4bb2
	jr @loadCompanionPresetIfHasntLeft		; $4bb4


; Ricky looking for gloves
@subid02:
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON		; $4bb6
	call checkGlobalFlag		; $4bb8
	jr z,@deleteSelf	; $4bbb
	ld hl,wRickyState		; $4bbd
	jr @loadCompanionPresetIfHasntLeft		; $4bc0


; Companion lost in forest
@subid04:
	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST		; $4bc2
	call checkGlobalFlag		; $4bc4
	jr z,@deleteSelf	; $4bc7
	jr @label_0a_052		; $4bc9


; Cutscene outside forest where you get the flute
@subid05:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $4bcb
	call checkGlobalFlag		; $4bcd
	jr z,@deleteSelf	; $4bd0
@label_0a_052:
	ld a,GLOBALFLAG_GOT_FLUTE		; $4bd2
	call checkGlobalFlag		; $4bd4
	jr nz,@deleteSelf	; $4bd7
	jr @loadCompanionPreset		; $4bd9


@loadCompanionPresetIfHasntLeft:
	; This bit of the companion's state is set if he's left after his sidequest
	ld a,(hl)		; $4bdb
	and $40			; $4bdc
	jr nz,@deleteSelf2	; $4bde

; Load a companion's ID and position from a table of presets based on subid.
@loadCompanionPreset:
	ld e,Interaction.subid		; $4be0
	ld a,(de)		; $4be2
	add a			; $4be3
	ld hl,@presetCompanionData		; $4be4
	rst_addDoubleIndex			; $4be7

	ld bc,w1Companion.enabled		; $4be8
	ld a,$01		; $4beb
	ld (bc),a		; $4bed

	; Get companion, either from the table, or from wAnimalCompanion
	inc c			; $4bee
	ldi a,(hl)		; $4bef
	or a			; $4bf0
	jr nz,+			; $4bf1
	ld a,(wAnimalCompanion)		; $4bf3
+
	ld (bc),a		; $4bf6

	; Set Y/X
	ld c,SpecialObject.yh		; $4bf7
	ldi a,(hl)		; $4bf9
	ld (bc),a		; $4bfa
	ld (wLastAnimalMountPointY),a		; $4bfb
	ld c,SpecialObject.xh		; $4bfe
	ldi a,(hl)		; $4c00
	ld (bc),a		; $4c01
	ld (wLastAnimalMountPointX),a		; $4c02

	xor a			; $4c05
	ld (wRememberedCompanionId),a		; $4c06
	jr @deleteSelf2		; $4c09

;;
; Check if the first 2 tiles near the edge of the screen are walkable for a companion.
;
; @param	hl	Address in wRoomCollisions to start at
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	z if the companion can spawn from there
; @addr{4c0b}
@checkVerticalCompanionSpawnPosition:
	ld b,$10		; $4c0b
	jr ++			; $4c0d

;;
; @param	hl	Address in wRoomCollisions to start at
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	z if the companion can spawn from there
; @addr{4c0b}
@checkHorizontalCompanionSpawnPosition:
	ld b,$01		; $4c0f
++
	ld a,(hl)		; $4c11
	or a			; $4c12
	ret nz			; $4c13
	ld a,l			; $4c14
	add b			; $4c15
	ld l,a			; $4c16
	ld a,(hl)		; $4c17
	or a			; $4c18
	ld a,l			; $4c19
	ret nz			; $4c1a
	call convertShortToLongPosition		; $4c1b
	xor a			; $4c1e
	ret			; $4c1f

;;
; Checks the given column and up to the following 3 after for if the companion can spawn
; there.
;
; @param	hl	Starting position to check (also checks 3 rows/columns after)
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	nz if valid position to spawn from found
; @addr{4c20}
@checkCompanionSpawnColumnRange:
	push de			; $4c20
	ld b,$01		; $4c21
	ld e,$10		; $4c23
	jr ++			; $4c25

;;
; @param	hl	Starting position to check (also checks 3 rows/columns after)
; @param[out]	bc	Position to spawn at
; @param[out]	zflag	nz if valid position to spawn from found
; @addr{4c27}
@checkCompanionSpawnRowRange:
	push de			; $4c27
	ld b,$10		; $4c28
	ld e,$01		; $4c2a
++
	ld c,$04		; $4c2c

@@nextRowOrColumn:
	ld a,(hl)		; $4c2e
	or a			; $4c2f
	jr z,@@tryThisRowOrColumn	; $4c30

@@resumeSearch:
	ld a,l			; $4c32
	add b			; $4c33
	ld l,a			; $4c34
	dec c			; $4c35
	jr nz,@@nextRowOrColumn	; $4c36

	pop de			; $4c38
	ret			; $4c39

@@tryThisRowOrColumn:
	ld a,l			; $4c3a
	add e			; $4c3b
	ld l,a			; $4c3c
	ld a,(hl)		; $4c3d
	or a			; $4c3e
	ld a,l			; $4c3f
	jr z,@@foundRowOrColumn	; $4c40
	sub e			; $4c42
	ld l,a			; $4c43
	jr @@resumeSearch		; $4c44

@@foundRowOrColumn:
	call convertShortToLongPosition		; $4c46
	or d			; $4c49
	pop de			; $4c4a
	ret			; $4c4b


; Data format:
;   b0: Companion ID (or $00 to use wAnimalCompanion)
;   b1: Y-position to spawn at
;   b2: X-position to spawn at
;   b3: Unused
@presetCompanionData:
	.db SPECIALOBJECTID_MOOSH,   $28, $58, $00 ; $00 == [subid]
	.db SPECIALOBJECTID_MOOSH,   $48, $38, $00 ; $01
	.db SPECIALOBJECTID_RICKY,   $40, $50, $00 ; $02
	.db SPECIALOBJECTID_DIMITRI, $48, $30, $00 ; $03
	.db $00,                     $58, $50, $00 ; $04
	.db $00,                     $48, $68, $00 ; $05


.include "build/data/companionCallableRooms.s"


; ==============================================================================
; INTERACID_ROSA
; ==============================================================================
interactionCode68:
	ld e,Interaction.subid		; $4c84
	ld a,(de)		; $4c86
	rst_jumpTable			; $4c87
	.dw @subid00
	.dw @subid01

@subid00:
	call checkInteractionState		; $4c8c
	jr nz,@@state1	; $4c8f

@@state0:
	call checkIsLinkedGame		; $4c91
	jp z,interactionDelete		; $4c94

	ld a,(wEssencesObtained)		; $4c97
	bit 2,a			; $4c9a
	jp nz,interactionDelete		; $4c9c

	call @initGraphicsAndLoadScript		; $4c9f
	call objectSetVisiblec2		; $4ca2
	call getThisRoomFlags		; $4ca5
	bit 6,a			; $4ca8
	jr nz,@@alreadyGaveShovel		; $4caa

	; Spawn shovel object
	call getFreeInteractionSlot		; $4cac
	ret nz			; $4caf
	ld (hl),INTERACID_MISCELLANEOUS_1		; $4cb0
	inc l			; $4cb2
	ld (hl),$09		; $4cb3
	ld l,Interaction.relatedObj1+1		; $4cb5
	ld a,d			; $4cb7
	ld (hl),a		; $4cb8
	ret			; $4cb9

@@alreadyGaveShovel:
	ld hl,rosa_subid00Script_alreadyGaveShovel		; $4cba
	jp interactionSetScript		; $4cbd

@@state1:
	call interactionRunScript		; $4cc0
	ld a,TREASURE_SHOVEL		; $4cc3
	call checkTreasureObtained		; $4cc5
	jp c,npcFaceLinkAndAnimate		; $4cc8
	jp interactionAnimateAsNpc		; $4ccb


@subid01:
	call checkInteractionState		; $4cce
	jr nz,@@state1	; $4cd1

@@state0:
	call @loadScriptFromTableAndInitGraphics		; $4cd3
	ld l,Interaction.var37		; $4cd6
	ld (hl),$04		; $4cd8
	call interactionRunScript		; $4cda
@@state1:
	call interactionRunScript		; $4cdd
	jp c,interactionDelete		; $4ce0
	jp npcFaceLinkAndAnimate		; $4ce3


; Unused
@initGraphicsAndIncState:
	call interactionInitGraphics		; $4ce6
	call objectMarkSolidPosition		; $4ce9
	jp interactionIncState		; $4cec

@initGraphicsAndLoadScript:
	call interactionInitGraphics		; $4cef
	call objectMarkSolidPosition		; $4cf2
	jr @loadScriptAndIncState		; $4cf5


@loadScriptFromTableAndInitGraphics:
	call interactionInitGraphics		; $4cf7
	call objectMarkSolidPosition		; $4cfa
	jr @loadScriptFromTableAndIncState		; $4cfd

@loadScriptAndIncState:
	call @getScript		; $4cff
	call interactionSetScript		; $4d02
	jp interactionIncState		; $4d05

@loadScriptFromTableAndIncState:
	call @getScript		; $4d08
	inc e			; $4d0b
	ld a,(de)		; $4d0c
	rst_addDoubleIndex			; $4d0d
	ldi a,(hl)		; $4d0e
	ld h,(hl)		; $4d0f
	ld l,a			; $4d10
	call interactionSetScript		; $4d11
	jp interactionIncState		; $4d14

@getScript:
	ld a,>TX_1c00		; $4d17
	call interactionSetHighTextIndex		; $4d19
	ld e,Interaction.subid		; $4d1c
	ld a,(de)		; $4d1e
	ld hl,@scriptTable		; $4d1f
	rst_addDoubleIndex			; $4d22
	ldi a,(hl)		; $4d23
	ld h,(hl)		; $4d24
	ld l,a			; $4d25
	ret			; $4d26

@scriptTable:
	.dw rosa_subid00Script
	.dw @scriptTable2

@scriptTable2:
	.dw rosa_subid01Script


; ==============================================================================
; INTERACID_RAFTON
;
; Variables:
;   var38: "behaviour" (what he does based on the stage in the game)
; ==============================================================================
interactionCode69:
	ld e,Interaction.state		; $4d2d
	ld a,(de)		; $4d2f
	rst_jumpTable			; $4d30
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4d35
	ld (de),a		; $4d37

	; Bit 7 of room flags set when Rafton isn't in this room?
	call getThisRoomFlags		; $4d38
	bit 7,a			; $4d3b
	jp nz,interactionDelete		; $4d3d

	call interactionInitGraphics		; $4d40
	call objectSetVisiblec2		; $4d43
	ld a,>TX_2700		; $4d46
	call interactionSetHighTextIndex		; $4d48

	ld e,Interaction.subid		; $4d4b
	ld a,(de)		; $4d4d
	rst_jumpTable			; $4d4e
	.dw @initSubid00
	.dw @initSubid01

@initSubid00:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS		; $4d53
	call checkGlobalFlag		; $4d55
	jp nz,interactionDelete		; $4d58
	ld c,$04		; $4d5b
	ld a,TREASURE_ISLAND_CHART		; $4d5d
	call checkTreasureObtained		; $4d5f
	jr c,@setBehaviour	; $4d62

	dec c			; $4d64
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON		; $4d65
	call checkGlobalFlag		; $4d67
	jr nz,@setBehaviour	; $4d6a

	dec c			; $4d6c
	ld a,TREASURE_CHEVAL_ROPE		; $4d6d
	call checkTreasureObtained		; $4d6f
	jr c,@setBehaviour	; $4d72

	dec c			; $4d74
	ld a,(wEssencesObtained)		; $4d75
	bit 1,a			; $4d78
	jr nz,@setBehaviour	; $4d7a
	dec c			; $4d7c

@setBehaviour:
	ld h,d			; $4d7d
	ld l,Interaction.var38		; $4d7e
	ld (hl),c		; $4d80
	jr @loadScript		; $4d81


@initSubid01:
	ld a,GLOBALFLAG_RAFTON_CHANGED_ROOMS		; $4d83
	call checkGlobalFlag		; $4d85
	jp z,interactionDelete		; $4d88
	jr @loadScript		; $4d8b


@state1:
	ld e,Interaction.subid		; $4d8d
	ld a,(de)		; $4d8f
	rst_jumpTable			; $4d90
	.dw @runSubid00
	.dw @runSubid01

@runSubid00:
	call interactionRunScript		; $4d95
	jp c,interactionDelete		; $4d98

	ld e,Interaction.var38		; $4d9b
	ld a,(de)		; $4d9d
	cp $04			; $4d9e
	jp z,interactionAnimateBasedOnSpeed		; $4da0
	jp interactionAnimateAsNpc		; $4da3

@runSubid01:
	call interactionAnimateAsNpc		; $4da6
	jp interactionRunScript		; $4da9

@loadScript:
	ld e,Interaction.subid		; $4dac
	ld a,(de)		; $4dae
	ld hl,@scriptTable		; $4daf
	rst_addDoubleIndex			; $4db2
	ldi a,(hl)		; $4db3
	ld h,(hl)		; $4db4
	ld l,a			; $4db5
	jp interactionSetScript		; $4db6

@scriptTable:
	.dw rafton_subid00Script
	.dw rafton_subid01Script


; ==============================================================================
; INTERACID_CHEVAL
; ==============================================================================
interactionCode6a:
	ld e,Interaction.state		; $4dbd
	ld a,(de)		; $4dbf
	rst_jumpTable			; $4dc0
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4dc5
	ld (de),a		; $4dc7
	call interactionInitGraphics		; $4dc8
	call objectSetVisiblec2		; $4dcb
	ld a,>TX_2700		; $4dce
	call interactionSetHighTextIndex		; $4dd0

	ld e,Interaction.subid		; $4dd3
	ld a,(de)		; $4dd5
	rst_jumpTable			; $4dd6
	.dw @loadScript

@state1:
	ld e,Interaction.subid		; $4dd9
	ld a,(de)		; $4ddb
	rst_jumpTable			; $4ddc
	.dw @runSubid00

@runSubid00:
	call interactionRunScript		; $4ddf
	jp interactionAnimateAsNpc		; $4de2

@loadScript:
	ld e,Interaction.subid		; $4de5
	ld a,(de)		; $4de7
	ld hl,@scriptTable		; $4de8
	rst_addDoubleIndex			; $4deb
	ldi a,(hl)		; $4dec
	ld h,(hl)		; $4ded
	ld l,a			; $4dee
	jp interactionSetScript		; $4def

@scriptTable:
	.dw cheval_subid00Script


; ==============================================================================
; INTERACID_MISCELLANEOUS_1
; ==============================================================================
interactionCode6b:
	ld e,Interaction.subid		; $4df4
	ld a,(de)		; $4df6
	rst_jumpTable			; $4df7
	.dw _interaction6b_subid00
	.dw _interaction6b_subid01
	.dw _interaction6b_subid02
	.dw _interaction6b_subid03
	.dw _interaction6b_subid04
	.dw _interaction6b_subid05
	.dw _interaction6b_subid06
	.dw _interaction6b_subid07
	.dw _interaction6b_subid08
	.dw _interaction6b_subid09
	.dw _interaction6b_subid0a
	.dw _interaction6b_subid0b
	.dw _interaction6b_subid0c
	.dw _interaction6b_subid0d
	.dw _interaction6b_subid0e
	.dw _interaction6b_subid0f
	.dw _interaction6b_subid10
	.dw _interaction6b_subid11
	.dw _interaction6b_subid12
	.dw _interaction6b_subid13
	.dw _interaction6b_subid14
	.dw _interaction6b_subid15
	.dw _interaction6b_subid16


; Handles showing Impa's "Help" text when Link's about to screen transition
_interaction6b_subid00:
	call checkInteractionState		; $4e26
	jr nz,@state1	; $4e29

@state0:
	ld a,$01		; $4e2b
	ld (de),a		; $4e2d
	call getThisRoomFlags		; $4e2e
	bit 6,a			; $4e31
	jp nz,interactionDelete		; $4e33
@state1:
	call checkInteractionState2		; $4e36
	jr nz,@substate1	; $4e39

@substate0:
	call _interaction6b_checkLinkPressedUpAtScreenEdge		; $4e3b
	ret z			; $4e3e

	ld a,$01		; $4e3f
	ld (wMenuDisabled),a		; $4e41
	ld (wDisabledObjects),a		; $4e44
	ld e,Interaction.counter1		; $4e47
	ld a,30		; $4e49
	ld (de),a		; $4e4b
	ld bc,TX_0100		; $4e4c
	call showText		; $4e4f
	jp interactionIncState2		; $4e52

@substate1:
	call @decCounter1IfTextNotActive		; $4e55
	ret nz			; $4e58

	xor a			; $4e59
	ld (wDisabledObjects),a		; $4e5a
	push de			; $4e5d

	ld hl,@simulatedInput		; $4e5e
	ld a,:@simulatedInput		; $4e61
	call setSimulatedInputAddress		; $4e63

	pop de			; $4e66
	call getThisRoomFlags		; $4e67
	set 6,(hl)		; $4e6a

	jp interactionDelete		; $4e6c

@decCounter1IfTextNotActive:
	ld a,(wTextIsActive)		; $4e6f
	or a			; $4e72
	ret nz			; $4e73
	jp interactionDecCounter1		; $4e74

@simulatedInput:
	dwb 8, BTN_UP
	.dw $ffff


; Spawns nayru, ralph, animals before she's possessed
_interaction6b_subid01:
	ld e,Interaction.state		; $4e7c
	ld a,(de)		; $4e7e
	rst_jumpTable			; $4e7f
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $4e84
	ld (de),a		; $4e86
	ld a,GLOBALFLAG_INTRO_DONE		; $4e87
	call checkGlobalFlag		; $4e89
	jr nz,@delete	; $4e8c

	ld hl,objectData.nayruAndAnimalsInIntro		; $4e8e
	call parseGivenObjectData		; $4e91
	ld a,INTERACID_NAYRU		; $4e94
	ld (wInteractionIDToLoadExtraGfx),a		; $4e96

	push de			; $4e99
	ld a,UNCMP_GFXH_IMPA_FAINTED		; $4e9a
	call loadUncompressedGfxHeader		; $4e9c
	pop de			; $4e9f

@delete:
	jp interactionDelete		; $4ea0

@state1:
	; Never executed (deletes self before running state 1)
	call interactionRunScript		; $4ea3
	jp c,interactionDelete		; $4ea6
	ret			; $4ea9


; Script for cutscene with Ralph outside Ambi's palace, before getting mystery seeds
_interaction6b_subid02:
	call checkInteractionState		; $4eaa
	jr nz,@state1	; $4ead

@state0:
	ld a,TREASURE_MYSTERY_SEEDS		; $4eaf
	call checkTreasureObtained		; $4eb1
	jp c,interactionDelete		; $4eb4

@loadScript:
	jp _interaction6b_loadScript		; $4eb7

@state1:
	call interactionRunScript		; $4eba
	jp c,interactionDelete		; $4ebd
	ret			; $4ec0


; Seasons troupe member with guitar / tambourine?
_interaction6b_subid03:
_interaction6b_subid12:
	call checkInteractionState		; $4ec1
	jp nz,interactionAnimate		; $4ec4

@state0:
	call _interaction6b_initGraphicsAndIncState		; $4ec7
	jp objectSetVisible82		; $4eca


; Script for cutscene where moblins attack maku sapling
_interaction6b_subid04:
	call checkInteractionState		; $4ecd
	jr nz,@state1	; $4ed0

@state0:
	xor a			; $4ed2
	ld (wccd4),a		; $4ed3
	call _interaction6b_loadScript		; $4ed6
@state1:
	call interactionRunScript		; $4ed9
	jp c,interactionDelete		; $4edc
	ret			; $4edf


; Cutscene in intro where lightning strikes a guy
_interaction6b_subid05:
	ld e,Interaction.state		; $4ee0
	ld a,(de)		; $4ee2
	rst_jumpTable			; $4ee3
	.dw _interaction6b_subid02@loadScript
	.dw @state1

@state1:
	call checkInteractionState2		; $4ee8
	jr nz,@substate1	; $4eeb

@substate0:
	call interactionRunScript		; $4eed
	ret nc			; $4ef0

	call interactionIncState2		; $4ef1
	ld l,Interaction.counter1		; $4ef4
	ld (hl),$01		; $4ef6
	inc l			; $4ef8
	ld l,Interaction.counter2		; $4ef9
	ld (hl),$00		; $4efb

@substate1:
	call interactionDecCounter1		; $4efd
	ret nz			; $4f00
	ld (hl),20		; $4f01
	inc l			; $4f03
	ld a,(hl)		; $4f04
	cp $04			; $4f05
	jp nz,++		; $4f07

	ld a,$03		; $4f0a
	ld (wTmpcfc0.introCutscene.cfd1),a		; $4f0c
	jp interactionDelete		; $4f0f
++
	inc (hl)		; $4f12
	ld hl,@lightningPositions		; $4f13
	rst_addDoubleIndex			; $4f16
	ld b,(hl)		; $4f17
	inc hl			; $4f18
	ld c,(hl)		; $4f19
	call getFreePartSlot		; $4f1a
	ret nz			; $4f1d
	ld (hl),PARTID_LIGHTNING		; $4f1e
	inc l			; $4f20
	inc (hl)		; $4f21
	inc l			; $4f22
	inc (hl)		; $4f23
	ld l,Part.yh		; $4f24
	ld (hl),b		; $4f26
	ld l,Part.xh		; $4f27
	ld (hl),c		; $4f29
	ret			; $4f2a

@lightningPositions:
	.db $28 $28
	.db $58 $38
	.db $38 $68
	.db $48 $98


; Manages cutscene after beating d3
_interaction6b_subid06:
	call checkInteractionState		; $4f33
	jr nz,@state1	; $4f36

@state0:
	ld a,(wEssencesObtained)		; $4f38
	bit 2,a			; $4f3b
	jr z,@delete	; $4f3d

	call getThisRoomFlags		; $4f3f
	and $40			; $4f42
	jp nz,@delete		; $4f44

	ld a,$01		; $4f47
	ld (wDisabledObjects),a		; $4f49
	ld (wMenuDisabled),a		; $4f4c
	call interactionIncState		; $4f4f
	ld l,Interaction.counter1		; $4f52
	ld (hl),90		; $4f54
	ret			; $4f56

@delete:
	jp interactionDelete		; $4f57

@state1:
	ld e,Interaction.state2		; $4f5a
	ld a,(de)		; $4f5c
	rst_jumpTable			; $4f5d
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call interactionDecCounter1		; $4f64
	ret nz			; $4f67

	xor a			; $4f68
	ld hl,wGenericCutscene.cbb3		; $4f69
	ld (hl),a		; $4f6c
	dec a			; $4f6d
	ld hl,wGenericCutscene.cbba		; $4f6e
	ld (hl),a		; $4f71
	ld a,SND_LIGHTNING		; $4f72
	call playSound		; $4f74
	jp interactionIncState2		; $4f77

@substate1:
	ld hl,wGenericCutscene.cbb3		; $4f7a
	ld b,$01		; $4f7d
	call flashScreen		; $4f7f
	ret z			; $4f82
	call interactionIncState2		; $4f83
	jp fadeoutToWhite		; $4f86

@substate2:
	ld a,(wPaletteThread_mode)		; $4f89
	or a			; $4f8c
	ret nz			; $4f8d

	push de			; $4f8e

	; Load ambi's palace room
	ld bc,$0116		; $4f8f
	call disableLcdAndLoadRoom		; $4f92
	call resetCamera		; $4f95

	ld hl,objectData.ambiAndNayruInPostD3Cutscene		; $4f98
	call parseGivenObjectData		; $4f9b

	ld a,$02		; $4f9e
	call loadGfxRegisterStateIndex		; $4fa0
	pop de			; $4fa3
	ld a,MUS_DISASTER		; $4fa4
	call playSound		; $4fa6
	jp fadeinFromWhite		; $4fa9


; A seed satchel that slowly falls toward Link. Unused?
_interaction6b_subid07:
	call checkInteractionState		; $4fac
	jr nz,@state1	; $4faf

@state0:
	call _interaction6b_initGraphicsAndIncState		; $4fb1
	ld bc,$0000		; $4fb4
	ld hl,w1Link.yh		; $4fb7
	call objectTakePositionWithOffset		; $4fba
	ld h,d			; $4fbd
	ld l,Interaction.zh		; $4fbe
	ld (hl),$a8		; $4fc0

@state1:
	ld h,d			; $4fc2
	ld l,Interaction.zh		; $4fc3
	ldd a,(hl)		; $4fc5
	cp $f4			; $4fc6
	jp nc,interactionDelete		; $4fc8

	ld bc,$0080		; $4fcb
	ld a,c			; $4fce
	add (hl)		; $4fcf
	ldi (hl),a		; $4fd0
	ld a,b			; $4fd1
	adc (hl)		; $4fd2
	ld (hl),a		; $4fd3
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $4fd4


; Part of the cutscene where tokays steal your stuff?
_interaction6b_subid08:
	call checkInteractionState		; $4fd7
	jr nz,@state1	; $4fda

@state0:
	call getThisRoomFlags		; $4fdc
	bit 6,a			; $4fdf
	jp nz,interactionDelete		; $4fe1
	jp interactionIncState		; $4fe4

@state1:
	ld a,(wTmpcfc0.genericCutscene.cfd1)		; $4fe7
	or a			; $4fea
	jp nz,interactionDelete		; $4feb

	ld h,d			; $4fee
	ld l,Interaction.counter1		; $4fef
	ld a,(hl)		; $4ff1
	or a			; $4ff2
	jp z,playWaveSoundAtRandomIntervals		; $4ff3
	dec (hl)		; $4ff6
	ret			; $4ff7


; Shovel that Rosa gives to you in linked game
_interaction6b_subid09:
	call checkInteractionState		; $4ff8
	jr nz,@state1	; $4ffb

@state0:
	call _interaction6b_initGraphicsAndIncState		; $4ffd
	ld bc,$3848		; $5000
	call interactionSetPosition		; $5003
	jp objectSetVisible80		; $5006

@state1:
	; If [rosa.var3e] == 0, return; if $ff, delete self.
	ld a,Object.enabled		; $5009
	call objectGetRelatedObject1Var		; $500b
	ld l,Interaction.var3e		; $500e
	ld a,(hl)		; $5010
	ld c,a			; $5011
	or a			; $5012
	ret z			; $5013
	inc a			; $5014
	jp z,interactionDelete		; $5015

	; If rosa's direction is nonzero, change visibility
	ld l,Interaction.direction		; $5018
	ld a,(hl)		; $501a
	or a			; $501b
	call nz,objectSetVisible83		; $501c

	; Copy rosa's position, with x-offset [rosa.var3e]
	ld b,$00		; $501f
	jp objectTakePositionWithOffset		; $5021


; Flippers, cheval rope, and bomb treasures
_interaction6b_subid0a:
_interaction6b_subid0b:
_interaction6b_subid0c:
	call checkInteractionState		; $5024
	jr nz,@state1	; $5027

@state0:
	call getThisRoomFlags		; $5029
	bit ROOMFLAG_BIT_ITEM,a			; $502c
	jp nz,interactionDelete		; $502e
	ld e,Interaction.subid		; $5031
	ld a,(de)		; $5033
	sub $0a			; $5034
	inc e			; $5036
	ld (de),a		; $5037
	call _interaction6b_initGraphicsAndLoadScript		; $5038

@state1:
	call interactionRunScript		; $503b
	jr nc,++		; $503e
	xor a			; $5040
	ld (wDisabledObjects),a		; $5041
	ld (wMenuDisabled),a		; $5044
	jp interactionDelete		; $5047
++
	call checkInteractionState2		; $504a
	jp z,interactionAnimateAsNpc		; $504d
	ret			; $5050


; Blocks that move over when pulling lever to get flippers
_interaction6b_subid0d:
	call checkInteractionState		; $5051
	jr nz,@state1	; $5054

@state0:
	call _interaction6b_initGraphicsAndIncState		; $5056
	ld a,PALH_a3		; $5059
	call loadPaletteHeader		; $505b

	ld a,$06		; $505e
	call objectSetCollideRadius		; $5060

	ld l,Interaction.xh		; $5063
	ld a,(hl)		; $5065
	cp $c0			; $5066
	jr nz,+			; $5068
	ld l,Interaction.var03		; $506a
	ld (hl),$01		; $506c
+
	ld l,Interaction.var3d		; $506e
	ld (hl),a		; $5070

@state1:
	ld a,(w1Link.state)		; $5071
	cp $01			; $5074
	ret nz			; $5076

	ld a,(wLever1PullDistance)		; $5077
	or a			; $507a
	jr z,@updateXAndDraw	; $507b

	and $7c			; $507d
	rrca			; $507f
	rrca			; $5080
	ld b,a			; $5081
	ld e,Interaction.var03		; $5082
	ld a,(de)		; $5084
	or a			; $5085
	ld a,b			; $5086
	jr nz,@updateXAndDraw	; $5087

	; For the one on the left, invert direction
	cpl			; $5089
	inc a			; $508a
	cp $fe			; $508b
	call nc,@checkLinkSquished		; $508d

@updateXAndDraw:
	ld h,d			; $5090
	ld l,Interaction.var3d		; $5091
	add (hl)		; $5093
	ld l,Interaction.xh		; $5094
	ld (hl),a		; $5096
	jp interactionAnimateAsNpc		; $5097

;;
; @addr{509a}
@checkLinkSquished:
	push af			; $509a
	ld a,(wLinkInAir)		; $509b
	or a			; $509e
	jr nz,@ret	; $509f

	ld a,$08		; $50a1
	ld bc,$38b8		; $50a3
	ld hl,w1Link.yh		; $50a6
	call checkObjectIsCloseToPosition		; $50a9
	jr nc,@ret	; $50ac

	xor a			; $50ae
	ld (wcc50),a		; $50af
	ld a,LINK_STATE_SQUISHED		; $50b2
	ld (wLinkForceState),a		; $50b4
@ret:
	pop af			; $50b7
	ret			; $50b8


; Stone statue of Link that appears unconditionally
_interaction6b_subid0e:
	call checkInteractionState		; $50b9
	jr nz,@state1	; $50bc

@state0: ; Also called by subid $15's state 0
	ld a,(wTilesetFlags)		; $50be
	and TILESETFLAG_PAST			; $50c1
	ld a,PALH_c7		; $50c3
	jr nz,+			; $50c5
	dec a			; $50c7
+
	call loadPaletteHeader		; $50c8
	call _interaction6b_initGraphicsAndIncState		; $50cb
	ld bc,$080a		; $50ce
	call objectSetCollideRadii		; $50d1

	; Check for mermaid statue tile to change appearance if necessary
	call objectGetShortPosition		; $50d4
	ld c,a			; $50d7
	ld b,>wRoomLayout		; $50d8
	ld a,(bc)		; $50da
	cp $f9			; $50db
	ld a,$04		; $50dd
	jr nz,+			; $50df
	inc a			; $50e1
+
	call interactionSetAnimation		; $50e2

@state1: ; Also used as subid $15's state 1
	call interactionAnimateAsNpc		; $50e5
	ld h,d			; $50e8

	; No terrain effects
	ld l,Interaction.visible		; $50e9
	res 6,(hl)		; $50eb
	ret			; $50ed


; Switch that opens path to Nuun Highlands
_interaction6b_subid0f:
	ld e,Interaction.state		; $50ee
	ld a,(de)		; $50f0
	rst_jumpTable			; $50f1
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $50f8
	ld (de),a		; $50fa

	call getThisRoomFlags		; $50fb
	and $40			; $50fe
	jp nz,interactionDelete		; $5100

	call getFreePartSlot		; $5103
	ret nz			; $5106
	ld (hl),PARTID_SWITCH		; $5107
	inc l			; $5109
	ld (hl),$01		; $510a
	jp objectCopyPosition		; $510c

@state1:
	ld a,(wSwitchState)		; $510f
	or a			; $5112
	ret z			; $5113

	; Switch hit; start cutscene
	ld a,$81		; $5114
	ld (wMenuDisabled),a		; $5116
	ld (wDisabledObjects),a		; $5119
	ld (wDisableScreenTransitions),a		; $511c

	call getThisRoomFlags		; $511f
	set 6,(hl)		; $5122
	call interactionIncState		; $5124
	ld hl,interaction6b_bridgeToNuunSimpleScript		; $5127
	jp interactionSetSimpleScript		; $512a

@state2:
	ld e,Interaction.counter1		; $512d
	ld a,(de)		; $512f
	or a			; $5130
	jr z,++			; $5131
	dec a			; $5133
	ld (de),a		; $5134
	ret			; $5135
++
	ret nz			; $5136
	call interactionRunSimpleScript		; $5137
	ret nc			; $513a

	xor a			; $513b
	ld (wMenuDisabled),a		; $513c
	ld (wDisabledObjects),a		; $513f
	ld (wDisableScreenTransitions),a		; $5142
	jp interactionDelete		; $5145


; Unfinished stone statue of Link in credits cutscene
_interaction6b_subid10:
	call checkInteractionState		; $5148
	jr nz,@state1	; $514b

@state0:
	ld a,PALH_c8		; $514d
	call loadPaletteHeader		; $514f
	call _interaction6b_initGraphicsAndLoadScript		; $5152
	jp objectSetVisiblec2		; $5155

@state1:
	ld e,Interaction.state2		; $5158
	ld a,(de)		; $515a
	rst_jumpTable			; $515b
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

@substate0:
	call interactionRunScript		; $516c
	ld a,(wTmpcfc0.genericCutscene.state)		; $516f
	cp $02			; $5172
	ret nz			; $5174
	call interactionIncState2		; $5175
	ld l,Interaction.counter1		; $5178
	ld (hl),$20		; $517a
	ret			; $517c

@substate1:
	call interactionDecCounter1		; $517d
	jr nz,++		; $5180
	ld a,$03		; $5182
	ld (wTmpcfc0.genericCutscene.state),a		; $5184
	jp interactionIncState2		; $5187
++
	ld a,(hl)		; $518a
	and $07			; $518b
	ret nz			; $518d
	ld l,Interaction.zh		; $518e
	dec (hl)		; $5190
	ret			; $5191

@substate2:
	call interactionRunScript		; $5192
	ret nc			; $5195
	jp interactionIncState2		; $5196

@substate3:
	call interactionAnimateBasedOnSpeed		; $5199
	call objectApplySpeed		; $519c
	ld a,(wTmpcfc0.genericCutscene.state)		; $519f
	cp $06			; $51a2
	ret nz			; $51a4
	call interactionIncState2		; $51a5
	ld bc,$4084		; $51a8
	jp interactionSetPosition		; $51ab

@substate4:
	ld a,(wTmpcfc0.genericCutscene.state)		; $51ae
	cp $07			; $51b1
	ret nz			; $51b3
	jp interactionIncState2		; $51b4

@substate5:
	ld c,$01		; $51b7
	call objectUpdateSpeedZ_paramC		; $51b9
	ret nz			; $51bc

	call interactionIncState2		; $51bd
	ld l,Interaction.counter1		; $51c0
	ld (hl),30		; $51c2
	call objectSetVisible82		; $51c4
	ld a,$05		; $51c7
	jp interactionSetAnimation		; $51c9

@substate6:
	call interactionDecCounter1		; $51cc
	jr nz,++		; $51cf
	xor a			; $51d1
	ld (wGfxRegs1.SCY),a		; $51d2
	jp interactionIncState2		; $51d5
++
	ld a,(hl)		; $51d8
	and $01			; $51d9
	jr nz,+			; $51db
	ld a,$ff		; $51dd
+
	ld (wGfxRegs1.SCY),a		; $51df

@substate7:
	ret			; $51e2


; Triggers cutscene after beating Jabu-Jabu
_interaction6b_subid11:
	ld a,(wEssencesObtained)		; $51e3
	bit 6,a			; $51e6
	jr z,@delete	; $51e8

	call getThisRoomFlags		; $51ea
	and $40			; $51ed
	jr nz,@delete	; $51ef

	ld a,$01		; $51f1
	ld (wDisabledObjects),a		; $51f3
	ld (wMenuDisabled),a		; $51f6
	ld a,CUTSCENE_BLACK_TOWER_COMPLETE		; $51f9
	ld (wCutsceneTrigger),a		; $51fb
@delete:
	jp interactionDelete		; $51fe


; Goron bomb statue (left/right)
_interaction6b_subid13:
_interaction6b_subid14:
	call checkInteractionState		; $5201
	jr nz,@state1	; $5204

@state0:
	call _interaction6b_initGraphicsAndIncState		; $5206

	; Make this position solid
	call objectGetShortPosition		; $5209
	ld c,a			; $520c
	ld b,>wRoomLayout		; $520d
	ld a,$00		; $520f
	ld (bc),a		; $5211
	ld b,>wRoomCollisions		; $5212
	ld a,$0f		; $5214
	ld (bc),a		; $5216
@state1:
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $5217


; Stone statue of Link, as seen in-game
_interaction6b_subid15:
	call checkInteractionState		; $521a
	jp nz,_interaction6b_subid0e@state1		; $521d

@state0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $5220
	call checkGlobalFlag		; $5222
	jp z,interactionDelete		; $5225
	call objectGetShortPosition		; $5228
	ld h,>wRoomCollisions		; $522b
	ld l,a			; $522d
	ld (hl),$0f		; $522e
	jp _interaction6b_subid0e@state0		; $5230


; A flame that appears for [counter1] frames.
_interaction6b_subid16:
	call checkInteractionState		; $5233
	jr nz,@state1	; $5236

@state0:
	call _interaction6b_initGraphicsAndIncState		; $5238
	call objectSetVisible81		; $523b
	ld a,SND_LIGHTTORCH		; $523e
	jp playSound		; $5240

@state1:
	call interactionDecCounter1		; $5243
	jp z,interactionDelete		; $5246
	jp interactionAnimate		; $5249


;;
; @addr{524c}
_interaction6b_initGraphicsAndIncState:
	call interactionInitGraphics		; $524c
	jp interactionIncState		; $524f

;;
; @addr{5252}
_interaction6b_initGraphicsAndLoadScript:
	call interactionInitGraphics		; $5252

;;
; @addr{5255}
_interaction6b_loadScript:
	ld e,Interaction.subid		; $5255
	ld a,(de)		; $5257
	ld hl,_interaction6b_scriptTable		; $5258
	rst_addDoubleIndex			; $525b
	ldi a,(hl)		; $525c
	ld h,(hl)		; $525d
	ld l,a			; $525e
	call interactionSetScript		; $525f
	jp interactionIncState		; $5262

;;
; @param[out]	zflag	nz if Link pressed up at screen edge
; @addr{5265}
_interaction6b_checkLinkPressedUpAtScreenEdge:
	ld a,(wScrollMode)		; $5265
	cp $01			; $5268
	jr nz,+			; $526a

	ld hl,w1Link.yh		; $526c
	ld a,(hl)		; $526f
	cp $07			; $5270
	jr c,++			; $5272
+
	xor a			; $5274
	ret			; $5275
++
	ld a,(wKeysPressed)		; $5276
	and BTN_UP			; $5279
	ret			; $527b

_interaction6b_scriptTable:
	.dw interaction6b_stubScript
	.dw interaction6b_stubScript
	.dw interaction6b_subid02Script
	.dw interaction6b_stubScript
	.dw interaction6b_subid04Script
	.dw interaction6b_subid05Script
	.dw interaction6b_stubScript
	.dw interaction6b_stubScript
	.dw interaction6b_stubScript
	.dw interaction6b_stubScript
	.dw interaction6b_subid0aScript
	.dw interaction6b_subid0aScript
	.dw interaction6b_subid0aScript
	.dw interaction6b_stubScript
	.dw interaction6b_stubScript
	.dw interaction6b_stubScript
	.dw interaction6b_subid10Script


; ==============================================================================
; INTERACID_FAIRY_HIDING_MINIGAME
; ==============================================================================
interactionCode6c:
	ld e,Interaction.subid		; $529e
	ld a,(de)		; $52a0
	rst_jumpTable			; $52a1
	.dw _fairyHidingMinigame_subid00
	.dw _fairyHidingMinigame_subid01
	.dw _fairyHidingMinigame_subid02


; Begins fairy-hiding minigame
_fairyHidingMinigame_subid00:
	ld e,Interaction.state		; $52a8
	ld a,(de)		; $52aa
	rst_jumpTable			; $52ab
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; Delete self if game shouldn't happen right now
	ld a,TREASURE_ESSENCE		; $52b2
	call checkTreasureObtained		; $52b4
	jp nc,interactionDelete		; $52b7

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $52ba
	call checkGlobalFlag		; $52bc
	jp nz,interactionDelete		; $52bf

	ld hl,wTmpcfc0.fairyHideAndSeek.active		; $52c2
	ldi a,(hl)		; $52c5
	or a			; $52c6
	jp z,interactionIncState		; $52c7

	; Minigame already started; spawn in the fairies Link's found.
	ld a,(hl)		; $52ca
	sub $07			; $52cb
	jr nz,@spawn3Fairies	; $52cd

	; Minigame just starting
	ld a,CUTSCENE_FAIRIES_HIDE		; $52cf
	ld (wCutsceneTrigger),a		; $52d1
	ld a,$80		; $52d4
	ld (wMenuDisabled),a		; $52d6
	ld a,DISABLE_COMPANION | DISABLE_LINK		; $52d9
	ld (wDisabledObjects),a		; $52db
	xor a			; $52de
	ld (w1Link.direction),a		; $52df

@spawn3Fairies:
	jp _fairyHidingMinigame_spawn3FairiesAndDelete		; $52e2

@state1:
	call _fairyHidingMinigame_checkBeginCutscene		; $52e5
	ret nc			; $52e8
	ld a,(wScreenTransitionDirection)		; $52e9
	ld (w1Link.direction),a		; $52ec
	ld a,$01		; $52ef
	ld (wTmpcfc0.fairyHideAndSeek.active),a		; $52f1
	ld hl,fairyHidingMinigame_subid00Script		; $52f4
	jp interactionSetScript		; $52f7

@state2:
	call interactionRunScript		; $52fa
	ret nc			; $52fd
	ld a,CUTSCENE_FAIRIES_HIDE		; $52fe
	ld (wCutsceneTrigger),a		; $5300
	jp interactionDelete		; $5303


; Hiding spot for fairy
_fairyHidingMinigame_subid01:
	ld e,Interaction.state		; $5306
	ld a,(de)		; $5308
	rst_jumpTable			; $5309
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call _fairyHidingMinigame_checkMinigameActive		; $5312
	jp nc,interactionDelete		; $5315

	; [var38] = original tile index
	call objectGetTileAtPosition		; $5318
	ld e,Interaction.var38		; $531b
	ld (de),a		; $531d

	ld e,l			; $531e
	ld hl,@table		; $531f
	call lookupKey		; $5322
	ld e,Interaction.var03		; $5325
	ld (de),a		; $5327

	; Delete if already found this fairy
	sub $03			; $5328
	ld hl,wTmpcfc0.fairyHideAndSeek.foundFairiesBitset		; $532a
	call checkFlag		; $532d
	jp nz,interactionDelete		; $5330

	xor a			; $5333
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a		; $5334
	ld e,Interaction.counter1		; $5337
	ld a,$0c		; $5339
	ld (de),a		; $533b
	jp interactionIncState		; $533c


; b0: tile position (lookup key)
; b1: value for var03 of fairy to spawn when found (subid is $00)
@table:
	.db $25 $03
	.db $54 $04
	.db $32 $05
	.db $00

@state1:
	; Check if tile changed
	call objectGetTileAtPosition		; $5346
	ld b,a			; $5349
	ld e,Interaction.var38		; $534a
	ld a,(de)		; $534c
	cp b			; $534d
	ret z			; $534e

	call interactionDecCounter1		; $534f
	ret nz			; $5352
	call _fairyHidingMinigame_checkBeginCutscene		; $5353
	ret nc			; $5356
	ld a,$01		; $5357
	ld (wDisableScreenTransitions),a		; $5359

; Tile changed; fairy is revealed
@state2:
	call getFreeInteractionSlot		; $535c
	ret nz			; $535f
	ld (hl),INTERACID_FOREST_FAIRY		; $5360
	ld l,Interaction.var03		; $5362
	ld e,l			; $5364
	ld a,(de)		; $5365
	ld (hl),a		; $5366
	call objectCreatePuff		; $5367
	call interactionIncState		; $536a
	ld hl,fairyHidingMinigame_subid01Script		; $536d
	jp interactionSetScript		; $5370

@state3:
	call interactionRunScript		; $5373
	ret nc			; $5376

	ld e,Interaction.var03		; $5377
	ld a,(de)		; $5379
	sub $03			; $537a
	ld hl,wTmpcfc0.fairyHideAndSeek.foundFairiesBitset		; $537c
	call setFlag		; $537f

	; If found all fairies, warp out
	ld a,(wTmpcfc0.fairyHideAndSeek.foundFairiesBitset)		; $5382
	cp $07			; $5385
	jr z,@warpOut	; $5387

	xor a			; $5389
	ld (wMenuDisabled),a		; $538a
	ld (wDisabledObjects),a		; $538d
	ld (wDisableScreenTransitions),a		; $5390
	jr @delete		; $5393

@warpOut:
	ld hl,@warpDestination		; $5395
	call setWarpDestVariables		; $5398
@delete:
	jp interactionDelete		; $539b

@warpDestination:
	m_HardcodedWarpA ROOM_AGES_082, $00, $64, $03


; Checks for Link leaving the hide-and-seek area
_fairyHidingMinigame_subid02:
	ld e,Interaction.state		; $53a3
	ld a,(de)		; $53a5
	or a			; $53a6
	jr z,@state0	; $53a7

@state1:
	call interactionRunScript		; $53a9
	ret nc			; $53ac

	; Clear hide-and-seek-related variables
	ld hl,wTmpcfc0.fairyHideAndSeek.active		; $53ad
	ld b,$10		; $53b0
	call clearMemory		; $53b2
	jp interactionDelete		; $53b5

@state0:
	call _fairyHidingMinigame_checkMinigameActive		; $53b8
	jp nc,interactionDelete		; $53bb
	call interactionIncState		; $53be
	ld hl,fairyHidingMinigame_subid02Script		; $53c1
	jp interactionSetScript		; $53c4

;;
; Spawns the 3 fairies; they should delete themselves if they're not found yet?
; @addr{53c7}
_fairyHidingMinigame_spawn3FairiesAndDelete:
	ld b,$03		; $53c7

@spawnFairy:
	call getFreeInteractionSlot		; $53c9
	ret nz			; $53cc
	ld (hl),INTERACID_FOREST_FAIRY		; $53cd
	inc l			; $53cf
	inc (hl)   ; [subid] = $01
	inc l			; $53d1
	dec b			; $53d2
	ld (hl),b  ; [var03] = 0,1,2
	jr nz,@spawnFairy	; $53d4
	jp interactionDelete		; $53d6

;;
; @param[out]	cflag	c if Link is vulnerable (ready to begin cutscene?)
; @addr{53d9}
_fairyHidingMinigame_checkBeginCutscene:
	call checkLinkVulnerable		; $53d9
	ret nc			; $53dc

	ld a,$80		; $53dd
	ld (wMenuDisabled),a		; $53df

	ld a,DISABLE_COMPANION | DISABLE_LINK		; $53e2
	ld (wDisabledObjects),a		; $53e4

	call dropLinkHeldItem		; $53e7
	call clearAllParentItems		; $53ea
	call interactionIncState		; $53ed
	scf			; $53f0
	ret			; $53f1

;;
; @param[out]	cflag	c if minigame is active
; @addr{53f2}
_fairyHidingMinigame_checkMinigameActive:
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $53f2
	call checkGlobalFlag		; $53f4
	ret nz			; $53f7
	ld a,(wTmpcfc0.fairyHideAndSeek.active)		; $53f8
	rrca			; $53fb
	ret			; $53fc


; ==============================================================================
; INTERACID_POSSESSED_NAYRU
; ==============================================================================
interactionCode6d:
	ld e,Interaction.subid		; $53fd
	ld a,(de)		; $53ff
	ld e,Interaction.state		; $5400
	rst_jumpTable			; $5402
	.dw _possessedNayru_subid00
	.dw _possessedNayru_ghost
	.dw _possessedNayru_ghost


_possessedNayru_subid00:
	ld a,(de)		; $5409
	rst_jumpTable			; $540a
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,GLOBALFLAG_BEAT_POSSESSED_NAYRU		; $5413
	call checkGlobalFlag		; $5415
	jp nz,interactionDelete		; $5418

	ld a,PALH_85		; $541b
	call loadPaletteHeader		; $541d

	ld a,GLOBALFLAG_BEGAN_POSSESSED_NAYRU_FIGHT		; $5420
	call checkGlobalFlag		; $5422
	jr nz,@state2	; $5425

	; Spawn "ghost" veran
	call getFreeInteractionSlot		; $5427
	ret nz			; $542a
	ld (hl),INTERACID_POSSESSED_NAYRU		; $542b
	inc l			; $542d
	ld (hl),$02		; $542e
	ld l,Interaction.relatedObj1		; $5430
	ld (hl),Interaction.start		; $5432
	inc l			; $5434
	ld (hl),d		; $5435

	call objectCopyPosition		; $5436
	call interactionInitGraphics		; $5439

	ld a,LINK_STATE_FORCE_MOVEMENT		; $543c
	ld (wLinkForceState),a		; $543e
	ld a,$0e		; $5441
	ld (wLinkStateParameter),a		; $5443

	; Set Link's direction, angle
	ld hl,w1Link.direction		; $5446
	ld a,(wScreenTransitionDirection)		; $5449
	ldi (hl),a		; $544c
	swap a			; $544d
	rrca			; $544f
	ld (hl),a		; $5450

	ld a,$01		; $5451
	ld (wDisabledObjects),a		; $5453
	ld (wMenuDisabled),a		; $5456
	call interactionIncState		; $5459
	call objectSetVisible82		; $545c
	ld hl,possessedNayru_beginFightScript		; $545f
	jp interactionSetScript		; $5462

@state1:
	call interactionRunScript		; $5465
	ret nc			; $5468
	call interactionIncState		; $5469

@state2:
	call getFreeEnemySlot		; $546c
	ret nz			; $546f
	ld (hl),ENEMYID_VERAN_POSSESSION_BOSS		; $5470
	call objectCopyPosition		; $5472
	ld h,d			; $5475
	ld l,Interaction.state		; $5476
	ld (hl),$03		; $5478
	ret			; $547a

@state3:
	ld a,GLOBALFLAG_BEGAN_POSSESSED_NAYRU_FIGHT		; $547b
	call setGlobalFlag		; $547d
	xor a			; $5480
	ld (wDisabledObjects),a		; $5481
	ld (wMenuDisabled),a		; $5484
	inc a			; $5487
	ld (wLoadedTreeGfxIndex),a		; $5488
	jp interactionDelete		; $548b


_possessedNayru_ghost:
	ld a,(de)		; $548e
	rst_jumpTable			; $548f
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $5496
	call interactionIncState		; $5499
	ld l,Interaction.zh		; $549c
	ld (hl),-$04		; $549e
	ret			; $54a0

@state1:
	ld a,Object.var37		; $54a1
	call objectGetRelatedObject1Var		; $54a3
	ld a,(hl)		; $54a6
	or a			; $54a7
	ret z			; $54a8

	inc (hl)		; $54a9
	call interactionIncState		; $54aa
	ld l,Interaction.speed		; $54ad
	ld (hl),SPEED_80		; $54af
	call objectSetVisible81		; $54b1
	ld hl,possessedNayru_veranGhostScript		; $54b4
	jp interactionSetScript		; $54b7

@state2:
	call interactionRunScript		; $54ba
	jp nc,interactionAnimate		; $54bd

	ld a,Object.var37		; $54c0
	call objectGetRelatedObject1Var		; $54c2
	ld (hl),$00		; $54c5
	jp interactionDelete		; $54c7


; ==============================================================================
; INTERACID_NAYRU_SAVED_CUTSCENE
; ==============================================================================
interactionCode6e:
	ld e,Interaction.subid		; $54ca
	ld a,(de)		; $54cc
	ld e,Interaction.state		; $54cd
	rst_jumpTable			; $54cf
	.dw _interaction6e_subid00
	.dw _interaction6e_subid01
	.dw _interaction6e_subid02
	.dw _interaction6e_subid03
	.dw _interaction6e_subid04


; Nayru waking up after being freed from possession
_interaction6e_subid00:
	ld a,(de)		; $54da
	rst_jumpTable			; $54db
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $54e2
	call interactionIncState		; $54e5

	ld l,Interaction.yh		; $54e8
	ld (hl),$58		; $54ea
	ld l,Interaction.xh		; $54ec
	ld (hl),$78		; $54ee
	ld l,Interaction.speed		; $54f0
	ld (hl),SPEED_40		; $54f2

	ld l,Interaction.oamFlagsBackup		; $54f4
	ld a,$01		; $54f6
	ldi (hl),a		; $54f8
	ld (hl),a		; $54f9
	ld (wLoadedTreeGfxIndex),a		; $54fa

	ld hl,w1Link.direction		; $54fd
	ld (hl),DIR_UP		; $5500
	ld l,<w1Link.yh		; $5502
	ld (hl),$64		; $5504
	ld l,<w1Link.xh		; $5506
	ld (hl),$78		; $5508

	ld hl,wTmpcfc0.genericCutscene.cfd0		; $550a
	ld b,$10		; $550d
	call clearMemory		; $550f
	call setCameraFocusedObjectToLink		; $5512
	call resetCamera		; $5515
	ldh a,(<hActiveObject)	; $5518
	ld d,a			; $551a
	call fadeinFromWhite		; $551b
	ld a,$0a		; $551e
	call interactionSetAnimation		; $5520
	call objectSetVisible82		; $5523
	ld hl,interaction6e_subid00Script		; $5526
	jp interactionSetScript		; $5529

@state1:
	call interactionRunScript		; $552c
	jp nc,interactionAnimate		; $552f
	call interactionIncState		; $5532
	ld a,$04		; $5535
	jp fadeoutToWhiteWithDelay		; $5537

@state2:
	ld a,(wPaletteThread_mode)		; $553a
	or a			; $553d
	ret nz			; $553e
	ld a,GLOBALFLAG_BEAT_POSSESSED_NAYRU		; $553f
	call setGlobalFlag		; $5541
	ld a,CUTSCENE_NAYRU_WARP_TO_MAKU_TREE		; $5544
	ld (wCutsceneTrigger),a		; $5546
	jp interactionDelete		; $5549


; Queen Ambi
_interaction6e_subid01:
	ld a,(de)		; $554c
	rst_jumpTable			; $554d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call interactionInitGraphics		; $5558
	call interactionIncState		; $555b
	ld l,Interaction.speed		; $555e
	ld (hl),SPEED_100		; $5560
	ld l,Interaction.oamFlagsBackup		; $5562
	ld a,$01		; $5564
	ldi (hl),a		; $5566
	ld (hl),a		; $5567
	call objectSetVisiblec2		; $5568
	ld hl,interaction6e_subid01Script_part1		; $556b
	jp interactionSetScript		; $556e

@state1:
	ld c,$30		; $5571
	call objectUpdateSpeedZ_paramC		; $5573
	ret nz			; $5576

	call interactionRunScript		; $5577
	jr nc,@animate		; $557a

	call interactionIncState		; $557c
	ld l,Interaction.counter1		; $557f
	ld (hl),244		; $5581

	; Use "direction" variable temporarily as "animation"
	ld l,Interaction.direction		; $5583
	ld (hl),$05		; $5585
@animate
	jp interactionAnimate		; $5587


; Veran circling Ambi (she's turning left and right)
@state2:
	call interactionDecCounter1		; $558a
	jr z,++			; $558d

	ld a,(hl)		; $558f
	cp $c1			; $5590
	jr nc,@animate		; $5592
	and $1f			; $5594
	ret nz			; $5596

	ld l,Interaction.direction		; $5597
	ld a,(hl)		; $5599
	xor $02			; $559a
	ld (hl),a		; $559c
	jr @setAnimation		; $559d
++
	ld l,e			; $559f
	inc (hl)		; $55a0
	ld a,$06		; $55a1

@setAnimation:
	jp interactionSetAnimation		; $55a3


; Veran in process of possessing Ambi
@state3:
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $55a6
	cp $07			; $55a9
	jr z,++			; $55ab

	; Shake X position
	ld a,(wFrameCounter)		; $55ad
	rrca			; $55b0
	ret c			; $55b1
	ld e,Interaction.xh		; $55b2
	ld a,(de)		; $55b4
	inc a			; $55b5
	and $01			; $55b6
	add $78			; $55b8
	ld (de),a		; $55ba
	ret			; $55bb
++
	call interactionIncState		; $55bc
	ld l,Interaction.xh		; $55bf
	ld (hl),$78		; $55c1
	ld l,Interaction.oamFlags		; $55c3
	ld a,$06		; $55c5
	ldd (hl),a		; $55c7
	ld (hl),a		; $55c8
	ld hl,interaction6e_subid01Script_part2		; $55c9
	call interactionSetScript		; $55cc

	ld a,SND_LIGHTNING		; $55cf
	call playSound		; $55d1
	ld a,MUS_DISASTER		; $55d4
	call playSound		; $55d6
	ld a,$04		; $55d9
	jp fadeinFromWhiteWithDelay		; $55db


; Now finished being possessed
@state4:
	ld a,(wPaletteThread_mode)		; $55de
	or a			; $55e1
	jr nz,++		; $55e2
	ld c,$30		; $55e4
	call objectUpdateSpeedZ_paramC		; $55e6
	ret nz			; $55e9
	call interactionRunScript		; $55ea
++
	jp interactionAnimate		; $55ed


; Ghost Veran
_interaction6e_subid02:
	ld a,(de)		; $55f0
	rst_jumpTable			; $55f1
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics		; $55fa
	call interactionIncState		; $55fd

	ld l,Interaction.speed		; $5600
	ld (hl),SPEED_200		; $5602

	ld l,Interaction.angle		; $5604
	ld (hl),$0e		; $5606

	ld l,Interaction.counter1		; $5608
	ld (hl),$48		; $560a

	ld bc,TX_560c		; $560c
	call showText		; $560f

	ld a,SNDCTRL_STOPMUSIC		; $5612
	call playSound		; $5614

	jp objectSetVisible81		; $5617


; Starting to move toward Ambi
@state1:
	ld e,Interaction.counter1		; $561a
	ld a,(de)		; $561c
	cp $48			; $561d
	ld a,SND_BEAM		; $561f
	call z,playSound		; $5621
	call interactionDecCounter1		; $5624
	jr nz,@applySpeedAndAnimate	; $5627

	ld (hl),$ac		; $5629

	ld l,Interaction.state		; $562b
	inc (hl)		; $562d
	ld l,Interaction.angle		; $562e
	ld (hl),$16		; $5630

	; Link moves up, while facing down
	ld hl,w1Link.direction		; $5632
	ld (hl),DIR_DOWN		; $5635
	inc l			; $5637
	ld (hl),ANGLE_UP		; $5638
	ld a,LINK_STATE_FORCE_MOVEMENT		; $563a
	ld (wLinkForceState),a		; $563c
	ld a,$04		; $563f
	ld (wLinkStateParameter),a		; $5641

	ld a,SND_CIRCLING		; $5644
	call playSound		; $5646


; Circling around Ambi
@state2:
	call interactionDecCounter1		; $5649
	jr z,@beginPossessingAmbi	; $564c

	ld a,(hl)		; $564e
	push af			; $564f
	cp $56			; $5650
	ld a,SND_CIRCLING		; $5652
	call z,playSound		; $5654

	pop af			; $5657
	rrca			; $5658
	ld e,Interaction.angle		; $5659
	jr nc,++		; $565b
	ld a,(de)		; $565d
	dec a			; $565e
	and $1f			; $565f
	ld (de),a		; $5661
++
	ld a,$10		; $5662
	ld bc,$7e78		; $5664
	call objectSetPositionInCircleArc		; $5667
	jp interactionAnimate		; $566a

@beginPossessingAmbi:
	ld (hl),$50		; $566d

	ld l,e			; $566f
	inc (hl) ; [state]++

	ld l,Interaction.speed		; $5671
	ld (hl),SPEED_20		; $5673
	ld l,Interaction.angle		; $5675
	ld (hl),ANGLE_DOWN		; $5677

	ld a,SND_BOSS_DAMAGE		; $5679
	call playSound		; $567b


; Moving into Ambi
@state3:
	call interactionDecCounter1		; $567e
	jr nz,++		; $5681
	ld a,$07		; $5683
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $5685
	ld a,$04		; $5688
	jp interactionDelete		; $568a
++
	ld l,Interaction.visible		; $568d
	ld a,(hl)		; $568f
	xor $80			; $5690
	ld (hl),a		; $5692

@applySpeedAndAnimate:
	call objectApplySpeed		; $5693
	jp interactionAnimate		; $5696


; Ralph
_interaction6e_subid03:
	ld a,(de)		; $5699
	or a			; $569a
	jr z,_interaction6e_initRalph	; $569b

_interaction6e_runScriptAndAnimate:
	call interactionRunScript		; $569d
	jp interactionAnimate		; $56a0

_interaction6e_initRalph:
	call interactionInitGraphics		; $56a3
	call interactionIncState		; $56a6
	ld l,Interaction.speed		; $56a9
	ld (hl),SPEED_200		; $56ab
	call objectSetVisible82		; $56ad
	ld hl,interaction6e_subid03Script		; $56b0
	jp interactionSetScript		; $56b3


; Guards that run into the room
_interaction6e_subid04:
	ld a,(de)		; $56b6
	or a			; $56b7
	jr nz,_interaction6e_runScriptAndAnimate	; $56b8

	call interactionInitGraphics		; $56ba
	call interactionIncState		; $56bd

	ld l,Interaction.speed		; $56c0
	ld (hl),SPEED_180		; $56c2

	ld l,Interaction.yh		; $56c4
	ld (hl),$b0		; $56c6
	ld l,Interaction.xh		; $56c8
	ld (hl),$78		; $56ca
	call objectSetVisible82		; $56cc

	ld e,Interaction.var03		; $56cf
	ld a,(de)		; $56d1
	ld hl,@scriptTable		; $56d2
	rst_addDoubleIndex			; $56d5
	ldi a,(hl)		; $56d6
	ld h,(hl)		; $56d7
	ld l,a			; $56d8
	jp interactionSetScript		; $56d9

@scriptTable:
	.dw interaction6e_guard0Script
	.dw interaction6e_guard1Script
	.dw interaction6e_guard2Script
	.dw interaction6e_guard3Script
	.dw interaction6e_guard4Script
	.dw interaction6e_guard5Script


; ==============================================================================
; INTERACID_WILD_TOKAY_CONTROLLER
;
; Variables:
;   var03: Set to $ff when the game is lost?
;   var38: ?
;   var39: ?
;   var3b: ?
;   var3e/3f: Link's B/A button items, saved
; ==============================================================================
interactionCode70:
	ld e,Interaction.state		; $56e8
	ld a,(de)		; $56ea
	rst_jumpTable			; $56eb
	.dw @state0
	.dw @state1

@state0:
	xor a			; $56f0
	ld hl,wTmpcfc0.wildTokay.cfde		; $56f1
	ldi (hl),a		; $56f4
	ld (hl),a		; $56f5
	call interactionIncState		; $56f6
	ld a,(wWildTokayGameLevel)		; $56f9
	ld b,a			; $56fc
	ld a,(wTmpcfc0.wildTokay.inPresent)		; $56fd
	or a			; $5700
	jr z,+			; $5701
	ld b,$02		; $5703
+
	ld a,b			; $5705
	ld (wTmpcfc0.wildTokay.cfdc),a		; $5706
	ld bc,@var3bValues		; $5709
	call addAToBc		; $570c
	ld a,(bc)		; $570f
	ld e,Interaction.var3b		; $5710
	ld (de),a		; $5712
	jp @getRandomVar39Value		; $5713

@var3bValues:
	.db $05 $05 $05 $06 $07

@state1:
	ld e,Interaction.state2		; $571b
	ld a,(de)		; $571d
	rst_jumpTable			; $571e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	ld a,(wPaletteThread_mode)		; $572d
	or a			; $5730
	ret nz			; $5731

	; Save Link's equipped items
	ld hl,wInventoryB		; $5732
	ld e,Interaction.var3e		; $5735
	ldi a,(hl)		; $5737
	ld (de),a		; $5738
	ldd a,(hl)		; $5739
	inc e			; $573a
	ld (de),a		; $573b

	ld (hl),ITEMID_NONE		; $573c
	inc l			; $573e
	ld (hl),ITEMID_BRACELET		; $573f

	; Replace tiles to start game
	ld b,$06		; $5741
	ld hl,@tilesToReplaceOnStart		; $5743
@@nextTile:
	ldi a,(hl)		; $5746
	ld c,(hl)		; $5747
	inc hl			; $5748
	push bc			; $5749
	push hl			; $574a
	call setTile		; $574b
	pop hl			; $574e
	pop bc			; $574f
	dec b			; $5750
	jr nz,@@nextTile	; $5751

	call interactionIncState2		; $5753
	ld l,Interaction.counter1		; $5756
	ld (hl),30		; $5758

	ld hl,w1Link.yh		; $575a
	ld (hl),$48		; $575d
	ld l,<w1Link.xh		; $575f
	ld (hl),$50		; $5761
	xor a			; $5763
	ld l,<w1Link.direction		; $5764
	ld (hl),a		; $5766

	dec a			; $5767
	ld (wStatusBarNeedsRefresh),a		; $5768
	ret			; $576b

; b0: new tile value
; b1: tile position
@tilesToReplaceOnStart:
	.db $ef $01
	.db $ef $08
	.db $ef $71
	.db $ef $78
	.db $7a $74
	.db $7a $75

@substate1:
	call interactionDecCounter1		; $5778
	ret nz			; $577b
	call interactionIncState2		; $577c
	ld l,Interaction.counter1		; $577f
	ld (hl),10		; $5781
	ld a,MUS_MINIGAME		; $5783
	call playSound		; $5785
	jp fadeinFromWhite		; $5788

@substate2:
	call interactionDecCounter1IfPaletteNotFading		; $578b
	ret nz			; $578e
	call interactionIncState2		; $578f
	xor a			; $5792
	ld (wDisabledObjects),a		; $5793
	ld bc,TX_0a16		; $5796
	jp showText		; $5799


; Starting the game
@substate3:
	ld a,(wTextIsActive)		; $579c
	or a			; $579f
	ret nz			; $57a0

	call interactionIncState2		; $57a1
	ld l,Interaction.counter1		; $57a4
	ld (hl),60		; $57a6
	call getFreeInteractionSlot		; $57a8
	ret nz			; $57ab
	ld (hl),INTERACID_TOKAY_MEAT		; $57ac
	ld a,SND_WHISTLE		; $57ae
	jp playSound		; $57b0


; Playing the game
@substate4:
	ld a,(wTmpcfc0.wildTokay.cfde)		; $57b3
	or a			; $57b6
	jp z,@checkSpawnNextTokay		; $57b7

	ld hl,wDisabledObjects		; $57ba
	ld (hl),DISABLE_LINK		; $57bd
	inc a			; $57bf
	jr z,@@lostGame	; $57c0

@@wonGame:
	ld a,SND_CRANEGAME		; $57c2
	call playSound		; $57c4
	jr ++			; $57c7

@@lostGame:
	dec a			; $57c9
	ld e,Interaction.var03		; $57ca
	ld (de),a		; $57cc
	ld a,SND_ERROR		; $57cd
	call playSound		; $57cf
++
	call interactionIncState2		; $57d2
	ld l,Interaction.counter1		; $57d5
	ld (hl),30		; $57d7
	ret			; $57d9


; Showing text after finishing game
@substate5:
	call interactionDecCounter1		; $57da
	ret nz			; $57dd

	ld (hl),60		; $57de
	call interactionIncState2		; $57e0

	ld a,(wTmpcfc0.wildTokay.inPresent)		; $57e3
	or a			; $57e6
	ret nz			; $57e7

	ld h,d			; $57e8
	ld l,Interaction.counter1		; $57e9
	ld (hl),20		; $57eb
	ld bc,TX_0a18		; $57ed
	ld l,Interaction.var03		; $57f0
	ld a,(hl)		; $57f2
	add c			; $57f3
	ld c,a			; $57f4
	jp showText		; $57f5

@substate6:
	ld a,(wTmpcfc0.wildTokay.inPresent)		; $57f8
	or a			; $57fb
	jr z,+			; $57fc

	call interactionDecCounter1		; $57fe
	ret nz			; $5801
	jr ++			; $5802
+
	call interactionDecCounter1IfTextNotActive		; $5804
	ret nz			; $5807
++
	; Restore inventory
	ld hl,wInventoryB		; $5808
	ld e,Interaction.var3e		; $580b
	ld a,(de)		; $580d
	inc e			; $580e
	ldi (hl),a		; $580f
	ld a,(de)		; $5810
	ld (hl),a		; $5811

	call getThisRoomFlags		; $5812
	set 6,(hl)		; $5815
	ld a,$ff		; $5817
	ld (wActiveMusic),a		; $5819

	ld hl,@@pastWarpDest		; $581c
	ld a,(wTmpcfc0.wildTokay.inPresent)		; $581f
	or a			; $5822
	jr z,+			; $5823
	ld hl,@@presentWarpDest		; $5825
+
	jp setWarpDestVariables		; $5828

@@pastWarpDest:
	m_HardcodedWarpA ROOM_AGES_2de, $00, $57, $03

@@presentWarpDest:
	m_HardcodedWarpA ROOM_AGES_2e5, $00, $57, $03


@checkSpawnNextTokay:
	call interactionDecCounter1		; $5835
	ret nz			; $5838

	ld (hl),60		; $5839
	ld l,Interaction.var3b		; $583b
	ld a,(hl)		; $583d
	or a			; $583e
	ret z			; $583f

	ld l,Interaction.var39		; $5840
	ld a,(hl)		; $5842
	add a			; $5843
	ld bc,@data_5898		; $5844
	call addDoubleIndexToBc		; $5847

	ld l,Interaction.var38		; $584a
	ld a,(hl)		; $584c
	cp $04			; $584d
	jr z,@decVar3b	; $584f

	inc (hl)		; $5851
	call addAToBc		; $5852
	ld a,(bc)		; $5855
	or a			; $5856
	ret z			; $5857
	ld c,a			; $5858
	ld l,Interaction.var3b		; $5859
	ld a,(hl)		; $585b
	dec a			; $585c
	jr nz,@loadTokay	; $585d

	ld l,Interaction.var39		; $585f
	ld a,(hl)		; $5861
	ld b,$03		; $5862
	cp $01			; $5864
	jr z,++			; $5866
	cp $06			; $5868
	jr z,++			; $586a
	inc b			; $586c
++
	ld l,Interaction.var38		; $586d
	ld a,(hl)		; $586f
	cp b			; $5870
	jr nz,@loadTokay	; $5871

	ld hl,wTmpcfc0.wildTokay.cfdf		; $5873
	ld (hl),b		; $5876

@loadTokay:
	ld b,c			; $5877
	call getWildTokayObjectDataIndex		; $5878
	jp parseGivenObjectData		; $587b

@decVar3b:
	ld (hl),$00		; $587e
	ld l,Interaction.var3b		; $5880
	dec (hl)		; $5882

;;
; @addr{5883}
@getRandomVar39Value:
	ld hl,wTmpcfc0.wildTokay.cfdc		; $5883
	ld a,(hl)		; $5886
	swap a			; $5887
	ld hl,@table		; $5889
	rst_addAToHl			; $588c
	call getRandomNumber		; $588d
	and $0f			; $5890
	rst_addAToHl			; $5892
	ld a,(hl)		; $5893
	ld e,Interaction.var39		; $5894
	ld (de),a		; $5896
	ret			; $5897


; Each row corresponds to a value for var39; each column corresponds to a value for var38?
@data_5898:
	.db $01 $00 $00 $02
	.db $02 $00 $01 $00
	.db $02 $01 $00 $01
	.db $01 $00 $02 $02
	.db $01 $01 $02 $02
	.db $02 $02 $01 $01
	.db $02 $03 $01 $00
	.db $01 $03 $02 $02

; Each row is a set of possible values for a particular value of wTmpcfc0.wildTokay.cfdc?
@table:
	.db $00 $00 $00 $01 $01 $01 $02 $02 $02 $03 $03 $03 $04 $04 $05 $05
	.db $00 $00 $01 $01 $01 $02 $02 $02 $03 $03 $03 $04 $04 $04 $05 $06
	.db $00 $01 $01 $02 $02 $03 $03 $04 $04 $04 $05 $05 $06 $06 $06 $07
	.db $01 $02 $03 $03 $04 $04 $04 $05 $05 $05 $05 $00 $00 $06 $07 $07
	.db $03 $04 $04 $04 $05 $05 $05 $05 $05 $02 $01 $00 $06 $07 $07 $07


; ==============================================================================
; INTERACID_COMPANION_SCRIPTS
; ==============================================================================
interactionCode71:
	ld a,(wLinkDeathTrigger)		; $5908
	or a			; $590b
	jr z,++			; $590c
	xor a			; $590e
	ld (wDisabledObjects),a		; $590f
	jp interactionDelete		; $5912
++
	ld e,Interaction.subid		; $5915
	ld a,(de)		; $5917
	rst_jumpTable			; $5918
	.dw _companionScript_subid00
	.dw _companionScript_subid01
	.dw _companionScript_subid02
	.dw _companionScript_subid03
	.dw _companionScript_subid04
	.dw _companionScript_subid05
	.dw _companionScript_subid06
	.dw _companionScript_subid07
	.dw _companionScript_subid08
	.dw _companionScript_subid09
	.dw _companionScript_subid0a
	.dw _companionScript_subid0b
	.dw _companionScript_subid0c
	.dw _companionScript_subid0d


_companionScript_subid00:
	ld e,Interaction.state		; $5935
	ld a,(de)		; $5937
	rst_jumpTable			; $5938
	.dw @state0
	.dw _companionScript_subid00_state1

@state0:
	ld a,$01		; $593d
	ld (de),a		; $593f
	ld a,(wEssencesObtained)		; $5940
	bit 1,a			; $5943
	jp z,_companionScript_deleteSelf		; $5945

	ld a,(wPastRoomFlags+$79)		; $5948
	bit 6,a			; $594b
	jp z,_companionScript_deleteSelf		; $594d

	ld a,(wMooshState)		; $5950
	and $60			; $5953
	jp nz,_companionScript_deleteSelf		; $5955

	ld a,$01		; $5958
	ld (wDisableScreenTransitions),a		; $595a
	ld (wDiggingUpEnemiesForbidden),a		; $595d
	ld hl,companionScript_subid00Script		; $5960
	jp interactionSetScript		; $5963


_companionScript_subid01:
	ld e,Interaction.state		; $5966
	ld a,(de)		; $5968
	rst_jumpTable			; $5969
	.dw _companionScript_genericState0
	.dw _companionScript_restrictHigherX

_companionScript_subid02:
	ld e,Interaction.state		; $596e
	ld a,(de)		; $5970
	rst_jumpTable			; $5971
	.dw _companionScript_genericState0
	.dw _companionScript_restrictLowerY

_companionScript_subid04:
	ld e,Interaction.state		; $5976
	ld a,(de)		; $5978
	rst_jumpTable			; $5979
	.dw _companionScript_genericState0
	.dw _companionScript_restrictHigherY

_companionScript_subid05:
	ld e,Interaction.state		; $597e
	ld a,(de)		; $5980
	rst_jumpTable			; $5981
	.dw _companionScript_genericState0
	.dw _companionScript_restrictLowerX


; Delete self if game is completed; otherwise, stay in state 0 until Link mounts the
; companion.
_companionScript_genericState0:
	ld a,(wFileIsCompleted)		; $5986
	or a			; $5989
	jp nz,_companionScript_deleteSelf		; $598a
	ld a,(wLinkObjectIndex)		; $598d
	rrca			; $5990
	ret nc			; $5991

	ld a,$01		; $5992
	ld (de),a		; $5994

	ld a,(w1Companion.id)		; $5995
	sub SPECIALOBJECTID_RICKY			; $5998
	ld e,Interaction.var30		; $599a
	ld (de),a		; $599c
	add <wRickyState			; $599d
	ld l,a			; $599f
	ld h,>wRickyState		; $59a0
	bit 7,(hl)		; $59a2
	jp nz,_companionScript_deleteSelf		; $59a4
	ret			; $59a7

_companionScript_restrictHigherX:
	call _companionScript_cpXToCompanion		; $59a8
	ret c			; $59ab
	inc a			; $59ac
	jr ++		; $59ad

_companionScript_restrictLowerX:
	call _companionScript_cpXToCompanion		; $59af
	ret nc			; $59b2
	jr ++		; $59b3

_companionScript_restrictLowerY:
	call _companionScript_cpYToCompanion		; $59b5
	ret nc			; $59b8
	jr ++		; $59b9

_companionScript_restrictHigherY:
	call _companionScript_cpYToCompanion		; $59bb
	ret c			; $59be
	inc a			; $59bf
	jr ++		; $59c0

++
	ld c,a			; $59c2
	ld a,(wLinkObjectIndex)		; $59c3
	rrca			; $59c6
	ret nc			; $59c7

	ld a,c			; $59c8
	ld (hl),a		; $59c9

	ld l,SpecialObject.speed		; $59ca
	ld (hl),SPEED_0		; $59cc

	ld e,Interaction.var30		; $59ce
	ld a,(de)		; $59d0
	ld hl,_companionScript_companionBarrierText		; $59d1
	rst_addDoubleIndex			; $59d4
	ldi a,(hl)		; $59d5
	ld b,(hl)		; $59d6
	ld c,a			; $59d7
	jp showText		; $59d8

_companionScript_cpYToCompanion:
	ld e,Interaction.yh		; $59db
	ld a,(de)		; $59dd
	ld hl,w1Companion.yh		; $59de
	cp (hl)			; $59e1
	ret			; $59e2

_companionScript_cpXToCompanion:
	ld e,Interaction.xh		; $59e3
	ld a,(de)		; $59e5
	ld hl,w1Companion.xh		; $59e6
	cp (hl)			; $59e9
	ret			; $59ea

; Text to show when you try to pass the "barriers" imposed.
_companionScript_companionBarrierText:
	.dw TX_2007 ; Ricky
	.dw TX_2105 ; Dimitri
	.dw TX_2209 ; Moosh


; Companion barrier to Symmetry City, until the tuni nut is restored
_companionScript_subid0d:
	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $59f1
	call checkGlobalFlag		; $59f3
	jp nz,_companionScript_deleteSelf		; $59f6

	ld a,(wScrollMode)		; $59f9
	and (SCROLLMODE_08 | SCROLLMODE_04 | SCROLLMODE_02)	; $59fc
	ret nz			; $59fe
	ld hl,w1Companion.enabled		; $59ff
	ldi a,(hl)		; $5a02
	or a			; $5a03
	ret z			; $5a04

	ldi a,(hl)		; $5a05
	cp SPECIALOBJECTID_FIRST_COMPANION			; $5a06
	ret c			; $5a08
	cp SPECIALOBJECTID_LAST_COMPANION+1			; $5a09
	ret nc			; $5a0b

	; Check if the companion is roughly at this object's position
	ld l,SpecialObject.xh		; $5a0c
	ld e,Interaction.xh		; $5a0e
	ld a,(de)		; $5a10
	sub (hl)		; $5a11
	add $05			; $5a12
	cp $0b			; $5a14
	ret nc			; $5a16
	ld l,SpecialObject.yh		; $5a17
	ld e,Interaction.yh		; $5a19
	ld a,(de)		; $5a1b
	cp (hl)			; $5a1c
	ret c			; $5a1d

	; If so, prevent companion from moving any further up
	inc a			; $5a1e
	ld (hl),a		; $5a1f
	ld l,SpecialObject.speed		; $5a20
	ld (hl),$00		; $5a22
	ld l,SpecialObject.state		; $5a24
	ldi a,(hl)		; $5a26

	; If it's Dimitri being held, make Link drop him
	cp $02			; $5a27
	jr nz,+			; $5a29
	ld (hl),$03		; $5a2b
	call dropLinkHeldItem		; $5a2d
+
	ld a,(wAnimalCompanion)		; $5a30
	sub SPECIALOBJECTID_FIRST_COMPANION			; $5a33
	ld hl,@textIndices		; $5a35
	rst_addDoubleIndex			; $5a38
	ldi a,(hl)		; $5a39
	ld b,(hl)		; $5a3a
	ld c,a			; $5a3b
	jp showText		; $5a3c

; Text to show as the excuse why they can't go into Symmetry City
@textIndices:
	.dw TX_200a
	.dw TX_2109
	.dw TX_220a


; Ricky script when he loses his gloves
_companionScript_subid03:
	ld e,Interaction.state		; $5a45
	ld a,(de)		; $5a47
	rst_jumpTable			; $5a48
	.dw @state0
	.dw _companionScript_runScript

@state0:
	ld a,$01		; $5a4d
	ld (de),a		; $5a4f
	ld hl,wRickyState		; $5a50
	ld a,(hl)		; $5a53
	and $20			; $5a54
	jr nz,_companionScript_deleteSelf	; $5a56
	ld hl,companionScript_subid03Script		; $5a58
	jp interactionSetScript		; $5a5b


; Dimitri script where he's harrassed by tokays
_companionScript_subid07:
	ld e,Interaction.state		; $5a5e
	ld a,(de)		; $5a60
	rst_jumpTable			; $5a61
	.dw @state0
	.dw _companionScript_runScript

@state0:
	ld a,(wDimitriState)		; $5a66
	and $20			; $5a69
	jr nz,_companionScript_deleteSelf	; $5a6b
	ld a,$01		; $5a6d
	ld (de),a		; $5a6f
	ld hl,companionScript_subid07Script		; $5a70
	jp interactionSetScript		; $5a73


; Dimitri script where he leaves Link after bringing him to the mainland
_companionScript_subid06:
	ld e,Interaction.state		; $5a76
	ld a,(de)		; $5a78
	rst_jumpTable			; $5a79
	.dw @state0
	.dw _companionScript_runScript

@state0:
	; Delete self if dimitri isn't here or the event has happened already
	ld a,(wDimitriState)		; $5a7e
	and $40			; $5a81
	jr nz,_companionScript_deleteSelf	; $5a83
	ld hl,w1Companion.id		; $5a85
	ld a,(hl)		; $5a88
	cp SPECIALOBJECTID_DIMITRI			; $5a89
	jr nz,_companionScript_deleteSelf	; $5a8b

	; Return if Dimitri's still in the water
	ld l,SpecialObject.var38		; $5a8d
	ld a,(hl)		; $5a8f
	or a			; $5a90
	ret nz			; $5a91

	ld a,$01		; $5a92
	ld (de),a		; $5a94
	ld (wDisableScreenTransitions),a		; $5a95

	; Manipulate Dimitri's state to force a dismount
	ld l,SpecialObject.var03		; $5a98
	ld (hl),$02		; $5a9a
	inc l			; $5a9c
	ld (hl),$0a		; $5a9d

	ld hl,companionScript_subid06Script		; $5a9f
	jp interactionSetScript		; $5aa2

_companionScript_deleteSelf:
	jp interactionDelete		; $5aa5


; A fairy appears to tell you about the animal companion in the forest
_companionScript_subid08:
	ld e,Interaction.state		; $5aa8
	ld a,(de)		; $5aaa
	rst_jumpTable			; $5aab
	.dw @state0
	.dw @state1
	.dw _companionScript_runScript

@state0:
	; Clear $10 bytes starting at $cfd0
	ld hl,wTmpcfc0.fairyHideAndSeek.active		; $5ab2
	ld b,$10		; $5ab5
	call clearMemory		; $5ab7

	ld a,GLOBALFLAG_CAN_BUY_FLUTE		; $5aba
	call unsetGlobalFlag		; $5abc

	ld l,<wAnimalCompanion		; $5abf
	ld a,(hl)		; $5ac1
	or a			; $5ac2
	jr nz,+			; $5ac3
	ld a,SPECIALOBJECTID_MOOSH		; $5ac5
	ld (hl),a		; $5ac7
+
	sub SPECIALOBJECTID_FIRST_COMPANION			; $5ac8
	add <TX_1123			; $5aca
	ld (wTextSubstitutions),a		; $5acc

	ld a,(wScreenTransitionDirection)		; $5acf
	cp DIR_LEFT			; $5ad2
	jr nz,_companionScript_deleteSelf	; $5ad4

	ld a,GLOBALFLAG_TALKED_TO_HEAD_CARPENTER		; $5ad6
	call checkGlobalFlag		; $5ad8
	jr z,_companionScript_deleteSelf	; $5adb

	call getThisRoomFlags		; $5add
	bit 6,a			; $5ae0
	jr nz,_companionScript_deleteSelf	; $5ae2
	jp interactionIncState		; $5ae4

@state1:
	; Wait for Link to trigger the fairy
	ld a,(w1Link.xh)		; $5ae7
	cp $50			; $5aea
	ret nc			; $5aec

	ld a,$81		; $5aed
	ld (wMenuDisabled),a		; $5aef
	ld (wDisabledObjects),a		; $5af2
	call putLinkOnGround		; $5af5

	ldbc INTERACID_FOREST_FAIRY, $03		; $5af8
	call objectCreateInteraction		; $5afb
	ld l,Interaction.var03		; $5afe
	ld (hl),$0f		; $5b00
	ld hl,companionScript_subid08Script		; $5b02
	call interactionSetScript		; $5b05
	jp interactionIncState		; $5b08


; Companion script where they're found in the fairy forest
_companionScript_subid09:
	ld e,Interaction.state		; $5b0b
	ld a,(de)		; $5b0d
	rst_jumpTable			; $5b0e
	.dw @state0
	.dw _companionScript_runScript

@state0:
	ld a,$01		; $5b13
	ld (de),a		; $5b15

	xor a			; $5b16
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a		; $5b17

	; Check whether the event is applicable right now
	ld a,GLOBALFLAG_TALKED_TO_HEAD_CARPENTER		; $5b1a
	call checkGlobalFlag		; $5b1c
	jr z,_companionScript_deleteSelf	; $5b1f

	ld a,GLOBALFLAG_GOT_FLUTE		; $5b21
	call checkGlobalFlag		; $5b23
	jp nz,_companionScript_deleteSelf		; $5b26

	; Put companion index (0-2) in var39
	ld hl,wAnimalCompanion		; $5b29
	ld a,(hl)		; $5b2c
	sub SPECIALOBJECTID_FIRST_COMPANION			; $5b2d
	ld e,Interaction.var39		; $5b2f
	ld (de),a		; $5b31

	ld c,a			; $5b32
	ld hl,@animationWhenNoticingLink		; $5b33
	rst_addAToHl			; $5b36
	ld a,(hl)		; $5b37
	ld e,Interaction.var38		; $5b38
	ld (de),a		; $5b3a

	ld a,c			; $5b3b
	add a			; $5b3c
	ld hl,@data1		; $5b3d
	rst_addDoubleIndex			; $5b40
	ldi a,(hl)		; $5b41
	ld (wTextSubstitutions),a		; $5b42
	call checkIsLinkedGame		; $5b45
	jr z,+			; $5b48
	ldi a,(hl)		; $5b4a
+
	ldi a,(hl)		; $5b4b
	ld (wTextSubstitutions+1),a		; $5b4c
	ld hl,companionScript_subid09Script		; $5b4f
	jp interactionSetScript		; $5b52


; b0: first text to show
; b1: text to show after that (unlinked)
; b2: text to show after that (linked)
@data1:
	.db <TX_1133, <TX_1134, <TX_1135, $00
	.db <TX_113a, <TX_113b, <TX_113c, $00
	.db <TX_1141, <TX_1142, <TX_1143, $00

@animationWhenNoticingLink:
	.db $00 ; Ricky
	.db $1e ; Dimitri
	.db $03 ; Moosh


; Script just outside the forest, where you get the flute
_companionScript_subid0a:
	ld e,Interaction.state		; $5b64
	ld a,(de)		; $5b66
	rst_jumpTable			; $5b67
	.dw @state0
	.dw _companionScript_runScript
	.dw _companionScript_subid0a_state2
	.dw _companionScript_subid0a_state3

@state0:
	ld a,GLOBALFLAG_SAVED_COMPANION_FROM_FOREST		; $5b70
	call checkGlobalFlag		; $5b72
	jp z,_companionScript_delete		; $5b75

	ld a,GLOBALFLAG_GOT_FLUTE		; $5b78
	call checkGlobalFlag		; $5b7a
	jp nz,_companionScript_delete		; $5b7d

	ld a,$01		; $5b80
	ld (de),a ; [state] = 1
	ld (wMenuDisabled),a		; $5b83
	ld (wDisabledObjects),a		; $5b86
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a		; $5b89

	ld a,DIR_UP		; $5b8c
	ld (w1Link.direction),a		; $5b8e

	; Put companion index (0-2) in var39
	ld hl,wAnimalCompanion		; $5b91
	ld a,(hl)		; $5b94
	sub SPECIALOBJECTID_FIRST_COMPANION			; $5b95
	ld e,Interaction.var39		; $5b97
	ld (de),a		; $5b99

	; Determine text to show for this companion
	add a			; $5b9a
	ld hl,@textIndices		; $5b9b
	rst_addDoubleIndex			; $5b9e
	ldi a,(hl)		; $5b9f
	ld (wTextSubstitutions+1),a		; $5ba0
	call checkIsLinkedGame		; $5ba3
	jr z,+			; $5ba6
	ldi a,(hl)		; $5ba8
+
	ldi a,(hl)		; $5ba9
	ld (wTextSubstitutions),a		; $5baa

	; Spawn in the fairies
	ld bc,$1103		; $5bad
@nextFairy:
	push bc			; $5bb0
	ldbc INTERACID_FOREST_FAIRY, $04		; $5bb1
	call objectCreateInteraction		; $5bb4
	pop bc			; $5bb7
	ld l,Interaction.var03		; $5bb8
	ld (hl),b		; $5bba
	inc b			; $5bbb
	dec c			; $5bbc
	jr nz,@nextFairy	; $5bbd

	ld hl,companionScript_subid0aScript		; $5bbf
	jp interactionSetScript		; $5bc2


; b0: Second text to show (after giving you the flute)
; b1: First text to show (unlinked)
; b2: First text to show (linked)
@textIndices:
	.db <TX_1139, <TX_1136, <TX_1137, $00 ; Ricky
	.db <TX_1140, <TX_113d, <TX_113e, $00 ; Dimitri
	.db <TX_1147, <TX_1144, <TX_1145, $00 ; Moosh


; Script in first screen of forest, where fairy leads you to the companion
_companionScript_subid0b:
	ld e,Interaction.state		; $5bd1
	ld a,(de)		; $5bd3
	rst_jumpTable			; $5bd4
	.dw @state0
	.dw _companionScript_runScript

@state0:
	ld a,(wScreenTransitionDirection)		; $5bd9
	cp DIR_DOWN			; $5bdc
	jr nz,_companionScript_delete	; $5bde
	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST		; $5be0
	call checkGlobalFlag		; $5be2
	jr z,_companionScript_delete	; $5be5

	ld a,GLOBALFLAG_GOT_FLUTE		; $5be7
	call checkGlobalFlag		; $5be9
	jr nz,_companionScript_delete	; $5bec

	ldbc INTERACID_FOREST_FAIRY, $03		; $5bee
	call objectCreateInteraction		; $5bf1
	ld l,Interaction.var03		; $5bf4
	ld (hl),$14		; $5bf6

	ld a,$81		; $5bf8
	ld (wMenuDisabled),a		; $5bfa
	ld (wDisabledObjects),a		; $5bfd

	xor a			; $5c00
	ld (wTmpcfc0.fairyHideAndSeek.cfd2),a		; $5c01

	ld hl,companionScript_subid0bScript		; $5c04
	call interactionSetScript		; $5c07
	jp interactionIncState		; $5c0a


; Sets bit 6 of wDimitriState so he disappears from Tokay Island
_companionScript_subid0c:
	ld a,(wDimitriState)		; $5c0d
	bit 5,a			; $5c10
	jr z,_companionScript_delete	; $5c12
	or $40			; $5c14
	ld (wDimitriState),a		; $5c16
	jr _companionScript_delete		; $5c19

;;
; @addr{5c1b}
_companionScript_subid00_state1:
	; If var3a is nonzero, make Moosh shake in fear
	ld e,Interaction.var3a		; $5c1b
	ld a,(de)		; $5c1d
	or a			; $5c1e
	jr z,_companionScript_runScript		; $5c1f

	dec a			; $5c21
	ld (de),a		; $5c22
	and $03			; $5c23
	jr nz,_companionScript_runScript		; $5c25
	ld a,(w1Companion.xh)		; $5c27
	xor $02			; $5c2a
	ld (w1Companion.xh),a		; $5c2c

_companionScript_runScript:
	call interactionRunScript		; $5c2f
	ret nc			; $5c32
	call setStatusBarNeedsRefreshBit1		; $5c33
_companionScript_delete:
	jp interactionDelete		; $5c36


; This is the part which gives Link the flute.
_companionScript_subid0a_state2:
	ld a,TREASURE_FLUTE		; $5c39
	call checkTreasureObtained		; $5c3b
	ld c,<TX_0038		; $5c3e
	jr nc,+			; $5c40
	ld c,<TX_0069		; $5c42
+
	ld e,Interaction.var39 ; Companion index
	ld a,(de)		; $5c46
	add c			; $5c47
	ld c,a			; $5c48
	ld b,>TX_0038		; $5c49
	call showText		; $5c4b

	ld a,$01		; $5c4e
	ld (wMenuDisabled),a		; $5c50
	call interactionIncState		; $5c53

	; Set wFluteIcon
	ld e,Interaction.var39		; $5c56
	ld a,(de)		; $5c58
	ld c,a			; $5c59
	inc a			; $5c5a
	ld (de),a		; $5c5b
	ld hl,wFluteIcon		; $5c5c
	ld (hl),a		; $5c5f

	; Set bit 7 of wRickyState / wDimitriState / wMooshState
	add <wCompanionStates - 1			; $5c60
	ld l,a			; $5c62
	set 7,(hl)		; $5c63

	; Give flute
	ld a,TREASURE_FLUTE		; $5c65
	call giveTreasure		; $5c67
	ld hl,wStatusBarNeedsRefresh		; $5c6a
	set 0,(hl)		; $5c6d

	; Turn this object into the flute graphic?
	ld e,Interaction.subid		; $5c6f
	xor a			; $5c71
	ld (de),a		; $5c72
	call interactionInitGraphics		; $5c73
	ld e,Interaction.subid		; $5c76
	ld a,$0a		; $5c78
	ld (de),a		; $5c7a

	; Set this object's palette
	ld e,Interaction.var39		; $5c7b
	ld a,(de)		; $5c7d
	ld c,a			; $5c7e
	and $01			; $5c7f
	add a			; $5c81
	xor c			; $5c82
	ld e,Interaction.oamFlags		; $5c83
	ld (de),a		; $5c85

	; Set this object's position
	ld hl,w1Link		; $5c86
	ld bc,$f200		; $5c89
	call objectTakePositionWithOffset		; $5c8c

	; Make Link hold it over his head
	ld hl,wLinkForceState		; $5c8f
	ld a,LINK_STATE_04		; $5c92
	ldi (hl),a		; $5c94
	ld (hl),$01 ; [wcc50] = $01
	call objectSetVisible80		; $5c97
	jp interactionRunScript		; $5c9a


_companionScript_subid0a_state3:
	call retIfTextIsActive		; $5c9d

	; ??
	ld a,(wLinkObjectIndex)		; $5ca0
	and $0f			; $5ca3
	add a			; $5ca5
	swap a			; $5ca6
	ld (wDisabledObjects),a		; $5ca8

	; Make flute disappear, wait for script to end
	call objectSetInvisible		; $5cab
	call interactionRunScript		; $5cae
	ret nc			; $5cb1

	; Clean up, delete self
	xor a			; $5cb2
	ld (wDisabledObjects),a		; $5cb3
	ld (wMenuDisabled),a		; $5cb6
	jp _companionScript_delete		; $5cb9


; ==============================================================================
; INTERACID_KING_MOBLIN_DEFEATED
; ==============================================================================
interactionCode72:
	ld e,Interaction.subid		; $5cbc
	ld a,(de)		; $5cbe
	ld e,Interaction.state		; $5cbf
	rst_jumpTable			; $5cc1
	.dw @subid0
	.dw @subid1
	.dw @subid2


; Subid 0: King moblin / "parent" for other subids
@subid0:
	ld a,(de)		; $5cc8
	or a			; $5cc9
	jr z,@subid0State0	; $5cca

@subid0State1:
	call interactionRunScript		; $5ccc
	jp nc,interactionAnimate		; $5ccf
	call getFreeInteractionSlot		; $5cd2
	ret nz			; $5cd5

	; Spawn instance of this object with subid 2
	ld (hl),INTERACID_KING_MOBLIN_DEFEATED		; $5cd6
	inc l			; $5cd8
	ld (hl),$02		; $5cd9
	ld l,Interaction.yh		; $5cdb
	ld (hl),$68		; $5cdd
	jp interactionDelete		; $5cdf

@subid0State0:
	call getThisRoomFlags		; $5ce2
	bit 6,a			; $5ce5
	jp nz,interactionDelete		; $5ce7

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $5cea
	call checkGlobalFlag		; $5cec
	jp z,interactionDelete		; $5cef

	call setDeathRespawnPoint		; $5cf2
	ld a,$80		; $5cf5
	ld (wDisabledObjects),a		; $5cf7
	ld (wMenuDisabled),a		; $5cfa

	call @spawnSubservientMoblin		; $5cfd
	ld (hl),$38		; $5d00
	call @spawnSubservientMoblin		; $5d02
	ld (hl),$78		; $5d05

	ld hl,$cfd0		; $5d07
	ld b,$04		; $5d0a
	call clearMemory		; $5d0c

	ld a,$02		; $5d0f
	call fadeinFromWhiteWithDelay		; $5d11
	ld hl,kingMoblinDefeated_kingScript		; $5d14

@setScriptAndInitStuff:
	call interactionSetScript		; $5d17
	call interactionInitGraphics		; $5d1a
	call interactionIncState		; $5d1d

	ld l,Interaction.speed		; $5d20
	ld (hl),SPEED_180		; $5d22
	ld l,Interaction.angle		; $5d24
	ld (hl),ANGLE_DOWN		; $5d26
	jp objectSetVisible82		; $5d28


; Spawn an instance of subid 1, the normal moblins
@spawnSubservientMoblin:
	call getFreeInteractionSlot		; $5d2b
	ret nz			; $5d2e
	ld (hl),INTERACID_KING_MOBLIN_DEFEATED		; $5d2f
	inc l			; $5d31
	inc (hl)		; $5d32
	ld l,Interaction.yh		; $5d33
	ld (hl),$68		; $5d35
	ld l,Interaction.xh		; $5d37
	ret			; $5d39


; Subid 1: Normal moblin following him
@subid1:
	ld a,(de)		; $5d3a
	or a			; $5d3b
	jr z,@subid1State0	; $5d3c

@runScriptAndAnimate:
	call interactionRunScript		; $5d3e
	jp nc,interactionAnimate		; $5d41
	jp interactionDelete		; $5d44

@subid1State0:
	ld hl,kingMoblinDefeated_helperMoblinScript		; $5d47
	jr @setScriptAndInitStuff		; $5d4a


; Subid 2: Gorons who approach after he leaves (var03 = index)
@subid2:
	ld a,(de)		; $5d4c
	or a			; $5d4d
	jr nz,@runScriptAndAnimate	; $5d4e

	call interactionInitGraphics		; $5d50
	call interactionIncState		; $5d53
	ld l,Interaction.speed		; $5d56
	ld (hl),SPEED_80		; $5d58

	; Load script
	ld e,Interaction.var03		; $5d5a
	ld a,(de)		; $5d5c
	ld hl,@scriptTable		; $5d5d
	rst_addDoubleIndex			; $5d60
	ldi a,(hl)		; $5d61
	ld h,(hl)		; $5d62
	ld l,a			; $5d63
	call interactionSetScript		; $5d64

	call objectSetVisible82		; $5d67

	; Load data from table
	ld e,Interaction.var03		; $5d6a
	ld a,(de)		; $5d6c
	add a			; $5d6d
	ld hl,@goronData		; $5d6e
	rst_addDoubleIndex			; $5d71
	ld e,Interaction.yh		; $5d72
	ldi a,(hl)		; $5d74
	ld (de),a		; $5d75
	ld e,Interaction.xh		; $5d76
	ldi a,(hl)		; $5d78
	ld (de),a		; $5d79
	ld e,Interaction.angle		; $5d7a
	ldi a,(hl)		; $5d7c
	ld (de),a		; $5d7d
	ld a,(hl)		; $5d7e
	call interactionSetAnimation		; $5d7f

	; If [var03] == 0, spawn the other gorons
	ld e,Interaction.var03		; $5d82
	ld a,(de)		; $5d84
	or a			; $5d85
	ret nz			; $5d86

	ld b,$01		; $5d87
	call @spawnGoronInstance		; $5d89
	inc b			; $5d8c
	call @spawnGoronInstance		; $5d8d
	inc b			; $5d90

@spawnGoronInstance:
	call getFreeInteractionSlot		; $5d91
	ret nz			; $5d94
	ld (hl),INTERACID_KING_MOBLIN_DEFEATED		; $5d95
	inc l			; $5d97
	ld (hl),$02		; $5d98
	inc l			; $5d9a
	ld (hl),b		; $5d9b
	ret			; $5d9c

@scriptTable:
	.dw kingMoblinDefeated_goron0
	.dw kingMoblinDefeated_goron1
	.dw kingMoblinDefeated_goron2
	.dw kingMoblinDefeated_goron3

; b0: Y
; b1: X
; b2: angle
; b3: animation
@goronData:
	.db $88 $38 $00 $04 ; $00 == [var03]
	.db $58 $a8 $18 $07 ; $01
	.db $88 $90 $00 $04 ; $02
	.db $88 $58 $00 $04 ; $03


; ==============================================================================
; INTERACID_GHINI_HARASSING_MOOSH
; ==============================================================================
interactionCode73:
	ld h,d			; $5db5
	ld l,Interaction.subid		; $5db6
	ldi a,(hl)		; $5db8
	or a			; $5db9
	jr nz,@checkState	; $5dba

	inc l			; $5dbc
	ld a,(hl)		; $5dbd
	or a			; $5dbe
	jr z,@checkState	; $5dbf

	ld a,(wScrollMode)		; $5dc1
	and $0e			; $5dc4
	ret nz			; $5dc6

@checkState:
	ld e,Interaction.state		; $5dc7
	ld a,(de)		; $5dc9
	rst_jumpTable			; $5dca
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $5dcf
	ld (de),a		; $5dd1

	; Delete self if they shouldn't be here right now
	ld a,(wEssencesObtained)		; $5dd2
	bit 1,a			; $5dd5
	jr z,@delete		; $5dd7

	ld a,(wPastRoomFlags+$79)		; $5dd9
	bit 6,a			; $5ddc
	jr z,@delete		; $5dde

	ld a,(wMooshState)		; $5de0
	and $60			; $5de3
	jr nz,@delete		; $5de5

	call interactionInitGraphics		; $5de7
	call interactionSetAlwaysUpdateBit		; $5dea
	ld l,Interaction.zh		; $5ded
	ld (hl),-2		; $5def

	; Load script
	ld e,Interaction.subid		; $5df1
	ld a,(de)		; $5df3
	ld hl,@scriptTable		; $5df4
	rst_addDoubleIndex			; $5df7
	ldi a,(hl)		; $5df8
	ld h,(hl)		; $5df9
	ld l,a			; $5dfa
	call interactionSetScript		; $5dfb
	jp objectSetVisiblec0		; $5dfe

@state1:
	call interactionAnimate		; $5e01
	ld e,Interaction.speed		; $5e04
	ld a,(de)		; $5e06
	or a			; $5e07
	jr z,++			; $5e08

	; While the ghini is moving, make them "rotate" in position.
	call objectApplySpeed		; $5e0a
	ld e,Interaction.angle		; $5e0d
	ld a,(de)		; $5e0f
	dec a			; $5e10
	and $1f			; $5e11
	ld (de),a		; $5e13
	cp $18			; $5e14
	jr nz,++		; $5e16

	xor a			; $5e18
	ld e,Interaction.speed		; $5e19
	ld (de),a		; $5e1b
++
	call interactionRunScript		; $5e1c
	ret nc			; $5e1f
@delete:
	jp interactionDelete		; $5e20

@scriptTable:
	.dw ghiniHarassingMoosh_subid00Script
	.dw ghiniHarassingMoosh_subid01Script
	.dw ghiniHarassingMoosh_subid02Script


; ==============================================================================
; INTERACID_RICKYS_GLOVE_SPAWNER
; ==============================================================================
interactionCode74:
	; Delete self if already returned gloves, haven't talked to Ricky, or already got
	; gloves
	ld a,(wRickyState)		; $5e29
	bit 5,a			; $5e2c
	jr nz,@delete	; $5e2e
	and $01			; $5e30
	jr z,@delete	; $5e32
	ld a,TREASURE_RICKY_GLOVES		; $5e34
	call checkTreasureObtained		; $5e36
	jr c,@delete	; $5e39

	ldbc INTERACID_TREASURE, TREASURE_RICKY_GLOVES		; $5e3b
	call objectCreateInteraction		; $5e3e
	ret nz			; $5e41
@delete:
	jp interactionDelete		; $5e42


; ==============================================================================
; INTERACID_INTRO_SPRITE
; ==============================================================================
interactionCode75:
	ld e,Interaction.state		; $5e45
	ld a,(de)		; $5e47
	rst_jumpTable			; $5e48
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState		; $5e4d
	call interactionInitGraphics		; $5e50
	call objectSetVisible82		; $5e53
	ld e,Interaction.subid		; $5e56
	ld a,(de)		; $5e58
	rst_jumpTable			; $5e59
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init

@subid0Init:
@subid5Init:
	ret			; $5e68

@subid1Init:
	ld h,d			; $5e69
	ld l,Interaction.counter1		; $5e6a
	ld (hl),$05		; $5e6c

@initSpeedToScrollLeft:
	ld l,Interaction.angle		; $5e6e
	ld (hl),ANGLE_LEFT		; $5e70
	ld l,Interaction.speed		; $5e72
	ld (hl),SPEED_20		; $5e74
	ld bc,$7080		; $5e76
	jp interactionSetPosition		; $5e79

@subid2Init:
	call objectSetVisible83		; $5e7c
	ld h,d			; $5e7f
	jr @initSpeedToScrollLeft		; $5e80

@subid3Init:
	ld bc,$4c6c		; $5e82
	call interactionSetPosition		; $5e85
	ld l,Interaction.angle		; $5e88
	ld (hl),$19		; $5e8a
	ld l,Interaction.speed		; $5e8c
	ld (hl),SPEED_40		; $5e8e
	ret			; $5e90

@subid4Init:
	ld bc,$1838		; $5e91
	jp interactionSetPosition		; $5e94

@subid6Init:
	ld h,d			; $5e97
	ld l,Interaction.angle		; $5e98
	ld (hl),$1a		; $5e9a
	ld l,Interaction.speed		; $5e9c
	ld (hl),SPEED_60		; $5e9e
	ret			; $5ea0

@state1:
	ld e,Interaction.subid		; $5ea1
	ld a,(de)		; $5ea3
	rst_jumpTable			; $5ea4
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid2
	.dw @runSubid3
	.dw interactionAnimate
	.dw @runSubid5
	.dw @runSubid6

@runSubid0:
@runSubid5:
	ld a,(wIntro.cbba)		; $5eb3
	or a			; $5eb6
	jp z,interactionAnimate		; $5eb7
	jp interactionDelete		; $5eba

@runSubid1:
	call checkInteractionState2		; $5ebd
	jr nz,@updateSpeed	; $5ec0

	call interactionAnimate		; $5ec2
	ld h,d			; $5ec5
	ld l,Interaction.animParameter		; $5ec6
	ld a,(hl)		; $5ec8
	or a			; $5ec9
	jr z,@updateSpeed	; $5eca

	ld (hl),$00		; $5ecc
	ld l,Interaction.counter1		; $5ece
	dec (hl)		; $5ed0
	jr nz,@updateSpeed	; $5ed1

	ld l,Interaction.state2		; $5ed3
	inc (hl)		; $5ed5
	ld a,$04		; $5ed6
	call interactionSetAnimation		; $5ed8

@updateSpeed:
@runSubid2:
	ld hl,wIntro.cbb6		; $5edb
	ld a,(hl)		; $5ede
	or a			; $5edf
	ret z			; $5ee0
	jp objectApplySpeed		; $5ee1

@runSubid3:
	call interactionAnimate		; $5ee4
	ld a,(wIntro.frameCounter)		; $5ee7
	and $03			; $5eea
	ret nz			; $5eec
	jp objectApplySpeed		; $5eed

@runSubid6:
	ld a,(wTmpcbba)		; $5ef0
	or a			; $5ef3
	jp nz,interactionDelete		; $5ef4
	ld a,(wPaletteThread_mode)		; $5ef7
	or a			; $5efa
	ret nz			; $5efb
	call interactionAnimate		; $5efc
	jp objectApplySpeed		; $5eff


; ==============================================================================
; INTERACID_MAKU_GATE_OPENING
; ==============================================================================
interactionCode76:
	ld e,Interaction.subid		; $5f02
	ld a,(de)		; $5f04
	rst_jumpTable			; $5f05
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	ld e,Interaction.state		; $5f0a
	ld a,(de)		; $5f0c
	rst_jumpTable			; $5f0d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $5f16
	ld l,Interaction.state		; $5f17
	inc (hl)		; $5f19
	ld l,Interaction.counter1		; $5f1a
	ld (hl),30		; $5f1c
	ld l,Interaction.subid		; $5f1e
	ld a,(hl)		; $5f20
	or a			; $5f21
	ld hl,@frame0And1_subid0		; $5f22
	jr z,+			; $5f25
	ld hl,@frame0And1_subid1		; $5f27
+
	call @loadInterleavedTiles		; $5f2a
	ld bc,@frame0_poof		; $5f2d
	call @loadPoofs		; $5f30

@shakeScreen:
	ld a,$06		; $5f33
	call setScreenShakeCounter		; $5f35
	ld a,SND_DOORCLOSE		; $5f38
	jp playSound		; $5f3a

@state1:
	call interactionDecCounter1		; $5f3d
	ret nz			; $5f40
	ld hl,@frame0And1_subid0		; $5f41
	call @loadTiles		; $5f44
	ld bc,@frame1_poof		; $5f47
	call @loadPoofs		; $5f4a
	call @shakeScreen		; $5f4d
	ld h,d			; $5f50
	ld l,Interaction.state		; $5f51
	inc (hl)		; $5f53
	ld l,Interaction.counter1		; $5f54
	ld (hl),30		; $5f56
	ret			; $5f58

@state2:
	call interactionDecCounter1		; $5f59
	ret nz			; $5f5c
	ld hl,@frame2And3		; $5f5d
	call @loadInterleavedTiles		; $5f60
	ld bc,@frame2_poof		; $5f63
	call @loadPoofs		; $5f66
	call @shakeScreen		; $5f69

	ld h,d			; $5f6c
	ld l,Interaction.state		; $5f6d
	inc (hl)		; $5f6f
	ld l,Interaction.counter1		; $5f70
	ld (hl),30		; $5f72
	ret			; $5f74

@state3:
	call interactionDecCounter1		; $5f75
	ret nz			; $5f78
	ld hl,@frame2And3		; $5f79
	call @loadTiles		; $5f7c
	ld bc,@frame3_poof		; $5f7f
	call @loadPoofs		; $5f82
	call @shakeScreen		; $5f85
	call getThisRoomFlags		; $5f88
	set 7,(hl)		; $5f8b
	jp interactionDelete		; $5f8d

@frame0And1_subid0:
	.db $02
	.db $74 $f9 $8e $03
	.db $75 $f9 $8e $01

@frame0And1_subid1:
	.db $02
	.db $74 $f9 $8c $03
	.db $75 $f9 $8c $01

@frame2And3:
	.db $02
	.db $73 $f9 $8c $03
	.db $76 $f9 $8c $01

@frame0_poof:
	.db $04
	.db $74 $48
	.db $74 $58
	.db $7c $48
	.db $7c $58

@frame1_poof:
	.db $04
	.db $74 $40
	.db $74 $60
	.db $7c $40
	.db $7c $60

@frame2_poof:
	.db $04
	.db $74 $38
	.db $74 $68
	.db $7c $38
	.db $7c $68

@frame3_poof:
	.db $04
	.db $74 $30
	.db $74 $70
	.db $7c $30
	.db $7c $70

;;
; @param	hl	Pointer to data
; @addr{5fcf}
@loadInterleavedTiles:
	ldi a,(hl)		; $5fcf
	ld b,a			; $5fd0
@@next:
	ldi a,(hl)		; $5fd1
	ldh (<hFF8C),a	; $5fd2
	ldi a,(hl)		; $5fd4
	ldh (<hFF8F),a	; $5fd5
	ldi a,(hl)		; $5fd7
	ldh (<hFF8E),a	; $5fd8
	ldi a,(hl)		; $5fda
	push hl			; $5fdb
	push bc			; $5fdc
	call setInterleavedTile		; $5fdd
	pop bc			; $5fe0
	pop hl			; $5fe1
	dec b			; $5fe2
	jr nz,@@next	; $5fe3
	ret			; $5fe5

;;
; @param	hl	Pointer to data
; @addr{5fe6}
@loadTiles:
	ldi a,(hl)		; $5fe6
	ld b,a			; $5fe7
@@next:
	ldi a,(hl)		; $5fe8
	ld c,a			; $5fe9
	ld a,(hl)		; $5fea
	push hl			; $5feb
	push bc			; $5fec
	call setTile		; $5fed
	pop bc			; $5ff0
	pop hl			; $5ff1
	inc hl			; $5ff2
	inc hl			; $5ff3
	inc hl			; $5ff4
	dec b			; $5ff5
	jr nz,@@next	; $5ff6
	ret			; $5ff8

;;
; @param	hl	Pointer to poof position data
; @addr{5ff9}
@loadPoofs:
	ld a,(bc)		; $5ff9
	inc bc			; $5ffa
@@next:
	ldh (<hFF8B),a	; $5ffb
	call getFreeInteractionSlot		; $5ffd
	ret nz			; $6000
	ld (hl),INTERACID_PUFF		; $6001
	ld l,Interaction.yh		; $6003
	ld a,(bc)		; $6005
	ld (hl),a		; $6006
	inc bc			; $6007
	ld l,Interaction.xh		; $6008
	ld a,(bc)		; $600a
	ld (hl),a		; $600b
	inc bc			; $600c
	ldh a,(<hFF8B)	; $600d
	dec a			; $600f
	jr nz,@@next	; $6010
	ld a,SND_KILLENEMY		; $6012
	jp playSound		; $6014


; ==============================================================================
; INTERACID_SMALL_KEY_ON_ENEMY
; ==============================================================================
interactionCode77:
	ld e,Interaction.state		; $6017
	ld a,(de)		; $6019
	rst_jumpTable			; $601a
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags		; $6021
	and ROOMFLAG_ITEM			; $6024
	jp nz,interactionDelete		; $6026

	ld e,Interaction.subid		; $6029
	ld a,(de)		; $602b
	ld b,a			; $602c
	ldhl FIRST_ENEMY_INDEX, Enemy.id		; $602d
@nextEnemy:
	ld a,(hl)		; $6030
	cp b			; $6031
	jr z,@foundMatch	; $6032
	inc h			; $6034
	ld a,h			; $6035
	cp LAST_ENEMY_INDEX+1			; $6036

	; BUG: Original game does "jp c", meaning this only works if the enemy in
	; question is in the first enemy slot.
.ifdef ENABLE_BUGFIXES
	jp nc,interactionDelete
.else
	jp c,interactionDelete		; $6038
.endif
	jr @nextEnemy		; $603b

; Found the enemy to attach the key to
@foundMatch:
	dec l			; $603d
	ld a,l			; $603e
	ld e,Interaction.relatedObj2		; $603f
	ld (de),a		; $6041
	ld a,h			; $6042
	inc e			; $6043
	ld (de),a		; $6044
	call interactionInitGraphics		; $6045
	call objectSetVisible80		; $6048
	call interactionIncState		; $604b

@takeRelatedObj2Position:
	ld a,Object.y		; $604e
	call objectGetRelatedObject2Var		; $6050
	jp objectTakePosition		; $6053

@state1: ; Copies the position of relatedObj2
	ld a,Object.enabled		; $6056
	call objectGetRelatedObject2Var		; $6058
	ld a,(hl)		; $605b
	or a			; $605c
	jp z,interactionIncState		; $605d

	call @takeRelatedObj2Position		; $6060
	ld a,Object.visible		; $6063
	call objectGetRelatedObject2Var		; $6065
	ld b,$01		; $6068
	jp objectFlickerVisibility		; $606a

@state2: ; relatedObj2 is gone, fall to the ground and create a key
	call objectSetVisible		; $606d
	ld c,$20		; $6070
	call objectUpdateSpeedZ_paramC		; $6072
	ret nz			; $6075
	ldbc TREASURE_SMALL_KEY,$00		; $6076
	call createTreasure		; $6079
	call objectCopyPosition		; $607c
	jp interactionDelete		; $607f


; ==============================================================================
; INTERACID_STONE_PANEL
; ==============================================================================
interactionCode7b:
	ld e,Interaction.state		; $6082
	ld a,(de)		; $6084
	rst_jumpTable			; $6085
	.dw @state0
	.dw @state1
	.dw @state2
	.dw objectPreventLinkFromPassing

@state0:
	ld bc,$0e08		; $608e
	call objectSetCollideRadii		; $6091
	call interactionInitGraphics		; $6094
	call objectSetVisible83		; $6097
	ld a,PALH_7e		; $609a
	call loadPaletteHeader		; $609c
	call getThisRoomFlags		; $609f
	and $40			; $60a2
	jr nz,@initializeOpenedState	; $60a4

	; Closed
	ld hl,wRoomCollisions+$66		; $60a6
	ld a,$0f		; $60a9
	ldi (hl),a		; $60ab
	ldi (hl),a		; $60ac
	ld (hl),a		; $60ad
	jp interactionIncState		; $60ae

@initializeOpenedState:
	ld e,Interaction.state		; $60b1
	ld a,$03		; $60b3
	ld (de),a		; $60b5

	; Move position 10 left or right
	ld e,Interaction.subid		; $60b6
	ld a,(de)		; $60b8
	or a			; $60b9
	ld b,$10		; $60ba
	jr nz,+			; $60bc
	ld b,$f0		; $60be
+
	ld e,Interaction.xh		; $60c0
	ld a,(de)		; $60c2
	add b			; $60c3
	ld (de),a		; $60c4

	ld e,Interaction.state		; $60c5
	ld a,$03		; $60c7
	ld (de),a		; $60c9

@updateSolidityUponOpening:
	ld hl,wRoomCollisions+$66		; $60ca
	xor a			; $60cd
	ldi (hl),a		; $60ce
	ldi (hl),a		; $60cf
	ld (hl),a		; $60d0
	ld l,$46		; $60d1
	ld (hl),$02		; $60d3
	ld l,$56		; $60d5
	ld (hl),$0a		; $60d7
	ld l,$66		; $60d9
	ld (hl),$08		; $60db
	ld l,$48		; $60dd
	ld (hl),$01		; $60df
	ld l,$58		; $60e1
	ld (hl),$05		; $60e3
	ld l,$68		; $60e5
	ld (hl),$04		; $60e7
	ret			; $60e9

; Wait for bit 7 of wActiveTriggers to open the panel.
@state1:
	call objectPreventLinkFromPassing		; $60ea
	ld a,(wActiveTriggers)		; $60ed
	bit 7,a			; $60f0
	ret z			; $60f2

	ld a,$81		; $60f3
	ld (wDisabledObjects),a		; $60f5
	ld (wMenuDisabled),a		; $60f8
	ld e,Interaction.counter1		; $60fb
	ld a,60		; $60fd
	ld (de),a		; $60ff
	ld a,SNDCTRL_STOPMUSIC		; $6100
	call playSound		; $6102
	jp interactionIncState		; $6105

@state2:
	call objectPreventLinkFromPassing		; $6108
	ld e,Interaction.state2		; $610b
	ld a,(de)		; $610d
	rst_jumpTable			; $610e
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0: ; Delay before opening
	call interactionDecCounter1		; $6115
	ret nz			; $6118

	ld (hl),$80		; $6119
	ld e,Interaction.subid		; $611b
	ld a,(de)		; $611d
	or a			; $611e
	ld a,ANGLE_LEFT		; $611f
	jr z,+			; $6121
	ld a,ANGLE_RIGHT		; $6123
+
	ld e,Interaction.angle		; $6125
	ld (de),a		; $6127
	ld e,Interaction.speed		; $6128
	ld a,SPEED_20		; $612a
	ld (de),a		; $612c

	ld a,SND_OPENING		; $612d
	call playSound		; $612f
	jp interactionIncState2		; $6132

@substate1: ; Currently opening
	ld a,(wFrameCounter)		; $6135
	rrca			; $6138
	ret nc			; $6139
	call objectApplySpeed		; $613a
	call interactionDecCounter1		; $613d
	ret nz			; $6140
	ld (hl),30		; $6141
	jp interactionIncState2		; $6143

@substate2: ; Done opening
	call interactionDecCounter1		; $6146
	ret nz			; $6149

	xor a			; $614a
	ld (wDisabledObjects),a		; $614b
	ld (wMenuDisabled),a		; $614e
	ld hl,wActiveTriggers		; $6151
	res 7,(hl)		; $6154
	call getThisRoomFlags		; $6156
	set 6,(hl)		; $6159

	call @updateSolidityUponOpening		; $615b
	ld a,(wActiveMusic)		; $615e
	call playSound		; $6161
	jp interactionIncState		; $6164


; ==============================================================================
; INTERACID_SCREEN_DISTORTION
; ==============================================================================
interactionCode7c:
	call checkInteractionState		; $6167
	jr z,@state0		; $616a

@state1:
	ld a,$01		; $616c
	jp loadBigBufferScrollValues		; $616e

@state0:
	call interactionSetAlwaysUpdateBit		; $6171
	call interactionIncState		; $6174
	ld a,$10		; $6177
	ld (wGfxRegs2.LYC),a		; $6179
	ld a,$02		; $617c
	ldh (<hNextLcdInterruptBehaviour),a	; $617e
	ld a,SND_WARP_START		; $6180
	call playSound		; $6182
	ld a,$ff		; $6185
	jp initWaveScrollValues		; $6187


; ==============================================================================
; INTERACID_DECORATION
; ==============================================================================
interactionCode80:
	call checkInteractionState		; $618a
	jr z,@state0		; $618d

@state1:
	ld e,Interaction.subid		; $618f
	ld a,(de)		; $6191
	rst_jumpTable			; $6192
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw @deleteIfGotRoomItem
	.dw @deleteIfGotRoomItem
	.dw interactionAnimate
	.dw interactionAnimate

@state0:
	call interactionInitGraphics		; $61a9
	call interactionIncState		; $61ac
	call objectSetVisible83		; $61af
	ld e,Interaction.subid		; $61b2
	ld a,(de)		; $61b4
	rst_jumpTable			; $61b5
	.dw @stub
	.dw @deleteIfMoblinsKeepDestroyed
	.dw @stub
	.dw @stub
	.dw @deleteIfRoomFlagBit7Unset
	.dw @stub
	.dw @deleteIfRoomFlagBit7Unset
	.dw @deleteIfGotRoomItem
	.dw @deleteIfGotRoomItem
	.dw @stub
	.dw @subid0a

@stub:
	ret			; $61cc

; Subid $01 (moblin's keep flag)
@deleteIfMoblinsKeepDestroyed:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $61cd
	call checkGlobalFlag		; $61cf
	ret z			; $61d2
	jp interactionDelete		; $61d3

; Subid $04, $06 (scent seedling & tokay eyeball)
@deleteIfRoomFlagBit7Unset:
	call getThisRoomFlags		; $61d6
	bit 7,a			; $61d9
	ret nz			; $61db
	jp interactionDelete		; $61dc

@deleteIfGotRoomItem:
	call getThisRoomFlags		; $61df
	bit ROOMFLAG_BIT_ITEM,a			; $61e2
	ret z			; $61e4
	jp interactionDelete		; $61e5

; Fountain "stream": decide which palette to used based on whether this is the "ruined"
; symmetry city or not
@subid0a:
	call objectSetVisible80		; $61e8
	call @isSymmetryCityRoom		; $61eb
	jr c,@isSymmetryCity	; $61ee

@normalPalette:
	ld a,PALH_7d		; $61f0
	jp loadPaletteHeader		; $61f2

@isSymmetryCity:
	ld a,(wActiveGroup)		; $61f5
	or a			; $61f8
	jr nz,@ruinedSymmetryPalette	; $61f9
	call getThisRoomFlags		; $61fb
	and $01			; $61fe
	jr nz,@normalPalette	; $6200

@ruinedSymmetryPalette:
	ld a,PALH_7c		; $6202
	jp loadPaletteHeader		; $6204

@isSymmetryCityRoom:
	ld a,(wActiveRoom)		; $6207
	ld e,a			; $620a
	ld hl,@symmetryCityRooms		; $620b
	jp lookupKey		; $620e

@symmetryCityRooms:
	.db $12 $00
	.db $13 $00
	.db $14 $00
	.db $00


; ==============================================================================
; INTERACID_TOKAY_SHOP_ITEM
;
; Variables:
;   var38: If nonzero, item can be bought with seeds
;   var39: Number of seeds Link has of the type needed to buy this item
;   var3a: Set if Link has the shovel
;   var3c: The treasure ID of this item (feather/bracelet only)
;   var3d: Set if Link has the shield
; ==============================================================================
interactionCode81:
	ld e,Interaction.state		; $6218
	ld a,(de)		; $621a
	rst_jumpTable			; $621b
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6220
	ld (de),a		; $6222
	ld a,>TX_0a00		; $6223
	call interactionSetHighTextIndex		; $6225
	call interactionSetAlwaysUpdateBit		; $6228
	ld a,$06		; $622b
	call objectSetCollideRadius		; $622d

	ld l,Interaction.subid		; $6230
	ldi a,(hl)		; $6232
	ld (hl),a ; [var03] = [subid]
	cp $04			; $6234
	jr nz,@initializeItem	; $6236

	; This is the shield; only appears if all other items retrieved. Also, adjust
	; level appropriately.
	ld a,GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY		; $6238
	call checkGlobalFlag		; $623a
	jp z,interactionDelete		; $623d

	ld a,(wShieldLevel)		; $6240
	or a			; $6243
	jr z,@initializeItem	; $6244

	; [subid] = [var03] = [wShieldLevel] + [subid] - 1
	ld e,Interaction.subid		; $6246
	ld c,a			; $6248
	dec c			; $6249
	ld a,(de)		; $624a
	add c			; $624b
	ld (de),a		; $624c
	inc e			; $624d
	ld (de),a		; $624e

@initializeItem:
	call @checkTransformItem		; $624f
	jp nz,interactionDelete		; $6252

	ld hl,tokayShopItemScript		; $6255
	call interactionSetScript		; $6258
	ld e,Interaction.pressedAButton		; $625b
	call objectAddToAButtonSensitiveObjectList		; $625d
	call interactionSetAlwaysUpdateBit		; $6260
	jp objectSetVisible82		; $6263

@initialShopTreasures:
	.db TREASURE_FEATHER, TREASURE_BRACELET

@seedsNeededToBuyItems:
	.db TREASURE_MYSTERY_SEEDS, TREASURE_SCENT_SEEDS, $00, $00,
	.db TREASURE_SCENT_SEEDS, TREASURE_SCENT_SEEDS, TREASURE_SCENT_SEEDS

	; TODO: what is this data? Possibly unused? ($626f)
	.db $28 $76 $6c $76 $b4 $76 $c4 $76

@state1:
	call interactionAnimateAsNpc		; $6277
	call @checkTransformItem		; $627a
	call nz,objectSetInvisible		; $627d
	call interactionRunScript		; $6280
	ret nc			; $6283
	xor a			; $6284
	ld (wDisabledObjects),a		; $6285
	jp interactionDelete		; $6288

;;
; This checks whether to replace the feather/bracelet with the shovel, changing the subid
; accordingly and initializing the graphics after doing so.
;
; @param[out]	zflag	nz if item should be deleted?
; @addr{628b}
@checkTransformItem:
	ld h,d			; $628b
	ld l,Interaction.var38		; $628c
	xor a			; $628e
	ldi (hl),a		; $628f
	ldi (hl),a		; $6290
	ldi (hl),a		; $6291
	ldi (hl),a		; $6292

	ld e,Interaction.var03		; $6293
	ld a,(de)		; $6295
	ld c,a			; $6296
	ld a,TREASURE_SEED_SATCHEL		; $6297
	call checkTreasureObtained		; $6299
	jr nc,@checkReplaceWithShovel	; $629c

	; Seed satchel obtained; set var38/var39 based on whether Link can buy the item?

	ld a,c			; $629e
	ld hl,@seedsNeededToBuyItems		; $629f
	rst_addAToHl			; $62a2
	ld a,(hl)		; $62a3
	call checkTreasureObtained		; $62a4
	jr nc,@checkReplaceWithShovel	; $62a7

	inc a			; $62a9
	ld e,Interaction.var39		; $62aa
	ld (de),a		; $62ac
	cp $10			; $62ad
	jr c,@checkReplaceWithShovel	; $62af

	ld e,Interaction.var38		; $62b1
	ld (de),a		; $62b3

@checkReplaceWithShovel:
	ld a,TREASURE_SHOVEL		; $62b4
	call checkTreasureObtained		; $62b6
	jr nc,++		; $62b9
	ld e,Interaction.var3a		; $62bb
	ld a,$01		; $62bd
	ld (de),a		; $62bf
++
	ld a,TREASURE_SHIELD		; $62c0
	call checkTreasureObtained		; $62c2
	jr nc,++		; $62c5
	ld e,Interaction.var3d		; $62c7
	ld a,$01		; $62c9
	ld (de),a		; $62cb
++
	ld a,c			; $62cc
	cp $04			; $62cd
	jr nc,@setSubidAndInitGraphics	; $62cf

	; The item is the feather or the bracelet.

	; If we've bought the item, it should be deleted.
	ld a,c			; $62d1
	ld hl,@boughtItemGlobalflags		; $62d2
	rst_addAToHl			; $62d5
	ld a,(hl)		; $62d6
	call checkGlobalFlag		; $62d7
	ret nz			; $62da

	; Otherwise, if Link has the item, it should be replaced with the shovel.
	ld a,c			; $62db
	ld hl,@initialShopTreasures		; $62dc
	rst_addAToHl			; $62df
	ld a,(hl)		; $62e0
	ld e,Interaction.var3c		; $62e1
	ld (de),a		; $62e3

	call checkTreasureObtained		; $62e4
	jr nc,@setSubidAndInitGraphics	; $62e7

	; Increment subid by 2, making it a shovel
	inc c			; $62e9
	inc c			; $62ea

@setSubidAndInitGraphics:
	ld e,Interaction.subid		; $62eb
	ld a,c			; $62ed
	ld (de),a		; $62ee
	call interactionInitGraphics		; $62ef
	xor a			; $62f2
	ret			; $62f3

@boughtItemGlobalflags:
	.db GLOBALFLAG_BOUGHT_FEATHER_FROM_TOKAY, GLOBALFLAG_BOUGHT_BRACELET_FROM_TOKAY


; ==============================================================================
; INTERACID_SARCOPHAGUS
; ==============================================================================
interactionCode82:
	ld e,Interaction.state		; $62f6
	ld a,(de)		; $62f8
	rst_jumpTable			; $62f9
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics		; $6302
	ld e,Interaction.subid		; $6305
	ld a,(de)		; $6307
	bit 7,a			; $6308
	jp nz,@break		; $630a

	or a			; $630d
	jr z,++			; $630e
	call getThisRoomFlags		; $6310
	bit 6,a			; $6313
	jp nz,interactionDelete		; $6315
++
	call interactionIncState		; $6318

	ld l,Interaction.collisionRadiusY		; $631b
	ld (hl),$10		; $631d
	ld l,Interaction.collisionRadiusX		; $631f
	ld (hl),$08		; $6321

	call objectMakeTileSolid		; $6323
	ld h,>wRoomLayout		; $6326
	ld (hl),$00		; $6328
	ld a,l			; $632a
	sub $10			; $632b
	ld l,a			; $632d
	ld (hl),$00		; $632e
	ld h,>wRoomCollisions		; $6330
	ld (hl),$0f		; $6332
	jp objectSetVisible83		; $6334

; Waiting for Link to grab
@state1:
	ld a,(wBraceletLevel)		; $6337
	cp $02			; $633a
	ret c			; $633c
	jp objectAddToGrabbableObjectBuffer		; $633d

; Link currently grabbing
@state2:
	inc e			; $6340
	ld a,(de)		; $6341
	rst_jumpTable			; $6342
	.dw @substate0_justGrabbed
	.dw @substate1_holding
	.dw @substate2_justReleased
	.dw @break

@substate0_justGrabbed:
	call interactionIncState2		; $634b
	ld l,Interaction.subid		; $634e
	ld a,(hl)		; $6350
	or a			; $6351
	jr z,++			; $6352

	dec a			; $6354
	ld a,SND_SOLVEPUZZLE		; $6355
	call z,playSound		; $6357
	call getThisRoomFlags		; $635a
	set 6,(hl)		; $635d
++
	call objectGetShortPosition		; $635f
	push af			; $6362
	call getTileIndexFromRoomLayoutBuffer		; $6363
	call setTile		; $6366
	pop af			; $6369
	sub $10			; $636a
	call getTileIndexFromRoomLayoutBuffer		; $636c
	call setTile		; $636f
	xor a			; $6372
	ld (wLinkGrabState2),a		; $6373
	jp objectSetVisiblec1		; $6376

@substate1_holding:
	ret			; $6379

@substate2_justReleased:
	ld h,d			; $637a
	ld l,Interaction.enabled		; $637b
	res 1,(hl)		; $637d

	; Wait for it to hit the ground
	ld l,Interaction.zh		; $637f
	bit 7,(hl)		; $6381
	ret nz			; $6383

@break:
	ld h,d			; $6384
	ld l,Interaction.state		; $6385
	ld (hl),$03		; $6387
	ld l,Interaction.counter1		; $6389
	ld (hl),$02		; $638b

	ld l,Interaction.oamFlagsBackup		; $638d
	ld a,$0c		; $638f
	ldi (hl),a		; $6391
	ldi (hl),a		; $6392
	ld (hl),$40 ; [oamTileIndexBase] = $40

	call objectSetVisible83		; $6395
	xor a			; $6398
	jp interactionSetAnimation		; $6399

; Being destroyed
@state3:
	call interactionDecCounter1		; $639c
	ld a,SND_KILLENEMY		; $639f
	call z,playSound		; $63a1
	ld e,Interaction.animParameter		; $63a4
	ld a,(de)		; $63a6
	inc a			; $63a7
	jp nz,interactionAnimate		; $63a8
	jp interactionDelete		; $63ab


; ==============================================================================
; INTERACID_BOMB_UPGRADE_FAIRY
; ==============================================================================
interactionCode83:
	ld e,Interaction.subid		; $63ae
	ld a,(de)		; $63b0
	ld e,Interaction.state		; $63b1
	rst_jumpTable			; $63b3
	.dw _bombUpgradeFairy_subid00
	.dw _bombUpgradeFairy_subid01
	.dw _bombUpgradeFairy_subid02

_bombUpgradeFairy_subid00:
	ld a,(de)		; $63ba
	rst_jumpTable			; $63bb
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY		; $63c4
	call checkGlobalFlag		; $63c6
	jp nz,interactionDelete		; $63c9

	call getThisRoomFlags		; $63cc
	bit 0,a			; $63cf
	jp z,interactionDelete		; $63d1

	call interactionInitGraphics		; $63d4
	call interactionSetAlwaysUpdateBit		; $63d7
	call interactionIncState		; $63da

	ld l,Interaction.collisionRadiusY		; $63dd
	inc (hl)		; $63df
	inc l			; $63e0
	ld (hl),$12		; $63e1

	ld hl,wTextNumberSubstitution		; $63e3
	ld a,(wMaxBombs)		; $63e6
	cp $10			; $63e9
	ld a,$30		; $63eb
	jr z,+			; $63ed
	ld a,$50		; $63ef
+
	ldi (hl),a		; $63f1
	xor a			; $63f2
	ld (hl),a		; $63f3
	ld (wTmpcfc0.bombUpgradeCutscene.state),a		; $63f4
	ld ($cfd0),a		; $63f7
	ret			; $63fa

@state1:
	; Bombs are hardcoded to set this variable to $01 when it falls into water on this
	; screen. Hold execution until that happens.
	ld a,(wTmpcfc0.bombUpgradeCutscene.state)		; $63fb
	dec a			; $63fe
	ret nz			; $63ff

	ld a,(w1Link.zh)		; $6400
	or a			; $6403
	ret nz			; $6404

	; Check that Link's in position
	ldh a,(<hEnemyTargetY)	; $6405
	sub $41			; $6407
	cp $06			; $6409
	ret nc			; $640b
	ldh a,(<hEnemyTargetX)	; $640c
	sub $58			; $640e
	cp $21			; $6410
	ret nc			; $6412

	call checkLinkVulnerable		; $6413
	ret nc			; $6416

	ldbc INTERACID_PUFF, $02		; $6417
	call objectCreateInteraction		; $641a
	ret nz			; $641d
	ld e,Interaction.relatedObj2		; $641e
	ld a,Interaction.start		; $6420
	ld (de),a		; $6422
	inc e			; $6423
	ld a,h			; $6424
	ld (de),a		; $6425

	call clearAllParentItems		; $6426
	call dropLinkHeldItem		; $6429

	xor a			; $642c
	ld (w1Link.direction),a		; $642d
	ld (wTmpcfc0.bombUpgradeCutscene.state),a		; $6430

	ld a,$80		; $6433
	ld (wDisabledObjects),a		; $6435
	ld (wMenuDisabled),a		; $6438
	call setLinkForceStateToState08		; $643b
	jp interactionIncState		; $643e

@state2:
	; Wait for signal to spawn in silver and gold bombs?
	ld a,Object.animParameter		; $6441
	call objectGetRelatedObject2Var		; $6443
	bit 7,(hl)		; $6446
	ret z			; $6448

	call interactionIncState		; $6449
	ld l,Interaction.yh		; $644c
	ld (hl),$28		; $644e

	ldbc INTERACID_SPARKLE, $0e		; $6450
	call objectCreateInteraction		; $6453

	call objectSetVisible81		; $6456
	ld hl,bombUpgradeFairyScript		; $6459
	call interactionSetScript		; $645c

	ld b,$00		; $645f
	call @spawnSubid2Instance		; $6461

	ld b,$01		; $6464

@spawnSubid2Instance:
	call getFreeInteractionSlot		; $6466
	ret nz			; $6469
	ld (hl),INTERACID_BOMB_UPGRADE_FAIRY		; $646a
	inc l			; $646c
	ld (hl),$02		; $646d
	inc l			; $646f
	ld (hl),b		; $6470
	ret			; $6471

@state3:
	call interactionAnimate		; $6472
	ld a,(wTextIsActive)		; $6475
	or a			; $6478
	ret nz			; $6479
	ld a,(wPaletteThread_mode)		; $647a
	or a			; $647d
	ret nz			; $647e
	call interactionRunScript		; $647f
	ret nc			; $6482

	xor a			; $6483
	ld (wDisabledObjects),a		; $6484
	ld (wMenuDisabled),a		; $6487
	inc a			; $648a
	ld (wTmpcfc0.bombUpgradeCutscene.state),a		; $648b

	call objectCreatePuff		; $648e
	jp interactionDelete		; $6491


; Bombs that surround Link (depending on his answer)
_bombUpgradeFairy_subid01:
	ld a,(de)		; $6494
	rst_jumpTable			; $6495
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $649c
	call interactionIncState		; $649f

	ld l,Interaction.var03		; $64a2
	ld a,(hl)		; $64a4
	add a			; $64a5
	add (hl)		; $64a6

	ld hl,@bombPositions		; $64a7
	rst_addAToHl			; $64aa
	ld e,Interaction.yh		; $64ab
	ldh a,(<hEnemyTargetY)	; $64ad
	add (hl)		; $64af
	ld (de),a		; $64b0
	ld e,Interaction.xh		; $64b1
	inc hl			; $64b3
	ldh a,(<hEnemyTargetX)	; $64b4
	add (hl)		; $64b6
	ld (de),a		; $64b7

	ld e,Interaction.counter1		; $64b8
	inc hl			; $64ba
	ld a,(hl)		; $64bb
	ld (de),a		; $64bc
	ret			; $64bd

@bombPositions:
	.db $00 $f0 $01
	.db $10 $00 $0f
	.db $00 $10 $1e
	.db $f0 $00 $2d

@state1:
	call interactionDecCounter1		; $64ca
	ret nz			; $64cd
	ld l,e			; $64ce
	inc (hl)		; $64cf
	call objectCreatePuff		; $64d0
	jp objectSetVisible82		; $64d3

@state2:
	ld a,($cfd0)		; $64d6
	inc a			; $64d9
	jp z,interactionDelete		; $64da

	; Flash the bomb between blue and red palettes
	call interactionDecCounter1		; $64dd
	ld a,(hl)		; $64e0
	and $03			; $64e1
	ret nz			; $64e3

	ld l,Interaction.oamFlagsBackup		; $64e4
	ld a,(hl)		; $64e6
	xor $01			; $64e7
	ldi (hl),a		; $64e9
	ld (hl),a		; $64ea
	ret			; $64eb


; Gold/silver bombs
_bombUpgradeFairy_subid02:
	ld a,(de)		; $64ec
	rst_jumpTable			; $64ed
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $64f4
	ld a,PALH_80		; $64f7
	call loadPaletteHeader		; $64f9
	call interactionIncState		; $64fc

	ld e,Interaction.var03		; $64ff
	ld a,(de)		; $6501
	or a			; $6502
	ld b,$5a		; $6503
	jr z,++			; $6505
	ld l,Interaction.oamFlagsBackup		; $6507
	ld a,$06		; $6509
	ldi (hl),a		; $650b
	ld (hl),a		; $650c
	ld b,$76		; $650d
++
	ld l,Interaction.yh		; $650f
	ld (hl),$3c		; $6511
	ld l,Interaction.xh		; $6513
	ld (hl),b		; $6515

	ldbc INTERACID_PUFF, $02		; $6516
	call objectCreateInteraction		; $6519
	ret nz			; $651c
	ld e,Interaction.relatedObj2		; $651d
	ld a,Interaction.start		; $651f
	ld (de),a		; $6521
	inc e			; $6522
	ld a,h			; $6523
	ld (de),a		; $6524
	ret			; $6525

@state1:
	; Wait for the puff to finish, then make self visible
	ld a,Object.animParameter		; $6526
	call objectGetRelatedObject1Var		; $6528
	bit 7,(hl)		; $652b
	ret nz			; $652d
	call interactionIncState		; $652e
	jp objectSetVisible82		; $6531

@state2:
	ld a,($cfd0)		; $6534
	or a			; $6537
	ret z			; $6538
	call objectCreatePuff		; $6539
	jp interactionDelete		; $653c


; ==============================================================================
; INTERACID_SPARKLE
; ==============================================================================
interactionCode84:
	call checkInteractionState		; $653f
	jr nz,@state1	; $6542

	call interactionInitGraphics		; $6544
	call interactionSetAlwaysUpdateBit		; $6547
	ld l,Interaction.state		; $654a
	inc (hl)		; $654c
	ld e,Interaction.subid		; $654d
	ld a,(de)		; $654f
	rst_jumpTable			; $6550
	.dw @initSubid00
	.dw @initSubid01
	.dw @initSubid02
	.dw @initSubid03
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @initSubid07
	.dw @highDrawPriority
	.dw @initSubid09
	.dw @initSubid0a
	.dw @initSubid0b
	.dw @initSubid0c
	.dw @highDrawPriority
	.dw @highDrawPriority
	.dw @highDrawPriority

@initSubid0a:
	ld h,d			; $6571
	ld l,Interaction.speed		; $6572
	ld a,(hl)		; $6574
	or a			; $6575
	jr nz,@initSubid00	; $6576
	ld (hl),$78		; $6578

@initSubid00:
@initSubid01:
@initSubid09:
	inc e			; $657a
	ld a,(de)		; $657b
	or a			; $657c
	jp nz,objectSetVisible81		; $657d

@initSubid02:
@initSubid03:
@initSubid07:
@lowDrawPriority:
	jp objectSetVisible82		; $6580

@highDrawPriority:
	jp objectSetVisible80		; $6583

@initSubid0b:
	ld h,d			; $6586
	ld l,Interaction.speedY		; $6587
	ld (hl),<(-$40)		; $6589
	inc l			; $658b
	ld (hl),>(-$40)		; $658c
	jp objectSetVisible81		; $658e

@initSubid0c:
	ld a,Object.id		; $6591
	call objectGetRelatedObject1Var		; $6593
	ld e,Interaction.var38		; $6596
	ld a,(hl)		; $6598
	ld (de),a		; $6599
	jr @lowDrawPriority		; $659a


@state1:
	ld e,Interaction.subid		; $659c
	ld a,(de)		; $659e
	rst_jumpTable			; $659f
	.dw @runSubid00
	.dw @runSubid01
	.dw @runSubid02
	.dw @runSubid03
	.dw @runSubid04
	.dw @runSubid05
	.dw @runSubid06
	.dw @runSubid07
	.dw @runSubid08
	.dw @runSubid09
	.dw @runSubid0a
	.dw @runSubid0b
	.dw @runSubid0c
	.dw @runSubid0d
	.dw @runSubid0e
	.dw @runSubid0f

@runSubid02:
@runSubid03:
@runSubid0b:
	call objectApplyComponentSpeed		; $65c0

@runSubid00:
@runSubid01:
@runSubid09:
	ld e,Interaction.animParameter		; $65c3
	ld a,(de)		; $65c5
	cp $ff			; $65c6
	jp z,interactionDelete		; $65c8
	jp interactionAnimate		; $65cb


@runSubid04:
@animateAndFlickerAndDeleteWhenCounter1Zero:
	call interactionDecCounter1		; $65ce
	jp z,interactionDelete		; $65d1

@runSubid08:
@animateAndFlicker:
	call interactionAnimate		; $65d4
	ld a,(wFrameCounter)		; $65d7
@flicker:
	rrca			; $65da
	jp c,objectSetInvisible		; $65db
	jp objectSetVisible		; $65de


@runSubid05:
	ld a,Object.yh		; $65e1
	call objectGetRelatedObject1Var		; $65e3
	ld bc,$0800		; $65e6
	call objectTakePositionWithOffset		; $65e9
	jr @animateAndFlickerAndDeleteWhenCounter1Zero		; $65ec


@runSubid07:
@runSubid0f:
	ld a,Object.yh		; $65ee
	call objectGetRelatedObject1Var		; $65f0
	call objectTakePosition		; $65f3

@runSubid0e:
	ld a,(wTmpcfc0.bombUpgradeCutscene.state)		; $65f6
	bit 0,a			; $65f9
	jp nz,interactionDelete		; $65fb
	jr @animateAndFlicker		; $65fe


@runSubid06:
	ld a,(wTmpcbb9)		; $6600
	cp $07			; $6603
	jp z,interactionDelete		; $6605

@animateFlickerAndTakeRelatedObj1Position:
	call interactionAnimate		; $6608
	ld a,Object.yh		; $660b
	call objectGetRelatedObject1Var		; $660d
	call objectTakePosition		; $6610
	ld a,(wIntro.frameCounter)		; $6613
	jr @flicker		; $6616


@runSubid0a:
	call objectApplySpeed		; $6618
	call objectCheckWithinScreenBoundary		; $661b
	jp c,interactionAnimate		; $661e
	jp interactionDelete		; $6621


@runSubid0c:
	ld a,Object.id		; $6624
	call objectGetRelatedObject1Var		; $6626
	ld e,Interaction.var38		; $6629
	ld a,(de)		; $662b
	cp (hl)			; $662c
	jp nz,interactionDelete		; $662d

	call objectTakePosition		; $6630
	ld a,($cfc0)		; $6633
	bit 0,a			; $6636
	jp nz,interactionDelete		; $6638
	jr @animateAndFlicker		; $663b


@runSubid0d:
	ld a,(wTmpcbb9)		; $663d
	cp $06			; $6640
	jp z,interactionDelete		; $6642
	jr @animateFlickerAndTakeRelatedObj1Position		; $6645


; ==============================================================================
; INTERACID_MAKU_FLOWER
; ==============================================================================
interactionCode86:
	ld e,Interaction.subid		; $6647
	ld a,(de)		; $6649
	rst_jumpTable			; $664a
	.dw @subid0
	.dw @subid1

; Present maku tree flower
@subid0:
	call checkInteractionState		; $664f
	jr nz,@subid0State1	; $6652

@subid0State0:
	call interactionInitGraphics		; $6654
	call objectSetVisible82		; $6657
	call interactionSetAlwaysUpdateBit		; $665a
	call interactionIncState		; $665d

@subid0State1:
	; Watch var3b of relatedObject1 to set the flower's animation
	ld a,Object.var3b		; $6660
	call objectGetRelatedObject2Var		; $6662
	ld a,(hl)		; $6665
	ld bc,@anims		; $6666
	call addAToBc		; $6669
	ld a,(bc)		; $666c
	cp $01			; $666d
	jr z,@setAnimA	; $666f
	ld b,a			; $6671
	ld l,Interaction.subid		; $6672
	ld a,(hl)		; $6674
	cp $04			; $6675
	jr nz,@setAnimB	; $6677
	ld b,$03		; $6679
@setAnimB:
	ld a,b			; $667b
@setAnimA:
	jp interactionSetAnimation		; $667c

@anims:
	.db $00 $00 $00 $00 $01


@subid1:
	call checkInteractionState	; $6684
	jr nz,@subid1State1	; $6687

@subid1State0:
	call interactionInitGraphics		; $6689
	call objectSetVisible82		; $668c
	call interactionSetAlwaysUpdateBit		; $668f
	call interactionIncState		; $6692
	ld l,Interaction.zh		; $6695
	ld (hl),$d4		; $6697
@subid1State1:
	ld h,d			; $6699
	ld l,Interaction.zh		; $669a
	inc (hl)		; $669c
	jp z,interactionDelete		; $669d
	ret			; $66a0


; ==============================================================================
; INTERACID_MAKU_TREE
;
; Variables:
;   var3b: Animation
;   var3d: 0 for present maku tree, 1 for past?
;   var3e: "Script mode"; mainly determines animation (see makuTree_subid00Script_body)
;   var3f: Text index to show for (sometimes shows the one after it as well)
; ==============================================================================
interactionCode87:
	ld e,Interaction.subid		; $66a1
	ld a,(de)		; $66a3
	rst_jumpTable			; $66a4
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06

@subid00:
	call checkInteractionState		; $66b3
	jr nz,@runScriptAndAnimate	; $66b6

	xor a			; $66b8
	ld e,Interaction.var3d		; $66b9
	ld (de),a		; $66bb
	call @initSubid00		; $66bc
	call @initializeMakuTree		; $66bf
	jr @runScriptAndAnimate		; $66c2

@subid01:
@subid02:
	call checkInteractionState		; $66c4
	jr nz,@runScriptAndAnimate	; $66c7

	call @initializeMakuTree		; $66c9
	call interactionRunScript		; $66cc
	ld e,Interaction.subid		; $66cf
	ld a,(de)		; $66d1
	dec a			; $66d2
	jr nz,@runScriptAndAnimate	; $66d3

	; Subid 1 only: make Link move right/up to approach the maku tree, starting the
	; "maku tree disappearance" cutscene

	ld a,PALH_8f		; $66d5
	call loadPaletteHeader		; $66d7

	ld hl,@simulatedInput		; $66da
	ld a,:@simulatedInput		; $66dd
	push de			; $66df
	call setSimulatedInputAddress		; $66e0
	pop de			; $66e3

	xor a			; $66e4
	ld (w1Link.direction),a		; $66e5
	jr @runScriptAndAnimate		; $66e8

@simulatedInput:
	dwb 60 $00
	dwb 48 BTN_RIGHT
	dwb  4 $00
	dwb 14 BTN_UP
	dwb 60 $00
	.dw $ffff

@runScriptAndAnimate:
	call interactionRunScript		; $66fb
	jp interactionAnimate		; $66fe

@subid03:
	call checkInteractionState		; $6701
	jr nz,@runScriptAndAnimate	; $6704

	ld b,$01		; $6706
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $6708
	cp $03			; $670b
	jr z,+			; $670d
	call interactionLoadExtraGraphics		; $670f
	ld b,$00		; $6712
+
	ld a,b			; $6714
	call interactionSetAnimation		; $6715
	call interactionInitGraphics		; $6718
	call @loadScript		; $671b
	jp @setVisibleAndSpawnFlower		; $671e

@subid04:
@subid05:
	call checkInteractionState		; $6721
	jr nz,@runScriptAndAnimate	; $6724
	call @initializeMakuTree		; $6726
	jr @runScriptAndAnimate		; $6729

@subid06:
	call checkInteractionState		; $672b
	jr nz,@runScriptAndAnimate	; $672e

	ld a,GLOBALFLAG_SAW_TWINROVA_BEFORE_ENDGAME		; $6730
	call checkGlobalFlag		; $6732
	jp nz,@initializeMakuTree		; $6735
	ld hl,w1Link.direction		; $6738
	ld (hl),$00		; $673b
	call setLinkForceStateToState08		; $673d
	call @initGraphicsAndIncState		; $6740
	call @setVisibleAndSpawnFlower		; $6743

	ld b,$00		; $6746
	ld hl,makuTree_subid06Script_part1		; $6748
	ld a,GLOBALFLAG_GOT_MAKU_SEED		; $674b
	push hl			; $674d
	call checkGlobalFlag		; $674e
	pop hl			; $6751
	jr z,+			; $6752
	ld b,$04		; $6754
	ld hl,makuTree_subid06Script_part2		; $6756
+
	call interactionSetScript		; $6759
	ld a,>TX_0500		; $675c
	call interactionSetHighTextIndex		; $675e
	ld a,b			; $6761
	call interactionSetAnimation		; $6762
	jp @runScriptAndAnimate		; $6765

@initSubid00:
	ld a,(wMakuTreeState)		; $6768
	rst_jumpTable			; $676b
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
	ld a,GLOBALFLAG_0c		; $678e
	call checkGlobalFlag		; $6790
	jr nz,@ret	; $6793
	ld a,$01		; $6795
	jr @runSubidCode		; $6797

@state02:
	ld a,$02		; $6799
	jr @runSubidCode		; $679b

@state03:
	ldbc $02, <TX_0500		; $679d
	jr @runSubid0ScriptMode		; $67a0

@state04:
	ldbc $00, <TX_0503		; $67a2
	jr @runSubid0ScriptMode		; $67a5

@state05:
	ldbc $00, <TX_0505		; $67a7
	jr @runSubid0ScriptMode		; $67aa

@state06:
	ldbc $00, <TX_0507		; $67ac
	jr @runSubid0ScriptMode		; $67af

@state07:
	ldbc $04, <TX_0509		; $67b1
	jr @runSubid0ScriptMode		; $67b4

@state08:
	ldbc $04, <TX_050b		; $67b6
	jr @runSubid0ScriptMode		; $67b9

@state09:
	ldbc $02, <TX_050d		; $67bb
	jr @runSubid0ScriptMode		; $67be

@state0a:
	ldbc $00, <TX_0510		; $67c0
	jr @runSubid0ScriptMode		; $67c3

@state0b:
	ldbc $05, <TX_0512		; $67c5
	jr @runSubid0ScriptMode		; $67c8

@state0c:
	ldbc $04, <TX_0514		; $67ca
	jr @runSubid0ScriptMode		; $67cd

@state0d:
	ldbc $00, <TX_0516		; $67cf
	jr @runSubid0ScriptMode		; $67d2

@state0e:
	ld a,$06		; $67d4
	jr @runSubidCode		; $67d6

@state0f:
	ldbc $00, <TX_0518		; $67d8
	jr @runSubid0ScriptMode		; $67db

@state10:
	call checkIsLinkedGame		; $67dd
	jr z,++			; $67e0
	ldbc $00, <TX_051a		; $67e2
	jr @runSubid0ScriptMode		; $67e5
++
	ldbc $01, <TX_051c		; $67e7
	jr @runSubid0ScriptMode		; $67ea

@state01:
	pop af			; $67ec
	jp interactionDelete		; $67ed

@runSubidCode:
	ld e,Interaction.subid		; $67f0
	ld (de),a		; $67f2
	pop af			; $67f3
	jp interactionCode87		; $67f4

@runSubid0ScriptMode:
	ld h,d			; $67f7
	ld l,Interaction.var3e		; $67f8
	ld (hl),b		; $67fa
	inc l			; $67fb
	ld (hl),c		; $67fc
@ret:
	ret			; $67fd


@initializeMakuTree:
	call @initGraphicsAndLoadScript		; $67fe

@setVisibleAndSpawnFlower:
	call objectSetVisible83		; $6801
	call interactionSetAlwaysUpdateBit		; $6804
	jp @spawnMakuFlower		; $6807

@initGraphicsAndIncState:
	call @initGraphics		; $680a
	jp interactionIncState		; $680d

@initGraphicsAndLoadScript:
	call @initGraphics		; $6810
	jr @loadScript		; $6813

@initGraphics:
	call interactionLoadExtraGraphics		; $6815
	jp interactionInitGraphics		; $6818

@loadScript:
	ld a,>TX_0500		; $681b
	call interactionSetHighTextIndex		; $681d
	ld e,Interaction.subid		; $6820
	ld a,(de)		; $6822
	ld hl,@scriptTable		; $6823
	rst_addDoubleIndex			; $6826
	ldi a,(hl)		; $6827
	ld h,(hl)		; $6828
	ld l,a			; $6829
	call interactionSetScript		; $682a
	jp interactionIncState		; $682d

@spawnMakuFlower:
	call getFreeInteractionSlot		; $6830
	ret nz			; $6833
	ld (hl),INTERACID_MAKU_FLOWER		; $6834
	ld l,Interaction.relatedObj2		; $6836
	ld a,Interaction.start		; $6838
	ldi (hl),a		; $683a
	ld (hl),d		; $683b
	ld e,Interaction.relatedObj1		; $683c
	ld a,Interaction.start		; $683e
	ld (de),a		; $6840
	inc e			; $6841
	ld a,h			; $6842
	ld (de),a		; $6843
	jp objectCopyPosition		; $6844

@scriptTable:
	.dw makuTree_subid00Script
	.dw makuTree_subid01Script
	.dw makuTree_subid02Script
	.dw makuTree_subid03Script
	.dw makuTree_subid04Script
	.dw makuTree_subid05Script
	.dw makuTree_subid06Script_part3


; ==============================================================================
; INTERACID_MAKU_SPROUT
;
; Variables:
;   var3b: Animation
;   var3d: 0 for present maku tree, 1 for past?
;   var3e: "Script mode"; mainly determines animation (see makuSprout_subid00Script_body)
;   var3f: Text index to show for (sometimes shows the one after it as well)
; ==============================================================================
interactionCode88:
	ld e,Interaction.subid		; $6855
	ld a,(de)		; $6857
	rst_jumpTable			; $6858
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
	call checkInteractionState		; $685f
	jr nz,@subid0State1	; $6862

	ld a,$01		; $6864
	ld e,Interaction.var3d		; $6866
	ld (de),a		; $6868

	call @initSubid0		; $6869
	call @initializeMakuSprout		; $686c

@subid0State1:
	call interactionAnimateAsNpc		; $686f
	ld e,Interaction.visible		; $6872
	ld a,(de)		; $6874
	and $8f			; $6875
	ld (de),a		; $6877
	jp interactionRunScript		; $6878

@subid1:
	call checkInteractionState		; $687b
	jr nz,@subid1State1	; $687e
	call @initializeMakuSprout		; $6880
	call interactionRunScript		; $6883

@subid1State1:
	jr @subid0State1		; $6886

@subid2:
	call checkInteractionState		; $6888
	jr nz,@subid2State1	; $688b

	call @initializeMakuSprout		; $688d
	ld a,$01		; $6890
	jp interactionSetAnimation		; $6892

@subid2State1:
	call checkInteractionState2		; $6895
	jp nz,interactionAnimate		; $6898

	ld a,(wTmpcfc0.genericCutscene.state)		; $689b
	cp $06			; $689e
	ret nz			; $68a0

	call interactionIncState2		; $68a1
	jp objectSetVisible82		; $68a4


@initSubid0:
	ld a,(wMakuTreeState)		; $68a7
	rst_jumpTable			; $68aa
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
	ld a,$01		; $68cd
	jr @runSubidCode	; $68cf

@state03:
@state04:
@state05:
	ldbc $01, <TX_0570		; $68d1
	jr @runSubid0ScriptMode		; $68d4

@state06:
	ldbc $00, <TX_0576		; $68d6
	jr @runSubid0ScriptMode		; $68d9

@state07:
	ldbc $00, <TX_0578		; $68db
	jr @runSubid0ScriptMode		; $68de

@state08:
	ldbc $02, <TX_057a		; $68e0
	jr @runSubid0ScriptMode		; $68e3

@state09:
	ldbc $01, <TX_057c		; $68e5
	jr @runSubid0ScriptMode		; $68e8

@state0a:
	ldbc $01, <TX_057e		; $68ea
	jr @runSubid0ScriptMode		; $68ed

@state0b:
	ldbc $00, <TX_0580		; $68ef
	jr @runSubid0ScriptMode		; $68f2

@state0c:
	ldbc $00, <TX_0582		; $68f4
	jr @runSubid0ScriptMode		; $68f7

@state0d:
	ldbc $01, <TX_0584		; $68f9
	jr @runSubid0ScriptMode		; $68fc

@state0e:
	ldbc $01, <TX_0586		; $68fe
	jr @runSubid0ScriptMode		; $6901

@state0f:
	ldbc $02, <TX_0588		; $6903
	jr @runSubid0ScriptMode		; $6906

@state10:
	call checkIsLinkedGame		; $6908
	jr z,++			; $690b

	ldbc $00, <TX_058a		; $690d
	jr @runSubid0ScriptMode		; $6910
++
	ldbc $01, <TX_058c		; $6912
	jr @runSubid0ScriptMode		; $6915

@runSubidCode:
	ld e,Interaction.subid		; $6917
	ld (de),a		; $6919
	pop af			; $691a
	jp interactionCode88		; $691b

@runSubid0ScriptMode:
	ld h,d			; $691e
	ld l,Interaction.var3e		; $691f
	ld (hl),b		; $6921
	inc l			; $6922
	ld (hl),c		; $6923

@state00:
	ret			; $6924


@initializeMakuSprout:
	call @loadScriptAndInitGraphics		; $6925
	jp interactionSetAlwaysUpdateBit		; $6928


@initGraphics: ; unused
	call interactionInitGraphics		; $692b
	jp interactionIncState		; $692e


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6931
	ld a,>TX_0500		; $6934
	call interactionSetHighTextIndex		; $6936
	ld e,Interaction.subid		; $6939
	ld a,(de)		; $693b
	ld hl,@scriptTable		; $693c
	rst_addDoubleIndex			; $693f
	ldi a,(hl)		; $6940
	ld h,(hl)		; $6941
	ld l,a			; $6942
	call interactionSetScript		; $6943
	jp interactionIncState		; $6946

@scriptTable:
	.dw makuSprout_subid00Script
	.dw makuSprout_subid01Script
	.dw stubScript


; ==============================================================================
; INTERACID_REMOTE_MAKU_CUTSCENE
;
; Variables:
;   var3e: Doesn't do anything
;   var3f: Text to show
; ==============================================================================
interactionCode8a:
	ld e,Interaction.subid		; $694f
	ld a,(de)		; $6951
	rst_jumpTable			; $6952
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	call checkInteractionState		; $6957
	jr nz,@state1	; $695a

@state0:
	call returnIfScrollMode01Unset		; $695c
	ld e,Interaction.subid		; $695f
	ld a,(de)		; $6961
	ld e,Interaction.var3d		; $6962
	ld (de),a		; $6964
	call @checkConditionsAndSetText		; $6965
	call getThisRoomFlags		; $6968
	and $40			; $696b
	jp nz,interactionDelete		; $696d

	call @loadScript		; $6970

@state1:
	call interactionRunScript		; $6973
	jp c,interactionDelete		; $6976
	ret			; $6979

@checkConditionsAndSetText:
	ld e,Interaction.var03		; $697a
	ld a,(de)		; $697c
	rst_jumpTable			; $697d
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @val06
	.dw @val07
	.dw @val08
	.dw @val09
	.dw @val0a
	.dw @val0b

@val00:
	xor a			; $6996
	call @checkEssenceObtained		; $6997
	jp z,@deleteSelfAndReturn		; $699a
	ldbc $00, <TX_05b0		; $699d
	jp @setTextForScript		; $69a0

@val01:
	ldbc $00, <TX_05b1		; $69a3
	jp @setTextForScript		; $69a6

@val02:
	ld a,TREASURE_HARP		; $69a9
	call checkTreasureObtained		; $69ab
	jp nc,@deleteSelfAndReturn		; $69ae
	ldbc $00, <TX_05b2		; $69b1
	jp @setTextForScript		; $69b4

@val03:
	ld a,$01		; $69b7
	call @checkEssenceObtained		; $69b9
	jp z,@deleteSelfAndReturn		; $69bc
	ldbc $00, <TX_05b3		; $69bf
	jp @setTextForScript		; $69c2

@val04:
	ld a,$02		; $69c5
	call @checkEssenceObtained		; $69c7
	jp z,@deleteSelfAndReturn		; $69ca

	ld hl,wPastRoomFlags+$76		; $69cd
	set 0,(hl)		; $69d0
	call checkIsLinkedGame		; $69d2
	ld a,GLOBALFLAG_CAN_BUY_FLUTE		; $69d5
	call z,setGlobalFlag		; $69d7
	ldbc $00, <TX_05b4		; $69da
	jp @setTextForScript		; $69dd

@val05:
	ld a,$03		; $69e0
	call @checkEssenceObtained		; $69e2
	jp z,@deleteSelfAndReturn		; $69e5
	ldbc $00, <TX_05b5		; $69e8
	jp @setTextForScript		; $69eb

@val06:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $69ee
	call checkGlobalFlag		; $69f0
	jp z,@deleteSelfAndReturn		; $69f3
	ldbc $00, <TX_05b6		; $69f6
	jp @setTextForScript		; $69f9

@val07:
	ld a,$04		; $69fc
	call @checkEssenceObtained		; $69fe
	jp z,@deleteSelfAndReturn		; $6a01
	ldbc $00, <TX_05b7		; $6a04
	jp @setTextForScript		; $6a07

@val08:
	ld a,$05		; $6a0a
	call @checkEssenceObtained		; $6a0c
	jp z,@deleteSelfAndReturn		; $6a0f
	ldbc $00, <TX_05b8		; $6a12
	jp @setTextForScript		; $6a15

@val09:
	ld a,$06		; $6a18
	call @checkEssenceObtained		; $6a1a
	jp z,@deleteSelfAndReturn		; $6a1d
	ldbc $00, <TX_05b9		; $6a20
	jp @setTextForScript		; $6a23

@val0a:
	ld a,$07		; $6a26
	call @checkEssenceObtained		; $6a28
	jp z,@deleteSelfAndReturn		; $6a2b
	ldbc $00, <TX_05ba		; $6a2e
	jp @setTextForScript		; $6a31

@val0b:
	ldbc $00, <TX_05bb		; $6a34
	jp @setTextForScript		; $6a37


@deleteSelfAndReturn:
	pop af			; $6a3a
	jp interactionDelete		; $6a3b

@setTextForScript:
	ld h,d			; $6a3e
	ld l,Interaction.var3e		; $6a3f
	ld (hl),b		; $6a41
	inc l			; $6a42
	ld (hl),c		; $6a43
	ret			; $6a44

;;
; @param	a	Essence number
; @addr{6a45}
@checkEssenceObtained:
	ld hl,wEssencesObtained		; $6a45
	jp checkFlag		; $6a48


@initGraphicsAndIncState: ; Unused
	call interactionInitGraphics		; $6a4b
	jp interactionIncState		; $6a4e

@initGraphicsAndLoadScript: ; Unused
	call interactionInitGraphics		; $6a51

@loadScript:
	ld a,>TX_0500		; $6a54
	call interactionSetHighTextIndex		; $6a56
	ld e,Interaction.subid		; $6a59
	ld a,(de)		; $6a5b
	ld hl,@scriptTable		; $6a5c
	rst_addDoubleIndex			; $6a5f
	ldi a,(hl)		; $6a60
	ld h,(hl)		; $6a61
	ld l,a			; $6a62
	call interactionSetScript		; $6a63
	jp interactionIncState		; $6a66

@scriptTable:
	.dw remoteMakuCutsceneScript
	.dw remoteMakuCutsceneScript


; ==============================================================================
; INTERACID_GORON_ELDER
;
; Variables:
;   var3f: If zero, elder should face Link when he's close?
; ==============================================================================
interactionCode8b:
	ld e,Interaction.subid		; $6a6d
	ld a,(de)		; $6a6f
	rst_jumpTable			; $6a70
	.dw @subid0
	.dw @subid1
	.dw @subid2

@subid0:
@subid1:
	call checkInteractionState		; $6a77
	jr nz,++			; $6a7a
	call @loadScriptAndInitGraphics		; $6a7c
++
	call interactionRunScript		; $6a7f
	jp c,interactionDelete		; $6a82
	ld e,Interaction.var3f		; $6a85
	ld a,(de)		; $6a87
	or a			; $6a88
	jp z,npcFaceLinkAndAnimate		; $6a89
	jp interactionAnimateAsNpc		; $6a8c

@subid2:
	ld a,GLOBALFLAG_FINISHEDGAME		; $6a8f
	call checkGlobalFlag		; $6a91
	jp z,interactionDelete		; $6a94
	jpab interactionBank08.shootingGalleryNpc		; $6a97


@initGraphics: ; unused
	call interactionInitGraphics		; $6a9f
	jp interactionIncState		; $6aa2


@loadScriptAndInitGraphics:
	call interactionInitGraphics		; $6aa5
	ld e,Interaction.subid		; $6aa8
	ld a,(de)		; $6aaa
	ld hl,@scriptTable		; $6aab
	rst_addDoubleIndex			; $6aae
	ldi a,(hl)		; $6aaf
	ld h,(hl)		; $6ab0
	ld l,a			; $6ab1
	call interactionSetScript		; $6ab2
	jp interactionIncState		; $6ab5

@scriptTable:
	.dw goronElderScript_subid00
	.dw goronElderScript_subid01


; ==============================================================================
; INTERACID_TOKAY_MEAT
; ==============================================================================
interactionCode8c:
	ld e,Interaction.state		; $6abc
	ld a,(de)		; $6abe
	rst_jumpTable			; $6abf
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call interactionInitGraphics		; $6ac8
	call interactionIncState		; $6acb
	ld l,Interaction.counter1		; $6ace
	ld (hl),30		; $6ad0
	ld a,$08		; $6ad2
	call objectSetCollideRadius		; $6ad4

	ld bc,$3850		; $6ad7
	call interactionSetPosition		; $6ada
	ld l,Interaction.zh		; $6add
	ld (hl),-$40		; $6adf
	ld bc,$0000		; $6ae1
	jp objectSetSpeedZ		; $6ae4


@state1:
	call objectAddToGrabbableObjectBuffer		; $6ae7
	ld e,Interaction.state2		; $6aea
	ld a,(de)		; $6aec
	rst_jumpTable			; $6aed
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0: ; Starts falling
	ld h,d			; $6af4
	ld l,Interaction.counter1		; $6af5
	ld a,(hl)		; $6af7
	or a			; $6af8
	jp nz,interactionDecCounter1		; $6af9
	call interactionIncState2		; $6afc
	call objectSetVisiblec1		; $6aff
	ld a,SND_FALLINHOLE		; $6b02
	jp playSound		; $6b04

@@substate1: ; Wait for it to land
	ld c,$28		; $6b07
	call objectUpdateSpeedZ_paramC		; $6b09
	ret nz			; $6b0c
	call interactionIncState2		; $6b0d
	ld a,SND_BOMB_LAND		; $6b10
	jp playSound		; $6b12

@@substate2: ; Sitting on the ground
	jp objectSetPriorityRelativeToLink_withTerrainEffects		; $6b15


; State 2 = grabbed by power bracelet state
@state2:
	inc e			; $6b18
	ld a,(de)		; $6b19
	rst_jumpTable			; $6b1a
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released

@justGrabbed:
	ld a,d			; $6b21
	ld (wTmpcfc0.wildTokay.activeMeatObject),a		; $6b22
	ld a,e			; $6b25
	ld (wTmpcfc0.wildTokay.activeMeatObject+1),a		; $6b26

	call getFreeInteractionSlot		; $6b29
	ret nz			; $6b2c
	ld (hl),INTERACID_TOKAY_MEAT		; $6b2d
	jp interactionIncState2		; $6b2f

@beingHeld:
	ret			; $6b32

@released:
	ld e,Interaction.zh		; $6b33
	ld a,(de)		; $6b35
	rlca			; $6b36
	ret c			; $6b37

	call dropLinkHeldItem		; $6b38
	call interactionIncState		; $6b3b
	ld l,Interaction.counter1		; $6b3e
	ld (hl),20		; $6b40
	jp objectSetVisible83		; $6b42


@state3: ; Disappearing after being dropped on the ground
	call interactionDecCounter1		; $6b45
	jr nz,+			; $6b48
	jp interactionDelete		; $6b4a
+
	ld a,(wFrameCounter)		; $6b4d
	and $01			; $6b50
	jp z,objectSetInvisible		; $6b52
	jp objectSetPriorityRelativeToLink		; $6b55


; ==============================================================================
; INTERACID_CLOAKED_TWINROVA
; ==============================================================================
interactionCode8d:
	ld e,Interaction.state		; $6b58
	ld a,(de)		; $6b5a
	rst_jumpTable			; $6b5b
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $6b60
	ld (de),a		; $6b62
	call interactionInitGraphics		; $6b63
	call objectSetVisiblec2		; $6b66
	ld a,>TX_2800		; $6b69
	call interactionSetHighTextIndex		; $6b6b

	ld e,Interaction.subid		; $6b6e
	ld a,(de)		; $6b70
	rst_jumpTable			; $6b71
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2

@initSubid0:
	ld a,$03		; $6b78
	call interactionSetAnimation		; $6b7a
	ld bc,$4088		; $6b7d
	call interactionSetPosition		; $6b80

@initSubid2:
	call @loadScript		; $6b83
	jp objectSetInvisible		; $6b86

@initSubid1:
	ld bc,$4050		; $6b89
	call interactionSetPosition		; $6b8c
	ld l,Interaction.counter1		; $6b8f
	ld (hl),30		; $6b91
	jp objectSetInvisible		; $6b93


@state1:
	ld e,Interaction.subid		; $6b96
	ld a,(de)		; $6b98
	rst_jumpTable			; $6b99
	.dw @runSubid0
	.dw @runSubid1
	.dw @runSubid0

@runSubid0:
@runSubid2:
	call interactionRunScript		; $6ba0
	jp nc,interactionAnimate		; $6ba3

	call objectCreatePuff		; $6ba6

	; Subid 2 only: when done the script, create the "real" twinrova objects
	ld e,Interaction.subid		; $6ba9
	ld a,(de)		; $6bab
	or a			; $6bac
	jr z,++			; $6bad
	ldbc INTERACID_TWINROVA, $02		; $6baf
	call objectCreateInteraction		; $6bb2
++
	jp interactionDelete		; $6bb5


; Cutscene after d7; black tower is complete
@runSubid1:
	call interactionAnimate		; $6bb8
	ld e,Interaction.state2		; $6bbb
	ld a,(de)		; $6bbd
	rst_jumpTable			; $6bbe
	.dw @subid1Substate0
	.dw @subid1Substate1
	.dw @subid1Substate2
	.dw @subid1Substate3

@subid1Substate0:
	call interactionDecCounter1		; $6bc7
	ret nz			; $6bca
	ld (hl),20		; $6bcb
	ld a,MUS_DISASTER		; $6bcd
	call playSound		; $6bcf
	call objectSetVisible		; $6bd2
	call fadeinFromBlack		; $6bd5
	ld a,$06		; $6bd8
	ld (wDirtyFadeSprPalettes),a		; $6bda
	ld (wFadeSprPaletteSources),a		; $6bdd
	ld a,$03		; $6be0
	ld (wDirtyFadeBgPalettes),a		; $6be2
	ld (wFadeBgPaletteSources),a		; $6be5
	jp interactionIncState2		; $6be8

@subid1Substate1:
	call interactionDecCounter1IfPaletteNotFading		; $6beb
	ret nz			; $6bee
	ld (hl),20		; $6bef
	call interactionIncState2		; $6bf1
	ld bc,TX_2808		; $6bf4
	jp showText		; $6bf7

@subid1Substate2:
	call interactionDecCounter1IfTextNotActive		; $6bfa
	ret nz			; $6bfd
	ld a,SND_LIGHTNING		; $6bfe
	call playSound		; $6c00
	ld hl,wGenericCutscene.cbb3		; $6c03
	ld (hl),$00		; $6c06
	ld hl,wGenericCutscene.cbba		; $6c08
	ld (hl),$ff		; $6c0b
	jp interactionIncState2		; $6c0d

@subid1Substate3:
	ld hl,wGenericCutscene.cbb3		; $6c10
	ld b,$02		; $6c13
	call flashScreen		; $6c15
	ret z			; $6c18
	ld a,$02		; $6c19
	ld (wGenericCutscene.cbb8),a		; $6c1b
	ld a,CUTSCENE_BLACK_TOWER_EXPLANATION		; $6c1e
	ld (wCutsceneTrigger),a		; $6c20
	jp interactionDelete		; $6c23


@loadScript:
	ld e,Interaction.subid		; $6c26
	ld a,(de)		; $6c28
	ld hl,@scriptTable		; $6c29
	rst_addDoubleIndex			; $6c2c
	ldi a,(hl)		; $6c2d
	ld h,(hl)		; $6c2e
	ld l,a			; $6c2f
	jp interactionSetScript		; $6c30

@scriptTable:
	.dw cloakedTwinrova_subid00Script
	.dw stubScript
	.dw cloakedTwinrova_subid02Script


; ==============================================================================
; INTERACID_OCTOGON_SPLASH
; ==============================================================================
interactionCode8e:
	ld e,Interaction.state		; $6c39
	ld a,(de)		; $6c3b
	or a			; $6c3c
	jr z,@state0	; $6c3d

@state1:
	ld e,Interaction.animParameter		; $6c3f
	ld a,(de)		; $6c41
	inc a			; $6c42
	jp nz,interactionAnimate		; $6c43
	jp interactionDelete		; $6c46

@state0:
	call interactionInitGraphics		; $6c49
	call interactionIncState		; $6c4c
	ld l,Interaction.direction		; $6c4f
	ld a,(hl)		; $6c51
	rrca			; $6c52
	rrca			; $6c53
	call interactionSetAnimation		; $6c54
	jp objectSetVisible81		; $6c57


; ==============================================================================
; INTERACID_TOKAY_CUTSCENE_EMBER_SEED
; ==============================================================================
interactionCode8f:
	ld e,Interaction.state		; $6c5a
	ld a,(de)		; $6c5c
	rst_jumpTable			; $6c5d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01		; $6c66
	ld (de),a		; $6c68
	ld bc,-$100		; $6c69
	call objectSetSpeedZ		; $6c6c
	call interactionInitGraphics		; $6c6f
	call interactionSetAlwaysUpdateBit		; $6c72
	jp objectSetVisible80		; $6c75

@state1:
	ld c,$10		; $6c78
	call objectUpdateSpeedZ_paramC		; $6c7a
	ret nz			; $6c7d

	call objectSetInvisible		; $6c7e
	ld a,(wTextIsActive)		; $6c81
	or a			; $6c84
	ret z			; $6c85

	ld l,Interaction.state		; $6c86
	inc (hl)		; $6c88
	ret			; $6c89

@state2:
	call retIfTextIsActive		; $6c8a
	call interactionIncState		; $6c8d

	ld l,Interaction.oamFlagsBackup		; $6c90
	ld a,$0a		; $6c92
	ldi (hl),a		; $6c94
	ldi (hl),a		; $6c95
	ld (hl),$06 ; [oamTileIndexBase] = $06

	ld l,Interaction.counter1		; $6c98
	ld (hl),58		; $6c9a
	ld a,$0b		; $6c9c
	call interactionSetAnimation		; $6c9e
	jp objectSetVisible		; $6ca1

@state3:
	call interactionAnimate		; $6ca4
	call interactionDecCounter1		; $6ca7
	ret nz			; $6caa
	jp interactionDelete		; $6cab


; ==============================================================================
; INTERACID_MISC_PUZZLES
; ==============================================================================
interactionCode90:
	ld e,Interaction.subid		; $6cae
	ld a,(de)		; $6cb0
	rst_jumpTable			; $6cb1
	.dw _miscPuzzles_subid00
	.dw _miscPuzzles_subid01
	.dw _miscPuzzles_subid02
	.dw _miscPuzzles_subid03
	.dw _miscPuzzles_subid04
	.dw _miscPuzzles_subid05
	.dw _miscPuzzles_subid06
	.dw _miscPuzzles_subid07
	.dw _miscPuzzles_subid08
	.dw _miscPuzzles_subid09
	.dw _miscPuzzles_subid0a
	.dw _miscPuzzles_subid0b
	.dw _miscPuzzles_subid0c
	.dw _miscPuzzles_subid0d
	.dw _miscPuzzles_subid0e
	.dw _miscPuzzles_subid0f
	.dw _miscPuzzles_subid10
	.dw _miscPuzzles_subid11
	.dw _miscPuzzles_subid12
	.dw _miscPuzzles_subid13
	.dw _miscPuzzles_subid14
	.dw _miscPuzzles_subid15
	.dw _miscPuzzles_subid16
	.dw _miscPuzzles_subid17
	.dw _miscPuzzles_subid18
	.dw _miscPuzzles_subid19
	.dw _miscPuzzles_subid1a
	.dw _miscPuzzles_subid1b
	.dw _miscPuzzles_subid1c
	.dw _miscPuzzles_subid1d
	.dw _miscPuzzles_subid1e
	.dw _miscPuzzles_subid1f
	.dw _miscPuzzles_subid20
	.dw _miscPuzzles_subid21


; Boss key puzzle in D6
_miscPuzzles_subid00:
	ld e,Interaction.state		; $6cf6
	ld a,(de)		; $6cf8
	rst_jumpTable			; $6cf9
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

; State 0: initialization
@state0:
	call interactionIncState		; $6d02

; State 1: waiting for a lever to be pulled
@state1:
	; Return if a lever has not been pulled?
	ld hl,wLever1PullDistance		; $6d05
	bit 7,(hl)		; $6d08
	jr nz,+			; $6d0a
	inc l			; $6d0c
	bit 7,(hl)		; $6d0d
	ret z			; $6d0f
+
	; Check if the chest has already been opened
	call getThisRoomFlags		; $6d10
	and ROOMFLAG_ITEM			; $6d13
	jr nz,@alreadyOpened	; $6d15

	; Go to state 2 (or possibly 3, if this gets called again)
	call interactionIncState		; $6d17

	; Check whether this is the first time pulling the lever
	ld l,Interaction.counter2		; $6d1a
	ld a,(hl)		; $6d1c
	or a			; $6d1d
	jr nz,@checkRng		; $6d1e

	; This was the first time pulling the lever; always unsuccessful
	ld (hl),$01		; $6d20
	jr @error		; $6d22

@checkRng:
	; Get a number between 0 and 3.
	call getRandomNumber		; $6d24
	and $03			; $6d27

	; If the number is 0, the chest will appear; go to state 3.
	jp z,interactionIncState		; $6d29

	; If the number is 1-3, make the snakes appear.
@error:
	ld a,SND_ERROR		; $6d2c
	call playSound		; $6d2e

	ld a,(wActiveTilePos)		; $6d31
	ld (wWarpDestPos),a		; $6d34

	ld hl,wTmpcec0		; $6d37
	ld b,$20		; $6d3a
	call clearMemory		; $6d3c

	callab roomInitialization.generateRandomBuffer		; $6d3f

	; Spawn the snakes?
	ld hl,objectData.objectData78db		; $6d47
	jp parseGivenObjectData		; $6d4a

; State 2: lever has been pulled unsuccessfully. Wait for snakes to be killed before
; returning to state 1.
@state2:
	ld a,(wNumEnemies)		; $6d4d
	or a			; $6d50
	ret nz			; $6d51

	; Go back to state 1
	ld a,$01		; $6d52
	ld e,Interaction.state		; $6d54
	ld (de),a		; $6d56
	ret			; $6d57

; State 3: lever has been pulled successfully. Make the chest and delete self.
@state3:
	ld a,$01		; $6d58
	ld (wActiveTriggers),a		; $6d5a
	jpab interactionBank08.spawnChestAndDeleteSelf		; $6d5d

@alreadyOpened:
	ld a,$01		; $6d65
	ld (wActiveTriggers),a		; $6d67
	jp interactionDelete		; $6d6a



; Underwater switch hook puzzle in past d6
_miscPuzzles_subid01:
	call interactionDeleteAndRetIfEnabled02		; $6d6d
	call _miscPuzzles_deleteSelfAndRetIfItemFlagSet		; $6d70

	ld hl,@diamondPositions		; $6d73
	call _miscPuzzles_verifyTilesAtPositions		; $6d76
	ret nz			; $6d79
	jpab interactionBank08.spawnChestAndDeleteSelf		; $6d7a

@diamondPositions:
	.db TILEINDEX_SWITCH_DIAMOND
	.db $16 $17 $18
	.db $26 $27 $28
	.db $00



; Spot to put a rolling colored block on in present d6
_miscPuzzles_subid02:
	call interactionDeleteAndRetIfEnabled02		; $6d8a

	; Check that the tile at this position matches the cube color
	call objectGetTileAtPosition		; $6d8d
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $6d90
	ld b,a			; $6d92
	ld a,(wRotatingCubePos)		; $6d93
	cp l			; $6d96
	ret nz			; $6d97
	ld a,(wRotatingCubeColor)		; $6d98
	and $03			; $6d9b
	cp b			; $6d9d
	ret nz			; $6d9e

	; They match.
	ld c,l			; $6d9f
	ld a,TILEINDEX_STANDARD_FLOOR		; $6da0
	call setTile		; $6da2
	ld b,>wRoomCollisions		; $6da5
	ld a,$0f		; $6da7
	ld (bc),a		; $6da9
	ld a,SND_SOLVEPUZZLE		; $6daa
	call playSound		; $6dac
	jp interactionDelete		; $6daf



; Chest from solving colored cube puzzle in d6 (related to subid $02)
_miscPuzzles_subid03:
	call interactionDeleteAndRetIfEnabled02		; $6db2
	call _miscPuzzles_deleteSelfAndRetIfItemFlagSet		; $6db5

	ld hl,@wantedFloorTiles		; $6db8
	call _miscPuzzles_verifyTilesAtPositions		; $6dbb
	ret nz			; $6dbe
	jpab interactionBank08.spawnChestAndDeleteSelf		; $6dbf

@wantedFloorTiles:
	.db TILEINDEX_STANDARD_FLOOR
	.db $37 $65 $69
	.db $00

;;
; @param	hl	Pointer to data. First byte is a tile index; then an arbitrary
;			number of positions in the room where that tile should be; $ff to
;			give a new tile index; $00 to stop.
; @param[out]	zflag	z if all tiles matched as expected.
; @addr{6dcc}
_miscPuzzles_verifyTilesAtPositions:
	ld b,>wRoomLayout		; $6dcc
@newTileIndex:
	ldi a,(hl)		; $6dce
	or a			; $6dcf
	ret z			; $6dd0
	ld e,a			; $6dd1
@nextTile:
	ldi a,(hl)		; $6dd2
	ld c,a			; $6dd3
	or a			; $6dd4
	ret z			; $6dd5
	inc a			; $6dd6
	jr z,@newTileIndex		; $6dd7
	ld a,(bc)		; $6dd9
	cp e			; $6dda
	ret nz			; $6ddb
	jr @nextTile		; $6ddc



; Floor changer in present D6, triggered by orb
_miscPuzzles_subid04:
	call checkInteractionState		; $6dde
	jr z,@state0	; $6de1

@state1:
	; Check for change in state
	ld a,(wToggleBlocksState)		; $6de3
	ld b,a			; $6de6
	ld e,Interaction.counter2		; $6de7
	ld a,(de)		; $6de9
	cp b			; $6dea
	ret z			; $6deb

	ld a,b			; $6dec
	ld (de),a		; $6ded
	ld a,$ff		; $6dee
	ld (wDisabledObjects),a		; $6df0
	ld (wMenuDisabled),a		; $6df3

	ld e,Interaction.counter1		; $6df6
	ld a,(de)		; $6df8
	inc a			; $6df9
	and $01			; $6dfa
	ld b,a			; $6dfc
	ld (de),a		; $6dfd

	ld c,$05		; $6dfe
	call @spawnSubid		; $6e00
	ld c,$06		; $6e03
	call @spawnSubid		; $6e05
	callab bank16.loadD6ChangingFloorPatternToBigBuffer		; $6e08
	ret			; $6e10

@spawnSubid:
	call getFreeInteractionSlot		; $6e11
	ret nz			; $6e14
	ld (hl),INTERACID_MISC_PUZZLES		; $6e15
	inc l			; $6e17
	ld (hl),c		; $6e18
	inc l			; $6e19
	ld (hl),b		; $6e1a
	ret			; $6e1b

@state0:
	ld a,(wToggleBlocksState)		; $6e1c
	ld e,Interaction.counter2		; $6e1f
	ld (de),a		; $6e21
	jp interactionIncState		; $6e22


; Helpers for floor changer (subid $04)
_miscPuzzles_subid05:
_miscPuzzles_subid06:
	ld e,Interaction.state2		; $6e25
	ld a,(de)		; $6e27
	or a			; $6e28
	jr nz,@substate1	; $6e29

@substate0:
	ld e,Interaction.subid		; $6e2b
	ld a,(de)		; $6e2d
	sub $05			; $6e2e
	add a			; $6e30
	ld hl,@data		; $6e31
	rst_addDoubleIndex			; $6e34
	ld b,$04		; $6e35
	ld e,Interaction.var30		; $6e37
	call copyMemory		; $6e39
	jp interactionIncState2		; $6e3c

; Values for var30-var33
; var30: Start position
; var31: Value to add to position (Y) (alternates direction each column)
; var32: Value to add to position (X)
; var33: Offset in wBigBuffer to read from
@data:
	.db $91 $f0 $01 $00 ; subid 5
	.db $1d $10 $ff $80 ; subid 6

@substate1:
	ld e,Interaction.var33		; $6e47
	ld a,(de)		; $6e49
	ld l,a			; $6e4a
	ld h,>wBigBuffer		; $6e4b

@nextTile:
	ldi a,(hl)		; $6e4d
	or a			; $6e4e
	jr z,@deleteSelf	; $6e4f
	cp $ff			; $6e51
	jr nz,@setTile	; $6e53

	ld e,Interaction.var32		; $6e55
	ld a,(de)		; $6e57
	ld b,a			; $6e58
	ld e,Interaction.var30		; $6e59
	ld a,(de)		; $6e5b
	add b			; $6e5c
	ld (de),a		; $6e5d
	ld e,Interaction.var31		; $6e5e
	ld a,(de)		; $6e60
	cpl			; $6e61
	inc a			; $6e62
	ld (de),a		; $6e63
	call @nextRow		; $6e64
	jr @nextTile		; $6e67

@setTile:
	ldh (<hFF8B),a	; $6e69
	ld e,Interaction.var33		; $6e6b
	ld a,l			; $6e6d
	ld (de),a		; $6e6e
	call @nextRow		; $6e6f
	ldh a,(<hFF8B)	; $6e72
	jp setTile		; $6e74

; [var30] += [var31]
@nextRow:
	ld e,Interaction.var31		; $6e77
	ld a,(de)		; $6e79
	ld b,a			; $6e7a
	ld e,Interaction.var30		; $6e7b
	ld a,(de)		; $6e7d
	ld c,a			; $6e7e
	add b			; $6e7f
	ld (de),a		; $6e80
	ret			; $6e81

@deleteSelf:
	xor a			; $6e82
	ld (wDisabledObjects),a		; $6e83
	ld (wMenuDisabled),a		; $6e86
	jp interactionDelete		; $6e89



; Wall retraction event after lighting torches in past d6
_miscPuzzles_subid07:
	call checkInteractionState		; $6e8c
	jr z,@state0	; $6e8f

@state1:
	call checkLinkVulnerable		; $6e91
	ret nc			; $6e94

	; Check if the number of lit torches has changed.
	call @checkLitTorches		; $6e95
	ld e,Interaction.counter1		; $6e98
	ld a,(de)		; $6e9a
	cp b			; $6e9b
	ret z			; $6e9c

	; It's changed.
	ld a,b			; $6e9d
	ld (de),a		; $6e9e

	ld e,Interaction.state2		; $6e9f
	ld a,(de)		; $6ea1
	ld hl,@torchLightOrder		; $6ea2
	rst_addAToHl			; $6ea5
	ld a,(hl)		; $6ea6
	cp b			; $6ea7
	jr nz,@litWrongTorch	; $6ea8

	ld a,(de)		; $6eaa
	cp $03			; $6eab
	jp c,interactionIncState2		; $6ead

	; Lit all torches
	ld a, $ff ~ (DISABLE_ITEMS | DISABLE_ALL_BUT_INTERACTIONS)
	ld (wDisabledObjects),a		; $6eb2
	ld (wMenuDisabled),a		; $6eb5

	ld a,CUTSCENE_WALL_RETRACTION		; $7eb8
	ld (wCutsceneTrigger),a		; $6eba

	; Set bit 6 in the present version of this room
	call getThisRoomFlags		; $6ebd
	ld l,<ROOM_AGES_525		; $6ec0
	set 6,(hl)		; $6ec2
	jp interactionDelete		; $6ec4

@litWrongTorch:
	xor a			; $6ec7
	ld (de),a		; $6ec8
	ld e,Interaction.counter1		; $6ec9
	ld (de),a		; $6ecb
	ld a,SND_ERROR		; $6ecc
	call playSound		; $6ece
	ld a,TILEINDEX_UNLIT_TORCH		; $6ed1
	ld c,$31		; $6ed3
	call setTile		; $6ed5
	ld a,TILEINDEX_UNLIT_TORCH		; $6ed8
	ld c,$33		; $6eda
	call setTile		; $6edc
	ld a,TILEINDEX_UNLIT_TORCH		; $6edf
	ld c,$35		; $6ee1
	call setTile		; $6ee3
	ld a,TILEINDEX_UNLIT_TORCH		; $6ee6
	ld c,$53		; $6ee8
	call setTile		; $6eea
	jr @makeTorchesLightable		; $6eed

@torchLightOrder:
	.db $01 $03 $07 $0f

@state0:
	call getThisRoomFlags		; $6ef3
	and ROOMFLAG_80			; $6ef6
	jp nz,interactionDelete		; $6ef8

	call interactionIncState		; $6efb
	call @checkLitTorches		; $6efe
	ld a,b			; $6f01
	ld e,Interaction.counter1		; $6f02
	ld (de),a		; $6f04

@makeTorchesLightable:
	call @makeTorchesUnlightable		; $6f05
	ld hl,objectData.objectData_makeTorchesLightableForD6Room		; $6f08
	jp parseGivenObjectData		; $6f0b

;;
; @addr{6f0e}
@makeTorchesUnlightable:
	ldhl FIRST_PART_INDEX, Part.id		; $6f0e
--
	ld a,(hl)		; $6f11
	cp PARTID_LIGHTABLE_TORCH			; $6f12
	call z,@deletePartObject		; $6f14
	inc h			; $6f17
	ld a,h			; $6f18
	cp LAST_PART_INDEX+1			; $6f19
	jr c,--			; $6f1b
	ret			; $6f1d

@deletePartObject:
	push hl			; $6f1e
	dec l			; $6f1f
	ld b,$40		; $6f20
	call clearMemory		; $6f22
	pop hl			; $6f25
	ret			; $6f26

;;
; @param[out]	b	Bitset of lit torches (in bits 0-3)
; @addr{6f27}
@checkLitTorches:
	ld a,TILEINDEX_LIT_TORCH		; $6f27
	ld b,$00		; $6f29
	ld hl,wRoomLayout+$31		; $6f2b
	cp (hl)			; $6f2e
	jr nz,+			; $6f2f
	set 0,b			; $6f31
+
	ld l,$33		; $6f33
	cp (hl)			; $6f35
	jr nz,+			; $6f36
	set 1,b			; $6f38
+
	ld l,$53		; $6f3a
	cp (hl)			; $6f3c
	jr nz,+			; $6f3d
	set 2,b			; $6f3f
+
	ld l,$35		; $6f41
	cp (hl)			; $6f43
	ret nz			; $6f44
	set 3,b			; $6f45
	ret			; $6f47



; Checks to set the "bombable wall open" bit in d6 (north)
_miscPuzzles_subid08:
	call interactionDeleteAndRetIfEnabled02		; $6f48
	call getThisRoomFlags		; $6f4b
	bit ROOMFLAG_BIT_KEYDOOR_UP,(hl)		; $6f4e
	ret z			; $6f50
	ld l,<ROOM_AGES_519		; $6f51
	set ROOMFLAG_BIT_KEYDOOR_UP,(hl)		; $6f53
	jp interactionDelete		; $6f55



; Checks to set the "bombable wall open" bit in d6 (east)
_miscPuzzles_subid09:
	call interactionDeleteAndRetIfEnabled02		; $6f58
	call getThisRoomFlags		; $6f5b
	bit ROOMFLAG_BIT_KEYDOOR_RIGHT,(hl)		; $6f5e
	ret z			; $6f60
	ld l,<ROOM_AGES_526		; $6f61
	set ROOMFLAG_BIT_KEYDOOR_RIGHT,(hl)		; $6f63
	jp interactionDelete		; $6f65



; Jabu-jabu water level controller script, in the room with the 3 buttons
_miscPuzzles_subid0a:
	ld e,Interaction.state		; $6f68
	ld a,(de)		; $6f6a
	rst_jumpTable			; $6f6b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,(wActiveTriggers)		; $6f74
	ld e,Interaction.var30		; $6f77
	ld (de),a		; $6f79

	ld a,(wJabuWaterLevel)		; $6f7a
	and $f0			; $6f7d
	ld (wSwitchState),a		; $6f7f
	jp interactionIncState		; $6f82

@state1:
	; Check if a button was pressed
	ld a,(wActiveTriggers)		; $6f85
	ld b,a			; $6f88
	ld e,Interaction.var30		; $6f89
	ld a,(de)		; $6f8b
	xor b			; $6f8c
	ld c,a			; $6f8d
	ld a,b			; $6f8e
	ld (de),a		; $6f8f

	bit 7,c			; $6f90
	jr nz,@drainWater	; $6f92

	; Ret if none pressed
	and c			; $6f94
	ret z			; $6f95
	ld a,(wSwitchState)		; $6f96
	and c			; $6f99
	ret nz			; $6f9a

	ld a,c			; $6f9b
	ld hl,wSwitchState		; $6f9c
	or (hl)			; $6f9f
	ld (hl),a		; $6fa0
	and $f0			; $6fa1
	ld b,a			; $6fa3
	ld hl,wJabuWaterLevel		; $6fa4
	ld a,(hl)		; $6fa7
	and $03			; $6fa8
	inc a			; $6faa
	or b			; $6fab
	ld (hl),a		; $6fac
	ld a,<TX_1209		; $6fad
	jr @beginCutscene		; $6faf

@drainWater:
	ld a,(wJabuWaterLevel)		; $6fb1
	and $07			; $6fb4
	ret z			; $6fb6
	xor a			; $6fb7
	ld (wJabuWaterLevel),a		; $6fb8
	ld (wSwitchState),a		; $6fbb
	ld a,<TX_1208		; $6fbe

@beginCutscene:
	ld e,Interaction.var31		; $6fc0
	ld (de),a		; $6fc2

	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $6fc3
	ld (wDisabledObjects),a		; $6fc5
	ld (wMenuDisabled),a		; $6fc8

	ld e,Interaction.counter1		; $6fcb
	ld a,60		; $6fcd
	ld (de),a		; $6fcf

	ld a,SNDCTRL_STOPMUSIC		; $6fd0
	call playSound		; $6fd2
	jp interactionIncState		; $6fd5

@state2:
	call interactionDecCounter1		; $6fd8
	ret nz			; $6fdb

	ld a,$f0		; $6fdc
	ld (hl),a		; $6fde
	call setScreenShakeCounter		; $6fdf
	ld a,SND_FLOODGATES		; $6fe2
	call playSound		; $6fe4
	jp interactionIncState		; $6fe7

@state3:
	call interactionDecCounter1		; $6fea
	ret nz			; $6fed

	ld l,Interaction.state		; $6fee
	ld (hl),$01		; $6ff0
	xor a			; $6ff2
	ld (wDisabledObjects),a		; $6ff3
	ld (wMenuDisabled),a		; $6ff6

	ld b,>TX_1200		; $6ff9
	ld l,Interaction.var31		; $6ffb
	ld c,(hl)		; $6ffd
	call showText		; $6ffe

	ld a,SNDCTRL_STOPSFX		; $7001
	call playSound		; $7003
	ld a,(wActiveMusic)		; $7006
	jp playSound		; $7009



; Ladder spawner in d7 miniboss room
_miscPuzzles_subid0b:
	ld e,Interaction.state		; $700c
	ld a,(de)		; $700e
	rst_jumpTable			; $700f
	.dw _miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set
	.dw @state1
	.dw @state2

@state1:
	ld a,(wNumEnemies)		; $7016
	or a			; $7019
	ret nz			; $701a

	call getThisRoomFlags		; $701b
	set ROOMFLAG_BIT_80,(hl)		; $701e
	ld l,<ROOM_AGES_54d		; $7020
	set ROOMFLAG_BIT_80,(hl)		; $7022
	ld e,Interaction.counter1		; $7024
	ld a,$08		; $7026
	ld (de),a		; $7028
	jp interactionIncState		; $7029

@state2:
	call interactionDecCounter1		; $702c
	ret nz			; $702f

	; Add the next ladder tile
	ld (hl),$08		; $7030
	call objectGetTileAtPosition		; $7032
	ld c,l			; $7035
	ld a,c			; $7036
	ldh (<hFF92),a	; $7037

	ld a,TILEINDEX_SS_LADDER		; $7039
	call setTile		; $703b

	ld b,INTERACID_PUFF		; $703e
	call objectCreateInteractionWithSubid00		; $7040

	ld e,Interaction.yh		; $7043
	ld a,(de)		; $7045
	add $10			; $7046
	ld (de),a		; $7048

	ldh a,(<hFF92)	; $7049
	cp $90			; $704b
	ret c			; $704d

	; Restore the entrance on the left side
	ld c,$80		; $704e
	ld a,TILEINDEX_SS_52		; $7050
	call setTile		; $7052
	ld c,$90		; $7055
	ld a,TILEINDEX_SS_EMPTY		; $7057
	call setTile		; $7059

	ld a,SND_SOLVEPUZZLE		; $705c
	call playSound		; $705e
	xor a			; $7061
	ld (wDisableLinkCollisionsAndMenu),a		; $7062
	jp interactionDelete		; $7065



; Switch hook puzzle early in d7 for a small key
_miscPuzzles_subid0c:
	call interactionDeleteAndRetIfEnabled02		; $7068
	call _miscPuzzles_deleteSelfAndRetIfItemFlagSet		; $706b

	ld hl,_miscPuzzles_subid0c_wantedTiles		; $706e
	call _miscPuzzles_verifyTilesAtPositions		; $7071
	ret nz			; $7074

;;
; @addr{7075}
_miscPuzzles_dropSmallKeyHere:
	ldbc TREASURE_SMALL_KEY, $01		; $7075
	call createTreasure		; $7078
	ret nz			; $707b
	call objectCopyPosition		; $707c
	jp interactionDelete		; $707f

_miscPuzzles_subid0c_wantedTiles:
	.db TILEINDEX_SWITCH_DIAMOND
	.db $36 $3a $76 $7a
	.db $00



; Staircase spawner after moving first set of stone panels in d8
_miscPuzzles_subid0d:
	ld e,Interaction.state		; $7088
	ld a,(de)		; $708a
	rst_jumpTable			; $708b
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call getThisRoomFlags		; $7092
	and ROOMFLAG_40			; $7095
	jp nz,interactionDelete		; $7097

	ld a,(wNumTorchesLit)		; $709a
	cp $01			; $709d
	ret nz			; $709f
	ld hl,wActiveTriggers		; $70a0
	ld a,(hl)		; $70a3
	cp $07			; $70a4
	ret nz			; $70a6

	ld e,Interaction.counter1		; $70a7
	ld a,30		; $70a9
	ld (de),a		; $70ab
	ld a,$08		; $70ac
	call setScreenShakeCounter		; $70ae
	ld a,SND_DOORCLOSE		; $70b1
	call playSound		; $70b3
	jp interactionIncState		; $70b6

@state1:
	call interactionDecCounter1		; $70b9
	ret nz			; $70bc

	ld hl,wActiveTriggers		; $70bd
	ld a,(hl)		; $70c0
	cp $07			; $70c1
	jr z,++			; $70c3
	ld e,Interaction.state		; $70c5
	xor a			; $70c7
	ld (de),a		; $70c8
	ret			; $70c9
++
	set 7,(hl)		; $70ca
	jp interactionIncState		; $70cc

@state2:
	; Wait for bit 7 of wActiveTriggers to be unset by another object?
	ld a,(wActiveTriggers)		; $70cf
	bit 7,a			; $70d2
	ret nz			; $70d4

	ld a,SND_SOLVEPUZZLE		; $70d5
	call playSound		; $70d7
	ld b,INTERACID_PUFF		; $70da
	call objectCreateInteractionWithSubid00		; $70dc

	call objectGetTileAtPosition		; $70df
	ld c,l			; $70e2
	ld a,TILEINDEX_NORTH_STAIRS		; $70e3
	call setTile		; $70e5
	jp interactionDelete		; $70e8



; Staircase spawner after putting in slates in d8
_miscPuzzles_subid0e:
	call checkInteractionState		; $70eb
	jp nz,@state1		; $70ee

@state0:
	call getThisRoomFlags		; $70f1
	bit ROOMFLAG_BIT_40,(hl)		; $70f4
	jp nz,interactionDelete		; $70f6

	; Wait for all slates to be put in
	ld a,(hl)		; $70f9
	and ROOMFLAG_01|ROOMFLAG_02|ROOMFLAG_04|ROOMFLAG_08
	cp  ROOMFLAG_01|ROOMFLAG_02|ROOMFLAG_04|ROOMFLAG_08
	ret nz			; $70fe

	ld hl,wActiveTriggers		; $70ff
	set 7,(hl)		; $7102
	jp interactionIncState		; $7104

@state1:
	; Wait for another object to unset bit 7 of wActiveTriggers?
	ld a,(wActiveTriggers)		; $7107
	bit 7,a			; $710a
	ret nz			; $710c

	ld a,SND_SOLVEPUZZLE		; $710d
	call playSound		; $710f
	ld b,INTERACID_PUFF		; $7112
	call objectCreateInteractionWithSubid00		; $7114

	call objectGetTileAtPosition		; $7117
	ld c,l			; $711a
	ld a,TILEINDEX_NORTH_STAIRS		; $711b
	call setTile		; $711d
	jp interactionDelete		; $7120



; Octogon boss initialization (in the room just before the boss)
_miscPuzzles_subid0f:
	ld hl,wTmpcfc0.octogonBoss.loadedExtraGfx		; $7123
	xor a			; $7126
	ldi (hl),a		; $7127
	ldi (hl),a ; [var03] = 0
	dec a			; $7129
	ldi (hl),a ; [direction] = $ff
	ld (hl),$28 ; [health]
	inc l			; $712d
	ld (hl),$28 ; [y]
	inc l			; $7130
	ld (hl),$78 ; [x]
	inc l			; $7133
	ld (hl),a ; [var30] = $ff
	jp interactionDelete		; $7135



; Something at the top of Talus Peaks?
_miscPuzzles_subid10:
	ld hl,wTmpcfc0.patchMinigame.fixingSword		; $7138
	ld b,$08		; $713b
	call clearMemory		; $713d
	jp interactionDelete		; $7140



; D5 keyhole opening
_miscPuzzles_subid11:
	call checkInteractionState		; $7143
	jp nz,interactionRunScript		; $7146

	call returnIfScrollMode01Unset		; $7149
	call getThisRoomFlags		; $714c
	and ROOMFLAG_80			; $714f
	jp nz,interactionDelete		; $7151

	push de			; $7154
	call reloadTileMap		; $7155
	pop de			; $7158
	ld hl,miscPuzzles_crownDungeonOpeningScript		; $7159

;;
; @addr{715c}
_miscPuzzles_setScriptAndIncState:
	call interactionSetScript		; $715c
	call interactionSetAlwaysUpdateBit		; $715f
	jp interactionIncState		; $7162



; D6 present/past keyhole opening
_miscPuzzles_subid12:
	call checkInteractionState		; $7165
	jp nz,interactionRunScript		; $7168

	call getThisRoomFlags		; $716b
	and ROOMFLAG_80			; $716e
	jp nz,interactionDelete		; $7170
	ld hl,miscPuzzles_mermaidsCaveDungeonOpeningScript		; $7173
	jr _miscPuzzles_setScriptAndIncState		; $7176



; Eyeglass library keyhole opening
_miscPuzzles_subid13:
	call checkInteractionState		; $7178
	jp nz,interactionRunScript		; $717b

	call getThisRoomFlags		; $717e
	and ROOMFLAG_80			; $7181
	jp nz,interactionDelete		; $7183
	ld hl,miscPuzzles_eyeglassLibraryOpeningScript		; $7186
	jr _miscPuzzles_setScriptAndIncState		; $7189



; Spot to put a rolling colored block on in Hero's Cave
_miscPuzzles_subid14:
	call checkInteractionState		; $718b
	jp z,_miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set		; $718e

	; Check that the tile at this position matches the cube color
	call objectGetTileAtPosition		; $7191
	sub TILEINDEX_RED_TOGGLE_FLOOR			; $7194
	cp $03			; $7196
	ret nc			; $7198
	ld b,a			; $7199
	ld a,(wRotatingCubePos)		; $719a
	cp l			; $719d
	ret nz			; $719e
	ld a,(wRotatingCubeColor)		; $719f
	and $03			; $71a2
	cp b			; $71a4
	ret nz			; $71a5

	; They match.
	ld c,l			; $71a6
	ld hl,wActiveTriggers		; $71a7
	ld a,b			; $71aa
	call setFlag		; $71ab

	ld a,$a3		; $71ae
	call setTile		; $71b0

	ld b,>wRoomCollisions		; $71b3
	ld a,$0f		; $71b5
	ld (bc),a		; $71b7
	ld a,SND_CLINK		; $71b8
	jp playSound		; $71ba



; Stairs from solving colored cube puzzle in Hero's Cave (related to subid $14)
_miscPuzzles_subid15:
	call checkInteractionState		; $71bd
	jp z,_miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set		; $71c0

	ld a,(wActiveTriggers)		; $71c3
	cp $07			; $71c6
	ret nz			; $71c8

	ld a,SND_SOLVEPUZZLE		; $71c9
	call playSound		; $71cb
	ld a,TILEINDEX_INDOOR_DOWNSTAIRCASE		; $71ce
	ld c,$15		; $71d0
	call setTile		; $71d2
	call getThisRoomFlags		; $71d5
	set ROOMFLAG_BIT_80,(hl)		; $71d8
	jp interactionDelete		; $71da



; Warps Link out of Hero's Cave upon opening the chest
_miscPuzzles_subid16:
	ld e,Interaction.state		; $71dd
	ld a,(de)		; $71df
	rst_jumpTable			; $71e0
	.dw _miscPuzzles_deleteSelfOrIncStateIfItemFlagSet
	.dw @state1
	.dw @state2

@state1:
	call getThisRoomFlags		; $71e7
	and ROOMFLAG_ITEM			; $71ea
	ret z			; $71ec
	call interactionIncState		; $71ed

@state2:
	ld a,DISABLE_ALL_BUT_INTERACTIONS | DISABLE_LINK		; $71f0
	ld (wDisabledObjects),a		; $71f2
	ld (wDisableLinkCollisionsAndMenu),a		; $71f5
	call retIfTextIsActive		; $71f8
	ld hl,@warpDestData		; $71fb
	call setWarpDestVariables		; $71fe
	jp interactionDelete		; $7201

@warpDestData:
	m_HardcodedWarpA ROOM_AGES_048, $01, $28, $03



; Enables portal in Hero's Cave first room if its other end is active
_miscPuzzles_subid17:
	call getThisRoomFlags		; $7209
	push hl			; $720c
	ld l,<ROOM_AGES_4c9		; $720d
	bit ROOMFLAG_BIT_ITEM,(hl)		; $720f
	pop hl			; $7211
	jr z,+			; $7212
	set ROOMFLAG_BIT_ITEM,(hl)		; $7214
+
	jp interactionDelete		; $7216



; Drops a key in hero's cave block-pushing puzzle
_miscPuzzles_subid18:
	call checkInteractionState		; $7219
	jp z,_miscPuzzles_deleteSelfOrIncStateIfItemFlagSet		; $721c

	ld hl,wRoomLayout+$95		; $721f
	ld a,(hl)		; $7222
	cp TILEINDEX_PUSHABLE_STATUE			; $7223
	ret nz			; $7225
	ld l,$5d		; $7226
	ld a,(hl)		; $7228
	cp TILEINDEX_PUSHABLE_STATUE			; $7229
	ret nz			; $722b
	jp _miscPuzzles_dropSmallKeyHere		; $722c



; Bridge controller in d5 room after the miniboss
_miscPuzzles_subid19:
	ld e,Interaction.state		; $722f
	ld a,(de)		; $7231
	rst_jumpTable			; $7232
	.dw interactionIncState
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

; Trigger off, waiting for it to be pressed
@state1:
	ld a,(wActiveTriggers)		; $723d
	rrca			; $7240
	ret nc			; $7241
	ld e,Interaction.counter1		; $7242
	ld a,$08		; $7244
	ld (de),a		; $7246
	jp interactionIncState		; $7247

; Trigger enabled, in the process of extending the bridge
@state2:
	ld a,(wActiveTriggers)		; $724a
	rrca			; $724d
	jr nc,@@releasedTrigger	; $724e
	call interactionDecCounter1		; $7250
	ret nz			; $7253
	ld (hl),$08		; $7254
	ld hl,wRoomLayout+$55		; $7256
--
	ld c,l			; $7259
	ldi a,(hl)		; $725a
	cp TILEINDEX_BLANK_HOLE			; $725b
	jr nz,++		; $725d
	ld a,TILEINDEX_HORIZONTAL_BRIDGE		; $725f
	call setTileInAllBuffers		; $7261
	ld a,SND_DOORCLOSE		; $7264
	jp playSound		; $7266
++
	ld a,l			; $7269
	cp $5a			; $726a
	jr c,--			; $726c
	jp interactionIncState		; $726e

@@releasedTrigger:
	call interactionIncState		; $7271
	inc (hl)		; $7274
	ret			; $7275

; Bridge fully extended, waiting for trigger to be released
@state3:
	ld a,(wActiveTriggers)		; $7276
	rrca			; $7279
	ret c			; $727a
	jp interactionIncState		; $727b

; Trigger released, in the process of retracting the bridge
@state4:
	ld a,(wActiveTriggers)		; $727e
	rrca			; $7281
	jr c,@@pressedTrigger	; $7282
	call interactionDecCounter1		; $7284
	ret nz			; $7287

	ld (hl),$08		; $7288

	ld hl,wRoomLayout+$59		; $728a
--
	ld c,l			; $728d
	ldd a,(hl)		; $728e
	cp TILEINDEX_BLANK_HOLE			; $728f
	jr z,++			; $7291

	cp TILEINDEX_SWITCH_DIAMOND			; $7293
	call z,@createDebris		; $7295

	ld a,TILEINDEX_BLANK_HOLE		; $7298
	call setTileInAllBuffers		; $729a
	ld a,SND_DOORCLOSE		; $729d
	jp playSound		; $729f
++
	ld a,l			; $72a2
	cp $55			; $72a3
	jr nc,--		; $72a5

@@pressedTrigger:
	ld e,Interaction.state		; $72a7
	ld a,$01		; $72a9
	ld (de),a		; $72ab
	ret			; $72ac

@createDebris:
	push hl			; $72ad
	push bc			; $72ae
	ld b,INTERACID_ROCKDEBRIS		; $72af
	call objectCreateInteractionWithSubid00		; $72b1
	pop bc			; $72b4
	pop hl			; $72b5
	ret			; $72b6



; Checks solution to pushblock puzzle in Hero's Cave
_miscPuzzles_subid1a:
	call interactionDeleteAndRetIfEnabled02		; $72b7
	call _miscPuzzles_deleteSelfAndRetIfItemFlagSet		; $72ba

	ld hl,@wantedTiles		; $72bd
	call _miscPuzzles_verifyTilesAtPositions		; $72c0
	ret nz			; $72c3
	jpab interactionBank08.spawnChestAndDeleteSelf		; $72c4

@wantedTiles:
	.db TILEINDEX_RED_PUSHABLE_BLOCK    $4a $4b $4c $ff
	.db TILEINDEX_YELLOW_PUSHABLE_BLOCK $5a $5c $ff
	.db TILEINDEX_BLUE_PUSHABLE_BLOCK   $6a $6c $00



; Subids $1b-$1d: Spawn gasha seeds at the top of the maku tree at specific times.
; b = essence that must be obtained; c = position to spawn it at.
_miscPuzzles_subid1b:
	ldbc $08, $53		; $72d9
	jr ++			; $72dc

_miscPuzzles_subid1c:
	ldbc $40, $34		; $72de
	jr ++			; $72e1

_miscPuzzles_subid1d:
	ldbc $20, $34		; $72e3
++
	push bc			; $72e6
	ld a,TREASURE_ESSENCE		; $72e7
	call checkTreasureObtained		; $72e9
	pop bc			; $72ec
	jr nc,@delete		; $72ed
	and b			; $72ef
	jr z,@delete		; $72f0

	call objectSetShortPosition		; $72f2
	call getThisRoomFlags		; $72f5
	and ROOMFLAG_ITEM			; $72f8
	jr nz,@delete		; $72fa

	ld bc,TREASURE_GASHA_SEED_SUBID_07		; $72fc
	call createTreasure		; $72ff
	call z,objectCopyPosition		; $7302
@delete:
	jp interactionDelete		; $7305



; Play "puzzle solved" sound after navigating eyeball puzzle in final dungeon
_miscPuzzles_subid1e:
	call returnIfScrollMode01Unset		; $7308
	ld a,(wScreenTransitionDirection)		; $730b
	or a			; $730e
	jp nz,interactionDelete		; $730f
	ld a,SND_SOLVEPUZZLE		; $7312
	call playSound		; $7314
	jp interactionDelete		; $7317



; Checks if Link gets stuck in the d5 boss key puzzle, resets the room if so
_miscPuzzles_subid1f:
	ld e,Interaction.state		; $731a
	ld a,(de)		; $731c
	rst_jumpTable			; $731d
	.dw interactionIncState
	.dw @state1
	.dw @state2

@state1:
	call interactionDecCounter1		; $7324
	ret nz			; $7327

	ld (hl),30		; $7328

	; Get Link's short position in 'e'
	ld hl,w1Link.yh		; $732a
	ldi a,(hl)		; $732d
	and $f0			; $732e
	ld b,a			; $7330
	inc l			; $7331
	ld a,(hl)		; $7332
	and $f0			; $7333
	swap a			; $7335
	or b			; $7337
	ld e,a			; $7338

	push de			; $7339
	ld hl,@offsetsToCheck		; $733a
	ld d,$08		; $733d

@checkNextOffset:
	ldi a,(hl)		; $733f
	add e			; $7340
	ld c,a			; $7341
	ld b,>wRoomCollisions		; $7342
	ld a,(bc)		; $7344
	or a			; $7345
	jr z,@doneCheckingIfTrapped	; $7346

	; For odd-indexed offsets only (one tile away from Link), check if we're near the
	; screen edge? If so, skip the next check?
	bit 0,d			; $7348
	jr nz,++			; $734a

	ld b,>wRoomLayout		; $734c
	ld a,(bc)		; $734e
	or a			; $734f
	jr nz,++			; $7350
	inc hl			; $7352
	dec d			; $7353
++
	dec d			; $7354
	jr nz,@checkNextOffset	; $7355

@doneCheckingIfTrapped:
	ld a,d			; $7357
	pop de			; $7358
	or a			; $7359
	ret nz			; $735a

	; Link is trapped; warp him out
	call checkLinkVulnerable		; $735b
	ret nc			; $735e
	ld a,DISABLE_LINK		; $735f
	ld (wMenuDisabled),a		; $7361
	ld (wDisabledObjects),a		; $7364
	ld a,SND_ERROR		; $7367
	call playSound		; $7369

	ld e,Interaction.counter1		; $736c
	ld a,60		; $736e
	ld (de),a		; $7370
	jp interactionIncState		; $7371

; Checks if there are solid walls / holes at all of these positions relative to Link
@offsetsToCheck:
	.db $f0 $e0 $01 $02 $10 $20 $ff $fe

@state2:
	call interactionDecCounter1	; $737c
	ret nz			; $737f
	xor a			; $7380
	ld (wMenuDisabled),a		; $7381
	ld (wDisabledObjects),a		; $7384
	ld hl,@warpDest		; $7387
	jp setWarpDestVariables		; $738a

@warpDest:
	m_HardcodedWarpA ROOM_AGES_49b, $00, $12, $03



; Money in sidescrolling room in Hero's Cave
_miscPuzzles_subid20:
	call getThisRoomFlags		; $7392
	and ROOMFLAG_ITEM			; $7395
	jr nz,@delete	; $7397

	ld bc,TREASURE_RUPEES_SUBID_16		; $7399
	call createTreasure		; $739c
	jp nz,@delete		; $739f
	call objectCopyPosition		; $73a2
@delete:
	jp interactionDelete		; $73a5



; Creates explosions while screen is fading out; used in some cutscene?
_miscPuzzles_subid21:
	call checkInteractionState		; $73a8
	jr z,@state0	; $73ab

	ld a,(wPaletteThread_mode)		; $73ad
	or a			; $73b0
	jp z,interactionDelete		; $73b1

	ld a,(wFrameCounter)		; $73b4
	ld b,a			; $73b7
	and $1f			; $73b8
	ret nz			; $73ba

	ld a,b			; $73bb
	and $70			; $73bc
	swap a			; $73be
	ld hl,@explosionPositions		; $73c0
	rst_addDoubleIndex			; $73c3
	ldi a,(hl)		; $73c4
	ld b,a			; $73c5
	ld c,(hl)		; $73c6
	call getFreeInteractionSlot		; $73c7
	ret nz			; $73ca
	ld (hl),INTERACID_EXPLOSION		; $73cb
	jp objectCopyPositionWithOffset		; $73cd

@explosionPositions:
	.db $f4 $0c
	.db $04 $fb
	.db $08 $10
	.db $fe $f4
	.db $0c $08
	.db $fc $04
	.db $06 $f8
	.db $f8 $fe

@state0:
	call interactionIncState		; $73e0
	ld a,$04		; $73e3
	jp fadeoutToWhiteWithDelay		; $73e5

;;
; @addr{73e8}
_miscPuzzles_deleteSelfAndRetIfItemFlagSet:
	call getThisRoomFlags		; $73e8
	and ROOMFLAG_ITEM			; $73eb
	ret z			; $73ed
	pop hl			; $73ee
	jp interactionDelete		; $73ef

;;
; @addr{73f2}
_miscPuzzles_deleteSelfOrIncStateIfItemFlagSet:
	call getThisRoomFlags		; $73f2
	and ROOMFLAG_ITEM			; $73f5
	jp nz,interactionDelete		; $73f7
	jp interactionIncState		; $73fa

;;
; @addr{73fd}
_miscPuzzles_deleteSelfOrIncStateIfRoomFlag7Set:
	call getThisRoomFlags		; $73fd
	and ROOMFLAG_80			; $7400
	jp nz,interactionDelete		; $7402
	jp interactionIncState		; $7405

;;
; Unused
; @addr{7408}
_miscPuzzles_deleteSelfOrIncStateIfRoomFlag6Set:
	call getThisRoomFlags		; $7408
	and ROOMFLAG_40			; $740b
	jp nz,interactionDelete		; $740d
	jp interactionIncState		; $7410



; ==============================================================================
; INTERACID_FALLING_ROCK
; ==============================================================================
interactionCode92:
	ld e,Interaction.subid		; $7413
	ld a,(de)		; $7415
	rst_jumpTable			; $7416
	.dw _fallingRock_subid00
	.dw _fallingRock_subid01
	.dw _fallingRock_subid02
	.dw _fallingRock_subid03
	.dw _fallingRock_subid04
	.dw _fallingRock_subid05
	.dw _fallingRock_subid06


; Spawner of falling rocks; stops when $cfdf is nonzero. Used when freeing goron elder.
_fallingRock_subid00:
	call checkInteractionState		; $7425
	jr nz,@state1	; $7428

@state0:
	call interactionIncState		; $742a
	ld l,Interaction.counter2		; $742d
	ld (hl),$01		; $742f
@state1:
	ld a,(wTmpcfc0.goronCutscenes.elder_stopFallingRockSpawner)		; $7431
	or a			; $7434
	jp nz,interactionDelete		; $7435

	call interactionDecCounter2		; $7438
	ret nz			; $743b

	ld l,Interaction.counter2		; $743c
	ld (hl),20		; $743e
	call getFreeInteractionSlot		; $7440
	ret nz			; $7443
	ld (hl),INTERACID_FALLING_ROCK		; $7444
	inc l			; $7446
	ld (hl),$01		; $7447
	inc l			; $7449
	ld e,Interaction.var03		; $744a
	ld a,(de)		; $744c
	ld (hl),a		; $744d
	ret			; $744e


; Instance of falling rock spawned by subid $00
_fallingRock_subid01:
	call checkInteractionState		; $744f
	jr nz,@state1		; $7452
	call _fallingRock_initGraphicsAndIncState		; $7454
	call _fallingRock_chooseRandomPosition		; $7457

@state1:
	ld c,$10		; $745a
	call objectUpdateSpeedZ_paramC		; $745c
	jr nz,@ret	; $745f

	; Rock has hit the ground
	call objectReplaceWithAnimationIfOnHazard		; $7461
	jp c,interactionDelete		; $7464

	ld a,SND_BREAK_ROCK		; $7467
	call playSound		; $7469
	call @spawnDebris		; $746c
	ld a,$04		; $746f
	call setScreenShakeCounter		; $7471
	jp interactionDelete		; $7474
@ret:
	ret			; $7477

@spawnDebris:
	call getRandomNumber		; $7478
	and $03			; $747b
	ld c,a			; $747d
	ld b,$00		; $747e
@next:
	push bc			; $7480
	ldbc INTERACID_FALLING_ROCK, $02		; $7481
	call objectCreateInteraction		; $7484
	pop bc			; $7487
	ret nz			; $7488
	ld l,Interaction.counter1		; $7489
	ld (hl),c		; $748b
	ld l,Interaction.angle		; $748c
	ld (hl),b		; $748e
	inc b			; $748f
	ld a,b			; $7490
	cp $04			; $7491
	jr nz,@next	; $7493
	ret			; $7495


; Used by gorons when freeing elder?
_fallingRock_subid02:
	call checkInteractionState		; $7496
	jr nz,@state1	; $7499

@state0:
	call _fallingRock_initGraphicsAndIncState		; $749b
	call interactionSetAlwaysUpdateBit		; $749e
	ld l,Interaction.var03		; $74a1
	ld a,(hl)		; $74a3
	or a			; $74a4
	jr nz,++		; $74a5

	ld l,Interaction.counter1		; $74a7
	ld a,(hl)		; $74a9
	jr @loadAngle		; $74aa
++
	ld l,Interaction.counter1		; $74ac
	ld a,(hl)		; $74ae
	add $04			; $74af
@loadAngle:
	add a			; $74b1
	add a			; $74b2
	ld l,Interaction.angle		; $74b3
	add (hl)		; $74b5
	ld bc,@angles		; $74b6
	call addAToBc		; $74b9
	ld a,(bc)		; $74bc
	ld (hl),a		; $74bd
	ld l,Interaction.var03		; $74be
	ld a,(hl)		; $74c0
	or a			; $74c1
	jr nz,@lowSpeed		; $74c2

	ld l,Interaction.speed		; $74c4
	ld (hl),SPEED_180		; $74c6
	ld l,Interaction.speedZ		; $74c8
	ld a,$18		; $74ca
	ldi (hl),a		; $74cc
	ld (hl),$ff		; $74cd
	ret			; $74cf

@lowSpeed:
	ld l,Interaction.speed		; $74d0
	ld (hl),SPEED_100		; $74d2
	ld l,Interaction.speedZ		; $74d4
	ld a,$1c		; $74d6
	ldi (hl),a		; $74d8
	ld (hl),$ff		; $74d9
	ret			; $74db

; List of angle values.
; A byte is read from offset: ([counter1] + ([var03] != 0 ? 4 : 0)) * 4 + [angle]
; (These 3 variables should be set by whatever spawned this object)
@angles:
	.db $04 $0c $14 $1c $02 $0a $12 $1a
	.db $04 $0c $14 $1c $06 $0e $16 $1e
	.db $1a $14 $0c $06 $16 $1c $04 $0a

@state1:
	ld a,(wTmpcfc0.goronCutscenes.cfde)		; $74f4
	or a			; $74f7
	jp nz,interactionDelete		; $74f8

_fallingRock_updateSpeedAndDeleteWhenLanded:
	ld c,$18		; $74fb
	call objectUpdateSpeedZ_paramC		; $74fd
	jp z,interactionDelete		; $7500
	jp objectApplySpeed		; $7503


; A twinkle? angle is a value from 0-3, indicating a diagonal to move in.
_fallingRock_subid03:
	call checkInteractionState		; $7506
	jr nz,_fallingRock_subid03_state1	; $7509

@state0:
	call _fallingRock_initGraphicsAndIncState		; $750b
	call interactionSetAlwaysUpdateBit		; $750e
_fallingRock_initDiagonalAngle:
	ld l,Interaction.angle		; $7511
	ld a,(hl)		; $7513
	ld bc,@diagonalAngles		; $7514
	call addAToBc		; $7517
	ld a,(bc)		; $751a
	ld (hl),a		; $751b
	ld l,Interaction.speed		; $751c
	ld (hl),SPEED_100		; $751e
	ret			; $7520

@diagonalAngles:
	.db $04 $0c $14 $1c

_fallingRock_subid03_state1:
	ld e,Interaction.animParameter		; $7525
	ld a,(de)		; $7527
	cp $ff			; $7528
	jp z,interactionDelete		; $752a
	call interactionAnimate		; $752d
	jp objectApplySpeed		; $7530


; Blue/Red rock debris, moving straight on a diagonal? (angle from 0-3)
_fallingRock_subid04:
_fallingRock_subid05:
	call checkInteractionState		; $7533
	jr nz,@state1	; $7536

@state0:
	call _fallingRock_initGraphicsAndIncState		; $7538
	call interactionSetAlwaysUpdateBit		; $753b
	ld l,Interaction.counter1		; $753e
	ld (hl),$0c		; $7540
	jr _fallingRock_initDiagonalAngle		; $7542
@state1:
	call interactionDecCounter1		; $7544
	jp z,interactionDelete		; $7547
	call interactionAnimate		; $754a
	jp objectApplySpeed		; $754d


; Debris from pickaxe workers?
_fallingRock_subid06:
	call checkInteractionState		; $7550
	jp nz,_fallingRock_updateSpeedAndDeleteWhenLanded		; $7553

@state0:
	call _fallingRock_initGraphicsAndIncState		; $7556
	call interactionSetAlwaysUpdateBit		; $7559
	ld l,Interaction.var03		; $755c
	ld a,(hl)		; $755e
	or $08			; $755f
	ld l,Interaction.oamFlags		; $7561
	ld (hl),a		; $7563
	ld l,Interaction.counter2		; $7564
	ld a,(hl)		; $7566
	or a			; $7567
	jr z,+			; $7568
	dec a			; $756a
+
	ld b,a			; $756b
	ld l,Interaction.visible		; $756c
	ld a,(hl)		; $756e
	and $bc			; $756f
	or b			; $7571
	ld (hl),a		; $7572

	ld l,Interaction.angle		; $7573
	ld a,(hl)		; $7575
	ld bc,@angles		; $7576
	call addAToBc		; $7579
	ld a,(bc)		; $757c
	ld (hl),a		; $757d
	ld l,Interaction.speed		; $757e
	ld (hl),SPEED_80		; $7580
	ld l,Interaction.speedZ		; $7582
	ld a,$40		; $7584
	ldi (hl),a		; $7586
	ld (hl),$ff		; $7587
	ret			; $7589

@angles:
	.db $08 $18

;;
; @addr{758c}
_fallingRock_initGraphicsAndIncState:
	call interactionInitGraphics	; $758c
	call objectSetVisiblec1		; $758f
	jp interactionIncState		; $7592

;;
; Randomly choose a position from a list of possible positions. var03 determines which
; list it reads from?
; @addr{7595}
_fallingRock_chooseRandomPosition:
	ld e,Interaction.var03		; $7595
	ld a,(de)		; $7597
	or a			; $7598
	ld hl,@positionList1		; $7599
	jr z,++			; $759c
	ld hl,@positionList2		; $759e
	ld e,Interaction.oamFlags		; $75a1
	ld a,$04		; $75a3
	ld (de),a		; $75a5
++
	call getRandomNumber		; $75a6
	and $0f			; $75a9
	rst_addDoubleIndex			; $75ab
	ldi a,(hl)		; $75ac
	ld e,Interaction.yh		; $75ad
	ld (de),a		; $75af
	cpl			; $75b0
	inc a			; $75b1
	sub $08			; $75b2
	ld e,Interaction.zh		; $75b4
	ld (de),a		; $75b6
	ldi a,(hl)		; $75b7
	ld e,Interaction.xh		; $75b8
	ld (de),a		; $75ba
	ret			; $75bb

@positionList1:
	.db $50 $18
	.db $60 $18
	.db $70 $18
	.db $48 $20
	.db $50 $28
	.db $70 $28
	.db $40 $38
	.db $60 $38
	.db $6c $38
	.db $78 $38
	.db $50 $48
	.db $70 $48
	.db $48 $50
	.db $50 $58
	.db $60 $58
	.db $70 $58

@positionList2:
	.db $50 $38
	.db $60 $38
	.db $70 $38
	.db $48 $40
	.db $50 $48
	.db $70 $48
	.db $40 $58
	.db $60 $58
	.db $6c $88
	.db $78 $88
	.db $50 $98
	.db $70 $98
	.db $48 $a0
	.db $50 $a8
	.db $60 $a8
	.db $70 $a8


; ==============================================================================
; INTERACID_TWINROVA
;
; Variables:
;   var3a: Index for "loadAngleAndCounterPreset" function
; ==============================================================================
interactionCode93:
	ld e,Interaction.state		; $75fc
	ld a,(de)		; $75fe
	rst_jumpTable			; $75ff
	.dw @state0
	.dw _twinrova_state1

@state0:
	ld e,Interaction.subid		; $7604
	ld a,(de)		; $7606
	cp $02			; $7607
	jr nc,@subid2AndUp		; $7609

@subid0Or1:
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $760b
	cp $08			; $760e
	ret nz			; $7610
	call _twinrova_loadGfx		; $7611
	jr ++			; $7614

@subid2AndUp:
	cp $06			; $7616
	call nz,interactionLoadExtraGraphics		; $7618
++
	call interactionIncState		; $761b
	call interactionInitGraphics		; $761e
	call objectSetVisiblec1		; $7621
	ld a,>TX_2800		; $7624
	call interactionSetHighTextIndex		; $7626
	ld e,Interaction.subid		; $7629
	ld a,(de)		; $762b
	rst_jumpTable			; $762c
	.dw _twinrova_initSubid00
	.dw _twinrova_initOtherHalf
	.dw _twinrova_initSubid02
	.dw _twinrova_initOtherHalf
	.dw _twinrova_initSubid04
	.dw _twinrova_initOtherHalf
	.dw _twinrova_initSubid06
	.dw _twinrova_initOtherHalf

;;
; @addr{763d}
_twinrova_loadGfx:
	ld hl,wLoadedObjectGfx+10		; $763d
	ld b,$03		; $7640
	ld a,OBJGFXH_2c		; $7642
--
	ldi (hl),a		; $7644
	inc a			; $7645
	ld (hl),$01		; $7646
	inc l			; $7648
	dec b			; $7649
	jr nz,--		; $764a
	push de			; $764c
	call reloadObjectGfx		; $764d
	pop de			; $7650
	ret			; $7651

_twinrova_initSubid06:
	ld h,d			; $7652
	ld l,Interaction.var3a		; $7653
	ld (hl),$00		; $7655
	call _twinrova_loadScript		; $7657
	ld bc,$4234		; $765a
	jr _twinrova_genericInitialize		; $765d

_twinrova_initSubid02:
	ld h,d			; $765f
	ld l,Interaction.var3a		; $7660
	ld (hl),$04		; $7662
	ld l,Interaction.var38		; $7664
	ld (hl),$02		; $7666
	call objectSetInvisible		; $7668
	ld bc,$3850		; $766b
	jr _twinrova_genericInitialize		; $766e

_twinrova_initSubid04:
	ld h,d			; $7670
	ld l,Interaction.var38		; $7671
	ld (hl),$1e		; $7673

_twinrova_initSubid00:
	ld h,d			; $7675
	ld l,Interaction.var3a		; $7676
	ld (hl),$00		; $7678
	ld bc,$f888		; $767a

_twinrova_genericInitialize:
	call interactionSetPosition		; $767d
	call interactionSetAlwaysUpdateBit		; $7680
	ld l,Interaction.oamFlags		; $7683
	ld (hl),$02		; $7685
	ld l,Interaction.speed		; $7687
	ld (hl),SPEED_200		; $7689
	ld l,Interaction.zh		; $768b
	ld (hl),-$08		; $768d

	; Spawn the other half ([subid]+1)
	call getFreeInteractionSlot		; $768f
	jr nz,++		; $7692
	ld (hl),INTERACID_TWINROVA		; $7694
	inc l			; $7696
	ld e,l			; $7697
	ld a,(de)		; $7698
	inc a			; $7699
	ld (hl),a		; $769a
	ld l,Interaction.relatedObj1		; $769b
	ld (hl),Interaction.start		; $769d
	inc l			; $769f
	ld (hl),d		; $76a0
++
	call _twinrova_loadAngleAndCounterPreset		; $76a1
	call _twinrova_updateDirectionFromAngle		; $76a4
	ld a,SND_BEAM2		; $76a7
	call playSound		; $76a9
	jpab scriptHlp.objectWritePositionTocfd5		; $76ac

;;
; @addr{76b4}
_twinrova_loadAngleAndCounterPreset:
	ld e,Interaction.var3a		; $76b4
	ld a,(de)		; $76b6
	ld b,a			; $76b7

;;
; Loads preset values for angle and counter1 variables for an interaction. The values it
; loads depends on parameter 'b' (the preset index) and 'Interaction.counter2' (the index
; in the preset to use).
;
; Generally used to make an object move around in circular-ish patterns?
;
; @param	b	Preset to use
; @param[out]	b	Zero if end of data reached; nonzero otherwise.
; @addr{76b8}
loadAngleAndCounterPreset:
	ld a,b			; $76b8
	ld hl,_presetInteractionAnglesAndCounters		; $76b9
	rst_addDoubleIndex			; $76bc
	ldi a,(hl)		; $76bd
	ld h,(hl)		; $76be
	ld l,a			; $76bf

	ld e,Interaction.counter2		; $76c0
	ld a,(de)		; $76c2
	rst_addDoubleIndex			; $76c3

	ldi a,(hl)		; $76c4
	ld e,Interaction.angle		; $76c5
	ld (de),a		; $76c7
	ld a,(hl)		; $76c8
	or a			; $76c9
	ld b,a			; $76ca
	ret z			; $76cb

	ld h,d			; $76cc
	ld l,Interaction.counter1		; $76cd
	ldi (hl),a		; $76cf
	inc (hl) ; [counter2]++
	or $01			; $76d1
	ret			; $76d3

;;
; @addr{76d4}
_twinrova_updateDirectionFromAngle:
	ld e,Interaction.angle		; $76d4
	call convertAngleDeToDirection		; $76d6
	and $03			; $76d9
	ld l,Interaction.direction		; $76db
	cp (hl)			; $76dd
	ret z			; $76de
	ld (hl),a		; $76df
	jp interactionSetAnimation		; $76e0


; Initialize odd subids (the half of twinrova that just follows along)
_twinrova_initOtherHalf:
	call interactionSetAlwaysUpdateBit		; $76e3
	ld l,Interaction.oamFlags		; $76e6
	ld (hl),$01		; $76e8

	; Copy position & stuff from other half, inverted if necessary
	ld a,Object.enabled		; $76ea
	call objectGetRelatedObject1Var		; $76ec

;;
; @param	h	Object to copy visiblility, direction, position from
; @addr{76ef}
_twinrova_takeInvertedPositionFromObject:
	ld l,Interaction.visible		; $76ef
	ld e,l			; $76f1
	ld a,(hl)		; $76f2
	ld (de),a		; $76f3

	call objectTakePosition		; $76f4
	ld l,Interaction.xh		; $76f7
	ld b,(hl)		; $76f9
	ld a,$50		; $76fa
	sub b			; $76fc
	add $50			; $76fd
	ld e,Interaction.xh		; $76ff
	ld (de),a		; $7701

	ld l,Interaction.direction		; $7702
	ld a,(hl)		; $7704
	ld b,a			; $7705
	and $01			; $7706
	jr z,++			; $7708

	ld a,b			; $770a
	ld b,$01		; $770b
	cp $03			; $770d
	jr z,++			; $770f
	ld b,$03		; $7711
++
	ld a,b			; $7713
	ld h,d			; $7714
	ld l,Interaction.direction		; $7715
	cp (hl)			; $7717
	ret z			; $7718
	ld (hl),a		; $7719
	jp interactionSetAnimation		; $771a


; This data contains "presets" for an interacton's angle and counter1.
_presetInteractionAnglesAndCounters:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3
	.dw @data4
	.dw @data5

; Data format:
;   b0: Value for Interaction.angle
;   b1: Value for Interaction.counter1 (or $00 for end)

@data0: ; Used by Twinrova
	.db $11 $28
	.db $12 $10
	.db $13 $07
	.db $15 $05
	.db $17 $04
	.db $19 $04
	.db $1a $05
	.db $1d $07
	.db $1f $12
	.db $00 $00

@data1:
@data5:
	.db $03 $06
	.db $04 $06
	.db $06 $06
	.db $07 $06
	.db $08 $04
	.db $09 $06
	.db $0a $06
	.db $0c $04
	.db $0e $04
	.db $0f $04
	.db $10 $04
	.db $11 $04
	.db $13 $06
	.db $14 $0c
	.db $15 $30
	.db $00 $00

@data2: ; Ralph spinning his sword in credits cutscene
	.db $1a $12
	.db $1e $12
	.db $02 $12
	.db $06 $12
	.db $0a $12
	.db $0e $12
	.db $12 $12
	.db $16 $12
	.db $16 $12
	.db $12 $12
	.db $0e $12
	.db $0a $12
	.db $04 $12
	.db $02 $12
	.db $1e $10
	.db $1a $04
	.db $00 $00

@data3: ; INTERACID_RAFTWRECK_CUTSCENE_HELPER
	.db $15 $0c
	.db $16 $0c
	.db $17 $12
	.db $18 $14
	.db $19 $14
	.db $1a $20
	.db $00 $00

@data4: ; Used by Twinrova
	.db $0e $03
	.db $0c $03
	.db $0a $03
	.db $08 $03
	.db $06 $03
	.db $04 $03
	.db $02 $03
	.db $00 $03
	.db $1e $06
	.db $1c $06
	.db $1a $06
	.db $18 $06
	.db $16 $06
	.db $14 $06
	.db $12 $06
	.db $0f $08
	.db $00 $00


_twinrova_state1:
	ld e,Interaction.subid		; $77af
	ld a,(de)		; $77b1
	rst_jumpTable			; $77b2
	.dw @runSubid00
	.dw @runOtherHalf
	.dw @runSubid02
	.dw @runOtherHalf
	.dw @runSubid04
	.dw @runOtherHalf
	.dw @runSubid06
	.dw @runOtherHalf

@runSubid00:
	ld e,Interaction.state2		; $77c3
	ld a,(de)		; $77c5
	rst_jumpTable			; $77c6
	.dw @subid00State0
	.dw @subid00State1
	.dw @subid00State2

@subid00State0:
	callab scriptHlp.objectWritePositionTocfd5		; $77cd
	call interactionAnimate		; $77d5
	call objectApplySpeed		; $77d8
	call interactionDecCounter1		; $77db
	call z,_twinrova_loadAngleAndCounterPreset		; $77de
	jp nz,_twinrova_updateDirectionFromAngle		; $77e1
	call interactionIncState2		; $77e4
	jp _twinrova_loadScript		; $77e7

@subid00State1:
	call interactionAnimate		; $77ea
	call objectOscillateZ		; $77ed
	call interactionRunScript		; $77f0
	ret nc			; $77f3

	ld a,SND_BEAM2		; $77f4
	call playSound		; $77f6
	callab scriptHlp.objectWritePositionTocfd5		; $77f9
	call interactionIncState2		; $7801
	ld l,Interaction.counter2		; $7804
	ld (hl),$00		; $7806
	ld l,Interaction.var3a		; $7808
	inc (hl)		; $780a
	jp _twinrova_loadAngleAndCounterPreset		; $780b

@subid00State2:
	callab scriptHlp.objectWritePositionTocfd5		; $780e
	call interactionAnimate		; $7816
	call objectApplySpeed		; $7819
	call interactionDecCounter1		; $781c
	call z,_twinrova_loadAngleAndCounterPreset		; $781f
	jp nz,_twinrova_updateDirectionFromAngle		; $7822
	ld a,$09		; $7825
	ld (wTmpcfc0.genericCutscene.cfd0),a		; $7827
	jp interactionDelete		; $782a

@runOtherHalf:
	call interactionAnimate		; $782d
	ld a,Object.enabled		; $7830
	call objectGetRelatedObject1Var		; $7832
	ld a,(hl)		; $7835
	or a			; $7836
	jp z,interactionDelete		; $7837
	jp _twinrova_takeInvertedPositionFromObject		; $783a

@runSubid02:
@runSubid04:
	ld e,Interaction.state2		; $783d
	ld a,(de)		; $783f
	rst_jumpTable			; $7840
	.dw @subid02State0
	.dw @subid00State0
	.dw @subid00State1
	.dw @subid00State2

@subid02State0:
	ld h,d			; $7849
	ld l,Interaction.var38		; $784a
	dec (hl)		; $784c
	ret nz			; $784d
	call objectSetVisiblec1		; $784e
	jp interactionIncState2		; $7851

@runSubid06:
	ld e,Interaction.state2		; $7854
	ld a,(de)		; $7856
	rst_jumpTable			; $7857
	.dw @subid00State1
	.dw @subid00State2

;;
; @addr{785c}
_twinrova_loadScript:
	ld e,Interaction.subid		; $785c
	ld a,(de)		; $785e
	ld hl,@scriptTable		; $785f
	rst_addDoubleIndex			; $7862
	ldi a,(hl)		; $7863
	ld h,(hl)		; $7864
	ld l,a			; $7865
	jp interactionSetScript		; $7866

@scriptTable:
	.dw twinrova_subid00Script
	.dw stubScript
	.dw twinrova_subid02Script
	.dw stubScript
	.dw twinrova_subid04Script
	.dw stubScript
	.dw twinrova_subid06Script

;;
; Gets a position stored in $cfd5/$cfd6?
;
; @param[out]	bc	Position
; @addr{7877}
func_0a_7877:
	ld hl,wTmpcfc0.genericCutscene.cfd5		; $7877
	ld b,(hl)		; $787a
	inc l			; $787b
	ld c,(hl)		; $787c
	ret			; $787d


; ==============================================================================
; INTERACID_PATCH
;
; Variables:
;   var38: 0 if Link has the broken tuni nut; 1 otherwise (upstairs script)
;   var39: Set by another object (subid 3) when all beetles are killed
; ==============================================================================
interactionCode94:
	ld e,Interaction.subid		; $787e
	ld a,(de)		; $7880
	ld e,Interaction.state		; $7881
	rst_jumpTable			; $7883
	.dw _patch_subid00
	.dw _patch_subid01
	.dw _patch_subid02
	.dw _patch_subid03
	.dw _patch_subid04
	.dw _patch_subid05
	.dw _patch_subid06
	.dw _patch_subid07


; Patch in the upstairs room
_patch_subid00:
	ld e,Interaction.state		; $7894
	ld a,(de)		; $7896
	rst_jumpTable			; $7897
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; If tuni nut's state is 1, set it back to 0 (put it back in Link's inventory if
	; the tuni nut game failed)
	ld hl,wTuniNutState		; $789e
	ld a,(hl)		; $78a1
	dec a			; $78a2
	jr nz,+			; $78a3
	ld (hl),a		; $78a5
+
	; Similarly, revert the trade item back to broken sword if failed the minigame
	ld hl,wTradeItem		; $78a6
	ld a,(hl)		; $78a9
	cp TRADEITEM_DOING_PATCH_GAME			; $78aa
	jr nz,+			; $78ac
	ld (hl),TRADEITEM_BROKEN_SWORD		; $78ae
+
	ld a,(wTmpcfc0.patchMinigame.patchDownstairs)		; $78b0
	dec a			; $78b3
	jp z,interactionDelete		; $78b4

	call interactionInitGraphics		; $78b7
	call interactionSetAlwaysUpdateBit		; $78ba
	call interactionIncState		; $78bd

	ld l,Interaction.speed		; $78c0
	ld (hl),SPEED_100		; $78c2

	call objectSetVisiblec2		; $78c4
	ld a,GLOBALFLAG_PATCH_REPAIRED_EVERYTHING		; $78c7
	call checkGlobalFlag		; $78c9
	ld hl,patch_upstairsRepairedEverythingScript		; $78cc
	jr nz,@setScript	; $78cf

	ld a,<TX_5813		; $78d1
	ld (wTmpcfc0.patchMinigame.itemNameText),a		; $78d3
	ld a,$01		; $78d6
	ld (wTmpcfc0.patchMinigame.fixingSword),a		; $78d8

	ld a,TREASURE_TRADEITEM		; $78db
	call checkTreasureObtained		; $78dd
	jr nc,@notRepairingSword	; $78e0
	cp TRADEITEM_BROKEN_SWORD			; $78e2
	jr nz,@notRepairingSword	; $78e4

	ld a,TREASURE_SWORD		; $78e6
	call checkTreasureObtained		; $78e8
	and $01			; $78eb
	ld (wTmpcfc0.patchMinigame.swordLevel),a		; $78ed
	ld hl,patch_upstairsRepairSwordScript		; $78f0
	jr @setScript		; $78f3

@notRepairingSword:
	ld a,<TX_5812		; $78f5
	ld (wTmpcfc0.patchMinigame.itemNameText),a		; $78f7
	xor a			; $78fa
	ld (wTmpcfc0.patchMinigame.fixingSword),a		; $78fb

	; Set var38 to 1 if Link doesn't have the broken tuni nut
	ld a,TREASURE_TUNI_NUT		; $78fe
	call checkTreasureObtained		; $7900
	ld hl,patch_upstairsRepairTuniNutScript		; $7903
	jr nc,++		; $7906
	or a			; $7908
	jr z,@setScript	; $7909
++
	ld e,Interaction.var38		; $790b
	ld a,$01		; $790d
	ld (de),a		; $790f
@setScript:
	jp interactionSetScript		; $7910

@state1:
	ld c,$20		; $7913
	call objectUpdateSpeedZ_paramC		; $7915
	ret nz			; $7918
	call interactionRunScript		; $7919
	jp nc,npcFaceLinkAndAnimate		; $791c

	; Done the script; now load another script to move downstairs

	call interactionIncState		; $791f
	ld hl,patch_upstairsMoveToStaircaseScript		; $7922
	jp interactionSetScript		; $7925


@state2:
	call interactionRunScript		; $7928
	jp nc,interactionAnimate		; $792b

	; Done moving downstairs; restore control to Link
	xor a			; $792e
	ld (wDisabledObjects),a		; $792f
	ld (wMenuDisabled),a		; $7932
	inc a			; $7935
	ld (wTmpcfc0.patchMinigame.patchDownstairs),a		; $7936
	jp interactionDelete		; $7939


; Patch in his minigame room
_patch_subid01:
	ld a,(de)		; $793c
	rst_jumpTable			; $793d
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call interactionInitGraphics		; $794c
	call interactionSetAlwaysUpdateBit		; $794f
	call interactionIncState		; $7952
	call objectSetVisiblec2		; $7955

	ld hl,wTmpcfc0.patchMinigame.patchDownstairs		; $7958
	ldi a,(hl)		; $795b
	or a			; $795c
	jp z,interactionDelete		; $795d

	ldi a,(hl) ; a = [wTmpcfc0.patchMinigame.wonMinigame]
	or a			; $7961
	jp nz,@alreadyWonMinigame		; $7962

	xor a			; $7965
	ldi (hl),a ; [wTmpcfc0.patchMinigame.gameStarted]
	ldi (hl),a ; [wTmpcfc0.patchMinigame.failedGame]
	ld (hl),a  ; [wTmpcfc0.patchMinigame.screenFadedOut]
	inc a			; $7969
	ld (wDiggingUpEnemiesForbidden),a		; $796a
	ld hl,patch_downstairsScript		; $796d
	jp interactionSetScript		; $7970

; Waiting for Link to talk to Patch to start the minigame
@state1:
	ld a,(wPaletteThread_mode)		; $7973
	or a			; $7976
	ret nz			; $7977
	call interactionRunScript		; $7978
	jp nc,npcFaceLinkAndAnimate		; $797b

	; Script ended, meaning the minigame will begin now

	ld a,$01		; $797e
	ld (wTmpcfc0.patchMinigame.gameStarted),a		; $7980

	ld a,SND_WHISTLE		; $7983
	call playSound		; $7985
	ld a,MUS_MINIBOSS		; $7988
	ld (wActiveMusic),a		; $798a
	call playSound		; $798d

	; Spawn subid 3, a "manager" for the beetle enemies.
	ldbc INTERACID_PATCH, $03		; $7990
	call objectCreateInteraction		; $7993
	ret nz			; $7996
	ld l,Interaction.relatedObj1		; $7997
	ld a,Interaction.start		; $7999
	ldi (hl),a		; $799b
	ld (hl),d		; $799c

	; Update the tuni nut or trade item state
	ld a,(wTmpcfc0.patchMinigame.fixingSword)		; $799d
	or a			; $79a0
	ld hl,wTuniNutState		; $79a1
	ld a,$01		; $79a4
	jr z,++			; $79a6
	ld hl,wTradeItem		; $79a8
	ld a,TRADEITEM_DOING_PATCH_GAME		; $79ab
++
	ld (hl),a		; $79ad

	ld a,$06		; $79ae
	call interactionSetAnimation		; $79b0
	call interactionIncState		; $79b3
	ld l,Interaction.var39		; $79b6
	ld (hl),$00		; $79b8
	ld hl,patch_duringMinigameScript		; $79ba
	call interactionSetScript		; $79bd

; The minigame is running; wait for all enemies to be killed?
@state2:
	ld a,(wTmpcfc0.patchMinigame.failedGame)		; $79c0
	or a			; $79c3
	jr z,@gameRunning	; $79c4

	; Failed minigame

	call checkLinkCollisionsEnabled		; $79c6
	ret nc			; $79c9

	ld a,DISABLE_LINK		; $79ca
	ld (wDisabledObjects),a		; $79cc
	ld e,Interaction.state		; $79cf
	ld a,$05		; $79d1
	ld (de),a		; $79d3
	dec a			; $79d4
	jp fadeoutToWhiteWithDelay		; $79d5

@gameRunning:
	; Subid 3 sets var39 to nonzero when all beetles are killed; wait for the signal.
	ld e,Interaction.var39		; $79d8
	ld a,(de)		; $79da
	or a			; $79db
	jr z,@runScriptAndAnimate	; $79dc

	; Link won the game.
	xor a			; $79de
	ld (wTmpcfc0.patchMinigame.gameStarted),a		; $79df
	ld (w1Link.knockbackCounter),a		; $79e2
	call checkLinkVulnerable		; $79e5
	ret nc			; $79e8

	ld a,DISABLE_ALL_BUT_INTERACTIONS		; $79e9
	ld (wDisabledObjects),a		; $79eb
	ld (wMenuDisabled),a		; $79ee

	; Spawn the repaired item
	ld a,(wTmpcfc0.patchMinigame.fixingSword)		; $79f1
	add $06			; $79f4
	ld c,a			; $79f6
	ld b,INTERACID_PATCH		; $79f7
	call objectCreateInteraction		; $79f9
	ret nz			; $79fc
	ld l,Interaction.relatedObj1		; $79fd
	ld a,Interaction.start		; $79ff
	ldi (hl),a		; $7a01
	ld (hl),d		; $7a02

	call interactionIncState		; $7a03
	ld hl,patch_linkWonMinigameScript		; $7a06
	call interactionSetScript		; $7a09
	ld a,SND_SOLVEPUZZLE_2		; $7a0c
	call playSound		; $7a0e
	ld a,(wActiveMusic2)		; $7a11
	ld (wActiveMusic),a		; $7a14
	jp playSound		; $7a17

@runScriptAndAnimate:
	call interactionRunScript		; $7a1a
	jp interactionAnimateAsNpc		; $7a1d

; Just won the game
@state3:
	ld a,(wPaletteThread_mode)		; $7a20
	or a			; $7a23
	jr nz,+			; $7a24
	ld a,(wTextIsActive)		; $7a26
	or a			; $7a29
	jr z,++			; $7a2a
+
	jp interactionAnimate		; $7a2c
++
	call interactionRunScript		; $7a2f
	jr nc,@faceLinkAndAnimate	; $7a32

	ld a,(wTmpcfc0.patchMinigame.fixingSword)		; $7a34
	or a			; $7a37
	ld a,GLOBALFLAG_PATCH_REPAIRED_EVERYTHING		; $7a38
	call nz,setGlobalFlag		; $7a3a

@alreadyWonMinigame:
	ld e,Interaction.state		; $7a3d
	ld a,$04		; $7a3f
	ld (de),a		; $7a41
	ld hl,patch_downstairsAfterBeatingMinigameScript		; $7a42
	jp interactionSetScript		; $7a45

; NPC after winning the game
@state4:
	call interactionRunScript		; $7a48
@faceLinkAndAnimate:
	jp npcFaceLinkAndAnimate		; $7a4b

; Failed the game
@state5:
	ld a,(wPaletteThread_mode)		; $7a4e
	or a			; $7a51
	ret nz			; $7a52

	; Delete all the enemies
	ldhl FIRST_ENEMY_INDEX, Enemy.id		; $7a53
@nextEnemy:
	ld a,(hl)		; $7a56
	cp ENEMYID_HARMLESS_HARDHAT_BEETLE			; $7a57
	jr nz,++		; $7a59
	push hl			; $7a5b
	ld d,h			; $7a5c
	ld e,Enemy.start		; $7a5d
	call objectDelete_de		; $7a5f
	pop hl			; $7a62
++
	inc h			; $7a63
	ld a,h			; $7a64
	cp LAST_ENEMY_INDEX+1			; $7a65
	jr c,@nextEnemy	; $7a67

	ldh a,(<hActiveObject)	; $7a69
	ld d,a			; $7a6b

	; Give back the broken item
	ld a,(wTmpcfc0.patchMinigame.fixingSword)		; $7a6c
	or a			; $7a6f
	ld hl,wTuniNutState		; $7a70
	jr z,+			; $7a73
	ld hl,wTradeItem		; $7a75
	ld a,TRADEITEM_BROKEN_SWORD		; $7a78
+
	ld (hl),a		; $7a7a

	call interactionIncState		; $7a7b
	ld a,(wActiveMusic2)		; $7a7e
	ld (wActiveMusic),a		; $7a81
	call playSound		; $7a84
	ld hl,patch_linkFailedMinigameScript		; $7a87
	jp interactionSetScript		; $7a8a

@state6:
	call interactionRunScript		; $7a8d
	jr nc,@faceLinkAndAnimate	; $7a90
	ld e,Interaction.state		; $7a92
	xor a			; $7a94
	ld (de),a		; $7a95
	jr @faceLinkAndAnimate		; $7a96


; The minecart in Patch's minigame
_patch_subid02:
	ld a,(wActiveTriggers)		; $7a98
	ld (wSwitchState),a		; $7a9b
	ld e,Interaction.state		; $7a9e
	ld a,(de)		; $7aa0
	rst_jumpTable			; $7aa1
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	; Spawn the object that will toggle the minecart track when the button is down
	call getFreeInteractionSlot		; $7aaa
	ret nz			; $7aad
	ld (hl),INTERACID_SWITCH_TILE_TOGGLER		; $7aae
	inc l			; $7ab0
	ld (hl),$01		; $7ab1
	ld l,Interaction.yh		; $7ab3
	ld (hl),$05		; $7ab5
	ld l,Interaction.xh		; $7ab7
	ld (hl),$0b		; $7ab9

	call interactionInitGraphics		; $7abb
	call interactionIncState		; $7abe
	ld l,Interaction.angle		; $7ac1
	ld (hl),ANGLE_RIGHT		; $7ac3
	ld l,Interaction.speed		; $7ac5
	ld (hl),SPEED_100		; $7ac7
	ld a,$06		; $7ac9
	call objectSetCollideRadius		; $7acb
	jp objectSetVisible82		; $7ace

; Wait for game to start
@state1:
	ld a,(wTmpcfc0.patchMinigame.gameStarted)		; $7ad1
	or a			; $7ad4
	ret z			; $7ad5

	; Spawn the broken item sprite (INTERACID_PATCH subid 4 or 5)
	call getFreeInteractionSlot		; $7ad6
	ret nz			; $7ad9
	ld (hl),INTERACID_PATCH		; $7ada
	inc l			; $7adc
	ld a,(wTmpcfc0.patchMinigame.fixingSword)		; $7add
	add $04			; $7ae0
	ld (hl),a		; $7ae2
	ld l,Interaction.relatedObj1		; $7ae3
	ld a,Interaction.start		; $7ae5
	ldi (hl),a		; $7ae7
	ld (hl),d		; $7ae8
	jp interactionIncState		; $7ae9

; Game is running
@state2:
	ld hl,wTmpcfc0.patchMinigame.gameStarted		; $7aec
	ldi a,(hl)		; $7aef
	or a			; $7af0
	jr z,@incState		; $7af1

	; Check if the game is failed; if so, wait for the screen to fade out.
	ldi a,(hl) ; a = [wTmpcfc0.patchMinigame.failedGame]
	or a			; $7af4
	jr z,@gameStillGoing	; $7af5
	ld a,(hl)  ; a = [wTmpcfc0.patchMinigame.screenFadedOut]
	or a			; $7af8
	ret z			; $7af9

	; Reset position
	ld h,d			; $7afa
	ld l,Interaction.yh		; $7afb
	ld (hl),$08		; $7afd
	ld l,Interaction.xh		; $7aff
	ld (hl),$68		; $7b01
@incState:
	jp interactionIncState		; $7b03

@gameStillGoing:
	call objectApplySpeed		; $7b06
	call interactionAnimate		; $7b09

	; Check if it's reached the center of a new tile
	ld h,d			; $7b0c
	ld l,Interaction.yh		; $7b0d
	ldi a,(hl)		; $7b0f
	and $0f			; $7b10
	cp $08			; $7b12
	ret nz			; $7b14
	inc l			; $7b15
	ld a,(hl)		; $7b16
	and $0f			; $7b17
	cp $08			; $7b19
	ret nz			; $7b1b

	; Determine the new angle to move in
	call objectGetTileAtPosition		; $7b1c
	ld e,a			; $7b1f
	ld a,l			; $7b20
	cp $15			; $7b21
	ld a,$08		; $7b23
	jr z,+			; $7b25
	ld hl,@trackTable		; $7b27
	call lookupKey		; $7b2a
	ret nc			; $7b2d
+
	ld e,Interaction.angle		; $7b2e
	ld (de),a		; $7b30
	bit 3,a			; $7b31
	ld a,$07		; $7b33
	jr z,+			; $7b35
	inc a			; $7b37
+
	jp interactionSetAnimation		; $7b38

@trackTable:
	.db TILEINDEX_TRACK_TR, ANGLE_DOWN
	.db TILEINDEX_TRACK_BR, ANGLE_LEFT
	.db TILEINDEX_TRACK_BL, ANGLE_UP
	.db TILEINDEX_TRACK_TL, ANGLE_RIGHT
	.db $00

; Stop moving until the game starts up again
@state3:
	ld a,(wTmpcfc0.patchMinigame.gameStarted)		; $7b44
	or a			; $7b47
	ret nz			; $7b48
	inc a			; $7b49
	ld (de),a		; $7b4a
	ret			; $7b4b


; Subid 3 = Beetle "manager"; spawns them and check when they're killed.
;
; Variables:
;   counter1: Number of beetles to be killed (starts at 4 or 8)
;   var3a: Set to 1 when another beetle should be spawned
;   var3b: Number of extra beetles spawned so far
_patch_subid03:
	ld e,Interaction.state		; $7b4c
	ld a,(de)		; $7b4e
	rst_jumpTable			; $7b4f
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	callab interactionBank08.clearFallDownHoleEventBuffer		; $7b56
	call interactionIncState		; $7b5e
	ld l,Interaction.counter1		; $7b61
	ld (hl),60		; $7b63
	ret			; $7b65

@state1:
	call interactionDecCounter1		; $7b66
	ret nz			; $7b69

	; Determine total number of beetles (4 or 8) and write that to counter1
	ld a,(wTmpcfc0.patchMinigame.fixingSword)		; $7b6a
	add a			; $7b6d
	add a			; $7b6e
	add $04			; $7b6f
	ld (hl),a		; $7b71
	call interactionIncState		; $7b72

	ld c,$44		; $7b75
	call @spawnBeetle		; $7b77
	ld c,$4a		; $7b7a
	call @spawnBeetle		; $7b7c
	ld c,$75		; $7b7f
	call @spawnBeetle		; $7b81
	ld c,$78		; $7b84
@spawnBeetle:
	call getFreeInteractionSlot		; $7b86
	ret nz			; $7b89
	ld (hl),INTERACID_PUFF		; $7b8a
	ld l,Interaction.yh		; $7b8c
	call setShortPosition_paramC		; $7b8e
	call getFreeEnemySlot		; $7b91
	ret nz			; $7b94
	ld (hl),ENEMYID_HARMLESS_HARDHAT_BEETLE		; $7b95
	ld l,Enemy.yh		; $7b97
	call setShortPosition_paramC		; $7b99
	xor a			; $7b9c
	ret			; $7b9d

@state2:
	ld a,(wTmpcfc0.patchMinigame.failedGame)		; $7b9e
	or a			; $7ba1
	jr nz,@delete	; $7ba2

	; Check which objects have fallen into holes
	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8+1		; $7ba4
	ld b,$04		; $7ba7
---
	ldi a,(hl)		; $7ba9
	cp ENEMYID_HARMLESS_HARDHAT_BEETLE			; $7baa
	jr nz,@nextFallenObject	; $7bac

	push hl			; $7bae
	call interactionDecCounter1		; $7baf
	jr z,@allBeetlesKilled			; $7bb2
	ld a,(hl)		; $7bb4
	cp $04			; $7bb5
	jr c,++			; $7bb7
	ld l,Interaction.var3a		; $7bb9
	inc (hl)		; $7bbb
++
	pop hl			; $7bbc

@nextFallenObject:
	inc l			; $7bbd
	dec b			; $7bbe
	jr nz,---		; $7bbf

	ld e,Interaction.var3a		; $7bc1
	ld a,(de)		; $7bc3
	or a			; $7bc4
	jr z,++			; $7bc5

	; Killed one of the first 4 beetles; spawn another.
	ld e,Interaction.var3b		; $7bc7
	ld a,(de)		; $7bc9
	ld hl,@extraBeetlePositions		; $7bca
	rst_addAToHl			; $7bcd
	ld c,(hl)		; $7bce
	call @spawnBeetle		; $7bcf
	jr nz,++		; $7bd2
	ld h,d			; $7bd4
	ld l,Interaction.var3a		; $7bd5
	dec (hl)		; $7bd7
	inc l			; $7bd8
	inc (hl)		; $7bd9
++
	jpab interactionBank08.clearFallDownHoleEventBuffer		; $7bda

@allBeetlesKilled:
	; Set parent object's "var39" to indicate that the game's over
	pop hl			; $7be2
	ld a,Object.var39		; $7be3
	call objectGetRelatedObject1Var		; $7be5
	inc (hl)		; $7be8
@delete:
	jp interactionDelete		; $7be9

@extraBeetlePositions:
	.db $4a $57 $75 $78



; Broken tuni nut (4) or sword (5) sprite
_patch_subid04:
_patch_subid05:
	ld e,Interaction.state		; $7bf0
	ld a,(de)		; $7bf2
	rst_jumpTable			; $7bf3
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics		; $7bfa
	call interactionIncState		; $7bfd

	ld l,Interaction.yh		; $7c00
	ld (hl),$18		; $7c02
	ld l,Interaction.xh		; $7c04
	ld (hl),$78		; $7c06
	ld bc,$0606		; $7c08
	call objectSetCollideRadii		; $7c0b
	jp objectSetVisible83		; $7c0e

@state1:
	; When a "palette fade" occurs, assume the game's ended (go to state 2)
	ld a,(wPaletteThread_mode)		; $7c11
	or a			; $7c14
	jp nz,interactionIncState		; $7c15

	; Check if relatedObj1 (the minecart) has collided with it
	ld a,Object.start		; $7c18
	call objectGetRelatedObject1Var		; $7c1a
	call checkObjectsCollided		; $7c1d
	ret nc			; $7c20

	; Collision occured; game failed.
	ld a,$01		; $7c21
	ld (wTmpcfc0.patchMinigame.failedGame),a		; $7c23
	ld b,INTERACID_EXPLOSION		; $7c26
	call objectCreateInteractionWithSubid00		; $7c28
	ret nz			; $7c2b
	ld l,Interaction.var03		; $7c2c
	inc (hl)		; $7c2e
	ld l,Interaction.xh		; $7c2f
	ld a,(hl)		; $7c31
	sub $08			; $7c32
	ld (hl),a		; $7c34
	jp interactionIncState		; $7c35

@state2:
	ld a,(wTmpcfc0.patchMinigame.screenFadedOut)		; $7c38
	or a			; $7c3b
	ret z			; $7c3c
	jp interactionDelete		; $7c3d



; Fixed tuni nut (6) or sword (7) sprite
_patch_subid06:
_patch_subid07:
	call checkInteractionState		; $7c40
	jr z,@state0	; $7c43

@state1:
	call interactionDecCounter1		; $7c45
	ret nz			; $7c48
	jp interactionDelete		; $7c49

@state0:
	ld a,(wTmpcfc0.patchMinigame.wonMinigame)		; $7c4c
	or a			; $7c4f
	ret z			; $7c50

	call interactionInitGraphics		; $7c51
	call interactionIncState		; $7c54
	ld l,Interaction.counter1		; $7c57
	ld (hl),60		; $7c59

	; If this is the L3 sword, need to change the palette & animation
	ld l,Interaction.subid		; $7c5b
	ld a,(hl)		; $7c5d
	cp $06			; $7c5e
	jr z,@getPosition	; $7c60
	ld a,(wTmpcfc0.patchMinigame.swordLevel)		; $7c62
	or a			; $7c65
	jr nz,@getPosition	; $7c66

	ld l,Interaction.oamFlagsBackup		; $7c68
	ld a,$04		; $7c6a
	ldi (hl),a		; $7c6c
	ld (hl),a		; $7c6d
	ld a,$0c		; $7c6e
	call interactionSetAnimation		; $7c70

@getPosition:
	; Copy position from relatedObj1 (patch)
	ld a,Object.start		; $7c73
	call objectGetRelatedObject1Var		; $7c75
	ld bc,$f2f8		; $7c78
	call objectTakePositionWithOffset		; $7c7b
	jp objectSetVisible81		; $7c7e



; ==============================================================================
; INTERACID_BALL
; ==============================================================================
interactionCode95:
	ld e,Interaction.state		; $7c81
	ld a,(de)		; $7c83
	rst_jumpTable			; $7c84
	.dw @state0
	.dw @state1

@state0:
	call interactionIncState		; $7c89
	ld l,Interaction.speed		; $7c8c
	ld (hl),SPEED_200		; $7c8e
	call interactionInitGraphics		; $7c90
	jp objectSetVisible80		; $7c93

@state1:
	ld e,Interaction.state2		; $7c96
	ld a,(de)		; $7c98
	rst_jumpTable			; $7c99
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,($cfd3)		; $7ca0
	or a			; $7ca3
	ret z			; $7ca4
	call interactionIncState2		; $7ca5
	ld b,ANGLE_RIGHT		; $7ca8
	dec a			; $7caa
	jr z,+			; $7cab
	ld b,ANGLE_LEFT		; $7cad
+
	ld l,Interaction.angle		; $7caf
	ld (hl),b		; $7cb1
	ld l,Interaction.subid		; $7cb2
	ld (hl),a		; $7cb4
	cp $02			; $7cb5
	jr nz,++		; $7cb7
	ld bc,$5075		; $7cb9
	call interactionHSetPosition		; $7cbc
	ld l,Interaction.zh		; $7cbf
	ld (hl),-$06		; $7cc1
++
	ld bc,-$1c0		; $7cc3
	jp objectSetSpeedZ		; $7cc6

@substate1:
	call objectApplySpeed		; $7cc9
	ld c,$20		; $7ccc
	call objectUpdateSpeedZ_paramC		; $7cce
	ret nz			; $7cd1

	; Ball has landed

	ld e,Interaction.subid		; $7cd2
	ld a,(de)		; $7cd4
	cp $02			; $7cd5
	jr z,@subid2			; $7cd7

	dec a			; $7cd9
	ld bc,$4a3c		; $7cda
	jr z,+			; $7cdd
	ld c,$75		; $7cdf
+
	xor a			; $7ce1
	ld ($cfd3),a		; $7ce2
	ld e,Interaction.state2		; $7ce5
	ld (de),a		; $7ce7
	jp interactionSetPosition		; $7ce8

@subid2:
	; [speedZ] = -[speedZ]/2
	ld l,Interaction.speedZ+1		; $7ceb
	ldd a,(hl)		; $7ced
	srl a			; $7cee
	ld b,a			; $7cf0
	ld a,(hl)		; $7cf1
	rra			; $7cf2
	cpl			; $7cf3
	add $01			; $7cf4
	ldi (hl),a		; $7cf6
	ld a,b			; $7cf7
	cpl			; $7cf8
	adc $00			; $7cf9
	ldd (hl),a		; $7cfb

	; Go to substate 2 (stop doing anything) if the ball's Z speed has gone too low
	ld bc,$ff80		; $7cfc
	ldi a,(hl)		; $7cff
	ld h,(hl)		; $7d00
	ld l,a			; $7d01
	call compareHlToBc		; $7d02
	ret c			; $7d05
	jp interactionIncState2		; $7d06

@substate2:
	ret			; $7d09



; ==============================================================================
; INTERACID_MOBLIN
; ==============================================================================
interactionCode96:
	ld e,Interaction.subid		; $7d0a
	ld a,(de)		; $7d0c
	rst_jumpTable			; $7d0d
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	call checkInteractionState		; $7d12
	jr nz,@state1	; $7d15

@state0:
	call @initGraphicsAndLoadScript		; $7d17
@state1:
	call interactionRunScript		; $7d1a
	jp c,interactionDelete		; $7d1d

	ld e,Interaction.var3f		; $7d20
	ld a,(de)		; $7d22
	or a			; $7d23
	jr nz,+			; $7d24
	call interactionAnimate		; $7d26
+
	jp interactionPushLinkAwayAndUpdateDrawPriority		; $7d29

@initGraphics: ; unused
	call interactionInitGraphics		; $7d2c
	jp interactionIncState		; $7d2f

@initGraphicsAndLoadScript:
	call interactionInitGraphics		; $7d32
	ld e,$42		; $7d35
	ld a,(de)		; $7d37
	ld hl,@scriptTable		; $7d38
	rst_addDoubleIndex			; $7d3b
	ldi a,(hl)		; $7d3c
	ld h,(hl)		; $7d3d
	ld l,a			; $7d3e
	call interactionSetScript		; $7d3f
	jp interactionIncState		; $7d42

@scriptTable:
	.dw moblin_subid00Script
	.dw moblin_subid01Script


; ==============================================================================
; INTERACID_97
; ==============================================================================
interactionCode97:
	ld e,Interaction.subid		; $7d49
	ld a,(de)		; $7d4b
	rst_jumpTable			; $7d4c
	.dw _interaction97_subid00
	.dw _interaction97_subid01

_interaction97_subid00:
	call checkInteractionState		; $7d51
	jr z,@state0	; $7d54

@state1:
	call interactionDecCounter1		; $7d56
	jp z,interactionDelete		; $7d59

	inc l			; $7d5c
	dec (hl) ; [counter2]--
	ret nz			; $7d5e
	call getRandomNumber		; $7d5f
	and $03			; $7d62
	ld a,$03		; $7d64
	ld (hl),a		; $7d66

	call getRandomNumber_noPreserveVars		; $7d67
	and $1f			; $7d6a
	sub $10			; $7d6c
	ld c,a			; $7d6e
	call getRandomNumber		; $7d6f
	and $07			; $7d72
	sub $04			; $7d74
	ld b,a			; $7d76
	call getFreeInteractionSlot		; $7d77
	ret nz			; $7d7a
	ld (hl),INTERACID_PUFF		; $7d7b
	jp objectCopyPositionWithOffset		; $7d7d

@state0:
	call interactionIncState		; $7d80
	ld l,Interaction.counter1		; $7d83
	ld (hl),$6a		; $7d85
	inc l			; $7d87
	inc (hl)		; $7d88
	ret			; $7d89


_interaction97_subid01:
	call checkInteractionState		; $7d8a
	jr z,@state0	; $7d8d

@state1:
	call interactionDecCounter1		; $7d8f
	ret nz			; $7d92
	ld (hl),$12		; $7d93
	inc l			; $7d95
	dec (hl)		; $7d96
	jp z,interactionDelete		; $7d97

	call getRandomNumber_noPreserveVars		; $7d9a
	and $03			; $7d9d
	add $0c			; $7d9f
	ld b,a			; $7da1

@spawnBubble:
	add a			; $7da2
	add b			; $7da3
	ld hl,@positions		; $7da4
	rst_addAToHl			; $7da7
	ldi a,(hl)		; $7da8
	ld b,a			; $7da9
	ldi a,(hl)		; $7daa
	ld c,a			; $7dab
	ld e,(hl)		; $7dac
	call getFreePartSlot		; $7dad
	ret nz			; $7db0
	ld (hl),PARTID_16		; $7db1
	inc l			; $7db3
	ld (hl),e		; $7db4
	ld l,Part.yh		; $7db5
	ld (hl),b		; $7db7
	ld l,Part.xh		; $7db8
	ld (hl),c		; $7dba
	ret			; $7dbb

@state0:
	call interactionSetAlwaysUpdateBit		; $7dbc
	call interactionIncState		; $7dbf

	ld l,Interaction.counter1		; $7dc2
	ld (hl),30		; $7dc4
	inc l			; $7dc6
	ld (hl),$04 ; [counter2]

	ld b,$0c		; $7dc9
--
	push bc			; $7dcb
	ld a,b			; $7dcc
	dec b			; $7dcd
	dec a			; $7dce
	call @spawnBubble		; $7dcf
	pop bc			; $7dd2
	dec b			; $7dd3
	jr nz,--		; $7dd4
	ret			; $7dd6

; Data format:
;   b0: Y
;   b1: X
;   b2: Subid for PARTID_16
@positions:
	.db $40 $2f $00
	.db $42 $31 $00
	.db $40 $35 $01
	.db $3e $3a $00
	.db $42 $40 $00
	.db $42 $46 $00
	.db $40 $5d $01
	.db $3e $62 $00
	.db $40 $69 $01
	.db $40 $6c $01
	.db $42 $3f $00
	.db $40 $71 $00
	.db $3e $3c $01
	.db $3a $48 $01
	.db $3c $54 $01
	.db $3e $62 $01
