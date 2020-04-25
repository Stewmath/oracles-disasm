enemyCode08:
	jr z,_label_0c_039	; $450f
	sub $03			; $4511
	ret c			; $4513
	jp z,enemyDie		; $4514
_label_0c_039:
	ld e,$84		; $4517
	ld a,(de)		; $4519
	rst_jumpTable			; $451a
	inc sp			; $451b
	ld b,l			; $451c
	scf			; $451d
	ld b,l			; $451e
	scf			; $451f
	ld b,l			; $4520
	scf			; $4521
	ld b,l			; $4522
	scf			; $4523
	ld b,l			; $4524
	scf			; $4525
	ld b,l			; $4526
	scf			; $4527
	ld b,l			; $4528
	scf			; $4529
	ld b,l			; $452a
	jr c,_label_0c_040	; $452b
	ccf			; $452d
	ld b,l			; $452e
	ld l,c			; $452f
	ld b,l			; $4530
	ld a,c			; $4531
	ld b,l			; $4532
	ld a,$09		; $4533
	ld (de),a		; $4535
	ret			; $4536
	ret			; $4537
	call _ecom_decCounter1		; $4538
	ret nz			; $453b
	ld l,e			; $453c
	inc (hl)		; $453d
	ret			; $453e
	call getRandomNumber_noPreserveVars		; $453f
	cp $98			; $4542
	ret nc			; $4544
	ld c,a			; $4545
	ldh a,(<hCameraX)	; $4546
	add c			; $4548
	ld c,a			; $4549
	ldh a,(<hCameraY)	; $454a
	ld b,a			; $454c
	ldh a,(<hRng2)	; $454d
	res 7,a			; $454f
	add b			; $4551
	ld b,a			; $4552
	call checkTileAtPositionIsWater		; $4553
	ret nc			; $4556
	ld c,l			; $4557
	call objectSetShortPosition		; $4558
	ld l,$86		; $455b
	ld (hl),$30		; $455d
	ld l,$84		; $455f
	inc (hl)		; $4561
	xor a			; $4562
	call enemySetAnimation		; $4563
	jp objectSetVisible83		; $4566
	call _ecom_decCounter1		; $4569
	jr nz,_label_0c_041	; $456c
	ld l,e			; $456e
	inc (hl)		; $456f
	ld l,$a4		; $4570
_label_0c_040:
	set 7,(hl)		; $4572
	ld a,$01		; $4574
	jp enemySetAnimation		; $4576
	ld h,d			; $4579
	ld l,$a1		; $457a
	ld a,(hl)		; $457c
	inc a			; $457d
	jr z,_label_0c_042	; $457e
	dec a			; $4580
	jr z,_label_0c_041	; $4581
	ld (hl),$00		; $4583
	ld b,$19		; $4585
	call _ecom_spawnProjectile		; $4587
	jr nz,_label_0c_041	; $458a
	ld l,$c2		; $458c
	inc (hl)		; $458e
_label_0c_041:
	jp enemyAnimate		; $458f
_label_0c_042:
	ld a,$08		; $4592
	ld (de),a		; $4594
	ld l,$a4		; $4595
	res 7,(hl)		; $4597
	call getRandomNumber_noPreserveVars		; $4599
	and $1f			; $459c
	add $18			; $459e
	ld e,$86		; $45a0
	ld (de),a		; $45a2
	ld b,$03		; $45a3
	call objectCreateInteractionWithSubid00		; $45a5
	jp objectSetInvisible		; $45a8

enemyCode09:
	call _ecom_checkHazards		; $45ab
	jr z,_label_0c_045	; $45ae
	sub $03			; $45b0
	ret c			; $45b2
	jr z,_label_0c_043	; $45b3
	dec a			; $45b5
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $45b6
	ret			; $45b9
_label_0c_043:
	ld e,$82		; $45ba
	ld a,(de)		; $45bc
	cp $04			; $45bd
	jr nz,_label_0c_044	; $45bf
	ld hl,$c6c9		; $45c1
	set 0,(hl)		; $45c4
_label_0c_044:
	jp enemyDie		; $45c6
_label_0c_045:
	call _ecom_checkScentSeedActive		; $45c9
	ld e,$84		; $45cc
	ld a,(de)		; $45ce
	rst_jumpTable			; $45cf
	add sp,$45		; $45d0
	ld h,c			; $45d2
	ld b,(hl)		; $45d3
	ld h,c			; $45d4
	ld b,(hl)		; $45d5
	ld d,l			; $45d6
	ld b,(hl)		; $45d7
	scf			; $45d8
	ld b,(hl)		; $45d9
	bit 0,h			; $45da
	ld h,c			; $45dc
	ld b,(hl)		; $45dd
	ld h,c			; $45de
	ld b,(hl)		; $45df
	ld h,d			; $45e0
	ld b,(hl)		; $45e1
	sub e			; $45e2
	ld b,(hl)		; $45e3
	cp d			; $45e4
	ld b,(hl)		; $45e5
	jp nc,$1e46		; $45e6
	add d			; $45e9
	ld a,(de)		; $45ea
	cp $04			; $45eb
	jr nz,_label_0c_046	; $45ed
	ld hl,$c6c9		; $45ef
	bit 0,(hl)		; $45f2
	jp nz,enemyDelete		; $45f4
_label_0c_046:
	rrca			; $45f7
	ld a,$14		; $45f8
	jr nc,_label_0c_047	; $45fa
	ld a,$1e		; $45fc
_label_0c_047:
	call _ecom_setSpeedAndState8AndVisible		; $45fe
	ld (hl),$0a		; $4601
	ld l,$bf		; $4603
	set 4,(hl)		; $4605
	ld e,$82		; $4607
	ld a,(de)		; $4609
	ld hl,$4632		; $460a
	rst_addAToHl			; $460d
	ld e,$b2		; $460e
	ld a,(hl)		; $4610
	ld (de),a		; $4611
	ld e,a			; $4612
	ld bc,$1803		; $4613
	call _ecom_randomBitwiseAndBCE		; $4616
	ld a,e			; $4619
	ld hl,$468b		; $461a
	rst_addAToHl			; $461d
	ld e,$86		; $461e
	ld a,(hl)		; $4620
	ld (de),a		; $4621
	ld e,$89		; $4622
	ld a,b			; $4624
	ld (de),a		; $4625
	ld a,c			; $4626
	ld hl,$46b6		; $4627
	rst_addAToHl			; $462a
	ld e,$b0		; $462b
	ld a,(hl)		; $462d
	ld (de),a		; $462e
	jp _ecom_updateAnimationFromAngle		; $462f
	rlca			; $4632
	rlca			; $4633
	inc bc			; $4634
	inc bc			; $4635
	ld bc,$f0fa		; $4636
	call z,$20b7		; $4639
	inc b			; $463c
	ld a,$08		; $463d
	ld (de),a		; $463f
	ret			; $4640
	call _ecom_updateAngleToScentSeed		; $4641
	ld e,$89		; $4644
	ld a,(de)		; $4646
	add $04			; $4647
	and $18			; $4649
	ld (de),a		; $464b
	call _ecom_updateAnimationFromAngle		; $464c
	call _ecom_applyVelocityForTopDownEnemy		; $464f
	jp enemyAnimate		; $4652
	inc e			; $4655
	ld a,(de)		; $4656
	rst_jumpTable			; $4657
	dec b			; $4658
	ld b,b			; $4659
	ld h,b			; $465a
	ld b,(hl)		; $465b
	ld h,b			; $465c
	ld b,(hl)		; $465d
	rst $38			; $465e
	ld b,h			; $465f
	ret			; $4660
	ret			; $4661
	call getRandomNumber_noPreserveVars		; $4662
	ld h,d			; $4665
	ld l,$b2		; $4666
	and (hl)		; $4668
	ld l,$84		; $4669
	jr nz,_label_0c_048	; $466b
	ld (hl),$0b		; $466d
	ld l,$86		; $466f
	ld (hl),$10		; $4671
	ld l,$82		; $4673
	ld a,(hl)		; $4675
	cp $02			; $4676
	ret c			; $4678
	call _ecom_updateCardinalAngleTowardTarget		; $4679
	jp _ecom_updateAnimationFromAngle		; $467c
_label_0c_048:
	inc (hl)		; $467f
	ld bc,$468b		; $4680
	call addAToBc		; $4683
	ld l,$86		; $4686
	ld a,(bc)		; $4688
	ld (hl),a		; $4689
	ret			; $468a
	ld e,$2d		; $468b
	inc a			; $468d
	ld c,e			; $468e
	dec l			; $468f
	inc a			; $4690
	ld c,e			; $4691
	ld e,d			; $4692
	call _ecom_decCounter1		; $4693
	ret nz			; $4696
	ld l,e			; $4697
	inc (hl)		; $4698
	ld e,$03		; $4699
	ld bc,$0318		; $469b
	call _ecom_randomBitwiseAndBCE		; $469e
	ld a,e			; $46a1
	ld hl,$46b6		; $46a2
	rst_addAToHl			; $46a5
	ld a,(hl)		; $46a6
	ld e,$b0		; $46a7
	ld (de),a		; $46a9
	ld e,$89		; $46aa
	ld a,c			; $46ac
	ld (de),a		; $46ad
	ld a,b			; $46ae
	or a			; $46af
	call z,_ecom_updateCardinalAngleTowardTarget		; $46b0
	jp _ecom_updateAnimationFromAngle		; $46b3
	add hl,de		; $46b6
	ld hl,$3129		; $46b7
	ld h,d			; $46ba
	ld l,$b0		; $46bb
	dec (hl)		; $46bd
	jr nz,_label_0c_049	; $46be
	ld l,e			; $46c0
	ld (hl),$08		; $46c1
	ret			; $46c3
_label_0c_049:
	call $414c		; $46c4
	jr nz,_label_0c_050	; $46c7
	call _ecom_setRandomCardinalAngle		; $46c9
	call _ecom_updateAnimationFromAngle		; $46cc
_label_0c_050:
	jp enemyAnimate		; $46cf
	call _ecom_decCounter1		; $46d2
	ret nz			; $46d5
	ld (hl),$20		; $46d6
	ld l,e			; $46d8
	ld (hl),$09		; $46d9
	ld b,$18		; $46db
	call _ecom_spawnProjectile		; $46dd
	ret nz			; $46e0
	ld a,$51		; $46e1
	jp playSound		; $46e3

enemyCode0a:
	call _ecom_checkHazards		; $46e6
	jr z,_label_0c_053	; $46e9
	sub $03			; $46eb
	ret c			; $46ed
	jr z,_label_0c_051	; $46ee
	dec a			; $46f0
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $46f1
	ret			; $46f4
_label_0c_051:
	ld e,$99		; $46f5
	ld a,(de)		; $46f7
	or a			; $46f8
	jr z,_label_0c_052	; $46f9
	ld h,a			; $46fb
	ld l,$d7		; $46fc
	ld (hl),$ff		; $46fe
_label_0c_052:
	jp enemyDie		; $4700
_label_0c_053:
	call _ecom_checkScentSeedActive		; $4703
	ld e,$84		; $4706
	ld a,(de)		; $4708
	rst_jumpTable			; $4709
	jr nz,_label_0c_054	; $470a
	ld e,b			; $470c
	ld b,a			; $470d
	ld e,b			; $470e
	ld b,a			; $470f
	ld b,a			; $4710
	ld b,a			; $4711
	inc l			; $4712
	ld b,a			; $4713
	bit 0,h			; $4714
	ld e,b			; $4716
	ld b,a			; $4717
	ld e,b			; $4718
	ld b,a			; $4719
	ld e,c			; $471a
	ld b,a			; $471b
	ld l,e			; $471c
	ld b,a			; $471d
	adc c			; $471e
	ld b,a			; $471f
	ld a,$14		; $4720
	call _ecom_setSpeedAndState8AndVisible		; $4722
	ld l,$bf		; $4725
	set 4,(hl)		; $4727
	jp $478f		; $4729
	ld a,($ccf0)		; $472c
	or a			; $472f
	jp z,$478f		; $4730
	call _ecom_updateAngleToScentSeed		; $4733
	ld e,$89		; $4736
	ld a,(de)		; $4738
	add $04			; $4739
	and $18			; $473b
	ld (de),a		; $473d
	call _ecom_updateAnimationFromAngle		; $473e
	call _ecom_applyVelocityForSideviewEnemy		; $4741
	jp enemyAnimate		; $4744
	inc e			; $4747
	ld a,(de)		; $4748
	rst_jumpTable			; $4749
	dec b			; $474a
	ld b,b			; $474b
	ld d,d			; $474c
	ld b,a			; $474d
	ld d,d			; $474e
	ld b,a			; $474f
	ld d,e			; $4750
	ld b,a			; $4751
	ret			; $4752
_label_0c_054:
	ld b,$0a		; $4753
	jp _ecom_fallToGroundAndSetState		; $4755
	ret			; $4758
	call _ecom_decCounter1		; $4759
	jr z,_label_0c_055	; $475c
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $475e
	jr nz,_label_0c_056	; $4761
_label_0c_055:
	ld e,$84		; $4763
	ld a,$09		; $4765
	ld (de),a		; $4767
_label_0c_056:
	jp enemyAnimate		; $4768
	call $478f		; $476b
	call objectGetAngleTowardEnemyTarget		; $476e
	add $04			; $4771
	and $18			; $4773
	swap a			; $4775
	rlca			; $4777
	ld h,d			; $4778
	ld l,$88		; $4779
	cp (hl)			; $477b
	ret nz			; $477c
	ld b,$21		; $477d
	call _ecom_spawnProjectile		; $477f
	ret nz			; $4782
	ld h,d			; $4783
	ld l,$84		; $4784
	ld (hl),$0a		; $4786
	ret			; $4788
	ld e,$99		; $4789
	ld a,(de)		; $478b
	or a			; $478c
	jr nz,_label_0c_056	; $478d
	call getRandomNumber_noPreserveVars		; $478f
	and $03			; $4792
	ld hl,$47a7		; $4794
	rst_addAToHl			; $4797
	ld e,$86		; $4798
	ld a,(hl)		; $479a
	ld (de),a		; $479b
	ld e,$84		; $479c
	ld a,$08		; $479e
	ld (de),a		; $47a0
	call _ecom_setRandomCardinalAngle		; $47a1
	jp _ecom_updateAnimationFromAngle		; $47a4
	jr nc,_label_0c_060	; $47a7
	ld d,b			; $47a9
	ld h,b			; $47aa

enemyCode0b:
	call _ecom_checkHazards		; $47ab
	jr z,_label_0c_059	; $47ae
	sub $03			; $47b0
	ret c			; $47b2
	jr z,_label_0c_057	; $47b3
	dec a			; $47b5
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $47b6
	ret			; $47b9
_label_0c_057:
	ld e,$82		; $47ba
	ld a,(de)		; $47bc
	cp $02			; $47bd
	jr nz,_label_0c_058	; $47bf
	ld b,$0b		; $47c1
	call _ecom_spawnEnemyWithSubid01		; $47c3
	ret nz			; $47c6
	inc (hl)		; $47c7
	ld e,$b0		; $47c8
	ld l,$8b		; $47ca
	ld a,(de)		; $47cc
	ldi (hl),a		; $47cd
	inc e			; $47ce
	inc l			; $47cf
	ld a,(de)		; $47d0
	ld (hl),a		; $47d1
_label_0c_058:
	jp enemyDie		; $47d2
_label_0c_059:
	call _ecom_getSubidAndCpStateTo08		; $47d5
	jr nc,_label_0c_061	; $47d8
	rst_jumpTable			; $47da
	di			; $47db
	ld b,a			; $47dc
	inc de			; $47dd
	ld c,b			; $47de
	inc de			; $47df
	ld c,b			; $47e0
	ld sp,hl		; $47e1
	ld b,a			; $47e2
	inc de			; $47e3
	ld c,b			; $47e4
	bit 0,h			; $47e5
	inc de			; $47e7
	ld c,b			; $47e8
_label_0c_060:
	inc de			; $47e9
	ld c,b			; $47ea
_label_0c_061:
	ld a,b			; $47eb
	rst_jumpTable			; $47ec
	inc d			; $47ed
	ld c,b			; $47ee
	halt			; $47ef
	ld c,b			; $47f0
	sub (hl)		; $47f1
	ld c,b			; $47f2
	call $4961		; $47f3
	jp _ecom_setSpeedAndState8		; $47f6
	inc e			; $47f9
	ld a,(de)		; $47fa
	rst_jumpTable			; $47fb
	dec b			; $47fc
	ld b,b			; $47fd
	inc b			; $47fe
	ld c,b			; $47ff
	inc b			; $4800
	ld c,b			; $4801
	dec b			; $4802
	ld c,b			; $4803
	ret			; $4804
	ld e,$82		; $4805
	ld a,(de)		; $4807
	ld hl,$4810		; $4808
	rst_addAToHl			; $480b
	ld b,(hl)		; $480c
	jp _ecom_fallToGroundAndSetState		; $480d
	ld a,(bc)		; $4810
	ld a,(bc)		; $4811
	ld a,(bc)		; $4812
	ret			; $4813
	ld a,(de)		; $4814
	sub $08			; $4815
	rst_jumpTable			; $4817
	jr nz,$48		; $4818
	ld (hl),$48		; $481a
	ld d,b			; $481c
	ld c,b			; $481d
	ld h,(hl)		; $481e
	ld c,b			; $481f
	call _ecom_decCounter1		; $4820
	ret nz			; $4823
	inc (hl)		; $4824
	call $4912		; $4825
	ret nz			; $4828
	call objectSetShortPosition		; $4829
	ld l,$84		; $482c
	inc (hl)		; $482e
	xor a			; $482f
	call enemySetAnimation		; $4830
	jp objectSetVisiblec2		; $4833
	ld h,d			; $4836
	ld l,$a1		; $4837
	ld a,(hl)		; $4839
	dec a			; $483a
	jr nz,_label_0c_062	; $483b
	ld l,e			; $483d
	inc (hl)		; $483e
	ld l,$a4		; $483f
	set 7,(hl)		; $4841
	ld l,$90		; $4843
	ld (hl),$14		; $4845
	call _ecom_updateCardinalAngleTowardTarget		; $4847
	call $4973		; $484a
_label_0c_062:
	jp enemyAnimate		; $484d
	call _ecom_decCounter1		; $4850
	jp nz,$4904		; $4853
	call _ecom_incState		; $4856
	ld l,$a4		; $4859
	res 7,(hl)		; $485b
	ld l,$90		; $485d
	ld (hl),$05		; $485f
	ld a,$02		; $4861
	jp enemySetAnimation		; $4863
	ld h,d			; $4866
	ld l,$a1		; $4867
	ld a,(hl)		; $4869
	dec a			; $486a
	jr nz,_label_0c_062	; $486b
	ld l,e			; $486d
	ld (hl),$08		; $486e
	call $4961		; $4870
	jp objectSetInvisible		; $4873
	ld a,(de)		; $4876
	sub $08			; $4877
	rst_jumpTable			; $4879
	jr nz,_label_0c_063	; $487a
	ld (hl),$48		; $487c
	add d			; $487e
	ld c,b			; $487f
	ld h,(hl)		; $4880
	ld c,b			; $4881
	call _ecom_decCounter1		; $4882
	jp z,$4856		; $4885
	call getRandomNumber_noPreserveVars		; $4888
	cp $14			; $488b
	jp nc,$4904		; $488d
	call _ecom_updateCardinalAngleTowardTarget		; $4890
	jp $4904		; $4893
	ld a,(de)		; $4896
	sub $08			; $4897
	rst_jumpTable			; $4899
	and h			; $489a
	ld c,b			; $489b
	cp d			; $489c
	ld c,b			; $489d
	jp z,$e448		; $489e
	ld c,b			; $48a1
	di			; $48a2
	ld c,b			; $48a3
	ld h,d			; $48a4
	ld l,e			; $48a5
	inc (hl)		; $48a6
	ld l,$86		; $48a7
	ld a,(hl)		; $48a9
	and $30			; $48aa
	add $60			; $48ac
	ld (hl),a		; $48ae
	ld e,$8b		; $48af
	ld l,$b0		; $48b1
	ld a,(de)		; $48b3
	ldi (hl),a		; $48b4
	ld e,$8d		; $48b5
	ld a,(de)		; $48b7
	ld (hl),a		; $48b8
	ret			; $48b9
	call _ecom_decCounter1		; $48ba
	ret nz			; $48bd
	inc l			; $48be
	ld (hl),$06		; $48bf
	ld l,e			; $48c1
	inc (hl)		; $48c2
	xor a			; $48c3
_label_0c_063:
	call enemySetAnimation		; $48c4
	jp objectSetVisiblec2		; $48c7
	ld e,$a1		; $48ca
	ld a,(de)		; $48cc
	dec a			; $48cd
	jr nz,_label_0c_064	; $48ce
	ld h,d			; $48d0
	ld l,$84		; $48d1
	inc (hl)		; $48d3
	ld l,$a4		; $48d4
	set 7,(hl)		; $48d6
	ld l,$90		; $48d8
	ld (hl),$19		; $48da
	call _ecom_updateCardinalAngleTowardTarget		; $48dc
	call $4973		; $48df
	jr _label_0c_064		; $48e2
	call _ecom_decCounter1		; $48e4
	jp z,$4856		; $48e7
	call $497e		; $48ea
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $48ed
_label_0c_064:
	jp enemyAnimate		; $48f0
	ld e,$a1		; $48f3
	ld a,(de)		; $48f5
	dec a			; $48f6
	jr nz,_label_0c_064	; $48f7
	ld e,$84		; $48f9
	ld a,$09		; $48fb
	ld (de),a		; $48fd
	call $4961		; $48fe
	jp objectSetInvisible		; $4901
	ld a,$01		; $4904
	call _ecom_getTopDownAdjacentWallsBitset		; $4906
	jp nz,$4856		; $4909
	call objectApplySpeed		; $490c
	jp enemyAnimate		; $490f
	ld a,b			; $4912
	or a			; $4913
	jr nz,_label_0c_066	; $4914
	ld de,$d00b		; $4916
	call getShortPositionFromDE		; $4919
	ld c,a			; $491c
	ld e,$08		; $491d
	ld a,(de)		; $491f
	rlca			; $4920
	rlca			; $4921
	ld hl,$4946		; $4922
	rst_addAToHl			; $4925
	ld a,(wFrameCounter)		; $4926
	and $03			; $4929
	rst_addAToHl			; $492b
	ldh a,(<hActiveObject)	; $492c
	ld d,a			; $492e
	ld a,c			; $492f
	add (hl)		; $4930
	ld c,a			; $4931
	and $f0			; $4932
	cp $80			; $4934
	jr nc,_label_0c_065	; $4936
	ld a,c			; $4938
	and $0f			; $4939
	cp $0a			; $493b
	jr nc,_label_0c_065	; $493d
	ld b,$ce		; $493f
	ld a,(bc)		; $4941
	or a			; $4942
	ret			; $4943
_label_0c_065:
	or d			; $4944
	ret			; $4945
	ret nc			; $4946
	ret nz			; $4947
	or b			; $4948
	or b			; $4949
	inc bc			; $494a
	inc b			; $494b
	dec b			; $494c
	dec b			; $494d
	jr nc,$40		; $494e
	ld d,b			; $4950
	ld d,b			; $4951
.DB $fd				; $4952
.DB $fc				; $4953
	ei			; $4954
	ei			; $4955
_label_0c_066:
	call getRandomNumber_noPreserveVars		; $4956
	and $77			; $4959
	ld c,a			; $495b
	ld b,$ce		; $495c
	ld a,(bc)		; $495e
	or a			; $495f
	ret			; $4960
	call getRandomNumber_noPreserveVars		; $4961
	and $03			; $4964
	ld hl,$496f		; $4966
	rst_addAToHl			; $4969
	ld e,$86		; $496a
	ld a,(hl)		; $496c
	ld (de),a		; $496d
	ret			; $496e
	stop			; $496f
	jr nc,_label_0c_070	; $4970
	ld (hl),b		; $4972
	call getRandomNumber_noPreserveVars		; $4973
	ld e,$86		; $4976
	and $38			; $4978
	add $70			; $497a
	ld (de),a		; $497c
	ret			; $497d
	call _ecom_decCounter2		; $497e
	ret nz			; $4981
	ld (hl),$06		; $4982
	call objectGetAngleTowardEnemyTarget		; $4984
	jp objectNudgeAngleTowards		; $4987

enemyCode0c:
enemyCode20:
enemyCode22:
	call _ecom_checkHazards		; $498a
	jr z,_label_0c_069	; $498d
	sub $03			; $498f
	ret c			; $4991
	jr z,_label_0c_067	; $4992
	dec a			; $4994
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4995
	ret			; $4998
_label_0c_067:
	ld e,$82		; $4999
	ld a,(de)		; $499b
	cp $02			; $499c
	jr nz,_label_0c_068	; $499e
	ld hl,$c6c9		; $49a0
	set 1,(hl)		; $49a3
_label_0c_068:
	jp enemyDie		; $49a5
_label_0c_069:
	call _ecom_checkScentSeedActive		; $49a8
	ld e,$84		; $49ab
	ld a,(de)		; $49ad
	rst_jumpTable			; $49ae
	jp $0049		; $49af
	ld c,d			; $49b2
	nop			; $49b3
	ld c,d			; $49b4
.DB $f4				; $49b5
	ld c,c			; $49b6
	reti			; $49b7
	ld c,c			; $49b8
	bit 0,h			; $49b9
	nop			; $49bb
	ld c,d			; $49bc
	nop			; $49bd
	ld c,d			; $49be
	ld bc,$154a		; $49bf
_label_0c_070:
	ld c,d			; $49c2
	ld h,d			; $49c3
	ld l,$bf		; $49c4
	set 4,(hl)		; $49c6
	ld l,$82		; $49c8
	bit 1,(hl)		; $49ca
	jr z,_label_0c_071	; $49cc
	ld a,($c6c9)		; $49ce
	bit 1,a			; $49d1
	jp nz,enemyDelete		; $49d3
_label_0c_071:
	jp $4a49		; $49d6
	ld a,($ccf0)		; $49d9
	or a			; $49dc
	jp z,$4a79		; $49dd
	call _ecom_updateAngleToScentSeed		; $49e0
	ld e,$89		; $49e3
	ld a,(de)		; $49e5
	add $04			; $49e6
	and $18			; $49e8
	ld (de),a		; $49ea
	call _ecom_updateAnimationFromAngle		; $49eb
	call _ecom_applyVelocityForSideviewEnemy		; $49ee
	jp enemyAnimate		; $49f1
	inc e			; $49f4
	ld a,(de)		; $49f5
	rst_jumpTable			; $49f6
	dec b			; $49f7
	ld b,b			; $49f8
	rst $38			; $49f9
	ld c,c			; $49fa
	rst $38			; $49fb
	ld c,c			; $49fc
	rst $38			; $49fd
	ld b,h			; $49fe
	ret			; $49ff
	ret			; $4a00
	call _ecom_decCounter1		; $4a01
	jr z,_label_0c_072	; $4a04
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4a06
	jr nz,_label_0c_073	; $4a09
_label_0c_072:
	call _ecom_incState		; $4a0b
	ld l,$86		; $4a0e
	ld (hl),$08		; $4a10
_label_0c_073:
	jp enemyAnimate		; $4a12
	call _ecom_decCounter1		; $4a15
	ret nz			; $4a18
	call _ecom_setRandomCardinalAngle		; $4a19
	call $4a79		; $4a1c
	jr _label_0c_075		; $4a1f

enemyCode21:
	call _ecom_seasonsFunc_4446		; $4a21
	jr z,_label_0c_074	; $4a24
	sub $03			; $4a26
	ret c			; $4a28
	jp z,enemyDie		; $4a29
	dec a			; $4a2c
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4a2d
	ret			; $4a30
_label_0c_074:
	ld e,$84		; $4a31
	ld a,(de)		; $4a33
	rst_jumpTable			; $4a34
	ld c,c			; $4a35
	ld c,d			; $4a36
	nop			; $4a37
	ld c,d			; $4a38
	nop			; $4a39
	ld c,d			; $4a3a
.DB $f4				; $4a3b
	ld c,c			; $4a3c
	nop			; $4a3d
	ld c,d			; $4a3e
	nop			; $4a3f
	ld c,d			; $4a40
	nop			; $4a41
	ld c,d			; $4a42
	nop			; $4a43
	ld c,d			; $4a44
	ld bc,$574a		; $4a45
	ld c,d			; $4a48
	ld e,$90		; $4a49
	ld a,$14		; $4a4b
	ld (de),a		; $4a4d
	call _ecom_setRandomCardinalAngle		; $4a4e
	call $4a79		; $4a51
	jp objectSetVisiblec2		; $4a54
	call _ecom_decCounter1		; $4a57
	ret nz			; $4a5a
	call $4a8b		; $4a5b
	call $4a79		; $4a5e
