; ==============================================================================
; INTERACID_MONKEY
;
; Variables:
;   var38/39: Copied to speedZ?
;   var3a:    Animation index?
; ==============================================================================
interactionCode39_body:
	ld e,Interaction.state		; $72e6
	ld a,(de)		; $72e8
	rst_jumpTable			; $72e9
	.dw @state0
	.dw _monkeyState1

@state0:
	ld a,$01		; $72ee
	ld (de),a		; $72f0

	ld a,>TX_5700		; $72f1
	call interactionSetHighTextIndex		; $72f3

	call interactionInitGraphics		; $72f6
	call objectSetVisiblec2		; $72f9
	call @initSubid		; $72fc

	ld e,Interaction.var03		; $72ff
	ld a,(de)		; $7301
	cp $09			; $7302
	ret z			; $7304

	ld e,Interaction.enabled		; $7305
	ld a,(de)		; $7307
	or a			; $7308
	jp nz,objectMarkSolidPosition		; $7309
	ret			; $730c

@initSubid:
	ld e,Interaction.subid		; $730d
	ld a,(de)		; $730f
	rst_jumpTable			; $7310
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init
	.dw @subid7Init

@subid0Init:
	ld a,$02		; $7321
	call interactionSetAnimation		; $7323

	ld hl,monkeySubid0Script		; $7326
	jp interactionSetScript		; $7329


@subid2Init:
	ld a,$02		; $732c
	ld e,Interaction.oamFlags		; $732e
	ld (de),a		; $7330
	ld a,$06		; $7331
	call interactionSetAnimation		; $7333
	jr ++			; $7336

@subid3Init:
	ld a,$07		; $7338
	call interactionSetAnimation		; $733a
++
	ld a,GLOBALFLAG_INTRO_DONE		; $733d
	call checkGlobalFlag		; $733f
	jp nz,interactionDelete		; $7342

	ld e,Interaction.subid		; $7345
	ld a,(de)		; $7347
	sub $02			; $7348
	ld hl,_introMonkeyScriptTable		; $734a
	rst_addDoubleIndex			; $734d
	ldi a,(hl)		; $734e
	ld h,(hl)		; $734f
	ld l,a			; $7350
	jp interactionSetScript		; $7351


@subid1Init: ; Subids 4 and 5 calls this too
	ld e,Interaction.var03		; $7354
	ld a,(de)		; $7356
	ld c,a			; $7357
	or a			; $7358
	jr nz,@doneSpawning	; $7359

	; Load PALH_ad if this isn't subid 5?
	dec e			; $735b
	ld a,(de)		; $735c
	cp $05			; $735d
	jr z,++			; $735f
	push bc			; $7361
	ld a,PALH_ad		; $7362
	call loadPaletteHeader		; $7364
	pop bc			; $7367
++

	; Spawn 9 monkeys
	ld b,$09		; $7368

@nextMonkey:
	call getFreeInteractionSlot		; $736a
	jr nz,@doneSpawning	; $736d

	ld (hl),INTERACID_MONKEY		; $736f
	inc l			; $7371
	ld e,Interaction.subid		; $7372
	ld a,(de)		; $7374
	ld (hl),a ; Copy subid
	inc l			; $7376
	ld (hl),b ; [var03] = b
	dec b			; $7378
	jr nz,@nextMonkey	; $7379

@doneSpawning:
	; Retrieve var03
	ld a,c			; $737b
	add a			; $737c

	ld hl,@monkeyPositions		; $737d
	rst_addDoubleIndex			; $7380
	ldi a,(hl)		; $7381
	ld e,Interaction.yh		; $7382
	ld (de),a		; $7384
	ldi a,(hl)		; $7385
	ld e,Interaction.xh		; $7386
	ld (de),a		; $7388

	ldi a,(hl)		; $7389
	ld e,Interaction.counter1		; $738a
	ld (de),a		; $738c
	ld a,(hl)		; $738d
	call interactionSetAnimation		; $738e

	; Randomize the animation slightly?
	call getRandomNumber_noPreserveVars		; $7391
	and $0f			; $7394
	ld h,d			; $7396
	ld l,Interaction.counter2		; $7397
	ld (hl),a		; $7399
	sub $07			; $739a
	ld l,Interaction.animCounter		; $739c
	add (hl)		; $739e
	ld (hl),a		; $739f

	; Randomize jump speeds?
	call getRandomNumber		; $73a0
	and $03			; $73a3
	ld bc,@jumpSpeeds		; $73a5
	call addDoubleIndexToBc		; $73a8
	ld l,Interaction.var38		; $73ab
	ld a,(bc)		; $73ad
	ldi (hl),a		; $73ae
	inc bc			; $73af
	ld a,(bc)		; $73b0
	ld (hl),a		; $73b1
	jp _monkeySetJumpSpeed		; $73b2


@jumpSpeeds:
	.dw -$80
	.dw -$a0
	.dw -$70
	.dw -$90


; This table takes var03 as an index.
; Data format:
;   b0: Y
;   b1: X
;   b2: counter1
;   b3: animation
@monkeyPositions:
	.db $58 $88 $f0 $00
	.db $58 $78 $d2 $01
	.db $28 $28 $dc $01
	.db $38 $38 $be $02
	.db $18 $68 $64 $01
	.db $1c $80 $78 $00
	.db $30 $68 $50 $05
	.db $34 $88 $8c $02
	.db $50 $46 $b4 $02
	.db $64 $28 $b8 $08

@subid4Init:
	call objectSetInvisible		; $73e5
	call @subid1Init		; $73e8

	ld l,Interaction.oamFlags		; $73eb
	ld (hl),$06		; $73ed
	ld l,Interaction.counter2		; $73ef
	ld (hl),$3c		; $73f1

	ld l,Interaction.var03		; $73f3
	ld a,(hl)		; $73f5
	cp $09			; $73f6
	jr nz,++		; $73f8

	; Monkey $09: ?
	ld l,Interaction.var3c		; $73fa
	inc (hl)		; $73fc
	ld bc,$6424		; $73fd
	jp interactionSetPosition		; $7400
++
	cp $08			; $7403
	ret nz			; $7405

	; Monkey $08: the monkey with a bowtie
	ld a,$fa		; $7406
	ld e,Interaction.counter1		; $7408
	ld (de),a		; $740a

