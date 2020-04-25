; ==============================================================================
; ENEMYID_RIVER_ZORA
; ==============================================================================
enemyCode08:
	jr z,@normalStatus	; $44f0
	sub ENEMYSTATUS_NO_HEALTH			; $44f2
	ret c			; $44f4
	jp z,enemyDie		; $44f5

@normalStatus:
	ld e,Enemy.state		; $44f8
	ld a,(de)		; $44fa
	rst_jumpTable			; $44fb
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_08
	.dw @state_09
	.dw @state_0a
	.dw @state_0b

@state_uninitialized:
	ld a,$09		; $4514
	ld (de),a		; $4516
	ret			; $4517

@state_stub:
	ret			; $4518


; Waiting under the water until time to resurface
@state_08:
	call _ecom_decCounter1		; $4519
	ret nz			; $451c
	ld l,e			; $451d
	inc (hl)		; $451e
	ret			; $451f


; Resurfacing in a random position
@state_09:
	call getRandomNumber_noPreserveVars		; $4520
	cp (SCREEN_WIDTH<<4)-8			; $4523
	ret nc			; $4525

	ld c,a			; $4526
	ldh a,(<hCameraX)	; $4527
	add c			; $4529
	ld c,a			; $452a

	ldh a,(<hCameraY)	; $452b
	ld b,a			; $452d
	ldh a,(<hRng2)	; $452e
	res 7,a			; $4530
	add b			; $4532
	ld b,a			; $4533

	call checkTileAtPositionIsWater		; $4534
	ret nc			; $4537

	; Tile is water; spawn here.
	ld c,l			; $4538
	call objectSetShortPosition		; $4539
	ld l,Enemy.counter1		; $453c
	ld (hl),48		; $453e

	ld l,Enemy.state		; $4540
	inc (hl) ; [state] = $0a

	xor a			; $4543
	call enemySetAnimation		; $4544
	jp objectSetVisible83		; $4547


; In the process of surfacing.
@state_0a:
	call _ecom_decCounter1		; $454a
	jr nz,@animate	; $454d

	; Surfaced; enable collisions & set animation.
	ld l,e			; $454f
	inc (hl)		; $4550
	ld l,Enemy.collisionType		; $4551
	set 7,(hl)		; $4553
	ld a,$01		; $4555
	jp enemySetAnimation		; $4557


; Above water, waiting until time to fire projectile.
@state_0b:
	ld h,d			; $455a
	ld l,Enemy.animParameter		; $455b
	ld a,(hl)		; $455d
	inc a			; $455e
	jr z,@disappear	; $455f

	dec a			; $4561
	jr z,@animate	; $4562

	; Make projectile
	ld (hl),$00		; $4564
	ld b,PARTID_ZORA_FIRE		; $4566
	call _ecom_spawnProjectile		; $4568
	jr nz,@animate	; $456b
	ld l,Part.subid		; $456d
	inc (hl)		; $456f

@animate:
	jp enemyAnimate		; $4570

@disappear:
	ld a,$08		; $4573
	ld (de),a ; [state] = 8

	ld l,Enemy.collisionType		; $4576
	res 7,(hl)		; $4578

	call getRandomNumber_noPreserveVars		; $457a
	and $1f			; $457d
	add $18			; $457f
	ld e,Enemy.counter1		; $4581
	ld (de),a		; $4583

	ld b,INTERACID_SPLASH		; $4584
	call objectCreateInteractionWithSubid00		; $4586
	jp objectSetInvisible		; $4589


; ==============================================================================
; ENEMYID_OCTOROK
;
; Variables:
;   counter1: How many frames to wait after various actions.
;   var30: How many frames to walk for.
;   var32: Should be 1, 3, or 7. Lower values make the octorok move and shoot more often.
; ==============================================================================
enemyCode09:
	call _ecom_checkHazards		; $458c
	jr z,@normalStatus	; $458f

	sub ENEMYSTATUS_NO_HEALTH			; $4591
	ret c			; $4593
	jr z,@dead	; $4594

	; Check ENEMYSTATUS_KNOCKBACK
	dec a			; $4596
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4597
	ret			; $459a

@dead:
	ld e,Enemy.subid		; $459b
	ld a,(de)		; $459d
	cp $04			; $459e
	jr nz,++		; $45a0
	ld hl,wKilledGoldenEnemies		; $45a2
	set 0,(hl)		; $45a5
++
	jp enemyDie		; $45a7

@normalStatus:
	call _ecom_checkScentSeedActive		; $45aa
	ld e,Enemy.state		; $45ad
	ld a,(de)		; $45af
	rst_jumpTable			; $45b0
	.dw _octorok_state_uninitialized
	.dw _octorok_state_stub
	.dw _octorok_state_stub
	.dw _octorok_state_latchedBySwitchHook
	.dw _octorok_state_followingScentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _octorok_state_stub
	.dw _octorok_state_stub
	.dw _octorok_state_08
	.dw _octorok_state_09
	.dw _octorok_state_0a
	.dw _octorok_state_0b


_octorok_state_uninitialized:
	; Delete self if it's a golden enemy that's been defeated
	ld e,Enemy.subid		; $45c9
	ld a,(de)		; $45cb
	cp $04			; $45cc
	jr nz,++		; $45ce
	ld hl,wKilledGoldenEnemies		; $45d0
	bit 0,(hl)		; $45d3
	jp nz,enemyDelete		; $45d5
++
	; If bit 1 of subid is set, octorok is faster
	rrca			; $45d8
	ld a,SPEED_80		; $45d9
	jr nc,+			; $45db
	ld a,SPEED_c0		; $45dd
+
	call _ecom_setSpeedAndState8AndVisible		; $45df
	ld (hl),$0a ; [state] = $0a

	; Enable moving toward scent seeds
	ld l,Enemy.var3f		; $45e4
	set 4,(hl)		; $45e6

	; Determine range of possible counter1 values, read into 'e' and 'var32'.
	ld e,Enemy.subid		; $45e8
	ld a,(de)		; $45ea
	ld hl,@counter1Ranges		; $45eb
	rst_addAToHl			; $45ee
	ld e,Enemy.var32		; $45ef
	ld a,(hl)		; $45f1
	ld (de),a		; $45f2

	; Decide random counter1, angle, and var30.
	ld e,a			; $45f3
	ldbc $18,$03		; $45f4
	call _ecom_randomBitwiseAndBCE		; $45f7
	ld a,e			; $45fa
	ld hl,_octorok_counter1Values		; $45fb
	rst_addAToHl			; $45fe
	ld e,Enemy.counter1		; $45ff
	ld a,(hl)		; $4601
	ld (de),a		; $4602

	; Random initial angle
	ld e,Enemy.angle		; $4603
	ld a,b			; $4605
	ld (de),a		; $4606

	ld a,c			; $4607
	ld hl,_octorok_walkCounterValues		; $4608
	rst_addAToHl			; $460b
	ld e,Enemy.var30		; $460c
	ld a,(hl)		; $460e
	ld (de),a		; $460f
	jp _ecom_updateAnimationFromAngle		; $4610


; For each subid, each byte determines the maximum index of the value that can be read
; from "_octorok_counter1Values" below. Effectively, lower values attack more often.
@counter1Ranges:
	.db $07 $07 $03 $03 $01


_octorok_state_followingScentSeed:
	ld a,(wScentSeedActive)	; $4618
	or a			; $461b
	jr nz,++		; $461c
	ld a,$08		; $461e
	ld (de),a ; [state] = 8
	ret			; $4621
++
	; Set angle toward scent seed (must be cardinal direction)
	call _ecom_updateAngleToScentSeed		; $4622
	ld e,Enemy.angle		; $4625
	ld a,(de)		; $4627
	add $04			; $4628
	and $18			; $462a
	ld (de),a		; $462c

	call _ecom_updateAnimationFromAngle		; $462d
	call _ecom_applyVelocityForTopDownEnemy		; $4630
	jp enemyAnimate		; $4633


_octorok_state_latchedBySwitchHook:
	inc e			; $4636
	ld a,(de)		; $4637
	rst_jumpTable			; $4638
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw _ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret			; $4641

_octorok_state_stub:
	ret			; $4642


; State 8: Octorok decides what to do next after previous action
_octorok_state_08:
	; Decide whether to move or shoot based on [var32] & [random number]. If var32 is
	; low, this means it will shoot more often.
	call getRandomNumber_noPreserveVars		; $4643
	ld h,d			; $4646
	ld l,Enemy.var32		; $4647
	and (hl)		; $4649
	ld l,Enemy.state		; $464a
	jr nz,@standStill	; $464c

	; Shoot a projectile after [counter1] frames
	ld (hl),$0b ; [state] = $0b
	ld l,Enemy.counter1		; $4650
	ld (hl),$10		; $4652

	; Blue and golden octoroks change direction to face Link before shooting
	ld l,Enemy.subid		; $4654
	ld a,(hl)		; $4656
	cp $02			; $4657
	ret c			; $4659
	call _ecom_updateCardinalAngleTowardTarget		; $465a
	jp _ecom_updateAnimationFromAngle		; $465d

@standStill:
	inc (hl) ; [state] = $09
	ld bc,_octorok_counter1Values		; $4661
	call addAToBc		; $4664
	ld l,Enemy.counter1		; $4667
	ld a,(bc)		; $4669
	ld (hl),a		; $466a
	ret			; $466b


; A random value for counter1 is chosen from here when the octorok changes direction?
; Red octoroks read the whole range, blue octoroks only the first 4, golden ones only the
; first 2.
; Effectively, blue & golden octoroks move more often.
_octorok_counter1Values:
	.db 30 45 60 75 45 60 75 90


; State 9: Standing still for [counter1] frames.
_octorok_state_09:
	call _ecom_decCounter1		; $4674
	ret nz			; $4677

	ld l,e			; $4678
	inc (hl) ; [state] = $0a (Walking)

	ld e,$03		; $467a
	ld bc,$0318		; $467c
	call _ecom_randomBitwiseAndBCE		; $467f

	; Randomly set how many frames to walk
	ld a,e			; $4682
	ld hl,_octorok_walkCounterValues		; $4683
	rst_addAToHl			; $4686
	ld a,(hl)		; $4687
	ld e,Enemy.var30		; $4688
	ld (de),a		; $468a

	; Set random angle
	ld e,Enemy.angle		; $468b
	ld a,c			; $468d
	ld (de),a		; $468e

	; 1 in 4 chance of changing direction toward Link (overriding previous angle)
	ld a,b			; $468f
	or a			; $4690
	call z,_ecom_updateCardinalAngleTowardTarget		; $4691
	jp _ecom_updateAnimationFromAngle		; $4694


; Values for var30 (how many frames to walk).
_octorok_walkCounterValues:
	.db $19 $21 $29 $31


; State $0a: Octorok is walking for [var30] frames.
_octorok_state_0a:
	ld h,d			; $469b
	ld l,Enemy.var30		; $469c
	dec (hl)		; $469e
	jr nz,++		; $469f

	ld l,e			; $46a1
	ld (hl),$08 ; [state] = $08
	ret			; $46a4
++
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $46a5
	jr nz,++		; $46a8

	; Stopped moving, set new angle
	call _ecom_setRandomCardinalAngle		; $46aa
	call _ecom_updateAnimationFromAngle		; $46ad
++
	jp enemyAnimate		; $46b0


; State $0b: Waiting [counter1] frames, then shooting a projectile
_octorok_state_0b:
	call _ecom_decCounter1		; $46b3
	ret nz			; $46b6

	ld (hl),$20 ; [counter1] = $20 (wait this many frames after shooting)
	ld l,e			; $46b9
	ld (hl),$09 ; [state] = $09

	ld b,PARTID_OCTOROK_PROJECTILE		; $46bc
	call _ecom_spawnProjectile		; $46be
	ret nz			; $46c1
	ld a,SND_THROW		; $46c2
	jp playSound		; $46c4


; ==============================================================================
; ENEMYID_BOOMERANG_MOBLIN
; ==============================================================================
enemyCode0a:
	call _ecom_checkHazards		; $46c7
	jr z,@normalStatus	; $46ca

	sub ENEMYSTATUS_NO_HEALTH			; $46cc
	ret c			; $46ce
	jr z,@dead	; $46cf
	dec a			; $46d1
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $46d2
	ret			; $46d5

@dead:
	ld e,Enemy.relatedObj2+1		; $46d6
	ld a,(de)		; $46d8
	or a			; $46d9
	jr z,++			; $46da
	ld h,a			; $46dc
	ld l,Part.relatedObj1+1		; $46dd
	ld (hl),$ff		; $46df
++
	jp enemyDie		; $46e1

@normalStatus:
	call _ecom_checkScentSeedActive		; $46e4
	ld e,Enemy.state		; $46e7
	ld a,(de)		; $46e9
	rst_jumpTable			; $46ea
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state_8
	.dw @state_9
	.dw @state_a


@state_uninitialized:
	ld a,SPEED_80		; $4701
	call _ecom_setSpeedAndState8AndVisible		; $4703
	ld l,Enemy.var3f		; $4706
	set 4,(hl)		; $4708
	jp @gotoState8WithRandomAngleAndCounter		; $470a


@state_scentSeed:
	ld a,(wScentSeedActive)		; $470d
	or a			; $4710
	jp z,@gotoState8WithRandomAngleAndCounter		; $4711

	call _ecom_updateAngleToScentSeed		; $4714
	ld e,Enemy.angle		; $4717
	ld a,(de)		; $4719
	add $04			; $471a
	and $18			; $471c
	ld (de),a		; $471e

	call _ecom_updateAnimationFromAngle		; $471f
	call _ecom_applyVelocityForSideviewEnemy		; $4722
	jp enemyAnimate		; $4725


@state_switchHook:
	inc e			; $4728
	ld a,(de)		; $4729
	rst_jumpTable			; $472a
	.dw _ecom_incState2
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret			; $4733

@@substate3:
	ld b,$0a		; $4734
	jp _ecom_fallToGroundAndSetState		; $4736

@state_stub:
	ret			; $4739


; Moving until counter1 reaches 0
@state_8:
	call _ecom_decCounter1		; $473a
	jr z,++		; $473d
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $473f
	jr nz,@animate	; $4742
++
	ld e,Enemy.state		; $4744
	ld a,$09		; $4746
	ld (de),a		; $4748
@animate:
	jp enemyAnimate		; $4749


; Shoot a boomerang if Link is in that general direction; otherwise go back to state 8.
@state_9:
	call @gotoState8WithRandomAngleAndCounter		; $474c
	call objectGetAngleTowardEnemyTarget		; $474f
	add $04			; $4752
	and $18			; $4754
	swap a			; $4756
	rlca			; $4758
	ld h,d			; $4759
	ld l,Enemy.direction		; $475a
	cp (hl)			; $475c
	ret nz			; $475d

	; Spawn projectile
	ld b,PARTID_MOBLIN_BOOMERANG		; $475e
	call _ecom_spawnProjectile		; $4760
	ret nz			; $4763
	ld h,d			; $4764
	ld l,Enemy.state		; $4765
	ld (hl),$0a		; $4767
	ret			; $4769


; Waiting for boomerang to return
@state_a:
	ld e,Enemy.relatedObj2+1		; $476a
	ld a,(de)		; $476c
	or a			; $476d
	jr nz,@animate	; $476e

@gotoState8WithRandomAngleAndCounter:
	call getRandomNumber_noPreserveVars		; $4770
	and $03			; $4773
	ld hl,@counterVals		; $4775
	rst_addAToHl			; $4778
	ld e,Enemy.counter1		; $4779
	ld a,(hl)		; $477b
	ld (de),a		; $477c
	ld e,Enemy.state		; $477d
	ld a,$08		; $477f
	ld (de),a		; $4781
	call _ecom_setRandomCardinalAngle		; $4782
	jp _ecom_updateAnimationFromAngle		; $4785

@counterVals:
	.db $30 $40 $50 $60


; ==============================================================================
; ENEMYID_LEEVER
; ==============================================================================
enemyCode0b:
	call _ecom_checkHazards		; $478c
	jr z,@normalStatus	; $478f
	sub $03			; $4791
	ret c			; $4793
	jr z,@dead	; $4794
	dec a			; $4796
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4797
	ret			; $479a

@dead:
	ld e,Enemy.subid		; $479b
	ld a,(de)		; $479d
	cp $02			; $479e
	jr nz,@die	; $47a0

	; This is a respawning leever (subid 2), so spawn a new one
	ld b,ENEMYID_LEEVER		; $47a2
	call _ecom_spawnEnemyWithSubid01		; $47a4
	ret nz			; $47a7

	inc (hl) ; [child.subid] = 2

	; Set Y/X
	ld e,Enemy.var30		; $47a9
	ld l,Enemy.yh		; $47ab
	ld a,(de)		; $47ad
	ldi (hl),a		; $47ae
	inc e			; $47af
	inc l			; $47b0
	ld a,(de)		; $47b1
	ld (hl),a		; $47b2
@die:
	jp enemyDie		; $47b3

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $47b6
	jr nc,@normalState	; $47b9
	rst_jumpTable			; $47bb
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub


@normalState:
	ld a,b			; $47cc
	rst_jumpTable			; $47cd
	.dw @normalState_subid00
	.dw @normalState_subid01
	.dw @normalState_subid02


@state_uninitialized:
	call @setRandomCounter1		; $47d4
	jp _ecom_setSpeedAndState8		; $47d7


@state_switchHook:
	inc e			; $47da
	ld a,(de)		; $47db
	rst_jumpTable			; $47dc
	.dw _ecom_incState2
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret			; $47e5

@@substate3:
	ld e,Enemy.subid		; $47e6
	ld a,(de)		; $47e8
	ld hl,@@destStates		; $47e9
	rst_addAToHl			; $47ec
	ld b,(hl)		; $47ed
	jp _ecom_fallToGroundAndSetState		; $47ee

@@destStates:
	.db $0a $0a $0a


@state_stub:
	ret			; $47f4


@normalState_subid00:
	ld a,(de)		; $47f5
	sub $08			; $47f6
	rst_jumpTable			; $47f8
	.dw @state8
	.dw @state9
	.dw @subid00_stateA
	.dw @stateB


; Underground until counter1 reaches 0.
@state8:
	call _ecom_decCounter1		; $4801
	ret nz			; $4804
	inc (hl)		; $4805

	call @chooseSpawnPosition		; $4806
	ret nz			; $4809
	call objectSetShortPosition		; $480a
	ld l,Enemy.state		; $480d
	inc (hl) ; [state] = 9
	xor a			; $4810
	call enemySetAnimation		; $4811
	jp objectSetVisiblec2		; $4814


; Emerging from the ground.
@state9:
	ld h,d			; $4817
	ld l,Enemy.animParameter		; $4818
	ld a,(hl)		; $481a
	dec a			; $481b
	jr nz,@animate		; $481c

	; [animParameter] == 1; fully emerged.
	ld l,e			; $481e
	inc (hl)		; $481f
	ld l,Enemy.collisionType		; $4820
	set 7,(hl)		; $4822

	ld l,Enemy.speed		; $4824
	ld (hl),SPEED_80		; $4826
	call _ecom_updateCardinalAngleTowardTarget		; $4828
	call @setRandomHighCounter1		; $482b
@animate:
	jp enemyAnimate		; $482e


; Chasing Link.
@subid00_stateA:
	call _ecom_decCounter1		; $4831
	jp nz,@updatePosition		; $4834

@backIntoGround:
	call _ecom_incState
	ld l,Enemy.collisionType		; $483a
	res 7,(hl)		; $483c
	ld l,Enemy.speed		; $483e
	ld (hl),SPEED_20		; $4840
	ld a,$02		; $4842
	jp enemySetAnimation		; $4844


; Sinking back into the ground.
@stateB:
	ld h,d			; $4847
	ld l,Enemy.animParameter		; $4848
	ld a,(hl)		; $484a
	dec a			; $484b
	jr nz,@animate	; $484c

	; [animParameter] == 1: Fully disappeared.
	ld l,e			; $484e
	ld (hl),$08		; $484f
	call @setRandomCounter1		; $4851
	jp objectSetInvisible		; $4854


@normalState_subid01:
	ld a,(de)		; $4857
	sub $08			; $4858
	rst_jumpTable			; $485a
	.dw @state8
	.dw @state9
	.dw @subid01_stateA
	.dw @stateB


; Chasing Link.
; (Same as subid 0's state A, except this sometimes "snaps" its angle back to Link
; immediately, making it more responsive?)
@subid01_stateA:
	call _ecom_decCounter1		; $4863
	jp z,@backIntoGround		; $4866
	call getRandomNumber_noPreserveVars		; $4869
	cp $14			; $486c
	jp nc,@updatePosition		; $486e
	call _ecom_updateCardinalAngleTowardTarget		; $4871
	jp @updatePosition		; $4874


; Respawning leever
@normalState_subid02:
	ld a,(de)		; $4877
	sub $08			; $4878
	rst_jumpTable			; $487a
	.dw @subid02_state8
	.dw @subid02_state9
	.dw @subid02_stateA
	.dw @subid02_stateB
	.dw @subid02_stateC

@subid02_state8:
	ld h,d			; $4885
	ld l,e			; $4886
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1		; $4888
	ld a,(hl)		; $488a
	and $30			; $488b
	add $60			; $488d
	ld (hl),a		; $488f

	; Save initial position to var30/var31 so it can be restored when respawning.
	ld e,Enemy.yh		; $4890
	ld l,Enemy.var30		; $4892
	ld a,(de)		; $4894
	ldi (hl),a		; $4895
	ld e,Enemy.xh		; $4896
	ld a,(de)		; $4898
	ld (hl),a		; $4899
	ret			; $489a

; In ground, waiting until time to spawn.
@subid02_state9:
	call _ecom_decCounter1		; $489b
	ret nz			; $489e
	inc l			; $489f
	ld (hl),$06 ; [counter2] = 6
	ld l,e			; $48a2
	inc (hl) ; [state] = $0a
	xor a			; $48a4
	call enemySetAnimation		; $48a5
	jp objectSetVisiblec2		; $48a8


; Emerging from ground.
@subid02_stateA:
	ld e,Enemy.animParameter		; $48ab
	ld a,(de)		; $48ad
	dec a			; $48ae
	jr nz,@animate2	; $48af

	; [animParameter] == 1; fully emerged.

	ld h,d			; $48b1
	ld l,Enemy.state		; $48b2
	inc (hl) ; [state] = $0b

	ld l,Enemy.collisionType		; $48b5
	set 7,(hl)		; $48b7

	ld l,Enemy.speed		; $48b9
	ld (hl),SPEED_a0		; $48bb
	call _ecom_updateCardinalAngleTowardTarget		; $48bd
	call @setRandomHighCounter1		; $48c0
	jr @animate2		; $48c3


; Chasing Link. Unlike other leever types, if this hits a wall, it doesn't sink back into
; the ground until its timer is up.
@subid02_stateB:
	call _ecom_decCounter1		; $48c5
	jp z,@backIntoGround		; $48c8
	call @nudgeTowardsLink		; $48cb
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $48ce
@animate2:
	jp enemyAnimate		; $48d1


; Sinking back into ground.
@subid02_stateC:
	ld e,Enemy.animParameter		; $48d4
	ld a,(de)		; $48d6
	dec a			; $48d7
	jr nz,@animate2	; $48d8

	; [animParameter] == 1; fully disappeared.

	ld e,Enemy.state		; $48da
	ld a,$09		; $48dc
	ld (de),a		; $48de
	call @setRandomCounter1		; $48df
	jp objectSetInvisible		; $48e2


;;
; Updates position, checks for collision with wall (or hole).
; @addr{48e5}
@updatePosition:
	ld a,$01 ; Set to $01 to treat holes as walls
	call _ecom_getTopDownAdjacentWallsBitset		; $48e7
	jp nz,@backIntoGround		; $48ea
	call objectApplySpeed		; $48ed
	jp enemyAnimate		; $48f0

;;
; @param	b	Subid. if 0, it spawns relative to Link's position & direction;
;			otherwise it spawns in a completely random position.
; @param[out]	c	Position
; @param[out]	zflag	z if a valid position was returned
; @addr{48f3}
@chooseSpawnPosition:
	ld a,b			; $48f3
	or a			; $48f4
	jr nz,@@chooseRandomSpot	; $48f5

	; Spawn in relative to Link's position.

	ld de,w1Link.yh		; $48f7
	call getShortPositionFromDE		; $48fa
	ld c,a			; $48fd
	ld e,<w1Link.direction		; $48fe
	ld a,(de)		; $4900
	rlca			; $4901
	rlca			; $4902
	ld hl,@@linkRelativeOffsets		; $4903
	rst_addAToHl			; $4906
	ld a,(wFrameCounter)		; $4907
	and $03			; $490a
	rst_addAToHl			; $490c
	ldh a,(<hActiveObject)	; $490d
	ld d,a			; $490f
	ld a,c			; $4910
	add (hl)		; $4911
	ld c,a			; $4912

	; We have a candidate position; check for validity. NOTE: Assumes small room.
	and $f0			; $4913
	cp SMALL_ROOM_HEIGHT<<4			; $4915
	jr nc,@@invalid		; $4917
	ld a,c			; $4919
	and $0f			; $491a
	cp SMALL_ROOM_WIDTH			; $491c
	jr nc,@@invalid		; $491e

	ld b,>wRoomCollisions		; $4920
	ld a,(bc)		; $4922
	or a			; $4923
	ret			; $4924

@@invalid:
	or d			; $4925
	ret			; $4926

; Each of Link's directions has 4 candidates, one is chosen randomly.
@@linkRelativeOffsets:
	.db $d0 $c0 $b0 $b0 ; DIR_UP
	.db $03 $04 $05 $05 ; DIR_RIGHT
	.db $30 $40 $50 $50 ; DIR_DOWN
	.db $fd $fc $fb $fb ; DIR_LEFT

@@chooseRandomSpot:
	call getRandomNumber_noPreserveVars		; $4937
	and $77			; $493a
	ld c,a			; $493c
	ld b,>wRoomCollisions		; $493d
	ld a,(bc)		; $493f
	or a			; $4940
	ret			; $4941


@setRandomCounter1:
	call getRandomNumber_noPreserveVars		; $4942
	and $03			; $4945
	ld hl,@counter1Vals		; $4947
	rst_addAToHl			; $494a
	ld e,Enemy.counter1		; $494b
	ld a,(hl)		; $494d
	ld (de),a		; $494e
	ret			; $494f

@counter1Vals:
	.db $10 $30 $50 $70

@setRandomHighCounter1:
	call getRandomNumber_noPreserveVars		; $4954
	ld e,Enemy.counter1		; $4957
	and $38			; $4959
	add $70			; $495b
	ld (de),a		; $495d
	ret			; $495e

@nudgeTowardsLink:
	call _ecom_decCounter2		; $495f
	ret nz			; $4962
	ld (hl),$06		; $4963
	call objectGetAngleTowardEnemyTarget		; $4965
	jp objectNudgeAngleTowards		; $4968


; ==============================================================================
; ENEMYID_ARROW_MOBLIN
; ENEMYID_MASKED_MOBLIN
; ENEMYID_ARROW_SHROUDED_STALFOS
;
; These enemies and ENEMYID_ARROW_DARKNUT share some code.
; ==============================================================================
enemyCode0c:
enemyCode20:
enemyCode22:
	call _ecom_checkHazards		; $496b
	jr z,@normalStatus	; $496e

	sub ENEMYSTATUS_NO_HEALTH			; $4970
	ret c			; $4972
	jr z,@dead	; $4973
	dec a			; $4975
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4976
	ret			; $4979
@dead:
	ld e,Enemy.subid		; $497a
	ld a,(de)		; $497c
	cp $02			; $497d
	jr nz,++		; $497f
	ld hl,wKilledGoldenEnemies		; $4981
	set 1,(hl)		; $4984
++
	jp enemyDie		; $4986

@normalStatus:
	call _ecom_checkScentSeedActive		; $4989
	ld e,Enemy.state		; $498c
	ld a,(de)		; $498e
	rst_jumpTable			; $498f
	.dw _moblin_state_uninitialized
	.dw _moblin_state_stub
	.dw _moblin_state_stub
	.dw _moblin_state_switchHook
	.dw _moblin_state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _moblin_state_stub
	.dw _moblin_state_stub
	.dw _moblin_state_8
	.dw _moblin_state_9


_moblin_state_uninitialized:
	; Enable chasing scent seeds
	ld h,d			; $49a4
	ld l,Enemy.var3f		; $49a5
	set 4,(hl)		; $49a7

	ld l,Enemy.subid		; $49a9
	bit 1,(hl)		; $49ab
	jr z,++			; $49ad
	ld a,(wKilledGoldenEnemies)		; $49af
	bit 1,a			; $49b2
	jp nz,enemyDelete		; $49b4
++
	jp _arrowDarknut_state_uninitialized		; $49b7


_moblin_state_scentSeed:
	ld a,(wScentSeedActive)		; $49ba
	or a			; $49bd
	jp z,_arrowDarknut_setState8WithRandomAngleAndCounter		; $49be

	call _ecom_updateAngleToScentSeed		; $49c1
	ld e,Enemy.angle		; $49c4
	ld a,(de)		; $49c6
	add $04			; $49c7
	and $18			; $49c9
	ld (de),a		; $49cb
	call _ecom_updateAnimationFromAngle		; $49cc
	call _ecom_applyVelocityForSideviewEnemy		; $49cf
	jp enemyAnimate		; $49d2


; Also used by darknuts
_moblin_state_switchHook:
	inc e			; $49d5
	ld a,(de)		; $49d6
	rst_jumpTable			; $49d7
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw _ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret			; $49e0


_moblin_state_stub:
	ret			; $49e1


; Also darknut state 8 (moving in some direction)
_moblin_state_8:
	call _ecom_decCounter1		; $49e2
	jr z,+			; $49e5
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $49e7
	jr nz,++		; $49ea
+
	call _ecom_incState		; $49ec
	ld l,Enemy.counter1		; $49ef
	ld (hl),$08		; $49f1
++
	jp enemyAnimate		; $49f3


; Standing until counter1 reaches 0 and a new direction is decided on.
_moblin_state_9:
	call _ecom_decCounter1		; $49f6
	ret nz			; $49f9
	call _ecom_setRandomCardinalAngle		; $49fa
	call _arrowDarknut_setState8WithRandomAngleAndCounter		; $49fd
	jr _arrowDarknut_fireArrowEveryOtherTime		; $4a00


; ==============================================================================
; ENEMYID_ARROW_DARKNUT
; ==============================================================================
enemyCode21:
.ifdef ROM_AGES
	call _ecom_checkHazards		; $4a02
.else
	call _ecom_seasonsFunc_4446
.endif
	jr z,@normalStatus	; $4a05
	sub ENEMYSTATUS_NO_HEALTH			; $4a07
	ret c			; $4a09
	jp z,enemyDie		; $4a0a
	dec a			; $4a0d
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4a0e
	ret			; $4a11

@normalStatus:
	ld e,Enemy.state		; $4a12
	ld a,(de)		; $4a14
	rst_jumpTable			; $4a15
	.dw _arrowDarknut_state_uninitialized
	.dw _moblin_state_stub
	.dw _moblin_state_stub
	.dw _moblin_state_switchHook
	.dw _moblin_state_stub
	.dw _moblin_state_stub
	.dw _moblin_state_stub
	.dw _moblin_state_stub
	.dw _moblin_state_8
	.dw _arrowDarknut_state_9


; Also used by moblins
_arrowDarknut_state_uninitialized:
	ld e,Enemy.speed		; $4a2a
	ld a,SPEED_80		; $4a2c
	ld (de),a		; $4a2e
	call _ecom_setRandomCardinalAngle		; $4a2f
	call _arrowDarknut_setState8WithRandomAngleAndCounter		; $4a32
	jp objectSetVisiblec2		; $4a35