_label_0c_075:
	ld h,d			; $4a61
	ld l,$b0		; $4a62
	inc (hl)		; $4a64
	bit 0,(hl)		; $4a65
	ret z			; $4a67
	call objectGetAngleTowardEnemyTarget		; $4a68
	add $04			; $4a6b
	and $18			; $4a6d
	ld h,d			; $4a6f
	ld l,$89		; $4a70
	cp (hl)			; $4a72
	ret nz			; $4a73
	ld b,$1a		; $4a74
	jp _ecom_spawnProjectile		; $4a76
	call getRandomNumber_noPreserveVars		; $4a79
	and $3f			; $4a7c
	add $30			; $4a7e
	ld h,d			; $4a80
	ld l,$86		; $4a81
	ld (hl),a		; $4a83
	ld l,$84		; $4a84
	ld (hl),$08		; $4a86
	jp _ecom_updateAnimationFromAngle		; $4a88
	call getRandomNumber_noPreserveVars		; $4a8b
	and $03			; $4a8e
	jp z,_ecom_updateCardinalAngleTowardTarget		; $4a90
	jp _ecom_setRandomCardinalAngle		; $4a93

enemyCode0d:
	call _ecom_checkHazards		; $4a96
	jr z,_label_0c_078	; $4a99
	sub $03			; $4a9b
	ret c			; $4a9d
	jr z,_label_0c_076	; $4a9e
	dec a			; $4aa0
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4aa1
	ret			; $4aa4
_label_0c_076:
	ld e,$82		; $4aa5
	ld a,(de)		; $4aa7
	cp $02			; $4aa8
	jr nz,_label_0c_077	; $4aaa
	ld hl,$c6c9		; $4aac
	set 3,(hl)		; $4aaf
_label_0c_077:
	jp enemyDie		; $4ab1
_label_0c_078:
	call _ecom_checkScentSeedActive		; $4ab4
	jr z,_label_0c_079	; $4ab7
	ld e,$90		; $4ab9
	ld a,$28		; $4abb
	ld (de),a		; $4abd
_label_0c_079:
	ld e,$84		; $4abe
	ld a,(de)		; $4ac0
	rst_jumpTable			; $4ac1
	ret c			; $4ac2
	ld c,d			; $4ac3
	dec h			; $4ac4
	ld c,e			; $4ac5
	dec h			; $4ac6
	ld c,e			; $4ac7
	dec h			; $4ac8
	ld c,e			; $4ac9
	ld ($254b),sp		; $4aca
	ld c,e			; $4acd
	dec h			; $4ace
	ld c,e			; $4acf
	dec h			; $4ad0
	ld c,e			; $4ad1
	ld h,$4b		; $4ad2
	ld c,e			; $4ad4
	ld c,e			; $4ad5
	ld e,b			; $4ad6
	ld c,e			; $4ad7
	ld e,$82		; $4ad8
	ld a,(de)		; $4ada
	cp $02			; $4adb
	jr nz,_label_0c_080	; $4add
	ld hl,$c6c9		; $4adf
	bit 3,(hl)		; $4ae2
	jp nz,enemyDelete		; $4ae4
_label_0c_080:
	ld e,$82		; $4ae7
	ld a,(de)		; $4ae9
	ld hl,$4b05		; $4aea
	rst_addAToHl			; $4aed
	ld e,$b0		; $4aee
	ld a,(hl)		; $4af0
	ld (de),a		; $4af1
	call objectSetVisiblec2		; $4af2
	call getRandomNumber_noPreserveVars		; $4af5
	and $30			; $4af8
	ld c,a			; $4afa
	ld h,d			; $4afb
	ld l,$bf		; $4afc
	set 4,(hl)		; $4afe
	ld l,$84		; $4b00
	jp $4b35		; $4b02
	rlca			; $4b05
	inc bc			; $4b06
	ld bc,$f0fa		; $4b07
	call z,$cab7		; $4b0a
	ld a,c			; $4b0d
	ld c,e			; $4b0e
	call _ecom_updateAngleToScentSeed		; $4b0f
	ld e,$89		; $4b12
	ld a,(de)		; $4b14
	add $04			; $4b15
	and $18			; $4b17
	ld (de),a		; $4b19
	ld b,$04		; $4b1a
	call $4ba2		; $4b1c
	call _ecom_applyVelocityForSideviewEnemy		; $4b1f
	jp enemyAnimate		; $4b22
	ret			; $4b25
	ld e,$b0		; $4b26
	ld a,(de)		; $4b28
	ld b,a			; $4b29
	ld c,$30		; $4b2a
	call _ecom_randomBitwiseAndBCE		; $4b2c
	or b			; $4b2f
	ld h,d			; $4b30
	ld l,$84		; $4b31
	jr z,_label_0c_081	; $4b33
	ld (hl),$09		; $4b35
	ld l,$86		; $4b37
	ld a,$30		; $4b39
	add c			; $4b3b
	ld (hl),a		; $4b3c
	jr _label_0c_084		; $4b3d
_label_0c_081:
	ld (hl),$0a		; $4b3f
	ld l,$86		; $4b41
	ld (hl),$08		; $4b43
	call _ecom_updateCardinalAngleTowardTarget		; $4b45
	jp _ecom_updateAnimationFromAngle		; $4b48
	call _ecom_decCounter1		; $4b4b
	jr z,_label_0c_083	; $4b4e
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4b50
	jr z,_label_0c_084	; $4b53
_label_0c_082:
	jp enemyAnimate		; $4b55
	call _ecom_decCounter1		; $4b58
	jr nz,_label_0c_082	; $4b5b
	ld b,$1b		; $4b5d
	call _ecom_spawnProjectile		; $4b5f
	jr nz,_label_0c_083	; $4b62
	call getRandomNumber_noPreserveVars		; $4b64
	and $30			; $4b67
	add $30			; $4b69
	ld e,$86		; $4b6b
	ld (de),a		; $4b6d
	ld h,d			; $4b6e
	ld l,$90		; $4b6f
	ld (hl),$14		; $4b71
	ld l,$84		; $4b73
	ld (hl),$09		; $4b75
	jr _label_0c_082		; $4b77
_label_0c_083:
	ld e,$84		; $4b79
	ld a,$08		; $4b7b
	ld (de),a		; $4b7d
	jr _label_0c_082		; $4b7e
_label_0c_084:
	call $4bb0		; $4b80
	ld b,$0e		; $4b83
	call objectCheckCenteredWithLink		; $4b85
	jr nc,_label_0c_085	; $4b88
	call objectGetAngleTowardEnemyTarget		; $4b8a
	add $04			; $4b8d
	and $18			; $4b8f
	ld h,d			; $4b91
	ld l,$89		; $4b92
	cp (hl)			; $4b94
	ld a,$28		; $4b95
	ld b,$04		; $4b97
	jr z,_label_0c_086	; $4b99
_label_0c_085:
	ld a,$14		; $4b9b
	ld b,$00		; $4b9d
_label_0c_086:
	ld l,$90		; $4b9f
	ld (hl),a		; $4ba1
	ld h,d			; $4ba2
	ld l,$89		; $4ba3
	ldd a,(hl)		; $4ba5
	swap a			; $4ba6
	rlca			; $4ba8
	add b			; $4ba9
	cp (hl)			; $4baa
	ret z			; $4bab
	ld (hl),a		; $4bac
	jp enemySetAnimation		; $4bad
	call getRandomNumber_noPreserveVars		; $4bb0
	ld h,d			; $4bb3
	ld l,$b0		; $4bb4
	and (hl)		; $4bb6
	jp nz,_ecom_setRandomCardinalAngle		; $4bb7
	jp _ecom_updateCardinalAngleTowardTarget		; $4bba

enemyCode0e:
enemyCode2b:
	dec a			; $4bbd
	ret z			; $4bbe
	dec a			; $4bbf
	ret z			; $4bc0
	call enemyAnimate		; $4bc1
	call _ecom_getSubidAndCpStateTo08		; $4bc4
	jr nc,_label_0c_087	; $4bc7
	rst_jumpTable			; $4bc9
	add sp,$4b		; $4bca
	dec b			; $4bcc
	ld c,h			; $4bcd
	dec b			; $4bce
	ld c,h			; $4bcf
	dec b			; $4bd0
	ld c,h			; $4bd1
	dec b			; $4bd2
	ld c,h			; $4bd3
	dec b			; $4bd4
	ld c,h			; $4bd5
	dec b			; $4bd6
	ld c,h			; $4bd7
	dec b			; $4bd8
	ld c,h			; $4bd9
_label_0c_087:
	ld a,b			; $4bda
	rst_jumpTable			; $4bdb
	ld b,$4c		; $4bdc
	ld e,l			; $4bde
	ld c,h			; $4bdf
	ld e,l			; $4be0
	ld c,h			; $4be1
.DB $db				; $4be2
	ld c,h			; $4be3
.DB $db				; $4be4
	ld c,h			; $4be5
	or $4c			; $4be6
	ld a,b			; $4be8
	sub $03			; $4be9
	cp $02			; $4beb
	call c,$4d62		; $4bed
	ld e,$82		; $4bf0
	ld a,(de)		; $4bf2
	or a			; $4bf3
	ld a,$08		; $4bf4
	jr nz,_label_0c_088	; $4bf6
	ld a,$01		; $4bf8
	call enemySetAnimation		; $4bfa
	ld a,$01		; $4bfd
_label_0c_088:
	ld e,$be		; $4bff
	ld (de),a		; $4c01
	jp _ecom_setSpeedAndState8AndVisible		; $4c02
	ret			; $4c05
	ld a,(de)		; $4c06
	sub $08			; $4c07
	rst_jumpTable			; $4c09
	ld (de),a		; $4c0a
	ld c,h			; $4c0b
	ld e,$4c		; $4c0c
	dec sp			; $4c0e
	ld c,h			; $4c0f
	ld c,(hl)		; $4c10
	ld c,h			; $4c11
	ld h,d			; $4c12
	ld l,e			; $4c13
	inc (hl)		; $4c14
	ld l,$90		; $4c15
	ld (hl),$1e		; $4c17
	ld a,$01		; $4c19
	jp enemySetAnimation		; $4c1b
	ld b,$0e		; $4c1e
	call $4df7		; $4c20
	ret nc			; $4c23
	call $4d94		; $4c24
	ret nz			; $4c27
	ld h,d			; $4c28
	ld l,$84		; $4c29
	ld (hl),$0a		; $4c2b
	ld l,$86		; $4c2d
	ld (hl),$18		; $4c2f
	ld a,$71		; $4c31
	call playSound		; $4c33
	ld a,$02		; $4c36
	jp enemySetAnimation		; $4c38
	ld e,$86		; $4c3b
	ld a,(de)		; $4c3d
	rrca			; $4c3e
	call c,$414c		; $4c3f
	call _ecom_decCounter1		; $4c42
	jr nz,_label_0c_089	; $4c45
	ld l,$84		; $4c47
	ld (hl),$0b		; $4c49
_label_0c_089:
	jp enemyAnimate		; $4c4b
	call $414c		; $4c4e
	jr nz,_label_0c_089	; $4c51
	ld e,$84		; $4c53
	ld a,$09		; $4c55
	ld (de),a		; $4c57
	ld a,$01		; $4c58
	jp enemySetAnimation		; $4c5a
	ld a,(de)		; $4c5d
	sub $08			; $4c5e
	rst_jumpTable			; $4c60
	ld l,e			; $4c61
	ld c,h			; $4c62
	ld a,e			; $4c63
	ld c,h			; $4c64
	sbc c			; $4c65
	ld c,h			; $4c66
	add $4c			; $4c67
	jp nc,$624c		; $4c69
	ld l,e			; $4c6c
	inc (hl)		; $4c6d
	ld l,$82		; $4c6e
	ld a,(hl)		; $4c70
	dec a			; $4c71
	ld a,$3c		; $4c72
	jr z,_label_0c_090	; $4c74
	ld a,$78		; $4c76
_label_0c_090:
	ld l,$b0		; $4c78
	ld (hl),a		; $4c7a
	ld b,$0d		; $4c7b
	call $4df7		; $4c7d
	ret nc			; $4c80
	call $4d94		; $4c81
	ret nz			; $4c84
	ld a,$01		; $4c85
	call _ecom_getTopDownAdjacentWallsBitset		; $4c87
	ret nz			; $4c8a
	call _ecom_incState		; $4c8b
	ld e,$b0		; $4c8e
	ld l,$90		; $4c90
	ld a,(de)		; $4c92
	ld (hl),a		; $4c93
	ld a,$75		; $4c94
	jp playSound		; $4c96
	call $414c		; $4c99
	ld h,d			; $4c9c
	jr z,_label_0c_092	; $4c9d
	ld l,$89		; $4c9f
	bit 3,(hl)		; $4ca1
	ld b,$58		; $4ca3
	ld l,$8b		; $4ca5
	jr z,_label_0c_091	; $4ca7
	ld b,$78		; $4ca9
	ld l,$8d		; $4cab
_label_0c_091:
	ld a,(hl)		; $4cad
	sub b			; $4cae
	add $07			; $4caf
	cp $0f			; $4cb1
	ret nc			; $4cb3
_label_0c_092:
	ld l,$89		; $4cb4
	ld a,(hl)		; $4cb6
	xor $10			; $4cb7
	ld (hl),a		; $4cb9
	ld l,$90		; $4cba
	ld (hl),$1e		; $4cbc
	ld l,$84		; $4cbe
	inc (hl)		; $4cc0
	ld a,$50		; $4cc1
	jp playSound		; $4cc3
	call $414c		; $4cc6
	ret nz			; $4cc9
	call _ecom_incState		; $4cca
	ld l,$86		; $4ccd
	ld (hl),$10		; $4ccf
	ret			; $4cd1
	call _ecom_decCounter1		; $4cd2
	ret nz			; $4cd5
	ld l,$84		; $4cd6
	ld (hl),$09		; $4cd8
	ret			; $4cda
	ld a,(de)		; $4cdb
	sub $08			; $4cdc
	rst_jumpTable			; $4cde
	pop hl			; $4cdf
	ld c,h			; $4ce0
	ld a,(wFrameCounter)		; $4ce1
	and $01			; $4ce4
	call z,$4d55		; $4ce6
	ld h,d			; $4ce9
	ld l,$b0		; $4cea
	ldi a,(hl)		; $4cec
	ld b,a			; $4ced
	ldi a,(hl)		; $4cee
	ld c,a			; $4cef
	ld a,(hl)		; $4cf0
	ld e,$89		; $4cf1
	jp objectSetPositionInCircleArc		; $4cf3
	ld a,(de)		; $4cf6
	sub $08			; $4cf7
	rst_jumpTable			; $4cf9
	inc b			; $4cfa
	ld c,l			; $4cfb
	dec bc			; $4cfc
	ld c,l			; $4cfd
	ldi a,(hl)		; $4cfe
	ld c,l			; $4cff
	ld b,b			; $4d00
	ld c,l			; $4d01
	ld c,h			; $4d02
	ld c,l			; $4d03
	ld h,d			; $4d04
	ld l,e			; $4d05
	inc (hl)		; $4d06
	ld l,$b0		; $4d07
	ld (hl),$50		; $4d09
	ld b,$0e		; $4d0b
	call $4df7		; $4d0d
	ret nc			; $4d10
	call $4d94		; $4d11
	ret nz			; $4d14
	ld a,$01		; $4d15
	call _ecom_getTopDownAdjacentWallsBitset		; $4d17
	ret nz			; $4d1a
	ld h,d			; $4d1b
	ld e,$b0		; $4d1c
	ld l,$90		; $4d1e
	ld a,(de)		; $4d20
	ld (hl),a		; $4d21
	ld l,$84		; $4d22
	inc (hl)		; $4d24
	ld a,$75		; $4d25
	jp playSound		; $4d27
	call $414c		; $4d2a
	ret nz			; $4d2d
	call _ecom_incState		; $4d2e
	ld l,$89		; $4d31
	ld a,(hl)		; $4d33
	xor $10			; $4d34
	ld (hl),a		; $4d36
	ld l,$90		; $4d37
	ld (hl),$28		; $4d39
	ld a,$50		; $4d3b
	jp playSound		; $4d3d
	call $414c		; $4d40
	ret nz			; $4d43
	call _ecom_incState		; $4d44
	ld l,$86		; $4d47
	ld (hl),$10		; $4d49
	ret			; $4d4b
	call _ecom_decCounter1		; $4d4c
	ret nz			; $4d4f
	ld l,$84		; $4d50
	ld (hl),$09		; $4d52
	ret			; $4d54
	ld e,$82		; $4d55
	ld a,(de)		; $4d57
	cp $03			; $4d58
	ld e,$89		; $4d5a
	jp nz,$4e24		; $4d5c
	jp $4e20		; $4d5f
	call getRandomNumber_noPreserveVars		; $4d62
	and $1f			; $4d65
	ld e,$89		; $4d67
	ld (de),a		; $4d69
	ld e,$8b		; $4d6a
	ld a,(de)		; $4d6c
	ld c,a			; $4d6d
	and $f0			; $4d6e
	add $08			; $4d70
	ld e,$b0		; $4d72
	ld (de),a		; $4d74
	ld b,a			; $4d75
	ld a,c			; $4d76
	and $0f			; $4d77
	swap a			; $4d79
	add $08			; $4d7b
	ld e,$b1		; $4d7d
	ld (de),a		; $4d7f
	ld c,a			; $4d80
	ld e,$8d		; $4d81
	ld a,(de)		; $4d83
	ld e,$b2		; $4d84
	ld (de),a		; $4d86
	ld e,$89		; $4d87
	jp objectSetPositionInCircleArc		; $4d89
	ld a,($ff00+$00)	; $4d8c
	nop			; $4d8e
	stop			; $4d8f
	stop			; $4d90
	nop			; $4d91
	nop			; $4d92
	ld a,($ff00+$62)	; $4d93
	ld l,$8b		; $4d95
	ld b,(hl)		; $4d97
	ld l,$8d		; $4d98
	ld c,(hl)		; $4d9a
	ldh a,(<hEnemyTargetX)	; $4d9b
	sub c			; $4d9d
	add $04			; $4d9e
	cp $09			; $4da0
	jr nc,_label_0c_093	; $4da2
	ldh a,(<hEnemyTargetY)	; $4da4
	sub b			; $4da6
	add $04			; $4da7
	cp $09			; $4da9
	ret c			; $4dab
_label_0c_093:
	ld l,$89		; $4dac
	call $4dde		; $4dae
	ld a,(hl)		; $4db1
	rrca			; $4db2
	rrca			; $4db3
	ld hl,$4d8c		; $4db4
	rst_addAToHl			; $4db7
	ldi a,(hl)		; $4db8
	ld l,(hl)		; $4db9
	ld h,a			; $4dba
	push de			; $4dbb
	ld d,$ce		; $4dbc
_label_0c_094:
	call $4dcc		; $4dbe
	jr nz,_label_0c_095	; $4dc1
	ldh a,(<hFF8B)	; $4dc3
	dec a			; $4dc5
	ldh (<hFF8B),a	; $4dc6
	jr nz,_label_0c_094	; $4dc8
_label_0c_095:
	pop de			; $4dca
	ret			; $4dcb
	ld a,b			; $4dcc
	add h			; $4dcd
	ld b,a			; $4dce
	and $f0			; $4dcf
	ld e,a			; $4dd1
	ld a,c			; $4dd2
	add l			; $4dd3
	ld c,a			; $4dd4
	and $f0			; $4dd5
	swap a			; $4dd7
	or e			; $4dd9
	ld e,a			; $4dda
	ld a,(de)		; $4ddb
	or a			; $4ddc
	ret			; $4ddd
	ld e,b			; $4dde
	ldh a,(<hEnemyTargetY)	; $4ddf
	bit 3,(hl)		; $4de1
	jr z,_label_0c_096	; $4de3
	ld e,c			; $4de5
	ldh a,(<hEnemyTargetX)	; $4de6
_label_0c_096:
	sub e			; $4de8
	jr nc,_label_0c_097	; $4de9
	cpl			; $4deb
	inc a			; $4dec
_label_0c_097:
	swap a			; $4ded
	and $0f			; $4def
	jr nz,_label_0c_098	; $4df1
	inc a			; $4df3
_label_0c_098:
	ldh (<hFF8B),a	; $4df4
	ret			; $4df6
	ld c,b			; $4df7
	sla c			; $4df8
	inc c			; $4dfa
	ld e,$00		; $4dfb
	ld h,d			; $4dfd
	ld l,$8d		; $4dfe
	ldh a,(<hEnemyTargetX)	; $4e00
	sub (hl)		; $4e02
	add b			; $4e03
	cp c			; $4e04
	ld l,$8b		; $4e05
	ldh a,(<hEnemyTargetY)	; $4e07
	jr c,_label_0c_099	; $4e09
	ld e,$18		; $4e0b
	sub (hl)		; $4e0d
	add b			; $4e0e
	cp c			; $4e0f
	ld l,$8d		; $4e10
	ldh a,(<hEnemyTargetX)	; $4e12
	ret nc			; $4e14
_label_0c_099:
	cp (hl)			; $4e15
	ld a,e			; $4e16
	jr c,_label_0c_100	; $4e17
	xor $10			; $4e19
_label_0c_100:
	ld l,$89		; $4e1b
	ld (hl),a		; $4e1d
	scf			; $4e1e
	ret			; $4e1f
	ld a,(de)		; $4e20
	inc a			; $4e21
	jr _label_0c_101		; $4e22
	ld a,(de)		; $4e24
	dec a			; $4e25
_label_0c_101:
	and $1f			; $4e26
	ld (de),a		; $4e28
	ret			; $4e29

enemyCode10:
	call $5018		; $4e2a
	or a			; $4e2d
	jr z,_label_0c_102	; $4e2e
	sub $03			; $4e30
	ret c			; $4e32
	jp z,enemyDie		; $4e33
	dec a			; $4e36
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $4e37
	ret			; $4e3a
_label_0c_102:
	call _ecom_checkScentSeedActive		; $4e3b
	jr z,_label_0c_103	; $4e3e
	ld e,$90		; $4e40
	ld a,$32		; $4e42
	ld (de),a		; $4e44
_label_0c_103:
	call _ecom_getSubidAndCpStateTo08		; $4e45
	jr nc,_label_0c_104	; $4e48
	rst_jumpTable			; $4e4a
	ld h,l			; $4e4b
	ld c,(hl)		; $4e4c
	cp (hl)			; $4e4d
	ld c,(hl)		; $4e4e
	cp (hl)			; $4e4f
	ld c,(hl)		; $4e50
	ld a,b			; $4e51
	ld c,(hl)		; $4e52
	adc a			; $4e53
	ld c,(hl)		; $4e54
	bit 0,h			; $4e55
	cp (hl)			; $4e57
	ld c,(hl)		; $4e58
	cp (hl)			; $4e59
	ld c,(hl)		; $4e5a
_label_0c_104:
	ld a,b			; $4e5b
	rst_jumpTable			; $4e5c
	cp a			; $4e5d
	ld c,(hl)		; $4e5e
	ld de,$684f		; $4e5f
	ld c,a			; $4e62
	sbc e			; $4e63
	ld c,a			; $4e64
	ld e,$88		; $4e65
	ld a,$ff		; $4e67
	ld (de),a		; $4e69
	dec b			; $4e6a
	ld a,$0f		; $4e6b
	jp z,_ecom_setSpeedAndState8		; $4e6d
	ld h,d			; $4e70
	ld l,$bf		; $4e71
	set 4,(hl)		; $4e73
	jp _ecom_setSpeedAndState8AndVisible		; $4e75
	inc e			; $4e78
	ld a,(de)		; $4e79
	rst_jumpTable			; $4e7a
	dec b			; $4e7b
	ld b,b			; $4e7c
	add e			; $4e7d
	ld c,(hl)		; $4e7e
	add e			; $4e7f
	ld c,(hl)		; $4e80
	add h			; $4e81
	ld c,(hl)		; $4e82
	ret			; $4e83
	ld e,$82		; $4e84
	ld a,(de)		; $4e86
	ld hl,$4eba		; $4e87
	rst_addAToHl			; $4e8a
	ld b,(hl)		; $4e8b
	jp _ecom_fallToGroundAndSetState		; $4e8c
	ld a,($ccf0)		; $4e8f
	or a			; $4e92
	jr nz,_label_0c_105	; $4e93
	ld e,$82		; $4e95
	ld a,(de)		; $4e97
	ld hl,$4eba		; $4e98
	rst_addAToHl			; $4e9b
	ld e,$84		; $4e9c
	ld a,(hl)		; $4e9e
	ld (de),a		; $4e9f
	ld e,$90		; $4ea0
	ld a,$0f		; $4ea2
	ld (de),a		; $4ea4
	ret			; $4ea5
_label_0c_105:
	call _ecom_updateAngleToScentSeed		; $4ea6
	ld e,$89		; $4ea9
	ld a,(de)		; $4eab
	add $04			; $4eac
	and $18			; $4eae
	ld (de),a		; $4eb0
	call $4ff6		; $4eb1
	call _ecom_applyVelocityForSideviewEnemy		; $4eb4
	jp $500a		; $4eb7
	add hl,bc		; $4eba
	dec bc			; $4ebb
	ld a,(bc)		; $4ebc
	ld a,(bc)		; $4ebd
	ret			; $4ebe
	ld a,(de)		; $4ebf
	sub $08			; $4ec0
	rst_jumpTable			; $4ec2
	ret			; $4ec3
	ld c,(hl)		; $4ec4
	call nc,$fc4e		; $4ec5
	ld c,(hl)		; $4ec8
	ld h,d			; $4ec9
	ld l,e			; $4eca
	inc (hl)		; $4ecb
	ld l,$a4		; $4ecc
	set 7,(hl)		; $4ece
	ld l,$b0		; $4ed0
	set 7,(hl)		; $4ed2
	ld b,$0a		; $4ed4
	call objectCheckCenteredWithLink		; $4ed6
	jr nc,_label_0c_106	; $4ed9
	ld e,$87		; $4edb
	ld a,(de)		; $4edd
	or a			; $4ede
	jr nz,_label_0c_106	; $4edf
	call _ecom_updateCardinalAngleTowardTarget		; $4ee1
	call _ecom_incState		; $4ee4
	ld l,$90		; $4ee7
	ld (hl),$32		; $4ee9
	jp $4ff6		; $4eeb
_label_0c_106:
	call _ecom_decCounter2		; $4eee
	dec l			; $4ef1
	dec (hl)		; $4ef2
	call nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $4ef3
	jp z,$4fe6		; $4ef6
_label_0c_107:
	jp enemyAnimate		; $4ef9
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4efc
	jp nz,$500a		; $4eff
	ld h,d			; $4f02
	ld l,$84		; $4f03
	dec (hl)		; $4f05
	ld l,$90		; $4f06
	ld (hl),$0f		; $4f08
	ld l,$87		; $4f0a
	ld (hl),$40		; $4f0c
	jp $4fe6		; $4f0e
	ld a,(de)		; $4f11
	sub $08			; $4f12
	rst_jumpTable			; $4f14
	rra			; $4f15
	ld c,a			; $4f16
	inc l			; $4f17
	ld c,a			; $4f18
	ld c,d			; $4f19
	ld c,a			; $4f1a
	call nc,$fc4e		; $4f1b
	ld c,(hl)		; $4f1e
	ld a,$09		; $4f1f
	ld (de),a		; $4f21
	call getRandomNumber_noPreserveVars		; $4f22
	ld e,$86		; $4f25
	and $38			; $4f27
	inc a			; $4f29
	ld (de),a		; $4f2a
	ret			; $4f2b
	call _ecom_decCounter1		; $4f2c
	ret nz			; $4f2f
	ld l,e			; $4f30
	inc (hl)		; $4f31
	ld l,$a4		; $4f32
	set 7,(hl)		; $4f34
	ld l,$b0		; $4f36
	set 7,(hl)		; $4f38
	ld l,$95		; $4f3a
	inc (hl)		; $4f3c
	ld a,$59		; $4f3d
	call playSound		; $4f3f
	call objectSetVisiblec1		; $4f42
	ld c,$08		; $4f45
	jp _ecom_setZAboveScreen		; $4f47
	ld c,$0e		; $4f4a
	call objectUpdateSpeedZ_paramC		; $4f4c
	ret nz			; $4f4f
	ld l,$94		; $4f50
	ldi (hl),a		; $4f52
	ld (hl),a		; $4f53
	ld l,$84		; $4f54
	inc (hl)		; $4f56
	ld l,$bf		; $4f57
	set 4,(hl)		; $4f59
	call objectSetVisiblec2		; $4f5b
	ld a,$52		; $4f5e
	call playSound		; $4f60
	call $4fe6		; $4f63
	jr _label_0c_107		; $4f66
	ld a,(de)		; $4f68
	sub $08			; $4f69
	rst_jumpTable			; $4f6b
	ld (hl),h		; $4f6c
	ld c,a			; $4f6d
	add l			; $4f6e
	ld c,a			; $4f6f
	call nc,$fc4e		; $4f70
	ld c,(hl)		; $4f73
	ld h,d			; $4f74
	ld l,e			; $4f75
	inc (hl)		; $4f76
	ld l,$90		; $4f77
	ld (hl),$32		; $4f79
	ld l,$86		; $4f7b
	ld (hl),$08		; $4f7d
	call _ecom_updateCardinalAngleTowardTarget		; $4f7f
	jp $4ff6		; $4f82
	call _ecom_decCounter1		; $4f85
	jr nz,_label_0c_108	; $4f88
	ld l,e			; $4f8a
	ld (hl),$0b		; $4f8b
	ld l,$a4		; $4f8d
	set 7,(hl)		; $4f8f
	ld l,$b0		; $4f91
	set 7,(hl)		; $4f93