@initBowtieMonkey:
	ld a,$07		; $740b
	call interactionSetAnimation		; $740d

	; Create a bowtie
	call getFreeInteractionSlot		; $7410
	ret nz			; $7413
	ld (hl),INTERACID_ACCESSORY		; $7414
	inc l			; $7416
	ld (hl),$3d		; $7417
	inc l			; $7419
	ld (hl),$01		; $741a

	ld l,Interaction.relatedObj1		; $741c
	ld (hl),Interaction.start		; $741e
	inc l			; $7420
	ld (hl),d		; $7421

	ld e,Interaction.relatedObj2+1		; $7422
	ld a,h			; $7424
	ld (de),a		; $7425
	ret			; $7426

@subid5Init:
	ld a,GLOBALFLAG_SAVED_NAYRU		; $7427
	call checkGlobalFlag		; $7429
	jp z,interactionDelete		; $742c
	call @subid1Init		; $742f
	ld l,Interaction.counter1		; $7432
	ldi (hl),a		; $7434
	ld (hl),a		; $7435
	ld hl,monkeySubid5Script		; $7436

	ld e,Interaction.var03		; $7439
	ld a,(de)		; $743b
	cp $08			; $743c
	jr nz,+			; $743e

	; Bowtie monkey has a different script
	push af			; $7440
	call @initBowtieMonkey		; $7441
	ld hl,monkeySubid5Script_bowtieMonkey		; $7444
	pop af			; $7447
+
	; Monkey $05 gets the red palette
	cp $05			; $7448
	ld a,$03		; $744a
	jr nz,+			; $744c
	ld a,$02		; $744e
+
	ld e,Interaction.oamFlags		; $7450
	ld (de),a		; $7452
	jp interactionSetScript		; $7453

@subid6Init:
	ld a,$05		; $7456
	jp interactionSetAnimation		; $7458

@subid7Init:
	ld e,Interaction.var03		; $745b
	ld a,(de)		; $745d
	rst_jumpTable			; $745e
	.dw @subid7Init_0
	.dw @subid7Init_1
	.dw @subid7Init_2

@subid7Init_0:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7465
	call checkGlobalFlag		; $7467
	jp nz,interactionDelete		; $746a

	ld a,GLOBALFLAG_SAVED_NAYRU		; $746d
	call checkGlobalFlag		; $746f
	jp z,interactionDelete		; $7472

	ld hl,monkeySubid7Script_0		; $7475
	call interactionSetScript		; $7478
	ld a,$06		; $747b
	jr @setVar3aAnimation		; $747d

@subid7Init_1:
	ld a,GLOBALFLAG_FINISHEDGAME		; $747f
	call checkGlobalFlag		; $7481
	jp z,interactionDelete		; $7484

	ld hl,monkeySubid7Script_1		; $7487
	call interactionSetScript		; $748a
	ld a,$05		; $748d
	jr @setVar3aAnimation		; $748f

@subid7Init_2:
	ld a,GLOBALFLAG_FINISHEDGAME		; $7491
	call checkGlobalFlag		; $7493
	jp nz,interactionDelete		; $7496

	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $7499
	call checkGlobalFlag		; $749b
	jp z,interactionDelete		; $749e

	ld a,GLOBALFLAG_SAVED_NAYRU		; $74a1
	call checkGlobalFlag		; $74a3
	ld hl,monkeySubid7Script_2		; $74a6
	jp z,@setScript		; $74a9
	ld hl,monkeySubid7Script_3		; $74ac
@setScript:
	call interactionSetScript		; $74af
	ld a,$05		; $74b2

@setVar3aAnimation:
	ld e,Interaction.var3a		; $74b4
	ld (de),a		; $74b6
	jp interactionSetAnimation		; $74b7

_monkeyState1:
	ld e,Interaction.subid		; $74ba
	ld a,(de)		; $74bc
	rst_jumpTable			; $74bd
	.dw _monkeySubid0State1
	.dw _monkeySubid1State1
	.dw _monkeySubid2State1
	.dw _monkeySubid3State1
	.dw _monkeySubid4State1
	.dw _monkeySubid5State1
	.dw interactionAnimate
	.dw _monkeyAnimateAndRunScript

;;
; @addr{74ce}
_monkeySubid0State1:
	call interactionAnimate		; $74ce
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $74d1
	ld e,Interaction.state2		; $74d4
	ld a,(de)		; $74d6
	or a			; $74d7
	call z,objectPreventLinkFromPassing		; $74d8

	ld e,Interaction.state2		; $74db
	ld a,(de)		; $74dd
	rst_jumpTable			; $74de
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _monkeySubid0State1Substate3

@substate0:
	ld a,($cfd0)		; $74e7
	cp $0e			; $74ea
	jp nz,interactionRunScript		; $74ec
	call interactionIncState2		; $74ef
	ld a,$06		; $74f2
	jp interactionSetAnimation		; $74f4

@substate1:
	ld a,($cfd0)		; $74f7
	cp $10			; $74fa
	ret nz			; $74fc
	call interactionIncState2		; $74fd
	ld l,Interaction.counter1		; $7500
	ld (hl),$32		; $7502
	ld a,$03		; $7504
	call interactionSetAnimation		; $7506
	jr _monkeyJumpSpeed120		; $7509

@substate2:
	call interactionDecCounter1		; $750b
	jr nz,_monkeyUpdateGravityAndHop	; $750e

	call interactionIncState2		; $7510
	ld l,Interaction.angle		; $7513
	ld (hl),$02		; $7515
	ld l,Interaction.zh		; $7517
	ld (hl),$00		; $7519
	ld l,Interaction.speed		; $751b
	ld (hl),SPEED_180		; $751d

_monkeySetAnimationAndJump:
	call interactionSetAnimation		; $751f

_monkeyJumpSpeed100:
	ld bc,-$100		; $7522
	jp objectSetSpeedZ		; $7525

_monkeySubid0State1Substate3:
	call objectCheckWithinScreenBoundary		; $7528
	jr c,++			; $752b
	ld a,$01		; $752d
	ld (wLoadedTreeGfxIndex),a		; $752f
	jp interactionDelete		; $7532
++
	ld c,$20		; $7535
	call objectUpdateSpeedZ_paramC		; $7537
	jp nz,objectApplySpeed		; $753a
	ld a,$04		; $753d
	jr _monkeySetAnimationAndJump		; $753f

_monkeyUpdateGravityAndHop:
	ld c,$20		; $7541
	call objectUpdateSpeedZ_paramC		; $7543
	ret nz			; $7546

_monkeyJumpSpeed120:
	ld bc,-$120		; $7547
	jp objectSetSpeedZ		; $754a

;;
; Updates gravity, and if the monkey landed, resets speedZ to values of var38/var39.
; @addr{754d}
_monkeyUpdateGravityAndJumpIfLanded:
	ld c,$10		; $754d
	call objectUpdateSpeedZ_paramC		; $754f
	ret nz			; $7552

