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