_label_0c_108:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4f95
	jp enemyAnimate		; $4f98
	ld a,(de)		; $4f9b
	sub $08			; $4f9c
	rst_jumpTable			; $4f9e
	and a			; $4f9f
	ld c,a			; $4fa0
	pop bc			; $4fa1
	ld c,a			; $4fa2
	call nc,$fc4e		; $4fa3
	ld c,(hl)		; $4fa6
	ld h,d			; $4fa7
	ld l,e			; $4fa8
	inc (hl)		; $4fa9
	ld l,$94		; $4faa
	ld a,$fe		; $4fac
	ldi (hl),a		; $4fae
	ld (hl),$fe		; $4faf
	ld l,$90		; $4fb1
	ld (hl),$1e		; $4fb3
	ld l,$89		; $4fb5
	ld a,($d008)		; $4fb7
	swap a			; $4fba
	rrca			; $4fbc
	ld (hl),a		; $4fbd
	jp $4ff6		; $4fbe
	ld c,$0e		; $4fc1
	call objectUpdateSpeedZAndBounce		; $4fc3
	jr c,_label_0c_110	; $4fc6
	ld a,$52		; $4fc8
	call z,playSound		; $4fca
	ld e,$95		; $4fcd
	ld a,(de)		; $4fcf
	or a			; $4fd0
	jr nz,_label_0c_109	; $4fd1
	ld h,d			; $4fd3
	ld l,$a4		; $4fd4
	set 7,(hl)		; $4fd6
	ld l,$b0		; $4fd8
	set 7,(hl)		; $4fda
_label_0c_109:
	jp _ecom_applyVelocityForSideviewEnemyNoHoles		; $4fdc
_label_0c_110:
	call _ecom_incState		; $4fdf
	ld l,$90		; $4fe2
	ld (hl),$0f		; $4fe4
	ld bc,$1870		; $4fe6
	call _ecom_randomBitwiseAndBCE		; $4fe9
	ld e,$89		; $4fec
	ld a,b			; $4fee
	ld (de),a		; $4fef
	ld e,$86		; $4ff0
	ld a,c			; $4ff2
	add $70			; $4ff3
	ld (de),a		; $4ff5
	ld h,d			; $4ff6
	ld l,$89		; $4ff7
	ld a,(hl)		; $4ff9
	and $0f			; $4ffa
	ret z			; $4ffc
	ldd a,(hl)		; $4ffd
	and $10			; $4ffe
	swap a			; $5000
	xor $01			; $5002
	cp (hl)			; $5004
	ret z			; $5005
	ld (hl),a		; $5006
	jp enemySetAnimation		; $5007
	ld h,d			; $500a
	ld l,$a0		; $500b
	ld a,(hl)		; $500d
	sub $03			; $500e
	jr nc,_label_0c_111	; $5010
	xor a			; $5012
_label_0c_111:
	inc a			; $5013
	ld (hl),a		; $5014
	jp enemyAnimate		; $5015
	ld h,d			; $5018
	ld l,$b0		; $5019
	bit 7,(hl)		; $501b
	ret z			; $501d
	jp _ecom_checkHazards		; $501e

enemyCode12:
	call _ecom_checkHazards		; $5021
	jr z,_label_0c_112	; $5024
	sub $03			; $5026
	ret c			; $5028
	jp z,enemyDie		; $5029
	ld e,$aa		; $502c
	ld a,(de)		; $502e
	cp $9b			; $502f
	ret nz			; $5031
	ld h,d			; $5032
	ld l,$84		; $5033
	ld a,$0a		; $5035
	cp (hl)			; $5037
	ret z			; $5038
	ld (hl),a		; $5039
	ld l,$86		; $503a
	ld (hl),$1e		; $503c
	ld l,$ae		; $503e
	ld (hl),$00		; $5040
	ret			; $5042
_label_0c_112:
	ld e,$84		; $5043
	ld a,(de)		; $5045
	rst_jumpTable			; $5046
	ld e,l			; $5047
	ld d,b			; $5048
	ld l,(hl)		; $5049
	ld d,b			; $504a
	ld l,(hl)		; $504b
	ld d,b			; $504c
	ld h,d			; $504d
	ld d,b			; $504e
	ld l,(hl)		; $504f
	ld d,b			; $5050
	bit 0,h			; $5051
	ld l,(hl)		; $5053
	ld d,b			; $5054
	ld l,(hl)		; $5055
	ld d,b			; $5056
	ld l,a			; $5057
	ld d,b			; $5058
	add h			; $5059
	ld d,b			; $505a
	sub c			; $505b
	ld d,b			; $505c
	ld a,$14		; $505d
	jp _ecom_setSpeedAndState8AndVisible		; $505f
	inc e			; $5062
	ld a,(de)		; $5063
	rst_jumpTable			; $5064
	dec b			; $5065
	ld b,b			; $5066
	ld l,l			; $5067
	ld d,b			; $5068
	ld l,l			; $5069
	ld d,b			; $506a
	rst $38			; $506b
	ld b,h			; $506c
	ret			; $506d
	ret			; $506e
	ld a,$09		; $506f
	ld (de),a		; $5071
	ld bc,$187f		; $5072
	call _ecom_randomBitwiseAndBCE		; $5075
	ld e,$89		; $5078
	ld a,b			; $507a
	ld (de),a		; $507b
	ld e,$86		; $507c
	ld a,$40		; $507e
	add c			; $5080
	ld (de),a		; $5081
	jr _label_0c_113		; $5082
	call _ecom_decCounter1		; $5084
	jr z,_label_0c_114	; $5087
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5089
	jr z,_label_0c_114	; $508c
_label_0c_113:
	jp enemyAnimate		; $508e
	call _ecom_decCounter1		; $5091
	ret nz			; $5094
	ld bc,$3102		; $5095
	jp enemyReplaceWithID		; $5098
_label_0c_114:
	ld e,$84		; $509b
	ld a,$08		; $509d
	ld (de),a		; $509f
	jr _label_0c_113		; $50a0

enemyCode13:
	call _ecom_checkHazards		; $50a2
	jr z,_label_0c_115	; $50a5
	sub $03			; $50a7
	ret c			; $50a9
	ld e,$aa		; $50aa
	ld a,(de)		; $50ac
	res 7,a			; $50ad
	sub $15			; $50af
	cp $02			; $50b1
	jr nc,_label_0c_115	; $50b3
	ld e,$84		; $50b5
	ld a,(de)		; $50b7
	cp $09			; $50b8
	jr nc,_label_0c_115	; $50ba
	ld a,$09		; $50bc
	ld (de),a		; $50be
_label_0c_115:
	ld e,$84		; $50bf
	ld a,(de)		; $50c1
	rst_jumpTable			; $50c2
	reti			; $50c3
	ld d,b			; $50c4
	rst $20			; $50c5
	ld d,b			; $50c6
	rst $20			; $50c7
	ld d,b			; $50c8
	rst $20			; $50c9
	ld d,b			; $50ca
	rst $20			; $50cb
	ld d,b			; $50cc
	rst $20			; $50cd
	ld d,b			; $50ce
	rst $20			; $50cf
	ld d,b			; $50d0
	rst $20			; $50d1
	ld d,b			; $50d2
	add sp,$50		; $50d3
	pop af			; $50d5
	ld d,b			; $50d6
	ld b,$51		; $50d7
	call $5197		; $50d9
	ld e,$89		; $50dc
	ld (de),a		; $50de
	ld a,$28		; $50df
	call _ecom_setSpeedAndState8		; $50e1
	jp objectSetVisible82		; $50e4
	ret			; $50e7
	call $516a		; $50e8
	call objectApplySpeed		; $50eb
	jp enemyAnimate		; $50ee
	ld bc,$0502		; $50f1
	call objectCreateInteraction		; $50f4
	ret nz			; $50f7
	ld e,$98		; $50f8
	ld a,$40		; $50fa
	ld (de),a		; $50fc
	inc e			; $50fd
	ld a,h			; $50fe
	ld (de),a		; $50ff
	call _ecom_incState		; $5100
	jp objectSetInvisible		; $5103
	ld a,$21		; $5106
	call objectGetRelatedObject2Var		; $5108
	ld a,(hl)		; $510b
	inc a			; $510c
	ret nz			; $510d
	ld e,$81		; $510e
	ld a,(de)		; $5110
	cp $13			; $5111
	ld b,$01		; $5113
	call z,_ecom_spawnProjectile		; $5115
	jp enemyDelete		; $5118

enemyCode19:
	jr z,_label_0c_116	; $511b
	sub $03			; $511d
	ret c			; $511f
	ld e,$aa		; $5120
	ld a,(de)		; $5122
	res 7,a			; $5123
	sub $15			; $5125
	cp $02			; $5127
	jr nc,_label_0c_116	; $5129
	ld e,$84		; $512b
	ld a,(de)		; $512d
	cp $09			; $512e
	jr nc,_label_0c_116	; $5130
	ld a,$09		; $5132
	ld (de),a		; $5134
_label_0c_116:
	ld e,$84		; $5135
	ld a,(de)		; $5137
	rst_jumpTable			; $5138
	ld c,a			; $5139
	ld d,c			; $513a
	rst $20			; $513b
	ld d,b			; $513c
	rst $20			; $513d
	ld d,b			; $513e
	rst $20			; $513f
	ld d,b			; $5140
	rst $20			; $5141
	ld d,b			; $5142
	bit 0,h			; $5143
	rst $20			; $5145
	ld d,b			; $5146
	rst $20			; $5147
	ld d,b			; $5148
	ld h,c			; $5149
	ld d,c			; $514a
	pop af			; $514b
	ld d,b			; $514c
	ld b,$51		; $514d
	call getRandomNumber_noPreserveVars		; $514f
	and $18			; $5152
	add $04			; $5154
	ld e,$89		; $5156
	ld (de),a		; $5158
	ld a,$1e		; $5159
	call _ecom_setSpeedAndState8		; $515b
	jp objectSetVisible82		; $515e
	call _ecom_bounceOffWalls		; $5161
	call objectApplySpeed		; $5164
	jp enemyAnimate		; $5167
	ld a,$01		; $516a
	ldh (<hFF8A),a	; $516c
	ld e,$89		; $516e
	ld a,(de)		; $5170
	sub $08			; $5171
	and $18			; $5173
	call $51bf		; $5175
	jr c,_label_0c_117	; $5178
	call $51ac		; $517a
	ret nz			; $517d
	ld e,$89		; $517e
	ld a,(de)		; $5180
	sub $08			; $5181
	and $18			; $5183
	ld (de),a		; $5185
	ret			; $5186
_label_0c_117:
	ld e,$89		; $5187
	ld a,(de)		; $5189
	call $51bf		; $518a
	ret nc			; $518d
	ld e,$89		; $518e
	ld a,(de)		; $5190
	add $08			; $5191
	and $18			; $5193
	ld (de),a		; $5195
	ret			; $5196
	xor a			; $5197
	call $51bf		; $5198
	ld a,$08		; $519b
	ret c			; $519d
	call $51bf		; $519e
	ld a,$10		; $51a1
	ret c			; $51a3
	call $51bf		; $51a4
	ld a,$18		; $51a7
	ret c			; $51a9
	xor a			; $51aa
	ret			; $51ab
	ld e,$89		; $51ac
	ld a,(de)		; $51ae
	bit 3,a			; $51af
	jr nz,_label_0c_118	; $51b1
	ld e,$8b		; $51b3
	ld a,(de)		; $51b5
	and $07			; $51b6
	ret			; $51b8
_label_0c_118:
	ld e,$8d		; $51b9
	ld a,(de)		; $51bb
	and $07			; $51bc
	ret			; $51be
	and $18			; $51bf
	rrca			; $51c1
	ld hl,$51e3		; $51c2
	rst_addAToHl			; $51c5
	ld e,$8b		; $51c6
	ld a,(de)		; $51c8
	add (hl)		; $51c9
	ld b,a			; $51ca
	inc hl			; $51cb
	ld e,$8d		; $51cc
	ld a,(de)		; $51ce
	add (hl)		; $51cf
	ld c,a			; $51d0
	push hl			; $51d1
	push bc			; $51d2
	call checkTileCollisionAt_disallowHoles		; $51d3
	pop bc			; $51d6
	pop hl			; $51d7
	ret c			; $51d8
	inc hl			; $51d9
	ldi a,(hl)		; $51da
	add b			; $51db
	ld b,a			; $51dc
	ld a,(hl)		; $51dd
	add c			; $51de
	ld c,a			; $51df
	jp checkTileCollisionAt_disallowHoles		; $51e0
	rst $30			; $51e3
.DB $fc				; $51e4
	nop			; $51e5
	rlca			; $51e6
.DB $fc				; $51e7
	ld ($0007),sp		; $51e8
	ld ($00fc),sp		; $51eb
	rlca			; $51ee
.DB $fc				; $51ef
	rst $30			; $51f0
	rlca			; $51f1
	nop			; $51f2

enemyCode14:
	call _ecom_checkHazards		; $51f3
	jr z,_label_0c_123	; $51f6
	sub $03			; $51f8
	ret c			; $51fa
	jp z,enemyDie		; $51fb
	dec a			; $51fe
	jr nz,_label_0c_121	; $51ff
	ld h,d			; $5201
	ld l,$b0		; $5202
	bit 0,(hl)		; $5204
	jr z,_label_0c_119	; $5206
	ld e,$8f		; $5208
	ld a,(de)		; $520a
	rlca			; $520b
	jr c,_label_0c_119	; $520c
	ld (hl),$00		; $520e
_label_0c_119:
	ld e,$aa		; $5210
	ld a,(de)		; $5212
	cp $8d			; $5213
	jr z,_label_0c_120	; $5215
	res 7,a			; $5217
	sub $01			; $5219
	cp $03			; $521b
	jr nc,_label_0c_123	; $521d
_label_0c_120:
	ld e,$84		; $521f
	ld a,(de)		; $5221
	cp $0b			; $5222
	ret z			; $5224
	ld (hl),$01		; $5225
	ld bc,$fe80		; $5227
	call objectSetSpeedZ		; $522a
	ld l,$84		; $522d
	ld (hl),$0b		; $522f
	ld l,$a5		; $5231
	ld (hl),$4e		; $5233
	ld l,$86		; $5235
	ld (hl),$b4		; $5237
	ld l,$ac		; $5239
	ld a,(hl)		; $523b
	xor $10			; $523c
	ld l,$89		; $523e
	ld (hl),a		; $5240
	ld a,$52		; $5241
	call playSound		; $5243
	ld a,$01		; $5246
	jp enemySetAnimation		; $5248
_label_0c_121:
	ld e,$b0		; $524b
	ld a,(de)		; $524d
	or a			; $524e
	jp z,_ecom_updateKnockbackAndCheckHazards		; $524f
	ld c,$18		; $5252
	call objectUpdateSpeedZAndBounce		; $5254
	ld a,$01		; $5257
	jr nc,_label_0c_122	; $5259
	xor a			; $525b
_label_0c_122:
	ld e,$ad		; $525c
	ld (de),a		; $525e
	ld e,$ac		; $525f
	ld a,(de)		; $5261
	ld c,a			; $5262
	ld b,$23		; $5263
	jp _ecom_applyGivenVelocity		; $5265
_label_0c_123:
	ld e,$84		; $5268
	ld a,(de)		; $526a
	rst_jumpTable			; $526b
	add (hl)		; $526c
	ld d,d			; $526d
	adc (hl)		; $526e
	ld d,d			; $526f
	adc (hl)		; $5270
	ld d,d			; $5271
	adc (hl)		; $5272
	ld d,d			; $5273
	adc (hl)		; $5274
	ld d,d			; $5275
	bit 0,h			; $5276
	adc (hl)		; $5278
	ld d,d			; $5279
	adc (hl)		; $527a
	ld d,d			; $527b
	adc a			; $527c
	ld d,d			; $527d
	and (hl)		; $527e
	ld d,d			; $527f
	cp c			; $5280
	ld d,d			; $5281
	pop de			; $5282
	ld d,d			; $5283
	nop			; $5284
	ld d,e			; $5285
	call $531e		; $5286
	ld a,$0a		; $5289
	jp _ecom_setSpeedAndState8AndVisible		; $528b
	ret			; $528e
	ld b,$08		; $528f
	call objectCheckCenteredWithLink		; $5291
	jp c,$532f		; $5294
	call _ecom_decCounter1		; $5297
	jp z,$531e		; $529a
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $529d
	jp z,$531e		; $52a0
_label_0c_124:
	jp enemyAnimate		; $52a3
	call _ecom_decCounter2		; $52a6
	call $5340		; $52a9
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $52ac
	jr nz,_label_0c_124	; $52af
	call _ecom_incState		; $52b1
	ld l,$86		; $52b4
	ld (hl),$1e		; $52b6
	ret			; $52b8
	ld b,$08		; $52b9
	call objectCheckCenteredWithLink		; $52bb
	jp c,$532f		; $52be
	call _ecom_decCounter1		; $52c1
	jr nz,_label_0c_124	; $52c4
	ld l,$84		; $52c6
	ld (hl),$08		; $52c8
	ld l,$90		; $52ca
	ld (hl),$0a		; $52cc
	jp $531e		; $52ce
	call _ecom_decCounter1		; $52d1
	jr nz,_label_0c_125	; $52d4
	ld l,e			; $52d6
	inc (hl)		; $52d7
	ld l,$90		; $52d8
	ld (hl),$1e		; $52da
	ld l,$a5		; $52dc
	ld (hl),$17		; $52de
	ld l,$8d		; $52e0
	inc (hl)		; $52e2
	ld bc,$fe80		; $52e3
	call objectSetSpeedZ		; $52e6
	xor a			; $52e9
	jp enemySetAnimation		; $52ea
_label_0c_125:
	ld a,(hl)		; $52ed
	cp $3c			; $52ee
	jr nc,_label_0c_124	; $52f0
	and $06			; $52f2
	rrca			; $52f4
	ld hl,$5350		; $52f5
	rst_addAToHl			; $52f8
	ld e,$8d		; $52f9
	ld a,(de)		; $52fb
	add (hl)		; $52fc
	ld (de),a		; $52fd
	jr _label_0c_124		; $52fe
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5300
	call enemyAnimate		; $5303
	ld c,$18		; $5306
	call objectUpdateSpeedZ_paramC		; $5308
	ret nz			; $530b
	ld e,$84		; $530c
	ld a,$08		; $530e
	ld (de),a		; $5310
	ld b,$10		; $5311
	call objectCheckCenteredWithLink		; $5313
	jr c,_label_0c_126	; $5316
	ld e,$90		; $5318
	ld a,$0a		; $531a
	ld (de),a		; $531c
	ret			; $531d
	ld bc,$1830		; $531e
	call _ecom_randomBitwiseAndBCE		; $5321
	ld e,$89		; $5324
	ld a,b			; $5326
	ld (de),a		; $5327
	ld e,$86		; $5328
	ld a,$30		; $532a
	add c			; $532c
	ld (de),a		; $532d
	ret			; $532e
_label_0c_126:
	call _ecom_updateCardinalAngleTowardTarget		; $532f
	ld h,d			; $5332
	ld l,$84		; $5333
	ld (hl),$09		; $5335
	ld l,$87		; $5337
	ld (hl),$96		; $5339
	ld l,$90		; $533b
	ld (hl),$0a		; $533d
	ret			; $533f
	ld e,$87		; $5340
	ld a,(de)		; $5342
	and $03			; $5343
	ret nz			; $5345
	ld e,$90		; $5346
	ld a,(de)		; $5348
	cp $3c			; $5349
	ret nc			; $534b
	add $05			; $534c
	ld (de),a		; $534e
	ret			; $534f
	ld bc,$ffff		; $5350
	.db $01

enemyCode15:
	jr z,_label_0c_127		; $5354
	sub $03			; $5356
	ret c			; $5358
	ld e,$aa		; $5359
	ld a,(de)		; $535b
	cp $80			; $535c
	jr nz,_label_0c_127	; $535e
	ld a,$39		; $5360
	call cpActiveRing		; $5362
	jr z,_label_0c_127	; $5365
	ld a,$b4		; $5367
	ld ($cc74),a		; $5369
_label_0c_127:
	ld e,$84		; $536c
	ld a,(de)		; $536e
	rst_jumpTable			; $536f
	add d			; $5370
	ld d,e			; $5371
	sub d			; $5372
	ld d,e			; $5373
	sub d			; $5374
	ld d,e			; $5375
	sub d			; $5376
	ld d,e			; $5377
	sub d			; $5378
	ld d,e			; $5379
	sub d			; $537a
	ld d,e			; $537b
	sub d			; $537c
	ld d,e			; $537d
	sub d			; $537e
	ld d,e			; $537f
	sub e			; $5380
	ld d,e			; $5381
	call getRandomNumber_noPreserveVars		; $5382
	and $18			; $5385
	ld e,$89		; $5387
	ld (de),a		; $5389
	ld a,$1e		; $538a
	call _ecom_setSpeedAndState8		; $538c
	jp objectSetVisible82		; $538f
	ret			; $5392
	call $53af		; $5393
	call z,$53a2		; $5396
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5399
	call z,$53a2		; $539c
	jp enemyAnimate		; $539f
	ld bc,$0718		; $53a2
	call _ecom_randomBitwiseAndBCE		; $53a5
	or b			; $53a8
	ret nz			; $53a9
	ld e,$89		; $53aa
	ld a,c			; $53ac
	ld (de),a		; $53ad
	ret			; $53ae
	ld h,d			; $53af
	ld l,$8b		; $53b0
	ldi a,(hl)		; $53b2
	ld b,a			; $53b3
	inc l			; $53b4
	ld c,(hl)		; $53b5
	or c			; $53b6
	and $07			; $53b7
	ret			; $53b9

enemyCode16:
	jr z,_label_0c_128	; $53ba
	sub $03			; $53bc
	ret c			; $53be
_label_0c_128:
	ld e,$84		; $53bf
	ld a,(de)		; $53c1
	rst_jumpTable			; $53c2
	rst_addAToHl			; $53c3
	ld d,e			; $53c4
	pop hl			; $53c5
	ld d,e			; $53c6
	pop hl			; $53c7
	ld d,e			; $53c8
	pop hl			; $53c9
	ld d,e			; $53ca
	pop hl			; $53cb
	ld d,e			; $53cc
	pop hl			; $53cd
	ld d,e			; $53ce
	pop hl			; $53cf
	ld d,e			; $53d0
	pop hl			; $53d1
	ld d,e			; $53d2
	ld ($ff00+c),a		; $53d3
	ld d,e			; $53d4
.DB $eb				; $53d5
	ld d,e			; $53d6
	call _ecom_setSpeedAndState8AndVisible		; $53d7
	ld l,$86		; $53da
	ld (hl),$05		; $53dc
	jp objectMakeTileSolid		; $53de
	ret			; $53e1
	call $5410		; $53e2
	call _ecom_decCounter2		; $53e5
	ret nz			; $53e8
	jr _label_0c_130		; $53e9
	call _ecom_decCounter1		; $53eb
	jr nz,_label_0c_129	; $53ee
	ld (hl),$05		; $53f0
	inc l			; $53f2
	ld (hl),$28		; $53f3
	ld l,e			; $53f5
	dec (hl)		; $53f6
	ret			; $53f7
_label_0c_129:
	ld a,(hl)		; $53f8
	cp $0b			; $53f9
	ld a,$a4		; $53fb
	jp z,playSound		; $53fd
	ret nc			; $5400
	ld b,$29		; $5401
	call _ecom_spawnProjectile		; $5403
	ret nz			; $5406
	ld e,$86		; $5407
	ld a,(de)		; $5409
	and $01			; $540a
	ld l,$c2		; $540c
	ld (hl),a		; $540e
	ret			; $540f
	call _ecom_decCounter1		; $5410
	ret nz			; $5413
	ld (hl),$05		; $5414
	ld l,$89		; $5416
	ld a,(hl)		; $5418
	inc a			; $5419
	and $1f			; $541a
	ld (hl),a		; $541c
	ld hl,$5425		; $541d
	rst_addAToHl			; $5420
	ld a,(hl)		; $5421
	jp enemySetAnimation		; $5422
	nop			; $5425
	nop			; $5426
	ld bc,$0101		; $5427
	ld bc,$0201		; $542a
	ld (bc),a		; $542d
	ld (bc),a		; $542e
	inc bc			; $542f
	inc bc			; $5430
	inc bc			; $5431
	inc bc			; $5432
	inc bc			; $5433
	inc b			; $5434
	inc b			; $5435
	inc b			; $5436
	dec b			; $5437
	dec b			; $5438
	dec b			; $5439
	dec b			; $543a
	dec b			; $543b
	ld b,$06		; $543c
	ld b,$07		; $543e
	rlca			; $5440
	rlca			; $5441
	rlca			; $5442
	rlca			; $5443
	nop			; $5444
_label_0c_130:
	call objectGetAngleTowardEnemyTarget		; $5445
	ld h,d			; $5448
	ld l,$89		; $5449
	sub (hl)		; $544b
	inc a			; $544c
	cp $02			; $544d
	ret nc			; $544f
	ld l,$86		; $5450
	ld (hl),$14		; $5452
	ld l,$ab		; $5454
	ld (hl),$14		; $5456
	ld l,$84		; $5458
	inc (hl)		; $545a
	ret			; $545b

enemyCode17:
	jr z,_label_0c_135	; $545c
	sub $03			; $545e
	jr c,_label_0c_131	; $5460
	jr z,_label_0c_132	; $5462
	dec a			; $5464
	jp nz,_ecom_updateKnockbackNoSolidity		; $5465
	ret			; $5468
_label_0c_131:
	ld e,$ae		; $5469
	ld a,(de)		; $546b
	or a			; $546c
	ret nz			; $546d
	ld e,$8f		; $546e
	ld a,$fe		; $5470
	ld (de),a		; $5472
	ret			; $5473
_label_0c_132:
	ld e,$82		; $5474
	ld a,(de)		; $5476
	dec a			; $5477
	jp z,enemyDie		; $5478
	ld hl,$d081		; $547b
_label_0c_133:
	ld a,(hl)		; $547e
	cp $17			; $547f
	jr nz,_label_0c_134	; $5481
	inc l			; $5483
	ldd a,(hl)		; $5484
	dec a			; $5485
	jr nz,_label_0c_134	; $5486
	call _ecom_killObjectH		; $5488
	ld l,$81		; $548b
_label_0c_134:
	inc h			; $548d
	ld a,h			; $548e
	cp $e0			; $548f
	jr c,_label_0c_133	; $5491
	jp enemyDie		; $5493
_label_0c_135:
	call _ecom_getSubidAndCpStateTo08		; $5496
	jr nc,_label_0c_136	; $5499
	rst_jumpTable			; $549b
	or h			; $549c
	ld d,h			; $549d
	ret nc			; $549e
	ld d,h			; $549f
	ret nc			; $54a0
	ld d,h			; $54a1
	ret nc			; $54a2
	ld d,h			; $54a3
	ret nc			; $54a4
	ld d,h			; $54a5
	bit 0,h			; $54a6
	ret nc			; $54a8
	ld d,h			; $54a9
	ret nc			; $54aa
	ld d,h			; $54ab