;;
; Sets speedZ to values of var38/var39.
; @addr{7553}
_monkeySetJumpSpeed:
	ld l,Interaction.var38		; $7553
	ldi a,(hl)		; $7555
	ld e,Interaction.speedZ		; $7556
	ld (de),a		; $7558
	inc e			; $7559
	ld a,(hl)		; $755a
	ld (de),a		; $755b
	ret			; $755c

;;
; Monkey disappearance cutscene
; @addr{755d}
_monkeySubid1State1:
	ld e,Interaction.var03		; $755d
	ld a,(de)		; $755f
	rst_jumpTable			; $7560
	.dw _monkey0Disappearance
	.dw _monkey1Disappearance
	.dw _monkey2Disappearance
	.dw _monkey3Disappearance
	.dw _monkey4Disappearance
	.dw _monkey5Disappearance
	.dw _monkey6Disappearance
	.dw _monkey7Disappearance
	.dw _monkey8Disappearance
	.dw _monkey9Disappearance


_monkey0Disappearance:
_monkey1Disappearance:
_monkey2Disappearance:
_monkey4Disappearance:
	ld e,Interaction.state2		; $7575
	ld a,(de)		; $7577
	rst_jumpTable			; $7578
	.dw @substate0
	.dw @substate1
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	call interactionAnimate		; $7581
	call interactionDecCounter2		; $7584
	ret nz			; $7587
	jp interactionIncState2		; $7588

@substate1:
	call interactionDecCounter1		; $758b
	jr nz,+			; $758e
	jr _monkeyBeginDisappearing			; $7590
+
	call _monkeyUpdateGravityAndJumpIfLanded		; $7592
	jp interactionAnimate		; $7595

_monkeyBeginDisappearing:
	ld (hl),$3c		; $7598
	ld l,Interaction.oamFlags		; $759a
	ld (hl),$06		; $759c
	ld l,Interaction.zh		; $759e
	ld (hl),$00		; $75a0

	ld a,SND_CLINK		; $75a2
	call playSound		; $75a4
	jp interactionIncState2		; $75a7

_monkeyWaitBeforeFlickering:
	call interactionDecCounter1		; $75aa
	ret nz			; $75ad
	ld (hl),$3c		; $75ae
	jp interactionIncState2		; $75b0

_monkeyFlickerUntilDeletion:
	call interactionDecCounter1		; $75b3
	jr nz,+			; $75b6
	jp interactionDelete		; $75b8
+
	ld b,$01		; $75bb
	jp objectFlickerVisibility		; $75bd


_monkey3Disappearance:
_monkey6Disappearance:
_monkey7Disappearance:
	ld e,Interaction.state2		; $75c0
	ld a,(de)		; $75c2
	rst_jumpTable			; $75c3
	.dw @substate0
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	call interactionDecCounter1		; $75ca
	jp nz,interactionAnimate		; $75cd
	jr _monkeyBeginDisappearing		; $75d0


_monkey5Disappearance:
	ld e,Interaction.state2		; $75d2
	ld a,(de)		; $75d4
	rst_jumpTable			; $75d5
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	call interactionIncState2		; $75e0
	ld l,Interaction.oamFlags		; $75e3
	ld (hl),$02		; $75e5

@substate1:
	call interactionDecCounter1		; $75e7
	ret nz			; $75ea
	ld (hl),$b4		; $75eb
	call interactionIncState2		; $75ed
	ld bc,$f3f8		; $75f0
	ld a,$5a		; $75f3
	jp objectCreateExclamationMark		; $75f5

@substate2:
	call interactionDecCounter1		; $75f8
	ret nz			; $75fb
	jp _monkeyBeginDisappearing		; $75fc


	; Unused code?
	ld e,Interaction.state2		; $75ff
	ld a,(de)		; $7601
	rst_jumpTable			; $7602
	.dw @@substate0
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@@substate0:
	call interactionDecCounter1		; $7609
	ret nz			; $760c
	jr _monkeyBeginDisappearing		; $760d


_monkey9Disappearance:
	call _monkeyCheckChangeAnimation		; $760f

	ld e,Interaction.state2		; $7612
	ld a,(de)		; $7614
	cp $04			; $7615
	jr nc,++		; $7617
	call interactionDecCounter1		; $7619
	jr nz,++			; $761c
	call _monkeyBeginDisappearing		; $761e
	ld l,Interaction.state2		; $7621
	ld (hl),$04		; $7623
++
	ld e,Interaction.state2		; $7625
	ld a,(de)		; $7627
	rst_jumpTable			; $7628
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _monkeyWaitBeforeFlickering
	.dw _monkeyFlickerUntilDeletion

@substate0:
	ld h,d			; $7635
	ld l,Interaction.direction		; $7636
	ld a,$08		; $7638
	ldi (hl),a		; $763a
	ld (hl),a		; $763b

	ld l,Interaction.speed		; $763c
	ld (hl),SPEED_100		; $763e
	call interactionIncState2		; $7640
	jp _monkeyJumpSpeed100		; $7643

@substate1:
	ld c,$20		; $7646
	call objectUpdateSpeedZ_paramC		; $7648
	jp nz,objectApplySpeed		; $764b

	call _monkeyJumpSpeed100		; $764e

	ld l,Interaction.var3c		; $7651
	inc (hl)		; $7653
	ld a,(hl)		; $7654
	cp $03			; $7655
	ret nz			; $7657

	call interactionIncState2		; $7658
	ld l,Interaction.var38		; $765b
	ld (hl),$10		; $765d
	ret			; $765f

@substate2:
	ld h,d			; $7660
	ld l,Interaction.var38		; $7661
	dec (hl)		; $7663
	ret nz			; $7664

	ld (hl),$10		; $7665
	call interactionIncState2		; $7667

	ld l,Interaction.direction		; $766a
	ld a,(hl)		; $766c
	xor $10			; $766d
	ldi (hl),a		; $766f
	ld (hl),a		; $7670

	ld l,Interaction.angle		; $7671
	ld a,(hl)		; $7673
	and $10			; $7674
	ld a,$03		; $7676
	jr nz,+			; $7678
	ld a,$08		; $767a
+
	jp _monkeySetAnimationAndJump		; $767c

@substate3:
	ld h,d			; $767f
	ld l,Interaction.var38		; $7680
	dec (hl)		; $7682
	ret nz			; $7683

	ld l,Interaction.var3c		; $7684
	ld (hl),$00		; $7686
	ld l,Interaction.state2		; $7688
	dec (hl)		; $768a
	dec (hl)		; $768b
	ret			; $768c