_arrowDarknut_state_9:
	call _ecom_decCounter1		; $4a38
	ret nz			; $4a3b
	call _arrowDarknut_chooseAngle		; $4a3c
	call _arrowDarknut_setState8WithRandomAngleAndCounter		; $4a3f

; This is also used by moblin's state 9.
; Every other time they move, if they're facing Link, fire an arrow.
_arrowDarknut_fireArrowEveryOtherTime:
	ld h,d			; $4a42
	ld l,Enemy.var30		; $4a43
	inc (hl)		; $4a45
	bit 0,(hl)		; $4a46
	ret z			; $4a48
	call objectGetAngleTowardEnemyTarget		; $4a49
	add $04			; $4a4c
	and $18			; $4a4e
	ld h,d			; $4a50
	ld l,Enemy.angle		; $4a51
	cp (hl)			; $4a53
	ret nz			; $4a54
	ld b,PARTID_ENEMY_ARROW		; $4a55
	jp _ecom_spawnProjectile		; $4a57


;;
; Sets random angle and counter, and goes to state 8.
; @addr{4a5a}
_arrowDarknut_setState8WithRandomAngleAndCounter:
	call getRandomNumber_noPreserveVars		; $4a5a
	and $3f			; $4a5d
	add $30			; $4a5f
	ld h,d			; $4a61
	ld l,Enemy.counter1		; $4a62
	ld (hl),a		; $4a64
	ld l,Enemy.state		; $4a65
	ld (hl),$08		; $4a67
	jp _ecom_updateAnimationFromAngle		; $4a69

;;
; 1-in-4 chance of turning to face Link directly, otherwise turns in a random direction.
; @addr{4a6c}
_arrowDarknut_chooseAngle:
	call getRandomNumber_noPreserveVars		; $4a6c
	and $03			; $4a6f
	jp z,_ecom_updateCardinalAngleTowardTarget		; $4a71
	jp _ecom_setRandomCardinalAngle		; $4a74


; ==============================================================================
; ENEMYID_LYNEL
;
; Variables:
;   var30: Determines probability that the Lynel turns toward Link whenever it turns (less
;          bits set = more likely).
; ==============================================================================
enemyCode0d:
	call _ecom_checkHazards		; $4a77
	jr z,@normalStatus	; $4a7a
	sub ENEMYSTATUS_NO_HEALTH			; $4a7c
	ret c			; $4a7e
	jr z,@dead		; $4a7f
	dec a			; $4a81
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4a82
	ret			; $4a85

@dead:
	ld e,Enemy.subid		; $4a86
	ld a,(de)		; $4a88
	cp $02			; $4a89
	jr nz,++		; $4a8b
	ld hl,wKilledGoldenEnemies		; $4a8d
	set 3,(hl)		; $4a90
++
	jp enemyDie		; $4a92

@normalStatus:
	call _ecom_checkScentSeedActive		; $4a95
	jr z,++			; $4a98
	ld e,Enemy.speed		; $4a9a
	ld a,SPEED_100		; $4a9c
	ld (de),a		; $4a9e
++
	ld e,Enemy.state		; $4a9f
	ld a,(de)		; $4aa1
	rst_jumpTable			; $4aa2
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_scentSeed
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_08
	.dw @state_09
	.dw @state_0a


@state_uninitialized:
	ld e,Enemy.subid		; $4ab9
	ld a,(de)		; $4abb
	cp $02			; $4abc
	jr nz,++		; $4abe
	ld hl,wKilledGoldenEnemies		; $4ac0
	bit 3,(hl)		; $4ac3
	jp nz,enemyDelete		; $4ac5
++
	ld e,Enemy.subid		; $4ac8
	ld a,(de)		; $4aca
	ld hl,@var30Vals		; $4acb
	rst_addAToHl			; $4ace
	ld e,Enemy.var30		; $4acf
	ld a,(hl)		; $4ad1
	ld (de),a		; $4ad2

	call objectSetVisiblec2		; $4ad3
	call getRandomNumber_noPreserveVars		; $4ad6
	and $30			; $4ad9
	ld c,a			; $4adb
	ld h,d			; $4adc

	; Enable scent seed effect
	ld l,Enemy.var3f		; $4add
	set 4,(hl)		; $4adf

	ld l,Enemy.state		; $4ae1
	jp @changeDirection		; $4ae3

@var30Vals:
	.db $07 $03 $01


@state_scentSeed:
	ld a,(wScentSeedActive)		; $4ae9
	or a			; $4aec
	jp z,@gotoState8		; $4aed
	call _ecom_updateAngleToScentSeed		; $4af0
	ld e,Enemy.angle		; $4af3
	ld a,(de)		; $4af5
	add $04			; $4af6
	and $18			; $4af8
	ld (de),a		; $4afa
	ld b,$04		; $4afb
	call @updateAnimationFromAngle		; $4afd
	call _ecom_applyVelocityForSideviewEnemy		; $4b00
	jp enemyAnimate		; $4b03

@state_stub:
	ret			; $4b06


; Choose whether to walk around some more, or fire a projectile.
@state_08:
	ld e,Enemy.var30		; $4b07
	ld a,(de)		; $4b09
	ld b,a			; $4b0a
	ld c,$30		; $4b0b
	call _ecom_randomBitwiseAndBCE		; $4b0d
	or b			; $4b10
	ld h,d			; $4b11
	ld l,Enemy.state		; $4b12
	jr z,@prepareProjectile	; $4b14

@changeDirection:
	ld (hl),$09 ; [state] = $09
	ld l,Enemy.counter1		; $4b18
	ld a,$30		; $4b1a
	add c			; $4b1c
	ld (hl),a		; $4b1d
	jr @updateAngleAndSpeed		; $4b1e

@prepareProjectile:
	ld (hl),$0a ; [state] = $0a
	ld l,Enemy.counter1		; $4b22
	ld (hl),$08		; $4b24
	call _ecom_updateCardinalAngleTowardTarget		; $4b26
	jp _ecom_updateAnimationFromAngle		; $4b29


; Moving until counter1 reaches 0, then return to state 8
@state_09:
	call _ecom_decCounter1		; $4b2c
	jr z,@gotoState8	; $4b2f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4b31
	jr z,@updateAngleAndSpeed	; $4b34
@animate:
	jp enemyAnimate		; $4b36


; Standing for a moment before firing projectile
@state_0a:
	call _ecom_decCounter1		; $4b39
	jr nz,@animate	; $4b3c
	ld b,PARTID_LYNEL_BEAM		; $4b3e
	call _ecom_spawnProjectile		; $4b40
	jr nz,@gotoState8	; $4b43

	call getRandomNumber_noPreserveVars		; $4b45
	and $30			; $4b48
	add $30			; $4b4a
	ld e,Enemy.counter1		; $4b4c
	ld (de),a		; $4b4e

	ld h,d			; $4b4f
	ld l,Enemy.speed		; $4b50
	ld (hl),SPEED_80		; $4b52

	ld l,Enemy.state		; $4b54
	ld (hl),$09		; $4b56
	jr @animate		; $4b58

@gotoState8:
	ld e,Enemy.state		; $4b5a
	ld a,$08		; $4b5c
	ld (de),a		; $4b5e
	jr @animate		; $4b5f

;;
; The lynel turns, and if Link is in its sights, it charges.
; @addr{4b61}
@updateAngleAndSpeed:
	call @chooseNewAngle		; $4b61
	ld b,$0e		; $4b64
	call objectCheckCenteredWithLink		; $4b66
	jr nc,++		; $4b69

	call objectGetAngleTowardEnemyTarget		; $4b6b
	add $04			; $4b6e
	and $18			; $4b70
	ld h,d			; $4b72
	ld l,Enemy.angle		; $4b73
	cp (hl)			; $4b75
	ld a,SPEED_100		; $4b76
	ld b,$04		; $4b78
	jr z,+++			; $4b7a
++
	ld a,SPEED_80		; $4b7c
	ld b,$00		; $4b7e
+++
	ld l,Enemy.speed		; $4b80
	ld (hl),a		; $4b82

;;
; @param	b	0 if walking, 4 if running (value to add to animation)
; @addr{4b83}
@updateAnimationFromAngle:
	ld h,d			; $4b83
	ld l,Enemy.angle		; $4b84
	ldd a,(hl)		; $4b86
	swap a			; $4b87
	rlca			; $4b89
	add b			; $4b8a
	cp (hl)			; $4b8b
	ret z			; $4b8c
	ld (hl),a		; $4b8d
	jp enemySetAnimation		; $4b8e

;;
; Chooses a new angle; var30 sets the probability that it will turn to face Link instead
; of just a random direction.
; @addr{4b91}
@chooseNewAngle:
	call getRandomNumber_noPreserveVars		; $4b91
	ld h,d			; $4b94
	ld l,Enemy.var30		; $4b95
	and (hl)		; $4b97
	jp nz,_ecom_setRandomCardinalAngle		; $4b98
	jp _ecom_updateCardinalAngleTowardTarget		; $4b9b


; ==============================================================================
; ENEMYID_BLADE_TRAP
; ENEMYID_FLAME_TRAP
;
; Variables for normal traps:
;   var30: Speed
;
; Variables for circular traps:
;   var30: Center Y for circular traps
;   var31: Center X for circular traps
;   var32: Radius of circle for circular traps
; ==============================================================================
enemyCode0e:
.ifdef ROM_SEASONS
enemyCode2b:
.endif
	dec a			; $4b9e
	ret z			; $4b9f
	dec a			; $4ba0
	ret z			; $4ba1
	call enemyAnimate		; $4ba2
	call _ecom_getSubidAndCpStateTo08		; $4ba5
	jr nc,@normalState	; $4ba8
	rst_jumpTable			; $4baa
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub

@normalState:
	ld a,b			; $4bbb
	rst_jumpTable			; $4bbc
	.dw _bladeTrap_subid00
	.dw _bladeTrap_subid01
	.dw _bladeTrap_subid02
	.dw _bladeTrap_subid03
	.dw _bladeTrap_subid04
	.dw _bladeTrap_subid05


@state_uninitialized:
	ld a,b			; $4bc9
	sub $03			; $4bca
	cp $02			; $4bcc
	call c,_bladeTrap_initCircular		; $4bce

	; Set different animation and var3e value for the spinning trap
	ld e,Enemy.subid		; $4bd1
	ld a,(de)		; $4bd3
	or a			; $4bd4
	ld a,$08		; $4bd5
	jr nz,++		; $4bd7

	ld a,$01		; $4bd9
	call enemySetAnimation		; $4bdb
	ld a,$01		; $4bde
++
	ld e,Enemy.var3e		; $4be0
	ld (de),a		; $4be2
	jp _ecom_setSpeedAndState8AndVisible		; $4be3

@state_stub:
	ret			; $4be6


; Red, spinning trap
_bladeTrap_subid00:
	ld a,(de)		; $4be7
	sub $08			; $4be8
	rst_jumpTable			; $4bea
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


; Initialization
@state8:
	ld h,d			; $4bf3
	ld l,e			; $4bf4
	inc (hl)		; $4bf5
	ld l,Enemy.speed		; $4bf6
	ld (hl),SPEED_c0		; $4bf8
	ld a,$01		; $4bfa
	jp enemySetAnimation		; $4bfc


; Waiting for Link to walk into range
@state9:
	ld b,$0e		; $4bff
	call _bladeTrap_checkLinkAligned		; $4c01
	ret nc			; $4c04
	call _bladeTrap_checkObstructionsToTarget		; $4c05
	ret nz			; $4c08

	ld h,d			; $4c09
	ld l,Enemy.state		; $4c0a
	ld (hl),$0a		; $4c0c

	ld l,Enemy.counter1		; $4c0e
	ld (hl),$18		; $4c10

	ld a,SND_MOVEBLOCK		; $4c12
	call playSound		; $4c14

	ld a,$02		; $4c17
	jp enemySetAnimation		; $4c19


; Moving toward Link (half-speed, just starting up)
@stateA:
	ld e,Enemy.counter1		; $4c1c
	ld a,(de)		; $4c1e
	rrca			; $4c1f
	call c,_ecom_applyVelocityForTopDownEnemyNoHoles		; $4c20
	call _ecom_decCounter1		; $4c23
	jr nz,@animate		; $4c26

	ld l,Enemy.state		; $4c28
	ld (hl),$0b		; $4c2a
@animate:
	jp enemyAnimate		; $4c2c


; Moving toward Link
@stateB:
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $4c2f
	jr nz,@animate	; $4c32

	; Hit wall
	ld e,Enemy.state		; $4c34
	ld a,$09		; $4c36
	ld (de),a		; $4c38
	ld a,$01		; $4c39
	jp enemySetAnimation		; $4c3b


; Blue, gold blade traps (reach exactly to the center of a large room, no further)
_bladeTrap_subid01:
_bladeTrap_subid02:
	ld a,(de)		; $4c3e
	sub $08			; $4c3f
	rst_jumpTable			; $4c41
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Initialization
@state8:
	ld h,d			; $4c4c
	ld l,e			; $4c4d
	inc (hl) ; [state] = 9

	ld l,Enemy.subid		; $4c4f
	ld a,(hl)		; $4c51
	dec a			; $4c52
	ld a,SPEED_180		; $4c53
	jr z,+		; $4c55
	ld a,SPEED_300		; $4c57
+
	ld l,Enemy.var30		; $4c59
	ld (hl),a		; $4c5b


; Waiting for Link to walk into range
@state9:
	ld b,$0d		; $4c5c
	call _bladeTrap_checkLinkAligned		; $4c5e
	ret nc			; $4c61
	call _bladeTrap_checkObstructionsToTarget		; $4c62
	ret nz			; $4c65

	ld a,$01		; $4c66
	call _ecom_getTopDownAdjacentWallsBitset		; $4c68
	ret nz			; $4c6b

	call _ecom_incState		; $4c6c

	ld e,Enemy.var30		; $4c6f
	ld l,Enemy.speed		; $4c71
	ld a,(de)		; $4c73
	ld (hl),a		; $4c74
	ld a,SND_UNKNOWN5		; $4c75
	jp playSound		; $4c77