_label_0c_136:
	ld a,b			; $54ac
	rst_jumpTable			; $54ad
	pop de			; $54ae
	ld d,h			; $54af
.DB $fd				; $54b0
	ld d,h			; $54b1
	adc (hl)		; $54b2
	ld d,l			; $54b3
	ld a,$14		; $54b4
	call _ecom_setSpeedAndState8		; $54b6
	ld l,$8f		; $54b9
	ld (hl),$fe		; $54bb
	ld a,b			; $54bd
	dec a			; $54be
	jr nz,_label_0c_137	; $54bf
	ld l,$86		; $54c1
	ld (hl),$3c		; $54c3
	ld l,$89		; $54c5
	ld (hl),$10		; $54c7
	ld l,$a4		; $54c9
	res 7,(hl)		; $54cb
_label_0c_137:
	jp objectSetVisiblec1		; $54cd
	ret			; $54d0
	ld a,(de)		; $54d1
	sub $08			; $54d2
	rst_jumpTable			; $54d4
	reti			; $54d5
	ld d,h			; $54d6
	rst $28			; $54d7
	ld d,h			; $54d8
	ld bc,$187f		; $54d9
	call _ecom_randomBitwiseAndBCE		; $54dc
	ld h,d			; $54df
	ld l,$86		; $54e0
	ld a,$30		; $54e2
	add c			; $54e4
	ld (hl),a		; $54e5
	ld l,$89		; $54e6
	ld (hl),b		; $54e8
	ld l,$84		; $54e9
	inc (hl)		; $54eb
	jp $5624		; $54ec
	call $561d		; $54ef
	call _ecom_decCounter1		; $54f2
	jr nz,_label_0c_138	; $54f5
	ld l,$84		; $54f7
	dec (hl)		; $54f9
_label_0c_138:
	jp enemyAnimate		; $54fa
	ld a,(de)		; $54fd
	sub $08			; $54fe
	rst_jumpTable			; $5500
	dec bc			; $5501
	ld d,l			; $5502
	inc h			; $5503
	ld d,l			; $5504
	ld d,l			; $5505
	ld d,l			; $5506
	ld h,(hl)		; $5507
	ld d,l			; $5508
	ld a,c			; $5509
	ld d,l			; $550a
	call _ecom_decCounter1		; $550b
	jr z,_label_0c_139	; $550e
	ld a,(hl)		; $5510
	and $01			; $5511
	ret nz			; $5513
	jp _ecom_flickerVisibility		; $5514
_label_0c_139:
	ld l,$9a		; $5517
	set 7,(hl)		; $5519
	ld l,$a4		; $551b
	set 7,(hl)		; $551d
	call $556b		; $551f
	jr _label_0c_141		; $5522
	call $561d		; $5524
	ld a,(wFrameCounter)		; $5527
	rrca			; $552a
	jr nc,_label_0c_141	; $552b
	call _ecom_decCounter1		; $552d
	jr z,_label_0c_140	; $5530
	call getRandomNumber_noPreserveVars		; $5532
	cp $08			; $5535
	jr nc,_label_0c_141	; $5537
	ld bc,$1f1f		; $5539
	call _ecom_randomBitwiseAndBCE		; $553c
	or b			; $553f
	ld a,c			; $5540
	call z,objectGetAngleTowardEnemyTarget		; $5541
	ld e,$89		; $5544
	ld (de),a		; $5546
	call $5624		; $5547
	jr _label_0c_141		; $554a
_label_0c_140:
	call _ecom_incState		; $554c
	ld l,$86		; $554f
	ld (hl),$00		; $5551
	jr _label_0c_141		; $5553
	ld h,d			; $5555
	ld l,$86		; $5556
	inc (hl)		; $5558
	ld a,(hl)		; $5559
	cp $80			; $555a
	jp c,$55fd		; $555c
	ld (hl),$80		; $555f
	ld l,e			; $5561
	inc (hl)		; $5562
_label_0c_141:
	jp enemyAnimate		; $5563
	call _ecom_decCounter1		; $5566
	jr nz,_label_0c_141	; $5569
	ld l,$84		; $556b
	ld (hl),$0c		; $556d
	ld l,$86		; $556f
	ld (hl),$7f		; $5571
	ld l,$90		; $5573
	ld (hl),$05		; $5575
	jr _label_0c_141		; $5577
	call _ecom_decCounter1		; $5579
	jp nz,$55fd		; $557c
	ld l,e			; $557f
	ld (hl),$09		; $5580
	call getRandomNumber_noPreserveVars		; $5582
	ld e,$86		; $5585
	and $7f			; $5587
	add $7f			; $5589
	ld (de),a		; $558b
	jr _label_0c_141		; $558c
	ld a,(de)		; $558e
	sub $08			; $558f
	rst_jumpTable			; $5591
	sbc d			; $5592
	ld d,l			; $5593
	xor b			; $5594
	ld d,l			; $5595
	cp h			; $5596
	ld d,l			; $5597
.DB $e3				; $5598
	ld d,l			; $5599
_label_0c_142:
	ld h,d			; $559a
	ld l,e			; $559b
	inc (hl)		; $559c
	ld l,$90		; $559d
	ld (hl),$0a		; $559f
	ld l,$86		; $55a1
	ld (hl),$24		; $55a3
	call $5635		; $55a5
	call _ecom_decCounter1		; $55a8
	jr nz,_label_0c_143	; $55ab
	ld l,e			; $55ad
	inc (hl)		; $55ae
	jr _label_0c_144		; $55af
_label_0c_143:
	ld a,(hl)		; $55b1
	and $07			; $55b2
	jr nz,_label_0c_144	; $55b4
	ld l,$90		; $55b6
	ld a,(hl)		; $55b8
	add $05			; $55b9
	ld (hl),a		; $55bb
_label_0c_144:
	ld h,d			; $55bc
	ld l,$b0		; $55bd
	call _ecom_readPositionVars		; $55bf
	sub c			; $55c2
	inc a			; $55c3
	cp $03			; $55c4
	jr nc,_label_0c_145	; $55c6
	ldh a,(<hFF8F)	; $55c8
	sub b			; $55ca
	inc a			; $55cb
	cp $03			; $55cc
	jr nc,_label_0c_145	; $55ce
	ld l,$84		; $55d0
	ld (hl),$0b		; $55d2
	ld l,$86		; $55d4
	ld (hl),$1c		; $55d6
	jr _label_0c_147		; $55d8
_label_0c_145:
	call _ecom_moveTowardPosition		; $55da
	call $5624		; $55dd
_label_0c_146:
	jp enemyAnimate		; $55e0
_label_0c_147:
	call _ecom_decCounter1		; $55e3
	jr z,_label_0c_149	; $55e6
	ld a,(hl)		; $55e8
	and $07			; $55e9
	jr nz,_label_0c_148	; $55eb
	ld l,$90		; $55ed
	ld a,(hl)		; $55ef
	sub $05			; $55f0
	ld (hl),a		; $55f2
_label_0c_148:
	call objectApplySpeed		; $55f3
	jr _label_0c_146		; $55f6
_label_0c_149:
	ld l,e			; $55f8
	ld (hl),$08		; $55f9
	jr _label_0c_142		; $55fb
	call $561d		; $55fd
	ld e,$86		; $5600
	ld a,(de)		; $5602
	ld b,$00		; $5603
	cp $2a			; $5605
	jr c,_label_0c_150	; $5607
	inc b			; $5609
	cp $54			; $560a
	jr c,_label_0c_150	; $560c
	inc b			; $560e
_label_0c_150:
	ld a,b			; $560f
	ld hl,$561a		; $5610
	rst_addAToHl			; $5613
	ld e,$90		; $5614
	ld a,(hl)		; $5616
	ld (de),a		; $5617
	jr _label_0c_146		; $5618
	inc d			; $561a
	ld a,(bc)		; $561b
	dec b			; $561c
	call objectApplySpeed		; $561d
	call _ecom_bounceOffScreenBoundary		; $5620
	ret z			; $5623
	ld h,d			; $5624
	ld l,$89		; $5625
	ldd a,(hl)		; $5627
	cp $10			; $5628
	ld a,$01		; $562a
	jr c,_label_0c_151	; $562c
	dec a			; $562e
_label_0c_151:
	cp (hl)			; $562f
	ret z			; $5630
	ld (hl),a		; $5631
	jp enemySetAnimation		; $5632
	ld bc,$7070		; $5635
	call _ecom_randomBitwiseAndBCE		; $5638
	ld a,b			; $563b
	sub $20			; $563c
	jr nc,_label_0c_152	; $563e
	xor a			; $5640
_label_0c_152:
	ld b,a			; $5641
	ld hl,$cca0		; $5642
	ldi a,(hl)		; $5645
	srl a			; $5646
	add b			; $5648
	sub $28			; $5649
	ld b,a			; $564b
	ld a,(hl)		; $564c
	srl a			; $564d
	add c			; $564f
	sub $38			; $5650
	ld c,a			; $5652
	ld h,d			; $5653
	ld l,$b0		; $5654
	ld (hl),b		; $5656
	inc l			; $5657
	ld (hl),c		; $5658
	ret			; $5659

enemyCode18:
	call _ecom_checkHazards		; $565a
	jr z,_label_0c_154	; $565d
	sub $03			; $565f
	jp c,$5720		; $5661
	jp z,enemyDie		; $5664
	dec a			; $5667
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5668
	ld h,d			; $566b
	ld l,$aa		; $566c
	ld a,(hl)		; $566e
	cp $9a			; $566f
	jr z,_label_0c_153	; $5671
	cp $a0			; $5673
	ret nz			; $5675
	ld l,$84		; $5676
	ld (hl),$0a		; $5678
	ld l,$bf		; $567a
	res 4,(hl)		; $567c
	ld l,$ae		; $567e
	ld (hl),$00		; $5680
	ld l,$86		; $5682
	ld (hl),$3c		; $5684
	ld a,$01		; $5686
	jp enemySetAnimation		; $5688
_label_0c_153:
	ld l,$b0		; $568b
	ld a,$02		; $568d
	cp (hl)			; $568f
	ret z			; $5690
	ld (hl),a		; $5691
	call enemySetAnimation		; $5692
	ld e,$b1		; $5695
	jp objectAddToAButtonSensitiveObjectList		; $5697
_label_0c_154:
	call $5720		; $569a
	call _ecom_checkScentSeedActive		; $569d
	ld e,$84		; $56a0
	ld a,(de)		; $56a2
	rst_jumpTable			; $56a3
	cp d			; $56a4
	ld d,(hl)		; $56a5
	ld ($ff00+c),a		; $56a6
	ld d,(hl)		; $56a7
	ld ($ff00+c),a		; $56a8
	ld d,(hl)		; $56a9
	ld ($ff00+c),a		; $56aa
	ld d,(hl)		; $56ab
	add $56			; $56ac
	bit 0,h			; $56ae
	ld ($ff00+c),a		; $56b0
	ld d,(hl)		; $56b1
	ld ($ff00+c),a		; $56b2
	ld d,(hl)		; $56b3
.DB $e3				; $56b4
	ld d,(hl)		; $56b5
	ld hl,sp+$56		; $56b6
	ld b,$57		; $56b8
	ld a,$0a		; $56ba
	call _ecom_setSpeedAndState8AndVisible		; $56bc
	ld l,$bf		; $56bf
	ld a,(hl)		; $56c1
	or $30			; $56c2
	ld (hl),a		; $56c4
	ret			; $56c5
	ld a,($ccf0)		; $56c6
	or a			; $56c9
	jr nz,_label_0c_155	; $56ca
	ld a,$08		; $56cc
	ld (de),a		; $56ce
	jr _label_0c_156		; $56cf
_label_0c_155:
	call _ecom_updateAngleToScentSeed		; $56d1
	ld e,$89		; $56d4
	ld a,(de)		; $56d6
	add $04			; $56d7
	and $18			; $56d9
	ld (de),a		; $56db
	call _ecom_applyVelocityForSideviewEnemy		; $56dc
	jp enemyAnimate		; $56df
	ret			; $56e2
	ld a,$09		; $56e3
	ld (de),a		; $56e5
	ld bc,$1c30		; $56e6
	call _ecom_randomBitwiseAndBCE		; $56e9
	ld e,$86		; $56ec
	ld a,$30		; $56ee
	add c			; $56f0
	ld (de),a		; $56f1
	ld e,$89		; $56f2
	ld a,b			; $56f4
	ld (de),a		; $56f5
	jr _label_0c_156		; $56f6
	call _ecom_decCounter1		; $56f8
	jr z,_label_0c_157	; $56fb
	call _ecom_bounceOffWallsAndHoles		; $56fd
	call objectApplySpeed		; $5700
_label_0c_156:
	jp enemyAnimate		; $5703
	call _ecom_decCounter1		; $5706
	jr nz,_label_0c_156	; $5709
	ld e,$b0		; $570b
	ld a,(de)		; $570d
	call enemySetAnimation		; $570e
_label_0c_157:
	ld h,d			; $5711
	ld l,$84		; $5712
	ld (hl),$08		; $5714
	ld l,$bf		; $5716
	set 4,(hl)		; $5718
	ld l,$a4		; $571a
	set 7,(hl)		; $571c
	jr _label_0c_156		; $571e
	ld e,$b1		; $5720
	ld a,(de)		; $5722
	or a			; $5723
	ret z			; $5724
	xor a			; $5725
	ld (de),a		; $5726
	call getRandomNumber_noPreserveVars		; $5727
	and $07			; $572a
	add $1e			; $572c
	ld c,a			; $572e
	ld b,$2f		; $572f
	jp showText		; $5731

enemyCode1a:
	jr z,_label_0c_158	; $5734
	sub $03			; $5736
	ret c			; $5738
	jp z,enemyDie		; $5739
	dec a			; $573c
	jp nz,_ecom_updateKnockback		; $573d
	ret			; $5740
_label_0c_158:
	call _ecom_checkScentSeedActive		; $5741
	ld e,$84		; $5744
	ld a,(de)		; $5746
	rst_jumpTable			; $5747
	ld e,h			; $5748
	ld d,a			; $5749
	sub (hl)		; $574a
	ld d,a			; $574b
	sub (hl)		; $574c
	ld d,a			; $574d
	adc d			; $574e
	ld d,a			; $574f
	ld h,h			; $5750
	ld d,a			; $5751
	bit 0,h			; $5752
	sub (hl)		; $5754
	ld d,a			; $5755
	sub (hl)		; $5756
	ld d,a			; $5757
	sub a			; $5758
	ld d,a			; $5759
	or a			; $575a
	ld d,a			; $575b
	ld h,d			; $575c
	ld l,$bf		; $575d
	set 4,(hl)		; $575f
	jp _ecom_setSpeedAndState8AndVisible		; $5761
	ld a,($ccf0)		; $5764
	or a			; $5767
	jr nz,_label_0c_159	; $5768
	ld a,$08		; $576a
	ld (de),a		; $576c
	jr _label_0c_163		; $576d
_label_0c_159:
	call _ecom_updateAngleToScentSeed		; $576f
	ld e,$89		; $5772
	ld a,(de)		; $5774
	add $04			; $5775
	and $18			; $5777
	ld (de),a		; $5779
	bit 3,a			; $577a
	ld a,$0a		; $577c
	jr z,_label_0c_160	; $577e
	ld a,$28		; $5780
_label_0c_160:
	ld e,$90		; $5782
	ld (de),a		; $5784
	call _ecom_applyVelocityForSideviewEnemy		; $5785
	jr _label_0c_163		; $5788
	inc e			; $578a
	ld a,(de)		; $578b
	rst_jumpTable			; $578c
	dec b			; $578d
	ld b,b			; $578e
	sub l			; $578f
	ld d,a			; $5790
	sub l			; $5791
	ld d,a			; $5792
	rst $38			; $5793
	ld b,h			; $5794
	ret			; $5795
	ret			; $5796
	ld a,$09		; $5797
	ld (de),a		; $5799
	ld bc,$1830		; $579a
	call _ecom_randomBitwiseAndBCE		; $579d
	ld e,$86		; $57a0
	ld a,$30		; $57a2
	add c			; $57a4
	ld (de),a		; $57a5
	bit 3,b			; $57a6
	ld a,$0a		; $57a8
	jr z,_label_0c_161	; $57aa
	ld a,$28		; $57ac
_label_0c_161:
	ld e,$90		; $57ae
	ld (de),a		; $57b0
	ld e,$89		; $57b1
	ld a,b			; $57b3
	ld (de),a		; $57b4
	jr _label_0c_163		; $57b5
	call _ecom_decCounter1		; $57b7
	jr z,_label_0c_162	; $57ba
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $57bc
	jr nz,_label_0c_163	; $57bf
_label_0c_162:
	ld e,$84		; $57c1
	ld a,$08		; $57c3
	ld (de),a		; $57c5
_label_0c_163:
	jp enemyAnimate		; $57c6

enemyCode1b:
	call _ecom_checkHazards		; $57c9
	jr z,_label_0c_164	; $57cc
	sub $03			; $57ce
	ret c			; $57d0
	jp z,enemyDie		; $57d1
	dec a			; $57d4
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $57d5
	ld e,$aa		; $57d8
	ld a,(de)		; $57da
	cp $80			; $57db
	ret nz			; $57dd
	ld e,$84		; $57de
	ld a,(de)		; $57e0
	cp $08			; $57e1
	jr nz,_label_0c_164	; $57e3
	call _ecom_updateCardinalAngleTowardTarget		; $57e5
	jp $585e		; $57e8
_label_0c_164:
	ld e,$84		; $57eb
	ld a,(de)		; $57ed
	rst_jumpTable			; $57ee
	rlca			; $57ef
	ld e,b			; $57f0
	ld b,h			; $57f1
	ld e,b			; $57f2
	ld b,h			; $57f3
	ld e,b			; $57f4
	jr c,_label_0c_165	; $57f5
	ld b,h			; $57f7
	ld e,b			; $57f8
	bit 0,h			; $57f9
	ld b,h			; $57fb
	ld e,b			; $57fc
	ld b,h			; $57fd
	ld e,b			; $57fe
	ld b,l			; $57ff
	ld e,b			; $5800
	ld l,h			; $5801
	ld e,b			; $5802
	adc l			; $5803
	ld e,b			; $5804
	sub a			; $5805
	ld e,b			; $5806
	ld b,$58		; $5807
	call _ecom_spawnUncountedEnemyWithSubid01		; $5809
	ret nz			; $580c
	ld e,l			; $580d
	ld a,(de)		; $580e
	ld (hl),a		; $580f
	ld l,$96		; $5810
	ld a,$80		; $5812
	ldi (hl),a		; $5814
	ld (hl),d		; $5815
	ld e,$98		; $5816
	ld (de),a		; $5818
	inc e			; $5819
	ld a,h			; $581a
	ld (de),a		; $581b
	call objectCopyPosition		; $581c
	ld a,$23		; $581f
	call _ecom_setSpeedAndState8		; $5821
	ld l,$a6		; $5824
	ld a,$03		; $5826
	ldi (hl),a		; $5828
	ld (hl),a		; $5829
	ld l,$83		; $582a
	ld (hl),$80		; $582c
	dec l			; $582e
	ld a,(hl)		; $582f
	cp $02			; $5830
	ret c			; $5832
	ld l,$a4		; $5833
	ld (hl),$96		; $5835
	ret			; $5837
	inc e			; $5838
	ld a,(de)		; $5839
	rst_jumpTable			; $583a
	dec b			; $583b
	ld b,b			; $583c
	ld b,e			; $583d
	ld e,b			; $583e
	ld b,e			; $583f
	ld e,b			; $5840
	rst $38			; $5841
	ld b,h			; $5842
	ret			; $5843
	ret			; $5844
	call $58ae		; $5845
	ret z			; $5848
	call _ecom_decCounter2		; $5849
	ret nz			; $584c
	ld b,$0c		; $584d
_label_0c_165:
	call objectCheckCenteredWithLink		; $584f
	ret nc			; $5852
	call _ecom_updateCardinalAngleTowardTarget		; $5853
	or a			; $5856
	ret z			; $5857
	ld a,$01		; $5858
	call _ecom_getTopDownAdjacentWallsBitset		; $585a
	ret nz			; $585d
	call _ecom_incState		; $585e
	ld l,$86		; $5861
	ld (hl),$38		; $5863
	ld l,$83		; $5865
	ld (hl),$81		; $5867
	jp objectSetVisiblec3		; $5869
	call $58ae		; $586c
	ret z			; $586f
	call _ecom_decCounter1		; $5870
	jr z,_label_0c_166	; $5873
	call $414c		; $5875
	jr nz,_label_0c_168	; $5878
_label_0c_166:
	ld h,d			; $587a
	ld l,$87		; $587b
	ld (hl),$1e		; $587d
	ld l,$84		; $587f
	dec (hl)		; $5881
	ld l,$83		; $5882
	ld (hl),$80		; $5884
	ld l,$bb		; $5886
	ld (hl),$00		; $5888
	jp objectSetInvisible		; $588a
	call _ecom_decCounter1		; $588d
	jr nz,_label_0c_168	; $5890
	inc (hl)		; $5892
	ld l,e			; $5893
	inc (hl)		; $5894
	jr _label_0c_168		; $5895
	call _ecom_decCounter1		; $5897
	jr nz,_label_0c_167	; $589a
	ld (hl),$28		; $589c
	call getRandomNumber_noPreserveVars		; $589e
	and $1c			; $58a1
	ld e,$89		; $58a3
	ld (de),a		; $58a5
	jr _label_0c_168		; $58a6
_label_0c_167:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $58a8
_label_0c_168:
	jp enemyAnimate		; $58ab
	ld e,$99		; $58ae
	ld a,(de)		; $58b0
	or a			; $58b1
	ret nz			; $58b2
	ld h,d			; $58b3
	ld l,$84		; $58b4
	ld (hl),$0a		; $58b6
	ld l,$86		; $58b8
	ld (hl),$3c		; $58ba
	ld l,$a4		; $58bc
	ld (hl),$9b		; $58be
	ld l,$a6		; $58c0
	ld a,$06		; $58c2
	ldi (hl),a		; $58c4
	ld (hl),a		; $58c5
	call objectSetVisiblec3		; $58c6
	xor a			; $58c9
	ret			; $58ca

enemyCode1d:
	call _ecom_checkHazards		; $58cb
	jr z,_label_0c_169	; $58ce
	sub $03			; $58d0
	ret c			; $58d2
	jp z,$5a5c		; $58d3
	dec a			; $58d6
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $58d7
	ld e,$aa		; $58da
	ld a,(de)		; $58dc
	cp $80			; $58dd
	ret nz			; $58df
	ld e,$82		; $58e0
	ld a,(de)		; $58e2
	cp $80			; $58e3
	jr nz,_label_0c_169	; $58e5
	ld h,d			; $58e7
	ld l,$84		; $58e8
	ld a,(hl)		; $58ea
	cp $09			; $58eb
	jr nc,_label_0c_169	; $58ed
	ld (hl),$09		; $58ef
	ret			; $58f1
_label_0c_169:
	call _ecom_getSubidAndCpStateTo08		; $58f2
	jr nc,_label_0c_170	; $58f5
	rst_jumpTable			; $58f7
	stop			; $58f8
	ld e,c			; $58f9
	ldd a,(hl)		; $58fa
	ld e,c			; $58fb
	ld h,(hl)		; $58fc
	ld e,c			; $58fd
	ld d,l			; $58fe
	ld e,c			; $58ff
	ld h,(hl)		; $5900
	ld e,c			; $5901
	ld h,(hl)		; $5902
	ld e,c			; $5903
	ld h,(hl)		; $5904
	ld e,c			; $5905
	ld h,(hl)		; $5906
	ld e,c			; $5907
_label_0c_170:
	res 7,b			; $5908
	ld a,b			; $590a
	rst_jumpTable			; $590b
	ld h,a			; $590c
	ld e,c			; $590d
	ret nz			; $590e
	ld e,c			; $590f
	ld a,b			; $5910
	bit 7,a			; $5911
	jr z,_label_0c_172	; $5913
	add a			; $5915
	ld hl,$5936		; $5916
	rst_addAToHl			; $5919
	ld e,$9c		; $591a
	ldi a,(hl)		; $591c
	ld (de),a		; $591d
	dec e			; $591e
	ld (de),a		; $591f
	ld a,(hl)		; $5920
	call _ecom_setSpeedAndState8		; $5921
	ld l,$82		; $5924
	bit 0,(hl)		; $5926
	jr z,_label_0c_171	; $5928
	ld l,$a9		; $592a
	inc (hl)		; $592c
_label_0c_171:
	ld l,$a4		; $592d
	ld (hl),$a9		; $592f
	ret			; $5931
_label_0c_172:
	ld a,$01		; $5932
	ld (de),a		; $5934
	ret			; $5935
	dec b			; $5936
	inc d			; $5937
	inc b			; $5938
	ld e,$1e		; $5939
	adc e			; $593b
	ld a,(de)		; $593c
	ld b,a			; $593d
	ld hl,$cf00		; $593e
	ld c,$b0		; $5941
_label_0c_173:
	ld a,(hl)		; $5943
	cp b			; $5944
	call z,$5a34		; $5945
	inc l			; $5948
	dec c			; $5949
	jr nz,_label_0c_173	; $594a
	call $5a73		; $594c
	call decNumEnemies		; $594f
	jp enemyDelete		; $5952
	inc e			; $5955
	ld a,(de)		; $5956
	rst_jumpTable			; $5957
	dec b			; $5958
	ld b,b			; $5959
	ld h,b			; $595a
	ld e,c			; $595b
	ld h,b			; $595c
	ld e,c			; $595d
	ld h,c			; $595e
	ld e,c			; $595f
	ret			; $5960
	ld b,$0b		; $5961
	jp _ecom_fallToGroundAndSetState		; $5963
	ret			; $5966
	ld a,(de)		; $5967
	sub $08			; $5968
	rst_jumpTable			; $596a
	ld (hl),l		; $596b
	ld e,c			; $596c
	ld a,(hl)		; $596d
	ld e,c			; $596e
	adc h			; $596f
	ld e,c			; $5970
	and (hl)		; $5971
	ld e,c			; $5972
	or b			; $5973
	ld e,c			; $5974
	ld a,($ccbc)		; $5975
	or a			; $5978
	ret z			; $5979
	ld a,$09		; $597a
	ld (de),a		; $597c
	ret			; $597d
	ld h,d			; $597e
	ld l,e			; $597f
	inc (hl)		; $5980
	ld l,$86		; $5981
	ld (hl),$3c		; $5983
	ld l,$8b		; $5985
	inc (hl)		; $5987
	inc (hl)		; $5988
	jp objectSetVisible82		; $5989
	call _ecom_decCounter1		; $598c
	jp nz,_ecom_flickerVisibility		; $598f
	ld a,$1d		; $5992
	ld l,e			; $5994
	inc (hl)		; $5995
	ld l,$a4		; $5996
	ld (hl),$9d		; $5998
	inc l			; $599a
	ldi (hl),a		; $599b
	ld a,$06		; $599c
	ldi (hl),a		; $599e
	ld (hl),a		; $599f
	call $5a81		; $59a0
	jp objectSetVisiblec2		; $59a3
	ld h,d			; $59a6
	ld l,e			; $59a7
	inc (hl)		; $59a8
	ld l,$86		; $59a9
	ld (hl),$3d		; $59ab
	call _ecom_setRandomCardinalAngle		; $59ad
	call _ecom_decCounter1		; $59b0
	call nz,$414c		; $59b3
	jr nz,_label_0c_174	; $59b6
	ld e,$84		; $59b8
	ld a,$0b		; $59ba
	ld (de),a		; $59bc