;;
; Checks if the monkey is in the air, updates var3a and animation accordingly?
; @addr{768d}
_monkeyCheckChangeAnimation:
	ld h,d			; $768d
	ld l,Interaction.zh		; $768e
	ld a,(hl)		; $7690
	sub $03			; $7691
	cp $fa			; $7693
	ld a,$00		; $7695
	jr nc,+			; $7697
	inc a			; $7699
+
	ld l,Interaction.var3a		; $769a
	cp (hl)			; $769c
	ret z			; $769d
	ld (hl),a		; $769e
	ld l,Interaction.animCounter		; $769f
	ld (hl),$01		; $76a1
	jp interactionAnimate		; $76a3


_monkey8Disappearance:
	ld e,Interaction.state2		; $76a6
	ld a,(de)		; $76a8
	rst_jumpTable			; $76a9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw _monkeyWaitBeforeFlickering
	.dw @substate3
	.dw @substate4

@substate0:
	call interactionDecCounter1		; $76b6
	jr nz,++		; $76b9
	ld (hl),$5a		; $76bb
	call interactionIncState2		; $76bd
	ld bc,$f3f8		; $76c0
	ld a,$3c		; $76c3
	jp objectCreateExclamationMark		; $76c5
++
	ld a,(wFrameCounter)		; $76c8
	and $01			; $76cb
	ret nz			; $76cd
	jp interactionAnimate		; $76ce

@substate1:
	call interactionDecCounter1		; $76d1
	ret nz			; $76d4
	ld (hl),$b4		; $76d5
	jp interactionIncState2		; $76d7

@substate2:
	call interactionDecCounter1		; $76da
	jr nz,+			; $76dd
	jp _monkeyBeginDisappearing		; $76df
+
	ld a,(wFrameCounter)		; $76e2
	and $0f			; $76e5
	ret nz			; $76e7
	ld l,Interaction.direction		; $76e8
	ld a,(hl)		; $76ea
	xor $01			; $76eb
	ld (hl),a		; $76ed
	jp interactionSetAnimation		; $76ee

@substate3:
	call interactionDecCounter1		; $76f1
	jr nz,++		; $76f4
	ld (hl),$1e		; $76f6
	call objectSetInvisible		; $76f8
	jp interactionIncState2		; $76fb
++
	ld b,$01		; $76fe
	jp objectFlickerVisibility		; $7700

@substate4:
	call interactionDecCounter1		; $7703
	ret nz			; $7706
	ld a,$ff		; $7707
	ld ($cfdf),a		; $7709
	jp interactionDelete		; $770c

;;
; Monkey that only exists before intro
; @addr{770f}
_monkeySubid2State1:
_monkeySubid3State1:
	call interactionRunScript		; $770f
	jp interactionAnimateAsNpc		; $7712


;;
; @addr{7715}
_monkeySubid4State1:
	ld e,Interaction.var03		; $7715
	ld a,(de)		; $7717
	rst_jumpTable			; $7718
	.dw @monkey0
	.dw @monkey0
	.dw @monkey0
	.dw @monkey3
	.dw @monkey0
	.dw @monkey3
	.dw @monkey3
	.dw @monkey3
	.dw @monkey3
	.dw @monkey9

@monkey0:
	ld e,Interaction.state2		; $772d
	ld a,(de)		; $772f
	rst_jumpTable			; $7730
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4_0

@substate0:
	call interactionDecCounter2		; $773b
	ret nz			; $773e
	jp interactionIncState2		; $773f

@substate1:
	call interactionDecCounter1		; $7742
	ret nz			; $7745
	ld (hl),$3c		; $7746
	ld l,Interaction.var03		; $7748
	ld a,(hl)		; $774a
	cp $08			; $774b
	jr nz,++		; $774d
	ld a,Object.enabled		; $774f
	call objectGetRelatedObject2Var		; $7751
	ld l,Interaction.oamFlags		; $7754
	ld (hl),$06		; $7756
++
	ld a,SND_GALE_SEED		; $7758
	call playSound		; $775a
	jp interactionIncState2		; $775d

@substate2:
	call interactionDecCounter1		; $7760
	jr nz,++		; $7763
	ld (hl),$3c		; $7765
	call objectSetVisible		; $7767
	jp interactionIncState2		; $776a
++
	ld b,$01		; $776d
	jp objectFlickerVisibility		; $776f

@substate3:
	call interactionDecCounter1		; $7772
	ret nz			; $7775
	ld b,$03		; $7776
	ld l,Interaction.var03		; $7778
	ld a,(hl)		; $777a
	cp $05			; $777b
	jr nz,+			; $777d
	dec b			; $777f
	jr ++			; $7780
+
	cp $08			; $7782
	jr nz,++		; $7784
	ld a,Object.enabled		; $7786
	call objectGetRelatedObject2Var		; $7788
	ld l,Interaction.oamFlags		; $778b
	ld (hl),$02		; $778d
	ld h,d			; $778f
	ld l,Interaction.counter1		; $7790
	ld (hl),$b4		; $7792
++
	ld l,Interaction.oamFlags		; $7794
	ld (hl),b		; $7796
	jp interactionIncState2		; $7797

@substate4_0:
	call _monkeyUpdateGravityAndJumpIfLanded		; $779a

@substate4_1:
	call interactionAnimate		; $779d
	ld e,Interaction.var03		; $77a0
	ld a,(de)		; $77a2
	cp $08			; $77a3
	ret nz			; $77a5
	call interactionDecCounter1		; $77a6
	ret nz			; $77a9
	ld a,$ff		; $77aa
	ld ($cfdf),a		; $77ac
	ret			; $77af

@monkey3:
	ld e,Interaction.state2		; $77b0
	ld a,(de)		; $77b2
	rst_jumpTable			; $77b3
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4_1

@monkey9:
	ld e,Interaction.state2		; $77be
	ld a,(de)		; $77c0
	cp $04			; $77c1
	call nc,_monkeyCheckChangeAnimation		; $77c3
	ld e,Interaction.state2		; $77c6
	ld a,(de)		; $77c8
	rst_jumpTable			; $77c9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _monkey9Disappearance@substate0
	.dw _monkey9Disappearance@substate1
	.dw _monkey9Disappearance@substate2
	.dw _monkey9Disappearance@substate3


;;
; @addr{77da}
_monkeySubid5State1:
	ld e,Interaction.var03		; $77da
	ld a,(de)		; $77dc
	rst_jumpTable			; $77dd
	.dw @monkey0
	.dw @monkey0
	.dw @monkey0
	.dw _monkeyAnimateAndRunScript
	.dw @monkey0
	.dw _monkeyAnimateAndRunScript
	.dw _monkeyAnimateAndRunScript
	.dw _monkeyAnimateAndRunScript
	.dw _monkeyAnimateAndRunScript
	.dw _monkeySubid5State1_monkey9

