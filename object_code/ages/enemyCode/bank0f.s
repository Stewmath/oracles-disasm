; ==============================================================================
; ENEMYID_GIANT_GHINI
;
; Variables:
;   var30: Number of children alive
;   var32: Nonzero to begin charging at Link (written to by ENEMYID_GIANT_GHINI_CHILD)
;   var33: Counter for Z-axis movement (reverses direction every 16 frames)
;   var34: The current "vertical half" of the screen it's moving toward
;   var35: Position the ghini is currently charging toward
; ==============================================================================
enemyCode70:
	jr z,@normalStatus	; $4594
	sub ENEMYSTATUS_NO_HEALTH			; $4596
	ret c			; $4598
	jr nz,@normalStatus	; $4599
	jp _enemyBoss_dead		; $459b

@normalStatus:
	call _giantGhini_updateZPos		; $459e
	ld e,Enemy.state		; $45a1
	ld a,(de)		; $45a3
	rst_jumpTable			; $45a4
	.dw _giantGhini_state_uninitialized
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state_stub
	.dw _giantGhini_state8
	.dw _giantGhini_state9
	.dw _giantGhini_stateA


_giantGhini_state_uninitialized:
	ld a,ENEMYID_GIANT_GHINI		; $45bb
	ld b,$00		; $45bd
	call _enemyBoss_initializeRoom		; $45bf
	call _ecom_setSpeedAndState8		; $45c2

	ld bc,$0040		; $45c5
	call objectSetSpeedZ		; $45c8

	ld l,Enemy.subid		; $45cb
	set 7,(hl)		; $45cd

	ld l,Enemy.counter1		; $45cf
	ld (hl),120		; $45d1

	ld l,Enemy.zh		; $45d3
	ld (hl),$f8		; $45d5

	ld l,Enemy.var33		; $45d7
	ld (hl),$10		; $45d9
	jp _giantGhini_spawnChildren		; $45db


_giantGhini_state_stub:
	ret			; $45de


; The ghini is spawning in before the fight starts
_giantGhini_state8:
	inc e			; $45df
	ld a,(de) ; [state2]
	rst_jumpTable			; $45e1
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,DISABLE_LINK		; $45e8
	ld (wDisabledObjects),a		; $45ea
	ld (wMenuDisabled),a		; $45ed

	; Wait for door to close
	ld a,($cc93)		; $45f0
	or a			; $45f3
	ret nz			; $45f4

	ld a,120		; $45f5
	ld e,Enemy.counter1		; $45f7
	ld (de),a		; $45f9

	inc e			; $45fa
	ld a,30		; $45fb
	ld (de),a ; [counter2]

	jp _ecom_incState2		; $45fe

@substate1:
	call _ecom_decCounter1		; $4601
	ret nz			; $4604

	ld (hl),60		; $4605

	ld l,Enemy.subid		; $4607
	res 7,(hl)		; $4609

	ld b,$01		; $460b
	ld c,$0c		; $460d
	call _enemyBoss_spawnShadow		; $460f
	jp _ecom_incState2		; $4612

@substate2:
	; Flicker visibility
	ld e,Enemy.visible		; $4615
	ld a,(de)		; $4617
	xor $80			; $4618
	ld (de),a		; $461a

	call _ecom_decCounter1		; $461b
	ret nz			; $461e

	; Finally begin the fight
	call _enemyBoss_beginMiniboss		; $461f
	call objectSetVisible80		; $4622

_giantGhini_gotoState9:
	xor a			; $4625
	call enemySetAnimation		; $4626

	call _giantGhini_getTargetAngle		; $4629
	ld h,d			; $462c
	ld e,Enemy.angle		; $462d
	ld (de),a		; $462f

	ld l,Enemy.state		; $4630
	ld (hl),$09		; $4632

	ld l,Enemy.speed		; $4634
	ld (hl),SPEED_c0		; $4636

	ld l,Enemy.counter1		; $4638
	ld (hl),$02		; $463a

	ld l,Enemy.var32		; $463c
	ld (hl),$00		; $463e

_giantGhini_setChildRespawnTimer:
	call getRandomNumber		; $4640
	and $03			; $4643
	ld c,60		; $4645
	call multiplyAByC		; $4647
	ld e,Enemy.counter2		; $464a
	ld a,l			; $464c
	ld (de),a		; $464d
	ret			; $464e


; "Normal" state during battle
_giantGhini_state9:
	ld e,Enemy.var32		; $464f
	ld a,(de)		; $4651
	or a			; $4652
	jr nz,@beginCharge	; $4653

	call enemyAnimate		; $4655
	call objectApplySpeed		; $4658

	; Nudge angle toward target every other frame
	call _ecom_decCounter1		; $465b
	jr nz,++		; $465e
	ld (hl),$02		; $4660
	call _giantGhini_getTargetAngle		; $4662
	call objectNudgeAngleTowards		; $4665
++
	call _ecom_decCounter2		; $4668
	ret nz			; $466b

	call _giantGhini_setChildRespawnTimer		; $466c
	ld e,Enemy.var30		; $466f
	ld a,(de)		; $4671
	or a			; $4672
	ret nz			; $4673
	call getRandomNumber		; $4674
	and $03			; $4677
	jp nz,_giantGhini_spawnChildren		; $4679

@beginCharge:
	ld a,$01		; $467c
	call enemySetAnimation		; $467e
	call _ecom_incState		; $4681

	ld l,Enemy.counter2		; $4684
	ld (hl),150		; $4686
	ld l,Enemy.speed		; $4688
	ld (hl),SPEED_20		; $468a

_giantGhini_updateChargeTargetPosition:
	; Get Link's position, save that as the position we're charging toward
	ld hl,w1Link.yh		; $468c
	ldi a,(hl)		; $468f
	ld b,a			; $4690
	inc l			; $4691
	ld a,(hl)		; $4692
	ld c,a			; $4693
	call getTileAtPosition		; $4694
	ld a,l			; $4697
	ld e,Enemy.var35		; $4698
	ld (de),a		; $469a

	call objectGetAngleTowardLink		; $469b
	ld e,Enemy.angle		; $469e
	ld (de),a		; $46a0
	ret			; $46a1


; Charging toward Link
_giantGhini_stateA:
	call enemyAnimate		; $46a2

	; Increase speed every 4 frames
	call _ecom_decCounter2		; $46a5
	ld a,(hl)		; $46a8
	and $03			; $46a9
	jr nz,++		; $46ab
	ld l,Enemy.speed		; $46ad
	ld a,(hl)		; $46af
	cp SPEED_300			; $46b0
	jr z,++			; $46b2
	add SPEED_20			; $46b4
	ld (hl),a		; $46b6
++
	call objectApplySpeed		; $46b7

	ld e,Enemy.var32		; $46ba
	ld a,(de)		; $46bc
	or a			; $46bd
	call nz,_giantGhini_updateChargeTargetPosition		; $46be

	ld e,Enemy.var35		; $46c1
	ld a,(de)		; $46c3
	call convertShortToLongPosition		; $46c4
	ld e,Enemy.yh		; $46c7
	call objectGetRelativeAngle		; $46c9
	ld e,Enemy.angle		; $46cc
	ld (de),a		; $46ce

	call objectGetTileAtPosition		; $46cf
	ld e,Enemy.var35		; $46d2
	ld a,(de)		; $46d4
	cp l			; $46d5
	jp z,_giantGhini_gotoState9		; $46d6
	ret			; $46d9


;;
; @addr{46da}
_giantGhini_updateZPos:
	ld c,$00		; $46da
	call objectUpdateSpeedZ_paramC		; $46dc

	ld l,Enemy.var33		; $46df
	ld a,(hl)		; $46e1
	dec a			; $46e2
	ld (hl),a		; $46e3
	ret nz			; $46e4

	ld a,$10		; $46e5
	ld (hl),a ; [var33]

	; Invert speedZ
	ld l,Enemy.speedZ		; $46e8
	ld a,(hl)		; $46ea
	cpl			; $46eb
	inc a			; $46ec
	ldi (hl),a		; $46ed
	ld a,(hl)		; $46ee
	cpl			; $46ef
	ld (hl),a		; $46f0
	ret			; $46f1


;;
; @addr{46f2}
_giantGhini_spawnChildren:
	ld c,$03		; $46f2
@nextChild:
	ld b,ENEMYID_GIANT_GHINI_CHILD		; $46f4
	call _ecom_spawnEnemyWithSubid01		; $46f6
	ret nz			; $46f9

	ld e,Enemy.var30		; $46fa
	ld a,(de)		; $46fc
	inc a			; $46fd
	ld (de),a		; $46fe

	; [child.subid] = [this.subid] | index
	ld e,Enemy.subid		; $46ff
	ld a,(de)		; $4701
	or c			; $4702
	ld (hl),a		; $4703

	ld l,Enemy.relatedObj1		; $4704
	ld a,Enemy.start		; $4706
	ldi (hl),a		; $4708
	ld (hl),d		; $4709

	call objectCopyPosition		; $470a

	dec c			; $470d
	jr nz,@nextChild	; $470e
	ret			; $4710


;;
; Decides on a position to move towards, for state 9 ("normal" state). It will target
; the horizontal center of the screen, with the Y-position one quarter away from the
; screen boundary (depends which side Link is on). The camera affects the target position.
;
; When Link moves beyond the half-screen boundary, the ghini recalculates its angle to
; face directly away from Link before it slowly moves toward him again.
;
; @param[out]	a	angle
; @addr{4711}
_giantGhini_getTargetAngle:
	ldh a,(<hCameraY)	; $4711
	ld c,a			; $4713
	ld a,(w1Link.yh)		; $4714
	sub c			; $4717
	ld b,(SCREEN_HEIGHT/4)<<4 + 8		; $4718
	cp (SCREEN_HEIGHT/2)<<4 + 8			; $471a
	jr nc,+			; $471c
	ld b,(SCREEN_HEIGHT*3/4)<<4 + 8		; $471e
+
	ld e,Enemy.var34		; $4720
	ld a,(de)		; $4722
	cp b			; $4723
	jr z,++			; $4724

	; Link changed sides on the screen boundary

	ld a,b			; $4726
	ld (de),a ; [var34]

	call objectGetAngleTowardLink		; $4728
	xor $10			; $472b
	ld e,Enemy.angle		; $472d
	ld (de),a		; $472f

	ld e,Enemy.counter1		; $4730
	ld a,$0a		; $4732
	ld (de),a		; $4734
	jr _giantGhini_getTargetAngle		; $4735
++
	ld a,c			; $4737
	add b			; $4738
	ld b,a			; $4739
	ldh a,(<hCameraX)	; $473a
	add (SCREEN_WIDTH/2)<<4			; $473c
	ld c,a			; $473e
	jp objectGetRelativeAngle		; $473f


; ==============================================================================
; ENEMYID_SWOOP
;
; Variables:
;   var30: Number of frames before swoop begins to stomp
;   var31: Target stomp position (short-form)
;   var32/var33: Target stomp position (long-form)
; ==============================================================================
enemyCode71:
	jr z,@normalStatus	; $4742
	sub ENEMYSTATUS_NO_HEALTH			; $4744
	ret c			; $4746
	jp nz,@normalStatus		; $4747
	jp _enemyBoss_dead		; $474a

@normalStatus:
	ld e,Enemy.state		; $474d
	ld a,(de)		; $474f
	rst_jumpTable			; $4750
	.dw _swoop_state_uninitialized
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state_stub
	.dw _swoop_state8
	.dw _swoop_state9
	.dw _swoop_stateA
	.dw _swoop_stateB


_swoop_state_uninitialized:
	ld a,ENEMYID_SWOOP		; $4769
	ld b,$00		; $476b
	call _enemyBoss_initializeRoom		; $476d
	call _ecom_setSpeedAndState8		; $4770
	ld b,$01		; $4773
	ld c,$08		; $4775
	jp _enemyBoss_spawnShadow		; $4777


_swoop_state_stub:
	ret			; $477a


; Spawning in before the fight starts
_swoop_state8:
	ld e,Enemy.state2		; $477b
	ld a,(de)		; $477d
	rst_jumpTable			; $477e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,DISABLE_LINK		; $4787
	ld (wDisabledObjects),a		; $4789
	ld (wMenuDisabled),a		; $478c

	; Wait for door to close
	ld a,($cc93)		; $478f
	or a			; $4792
	ret nz			; $4793

	call _ecom_incState2		; $4794
	ld c,$08		; $4797
	call _ecom_setZAboveScreen		; $4799

	ld e,Enemy.counter1		; $479c
	ld a,60		; $479e
	ld (de),a		; $47a0

	inc e			; $47a1
	ld a,$02		; $47a2
	ld (de),a ; [counter2]

	call objectSetVisible82		; $47a5
	ld a,$02		; $47a8
	jp enemySetAnimation		; $47aa

; Falling to ground
@substate1:
	ld c,$10		; $47ad
	call objectUpdateSpeedZ_paramC		; $47af
	ret nz			; $47b2

	ld e,Enemy.counter2		; $47b3
	ld a,(de)		; $47b5
	or a			; $47b6
	jr z,@doneBouncing	; $47b7

	dec a			; $47b9
	ld (de),a		; $47ba
	jr nz,++		; $47bb

	ld a,$00		; $47bd
	call enemySetAnimation		; $47bf
	jr @doneBouncing		; $47c2
++
	ld bc,-$180		; $47c4
	call objectSetSpeedZ		; $47c7
	ld a,$0a		; $47ca
	call setScreenShakeCounter		; $47cc
	ld a,SND_DOORCLOSE		; $47cf
	jp playSound		; $47d1

@doneBouncing:
	call _ecom_decCounter1		; $47d4
	ret nz			; $47d7
	ld bc,TX_2f00		; $47d8
	call showText		; $47db
	jp _ecom_incState2		; $47de

@substate2:
	call retIfTextIsActive		; $47e1
	call _enemyBoss_beginMiniboss		; $47e4
	call _ecom_incState2		; $47e7
	jp _swoop_beginFlyingUp		; $47ea

@substate3:
	call _swoop_state9		; $47ed

	ld e,Enemy.state		; $47f0
	ld a,(de)		; $47f2
	cp $0a			; $47f3
	ret nz			; $47f5

	xor a			; $47f6
	ld (wDisabledObjects),a		; $47f7
	ld (wMenuDisabled),a		; $47fa
	ret			; $47fd


; Flying upward
_swoop_state9:
	call _swoop_animate		; $47fe

	; Set Z-speed if just flapped wings
	ld a,(de)		; $4801
	or a			; $4802
	ld bc,-$100		; $4803
	call nz,objectSetSpeedZ		; $4806

	ld c,$08		; $4809
	call objectUpdateSpeedZ_paramC		; $480b
	call _ecom_decCounter2		; $480e
	ret nz			; $4811

	call _ecom_decCounter1		; $4812
	jp nz,_swoop_flyFurtherUp		; $4815

	ld (hl),60 ; [counter1]

	ld a,$0a		; $481a
	ld l,Enemy.state		; $481c
	ldi (hl),a		; $481e
	ld (hl),$00 ; [state2]

	call _swoop_getAngerLevel		; $4821
	ld hl,_swoop_framesBeforeAttacking		; $4824
	rst_addAToHl			; $4827
	ld a,(hl)		; $4828
	ld e,Enemy.var30		; $4829
	ld (de),a		; $482b

	call objectGetAngleTowardLink		; $482c
	ld e,Enemy.angle		; $482f
	ld (de),a		; $4831

	ld a,$00		; $4832
	jp enemySetAnimation		; $4834


; Flying around, getting closer to Link before stomping
_swoop_stateA:
	call _swoop_animate		; $4837
	call _swoop_getAngerLevel		; $483a

	ld hl,_swoop_speedVals		; $483d
	rst_addAToHl			; $4840
	ld a,(hl)		; $4841
	ld e,Enemy.speed		; $4842
	ld (de),a		; $4844

	ld e,Enemy.var30		; $4845
	ld a,(de)		; $4847
	or a			; $4848
	jr z,++			; $4849
	dec a			; $484b
	ld (de),a		; $484c
	jr nz,@updatePosition	; $484d
++
	ld c,$30		; $484f
	call objectCheckLinkWithinDistance		; $4851
	jr nc,@updatePosition	; $4854

	call _ecom_incState		; $4856
	inc l			; $4859
	ld (hl),$00 ; [state2]
	ld l,Enemy.counter1		; $485c
	ld (hl),30		; $485e
	ret			; $4860

@updatePosition:
	call _ecom_decCounter1		; $4861
	jr nz,++		; $4864
	call objectGetAngleTowardLink		; $4866
	ld e,Enemy.angle		; $4869
	ld (de),a		; $486b
	ld e,Enemy.counter1		; $486c
	ld a,60		; $486e
	ld (de),a		; $4870
++
	jp _ecom_applyVelocityForSideviewEnemy		; $4871


; Stomping
_swoop_stateB:
	ld e,Enemy.state2		; $4874
	ld a,(de)		; $4876
	rst_jumpTable			; $4877
	.dw @substate0
	.dw @substate1
	.dw _swoop_stomp_substate2
	.dw _swoop_stomp_substate3

; Flapping wings quickly, telegraphing stomp is about to begin
@substate0:
	call _swoop_animate		; $4880
	call _swoop_animate		; $4883
	call _ecom_decCounter1		; $4886
	jr z,@beginStomp	; $4889

	ld a,(hl) ; [counter1]
	cp $0a			; $488c
	ret nz			; $488e

	; Decide on target position to stomp at, store in var31
	ld hl,w1Link.yh		; $488f
	ldi a,(hl)		; $4892
	ld b,a			; $4893
	inc l			; $4894
	ld c,(hl) ; [w1Link.xh]
	call getTileAtPosition		; $4896
	ld a,l			; $4899
	ld e,Enemy.var31		; $489a
	ld (de),a		; $489c

	; Convert to long-form, store in var32/var33
	call convertShortToLongPosition		; $489d
	ld e,Enemy.var32		; $48a0
	ld a,b			; $48a2
	and $f0			; $48a3
	ld (de),a		; $48a5
	inc e			; $48a6
	ld a,c			; $48a7
	ld (de),a		; $48a8

	; Get angle toward stomp position
	ld e,Enemy.yh		; $48a9
	call objectGetRelativeAngle		; $48ab
	ld e,Enemy.angle		; $48ae
	ld (de),a		; $48b0
	ret			; $48b1

@beginStomp:
	call _ecom_incState2		; $48b2
	ld l,Enemy.speed		; $48b5
	ld (hl),SPEED_200		; $48b7

	ld l,Enemy.collisionType		; $48b9
	set 7,(hl)		; $48bb

	ld bc,$0000		; $48bd
	call objectSetSpeedZ		; $48c0
	ld a,$02		; $48c3
	jp enemySetAnimation		; $48c5

; Moving toward stomp position while falling to ground
@substate1:
	; Get target stomp position
	ld h,d			; $48c8
	ld l,Enemy.var32		; $48c9
	ldi a,(hl)		; $48cb
	ld c,(hl)		; $48cc
	ld b,a			; $48cd

	; Compare with current position
	ld e,Enemy.yh		; $48ce
	ld l,e			; $48d0
	ldi a,(hl)		; $48d1
	and $fe			; $48d2
	cp b			; $48d4
	jr nz,++		; $48d5
	inc l			; $48d7
	ld a,(hl)		; $48d8
	and $fe			; $48d9
	cp c			; $48db
	jr z,+++		; $48dc
++
	; Must still move toward target position
	call objectGetRelativeAngle		; $48de
	ld e,Enemy.angle		; $48e1
	ld (de),a		; $48e3
	call _ecom_applyVelocityForSideviewEnemy		; $48e4
+++
	ld c,$10		; $48e7
	call objectUpdateSpeedZ_paramC		; $48e9
	ret nz			; $48ec

	; Hit the ground.
	call _swoop_hitGround		; $48ed
	call _ecom_incState2		; $48f0
	ld e,Enemy.health		; $48f3
	ld a,(de)		; $48f5
	cp $0a			; $48f6
	jr nc,_swoop_setVisible	; $48f8

	; Health is low; will bounce either 2 or 3 times.
	inc (hl) ; [state2] = 3

	; [counter1] = number of bounces
	call getRandomNumber		; $48fb
	and $01			; $48fe
	inc a			; $4900
	ld l,Enemy.counter1		; $4901
	ld (hl),a		; $4903

	ld l,Enemy.speed		; $4904
	ld (hl),SPEED_100		; $4906

	call objectGetAngleTowardLink		; $4908
	ld e,Enemy.angle		; $490b
	ld (de),a		; $490d

_swoop_setSpeedZForBounce:
	ld bc,-$100		; $490e
	jp objectSetSpeedZ		; $4911

_swoop_setVisible:
	jp objectSetVisible82		; $4914


; Completed stomp, about to fly back up.
_swoop_stomp_substate2:
	call _swoop_animate		; $4917

	; Wait until animation signals to fly up again, or Link attacks
	ld e,Enemy.invincibilityCounter		; $491a
	ld a,(de)		; $491c
	and $7f			; $491d
	jr nz,@flyBackUp		; $491f

	ld e,Enemy.animParameter		; $4921
	ld a,(de)		; $4923
	or a			; $4924
	ret z			; $4925

@flyBackUp:
	ld bc,$0000		; $4926
	call objectSetSpeedZ		; $4929

	ld l,Enemy.state		; $492c
	ld a,$09		; $492e
	ldi (hl),a		; $4930
	ld (hl),$00 ; [state2]

	ld l,Enemy.collisionType		; $4933
	res 7,(hl)		; $4935

;;
; @addr{4937}
_swoop_beginFlyingUp:
	ld l,Enemy.counter1		; $4937
	ld (hl),$03 ; 3 flaps before he goes to next state

;;
; @addr{493b}
_swoop_flyFurtherUp:
	ld l,Enemy.counter2		; $493b
	ld (hl),$30 ; $30 frames per wing flap
	call objectSetVisible80		; $493f
	ld a,$03		; $4942
	jp enemySetAnimation		; $4944


; Bouncing
_swoop_stomp_substate3:
	call _ecom_applyVelocityForSideviewEnemy		; $4947
	ld c,$10		; $494a
	call objectUpdateSpeedZ_paramC		; $494c
	ret nz			; $494f

	call _swoop_hitGround		; $4950
	call _ecom_decCounter1		; $4953
	jr nz,_swoop_setSpeedZForBounce	; $4956

	ld l,Enemy.state2		; $4958
	dec (hl)		; $495a
	jp objectSetVisible82		; $495b


;;
; @param[out]	a	Value from 0-2
; @addr{495e}
_swoop_getAngerLevel:
	ld b,$00		; $495e
	ld e,Enemy.health		; $4960
	ld a,(de)		; $4962
	cp $0a			; $4963
	jr nc,++		; $4965
	inc b			; $4967
	cp $06			; $4968
	jr nc,++		; $496a
	inc b			; $496c
++
	ld a,b			; $496d
	ret			; $496e

;;
; @addr{496f}
_swoop_hitGround:
	ld a,$30		; $496f
	call setScreenShakeCounter		; $4971
	ld a,SND_DOORCLOSE		; $4974
	call playSound		; $4976

	; Replace tile at this position if it's of the appropriate type, and not solid.
	ld bc,$0500		; $4979
	call objectGetRelativeTile		; $497c
	ld c,l			; $497f
	ld h,>wRoomCollisions		; $4980
	ld a,(hl)		; $4982
	cp $0f			; $4983
	ret z			; $4985

	ld h,>wRoomLayout		; $4986
	ld a,(hl)		; $4988
	cp $a2			; $4989
	ret z			; $498b
	cp $48			; $498c
	ret z			; $498e

	ld a,$48		; $498f
	call setTile		; $4991

	ld b,INTERACID_ROCKDEBRIS		; $4994
	jp objectCreateInteractionWithSubid00		; $4996


;;
; @param[out]	de	animParameter (if nonzero, just flapped wings)
; @addr{4999}
_swoop_animate:
	call enemyAnimate		; $4999
	ld e,Enemy.animParameter		; $499c
	ld a,(de)		; $499e
	or a			; $499f
	ret z			; $49a0
	ld a,SND_JUMP		; $49a1
	jp playSound		; $49a3

_swoop_speedVals:
	.db SPEED_80, SPEED_100, SPEED_180

_swoop_framesBeforeAttacking:
	.db 255, 150, 60


; ==============================================================================
; ENEMYID_SUBTERROR
;
; Variables:
;   var30: If nonzero, dirt is created at subterror's position every 8 frames.
;   var31: Counter until a new dirt object (PARTID_SUBTERROR_DIRT) is created.
; ==============================================================================
enemyCode72:
	jr z,@normalStatus	; $49ac
	sub ENEMYSTATUS_NO_HEALTH			; $49ae
	ret c			; $49b0
	jr nz,@normalStatus	; $49b1
	jp _enemyBoss_dead		; $49b3

@normalStatus:
	ld e,Enemy.var30		; $49b6
	ld a,(de)		; $49b8
	or a			; $49b9
	call nz,_subterror_spawnDirtEvery8Frames		; $49ba
	ld e,Enemy.state		; $49bd
	ld a,(de)		; $49bf
	rst_jumpTable			; $49c0
	.dw _subterror_state_uninitialized
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state_stub
	.dw _subterror_state8
	.dw _subterror_state9
	.dw _subterror_stateA
	.dw _subterror_stateB
	.dw _subterror_stateC


_subterror_state_uninitialized:
	ld a,ENEMYID_SUBTERROR		; $49db
	ld b,PALH_be		; $49dd
	call _enemyBoss_initializeRoom		; $49df
	call _ecom_setSpeedAndState8		; $49e2

	ld a,$07		; $49e5
	ld l,Enemy.var31		; $49e7
	ldd (hl),a ; [var31] = 7
	ld (hl),a  ; [var30] = 7

	ld l,Enemy.speed		; $49eb
	ld (hl),SPEED_180		; $49ed
	ld l,Enemy.angle		; $49ef
	ld (hl),ANGLE_DOWN		; $49f1

	ld l,Enemy.counter2		; $49f3
	ld (hl),30		; $49f5
	ret			; $49f7


_subterror_state_stub:
	ret			; $49f8


; Cutscene before fight
_subterror_state8:
	ld e,Enemy.state2		; $49f9
	ld a,(de)		; $49fb
	rst_jumpTable			; $49fc
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,DISABLE_LINK		; $4a05
	ld (wDisabledObjects),a		; $4a07
	ld (wMenuDisabled),a		; $4a0a

	; Wait for door to close
	ld a,($cc93)		; $4a0d
	or a			; $4a10
	ret nz			; $4a11

	call _ecom_decCounter2		; $4a12
	ret nz			; $4a15

	; Move further down
	call objectApplySpeed		; $4a16
	ld e,Enemy.yh		; $4a19
	ld a,(de)		; $4a1b
	cp $58			; $4a1c
	ret c			; $4a1e

	; Reached middle of screen, about to pop out

	ld a,SND_DIG		; $4a1f
	call playSound		; $4a21

	ld a,$06		; $4a24
	call enemySetAnimation		; $4a26
	call objectSetVisiblec2		; $4a29

	call _ecom_incState2		; $4a2c

	; Disable dirt animation
	ld l,Enemy.var30		; $4a2f
	ld (hl),$00		; $4a31

	call objectGetTileAtPosition		; $4a33
	ld c,l			; $4a36
	ld a,TILEINDEX_DUNGEON_DUG_DIRT		; $4a37
	jp setTile		; $4a39

@substate1:
	call _subterror_retFromCallerIfAnimationUnfinished		; $4a3c

	ld b,INTERACID_ROCKDEBRIS		; $4a3f
	call objectCreateInteractionWithSubid00		; $4a41

	call _ecom_incState2		; $4a44

	ld l,Enemy.counter1		; $4a47
	ld (hl),60		; $4a49

	ld bc,-$200		; $4a4b
	call objectSetSpeedZ		; $4a4e

	ld a,$05		; $4a51
	jp enemySetAnimation		; $4a53

@substate2:
	ld c,$10		; $4a56
	call objectUpdateSpeedZ_paramC		; $4a58
	ret nz			; $4a5b

	ld a,$02		; $4a5c
	call enemySetAnimation		; $4a5e
	call _ecom_decCounter1		; $4a61
	ret nz			; $4a64

	ld bc,TX_2f03		; $4a65
	call showText		; $4a68
	jp _ecom_incState2		; $4a6b

@substate3:
	call retIfTextIsActive		; $4a6e

	call _enemyBoss_beginMiniboss		; $4a71
	xor a			; $4a74
	ld (wDisabledObjects),a		; $4a75
	ld (wMenuDisabled),a		; $4a78


_subterror_digIntoGround:
	ld e,Enemy.state		; $4a7b
	ld a,$09		; $4a7d
	ld (de),a		; $4a7f

	ld a,$04		; $4a80
	jp enemySetAnimation		; $4a82


; Digging into ground
_subterror_state9:
	call _subterror_retFromCallerIfAnimationUnfinished		; $4a85

	; Done digging, about to start moving around
_subterror_beginUndergroundMovement:
	ld h,d			; $4a88
	ld l,Enemy.state		; $4a89
	ld (hl),$0a		; $4a8b
	inc l			; $4a8d
	xor a			; $4a8e
	ld (hl),a ; [state2]

	dec a			; $4a90
	ld l,Enemy.angle		; $4a91
	ld (hl),a ; [angle] = $ff

	ld l,Enemy.visible		; $4a94
	res 7,(hl)		; $4a96

	ld l,Enemy.enemyCollisionMode		; $4a98
	ld (hl),ENEMYCOLLISION_SUBTERROR_UNDERGROUND		; $4a9a

	ld l,Enemy.counter1		; $4a9c
	ld (hl),60		; $4a9e

	call _subterror_getAngerLevel		; $4aa0
	ld hl,_subterror_timeUntilDrillAttack		; $4aa3
	rst_addAToHl			; $4aa6
	ld a,(hl)		; $4aa7
	ld e,Enemy.counter2		; $4aa8
	ld (de),a		; $4aaa

	ld a,SND_DIG		; $4aab
	call playSound		; $4aad
	jp _subterror_spawnDirt		; $4ab0


; Currently in the ground, moving around
_subterror_stateA:
	ld e,Enemy.state2		; $4ab3
	ld a,(de)		; $4ab5
	rst_jumpTable			; $4ab6
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Staying underground for [counter1] frames before moving
@substate0:
	call _ecom_decCounter1		; $4abd
	ret nz			; $4ac0

	call _ecom_incState2		; $4ac1

@resetUndergroundMovement:
	; Adjust angle toward Link?
	call objectGetAngleTowardLink		; $4ac4
	ld c,a			; $4ac7
	ld e,Enemy.angle		; $4ac8
	ld a,(de)		; $4aca
	xor $10			; $4acb
	cp c			; $4acd
	ld a,c			; $4ace
	jr nz,+			; $4acf
	add $08			; $4ad1
	and $1f			; $4ad3
+
	ld (de),a		; $4ad5

	ld e,Enemy.counter1		; $4ad6
	ld a,30		; $4ad8
	ld (de),a		; $4ada

	call _subterror_getAngerLevel		; $4adb
	ld hl,_subterror_speedVals		; $4ade
	rst_addAToHl			; $4ae1
	ld a,(hl)		; $4ae2
	ld e,Enemy.speed		; $4ae3
	ld (de),a		; $4ae5

	ld a,$0a		; $4ae6
	call objectSetCollideRadius		; $4ae8
	jp _subterror_spawnDirt		; $4aeb

; Moving around until shovel is used or he starts drilling
@substate1:
	ld e,Enemy.var2a		; $4aee
	ld a,(de)		; $4af0
	sla a			; $4af1
	jr nc,@noShovel	; $4af3
	cp ITEMCOLLISION_SHOVEL<<1			; $4af5
	jr nz,@noShovel	; $4af7

	; Shovel was used; will now pop out of ground

	ld bc,-$100		; $4af9
	call objectSetSpeedZ		; $4afc
	ld l,Enemy.speed		; $4aff
	ld (hl),SPEED_100		; $4b01

	ld a,$0c		; $4b03
	ld l,Enemy.state		; $4b05
	ldi (hl),a		; $4b07
	xor a			; $4b08
	ld (hl),a ; [state2] = 0

	ld l,Enemy.var30		; $4b0a
	ld (hl),a ; [var30] = 0

	inc a			; $4b0d
	ld l,Enemy.counter1		; $4b0e
	ld (hl),a ; [counter1] = 1

	ld l,Enemy.visible		; $4b11
	set 7,(hl)		; $4b13

	; Bounces away from Link
	call objectGetAngleTowardLink		; $4b15
	xor $10			; $4b18
	ld e,Enemy.angle		; $4b1a
	ld (de),a		; $4b1c

	ld a,$06		; $4b1d
	call objectSetCollideRadius		; $4b1f
	ld a,$05		; $4b22
	jp enemySetAnimation		; $4b24

@noShovel:
	call objectApplySpeed		; $4b27
	ld a,$01		; $4b2a
	call _ecom_getSideviewAdjacentWallsBitset		; $4b2c
	jr z,++			; $4b2f

	; Hit wall
	call _ecom_incState2		; $4b31
	ld l,Enemy.counter1		; $4b34
	ld (hl),90		; $4b36
	ld l,Enemy.visible		; $4b38
	res 7,(hl)		; $4b3a
	ld l,Enemy.var30		; $4b3c
	ld (hl),$00		; $4b3e
	ret			; $4b40
++
	call _ecom_decCounter1		; $4b41
	call z,@resetUndergroundMovement		; $4b44
	call _ecom_decCounter2		; $4b47
	ret nz			; $4b4a

	; If Link is close enough, drill him
	ld c,$18		; $4b4b
	call objectCheckLinkWithinDistance		; $4b4d
	ret nc			; $4b50

	; "Transport" to the tile at Link's position
	ld hl,w1Link.yh		; $4b51
	ldi a,(hl)		; $4b54
	inc l			; $4b55
	ld c,(hl)		; $4b56
	ld b,a			; $4b57
	call getTileAtPosition		; $4b58
	ld c,l			; $4b5b
	call convertShortToLongPosition_paramC		; $4b5c
	ld e,Enemy.yh		; $4b5f
	ld a,b			; $4b61
	ld (de),a		; $4b62
	ld e,Enemy.xh		; $4b63
	ld a,c			; $4b65
	ld (de),a		; $4b66

	call _ecom_incState ; [state] = $0b
	inc l			; $4b6a
	xor a			; $4b6b
	ld (hl),a ; [state2] = 0

	ld l,Enemy.var30		; $4b6d
	ld (hl),a ; [var30] = 0

	ld a,60		; $4b70
	ld l,Enemy.counter1		; $4b72
	ldi (hl),a		; $4b74
	sra a			; $4b75
	ld (hl),a ; [counter2] = 30

	ld a,$06		; $4b78
	call objectSetCollideRadius		; $4b7a
	ld a,$06		; $4b7d
	jp enemySetAnimation		; $4b7f

; Hit a wall; pause before resuming
@substate2:
	call _ecom_decCounter2		; $4b82
	call _ecom_decCounter1		; $4b85
	ret nz			; $4b88
	ld l,Enemy.state2		; $4b89
	dec (hl)		; $4b8b
	jp @resetUndergroundMovement		; $4b8c


; Drilling
_subterror_stateB:
	ld e,Enemy.state2		; $4b8f
	ld a,(de)		; $4b91
	rst_jumpTable			; $4b92
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d			; $4b97
	ld l,Enemy.counter2		; $4b98
	ld a,(hl)		; $4b9a
	or a			; $4b9b
	jr z,@drilling	; $4b9c

	dec (hl)		; $4b9e
	ret nz			; $4b9f

	; Just started drilling
	ld l,Enemy.enemyCollisionMode		; $4ba0
	ld (hl),ENEMYCOLLISION_SUBTERROR_DRILLING		; $4ba2
	ld l,Enemy.visible		; $4ba4
	set 7,(hl)		; $4ba6
	ld a,SND_SHOCK		; $4ba8
	call playSound		; $4baa

@drilling:
	call enemyAnimate		; $4bad
	call _ecom_decCounter1		; $4bb0
	ret nz			; $4bb3

	ld l,Enemy.counter1		; $4bb4
	ld (hl),60		; $4bb6
	ld a,$07		; $4bb8
	call enemySetAnimation		; $4bba
	jp _ecom_incState2		; $4bbd

@substate1:
	call _subterror_retFromCallerIfAnimationUnfinished		; $4bc0
	call _subterror_beginUndergroundMovement		; $4bc3
	ld e,Enemy.var30		; $4bc6
	xor a			; $4bc8
	ld (de),a		; $4bc9
	ret			; $4bca


; Popping out of ground after shovel was used
_subterror_stateC:
	ld e,Enemy.state2		; $4bcb
	ld a,(de)		; $4bcd
	rst_jumpTable			; $4bce
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _ecom_applyVelocityForSideviewEnemy		; $4bd5
	ld c,$10		; $4bd8
	call objectUpdateSpeedZ_paramC		; $4bda
	ret nz			; $4bdd

	ld e,Enemy.var2a		; $4bde
	ld (de),a ; [var2a] = 0

	ld e,Enemy.enemyCollisionMode		; $4be1
	ld a,ENEMYCOLLISION_STANDARD_MINIBOSS		; $4be3
	ld (de),a		; $4be5

	call _ecom_decCounter1		; $4be6
	jr z,++			; $4be9
	ld l,Enemy.counter1		; $4beb
	ld (hl),180		; $4bed
	jp _ecom_incState2		; $4bef
++
	ld bc,-$80		; $4bf2
	jp objectSetSpeedZ		; $4bf5

@substate1:
	ld e,Enemy.var2a		; $4bf8
	ld a,(de)		; $4bfa
	or a			; $4bfb
	jr nz,++		; $4bfc
	call enemyAnimate		; $4bfe
	call _ecom_decCounter1		; $4c01
	ret nz			; $4c04
++
	call _ecom_incState2		; $4c05

	call getRandomNumber		; $4c08
	and $1c			; $4c0b
	ld l,Enemy.angle		; $4c0d
	ld (hl),a		; $4c0f

	ld l,Enemy.speed		; $4c10
	ld (hl),SPEED_80		; $4c12

	call getRandomNumber		; $4c14
	and $03			; $4c17
	ld hl,_subterror_durationAboveGround		; $4c19
	rst_addAToHl			; $4c1c
	ldi a,(hl)		; $4c1d
	ld e,Enemy.counter1		; $4c1e
	ld (de),a		; $4c20

	jp _subterror_setAnimationFromAngle		; $4c21

@substate2:
	call enemyAnimate		; $4c24

	ld e,Enemy.animParameter		; $4c27
	ld a,(de)		; $4c29
	or a			; $4c2a
	ld a,SND_LAND		; $4c2b
	call nz,playSound		; $4c2d

	call objectApplySpeed		; $4c30
	call _ecom_bounceOffWallsAndHoles		; $4c33
	call nz,_subterror_setAnimationFromAngle		; $4c36

	; Dig back into ground when [counter1] reaches 0
	call _ecom_decCounter1		; $4c39
	ret nz			; $4c3c
	jp _subterror_digIntoGround		; $4c3d


;;
; @addr{4c40}
_subterror_spawnDirtEvery8Frames:
	inc e			; $4c40
	ld a,(de) ; [var31]
	dec a			; $4c42
	ld (de),a		; $4c43
	ret nz			; $4c44

;;
; @addr{4c45}
_subterror_spawnDirt:
	ld e,Enemy.var31		; $4c45
	ld a,$07		; $4c47
	ld (de),a ; [var31] = 7
	dec e			; $4c4a
	ld (de),a ; [var30] = 7

	ld b,PARTID_SUBTERROR_DIRT		; $4c4c
	call _ecom_spawnProjectile		; $4c4e

	call objectGetTileAtPosition		; $4c51
	ld c,l			; $4c54
	ld a,$ef		; $4c55
	jp setTile		; $4c57

;;
; @addr{4c5a}
_subterror_retFromCallerIfAnimationUnfinished:
	call enemyAnimate		; $4c5a
	ld h,d			; $4c5d
	ld l,Enemy.animParameter		; $4c5e
	ld a,(hl)		; $4c60
	or a			; $4c61
	ret nz			; $4c62
	pop af			; $4c63
	ret			; $4c64

;;
; @param[out]	a	Anger level (0-2)
; @addr{4c65}
_subterror_getAngerLevel:
	ld b,$00		; $4c65
	ld e,Enemy.health		; $4c67
	ld a,(de)		; $4c69
	cp $0a			; $4c6a
	jr nc,++		; $4c6c
	inc b			; $4c6e
	cp $06			; $4c6f
	jr nc,++		; $4c71
	inc b			; $4c73
++
	ld a,b			; $4c74
	ret			; $4c75

;;
; @addr{4c76}
_subterror_setAnimationFromAngle:
	ld h,d			; $4c76
	ld l,Enemy.angle		; $4c77
	ldd a,(hl)		; $4c79
	add a			; $4c7a
	swap a			; $4c7b
	and $03			; $4c7d
	ld (hl),a ; [direction]
	add $00			; $4c80
	jp enemySetAnimation		; $4c82


_subterror_speedVals: ; Chosen based on "anger level"
	.db SPEED_80 SPEED_100 SPEED_180

_subterror_timeUntilDrillAttack: ; Chosen based on "anger level"
	.db 120 90 60

_subterror_durationAboveGround: ; Chosen randomly
	.db 60 90 120 180


; ==============================================================================
; ENEMYID_ARMOS_WARRIOR
;
; Variables (for parent only, subid 1):
;   var30: "Turn" direction (should be 8 or -8)
;   var31: Shield
;   var32: Sword
;
; Variables (for shield only, subid 2):
;   relatedObj1: parent
;   relatedObj2: shield
;   var30: Animation index (0 or 1)
;   var31: Animation base (multiple of 2, for broken shield animation)
;   var32: Hits until destruction
;
; Variables (for sword only, subid 3):
;   relatedObj1: parent
;   relatedObj2: shield
;   var30/var31: Target position
;   var32/var33: Base position (yh and xh are manipulated by the animation to fix their
;                collision box, so need to be reset to these values each frame)
;   var34: If nonzero, checks for collision with shield
; ==============================================================================
enemyCode73:
	jr z,@normalStatus	; $4c8f
	sub ENEMYSTATUS_NO_HEALTH			; $4c91
	ret c			; $4c93
	jr nz,@normalStatus	; $4c94

	; ENEMYSTATUS_DEAD

	ld e,Enemy.subid		; $4c96
	ld a,(de)		; $4c98
	dec a			; $4c99
	jp z,_enemyBoss_dead		; $4c9a

	dec a			; $4c9d
	jr nz,@delete	; $4c9e

	; Subid 2 (shield) just destroyed

	; Destroy sword
	call _ecom_killRelatedObj2		; $4ca0

	; Set some variables on parent
	ld a,Object.state		; $4ca3
	call objectGetRelatedObject1Var		; $4ca5
	ld (hl),$0d		; $4ca8

	ld l,Enemy.counter1		; $4caa
	ld (hl),90		; $4cac

	ld l,Enemy.invincibilityCounter		; $4cae
	ld (hl),$60		; $4cb0

@delete:
	jp enemyDelete		; $4cb2

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $4cb5
	jr nc,@normalState	; $4cb8
	rst_jumpTable			; $4cba
	.dw _armosWarrior_state_uninitialized
	.dw _armosWarrior_state_spawner
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub
	.dw _armosWarrior_state_stub

@normalState:
	dec b			; $4ccb
	ld a,b			; $4ccc
	rst_jumpTable			; $4ccd
	.dw _armosWarrior_parent
	.dw _armosWarrior_shield
	.dw _armosWarrior_sword


_armosWarrior_state_uninitialized:
	ld a,b			; $4cd4
	or a			; $4cd5
	jp nz,_ecom_setSpeedAndState8		; $4cd6

	; Spawner only

	inc a			; $4cd9
	ld (de),a ; [state] = 1
	ld (wDisabledObjects),a		; $4cdb
	ld (wMenuDisabled),a		; $4cde

	ld a,ENEMYID_ARMOS_WARRIOR		; $4ce1
	jp _enemyBoss_initializeRoom		; $4ce3


_armosWarrior_state_spawner:
	ld b,$03		; $4ce6
	call checkBEnemySlotsAvailable		; $4ce8
	ret nz			; $4ceb

	ld c,$0c		; $4cec
	call _ecom_setZAboveScreen		; $4cee

	; Spawn parent
	ld b,ENEMYID_ARMOS_WARRIOR		; $4cf1
	call _ecom_spawnUncountedEnemyWithSubid01		; $4cf3
	ld c,h			; $4cf6

	; Spawn shield
	call _ecom_spawnUncountedEnemyWithSubid01		; $4cf7
	inc (hl) ; [shield.subid] = 2

	; [shield.relatedObj1] = parent
	ld l,Enemy.relatedObj1		; $4cfb
	ld a,Enemy.start		; $4cfd
	ldi (hl),a		; $4cff
	ld (hl),c		; $4d00

	call objectCopyPosition		; $4d01
	push hl			; $4d04

	; Spawn sword
	call _ecom_spawnUncountedEnemyWithSubid01		; $4d05
	ld (hl),$03 ; [sword.subid] = 3

	; [sword.relatedObj1] = parent
	ld l,Enemy.relatedObj1		; $4d0a
	ld a,Enemy.start		; $4d0c
	ldi (hl),a		; $4d0e
	ld (hl),c		; $4d0f

	call objectCopyPosition		; $4d10

	; [parent.var31] = shield
	; [parent.var32] = sword
	ld b,h			; $4d13
	pop hl			; $4d14
	ld a,h			; $4d15
	ld h,c			; $4d16
	ld l,Enemy.var31		; $4d17
	ldi (hl),a		; $4d19
	ld (hl),b		; $4d1a

	call objectCopyPosition		; $4d1b

	; Transfer enabled byte to parent
	ld l,Enemy.enabled		; $4d1e
	ld e,l			; $4d20
	ld a,(de)		; $4d21
	ld (hl),a		; $4d22

	jp enemyDelete		; $4d23


_armosWarrior_state_stub:
	ret			; $4d26


_armosWarrior_parent:
	ld a,(de)		; $4d27
	sub $08			; $4d28
	rst_jumpTable			; $4d2a
	.dw _armosWarrior_parent_state8
	.dw _armosWarrior_parent_state9
	.dw _armosWarrior_parent_stateA
	.dw _armosWarrior_parent_stateB
	.dw _armosWarrior_parent_stateC
	.dw _armosWarrior_parent_stateD
	.dw _armosWarrior_parent_stateE
	.dw _armosWarrior_parent_stateF
	.dw _armosWarrior_parent_state10


; Waiting for door to close
_armosWarrior_parent_state8:
	ld a,($cc93)		; $4d3d
	or a			; $4d40
	ret nz			; $4d41

	ldbc $01,$08		; $4d42
	call _enemyBoss_spawnShadow		; $4d45
	ret nz			; $4d48

	ld h,d			; $4d49
	ld l,e			; $4d4a
	inc (hl) ; [state]

	ld l,Enemy.speed		; $4d4c
	ld (hl),SPEED_80		; $4d4e

	ld l,Enemy.enemyCollisionMode		; $4d50
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_PROTECTED		; $4d52
	jp objectSetVisible82		; $4d54


; Cutscene before fight starts (falling from sky)
_armosWarrior_parent_state9:
	inc e			; $4d57
	ld a,(de) ; [state2]
	rst_jumpTable			; $4d59
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld c,$20		; $4d64
	call objectUpdateSpeedZ_paramC		; $4d66
	ret nz			; $4d69

	; Hit the ground

	ld l,Enemy.state2		; $4d6a
	inc (hl)		; $4d6c

	inc l			; $4d6d
	ld a,$1a		; $4d6e
	ld (hl),a ; [counter1]
	ld (wScreenShakeCounterY),a		; $4d71
	ld (wScreenShakeCounterX),a		; $4d74

	; [sword.zh] = [parent.zh]
	ld l,Enemy.var32		; $4d77
	ld h,(hl)		; $4d79
	ld l,Enemy.zh		; $4d7a
	ld e,l			; $4d7c
	ld a,(de)		; $4d7d
	ld (hl),a		; $4d7e

	ld a,SND_STRONG_POUND		; $4d7f
	jp playSound		; $4d81

@substate1:
	call _ecom_decCounter1		; $4d84
	ret nz			; $4d87
	ld l,e			; $4d88
	inc (hl) ; [state2]
	ld bc,TX_2f01		; $4d8a
	jp showText		; $4d8d

@substate2:
	ld h,d			; $4d90
	ld l,e			; $4d91
	inc (hl) ; [state2]

	ld l,Enemy.counter1		; $4d93
	ld (hl),30		; $4d95

	call _enemyBoss_beginMiniboss		; $4d97
	ld a,$02		; $4d9a
	jp enemySetAnimation		; $4d9c

@substate3:
	call _ecom_decCounter1		; $4d9f
	ret nz			; $4da2

	ld (hl),70 ; [counter1]
	ld l,Enemy.angle		; $4da5
	ld (hl),ANGLE_DOWN		; $4da7

	ld l,e			; $4da9
	inc (hl) ; [state2]

	; [sword.yh] -= 2
	ld l,Enemy.var32		; $4dab
	ld h,(hl)		; $4dad
	ld l,Enemy.yh		; $4dae
	ld a,(hl)		; $4db0
	sub $02			; $4db1
	ldi (hl),a		; $4db3

	; [sword.xh] -= 1
	inc l			; $4db4
	dec (hl)		; $4db5

	xor a			; $4db6
	jp enemySetAnimation		; $4db7

; Sword moving up, parent moving down
@substate4:
	call _ecom_decCounter1		; $4dba
	jr nz,++		; $4dbd

	ld l,Enemy.state		; $4dbf
	inc (hl)		; $4dc1

	ld l,Enemy.angle		; $4dc2
	ld (hl),ANGLE_LEFT		; $4dc4

	ld l,Enemy.var30		; $4dc6
	ld (hl),$08		; $4dc8
++
	call objectApplySpeed		; $4dca
	jp enemyAnimate		; $4dcd


; Deciding which direction to move in next
_armosWarrior_parent_stateA:
	; If the armos is moving directly toward his sword, reverse direction
	ld e,Enemy.var32		; $4dd0
	ld a,(de)		; $4dd2
	ld h,a			; $4dd3
	ld l,Enemy.yh		; $4dd4
	ld b,(hl)		; $4dd6
	ld l,Enemy.xh		; $4dd7
	ld c,(hl)		; $4dd9
	call objectGetRelativeAngle		; $4dda
	add $04			; $4ddd
	and $18			; $4ddf
	ld b,a			; $4de1
	ld e,Enemy.angle		; $4de2
	ld a,(de)		; $4de4
	cp b			; $4de5
	jr nz,++		; $4de6

	; Reverse direction
	xor $10			; $4de8
	ld (de),a		; $4dea
	ld e,Enemy.var30		; $4deb
	ld a,(de)		; $4ded
	cpl			; $4dee
	inc a			; $4def
	ld (de),a		; $4df0
++
	call _ecom_incState		; $4df1
	ld l,Enemy.counter1		; $4df4
	ld (hl),75		; $4df6
	jr _armosWarrior_parent_animate		; $4df8


; Moving in "box" pattern for [counter1] frames
_armosWarrior_parent_stateB:
	call _ecom_decCounter1		; $4dfa
	jr nz,_armosWarrior_parent_updateBoxMovement		; $4dfd
	ld l,e			; $4dff
	dec (hl) ; [state]

_armosWarrior_parent_updateBoxMovement:
	call _armosWarrior_parent_checkReachedTurningPoint		; $4e01
	jr nz,_armosWarrior_parent_animate	; $4e04

	; Hit one of the turning points in his movement pattern; turn 90 degrees
	ld h,d			; $4e06
	ld l,Enemy.var30		; $4e07
	ld e,Enemy.angle		; $4e09
	ld a,(de)		; $4e0b
	add (hl)		; $4e0c
	and $18			; $4e0d
	ld (de),a		; $4e0f

_armosWarrior_parent_animate:
	jp enemyAnimate		; $4e10


; Shield just hit
_armosWarrior_parent_stateC:
	call enemyAnimate		; $4e13
	call _ecom_decCounter1		; $4e16
	jr nz,_armosWarrior_parent_updateBoxMovement	; $4e19

	ld l,Enemy.state		; $4e1b
	ld (hl),$0a		; $4e1d

	; Set speed based on number of shield hits
	ld l,Enemy.var31		; $4e1f
	ld h,(hl)		; $4e21
	ld l,Enemy.var32		; $4e22
	ld a,(hl)		; $4e24
	ld hl,_armosWarrior_parent_speedVals		; $4e25
	rst_addAToHl			; $4e28
	ld e,Enemy.speed		; $4e29
	ld a,(hl)		; $4e2b
	ld (de),a		; $4e2c
	ret			; $4e2d


; Shield just destroyed
_armosWarrior_parent_stateD:
	call _ecom_decCounter1		; $4e2e
	jr z,@gotoNextState	; $4e31

	; Create debris at random offset every 8 frames
	ld a,(hl)		; $4e33
	and $07			; $4e34
	ret nz			; $4e36

	call getRandomNumber_noPreserveVars		; $4e37
	ld c,a			; $4e3a
	and $70			; $4e3b
	swap a			; $4e3d
	sub $04			; $4e3f
	ld b,a			; $4e41
	ld a,c			; $4e42
	and $0f			; $4e43
	ld c,a			; $4e45
	call getFreeInteractionSlot		; $4e46
	ret nz			; $4e49
	ld (hl),INTERACID_ROCKDEBRIS		; $4e4a
	jp objectCopyPositionWithOffset		; $4e4c

@gotoNextState:
	ld (hl),30 ; [counter1]
	ld l,e			; $4e51
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $4e53
	ld (hl),ENEMYCOLLISION_STANDARD_MINIBOSS		; $4e55

	ld l,Enemy.speed		; $4e57
	ld (hl),SPEED_200		; $4e59

	ld bc,TX_2f02		; $4e5b
	call showText		; $4e5e

	ld a,$01		; $4e61
	jp enemySetAnimation		; $4e63


; Standing still before charging Link
_armosWarrior_parent_stateE:
	call enemyAnimate		; $4e66
	call _ecom_decCounter1		; $4e69
	jr nz,_armosWarrior_parent_animate	; $4e6c
	ld l,Enemy.state		; $4e6e
	inc (hl)		; $4e70
	jp _ecom_updateAngleTowardTarget		; $4e71


; Charging
_armosWarrior_parent_stateF:
	call enemyAnimate		; $4e74
	ld a,$01		; $4e77
	call _ecom_getSideviewAdjacentWallsBitset		; $4e79
	jp z,objectApplySpeed		; $4e7c

	; Hit wall

	call _ecom_incState		; $4e7f
	ld l,Enemy.angle		; $4e82
	ld a,(hl)		; $4e84
	xor $10			; $4e85
	ld (hl),a		; $4e87

	ld l,Enemy.speedZ		; $4e88
	ld a,<(-$180)		; $4e8a
	ldi (hl),a		; $4e8c
	ld (hl),>(-$180)		; $4e8d

	ld l,Enemy.speed		; $4e8f
	ld (hl),SPEED_100		; $4e91

	ld a,30		; $4e93
	call setScreenShakeCounter		; $4e95

	ld a,SND_STRONG_POUND		; $4e98
	jp playSound		; $4e9a


; Recoiling from hitting wall
_armosWarrior_parent_state10:
	call enemyAnimate		; $4e9d
	ld c,$16		; $4ea0
	call objectUpdateSpeedZ_paramC		; $4ea2
	jp nz,objectApplySpeed		; $4ea5

	; Hit ground

	ld h,d			; $4ea8
	ld l,Enemy.state		; $4ea9
	ld (hl),$0e		; $4eab

	ld l,Enemy.speed		; $4ead
	ld (hl),SPEED_200		; $4eaf

	ld l,Enemy.counter1		; $4eb1
	ld (hl),60		; $4eb3
	ret			; $4eb5


_armosWarrior_shield:
	ld a,(de)		; $4eb6
	cp $08			; $4eb7
	jr z,@state8		; $4eb9

@state9:
	; Delete self if no hits remaining
	ld h,d			; $4ebb
	ld l,Enemy.var32		; $4ebc
	ld a,(hl)		; $4ebe
	or a			; $4ebf
	jp z,_ecom_killObjectH		; $4ec0

	ld a,Object.animParameter		; $4ec3
	call objectGetRelatedObject1Var		; $4ec5
	ld e,Enemy.var30		; $4ec8
	ld a,(de)		; $4eca
	cp (hl)			; $4ecb
	jr z,++			; $4ecc

	ld a,(hl)		; $4ece
	ld (de),a		; $4ecf
	ld e,Enemy.var31		; $4ed0
	ld a,(de)		; $4ed2
	add (hl)		; $4ed3
	call enemySetAnimation		; $4ed4
++
	jp _armosWarrior_shield_updatePosition		; $4ed7

; Uninitialized
@state8:
	ld a,($cc93)		; $4eda
	or a			; $4edd
	ret nz			; $4ede

	ld h,d			; $4edf
	ld l,e			; $4ee0
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $4ee2
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_SHIELD		; $4ee4

	ld l,Enemy.var32		; $4ee6
	ld (hl),$03		; $4ee8

	; [shield.relatedObj2] = sword (parent.var32)
	ld l,Enemy.relatedObj1+1		; $4eea
	ld h,(hl)		; $4eec
	ld l,Enemy.var32		; $4eed
	ld e,Enemy.relatedObj2		; $4eef
	ld a,Enemy.start		; $4ef1
	ld (de),a		; $4ef3
	inc e			; $4ef4
	ld a,(hl)		; $4ef5
	ld (de),a		; $4ef6

	ld e,Enemy.var31		; $4ef7
	ld a,$03		; $4ef9
	ld (de),a		; $4efb

	call enemySetAnimation		; $4efc
	call _armosWarrior_shield_updatePosition		; $4eff
	jp objectSetVisible81		; $4f02


_armosWarrior_sword:
	ld e,Enemy.state		; $4f05
	ld a,(de)		; $4f07
	cp $0b			; $4f08
	call nc,_armosWarrior_sword_playSlashSound		; $4f0a

	ld e,Enemy.state		; $4f0d
	ld a,(de)		; $4f0f
	sub $08			; $4f10
	rst_jumpTable			; $4f12
	.dw _armosWarrior_sword_state8
	.dw _armosWarrior_sword_state9
	.dw _armosWarrior_sword_stateA
	.dw _armosWarrior_sword_stateB
	.dw _armosWarrior_sword_stateC


; Waiting for door to close
_armosWarrior_sword_state8:
	ld a,($cc93)		; $4f1d
	or a			; $4f20
	ret nz			; $4f21

	ld h,d			; $4f22
	ld l,e			; $4f23
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $4f25
	ld (hl),ENEMYCOLLISION_ARMOS_WARRIOR_SWORD		; $4f27

	ld l,Enemy.speed		; $4f29
	ld (hl),SPEED_20		; $4f2b

	call _armosWarrior_sword_setPositionAsHeld		; $4f2d

	; [sword.relatedObj2] = shield (parent.var31)
	ld l,Enemy.var31		; $4f30
	ld e,Enemy.relatedObj2		; $4f32
	ld a,Enemy.start		; $4f34
	ld (de),a		; $4f36
	inc e			; $4f37
	ld a,(hl)		; $4f38
	ld (de),a		; $4f39

	ld a,$09		; $4f3a
	call enemySetAnimation		; $4f3c
	jp objectSetVisible80		; $4f3f


; Waiting for initial cutscene to end, then moving upward before fight starts
_armosWarrior_sword_state9:
	ld a,Object.state2		; $4f42
	call objectGetRelatedObject1Var		; $4f44
	ld a,(hl)		; $4f47
	or a			; $4f48
	jp z,_armosWarrior_sword_setPositionAsHeld		; $4f49

	sub $03			; $4f4c
	ret c			; $4f4e
	jr z,@parentSubstate3	; $4f4f

	dec l			; $4f51
	ld a,(hl) ; [parent.state]
	cp $0a			; $4f53
	jr nc,@gotoStateA	; $4f55
	call _armosWarrior_sword_playSlashSound		; $4f57
	jp enemyAnimate		; $4f5a

@gotoStateA:
	ld h,d			; $4f5d
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $4f5f
	ld (hl),$01		; $4f61

	; Save position
	ld e,Enemy.yh		; $4f63
	ld l,Enemy.var32		; $4f65
	ld a,(de)		; $4f67
	ldi (hl),a		; $4f68
	ld e,Enemy.xh		; $4f69
	ld a,(de)		; $4f6b
	ld (hl),a		; $4f6c
	ret			; $4f6d

@parentSubstate3:
	ld h,d			; $4f6e
	ld l,Enemy.counter1		; $4f6f
	ld a,(hl)		; $4f71
	inc (hl)		; $4f72

	or a			; $4f73
	ld a,$0a		; $4f74
	jp z,enemySetAnimation		; $4f76

	ld l,Enemy.yh		; $4f79
	dec (hl)		; $4f7b
	ret			; $4f7c


; Staying still before charging toward Link
_armosWarrior_sword_stateA:
	call _ecom_decCounter1		; $4f7d
	ret nz			; $4f80

	ld l,e			; $4f81
	inc (hl) ; [state]

	ld l,Enemy.speed		; $4f83
	ld (hl),SPEED_180		; $4f85

	ld l,Enemy.counter1		; $4f87
	ld (hl),150		; $4f89

	; Write target position to var30/var31
	ld l,Enemy.var30		; $4f8b
	ldh a,(<hEnemyTargetY)	; $4f8d
	ldi (hl),a		; $4f8f
	ldh a,(<hEnemyTargetX)	; $4f90
	ld (hl),a		; $4f92

	call _ecom_updateAngleTowardTarget		; $4f93
	call enemyAnimate		; $4f96
	jp _armosWarrior_sword_updateCollisionBox		; $4f99


; Charging toward target position
_armosWarrior_sword_stateB:
	call _armosWarrior_sword_checkCollisionWithShield		; $4f9c
	ld a,(wFrameCounter)		; $4f9f
	and $03			; $4fa2
	jr nz,++		; $4fa4

	; Update angle toward target position every 4 frames
	ld h,d			; $4fa6
	ld l,Enemy.var30		; $4fa7
	call _ecom_readPositionVars		; $4fa9
	call objectGetRelativeAngleWithTempVars		; $4fac
	ld e,Enemy.angle		; $4faf
	ld (de),a		; $4fb1
++
	call _armosWarrior_sword_checkWentTooFar		; $4fb2
	jr c,@beginSlowingDown	; $4fb5

	; If within 28 pixels of target position, start slowing down
	ld l,Enemy.var30		; $4fb7
	ld a,(hl)		; $4fb9
	sub b			; $4fba
	add 28			; $4fbb
	cp 57			; $4fbd
	jr nc,@notSlowingDown	; $4fbf
	inc l			; $4fc1
	ld a,(hl)		; $4fc2
	sub c			; $4fc3
	add 28			; $4fc4
	cp 57			; $4fc6
	jr nc,@notSlowingDown	; $4fc8

@beginSlowingDown:
	ld l,Enemy.state		; $4fca
	inc (hl)		; $4fcc
	ld l,Enemy.counter1		; $4fcd
	ld (hl),$70		; $4fcf

@notSlowingDown:
	call enemyAnimate		; $4fd1

_armosWarrior_sword_updatePosition:
	call _ecom_applyVelocityForTopDownEnemy		; $4fd4

	; Save position
	ld h,d			; $4fd7
	ld l,Enemy.yh		; $4fd8
	ld e,Enemy.var32		; $4fda
	ldi a,(hl)		; $4fdc
	ld (de),a		; $4fdd
	inc e			; $4fde
	inc l			; $4fdf
	ld a,(hl)		; $4fe0
	ld (de),a		; $4fe1

	jp _armosWarrior_sword_updateCollisionBox		; $4fe2


; Slowing down
_armosWarrior_sword_stateC:
	call _armosWarrior_sword_checkCollisionWithShield		; $4fe5
	call _ecom_decCounter1		; $4fe8
	jr z,@stoppedMoving	; $4feb

	ld a,(hl) ; [counter1]
	swap a			; $4fee
	rrca			; $4ff0
	and $03			; $4ff1
	ld hl,_armosWarrior_sword_speedVals		; $4ff3
	rst_addAToHl			; $4ff6
	ld e,Enemy.speed		; $4ff7
	ld a,(hl)		; $4ff9
	ld (de),a		; $4ffa

	; Restore position (which was manipulated for shield collision detection)
	ld h,d			; $4ffb
	ld l,Enemy.yh		; $4ffc
	ld e,Enemy.var32		; $4ffe
	ld a,(de)		; $5000
	ldi (hl),a		; $5001
	inc e			; $5002
	inc l			; $5003
	ld a,(de)		; $5004
	ld (hl),a		; $5005

	ld e,Enemy.counter1		; $5006
	ld a,(de)		; $5008
	cp 30			; $5009
	jr nc,+			; $500b
	rrca			; $500d
+
	call nc,enemyAnimate		; $500e
	jr _armosWarrior_sword_updatePosition		; $5011

@stoppedMoving:
	ld e,Enemy.animParameter		; $5013
	ld a,(de)		; $5015
	cp $07			; $5016
	jr z,@atRest			; $5018
	ld (hl),$02 ; [counter1]
	jp enemyAnimate		; $501c

@atRest:
	ld l,Enemy.state		; $501f
	ld (hl),$0a		; $5021
	ld l,Enemy.var34		; $5023
	ld (hl),$00		; $5025

	; Set counter1 (frames to rest) based on number of hits until shield destroyed
	ld a,Object.var32		; $5027
	call objectGetRelatedObject2Var		; $5029
	ld a,(hl)		; $502c
	swap a			; $502d
	rlca			; $502f
	add 30			; $5030
	ld e,Enemy.counter1		; $5032
	ld (de),a		; $5034

	ld a,$0a		; $5035
	jp enemySetAnimation		; $5037


;;
; Shield copies parent's position plus an offset
; @addr{503a}
_armosWarrior_shield_updatePosition:
	ld a,Object.yh		; $503a
	call objectGetRelatedObject1Var		; $503c
	ldi a,(hl) ; [parent.yh]
	ld b,a			; $5040
	inc l			; $5041
	ldi a,(hl) ; [parent.xh]
	ld c,a			; $5043

	inc l			; $5044
	ld e,l			; $5045
	ld a,(hl)		; $5046
	ld (de),a ; [shield.zh] = [parent.zh]

	ld e,Enemy.var30		; $5048
	ld a,(de)		; $504a
	ld hl,_armosWarrior_shield_YXOffsets		; $504b
	rst_addDoubleIndex			; $504e
	ld e,Enemy.yh		; $504f
	ldi a,(hl)		; $5051
	add b			; $5052
	ld (de),a		; $5053
	ld e,Enemy.xh		; $5054
	ld a,(hl)		; $5056
	add c			; $5057
	ld (de),a		; $5058
	ret			; $5059


;;
; Updates collisionRadiusY/X based on animParameter, also adds an offset to Y/X position.
; @addr{505a}
_armosWarrior_sword_updateCollisionBox:
	ld e,Enemy.animParameter		; $505a
	ld a,(de)		; $505c
	add a			; $505d
	ld hl,_armosWarrior_sword_collisionBoxes		; $505e
	rst_addDoubleIndex			; $5061

	ld e,Enemy.var32		; $5062
	ld a,(de)		; $5064
	add (hl)		; $5065
	ld e,Enemy.yh		; $5066
	ld (de),a		; $5068

	inc hl			; $5069
	ld e,Enemy.var33		; $506a
	ld a,(de)		; $506c
	add (hl)		; $506d
	ld e,Enemy.xh		; $506e
	ld (de),a		; $5070
	inc hl			; $5071

	ld e,Enemy.collisionRadiusY		; $5072
	ldi a,(hl)		; $5074
	ld (de),a		; $5075
	inc e			; $5076
	ld a,(hl)		; $5077
	ld (de),a		; $5078
	ret			; $5079


;;
; Sets the sword's position assuming it's being held by the parent.
; @addr{507a}
_armosWarrior_sword_setPositionAsHeld:
	ld a,Object.yh		; $507a
	call objectGetRelatedObject1Var		; $507c
	ld bc,$f4fa		; $507f
	jp objectTakePositionWithOffset		; $5082

;;
; @addr{5085}
_armosWarrior_sword_checkCollisionWithShield:
	ld e,Enemy.var34		; $5085
	ld a,(de)		; $5087
	dec a			; $5088
	ret z			; $5089

	; Check if sword and shield collide
	ld a,Object.collisionRadiusY		; $508a
	call objectGetRelatedObject2Var		; $508c
	ld c,Enemy.yh		; $508f
	call @checkIntersection		; $5091
	ret nc			; $5094

	ld c,Enemy.xh		; $5095
	ld l,$a7		; $5097
	call @checkIntersection		; $5099
	ret nc			; $509c

	; They've collided

	ld e,Enemy.var34		; $509d
	ld a,$01		; $509f
	ld (de),a		; $50a1

	; Set various variables on the shield
	ld l,Enemy.invincibilityCounter		; $50a2
	ld (hl),$18		; $50a4

	; [Hits until destruction]--
	ld l,Enemy.var32		; $50a6
	dec (hl)		; $50a8

	ld l,Enemy.var31		; $50a9
	ld a,(hl)		; $50ab
	add $02			; $50ac
	ld (hl),a		; $50ae

	; h = [shield.relatedObj1] = parent
	ld l,Enemy.relatedObj1+1		; $50af
	ld h,(hl)		; $50b1

	ld l,Enemy.counter1		; $50b2
	ld (hl),60		; $50b4

	ld l,Enemy.state		; $50b6
	ld (hl),$0c		; $50b8

	ld l,Enemy.speed		; $50ba
	ld (hl),SPEED_300		; $50bc

	ld l,Enemy.invincibilityCounter		; $50be
	ld (hl),$18		; $50c0

	ld a,SND_BOSS_DAMAGE		; $50c2
	jp playSound		; $50c4

;;
; Checks for intersection on a position component given two objects.
; @addr{50c7}
@checkIntersection:
	; b = [sword.collisionRadius] + [shield.collisionRadius]
	ld e,l			; $50c7
	ld a,(de)		; $50c8
	add (hl)		; $50c9
	ld b,a			; $50ca

	; a = [sword.pos] - [shield.pos]
	ld l,c			; $50cb
	ld e,l			; $50cc
	ld a,(de)		; $50cd
	sub (hl)		; $50ce

	add b			; $50cf
	sla b			; $50d0
	inc b			; $50d2
	cp b			; $50d3
	ret			; $50d4


;;
; The armos always moves in a "box" pattern in his first phase, this checks if he's
; reached one of the "corners" of the box where he must turn.
;
; @param[out]	zflag	z if hit a turning point
; @addr{50d5}
_armosWarrior_parent_checkReachedTurningPoint:
	ld b,$31		; $50d5
	ld e,Enemy.yh		; $50d7
	ld a,(de)		; $50d9
	cp $30			; $50da
	jr c,@hitCorner	; $50dc

	ld b,$7f		; $50de
	cp $80			; $50e0
	jr nc,@hitCorner	; $50e2

	ld b,$bf		; $50e4
	ld e,Enemy.xh		; $50e6
	ld a,(de)		; $50e8
	cp $c0			; $50e9
	jr nc,@hitCorner	; $50eb

	ld b,$31		; $50ed
	cp $30			; $50ef
	jr c,@hitCorner	; $50f1

	call objectApplySpeed		; $50f3
	or d			; $50f6
	ret			; $50f7

@hitCorner:
	ld a,b			; $50f8
	ld (de),a		; $50f9
	xor a			; $50fa
	ret			; $50fb


;;
; @param[out]	bc	Position of sword
; @param[out]	cflag	c if the sword has gone to far and should stop now
; @addr{50fc}
_armosWarrior_sword_checkWentTooFar:
	; Fix position, store it in bc
	ld h,d			; $50fc
	ld l,Enemy.yh		; $50fd
	ld e,Enemy.var32		; $50ff
	ld a,(de)		; $5101
	ldi (hl),a		; $5102
	ld b,a			; $5103
	inc e			; $5104
	inc l			; $5105
	ld a,(de)		; $5106
	ld (hl),a		; $5107
	ld c,a			; $5108

	; Read in boundary data based on the angle, determine if the sword has gone past
	ld e,Enemy.angle		; $5109
	ld a,(de)		; $510b
	add $02			; $510c
	and $1c			; $510e
	rrca			; $5110
	ld hl,_armosWarrior_sword_angleBoundaries		; $5111
	rst_addAToHl			; $5114

	ldi a,(hl)		; $5115
	ld e,b			; $5116
	call @checkPositionComponent		; $5117
	jr c,++			; $511a
	ld e,c			; $511c
	ld a,(hl)		; $511d
	call @checkPositionComponent		; $511e
++
	ld h,d			; $5121
	ret			; $5122

;;
; @addr{5123}
@checkPositionComponent:
	; If bit 0 of the data structure is set, it's an upper / left boundary
	bit 0,a			; $5123
	jr nz,++		; $5125
	cp e			; $5127
	ret			; $5128
++
	cp e			; $5129
	ccf			; $512a
	ret			; $512b


_armosWarrior_shield_YXOffsets:
	.db $fb $03 ; Frame 0
	.db $fb $07 ; Frame 1


; This is a table of data values for various parts of the sword's animation, which adjusts
; its collision box.
;   b0: Y-offset
;   b1: X-offset
;   b2: collisionRadiusY
;   b3: collisionRadiusX
_armosWarrior_sword_collisionBoxes:
	.db $fc $00 $08 $03
	.db $fe $fe $06 $06
	.db $00 $fc $03 $08
	.db $02 $fe $06 $06
	.db $04 $ff $08 $03
	.db $02 $02 $06 $06
	.db $01 $04 $03 $08
	.db $fe $02 $06 $06


; Sword decelerates based on these values
_armosWarrior_sword_speedVals:
	.db SPEED_40, SPEED_80, SPEED_100, SPEED_140


; Parent chooses a speed from here based on how many hits the shield has taken
_armosWarrior_parent_speedVals:
	.db SPEED_180, SPEED_140, SPEED_100


; For each possible angle the sword can move in, this has Y and X boundaries where it
; should stop.
;   b0: Y-boundary. (If bit 0 is set, it's an upper boundary.)
;   b1: X-boundary. (If bit 0 is set, it's a left boundary.)
_armosWarrior_sword_angleBoundaries:
	.db $51 $fe ; Up
	.db $51 $98 ; Up-right
	.db $fe $98 ; Right
	.db $60 $98 ; Down-right
	.db $60 $fe ; Down
	.db $60 $51 ; Down-left
	.db $fe $51 ; Left
	.db $51 $51 ; Up-left

;;
; @addr{5167}
_armosWarrior_sword_playSlashSound:
	ld a,(wFrameCounter)		; $5167
	and $0f			; $516a
	ret nz			; $516c
	ld a,SND_SWORDSLASH		; $516d
	jp playSound		; $516f


; ==============================================================================
; ENEMYID_SMASHER
;
; Variables (ball, subid 0):
;   relatedObj1: parent
;   var30: Counter until the ball respawns
;
; Variables (parent, subid 1):
;   relatedObj1: ball
;   var30/var31: Target position (directly in front of ball object)
;   var32: Nonzero if already initialized
; ==============================================================================
enemyCode74:
	jr z,@normalStatus	; $5172
	sub ENEMYSTATUS_NO_HEALTH			; $5174
	ret c			; $5176
	jr z,@dead	; $5177
	dec a			; $5179
	jr z,@normalStatus	; $517a
	jp _ecom_updateKnockback		; $517c

@dead:
	ld e,Enemy.subid		; $517f
	ld a,(de)		; $5181
	or a			; $5182
	jr nz,@mainDead	; $5183

	; Ball dead
	call _smasher_ball_makeLinkDrop		; $5185
	call objectCreatePuff		; $5188
	jp enemyDelete		; $518b

@mainDead:
	ld e,Enemy.collisionType		; $518e
	ld a,(de)		; $5190
	or a			; $5191
	call nz,_ecom_killRelatedObj1		; $5192
	jp _enemyBoss_dead		; $5195

@normalStatus:
	call _smasher_ball_updateRespawnTimer		; $5198
	call _ecom_getSubidAndCpStateTo08		; $519b
	jr c,@commonState	; $519e
	ld a,b			; $51a0
	or a			; $51a1
	jp z,_smasher_ball		; $51a2
	jp _smasher_parent		; $51a5

@commonState:
	rst_jumpTable			; $51a8
	.dw _smasher_state_uninitialized
	.dw _smasher_state_stub
	.dw _smasher_state_grabbed
	.dw _smasher_state_stub
	.dw _smasher_state_stub
	.dw _smasher_state_stub
	.dw _smasher_state_stub
	.dw _smasher_state_stub


_smasher_state_uninitialized:
	ld a,b			; $51b9
	or a			; $51ba
	jr nz,@alreadySpawnedParent	; $51bb

@initializeBall:
	ld b,a			; $51bd
	ld a,$ff		; $51be
	call _enemyBoss_initializeRoom		; $51c0

	; Spawn parent
	ld b,ENEMYID_SMASHER		; $51c3
	call _ecom_spawnUncountedEnemyWithSubid01		; $51c5
	ret nz			; $51c8

	; [parent.enabled] = [ball.enabled]
	ld l,Enemy.enabled		; $51c9
	ld e,l			; $51cb
	ld a,(de)		; $51cc
	ld (hl),a		; $51cd

	; [ball.relatedObj1] = parent
	; [parent.relatedObj1] = ball
	ld l,Enemy.relatedObj1		; $51ce
	ld e,l			; $51d0
	ld a,Enemy.start		; $51d1
	ldi (hl),a		; $51d3
	ld (de),a		; $51d4
	inc e			; $51d5
	ld a,h			; $51d6
	ld (de),a		; $51d7
	ld (hl),d		; $51d8

	call objectCopyPosition		; $51d9

	; If parent object has a lower index than ball object, swap them
	ld a,h			; $51dc
	cp d			; $51dd
	jr nc,@initialize	; $51de

	ld l,Enemy.subid		; $51e0
	ld (hl),$80 ; Change former "parent" to "ball"
	ld e,l			; $51e4
	ld a,$01		; $51e5
	ld (de),a   ; Change former "ball" (this) to "parent"

@alreadySpawnedParent:
	dec a			; $51e8
	jr z,@gotoState8	; $51e9

	; Effectively clears bit 7 of parent's subid (should be $80 when it reaches here)
	ld e,Enemy.subid		; $51eb
	xor a			; $51ed
	ld (de),a		; $51ee

@initialize:
	ld a,$01		; $51ef
	call _smasher_setOamFlags		; $51f1

	ld l,Enemy.xh		; $51f4
	ld a,(hl)		; $51f6
	sub $20			; $51f7
	ld (hl),a		; $51f9

	ld a,$04		; $51fa
	call enemySetAnimation		; $51fc

@gotoState8:
	jp _ecom_setSpeedAndState8AndVisible		; $51ff


_smasher_state_grabbed:
	inc e			; $5202
	ld a,(de) ; [state2]
	rst_jumpTable			; $5204
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d			; $520d
	ld l,e			; $520e
	inc (hl)		; $520f
	ld a,2<<4		; $5210
	ld (wLinkGrabState2),a		; $5212
	jp objectSetVisiblec1		; $5215

@beingHeld:
	ret			; $5218

@released:
	call _ecom_bounceOffWallsAndHoles		; $5219
	jr z,++			; $521c

	; Hit a wall; copy new angle to the "throw item" that's controlling this
	ld e,Enemy.angle		; $521e
	ld a,(de)		; $5220
	ld hl,w1ReservedItemC.angle		; $5221
	ld (hl),a		; $5224
++
	; Return if parent was already hit
	ld a,Object.invincibilityCounter		; $5225
	call objectGetRelatedObject1Var		; $5227
	ld a,(hl)		; $522a
	or a			; $522b
	ret nz			; $522c

	; Check if we've collided with parent
	ld l,Enemy.zh		; $522d
	ld e,l			; $522f
	ld a,(de)		; $5230
	sub (hl)		; $5231
	add $08			; $5232
	cp $11			; $5234
	ret nc			; $5236
	call checkObjectsCollided		; $5237
	ret nc			; $523a

	; We've collided

	ld l,Enemy.invincibilityCounter		; $523b
	ld (hl),$20		; $523d
	ld l,Enemy.knockbackCounter		; $523f
	ld (hl),$10		; $5241

	ld l,Enemy.health		; $5243
	dec (hl)		; $5245

	; Calculate knockback angle for boss
	call _smasher_ball_loadPositions		; $5246
	push hl			; $5249
	call objectGetRelativeAngleWithTempVars		; $524a
	pop hl			; $524d
	ld l,Enemy.knockbackAngle		; $524e
	ld (hl),a		; $5250

	; Reverse knockback angle for ball
	xor $10			; $5251
	ld hl,w1ReservedItemC.angle		; $5253
	ld (hl),a		; $5256

	ld a,SND_BOSS_DAMAGE		; $5257
	jp playSound		; $5259

@atRest:
	dec e			; $525c
	ld a,$08		; $525d
	ld (de),a ; [state] = 8
	jp objectSetVisiblec2		; $5260


_smasher_state_stub:
	ret			; $5263


_smasher_ball:
	ld a,(de)		; $5264
	sub $08			; $5265
	rst_jumpTable			; $5267
	.dw _smasher_ball_state8
	.dw _smasher_ball_state9
	.dw _smasher_ball_stateA
	.dw _smasher_ball_stateB
	.dw _smasher_ball_stateC
	.dw _smasher_ball_stateD
	.dw _smasher_ball_stateE
	.dw _smasher_ball_stateF


; Initialization (or just reappeared after disappearing)
_smasher_ball_state8:
	ld h,d			; $5278
	ld l,e			; $5279
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $527b
	ld (hl),ENEMYCOLLISION_SMASHER_BALL		; $527d
	ld l,Enemy.speed		; $527f
	ld (hl),SPEED_a0		; $5281


; Lying on ground, waiting for parent or Link to pick it up
_smasher_ball_state9:
	call objectAddToGrabbableObjectBuffer		; $5283
	jp objectPushLinkAwayOnCollision		; $5286


; Parent is picking up the ball
_smasher_ball_stateA:
	ld h,d			; $5289
	ld l,Enemy.zh		; $528a
	ldd a,(hl)		; $528c
	cp $f4			; $528d
	jr z,++			; $528f

	; [ball.z] -= $0080 (moving up)
	ld a,(hl)		; $5291
	sub <($0080)			; $5292
	ldi (hl),a		; $5294
	ld a,(hl)		; $5295
	sbc >($0080)			; $5296
	ld (hl),a		; $5298
++
	; Move toward parent on Y/X axis
	ld a,Object.yh		; $5299
	call objectGetRelatedObject1Var		; $529b
	call _smasher_ball_loadPositions		; $529e
	cp c			; $52a1
	jp nz,_ecom_moveTowardPosition		; $52a2
	ldh a,(<hFF8F)	; $52a5
	cp b			; $52a7
	jp nz,_ecom_moveTowardPosition		; $52a8

	; Reached parent's Y/X position; wait for Z as well
	ld e,Enemy.zh		; $52ab
	ld a,(de)		; $52ad
	cp $f4			; $52ae
	ret nz			; $52b0

	; Reached position; go to next state
	call _ecom_incState		; $52b1

	ld l,Enemy.collisionType		; $52b4
	set 7,(hl)		; $52b6

	ld l,Enemy.speed		; $52b8
	ld (hl),SPEED_300		; $52ba
	jp objectSetVisiblec1		; $52bc


; This state is a signal for the parent, which will update the ball's state when it gets
; released.
_smasher_ball_stateB:
	ret			; $52bf


; Being thrown
_smasher_ball_stateC:
	ld c,$20		; $52c0
	call objectUpdateSpeedZAndBounce		; $52c2
	jr c,@doneBouncing	; $52c5
	jr nz,++		; $52c7

	; Hit ground
	ld e,Enemy.speed		; $52c9
	ld a,(de)		; $52cb
	srl a			; $52cc
	ld (de),a		; $52ce
	call _smasher_ball_playLandSound		; $52cf
++
	call _ecom_bounceOffWallsAndHoles		; $52d2
	jp objectApplySpeed		; $52d5

@doneBouncing:
	ld h,d			; $52d8
	ld l,Enemy.state		; $52d9
	ld (hl),$08		; $52db

	ld l,Enemy.collisionType		; $52dd
	res 7,(hl)		; $52df
	call objectSetVisiblec2		; $52e1

_smasher_ball_playLandSound:
	ld a,SND_BOMB_LAND		; $52e4
	jp playSound		; $52e6


; Disappearing (either after being thrown, or after a time limit)
_smasher_ball_stateD:
	call objectCreatePuff		; $52e9
	ret nz			; $52ec

	; If parent is picking up or throwing the ball, cancel that
	ld a,Object.state		; $52ed
	call objectGetRelatedObject1Var		; $52ef
	ld a,(hl)		; $52f2
	cp $0b			; $52f3
	jr c,++			; $52f5
	ld (hl),$0d ; [parent.state]
	ld l,Enemy.oamFlagsBackup		; $52f9
	ld a,$03		; $52fb
	ldi (hl),a		; $52fd
	ld (hl),a		; $52fe
++
	call _ecom_incState		; $52ff

	ld l,Enemy.collisionType		; $5302
	res 7,(hl)		; $5304

	ld l,Enemy.counter1		; $5306
	ld (hl),60		; $5308
	jp objectSetInvisible		; $530a


; Ball is gone, will reappear after [counter1] frames
_smasher_ball_stateE:
	call _ecom_decCounter1		; $530d
	ret nz			; $5310

	ld l,e			; $5311
	inc (hl) ; [state]

	ld l,Enemy.zh		; $5313
	ld (hl),-$20		; $5315

	ld l,Enemy.speedZ		; $5317
	xor a			; $5319
	ldi (hl),a		; $531a
	ld (hl),a		; $531b

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars		; $531c
	and $0e			; $531f
	ld hl,@spawnPositions		; $5321
	rst_addAToHl			; $5324
	ld e,Enemy.yh		; $5325
	ldi a,(hl)		; $5327
	ld (de),a		; $5328
	ld e,Enemy.xh		; $5329
	ld a,(hl)		; $532b
	ld (de),a		; $532c

	call objectCreatePuff		; $532d
	jp objectSetVisiblec1		; $5330

@spawnPositions:
	.db $38 $38
	.db $78 $38
	.db $38 $78
	.db $78 $78
	.db $38 $b8
	.db $78 $b8
	.db $58 $58
	.db $58 $98


; Ball is falling to ground after reappearing
_smasher_ball_stateF:
	ld c,$20		; $5343
	call objectUpdateSpeedZAndBounce		; $5345
	jr c,@doneBouncing	; $5348
	ret nz			; $534a
	jp _smasher_ball_playLandSound		; $534b

@doneBouncing:
	ld e,Enemy.state		; $534e
	ld a,$08		; $5350
	ld (de),a		; $5352
	jp objectSetVisiblec2		; $5353


_smasher_parent:
	ld a,(de)		; $5356
	sub $08			; $5357
	rst_jumpTable			; $5359
	.dw _smasher_parent_state8
	.dw _smasher_parent_state9
	.dw _smasher_parent_stateA
	.dw _smasher_parent_stateB
	.dw _smasher_parent_stateC
	.dw _smasher_parent_stateD


; Initialization
_smasher_parent_state8:
	ld h,d			; $5366
	ld l,e			; $5367
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $5369
	ld (hl),$01		; $536b

	ld l,Enemy.speed		; $536d
	ld (hl),SPEED_c0		; $536f

	; Don't do below function call if already initialized
	ld l,Enemy.var32		; $5371
	bit 0,(hl)		; $5373
	jr nz,_smasher_parent_state9	; $5375

	inc (hl) ; [var32]
	call _enemyBoss_beginMiniboss		; $5378


_smasher_parent_state9:
	ld a,Object.state		; $537b
	call objectGetRelatedObject1Var		; $537d
	ld a,(hl)		; $5380
	cp $09			; $5381
	jr z,@moveTowardBall	; $5383

	; Ball unavailable; moving aronund in random angles

	call _ecom_decCounter1		; $5385
	jr nz,@updateMovement	; $5388

	; Time to choose a new angle
	ld (hl),60 ; [counter1]

	call getRandomNumber_noPreserveVars		; $538c
	and $03			; $538f
	ld hl,@randomAngles		; $5391
	rst_addAToHl			; $5394
	ld e,Enemy.angle		; $5395
	ld a,(hl)		; $5397
	ld (de),a		; $5398
	call _smasher_updateDirectionFromAngle		; $5399

@updateMovement:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $539c
	ld c,$20		; $539f
	call objectUpdateSpeedZ_paramC		; $53a1
	jr nz,@updateAnim	; $53a4

	call _smasher_hop		; $53a6
	ld e,Enemy.direction		; $53a9
	ld a,(de)		; $53ab
	inc a			; $53ac
	jp enemySetAnimation		; $53ad

@updateAnim:
	; Change animation when he reaches the peak of his hop (speedZ is zero)
	ldd a,(hl)		; $53b0
	or (hl)			; $53b1
	ret nz			; $53b2
	ld e,Enemy.direction		; $53b3
	ld a,(de)		; $53b5
	jp enemySetAnimation		; $53b6

@moveTowardBall:
	; Copy ball's Y-position to var30 (Y-position to move to)
	ld l,Enemy.yh		; $53b9
	ld e,Enemy.var30		; $53bb
	ldi a,(hl)		; $53bd
	ld (de),a		; $53be

	; Calculate X-position to move to ($0e pixels to one side of the ball), then store
	; the value in var31
	inc l			; $53bf
	ld e,l			; $53c0
	ld a,(de) ; [parent.xh]
	cp (hl)   ; [ball.xh]
	ld a,$0e		; $53c3
	jr nc,+			; $53c5
	ld a,-$0e		; $53c7
+
	ld c,a			; $53c9

	add (hl) ; [ball.xh]
	ld b,a			; $53cb
	sub $18			; $53cc
	cp $c0			; $53ce
	jr c,++			; $53d0
	ld a,c			; $53d2
	cpl			; $53d3
	inc a			; $53d4
	add a			; $53d5
	add b			; $53d6
	ld b,a			; $53d7
++
	ld h,d			; $53d8
	ld l,Enemy.var31		; $53d9
	ld (hl),b		; $53db

	; Goto next state to move toward the ball
	ld l,Enemy.state		; $53dc
	inc (hl)		; $53de

	ld l,Enemy.speed		; $53df
	ld (hl),SPEED_100		; $53e1

	ld l,Enemy.var30		; $53e3
	call _ecom_readPositionVars		; $53e5
	call _smasher_updateAngleTowardPosition		; $53e8
	jp enemySetAnimation		; $53eb


@randomAngles: ; When ball is unavailable, smasher move randomly in one of these angles
	.db $06 $0a $16 $1a


; Moving toward ball on the ground
_smasher_parent_stateA:
	ld a,Object.state		; $53f2
	call objectGetRelatedObject1Var		; $53f4
	ld a,(hl)		; $53f7
	cp $09			; $53f8
	jr nz,_smasher_parent_linkPickedUpBall	; $53fa

	; Check if we've reached the target position in front of the ball
	ld h,d			; $53fc
	ld l,Enemy.var30		; $53fd
	call _ecom_readPositionVars		; $53ff
	sub c			; $5402
	add $02			; $5403
	cp $05			; $5405
	jr nc,@movingTowardBall	; $5407
	ldh a,(<hFF8F)	; $5409
	sub b			; $540b
	add $02			; $540c
	cp $05			; $540e
	jr nc,@movingTowardBall	; $5410

	; We've reached the position

	ld l,Enemy.state		; $5412
	inc (hl) ; [parent.state]

	ld l,Enemy.zh		; $5415
	ld (hl),$00		; $5417

	ld a,$02		; $5419
	call _smasher_setOamFlags		; $541b

	ld a,Object.state		; $541e
	call objectGetRelatedObject1Var		; $5420
	inc (hl) ; [ball.state] = $0a

	; Face toward the ball? ('b' is still set to the y-position from before?)
	ld l,Enemy.xh		; $5424
	ld c,(hl)		; $5426
	call _smasher_updateAngleTowardPosition		; $5427
	inc a			; $542a
	jp enemySetAnimation		; $542b

@movingTowardBall:
	call _ecom_moveTowardPosition		; $542e

	ld e,Enemy.angle		; $5431
	ld a,(de)		; $5433
	call _smasher_updateDirectionFromAngle		; $5434
	call enemySetAnimation		; $5437

	ld c,$20		; $543a
	call objectUpdateSpeedZ_paramC		; $543c
	ret nz			; $543f
	jr _smasher_hop		; $5440


_smasher_parent_linkPickedUpBall:
	; Stop chasing the ball
	ld h,d			; $5442
	ld l,Enemy.state		; $5443
	ld (hl),$09		; $5445

	ld l,Enemy.speed		; $5447
	ld (hl),SPEED_c0		; $5449

	ld l,Enemy.counter1		; $544b
	ld (hl),60		; $544d

	ld a,$03		; $544f
	call _smasher_setOamFlags		; $5451

	; Run away from Link
	call _ecom_updateCardinalAngleAwayFromTarget		; $5454
	jp _smasher_updateDirectionFromAngle		; $5457


; About to pick up ball
_smasher_parent_stateB:
	ld a,Object.state		; $545a
	call objectGetRelatedObject1Var		; $545c
	ld a,(hl)		; $545f
	cp ENEMYSTATE_GRABBED			; $5460
	jr z,_smasher_parent_linkPickedUpBall	; $5462

	; Wait for ball's state to update
	cp $0b			; $5464
	ret c			; $5466

	ld a,$03		; $5467
	call _smasher_setOamFlags		; $5469

	ld l,Enemy.state		; $546c
	inc (hl)		; $546e

	ld l,Enemy.counter2		; $546f
	ld (hl),30		; $5471

	ld l,Enemy.speed		; $5473
	ld (hl),SPEED_40		; $5475

;;
; @addr{5477}
_smasher_hop:
	ld l,Enemy.speedZ		; $5477
	ld a,<(-$c0)		; $5479
	ldi (hl),a		; $547b
	ld (hl),>(-$c0)		; $547c
	ret			; $547e


; Just picked up ball; hopping while moving slowly toward Link
_smasher_parent_stateC:
	call _smasher_updateAngleTowardLink		; $547f
	inc a			; $5482
	call enemySetAnimation		; $5483

	call _ecom_decCounter2		; $5486

	ld c,$20		; $5489
	call objectUpdateSpeedZ_paramC		; $548b
	jr z,@hitGround	; $548e

	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5490

	; Update ball's position
	ld a,Object.enabled		; $5493
	call objectGetRelatedObject1Var		; $5495
	call objectCopyPosition		; $5498
	dec l			; $549b
	ld e,l			; $549c
	ld a,(de) ; [parent.zh]
	add $f4			; $549e
	ld (hl),a ; [ball.zh]
	ret			; $54a1

@hitGround:
	ld e,Enemy.counter2		; $54a2
	ld a,(de)		; $54a4
	or a			; $54a5
	jp nz,_smasher_hop		; $54a6

	; Done hopping; go to next state to leap into the air

	ld a,>(-$1e0)		; $54a9
	ldd (hl),a		; $54ab
	ld (hl),<(-$1e0)		; $54ac

	ld l,Enemy.state		; $54ae
	inc (hl)		; $54b0

	ld a,$02		; $54b1
	jp _smasher_setOamFlags		; $54b3


; In midair just before throwing ball
_smasher_parent_stateD:
	ld c,$20		; $54b6
	call objectUpdateSpeedZ_paramC		; $54b8
	jr nz,@inMidair	; $54bb

	; Hit the ground
	ld l,Enemy.state		; $54bd
	ld (hl),$08		; $54bf
	ret			; $54c1

@inMidair:
	ld a,Object.zh		; $54c2
	call objectGetRelatedObject1Var		; $54c4
	ld e,l			; $54c7
	ld a,(de)		; $54c8
	add $f4			; $54c9
	ld (hl),a		; $54cb

	ld e,Enemy.speedZ+1		; $54cc
	ld a,(de)		; $54ce
	rlca			; $54cf
	jr nc,@movingDown		; $54d0

	; Moving up
	call _smasher_updateAngleTowardLink		; $54d2
	inc a			; $54d5
	jp enemySetAnimation		; $54d6

@movingDown:
	; Return if speedZ is nonzero (not at peak of jump)
	ld b,a			; $54d9
	dec e			; $54da
	ld a,(de)		; $54db
	or b			; $54dc
	ret nz			; $54dd

	; Throw the ball if its state is valid for this
	ld a,Object.state		; $54de
	call objectGetRelatedObject1Var		; $54e0
	ld a,(hl)		; $54e3
	cp $0b			; $54e4
	ret nz			; $54e6

	inc (hl) ; [ball.state]
	ld l,Enemy.angle		; $54e8
	ld e,l			; $54ea
	ld a,(de)		; $54eb
	ld (hl),a		; $54ec

	ld a,$03		; $54ed
	call _smasher_setOamFlags		; $54ef

	ld e,Enemy.direction		; $54f2
	ld a,(de)		; $54f4
	jp enemySetAnimation		; $54f5


;;
; @param[out]	a	direction value
; @addr{54f8}
_smasher_updateAngleTowardPosition:
	call objectGetRelativeAngleWithTempVars		; $54f8
	ld e,Enemy.angle		; $54fb
	ld (de),a		; $54fd
	jr _smasher_updateDirectionFromAngle			; $54fe

;;
; @addr{5500}
_smasher_updateAngleTowardLink:
	call objectGetAngleTowardEnemyTarget		; $5500
	ld e,Enemy.angle		; $5503
	ld (de),a		; $5505

;;
; @param	a	angle
; @param[out]	a	direction value
; @addr{5506}
_smasher_updateDirectionFromAngle:
	ld b,a			; $5506
	and $0f			; $5507
	ret z			; $5509
	ld a,b			; $550a
	and $10			; $550b
	xor $10			; $550d
	swap a			; $550f
	rlca			; $5511
	ld e,Enemy.direction		; $5512
	ld (de),a		; $5514
	ret			; $5515


;;
; @param	a	Value for oamFlags
; @addr{5516}
_smasher_setOamFlags:
	ld h,d			; $5516
	ld l,Enemy.oamFlagsBackup		; $5517
	ldi (hl),a		; $5519
	ld (hl),a		; $551a
	ret			; $551b

;;
; Loads positions into bc and hFF8E/hFF8F for subsequent call to
; "objectGetRelativeAngleWithTempVars".
;
; @param	h	Parent object
; @addr{551c}
_smasher_ball_loadPositions:
	ld l,Enemy.yh		; $551c
	ld e,l			; $551e
	ld a,(de)		; $551f
	ldh (<hFF8F),a	; $5520
	ld b,(hl)		; $5522
	ld l,Enemy.xh		; $5523
	ld e,l			; $5525
	ld a,(de)		; $5526
	ldh (<hFF8E),a	; $5527
	ld c,(hl)		; $5529
	ret			; $552a


;;
; Updates the ball's "respawn timer" and makes it disappear (goes to state $0d) when it
; hits zero.
; @addr{552b}
_smasher_ball_updateRespawnTimer:
	; Return if this isn't the ball
	ld e,Enemy.subid		; $552b
	ld a,(de)		; $552d
	or a			; $552e
	ret nz			; $552f

	ld e,Enemy.state		; $5530
	ld a,(de)		; $5532
	cp $0d			; $5533
	ret nc			; $5535
	ld a,(wFrameCounter)		; $5536
	rrca			; $5539
	ret c			; $553a

	ld h,d			; $553b
	ld l,Enemy.var30		; $553c
	inc (hl)		; $553e
	ld a,(hl)		; $553f
	cp 180			; $5540
	ret c			; $5542

	ld (hl),$00		; $5543
	call _smasher_ball_makeLinkDrop		; $5545
	ld e,Enemy.state		; $5548
	ld a,$0d		; $554a
	ld (de),a		; $554c
	ret			; $554d


;;
; @addr{554e}
_smasher_ball_makeLinkDrop:
	ld e,Enemy.state		; $554e
	ld a,(de)		; $5550
	cp $02			; $5551
	ret nz			; $5553
	inc e			; $5554
	ld a,(de)		; $5555
	cp $02			; $5556
	ret nc			; $5558
	jp dropLinkHeldItem		; $5559


; ==============================================================================
; ENEMYID_VIRE
;
; Variables (for main form, subid 0):
;   relatedObj2: INTERACID_PUFF?
;   var30: Rotation angle?
;   var32: Used for animations?
;   var33: Health?
;   var34: Number of "bat children" alive. Will die when this reaches 0.
;   var37: Marks whether text has been shown as health goes down
;   var38: If nonzero, he won't spawn a fairy when defeated?
;
; Variables (for bat form, subid 1):
;   relatedObj1: Reference to main form (subid 0)
;   var30: Rotation angle?
;   var35/var36: Target position?
; ==============================================================================
enemyCode75:
	jr z,@normalStatus	; $555c
	sub ENEMYSTATUS_NO_HEALTH			; $555e
	ret c			; $5560
	jr z,@dead	; $5561

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.subid		; $5563
	ld a,(de)		; $5565
	or a			; $5566
	ld e,Enemy.health		; $5567
	ld a,(de)		; $5569
	jr z,++			; $556a
	or a			; $556c
	ret z			; $556d
	jr @normalStatus		; $556e
++
	ld h,d			; $5570
	ld l,Enemy.var33		; $5571
	cp (hl)			; $5573
	jr z,@normalStatus	; $5574

	ld (hl),a		; $5576
	or a			; $5577
	ret z			; $5578

	ld l,Enemy.state		; $5579
	ld (hl),$0e		; $557b
	inc l			; $557d
	ld (hl),$00		; $557e
	ret			; $5580

@dead:
	ld e,Enemy.subid		; $5581
	ld a,(de)		; $5583
	or a			; $5584
	jr z,@subid0Dead	; $5585

	; Subid 1 (bat child) death
	call objectCreatePuff		; $5587
	ld a,Object.var34		; $558a
	call objectGetRelatedObject1Var		; $558c
	dec (hl)		; $558f
	call z,objectCopyPosition		; $5590
	jp enemyDelete		; $5593

@subid0Dead:
	ld h,d			; $5596
	ld l,Enemy.state		; $5597
	ld a,(hl)		; $5599
	cp $0f			; $559a
	jp z,_enemyBoss_dead		; $559c

	ld (hl),$0f ; [state]
	inc l			; $55a1
	ld (hl),$00 ; [state2]
	inc l			; $55a4
	ld (hl),20 ; [counter1]

	ld l,Enemy.health		; $55a7
	ld (hl),$01		; $55a9

	ld l,Enemy.direction		; $55ab
	xor a			; $55ad
	ld (hl),a		; $55ae
	call enemySetAnimation		; $55af

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $55b2
	jr c,@commonState	; $55b5

	ld a,b			; $55b7
	or a			; $55b8
	jp z,_vire_mainForm		; $55b9
	jp _vire_batForm		; $55bc

@commonState:
	ld e,Enemy.state		; $55bf
	ld a,(de)		; $55c1
	rst_jumpTable			; $55c2
	.dw _vire_state_uninitialized
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub
	.dw _vire_state_stub


_vire_state_uninitialized:
	ld a,SPEED_c0		; $55d3
	call _ecom_setSpeedAndState8		; $55d5

	ld a,b			; $55d8
	or a			; $55d9
	ret nz			; $55da

	; "Main" vire only (not bat form)
	ld l,Enemy.zh		; $55db
	ld (hl),$fc		; $55dd

	dec a ; a = $ff
	ld b,$00		; $55e0
	jp _enemyBoss_initializeRoom		; $55e2


_vire_state_stub:
	ret			; $55e5


_vire_mainForm:
	ld e,Enemy.direction		; $55e6
	ld a,(de)		; $55e8
	or a			; $55e9
	jr z,@runState	; $55ea

	ld h,d			; $55ec
	ld l,Enemy.var32		; $55ed
	inc (hl)		; $55ef
	ld a,(hl)		; $55f0
	cp $18			; $55f1
	jr c,@runState	; $55f3

	xor a			; $55f5
	ld (hl),a ; [var32] = 0

	ld l,e			; $55f7
	ld (hl),a ; [direction] = 0
	call enemySetAnimation		; $55f9

@runState:
	ld e,Enemy.state		; $55fc
	ld a,(de)		; $55fe
	sub $08			; $55ff
	rst_jumpTable			; $5601
	.dw _vire_mainForm_state8
	.dw _vire_mainForm_state9
	.dw _vire_mainForm_stateA
	.dw _vire_mainForm_stateB
	.dw _vire_mainForm_stateC
	.dw _vire_mainForm_stateD
	.dw _vire_mainForm_stateE
	.dw _vire_mainForm_stateF


; Mini-cutscene before starting fight
_vire_mainForm_state8:
	inc e			; $5612
	ld a,(de) ; [state2]
	rst_jumpTable			; $5614
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Wait for Link to approach
	ldh a,(<hEnemyTargetY)	; $561d
	sub $38			; $561f
	cp $41			; $5621
	ret nc			; $5623
	ldh a,(<hEnemyTargetX)	; $5624
	sub $50			; $5626
	cp $51			; $5628
	ret nc			; $562a

	; Can't be dead...
	ld a,(wLinkDeathTrigger)		; $562b
	or a			; $562e
	ret nz			; $562f

	ldbc INTERACID_PUFF, $02		; $5630
	call objectCreateInteraction		; $5633
	ret nz			; $5636

	; [relatedObj2] = INTERACID_PUFF
	ld e,Enemy.relatedObj2+1		; $5637
	ld a,h			; $5639
	ld (de),a		; $563a
	dec e			; $563b
	ld a,Interaction.start		; $563c
	ld (de),a		; $563e

	ld e,Enemy.state2		; $563f
	ld a,$01		; $5641
	ld (de),a		; $5643
	ld (wDisabledObjects),a ; DISABLE_LINK
	ld (wDisableLinkCollisionsAndMenu),a		; $5647
	ret			; $564a

@substate1:
	; Wait for puff to disappear
	ld a,Object.animParameter		; $564b
	call objectGetRelatedObject2Var		; $564d
	bit 7,(hl)		; $5650
	ret z			; $5652

	ld h,d			; $5653
	ld l,Enemy.state2		; $5654
	inc (hl)		; $5656
	inc l			; $5657
	ld (hl),$08 ; [counter1]
	jp objectSetVisiblec1		; $565a

@substate2:
	; Show text in 8 frames
	call _ecom_decCounter1		; $565d
	jp nz,enemyAnimate		; $5660

	ld l,e			; $5663
	inc (hl) ; [state2]
	ld bc,TX_2f12		; $5665
	call checkIsLinkedGame		; $5668
	jr z,+			; $566b
	inc c ; TX_2f13
+
	jp showText		; $566e

@substate3:
	; Disappear
	call objectCreatePuff		; $5671
	ret nz			; $5674

	; a == 0
	ld (wDisabledObjects),a		; $5675
	ld (wDisableLinkCollisionsAndMenu),a		; $5678

.ifdef ROM_AGES
	call _ecom_incState		; $567b
.else
	ld h,d			; $56f2
	ld l,Enemy.state		; $56f3
	inc (hl)		; $56f5
.endif

	inc l			; $567e
	ldi (hl),a ; [state2] = 0
	ld (hl),90 ; [counter1]

	ld l,Enemy.health		; $5682
	ld a,(hl)		; $5684
	ld l,Enemy.var33		; $5685
	ld (hl),a		; $5687

	call objectSetInvisible		; $5688
	ld a,MUS_MINIBOSS		; $568b
	ld (wActiveMusic),a		; $568d
	jp playSound		; $5690


; Off-screen for [counter1] frames
_vire_mainForm_state9:
	call _ecom_decCounter1		; $5693
	ret nz			; $5696

	; Decide what to do next (health affects probability)
	ld e,Enemy.health		; $5697
	ld a,(de)		; $5699
	ld c,$08		; $569a
	cp $0a			; $569c
	jr c,++			; $569e
	ld c,$04		; $56a0
	cp $10			; $56a2
	jr c,++		; $56a4
	ld c,$00		; $56a6
++
	call getRandomNumber		; $56a8
	and $07			; $56ab
	add c			; $56ad
	ld hl,@behaviourTable		; $56ae
	rst_addAToHl			; $56b1

	ld a,(hl)		; $56b2
	ld e,Enemy.state		; $56b3
	ld (de),a		; $56b5
	ret			; $56b6

; Vire chooses from 8 of these values, starting from index 0, 4, or 8 depending on health
; (starts from 0 when health is high).
@behaviourTable:
	.db $0a $0a $0b $0d $0a $0a $0a $0a
	.db $0b $0b $0c $0d $0a $0b $0c $0d


; Charges across screen
_vire_mainForm_stateA:
	inc e			; $56c7
	ld a,(de)		; $56c8
	rst_jumpTable			; $56c9
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _vire_spawnOutsideCamera		; $56d0
	inc l			; $56d3
	ld (hl),20 ; [counter1]
	ld l,Enemy.speed		; $56d6
	ld (hl),SPEED_100		; $56d8
	ret			; $56da

; Moving slowly before charging
@substate1:
	call _ecom_decCounter1		; $56db
	jp nz,_vire_mainForm_applySpeedAndAnimate		; $56de

	; Begin charging
	ld l,e			; $56e1
	inc (hl) ; [state2]

	ld l,Enemy.speed		; $56e3
	ld (hl),SPEED_200		; $56e5
	call _ecom_updateAngleTowardTarget		; $56e7
	call getRandomNumber_noPreserveVars		; $56ea
	and $03			; $56ed
	sub $02			; $56ef
	ld b,a			; $56f1
	ld e,Enemy.angle		; $56f2
	ld a,(de)		; $56f4
	add b			; $56f5
	and $1f			; $56f6
	ld (de),a		; $56f8

; Charging across screen
@substate2:
	call _vire_checkOffScreen		; $56f9
	jp nc,_vire_mainForm_leftScreen		; $56fc
	call _ecom_decCounter1		; $56ff
	ld a,(hl)		; $5702
	and $1f			; $5703
	call z,_vire_mainForm_fireProjectile		; $5705
	jp _vire_mainForm_applySpeedAndAnimate		; $5708


; Circling Link, runs away if Link gets too close (similar to state D)
_vire_mainForm_stateB:
	inc e			; $570b
	ld a,(de)		; $570c
	rst_jumpTable			; $570d
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0: ; Also subid 0 for state D
	call _vire_spawnOutsideCamera		; $5716
	inc l			; $5719
	ld (hl),120 ; [counter1]
	call getRandomNumber_noPreserveVars		; $571c
	and $08			; $571f
	jr nz,+			; $5721
	ld a,$f8		; $5723
+
	ld e,Enemy.var30		; $5725
	ld (de),a		; $5727
	ret			; $5728

@substate1:
	ld a,(wFrameCounter)		; $5729
	and $03			; $572c
	jr nz,++		; $572e

	call _ecom_decCounter1		; $5730
	jr z,@beginCharge	; $5733

	ld a,(hl)		; $5735
	and $1f			; $5736
	ld b,$01		; $5738
	call z,_vire_mainForm_fireProjectileWithSubid		; $573a
++
	call _vire_mainForm_checkLinkTooClose		; $573d
	jp nc,_vire_mainForm_circleAroundScreen		; $5740

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.state2		; $5743
	inc (hl)		; $5745
	ld l,Enemy.speed		; $5746
	ld (hl),SPEED_200		; $5748
	call _ecom_updateAngleTowardTarget		; $574a
	jr @animate		; $574d

; Charging toward Link
@substate2:
	call _vire_mainForm_checkLinkTooClose		; $574f
	jr c,@updateAngleAway			; $5752
	ld a,(wLinkUsingItem1)		; $5754
	or a			; $5757
	jr nz,@updateAngleAway		; $5758
	call _vire_checkOffScreen		; $575a
	jp nc,_vire_mainForm_leftScreen		; $575d
	jp _vire_mainForm_applySpeedAndAnimate		; $5760

; Charging away from Link
@updateAngleAway:
	ld l,e			; $5763
	inc (hl) ; [state2]
	call _ecom_updateCardinalAngleAwayFromTarget		; $5765
@animate:
	jp enemyAnimate		; $5768

@substate3:
	call _vire_checkOffScreen		; $576b
	jp nc,_vire_mainForm_leftScreen		; $576e

	call _ecom_decCounter1		; $5771
	ld a,(hl)		; $5774
	and $1f			; $5775
	ld b,$01		; $5777
	call z,_vire_mainForm_fireProjectileWithSubid		; $5779
	jp _vire_mainForm_applySpeedAndAnimate		; $577c


; Vire creeps in from the screen edge to fire one projectile, then runs away
_vire_mainForm_stateC:
	inc e			; $577f
	ld a,(de)		; $5780
	rst_jumpTable			; $5781
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call _vire_spawnOutsideCamera		; $578a
	inc l			; $578d
	ld (hl),28 ; [counter1]
	ld l,Enemy.speed		; $5790
	ld (hl),SPEED_100		; $5792
	ret			; $5794

@substate1:
	call _ecom_decCounter1		; $5795
	jp nz,_vire_mainForm_applySpeedAndAnimate		; $5798

	ld (hl),12 ; [counter1]
	ld l,e			; $579d
	inc (hl) ; [state2]

	ld b,$03		; $579f
	call _vire_mainForm_fireProjectileWithSubid		; $57a1
	jr @animate		; $57a4

@substate2:
	call _ecom_decCounter1		; $57a6
	jr nz,@animate	; $57a9

	ld l,e			; $57ab
	inc (hl) ; [state2]

	ld l,Enemy.angle		; $57ad
	ld a,(hl)		; $57af
	xor $10			; $57b0
	ld (hl),a		; $57b2
	ld l,Enemy.speed		; $57b3
	ld (hl),SPEED_200		; $57b5

@animate:
	jp enemyAnimate		; $57b7

@substate3:
	call _vire_checkOffScreen		; $57ba
	jp nc,_vire_mainForm_leftScreen		; $57bd
	jp _vire_mainForm_applySpeedAndAnimate		; $57c0


; Circling Link, runs away if Link attempts to attack (similar to state B)
_vire_mainForm_stateD:
	inc e			; $57c3
	ld a,(de)		; $57c4
	rst_jumpTable			; $57c5
	.dw _vire_mainForm_stateB@substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw _vire_state_moveOffScreen

@substate1:
	ld a,(wFrameCounter)		; $57d2
	and $03			; $57d5
	jr nz,++		; $57d7

	call _ecom_decCounter1		; $57d9
	jr z,@beginCharge	; $57dc

	ld a,(hl)		; $57de
	and $1f			; $57df
	ld b,$01		; $57e1
	call z,_vire_mainForm_fireProjectileWithSubid		; $57e3
++
	call _vire_mainForm_checkLinkTooClose		; $57e6
	jp nc,_vire_mainForm_circleAroundScreen		; $57e9

; Begin charging; initially toward Link, but will run away if he gets too close or Link
; attacks
@beginCharge:
	ld l,Enemy.state2		; $57ec
	inc (hl)		; $57ee
	ld l,Enemy.speed		; $57ef
	ld (hl),SPEED_200		; $57f1
	call _ecom_updateAngleTowardTarget		; $57f3
@animate:
	jp enemyAnimate		; $57f6

; Charging toward Link
@substate2:
	ld a,(wLinkUsingItem1)		; $57f9
	or a			; $57fc
	jr z,@moveOffScreen	; $57fd

	ld h,d			; $57ff
	ld l,e			; $5800
	inc (hl) ; [state2]
	inc l			; $5802
	ld (hl),12 ; [counter1]
	ld l,Enemy.speed		; $5805
	ld (hl),SPEED_300		; $5807
	call _ecom_updateCardinalAngleAwayFromTarget		; $5809
	jr @animate		; $580c

@moveOffScreen:
	call _vire_checkOffScreen		; $580e
	jp nc,_vire_mainForm_leftScreen		; $5811
	jp _vire_mainForm_applySpeedAndAnimate		; $5814

@substate3:
	call _ecom_decCounter1		; $5817
	jp nz,_vire_mainForm_applySpeedAndAnimate		; $581a

	ld (hl),12 ; [counter1]
	ld l,e			; $581f
	inc (hl) ; [state2]

	ld b,PARTID_VIRE_PROJECTILE		; $5821
	call _ecom_spawnProjectile		; $5823

	ld a,SND_SPLASH		; $5826
	call playSound		; $5828
	jr @animate		; $582b

@substate4:
	call _ecom_decCounter1		; $582d
	jr nz,@animate	; $5830

	ld l,e			; $5832
	inc (hl) ; [state2]

	ld l,Enemy.speed		; $5834
	ld (hl),SPEED_1c0		; $5836

	call _ecom_updateCardinalAngleAwayFromTarget		; $5838
	jr @animate		; $583b


_vire_state_moveOffScreen: ; Used by states D and E
	call _vire_checkOffScreen		; $583d
	jp nc,_vire_mainForm_leftScreen		; $5840
	jp _vire_mainForm_applySpeedAndAnimate		; $5843


; Just took damage
_vire_mainForm_stateE:
	inc e			; $5846
	ld a,(de)		; $5847
	rst_jumpTable			; $5848
	.dw @substate0
	.dw @substate1
	.dw _vire_state_moveOffScreen

@substate0:
	ld h,d			; $584f
	ld l,e			; $5850
	inc (hl) ; [state2]

	inc l			; $5852
	ld (hl),20 ; [counter1]

	ld l,Enemy.speed		; $5855
	ld (hl),SPEED_300		; $5857
	call _ecom_updateCardinalAngleAwayFromTarget		; $5859

	ld e,Enemy.direction		; $585c
	xor a			; $585e
	ld (de),a		; $585f

	ld e,Enemy.var32		; $5860
	ld (de),a		; $5862
	jp enemySetAnimation		; $5863

@substate1:
	call _ecom_decCounter1		; $5866
	jp nz,enemyAnimate		; $5869

	ld l,e			; $586c
	inc (hl) ; [state2]

	; Check whether to show text based on current health
	ld l,Enemy.health		; $586e
	ld a,(hl)		; $5870
	cp $10			; $5871
	ret nc			; $5873

	ld b,$01		; $5874
	cp $0a			; $5876
	jr nc,+			; $5878
	inc b			; $587a
+
	ld a,b			; $587b
	ld l,Enemy.var37		; $587c
	cp (hl)			; $587e
	ret z			; $587f

	ld (hl),a		; $5880
	add <TX_2f13			; $5881
	ld c,a			; $5883
	ld b,>TX_2f00		; $5884
	jp showText		; $5886


; "Main form" died, about to split into bats
_vire_mainForm_stateF:
	inc e			; $5889
	ld a,(de)		; $588a
	rst_jumpTable			; $588b
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	call _ecom_decCounter1		; $5898
	ret nz			; $589b
	ld l,e			; $589c
	inc (hl) ; [counter1]
	ld bc,TX_2f16		; $589e
	jp showText		; $58a1

@substate1:
	ld b,$02		; $58a4
	call checkBEnemySlotsAvailable		; $58a6
	jp nz,enemyAnimate		; $58a9

	ld h,d			; $58ac
	ld l,Enemy.state2		; $58ad
	inc (hl)		; $58af

	ld l,Enemy.var34		; $58b0
	ld (hl),$02		; $58b2

	call objectSetInvisible		; $58b4
	call objectCreatePuff		; $58b7

	; Spawn bats
	ld b,ENEMYID_VIRE		; $58ba
	call _ecom_spawnUncountedEnemyWithSubid01		; $58bc
	call @initBat		; $58bf

	call _ecom_spawnUncountedEnemyWithSubid01		; $58c2
	inc a			; $58c5

@initBat:
	inc l			; $58c6
	ld (hl),a ; [var03] = a (0 or 1)
	rrca			; $58c8
	swap a			; $58c9
	jr nz,+			; $58cb
	ld a,$f8		; $58cd
+
	ld l,Enemy.var30 ; Bat's x-offset relative to vire
	ld (hl),a		; $58d1

	ld l,Enemy.relatedObj1		; $58d2
	ld a,Enemy.start		; $58d4
	ldi (hl),a		; $58d6
	ld (hl),d		; $58d7
	jp objectCopyPosition		; $58d8

@substate2:
	; Wait for "bat children" to be killed
	ld e,Enemy.var34		; $58db
	ld a,(de)		; $58dd
	or a			; $58de
	jp nz,_ecom_decCounter2		; $58df

	; Vire defeated
	ld h,d			; $58e2
	ld l,Enemy.state2		; $58e3
	inc (hl)		; $58e5
	inc l			; $58e6
	ld (hl),60 ; [counter1]
	ld a,SNDCTRL_STOPMUSIC		; $58e9
	jp playSound		; $58eb

@substate3:
	call _ecom_decCounter1		; $58ee
	jp nz,_ecom_flickerVisibility		; $58f1

	ld (hl),$10 ; [counter1]
	ld l,e			; $58f6
	inc (hl) ; [state2]
	jp objectSetVisiblec1		; $58f8

@substate4:
	call _ecom_decCounter1		; $58fb
	jp nz,enemyAnimate		; $58fe

	ld l,e			; $5901
	inc (hl) ; [state2]

	ld l,Enemy.angle		; $5903
	ld (hl),$06		; $5905
	ld l,Enemy.speed		; $5907
	ld (hl),SPEED_300		; $5909

	ld bc,TX_2f17		; $590b
	call checkIsLinkedGame		; $590e
	jr z,+			; $5911
	inc c ; TX_2f18
+
	jp showText		; $5914

@substate5:
	call checkIsLinkedGame		; $5917
	jr z,@unlinked	; $591a

@linked:
	ld e,Enemy.health		; $591c
	xor a			; $591e
	ld (de),a		; $591f
	ret			; $5920

@unlinked:
	; Spawn fairy if var38 is 0.
	ld e,Enemy.var38		; $5921
	ld a,(de)		; $5923
	or a			; $5924
	jr nz,++		; $5925
	inc a			; $5927
	ld (de),a		; $5928
	ld b,PARTID_ITEM_DROP		; $5929
	call _ecom_spawnProjectile		; $592b
++
	call enemyAnimate		; $592e

	ld h,d			; $5931
	ld l,Enemy.z		; $5932
	ld a,(hl)		; $5934
	sub <($0080)			; $5935
	ldi (hl),a		; $5937
	ld a,(hl)		; $5938
	sbc >($0080)			; $5939
	ld (hl),a		; $593b

	call _vire_checkOffScreen		; $593c
	jp c,objectApplySpeed		; $593f

	; Vire is gone; cleanup
	call markEnemyAsKilledInRoom		; $5942
	call decNumEnemies		; $5945
	ld a,(wActiveMusic2)		; $5948
	ld (wActiveMusic),a		; $594b
	call playSound		; $594e
	jp enemyDelete		; $5951


_vire_batForm:
	ld a,(de)		; $5954
	sub $08			; $5955
	rst_jumpTable			; $5957
	.dw _vire_batForm_state8
	.dw _vire_batForm_state9
	.dw _vire_batForm_stateA
	.dw _vire_batForm_stateB
	.dw _vire_batForm_stateC
	.dw _vire_batForm_stateD


_vire_batForm_state8:
	ld h,d			; $5964
	ld l,e			; $5965
	inc (hl) ; [state]

	ld l,Enemy.var30		; $5967
	ld a,(hl)		; $5969
	and $1f			; $596a
	ld l,Enemy.angle		; $596c
	ld (hl),a		; $596e

	ld l,Enemy.counter1		; $596f
	ld (hl),$10		; $5971

	ld l,Enemy.health		; $5973
	ld (hl),$01		; $5975

	ld a,$02		; $5977
	call enemySetAnimation		; $5979
	jp objectSetVisiblec1		; $597c


; Moving upward after charging (or after spawning)
_vire_batForm_state9:
	call _ecom_decCounter1		; $597f
	jr z,_vire_batForm_gotoStateA	; $5982

	; Move up while zh > -$10
	ld l,Enemy.zh		; $5984
	ldd a,(hl)		; $5986
	cp $f0			; $5987
	jr c,++			; $5989
	ld a,(hl)		; $598b
	sub <($00c0)			; $598c
	ldi (hl),a		; $598e
	ld a,(hl)		; $598f
	sbc >($00c0)			; $5990
	ld (hl),a		; $5992
++
	call objectApplySpeed		; $5993
	jr _vire_batForm_animate		; $5996

_vire_batForm_gotoStateA:
	ld l,e			; $5998
	ld (hl),$0a ; [state]

	ld l,Enemy.speed		; $599b
	ld (hl),SPEED_80		; $599d

	ld l,Enemy.collisionType		; $599f
	set 7,(hl)		; $59a1

	call getRandomNumber_noPreserveVars		; $59a3
	ld e,Enemy.counter1		; $59a6
	ld (de),a		; $59a8

	; [mainForm.counter2] = 180
	ld a,Object.counter2		; $59a9
	call objectGetRelatedObject1Var		; $59ab
	ld (hl),180		; $59ae
	jr _vire_batForm_animate		; $59b0


_vire_batForm_stateA:
	call _vire_batForm_updateZPos		; $59b2

	ld a,Object.counter2		; $59b5
	call objectGetRelatedObject1Var		; $59b7
	ld a,(hl)		; $59ba
	or a			; $59bb
	jr nz,++		; $59bc

.ifdef ROM_AGES
	call _ecom_incState		; $59be
.else
	ld h,d			; $5a36
	ld l,Enemy.state	; $5a37
	inc (hl)		; $5a39
.endif

	ld l,Enemy.counter1		; $59c1
	ld (hl),$08		; $59c3
	ret			; $59c5
++
	call _vire_batForm_moveAwayFromLinkIfTooClose		; $59c6

	call objectGetAngleTowardEnemyTarget		; $59c9
	ld b,a			; $59cc
	ld e,Enemy.var30		; $59cd
	ld a,(de)		; $59cf
	add b			; $59d0
	and $1f			; $59d1
	ld e,Enemy.angle		; $59d3
	ld (de),a		; $59d5

	ld a,$02		; $59d6
	call _ecom_getSideviewAdjacentWallsBitset		; $59d8
	call z,objectApplySpeed		; $59db

_vire_batForm_animate:
	jp enemyAnimate		; $59de


; About to charge toward Link in [counter1] frames
_vire_batForm_stateB:
	call _ecom_decCounter1		; $59e1
	ret nz			; $59e4

	ld l,e			; $59e5
	inc (hl) ; [state]

	ld l,Enemy.speed		; $59e7
	ld (hl),SPEED_200		; $59e9

	ld l,Enemy.var35		; $59eb
	ldh a,(<hEnemyTargetY)	; $59ed
	ldi (hl),a		; $59ef
	ldh a,(<hEnemyTargetX)	; $59f0
	ld (hl),a		; $59f2
	ret			; $59f3


; Charging toward target position in var35/var36
_vire_batForm_stateC:
	ld h,d			; $59f4
	ld l,Enemy.var35		; $59f5
	call _ecom_readPositionVars		; $59f7
	sub c			; $59fa
	add $08			; $59fb
	cp $11			; $59fd
	jr nc,@notReachedPosition	; $59ff

	ldh a,(<hFF8F)	; $5a01
	sub b			; $5a03
	add $08			; $5a04
	cp $11			; $5a06
	jr nc,@notReachedPosition	; $5a08

	ld l,Enemy.zh		; $5a0a
	ld a,(hl)		; $5a0c
	cp $fa			; $5a0d
	jr c,@notReachedPosition	; $5a0f

	; Reached target position

	ld l,e			; $5a11
	inc (hl) ; [state]
	ld l,Enemy.counter1		; $5a13
	ld (hl),20		; $5a15
	jr _vire_batForm_animate		; $5a17

@notReachedPosition:
	ld l,Enemy.zh		; $5a19
	ld a,(hl)		; $5a1b
	cp $fe			; $5a1c
	jr nc,+			; $5a1e
	inc (hl)		; $5a20
+
	call _ecom_moveTowardPosition		; $5a21
	jr _vire_batForm_animate		; $5a24


; Moving back up after charging
_vire_batForm_stateD:
	call _ecom_decCounter1		; $5a26
	jp z,_vire_batForm_gotoStateA		; $5a29

	ld l,Enemy.zh		; $5a2c
	ldd a,(hl)		; $5a2e
	cp $f0			; $5a2f
	jr c,++			; $5a31

	ld a,(hl)		; $5a33
	sub <($00c0)			; $5a34
	ldi (hl),a		; $5a36
	ld a,(hl)		; $5a37
	sbc >($00c0)			; $5a38
	ld (hl),a		; $5a3a
++
	ld a,$02		; $5a3b
	call _ecom_getSideviewAdjacentWallsBitset		; $5a3d
	call z,objectApplySpeed		; $5a40
	jr _vire_batForm_animate		; $5a43


;;
; Sets Vire's position to just outside the camera (along with corresponding angle), and
; increments state2.
;
; @param[out]	hl	Enemy.state2
; @addr{5a45}
_vire_spawnOutsideCamera:
	call getRandomNumber_noPreserveVars		; $5a45
	and $07			; $5a48
	ld b,a			; $5a4a
	add a			; $5a4b
	add b			; $5a4c
	ld hl,@spawnPositions		; $5a4d
	rst_addAToHl			; $5a50

	ld e,Enemy.yh		; $5a51
	ldh a,(<hCameraY)	; $5a53
	add (hl)		; $5a55
	ld (de),a		; $5a56
	inc hl			; $5a57
	ld e,Enemy.xh		; $5a58
	ldh a,(<hCameraX)	; $5a5a
	add (hl)		; $5a5c
	ld (de),a		; $5a5d

	inc hl			; $5a5e
	ld e,Enemy.angle		; $5a5f
	ld a,(hl)		; $5a61
	ld (de),a		; $5a62

	ld h,d			; $5a63
	ld l,Enemy.collisionType		; $5a64
	set 7,(hl)		; $5a66

	ld l,Enemy.state2		; $5a68
	inc (hl)		; $5a6a
	jp objectSetVisiblec1		; $5a6b

; Data format:
;   b0: y (relative to hCameraY)
;   b1: x (relative to hCameraX)
;   b2: angle
@spawnPositions:
	.db $f8 $10 $10
	.db $f8 $90 $10
	.db $10 $f8 $08
	.db $10 $a8 $18
	.db $70 $f8 $08
	.db $70 $a8 $18
	.db $88 $10 $00
	.db $88 $90 $00

;;
; Vire has left the screen; set state to 9, where he'll wait for 90 frames before
; attacking again.
; @addr{5a86}
_vire_mainForm_leftScreen:
	ld h,d			; $5a86
	ld l,Enemy.state		; $5a87
	ld (hl),$09		; $5a89
	inc l			; $5a8b
	ld (hl),$00 ; [state2]
	inc l			; $5a8e
	ld (hl),90 ; [counter1]

	ld l,Enemy.collisionType		; $5a91
	res 7,(hl)		; $5a93
	jp objectSetInvisible		; $5a95

;;
; @param[out]	cflag	c if left screen
; @addr{5a98}
_vire_checkOffScreen:
	ld e,Enemy.yh		; $5a98
	ld a,(de)		; $5a9a
	cp (LARGE_ROOM_HEIGHT<<4)+8			; $5a9b
	ret nc			; $5a9d
	ld e,Enemy.xh		; $5a9e
	ld a,(de)		; $5aa0
	cp (LARGE_ROOM_WIDTH<<4)			; $5aa1
	ret			; $5aa3


;;
; @addr{5aa4}
_vire_mainForm_circleAroundScreen:
	ldh a,(<hCameraY)	; $5aa4
	add (SCREEN_HEIGHT<<3)+4			; $5aa6
	ld b,a			; $5aa8
	ldh a,(<hCameraX)	; $5aa9
	add SCREEN_WIDTH<<3			; $5aab
	ld c,a			; $5aad
	push bc			; $5aae
	call objectGetRelativeAngle		; $5aaf
	pop bc			; $5ab2

	ld h,a			; $5ab3
	ld e,Enemy.yh		; $5ab4
	ld a,(de)		; $5ab6
	sub b			; $5ab7
	jr nc,+		; $5ab8
	cpl			; $5aba
	inc a			; $5abb
+
	ld b,a			; $5abc
	cp $3e			; $5abd
	ld a,h			; $5abf
	jr nc,@setAngleAndSpeed	; $5ac0

	ld e,Enemy.xh		; $5ac2
	ld a,(de)		; $5ac4
	sub c			; $5ac5
	jr nc,+			; $5ac6
	cpl			; $5ac8
	inc a			; $5ac9
+
	ld c,a			; $5aca
	cp $3e			; $5acb
	ld a,h			; $5acd
	jr nc,@setAngleAndSpeed	; $5ace

	ld a,b			; $5ad0
	add c			; $5ad1
	sub $42			; $5ad2
	cp $08			; $5ad4
	jr c,@offsetAngle	; $5ad6

	rlca			; $5ad8
	ld a,h			; $5ad9
	jr nc,@setAngleAndSpeed	; $5ada

	xor $10			; $5adc

@setAngleAndSpeed:
	push hl			; $5ade
	ld e,Enemy.angle		; $5adf
	ld (de),a		; $5ae1
	ld e,Enemy.speed		; $5ae2
	ld a,SPEED_40		; $5ae4
	ld (de),a		; $5ae6
	call objectApplySpeed		; $5ae7
	pop hl			; $5aea

@offsetAngle:
	ld e,Enemy.var30		; $5aeb
	ld a,(de)		; $5aed
	add h			; $5aee
	and $1f			; $5aef
	ld e,Enemy.angle		; $5af1
	ld (de),a		; $5af3

	ld e,Enemy.speed		; $5af4
	ld a,SPEED_e0		; $5af6
	ld (de),a		; $5af8


;;
; @addr{5af9}
_vire_mainForm_applySpeedAndAnimate:
	call objectApplySpeed		; $5af9
	jp enemyAnimate		; $5afc

;;
; @param[out]	cflag	c if Link is too close (Vire will flee)
; @addr{5aff}
_vire_mainForm_checkLinkTooClose:
	ld h,d			; $5aff
	ld l,Enemy.yh		; $5b00
	ldh a,(<hEnemyTargetY)	; $5b02
	sub (hl)		; $5b04
	add 30			; $5b05
	cp 61			; $5b07
	ret nc			; $5b09
	ld l,Enemy.xh		; $5b0a
	ldh a,(<hEnemyTargetX)	; $5b0c
	sub (hl)		; $5b0e
	add 30			; $5b0f
	cp 61			; $5b11
	ret			; $5b13


;;
; @addr{5b14}
_vire_mainForm_fireProjectile:
	call getRandomNumber_noPreserveVars		; $5b14
	and $01			; $5b17
	inc a			; $5b19
	ld b,a			; $5b1a

;;
; @param	b	Subid
; @addr{5b1b}
_vire_mainForm_fireProjectileWithSubid:
	call getFreePartSlot		; $5b1b
	ret nz			; $5b1e
	ld (hl),PARTID_VIRE_PROJECTILE		; $5b1f
	inc l			; $5b21
	ld (hl),b ; [subid]

	ld l,Part.relatedObj1+1		; $5b23
	ld (hl),d		; $5b25
	dec l			; $5b26
	ld (hl),Enemy.start		; $5b27

	call objectCopyPosition		; $5b29
	ld a,SND_SPLASH		; $5b2c
	call playSound		; $5b2e

	ld e,Enemy.direction		; $5b31
	ld a,$01		; $5b33
	ld (de),a		; $5b35
	jp enemySetAnimation		; $5b36

;;
; @addr{5b39}
_vire_batForm_moveAwayFromLinkIfTooClose:
	ld h,d			; $5b39
	ld l,Enemy.yh		; $5b3a
	ldh a,(<hEnemyTargetY)	; $5b3c
	sub (hl)		; $5b3e
	add 12			; $5b3f
	cp 25			; $5b41
	ret nc			; $5b43
	ld l,Enemy.xh		; $5b44
	ldh a,(<hEnemyTargetX)	; $5b46
	sub (hl)		; $5b48
	add 12			; $5b49
	cp 25			; $5b4b
	ret nc			; $5b4d

	call objectGetAngleTowardEnemyTarget		; $5b4e
	xor $10			; $5b51
	ld c,a			; $5b53
	ld b,SPEED_200		; $5b54
	jp _ecom_applyGivenVelocity		; $5b56


;;
; @addr{5b59}
_vire_batForm_updateZPos:
	call _ecom_decCounter1		; $5b59
	ld a,(hl)		; $5b5c
	and $1c			; $5b5d
	rrca			; $5b5f
	rrca			; $5b60
	ld hl,@zVals		; $5b61
	rst_addAToHl			; $5b64
	ld e,Enemy.zh		; $5b65
	ld a,(hl)		; $5b67
	ld (de),a		; $5b68
	ret			; $5b69

@zVals:
	.db $f0 $f1 $f0 $ef $ee $ed $ee $ef


; ==============================================================================
; ENEMYID_ANGLER_FISH
;
; Variables:
;   relatedObj1: reference to other subid (main <-> antenna)
; ==============================================================================
enemyCode76:
	jr z,@normalStatus	; $5b72
	sub ENEMYSTATUS_NO_HEALTH			; $5b74
	ret c			; $5b76
	jr nz,@justHit	; $5b77

	; ENEMYSTATUS_DEAD
	ld e,Enemy.subid		; $5b79
	ld a,(de)		; $5b7b
	or a			; $5b7c
	jp z,_enemyBoss_dead		; $5b7d
	call _ecom_killRelatedObj1		; $5b80
	jp enemyDelete		; $5b83

@justHit:
	ld e,Enemy.subid		; $5b86
	ld a,(de)		; $5b88
	or a			; $5b89
	jr z,@fishHit	; $5b8a

@antennaHit:
	ld a,Object.invincibilityCounter		; $5b8c
	call objectGetRelatedObject1Var		; $5b8e
	ld e,l			; $5b91
	ld a,(de)		; $5b92
	ld (hl),a		; $5b93
	jr @normalStatus		; $5b94

@fishHit:
	ld e,Enemy.var2a		; $5b96
	ld a,(de)		; $5b98
	cp $80|ITEMCOLLISION_SCENT_SEED			; $5b99
	jr nz,@normalStatus	; $5b9b

	ld h,d			; $5b9d
	ld l,Enemy.state		; $5b9e
	ld (hl),$0d		; $5ba0

	ld l,Enemy.collisionType		; $5ba2
	res 7,(hl)		; $5ba4

	ld e,Enemy.direction		; $5ba6
	ld a,(de)		; $5ba8
	and $01			; $5ba9
	add $04			; $5bab
	ld (de),a		; $5bad
	call enemySetAnimation		; $5bae

	ld b,INTERACID_EXPLOSION		; $5bb1
	call objectCreateInteractionWithSubid00		; $5bb3

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5bb6
	jr c,@commonState	; $5bb9
	ld a,b			; $5bbb
	or a			; $5bbc
	jp z,anglerFish_main		; $5bbd
	jp _anglerFish_antenna		; $5bc0

@commonState:
	rst_jumpTable			; $5bc3
	.dw _anglerFish_state_uninitialized
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub
	.dw _anglerFish_state_stub


_anglerFish_state_uninitialized:
	ld a,$ff		; $5bd4
	ld b,$00		; $5bd6
	call _enemyBoss_initializeRoom		; $5bd8

	; If bit 7 of subid is set, it's already been initialized
	ld e,Enemy.subid		; $5bdb
	ld a,(de)		; $5bdd
	bit 7,a			; $5bde
	res 7,a			; $5be0
	ld (de),a		; $5be2
	jr nz,@doneInit	; $5be3

	; Subid 1 has no special initialization
	dec a			; $5be5
	jr z,@doneInit	; $5be6

	; Subid 0 initialization; spawn subid 1, set their relatedObj1 to each other
	ld b,ENEMYID_ANGLER_FISH		; $5be8
	call _ecom_spawnUncountedEnemyWithSubid01		; $5bea
	ret nz			; $5bed
	ld e,Enemy.relatedObj1		; $5bee
	ld l,e			; $5bf0
	ld a,Enemy.start		; $5bf1
	ld (de),a		; $5bf3
	ldi (hl),a		; $5bf4
	inc e			; $5bf5
	ld (hl),d		; $5bf6
	ld a,h			; $5bf7
	ld (de),a		; $5bf8

	; Make sure subid 0 comes before subid 1, otherwise swap them
	ld a,h			; $5bf9
	cp d			; $5bfa
	jr nc,@doneInit	; $5bfb
	ld l,Enemy.subid		; $5bfd
	ld (hl),$80		; $5bff
	ld e,l			; $5c01
	ld a,$01		; $5c02
	ld (de),a		; $5c04
@doneInit:
	jp _ecom_setSpeedAndState8		; $5c05


_anglerFish_state_stub:
	ret			; $5c08


anglerFish_main:
	ld a,(de)		; $5c09
	sub $08			; $5c0a
	rst_jumpTable			; $5c0c
	.dw anglerFish_main_state8
	.dw anglerFish_main_state9
	.dw anglerFish_main_stateA
	.dw anglerFish_main_stateB
	.dw anglerFish_main_stateC
	.dw anglerFish_main_stateD
	.dw anglerFish_main_stateE
	.dw anglerFish_main_stateF


; Waiting for Link to enter
anglerFish_main_state8:
	ld a,(w1Link.state)		; $5c1d
	cp LINK_STATE_FORCE_MOVEMENT			; $5c20
	ret z			; $5c22
	call checkLinkVulnerable		; $5c23
	ret nc			; $5c26

	ld a,DISABLE_LINK		; $5c27
	ld (wDisabledObjects),a		; $5c29
	ld (wMenuDisabled),a		; $5c2c

	ld a,$42		; $5c2f
	ld c,$80		; $5c31
	call setTile		; $5c33
	ld a,$52		; $5c36
	ld c,$90		; $5c38
	call setTile		; $5c3a

	call _ecom_incState		; $5c3d
	ld l,Enemy.counter1		; $5c40
	ld (hl),30		; $5c42
	ld a,SND_DOORCLOSE		; $5c44
	jp playSound		; $5c46


; Delay before starting fight
anglerFish_main_state9:
	call _ecom_decCounter1		; $5c49
	ret nz			; $5c4c

	ld l,e			; $5c4d
	inc (hl) ; [state]

	ld l,Enemy.angle		; $5c4f
	ld (hl),ANGLE_LEFT		; $5c51
	ld l,Enemy.speed		; $5c53
	ld (hl),SPEED_c0		; $5c55

	jp objectSetVisible82		; $5c57


; Falling to the ground, then the fight will begin
anglerFish_main_stateA:
	ld b,$0c		; $5c5a
	ld a,$10		; $5c5c
	call objectUpdateSpeedZ_sidescroll_givenYOffset		; $5c5e
	jr c,@hitGround	; $5c61

	ld l,Enemy.speedZ+1		; $5c63
	ld a,(hl)		; $5c65
	cp $02			; $5c66
	ret c			; $5c68
	ld (hl),$02		; $5c69
	ret			; $5c6b

@hitGround:
	call _enemyBoss_beginMiniboss		; $5c6c
	call _ecom_incState		; $5c6f

	ld l,Enemy.counter2		; $5c72
	ld (hl),180		; $5c74

_anglerFish_bounceOffGround:
	ld h,d			; $5c76
	ld l,Enemy.speedZ		; $5c77
	ld a,<(-$320)		; $5c79
	ldi (hl),a		; $5c7b
	ld (hl),>(-$320)		; $5c7c

	ld a,SND_POOF		; $5c7e
	jp playSound		; $5c80


; Bouncing around normally
anglerFish_main_stateB:
	call _ecom_decCounter2		; $5c83
	call z,anglerFish_main_checkFireProjectile		; $5c86

_anglerFish_updatePosition:
	ld b,$0c		; $5c89
	ld a,$10		; $5c8b
	call objectUpdateSpeedZ_sidescroll_givenYOffset		; $5c8d
	jr nc,_anglerFish_applySpeed	; $5c90

	; Hit ground
	call _anglerFish_bounceOffGround		; $5c92

	call getRandomNumber_noPreserveVars		; $5c95
	and $10			; $5c98
	add $08			; $5c9a
	ld e,Enemy.angle		; $5c9c
	ld (de),a		; $5c9e

	and $10			; $5c9f
	xor $10			; $5ca1
	swap a			; $5ca3
	ld b,a			; $5ca5
	ld e,Enemy.direction		; $5ca6
	ld a,(de)		; $5ca8
	and $01			; $5ca9
	cp b			; $5cab
	call nz,_anglerFish_updateAnimation		; $5cac

_anglerFish_applySpeed:
	call objectApplySpeed		; $5caf
	call _ecom_bounceOffWallsAndHoles		; $5cb2
	jp z,enemyAnimate		; $5cb5

_anglerFish_updateAnimation:
	ld e,Enemy.direction		; $5cb8
	ld a,(de)		; $5cba
	xor $01			; $5cbb
	ld (de),a		; $5cbd
	jp enemySetAnimation		; $5cbe


; Firing a projectile
anglerFish_main_stateC:
	ld e,Enemy.animParameter		; $5cc1
	ld a,(de)		; $5cc3
	inc a			; $5cc4
	jr z,@doneFiring	; $5cc5
	dec a			; $5cc7
	jr z,_anglerFish_updatePosition	; $5cc8

	; Time to spawn the projectile
	xor a			; $5cca
	ld (de),a		; $5ccb
	call getFreeEnemySlot_uncounted		; $5ccc
	jr nz,_anglerFish_updatePosition	; $5ccf

	ld (hl),ENEMYID_ANGLER_FISH_BUBBLE		; $5cd1
	ld l,Enemy.relatedObj1		; $5cd3
	ld a,Enemy.start		; $5cd5
	ldi (hl),a		; $5cd7
	ld (hl),d		; $5cd8

	ld a,SND_FALLINHOLE		; $5cd9
	call playSound		; $5cdb
	jr _anglerFish_updatePosition		; $5cde

@doneFiring:
	ld h,d			; $5ce0
	ld l,Enemy.state		; $5ce1
	dec (hl)		; $5ce3

	ld l,Enemy.direction		; $5ce4
	ld a,(hl)		; $5ce6
	sub $02			; $5ce7
	ld (hl),a		; $5ce9
	call enemySetAnimation		; $5cea

	jr _anglerFish_updatePosition		; $5ced


; Just hit with a scent seed, falling to ground
anglerFish_main_stateD:
	ld a,$20		; $5cef
	call objectUpdateSpeedZ_sidescroll		; $5cf1
	ret nc			; $5cf4

	call _ecom_incState		; $5cf5
	ld l,Enemy.counter1		; $5cf8
	ld (hl),150		; $5cfa
	ret			; $5cfc


; Vulnerable for [counter1] frames
anglerFish_main_stateE:
	call _ecom_decCounter1		; $5cfd
	jp nz,enemyAnimate		; $5d00

	ld l,e			; $5d03
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $5d05
	ld a,<(-$400)		; $5d07
	ldi (hl),a		; $5d09
	ld (hl),>(-$400)		; $5d0a
	ret			; $5d0c


; Bouncing back up after being deflated
anglerFish_main_stateF:
	ld a,$20		; $5d0d
	call objectUpdateSpeedZ_sidescroll		; $5d0f

	ld l,Enemy.speedZ+1		; $5d12
	ld a,(hl)		; $5d14
	or a			; $5d15
	jr nz,_anglerFish_applySpeed	; $5d16

	ld l,Enemy.state		; $5d18
	ld (hl),$0b		; $5d1a

	ld l,Enemy.collisionType		; $5d1c
	set 7,(hl)		; $5d1e

	ld l,Enemy.counter1		; $5d20
	ld (hl),180		; $5d22

	ld l,Enemy.direction		; $5d24
	ld a,(hl)		; $5d26
	sub $04			; $5d27
	ld (hl),a		; $5d29
	call enemySetAnimation		; $5d2a

	ld a,SND_POOF		; $5d2d
	jp playSound		; $5d2f


_anglerFish_antenna:
	ld a,(de)		; $5d32
	cp $08			; $5d33
	jr z,@state8	; $5d35

@state9:
	ld a,Object.direction		; $5d37
	call objectGetRelatedObject1Var		; $5d39
	ld a,(hl)		; $5d3c
	push hl			; $5d3d

	ld hl,@positionOffsets		; $5d3e
	rst_addDoubleIndex			; $5d41
	ldi a,(hl)		; $5d42
	ld b,a			; $5d43
	ld c,(hl)		; $5d44

	pop hl			; $5d45
	call objectTakePositionWithOffset		; $5d46
	ld l,Enemy.invincibilityCounter		; $5d49
	ld a,(hl)		; $5d4b
	or a			; $5d4c
	jp nz,objectSetInvisible		; $5d4d

	ld a,(wFrameCounter)		; $5d50
	rrca			; $5d53
	ret c			; $5d54
	jp _ecom_flickerVisibility		; $5d55

@positionOffsets:
	.db $f0 $f6
	.db $f0 $0a
	.db $f0 $f6
	.db $f0 $0a
	.db $fc $f7
	.db $fc $09

@state8:
	ld h,d			; $5d64
	ld l,e			; $5d65
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $5d67
	ld (hl),ENEMYCOLLISION_ANGLER_FISH_ANTENNA		; $5d69

	ld l,Enemy.collisionRadiusY		; $5d6b
	ld a,$03		; $5d6d
	ldi (hl),a		; $5d6f
	ld (hl),a		; $5d70

	ld l,Enemy.oamTileIndexBase		; $5d71
	ld (hl),$1e		; $5d73

	ld l,Enemy.oamFlagsBackup		; $5d75
	ld a,$0d		; $5d77
	ldi (hl),a		; $5d79
	ld (hl),a		; $5d7a

	ld a,$06		; $5d7b
	jp enemySetAnimation		; $5d7d

;;
; Changes state to $0c if conditions are appropriate to fire a projectile.
; @addr{5d80}
anglerFish_main_checkFireProjectile:
	ld e,Enemy.yh		; $5d80
	ld a,(de)		; $5d82
	cp $5c			; $5d83
	ret nc			; $5d85
	ld e,Enemy.xh		; $5d86
	ld a,(de)		; $5d88
	sub $38			; $5d89
	cp $70			; $5d8b
	ret nc			; $5d8d

	ld (hl),180		; $5d8e
	ld l,Enemy.state		; $5d90
	inc (hl)		; $5d92
	ld l,Enemy.direction		; $5d93
	ld a,(hl)		; $5d95
	add $02			; $5d96
	ld (hl),a		; $5d98
	jp enemySetAnimation		; $5d99


; ==============================================================================
; ENEMYID_BLUE_STALFOS
;
; Variables (for subid 1, "main" enemy):
;   var30/var31: Destination position while moving
;   var32: Projectile pattern index; number from 0-7 which cycles through ball types.
;          (Used by PARTID_BLUE_STALFOS_PROJECTILE.)
;
; Variables (for subid 3, the afterimage):
;   var30/var31: Y/X position?
;   var32: Index in position differenc buffer?
;   var33-var3a: Position difference buffer?
; ==============================================================================
enemyCode77:
	jr z,@normalStatus	; $5d9c
	sub ENEMYSTATUS_NO_HEALTH			; $5d9e
	ret c			; $5da0
	jp z,_enemyBoss_dead		; $5da1
	dec a			; $5da4
	jr nz,@normalStatus	; $5da5

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5da7
	jr nc,@normalState	; $5daa
	rst_jumpTable			; $5dac
	.dw _blueStalfos_state_uninitialized
	.dw _blueStalfos_state_spawner
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub
	.dw _blueStalfos_state_stub

@normalState:
	dec b			; $5dbd
	ld a,b			; $5dbe
	rst_jumpTable			; $5dbf
	.dw _blueStalfos_subid1
	.dw _blueStalfos_subid2
	.dw _blueStalfos_subid3


_blueStalfos_state_uninitialized:
	ld a,b			; $5dc6
	sub $02			; $5dc7
	call c,objectSetVisible82		; $5dc9
	ld a,b			; $5dcc
	or a			; $5dcd
	jp nz,_ecom_setSpeedAndState8		; $5dce

	; Spawner (subid 0) only
	call _ecom_incState		; $5dd1
	ld l,Enemy.zh		; $5dd4
	ld (hl),$ff		; $5dd6
	ld a,ENEMYID_BLUE_STALFOS		; $5dd8
	jp _enemyBoss_initializeRoom		; $5dda


_blueStalfos_state_spawner:
	ld b,$03		; $5ddd
	call checkBEnemySlotsAvailable		; $5ddf
	ret nz			; $5de2

	; Spawn subid 1
	ld b,ENEMYID_BLUE_STALFOS		; $5de3
	call _ecom_spawnUncountedEnemyWithSubid01		; $5de5
	call objectCopyPosition		; $5de8
	ld l,Enemy.enabled		; $5deb
	ld e,l			; $5ded
	ld a,(de)		; $5dee
	ld (hl),a		; $5def

	; Spawn subid 2
	ld c,h			; $5df0
	call _ecom_spawnUncountedEnemyWithSubid01		; $5df1
	inc (hl)		; $5df4

	; [subid2.relatedObj1] = subid1
	ld l,Enemy.relatedObj1		; $5df5
	ld a,Enemy.start		; $5df7
	ldi (hl),a		; $5df9
	ld (hl),c		; $5dfa

	call objectCopyPosition		; $5dfb

	; Spawn subid 3
	call _ecom_spawnUncountedEnemyWithSubid01		; $5dfe
	ld (hl),$03		; $5e01

	; [subid3.relatedObj1] = subid1
	ld l,Enemy.relatedObj1		; $5e03
	ld a,Enemy.start		; $5e05
	ldi (hl),a		; $5e07
	ld (hl),c		; $5e08

	call objectCopyPosition		; $5e09

	jp enemyDelete		; $5e0c


_blueStalfos_state_stub:
	ret			; $5e0f


_blueStalfos_subid1:
	ld a,(de)		; $5e10
	sub $08			; $5e11
	rst_jumpTable			; $5e13
	.dw _blueStalfos_main_state08
	.dw _blueStalfos_main_state09
	.dw _blueStalfos_main_state0a
	.dw _blueStalfos_main_state0b
	.dw _blueStalfos_main_state0c
	.dw _blueStalfos_main_state0d
	.dw _blueStalfos_main_state0e
	.dw _blueStalfos_main_state0f
	.dw _blueStalfos_main_state10
	.dw _blueStalfos_main_state11
	.dw _blueStalfos_main_state12
	.dw _blueStalfos_main_state13
	.dw _blueStalfos_main_state14
	.dw _blueStalfos_main_state15
	.dw _blueStalfos_main_state16
	.dw _blueStalfos_main_state17


_blueStalfos_main_state08:
	ld bc,$010b		; $5e34
	call _enemyBoss_spawnShadow		; $5e37
	ret nz			; $5e3a

	call _ecom_incState		; $5e3b

	ld l,Enemy.speed		; $5e3e
	ld (hl),SPEED_200		; $5e40
	ld l,Enemy.angle		; $5e42
	ld (hl),ANGLE_DOWN		; $5e44
	ret			; $5e46


; Moving down before fight starts
_blueStalfos_main_state09:
	call objectApplySpeed		; $5e47
	ld e,Enemy.yh		; $5e4a
	ld a,(de)		; $5e4c
	cp $58			; $5e4d
	jr nz,_blueStalfos_main_animate	; $5e4f

	; Fight starts now
	call _ecom_incState		; $5e51

	ld l,Enemy.counter1		; $5e54
	ld (hl),$40		; $5e56
	ld l,Enemy.speed		; $5e58
	ld (hl),SPEED_20		; $5e5a

	ld a,MUS_MINIBOSS		; $5e5c
	ld (wActiveMusic),a		; $5e5e
	call playSound		; $5e61

	ld e,$0f		; $5e64
	ld bc,$3030		; $5e66
	call _ecom_randomBitwiseAndBCE		; $5e69
	ld a,e			; $5e6c
	jp _blueStalfos_main_moveToQuadrant		; $5e6d


; Moving to position in var30/var31
_blueStalfos_main_state0a:
	ld h,d			; $5e70
	ld l,Enemy.var30		; $5e71
	call _ecom_readPositionVars		; $5e73
	sub c			; $5e76
	add $04			; $5e77
	cp $09			; $5e79
	jr nc,@moveToPosition	; $5e7b

	ldh a,(<hFF8F)	; $5e7d
	sub b			; $5e7f
	add $04			; $5e80
	cp $09			; $5e82
	jr nc,@moveToPosition	; $5e84

	; Reached target position
	ld h,d			; $5e86
	ld l,Enemy.state		; $5e87
	ld (hl),$0b		; $5e89
	ld l,Enemy.counter1		; $5e8b
	ld (hl),$10		; $5e8d
	jr _blueStalfos_main_animate		; $5e8f

@moveToPosition:
	call _blueStalfos_main_accelerate		; $5e91
	call _ecom_moveTowardPosition		; $5e94
	jr _blueStalfos_main_animate		; $5e97


; Reached position, standing still for [counter1] frames
_blueStalfos_main_state0b:
	call _ecom_decCounter1		; $5e99
	jr nz,_blueStalfos_main_animate	; $5e9c

	ld l,e			; $5e9e
	inc (hl) ; [state]

_blueStalfos_main_animate:
	jp enemyAnimate		; $5ea0


; Decide which attack to do
_blueStalfos_main_state0c:
	ld e,Enemy.yh		; $5ea3
	ld a,(de)		; $5ea5
	add $10			; $5ea6
	ld b,a			; $5ea8
	ld e,Enemy.xh		; $5ea9
	ld a,(de)		; $5eab
	add $04			; $5eac
	ld c,a			; $5eae

	; If Link is close enough, use the sickle on him
	ldh a,(<hEnemyTargetY)	; $5eaf
	sub b			; $5eb1
	add $14			; $5eb2
	cp $29			; $5eb4
	jr nc,@projectileAttack	; $5eb6
	ldh a,(<hEnemyTargetX)	; $5eb8
	sub c			; $5eba
	add $12			; $5ebb
	cp $25			; $5ebd
	jp c,_blueStalfos_main_beginSickleAttack		; $5ebf

@projectileAttack:
	ld b,PARTID_BLUE_STALFOS_PROJECTILE		; $5ec2
	call _ecom_spawnProjectile		; $5ec4
	ret nz			; $5ec7
	ld h,d			; $5ec8
	ld l,Enemy.counter1		; $5ec9
	ld (hl),120		; $5ecb
	ld l,Enemy.state		; $5ecd
	ld (hl),$0e		; $5ecf
	ld a,$02		; $5ed1
	jp enemySetAnimation		; $5ed3


; Sickle attack
_blueStalfos_main_state0d:
	call enemyAnimate		; $5ed6
	ld e,Enemy.animParameter		; $5ed9
	ld a,(de)		; $5edb
	inc a			; $5edc
	jr z,_blueStalfos_main_finishedAttack	; $5edd

	dec a			; $5edf
	ret nz			; $5ee0

	ld a,$08		; $5ee1
	ld (de),a ; [animParameter]

	ld a,SND_SWORDSPIN		; $5ee4
	jp playSound		; $5ee6


; Charging a projectile
_blueStalfos_main_state0e:
	call _ecom_decCounter1		; $5ee9
	jr nz,_blueStalfos_main_animate	; $5eec

	ld (hl),60		; $5eee
	ld l,e			; $5ef0
	inc (hl) ; [state]
	ld a,$03		; $5ef2
	jp enemySetAnimation		; $5ef4


; Just fired projectile
_blueStalfos_main_state0f:
	call _ecom_decCounter1		; $5ef7
	ret nz			; $5efa

_blueStalfos_main_finishedAttack:
	ld h,d			; $5efb
	ld l,Enemy.state		; $5efc
	ld (hl),$0a		; $5efe
	ld l,Enemy.counter1		; $5f00
	ld (hl),$40		; $5f02
	ld l,Enemy.speed		; $5f04
	ld (hl),SPEED_20		; $5f06
	xor a			; $5f08
	call enemySetAnimation		; $5f09
	jp _blueStalfos_main_decideNextPosition		; $5f0c


; Link just turned into a baby; about to turn transparent and warp to top of room
_blueStalfos_main_state10:
	call _ecom_decCounter1		; $5f0f
	jr nz,_blueStalfos_main_animate	; $5f12

	ld (hl),$10 ; [counter1]
	ld l,e			; $5f16
	inc (hl) ; [state]
	ld l,Enemy.collisionType		; $5f18
	res 7,(hl)		; $5f1a
	ret			; $5f1c


; Now transparent; waiting for [counter1] frames before warping
_blueStalfos_main_state11:
	call _ecom_decCounter1		; $5f1d
	jp nz,_ecom_flickerVisibility		; $5f20

	ld (hl),$08 ; [counter1]
	ld l,e			; $5f25
	inc (hl) ; [state]
	ld l,Enemy.collisionType		; $5f27
	set 7,(hl)		; $5f29

	ld l,Enemy.yh		; $5f2b
	ld (hl),$0c		; $5f2d
	ld l,Enemy.xh		; $5f2f
	ldh a,(<hEnemyTargetX)	; $5f31
	ld (hl),a		; $5f33

	xor a			; $5f34
	call enemySetAnimation		; $5f35
	jp objectSetInvisible		; $5f38


; Just warped to top of room; standing in place
_blueStalfos_main_state12:
	call _ecom_decCounter1		; $5f3b
	jp nz,_ecom_flickerVisibility		; $5f3e

	ld l,Enemy.angle		; $5f41
	ld (hl),$10		; $5f43

	ld l,e			; $5f45
	inc (hl) ; [state]

	call getRandomNumber_noPreserveVars		; $5f47
	and $03			; $5f4a
	ld hl,@speedTable		; $5f4c
	rst_addAToHl			; $5f4f
	ld e,Enemy.speed		; $5f50
	ld a,(hl)		; $5f52
	ld (de),a		; $5f53

	jp objectSetVisible82		; $5f54

@speedTable:
	.db SPEED_180, SPEED_1c0, SPEED_200, SPEED_300


; Moving down toward baby Link before attacking with sickle
_blueStalfos_main_state13:
	ld h,d			; $5f5b
	ld l,Enemy.yh		; $5f5c
	ldh a,(<hEnemyTargetY)	; $5f5e
	sub (hl)		; $5f60
	cp $18			; $5f61
	jp nc,objectApplySpeed		; $5f63

_blueStalfos_main_beginSickleAttack:
	ld e,Enemy.state		; $5f66
	ld a,$0d		; $5f68
	ld (de),a		; $5f6a
	ld a,$01		; $5f6b
	jp enemySetAnimation		; $5f6d


; Just hit by PARTID_BLUE_STALFOS_PROJECTILE; turning into a small bat
_blueStalfos_main_state14:
	call _blueStalfos_createPuff		; $5f70
	ret nz			; $5f73

	ld l,Enemy.state		; $5f74
	inc (hl)		; $5f76
	ld l,Enemy.collisionRadiusY		; $5f77
	ld (hl),$02		; $5f79
	inc l			; $5f7b
	ld (hl),$06		; $5f7c

	ld l,Enemy.counter1		; $5f7e
	ld (hl),$f0		; $5f80
	inc l			; $5f82
	ld (hl),$00 ; [counter2]

	ld l,Enemy.speed		; $5f85
	ld (hl),SPEED_c0		; $5f87

	call objectSetInvisible		; $5f89

	ld a,SND_SCENT_SEED		; $5f8c
	call playSound		; $5f8e

	ld a,$04		; $5f91
	jp enemySetAnimation		; $5f93


; Transforming into bat
_blueStalfos_main_state15:
	ld a,Object.animParameter		; $5f96
	call objectGetRelatedObject2Var		; $5f98
	bit 7,(hl)		; $5f9b
	ret nz			; $5f9d

	call _ecom_incState		; $5f9e

	ld l,Enemy.enemyCollisionMode		; $5fa1
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS_BAT		; $5fa3

	ld l,Enemy.zh		; $5fa5
	ld (hl),$00		; $5fa7

	jp objectSetVisiblec2		; $5fa9


; Flying around as a bat
_blueStalfos_main_state16:
	call _ecom_decCounter1		; $5fac
	jr nz,@flyAround	; $5faf

	; Time to transform back into stalfos

	inc (hl) ; [counter1] = 1
	call _blueStalfos_createPuff		; $5fb2
	ret nz			; $5fb5

	ld l,Enemy.state		; $5fb6
	inc (hl)		; $5fb8

	ld l,Enemy.enemyCollisionMode		; $5fb9
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS		; $5fbb
	ld l,Enemy.zh		; $5fbd
	ld (hl),$ff		; $5fbf
	jp objectSetInvisible		; $5fc1

@flyAround:
	call _ecom_decCounter2		; $5fc4
	jr nz,++		; $5fc7
	ld (hl),30 ; [counter2]
	call _ecom_setRandomAngle		; $5fcb
++
	call _ecom_bounceOffWallsAndHoles		; $5fce
	call objectApplySpeed		; $5fd1
	jp enemyAnimate		; $5fd4


; Transforming back into stalfos
_blueStalfos_main_state17:
	ld a,Object.animParameter		; $5fd7
	call objectGetRelatedObject2Var		; $5fd9
	bit 7,(hl)		; $5fdc
	ret nz			; $5fde

	ld e,Enemy.collisionRadiusY		; $5fdf
	ld a,$08		; $5fe1
	ld (de),a		; $5fe3
	inc e			; $5fe4
	ld (de),a		; $5fe5

	call _blueStalfos_main_finishedAttack		; $5fe6
	ld a,SND_SCENT_SEED		; $5fe9
	call playSound		; $5feb
	jp objectSetVisible82		; $5fee


; Hitbox for the sickle (invisible)
_blueStalfos_subid2:
	ld a,(de)		; $5ff1
	sub $08			; $5ff2
	jr z,_blueStalfos_initSubid2Or3	; $5ff4

@state9:
	ld a,Object.id		; $5ff6
	call objectGetRelatedObject1Var		; $5ff8
	ld a,(hl)		; $5ffb
	cp ENEMYID_BLUE_STALFOS			; $5ffc
	jp nz,enemyDelete		; $5ffe

	; [this.collisionType] = [subid0.collisionType]
	ld l,Enemy.collisionType		; $6001
	ld e,l			; $6003
	ld a,(hl)		; $6004
	ld (de),a		; $6005

	; Set collision and hitbox based on [subid0.animParameter]
	ld l,Enemy.animParameter		; $6006
	ld a,(hl)		; $6008
	cp $ff			; $6009
	jr nz,+			; $600b
	ld a,$0c		; $600d
+
	ld bc,@positionAndHitboxTable		; $600f
	call addAToBc		; $6012

	ld l,Enemy.yh		; $6015
	ld e,l			; $6017
	ld a,(bc)		; $6018
	add (hl)		; $6019
	ld (de),a		; $601a

	inc bc			; $601b
	ld l,Enemy.xh		; $601c
	ld e,l			; $601e
	ld a,(bc)		; $601f
	add (hl)		; $6020
	ld (de),a		; $6021

	inc bc			; $6022
	ld e,Enemy.collisionRadiusY		; $6023
	ld a,(bc)		; $6025
	ld (de),a		; $6026

	inc bc			; $6027
	inc e			; $6028
	ld a,(bc)		; $6029
	ld (de),a		; $602a

	; If collision size is 0, disable collisions
	or a			; $602b
	ret nz			; $602c
	ld h,d			; $602d
	ld l,Enemy.collisionType		; $602e
	res 7,(hl)		; $6030
	ret			; $6032

; Data format:
;   b0: Y offset
;   b1: X offset
;   b2: collisionRadiusY
;   b3: collisionRadiusX
@positionAndHitboxTable:
	.db $04 $0d $08 $03
	.db $f0 $04 $03 $0a
	.db $0c $06 $14 $0c
	.db $14 $fc $04 $0a
	.db $f4 $0e $04 $06
	.db $f6 $0c $04 $06
	.db $f4 $0a $04 $06
	.db $f2 $0c $04 $06
	.db $00 $00 $00 $00


_blueStalfos_initSubid2Or3:
	ld h,d			; $6057
	ld l,e			; $6058
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $605a
	ld (hl),ENEMYCOLLISION_BLUE_STALFOS_SICKLE		; $605c

	ld a,Object.zh		; $605e
	call objectGetRelatedObject1Var		; $6060
	ld e,l			; $6063
	ld a,(hl)		; $6064
	ld (de),a		; $6065
	ret			; $6066


; "Afterimage" of blue stalfos visible while moving
_blueStalfos_subid3:
	ld a,(de)		; $6067
	sub $08			; $6068
	jr z,@state8	; $606a

@state9:
	ld a,Object.id		; $606c
	call objectGetRelatedObject1Var		; $606e
	ld a,(hl)		; $6071
	cp ENEMYID_BLUE_STALFOS			; $6072
	jp nz,enemyDelete		; $6074

	ld l,Enemy.state		; $6077
	ld a,(hl)		; $6079
	cp $12			; $607a
	jp z,_blueStalfos_afterImage_resetPositionVars		; $607c

	cp $14			; $607f
	call nc,objectSetVisible82		; $6081

	; Calculate Y-diff, update var30 (last frame's Y-position)
	ld l,Enemy.yh		; $6084
	ld e,Enemy.var30		; $6086
	ld a,(de)		; $6088
	ld b,a			; $6089
	ld a,(hl)		; $608a
	sub b			; $608b
	add $08			; $608c
	and $0f			; $608e
	swap a			; $6090
	ld c,a			; $6092
	ldi a,(hl)		; $6093
	ld (de),a		; $6094

	; Calculate X-diff, update var31 (last frame's Y-position)
	inc l			; $6095
	inc e			; $6096
	ld a,(de)		; $6097
	ld b,a			; $6098
	ld a,(hl)		; $6099
	sub b			; $609a
	add $08			; $609b
	and $0f			; $609d
	or c			; $609f
	ld c,a			; $60a0
	ld a,(hl)		; $60a1
	ld (de),a		; $60a2

	; Write position difference to offset buffer
	ld e,Enemy.var32		; $60a3
	ld a,(de)		; $60a5
	add Enemy.var33			; $60a6
	ld e,a			; $60a8
	ld a,c			; $60a9
	ld (de),a		; $60aa

	; Increment index in offset buffer
	ld e,Enemy.var32		; $60ab
	ld a,(de)		; $60ad
	inc a			; $60ae
	and $07			; $60af
	ld (de),a		; $60b1

	; Don't draw if difference is 0
	add Enemy.var33			; $60b2
	ld e,a			; $60b4
	ld a,(de)		; $60b5
	cp $88			; $60b6
	ld b,a			; $60b8
	jp z,objectSetInvisible		; $60b9

	; Update position based on offset, draw afterimage
	ld h,d			; $60bc
	ld l,Enemy.yh		; $60bd
	and $f0			; $60bf
	swap a			; $60c1
	sub $08			; $60c3
	add (hl)		; $60c5
	ldi (hl),a		; $60c6
	inc l			; $60c7
	ld a,b			; $60c8
	and $0f			; $60c9
	sub $08			; $60cb
	add (hl)		; $60cd
	ld (hl),a		; $60ce

	jp _ecom_flickerVisibility		; $60cf

@state8:
	call _blueStalfos_initSubid2Or3		; $60d2
	call _blueStalfos_afterImage_resetPositionVars		; $60d5
	ld l,Enemy.collisionType		; $60d8
	res 7,(hl)		; $60da
	call objectSetVisible83		; $60dc
	jp objectSetInvisible		; $60df


;;
; Decides the next position for the blue stalfos. It will always choose a different
; quadrant of the screen from the one it's in already.
; @addr{60e2}
_blueStalfos_main_decideNextPosition:
	ld e,$03		; $60e2
	ld bc,$3030		; $60e4
	call _ecom_randomBitwiseAndBCE		; $60e7

	ld h,e			; $60ea
	ld l,$00		; $60eb
	ld e,Enemy.yh		; $60ed
	ld a,(de)		; $60ef
	cp (LARGE_ROOM_HEIGHT<<4)/2			; $60f0
	jr c,+			; $60f2
	ld l,$02		; $60f4
+
	ld e,Enemy.xh		; $60f6
	ld a,(de)		; $60f8
	cp (LARGE_ROOM_WIDTH<<4)/2			; $60f9
	jr c,+			; $60fb
	inc l			; $60fd
+
	ld a,l			; $60fe
	add a			; $60ff
	add a			; $6100
	add h			; $6101


;;
; @param	a	Position index to use
; @param	bc	Offset to be added to target position
; @addr{6102}
_blueStalfos_main_moveToQuadrant:
	ld hl,@quadrantList		; $6102
	rst_addAToHl			; $6105
	call @getLinkQuadrant		; $6106
	cp (hl)			; $6109
	jr z,@moveToLinksPosition	; $610a

	ld a,(hl)		; $610c
	ld hl,@targetPositions		; $610d
	rst_addAToHl			; $6110
	ld e,Enemy.var30		; $6111
	ldi a,(hl)		; $6113
	add b			; $6114
	ld (de),a		; $6115
	inc e			; $6116
	ld a,(hl)		; $6117
	add c			; $6118
	ld (de),a		; $6119
	ret			; $611a

@moveToLinksPosition:
	ld e,Enemy.var30		; $611b
	ldh a,(<hEnemyTargetY)	; $611d
	sub $14			; $611f
	ld (de),a		; $6121
	inc e			; $6122
	ldh a,(<hEnemyTargetX)	; $6123
	ld (de),a		; $6125
	ret			; $6126

;;
; @param[out]	a	The quadrant of the screen Link is in.
;			(0/2/4/6 for up/left, up/right, down/left, down/right)
; @addr{6127}
@getLinkQuadrant:
	ld e,$00		; $6127
	ldh a,(<hEnemyTargetY)	; $6129
	cp (LARGE_ROOM_HEIGHT<<4)/2			; $612b
	jr c,+			; $612d
	ld e,$02		; $612f
+
	ldh a,(<hEnemyTargetX)	; $6131
	cp (LARGE_ROOM_WIDTH<<4)/2			; $6133
	jr c,+			; $6135
	inc e			; $6137
+
	ld a,e			; $6138
	add a			; $6139
	ret			; $613a

@quadrantList:
	.db $02 $04 $06 $04 ; Currently in TL quadrant
	.db $00 $06 $04 $06 ; Currently in TR quadrant
	.db $00 $02 $06 $02 ; Currently in BL quadrant
	.db $00 $02 $04 $00 ; Currently in BR quadrant

@targetPositions:
	.dw $3828
	.dw $8828
	.dw $3868
	.dw $8868


;;
; @addr{6153}
_blueStalfos_main_accelerate:
	ld e,Enemy.counter1		; $6153
	ld a,(de)		; $6155
	or a			; $6156
	ret z			; $6157

	dec a			; $6158
	ld (de),a		; $6159

	and $03			; $615a
	ret nz			; $615c

	ld e,Enemy.speed		; $615d
	ld a,(de)		; $615f
	add SPEED_20			; $6160
	ld (de),a		; $6162
	ret			; $6163


;;
; @addr{6164}
_blueStalfos_afterImage_resetPositionVars:
	; [this.position] = [parent.position]
	; (Also copy position to var30/var31)
	ld l,Enemy.yh		; $6164
	ld e,l			; $6166
	ldi a,(hl)		; $6167
	ld (de),a		; $6168
	ld e,Enemy.var30		; $6169

	ld (de),a		; $616b
	inc l			; $616c
	ld e,l			; $616d
	ld a,(hl)		; $616e
	ld (de),a		; $616f
	ld e,Enemy.var31		; $6170
	ld (de),a		; $6172

	ld h,d			; $6173
	ld l,Enemy.var32		; $6174
	xor a			; $6176
	ldi (hl),a		; $6177

	; Initialize "position offset" buffer
	ld a,$88		; $6178
	ldi (hl),a		; $617a
	ldi (hl),a		; $617b
	ldi (hl),a		; $617c
	ldi (hl),a		; $617d
	ldi (hl),a		; $617e
	ldi (hl),a		; $617f
	ldi (hl),a		; $6180
	ld (hl),a		; $6181
	ret			; $6182

;;
; @addr{6183}
_blueStalfos_createPuff:
	ldbc INTERACID_PUFF,$02		; $6183
	call objectCreateInteraction		; $6186
	ret nz			; $6189

	ld a,h			; $618a
	ld h,d			; $618b
	ld l,Enemy.relatedObj2+1		; $618c
	ldd (hl),a		; $618e
	ld (hl),Interaction.start		; $618f
	ret			; $6191


; ==============================================================================
; ENEMYID_PUMPKIN_HEAD
;
; Variables (body, subid 1):
;   relatedObj1: Reference to ghost
;   relatedObj2: Reference to head
;   var30: Stomp counter (stops stomping when it reaches 0)
;
; Variables (ghost, subid 2):
;   relatedObj1: Reference to body
;   var33/var34: Head's position (where ghost is moving toward)
;
; Variables (head, subid 3):
;   relatedObj1: Reference to body
;   var31: Link's direction last frame
;   var32: Head's orientation when it was picked up
; ==============================================================================
enemyCode78:
	jr z,@normalStatus	; $6192
	sub ENEMYSTATUS_NO_HEALTH			; $6194
	ret c			; $6196
	jr z,@dead	; $6197
	jr @normalStatus		; $6199

@dead:
	call _pumpkinHead_noHealth		; $619b
	ret z			; $619e

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $619f
	jr c,@commonState	; $61a2
	dec b			; $61a4
	ld a,b			; $61a5
	rst_jumpTable			; $61a6
	.dw _pumpkinHead_body
	.dw _pumpkinHead_ghost
	.dw _pumpkinHead_head

@commonState:
	rst_jumpTable			; $61ad
	.dw _pumpkinHead_state_uninitialized
	.dw _pumpkinHead_state_spawner
	.dw _pumpkinHead_state_grabbed
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub


_pumpkinHead_state_uninitialized:
	ld a,b			; $61be
	or a			; $61bf
	jp nz,_ecom_setSpeedAndState8		; $61c0

	; Subid 0 (spawner)
	inc a			; $61c3
	ld (de),a ; [state] = 1
	ld a,ENEMYID_PUMPKIN_HEAD		; $61c5
	ld b,$00		; $61c7
	jp _enemyBoss_initializeRoom		; $61c9


_pumpkinHead_state_spawner:
	; Wait for doors to close
	ld a,($cc93)		; $61cc
	or a			; $61cf
	ret nz			; $61d0

	ld b,$03		; $61d1
	call checkBEnemySlotsAvailable		; $61d3
	ret nz			; $61d6

	; Spawn body
	ld b,ENEMYID_PUMPKIN_HEAD		; $61d7
	call _ecom_spawnUncountedEnemyWithSubid01		; $61d9
	call objectCopyPosition		; $61dc
	ld c,h			; $61df

	; Spawn ghost
	call _ecom_spawnUncountedEnemyWithSubid01		; $61e0
	call @commonInit		; $61e3

	ld l,Enemy.enabled		; $61e6
	ld e,l			; $61e8
	ld a,(de)		; $61e9
	ld (hl),a		; $61ea

	; [body.relatedObj1] = ghost
	ld a,h			; $61eb
	ld h,c			; $61ec
	ld l,Enemy.relatedObj1+1		; $61ed
	ldd (hl),a		; $61ef
	ld (hl),Enemy.start		; $61f0

	; Spawn head
	call _ecom_spawnUncountedEnemyWithSubid01		; $61f2
	inc (hl)		; $61f5
	call @commonInit		; $61f6

	; [body.relatedObj2] = head
	ld a,h			; $61f9
	ld h,c			; $61fa
	ld l,Enemy.relatedObj2+1		; $61fb
	ldd (hl),a		; $61fd
	ld (hl),Enemy.start		; $61fe

	; Delete spawner
	jp enemyDelete		; $6200

@commonInit:
	inc (hl) ; [subid]++

	; [relatedObj1] = body
	ld l,Enemy.relatedObj1		; $6204
	ld (hl),Enemy.start		; $6206
	inc l			; $6208
	ld (hl),c		; $6209

	jp objectCopyPosition		; $620a


_pumpkinHead_state_grabbed:
	inc e			; $620d
	ld a,(de)		; $620e
	rst_jumpTable			; $620f
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d			; $6218
	ld l,e			; $6219
	inc (hl) ; [state2]

	xor a			; $621b
	ld (wLinkGrabState2),a		; $621c

	ld l,Enemy.var31		; $621f
	ld a,(w1Link.direction)		; $6221
	ld (hl),a		; $6224

	ld l,Enemy.direction		; $6225
	ld e,Enemy.var32		; $6227
	ld a,(hl)		; $6229
	ld (de),a		; $622a

	; [ghost.state] = $13
	ld a,Object.relatedObj1+1		; $622b
	call objectGetRelatedObject1Var		; $622d
	ld h,(hl)		; $6230
	ld l,Enemy.state		; $6231
	ld a,(hl)		; $6233
	ld (hl),$13		; $6234

	cp $13			; $6236
	jr nc,++		; $6238
	ld l,Enemy.zh		; $623a
	ld (hl),$f8		; $623c
	ld l,Enemy.invincibilityCounter		; $623e
	ld (hl),$f4		; $6240
++
	jp objectSetVisiblec1		; $6242

@beingHeld:
	; Update animation based on Link's facing direction
	ld a,(w1Link.direction)		; $6245
	ld h,d			; $6248
	ld l,Enemy.var31		; $6249
	cp (hl)			; $624b
	ret z			; $624c

	ld (hl),a		; $624d

	ld l,Enemy.var32		; $624e
	add (hl)		; $6250
	and $03			; $6251
	add a			; $6253
	ld l,Enemy.direction		; $6254
	ld (hl),a		; $6256
	jp enemySetAnimation		; $6257

@released:
	ret			; $625a

@atRest:
	; [ghost.state] = $15
	ld a,Object.relatedObj1+1		; $625b
	call objectGetRelatedObject1Var		; $625d
	ld h,(hl)		; $6260
	ld l,Enemy.state		; $6261
	ld (hl),$15		; $6263

	; [head.state] = $16
	ld h,d			; $6265
	ld (hl),$16		; $6266

	jp objectSetVisiblec2		; $6268


_pumpkinHead_state_stub:
	ret			; $626b


_pumpkinHead_body:
	ld a,(de)		; $626c
	sub $08			; $626d
	rst_jumpTable			; $626f
	.dw _pumpkinHead_body_state08
	.dw _pumpkinHead_body_state09
	.dw _pumpkinHead_body_state0a
	.dw _pumpkinHead_body_state0b
	.dw _pumpkinHead_body_state0c
	.dw _pumpkinHead_body_state0d
	.dw _pumpkinHead_body_state0e
	.dw _pumpkinHead_body_state0f
	.dw _pumpkinHead_body_state10
	.dw _pumpkinHead_body_state11
	.dw _pumpkinHead_body_state12
	.dw _pumpkinHead_body_state13


; Initialization
_pumpkinHead_body_state08:
	ld bc,$0106		; $6288
	call _enemyBoss_spawnShadow		; $628b
	ret nz			; $628e

	ld h,d			; $628f
	ld l,e			; $6290
	inc (hl) ; [state]

	ld l,Enemy.oamFlags		; $6292
	ld a,$01		; $6294
	ldd (hl),a		; $6296
	ld (hl),a		; $6297

	call objectSetVisible83		; $6298

	ld c,$08		; $629b
	call _ecom_setZAboveScreen		; $629d

	ld a,$0d		; $62a0
	jp enemySetAnimation		; $62a2


; Falling from ceiling
_pumpkinHead_body_state09:
	ld c,$10		; $62a5
	call objectUpdateSpeedZ_paramC		; $62a7
	ret nz			; $62aa

	ld l,Enemy.state		; $62ab
	inc (hl)		; $62ad

	ld l,Enemy.counter1		; $62ae
	ld (hl),30		; $62b0

	ld l,Enemy.angle		; $62b2
	ld (hl),ANGLE_DOWN		; $62b4

	ld a,30		; $62b6

_pumpkinHead_body_shakeScreen:
	call setScreenShakeCounter		; $62b8
	ld a,SND_DOORCLOSE		; $62bb
	jp playSound		; $62bd


; Waiting for head to catch up with body
_pumpkinHead_body_state0a:
	ld a,Object.zh		; $62c0
	call objectGetRelatedObject2Var		; $62c2
	ld a,(hl)		; $62c5
	cp $f0			; $62c6
	ret c			; $62c8

	call _ecom_decCounter1		; $62c9
	ret nz			; $62cc

	call _pumpkinHead_body_chooseRandomStompTimerAndCount		; $62cd
	jr _pumpkinHead_body_beginMoving		; $62d0


; Walking around
_pumpkinHead_body_state0b:
	call pumpkinHead_body_countdownUntilStomp		; $62d2
	ret z			; $62d5

	call _ecom_decCounter1		; $62d6
	jr z,_pumpkinHead_body_chooseNextAction	; $62d9

	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $62db
	jr z,_pumpkinHead_body_chooseNextAction	; $62de

	jp enemyAnimate		; $62e0


_pumpkinHead_body_chooseNextAction:
	call objectGetAngleTowardEnemyTarget		; $62e3
	add $04			; $62e6
	and $18			; $62e8
	ld b,a			; $62ea

	ld e,Enemy.angle		; $62eb
	ld a,(de)		; $62ed
	cp b			; $62ee
	jr nz,_pumpkinHead_body_beginMoving	; $62ef

	; Currently facing toward Link. 1 in 4 chance of head firing projectiles.
	call getRandomNumber_noPreserveVars		; $62f1
	cp $40			; $62f4
	jr c,_pumpkinHead_body_beginMoving	; $62f6

	; Head will fire projectiles.
	call _ecom_incState		; $62f8
	ld l,Enemy.counter1		; $62fb
	ld (hl),$38		; $62fd

	; [head.state] = $0b
	ld a,Object.state		; $62ff
	call objectGetRelatedObject2Var		; $6301
	inc (hl)		; $6304

	jr _pumpkinHead_body_updateAnimationFromAngle		; $6305


; Head is firing projectiles; waiting for it to finish.
_pumpkinHead_body_state0c:
	call _ecom_decCounter1		; $6307
	ret nz			; $630a

_pumpkinHead_body_beginMoving:
	ld h,d			; $630b
	ld l,Enemy.state		; $630c
	ld (hl),$0b		; $630e

	ld l,Enemy.speed		; $6310
	ld (hl),SPEED_80		; $6312

	; Random duration of time to walk
	call getRandomNumber_noPreserveVars		; $6314
	and $0f			; $6317
	ld hl,_pumpkinHead_body_walkDurations		; $6319
	rst_addAToHl			; $631c
	ld e,Enemy.counter1		; $631d
	ld a,(hl)		; $631f
	ld (de),a		; $6320

	call _ecom_setRandomCardinalAngle		; $6321

_pumpkinHead_body_updateAnimationFromAngle:
	ld e,Enemy.angle		; $6324
	ld a,(de)		; $6326
	swap a			; $6327
	rlca			; $6329
	ld b,a			; $632a

	ld hl,_pumpkinHead_body_collisionRadiusXVals		; $632b
	rst_addAToHl			; $632e
	ld e,Enemy.collisionRadiusX		; $632f
	ld a,(hl)		; $6331
	ld (de),a		; $6332

	ld a,b			; $6333
	add $0b			; $6334
	jp enemySetAnimation		; $6336


_pumpkinHead_body_walkDurations:
	.db 30, 30, 60, 60, 60, 60,  60,  90
	.db 90, 90, 90, 90, 90, 120, 120, 120

_pumpkinHead_body_collisionRadiusXVals:
	.db $0c $08 $0c $08


; Preparing to stomp
_pumpkinHead_body_state0d:
	call _ecom_decCounter1		; $634d
	jr z,_pumpkinHead_body_beginStomp	; $6350

	ld a,(hl)		; $6352
	rrca			; $6353
	ret nc			; $6354
	call _ecom_updateCardinalAngleTowardTarget		; $6355
	jr _pumpkinHead_body_updateAnimationFromAngle		; $6358

_pumpkinHead_body_beginStomp:
	ld l,Enemy.state		; $635a
	ld (hl),$0e		; $635c

	ld l,Enemy.speedZ		; $635e
	ld a,<(-$3a0)		; $6360
	ldi (hl),a		; $6362
	ld (hl),>(-$3a0)		; $6363

	ld l,Enemy.speed		; $6365
	ld (hl),SPEED_100		; $6367

	; [ghost.state] = $0c
	ld a,Object.state		; $6369
	call objectGetRelatedObject1Var		; $636b
	ld (hl),$0c		; $636e

	; [head.state] = $0e
	ld a,Object.state		; $6370
	call objectGetRelatedObject2Var		; $6372
	ld (hl),$0e		; $6375

	; Update angle based on direction toward Link
	call _ecom_updateAngleTowardTarget		; $6377
	add $04			; $637a
	and $18			; $637c
	swap a			; $637e
	rlca			; $6380
	ld b,a			; $6381
	ld hl,_pumpkinHead_body_collisionRadiusXVals		; $6382
	rst_addAToHl			; $6385
	ld e,Enemy.collisionRadiusX		; $6386
	ld a,(hl)		; $6388
	ld (de),a		; $6389

	ld a,b			; $638a
	add $0b			; $638b
	call enemySetAnimation		; $638d
	jp objectSetVisible81		; $6390


; In midair during stomp
_pumpkinHead_body_state0e:
	ld c,$30		; $6393
	call objectUpdateSpeedZ_paramC		; $6395
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $6398

	; Hit ground

	ld l,Enemy.state		; $639b
	inc (hl)		; $639d

	ld e,Enemy.var30		; $639e
	ld a,(de)		; $63a0
	dec a			; $63a1
	ld a,15		; $63a2
	jr nz,+			; $63a4
	ld a,30		; $63a6
+
	ld l,Enemy.counter1		; $63a8
	ld (hl),a		; $63aa

	ld a,20		; $63ab
	call _pumpkinHead_body_shakeScreen		; $63ad
	jp objectSetVisible83		; $63b0


; Landed after a stomp
_pumpkinHead_body_state0f:
	call _ecom_decCounter1		; $63b3
	ret nz			; $63b6

	ld l,Enemy.var30		; $63b7
	dec (hl)		; $63b9
	jr nz,_pumpkinHead_body_beginStomp	; $63ba
	jp _pumpkinHead_body_beginMoving		; $63bc


; Body has been destroyed
_pumpkinHead_body_state10:
	ret			; $63bf


; Head has moved up, body will now regenerate
_pumpkinHead_body_state11:
	ld h,d			; $63c0
	ld l,e			; $63c1
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $63c3
	ld (hl),$08		; $63c5
	ld l,Enemy.angle		; $63c7
	ld (hl),$10		; $63c9
	jp objectCreatePuff		; $63cb


; Delay before making body visible
_pumpkinHead_body_state12:
	call _ecom_decCounter1		; $63ce
	ret nz			; $63d1

	ld (hl),30 ; [counter1]
	ld l,e			; $63d4
	inc (hl) ; [state]

	call objectSetVisible83		; $63d6

	ld a,$0d		; $63d9
	jp enemySetAnimation		; $63db


; Body has regenerated, waiting a moment before resuming
_pumpkinHead_body_state13:
	call _ecom_decCounter1		; $63de
	ret nz			; $63e1

	ld l,Enemy.collisionType		; $63e2
	set 7,(hl)		; $63e4

	call _pumpkinHead_body_chooseRandomStompTimerAndCount		; $63e6
	jp _pumpkinHead_body_beginMoving		; $63e9


_pumpkinHead_ghost:
	ld a,(de)		; $63ec
	sub $08			; $63ed
	rst_jumpTable			; $63ef
	.dw _pumpkinHead_ghost_state08
	.dw _pumpkinHead_ghost_state09
	.dw _pumpkinHead_ghost_state0a
	.dw _pumpkinHead_ghost_state0b
	.dw _pumpkinHead_ghost_state0c
	.dw _pumpkinHead_ghost_state0d
	.dw _pumpkinHead_ghost_state0e
	.dw _pumpkinHead_ghost_state0f
	.dw _pumpkinHead_ghost_state10
	.dw _pumpkinHead_ghost_state11
	.dw _pumpkinHead_ghost_state12
	.dw _pumpkinHead_ghost_state13
	.dw _pumpkinHead_ghost_state14
	.dw _pumpkinHead_ghost_state15
	.dw _pumpkinHead_ghost_state16
	.dw _pumpkinHead_ghost_state17


; Initialization
_pumpkinHead_ghost_state08:
	ld h,d			; $6410
	ld l,e			; $6411
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $6413
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_GHOST		; $6415

	ld l,Enemy.oamFlags		; $6417
	ld a,$05		; $6419
	ldd (hl),a		; $641b
	ld (hl),a		; $641c

	ld l,Enemy.collisionType		; $641d
	res 7,(hl)		; $641f

	ld l,Enemy.collisionRadiusY		; $6421
	ld a,$06		; $6423
	ldi (hl),a		; $6425
	ld (hl),a		; $6426

	call objectSetVisible83		; $6427
	ld c,$20		; $642a
	call _ecom_setZAboveScreen		; $642c

	ld a,$0a		; $642f
	jp enemySetAnimation		; $6431


; Falling from ceiling. (Also called by "head" state 9.)
_pumpkinHead_ghost_state09:
	ld c,$10		; $6434
	call objectUpdateSpeedZ_paramC		; $6436
	ld l,Enemy.zh		; $6439
	ld a,(hl)		; $643b
	cp $f0			; $643c
	ret c			; $643e

	ld (hl),$f0		; $643f
	ld l,Enemy.state		; $6441
	inc (hl)		; $6443
	ret			; $6444


; Waiting for head to fall into place
_pumpkinHead_ghost_state0a:
	; Check [head.zh]
	ld a,Object.relatedObj2+1		; $6445
	call objectGetRelatedObject1Var		; $6447
	ld h,(hl)		; $644a
	ld l,Enemy.zh		; $644b
	ld a,(hl)		; $644d
	cp $f0			; $644e
	ret nz			; $6450

	ld e,Enemy.state		; $6451
	ld a,$0b		; $6453
	ld (de),a		; $6455
	call objectSetInvisible		; $6456


; Copy body's position
_pumpkinHead_ghost_state0b:
	ld a,Object.enabled		; $6459
	call objectGetRelatedObject1Var		; $645b
	jp objectTakePosition		; $645e


; Body just began stomping; is moving upward
_pumpkinHead_ghost_state0c:
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingUp		; $6461
	ret nz			; $6464

	call _ecom_incState		; $6465
	ld l,Enemy.speedZ		; $6468
	xor a			; $646a
	ldi (hl),a		; $646b
	ld (hl),a		; $646c
	call objectSetVisible81		; $646d


; Body is stomping; moving downward
_pumpkinHead_ghost_state0d:
	ld c,$28		; $6470
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingDown		; $6472
	ret c			; $6475

	ld (hl),$f0 ; [zh]
	ld l,Enemy.state		; $6478
	inc (hl)		; $647a
	jp objectSetVisible83		; $647b


; Reached target z-position after stomping; waiting for head to catch up
_pumpkinHead_ghost_state0e:
	ld a,Object.relatedObj2+1		; $647e
	call objectGetRelatedObject1Var		; $6480
	ld h,(hl)		; $6483
	ld l,Enemy.zh		; $6484
	ld a,(hl)		; $6486
	cp $ee			; $6487
	ret c			; $6489

	ld e,Enemy.state		; $648a
	ld a,$0b		; $648c
	ld (de),a		; $648e
	jp objectSetInvisible		; $648f


; Body just destroyed
_pumpkinHead_ghost_state0f:
	ld h,d			; $6492
	ld l,e			; $6493
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $6495
	ld a,<(-$120)		; $6497
	ldi (hl),a		; $6499
	ld (hl),>(-$120)		; $649a

	jp objectSetInvisible		; $649c


; Falling to ground after body disappeared
_pumpkinHead_ghost_state10:
	ld c,$28		; $649f
	call objectUpdateSpeedZ_paramC		; $64a1
	ret nz			; $64a4

	ld l,Enemy.state		; $64a5
	inc (hl)		; $64a7
	ld l,Enemy.counter1		; $64a8
	ld (hl),$08		; $64aa
	ret			; $64ac


; Delay before going to next state?
_pumpkinHead_ghost_state11:
	call _ecom_decCounter1		; $64ad
	ret nz			; $64b0
	ld l,e			; $64b1
	inc (hl) ; [state]
	ret			; $64b3


; Waiting for head to be picked up
_pumpkinHead_ghost_state12:
	ret			; $64b4


; Link just grabbed the head; ghost runs away
_pumpkinHead_ghost_state13:
	ld h,d			; $64b5
	ld l,e			; $64b6
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $64b8
	ld (hl),60		; $64ba

	ld l,Enemy.speed		; $64bc
	ld (hl),SPEED_140		; $64be
	ld l,Enemy.speedZ		; $64c0
	xor a			; $64c2
	ldi (hl),a		; $64c3
	ld (hl),a		; $64c4

	ld l,Enemy.collisionType		; $64c5
	set 7,(hl)		; $64c7
	call objectSetVisiblec2		; $64c9

	call _ecom_updateCardinalAngleAwayFromTarget		; $64cc

	ld a,$0a		; $64cf
	jp enemySetAnimation		; $64d1


; Falling to ground, then running away with angle computed earlier
_pumpkinHead_ghost_state14:
	ld c,$20		; $64d4
	call objectUpdateSpeedZ_paramC		; $64d6
	ret nz			; $64d9

	call _ecom_decCounter1		; $64da
	jr nz,++		; $64dd

	ld l,Enemy.state		; $64df
	inc (hl)		; $64e1
	call objectSetVisible82		; $64e2
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $64e5
	jp enemyAnimate		; $64e8


; Stopped running away, or head just landed on ground
_pumpkinHead_ghost_state15:
	ld h,d			; $64eb
	ld l,e			; $64ec
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $64ee
	ld (hl),120		; $64f0
	ld a,$09		; $64f2
	jp enemySetAnimation		; $64f4


; After [counter1] frames, will choose which direction to move in next
_pumpkinHead_ghost_state16:
	call _ecom_decCounter1		; $64f7
	jr nz,@checkHeadOnGround	; $64fa

	ld (hl),60 ; [counter1]
	ld l,e			; $64fe
	dec (hl)		; $64ff
	dec (hl) ; [state] = $14

	call getRandomNumber_noPreserveVars		; $6501
	and $1c			; $6504
	ld e,Enemy.angle		; $6506
	ld (de),a		; $6508
	jr @setAnim		; $6509

@checkHeadOnGround:
	; Check [head.state] to see if head is at rest on the ground
	ld a,Object.relatedObj2+1		; $650b
	call objectGetRelatedObject1Var		; $650d
	ld h,(hl)		; $6510
	ld l,Enemy.state		; $6511
	ld a,(hl)		; $6513
	cp $02			; $6514
	jp z,enemyAnimate		; $6516

	ld h,d			; $6519
	inc (hl) ; [this.state]

	; Copy head's position, use that as target position to move toward.
	; [this.var33] = [head.yh]
	ld a,Object.relatedObj2+1		; $651b
	call objectGetRelatedObject1Var		; $651d
	ld h,(hl)		; $6520
	ld l,Enemy.yh		; $6521
	ld e,Enemy.var33		; $6523
	ldi a,(hl)		; $6525
	ld (de),a		; $6526

	; [this.var34] = [head.xh]
	inc l			; $6527
	inc e			; $6528
	ld a,(hl)		; $6529
	ld (de),a		; $652a

@setAnim:
	ld a,$0a		; $652b
	jp enemySetAnimation		; $652d


; Moving toward head (or where head used to be)
_pumpkinHead_ghost_state17:
	ld h,d			; $6530
	ld l,Enemy.var33		; $6531
	call _ecom_readPositionVars		; $6533
	sub c			; $6536
	add $08			; $6537
	cp $11			; $6539
	jr nc,@moveTowardHead	; $653b
	ldh a,(<hFF8F)	; $653d
	sub b			; $653f
	add $08			; $6540
	cp $11			; $6542
	jr nc,@moveTowardHead	; $6544

	; Reached head.

	; Check [head.state] to see if it's being held
	ld a,Object.relatedObj2+1		; $6546
	call objectGetRelatedObject1Var		; $6548
	ld h,(hl)		; $654b
	ld l,Enemy.state		; $654c
	ld a,(hl)		; $654e
	cp $02			; $654f
	ret z			; $6551

	ld (hl),$13 ; [head.state] = $13

	ld h,d			; $6554
	ld (hl),$0b ; [this.state] = $0b

	ld l,Enemy.collisionType		; $6557
	res 7,(hl)		; $6559
	jp objectSetInvisible		; $655b

@moveTowardHead:
	call _ecom_moveTowardPosition		; $655e
	jp enemyAnimate		; $6561


_pumpkinHead_head:
	ld a,(de)		; $6564
	sub $08			; $6565
	rst_jumpTable			; $6567
	.dw _pumpkinHead_head_state08
	.dw _pumpkinHead_head_state09
	.dw _pumpkinHead_head_state0a
	.dw _pumpkinHead_head_state0b
	.dw _pumpkinHead_head_state0c
	.dw _pumpkinHead_head_state0d
	.dw _pumpkinHead_head_state0e
	.dw _pumpkinHead_head_state0f
	.dw _pumpkinHead_head_state10
	.dw _pumpkinHead_head_state11
	.dw _pumpkinHead_head_state12
	.dw _pumpkinHead_head_state13
	.dw _pumpkinHead_head_state14
	.dw _pumpkinHead_head_state15
	.dw _pumpkinHead_head_state16


; Initialization
_pumpkinHead_head_state08:
	ld h,d			; $6586
	ld l,e			; $6587
	inc (hl) ; [state]

	ld l,Enemy.angle		; $6589
	ld (hl),$ff		; $658b

	ld l,Enemy.enemyCollisionMode		; $658d
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_HEAD		; $658f

	ld l,Enemy.collisionRadiusY		; $6591
	ld (hl),$06		; $6593

	call objectSetVisible82		; $6595
	ld c,$30		; $6598
	call _ecom_setZAboveScreen		; $659a

	ld a,$04		; $659d
	ld b,$00		; $659f

;;
; @addr{65a1}
_pumpkinHead_head_setAnimation:
	ld e,Enemy.direction		; $65a1
	ld (de),a		; $65a3
	add b			; $65a4
	ld b,a			; $65a5
	srl a			; $65a6
	ld hl,@collisionRadiusXVals		; $65a8
	rst_addAToHl			; $65ab
	ld e,Enemy.collisionRadiusX		; $65ac
	ld a,(hl)		; $65ae
	ld (de),a		; $65af
	ld a,b			; $65b0
	jp enemySetAnimation		; $65b1

@collisionRadiusXVals:
	.db $08 $06 $08 $06


_pumpkinHead_head_state09:
	call _pumpkinHead_ghost_state09		; $65b8
	ret c			; $65bb

	ld a,MUS_BOSS		; $65bc
	ld (wActiveMusic),a		; $65be
	jp playSound		; $65c1


; Head follows body. Called by other states.
_pumpkinHead_head_state0a:
	call objectSetPriorityRelativeToLink		; $65c4

	ld a,Object.animParameter		; $65c7
	call objectGetRelatedObject1Var		; $65c9
	ld a,(hl)		; $65cc
	push hl			; $65cd
	ld hl,@headZOffsets		; $65ce
	rst_addAToHl			; $65d1
	ldi a,(hl)		; $65d2
	ld c,a			; $65d3
	ld b,$00		; $65d4
	ld a,(hl)		; $65d6
	pop hl			; $65d7
	push af			; $65d8
	call objectTakePositionWithOffset		; $65d9

	pop af			; $65dc
	ld e,Enemy.zh		; $65dd
	ld (de),a		; $65df

	; Check whether body's angle is different from head's angle
	ld l,Enemy.angle		; $65e0
	ld e,l			; $65e2
	ld a,(de)		; $65e3
	cp (hl)			; $65e4
	jp z,enemyAnimate		; $65e5

	ld a,(hl)		; $65e8
	ld (de),a		; $65e9
	rrca			; $65ea
	rrca			; $65eb
	ld b,$00		; $65ec
	jr _pumpkinHead_head_setAnimation		; $65ee

; Offsets for head relative to body. Indexed by body's animParameter.
;   b0: Y offset
;   b1: Z position
@headZOffsets:
	.db $00 $f0
	.db $01 $f0
	.db $00 $ef


; Preparing to fire projectiles
_pumpkinHead_head_state0b:
	ld h,d			; $65f6
	ld l,e			; $65f7
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $65f9
	ld (hl),20		; $65fb

	call _pumpkinHead_head_state0a		; $65fd

	ld e,Enemy.angle		; $6600
	ld a,(de)		; $6602
	rrca			; $6603
	rrca			; $6604
	ld b,$01		; $6605
	jp _pumpkinHead_head_setAnimation		; $6607


; Delay before firing projectile
_pumpkinHead_head_state0c:
	call _ecom_decCounter1		; $660a
	jp nz,objectSetPriorityRelativeToLink		; $660d

	; Fire projectile
	ld (hl),36 ; [counter1]
	ld l,e			; $6612
	inc (hl) ; [state]

	ld l,Enemy.angle		; $6614
	ld a,(hl)		; $6616
	rrca			; $6617
	rrca			; $6618
	ld b,$00		; $6619
	call _pumpkinHead_head_setAnimation		; $661b
	call getFreePartSlot		; $661e
	ret nz			; $6621

	ld (hl),PARTID_PUMPKIN_HEAD_PROJECTILE		; $6622
	ld l,Part.angle		; $6624
	ld e,Enemy.angle		; $6626
	ld a,(de)		; $6628
	ld (hl),a		; $6629
	call objectCopyPosition		; $662a

	ld a,SND_VERAN_FAIRY_ATTACK		; $662d
	jp playSound		; $662f


; Delay after firing projectile
_pumpkinHead_head_state0d:
	call _ecom_decCounter1		; $6632
	jp nz,objectSetPriorityRelativeToLink		; $6635

	ld l,e			; $6638
	ld (hl),$0a ; [state]
	jr _pumpkinHead_head_state0a		; $663b


; Began a stomp; moving up
_pumpkinHead_head_state0e:
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingUp		; $663d
	jr z,@movingDown	; $6640

	; Update angle
	ld l,Enemy.angle		; $6642
	ld e,l			; $6644
	ld a,(de)		; $6645
	cp (hl)			; $6646
	ret z			; $6647
	ld a,(hl)		; $6648
	ld (de),a		; $6649
	add $04			; $664a
	and $18			; $664c
	rrca			; $664e
	rrca			; $664f
	ld b,$00		; $6650
	jp _pumpkinHead_head_setAnimation		; $6652

@movingDown:
	call _ecom_incState		; $6655
	ld l,Enemy.speedZ		; $6658
	xor a			; $665a
	ldi (hl),a		; $665b
	ld (hl),a		; $665c
	call objectSetVisible80		; $665d


; Body is stomping; moving down
_pumpkinHead_head_state0f:
	ld c,$20		; $6660
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingDown		; $6662
	ret c			; $6665

	; Reached target position
	ld (hl),$f0 ; [zh]
	ld l,Enemy.state		; $6668
	ld (hl),$0a		; $666a
	jp objectSetVisible82		; $666c


; Body just destroyed
_pumpkinHead_head_state10:
	ld h,d			; $666f
	ld l,e			; $6670
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $6672
	ld a,<(-$120)		; $6674
	ldi (hl),a		; $6676
	ld (hl),>(-$120)		; $6677
	jp objectSetVisiblec2		; $6679


; Head falling down after body destroyed
_pumpkinHead_head_state11:
	ld c,$20		; $667c
	call objectUpdateSpeedZ_paramC		; $667e
	ret nz			; $6681

	ld l,Enemy.state		; $6682
	inc (hl)		; $6684
	ld l,Enemy.counter1		; $6685
	ld (hl),120		; $6687
	ret			; $6689


; Head is grabbable for 120 frames
_pumpkinHead_head_state12:
	call _ecom_decCounter1		; $668a
	jp nz,_pumpkinHead_head_state16		; $668d

	ld l,e			; $6690
	inc (hl) ; [state]

	; [ghost.state] = $0b
	ld a,Object.relatedObj1+1		; $6692
	call objectGetRelatedObject1Var		; $6694
	ld h,(hl)		; $6697
	ld l,Enemy.state		; $6698
	ld (hl),$0b		; $669a
	ret			; $669c


; Ghost just re-entered head, or head timed out before Link grabbed it
_pumpkinHead_head_state13:
	ld h,d			; $669d
	ld l,e			; $669e
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $66a0
	ld (hl),$10		; $66a2

	ld l,Enemy.collisionRadiusX		; $66a4
	ld (hl),$0a		; $66a6

	ld a,$08		; $66a8
	jp enemySetAnimation		; $66aa


; Delay before moving back up, respawning body
_pumpkinHead_head_state14:
	call _ecom_decCounter1		; $66ad
	ret nz			; $66b0

	ld l,e			; $66b1
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $66b3
	ld a,<(-$200)		; $66b5
	ldi (hl),a		; $66b7
	ld (hl),>(-$200)		; $66b8

	ld l,Enemy.collisionRadiusX		; $66ba
	ld (hl),$06		; $66bc
	ld a,$04		; $66be
	jp enemySetAnimation		; $66c0


; Head moving up
_pumpkinHead_head_state15:
	ld c,$20		; $66c3
	call objectUpdateSpeedZ_paramC		; $66c5

	ld l,Enemy.zh		; $66c8
	ld a,(hl)		; $66ca
	cp $f1			; $66cb
	ret nc			; $66cd

	; Head has gone up high enough; respawn body now.

	ld (hl),$f0 ; [zh]

	ld l,Enemy.state		; $66d0
	ld (hl),$0a		; $66d2

	ld l,Enemy.collisionRadiusX		; $66d4
	ld (hl),$0c		; $66d6

	call objectSetVisible82		; $66d8

	; [body.state] = $11
	ld a,Object.state		; $66db
	call objectGetRelatedObject1Var		; $66dd
	ld (hl),$11		; $66e0

	; Copy head's position to ghost
	call objectCopyPosition		; $66e2

	; [ghost.zh]
	ld l,Enemy.zh		; $66e5
	ld (hl),$00		; $66e7

	ld a,$04		; $66e9
	ld b,$00		; $66eb
	jp _pumpkinHead_head_setAnimation		; $66ed


; Head has just come to rest after being thrown.
; Called by other states (to make it grabbable).
_pumpkinHead_head_state16:
	ld a,Object.health		; $66f0
	call objectGetRelatedObject1Var		; $66f2
	ld a,(hl)		; $66f5
	or a			; $66f6
	ret z			; $66f7
	call objectAddToGrabbableObjectBuffer		; $66f8
	jp objectPushLinkAwayOnCollision		; $66fb


;;
; @param[out]	zflag	z if time to stomp
; @addr{66fe}
pumpkinHead_body_countdownUntilStomp:
	ld a,(wFrameCounter)		; $66fe
	rrca			; $6701
	ret c			; $6702
	call _ecom_decCounter2		; $6703
	ret nz			; $6706

	ld l,Enemy.state		; $6707
	ld (hl),$0d		; $6709
	ld l,Enemy.counter1		; $670b
	ld (hl),60		; $670d

;;
; Randomly sets the duration until a stomp occurs, and the number of stomps to perform.
; @addr{670f}
_pumpkinHead_body_chooseRandomStompTimerAndCount:
	ld bc,$0701		; $670f
	call _ecom_randomBitwiseAndBCE		; $6712
	ld a,b			; $6715
	ld hl,@counter2Vals		; $6716
	rst_addAToHl			; $6719

	ld e,Enemy.counter2		; $671a
	ld a,(hl)		; $671c
	ld (de),a		; $671d

	ld e,Enemy.var30		; $671e
	ld a,c			; $6720
	add $02			; $6721
	ld (de),a		; $6723
	xor a			; $6724
	ret			; $6725

@counter2Vals:
	.db 90, 120, 120, 120, 150, 150, 150, 180

;;
; @param[out]	zflag	z if body is moving down
; @addr{672e}
_pumpkinHead_ghostOrHead_updatePositionWhileStompingUp:
	ld a,Object.speedZ+1		; $672e
	call objectGetRelatedObject1Var		; $6730
	bit 7,(hl)		; $6733
	ret z			; $6735

	call objectTakePosition		; $6736
	ld e,Enemy.zh		; $6739
	ld a,(de)		; $673b
	sub $10			; $673c
	ld (de),a		; $673e
	ret			; $673f

;;
; @param	c	Gravity
; @param[out]	hl	Enemy.zh
; @param[out]	cflag	nc if reached target z-position
; @addr{6740}
_pumpkinHead_ghostOrHead_updatePositionWhileStompingDown:
	call objectUpdateSpeedZ_paramC		; $6740
	ld l,Enemy.zh		; $6743
	ld a,(hl)		; $6745
	cp $f0			; $6746
	ret nc			; $6748

	push af			; $6749
	ld a,Object.enabled		; $674a
	call objectGetRelatedObject1Var		; $674c
	call objectTakePosition		; $674f
	pop af			; $6752
	ld e,Enemy.zh		; $6753
	ld (de),a		; $6755
	ret			; $6756


;;
; @addr{6757}
_pumpkinHead_noHealth:
	ld e,Enemy.subid		; $6757
	ld a,(de)		; $6759
	dec a			; $675a
	jr z,@bodyHealthZero	; $675b
	dec a			; $675d
	jr z,@ghostHealthZero	; $675e

@headHealthZero:
	call objectCreatePuff		; $6760
	ld h,d			; $6763
	ld l,Enemy.state		; $6764
	ldi a,(hl)		; $6766
	cp $02			; $6767
	jr nz,@delete	; $6769

	ld a,(hl) ; [state2]
	cp $02			; $676c
	call c,dropLinkHeldItem		; $676e
@delete:
	jp enemyDelete		; $6771

@ghostHealthZero:
	ld e,Enemy.collisionType		; $6774
	ld a,(de)		; $6776
	or a			; $6777
	jr nz,++		; $6778
	call _ecom_killRelatedObj1		; $677a
	ld l,Enemy.relatedObj2+1		; $677d
	ld h,(hl)		; $677f
	call _ecom_killObjectH		; $6780
++
	call _enemyBoss_dead		; $6783
	xor a			; $6786
	ret			; $6787

@bodyHealthZero:
	; Delete self if ghost's health is 0
	ld a,Object.health		; $6788
	call objectGetRelatedObject1Var		; $678a
	ld a,(hl)		; $678d
	or a			; $678e
	jp z,enemyDelete		; $678f

	; Otherwise, the body just disappears temporarily
	ld h,d			; $6792
	ld l,Enemy.health		; $6793
	ld (hl),$08		; $6795

	ld l,Enemy.state		; $6797
	ld (hl),$10		; $6799

	ld l,Enemy.zh		; $679b
	ld (hl),$00		; $679d

	; [ghost.state] = $0f
	ld a,Object.state		; $679f
	call objectGetRelatedObject1Var		; $67a1
	ld (hl),$0f		; $67a4

	; [head.state] = $10
	ld a,Object.state		; $67a6
	call objectGetRelatedObject2Var		; $67a8
	ld (hl),$10		; $67ab

	call objectCreatePuff		; $67ad
	jp objectSetInvisible		; $67b0


; ==============================================================================
; ENEMYID_HEAD_THWOMP
;
; Variables:
;   direction: Current animation. Even numbers are face colors; odd numbers are
;              transitions.
;   var30: "Spin counter" used when bomb is thrown into head
;   var31: Which head the thwomp will settle on after throwing bomb in?
;   var32: Bit 0 triggers the effect of a bomb being thrown into head thwomp.
;   var33: Determines the initial angle of the circular projectiles' initial angle
;   var34: Counter which determines when head thwomp starts shooting fireballs / bombs
; ==============================================================================
enemyCode79:
	jr z,@normalStatus	; $67b3
	sub ENEMYSTATUS_NO_HEALTH			; $67b5
	ret c			; $67b7
	jp z,_enemyBoss_dead		; $67b8

@normalStatus:
	ld e,Enemy.state		; $67bb
	ld a,(de)		; $67bd
	rst_jumpTable			; $67be
	.dw _headThwomp_state_uninitialized
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state_stub
	.dw _headThwomp_state8
	.dw _headThwomp_state9
	.dw _headThwomp_stateA
	.dw _headThwomp_stateB
	.dw _headThwomp_stateC
	.dw _headThwomp_stateD
	.dw _headThwomp_stateE
	.dw _headThwomp_stateF
	.dw _headThwomp_state10
	.dw _headThwomp_state11


_headThwomp_state_uninitialized:
	ld a,ENEMYID_HEAD_THWOMP		; $67e3
	ld b,PALH_81		; $67e5
	call _enemyBoss_initializeRoom		; $67e7

	call _ecom_setSpeedAndState8		; $67ea
	ld l,Enemy.counter1		; $67ed
	ld (hl),18		; $67ef

	call _headThwomp_setSolidTilesAroundSelf		; $67f1
	jp objectSetVisible80		; $67f4


_headThwomp_state_stub:
	ret			; $67f7


; Waiting for Link to move up for fight to start
_headThwomp_state8:
	ld a,(w1Link.yh)		; $67f8
	cp $9c			; $67fb
	ret nc			; $67fd

	ld c,$a4		; $67fe
	ld a,$3d		; $6800
	call setTile		; $6802

	ld a,SND_DOORCLOSE		; $6805
	call playSound		; $6807

	ld a,$98		; $680a
	ld (wLinkLocalRespawnY),a		; $680c
	ld a,$48		; $680f
	ld (wLinkLocalRespawnX),a		; $6811

	call _ecom_incState		; $6814

	ld l,Enemy.var34		; $6817
	ld (hl),$f0		; $6819

	call _enemyBoss_beginBoss		; $681b


; Spinning normally
_headThwomp_state9:
	call _headThwomp_checkBombThrownIntoHead		; $681e
	ret nz			; $6821

	call _headThwomp_checkShootProjectile		; $6822

	; Update rotation
	call _ecom_decCounter1		; $6825
	ret nz			; $6828

	ld e,Enemy.health		; $6829
	ld a,(de)		; $682b
	dec a			; $682c
	ld bc,@rotationSpeeds		; $682d
	call addDoubleIndexToBc		; $6830

	ld e,Enemy.direction		; $6833
	ld a,(de)		; $6835
	inc a			; $6836
	and $07			; $6837
	ld (de),a		; $6839
	rrca			; $683a
	jr nc,+			; $683b
	inc bc			; $683d
+
	ld a,(bc)		; $683e
	ld (hl),a		; $683f
	ld a,SND_CLINK2		; $6840
	call c,playSound		; $6842
	ld a,(de)		; $6845
	jp enemySetAnimation		; $6846

@rotationSpeeds:
	.db $11 $07 ; $01 == [health]
	.db $14 $08 ; $02
	.db $17 $0a ; $03
	.db $1a $0b ; $04


; Bomb just thrown into head thwomp
_headThwomp_stateA:
	call _ecom_decCounter1		; $6851
	jp nz,enemyAnimate		; $6854

	ld l,e			; $6857
	inc (hl) ; [state]
	inc l			; $6859
	ld (hl),$00 ; [state2]
	ret			; $685c


; Spinning after bomb was thrown into head
_headThwomp_stateB:
	inc e			; $685d
	ld a,(de) ; [state2]
	rst_jumpTable			; $685f
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $6868
	ld l,e			; $6869
	inc (hl) ; [state2]
	inc l			; $686b
	ld (hl),60 ; [counter1]

; Spinning at max speed
@substate1:
	call _ecom_decCounter1		; $686e
	ld b,$08		; $6871
	jp nz,_headThwomp_rotate		; $6873

	ld l,e			; $6876
	inc (hl) ; [state2]
	inc l			; $6878
	ld (hl),$01 ; [counter1]
	inc l			; $687b
	ld (hl),$02 ; [counter2]

	ld l,Enemy.var30		; $687e
	ld (hl),$01		; $6880

; Slower spinning
@substate2:
	call _ecom_decCounter1		; $6882
	ret nz			; $6885

	inc l			; $6886
	dec (hl) ; [counter2]
	jr nz,++		; $6888

	ld (hl),$02		; $688a
	ld l,Enemy.var30		; $688c
	inc (hl)		; $688e
	ld a,(hl)		; $688f
	cp $12			; $6890
	jr nc,@startSlowestSpinning	; $6892
++
	ld l,Enemy.var30		; $6894
	ld a,(hl)		; $6896
	ld l,Enemy.counter1		; $6897
	ld (hl),a		; $6899
	ld b,$08		; $689a
	jp _headThwomp_rotate		; $689c

@startSlowestSpinning:
	ld l,Enemy.counter1		; $689f
	ld (hl),$01		; $68a1
	inc l			; $68a3
	ld (hl),$06 ; [counter2]
	ld l,e			; $68a6
	inc (hl) ; [state2]

; Slowest spinning; will stop when it reaches the target head
@substate3:
	call _ecom_decCounter1		; $68a8
	ret nz			; $68ab

	inc l			; $68ac
	ld a,(hl) ; [counter2]
	add $0c			; $68ae
	ldd (hl),a ; [counter2]
	ld (hl),a  ; [counter1]

	; Continue rotating if head color is wrong
	ld l,Enemy.direction		; $68b2
	ld a,(hl)		; $68b4
	ld l,Enemy.var31		; $68b5
	cp (hl)			; $68b7
	ld b,$08		; $68b8
	jp nz,_headThwomp_rotate		; $68ba

	ld l,Enemy.state		; $68bd
	inc (hl)		; $68bf
	ld l,Enemy.counter1		; $68c0
	ld (hl),$10		; $68c2
	ret			; $68c4


; Just reached the target head color
_headThwomp_stateC:
	call _ecom_decCounter1		; $68c5
	ret nz			; $68c8

	; Set state to number from $0d-$10 based on head color
	ld l,Enemy.direction		; $68c9
	ld a,(hl)		; $68cb
	srl a			; $68cc
	inc a			; $68ce
	ld l,e ; [state]
	add (hl)		; $68d0
	ld (hl),a		; $68d1

	inc l			; $68d2
	ld (hl),$00 ; [state2]
	ret			; $68d5


; Green face (shoots fireballs)
_headThwomp_stateD:
	inc e			; $68d6
	ld a,(de) ; [state2]
	or a			; $68d8
	jr nz,@substate1	; $68d9

@substate0:
	ld h,d			; $68db
	ld l,e			; $68dc
	inc (hl) ; [state2]

	inc l			; $68de
	ld (hl),$f0 ; [counter1]

	ld hl,wRoomCollisions+$47		; $68e1
	ld (hl),$00		; $68e4
	ret			; $68e6

@substate1:
	call _headThwomp_checkBombThrownIntoHead		; $68e7
	ret nz			; $68ea

	call _ecom_decCounter1		; $68eb
	jr z,@resumeSpinning	; $68ee

	ld a,(hl)		; $68f0
	cp 210			; $68f1
	call nc,enemyAnimate		; $68f3

	ld e,$c6		; $68f6
	ld a,(hl)		; $68f8
	and $1f			; $68f9
	ret nz			; $68fb
	ld b,PARTID_HEAD_THWOMP_FIREBALL		; $68fc
	jp _ecom_spawnProjectile		; $68fe

@resumeSpinning:
	ld l,Enemy.state		; $6901
	ld (hl),$11		; $6903
	ld l,Enemy.counter1		; $6905
	ld (hl),$01		; $6907
	ret			; $6909


; Blue face (fires circular projectiles)
_headThwomp_stateE:
	inc e			; $690a
	ld a,(de)		; $690b
	rst_jumpTable			; $690c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $6915
	ld l,e			; $6916
	inc (hl) ; [state2]

	inc l			; $6918
	ld a,$08		; $6919
	ldi (hl),a ; [counter1]
	ld (hl),a  ; [counter2] (number of times to fire)

	call getRandomNumber_noPreserveVars		; $691d
	and $02			; $6920
	jr nz,+			; $6922
	ld a,$fe		; $6924
+
	ld e,Enemy.var33		; $6926
	ld (de),a		; $6928
	ld hl,wRoomCollisions+$47		; $6929
	ld (hl),$00		; $692c
	ret			; $692e

; Waiting a moment before starting to fire
@substate1:
	call _headThwomp_checkBombThrownIntoHead		; $692f
	ret nz			; $6932
	call _ecom_decCounter1		; $6933
	jp nz,enemyAnimate		; $6936

	ld (hl),$08 ; [counter1]
	ld l,Enemy.state2		; $693b
	inc (hl)		; $693d

	ld hl,wRoomCollisions+$47		; $693e
	ld (hl),$03		; $6941

	call getFreePartSlot		; $6943
	jr nz,++		; $6946
	ld (hl),PARTID_HEAD_THWOMP_CIRCULAR_PROJECTILE		; $6948
	inc l			; $694a
	ld e,Enemy.var33		; $694b
	ld a,(de)		; $694d
	ld (hl),a ; [part.subid]
	ld bc,$f800		; $694f
	call objectCopyPositionWithOffset		; $6952
++
	ld e,Enemy.direction		; $6955
	ld a,(de)		; $6957
	jp enemySetAnimation		; $6958

; Cooldown after firing
@substate2:
	call _ecom_decCounter1		; $695b
	jp nz,enemyAnimate		; $695e

	ld (hl),30 ; [counter1]
	ld l,e			; $6963
	inc (hl) ; [state2]
	ret			; $6965

; Cooldown after firing; checks whether to fire again or return to normal state
@substate3:
	call _ecom_decCounter1		; $6966
	ret nz			; $6969

	inc l			; $696a
	dec (hl) ; [counter2]
	jr z,@resumeSpinning	; $696c

	; Fire again
	ld l,e			; $696e
	ld (hl),$01 ; [state2]
	ld a,$08		; $6971
	jr ++			; $6973

@resumeSpinning:
	ld l,Enemy.state		; $6975
	ld (hl),$11		; $6977

	ld a,$10		; $6979
++
	ld l,Enemy.counter1		; $697b
	ld (hl),a		; $697d

	ld hl,wRoomCollisions+$47		; $697e
	ld (hl),$00		; $6981
	ld e,Enemy.direction		; $6983
	ld a,(de)		; $6985
	add $08			; $6986
	jp enemySetAnimation		; $6988


; Purple face (stomps the ground)
_headThwomp_stateF:
	inc e			; $698b
	ld a,(de) ; [state2]
	rst_jumpTable			; $698d
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d			; $6998
	ld l,e			; $6999
	inc (hl) ; [state2]

	ld l,Enemy.speedZ		; $699b
	xor a			; $699d
	ldi (hl),a		; $699e
	ld (hl),$02		; $699f
	jp _headThwomp_unsetSolidTilesAroundSelf		; $69a1

; Falling
@substate1:
	ld a,$20		; $69a4
	call objectUpdateSpeedZ_sidescroll		; $69a6

	ld e,Enemy.yh		; $69a9
	ld a,(de)		; $69ab
	cp $90			; $69ac
	ret c			; $69ae

	ld h,d			; $69af
	ld l,Enemy.state2		; $69b0
	inc (hl)		; $69b2

	inc l			; $69b3
	ld (hl),120 ; [counter1]

@poundGround: ; Also used by death code
	ld a,60		; $69b6
	ld (wScreenShakeCounterY),a		; $69b8

	ld a,SND_STRONG_POUND		; $69bb
	jp playSound		; $69bd

; Resting on ground
@substate2:
	call _ecom_decCounter1		; $69c0
	jr z,@beginMovingUp	; $69c3

	ld a,(hl) ; [counter1]
	cp 30			; $69c6
	ret c			; $69c8

	; Spawn falling rocks every 16 frames
	and $0f			; $69c9
	ret nz			; $69cb
	call getFreePartSlot		; $69cc
	ret nz			; $69cf
	ld (hl),PARTID_3b		; $69d0
	ret			; $69d2

@beginMovingUp:
	ld l,e			; $69d3
	inc (hl) ; [state2]
	ret			; $69d5

; Moving back up
@substate3:
	ld h,d			; $69d6
	ld l,Enemy.y		; $69d7
	ld a,(hl)		; $69d9
	sub <($0080)			; $69da
	ldi (hl),a		; $69dc
	ld a,(hl)		; $69dd
	sbc >($0080)			; $69de
	ld (hl),a		; $69e0

	cp $56			; $69e1
	ret nz			; $69e3
	ld l,e			; $69e4
	inc (hl) ; [state2]
	ret			; $69e6

; Reached original position
@substate4:
	; Don't set tile solidity as long as Link is within 16 pixels (wouldn't want him
	; to get stuck)
	ld h,d			; $69e7
	ld l,Enemy.yh		; $69e8
	ld a,(w1Link.yh)		; $69ea
	sub (hl)		; $69ed
	add $10			; $69ee
	cp $21			; $69f0
	jr nc,@setSolidity	; $69f2

	ld l,Enemy.xh		; $69f4
	ld a,(w1Link.xh)		; $69f6
	sub (hl)		; $69f9
	add $10			; $69fa
	cp $21			; $69fc
	ret c			; $69fe

@setSolidity:
	ld l,Enemy.state		; $69ff
	ld (hl),$11		; $6a01
	ld l,Enemy.counter1		; $6a03
	ld (hl),$10		; $6a05
	jp _headThwomp_setSolidTilesAroundSelf		; $6a07


; Red face (takes damage)
_headThwomp_state10:
	inc e			; $6a0a
	ld a,(de) ; [state2]
	or a			; $6a0c
	jr nz,@substate1	; $6a0d

@substate0:
	ld h,d			; $6a0f
	ld l,e			; $6a10
	inc (hl) ; [state2]

	inc l			; $6a12
	ld (hl),120 ; [counter1]

	ld l,Enemy.invincibilityCounter		; $6a15
	ld (hl),$18		; $6a17

	ld l,Enemy.health		; $6a19
	dec (hl)		; $6a1b
	jr nz,++		; $6a1c

	; He's dead
	dec (hl)		; $6a1e
	call _headThwomp_unsetSolidTilesAroundSelf		; $6a1f
	ld a,TREE_GFXH_01		; $6a22
	ld (wLoadedTreeGfxIndex),a		; $6a24
++
	ld e,Enemy.health		; $6a27
	ld a,(de)		; $6a29
	inc a			; $6a2a
	call nz,_headThwomp_dropHeart		; $6a2b

	ld a,$10		; $6a2e
	call enemySetAnimation		; $6a30
	ld a,SND_BOSS_DAMAGE		; $6a33
	jp playSound		; $6a35

@substate1:
	call _ecom_decCounter1		; $6a38
	jr z,@resumeSpinning	; $6a3b

	; Run below code only if he's dead
	ld e,Enemy.health		; $6a3d
	ld a,(de)		; $6a3f
	inc a			; $6a40
	ret nz			; $6a41

	ld (hl),$ff		; $6a42

	ld a,$20		; $6a44
	call objectUpdateSpeedZ_sidescroll		; $6a46

	ld e,Enemy.yh		; $6a49
	ld a,(de)		; $6a4b
	cp $90			; $6a4c
	ret c			; $6a4e

	; Trigger generic "boss death" code by setting health to 0 for real
	ld h,d			; $6a4f
	ld l,Enemy.health		; $6a50
	ld (hl),$00		; $6a52
	jp _headThwomp_stateF@poundGround		; $6a54

@resumeSpinning:
	ld l,Enemy.state		; $6a57
	ld (hl),$11		; $6a59

	ld l,Enemy.counter1		; $6a5b
	ld (hl),$10		; $6a5d

	ld hl,wRoomCollisions+$47		; $6a5f
	ld (hl),$00		; $6a62

	ld a,$0e		; $6a64
	jp enemySetAnimation		; $6a66


_headThwomp_state11:
	call _ecom_decCounter1		; $6a69
	jp nz,enemyAnimate		; $6a6c

	inc (hl) ; [counter1]
	ld l,e			; $6a70
	ld (hl),$09 ; [state]

	ld l,Enemy.var34		; $6a73
	ld (hl),$f0		; $6a75
	ret			; $6a77


;;
; @addr{6a78}
_headThwomp_setSolidTilesAroundSelf:
	ld hl,wRoomCollisions+$46		; $6a78
	ld (hl),$01		; $6a7b
	inc l			; $6a7d
	inc l			; $6a7e
	ld (hl),$02		; $6a7f

	ld a,l			; $6a81
	add $0e			; $6a82
	ld l,a			; $6a84
	ld (hl),$05		; $6a85
	inc l			; $6a87
	ld (hl),$0f		; $6a88
	inc l			; $6a8a
	ld (hl),$0a		; $6a8b
	ret			; $6a8d

;;
; @addr{6a8e}
_headThwomp_unsetSolidTilesAroundSelf:
	ld hl,wRoomCollisions+$46		; $6a8e
	xor a			; $6a91
	ldi (hl),a		; $6a92
	ldi (hl),a		; $6a93
	ld (hl),a		; $6a94
	ld l,$56		; $6a95
	ldi (hl),a		; $6a97
	ldi (hl),a		; $6a98
	ld (hl),a		; $6a99
	ret			; $6a9a


;;
; @param	b	Animation base
; @addr{6a9b}
_headThwomp_rotate:
	ld e,Enemy.direction		; $6a9b
	ld a,(de)		; $6a9d
	inc a			; $6a9e
	and $07			; $6a9f
	ld (de),a		; $6aa1

	add b			; $6aa2
	call enemySetAnimation		; $6aa3

	ld e,Enemy.direction		; $6aa6
	ld a,(de)		; $6aa8
	rrca			; $6aa9
	ret c			; $6aaa
	ld a,SND_CLINK2		; $6aab
	jp playSound		; $6aad


;;
; If a bomb is thrown into head thwomp, this sets the state to $0a.
;
; @param[out]	zflag	z if no bomb entered head thwomp
; @addr{6ab0}
_headThwomp_checkBombThrownIntoHead:
	ldhl FIRST_DYNAMIC_ITEM_INDEX,Item.start		; $6ab0
@itemLoop:
	ld l,Item.id		; $6ab3
	ld a,(hl)		; $6ab5
	cp ITEMID_BOMB			; $6ab6
	jr nz,@nextItem	; $6ab8

	ld l,Item.state		; $6aba
	ldi a,(hl)		; $6abc
	dec a			; $6abd
	jr z,@isNonExplodingBomb	; $6abe
	ld a,(hl)		; $6ac0
	cp $02			; $6ac1
	jr c,@nextItem	; $6ac3

@isNonExplodingBomb:
	; Check if bomb is in the right position to enter thwomp
	ld l,Item.yh		; $6ac5
	ldi a,(hl)		; $6ac7
	sub $50			; $6ac8
	add $0c			; $6aca
	cp $19			; $6acc
	jr nc,@nextItem	; $6ace
	inc l			; $6ad0
	ld a,(hl)		; $6ad1
	sub $78			; $6ad2
	add $0c			; $6ad4
	cp $19			; $6ad6
	jr c,@bombEnteredThwomp	; $6ad8

@nextItem:
	inc h			; $6ada
	ld a,h			; $6adb
	cp LAST_DYNAMIC_ITEM_INDEX+1			; $6adc
	jr c,@itemLoop		; $6ade

	ld e,Enemy.var32		; $6ae0
	ld a,(de)		; $6ae2
	rrca			; $6ae3
	jr c,@triggerBombEffect	; $6ae4

	xor a			; $6ae6
	ret			; $6ae7

@bombEnteredThwomp:
	ld l,Item.var2f		; $6ae8
	set 5,(hl)		; $6aea

@triggerBombEffect:
	ld h,d			; $6aec
	ld l,Enemy.var32		; $6aed
	set 0,(hl)		; $6aef

	ld e,Enemy.direction		; $6af1
	ld a,(de)		; $6af3
	bit 0,a			; $6af4
	jr nz,@betweenTwoHeads	; $6af6

	ld l,Enemy.var31		; $6af8
	ld (hl),a		; $6afa

	ld l,Enemy.var32		; $6afb
	ld (hl),$00		; $6afd

	ld l,Enemy.state		; $6aff
	ld (hl),$0a		; $6b01

	ld l,Enemy.counter1		; $6b03
	ld (hl),$06		; $6b05

	call enemySetAnimation		; $6b07

	ld hl,wRoomCollisions+$47		; $6b0a
	ld (hl),$03		; $6b0d
	or d			; $6b0f
	ret			; $6b10

@betweenTwoHeads:
	call _ecom_decCounter1		; $6b11
	ret nz			; $6b14

	ld b,$00		; $6b15
	call _headThwomp_rotate		; $6b17
	jr @triggerBombEffect		; $6b1a

;;
; @addr{6b1c}
_headThwomp_dropHeart:
	call getFreePartSlot		; $6b1c
	ret nz			; $6b1f
	ld (hl),PARTID_ITEM_DROP		; $6b20
	inc l			; $6b22
	ld (hl),ITEM_DROP_HEART		; $6b23
	ld bc,$1400		; $6b25
	jp objectCopyPositionWithOffset		; $6b28

;;
; @addr{6b2b}
_headThwomp_checkShootProjectile:
	ld a,(wFrameCounter)		; $6b2b
	rrca			; $6b2e
	ret c			; $6b2f

	ld h,d			; $6b30
	ld l,Enemy.var34		; $6b31
	dec (hl)		; $6b33
	jr nz,+			; $6b34
	ld (hl),$f0		; $6b36
+
	ld a,(hl)		; $6b38
	cp 90			; $6b39
	ret nc			; $6b3b
	and $0f			; $6b3c
	ret nz			; $6b3e

	call getRandomNumber_noPreserveVars		; $6b3f
	and $07			; $6b42
	jr z,@dropBomb			; $6b44

	ld b,PARTID_HEAD_THWOMP_FIREBALL		; $6b46
	jp _ecom_spawnProjectile		; $6b48

@dropBomb:
	ld b,$02		; $6b4b
	call checkBPartSlotsAvailable		; $6b4d
	ret nz			; $6b50

	; Spawn bomb drop
	call getFreePartSlot		; $6b51
	ld (hl),PARTID_ITEM_DROP		; $6b54
	inc l			; $6b56
	ld (hl),ITEM_DROP_BOMBS		; $6b57
	call objectCopyPosition		; $6b59

	; Spawn bomb drop "physics" object?
	ld b,h			; $6b5c
	call getFreePartSlot		; $6b5d
	ld (hl),PARTID_40		; $6b60

	ld l,Part.relatedObj1		; $6b62
	ld a,Part.start		; $6b64
	ldi (hl),a		; $6b66
	ld (hl),b		; $6b67

	jp objectCopyPosition		; $6b68


; ==============================================================================
; ENEMYID_SHADOW_HAG
;
; Variables:
;   counter2: Number of times to spawn bugs before shadows separate
;   var30: Number of bugs on-screen
;   var31: Set if the hag couldn't spawn because Link was in a bad position
; ==============================================================================
enemyCode7a:
	jr z,@normalStatus	; $6b6b
	sub ENEMYSTATUS_NO_HEALTH			; $6b6d
	ret c			; $6b6f
	jr nz,@normalStatus	; $6b70

	; Dead. Delete all "children" objects.
	ld e,Enemy.collisionType		; $6b72
	ld a,(de)		; $6b74
	or a			; $6b75
	jr z,@dead	; $6b76
	ldhl FIRST_ENEMY_INDEX, Enemy.start		; $6b78
@killNext:
	ld l,Enemy.id		; $6b7b
	ld a,(hl)		; $6b7d
	cp ENEMYID_SHADOW_HAG_BUG			; $6b7e
	call z,_ecom_killObjectH		; $6b80
	inc h			; $6b83
	ld a,h			; $6b84
	cp LAST_ENEMY_INDEX+1			; $6b85
	jr c,@killNext	; $6b87
@dead:
	jp _enemyBoss_dead		; $6b89

@normalStatus:
	ld e,Enemy.state		; $6b8c
	ld a,(de)		; $6b8e
	rst_jumpTable			; $6b8f
	.dw _shadowHag_state_uninitialized
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state_stub
	.dw _shadowHag_state8
	.dw _shadowHag_state9
	.dw _shadowHag_stateA
	.dw _shadowHag_stateB
	.dw _shadowHag_stateC
	.dw _shadowHag_stateD
	.dw _shadowHag_stateE
	.dw _shadowHag_stateF
	.dw _shadowHag_state10
	.dw _shadowHag_state11
	.dw _shadowHag_state12
	.dw _shadowHag_state13

_shadowHag_state_uninitialized:
	ld a,ENEMYID_SHADOW_HAG		; $6bb8
	ld b,$00		; $6bba
	call _enemyBoss_initializeRoom		; $6bbc
	ld a,SPEED_80		; $6bbf
	jp _ecom_setSpeedAndState8		; $6bc1


_shadowHag_state_stub:
	ret			; $6bc4


_shadowHag_state8:
	inc e			; $6bc5
	ld a,(de)		; $6bc6
	rst_jumpTable			; $6bc7
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

; Wait for door to close, then begin cutscene
@substate0:
	ld a,($cc93)		; $6bd2
	or a			; $6bd5
	ret nz			; $6bd6

	inc a			; $6bd7
	ld (wDisabledObjects),a		; $6bd8

	ld bc,$0104		; $6bdb
	call _enemyBoss_spawnShadow		; $6bde
	ret nz			; $6be1

	ld h,d			; $6be2
	ld l,Enemy.state2		; $6be3
	inc (hl)		; $6be5
	ld l,Enemy.angle		; $6be6
	ld (hl),$18		; $6be8
	ld l,Enemy.zh		; $6bea
	ld (hl),$ff		; $6bec

	; Set position to Link's position
	ld l,Enemy.yh		; $6bee
	ldh a,(<hEnemyTargetY)	; $6bf0
	add $04			; $6bf2
	ldi (hl),a		; $6bf4
	inc l			; $6bf5
	ldh a,(<hEnemyTargetX)	; $6bf6
	ld (hl),a		; $6bf8
	ret			; $6bf9

; Moving left to center of room
@substate1:
	ld e,Enemy.xh		; $6bfa
	ld a,(de)		; $6bfc
	cp ((LARGE_ROOM_WIDTH/2)<<4)+8			; $6bfd
	jp nc,objectApplySpeed		; $6bff

	call _shadowHag_beginEmergingFromShadow		; $6c02
	ld h,d			; $6c05
	ld l,Enemy.state2		; $6c06
	inc (hl)		; $6c08

	inc l			; $6c09
	ld (hl),$10 ; [counter1]

	ld l,Enemy.zh		; $6c0c
	ld (hl),$00		; $6c0e
	jp _ecom_killRelatedObj2		; $6c10

; Emerging from shadow
@substate2:
	call _shadowHag_updateEmergingFromShadow		; $6c13
	ret nz			; $6c16

	ld e,Enemy.state2		; $6c17
	ld a,$03		; $6c19
	ld (de),a		; $6c1b
	dec a			; $6c1c
	jp enemySetAnimation		; $6c1d

; Delay before showing textbox
@substate3:
	call _ecom_decCounter1		; $6c20
	jr nz,@animate	; $6c23

	ld (hl),$08		; $6c25
	ld l,e			; $6c27
	inc (hl)		; $6c28
	ld bc,TX_2f2b		; $6c29
	jp showText		; $6c2c

@substate4:
	call _ecom_decCounter1		; $6c2f
	jr nz,@animate	; $6c32
	call _shadowHag_beginReturningToGround		; $6c34
	call _enemyBoss_beginBoss		; $6c37
@animate:
	jp enemyAnimate		; $6c3a


; Currently in the ground, showing eyes
_shadowHag_state9:
	call _ecom_decCounter2		; $6c3d
	jp nz,shadowHag_updateReturningToGround		; $6c40

	dec l			; $6c43
	ld a,(hl)		; $6c44
	or a			; $6c45
	jr z,@spawnShadows			; $6c46

	dec (hl)		; $6c48
	jp _ecom_flickerVisibility		; $6c49

@spawnShadows:
	ld b,$04		; $6c4c
	call checkBPartSlotsAvailable		; $6c4e
	ret nz			; $6c51

	ldbc PARTID_SHADOW_HAG_SHADOW,$04		; $6c52
--
	call _ecom_spawnProjectile		; $6c55
	dec c			; $6c58
	ld l,Part.angle		; $6c59
	ld (hl),c		; $6c5b
	jr nz,--		; $6c5c

	; Go to state A
	call _ecom_incState		; $6c5e
	ld l,Enemy.counter1		; $6c61
	ld (hl),150		; $6c63
	inc l			; $6c65
	ld (hl),$04 ; [counter2]

	ld l,Enemy.collisionType		; $6c68
	res 7,(hl)		; $6c6a
	jp objectSetInvisible		; $6c6c


; Shadows chasing Link
_shadowHag_stateA:
	ld a,(wFrameCounter)		; $6c6f
	rrca			; $6c72
	ret c			; $6c73
	call _ecom_decCounter1		; $6c74
	ret nz			; $6c77

	; Time for shadows to reconverge.

	dec (hl) ; [counter1] = $ff
	ld l,e			; $6c79
	inc (hl) ; [state] = $0b

	call getRandomNumber_noPreserveVars		; $6c7b
	and $06			; $6c7e
	ld hl,@targetPositions		; $6c80
	rst_addAToHl			; $6c83
	ld e,Enemy.yh		; $6c84
	ldi a,(hl)		; $6c86
	ld (de),a		; $6c87
	ld e,Enemy.xh		; $6c88
	ld a,(hl)		; $6c8a
	ld (de),a		; $6c8b
	ret			; $6c8c

; When the shadows reconverge, one of these positions is chosen randomly.
@targetPositions:
	.db $38 $48
	.db $38 $b8
	.db $78 $48
	.db $78 $b8


; Shadows reconverging to target position
_shadowHag_stateB:
	ld e,Enemy.counter2		; $6c95
	ld a,(de)		; $6c97
	or a			; $6c98
	ret nz			; $6c99

	; All shadows have now returned.

	; Decide how many times to spawn bugs before shadows separate again
	call getRandomNumber_noPreserveVars		; $6c9a
	and $01			; $6c9d
	add $02			; $6c9f
	ld e,Enemy.counter2		; $6ca1
	ld (de),a		; $6ca3

_shadowHag_initStateC:
	ld h,d			; $6ca4
	ld l,Enemy.state		; $6ca5
	ld (hl),$0c		; $6ca7
	ld l,Enemy.counter1		; $6ca9
	ld (hl),30		; $6cab

	ld l,Enemy.collisionType		; $6cad
	ld (hl),$80|ENEMYID_PODOBOO		; $6caf

	ld l,Enemy.collisionRadiusY		; $6cb1
	ld (hl),$03		; $6cb3
	inc l			; $6cb5
	ld (hl),$05		; $6cb6

	call objectSetVisible83		; $6cb8
	ld a,$04		; $6cbb
	jp enemySetAnimation		; $6cbd


; Delay before spawning bugs
_shadowHag_stateC:
	call _ecom_decCounter1		; $6cc0
	jr nz,++		; $6cc3
	ld (hl),$41		; $6cc5
	ld l,e			; $6cc7
	inc (hl)		; $6cc8
++
	jp enemyAnimate		; $6cc9


; Spawning bugs
_shadowHag_stateD:
	call enemyAnimate		; $6ccc
	call _ecom_decCounter1		; $6ccf
	jr z,@doneSpawningBugs	; $6cd2

	; Spawn bug every 16 frames
	ld a,(hl)		; $6cd4
	and $0f			; $6cd5
	ret nz			; $6cd7

	; Maximum of 7 at a time
	ld e,Enemy.var30		; $6cd8
	ld a,(de)		; $6cda
	cp $07			; $6cdb
	ret nc			; $6cdd

	; Spawn bug
	ld b,ENEMYID_SHADOW_HAG_BUG		; $6cde
	call _ecom_spawnUncountedEnemyWithSubid01		; $6ce0
	ret nz			; $6ce3

	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1		; $6ce4
	ld a,Enemy.start		; $6ce6
	ldi (hl),a		; $6ce8
	ld (hl),d		; $6ce9

	; [child.position] = [this.position]
	call objectCopyPosition		; $6cea

	ld h,d			; $6ced
	ld l,Enemy.var30		; $6cee
	inc (hl)		; $6cf0
	ret			; $6cf1

@doneSpawningBugs:
	call _ecom_incState		; $6cf2
	ld l,Enemy.counter1		; $6cf5
	ld (hl),30		; $6cf7
	ret			; $6cf9


; Done spawning bugs; delay before the hag herself spawns in
_shadowHag_stateE:
	call _ecom_decCounter1		; $6cfa
	jp nz,_ecom_flickerVisibility		; $6cfd

	ld e,Enemy.var31		; $6d00
	ld a,(de)		; $6d02
	or a			; $6d03
	ld a,90		; $6d04
	jr z,++			; $6d06
	xor a			; $6d08
	ld (de),a		; $6d09
	ld a,150		; $6d0a
++
	ld (hl),a ; [counter1] = a

	ld l,Enemy.state		; $6d0d
	inc (hl)		; $6d0f
	ld l,Enemy.collisionType		; $6d10
	res 7,(hl)		; $6d12
	jp objectSetInvisible		; $6d14


; Waiting for Link to be in a position where the hag can spawn behind him
_shadowHag_stateF:
	call _ecom_decCounter1		; $6d17
	jr z,@couldntSpawn	; $6d1a

	call _shadowHag_chooseSpawnPosition		; $6d1c
	ret nz			; $6d1f
	ld e,Enemy.yh		; $6d20
	ld a,b			; $6d22
	ld (de),a		; $6d23
	ld e,Enemy.xh		; $6d24
	ld a,c			; $6d26
	ld (de),a		; $6d27
	call _shadowHag_beginEmergingFromShadow		; $6d28
	jp _ecom_incState		; $6d2b

@couldntSpawn:
	ld e,Enemy.var31		; $6d2e
	ld a,$01		; $6d30
	ld (de),a		; $6d32

	inc l			; $6d33
	dec (hl) ; [counter2]--
	jp nz,_shadowHag_initStateC		; $6d35

	call _shadowHag_beginReturningToGround		; $6d38
	ld a,$04		; $6d3b
	jp enemySetAnimation		; $6d3d


; Spawning out of ground to attack Link
_shadowHag_state10:
	call _shadowHag_updateEmergingFromShadow		; $6d40
	ret nz			; $6d43

	call _ecom_incState		; $6d44

	ld l,Enemy.collisionType		; $6d47
	ld (hl),$80|ENEMYID_SHADOW_HAG		; $6d49

	ld l,Enemy.speed		; $6d4b
	ld (hl),SPEED_180		; $6d4d
	ld l,Enemy.counter1		; $6d4f
	ld (hl),30		; $6d51
	ld l,Enemy.direction		; $6d53
	ld (hl),$ff		; $6d55

	ld l,Enemy.collisionRadiusY		; $6d57
	ld (hl),$0c		; $6d59
	inc l			; $6d5b
	ld (hl),$08		; $6d5c

	call _ecom_updateCardinalAngleTowardTarget		; $6d5e
	jp _ecom_updateAnimationFromAngle		; $6d61


; Delay before charging at Link
_shadowHag_state11:
	call _shadowHag_checkLinkLookedAtHag		; $6d64
	jr z,_shadowHag_doneCharging	; $6d67

	call _ecom_decCounter1		; $6d69
	ret nz			; $6d6c
	ld (hl),60		; $6d6d

	ld l,Enemy.state		; $6d6f
	inc (hl)		; $6d71

_shadowHag_animate:
	jp enemyAnimate		; $6d72


; Charging at Link
_shadowHag_state12:
	call _shadowHag_checkLinkLookedAtHag		; $6d75
	jr z,_shadowHag_doneCharging	; $6d78

	call _ecom_decCounter1		; $6d7a
	jr z,_shadowHag_doneCharging	; $6d7d

	ld e,Enemy.yh		; $6d7f
	ld a,(de)		; $6d81
	sub $12			; $6d82
	cp (LARGE_ROOM_HEIGHT<<4)-$32			; $6d84
	jr nc,_shadowHag_doneCharging	; $6d86

	ld e,Enemy.xh		; $6d88
	ld a,(de)		; $6d8a
	sub $18			; $6d8b
	cp (LARGE_ROOM_WIDTH<<4)-$30			; $6d8d
	jr nc,_shadowHag_doneCharging	; $6d8f
	call objectApplySpeed		; $6d91
	jr _shadowHag_animate		; $6d94


_shadowHag_doneCharging:
	call _ecom_decCounter2		; $6d96
	jp z,_shadowHag_beginReturningToGround		; $6d99

	ld l,Enemy.counter1		; $6d9c
	ld (hl),30		; $6d9e

	ld l,Enemy.state		; $6da0
	inc (hl)		; $6da2

	ld l,Enemy.collisionType		; $6da3
	ld (hl),$80|ENEMYID_PODOBOO		; $6da5
	ld a,$06		; $6da7
	jp enemySetAnimation		; $6da9


; Delay before spawning bugs again
_shadowHag_state13:
	call _ecom_decCounter1		; $6dac
	jr nz,shadowHag_updateReturningToGround	; $6daf
	jp _shadowHag_initStateC		; $6db1


;;
; @addr{6db4}
_shadowHag_beginEmergingFromShadow:
	ld a,$05		; $6db4
	call enemySetAnimation		; $6db6
	call objectSetVisible82		; $6db9
	ld e,Enemy.yh		; $6dbc
	ld a,(de)		; $6dbe
	sub $04			; $6dbf
	ld (de),a		; $6dc1
	ret			; $6dc2

;;
; @param[out]	zflag	z if done emerging? (animParameter was $ff)
; @addr{6dc3}
_shadowHag_updateEmergingFromShadow:
	call enemyAnimate		; $6dc3
	ld e,Enemy.animParameter		; $6dc6
	ld a,(de)		; $6dc8
	inc a			; $6dc9
	ret z			; $6dca

	; If [animParameter] == 1, y -= 8? (To center the hitbox maybe?)
	sub $02			; $6dcb
	ret nz			; $6dcd
	ld (de),a		; $6dce

	ld e,Enemy.yh		; $6dcf
	ld a,(de)		; $6dd1
	sub $08			; $6dd2
	ld (de),a		; $6dd4
	or d			; $6dd5
	ret			; $6dd6

;;
; @addr{6dd7}
shadowHag_updateReturningToGround:
	call enemyAnimate		; $6dd7

	ld e,Enemy.animParameter		; $6dda
	ld a,(de)		; $6ddc
	or a			; $6ddd
	ret z			; $6dde
	bit 7,a			; $6ddf
	ret nz			; $6de1

	dec a			; $6de2
	ld hl,@yOffsets		; $6de3
	rst_addAToHl			; $6de6

	ld e,Enemy.yh		; $6de7
	ld a,(de)		; $6de9
	add (hl)		; $6dea
	ld (de),a		; $6deb

	ld e,Enemy.animParameter		; $6dec
	xor a			; $6dee
	ld (de),a		; $6def
	ret			; $6df0

@yOffsets:
	.db $08 $04

;;
; Sets state to 9 & initializes stuff
; @addr{6df3}
_shadowHag_beginReturningToGround:
	ld h,d			; $6df3
	ld l,Enemy.state		; $6df4
	ld (hl),$09		; $6df6

	ld l,Enemy.counter1		; $6df8
	ld (hl),90		; $6dfa
	inc l			; $6dfc
	ld (hl),30 ; [counter2]

	; Make hag invincible
	ld l,Enemy.collisionType		; $6dff
	ld (hl),$80|ENEMYID_PODOBOO		; $6e01

	ld l,Enemy.collisionRadiusY		; $6e03
	ld (hl),$03		; $6e05
	inc l			; $6e07
	ld (hl),$05		; $6e08

	ld a,$06		; $6e0a
	jp enemySetAnimation		; $6e0c

;;
; Chooses position to spawn at for charge attack based on Link's facing direction.
;
; @param[out]	bc	Spawn position
; @param[out]	zflag	nz if Link is too close to the wall to spawn in
; @addr{6e0f}
_shadowHag_chooseSpawnPosition:
	ld a,(w1Link.direction)		; $6e0f
	ld hl,@spawnOffsets		; $6e12
	rst_addDoubleIndex			; $6e15

	ld a,(w1Link.yh)		; $6e16
	add (hl)		; $6e19
	ld b,a			; $6e1a
	sub $1c			; $6e1b
	cp $80			; $6e1d
	jr nc,@invalid		; $6e1f

	inc hl			; $6e21
	ld a,(w1Link.xh)		; $6e22
	ld e,a			; $6e25
	add (hl)		; $6e26
	ld c,a			; $6e27
	cp $f0			; $6e28
	jr nc,@invalid		; $6e2a

	sub e			; $6e2c
	jr nc,++		; $6e2d
	cpl			; $6e2f
	inc a			; $6e30
++
	rlca			; $6e31
	jp nc,getTileCollisionsAtPosition		; $6e32

@invalid:
	or d			; $6e35
	ret			; $6e36

@spawnOffsets:
	.db $40 $00
	.db $08 $c0
	.db $c0 $00
	.db $08 $40

;;
; @param[out]	zflag	z if Link looked at the hag
; @addr{6e3f}
_shadowHag_checkLinkLookedAtHag:
	call objectGetAngleTowardEnemyTarget		; $6e3f
	add $14			; $6e42
	and $18			; $6e44
	swap a			; $6e46
	rlca			; $6e48
	ld b,a			; $6e49
	ld a,(w1Link.direction)		; $6e4a
	cp b			; $6e4d
	ret			; $6e4e


; ==============================================================================
; ENEMYID_EYESOAR
;
; Variables:
;   var30-var35: Object indices of children
;   var36/var37: Target Y/X position for state $0b
;   var38: The distance each child should be from Eyesoar (the value they're moving
;          toward)
;   var39: Bit 4: Set when children should return?
;          Bit 3: Unset to make the children start moving back to Eyesoar (after using
;                 switch hook on him)
;          Bit 2: Set while eyesoar is in his "dazed" state (Signals children to start
;                 moving around randomly)
;          Bit 1: Set to indicate the children should start moving again as normal after
;                 returning to Eyesoar
;          Bit 0: While set, children don't respawn?
;   var3a: Bits 0-3: set when corresponding children have reached their target distance
;                    away from eyesoar?
;          Bits 4-7: set when corresponding children have reached their target position
;                    relative to eyesoar after using the switch hook on him?
;   var3b: Current "angle" (rotation offset for children)
;   var3c: Counter until bit 0 of var39 gets reset
; ==============================================================================
enemyCode7b:
	jr z,@normalStatus	; $6e4f
	sub ENEMYSTATUS_NO_HEALTH			; $6e51
	ret c			; $6e53
	jp z,_eyesoar_dead		; $6e54

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK

	; TODO: Checking for mystery seed? Why?
	ld h,d			; $6e57
	ld l,Enemy.var2a		; $6e58
	ld a,(hl)		; $6e5a
	cp $80|ITEMCOLLISION_MYSTERY_SEED			; $6e5b
	jr nz,@normalStatus	; $6e5d
	ld l,Enemy.var3c		; $6e5f
	ld (hl),$78		; $6e61
	ld l,Enemy.var39		; $6e63
	set 0,(hl)		; $6e65

@normalStatus:
	ld h,d			; $6e67
	ld l,Enemy.var3c		; $6e68
	ld a,(hl)		; $6e6a
	or a			; $6e6b
	jr z,++			; $6e6c
	dec (hl)		; $6e6e
	jr nz,++		; $6e6f

	ld l,Enemy.var39		; $6e71
	res 0,(hl)		; $6e73
++
	ld e,Enemy.state		; $6e75
	ld a,(de)		; $6e77
	rst_jumpTable			; $6e78
	.dw _eyesoar_state_uninitialized
	.dw _eyesoar_state1
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_switchHook
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_stub
	.dw _eyesoar_state_stub
	.dw _eyesoar_state8
	.dw _eyesoar_state9
	.dw _eyesoar_stateA
	.dw _eyesoar_stateB
	.dw _eyesoar_stateC
	.dw _eyesoar_stateD
	.dw _eyesoar_stateE


_eyesoar_state_uninitialized:
	ld h,d			; $6e97
	ld l,Enemy.counter1		; $6e98
	ld (hl),60		; $6e9a

	ld l,Enemy.zh		; $6e9c
	ld (hl),$fe		; $6e9e

	; Check for subid 1
	ld l,Enemy.subid		; $6ea0
	ld a,(hl)		; $6ea2
	or a			; $6ea3
	ld a,SPEED_80		; $6ea4
	jp nz,_ecom_setSpeedAndState8		; $6ea6

	; BUG: This sets an invalid state!
	; 'a+1' == SPEED_80+1 == $15, a state which isn't defined.
	; Doesn't really matter, since this object will be deleted anyway...
	; But there are obscure conditions below where it returns before deleting itself.
	; Then this would become a problem. But those conditions probably never happen...
	inc a			; $6ea9
	ld (de),a ; [state] = $15 (!)

	ld a,$ff		; $6eab
	ld b,$00		; $6ead
	call _enemyBoss_initializeRoom		; $6eaf


; Spawning "real" eyesoar and children.
_eyesoar_state1:
	; If this actually returns here, the game could crash (see above note).
	ld b,$05		; $6eb2
	call checkBEnemySlotsAvailable		; $6eb4
	ret nz			; $6eb7

	; Spawn the "real" version of the boss (subid 1).
	ld b,ENEMYID_EYESOAR		; $6eb8
	call _ecom_spawnUncountedEnemyWithSubid01		; $6eba

	ld l,Enemy.enabled		; $6ebd
	ld e,l			; $6ebf
	ld a,(de)		; $6ec0
	ld (hl),a		; $6ec1
	call objectCopyPosition		; $6ec2

	; Spawn 4 children.
	ld l,Enemy.var30		; $6ec5
	ld b,h			; $6ec7
	ld c,$04		; $6ec8

@spawnChildLoop:
	push hl			; $6eca
	call getFreeEnemySlot_uncounted		; $6ecb
	ld (hl),ENEMYID_EYESOAR_CHILD		; $6ece
	inc l			; $6ed0
	dec c			; $6ed1
	ld (hl),c ; [child.subid]

	ld l,Enemy.relatedObj1+1		; $6ed3
	ld a,b			; $6ed5
	ldd (hl),a		; $6ed6
	ld (hl),Enemy.start		; $6ed7
	ld a,h			; $6ed9
	pop hl			; $6eda
	ldi (hl),a ; [var30+i] = child object index
	jr nz,@spawnChildLoop	; $6edc

	jp enemyDelete		; $6ede


_eyesoar_state_switchHook:
	inc e			; $6ee1
	ld a,(de)		; $6ee2
	rst_jumpTable			; $6ee3
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	; Signal children to run around randomly
	ld h,d			; $6eec
	ld l,Enemy.var39		; $6eed
	ld a,(hl)		; $6eef
	or $0a			; $6ef0
	ldd (hl),a		; $6ef2

	; Jdust var38 (distance away children should be)?
	ld a,(hl)		; $6ef3
	and $07			; $6ef4
	or $18			; $6ef6
	ld (hl),a		; $6ef8

	ld l,Enemy.enemyCollisionMode		; $6ef9
	ld (hl),ENEMYCOLLISION_EYESOAR_VULNERABLE		; $6efb
	ld l,Enemy.counter1		; $6efd
	ld (hl),150		; $6eff
	ld l,Enemy.direction		; $6f01
	ld (hl),$00		; $6f03
	jp _ecom_incState2		; $6f05

@substate1:
	ret			; $6f08

@substate2:
	ld e,Enemy.direction		; $6f09
	ld a,(de)		; $6f0b
	or a			; $6f0c
	ret nz			; $6f0d

	inc a			; $6f0e
	ld (de),a		; $6f0f
	jp enemySetAnimation		; $6f10

@substate3:
	ld b,$0c		; $6f13
	jp _ecom_fallToGroundAndSetState		; $6f15


_eyesoar_state_stub:
	ret			; $6f18


; Flickering into existence
_eyesoar_state8:
	; Something about doors?
	ld a,($cc93)		; $6f19
	or a			; $6f1c
	ret nz			; $6f1d

	inc a			; $6f1e
	ld (wDisabledObjects),a		; $6f1f
	call _ecom_decCounter1		; $6f22
	jp nz,_ecom_flickerVisibility		; $6f25

	ld (hl),60  ; [counter1]
	inc l			; $6f2a
	ld (hl),180 ; [counter2]

	; [var3a] = $ff (all children are in place at the beginning)
	ld l,Enemy.var3a		; $6f2d
	dec (hl)		; $6f2f

	ld l,e			; $6f30
	inc (hl) ; [state]
	jp objectSetVisiblec2		; $6f32


; Waiting [counter1] frames until fight begins
_eyesoar_state9:
	call _ecom_decCounter1		; $6f35
	jr nz,_eyesoar_animate	; $6f38

	ld l,e			; $6f3a
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $6f3c
	inc (hl)		; $6f3e

	call _enemyBoss_beginBoss		; $6f3f
	jr _eyesoar_animate		; $6f42


; Standing still for [counter1] frames?
_eyesoar_stateA:
	call _eyesoar_updateFormation		; $6f44
	call _ecom_decCounter1		; $6f47
	jr nz,_eyesoar_animate	; $6f4a

	ld l,Enemy.state		; $6f4c
	inc (hl)		; $6f4e

	; Decide on target position (written to var36/var37)
	ld l,Enemy.var36		; $6f4f
	ldh a,(<hEnemyTargetY)	; $6f51
	ld b,a			; $6f53
	sub $40			; $6f54
	cp $30			; $6f56
	jr c,++			; $6f58
	cp $c0			; $6f5a
	ld b,$40		; $6f5c
	jr nc,++		; $6f5e
	ld b,$70		; $6f60
++
	ld a,b			; $6f62
	ldi (hl),a ; [var36]

	ldh a,(<hEnemyTargetX)	; $6f64
	ld b,a			; $6f66
	sub $40			; $6f67
	cp $70			; $6f69
	jr c,++			; $6f6b
	cp $c0			; $6f6d
	ld b,$40		; $6f6f
	jr nc,++		; $6f71
	ld b,$b0		; $6f73
++
	ld (hl),b ; [var37]

	jr _eyesoar_animate		; $6f76


; Moving until it reaches its target position
_eyesoar_stateB:
	call _eyesoar_updateFormation		; $6f78
	ld h,d			; $6f7b
	ld l,Enemy.var36		; $6f7c

	call _ecom_readPositionVars		; $6f7e
	sub c			; $6f81
	add $02			; $6f82
	cp $05			; $6f84
	jr nc,++	; $6f86
	ldh a,(<hFF8F)	; $6f88
	sub b			; $6f8a
	add $02			; $6f8b
	cp $05			; $6f8d
	jr nc,++	; $6f8f

	ld l,Enemy.state		; $6f91
	dec (hl)		; $6f93
	ld l,Enemy.counter1		; $6f94
	ld (hl),60		; $6f96
	jr _eyesoar_animate		; $6f98
++
	call _ecom_moveTowardPosition		; $6f9a

_eyesoar_animate:
	jp enemyAnimate		; $6f9d


; Spinning in place after being switch hook'd
_eyesoar_stateC:
	call _ecom_decCounter1		; $6fa0
	jr nz,_eyesoar_animate	; $6fa3

	ld l,e			; $6fa5
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $6fa7
	ld (hl),ENEMYCOLLISION_EYESOAR		; $6fa9

	xor a			; $6fab
	call enemySetAnimation		; $6fac


; Moving back up into the air
_eyesoar_stateD:
	ld h,d			; $6faf
	ld l,Enemy.z		; $6fb0
	ld a,(hl)		; $6fb2
	sub $80			; $6fb3
	ldi (hl),a		; $6fb5
	ld a,(hl)		; $6fb6
	sbc $00			; $6fb7
	ld (hl),a		; $6fb9

	cp $fe			; $6fba
	jr nz,_eyesoar_animate	; $6fbc

	ld l,e			; $6fbe
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $6fc0
	ld (hl),240		; $6fc2

	ld l,Enemy.var3a		; $6fc4
	ld (hl),$0f		; $6fc6

	ld l,Enemy.var39		; $6fc8
	res 1,(hl)		; $6fca
	call _eyesoar_chooseNewAngle		; $6fcc


; Flying around kinda randomly
_eyesoar_stateE:
	call _ecom_decCounter1		; $6fcf
	jr nz,++		; $6fd2
	ld l,Enemy.var39		; $6fd4
	res 3,(hl)		; $6fd6
	set 4,(hl)		; $6fd8
++
	ld l,Enemy.var3a		; $6fda
	ld a,(hl)		; $6fdc
	inc a			; $6fdd
	jr nz,++		; $6fde

	; All children dead?
	dec l			; $6fe0
	res 4,(hl) ; [var39]
	ld l,e			; $6fe3
	ld (hl),$0a ; [state]

	ld l,Enemy.counter1		; $6fe6
	ld (hl),$01 ; [counter1]		; $6fe8
	inc l			; $6fea
	ld (hl),$08 ; [counter2]
++
	ld l,Enemy.counter1		; $6fed
	ld a,(hl)		; $6fef
	and $3f			; $6ff0
	call z,_eyesoar_chooseNewAngle		; $6ff2
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6ff5
	jr _eyesoar_animate		; $6ff8


;;
; Checks to update the "formation", that is, the distances away from Eyesoar for the
; children.
; @addr{6ffa}
_eyesoar_updateFormation:
	; Check all children are at their target distance away from Eyesoar
	ld e,Enemy.var3a		; $6ffa
	ld a,(de)		; $6ffc
	ld c,a			; $6ffd
	and $f0			; $6ffe
	cp $f0			; $7000
	ret nz			; $7002

	; Increment angle offset for children
	ld a,(wFrameCounter)		; $7003
	and $03			; $7006
	jr nz,++		; $7008
	ld e,Enemy.var3b		; $700a
	ld a,(de)		; $700c
	inc a			; $700d
	and $1f			; $700e
	ld (de),a		; $7010
++
	; Check that all children are in formation
	inc c			; $7011
	jr nz,@notInFormation	; $7012

	call _ecom_decCounter2		; $7014
	ret nz			; $7017
	ld (hl),180		; $7018

	; Signal children to begin moving to new distance away from eyesoar
	ld l,Enemy.var39		; $701a
	set 2,(hl)		; $701c
	ld l,Enemy.var3a		; $701e
	ld (hl),$f0		; $7020

	; Choose new distance away
	ld e,Enemy.var38		; $7022
	ld a,(de)		; $7024
	inc a			; $7025
	and $07			; $7026
	ld b,a			; $7028
	ld hl,distancesFromEyesoar		; $7029
	rst_addAToHl			; $702c
	ld a,(hl)		; $702d
	or b			; $702e
	ld (de),a		; $702f
	ret			; $7030

@notInFormation:
	ld e,Enemy.var39		; $7031
	ld a,(de)		; $7033
	res 2,a			; $7034
	ld (de),a		; $7036
	ret			; $7037

; Distances away from Eyesoar for the children
distancesFromEyesoar:
	.db $18 $28 $30 $20 $30 $18 $28 $20



_eyesoar_dead:
	ld e,Enemy.collisionType		; $7040
	ld a,(de)		; $7042
	or a			; $7043
	jr z,@doneKillingChildren	; $7044

	ld e,Enemy.var30		; $7046
@killNextChild:
	ld a,(de)		; $7048
	ld h,a			; $7049
	ld l,e			; $704a
	call _ecom_killObjectH		; $704b
	inc e			; $704e
	ld a,e			; $704f
	cp Enemy.var36			; $7050
	jr c,@killNextChild	; $7052

@doneKillingChildren:
	jp _enemyBoss_dead		; $7054


;;
; Chooses an angle which roughly goes toward the center of the room, plus a small, random
; angle offset.
; @addr{7057}
_eyesoar_chooseNewAngle:
	; Get random angle offset in 'c'
	call getRandomNumber_noPreserveVars		; $7057
	and $0f			; $705a
	cp $09			; $705c
	jr nc,_eyesoar_chooseNewAngle	; $705e

	ld c,a			; $7060
	ld b,$00		; $7061
	ld e,Enemy.yh		; $7063
	ld a,(de)		; $7065
	cp (LARGE_ROOM_HEIGHT/2)<<4 + 8			; $7066
	jr c,+			; $7068
	inc b			; $706a
+
	ld e,Enemy.xh		; $706b
	ld a,(de)		; $706d
	cp (LARGE_ROOM_WIDTH/2)<<4 + 8			; $706e
	jr c,+			; $7070
	set 1,b			; $7072
+
	ld a,b			; $7074
	ld hl,@angleVals		; $7075
	rst_addAToHl			; $7078
	ld a,(hl)		; $7079
	add c			; $707a
	and $1f			; $707b
	ld e,Enemy.angle		; $707d
	ld (de),a		; $707f
	ret			; $7080

@angleVals:
	.db $08 $00 $10 $18


; ==============================================================================
; ENEMYID_SMOG
;
; Variables:
;   var03: Phase of fight (0-3)
;   counter2: Stops movement temporarily (when sword collision occurs)
;   var30: "Adjacent walls bitset" (bitset of solid walls around smog, similar to the
;          variable used for special objects)
;   var31: Position of the tile it's "hugging"
;   var32: Number of frames to wait for a wall before disappearing and respawning
;   var33: Original value of "direction" (for subid 2 respawning)
;   var34/var35: Original Y/X position (for subid 2 respawning)
;   var36: Counter until "fire projectile" animation will begin
; ==============================================================================
enemyCode7c:
	jr z,@normalStatus	; $7085
	sub ENEMYSTATUS_NO_HEALTH			; $7087
	ret c			; $7089
	jr nz,@normalStatus	; $708a
	jp _enemyBoss_dead		; $708c

@normalStatus:
	ld e,Enemy.state		; $708f
	ld a,(de)		; $7091
	rst_jumpTable			; $7092
	.dw _smog_state_uninitialized
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state_stub
	.dw _smog_state8


_smog_state_uninitialized:
	ld e,Enemy.subid		; $70a5
	ld a,(de)		; $70a7
	and $0f			; $70a8
	rst_jumpTable			; $70aa
	.dw @subid0Init
	.dw @subid1Init
	.dw @subid2Init
	.dw @subid3Init
	.dw @subid4Init
	.dw @subid5Init
	.dw @subid6Init

@subid0Init:
	ld bc,TX_2f26		; $70b9
	call showText		; $70bc
	ld e,Enemy.counter2		; $70bf
	ld a,60		; $70c1
	ld (de),a		; $70c3
	ld a,$04		; $70c4
	jr @setAnimationAndCommonInit		; $70c6

@subid1Init:
	ld e,Enemy.counter2		; $70c8
	ld a,120		; $70ca
	ld (de),a		; $70cc
	ld a,$00		; $70cd
	jr @setAnimationAndCommonInit		; $70cf

@subid2Init:
	call _enemyBoss_beginBoss		; $70d1

	ld h,d			; $70d4
	ld e,Enemy.direction		; $70d5
	ld l,Enemy.var33		; $70d7
	ld a,(de)		; $70d9
	ldi (hl),a		; $70da

	ld e,Enemy.yh		; $70db
	ld a,(de)		; $70dd
	ldi (hl),a		; $70de
	ld e,Enemy.xh		; $70df
	ld a,(de)		; $70e1
	ld (hl),a		; $70e2

	ld a,$04		; $70e3
	call @initCollisions		; $70e5
	ld a,$00		; $70e8
	jr @setAnimationAndCommonInit		; $70ea

@subid3Init:
	call _ecom_decCounter2		; $70ec

	ld l,Enemy.collisionType		; $70ef
	res 7,(hl)		; $70f1
	ret nz			; $70f3
	set 7,(hl)		; $70f4

	ld a,(wNumEnemies)		; $70f6
	cp $02			; $70f9
	jr z,@subid4Init	; $70fb

	; BUG?
	ld e,Interaction.counter2		; $70fd
	ld a,60		; $70ff
	ld (de),a		; $7101
	ld a,$06		; $7102
	call @initCollisions		; $7104

	ld a,$02		; $7107
	jr @setAnimationAndCommonInit		; $7109

@subid4Init:
	ld a,$04		; $710b
	ld (de),a ; [subid] = 4

	ld a,TILEINDEX_DUNGEON_a3		; $710e
	ld c,$11		; $7110
	call setTile		; $7112

	ld a,$04		; $7115

@setAnimationAndCommonInit:
	call enemySetAnimation		; $7117
	call _smog_setCounterToFireProjectile		; $711a
	ld e,Enemy.subid		; $711d
	ld a,(de)		; $711f
	and $0f			; $7120
	ld hl,@subidSpeedTable		; $7122
	rst_addAToHl			; $7125
	ld a,(hl)		; $7126
	jp _ecom_setSpeedAndState8AndVisible		; $7127

@subid5Init:
@subid6Init:
	ld a,ENEMYID_SMOG		; $712a
	ld b,$00		; $712c
	call _enemyBoss_initializeRoom		; $712e
	call _ecom_setSpeedAndState8		; $7131
	ld l,Enemy.collisionType		; $7134
	res 7,(hl)		; $7136
	ret			; $7138

;;
; @param	a	Collision radius
; @addr{7139}
@initCollisions:
	call objectSetCollideRadius		; $7139
	ld l,Enemy.enemyCollisionMode		; $713c
	ld a,ENEMYCOLLISION_PROJECTILE_WITH_RING_MOD		; $713e
	ld (hl),a		; $7140
	ret			; $7141

@subidSpeedTable:
	.db SPEED_00
	.db SPEED_00
	.db SPEED_e0
	.db SPEED_80
	.db SPEED_40


_smog_state_stub:
	ret			; $7147


_smog_state8:
	ld e,Enemy.subid		; $7148
	ld a,(de)		; $714a
	and $0f			; $714b
	rst_jumpTable			; $714d
	.dw _smog_state8_subid0
	.dw _smog_state8_subid1
	.dw _smog_state8_subid2
	.dw _smog_state8_subid3
	.dw _smog_state8_subid4
	.dw _smog_state8_subid5
	.dw _smog_deleteSelf

; Splitting into two?
_smog_state8_subid0:
	call retIfTextIsActive		; $715c
	call enemyAnimate		; $715f
	call _ecom_decCounter2		; $7162
	ret nz			; $7165

	call getFreeEnemySlot		; $7166
	ld (hl),ENEMYID_SMOG		; $7169
	inc l			; $716b
	ld (hl),$01 ; [child.subid]
	ld bc,$00f0		; $716e
	call objectCopyPositionWithOffset		; $7171

	call getFreeEnemySlot		; $7174
	ld (hl),ENEMYID_SMOG		; $7177
	inc l			; $7179
	ld (hl),$01 ; [child.subid]
	ld bc,$0010		; $717c
	call objectCopyPositionWithOffset		; $717f
	jr _smog_deleteSelf		; $7182

_smog_state8_subid1:
	call enemyAnimate		; $7184
	call _ecom_decCounter2		; $7187
	ret nz			; $718a

_smog_deleteSelf:
	call objectCreatePuff		; $718b
	call decNumEnemies		; $718e
	jp enemyDelete		; $7191


; Small or medium-sized smog
_smog_state8_subid2:
_smog_state8_subid3:
	ld e,Enemy.var2a		; $7194
	ld a,(de)		; $7196
	bit 7,a			; $7197
	jr z,@noCollision	; $7199

	and $7f			; $719b
	cp ITEMCOLLISION_L1_SWORD			; $719d
	jr c,@noCollision	; $719f
	cp ITEMCOLLISION_SWORD_HELD+1			; $71a1
	jr nc,@noCollision	; $71a3

	; If sword collision occurred, stop movement briefly?
	ld e,Enemy.counter2		; $71a5
	ld a,30		; $71a7
	ld (de),a		; $71a9

@noCollision:
	call _ecom_decCounter2		; $71aa
	jp nz,enemyAnimate		; $71ad

	call getThisRoomFlags		; $71b0
	bit ROOMFLAG_BIT_40,a			; $71b3
	jr nz,_smog_deleteSelf	; $71b5

	call enemyAnimate		; $71b7

	; If animParameter is nonzero, shoot projectile
	ld e,Enemy.animParameter		; $71ba
	ld a,(de)		; $71bc
	or a			; $71bd
	jr z,@doneShootingProjectile	; $71be

	ld e,Enemy.subid		; $71c0
	ld a,(de)		; $71c2
	and $0f			; $71c3
	add a			; $71c5
	add -4			; $71c6
	call enemySetAnimation		; $71c8
	call _smog_setCounterToFireProjectile		; $71cb
	ld b,PARTID_SMOG_PROJECTILE		; $71ce
	call _ecom_spawnProjectile		; $71d0
	call objectCopyPosition		; $71d3

@doneShootingProjectile:
	call _smog_decCounterToFireProjectile		; $71d6
	jr z,@runSubstate	; $71d9

	ld e,Enemy.subid		; $71db
	ld a,(de)		; $71dd
	and $0f			; $71de
	add a			; $71e0
	add -3			; $71e1
	call enemySetAnimation		; $71e3

@runSubstate:
	ld e,Enemy.state2		; $71e6
	ld a,(de)		; $71e8
	rst_jumpTable			; $71e9
	.dw @substate0
	.dw @substate1
	.dw @substate2

; Just spawned, or need to redetermine what direction to move in based on surrounding
; walls
@substate0:
	call _smog_applySpeed		; $71f0
	call _smog_checkHuggingWall		; $71f3
	jr nz,@checkHitWall	; $71f6

	ld l,Enemy.var32		; $71f8
	ld (hl),$10		; $71fa

@gotoState1:
	; Update direction based on angle
	ld e,Enemy.angle		; $71fc
	ld a,(de)		; $71fe
	add a			; $71ff
	swap a			; $7200
	dec e			; $7202
	ld (de),a		; $7203

	; Go to substate 1
	ld e,Enemy.state2		; $7204
	ld a,$01		; $7206
	ld (de),a		; $7208
	jp _smog_applySpeed		; $7209

@checkHitWall:
	call _smog_checkHitWall		; $720c
	jr nz,@hitWall	; $720f
	ret			; $7211

@substate1:
	call _smog_applySpeed		; $7212
	call _smog_checkHuggingWall		; $7215
	jr nz,@notHuggingWall	; $7218

	; The wall being hugged disappeared.

	; Check if this is a small or medium smog.
	ld l,Enemy.subid		; $721a
	ld a,(hl)		; $721c
	and $0f			; $721d
	cp $02			; $721f
	jr nz,@mediumSmog	; $7221

	; It's a small smog. Decrement counter before respawning
	ld l,Enemy.var32		; $7223
	dec (hl)		; $7225
	jr nz,@gotoState1	; $7226

	; Respawn
	call objectCreatePuff		; $7228
	ld h,d			; $722b
	ld l,Enemy.var33		; $722c
	ld e,Enemy.direction		; $722e
	ldi a,(hl)		; $7230
	ld (de),a		; $7231
	ld e,Enemy.yh		; $7232
	ldi a,(hl)		; $7234
	ld (de),a		; $7235
	ld e,Enemy.xh		; $7236
	ld a,(hl)		; $7238
	ld (de),a		; $7239
	call objectCreatePuff		; $723a
	jr @notHuggingWall		; $723d

@mediumSmog:
	; Just keep moving forward until we hit a wall
	call _smog_checkHitWall		; $723f
	ret z			; $7242

@hitWall:
	; Rotate direction clockwise or counterclockwise
	ld b,$01		; $7243
	ld e,Enemy.subid		; $7245
	ld a,(de)		; $7247
	bit 7,a			; $7248
	jr z,+			; $724a
	ld b,$ff		; $724c
+
	ld e,Enemy.direction		; $724e
	ld a,(de)		; $7250
	sub b			; $7251
	and $03			; $7252
	ld (de),a		; $7254
	ld e,Enemy.state2		; $7255
	ld a,$02		; $7257
	ld (de),a		; $7259
	ret			; $725a

; Moving normally along wall
@substate2:
	call _smog_updateAdjacentWallsBitset		; $725b
	call _smog_checkHitWall		; $725e
	jr nz,@hitWall	; $7261

@notHuggingWall:
	ld e,Enemy.state2		; $7263
	xor a			; $7265
	ld (de),a		; $7266
	jp _smog_applySpeed		; $7267


; Large smog (can be attacked)
_smog_state8_subid4:
	ld e,Enemy.var2a		; $726a
	ld a,(de)		; $726c
	cp $80|ITEMCOLLISION_ELECTRIC_SHOCK			; $726d
	jr nz,++		; $726f

	; Link attacked the boss and got shocked.
	ld a,$03		; $7271
	ld e,Enemy.state2		; $7273
	ld (de),a		; $7275
	ld a,70		; $7276
	ld e,Enemy.counter2		; $7278
	ld (de),a		; $727a
++
	call enemyAnimate		; $727b
	ld e,Enemy.state2		; $727e
	ld a,(de)		; $7280
	rst_jumpTable			; $7281
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,$01		; $728a
	ld (de),a ; [state2] = 1
	dec a			; $728d
	ld e,Enemy.speed		; $728e
	ld (de),a		; $7290

	call _ecom_updateAngleTowardTarget		; $7291

	ld e,Enemy.counter1		; $7294
	ld a,20		; $7296
	ld (de),a		; $7298

; Speeding up
@substate1:
	call @func_72b2		; $7299
	ret nz			; $729c

	add SPEED_20			; $729d
	ld (hl),a		; $729f
	cp SPEED_c0			; $72a0
	ret nz			; $72a2

	jp _ecom_incState2		; $72a3

; Slowing down
@substate2:
	call @func_72b2		; $72a6
	ret nz			; $72a9

	sub SPEED_20			; $72aa
	ld (hl),a		; $72ac
	ret nz			; $72ad

	ld l,Enemy.state2		; $72ae
	ld (hl),a ; [state2] = 0
	ret			; $72b1

;;
; @param[out]	zflag	z if counter1 reached 0 (should update speed)
; @addr{72b2}
@func_72b2:
	ld e,Enemy.animParameter		; $72b2
	ld a,(de)		; $72b4
	or a			; $72b5
	jr z,@parameter0	; $72b6

	dec a			; $72b8
	jr nz,@parameter1	; $72b9

	ld a,$04		; $72bb
	call enemySetAnimation		; $72bd
	jp _smog_setCounterToFireProjectile		; $72c0

@parameter1:
	ld b,PARTID_SMOG_PROJECTILE		; $72c3
	call _ecom_spawnProjectile		; $72c5
	ld l,Part.subid		; $72c8
	inc (hl)		; $72ca
	ld bc,$0800		; $72cb
	jp objectCopyPositionWithOffset		; $72ce

@parameter0:
	call _smog_decCounterToFireProjectile		; $72d1
	jr z,++			; $72d4
	ld a,$05		; $72d6
	call enemySetAnimation		; $72d8
++
	call objectApplySpeed		; $72db
	call _ecom_bounceOffScreenBoundary		; $72de
	call _ecom_decCounter1		; $72e1
	ret nz			; $72e4

	ld (hl),20		; $72e5
	ld l,Enemy.speed		; $72e7
	ld a,(hl)		; $72e9
	ret			; $72ea

; Stop while Link is shocked
@substate3:
	call _ecom_decCounter2		; $72eb
	ret nz			; $72ee
	xor a			; $72ef
	ld (de),a		; $72f0
	ld l,Enemy.collisionType		; $72f1
	set 7,(hl)		; $72f3
	ret			; $72f5


_smog_state8_subid5:
	ret			; $72f6


;;
; @param[out]	zflag	nz if hit a wall
; @addr{72f7}
_smog_checkHitWall:
	ld e,Enemy.direction		; $72f7
	ld a,(de)		; $72f9
	swap a			; $72fa
	rrca			; $72fc
	inc e			; $72fd
	ld (de),a		; $72fe
	jr _smog_checkAdjacentWallsBitset		; $72ff

_smog_positionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @param[out]	zflag	nz if hugging a wall
; @addr{7309}
_smog_checkHuggingWall:
	ld b,$ff		; $7309
	ld e,Enemy.subid		; $730b
	ld a,(de)		; $730d
	bit 7,a			; $730e
	jr z,+			; $7310
	ld b,$01		; $7312
+
	; Get direction clockwise or counterclockwise from current direction
	ld e,Enemy.direction		; $7314
	ld a,(de)		; $7316
	sub b			; $7317
	and $03			; $7318
	ld c,a			; $731a

	; Set "angle" value perpendicular to "direction" value
	swap a			; $731b
	rrca			; $731d
	inc e			; $731e
	ld (de),a		; $731f

	; Get position offset in direction smog is moving in
	ld a,c			; $7320
	ld hl,_smog_positionOffsets		; $7321
	rst_addDoubleIndex			; $7324
	ldi a,(hl)		; $7325
	ld c,(hl)		; $7326
	ld b,a			; $7327

	; Put the position of the next tile in var31
	call objectGetRelativeTile		; $7328
	ld h,>wRoomCollisions		; $732b
	ld e,Enemy.var31		; $732d
	ld a,l			; $732f
	and $0f			; $7330
	ld c,a			; $7332
	ld a,l			; $7333
	swap a			; $7334
	and $0f			; $7336
	add c			; $7338
	ld (de),a		; $7339

;;
; Checks if there is a wall in the direction of the "angle" variable. (Angle could be
; facing forward, or in the direction of the wall being hugged, depending when this is
; called.)
;
; @param[out]	zflag	nz if a wall exists
; @addr{733a}
_smog_checkAdjacentWallsBitset:
	ld h,d			; $733a
	ld l,Enemy.angle		; $733b
	ld a,(hl)		; $733d
	bit 3,a			; $733e
	jr z,@upOrDown	; $7340

@leftOrRight:
	ld l,Enemy.var30		; $7342
	ld b,(hl)		; $7344
	bit 4,a			; $7345
	ld a,$03		; $7347
	jr z,+			; $7349
	ld a,$0c		; $734b
+
	and b			; $734d
	ret			; $734e

@upOrDown:
	ld l,Enemy.var30		; $734f
	ld c,(hl)		; $7351
	bit 4,a			; $7352
	ld a,$30		; $7354
	jr nz,+		; $7356
	ld a,$c0		; $7358
+
	and c			; $735a
	ret			; $735b

;;
; Applies speed and updates "adjacentWallsBitset"
; @addr{735c}
_smog_applySpeed:
	; Update angle based on direction
	ld e,Enemy.direction		; $735c
	ld a,(de)		; $735e
	swap a			; $735f
	rrca			; $7361
	inc e			; $7362
	ld (de),a		; $7363
	call objectApplySpeed		; $7364

_smog_updateAdjacentWallsBitset:
	; Clear collision value of wall being hugged?
	ld e,Enemy.var30		; $7367
	xor a			; $7369
	ld (de),a		; $736a

	; Update each bit of adjacent walls bitset
	ld h,d			; $736b
	ld l,Enemy.yh		; $736c
	ld b,(hl)		; $736e
	ld l,Enemy.xh		; $736f
	ld c,(hl)		; $7371
	ld a,$01		; $7372
	ldh (<hFF8B),a	; $7374
	ld hl,@offsetTable		; $7376
@loop:
	ldi a,(hl)		; $7379
	add b			; $737a
	ld b,a			; $737b
	ldi a,(hl)		; $737c
	add c			; $737d
	ld c,a			; $737e
	push hl			; $737f
	call getTileAtPosition		; $7380
	ld h,>wRoomCollisions		; $7383
	ld a,(hl)		; $7385
	or a			; $7386
	jr z,+			; $7387
	scf			; $7389
+
	pop hl			; $738a
	ldh a,(<hFF8B)	; $738b
	rla			; $738d
	ldh (<hFF8B),a	; $738e
	jr nc,@loop	; $7390

	ld e,Enemy.var30		; $7392
	ld (de),a		; $7394
	ret			; $7395

@offsetTable:
	.db $f7 $f8
	.db $00 $0f
	.db $11 $f1
	.db $00 $0f
	.db $f0 $f0
	.db $0f $00
	.db $f1 $11
	.db $0f $00

;;
; @param[out]	zflag	nz if smog should begin "firing projectile" animation
; @addr{73a6}
_smog_decCounterToFireProjectile:
	ld e,Enemy.var36		; $73a6
	ld a,(de)		; $73a8
	or a			; $73a9
	ret z			; $73aa

	dec a			; $73ab
	ld (de),a		; $73ac
	jr nz,@zflag		; $73ad

	or d			; $73af
	ret			; $73b0
@zflag:
	xor a			; $73b1
	ret			; $73b2


;;
; For given values of subid and var03, this reads one of four randomly chosen values and
; puts that value into var36 (counter until next projectile is fired).
; @addr{73b3}
_smog_setCounterToFireProjectile:
	ld e,Enemy.subid		; $73b3
	ld a,(de)		; $73b5
	and $0f			; $73b6
	sub $02			; $73b8
	ld hl,@table		; $73ba
	rst_addAToHl			; $73bd
	ld a,(hl)		; $73be
	rst_addAToHl			; $73bf
	inc e			; $73c0
	ld a,(de) ; [var03]
	rst_addAToHl			; $73c2
	ld a,(hl)		; $73c3
	rst_addAToHl			; $73c4
	call getRandomNumber		; $73c5
	and $03			; $73c8
	rst_addAToHl			; $73ca
	ld a,(hl)		; $73cb
	ld e,Enemy.var36		; $73cc
	ld (de),a		; $73ce
	ret			; $73cf

@table:
	.db @subid2 - CADDR
	.db @subid3 - CADDR
	.db @subid4 - CADDR

@subid2:
	.db @subid2_0 - CADDR
	.db @subid2_1 - CADDR
	.db @subid2_2 - CADDR
	.db @subid2_3 - CADDR
@subid3:
	.db @subid3_0 - CADDR
	.db @subid3_1 - CADDR
	.db @subid3_2 - CADDR
	.db @subid3_3 - CADDR
@subid4:
	.db @subid4_0 - CADDR
	.db @subid4_1 - CADDR
	.db @subid4_2 - CADDR
	.db @subid4_3 - CADDR

@subid2_0:
	.db $78 $f0 $ff $ff
@subid2_1:
	.db $78 $78 $b4 $f0
@subid2_2:
	.db $50 $50 $64 $78
@subid2_3:
	.db $32 $32 $3c $50

@subid3_0:
	.db $00 $00 $00 $00
@subid3_1:
	.db $50 $78 $96 $b4
@subid3_2:
	.db $32 $50 $96 $b4
@subid3_3:
	.db $32 $50 $64 $96

@subid4_0:
	.db $5a $78 $64 $96
@subid4_1:
	.db $1e $28 $32 $3c
@subid4_2:
	.db $14 $1e $32 $3c
@subid4_3:
	.db $14 $1e $28 $32


; ==============================================================================
; ENEMYID_OCTOGON
;
; Variables:
;   var03: Where it actually is? (0 = above water, 1 = below water)
;   counter2: Counter until it moves above or below the water?
;   relatedObj1: Reference to other instance of ENEMYID_OCTOGON?
;   var30: Index in "target position list"?
;   var31/var32: Target position to move to
;   var33/var34: Original Y/X position when this screen was entered
;   var35: Counter for animation purposes?
;   var36: Counter which, when 0 is reached, invokes a change of state (ie. fire at link
;          instead of moving around)
;   var37: Health value from when octogon appeared here (used to decide when to surface or
;          not)
; ==============================================================================
enemyCode7d:
	jr z,@normalStatus	; $740f
	sub ENEMYSTATUS_NO_HEALTH			; $7411
	ret c			; $7413
	jr nz,@justHit	; $7414

	; Dead
	ld e,Enemy.subid		; $7416
	ld a,(de)		; $7418
	cp $02			; $7419
	jp z,enemyDelete		; $741b

	ld e,Enemy.collisionType		; $741e
	ld a,(de)		; $7420
	or a			; $7421
	call nz,_ecom_killRelatedObj1		; $7422
	jp _enemyBoss_dead		; $7425

@justHit:
	ld a,Object.invincibilityCounter		; $7428
	call objectGetRelatedObject1Var		; $742a
	ld e,l			; $742d
	ld a,(de)		; $742e
	ld (hl),a		; $742f

	ld e,Enemy.subid		; $7430
	ld a,(de)		; $7432
	cp $02			; $7433
	jr z,@normalStatus	; $7435

	; Check if enough damage has been dealt to rise above or below the water
	ld h,d			; $7437
	ld l,Enemy.health		; $7438
	ld e,Enemy.var37		; $743a
	ld a,(de)		; $743c
	sub (hl)		; $743d
	cp $0a			; $743e
	jr c,+			; $7440
	ld l,Enemy.counter2		; $7442
	ld (hl),$01		; $7444
+
	ld e,Enemy.health		; $7446
	ld a,(de)		; $7448
	or a			; $7449
	jr nz,@normalStatus	; $744a

	; Health just reached 0
	ld hl,wGroup5Flags+$2d		; $744c
	set 7,(hl)		; $744f
	ld l,$36		; $7451
	set 7,(hl)		; $7453
	ld a,MUS_BOSS		; $7455
	ld (wActiveMusic),a		; $7457
	ret			; $745a

@normalStatus:
	call @doJumpTable		; $745b

	ld h,d			; $745e
	ld l,Enemy.var34		; $745f
	ld e,Enemy.xh		; $7461
	ld a,(de)		; $7463
	ldd (hl),a		; $7464
	ld e,Enemy.yh		; $7465
	ld a,(de)		; $7467
	ld (hl),a		; $7468
	ld l,Enemy.direction		; $7469
	ld a,(hl)		; $746b
	cp $10			; $746c
	jr c,+			; $746e
	ld a,$08		; $7470
+
	and $0c			; $7472
	rrca			; $7474
	ld hl,@offsetData		; $7475
	rst_addAToHl			; $7478

	; Add offsets to Y/X position
	ld a,(de)		; $7479
	add (hl)		; $747a
	ld (de),a		; $747b
	ld e,Enemy.xh		; $747c
	inc hl			; $747e
	ld a,(de)		; $747f
	add (hl)		; $7480
	ld (de),a		; $7481

	; Store some persistent variables?

	ld hl,wTmpcfc0.octogonBoss.var03		; $7482
	ld e,Enemy.var03		; $7485
	ld a,(de)		; $7487
	ldi (hl),a		; $7488

	ld e,Enemy.direction		; $7489
	ld a,(de)		; $748b
	ldi (hl),a ; [wTmpcfc0.octogonBoss.direction]

	ld e,Enemy.health		; $748d
	ld a,(de)		; $748f
	ldi (hl),a ; [wTmpcfc0.octogonBoss.health]

	ld e,Enemy.var33		; $7491
	ld a,(de)		; $7493
	ldi (hl),a ; [wTmpcfc0.octogonBoss.var33]
	inc e			; $7495
	ld a,(de) ; [var34]
	ldi (hl),a ; [wTmpcfc0.octogonBoss.var34]

	ld e,Enemy.var30		; $7498
	ld a,(de)		; $749a
	ld (hl),a ; [wTmpcfc0.octogonBoss.var30]
	ret			; $749c

@offsetData:
	.db $f8 $00
	.db $00 $08
	.db $08 $00
	.db $00 $f8

@doJumpTable:
	ld e,Enemy.state	; $74a5
	ld a,(de)		; $74a7
	cp $08			; $74a8
	ld e,Enemy.subid		; $74aa
	jr c,@state8OrLess	; $74ac

	ld a,(de)		; $74ae
	rst_jumpTable			; $74af
	.dw _octogon_subid0
	.dw _octogon_subid1
	.dw _octogon_subid2


@state8OrLess:
	rst_jumpTable			; $74b6
	.dw _octogon_state_uninitialized
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub
	.dw _octogon_state_stub


_octogon_state_uninitialized:
	ld e,Enemy.subid		; $74c7
	ld a,(de)		; $74c9
	cp $02			; $74ca
	jr nz,@notSubid2	; $74cc

	ld e,Enemy.enemyCollisionMode		; $74ce
	ld a,ENEMYCOLLISION_OCTOGON_SHELL		; $74d0
	ld (de),a		; $74d2
	jp _ecom_setSpeedAndState8		; $74d3

@notSubid2:
	ld a,ENEMYID_OCTOGON		; $74d6
	ld (wEnemyIDToLoadExtraGfx),a		; $74d8
	ld a,PALH_88		; $74db
	call loadPaletteHeader		; $74dd

	ld hl,wTmpcfc0.octogonBoss.loadedExtraGfx		; $74e0
	ld a,(hl)		; $74e3
	or a			; $74e4
	jr nz,++		; $74e5
	inc (hl)		; $74e7
	call _enemyBoss_initializeRoomWithoutExtraGfx		; $74e8
++
	; Create "child" with subid 2? They will reference each other with relatedObj2.
	call getFreeEnemySlot_uncounted		; $74eb
	ret nz			; $74ee
	ld (hl),ENEMYID_OCTOGON		; $74ef
	inc l			; $74f1
	ld (hl),$02 ; [child.subid]
	ld l,Enemy.relatedObj1		; $74f4
	ld e,l			; $74f6
	ld a,Enemy.start		; $74f7
	ld (de),a		; $74f9
	ldi (hl),a		; $74fa
	inc e			; $74fb
	ld a,h			; $74fc
	ld (de),a		; $74fd
	ld (hl),d		; $74fe

	ld a,SPEED_100		; $74ff
	call _ecom_setSpeedAndState8		; $7501

	ld l,Enemy.var35		; $7504
	ld (hl),$0c ; [this.var35]
	inc l			; $7508
	ld (hl),120 ; [var36]

	ld l,Enemy.subid		; $750b
	ld a,(hl)		; $750d
	add a			; $750e
	ld b,a			; $750f
	call objectSetVisible83		; $7510

	; Load persistent variables

	ld hl,wTmpcfc0.octogonBoss.var30		; $7513
	ld e,Enemy.var30		; $7516
	ldd a,(hl)		; $7518
	ld (de),a		; $7519
	ld e,Enemy.xh		; $751a
	ldd a,(hl)		; $751c
	ld (de),a		; $751d
	ld e,Enemy.yh		; $751e
	ldd a,(hl)		; $7520
	ld (de),a		; $7521
	ld e,Enemy.health		; $7522
	ldd a,(hl)		; $7524
	ld (de),a		; $7525
	ld e,Enemy.var37		; $7526
	ld (de),a		; $7528
	ld e,Enemy.direction		; $7529
	ldd a,(hl)		; $752b
	ld (de),a		; $752c
	ld e,Enemy.var03		; $752d
	ld a,(hl)		; $752f
	ld (de),a		; $7530

	add b			; $7531
	rst_jumpTable			; $7532
	.dw @subid0_0
	.dw @subid0_1
	.dw @subid1_0
	.dw @subid1_1

@subid0_0:
	call _octogon_fixPositionAboveWater		; $753b

	ld h,d			; $753e
	ld l,Enemy.counter2		; $753f
	ld (hl),120		; $7541

	ld l,Enemy.var30		; $7543
	ld a,(hl)		; $7545
	inc a			; $7546
	jp z,_octogon_chooseRandomTargetPosition		; $7547

	call _octogon_loadTargetPosition		; $754a
	ret z			; $754d
	dec hl			; $754e
	dec hl			; $754f
	dec hl			; $7550
	ld a,(hl)		; $7551
	ld e,Enemy.direction		; $7552
	ld (de),a		; $7554
	jp enemySetAnimation		; $7555

@subid0_1:
	call _octogon_fixPositionAboveWater		; $7558
	jp _octogon_loadNormalSubmergedAnimation		; $755b

@subid1_0:
	ld h,d			; $755e
	ld l,Enemy.collisionType		; $755f
	res 7,(hl)		; $7561

	; Delete child object (subid 2)
	ld a,Object.start		; $7563
	call objectGetRelatedObject1Var		; $7565
	ld b,$40		; $7568
	call clearMemory		; $756a

	jp objectSetInvisible		; $756d

@subid1_1:
	ld a,$01		; $7570
	ld (wTmpcfc0.octogonBoss.posNeedsFixing),a		; $7572

	ld h,d			; $7575
	ld l,Enemy.oamFlagsBackup		; $7576
	ld a,$06		; $7578
	ldi (hl),a		; $757a
	ld (hl),a		; $757b

	ld l,Enemy.counter1		; $757c
	ld (hl),90		; $757e
	inc l			; $7580
	ld (hl),150 ; [counter2]

	ld l,Enemy.var31		; $7583
	ldh a,(<hEnemyTargetY)	; $7585
	ldi (hl),a		; $7587
	ldh a,(<hEnemyTargetX)	; $7588
	ld (hl),a		; $758a

	call _ecom_updateAngleTowardTarget		; $758b
	add $04			; $758e
	and $18			; $7590
	rrca			; $7592
	ld e,Enemy.direction		; $7593
	ld (de),a		; $7595
	call enemySetAnimation		; $7596

	call getFreeInteractionSlot		; $7599
	ret nz			; $759c
	ld (hl),INTERACID_BUBBLE		; $759d
	inc l			; $759f
	inc (hl) ; [bubble.subid] = 1
	ld l,Interaction.relatedObj1		; $75a1
	ld a,Enemy.start		; $75a3
	ldi (hl),a		; $75a5
	ld (hl),d		; $75a6
	ret			; $75a7


_octogon_state_stub:
	ret			; $75a8


_octogon_subid0:
	; Initialize Y/X position
	ld h,d			; $75a9
	ld l,Enemy.var33		; $75aa
	ld e,Enemy.yh		; $75ac
	ldi a,(hl)		; $75ae
	ld (de),a		; $75af
	ld e,Enemy.xh		; $75b0
	ld a,(hl)		; $75b2
	ld (de),a		; $75b3

	; Check if submerged
	ld e,Enemy.var03		; $75b4
	ld a,(de)		; $75b6
	or a			; $75b7
	ld e,Enemy.state		; $75b8
	ld a,(de)		; $75ba
	jp nz,_octogon_subid0BelowWater		; $75bb

	sub $08			; $75be
	rst_jumpTable			; $75c0
	.dw _octogon_subid0AboveWater_state8
	.dw _octogon_subid0AboveWater_state9
	.dw _octogon_subid0AboveWater_stateA
	.dw _octogon_subid0AboveWater_stateB
	.dw _octogon_subid0AboveWater_stateC
	.dw _octogon_subid0AboveWater_stateD
	.dw _octogon_subid0AboveWater_stateE
	.dw _octogon_subid0AboveWater_stateF
	.dw _octogon_subid0AboveWater_state10
	.dw _octogon_subid0AboveWater_state11


_octogon_subid0AboveWater_state8:
	; Wait for shutters to close
	ld a,($cc93)		; $75d5
	or a			; $75d8
	ret nz			; $75d9

	ld h,d			; $75da
	ld l,e			; $75db
	inc (hl) ; [state] = 9

	; Initialize music if necessary
	ld hl,wActiveMusic		; $75dd
	ld a,(hl)		; $75e0
	or a			; $75e1
	ret z			; $75e2
	ld (hl),$00		; $75e3
	ld a,MUS_BOSS		; $75e5
	jp playSound		; $75e7


; Moving normally around the room
_octogon_subid0AboveWater_state9:
	call _octogon_decVar36IfNonzero		; $75ea

	; Submerge into water after set amount of time
	ld a,(wFrameCounter)		; $75ed
	and $03			; $75f0
	jr nz,++		; $75f2
	ld l,Enemy.counter2		; $75f4
	dec (hl)		; $75f6
	jp z,_octogon_subid0_submergeIntoWater		; $75f7
++
	; Check if lined up to fire at Link.
	; BUG: Should set 'b', not 'c'? (b happens to be $0f here, so it works out ok.)
	ld c,$08		; $75fa
	call objectCheckCenteredWithLink		; $75fc
	jp nc,_octogon_updateMovementAndAnimation		; $75ff

	; If enough time has passed, begin firing at Link.
	ld h,d			; $7602
	ld l,Enemy.var36		; $7603
	ld a,(hl)		; $7605
	or a			; $7606
	jp nz,_octogon_updateMovementAndAnimation		; $7607

	ld (hl),120 ; [var36]

	; Begin turning toward Link to fire.
	call objectGetAngleTowardEnemyTarget		; $760c
	add $14			; $760f
	and $18			; $7611
	ld b,a			; $7613
	ld e,Enemy.direction		; $7614
	ld a,(de)		; $7616
	and $0c			; $7617
	add a			; $7619
	cp b			; $761a
	jp nz,_octogon_updateMovementAndAnimation		; $761b

	ld h,d			; $761e
	ld l,Enemy.state		; $761f
	ld (hl),$0b		; $7621

	ld l,Enemy.counter1		; $7623
	ld (hl),$08		; $7625
	ret			; $7627


_octogon_subid0AboveWater_stateA:
_octogon_subid0_pauseMovement:
	call _ecom_decCounter1		; $7628
	ret nz			; $762b

	ld l,e			; $762c
	dec (hl) ; [state]--

	ld l,Enemy.var30		; $762e
	ld a,(hl)		; $7630
	inc a			; $7631
	ld (hl),a		; $7632

	and $07			; $7633
	jr nz,_octogon_loadTargetPosition	; $7635


;;
; @addr{7637}
_octogon_chooseRandomTargetPosition:
	call getRandomNumber		; $7637
	and $18			; $763a
	ld (hl),a		; $763c

;;
; @param	hl	Pointer to index for a table
; @param[out]	hl	Pointer to some data
; @param[out]	zflag	z if animation changed
; @addr{763d}
_octogon_loadTargetPosition:
	ld a,(hl)		; $763d
	add a			; $763e
	add (hl)		; $763f
	ld hl,@targetPositionList		; $7640
	rst_addAToHl			; $7643
	ld e,Enemy.var31		; $7644
	ldi a,(hl)		; $7646
	ld (de),a		; $7647
	inc e			; $7648
	ldi a,(hl)		; $7649
	ld (de),a ; [var32]
	ld e,Enemy.var03		; $764b
	ld a,(de)		; $764d
	or a			; $764e
	ret nz			; $764f

	ld a,(hl)		; $7650
	bit 7,a			; $7651
	ret nz			; $7653

	ld e,Enemy.direction		; $7654
	ld (de),a		; $7656
	call enemySetAnimation		; $7657
	xor a			; $765a
	ret			; $765b

; data format: target position (2 bytes), animation
@targetPositionList:
	.db $28 $38 $00
	.db $58 $30 $0c
	.db $88 $38 $ff
	.db $88 $78 $08
	.db $88 $b8 $ff
	.db $58 $c0 $04
	.db $28 $b8 $ff
	.db $28 $78 $00

	.db $28 $b8 $00
	.db $58 $c0 $04
	.db $88 $b8 $ff
	.db $88 $78 $08
	.db $88 $38 $ff
	.db $58 $30 $0c
	.db $28 $38 $ff
	.db $28 $78 $00

	.db $28 $38 $00
	.db $58 $30 $0c
	.db $88 $38 $ff
	.db $88 $78 $08
	.db $88 $38 $ff
	.db $58 $30 $0c
	.db $28 $38 $ff
	.db $28 $78 $00

	.db $28 $b8 $00
	.db $58 $c0 $04
	.db $88 $b8 $ff
	.db $88 $78 $08
	.db $88 $b8 $ff
	.db $58 $c0 $04
	.db $28 $b8 $ff
	.db $28 $78 $00


; Turning around to fire projectile (or just after doing so)?
_octogon_subid0AboveWater_stateB:
_octogon_subid0AboveWater_stateF:
	ld b,$06		; $76bc
	jr _octogon_subid0AboveWater_turningAround	; $76be


; Turning around?
_octogon_subid0AboveWater_stateC:
	ld b,$18		; $76c0

_octogon_subid0AboveWater_turningAround:
	call _ecom_decCounter1		; $76c2
	ret nz			; $76c5

	ld (hl),b		; $76c6
	ld l,e			; $76c7
	inc (hl) ; [state]++

	ld l,Enemy.direction		; $76c9
	ld a,(hl)		; $76cb
	add $04			; $76cc
	and $0c			; $76ce
	ld (hl),a		; $76d0
	jp enemySetAnimation		; $76d1


; About to fire projectile?
_octogon_subid0AboveWater_stateD:
	call _ecom_decCounter1		; $76d4
	ret nz			; $76d7

	ld (hl),$08		; $76d8

	ld l,e			; $76da
	inc (hl) ; [state] = $0e

	ld l,Enemy.direction		; $76dc
	ld a,(hl)		; $76de
	add $02			; $76df
	ld (hl),a		; $76e1
	jp enemySetAnimation		; $76e2


; Firing projectile
_octogon_subid0AboveWater_stateE:
	call _ecom_decCounter1		; $76e5
	ret nz			; $76e8

	ld (hl),40		; $76e9
	ld l,e			; $76eb
	inc (hl) ; [state] = $0f
	ld l,Enemy.direction		; $76ed
	inc (hl)		; $76ef
	ld a,(hl)		; $76f0
	call enemySetAnimation		; $76f1
	jp _octogon_fireOctorokProjectile		; $76f4


; Turning around after firing projectile?
_octogon_subid0AboveWater_state10:
	ld b,$0c		; $76f7
	jr _octogon_subid0AboveWater_turningAround		; $76f9


; Delay before resuming normal movement
_octogon_subid0AboveWater_state11:
	call _ecom_decCounter1		; $76fb
	ret nz			; $76fe
	ld l,e			; $76ff
	ld (hl),$09 ; [state]
	ret			; $7702


; Octogon code where octogon itself is below water, and link is above water
_octogon_subid0BelowWater:
	sub $08			; $7703
	rst_jumpTable			; $7705
	.dw _octogon_subid0BelowWater_state8
	.dw _octogon_subid0BelowWater_state9
	.dw _octogon_subid0BelowWater_stateA
	.dw _octogon_subid0BelowWater_stateB
	.dw _octogon_subid0BelowWater_stateC
	.dw _octogon_subid0BelowWater_stateD


; Swimming normally
_octogon_subid0BelowWater_state8:
	call enemyAnimate		; $7712

	; Check whether to play swimming sound
	ld e,Enemy.animParameter		; $7715
	ld a,(de)		; $7717
	or a			; $7718
	jr nz,++		; $7719
	inc a			; $771b
	ld (de),a		; $771c
	ld a,SND_LINK_SWIM		; $771d
	call playSound		; $771f
++
	call _octogon_decVar36IfNonzero		; $7722
	jp nz,_octogon_moveTowardTargetPosition		; $7725

	; Reached target position
	ld (hl),90 ; [var36]
	call getRandomNumber		; $772a
	cp $50			; $772d
	jp nc,_octogon_moveTowardTargetPosition		; $772f

	; Random chance of going to state $0a (firing projectile)
	ld l,Enemy.state		; $7732
	ld (hl),$0a		; $7734
	ld l,Enemy.counter1		; $7736
	ld (hl),60		; $7738
	jr _octogon_loadNormalSubmergedAnimation		; $773a


; Waiting in place before moving again
_octogon_subid0BelowWater_state9:
	call _octogon_subid0_pauseMovement		; $773c
_octogon_animate:
	jp enemyAnimate		; $773f


; Delay before firing projectile
_octogon_subid0BelowWater_stateA:
	call _ecom_decCounter1		; $7742
	jr z,@beginFiring	; $7745

	ld a,(hl)		; $7747
	and $07			; $7748
	ret nz			; $774a
	ld l,Enemy.direction		; $774b
	ld a,(hl)		; $774d
	xor $01			; $774e
	ld (hl),a		; $7750
	jp enemySetAnimation		; $7751

@beginFiring:
	ld (hl),$08		; $7754
	ld l,e			; $7756
	inc (hl) ; [state] = $0b

_octogon_loadNormalSubmergedAnimation:
	ld e,Enemy.direction		; $7758
	ld a,$12		; $775a
	ld (de),a		; $775c
	jp enemySetAnimation		; $775d


; Firing projectile
_octogon_subid0BelowWater_stateB:
	call _ecom_decCounter1		; $7760
	jr z,@fireProjectile	; $7763

	ld a,(hl)		; $7765
	cp $06			; $7766
	ret nz			; $7768

	ld l,Enemy.direction		; $7769
	ld a,$14		; $776b
	ld (hl),a		; $776d
	jp enemySetAnimation		; $776e

@fireProjectile:
	ld (hl),60 ; [counter1]
	ld l,e			; $7773
	inc (hl) ; [state] = $0c
	ld b,PARTID_OCTOGON_DEPTH_CHARGE		; $7775
	call _ecom_spawnProjectile		; $7777
	jr _octogon_loadNormalSubmergedAnimation		; $777a


; Delay before moving again
_octogon_subid0BelowWater_stateC:
	call _ecom_decCounter1		; $777c
	jr nz,_octogon_animate	; $777f

	ld l,Enemy.var36		; $7781
	ld (hl),90		; $7783

	ld l,e			; $7785
	ld (hl),$08 ; [state]

	jr _octogon_animate		; $7788


; Just submerged into water
_octogon_subid0BelowWater_stateD:
	call _ecom_decCounter1		; $778a
	ret nz			; $778d
	ld (hl),30		; $778e

	ld l,e			; $7790
	ld (hl),$08 ; [state]

	jr _octogon_loadNormalSubmergedAnimation		; $7793


; Link is below water
_octogon_subid1:
	ld h,d			; $7795
	ld l,Enemy.var33		; $7796
	ld e,Enemy.yh		; $7798
	ldi a,(hl)		; $779a
	ld (de),a		; $779b
	ld e,Enemy.xh		; $779c
	ld a,(hl)		; $779e
	ld (de),a		; $779f

	ld e,Enemy.var03		; $77a0
	ld a,(de)		; $77a2
	or a			; $77a3
	ld e,Enemy.state		; $77a4
	ld a,(de)		; $77a6
	jp z,_octogon_subid1_aboveWater		; $77a7

	sub $08			; $77aa
	rst_jumpTable			; $77ac
	.dw _octogon_subid1_belowWater_state8
	.dw _octogon_subid1_belowWater_state9
	.dw _octogon_subid1_belowWater_stateA
	.dw _octogon_subid1_belowWater_stateB
	.dw _octogon_subid1_belowWater_stateC


; Normal movement (moving toward some target position decided already)
_octogon_subid1_belowWater_state8:
	call _octogon_decVar36IfNonzero		; $77b7
	jr nz,@normalMovement	; $77ba

	; var36 reached 0
	ld (hl),90		; $77bc

	; 50% chance to do check below...
	call getRandomNumber		; $77be
	rrca			; $77c1
	jr nc,@normalMovement	; $77c2

	; If the direction toward Link has not changed...
	call objectGetAngleTowardEnemyTarget		; $77c4
	add $04			; $77c7
	and $18			; $77c9
	ld b,a			; $77cb
	ld e,Enemy.angle		; $77cc
	ld a,(de)		; $77ce
	add $04			; $77cf
	and $18			; $77d1
	cp b			; $77d3
	ld h,d			; $77d4
	jr nz,@normalMovement	; $77d5

	; Go to state $0b (fire bubble projectile)
	ld l,Enemy.state		; $77d7
	ld (hl),$0b		; $77d9
	ld l,Enemy.counter1		; $77db
	ld (hl),$08		; $77dd
	ld l,Enemy.direction		; $77df
	ld a,(hl)		; $77e1
	and $0c			; $77e2
	add $02			; $77e4
	ld (hl),a		; $77e6
	jp enemySetAnimation		; $77e7

@normalMovement:
	; Will rise above water when counter2 reaches 0
	ld a,(wFrameCounter)		; $77ea
	and $03			; $77ed
	jr nz,++		; $77ef
	ld l,Enemy.counter2		; $77f1
	dec (hl)		; $77f3
	jp z,_octogon_beginRisingAboveWater		; $77f4
++
	call _ecom_decCounter1		; $77f7
	jr nz,_octogon_updateMovementAndAnimation	; $77fa

	ld (hl),60 ; [counter1]

	ld l,Enemy.state		; $77fe
	inc (hl) ; [state] = 9
	ret			; $7801

;;
; Moves toward target position and updates animation + sound effects accordingly
; @addr{7802}
_octogon_updateMovementAndAnimation:
	call _octogon_moveTowardTargetPosition		; $7802

	ld h,d			; $7805
	ld l,Enemy.var35		; $7806
	dec (hl)		; $7808
	ret nz			; $7809

	ld (hl),$0c		; $780a

	ld l,Enemy.direction		; $780c
	ld a,(hl)		; $780e
	xor $01			; $780f
	ld (hl),a		; $7811
	call enemySetAnimation		; $7812

	ld e,Enemy.subid		; $7815
	ld a,(de)		; $7817
	or a			; $7818
	ld a,SND_LINK_SWIM		; $7819
	jp nz,playSound		; $781b

	; Above-water only (subid 0)

;;
; @addr{781e}
_octogon_doSplashAnimation:
	ld a,SND_SWORDSPIN		; $781e
	call playSound		; $7820

	; Splash animation
	call getFreeInteractionSlot		; $7823
	ret nz			; $7826
	ld (hl),INTERACID_OCTOGON_SPLASH		; $7827
	ld e,Enemy.direction		; $7829
	ld a,(de)		; $782b
	and $0c			; $782c
	ld l,Interaction.direction		; $782e
	ld (hl),a		; $7830
	jp objectCopyPosition		; $7831


; Waiting in place until counter1 reaches 0, then will charge at Link.
_octogon_subid1_belowWater_state9:
	call _ecom_decCounter1		; $7834
	ret nz			; $7837

	ld (hl),$0c ; [counter1]

	ld l,e			; $783a
	inc (hl) ; [state] = $0a

	; Save Link's current position as target position to charge at
	ld l,Enemy.var31		; $783c
	ldh a,(<hEnemyTargetY)	; $783e
	ldi (hl),a		; $7840
	ldh a,(<hEnemyTargetX)	; $7841
	ld (hl),a		; $7843

	; Do some weird math to decide animation
	call _ecom_updateAngleTowardTarget		; $7844
	ld h,d			; $7847
	ld l,Enemy.direction		; $7848
	ld a,(hl)		; $784a
	and $0c			; $784b
	add a			; $784d
	ld b,a			; $784e

	ld e,Enemy.angle		; $784f
	ld a,(de)		; $7851
	sub b			; $7852
	and $1f			; $7853
	ld b,a			; $7855
	sub $04			; $7856
	cp $18			; $7858
	ret nc			; $785a

	bit 4,b			; $785b
	ld a,$04		; $785d
	jr z,+			; $785f
	ld a,$0c		; $7861
+
	add (hl)		; $7863
	and $0c			; $7864
	ld (hl),a		; $7866
	jp enemySetAnimation		; $7867


; Waiting for a split second before charging
_octogon_subid1_belowWater_stateA:
	call _ecom_decCounter1		; $786a
	ret nz			; $786d

	ld (hl),90		; $786e

	ld l,e			; $7870
	ld (hl),$08 ; [state]

	ld l,Enemy.angle		; $7873
	ldd a,(hl)		; $7875
	add $04			; $7876
	and $18			; $7878
	rrca			; $787a
	ld (hl),a		; $787b
	jp enemySetAnimation		; $787c


; Delay before firing bubble
_octogon_subid1_belowWater_stateB:
	call _ecom_decCounter1		; $787f
	ret nz			; $7882

	ld (hl),60		; $7883

	ld l,e			; $7885
	inc (hl) ; [state] = $0c

	ld l,Enemy.direction		; $7887
	inc (hl)		; $7889
	ld a,(hl)		; $788a
	call enemySetAnimation		; $788b

	call getFreePartSlot		; $788e
	jr nz,++		; $7891
	ld (hl),PARTID_OCTOGON_BUBBLE		; $7893
	call _octogon_initializeProjectile		; $7895
++
	jp _octogon_doSplashAnimation		; $7898


; Delay after firing bubble
_octogon_subid1_belowWater_stateC:
	call _ecom_decCounter1		; $789b
	ret nz			; $789e

	ld l,e			; $789f
	ld (hl),$08 ; [state]

	ld l,Enemy.direction		; $78a2
	ld a,(hl)		; $78a4
	and $0c			; $78a5
	ld (hl),a		; $78a7
	jp enemySetAnimation		; $78a8


; Octogon is above water, but Link is below water
_octogon_subid1_aboveWater:
	sub $08			; $78ab
	rst_jumpTable			; $78ad
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	call _ecom_decCounter1		; $78b4
	ret nz			; $78b7
	ld (hl),120		; $78b8
	ld b,PARTID_OCTOGON_DEPTH_CHARGE		; $78ba
	jp _ecom_spawnProjectile		; $78bc


; States $09-$0a used while moving to surface
@state9:
	call _ecom_decCounter1		; $78bf
	ret nz			; $78c2

	ld l,e			; $78c3
	inc (hl) ; [state] = $0a

	ld l,Enemy.direction		; $78c5
	ld a,$11		; $78c7
	ld (hl),a		; $78c9
	call enemySetAnimation		; $78ca

	ld a,SND_ENEMY_JUMP		; $78cd
	call playSound		; $78cf

	ld bc,$0208		; $78d2
	jp _enemyBoss_spawnShadow		; $78d5

@stateA:
	ld h,d			; $78d8
	ld l,Enemy.z		; $78d9
	ld a,(hl)		; $78db
	sub <($00c0)			; $78dc
	ldi (hl),a		; $78de
	ld a,(hl)		; $78df
	sbc >($00c0)			; $78e0
	ld (hl),a		; $78e2

	cp $d0			; $78e3
	ret nc			; $78e5

	cp $c0			; $78e6
	jp nz,_ecom_flickerVisibility		; $78e8

	ld (hl),$00		; $78eb

	ld l,e			; $78ed
	ld (hl),$08 ; [state] = 8

	ld l,Enemy.collisionType		; $78f0
	res 7,(hl)		; $78f2

	ld l,Enemy.counter1		; $78f4
	ld (hl),60		; $78f6

	call objectSetInvisible		; $78f8
	jp _ecom_killRelatedObj1		; $78fb


; Invisible collision box for the shell
_octogon_subid2:
	ld a,Object.direction		; $78fe
	call objectGetRelatedObject1Var		; $7900
	ld a,(hl)		; $7903
	cp $10			; $7904
	jr c,+			; $7906
	ld a,$08		; $7908
+
	and $0c			; $790a
	push hl			; $790c
	ld hl,@data		; $790d
	rst_addAToHl			; $7910

	ld e,Enemy.collisionRadiusY		; $7911
	ldi a,(hl)		; $7913
	ld (de),a		; $7914
	inc e			; $7915
	ldi a,(hl)		; $7916
	ld (de),a		; $7917

	ldi a,(hl)		; $7918
	ld c,(hl)		; $7919
	ld b,a			; $791a
	pop hl			; $791b
	call objectTakePositionWithOffset		; $791c
	pop hl			; $791f
	ret			; $7920

; Data format: collisionRadiusY, collisionRadiusX, Y position, X position
@data:
	.db $06 $0a $0e $00
	.db $0a $06 $00 $f2
	.db $06 $0a $f2 $00
	.db $0a $06 $00 $0e


;;
; @addr{7931}
_octogon_subid0_submergeIntoWater:
	ld h,d			; $7931
	ld l,Enemy.state		; $7932
	ld (hl),$0d		; $7934
	ld l,Enemy.collisionType		; $7936
	res 7,(hl)		; $7938
	ld l,Enemy.var03		; $793a
	ld (hl),$01		; $793c
	ld l,Enemy.counter1		; $793e
	ld (hl),$10		; $7940
	ld l,Enemy.var36		; $7942
	ld (hl),90		; $7944
	ld l,Enemy.direction		; $7946
	ld a,$15		; $7948
	ld (hl),a		; $794a
	jp enemySetAnimation		; $794b


;;
; @addr{794e}
_octogon_beginRisingAboveWater:
	ld h,d			; $794e
	ld l,Enemy.state		; $794f
	ld (hl),$09		; $7951
	ld l,Enemy.var03		; $7953
	ld (hl),$00		; $7955

	ld l,Enemy.counter1		; $7957
	ld (hl),30		; $7959

	ld l,Enemy.var36		; $795b
	ld (hl),90		; $795d

	ld l,Enemy.direction		; $795f
	ld a,$10		; $7961
	ld (hl),a		; $7963
	jp enemySetAnimation		; $7964


;;
; Takes current position, fixes it to the closest valid spot above water, and decides
; a value for var30 (target position index).
; @addr{7967}
_octogon_fixPositionAboveWater:
	ld a,(wTmpcfc0.octogonBoss.posNeedsFixing)		; $7967
	or a			; $796a
	ret z			; $796b

	xor a			; $796c
	ld (wTmpcfc0.octogonBoss.posNeedsFixing),a		; $796d

	ld h,d			; $7970
	ld l,Enemy.yh		; $7971
	ldi a,(hl)		; $7973
	ld b,a			; $7974
	inc l			; $7975
	ld c,(hl)		; $7976
	call _octogon_getClosestTargetPositionIndex		; $7977
	ld l,e			; $797a

	ld a,(w1Link.yh)		; $797b
	ld b,a			; $797e
	ld a,(w1Link.xh)		; $797f
	ld c,a			; $7982
	call _octogon_getClosestTargetPositionIndex		; $7983

	; BUG: supposed to compare 'l' against 'e', not 'a'. As a result octogon may not
	; move out of the way properly if Link surfaces in the same position.
	; (In effect, it only matters when they're both around centre-bottom, and maybe
	; one other spot?)
	cp l			; $7986
	ld a,l			; $7987
	jr nz,++		; $7988
	ld hl,@linkCompensationIndices		; $798a
	rst_addAToHl			; $798d
	ld a,(hl)		; $798e
++
	add a			; $798f
	ld hl,@data		; $7990
	rst_addDoubleIndex			; $7993
	ld e,Enemy.yh		; $7994
	ldi a,(hl)		; $7996
	ld (de),a		; $7997
	ld e,Enemy.xh		; $7998
	ldi a,(hl)		; $799a
	ld (de),a		; $799b
	ld e,Enemy.var30		; $799c
	ld a,(hl)		; $799e
	ld (de),a		; $799f

	ld h,d			; $79a0
	ld l,e			; $79a1
	bit 7,a			; $79a2
	jp nz,_octogon_chooseRandomTargetPosition		; $79a4
	jp _octogon_loadTargetPosition		; $79a7

; Data format: Y, X, var30 (target position index), unused
@data:
	.db $28 $30 $01 $00
	.db $28 $78 $ff $00
	.db $28 $c0 $09 $00
	.db $58 $30 $02 $00
	.db $00 $00 $ff $00
	.db $58 $c0 $0a $00
	.db $88 $30 $0d $00
	.db $88 $78 $0c $00
	.db $88 $c0 $05 $00

; Corresponding index from this table is used if Link would have surfaced on top of
; octogon.
@linkCompensationIndices:
	.db $01 $00 $01 $06 $00 $08 $03 $08 $05

;;
; @addr{79d7}
_octogon_fireOctorokProjectile:
	call getFreePartSlot		; $79d7
	ret nz			; $79da
	ld (hl),PARTID_OCTOROK_PROJECTILE		; $79db

;;
; @param	h	Projectile (could be PARTID_OCTOROK_PROJECTILE or
;			PARTID_OCTOGON_BUBBLE)
; @addr{79dd}
_octogon_initializeProjectile:
	ld e,Enemy.direction		; $79dd
	ld a,(de)		; $79df
	and $0c			; $79e0
	ld b,a			; $79e2
	add a			; $79e3
	ld l,Part.angle		; $79e4
	ld (hl),a		; $79e6

	ld a,b			; $79e7
	rrca			; $79e8
	push hl			; $79e9
	ld hl,@positionOffsets		; $79ea
	rst_addAToHl			; $79ed
	ldi a,(hl)		; $79ee
	ld b,a			; $79ef
	ld c,(hl)		; $79f0

	pop hl			; $79f1
	call objectCopyPositionWithOffset		; $79f2
	ld a,SND_STRIKE		; $79f5
	jp playSound		; $79f7

@positionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @addr{7a02}
_octogon_decVar36IfNonzero:
	ld h,d			; $7a02
	ld l,Enemy.var36		; $7a03
	ld a,(hl)		; $7a05
	or a			; $7a06
	ret z			; $7a07
	dec (hl)		; $7a08
	ret			; $7a09

;;
; Moves toward position stored in var31/var32. Increments state and sets counter1 to 30
; when it reaches that position.
; @addr{7a0a}
_octogon_moveTowardTargetPosition:
	ld h,d			; $7a0a
	ld l,Enemy.var31		; $7a0b
	call _ecom_readPositionVars		; $7a0d
	sub c			; $7a10
	inc a			; $7a11
	cp $03			; $7a12
	jp nc,_ecom_moveTowardPosition		; $7a14

	ldh a,(<hFF8F)	; $7a17
	sub b			; $7a19
	inc a			; $7a1a
	cp $03			; $7a1b
	jp nc,_ecom_moveTowardPosition		; $7a1d

	ld l,Enemy.yh		; $7a20
	ld (hl),b		; $7a22
	ld l,Enemy.xh		; $7a23
	ld (hl),c		; $7a25
	ld l,Enemy.state		; $7a26
	inc (hl)		; $7a28
	ld l,Enemy.counter1		; $7a29
	ld (hl),30		; $7a2b
	ret			; $7a2d


;;
; Given a position, this determines the "target position index" (value for var30) which
; that position most closely corresponds to.
;
; @param	bc	Position
; @param[out]	a
; @param[out]	e
; @addr{7a2e}
_octogon_getClosestTargetPositionIndex:
	ld e,$00		; $7a2e

@checkY:
	ld a,b			; $7a30
	cp $40			; $7a31
	jr c,@checkX	; $7a33
	ld e,$03		; $7a35
	cp $70			; $7a37
	jr c,@checkX	; $7a39

	ld e,$06		; $7a3b
@checkX:
	ld a,c			; $7a3d
	cp $50			; $7a3e
	jr c,++		; $7a40
	inc e			; $7a42
	cp $a0			; $7a43
	jr c,++		; $7a45

	inc e			; $7a47
++
	ld a,e			; $7a48
	cp $04			; $7a49
	ret nz			; $7a4b

	ld e,$00		; $7a4c
	ld a,b			; $7a4e
	cp $58			; $7a4f
	jr c,+			; $7a51
	ld e,$06		; $7a53
+
	ld a,c			; $7a55
	cp $78			; $7a56
	ret c			; $7a58
	inc e			; $7a59
	inc e			; $7a5a
	ret			; $7a5b

; ==============================================================================
; ENEMYID_PLASMARINE
;
; Variables:
;   counter2: Number of times to do shock attack before firing projectiles
;   var30/var31: Target position?
;   var32: Color (0 for blue, 1 for red)
;   var33: ?
;   var34: Number of projectiles to fire in one attack
; ==============================================================================
enemyCode7e:
	jr z,@normalStatus	; $7a5c

	sub ENEMYSTATUS_NO_HEALTH			; $7a5e
	ret c			; $7a60
	jp z,_enemyBoss_dead		; $7a61

	; Hit by something
	ld e,Enemy.enemyCollisionMode		; $7a64
	ld a,(de)		; $7a66
	cp ENEMYCOLLISION_PLASMARINE_SHOCK			; $7a67
	jr z,@normalStatus	; $7a69

	ld e,Enemy.var2a		; $7a6b
	ld a,(de)		; $7a6d
	res 7,a			; $7a6e
	cp ITEMCOLLISION_L1_SWORD			; $7a70
	call nc,_plasmarine_state_switchHook@swapColor		; $7a72

@normalStatus:
	ld e,Enemy.state		; $7a75
	ld a,(de)		; $7a77
	rst_jumpTable			; $7a78
	.dw _plasmarine_state_uninitialized
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_switchHook
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state_stub
	.dw _plasmarine_state8
	.dw _plasmarine_state9
	.dw _plasmarine_stateA
	.dw _plasmarine_stateB
	.dw _plasmarine_stateC
	.dw _plasmarine_stateD
	.dw _plasmarine_stateE
	.dw _plasmarine_stateF


_plasmarine_state_uninitialized:
	ld a,SPEED_280		; $7a99
	call _ecom_setSpeedAndState8		; $7a9b
	ld l,Enemy.angle		; $7a9e
	ld (hl),$08		; $7aa0

	ld l,Enemy.counter1		; $7aa2
	ld (hl),$04		; $7aa4

	ld l,Enemy.var30		; $7aa6
	ld (hl),$58		; $7aa8
	inc l			; $7aaa
	ld (hl),$78		; $7aab

	ld a,$01		; $7aad
	ld (wMenuDisabled),a		; $7aaf
	ld (wDisabledObjects),a		; $7ab2

	ld a,ENEMYID_PLASMARINE		; $7ab5
	ld b,$00		; $7ab7
	call _enemyBoss_initializeRoom		; $7ab9
	jp objectSetVisible83		; $7abc


_plasmarine_state_switchHook:
	inc e			; $7abf
	ld a,(de)		; $7ac0
	rst_jumpTable			; $7ac1
	.dw @justLatched
	.dw @beforeSwitch
	.dw @afterSwitch
	.dw @released

@justLatched:
	xor a			; $7aca
	ld e,Enemy.var33		; $7acb
	ld (de),a		; $7acd
	call enemySetAnimation		; $7ace
	jp _ecom_incState2		; $7ad1

@afterSwitch:
	ld e,Enemy.var33		; $7ad4
	ld a,(de)		; $7ad6
	or a			; $7ad7
	ret nz			; $7ad8
	inc a			; $7ad9
	ld (de),a		; $7ada
	ld a,SND_MYSTERY_SEED		; $7adb
	call playSound		; $7add


; This is called from outside "plasmarine_state_switchHook" (ie. when sword slash occurs).
@swapColor:
	ld h,d			; $7ae0
	ld l,Enemy.var32		; $7ae1
	ld a,(hl)		; $7ae3
	xor $01			; $7ae4
	ld (hl),a		; $7ae6
	inc a			; $7ae7
	ld l,Enemy.oamFlagsBackup		; $7ae8
	ldi (hl),a		; $7aea
	ld (hl),a		; $7aeb


@beforeSwitch:
	ret			; $7aec


@released:
	ld b,$0a		; $7aed
	call _ecom_fallToGroundAndSetState		; $7aef
	ret nz			; $7af2
	ld l,Enemy.counter1		; $7af3
	ld (hl),60		; $7af5
	jp _plasmarine_decideNumberOfShockAttacks		; $7af7


_plasmarine_state_stub:
	ret			; $7afa


; Moving toward centre of room before starting fight
_plasmarine_state8:
	call _plasmarine_checkCloseToTargetPosition		; $7afb
	jr c,@reachedTarget	; $7afe

	call _ecom_decCounter1		; $7b00
	jr nz,++		; $7b03
	ld (hl),$04		; $7b05
	call objectGetRelativeAngleWithTempVars		; $7b07
	call objectNudgeAngleTowards		; $7b0a
++
	call objectApplySpeed		; $7b0d
	jr _plasmarine_animate		; $7b10

@reachedTarget:
	ld l,e			; $7b12
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1		; $7b14
	ld (hl),60		; $7b16
	ld l,Enemy.yh		; $7b18
	ld (hl),b		; $7b1a
	ld l,Enemy.xh		; $7b1b
	ld (hl),c		; $7b1d
	jr _plasmarine_animate		; $7b1e


; 60 frame delay before starting fight
_plasmarine_state9:
	call _ecom_decCounter1		; $7b20
	jr nz,_plasmarine_animate	; $7b23

	ld (hl),60 ; [counter1]
	ld l,e			; $7b27
	inc (hl) ; [state] = $0a

	ld l,Enemy.collisionType		; $7b29
	set 7,(hl)		; $7b2b

	call _plasmarine_decideNumberOfShockAttacks		; $7b2d
	call _enemyBoss_beginBoss		; $7b30
	xor a			; $7b33
	jp enemySetAnimation		; $7b34


; Standing in place before charging
_plasmarine_stateA:
	call _ecom_decCounter1		; $7b37
	jr nz,_plasmarine_animate	; $7b3a

	inc (hl) ; [counter1] = 1

	ld l,Enemy.animParameter		; $7b3d
	bit 0,(hl)		; $7b3f
	jr z,_plasmarine_animate	; $7b41

	; Initialize stuff for state $0b (charge at Link)
	ld l,Enemy.counter1		; $7b43
	ld (hl),$0c		; $7b45
	ld l,e			; $7b47
	inc (hl) ; [state] = $0b
	ld l,Enemy.speed		; $7b49
	ld (hl),SPEED_300		; $7b4b

	ld l,Enemy.var30		; $7b4d
	ldh a,(<hEnemyTargetY)	; $7b4f
	ldi (hl),a		; $7b51
	ldh a,(<hEnemyTargetX)	; $7b52
	ld (hl),a		; $7b54

_plasmarine_animate:
	jp enemyAnimate		; $7b55


; Charging toward Link
_plasmarine_stateB:
	call _ecom_decCounter1		; $7b58
	jr nz,++		; $7b5b
	ld l,e			; $7b5d
	inc (hl) ; [state] = $0c
++
	ld l,Enemy.speed		; $7b5f
	ld a,(hl)		; $7b61
	sub SPEED_20			; $7b62
	ld (hl),a		; $7b64
	; Fall through

_plasmarine_stateC:
	call _plasmarine_checkCloseToTargetPosition		; $7b65
	jp nc,_ecom_moveTowardPosition		; $7b68

	; Reached target position.
	ld l,Enemy.counter2		; $7b6b
	dec (hl)		; $7b6d
	ld l,e			; $7b6e
	jr z,@fireProjectiles	; $7b6f

	; Do shock attack (state $0d)
	ld (hl),$0d ; [state]
	ld l,Enemy.counter1		; $7b73
	ld (hl),65		; $7b75

	ld l,Enemy.damage		; $7b77
	ld (hl),-8		; $7b79

	ld l,Enemy.var32		; $7b7b
	ld a,(hl)		; $7b7d
	add $04			; $7b7e
	ld l,Enemy.oamFlagsBackup		; $7b80
	ldi (hl),a		; $7b82
	ld (hl),a		; $7b83

	ld l,Enemy.enemyCollisionMode		; $7b84
	ld (hl),ENEMYCOLLISION_PLASMARINE_SHOCK		; $7b86
	ld a,$02		; $7b88
	jp enemySetAnimation		; $7b8a

@fireProjectiles:
	ld (hl),$0e ; [state]
	ld l,Enemy.health		; $7b8f
	ld a,(hl)		; $7b91
	dec a			; $7b92
	ld hl,@numProjectilesToFire		; $7b93
	rst_addAToHl			; $7b96
	ld e,Enemy.var34		; $7b97
	ld a,(hl)		; $7b99
	ld (de),a		; $7b9a

	ld a,$01		; $7b9b
	jp enemySetAnimation		; $7b9d

; Takes health value as index, returns number of projectiles to fire in one attack
@numProjectilesToFire:
	.db $03 $03 $02 $02 $02 $01 $01


; Shock attack
_plasmarine_stateD:
	call _ecom_decCounter1		; $7ba7
	jr z,@doneAttack	; $7baa

	ld a,(hl)		; $7bac
	and $0f			; $7bad
	ld a,SND_SHOCK		; $7baf
	call z,playSound		; $7bb1

	; Update oamFlags based on animParameter
	ld e,Enemy.animParameter		; $7bb4
	ld a,(de)		; $7bb6
	or a			; $7bb7
	ld b,$04		; $7bb8
	jr z,+			; $7bba
	ld b,$01		; $7bbc
+
	ld e,Enemy.var32		; $7bbe
	ld a,(de)		; $7bc0
	add b			; $7bc1
	ld h,d			; $7bc2
	ld l,Enemy.oamFlagsBackup		; $7bc3
	ldi (hl),a		; $7bc5
	ld (hl),a		; $7bc6
	jr _plasmarine_animate		; $7bc7

@doneAttack:
	ld (hl),60 ; [counter1]
	ld l,e			; $7bcb
	ld (hl),$0a ; [state]

	ld l,Enemy.collisionType		; $7bce
	set 7,(hl)		; $7bd0

	ld l,Enemy.damage		; $7bd2
	ld (hl),-4		; $7bd4

	ld l,Enemy.var32		; $7bd6
	ld a,(hl)		; $7bd8
	inc a			; $7bd9
	ld l,Enemy.oamFlagsBackup		; $7bda
	ldi (hl),a		; $7bdc
	ld (hl),a		; $7bdd

	ld l,Enemy.enemyCollisionMode		; $7bde
	ld (hl),ENEMYCOLLISION_PLASMARINE		; $7be0
	xor a			; $7be2
	jp enemySetAnimation		; $7be3


; Firing projectiles
_plasmarine_stateE:
	call enemyAnimate		; $7be6
	ld e,Enemy.animParameter		; $7be9
	ld a,(de)		; $7beb
	dec a			; $7bec
	jr z,@fire	; $7bed

	inc a			; $7bef
	ret z			; $7bf0

	call _ecom_incState		; $7bf1
	ld l,Enemy.counter1		; $7bf4
	ld (hl),60		; $7bf6
	xor a			; $7bf8
	jp enemySetAnimation		; $7bf9

@fire:
	ld (de),a ; [animParameter] = 0

	call getFreePartSlot		; $7bfd
	ret nz			; $7c00
	ld (hl),PARTID_PLASMARINE_PROJECTILE		; $7c01
	inc l			; $7c03
	ld e,Enemy.oamFlags		; $7c04
	ld a,(de)		; $7c06
	dec a			; $7c07
	ld (hl),a ; [projectile.var03]

	ld l,Part.relatedObj1+1		; $7c09
	ld (hl),d		; $7c0b
	dec l			; $7c0c
	ld (hl),Enemy.start		; $7c0d

	ld bc,$ec00		; $7c0f
	call objectCopyPositionWithOffset		; $7c12
	ld a,SND_VERAN_FAIRY_ATTACK		; $7c15
	jp playSound		; $7c17


; Decides whether to return to state $0e (fire another projectile) or charge at Link again
_plasmarine_stateF:
	call _ecom_decCounter1		; $7c1a
	jp nz,enemyAnimate		; $7c1d

	ld l,Enemy.var34		; $7c20
	dec (hl)		; $7c22
	ld l,e			; $7c23
	jr z,@chargeAtLink	; $7c24

	dec (hl) ; [state] = $0e
	ld a,$01		; $7c27
	jp enemySetAnimation		; $7c29

@chargeAtLink:
	ld (hl),$0a		; $7c2c
	ld l,Enemy.counter1		; $7c2e
	ld (hl),30		; $7c30

;;
; @addr{7c32}
_plasmarine_decideNumberOfShockAttacks:
	call getRandomNumber_noPreserveVars		; $7c32
	and $01			; $7c35
	inc a			; $7c37
	ld e,Enemy.counter2		; $7c38
	ld (de),a		; $7c3a
	ret			; $7c3b

;;
; @param[out]	cflag	c if close enough to target position
; @addr{7c3c}
_plasmarine_checkCloseToTargetPosition:
	ld h,d			; $7c3c
	ld l,Enemy.var30		; $7c3d
	call _ecom_readPositionVars		; $7c3f
	sub c			; $7c42
	add $04			; $7c43
	cp $09			; $7c45
	ret nc			; $7c47
	ldh a,(<hFF8F)	; $7c48
	sub b			; $7c4a
	add $04			; $7c4b
	cp $09			; $7c4d
	ret			; $7c4f

; TODO: what is this? Unused data?
.db $ec $ec $ec $14 $14 $14 $14 $ec
.db $00 $e8 $e8 $00 $00 $18 $18 $00


; ==============================================================================
; ENEMYID_KING_MOBLIN
;
; Variables:
;   counter2: ?
;   relatedObj2: Instance of PARTID_KING_MOBLIN_BOMB
;   var30/var31: Object indices for two ENEMYID_KING_MOBLIN_MINION instances
;   var32: Target x-position to walk toward to grab bomb
;   var33: Signal from ENEMYID_KING_MOBLIN_MINION to trigger warp to the outside
; ==============================================================================
enemyCode7f:
	jr z,@normalStatus	; $7c60
	sub ENEMYSTATUS_NO_HEALTH			; $7c62
	ret c			; $7c64
	jr z,@dead	; $7c65

	; Collision occurred

	ld e,Enemy.var2a		; $7c67
	ld a,(de)		; $7c69
	cp $80|ITEMCOLLISION_BOMB			; $7c6a
	jr nz,@normalStatus	; $7c6c

	ld a,SND_BOSS_DAMAGE		; $7c6e
	call playSound		; $7c70

	; Determine speed based on health
	ld e,Enemy.health		; $7c73
	ld a,(de)		; $7c75
	dec a			; $7c76
	ld hl,@speeds		; $7c77
	rst_addAToHl			; $7c7a
	ld e,Enemy.speed		; $7c7b
	ld a,(hl)		; $7c7d
	ld (de),a		; $7c7e

	jr @normalStatus		; $7c7f

; Indexed by current health value
@speeds:
	.db SPEED_1c0, SPEED_1c0
	.db SPEED_140, SPEED_140
	.db SPEED_0c0, SPEED_0c0

@dead:
	call checkLinkCollisionsEnabled		; $7c87
	ret nc			; $7c8a

	ld a,$01		; $7c8b
	ld (wDisabledObjects),a		; $7c8d
	ld (wMenuDisabled),a		; $7c90

	ld h,d			; $7c93
	ld l,Enemy.collisionType		; $7c94
	res 7,(hl)		; $7c96

	ld l,Enemy.health		; $7c98
	ld (hl),a ; [health] = $01

	ld l,Enemy.state		; $7c9b
	ld (hl),$12		; $7c9d

	ld l,Enemy.angle		; $7c9f
	ld (hl),$00		; $7ca1
	ld l,Enemy.speed		; $7ca3
	ld (hl),SPEED_300		; $7ca5

	ld l,Enemy.invincibilityCounter		; $7ca7
	ld (hl),$00		; $7ca9

	ld a,$06		; $7cab
	call enemySetAnimation		; $7cad

@normalStatus:
	ld e,Enemy.invincibilityCounter		; $7cb0
	ld a,(de)		; $7cb2
	or a			; $7cb3
	ret nz			; $7cb4

	ld e,Enemy.state		; $7cb5
	ld a,(de)		; $7cb7
	rst_jumpTable			; $7cb8
	.dw _kingMoblin_state_uninitialized
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state_stub
	.dw _kingMoblin_state8
	.dw _kingMoblin_state9
	.dw _kingMoblin_stateA
	.dw _kingMoblin_stateB
	.dw _kingMoblin_stateC
	.dw _kingMoblin_stateD
	.dw _kingMoblin_stateE
	.dw _kingMoblin_stateF
	.dw _kingMoblin_state10
	.dw _kingMoblin_state11
	.dw _kingMoblin_state12
	.dw _kingMoblin_state13
	.dw _kingMoblin_state14
	.dw _kingMoblin_state15


_kingMoblin_state_uninitialized:
	ld a,ENEMYID_KING_MOBLIN		; $7ce5
	ld (wEnemyIDToLoadExtraGfx),a		; $7ce7

	ld a,PALH_8c		; $7cea
	call loadPaletteHeader		; $7cec

	ld a,SNDCTRL_STOPMUSIC		; $7cef
	call playSound		; $7cf1

	xor a			; $7cf4
	ld (wDisableLinkCollisionsAndMenu),a		; $7cf5
	dec a			; $7cf8
	ld (wActiveMusic),a		; $7cf9

	ld b,$02		; $7cfc
	call checkBEnemySlotsAvailable		; $7cfe
	ret nz			; $7d01

	call @spawnMinion		; $7d02
	ld e,Enemy.var30		; $7d05
	ld (de),a		; $7d07

	call @spawnMinion		; $7d08
	ld l,Enemy.subid		; $7d0b
	inc (hl)		; $7d0d
	ld e,Enemy.var31		; $7d0e
	ld (de),a		; $7d10
	ld a,SPEED_c0		; $7d11
	call _ecom_setSpeedAndState8		; $7d13
	call objectSetVisible83		; $7d16
	ld a,$02		; $7d19
	jp enemySetAnimation		; $7d1b

;;
; @param[out]	a,h	Object index
; @addr{7d1e}
@spawnMinion:
	call getFreeEnemySlot_uncounted		; $7d1e
	ld (hl),ENEMYID_KING_MOBLIN_MINION		; $7d21
	ld l,Enemy.relatedObj1		; $7d23
	ld a,Enemy.start		; $7d25
	ldi (hl),a		; $7d27
	ld (hl),d		; $7d28
	ld a,h			; $7d29
	ret			; $7d2a


_kingMoblin_state_stub:
	ret			; $7d2b


; Waiting for Link to move in to start the fight
_kingMoblin_state8:
	ld hl,w1Link.xh		; $7d2c
	ld a,(hl)		; $7d2f
	sub $40			; $7d30
	cp $20			; $7d32
	jr nc,_kingMoblin_animate	; $7d34

	ld l,<w1Link.zh		; $7d36
	ld a,(hl)		; $7d38
	or a			; $7d39
	jr nz,_kingMoblin_animate	; $7d3a

	ld l,<w1Link.direction		; $7d3c
	ld (hl),DIR_UP		; $7d3e

	call checkLinkVulnerable		; $7d40
	ret nc			; $7d43

	call clearAllParentItems		; $7d44
	ld a,$01		; $7d47
	ld (wDisabledObjects),a		; $7d49
	ld (wMenuDisabled),a		; $7d4c

	; Make stairs disappear
	ld c,$61		; $7d4f
	ld a,TILEINDEX_STANDARD_FLOOR		; $7d51
	call setTile		; $7d53

	; Poof at stairs
	call getFreeInteractionSlot		; $7d56
	jr nz,++		; $7d59
	ld (hl),INTERACID_PUFF		; $7d5b
	ld l,Interaction.yh		; $7d5d
	ld (hl),$68	; $7d5f
	ld l,Interaction.xh		; $7d61
	ld (hl),$18		; $7d63
++
	call _ecom_incState		; $7d65
	ld l,Enemy.counter1		; $7d68
	ld (hl),$18		; $7d6a

_kingMoblin_animate:
	jp enemyAnimate		; $7d6c


; Delay before showing text
_kingMoblin_state9:
	call _ecom_decCounter1		; $7d6f
	jr nz,_kingMoblin_animate	; $7d72

	ld l,e			; $7d74
	inc (hl) ; [state] = $0a

	call checkIsLinkedGame		; $7d76
	ld bc,TX_2f19		; $7d79
	jr z,+			; $7d7c
	ld bc,TX_2f1a		; $7d7e
+
	jp showText		; $7d81


; Starting fight
_kingMoblin_stateA:
	ld h,d			; $7d84
	ld l,e			; $7d85
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter2		; $7d87
	ld (hl),30		; $7d89

	ld l,Enemy.var30		; $7d8b
	ld b,(hl)		; $7d8d
	ld c,e			; $7d8e
	ld a,$02		; $7d8f
	ld (bc),a ; [minion1.state] = $02
	inc l			; $7d92
	ld b,(hl)		; $7d93
	ld (bc),a ; [minion2.state] = $02

	call _enemyBoss_beginBoss		; $7d95
	xor a			; $7d98
	jp enemySetAnimation		; $7d99


; Facing backwards while picking up a bomb
_kingMoblin_stateB:
	call _ecom_decCounter2		; $7d9c
	jr nz,_kingMoblin_animate	; $7d9f

	ld b,PARTID_KING_MOBLIN_BOMB		; $7da1
	call _ecom_spawnProjectile		; $7da3
	ret nz			; $7da6

	call _ecom_incState		; $7da7

_kingMoblin_initBombPickupAnimation:
	ld e,Enemy.health		; $7daa
	ld a,(de)		; $7dac
	dec a			; $7dad
	ld hl,@counter2Vals		; $7dae
	rst_addAToHl			; $7db1
	ld e,Enemy.counter2		; $7db2
	ld a,(hl)		; $7db4
	ld (de),a		; $7db5

	ld a,$04		; $7db6
	jp enemySetAnimation		; $7db8

@counter2Vals:
	.db 10 20 28 45 45 45


; Will raise bomb over head in [counter2] frames?
_kingMoblin_stateC:
	call _kingMoblin_checkMoveToCentre		; $7dc1
	ret nz			; $7dc4

	call _ecom_decCounter2		; $7dc5
	ret nz			; $7dc8

	ld l,Enemy.state		; $7dc9
	inc (hl) ; [state] = $0d

	; Set counter2 based on health
	ld l,Enemy.health		; $7dcc
	ld a,(hl)		; $7dce
	dec a			; $7dcf
	ld hl,@counter2Vals		; $7dd0
	rst_addAToHl			; $7dd3
	ld e,Enemy.counter2		; $7dd4
	ld a,(hl)		; $7dd6
	ld (de),a		; $7dd7

	; Update bomb's position if it hasn't exploded
	ld a,Object.state		; $7dd8
	call objectGetRelatedObject2Var		; $7dda
	ld a,(hl)		; $7ddd
	cp $05			; $7dde
	jr z,+			; $7de0
	ld bc,$f0f2		; $7de2
	call objectCopyPositionWithOffset		; $7de5
+
	ld a,$02		; $7de8
	jp enemySetAnimation		; $7dea

; Indexed by [health]-1
@counter2Vals:
	.db 5, 10, 12, 15, 15, 15


; Delay before throwing bomb
_kingMoblin_stateD:
	call _kingMoblin_checkMoveToCentre		; $7df3
	ret nz			; $7df6

	call _ecom_decCounter2		; $7df7
	ret nz			; $7dfa

	ld (hl),30		; $7dfb
	ld l,Enemy.state		; $7dfd
	inc (hl) ; [state] = $0e

	; Decide angle of bomb's movement based on link's position
	call objectGetAngleTowardEnemyTarget		; $7e00
	ld b,a			; $7e03
	sub $0c			; $7e04
	cp $07			; $7e06
	jr c,++			; $7e08

	ld b,$0c		; $7e0a
	rlca			; $7e0c
	jr c,++			; $7e0d

	ld b,$13		; $7e0f
++
	ld a,Object.state		; $7e11
	call objectGetRelatedObject2Var		; $7e13
	ld a,(hl)		; $7e16
	cp $05			; $7e17
	jr z,++			; $7e19

	; Throw bomb
	ld (hl),$03 ; [bomb.state] = $03
	ld l,Part.angle		; $7e1d
	ld (hl),b		; $7e1f
	ld l,Part.speedZ		; $7e20
	ld (hl),<(-$180)		; $7e22
	inc l			; $7e24
	ld (hl),>(-$180)		; $7e25
++
	ld a,$05		; $7e27
	jp enemySetAnimation		; $7e29


; Delay after throwing bomb
_kingMoblin_stateE:
	call _ecom_decCounter2		; $7e2c
	ret nz			; $7e2f
	ld l,e			; $7e30
	inc (hl) ; [state] = $0f
	ld a,$02		; $7e32
	jp enemySetAnimation		; $7e34


; Waiting for something to do
_kingMoblin_stateF:
	ld a,Object.id		; $7e37
	call objectGetRelatedObject2Var		; $7e39
	ld a,(hl)		; $7e3c
	cp PARTID_KING_MOBLIN_BOMB			; $7e3d
	jp nz,_kingMoblin_moveToCentre		; $7e3f

	; Do several checks to see if king moblin can pick up the bomb.

	; Is the state ok?
	ld l,Part.state		; $7e42
	ld a,(hl)		; $7e44
	cp $04			; $7e45
	jr nz,_kingMoblin_animate2	; $7e47

	; Is it above the ledge?
	ld l,Part.yh		; $7e49
	ldi a,(hl)		; $7e4b
	cp $36			; $7e4c
	jr nc,_kingMoblin_animate2	; $7e4e

	; Is it reachable on the x axis?
	inc l			; $7e50
	ld a,(hl) ; [bomb.xh]
	sub $30			; $7e52
	cp $41			; $7e54
	jr nc,_kingMoblin_animate2	; $7e56

	; Bomb can be grabbed.

	; Is the bomb close enough to grab without walking?
	ld e,Enemy.xh		; $7e58
	ld a,(de)		; $7e5a
	ld b,a			; $7e5b
	sub (hl)		; $7e5c
	add $08			; $7e5d
	cp $11			; $7e5f
	jr c,_kingMoblin_grabBomb			; $7e61

	; No; must move toward it
	ld a,(hl)		; $7e63
	cp b			; $7e64
	ld h,d			; $7e65
	ld l,Enemy.var32		; $7e66
	ld (hl),a		; $7e68
	ld b,$11 ; state $11
	jp _kingMoblin_setAngleStateAndAnimation		; $7e6b

_kingMoblin_grabBomb:
	ld a,Object.state		; $7e6e
	call objectGetRelatedObject2Var		; $7e70
	ld a,(hl)		; $7e73
	cp $05			; $7e74
	jr z,++			; $7e76
	ld (hl),$01		; $7e78
	ld bc,$0800		; $7e7a
	call objectCopyPositionWithOffset		; $7e7d
++
	ld h,d			; $7e80
	ld l,Enemy.state		; $7e81
	ld (hl),$0c		; $7e83
	jp _kingMoblin_initBombPickupAnimation		; $7e85


; Moving to centre of screen
_kingMoblin_state10:
	ld e,Enemy.xh		; $7e88
	ld a,(de)		; $7e8a
	sub $4e			; $7e8b
	cp $05			; $7e8d
	jr nc,++		; $7e8f

	ld h,d			; $7e91
	ld l,Enemy.state		; $7e92
	ld (hl),$0b		; $7e94
	ld l,Enemy.counter2		; $7e96
	ld (hl),30		; $7e98
	xor a			; $7e9a
	jp enemySetAnimation		; $7e9b
++
	call objectApplySpeed		; $7e9e

_kingMoblin_animate2:
	jp enemyAnimate		; $7ea1


; Moving toward bomb
_kingMoblin_state11:
	call _kingMoblin_checkMoveToCentre		; $7ea4
	ret nz			; $7ea7

	call objectApplySpeed		; $7ea8
	ld h,d			; $7eab
	ld l,Enemy.xh		; $7eac
	ld e,Enemy.var32		; $7eae
	ld a,(de)		; $7eb0
	sub (hl)		; $7eb1
	add $08			; $7eb2
	cp $11			; $7eb4
	jr c,_kingMoblin_grabBomb	; $7eb6
	jp enemyAnimate		; $7eb8


; Just died
_kingMoblin_state12:
	call objectApplySpeed		; $7ebb
	ld e,Enemy.yh		; $7ebe
	ld a,(de)		; $7ec0
	cp $0c			; $7ec1
	ret nc			; $7ec3

	call _ecom_incState		; $7ec4

	ld l,Enemy.angle		; $7ec7
	ld (hl),$10		; $7ec9
	ld l,Enemy.speed		; $7ecb
	ld (hl),SPEED_80		; $7ecd

	ld l,Enemy.speedZ		; $7ecf
	ld a,<(-$160)		; $7ed1
	ldi (hl),a		; $7ed3
	ld (hl),>(-$160)		; $7ed4

	ld a,60		; $7ed6
	jp setScreenShakeCounter		; $7ed8


; Falling to ground
_kingMoblin_state13:
	ld c,$20		; $7edb
	call objectUpdateSpeedZAndBounce		; $7edd
	jp nc,objectApplySpeed		; $7ee0

	call _ecom_incState		; $7ee3
	ld l,Enemy.counter1		; $7ee6
	ld (hl),150		; $7ee8
	ld l,Enemy.yh		; $7eea
	ld (hl),$20		; $7eec
	ret			; $7eee


; Wait for signal from ENEMYID_KING_MOBLIN_MINION to go to state $15?
_kingMoblin_state14:
	ld e,Enemy.var33		; $7eef
	ld a,(de)		; $7ef1
	or a			; $7ef2
	jr nz,@gotoState15	; $7ef3

	ld a,(wFrameCounter)		; $7ef5
	rrca			; $7ef8
	ret c			; $7ef9

	call _ecom_decCounter1		; $7efa
	ret nz			; $7efd

	ld l,Enemy.state		; $7efe
	ld (hl),$0b		; $7f00
	ld l,Enemy.counter2		; $7f02
	ld (hl),30		; $7f04
	xor a			; $7f06
	jp enemySetAnimation		; $7f07

@gotoState15:
	call _ecom_incState		; $7f0a
	ld l,Enemy.counter2		; $7f0d
	ld (hl),98		; $7f0f
	ret			; $7f11


; All bombs at top of screen explode, then initiates warp outside
_kingMoblin_state15:
	call _ecom_decCounter2		; $7f12
	jr z,@warpOutside	; $7f15

	; Explosion every 32 frames
	ld a,(hl)		; $7f17
	dec a			; $7f18
	and $1f			; $7f19
	ret nz			; $7f1b

	ld a,(hl)		; $7f1c
	and $60			; $7f1d
	rrca			; $7f1f
	swap a			; $7f20
	ld hl,@explosionPositions		; $7f22
	rst_addAToHl			; $7f25

	ld c,(hl)		; $7f26
	ld b,$08		; $7f27
	call getFreeInteractionSlot		; $7f29
	ret nz			; $7f2c
	ld (hl),INTERACID_EXPLOSION		; $7f2d
	ld l,Interaction.yh		; $7f2f
	ld (hl),b		; $7f31
	ld l,Interaction.xh		; $7f32
	ld (hl),c		; $7f34

	call getTileAtPosition		; $7f35
	ld c,l			; $7f38
	ld a,$a1		; $7f39
	jp setTile		; $7f3b

@warpOutside:
	ld hl,wPresentRoomFlags+$09		; $7f3e
	set 0,(hl)		; $7f41

	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED		; $7f43
	call setGlobalFlag		; $7f45
	ld a,GLOBALFLAG_16		; $7f48
	call setGlobalFlag		; $7f4a

	ld hl,@warpDest		; $7f4d
	jp setWarpDestVariables		; $7f50

@explosionPositions:
	.db $68 $38 $58 $48

@warpDest:
	m_HardcodedWarpA ROOM_AGES_009, $00, $45, $03


;;
; Updates state and angle values to move king moblin to centre of screen, if there is no
; bomb on screen. Sets state to $10 while moving, $0b when reached centre.
;
; @param[out]	zflag	nz if state changed
; @addr{7f5c}
_kingMoblin_checkMoveToCentre:
	ld a,Object.id		; $7f5c
	call objectGetRelatedObject2Var		; $7f5e
	ld a,(hl)		; $7f61
	cp PARTID_KING_MOBLIN_BOMB			; $7f62
	ret z			; $7f64

;;
; @addr{7f65}
_kingMoblin_moveToCentre:
	ld h,d			; $7f65
	ld l,Enemy.xh		; $7f66
	ld a,(hl)		; $7f68
	sub $4e			; $7f69
	cp $05			; $7f6b
	jr nc,@moveTowardCentre	; $7f6d

	; Reached centre
	ld l,Enemy.counter2		; $7f6f
	ld (hl),30		; $7f71
	ld b,$0b		; $7f73
	xor a			; $7f75
	jr _kingMoblin_setStateAndAnimation		; $7f76

@moveTowardCentre:
	cp $b0			; $7f78
	ld b,$10		; $7f7a

_kingMoblin_setAngleStateAndAnimation:
	ld a,ANGLE_RIGHT		; $7f7c
	jr nc,+			; $7f7e
	ld a,ANGLE_LEFT		; $7f80
+
	ld e,Enemy.angle		; $7f82
	ld (de),a		; $7f84
	swap a			; $7f85
	rlca			; $7f87

_kingMoblin_setStateAndAnimation:
	ld l,Enemy.state		; $7f88
	ld (hl),b		; $7f8a
	call enemySetAnimation		; $7f8b
	or d			; $7f8e
	ret			; $7f8f