_label_0c_174:
	jp enemyAnimate		; $59bd
	ld a,(de)		; $59c0
	sub $08			; $59c1
	rst_jumpTable			; $59c3
	adc $59			; $59c4
	ld a,(hl)		; $59c6
	ld e,c			; $59c7
	ld hl,sp+$59		; $59c8
	inc bc			; $59ca
	ld e,d			; $59cb
	ld hl,$cd5a		; $59cc
	ld (hl),l		; $59cf
	ld e,c			; $59d0
	ret nz			; $59d1
	ld h,d			; $59d2
	ld l,$8b		; $59d3
	ldh a,(<hEnemyTargetY)	; $59d5
	sub (hl)		; $59d7
	add $18			; $59d8
	cp $31			; $59da
	ret nc			; $59dc
	ld b,(hl)		; $59dd
	ld l,$8d		; $59de
	ldh a,(<hEnemyTargetX)	; $59e0
	sub (hl)		; $59e2
	add $18			; $59e3
	cp $31			; $59e5
	ret nc			; $59e7
	ld a,(hl)		; $59e8
	and $f0			; $59e9
	swap a			; $59eb
	ld c,a			; $59ed
	ld a,b			; $59ee
	and $f0			; $59ef
	or c			; $59f1
	ld l,$b1		; $59f2
	ld (hl),a		; $59f4
	ld l,e			; $59f5
	inc (hl)		; $59f6
	ret			; $59f7
	call _ecom_decCounter1		; $59f8
	jp nz,_ecom_flickerVisibility		; $59fb
	ld a,$51		; $59fe
	jp $5994		; $5a00
	ld a,$0c		; $5a03
	ld (de),a		; $5a05
	ld bc,$0303		; $5a06
	call _ecom_randomBitwiseAndBCE		; $5a09
	ld a,b			; $5a0c
	ld hl,$5a1d		; $5a0d
	rst_addAToHl			; $5a10
	ld e,$86		; $5a11
	ld a,(hl)		; $5a13
	ld (de),a		; $5a14
	ld a,c			; $5a15
	or a			; $5a16
	jp z,_ecom_updateCardinalAngleTowardTarget		; $5a17
	jp _ecom_setRandomCardinalAngle		; $5a1a
	ld e,$2d		; $5a1d
	inc a			; $5a1f
	ld c,e			; $5a20
	call _ecom_decCounter1		; $5a21
	jr z,_label_0c_175	; $5a24
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5a26
	jr z,_label_0c_175	; $5a29
	jp enemyAnimate		; $5a2b
_label_0c_175:
	ld e,$84		; $5a2e
	ld a,$0b		; $5a30
	ld (de),a		; $5a32
	ret			; $5a33
	push bc			; $5a34
	push hl			; $5a35
	ld c,l			; $5a36
	ld b,$1d		; $5a37
	call _ecom_spawnEnemyWithSubid01		; $5a39
	jr nz,_label_0c_176	; $5a3c
	ld e,l			; $5a3e
	ld a,(de)		; $5a3f
	set 7,a			; $5a40
	ld (hl),a		; $5a42
	ld e,$8d		; $5a43
	ld l,$b0		; $5a45
	ld a,(de)		; $5a47
	ld (hl),a		; $5a48
	ld l,e			; $5a49
	ld a,c			; $5a4a
	and $0f			; $5a4b
	swap a			; $5a4d
	add $08			; $5a4f
	ldd (hl),a		; $5a51
	dec l			; $5a52
	ld a,c			; $5a53
	and $f0			; $5a54
	add $06			; $5a56
	ld (hl),a		; $5a58
_label_0c_176:
	pop hl			; $5a59
	pop bc			; $5a5a
	ret			; $5a5b
	ld e,$82		; $5a5c
	ld a,(de)		; $5a5e
	rrca			; $5a5f
	jp nc,enemyDie		; $5a60
	ld e,$b1		; $5a63
	ld a,(de)		; $5a65
	ld b,a			; $5a66
	ld hl,$cfcf		; $5a67
_label_0c_177:
	inc l			; $5a6a
	ld a,(hl)		; $5a6b
	or a			; $5a6c
	jr nz,_label_0c_177	; $5a6d
	ld (hl),b		; $5a6f
	jp enemyDie		; $5a70
	ld hl,$cfd0		; $5a73
	xor a			; $5a76
	ld b,$04		; $5a77
_label_0c_178:
	ldi (hl),a		; $5a79
	ldi (hl),a		; $5a7a
	ldi (hl),a		; $5a7b
	ldi (hl),a		; $5a7c
	dec b			; $5a7d
	jr nz,_label_0c_178	; $5a7e
	ret			; $5a80
	call objectGetTileAtPosition		; $5a81
	ld c,l			; $5a84
	ld e,$b0		; $5a85
	ld a,(de)		; $5a87
	jp setTile		; $5a88

enemyCode1e:
	jr z,_label_0c_180	; $5a8b
	sub $03			; $5a8d
	jr c,_label_0c_179	; $5a8f
	jp z,enemyDie		; $5a91
	dec a			; $5a94
	ret z			; $5a95
	ld e,$90		; $5a96
	ld a,$50		; $5a98
	ld (de),a		; $5a9a
	call $5bda		; $5a9b
	ld e,$ac		; $5a9e
	call _ecom_applyVelocityGivenAdjacentWalls		; $5aa0
	ld e,$90		; $5aa3
	ld a,$1e		; $5aa5
	ld (de),a		; $5aa7
	ret			; $5aa8
_label_0c_179:
	ld e,$8f		; $5aa9
	ld a,(de)		; $5aab
	cp $02			; $5aac
	ret z			; $5aae
	or a			; $5aaf
	ret nz			; $5ab0
	jp $5b3c		; $5ab1
_label_0c_180:
	call _ecom_getSubidAndCpStateTo08		; $5ab4
	jr nc,_label_0c_181	; $5ab7
	rst_jumpTable			; $5ab9
	ret nc			; $5aba
	ld e,d			; $5abb
	and $5a			; $5abc
	and $5a			; $5abe
	and $5a			; $5ac0
	and $5a			; $5ac2
	bit 0,h			; $5ac4
	and $5a			; $5ac6
	and $5a			; $5ac8
_label_0c_181:
	ld a,b			; $5aca
	rst_jumpTable			; $5acb
	rst $20			; $5acc
	ld e,d			; $5acd
	ld e,e			; $5ace
	ld e,e			; $5acf
	ld a,$14		; $5ad0
	call _ecom_setSpeedAndState8		; $5ad2
	call objectSetVisible83		; $5ad5
	ld l,$8f		; $5ad8
	ld (hl),$02		; $5ada
	ld l,$89		; $5adc
	ld (hl),$08		; $5ade
	call $5bc8		; $5ae0
	jp $5b69		; $5ae3
	ret			; $5ae6
	ld a,(de)		; $5ae7
	sub $08			; $5ae8
	rst_jumpTable			; $5aea
	rst $28			; $5aeb
	ld e,d			; $5aec
	ldi (hl),a		; $5aed
	ld e,e			; $5aee
	ld a,($ccf0)		; $5aef
	or a			; $5af2
	jr nz,_label_0c_182	; $5af3
	call _ecom_decCounter1		; $5af5
	jr z,_label_0c_183	; $5af8
_label_0c_182:
	call $5b98		; $5afa
	jp $5b62		; $5afd
_label_0c_183:
	ld l,e			; $5b00
	inc (hl)		; $5b01
	ld l,$a5		; $5b02
	ld (hl),$10		; $5b04
	ld l,$8f		; $5b06
	ld (hl),$00		; $5b08
	ld l,$94		; $5b0a
	ld a,$80		; $5b0c
	ldi (hl),a		; $5b0e
	ld (hl),$fe		; $5b0f
	ld l,$90		; $5b11
	ld (hl),$1e		; $5b13
	ld b,$03		; $5b15
	call objectCreateInteractionWithSubid00		; $5b17
	call objectSetVisiblec1		; $5b1a
	ld b,$00		; $5b1d
	jp $5b81		; $5b1f
	ld c,$10		; $5b22
	call objectUpdateSpeedZ_paramC		; $5b24
	jr z,_label_0c_185	; $5b27
	ld l,$94		; $5b29
	ld a,(hl)		; $5b2b
	or a			; $5b2c
	jr nz,_label_0c_184	; $5b2d
	inc l			; $5b2f
	ld a,(hl)		; $5b30
	or a			; $5b31
	jr nz,_label_0c_184	; $5b32
	ld b,$01		; $5b34
	call $5b81		; $5b36
_label_0c_184:
	jp $5b98		; $5b39
_label_0c_185:
	ld h,d			; $5b3c
	ld l,$a5		; $5b3d
	ld (hl),$04		; $5b3f
	ld l,$8f		; $5b41
	ld (hl),$02		; $5b43
	ld l,$84		; $5b45
	ld (hl),$08		; $5b47
	ld l,$90		; $5b49
	ld (hl),$14		; $5b4b
	call $5bc8		; $5b4d
	ld b,$03		; $5b50
	call objectCreateInteractionWithSubid00		; $5b52
	call objectSetVisible83		; $5b55
	jp $5b69		; $5b58
	ld a,(de)		; $5b5b
	sub $08			; $5b5c
	rst_jumpTable			; $5b5e
	ld h,c			; $5b5f
	ld e,e			; $5b60
	ret			; $5b61
	ret c			; $5b62
	ld e,$89		; $5b63
	ld a,(de)		; $5b65
	xor $10			; $5b66
	ld (de),a		; $5b68
	ld e,$89		; $5b69
	ld a,(de)		; $5b6b
	swap a			; $5b6c
	rlca			; $5b6e
	ld hl,$5b7d		; $5b6f
	rst_addAToHl			; $5b72
	ld a,(hl)		; $5b73
	ld h,d			; $5b74
	ld l,$b0		; $5b75
	cp (hl)			; $5b77
	ret z			; $5b78
	ld (hl),a		; $5b79
	jp enemySetAnimation		; $5b7a
	ld (bc),a		; $5b7d
	ld bc,$0002		; $5b7e
	ld e,$89		; $5b81
	ld a,(de)		; $5b83
	swap a			; $5b84
	and $01			; $5b86
	ld a,$03		; $5b88
	jr nz,_label_0c_186	; $5b8a
	ld a,$05		; $5b8c
_label_0c_186:
	add b			; $5b8e
	ld h,d			; $5b8f
	ld l,$b0		; $5b90
	cp (hl)			; $5b92
	ret z			; $5b93
	ld (hl),a		; $5b94
	jp enemySetAnimation		; $5b95
	ld e,$89		; $5b98
	ld a,(de)		; $5b9a
	rrca			; $5b9b
	rrca			; $5b9c
	ld hl,$5bc0		; $5b9d
	rst_addAToHl			; $5ba0
	ld e,$8b		; $5ba1
	ld a,(de)		; $5ba3
	add (hl)		; $5ba4
	and $f0			; $5ba5
	ld c,a			; $5ba7
	inc hl			; $5ba8
	ld e,$8d		; $5ba9
	ld a,(de)		; $5bab
	add (hl)		; $5bac
	and $f0			; $5bad
	swap a			; $5baf
	or c			; $5bb1
	ld c,a			; $5bb2
	ld b,$cf		; $5bb3
	ld a,(bc)		; $5bb5
	sub $fa			; $5bb6
	cp $04			; $5bb8
	ret nc			; $5bba
	call objectApplySpeed		; $5bbb
	scf			; $5bbe
	ret			; $5bbf
	ld a,($ff00+$00)	; $5bc0
	nop			; $5bc2
	stop			; $5bc3
	stop			; $5bc4
	nop			; $5bc5
	nop			; $5bc6
	ld a,($ff00+$cd)	; $5bc7
	cpl			; $5bc9
	inc b			; $5bca
	and $03			; $5bcb
	ld hl,$5bd6		; $5bcd
	rst_addAToHl			; $5bd0
	ld e,$86		; $5bd1
	ld a,(hl)		; $5bd3
	ld (de),a		; $5bd4
	ret			; $5bd5
	ld b,b			; $5bd6
	ld d,b			; $5bd7
	ld h,b			; $5bd8
	ld (hl),b		; $5bd9
	ld e,$ac		; $5bda
	ld a,(de)		; $5bdc
	call _ecom_getAdjacentWallTableOffset		; $5bdd
	ld h,d			; $5be0
	ld l,$8b		; $5be1
	ld b,(hl)		; $5be3
	ld l,$8d		; $5be4
	ld c,(hl)		; $5be6
	ld hl,$425e		; $5be7
	rst_addAToHl			; $5bea
	ld a,$10		; $5beb
	ldh (<hFF8B),a	; $5bed
	ld d,$cf		; $5bef
_label_0c_187:
	ldi a,(hl)		; $5bf1
	add b			; $5bf2
	ld b,a			; $5bf3
	and $f0			; $5bf4
	ld e,a			; $5bf6
	ldi a,(hl)		; $5bf7
	add c			; $5bf8
	ld c,a			; $5bf9
	and $f0			; $5bfa
	swap a			; $5bfc
	or e			; $5bfe
	ld e,a			; $5bff
	ld a,(de)		; $5c00
	sub $fa			; $5c01
	cp $04			; $5c03
	ldh a,(<hFF8B)	; $5c05
	rla			; $5c07
	ldh (<hFF8B),a	; $5c08
	jr nc,_label_0c_187	; $5c0a
	xor $0f			; $5c0c
	ldh (<hFF8B),a	; $5c0e
	ldh a,(<hActiveObject)	; $5c10
	ld d,a			; $5c12
	ret			; $5c13

enemyCode23:
	call _ecom_checkHazardsNoAnimationForHoles		; $5c14
	call $5cac		; $5c17
	jr z,_label_0c_188	; $5c1a
	sub $03			; $5c1c
	ret c			; $5c1e
	jp z,enemyDie		; $5c1f
	dec a			; $5c22
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5c23
	ret			; $5c26
_label_0c_188:
	ld e,$84		; $5c27
	ld a,(de)		; $5c29
	rst_jumpTable			; $5c2a
	ccf			; $5c2b
	ld e,h			; $5c2c
	ld c,l			; $5c2d
	ld e,h			; $5c2e
	ld c,l			; $5c2f
	ld e,h			; $5c30
	ld c,l			; $5c31
	ld e,h			; $5c32
	ld c,l			; $5c33
	ld e,h			; $5c34
	bit 0,h			; $5c35
	ld c,l			; $5c37
	ld e,h			; $5c38
	ld c,l			; $5c39
	ld e,h			; $5c3a
	ld c,(hl)		; $5c3b
	ld e,h			; $5c3c
	sub c			; $5c3d
	ld e,h			; $5c3e
	call _ecom_setSpeedAndState8		; $5c3f
	call getRandomNumber_noPreserveVars		; $5c42
	ld e,$86		; $5c45
	and $3f			; $5c47
	inc a			; $5c49
	ld (de),a		; $5c4a
	jr _label_0c_191		; $5c4b
	ret			; $5c4d
	call _ecom_decCounter1		; $5c4e
	ret nz			; $5c51
	ld l,e			; $5c52
	inc (hl)		; $5c53
	ld bc,$0f1c		; $5c54
	call _ecom_randomBitwiseAndBCE		; $5c57
	or b			; $5c5a
	ld hl,$5c89		; $5c5b
	jr nz,_label_0c_189	; $5c5e
	ld hl,$5c8d		; $5c60
_label_0c_189:
	ld e,$94		; $5c63
	ldi a,(hl)		; $5c65
	ld (de),a		; $5c66
	inc e			; $5c67
	ldi a,(hl)		; $5c68
	ld (de),a		; $5c69
	ld e,$b0		; $5c6a
	ldi a,(hl)		; $5c6c
	ld (de),a		; $5c6d
	ld e,$90		; $5c6e
	ld a,(hl)		; $5c70
	ld (de),a		; $5c71
	cp $14			; $5c72
	jr z,_label_0c_190	; $5c74
	call objectGetAngleTowardEnemyTarget		; $5c76
	add $02			; $5c79
	and $1c			; $5c7b
	ld c,a			; $5c7d
_label_0c_190:
	ld e,$89		; $5c7e
	ld a,c			; $5c80
	ld (de),a		; $5c81
	xor a			; $5c82
	call enemySetAnimation		; $5c83
	jp objectSetVisiblec1		; $5c86
	ret c			; $5c89
	cp $0c			; $5c8a
	inc d			; $5c8c
	add b			; $5c8d
	cp $0c			; $5c8e
	ld e,$cd		; $5c90
	ld d,(hl)		; $5c92
	ld b,c			; $5c93
	ld e,$b0		; $5c94
	ld a,(de)		; $5c96
	ld c,a			; $5c97
	call objectUpdateSpeedZ_paramC		; $5c98
	ret nz			; $5c9b
	ld h,d			; $5c9c
	ld l,$84		; $5c9d
	dec (hl)		; $5c9f
	ld l,$86		; $5ca0
	ld (hl),$20		; $5ca2
_label_0c_191:
	ld a,$01		; $5ca4
	call enemySetAnimation		; $5ca6
	jp objectSetVisiblec2		; $5ca9
	ld b,a			; $5cac
	ld a,($cca7)		; $5cad
	or a			; $5cb0
	jr z,_label_0c_192	; $5cb1
	ld b,$03		; $5cb3
_label_0c_192:
	ld a,b			; $5cb5
	or a			; $5cb6
	ret			; $5cb7

enemyCode24:
	call $5f49		; $5cb8
	jr z,_label_0c_195	; $5cbb
	sub $03			; $5cbd
	ret c			; $5cbf
	jr z,_label_0c_194	; $5cc0
	dec a			; $5cc2
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5cc3
	ld e,$aa		; $5cc6
	ld a,(de)		; $5cc8
	cp $80			; $5cc9
	ret nz			; $5ccb
	ld h,d			; $5ccc
	ld l,$8b		; $5ccd
	ldi a,(hl)		; $5ccf
	ld b,a			; $5cd0
	inc l			; $5cd1
	ld c,(hl)		; $5cd2
	ld hl,$5d74		; $5cd3
	ld e,$05		; $5cd6
	call interBankCall		; $5cd8
	rl b			; $5cdb
	jp c,$5de6		; $5cdd
	ld e,$82		; $5ce0
	ld a,(de)		; $5ce2
	or a			; $5ce3
	ld a,$0b		; $5ce4
	jr z,_label_0c_193	; $5ce6
	inc a			; $5ce8
_label_0c_193:
	ld h,d			; $5ce9
	ld l,$84		; $5cea
	ldi (hl),a		; $5cec
	inc l			; $5ced
	ld (hl),$00		; $5cee
	inc l			; $5cf0
	ld (hl),$5a		; $5cf1
	ld l,$a4		; $5cf3
	res 7,(hl)		; $5cf5
	ld hl,$d000		; $5cf7
	call objectCopyPosition		; $5cfa
	ld l,$24		; $5cfd
	res 7,(hl)		; $5cff
	ld a,$01		; $5d01
	call enemySetAnimation		; $5d03
	jp objectSetVisiblec1		; $5d06
_label_0c_194:
	ld e,$97		; $5d09
	ld a,(de)		; $5d0b
	or a			; $5d0c
	jp z,enemyDie		; $5d0d
	ld h,a			; $5d10
	ld l,$b0		; $5d11
	dec (hl)		; $5d13
	jp enemyDie		; $5d14
_label_0c_195:
	call _ecom_getSubidAndCpStateTo08		; $5d17
	jr nc,_label_0c_196	; $5d1a
	rst_jumpTable			; $5d1c
	scf			; $5d1d
	ld e,l			; $5d1e
	ld (hl),b		; $5d1f
	ld e,l			; $5d20
	ld (hl),b		; $5d21
	ld e,l			; $5d22
	ld b,c			; $5d23
	ld e,l			; $5d24
	ld (hl),b		; $5d25
	ld e,l			; $5d26
	ld e,h			; $5d27
	ld e,l			; $5d28
	ld (hl),b		; $5d29
	ld e,l			; $5d2a
	ld (hl),b		; $5d2b
	ld e,l			; $5d2c
_label_0c_196:
	ld a,b			; $5d2d
	rst_jumpTable			; $5d2e
	ld (hl),c		; $5d2f
	ld e,l			; $5d30
	ld (de),a		; $5d31
	ld e,(hl)		; $5d32
	ld (hl),e		; $5d33
	ld e,(hl)		; $5d34
	xor c			; $5d35
	ld e,(hl)		; $5d36
	bit 0,b			; $5d37
	call z,objectSetVisiblec2		; $5d39
	ld a,$0a		; $5d3c
	jp _ecom_setSpeedAndState8		; $5d3e
	inc e			; $5d41
	ld a,(de)		; $5d42
	rst_jumpTable			; $5d43
	dec b			; $5d44
	ld b,b			; $5d45
	ld c,h			; $5d46
	ld e,l			; $5d47
	ld c,h			; $5d48
	ld e,l			; $5d49
	ld c,l			; $5d4a
	ld e,l			; $5d4b
	ret			; $5d4c
	ld e,$82		; $5d4d
	ld a,(de)		; $5d4f
	ld hl,$5d58		; $5d50
	rst_addAToHl			; $5d53
	ld b,(hl)		; $5d54
	jp _ecom_fallToGroundAndSetState		; $5d55
	add hl,bc		; $5d58
	ld ($0a0a),sp		; $5d59
	call _ecom_galeSeedEffect		; $5d5c
	ret c			; $5d5f
	ld e,$97		; $5d60
	ld a,(de)		; $5d62
	or a			; $5d63
	jr z,_label_0c_197	; $5d64
	ld h,a			; $5d66
	ld l,$b0		; $5d67
	dec (hl)		; $5d69
_label_0c_197:
	call decNumEnemies		; $5d6a
	jp enemyDelete		; $5d6d
	ret			; $5d70
	ld a,(de)		; $5d71
	sub $08			; $5d72
	rst_jumpTable			; $5d74
	ld a,a			; $5d75
	ld e,l			; $5d76
	add (hl)		; $5d77
	ld e,l			; $5d78
	sbc e			; $5d79
	ld e,l			; $5d7a
	xor (hl)		; $5d7b
	ld e,l			; $5d7c
	di			; $5d7d
	ld e,l			; $5d7e
	ld h,d			; $5d7f
	ld l,e			; $5d80
	inc (hl)		; $5d81
	ld l,$a4		; $5d82
	set 7,(hl)		; $5d84
	ld h,d			; $5d86
	ld l,e			; $5d87
	inc (hl)		; $5d88
	ld bc,$1830		; $5d89
	call _ecom_randomBitwiseAndBCE		; $5d8c
	ld e,$89		; $5d8f
	ld a,b			; $5d91
	ld (de),a		; $5d92
	ld e,$86		; $5d93
	ld a,$38		; $5d95
	add c			; $5d97
	ld (de),a		; $5d98
	jr _label_0c_200		; $5d99
	call _ecom_decCounter1		; $5d9b
	jr nz,_label_0c_199	; $5d9e
_label_0c_198:
	ld h,d			; $5da0
	ld l,$84		; $5da1
	dec (hl)		; $5da3
	jr _label_0c_200		; $5da4
_label_0c_199:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5da6
	jr z,_label_0c_198	; $5da9
_label_0c_200:
	jp enemyAnimate		; $5dab
	call _ecom_decCounter2		; $5dae
	jr z,_label_0c_201	; $5db1
	ld a,($cc46)		; $5db3
	or a			; $5db6
	jr z,_label_0c_200	; $5db7
	dec l			; $5db9
	inc (hl)		; $5dba
	jr _label_0c_200		; $5dbb
_label_0c_201:
	ld (hl),$3c		; $5dbd
	ld l,$84		; $5dbf
	inc (hl)		; $5dc1
	ld l,$86		; $5dc2
	ld a,(hl)		; $5dc4
	cp $13			; $5dc5
	jr nc,_label_0c_202	; $5dc7
	ld a,$01		; $5dc9
	call checkTreasureObtained		; $5dcb
	jr nc,_label_0c_202	; $5dce
	ld a,$01		; $5dd0
	call loseTreasure		; $5dd2
	ld bc,$510b		; $5dd5
	call showText		; $5dd8
_label_0c_202:
	call getRandomNumber_noPreserveVars		; $5ddb
	and $18			; $5dde
	ld e,$89		; $5de0
	ld (de),a		; $5de2
	call objectSetVisiblec2		; $5de3
	ld hl,$d005		; $5de6
	ld (hl),$04		; $5de9
	ld l,$24		; $5deb
	set 7,(hl)		; $5ded
	xor a			; $5def
	jp enemySetAnimation		; $5df0
	call _ecom_decCounter2		; $5df3
	jr nz,_label_0c_203	; $5df6
	ld l,e			; $5df8
	ld a,(hl)		; $5df9
	sub $03			; $5dfa
	ld (hl),a		; $5dfc
	ld l,$a4		; $5dfd
	set 7,(hl)		; $5dff
	jr _label_0c_200		; $5e01
_label_0c_203:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5e03
	jr nz,_label_0c_200	; $5e06
	call getRandomNumber_noPreserveVars		; $5e08
	and $18			; $5e0b
	ld e,$89		; $5e0d
	ld (de),a		; $5e0f
	jr _label_0c_200		; $5e10
	ld a,(de)		; $5e12
	sub $08			; $5e13
	rst_jumpTable			; $5e15
	inc e			; $5e16
	ld e,(hl)		; $5e17
	dec h			; $5e18
	ld e,(hl)		; $5e19
	jr c,_label_0c_207	; $5e1a
	ld h,d			; $5e1c
	ld l,e			; $5e1d
	inc (hl)		; $5e1e
	ld l,$86		; $5e1f
	inc (hl)		; $5e21
	jp $5f10		; $5e22
	ld a,($d00b)		; $5e25
	sub $10			; $5e28
	cp $60			; $5e2a
	ret nc			; $5e2c
	ld a,($d00d)		; $5e2d
	sub $10			; $5e30
	cp $80			; $5e32
	ret nc			; $5e34
	ld a,$0a		; $5e35
	ld (de),a		; $5e37
	call _ecom_decCounter1		; $5e38
	ret nz			; $5e3b
	inc (hl)		; $5e3c
	ld l,$b0		; $5e3d
	ld a,(hl)		; $5e3f
	cp $06			; $5e40
	ret nc			; $5e42
	call getRandomNumber_noPreserveVars		; $5e43
	and $02			; $5e46
	ld c,a			; $5e48
	ld a,($cc4c)		; $5e49
	cp $50			; $5e4c
	jr z,_label_0c_205	; $5e4e
	cp $40			; $5e50
	jr z,_label_0c_204	; $5e52
	set 2,c			; $5e54
	cp $51			; $5e56
	ret nz			; $5e58
_label_0c_204:
	ld e,$02		; $5e59
	call $5ee8		; $5e5b
	ret nz			; $5e5e
	call $5ef7		; $5e5f
	jr _label_0c_206		; $5e62
_label_0c_205:
	ld e,$03		; $5e64
	call $5ee8		; $5e66
	ret nz			; $5e69
_label_0c_206:
	ld h,d			; $5e6a
	ld l,$b0		; $5e6b
	inc (hl)		; $5e6d
	ld l,$86		; $5e6e
	ld (hl),$78		; $5e70
	ret			; $5e72
	ld a,(de)		; $5e73
	sub $08			; $5e74
	rst_jumpTable			; $5e76
	add e			; $5e77
	ld e,(hl)		; $5e78
	sub (hl)		; $5e79
_label_0c_207:
	ld e,(hl)		; $5e7a
	add (hl)		; $5e7b
	ld e,l			; $5e7c
	sbc e			; $5e7d
	ld e,l			; $5e7e
	xor (hl)		; $5e7f
	ld e,l			; $5e80
	di			; $5e81
	ld e,l			; $5e82
	ld h,d			; $5e83
	ld l,e			; $5e84
	inc (hl)		; $5e85
	ld l,$8b		; $5e86
	ld a,(hl)		; $5e88
	cp $88			; $5e89
	jr z,_label_0c_208	; $5e8b
	ld l,$89		; $5e8d
	ld (hl),$08		; $5e8f
_label_0c_208:
	ld l,$86		; $5e91
	ld (hl),$2d		; $5e93
	ret			; $5e95
	call _ecom_decCounter1		; $5e96
	jr z,_label_0c_209	; $5e99
	call objectApplySpeed		; $5e9b
	jr _label_0c_210		; $5e9e
_label_0c_209:
	ld l,e			; $5ea0
	inc (hl)		; $5ea1
	ld l,$a4		; $5ea2
	set 7,(hl)		; $5ea4