@monkey0:
	call _monkeyUpdateGravityAndJumpIfLanded		; $77f2

_monkeyAnimateAndRunScript:
	call interactionRunScript		; $77f5
	jp interactionAnimateAsNpc		; $77f8

_monkeySubid5State1_monkey9:
	call interactionRunScript		; $77fb
	call _monkeyCheckChangeAnimation		; $77fe
	call objectPushLinkAwayOnCollision		; $7801
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $7804
	ld e,Interaction.state2	; $7807
	ld a,(de)		; $7809
	rst_jumpTable			; $780a
	.dw _monkey9Disappearance@substate0
	.dw _monkey9Disappearance@substate1
	.dw _monkey9Disappearance@substate2
	.dw _monkey9Disappearance@substate3

_introMonkeyScriptTable:
	.dw monkeySubid2Script
	.dw monkeySubid3Script


; ==============================================================================
; INTERACID_RABBIT
; ==============================================================================
interactionCode4b_body:
	ld e,Interaction.state		; $7817
	ld a,(de)		; $7819
	rst_jumpTable			; $781a
	.dw @state0
	.dw @state1

@state0:
	ld a,$01		; $781f
	ld (de),a		; $7821
	call interactionInitGraphics		; $7822
	call objectSetVisiblec2		; $7825
	call @initSubid		; $7828
	ld e,Interaction.enabled		; $782b
	ld a,(de)		; $782d
	or a			; $782e
	jp nz,objectMarkSolidPosition		; $782f
	ret			; $7832

@initSubid:
	ld e,Interaction.subid		; $7833
	ld a,(de)		; $7835
	rst_jumpTable			; $7836
	.dw @initSubid0
	.dw @initSubid1
	.dw @initSubid2
	.dw @initSubid3
	.dw @initSubid4
	.dw @initSubid5
	.dw @initSubid6
	.dw @initSubid7

@initSubid0:
	ld hl,rabbitScript_listeningToNayruGameStart		; $7847
	jp interactionSetScript		; $784a

; This is also called from outside this interaction's code
@initSubid1:
	ld h,d			; $784d
	ld l,Interaction.angle		; $784e
	ld (hl),$18		; $7850
	ld l,Interaction.speed		; $7852
	ld (hl),SPEED_180		; $7854

@setJumpAnimation:
	ld a,$05		; $7856
	call interactionSetAnimation		; $7858

	ld bc,-$180		; $785b
	jp objectSetSpeedZ		; $785e

@initSubid2:
	ld e,Interaction.counter1		; $7861
	ld a,180		; $7863
	ld (de),a		; $7865
	callab interactionBank08.loadStoneNpcPalette		; $7866
	jp _rabbitSubid2SetRandomSpawnDelay		; $786e

@initSubid6:
	; Delete if veran defeated
	ld hl,wGroup4Flags+$fc		; $7871
	bit 7,(hl)		; $7874
	jp nz,interactionDelete		; $7876

	; Delete if haven't beaten Jabu
	ld a,(wEssencesObtained)		; $7879
	bit 6,a			; $787c
	jp z,interactionDelete		; $787e

	callab interactionBank08.loadStoneNpcPalette		; $7881
	ld a,$06		; $7889
	call objectSetCollideRadius		; $788b

@initSubid3:
	ld a,120		; $788e
	ld e,Interaction.counter1		; $7890
	ld (de),a		; $7892

@setStonePaletteAndAnimation:
	ld a,$06		; $7893
	ld e,Interaction.oamFlags		; $7895
	ld (de),a		; $7897
	jp interactionSetAnimation		; $7898

@initSubid5:
	call interactionLoadExtraGraphics		; $789b
	ld h,d			; $789e
	ld l,Interaction.counter1		; $789f
	ld (hl),$0e		; $78a1
	inc l			; $78a3
	ld (hl),$01		; $78a4
	jr @setStonePaletteAndAnimation		; $78a6

@initSubid4:
	call interactionLoadExtraGraphics		; $78a8
	jp _rabbitJump		; $78ab

@initSubid7:
	ld a,GLOBALFLAG_FINISHEDGAME		; $78ae
	call checkGlobalFlag		; $78b0
	jp nz,interactionDelete		; $78b3

	ld a,GLOBALFLAG_MAKU_TREE_SAVED		; $78b6
	call checkGlobalFlag		; $78b8
	jp z,interactionDelete		; $78bb

	ld a,GLOBALFLAG_SAVED_NAYRU		; $78be
	call checkGlobalFlag		; $78c0
	ld hl,rabbitScript_waitingForNayru1		; $78c3
	jp z,+			; $78c6
	ld hl,rabbitScript_waitingForNayru2		; $78c9
+
	call interactionSetScript		; $78cc

@state1:
	ld e,Interaction.subid		; $78cf
	ld a,(de)		; $78d1
	rst_jumpTable			; $78d2
	.dw _rabbitSubid0
	.dw _rabbitSubid1
	.dw _rabbitSubid2
	.dw _rabbitSubid3
	.dw _rabbitSubid4
	.dw _rabbitSubid5
	.dw interactionPushLinkAwayAndUpdateDrawPriority
	.dw _rabbitSubid7


; Listening to Nayru at the start of the game
_rabbitSubid0:
	call interactionAnimateAsNpc		; $78e3
	ld e,Interaction.state2		; $78e6
	ld a,(de)		; $78e8
	rst_jumpTable			; $78e9
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfd0)		; $78f2
	cp $0e			; $78f5
	jp nz,interactionRunScript		; $78f7

	call interactionIncState2		; $78fa
	ld a,$02		; $78fd
	jp interactionSetAnimation		; $78ff

@substate1:
	ld a,($cfd0)		; $7902
	cp $10			; $7905
	jp nz,interactionRunScript		; $7907

	call interactionIncState2		; $790a
	ld l,Interaction.counter1		; $790d
	ld (hl),40		; $790f
	ret			; $7911

@substate2:
	call interactionDecCounter1		; $7912
	jp nz,interactionAnimate		; $7915

	call interactionIncState2		; $7918
	ld l,Interaction.angle		; $791b
	ld (hl),$06		; $791d
	ld l,Interaction.speed		; $791f
	ld (hl),SPEED_180		; $7921

@jump:
	ld bc,-$200		; $7923
	call objectSetSpeedZ		; $7926
	ld a,$04		; $7929
	jp interactionSetAnimation		; $792b