; Moving
@stateA:
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $4c7a
	ld h,d			; $4c7d
	jr z,@beginRetracting	; $4c7e

	; Blade trap spans about half the size of a large room (which is different in
	ld l,Enemy.angle		; $4c80
	bit 3,(hl)		; $4c82
	ld b,(LARGE_ROOM_HEIGHT/2)<<4 + 8		; $4c84
	ld l,Enemy.yh		; $4c86
	jr z,++			; $4c88

	ld b,(LARGE_ROOM_WIDTH/2)<<4 + 8		; $4c8a
	ld l,Enemy.xh		; $4c8c
++
	ld a,(hl)		; $4c8e
	sub b			; $4c8f
	add $07			; $4c90
	cp $0f			; $4c92
	ret nc			; $4c94

@beginRetracting:
	ld l,Enemy.angle		; $4c95
	ld a,(hl)		; $4c97
	xor $10			; $4c98
	ld (hl),a		; $4c9a

	ld l,Enemy.speed		; $4c9b
	ld (hl),SPEED_c0		; $4c9d

	ld l,Enemy.state		; $4c9f
	inc (hl)		; $4ca1
	ld a,SND_CLINK		; $4ca2
	jp playSound		; $4ca4


; Retracting
@stateB:
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $4ca7
	ret nz			; $4caa
	call _ecom_incState		; $4cab
	ld l,Enemy.counter1		; $4cae
	ld (hl),$10		; $4cb0
	ret			; $4cb2


; Cooldown of 16 frames
@stateC:
	call _ecom_decCounter1		; $4cb3
	ret nz			; $4cb6
	ld l,Enemy.state		; $4cb7
	ld (hl),$09		; $4cb9
	ret			; $4cbb


; Circular blade traps (clockwise & counterclockwise, respectively)
_bladeTrap_subid03:
_bladeTrap_subid04:
	ld a,(de)		; $4cbc
	sub $08			; $4cbd
	rst_jumpTable			; $4cbf
	.dw @state8

@state8:
	ld a,(wFrameCounter)		; $4cc2
	and $01			; $4cc5
	call z,bladeTrap_updateAngle		; $4cc7

	; Update position
	ld h,d			; $4cca
	ld l,Enemy.var30		; $4ccb
	ldi a,(hl)		; $4ccd
	ld b,a			; $4cce
	ldi a,(hl)		; $4ccf
	ld c,a			; $4cd0
	ld a,(hl)		; $4cd1
	ld e,Enemy.angle		; $4cd2
	jp objectSetPositionInCircleArc		; $4cd4


; Unlimited range green blade
_bladeTrap_subid05:
	ld a,(de)		; $4cd7
	sub $08			; $4cd8
	rst_jumpTable			; $4cda
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Initialization
@state8:
	ld h,d			; $4ce5
	ld l,e			; $4ce6
	inc (hl)		; $4ce7
	ld l,Enemy.var30		; $4ce8
	ld (hl),SPEED_200		; $4cea


; Waiting for Link to walk into range
@state9:
	ld b,$0e		; $4cec
	call _bladeTrap_checkLinkAligned		; $4cee
	ret nc			; $4cf1
	call _bladeTrap_checkObstructionsToTarget		; $4cf2
	ret nz			; $4cf5

	ld a,$01		; $4cf6
	call _ecom_getTopDownAdjacentWallsBitset		; $4cf8
	ret nz			; $4cfb

	ld h,d			; $4cfc
	ld e,Enemy.var30		; $4cfd
	ld l,Enemy.speed		; $4cff
	ld a,(de)		; $4d01
	ld (hl),a		; $4d02

	ld l,Enemy.state		; $4d03
	inc (hl)		; $4d05
	ld a,SND_UNKNOWN5		; $4d06
	jp playSound		; $4d08


; Moving toward Link
@stateA:
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $4d0b
	ret nz			; $4d0e

	call _ecom_incState		; $4d0f
	ld l,Enemy.angle		; $4d12
	ld a,(hl)		; $4d14
	xor $10			; $4d15
	ld (hl),a		; $4d17
	ld l,Enemy.speed		; $4d18
	ld (hl),SPEED_100		; $4d1a
	ld a,SND_CLINK		; $4d1c
	jp playSound		; $4d1e


; Retracting
@stateB:
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $4d21
	ret nz			; $4d24
	call _ecom_incState		; $4d25
	ld l,Enemy.counter1		; $4d28
	ld (hl),$10		; $4d2a
	ret			; $4d2c


; Cooldown of 16 frames
@stateC:
	call _ecom_decCounter1		; $4d2d
	ret nz			; $4d30
	ld l,Enemy.state		; $4d31
	ld (hl),$09		; $4d33
	ret			; $4d35

;;
; Only for subids 3-4 (circular traps)
; @addr{4d36}
bladeTrap_updateAngle:
	ld e,Enemy.subid		; $4d36
	ld a,(de)		; $4d38
	cp $03			; $4d39
	ld e,Enemy.angle		; $4d3b
	jp nz,_bladeTrap_decAngle		; $4d3d
	jp _bladeTrap_incAngle		; $4d40

;;
; @addr{4d43}
_bladeTrap_initCircular:
	call getRandomNumber_noPreserveVars		; $4d43
	and $1f			; $4d46
	ld e,Enemy.angle		; $4d48
	ld (de),a		; $4d4a

	ld e,Enemy.yh		; $4d4b
	ld a,(de)		; $4d4d
	ld c,a			; $4d4e
	and $f0			; $4d4f
	add $08			; $4d51
	ld e,Enemy.var30		; $4d53
	ld (de),a		; $4d55
	ld b,a			; $4d56

	ld a,c			; $4d57
	and $0f			; $4d58
	swap a			; $4d5a
	add $08			; $4d5c
	ld e,Enemy.var31		; $4d5e
	ld (de),a		; $4d60
	ld c,a			; $4d61

	ld e,Enemy.xh		; $4d62
	ld a,(de)		; $4d64
	ld e,Enemy.var32		; $4d65
	ld (de),a		; $4d67

	ld e,Enemy.angle		; $4d68
	jp objectSetPositionInCircleArc		; $4d6a


; Position offset to add when checking each successive tile between the trap and the
; target for solidity
_bladeTrap_directionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @param[out]	zflag	z if there are no obstructions (solid tiles) between trap and
;			target
; @addr{4d75}
_bladeTrap_checkObstructionsToTarget:
	ld h,d			; $4d75
	ld l,Enemy.yh		; $4d76
	ld b,(hl)		; $4d78
	ld l,Enemy.xh		; $4d79
	ld c,(hl)		; $4d7b
	ldh a,(<hEnemyTargetX)	; $4d7c
	sub c			; $4d7e
	add $04			; $4d7f
	cp $09			; $4d81
	jr nc,++		; $4d83

	ldh a,(<hEnemyTargetY)	; $4d85
	sub b			; $4d87
	add $04			; $4d88
	cp $09			; $4d8a
	ret c			; $4d8c
++
	ld l,Enemy.angle		; $4d8d
	call @getNumTilesToTarget		; $4d8f

	; Get direction offset in hl
	ld a,(hl)		; $4d92
	rrca			; $4d93
	rrca			; $4d94
	ld hl,_bladeTrap_directionOffsets		; $4d95
	rst_addAToHl			; $4d98
	ldi a,(hl)		; $4d99
	ld l,(hl)		; $4d9a
	ld h,a			; $4d9b

	; Check each tile between the trap and the target for solidity
	push de			; $4d9c
	ld d,>wRoomCollisions		; $4d9d
--
	call @checkNextTileSolid		; $4d9f
	jr nz,++		; $4da2
	ldh a,(<hFF8B)	; $4da4
	dec a			; $4da6
	ldh (<hFF8B),a	; $4da7
	jr nz,--		; $4da9
++
	pop de			; $4dab
	ret			; $4dac

;;
; @param	bc	Tile we're at right now
; @param	d	>wRoomCollisions
; @param	hl	Value to add to bc each time (direction offset)
; @param[out]	zflag	nz if tile is solid
; @addr{4dad}
@checkNextTileSolid:
	ld a,b			; $4dad
	add h			; $4dae
	ld b,a			; $4daf
	and $f0			; $4db0
	ld e,a			; $4db2
	ld a,c			; $4db3
	add l			; $4db4
	ld c,a			; $4db5
	and $f0			; $4db6
	swap a			; $4db8
	or e			; $4dba
	ld e,a			; $4dbb
	ld a,(de)		; $4dbc
	or a			; $4dbd
	ret			; $4dbe

;;
; @param	bc	Enemy position
; @param	hl	Enemy angle
; @param[out]	hFF8B	Number of tiles between enemy and target
; @addr{4dbf}
@getNumTilesToTarget:
	ld e,b			; $4dbf
	ldh a,(<hEnemyTargetY)	; $4dc0
	bit 3,(hl)		; $4dc2
	jr z,+			; $4dc4
	ld e,c			; $4dc6
	ldh a,(<hEnemyTargetX)	; $4dc7
+
	sub e			; $4dc9
	jr nc,+			; $4dca
	cpl			; $4dcc
	inc a			; $4dcd
+
	swap a			; $4dce
	and $0f			; $4dd0
	jr nz,+			; $4dd2
	inc a			; $4dd4
+
	ldh (<hFF8B),a	; $4dd5
	ret			; $4dd7

;;
; Determines if Link is aligned close enough on the X or Y axis to be attacked; if so,
; this sets the blade's angle accordingly.
;
; @param	b	How close Link must be (on the orthogonal axis relative to the
;			attack) before the trap can attack
; @param[out]	cflag	c if Link is in range
; @addr{4dd8}
_bladeTrap_checkLinkAligned:
	ld c,b			; $4dd8
	sla c			; $4dd9
	inc c			; $4ddb
	ld e,$00		; $4ddc
	ld h,d			; $4dde
	ld l,Enemy.xh		; $4ddf
	ldh a,(<hEnemyTargetX)	; $4de1
	sub (hl)		; $4de3
	add b			; $4de4
	cp c			; $4de5
	ld l,Enemy.yh		; $4de6
	ldh a,(<hEnemyTargetY)	; $4de8
	jr c,@inRange		; $4dea

	ld e,$18		; $4dec
	sub (hl)		; $4dee
	add b			; $4def
	cp c			; $4df0
	ld l,Enemy.xh		; $4df1
	ldh a,(<hEnemyTargetX)	; $4df3
	ret nc			; $4df5

@inRange:
	cp (hl)			; $4df6
	ld a,e			; $4df7
	jr c,+			; $4df8
	xor $10			; $4dfa
+
	ld l,Enemy.angle		; $4dfc
	ld (hl),a		; $4dfe
	scf			; $4dff
	ret			; $4e00

;;
; @addr{4e01}
_bladeTrap_incAngle:
	ld a,(de)		; $4e01
	inc a			; $4e02
	jr ++			; $4e03

;;
; @addr{4e05}
_bladeTrap_decAngle:
	ld a,(de)		; $4e05
	dec a			; $4e06
++
	and $1f			; $4e07
	ld (de),a		; $4e09
	ret			; $4e0a


; ==============================================================================
; ENEMYID_ROPE
;
; Variables:
;   counter2: Cooldown until rope can charge at Link again
;   var30: Hazards are checked iff bit 7 is set.
; ==============================================================================
enemyCode10:
	call _rope_checkHazardsIfApplicable		; $4e0b
	or a			; $4e0e
	jr z,@normalStatus	; $4e0f

	sub $03			; $4e11
	ret c			; $4e13
	jp z,enemyDie		; $4e14
	dec a			; $4e17
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4e18
	ret			; $4e1b

@normalStatus:
	call _ecom_checkScentSeedActive		; $4e1c
	jr z,++		; $4e1f
	ld e,Enemy.speed		; $4e21
	ld a,SPEED_140		; $4e23
	ld (de),a		; $4e25
++
	call _ecom_getSubidAndCpStateTo08		; $4e26
	jr nc,@normalState	; $4e29
	rst_jumpTable			; $4e2b
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub


@normalState:
	ld a,b			; $4e3c
	rst_jumpTable			; $4e3d
	.dw _rope_subid00
	.dw _rope_subid01
	.dw _rope_subid02
	.dw _rope_subid03


@state_uninitialized:
	ld e,Enemy.direction		; $4e46
	ld a,$ff		; $4e48
	ld (de),a		; $4e4a

	; Subid 1: make speed lower?
	dec b			; $4e4b
	ld a,SPEED_60		; $4e4c
	jp z,_ecom_setSpeedAndState8		; $4e4e

	; Enable scent seed effect
	ld h,d			; $4e51
	ld l,Enemy.var3f		; $4e52
	set 4,(hl)		; $4e54

	jp _ecom_setSpeedAndState8AndVisible		; $4e56


@state_switchHook:
	inc e			; $4e59
	ld a,(de)		; $4e5a
	rst_jumpTable			; $4e5b
	.dw _ecom_incState2
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate1:
@@substate2:
	ret			; $4e64


@@substate3:
	ld e,Enemy.subid		; $4e65
	ld a,(de)		; $4e67
	ld hl,@defaultStates		; $4e68
	rst_addAToHl			; $4e6b
	ld b,(hl)		; $4e6c
	jp _ecom_fallToGroundAndSetState		; $4e6d


@state_scentSeed:
	ld a,(wScentSeedActive)		; $4e70
	or a			; $4e73
	jr nz,++		; $4e74

	ld e,Enemy.subid		; $4e76
	ld a,(de)		; $4e78
	ld hl,@defaultStates		; $4e79
	rst_addAToHl			; $4e7c
	ld e,Enemy.state		; $4e7d
	ld a,(hl)		; $4e7f
	ld (de),a		; $4e80
	ld e,Enemy.speed		; $4e81
	ld a,SPEED_60		; $4e83
	ld (de),a		; $4e85
	ret			; $4e86
++
	call _ecom_updateAngleToScentSeed		; $4e87
	ld e,Enemy.angle		; $4e8a
	ld a,(de)		; $4e8c
	add $04			; $4e8d
	and $18			; $4e8f
	ld (de),a		; $4e91
	call _rope_updateAnimationFromAngle		; $4e92
	call _ecom_applyVelocityForSideviewEnemy		; $4e95
	jp _rope_animate		; $4e98


@defaultStates: ; Default states for each subid
	.db $09 $0b $0a $0a


@state_stub:
	ret			; $4e9f


; Normal rope.
_rope_subid00:
	ld a,(de)		; $4ea0
	sub $08			; $4ea1
	rst_jumpTable			; $4ea3
	.dw @state8
	.dw _rope_state_moveAround
	.dw _rope_state_chargeLink


; Initialization
@state8:
	ld h,d			; $4eaa
	ld l,e			; $4eab
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType		; $4ead
	set 7,(hl)		; $4eaf
	ld l,Enemy.var30		; $4eb1
	set 7,(hl)		; $4eb3


; Moving around, checking whether to charge Link
_rope_state_moveAround:
	ld b,$0a		; $4eb5
	call objectCheckCenteredWithLink		; $4eb7
	jr nc,++	; $4eba

	ld e,Enemy.counter2		; $4ebc
	ld a,(de)		; $4ebe
	or a			; $4ebf
	jr nz,++	; $4ec0

	; Charge at Link
	call _ecom_updateCardinalAngleTowardTarget		; $4ec2
	call _ecom_incState		; $4ec5
	ld l,Enemy.speed		; $4ec8
	ld (hl),SPEED_140		; $4eca
	jp _rope_updateAnimationFromAngle		; $4ecc

++
	call _ecom_decCounter2		; $4ecf
	dec l			; $4ed2
	dec (hl) ; [counter1]--
	call nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $4ed4
	jp z,_rope_changeDirection		; $4ed7

_rope_callEnemyAnimate:
	jp enemyAnimate		; $4eda


; Charging Link
_rope_state_chargeLink:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4edd
	jp nz,_rope_animate		; $4ee0

	ld h,d			; $4ee3
	ld l,Enemy.state		; $4ee4
	dec (hl)		; $4ee6

	ld l,Enemy.speed		; $4ee7
	ld (hl),SPEED_60		; $4ee9
	ld l,Enemy.counter2		; $4eeb
	ld (hl),$40		; $4eed
	jp _rope_changeDirection		; $4eef


; Rope that falls from the sky.
_rope_subid01:
	ld a,(de)		; $4ef2
	sub $08			; $4ef3
	rst_jumpTable			; $4ef5
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw _rope_state_moveAround
	.dw _rope_state_chargeLink


; Initialization
@state8:
	ld a,$09		; $4f00
	ld (de),a		; $4f02
	call getRandomNumber_noPreserveVars		; $4f03
	ld e,Enemy.counter1		; $4f06
	and $38			; $4f08
	inc a			; $4f0a
	ld (de),a		; $4f0b
	ret			; $4f0c


; Wait a random amount of time before dropping from the sky
@state9:
	call _ecom_decCounter1		; $4f0d
	ret nz			; $4f10

	ld l,e			; $4f11
	inc (hl) ; [state]++

	ld l,Enemy.collisionType		; $4f13
	set 7,(hl)		; $4f15
	ld l,Enemy.var30		; $4f17
	set 7,(hl)		; $4f19

	ld l,Enemy.speedZ+1		; $4f1b
	inc (hl)		; $4f1d

	ld a,SND_FALLINHOLE		; $4f1e
	call playSound		; $4f20
	call objectSetVisiblec1		; $4f23

	ld c,$08		; $4f26
	jp _ecom_setZAboveScreen		; $4f28


; Currently falling from the sky
@stateA:
	ld c,$0e		; $4f2b
	call objectUpdateSpeedZ_paramC		; $4f2d
	ret nz			; $4f30

	ld l,Enemy.speedZ		; $4f31
	ldi (hl),a		; $4f33
	ld (hl),a		; $4f34

	ld l,Enemy.state		; $4f35
	inc (hl)		; $4f37

	; Enable scent seeds
	ld l,Enemy.var3f		; $4f38
	set 4,(hl)		; $4f3a

	call objectSetVisiblec2		; $4f3c
	ld a,SND_BOMB_LAND		; $4f3f
	call playSound		; $4f41

	call _rope_changeDirection		; $4f44
	jr _rope_callEnemyAnimate		; $4f47


; Immediately charges Link upon spawning
_rope_subid02:
	ld a,(de)		; $4f49
	sub $08			; $4f4a
	rst_jumpTable			; $4f4c
	.dw @state8
	.dw @state9
	.dw _rope_state_moveAround
	.dw _rope_state_chargeLink


; Initialization
@state8:
	ld h,d			; $4f55
	ld l,e			; $4f56
	inc (hl) ; [state] = 9

	ld l,Enemy.speed		; $4f58
	ld (hl),SPEED_140		; $4f5a
	ld l,Enemy.counter1		; $4f5c
	ld (hl),$08		; $4f5e
	call _ecom_updateCardinalAngleTowardTarget		; $4f60
	jp _rope_updateAnimationFromAngle		; $4f63


; Waiting just before charging Link
@state9:
	call _ecom_decCounter1		; $4f66
	jr nz,++		; $4f69

	ld l,e			; $4f6b
	ld (hl),$0b ; [state] = "charge at Link" state

	ld l,Enemy.collisionType		; $4f6e
	set 7,(hl)		; $4f70
	ld l,Enemy.var30		; $4f72
	set 7,(hl)		; $4f74
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4f76
	jp enemyAnimate		; $4f79


; Falls and bounces toward Link when it spawns
_rope_subid03:
	ld a,(de)		; $4f7c
	sub $08			; $4f7d
	rst_jumpTable			; $4f7f
	.dw @state8
	.dw @state9
	.dw _rope_state_moveAround
	.dw _rope_state_chargeLink


; Initialization
@state8:
	ld h,d			; $4f88
	ld l,e			; $4f89
	inc (hl) ; [state] = 9

	ld l,Enemy.speedZ		; $4f8b
	ld a,$fe		; $4f8d
	ldi (hl),a		; $4f8f
	ld (hl),$fe		; $4f90

	ld l,Enemy.speed		; $4f92
	ld (hl),SPEED_c0		; $4f94

	ld l,Enemy.angle		; $4f96
	ld a,(w1Link.direction)		; $4f98
	swap a			; $4f9b
	rrca			; $4f9d
	ld (hl),a		; $4f9e

	jp _rope_updateAnimationFromAngle		; $4f9f


; "Bouncing" toward Link
@state9:
	ld c,$0e		; $4fa2
	call objectUpdateSpeedZAndBounce		; $4fa4
	jr c,@doneBouncing	; $4fa7

	ld a,SND_BOMB_LAND		; $4fa9
	call z,playSound		; $4fab

	; Enable collisions if speedZ is positive?
	ld e,Enemy.speedZ+1		; $4fae
	ld a,(de)		; $4fb0
	or a			; $4fb1
	jr nz,++		; $4fb2
	ld h,d			; $4fb4
	ld l,Enemy.collisionType		; $4fb5
	set 7,(hl)		; $4fb7
	ld l,Enemy.var30		; $4fb9
	set 7,(hl)		; $4fbb
++
	jp _ecom_applyVelocityForSideviewEnemyNoHoles		; $4fbd

@doneBouncing:
	call _ecom_incState		; $4fc0
	ld l,Enemy.speed		; $4fc3
	ld (hl),SPEED_60		; $4fc5

;;
; Chooses random new angle, random value for counter1.
; @addr{4fc7}
_rope_changeDirection:
	ldbc $18,$70		; $4fc7
	call _ecom_randomBitwiseAndBCE		; $4fca
	ld e,Enemy.angle		; $4fcd
	ld a,b			; $4fcf
	ld (de),a		; $4fd0
	ld e,Enemy.counter1		; $4fd1
	ld a,c			; $4fd3
	add $70			; $4fd4
	ld (de),a		; $4fd6

;;
; @addr{4fd7}
_rope_updateAnimationFromAngle:
	ld h,d			; $4fd7
	ld l,Enemy.angle		; $4fd8
	ld a,(hl)		; $4fda
	and $0f			; $4fdb
	ret z			; $4fdd

	ldd a,(hl)		; $4fde
	and $10			; $4fdf
	swap a			; $4fe1
	xor $01			; $4fe3
	cp (hl)			; $4fe5
	ret z			; $4fe6

	ld (hl),a		; $4fe7
	jp enemySetAnimation		; $4fe8

;;
; @addr{4feb}
_rope_animate:
	ld h,d			; $4feb
	ld l,Enemy.animCounter		; $4fec
	ld a,(hl)		; $4fee
	sub $03			; $4fef
	jr nc,+			; $4ff1
	xor a			; $4ff3
+
	inc a			; $4ff4
	ld (hl),a		; $4ff5
	jp enemyAnimate		; $4ff6

;;
; @addr{4ff9}
_rope_checkHazardsIfApplicable:
	ld h,d			; $4ff9
	ld l,Enemy.var30		; $4ffa
	bit 7,(hl)		; $4ffc
	ret z			; $4ffe
	jp _ecom_checkHazards		; $4fff


; ==============================================================================
; ENEMYID_GIBDO
; ==============================================================================
enemyCode12:
	; a = ENEMY_STATUS
	call _ecom_checkHazards		; $5002

	; a = ENEMY_STATUS
	jr z,@normalStatus	; $5005

	sub ENEMYSTATUS_NO_HEALTH			; $5007
	ret c			; $5009
	jp z,enemyDie		; $500a

	; If just hit by ember seed, go to state $0a (turn into stalfos)
	ld e,Enemy.var2a		; $500d
	ld a,(de)		; $500f
	cp $80|ITEMCOLLISION_EMBER_SEED			; $5010
	ret nz			; $5012

	ld h,d			; $5013
	ld l,Enemy.state		; $5014
	ld a,$0a		; $5016
	cp (hl)			; $5018
	ret z			; $5019

	ld (hl),a		; $501a
	ld l,Enemy.counter1		; $501b
	ld (hl),30		; $501d
	ld l,Enemy.stunCounter		; $501f
	ld (hl),$00		; $5021
	ret			; $5023

@normalStatus:
	ld e,Enemy.state		; $5024
	ld a,(de)		; $5026
	rst_jumpTable			; $5027
	.dw @uninitialized
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


@uninitialized:
	ld a,SPEED_80		; $503e
	jp _ecom_setSpeedAndState8AndVisible		; $5040


@state_switchHook:
	inc e			; $5043
	ld a,(de)		; $5044
	rst_jumpTable			; $5045
	.dw _ecom_incState2
	.dw @@substate1
	.dw @@substate2
	.dw _ecom_fallToGroundAndSetState8

@@substate1:
@@substate2:
	ret			; $504e

@state_stub:
	ret			; $504f


; Choosing a direction & duration to walk
@state8:
	ld a,$09		; $5050
	ld (de),a		; $5052

	; Choose random angle & counter1
	ldbc $18,$7f		; $5053
	call _ecom_randomBitwiseAndBCE		; $5056
	ld e,Enemy.angle		; $5059
	ld a,b			; $505b
	ld (de),a		; $505c
	ld e,Enemy.counter1		; $505d
	ld a,$40		; $505f
	add c			; $5061
	ld (de),a		; $5062
	jr @animate		; $5063


; Walking in some direction for [counter1] frames
@state9:
	call _ecom_decCounter1		; $5065
	jr z,@gotoState8	; $5068
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $506a
	jr z,@gotoState8	; $506d
@animate:
	jp enemyAnimate		; $506f


; Burning; turns into stalfos
@stateA:
	call _ecom_decCounter1		; $5072
	ret nz			; $5075
	ldbc ENEMYID_STALFOS,$02		; $5076
	jp enemyReplaceWithID		; $5079


@gotoState8:
	ld e,Enemy.state		; $507c
	ld a,$08		; $507e
	ld (de),a		; $5080
	jr @animate		; $5081


; ==============================================================================
; ENEMYID_SPARK
; ==============================================================================
enemyCode13:
	call _ecom_checkHazards		; $5083
	jr z,@normalStatus	; $5086

	sub ENEMYSTATUS_NO_HEALTH			; $5088
	ret c			; $508a
	ld e,Enemy.var2a		; $508b
	ld a,(de)		; $508d
	res 7,a			; $508e
.ifdef ROM_AGES
	sub ITEMCOLLISION_BOOMERANG			; $5090
	cp $01			; $5092
.else
	sub ITEMCOLLISION_BOOMERANG-2			; $5090
	cp $02			; $5092
.endif
	jr nc,@normalStatus	; $5094

	; Collision with boomerang occurred. Go to state 9.
	ld e,Enemy.state		; $5096
	ld a,(de)		; $5098
	cp $09			; $5099
	jr nc,@normalStatus	; $509b
	ld a,$09		; $509d
	ld (de),a		; $509f

@normalStatus:
	ld e,Enemy.state		; $50a0
	ld a,(de)		; $50a2
	rst_jumpTable			; $50a3
	.dw _spark_state_uninitialized
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state8
	.dw _spark_state9
	.dw _spark_stateA


_spark_state_uninitialized:
	call _spark_getWallAngle		; $50ba
	ld e,Enemy.angle		; $50bd
	ld (de),a		; $50bf
	ld a,SPEED_100		; $50c0
	call _ecom_setSpeedAndState8		; $50c2
	jp objectSetVisible82		; $50c5


_spark_state_stub:
	ret			; $50c8


; Standard movement state.
_spark_state8:
	call _spark_updateAngle		; $50c9
	call objectApplySpeed		; $50cc
	jp enemyAnimate		; $50cf


; Just hit by a boomerang. (Also whisp's state 9.)
_spark_state9:
	ldbc INTERACID_PUFF,$02		; $50d2
	call objectCreateInteraction		; $50d5
	ret nz			; $50d8

	ld e,Enemy.relatedObj2		; $50d9
	ld a,Interaction.start		; $50db
	ld (de),a		; $50dd
	inc e			; $50de
	ld a,h			; $50df
	ld (de),a		; $50e0

	call _ecom_incState		; $50e1
	jp objectSetInvisible		; $50e4


; Will delete self and create fairy when the "puff" is gone. (Also whisp's state A.)
_spark_stateA:
	ld a,Object.animParameter		; $50e7
	call objectGetRelatedObject2Var		; $50e9
	ld a,(hl)		; $50ec
	inc a			; $50ed
	ret nz			; $50ee

	ld e,Enemy.id		; $50ef
	ld a,(de)		; $50f1
	cp ENEMYID_SPARK			; $50f2
	ld b,PARTID_ITEM_DROP		; $50f4
	call z,_ecom_spawnProjectile		; $50f6
	jp enemyDelete		; $50f9


; ==============================================================================
; ENEMYID_WHISP
; ==============================================================================
enemyCode19:
	jr z,@normalStatus	; $50fc
	sub ENEMYSTATUS_NO_HEALTH			; $50fe
	ret c			; $5100

	ld e,Enemy.var2a		; $5101
	ld a,(de)		; $5103
	res 7,a			; $5104
.ifdef ROM_AGES
	sub ITEMCOLLISION_BOOMERANG			; $5106
	cp $01			; $5108
.else
	sub ITEMCOLLISION_BOOMERANG-2			; $5106
	cp $02			; $5108
.endif
	jr nc,@normalStatus	; $510a

	; Hit with boomerang
	ld e,Enemy.state		; $510c
	ld a,(de)		; $510e
	cp $09			; $510f
	jr nc,@normalStatus	; $5111
	ld a,$09		; $5113
	ld (de),a		; $5115

@normalStatus:
	ld e,Enemy.state		; $5116
	ld a,(de)		; $5118
	rst_jumpTable			; $5119
	.dw _whisp_state_uninitialized
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _spark_state_stub
	.dw _spark_state_stub
	.dw _whisp_state8
	.dw _spark_state9
	.dw _spark_stateA


_whisp_state_uninitialized:
	call getRandomNumber_noPreserveVars		; $5130
	and $18			; $5133
	add $04			; $5135
	ld e,Enemy.angle		; $5137
	ld (de),a		; $5139

	ld a,SPEED_c0		; $513a
	call _ecom_setSpeedAndState8		; $513c

	jp objectSetVisible82		; $513f


_whisp_state8:
	call _ecom_bounceOffWalls		; $5142
	call objectApplySpeed		; $5145
	jp enemyAnimate		; $5148


;;
; Updates the spark's moving angle by checking for walls, updating angle appropriately.
; Sparks move by hugging walls.
; @addr{514b}
_spark_updateAngle:
	ld a,$01		; $514b
	ldh (<hFF8A),a

	; Confirm that we're still up against a wall
	ld e,Enemy.angle		; $514f
	ld a,(de)		; $5151
	sub $08			; $5152
	and $18			; $5154
	call _spark_checkWallInDirection		; $5156
	jr c,++		; $5159

	; The wall has gone missing, but don't update angle until we're centered by
	; 8 pixels.
	call _spark_getTileOffset		; $515b
	ret nz			; $515e

	ld e,Enemy.angle		; $515f
	ld a,(de)		; $5161
	sub $08			; $5162
	and $18			; $5164
	ld (de),a		; $5166
	ret			; $5167
++
	; We're still hugging a wall, but check if we're running into one now.
	ld e,Enemy.angle		; $5168
	ld a,(de)		; $516a
	call _spark_checkWallInDirection		; $516b
	ret nc			; $516e

	ld e,Enemy.angle		; $516f
	ld a,(de)		; $5171
	add $08			; $5172
	and $18			; $5174
	ld (de),a		; $5176
	ret			; $5177


;;
; @param[out]	a	Angle relative to enemy where wall is (only valid if cflag is set)
; @param[out]	cflag	c if there is a wall in any direction, nc otherwise
; @addr{5178}
_spark_getWallAngle:
	xor a			; $5178
	call _spark_checkWallInDirection		; $5179
	ld a,$08		; $517c
	ret c			; $517e
	call _spark_checkWallInDirection		; $517f
	ld a,$10		; $5182
	ret c			; $5184
	call _spark_checkWallInDirection		; $5185
	ld a,$18		; $5188
	ret c			; $518a
	xor a			; $518b
	ret			; $518c

;;
; @param[out]	a	A value from 0-7, indicating the offset within a quarter-tile the
;			whisp is at. When this is 0, it needs to check for a direction
;			change?
; @addr{518d}
_spark_getTileOffset:
	ld e,Enemy.angle		; $518d
	ld a,(de)		; $518f
	bit 3,a			; $5190
	jr nz,++		; $5192
	ld e,Enemy.yh		; $5194
	ld a,(de)		; $5196
	and $07			; $5197
	ret			; $5199
++
	ld e,Enemy.xh		; $519a
	ld a,(de)		; $519c
	and $07			; $519d
	ret			; $519f

;;
; @param	a	Angle to check
; @param[out]	cflag	c if there's a solid wall in that direction
; @addr{51a0}
_spark_checkWallInDirection:
	and $18			; $51a0
	rrca			; $51a2
	ld hl,@offsetTable		; $51a3
	rst_addAToHl			; $51a6
	ld e,Enemy.yh		; $51a7
	ld a,(de)		; $51a9
	add (hl)		; $51aa
	ld b,a			; $51ab

	inc hl			; $51ac
	ld e,Enemy.xh		; $51ad
	ld a,(de)		; $51af
	add (hl)		; $51b0
	ld c,a			; $51b1

	push hl			; $51b2
	push bc			; $51b3
	call checkTileCollisionAt_disallowHoles		; $51b4
	pop bc			; $51b7
	pop hl			; $51b8
	ret c			; $51b9

	inc hl			; $51ba
	ldi a,(hl)		; $51bb
	add b			; $51bc
	ld b,a			; $51bd
	ld a,(hl)		; $51be
	add c			; $51bf
	ld c,a			; $51c0
	jp checkTileCollisionAt_disallowHoles		; $51c1


; Each direction lists two position offsets to check for collisions at.
@offsetTable:
	.db $f7 $fc $00 $07 ; DIR_UP
	.db $fc $08 $07 $00 ; DIR_RIGHT
	.db $08 $fc $00 $07 ; DIR_DOWN
	.db $fc $f7 $07 $00 ; DIR_LEFT


; ==============================================================================
; ENEMYID_SPIKED_BEETLE
;
; Variables:
;   var30: $00 normally, $01 when flipped over.
; ==============================================================================
enemyCode14:
	call _ecom_checkHazards		; $51d4
	jr z,@normalStatus	; $51d7

	sub ENEMYSTATUS_NO_HEALTH			; $51d9
	ret c			; $51db
	jp z,enemyDie		; $51dc

	dec a			; $51df
	jr nz,@knockback	; $51e0

	; Just hit by something

	; If bit 0 of var30 is set, ...?
	ld h,d			; $51e2
	ld l,Enemy.var30		; $51e3
	bit 0,(hl)		; $51e5
	jr z,++			; $51e7
	ld e,Enemy.zh		; $51e9
	ld a,(de)		; $51eb
	rlca			; $51ec
	jr c,++			; $51ed
	ld (hl),$00		; $51ef
++
	; Check if the collision was a shovel or shield (enemy will flip over)
	ld e,Enemy.var2a		; $51f1
	ld a,(de)		; $51f3
.ifdef ROM_AGES
	cp $80|ITEMCOLLISION_SHOVEL			; $51f4
.else
	cp $80|ITEMCOLLISION_SHOVEL+1			; $51f4
.endif
	jr z,++			; $51f6
	res 7,a			; $51f8
	sub ITEMCOLLISION_L1_SHIELD			; $51fa
	cp (ITEMCOLLISION_L3_SHIELD-ITEMCOLLISION_L1_SHIELD)+1
	jr nc,@normalStatus	; $51fe
++
	; If already flipped, return.
	ld e,Enemy.state		; $5200
	ld a,(de)		; $5202
	cp $0b			; $5203
	ret z			; $5205

	; Flip over.

	ld (hl),$01 ; [var30] = $01
	ld bc,-$180		; $5208
	call objectSetSpeedZ		; $520b

	ld l,Enemy.state		; $520e
	ld (hl),$0b		; $5210

	ld l,Enemy.enemyCollisionMode		; $5212
	ld (hl),ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED		; $5214

	ld l,Enemy.counter1		; $5216
	ld (hl),180		; $5218

	ld l,Enemy.knockbackAngle		; $521a
	ld a,(hl)		; $521c
	xor $10			; $521d
	ld l,Enemy.angle		; $521f
	ld (hl),a		; $5221

	ld a,SND_BOMB_LAND		; $5222
	call playSound		; $5224
	ld a,$01		; $5227
	jp enemySetAnimation		; $5229


@knockback:
	ld e,Enemy.var30		; $522c
	ld a,(de)		; $522e
	or a			; $522f
	jp z,_ecom_updateKnockbackAndCheckHazards		; $5230

	; If flipped over, knockback is considered to last until it stops bouncing.
	ld c,$18		; $5233
	call objectUpdateSpeedZAndBounce		; $5235
	ld a,$01		; $5238
	jr nc,+			; $523a
	xor a			; $523c
+
	ld e,Enemy.knockbackCounter		; $523d
	ld (de),a		; $523f
	ld e,Enemy.knockbackAngle		; $5240
	ld a,(de)		; $5242
	ld c,a			; $5243
	ld b,SPEED_e0		; $5244
	jp _ecom_applyGivenVelocity		; $5246


@normalStatus:
	ld e,Enemy.state		; $5249
	ld a,(de)		; $524b
	rst_jumpTable			; $524c
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


@state_uninitialized:
	call @setRandomAngleAndCounter1		; $5267
	ld a,SPEED_40		; $526a
	jp _ecom_setSpeedAndState8AndVisible		; $526c


@state_stub:
	ret			; $526f


; Wandering around until Link comes into range
@state8:
	ld b,$08		; $5270
	call objectCheckCenteredWithLink		; $5272
	jp c,@chargeLink		; $5275

	call _ecom_decCounter1		; $5278
	jp z,@setRandomAngleAndCounter1		; $527b
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $527e
	jp z,@setRandomAngleAndCounter1		; $5281
@animate:
	jp enemyAnimate		; $5284


; Charging at Link
@state9:
	call _ecom_decCounter2		; $5287
	call @incSpeed		; $528a
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $528d
	jr nz,@animate	; $5290

	; Hit wall
	call _ecom_incState		; $5292
	ld l,Enemy.counter1		; $5295
	ld (hl),30		; $5297
	ret			; $5299


; Standing still for 30 frames (unless it can charge Link again)
@stateA:
	ld b,$08		; $529a
	call objectCheckCenteredWithLink		; $529c
	jp c,@chargeLink		; $529f

	call _ecom_decCounter1		; $52a2
	jr nz,@animate	; $52a5

	ld l,Enemy.state		; $52a7
	ld (hl),$08		; $52a9
	ld l,Enemy.speed		; $52ab
	ld (hl),SPEED_40		; $52ad
	jp @setRandomAngleAndCounter1		; $52af


; Flipped over.
@stateB:
	call _ecom_decCounter1		; $52b2
	jr nz,++		; $52b5

	; Flip back to normal.

	ld l,e			; $52b7
	inc (hl) ; [state] = $0c
	ld l,Enemy.speed		; $52b9
	ld (hl),SPEED_c0		; $52bb

	ld l,Enemy.enemyCollisionMode		; $52bd
	ld (hl),ENEMYCOLLISION_SPIKED_BEETLE		; $52bf
	ld l,Enemy.xh		; $52c1
	inc (hl)		; $52c3
	ld bc,-$180		; $52c4
	call objectSetSpeedZ		; $52c7
	xor a			; $52ca
	jp enemySetAnimation		; $52cb
++
	; Waiting to flip back.
	ld a,(hl)		; $52ce
	cp 60			; $52cf
	jr nc,@animate	; $52d1

	; In last second, start shaking.
	and $06			; $52d3
	rrca			; $52d5
	ld hl,@xOscillationOffsets	; $52d6
	rst_addAToHl			; $52d9
	ld e,Enemy.xh		; $52da
	ld a,(de)		; $52dc
	add (hl)		; $52dd
	ld (de),a		; $52de
	jr @animate		; $52df


; In the process of flipping back to normal.
@stateC:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $52e1
	call enemyAnimate		; $52e4

	ld c,$18		; $52e7
	call objectUpdateSpeedZ_paramC		; $52e9
	ret nz			; $52ec

	ld e,Enemy.state		; $52ed
	ld a,$08		; $52ef
	ld (de),a		; $52f1

	ld b,$10		; $52f2
	call objectCheckCenteredWithLink		; $52f4
	jr c,@chargeLink	; $52f7

	ld e,Enemy.speed		; $52f9
	ld a,SPEED_40		; $52fb
	ld (de),a		; $52fd
	ret			; $52fe

;;
; Angle and counter1 are set randomly (counter1 is between $30-$60, in increments of $10).
; @addr{52ff}
@setRandomAngleAndCounter1:
	ldbc $18,$30		; $52ff
	call _ecom_randomBitwiseAndBCE		; $5302
	ld e,Enemy.angle		; $5305
	ld a,b			; $5307
	ld (de),a		; $5308
	ld e,Enemy.counter1		; $5309
	ld a,$30		; $530b
	add c			; $530d
	ld (de),a		; $530e
	ret			; $530f

;;
; @addr{5310}
@chargeLink:
	call _ecom_updateCardinalAngleTowardTarget		; $5310
	ld h,d			; $5313
	ld l,Enemy.state		; $5314
	ld (hl),$09		; $5316
	ld l,Enemy.counter2		; $5318
	ld (hl),150		; $531a
	ld l,Enemy.speed		; $531c
	ld (hl),SPEED_40		; $531e
	ret			; $5320

;;
; @addr{5321}
@incSpeed:
	ld e,Enemy.counter2		; $5321
	ld a,(de)		; $5323
	and $03			; $5324
	ret nz			; $5326

	ld e,Enemy.speed		; $5327
	ld a,(de)		; $5329
	cp SPEED_180			; $532a
	ret nc			; $532c
	add SPEED_20			; $532d
	ld (de),a		; $532f
	ret			; $5330

@xOscillationOffsets:
	.db $01 $ff $ff $01


; ==============================================================================
; ENEMYID_BUBBLE
; ==============================================================================
enemyCode15:
	jr z,@normalStatus	; $5335
	sub ENEMYSTATUS_NO_HEALTH			; $5337
	ret c			; $5339

	; Check if collided with Link; disable sword if so.
	ld e,Enemy.var2a		; $533a
	ld a,(de)		; $533c
	cp $80|ITEMCOLLISION_LINK			; $533d
	jr nz,@normalStatus	; $533f

	ld a,WHISP_RING		; $5341
	call cpActiveRing		; $5343
	jr z,@normalStatus	; $5346

	ld a,180		; $5348
	ld (wSwordDisabledCounter),a		; $534a

@normalStatus:
	ld e,Enemy.state		; $534d
	ld a,(de)		; $534f
	rst_jumpTable			; $5350
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8

@state_uninitialized:
	call getRandomNumber_noPreserveVars		; $5363
	and $18			; $5366
	ld e,Enemy.angle		; $5368
	ld (de),a		; $536a
	ld a,SPEED_c0		; $536b
	call _ecom_setSpeedAndState8		; $536d
	jp objectSetVisible82		; $5370


@state_stub:
	ret			; $5373


@state8:
	call @checkCenteredOnTile		; $5374
	call z,@chooseNewDirection		; $5377
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $537a
	call z,@chooseNewDirection		; $537d
	jp enemyAnimate		; $5380

;;
; @addr{5383}
@chooseNewDirection:
	ldbc $07,$18		; $5383
	call _ecom_randomBitwiseAndBCE		; $5386
	or b			; $5389
	ret nz			; $538a
	ld e,Enemy.angle		; $538b
	ld a,c			; $538d
	ld (de),a		; $538e
	ret			; $538f

;;
; @param[out]	zflag	z if centered
; @addr{5390}
@checkCenteredOnTile:
	ld h,d			; $5390
	ld l,Enemy.yh		; $5391
	ldi a,(hl)		; $5393
	ld b,a			; $5394
	inc l			; $5395
	ld c,(hl)		; $5396
	or c			; $5397
	and $07			; $5398
	ret			; $539a


; ==============================================================================
; ENEMYID_BEAMOS
; ==============================================================================
enemyCode16:
	jr z,@normalStatus	; $539b
	sub ENEMYSTATUS_NO_HEALTH			; $539d
	ret c			; $539f

@normalStatus:
	ld e,Enemy.state		; $53a0
	ld a,(de)		; $53a2
	rst_jumpTable			; $53a3
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	call _ecom_setSpeedAndState8AndVisible		; $53b8
	ld l,Enemy.counter1		; $53bb
	ld (hl),$05		; $53bd
	jp objectMakeTileSolid		; $53bf


@state_stub:
	ret			; $53c2


@state8:
	call @updateAngle		; $53c3
	call _ecom_decCounter2		; $53c6
	ret nz			; $53c9
	jr @checkFireBeam		; $53ca


@state9:
	call _ecom_decCounter1		; $53cc
	jr nz,++		; $53cf
	ld (hl),$05 ; [counter1] = 5
	inc l			; $53d3
	ld (hl),40  ; [counter2] = 40
	ld l,e			; $53d6
	dec (hl) ; [state] = 8
	ret			; $53d8
++
	; Play sound on 11th-to-last frame
	ld a,(hl)		; $53d9
	cp $0b			; $53da
	ld a,SND_BEAM		; $53dc
	jp z,playSound		; $53de
	ret nc			; $53e1

	; Spawn projectile every frame for 10 frames
	ld b,PARTID_BEAM		; $53e2
	call _ecom_spawnProjectile		; $53e4
	ret nz			; $53e7

	ld e,Enemy.counter1		; $53e8
	ld a,(de)		; $53ea
	and $01			; $53eb
	ld l,Part.subid		; $53ed
	ld (hl),a		; $53ef
	ret			; $53f0

;;
; Increments angle every 5 frames.
; @addr{53f1}
@updateAngle:
	call _ecom_decCounter1		; $53f1
	ret nz			; $53f4

	ld (hl),$05		; $53f5
	ld l,Enemy.angle		; $53f7
	ld a,(hl)		; $53f9
	inc a			; $53fa
	and $1f			; $53fb
	ld (hl),a		; $53fd

	ld hl,@angleToAnimation		; $53fe
	rst_addAToHl			; $5401
	ld a,(hl)		; $5402
	jp enemySetAnimation		; $5403

@angleToAnimation:
	.db $00 $00 $01 $01 $01 $01 $01 $02
	.db $02 $02 $03 $03 $03 $03 $03 $04
	.db $04 $04 $05 $05 $05 $05 $05 $06
	.db $06 $06 $07 $07 $07 $07 $07 $00

;;
; @addr{5426}
@checkFireBeam:
	call objectGetAngleTowardEnemyTarget		; $5426
	ld h,d			; $5429
	ld l,Enemy.angle		; $542a
	sub (hl)		; $542c
	inc a			; $542d
	cp $02			; $542e
	ret nc			; $5430

	ld l,Enemy.counter1		; $5431
	ld (hl),20		; $5433

	; "Invincibility" is just for the glowing effect?
	ld l,Enemy.invincibilityCounter		; $5435
	ld (hl),$14		; $5437

	ld l,Enemy.state		; $5439
	inc (hl) ; [state] = 9
	ret			; $543c


; ==============================================================================
; ENEMYID_GHINI
;
; Variables:
;   var30/31: Target Y/X position for subid 2 only
; ==============================================================================
enemyCode17:
	jr z,@normalStatus	; $543d
	sub ENEMYSTATUS_NO_HEALTH			; $543f
	jr c,@stunned	; $5441
	jr z,@dead	; $5443
	dec a			; $5445
	jp nz,_ecom_updateKnockbackNoSolidity		; $5446
	ret			; $5449

@stunned:
	ld e,Enemy.stunCounter		; $544a
	ld a,(de)		; $544c
	or a			; $544d
	ret nz			; $544e

	; Restore normal Z position when stun is over?
	ld e,Enemy.zh		; $544f
	ld a,$fe		; $5451
	ld (de),a		; $5453
	ret			; $5454

@dead:
	ld e,Enemy.subid		; $5455
	ld a,(de)		; $5457
	dec a			; $5458
	jp z,enemyDie		; $5459

	; For subid 1 only, kill all other ghinis with subid 1.
	ldhl FIRST_ENEMY_INDEX, Enemy.id		; $545c
@nextGhini:
	ld a,(hl)		; $545f
	cp ENEMYID_GHINI			; $5460
	jr nz,++		; $5462
	inc l			; $5464
	ldd a,(hl)		; $5465
	dec a			; $5466
	jr nz,++			; $5467
	call _ecom_killObjectH		; $5469
	ld l,Enemy.id		; $546c
++
	inc h			; $546e
	ld a,h			; $546f
	cp LAST_ENEMY_INDEX+1			; $5470
	jr c,@nextGhini	; $5472
	jp enemyDie		; $5474


@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5477
	jr nc,@normalState	; $547a
	rst_jumpTable			; $547c
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub

@normalState:
	ld a,b			; $548d
	rst_jumpTable			; $548e
	.dw _ghini_subid00
	.dw _ghini_subid01
	.dw _ghini_subid02


@state_uninitialized:
	ld a,SPEED_80		; $5495
	call _ecom_setSpeedAndState8		; $5497
	ld l,Enemy.zh		; $549a
	ld (hl),$fe		; $549c

	; Check for subid 1 only
	ld a,b			; $549e
	dec a			; $549f
	jr nz,++		; $54a0

	ld l,Enemy.counter1		; $54a2
	ld (hl),60		; $54a4
	ld l,Enemy.angle		; $54a6
	ld (hl),$10		; $54a8
	ld l,Enemy.collisionType		; $54aa
	res 7,(hl)		; $54ac
++
	jp objectSetVisiblec1		; $54ae


@state_stub:
	ret			; $54b1


; Normal ghini.
_ghini_subid00:
	ld a,(de)		; $54b2
	sub $08			; $54b3
	rst_jumpTable			; $54b5
	.dw @state8
	.dw @state9

@state8:
	; Set random angle, counter1
	ldbc $18,$7f		; $54ba
	call _ecom_randomBitwiseAndBCE		; $54bd
	ld h,d			; $54c0
	ld l,Enemy.counter1		; $54c1
	ld a,$30		; $54c3
	add c			; $54c5
	ld (hl),a		; $54c6
	ld l,Enemy.angle		; $54c7
	ld (hl),b		; $54c9

	ld l,Enemy.state		; $54ca
	inc (hl)		; $54cc
	jp _ghini_updateAnimationFromAngle		; $54cd

@state9:
	call _ghini_updateMovement		; $54d0
	call _ecom_decCounter1		; $54d3
	jr nz,++		; $54d6

	; Go back to state 8 to decide a new direction.
	ld l,Enemy.state		; $54d8
	dec (hl)		; $54da
++
	jp enemyAnimate		; $54db


; This type takes a second to spawn in, and killing one ghini of subid 1 makes all other
; die too?
_ghini_subid01:
	ld a,(de)		; $54de
	sub $08			; $54df
	rst_jumpTable			; $54e1
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


; Fading in.
@state8:
	call _ecom_decCounter1		; $54ec
	jr z,++			; $54ef

	; Flicker visibility
	ld a,(hl)		; $54f1
	and $01			; $54f2
	ret nz			; $54f4
	jp _ecom_flickerVisibility		; $54f5
++
	; Make visible, enable collisions
	ld l,Enemy.visible		; $54f8
	set 7,(hl)		; $54fa
	ld l,Enemy.collisionType		; $54fc
	set 7,(hl)		; $54fe
	call @gotoStateC		; $5500
	jr @animate		; $5503


; Just wandering around until counter1 reaches 0.
@state9:
	call _ghini_updateMovement		; $5505
	ld a,(wFrameCounter)		; $5508
	rrca			; $550b
	jr nc,@animate	; $550c
	call _ecom_decCounter1		; $550e
	jr z,@incState	; $5511

	call getRandomNumber_noPreserveVars		; $5513
	cp $08			; $5516
	jr nc,@animate	; $5518

	; Rare chance (1/8192 per frame) of moving directly toward Link
	; Otherwise just takes a new random angle
	ldbc $1f,$1f		; $551a
	call _ecom_randomBitwiseAndBCE		; $551d
	or b			; $5520
	ld a,c			; $5521
	call z,objectGetAngleTowardEnemyTarget		; $5522
	ld e,Enemy.angle		; $5525
	ld (de),a		; $5527
	call _ghini_updateAnimationFromAngle		; $5528
	jr @animate		; $552b

@incState:
	call _ecom_incState		; $552d
	ld l,Enemy.counter1		; $5530
	ld (hl),$00		; $5532
	jr @animate		; $5534


; Gradually decrease speed for 128 frames
@stateA:
	ld h,d			; $5536
	ld l,Enemy.counter1		; $5537
	inc (hl)		; $5539
	ld a,(hl)		; $553a
	cp $80			; $553b
	jp c,_ghini_updateMovementAndSetSpeedFromCounter1		; $553d

	ld (hl),$80		; $5540
	ld l,e			; $5542
	inc (hl) ; [state] = $0b
@animate:
	jp enemyAnimate		; $5544


; Stop moving for 128 frames
@stateB:
	call _ecom_decCounter1		; $5547
	jr nz,@animate	; $554a


@gotoStateC:
	ld l,Enemy.state		; $554c
	ld (hl),$0c		; $554e
	ld l,Enemy.counter1		; $5550
	ld (hl),$7f		; $5552
	ld l,Enemy.speed		; $5554
	ld (hl),SPEED_20		; $5556
	jr @animate		; $5558


; Gradually increase speed for 128 frames
@stateC:
	call _ecom_decCounter1		; $555a
	jp nz,_ghini_updateMovementAndSetSpeedFromCounter1		; $555d

	ld l,e			; $5560
	ld (hl),$09		; $5561
	call getRandomNumber_noPreserveVars		; $5563
	ld e,Enemy.counter1		; $5566
	and $7f			; $5568
	add $7f			; $556a
	ld (de),a		; $556c
	jr @animate		; $556d


_ghini_subid02:
	ld a,(de)		; $556f
	sub $08			; $5570
	rst_jumpTable			; $5572
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB


; Choose a random target position to move toward
@state8:
	ld h,d			; $557b
	ld l,e			; $557c
	inc (hl)		; $557d
	ld l,Enemy.speed		; $557e
	ld (hl),SPEED_40		; $5580
	ld l,Enemy.counter1		; $5582
	ld (hl),$24		; $5584
	call _ghini_chooseTargetPosition		; $5586


; Grudually increasing speed while moving toward target
@state9:
	call _ecom_decCounter1		; $5589
	jr nz,++		; $558c

	ld l,e			; $558e
	inc (hl) ; [state] = $0a
	jr @stateA		; $5590
++
	ld a,(hl)		; $5592
	and $07			; $5593
	jr nz,@stateA	; $5595
	ld l,Enemy.speed		; $5597
	ld a,(hl)		; $5599
	add SPEED_20			; $559a
	ld (hl),a		; $559c


; Moving toward target
@stateA:
	ld h,d			; $559d
	ld l,Enemy.var30		; $559e
	call _ecom_readPositionVars		; $55a0

	; Check that the target is at least 2 pixels away in either direction.
	sub c			; $55a3
	inc a			; $55a4
	cp $03			; $55a5
	jr nc,@moveTowardTarget	; $55a7
	ldh a,(<hFF8F)	; $55a9
	sub b			; $55ab
	inc a			; $55ac
	cp $03			; $55ad
	jr nc,@moveTowardTarget	; $55af

	; We've reached the target; go to state $0b.
	ld l,Enemy.state		; $55b1
	ld (hl),$0b		; $55b3
	ld l,Enemy.counter1		; $55b5
	ld (hl),$1c		; $55b7
	jr @stateB		; $55b9

@moveTowardTarget:
	call _ecom_moveTowardPosition		; $55bb
	call _ghini_updateAnimationFromAngle		; $55be
@animate:
	jp enemyAnimate		; $55c1


; Gradually decreasing speed
@stateB:
	call _ecom_decCounter1		; $55c4
	jr z,@gotoState8	; $55c7

	ld a,(hl)		; $55c9
	and $07			; $55ca
	jr nz,++		; $55cc
	ld l,Enemy.speed		; $55ce
	ld a,(hl)		; $55d0
	sub SPEED_20			; $55d1
	ld (hl),a		; $55d3
++
	call objectApplySpeed		; $55d4
	jr @animate		; $55d7

@gotoState8:
	ld l,e			; $55d9
	ld (hl),$08		; $55da
	jr @state8			; $55dc


;;
; Sets speed, where it's higher if counter1 is lower.
; @addr{55de}
_ghini_updateMovementAndSetSpeedFromCounter1:
	call _ghini_updateMovement		; $55de
	ld e,Enemy.counter1		; $55e1
	ld a,(de)		; $55e3
	ld b,$00		; $55e4
	cp $2a			; $55e6
	jr c,++			; $55e8
	inc b			; $55ea
	cp $54			; $55eb
	jr c,++			; $55ed
	inc b			; $55ef
++
	ld a,b			; $55f0
	ld hl,@speeds		; $55f1
	rst_addAToHl			; $55f4
	ld e,Enemy.speed		; $55f5
	ld a,(hl)		; $55f7
	ld (de),a		; $55f8
	jr _ghini_subid02@animate		; $55f9

@speeds:
	.db SPEED_80, SPEED_40, SPEED_20

;;
; @addr{55fe}
_ghini_updateMovement:
	call objectApplySpeed		; $55fe
	call _ecom_bounceOffScreenBoundary		; $5601
	ret z			; $5604

;;
; @addr{5605}
_ghini_updateAnimationFromAngle:
	ld h,d			; $5605
	ld l,Enemy.angle		; $5606
	ldd a,(hl)		; $5608
	cp $10			; $5609
	ld a,$01		; $560b
	jr c,+			; $560d
	dec a			; $560f
+
	cp (hl)			; $5610
	ret z			; $5611
	ld (hl),a		; $5612
	jp enemySetAnimation		; $5613

;;
; Sets var30/var31 to target position for subid 2.
;
; Target position seems to always be somewhere around the center of the room, even moreso
; for large rooms.
;
; @addr{5616}
_ghini_chooseTargetPosition:
	ldbc $70,$70		; $5616
	call _ecom_randomBitwiseAndBCE		; $5619
	ld a,b			; $561c
	sub $20			; $561d
	jr nc,+			; $561f
	xor a			; $5621
+
	ld b,a			; $5622

	; b = [wRoomEdgeY]/2 + b - $28
	ld hl,wRoomEdgeY		; $5623
	ldi a,(hl)		; $5626
	srl a			; $5627
	add b			; $5629
	sub $28			; $562a
	ld b,a			; $562c

	; c = [wRoomEdgeX]/2 + c - $38
	ld a,(hl)		; $562d
	srl a			; $562e
	add c			; $5630
	sub $38			; $5631
	ld c,a			; $5633
	ld h,d			; $5634

	ld l,Enemy.var30		; $5635
	ld (hl),b		; $5637
	inc l			; $5638
	ld (hl),c		; $5639
	ret			; $563a


; ==============================================================================
; ENEMYID_BUZZBLOB
;
; Variables:
;   var30: Animation index ($02 if in cukeman form)
;   var31: "pressedAButton" variable (set to $01 when pressed A, only in cukeman form)
; ==============================================================================
enemyCode18:
	call _ecom_checkHazards		; $563b
	jr z,@normalStatus	; $563e
	sub ENEMYSTATUS_NO_HEALTH			; $5640
	jp c,_buzzblob_checkShowText		; $5642
	jp z,enemyDie		; $5645

	dec a			; $5648
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5649

	; Just hit by something

	ld h,d			; $564c
	ld l,Enemy.var2a		; $564d
	ld a,(hl)		; $564f
	cp $80|ITEMCOLLISION_MYSTERY_SEED			; $5650
	jr z,@becomeCukeman	; $5652

	cp $80|ITEMCOLLISION_ELECTRIC_SHOCK			; $5654
	ret nz			; $5656

	; Link hit the buzzblob, go to state $0a
	ld l,Enemy.state		; $5657
	ld (hl),$0a		; $5659

	; Disable scent seeds
	ld l,Enemy.var3f		; $565b
	res 4,(hl)		; $565d

	ld l,Enemy.stunCounter		; $565f
	ld (hl),$00		; $5661
	ld l,Enemy.counter1		; $5663
	ld (hl),60		; $5665
	ld a,$01		; $5667
	jp enemySetAnimation		; $5669


; Buzzblob becomes cukeman when using mystery seed on it.
@becomeCukeman:
	ld l,Enemy.var30		; $566c
	ld a,$02		; $566e
	cp (hl)			; $5670
	ret z			; $5671
	ld (hl),a		; $5672
	call enemySetAnimation		; $5673
	ld e,Enemy.pressedAButton		; $5676
	jp objectAddToAButtonSensitiveObjectList		; $5678

@normalStatus:
	call _buzzblob_checkShowText		; $567b
	call _ecom_checkScentSeedActive		; $567e
	ld e,Enemy.state		; $5681
	ld a,(de)		; $5683
	rst_jumpTable			; $5684
	.dw _buzzblob_state_uninitialized
	.dw _buzzblob_state_stub
	.dw _buzzblob_state_stub
	.dw _buzzblob_state_stub
	.dw _buzzblob_state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _buzzblob_state_stub
	.dw _buzzblob_state_stub
	.dw _buzzblob_state8
	.dw _buzzblob_state9
	.dw _buzzblob_stateA


_buzzblob_state_uninitialized:
	ld a,SPEED_40		; $569b
	call _ecom_setSpeedAndState8AndVisible		; $569d

	; Enable moving toward scent seeds, and...?
	ld l,Enemy.var3f		; $56a0
	ld a,(hl)		; $56a2
	or $30			; $56a3
	ld (hl),a		; $56a5

	ret			; $56a6


_buzzblob_state_scentSeed:
	ld a,(wScentSeedActive)		; $56a7
	or a			; $56aa
	jr nz,++		; $56ab
	ld a,$08		; $56ad
	ld (de),a ; [state] = 8
	jr _buzzblob_animate		; $56b0
++
	call _ecom_updateAngleToScentSeed		; $56b2
	ld e,Enemy.angle		; $56b5
	ld a,(de)		; $56b7
	add $04			; $56b8
	and $18			; $56ba
	ld (de),a		; $56bc
	call _ecom_applyVelocityForSideviewEnemy		; $56bd
	jp enemyAnimate		; $56c0


_buzzblob_state_stub:
	ret			; $56c3


; Choosing a direction and duration to move
_buzzblob_state8:
	ld a,$09		; $56c4
	ld (de),a ; [state] = 9

	; Set random angle and counter1
	ldbc $1c,$30		; $56c7
	call _ecom_randomBitwiseAndBCE		; $56ca
	ld e,Enemy.counter1		; $56cd
	ld a,$30		; $56cf
	add c			; $56d1
	ld (de),a		; $56d2
	ld e,Enemy.angle		; $56d3
	ld a,b			; $56d5
	ld (de),a		; $56d6
	jr _buzzblob_animate		; $56d7


; Moving in some direction for a certain amount of time
_buzzblob_state9:
	call _ecom_decCounter1		; $56d9
	jr z,_buzzblob_chooseNewDirection	; $56dc
	call _ecom_bounceOffWallsAndHoles		; $56de
	call objectApplySpeed		; $56e1
_buzzblob_animate:
	jp enemyAnimate		; $56e4


; "Shocking Link" state
_buzzblob_stateA:
	call _ecom_decCounter1		; $56e7
	jr nz,_buzzblob_animate	; $56ea
	ld e,Enemy.var30		; $56ec
	ld a,(de)		; $56ee
	call enemySetAnimation		; $56ef

_buzzblob_chooseNewDirection:
	ld h,d			; $56f2
	ld l,Enemy.state		; $56f3
	ld (hl),$08 ; Will choose new direction in state 8

	; Enable scent seeds
	ld l,Enemy.var3f		; $56f7
	set 4,(hl)		; $56f9

	ld l,Enemy.collisionType		; $56fb
	set 7,(hl)		; $56fd
	jr _buzzblob_animate		; $56ff

;;
; @addr{5701}
_buzzblob_checkShowText:
	ld e,Enemy.var31		; $5701
	ld a,(de)		; $5703
	or a			; $5704
	ret z			; $5705

	xor a			; $5706
	ld (de),a		; $5707
	call getRandomNumber_noPreserveVars		; $5708
	and $07			; $570b
	add <TX_2f1e			; $570d
	ld c,a			; $570f
	ld b,>TX_2f00		; $5710
	jp showText		; $5712


; ==============================================================================
; ENEMYID_SAND_CRAB
; ==============================================================================
enemyCode1a:
	jr z,@normalStatus	; $5715
	sub ENEMYSTATUS_NO_HEALTH			; $5717
	ret c			; $5719
	jp z,enemyDie		; $571a
	dec a			; $571d
	jp nz,_ecom_updateKnockback		; $571e
	ret			; $5721
@normalStatus:
	call _ecom_checkScentSeedActive		; $5722
	ld e,Enemy.state		; $5725
	ld a,(de)		; $5727
	rst_jumpTable			; $5728
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_switchHook
	.dw @state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	ld h,d			; $573d
	ld l,Enemy.var3f		; $573e
	set 4,(hl)		; $5740
	jp _ecom_setSpeedAndState8AndVisible		; $5742


@state_scentSeed:
	ld a,(wScentSeedActive)		; $5745
	or a			; $5748
	jr nz,++		; $5749
	ld a,$08		; $574b
	ld (de),a ; [state] = 8
	jr @animate		; $574e
++
	call _ecom_updateAngleToScentSeed		; $5750
	ld e,Enemy.angle		; $5753
	ld a,(de)		; $5755
	add $04			; $5756
	and $18			; $5758
	ld (de),a		; $575a

	; Faster when moving left/right instead of up/down
	bit 3,a			; $575b
	ld a,SPEED_40		; $575d
	jr z,+			; $575f
	ld a,SPEED_100		; $5761
+
	ld e,Enemy.speed		; $5763
	ld (de),a		; $5765

	call _ecom_applyVelocityForSideviewEnemy		; $5766
	jr @animate		; $5769


@state_switchHook:
	inc e			; $576b
	ld a,(de)		; $576c
	rst_jumpTable			; $576d
	.dw _ecom_incState2
	.dw @@substate1
	.dw @@substate2
	.dw _ecom_fallToGroundAndSetState8


@@substate1:
@@substate2:
	ret			; $5776


@state_stub:
	ret			; $5777



; Choose random angle to move in
@state8:
	ld a,$09		; $5778
	ld (de),a ; [state] = 9

	; Get random angle & duration for walk
	ldbc $18,$30		; $577b
	call _ecom_randomBitwiseAndBCE		; $577e
	ld e,$86		; $5781
	ld a,$30		; $5783
	add c			; $5785
	ld (de),a		; $5786

	; Faster when moving left/right
	bit 3,b			; $5787
	ld a,SPEED_40		; $5789
	jr z,+			; $578b
	ld a,SPEED_100		; $578d
+
	ld e,$90		; $578f
	ld (de),a		; $5791

	ld e,Enemy.angle		; $5792
	ld a,b			; $5794
	ld (de),a		; $5795
	jr @animate		; $5796


; Moving in direction for [counter1] frames
@state9:
	call _ecom_decCounter1		; $5798
	jr z,++			; $579b
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $579d
	jr nz,@animate	; $57a0
++
	ld e,Enemy.state		; $57a2
	ld a,$08		; $57a4
	ld (de),a		; $57a6
@animate:
	jp enemyAnimate		; $57a7


; ==============================================================================
; ENEMYID_SPINY_BEETLE
;
; Variables:
;   var03: $80 when stationary, $81 when charging Link. Child object (bush or rock) reads
;          this to determine relative Z position. Bit 7 is set to indicate it's grabbable.
;   var3b: Probably unused?
; ==============================================================================
enemyCode1b:
	call _ecom_checkHazards		; $57aa
	jr z,@normalStatus	; $57ad
	sub ENEMYSTATUS_NO_HEALTH			; $57af
	ret c			; $57b1
	jp z,enemyDie		; $57b2

	dec a			; $57b5
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $57b6

	; ENEMYSTATUS_JUST_HIT
	; If Link just hit the enemy, start moving
	ld e,Enemy.var2a		; $57b9
	ld a,(de)		; $57bb
	cp $80|ITEMCOLLISION_LINK			; $57bc
	ret nz			; $57be

	ld e,Enemy.state		; $57bf
	ld a,(de)		; $57c1
	cp $08			; $57c2
	jr nz,@normalStatus	; $57c4
	call _ecom_updateCardinalAngleTowardTarget		; $57c6
	jp @chargeAtLink		; $57c9

@normalStatus:
	ld e,Enemy.state		; $57cc
	ld a,(de)		; $57ce
	rst_jumpTable			; $57cf
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
	; Spawn the bush or rock to hide under
	ld b,ENEMYID_BUSH_OR_ROCK		; $57e8
	call _ecom_spawnUncountedEnemyWithSubid01		; $57ea
	ret nz			; $57ed

	ld e,l			; $57ee
	ld a,(de)		; $57ef
	ld (hl),a ; [child.subid] = [this.subid]

	ld l,Enemy.relatedObj1		; $57f1
	ld a,Enemy.start		; $57f3
	ldi (hl),a		; $57f5
	ld (hl),d		; $57f6

	ld e,Enemy.relatedObj2		; $57f7
	ld (de),a		; $57f9
	inc e			; $57fa
	ld a,h			; $57fb
	ld (de),a		; $57fc

	call objectCopyPosition		; $57fd

	ld a,SPEED_e0		; $5800
	call _ecom_setSpeedAndState8		; $5802

	ld l,Enemy.collisionRadiusY		; $5805
	ld a,$03		; $5807
	ldi (hl),a		; $5809
	ld (hl),a		; $580a

	ld l,Enemy.var03		; $580b
	ld (hl),$80		; $580d

	; Change collisionType only for those hiding under rocks?
	dec l			; $580f
	ld a,(hl)		; $5810
	cp $02			; $5811
	ret c			; $5813

	; Borrow beamos collisions (nothing can kill it until rock is removed)
	ld l,Enemy.collisionType		; $5814
	ld (hl),$80|ENEMYID_BEAMOS		; $5816
	ret			; $5818


@state_switchHook:
	inc e			; $5819
	ld a,(de)		; $581a
	rst_jumpTable			; $581b
	.dw _ecom_incState2
	.dw @@substate1
	.dw @@substate2
	.dw _ecom_fallToGroundAndSetState8

@@substate1:
@@substate2:
	ret			; $5824


@state_stub:
	ret			; $5825


; Waiting for Link to move close enough.
@state8:
	call @checkBushOrRockGone		; $5826
	ret z			; $5829
	call _ecom_decCounter2		; $582a
	ret nz			; $582d

	ld b,$0c		; $582e
	call objectCheckCenteredWithLink		; $5830
	ret nc			; $5833

	call _ecom_updateCardinalAngleTowardTarget		; $5834
	or a			; $5837
	ret z ; For some reason he never moves up?

	ld a,$01		; $5839
	call _ecom_getTopDownAdjacentWallsBitset		; $583b
	ret nz			; $583e


@chargeAtLink:
	call _ecom_incState ; [state] = 9
	ld l,Enemy.counter1		; $5842
	ld (hl),$38		; $5844
	ld l,Enemy.var03		; $5846
	ld (hl),$81		; $5848
	jp objectSetVisiblec3		; $584a


; Moving toward Link
@state9:
	call @checkBushOrRockGone		; $584d
	ret z			; $5850
	call _ecom_decCounter1		; $5851
	jr z,++			; $5854
	call _ecom_applyVelocityForTopDownEnemyNoHoles		; $5856
	jr nz,@animate	; $5859
++
	ld h,d			; $585b
	ld l,Enemy.counter2		; $585c
	ld (hl),30		; $585e

	ld l,Enemy.state		; $5860
	dec (hl)		; $5862

	ld l,Enemy.var03		; $5863
	ld (hl),$80		; $5865
	ld l,Enemy.var3b		; $5867
	ld (hl),$00		; $5869

	jp objectSetInvisible		; $586b


; Just lost protection (bush or rock).
@stateA:
	call _ecom_decCounter1		; $586e
	jr nz,@animate	; $5871
	inc (hl)		; $5873
	ld l,e			; $5874
	inc (hl)		; $5875
	jr @animate		; $5876


; Moving around randomly after losing protection.
@stateB:
	call _ecom_decCounter1		; $5878
	jr nz,++		; $587b

	ld (hl),40		; $587d
	call getRandomNumber_noPreserveVars		; $587f
	and $1c			; $5882
	ld e,Enemy.angle		; $5884
	ld (de),a		; $5886
	jr @animate		; $5887
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5889
@animate:
	jp enemyAnimate		; $588c


;;
; Checks if the object we're hiding under is gone; if so, updates collisionType,
; collisiosRadius, visibility, and sets state to $0a
;
; @param[out]	zflag	z if the object it's hiding under is gone
; @addr{588f}
@checkBushOrRockGone:
	ld e,Enemy.relatedObj2+1		; $588f
	ld a,(de)		; $5891
	or a			; $5892
	ret nz			; $5893

	ld h,d			; $5894
	ld l,Enemy.state		; $5895
	ld (hl),$0a		; $5897
	ld l,Enemy.counter1		; $5899
	ld (hl),60		; $589b

	; Restore normal collisions
	ld l,Enemy.collisionType		; $589d
	ld (hl),$80|ENEMYID_SPINY_BEETLE		; $589f

	ld l,Enemy.collisionRadiusY		; $58a1
	ld a,$06		; $58a3
	ldi (hl),a		; $58a5
	ld (hl),a		; $58a6
	call objectSetVisiblec3		; $58a7
	xor a			; $58aa
	ret			; $58ab

; ==============================================================================
; ENEMYID_ARMOS
;
; Variables:
;   subid: If bit 7 is set, it's a real armos; otherwise it's an armos spawner.
;   var31: The initial position of the armos (subid 1 only)
; ==============================================================================
enemyCode1d:
	call _ecom_checkHazards		; $58ac
	jr z,@normalStatus	; $58af
	sub ENEMYSTATUS_NO_HEALTH			; $58b1
	ret c			; $58b3
	jp z,_armos_dead		; $58b4

	dec a			; $58b7
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $58b8

	; ENEMYSTATUS_JUST_HIT

	; For subid $80, if Link touches this position, activate the armos.
	ld e,Enemy.var2a		; $58bb
	ld a,(de)		; $58bd
	cp $80|ITEMCOLLISION_LINK			; $58be
	ret nz			; $58c0

	ld e,Enemy.subid		; $58c1
	ld a,(de)		; $58c3
	cp $80			; $58c4
	jr nz,@normalStatus	; $58c6

	ld h,d			; $58c8
	ld l,Enemy.state		; $58c9
	ld a,(hl)		; $58cb
	cp $09			; $58cc
	jr nc,@normalStatus	; $58ce
	ld (hl),$09		; $58d0
	ret			; $58d2

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $58d3
	jr nc,@normalState	; $58d6
	rst_jumpTable			; $58d8
	.dw _armos_uninitialized
	.dw _armos_state1
	.dw _armos_state_stub
	.dw _armos_state_switchHook
	.dw _armos_state_stub
	.dw _armos_state_stub
	.dw _armos_state_stub
	.dw _armos_state_stub

@normalState:
	res 7,b			; $58e9
	ld a,b			; $58eb
	rst_jumpTable			; $58ec
	.dw _armos_subid00
	.dw _armos_subid01


_armos_uninitialized:
	ld a,b			; $58f1
	bit 7,a			; $58f2
	jr z,@gotoState1	; $58f4

	add a			; $58f6
	ld hl,@oamFlagsAndSpeeds		; $58f7
	rst_addAToHl			; $58fa
	ld e,Enemy.oamFlags		; $58fb
	ldi a,(hl)		; $58fd
	ld (de),a		; $58fe
	dec e			; $58ff
	ld (de),a		; $5900
	ld a,(hl)		; $5901
	call _ecom_setSpeedAndState8		; $5902

	; Subid 1 gets more health
	ld l,Enemy.subid		; $5905
	bit 0,(hl)		; $5907
	jr z,+			; $5909
	ld l,Enemy.health		; $590b
	inc (hl)		; $590d
+
	; Effectively disable collisions
	ld l,Enemy.collisionType		; $590e
	ld (hl),$80|ENEMYID_PODOBOO		; $5910
	ret			; $5912

@gotoState1:
	ld a,$01		; $5913
	ld (de),a		; $5915
	ret			; $5916

@oamFlagsAndSpeeds:
	.db $05, SPEED_80 ; subid 0
	.db $04, SPEED_c0 ; subid 1


; For subid where bit 7 isn't set; spawn armos at all positions where their tiles are.
; (Enemy.yh currently contains the tile to replace, Enemy.xh is the new tile it becomes.)
_armos_state1:
	ld e,Enemy.yh		; $591b
	ld a,(de)		; $591d
	ld b,a			; $591e
	ld hl,wRoomLayout		; $591f
	ld c,LARGE_ROOM_HEIGHT<<4		; $5922
--
	ld a,(hl)		; $5924
	cp b			; $5925
	call z,_armos_spawnArmosAtPosition		; $5926
	inc l			; $5929
	dec c			; $592a
	jr nz,--		; $592b

	call _armos_clearKilledArmosBuffer		; $592d
	call decNumEnemies		; $5930
	jp enemyDelete		; $5933


_armos_state_switchHook:
	inc e			; $5936
	ld a,(de)		; $5937
	rst_jumpTable			; $5938
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3


@substate1:
@substate2:
	ret			; $5941

@substate3:
	ld b,$0b		; $5942
	jp _ecom_fallToGroundAndSetState		; $5944


_armos_state_stub:
	ret			; $5947


_armos_subid00:
	ld a,(de)		; $5948
	sub $08			; $5949
	rst_jumpTable			; $594b
	.dw _armos_subid00_state8
	.dw _armos_state9
	.dw _armos_subid00_stateA
	.dw _armos_subid00_stateB
	.dw _armos_subid00_stateC

; Waiting for Link to touch the statue (or for "$cca2" trigger?)
_armos_subid00_state8:
	ld a,(wcca2)		; $5956
	or a			; $5959
	ret z			; $595a
	ld a,$09		; $595b
	ld (de),a		; $595d
	ret			; $595e


; The statue was just activated
_armos_state9:
	ld h,d			; $595f
	ld l,e			; $5960
	inc (hl) ; [state] = $0a
	ld l,Enemy.counter1		; $5962
	ld (hl),60		; $5964
	ld l,Enemy.yh		; $5966
	inc (hl)		; $5968
	inc (hl)		; $5969
	jp objectSetVisible82		; $596a


; Flickering until it starts moving
_armos_subid00_stateA:
	call _ecom_decCounter1		; $596d
	jp nz,_ecom_flickerVisibility		; $5970

	ld a,ENEMYCOLLISION_ACTIVE_RED_ARMOS		; $5973

;;
; @param	a	EnemyCollisionMode
; @addr{5975}
_armos_beginMoving:
	ld l,e			; $5975
	inc (hl) ; [state] = $0b

	; Enable normal collisions
	ld l,Enemy.collisionType		; $5977
	ld (hl),$80|ENEMYID_ARMOS		; $5979

	inc l			; $597b
	ldi (hl),a ; Set enemyCollisionMode

	; Set collisionRadiusY/X
	ld a,$06		; $597d
	ldi (hl),a		; $597f
	ld (hl),a		; $5980

	call _armos_replaceTileUnderSelf		; $5981
	jp objectSetVisiblec2		; $5984


; Choose a direction to move
_armos_subid00_stateB:
	ld h,d			; $5987
	ld l,e			; $5988
	inc (hl) ; [state] = $0c

	ld l,Enemy.counter1		; $598a
	ld (hl),61		; $598c
	call _ecom_setRandomCardinalAngle		; $598e


; Moving in some direction for [counter1] frames
_armos_subid00_stateC:
	call _ecom_decCounter1		; $5991
	call nz,_ecom_applyVelocityForTopDownEnemyNoHoles		; $5994
	jr nz,++		; $5997
	ld e,Enemy.state		; $5999
	ld a,$0b		; $599b
	ld (de),a		; $599d
++
	jp enemyAnimate		; $599e


_armos_subid01:
	ld a,(de)		; $59a1
	sub $08			; $59a2
	rst_jumpTable			; $59a4
	.dw _armos_subid01_state8
	.dw _armos_state9
	.dw _armos_subid01_stateA
	.dw _armos_subid02_stateB
	.dw _armos_subid03_stateC


; Waiting for Link to approach the statue
_armos_subid01_state8:
	call _armos_subid00_state8		; $59af
	ret nz			; $59b2

	ld h,d			; $59b3
	ld l,Enemy.yh		; $59b4
	ldh a,(<hEnemyTargetY)	; $59b6
	sub (hl)		; $59b8
	add $18			; $59b9
	cp $31			; $59bb
	ret nc			; $59bd

	ld b,(hl)		; $59be
	ld l,Enemy.xh		; $59bf
	ldh a,(<hEnemyTargetX)	; $59c1
	sub (hl)		; $59c3
	add $18			; $59c4
	cp $31			; $59c6
	ret nc			; $59c8

	; Link has gotten close enough; activate the armos.
	ld a,(hl)		; $59c9
	and $f0			; $59ca
	swap a			; $59cc
	ld c,a			; $59ce
	ld a,b			; $59cf
	and $f0			; $59d0
	or c			; $59d2
	ld l,Enemy.var31		; $59d3
	ld (hl),a		; $59d5

	ld l,e			; $59d6
	inc (hl) ; [state] = 9
	ret			; $59d8


; Flickering until it starts moving
_armos_subid01_stateA:
	call _ecom_decCounter1		; $59d9
	jp nz,_ecom_flickerVisibility		; $59dc
	ld a,ENEMYCOLLISION_ACTIVE_BLUE_ARMOS		; $59df
	jp _armos_beginMoving		; $59e1


; Choose random new direction & amount of time to move in that direction
_armos_subid02_stateB:
	ld a,$0c		; $59e4
	ld (de),a ; [state] = $0c

	; Get counter1
	ldbc $03,$03		; $59e7
	call _ecom_randomBitwiseAndBCE		; $59ea
	ld a,b			; $59ed
	ld hl,@counter1Vals		; $59ee
	rst_addAToHl			; $59f1
	ld e,Enemy.counter1		; $59f2
	ld a,(hl)		; $59f4
	ld (de),a		; $59f5

	; 1 in 4 chance of moving directly toward Link
	ld a,c			; $59f6
	or a			; $59f7
	jp z,_ecom_updateCardinalAngleTowardTarget		; $59f8
	jp _ecom_setRandomCardinalAngle		; $59fb

@counter1Vals:
	.db 30, 45, 60, 75


; Moving in some direction for [counter1] frames
_armos_subid03_stateC:
	call _ecom_decCounter1		; $5a02
	jr z,++			; $5a05
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5a07
	jr z,++			; $5a0a
	jp enemyAnimate		; $5a0c
++
	ld e,Enemy.state		; $5a0f
	ld a,$0b		; $5a11
	ld (de),a		; $5a13
	ret			; $5a14

;;
; @param	l	Position to spawn at
; @addr{5a15}
_armos_spawnArmosAtPosition:
	push bc			; $5a15
	push hl			; $5a16
	ld c,l			; $5a17

	ld b,ENEMYID_ARMOS		; $5a18
	call _ecom_spawnEnemyWithSubid01		; $5a1a
	jr nz,@ret	; $5a1d

	ld e,l			; $5a1f
	ld a,(de)		; $5a20
	set 7,a			; $5a21
	ld (hl),a ; [child.subid] = [this.subid]|$80

	; [child.var30] = [this.xh] = tile to replace underneath new armos
	ld e,Enemy.xh		; $5a24
	ld l,Enemy.var30		; $5a26
	ld a,(de)		; $5a28
	ld (hl),a		; $5a29

	; Take short-form position in 'c', write to child's position
	ld l,e			; $5a2a
	ld a,c			; $5a2b
	and $0f			; $5a2c
	swap a			; $5a2e
	add $08			; $5a30
	ldd (hl),a		; $5a32
	dec l			; $5a33
	ld a,c			; $5a34
	and $f0			; $5a35
	add $06			; $5a37
	ld (hl),a		; $5a39
@ret:
	pop hl			; $5a3a
	pop bc			; $5a3b
	ret			; $5a3c

;;
; @addr{5a3d}
_armos_dead:
	ld e,Enemy.subid		; $5a3d
	ld a,(de)		; $5a3f
	rrca			; $5a40
	jp nc,enemyDie		; $5a41

	; Subid 1 only: record the initial position of the armos that was killed.
	ld e,Enemy.var31		; $5a44
	ld a,(de)		; $5a46
	ld b,a			; $5a47
	ld hl,wTmpcfc0.armosStatue.killedArmosPositions-1		; $5a48
--
	inc l			; $5a4b
	ld a,(hl)		; $5a4c
	or a			; $5a4d
	jr nz,--		; $5a4e
	ld (hl),b		; $5a50
	jp enemyDie		; $5a51

;;
; @addr{5a54}
_armos_clearKilledArmosBuffer:
	ld hl,wTmpcfc0.armosStatue.killedArmosPositions		; $5a54
	xor a			; $5a57
	ld b,$04		; $5a58
--
	ldi (hl),a		; $5a5a
	ldi (hl),a		; $5a5b
	ldi (hl),a		; $5a5c
	ldi (hl),a		; $5a5d
	dec b			; $5a5e
	jr nz,--		; $5a5f
	ret			; $5a61

;;
; Replace the tile underneath the armos with [var30].
; @addr{5a62}
_armos_replaceTileUnderSelf:
	call objectGetTileAtPosition		; $5a62
	ld c,l			; $5a65
	ld e,Enemy.var30		; $5a66
	ld a,(de)		; $5a68
	jp setTile		; $5a69


; ==============================================================================
; ENEMYID_PIRANHA
;
; Variables:
;   zh: Equals 2 when underwater
;   var30: Current animation index
; ==============================================================================
enemyCode1e:
	jr z,@normalStatus	; $5a6c
	sub $03			; $5a6e
	jr c,@stunned	; $5a70
	jp z,enemyDie		; $5a72
	dec a			; $5a75
	ret z			; $5a76

	; ENEMYSTATUS_KNOCKBACK

	ld e,Enemy.speed		; $5a77
	ld a,SPEED_200		; $5a79
	ld (de),a		; $5a7b
	call _fish_getAdjacentWallsBitsetForKnockback		; $5a7c

	ld e,Enemy.knockbackAngle		; $5a7f
	call _ecom_applyVelocityGivenAdjacentWalls		; $5a81

	ld e,Enemy.speed		; $5a84
	ld a,SPEED_c0		; $5a86
	ld (de),a		; $5a88
	ret			; $5a89

@stunned:
	ld e,Enemy.zh		; $5a8a
	ld a,(de)		; $5a8c
	cp $02			; $5a8d
	ret z			; $5a8f
	or a			; $5a90
	ret nz			; $5a91
	jp _fish_enterWater		; $5a92

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5a95
	jr nc,@normalState	; $5a98
	rst_jumpTable			; $5a9a
	.dw _fish_state_uninitialized
	.dw _fish_state_stub
	.dw _fish_state_stub
	.dw _fish_state_stub
	.dw _fish_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _fish_state_stub
	.dw _fish_state_stub

@normalState:
	ld a,b			; $5aab
	rst_jumpTable			; $5aac
	.dw _fish_subid00
	.dw _fish_subid01


_fish_state_uninitialized:
	ld a,SPEED_80		; $5ab1
	call _ecom_setSpeedAndState8		; $5ab3
	call objectSetVisible83		; $5ab6

	ld l,Enemy.zh		; $5ab9
	ld (hl),$02		; $5abb
	ld l,Enemy.angle		; $5abd
	ld (hl),ANGLE_RIGHT		; $5abf

	call _fish_setRandomCounter1		; $5ac1
	jp _fish_updateAnimationFromAngle		; $5ac4


_fish_state_stub:
	ret			; $5ac7


_fish_subid00:
	ld a,(de)		; $5ac8
	sub $08			; $5ac9
	rst_jumpTable			; $5acb
	.dw @state8
	.dw @state9


; Moving below water.
@state8:
	ld a,(wScentSeedActive)		; $5ad0
	or a			; $5ad3
	jr nz,++		; $5ad4
	call _ecom_decCounter1		; $5ad6
	jr z,@leapOutOfWater		; $5ad9
++
	call _fish_updatePosition		; $5adb
	jp _fish_checkReverseAngle		; $5ade

@leapOutOfWater:
	ld l,e			; $5ae1
	inc (hl)		; $5ae2
	ld l,Enemy.enemyCollisionMode		; $5ae3
.ifdef ROM_AGES
	ld (hl),ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY		; $5ae5
.else
	ld (hl),ENEMYCOLLISION_STANDARD_ENEMY		; $5ae5
.endif
	ld l,Enemy.zh		; $5ae7
	ld (hl),$00		; $5ae9

	ld l,Enemy.speedZ		; $5aeb
	ld a,<(-$180)		; $5aed
	ldi (hl),a		; $5aef
	ld (hl),>(-$180)		; $5af0

	ld l,Enemy.speed		; $5af2
	ld (hl),SPEED_c0		; $5af4
	ld b,INTERACID_SPLASH		; $5af6
	call objectCreateInteractionWithSubid00		; $5af8
	call objectSetVisiblec1		; $5afb
	ld b,$00		; $5afe
	jp _fish_setAnimation		; $5b00


; Leaping outside the water.
@state9:
	ld c,$10		; $5b03
	call objectUpdateSpeedZ_paramC		; $5b05
	jr z,_fish_enterWater	; $5b08

	ld l,Enemy.speedZ		; $5b0a
	ld a,(hl)		; $5b0c
	or a			; $5b0d
	jr nz,++		; $5b0e
	inc l			; $5b10
	ld a,(hl)		; $5b11
	or a			; $5b12
	jr nz,++		; $5b13
	ld b,$01		; $5b15
	call _fish_setAnimation		; $5b17
++
	jp _fish_updatePosition		; $5b1a


;;
; @addr{5b1d}
_fish_enterWater:
	ld h,d			; $5b1d
	ld l,Enemy.enemyCollisionMode		; $5b1e
	ld (hl),ENEMYCOLLISION_PODOBOO		; $5b20
	ld l,Enemy.zh		; $5b22
	ld (hl),$02		; $5b24

	ld l,Enemy.state		; $5b26
	ld (hl),$08		; $5b28

	ld l,Enemy.speed		; $5b2a
	ld (hl),SPEED_80		; $5b2c

	call _fish_setRandomCounter1		; $5b2e
	ld b,INTERACID_SPLASH		; $5b31
	call objectCreateInteractionWithSubid00		; $5b33
	call objectSetVisible83		; $5b36
	jp _fish_updateAnimationFromAngle		; $5b39



_fish_subid01:
	ld a,(de)		; $5b3c
	sub $08			; $5b3d
	rst_jumpTable			; $5b3f
	.dw @state8

@state8:
	ret			; $5b42

;;
; @param	cflag	c if we were able to move
; @addr{5b43}
_fish_checkReverseAngle:
	ret c			; $5b43
	ld e,Enemy.angle		; $5b44
	ld a,(de)		; $5b46
	xor $10			; $5b47
	ld (de),a		; $5b49

;;
; @addr{5b4a}
_fish_updateAnimationFromAngle:
	ld e,Enemy.angle		; $5b4a
	ld a,(de)		; $5b4c
	swap a			; $5b4d
	rlca			; $5b4f
	ld hl,@animations		; $5b50
	rst_addAToHl			; $5b53
	ld a,(hl)		; $5b54
	ld h,d			; $5b55
	ld l,Enemy.var30		; $5b56
	cp (hl)			; $5b58
	ret z			; $5b59
	ld (hl),a		; $5b5a
	jp enemySetAnimation		; $5b5b

@animations:
	.db $02 $01 $02 $00

;;
; Sets animation (3 or 5 is added to value passed if we're moving right or left)
;
; @param	b	Value to add to animation index
; @addr{5b62}
_fish_setAnimation:
	ld e,Enemy.angle		; $5b62
	ld a,(de)		; $5b64
	swap a			; $5b65
	and $01			; $5b67
	ld a,$03		; $5b69
	jr nz,+			; $5b6b
	ld a,$05		; $5b6d
+
	add b			; $5b6f
	ld h,d			; $5b70
	ld l,Enemy.var30		; $5b71
	cp (hl)			; $5b73
	ret z			; $5b74
	ld (hl),a		; $5b75
	jp enemySetAnimation		; $5b76


;;
; @param[out]	cflag	c if we were able to move (tile in front of us is traversable)
; @addr{5b79}
_fish_updatePosition:
	ld e,Enemy.angle		; $5b79
	ld a,(de)		; $5b7b
	rrca			; $5b7c
	rrca			; $5b7d
	ld hl,@directionOffsets		; $5b7e
	rst_addAToHl			; $5b81

	ld e,Enemy.yh		; $5b82
	ld a,(de)		; $5b84
	add (hl)		; $5b85
	and $f0			; $5b86
	ld c,a			; $5b88

	inc hl			; $5b89
	ld e,Enemy.xh		; $5b8a
	ld a,(de)		; $5b8c
	add (hl)		; $5b8d
	and $f0			; $5b8e
	swap a			; $5b90

	or c			; $5b92
	ld c,a			; $5b93
	ld b,>wRoomLayout		; $5b94
	ld a,(bc)		; $5b96
	sub TILEINDEX_PUDDLE			; $5b97
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1			; $5b99
	ret nc			; $5b9b
	call objectApplySpeed		; $5b9c
	scf			; $5b9f
	ret			; $5ba0

@directionOffsets:
	.db $f0 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0

;;
; @addr{5ba9}
_fish_setRandomCounter1:
	call getRandomNumber_noPreserveVars		; $5ba9
	and $03			; $5bac
	ld hl,@counter1Vals		; $5bae
	rst_addAToHl			; $5bb1
	ld e,Enemy.counter1		; $5bb2
	ld a,(hl)		; $5bb4
	ld (de),a		; $5bb5
	ret			; $5bb6

@counter1Vals:
	.db $40 $50 $60 $70

;;
; Gets the "adjacent walls bitset" for the fish; since this swims, water is traversable,
; everything else is not.
;
; This is identical to "_waterTektite_getAdjacentWallsBitsetGivenAngle".
;
; @param[out]	hFF8B	Bitset of adjacent walls
; @addr{5bbb}
_fish_getAdjacentWallsBitsetForKnockback:
	ld e,Enemy.knockbackAngle		; $5bbb
	ld a,(de)		; $5bbd
	call _ecom_getAdjacentWallTableOffset		; $5bbe

	ld h,d			; $5bc1
	ld l,Enemy.yh		; $5bc2
	ld b,(hl)		; $5bc4
	ld l,Enemy.xh		; $5bc5
	ld c,(hl)		; $5bc7
	ld hl,_ecom_sideviewAdjacentWallOffsetTable		; $5bc8
	rst_addAToHl			; $5bcb

	ld a,$10		; $5bcc
	ldh (<hFF8B),a	; $5bce
	ld d,>wRoomLayout		; $5bd0
---
	ldi a,(hl)		; $5bd2
	add b			; $5bd3
	ld b,a			; $5bd4
	and $f0			; $5bd5
	ld e,a			; $5bd7
	ldi a,(hl)		; $5bd8
	add c			; $5bd9
	ld c,a			; $5bda
	and $f0			; $5bdb
	swap a			; $5bdd
	or e			; $5bdf
	ld e,a			; $5be0
	ld a,(de)		; $5be1
	sub TILEINDEX_PUDDLE			; $5be2
	cp TILEINDEX_FD-TILEINDEX_PUDDLE+1			; $5be4
	ldh a,(<hFF8B)	; $5be6
	rla			; $5be8
	ldh (<hFF8B),a	; $5be9
	jr nc,---		; $5beb

	xor $0f			; $5bed
	ldh (<hFF8B),a	; $5bef
	ldh a,(<hActiveObject)	; $5bf1
	ld d,a			; $5bf3
	ret			; $5bf4


; ==============================================================================
; ENEMYID_POLS_VOICE
;
; Variables:
;   var30: gravity
; ==============================================================================
enemyCode23:
	call _ecom_checkHazardsNoAnimationForHoles		; $5bf5
	call _polsVoice_checkLinkPlayingInstrument		; $5bf8
	jr z,@normalStatus	; $5bfb
	sub ENEMYSTATUS_NO_HEALTH			; $5bfd
	ret c			; $5bff
	jp z,enemyDie		; $5c00

	dec a			; $5c03
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5c04
	ret			; $5c07

@normalStatus:
	ld e,Enemy.state		; $5c08
	ld a,(de)		; $5c0a
	rst_jumpTable			; $5c0b
	.dw _polsVoice_state_uninitialized
	.dw _polsVoice_state_stub
	.dw _polsVoice_state_stub
	.dw _polsVoice_state_stub
	.dw _polsVoice_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _polsVoice_state_stub
	.dw _polsVoice_state_stub
	.dw _polsVoice_state8
	.dw _polsVoice_state9

_polsVoice_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call _ecom_setSpeedAndState8		; $5c20

	call getRandomNumber_noPreserveVars		; $5c23
	ld e,Enemy.counter1		; $5c26
	and $3f			; $5c28
	inc a			; $5c2a
	ld (de),a		; $5c2b
	jr _polsVoice_setLandedAnimation		; $5c2c


_polsVoice_state_stub:
	ret			; $5c2e


_polsVoice_state8:
	call _ecom_decCounter1		; $5c2f
	ret nz			; $5c32

	ld l,e			; $5c33
	inc (hl) ; [state] = 9

	; Randomly read in 3 speed values: speedZ, gravity (var30), and speed.
	ld bc,$0f1c		; $5c35
	call _ecom_randomBitwiseAndBCE		; $5c38
	or b			; $5c3b
	ld hl,@jumpSpeeds1		; $5c3c
	jr nz,+			; $5c3f
	ld hl,@jumpSpeeds2		; $5c41
+
	ld e,Enemy.speedZ		; $5c44
	ldi a,(hl)		; $5c46
	ld (de),a		; $5c47
	inc e			; $5c48
	ldi a,(hl)		; $5c49
	ld (de),a		; $5c4a

	; [var30] = gravity
	ld e,Enemy.var30		; $5c4b
	ldi a,(hl)		; $5c4d
	ld (de),a		; $5c4e

	ld e,Enemy.speed		; $5c4f
	ld a,(hl)		; $5c51
	ld (de),a		; $5c52
	cp SPEED_80			; $5c53
	jr z,++			; $5c55

	; For high speed jump, target Link directly instead of using a random angle
	call objectGetAngleTowardEnemyTarget		; $5c57
	add $02			; $5c5a
	and $1c			; $5c5c
	ld c,a			; $5c5e
++
	ld e,Enemy.angle		; $5c5f
	ld a,c			; $5c61
	ld (de),a		; $5c62
	xor a			; $5c63
	call enemySetAnimation		; $5c64
	jp objectSetVisiblec1		; $5c67


; Word: Initial speedZ
; Byte: gravity
; Byte: speed
@jumpSpeeds1:
	dwbb -$128, $0c, SPEED_80
@jumpSpeeds2:
	dwbb -$180, $0c, SPEED_c0


_polsVoice_state9:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5c72
	ld e,Enemy.var30		; $5c75
	ld a,(de)		; $5c77
	ld c,a			; $5c78
	call objectUpdateSpeedZ_paramC		; $5c79
	ret nz			; $5c7c

	; Landed
	ld h,d			; $5c7d
	ld l,Enemy.state		; $5c7e
	dec (hl) ; [state] = 8
	ld l,Enemy.counter1		; $5c81
	ld (hl),$20		; $5c83

_polsVoice_setLandedAnimation:
	ld a,$01		; $5c85
	call enemySetAnimation		; $5c87
	jp objectSetVisiblec2		; $5c8a

;;
; @param	a	Enemy status
; @param[out]	a	Updated enemy status
; @addr{5c8d}
_polsVoice_checkLinkPlayingInstrument:
	ld b,a			; $5c8d
	ld a,(wLinkPlayingInstrument)		; $5c8e
	or a			; $5c91
	jr z,+			; $5c92
	ld b,ENEMYSTATUS_NO_HEALTH		; $5c94
+
	ld a,b			; $5c96
	or a			; $5c97
	ret			; $5c98


; ==============================================================================
; ENEMYID_LIKE_LIKE
;
; Variables:
;   relatedObj1: Pointer to the like-like spawner (subid 1), if one exists.
;   var30: Number of like-likes on-screen (for subid 1)
; ==============================================================================
enemyCode24:
	call _likelike_checkHazards		; $5c99
	jr z,@normalStatus	; $5c9c
	sub ENEMYSTATUS_NO_HEALTH			; $5c9e
	ret c			; $5ca0
	jr z,@dead	; $5ca1

	dec a			; $5ca3
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5ca4

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a		; $5ca7
	ld a,(de)		; $5ca9
	cp $80|ITEMCOLLISION_LINK			; $5caa
	ret nz			; $5cac

	; Just collided with Link. omnomnom
	ld h,d			; $5cad
	ld l,Enemy.yh		; $5cae
	ldi a,(hl)		; $5cb0
	ld b,a			; $5cb1
	inc l			; $5cb2
	ld c,(hl)		; $5cb3

	; Don't eat him if Link would (somehow) get stuck in a wall
.ifdef ROM_AGES
	callab bank5.checkPositionSurroundedByWalls		; $5cb4
.else
	callab bank5.seasonsFunc_05_5d74		; $5cb4
.endif
	rl b			; $5cbc
	jp c,_likelike_releaseLink		; $5cbe

	ld e,Enemy.subid		; $5cc1
	ld a,(de)		; $5cc3
	or a			; $5cc4
	ld a,$0b		; $5cc5
	jr z,+			; $5cc7
	inc a			; $5cc9
+
	ld h,d			; $5cca
	ld l,Enemy.state		; $5ccb
	ldi (hl),a		; $5ccd
	inc l			; $5cce
	ld (hl),$00 ; [counter1] = 0
	inc l			; $5cd1
	ld (hl),90  ; [counter2] = 90

	ld l,Enemy.collisionType		; $5cd4
	res 7,(hl)		; $5cd6

	; Link copies Likelike's position
	ld hl,w1Link		; $5cd8
	call objectCopyPosition		; $5cdb

	ld l,<w1Link.collisionType		; $5cde
	res 7,(hl)		; $5ce0

	ld a,$01		; $5ce2
	call enemySetAnimation		; $5ce4
	jp objectSetVisiblec1		; $5ce7


@dead:
	; Decrement spawner's counter
	ld e,Enemy.relatedObj1+1		; $5cea
	ld a,(de)		; $5cec
	or a			; $5ced
	jp z,enemyDie		; $5cee

	ld h,a			; $5cf1
	ld l,Enemy.var30		; $5cf2
	dec (hl)		; $5cf4
	jp enemyDie		; $5cf5


@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5cf8
	jr nc,@normalState	; $5cfb
	rst_jumpTable			; $5cfd
	.dw _likelike_state_uninitialized
	.dw _likelike_state_stub
	.dw _likelike_state_stub
	.dw _likelike_state_switchHook
	.dw _likelike_state_stub
	.dw _likelike_state_galeSeed
	.dw _likelike_state_stub
	.dw _likelike_state_stub

@normalState:
	ld a,b			; $5d0e
	rst_jumpTable			; $5d0f
	.dw _likelike_subid00
	.dw _likelike_subid01
	.dw _likelike_subid02
	.dw _likelike_subid03


_likelike_state_uninitialized:
	bit 0,b			; $5d18
	call z,objectSetVisiblec2		; $5d1a
	ld a,SPEED_40		; $5d1d
	jp _ecom_setSpeedAndState8		; $5d1f


_likelike_state_switchHook:
	inc e			; $5d22
	ld a,(de)		; $5d23
	rst_jumpTable			; $5d24
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $5d2d

@substate3:
	ld e,Enemy.subid		; $5d2e
	ld a,(de)		; $5d30
	ld hl,@defaultStates		; $5d31
	rst_addAToHl			; $5d34
	ld b,(hl)		; $5d35
	jp _ecom_fallToGroundAndSetState		; $5d36

@defaultStates:
	.db $09 $08 $0a $0a


_likelike_state_galeSeed:
	call _ecom_galeSeedEffect		; $5d3d
	ret c			; $5d40

	; Decrement spawner's counter
	ld e,Enemy.relatedObj1+1		; $5d41
	ld a,(de)		; $5d43
	or a			; $5d44
	jr z,++			; $5d45
	ld h,a			; $5d47
	ld l,Enemy.var30		; $5d48
	dec (hl)		; $5d4a
++
	call decNumEnemies		; $5d4b
	jp enemyDelete		; $5d4e


_likelike_state_stub:
	ret			; $5d51


_likelike_subid00:
	ld a,(de)		; $5d52
	sub $08			; $5d53
	rst_jumpTable			; $5d55
	.dw _likelike_subid00_state8
	.dw _likelike_state9
	.dw _likelike_stateA
	.dw _likelike_stateB
	.dw _likelike_stateC


; Initialization
_likelike_subid00_state8:
	ld h,d			; $5d60
	ld l,e			; $5d61
	inc (hl) ; [state]++
	ld l,Enemy.collisionType		; $5d63
	set 7,(hl)		; $5d65


; Choosing a new direction & duration
_likelike_state9:
	ld h,d			; $5d67
	ld l,e			; $5d68
	inc (hl) ; [state]++

	ldbc $18,$30		; $5d6a
	call _ecom_randomBitwiseAndBCE		; $5d6d
	ld e,Enemy.angle		; $5d70
	ld a,b			; $5d72
	ld (de),a		; $5d73
	ld e,Enemy.counter1		; $5d74
	ld a,$38		; $5d76
	add c			; $5d78
	ld (de),a		; $5d79
	jr _likelike_animate		; $5d7a


; Moving in some direction for [counter1] frames
_likelike_stateA:
	call _ecom_decCounter1		; $5d7c
	jr nz,@move	; $5d7f

@newDirection:
	ld h,d			; $5d81
	ld l,Enemy.state		; $5d82
	dec (hl)		; $5d84
	jr _likelike_animate		; $5d85

@move:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5d87
	jr z,@newDirection	; $5d8a

_likelike_animate:
	jp enemyAnimate		; $5d8c


; Eating Link
_likelike_stateB:
	call _ecom_decCounter2		; $5d8f
	jr z,@releaseLink	; $5d92

	; Mashing 19 buttons before being released prevents like-like from eating shield
	ld a,(wGameKeysJustPressed)		; $5d94
	or a			; $5d97
	jr z,_likelike_animate	; $5d98
	dec l			; $5d9a
	inc (hl) ; [counter1]++
	jr _likelike_animate		; $5d9c

@releaseLink:
	ld (hl),60		; $5d9e

	ld l,Enemy.state		; $5da0
	inc (hl)		; $5da2

	ld l,Enemy.counter1		; $5da3
	ld a,(hl)		; $5da5
	cp 19			; $5da6
	jr nc,++		; $5da8
	ld a,TREASURE_SHIELD		; $5daa
	call checkTreasureObtained		; $5dac
	jr nc,++		; $5daf

	ld a,TREASURE_SHIELD		; $5db1
	call loseTreasure		; $5db3
	ld bc,TX_510b		; $5db6
	call showText		; $5db9
++
	call getRandomNumber_noPreserveVars		; $5dbc
	and $18			; $5dbf
	ld e,Enemy.angle		; $5dc1
	ld (de),a		; $5dc3
	call objectSetVisiblec2		; $5dc4

;;
; @addr{5dc7}
_likelike_releaseLink:
	; Release link from LINK_STATE_GRABBED
	ld hl,w1Link.state2		; $5dc7
	ld (hl),$04		; $5dca

	ld l,<w1Link.collisionType		; $5dcc
	set 7,(hl)		; $5dce
	xor a			; $5dd0
	jp enemySetAnimation		; $5dd1


; Cooldown after eating Link; won't eat him again for another 60 frames
_likelike_stateC:
	call _ecom_decCounter2		; $5dd4
	jr nz,++		; $5dd7

	ld l,e			; $5dd9
	ld a,(hl)		; $5dda
	sub $03			; $5ddb
	ld (hl),a ; [state] -= 3

	ld l,Enemy.collisionType		; $5dde
	set 7,(hl)		; $5de0
	jr _likelike_animate		; $5de2
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5de4
	jr nz,_likelike_animate	; $5de7

	; Ran into wall
	call getRandomNumber_noPreserveVars		; $5de9
	and $18			; $5dec
	ld e,Enemy.angle		; $5dee
	ld (de),a		; $5df0
	jr _likelike_animate		; $5df1


; Like-like spawner.
_likelike_subid01:
	ld a,(de)		; $5df3
	sub $08			; $5df4
	rst_jumpTable			; $5df6
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	ld h,d			; $5dfd
	ld l,e			; $5dfe
	inc (hl)		; $5dff
	ld l,Enemy.counter1		; $5e00
	inc (hl)		; $5e02
	jp _likelike_findAllLikelikesWithSubid0		; $5e03


; Wait for Link to move past the screen edge
@state9:
	; Y from $10-$6f
	ld a,(w1Link.yh)		; $5e06
	sub $10			; $5e09
	cp (SMALL_ROOM_HEIGHT<<4)-$20			; $5e0b
	ret nc			; $5e0d

	; X from $10-$8f
	ld a,(w1Link.xh)		; $5e0e
	sub $10			; $5e11
	cp (SMALL_ROOM_WIDTH<<4)-$20			; $5e13
	ret nc			; $5e15

	ld a,$0a		; $5e16
	ld (de),a ; [state] = $0a

; Check to spawn more like-likes.
@stateA:
	call _ecom_decCounter1		; $5e19
	ret nz			; $5e1c

	inc (hl) ; [counter1] = 1

	; No more than 6 like-likes at once
	ld l,Enemy.var30		; $5e1e
	ld a,(hl)		; $5e20
	cp $06			; $5e21
	ret nc			; $5e23

	call getRandomNumber_noPreserveVars		; $5e24
	and $02			; $5e27
	ld c,a			; $5e29
	ld a,(wActiveRoom)		; $5e2a
	cp $50			; $5e2d
	jr z,@fromTop	; $5e2f
	cp $40			; $5e31
	jr z,@fromBottom	; $5e33

	set 2,c			; $5e35
	cp $51			; $5e37
	ret nz			; $5e39

@fromBottom:
	ld e,$02		; $5e3a
	call _likelike_spawn		; $5e3c
	ret nz			; $5e3f
	call _likelike_setChildSpawnPosition		; $5e40
	jr ++			; $5e43
@fromTop:
	ld e,$03		; $5e45
	call _likelike_spawn		; $5e47
	ret nz			; $5e4a
++
	; Successfully spawned a like-like.
	ld h,d			; $5e4b
	ld l,Enemy.var30		; $5e4c
	inc (hl)		; $5e4e
	ld l,Enemy.counter1		; $5e4f
	ld (hl),120		; $5e51
	ret			; $5e53


_likelike_subid02:
	ld a,(de)		; $5e54
	sub $08			; $5e55
	rst_jumpTable			; $5e57
	.dw @state8
	.dw @state9
	.dw _likelike_state9 ; States actually offset by 1 compared to subid 0...
	.dw _likelike_stateA
	.dw _likelike_stateB
	.dw _likelike_stateC

; Initialization
@state8:
	ld h,d			; $5e64
	ld l,e			; $5e65
	inc (hl) ; [state] = 9

	; Set angle to ANGLE_UP (default) if spawning from bottom, or ANGLE_RIGHT if
	; spawning from left of screen
	ld l,Enemy.yh		; $5e67
	ld a,(hl)		; $5e69
	cp (SMALL_ROOM_HEIGHT<<4)+8			; $5e6a
	jr z,+			; $5e6c
	ld l,Enemy.angle		; $5e6e
	ld (hl),ANGLE_RIGHT		; $5e70
+
	ld l,Enemy.counter1		; $5e72
	ld (hl),45		; $5e74
	ret			; $5e76

; Move forward until we're well into the screen boundary
@state9:
	call _ecom_decCounter1		; $5e77
	jr z,++			; $5e7a
	call objectApplySpeed		; $5e7c
	jr _likelike_animate2		; $5e7f
++
	ld l,e			; $5e81
	inc (hl)		; $5e82
	ld l,Enemy.collisionType		; $5e83
	set 7,(hl)		; $5e85

_likelike_animate2:
	jp enemyAnimate		; $5e87


_likelike_subid03:
	ld a,(de)		; $5e8a
	sub $08			; $5e8b
	rst_jumpTable			; $5e8d
	.dw @state8
	.dw @state9
	.dw _likelike_state9 ; States actually offset by 1 compared to subid 0...
	.dw _likelike_stateA
	.dw @stateB
	.dw _likelike_stateC


; Initialization (spawning above the screen).
@state8:
	call _likelike_chooseRandomPosition		; $5e9a
	ret nz			; $5e9d
	ld l,Enemy.state		; $5e9e
	inc (hl)		; $5ea0
	ld l,Enemy.collisionType		; $5ea1
	set 7,(hl)		; $5ea3

	ld l,Enemy.speedZ+1		; $5ea5
	ld (hl),$02		; $5ea7
	jp objectSetVisiblec1		; $5ea9


; Falling to the ground.
@state9:
	ld c,$08		; $5eac
	call objectUpdateSpeedZ_paramC		; $5eae
	jr nz,_likelike_animate2	; $5eb1

	; Hit the ground.
	ld l,Enemy.state		; $5eb3
	inc (hl)		; $5eb5
	call objectSetVisiblec2		; $5eb6
	jr _likelike_animate2		; $5eb9


; Eating Link. Since this falls from the sky, this has extra height-related code.
@stateB:
	ld c,$08		; $5ebb
	call objectUpdateSpeedZ_paramC		; $5ebd
	ld l,Enemy.zh		; $5ec0
	ld a,(hl)		; $5ec2
	ld (w1Link.zh),a		; $5ec3
	jp _likelike_stateB		; $5ec6

;;
; Spawner (subid 1) calls this to make new like-likes where their relatedObj1 references
; the spawner.
;
; @param	e	Subid of like-like to spwan
; @addr{5ec9}
_likelike_spawn:
	ld b,ENEMYID_LIKE_LIKE		; $5ec9
	call _ecom_spawnEnemyWithSubid01		; $5ecb
	ret nz			; $5ece
	ld (hl),e		; $5ecf
	ld l,Enemy.relatedObj1		; $5ed0
	ld a,Enemy.start		; $5ed2
	ldi (hl),a		; $5ed4
	ld (hl),d		; $5ed5
	xor a			; $5ed6
	ret			; $5ed7

;;
; @param	c	Index of spawn position to use
; @addr{5ed8}
_likelike_setChildSpawnPosition:
	push hl			; $5ed8
	ld a,c			; $5ed9
	ld hl,@spawnPositions		; $5eda
	rst_addAToHl			; $5edd
	ldi a,(hl)		; $5ede
	ld b,a			; $5edf
	ld c,(hl)		; $5ee0
	pop hl			; $5ee1
	ld l,Enemy.yh		; $5ee2
	ld (hl),b		; $5ee4
	ld l,Enemy.xh		; $5ee5
	ld (hl),c		; $5ee7
	ret			; $5ee8

@spawnPositions:
	.db $88 $48
	.db $88 $58
	.db $38 $f8
	.db $48 $f8

;;
; Searches for all existing like-likes with subid 0, sets their relatedObj1 to point to
; this object (the spawner), and stores the current like-like count in var30.
; @addr{5ef1}
_likelike_findAllLikelikesWithSubid0:
	ldhl FIRST_ENEMY_INDEX, Enemy.id		; $5ef1
	ld c,$00		; $5ef4
@nextEnemy:
	; Find like-like with subid 0
	ld a,(hl)		; $5ef6
	cp ENEMYID_LIKE_LIKE			; $5ef7
	jr nz,++		; $5ef9
	inc l			; $5efb
	ldd a,(hl)		; $5efc
	or a			; $5efd
	jr nz,++		; $5efe

	; Set its relatedObj1 to this
	ld l,Enemy.relatedObj1		; $5f00
	ld a,Enemy.start		; $5f02
	ldi (hl),a		; $5f04
	ld (hl),d		; $5f05
	ld l,Enemy.id		; $5f06
	inc c			; $5f08
++
	inc h			; $5f09
	ld a,h			; $5f0a
	cp LAST_ENEMY_INDEX+1			; $5f0b
	jr c,@nextEnemy	; $5f0d

	ld e,Enemy.var30		; $5f0f
	ld a,c			; $5f11
	ld (de),a		; $5f12
	ret			; $5f13

;;
; Choose a random position to fall from the sky. If a good position is chosen, the
; Z position is also set to be above the screen.
;
; @param[out]	zflag	z if chose valid position
; @addr{5f14}
_likelike_chooseRandomPosition:
	call getRandomNumber_noPreserveVars		; $5f14
	and $77			; $5f17
	inc a			; $5f19
	ld c,a			; $5f1a
	ld b,>wRoomCollisions		; $5f1b
	ld a,(bc)		; $5f1d
	or a			; $5f1e
	ret nz			; $5f1f
	call objectSetShortPosition		; $5f20
	ld c,$08		; $5f23
	call _ecom_setZAboveScreen		; $5f25
	xor a			; $5f28
	ret			; $5f29


;;
; @addr{5f2a}
_likelike_checkHazards:
	push af			; $5f2a
	ld a,(w1Link.state)		; $5f2b
	cp LINK_STATE_GRABBED			; $5f2e
	jr nz,++		; $5f30

	ld e,Enemy.zh		; $5f32
	ld a,(de)		; $5f34
	rlca			; $5f35
	jr c,++			; $5f36
	ld bc,$0500		; $5f38
	call objectGetRelativeTile		; $5f3b
	ld hl,hazardCollisionTable		; $5f3e
	call lookupCollisionTable		; $5f41
	call c,_likelike_releaseLink		; $5f44
++
	pop af			; $5f47
	jp _ecom_checkHazards		; $5f48


; ==============================================================================
; ENEMYID_GOPONGA_FLOWER
; ==============================================================================
enemyCode25:
	jr z,@normalStatus	; $5f4b
	sub ENEMYSTATUS_NO_HEALTH			; $5f4d
	ret c			; $5f4f
	jp z,enemyDie		; $5f50

	ld e,Enemy.health		; $5f53
	ld a,(de)		; $5f55
	or a			; $5f56
	jp z,_ecom_updateKnockback		; $5f57

@normalStatus:
	ld e,Enemy.state		; $5f5a
	ld a,(de)		; $5f5c
	rst_jumpTable			; $5f5d
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9


@state_uninitialized:
	ld h,d			; $5f72
	ld l,Enemy.counter1		; $5f73
	ld (hl),90		; $5f75
	ld l,Enemy.subid		; $5f77
	ld a,(hl)		; $5f79
	or a			; $5f7a
	jr z,++			; $5f7b

	ld l,Enemy.oamTileIndexBase		; $5f7d
	ld a,(hl)		; $5f7f
	add $04			; $5f80
	ld (hl),a		; $5f82
	ld l,Enemy.enemyCollisionMode		; $5f83
	ld (hl),ENEMYCOLLISION_BIG_GOPONGA_FLOWER		; $5f85
++
	call _ecom_setSpeedAndState8		; $5f87
	jp objectSetVisible83		; $5f8a


@state_stub:
	ret			; $5f8d


; Closed
@state8:
	call _ecom_decCounter1		; $5f8e
	ret nz			; $5f91
	ld (hl),60		; $5f92
	ld l,e			; $5f94
	inc (hl)		; $5f95
	ld a,$01		; $5f96
	jp enemySetAnimation		; $5f98


; Open, about to shoot a projectile
@state9:
	call _ecom_decCounter1		; $5f9b
	jr z,@closeFlower	; $5f9e

	ld a,(hl)		; $5fa0
	cp 40			; $5fa1
	ret nz			; $5fa3

	ld e,Enemy.subid		; $5fa4
	ld a,(de)		; $5fa6
	dec a			; $5fa7
	call nz,getRandomNumber_noPreserveVars		; $5fa8
	and $03			; $5fab
	ret nz			; $5fad
	ld b,PARTID_GOPONGA_PROJECTILE		; $5fae
	jp _ecom_spawnProjectile		; $5fb0

@closeFlower:
	ld e,Enemy.subid		; $5fb3
	ld a,(de)		; $5fb5
	ld bc,@counter1Vals		; $5fb6
	call addAToBc		; $5fb9
	ld a,(bc)		; $5fbc
	ld (hl),a		; $5fbd

	ld l,Enemy.state		; $5fbe
	dec (hl)		; $5fc0

	xor a			; $5fc1
	jp enemySetAnimation		; $5fc2


@counter1Vals: ; counter1 values per subid
	.db $78 $b4


; ==============================================================================
; ENEMYID_DEKU_SCRUB
;
; Variables:
;   var03: Read by ENEMYID_BUSH_OR_ROCK to control Z-offset
;   var30: Starts at 2, gets decremented each time one of the scrub's bullets hits itself.
;   var31: Index of ENEMYID_BUSH_OR_ROCK
;   var32: "pressedAButton" variable (nonzero when player presses A)
;   var33: Former var03 value (low byte of text index, TX_45XX)
; ==============================================================================
enemyCode27:
	jr z,@normalStatus	; $5fc7
	sub ENEMYSTATUS_NO_HEALTH			; $5fc9
	ret c			; $5fcb
	jr z,@dead	; $5fcc
	dec a			; $5fce
	jr nz,@normalStatus	; $5fcf

	; ENEMYSTATUS_JUST_HIT

	; Check var30, which is decremented by PARTID_DEKU_SCRUB_PROJECTILE each time it
	; hits the deku scrub.
	ld e,Enemy.var30		; $5fd1
	ld a,(de)		; $5fd3
	or a			; $5fd4
	ret nz			; $5fd5

	; We've been hit twice, go to state $0c and delete the bush.
	ld h,d			; $5fd6
	ld l,Enemy.state		; $5fd7
	ld (hl),$0c		; $5fd9
	ld l,Enemy.var31		; $5fdb
	ld h,(hl)		; $5fdd
	jp _ecom_killObjectH		; $5fde

@dead:
	ld e,Enemy.subid		; $5fe1
	ld a,(de)		; $5fe3
	dec a			; $5fe4
	jp nz,enemyDie		; $5fe5

@normalStatus:
	ld e,Enemy.state		; $5fe8
	ld a,(de)		; $5fea
	rst_jumpTable			; $5feb
	.dw _dekuScrub_state_uninitialized
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state_stub
	.dw _dekuScrub_state8
	.dw _dekuScrub_state9
	.dw _dekuScrub_stateA
	.dw _dekuScrub_stateB
	.dw _dekuScrub_stateC
	.dw _dekuScrub_stateD


_dekuScrub_state_uninitialized:
	call _dekuScrub_spawnBush		; $6008
	ret nz			; $600b

	call objectMakeTileSolid		; $600c
	ld h,>wRoomLayout		; $600f
	ld (hl),$00		; $6011

	; The value of 'a' here depends on "objectMakeTileSolid".
	; It should be 0 if the enemy spawned on an empty space.
	; In any case it shouldn't matter since this enemy doesn't move.
	call _ecom_setSpeedAndState8		; $6013

	ld l,Enemy.counter1		; $6016
	inc (hl)		; $6018

	ld l,Enemy.var30		; $6019
	ld (hl),$02		; $601b

	ld l,Enemy.var03		; $601d
	ld a,(hl)		; $601f
	ld (hl),$00		; $6020
	ld l,Enemy.var33		; $6022
	ld (hl),a		; $6024
	ret			; $6025


_dekuScrub_state_stub:
	ret			; $6026


; Waiting for Link to be a certain distance away
_dekuScrub_state8:
	ld c,$2c		; $6027
	call objectCheckLinkWithinDistance		; $6029
	ret c			; $602c
	call _ecom_decCounter1		; $602d
	ret nz			; $6030

	ld (hl),90		; $6031

	ld l,Enemy.state		; $6033
	inc (hl)		; $6035

	ld l,Enemy.var03		; $6036
	ld (hl),$02		; $6038

	xor a			; $603a
	call enemySetAnimation		; $603b
	jp objectSetVisiblec3		; $603e


; Link is at a good distance, wait a bit longer before emerging from bush
_dekuScrub_state9:
	ld c,$2c		; $6041
	call objectCheckLinkWithinDistance		; $6043
	jp c,_dekuScrub_hideInBush		; $6046

	call _ecom_decCounter1		; $6049
	jr nz,_dekuScrub_animate	; $604c

	; Emerge from under the bush
	ld l,Enemy.state		; $604e
	inc (hl)		; $6050

	ld l,Enemy.collisionType		; $6051
	set 7,(hl)		; $6053
	ld l,Enemy.var03		; $6055
	inc (hl)		; $6057

	; Calculate angle to shoot
	call objectGetAngleTowardEnemyTarget		; $6058
	ld hl,_dekuScrub_targetAngles		; $605b
	rst_addAToHl			; $605e
	ld a,(hl)		; $605f
	or a			; $6060
	jr z,_dekuScrub_hideInBush	; $6061

	ld e,Enemy.angle		; $6063
	ld (de),a		; $6065
	rrca			; $6066
	rrca			; $6067
	sub $02			; $6068
	ld hl,_dekuScrub_fireAnimations		; $606a
	rst_addAToHl			; $606d
	ld a,(hl)		; $606e
	jp enemySetAnimation		; $606f


; Firing sequence
_dekuScrub_stateA:
	ld c,$2c		; $6072
	call objectCheckLinkWithinDistance		; $6074
	jr c,_dekuScrub_hideInBush	; $6077

	ld e,Enemy.animParameter		; $6079
	ld a,(de)		; $607b
	inc a			; $607c
	jr z,_dekuScrub_hideInBush	; $607d

	ld a,(de)		; $607f
	dec a			; $6080
	jr nz,_dekuScrub_animate	; $6081
	ld (de),a		; $6083

	ld b,PARTID_DEKU_SCRUB_PROJECTILE		; $6084
	call _ecom_spawnProjectile		; $6086

_dekuScrub_animate:
	jp enemyAnimate		; $6089


; Go hide in the bush again
_dekuScrub_stateB:
	ld e,Enemy.animParameter		; $608c
	ld a,(de)		; $608e
	inc a			; $608f
	jr nz,_dekuScrub_animate	; $6090

	ld h,d			; $6092
	ld l,Enemy.state		; $6093
	ld (hl),$08		; $6095

	ld l,Enemy.var03		; $6097
	ld (hl),$00		; $6099
	jp objectSetInvisible		; $609b


; He's just been defeated
_dekuScrub_stateC:
	ld h,d			; $609e
	ld l,e			; $609f
	inc (hl) ; [state] = $0d

	ld l,Enemy.collisionType		; $60a1
	res 7,(hl)		; $60a3

	ld e,Enemy.var32		; $60a5
	call objectAddToAButtonSensitiveObjectList		; $60a7
	ld a,$07		; $60aa
	call enemySetAnimation		; $60ac


; Waiting for Link to talk to him
_dekuScrub_stateD:
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $60af
	ld e,Enemy.var32		; $60b2
	ld a,(de)		; $60b4
	or a			; $60b5
	jr z,_dekuScrub_animate	; $60b6

	; Pressed A in front of deku scrub
	ld e,Enemy.var32		; $60b8
	xor a			; $60ba
	ld (de),a		; $60bb

	; Show text
	ld e,Enemy.var33		; $60bc
	ld a,(de)		; $60be
	ld c,a			; $60bf
	ld b,>TX_4500		; $60c0
	jp showText		; $60c2


;;
; @addr{60c5}
_dekuScrub_hideInBush:
	ld h,d			; $60c5
	ld l,Enemy.state		; $60c6
	ld (hl),$0b		; $60c8

	ld l,Enemy.counter1		; $60ca
	ld (hl),120		; $60cc

	ld l,Enemy.collisionType		; $60ce
	res 7,(hl)		; $60d0

	ld l,Enemy.var03		; $60d2
	ld (hl),$02		; $60d4
	ld a,$06		; $60d6
	jp enemySetAnimation		; $60d8


; Takes the relative angle between the deku scrub and Link as an index, and the
; corresponding value is the angle at which to shoot a projectile. "0" means can't shoot
; from this angle.
_dekuScrub_targetAngles:
	.db $00 $00 $00 $00 $00 $00 $00 $08
	.db $08 $08 $0c $0c $0c $0c $0c $10
	.db $10 $10 $14 $14 $14 $14 $14 $18
	.db $18 $18 $00 $00 $00 $00 $00 $00

_dekuScrub_fireAnimations:
	.db $05 $04 $03 $02 $01

;;
; @param[out]	zflag	z if spawned bus successfully
; @addr{6100}
_dekuScrub_spawnBush:
	ld b,ENEMYID_BUSH_OR_ROCK		; $6100
	call _ecom_spawnUncountedEnemyWithSubid01		; $6102
	ret nz			; $6105

	call objectCopyPosition		; $6106

	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1		; $6109
	ld a,Enemy.start		; $610b
	ldi (hl),a		; $610d
	ld (hl),d		; $610e

	; Save projectile's index to var31
	ld e,Enemy.var31		; $610f
	ld a,h			; $6111
	ld (de),a		; $6112

	ld l,Enemy.subid		; $6113
	ld e,l			; $6115
	ld a,(de)		; $6116
	ld (hl),a		; $6117
	xor a			; $6118
	ret			; $6119


; ==============================================================================
; ENEMYID_WALLMASTER
;
; Variables:
;   relatedObj1: For actual wallmaster (subid 1): reference to spawner.
;   relatedObj2: For spawner (subid 0): reference to actual wallmaster.
;   var30: Nonzero if collided with Link (currently warping him out)
; ==============================================================================
enemyCode28:
	jr z,@normalStatus	; $611a
	sub $03			; $611c
	ret c			; $611e
	jr z,@dead	; $611f
	dec a			; $6121
	jp nz,_ecom_updateKnockback		; $6122

	; ENEMYSTATUS_JUST_HIT

	ld e,Enemy.var2a		; $6125
	ld a,(de)		; $6127
	cp $80|ITEMCOLLISION_LINK			; $6128
	ret nz			; $612a

	; Link just touched the hand. If not experiencing knockback, begin warping Link
	; out.
	ld e,Enemy.knockbackCounter		; $612b
	ld a,(de)		; $612d
	or a			; $612e
	ret nz			; $612f

	ld h,d			; $6130
	ld l,Enemy.var30		; $6131
	ld (hl),$01		; $6133

	ld l,Enemy.collisionType		; $6135
	res 7,(hl)		; $6137

	ld l,Enemy.yh		; $6139
	ldi a,(hl)		; $613b
	ld (w1Link.yh),a		; $613c
	inc l			; $613f
	ld a,(hl)		; $6140
	ld (w1Link.xh),a		; $6141
	ret			; $6144

@dead:
	ld e,Enemy.relatedObj1+1		; $6145
	ld a,(de)		; $6147
	or a			; $6148
	jr z,++		; $6149
	ld h,a			; $614b
	ld l,Enemy.relatedObj2+1		; $614c
	ld (hl),$00		; $614e
	ld l,Enemy.yh		; $6150
	dec (hl)		; $6152
++
	jp enemyDie_uncounted		; $6153


@normalStatus:
	ld e,Enemy.state		; $6156
	ld a,(de)		; $6158
	rst_jumpTable			; $6159
	.dw _wallmaster_state_uninitialized
	.dw _wallmaster_state1
	.dw _wallmaster_state_stub
	.dw _wallmaster_state_stub
	.dw _wallmaster_state_stub
	.dw _wallmaster_state_galeSeed
	.dw _wallmaster_state_stub
	.dw _wallmaster_state_stub
	.dw _wallmaster_state8
	.dw _wallmaster_state9
	.dw _wallmaster_stateA
	.dw _wallmaster_stateB
	.dw _wallmaster_stateC
	.dw _wallmaster_stateD


_wallmaster_state_uninitialized:
	ld e,Enemy.subid		; $6176
	ld a,(de)		; $6178
	or a			; $6179
	jp nz,_ecom_setSpeedAndState8		; $617a

	ld h,d			; $617d
	ld l,Enemy.state		; $617e
	inc (hl)		; $6180
	ld l,Enemy.counter1		; $6181
	ld (hl),180		; $6183

	ld l,Enemy.relatedObj2		; $6185
	ld (hl),Enemy.start		; $6187
	ret			; $6189


; Subid 0 (wallmaster spawner) stays in this state indefinitely; spawns a wallmaster every
; 2 seconds.
_wallmaster_state1:
	; "yh" acts as the number of wallmasters remaining to spawn, for the spawner.
	ld e,Enemy.yh		; $618a
	ld a,(de)		; $618c
	or a			; $618d
	jr z,@delete	; $618e

	ld e,Enemy.relatedObj2+1		; $6190
	ld a,(de)		; $6192
	or a			; $6193
	ret nz			; $6194

	call _ecom_decCounter1		; $6195
	ret nz			; $6198

	ld (hl),120		; $6199

	ld a,(w1Link.yh)		; $619b
	ld b,a			; $619e
	ld a,(w1Link.xh)		; $619f
	ld c,a			; $61a2
	call getTileCollisionsAtPosition		; $61a3
	ret nz			; $61a6

	push bc			; $61a7
	ld b,ENEMYID_WALLMASTER		; $61a8
	call _ecom_spawnUncountedEnemyWithSubid01		; $61aa
	pop bc			; $61ad
	ret nz			; $61ae
	ld l,Enemy.relatedObj1		; $61af
	ld a,Enemy.start		; $61b1
	ldi (hl),a		; $61b3
	ld (hl),d		; $61b4

	ld e,Enemy.relatedObj2+1		; $61b5
	ld a,h			; $61b7
	ld (de),a		; $61b8
	ret			; $61b9

@delete:
	call decNumEnemies		; $61ba
	call markEnemyAsKilledInRoom		; $61bd
	jp enemyDelete		; $61c0


_wallmaster_state_galeSeed:
	call _ecom_galeSeedEffect		; $61c3
	ret c			; $61c6

	; Tell spawner that this wallmaster is dead
	ld e,Enemy.relatedObj1+1		; $61c7
	ld a,(de)		; $61c9
	or a			; $61ca
	jr z,++			; $61cb
	ld h,a			; $61cd
	ld l,Enemy.relatedObj2+1		; $61ce
	ld (hl),$00		; $61d0
++
	jp enemyDelete		; $61d2


_wallmaster_state_stub:
	ret			; $61d5


; Spawning at Link's position, above the screen
_wallmaster_state8:
	ld h,d			; $61d6
	ld l,e			; $61d7
	inc (hl) ; [state]++

	ld l,Enemy.collisionType		; $61d9
	ld (hl),$80|ENEMYID_FLOORMASTER		; $61db

	; Copy Link's position, set high Z position
	ld l,Enemy.zh		; $61dd
	ld (hl),$a0		; $61df
	ld l,Enemy.yh		; $61e1
	ld a,(w1Link.yh)		; $61e3
	ldi (hl),a		; $61e6
	inc l			; $61e7
	ld a,(w1Link.xh)		; $61e8
	ld (hl),a		; $61eb

	ld a,SND_FALLINHOLE		; $61ec
	call playSound		; $61ee
	jp objectSetVisiblec1		; $61f1


; Falling to ground
_wallmaster_state9:
	ld c,$0e		; $61f4
	call objectUpdateSpeedZ_paramC		; $61f6
	jr z,@hitGround	; $61f9

	call _wallmaster_flickerVisibilityIfHighUp		; $61fb

	; Chechk for collision with Link
	ld e,Enemy.var30		; $61fe
	ld a,(de)		; $6200
	or a			; $6201
	ret z			; $6202
	ld e,Enemy.zh		; $6203
	ld a,(de)		; $6205
	ld (w1Link.zh),a		; $6206
	ret			; $6209

@hitGround:
	ld l,Enemy.counter1		; $620a
	ld (hl),30		; $620c
	ld l,Enemy.state		; $620e
	inc (hl)		; $6210
	ret			; $6211


; Waiting on ground for [counter1] frames before moving back up
_wallmaster_stateA:
	call _ecom_decCounter1		; $6212
	jr nz,++		; $6215
	ld l,e			; $6217
	inc (hl) ; [state]++
	ret			; $6219
++
	ld a,(hl)		; $621a
	cp 20 ; [counter1] == 20?
	jr c,++			; $621d
	ret nz			; $621f

	; Close hand when [counter1] == 20
	ld a,$01		; $6220
	jp enemySetAnimation		; $6222
++
	dec a			; $6225
	jr nz,++		; $6226

	; Set collisionType when [counter1] == 1?
	ld l,Enemy.collisionType		; $6228
	ld a,(hl)		; $622a
	and $80			; $622b
	or ENEMYID_WALLMASTER			; $622d
	ld (hl),a		; $622f
++
	ld l,Enemy.var30		; $6230
	bit 0,(hl)		; $6232
	ret z			; $6234
	xor a			; $6235
	ld (w1Link.visible),a		; $6236
	ret			; $6239


; Moving back up
_wallmaster_stateB:
	call _wallmaster_flickerVisibilityIfHighUp		; $623a
	ld h,d			; $623d
	ld l,Enemy.zh		; $623e
	dec (hl)		; $6240
	dec (hl)		; $6241
	ld a,(hl)		; $6242
	cp $a0			; $6243
	ret nc			; $6245

	; Moved high enough
	call objectSetInvisible		; $6246
	ld l,Enemy.var30		; $6249
	bit 0,(hl)		; $624b
	jr z,++			; $624d

	; We just pulled Link out, go to state $0d
	ld l,Enemy.state		; $624f
	ld (hl),$0d		; $6251
	ret			; $6253
++
	ld l,Enemy.state		; $6254
	inc (hl) ; [state] = $0c
	ld l,Enemy.collisionType		; $6257
	res 7,(hl)		; $6259
	ld l,Enemy.counter1		; $625b
	ld (hl),120		; $625d
	ret			; $625f


; Waiting off-screen until time to attack again
_wallmaster_stateC:
	call _ecom_decCounter1		; $6260
	ret nz			; $6263

	ld l,e			; $6264
	ld (hl),$08 ; [state] = 8
	ld l,Enemy.speedZ		; $6267
	xor a			; $6269
	ldi (hl),a		; $626a
	ld (hl),a		; $626b
	jp enemySetAnimation		; $626c


; Just dragged Link off-screen
_wallmaster_stateD:
	; Go to substate 2 in LINK_STATE_GRABBED_BY_WALLMASTER.
	ld a,$02		; $626f
	ld (w1Link.state2),a		; $6271
	ret			; $6274


;;
; Flickers visibility if very high up (zh < $b8)
; @addr{6275}
_wallmaster_flickerVisibilityIfHighUp:
	ld e,Enemy.zh		; $6275
	ld a,(de)		; $6277
	or a			; $6278
	ret z			; $6279
	cp $b8			; $627a
	jp c,_ecom_flickerVisibility		; $627c
	cp $bc			; $627f
	ret nc			; $6281
	jp objectSetVisiblec1		; $6282


; ==============================================================================
; ENEMYID_PODOBOO
;
; Variables:
;   relatedObj1: "Parent" (for subid 1, the lava particle)
;   var30: Animation index
;   var31: Initial Y position; the point at which the podoboo returns back to the lava
; ==============================================================================
enemyCode29:
	; Return for ENEMYSTATUS_01 or ENEMYSTATUS_STUNNED
	dec a			; $6285
	ret z			; $6286
	dec a			; $6287
	ret z			; $6288

	ld e,Enemy.state		; $6289
	ld a,(de)		; $628b
	rst_jumpTable			; $628c
	.dw podoboo_state_uninitialized
	.dw _podoboo_state_stub
	.dw _podoboo_state_stub
	.dw _podoboo_state_stub
	.dw _podoboo_state_stub
	.dw _podoboo_state_stub
	.dw _podoboo_state_stub
	.dw _podoboo_state_stub
	.dw _podoboo_state8
	.dw _podoboo_state9
	.dw _podoboo_stateA
	.dw _podoboo_stateB
	.dw _podoboo_stateC

podoboo_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call _ecom_setSpeedAndState8		; $62a7
	ld e,Enemy.subid		; $62aa
	ld a,(de)		; $62ac
	or a			; $62ad
	ret z			; $62ae

	; Subid 1 only

	ld (hl),$0c ; [state] = $0c

	ld l,Enemy.relatedObj1+1		; $62b1
	ld h,(hl)		; $62b3
	ld l,Enemy.var30		; $62b4
	ld a,(hl)		; $62b6
	inc a			; $62b7
	call enemySetAnimation		; $62b8
	jp objectSetVisible83		; $62bb


_podoboo_state_stub:
	ret			; $62be


; Subid 0: Waiting for Link to approach horizontally
_podoboo_state8:
	ld h,d			; $62bf
	ld l,Enemy.xh		; $62c0
	ldh a,(<hEnemyTargetX)	; $62c2
	sub (hl)		; $62c4
	add $30			; $62c5
	cp $61			; $62c7
	ret nc			; $62c9

	; Save initial Y-position so we know when the leap is done
	ld l,Enemy.yh		; $62ca
	ld a,(hl)		; $62cc
	ld l,Enemy.var31		; $62cd
	ld (hl),a		; $62cf
	jr _podoboo_beginMovingUp		; $62d0


; Leaping out of lava
_podoboo_state9:
	call enemyAnimate		; $62d2
	call _podoboo_updatePosition		; $62d5
	jr z,@doneLeaping	; $62d8

	ld a,(hl) ; hl == Enemy.speedZ+1
	or a			; $62db
	jr nz,_podoboo_spawnLavaParticleEvery16Frames	; $62dc

	; Moving down
	ld l,Enemy.var30		; $62de
	cp (hl)			; $62e0
	ret z			; $62e1
	ld (hl),a		; $62e2
	call enemySetAnimation		; $62e3
	jr _podoboo_spawnLavaParticle		; $62e6

@doneLeaping:
	ld l,Enemy.state		; $62e8
	inc (hl)		; $62ea
	ld l,Enemy.collisionType		; $62eb
	res 7,(hl)		; $62ed


; Just re-entered the lava
_podoboo_stateA:
	call _podoboo_makeLavaSplash		; $62ef
	ret nz			; $62f2

	; Wait a random amount of time before resurfacing
	call getRandomNumber_noPreserveVars		; $62f3
	and $03			; $62f6
	ld hl,_podoboo_counter1Vals		; $62f8
	rst_addAToHl			; $62fb
	ld e,Enemy.counter1		; $62fc
	ld a,(hl)		; $62fe
	ld (de),a		; $62ff

	call _ecom_incState		; $6300
	jp objectSetInvisible		; $6303


; Waiting for [counter1] frames before jumping out again.
_podoboo_stateB:
	call _ecom_decCounter1		; $6306
	ret nz			; $6309
	inc (hl)		; $630a
	jr _podoboo_beginMovingUp		; $630b


; State for "lava particle" (subid 1); just animate until time to delete self.
_podoboo_stateC:
	call enemyAnimate		; $630d
	ld e,Enemy.animParameter		; $6310
	ld a,(de)		; $6312
	inc a			; $6313
	jp z,enemyDelete		; $6314
	dec a			; $6317
	jp nz,objectSetInvisible		; $6318
	jp _ecom_flickerVisibility		; $631b


;;
; @addr{631e}
_podoboo_spawnLavaParticleEvery16Frames:
	call _ecom_decCounter1		; $631e
	ld a,(hl)		; $6321
	and $0f			; $6322
	ret nz			; $6324

;;
; @addr{6325}
_podoboo_spawnLavaParticle:
	ld b,ENEMYID_PODOBOO		; $6325
	call _ecom_spawnUncountedEnemyWithSubid01		; $6327
	ret nz			; $632a
	call objectCopyPosition		; $632b
	ld l,Enemy.relatedObj1		; $632e
	ld a,Enemy.start		; $6330
	ldi (hl),a		; $6332
	ld (hl),d		; $6333
	ret			; $6334


;;
; Makes a splash, sets animation and speed, enables collisions for when the splash has
; just spawned, sets state to 9.
; @addr{6335}
_podoboo_beginMovingUp:
	call _podoboo_makeLavaSplash		; $6335
	ret nz			; $6338

	call objectSetVisible82		; $6339

	ld e,Enemy.var30		; $633c
	ld a,$02		; $633e
	ld (de),a		; $6340
	call enemySetAnimation		; $6341

	ld bc,-$440		; $6344
	call objectSetSpeedZ		; $6347

	ld l,Enemy.state		; $634a
	ld (hl),$09		; $634c
	ld l,Enemy.collisionType		; $634e
	set 7,(hl)		; $6350
	xor a			; $6352
	ret			; $6353


;;
; @param[out]	zflag	z if created successfully
; @addr{6354}
_podoboo_makeLavaSplash:
	ldbc INTERACID_LAVASPLASH,$01		; $6354
	jp objectCreateInteraction		; $6357


; Value randomly chosen from here
_podoboo_counter1Vals:
	.db $10 $50 $50 $50


;;
; @param[out]	zflag	z if returned to original position.
; @addr{635e}
_podoboo_updatePosition:
	ld h,d			; $635e
	ld l,Enemy.speedZ		; $635f
	ld e,Enemy.y		; $6361
	call add16BitRefs		; $6363
	ld b,a			; $6366

	; Check if Enemy.y has returned to its original position
	ld e,Enemy.var31		; $6367
	ld a,(de)		; $6369
	cp b			; $636a
	jr c,++			; $636b

	; If so, [Enemy.speedZ] += $001c
	dec l			; $636d
	ld a,$1c		; $636e
	add (hl)		; $6370
	ldi (hl),a		; $6371
	ld a,$00		; $6372
	adc (hl)		; $6374
	ld (hl),a		; $6375
	or d			; $6376
	ret			; $6377
++
	; Reached original position.
	ld l,Enemy.yh		; $6378
	ldd (hl),a		; $637a
	ld (hl),$00		; $637b
	xor a			; $637d
	ret			; $637e


; ==============================================================================
; ENEMYID_GIANT_BLADE_TRAP
; ==============================================================================
enemyCode2a:
	; Return for ENEMYSTATUS_01 or ENEMYSTATUS_STUNNED
	dec a			; $637f
	ret z			; $6380
	dec a			; $6381
	ret z			; $6382

	call _ecom_getSubidAndCpStateTo08		; $6383
	jr c,@commonState	; $6386
	ld a,b			; $6388
	rst_jumpTable			; $6389
	.dw _giantBladeTrap_subid00
	.dw _giantBladeTrap_subid01
	.dw _giantBladeTrap_subid02
	.dw _giantBladeTrap_subid03

@commonState:
	rst_jumpTable			; $6392
	.dw _giantBladeTrap_state_uninitialized
	.dw _giantBladeTrap_state_stub
	.dw _giantBladeTrap_state_stub
	.dw _giantBladeTrap_state_stub
	.dw _giantBladeTrap_state_stub
	.dw _giantBladeTrap_state_stub
	.dw _giantBladeTrap_state_stub
	.dw _giantBladeTrap_state_stub


_giantBladeTrap_state_uninitialized:
	call _ecom_setSpeedAndState8		; $63a3
	jp objectSetVisible82		; $63a6


_giantBladeTrap_state_stub:
	ret			; $63a9


_giantBladeTrap_subid00:
	ret			; $63aa


_giantBladeTrap_subid01:
	ld a,(de)		; $63ab
	sub $08			; $63ac
	rst_jumpTable			; $63ae
	.dw _giantBladeTrap_subid01_state8
	.dw _giantBladeTrap_subid01_state9
	.dw _giantBladeTrap_subid01_stateA


; Choosing initial direction to move.
_giantBladeTrap_subid01_state8:
	ld a,$09		; $63b5
	ld (de),a ; [state] = 9
	call _giantBladeTrap_chooseInitialAngle		; $63b8
	ld e,Enemy.speed		; $63bb
	ld a,SPEED_80		; $63bd
	ld (de),a		; $63bf
	ret			; $63c0


; Move until hitting a wall.
_giantBladeTrap_subid01_state9:
	call _giantBladeTrap_checkCanMoveInDirection		; $63c1
	jp z,objectApplySpeed		; $63c4
	call _ecom_incState		; $63c7
	ld l,Enemy.counter1		; $63ca
	ld (hl),$10		; $63cc
	ret			; $63ce


; Wait 16 frames, then change directions and start moving again.
_giantBladeTrap_subid01_stateA:
	call _ecom_decCounter1		; $63cf
	ret nz			; $63d2

	ld l,e			; $63d3
	dec (hl) ; [state]--

	; Rotate angle clockwise
	ld l,Enemy.angle		; $63d5
	ld a,(hl)		; $63d7
	add $08			; $63d8
	and $18			; $63da
	ld (hl),a		; $63dc
	ret			; $63dd


_giantBladeTrap_subid02:
	ld a,(de)		; $63de
	sub $08			; $63df
	rst_jumpTable			; $63e1
	.dw _giantBladeTrap_subid02_state8
	.dw _giantBladeTrap_commonState9
	.dw _giantBladeTrap_subid02_stateA


; Initialization
_giantBladeTrap_subid02_state8:
	ld h,d			; $63e8
	ld l,e			; $63e9
	inc (hl)		; $63ea
	ld l,Enemy.counter1		; $63eb
	ld (hl),60		; $63ed
	ret			; $63ef


; Accelerate until hitting a wall.
_giantBladeTrap_commonState9:
	call _giantBladeTrap_updateSpeed		; $63f0
	call _giantBladeTrap_checkCanMoveInDirection		; $63f3
	jp z,objectApplySpeed		; $63f6

	call _ecom_incState		; $63f9

	; Round Y, X to center of tile
	ld l,Enemy.yh		; $63fc
	ld a,(hl)		; $63fe
	add $02			; $63ff
	and $f8			; $6401
	ldi (hl),a		; $6403
	inc l			; $6404
	ld a,(hl)		; $6405
	add $02			; $6406
	and $f8			; $6408
	ld (hl),a		; $640a

	ld l,Enemy.counter1		; $640b
	ld (hl),$10		; $640d
	ret			; $640f


; Hit a wall, waiting for a bit then changing direction.
_giantBladeTrap_subid02_stateA:
	call _ecom_decCounter1		; $6410
	ret nz			; $6413

	; Rotate angle clockwise
	ld e,Enemy.angle		; $6414
	ld a,(de)		; $6416
	add $08			; $6417
	and $1f			; $6419
	ld (de),a		; $641b

	call _giantBladeTrap_checkCanMoveInDirection		; $641c
	jr z,@canMove	; $641f

	; Can't move this way; try reversing direction.
	ld e,Enemy.angle		; $6421
	ld a,(de)		; $6423
	xor $10			; $6424
	ld (de),a		; $6426
	call _giantBladeTrap_checkCanMoveInDirection		; $6427
	jr z,@canMove	; $642a

	; Can't move backward either; try another direction.
	ld e,Enemy.angle		; $642c
	ld a,(de)		; $642e
	sub $08			; $642f
	and $1f			; $6431
	ld (de),a		; $6433

@canMove:
	 ; Return to state 9
	ld h,d			; $6434
	ld l,Enemy.state		; $6435
	dec (hl)		; $6437
	ld l,Enemy.counter1		; $6438
	ld (hl),90		; $643a
	ret			; $643c


_giantBladeTrap_subid03:
	ld a,(de)		; $643d
	sub $08			; $643e
	rst_jumpTable			; $6440
	.dw _giantBladeTrap_subid03_state8
	.dw _giantBladeTrap_commonState9
	.dw _giantBladeTrap_subid03_stateA


; Initialization
_giantBladeTrap_subid03_state8:
	ld h,d			; $6447
	ld l,e			; $6448
	inc (hl)		; $6449
	ld l,Enemy.angle		; $644a
	ld (hl),$10		; $644c
	ld l,Enemy.counter1		; $644e
	ld (hl),90		; $6450
	ret			; $6452


; Hit a wall, waiting for a bit then changing direction.
_giantBladeTrap_subid03_stateA:
	call _ecom_decCounter1		; $6453
	ret nz			; $6456

	; Rotate angle counterclockwise
	ld e,Enemy.angle		; $6457
	ld a,(de)		; $6459
	sub $08			; $645a
	and $1f			; $645c
	ld (de),a		; $645e

	call _giantBladeTrap_checkCanMoveInDirection		; $645f
	jr z,@canMove	; $6462

	; Can't move this way; try reversing direction.
	ld e,Enemy.angle		; $6464
	ld a,(de)		; $6466
	xor $10			; $6467
	ld (de),a		; $6469
	call _giantBladeTrap_checkCanMoveInDirection		; $646a
	jr z,@canMove	; $646d

	; Can't move backward either; try another direction.
	ld e,Enemy.angle		; $646f
	ld a,(de)		; $6471
	add $08			; $6472
	and $1f			; $6474
	ld (de),a		; $6476

@canMove:
	; Return to state 9
	ld h,d			; $6477
	ld l,Enemy.state		; $6478
	dec (hl)		; $647a
	ld l,Enemy.counter1		; $647b
	ld (hl),90		; $647d
	ret			; $647f


;;
; Subid 1 only; check all directions, choose which way to go.
; @addr{6480}
_giantBladeTrap_chooseInitialAngle:
	call _giantBladeTrap_checkCanMoveInDirection		; $6480
	ld a,ANGLE_RIGHT		; $6483
	jr nz,@setAngle	; $6485

	ld e,Enemy.angle		; $6487
	ld (de),a		; $6489
	call _giantBladeTrap_checkCanMoveInDirection		; $648a
	ld a,ANGLE_DOWN		; $648d
	jr nz,@setAngle	; $648f

	ld e,Enemy.angle		; $6491
	ld (de),a		; $6493
	call _giantBladeTrap_checkCanMoveInDirection		; $6494
	ld a,ANGLE_LEFT		; $6497
	jr nz,@setAngle	; $6499

	xor a			; $649b
@setAngle:
	ld e,Enemy.angle		; $649c
	ld (de),a		; $649e
	ret			; $649f

;;
; Based on current angle value, this checks if it can move in that direction (it is not
; blocked by solid tiles directly ahead).
;
; @param[out]	zflag	z if it can move in this direction.
; @addr{64a0}
_giantBladeTrap_checkCanMoveInDirection:
	ld e,Enemy.yh		; $64a0
	ld a,(de)		; $64a2
	ld b,a			; $64a3
	ld e,Enemy.xh		; $64a4
	ld a,(de)		; $64a6
	ld c,a			; $64a7

	ld e,Enemy.angle		; $64a8
	ld a,(de)		; $64aa
	rrca			; $64ab
	ld hl,@positionOffsets		; $64ac
	rst_addAToHl			; $64af
	push de			; $64b0
	ld d,>wRoomCollisions		; $64b1
	call @checkTileAtOffsetSolid		; $64b3
	jr nz,+			; $64b6
	call @checkTileAtOffsetSolid		; $64b8
+
	pop de			; $64bb
	ret			; $64bc

;;
; @param	bc	Position
; @param	hl	Pointer to position offsets
; @param[out]	zflag	z if tile is solid
; @addr{64bd}
@checkTileAtOffsetSolid:
	ldi a,(hl)		; $64bd
	add b			; $64be
	and $f0			; $64bf
	ld e,a			; $64c1
	ldi a,(hl)		; $64c2
	add c			; $64c3
	swap a			; $64c4
	and $0f			; $64c6
	or e			; $64c8
	ld e,a			; $64c9
	ld a,(de)		; $64ca
	or a			; $64cb
	ret			; $64cc

@positionOffsets:
	.db $ef $f8  $ef $07 ; DIR_UP
	.db $f8 $10  $07 $10 ; DIR_RIGHT
	.db $10 $f8  $10 $07 ; DIR_DOWN
	.db $f8 $ef  $07 $ef ; DIR_LEFT

;;
; Decrements counter1 and uses its value to determine speed. Lower values = higher speed.
; @addr{64dd}
_giantBladeTrap_updateSpeed:
	ld e,Enemy.counter1		; $64dd
	ld a,(de)		; $64df
	or a			; $64e0
	ret z			; $64e1
	ld a,(de)		; $64e2
	dec a			; $64e3
	ld (de),a		; $64e4

	and $f0			; $64e5
	swap a			; $64e7
	ld hl,@speeds		; $64e9
	rst_addAToHl			; $64ec
	ld e,Enemy.speed		; $64ed
	ld a,(hl)		; $64ef
	ld (de),a		; $64f0
	ret			; $64f1

@speeds:
	.db SPEED_280, SPEED_200, SPEED_180, SPEED_100, SPEED_80, SPEED_20


; ==============================================================================
; ENEMYID_CHEEP_CHEEP
;
; Variables:
;   var03: How far to travel (copied to counter1)
; ==============================================================================
enemyCode2c:
	jr z,@normalStatus	; $64f8
	sub ENEMYSTATUS_NO_HEALTH			; $64fa
	ret c			; $64fc
	jp z,enemyDie		; $64fd
	dec a			; $6500
	jp nz,_ecom_updateKnockback		; $6501

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $6504
	jr nc,@normalState	; $6507
	rst_jumpTable			; $6509
	.dw _cheepCheep_state_uninitialized
	.dw _cheepCheep_state_stub
	.dw _cheepCheep_state_stub
	.dw _cheepCheep_state_stub
	.dw _cheepCheep_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _cheepCheep_state_stub
	.dw _cheepCheep_state_stub

@normalState:
	ld a,b			; $651a
	rst_jumpTable			; $651b
	.dw _cheepCheep_subid00
	.dw _cheepCheep_subid01


_cheepCheep_state_uninitialized:
	ld a,SPEED_80		; $6520
	call _ecom_setSpeedAndState8		; $6522
	jp objectSetVisible82		; $6525


_cheepCheep_state_stub:
	ret			; $6528


_cheepCheep_subid00:
	ld a,(de)		; $6529
	sub $08			; $652a
	rst_jumpTable			; $652c
	.dw _cheepCheep_subid00_state8
	.dw _cheepCheep_state9
	.dw _cheepCheep_stateA


; Initialize angle (left), counter1.
_cheepCheep_subid00_state8:
	ld h,d			; $6533
	ld l,e			; $6534
	inc (hl) ; [state]++

	ld l,Enemy.angle		; $6536
	ld (hl),ANGLE_LEFT		; $6538

	ld l,Enemy.var03		; $653a
	ld a,(hl)		; $653c
	add a			; $653d
	ld (hl),a		; $653e
	ld l,Enemy.counter1		; $653f
	ld (hl),a		; $6541
	ret			; $6542


; Moving until counter1 expires
_cheepCheep_state9:
	call _ecom_decCounter1		; $6543
	jr nz,++		; $6546
	ld (hl),60		; $6548
	ld l,e			; $654a
	inc (hl) ; [state]++
++
	call objectApplySpeed		; $654c

_cheepCheep_animate:
	jp enemyAnimate		; $654f


; Waiting for 60 frames, then reverse direction
_cheepCheep_stateA:
	call _ecom_decCounter1		; $6552
	jr nz,_cheepCheep_animate	; $6555

	ld e,Enemy.var03		; $6557
	ld a,(de)		; $6559
	ld (hl),a ; [counter1] = [var03]

	ld l,Enemy.state		; $655b
	dec (hl)		; $655d

	; Reverse angle
	ld l,Enemy.angle		; $655e
	ld a,(hl)		; $6560
	xor $10			; $6561
	ldd (hl),a		; $6563

	; Reverse animation (in Enemy.direction variable)
	ld a,(hl)		; $6564
	xor $01			; $6565
	ld (hl),a		; $6567
	jp enemySetAnimation		; $6568


_cheepCheep_subid01:
	ld a,(de)		; $656b
	sub $08			; $656c
	rst_jumpTable			; $656e
	.dw _cheepCheep_subid01_state8
	.dw _cheepCheep_state9
	.dw _cheepCheep_stateA


; Initialize angle (down), counter1.
_cheepCheep_subid01_state8:
	ld h,d			; $6575
	ld l,e			; $6576
	inc (hl) ; [state]++
	ld l,Enemy.angle		; $6578
	ld (hl),ANGLE_DOWN		; $657a

	ld l,Enemy.var03		; $657c
	ld a,(hl)		; $657e
	add a			; $657f
	ld (hl),a		; $6580
	ld l,Enemy.counter1		; $6581
	ld (hl),a		; $6583
	ret			; $6584


; ==============================================================================
; ENEMYID_PODOBOO_TOWER
;
; Variables:
;   var30: Base y-position. (Actual y-position changes as it emerges from the ground.)
; ==============================================================================
enemyCode2d:
	jr z,@normalStatus	; $6585
	sub ENEMYSTATUS_NO_HEALTH			; $6587
	ret c			; $6589
	jp z,enemyDie_withoutItemDrop		; $658a

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	ld e,Enemy.var2a		; $658d
	ld a,(de)		; $658f
	cp $80|ITEMCOLLISION_MYSTERY_SEED			; $6590
	jp z,enemyDie_uncounted_withoutItemDrop		; $6592

@normalStatus:
	ld e,Enemy.state		; $6595
	ld a,(de)		; $6597
	rst_jumpTable			; $6598
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD


@state_uninitialized:
	call _ecom_setSpeedAndState8		; $65b5
	ld l,Enemy.var3f		; $65b8
	set 5,(hl)		; $65ba

	ld l,Enemy.counter1		; $65bc
	ld (hl),60		; $65be

	ld l,Enemy.yh		; $65c0
	ld a,(hl)		; $65c2
	ld l,Enemy.var30		; $65c3
	ld (hl),a		; $65c5
	ret			; $65c6


@state_stub:
	ret			; $65c7


; Head is in the ground, flickering, for 60 frames
@state8:
	call _ecom_decCounter1		; $65c8
	jp nz,_ecom_flickerVisibility		; $65cb
	ld l,e			; $65ce
	inc (hl) ; [state]++
	ld l,Enemy.collisionType		; $65d0
	set 7,(hl)		; $65d2
	jp objectSetVisible82		; $65d4


; Rising up out of the ground
@state9:
	call enemyAnimate		; $65d7
	ld e,Enemy.animParameter		; $65da
	ld a,(de)		; $65dc
	or a			; $65dd
	ret z			; $65de

	ld b,a			; $65df
	call @updateCollisionRadiiAndYPosition		; $65e0
	ld a,b			; $65e3
	cp $0f			; $65e4
	ret nz			; $65e6

	; Fully emerged
	ld h,d			; $65e7
	ld l,Enemy.state		; $65e8
	inc (hl)		; $65ea
	ld l,Enemy.counter1		; $65eb
	ld (hl),150		; $65ed
	inc l			; $65ef
	ld (hl),180 ; [counter2]


; Fully emerged from ground, firing at Link until counter2 reaches 0
@stateA:
	call @decCounter2Every4Frames		; $65f2
	jr nz,++		; $65f5
	ld l,e			; $65f7
	inc (hl) ; [state]++
	ld a,$01		; $65f9
	jp enemySetAnimation		; $65fb
++
	; Randomly fire projectile when [counter1] reaches 0
	call _ecom_decCounter1		; $65fe
	jr nz,@animate	; $6601

	ld (hl),150		; $6603

	call getRandomNumber_noPreserveVars		; $6605
	cp $b4			; $6608
	jr nc,@animate	; $660a

	ld b,PARTID_GOPONGA_PROJECTILE		; $660c
	call _ecom_spawnProjectile		; $660e
@animate:
	jp enemyAnimate		; $6611


; Moving back into the ground
@stateB:
	call enemyAnimate		; $6614
	ld e,Enemy.animParameter		; $6617
	ld a,(de)		; $6619
	or a			; $661a
	ret z			; $661b

	bit 7,a			; $661c
	jr z,@updateCollisionRadiiAndYPosition	; $661e

	; Head reached the ground
	call _ecom_incState		; $6620
	ld l,Enemy.collisionType		; $6623
	res 7,(hl)		; $6625
	ld l,Enemy.counter1		; $6627
	ld (hl),60		; $6629
	ret			; $662b


; Head is in the ground, flickering, for 60 frames.
@stateC:
	call _ecom_decCounter1		; $662c
	jp nz,_ecom_flickerVisibility		; $662f

	ld l,Enemy.state		; $6632
	inc (hl)		; $6634

	ld l,Enemy.counter1		; $6635
	ld (hl),180		; $6637
	jp objectSetInvisible		; $6639


; Waiting underground for [counter1] frames.
@stateD:
	call _ecom_decCounter1		; $663c
	ret nz			; $663f
	ld (hl),60		; $6640

	ld l,e			; $6642
	ld (hl),$08 ; [state]

	xor a			; $6645
	jp enemySetAnimation		; $6646

;;
; Updates the podoboo tower's collision radius and y-position while it's emerging from the
; ground.
;
; @param	a	Index of data to read (multiple of 3)
; @addr{6649}
@updateCollisionRadiiAndYPosition:
	sub $03			; $6649
	ld hl,@data		; $664b
	rst_addAToHl			; $664e
	ld e,Enemy.collisionRadiusY		; $664f
	ldi a,(hl)		; $6651
	ld (de),a		; $6652
	inc e			; $6653
	ldi a,(hl)		; $6654
	ld (de),a		; $6655

	ld e,Enemy.var30		; $6656
	ld a,(de)		; $6658
	add (hl)		; $6659
	ld e,Enemy.yh		; $665a
	ld (de),a		; $665c

	ld e,Enemy.animParameter		; $665d
	xor a			; $665f
	ld (de),a		; $6660
	ret			; $6661

; b0: collisionRadiusY
; b1: collisionRadiusX
; b2: Offset for y-position
@data:
	.db $06 $04 $00
	.db $08 $04 $f9
	.db $0b $04 $f7
	.db $0f $04 $f4
	.db $12 $04 $f2

;;
; @addr{6671}
@decCounter2Every4Frames:
	ld a,(wFrameCounter)		; $6671
	and $03			; $6674
	ret nz			; $6676
	jp _ecom_decCounter2		; $6677


; ==============================================================================
; ENEMYID_THWIMP
;
; Variables:
;   var30: Original y-position (where it returns to after stomping)
; ==============================================================================
enemyCode2e:
	jr z,@normalStatus	; $667a
	sub ENEMYSTATUS_NO_HEALTH			; $667c
	ret c			; $667e

@normalStatus:
	ld e,Enemy.state		; $667f
	ld a,(de)		; $6681
	rst_jumpTable			; $6682
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC


@state_uninitialized:
	ld e,Enemy.yh		; $669d
	ld a,(de)		; $669f
	ld e,Enemy.var30		; $66a0
	ld (de),a		; $66a2

	ld h,d			; $66a3
	ld l,Enemy.counter1		; $66a4
	inc (hl)		; $66a6

	ld l,Enemy.angle		; $66a7
	ld (hl),ANGLE_DOWN		; $66a9
	jp _ecom_setSpeedAndState8AndVisible		; $66ab


@state_stub:
	ret			; $66ae


; Cooldown of [counter1] frames
@state8:
	call _ecom_decCounter1		; $66af
	ret nz			; $66b2
	ld l,e			; $66b3
	inc (hl) ; [state]
	xor a			; $66b5
	ret			; $66b6


; Waiting for Link to approach
@state9:
	ld h,d			; $66b7
	ld l,Enemy.xh		; $66b8
	ldh a,(<hEnemyTargetX)	; $66ba
	sub (hl)		; $66bc
	add $0a			; $66bd
	cp $15			; $66bf
	ret nc			; $66c1

	ld l,e			; $66c2
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $66c4
	xor a			; $66c6
	ldi (hl),a		; $66c7
	ld (hl),a		; $66c8

	inc a			; $66c9
	jp enemySetAnimation		; $66ca


; Falling down
@stateA:
	ld a,$40		; $66cd
	call objectUpdateSpeedZ_sidescroll		; $66cf
	jr c,@landed	; $66d2

	; Cap speedZ to $0200 (ish... doesn't fix the low byte)
	ld a,(hl)		; $66d4
	cp $03			; $66d5
	ret c			; $66d7
	ld (hl),$02		; $66d8
	ret			; $66da

@landed:
	call _ecom_incState		; $66db
	ld l,Enemy.counter1		; $66de
	ld (hl),45		; $66e0
	ld a,SND_CLINK		; $66e2
	jp playSound		; $66e4


; Just landed. Wait for [counter1] frames
@stateB:
	call @state8		; $66e7
	ret nz			; $66ea
	jp enemySetAnimation		; $66eb


; Moving back up at constant speed
@stateC:
	ld h,d			; $66ee
	ld l,Enemy.y		; $66ef
	ld a,(hl)		; $66f1
	sub $80			; $66f2
	ldi (hl),a		; $66f4
	ld a,(hl)		; $66f5
	sbc $00			; $66f6
	ld (hl),a		; $66f8

	ld e,Enemy.var30		; $66f9
	ld a,(de)		; $66fb
	cp (hl)			; $66fc
	ret nz			; $66fd

	ld l,Enemy.counter1		; $66fe
	ld (hl),24		; $6700
	ld l,Enemy.state		; $6702
	ld (hl),$08		; $6704
	ret			; $6706


; ==============================================================================
; ENEMYID_THWOMP
;
; Variables:
;   var30: Original y-position (where it returns to after stomping)
; ==============================================================================
enemyCode2f:
	jr z,@normalStatus	; $6707
	sub ENEMYSTATUS_NO_HEALTH			; $6709
	ret c			; $670b

@normalStatus:
	call @runState		; $670c
	jp _thwomp_updateLinkRidingSelf		; $670f

@runState:
	ld e,Enemy.state		; $6712
	ld a,(de)		; $6714
	rst_jumpTable			; $6715
	.dw _thwomp_uninitialized
	.dw _thwomp_state_stub
	.dw _thwomp_state_stub
	.dw _thwomp_state_stub
	.dw _thwomp_state_stub
	.dw _thwomp_state_stub
	.dw _thwomp_state_stub
	.dw _thwomp_state_stub
	.dw _thwomp_state8
	.dw _thwomp_state9
	.dw _thwomp_stateA
	.dw _thwomp_stateB


_thwomp_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call _ecom_setSpeedAndState8		; $672e

	ld l,Enemy.var30		; $6731
	ld e,Enemy.yh		; $6733
	ld a,(de)		; $6735
	ld (hl),a		; $6736

	ld l,Enemy.angle		; $6737
	ld (hl),ANGLE_DOWN		; $6739
	ld a,$04		; $673b
	call enemySetAnimation		; $673d
	jp objectSetVisible82		; $6740


_thwomp_state_stub:
	ret			; $6743


; Waiting for Link to approach
_thwomp_state8:
	ld h,d			; $6744
	ld l,Enemy.xh		; $6745
	ld a,(w1Link.xh)		; $6747
	sub (hl)		; $674a
	add $14			; $674b
	cp $29			; $674d
	jr c,@linkApproached	; $674f

	; Update eye looking at Link
	call objectGetAngleTowardLink		; $6751
	add $02			; $6754
	and $1c			; $6756
	ld h,d			; $6758
	ld l,Enemy.angle		; $6759
	cp (hl)			; $675b
	ret z			; $675c
	ld (hl),a		; $675d
	rrca			; $675e
	rrca			; $675f
	jp enemySetAnimation		; $6760

@linkApproached:
	call _ecom_incState		; $6763
	ld l,Enemy.speedZ		; $6766
	xor a			; $6768
	ldi (hl),a		; $6769
	ld (hl),a		; $676a
	ld a,$08		; $676b
	jp enemySetAnimation		; $676d


; Falling to ground
_thwomp_state9:
	ld b,$10		; $6770
	ld a,$30		; $6772
	call objectUpdateSpeedZ_sidescroll_givenYOffset		; $6774
	jr c,@hitGround	; $6777

	; Cap speedZ to $0200 (ish... doesn't fix the low byte)
	ld a,(hl)		; $6779
	cp $03			; $677a
	ret c			; $677c
	ld (hl),$02		; $677d
	ret			; $677f

@hitGround:
	call _ecom_incState		; $6780

	ld l,Enemy.counter2		; $6783
	ld (hl),60		; $6785
	ld a,45		; $6787
	ld (wScreenShakeCounterY),a		; $6789

	ld a,SND_DOORCLOSE		; $678c
	jp playSound		; $678e


; Resting on ground for 50 frames after hitting it, then moving back to starting position
_thwomp_stateA:
	call _ecom_decCounter2		; $6791
	ret nz			; $6794

	ld e,Enemy.yh		; $6795
	ld l,Enemy.var30		; $6797
	ld a,(de)		; $6799
	cp (hl)			; $679a
	jr z,@doneMovingUp	; $679b

	ld l,Enemy.y		; $679d
	ld a,(hl)		; $679f
	sub $80			; $67a0
	ldi (hl),a		; $67a2
	ld a,(hl)		; $67a3
	sbc $00			; $67a4
	ld (hl),a		; $67a6
	ret			; $67a7

@doneMovingUp:
	ld l,Enemy.state		; $67a8
	inc (hl)		; $67aa

	ld l,Enemy.counter1		; $67ab
	ld (hl),$20		; $67ad
	ret			; $67af


; Cooldown before stomping again
_thwomp_stateB:
	call _ecom_decCounter1		; $67b0
	ret nz			; $67b3

	ld l,e			; $67b4
	ld (hl),$08 ; [state] = 8
	jp _thwomp_updateLinkRidingSelf		; $67b7


;;
; Unused function
;
; @param	bc	Position offset
; @param[out]	a	Tile collisions at thwomp's position + offset bc
; @addr{67ba}
_thwomp_func67ba:
	ld e,Enemy.yh		; $67ba
	ld a,(de)		; $67bc
	add b			; $67bd
	ld b,a			; $67be
	ld e,Enemy.xh		; $67bf
	ld a,(de)		; $67c1
	ld c,a			; $67c2
	jp getTileCollisionsAtPosition		; $67c3


;;
; Checks if Link is riding the thwomp, updates appropriate variables if so.
; @addr{67c6}
_thwomp_updateLinkRidingSelf:
	ld h,d			; $67c6
	ld l,Enemy.xh		; $67c7
	ld a,(w1Link.xh)		; $67c9
	sub (hl)		; $67cc
	add $13			; $67cd
	cp $27			; $67cf
	jr nc,@notRiding		; $67d1

	ld a,(w1Link.collisionRadiusY)		; $67d3
	ld b,a			; $67d6
	ld l,Enemy.collisionRadiusY		; $67d7
	ld e,Enemy.yh		; $67d9
	ld a,(de)		; $67db
	sub (hl)		; $67dc
	sub b			; $67dd
	ld c,a			; $67de

	ld a,(w1Link.yh)		; $67df
	sub c			; $67e2
	add $03			; $67e3
	cp $07			; $67e5
	jr nc,@notRiding		; $67e7

	ld a,c			; $67e9
	sub $03			; $67ea
	ld (w1Link.yh),a		; $67ec
	ld a,d			; $67ef
	ld (wLinkRidingObject),a		; $67f0
	ret			; $67f3

@notRiding:
	; Only clear wLinkRidingObject if it's already equal to this object's index.
	ld a,(wLinkRidingObject)		; $67f4
	sub d			; $67f7
	ret nz			; $67f8
	ld (wLinkRidingObject),a		; $67f9
	ret			; $67fc


;;; split

; ==============================================================================
; ENEMYID_VERAN_SPIDER
; ==============================================================================
enemyCode0f:
	ld b,a			; $67fd

	; Kill spiders when a cutscene trigger occurs
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $67fe
	or a			; $6801
	ld a,b			; $6802
	jr z,+			; $6803
	ld a,ENEMYSTATUS_NO_HEALTH		; $6805
+
	or a			; $6807
	jr z,@normalStatus			; $6808
	sub ENEMYSTATUS_NO_HEALTH			; $680a
	ret c			; $680c
	jp z,enemyDie		; $680d
	dec a			; $6810
	jp nz,_ecom_updateKnockback		; $6811
	ret			; $6814

@normalStatus:
	call _ecom_checkScentSeedActive		; $6815
	jr z,++			; $6818
	ld e,Enemy.speed		; $681a
	ld a,SPEED_140		; $681c
	ld (de),a		; $681e
++
	ld e,Enemy.state		; $681f
	ld a,(de)		; $6821
	rst_jumpTable			; $6822
	.dw _veranSpider_state_uninitialized
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_switchHook
	.dw _veranSpider_state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_stub
	.dw _veranSpider_state8
	.dw _veranSpider_state9
	.dw _veranSpider_stateA


_veranSpider_state_uninitialized:
	ld a,PALH_8a		; $6839
	call loadPaletteHeader		; $683b

	; Choose a random position roughly within the current screen bounds to spawn the
	; spider at. This prevents the spider from spawning off-screen. But, the width is
	; only checked properly in the last row; if this were spawned in a small room, the
	; spiders could spawn off-screen. (Large rooms aren't a problem since there is no
	; off-screen area to the right, aside from one column, which is marked as solid.)
--
	call getRandomNumber		; $683e
	and $7f			; $6841
	cp $70 + SCREEN_WIDTH			; $6843
	jr nc,--		; $6845

	ld c,a			; $6847
	call objectSetShortPosition		; $6848

	; Adjust position to be relative to screen bounds
	ldh a,(<hCameraX)	; $684b
	add (hl)		; $684d
	ldd (hl),a		; $684e
	ld c,a			; $684f

	dec l			; $6850
	ldh a,(<hCameraY)	; $6851
	add (hl)		; $6853
	ld (hl),a		; $6854
	ld b,a			; $6855

	; If solid at this position, try again next frame.
	call getTileCollisionsAtPosition		; $6856
	ret nz			; $6859

	ld c,$08		; $685a
	call _ecom_setZAboveScreen		; $685c
	ld a,SPEED_60		; $685f
	call _ecom_setSpeedAndState8		; $6861

	ld l,Enemy.collisionType		; $6864
	set 7,(hl)		; $6866

	ld a,SND_FALLINHOLE		; $6868
	call playSound		; $686a
	jp objectSetVisiblec1		; $686d


_veranSpider_state_switchHook:
	inc e			; $6870
	ld a,(de)		; $6871
	rst_jumpTable			; $6872
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $687b

@substate3:
	ld b,$09		; $687c
	jp _ecom_fallToGroundAndSetState		; $687e


_veranSpider_state_scentSeed:
	ld a,(wScentSeedActive)		; $6881
	or a			; $6884
	jr z,_veranSpider_gotoState9	; $6885

	call _ecom_updateAngleToScentSeed		; $6887
	ld e,Enemy.angle		; $688a
	ld a,(de)		; $688c
	and $18			; $688d
	add $04			; $688f
	ld (de),a		; $6891
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6892


;;
; @addr{6895}
_veranSpider_updateAnimation:
	ld h,d			; $6895
	ld l,Enemy.animCounter		; $6896
	ld a,(hl)		; $6898
	sub $03			; $6899
	jr nc,+			; $689b
	xor a			; $689d
+
	inc a			; $689e
	ld (hl),a		; $689f
	jp enemyAnimate		; $68a0

;;
; @addr{68a3}
_veranSpider_gotoState9:
	ld h,d			; $68a3
	ld l,Enemy.state		; $68a4
	ld (hl),$09		; $68a6
	ld l,Enemy.speed		; $68a8
	ld (hl),SPEED_60		; $68aa
	ret			; $68ac


_veranSpider_state_stub:
	ret			; $68ad


; Falling from sky
_veranSpider_state8:
	ld c,$0e		; $68ae
	call objectUpdateSpeedZ_paramC		; $68b0
	ret nz			; $68b3

	; Landed on ground
	ld l,Enemy.speedZ		; $68b4
	ldi (hl),a		; $68b6
	ld (hl),a		; $68b7

	ld l,Enemy.state		; $68b8
	inc (hl)		; $68ba

	; Enable scent seeds
	ld l,Enemy.var3f		; $68bb
	set 4,(hl)		; $68bd

	call objectSetVisiblec2		; $68bf
	ld a,SND_BOMB_LAND		; $68c2
	call playSound		; $68c4

	call _veranSpider_setRandomAngleAndCounter1		; $68c7
	jr _veranSpider_animate		; $68ca


; Moving in some direction for [counter1] frames
_veranSpider_state9:
	; Check if Link is along a diagonal relative to self?
	call objectGetAngleTowardEnemyTarget		; $68cc
	and $07			; $68cf
	sub $04			; $68d1
	inc a			; $68d3
	cp $03			; $68d4
	jr nc,@moveNormally	; $68d6

	; He is on a diagonal; if counter2 is zero, go to state $0a (charge at Link).
	ld e,Enemy.counter2		; $68d8
	ld a,(de)		; $68da
	or a			; $68db
	jr nz,@moveNormally	; $68dc

	call _ecom_updateAngleTowardTarget		; $68de
	and $18			; $68e1
	add $04			; $68e3
	ld (de),a		; $68e5

	call _ecom_incState		; $68e6
	ld l,Enemy.speed		; $68e9
	ld (hl),SPEED_140		; $68eb
	ld l,Enemy.counter1		; $68ed
	ld (hl),120		; $68ef
	ret			; $68f1

@moveNormally:
	call _ecom_decCounter2		; $68f2
	dec l			; $68f5
	dec (hl) ; [counter1]--
	call nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $68f7
	jp z,_veranSpider_setRandomAngleAndCounter1		; $68fa

_veranSpider_animate:
	jp enemyAnimate		; $68fd


; Charging in some direction for [counter1] frames
_veranSpider_stateA:
	call _ecom_decCounter1		; $6900
	jr z,++			; $6903
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6905
	jp nz,_veranSpider_updateAnimation		; $6908
++
	call _veranSpider_gotoState9		; $690b
	ld l,Enemy.counter2		; $690e
	ld (hl),$40		; $6910


;;
; @addr{6912}
_veranSpider_setRandomAngleAndCounter1:
	ld bc,$1870		; $6912
	call _ecom_randomBitwiseAndBCE		; $6915
	ld e,Enemy.angle		; $6918
	ld a,b			; $691a
	add $04			; $691b
	ld (de),a		; $691d
	ld e,Enemy.counter1		; $691e
	ld a,c			; $6920
	add $70			; $6921
	ld (de),a		; $6923
	ret			; $6924


; ==============================================================================
; ENEMYID_EYESOAR_CHILD
;
; Variables:
;   relatedObj1: Pointer to ENEMYID_EYESOAR
;   relatedObj2: Pointer to INTERACID_0b?
;   var30: Distance away from Eyesoar (position in "circle arc")
;   var31: "Target" distance away from Eyesoar (var30 is moving toward this value)
;   var32: Angle offset for this child (each subid is a quarter circle apart)
;
; See also ENEMYID_EYESOAR variables.
; ==============================================================================
enemyCode11:
	jr z,@normalStatus	; $6925
	sub ENEMYSTATUS_NO_HEALTH			; $6927
	ret c			; $6929
	jr nz,@normalStatus	; $692a

	ld a,Object.health		; $692c
	call objectGetRelatedObject1Var		; $692e
	ld a,(hl)		; $6931
	or a			; $6932
	jp z,enemyDie_uncounted		; $6933

	call objectCreatePuff		; $6936
	ld h,d			; $6939
	ld l,Enemy.state		; $693a
	ld (hl),$0c		; $693c

	ld l,Enemy.counter1		; $693e
	ld (hl),30		; $6940

	ld l,Enemy.var30		; $6942
	ld (hl),$00		; $6944

	ld l,Enemy.collisionType		; $6946
	res 7,(hl)		; $6948

	ld l,Enemy.health		; $694a
	ld (hl),$04		; $694c
	call objectSetInvisible		; $694e

@normalStatus:
	ld a,Object.var39		; $6951
	call objectGetRelatedObject1Var		; $6953
	bit 1,(hl)		; $6956
	ld b,h			; $6958

	ld e,Enemy.state		; $6959
	jr z,@runState	; $695b
	ld a,(de)		; $695d
	cp $0f			; $695e
	jr nc,@runState	; $6960
	cp $0c			; $6962
	ld h,d			; $6964
	jr z,++		; $6965

	ld l,e			; $6967
	ld (hl),$0f ; [state]
	ld l,Enemy.counter1		; $696a
	ld (hl),$f0		; $696c
++
	ld l,Enemy.var31		; $696e
	ld (hl),$18		; $6970

@runState:
	; Note: b == parent (ENEMYID_EYESOAR), which is used in some of the states below.
	ld a,(de)		; $6972
	rst_jumpTable			; $6973
	.dw _eyesoarChild_state_uninitialized
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state8
	.dw _eyesoarChild_state9
	.dw _eyesoarChild_stateA
	.dw _eyesoarChild_stateB
	.dw _eyesoarChild_stateC
	.dw _eyesoarChild_stateD
	.dw _eyesoarChild_stateE
	.dw _eyesoarChild_stateF
	.dw _eyesoarChild_state10


_eyesoarChild_state_uninitialized:
	ld a,Object.yh		; $6996
	call objectGetRelatedObject1Var		; $6998
	ld b,(hl)		; $699b
	ld l,Enemy.xh		; $699c
	ld c,(hl)		; $699e

	ld e,Enemy.subid		; $699f
	ld a,(de)		; $69a1
	ld hl,@initialAnglesForSubids		; $69a2
	rst_addAToHl			; $69a5

	ld e,Enemy.angle		; $69a6
	ld a,(hl)		; $69a8
	ld (de),a		; $69a9
	ld e,Enemy.var32		; $69aa
	ld (de),a		; $69ac
	ld a,$18		; $69ad
	call objectSetPositionInCircleArc		; $69af

	ld e,Enemy.counter1		; $69b2
	ld a,90		; $69b4
	ld (de),a		; $69b6
	ld a,SPEED_100		; $69b7
	jp _ecom_setSpeedAndState8		; $69b9

@initialAnglesForSubids:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN, ANGLE_LEFT



_eyesoarChild_state_stub:
	ret			; $69c0


; Wait for [counter1] frames before becoming visible
_eyesoarChild_state8:
	call _ecom_decCounter1		; $69c1
	ret nz			; $69c4
	ldbc INTERACID_0b,$02		; $69c5
	call objectCreateInteraction		; $69c8
	ret nz			; $69cb
	ld e,Enemy.relatedObj2		; $69cc
	ld a,Interaction.start		; $69ce
	ld (de),a		; $69d0
	inc e			; $69d1
	ld a,h			; $69d2
	ld (de),a		; $69d3

	jp _ecom_incState		; $69d4


_eyesoarChild_state9:
	ld a,Object.animParameter		; $69d7
	call objectGetRelatedObject2Var		; $69d9
	bit 7,(hl)		; $69dc
	ret z			; $69de

	call _ecom_incState		; $69df
	ld l,Enemy.counter1		; $69e2
	ld (hl),$f0		; $69e4
	ld l,Enemy.zh		; $69e6
	ld (hl),$fe		; $69e8
	ld l,Enemy.var30		; $69ea
	ld (hl),$18		; $69ec
	jp objectSetVisiblec2		; $69ee


; Moving around Eyesoar in a circle
_eyesoarChild_stateA:
	ld h,b			; $69f1
	ld l,Enemy.var39		; $69f2
	bit 2,(hl)		; $69f4
	jr z,_eyesoarChild_updatePosition			; $69f6

	ld l,Enemy.var38		; $69f8
	ld a,(hl)		; $69fa
	and $f8			; $69fb
	ld e,Enemy.var31		; $69fd
	ld (de),a		; $69ff
	ld e,Enemy.state		; $6a00
	ld a,$0b		; $6a02
	ld (de),a		; $6a04

;;
; @addr{6a05}
_eyesoarChild_updatePosition:
	ld l,Enemy.yh		; $6a05
	ld b,(hl)		; $6a07
	ld l,Enemy.xh		; $6a08
	ld c,(hl)		; $6a0a

	; [this.var32] += [parent.var3b] (update angle by rotation speed)
	ld l,Enemy.var3b		; $6a0b
	ld e,Enemy.var32		; $6a0d
	ld a,(de)		; $6a0f
	add (hl)		; $6a10
	and $1f			; $6a11
	ld e,Enemy.angle		; $6a13
	ld (de),a		; $6a15

	ld h,d			; $6a16
	ld l,Enemy.var30		; $6a17
	ld a,(hl)		; $6a19
	call objectSetPositionInCircleArc		; $6a1a
	jp enemyAnimate		; $6a1d


_eyesoarChild_stateB:
	; Check if we're the correct distance away
	ld h,d			; $6a20
	ld l,Enemy.var31		; $6a21
	ldd a,(hl)		; $6a23
	cp (hl) ; [var30]
	jr nz,_eyesoarChild_incOrDecHL	; $6a25

	ld l,e			; $6a27
	dec (hl) ; [state]

	; Mark flag in parent indicating we're in position
	ld h,b			; $6a29
	ld l,Enemy.var3a		; $6a2a
	ld e,Enemy.subid		; $6a2c
	ld a,(de)		; $6a2e
	call setFlag		; $6a2f
	jr _eyesoarChild_updatePosition		; $6a32


_eyesoarChild_incOrDecHL:
	ld a,$01		; $6a34
	jr nc,+			; $6a36
	ld a,$ff		; $6a38
+
	add (hl)		; $6a3a
	ld (hl),a		; $6a3b
	ld h,b			; $6a3c
	jr _eyesoarChild_updatePosition		; $6a3d


; Was just "killed"; waiting a bit before reappearing
_eyesoarChild_stateC:
	ld h,b			; $6a3f
	ld l,Enemy.var39		; $6a40
	bit 0,(hl)		; $6a42
	jr nz,@stillInvisible	; $6a44
	call _ecom_decCounter1		; $6a46
	jr nz,@stillInvisible	; $6a49

	ld l,e			; $6a4b
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $6a4d
	set 7,(hl)		; $6a4f
	call objectSetVisiblec2		; $6a51
	ld h,b			; $6a54
	jr _eyesoarChild_updatePosition		; $6a55

@stillInvisible:
	ld h,b			; $6a57
	ld e,Enemy.subid		; $6a58
	ld a,(de)		; $6a5a
	ld bc,@data		; $6a5b
	call addAToBc		; $6a5e
	ld a,(bc)		; $6a61
	ld l,Enemy.var3a		; $6a62
	or (hl)			; $6a64
	ld (hl),a		; $6a65
	ret			; $6a66

@data:
	.db $11 $22 $44 $88


; Just reappeared
_eyesoarChild_stateD:
	; Update position relative to eyesoar
	ld h,b			; $6a6b
	ld l,Enemy.var38		; $6a6c
	ld a,(hl)		; $6a6e
	and $f8			; $6a6f
	ld h,d			; $6a71
	ld l,Enemy.var30		; $6a72
	cp (hl)			; $6a74
	jr nz,_eyesoarChild_incOrDecHL	; $6a75

	; Reached desired position, go back to state $0a
	ld l,Enemy.state		; $6a77
	ld (hl),$0a		; $6a79

	ld h,b			; $6a7b
	jp _eyesoarChild_updatePosition		; $6a7c


_eyesoarChild_stateE:
	ld h,b			; $6a7f
	ld l,Enemy.var39		; $6a80
	bit 4,(hl)		; $6a82
	jp nz,_eyesoarChild_updatePosition		; $6a84

	ld a,$0b		; $6a87
	ld (de),a ; [state]
	jp _eyesoarChild_updatePosition		; $6a8a


; Moving around randomly
_eyesoarChild_stateF:
	ld h,b			; $6a8d
	ld l,Enemy.var39		; $6a8e
	bit 3,(hl)		; $6a90
	jr nz,@stillMovingRandomly	; $6a92

	; Calculate the angle relative to Eyesoar it should move to
	ld l,Enemy.var3b		; $6a94
	ld e,Enemy.var32		; $6a96
	ld a,(de)		; $6a98
	add (hl)		; $6a99
	and $1f			; $6a9a
	ld e,Enemy.angle		; $6a9c
	ld (de),a		; $6a9e

	call _ecom_incState		; $6a9f

	; $18 units away from Eyesoar
	ld l,Enemy.var30		; $6aa2
	ld (hl),$18		; $6aa4

	jr _eyesoarChild_animate		; $6aa6

@stillMovingRandomly:
	ld a,(wFrameCounter)		; $6aa8
	and $0f			; $6aab
	jr nz,+			; $6aad
	call objectGetAngleTowardEnemyTarget		; $6aaf
	call objectNudgeAngleTowards		; $6ab2
+
	call objectApplySpeed		; $6ab5
	call _ecom_bounceOffScreenBoundary		; $6ab8

_eyesoarChild_animate:
	jp enemyAnimate		; $6abb


; Moving back toward Eyesoar
_eyesoarChild_state10:
	; Load into wTmpcec0 the position offset relative to Eyesoar where we should be
	; moving to
	ld h,b			; $6abe
	ld l,Enemy.var3b		; $6abf
	ld a,(hl)		; $6ac1
	ld e,Enemy.var32		; $6ac2
	ld a,(de)		; $6ac4
	add (hl)		; $6ac5
	and $1f			; $6ac6
	ld c,a			; $6ac8
	ld a,$18		; $6ac9
	ld b,SPEED_100		; $6acb
	call getScaledPositionOffsetForVelocity		; $6acd

	; Get parent.position + offset in bc
	ld a,Object.yh		; $6ad0
	call objectGetRelatedObject1Var		; $6ad2
	ld a,(wTmpcec0+1)		; $6ad5
	add (hl)		; $6ad8
	ld b,a			; $6ad9
	ld l,Enemy.xh		; $6ada
	ld a,(wTmpcec0+3)		; $6adc
	add (hl)		; $6adf
	ld c,a			; $6ae0

	; Store current position
	ld e,l			; $6ae1
	ld a,(de)		; $6ae2
	ldh (<hFF8E),a	; $6ae3
	ld e,Enemy.yh		; $6ae5
	ld a,(de)		; $6ae7
	ldh (<hFF8F),a	; $6ae8

	; Check if we've reached the target position
	cp b			; $6aea
	jr nz,++		; $6aeb
	ldh a,(<hFF8E)	; $6aed
	cp c			; $6aef
	jr z,@reachedTargetPosition	; $6af0
++
	call _ecom_moveTowardPosition		; $6af2
	jr _eyesoarChild_animate		; $6af5

@reachedTargetPosition:
	; Wait for signal to change state
	ld l,Enemy.var39		; $6af7
	bit 1,(hl)		; $6af9
	ret nz			; $6afb

	ld e,Enemy.state		; $6afc
	ld a,$0e		; $6afe
	ld (de),a		; $6b00

	; Set flag in parent's var3a indicating we're good to go?
	ld e,Enemy.subid		; $6b01
	ld a,(de)		; $6b03
	add $04			; $6b04
	ld l,Enemy.var3a		; $6b06
	jp setFlag		; $6b08


; ==============================================================================
; ENEMYID_IRON_MASK
; ==============================================================================
enemyCode1c:
	call _ecom_checkHazards		; $6b0b
	jr z,@normalStatus	; $6b0e
	sub ENEMYSTATUS_NO_HEALTH			; $6b10
	ret c			; $6b12
	jp z,enemyDie		; $6b13
	dec a			; $6b16
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6b17

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $6b1a
	jr c,@commonState	; $6b1d
	bit 0,b			; $6b1f
	jp z,_ironMask_subid00		; $6b21
	jp _ironMask_subid01		; $6b24

@commonState:
	rst_jumpTable			; $6b27
	.dw _ironMask_state_uninitialized
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub
	.dw _ironMask_state_switchHook
	.dw _ironMask_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub


_ironMask_state_uninitialized:
	ld a,SPEED_80		; $6b38
	call _ecom_setSpeedAndState8AndVisible		; $6b3a

	ld l,Enemy.counter1		; $6b3d
	inc (hl)		; $6b3f

	bit 0,b			; $6b40
	ret z			; $6b42

	; Subid 1 only
	ld l,Enemy.enemyCollisionMode		; $6b43
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK		; $6b45
	ld l,Enemy.knockbackCounter		; $6b47
	ld (hl),$10		; $6b49
	ld l,Enemy.invincibilityCounter		; $6b4b
	ld (hl),$e8		; $6b4d
	ld a,$04		; $6b4f
	jp enemySetAnimation		; $6b51


_ironMask_state_switchHook:
	inc e			; $6b54
	ld a,(de)		; $6b55
	rst_jumpTable			; $6b56
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

; Using switch hook may cause this enemy's mask to be removed.
@substate0:
	ld e,Enemy.subid		; $6b5f
	ld a,(de)		; $6b61
	or a			; $6b62
	jr nz,@dontRemoveMask	; $6b63

	ld e,Enemy.enemyCollisionMode		; $6b65
	ld a,(de)		; $6b67
	cp ENEMYCOLLISION_UNMASKED_IRON_MASK			; $6b68
	jr z,@dontRemoveMask	; $6b6a

	ld b,ENEMYID_IRON_MASK		; $6b6c
	call _ecom_spawnUncountedEnemyWithSubid01		; $6b6e
	jr nz,@dontRemoveMask	; $6b71

	; Transfer "index" from enabled byte to new enemy
	ld l,Enemy.enabled		; $6b73
	ld e,l			; $6b75
	ld a,(de)		; $6b76
	ld (hl),a		; $6b77

	ld l,Enemy.knockbackAngle		; $6b78
	ld e,l			; $6b7a
	ld a,(de)		; $6b7b
	ld (hl),a		; $6b7c
	call objectCopyPosition		; $6b7d

	ld a,$05		; $6b80
	call enemySetAnimation		; $6b82

	ld a,SND_BOMB_LAND		; $6b85
	call playSound		; $6b87

	ld a,60		; $6b8a
	jr ++			; $6b8c

@dontRemoveMask:
	ld a,16		; $6b8e
++
	ld e,Enemy.counter1		; $6b90
	ld (de),a		; $6b92
	jp _ecom_incState2		; $6b93

@substate1:
@substate2:
	ret			; $6b96

@substate3:
	ld e,Enemy.subid		; $6b97
	ld a,(de)		; $6b99
	or a			; $6b9a
	jp nz,_ecom_fallToGroundAndSetState8		; $6b9b

	ld e,Enemy.enemyCollisionMode		; $6b9e
	ld a,(de)		; $6ba0
	cp ENEMYCOLLISION_IRON_MASK			; $6ba1
	jp nz,_ecom_fallToGroundAndSetState8		; $6ba3

	ld b,$0a		; $6ba6
	call _ecom_fallToGroundAndSetState		; $6ba8

	ld l,Enemy.collisionType		; $6bab
	res 7,(hl)		; $6bad
	ret			; $6baf


_ironMask_state_stub:
	ret			; $6bb0


; Iron mask with mask on
_ironMask_subid00:
	ld a,(de)		; $6bb1
	sub $08			; $6bb2
	rst_jumpTable			; $6bb4
	.dw @state8
	.dw @state9
	.dw @stateA


; Standing in place
@state8:
	call _ecom_decCounter1		; $6bbb
	jp nz,_ironMask_updateCollisionsFromLinkRelativeAngle		; $6bbe
	ld l,e			; $6bc1
	inc (hl) ; [state]
	call _ironMask_chooseRandomAngleAndCounter1		; $6bc3

; Moving in some direction for [counter1] frames
@state9:
	call _ecom_decCounter1		; $6bc6
	jr nz,++		; $6bc9
	ld l,e			; $6bcb
	dec (hl) ; [state]
	call _ironMask_chooseAmountOfTimeToStand		; $6bcd
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6bd0
	call _ironMask_updateCollisionsFromLinkRelativeAngle		; $6bd3
	jp enemyAnimate		; $6bd6

; This enemy has turned into the mask that was removed; will delete self after [counter1]
; frames.
@stateA:
	call _ecom_decCounter1		; $6bd9
	jp nz,_ecom_flickerVisibility		; $6bdc
	jp enemyDelete		; $6bdf


; Iron mask without mask on
_ironMask_subid01:
	call _ecom_decCounter1		; $6be2
	call z,_ironMask_chooseRandomAngleAndCounter1		; $6be5
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6be8
	jp enemyAnimate		; $6beb


;;
; Modifies this object's enemyCollisionMode based on if Link is directly behind the iron
; mask or not.
; @addr{6bee}
_ironMask_updateCollisionsFromLinkRelativeAngle:
	call objectGetAngleTowardEnemyTarget		; $6bee
	ld h,d			; $6bf1
	ld l,Enemy.angle		; $6bf2
	sub (hl)		; $6bf4
	and $1f			; $6bf5
	sub $0c			; $6bf7
	cp $09			; $6bf9
	ld l,Enemy.enemyCollisionMode		; $6bfb
	jr c,++			; $6bfd
	ld (hl),ENEMYCOLLISION_IRON_MASK		; $6bff
	ret			; $6c01
++
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK		; $6c02
	ret			; $6c04


;;
; @addr{6c05}
_ironMask_chooseRandomAngleAndCounter1:
	ld bc,$0703		; $6c05
	call _ecom_randomBitwiseAndBCE		; $6c08
	ld a,b			; $6c0b
	ld hl,@counter1Vals		; $6c0c
	rst_addAToHl			; $6c0f

	ld e,Enemy.counter1		; $6c10
	ld a,(hl)		; $6c12
	ld (de),a		; $6c13

	ld e,Enemy.subid		; $6c14
	ld a,(de)		; $6c16
	or a			; $6c17
	jp nz,_ecom_setRandomCardinalAngle		; $6c18

	; Subid 0 only: 1 in 4 chance of turning directly toward Link, otherwise just
	; choose a random angle
	call @chooseAngle		; $6c1b
	swap a			; $6c1e
	rlca			; $6c20
	ld h,d			; $6c21
	ld l,Enemy.direction		; $6c22
	cp (hl)			; $6c24
	ret z			; $6c25
	ld (hl),a		; $6c26
	jp enemySetAnimation		; $6c27

@chooseAngle:
	ld a,c			; $6c2a
	or a			; $6c2b
	jp z,_ecom_updateCardinalAngleTowardTarget		; $6c2c
	jp _ecom_setRandomCardinalAngle		; $6c2f

@counter1Vals:
	.db 25 30 35 40 45 50 55 60

;;
; @addr{6c3a}
_ironMask_chooseAmountOfTimeToStand:
	call getRandomNumber_noPreserveVars		; $6c3a
	and $03			; $6c3d
	ld hl,@counter1Vals		; $6c3f
	rst_addAToHl			; $6c42
	ld e,Enemy.counter1		; $6c43
	ld a,(hl)		; $6c45
	ld (de),a		; $6c46
	ret			; $6c47

@counter1Vals:
	.db 15 30 45 60


; ==============================================================================
; ENEMYID_VERAN_CHILD_BEE
; ==============================================================================
enemyCode1f:
	jr z,@normalStatus	; $6c4c
	sub ENEMYSTATUS_NO_HEALTH			; $6c4e
	ret c			; $6c50
	jp z,enemyDie		; $6c51
	dec a			; $6c54
	jp nz,_ecom_updateKnockbackNoSolidity		; $6c55
	ret			; $6c58

@normalStatus:
	ld e,Enemy.state		; $6c59
	ld a,(de)		; $6c5b
	rst_jumpTable			; $6c5c
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA


@state_uninitialized:
	ld a,SPEED_200		; $6c73
	call _ecom_setSpeedAndState8		; $6c75
	ld l,Enemy.counter1		; $6c78
	ld (hl),$10		; $6c7a

	ld e,Enemy.subid		; $6c7c
	ld a,(de)		; $6c7e
	ld hl,@angleVals		; $6c7f
	rst_addAToHl			; $6c82
	ld e,Enemy.angle		; $6c83
	ld a,(hl)		; $6c85
	ld (de),a		; $6c86
	jp objectSetVisible83		; $6c87

@angleVals:
	.db $10 $16 $0a


@state_stub:
	ret			; $6c8d


@state8:
	call _ecom_decCounter1		; $6c8e
	jr z,++			; $6c91
	call objectApplySpeed		; $6c93
	jr @animate		; $6c96
++
	ld (hl),$0c ; [counter1]
	ld l,e			; $6c9a
	inc (hl) ; [state]
@animate:
	jp enemyAnimate		; $6c9c


@state9:
	call _ecom_decCounter1		; $6c9f
	jr nz,@animate	; $6ca2
	ld l,e			; $6ca4
	inc (hl) ; [state]
	call _ecom_updateAngleTowardTarget		; $6ca6


@stateA:
	call objectApplySpeed		; $6ca9
	call objectCheckWithinRoomBoundary		; $6cac
	jr c,@animate	; $6caf
	call decNumEnemies		; $6cb1
	jp enemyDelete		; $6cb4


; ==============================================================================
; ENEMYID_ANGLER_FISH_BUBBLE
; ==============================================================================
enemyCode26:
	jr z,@normalStatus	; $6cb7
	sub ENEMYSTATUS_NO_HEALTH			; $6cb9
	ret c			; $6cbb
	call @popBubble		; $6cbc

@normalStatus:
	ld e,Enemy.state		; $6cbf
	ld a,(de)		; $6cc1
	rst_jumpTable			; $6cc2
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6cc9
	ld l,e			; $6cca
	inc (hl) ; [state]

	; Can bounce off walls 5 times before popping
	ld l,Enemy.counter1		; $6ccc
	ld (hl),$05		; $6cce

	ld l,Enemy.speed		; $6cd0
	ld (hl),SPEED_100		; $6cd2

	ld a,Object.direction		; $6cd4
	call objectGetRelatedObject1Var		; $6cd6
	bit 0,(hl)		; $6cd9
	ld c,$f4		; $6cdb
	jr z,+			; $6cdd
	ld c,$0c		; $6cdf
+
	ld b,$00		; $6ce1
	call objectTakePositionWithOffset		; $6ce3
	call _ecom_updateAngleTowardTarget		; $6ce6
	jp objectSetVisible81		; $6ce9


; Bubble moving around
@state1:
	ld a,Object.id		; $6cec
	call objectGetRelatedObject1Var		; $6cee
	ld a,(hl)		; $6cf1
	cp ENEMYID_ANGLER_FISH			; $6cf2
	jr nz,@popBubble	; $6cf4

	call objectApplySpeed		; $6cf6
	call _ecom_bounceOffWallsAndHoles		; $6cf9
	jr z,@animate	; $6cfc

	; Each time it bounces off a wall, decrement counter1
	call _ecom_decCounter1		; $6cfe
	jr z,@popBubble	; $6d01

@animate:
	jp enemyAnimate		; $6d03

@popBubble:
	ld h,d			; $6d06
	ld l,Enemy.state		; $6d07
	ld (hl),$02		; $6d09

	ld l,Enemy.counter1		; $6d0b
	ld (hl),$08		; $6d0d

	ld l,Enemy.collisionType		; $6d0f
	res 7,(hl)		; $6d11

	ld l,Enemy.knockbackCounter		; $6d13
	ld (hl),$00		; $6d15

	; 1 in 4 chance of item drop
	call getRandomNumber_noPreserveVars		; $6d17
	cp $40			; $6d1a
	jr nc,++		; $6d1c

	call getFreePartSlot		; $6d1e
	jr nz,++		; $6d21
	ld (hl),PARTID_ITEM_DROP		; $6d23
	inc l			; $6d25
	ld (hl),ITEM_DROP_SCENT_SEEDS		; $6d26

	ld l,Part.invincibilityCounter		; $6d28
	ld (hl),$f0		; $6d2a
	call objectCopyPosition		; $6d2c
++
	; Bubble pop animation
	ld a,$01		; $6d2f
	call enemySetAnimation		; $6d31
	jp objectSetVisible83		; $6d34


; Bubble in the process of popping
@state2:
	call _ecom_decCounter1		; $6d37
	jr nz,@animate	; $6d3a
	jp enemyDelete		; $6d3c


; ==============================================================================
; ENEMYID_ENABLE_SIDESCROLL_DOWN_TRANSITION
; ==============================================================================
enemyCode2b:
	ld e,Enemy.state		; $6d3f
	ld a,(de)		; $6d41
	or a			; $6d42
	jp z,_ecom_incState		; $6d43

	ld hl,w1Link.xh		; $6d46
	ld a,(hl)		; $6d49
	cp $d0			; $6d4a
	ret c			; $6d4c

	ld l,<w1Link.yh		; $6d4d
	ld a,(hl)		; $6d4f
	ld l,<w1Link.speedZ+1		; $6d50
	add (hl)		; $6d52
	cp LARGE_ROOM_HEIGHT<<4 - 8			; $6d53
	ret c			; $6d55

	ld a,$80|DIR_DOWN		; $6d56
	ld (wScreenTransitionDirection),a		; $6d58
	ret			; $6d5b