_label_0c_210:
	jp enemyAnimate		; $5ea6
	ld a,(de)		; $5ea9
	sub $08			; $5eaa
	rst_jumpTable			; $5eac
	cp c			; $5ead
	ld e,(hl)		; $5eae
	bit 3,(hl)		; $5eaf
	add (hl)		; $5eb1
	ld e,l			; $5eb2
	sbc e			; $5eb3
	ld e,l			; $5eb4
	jp c,$f35e		; $5eb5
	ld e,l			; $5eb8
	call $5f33		; $5eb9
	ret nz			; $5ebc
	ld l,$84		; $5ebd
	inc (hl)		; $5ebf
	ld l,$a4		; $5ec0
	set 7,(hl)		; $5ec2
	ld l,$95		; $5ec4
	ld (hl),$02		; $5ec6
	jp objectSetVisiblec1		; $5ec8
	ld c,$08		; $5ecb
	call objectUpdateSpeedZ_paramC		; $5ecd
	jr nz,_label_0c_210	; $5ed0
	ld l,$84		; $5ed2
	inc (hl)		; $5ed4
	call objectSetVisiblec2		; $5ed5
	jr _label_0c_210		; $5ed8
	ld c,$08		; $5eda
	call objectUpdateSpeedZ_paramC		; $5edc
	ld l,$8f		; $5edf
	ld a,(hl)		; $5ee1
	ld ($d00f),a		; $5ee2
	jp $5dae		; $5ee5
	ld b,$24		; $5ee8
	call _ecom_spawnEnemyWithSubid01		; $5eea
	ret nz			; $5eed
	ld (hl),e		; $5eee
	ld l,$96		; $5eef
	ld a,$80		; $5ef1
	ldi (hl),a		; $5ef3
	ld (hl),d		; $5ef4
	xor a			; $5ef5
	ret			; $5ef6
	push hl			; $5ef7
	ld a,c			; $5ef8
	ld hl,$5f08		; $5ef9
	rst_addAToHl			; $5efc
	ldi a,(hl)		; $5efd
	ld b,a			; $5efe
	ld c,(hl)		; $5eff
	pop hl			; $5f00
	ld l,$8b		; $5f01
	ld (hl),b		; $5f03
	ld l,$8d		; $5f04
_label_0c_211:
	ld (hl),c		; $5f06
	ret			; $5f07
	adc b			; $5f08
	ld c,b			; $5f09
	adc b			; $5f0a
	ld e,b			; $5f0b
	jr c,_label_0c_211	; $5f0c
	ld c,b			; $5f0e
	ld hl,sp+$21		; $5f0f
	add c			; $5f11
	ret nc			; $5f12
	ld c,$00		; $5f13
_label_0c_212:
	ld a,(hl)		; $5f15
	cp $24			; $5f16
	jr nz,_label_0c_213	; $5f18
	inc l			; $5f1a
	ldd a,(hl)		; $5f1b
	or a			; $5f1c
	jr nz,_label_0c_213	; $5f1d
	ld l,$96		; $5f1f
	ld a,$80		; $5f21
	ldi (hl),a		; $5f23
	ld (hl),d		; $5f24
	ld l,$81		; $5f25
	inc c			; $5f27
_label_0c_213:
	inc h			; $5f28
	ld a,h			; $5f29
	cp $e0			; $5f2a
	jr c,_label_0c_212	; $5f2c
	ld e,$b0		; $5f2e
	ld a,c			; $5f30
	ld (de),a		; $5f31
	ret			; $5f32
	call getRandomNumber_noPreserveVars		; $5f33
	and $77			; $5f36
	inc a			; $5f38
	ld c,a			; $5f39
	ld b,$ce		; $5f3a
	ld a,(bc)		; $5f3c
	or a			; $5f3d
	ret nz			; $5f3e
	call objectSetShortPosition		; $5f3f
	ld c,$08		; $5f42
	call _ecom_setZAboveScreen		; $5f44
	xor a			; $5f47
	ret			; $5f48
	push af			; $5f49
	ld a,($d004)		; $5f4a
	cp $0d			; $5f4d
	jr nz,_label_0c_214	; $5f4f
	ld e,$8f		; $5f51
	ld a,(de)		; $5f53
	rlca			; $5f54
	jr c,_label_0c_214	; $5f55
	ld bc,$0500		; $5f57
	call objectGetRelativeTile		; $5f5a
	ld hl,hazardCollisionTable		; $5f5d
	call lookupCollisionTable		; $5f60
	call c,$5de6		; $5f63
_label_0c_214:
	pop af			; $5f66
	jp _ecom_checkHazards		; $5f67

enemyCode25:
	jr z,_label_0c_215	; $5f6a
	sub $03			; $5f6c
	ret c			; $5f6e
	jp z,enemyDie		; $5f6f
	ld e,$a9		; $5f72
	ld a,(de)		; $5f74
	or a			; $5f75
	jp z,_ecom_updateKnockback		; $5f76
_label_0c_215:
	ld e,$84		; $5f79
	ld a,(de)		; $5f7b
	rst_jumpTable			; $5f7c
	sub c			; $5f7d
	ld e,a			; $5f7e
	xor h			; $5f7f
	ld e,a			; $5f80
	xor h			; $5f81
	ld e,a			; $5f82
	xor h			; $5f83
	ld e,a			; $5f84
	xor h			; $5f85
	ld e,a			; $5f86
	xor h			; $5f87
	ld e,a			; $5f88
	xor h			; $5f89
	ld e,a			; $5f8a
	xor h			; $5f8b
	ld e,a			; $5f8c
	xor l			; $5f8d
	ld e,a			; $5f8e
	cp d			; $5f8f
	ld e,a			; $5f90
	ld h,d			; $5f91
	ld l,$86		; $5f92
	ld (hl),$5a		; $5f94
	ld l,$82		; $5f96
	ld a,(hl)		; $5f98
	or a			; $5f99
	jr z,_label_0c_216	; $5f9a
	ld l,$9d		; $5f9c
	ld a,(hl)		; $5f9e
	add $04			; $5f9f
	ld (hl),a		; $5fa1
	ld l,$a5		; $5fa2
	ld (hl),$54		; $5fa4
_label_0c_216:
	call _ecom_setSpeedAndState8		; $5fa6
	jp objectSetVisible83		; $5fa9
	ret			; $5fac
	call _ecom_decCounter1		; $5fad
	ret nz			; $5fb0
	ld (hl),$3c		; $5fb1
	ld l,e			; $5fb3
	inc (hl)		; $5fb4
	ld a,$01		; $5fb5
	jp enemySetAnimation		; $5fb7
	call _ecom_decCounter1		; $5fba
	jr z,_label_0c_217	; $5fbd
	ld a,(hl)		; $5fbf
	cp $28			; $5fc0
	ret nz			; $5fc2
	ld e,$82		; $5fc3
	ld a,(de)		; $5fc5
	dec a			; $5fc6
	call nz,getRandomNumber_noPreserveVars		; $5fc7
	and $03			; $5fca
	ret nz			; $5fcc
	ld b,$31		; $5fcd
	jp _ecom_spawnProjectile		; $5fcf
_label_0c_217:
	ld e,$82		; $5fd2
	ld a,(de)		; $5fd4
	ld bc,$5fe4		; $5fd5
	call addAToBc		; $5fd8
	ld a,(bc)		; $5fdb
	ld (hl),a		; $5fdc
	ld l,$84		; $5fdd
	dec (hl)		; $5fdf
	xor a			; $5fe0
	jp enemySetAnimation		; $5fe1
	ld a,b			; $5fe4
	or h			; $5fe5

enemyCode27:
	jr z,_label_0c_219	; $5fe6
	sub $03			; $5fe8
	ret c			; $5fea
	jr z,_label_0c_218	; $5feb
	dec a			; $5fed
	jr nz,_label_0c_219	; $5fee
	ld e,$b0		; $5ff0
	ld a,(de)		; $5ff2
	or a			; $5ff3
	ret nz			; $5ff4
	ld h,d			; $5ff5
	ld l,$84		; $5ff6
	ld (hl),$0c		; $5ff8
	ld l,$b1		; $5ffa
	ld h,(hl)		; $5ffc
	jp _ecom_killObjectH		; $5ffd
_label_0c_218:
	ld e,$82		; $6000
	ld a,(de)		; $6002
	dec a			; $6003
	jp nz,enemyDie		; $6004
_label_0c_219:
	ld e,$84		; $6007
	ld a,(de)		; $6009
	rst_jumpTable			; $600a
	daa			; $600b
	ld h,b			; $600c
	ld b,l			; $600d
	ld h,b			; $600e
	ld b,l			; $600f
	ld h,b			; $6010
	ld b,l			; $6011
	ld h,b			; $6012
	ld b,l			; $6013
	ld h,b			; $6014
	ld b,l			; $6015
	ld h,b			; $6016
	ld b,l			; $6017
	ld h,b			; $6018
	ld b,l			; $6019
	ld h,b			; $601a
	ld b,(hl)		; $601b
	ld h,b			; $601c
	ld h,b			; $601d
	ld h,b			; $601e
	sub c			; $601f
	ld h,b			; $6020
	xor e			; $6021
	ld h,b			; $6022
	cp l			; $6023
	ld h,b			; $6024
	adc $60			; $6025
	call $611f		; $6027
	ret nz			; $602a
	call objectMakeTileSolid		; $602b
	ld h,$cf		; $602e
	ld (hl),$00		; $6030
	call _ecom_setSpeedAndState8		; $6032
	ld l,$86		; $6035
	inc (hl)		; $6037
	ld l,$b0		; $6038
	ld (hl),$02		; $603a
	ld l,$83		; $603c
	ld a,(hl)		; $603e
	ld (hl),$00		; $603f
	ld l,$b3		; $6041
	ld (hl),a		; $6043
	ret			; $6044
	ret			; $6045
	ld c,$2c		; $6046
	call objectCheckLinkWithinDistance		; $6048
	ret c			; $604b
	call _ecom_decCounter1		; $604c
	ret nz			; $604f
	ld (hl),$5a		; $6050
	ld l,$84		; $6052
	inc (hl)		; $6054
	ld l,$83		; $6055
	ld (hl),$02		; $6057
	xor a			; $6059
	call enemySetAnimation		; $605a
	jp objectSetVisiblec3		; $605d
	ld c,$2c		; $6060
	call objectCheckLinkWithinDistance		; $6062
	jp c,$60e4		; $6065
	call _ecom_decCounter1		; $6068
	jr nz,_label_0c_220	; $606b
	ld l,$84		; $606d
	inc (hl)		; $606f
	ld l,$a4		; $6070
	set 7,(hl)		; $6072
	ld l,$83		; $6074
	inc (hl)		; $6076
	call objectGetAngleTowardEnemyTarget		; $6077
	ld hl,$60fa		; $607a
	rst_addAToHl			; $607d
	ld a,(hl)		; $607e
	or a			; $607f
	jr z,_label_0c_221	; $6080
	ld e,$89		; $6082
	ld (de),a		; $6084
	rrca			; $6085
	rrca			; $6086
	sub $02			; $6087
	ld hl,$611a		; $6089
	rst_addAToHl			; $608c
	ld a,(hl)		; $608d
	jp enemySetAnimation		; $608e
	ld c,$2c		; $6091
	call objectCheckLinkWithinDistance		; $6093
	jr c,_label_0c_221	; $6096
	ld e,$a1		; $6098
	ld a,(de)		; $609a
	inc a			; $609b
	jr z,_label_0c_221	; $609c
	ld a,(de)		; $609e
	dec a			; $609f
	jr nz,_label_0c_220	; $60a0
	ld (de),a		; $60a2
	ld b,$1e		; $60a3
	call _ecom_spawnProjectile		; $60a5
_label_0c_220:
	jp enemyAnimate		; $60a8
	ld e,$a1		; $60ab
	ld a,(de)		; $60ad
	inc a			; $60ae
	jr nz,_label_0c_220	; $60af
	ld h,d			; $60b1
	ld l,$84		; $60b2
	ld (hl),$08		; $60b4
	ld l,$83		; $60b6
	ld (hl),$00		; $60b8
	jp objectSetInvisible		; $60ba
	ld h,d			; $60bd
	ld l,e			; $60be
	inc (hl)		; $60bf
	ld l,$a4		; $60c0
	res 7,(hl)		; $60c2
	ld e,$b2		; $60c4
	call objectAddToAButtonSensitiveObjectList		; $60c6
	ld a,$07		; $60c9
	call enemySetAnimation		; $60cb
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $60ce
	ld e,$b2		; $60d1
	ld a,(de)		; $60d3
	or a			; $60d4
	jr z,_label_0c_220	; $60d5
	ld e,$b2		; $60d7
	xor a			; $60d9
	ld (de),a		; $60da
	ld e,$b3		; $60db
	ld a,(de)		; $60dd
	ld c,a			; $60de
	ld b,$45		; $60df
	jp showText		; $60e1
_label_0c_221:
	ld h,d			; $60e4
	ld l,$84		; $60e5
	ld (hl),$0b		; $60e7
	ld l,$86		; $60e9
	ld (hl),$78		; $60eb
	ld l,$a4		; $60ed
	res 7,(hl)		; $60ef
	ld l,$83		; $60f1
	ld (hl),$02		; $60f3
	ld a,$06		; $60f5
	jp enemySetAnimation		; $60f7
	nop			; $60fa
	nop			; $60fb
	nop			; $60fc
	nop			; $60fd
	nop			; $60fe
	nop			; $60ff
	nop			; $6100
	ld ($0808),sp		; $6101
	inc c			; $6104
	inc c			; $6105
	inc c			; $6106
	inc c			; $6107
	inc c			; $6108
	stop			; $6109
	stop			; $610a
	stop			; $610b
	inc d			; $610c
	inc d			; $610d
	inc d			; $610e
	inc d			; $610f
	inc d			; $6110
	jr $18			; $6111
	jr _label_0c_222		; $6113
_label_0c_222:
	nop			; $6115
	nop			; $6116
	nop			; $6117
	nop			; $6118
	nop			; $6119
	dec b			; $611a
	inc b			; $611b
	inc bc			; $611c
	ld (bc),a		; $611d
	ld bc,$5806		; $611e
	call _ecom_spawnUncountedEnemyWithSubid01		; $6121
	ret nz			; $6124
	call objectCopyPosition		; $6125
	ld l,$96		; $6128
	ld a,$80		; $612a
	ldi (hl),a		; $612c
	ld (hl),d		; $612d
	ld e,$b1		; $612e
	ld a,h			; $6130
	ld (de),a		; $6131
	ld l,$82		; $6132
	ld e,l			; $6134
	ld a,(de)		; $6135
	ld (hl),a		; $6136
	xor a			; $6137
	ret			; $6138

enemyCode28:
	jr z,_label_0c_225	; $6139
	sub $03			; $613b
	ret c			; $613d
	jr z,_label_0c_223	; $613e
	dec a			; $6140
	jp nz,_ecom_updateKnockback		; $6141
	ld e,$aa		; $6144
	ld a,(de)		; $6146
	cp $80			; $6147
	ret nz			; $6149
	ld e,$ad		; $614a
	ld a,(de)		; $614c
	or a			; $614d
	ret nz			; $614e
	ld h,d			; $614f
	ld l,$b0		; $6150
	ld (hl),$01		; $6152
	ld l,$a4		; $6154
	res 7,(hl)		; $6156
	ld l,$8b		; $6158
	ldi a,(hl)		; $615a
	ld ($d00b),a		; $615b
	inc l			; $615e
	ld a,(hl)		; $615f
	ld ($d00d),a		; $6160
	ret			; $6163
_label_0c_223:
	ld e,$97		; $6164
	ld a,(de)		; $6166
	or a			; $6167
	jr z,_label_0c_224	; $6168
	ld h,a			; $616a
	ld l,$99		; $616b
	ld (hl),$00		; $616d
	ld l,$8b		; $616f
	dec (hl)		; $6171
_label_0c_224:
	jp enemyDie_uncounted		; $6172
_label_0c_225:
	ld e,$84		; $6175
	ld a,(de)		; $6177
	rst_jumpTable			; $6178
	sub l			; $6179
	ld h,c			; $617a
	xor c			; $617b
	ld h,c			; $617c
.DB $f4				; $617d
	ld h,c			; $617e
.DB $f4				; $617f
	ld h,c			; $6180
.DB $f4				; $6181
	ld h,c			; $6182
	ld ($ff00+c),a		; $6183
	ld h,c			; $6184
.DB $f4				; $6185
	ld h,c			; $6186
.DB $f4				; $6187
	ld h,c			; $6188
	push af			; $6189
	ld h,c			; $618a
	inc de			; $618b
	ld h,d			; $618c
	ld sp,$5962		; $618d
	ld h,d			; $6190
	ld a,a			; $6191
	ld h,d			; $6192
	adc (hl)		; $6193
	ld h,d			; $6194
	ld e,$82		; $6195
	ld a,(de)		; $6197
	or a			; $6198
	jp nz,_ecom_setSpeedAndState8		; $6199
	ld h,d			; $619c
	ld l,$84		; $619d
	inc (hl)		; $619f
	ld l,$86		; $61a0
	ld (hl),$b4		; $61a2
	ld l,$98		; $61a4
	ld (hl),$80		; $61a6
	ret			; $61a8
	ld e,$8b		; $61a9
	ld a,(de)		; $61ab
	or a			; $61ac
	jr z,_label_0c_226	; $61ad
	ld e,$99		; $61af
	ld a,(de)		; $61b1
	or a			; $61b2
	ret nz			; $61b3
	call _ecom_decCounter1		; $61b4
	ret nz			; $61b7
	ld (hl),$78		; $61b8
	ld a,($d00b)		; $61ba
	ld b,a			; $61bd
	ld a,($d00d)		; $61be
	ld c,a			; $61c1
	call getTileCollisionsAtPosition		; $61c2
	ret nz			; $61c5
	push bc			; $61c6
	ld b,$28		; $61c7
	call _ecom_spawnUncountedEnemyWithSubid01		; $61c9
	pop bc			; $61cc
	ret nz			; $61cd
	ld l,$96		; $61ce
	ld a,$80		; $61d0
	ldi (hl),a		; $61d2
	ld (hl),d		; $61d3
	ld e,$99		; $61d4
	ld a,h			; $61d6
	ld (de),a		; $61d7
	ret			; $61d8
_label_0c_226:
	call decNumEnemies		; $61d9
	call markEnemyAsKilledInRoom		; $61dc
	jp enemyDelete		; $61df
	call _ecom_galeSeedEffect		; $61e2
	ret c			; $61e5
	ld e,$97		; $61e6
	ld a,(de)		; $61e8
	or a			; $61e9
	jr z,_label_0c_227	; $61ea
	ld h,a			; $61ec
	ld l,$99		; $61ed
	ld (hl),$00		; $61ef
_label_0c_227:
	jp enemyDelete		; $61f1
	ret			; $61f4
	ld h,d			; $61f5
	ld l,e			; $61f6
	inc (hl)		; $61f7
	ld l,$a4		; $61f8
	ld (hl),$b5		; $61fa
	ld l,$8f		; $61fc
	ld (hl),$a0		; $61fe
	ld l,$8b		; $6200
	ld a,($d00b)		; $6202
	ldi (hl),a		; $6205
	inc l			; $6206
	ld a,($d00d)		; $6207
	ld (hl),a		; $620a
	ld a,$59		; $620b
	call playSound		; $620d
	jp objectSetVisiblec1		; $6210
	ld c,$0e		; $6213
	call objectUpdateSpeedZ_paramC		; $6215
	jr z,_label_0c_228	; $6218
	call $6294		; $621a
	ld e,$b0		; $621d
	ld a,(de)		; $621f
	or a			; $6220
	ret z			; $6221
	ld e,$8f		; $6222
	ld a,(de)		; $6224
	ld ($d00f),a		; $6225
	ret			; $6228
_label_0c_228:
	ld l,$86		; $6229
	ld (hl),$1e		; $622b
	ld l,$84		; $622d
	inc (hl)		; $622f
	ret			; $6230
	call _ecom_decCounter1		; $6231
	jr nz,_label_0c_229	; $6234
	ld l,e			; $6236
	inc (hl)		; $6237
	ret			; $6238
_label_0c_229:
	ld a,(hl)		; $6239
	cp $14			; $623a
	jr c,_label_0c_230	; $623c
	ret nz			; $623e
	ld a,$01		; $623f
	jp enemySetAnimation		; $6241
_label_0c_230:
	dec a			; $6244
	jr nz,_label_0c_231	; $6245
	ld l,$a4		; $6247
	ld a,(hl)		; $6249
	and $80			; $624a
	or $28			; $624c
	ld (hl),a		; $624e
_label_0c_231:
	ld l,$b0		; $624f
	bit 0,(hl)		; $6251
	ret z			; $6253
	xor a			; $6254
	ld ($d01a),a		; $6255
	ret			; $6258
	call $6294		; $6259
	ld h,d			; $625c
	ld l,$8f		; $625d
	dec (hl)		; $625f
	dec (hl)		; $6260
	ld a,(hl)		; $6261
	cp $a0			; $6262
	ret nc			; $6264
	call objectSetInvisible		; $6265
	ld l,$b0		; $6268
	bit 0,(hl)		; $626a
	jr z,_label_0c_232	; $626c
	ld l,$84		; $626e
	ld (hl),$0d		; $6270
	ret			; $6272
_label_0c_232:
	ld l,$84		; $6273
	inc (hl)		; $6275
	ld l,$a4		; $6276
	res 7,(hl)		; $6278
	ld l,$86		; $627a
	ld (hl),$78		; $627c
	ret			; $627e
	call _ecom_decCounter1		; $627f
	ret nz			; $6282
	ld l,e			; $6283
	ld (hl),$08		; $6284
	ld l,$94		; $6286
	xor a			; $6288
	ldi (hl),a		; $6289
	ld (hl),a		; $628a
	jp enemySetAnimation		; $628b
	ld a,$02		; $628e
	ld ($d005),a		; $6290
	ret			; $6293
	ld e,$8f		; $6294
	ld a,(de)		; $6296
	or a			; $6297
	ret z			; $6298
	cp $b8			; $6299
	jp c,_ecom_flickerVisibility		; $629b
	cp $bc			; $629e
	ret nc			; $62a0
	jp objectSetVisiblec1		; $62a1

enemyCode29:
	dec a			; $62a4
	ret z			; $62a5
	dec a			; $62a6
	ret z			; $62a7
	ld e,$84		; $62a8
	ld a,(de)		; $62aa
	rst_jumpTable			; $62ab
	add $62			; $62ac
.DB $dd				; $62ae
	ld h,d			; $62af
.DB $dd				; $62b0
	ld h,d			; $62b1
.DB $dd				; $62b2
	ld h,d			; $62b3
.DB $dd				; $62b4
	ld h,d			; $62b5
.DB $dd				; $62b6
	ld h,d			; $62b7
.DB $dd				; $62b8
	ld h,d			; $62b9
.DB $dd				; $62ba
	ld h,d			; $62bb
	sbc $62			; $62bc
	pop af			; $62be
	ld h,d			; $62bf
	ld c,$63		; $62c0
	dec h			; $62c2
	ld h,e			; $62c3
	inc l			; $62c4
	ld h,e			; $62c5
	call _ecom_setSpeedAndState8		; $62c6
	ld e,$82		; $62c9
	ld a,(de)		; $62cb
	or a			; $62cc
	ret z			; $62cd
	ld (hl),$0c		; $62ce
	ld l,$97		; $62d0
	ld h,(hl)		; $62d2
	ld l,$b0		; $62d3
	ld a,(hl)		; $62d5
	inc a			; $62d6
	call enemySetAnimation		; $62d7
	jp objectSetVisible83		; $62da
	ret			; $62dd
	ld h,d			; $62de
	ld l,$8d		; $62df
	ldh a,(<hEnemyTargetX)	; $62e1
	sub (hl)		; $62e3
	add $30			; $62e4
	cp $61			; $62e6
	ret nc			; $62e8
	ld l,$8b		; $62e9
	ld a,(hl)		; $62eb
	ld l,$b1		; $62ec
	ld (hl),a		; $62ee
	jr _label_0c_236		; $62ef
	call enemyAnimate		; $62f1
	call $637d		; $62f4
	jr z,_label_0c_233	; $62f7
	ld a,(hl)		; $62f9
	or a			; $62fa
	jr nz,_label_0c_234	; $62fb
	ld l,$b0		; $62fd
	cp (hl)			; $62ff
	ret z			; $6300
	ld (hl),a		; $6301
	call enemySetAnimation		; $6302
	jr _label_0c_235		; $6305
_label_0c_233:
	ld l,$84		; $6307
	inc (hl)		; $6309
	ld l,$a4		; $630a
	res 7,(hl)		; $630c
	call $6373		; $630e
	ret nz			; $6311
	call getRandomNumber_noPreserveVars		; $6312
	and $03			; $6315
	ld hl,$6379		; $6317
	rst_addAToHl			; $631a
	ld e,$86		; $631b
	ld a,(hl)		; $631d
	ld (de),a		; $631e
	call _ecom_incState		; $631f
	jp objectSetInvisible		; $6322
	call _ecom_decCounter1		; $6325
	ret nz			; $6328
	inc (hl)		; $6329
	jr _label_0c_236		; $632a
	call enemyAnimate		; $632c
	ld e,$a1		; $632f
	ld a,(de)		; $6331
	inc a			; $6332
	jp z,enemyDelete		; $6333
	dec a			; $6336
	jp nz,objectSetInvisible		; $6337
	jp _ecom_flickerVisibility		; $633a
_label_0c_234:
	call _ecom_decCounter1		; $633d
	ld a,(hl)		; $6340
	and $0f			; $6341
	ret nz			; $6343
_label_0c_235:
	ld b,$29		; $6344
	call _ecom_spawnUncountedEnemyWithSubid01		; $6346
	ret nz			; $6349
	call objectCopyPosition		; $634a
	ld l,$96		; $634d
	ld a,$80		; $634f
	ldi (hl),a		; $6351
	ld (hl),d		; $6352
	ret			; $6353
_label_0c_236:
	call $6373		; $6354
	ret nz			; $6357
	call objectSetVisible82		; $6358
	ld e,$b0		; $635b
	ld a,$02		; $635d
	ld (de),a		; $635f
	call enemySetAnimation		; $6360
	ld bc,$fbc0		; $6363
	call objectSetSpeedZ		; $6366
	ld l,$84		; $6369
	ld (hl),$09		; $636b
	ld l,$a4		; $636d
	set 7,(hl)		; $636f
	xor a			; $6371
	ret			; $6372
	ld bc,$0401		; $6373
	jp objectCreateInteraction		; $6376
	stop			; $6379
	ld d,b			; $637a
	ld d,b			; $637b
	ld d,b			; $637c
	ld h,d			; $637d
	ld l,$94		; $637e
	ld e,$8a		; $6380
	call add16BitRefs		; $6382
	ld b,a			; $6385
	ld e,$b1		; $6386
	ld a,(de)		; $6388
	cp b			; $6389
	jr c,_label_0c_237	; $638a
	dec l			; $638c
	ld a,$1c		; $638d
	add (hl)		; $638f
	ldi (hl),a		; $6390
	ld a,$00		; $6391
	adc (hl)		; $6393
	ld (hl),a		; $6394
	or d			; $6395
	ret			; $6396
_label_0c_237:
	ld l,$8b		; $6397
	ldd (hl),a		; $6399
	ld (hl),$00		; $639a
	xor a			; $639c
	ret			; $639d

enemyCode2a:
	dec a			; $639e
	ret z			; $639f
	dec a			; $63a0
	ret z			; $63a1
	call _ecom_getSubidAndCpStateTo08		; $63a2
	jr c,_label_0c_238	; $63a5
	ld a,b			; $63a7
	rst_jumpTable			; $63a8
	ret			; $63a9
	ld h,e			; $63aa
	jp z,$fd63		; $63ab
	ld h,e			; $63ae
	ld e,h			; $63af
	ld h,h			; $63b0