@substate3:
	call objectCheckWithinScreenBoundary		; $792e
	jp nc,interactionDelete		; $7931
	ld c,$20		; $7934
	call objectUpdateSpeedZ_paramC		; $7936
	jp nz,objectApplySpeed		; $7939
	jr @jump		; $793c


_rabbitSubid1:
	ld h,d			; $793e
	ld l,Interaction.counter1		; $793f
	ld a,(hl)		; $7941
	or a			; $7942
	jr z,@updateSubstate	; $7943
	dec (hl)		; $7945
	jr nz,@updateSubstate	; $7946

	inc l			; $7948
	ld a,30 ; [counter2] = 30

	ld (hl),a		; $794b
	ld l,Interaction.state2		; $794c
	ld (hl),$02		; $794e
	ld bc,$f000		; $7950
	call objectCreateExclamationMark		; $7953

@updateSubstate:
	ld e,Interaction.state2		; $7956
	ld a,(de)		; $7958
	rst_jumpTable			; $7959
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

; This is also called by subids 1 and 3
@substate0:
	call interactionAnimate		; $7968
	ld e,Interaction.animParameter		; $796b
	ld a,(de)		; $796d
	or a			; $796e
	ret z			; $796f
	ld a,SND_JUMP		; $7970
	call playSound		; $7972
	jp interactionIncState2		; $7975

; This is also called by subids 1 and 3
@substate1:
	ld e,Interaction.xh		; $7978
	ld a,(de)		; $797a
	cp $d0			; $797b
	jp nc,interactionDelete		; $797d

	call objectApplySpeed		; $7980
	ld c,$20		; $7983
	call objectUpdateSpeedZ_paramC		; $7985
	ret nz			; $7988

	ld h,d			; $7989
	ld l,Interaction.state2		; $798a
	dec (hl)		; $798c
	jp interactionCode4b_body@setJumpAnimation		; $798d

@substate2:
	call interactionDecCounter2		; $7990
	ret nz			; $7993

	ld (hl),60		; $7994
	ld l,Interaction.xh		; $7996
	ld a,(hl)		; $7998
	ld l,Interaction.var3d		; $7999
	ld (hl),a		; $799b
	jp interactionIncState2		; $799c

@substate3:
	callab interactionBank08.interactionOscillateXRandomly		; $799f
	call interactionDecCounter2		; $79a7
	ret nz			; $79aa
	ld (hl),20		; $79ab

	; Set stone color
	ld l,Interaction.oamFlags		; $79ad
	ld (hl),$06		; $79af

	jp interactionIncState2		; $79b1

@substate4:
	call interactionDecCounter2		; $79b4
	ret nz			; $79b7

	ld bc,$0000		; $79b8
	call objectSetSpeedZ		; $79bb
	jp interactionIncState2		; $79be

@substate5:
	ld c,$20		; $79c1
	call objectUpdateSpeedZ_paramC		; $79c3
	ret nz			; $79c6

	call interactionIncState2		; $79c7
	ld l,Interaction.counter2		; $79ca
	ld (hl),240		; $79cc
	ld a,$04		; $79ce
	jp setScreenShakeCounter		; $79d0

@substate6:
	call interactionDecCounter2		; $79d3
	ret nz			; $79d6
	ld a,$ff		; $79d7
	ld ($cfdf),a		; $79d9
	ret			; $79dc


; "Controller" for the cutscene where rabbits turn to stone? (spawns subid $01)
_rabbitSubid2:
	ld h,d			; $79dd
	ld l,Interaction.counter1		; $79de
	ld a,(hl)		; $79e0
	or a			; $79e1
	jr z,+			; $79e2
	dec (hl)		; $79e4
	call z,_spawnNextRabbitThatTurnsToStone		; $79e5
+
	; After a random delay, spawn a rabbit that just runs across the screen (doesn't
	; turn to stone)
	ld h,d			; $79e8
	ld l,Interaction.var38		; $79e9
	dec (hl)		; $79eb
	ret nz			; $79ec

	call getRandomNumber_noPreserveVars		; $79ed
	and $07			; $79f0
	ld hl,_rabbitSubid2YPositions		; $79f2
	rst_addAToHl			; $79f5
	ld b,(hl)		; $79f6
	call getRandomNumber		; $79f7
	and $0f			; $79fa
	cpl			; $79fc
	inc a			; $79fd
	add $b0			; $79fe
	ld c,a			; $7a00
	call _spawnRabbitWithSubid1		; $7a01
	jp _rabbitSubid2SetRandomSpawnDelay		; $7a04


; Rabbit being restored from stone cutscene (gets restored and jumps away)
_rabbitSubid3:
	ld e,Interaction.state2		; $7a07
	ld a,(de)		; $7a09
	rst_jumpTable			; $7a0a
	.dw @substate0
	.dw @substate1
	.dw _rabbitSubid1@substate0
	.dw _rabbitSubid1@substate1

@substate0:
	call interactionDecCounter1		; $7a13
	ret nz			; $7a16
	ld (hl),$5a		; $7a17
	ld a,$01		; $7a19
	ld ($cfd1),a		; $7a1b
	ld a,SND_RESTORE		; $7a1e
	call playSound		; $7a20
	jp interactionIncState2		; $7a23

; This is also called from subid 5
@substate1:
	call interactionDecCounter1		; $7a26
	jr z,+			; $7a29
	jpab interactionBank08.childFlickerBetweenStone		; $7a2b
+
	call interactionIncState2		; $7a33
	ld l,Interaction.oamFlags		; $7a36
	ld (hl),$02		; $7a38
	ld l,Interaction.var38		; $7a3a
	ld (hl),$20		; $7a3c
	jp interactionCode4b_body@initSubid1		; $7a3e


