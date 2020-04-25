; ==============================================================================
; ENEMYID_TEKTITE
;
; Variables:
;   var30: Gravity
;   var31: Minimum value for counter1 (lower value = more frequent jumping)
; ==============================================================================
enemyCode30:
	call _ecom_checkHazards		; $44f0
	jr z,@normalStatus	; $44f3
	sub ENEMYSTATUS_NO_HEALTH			; $44f5
	ret c			; $44f7
	jp z,enemyDie		; $44f8
	dec a			; $44fb
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $44fc
	ret			; $44ff

@normalStatus:
	ld e,Enemy.state		; $4500
	ld a,(de)		; $4502
	rst_jumpTable			; $4503
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


@state_uninitialized:
	; Subid 1 has lower value for var31, meaning more frequent jumps.
	ld h,d			; $451c
	ld l,Enemy.subid		; $451d
	bit 0,(hl)		; $451f
	ld l,Enemy.var31		; $4521
	ld (hl),90		; $4523
	jr z,+			; $4525
	ld (hl),45		; $4527
+
	call getRandomNumber_noPreserveVars		; $4529
	and $7f			; $452c
	inc a			; $452e
	ld e,Enemy.counter1		; $452f
	ld (de),a		; $4531
	ld a,SPEED_140		; $4532
	jp _ecom_setSpeedAndState8AndVisible		; $4534


@state_switchHook:
	inc e			; $4537
	ld a,(de)		; $4538
	rst_jumpTable			; $4539
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $4542

@substate3:
	ld b,$08		; $4543
	call _ecom_fallToGroundAndSetState		; $4545
	ret nz			; $4548
	jp @gotoState8		; $4549


@state_stub:
	ret			; $454c


; Standing in place for [counter1] frames
@state8:
	call _ecom_decCounter1		; $454d
	jr nz,@animate	; $4550

	; Set [counter1] to how long the crouch will last
	call getRandomNumber_noPreserveVars		; $4552
	and $7f			; $4555
	call _ecom_incState		; $4557
	ld l,Enemy.var31		; $455a
	add (hl)		; $455c
	ld l,Enemy.counter1		; $455d
	ldi (hl),a		; $455f
	ld (hl),$18		; $4560
	ld a,$01		; $4562
	jp enemySetAnimation		; $4564
@animate:
	jp enemyAnimate		; $4567


; Crouching before a leap
@state9:
	call _ecom_decCounter2		; $456a
	ret nz			; $456d
	ld l,e			; $456e
	inc (hl)		; $456f
	ld a,$02		; $4570
	jp enemySetAnimation		; $4572


; About to start a leap
@stateA:
	ld a,$0b		; $4575
	ld (de),a ; [state]

	call getRandomNumber_noPreserveVars		; $4578
	and $07			; $457b
	ld hl,@smallLeap		; $457d
	jr nz,+			; $4580
	ld hl,@bigLeap		; $4582
+
	ld e,Enemy.speedZ		; $4585
	ldi a,(hl)		; $4587
	ld (de),a		; $4588
	inc e			; $4589
	ldi a,(hl)		; $458a
	ld (de),a		; $458b

	; Gravity
	ld e,Enemy.var30		; $458c
	ldi a,(hl)		; $458e
	ld (de),a		; $458f

	call _ecom_updateAngleTowardTarget		; $4590
	ld a,SND_ENEMY_JUMP		; $4593
	call playSound		; $4595
	jp objectSetVisiblec1		; $4598


; speedZ, gravity
@smallLeap:
	dwb $feaa, $0e
@bigLeap:
	dwb $fe80, $0c


; Leaping
@stateB:
	call _ecom_bounceOffScreenBoundary		; $45a1
	ld e,Enemy.var30		; $45a4
	ld a,(de)		; $45a6
	ld c,a			; $45a7
	call objectUpdateSpeedZ_paramC		; $45a8
	jp nz,_ecom_applyVelocityForSideviewEnemy		; $45ab

;;
; @addr{45ae}
@gotoState8:
	call getRandomNumber_noPreserveVars		; $45ae
	and $7f			; $45b1
	ld h,d			; $45b3
	ld l,Enemy.var31		; $45b4
	add (hl)		; $45b6
	ld l,Enemy.counter1		; $45b7
	ld (hl),a		; $45b9
	ld l,Enemy.state		; $45ba
	ld (hl),$08		; $45bc
	xor a			; $45be
	call enemySetAnimation		; $45bf
	jp objectSetVisiblec2		; $45c2


; ==============================================================================
; ENEMYID_STALFOS
; ==============================================================================
enemyCode31:
	call _ecom_checkHazards		; $45c5
	jr z,@normalStatus	; $45c8
	sub ENEMYSTATUS_NO_HEALTH			; $45ca
	ret c			; $45cc
	jp z,enemyDie		; $45cd
	dec a			; $45d0
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $45d1
	ret			; $45d4

@normalStatus:
	call _stalfos_checkJumpAwayFromLink		; $45d5
	ld e,Enemy.state		; $45d8
	ld a,(de)		; $45da
	rst_jumpTable			; $45db
	.dw _stalfos_state_uninitialized
	.dw _stalfos_state_stub
	.dw _stalfos_state_stub
	.dw _stalfos_state_switchHook
	.dw _stalfos_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _stalfos_state_stub
	.dw _stalfos_state_stub
	.dw _stalfos_state08
	.dw _stalfos_state09
	.dw _stalfos_state0a
	.dw _stalfos_state0b
	.dw _stalfos_state0c
	.dw _stalfos_state0d
	.dw _stalfos_state0e
	.dw _stalfos_state0f
	.dw _stalfos_state10


_stalfos_state_uninitialized:
	ld a,SPEED_80		; $45fe
	jp _ecom_setSpeedAndState8AndVisible		; $4600


_stalfos_state_switchHook:
	inc e			; $4603
	ld a,(de)		; $4604
	rst_jumpTable			; $4605
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw _ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret			; $460e


_stalfos_state_stub:
	ret			; $460f


; Choosing what to do next (move in a random direction, or shoot a bone an Link)
_stalfos_state08:
	call _stalfos_checkSubid3StompsLink		; $4610
	; Above function call may pop its return address, ignoring everything below this

	call getRandomNumber_noPreserveVars		; $4613
	and $07			; $4616
	jp nz,_stalfos_moveInRandomAngle		; $4618

	ld e,Enemy.subid		; $461b
	ld a,(de)		; $461d
	cp $02			; $461e
	jp nz,_stalfos_moveInRandomAngle		; $4620

	; For subid 2 only, there's a 1 in 8 chance of getting here (shooting a bone at
	; Link)
	ld e,Enemy.state		; $4623
	ld a,$0c		; $4625
	ld (de),a		; $4627
	ret			; $4628


; Moving in some direction for [counter1] frames
_stalfos_state09:
	call _stalfos_checkSubid3StompsLink		; $4629
	; Above function call may pop its return address, ignoring everything below this

	call _ecom_decCounter1		; $462c
	jr nz,++		; $462f
	ld l,Enemy.state		; $4631
	ld (hl),$08		; $4633
++
	call _ecom_bounceOffWallsAndHoles		; $4635
	call objectApplySpeed		; $4638
	jp enemyAnimate		; $463b


; Just starting a jump away from Link
_stalfos_state0a:
	ld bc,-$200		; $463e
	call objectSetSpeedZ		; $4641

	ld l,e			; $4644
	inc (hl) ; [state]

	; Make him invincible while he's moving upward
	ld l,Enemy.collisionType		; $4646
	res 7,(hl)		; $4648

	ld l,Enemy.speed		; $464a
	ld (hl),SPEED_140		; $464c

	call _ecom_updateCardinalAngleAwayFromTarget		; $464e
	jp _stalfos_beginJumpAnimation		; $4651


; Jumping until hitting the ground
_stalfos_state0b:
	ld c,$20		; $4654
	call objectUpdateSpeedZ_paramC		; $4656
	jr z,@hitGround	; $4659

	; Make him vulnerable to attack again once he starts moving down
	ld a,(hl) ; a = [speedZ]
	or a			; $465c
	jr nz,++		; $465d
	ld l,Enemy.collisionType		; $465f
	set 7,(hl)		; $4661
++
	jp _ecom_applyVelocityForSideviewEnemy		; $4663

@hitGround:
	ld a,SPEED_80		; $4666
	call _ecom_setSpeedAndState8		; $4668
	xor a			; $466b
	call enemySetAnimation		; $466c
	jp objectSetVisiblec2		; $466f


; Firing a projectile, then immediately going to state 9 to keep moving
_stalfos_state0c:
	ld b,PARTID_STALFOS_BONE		; $4672
	call _ecom_spawnProjectile		; $4674
	jr _stalfos_moveInRandomAngle		; $4677


; Stomping on Link
_stalfos_state0d:
	ld c,$20		; $4679
	call objectUpdateSpeedZ_paramC		; $467b

	; Check if he's begun moving down yet
	ld a,(hl)		; $467e
	or a			; $467f
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $4680

	; He's begun moving down. Go to next state so he freezes in the air.
	ld l,Enemy.counter1		; $4683
	ld (hl),$08		; $4685
	ld l,Enemy.state		; $4687
	inc (hl)		; $4689
	ret			; $468a


; Wait for 8 frames while hanging in the air mid-stomp
_stalfos_state0e:
	call _ecom_decCounter1		; $468b
	ret nz			; $468e
	ld l,e			; $468f
	inc (hl) ; [state]
	ret			; $4691


; Fall down for the stomp
_stalfos_state0f:
	ld h,d			; $4692
	ld l,Enemy.zh		; $4693
	ld a,(hl)		; $4695
	add $03			; $4696
	ld (hl),a		; $4698
	cp $80			; $4699
	ret nc			; $469b

	; Hit the ground
	xor a			; $469c
	ld (hl),a ; [zh] = 0

	ld l,e			; $469e
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $46a0
	ld (hl),30		; $46a2
	jp objectSetVisiblec2		; $46a4


; Laying on the ground for [counter1] frames until he starts moving again
_stalfos_state10:
	call _ecom_decCounter1		; $46a7
	ret nz			; $46aa


;;
; Go to state 9 with a freshly chosen angle
; @addr{46ab}
_stalfos_moveInRandomAngle:
	ld e,$30		; $46ab
	ld bc,$1f0f		; $46ad
	call _ecom_randomBitwiseAndBCE		; $46b0

	ld h,d			; $46b3
	ld l,Enemy.state		; $46b4
	ld (hl),$09		; $46b6
	ld l,Enemy.speed		; $46b8
	ld (hl),SPEED_80		; $46ba

	ld a,$20		; $46bc
	add e			; $46be
	ld l,Enemy.counter1		; $46bf
	ld (hl),a		; $46c1

	; 1 in 16 chance of moving toward Link; otherwise, move in random direction
	dec c			; $46c2
	ld a,b			; $46c3
	call z,objectGetAngleTowardEnemyTarget		; $46c4
	ld e,Enemy.angle		; $46c7
	ld (de),a		; $46c9
	xor a			; $46ca
	jp enemySetAnimation		; $46cb


;;
; For subid 3 only, if Link approaches close enough, it will jump toward Link to stomp on
; him (goes to state $0d).
; @addr{46ce}
_stalfos_checkSubid3StompsLink:
	ld e,Enemy.subid		; $46ce
	ld a,(de)		; $46d0
	cp $03			; $46d1
	ret nz			; $46d3

	ld c,$1c		; $46d4
	call objectCheckLinkWithinDistance		; $46d6
	ret nc			; $46d9

	ld bc,-$240		; $46da
	call objectSetSpeedZ		; $46dd

	ld l,Enemy.state		; $46e0
	ld (hl),$0d		; $46e2
	ld l,Enemy.speed		; $46e4
	ld (hl),SPEED_180		; $46e6

	pop hl ; Return from caller

	call _ecom_updateAngleTowardTarget		; $46e9


;;
; @addr{46ec}
_stalfos_beginJumpAnimation:
	ld a,$01		; $46ec
	call enemySetAnimation		; $46ee
	ld a,SND_ENEMY_JUMP		; $46f1
	call playSound		; $46f3
	jp objectSetVisiblec1		; $46f6


;;
; If Link is swinging something near this object, it will set its state to $0a if not
; already jumping.
; @addr{46f9}
_stalfos_checkJumpAwayFromLink:
	; Not for subid 0
	ld e,Enemy.subid		; $46f9
	ld a,(de)		; $46fb
	or a			; $46fc
	ret z			; $46fd

	; Check specifically for w1WeaponItem being used?
	ld a,(wLinkUsingItem1)		; $46fe
	and $f0			; $4701
	ret z			; $4703

	ld e,Enemy.state		; $4704
	ld a,(de)		; $4706
	cp $0a			; $4707
	ret nc			; $4709

	ld c,$2c		; $470a
	call objectCheckLinkWithinDistance		; $470c
	ret nc			; $470f

	ld e,Enemy.state		; $4710
	ld a,$0a		; $4712
	ld (de),a		; $4714
	ret			; $4715

;;
; Unused
; @addr{4716}
_stalfos_setState8:
	ld e,Enemy.state		; $4716
	ld a,$08		; $4718
	ld (de),a		; $471a
	ret			; $471b


; ==============================================================================
; ENEMYID_KEESE
;
; Variables (for subid 1 only, the one that moves as Link approaches):
;   var30: Amount to add to angle each frame. (Clockwise or counterclockwise turning)
; ==============================================================================
enemyCode32:
	jr z,@normalStatus	; $471c
	sub ENEMYSTATUS_NO_HEALTH			; $471e
	ret c			; $4720
	jp z,enemyDie		; $4721
	dec a			; $4724
	jp nz,_ecom_updateKnockbackNoSolidity		; $4725
	ret			; $4728

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $4729
	jr nc,@normalState	; $472c
	rst_jumpTable			; $472e
	.dw _keese_state_uninitialized
	.dw _keese_state_stub
	.dw _keese_state_stub
	.dw _keese_state_stub
	.dw _keese_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _keese_state_stub
	.dw _keese_state_stub

@normalState:
	ld a,b			; $473f
	rst_jumpTable			; $4740
	.dw _keese_subid00
	.dw _keese_subid01


_keese_state_uninitialized:
	call _ecom_setSpeedAndState8		; $4745
	call _keese_initializeSubid		; $4748
	jp objectSetVisible82		; $474b


_keese_state_stub:
	ret			; $474e


_keese_subid00:
	ld a,(de)		; $474f
	sub $08			; $4750
	rst_jumpTable			; $4752
	.dw _keese_subid00_state8
	.dw _keese_subid00_state9
	.dw _keese_subid00_stateA


; Resting for [counter1] frames
_keese_subid00_state8:
	call _ecom_decCounter1		; $4759
	ret nz			; $475c

	; Choose random angle and counter1
	ld bc,$1f3f		; $475d
	call _ecom_randomBitwiseAndBCE		; $4760
	call _ecom_incState		; $4763

	ld l,Enemy.angle		; $4766
	ld (hl),b		; $4768
	ld l,Enemy.speed		; $4769
	ld (hl),SPEED_c0		; $476b

	ld a,$c0		; $476d
	add c			; $476f
	ld l,Enemy.counter1		; $4770
	ld (hl),a		; $4772

	ld a,$01		; $4773
	call enemySetAnimation		; $4775
	jr _keese_animate		; $4778


; Moving in some direction for [counter1] frames
_keese_subid00_state9:
	call objectApplySpeed		; $477a
	call _ecom_bounceOffScreenBoundary		; $477d
	ld a,(wFrameCounter)		; $4780
	rrca			; $4783
	jr c,_keese_animate	; $4784

	call _ecom_decCounter1		; $4786
	jr z,@timeToStop			; $4789

	; 1 in 16 chance, per frame, of randomly choosing a new angle to move in
	ld bc,$0f1f		; $478b
	call _ecom_randomBitwiseAndBCE		; $478e
	or b			; $4791
	jr nz,_keese_animate	; $4792

	ld e,Enemy.angle		; $4794
	ld a,c			; $4796
	ld (de),a		; $4797
	jr _keese_animate		; $4798

@timeToStop:
	ld l,Enemy.state		; $479a
	inc (hl)		; $479c

_keese_animate:
	jp enemyAnimate		; $479d


; Decelerating until [counter1] counts up to $7f, when it stops completely.
_keese_subid00_stateA:
	ld e,Enemy.counter1		; $47a0
	ld a,(de)		; $47a2
	cp $68			; $47a3
	jr nc,++		; $47a5
	call objectApplySpeed		; $47a7
	call _ecom_bounceOffScreenBoundary		; $47aa
++
	call _keese_updateDeceleration		; $47ad
	ld h,d			; $47b0
	ld l,Enemy.counter1		; $47b1
	inc (hl)		; $47b3

	ld a,$7f		; $47b4
	cp (hl)			; $47b6
	ret nz			; $47b7

	; Full stop
	ld l,Enemy.state		; $47b8
	ld (hl),$08		; $47ba

	; Set counter1 randomly
	call getRandomNumber_noPreserveVars		; $47bc
	and $7f			; $47bf
	ld e,Enemy.counter1		; $47c1
	add $20			; $47c3
	ld (de),a		; $47c5
	xor a			; $47c6
	jp enemySetAnimation		; $47c7


_keese_subid01:
	ld a,(de)		; $47ca
	sub $08			; $47cb
	rst_jumpTable			; $47cd
	.dw _keese_subid01_state8
	.dw _keese_subid02_state9


; Waiting for Link to approach
_keese_subid01_state8:
	ld c,$31		; $47d2
	call objectCheckLinkWithinDistance		; $47d4
	ret nc			; $47d7

	call _ecom_updateAngleTowardTarget		; $47d8
	call _ecom_incState		; $47db

	ld l,Enemy.speed		; $47de
	ld (hl),SPEED_100		; $47e0

	; Turn clockwise or counterclockwise, based on var30
	ld e,Enemy.angle		; $47e2
	ld l,Enemy.var30		; $47e4
	ld a,(de)		; $47e6
	add (hl)		; $47e7
	and $1f			; $47e8
	ld (de),a		; $47ea

	ld l,Enemy.counter1		; $47eb
	ld (hl),12		; $47ed
	inc l			; $47ef
	ld (hl),12 ; [counter2]

	ld a,$01		; $47f2
	jp enemySetAnimation		; $47f4


_keese_subid02_state9:
	call objectApplySpeed		; $47f7
	call _ecom_bounceOffScreenBoundary		; $47fa
	call _ecom_decCounter1		; $47fd
	jr nz,_keese_animate	; $4800

	ld (hl),12 ; [counter1]

	; Turn clockwise or counterclockwise, based on var30
	ld l,Enemy.var30		; $4804
	ld e,Enemy.angle		; $4806
	ld a,(de)		; $4808
	add (hl)		; $4809
	and $1f			; $480a
	ld (de),a		; $480c

	ld l,Enemy.counter2		; $480d
	dec (hl)		; $480f
	jr nz,_keese_animate	; $4810

	; Done moving.
	ld l,Enemy.state		; $4812
	dec (hl)		; $4814
	call _keese_chooseWhetherToReverseTurningAngle		; $4815
	xor a			; $4818
	jp enemySetAnimation		; $4819


;;
; Every 16 frames (based on counter1) this updates the keese's speed as it's decelerating.
; Also handles the animation (which slows down).
; @addr{481c}
_keese_updateDeceleration:
	ld e,Enemy.counter1		; $481c
	ld a,(de)		; $481e
	and $0f			; $481f
	jr nz,++		; $4821

	ld a,(de)		; $4823
	swap a			; $4824
	ld hl,@speeds		; $4826
	rst_addAToHl			; $4829
	ld a,(hl)		; $482a
	ld e,Enemy.speed		; $482b
	ld (de),a		; $482d
++
	ld e,Enemy.counter1		; $482e
	ld a,(de)		; $4830
	and $f0			; $4831
	swap a			; $4833
	ld hl,@bits		; $4835
	rst_addAToHl			; $4838
	ld a,(wFrameCounter)		; $4839
	and (hl)		; $483c
	jp z,enemyAnimate		; $483d
	ret			; $4840

@speeds:
	.db SPEED_c0, SPEED_80, SPEED_40, SPEED_40, SPEED_20, SPEED_20, SPEED_20, SPEED_20

@bits:
	.db $00 $00 $01 $01 $03 $03 $07 $00


;;
; @addr{4851}
_keese_initializeSubid:
	dec b			; $4851
	jr z,@subid1			; $4852

@subid0:
	; Just set how long to wait initially
	ld l,Enemy.counter1		; $4854
	ld (hl),$20		; $4856
	ret			; $4858

@subid1:
	ld l,Enemy.zh		; $4859
	ld (hl),$ff		; $485b

	ld l,Enemy.var30		; $485d
	ld (hl),$02		; $485f

;;
; For subid 1 only, this has a 1 in 4 chance of deciding to reverse the turning angle
; (clockwise or counterclockwise).
; @addr{4861}
_keese_chooseWhetherToReverseTurningAngle:
	call getRandomNumber_noPreserveVars		; $4861
	and $03			; $4864
	ret nz			; $4866

	ld e,Enemy.var30		; $4867
	ld a,(de)		; $4869
	cpl			; $486a
	inc a			; $486b
	ld (de),a		; $486c
	ret			; $486d


; ==============================================================================
; ENEMYID_BABY_CUCCO
; ==============================================================================
enemyCode33:
	ld e,Enemy.state		; $486e
	ld a,(de)		; $4870
	rst_jumpTable			; $4871
	.dw _babyCucco_state_uninitialized
	.dw _babyCucco_state_stub
	.dw _babyCucco_state_grabbed
	.dw _babyCucco_state_stub
	.dw _babyCucco_state_stub
	.dw _babyCucco_state_stub
	.dw _babyCucco_state_stub
	.dw _babyCucco_state_stub
	.dw _babyCucco_state8
	.dw _babyCucco_state9


_babyCucco_state_uninitialized:
	ld a,SPEED_40		; $4886
	jp _ecom_setSpeedAndState8AndVisible		; $4888


_babyCucco_state_grabbed:
	inc e			; $488b
	ld a,(de)		; $488c
	rst_jumpTable			; $488d
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @landed

@justGrabbed:
	ld h,d			; $4896
	ld l,e			; $4897
	inc (hl) ; [state2]

	ld l,Enemy.collisionType		; $4899
	res 7,(hl)		; $489b

	xor a			; $489d
	ld (wLinkGrabState2),a		; $489e

	ld a,(w1Link.direction)		; $48a1
	srl a			; $48a4
	xor $01			; $48a6
	ld l,Enemy.direction		; $48a8
	ld (hl),a		; $48aa
	call enemySetAnimation		; $48ab

	jp objectSetVisiblec1		; $48ae

@beingHeld:
	ld h,d			; $48b1
	ld l,Enemy.direction		; $48b2
	ld a,(w1Link.direction)		; $48b4
	srl a			; $48b7
	xor $01			; $48b9
	cp (hl)			; $48bb
	jr z,@released		; $48bc
	ld (hl),a		; $48be
	jp enemySetAnimation		; $48bf

@released:
	ld e,Enemy.yh		; $48c2
	ld a,(de)		; $48c4
	cp SMALL_ROOM_HEIGHT<<4			; $48c5
	jr nc,@delete		; $48c7

	ld e,Enemy.xh		; $48c9
	ld a,(de)		; $48cb
	cp SMALL_ROOM_WIDTH<<4			; $48cc
	jp c,enemyAnimate		; $48ce
@delete:
	jp enemyDelete		; $48d1

@landed:
	ld h,d			; $48d4
	ld l,Enemy.state		; $48d5
	ld (hl),$08		; $48d7
	ld l,Enemy.collisionType		; $48d9
	set 7,(hl)		; $48db
	ld l,Enemy.direction		; $48dd
	ld (hl),$ff		; $48df
	jp objectSetVisiblec2		; $48e1


_babyCucco_state_stub:
	ret			; $48e4


_babyCucco_state8:
	call objectAddToGrabbableObjectBuffer		; $48e5
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $48e8

	call _ecom_updateAngleTowardTarget		; $48eb
	call _babyCucco_updateAnimationFromAngle		; $48ee

	ld c,$10		; $48f1
	call objectCheckLinkWithinDistance		; $48f3
	jr nc,@moveCloserToLink	; $48f6

	; If near Link, 1 in 64 chance of hopping (per frame)
	call getRandomNumber_noPreserveVars		; $48f8
	and $3f			; $48fb
	ret nz			; $48fd

	call _ecom_incState		; $48fe
	ld l,Enemy.speedZ		; $4901
	ld a,<($ff40)		; $4903
	ldi (hl),a		; $4905
	ld (hl),>($ff40)		; $4906
	ret			; $4908

@moveCloserToLink:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4909

_babyCucco_animate:
	jp enemyAnimate		; $490c


; Hopping
_babyCucco_state9:
	ld c,$12		; $490f
	call objectUpdateSpeedZ_paramC		; $4911
	jr nz,_babyCucco_animate	; $4914

	ld l,Enemy.state		; $4916
	dec (hl)		; $4918
	ret			; $4919


;;
; @addr{491a}
_babyCucco_updateAnimationFromAngle:
	ld e,Enemy.angle		; $491a
	ld a,(de)		; $491c
	cp $10			; $491d
	ld a,$01		; $491f
	jr c,+			; $4921
	xor a			; $4923
+
	ld h,d			; $4924
	ld l,Enemy.direction		; $4925
	cp (hl)			; $4927
	ret z			; $4928
	ld (hl),a		; $4929
	jp enemySetAnimation		; $492a


; ==============================================================================
; ENEMYID_ZOL
;
; Variables:
;   var30: 1 when the zol is out of the ground, 0 otherwise. (only for subid 0, and only
;          used to prevent the "jump" sound effect from playing more than once.)
; ==============================================================================
enemyCode34:
	call _ecom_checkHazardsNoAnimationForHoles		; $492d
	jr z,@normalStatus	; $4930
	sub ENEMYSTATUS_NO_HEALTH			; $4932
	ret c			; $4934
	jp z,enemyDie		; $4935
	dec a			; $4938
	jp nz,_ecom_updateKnockbackAndCheckHazardsNoAnimationsForHoles		; $4939

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.subid		; $493c
	ld a,(de)		; $493e
	or a			; $493f
	ret z			; $4940

	; Subid 1 only: Collision with anything except Link or a shield causes it to
	; split in two.
	ld e,Enemy.var2a		; $4941
	ld a,(de)		; $4943
	cp ITEMCOLLISION_LINK|$80			; $4944
	jr z,@normalStatus	; $4946

	res 7,a			; $4948
	sub ITEMCOLLISION_L1_SHIELD			; $494a
	cp ITEMCOLLISION_L3_SHIELD - ITEMCOLLISION_L1_SHIELD + 1			; $494c
	ret c			; $494e

	ld e,Enemy.state		; $494f
	ld a,$0c		; $4951
	ld (de),a		; $4953
	ret			; $4954

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $4955
	jr nc,@normalState	; $4958
	rst_jumpTable			; $495a
	.dw _zol_state_uninitialized
	.dw _zol_state_stub
	.dw _zol_state_stub
	.dw _zol_state_stub
	.dw _zol_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _zol_state_stub
	.dw _zol_state_stub

@normalState:
	ld a,b			; $496b
	rst_jumpTable			; $496c
	.dw _zol_subid00
	.dw _zol_subid01


_zol_state_uninitialized:
	ld a,b			; $4971
	or a			; $4972
	ld a,SPEED_c0		; $4973
	jp z,_ecom_setSpeedAndState8		; $4975

	; Subid 1 only
	ld h,d			; $4978
	ld l,Enemy.counter1		; $4979
	ld (hl),$18		; $497b
	ld l,Enemy.collisionType		; $497d
	set 7,(hl)		; $497f

	ld a,$04		; $4981
	call enemySetAnimation		; $4983
	jp _ecom_setSpeedAndState8AndVisible		; $4986


_zol_state_stub:
	ret			; $4989


_zol_subid00:
	ld a,(de)		; $498a
	sub $08			; $498b
	rst_jumpTable			; $498d
	.dw _zol_subid00_state8
	.dw _zol_subid00_state9
	.dw _zol_subid00_stateA
	.dw _zol_subid00_stateB
	.dw _zol_subid00_stateC
	.dw _zol_subid00_stateD


; Hiding in ground, waiting for Link to approach
_zol_subid00_state8:
	ld c,$28		; $499a
	call objectCheckLinkWithinDistance		; $499c
	ret nc			; $499f

	ld bc,-$200		; $49a0
	call objectSetSpeedZ		; $49a3

	ld l,Enemy.state		; $49a6
	inc (hl)		; $49a8

	; [counter2] = number of hops before disappearing
	ld l,Enemy.counter2		; $49a9
	ld (hl),$04		; $49ab

	jp objectSetVisiblec2		; $49ad


; Jumping out of ground
_zol_subid00_state9:
	ld h,d			; $49b0
	ld l,Enemy.animParameter		; $49b1
	ld a,(hl)		; $49b3
	or a			; $49b4
	jr z,_zol_animate	; $49b5

	ld l,Enemy.var30		; $49b7
	and (hl)		; $49b9
	jr nz,++		; $49ba
	ld (hl),$01		; $49bc
	ld a,SND_ENEMY_JUMP		; $49be
	call playSound		; $49c0
++
	ld c,$28		; $49c3
	call objectUpdateSpeedZ_paramC		; $49c5
	ret nz			; $49c8

	; Landed on ground; go to next state
	call _ecom_incState		; $49c9

	ld l,Enemy.counter1		; $49cc
	ld (hl),$30		; $49ce

	ld l,Enemy.collisionType		; $49d0
	set 7,(hl)		; $49d2
	inc a			; $49d4
	jp enemySetAnimation		; $49d5


; Holding still for [counter1] frames, preparing to hop toward Link
_zol_subid00_stateA:
	call _ecom_decCounter1		; $49d8
	ret nz			; $49db

	ld l,e			; $49dc
	inc (hl) ; [state]

	ld bc,-$200		; $49de
	call objectSetSpeedZ		; $49e1

	call _ecom_updateAngleTowardTarget		; $49e4

	ld a,$02		; $49e7
	call enemySetAnimation		; $49e9

	ld a,SND_ENEMY_JUMP		; $49ec
	call playSound		; $49ee

_zol_animate:
	jp enemyAnimate		; $49f1


; Hopping toward Link
_zol_subid00_stateB:
	call _ecom_applyVelocityForSideviewEnemy		; $49f4

	ld c,$28		; $49f7
	call objectUpdateSpeedZ_paramC		; $49f9
	ret nz			; $49fc

	; Hit the ground

	ld h,d			; $49fd
	ld l,Enemy.counter1		; $49fe
	ld (hl),$30		; $4a00
	inc l			; $4a02
	dec (hl) ; [counter2]-- (number of hops remaining)

	ld a,$0a		; $4a04
	ld b,$01		; $4a06
	jr nz,++		; $4a08

	; [counter2] == 0; go to state $0c, and disable collisions as we're disappearing
	; now
	ld l,Enemy.collisionType		; $4a0a
	res 7,(hl)		; $4a0c
	ld a,$0c		; $4a0e
	ld b,$03		; $4a10
++
	ld l,Enemy.state		; $4a12
	ld (hl),a		; $4a14
	ld a,b			; $4a15
	jp enemySetAnimation		; $4a16


; Disappearing into the ground
_zol_subid00_stateC:
	ld h,d			; $4a19
	ld l,Enemy.animParameter		; $4a1a
	ld a,(hl)		; $4a1c
	or a			; $4a1d
	jr z,_zol_animate	; $4a1e

	ld l,e			; $4a20
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $4a22
	ld (hl),40		; $4a24

	ld l,Enemy.var30		; $4a26
	xor a			; $4a28
	ld (hl),a		; $4a29

	call enemySetAnimation		; $4a2a
	jp objectSetInvisible		; $4a2d


; Fully disappeared into ground. Wait [counter1] frames before we can emerge again
_zol_subid00_stateD:
	call _ecom_decCounter1		; $4a30
	ret nz			; $4a33

	ld l,e			; $4a34
	ld (hl),$08 ; [state]

	xor a			; $4a37
	jp enemySetAnimation		; $4a38


_zol_subid01:
	ld a,(de)		; $4a3b
	sub $08			; $4a3c
	rst_jumpTable			; $4a3e
	.dw _zol_subid01_state8
	.dw _zol_subid01_state9
	.dw _zol_subid01_stateA
	.dw _zol_subid01_stateB
	.dw _zol_subid01_stateC
	.dw _zol_subid01_stateD


; Holding still for [counter1] frames before deciding whether to hop or move forward
_zol_subid01_state8:
	call _ecom_decCounter1		; $4a4b
	jr nz,_zol_animate2	; $4a4e

	; 1 in 8 chance of hopping toward Link
	call getRandomNumber_noPreserveVars		; $4a50
	and $07			; $4a53
	ld h,d			; $4a55
	ld l,Enemy.counter1		; $4a56
	jr z,@hopTowardLink	; $4a58

	; 7 in 8 chance of sliding toward Link
	ld (hl),$10 ; [counter1]
	ld l,Enemy.state		; $4a5c
	inc (hl)		; $4a5e

	ld l,Enemy.speed		; $4a5f
	ld (hl),SPEED_80		; $4a61
	call _ecom_updateAngleTowardTarget		; $4a63
	jr _zol_animate2		; $4a66

@hopTowardLink:
	ld (hl),$20 ; [counter1]
	ld l,Enemy.state		; $4a6a
	ld (hl),$0a		; $4a6c
	ld a,$05		; $4a6e
	jp enemySetAnimation		; $4a70


; Sliding toward Link
_zol_subid01_state9:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4a73
	call _ecom_bounceOffScreenBoundary		; $4a76

	call _ecom_decCounter1		; $4a79
	jr nz,_zol_animate2	; $4a7c

	ld (hl),$18 ; [counter1]
	ld l,Enemy.state		; $4a80
	dec (hl)		; $4a82

_zol_animate2:
	jp enemyAnimate		; $4a83


; Shaking before hopping toward Link
_zol_subid01_stateA:
	call _ecom_decCounter1		; $4a86
	jr nz,_zol_animate2	; $4a89

	call _ecom_incState		; $4a8b

	ld l,Enemy.speedZ		; $4a8e
	ld (hl),<(-$200)		; $4a90
	inc l			; $4a92
	ld (hl),>(-$200)		; $4a93

	ld l,Enemy.speed		; $4a95
	ld (hl),SPEED_100		; $4a97
	call _ecom_updateAngleTowardTarget		; $4a99

	ld a,$02		; $4a9c
	call enemySetAnimation		; $4a9e
	ld a,SND_ENEMY_JUMP		; $4aa1
	call playSound		; $4aa3

	jp objectSetVisiblec1		; $4aa6


; Hopping toward Link
_zol_subid01_stateB:
	call _ecom_applyVelocityForSideviewEnemy		; $4aa9
	ld c,$28		; $4aac
	call objectUpdateSpeedZ_paramC		; $4aae
	ret nz			; $4ab1

	; Hit ground
	ld h,d			; $4ab2
	ld l,Enemy.counter1		; $4ab3
	ld (hl),$18		; $4ab5

	ld l,Enemy.state		; $4ab7
	ld (hl),$08		; $4ab9

	ld a,$04		; $4abb
	call enemySetAnimation		; $4abd
	jp objectSetVisiblec2		; $4ac0


; Zol has been attacked, create puff, disable collisions, prepare to spawn two gels in the
; zol's place.
_zol_subid01_stateC:
	ld b,INTERACID_KILLENEMYPUFF		; $4ac3
	call objectCreateInteractionWithSubid00		; $4ac5

	ld h,d			; $4ac8
	ld l,Enemy.counter2		; $4ac9
	ld (hl),18		; $4acb

	ld l,Enemy.collisionType		; $4acd
	res 7,(hl)		; $4acf

	ld l,Enemy.state		; $4ad1
	inc (hl)		; $4ad3

	ld a,SND_KILLENEMY		; $4ad4
	call playSound		; $4ad6

	jp objectSetInvisible		; $4ad9


; Zol has been attacked, spawn gels after [counter2] frames
_zol_subid01_stateD:
	call _ecom_decCounter2		; $4adc
	ret nz			; $4adf

	ld c,$04		; $4ae0
	call _zol_spawnGel		; $4ae2
	ld c,-$04		; $4ae5
	call _zol_spawnGel		; $4ae7

	call decNumEnemies		; $4aea
	jp enemyDelete		; $4aed

;;
; @param	c	X offset
; @addr{4af0}
_zol_spawnGel:
	ld b,ENEMYID_GEL		; $4af0
	call _ecom_spawnEnemyWithSubid01		; $4af2
	ret nz			; $4af5

	ld (hl),a ; [child.subid] = 0
	ld b,$00		; $4af7
	call objectCopyPositionWithOffset		; $4af9

	xor a			; $4afc
	ld l,Enemy.z		; $4afd
	ldi (hl),a		; $4aff
	ld (hl),a		; $4b00

	; Transfer "enemy index" to gel
	ld l,Enemy.enabled		; $4b01
	ld e,l			; $4b03
	ld a,(de)		; $4b04
	ld (hl),a		; $4b05
	ret			; $4b06


; ==============================================================================
; ENEMYID_FLOORMASTER
;
; Variables for subids other than 0:
;   relatedObj1: Reference to spawner object (subid 0)
;   var30: Animation index
;   var31: Index for z-position to use while chasing Link (0-7)
;   var32: Angle relative to Link where floormaster should spawn
;
; Variables for spawner (subid 0):
;   var30: Number of floormaster currently spawned (they delete themselves after
;          disappearing into the ground)
;   var31/var32: Link's position last time a floormaster was spawned. If Link hasn't moved
;                far from here, the floormaster will spawn at a random angle relative to
;                him; otherwise it will spawn in the direction Link is moving.
;   var33: # floormasters to spawn. Children decrement this when they're killed.
;          (High nibble of original Y value.)
;   var34: Subid for child objects (high nibble of original X value, plus one)
; ==============================================================================
enemyCode35:
	jr z,@normalStatus	; $4b07
	sub ENEMYSTATUS_NO_HEALTH			; $4b09
	ret c			; $4b0b
	jr z,@dead	; $4b0c
	dec a			; $4b0e
	jp nz,_ecom_updateKnockbackNoSolidity		; $4b0f

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a		; $4b12
	ld a,(de)		; $4b14
	cp $80|ITEMCOLLISION_LINK			; $4b15
	ret nz			; $4b17

	; Grabbed Link
	ld h,d			; $4b18
	ld l,Enemy.state		; $4b19
	ld (hl),$0c		; $4b1b
	ld l,Enemy.zh		; $4b1d
	ld (hl),$fb		; $4b1f

	call _floormaster_updateAngleTowardLink		; $4b21
	add $04			; $4b24
	call enemySetAnimation		; $4b26

	; Move to halfway point between Link and floormaster
	ld h,d			; $4b29
	ld l,Enemy.yh		; $4b2a
	ld a,(w1Link.yh)		; $4b2c
	sub (hl)		; $4b2f
	sra a			; $4b30
	add (hl)		; $4b32
	ld (hl),a		; $4b33

	ld l,Enemy.xh		; $4b34
	ld a,(w1Link.xh)		; $4b36
	sub (hl)		; $4b39
	sra a			; $4b3a
	add (hl)		; $4b3c
	ld (hl),a		; $4b3d
	ret			; $4b3e

@dead:
	ld a,Object.var30		; $4b3f
	call objectGetRelatedObject1Var		; $4b41
	dec (hl)		; $4b44
	ld l,Enemy.var33		; $4b45
	dec (hl)		; $4b47
	jp enemyDie_uncounted		; $4b48

@normalStatus:
	ld e,Enemy.state		; $4b4b
	ld a,(de)		; $4b4d
	rst_jumpTable			; $4b4e
	.dw _floormaster_state_uninitialized
	.dw _floormaster_state1
	.dw _floormaster_state_stub
	.dw _floormaster_state_stub
	.dw _floormaster_state_stub
	.dw _floormaster_state_galeSeed
	.dw _floormaster_state_stub
	.dw _floormaster_state_stub
	.dw _floormaster_state8
	.dw _floormaster_state9
	.dw _floormaster_stateA
	.dw _floormaster_stateB
	.dw _floormaster_stateC
	.dw _floormaster_stateD


_floormaster_state_uninitialized:
	ld h,d			; $4b6b
	ld l,Enemy.counter1		; $4b6c
	ld (hl),60		; $4b6e
	ld l,e			; $4b70
	inc (hl) ; [state] = 1

	ld e,Enemy.subid		; $4b72
	ld a,(de)		; $4b74
	or a			; $4b75
	jp z,_floormaster_initSpawner		; $4b76

	; Subid 1 only
	ld (hl),$08 ; [state] = 8
	ret			; $4b7b


; State 1: only for subid 0 (spawner).
_floormaster_state1:
	; Delete self if all floormasters were killed
	ld h,d			; $4b7c
	ld l,Enemy.var33		; $4b7d
	ld a,(hl)		; $4b7f
	or a			; $4b80
	jr z,@delete	; $4b81

	; Return if all available floormasters have spawned already
	ld e,Enemy.var30		; $4b83
	ld a,(de)		; $4b85
	sub (hl)		; $4b86
	ret nc			; $4b87

	; Spawn another floormaster in [counter1] frames
	ld l,Enemy.counter1		; $4b88
	dec (hl)		; $4b8a
	ret nz			; $4b8b

	ld (hl),$01 ; [counter1]

	; Maximum of 3 on-screen at any given time
	ld l,Enemy.var30		; $4b8e
	ld a,(hl)		; $4b90
	cp $03			; $4b91
	ret nc			; $4b93

	ld b,ENEMYID_FLOORMASTER		; $4b94
	call _ecom_spawnUncountedEnemyWithSubid01		; $4b96
	ret nz			; $4b99

	ld e,Enemy.var34		; $4b9a
	ld a,(de)		; $4b9c
	ld (hl),a ; [child.subid] = [this.var34]

	ld l,Enemy.relatedObj1		; $4b9e
	ld a,Enemy.start		; $4ba0
	ldi (hl),a		; $4ba2
	ld (hl),d		; $4ba3

	ld h,d			; $4ba4
	ld l,Enemy.var30		; $4ba5
	inc (hl)		; $4ba7

	ld l,Enemy.counter1		; $4ba8
	ld (hl),$80		; $4baa
	ret			; $4bac

@delete:
	call decNumEnemies		; $4bad
	call markEnemyAsKilledInRoom		; $4bb0
	jp enemyDelete		; $4bb3


_floormaster_state_galeSeed:
	call _ecom_galeSeedEffect		; $4bb6
	ret c			; $4bb9

	ld a,Object.var30		; $4bba
	call objectGetRelatedObject1Var		; $4bbc
	dec (hl)		; $4bbf
	ld l,Enemy.var33		; $4bc0
	dec (hl)		; $4bc2
	jp enemyDelete		; $4bc3


_floormaster_state_stub:
	ret			; $4bc6


; States 8+ are for subids 1+ (not spawner objects; actual, physical floormasters).

; Choosing a position to spawn at.
_floormaster_state8:
	; If Link is within 8 pixels of his position last time a floormaster was spawned,
	; the floormaster will spawn at a random angle relative to Link. Otherwise, it
	; will spawn in the direction Link is moving.
	call _floormaster_checkLinkMoved8PixelsAway		; $4bc7
	ld a,$00		; $4bca
	push bc			; $4bcc
	call c,getRandomNumber_noPreserveVars		; $4bcd
	pop bc			; $4bd0

	ld e,a			; $4bd1
	ld a,(w1Link.angle)		; $4bd2
	add e			; $4bd5
	and $1f			; $4bd6
	ld e,Enemy.var32		; $4bd8
	ld (de),a		; $4bda

	; Try various distances away from Link ($50 to $10)
	ld a,$50		; $4bdb
	ldh (<hFF8A),a	; $4bdd

@tryDistance:
	ldh a,(<hFF8A)	; $4bdf
	sub $10			; $4be1
	jr z,@doneLoop	; $4be3
	ldh (<hFF8A),a	; $4be5

	push bc			; $4be7
	ld e,Enemy.var32		; $4be8
	call objectSetPositionInCircleArc		; $4bea
	pop bc			; $4bed

	; Check that this position candidate is valid.

	; a = abs([w1Link.xh] - [this.xh])
	ld a,(de)		; $4bee
	ld e,a			; $4bef
	ld a,(w1Link.xh)		; $4bf0
	sub e			; $4bf3
	jr nc,+			; $4bf4
	cpl			; $4bf6
	inc a			; $4bf7
+
	cp $80			; $4bf8
	jr nc,@tryDistance	; $4bfa

	ld e,Enemy.yh		; $4bfc
	ld a,(de)		; $4bfe
	cp LARGE_ROOM_HEIGHT<<4			; $4bff
	jr nc,@tryDistance	; $4c01

	; Tile must not be solid
	push bc			; $4c03
	call objectGetTileCollisions		; $4c04
	pop bc			; $4c07
	jr nz,@tryDistance	; $4c08

	; Found a valid position. Go to state 9
	ld h,d			; $4c0a
	ld l,Enemy.state		; $4c0b
	ld (hl),$09		; $4c0d

	ld l,Enemy.counter1		; $4c0f
	ld (hl),$20		; $4c11

	call objectGetAngleTowardEnemyTarget		; $4c13
	ld b,a			; $4c16

	; Subid 1 only: angle must be a cardinal direction
	ld e,Enemy.subid		; $4c17
	ld a,(de)		; $4c19
	dec a			; $4c1a
	ld a,b			; $4c1b
	jr nz,+			; $4c1c
	add $04			; $4c1e
	and $18			; $4c20
+
	ld e,Enemy.angle		; $4c22
	ld (de),a		; $4c24

	; Decide animation to use
	cp $10			; $4c25
	ld a,$00		; $4c27
	jr nc,+			; $4c29
	inc a			; $4c2b
+
	ld e,Enemy.var30		; $4c2c
	ld (de),a		; $4c2e
	call enemySetAnimation		; $4c2f
	call objectSetVisiblec1		; $4c32

@doneLoop:
	; Copy Link's position to spawner.var31/var32
	ld e,Enemy.relatedObj1+1		; $4c35
	ld a,(de)		; $4c37
	ld h,a			; $4c38
	ld l,Enemy.var31		; $4c39
	ld a,(w1Link.yh)		; $4c3b
	ldi (hl),a		; $4c3e
	ld a,(w1Link.xh)		; $4c3f
	ld (hl),a		; $4c42
	ret			; $4c43


; Emerging from ground
_floormaster_state9:
	ld e,Enemy.animParameter		; $4c44
	ld a,(de)		; $4c46
	dec a			; $4c47
	jp nz,enemyAnimate		; $4c48

	ld e,Enemy.state		; $4c4b
	ld a,$0a		; $4c4d
	ld (de),a		; $4c4f

	ld e,Enemy.var30		; $4c50
	ld a,(de)		; $4c52
	add $02			; $4c53
	jp enemySetAnimation		; $4c55


; Floating in place for [counter1] frames before chasing Link
_floormaster_stateA:
	call _ecom_decCounter1		; $4c58
	jr z,@beginChasing	; $4c5b

	ld a,(hl)		; $4c5d
	srl a			; $4c5e
	srl a			; $4c60
	ld hl,@zVals		; $4c62
	rst_addAToHl			; $4c65
	ld a,(hl)		; $4c66
	ld e,Enemy.zh		; $4c67
	ld (de),a		; $4c69
	ret			; $4c6a

@beginChasing:
	ld (hl),$f0 ; [counter1]

	ld l,Enemy.collisionType		; $4c6d
	set 7,(hl)		; $4c6f

	ld l,Enemy.state		; $4c71
	ld (hl),$0b		; $4c73

	call _floormaster_updateAngleTowardLink		; $4c75
	ld b,a			; $4c78

	ld e,Enemy.relatedObj1+1		; $4c79
	ld a,(de)		; $4c7b
	ld h,a			; $4c7c
	ld l,Enemy.xh		; $4c7d
	bit 5,(hl)		; $4c7f

	; Certain subids have higher speed?
	ld h,d			; $4c81
	ld l,Enemy.speed		; $4c82
	ld (hl),SPEED_60		; $4c84
	jr z,+			; $4c86
	ld (hl),SPEED_a0		; $4c88
+
	ld a,b			; $4c8a
	add $02			; $4c8b
	call enemySetAnimation		; $4c8d
	jr _floormaster_animate		; $4c90

@zVals:
	.db $fb $fc $fd $fd $fe $fe $ff $ff


; Chasing Link
_floormaster_stateB:
	call _ecom_decCounter1		; $4c9a
	jr nz,@stillChasing	; $4c9d

	; Time to go back into ground
	ld l,Enemy.zh		; $4c9f
	ld (hl),$00		; $4ca1
	ld l,Enemy.collisionType		; $4ca3
	res 7,(hl)		; $4ca5

	ld l,e			; $4ca7
	ld (hl),$0d ; [state]

	ld l,Enemy.var30		; $4caa
	ld a,$06		; $4cac
	add (hl)		; $4cae
	jp enemySetAnimation		; $4caf

@stillChasing:
	ld e,Enemy.var30		; $4cb2
	ld a,(de)		; $4cb4
	ldh (<hFF8D),a	; $4cb5

	call _floormaster_updateAngleTowardLink		; $4cb7
	ld b,a			; $4cba
	ldh a,(<hFF8D)	; $4cbb
	cp b			; $4cbd
	jr z,++			; $4cbe
	ld a,$02		; $4cc0
	add b			; $4cc2
	call enemySetAnimation		; $4cc3
++
	call _floormaster_updateZPosition		; $4cc6
	call _floormaster_getAdjacentWallsBitset		; $4cc9
	call _ecom_applyVelocityGivenAdjacentWalls		; $4ccc

_floormaster_animate:
	jp enemyAnimate		; $4ccf


; Grabbing Link
_floormaster_stateC:
	ld e,Enemy.animParameter		; $4cd2
	ld a,(de)		; $4cd4
	dec a			; $4cd5
	jr z,@makeLinkInvisible	; $4cd6
	dec a			; $4cd8
	jr z,@setZToZero	; $4cd9
	dec a			; $4cdb
	jr nz,_floormaster_animate	; $4cdc

	; [animParameter] == 3
	; Set state2 for LINK_STATE_GRABBED_BY_WALLMASTER
	ld a,$02		; $4cde
	ld (w1Link.state2),a		; $4ce0
	jp objectSetInvisible		; $4ce3

@makeLinkInvisible: ; [animParameter] == 1
	ld (de),a		; $4ce6
	ld (w1Link.visible),a		; $4ce7

	ld e,Enemy.yh		; $4cea
	ld a,(w1Link.yh)		; $4cec
	ld (de),a		; $4cef
	ld e,Enemy.xh		; $4cf0
	ld a,(w1Link.xh)		; $4cf2
	ld (de),a		; $4cf5
	ret			; $4cf6

@setZToZero: ; [animParameter] == 2
	xor a			; $4cf7
	ld (de),a		; $4cf8
	ld e,Enemy.zh		; $4cf9
	ld (de),a		; $4cfb
	jr _floormaster_animate		; $4cfc


; Sinking into ground
_floormaster_stateD:
	ld e,Enemy.animParameter		; $4cfe
	ld a,(de)		; $4d00
	cp $03			; $4d01
	jr nz,_floormaster_animate	; $4d03

	; Tell spawner that there's one less floormaster on-screen before deleting self
	ld e,Enemy.relatedObj1+1		; $4d05
	ld a,(de)		; $4d07
	ld h,a			; $4d08
	ld l,Enemy.var30		; $4d09
	dec (hl)		; $4d0b

	jp enemyDelete		; $4d0c


;;
; @param[out]	a	Value written to var30 (0 if Link is to the left, 1 if right)
; @addr{4d0f}
_floormaster_updateAngleTowardLink:
	call @checkLinkCollisionsEnabled		; $4d0f
	ret nc			; $4d12

	call objectGetAngleTowardLink		; $4d13
	ld b,a			; $4d16
	and $0f			; $4d17
	jr nz,++		; $4d19

	; Link is directly above or below the floormaster
	ld e,Enemy.angle		; $4d1b
	ld a,b			; $4d1d
	ld (de),a		; $4d1e
	ld e,Enemy.var30		; $4d1f
	ld a,(de)		; $4d21
	ret			; $4d22
++
	ld e,Enemy.subid		; $4d23
	ld a,(de)		; $4d25
	dec a			; $4d26
	ld a,b			; $4d27
	jr nz,@subid0		; $4d28

@subid1:
	; Only move in cardinal directions
	ld e,Enemy.angle		; $4d2a
	and $f8			; $4d2c
	ld (de),a		; $4d2e

	cp $10			; $4d2f
	ld a,$00		; $4d31
	jr nc,+			; $4d33
	inc a			; $4d35
+
	ld e,Enemy.var30		; $4d36
	ld (de),a		; $4d38
	ret			; $4d39

@subid0:
	ld e,Enemy.angle		; $4d3a
	ld (de),a		; $4d3c

	cp $10			; $4d3d
	ld a,$00		; $4d3f
	jr nc,+			; $4d41
	inc a			; $4d43
+
	ld e,Enemy.var30		; $4d44
	ld (de),a		; $4d46
	ret			; $4d47

;;
; @param[out]	cflag	c if Link's collisions are enabled
; @addr{4d48}
@checkLinkCollisionsEnabled:
	ld a,(w1Link.collisionType)		; $4d48
	rlca			; $4d4b
	ret c			; $4d4c
	ld e,Enemy.var30		; $4d4d
	ld a,(de)		; $4d4f
	ret			; $4d50


;;
; @addr{4d51}
_floormaster_updateZPosition:
	ld e,Enemy.counter1		; $4d51
	ld a,(de)		; $4d53
	and $07			; $4d54
	ret nz			; $4d56

	ld e,Enemy.var31		; $4d57
	ld a,(de)		; $4d59
	inc a			; $4d5a
	and $07			; $4d5b
	ld (de),a		; $4d5d
	ld hl,@zVals		; $4d5e
	rst_addAToHl			; $4d61
	ld e,Enemy.zh		; $4d62
	ld a,(hl)		; $4d64
	ld (de),a		; $4d65
	ret			; $4d66

@zVals:
	.db $fb $fc $fd $fc $fb $fa $f9 $fa



;;
; Checks whether Link has moved 8 pixels away from his position last time a floormaster
; was spawned.
;
; @param[out]	bc	Link's position
; @param[out]	cflag	c if he's within 8 pixels
; @addr{4d6f}
_floormaster_checkLinkMoved8PixelsAway:
	ld a,Object.var31		; $4d6f
	call objectGetRelatedObject1Var		; $4d71
	ld a,(w1Link.yh)		; $4d74
	ld b,a			; $4d77
	sub (hl)		; $4d78
	add $08			; $4d79
	cp $10			; $4d7b
	ld a,(w1Link.xh)		; $4d7d
	ld c,a			; $4d80
	ret nc			; $4d81

	inc l			; $4d82
	sub (hl) ; [var32]
	add $08			; $4d84
	cp $10			; $4d86
	ret			; $4d88


;;
; @addr{4d89}
_floormaster_initSpawner:
	ld e,Enemy.yh		; $4d89
	ld a,(de)		; $4d8b
	and $f0			; $4d8c
	swap a			; $4d8e
	ld e,Enemy.var33		; $4d90
	ld (de),a		; $4d92

	ld e,Enemy.xh		; $4d93
	ld a,(de)		; $4d95
	and $f0			; $4d96
	swap a			; $4d98
	inc a			; $4d9a
	ld e,Enemy.var34		; $4d9b
	ld (de),a		; $4d9d
	ret			; $4d9e

;;
; Only screen boundaries count as "walls" for floormaster.
; @addr{4d9f}
_floormaster_getAdjacentWallsBitset:
	ld a,$02		; $4d9f
	jp _ecom_getTopDownAdjacentWallsBitset		; $4da1


; ==============================================================================
; ENEMYID_CUCCO
;
; Shares some code with ENEMYID_GIANT_CUCCO.
;
; Variables:
;   relatedObj1: INTERACID_PUFF object when transforming
;   var30: Number of times it's been hit (also read by PARTID_CUCCO_ATTACKER to decide
;          speed)
;   var31: Enemy ID to transform into, when a mystery seed is used on it
;   var32: Counter used while being held
;   var33: Counter until next PARTID_CUCCO_ATTACKER is spawned
; ==============================================================================
enemyCode36:
	jr z,@normalStatus	; $4da4

	ld h,d			; $4da6
	ld l,Enemy.var2a		; $4da7
	ld a,(hl)		; $4da9
	cp $80|ITEMCOLLISION_MYSTERY_SEED			; $4daa
	jp z,_cucco_hitWithMysterySeed		; $4dac

	cp $80|ITEMCOLLISION_GALE_SEED			; $4daf
	jp nz,_cucco_attacked		; $4db1

@normalStatus:
	call _cucco_checkSpawnCuccoAttacker		; $4db4
	ld e,Enemy.state		; $4db7
	ld a,(de)		; $4db9
	rst_jumpTable			; $4dba
	.dw _cucco_state_uninitialized
	.dw _cucco_state_stub
	.dw _cucco_state_grabbed
	.dw _cucco_state_stub
	.dw _cucco_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _cucco_state_stub
	.dw _cucco_state_stub
	.dw _cucco_state8
	.dw _cucco_state9
	.dw _cucco_stateA
	.dw _cucco_stateB


_cucco_state_uninitialized:
	ld a,SPEED_80		; $4dd3
	call _ecom_setSpeedAndState8AndVisible		; $4dd5

	ld l,Enemy.var3f		; $4dd8
	set 5,(hl)		; $4dda
	ret			; $4ddc


; Also used by ENEMYID_GIANT_CUCCO
_cucco_state_grabbed:
	inc e			; $4ddd
	ld a,(de)		; $4dde
	rst_jumpTable			; $4ddf
	.dw @justGrabbed
	.dw @holding
	.dw @checkOutOfScreenBounds
	.dw @landed

@justGrabbed:
	ld h,d			; $4de8
	ld l,e			; $4de9
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $4deb
	res 7,(hl)		; $4ded
	ld l,Enemy.var32		; $4def
	xor a			; $4df1
	ld (hl),a		; $4df2
	ld (wLinkGrabState2),a		; $4df3

	ld a,(w1Link.direction)		; $4df6
	srl a			; $4df9
	xor $01			; $4dfb
	ld l,Enemy.direction		; $4dfd
	ld (hl),a		; $4dff
	call enemySetAnimation		; $4e00

	ld a,SND_CHICKEN		; $4e03
	call playSound		; $4e05
	jp objectSetVisiblec1		; $4e08

@holding:
	call _cucco_playChickenSoundEvery32Frames		; $4e0b
	ld h,d			; $4e0e
	ld l,Enemy.direction		; $4e0f
	ld a,(w1Link.direction)		; $4e11
	srl a			; $4e14
	xor $01			; $4e16
	cp (hl)			; $4e18
	jr z,@checkOutOfScreenBounds	; $4e19
	ld (hl),a		; $4e1b
	jp enemySetAnimation		; $4e1c

@checkOutOfScreenBounds:
	ld e,Enemy.yh		; $4e1f
	ld a,(de)		; $4e21
	cp SMALL_ROOM_HEIGHT<<4			; $4e22
	jr nc,++		; $4e24
	ld e,Enemy.xh		; $4e26
	ld a,(de)		; $4e28
	cp SMALL_ROOM_WIDTH<<4			; $4e29
	jp c,enemyAnimate		; $4e2b
++
	jp enemyDelete		; $4e2e

@landed:
	ld h,d			; $4e31
	ld l,Enemy.state		; $4e32
	ld (hl),$0a		; $4e34

	ld l,Enemy.collisionType		; $4e36
	set 7,(hl)		; $4e38

	ld l,Enemy.speed		; $4e3a
	ld (hl),SPEED_100		; $4e3c

	ld l,Enemy.counter1		; $4e3e
	ld (hl),$01		; $4e40
	jp objectSetVisiblec2		; $4e42


_cucco_state_stub:
	ret			; $4e45


; Standing still.
; Also used by ENEMYID_GIANT_CUCCO.
_cucco_state8:
	call objectAddToGrabbableObjectBuffer		; $4e46

	ld e,$3f		; $4e49
	ld bc,$031f		; $4e4b
	call _ecom_randomBitwiseAndBCE		; $4e4e
	or e			; $4e51
	ret nz ; 63 in 64 chance of returning

	call _ecom_incState		; $4e53

	ld l,Enemy.counter1		; $4e56
	ldi (hl),a ; [counter1] = 0

	ld a,$02		; $4e59
	add b			; $4e5b
	ld (hl),a ; [counter2] = random value between 2-6 (number of hops)

	ld l,Enemy.angle		; $4e5d
	ld a,c			; $4e5f
	ld (hl),a		; $4e60
	jp _cucco_setAnimationFromAngle		; $4e61


; Moving in some direction until [counter2] == 0.
; Also used by ENEMYID_GIANT_CUCCO.
_cucco_state9:
	call objectAddToGrabbableObjectBuffer		; $4e64
	ld h,d			; $4e67
	ld l,Enemy.counter1		; $4e68
	ld a,(hl)		; $4e6a
	and $0f			; $4e6b
	inc (hl)		; $4e6d

	ld hl,_cucco_zVals		; $4e6e
	rst_addAToHl			; $4e71
	ld e,Enemy.zh		; $4e72
	ld a,(hl)		; $4e74
	ld (de),a		; $4e75
	or a			; $4e76
	jr nz,++		; $4e77

	; Just finished a hop
	call _ecom_decCounter2		; $4e79
	jr nz,++		; $4e7c

	; Stop moving
	ld l,Enemy.state		; $4e7e
	dec (hl)		; $4e80
++
	call _ecom_bounceOffWallsAndHoles		; $4e81
	call nz,_cucco_setAnimationFromAngle		; $4e84
	call objectApplySpeed		; $4e87
_cucco_animate:
	jp enemyAnimate		; $4e8a


; Just landed after being thrown. Run away from Link indefinitely.
_cucco_stateA:
	call objectAddToGrabbableObjectBuffer		; $4e8d
	call _ecom_updateCardinalAngleAwayFromTarget		; $4e90
	call _cucco_setAnimationFromAngle		; $4e93
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4e96
	jr _cucco_animate		; $4e99


; In the process of transforming (into ENEMYID_BABY_CUCCO or ENEMYID_GIANT_CUCCO, based on
; var31)
_cucco_stateB:
	ld a,Object.animParameter		; $4e9b
	call objectGetRelatedObject1Var		; $4e9d
	bit 7,(hl)		; $4ea0
	ret z			; $4ea2

	ld e,Enemy.var31		; $4ea3
	ld a,(de)		; $4ea5
	ld b,a			; $4ea6
	ld c,$00		; $4ea7
	jp objectReplaceWithID		; $4ea9


; ==============================================================================
; ENEMYID_GIANT_CUCCO
;
; Variables are the same as ENEMYID_CUCCO.
; ==============================================================================
enemyCode3b:
	jr z,@normalStatus	; $4eac
	sub ENEMYSTATUS_NO_HEALTH			; $4eae
	ret c			; $4eb0

	ld e,Enemy.var2a		; $4eb1
	ld a,(de)		; $4eb3
	res 7,a			; $4eb4

	; Check if hit by anything other than Link or shield.
	cp ITEMCOLLISION_L1_SWORD			; $4eb6
	jr c,@normalStatus	; $4eb8

	ld h,d			; $4eba
	ld l,Enemy.var30		; $4ebb
	inc (hl)		; $4ebd

	; NOTE: The cucco starts with 0 health. It's constantly reset to $40 here. This
	; isn't a problem in Seasons, but in Ages this seems to trigger a bug causing its
	; collisions to get disabled. See enemyTypes.s for details.
	ld l,Enemy.health		; $4ebe
	ld (hl),$40		; $4ec0

	ld l,Enemy.state		; $4ec2
	ld a,(hl)		; $4ec4
	cp $0a			; $4ec5
	jr nc,@normalStatus	; $4ec7
	ld (hl),$0a		; $4ec9
	ld l,Enemy.zh		; $4ecb
	ld (hl),$00		; $4ecd

@normalStatus:
	ld e,Enemy.state		; $4ecf
	ld a,(de)		; $4ed1
	rst_jumpTable			; $4ed2
	.dw _giantCucco_state_uninitialized
	.dw _cucco_state_stub
	.dw _cucco_state_grabbed
	.dw _cucco_state_stub
	.dw _cucco_state_stub
	.dw _cucco_state_stub
	.dw _cucco_state_stub
	.dw _cucco_state_stub
	.dw _cucco_state8 ; States 8 and 9 same as normal cucco (wandering around)
	.dw _cucco_state9
	.dw _giantCucco_stateA
	.dw _giantCucco_stateB


_giantCucco_state_uninitialized:
	ld a,SPEED_c0		; $4eeb
	call _ecom_setSpeedAndState8		; $4eed
	ld a,$30		; $4ef0
	call setScreenShakeCounter		; $4ef2
	jp objectSetVisiblec1		; $4ef5


; Hit with anything other than Link or shield
_giantCucco_stateA:
	ld e,Enemy.var30		; $4ef8
	ld a,(de)		; $4efa
	cp $08			; $4efb
	jr c,@runAway	; $4efd

	; Hit at least 8 times
	call _ecom_incState		; $4eff

	ld l,Enemy.var32		; $4f02
	ld (hl),$00		; $4f04

	ld a,SND_TELEPORT		; $4f06
	jp playSound		; $4f08

@runAway:
	call _ecom_updateCardinalAngleAwayFromTarget		; $4f0b
	call _cucco_setAnimationFromAngle		; $4f0e
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4f11
	jr _giantCucco_animate		; $4f14


; Charging toward Link after being hit 8 times
_giantCucco_stateB:
	call objectGetAngleTowardEnemyTarget		; $4f16
	call objectNudgeAngleTowards		; $4f19
	call _cucco_setAnimationFromAngle		; $4f1c
	call objectApplySpeed		; $4f1f

_giantCucco_animate:
	jp enemyAnimate		; $4f22


;;
; @addr{4f25}
_cucco_setAnimationFromAngle:
	ld h,d			; $4f25
	ld l,Enemy.angle		; $4f26
	ld a,(hl)		; $4f28
	and $0f			; $4f29
	ret z			; $4f2b

	ldd a,(hl)		; $4f2c
	and $10			; $4f2d
	swap a			; $4f2f
	xor $01			; $4f31
	cp (hl) ; hl == direction
	ret z			; $4f34
	ld (hl),a		; $4f35
	jp enemySetAnimation		; $4f36


_cucco_zVals:
	.db $00 $ff $ff $fe $fe $fe $fd $fd
	.db $fd $fd $fe $fe $fe $ff $ff $00


;;
; @addr{4f49}
_cucco_checkSpawnCuccoAttacker:
	ld h,d			; $4f49
	ld l,Enemy.var33		; $4f4a
	ld a,(hl)		; $4f4c
	or a			; $4f4d
	jr z,+			; $4f4e
	dec (hl)		; $4f50
	ret nz			; $4f51
+
	; Must have been hit at least 16 times
	ld l,Enemy.var30		; $4f52
	ld a,(hl)		; $4f54
	cp $10			; $4f55
	ret c			; $4f57

	ld b,PARTID_CUCCO_ATTACKER		; $4f58
	call _ecom_spawnProjectile		; $4f5a

	ld e,Enemy.var30		; $4f5d
	ld a,(de)		; $4f5f
	sub $10			; $4f60
	and $1e			; $4f62
	rrca			; $4f64
	ld hl,@var33Vals		; $4f65
	rst_addAToHl			; $4f68
	ld e,Enemy.var33		; $4f69
	ld a,(hl)		; $4f6b
	ld (de),a		; $4f6c
	ret			; $4f6d

@var33Vals:
	.db $1e $1a $18 $16 $14 $12 $10 $0e
	.db $0c


_cucco_attacked:
	ld l,Enemy.health		; $4f77
	ld (hl),$40		; $4f79

	ld l,Enemy.state		; $4f7b
	ld a,$0a		; $4f7d
	cp (hl)			; $4f7f
	jr z,++			; $4f80

	; Just starting to run away
	ld (hl),a		; $4f82
	ld l,Enemy.speed		; $4f83
	ld (hl),SPEED_100		; $4f85
	ld l,Enemy.zh		; $4f87
	ld (hl),$00		; $4f89
++
	ld e,Enemy.var2a		; $4f8b
	ld a,(de)		; $4f8d
	rlca			; $4f8e
	ret nc			; $4f8f

	; Increment number of times hit
	ld l,Enemy.var30		; $4f90
	bit 5,(hl)		; $4f92
	jr nz,+			; $4f94
	inc (hl)		; $4f96
+
	ld a,SND_CHICKEN		; $4f97
	jp playSound		; $4f99


;;
; Cucco will transform into ENEMYID_BABY_CUCCO (if not aggressive) or ENEMYID_GIANT_CUCCO
; (if aggressive).
; @addr{4f9c}
_cucco_hitWithMysterySeed:
	ld l,Enemy.collisionType		; $4f9c
	res 7,(hl)		; $4f9e

	; Check if the cucco been hit 16 or more times
	ld l,Enemy.var30		; $4fa0
	ld a,(hl)		; $4fa2
	cp $10			; $4fa3
	jr c,+			; $4fa5
	ld a,ENEMYID_GIANT_CUCCO		; $4fa7
	jr ++			; $4fa9
+
	ld a,ENEMYID_BABY_CUCCO		; $4fab
++
	ld e,Enemy.var31		; $4fad
	ld (de),a		; $4faf

	ldbc INTERACID_PUFF,$02		; $4fb0
	call objectCreateInteraction		; $4fb3
	ret nz			; $4fb6

	ld e,Enemy.relatedObj1		; $4fb7
	ld a,Interaction.start		; $4fb9
	ld (de),a		; $4fbb
	inc e			; $4fbc
	ld a,h			; $4fbd
	ld (de),a		; $4fbe

	ld e,Enemy.state		; $4fbf
	ld a,$0b		; $4fc1
	ld (de),a		; $4fc3

	jp objectSetInvisible		; $4fc4


;;
; @addr{4fc7}
_cucco_playChickenSoundEvery32Frames:
	ld h,d			; $4fc7
	ld l,Enemy.invincibilityCounter		; $4fc8
	ld a,(hl)		; $4fca
	or a			; $4fcb
	ret nz			; $4fcc

	ld l,Enemy.var32		; $4fcd
	dec (hl)		; $4fcf
	ld a,(hl)		; $4fd0
	and $1f			; $4fd1
	ret nz			; $4fd3
	ld a,SND_CHICKEN		; $4fd4
	jp playSound		; $4fd6


; ==============================================================================
; ENEMYID_BUTTERFLY
; ==============================================================================
enemyCode37:
	ld e,Enemy.state		; $4fd9
	ld a,(de)		; $4fdb
	rst_jumpTable			; $4fdc
	.dw @state0
	.dw @state1

@state0:
.ifdef ROM_SEASONS
	; spring-only
	ld a,(wRoomStateModifier)		; $5000
	or a			; $5003
	jp nz,enemyDelete		; $5004
.endif
	ld h,d			; $4fe1
	ld l,e			; $4fe2
	inc (hl) ; [state]

	ld l,Enemy.speed		; $4fe4
	ld (hl),SPEED_40		; $4fe6
	call _ecom_setRandomAngle		; $4fe8

	jp objectSetVisible81		; $4feb

@state1:
	ld bc,$1f1f		; $4fee
	call _ecom_randomBitwiseAndBCE		; $4ff1
	or b			; $4ff4
	jr nz,++		; $4ff5
	ld h,d			; $4ff7
	ld l,Enemy.angle		; $4ff8
	ld (hl),c		; $4ffa
++
	call objectApplySpeed		; $4ffb
	call _ecom_bounceOffScreenBoundary		; $4ffe
	jp enemyAnimate		; $5001


; ==============================================================================
; ENEMYID_GREAT_FAIRY
;
; Variables:
;   relatedObj2: Reference to INTERACID_PUFF
;   var30: Counter used to update Z-position as she floats up and down
;   var31: Number of hearts spawned (the ones that circle around Link)
; ==============================================================================
enemyCode38:
	ld e,Enemy.state		; $5004
	ld a,(de)		; $5006
	rst_jumpTable			; $5007
	.dw _greatFairy_state_uninitialized
	.dw _greatFairy_state1
	.dw _greatFairy_state2
	.dw _greatFairy_state3
	.dw _greatFairy_state4
	.dw _greatFairy_state5
	.dw _greatFairy_state6
	.dw _greatFairy_state7
	.dw _greatFairy_state8
	.dw _greatFairy_state9


_greatFairy_state_uninitialized:
	ld h,d			; $501c
	ld l,e			; $501d
	inc (hl) ; [state]
	ld l,Enemy.zh		; $501f
	ld (hl),$f0		; $5021
	ret			; $5023


; Create puff
_greatFairy_state1:
	call _greatFairy_createPuff		; $5024
	ret nz			; $5027

	ld l,Enemy.state		; $5028
	inc (hl)		; $502a

	ld l,Enemy.counter1		; $502b
	ld (hl),$11		; $502d
	ld a,MUS_FAIRY		; $502f
	ld (wActiveMusic),a		; $5031
	ret			; $5034


; Waiting for puff to disappear
_greatFairy_state2:
	ld a,Object.animParameter		; $5035
	call objectGetRelatedObject2Var		; $5037
	bit 7,(hl)		; $503a
	ret z			; $503c

	call _ecom_incState		; $503d


; Waiting for Link to approach
_greatFairy_state3:
	call _greatFairy_checkLinkApproached		; $5040
	jr nc,_greatFairy_animate	; $5043

	ld a,$80		; $5045
	ld (wMenuDisabled),a		; $5047

	ld a,DISABLE_COMPANION|DISABLE_LINK		; $504a
	ld (wDisabledObjects),a		; $504c

	ld hl,wLinkHealth		; $504f
	ldi a,(hl)		; $5052
	cp (hl)			; $5053
	ld a,$04		; $5054
	ld bc,TX_4100		; $5056
	jr nz,++		; $5059

	; Full health already
	ld e,Enemy.counter1		; $505b
	ld a,30		; $505d
	ld (de),a		; $505f
	ld a,$08		; $5060
	ld bc,TX_4105		; $5062
++
	ld e,Enemy.state		; $5065
	ld (de),a		; $5067
	call showText		; $5068

_greatFairy_animate:
	call _greatFairy_updateZPosition		; $506b
	call enemyAnimate		; $506e
	ld e,Enemy.yh		; $5071
	ld a,(de)		; $5073
	ld b,a			; $5074
	ldh a,(<hEnemyTargetY)	; $5075
	cp b			; $5077
	jp c,objectSetVisiblec1		; $5078
	jp objectSetVisiblec2		; $507b


; Begin healing Link
_greatFairy_state4:
	ld h,d			; $507e
	ld l,e			; $507f
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $5081
	ld (hl),$0c		; $5083
	inc l			; $5085
	ld (hl),$09 ; [counter2]


; Spawning hearts
_greatFairy_state5:
	call _greatFairy_playSoundEvery8Frames		; $5088
	call _ecom_decCounter1		; $508b
	jr nz,_greatFairy_animate	; $508e

	ld (hl),$0c ; [counter1]
	inc l			; $5092
	dec (hl) ; [counter2]
	jr z,@spawnedAllHearts			; $5094
	call _greatFairy_spawnCirclingHeart		; $5096
	jr _greatFairy_animate		; $5099

@spawnedAllHearts:
	dec l			; $509b
	ld (hl),30 ; [counter1]

	ld l,Enemy.state		; $509e
	inc (hl)		; $50a0
	jr _greatFairy_animate		; $50a1


; Hearts have all spawned, are now circling around Link
_greatFairy_state6:
	call _greatFairy_playSoundEvery8Frames		; $50a3
	call _ecom_decCounter1		; $50a6
	jr nz,_greatFairy_animate	; $50a9
	ld l,Enemy.state		; $50ab
	inc (hl)		; $50ad
	ld a,TREASURE_HEART_REFILL		; $50ae
	ld c,MAX_LINK_HEALTH		; $50b0
	call giveTreasure		; $50b2


; Waiting for all hearts to disappear
_greatFairy_state7:
	call _greatFairy_playSoundEvery8Frames		; $50b5
	ld e,Enemy.var31		; $50b8
	ld a,(de)		; $50ba
	or a			; $50bb
	jr nz,_greatFairy_animate	; $50bc

	call _ecom_incState		; $50be
	ld l,Enemy.counter1		; $50c1
	ld (hl),30		; $50c3


; About to disappear; staying in place for 30 frames
_greatFairy_state8:
	call _ecom_decCounter1		; $50c5
	jr nz,_greatFairy_animate	; $50c8

	ld (hl),60 ; [counter1]
	ld l,e			; $50cc
	inc (hl) ; [state]

	xor a			; $50ce
	ld (wDisabledObjects),a		; $50cf
	ld (wMenuDisabled),a		; $50d2

	ld a,SND_FAIRYCUTSCENE		; $50d5
	call playSound		; $50d7


; Disappearing
_greatFairy_state9:
	call _ecom_decCounter1		; $50da
	jp z,enemyDelete		; $50dd

	call _greatFairy_animate		; $50e0

	; Flicker visibility
	ld h,d			; $50e3
	ld l,Enemy.counter1		; $50e4
	bit 0,(hl)		; $50e6
	ret nz			; $50e8
	ld l,Enemy.visible		; $50e9
	res 7,(hl)		; $50eb
	ret			; $50ed


;;
; @addr{50ee}
_greatFairy_updateZPosition:
	ld h,d			; $50ee
	ld l,Enemy.var30		; $50ef
	dec (hl)		; $50f1
	ld a,(hl)		; $50f2
	and $07			; $50f3
	ret nz			; $50f5

	ld a,(hl)		; $50f6
	and $18			; $50f7
	swap a			; $50f9
	rlca			; $50fb
	sub $02			; $50fc
	bit 5,(hl)		; $50fe
	jr nz,++		; $5100
	cpl			; $5102
	inc a			; $5103
++
	sub $10			; $5104
	ld l,Enemy.zh		; $5106
	ld (hl),a		; $5108
	ret			; $5109


;;
; @param[out]	cflag	c if Link approached
; @addr{510a}
_greatFairy_checkLinkApproached:
	call checkLinkVulnerable		; $510a
	ret nc			; $510d

	ld h,d			; $510e
	ld l,Enemy.yh		; $510f
	ldh a,(<hEnemyTargetY)	; $5111
	sub (hl)		; $5113
	sub $10			; $5114
	cp $21			; $5116
	ret nc			; $5118

	ld l,Enemy.xh		; $5119
	ldh a,(<hEnemyTargetX)	; $511b
	sub (hl)		; $511d
	add $18			; $511e
	cp $31			; $5120
	ret			; $5122

;;
; @addr{5123}
_greatFairy_spawnCirclingHeart:
	call getFreePartSlot		; $5123
	ret nz			; $5126

	ld (hl),PARTID_GREAT_FAIRY_HEART		; $5127
	ld l,Part.relatedObj1		; $5129
	ld a,Enemy.start		; $512b
	ldi (hl),a		; $512d
	ld (hl),d		; $512e

	ld h,d			; $512f
	ld l,Enemy.var31		; $5130
	inc (hl)		; $5132
	ret			; $5133


;;
; @addr{5134}
_greatFairy_createPuff:
	ldbc INTERACID_PUFF,$02		; $5134
	call objectCreateInteraction		; $5137
	ret nz			; $513a

	ld a,h			; $513b
	ld h,d			; $513c
	ld l,Enemy.relatedObj2+1		; $513d
	ldd (hl),a		; $513f
	ld (hl),Interaction.start		; $5140
	xor a			; $5142
	ret			; $5143

;;
; @addr{5144}
_greatFairy_playSoundEvery8Frames:
	ld a,(wFrameCounter)		; $5144
	and $07			; $5147
	ret nz			; $5149
	ld a,SND_UNKNOWN7		; $514a
	jp playSound		; $514c


; ==============================================================================
; ENEMYID_FIRE_KEESE
;
; Variables:
;   var30: Distance away (in tiles) closest lit torch is
;   var31/var32: Position of lit torch it's moving towards to re-light itself
;   var33: Nonzero if fire has been shed (set to 2). Doubles as animation index?
;   var34: Position at which to search for a lit torch ($16 tiles are checked each frame,
;          so this gets incremented by $16 each frame)
;   var35: Angular rotation for subid 0. (set to -1 or 1 randomly on initialization, for
;          counterclockwise or clockwise movement)
; ==============================================================================
enemyCode39:
	jr z,@normalStatus	; $514f
	sub ENEMYSTATUS_NO_HEALTH			; $5151
	ret c			; $5153
	jp z,enemyDie		; $5154
	dec a			; $5157
	jp nz,_ecom_updateKnockbackNoSolidity		; $5158

	; ENEMYSTATUS_JUST_HIT
	ld e,Enemy.var2a		; $515b
	ld a,(de)		; $515d
	cp $80|ITEMCOLLISION_LINK			; $515e
	ret nz			; $5160

	; We collided with Link; if still on fire, transfer that fire to the ground.
	ld e,Enemy.var33		; $5161
	ld a,(de)		; $5163
	or a			; $5164
	ret nz			; $5165

	ld b,PARTID_FIRE		; $5166
	call _ecom_spawnProjectile		; $5168

	ld h,d			; $516b
	ld l,Enemy.oamFlags		; $516c
	ld a,$01		; $516e
	ldd (hl),a		; $5170
	ld (hl),a		; $5171

	ld l,Enemy.state		; $5172
	ld (hl),$08		; $5174

	ld l,Enemy.damage		; $5176
	ld (hl),-$04		; $5178

	ld l,Enemy.var33		; $517a
	ld (hl),$02		; $517c

	ld l,Enemy.speed		; $517e
	ld (hl),SPEED_c0		; $5180

	ld a,$03		; $5182
	jp enemySetAnimation		; $5184

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5187
	cp $0b			; $518a
	jr nc,_fireKeese_stateBOrHigher	; $518c
	rst_jumpTable			; $518e
	.dw _fireKeese_state_uninitialized
	.dw _fireKeese_state_stub
	.dw _fireKeese_state_stub
	.dw _fireKeese_state_stub
	.dw _fireKeese_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _fireKeese_state_stub
	.dw _fireKeese_state_stub
	.dw _fireKeese_state8
	.dw _fireKeese_state9
	.dw _fireKeese_stateA

_fireKeese_stateBOrHigher:
	ld a,b			; $51a5
	rst_jumpTable			; $51a6
	.dw _fireKeese_subid0
	.dw _fireKeese_subid1


_fireKeese_state_uninitialized:
	ld h,d			; $51ab
	ld l,Enemy.counter1		; $51ac
	ld (hl),$08		; $51ae

	ld l,Enemy.damage		; $51b0
	ld (hl),-$08		; $51b2

	bit 0,b			; $51b4
	ld l,e			; $51b6
	jr z,@subid0	; $51b7

@subid1:
	ld (hl),$0b ; [state]
	jp objectSetVisible82		; $51bb

@subid0:
	ld (hl),$0b ; [state]

	ld l,Enemy.zh		; $51c0
	ld (hl),-$1c		; $51c2

	ld l,Enemy.speed		; $51c4
	ld (hl),SPEED_80		; $51c6

	; Random angle
	ld bc,$1f01		; $51c8
	call _ecom_randomBitwiseAndBCE		; $51cb
	ld e,Enemy.angle		; $51ce
	ld a,b			; $51d0
	ld (de),a		; $51d1

	; Set var35 to 1 or -1 for clockwise or counterclockwise movement.
	ld a,c			; $51d2
	or a			; $51d3
	jr nz,+			; $51d4
	dec a			; $51d6
+
	ld e,Enemy.var35		; $51d7
	ld (de),a		; $51d9

	ld a,$01		; $51da
	call enemySetAnimation		; $51dc
	jp objectSetVisiblec1		; $51df


_fireKeese_state_stub:
	ret			; $51e2


; Just lost fire; looks for a torch if one exists, otherwise it will keep flying around
; like normal.
_fireKeese_state8:
	; Initialize "infinite" distance away from closest lit torch (none found yet)
	ld e,Enemy.var30		; $51e3
	ld a,$ff		; $51e5
	ld (de),a		; $51e7

	; Check all tiles in the room, try to find a lit torch to light self back on fire
	call objectGetTileAtPosition		; $51e8
	ld c,l			; $51eb
	ld l,$00		; $51ec
@nextTile:
	ld a,(hl)		; $51ee
	cp TILEINDEX_LIT_TORCH			; $51ef
	call z,_fireKeese_addCandidateTorch		; $51f1
	inc l			; $51f4
	ld a,l			; $51f5
	cp LARGE_ROOM_HEIGHT<<4			; $51f6
	jr c,@nextTile	; $51f8

	; Check if one was found
	ld e,Enemy.var30		; $51fa
	ld a,(de)		; $51fc
	inc a			; $51fd
	ld h,d			; $51fe
	jr nz,@torchFound	; $51ff

	; No torch found. Go back to doing subid-specific movement.

	ld l,Enemy.subid		; $5201
	bit 0,(hl)		; $5203
	ld a,$0d		; $5205
	jr z,++			; $5207

	; Subid 1
	ld l,Enemy.counter1		; $5209
	ld (hl),120		; $520b
	ld a,$0c		; $520d
++
	ld l,Enemy.state		; $520f
	ld (hl),a		; $5211
	ret			; $5212

@torchFound:
	ld l,Enemy.state		; $5213
	inc (hl)		; $5215
	ld l,Enemy.speed		; $5216
	ld (hl),SPEED_c0		; $5218
	ld a,$03		; $521a
	jp enemySetAnimation		; $521c


; Moving towards a torch's position, marked in var31/var32
_fireKeese_state9:
	ld h,d			; $521f
	ld l,Enemy.var31		; $5220
	call _ecom_readPositionVars		; $5222
	cp c			; $5225
	jr nz,@notAtTargetPosition		; $5226

	ldh a,(<hFF8F)	; $5228
	cp b			; $522a
	jr z,@atTargetPosition	; $522b

@notAtTargetPosition:
	call _fireKeese_moveToGround		; $522d
	call _ecom_moveTowardPosition		; $5230
	jp enemyAnimate		; $5233

@atTargetPosition:
	call _fireKeese_moveToGround		; $5236
	ret c			; $5239

	ld l,Enemy.state		; $523a
	inc (hl)		; $523c

	ld l,Enemy.counter1		; $523d
	ld (hl),60		; $523f

	ld a,$02		; $5241
	jp enemySetAnimation		; $5243


; Touched down on the torch; in the process of being lit back on fire
_fireKeese_stateA:
	call _ecom_decCounter1		; $5246
	jr z,@gotoNextState	; $5249

	ld a,(hl) ; [counter1]
	sub 30			; $524c
	ret nz			; $524e

	; [counter1] == 30
	ld l,Enemy.oamFlags		; $524f
	ld a,$05		; $5251
	ldd (hl),a		; $5253
	ld (hl),a		; $5254

	ld l,Enemy.damage		; $5255
	ld (hl),-$08		; $5257
	ld l,Enemy.var33		; $5259
	xor a			; $525b
	ld (hl),a		; $525c
	jp enemySetAnimation		; $525d

@gotoNextState:
	ld l,Enemy.angle		; $5260
	ld a,(hl)		; $5262
	add $10			; $5263
	and $1f			; $5265
	ld (hl),a		; $5267

	ld l,Enemy.subid		; $5268
	bit 0,(hl)		; $526a
	ld a,$0d		; $526c
	jr z,++			; $526e

	; Subid 1
	ld l,Enemy.counter1		; $5270
	ld (hl),120		; $5272
	ld a,$0c		; $5274
++
	ld (de),a		; $5276
	ld a,$01		; $5277
	jp enemySetAnimation		; $5279


; Keese which move up and down on Z axis
_fireKeese_subid0:
	call _fireKeese_checkForNewlyLitTorch		; $527c
	; Above function call may pop its return address, ignore everything below here

	ld e,Enemy.state		; $527f
	ld a,(de)		; $5281
	sub $0b			; $5282
	rst_jumpTable			; $5284
	.dw _fireKeese_subid0_stateB
	.dw _fireKeese_subid0_stateC
	.dw _fireKeese_subid0_stateD


; Flying around on fire
_fireKeese_subid0_stateB:
	call _fireKeese_checkCloseToLink		; $528b
	jr nc,@linkNotClose	; $528e

	; Link is close
	ld l,Enemy.state		; $5290
	inc (hl)		; $5292
	ld l,Enemy.counter1		; $5293
	ld (hl),91		; $5295
	ld l,Enemy.speed		; $5297
	ld (hl),SPEED_a0		; $5299

@linkNotClose:
	call _ecom_decCounter1		; $529b
	jr nz,++		; $529e

	ld (hl),$08 ; [counter1]

	; Move clockwise or counterclockwise (var35 is randomly set to 1 or -1 on
	; initialization)
	ld e,Enemy.var35		; $52a2
	ld a,(de)		; $52a4
	ld l,Enemy.angle		; $52a5
	add (hl)		; $52a7
	and $1f			; $52a8
	ld (hl),a		; $52aa
++
	call objectApplySpeed		; $52ab
	call _fireKeese_moveTowardCenterIfOutOfBounds		; $52ae
	jr _fireKeese_animate		; $52b1


; Divebombing because Link got close enough
_fireKeese_subid0_stateC:
	call _ecom_decCounter1		; $52b3
	jr nz,++		; $52b6
	ld l,Enemy.state		; $52b8
	inc (hl)		; $52ba
	jr _fireKeese_animate		; $52bb
++
	; Add some amount to Z-position
	ld a,(hl)		; $52bd
	and $f0			; $52be
	swap a			; $52c0
	ld hl,_fireKeese_subid0_zOffsets		; $52c2
	rst_addAToHl			; $52c5

	ld e,Enemy.z		; $52c6
	ld a,(de)		; $52c8
	add (hl)		; $52c9
	ld (de),a		; $52ca
	inc e			; $52cb
	ld a,(de)		; $52cc
	adc $00			; $52cd
	ld (de),a		; $52cf

	; Adjust angle toward Link
	call objectGetAngleTowardEnemyTarget		; $52d0
	ld b,a			; $52d3
	ld e,Enemy.counter1		; $52d4
	ld a,(de)		; $52d6
	and $03			; $52d7
	ld a,b			; $52d9
	call z,objectNudgeAngleTowards		; $52da

_fireKeese_updatePosition:
	call _ecom_bounceOffScreenBoundary		; $52dd
	call objectApplySpeed		; $52e0

_fireKeese_animate:
	jp enemyAnimate		; $52e3


; Moving back up after divebombing
_fireKeese_subid0_stateD:
	ld h,d			; $52e6
	ld l,Enemy.z		; $52e7
	ld a,(hl)		; $52e9
	sub <($0040)			; $52ea
	ldi (hl),a		; $52ec
	ld a,(hl)		; $52ed
	sbc >($0040)			; $52ee
	ld (hl),a		; $52f0

	cp $e4			; $52f1
	jr nc,_fireKeese_updatePosition	; $52f3

	ld l,e			; $52f5
	ld (hl),$0b ; [state]

	ld l,Enemy.speed		; $52f8
	ld (hl),SPEED_80		; $52fa

	ld l,Enemy.counter1		; $52fc
	ld (hl),$08		; $52fe
	jr _fireKeese_animate		; $5300


; Keese which has no Z-axis movement
_fireKeese_subid1:
	call _fireKeese_checkForNewlyLitTorch		; $5302
	; Above function call may pop its return address, ignore everything below here

	ld e,Enemy.state		; $5305
	ld a,(de)		; $5307
	sub $0b			; $5308
	rst_jumpTable			; $530a
	.dw _fireKeese_subid1_stateB
	.dw _fireKeese_subid1_stateC
	.dw _fireKeese_subid1_stateD


; Waiting [counter1] frames (8 frames) before moving
_fireKeese_subid1_stateB:
	call _ecom_decCounter1		; $5311
	ret nz			; $5314

	ld l,e			; $5315
	inc (hl) ; [state]

	ld l,Enemy.speed		; $5317
	ld (hl),SPEED_c0		; $5319

	; Random angle
	ld bc,$1f3f		; $531b
	call _ecom_randomBitwiseAndBCE		; $531e
	ld e,Enemy.angle		; $5321
	ld a,b			; $5323
	ld (de),a		; $5324

	; Random counter1 between $c0-$ff
	ld a,$c0		; $5325
	add c			; $5327
	ld e,Enemy.counter1		; $5328
	ld (de),a		; $532a

	; Set animation based on if on fire
	ld e,Enemy.var33		; $532b
	ld a,(de)		; $532d
	inc a			; $532e
	call enemySetAnimation		; $532f

	; Create fire when initially spawning
	ld e,Enemy.var33		; $5332
	ld a,(de)		; $5334
	or a			; $5335
	ld b,PARTID_FIRE		; $5336
	call z,_ecom_spawnProjectile		; $5338
	jp enemyAnimate		; $533b


; Moving around randomly for [counter1]*2 frames
_fireKeese_subid1_stateC:
	call _fireKeese_updatePosition		; $533e

	ld a,(wFrameCounter)		; $5341
	and $01			; $5344
	ret nz			; $5346

	call _ecom_decCounter1		; $5347
	jr z,@gotoNextState	; $534a

	; 1 in 16 chance of changing angle (every 2 frames)
	ld bc,$0f1f		; $534c
	call _ecom_randomBitwiseAndBCE		; $534f
	or b			; $5352
	ret nz			; $5353
	ld e,Enemy.angle		; $5354
	ld a,c			; $5356
	ld (de),a		; $5357
	ret			; $5358

@gotoNextState:
	ld l,Enemy.state		; $5359
	inc (hl)		; $535b
	ret			; $535c


; Slowing down, then stopping for a brief period
_fireKeese_subid1_stateD:
	ld e,Enemy.counter1		; $535d
	ld a,(de)		; $535f
	cp $68			; $5360
	jr nc,++		; $5362

	call _ecom_bounceOffScreenBoundary		; $5364
	call objectApplySpeed		; $5367
++
	call _fireKeese_subid1_setSpeedAndAnimateBasedOnCounter1		; $536a

	ld h,d			; $536d
	ld l,Enemy.counter1		; $536e
	inc (hl)		; $5370
	ld a,$7f		; $5371
	cp (hl)			; $5373
	ret nz			; $5374

	; Time to start moving again; go back to state $0b where we'll abruptly go fast.
	ld l,Enemy.state		; $5375
	ld (hl),$0b		; $5377

	ld e,Enemy.var33		; $5379
	ld a,(de)		; $537b
	call enemySetAnimation		; $537c

	; Set counter1 to random value from $20-$9f
	call getRandomNumber_noPreserveVars		; $537f
	and $7f			; $5382
	ld e,Enemy.counter1		; $5384
	add $20			; $5386
	ld (de),a		; $5388
	ret			; $5389


;;
; Subid 1 slows down gradually in state $0d.
; @addr{538a}
_fireKeese_subid1_setSpeedAndAnimateBasedOnCounter1:
	ld e,Enemy.counter1		; $538a
	ld a,(de)		; $538c
	and $0f			; $538d
	jr nz,++		; $538f

	; Set speed based on value of counter1
	ld a,(de)		; $5391
	swap a			; $5392
	ld hl,_fireKeese_subid1_speeds		; $5394
	rst_addAToHl			; $5397
	ld e,Enemy.speed		; $5398
	ld a,(hl)		; $539a
	ld (de),a		; $539b
++
	; Animate at some rate based on value of counter1
	ld e,Enemy.counter1		; $539c
	ld a,(de)		; $539e
	and $f0			; $539f
	swap a			; $53a1
	ld hl,_fireKeese_subid1_animFrequencies		; $53a3
	rst_addAToHl			; $53a6
	ld a,(wFrameCounter)		; $53a7
	and (hl)		; $53aa
	jp z,enemyAnimate		; $53ab
	ret			; $53ae


;;
; @param[out]	cflag	c if Link is within 32 pixels of keese in each direction
; @addr{53af}
_fireKeese_checkCloseToLink:
	ld h,d			; $53af
	ld l,Enemy.yh		; $53b0
	ldh a,(<hEnemyTargetY)	; $53b2
	sub (hl)		; $53b4
	add $20			; $53b5
	cp $41			; $53b7
	ret nc			; $53b9
	ld l,Enemy.xh		; $53ba
	ldh a,(<hEnemyTargetX)	; $53bc
	sub (hl)		; $53be
	add $20			; $53bf
	cp $41			; $53c1
	ret			; $53c3


;;
; Given the position of a torch, checks whether to update "position of closest known
; torch" (var31/var32).
;
; @param	c	Position of lit torch
; @addr{53c4}
_fireKeese_addCandidateTorch:
	; Get Y distance
	ld a,c			; $53c4
	and $f0			; $53c5
	swap a			; $53c7
	ld b,a			; $53c9
	ld a,l			; $53ca
	and $f0			; $53cb
	swap a			; $53cd
	sub b			; $53cf
	jr nc,+			; $53d0
	cpl			; $53d2
	inc a			; $53d3
+
	ld b,a			; $53d4

	; Get X distance
	ld a,c			; $53d5
	and $0f			; $53d6
	ld e,a			; $53d8
	ld a,l			; $53d9
	and $0f			; $53da
	sub e			; $53dc
	jr nc,+			; $53dd
	cpl			; $53df
	inc a			; $53e0
+
	; Compare with closest candidate, return if farther away
	add b			; $53e1
	ld b,a			; $53e2
	ld e,Enemy.var30		; $53e3
	ld a,(de)		; $53e5
	cp b			; $53e6
	ret c			; $53e7

	; This is the closest torch found so far.
	ld a,b			; $53e8
	ld (de),a		; $53e9

	; Mark its position in var31/var32
	ld e,Enemy.var31		; $53ea
	ld a,l			; $53ec
	and $f0			; $53ed
	add $08			; $53ef
	ld (de),a		; $53f1
	inc e			; $53f2
	ld a,l			; $53f3
	and $0f			; $53f4
	swap a			; $53f6
	add $08			; $53f8
	ld (de),a		; $53fa
	ret			; $53fb


;;
; While the keese is not lit on fire, this function checks if any new lit torches suddenly
; appear in the room. If so, it sets the state to 8 and returns from the caller (discards
; return address).
; @addr{53fc}
_fireKeese_checkForNewlyLitTorch:
	; Return if on fire already
	ld e,Enemy.var33		; $53fc
	ld a,(de)		; $53fe
	or a			; $53ff
	ret z			; $5400

	; Check $16 tiles per frame, searching for a torch. (Searching all of them could
	; cause lag, especially with a lot of bats on-screen.)
	ld e,Enemy.var34		; $5401
	ld a,(de)		; $5403
	ld l,a			; $5404
	ld h,>wRoomLayout		; $5405
	ld b,$16		; $5407
@loop:
	ldi a,(hl)		; $5409
	cp TILEINDEX_LIT_TORCH			; $540a
	jr z,@foundTorch	; $540c
	dec b			; $540e
	jr nz,@loop	; $540f

	ld a,l			; $5411
	cp LARGE_ROOM_HEIGHT<<4			; $5412
	jr nz,+			; $5414
	xor a			; $5416
+
	ld (de),a		; $5417
	ret			; $5418

@foundTorch:
	pop hl ; Return from caller

	ld h,d			; $541a
	ld l,e			; $541b
	ld (hl),$00 ; [var34]

	; State 8 will cause the bat to move toward the torch.
	; (var31/var32 are not set here because the search will be done again in state 8.)
	ld l,Enemy.state		; $541e
	ld (hl),$08		; $5420

	ld l,Enemy.speed		; $5422
	ld (hl),SPEED_c0		; $5424
	ret			; $5426

;;
; @param[out]	cflag	nc if reached ground (or at most 6 units away)
; @addr{5427}
_fireKeese_moveToGround:
	ld e,Enemy.zh		; $5427
	ld a,(de)		; $5429
	or a			; $542a
	ret z			; $542b

	cp $fa			; $542c
	ret nc			; $542e

	; [Enemy.z] += $0080
	dec e			; $542f
	ld a,(de)		; $5430
	add <($0080)			; $5431
	ld (de),a		; $5433
	inc e			; $5434
	ld a,(de)		; $5435
	adc >($0080)			; $5436
	ld (de),a		; $5438
	scf			; $5439
	ret			; $543a


;;
; @addr{543b}
_fireKeese_moveTowardCenterIfOutOfBounds:
	ld e,Enemy.yh		; $543b
	ld a,(de)		; $543d
	cp LARGE_ROOM_HEIGHT<<4			; $543e
	jr nc,@outOfBounds		; $5440

	ld e,Enemy.xh		; $5442
	ld a,(de)		; $5444
	cp $f0			; $5445
	ret c			; $5447

@outOfBounds:
	ld e,Enemy.yh		; $5448
	ld a,(de)		; $544a
	ldh (<hFF8F),a	; $544b
	ld e,Enemy.xh		; $544d
	ld a,(de)		; $544f
	ldh (<hFF8E),a	; $5450

	ldbc (LARGE_ROOM_HEIGHT/2)<<4 + 8, (LARGE_ROOM_WIDTH/2)<<4 + 8		; $5452
	call objectGetRelativeAngleWithTempVars		; $5455
	ld c,a			; $5458
	ld b,SPEED_100		; $5459
	ld e,Enemy.angle		; $545b
	jp objectApplyGivenSpeed		; $545d


; Offsets for Z position, in subpixels.
_fireKeese_subid0_zOffsets:
	.db $80 $60 $40 $30 $20 $20

; Speed values for subid 1, where it gradually slows down.
_fireKeese_subid1_speeds:
	.db SPEED_c0 SPEED_80 SPEED_40 SPEED_40
	.db SPEED_20 SPEED_20 SPEED_20 SPEED_20

_fireKeese_subid1_animFrequencies:
	.db $00 $00 $01 $01 $03 $03 $07 $00


; ==============================================================================
; ENEMYID_WATER_TEKTITE
; ==============================================================================
enemyCode3a:
	jr z,@normalStatus	; $5476
	sub ENEMYSTATUS_NO_HEALTH			; $5478
	ret c			; $547a
	jp z,enemyDie		; $547b
	dec a			; $547e
	ret z			; $547f

	; ENEMYSTATUS_KNOCKBACK
	; Need special knockback code for special "solidity" properties (water is
	; traversible, everything else is solid)
	ld e,Enemy.speed		; $5480
	ld a,(de)		; $5482
	push af			; $5483
	ld a,SPEED_200		; $5484
	ld (de),a		; $5486
	ld e,Enemy.knockbackAngle		; $5487
	call _waterTektite_getAdjacentWallsBitsetGivenAngle		; $5489
	ld e,Enemy.knockbackAngle		; $548c
	call _ecom_applyVelocityGivenAdjacentWalls		; $548e

	pop af			; $5491
	ld e,Enemy.speed		; $5492
	ld (de),a		; $5494
	ret			; $5495

@normalStatus:
	ld e,Enemy.state		; $5496
	ld a,(de)		; $5498
	rst_jumpTable			; $5499
	.dw _waterTektite_state_uninitialized
	.dw _waterTektike_state_stub
	.dw _waterTektike_state_stub
	.dw _waterTektike_state_stub
	.dw _waterTektike_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _waterTektike_state_stub
	.dw _waterTektike_state_stub
	.dw _waterTektike_state8
	.dw _waterTektike_state9


_waterTektite_state_uninitialized:
	call objectSetVisible82		; $54ae

_waterTektike_decideNewAngle:
	ld h,d			; $54b1
	ld l,Enemy.state		; $54b2
	ld (hl),$08		; $54b4

	ld l,Enemy.counter1		; $54b6
	ld (hl),$40		; $54b8

	ld a,(wScentSeedActive)		; $54ba
	or a			; $54bd
	jr nz,@scentSeedActive	; $54be

	; Random diagonal angle
	call getRandomNumber_noPreserveVars		; $54c0
	and $18			; $54c3
	add $04			; $54c5
	ld e,Enemy.angle		; $54c7
	ld (de),a		; $54c9
	jr _waterTektike_animate		; $54ca

@scentSeedActive:
	ldh a,(<hFFB2)	; $54cc
	ldh (<hFF8F),a	; $54ce
	ldh a,(<hFFB3)	; $54d0
	ldh (<hFF8E),a	; $54d2
	ld l,Enemy.yh		; $54d4
	ldi a,(hl)		; $54d6
	ld b,a			; $54d7
	inc l			; $54d8
	ld c,(hl)		; $54d9
	call objectGetRelativeAngleWithTempVars		; $54da
	ld e,Enemy.angle		; $54dd
	ld (de),a		; $54df
	jr _waterTektike_animate		; $54e0


_waterTektike_state_stub:
	ret			; $54e2


; Moving in some direction for [counter1] frames, at varying speeds.
_waterTektike_state8:
	call _ecom_decCounter1		; $54e3
	jr nz,++		; $54e6

	ld l,e			; $54e8
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $54ea
	ld (hl),$08		; $54ec
	jr _waterTektike_animate		; $54ee
++
	call _waterTektike_setSpeedFromCounter1		; $54f0

	call _waterTektite_getAdjacentWallsBitset		; $54f3
	ld e,Enemy.angle		; $54f6
	call _ecom_applyVelocityGivenAdjacentWalls		; $54f8
	call _ecom_bounceOffScreenBoundary		; $54fb

_waterTektike_animate:
	jp enemyAnimate		; $54fe



; Not moving for [counter1] frames; then choosing new angle
_waterTektike_state9:
	call _ecom_decCounter1		; $5501
	jr nz,_waterTektike_animate	; $5504
	jr _waterTektike_decideNewAngle		; $5506

;;
; Gets the "adjacent walls bitset" for the tektike; since this swims, water is
; traversable, everything else is not.
;
; This is identical to "_fish_getAdjacentWallsBitsetForKnockback".
;
; @addr{5508}
_waterTektite_getAdjacentWallsBitset:
	ld e,Enemy.angle		; $5508

;;
; @param	de	Angle variable
; @addr{550a}
_waterTektite_getAdjacentWallsBitsetGivenAngle:
	ld a,(de)		; $550a
	call _ecom_getAdjacentWallTableOffset		; $550b

	ld h,d			; $550e
	ld l,Enemy.yh		; $550f
	ld b,(hl)		; $5511
	ld l,Enemy.xh		; $5512
	ld c,(hl)		; $5514
	ld hl,_ecom_sideviewAdjacentWallOffsetTable		; $5515
	rst_addAToHl			; $5518

	ld a,$10		; $5519
	ldh (<hFF8B),a	; $551b
	ld d,>wRoomLayout		; $551d
@nextOffset:
	ldi a,(hl)		; $551f
	add b			; $5520
	ld b,a			; $5521
	and $f0			; $5522
	ld e,a			; $5524
	ldi a,(hl)		; $5525
	add c			; $5526
	ld c,a			; $5527
	and $f0			; $5528
	swap a			; $552a
	or e			; $552c
	ld e,a			; $552d
	ld a,(de)		; $552e
	sub TILEINDEX_PUDDLE			; $552f
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1			; $5531
	ldh a,(<hFF8B)	; $5533
	rla			; $5535
	ldh (<hFF8B),a	; $5536
	jr nc,@nextOffset	; $5538

	xor $0f			; $553a
	ldh (<hFF8B),a	; $553c
	ldh a,(<hActiveObject)	; $553e
	ld d,a			; $5540
	ret			; $5541


;;
; @param	hl	Pointer to counter1
; @addr{5542}
_waterTektike_setSpeedFromCounter1:
	ld a,(hl)		; $5542
	srl a			; $5543
	srl a			; $5545
	ld hl,@speedVals		; $5547
	rst_addAToHl			; $554a
	ld e,Enemy.speed		; $554b
	ld a,(hl)		; $554d
	ld (de),a		; $554e
	ret			; $554f

@speedVals:
	.db SPEED_020 SPEED_040 SPEED_080 SPEED_0c0 SPEED_100 SPEED_140 SPEED_140 SPEED_140
	.db SPEED_100 SPEED_100 SPEED_0c0 SPEED_0c0 SPEED_080 SPEED_080 SPEED_040 SPEED_040


; ==============================================================================
; ENEMYID_SWORD_MOBLIN
; ENEMYID_SWORD_SHROUDED_STALFOS
; ENEMYID_SWORD_MASKED_MOBLIN
;
; Shares some code with ENEMYID_SWORD_DARKNUT.
;
; Variables:
;   var30: Nonzero if enemyCollisionMode was changed to ignore sword damage (due to the
;          enemy's sword blocking it)
; ==============================================================================
enemyCode3d:
enemyCode49:
enemyCode4a:
	call _ecom_checkHazards		; $5560
	call @runState		; $5563
	jp _swordEnemy_updateEnemyCollisionMode		; $5566

@runState:
	jr z,@normalStatus	; $5569
	sub ENEMYSTATUS_NO_HEALTH			; $556b
	ret c			; $556d
	jr z,@dead	; $556e
	dec a			; $5570
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5571
	ret			; $5574
@dead:
	pop hl			; $5575
	jp enemyDie		; $5576

@normalStatus:
	call _ecom_checkScentSeedActive		; $5579
	jr z,++			; $557c
	ld e,Enemy.speed		; $557e
	ld a,SPEED_a0		; $5580
	ld (de),a		; $5582
++
	ld e,Enemy.state		; $5583
	ld a,(de)		; $5585
	rst_jumpTable			; $5586
	.dw _swordEnemy_state_uninitialized
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_switchHook
	.dw _swordEnemy_state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state8
	.dw _swordEnemy_state9
	.dw _swordEnemy_stateA


_swordEnemy_state_uninitialized:
	ld b,PARTID_ENEMY_SWORD		; $559d
	call _ecom_spawnProjectile		; $559f
	ret nz			; $55a2

	call _ecom_setRandomCardinalAngle		; $55a3
	call _ecom_updateAnimationFromAngle		; $55a6

	ld a,SPEED_80		; $55a9
	call _ecom_setSpeedAndState8AndVisible		; $55ab

	ld l,Enemy.counter1		; $55ae
	inc (hl)		; $55b0

	; Enable scent seeds
	ld l,Enemy.var3f		; $55b1
	set 4,(hl)		; $55b3

	jp _swordEnemy_setChaseCooldown		; $55b5


_swordEnemy_state_switchHook:
	inc e			; $55b8
	ld a,(de)		; $55b9
	rst_jumpTable			; $55ba
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $55c3

@substate3:
	ld b,$09		; $55c4
	call _ecom_fallToGroundAndSetState		; $55c6
	ld l,Enemy.counter1		; $55c9
	ld (hl),$10		; $55cb
	ret			; $55cd


_swordEnemy_state_scentSeed:
	ld a,(wScentSeedActive)		; $55ce
	or a			; $55d1
	ld h,d			; $55d2
	jp z,_swordEnemy_gotoState8		; $55d3
	call _ecom_updateAngleToScentSeed		; $55d6
	call _ecom_updateAnimationFromAngle		; $55d9
	call _ecom_applyVelocityForSideviewEnemy		; $55dc
	call enemyAnimate		; $55df
	jr _swordEnemy_animate		; $55e2


_swordEnemy_state_stub:
	ret			; $55e4


; Moving slowly in cardinal directions until Link get close.
_swordEnemy_state8:
	call _swordEnemy_checkLinkIsClose		; $55e5
	jp c,_swordEnemy_beginChasingLink		; $55e8

	call _ecom_decCounter1		; $55eb
	jp z,_swordEnemy_chooseRandomAngleAndCounter1		; $55ee

	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $55f1
	jr nz,_swordEnemy_animate	; $55f4

	; Hit a wall
	call _ecom_bounceOffWallsAndHoles		; $55f6
	jp nz,_ecom_updateAnimationFromAngle		; $55f9

_swordEnemy_animate:
	jp enemyAnimate		; $55fc


; Started chasing Link (don't adjust angle until next state).
_swordEnemy_state9:
	call _ecom_decCounter1		; $55ff
	ret nz			; $5602
	ld (hl),$60		; $5603
	ld l,e			; $5605
	inc (hl) ; [state]
	ld l,Enemy.speed		; $5607
	ld (hl),SPEED_a0		; $5609
	ret			; $560b


; Chasing Link for [counter1] frames (adjusts angle appropriately).
_swordEnemy_stateA:
	call _ecom_decCounter1		; $560c
	jp z,_swordEnemy_gotoState8		; $560f

	ld a,(hl)		; $5612
	and $03			; $5613
	jr nz,++		; $5615
	call objectGetAngleTowardEnemyTarget		; $5617
	call objectNudgeAngleTowards		; $561a
	call _ecom_updateAnimationFromAngle		; $561d
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5620

	; Animate at double speed
	call enemyAnimate		; $5623
	jr _swordEnemy_animate		; $5626


;;
; Reverts to state 8; wandering around in cardinal directions
; @addr{5628}
_swordEnemy_gotoState8:
	ld l,e			; $5628
	ld (hl),$08 ; [state]

	ld l,Enemy.speed		; $562b
	ld (hl),SPEED_80		; $562d
	ld l,Enemy.angle		; $562f
	ld a,(hl)		; $5631
	add $04			; $5632
	and $18			; $5634
	ld (hl),a		; $5636

	call _ecom_updateAnimationFromAngle		; $5637
	call _swordEnemy_setChaseCooldown		; $563a
	jr _swordEnemy_animate		; $563d


; ==============================================================================
; ENEMYID_SWORD_DARKNUT
; ==============================================================================
enemyCode48:
.ifdef ROM_AGES
	call _ecom_checkHazards		; $563f
.else
	call _ecom_seasonsFunc_4446
.endif
	call @runState		; $5642
	jp _swordDarknut_updateEnemyCollisionMode		; $5645

@runState:
	jr z,@normalStatus	; $5648
	sub ENEMYSTATUS_NO_HEALTH			; $564a
	ret c			; $564c
	jr z,@dead	; $564d
	dec a			; $564f
	call nz,_ecom_updateKnockbackAndCheckHazards		; $5650
	jp _swordDarknut_updateEnemyCollisionMode		; $5653

@dead:
	ld e,Enemy.subid		; $5656
	ld a,(de)		; $5658
	cp $02			; $5659
	jr nz,++		; $565b
	ld hl,wKilledGoldenEnemies		; $565d
	set 2,(hl)		; $5660
++
	pop hl			; $5662
	jp enemyDie		; $5663

@normalStatus:
	ld e,Enemy.state		; $5666
	ld a,(de)		; $5668
	rst_jumpTable			; $5669
	.dw _swordDarknut_state_uninitialized
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_switchHook
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_stub
	.dw _swordEnemy_state_stub
	.dw _swordDarknut_state8
	.dw _swordDarknut_state9
	.dw _swordDarknut_stateA


_swordDarknut_state_uninitialized:
	ld e,Enemy.subid		; $5680
	ld a,(de)		; $5682
	cp $02			; $5683
	jr nz,++		; $5685
	ld a,(wKilledGoldenEnemies)		; $5687
	bit 2,a			; $568a
	jp nz,_swordDarknut_delete		; $568c
++
	jp _swordEnemy_state_uninitialized		; $568f


; Moving slowly in cardinal directions until Link get close.
; Identical to _swordEnemy_state8.
_swordDarknut_state8:
	call _swordDarknut_checkLinkIsClose		; $5692
	jr c,_swordEnemy_beginChasingLink	; $5695

	call _ecom_decCounter1		; $5697
	jr z,_swordEnemy_chooseRandomAngleAndCounter1	; $569a

	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $569c
	jr nz,_swordDarknut_animate	; $569f

	; Hit a wall
	call _ecom_bounceOffWallsAndHoles		; $56a1
	jp nz,_ecom_updateAnimationFromAngle		; $56a4

_swordDarknut_animate:
	jp enemyAnimate		; $56a7


; Started chasing Link (don't adjust angle until next state).
; Identical to _swordEnemy_state9 except for the speed.
_swordDarknut_state9:
	call _ecom_decCounter1		; $56aa
	ret nz			; $56ad
	ld (hl),$60		; $56ae
	ld l,e			; $56b0
	inc (hl) ; [state]
	ld l,Enemy.speed		; $56b2
	ld (hl),SPEED_c0		; $56b4
	ret			; $56b6


; Chasing Link for [counter1] frames (adjusts angle appropriately).
; Identical to _swordEnemy_stateA except for how quickly it turns toward Link.
_swordDarknut_stateA:
	call _ecom_decCounter1		; $56b7
	jp z,_swordEnemy_gotoState8		; $56ba

	ld a,(hl)		; $56bd
	and $01			; $56be
	jr nz,++		; $56c0
	call objectGetAngleTowardEnemyTarget		; $56c2
	call objectNudgeAngleTowards		; $56c5
	call _ecom_updateAnimationFromAngle		; $56c8
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $56cb

	; Animate at double speed
	call enemyAnimate		; $56ce
	jr _swordDarknut_animate		; $56d1

;;
; @addr{56d3}
_swordEnemy_beginChasingLink:
	ld l,Enemy.state		; $56d3
	inc (hl)		; $56d5
	ld l,Enemy.counter1		; $56d6
	ld (hl),$10		; $56d8
	call _ecom_updateAngleTowardTarget		; $56da
	jp _ecom_updateAnimationFromAngle		; $56dd

;;
; @addr{56e0}
_swordEnemy_chooseRandomAngleAndCounter1:
	ld bc,$3f07		; $56e0
	call _ecom_randomBitwiseAndBCE		; $56e3
	ld e,Enemy.counter1		; $56e6
	ld a,$50		; $56e8
	add b			; $56ea
	ld (de),a		; $56eb

	call @chooseAngle		; $56ec
	jp _ecom_updateAnimationFromAngle		; $56ef

@chooseAngle:
	; 1 in 8 chance of moving toward Link
	ld a,c			; $56f2
	or a			; $56f3
	jp z,_ecom_updateCardinalAngleTowardTarget		; $56f4
	jp _ecom_setRandomCardinalAngle		; $56f7


;;
; @param[out]	cflag	c if Link is within 40 pixels of enemy in both directions (and
;			counter2, the timeout, has reached 0)
; @addr{56fa}
_swordEnemy_checkLinkIsClose:
	call _ecom_decCounter2		; $56fa
	ret nz			; $56fd

	; NOTE: Why does this use hFFB2, then hEnemyTargetX? It's mixing two position
	; variables.
	ld l,Enemy.yh		; $56fe
	ldh a,(<hFFB2)	; $5700
	sub (hl)		; $5702
	add $28			; $5703
	cp $51			; $5705
	ret nc			; $5707
	ld l,Enemy.xh		; $5708
	ldh a,(<hEnemyTargetX)	; $570a
	sub (hl)		; $570c
	add $28			; $570d
	cp $51			; $570f
	ret			; $5711

;;
; This is identical to the above function.
; @addr{5712}
_swordDarknut_checkLinkIsClose:
	call _ecom_decCounter2		; $5712
	ret nz			; $5715

	; NOTE: Why does this use hFFB2, then hEnemyTargetX? It's mixing two position
	; variables.
	ld l,Enemy.yh		; $5716
	ldh a,(<hFFB2)	; $5718
	sub (hl)		; $571a
	add $28			; $571b
	cp $51			; $571d
	ret nc			; $571f
	ld l,Enemy.xh		; $5720
	ldh a,(<hEnemyTargetX)	; $5722
	sub (hl)		; $5724
	add $28			; $5725
	cp $51			; $5727
	ret			; $5729


;;
; Sets counter2 to the number of frames to wait before chasing Link again. Higher subids
; have lower cooldowns.
; @addr{572a}
_swordEnemy_setChaseCooldown:
	ld e,Enemy.subid		; $572a
	ld a,(de)		; $572c
	ld bc,@counter2Vals		; $572d
	call addAToBc		; $5730
	ld e,Enemy.counter2		; $5733
	ld a,(bc)		; $5735
	ld (de),a		; $5736
	ret			; $5737

@counter2Vals:
	.db $14 $10 $0c


;;
; Updates enemyCollisionMode based on Link's angle relative to the enemy. In this way,
; Link's sword doesn't damage the enemy if positioned in such a way that their sword
; should block it.
; @addr{573b}
_swordEnemy_updateEnemyCollisionMode:
	ld b,$00		; $573b
	ld e,Enemy.stunCounter		; $573d
	ld a,(de)		; $573f
	or a			; $5740
	jr nz,++		; $5741

	call _swordEnemy_checkIgnoreCollision		; $5743
	ld a,ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD		; $5746
	ld b,$00		; $5748
	jr nz,@setVars	; $574a
++
	inc b			; $574c
	ld e,Enemy.id		; $574d
	ld a,(de)		; $574f
	cp ENEMYID_SWORD_SHROUDED_STALFOS			; $5750
	ld a,ENEMYCOLLISION_BURNABLE_ENEMY		; $5752
	jr nz,@setVars	; $5754
.ifdef ROM_AGES
	ld a,ENEMYCOLLISION_BURNABLE_ENEMY		; $5756
.else
	ld a,ENEMYCOLLISION_BURNABLE_UNDEAD
.endif

@setVars:
	ld e,Enemy.enemyCollisionMode		; $5758
	ld (de),a		; $575a

	ld e,Enemy.var30		; $575b
	ld a,b			; $575d
	ld (de),a		; $575e
	ret			; $575f

;;
; Same as above, but with a different enemyCollisionMode for the darknut.
; @addr{5760}
_swordDarknut_updateEnemyCollisionMode:
	ld b,$00		; $5760
	ld e,Enemy.stunCounter		; $5762
	ld a,(de)		; $5764
	or a			; $5765
	jr nz,++		; $5766

	call _swordEnemy_checkIgnoreCollision		; $5768
	ld a,ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD		; $576b
	ld b,$00		; $576d
	jr nz,@setVars	; $576f
++
	ld a,ENEMYCOLLISION_DARKNUT		; $5771
	inc b			; $5773

@setVars:
	ld e,Enemy.enemyCollisionMode		; $5774
	ld (de),a		; $5776

	ld e,Enemy.var30		; $5777
	ld a,b			; $5779
	ld (de),a		; $577a
	ret			; $577b

;;
; Check whether the angle between Link and the enemy is such that the collision should be
; ignored (due to the sword blocking it)
;
; Knockback is handled by PARTID_ENEMY_SWORD.
;
; @param[out]	zflag	z if sword hits should be ignored
; @addr{577c}
_swordEnemy_checkIgnoreCollision:
	ld e,Enemy.knockbackCounter		; $577c
	ld a,(de)		; $577e
	or a			; $577f
	ret nz			; $5780

	call objectGetAngleTowardEnemyTarget		; $5781
	ld b,a			; $5784
	ld e,Enemy.direction		; $5785
	ld a,(de)		; $5787
	add a			; $5788
	ld hl,@angleBits		; $5789
	rst_addDoubleIndex			; $578c
	ld a,b			; $578d
	jp checkFlag		; $578e

@angleBits:
	.db $3f $00 $00 $00 ; DIR_UP
	.db $00 $3f $00 $00 ; DIR_RIGHT
	.db $00 $00 $3f $00 ; DIR_DOWN
	.db $00 $00 $f8 $01 ; DIR_LEFT


;;
; @addr{57a1}
_swordDarknut_delete:
	call decNumEnemies		; $57a1
	jp enemyDelete		; $57a4


; ==============================================================================
; ENEMYID_PEAHAT
; ==============================================================================
enemyCode3e:
	jr z,@normalStatus	; $57a7
	sub ENEMYSTATUS_NO_HEALTH			; $57a9
	ret c			; $57ab
	jp z,enemyDie		; $57ac

	; ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.enemyCollisionMode		; $57af
	ld a,(de)		; $57b1
	cp ENEMYCOLLISION_PEAHAT			; $57b2
	ret nz			; $57b4

@normalStatus:
	call _peahat_updateEnemyCollisionMode		; $57b5
	ld e,Enemy.state		; $57b8
	ld a,(de)		; $57ba
	rst_jumpTable			; $57bb
	.dw _peahat_state_uninitialized
	.dw _peahet_state_stub
	.dw _peahet_state_stub
	.dw _peahet_state_stub
	.dw _peahet_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _peahet_state_stub
	.dw _peahet_state_stub
	.dw _peahat_state8
	.dw _peahat_state9
	.dw _peahat_stateA
	.dw _peahat_stateB


_peahat_state_uninitialized:
	call _ecom_setSpeedAndState8AndVisible		; $57d4
	ld l,Enemy.counter1		; $57d7
	inc (hl)		; $57d9
	ret			; $57da


_peahet_state_stub:
	ret			; $57db


; Stationary for [counter1] frames
_peahat_state8:
	call _ecom_decCounter1		; $57dc
	ret nz			; $57df

	ld l,Enemy.state		; $57e0
	inc (hl)		; $57e2

	ld l,Enemy.counter1		; $57e3
	ld (hl),$7f		; $57e5

	ld l,Enemy.speed		; $57e7
	ld (hl),SPEED_20		; $57e9

	ld l,Enemy.var30		; $57eb
	ld (hl),$0f		; $57ed
	call objectSetVisiblec1		; $57ef
	jr _peahat_animate		; $57f2


; Accelerating
_peahat_state9:
	call _ecom_decCounter1		; $57f4
	jp nz,_peahat_updatePosition		; $57f7

	ld l,Enemy.state		; $57fa
	inc (hl)		; $57fc

	call getRandomNumber_noPreserveVars		; $57fd
	and $07			; $5800
	ld hl,_peahat_counter1Vals		; $5802
	rst_addAToHl			; $5805
	ld e,Enemy.counter1		; $5806
	ld a,(hl)		; $5808
	ld (de),a		; $5809
	call _ecom_setRandomAngle		; $580a
	jr _peahat_animate		; $580d


; Flying around at top speed
_peahat_stateA:
	call _ecom_decCounter1		; $580f
	jr z,@beginSlowingDown	; $5812

	; Change angle every 32 frames
	ld a,(hl)		; $5814
	and $1f			; $5815
	call z,_ecom_setRandomAngle		; $5817

	call objectApplySpeed		; $581a
	call _ecom_bounceOffScreenBoundary		; $581d
	jr _peahat_animate		; $5820

@beginSlowingDown:
	ld l,e			; $5822
	inc (hl) ; [state]
	ld l,Enemy.counter1		; $5824
	ld (hl),$00		; $5826

_peahat_animate:
	jp enemyAnimate		; $5828


; Slowing down
_peahat_stateB:
	ld h,d			; $582b
	ld l,Enemy.counter1		; $582c
	inc (hl)		; $582e

	ld a,$80		; $582f
	cp (hl)			; $5831
	jp nz,_peahat_updatePosition		; $5832

	; Go to state 8 for $80 frames (if tile is non-solid) or 1 frame (if tile is
	; solid).
	ld (hl),$80 ; [counter1]
	push hl			; $5837
	call objectGetTileCollisions		; $5838
	pop hl			; $583b
	jr z,+			; $583c
	ld (hl),$01 ; [counter1]
+
	ld l,Enemy.state		; $5840
	ld (hl),$08		; $5842
	call objectSetVisiblec2		; $5844
	jr _peahat_animate		; $5847


;;
; @addr{5849}
_peahat_updateEnemyCollisionMode:
	ld e,Enemy.zh		; $5849
	ld a,(de)		; $584b
	or a			; $584c
	ld a,ENEMYCOLLISION_PEAHAT_VULNERABLE		; $584d
	jr z,+			; $584f
	ld a,ENEMYCOLLISION_PEAHAT		; $5851
+
	ld e,Enemy.enemyCollisionMode		; $5853
	ld (de),a		; $5855
	ret			; $5856

;;
; Adjusts speed based on counter1, updates position, animates.
; @addr{5857}
_peahat_updatePosition:
	ld e,Enemy.counter1		; $5857
	ld a,(de)		; $5859
	dec a			; $585a
	cp $41			; $585b
	jr nc,@animate	; $585d

	and $78			; $585f
	swap a			; $5861
	rlca			; $5863
	ld b,a			; $5864
	sub $06			; $5865
	jr c,+			; $5867
	xor a			; $5869
+
	ld e,Enemy.zh		; $586a
	ld (de),a		; $586c

	; Determine speed
	ld a,b			; $586d
	ld hl,@speedVals		; $586e
	rst_addAToHl			; $5871
	ld e,Enemy.speed		; $5872
	ld a,(hl)		; $5874
	ld (de),a		; $5875
	call objectApplySpeed		; $5876
	call _ecom_bounceOffScreenBoundary		; $5879

@animate:
	ld e,Enemy.counter1		; $587c
	ld a,(de)		; $587e
	and $f0			; $587f
	swap a			; $5881
	ld hl,@animFrequencies		; $5883
	rst_addAToHl			; $5886
	ld b,(hl)		; $5887
	ld a,b			; $5888
	inc a			; $5889
	jr nz,+			; $588a
	call enemyAnimate		; $588c
	ld b,$00		; $588f
+
	ld a,(wFrameCounter)		; $5891
	and b			; $5894
	jp z,enemyAnimate		; $5895
	ret			; $5898

@animFrequencies:
	.db $ff $ff $ff $00 $00 $01 $03 $07

@speedVals:
	.db SPEED_c0 SPEED_c0 SPEED_c0 SPEED_80 SPEED_80 SPEED_40 SPEED_40 SPEED_20
	.db SPEED_20

_peahat_counter1Vals:
	.db 180 180 210 210 240 240 0 0


; ==============================================================================
; ENEMYID_WIZZROBE
;
; Variables:
;   var30: The low byte of wWizzrobePositionReservations that this wizzrobe is using
;          (red wizzrobes only)
;   var31/var32: Target position (blue wizzrobes only)
; ==============================================================================
enemyCode40:
	call _ecom_checkHazardsNoAnimationForHoles		; $58b2
	jr z,@normalStatus	; $58b5
	sub ENEMYSTATUS_NO_HEALTH			; $58b7
	ret c			; $58b9
	jp z,enemyDie		; $58ba
	dec a			; $58bd
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $58be
	jr @justHit		; $58c1

@justHit:
	; For red wizzrobes only...
	ld e,Enemy.subid		; $58c3
	ld a,(de)		; $58c5
	dec a			; $58c6
	ret nz			; $58c7

	ld e,Enemy.stunCounter		; $58c8
	ld a,(de)		; $58ca
	or a			; $58cb
	ret nz			; $58cc

	ld e,Enemy.var2a		; $58cd
	ld a,(de)		; $58cf
	cp ITEMCOLLISION_LINK|$80			; $58d0
	ret z			; $58d2

	; The wizzrobe is knocked out of its normal position; allow other wizzrobes to
	; spawn there
	jp _wizzrobe_removePositionReservation		; $58d3

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $58d6
	jr nc,@normalState	; $58d9
	rst_jumpTable			; $58db
	.dw _wizzrobe_state_uninitialized
	.dw _wizzrobe_state_stub
	.dw _wizzrobe_state_stub
	.dw _wizzrobe_state_switchHook
	.dw _wizzrobe_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _wizzrobe_state_stub
	.dw _wizzrobe_state_stub

@normalState:
	ld a,b			; $58ec
	rst_jumpTable			; $58ed
	.dw _wizzrobe_subid0
	.dw _wizzrobe_subid1
	.dw _wizzrobe_subid2


_wizzrobe_state_uninitialized:
	ld h,d			; $58f4
	ld l,Enemy.visible		; $58f5
	ld a,(hl)		; $58f7
	or $42			; $58f8
	ld (hl),a		; $58fa

	ld l,e			; $58fb
	ld e,Enemy.subid		; $58fc
	ld a,(de)		; $58fe
	or a			; $58ff
	jr nz,@subid1Or2	; $5900

@subid0:
	ld (hl),$08 ; [state]
	ld l,Enemy.counter1		; $5904
	ld (hl),$50		; $5906
	ret			; $5908

@subid1Or2:
	dec a			; $5909
	jr nz,@subid2	; $590a

@subid1:
	ld (hl),$08 ; [state]
	ld hl,wWizzrobePositionReservations		; $590e
	ld b,$10		; $5911
	jp clearMemory		; $5913

@subid2:
	ld (hl),$0b ; [state]
	ld l,Enemy.speed		; $5918
	ld (hl),SPEED_80		; $591a

	ld l,Enemy.counter1		; $591c
	ld (hl),$08		; $591e
	call _ecom_setRandomCardinalAngle		; $5920
	jp _wizzrobe_setAnimationFromAngle		; $5923


_wizzrobe_state_switchHook:
	inc e			; $5926
	ld a,(de)		; $5927
	rst_jumpTable			; $5928
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $5931

@substate3:
	call _ecom_fallToGroundAndSetState		; $5932
	ret nz			; $5935

	ld l,Enemy.collisionType		; $5936
	res 7,(hl)		; $5938

	ld e,Enemy.subid		; $593a
	ld a,(de)		; $593c
	ld hl,@stateAndCounter1		; $593d
	rst_addDoubleIndex			; $5940

	ld e,Enemy.state		; $5941
	ldi a,(hl)		; $5943
	ld (de),a		; $5944
	ld e,Enemy.counter1		; $5945
	ld a,(hl)		; $5947
	ld (de),a		; $5948
	ret			; $5949

@stateAndCounter1:
	.db $0b,  30 ; 0 == [subid]
	.db $0b, 150 ; 1
	.db $09,   0 ; 2


_wizzrobe_state_stub:
	ret			; $5950


; Green wizzrobe
_wizzrobe_subid0:
	ld a,(de)		; $5951
	sub $08			; $5952
	rst_jumpTable			; $5954
	.dw _wizzrobe_subid0_state8
	.dw _wizzrobe_subid0_state9
	.dw _wizzrobe_subid0_stateA
	.dw _wizzrobe_subid0_stateB


; Waiting [counter1] frames before spawning in
_wizzrobe_subid0_state8:
	call _ecom_decCounter1		; $595d
	ret nz			; $5960
	ld (hl),75		; $5961
	ld l,e			; $5963
	inc (hl) ; [state]
	jp objectSetVisiblec2		; $5965


; Phasing in for [counter1] frames
_wizzrobe_subid0_state9:
	call _ecom_decCounter1		; $5968
	jp nz,_wizzrobe_checkFlickerVisibility		; $596b

	ld (hl),72 ; [counter1]
	ld l,e			; $5970
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $5972
	set 7,(hl)		; $5974

	call _ecom_updateCardinalAngleTowardTarget		; $5976
	jp _wizzrobe_setAnimationFromAngle		; $5979


; Fully phased in; standing there for [counter1] frames, and firing a projectile at some
; point
_wizzrobe_subid0_stateA:
	call _ecom_decCounter1		; $597c
	jr z,@phaseOut	; $597f

	; Fire a projectile when [counter1] == 52
	ld a,(hl)		; $5981
	cp 52			; $5982
	ret nz			; $5984
	ld b,PARTID_WIZZROBE_PROJECTILE		; $5985
	jp _ecom_spawnProjectile		; $5987

@phaseOut:
	ld l,e			; $598a
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $598c
	res 7,(hl)		; $598e

	xor a			; $5990
	jp enemySetAnimation		; $5991


; Phasing out
_wizzrobe_subid0_stateB:
	ld h,d			; $5994
	ld l,Enemy.counter1		; $5995
	inc (hl)		; $5997
	ld a,(hl)		; $5998
	cp 75			; $5999
	jp c,_wizzrobe_checkFlickerVisibility		; $599b

	ld (hl),72 ; [counter1]
	ld l,e			; $59a0
	ld (hl),$08 ; [state]
	jp objectSetInvisible		; $59a3


; Red wizzrobe
_wizzrobe_subid1:
	ld a,(de)		; $59a6
	sub $08			; $59a7
	rst_jumpTable			; $59a9
	.dw _wizzrobe_subid1_state8
	.dw _wizzrobe_subid1_state9
	.dw _wizzrobe_subid1_stateA
	.dw _wizzrobe_subid1_stateB


; Choosing a new position to spawn at
_wizzrobe_subid1_state8:
	call _wizzrobe_chooseSpawnPosition		; $59b2
	ret nz			; $59b5
	call _wizzrobe_markSpotAsTaken		; $59b6
	ret z			; $59b9

	ld h,d			; $59ba
	ld l,Enemy.yh		; $59bb
	ld (hl),b		; $59bd
	ld l,Enemy.xh		; $59be
	ld (hl),c		; $59c0

	ld l,Enemy.state		; $59c1
	inc (hl)		; $59c3

	ld l,Enemy.counter1		; $59c4
	ld (hl),60		; $59c6

	call _ecom_updateCardinalAngleTowardTarget		; $59c8
	jp _wizzrobe_setAnimationFromAngle		; $59cb


; Phasing in for [counter1] frames
_wizzrobe_subid1_state9:
	call _ecom_decCounter1		; $59ce
	jp nz,_ecom_flickerVisibility		; $59d1

	ld (hl),72 ; [counter1]
	ld l,e			; $59d6
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $59d8
	set 7,(hl)		; $59da
	jp objectSetVisiblec2		; $59dc


; Fully phased in; standing there for [counter1] frames, and firing a projectile at some
; point
_wizzrobe_subid1_stateA:
	call _ecom_decCounter1		; $59df
	jr z,@phaseOut	; $59e2

	; Fire a projectile when [counter1] == 52
	ld a,(hl)		; $59e4
	cp 52			; $59e5
	ret nz			; $59e7
	ld b,PARTID_WIZZROBE_PROJECTILE		; $59e8
	jp _ecom_spawnProjectile		; $59ea

@phaseOut:
	ld (hl),180 ; [counter1]
	ld l,e			; $59ef
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $59f1
	res 7,(hl)		; $59f3
	ret			; $59f5


; Phasing out
_wizzrobe_subid1_stateB:
	call _ecom_decCounter1		; $59f6
	jr z,@gotoState8	; $59f9

	ld a,(hl)		; $59fb
	cp 120			; $59fc
	ret c			; $59fe
	jp z,objectSetInvisible		; $59ff
	jp _ecom_flickerVisibility		; $5a02

@gotoState8:
	ld l,e			; $5a05
	ld (hl),$08 ; [state]


;;
; Removes position reservation in "wWizzrobePositionReservations" allowing other wizzrobes
; to spawn here.
; @addr{5a08}
_wizzrobe_removePositionReservation:
	ld h,d			; $5a08
	ld l,Enemy.var30		; $5a09
	ld l,(hl)		; $5a0b
	ld h,>wWizzrobePositionReservations		; $5a0c
	ld a,(hl)		; $5a0e
	sub d			; $5a0f
	ret nz			; $5a10
	ldd (hl),a		; $5a11
	ld (hl),a		; $5a12
	ret			; $5a13


; Blue wizzrobe
_wizzrobe_subid2:
	ld a,(de)		; $5a14
	sub $08			; $5a15
	rst_jumpTable			; $5a17
	.dw _wizzrobe_subid2_state8
	.dw _wizzrobe_subid2_state9
	.dw _wizzrobe_subid2_stateA
	.dw _wizzrobe_subid2_stateB


; Currently phased in, attacking until [counter1] reaches 0 or it hits a wall
_wizzrobe_subid2_state8:
	call _ecom_decCounter1		; $5a20
	jr z,@phaseOut	; $5a23

	; Reorient toward Link in [counter2] frames
	inc l			; $5a25
	dec (hl) ; [counter2]
	jr nz,@updatePosition	; $5a27

	call _ecom_updateCardinalAngleTowardTarget		; $5a29
	call _wizzrobe_setAnimationFromAngle		; $5a2c

	; Set random counter2 from $20-$5f
	call getRandomNumber_noPreserveVars		; $5a2f
	and $3f			; $5a32
	add $20			; $5a34
	ld e,Enemy.counter2		; $5a36
	ld (de),a		; $5a38

@updatePosition:
	call _wizzrobe_fireEvery32Frames		; $5a39
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5a3c
	ret nz			; $5a3f

@phaseOut:
	call _ecom_incState		; $5a40
	ld l,Enemy.collisionType		; $5a43
	res 7,(hl)		; $5a45
	ret			; $5a47


; Currently phased out, choosing a target position
_wizzrobe_subid2_state9:
	call _wizzrobe_chooseSpawnPosition		; $5a48
	jp nz,_ecom_flickerVisibility		; $5a4b

	; Store target position
	ld h,d			; $5a4e
	ld l,Enemy.var31		; $5a4f
	ld (hl),b		; $5a51
	inc l			; $5a52
	ld (hl),c		; $5a53

	ld l,Enemy.state		; $5a54
	inc (hl)		; $5a56

	ld l,Enemy.zh		; $5a57
	dec (hl)		; $5a59

	call _wizzrobe_setAngleTowardTargetPosition		; $5a5a
	jr _wizzrobe_setAnimationFromAngle		; $5a5d


; Currently phased out, moving toward target position
_wizzrobe_subid2_stateA:
	call _wizzrobe_setAngleTowardTargetPosition		; $5a5f
	call _ecom_flickerVisibility		; $5a62
	call _wizzrobe_checkReachedTargetPosition		; $5a65
	jp nc,objectApplySpeed		; $5a68

	; Reached target position
	ld l,Enemy.state		; $5a6b
	inc (hl)		; $5a6d

	ld l,Enemy.counter1		; $5a6e
	ld (hl),$08		; $5a70

	ld l,Enemy.zh		; $5a72
	ld (hl),$00		; $5a74

	call _ecom_updateCardinalAngleTowardTarget		; $5a76
	call _wizzrobe_setAnimationFromAngle		; $5a79
	jp objectSetVisiblec2		; $5a7c


; Standing still for [counter1] frames (8 frames) before phasing in and attacking again
_wizzrobe_subid2_stateB:
	call _ecom_decCounter1		; $5a7f
	jp nz,_ecom_flickerVisibility		; $5a82

	ld h,d			; $5a85
	ld l,e			; $5a86
	ld (hl),$08 ; [state]

	ld l,Enemy.collisionType		; $5a89
	set 7,(hl)		; $5a8b

	; Choose random counter1 between $80-$ff (how long to stay in state 8)
	ld bc,$7f3f		; $5a8d
	call _ecom_randomBitwiseAndBCE		; $5a90
	ld e,Enemy.counter1		; $5a93
	ld a,b			; $5a95
	add $80			; $5a96
	ld (de),a		; $5a98

	; Choose random counter2 between $10-$4f (when to reorient toward Link)
	inc e			; $5a99
	ld a,c			; $5a9a
	add $10			; $5a9b
	ld (de),a		; $5a9d

	call _ecom_updateCardinalAngleTowardTarget		; $5a9e
	call _wizzrobe_setAnimationFromAngle		; $5aa1
	jp objectSetVisiblec2		; $5aa4

;;
; @addr{5aa7}
_wizzrobe_setAnimationFromAngle:
	ld e,Enemy.angle		; $5aa7
	ld a,(de)		; $5aa9
	add $04			; $5aaa
	and $18			; $5aac
	swap a			; $5aae
	rlca			; $5ab0
	inc a			; $5ab1
	jp enemySetAnimation		; $5ab2

;;
; Flicker visibility when [counter1] < 45.
; @addr{5ab5}
_wizzrobe_checkFlickerVisibility:
	ld e,Enemy.counter1		; $5ab5
	ld a,(de)		; $5ab7
	cp 45			; $5ab8
	ret c			; $5aba
	jp _ecom_flickerVisibility		; $5abb

;;
; @param[out]	cflag	c if within 1 pixel of target position in both directions
; @addr{5abe}
_wizzrobe_checkReachedTargetPosition:
	ld h,d			; $5abe
	ld l,Enemy.yh		; $5abf
	ld e,Enemy.var31		; $5ac1
	ld a,(de)		; $5ac3
	sub (hl)		; $5ac4
	inc a			; $5ac5
	cp $03			; $5ac6
	ret nc			; $5ac8
	ld l,Enemy.xh		; $5ac9
	inc e			; $5acb
	ld a,(de)		; $5acc
	sub (hl)		; $5acd
	inc a			; $5ace
	cp $03			; $5acf
	ret			; $5ad1


;;
; @addr{5ad2}
_wizzrobe_setAngleTowardTargetPosition:
	ld h,d			; $5ad2
	ld l,Enemy.var31		; $5ad3
	call _ecom_readPositionVars		; $5ad5
	call objectGetRelativeAngleWithTempVars		; $5ad8
	ld e,Enemy.angle		; $5adb
	ld (de),a		; $5add
	ret			; $5ade


;;
; Chooses a random position somewhere within the screen boundaries (accounting for camera
; position). It may choose a solid position (in which case this need to be called again).
;
; @param[out]	bc	Chosen position (long form)
; @param[out]	l	Chosen position (short form)
; @param[out]	zflag	nz if this tile has solidity
; @addr{5adf}
_wizzrobe_chooseSpawnPosition:
	call getRandomNumber_noPreserveVars		; $5adf
	and $70 ; Value strictly under SCREEN_HEIGHT<<4
	ld b,a			; $5ae4
	ldh a,(<hCameraY)	; $5ae5
	add b			; $5ae7
	and $f0			; $5ae8
	add $08			; $5aea
	ld b,a			; $5aec
--
	call getRandomNumber		; $5aed
	and $f0			; $5af0
	cp SCREEN_WIDTH<<4			; $5af2
	jr nc,--		; $5af4

	ld c,a			; $5af6
	ldh a,(<hCameraX)	; $5af7
	add c			; $5af9
	and $f0			; $5afa
	add $08			; $5afc
	ld c,a			; $5afe
	jp getTileCollisionsAtPosition		; $5aff

;;
; @addr{5b02}
_wizzrobe_fireEvery32Frames:
	ld e,Enemy.counter1		; $5b02
	ld a,(de)		; $5b04
	and $1f			; $5b05
	ret nz			; $5b07
	ld b,PARTID_WIZZROBE_PROJECTILE		; $5b08
	jp _ecom_spawnProjectile		; $5b0a


;;
; Marks a spot as taken in wWizzrobePositionReservations; the position is reserved so no
; other red wizzrobe can spawn there. If this position is already reserved, this returns
; with the zflag set.
;
; @param	l	Position
; @param[out]	zflag	z if position already reserved, or wWizzrobePositionReservations
;			is full
; @addr{5b0d}
_wizzrobe_markSpotAsTaken:
	push bc			; $5b0d
	ld e,l			; $5b0e
	ld b,$08		; $5b0f
	ld c,b			; $5b11
	ld hl,wWizzrobePositionReservations		; $5b12
--
	ldi a,(hl)		; $5b15
	cp e			; $5b16
	jr z,@ret	; $5b17
	inc l			; $5b19
	dec b			; $5b1a
	jr nz,--		; $5b1b

	ld l,<wWizzrobePositionReservations		; $5b1d
--
	ld a,(hl)		; $5b1f
	or a			; $5b20
	jr z,@fillBlankSpot	; $5b21
	inc l			; $5b23
	inc l			; $5b24
	dec c			; $5b25
	jr nz,--		; $5b26
	jr @ret		; $5b28

@fillBlankSpot:
	ld (hl),e		; $5b2a
	inc l			; $5b2b
	ld (hl),d		; $5b2c
	ld e,Enemy.var30		; $5b2d
	ld a,l			; $5b2f
	ld (de),a		; $5b30
	or d			; $5b31

@ret:
	pop bc			; $5b32
	ret			; $5b33


; ==============================================================================
; ENEMYID_CROW
; ENEMYID_BLUE_CROW
;
; Variables:
;   var30: "Base" animation index (direction gets added to this)
;   var31: Actual animation index
;   var32/var33: Target position (subid 1 only)
; ==============================================================================
enemyCode41:
enemyCode4c:
	jr z,@normalStatus	; $5b34
	sub ENEMYSTATUS_NO_HEALTH			; $5b36
	ret c			; $5b38
	jp z,enemyDie		; $5b39
	dec a			; $5b3c
	ret z			; $5b3d
	jp _ecom_updateKnockbackNoSolidity		; $5b3e

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5b41
	jr nc,@normalState	; $5b44
	rst_jumpTable			; $5b46
	.dw _crow_state_uninitialized
	.dw _crow_state_stub
	.dw _crow_state_stub
	.dw _crow_state_stub
	.dw _crow_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _crow_state_stub
	.dw _crow_state_stub

@normalState:
	ld a,b			; $5b57
	rst_jumpTable			; $5b58
	.dw _crow_subid0
	.dw _crow_subid1


_crow_state_uninitialized:
	ld e,Enemy.subid		; $5b5d
	ld a,(de)		; $5b5f
	or a			; $5b60
	jp nz,_ecom_setSpeedAndState8		; $5b61

	; Subid 0
	ld a,SPEED_140		; $5b64
	call _ecom_setSpeedAndState8		; $5b66
	jp objectSetVisiblec1		; $5b69


_crow_state_stub:
	ret			; $5b6c


_crow_subid0:
	ld a,(de)		; $5b6d
	sub $08			; $5b6e
	rst_jumpTable			; $5b70
	.dw _crow_subid0_state8
	.dw _crow_subid0_state9
	.dw _crow_subid0_stateA


; Perched, waiting for Link to approach
_crow_subid0_state8:
	call _ecom_updateAngleTowardTarget		; $5b77
	call _crow_setAnimationFromAngle		; $5b7a

	; Check if Link has approached
	ld h,d			; $5b7d
	ld l,Enemy.yh		; $5b7e
	ldh a,(<hEnemyTargetY)	; $5b80
	sub (hl)		; $5b82
	add $30			; $5b83
	cp $61			; $5b85
	ret nc			; $5b87

	ld l,Enemy.xh		; $5b88
	ldh a,(<hEnemyTargetX)	; $5b8a
	sub (hl)		; $5b8c
	add $18			; $5b8d
	cp $31			; $5b8f
	ret nc			; $5b91

	; Link has approached.
	call _ecom_incState		; $5b92
	ld l,Enemy.counter1		; $5b95
	ld (hl),25		; $5b97

	ld l,Enemy.var30		; $5b99
	ld (hl),$02		; $5b9b
	ret			; $5b9d


; Moving up and preparing to charge at Link after [counter1] frames (25 frames)
_crow_subid0_state9:
	call _ecom_updateAngleTowardTarget		; $5b9e
	call _crow_setAnimationFromAngle		; $5ba1
	call _ecom_decCounter1		; $5ba4
	jr z,@beginCharge	; $5ba7

	ld a,(hl) ; [counter1]
	and $03			; $5baa
	jr nz,_crow_subid0_animate	; $5bac

	ld l,Enemy.zh		; $5bae
	dec (hl)		; $5bb0
	jr _crow_subid0_animate		; $5bb1

@beginCharge:
	inc l			; $5bb3
	ld (hl),90 ; [counter2]

	ld l,Enemy.state		; $5bb6
	inc (hl)		; $5bb8

	ld l,Enemy.collisionType		; $5bb9
	set 7,(hl)		; $5bbb

	call _ecom_updateAngleTowardTarget		; $5bbd

	; Randomly add or subtract 4 from angle (will either overshoot or undershoot Link)
	call getRandomNumber_noPreserveVars		; $5bc0
	and $04			; $5bc3
	jr nz,+			; $5bc5
	ld a,-$04		; $5bc7
+
	ld b,a			; $5bc9
	ld e,Enemy.angle		; $5bca
	ld a,(de)		; $5bcc
	add b			; $5bcd
	ld (de),a		; $5bce

	jr _crow_subid0_animate		; $5bcf


; Charging toward Link
_crow_subid0_stateA:
	call _crow_subid0_checkWithinScreenBounds		; $5bd1
	jp nc,enemyDelete		; $5bd4

	call _ecom_decCounter2		; $5bd7
	jr z,@applySpeed	; $5bda

	; Adjust angle toward Link every 8 frames
	ld a,(hl)		; $5bdc
	and $07			; $5bdd
	jr nz,@applySpeed	; $5bdf

	call objectGetAngleTowardEnemyTarget		; $5be1
	call objectNudgeAngleTowards		; $5be4
	call _crow_setAnimationFromAngle		; $5be7

@applySpeed:
	call objectApplySpeed		; $5bea

_crow_subid0_animate:
	jp enemyAnimate		; $5bed


_crow_subid1:
	ld a,(de)		; $5bf0
	sub $08			; $5bf1
	rst_jumpTable			; $5bf3
	.dw _crow_subid1_state8
	.dw _crow_subid1_state9
	.dw _crow_subid1_stateA
	.dw _crow_subid1_stateB
	.dw _crow_subid1_stateC
	.dw _crow_subid1_stateD


; Checking whether it's ok to charge in right now
_crow_subid1_state8:
	; Count the number of crows that are in state 9 or higher (number of crows that
	; are either about to or are already charging across the screen)
	ldhl FIRST_ENEMY_INDEX, Enemy.id		; $5c00
	ld b,$00		; $5c03
@nextEnemy:
	ld a,(hl)		; $5c05
	cp ENEMYID_CROW			; $5c06
	jr nz,++		; $5c08

	ld l,e ; l = state
	ldd a,(hl)		; $5c0b
	dec l			; $5c0c
	dec l			; $5c0d
	cp $09			; $5c0e
	jr c,++		; $5c10
	inc b			; $5c12
++
	inc h			; $5c13
	ld a,h			; $5c14
	cp LAST_ENEMY_INDEX+1			; $5c15
	jr c,@nextEnemy	; $5c17

	; Only allow 2 such crows at a time (this one needs to wait)
	ld a,b			; $5c19
	cp $02			; $5c1a
	ret nc			; $5c1c

	ld h,d			; $5c1d
	ld l,e			; $5c1e
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $5c20
	or a			; $5c22
	ld a,60   ; 1st crow on-screen
	jr z,+			; $5c25
	ld a,240  ; 2nd crow on-screen
+
	ld (hl),a		; $5c29

	ld l,Enemy.var30		; $5c2a
	ld (hl),$02		; $5c2c
	ret			; $5c2e


; Spawn in after [counter1] frames
_crow_subid1_state9:
	call _ecom_decCounter1		; $5c2f
	ret nz			; $5c32

	; Determine spawn/target position data to read based on which screen quadrant Link
	; is in
	ld b,$00		; $5c33
	ldh a,(<hEnemyTargetY)	; $5c35
	cp (SMALL_ROOM_HEIGHT/2)<<4			; $5c37
	jr c,+			; $5c39
	ld b,$08		; $5c3b
+
	ldh a,(<hEnemyTargetX)	; $5c3d
	cp (SMALL_ROOM_WIDTH/2)<<4			; $5c3f
	jr c,+			; $5c41
	set 2,b			; $5c43
+
	ld a,b			; $5c45
	ld hl,_crow_offScreenSpawnData		; $5c46
	rst_addAToHl			; $5c49

	; Read in spawn position
	ld e,Enemy.yh		; $5c4a
	ldi a,(hl)		; $5c4c
	ld (de),a		; $5c4d
	ldh (<hFF8F),a	; $5c4e

	ld e,Enemy.xh		; $5c50
	ldi a,(hl)		; $5c52
	ld (de),a		; $5c53
	ldh (<hFF8E),a	; $5c54

	; Read in target position
	ld e,Enemy.var32		; $5c56
	ldi a,(hl)		; $5c58
	ld (de),a		; $5c59
	ld b,a			; $5c5a

	inc e			; $5c5b
	ld a,(hl)		; $5c5c
	ld (de),a		; $5c5d
	ld c,a			; $5c5e

	; Set angle to target position
	call _ecom_updateAngleTowardTarget		; $5c5f

	call _ecom_incState		; $5c62

	ld l,Enemy.collisionType		; $5c65
	set 7,(hl)		; $5c67

	ld l,Enemy.speed		; $5c69
	ld (hl),SPEED_80		; $5c6b

	ld l,Enemy.zh		; $5c6d
	ld (hl),-$06		; $5c6f

	call _crow_setAnimationFromAngle		; $5c71
	jp objectSetVisiblec1		; $5c74


; Moving into screen
_crow_subid1_stateA:
	call _crow_moveTowardTargetPosition		; $5c77
	jr nc,_crow_subid1_animate	; $5c7a

	ld l,e			; $5c7c
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $5c7e
	ld (hl),60		; $5c80

	call _ecom_updateAngleTowardTarget		; $5c82
	call _crow_setAnimationFromAngle		; $5c85

_crow_subid1_animate:
	jp enemyAnimate		; $5c88


; Hovering in position for [counter1] frames before charging
_crow_subid1_stateB:
	call _ecom_decCounter1		; $5c8b
	jr nz,_crow_subid1_animate	; $5c8e

	ld (hl),24  ; [counter1]
	inc l			; $5c92
	ld (hl),$00 ; [counter2]

	ld l,e			; $5c95
	inc (hl) ; [state]

	ld l,Enemy.var32		; $5c97
	ldh a,(<hEnemyTargetY)	; $5c99
	ldi (hl),a		; $5c9b
	ldh a,(<hEnemyTargetX)	; $5c9c
	ld (hl),a		; $5c9e

	ld l,Enemy.speed		; $5c9f
	ld (hl),SPEED_20		; $5ca1
	jr _crow_subid1_animate		; $5ca3


; Moving, accelerating toward Link
_crow_subid1_stateC:
	call _crow_subid1_checkWithinScreenBounds		; $5ca5
	jr nc,@outOfBounds	; $5ca8

	call _crow_updateAngleTowardLinkIfCounter1Zero		; $5caa
	call _crow_updateSpeed		; $5cad
	call objectApplySpeed		; $5cb0
	jr _crow_subid1_animate		; $5cb3

@outOfBounds:
	call _ecom_incState		; $5cb5
	jr _crow_subid1_animate		; $5cb8


; Moved out of bounds; go back to state 8 to eventually charge again
_crow_subid1_stateD:
	ld h,d			; $5cba
	ld l,e			; $5cbb
	ld (hl),$08 ; [state]

	ld l,Enemy.collisionType		; $5cbe
	res 7,(hl)		; $5cc0

	jp objectSetInvisible		; $5cc2


;;
; Adjusts angle to move directly toward Link when [counter1] reaches 0. After this it
; underflows to 255, so the angle correction only happens once.
; @addr{5cc5}
_crow_updateAngleTowardLinkIfCounter1Zero:
	call _ecom_decCounter1		; $5cc5
	ret nz			; $5cc8
	call _ecom_updateAngleTowardTarget		; $5cc9


;;
; @addr{5ccc}
_crow_setAnimationFromAngle:
	ld h,d			; $5ccc
	ld l,Enemy.angle		; $5ccd
	ld a,(hl)		; $5ccf
	and $0f			; $5cd0
	ret z			; $5cd2

	bit 4,(hl)		; $5cd3
	ld l,Enemy.var30		; $5cd5
	ld a,(hl)		; $5cd7
	jr nz,+			; $5cd8
	inc a			; $5cda
+
	ld l,Enemy.var31		; $5cdb
	cp (hl)			; $5cdd
	ret z			; $5cde
	ld (hl),a		; $5cdf
	jp enemySetAnimation		; $5ce0

;;
; Identical to _crow_subid1_checkWithinScreenBounds.
;
; @param[out]	cflag	c if within screen bounds
; @addr{5ce3}
_crow_subid0_checkWithinScreenBounds:
	ld e,Enemy.yh		; $5ce3
	ld a,(de)		; $5ce5
	cp SMALL_ROOM_HEIGHT<<4 + 8			; $5ce6
	ret nc			; $5ce8
	ld e,Enemy.xh		; $5ce9
	ld a,(de)		; $5ceb
	cp SMALL_ROOM_WIDTH<<4 + 8			; $5cec
	ret			; $5cee

;;
; @param[out]	cflag	c if within 1 pixel of target position
; @addr{5cef}
_crow_moveTowardTargetPosition:
	ld h,d			; $5cef
	ld l,Enemy.var32		; $5cf0
	call _ecom_readPositionVars		; $5cf2
	sub c			; $5cf5
	inc a			; $5cf6
	cp $02			; $5cf7
	jr nc,@moveToward	; $5cf9

	ldh a,(<hFF8F)	; $5cfb
	sub b			; $5cfd
	inc a			; $5cfe
	cp $02			; $5cff
	ret c			; $5d01

@moveToward:
	call _ecom_moveTowardPosition		; $5d02
	call _crow_setAnimationFromAngle		; $5d05
	or d			; $5d08
	ret			; $5d09

;;
; Updates speed based on counter2. For subid 1.
; @addr{5d0a}
_crow_updateSpeed:
	ld e,Enemy.counter2		; $5d0a
	ld a,(de)		; $5d0c
	cp $7f			; $5d0d
	jr z,+			; $5d0f
	inc a			; $5d11
	ld (de),a		; $5d12
+
	and $f0			; $5d13
	swap a			; $5d15
	ld hl,_crow_speeds		; $5d17
	rst_addAToHl			; $5d1a
	ld e,Enemy.speed		; $5d1b
	ld a,(hl)		; $5d1d
	ld (de),a		; $5d1e
	ret			; $5d1f


;;
; Identical to _crow_subid0_checkWithinScreenBounds.
;
; @param[out]	cflag	c if within screen bounds
; @addr{5d20}
_crow_subid1_checkWithinScreenBounds:
	ld e,Enemy.yh		; $5d20
	ld a,(de)		; $5d22
	cp SCREEN_HEIGHT<<4 + 8			; $5d23
	ret nc			; $5d25
	ld e,Enemy.xh		; $5d26
	ld a,(de)		; $5d28
	cp SCREEN_WIDTH<<4 + 8			; $5d29
	ret			; $5d2b


; Speeds for subid 1; accerelates while chasing Link.
_crow_speeds:
	.db SPEED_040 SPEED_080 SPEED_0c0 SPEED_100
	.db SPEED_140 SPEED_180 SPEED_1c0 SPEED_200

; Each row corresponds to a screen quadrant Link is in.
; Byte values:
;   b0/b1: Spawn Y/X position
;   b2/b3: Target Y/X position (position to move to before charging in)
_crow_offScreenSpawnData:
	.db $60 $a0 $70 $90
	.db $60 $00 $70 $10
	.db $20 $a0 $10 $90
	.db $20 $00 $10 $10


; ==============================================================================
; ENEMYID_GEL
; ==============================================================================
enemyCode43:
	call _ecom_checkHazardsNoAnimationForHoles		; $5d44
	jr z,@normalStatus	; $5d47
	sub ENEMYSTATUS_NO_HEALTH			; $5d49
	ret c			; $5d4b
	jp z,enemyDie		; $5d4c

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.var2a		; $5d4f
	ld a,(de)		; $5d51
	cp $80|ITEMCOLLISION_LINK			; $5d52
	jr nz,@normalStatus	; $5d54

	; Touched Link; attach self to him.
	ld e,Enemy.state		; $5d56
	ld a,$0c		; $5d58
	ld (de),a		; $5d5a

@normalStatus:
	ld e,Enemy.state		; $5d5b
	ld a,(de)		; $5d5d
	rst_jumpTable			; $5d5e
	.dw _gel_state_uninitialized
	.dw _gel_state_stub
	.dw _gel_state_stub
	.dw _gel_state_stub
	.dw _gel_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _gel_state_stub
	.dw _gel_state_stub
	.dw _gel_state8
	.dw _gel_state9
	.dw _gel_stateA
	.dw _gel_stateB
	.dw _gel_stateC
	.dw _gel_stateD


_gel_state_uninitialized:
	ld e,Enemy.counter1		; $5d7b
	ld a,$10		; $5d7d
	ld (de),a		; $5d7f
	jp _ecom_setSpeedAndState8AndVisible		; $5d80


_gel_state_stub:
	ret			; $5d83


; Standing in place for [counter1] frames
_gel_state8:
	call _ecom_decCounter1		; $5d84
	jr nz,_gel_animate	; $5d87

	; 1 in 8 chance of switching to "hopping" state
	call getRandomNumber_noPreserveVars		; $5d89
	and $07			; $5d8c
	ld h,d			; $5d8e
	jr nz,@inchForward	; $5d8f

	; Prepare to hop
	ld l,Enemy.counter1		; $5d91
	ld (hl),$30		; $5d93

	ld l,Enemy.state		; $5d95
	ld (hl),$0a		; $5d97

	ld a,$02		; $5d99
	jp enemySetAnimation		; $5d9b

@inchForward:
	ld l,Enemy.counter1		; $5d9e
	ld (hl),$08		; $5da0

	ld l,Enemy.state		; $5da2
	inc (hl)		; $5da4

	ld l,Enemy.speed		; $5da5
	ld (hl),SPEED_40		; $5da7

	call _ecom_updateAngleTowardTarget		; $5da9
	jr _gel_animate		; $5dac


; Inching toward Link for [counter1] frames
_gel_state9:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5dae
	call _ecom_decCounter1		; $5db1
	jr nz,_gel_animate	; $5db4

	ld l,Enemy.state		; $5db6
	ld (hl),$08		; $5db8
	ld l,Enemy.counter1		; $5dba
	ld (hl),$10		; $5dbc

_gel_animate:
	jp enemyAnimate		; $5dbe


; Preparing to hop toward Link
_gel_stateA:
	call _ecom_decCounter1		; $5dc1
	jr nz,_gel_animate	; $5dc4

	call _gel_beginHop		; $5dc6
	jp _ecom_updateAngleTowardTarget		; $5dc9


; Hopping toward Link
_gel_stateB:
	call _ecom_applyVelocityForSideviewEnemy		; $5dcc
	ld c,$28		; $5dcf
	call objectUpdateSpeedZ_paramC		; $5dd1
	ret nz			; $5dd4

	; Just landed

	ld h,d			; $5dd5
	ld l,Enemy.state		; $5dd6
	ld (hl),$08		; $5dd8

	ld l,Enemy.counter1		; $5dda
	ld (hl),$10		; $5ddc

	ld l,Enemy.collisionType		; $5dde
	set 7,(hl)		; $5de0
	jp objectSetVisiblec2		; $5de2


; Just latched onto Link
_gel_stateC:
	ld h,d			; $5de5
	ld l,e			; $5de6
	inc (hl) ; [state]

	ld l,Enemy.counter2		; $5de8
	ld (hl),120		; $5dea

	ld a,$01		; $5dec
	jp enemySetAnimation		; $5dee


; Attached to Link, slowing him down
_gel_stateD:
	ld a,(w1Link.yh)		; $5df1
	ld e,Enemy.yh		; $5df4
	ld (de),a		; $5df6
	ld a,(w1Link.xh)		; $5df7
	ld e,Enemy.xh		; $5dfa
	ld (de),a		; $5dfc

	call _ecom_decCounter2		; $5dfd
	jr z,@hopOff	; $5e00

	; If any button is pressed, counter2 goes down more quickly
	ld a,(wGameKeysJustPressed)		; $5e02
	or a			; $5e05
	jr z,++		; $5e06

	ld a,(hl) ; [counter2]
	sub $03			; $5e09
	jr nc,+			; $5e0b
	ld a,$01		; $5e0d
+
	ld (hl),a		; $5e0f
++
	; Invert draw priority every 4 frames
	ld a,(hl)		; $5e10
	and $03			; $5e11
	jr nz,++		; $5e13
	ld l,Enemy.visible		; $5e15
	ld a,(hl)		; $5e17
	xor $07			; $5e18
	ld (hl),a		; $5e1a
++
	; Disable use of sword
	ld hl,wccd8		; $5e1b
	set 5,(hl)		; $5e1e

	; Disable movement every other frame
	ld a,(wFrameCounter)		; $5e20
	rrca			; $5e23
	jr nc,_gel_animate	; $5e24
	ld hl,wLinkImmobilized		; $5e26
	set 5,(hl)		; $5e29
	jr _gel_animate		; $5e2b

@hopOff:
	call _gel_setAngleAwayFromLink		; $5e2d
	jr _gel_beginHop		; $5e30


;;
; @addr{5e32}
_gel_beginHop:
	ld bc,-$200		; $5e32
	call objectSetSpeedZ		; $5e35

	ld l,Enemy.state		; $5e38
	ld (hl),$0b		; $5e3a

	ld l,Enemy.speed		; $5e3c
	ld (hl),SPEED_100		; $5e3e

	xor a			; $5e40
	call enemySetAnimation		; $5e41

	ld a,SND_ENEMY_JUMP		; $5e44
	call playSound		; $5e46
	jp objectSetVisiblec1		; $5e49

;;
; @addr{5e4c}
_gel_setAngleAwayFromLink:
	ld a,(w1Link.angle)		; $5e4c
	bit 7,a			; $5e4f
	jp nz,_ecom_setRandomAngle		; $5e51
	xor $10			; $5e54
	ld e,Enemy.angle		; $5e56
	ld (de),a		; $5e58
	ret			; $5e59


; ==============================================================================
; ENEMYID_PINCER
;
; Variables:
;   relatedObj1: Pointer to "head", aka subid 1 (only for body parts, subids 2+)
;   var31/var32: Base Y/X position (where it originates from)
;   var33: Amount extended (0 means still in hole)
;   var34: Copy of parent's "id" value. For body parts only.
; ==============================================================================
enemyCode45:
	jr z,@normalStatus	; $5e5a
	sub ENEMYSTATUS_NO_HEALTH			; $5e5c
	ret c			; $5e5e
	jp z,enemyDie		; $5e5f

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5e62
	jr nc,@normalState	; $5e65
	rst_jumpTable			; $5e67
	.dw _pincer_state_uninitialized
	.dw _pincer_state1
	.dw _pincer_state_stub
	.dw _pincer_state_stub
	.dw _pincer_state_stub
	.dw _pincer_state_stub
	.dw _pincer_state_stub
	.dw _pincer_state_stub

@normalState:
	dec b			; $5e78
	ld a,b			; $5e79
	rst_jumpTable			; $5e7a
	.dw _pincer_head
	.dw _pincer_body
	.dw _pincer_body
	.dw _pincer_body


_pincer_state_uninitialized:
	ld a,b			; $5e83
	or a			; $5e84
	jp nz,_ecom_setSpeedAndState8		; $5e85

	; subid 0 only
	inc a			; $5e88
	ld (de),a ; [state] = 1


; Spawner only (subid 0): Spawn head and body parts, then delete self.
_pincer_state1:
	ld b,$04		; $5e8a
	call checkBEnemySlotsAvailable		; $5e8c
	ret nz			; $5e8f

	; Spawn head
	ld b,ENEMYID_PINCER		; $5e90
	call _ecom_spawnUncountedEnemyWithSubid01		; $5e92
	ld l,Enemy.enabled		; $5e95
	ld e,l			; $5e97
	ld a,(de)		; $5e98
	ld (hl),a		; $5e99
	call objectCopyPosition		; $5e9a

	; Spawn body parts
	ld c,h			; $5e9d
	call _ecom_spawnUncountedEnemyWithSubid01		; $5e9e
	call _pincer_setChildRelatedObj1		; $5ea1
	; [child.subid] = 2 (incremented in above function call)

	call _ecom_spawnUncountedEnemyWithSubid01		; $5ea4
	inc (hl)
	call _pincer_setChildRelatedObj1		; $5ea8
	; [child.subid] = 3

	call _ecom_spawnUncountedEnemyWithSubid01		; $5eab
	inc (hl)		; $5eae
	inc (hl)
	call _pincer_setChildRelatedObj1		; $5eb0
	; [child.subid] = 4

	; Spawner no longer needed
	jp enemyDelete		; $5eb3


_pincer_state_stub:
	ret			; $5eb6


; Subid 1: Head of pincer (the "main" part, which is attackable)
_pincer_head:
	ld a,(de)		; $5eb7
	sub $08			; $5eb8
	rst_jumpTable			; $5eba
	.dw _pincer_head_state8
	.dw _pincer_head_state9
	.dw _pincer_head_stateA
	.dw _pincer_head_stateB
	.dw _pincer_head_stateC
	.dw _pincer_head_stateD
	.dw _pincer_head_stateE


; Initialization
_pincer_head_state8:
	ld h,d			; $5ec9
	ld l,e			; $5eca
	inc (hl) ; [state]

	ld e,Enemy.yh		; $5ecc
	ld l,Enemy.var31		; $5ece
	ld a,(de)		; $5ed0
	ldi (hl),a		; $5ed1
	ld e,Enemy.xh		; $5ed2
	ld a,(de)		; $5ed4
	ld (hl),a		; $5ed5
	ret			; $5ed6


; Waiting for Link to approach
_pincer_head_state9:
	ld c,$28		; $5ed7
	call objectCheckLinkWithinDistance		; $5ed9
	ret nc			; $5edc

	ld e,Enemy.state		; $5edd
	ld a,$0a		; $5edf
	ld (de),a		; $5ee1
	jp objectSetVisible82		; $5ee2


; Showing eyes as a "warning" that it's about to attack
_pincer_head_stateA:
	ld e,Enemy.animParameter		; $5ee5
	ld a,(de)		; $5ee7
	dec a			; $5ee8
	jp nz,enemyAnimate		; $5ee9

	; Time to attack
	call _ecom_incState		; $5eec

	ld l,Enemy.collisionType		; $5eef
	set 7,(hl)		; $5ef1

	; Initial "extended" amount is 0
	ld l,Enemy.var33		; $5ef3
	ld (hl),$00		; $5ef5

	; "Dig up" the tile if coming from underground
	ld l,Enemy.yh		; $5ef7
	ld b,(hl)		; $5ef9
	ld l,Enemy.xh		; $5efa
	ld c,(hl)		; $5efc
	ld a,BREAKABLETILESOURCE_06		; $5efd
	call tryToBreakTile		; $5eff
.ifdef ROM_AGES
	; If in water, create a splash
	call objectCheckTileAtPositionIsWater		; $5f02
	jr nc,++		; $5f05

	call getFreeInteractionSlot		; $5f07
	jr nz,++		; $5f0a
	ld (hl),INTERACID_SPLASH		; $5f0c
	ld bc,$fa00		; $5f0e
	call objectCopyPositionWithOffset		; $5f11
++
.endif
	call _ecom_updateAngleTowardTarget		; $5f14
	add $02			; $5f17
	and $1c			; $5f19
	rrca			; $5f1b
	rrca			; $5f1c
	inc a			; $5f1d
	jp enemySetAnimation		; $5f1e


; Extending toward target
_pincer_head_stateB:
	call _pincer_updatePosition		; $5f21

	ld e,Enemy.var33		; $5f24
	ld a,(de)		; $5f26
	add $02			; $5f27
	cp $20			; $5f29
	jr nc,@fullyExtended	; $5f2b
	ld (de),a		; $5f2d
	ret			; $5f2e

@fullyExtended:
	call _ecom_incState		; $5f2f
	ld l,Enemy.counter1		; $5f32
	ld (hl),$08		; $5f34
	ret			; $5f36


; Staying fully extended for several frames
_pincer_head_stateC:
	call _ecom_decCounter1		; $5f37
	ret nz			; $5f3a
	ld l,e			; $5f3b
	inc (hl) ; [state]
	ret			; $5f3d


; Retracting
_pincer_head_stateD:
	call _pincer_updatePosition		; $5f3e

	ld h,d			; $5f41
	ld l,Enemy.var33		; $5f42
	dec (hl)		; $5f44
	ret nz			; $5f45

	; Fully retracted
	ld l,Enemy.counter1		; $5f46
	ld (hl),30		; $5f48

	ld l,Enemy.state		; $5f4a
	inc (hl)		; $5f4c

	ld l,Enemy.collisionType		; $5f4d
	res 7,(hl)		; $5f4f
	jp objectSetInvisible		; $5f51


; Fully retracted; on cooldown
_pincer_head_stateE:
	call _ecom_decCounter1		; $5f54
	ret nz			; $5f57

	; Cooldown over
	ld l,e			; $5f58
	ld (hl),$09 ; [state]

	; Make sure Y/X position is fully fixed back to origin
	ld l,Enemy.var31		; $5f5b
	ld e,Enemy.yh		; $5f5d
	ldi a,(hl)		; $5f5f
	ld (de),a		; $5f60
	ld e,Enemy.xh		; $5f61
	ld a,(hl)		; $5f63
	ld (de),a		; $5f64

	xor a			; $5f65
	jp enemySetAnimation		; $5f66


;;
; Subid 2-4: body of pincer (just decoration)
; @addr{5f69}
_pincer_body:
	ld a,(de)		; $5f69
	sub $08			; $5f6a
	rst_jumpTable			; $5f6c
	.dw @state8
	.dw @state9

; Initialization
@state8:
	ld a,$09		; $5f71
	ld (de),a ; [state]

	; Copy parent's base position (var31/var32)
	ld a,Object.yh		; $5f74
	call objectGetRelatedObject1Var		; $5f76
	ld e,Enemy.var31		; $5f79
	ldi a,(hl)		; $5f7b
	ld (de),a		; $5f7c
	inc l			; $5f7d
	inc e			; $5f7e
	ld a,(hl)		; $5f7f
	ld (de),a		; $5f80

	ld e,Enemy.var34		; $5f81
	ld l,Enemy.id		; $5f83
	ld a,(hl)		; $5f85
	ld (de),a		; $5f86

	ld a,$09		; $5f87
	jp enemySetAnimation		; $5f89

@state9:
	; Check if parent was deleted
	ld a,Object.id		; $5f8c
	call objectGetRelatedObject1Var		; $5f8e
	ld e,Enemy.var34		; $5f91
	ld a,(de)		; $5f93
	cp (hl)			; $5f94
	jp nz,enemyDelete		; $5f95

	; Copy parent's angle, invincibilityCounter
	ld l,Enemy.angle		; $5f98
	ld e,l			; $5f9a
	ld a,(hl)		; $5f9b
	ld (de),a		; $5f9c
	ld l,Enemy.invincibilityCounter		; $5f9d
	ld e,l			; $5f9f
	ld a,(hl)		; $5fa0
	ld (de),a		; $5fa1

	; Copy parent's visibility only if parent is in state $0b or higher
	ld l,Enemy.state		; $5fa2
	ld a,(hl)		; $5fa4
	cp $0b			; $5fa5
	jr c,++		; $5fa7

	ld l,Enemy.visible		; $5fa9
	ld e,l			; $5fab
	ld a,(hl)		; $5fac
	ld (de),a		; $5fad
++
	call _pincer_body_updateExtendedAmount		; $5fae
	jr _pincer_updatePosition		; $5fb1


;;
; Sets relatedObj1 of object 'h' to object 'c'.
; 'h' is part of the pincer's body, 'c' is the pincer's head.
; Also increments the body part's subid since that does need to be done...
; @addr{5fb3}
_pincer_setChildRelatedObj1:
	inc (hl) ; [subid]++
	ld l,Enemy.relatedObj1		; $5fb4
	ld a,Enemy.start		; $5fb6
	ldi (hl),a		; $5fb8
	ld (hl),c		; $5fb9
	ret			; $5fba

;;
; Updates position based on "base position" (var31), angle, and distance extended (var33).
; @addr{5fbb}
_pincer_updatePosition:
	ld h,d			; $5fbb
	ld l,Enemy.var31		; $5fbc
	ld b,(hl)		; $5fbe
	inc l			; $5fbf
	ld c,(hl)		; $5fc0
	inc l			; $5fc1
	ld a,(hl)		; $5fc2
	ld e,Enemy.angle		; $5fc3
	jp objectSetPositionInCircleArc		; $5fc5

;;
; Calculates value for var33 (amount extended) for a body part.
; @addr{5fc8}
_pincer_body_updateExtendedAmount:
	push hl			; $5fc8
	ld e,Enemy.subid		; $5fc9
	ld a,(de)		; $5fcb
	sub $02			; $5fcc
	rst_jumpTable			; $5fce
	.dw @subid2
	.dw @subid3
	.dw @subid4

@subid2:
	pop hl			; $5fd5
	call @getExtendedAmountDividedByFour		; $5fd6
	ld b,a			; $5fd9
	add a			; $5fda
	add b			; $5fdb
	ld (de),a		; $5fdc
	ret			; $5fdd

@subid3:
	pop hl			; $5fde
	call @getExtendedAmountDividedByFour		; $5fdf
	add a			; $5fe2
	ld (de),a		; $5fe3
	ret			; $5fe4

@subid4:
	pop hl			; $5fe5
	call @getExtendedAmountDividedByFour		; $5fe6
	ld (de),a		; $5fe9
	ret			; $5fea

@getExtendedAmountDividedByFour:
	ld l,Enemy.var33		; $5feb
	ld e,l			; $5fed
	ld a,(hl)		; $5fee
	srl a			; $5fef
	srl a			; $5ff1
	ret			; $5ff3


; ==============================================================================
; ENEMYID_BALL_AND_CHAIN_SOLDIER
;
; Variables:
;   relatedObj2: reference to PARTID_SPIKED_BALL
;   counter1: Written to by PARTID_SPIKED_BALL?
;   var30: Signal for PARTID_SPIKED_BALL.
;          0: Ball should rotate at normal speed.
;          1: Ball should rotate at double speed.
;          2: Ball should be thrown at Link.
;   var31: State to return to after switch hook is used on enemy
; ==============================================================================
enemyCode4b:
	jr z,@normalStatus	; $5ff4
	sub ENEMYSTATUS_NO_HEALTH			; $5ff6
	ret c			; $5ff8
	jr nz,@normalStatus	; $5ff9
	jp enemyDie		; $5ffb

@normalStatus:
.ifdef ROM_AGES
	call _ecom_checkHazards		; $5ffe
.else
	call _ecom_seasonsFunc_4446		; $5ffe
.endif
	ld e,Enemy.state		; $6001
	ld a,(de)		; $6003
	rst_jumpTable			; $6004
	.dw _ballAndChain_state_uninitialized
	.dw _ballAndChain_state_stub
	.dw _ballAndChain_state_stub
	.dw _ballAndChain_state_switchHook
	.dw _ballAndChain_state_stub
	.dw _ballAndChain_state_stub
	.dw _ballAndChain_state_stub
	.dw _ballAndChain_state_stub
	.dw _ballAndChain_state8
	.dw _ballAndChain_state9
	.dw _ballAndChain_stateA


_ballAndChain_state_uninitialized:
	call _ballAndChain_spawnSpikedBall		; $601b
	ret nz			; $601e

	ld a,SPEED_60		; $601f
	call _ecom_setSpeedAndState8AndVisible		; $6021

	ld l,Enemy.var31		; $6024
	ld (hl),$08		; $6026
	ret			; $6028


_ballAndChain_state_switchHook:
	inc e			; $6029
	ld a,(de)		; $602a
	rst_jumpTable			; $602b
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $6034

@substate3:
	ld e,Enemy.var31		; $6035
	ld a,(de)		; $6037
	ld b,a			; $6038
	jp _ecom_fallToGroundAndSetState		; $6039


_ballAndChain_state_stub:
	ret			; $603c


; Waiting for Link to be close enough to attack
_ballAndChain_state8:
	ld c,$38		; $603d
	call objectCheckLinkWithinDistance		; $603f
	jr nc,@moveTowardLink	; $6042

	; Link is close enough
	call _ecom_incState		; $6044
	call _ballAndChain_setDefaultState		; $6047

	ld l,Enemy.counter1		; $604a
	ld (hl),90		; $604c

	; Signal PARTID_SPIKED_BALL to rotate faster
	ld l,Enemy.var30		; $604e
	inc (hl)		; $6050

	ld a,$01		; $6051
	jp enemySetAnimation		; $6053

@moveTowardLink:
	call _ecom_updateAngleTowardTarget		; $6056
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6059

_ballAndChain_animate:
	jp enemyAnimate		; $605c


; Spinning up ball for [counter1] frames before attacking
_ballAndChain_state9:
	call _ecom_decCounter1		; $605f
	jr nz,_ballAndChain_animate	; $6062

	inc (hl) ; [counter1]
	ld l,e			; $6065
	inc (hl) ; [state]

	call _ballAndChain_setDefaultState		; $6067

	; Signal PARTID_SPIKED_BALL to begin throw toward Link
	ld l,Enemy.var30		; $606a
	inc (hl)		; $606c
	ret			; $606d


; Waiting for PARTID_SPIKED_BALL to set this object's counter1 to 0 (signalling the throw
; is done)
_ballAndChain_stateA:
	ld e,Enemy.counter1		; $606e
	ld a,(de)		; $6070
	or a			; $6071
	ret nz			; $6072

	; Throw done

	ld c,$38		; $6073
	call objectCheckLinkWithinDistance		; $6075
	ld h,d			; $6078
	ld l,Enemy.state		; $6079
	jr nc,@gotoState8	; $607b

	; Link is close; attack again immediately
	dec (hl) ; [state] = 9
	call _ballAndChain_setDefaultState		; $607e
	ld l,Enemy.counter1		; $6081
	ld (hl),90		; $6083

	ld l,Enemy.var30		; $6085
	dec (hl)		; $6087
	ret			; $6088

@gotoState8:
	; Link isn't close; go to state 8, waiting for him to be close enough
	ld (hl),$08 ; [state]
	call _ballAndChain_setDefaultState		; $608b

	ld l,Enemy.var30		; $608e
	xor a			; $6090
	ld (hl),a		; $6091
	jp enemySetAnimation		; $6092


;;
; @param[out]	zflag	z if spawned successfully
; @addr{6095}
_ballAndChain_spawnSpikedBall:
	; BUG: This checks for 4 enemy slots, but we actually need 4 part slots...
	ld b,$04		; $6095
	call checkBEnemySlotsAvailable		; $6097
	ret nz			; $609a

	; Spawn the ball
	ld b,PARTID_SPIKED_BALL		; $609b
	call _ecom_spawnProjectile		; $609d

	; Spawn the 3 parts of the chain. Their "relatedObj1" will be set to the ball (not
	; this enemy).
	ld c,h			; $60a0
	ld e,$01		; $60a1
@nextChain:
	call getFreePartSlot		; $60a3
	ld (hl),b		; $60a6
	inc l			; $60a7
	ld (hl),e		; $60a8
	ld l,Part.relatedObj1		; $60a9
	ld a,Part.start		; $60ab
	ldi (hl),a		; $60ad
	ld (hl),c		; $60ae
	inc e			; $60af
	ld a,e			; $60b0
	cp $04			; $60b1
	jr nz,@nextChain	; $60b3
	ret			; $60b5


;;
; Sets state the enemy will return to after switch hook is used on it
;
; @param	hl	Pointer to state
; @addr{60b6}
_ballAndChain_setDefaultState:
	ld a,(hl)		; $60b6
	ld l,Enemy.var31		; $60b7
	ld (hl),a		; $60b9
	ret			; $60ba


; ==============================================================================
; ENEMYID_HARDHAT_BEETLE
; ENEMYID_HARMLESS_HARDHAT_BEETLE
; ==============================================================================
enemyCode4d:
.ifdef ROM_AGES
enemyCode5f:
.endif
	call _ecom_checkHazards		; $60bb
	jr z,@normalStatus	; $60be
	sub ENEMYSTATUS_NO_HEALTH			; $60c0
	ret c			; $60c2
	jp z,enemyDie		; $60c3
	dec a			; $60c6
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $60c7
	ret			; $60ca

@normalStatus:
	ld e,Enemy.state		; $60cb
	ld a,(de)		; $60cd
	rst_jumpTable			; $60ce
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8

@state_uninitialized:
.ifdef ROM_AGES
	ld e,Enemy.id		; $60e1
	ld a,(de)		; $60e3
	cp ENEMYID_HARMLESS_HARDHAT_BEETLE			; $60e4
	ld a,PALH_8d		; $60e6
	call z,loadPaletteHeader		; $60e8
.endif
	ld a,SPEED_60		; $60eb
	jp _ecom_setSpeedAndState8AndVisible		; $60ed

@state_stub:
	ret			; $60f0

@state8:
	call _ecom_updateAngleTowardTarget		; $60f1
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $60f4
	jp enemyAnimate		; $60f7


.ifdef ROM_AGES
; ==============================================================================
; ENEMYID_LINK_MIMIC
;
; Shares code with ENEMYID_ARM_MIMIC.
; ==============================================================================
enemyCode64:
	jr z,@normalStatus	; $60fa
	sub ENEMYSTATUS_NO_HEALTH			; $60fc
	ret c			; $60fe
	jp z,enemyDie		; $60ff
	dec a			; $6102
	jp nz,_ecom_updateKnockback		; $6103
	ret			; $6106

@normalStatus:
	ld e,Enemy.state		; $6107
	ld a,(de)		; $6109
	rst_jumpTable			; $610a
	.dw @state_uninitialized
	.dw _armMimic_state_stub
	.dw _armMimic_state_stub
	.dw _armMimic_state_switchHook
	.dw _armMimic_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _armMimic_state_stub
	.dw _armMimic_state_stub
	.dw _linkMimic_state8


@state_uninitialized:
	ld a,PALH_82		; $611d
	call loadPaletteHeader		; $611f
	call _armMimic_uninitialized		; $6122
	jp objectSetVisible83		; $6125


_linkMimic_state8:
	ld a,(wDisabledObjects)		; $6128
	or a			; $612b
	ret nz			; $612c
	jr _armMimic_state8		; $612d
.endif


; ==============================================================================
; ENEMYID_ARM_MIMIC
;
; Shares code with ENEMYID_LINK_MIMIC.
;
; Variables:
;   var30: Animation index
; ==============================================================================
enemyCode4e:
	call _ecom_checkHazards		; $612f
	jr z,@normalStatus	; $6132
	sub ENEMYSTATUS_NO_HEALTH			; $6134
	ret c			; $6136
	jp z,enemyDie		; $6137
	dec a			; $613a
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $613b
	ret			; $613e

@normalStatus:
	ld e,Enemy.state		; $613f
	ld a,(de)		; $6141
	rst_jumpTable			; $6142
	.dw _armMimic_uninitialized
	.dw _armMimic_state_stub
	.dw _armMimic_state_stub
	.dw _armMimic_state_switchHook
	.dw _armMimic_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _armMimic_state_stub
	.dw _armMimic_state_stub
	.dw _armMimic_state8


_armMimic_uninitialized:
	ld e,Enemy.var30		; $6155
	ld a,(w1Link.direction)		; $6157
	add $02			; $615a
	and $03			; $615c
	ld (de),a		; $615e
	call enemySetAnimation		; $615f

	ld a,SPEED_100		; $6162
	jp _ecom_setSpeedAndState8AndVisible		; $6164


_armMimic_state_switchHook:
	inc e			; $6167
	ld a,(de)		; $6168
	rst_jumpTable			; $6169
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw _ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret			; $6172


_armMimic_state_stub:
	ret			; $6173


; Only "normal" state; simply moves in reverse of Link's direction.
_armMimic_state8:
	; Check that Link is moving
	ld a,(wLinkAngle)		; $6174
	inc a			; $6177
	ret z			; $6178

	add $0f			; $6179
	and $1f			; $617b
	ld e,Enemy.angle		; $617d
	ld (de),a		; $617f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6180

	ld h,d			; $6183
	ld l,Enemy.var30		; $6184
	ld a,(w1Link.direction)		; $6186
	add $02			; $6189
	and $03			; $618b
	cp (hl)			; $618d
	jr z,@animate	; $618e

	ld (hl),a		; $6190
	call enemySetAnimation		; $6191
@animate:
	jp enemyAnimate		; $6194


; ==============================================================================
; ENEMYID_MOLDORM
;
; Variables for head (subid 1):
;   var30: Tail 1 object index
;   var31: Tail 2 object index
;   var32: Animation index
;   var33: Angular speed (added to angle)
;
; Variables for tail (subids 2-3):
;   relatedObj1: Object to follow (either the head or the tail in front)
;   var30: Index for offset buffer
;   var31/var32: Parent object's position last frame
;   var33-var3b: Offset buffer. Stores the parent's movement offsets for up to 8 frames.
; ==============================================================================
enemyCode4f:
	call _moldorm_checkHazards		; $6197
	jr z,@normalStatus	; $619a
	sub ENEMYSTATUS_NO_HEALTH			; $619c
	ret c			; $619e
	jr z,@dead	; $619f
	dec a			; $61a1
	jr nz,@knockback	; $61a2

	; ENEMYSTATUS_JUST_HIT
	; Only apply this to the head (subid 1)
	ld e,Enemy.subid		; $61a4
	ld a,(de)		; $61a6
	dec a			; $61a7
	jr nz,@normalStatus	; $61a8

	; [tail1.invincibilityCounter] = [this.invincibilityCounter]
	ld e,Enemy.invincibilityCounter		; $61aa
	ld l,e			; $61ac
	ld a,(de)		; $61ad
	ld b,a			; $61ae
	ld e,Enemy.var30		; $61af
	ld a,(de)		; $61b1
	ld h,a			; $61b2
	ld (hl),b		; $61b3

	; [tail2.invincibilityCounter] = [this.invincibilityCounter]
	inc e			; $61b4
	ld a,(de)		; $61b5
	ld h,a			; $61b6
	ld (hl),b		; $61b7
	ret			; $61b8

@dead:
	ld e,Enemy.subid		; $61b9
	ld a,(de)		; $61bb
	dec a			; $61bc
	jp nz,_moldorm_tail_delete		; $61bd

	; Head only; kill the tails.
	ld e,Enemy.var30		; $61c0
	ld a,(de)		; $61c2
	ld h,a			; $61c3
	call _ecom_killObjectH		; $61c4
	inc e			; $61c7
	ld a,(de)		; $61c8
	ld h,a			; $61c9
	call _ecom_killObjectH		; $61ca
.ifdef ROM_SEASONS
	; moldorm guarding jewel
	ld a,(wActiveRoom)		; $61a2
	cp $f4			; $61a5
	jr nz,+			; $61a7
	ld a,(wActiveGroup)		; $61a9
	or a			; $61ac
	jr nz,+			; $61ad
	inc a			; $61af
	ld ($cfc0),a		; $61b0
+
.endif
	jp enemyDie		; $61cd

@knockback:
	ld e,Enemy.subid		; $61d0
	ld a,(de)		; $61d2
	dec a			; $61d3
	jr nz,@normalStatus	; $61d4
	jp _ecom_updateKnockbackAndCheckHazards		; $61d6

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $61d9
	jr nc,@normalState	; $61dc
	rst_jumpTable			; $61de
	.dw _moldorm_state_uninitialized
	.dw _moldorm_state1
	.dw _moldorm_state_stub
	.dw _moldorm_state_stub
	.dw _moldorm_state_stub
	.dw _moldorm_state_stub
	.dw _moldorm_state_stub
	.dw _moldorm_state_stub

@normalState:
	dec b			; $61ef
	ld a,b			; $61f0
	rst_jumpTable			; $61f1
	.dw _moldorm_head
	.dw _moldorm_tail
	.dw _moldorm_tail


_moldorm_state_uninitialized:
	ld a,b			; $61f8
	or a			; $61f9
	jr nz,@notSpawner		; $61fa

@spawner:
	inc a			; $61fc
	ld (de),a ; [state] = 1
	jr _moldorm_state1		; $61fe

@notSpawner:
	call _ecom_setSpeedAndState8AndVisible		; $6200
	ld a,b			; $6203
	dec a			; $6204
	ret z			; $6205
	add $07			; $6206
	jp enemySetAnimation		; $6208


; Spawner; spawn the head and tails, then delete self.
_moldorm_state1:
	ld b,$03		; $620b
	call checkBEnemySlotsAvailable		; $620d
	jp nz,objectSetVisible82		; $6210

	; Spawn head
	ld b,ENEMYID_MOLDORM		; $6213
	call _ecom_spawnUncountedEnemyWithSubid01		; $6215

	; Spawn tail 1
	ld c,h			; $6218
	push hl			; $6219
	call _ecom_spawnEnemyWithSubid01		; $621a
	inc (hl) ; [subid] = 2
	call _moldorm_tail_setRelatedObj1AndCopyPosition ; Follows head

	; Spawn tail 2
	ld c,h			; $6221
	call _ecom_spawnEnemyWithSubid01		; $6222
	inc (hl)		; $6225
	inc (hl) ; [subid] = 3
	call _moldorm_tail_setRelatedObj1AndCopyPosition ; Follows tail1

	; [head.var30] = tail1
	ld b,h			; $622a
	pop hl			; $622b
	ld l,Enemy.var30		; $622c
	ld (hl),c		; $622e

	; [head.var31] = tail2
	inc l			; $622f
	ld (hl),b		; $6230

	; [head.enabled] = [this.enabled] (copy spawned index value)
	ld l,Enemy.enabled		; $6231
	ld e,l			; $6233
	ld a,(de)		; $6234
	ld (hl),a		; $6235

	call objectCopyPosition		; $6236
	jp enemyDelete		; $6239


_moldorm_state_stub:
	ret			; $623c


; Subid 1
_moldorm_head:
	ld a,(de)		; $623d
	sub $08			; $623e
	rst_jumpTable			; $6240
	.dw @state8
	.dw @state9


; Initialization
@state8:
	ld h,d			; $6245
	ld l,e			; $6246
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $6248
	ld (hl),$08		; $624a

	ld l,Enemy.speed		; $624c
	ld (hl),SPEED_100		; $624e

	; Angular speed
	ld l,Enemy.var33		; $6250
	ld (hl),$02		; $6252

	call _ecom_setRandomAngle		; $6254
	jp _moldorm_head_updateAnimationFromAngle		; $6257


; Main state for head
@state9:
	call _ecom_decCounter1		; $625a
	jr nz,@applySpeed	; $625d

	ld (hl),$08 ; [counter1]

	; Angle is updated every 8 frames.
	ld l,Enemy.var33		; $6261
	ld e,Enemy.angle		; $6263
	ld a,(de)		; $6265
	add (hl)		; $6266
	and $1f			; $6267
	ld (de),a		; $6269
	call _moldorm_head_updateAnimationFromAngle		; $626a

	; 1 in 16 chance of inverting rotation every 8 frames
	call getRandomNumber_noPreserveVars		; $626d
	and $0f			; $6270
	jr nz,@applySpeed	; $6272
	ld e,Enemy.var33		; $6274
	ld a,(de)		; $6276
	cpl			; $6277
	inc a			; $6278
	ld (de),a		; $6279

@applySpeed:
	call _ecom_bounceOffWallsAndHoles		; $627a
	call nz,_moldorm_head_updateAnimationFromAngle		; $627d
	jp objectApplySpeed		; $6280


_moldorm_tail:
	ld e,Enemy.state		; $6283
	ld a,(de)		; $6285
	sub $08			; $6286
	rst_jumpTable			; $6288
	.dw @state8
	.dw @state9


; Initialization
@state8:
	ld h,d			; $628d
	ld l,e			; $628e
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $6290
	res 7,(hl)		; $6292

	; Copy parent's current position into var31/var32
	ld l,Enemy.relatedObj1+1		; $6294
	ld h,(hl)		; $6296
	ld l,Enemy.yh		; $6297
	ld e,Enemy.var31		; $6299
	ldi a,(hl)		; $629b
	ld (de),a		; $629c
	inc e			; $629d
	inc l			; $629e
	ld a,(hl)		; $629f
	ld (de),a		; $62a0

	jp _moldorm_tail_clearOffsetBuffer		; $62a1


; Main state for tail
@state9:
	; Check if parent deleted
	ld a,Object.enabled		; $62a4
	call objectGetRelatedObject1Var		; $62a6
	ld a,(hl)		; $62a9
	or a			; $62aa
	jr z,_moldorm_tail_delete	; $62ab

	; Get distance between parent's last and current Y position in high nibble of 'b'.
	; (Add 8 so it's positive.)
	ld l,Enemy.yh		; $62ad
	ld e,Enemy.var31		; $62af
	ld a,(de)		; $62b1
	ld b,a			; $62b2
	ldi a,(hl)		; $62b3
	sub b			; $62b4
	add $08			; $62b5
	swap a			; $62b7
	ld b,a			; $62b9

	; Get distance between parent's last and current X position in low nibble of 'b'.
	inc e			; $62ba
	inc l			; $62bb
	ld a,(de)		; $62bc
	ld c,a			; $62bd
	ld a,(hl)		; $62be
	sub c			; $62bf
	add $08			; $62c0
	or b			; $62c2
	ld b,a			; $62c3

	; Copy parent's Y/X to var31/var32
	ldd a,(hl)		; $62c4
	ld (de),a		; $62c5
	dec e			; $62c6
	dec l			; $62c7
	ld a,(hl)		; $62c8
	ld (de),a		; $62c9

	; Add the calculated position difference to the offset buffer starting at var33
	ld e,Enemy.var30		; $62ca
	ld a,(de)		; $62cc
	add Enemy.var33			; $62cd
	ld e,a			; $62cf
	ld a,b			; $62d0
	ld (de),a		; $62d1
	ld h,d			; $62d2
	ld l,Enemy.yh		; $62d3

	; Offset buffer index ++
	ld e,Enemy.var30		; $62d5
	ld a,(de)		; $62d7
	inc a			; $62d8
	and $07			; $62d9
	ld (de),a		; $62db

	; Read next byte in offset buffer (value from 8 frames ago) to get the value to
	; add to our current position.
	add Enemy.var33			; $62dc
	ld e,a			; $62de
	ld a,(de)		; $62df
	ld b,a			; $62e0
	and $f0			; $62e1
	swap a			; $62e3
	sub $08			; $62e5
	add (hl) ; [yh]
	ldi (hl),a		; $62e8
	inc l			; $62e9
	ld a,b			; $62ea
	and $0f			; $62eb
	sub $08			; $62ed
	add (hl) ; [xh]
	ld (hl),a		; $62f0
	ret			; $62f1

;;
; @addr{62f2}
_moldorm_tail_delete:
	call decNumEnemies		; $62f2
	jp enemyDelete		; $62f5


;;
; @param	h	Object to follow (either the head or the tail in front)
; @addr{62f8}
_moldorm_tail_setRelatedObj1AndCopyPosition:
	ld l,Enemy.relatedObj1		; $62f8
	ld a,Enemy.start		; $62fa
	ldi (hl),a		; $62fc
	ld (hl),c		; $62fd
	jp objectCopyPosition		; $62fe


;;
; @addr{6301}
_moldorm_head_updateAnimationFromAngle:
	ld e,Enemy.angle		; $6301
	ld a,(de)		; $6303
	add $02			; $6304
	and $1c			; $6306
	rrca			; $6308
	rrca			; $6309
	ld h,d			; $630a
	ld l,Enemy.var32		; $630b
	cp (hl)			; $630d
	ret z			; $630e
	ld (hl),a		; $630f
	jp enemySetAnimation		; $6310

;;
; @addr{6313}
_moldorm_tail_clearOffsetBuffer:
	ld h,d			; $6313
	ld l,Enemy.var33		; $6314
	ld b,$02		; $6316
	ld a,$88		; $6318
--
	ldi (hl),a		; $631a
	ldi (hl),a		; $631b
	ldi (hl),a		; $631c
	ldi (hl),a		; $631d
	dec b			; $631e
	jr nz,--		; $631f
	ret			; $6321


;;
; @addr{6322}
_moldorm_checkHazards:
	ld b,a			; $6322
	ld e,Enemy.subid		; $6323
	ld a,(de)		; $6325
	dec a			; $6326
	jr z,@checkHazards	; $6327

	; Tails only; check if parent fell into a hazard
	ld a,Object.var3f		; $6329
	call objectGetRelatedObject1Var		; $632b
	ld a,(hl)		; $632e
	and $07			; $632f
	jr nz,@checkHazards	; $6331
	ld a,b			; $6333
	or a			; $6334
	ret			; $6335

@checkHazards:
	ld a,b			; $6336
	jp _ecom_checkHazardsNoAnimationForHoles		; $6337


; ==============================================================================
; ENEMYID_FIREBALL_SHOOTER
; ==============================================================================
enemyCode50:
	dec a			; $633a
	ret z			; $633b
	dec a			; $633c
	ret z			; $633d
	ld e,Enemy.state		; $633e
	ld a,(de)		; $6340
	rst_jumpTable			; $6341
	.dw _fireballShooter_state_uninitialized
	.dw _fireballShooter_state1
	.dw _fireballShooter_state_stub
	.dw _fireballShooter_state_stub
	.dw _fireballShooter_state_stub
	.dw _fireballShooter_state_stub
	.dw _fireballShooter_state_stub
	.dw _fireballShooter_state_stub
	.dw _fireballShooter_state8
	.dw _fireballShooter_state9


_fireballShooter_state_uninitialized:
	ld h,d			; $6356
	ld l,e			; $6357
	inc (hl) ; [state]

	ld e,Enemy.subid		; $6359
	ld a,(de)		; $635b
	bit 7,a			; $635c
	ret z			; $635e
	ld (hl),$08 ; [state]
	ret			; $6361


; "Spawner"; spawns shooters at each appropriate tile index, then deletes self.
_fireballShooter_state1:
	xor a			; $6362
	ldh (<hFF8D),a	; $6363

	ld e,Enemy.yh		; $6365
	ld a,(de)		; $6367
	ld c,a ; c = tile index to spawn at

	ld hl,wRoomLayout		; $6369
	ld b,LARGE_ROOM_HEIGHT<<4		; $636c

@nextTile:
	ldi a,(hl)		; $636e
	cp c			; $636f
	jr nz,+++		; $6370

	push bc			; $6372
	push hl			; $6373
	ld c,l			; $6374
	dec c			; $6375
	ld b,ENEMYID_FIREBALL_SHOOTER		; $6376
	call _ecom_spawnUncountedEnemyWithSubid01		; $6378
	jr nz,@delete	; $637b

	; [child.subid] = [this.subid] | $80
	ld e,l			; $637d
	ld a,(de)		; $637e
	set 7,a			; $637f
	ldi (hl),a		; $6381

	; [child.var03] = ([hFF8D]+1)&3 (timing offset)
	ldh a,(<hFF8D)	; $6382
	inc a			; $6384
	and $03			; $6385
	ldh (<hFF8D),a	; $6387
	ld (hl),a		; $6389

	; Set child's position
	ld a,c			; $638a
	and $f0			; $638b
	add $06			; $638d
	ld l,Enemy.yh		; $638f
	ldi (hl),a		; $6391
	ld a,c			; $6392
	and $0f			; $6393
	swap a			; $6395
	add $08			; $6397
	inc l			; $6399
	ld (hl),a		; $639a

	pop hl			; $639b
	pop bc			; $639c
+++
	dec b			; $639d
	jr nz,@nextTile	; $639e

@delete:
	jp enemyDelete		; $63a0


_fireballShooter_state_stub:
	ret			; $63a3


; Initialization for "actual" shooter (not spawner)
_fireballShooter_state8:
	ld a,$09		; $63a4
	ld (de),a ; [state]

	ld e,Enemy.var03		; $63a7
	ld a,(de)		; $63a9
	ld hl,_fireballShooter_timingOffsets		; $63aa
	rst_addAToHl			; $63ad
	ld e,Enemy.counter1		; $63ae
	ld a,(hl)		; $63b0
	ld (de),a		; $63b1
	ret			; $63b2


; Main state for actual shooter
_fireballShooter_state9:
	call _fireballShooter_checkAllEnemiesKilled		; $63b3
	; BUG: This does NOT return if it's just deleted itself! This could cause counter1
	; to be dirty the next time an enemy is spawned in its former slot.

	; Wait for Link to be far enough away
	ld c,$24		; $63b6
	call objectCheckLinkWithinDistance		; $63b8
	ret c			; $63bb

	; Wait for cooldown
	call _ecom_decCounter1		; $63bc
	ret nz			; $63bf

	ld b,PARTID_GOPONGA_PROJECTILE		; $63c0
	call _ecom_spawnProjectile		; $63c2

	; Random cooldown between $c0-$c7
	call getRandomNumber_noPreserveVars		; $63c5
	and $07			; $63c8
	add $c0			; $63ca
	ld e,Enemy.counter1		; $63cc
	ld (de),a		; $63ce
	ret			; $63cf


_fireballShooter_timingOffsets:
	.db $4e $7e $ae $de


;;
; For subid $81 only, this deletes itself when all enemies are killed.
; @addr{63d4}
_fireballShooter_checkAllEnemiesKilled:
	ld e,Enemy.subid	; $63d4
	ld a,(de)		; $63d6
	cp $81			; $63d7
	ret nz			; $63d9
	ld a,(wNumEnemies)		; $63da
	or a			; $63dd
	ret nz			; $63de
	jp enemyDelete		; $63df


; ==============================================================================
; ENEMYID_BEETLE
;
; Variables for spawner (subid 0):
;   var30: Number of beetles spawned in? It's never actually used, and it doesn't seem to
;          update correctly, so this was probably for some abandoned idea.
;
; Variables for actual beetles (subid 1+):
;   relatedObj1: Reference to spawner object (optional)
; ==============================================================================
enemyCode51:
	call _beetle_checkHazards		; $63e2
	or a			; $63e5
	jr z,@normalStatus	; $63e6
	sub ENEMYSTATUS_NO_HEALTH			; $63e8
	ret c			; $63ea
	jr z,@dead	; $63eb
	dec a			; $63ed
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $63ee

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.subid		; $63f1
	ld a,(de)		; $63f3
	cp $02			; $63f4
	ret nz			; $63f6

	ld e,Enemy.var2a		; $63f7
	ld a,(de)		; $63f9
	cp $80|ITEMCOLLISION_LINK			; $63fa
	ret z			; $63fc

	ld h,d			; $63fd
	ld l,Enemy.state		; $63fe
	ld (hl),$0a		; $6400

	ld l,Enemy.counter1		; $6402
	ld (hl),$01		; $6404
	ret			; $6406

@dead:
	ld e,Enemy.subid		; $6407
	ld a,(de)		; $6409
	dec a			; $640a
	jr nz,++		; $640b

	; Subid 1 only (falling from sky): Update spawner's var30.
	; Since the spawner spawns subid 2, this is probably broken... (not that it
	; matters since the spawner doesn't check its var30 anyway)
	ld e,Enemy.relatedObj1+1		; $640d
	ld a,(de)		; $640f
	or a			; $6410
	jr z,++			; $6411
	ld a,Object.var30		; $6413
	call objectGetRelatedObject1Var		; $6415
	dec (hl)		; $6418
++
	jp enemyDie		; $6419

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $641c
	jr nc,@normalState	; $641f
	rst_jumpTable			; $6421
	.dw _beetle_state_uninitialized
	.dw _beetle_state_spawner
	.dw _beetle_state_stub
	.dw _beetle_state_switchHook
	.dw _beetle_state_stub
	.dw _beetle_state_galeSeed
	.dw _beetle_state_stub
	.dw _beetle_state_stub

@normalState:
	dec b			; $6432
	ld a,b			; $6433
	rst_jumpTable			; $6434
	.dw _beetle_subid1
	.dw _beetle_subid2
	.dw _beetle_subid3


_beetle_state_uninitialized:
	ld a,b			; $643b
	or a			; $643c
	ld a,SPEED_80		; $643d
	jp nz,_ecom_setSpeedAndState8		; $643f

	; Subid 0
	ld a,$01		; $6442
	ld (de),a ; [state]


_beetle_state_spawner:
	call _ecom_decCounter2		; $6445
	ret nz			; $6448

	; Only spawn beetles when Link is close
	ld c,$20		; $6449
	call objectCheckLinkWithinDistance		; $644b
	ret nc			; $644e

	ld e,Enemy.counter2		; $644f
	ld a,90		; $6451
	ld (de),a		; $6453

	ld b,ENEMYID_BEETLE		; $6454
	call _ecom_spawnEnemyWithSubid01		; $6456
	ret nz			; $6459
	inc (hl) ; [subid] = 2
	jp objectCopyPosition		; $645b


_beetle_state_galeSeed:
	call _ecom_galeSeedEffect		; $645e
	ret c			; $6461

	ld e,Enemy.relatedObj1+1		; $6462
	ld a,(de)		; $6464
	or a			; $6465
	jr z,++			; $6466

	ld h,a			; $6468
	ld l,Enemy.var30		; $6469
	dec (hl)		; $646b
++
	call decNumEnemies		; $646c
	jp enemyDelete		; $646f


_beetle_state_switchHook:
	inc e			; $6472
	ld a,(de)		; $6473
	rst_jumpTable			; $6474
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $647d

@substate3:
	ld b,$0a		; $647e
	jp _ecom_fallToGroundAndSetState		; $6480


_beetle_state_stub:
	ret			; $6483


; Falls from the sky
_beetle_subid1:
	ld a,(de)		; $6484
	sub $08			; $6485
	rst_jumpTable			; $6487
	.dw @state8
	.dw @state9
	.dw _beetle_stateA


; Initialization
@state8:
	ld h,d			; $648e
	ld l,e			; $648f
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $6491
	set 7,(hl)		; $6493

	ld c,$08		; $6495
	call _ecom_setZAboveScreen		; $6497

	call objectSetVisiblec1		; $649a

	ld a,SND_FALLINHOLE		; $649d
	jp playSound		; $649f


; Falling in from above the screen
@state9:
	ld c,$0e		; $64a2
	call objectUpdateSpeedZ_paramC		; $64a4
	ret nz			; $64a7

	; [speedZ] = 0
	ld l,Enemy.speedZ		; $64a8
	ldi (hl),a		; $64aa
	ld (hl),a		; $64ab

	ld l,Enemy.state		; $64ac
	inc (hl)		; $64ae

	call objectSetVisiblec2		; $64af

	ld a,SND_BOMB_LAND		; $64b2
	call playSound		; $64b4

	call _beetle_chooseRandomAngleAndCounter1		; $64b7
	jr _beetle_animate		; $64ba


; Common beetle state
_beetle_stateA:
	call _ecom_decCounter1		; $64bc
	call z,_beetle_chooseRandomAngleAndCounter1		; $64bf
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $64c2

_beetle_animate:
	jp enemyAnimate		; $64c5


; Spawns in instantly
_beetle_subid2:
	ld a,(de)		; $64c8
	sub $08			; $64c9
	rst_jumpTable			; $64cb
	.dw @state8
	.dw @state9
	.dw _beetle_stateA


; Initialization
@state8:
	ld h,d			; $64d2
	ld l,e			; $64d3
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $64d5
	ld (hl),30		; $64d7

	call _ecom_updateCardinalAngleTowardTarget		; $64d9
	jp objectSetVisiblec2		; $64dc


; Moving toward Link for 30 frames, before starting random movement
@state9:
	call _ecom_decCounter1		; $64df
	jr nz,@keepMovingTowardLink	; $64e2

	inc (hl) ; [counter1] = 1
	ld l,e			; $64e5
	inc (hl) ; [state]
	jr _beetle_stateA		; $64e7

@keepMovingTowardLink:
	ld a,(hl)		; $64e9
	cp 22			; $64ea
	jr nz,++		; $64ec
	ld l,Enemy.collisionType		; $64ee
	set 7,(hl)		; $64f0
++
	call _ecom_applyVelocityForSideviewEnemy		; $64f2
	jr _beetle_animate		; $64f5


; "Bounces in" when it spawns (dug up from the ground)
_beetle_subid3:
	ld a,(de)		; $64f7
	sub $08			; $64f8
	rst_jumpTable			; $64fa
	.dw @state8
	.dw @state9
	.dw _beetle_stateA


; Initialization
@state8:
	ld h,d			; $6501
	ld l,e			; $6502
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $6504
	ld a,<(-$102)		; $6506
	ldi (hl),a		; $6508
	ld (hl),>(-$102)		; $6509

	ld l,Enemy.speed		; $650b
	ld (hl),SPEED_c0		; $650d

	; Bounce in the direction Link is facing
	ld l,Enemy.angle		; $650f
	ld a,(w1Link.direction)		; $6511
	swap a			; $6514
	rrca			; $6516
	ld (hl),a		; $6517

	jp objectSetVisiblec2		; $6518


; Bouncing
@state9:
	ld c,$0e		; $651b
	call objectUpdateSpeedZAndBounce		; $651d
	jr c,@doneBouncing	; $6520

	ld a,SND_BOMB_LAND		; $6522
	call z,playSound		; $6524

	; Enable collisions when it starts moving back down
	ld e,Enemy.speedZ+1		; $6527
	ld a,(de)		; $6529
	or a			; $652a
	jr nz,++		; $652b
	ld h,d			; $652d
	ld l,Enemy.collisionType		; $652e
	set 7,(hl)		; $6530
++
	jp _ecom_applyVelocityForSideviewEnemyNoHoles		; $6532

@doneBouncing:
	call _ecom_incState		; $6535
	ld l,Enemy.speed		; $6538
	ld (hl),SPEED_80		; $653a


;;
; @addr{653c}
_beetle_chooseRandomAngleAndCounter1:
	ld bc,$071c		; $653c
	call _ecom_randomBitwiseAndBCE		; $653f
	ld e,Enemy.angle		; $6542
	ld a,c			; $6544
	ld (de),a		; $6545

	ld a,b			; $6546
	ld hl,@counter1Vals		; $6547
	rst_addAToHl			; $654a
	ld e,Enemy.counter1		; $654b
	ld a,(hl)		; $654d
	ld (de),a		; $654e
	ret			; $654f

@counter1Vals:
	.db 15 30 30 60 60 60 90 90

;;
; Beetle has custom checkHazards function so it can decrease the spawner's var30 (number
; of spawned
; @addr{6558}
_beetle_checkHazards:
	ld b,a			; $6558
	ld e,Enemy.state		; $6559
	ld a,(de)		; $655b
	cp $0a			; $655c
	ld a,b			; $655e
	ret c			; $655f

	; Check if currently sinking in lava? (water doesn't count?)
	ld h,d			; $6560
	ld l,Enemy.var3f		; $6561
	bit 1,(hl)		; $6563
	jr z,@checkHazards	; $6565

	; When [counter1] == 59, decrement spawner's var30 if it exists?
	ld l,Enemy.counter1		; $6567
	ld a,(hl)		; $6569
	cp 59			; $656a
	jr nz,@checkHazards	; $656c

	ld l,Enemy.relatedObj1+1		; $656e
	ld a,(hl)		; $6570
	or a			; $6571
	jr z,@checkHazards	; $6572

	ld h,a			; $6574
	ld l,Enemy.var30		; $6575
	dec (hl)		; $6577

@checkHazards:
	ld a,b			; $6578
	jp _ecom_checkHazards		; $6579


; ==============================================================================
; ENEMYID_FLYING_TILE
;
; Variables:
;   var30/var31: Pointer to current address in _flyingTile_layoutData
; ==============================================================================
enemyCode52:
	jr z,@normalStatus	; $657c
	sub ENEMYSTATUS_NO_HEALTH			; $657e
	ret c			; $6580
	jp _flyingTile_dead		; $6581

@normalStatus:
	ld e,Enemy.state		; $6584
	ld a,(de)		; $6586
	rst_jumpTable			; $6587
	.dw _flyingTile_state_uninitialized
	.dw _flyingTile_state_spawner
	.dw _flyingTile_state_stub
	.dw _flyingTile_state_stub
	.dw _flyingTile_state_stub
	.dw _flyingTile_state_stub
	.dw _flyingTile_state_stub
	.dw _flyingTile_state_stub
	.dw _flyingTile_state8
	.dw _flyingTile_state9
	.dw _flyingTile_stateA
	.dw _flyingTile_stateB


_flyingTile_state_uninitialized:
	ld e,Enemy.subid		; $65a0
	ld a,(de)		; $65a2
	rlca			; $65a3
	ld a,SPEED_1c0		; $65a4
	jp c,_ecom_setSpeedAndState8		; $65a6

	; Subids $00-$7f only
	ld e,Enemy.state		; $65a9
	ld a,$01		; $65ab
	ld (de),a		; $65ad
	ret			; $65ae


_flyingTile_state_spawner:
	inc e			; $65af
	ld a,(de) ; [state2]
	rst_jumpTable			; $65b1
	.dw @substate0
	.dw @substate1

@substate0:
	ld h,d			; $65b6
	ld l,e			; $65b7
	inc (hl) ; [state2]

	inc l			; $65b9
	ld (hl),120 ; [counter1]

	ld e,Enemy.subid		; $65bc
	ld a,(de)		; $65be
	ld hl,_flyingTile_layoutData		; $65bf
	rst_addDoubleIndex			; $65c2
	ldi a,(hl)		; $65c3
	ld h,(hl)		; $65c4
	ld l,a			; $65c5

	ld e,Enemy.var03		; $65c6
	ldi a,(hl)		; $65c8
	ld (de),a		; $65c9


;;
; @param	hl	Address to save to var30/var31
; @addr{65ca}
@flyingTile_saveTileDataAddress:
	ld e,Enemy.var30		; $65ca
	ld a,l			; $65cc
	ld (de),a		; $65cd
	inc e			; $65ce
	ld a,h			; $65cf
	ld (de),a		; $65d0
	ret			; $65d1

@substate1:
	call _ecom_decCounter1		; $65d2
	ret nz			; $65d5

	ld (hl),60		; $65d6

	; Retrieve address in _flyingTile_layoutData
	ld l,Enemy.var30		; $65d8
	ldi a,(hl)		; $65da
	ld h,(hl)		; $65db
	ld l,a			; $65dc

	; Get next position to spawn tile at
	ldi a,(hl)		; $65dd
	ld c,a			; $65de
	push hl			; $65df

	call @flyingTile_saveTileDataAddress		; $65e0
	ld b,ENEMYID_FLYING_TILE		; $65e3
	call _ecom_spawnEnemyWithSubid01		; $65e5
	jr nz,++		; $65e8

	; [child.subid] = [this.var03]
	ld l,Enemy.subid		; $65ea
	ld e,Enemy.var03		; $65ec
	ld a,(de)		; $65ee
	ld (hl),a		; $65ef

	ld l,Enemy.yh		; $65f0
	call setShortPosition_paramC		; $65f2
++
	pop hl			; $65f5
	ld a,(hl)		; $65f6
	or a			; $65f7
	ret nz			; $65f8

	; Spawned all tiles; delete the spawner.
	jp _flyingTile_delete		; $65f9


_flyingTile_state_stub:
	ret			; $65fc


; Initialization of actual flying tile (not spawner)
_flyingTile_state8:
	ld h,d			; $65fd
	ld l,e			; $65fe
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $6600
	set 7,(hl)		; $6602

	call _flyingTile_overwriteTileHere		; $6604
	jp objectSetVisiblec2		; $6607


; Moving up before charging at Link
_flyingTile_state9:
	ld h,d			; $660a
	ld l,Enemy.z		; $660b
	ld a,(hl)		; $660d
	sub <($0080)			; $660e
	ldi (hl),a		; $6610
	ld a,(hl)		; $6611
	sbc >($0080)			; $6612
	ld (hl),a		; $6614

	cp $fd			; $6615
	jr nc,_flyingTile_animate		; $6617

	; Moved high enoguh
	ld l,e			; $6619
	inc (hl) ; [state]
	ld l,Enemy.counter1		; $661b
	ld (hl),$0f		; $661d

_flyingTile_animate:
	jp enemyAnimate		; $661f


; Staying in place for [counter1] frames before charging Link
_flyingTile_stateA:
	call _ecom_decCounter1		; $6622
	jr nz,_flyingTile_animate	; $6625

	ld l,e			; $6627
	inc (hl) ; [state]

	call _ecom_updateAngleTowardTarget		; $6629
	jr _flyingTile_animate		; $662c


; Charging at Link
_flyingTile_stateB:
	call objectApplySpeed		; $662e
	call objectCheckTileCollision_allowHoles		; $6631
	jr nc,_flyingTile_animate	; $6634


;;
; @addr{6636}
_flyingTile_dead:
	ld b,INTERACID_ROCKDEBRIS		; $6636
	call objectCreateInteractionWithSubid00		; $6638

;;
; @addr{663b}
_flyingTile_delete:
	call decNumEnemies		; $663b
	jp enemyDelete		; $663e

;;
; Overwrites the tile at this position with whatever it should become after a flying tile
; is created there (depends on subid).
; @addr{6641}
_flyingTile_overwriteTileHere:
	call objectGetShortPosition		; $6641
	ld c,a			; $6644
	ld e,Enemy.subid		; $6645
	ld a,(de)		; $6647
	and $0f			; $6648
	ld hl,@tileReplacements		; $664a
	rst_addAToHl			; $664d
	ld a,(hl)		; $664e
	jp setTile		; $664f


@tileReplacements:
	.db $a0 $f3 $f4 $4c $a4


.ifdef ROM_AGES
_flyingTile_layoutData:
	.dw @subid0
	.dw @subid1
	.dw @subid2

; First byte is value for var03 (subid for spawned children).
; All remaining bytes are positions at which to spawn flying tiles.
; Ends when it reads $00.
@subid0:
	.db $80
	.db $57 $56 $46 $47 $48 $58 $68 $67
	.db $66 $65 $55 $45 $36 $37 $38 $49
	.db $59 $69 $78 $77 $76 $54 $5a
	.db $00

@subid1:
	.db $80
	.db $57 $46 $48 $39 $35 $26 $37 $59
	.db $49 $38 $29 $28 $36 $45 $56 $58
	.db $27 $47 $55 $25
	.db $00

@subid2:
	.db $80
	.db $67 $54 $5a $47 $34 $3a $76 $38
	.db $78 $36 $58 $45 $49 $56 $65 $69
	.db $00
.else
_flyingTile_layoutData:
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3

@subid0:
	.db $82
	.db $34 $66 $44 $56 $54 $46 $64 $36
	.db $35 $65 $45 $55
	.db $00
@subid1:
	.db $82
	.db $19 $59 $7c $79 $76 $73 $93
	.db $00
@subid2:
	.db $80
	.db $57 $46 $54 $66 $37 $77 $48 $68
	.db $5a $5b $27 $87 $45 $69 $65 $49
	.db $53 $36 $78 $38 $76 $44 $6a $64
	.db $4a $55 $59 $47 $67 $56 $58
	.db $00
@subid3:
	.db $80
	.db $36 $76 $38 $78 $44 $64 $4a $6a
	.db $26 $88 $75 $39 $35 $79 $43 $6b
	.db $63 $4b $37 $87 $77 $27 $53 $34
	.db $7a $74 $3a $28 $86 $5b
	.db $00
.endif


; ==============================================================================
; ENEMYID_DRAGONFLY
; ==============================================================================
enemyCode53:
	ld e,Enemy.state		; $669e
	ld a,(de)		; $66a0
	rst_jumpTable			; $66a1
	.dw _dragonfly_state0
	.dw _dragonfly_state1
	.dw _dragonfly_state2
	.dw _dragonfly_state3
	.dw _dragonfly_state4
	.dw _dragonfly_state5


; Initialization
_dragonfly_state0:
.ifdef ROM_SEASONS
	ld a,(wRoomStateModifier)		; $66ad
	cp SEASON_FALL			; $66b0
	jp nz,enemyDelete		; $66b2
.endif
	ld h,d			; $66ae
	ld l,e			; $66af
	inc (hl) ; [state]

	ld l,Enemy.subid		; $66b1
	ld a,(hl)		; $66b3
	ld l,Enemy.oamFlagsBackup		; $66b4
	ldi (hl),a		; $66b6
	ld (hl),a		; $66b7

	ld l,Enemy.zh		; $66b8
	ld (hl),-$08		; $66ba
	jp objectSetVisiblec1		; $66bc


; Choosing new direction to move in
_dragonfly_state1:
	ld h,d			; $66bf
	ld l,e			; $66c0
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $66c2
	ld (hl),$03		; $66c4

	ld l,Enemy.speed		; $66c6
	ld (hl),SPEED_200		; $66c8

	call getRandomNumber_noPreserveVars		; $66ca
	and $06			; $66cd
	ld c,a			; $66cf

	ld b,$00		; $66d0
	ld e,Enemy.yh		; $66d2
	ld a,(de)		; $66d4
	cp (SMALL_ROOM_HEIGHT/2)<<4			; $66d5
	jr c,+			; $66d7
	inc b			; $66d9
+
	ld e,Enemy.xh		; $66da
	ld a,(de)		; $66dc
	cp (SMALL_ROOM_WIDTH/2)<<4			; $66dd
	jr c,+			; $66df
	set 1,b			; $66e1
+
	ld a,b			; $66e3
	ld hl,@angleVals		; $66e4
	rst_addAToHl			; $66e7
	ld a,(hl)		; $66e8
	add c			; $66e9
	and $1f			; $66ea
	ld e,Enemy.angle		; $66ec
	ld (de),a		; $66ee

	; Update animation
	ld e,Enemy.angle		; $66ef
	ld a,(de)		; $66f1
	ld b,a			; $66f2
	and $0f			; $66f3
	ret z			; $66f5

	ld a,b			; $66f6
	cp $10			; $66f7
	ld a,$01		; $66f9
	jr c,+			; $66fb
	dec a			; $66fd
+
	jp enemySetAnimation		; $66fe

@angleVals:
	.db $08 $02 $12 $18


; Move in given direction for 3 frames at SPEED_200
_dragonfly_state2:
	call _dragonfly_applySpeed		; $6705
	jr nz,@nextState	; $6708

	call _ecom_decCounter1		; $670a
	jr nz,_dragonfly_animate	; $670d

@nextState:
	call _ecom_incState		; $670f
	ld l,Enemy.counter1		; $6712
	ld (hl),$0c		; $6714

_dragonfly_animate:
	jp enemyAnimate		; $6716


; Slowing down over 12 frames, eventually reaching SPEED_140
_dragonfly_state3:
	call _dragonfly_applySpeed		; $6719
	jr nz,@nextState	; $671c

	call _ecom_decCounter1		; $671e
	jr z,@nextState	; $6721

	ld a,(hl) ; [counter1]
	rrca			; $6724
	jr nc,_dragonfly_animate	; $6725

	ld l,Enemy.speed		; $6727
	ld a,(hl)		; $6729
	sub SPEED_20			; $672a
	ld (hl),a		; $672c
	jr _dragonfly_animate		; $672d

@nextState:
	ld e,Enemy.state		; $672f
	ld a,$04		; $6731
	ld (de),a		; $6733

	; Set counter1 somewhere in range $18-$1f
	call getRandomNumber_noPreserveVars		; $6734
	and $07			; $6737
	add $18			; $6739
	ld e,Enemy.counter1		; $673b
	ld (de),a		; $673d
	jr _dragonfly_animate		; $673e


; Moving at SPEED_140 for between 24-31 frames
_dragonfly_state4:
	call _dragonfly_applySpeed		; $6740
	jr nz,@nextState	; $6743

	call _ecom_decCounter1		; $6745
	jr nz,_dragonfly_animate	; $6748

@nextState:
	call getRandomNumber_noPreserveVars		; $674a
	and $7f			; $674d
	add $20			; $674f
	ld e,Enemy.counter1		; $6751
	ld (de),a		; $6753

	ld e,Enemy.state		; $6754
	ld a,$05		; $6756
	ld (de),a		; $6758
	jr _dragonfly_animate		; $6759


; Holding still for [counter1] frames
_dragonfly_state5:
	call _ecom_decCounter1		; $675b
	jr nz,_dragonfly_animate	; $675e

	ld l,e			; $6760
	ld (hl),$01 ; [state]
	jr _dragonfly_animate		; $6763


;;
; @param[out]	zflag	nz if touched a wall
; @addr{6765}
_dragonfly_applySpeed:
	ld a,$02 ; Only screen boundaries count as walls
	call _ecom_getSideviewAdjacentWallsBitset		; $6767
	ret nz			; $676a
	call objectApplySpeed		; $676b
	xor a			; $676e
	ret			; $676f


; ==============================================================================
; ENEMYID_BUSH_OR_ROCK
;
; Variables:
;   var30: Enemy ID of parent object
; ==============================================================================
enemyCode58:
	jr z,@normalStatus	; $6770
	sub ENEMYSTATUS_NO_HEALTH			; $6772
	ret c			; $6774
	jp z,@destroyed		; $6775

@normalStatus:
	ld e,Enemy.state		; $6778
	ld a,(de)		; $677a
	rst_jumpTable			; $677b
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_grabbed
	.dw @state_switchHook
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8


@state_uninitialized:
	; Initialize enemyCollisionMode and load tile to mimic
	ld e,Enemy.subid		; $678e
	ld a,(de)		; $6790
	ld hl,@collisionAndTileData		; $6791
	rst_addDoubleIndex			; $6794

	ld e,Enemy.enemyCollisionMode		; $6795
	ldi a,(hl)		; $6797
	ld (de),a		; $6798

	ld a,(hl)		; $6799
	call objectMimicBgTile		; $679a

	call @checkDisableDestruction		; $679d
	call _ecom_setSpeedAndState8		; $67a0
	call @copyParentPosition		; $67a3
	jr @setPriorityRelativeToLink		; $67a6


@collisionAndTileData:
.ifdef ROM_AGES
	.db ENEMYCOLLISION_BUSH, TILEINDEX_OVERWORLD_BUSH ; Subid 0
.else
	.db ENEMYCOLLISION_BUSH, $c4 ; Subid 0 TODO:
.endif
	.db ENEMYCOLLISION_BUSH, TILEINDEX_DUNGEON_BUSH   ; Subid 1
	.db ENEMYCOLLISION_ROCK,           TILEINDEX_DUNGEON_POT    ; Subid 2
	.db ENEMYCOLLISION_ROCK,           TILEINDEX_OVERWORLD_ROCK ; Subid 3



@state_grabbed:
	inc e			; $67b0
	ld a,(de)		; $67b1
	rst_jumpTable			; $67b2
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0: ; Just picked up
	ld h,d			; $67bb
	ld l,e			; $67bc
	inc (hl)		; $67bd

	ld l,Enemy.collisionType		; $67be
	res 7,(hl)		; $67c0

	xor a			; $67c2
	ld (wLinkGrabState2),a		; $67c3
	call @makeParentEnemyVisibleAndRemoveReference		; $67c6
	jp objectSetVisible81		; $67c9

@@substate1: ; Being held
	ret			; $67cc

@@substate2: ; Being thrown
	ld h,d			; $67cd

	; No longer persist between screens
	ld l,Enemy.enabled		; $67ce
	res 1,(hl)		; $67d0

	ld l,Enemy.zh		; $67d2
	bit 7,(hl)		; $67d4
	ret nz			; $67d6

@@substate3:
	call objectSetPriorityRelativeToLink		; $67d7
	jr @makeDebrisAndDelete		; $67da


@state_switchHook:
	inc e			; $67dc
	ld a,(de)		; $67dd
	rst_jumpTable			; $67de
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call @makeParentEnemyVisibleAndRemoveReference		; $67e7
	jp _ecom_incState2		; $67ea

@@substate1:
@@substate2:
	ret			; $67ed

@@substate3:
	ld c,$20		; $67ee
	call objectUpdateSpeedZ_paramC		; $67f0
	ret nz			; $67f3
	jr @makeDebrisAndDelete		; $67f4


@state_stub:
	ret			; $67f6


@state8:
	; Check if parent object's type has changed, if so, delete self?
	ld a,Object.id		; $67f7
	call objectGetRelatedObject1Var		; $67f9
	ld e,Enemy.var30		; $67fc
	ld a,(de)		; $67fe
	cp (hl)			; $67ff
	jp nz,enemyDelete		; $6800

	ld l,Enemy.var03		; $6803
	ld a,(hl)		; $6805
	rlca			; $6806
	call c,objectAddToGrabbableObjectBuffer		; $6807
	call @copyParentPosition		; $680a

@setPriorityRelativeToLink:
	jp objectSetPriorityRelativeToLink		; $680d


@destroyed:
	call @makeParentEnemyVisibleAndRemoveReference		; $6810

@makeDebrisAndDelete:
	ld e,Enemy.subid		; $6813
	ld a,(de)		; $6815
	ld hl,@debrisTypes		; $6816
	rst_addAToHl			; $6819
	ld b,(hl)		; $681a
	call objectCreateInteractionWithSubid00		; $681b
	jp enemyDelete		; $681e

; Debris for each subid (0-3)
@debrisTypes:
	.db INTERACID_GRASSDEBRIS
	.db INTERACID_GRASSDEBRIS
	.db INTERACID_ROCKDEBRIS
	.db INTERACID_ROCKDEBRIS

;;
; Make parent visible, remove self from Parent.relatedObj2
; @addr{6825}
@makeParentEnemyVisibleAndRemoveReference:
	ld a,Object.visible		; $6825
	call objectGetRelatedObject1Var		; $6827
	set 7,(hl)		; $682a
	ld l,Enemy.relatedObj2		; $682c
	xor a			; $682e
	ldi (hl),a		; $682f
	ld (hl),a		; $6830
	ret			; $6831

;;
; Copies parent position, with a Z offset determined by parent.var03.
; @addr{6832}
@copyParentPosition:
	ld a,Object.yh		; $6832
	call objectGetRelatedObject1Var		; $6834
	call objectTakePosition		; $6837

	ld l,Enemy.var03		; $683a
	ld a,(hl)		; $683c
	and $03			; $683d
	ld hl,@zVals		; $683f
	rst_addAToHl			; $6842
	ld e,Enemy.zh		; $6843
	ld a,(de)		; $6845
	add (hl)		; $6846
	ld (de),a		; $6847
	ret			; $6848

@zVals:
	.db $00 $fc $f8 $f4

;;
; Disable bush destruction for deku scrubs only.
; @addr{684d}
@checkDisableDestruction:
	ld a,Object.id		; $684d
	call objectGetRelatedObject1Var		; $684f
	ld e,Enemy.var30		; $6852
	ld a,(hl)		; $6854
	ld (de),a		; $6855

	; Don't allow destruction of bush for deku scrubs
	cp ENEMYID_DEKU_SCRUB			; $6856
	ret nz			; $6858
	ld e,Enemy.enemyCollisionMode		; $6859
	ld a,ENEMYCOLLISION_ROCK		; $685b
	ld (de),a		; $685d
	ret			; $685e


; ==============================================================================
; ENEMYID_ITEM_DROP_PRODUCER
;
; Variables:
;   var30: Tile at position (item drop will spawn when this changes)
; ==============================================================================
enemyCode59:
	ld e,Enemy.state		; $685f
	ld a,(de)		; $6861
	or a			; $6862
	jr nz,@state1		; $6863

@state0:
	; Initialization
	ld a,$01		; $6865
	ld (de),a ; [state]
	call objectGetTileAtPosition		; $6868
	ld e,Enemy.var30		; $686b
	ld (de),a		; $686d

@state1
	call objectGetTileAtPosition		; $686e
	ld h,d			; $6871
	ld l,Enemy.var30		; $6872
	cp (hl)			; $6874
	ret z			; $6875

	; Tile has changed.

	; Delete self if Link can't get the item drop yet (ie. doesn't have bombs)
	ld e,Enemy.subid		; $6876
	ld a,(de)		; $6878
	call checkItemDropAvailable		; $6879
	jp z,enemyDelete		; $687c

	call getFreePartSlot		; $687f
	ret nz			; $6882
	ld (hl),PARTID_ITEM_DROP		; $6883

	; [child.subid] = [this.subid]
	inc l			; $6885
	ld e,Enemy.subid		; $6886
	ld a,(de)		; $6888
	ld (hl),a		; $6889

	call objectCopyPosition		; $688a
	call markEnemyAsKilledInRoom		; $688d
	jp enemyDelete		; $6890


; ==============================================================================
; ENEMYID_SEEDS_ON_TREE
;
; Variables:
;   var03: Child "PARTID_SEED_ON_TREE" objects write here when Link touches them?
; ==============================================================================
enemyCode5a:
	ld e,Enemy.state	; $6893
	ld a,(de)		; $6895
	or a			; $6896
	jr nz,@state1	; $6897


; Initialization
@state0:
	ld a,$01		; $6899
	ld (de),a ; [state]

.ifdef ROM_AGES
	; Locate tree
	ld a,TILEINDEX_MYSTICAL_TREE_TL		; $689c
	call findTileInRoom		; $689e
	jp nz,interactionDelete ; BUG: Wrong function call! (see below)

	; Move to that position
	ld c,l			; $68a4
	ld h,d			; $68a5
	ld l,Enemy.yh		; $68a6
	call setShortPosition_paramC		; $68a8
	ld bc,$0808		; $68ab
	call objectCopyPositionWithOffset		; $68ae

	ld e,Enemy.subid	; $68b1
	ld a,(de)		; $68b3
	and $0f			; $68b4
	ld hl,wSeedTreeRefilledBitset		; $68b6
	call checkFlag		; $68b9
	jp z,interactionDelete		; $68bc

	; BUG: Above function call is wrong! Should be "enemyDelete"!
	; If a seed tree's seeds are exhausted, instead of deleting this object, it will
	; try to delete the interaction in the corresponding spot!
	; This is not be very noticeable, because often this will be in slot $d0, which
	; for interactions, is reserved for items from chests and stuff like that. But
	; that can be manipulated by digging up enemies from the ground...

	ld a,(de)		; $68bf
	swap a			; $68c0
	and $0f			; $68c2
	ldh (<hFF8B),a	; $68c4
.else
	ld e,Enemy.subid		; $68a3
	ld a,(de)		; $68a5
	ld b,a			; $68a6
	add a			; $68a7
	add b			; $68a8
	ld hl,@seasonsTable_0d_68fb		; $68a9
	rst_addAToHl			; $68ac
	ldi a,(hl)		; $68ad
	ldh (<hFF8B),a	; $68ae
	ldi a,(hl)		; $68b0
	ld b,a			; $68b1
	ld a,(wRoomStateModifier)		; $68b2
	cp b			; $68b5
	jp nz,enemyDelete		; $68b6
	ld a,(hl)		; $68b9
	cpl			; $68ba
	ld e,Enemy.direction		; $68bb
	ld (de),a		; $68bd
	ld a,(wSeedTreeRefilledBitset)		; $68be
	and (hl)		; $68c1
	jp z,enemyDelete		; $68c2
.endif

	; Spawn the 3 seed objects
	xor a			; $68c6
	call @addSeed		; $68c7
	ld a,$01		; $68ca
	call @addSeed		; $68cc
	ld a,$02		; $68cf
@addSeed:
	ld hl,@positionOffsets		; $68d1
	rst_addDoubleIndex			; $68d4
	ld e,Enemy.yh		; $68d5
	ld a,(de)		; $68d7
	add (hl)		; $68d8
	inc hl			; $68d9
	ld b,a			; $68da
	ld e,Enemy.xh		; $68db
	ld a,(de)		; $68dd
	add (hl)		; $68de
	ld c,a			; $68df

	call getFreePartSlot		; $68e0
	ld (hl),PARTID_SEED_ON_TREE		; $68e3
	inc l			; $68e5
	ldh a,(<hFF8B)	; $68e6
	ld (hl),a ; [subid]

	ld l,Part.yh		; $68e9
	ld (hl),b		; $68eb
	ld l,Part.xh		; $68ec
	ld (hl),c		; $68ee

	ld l,Part.relatedObj2	; $68ef
	ld (hl),Enemy.start	; $68f1
	inc l			; $68f3
	ld (hl),d		; $68f4
	ret			; $68f5

@positionOffsets:
	.db $f8 $00
	.db $00 $f8
	.db $00 $08

.ifdef ROM_SEASONS
@seasonsTable_0d_68fb:
	; <hFF8B - required season - checked against wSeedTreeRefilledBitset
	.db $00	SEASON_WINTER	$80
	.db $04	SEASON_SUMMER	$40
	.db $01	SEASON_SPRING	$20
	.db $02	SEASON_FALL	$10
	.db $03	SEASON_SUMMER	$08
	.db $03	SEASON_SUMMER	$04
.endif


@state1:
	; Waiting for one of the PARTID_SEED_ON_TREE objects to write to var03, indicating
	; that they were grabbed
	ld e,Enemy.var03
	ld a,(de)		; $68fe
	or a			; $68ff
	ret z			; $6900

	; Mark seeds as taken
.ifdef ROM_AGES
	ld e,Enemy.subid	; $6901
	ld a,(de)		; $6903
	and $0f			; $6904
	ld hl,wSeedTreeRefilledBitset		; $6906
	call unsetFlag		; $6909
.else
	ld e,Enemy.direction	; $6901
	ld a,(de)		; $6903
	ld hl,wSeedTreeRefilledBitset		; $6915
	and (hl)		; $6918
	ld (hl),a
.endif
	jp enemyDelete		; $690c


; ==============================================================================
; ENEMYID_TWINROVA_ICE
;
; Variables:
;   var3e: ?
; ==============================================================================
enemyCode5d:
	jr z,@normalStatus	; $690f
	sub ENEMYSTATUS_NO_HEALTH			; $6911
	ret c			; $6913

	; Hit something
	ld e,Enemy.var2a		; $6914
	ld a,(de)		; $6916
	cp $80|ITEMCOLLISION_LINK			; $6917
	jr z,@normalStatus	; $6919

	res 7,a			; $691b
	sub ITEMCOLLISION_L2_SHIELD			; $691d
	cp ITEMCOLLISION_L3_SHIELD-ITEMCOLLISION_L2_SHIELD + 1			; $691f
	call c,_twinrovaIce_bounceOffShield		; $6921
	call _ecom_updateCardinalAngleAwayFromTarget		; $6924

@normalStatus:
	ld e,Enemy.state		; $6927
	ld a,(de)		; $6929
	rst_jumpTable			; $692a
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6931
	ld l,e			; $6932
	inc (hl) ; [state]

	ld l,Enemy.speed		; $6934
	ld (hl),SPEED_1c0		; $6936

	ld l,Enemy.counter1		; $6938
	ld (hl),120		; $693a

	ld l,Enemy.var3e		; $693c
	ld (hl),$08		; $693e

	ld a,SND_POOF		; $6940
	call playSound		; $6942
	jp objectSetVisible82		; $6945


@state1:
	call _ecom_decCounter1		; $6948
	jp nz,enemyAnimate		; $694b

	ld l,e			; $694e
	inc (hl)		; $694f


@state2:
	; Check if parent is dead
	ld a,Object.health		; $6950
	call objectGetRelatedObject1Var		; $6952
	ld a,(hl)		; $6955
	or a			; $6956
	jr z,@delete	; $6957

	ld l,Enemy.state		; $6959
	ld a,(hl)		; $695b
	cp $0a			; $695c
	jr z,@delete	; $695e

	call objectApplySpeed		; $6960
	call _ecom_bounceOffWallsAndHoles		; $6963
	ret z			; $6966
	ld a,SND_CLINK		; $6967
	jp playSound		; $6969

@delete:
	call objectCreatePuff		; $696c
	jp enemyDelete		; $696f


;;
; This doesn't appear to do anything other than make a sound, because the angle is
; immediately overwritten after this is called?
; @addr{6972}
_twinrovaIce_bounceOffShield:
	ld a,(w1Link.direction)		; $6972
	swap a			; $6975
	ld b,a			; $6977
	ld e,Enemy.angle		; $6978
	ld a,(de)		; $697a
	add b			; $697b
	ld hl,@bounceTable		; $697c
	rst_addAToHl			; $697f
	ld e,Enemy.angle		; $6980
	ld a,(hl)		; $6982
	ld (de),a		; $6983
	ld a,SND_CLINK		; $6984
	jp playSound		; $6986

@bounceTable:
	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01

	.db $00 $1f $1e $1d $1c $1b $1a $19
	.db $18 $17 $16 $15 $14 $13 $12 $11

	.db $10 $0f $0e $0d $0c $0b $0a $09
	.db $08 $07 $06 $05 $04 $03 $02 $01


; ==============================================================================
; ENEMYID_TWINROVA_BAT
; ==============================================================================
enemyCode5e:
	jr z,+			; $69d9
	sub ENEMYSTATUS_NO_HEALTH			; $69db
	ret c			; $69dd
	jp z,enemyDie_uncounted		; $69de
+
	ld a,Object.id		; $69e1
	call objectGetRelatedObject1Var		; $69e3
	ld a,(hl)		; $69e6
	cp ENEMYID_MERGED_TWINROVA			; $69e7
	jp nz,enemyDelete		; $69e9

	ld e,Enemy.counter1		; $69ec
	ld a,(de)		; $69ee
	inc a			; $69ef
	and $1f			; $69f0
	ld a,SND_BOOMERANG		; $69f2
	call z,playSound		; $69f4

	ld e,Enemy.state		; $69f7
	ld a,(de)		; $69f9
	rst_jumpTable			; $69fa
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	ld h,d			; $6a01
	ld l,e			; $6a02
	inc (hl) ; [state]

	ld l,Enemy.speed		; $6a04
	ld (hl),SPEED_200		; $6a06

	ld l,Enemy.counter2		; $6a08
	ld (hl),$50		; $6a0a

	call getRandomNumber_noPreserveVars		; $6a0c
	ld e,Enemy.counter1		; $6a0f
	ld (de),a		; $6a11

	ld a,SND_VERAN_FAIRY_ATTACK		; $6a12
	call playSound		; $6a14
	jp objectSetVisible82		; $6a17


@state1:
	call @updateOamFlags		; $6a1a
	call _ecom_decCounter2		; $6a1d
	jr nz,@animate	; $6a20

	ld l,e			; $6a22
	inc (hl) ; [state]
	call _ecom_updateAngleTowardTarget		; $6a24


@state2:
	call @checkInBounds		; $6a27
	jp nc,enemyDelete		; $6a2a

	call @updateOamFlags		; $6a2d
	call objectApplySpeed		; $6a30
@animate:
	jp enemyAnimate		; $6a33


;;
; @param[out]	cflag	c if in bounds
; @addr{6a36}
@checkInBounds:
	ld e,Enemy.yh		; $6a36
	ld a,(de)		; $6a38
	cp LARGE_ROOM_HEIGHT<<4			; $6a39
	ret nc			; $6a3b
	ld e,Enemy.xh		; $6a3c
	ld a,(de)		; $6a3e
	cp LARGE_ROOM_WIDTH<<4			; $6a3f
	ret			; $6a41

;;
; @addr{6a42}
@updateOamFlags:
	call _ecom_decCounter1		; $6a42
	ld a,(hl)		; $6a45
	and $04			; $6a46
	rrca			; $6a48
	rrca			; $6a49
	add $02			; $6a4a
	ld l,Enemy.oamFlagsBackup		; $6a4c
	ldi (hl),a		; $6a4e
	ld (hl),a		; $6a4f
	ret			; $6a50


; ==============================================================================
; ENEMYID_GANON_REVIVAL_CUTSCENE
;
; Variables:
;   var30: Copied to counter2?
;   var31: Nonzero if initialization has occurred? (spawner only)
; ==============================================================================
enemyCode60:
	ld e,Enemy.subid		; $6a51
	ld a,(de)		; $6a53
	or a			; $6a54
	ld e,Enemy.var31		; $6a55
	jr z,_ganonRevivalCutscene_controller	; $6a57

	; This is an individual shadow in the cutscene.

	ld a,(de)		; $6a59
	or a			; $6a5a
	jr nz,_label_266	; $6a5b

	ld h,d			; $6a5d
	ld l,e			; $6a5e
	inc (hl) ; [state]

	ld l,Enemy.speed		; $6a60
	ld (hl),SPEED_200		; $6a62

	call objectSetVisible83		; $6a64

	ld a,SND_WIND		; $6a67
	call playSound		; $6a69

_label_266:
	ld bc,$5478		; $6a6c
	ld e,Enemy.yh		; $6a6f
	ld a,(de)		; $6a71
	ldh (<hFF8F),a	; $6a72
	ld e,Enemy.xh		; $6a74
	ld a,(de)		; $6a76
	ldh (<hFF8E),a	; $6a77
	sub c			; $6a79
	add $08			; $6a7a
	cp $11			; $6a7c
	jr nc,_label_267	; $6a7e

	ldh a,(<hFF8F)	; $6a80
	sub b			; $6a82
	add $08			; $6a83
	cp $11			; $6a85
	jp c,enemyDelete		; $6a87

_label_267:
	; Nudge toward target every 8 frames
	ld a,(wFrameCounter)		; $6a8a
	and $07			; $6a8d
	jr nz,++		; $6a8f
	call objectGetRelativeAngleWithTempVars		; $6a91
	call objectNudgeAngleTowards		; $6a94
++
	call objectApplySpeed		; $6a97
	jp _ecom_flickerVisibility		; $6a9a


_ganonRevivalCutscene_controller:
	ld a,(de) ; [var31]
	or a			; $6a9e
	jr nz,_label_270	; $6a9f

	; Just starting the cutscene

	ld a,(wPaletteThread_mode)		; $6aa1
	or a			; $6aa4
	ret nz			; $6aa5

	ld h,d			; $6aa6
	ld l,e			; $6aa7
	inc (hl) ; [var31] = 1

	ld l,Enemy.var30		; $6aa9
	ld (hl),$28		; $6aab

	call hideStatusBar		; $6aad

	ldh a,(<hActiveObject)	; $6ab0
	ld d,a			; $6ab2
	ld a,$0e		; $6ab3
	call fadeoutToBlackWithDelay		; $6ab5

	xor a			; $6ab8
	ld (wDirtyFadeSprPalettes),a		; $6ab9
	ld (wFadeSprPaletteSources),a		; $6abc

_label_270:
	call _ecom_decCounter2		; $6abf
	ret nz			; $6ac2

	; Check number of shadows spawned already
	dec l			; $6ac3
	ld a,(hl) ; [counter1]
	cp $10			; $6ac5
	inc (hl)		; $6ac7
	jr nc,@delete	; $6ac8

	call _ganonRevivalCutscene_spawnShadow		; $6aca

	ld e,Enemy.var30		; $6acd
	ld a,(de)		; $6acf
	ld e,Enemy.counter2		; $6ad0
	ld (de),a		; $6ad2

	ld e,Enemy.var30		; $6ad3
	ld a,(de)		; $6ad5
	sub $04			; $6ad6
	cp $10			; $6ad8
	ret c			; $6ada
	ld (de),a		; $6adb
	ret			; $6adc

@delete:
	; Signal parent to move to next phase of cutscene?
	ld a,Object.counter1		; $6add
	call objectGetRelatedObject1Var		; $6adf
	inc (hl)		; $6ae2
	jp enemyDelete		; $6ae3

;;
; @addr{6ae6}
_ganonRevivalCutscene_spawnShadow:
	call getFreeEnemySlot_uncounted		; $6ae6
	ret nz			; $6ae9

	ld (hl),ENEMYID_GANON_REVIVAL_CUTSCENE		; $6aea
	inc l			; $6aec
	inc (hl) ; [child.subid] = 1

	ld e,Enemy.counter1		; $6aee
	ld a,(de)		; $6af0
	and $07			; $6af1
	ld b,a			; $6af3
	add a			; $6af4
	add b			; $6af5
	ld bc,@shadowVariables		; $6af6
	call addAToBc		; $6af9

	ld l,Enemy.yh		; $6afc
	ld a,(bc)		; $6afe
	ldi (hl),a		; $6aff
	inc l			; $6b00
	inc bc			; $6b01
	ld a,(bc)		; $6b02
	ld (hl),a ; [xh]

	ld l,Enemy.angle		; $6b04
	inc bc			; $6b06
	ld a,(bc)		; $6b07
	ld (hl),a		; $6b08
	ret			; $6b09

; Byte 0: yh
; Byte 1: xh
; Byte 2: angle
@shadowVariables:
	.db $60 $f0 $19
	.db $b8 $d0 $00
	.db $90 $00 $02
	.db $40 $f0 $16
	.db $b8 $60 $1e
	.db $b8 $20 $05
	.db $90 $f0 $18
	.db $40 $00 $06

;;; split

seasonsTable_0d_6b30:
	.dw @index0
	.dw @index1
	.dw @index2
	.dw @index3
	.dw @index4
	.dw @index5
	.dw @index6
	.dw @index7
	.dw @index8
	.dw @index9
	.dw @indexA

@index0:
	.db $14 $00 $02 $38
	.db $05 $14 $04 $18
	.db $05 $14 $00 $48
	.db $6b

@index1:
	.db $3c $00 $02 $48
	.db $05 $14 $04 $18
	.db $05 $14 $00 $55
	.db $6b

@index2:
	.db $28 $00 $02 $48
	.db $05 $14 $04 $18
	.db $05 $14 $00 $62
	.db $6b

@index3:
	.db $14 $00 $02 $48
	.db $05 $14 $04 $18
	.db $05 $14 $00 $6f
	.db $6b

@index4:
	.db $14 $00 $02 $d8
	.db $05 $14 $04 $b8
	.db $05 $14 $00 $7c
	.db $6b

@index5:
	.db $78 $00 $02 $78
	.db $04 $38 $00 $89
	.db $6b

@index6:
	.db $73 $00 $02 $78
	.db $04 $38 $00 $92
	.db $6b

@index7:
	.db $6e $00 $02 $78
	.db $04 $38 $00 $9b
	.db $6b

@index8:
	.db $69 $00 $02 $78
	.db $04 $38 $00 $a4
	.db $6b

@index9:
	.db $64 $00 $02 $78
	.db $04 $38 $00 $ad
	.db $6b

@indexA:
	.db $5f $00 $02 $78
	.db $04 $38 $00 $b6
	.db $6b


; ==============================================================================
; ENEMYID_MAGUNESU
; ==============================================================================
enemyCode3c:
	jr z,_label_0d_283	; $6bbd
	sub $03			; $6bbf
	ret c			; $6bc1
	jp z,enemyDie		; $6bc2
	dec a			; $6bc5
	jp nz,_ecom_updateKnockback		; $6bc6
	ret			; $6bc9
_label_0d_283:
	call $6ccd		; $6bca
	call $6ce6		; $6bcd
	ld e,$84		; $6bd0
	ld a,(de)		; $6bd2
	rst_jumpTable			; $6bd3
	ld a,($ff00+c)		; $6bd4
	ld l,e			; $6bd5
.DB $fc				; $6bd6
	ld l,e			; $6bd7
.DB $fc				; $6bd8
	ld l,e			; $6bd9
.DB $fc				; $6bda
	ld l,e			; $6bdb
.DB $fc				; $6bdc
	ld l,e			; $6bdd
.DB $fc				; $6bde
	ld l,e			; $6bdf
.DB $fc				; $6be0
	ld l,e			; $6be1
.DB $fc				; $6be2
	ld l,e			; $6be3
.DB $fd				; $6be4
	ld l,e			; $6be5
	ld c,$6c		; $6be6
	jr z,$6c		; $6be8
	ld (hl),$6c		; $6bea
	ld b,a			; $6bec
	ld l,h			; $6bed
	ld h,b			; $6bee
	ld l,h			; $6bef
	ld l,(hl)		; $6bf0
	ld l,h			; $6bf1
	call $6d06		; $6bf2
	ld a,$14		; $6bf5
	call _ecom_setSpeedAndState8AndVisible		; $6bf7
	jr _label_0d_284		; $6bfa
	ret			; $6bfc
	call $6d18		; $6bfd
	call _ecom_decCounter1		; $6c00
	jp nz,_ecom_applyVelocityForTopDownEnemy		; $6c03
	ld l,$84		; $6c06
	inc (hl)		; $6c08
	ld a,$01		; $6c09
	jp enemySetAnimation		; $6c0b
	call enemyAnimate		; $6c0e
	ld e,$a1		; $6c11
	ld a,(de)		; $6c13
	or a			; $6c14
	ret z			; $6c15
	dec a			; $6c16
	ld a,$05		; $6c17
	jp nz,$6ca9		; $6c19
	ld h,d			; $6c1c
	ld l,$83		; $6c1d
	ld (hl),$02		; $6c1f
	ld l,$9b		; $6c21
	ld a,$02		; $6c23
	ldi (hl),a		; $6c25
	ld (hl),a		; $6c26
	ret			; $6c27
	call $6cb7		; $6c28
	ret nz			; $6c2b
	ld l,e			; $6c2c
	inc (hl)		; $6c2d
	call $6d06		; $6c2e
	ld a,$03		; $6c31
	jp enemySetAnimation		; $6c33
	call $6d18		; $6c36
	call _ecom_decCounter1		; $6c39
	jp nz,_ecom_applyVelocityForTopDownEnemy		; $6c3c
	ld l,$84		; $6c3f
	inc (hl)		; $6c41
	ld a,$04		; $6c42
	jp enemySetAnimation		; $6c44
	call enemyAnimate		; $6c47
	ld e,$a1		; $6c4a
	ld a,(de)		; $6c4c
	or a			; $6c4d
	ret z			; $6c4e
	dec a			; $6c4f
	ld a,$02		; $6c50
	jr nz,_label_0d_287	; $6c52
_label_0d_284:
	ld h,d			; $6c54
	ld l,$83		; $6c55
	ld (hl),$00		; $6c57
	ld l,$9b		; $6c59
	ld a,$01		; $6c5b
	ldi (hl),a		; $6c5d
	ld (hl),a		; $6c5e
	ret			; $6c5f
	call $6cb7		; $6c60
	ret nz			; $6c63
	ld l,e			; $6c64
	ld (hl),$08		; $6c65
	call $6d06		; $6c67
	xor a			; $6c6a
	jp enemySetAnimation		; $6c6b
	call _ecom_decCounter2		; $6c6e
	jr nz,_label_0d_285	; $6c71
	ld l,$90		; $6c73
	ld (hl),$14		; $6c75
	ld l,e			; $6c77
	ld e,$83		; $6c78
	ld a,(de)		; $6c7a
	or a			; $6c7b
	ld (hl),$08		; $6c7c
	ret z			; $6c7e
	ld (hl),$0b		; $6c7f
	ret			; $6c81
_label_0d_285:
	call _ecom_applyVelocityForTopDownEnemy		; $6c82
	ret nz			; $6c85
	call objectGetAngleTowardEnemyTarget		; $6c86
	xor $10			; $6c89
	ld h,d			; $6c8b
	ld l,$89		; $6c8c
	sub (hl)		; $6c8e
	and $1f			; $6c8f
	bit 4,a			; $6c91
	ld a,$08		; $6c93
	jr z,_label_0d_286	; $6c95
	ld a,$f8		; $6c97
_label_0d_286:
	add (hl)		; $6c99
	and $18			; $6c9a
	ld (hl),a		; $6c9c
	xor a			; $6c9d
	call _ecom_getTopDownAdjacentWallsBitset		; $6c9e
	ret z			; $6ca1
	ld e,$89		; $6ca2
	ld a,(de)		; $6ca4
	xor $10			; $6ca5
	ld (de),a		; $6ca7
	ret			; $6ca8
_label_0d_287:
	ld h,d			; $6ca9
	ld l,$84		; $6caa
	inc (hl)		; $6cac
	ld l,$86		; $6cad
	ld (hl),$1e		; $6caf
	call enemySetAnimation		; $6cb1
	jp _ecom_setRandomCardinalAngle		; $6cb4
	call _ecom_decCounter1		; $6cb7
	ret z			; $6cba
	ld a,(hl)		; $6cbb
	cp $0f			; $6cbc
	ret nz			; $6cbe
	call getFreePartSlot		; $6cbf
	ret nz			; $6cc2
	ld (hl),$31		; $6cc3
	ld bc,$0400		; $6cc5
	call objectCopyPositionWithOffset		; $6cc8
	or d			; $6ccb
	ret			; $6ccc
	ld a,(wFrameCounter)		; $6ccd
	and $38			; $6cd0
	swap a			; $6cd2
	rlca			; $6cd4
	ld hl,$6cde		; $6cd5
	rst_addAToHl			; $6cd8
	ld e,$8f		; $6cd9
	ld a,(hl)		; $6cdb
	ld (de),a		; $6cdc
	ret			; $6cdd
	cp $fd			; $6cde
.DB $fc				; $6ce0
	ei			; $6ce1
	ld a,($fcfb)		; $6ce2
.DB $fd				; $6ce5
	ld a,($cc79)		; $6ce6
	or a			; $6ce9
	ret z			; $6cea
	call $6cf3		; $6ceb
	ld b,$46		; $6cee
	jp _ecom_applyGivenVelocity		; $6cf0
	call objectGetAngleTowardEnemyTarget		; $6cf3
	ld c,a			; $6cf6
	ld h,d			; $6cf7
	ld l,$83		; $6cf8
	ld a,($cc79)		; $6cfa
	add (hl)		; $6cfd
	bit 1,a			; $6cfe
	ret nz			; $6d00
	ld a,c			; $6d01
	xor $10			; $6d02
	ld c,a			; $6d04
	ret			; $6d05
	call getRandomNumber_noPreserveVars		; $6d06
	and $03			; $6d09
	ld hl,$6d14		; $6d0b
	rst_addAToHl			; $6d0e
	ld e,$86		; $6d0f
	ld a,(hl)		; $6d11
	ld (de),a		; $6d12
	ret			; $6d13
	inc a			; $6d14
	ld a,b			; $6d15
	ld a,b			; $6d16
	or h			; $6d17
	ld c,$30		; $6d18
	call objectCheckLinkWithinDistance		; $6d1a
	ret nc			; $6d1d
	pop hl			; $6d1e
	ld h,d			; $6d1f
	ld l,$84		; $6d20
	ld (hl),$0e		; $6d22
	ld l,$87		; $6d24
	ld (hl),$2d		; $6d26
	ld l,$90		; $6d28
	ld (hl),$3c		; $6d2a
	call objectGetAngleTowardEnemyTarget		; $6d2c
	sub $0c			; $6d2f
	and $18			; $6d31
	ld e,$89		; $6d33
	ld (de),a		; $6d35
	ret			; $6d36
	ret			; $6d37
	jr z,_label_0d_288	; $6d38
	sub $03			; $6d3a
	ret c			; $6d3c
	jp z,enemyDie		; $6d3d
	dec a			; $6d40
	jp nz,_ecom_updateKnockbackNoSolidity		; $6d41
	ret			; $6d44
_label_0d_288:
	ld e,$84		; $6d45
	ld a,(de)		; $6d47
	rst_jumpTable			; $6d48
	ld e,e			; $6d49
	ld l,l			; $6d4a
	ld e,(hl)		; $6d4b
	ld l,l			; $6d4c
	ld e,(hl)		; $6d4d
	ld l,l			; $6d4e
	ld e,(hl)		; $6d4f
	ld l,l			; $6d50
	ld e,(hl)		; $6d51
	ld l,l			; $6d52
	ld e,(hl)		; $6d53
	ld l,l			; $6d54
	ld e,(hl)		; $6d55
	ld l,l			; $6d56
	ld e,(hl)		; $6d57
	ld l,l			; $6d58
	ld e,a			; $6d59
	ld l,l			; $6d5a
	jp _ecom_setSpeedAndState8AndVisible		; $6d5b
	ret			; $6d5e
	jp enemyAnimate		; $6d5f
	call _ecom_checkHazards		; $6d62
	jr z,_label_0d_289	; $6d65
	sub $03			; $6d67
	ret c			; $6d69
	jp z,enemyDie		; $6d6a
	dec a			; $6d6d
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6d6e
	ret			; $6d71
_label_0d_289:
	ld e,$84		; $6d72
	ld a,(de)		; $6d74
	rst_jumpTable			; $6d75
	add (hl)		; $6d76
	ld l,l			; $6d77
	adc c			; $6d78
	ld l,l			; $6d79
	adc c			; $6d7a
	ld l,l			; $6d7b
	adc c			; $6d7c
	ld l,l			; $6d7d
	adc c			; $6d7e
	ld l,l			; $6d7f
	adc c			; $6d80
	ld l,l			; $6d81
	adc c			; $6d82
	ld l,l			; $6d83
	adc c			; $6d84
	ld l,l			; $6d85
	jp enemyDelete		; $6d86
	ret			; $6d89

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode46:
	jr z,_label_0d_291	; $6d8a
	sub $03			; $6d8c
	ret c			; $6d8e
	jr nz,_label_0d_290	; $6d8f
	ld a,$32		; $6d91
	call objectGetRelatedObject1Var		; $6d93
	dec (hl)		; $6d96
	ld e,$82		; $6d97
	ld a,(de)		; $6d99
	dec a			; $6d9a
	jp nz,enemyDie_uncounted		; $6d9b
	jp enemyDie_uncounted_withoutItemDrop		; $6d9e
_label_0d_290:
	ld e,$82		; $6da1
	ld a,(de)		; $6da3
	cp $02			; $6da4
	jr nz,_label_0d_291	; $6da6
	ld e,$aa		; $6da8
	ld a,(de)		; $6daa
	cp $80			; $6dab
	jr nz,_label_0d_291	; $6dad
	ld e,$84		; $6daf
	ld a,$0d		; $6db1
	ld (de),a		; $6db3
_label_0d_291:
	call _ecom_getSubidAndCpStateTo08		; $6db4
	cp $0a			; $6db7
	jr nc,$15		; $6db9
	rst_jumpTable			; $6dbb
	jp c,$f86d		; $6dbc
	ld l,l			; $6dbf
	ld hl,sp+$6d		; $6dc0
	ld hl,sp+$6d		; $6dc2
	ld hl,sp+$6d		; $6dc4
.DB $eb				; $6dc6
	ld l,l			; $6dc7
	ld hl,sp+$6d		; $6dc8
	ld hl,sp+$6d		; $6dca
	ld sp,hl		; $6dcc
	ld l,l			; $6dcd
	ld ($786e),sp		; $6dce
	rst_jumpTable			; $6dd1
	inc d			; $6dd2
	ld l,(hl)		; $6dd3
	ld l,d			; $6dd4
	ld l,(hl)		; $6dd5
	rst_addAToHl			; $6dd6
	ld l,(hl)		; $6dd7
	ld b,(hl)		; $6dd8
	ld l,a			; $6dd9
	call _ecom_setSpeedAndState8		; $6dda
	ld l,$82		; $6ddd
	ld a,(hl)		; $6ddf
	cp $02			; $6de0
	jr nz,_label_0d_292	; $6de2
	ld l,$a5		; $6de4
	ld (hl),$31		; $6de6
_label_0d_292:
	jp objectSetVisiblec1		; $6de8
	call _ecom_galeSeedEffect		; $6deb
	ret c			; $6dee
	ld a,$32		; $6def
	call objectGetRelatedObject1Var		; $6df1
	dec (hl)		; $6df4
	jp enemyDelete		; $6df5
	ret			; $6df8
	ld bc,$ff00		; $6df9
	call objectSetSpeedZ		; $6dfc
	ld l,e			; $6dff
	inc (hl)		; $6e00
	ld l,$90		; $6e01
	ld (hl),$1e		; $6e03
	call _ecom_setRandomAngle		; $6e05
	ld c,$0e		; $6e08
	call objectUpdateSpeedZ_paramC		; $6e0a
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $6e0d
	ld l,$84		; $6e10
	inc (hl)		; $6e12
	ret			; $6e13
	ld a,(de)		; $6e14
	sub $0a			; $6e15
	rst_jumpTable			; $6e17
	ld e,$6e		; $6e18
	dec h			; $6e1a
	ld l,(hl)		; $6e1b
	ld d,d			; $6e1c
	ld l,(hl)		; $6e1d
	ld h,d			; $6e1e
	ld l,$90		; $6e1f
	ld (hl),$28		; $6e21
	jr _label_0d_294		; $6e23
	call enemyAnimate		; $6e25
	ld c,$0c		; $6e28
	call objectUpdateSpeedZ_paramC		; $6e2a
	jr z,_label_0d_293	; $6e2d
	call _ecom_bounceOffWallsAndHoles		; $6e2f
	jp objectApplySpeed		; $6e32
_label_0d_293:
	call getRandomNumber_noPreserveVars		; $6e35
	and $07			; $6e38
	ld hl,$6e4a		; $6e3a
	rst_addAToHl			; $6e3d
	ld e,$86		; $6e3e
	ld a,(hl)		; $6e40
	ld (de),a		; $6e41
	ld e,$84		; $6e42
	ld a,$0c		; $6e44
	ld (de),a		; $6e46
	jp objectSetVisible82		; $6e47
	ld bc,$0101		; $6e4a
	jr nc,$30		; $6e4d
	jr nc,$30		; $6e4f
	jr nc,-$33		; $6e51
	ld e,a			; $6e53
	daa			; $6e54
	call _ecom_decCounter1		; $6e55
	ret nz			; $6e58
	call objectSetVisiblec1		; $6e59
_label_0d_294:
	ld l,$84		; $6e5c
	ld (hl),$0b		; $6e5e
	ld l,$94		; $6e60
	ld a,$80		; $6e62
	ldi (hl),a		; $6e64
	ld (hl),$fe		; $6e65
	jp _ecom_updateAngleTowardTarget		; $6e67
	ld a,(de)		; $6e6a
	sub $0a			; $6e6b
	rst_jumpTable			; $6e6d
	halt			; $6e6e
	ld l,(hl)		; $6e6f
	adc h			; $6e70
	ld l,(hl)		; $6e71
	sub (hl)		; $6e72
	ld l,(hl)		; $6e73
	cp a			; $6e74
	ld l,(hl)		; $6e75
	ld h,d			; $6e76
	ld l,e			; $6e77
	inc (hl)		; $6e78
	ld l,$90		; $6e79
	ld (hl),$1e		; $6e7b
	call getRandomNumber_noPreserveVars		; $6e7d
	and $1f			; $6e80
	ld e,$89		; $6e82
	ld (de),a		; $6e84
	ld e,$86		; $6e85
	ld a,$3c		; $6e87
	ld (de),a		; $6e89
	jr _label_0d_298		; $6e8a
	call _ecom_decCounter1		; $6e8c
	jr z,_label_0d_297	; $6e8f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6e91
	jr _label_0d_298		; $6e94
	ld h,d			; $6e96
	ld l,$b0		; $6e97
	call _ecom_readPositionVars		; $6e99
	cp c			; $6e9c
	jr nz,_label_0d_295	; $6e9d
	ldh a,(<hFF8F)	; $6e9f
	cp b			; $6ea1
	jr nz,_label_0d_295	; $6ea2
	ld l,e			; $6ea4
	inc (hl)		; $6ea5
	call $6f87		; $6ea6
	jr _label_0d_298		; $6ea9
_label_0d_295:
	call objectGetRelativeAngleWithTempVars		; $6eab
	ld e,$89		; $6eae
	ld (de),a		; $6eb0
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6eb1
	jr z,_label_0d_296	; $6eb4
	jr _label_0d_298		; $6eb6
_label_0d_296:
	call _ecom_decCounter1		; $6eb8
	jr nz,_label_0d_298	; $6ebb
	jr _label_0d_297		; $6ebd
	call _ecom_decCounter1		; $6ebf
	jr nz,_label_0d_298	; $6ec2
_label_0d_297:
	ld l,$84		; $6ec4
	ld (hl),$0c		; $6ec6
	ld l,$86		; $6ec8
	ld (hl),$08		; $6eca
	ld l,$b0		; $6ecc
	ldh a,(<hEnemyTargetY)	; $6ece
	ldi (hl),a		; $6ed0
	ldh a,(<hEnemyTargetX)	; $6ed1
	ld (hl),a		; $6ed3
_label_0d_298:
	jp enemyAnimate		; $6ed4
	ld a,(de)		; $6ed7
	sub $0a			; $6ed8
	rst_jumpTable			; $6eda
	ld e,$6e		; $6edb
	dec h			; $6edd
	ld l,(hl)		; $6ede
	ld d,d			; $6edf
	ld l,(hl)		; $6ee0
	push hl			; $6ee1
	ld l,(hl)		; $6ee2
	inc sp			; $6ee3
	ld l,a			; $6ee4
	ld a,($d00b)		; $6ee5
	ld e,$8b		; $6ee8
	ld (de),a		; $6eea
	ld a,($d00d)		; $6eeb
	ld e,$8d		; $6eee
	ld (de),a		; $6ef0
	call _ecom_decCounter1		; $6ef1
	jr z,_label_0d_300	; $6ef4
	ld a,($cc46)		; $6ef6
	or a			; $6ef9
	jr z,_label_0d_299	; $6efa
	dec (hl)		; $6efc
	jr z,_label_0d_300	; $6efd
	dec (hl)		; $6eff
	jr z,_label_0d_300	; $6f00
_label_0d_299:
	ld a,(wFrameCounter)		; $6f02
	rrca			; $6f05
	jr nc,_label_0d_301	; $6f06
	ld hl,wLinkImmobilized		; $6f08
	set 5,(hl)		; $6f0b
	jr _label_0d_301		; $6f0d
_label_0d_300:
	call $6f25		; $6f0f
	ld bc,$ff20		; $6f12
	call objectSetSpeedZ		; $6f15
	ld l,$84		; $6f18
	inc (hl)		; $6f1a
	ld a,$8f		; $6f1b
	call playSound		; $6f1d
	call objectSetVisiblec1		; $6f20
	jr _label_0d_301		; $6f23
	ld a,($d009)		; $6f25
	bit 7,a			; $6f28
	jp nz,_ecom_setRandomAngle		; $6f2a
	xor $10			; $6f2d
	ld e,$89		; $6f2f
	ld (de),a		; $6f31
	ret			; $6f32
	ld c,$0e		; $6f33
	call objectUpdateSpeedZ_paramC		; $6f35
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $6f38
	ld l,$84		; $6f3b
	ld (hl),$0b		; $6f3d
	ld l,$a4		; $6f3f
	set 7,(hl)		; $6f41
_label_0d_301:
	jp enemyAnimate		; $6f43
	ld a,(de)		; $6f46
	sub $0a			; $6f47
	rst_jumpTable			; $6f49
	ld d,b			; $6f4a
	ld l,a			; $6f4b
	ld d,a			; $6f4c
	ld l,a			; $6f4d
	ld (hl),l		; $6f4e
	ld l,a			; $6f4f
	ld h,d			; $6f50
	ld l,e			; $6f51
	inc (hl)		; $6f52
	ld l,$90		; $6f53
	ld (hl),$1e		; $6f55
	ld h,d			; $6f57
	ld l,e			; $6f58
	inc (hl)		; $6f59
	ld l,$86		; $6f5a
	ld (hl),$5a		; $6f5c
	call _ecom_updateAngleTowardTarget		; $6f5e
	call getRandomNumber_noPreserveVars		; $6f61
	and $01			; $6f64
	ld hl,$6f73		; $6f66
	rst_addAToHl			; $6f69
	ld e,$89		; $6f6a
	ld a,(de)		; $6f6c
	add (hl)		; $6f6d
	and $1f			; $6f6e
	ld (de),a		; $6f70
	jr _label_0d_303		; $6f71
	inc b			; $6f73
.DB $fc				; $6f74
	call _ecom_decCounter1		; $6f75
	jr nz,_label_0d_302	; $6f78
	ld l,e			; $6f7a
	dec (hl)		; $6f7b
	jr _label_0d_303		; $6f7c
_label_0d_302:
	call _ecom_bounceOffWallsAndHoles		; $6f7e
	call objectApplySpeed		; $6f81
_label_0d_303:
	jp enemyAnimate		; $6f84
	call getRandomNumber_noPreserveVars		; $6f87
	and $0f			; $6f8a
	ld hl,$6f95		; $6f8c
	rst_addAToHl			; $6f8f
	ld e,$86		; $6f90
	ld a,(hl)		; $6f92
	ld (de),a		; $6f93
	ret			; $6f94
	ld bc,$1401		; $6f95
	inc d			; $6f98
	inc d			; $6f99
	inc d			; $6f9a
	inc d			; $6f9b
	inc a			; $6f9c
	inc a			; $6f9d
	inc a			; $6f9e
	inc a			; $6f9f
	inc a			; $6fa0
	inc a			; $6fa1
	ld e,d			; $6fa2
	ld e,d			; $6fa3
	ld e,d			; $6fa4

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode47:
	jr z,_label_0d_304	; $6fa5
	sub $03			; $6fa7
	ret c			; $6fa9
	jp z,enemyDie_uncounted		; $6faa
	dec a			; $6fad
	jp nz,_ecom_updateKnockbackNoSolidity		; $6fae
	ret			; $6fb1
_label_0d_304:
	call _ecom_getSubidAndCpStateTo08		; $6fb2
	jr nc,_label_0d_305	; $6fb5
	rst_jumpTable			; $6fb7
	jp nc,$dc6f		; $6fb8
	ld l,a			; $6fbb
	jr z,$70		; $6fbc
	jr z,_label_0d_308	; $6fbe
	jr z,_label_0d_309	; $6fc0
	ld hl,$2870		; $6fc2
	ld (hl),b		; $6fc5
	jr z,_label_0d_310	; $6fc6
_label_0d_305:
	ld a,b			; $6fc8
	rst_jumpTable			; $6fc9
	add hl,hl		; $6fca
	ld (hl),b		; $6fcb
	ld h,e			; $6fcc
	ld (hl),b		; $6fcd
	ld l,d			; $6fce
	ld (hl),b		; $6fcf
	ld (hl),c		; $6fd0
	ld (hl),b		; $6fd1
	bit 7,b			; $6fd2
	ld a,$46		; $6fd4
	jp z,_ecom_setSpeedAndState8AndVisible		; $6fd6
	ld a,$01		; $6fd9
	ld (de),a		; $6fdb
	bit 0,b			; $6fdc
	ld bc,$0400		; $6fde
	jr z,_label_0d_306	; $6fe1
	ld bc,$0604		; $6fe3
_label_0d_306:
	push bc			; $6fe6
	call checkBEnemySlotsAvailable		; $6fe7
	pop bc			; $6fea
	ret nz			; $6feb
	ld a,b			; $6fec
	ldh (<hFF8B),a	; $6fed
	ld a,c			; $6fef
	ld bc,$7017		; $6ff0
	call addAToBc		; $6ff3
_label_0d_307:
	push bc			; $6ff6
	ld b,$47		; $6ff7
	call _ecom_spawnUncountedEnemyWithSubid01		; $6ff9
	dec (hl)		; $6ffc
	call objectCopyPosition		; $6ffd
	dec l			; $7000
	ld a,(hl)		; $7001
	ld (hl),$00		; $7002
	ld l,$8b		; $7004
	add (hl)		; $7006
	ld (hl),a		; $7007
	pop bc			; $7008
	ld l,$89		; $7009
	ld a,(bc)		; $700b
	ld (hl),a		; $700c
	inc bc			; $700d
	ld hl,$ff8b		; $700e
	dec (hl)		; $7011
	jr nz,_label_0d_307	; $7012
	jp enemyDelete		; $7014
	inc b			; $7017
	inc c			; $7018
	inc d			; $7019
	inc e			; $701a
	nop			; $701b
	dec b			; $701c
	dec bc			; $701d
	stop			; $701e
	dec d			; $701f
	dec de			; $7020
	call _ecom_galeSeedEffect		; $7021
	ret c			; $7024
	jp enemyDelete		; $7025
	ret			; $7028
	ld a,(de)		; $7029
	sub $08			; $702a
	rst_jumpTable			; $702c
	ld sp,$4570		; $702d
_label_0d_308:
	ld (hl),b		; $7030
	ld h,d			; $7031
_label_0d_309:
	ld l,e			; $7032
	inc (hl)		; $7033
	ld l,$a4		; $7034
	set 7,(hl)		; $7036
_label_0d_310:
	ld l,$86		; $7038
	ld (hl),$04		; $703a
	inc l			; $703c
	ld (hl),$3c		; $703d
	call $7089		; $703f
	jp objectSetVisible82		; $7042
	call _ecom_decCounter2		; $7045
	jr z,_label_0d_311	; $7048
	call _ecom_decCounter1		; $704a
	jr nz,_label_0d_311	; $704d
	ld (hl),$04		; $704f
	call objectGetAngleTowardEnemyTarget		; $7051
	call objectNudgeAngleTowards		; $7054
	call $7089		; $7057
_label_0d_311:
	call objectApplySpeed		; $705a
	call $7078		; $705d
	jp enemyAnimate		; $7060
	ld a,(de)		; $7063
	sub $08			; $7064
	rst_jumpTable			; $7066
	ld l,c			; $7067
	ld (hl),b		; $7068
	ret			; $7069
	ld a,(de)		; $706a
	sub $08			; $706b
	rst_jumpTable			; $706d
	ld (hl),b		; $706e
	ld (hl),b		; $706f
	ret			; $7070
	ld a,(de)		; $7071
	sub $08			; $7072
	rst_jumpTable			; $7074
	ld (hl),a		; $7075
	ld (hl),b		; $7076
	ret			; $7077
	ld e,$8b		; $7078
	ld a,(de)		; $707a
	cp $b8			; $707b
	jr nc,_label_0d_312	; $707d
	ld e,$8d		; $707f
	ld a,(de)		; $7081
	cp $f8			; $7082
	ret c			; $7084
_label_0d_312:
	pop hl			; $7085
	jp enemyDelete		; $7086
	ld h,d			; $7089
	ld l,$89		; $708a
	ldd a,(hl)		; $708c
	add $02			; $708d
	and $1c			; $708f
	rrca			; $7091
	rrca			; $7092
	cp (hl)			; $7093
	ret z			; $7094
	ld (hl),a		; $7095
	jp enemySetAnimation		; $7096

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode54:
	jr z,_label_0d_313	; $7099
	sub $03			; $709b
	ret c			; $709d
	jp z,enemyDelete		; $709e
	dec a			; $70a1
	jp nz,_ecom_updateKnockback		; $70a2
	ld e,$aa		; $70a5
	ld a,(de)		; $70a7
	res 7,a			; $70a8
	sub $0a			; $70aa
	cp $02			; $70ac
	jr nc,_label_0d_313	; $70ae
	call $73df		; $70b0
	ld h,d			; $70b3
	ld l,$a9		; $70b4
	ld (hl),$40		; $70b6
	ld l,$86		; $70b8
	ld (hl),$0a		; $70ba
	inc l			; $70bc
	inc (hl)		; $70bd
	ld l,$84		; $70be
	ld a,$0f		; $70c0
	cp (hl)			; $70c2
	jr z,_label_0d_313	; $70c3
	ld (hl),a		; $70c5
	ld l,$87		; $70c6
	ld (hl),$00		; $70c8
	ld l,$b0		; $70ca
	ld a,(hl)		; $70cc
	add $05			; $70cd
	call enemySetAnimation		; $70cf
	ld a,$24		; $70d2
	call objectGetRelatedObject2Var		; $70d4
	res 7,(hl)		; $70d7
	ld l,$84		; $70d9
	ld (hl),$03		; $70db
_label_0d_313:
	call $7323		; $70dd
	ld a,($cced)		; $70e0
	cp $02			; $70e3
	jr z,_label_0d_314	; $70e5
	ld e,$84		; $70e7
	ld a,(de)		; $70e9
	or a			; $70ea
	jp nz,$7312		; $70eb
_label_0d_314:
	ld e,$84		; $70ee
	ld a,(de)		; $70f0
	rst_jumpTable			; $70f1
	ld (de),a		; $70f2
	ld (hl),c		; $70f3
	dec (hl)		; $70f4
	ld (hl),c		; $70f5
	dec (hl)		; $70f6
	ld (hl),c		; $70f7
	dec (hl)		; $70f8
	ld (hl),c		; $70f9
	dec (hl)		; $70fa
	ld (hl),c		; $70fb
	dec (hl)		; $70fc
	ld (hl),c		; $70fd
	dec (hl)		; $70fe
	ld (hl),c		; $70ff
	dec (hl)		; $7100
	ld (hl),c		; $7101
	ld (hl),$71		; $7102
	ld d,c			; $7104
	ld (hl),c		; $7105
	ld d,a			; $7106
	ld (hl),c		; $7107
	ld h,e			; $7108
	ld (hl),c		; $7109
	ld (hl),l		; $710a
	ld (hl),c		; $710b
	add l			; $710c
	ld (hl),c		; $710d
	sbc a			; $710e
	ld (hl),c		; $710f
	cp a			; $7110
	ld (hl),c		; $7111
	call getFreeEnemySlot_uncounted		; $7112
	ret nz			; $7115
	ld (hl),$5f		; $7116
	ld l,$96		; $7118
	ld a,$80		; $711a
	ldi (hl),a		; $711c
	ld (hl),d		; $711d
	ld e,$98		; $711e
	ld (de),a		; $7120
	inc e			; $7121
	ld a,h			; $7122
	ld (de),a		; $7123
	call objectCopyPosition		; $7124
	call $736d		; $7127
	ld e,$b0		; $712a
	ld a,$01		; $712c
	ld (de),a		; $712e
	call enemySetAnimation		; $712f
	jp objectSetVisiblec2		; $7132
	ret			; $7135
	call $72d4		; $7136
	inc a			; $7139
	jr z,_label_0d_315	; $713a
	ld e,$84		; $713c
	ld a,$0d		; $713e
	ld (de),a		; $7140
	jr _label_0d_317		; $7141
_label_0d_315:
	call $73b1		; $7143
	ld a,$09		; $7146
	jr nc,_label_0d_316	; $7148
	ld a,$0b		; $714a
_label_0d_316:
	ld e,$84		; $714c
	ld (de),a		; $714e
	jr _label_0d_317		; $714f
	ld a,$0a		; $7151
	ld (de),a		; $7153
	jp $7350		; $7154
	call $7312		; $7157
	call z,$736d		; $715a
	call objectApplySpeed		; $715d
_label_0d_317:
	jp enemyAnimate		; $7160
	ld a,$0c		; $7163
	ld (de),a		; $7165
	inc e			; $7166
	xor a			; $7167
	ld (de),a		; $7168
	call $737f		; $7169
	ld e,$83		; $716c
	ld a,b			; $716e
	ld (de),a		; $716f
	ld e,$b1		; $7170
	inc a			; $7172
	ld (de),a		; $7173
	ret			; $7174
	ld e,$83		; $7175
	ld a,(de)		; $7177
	ld e,$85		; $7178
	rst_jumpTable			; $717a
.DB $dd				; $717b
	ld (hl),c		; $717c
	and $71			; $717d
	ld sp,hl		; $717f
	ld (hl),c		; $7180
	ld c,b			; $7181
	ld (hl),d		; $7182
	ld a,h			; $7183
	ld (hl),d		; $7184
	ld h,d			; $7185
	ld l,e			; $7186
	inc (hl)		; $7187
	inc l			; $7188
	ld (hl),$00		; $7189
	ld l,$90		; $718b
	ld (hl),$2d		; $718d
	call $7395		; $718f
	ret nc			; $7192
	ld e,$b2		; $7193
	ld a,(de)		; $7195
	ld hl,$73d7		; $7196
	rst_addAToHl			; $7199
	ld e,$89		; $719a
	ld a,(hl)		; $719c
	ld (de),a		; $719d
	ret			; $719e
	inc e			; $719f
	ld a,(de)		; $71a0
	rst_jumpTable			; $71a1
	and (hl)		; $71a2
	ld (hl),c		; $71a3
	ld d,a			; $71a4
	ld (hl),c		; $71a5
	call $7312		; $71a6
	jr z,_label_0d_318	; $71a9
	call objectApplySpeed		; $71ab
	jr _label_0d_317		; $71ae
_label_0d_318:
	ld e,$85		; $71b0
	ld a,$01		; $71b2
	ld (de),a		; $71b4
	ld bc,$4050		; $71b5
	call objectGetRelativeAngle		; $71b8
	ld e,$89		; $71bb
	ld (de),a		; $71bd
	ret			; $71be
	call _ecom_decCounter1		; $71bf
	ret nz			; $71c2
	ld a,$24		; $71c3
	call objectGetRelatedObject2Var		; $71c5
	set 7,(hl)		; $71c8
	inc l			; $71ca
	ld (hl),$40		; $71cb
	ld l,$84		; $71cd
	ld (hl),$01		; $71cf
	inc l			; $71d1
	ld (hl),$00		; $71d2
	ld e,$b0		; $71d4
	ld a,(de)		; $71d6
	call enemySetAnimation		; $71d7
	jp $736d		; $71da
	call $7312		; $71dd
	jp z,$736d		; $71e0
	jp enemyAnimate		; $71e3
	ld a,(de)		; $71e6
	rst_jumpTable			; $71e7
.DB $ec				; $71e8
	ld (hl),c		; $71e9
	ld a,($ff00+c)		; $71ea
	ld (hl),c		; $71eb
	ld h,d			; $71ec
	ld l,e			; $71ed
	inc (hl)		; $71ee
	inc l			; $71ef
	ld (hl),$3c		; $71f0
	call _ecom_decCounter1		; $71f2
	ret nz			; $71f5
	jp $736d		; $71f6
	ld a,(de)		; $71f9
	rst_jumpTable			; $71fa
	dec b			; $71fb
	ld (hl),d		; $71fc
	dec d			; $71fd
	ld (hl),d		; $71fe
	rra			; $71ff
	ld (hl),d		; $7200
	ld sp,$4172		; $7201
	ld (hl),d		; $7204
	ld h,d			; $7205
	ld l,e			; $7206
	inc (hl)		; $7207
	inc l			; $7208
	ld (hl),$1e		; $7209
	ld l,$90		; $720b
	ld (hl),$0a		; $720d
	call $73cd		; $720f
	xor $10			; $7212
	ld (de),a		; $7214
	call _ecom_decCounter1		; $7215
	jp nz,objectApplySpeed		; $7218
	ld (hl),$04		; $721b
	ld l,e			; $721d
	inc (hl)		; $721e
	call _ecom_decCounter1		; $721f
	ret nz			; $7222
	ld (hl),$1e		; $7223
	ld l,e			; $7225
	inc (hl)		; $7226
	ld l,$90		; $7227
	ld (hl),$50		; $7229
	ld l,$89		; $722b
	ld a,(hl)		; $722d
	xor $10			; $722e
	ld (hl),a		; $7230
	call _ecom_decCounter1		; $7231
	jr z,_label_0d_319	; $7234
	ld a,(hl)		; $7236
	cp $1a			; $7237
	jp nc,objectApplySpeed		; $7239
	ret			; $723c
_label_0d_319:
	ld (hl),$1e		; $723d
	ld l,e			; $723f
	inc (hl)		; $7240
	call _ecom_decCounter1		; $7241
	ret nz			; $7244
	jp $736d		; $7245
	ld a,(de)		; $7248
	rst_jumpTable			; $7249
	ld d,d			; $724a
	ld (hl),d		; $724b
	ld e,b			; $724c
	ld (hl),d		; $724d
	ld l,e			; $724e
	ld (hl),d		; $724f
	ld (hl),l		; $7250
	ld (hl),d		; $7251
	ld h,d			; $7252
	ld l,e			; $7253
	inc (hl)		; $7254
	inc l			; $7255
	ld (hl),$03		; $7256
	call $7312		; $7258
	ret nz			; $725b
	call _ecom_decCounter1		; $725c
	ret nz			; $725f
	ld (hl),$0a		; $7260
	dec l			; $7262
	inc (hl)		; $7263
	ld l,$90		; $7264
	ld (hl),$28		; $7266
	call $73cd		; $7268
	call _ecom_decCounter1		; $726b
	jp nz,objectApplySpeed		; $726e
	ld (hl),$28		; $7271
	ld l,e			; $7273
	inc (hl)		; $7274
	call _ecom_decCounter1		; $7275
	ret nz			; $7278
	jp $736d		; $7279
	ld a,(de)		; $727c
	rst_jumpTable			; $727d
	add h			; $727e
	ld (hl),d		; $727f
	sub a			; $7280
	ld (hl),d		; $7281
	or b			; $7282
	ld (hl),d		; $7283
	ld h,d			; $7284
	ld l,e			; $7285
	inc (hl)		; $7286
	ld l,$90		; $7287
	ld (hl),$28		; $7289
	ld l,$a4		; $728b
	res 7,(hl)		; $728d
	call _ecom_updateAngleTowardTarget		; $728f
	ld a,$04		; $7292
	jp enemySetAnimation		; $7294
	call $7312		; $7297
	jr z,_label_0d_320	; $729a
	call objectApplySpeed		; $729c
	jr _label_0d_323		; $729f
_label_0d_320:
	ld h,d			; $72a1
	ld l,$85		; $72a2
	inc (hl)		; $72a4
	ld l,$94		; $72a5
	ld a,$c0		; $72a7
	ldi (hl),a		; $72a9
	ld (hl),$fc		; $72aa
	ld l,$90		; $72ac
	ld (hl),$0f		; $72ae
	ld c,$28		; $72b0
	call objectUpdateSpeedZ_paramC		; $72b2
	jr nz,_label_0d_321	; $72b5
	ld e,$b0		; $72b7
	ld a,$02		; $72b9
	ld (de),a		; $72bb
	call enemySetAnimation		; $72bc
	jp $736d		; $72bf
_label_0d_321:
	ld e,$95		; $72c2
	ld a,(de)		; $72c4
	or a			; $72c5
	jr nz,_label_0d_322	; $72c6
	ld h,d			; $72c8
	ld l,$a4		; $72c9
	set 7,(hl)		; $72cb
_label_0d_322:
	rla			; $72cd
	call c,objectApplySpeed		; $72ce
_label_0d_323:
	jp enemyAnimate		; $72d1
	call $72dc		; $72d4
	ld e,$b2		; $72d7
	ld a,b			; $72d9
	ld (de),a		; $72da
	ret			; $72db
	ld b,$ff		; $72dc
	ld e,$8b		; $72de
	ld a,(de)		; $72e0
	sub $20			; $72e1
	cp $36			; $72e3
	jr nc,_label_0d_325	; $72e5
	ld e,$8d		; $72e7
	ld a,(de)		; $72e9
	sub $30			; $72ea
	cp $40			; $72ec
	ret c			; $72ee
	ld b,$02		; $72ef
	ld a,(de)		; $72f1
	cp $50			; $72f2
	jr c,_label_0d_324	; $72f4
	inc b			; $72f6
_label_0d_324:
	ld e,$8b		; $72f7
	ld a,(de)		; $72f9
	cp $39			; $72fa
	ret c			; $72fc
	ld a,b			; $72fd
	add $02			; $72fe
	ld b,a			; $7300
	ret			; $7301
_label_0d_325:
	inc b			; $7302
	ld a,(de)		; $7303
	cp $39			; $7304
	jr c,_label_0d_326	; $7306
	ld b,$06		; $7308
_label_0d_326:
	ld e,$8d		; $730a
	ld a,(de)		; $730c
	cp $50			; $730d
	ret c			; $730f
	inc b			; $7310
	ret			; $7311
	ld c,$0e		; $7312
	ld e,$8f		; $7314
	ld a,(de)		; $7316
	or a			; $7317
	jp nz,objectUpdateSpeedZ_paramC		; $7318
	dec a			; $731b
	ld (de),a		; $731c
	ld bc,$ff80		; $731d
	jp objectSetSpeedZ		; $7320
	call $7340		; $7323
	ret z			; $7326
	ld a,(wFrameCounter)		; $7327
	and $07			; $732a
	ret nz			; $732c
	call objectGetAngleTowardLink		; $732d
	add $04			; $7330
	and $18			; $7332
	swap a			; $7334
	rlca			; $7336
	ld h,d			; $7337
	ld l,$b0		; $7338
	cp (hl)			; $733a
	ret z			; $733b
	ld (hl),a		; $733c
	jp enemySetAnimation		; $733d
	ld e,$84		; $7340
	ld a,(de)		; $7342
	cp $0c			; $7343
	ret nz			; $7345
	ld e,$b1		; $7346
	ld a,(de)		; $7348
	dec a			; $7349
	jr z,_label_0d_327	; $734a
	xor a			; $734c
	ret			; $734d
_label_0d_327:
	or d			; $734e
	ret			; $734f
	ld c,$20		; $7350
	call objectCheckLinkWithinDistance		; $7352
	jp nc,_ecom_updateAngleTowardTarget		; $7355
	call getRandomNumber_noPreserveVars		; $7358
	and $01			; $735b
	ld b,$f8		; $735d
	jr z,_label_0d_328	; $735f
	ld b,$08		; $7361
_label_0d_328:
	push bc			; $7363
	call objectGetAngleTowardLink		; $7364
	pop bc			; $7367
	ld e,$89		; $7368
	add b			; $736a
	ld (de),a		; $736b
	ret			; $736c
	ld h,d			; $736d
	ld l,$84		; $736e
	ld (hl),$08		; $7370
	ld l,$a5		; $7372
	ld (hl),$56		; $7374
	ld l,$90		; $7376
	ld (hl),$0f		; $7378
	ld l,$b1		; $737a
	ld (hl),$00		; $737c
	ret			; $737e
	call getRandomNumber_noPreserveVars		; $737f
	ld b,$00		; $7382
	cp $30			; $7384
	ret c			; $7386
	inc b			; $7387
	cp $90			; $7388
	ret c			; $738a
	inc b			; $738b
	cp $e0			; $738c
	ret c			; $738e
	inc b			; $738f
	cp $ff			; $7390
	ret c			; $7392
	inc b			; $7393
	ret			; $7394
	ld bc,$4050		; $7395
	call objectGetRelativeAngle		; $7398
	ld b,a			; $739b
	push bc			; $739c
	call objectGetAngleTowardLink		; $739d
	pop bc			; $73a0
	sub b			; $73a1
	add $02			; $73a2
	cp $05			; $73a4
	ret c			; $73a6
	ld e,$89		; $73a7
	ld a,b			; $73a9
	ld (de),a		; $73aa
	ld e,$85		; $73ab
	ld a,$01		; $73ad
	ld (de),a		; $73af
	ret			; $73b0
	ld b,$09		; $73b1
	call objectCheckCenteredWithLink		; $73b3
	ret nc			; $73b6
	ld c,$1c		; $73b7
	call objectCheckLinkWithinDistance		; $73b9
	ret nc			; $73bc
	call objectGetAngleTowardLink		; $73bd
	ld b,a			; $73c0
	ld e,$b0		; $73c1
	ld a,(de)		; $73c3
	rrca			; $73c4
	swap a			; $73c5
	sub b			; $73c7
	add $04			; $73c8
	cp $09			; $73ca
	ret			; $73cc
	ld e,$b0		; $73cd
	ld a,(de)		; $73cf
	rrca			; $73d0
	swap a			; $73d1
	ld e,$89		; $73d3
	ld (de),a		; $73d5
	ret			; $73d6
	add hl,bc		; $73d7
	rla			; $73d8
	rrca			; $73d9
	ld de,$1f01		; $73da
	rlca			; $73dd
	add hl,de		; $73de
	ld a,$2b		; $73df
	call objectGetRelatedObject2Var		; $73e1
	ld e,$ab		; $73e4
	ld a,(de)		; $73e6
	ld (hl),a		; $73e7
	ret			; $73e8

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode55:
	jr z,_label_0d_331	; $73e9
	sub $03			; $73eb
	ret c			; $73ed
	jr nz,_label_0d_331	; $73ee
	ld h,d			; $73f0
	ld l,$b2		; $73f1
	bit 0,(hl)		; $73f3
	jr nz,_label_0d_329	; $73f5
	inc (hl)		; $73f7
	ld l,$86		; $73f8
	ld (hl),$1e		; $73fa
	ld a,$69		; $73fc
	call playSound		; $73fe
	ld a,$32		; $7401
	call objectGetRelatedObject1Var		; $7403
	dec (hl)		; $7406
	dec l			; $7407
	dec (hl)		; $7408
	jr z,_label_0d_330	; $7409
	ld a,$04		; $740b
	call enemySetAnimation		; $740d
_label_0d_329:
	call _ecom_decCounter1		; $7410
	ret nz			; $7413
	jp enemyDie_uncounted		; $7414
_label_0d_330:
	ld l,$a9		; $7417
	ld (hl),$00		; $7419
	call objectCopyPosition		; $741b
	jp enemyDelete		; $741e
_label_0d_331:
	ld e,$84		; $7421
	ld a,(de)		; $7423
	rst_jumpTable			; $7424
	ccf			; $7425
	ld (hl),h		; $7426
	ld h,h			; $7427
	ld (hl),h		; $7428
	ld h,h			; $7429
	ld (hl),h		; $742a
	ld h,h			; $742b
	ld (hl),h		; $742c
	ld h,h			; $742d
	ld (hl),h		; $742e
	ld h,h			; $742f
	ld (hl),h		; $7430
	ld h,h			; $7431
	ld (hl),h		; $7432
	ld h,h			; $7433
	ld (hl),h		; $7434
	ld h,l			; $7435
	ld (hl),h		; $7436
	ld (hl),a		; $7437
	ld (hl),h		; $7438
	adc e			; $7439
	ld (hl),h		; $743a
	sbc d			; $743b
	ld (hl),h		; $743c
	cp h			; $743d
	ld (hl),h		; $743e
	ld bc,$011f		; $743f
	call _ecom_randomBitwiseAndBCE		; $7442
	ld e,$89		; $7445
	ld a,c			; $7447
	ld (de),a		; $7448
	ld a,b			; $7449
	ld hl,$7462		; $744a
	rst_addAToHl			; $744d
	ld e,$87		; $744e
	ld a,(hl)		; $7450
	ld (de),a		; $7451
	call $74ce		; $7452
	ld h,d			; $7455
	ld l,$94		; $7456
	ld a,$80		; $7458
	ldi (hl),a		; $745a
	ld (hl),$fe		; $745b
	ld a,$32		; $745d
	jp _ecom_setSpeedAndState8AndVisible		; $745f
	inc a			; $7462
	ld d,b			; $7463
	ret			; $7464
	ld c,$0e		; $7465
	call objectUpdateSpeedZ_paramC		; $7467
	jr nz,_label_0d_333	; $746a
	ld l,$84		; $746c
	inc (hl)		; $746e
	ld l,$94		; $746f
	ld a,$00		; $7471
	ldi (hl),a		; $7473
	ld (hl),$ff		; $7474
	ret			; $7476
	call $7523		; $7477
	ld c,$0f		; $747a
	call objectUpdateSpeedZ_paramC		; $747c
	jr nz,_label_0d_333	; $747f
	ld l,$84		; $7481
	inc (hl)		; $7483
	ld l,$87		; $7484
	ld a,(hl)		; $7486
	ld l,$90		; $7487
	ld (hl),a		; $7489
	ret			; $748a
	call $7547		; $748b
	call $7523		; $748e
	call $74e1		; $7491
	call $74c5		; $7494
	jp enemyAnimate		; $7497
	ld c,$10		; $749a
	call objectUpdateSpeedZ_paramC		; $749c
	ld l,$95		; $749f
	ldd a,(hl)		; $74a1
	or a			; $74a2
	jr nz,_label_0d_332	; $74a3
	ldi a,(hl)		; $74a5
	or a			; $74a6
	jr nz,_label_0d_332	; $74a7
	ld (hl),$02		; $74a9
	ld l,$90		; $74ab
	ld (hl),$6e		; $74ad
_label_0d_332:
	ld l,$97		; $74af
	ld h,(hl)		; $74b1
	call $74fe		; $74b2
	jr nc,_label_0d_334	; $74b5
	ld e,$8f		; $74b7
	ld a,(de)		; $74b9
	or a			; $74ba
	ret nz			; $74bb
	ld a,$32		; $74bc
	call objectGetRelatedObject1Var		; $74be
	dec (hl)		; $74c1
	jp enemyDelete		; $74c2
_label_0d_333:
	call _ecom_bounceOffWallsAndHoles		; $74c5
_label_0d_334:
	call $74ce		; $74c8
	jp objectApplySpeed		; $74cb
	ld h,d			; $74ce
	ld l,$b0		; $74cf
	ld e,$89		; $74d1
	ld a,(de)		; $74d3
	add $04			; $74d4
	and $18			; $74d6
	swap a			; $74d8
	rlca			; $74da
	cp (hl)			; $74db
	ret z			; $74dc
	ld (hl),a		; $74dd
	jp enemySetAnimation		; $74de
	ld e,$99		; $74e1
	ld a,(de)		; $74e3
	or a			; $74e4
	ret z			; $74e5
	ld h,d			; $74e6
	ld l,$84		; $74e7
	inc (hl)		; $74e9
	cp h			; $74ea
	jr nz,_label_0d_335	; $74eb
	inc (hl)		; $74ed
_label_0d_335:
	ld l,$90		; $74ee
	ld (hl),$28		; $74f0
	ld l,$94		; $74f2
	ld a,$c0		; $74f4
	ldi (hl),a		; $74f6
	ld (hl),$fc		; $74f7
	ld a,$59		; $74f9
	jp playSound		; $74fb
	ld l,$8b		; $74fe
	ld e,l			; $7500
	ld b,(hl)		; $7501
	ld a,(de)		; $7502
	ldh (<hFF8F),a	; $7503
	ld l,$8d		; $7505
	ld e,l			; $7507
	ld c,(hl)		; $7508
	ld a,(de)		; $7509
	ldh (<hFF8E),a	; $750a
	sub c			; $750c
	add $02			; $750d
	cp $05			; $750f
	jr nc,_label_0d_336	; $7511
	ldh a,(<hFF8F)	; $7513
	sub b			; $7515
	add $02			; $7516
	cp $05			; $7518
	ret c			; $751a
_label_0d_336:
	call objectGetRelativeAngleWithTempVars		; $751b
	ld e,$89		; $751e
	ld (de),a		; $7520
	or d			; $7521
	ret			; $7522
	ld e,$b1		; $7523
	ld a,(de)		; $7525
	ld h,a			; $7526
	ld l,$8b		; $7527
	ld e,l			; $7529
	ld a,(de)		; $752a
	sub (hl)		; $752b
	add $0a			; $752c
	cp $15			; $752e
	ret nc			; $7530
	ld l,$8d		; $7531
	ld e,l			; $7533
	ld a,(de)		; $7534
	sub (hl)		; $7535
	add $0a			; $7536
	cp $15			; $7538
	ret nc			; $753a
	ld l,$90		; $753b
	ld a,(hl)		; $753d
	cp $14			; $753e
	ret c			; $7540
	pop hl			; $7541
	ld e,$a9		; $7542
	xor a			; $7544
	ld (de),a		; $7545
	ret			; $7546
	ld a,(wFrameCounter)		; $7547
	and $07			; $754a
	ret nz			; $754c
	ld a,$a3		; $754d
	jp playSound		; $754f

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode56:
	jr z,_label_0d_337	; $7552
	ld e,$84		; $7554
	ld a,$02		; $7556
	ld (de),a		; $7558
_label_0d_337:
	ld e,$84		; $7559
	ld a,(de)		; $755b
	rst_jumpTable			; $755c
	ld h,l			; $755d
	ld (hl),l		; $755e
	ld l,l			; $755f
	ld (hl),l		; $7560
	reti			; $7561
	ld (hl),l		; $7562
	dec c			; $7563
	halt			; $7564
	ld a,$01		; $7565
	ld (de),a		; $7567
	call objectSetVisible80		; $7568
	jr _label_0d_339		; $756b
	ld e,$82		; $756d
	ld a,(de)		; $756f
	jr z,_label_0d_338	; $7570
	ld hl,$cfc0		; $7572
	bit 7,(hl)		; $7575
	jr z,_label_0d_338	; $7577
	ld e,$84		; $7579
	ld a,$02		; $757b
	ld (de),a		; $757d
_label_0d_338:
	call enemyAnimate		; $757e
_label_0d_339:
	ld a,$0b		; $7581
	call objectGetRelatedObject2Var		; $7583
	ldi a,(hl)		; $7586
	ld b,a			; $7587
	inc l			; $7588
	ld c,(hl)		; $7589
	ld e,$84		; $758a
	ld a,(de)		; $758c
	cp $01			; $758d
	jr nz,_label_0d_340	; $758f
	ld e,$a1		; $7591
	ld a,(de)		; $7593
	or a			; $7594
	jr nz,_label_0d_341	; $7595
	ld e,$a0		; $7597
	ld a,(de)		; $7599
	cp $01			; $759a
	jr nz,_label_0d_340	; $759c
	ld a,$92		; $759e
	call playSound		; $75a0
_label_0d_340:
	ld e,$a1		; $75a3
	ld a,(de)		; $75a5
_label_0d_341:
	add a			; $75a6
	ld hl,$75c1		; $75a7
	rst_addDoubleIndex			; $75aa
	ld e,$8b		; $75ab
	ldi a,(hl)		; $75ad
	add b			; $75ae
	ld (de),a		; $75af
	ld e,$8d		; $75b0
	ldi a,(hl)		; $75b2
	add c			; $75b3
	ld (de),a		; $75b4
	ld e,$8f		; $75b5
	ld a,$f8		; $75b7
	ld (de),a		; $75b9
	ld e,$a6		; $75ba
	ldi a,(hl)		; $75bc
	ld (de),a		; $75bd
	inc e			; $75be
	ld (de),a		; $75bf
	ret			; $75c0
	ret c			; $75c1
	ld ($ff00+$00),a	; $75c2
	nop			; $75c4
	ld b,$f6		; $75c5
	nop			; $75c7
	nop			; $75c8
	ld ($06f0),sp		; $75c9
	nop			; $75cc
	inc b			; $75cd
.DB $ec				; $75ce
	ld ($0700),sp		; $75cf
	ld a,($ff00+$06)	; $75d2
	nop			; $75d4
	dec b			; $75d5
	or $00			; $75d6
	nop			; $75d8
	ld h,d			; $75d9
	ld l,$85		; $75da
	ld a,(hl)		; $75dc
	or a			; $75dd
	jr nz,_label_0d_342	; $75de
	inc (hl)		; $75e0
	ld l,$a4		; $75e1
	ld b,$0b		; $75e3
	call clearMemory		; $75e5
	ld l,$a9		; $75e8
	inc (hl)		; $75ea
	ld l,$9b		; $75eb
	ld a,$01		; $75ed
	ldi (hl),a		; $75ef
	ld (hl),a		; $75f0
	ld a,$01		; $75f1
	call enemySetAnimation		; $75f3
	ld hl,$cfc0		; $75f6
	set 7,(hl)		; $75f9
	jr _label_0d_339		; $75fb
_label_0d_342:
	ld l,$a1		; $75fd
	bit 7,(hl)		; $75ff
	jp z,enemyAnimate		; $7601
	xor a			; $7604
	ld (hl),a		; $7605
	ld l,$85		; $7606
	ldd (hl),a		; $7608
	inc (hl)		; $7609
	jp $7581		; $760a
	call enemyAnimate		; $760d
	ld e,$a1		; $7610
	ld a,(de)		; $7612
	or a			; $7613
	ret z			; $7614
	rlca			; $7615
	jp c,enemyDelete		; $7616
	ld h,d			; $7619
	ld l,$8b		; $761a
	inc (hl)		; $761c
	ret			; $761d

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode5b:
	ld e,$84		; $761e
	ld a,(de)		; $7620
	rst_jumpTable			; $7621
	jr z,_label_0d_343	; $7622
	add hl,sp		; $7624
	halt			; $7625
	ld e,a			; $7626
	daa			; $7627
	ld a,$01		; $7628
	ld (de),a		; $762a
	call getRandomNumber		; $762b
	and $07			; $762e
	inc a			; $7630
	ld e,$86		; $7631
	ld (de),a		; $7633
	ld a,$b0		; $7634
	jp loadPaletteHeader		; $7636
	call _ecom_decCounter1		; $7639
	ret nz			; $763c
	ld l,e			; $763d
	inc (hl)		; $763e
	jp objectSetVisible83		; $763f

; ==============================================================================
; ENEMYID_WALL_FLAME_SHOOTER
; ==============================================================================
enemyCode5c:
	dec a			; $7642
	ret z			; $7643
	dec a			; $7644
	ret z			; $7645
	ld e,$84		; $7646
	ld a,(de)		; $7648
	rst_jumpTable			; $7649
	ld c,(hl)		; $764a
	halt			; $764b
	ld e,a			; $764c
	halt			; $764d
	ld h,d			; $764e
	ld l,e			; $764f
	inc (hl)		; $7650
	ld l,$8f		; $7651
	ld (hl),$fe		; $7653
	ld l,$82		; $7655
	bit 0,(hl)		; $7657
	ret z			; $7659
	ld l,$87		; $765a
	ld (hl),$08		; $765c
	ret			; $765e
	call _ecom_decCounter2		; $765f
	ret nz			; $7662
	ld (hl),$10		; $7663
	call getFreePartSlot		; $7665
	ret nz			; $7668
	ld (hl),$26		; $7669
	ld bc,$0600		; $766b
	jp objectCopyPositionWithOffset		; $766e

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode5f:
	jr z,_label_0d_344	; $7671
	call $7986		; $7673
	ld e,$a5		; $7676
	ld a,(de)		; $7678
	cp $40			; $7679
	jr nz,_label_0d_344	; $767b
	ld e,$aa		; $767d
	ld a,(de)		; $767f
	res 7,a			; $7680
	sub $0a			; $7682
	cp $02			; $7684
	jr nc,_label_0d_344	; $7686
	ld h,d			; $7688
	ld l,$84		; $7689
	ld (hl),$02		; $768b
	ld l,$a4		; $768d
	res 7,(hl)		; $768f
	ld l,$87		; $7691
	ld (hl),$1e		; $7693
	ld l,$8e		; $7695
	xor a			; $7697
	ldi (hl),a		; $7698
	ld (hl),a		; $7699
_label_0d_343:
	ld a,$2b		; $769a
	call objectGetRelatedObject1Var		; $769c
	ld (hl),$f8		; $769f
	ld l,$8e		; $76a1
	xor a			; $76a3
	ldi (hl),a		; $76a4
	ld (hl),a		; $76a5
_label_0d_344:
	call $785c		; $76a6
	ld e,$84		; $76a9
	ld a,(de)		; $76ab
	rst_jumpTable			; $76ac
	or l			; $76ad
	halt			; $76ae
	cp b			; $76af
	halt			; $76b0
	call z,$ee76		; $76b1
	halt			; $76b4
	ld a,$01		; $76b5
	ld (de),a		; $76b7
	call $786d		; $76b8
	ld b,h			; $76bb
	ld e,$85		; $76bc
	ld a,(hl)		; $76be
	rst_jumpTable			; $76bf
	ld a,($fa76)		; $76c0
	halt			; $76c3
	cp $76			; $76c4
	dec sp			; $76c6
	ld (hl),a		; $76c7
	xor (hl)		; $76c8
	ld (hl),a		; $76c9
	rrca			; $76ca
	ld a,b			; $76cb
	call _ecom_decCounter2		; $76cc
	jr z,_label_0d_345	; $76cf
	ld a,$2e		; $76d1
	call objectGetRelatedObject1Var		; $76d3
	ld (hl),$02		; $76d6
	ld l,$a5		; $76d8
	ld (hl),$3b		; $76da
	jr _label_0d_346		; $76dc
_label_0d_345:
	ld l,e			; $76de
	dec (hl)		; $76df
	ld l,$a4		; $76e0
	set 7,(hl)		; $76e2
	ld a,$25		; $76e4
	call objectGetRelatedObject1Var		; $76e6
	ld (hl),$56		; $76e9
_label_0d_346:
	jp $796d		; $76eb
	ld a,$2b		; $76ee
	call objectGetRelatedObject1Var		; $76f0
	ld e,$ab		; $76f3
	ld a,(hl)		; $76f5
	ld (de),a		; $76f6
	jp $796d		; $76f7
	ld h,b			; $76fa
	jp $7883		; $76fb
	ld a,(de)		; $76fe
	rst_jumpTable			; $76ff
	inc b			; $7700
	ld (hl),a		; $7701
	dec bc			; $7702
	ld (hl),a		; $7703
	ld h,d			; $7704
	ld l,e			; $7705
	inc (hl)		; $7706
	ld l,$a5		; $7707
	ld (hl),$57		; $7709
	call $76fa		; $770b
	ld l,$b0		; $770e
	ld a,(hl)		; $7710
	add a			; $7711
	add a			; $7712
	ld b,a			; $7713
	ld a,(wFrameCounter)		; $7714
	and $04			; $7717
	rrca			; $7719
	add b			; $771a
	ld hl,$772b		; $771b
	rst_addAToHl			; $771e
	ld e,$8b		; $771f
	ld a,(de)		; $7721
	add (hl)		; $7722
	ld (de),a		; $7723
	inc hl			; $7724
	ld e,$8d		; $7725
	ld a,(de)		; $7727
	add (hl)		; $7728
	ld (de),a		; $7729
	ret			; $772a
	ld hl,sp+$00		; $772b
	ei			; $772d
	nop			; $772e
	nop			; $772f
	ld ($0500),sp		; $7730
	ld ($0500),sp		; $7733
	nop			; $7736
	nop			; $7737
	ld hl,sp+$00		; $7738
	ei			; $773a
	ld a,(de)		; $773b
	rst_jumpTable			; $773c
	ld c,c			; $773d
	ld (hl),a		; $773e
	ld l,c			; $773f
	ld (hl),a		; $7740
	ld (hl),e		; $7741
	ld (hl),a		; $7742
	add a			; $7743
	ld (hl),a		; $7744
	sub c			; $7745
	ld (hl),a		; $7746
	and l			; $7747
	ld (hl),a		; $7748
	ld h,d			; $7749
	ld l,e			; $774a
	inc (hl)		; $774b
	ld l,$a5		; $774c
	ld (hl),$04		; $774e
	ld l,$90		; $7750
	ld (hl),$0a		; $7752
	ld l,$87		; $7754
	ld (hl),$1e		; $7756
	call $76fa		; $7758
	ld l,$b0		; $775b
	ld a,(hl)		; $775d
	rrca			; $775e
	swap a			; $775f
	xor $10			; $7761
	ld e,$89		; $7763
	ld (de),a		; $7765
	call $78ce		; $7766
	call _ecom_decCounter2		; $7769
	jp nz,$78bc		; $776c
	ld (hl),$04		; $776f
	ld l,e			; $7771
	inc (hl)		; $7772
	call _ecom_decCounter2		; $7773
	jp nz,$78ab		; $7776
	ld (hl),$0a		; $7779
	ld l,e			; $777b
	inc (hl)		; $777c
	ld l,$90		; $777d
	ld (hl),$78		; $777f
	ld l,$89		; $7781
	ld a,(hl)		; $7783
	xor $10			; $7784
	ld (hl),a		; $7786
	call _ecom_decCounter2		; $7787
	jp nz,$78bc		; $778a
	ld (hl),$14		; $778d
	ld l,e			; $778f
	inc (hl)		; $7790
	call _ecom_decCounter2		; $7791
	jp nz,$78ab		; $7794
	ld (hl),$14		; $7797
	ld l,e			; $7799
	inc (hl)		; $779a
	ld l,$90		; $779b
	ld (hl),$28		; $779d
	ld l,$89		; $779f
	ld a,(hl)		; $77a1
	xor $10			; $77a2
	ld (hl),a		; $77a4
	call _ecom_decCounter2		; $77a5
	jp nz,$78bc		; $77a8
	jp $76fa		; $77ab
	ld a,(de)		; $77ae
	rst_jumpTable			; $77af
	cp b			; $77b0
	ld (hl),a		; $77b1
	cp a			; $77b2
	ld (hl),a		; $77b3
	jp hl			; $77b4
	ld (hl),a		; $77b5
	ld (bc),a		; $77b6
	ld a,b			; $77b7
	ld h,d			; $77b8
	ld l,e			; $77b9
	inc (hl)		; $77ba
	ld l,$a5		; $77bb
	ld (hl),$57		; $77bd
	call $76fa		; $77bf
	ld a,$05		; $77c2
	call objectGetRelatedObject1Var		; $77c4
	ld a,(hl)		; $77c7
	cp $02			; $77c8
	ret c			; $77ca
	ld l,$89		; $77cb
	ld e,$89		; $77cd
	ld a,(hl)		; $77cf
	ld (de),a		; $77d0
	call $78ce		; $77d1
	ld bc,$ff80		; $77d4
	call objectSetSpeedZ		; $77d7
	ld l,$a5		; $77da
	ld (hl),$58		; $77dc
	ld l,$85		; $77de
	inc (hl)		; $77e0
	ld l,$87		; $77e1
	ld (hl),$0a		; $77e3
	ld l,$90		; $77e5
	ld (hl),$50		; $77e7
	call _ecom_decCounter2		; $77e9
	jr nz,_label_0d_347	; $77ec
	ld (hl),$08		; $77ee
	ld l,e			; $77f0
	inc (hl)		; $77f1
	ld l,$90		; $77f2
	ld (hl),$64		; $77f4
	ld l,$89		; $77f6
	ld a,(hl)		; $77f8
	xor $10			; $77f9
	ld (hl),a		; $77fb
_label_0d_347:
	call $78bc		; $77fc
	jp $78e1		; $77ff
	call _ecom_decCounter2		; $7802
	jp z,$76fa		; $7805
	ld l,$8f		; $7808
	inc (hl)		; $780a
	inc (hl)		; $780b
	jp $78bc		; $780c
	ld a,(de)		; $780f
	rst_jumpTable			; $7810
	rla			; $7811
	ld a,b			; $7812
	ldi (hl),a		; $7813
	ld a,b			; $7814
	ld b,(hl)		; $7815
	ld a,b			; $7816
	ld h,d			; $7817
	ld l,$85		; $7818
	inc (hl)		; $781a
	ld l,$a4		; $781b
	res 7,(hl)		; $781d
	inc l			; $781f
	ld (hl),$58		; $7820
	ld a,$05		; $7822
	call objectGetRelatedObject1Var		; $7824
	ld a,(hl)		; $7827
	cp $02			; $7828
	jp c,$78f8		; $782a
	ld h,d			; $782d
	ld l,$87		; $782e
	ld (hl),$1e		; $7830
	ld l,$a6		; $7832
	ld a,$08		; $7834
	ldi (hl),a		; $7836
	ld (hl),a		; $7837
	ld l,$a4		; $7838
	set 7,(hl)		; $783a
	ld l,$85		; $783c
	inc (hl)		; $783e
	ld l,$94		; $783f
	ld a,$c0		; $7841
	ldi (hl),a		; $7843
	ld (hl),$fb		; $7844
	call _ecom_decCounter2		; $7846
	jr z,_label_0d_348	; $7849
	ld l,$a6		; $784b
	ld a,$06		; $784d
	ldi (hl),a		; $784f
	ld (hl),a		; $7850
_label_0d_348:
	call $7915		; $7851
	call $78f8		; $7854
	ld c,$34		; $7857
	jp objectUpdateSpeedZ_paramC		; $7859
	ld e,$84		; $785c
	ld a,(de)		; $785e
	or a			; $785f
	ret z			; $7860
	ld a,$01		; $7861
	call objectGetRelatedObject1Var		; $7863
	ld a,(hl)		; $7866
	cp $54			; $7867
	ret z			; $7869
	jp enemyDelete		; $786a
	ld a,$31		; $786d
	call objectGetRelatedObject1Var		; $786f
	ld e,$b1		; $7872
	ld a,(de)		; $7874
	cp (hl)			; $7875
	ret z			; $7876
	ld a,(hl)		; $7877
	ld (de),a		; $7878
	ld e,$a5		; $7879
	ld a,$40		; $787b
	ld (de),a		; $787d
	ld e,$85		; $787e
	xor a			; $7880
	ld (de),a		; $7881
	ret			; $7882
	ld l,$b0		; $7883
	ld a,(hl)		; $7885
	push hl			; $7886
	ld hl,$78a3		; $7887
	rst_addDoubleIndex			; $788a
	ldi a,(hl)		; $788b
	ld c,(hl)		; $788c
	ld b,a			; $788d
	pop hl			; $788e
	ld l,$8f		; $788f
	ld e,$8f		; $7891
	ld a,(hl)		; $7893
	ld (de),a		; $7894
	call objectTakePositionWithOffset		; $7895
	ld l,$b0		; $7898
	ld a,(hl)		; $789a
	cp $02			; $789b
	jp c,objectSetVisible82		; $789d
	jp objectSetVisible81		; $78a0
	ei			; $78a3
.DB $fc				; $78a4
	ld bc,$0406		; $78a5
	inc b			; $78a8
	ld bc,$2efc		; $78a9
	or d			; $78ac
	ld b,(hl)		; $78ad
	inc l			; $78ae
	ld c,(hl)		; $78af
	ld a,$0b		; $78b0
	call objectGetRelatedObject1Var		; $78b2
	push hl			; $78b5
	call $7895		; $78b6
	pop hl			; $78b9
	jr _label_0d_349		; $78ba
	ld l,$b2		; $78bc
	ld b,(hl)		; $78be
	inc l			; $78bf
	ld c,(hl)		; $78c0
	ld a,$0b		; $78c1
	call objectGetRelatedObject1Var		; $78c3
	push hl			; $78c6
	call $7895		; $78c7
	call objectApplySpeed		; $78ca
	pop hl			; $78cd
_label_0d_349:
	ld l,$8b		; $78ce
	ld e,$8b		; $78d0
	ld a,(de)		; $78d2
	sub (hl)		; $78d3
	ld e,$b2		; $78d4
	ld (de),a		; $78d6
	ld l,$8d		; $78d7
	ld e,$8d		; $78d9
	ld a,(de)		; $78db
	sub (hl)		; $78dc
	ld e,$b3		; $78dd
	ld (de),a		; $78df
	ret			; $78e0
	ld h,d			; $78e1
	ld l,$94		; $78e2
	ld e,$8e		; $78e4
	ld a,(de)		; $78e6
	sub (hl)		; $78e7
	ld (de),a		; $78e8
	inc l			; $78e9
	inc e			; $78ea
	ld a,(de)		; $78eb
	sbc (hl)		; $78ec
	ld (de),a		; $78ed
	dec l			; $78ee
	ld a,(hl)		; $78ef
	add $80			; $78f0
	ldi (hl),a		; $78f2
	ld a,(hl)		; $78f3
	adc $00			; $78f4
	ld (hl),a		; $78f6
	ret			; $78f7
	ld a,$21		; $78f8
	call objectGetRelatedObject1Var		; $78fa
	push hl			; $78fd
	ld a,(hl)		; $78fe
	ld hl,$78a3		; $78ff
	rst_addAToHl			; $7902
	ldi a,(hl)		; $7903
	ld c,(hl)		; $7904
	ld b,a			; $7905
	pop hl			; $7906
	call objectTakePositionWithOffset		; $7907
	ld l,$a1		; $790a
	ld a,(hl)		; $790c
	cp $02			; $790d
	jp c,objectSetVisible82		; $790f
	jp objectSetVisible81		; $7912
	call $795c		; $7915
	ld l,$aa		; $7918
	ld a,(hl)		; $791a
	cp $80			; $791b
	ret nz			; $791d
	ld l,$b4		; $791e
	ld (hl),$08		; $7920
	ld hl,$d00f		; $7922
	ld a,(hl)		; $7925
	sub $08			; $7926
	ld (hl),a		; $7928
	ld l,$2b		; $7929
	ld (hl),$00		; $792b
	ld l,$2d		; $792d
	ld (hl),$00		; $792f
	ld a,$09		; $7931
	call objectGetRelatedObject1Var		; $7933
	ld a,(hl)		; $7936
	ld ($d02c),a		; $7937
	add $04			; $793a
	and $18			; $793c
	rrca			; $793e
	rrca			; $793f
	ld hl,$7954		; $7940
	rst_addAToHl			; $7943
	ld e,$8b		; $7944
	ld a,(de)		; $7946
	add (hl)		; $7947
	ld ($d00b),a		; $7948
	inc hl			; $794b
	ld e,$8d		; $794c
	ld a,(de)		; $794e
	add (hl)		; $794f
	ld ($d00d),a		; $7950
	ret			; $7953
.DB $fc				; $7954
	nop			; $7955
	nop			; $7956
	inc b			; $7957
	inc b			; $7958
	nop			; $7959
	nop			; $795a
.DB $fc				; $795b
	ld h,d			; $795c
	ld l,$b4		; $795d
	ld a,(hl)		; $795f
	or a			; $7960
	ret z			; $7961
	dec (hl)		; $7962
	ret nz			; $7963
	ld a,$14		; $7964
	ld ($d02b),a		; $7966
	ld ($d02d),a		; $7969
	ret			; $796c
	ld a,$30		; $796d
	call objectGetRelatedObject1Var		; $796f
	ld a,(hl)		; $7972
	push hl			; $7973
	ld hl,$7982		; $7974
	rst_addAToHl			; $7977
	ld c,(hl)		; $7978
	ld b,$f8		; $7979
	pop hl			; $797b
	call objectTakePositionWithOffset		; $797c
	jp $7898		; $797f
	ei			; $7982
.DB $fc				; $7983
	dec b			; $7984
	inc b			; $7985
	ld e,$ab		; $7986
	ld a,(de)		; $7988
	bit 7,a			; $7989
	ret z			; $798b
	xor a			; $798c
	ld (de),a		; $798d
	ret			; $798e