_label_0c_238:
	rst_jumpTable			; $63b1
	jp nz,$c863		; $63b2
	ld h,e			; $63b5
	ret z			; $63b6
	ld h,e			; $63b7
	ret z			; $63b8
	ld h,e			; $63b9
	ret z			; $63ba
	ld h,e			; $63bb
	ret z			; $63bc
	ld h,e			; $63bd
	ret z			; $63be
	ld h,e			; $63bf
	ret z			; $63c0
	ld h,e			; $63c1
	call _ecom_setSpeedAndState8		; $63c2
	jp objectSetVisible82		; $63c5
	ret			; $63c8
	ret			; $63c9
	ld a,(de)		; $63ca
	sub $08			; $63cb
	rst_jumpTable			; $63cd
	call nc,$e063		; $63ce
	ld h,e			; $63d1
	xor $63			; $63d2
	ld a,$09		; $63d4
	ld (de),a		; $63d6
	call $649f		; $63d7
	ld e,$90		; $63da
	ld a,$14		; $63dc
	ld (de),a		; $63de
	ret			; $63df
	call $64bf		; $63e0
	jp z,objectApplySpeed		; $63e3
	call _ecom_incState		; $63e6
	ld l,$86		; $63e9
	ld (hl),$10		; $63eb
	ret			; $63ed
	call _ecom_decCounter1		; $63ee
	ret nz			; $63f1
	ld l,e			; $63f2
	dec (hl)		; $63f3
	ld l,$89		; $63f4
	ld a,(hl)		; $63f6
	add $08			; $63f7
	and $18			; $63f9
	ld (hl),a		; $63fb
	ret			; $63fc
	ld a,(de)		; $63fd
	sub $08			; $63fe
	rst_jumpTable			; $6400
	rlca			; $6401
	ld h,h			; $6402
	rrca			; $6403
	ld h,h			; $6404
	cpl			; $6405
	ld h,h			; $6406
	ld h,d			; $6407
	ld l,e			; $6408
	inc (hl)		; $6409
	ld l,$86		; $640a
	ld (hl),$3c		; $640c
	ret			; $640e
	call $64fc		; $640f
	call $64bf		; $6412
	jp z,objectApplySpeed		; $6415
	call _ecom_incState		; $6418
	ld l,$8b		; $641b
	ld a,(hl)		; $641d
	add $02			; $641e
	and $f8			; $6420
	ldi (hl),a		; $6422
	inc l			; $6423
	ld a,(hl)		; $6424
	add $02			; $6425
	and $f8			; $6427
	ld (hl),a		; $6429
	ld l,$86		; $642a
	ld (hl),$10		; $642c
	ret			; $642e
	call _ecom_decCounter1		; $642f
	ret nz			; $6432
	ld e,$89		; $6433
	ld a,(de)		; $6435
	add $08			; $6436
	and $1f			; $6438
	ld (de),a		; $643a
	call $64bf		; $643b
	jr z,_label_0c_239	; $643e
	ld e,$89		; $6440
	ld a,(de)		; $6442
	xor $10			; $6443
	ld (de),a		; $6445
	call $64bf		; $6446
	jr z,_label_0c_239	; $6449
	ld e,$89		; $644b
	ld a,(de)		; $644d
	sub $08			; $644e
	and $1f			; $6450
	ld (de),a		; $6452
_label_0c_239:
	ld h,d			; $6453
	ld l,$84		; $6454
	dec (hl)		; $6456
	ld l,$86		; $6457
	ld (hl),$5a		; $6459
	ret			; $645b
	ld a,(de)		; $645c
	sub $08			; $645d
	rst_jumpTable			; $645f
	ld h,(hl)		; $6460
	ld h,h			; $6461
	rrca			; $6462
	ld h,h			; $6463
	ld (hl),d		; $6464
	ld h,h			; $6465
	ld h,d			; $6466
	ld l,e			; $6467
	inc (hl)		; $6468
	ld l,$89		; $6469
	ld (hl),$10		; $646b
	ld l,$86		; $646d
	ld (hl),$5a		; $646f
	ret			; $6471
	call _ecom_decCounter1		; $6472
	ret nz			; $6475
	ld e,$89		; $6476
	ld a,(de)		; $6478
	sub $08			; $6479
	and $1f			; $647b
	ld (de),a		; $647d
	call $64bf		; $647e
	jr z,_label_0c_240	; $6481
	ld e,$89		; $6483
	ld a,(de)		; $6485
	xor $10			; $6486
	ld (de),a		; $6488
	call $64bf		; $6489
	jr z,_label_0c_240	; $648c
	ld e,$89		; $648e
	ld a,(de)		; $6490
	add $08			; $6491
	and $1f			; $6493
	ld (de),a		; $6495
_label_0c_240:
	ld h,d			; $6496
	ld l,$84		; $6497
	dec (hl)		; $6499
	ld l,$86		; $649a
	ld (hl),$5a		; $649c
	ret			; $649e
	call $64bf		; $649f
	ld a,$08		; $64a2
	jr nz,_label_0c_241	; $64a4
	ld e,$89		; $64a6
	ld (de),a		; $64a8
	call $64bf		; $64a9
	ld a,$10		; $64ac
	jr nz,_label_0c_241	; $64ae
	ld e,$89		; $64b0
	ld (de),a		; $64b2
	call $64bf		; $64b3
	ld a,$18		; $64b6
	jr nz,_label_0c_241	; $64b8
	xor a			; $64ba
_label_0c_241:
	ld e,$89		; $64bb
	ld (de),a		; $64bd
	ret			; $64be
	ld e,$8b		; $64bf
	ld a,(de)		; $64c1
	ld b,a			; $64c2
	ld e,$8d		; $64c3
	ld a,(de)		; $64c5
	ld c,a			; $64c6
	ld e,$89		; $64c7
	ld a,(de)		; $64c9
	rrca			; $64ca
	ld hl,$64ec		; $64cb
	rst_addAToHl			; $64ce
	push de			; $64cf
	ld d,$ce		; $64d0
	call $64dc		; $64d2
	jr nz,_label_0c_242	; $64d5
	call $64dc		; $64d7
_label_0c_242:
	pop de			; $64da
	ret			; $64db
	ldi a,(hl)		; $64dc
	add b			; $64dd
	and $f0			; $64de
	ld e,a			; $64e0
	ldi a,(hl)		; $64e1
	add c			; $64e2
	swap a			; $64e3
	and $0f			; $64e5
	or e			; $64e7
	ld e,a			; $64e8
	ld a,(de)		; $64e9
	or a			; $64ea
	ret			; $64eb
	rst $28			; $64ec
	ld hl,sp-$11		; $64ed
	rlca			; $64ef
	ld hl,sp+$10		; $64f0
	rlca			; $64f2
	stop			; $64f3
	stop			; $64f4
	ld hl,sp+$10		; $64f5
	rlca			; $64f7
	ld hl,sp-$11		; $64f8
	rlca			; $64fa
	rst $28			; $64fb
	ld e,$86		; $64fc
	ld a,(de)		; $64fe
	or a			; $64ff
	ret z			; $6500
	ld a,(de)		; $6501
	dec a			; $6502
	ld (de),a		; $6503
	and $f0			; $6504
	swap a			; $6506
	ld hl,$6511		; $6508
	rst_addAToHl			; $650b
	ld e,$90		; $650c
	ld a,(hl)		; $650e
	ld (de),a		; $650f
	ret			; $6510
	ld h,h			; $6511
	ld d,b			; $6512
	inc a			; $6513
	jr z,_label_0c_244	; $6514
	dec b			; $6516

enemyCode2c:
	jr z,_label_0c_243	; $6517
	sub $03			; $6519
	ret c			; $651b
	jp z,enemyDie		; $651c
	dec a			; $651f
	jp nz,_ecom_updateKnockback		; $6520
_label_0c_243:
	call _ecom_getSubidAndCpStateTo08		; $6523
	jr nc,_label_0c_245	; $6526
	rst_jumpTable			; $6528
	ccf			; $6529
_label_0c_244:
	ld h,l			; $652a
	ld b,a			; $652b
	ld h,l			; $652c
	ld b,a			; $652d
	ld h,l			; $652e
	ld b,a			; $652f
	ld h,l			; $6530
	ld b,a			; $6531
	ld h,l			; $6532
	bit 0,h			; $6533
	ld b,a			; $6535
	ld h,l			; $6536
	ld b,a			; $6537
	ld h,l			; $6538
_label_0c_245:
	ld a,b			; $6539
	rst_jumpTable			; $653a
	ld c,b			; $653b
	ld h,l			; $653c
	adc d			; $653d
	ld h,l			; $653e
	ld a,$14		; $653f
	call _ecom_setSpeedAndState8		; $6541
	jp objectSetVisible82		; $6544
	ret			; $6547
	ld a,(de)		; $6548
	sub $08			; $6549
	rst_jumpTable			; $654b
	ld d,d			; $654c
	ld h,l			; $654d
	ld h,d			; $654e
	ld h,l			; $654f
	ld (hl),c		; $6550
	ld h,l			; $6551
	ld h,d			; $6552
	ld l,e			; $6553
	inc (hl)		; $6554
	ld l,$89		; $6555
	ld (hl),$18		; $6557
	ld l,$83		; $6559
	ld a,(hl)		; $655b
	add a			; $655c
	ld (hl),a		; $655d
	ld l,$86		; $655e
	ld (hl),a		; $6560
	ret			; $6561
	call _ecom_decCounter1		; $6562
	jr nz,_label_0c_246	; $6565
	ld (hl),$3c		; $6567
	ld l,e			; $6569
	inc (hl)		; $656a
_label_0c_246:
	call objectApplySpeed		; $656b
_label_0c_247:
	jp enemyAnimate		; $656e
	call _ecom_decCounter1		; $6571
	jr nz,_label_0c_247	; $6574
	ld e,$83		; $6576
	ld a,(de)		; $6578
	ld (hl),a		; $6579
	ld l,$84		; $657a
	dec (hl)		; $657c
	ld l,$89		; $657d
	ld a,(hl)		; $657f
	xor $10			; $6580
	ldd (hl),a		; $6582
	ld a,(hl)		; $6583
	xor $01			; $6584
	ld (hl),a		; $6586
	jp enemySetAnimation		; $6587
	ld a,(de)		; $658a
	sub $08			; $658b
	rst_jumpTable			; $658d
	sub h			; $658e
	ld h,l			; $658f
	ld h,d			; $6590
	ld h,l			; $6591
	ld (hl),c		; $6592
	ld h,l			; $6593
	ld h,d			; $6594
	ld l,e			; $6595
	inc (hl)		; $6596
	ld l,$89		; $6597
	ld (hl),$10		; $6599
	ld l,$83		; $659b
	ld a,(hl)		; $659d
	add a			; $659e
	ld (hl),a		; $659f
	ld l,$86		; $65a0
	ld (hl),a		; $65a2
	ret			; $65a3

enemyCode2d:
	jr z,_label_0c_248	; $65a4
	sub $03			; $65a6
	ret c			; $65a8
	jp z,enemyDie_withoutItemDrop		; $65a9
	ld e,$aa		; $65ac
	ld a,(de)		; $65ae
	cp $9a			; $65af
	jp z,enemyDie_uncounted_withoutItemDrop		; $65b1
_label_0c_248:
	ld e,$84		; $65b4
	ld a,(de)		; $65b6
	rst_jumpTable			; $65b7
	call nc,$e665		; $65b8
	ld h,l			; $65bb
	and $65			; $65bc
	and $65			; $65be
	and $65			; $65c0
	and $65			; $65c2
	and $65			; $65c4
	and $65			; $65c6
	rst $20			; $65c8
	ld h,l			; $65c9
	or $65			; $65ca
	ld de,$3366		; $65cc
	ld h,(hl)		; $65cf
	ld c,e			; $65d0
	ld h,(hl)		; $65d1
	ld e,e			; $65d2
	ld h,(hl)		; $65d3
	call _ecom_setSpeedAndState8		; $65d4
	ld l,$bf		; $65d7
	set 5,(hl)		; $65d9
	ld l,$86		; $65db
	ld (hl),$3c		; $65dd
	ld l,$8b		; $65df
	ld a,(hl)		; $65e1
	ld l,$b0		; $65e2
	ld (hl),a		; $65e4
	ret			; $65e5
	ret			; $65e6
	call _ecom_decCounter1		; $65e7
	jp nz,_ecom_flickerVisibility		; $65ea
	ld l,e			; $65ed
	inc (hl)		; $65ee
	ld l,$a4		; $65ef
	set 7,(hl)		; $65f1
	jp objectSetVisible82		; $65f3
	call enemyAnimate		; $65f6
	ld e,$a1		; $65f9
	ld a,(de)		; $65fb
	or a			; $65fc
	ret z			; $65fd
	ld b,a			; $65fe
	call $6668		; $65ff
	ld a,b			; $6602
	cp $0f			; $6603
	ret nz			; $6605
	ld h,d			; $6606
	ld l,$84		; $6607
	inc (hl)		; $6609
	ld l,$86		; $660a
	ld (hl),$96		; $660c
	inc l			; $660e
	ld (hl),$b4		; $660f
	call $6690		; $6611
	jr nz,_label_0c_249	; $6614
	ld l,e			; $6616
	inc (hl)		; $6617
	ld a,$01		; $6618
	jp enemySetAnimation		; $661a
_label_0c_249:
	call _ecom_decCounter1		; $661d
	jr nz,_label_0c_250	; $6620
	ld (hl),$96		; $6622
	call getRandomNumber_noPreserveVars		; $6624
	cp $b4			; $6627
	jr nc,_label_0c_250	; $6629
	ld b,$31		; $662b
	call _ecom_spawnProjectile		; $662d
_label_0c_250:
	jp enemyAnimate		; $6630
	call enemyAnimate		; $6633
	ld e,$a1		; $6636
	ld a,(de)		; $6638
	or a			; $6639
	ret z			; $663a
	bit 7,a			; $663b
	jr z,_label_0c_251	; $663d
	call _ecom_incState		; $663f
	ld l,$a4		; $6642
	res 7,(hl)		; $6644
	ld l,$86		; $6646
	ld (hl),$3c		; $6648
	ret			; $664a
	call _ecom_decCounter1		; $664b
	jp nz,_ecom_flickerVisibility		; $664e
	ld l,$84		; $6651
	inc (hl)		; $6653
	ld l,$86		; $6654
	ld (hl),$b4		; $6656
	jp objectSetInvisible		; $6658
	call _ecom_decCounter1		; $665b
	ret nz			; $665e
	ld (hl),$3c		; $665f
	ld l,e			; $6661
	ld (hl),$08		; $6662
	xor a			; $6664
	jp enemySetAnimation		; $6665
_label_0c_251:
	sub $03			; $6668
	ld hl,$6681		; $666a
	rst_addAToHl			; $666d
	ld e,$a6		; $666e
	ldi a,(hl)		; $6670
	ld (de),a		; $6671
	inc e			; $6672
	ldi a,(hl)		; $6673
	ld (de),a		; $6674
	ld e,$b0		; $6675
	ld a,(de)		; $6677
	add (hl)		; $6678
	ld e,$8b		; $6679
	ld (de),a		; $667b
	ld e,$a1		; $667c
	xor a			; $667e
	ld (de),a		; $667f
	ret			; $6680
	ld b,$04		; $6681
	nop			; $6683
	ld ($f904),sp		; $6684
	dec bc			; $6687
	inc b			; $6688
	rst $30			; $6689
	rrca			; $668a
	inc b			; $668b
.DB $f4				; $668c
	ld (de),a		; $668d
	inc b			; $668e
	ld a,($ff00+c)		; $668f
	ld a,(wFrameCounter)		; $6690
	and $03			; $6693
	ret nz			; $6695
	jp _ecom_decCounter2		; $6696

enemyCode2e:
	jr z,_label_0c_252	; $6699
	sub $03			; $669b
	ret c			; $669d
_label_0c_252:
	ld e,$84		; $669e
	ld a,(de)		; $66a0
	rst_jumpTable			; $66a1
	cp h			; $66a2
	ld h,(hl)		; $66a3
	call $cd66		; $66a4
	ld h,(hl)		; $66a7
	call $cd66		; $66a8
	ld h,(hl)		; $66ab
	call $cd66		; $66ac
	ld h,(hl)		; $66af
	call $ce66		; $66b0
	ld h,(hl)		; $66b3
	sub $66			; $66b4
.DB $ec				; $66b6
	ld h,(hl)		; $66b7
	ld b,$67		; $66b8
	dec c			; $66ba
	ld h,a			; $66bb
	ld e,$8b		; $66bc
	ld a,(de)		; $66be
	ld e,$b0		; $66bf
	ld (de),a		; $66c1
	ld h,d			; $66c2
	ld l,$86		; $66c3
	inc (hl)		; $66c5
	ld l,$89		; $66c6
	ld (hl),$10		; $66c8
	jp _ecom_setSpeedAndState8AndVisible		; $66ca
	ret			; $66cd
	call _ecom_decCounter1		; $66ce
	ret nz			; $66d1
	ld l,e			; $66d2
	inc (hl)		; $66d3
	xor a			; $66d4
	ret			; $66d5
	ld h,d			; $66d6
	ld l,$8d		; $66d7
	ldh a,(<hEnemyTargetX)	; $66d9
	sub (hl)		; $66db
	add $0a			; $66dc
	cp $15			; $66de
	ret nc			; $66e0
	ld l,e			; $66e1
	inc (hl)		; $66e2
	ld l,$94		; $66e3
	xor a			; $66e5
	ldi (hl),a		; $66e6
	ld (hl),a		; $66e7
	inc a			; $66e8
	jp enemySetAnimation		; $66e9
	ld a,$40		; $66ec
	call objectUpdateSpeedZ_sidescroll		; $66ee
	jr c,_label_0c_253	; $66f1
	ld a,(hl)		; $66f3
	cp $03			; $66f4
	ret c			; $66f6
	ld (hl),$02		; $66f7
	ret			; $66f9
_label_0c_253:
	call _ecom_incState		; $66fa
	ld l,$86		; $66fd
	ld (hl),$2d		; $66ff
	ld a,$50		; $6701
	jp playSound		; $6703
	call $66ce		; $6706
	ret nz			; $6709
	jp enemySetAnimation		; $670a
	ld h,d			; $670d
	ld l,$8a		; $670e
	ld a,(hl)		; $6710
	sub $80			; $6711
	ldi (hl),a		; $6713
	ld a,(hl)		; $6714
	sbc $00			; $6715
	ld (hl),a		; $6717
	ld e,$b0		; $6718
	ld a,(de)		; $671a
	cp (hl)			; $671b
	ret nz			; $671c
	ld l,$86		; $671d
	ld (hl),$18		; $671f
	ld l,$84		; $6721
	ld (hl),$08		; $6723
	ret			; $6725

enemyCode2f:
	jr z,_label_0c_254	; $6726
	sub $03			; $6728
	ret c			; $672a
_label_0c_254:
	call $6731		; $672b
	jp $67e5		; $672e
	ld e,$84		; $6731
	ld a,(de)		; $6733
	rst_jumpTable			; $6734
	ld c,l			; $6735
	ld h,a			; $6736
	ld h,d			; $6737
	ld h,a			; $6738
	ld h,d			; $6739
	ld h,a			; $673a
	ld h,d			; $673b
	ld h,a			; $673c
	ld h,d			; $673d
	ld h,a			; $673e
	ld h,d			; $673f
	ld h,a			; $6740
	ld h,d			; $6741
	ld h,a			; $6742
	ld h,d			; $6743
	ld h,a			; $6744
	ld h,e			; $6745
	ld h,a			; $6746
	adc a			; $6747
	ld h,a			; $6748
	or b			; $6749
	ld h,a			; $674a
	rst $8			; $674b
	ld h,a			; $674c
	call _ecom_setSpeedAndState8		; $674d
	ld l,$b0		; $6750
	ld e,$8b		; $6752
	ld a,(de)		; $6754
	ld (hl),a		; $6755
	ld l,$89		; $6756
	ld (hl),$10		; $6758
	ld a,$04		; $675a
	call enemySetAnimation		; $675c
	jp objectSetVisible82		; $675f
	ret			; $6762
	ld h,d			; $6763
	ld l,$8d		; $6764
	ld a,($d00d)		; $6766
	sub (hl)		; $6769
	add $14			; $676a
	cp $29			; $676c
	jr c,_label_0c_255	; $676e
	call objectGetAngleTowardLink		; $6770
	add $02			; $6773
	and $1c			; $6775
	ld h,d			; $6777
	ld l,$89		; $6778
	cp (hl)			; $677a
	ret z			; $677b
	ld (hl),a		; $677c
	rrca			; $677d
	rrca			; $677e
	jp enemySetAnimation		; $677f
_label_0c_255:
	call _ecom_incState		; $6782
	ld l,$94		; $6785
	xor a			; $6787
	ldi (hl),a		; $6788
	ld (hl),a		; $6789
	ld a,$08		; $678a
	jp enemySetAnimation		; $678c
	ld b,$10		; $678f
	ld a,$30		; $6791
	call objectUpdateSpeedZ_sidescroll_givenYOffset		; $6793
	jr c,_label_0c_256	; $6796
	ld a,(hl)		; $6798
	cp $03			; $6799
	ret c			; $679b
	ld (hl),$02		; $679c
	ret			; $679e
_label_0c_256:
	call _ecom_incState		; $679f
	ld l,$87		; $67a2
	ld (hl),$3c		; $67a4
	ld a,$2d		; $67a6
	ld ($cd18),a		; $67a8
	ld a,$70		; $67ab
	jp playSound		; $67ad
	call _ecom_decCounter2		; $67b0
	ret nz			; $67b3
	ld e,$8b		; $67b4
	ld l,$b0		; $67b6
	ld a,(de)		; $67b8
	cp (hl)			; $67b9
	jr z,_label_0c_257	; $67ba
	ld l,$8a		; $67bc
	ld a,(hl)		; $67be
	sub $80			; $67bf
	ldi (hl),a		; $67c1
	ld a,(hl)		; $67c2
	sbc $00			; $67c3
	ld (hl),a		; $67c5
	ret			; $67c6
_label_0c_257:
	ld l,$84		; $67c7
	inc (hl)		; $67c9
	ld l,$86		; $67ca
	ld (hl),$20		; $67cc
	ret			; $67ce
	call _ecom_decCounter1		; $67cf
	ret nz			; $67d2
	ld l,e			; $67d3
	ld (hl),$08		; $67d4
	jp $67e5		; $67d6
	ld e,$8b		; $67d9
	ld a,(de)		; $67db
	add b			; $67dc
	ld b,a			; $67dd
	ld e,$8d		; $67de
	ld a,(de)		; $67e0
	ld c,a			; $67e1
	jp getTileCollisionsAtPosition		; $67e2
	ld h,d			; $67e5
	ld l,$8d		; $67e6
	ld a,($d00d)		; $67e8
	sub (hl)		; $67eb
	add $13			; $67ec
	cp $27			; $67ee
	jr nc,_label_0c_258	; $67f0
	ld a,($d026)		; $67f2
	ld b,a			; $67f5
	ld l,$a6		; $67f6
	ld e,$8b		; $67f8
	ld a,(de)		; $67fa
	sub (hl)		; $67fb
	sub b			; $67fc
	ld c,a			; $67fd
	ld a,($d00b)		; $67fe
	sub c			; $6801
	add $03			; $6802
	cp $07			; $6804
	jr nc,_label_0c_258	; $6806
	ld a,c			; $6808
	sub $03			; $6809
	ld ($d00b),a		; $680b
	ld a,d			; $680e
	ld ($ccb0),a		; $680f
	ret			; $6812
_label_0c_258:
	ld a,($ccb0)		; $6813
	sub d			; $6816
	ret nz			; $6817
	ld ($ccb0),a		; $6818
	ret			; $681b

enemyCode0f:
	dec a			; $681c
	ret z			; $681d
	dec a			; $681e
	ret z			; $681f
	call _ecom_getSubidAndCpStateTo08		; $6820
	jr nc,_label_0c_259	; $6823
	rst_jumpTable			; $6825
	ld a,$68		; $6826
	ld c,(hl)		; $6828
	ld l,b			; $6829
	halt			; $682a
	ld l,b			; $682b
	halt			; $682c
	ld l,b			; $682d
	halt			; $682e
	ld l,b			; $682f
	halt			; $6830
	ld l,b			; $6831
	halt			; $6832
	ld l,b			; $6833
	halt			; $6834
	ld l,b			; $6835
_label_0c_259:
	ld a,b			; $6836
	sub $08			; $6837
	rst_jumpTable			; $6839
	ld (hl),a		; $683a
	ld l,b			; $683b
	sbc h			; $683c
	ld l,b			; $683d
	ld e,$be		; $683e
	ld a,$08		; $6840
	ld (de),a		; $6842
	ld a,b			; $6843
	sub $08			; $6844
	jp nc,$68d6		; $6846
	ld e,$84		; $6849
	ld a,$01		; $684b
	ld (de),a		; $684d
	ld a,b			; $684e
	ld hl,$686e		; $684f
	rst_addAToHl			; $6852
	ld b,(hl)		; $6853
	call checkBEnemySlotsAvailable		; $6854
	ret nz			; $6857
	call $68f2		; $6858
	ld b,$0f		; $685b
	call _ecom_spawnUncountedEnemyWithSubid01		; $685d
	ld (hl),$08		; $6860
	call $68c8		; $6862
	call $68fa		; $6865
	call $6992		; $6868
	jp enemyDelete		; $686b
	inc bc			; $686e
	inc bc			; $686f
	inc bc			; $6870
	inc b			; $6871
	inc b			; $6872
	inc b			; $6873
	dec b			; $6874
	dec b			; $6875
	ret			; $6876
	ld a,(de)		; $6877
	sub $08			; $6878
	rst_jumpTable			; $687a
	ld a,a			; $687b
	ld l,b			; $687c
	sub d			; $687d
	ld l,b			; $687e
	call $699d		; $687f
	ld l,$84		; $6882
	inc (hl)		; $6884
	call $69b4		; $6885
	ld e,$b1		; $6888
	ld a,(de)		; $688a
	ld e,$99		; $688b
	ld (de),a		; $688d
	dec e			; $688e
	ld a,$80		; $688f
	ld (de),a		; $6891
	call $69c9		; $6892
	call $69d2		; $6895
	ret z			; $6898
	jp $69fd		; $6899
	ld a,(de)		; $689c
	sub $08			; $689d
	rst_jumpTable			; $689f
	and h			; $68a0
	ld l,b			; $68a1
	or e			; $68a2
	ld l,b			; $68a3
	ld h,d			; $68a4
	ld l,e			; $68a5
	inc (hl)		; $68a6
	ld l,$89		; $68a7
	ld (hl),$08		; $68a9
	ld l,$b0		; $68ab
	ld e,$86		; $68ad
	ld a,(hl)		; $68af
	ld (de),a		; $68b0
	jr _label_0c_261		; $68b1
	call _ecom_decCounter1		; $68b3
	jr nz,_label_0c_260	; $68b6
	ld e,$b0		; $68b8
	ld a,(de)		; $68ba
	ld (hl),a		; $68bb
	ld l,$89		; $68bc
	ld a,(hl)		; $68be
	xor $10			; $68bf
	ld (hl),a		; $68c1
_label_0c_260:
	call objectApplySpeed		; $68c2
_label_0c_261:
	jp enemyAnimate		; $68c5
	ld e,$b0		; $68c8
	ld l,e			; $68ca
	ld a,(de)		; $68cb
	ld (hl),a		; $68cc
	ld e,$82		; $68cd
	ld l,$83		; $68cf
	ld a,(de)		; $68d1
	ld (hl),a		; $68d2
	jp objectCopyPosition		; $68d3
	jr z,_label_0c_262	; $68d6
	ld e,$b1		; $68d8
	ld a,(de)		; $68da
	ld c,a			; $68db
	ld hl,$68ed		; $68dc
	rst_addAToHl			; $68df
	ld e,$a6		; $68e0
	ld a,(hl)		; $68e2
	ld (de),a		; $68e3
	ld a,c			; $68e4
	call enemySetAnimation		; $68e5
	ld a,$1e		; $68e8
_label_0c_262:
	jp _ecom_setSpeedAndState8		; $68ea
	ld b,$06		; $68ed
	ld c,$16		; $68ef
	add hl,de		; $68f1
	ld h,d			; $68f2
	ld l,$83		; $68f3
	ld e,$b0		; $68f5
	ld a,(hl)		; $68f7
	ld (de),a		; $68f8
	ret			; $68f9
	push hl			; $68fa
	ld c,h			; $68fb
	ld e,$82		; $68fc
	ld a,(de)		; $68fe
	ld hl,$694c		; $68ff
	rst_addDoubleIndex			; $6902
	ldi a,(hl)		; $6903
	ld h,(hl)		; $6904
	ld l,a			; $6905
	ld e,$b0		; $6906