; Rabbit being restored from stone cutscene (the one that wasn't stone)
_rabbitSubid4:
	ld e,Interaction.state2		; $7a41
	ld a,(de)		; $7a43
	rst_jumpTable			; $7a44
	.dw @substate0
	.dw @substate1
	.dw _rabbitSubid4Substate2
	.dw _rabbitSubid5@substate3
	.dw _rabbitSubid5@ret

@substate0:
	ld a,($cfd1)		; $7a4f
	cp $01			; $7a52
	jr nz,++		; $7a54

	ld h,d			; $7a56
	ld l,Interaction.state2		; $7a57
	ld (hl),$02		; $7a59
	ld hl,rabbitSubid4Script		; $7a5b
	jp interactionSetScript		; $7a5e
++
	call interactionAnimate		; $7a61
	ld e,Interaction.animParameter		; $7a64
	ld a,(de)		; $7a66
	or a			; $7a67
	ret z			; $7a68
	jp interactionIncState2		; $7a69

@substate1:
	ld c,$20		; $7a6c
	call objectUpdateSpeedZ_paramC		; $7a6e
	ret nz			; $7a71

	ld h,d			; $7a72
	ld l,Interaction.state2		; $7a73
	dec (hl)		; $7a75

;;
; @addr{7a76}
_rabbitJump:
	ld a,$07		; $7a76
	call interactionSetAnimation		; $7a78
	ld bc,-$e0		; $7a7b
	jp objectSetSpeedZ		; $7a7e


_rabbitSubid4Substate2:
	ld a,($cfd1)		; $7a81
	cp $02			; $7a84
	jp nz,interactionRunScript		; $7a86

	call interactionIncState2		; $7a89
	ld l,Interaction.angle		; $7a8c
	ld (hl),$18		; $7a8e

	ld l,Interaction.speed		; $7a90
	ld (hl),SPEED_a0		; $7a92
	ld bc,-$180		; $7a94
	call objectSetSpeedZ		; $7a97

	ld a,$09		; $7a9a
	jp interactionSetAnimation		; $7a9c

_rabbitSubid5:
	ld h,d			; $7a9f
	ld l,Interaction.var38		; $7aa0
	ld a,(hl)		; $7aa2
	or a			; $7aa3
	jr z,@updateSubstate	; $7aa4
	dec (hl)		; $7aa6
	jr nz,@updateSubstate	; $7aa7

	; Just collided with another rabbit?

	ld l,Interaction.state2		; $7aa9
	ld (hl),$04		; $7aab
	ld l,Interaction.angle		; $7aad
	ld (hl),$08		; $7aaf

	ld l,Interaction.speed		; $7ab1
	ld (hl),SPEED_a0		; $7ab3
	ld bc,-$1e0		; $7ab5
	call objectSetSpeedZ		; $7ab8

	ldbc INTERACID_CLINK,$80		; $7abb
	call objectCreateInteraction		; $7abe
	jr nz,@label_3f_367	; $7ac1

	ld a,SND_DAMAGE_ENEMY		; $7ac3
	call playSound		; $7ac5
	ld a,$02		; $7ac8
	ld ($cfd1),a		; $7aca

@label_3f_367:
	ld a,$08		; $7acd
	call interactionSetAnimation		; $7acf

@updateSubstate:
	ld e,Interaction.state2		; $7ad2
	ld a,(de)		; $7ad4
	rst_jumpTable			; $7ad5
	.dw @substate0
	.dw _rabbitSubid3@substate1
	.dw _rabbitSubid1@substate0
	.dw _rabbitSubid1@substate1
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d			; $7ae2
	ld l,Interaction.counter1		; $7ae3
	call decHlRef16WithCap		; $7ae5
	ret nz			; $7ae8

	ld (hl),$5a		; $7ae9
	call interactionIncState2		; $7aeb
	ld a,SND_RESTORE		; $7aee
	jp playSound		; $7af0

; Also called from subid 4
@substate3:
	call objectApplySpeed		; $7af3
	ld c,$20		; $7af6
	call objectUpdateSpeedZAndBounce		; $7af8
	ret nc			; $7afb

	call interactionIncState2		; $7afc
	ld l,Interaction.counter1		; $7aff
	ld (hl),$3c		; $7b01

@ret:
	ret			; $7b03

@substate4:
	call interactionDecCounter1		; $7b04
	ret nz			; $7b07

	ld a,$ff		; $7b08
	ld ($cfdf),a		; $7b0a
	ret			; $7b0d


; Generic NPC waiting around in the spot Nayru used to sing
_rabbitSubid7:
	call interactionRunScript		; $7b0e
	jp c,interactionDelete		; $7b11
	jp npcFaceLinkAndAnimate		; $7b14

;;
; This might be setting one of 4 possible speed values to var38?
; @addr{7b17}
_rabbitSubid2SetRandomSpawnDelay:
	call getRandomNumber_noPreserveVars		; $7b17
	and $03			; $7b1a
	ld bc,_rabbitSubid2SpawnDelays		; $7b1c
	call addAToBc		; $7b1f
	ld a,(bc)		; $7b22
	ld e,Interaction.var38		; $7b23
	ld (de),a		; $7b25
	ret			; $7b26

;;
; hl should point to "counter1".
; @addr{7b27}
_spawnNextRabbitThatTurnsToStone:
	; Increment counter2, the index of the rabbit to spawn (0-2)
	inc l			; $7b27
	ld a,(hl)		; $7b28
	inc (hl)		; $7b29

	ld b,a			; $7b2a
	add a			; $7b2b
	add b			; $7b2c
	ld hl,@data		; $7b2d
	rst_addAToHl			; $7b30
	ldi a,(hl)		; $7b31
	ld e,Interaction.counter1		; $7b32
	ld (de),a		; $7b34
	ld b,(hl)		; $7b35
	inc hl			; $7b36
	ld c,(hl)		; $7b37

	; Spawn a rabbit that will turn to stone after 95 frames
	call _spawnRabbitWithSubid1		; $7b38
	ld l,Interaction.counter1		; $7b3b
	ld (hl),95		; $7b3d
	ret			; $7b3f

; Data for the rabbits that turn to stone in a cutscene. Format:
;   b0: Frames until next rabbit is spawned?
;   b1: Y position
;   b2: X position
@data:
	.db $5a $28 $b8
	.db $1e $40 $a8
	.db $00 $50 $c8

;;
; Spawns a rabbit for the cutscene where a bunch of rabbits turn to stone
;
; @param	bc	Position
; @addr{7b49}
_spawnRabbitWithSubid1;
	call getFreeInteractionSlot		; $7b49
	ret nz			; $7b4c
	ld (hl),INTERACID_RABBIT		; $7b4d
	inc l			; $7b4f
	inc (hl)		; $7b50
	jp interactionHSetPosition		; $7b51


; A byte from here is chosen randomly to spawn a rabbit at.
_rabbitSubid2YPositions:
	.db $66 $5e $58 $46 $3a $30 $20 $18

; A byte from here is chosen randomly as a delay before spawning another rabbit.
_rabbitSubid2SpawnDelays:
	.db $1e $3c $50 $78


; ==============================================================================
; INTERACID_TUNI_NUT
; ==============================================================================
interactionCodeb1_body:
	ld e,Interaction.state		; $7b60
	ld a,(de)		; $7b62
	rst_jumpTable			; $7b63
	.dw _tuniNut_state0
	.dw _tuniNut_state1
	.dw _tuniNut_state2
	.dw _tuniNut_state3
	.dw objectPreventLinkFromPassing


_tuniNut_state0:
	call interactionInitGraphics		; $7b6e
	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7b71
	call checkGlobalFlag		; $7b73
	jr nz,_tuniNut_gotoState4	; $7b76

	ld a,TREASURE_TUNI_NUT		; $7b78
	call checkTreasureObtained		; $7b7a
	jr nc,@delete	; $7b7d
	cp $02			; $7b7f
	jr nz,@delete	; $7b81

	ld bc,$0810		; $7b83
	call objectSetCollideRadii		; $7b86
	jp interactionIncState		; $7b89

@delete:
	jp interactionDelete		; $7b8c


_tuniNut_gotoState4:
	ld bc,$1878		; $7b8f
	call interactionSetPosition		; $7b92
	ld l,Interaction.state		; $7b95
	ld (hl),$04		; $7b97
	ld a,$06		; $7b99
	call objectSetCollideRadius		; $7b9b
	jp objectSetVisible82		; $7b9e


; Waiting for Link to walk up to the object (currently invisible, acting as a cutscene trigger)
_tuniNut_state1:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing		; $7ba1
	ret nc			; $7ba4
	call checkLinkCollisionsEnabled		; $7ba5
	ret nc			; $7ba8

	push de			; $7ba9
	call clearAllItemsAndPutLinkOnGround		; $7baa
	pop de			; $7bad

	ld a,DISABLE_LINK		; $7bae
	ld (wDisabledObjects),a		; $7bb0
	ld (wMenuDisabled),a		; $7bb3

	ld a,(w1Link.xh)		; $7bb6
	sub LARGE_ROOM_WIDTH<<3			; $7bb9
	jr z,@perfectlyCentered	; $7bbb
	jr c,@leftSide	; $7bbd

	; Right side
	ld b,DIR_LEFT		; $7bbf
	jr @moveToCenter		; $7bc1

@leftSide:
	cpl			; $7bc3
	inc a			; $7bc4
	ld b,DIR_RIGHT		; $7bc5

@moveToCenter:
	ld (wLinkStateParameter),a		; $7bc7
	ld e,Interaction.counter1		; $7bca
	ld (de),a		; $7bcc
	ld a,b			; $7bcd
	ld (w1Link.direction),a		; $7bce
	swap a			; $7bd1
	rrca			; $7bd3
	ld (w1Link.angle),a		; $7bd4
	ld a,LINK_STATE_FORCE_MOVEMENT		; $7bd7
	ld (wLinkForceState),a		; $7bd9
	jp interactionIncState		; $7bdc

@perfectlyCentered:
	call interactionIncState		; $7bdf
	jr _tuniNut_beginMovingIntoPlace		; $7be2


_tuniNut_state2:
	call interactionDecCounter1		; $7be4
	ret nz			; $7be7

_tuniNut_beginMovingIntoPlace:
	xor a			; $7be8
	ld (w1Link.direction),a		; $7be9

	ld e,Interaction.counter1		; $7bec
	ld a,60		; $7bee
	ld (de),a		; $7bf0

	ldbc INTERACID_SPARKLE, $07		; $7bf1
	call objectCreateInteraction		; $7bf4
	ld l,Interaction.relatedObj1		; $7bf7
	ld a,e			; $7bf9
	ldi (hl),a		; $7bfa
	ld a,d			; $7bfb
	ld (hl),a		; $7bfc

	call darkenRoomLightly		; $7bfd
	ld a,SNDCTRL_STOPMUSIC		; $7c00
	call playSound		; $7c02
	call objectSetVisiblec0		; $7c05
	jp interactionIncState		; $7c08


_tuniNut_state3:
	ld e,Interaction.state2		; $7c0b
	ld a,(de)		; $7c0d
	rst_jumpTable			; $7c0e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	call interactionDecCounter1		; $7c1b
	ret nz			; $7c1e
	ld (hl),$10		; $7c1f
	jp interactionIncState2		; $7c21

@substate1:
	ld a,(wFrameCounter)		; $7c24
	rrca			; $7c27
	ret c			; $7c28
	ld h,d			; $7c29
	ld l,Interaction.zh		; $7c2a
	dec (hl)		; $7c2c
	call interactionDecCounter1		; $7c2d
	ret nz			; $7c30
	call objectCenterOnTile		; $7c31
	jp interactionIncState2		; $7c34

@substate2:
	ld b,SPEED_40		; $7c37
	ld c,$00		; $7c39
	ld e,Interaction.angle		; $7c3b
	call objectApplyGivenSpeed		; $7c3d
	ld e,Interaction.yh		; $7c40
	ld a,(de)		; $7c42
	cp $18			; $7c43
	ret nc			; $7c45
	call objectCenterOnTile		; $7c46
	jp interactionIncState2		; $7c49

@substate3:
	ld c,$20		; $7c4c
	call objectUpdateSpeedZ_paramC		; $7c4e
	ret nz			; $7c51
	ld a,SND_DROPESSENCE		; $7c52
	call playSound		; $7c54
	ld e,Interaction.counter1		; $7c57
	ld a,90		; $7c59
	ld (de),a		; $7c5b
	ld a,SND_SOLVEPUZZLE_2		; $7c5c
	call playSound		; $7c5e
	jp interactionIncState2		; $7c61

@substate4:
	call interactionDecCounter1		; $7c64
	ret nz			; $7c67
	call brightenRoom		; $7c68
	jp interactionIncState2		; $7c6b

@substate5:
	ld a,(wPaletteThread_mode)		; $7c6e
	or a			; $7c71
	ret nz			; $7c72

	ld a,GLOBALFLAG_TUNI_NUT_PLACED		; $7c73
	call setGlobalFlag		; $7c75

	ld a,TREASURE_TUNI_NUT		; $7c78
	call loseTreasure		; $7c7a

	call @setSymmetryVillageRoomFlags		; $7c7d

	xor a			; $7c80
	ld (wDisabledObjects),a		; $7c81
	ld (wMenuDisabled),a		; $7c84

	ld hl,wTmpcfc0.genericCutscene.state		; $7c87
	set 0,(hl)		; $7c8a

	ld a,(wActiveMusic)		; $7c8c
	call playSound		; $7c8f
	jp _tuniNut_gotoState4		; $7c92

;;
; Sets the room flags so present symmetry village is nice and cheerful now
; @addr{7c95}
@setSymmetryVillageRoomFlags:
	ld hl,wPresentRoomFlags+$02		; $7c95
	call @setRow		; $7c98
	ld l,$12		; $7c9b
@setRow:
	set 0,(hl)		; $7c9d
	inc l			; $7c9f
	set 0,(hl)		; $7ca0
	inc l			; $7ca2
	set 0,(hl)		; $7ca3
	inc l			; $7ca5
	ret			; $7ca6