_label_0c_263:
	push hl			; $6908
	inc e			; $6909
	push de			; $690a
	call $6925		; $690b
	push bc			; $690e
	ld b,$0f		; $690f
	call _ecom_spawnEnemyWithSubid01		; $6911
	ld (hl),$09		; $6914
	pop bc			; $6916
	ld a,e			; $6917
	pop de			; $6918
	call $692f		; $6919
	pop hl			; $691c
	inc hl			; $691d
	inc hl			; $691e
	ld a,(hl)		; $691f
	inc a			; $6920
	jr nz,_label_0c_263	; $6921
	pop hl			; $6923
	ret			; $6924
	ld e,$8b		; $6925
	ld a,(de)		; $6927
	add (hl)		; $6928
	ld b,a			; $6929
	ld e,c			; $692a
	inc hl			; $692b
	ld c,(hl)		; $692c
	inc hl			; $692d
	ret			; $692e
	push de			; $692f
	ld l,$97		; $6930
	ldd (hl),a		; $6932
	ld (hl),$80		; $6933
	ld a,h			; $6935
	ld (de),a		; $6936
	ld l,$8d		; $6937
	ld e,l			; $6939
	ld a,(de)		; $693a
	ldd (hl),a		; $693b
	dec l			; $693c
	ld (hl),b		; $693d
	ld d,h			; $693e
	ld e,l			; $693f
	ld a,c			; $6940
	ld e,$b1		; $6941
	ld (de),a		; $6943
	call enemySetAnimation		; $6944
	call objectSetVisible82		; $6947
	pop de			; $694a
	ret			; $694b
	ld e,h			; $694c
	ld l,c			; $694d
	ld h,c			; $694e
	ld l,c			; $694f
	ld h,(hl)		; $6950
	ld l,c			; $6951
	ld l,e			; $6952
	ld l,c			; $6953
	ld (hl),d		; $6954
	ld l,c			; $6955
	ld a,c			; $6956
	ld l,c			; $6957
	add b			; $6958
	ld l,c			; $6959
	adc c			; $695a
	ld l,c			; $695b
	ld hl,sp+$00		; $695c
	ld ($ff01),sp		; $695e
	ld hl,sp+$02		; $6961
	stop			; $6963
	ld bc,$f8ff		; $6964
	inc bc			; $6967
	jr _label_0c_264		; $6968
	rst $38			; $696a
_label_0c_264:
	ld ($ff00+$00),a	; $696b
	nop			; $696d
	inc b			; $696e
	jr nz,_label_0c_265	; $696f
	rst $38			; $6971
_label_0c_265:
	ld ($ff00+$02),a	; $6972
	ld ($2804),sp		; $6974
	ld bc,$e0ff		; $6977
	inc bc			; $697a
	stop			; $697b
	inc b			; $697c
	jr nc,_label_0c_266	; $697d
	rst $38			; $697f
_label_0c_266:
	ret z			; $6980
	nop			; $6981
	add sp,$04		; $6982
	jr _label_0c_268		; $6984
	jr c,_label_0c_267	; $6986
	rst $38			; $6988
_label_0c_267:
	ret z			; $6989
_label_0c_268:
	ld (bc),a		; $698a
	ld a,($ff00+$04)	; $698b
	jr nz,_label_0c_269	; $698d
	ld b,b			; $698f
	ld bc,$06ff		; $6990
_label_0c_269:
	inc b			; $6993
	ld l,$b1		; $6994
_label_0c_270:
	ld e,l			; $6996
	ld a,(de)		; $6997
	ldi (hl),a		; $6998
	dec b			; $6999
	jr nz,_label_0c_270	; $699a
	ret			; $699c
	ld h,d			; $699d
	ld e,$b0		; $699e
	ld l,$b1		; $69a0
_label_0c_271:
	ldi a,(hl)		; $69a2
	ld b,a			; $69a3
	ld c,$81		; $69a4
	ld a,(bc)		; $69a6
	cp $0f			; $69a7
	jr nz,_label_0c_272	; $69a9
	ld c,e			; $69ab
	ld a,(de)		; $69ac
	ld (bc),a		; $69ad
_label_0c_272:
	ld a,$b5		; $69ae
	cp l			; $69b0
	jr nz,_label_0c_271	; $69b1
	ret			; $69b3
	ld e,$83		; $69b4
	ld a,(de)		; $69b6
	ld hl,$69c1		; $69b7
	rst_addAToHl			; $69ba
	ld e,$8b		; $69bb
	ld a,(de)		; $69bd
	add (hl)		; $69be
	ld (de),a		; $69bf
	ret			; $69c0
	ld hl,sp-$10		; $69c1
	add sp,-$20		; $69c3
	ret c			; $69c5
	ret nc			; $69c6
	ret z			; $69c7
	ret nz			; $69c8
	ld a,$0d		; $69c9
	call objectGetRelatedObject2Var		; $69cb
	ld e,l			; $69ce
	ld a,(hl)		; $69cf
	ld (de),a		; $69d0
	ret			; $69d1
	ld a,$09		; $69d2
	call objectGetRelatedObject2Var		; $69d4
	ld c,$f7		; $69d7
	bit 4,(hl)		; $69d9
	jr nz,_label_0c_273	; $69db
	ld c,$08		; $69dd
_label_0c_273:
	ld e,$8d		; $69df
	ld a,(de)		; $69e1
	add c			; $69e2
	ld c,a			; $69e3
	ld e,$8b		; $69e4
	ld a,(de)		; $69e6
	ld b,a			; $69e7
	ld e,$83		; $69e8
	ld a,(de)		; $69ea
	add $02			; $69eb
	ld e,a			; $69ed
_label_0c_274:
	call getTileCollisionsAtPosition		; $69ee
	dec a			; $69f1
	cp $0f			; $69f2
	ret c			; $69f4
	ld a,b			; $69f5
	add $10			; $69f6
	ld b,a			; $69f8
	dec e			; $69f9
	jr nz,_label_0c_274	; $69fa
	ret			; $69fc
	ld h,d			; $69fd
	ld l,$b1		; $69fe
_label_0c_275:
	ldi a,(hl)		; $6a00
	ld b,a			; $6a01
	ld c,$81		; $6a02
	ld a,(bc)		; $6a04
	cp $0f			; $6a05
	jr nz,_label_0c_276	; $6a07
	ld c,$86		; $6a09
	ld a,$01		; $6a0b
	ld (bc),a		; $6a0d
_label_0c_276:
	ld a,$b5		; $6a0e
	cp l			; $6a10
	jr nz,_label_0c_275	; $6a11
	ret			; $6a13

enemyCode11:
	jr z,_label_0c_278	; $6a14
	sub $03			; $6a16
	ret c			; $6a18
	jr nz,_label_0c_277	; $6a19
	ld e,$83		; $6a1b
	ld a,(de)		; $6a1d
	cp $03			; $6a1e
	jp nz,$6ba8		; $6a20
	call _ecom_killRelatedObj1		; $6a23
	ld l,$b3		; $6a26
	ld (hl),$00		; $6a28
	ld l,$b1		; $6a2a
	push hl			; $6a2c
	ld h,(hl)		; $6a2d
	call _ecom_killObjectH		; $6a2e
	pop hl			; $6a31
	inc l			; $6a32
	ld h,(hl)		; $6a33
	call _ecom_killObjectH		; $6a34
	jp enemyDie		; $6a37
_label_0c_277:
	ld e,$aa		; $6a3a
	ld a,(de)		; $6a3c
	cp $9a			; $6a3d
	call z,$6bfe		; $6a3f
	call $6c3e		; $6a42
	ld e,$a4		; $6a45
	ld a,(de)		; $6a47
	rlca			; $6a48
	ret nc			; $6a49
_label_0c_278:
	call _ecom_getSubidAndCpStateTo08		; $6a4a
	jr nc,_label_0c_279	; $6a4d
	rst_jumpTable			; $6a4f
	ld a,h			; $6a50
	ld l,d			; $6a51
	inc b			; $6a52
	ld l,e			; $6a53
	inc b			; $6a54
	ld l,e			; $6a55
	inc b			; $6a56
	ld l,e			; $6a57
	inc b			; $6a58
	ld l,e			; $6a59
	inc b			; $6a5a
	ld l,e			; $6a5b
	inc b			; $6a5c
	ld l,e			; $6a5d
	inc b			; $6a5e
	ld l,e			; $6a5f
_label_0c_279:
	ld e,$83		; $6a60
	ld a,(de)		; $6a62
	or a			; $6a63
	call z,_ecom_decCounter1		; $6a64
	ld a,$33		; $6a67
	call objectGetRelatedObject1Var		; $6a69
	ld a,(hl)		; $6a6c
	or a			; $6a6d
	ret z			; $6a6e
	dec b			; $6a6f
	ld a,b			; $6a70
	rst_jumpTable			; $6a71
	dec b			; $6a72
	ld l,e			; $6a73
	ld l,$6b		; $6a74
	dec (hl)		; $6a76
	ld l,e			; $6a77
	inc a			; $6a78
	ld l,e			; $6a79
	inc b			; $6a7a
	ld l,e			; $6a7b
	ld a,b			; $6a7c
	or a			; $6a7d
	jr nz,_label_0c_281	; $6a7e
	ld b,$04		; $6a80
	call checkBEnemySlotsAvailable		; $6a82
	ret nz			; $6a85
	ld b,$11		; $6a86
	call _ecom_spawnUncountedEnemyWithSubid01		; $6a88
	ld (hl),$05		; $6a8b
	ld l,$96		; $6a8d
	ld a,$80		; $6a8f
	ldi (hl),a		; $6a91
	ld (hl),h		; $6a92
	call objectCopyPosition		; $6a93
	ld l,$b0		; $6a96
	ld (hl),h		; $6a98
	ld c,h			; $6a99
	ld e,$03		; $6a9a
	inc l			; $6a9c
_label_0c_280:
	push hl			; $6a9d
	call _ecom_spawnUncountedEnemyWithSubid01		; $6a9e
	ld a,$04		; $6aa1
	sub e			; $6aa3
	ld (hl),a		; $6aa4
	inc l			; $6aa5
	ld (hl),a		; $6aa6
	ld l,$96		; $6aa7
	ld a,$80		; $6aa9
	ldi (hl),a		; $6aab
	ld (hl),c		; $6aac
	push de			; $6aad
	call objectCopyPosition		; $6aae
	pop de			; $6ab1
	ld a,h			; $6ab2
	pop hl			; $6ab3
	ldi (hl),a		; $6ab4
	dec e			; $6ab5
	jr nz,_label_0c_280	; $6ab6
	ld h,a			; $6ab8
	ld l,$80		; $6ab9
	ld e,l			; $6abb
	ld a,(de)		; $6abc
	ld (hl),a		; $6abd
	jp enemyDelete		; $6abe
_label_0c_281:
	cp $03			; $6ac1
	ld a,$01		; $6ac3
	call nz,enemySetAnimation		; $6ac5
	ld a,$0f		; $6ac8
	call _ecom_setSpeedAndState8		; $6aca
	ld l,$bf		; $6acd
	set 5,(hl)		; $6acf
	ld l,$82		; $6ad1
	ld a,(hl)		; $6ad3
	cp $05			; $6ad4
	jr z,_label_0c_284	; $6ad6
	ld b,a			; $6ad8
	ld a,$30		; $6ad9
	call objectGetRelatedObject1Var		; $6adb
	ld e,l			; $6ade
	ldi a,(hl)		; $6adf
	ld (de),a		; $6ae0
	inc e			; $6ae1
	ldi a,(hl)		; $6ae2
	ld (de),a		; $6ae3
	inc e			; $6ae4
	ldi a,(hl)		; $6ae5
	ld (de),a		; $6ae6
	inc e			; $6ae7
	ld a,(hl)		; $6ae8
	ld (de),a		; $6ae9
	dec b			; $6aea
	jr z,_label_0c_283	; $6aeb
	dec b			; $6aed
	ld a,$f3		; $6aee
	jr z,_label_0c_282	; $6af0
	add a			; $6af2
_label_0c_282:
	ld e,$8f		; $6af3
	ld (de),a		; $6af5
_label_0c_283:
	jp objectSetVisible82		; $6af6
_label_0c_284:
	ld l,$a4		; $6af9
	res 7,(hl)		; $6afb
	call getRandomNumber_noPreserveVars		; $6afd
	ld e,$86		; $6b00
	ld (de),a		; $6b02
	ret			; $6b03
	ret			; $6b04
	ld e,$8f		; $6b05
	ld a,(de)		; $6b07
	or a			; $6b08
	jr z,_label_0c_285	; $6b09
	ld c,$0e		; $6b0b
	call objectUpdateSpeedZ_paramC		; $6b0d
	jp nz,objectSetVisiblec2		; $6b10
	ld l,$94		; $6b13
	xor a			; $6b15
	ldi (hl),a		; $6b16
	ld (hl),a		; $6b17
_label_0c_285:
	ld a,$10		; $6b18
	call objectGetRelatedObject1Var		; $6b1a
	ld e,l			; $6b1d
	ld a,(hl)		; $6b1e
	ld (de),a		; $6b1f
	ld l,$86		; $6b20
	ld a,(hl)		; $6b22
	and $3f			; $6b23
	call z,_ecom_setRandomAngle		; $6b25
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6b28
	jp objectSetPriorityRelativeToLink		; $6b2b
	ld b,$f3		; $6b2e
	call $6b8e		; $6b30
	jr _label_0c_286		; $6b33
	ld b,$e6		; $6b35
	call $6b8e		; $6b37
	jr _label_0c_286		; $6b3a
	ld b,$d9		; $6b3c
	call $6b8e		; $6b3e
_label_0c_286:
	ld a,$06		; $6b41
	call objectGetRelatedObject1Var		; $6b43
	ld a,(hl)		; $6b46
	and $1c			; $6b47
	rrca			; $6b49
	rrca			; $6b4a
	ld b,a			; $6b4b
	ld e,$82		; $6b4c
	ld a,(de)		; $6b4e
	sub $02			; $6b4f
	swap a			; $6b51
	rrca			; $6b53
	add b			; $6b54
	ld hl,$6b6a		; $6b55
	rst_addAToHl			; $6b58
	ld b,(hl)		; $6b59
	call $6b82		; $6b5a
	ld l,$8b		; $6b5d
	ld e,l			; $6b5f
	ldi a,(hl)		; $6b60
	ld (de),a		; $6b61
	inc l			; $6b62
	ld e,l			; $6b63
	ld a,(hl)		; $6b64
	add b			; $6b65
	ld (de),a		; $6b66
	jp objectSetPriorityRelativeToLink		; $6b67
	rst $38			; $6b6a
	rst $38			; $6b6b
	nop			; $6b6c
	nop			; $6b6d
	ld bc,$0001		; $6b6e
	nop			; $6b71
	ld bc,$0102		; $6b72
	nop			; $6b75
	rst $38			; $6b76
	cp $ff			; $6b77
	nop			; $6b79
	rst $38			; $6b7a
	cp $ff			; $6b7b
	nop			; $6b7d
	ld bc,$0102		; $6b7e
	nop			; $6b81
	ld e,$af		; $6b82
	ld l,$82		; $6b84
_label_0c_287:
	inc e			; $6b86
	ld a,(de)		; $6b87
	ld h,a			; $6b88
	ld a,(hl)		; $6b89
	dec a			; $6b8a
	jr nz,_label_0c_287	; $6b8b
	ret			; $6b8d
	ld h,d			; $6b8e
	ld l,$8f		; $6b8f
	ld a,(hl)		; $6b91
	cp b			; $6b92
	ret z			; $6b93
	or a			; $6b94
	jr z,_label_0c_288	; $6b95
	ld c,$0e		; $6b97
	call objectUpdateSpeedZ_paramC		; $6b99
	ld l,$8f		; $6b9c
	ld a,(hl)		; $6b9e
	cp b			; $6b9f
	ret c			; $6ba0
_label_0c_288:
	ld (hl),b		; $6ba1
	ld l,$94		; $6ba2
	xor a			; $6ba4
	ldi (hl),a		; $6ba5
	ld (hl),a		; $6ba6
	ret			; $6ba7
	ld a,$33		; $6ba8
	call objectGetRelatedObject1Var		; $6baa
	ld a,(hl)		; $6bad
	or a			; $6bae
	jr nz,_label_0c_289	; $6baf
	ld e,$82		; $6bb1
	ld a,(de)		; $6bb3
	cp $05			; $6bb4
	jp nz,enemyDie_uncounted_withoutItemDrop		; $6bb6
	jp enemyDelete		; $6bb9
_label_0c_289:
	ld e,$83		; $6bbc
	ld a,(de)		; $6bbe
	add $b1			; $6bbf
	ld l,a			; $6bc1
	ld h,d			; $6bc2
	ld c,$82		; $6bc3
	sub $b3			; $6bc5
	jr z,_label_0c_290	; $6bc7
	inc a			; $6bc9
	call nz,$6bf5		; $6bca
	call $6bf5		; $6bcd
_label_0c_290:
	call $6bf5		; $6bd0
	ld l,$a4		; $6bd3
	res 7,(hl)		; $6bd5
	ld l,$a9		; $6bd7
	ld (hl),$05		; $6bd9
	ld l,$82		; $6bdb
	ld (hl),$05		; $6bdd
	ld b,$02		; $6bdf
	call _ecom_spawnProjectile		; $6be1
	jr nz,_label_0c_291	; $6be4
	ld l,$c7		; $6be6
	ld (hl),$80		; $6be8
	ld a,$73		; $6bea
	call playSound		; $6bec
_label_0c_291:
	call objectSetInvisible		; $6bef
	jp $6c3e		; $6bf2
	ld b,(hl)		; $6bf5
	inc l			; $6bf6
	ld a,(bc)		; $6bf7
	cp $05			; $6bf8
	ret nc			; $6bfa
	dec a			; $6bfb
	ld (bc),a		; $6bfc
	ret			; $6bfd
	ld h,d			; $6bfe
	ld l,$b3		; $6bff
	ld c,$82		; $6c01
	ld b,(hl)		; $6c03
_label_0c_292:
	ld a,(bc)		; $6c04
	ld e,a			; $6c05
	dec l			; $6c06
	ld a,$af		; $6c07
	cp l			; $6c09
	ret nc			; $6c0a
	ld b,(hl)		; $6c0b
	ld a,(bc)		; $6c0c
	cp $05			; $6c0d
	jr nz,_label_0c_292	; $6c0f
	ld h,e			; $6c11
	push hl			; $6c12
	call $6b82		; $6c13
	ld l,$8b		; $6c16
	ld c,l			; $6c18
	ldi a,(hl)		; $6c19
	ld (bc),a		; $6c1a
	inc l			; $6c1b
	ld c,l			; $6c1c
	ld a,(hl)		; $6c1d
	ld (bc),a		; $6c1e
	ld c,$8f		; $6c1f
	xor a			; $6c21
	ld (bc),a		; $6c22
	ld c,$a4		; $6c23
	ld a,(bc)		; $6c25
	or $80			; $6c26
	ld (bc),a		; $6c28
	pop hl			; $6c29
	ld c,$82		; $6c2a
	ld a,h			; $6c2c
	ld (bc),a		; $6c2d
	ld h,d			; $6c2e
_label_0c_293:
	inc l			; $6c2f
	ld a,$b3		; $6c30
	cp l			; $6c32
	ret c			; $6c33
	ld b,(hl)		; $6c34
	ld a,(bc)		; $6c35
	cp $05			; $6c36
	jr z,_label_0c_293	; $6c38
	inc a			; $6c3a
	ld (bc),a		; $6c3b
	jr _label_0c_293		; $6c3c
	ld bc,$0404		; $6c3e
	ld l,$82		; $6c41
	ld e,$b4		; $6c43
_label_0c_294:
	dec e			; $6c45
	ld a,(de)		; $6c46
	ld h,a			; $6c47
	ld a,(hl)		; $6c48
	cp $05			; $6c49
	jr z,_label_0c_295	; $6c4b
	dec b			; $6c4d
_label_0c_295:
	dec c			; $6c4e
	jr nz,_label_0c_294	; $6c4f
	ld a,b			; $6c51
	ld bc,$6c5d		; $6c52
	call addAToBc		; $6c55
	ld l,$90		; $6c58
	ld a,(bc)		; $6c5a
	ld (hl),a		; $6c5b
	ret			; $6c5c
	ld a,(bc)		; $6c5d
	rrca			; $6c5e
	ld e,$3c		; $6c5f

enemyCode1c:
	call _ecom_checkHazards		; $6c61
	jr z,_label_0c_296	; $6c64
	sub $03			; $6c66
	ret c			; $6c68
	jp z,enemyDie		; $6c69
	dec a			; $6c6c
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6c6d
	ld e,$82		; $6c70
	ld a,(de)		; $6c72
	or a			; $6c73
	ret z			; $6c74
	ld e,$aa		; $6c75
	ld a,(de)		; $6c77
	cp $80			; $6c78
	ret nz			; $6c7a
	jp enemyDelete		; $6c7b
_label_0c_296:
	call _ecom_getSubidAndCpStateTo08		; $6c7e
	jr nc,_label_0c_297	; $6c81
	rst_jumpTable			; $6c83
	sbc d			; $6c84
	ld l,h			; $6c85
	xor b			; $6c86
	ld l,h			; $6c87
	xor b			; $6c88
	ld l,h			; $6c89
	xor b			; $6c8a
	ld l,h			; $6c8b
	xor b			; $6c8c
	ld l,h			; $6c8d
	bit 0,h			; $6c8e
	xor b			; $6c90
	ld l,h			; $6c91
	xor b			; $6c92
	ld l,h			; $6c93
_label_0c_297:
	ld a,b			; $6c94
	rst_jumpTable			; $6c95
	xor c			; $6c96
	ld l,h			; $6c97
	push hl			; $6c98
	ld l,h			; $6c99
	bit 0,b			; $6c9a
	jp nz,_ecom_setSpeedAndState8		; $6c9c
	ld a,$14		; $6c9f
	call _ecom_setSpeedAndState8AndVisible		; $6ca1
	ld l,$86		; $6ca4
	inc (hl)		; $6ca6
	ret			; $6ca7
	ret			; $6ca8
	ld a,(de)		; $6ca9
	sub $08			; $6caa
	rst_jumpTable			; $6cac
	or e			; $6cad
	ld l,h			; $6cae
	jp nz,$d96c		; $6caf
	ld l,h			; $6cb2
	call $6d7d		; $6cb3
	call _ecom_decCounter1		; $6cb6
	jp nz,$6d1e		; $6cb9
	ld l,$84		; $6cbc
	inc (hl)		; $6cbe
	call $6d35		; $6cbf
	call $6d7d		; $6cc2
	call _ecom_decCounter1		; $6cc5
	jr nz,_label_0c_298	; $6cc8
	ld l,$84		; $6cca
	dec (hl)		; $6ccc
	call $6d6b		; $6ccd
_label_0c_298:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6cd0
	call $6d1e		; $6cd3
	jp enemyAnimate		; $6cd6
	call _ecom_decCounter1		; $6cd9
	call z,$6d35		; $6cdc
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6cdf
	jp enemyAnimate		; $6ce2
	ld a,(de)		; $6ce5
	sub $08			; $6ce6
	rst_jumpTable			; $6ce8
	rst $28			; $6ce9
	ld l,h			; $6cea
	ld (bc),a		; $6ceb
	ld l,l			; $6cec
	dec d			; $6ced
	ld l,l			; $6cee
	ld h,d			; $6cef
	ld l,e			; $6cf0
	inc (hl)		; $6cf1
	ld l,$90		; $6cf2
	ld (hl),$50		; $6cf4
	ld l,$a5		; $6cf6
	ld (hl),$05		; $6cf8
	ld a,$05		; $6cfa
	call enemySetAnimation		; $6cfc
	call objectSetVisible82		; $6cff
	ld a,($cc79)		; $6d02
	or a			; $6d05
	jr z,_label_0c_299	; $6d06
	call _ecom_updateAngleTowardTarget		; $6d08
	jp objectApplySpeed		; $6d0b
_label_0c_299:
	ld h,d			; $6d0e
	ld l,e			; $6d0f
	inc (hl)		; $6d10
	ld l,$86		; $6d11
	ld (hl),$1e		; $6d13
	call _ecom_decCounter1		; $6d15
	jp nz,_ecom_flickerVisibility		; $6d18
	jp enemyDelete		; $6d1b
	call objectGetAngleTowardEnemyTarget		; $6d1e
	ld h,d			; $6d21
	ld l,$89		; $6d22
	sub (hl)		; $6d24
	and $1f			; $6d25
	sub $0c			; $6d27
	cp $09			; $6d29
	ld l,$a5		; $6d2b
	jr c,_label_0c_300	; $6d2d
	ld (hl),$1c		; $6d2f
	ret			; $6d31
_label_0c_300:
	ld (hl),$50		; $6d32
	ret			; $6d34
	ld bc,$0703		; $6d35
	call _ecom_randomBitwiseAndBCE		; $6d38
	ld a,b			; $6d3b
	ld hl,$6d63		; $6d3c
	rst_addAToHl			; $6d3f
	ld e,$86		; $6d40
	ld a,(hl)		; $6d42
	ld (de),a		; $6d43
	ld e,$84		; $6d44
	ld a,(de)		; $6d46
	cp $0a			; $6d47
	jp z,_ecom_setRandomCardinalAngle		; $6d49
	call $6d5b		; $6d4c
	swap a			; $6d4f
	rlca			; $6d51
	ld h,d			; $6d52
	ld l,$b1		; $6d53
	cp (hl)			; $6d55
	ret z			; $6d56
	ld (hl),a		; $6d57
	jp enemySetAnimation		; $6d58
	ld a,c			; $6d5b
	or a			; $6d5c
	jp z,_ecom_updateCardinalAngleTowardTarget		; $6d5d
	jp _ecom_setRandomCardinalAngle		; $6d60
	add hl,de		; $6d63
	ld e,$23		; $6d64
	jr z,$2d		; $6d66
	ldd (hl),a		; $6d68
	scf			; $6d69
	inc a			; $6d6a
	call getRandomNumber_noPreserveVars		; $6d6b
	and $03			; $6d6e
	ld hl,$6d79		; $6d70
	rst_addAToHl			; $6d73
	ld e,$86		; $6d74
	ld a,(hl)		; $6d76
	ld (de),a		; $6d77
	ret			; $6d78
	rrca			; $6d79
	ld e,$2d		; $6d7a
	inc a			; $6d7c
	ld a,($cc79)		; $6d7d
	or a			; $6d80
	jr z,_label_0c_301	; $6d81
	ld c,$40		; $6d83
	call objectCheckLinkWithinDistance		; $6d85
	jr nc,_label_0c_301	; $6d88
	rrca			; $6d8a
	xor $02			; $6d8b
	ld b,a			; $6d8d
	ld a,($d008)		; $6d8e
	cp b			; $6d91
	jr z,_label_0c_302	; $6d92
_label_0c_301:
	ld e,$b2		; $6d94
	ld a,$3c		; $6d96
	ld (de),a		; $6d98
	ret			; $6d99
_label_0c_302:
	pop hl			; $6d9a
	ld h,d			; $6d9b
	ld l,$b2		; $6d9c
	dec (hl)		; $6d9e
	jr z,_label_0c_305	; $6d9f
	ld a,(hl)		; $6da1
	and $03			; $6da2
	sub $01			; $6da4
	jr nc,_label_0c_303	; $6da6
	cpl			; $6da8
	inc a			; $6da9
_label_0c_303:
	dec a			; $6daa
	bit 0,b			; $6dab
	jr z,_label_0c_304	; $6dad
	ld l,$8d		; $6daf
	add (hl)		; $6db1
	ld (hl),a		; $6db2
	ret			; $6db3
_label_0c_304:
	ld l,$8b		; $6db4
	add (hl)		; $6db6
	ld (hl),a		; $6db7
	ret			; $6db8
_label_0c_305:
	ld l,$84		; $6db9
	ld (hl),$0a		; $6dbb
	ld l,$a5		; $6dbd
	ld (hl),$50		; $6dbf
	ld a,$04		; $6dc1
	call enemySetAnimation		; $6dc3
	ld b,$1c		; $6dc6
	call _ecom_spawnUncountedEnemyWithSubid01		; $6dc8
	ret nz			; $6dcb
	jp objectCopyPosition		; $6dcc
	jr z,_label_0c_306	; $6dcf
	sub $03			; $6dd1
	ret c			; $6dd3
	jp z,enemyDie		; $6dd4
	dec a			; $6dd7
	jp nz,_ecom_updateKnockback		; $6dd8
	ret			; $6ddb
_label_0c_306:
	ld e,$84		; $6ddc
	ld a,(de)		; $6dde
	rst_jumpTable			; $6ddf
	ld a,($ff00+$6d)	; $6de0
	di			; $6de2
	ld l,l			; $6de3
	di			; $6de4
	ld l,l			; $6de5
	di			; $6de6
	ld l,l			; $6de7
	di			; $6de8
	ld l,l			; $6de9
	di			; $6dea
	ld l,l			; $6deb
	di			; $6dec
	ld l,l			; $6ded
	di			; $6dee
	ld l,l			; $6def
	jp enemyDelete		; $6df0
	ret			; $6df3
	jp enemyDelete		; $6df4
