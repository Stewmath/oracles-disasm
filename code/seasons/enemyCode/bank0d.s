enemyCode30:
	call _ecom_checkHazards		; $450f
	jr z,_label_0d_039	; $4512
	sub $03			; $4514
	ret c			; $4516
	jp z,enemyDie		; $4517
	dec a			; $451a
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $451b
	ret			; $451e
_label_0d_039:
	ld e,$84		; $451f
	ld a,(de)		; $4521
	rst_jumpTable			; $4522
	dec sp			; $4523
	ld b,l			; $4524
	ld l,e			; $4525
	ld b,l			; $4526
	ld l,e			; $4527
	ld b,l			; $4528
	ld d,(hl)		; $4529
	ld b,l			; $452a
	ld l,e			; $452b
	ld b,l			; $452c
	bit 0,h			; $452d
	ld l,e			; $452f
	ld b,l			; $4530
	ld l,e			; $4531
	ld b,l			; $4532
	ld l,h			; $4533
	ld b,l			; $4534
	adc c			; $4535
	ld b,l			; $4536
	sub h			; $4537
	ld b,l			; $4538
	ret nz			; $4539
	ld b,l			; $453a
	ld h,d			; $453b
	ld l,$82		; $453c
	bit 0,(hl)		; $453e
	ld l,$b1		; $4540
	ld (hl),$5a		; $4542
	jr z,_label_0d_040	; $4544
	ld (hl),$2d		; $4546
_label_0d_040:
	call getRandomNumber_noPreserveVars		; $4548
	and $7f			; $454b
	inc a			; $454d
	ld e,$86		; $454e
	ld (de),a		; $4550
	ld a,$32		; $4551
	jp _ecom_setSpeedAndState8AndVisible		; $4553
	inc e			; $4556
	ld a,(de)		; $4557
	rst_jumpTable			; $4558
	dec b			; $4559
	ld b,b			; $455a
	ld h,c			; $455b
	ld b,l			; $455c
	ld h,c			; $455d
	ld b,l			; $455e
	ld h,d			; $455f
	ld b,l			; $4560
	ret			; $4561
	ld b,$08		; $4562
	call _ecom_fallToGroundAndSetState		; $4564
	ret nz			; $4567
	jp $45cd		; $4568
	ret			; $456b
	call _ecom_decCounter1		; $456c
	jr nz,_label_0d_041	; $456f
	call getRandomNumber_noPreserveVars		; $4571
	and $7f			; $4574
	call _ecom_incState		; $4576
	ld l,$b1		; $4579
	add (hl)		; $457b
	ld l,$86		; $457c
	ldi (hl),a		; $457e
	ld (hl),$18		; $457f
	ld a,$01		; $4581
	jp enemySetAnimation		; $4583
_label_0d_041:
	jp enemyAnimate		; $4586
	call _ecom_decCounter2		; $4589
	ret nz			; $458c
	ld l,e			; $458d
	inc (hl)		; $458e
	ld a,$02		; $458f
	jp enemySetAnimation		; $4591
	ld a,$0b		; $4594
	ld (de),a		; $4596
	call getRandomNumber_noPreserveVars		; $4597
	and $07			; $459a
	ld hl,$45ba		; $459c
	jr nz,_label_0d_042	; $459f
	ld hl,$45bd		; $45a1
_label_0d_042:
	ld e,$94		; $45a4
	ldi a,(hl)		; $45a6
	ld (de),a		; $45a7
	inc e			; $45a8
	ldi a,(hl)		; $45a9
	ld (de),a		; $45aa
	ld e,$b0		; $45ab
	ldi a,(hl)		; $45ad
	ld (de),a		; $45ae
	call _ecom_updateAngleTowardTarget		; $45af
	ld a,$8f		; $45b2
	call playSound		; $45b4
	jp objectSetVisiblec1		; $45b7
	xor d			; $45ba
	cp $0e			; $45bb
	add b			; $45bd
	cp $0c			; $45be
	call _ecom_bounceOffScreenBoundary		; $45c0
	ld e,$b0		; $45c3
	ld a,(de)		; $45c5
	ld c,a			; $45c6
	call objectUpdateSpeedZ_paramC		; $45c7
	jp nz,_ecom_applyVelocityForSideviewEnemy		; $45ca
	call getRandomNumber_noPreserveVars		; $45cd
	and $7f			; $45d0
	ld h,d			; $45d2
	ld l,$b1		; $45d3
	add (hl)		; $45d5
	ld l,$86		; $45d6
	ld (hl),a		; $45d8
	ld l,$84		; $45d9
	ld (hl),$08		; $45db
	xor a			; $45dd
	call enemySetAnimation		; $45de
	jp objectSetVisiblec2		; $45e1

enemyCode31:
	call _ecom_checkHazards		; $45e4
	jr z,_label_0d_043	; $45e7
	sub $03			; $45e9
	ret c			; $45eb
	jp z,enemyDie		; $45ec
	dec a			; $45ef
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $45f0
	ret			; $45f3
_label_0d_043:
	call $4718		; $45f4
	ld e,$84		; $45f7
	ld a,(de)		; $45f9
	rst_jumpTable			; $45fa
	dec e			; $45fb
	ld b,(hl)		; $45fc
	ld l,$46		; $45fd
	ld l,$46		; $45ff
	ldi (hl),a		; $4601
	ld b,(hl)		; $4602
	ld l,$46		; $4603
	bit 0,h			; $4605
	ld l,$46		; $4607
	ld l,$46		; $4609
	cpl			; $460b
	ld b,(hl)		; $460c
	ld c,b			; $460d
	ld b,(hl)		; $460e
	ld e,l			; $460f
	ld b,(hl)		; $4610
	ld (hl),e		; $4611
	ld b,(hl)		; $4612
	sub c			; $4613
	ld b,(hl)		; $4614
	sbc b			; $4615
	ld b,(hl)		; $4616
	xor d			; $4617
	ld b,(hl)		; $4618
	or c			; $4619
	ld b,(hl)		; $461a
	add $46			; $461b
	ld a,$14		; $461d
	jp _ecom_setSpeedAndState8AndVisible		; $461f
	inc e			; $4622
	ld a,(de)		; $4623
	rst_jumpTable			; $4624
	dec b			; $4625
	ld b,b			; $4626
	dec l			; $4627
	ld b,(hl)		; $4628
	dec l			; $4629
	ld b,(hl)		; $462a
	rst $38			; $462b
	ld b,h			; $462c
	ret			; $462d
	ret			; $462e
	call $46ed		; $462f
	call getRandomNumber_noPreserveVars		; $4632
	and $07			; $4635
	jp nz,$46ca		; $4637
	ld e,$82		; $463a
	ld a,(de)		; $463c
	cp $02			; $463d
	jp nz,$46ca		; $463f
	ld e,$84		; $4642
	ld a,$0c		; $4644
	ld (de),a		; $4646
	ret			; $4647
	call $46ed		; $4648
	call _ecom_decCounter1		; $464b
	jr nz,_label_0d_044	; $464e
	ld l,$84		; $4650
	ld (hl),$08		; $4652
_label_0d_044:
	call _ecom_bounceOffWallsAndHoles		; $4654
	call objectApplySpeed		; $4657
	jp enemyAnimate		; $465a
	ld bc,$fe00		; $465d
	call objectSetSpeedZ		; $4660
	ld l,e			; $4663
	inc (hl)		; $4664
	ld l,$a4		; $4665
	res 7,(hl)		; $4667
	ld l,$90		; $4669
	ld (hl),$32		; $466b
	call _ecom_updateCardinalAngleAwayFromTarget		; $466d
	jp $470b		; $4670
	ld c,$20		; $4673
	call objectUpdateSpeedZ_paramC		; $4675
	jr z,_label_0d_046	; $4678
	ld a,(hl)		; $467a
	or a			; $467b
	jr nz,_label_0d_045	; $467c
	ld l,$a4		; $467e
	set 7,(hl)		; $4680
_label_0d_045:
	jp _ecom_applyVelocityForSideviewEnemy		; $4682
_label_0d_046:
	ld a,$14		; $4685
	call _ecom_setSpeedAndState8		; $4687
	xor a			; $468a
	call enemySetAnimation		; $468b
	jp objectSetVisiblec2		; $468e
	ld b,$1c		; $4691
	call _ecom_spawnProjectile		; $4693
	jr _label_0d_047		; $4696
	ld c,$20		; $4698
	call objectUpdateSpeedZ_paramC		; $469a
	ld a,(hl)		; $469d
	or a			; $469e
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $469f
	ld l,$86		; $46a2
	ld (hl),$08		; $46a4
	ld l,$84		; $46a6
	inc (hl)		; $46a8
	ret			; $46a9
	call _ecom_decCounter1		; $46aa
	ret nz			; $46ad
	ld l,e			; $46ae
	inc (hl)		; $46af
	ret			; $46b0
	ld h,d			; $46b1
	ld l,$8f		; $46b2
	ld a,(hl)		; $46b4
	add $03			; $46b5
	ld (hl),a		; $46b7
	cp $80			; $46b8
	ret nc			; $46ba
	xor a			; $46bb
	ld (hl),a		; $46bc
	ld l,e			; $46bd
	inc (hl)		; $46be
	ld l,$86		; $46bf
	ld (hl),$1e		; $46c1
	jp objectSetVisiblec2		; $46c3
	call _ecom_decCounter1		; $46c6
	ret nz			; $46c9
_label_0d_047:
	ld e,$30		; $46ca
	ld bc,$1f0f		; $46cc
	call _ecom_randomBitwiseAndBCE		; $46cf
	ld h,d			; $46d2
	ld l,$84		; $46d3
	ld (hl),$09		; $46d5
	ld l,$90		; $46d7
	ld (hl),$14		; $46d9
	ld a,$20		; $46db
	add e			; $46dd
	ld l,$86		; $46de
	ld (hl),a		; $46e0
	dec c			; $46e1
	ld a,b			; $46e2
	call z,objectGetAngleTowardEnemyTarget		; $46e3
	ld e,$89		; $46e6
	ld (de),a		; $46e8
	xor a			; $46e9
	jp enemySetAnimation		; $46ea
	ld e,$82		; $46ed
	ld a,(de)		; $46ef
	cp $03			; $46f0
	ret nz			; $46f2
	ld c,$1c		; $46f3
	call objectCheckLinkWithinDistance		; $46f5
	ret nc			; $46f8
	ld bc,$fdc0		; $46f9
	call objectSetSpeedZ		; $46fc
	ld l,$84		; $46ff
	ld (hl),$0d		; $4701
	ld l,$90		; $4703
	ld (hl),$3c		; $4705
	pop hl			; $4707
	call _ecom_updateAngleTowardTarget		; $4708
	ld a,$01		; $470b
	call enemySetAnimation		; $470d
	ld a,$8f		; $4710
	call playSound		; $4712
	jp objectSetVisiblec1		; $4715
	ld e,$82		; $4718
	ld a,(de)		; $471a
	or a			; $471b
	ret z			; $471c
	ld a,($cc7a)		; $471d
	and $f0			; $4720
	ret z			; $4722
	ld e,$84		; $4723
	ld a,(de)		; $4725
	cp $0a			; $4726
	ret nc			; $4728
	ld c,$2c		; $4729
	call objectCheckLinkWithinDistance		; $472b
	ret nc			; $472e
	ld e,$84		; $472f
	ld a,$0a		; $4731
	ld (de),a		; $4733
	ret			; $4734
	ld e,$84		; $4735
	ld a,$08		; $4737
	ld (de),a		; $4739
	ret			; $473a

enemyCode32:
	jr z,_label_0d_048	; $473b
	sub $03			; $473d
	ret c			; $473f
	jp z,enemyDie		; $4740
	dec a			; $4743
	jp nz,_ecom_updateKnockbackNoSolidity		; $4744
	ret			; $4747
_label_0d_048:
	call _ecom_getSubidAndCpStateTo08		; $4748
	jr nc,_label_0d_049	; $474b
	rst_jumpTable			; $474d
	ld h,h			; $474e
	ld b,a			; $474f
	ld l,l			; $4750
	ld b,a			; $4751
	ld l,l			; $4752
	ld b,a			; $4753
	ld l,l			; $4754
	ld b,a			; $4755
	ld l,l			; $4756
	ld b,a			; $4757
	bit 0,h			; $4758
	ld l,l			; $475a
	ld b,a			; $475b
	ld l,l			; $475c
	ld b,a			; $475d
_label_0d_049:
	ld a,b			; $475e
	rst_jumpTable			; $475f
	ld l,(hl)		; $4760
	ld b,a			; $4761
	jp hl			; $4762
	ld b,a			; $4763
	call _ecom_setSpeedAndState8		; $4764
	call $4870		; $4767
	jp objectSetVisible82		; $476a
	ret			; $476d
	ld a,(de)		; $476e
	sub $08			; $476f
	rst_jumpTable			; $4771
	ld a,b			; $4772
	ld b,a			; $4773
	sbc c			; $4774
	ld b,a			; $4775
	cp a			; $4776
	ld b,a			; $4777
	call _ecom_decCounter1		; $4778
	ret nz			; $477b
	ld bc,$1f3f		; $477c
	call _ecom_randomBitwiseAndBCE		; $477f
	call _ecom_incState		; $4782
	ld l,$89		; $4785
	ld (hl),b		; $4787
	ld l,$90		; $4788
	ld (hl),$1e		; $478a
	ld a,$c0		; $478c
	add c			; $478e
	ld l,$86		; $478f
	ld (hl),a		; $4791
	ld a,$01		; $4792
	call enemySetAnimation		; $4794
	jr _label_0d_051		; $4797
	call objectApplySpeed		; $4799
	call _ecom_bounceOffScreenBoundary		; $479c
	ld a,(wFrameCounter)		; $479f
	rrca			; $47a2
	jr c,_label_0d_051	; $47a3
	call _ecom_decCounter1		; $47a5
	jr z,_label_0d_050	; $47a8
	ld bc,$0f1f		; $47aa
	call _ecom_randomBitwiseAndBCE		; $47ad
	or b			; $47b0
	jr nz,_label_0d_051	; $47b1
	ld e,$89		; $47b3
	ld a,c			; $47b5
	ld (de),a		; $47b6
	jr _label_0d_051		; $47b7
_label_0d_050:
	ld l,$84		; $47b9
	inc (hl)		; $47bb
_label_0d_051:
	jp enemyAnimate		; $47bc
	ld e,$86		; $47bf
	ld a,(de)		; $47c1
	cp $68			; $47c2
	jr nc,_label_0d_052	; $47c4
	call objectApplySpeed		; $47c6
	call _ecom_bounceOffScreenBoundary		; $47c9
_label_0d_052:
	call $483b		; $47cc
	ld h,d			; $47cf
	ld l,$86		; $47d0
	inc (hl)		; $47d2
	ld a,$7f		; $47d3
	cp (hl)			; $47d5
	ret nz			; $47d6
	ld l,$84		; $47d7
	ld (hl),$08		; $47d9
	call getRandomNumber_noPreserveVars		; $47db
	and $7f			; $47de
	ld e,$86		; $47e0
	add $20			; $47e2
	ld (de),a		; $47e4
	xor a			; $47e5
	jp enemySetAnimation		; $47e6
	ld a,(de)		; $47e9
	sub $08			; $47ea
	rst_jumpTable			; $47ec
	pop af			; $47ed
	ld b,a			; $47ee
	ld d,$48		; $47ef
	ld c,$31		; $47f1
	call objectCheckLinkWithinDistance		; $47f3
	ret nc			; $47f6
	call _ecom_updateAngleTowardTarget		; $47f7
	call _ecom_incState		; $47fa
	ld l,$90		; $47fd
	ld (hl),$28		; $47ff
	ld e,$89		; $4801
	ld l,$b0		; $4803
	ld a,(de)		; $4805
	add (hl)		; $4806
	and $1f			; $4807
	ld (de),a		; $4809
	ld l,$86		; $480a
	ld (hl),$0c		; $480c
	inc l			; $480e
	ld (hl),$0c		; $480f
	ld a,$01		; $4811
	jp enemySetAnimation		; $4813
	call objectApplySpeed		; $4816
	call _ecom_bounceOffScreenBoundary		; $4819
	call _ecom_decCounter1		; $481c
	jr nz,_label_0d_051	; $481f
	ld (hl),$0c		; $4821
	ld l,$b0		; $4823
	ld e,$89		; $4825
	ld a,(de)		; $4827
	add (hl)		; $4828
	and $1f			; $4829
	ld (de),a		; $482b
	ld l,$87		; $482c
	dec (hl)		; $482e
	jr nz,_label_0d_051	; $482f
	ld l,$84		; $4831
	dec (hl)		; $4833
	call $4880		; $4834
	xor a			; $4837
	jp enemySetAnimation		; $4838
	ld e,$86		; $483b
	ld a,(de)		; $483d
	and $0f			; $483e
	jr nz,_label_0d_053	; $4840
	ld a,(de)		; $4842
	swap a			; $4843
	ld hl,$4860		; $4845
	rst_addAToHl			; $4848
	ld a,(hl)		; $4849
	ld e,$90		; $484a
	ld (de),a		; $484c
_label_0d_053:
	ld e,$86		; $484d
	ld a,(de)		; $484f
	and $f0			; $4850
	swap a			; $4852
	ld hl,$4868		; $4854
	rst_addAToHl			; $4857
	ld a,(wFrameCounter)		; $4858
	and (hl)		; $485b
	jp z,enemyAnimate		; $485c
	ret			; $485f
	ld e,$14		; $4860
	ld a,(bc)		; $4862
	ld a,(bc)		; $4863
	dec b			; $4864
	dec b			; $4865
	dec b			; $4866
	dec b			; $4867
	nop			; $4868
	nop			; $4869
	ld bc,$0301		; $486a
	inc bc			; $486d
	rlca			; $486e
	nop			; $486f
	dec b			; $4870
	jr z,_label_0d_054	; $4871
	ld l,$86		; $4873
	ld (hl),$20		; $4875
	ret			; $4877
_label_0d_054:
	ld l,$8f		; $4878
	ld (hl),$ff		; $487a
	ld l,$b0		; $487c
	ld (hl),$02		; $487e
	call getRandomNumber_noPreserveVars		; $4880
	and $03			; $4883
	ret nz			; $4885
	ld e,$b0		; $4886
	ld a,(de)		; $4888
	cpl			; $4889
	inc a			; $488a
	ld (de),a		; $488b
	ret			; $488c

enemyCode33:
	ld e,$84		; $488d
	ld a,(de)		; $488f
	rst_jumpTable			; $4890
	and l			; $4891
	ld c,b			; $4892
	inc bc			; $4893
	ld c,c			; $4894
	xor d			; $4895
	ld c,b			; $4896
	inc bc			; $4897
	ld c,c			; $4898
	inc bc			; $4899
	ld c,c			; $489a
	inc bc			; $489b
	ld c,c			; $489c
	inc bc			; $489d
	ld c,c			; $489e
	inc bc			; $489f
	ld c,c			; $48a0
	inc b			; $48a1
	ld c,c			; $48a2
	ld l,$49		; $48a3
	ld a,$0a		; $48a5
	jp _ecom_setSpeedAndState8AndVisible		; $48a7
	inc e			; $48aa
	ld a,(de)		; $48ab
	rst_jumpTable			; $48ac
	or l			; $48ad
	ld c,b			; $48ae
	ret nc			; $48af
	ld c,b			; $48b0
	pop hl			; $48b1
	ld c,b			; $48b2
	di			; $48b3
	ld c,b			; $48b4
	ld h,d			; $48b5
	ld l,e			; $48b6
	inc (hl)		; $48b7
	ld l,$a4		; $48b8
	res 7,(hl)		; $48ba
	xor a			; $48bc
	ld (wLinkGrabState2),a		; $48bd
	ld a,($d008)		; $48c0
	srl a			; $48c3
	xor $01			; $48c5
	ld l,$88		; $48c7
	ld (hl),a		; $48c9
	call enemySetAnimation		; $48ca
	jp objectSetVisiblec1		; $48cd
	ld h,d			; $48d0
	ld l,$88		; $48d1
	ld a,($d008)		; $48d3
	srl a			; $48d6
	xor $01			; $48d8
	cp (hl)			; $48da
	jr z,_label_0d_055	; $48db
	ld (hl),a		; $48dd
	jp enemySetAnimation		; $48de
_label_0d_055:
	ld e,$8b		; $48e1
	ld a,(de)		; $48e3
	cp $80			; $48e4
	jr nc,_label_0d_056	; $48e6
	ld e,$8d		; $48e8
	ld a,(de)		; $48ea
	cp $a0			; $48eb
	jp c,enemyAnimate		; $48ed
_label_0d_056:
	jp enemyDelete		; $48f0
	ld h,d			; $48f3
	ld l,$84		; $48f4
	ld (hl),$08		; $48f6
	ld l,$a4		; $48f8
	set 7,(hl)		; $48fa
	ld l,$88		; $48fc
	ld (hl),$ff		; $48fe
	jp objectSetVisiblec2		; $4900
	ret			; $4903
	call objectAddToGrabbableObjectBuffer		; $4904
	call objectSetPriorityRelativeToLink_withTerrainEffects		; $4907
	call _ecom_updateAngleTowardTarget		; $490a
	call $4939		; $490d
	ld c,$10		; $4910
	call objectCheckLinkWithinDistance		; $4912
	jr nc,_label_0d_057	; $4915
	call getRandomNumber_noPreserveVars		; $4917
	and $3f			; $491a
	ret nz			; $491c
	call _ecom_incState		; $491d
	ld l,$94		; $4920
	ld a,$40		; $4922
	ldi (hl),a		; $4924
	ld (hl),$ff		; $4925
	ret			; $4927
_label_0d_057:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4928
_label_0d_058:
	jp enemyAnimate		; $492b
	ld c,$12		; $492e
	call objectUpdateSpeedZ_paramC		; $4930
	jr nz,_label_0d_058	; $4933
	ld l,$84		; $4935
	dec (hl)		; $4937
	ret			; $4938
	ld e,$89		; $4939
	ld a,(de)		; $493b
	cp $10			; $493c
	ld a,$01		; $493e
	jr c,_label_0d_059	; $4940
	xor a			; $4942
_label_0d_059:
	ld h,d			; $4943
	ld l,$88		; $4944
	cp (hl)			; $4946
	ret z			; $4947
	ld (hl),a		; $4948
	jp enemySetAnimation		; $4949

enemyCode34:
	call _ecom_checkHazardsNoAnimationForHoles		; $494c
	jr z,_label_0d_060	; $494f
	sub $03			; $4951
	ret c			; $4953
	jp z,enemyDie		; $4954
	dec a			; $4957
	jp nz,_ecom_updateKnockbackAndCheckHazardsNoAnimationsForHoles		; $4958
	ld e,$82		; $495b
	ld a,(de)		; $495d
	or a			; $495e
	ret z			; $495f
	ld e,$aa		; $4960
	ld a,(de)		; $4962
	cp $80			; $4963
	jr z,_label_0d_060	; $4965
	res 7,a			; $4967
	sub $01			; $4969
	cp $03			; $496b
	ret c			; $496d
	ld e,$84		; $496e
	ld a,$0c		; $4970
	ld (de),a		; $4972
	ret			; $4973
_label_0d_060:
	call _ecom_getSubidAndCpStateTo08		; $4974
	jr nc,_label_0d_061	; $4977
	rst_jumpTable			; $4979
	sub b			; $497a
	ld c,c			; $497b
	xor b			; $497c
	ld c,c			; $497d
	xor b			; $497e
	ld c,c			; $497f
	xor b			; $4980
	ld c,c			; $4981
	xor b			; $4982
	ld c,c			; $4983
	bit 0,h			; $4984
	xor b			; $4986
	ld c,c			; $4987
	xor b			; $4988
	ld c,c			; $4989
_label_0d_061:
	ld a,b			; $498a
	rst_jumpTable			; $498b
	xor c			; $498c
	ld c,c			; $498d
	ld e,d			; $498e
	ld c,d			; $498f
	ld a,b			; $4990
	or a			; $4991
	ld a,$1e		; $4992
	jp z,_ecom_setSpeedAndState8		; $4994
	ld h,d			; $4997
	ld l,$86		; $4998
	ld (hl),$18		; $499a
	ld l,$a4		; $499c
	set 7,(hl)		; $499e
	ld a,$04		; $49a0
	call enemySetAnimation		; $49a2
	jp _ecom_setSpeedAndState8AndVisible		; $49a5
	ret			; $49a8
	ld a,(de)		; $49a9
	sub $08			; $49aa
	rst_jumpTable			; $49ac
	cp c			; $49ad
	ld c,c			; $49ae
	rst $8			; $49af
	ld c,c			; $49b0
	rst $30			; $49b1
	ld c,c			; $49b2
	inc de			; $49b3
	ld c,d			; $49b4
	jr c,$4a		; $49b5
	ld c,a			; $49b7
	ld c,d			; $49b8
	ld c,$28		; $49b9
	call objectCheckLinkWithinDistance		; $49bb
	ret nc			; $49be
	ld bc,$fe00		; $49bf
	call objectSetSpeedZ		; $49c2
	ld l,$84		; $49c5
	inc (hl)		; $49c7
	ld l,$87		; $49c8
	ld (hl),$04		; $49ca
	jp objectSetVisiblec2		; $49cc
	ld h,d			; $49cf
	ld l,$a1		; $49d0
	ld a,(hl)		; $49d2
	or a			; $49d3
	jr z,_label_0d_063	; $49d4
	ld l,$b0		; $49d6
	and (hl)		; $49d8
	jr nz,_label_0d_062	; $49d9
	ld (hl),$01		; $49db
	ld a,$8f		; $49dd
	call playSound		; $49df
_label_0d_062:
	ld c,$28		; $49e2
	call objectUpdateSpeedZ_paramC		; $49e4
	ret nz			; $49e7
	call _ecom_incState		; $49e8
	ld l,$86		; $49eb
	ld (hl),$30		; $49ed
	ld l,$a4		; $49ef
	set 7,(hl)		; $49f1
	inc a			; $49f3
	jp enemySetAnimation		; $49f4
	call _ecom_decCounter1		; $49f7
	ret nz			; $49fa
	ld l,e			; $49fb
	inc (hl)		; $49fc
	ld bc,$fe00		; $49fd
	call objectSetSpeedZ		; $4a00
	call _ecom_updateAngleTowardTarget		; $4a03
	ld a,$02		; $4a06
	call enemySetAnimation		; $4a08
	ld a,$8f		; $4a0b
	call playSound		; $4a0d
_label_0d_063:
	jp enemyAnimate		; $4a10
	call _ecom_applyVelocityForSideviewEnemy		; $4a13
	ld c,$28		; $4a16
	call objectUpdateSpeedZ_paramC		; $4a18
	ret nz			; $4a1b
	ld h,d			; $4a1c
	ld l,$86		; $4a1d
	ld (hl),$30		; $4a1f
	inc l			; $4a21
	dec (hl)		; $4a22
	ld a,$0a		; $4a23
	ld b,$01		; $4a25
	jr nz,_label_0d_064	; $4a27
	ld l,$a4		; $4a29
	res 7,(hl)		; $4a2b
	ld a,$0c		; $4a2d
	ld b,$03		; $4a2f
_label_0d_064:
	ld l,$84		; $4a31
	ld (hl),a		; $4a33
	ld a,b			; $4a34
	jp enemySetAnimation		; $4a35
	ld h,d			; $4a38
	ld l,$a1		; $4a39
	ld a,(hl)		; $4a3b
	or a			; $4a3c
	jr z,_label_0d_063	; $4a3d
	ld l,e			; $4a3f
	inc (hl)		; $4a40
	ld l,$86		; $4a41
	ld (hl),$28		; $4a43
	ld l,$b0		; $4a45
	xor a			; $4a47
	ld (hl),a		; $4a48
	call enemySetAnimation		; $4a49
	jp objectSetInvisible		; $4a4c
	call _ecom_decCounter1		; $4a4f
	ret nz			; $4a52
	ld l,e			; $4a53
	ld (hl),$08		; $4a54
	xor a			; $4a56
	jp enemySetAnimation		; $4a57
	ld a,(de)		; $4a5a
	sub $08			; $4a5b
	rst_jumpTable			; $4a5d
	ld l,d			; $4a5e
	ld c,d			; $4a5f
	sub d			; $4a60
	ld c,d			; $4a61
	and l			; $4a62
	ld c,d			; $4a63
	ret z			; $4a64
	ld c,d			; $4a65
	ld ($ff00+c),a		; $4a66
	ld c,d			; $4a67
	ei			; $4a68
	ld c,d			; $4a69
	call _ecom_decCounter1		; $4a6a
	jr nz,_label_0d_066	; $4a6d
	call getRandomNumber_noPreserveVars		; $4a6f
	and $07			; $4a72
	ld h,d			; $4a74
	ld l,$86		; $4a75
	jr z,_label_0d_065	; $4a77
	ld (hl),$10		; $4a79
	ld l,$84		; $4a7b
	inc (hl)		; $4a7d
	ld l,$90		; $4a7e
	ld (hl),$14		; $4a80
	call _ecom_updateAngleTowardTarget		; $4a82
	jr _label_0d_066		; $4a85
_label_0d_065:
	ld (hl),$20		; $4a87
	ld l,$84		; $4a89
	ld (hl),$0a		; $4a8b
	ld a,$05		; $4a8d
	jp enemySetAnimation		; $4a8f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4a92
	call _ecom_bounceOffScreenBoundary		; $4a95
	call _ecom_decCounter1		; $4a98
	jr nz,_label_0d_066	; $4a9b
	ld (hl),$18		; $4a9d
	ld l,$84		; $4a9f
	dec (hl)		; $4aa1
_label_0d_066:
	jp enemyAnimate		; $4aa2
	call _ecom_decCounter1		; $4aa5
	jr nz,_label_0d_066	; $4aa8
	call _ecom_incState		; $4aaa
	ld l,$94		; $4aad
	ld (hl),$00		; $4aaf
	inc l			; $4ab1
	ld (hl),$fe		; $4ab2
	ld l,$90		; $4ab4
	ld (hl),$28		; $4ab6
	call _ecom_updateAngleTowardTarget		; $4ab8
	ld a,$02		; $4abb
	call enemySetAnimation		; $4abd
	ld a,$8f		; $4ac0
	call playSound		; $4ac2
	jp objectSetVisiblec1		; $4ac5
	call _ecom_applyVelocityForSideviewEnemy		; $4ac8
	ld c,$28		; $4acb
	call objectUpdateSpeedZ_paramC		; $4acd
	ret nz			; $4ad0
	ld h,d			; $4ad1
	ld l,$86		; $4ad2
	ld (hl),$18		; $4ad4
	ld l,$84		; $4ad6
	ld (hl),$08		; $4ad8
	ld a,$04		; $4ada
	call enemySetAnimation		; $4adc
	jp objectSetVisiblec2		; $4adf
	ld b,$08		; $4ae2
	call objectCreateInteractionWithSubid00		; $4ae4
	ld h,d			; $4ae7
	ld l,$87		; $4ae8
	ld (hl),$12		; $4aea
	ld l,$a4		; $4aec
	res 7,(hl)		; $4aee
	ld l,$84		; $4af0
	inc (hl)		; $4af2
	ld a,$73		; $4af3
	call playSound		; $4af5
	jp objectSetInvisible		; $4af8
	call _ecom_decCounter2		; $4afb
	ret nz			; $4afe
	ld c,$04		; $4aff
	call $4b0f		; $4b01
	ld c,$fc		; $4b04
	call $4b0f		; $4b06
	call decNumEnemies		; $4b09
	jp enemyDelete		; $4b0c
	ld b,$43		; $4b0f
	call _ecom_spawnEnemyWithSubid01		; $4b11
	ret nz			; $4b14
	ld (hl),a		; $4b15
	ld b,$00		; $4b16
	call objectCopyPositionWithOffset		; $4b18
	xor a			; $4b1b
	ld l,$8e		; $4b1c
	ldi (hl),a		; $4b1e
	ld (hl),a		; $4b1f
	ld l,$80		; $4b20
	ld e,l			; $4b22
	ld a,(de)		; $4b23
	ld (hl),a		; $4b24
	ret			; $4b25

enemyCode35:
	jr z,_label_0d_068	; $4b26
	sub $03			; $4b28
	ret c			; $4b2a
	jr z,_label_0d_067	; $4b2b
	dec a			; $4b2d
	jp nz,_ecom_updateKnockbackNoSolidity		; $4b2e
	ld e,$aa		; $4b31
	ld a,(de)		; $4b33
	cp $80			; $4b34
	ret nz			; $4b36
	ld h,d			; $4b37
	ld l,$84		; $4b38
	ld (hl),$0c		; $4b3a
	ld l,$8f		; $4b3c
	ld (hl),$fb		; $4b3e
	call $4d2e		; $4b40
	add $04			; $4b43
	call enemySetAnimation		; $4b45
	ld h,d			; $4b48
	ld l,$8b		; $4b49
	ld a,($d00b)		; $4b4b
	sub (hl)		; $4b4e
	sra a			; $4b4f
	add (hl)		; $4b51
	ld (hl),a		; $4b52
	ld l,$8d		; $4b53
	ld a,($d00d)		; $4b55
	sub (hl)		; $4b58
	sra a			; $4b59
	add (hl)		; $4b5b
	ld (hl),a		; $4b5c
	ret			; $4b5d
_label_0d_067:
	ld a,$30		; $4b5e
	call objectGetRelatedObject1Var		; $4b60
	dec (hl)		; $4b63
	ld l,$b3		; $4b64
	dec (hl)		; $4b66
	jp enemyDie_uncounted		; $4b67
_label_0d_068:
	ld e,$84		; $4b6a
	ld a,(de)		; $4b6c
	rst_jumpTable			; $4b6d
	adc d			; $4b6e
	ld c,e			; $4b6f
	sbc e			; $4b70
	ld c,e			; $4b71
	push hl			; $4b72
	ld c,e			; $4b73
	push hl			; $4b74
	ld c,e			; $4b75
	push hl			; $4b76
	ld c,e			; $4b77
	push de			; $4b78
	ld c,e			; $4b79
	push hl			; $4b7a
	ld c,e			; $4b7b
	push hl			; $4b7c
	ld c,e			; $4b7d
	and $4b			; $4b7e
	ld h,e			; $4b80
	ld c,h			; $4b81
	ld (hl),a		; $4b82
	ld c,h			; $4b83
	cp c			; $4b84
	ld c,h			; $4b85
	pop af			; $4b86
	ld c,h			; $4b87
	dec e			; $4b88
	ld c,l			; $4b89
	ld h,d			; $4b8a
	ld l,$86		; $4b8b
	ld (hl),$3c		; $4b8d
	ld l,e			; $4b8f
	inc (hl)		; $4b90
	ld e,$82		; $4b91
	ld a,(de)		; $4b93
	or a			; $4b94
	jp z,$4da8		; $4b95
	ld (hl),$08		; $4b98
	ret			; $4b9a
	ld h,d			; $4b9b
	ld l,$b3		; $4b9c
	ld a,(hl)		; $4b9e
	or a			; $4b9f
	jr z,_label_0d_069	; $4ba0
	ld e,$b0		; $4ba2
	ld a,(de)		; $4ba4
	sub (hl)		; $4ba5
	ret nc			; $4ba6
	ld l,$86		; $4ba7
	dec (hl)		; $4ba9
	ret nz			; $4baa
	ld (hl),$01		; $4bab
	ld l,$b0		; $4bad
	ld a,(hl)		; $4baf
	cp $03			; $4bb0
	ret nc			; $4bb2
	ld b,$35		; $4bb3
	call _ecom_spawnUncountedEnemyWithSubid01		; $4bb5
	ret nz			; $4bb8
	ld e,$b4		; $4bb9
	ld a,(de)		; $4bbb
	ld (hl),a		; $4bbc
	ld l,$96		; $4bbd
	ld a,$80		; $4bbf
	ldi (hl),a		; $4bc1
	ld (hl),d		; $4bc2
	ld h,d			; $4bc3
	ld l,$b0		; $4bc4
	inc (hl)		; $4bc6
	ld l,$86		; $4bc7
	ld (hl),$80		; $4bc9
	ret			; $4bcb
_label_0d_069:
	call decNumEnemies		; $4bcc
	call markEnemyAsKilledInRoom		; $4bcf
	jp enemyDelete		; $4bd2
	call _ecom_galeSeedEffect		; $4bd5
	ret c			; $4bd8
	ld a,$30		; $4bd9
	call objectGetRelatedObject1Var		; $4bdb
	dec (hl)		; $4bde
	ld l,$b3		; $4bdf
	dec (hl)		; $4be1
	jp enemyDelete		; $4be2
	ret			; $4be5
	call $4d8e		; $4be6
	ld a,$00		; $4be9
	push bc			; $4beb
	call c,getRandomNumber_noPreserveVars		; $4bec
	pop bc			; $4bef
	ld e,a			; $4bf0
	ld a,($d009)		; $4bf1
	add e			; $4bf4
	and $1f			; $4bf5
	ld e,$b2		; $4bf7
	ld (de),a		; $4bf9
	ld a,$50		; $4bfa
	ldh (<hFF8A),a	; $4bfc
_label_0d_070:
	ldh a,(<hFF8A)	; $4bfe
	sub $10			; $4c00
	jr z,_label_0d_074	; $4c02
	ldh (<hFF8A),a	; $4c04
	push bc			; $4c06
	ld e,$b2		; $4c07
	call objectSetPositionInCircleArc		; $4c09
	pop bc			; $4c0c
	ld a,(de)		; $4c0d
	ld e,a			; $4c0e
	ld a,($d00d)		; $4c0f
	sub e			; $4c12
	jr nc,_label_0d_071	; $4c13
	cpl			; $4c15
	inc a			; $4c16
_label_0d_071:
	cp $80			; $4c17
	jr nc,_label_0d_070	; $4c19
	ld e,$8b		; $4c1b
	ld a,(de)		; $4c1d
	cp $b0			; $4c1e
	jr nc,_label_0d_070	; $4c20
	push bc			; $4c22
	call objectGetTileCollisions		; $4c23
	pop bc			; $4c26
	jr nz,_label_0d_070	; $4c27
	ld h,d			; $4c29
	ld l,$84		; $4c2a
	ld (hl),$09		; $4c2c
	ld l,$86		; $4c2e
	ld (hl),$20		; $4c30
	call objectGetAngleTowardEnemyTarget		; $4c32
	ld b,a			; $4c35
	ld e,$82		; $4c36
	ld a,(de)		; $4c38
	dec a			; $4c39
	ld a,b			; $4c3a
	jr nz,_label_0d_072	; $4c3b
	add $04			; $4c3d
	and $18			; $4c3f
_label_0d_072:
	ld e,$89		; $4c41
	ld (de),a		; $4c43
	cp $10			; $4c44
	ld a,$00		; $4c46
	jr nc,_label_0d_073	; $4c48
	inc a			; $4c4a
_label_0d_073:
	ld e,$b0		; $4c4b
	ld (de),a		; $4c4d
	call enemySetAnimation		; $4c4e
	call objectSetVisiblec1		; $4c51
_label_0d_074:
	ld e,$97		; $4c54
	ld a,(de)		; $4c56
	ld h,a			; $4c57
	ld l,$b1		; $4c58
	ld a,($d00b)		; $4c5a
	ldi (hl),a		; $4c5d
	ld a,($d00d)		; $4c5e
	ld (hl),a		; $4c61
	ret			; $4c62
	ld e,$a1		; $4c63
	ld a,(de)		; $4c65
	dec a			; $4c66
	jp nz,enemyAnimate		; $4c67
	ld e,$84		; $4c6a
	ld a,$0a		; $4c6c
	ld (de),a		; $4c6e
	ld e,$b0		; $4c6f
	ld a,(de)		; $4c71
	add $02			; $4c72
	jp enemySetAnimation		; $4c74
	call _ecom_decCounter1		; $4c77
	jr z,_label_0d_075	; $4c7a
	ld a,(hl)		; $4c7c
	srl a			; $4c7d
	srl a			; $4c7f
	ld hl,$4cb1		; $4c81
	rst_addAToHl			; $4c84
	ld a,(hl)		; $4c85
	ld e,$8f		; $4c86
	ld (de),a		; $4c88
	ret			; $4c89
_label_0d_075:
	ld (hl),$f0		; $4c8a
	ld l,$a4		; $4c8c
	set 7,(hl)		; $4c8e
	ld l,$84		; $4c90
	ld (hl),$0b		; $4c92
	call $4d2e		; $4c94
	ld b,a			; $4c97
	ld e,$97		; $4c98
	ld a,(de)		; $4c9a
	ld h,a			; $4c9b
	ld l,$8d		; $4c9c
	bit 5,(hl)		; $4c9e
	ld h,d			; $4ca0
	ld l,$90		; $4ca1
	ld (hl),$0f		; $4ca3
	jr z,_label_0d_076	; $4ca5
	ld (hl),$19		; $4ca7
_label_0d_076:
	ld a,b			; $4ca9
	add $02			; $4caa
	call enemySetAnimation		; $4cac
	jr _label_0d_079		; $4caf
	ei			; $4cb1
.DB $fc				; $4cb2
.DB $fd				; $4cb3
.DB $fd				; $4cb4
	cp $fe			; $4cb5
	rst $38			; $4cb7
	rst $38			; $4cb8
	call _ecom_decCounter1		; $4cb9
	jr nz,_label_0d_077	; $4cbc
	ld l,$8f		; $4cbe
	ld (hl),$00		; $4cc0
	ld l,$a4		; $4cc2
	res 7,(hl)		; $4cc4
	ld l,e			; $4cc6
	ld (hl),$0d		; $4cc7
	ld l,$b0		; $4cc9
	ld a,$06		; $4ccb
	add (hl)		; $4ccd
	jp enemySetAnimation		; $4cce
_label_0d_077:
	ld e,$b0		; $4cd1
	ld a,(de)		; $4cd3
	ldh (<hFF8D),a	; $4cd4
	call $4d2e		; $4cd6
	ld b,a			; $4cd9
	ldh a,(<hFF8D)	; $4cda
	cp b			; $4cdc
	jr z,_label_0d_078	; $4cdd
	ld a,$02		; $4cdf
	add b			; $4ce1
	call enemySetAnimation		; $4ce2
_label_0d_078:
	call $4d70		; $4ce5
	call $4dbe		; $4ce8
	call _ecom_applyVelocityGivenAdjacentWalls		; $4ceb
_label_0d_079:
	jp enemyAnimate		; $4cee
	ld e,$a1		; $4cf1
	ld a,(de)		; $4cf3
	dec a			; $4cf4
	jr z,_label_0d_080	; $4cf5
	dec a			; $4cf7
	jr z,_label_0d_081	; $4cf8
	dec a			; $4cfa
	jr nz,_label_0d_079	; $4cfb
	ld a,$02		; $4cfd
	ld ($d005),a		; $4cff
	jp objectSetInvisible		; $4d02
_label_0d_080:
	ld (de),a		; $4d05
	ld ($d01a),a		; $4d06
	ld e,$8b		; $4d09
	ld a,($d00b)		; $4d0b
	ld (de),a		; $4d0e
	ld e,$8d		; $4d0f
	ld a,($d00d)		; $4d11
	ld (de),a		; $4d14
	ret			; $4d15
_label_0d_081:
	xor a			; $4d16
	ld (de),a		; $4d17
	ld e,$8f		; $4d18
	ld (de),a		; $4d1a
	jr _label_0d_079		; $4d1b
	ld e,$a1		; $4d1d
	ld a,(de)		; $4d1f
	cp $03			; $4d20
	jr nz,_label_0d_079	; $4d22
	ld e,$97		; $4d24
	ld a,(de)		; $4d26
	ld h,a			; $4d27
	ld l,$b0		; $4d28
	dec (hl)		; $4d2a
	jp enemyDelete		; $4d2b
	call $4d67		; $4d2e
	ret nc			; $4d31
	call objectGetAngleTowardLink		; $4d32
	ld b,a			; $4d35
	and $0f			; $4d36
	jr nz,_label_0d_082	; $4d38
	ld e,$89		; $4d3a
	ld a,b			; $4d3c
	ld (de),a		; $4d3d
	ld e,$b0		; $4d3e
	ld a,(de)		; $4d40
	ret			; $4d41
_label_0d_082:
	ld e,$82		; $4d42
	ld a,(de)		; $4d44
	dec a			; $4d45
	ld a,b			; $4d46
	jr nz,_label_0d_084	; $4d47
	ld e,$89		; $4d49
	and $f8			; $4d4b
	ld (de),a		; $4d4d
	cp $10			; $4d4e
	ld a,$00		; $4d50
	jr nc,_label_0d_083	; $4d52
	inc a			; $4d54
_label_0d_083:
	ld e,$b0		; $4d55
	ld (de),a		; $4d57
	ret			; $4d58
_label_0d_084:
	ld e,$89		; $4d59
	ld (de),a		; $4d5b
	cp $10			; $4d5c
	ld a,$00		; $4d5e
	jr nc,_label_0d_085	; $4d60
	inc a			; $4d62
_label_0d_085:
	ld e,$b0		; $4d63
	ld (de),a		; $4d65
	ret			; $4d66
	ld a,($d024)		; $4d67
	rlca			; $4d6a
	ret c			; $4d6b
	ld e,$b0		; $4d6c
	ld a,(de)		; $4d6e
	ret			; $4d6f
	ld e,$86		; $4d70
	ld a,(de)		; $4d72
	and $07			; $4d73
	ret nz			; $4d75
	ld e,$b1		; $4d76
	ld a,(de)		; $4d78
	inc a			; $4d79
	and $07			; $4d7a
	ld (de),a		; $4d7c
	ld hl,$4d86		; $4d7d
	rst_addAToHl			; $4d80
	ld e,$8f		; $4d81
	ld a,(hl)		; $4d83
	ld (de),a		; $4d84
	ret			; $4d85
	ei			; $4d86
.DB $fc				; $4d87
.DB $fd				; $4d88
.DB $fc				; $4d89
	ei			; $4d8a
	ld a,($faf9)		; $4d8b
	ld a,$31		; $4d8e
	call objectGetRelatedObject1Var		; $4d90
	ld a,($d00b)		; $4d93
	ld b,a			; $4d96
	sub (hl)		; $4d97
	add $08			; $4d98
	cp $10			; $4d9a
	ld a,($d00d)		; $4d9c
	ld c,a			; $4d9f
	ret nc			; $4da0
	inc l			; $4da1
	sub (hl)		; $4da2
	add $08			; $4da3
	cp $10			; $4da5
	ret			; $4da7
	ld e,$8b		; $4da8
	ld a,(de)		; $4daa
	and $f0			; $4dab
	swap a			; $4dad
	ld e,$b3		; $4daf
	ld (de),a		; $4db1
	ld e,$8d		; $4db2
	ld a,(de)		; $4db4
	and $f0			; $4db5
	swap a			; $4db7
	inc a			; $4db9
	ld e,$b4		; $4dba
	ld (de),a		; $4dbc
	ret			; $4dbd
	ld a,$02		; $4dbe
	jp _ecom_getTopDownAdjacentWallsBitset		; $4dc0

enemyCode36:
	jr z,_label_0d_086	; $4dc3
	ld h,d			; $4dc5
	ld l,$aa		; $4dc6
	ld a,(hl)		; $4dc8
	cp $9a			; $4dc9
	jp z,$4fbb		; $4dcb
	cp $9e			; $4dce
	jp nz,$4f96		; $4dd0
_label_0d_086:
	call $4f68		; $4dd3
	ld e,$84		; $4dd6
	ld a,(de)		; $4dd8
	rst_jumpTable			; $4dd9
	ld a,($ff00+c)		; $4dda
	ld c,l			; $4ddb
	ld h,h			; $4ddc
	ld c,(hl)		; $4ddd
.DB $fc				; $4dde
	ld c,l			; $4ddf
	ld h,h			; $4de0
	ld c,(hl)		; $4de1
	ld h,h			; $4de2
	ld c,(hl)		; $4de3
	bit 0,h			; $4de4
	ld h,h			; $4de6
	ld c,(hl)		; $4de7
	ld h,h			; $4de8
	ld c,(hl)		; $4de9
	ld h,l			; $4dea
	ld c,(hl)		; $4deb
	add e			; $4dec
	ld c,(hl)		; $4ded
	xor h			; $4dee
	ld c,(hl)		; $4def
	cp d			; $4df0
	ld c,(hl)		; $4df1
	ld a,$14		; $4df2
	call _ecom_setSpeedAndState8AndVisible		; $4df4
	ld l,$bf		; $4df7
	set 5,(hl)		; $4df9
	ret			; $4dfb
	inc e			; $4dfc
	ld a,(de)		; $4dfd
	rst_jumpTable			; $4dfe
	rlca			; $4dff
	ld c,(hl)		; $4e00
	ldi a,(hl)		; $4e01
	ld c,(hl)		; $4e02
	ld a,$4e		; $4e03
	ld d,b			; $4e05
	ld c,(hl)		; $4e06
	ld h,d			; $4e07
	ld l,e			; $4e08
	inc (hl)		; $4e09
	ld l,$a4		; $4e0a
	res 7,(hl)		; $4e0c
	ld l,$b2		; $4e0e
	xor a			; $4e10
	ld (hl),a		; $4e11
	ld (wLinkGrabState2),a		; $4e12
	ld a,($d008)		; $4e15
	srl a			; $4e18
	xor $01			; $4e1a
	ld l,$88		; $4e1c
	ld (hl),a		; $4e1e
	call enemySetAnimation		; $4e1f
	ld a,$a0		; $4e22
	call playSound		; $4e24
	jp objectSetVisiblec1		; $4e27
	call $4fe6		; $4e2a
	ld h,d			; $4e2d
	ld l,$88		; $4e2e
	ld a,($d008)		; $4e30
	srl a			; $4e33
	xor $01			; $4e35
	cp (hl)			; $4e37
	jr z,_label_0d_087	; $4e38
	ld (hl),a		; $4e3a
	jp enemySetAnimation		; $4e3b
_label_0d_087:
	ld e,$8b		; $4e3e
	ld a,(de)		; $4e40
	cp $80			; $4e41
	jr nc,_label_0d_088	; $4e43
	ld e,$8d		; $4e45
	ld a,(de)		; $4e47
	cp $a0			; $4e48
	jp c,enemyAnimate		; $4e4a
_label_0d_088:
	jp enemyDelete		; $4e4d
	ld h,d			; $4e50
	ld l,$84		; $4e51
	ld (hl),$0a		; $4e53
	ld l,$a4		; $4e55
	set 7,(hl)		; $4e57
	ld l,$90		; $4e59
	ld (hl),$28		; $4e5b
	ld l,$86		; $4e5d
	ld (hl),$01		; $4e5f
	jp objectSetVisiblec2		; $4e61
	ret			; $4e64
	call objectAddToGrabbableObjectBuffer		; $4e65
	ld e,$3f		; $4e68
	ld bc,$031f		; $4e6a
	call _ecom_randomBitwiseAndBCE		; $4e6d
	or e			; $4e70
	ret nz			; $4e71
	call _ecom_incState		; $4e72
	ld l,$86		; $4e75
	ldi (hl),a		; $4e77
	ld a,$02		; $4e78
	add b			; $4e7a
	ld (hl),a		; $4e7b
	ld l,$89		; $4e7c
	ld a,c			; $4e7e
	ld (hl),a		; $4e7f
	jp $4f44		; $4e80
	call objectAddToGrabbableObjectBuffer		; $4e83
	ld h,d			; $4e86
	ld l,$86		; $4e87
	ld a,(hl)		; $4e89
	and $0f			; $4e8a
	inc (hl)		; $4e8c
	ld hl,$4f58		; $4e8d
	rst_addAToHl			; $4e90
	ld e,$8f		; $4e91
	ld a,(hl)		; $4e93
	ld (de),a		; $4e94
	or a			; $4e95
	jr nz,_label_0d_089	; $4e96
	call _ecom_decCounter2		; $4e98
	jr nz,_label_0d_089	; $4e9b
	ld l,$84		; $4e9d
	dec (hl)		; $4e9f
_label_0d_089:
	call _ecom_bounceOffWallsAndHoles		; $4ea0
	call nz,$4f44		; $4ea3
	call objectApplySpeed		; $4ea6
_label_0d_090:
	jp enemyAnimate		; $4ea9
	call objectAddToGrabbableObjectBuffer		; $4eac
	call _ecom_updateCardinalAngleAwayFromTarget		; $4eaf
	call $4f44		; $4eb2
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4eb5
	jr _label_0d_090		; $4eb8
	ld a,$21		; $4eba
	call objectGetRelatedObject1Var		; $4ebc
	bit 7,(hl)		; $4ebf
	ret z			; $4ec1
	ld e,$b1		; $4ec2
	ld a,(de)		; $4ec4
	ld b,a			; $4ec5
	ld c,$00		; $4ec6
	jp objectReplaceWithID		; $4ec8

enemyCode3b:
	jr z,_label_0d_091	; $4ecb
	sub $03			; $4ecd
	ret c			; $4ecf
	ld e,$aa		; $4ed0
	ld a,(de)		; $4ed2
	res 7,a			; $4ed3
	cp $04			; $4ed5
	jr c,_label_0d_091	; $4ed7
	ld h,d			; $4ed9
	ld l,$b0		; $4eda
	inc (hl)		; $4edc
	ld l,$a9		; $4edd
	ld (hl),$40		; $4edf
	ld l,$84		; $4ee1
	ld a,(hl)		; $4ee3
	cp $0a			; $4ee4
	jr nc,_label_0d_091	; $4ee6
	ld (hl),$0a		; $4ee8
	ld l,$8f		; $4eea
	ld (hl),$00		; $4eec
_label_0d_091:
	ld e,$84		; $4eee
	ld a,(de)		; $4ef0
	rst_jumpTable			; $4ef1
	ld a,(bc)		; $4ef2
	ld c,a			; $4ef3
	ld h,h			; $4ef4
	ld c,(hl)		; $4ef5
.DB $fc				; $4ef6
	ld c,l			; $4ef7
	ld h,h			; $4ef8
	ld c,(hl)		; $4ef9
	ld h,h			; $4efa
	ld c,(hl)		; $4efb
	ld h,h			; $4efc
	ld c,(hl)		; $4efd
	ld h,h			; $4efe
	ld c,(hl)		; $4eff
	ld h,h			; $4f00
	ld c,(hl)		; $4f01
	ld h,l			; $4f02
	ld c,(hl)		; $4f03
	add e			; $4f04
	ld c,(hl)		; $4f05
	rla			; $4f06
	ld c,a			; $4f07
	dec (hl)		; $4f08
	ld c,a			; $4f09
	ld a,$1e		; $4f0a
	call _ecom_setSpeedAndState8		; $4f0c
	ld a,$30		; $4f0f
	call setScreenShakeCounter		; $4f11
	jp objectSetVisiblec1		; $4f14
	ld e,$b0		; $4f17
	ld a,(de)		; $4f19
	cp $08			; $4f1a
	jr c,_label_0d_092	; $4f1c
	call _ecom_incState		; $4f1e
	ld l,$b2		; $4f21
	ld (hl),$00		; $4f23
	ld a,$8d		; $4f25
	jp playSound		; $4f27
_label_0d_092:
	call _ecom_updateCardinalAngleAwayFromTarget		; $4f2a
	call $4f44		; $4f2d
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4f30
	jr _label_0d_093		; $4f33
	call objectGetAngleTowardEnemyTarget		; $4f35
	call objectNudgeAngleTowards		; $4f38
	call $4f44		; $4f3b
	call objectApplySpeed		; $4f3e
_label_0d_093:
	jp enemyAnimate		; $4f41
	ld h,d			; $4f44
	ld l,$89		; $4f45
	ld a,(hl)		; $4f47
	and $0f			; $4f48
	ret z			; $4f4a
	ldd a,(hl)		; $4f4b
	and $10			; $4f4c
	swap a			; $4f4e
	xor $01			; $4f50
	cp (hl)			; $4f52
	ret z			; $4f53
	ld (hl),a		; $4f54
	jp enemySetAnimation		; $4f55
	nop			; $4f58
	rst $38			; $4f59
	rst $38			; $4f5a
	cp $fe			; $4f5b
	cp $fd			; $4f5d
.DB $fd				; $4f5f
.DB $fd				; $4f60
.DB $fd				; $4f61
	cp $fe			; $4f62
	cp $ff			; $4f64
	rst $38			; $4f66
	nop			; $4f67
	ld h,d			; $4f68
	ld l,$b3		; $4f69
	ld a,(hl)		; $4f6b
	or a			; $4f6c
	jr z,_label_0d_094	; $4f6d
	dec (hl)		; $4f6f
	ret nz			; $4f70
_label_0d_094:
	ld l,$b0		; $4f71
	ld a,(hl)		; $4f73
	cp $10			; $4f74
	ret c			; $4f76
	ld b,$22		; $4f77
	call _ecom_spawnProjectile		; $4f79
	ld e,$b0		; $4f7c
	ld a,(de)		; $4f7e
	sub $10			; $4f7f
	and $1e			; $4f81
	rrca			; $4f83
	ld hl,$4f8d		; $4f84
	rst_addAToHl			; $4f87
	ld e,$b3		; $4f88
	ld a,(hl)		; $4f8a
	ld (de),a		; $4f8b
	ret			; $4f8c
	ld e,$1a		; $4f8d
	jr $16			; $4f8f
	inc d			; $4f91
	ld (de),a		; $4f92
	stop			; $4f93
	ld c,$0c		; $4f94
	ld l,$a9		; $4f96
	ld (hl),$40		; $4f98
	ld l,$84		; $4f9a
	ld a,$0a		; $4f9c
	cp (hl)			; $4f9e
	jr z,_label_0d_095	; $4f9f
	ld (hl),a		; $4fa1
	ld l,$90		; $4fa2
	ld (hl),$28		; $4fa4
	ld l,$8f		; $4fa6
	ld (hl),$00		; $4fa8
_label_0d_095:
	ld e,$aa		; $4faa
	ld a,(de)		; $4fac
	rlca			; $4fad
	ret nc			; $4fae
	ld l,$b0		; $4faf
	bit 5,(hl)		; $4fb1
	jr nz,_label_0d_096	; $4fb3
	inc (hl)		; $4fb5
_label_0d_096:
	ld a,$a0		; $4fb6
	jp playSound		; $4fb8
	ld l,$a4		; $4fbb
	res 7,(hl)		; $4fbd
	ld l,$b0		; $4fbf
	ld a,(hl)		; $4fc1
	cp $10			; $4fc2
	jr c,_label_0d_097	; $4fc4
	ld a,$3b		; $4fc6
	jr _label_0d_098		; $4fc8
_label_0d_097:
	ld a,$33		; $4fca
_label_0d_098:
	ld e,$b1		; $4fcc
	ld (de),a		; $4fce
	ld bc,$0502		; $4fcf
	call objectCreateInteraction		; $4fd2
	ret nz			; $4fd5
	ld e,$96		; $4fd6
	ld a,$40		; $4fd8
	ld (de),a		; $4fda
	inc e			; $4fdb
	ld a,h			; $4fdc
	ld (de),a		; $4fdd
	ld e,$84		; $4fde
	ld a,$0b		; $4fe0
	ld (de),a		; $4fe2
	jp objectSetInvisible		; $4fe3
	ld h,d			; $4fe6
	ld l,$ab		; $4fe7
	ld a,(hl)		; $4fe9
	or a			; $4fea
	ret nz			; $4feb
	ld l,$b2		; $4fec
	dec (hl)		; $4fee
	ld a,(hl)		; $4fef
	and $1f			; $4ff0
	ret nz			; $4ff2
	ld a,$a0		; $4ff3
	jp playSound		; $4ff5

enemyCode37:
	ld e,$84		; $4ff8
	ld a,(de)		; $4ffa
	rst_jumpTable			; $4ffb
	nop			; $4ffc
	ld d,b			; $4ffd
	inc d			; $4ffe
	ld d,b			; $4fff
	ld a,($cc4e)		; $5000
	or a			; $5003
	jp nz,enemyDelete		; $5004
	ld h,d			; $5007
	ld l,e			; $5008
	inc (hl)		; $5009
	ld l,$90		; $500a
	ld (hl),$0a		; $500c
	call _ecom_setRandomAngle		; $500e
	jp objectSetVisible81		; $5011
	ld bc,$1f1f		; $5014
	call _ecom_randomBitwiseAndBCE		; $5017
	or b			; $501a
	jr nz,_label_0d_099	; $501b
	ld h,d			; $501d
	ld l,$89		; $501e
	ld (hl),c		; $5020
_label_0d_099:
	call objectApplySpeed		; $5021
	call _ecom_bounceOffScreenBoundary		; $5024
	jp enemyAnimate		; $5027

enemyCode38:
	ld e,$84		; $502a
	ld a,(de)		; $502c
	rst_jumpTable			; $502d
	ld b,d			; $502e
	ld d,b			; $502f
	ld c,d			; $5030
	ld d,b			; $5031
	ld e,e			; $5032
	ld d,b			; $5033
	ld h,(hl)		; $5034
	ld d,b			; $5035
	and h			; $5036
	ld d,b			; $5037
	xor (hl)		; $5038
	ld d,b			; $5039
	ret			; $503a
	ld d,b			; $503b
.DB $db				; $503c
	ld d,b			; $503d
.DB $eb				; $503e
	ld d,b			; $503f
	nop			; $5040
	ld d,c			; $5041
	ld h,d			; $5042
	ld l,e			; $5043
	inc (hl)		; $5044
	ld l,$8f		; $5045
	ld (hl),$f0		; $5047
	ret			; $5049
	call $515a		; $504a
	ret nz			; $504d
	ld l,$84		; $504e
	inc (hl)		; $5050
	ld l,$86		; $5051
	ld (hl),$11		; $5053
	ld a,$0f		; $5055
	ld (wActiveMusic),a		; $5057
	ret			; $505a
	ld a,$21		; $505b
	call objectGetRelatedObject2Var		; $505d
	bit 7,(hl)		; $5060
	ret z			; $5062
	call _ecom_incState		; $5063
	call $5130		; $5066
	jr nc,_label_0d_101	; $5069
	ld a,$80		; $506b
	ld ($cc02),a		; $506d
	ld a,$21		; $5070
	ld ($cca4),a		; $5072
	ld hl,$c6a2		; $5075
	ldi a,(hl)		; $5078
	cp (hl)			; $5079
	ld a,$04		; $507a
	ld bc,$4100		; $507c
	jr nz,_label_0d_100	; $507f
	ld e,$86		; $5081
	ld a,$1e		; $5083
	ld (de),a		; $5085
	ld a,$08		; $5086
	ld bc,$4105		; $5088
_label_0d_100:
	ld e,$84		; $508b
	ld (de),a		; $508d
	call showText		; $508e
_label_0d_101:
	call $5114		; $5091
	call enemyAnimate		; $5094
	ld e,$8b		; $5097
	ld a,(de)		; $5099
	ld b,a			; $509a
	ldh a,(<hEnemyTargetY)	; $509b
	cp b			; $509d
	jp c,objectSetVisiblec1		; $509e
	jp objectSetVisiblec2		; $50a1
	ld h,d			; $50a4
	ld l,e			; $50a5
	inc (hl)		; $50a6
	ld l,$86		; $50a7
	ld (hl),$0c		; $50a9
	inc l			; $50ab
	ld (hl),$09		; $50ac
	call $516a		; $50ae
	call _ecom_decCounter1		; $50b1
	jr nz,_label_0d_101	; $50b4
	ld (hl),$0c		; $50b6
	inc l			; $50b8
	dec (hl)		; $50b9
	jr z,_label_0d_102	; $50ba
	call $5149		; $50bc
	jr _label_0d_101		; $50bf
_label_0d_102:
	dec l			; $50c1
	ld (hl),$1e		; $50c2
	ld l,$84		; $50c4
	inc (hl)		; $50c6
	jr _label_0d_101		; $50c7
	call $516a		; $50c9
	call _ecom_decCounter1		; $50cc
	jr nz,_label_0d_101	; $50cf
	ld l,$84		; $50d1
	inc (hl)		; $50d3
	ld a,$29		; $50d4
	ld c,$40		; $50d6
	call giveTreasure		; $50d8
	call $516a		; $50db
	ld e,$b1		; $50de
	ld a,(de)		; $50e0
	or a			; $50e1
	jr nz,_label_0d_101	; $50e2
	call _ecom_incState		; $50e4
	ld l,$86		; $50e7
	ld (hl),$1e		; $50e9
	call _ecom_decCounter1		; $50eb
	jr nz,_label_0d_101	; $50ee
	ld (hl),$3c		; $50f0
	ld l,e			; $50f2
	inc (hl)		; $50f3
	xor a			; $50f4
	ld ($cca4),a		; $50f5
	ld ($cc02),a		; $50f8
	ld a,$91		; $50fb
	call playSound		; $50fd
	call _ecom_decCounter1		; $5100
	jp z,enemyDelete		; $5103
	call $5091		; $5106
	ld h,d			; $5109
	ld l,$86		; $510a
	bit 0,(hl)		; $510c
	ret nz			; $510e
	ld l,$9a		; $510f
	res 7,(hl)		; $5111
	ret			; $5113
	ld h,d			; $5114
	ld l,$b0		; $5115
	dec (hl)		; $5117
	ld a,(hl)		; $5118
	and $07			; $5119
	ret nz			; $511b
	ld a,(hl)		; $511c
	and $18			; $511d
	swap a			; $511f
	rlca			; $5121
	sub $02			; $5122
	bit 5,(hl)		; $5124
	jr nz,_label_0d_103	; $5126
	cpl			; $5128
	inc a			; $5129
_label_0d_103:
	sub $10			; $512a
	ld l,$8f		; $512c
	ld (hl),a		; $512e
	ret			; $512f
	call checkLinkVulnerable		; $5130
	ret nc			; $5133
	ld h,d			; $5134
	ld l,$8b		; $5135
	ldh a,(<hEnemyTargetY)	; $5137
	sub (hl)		; $5139
	sub $10			; $513a
	cp $21			; $513c
	ret nc			; $513e
	ld l,$8d		; $513f
	ldh a,(<hEnemyTargetX)	; $5141
	sub (hl)		; $5143
	add $18			; $5144
	cp $31			; $5146
	ret			; $5148
	call getFreePartSlot		; $5149
	ret nz			; $514c
	ld (hl),$30		; $514d
	ld l,$d6		; $514f
	ld a,$80		; $5151
	ldi (hl),a		; $5153
	ld (hl),d		; $5154
	ld h,d			; $5155
	ld l,$b1		; $5156
	inc (hl)		; $5158
	ret			; $5159
	ld bc,$0502		; $515a
	call objectCreateInteraction		; $515d
	ret nz			; $5160
	ld a,h			; $5161
	ld h,d			; $5162
	ld l,$99		; $5163
	ldd (hl),a		; $5165
	ld (hl),$40		; $5166
	xor a			; $5168
	ret			; $5169
	ld a,(wFrameCounter)		; $516a
	and $07			; $516d
	ret nz			; $516f
	ld a,$8c		; $5170
	jp playSound		; $5172

enemyCode39:
	jr z,_label_0d_104	; $5175
	sub $03			; $5177
	ret c			; $5179
	jp z,enemyDie		; $517a
	dec a			; $517d
	jp nz,_ecom_updateKnockbackNoSolidity		; $517e
	ld e,$aa		; $5181
	ld a,(de)		; $5183
	cp $80			; $5184
	ret nz			; $5186
	ld e,$b3		; $5187
	ld a,(de)		; $5189
	or a			; $518a
	ret nz			; $518b
	ld b,$20		; $518c
	call _ecom_spawnProjectile		; $518e
	ld h,d			; $5191
	ld l,$9c		; $5192
	ld a,$01		; $5194
	ldd (hl),a		; $5196
	ld (hl),a		; $5197
	ld l,$84		; $5198
	ld (hl),$08		; $519a
	ld l,$a8		; $519c
	ld (hl),$fc		; $519e
	ld l,$b3		; $51a0
	ld (hl),$02		; $51a2
	ld l,$90		; $51a4
	ld (hl),$1e		; $51a6
	ld a,$03		; $51a8
	jp enemySetAnimation		; $51aa
_label_0d_104:
	call _ecom_getSubidAndCpStateTo08		; $51ad
	cp $0b			; $51b0
	jr nc,_label_0d_105	; $51b2
	rst_jumpTable			; $51b4
	pop de			; $51b5
	ld d,c			; $51b6
	ld ($0852),sp		; $51b7
	ld d,d			; $51ba
	ld ($0852),sp		; $51bb
	ld d,d			; $51be
	bit 0,h			; $51bf
	ld ($0852),sp		; $51c1
	ld d,d			; $51c4
	add hl,bc		; $51c5
	ld d,d			; $51c6
	ld b,l			; $51c7
	ld d,d			; $51c8
	ld l,h			; $51c9
	ld d,d			; $51ca
_label_0d_105:
	ld a,b			; $51cb
	rst_jumpTable			; $51cc
	and d			; $51cd
	ld d,d			; $51ce
	jr z,_label_0d_109	; $51cf
	ld h,d			; $51d1
	ld l,$86		; $51d2
	ld (hl),$08		; $51d4
	ld l,$a8		; $51d6
	ld (hl),$f8		; $51d8
	bit 0,b			; $51da
	ld l,e			; $51dc
	jr z,_label_0d_106	; $51dd
	ld (hl),$0b		; $51df
	jp objectSetVisible82		; $51e1
_label_0d_106:
	ld (hl),$0b		; $51e4
	ld l,$8f		; $51e6
	ld (hl),$e4		; $51e8
	ld l,$90		; $51ea
	ld (hl),$14		; $51ec
	ld bc,$1f01		; $51ee
	call _ecom_randomBitwiseAndBCE		; $51f1
	ld e,$89		; $51f4
	ld a,b			; $51f6
	ld (de),a		; $51f7
	ld a,c			; $51f8
	or a			; $51f9
	jr nz,_label_0d_107	; $51fa
	dec a			; $51fc
_label_0d_107:
	ld e,$b5		; $51fd
	ld (de),a		; $51ff
	ld a,$01		; $5200
	call enemySetAnimation		; $5202
	jp objectSetVisiblec1		; $5205
	ret			; $5208
	ld e,$b0		; $5209
	ld a,$ff		; $520b
	ld (de),a		; $520d
	call objectGetTileAtPosition		; $520e
	ld c,l			; $5211
	ld l,$00		; $5212
_label_0d_108:
	ld a,(hl)		; $5214
	cp $09			; $5215
	call z,$53ea		; $5217
	inc l			; $521a
	ld a,l			; $521b
	cp $b0			; $521c
	jr c,_label_0d_108	; $521e
	ld e,$b0		; $5220
	ld a,(de)		; $5222
	inc a			; $5223
_label_0d_109:
	ld h,d			; $5224
	jr nz,_label_0d_111	; $5225
	ld l,$82		; $5227
	bit 0,(hl)		; $5229
	ld a,$0d		; $522b
	jr z,_label_0d_110	; $522d
	ld l,$86		; $522f
	ld (hl),$78		; $5231
	ld a,$0c		; $5233
_label_0d_110:
	ld l,$84		; $5235
	ld (hl),a		; $5237
	ret			; $5238
_label_0d_111:
	ld l,$84		; $5239
	inc (hl)		; $523b
	ld l,$90		; $523c
	ld (hl),$1e		; $523e
	ld a,$03		; $5240
	jp enemySetAnimation		; $5242
	ld h,d			; $5245
	ld l,$b1		; $5246
	call _ecom_readPositionVars		; $5248
	cp c			; $524b
	jr nz,_label_0d_112	; $524c
	ldh a,(<hFF8F)	; $524e
	cp b			; $5250
	jr z,_label_0d_113	; $5251
_label_0d_112:
	call $544d		; $5253
	call _ecom_moveTowardPosition		; $5256
	jp enemyAnimate		; $5259
_label_0d_113:
	call $544d		; $525c
	ret c			; $525f
	ld l,$84		; $5260
	inc (hl)		; $5262
	ld l,$86		; $5263
	ld (hl),$3c		; $5265
	ld a,$02		; $5267
	jp enemySetAnimation		; $5269
	call _ecom_decCounter1		; $526c
	jr z,_label_0d_114	; $526f
	ld a,(hl)		; $5271
	sub $1e			; $5272
	ret nz			; $5274
	ld l,$9c		; $5275
	ld a,$05		; $5277
	ldd (hl),a		; $5279
	ld (hl),a		; $527a
	ld l,$a8		; $527b
	ld (hl),$f8		; $527d
	ld l,$b3		; $527f
	xor a			; $5281
	ld (hl),a		; $5282
	jp enemySetAnimation		; $5283
_label_0d_114:
	ld l,$89		; $5286
	ld a,(hl)		; $5288
	add $10			; $5289
	and $1f			; $528b
	ld (hl),a		; $528d
	ld l,$82		; $528e
	bit 0,(hl)		; $5290
	ld a,$0d		; $5292
	jr z,_label_0d_115	; $5294
	ld l,$86		; $5296
	ld (hl),$78		; $5298
	ld a,$0c		; $529a
_label_0d_115:
	ld (de),a		; $529c
	ld a,$01		; $529d
	jp enemySetAnimation		; $529f
	call $5422		; $52a2
	ld e,$84		; $52a5
	ld a,(de)		; $52a7
	sub $0b			; $52a8
	rst_jumpTable			; $52aa
	or c			; $52ab
	ld d,d			; $52ac
	reti			; $52ad
	ld d,d			; $52ae
	inc c			; $52af
	ld d,e			; $52b0
	call $53d5		; $52b1
	jr nc,_label_0d_116	; $52b4
	ld l,$84		; $52b6
	inc (hl)		; $52b8
	ld l,$86		; $52b9
	ld (hl),$5b		; $52bb
	ld l,$90		; $52bd
	ld (hl),$19		; $52bf
_label_0d_116:
	call _ecom_decCounter1		; $52c1
	jr nz,_label_0d_117	; $52c4
	ld (hl),$08		; $52c6
	ld e,$b5		; $52c8
	ld a,(de)		; $52ca
	ld l,$89		; $52cb
	add (hl)		; $52cd
	and $1f			; $52ce
	ld (hl),a		; $52d0
_label_0d_117:
	call objectApplySpeed		; $52d1
	call $5461		; $52d4
	jr _label_0d_120		; $52d7
	call _ecom_decCounter1		; $52d9
	jr nz,_label_0d_118	; $52dc
	ld l,$84		; $52de
	inc (hl)		; $52e0
	jr _label_0d_120		; $52e1
_label_0d_118:
	ld a,(hl)		; $52e3
	and $f0			; $52e4
	swap a			; $52e6
	ld hl,$5486		; $52e8
	rst_addAToHl			; $52eb
	ld e,$8e		; $52ec
	ld a,(de)		; $52ee
	add (hl)		; $52ef
	ld (de),a		; $52f0
	inc e			; $52f1
	ld a,(de)		; $52f2
	adc $00			; $52f3
	ld (de),a		; $52f5
	call objectGetAngleTowardEnemyTarget		; $52f6
	ld b,a			; $52f9
	ld e,$86		; $52fa
	ld a,(de)		; $52fc
	and $03			; $52fd
	ld a,b			; $52ff
	call z,objectNudgeAngleTowards		; $5300
_label_0d_119:
	call _ecom_bounceOffScreenBoundary		; $5303
	call objectApplySpeed		; $5306
_label_0d_120:
	jp enemyAnimate		; $5309
	ld h,d			; $530c
	ld l,$8e		; $530d
	ld a,(hl)		; $530f
	sub $40			; $5310
	ldi (hl),a		; $5312
	ld a,(hl)		; $5313
	sbc $00			; $5314
	ld (hl),a		; $5316
	cp $e4			; $5317
	jr nc,_label_0d_119	; $5319
	ld l,e			; $531b
	ld (hl),$0b		; $531c
	ld l,$90		; $531e
	ld (hl),$14		; $5320
	ld l,$86		; $5322
	ld (hl),$08		; $5324
	jr _label_0d_120		; $5326
	call $5422		; $5328
	ld e,$84		; $532b
	ld a,(de)		; $532d
	sub $0b			; $532e
	rst_jumpTable			; $5330
	scf			; $5331
	ld d,e			; $5332
	ld h,h			; $5333
	ld d,e			; $5334
	add e			; $5335
	ld d,e			; $5336
	call _ecom_decCounter1		; $5337
	ret nz			; $533a
	ld l,e			; $533b
	inc (hl)		; $533c
	ld l,$90		; $533d
	ld (hl),$1e		; $533f
	ld bc,$1f3f		; $5341
	call _ecom_randomBitwiseAndBCE		; $5344
	ld e,$89		; $5347
	ld a,b			; $5349
	ld (de),a		; $534a
	ld a,$c0		; $534b
	add c			; $534d
	ld e,$86		; $534e
	ld (de),a		; $5350
	ld e,$b3		; $5351
	ld a,(de)		; $5353
	inc a			; $5354
	call enemySetAnimation		; $5355
	ld e,$b3		; $5358
	ld a,(de)		; $535a
	or a			; $535b
	ld b,$20		; $535c
	call z,_ecom_spawnProjectile		; $535e
	jp enemyAnimate		; $5361
	call $5303		; $5364
	ld a,(wFrameCounter)		; $5367
	and $01			; $536a
	ret nz			; $536c
	call _ecom_decCounter1		; $536d
	jr z,_label_0d_121	; $5370
	ld bc,$0f1f		; $5372
	call _ecom_randomBitwiseAndBCE		; $5375
	or b			; $5378
	ret nz			; $5379
	ld e,$89		; $537a
	ld a,c			; $537c
	ld (de),a		; $537d
	ret			; $537e
_label_0d_121:
	ld l,$84		; $537f
	inc (hl)		; $5381
	ret			; $5382
	ld e,$86		; $5383
	ld a,(de)		; $5385
	cp $68			; $5386
	jr nc,_label_0d_122	; $5388
	call _ecom_bounceOffScreenBoundary		; $538a
	call objectApplySpeed		; $538d
_label_0d_122:
	call $53b0		; $5390
	ld h,d			; $5393
	ld l,$86		; $5394
	inc (hl)		; $5396
	ld a,$7f		; $5397
	cp (hl)			; $5399
	ret nz			; $539a
	ld l,$84		; $539b
	ld (hl),$0b		; $539d
	ld e,$b3		; $539f
	ld a,(de)		; $53a1
	call enemySetAnimation		; $53a2
	call getRandomNumber_noPreserveVars		; $53a5
	and $7f			; $53a8
	ld e,$86		; $53aa
	add $20			; $53ac
	ld (de),a		; $53ae
	ret			; $53af
	ld e,$86		; $53b0
	ld a,(de)		; $53b2
	and $0f			; $53b3
	jr nz,_label_0d_123	; $53b5
	ld a,(de)		; $53b7
	swap a			; $53b8
	ld hl,$548c		; $53ba
	rst_addAToHl			; $53bd
	ld e,$90		; $53be
	ld a,(hl)		; $53c0
	ld (de),a		; $53c1
_label_0d_123:
	ld e,$86		; $53c2
	ld a,(de)		; $53c4
	and $f0			; $53c5
	swap a			; $53c7
	ld hl,$5494		; $53c9
	rst_addAToHl			; $53cc
	ld a,(wFrameCounter)		; $53cd
	and (hl)		; $53d0
	jp z,enemyAnimate		; $53d1
	ret			; $53d4
	ld h,d			; $53d5
	ld l,$8b		; $53d6
	ldh a,(<hEnemyTargetY)	; $53d8
	sub (hl)		; $53da
	add $20			; $53db
	cp $41			; $53dd
	ret nc			; $53df
	ld l,$8d		; $53e0
	ldh a,(<hEnemyTargetX)	; $53e2
	sub (hl)		; $53e4
	add $20			; $53e5
	cp $41			; $53e7
	ret			; $53e9
	ld a,c			; $53ea
	and $f0			; $53eb
	swap a			; $53ed
	ld b,a			; $53ef
	ld a,l			; $53f0
	and $f0			; $53f1
	swap a			; $53f3
	sub b			; $53f5
	jr nc,_label_0d_124	; $53f6
	cpl			; $53f8
	inc a			; $53f9
_label_0d_124:
	ld b,a			; $53fa
	ld a,c			; $53fb
	and $0f			; $53fc
	ld e,a			; $53fe
	ld a,l			; $53ff
	and $0f			; $5400
	sub e			; $5402
	jr nc,_label_0d_125	; $5403
	cpl			; $5405
	inc a			; $5406
_label_0d_125:
	add b			; $5407
	ld b,a			; $5408
	ld e,$b0		; $5409
	ld a,(de)		; $540b
	cp b			; $540c
	ret c			; $540d
	ld a,b			; $540e
	ld (de),a		; $540f
	ld e,$b1		; $5410
	ld a,l			; $5412
	and $f0			; $5413
	add $08			; $5415
	ld (de),a		; $5417
	inc e			; $5418
	ld a,l			; $5419
	and $0f			; $541a
	swap a			; $541c
	add $08			; $541e
	ld (de),a		; $5420
	ret			; $5421
	ld e,$b3		; $5422
	ld a,(de)		; $5424
	or a			; $5425
	ret z			; $5426
	ld e,$b4		; $5427
	ld a,(de)		; $5429
	ld l,a			; $542a
	ld h,$cf		; $542b
	ld b,$16		; $542d
_label_0d_126:
	ldi a,(hl)		; $542f
	cp $09			; $5430
	jr z,_label_0d_128	; $5432
	dec b			; $5434
	jr nz,_label_0d_126	; $5435
	ld a,l			; $5437
	cp $b0			; $5438
	jr nz,_label_0d_127	; $543a
	xor a			; $543c
_label_0d_127:
	ld (de),a		; $543d
	ret			; $543e
_label_0d_128:
	pop hl			; $543f
	ld h,d			; $5440
	ld l,e			; $5441
	ld (hl),$00		; $5442
	ld l,$84		; $5444
	ld (hl),$08		; $5446
	ld l,$90		; $5448
	ld (hl),$1e		; $544a
	ret			; $544c
	ld e,$8f		; $544d
	ld a,(de)		; $544f
	or a			; $5450
	ret z			; $5451
	cp $fa			; $5452
	ret nc			; $5454
	dec e			; $5455
	ld a,(de)		; $5456
	add $80			; $5457
	ld (de),a		; $5459
	inc e			; $545a
	ld a,(de)		; $545b
	adc $00			; $545c
	ld (de),a		; $545e
	scf			; $545f
	ret			; $5460
	ld e,$8b		; $5461
	ld a,(de)		; $5463
	cp $b0			; $5464
	jr nc,_label_0d_129	; $5466
	ld e,$8d		; $5468
	ld a,(de)		; $546a
	cp $f0			; $546b
	ret c			; $546d
_label_0d_129:
	ld e,$8b		; $546e
	ld a,(de)		; $5470
	ldh (<hFF8F),a	; $5471
	ld e,$8d		; $5473
	ld a,(de)		; $5475
	ldh (<hFF8E),a	; $5476
	ld bc,$5878		; $5478
	call objectGetRelativeAngleWithTempVars		; $547b
	ld c,a			; $547e
	ld b,$28		; $547f
	ld e,$89		; $5481
	jp objectApplyGivenSpeed		; $5483
	add b			; $5486
	ld h,b			; $5487
	ld b,b			; $5488
	jr nc,$20		; $5489
	jr nz,$1e		; $548b
	inc d			; $548d
	ld a,(bc)		; $548e
	ld a,(bc)		; $548f
	dec b			; $5490
	dec b			; $5491
	dec b			; $5492
	dec b			; $5493
	nop			; $5494
	nop			; $5495
	ld bc,$0301		; $5496
	inc bc			; $5499
	rlca			; $549a
	nop			; $549b

enemyCode3a:
	jr z,_label_0d_130	; $549c
	sub $03			; $549e
	ret c			; $54a0
	jp z,enemyDie		; $54a1
	dec a			; $54a4
	ret z			; $54a5
	ld e,$90		; $54a6
	ld a,(de)		; $54a8
	push af			; $54a9
	ld a,$50		; $54aa
	ld (de),a		; $54ac
	ld e,$ac		; $54ad
	call $5530		; $54af
	ld e,$ac		; $54b2
	call _ecom_applyVelocityGivenAdjacentWalls		; $54b4
	pop af			; $54b7
	ld e,$90		; $54b8
	ld (de),a		; $54ba
	ret			; $54bb
_label_0d_130:
	ld e,$84		; $54bc
	ld a,(de)		; $54be
	rst_jumpTable			; $54bf
	call nc,dec16_ff8c		; $54c0
	ld d,l			; $54c3
	ld ($0855),sp		; $54c4
	ld d,l			; $54c7
	ld ($cb55),sp		; $54c8
	ld b,h			; $54cb
	ld ($0855),sp		; $54cc
	ld d,l			; $54cf
	add hl,bc		; $54d0
	ld d,l			; $54d1
	daa			; $54d2
	ld d,l			; $54d3
	call objectSetVisible82		; $54d4
_label_0d_131:
	ld h,d			; $54d7
	ld l,$84		; $54d8
	ld (hl),$08		; $54da
	ld l,$86		; $54dc
	ld (hl),$40		; $54de
	ld a,($ccf0)		; $54e0
	or a			; $54e3
	jr nz,_label_0d_132	; $54e4
	call getRandomNumber_noPreserveVars		; $54e6
	and $18			; $54e9
	add $04			; $54eb
	ld e,$89		; $54ed
	ld (de),a		; $54ef
	jr _label_0d_134		; $54f0
_label_0d_132:
	ldh a,(<hFFB2)	; $54f2
	ldh (<hFF8F),a	; $54f4
	ldh a,(<hFFB3)	; $54f6
	ldh (<hFF8E),a	; $54f8
	ld l,$8b		; $54fa
	ldi a,(hl)		; $54fc
	ld b,a			; $54fd
	inc l			; $54fe
	ld c,(hl)		; $54ff
	call objectGetRelativeAngleWithTempVars		; $5500
	ld e,$89		; $5503
	ld (de),a		; $5505
	jr _label_0d_134		; $5506
	ret			; $5508
	call _ecom_decCounter1		; $5509
	jr nz,_label_0d_133	; $550c
	ld l,e			; $550e
	inc (hl)		; $550f
	ld l,$86		; $5510
	ld (hl),$08		; $5512
	jr _label_0d_134		; $5514
_label_0d_133:
	call $5568		; $5516
	call $552e		; $5519
	ld e,$89		; $551c
	call _ecom_applyVelocityGivenAdjacentWalls		; $551e
	call _ecom_bounceOffScreenBoundary		; $5521
_label_0d_134:
	jp enemyAnimate		; $5524
	call _ecom_decCounter1		; $5527
	jr nz,_label_0d_134	; $552a
	jr _label_0d_131		; $552c
	ld e,$89		; $552e
	ld a,(de)		; $5530
	call _ecom_getAdjacentWallTableOffset		; $5531
	ld h,d			; $5534
	ld l,$8b		; $5535
	ld b,(hl)		; $5537
	ld l,$8d		; $5538
	ld c,(hl)		; $553a
	ld hl,$425e		; $553b
	rst_addAToHl			; $553e
	ld a,$10		; $553f
	ldh (<hFF8B),a	; $5541
	ld d,$cf		; $5543
_label_0d_135:
	ldi a,(hl)		; $5545
	add b			; $5546
	ld b,a			; $5547
	and $f0			; $5548
	ld e,a			; $554a
	ldi a,(hl)		; $554b
	add c			; $554c
	ld c,a			; $554d
	and $f0			; $554e
	swap a			; $5550
	or e			; $5552
	ld e,a			; $5553
	ld a,(de)		; $5554
	sub $fa			; $5555
	cp $04			; $5557
	ldh a,(<hFF8B)	; $5559
	rla			; $555b
	ldh (<hFF8B),a	; $555c
	jr nc,_label_0d_135	; $555e
	xor $0f			; $5560
	ldh (<hFF8B),a	; $5562
	ldh a,(<hActiveObject)	; $5564
	ld d,a			; $5566
	ret			; $5567
	ld a,(hl)		; $5568
	srl a			; $5569
	srl a			; $556b
	ld hl,$5576		; $556d
	rst_addAToHl			; $5570
	ld e,$90		; $5571
	ld a,(hl)		; $5573
	ld (de),a		; $5574
	ret			; $5575
	dec b			; $5576
	ld a,(bc)		; $5577
	inc d			; $5578
	ld e,$28		; $5579
	ldd (hl),a		; $557b
	ldd (hl),a		; $557c
	ldd (hl),a		; $557d
	jr z,_label_0d_138	; $557e
	ld e,$1e		; $5580
	inc d			; $5582
	inc d			; $5583
	ld a,(bc)		; $5584
	ld a,(bc)		; $5585

enemyCode3d:
enemyCode49:
enemyCode4a:
	call _ecom_checkHazards		; $5586
	call $558f		; $5589
	jp $5761		; $558c
	jr z,_label_0d_137	; $558f
	sub $03			; $5591
	ret c			; $5593
	jr z,_label_0d_136	; $5594
	dec a			; $5596
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $5597
	ret			; $559a
_label_0d_136:
	pop hl			; $559b
	jp enemyDie		; $559c
_label_0d_137:
	call _ecom_checkScentSeedActive		; $559f
	jr z,_label_0d_139	; $55a2
	ld e,$90		; $55a4
	ld a,$19		; $55a6
_label_0d_138:
	ld (de),a		; $55a8
_label_0d_139:
	ld e,$84		; $55a9
	ld a,(de)		; $55ab
	rst_jumpTable			; $55ac
	jp $0a55		; $55ad
	ld d,(hl)		; $55b0
	ld a,(bc)		; $55b1
	ld d,(hl)		; $55b2
	sbc $55			; $55b3
.DB $f4				; $55b5
	ld d,l			; $55b6
	bit 0,h			; $55b7
	ld a,(bc)		; $55b9
	ld d,(hl)		; $55ba
	ld a,(bc)		; $55bb
	ld d,(hl)		; $55bc
	dec bc			; $55bd
	ld d,(hl)		; $55be
	dec h			; $55bf
	ld d,(hl)		; $55c0
	ldd (hl),a		; $55c1
	ld d,(hl)		; $55c2
	ld b,$1d		; $55c3
	call _ecom_spawnProjectile		; $55c5
	ret nz			; $55c8
	call _ecom_setRandomCardinalAngle		; $55c9
	call _ecom_updateAnimationFromAngle		; $55cc
	ld a,$14		; $55cf
	call _ecom_setSpeedAndState8AndVisible		; $55d1
	ld l,$86		; $55d4
	inc (hl)		; $55d6
	ld l,$bf		; $55d7
	set 4,(hl)		; $55d9
	jp $5750		; $55db
	inc e			; $55de
	ld a,(de)		; $55df
	rst_jumpTable			; $55e0
	dec b			; $55e1
	ld b,b			; $55e2
	jp hl			; $55e3
	ld d,l			; $55e4
	jp hl			; $55e5
	ld d,l			; $55e6
	ld ($c955),a		; $55e7
	ld b,$09		; $55ea
	call _ecom_fallToGroundAndSetState		; $55ec
	ld l,$86		; $55ef
	ld (hl),$10		; $55f1
	ret			; $55f3
	ld a,($ccf0)		; $55f4
	or a			; $55f7
	ld h,d			; $55f8
	jp z,$564e		; $55f9
	call _ecom_updateAngleToScentSeed		; $55fc
	call _ecom_updateAnimationFromAngle		; $55ff
	call _ecom_applyVelocityForSideviewEnemy		; $5602
	call enemyAnimate		; $5605
	jr _label_0d_140		; $5608
	ret			; $560a
	call $5720		; $560b
	jp c,$56f9		; $560e
	call _ecom_decCounter1		; $5611
	jp z,$5706		; $5614
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5617
	jr nz,_label_0d_140	; $561a
	call _ecom_bounceOffWallsAndHoles		; $561c
	jp nz,_ecom_updateAnimationFromAngle		; $561f
_label_0d_140:
	jp enemyAnimate		; $5622
	call _ecom_decCounter1		; $5625
	ret nz			; $5628
	ld (hl),$60		; $5629
	ld l,e			; $562b
	inc (hl)		; $562c
	ld l,$90		; $562d
	ld (hl),$19		; $562f
	ret			; $5631
	call _ecom_decCounter1		; $5632
	jp z,$564e		; $5635
	ld a,(hl)		; $5638
	and $03			; $5639
	jr nz,_label_0d_141	; $563b
	call objectGetAngleTowardEnemyTarget		; $563d
	call objectNudgeAngleTowards		; $5640
	call _ecom_updateAnimationFromAngle		; $5643
_label_0d_141:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5646
	call enemyAnimate		; $5649
	jr _label_0d_140		; $564c
	ld l,e			; $564e
	ld (hl),$08		; $564f
	ld l,$90		; $5651
	ld (hl),$14		; $5653
	ld l,$89		; $5655
	ld a,(hl)		; $5657
	add $04			; $5658
	and $18			; $565a
	ld (hl),a		; $565c
	call _ecom_updateAnimationFromAngle		; $565d
	call $5750		; $5660
	jr _label_0d_140		; $5663

enemyCode48:
	call _ecom_seasonsFunc_4446		; $5665
	call $566e		; $5668
	jp $5786		; $566b
	jr z,_label_0d_144	; $566e
	sub $03			; $5670
	ret c			; $5672
	jr z,_label_0d_142	; $5673
	dec a			; $5675
	call nz,_ecom_updateKnockbackAndCheckHazards		; $5676
	jp $5786		; $5679
_label_0d_142:
	ld e,$82		; $567c
	ld a,(de)		; $567e
	cp $02			; $567f
	jr nz,_label_0d_143	; $5681
	ld hl,$c6c9		; $5683
	set 2,(hl)		; $5686
_label_0d_143:
	pop hl			; $5688
	jp enemyDie		; $5689
_label_0d_144:
	ld e,$84		; $568c
	ld a,(de)		; $568e
	rst_jumpTable			; $568f
	and (hl)		; $5690
	ld d,(hl)		; $5691
	ld a,(bc)		; $5692
	ld d,(hl)		; $5693
	ld a,(bc)		; $5694
	ld d,(hl)		; $5695
	sbc $55			; $5696
	ld a,(bc)		; $5698
	ld d,(hl)		; $5699
	ld a,(bc)		; $569a
	ld d,(hl)		; $569b
	ld a,(bc)		; $569c
	ld d,(hl)		; $569d
	ld a,(bc)		; $569e
	ld d,(hl)		; $569f
	cp b			; $56a0
	ld d,(hl)		; $56a1
	ret nc			; $56a2
	ld d,(hl)		; $56a3
.DB $dd				; $56a4
	ld d,(hl)		; $56a5
	ld e,$82		; $56a6
	ld a,(de)		; $56a8
	cp $02			; $56a9
	jr nz,_label_0d_145	; $56ab
	ld a,($c6c9)		; $56ad
	bit 2,a			; $56b0
	jp nz,$57c7		; $56b2
_label_0d_145:
	jp $55c3		; $56b5
	call $5738		; $56b8
	jr c,_label_0d_148	; $56bb
	call _ecom_decCounter1		; $56bd
	jr z,_label_0d_149	; $56c0
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $56c2
	jr nz,_label_0d_146	; $56c5
	call _ecom_bounceOffWallsAndHoles		; $56c7
	jp nz,_ecom_updateAnimationFromAngle		; $56ca
_label_0d_146:
	jp enemyAnimate		; $56cd
	call _ecom_decCounter1		; $56d0
	ret nz			; $56d3
	ld (hl),$60		; $56d4
	ld l,e			; $56d6
	inc (hl)		; $56d7
	ld l,$90		; $56d8
	ld (hl),$1e		; $56da
	ret			; $56dc
	call _ecom_decCounter1		; $56dd
	jp z,$564e		; $56e0
	ld a,(hl)		; $56e3
	and $01			; $56e4
	jr nz,_label_0d_147	; $56e6
	call objectGetAngleTowardEnemyTarget		; $56e8
	call objectNudgeAngleTowards		; $56eb
	call _ecom_updateAnimationFromAngle		; $56ee
_label_0d_147:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $56f1
	call enemyAnimate		; $56f4
	jr _label_0d_146		; $56f7
_label_0d_148:
	ld l,$84		; $56f9
	inc (hl)		; $56fb
	ld l,$86		; $56fc
	ld (hl),$10		; $56fe
	call _ecom_updateAngleTowardTarget		; $5700
	jp _ecom_updateAnimationFromAngle		; $5703
_label_0d_149:
	ld bc,$3f07		; $5706
	call _ecom_randomBitwiseAndBCE		; $5709
	ld e,$86		; $570c
	ld a,$50		; $570e
	add b			; $5710
	ld (de),a		; $5711
	call $5718		; $5712
	jp _ecom_updateAnimationFromAngle		; $5715
	ld a,c			; $5718
	or a			; $5719
	jp z,_ecom_updateCardinalAngleTowardTarget		; $571a
	jp _ecom_setRandomCardinalAngle		; $571d
	call _ecom_decCounter2		; $5720
	ret nz			; $5723
	ld l,$8b		; $5724
	ldh a,(<hFFB2)	; $5726
	sub (hl)		; $5728
	add $28			; $5729
	cp $51			; $572b
	ret nc			; $572d
	ld l,$8d		; $572e
	ldh a,(<hEnemyTargetX)	; $5730
	sub (hl)		; $5732
	add $28			; $5733
	cp $51			; $5735
	ret			; $5737
	call _ecom_decCounter2		; $5738
	ret nz			; $573b
	ld l,$8b		; $573c
	ldh a,(<hFFB2)	; $573e
	sub (hl)		; $5740
	add $28			; $5741
	cp $51			; $5743
	ret nc			; $5745
	ld l,$8d		; $5746
	ldh a,(<hEnemyTargetX)	; $5748
	sub (hl)		; $574a
	add $28			; $574b
	cp $51			; $574d
	ret			; $574f
	ld e,$82		; $5750
	ld a,(de)		; $5752
	ld bc,$575e		; $5753
	call addAToBc		; $5756
	ld e,$87		; $5759
	ld a,(bc)		; $575b
	ld (de),a		; $575c
	ret			; $575d
	inc d			; $575e
	stop			; $575f
	inc c			; $5760
	ld b,$00		; $5761
	ld e,$ae		; $5763
	ld a,(de)		; $5765
	or a			; $5766
	jr nz,_label_0d_150	; $5767
	call $57a2		; $5769
	ld a,$52		; $576c
	ld b,$00		; $576e
	jr nz,_label_0d_151	; $5770
_label_0d_150:
	inc b			; $5772
	ld e,$81		; $5773
	ld a,(de)		; $5775
	cp $49			; $5776
	ld a,$11		; $5778
	jr nz,_label_0d_151	; $577a
	ld a,$20		; $577c
_label_0d_151:
	ld e,$a5		; $577e
	ld (de),a		; $5780
	ld e,$b0		; $5781
	ld a,b			; $5783
	ld (de),a		; $5784
	ret			; $5785
	ld b,$00		; $5786
	ld e,$ae		; $5788
	ld a,(de)		; $578a
	or a			; $578b
	jr nz,_label_0d_152	; $578c
	call $57a2		; $578e
	ld a,$53		; $5791
	ld b,$00		; $5793
	jr nz,_label_0d_153	; $5795
_label_0d_152:
	ld a,$1f		; $5797
	inc b			; $5799
_label_0d_153:
	ld e,$a5		; $579a
	ld (de),a		; $579c
	ld e,$b0		; $579d
	ld a,b			; $579f
	ld (de),a		; $57a0
	ret			; $57a1
	ld e,$ad		; $57a2
	ld a,(de)		; $57a4
	or a			; $57a5
	ret nz			; $57a6
	call objectGetAngleTowardEnemyTarget		; $57a7
	ld b,a			; $57aa
	ld e,$88		; $57ab
	ld a,(de)		; $57ad
	add a			; $57ae
	ld hl,$57b7		; $57af
	rst_addDoubleIndex			; $57b2
	ld a,b			; $57b3
	jp checkFlag		; $57b4
	ccf			; $57b7
	nop			; $57b8
	nop			; $57b9
	nop			; $57ba
	nop			; $57bb
	ccf			; $57bc
	nop			; $57bd
	nop			; $57be
	nop			; $57bf
	nop			; $57c0
	ccf			; $57c1
	nop			; $57c2
	nop			; $57c3
	nop			; $57c4
	ld hl,sp+$01		; $57c5
	call decNumEnemies		; $57c7
	jp enemyDelete		; $57ca

enemyCode3e:
	jr z,_label_0d_154	; $57cd
	sub $03			; $57cf
	ret c			; $57d1
	jp z,enemyDie		; $57d2
	ld e,$a5		; $57d5
	ld a,(de)		; $57d7
	cp $55			; $57d8
	ret nz			; $57da
_label_0d_154:
	call $586f		; $57db
	ld e,$84		; $57de
	ld a,(de)		; $57e0
	rst_jumpTable			; $57e1
	ld a,($0157)		; $57e2
	ld e,b			; $57e5
	ld bc,$0158		; $57e6
	ld e,b			; $57e9
	ld bc,$cb58		; $57ea
	ld b,h			; $57ed
	ld bc,$0158		; $57ee
	ld e,b			; $57f1
	ld (bc),a		; $57f2
	ld e,b			; $57f3
	ld a,(de)		; $57f4
	ld e,b			; $57f5
	dec (hl)		; $57f6
	ld e,b			; $57f7
	ld d,c			; $57f8
	ld e,b			; $57f9
	call _ecom_setSpeedAndState8AndVisible		; $57fa
	ld l,$86		; $57fd
	inc (hl)		; $57ff
	ret			; $5800
	ret			; $5801
	call _ecom_decCounter1		; $5802
	ret nz			; $5805
	ld l,$84		; $5806
	inc (hl)		; $5808
	ld l,$86		; $5809
	ld (hl),$7f		; $580b
	ld l,$90		; $580d
	ld (hl),$05		; $580f
	ld l,$b0		; $5811
	ld (hl),$0f		; $5813
	call objectSetVisiblec1		; $5815
	jr _label_0d_156		; $5818
	call _ecom_decCounter1		; $581a
	jp nz,$587d		; $581d
	ld l,$84		; $5820
	inc (hl)		; $5822
	call getRandomNumber_noPreserveVars		; $5823
	and $07			; $5826
	ld hl,$58d0		; $5828
	rst_addAToHl			; $582b
	ld e,$86		; $582c
	ld a,(hl)		; $582e
	ld (de),a		; $582f
	call _ecom_setRandomAngle		; $5830
	jr _label_0d_156		; $5833
	call _ecom_decCounter1		; $5835
	jr z,_label_0d_155	; $5838
	ld a,(hl)		; $583a
	and $1f			; $583b
	call z,_ecom_setRandomAngle		; $583d
	call objectApplySpeed		; $5840
	call _ecom_bounceOffScreenBoundary		; $5843
	jr _label_0d_156		; $5846
_label_0d_155:
	ld l,e			; $5848
	inc (hl)		; $5849
	ld l,$86		; $584a
	ld (hl),$00		; $584c
_label_0d_156:
	jp enemyAnimate		; $584e
	ld h,d			; $5851
	ld l,$86		; $5852
	inc (hl)		; $5854
	ld a,$80		; $5855
	cp (hl)			; $5857
	jp nz,$587d		; $5858
	ld (hl),$80		; $585b
	push hl			; $585d
	call objectGetTileCollisions		; $585e
	pop hl			; $5861
	jr z,_label_0d_157	; $5862
	ld (hl),$01		; $5864
_label_0d_157:
	ld l,$84		; $5866
	ld (hl),$08		; $5868
	call objectSetVisiblec2		; $586a
	jr _label_0d_156		; $586d
	ld e,$8f		; $586f
	ld a,(de)		; $5871
	or a			; $5872
	ld a,$2e		; $5873
	jr z,_label_0d_158	; $5875
	ld a,$55		; $5877
_label_0d_158:
	ld e,$a5		; $5879
	ld (de),a		; $587b
	ret			; $587c
	ld e,$86		; $587d
	ld a,(de)		; $587f
	dec a			; $5880
	cp $41			; $5881
	jr nc,_label_0d_160	; $5883
	and $78			; $5885
	swap a			; $5887
	rlca			; $5889
	ld b,a			; $588a
	sub $06			; $588b
	jr c,_label_0d_159	; $588d
	xor a			; $588f
_label_0d_159:
	ld e,$8f		; $5890
	ld (de),a		; $5892
	ld a,b			; $5893
	ld hl,$58c7		; $5894
	rst_addAToHl			; $5897
	ld e,$90		; $5898
	ld a,(hl)		; $589a
	ld (de),a		; $589b
	call objectApplySpeed		; $589c
	call _ecom_bounceOffScreenBoundary		; $589f
_label_0d_160:
	ld e,$86		; $58a2
	ld a,(de)		; $58a4
	and $f0			; $58a5
	swap a			; $58a7
	ld hl,$58bf		; $58a9
	rst_addAToHl			; $58ac
	ld b,(hl)		; $58ad
	ld a,b			; $58ae
	inc a			; $58af
	jr nz,_label_0d_161	; $58b0
	call enemyAnimate		; $58b2
	ld b,$00		; $58b5
_label_0d_161:
	ld a,(wFrameCounter)		; $58b7
	and b			; $58ba
	jp z,enemyAnimate		; $58bb
	ret			; $58be
	rst $38			; $58bf
	rst $38			; $58c0
	rst $38			; $58c1
	nop			; $58c2
	nop			; $58c3
	ld bc,$0703		; $58c4
	ld e,$1e		; $58c7
	ld e,$14		; $58c9
	inc d			; $58cb
	ld a,(bc)		; $58cc
	ld a,(bc)		; $58cd
	dec b			; $58ce
	dec b			; $58cf
	or h			; $58d0
	or h			; $58d1
	jp nc,$f0d2		; $58d2
	ld a,($ff00+$00)	; $58d5
	nop			; $58d7

enemyCode40:
	call _ecom_checkHazardsNoAnimationForHoles		; $58d8
	jr z,_label_0d_163	; $58db
	sub $03			; $58dd
	ret c			; $58df
	jp z,enemyDie		; $58e0
	dec a			; $58e3
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $58e4
	jr _label_0d_162		; $58e7
_label_0d_162:
	ld e,$82		; $58e9
	ld a,(de)		; $58eb
	dec a			; $58ec
	ret nz			; $58ed
	ld e,$ae		; $58ee
	ld a,(de)		; $58f0
	or a			; $58f1
	ret nz			; $58f2
	ld e,$aa		; $58f3
	ld a,(de)		; $58f5
	cp $80			; $58f6
	ret z			; $58f8
	jp $5a2e		; $58f9
_label_0d_163:
	call _ecom_getSubidAndCpStateTo08		; $58fc
	jr nc,_label_0d_164	; $58ff
	rst_jumpTable			; $5901
	ld a,(de)		; $5902
	ld e,c			; $5903
	halt			; $5904
	ld e,c			; $5905
	halt			; $5906
	ld e,c			; $5907
	ld c,h			; $5908
	ld e,c			; $5909
	halt			; $590a
	ld e,c			; $590b
	bit 0,h			; $590c
	halt			; $590e
	ld e,c			; $590f
	halt			; $5910
	ld e,c			; $5911
_label_0d_164:
	ld a,b			; $5912
	rst_jumpTable			; $5913
	ld (hl),a		; $5914
	ld e,c			; $5915
	call z,$3a59		; $5916
	ld e,d			; $5919
	ld h,d			; $591a
	ld l,$9a		; $591b
	ld a,(hl)		; $591d
	or $42			; $591e
	ld (hl),a		; $5920
	ld l,e			; $5921
	ld e,$82		; $5922
	ld a,(de)		; $5924
	or a			; $5925
	jr nz,_label_0d_165	; $5926
	ld (hl),$08		; $5928
	ld l,$86		; $592a
	ld (hl),$50		; $592c
	ret			; $592e
_label_0d_165:
	dec a			; $592f
	jr nz,_label_0d_166	; $5930
	ld (hl),$08		; $5932
	ld hl,$cee0		; $5934
	ld b,$10		; $5937
	jp clearMemory		; $5939
_label_0d_166:
	ld (hl),$0b		; $593c
	ld l,$90		; $593e
	ld (hl),$14		; $5940
	ld l,$86		; $5942
	ld (hl),$08		; $5944
	call _ecom_setRandomCardinalAngle		; $5946
	jp $5acd		; $5949
	inc e			; $594c
	ld a,(de)		; $594d
	rst_jumpTable			; $594e
	dec b			; $594f
	ld b,b			; $5950
	ld d,a			; $5951
	ld e,c			; $5952
	ld d,a			; $5953
	ld e,c			; $5954
	ld e,b			; $5955
	ld e,c			; $5956
	ret			; $5957
	call _ecom_fallToGroundAndSetState		; $5958
	ret nz			; $595b
	ld l,$a4		; $595c
	res 7,(hl)		; $595e
	ld e,$82		; $5960
	ld a,(de)		; $5962
	ld hl,$5970		; $5963
	rst_addDoubleIndex			; $5966
	ld e,$84		; $5967
	ldi a,(hl)		; $5969
	ld (de),a		; $596a
	ld e,$86		; $596b
	ld a,(hl)		; $596d
	ld (de),a		; $596e
	ret			; $596f
	dec bc			; $5970
	ld e,$0b		; $5971
	sub (hl)		; $5973
	add hl,bc		; $5974
	nop			; $5975
	ret			; $5976
	ld a,(de)		; $5977
	sub $08			; $5978
	rst_jumpTable			; $597a
	add e			; $597b
	ld e,c			; $597c
	adc (hl)		; $597d
	ld e,c			; $597e
	and d			; $597f
	ld e,c			; $5980
	cp d			; $5981
	ld e,c			; $5982
	call _ecom_decCounter1		; $5983
	ret nz			; $5986
	ld (hl),$4b		; $5987
	ld l,e			; $5989
	inc (hl)		; $598a
	jp objectSetVisiblec2		; $598b
	call _ecom_decCounter1		; $598e
	jp nz,$5adb		; $5991
	ld (hl),$48		; $5994
	ld l,e			; $5996
	inc (hl)		; $5997
	ld l,$a4		; $5998
	set 7,(hl)		; $599a
	call _ecom_updateCardinalAngleTowardTarget		; $599c
	jp $5acd		; $599f

	call _ecom_decCounter1		; $59a2
	jr z,_label_0d_167	; $59a5
	ld a,(hl)		; $59a7
	cp $34			; $59a8
	ret nz			; $59aa
	ld b,$1f		; $59ab
	jp _ecom_spawnProjectile		; $59ad
_label_0d_167:
	ld l,e			; $59b0
	inc (hl)		; $59b1
	ld l,$a4		; $59b2
	res 7,(hl)		; $59b4
	xor a			; $59b6
	jp enemySetAnimation		; $59b7
	ld h,d			; $59ba
	ld l,$86		; $59bb
	inc (hl)		; $59bd
	ld a,(hl)		; $59be
	cp $4b			; $59bf
	jp c,$5adb		; $59c1
	ld (hl),$48		; $59c4
	ld l,e			; $59c6
	ld (hl),$08		; $59c7
	jp objectSetInvisible		; $59c9
	ld a,(de)		; $59cc
	sub $08			; $59cd
	rst_jumpTable			; $59cf
	ret c			; $59d0
	ld e,c			; $59d1
.DB $f4				; $59d2
	ld e,c			; $59d3
	dec b			; $59d4
	ld e,d			; $59d5
	inc e			; $59d6
	ld e,d			; $59d7
	call $5b05		; $59d8
	ret nz			; $59db
	call $5b33		; $59dc
	ret z			; $59df
	ld h,d			; $59e0
	ld l,$8b		; $59e1
	ld (hl),b		; $59e3
	ld l,$8d		; $59e4
	ld (hl),c		; $59e6
	ld l,$84		; $59e7
	inc (hl)		; $59e9
	ld l,$86		; $59ea
	ld (hl),$3c		; $59ec
	call _ecom_updateCardinalAngleTowardTarget		; $59ee
	jp $5acd		; $59f1
	call _ecom_decCounter1		; $59f4
	jp nz,_ecom_flickerVisibility		; $59f7
	ld (hl),$48		; $59fa
	ld l,e			; $59fc
	inc (hl)		; $59fd
	ld l,$a4		; $59fe
	set 7,(hl)		; $5a00
	jp objectSetVisiblec2		; $5a02
	call _ecom_decCounter1		; $5a05
	jr z,_label_0d_168	; $5a08
	ld a,(hl)		; $5a0a
	cp $34			; $5a0b
	ret nz			; $5a0d
	ld b,$1f		; $5a0e
	jp _ecom_spawnProjectile		; $5a10
_label_0d_168:
	ld (hl),$b4		; $5a13
	ld l,e			; $5a15
	inc (hl)		; $5a16
	ld l,$a4		; $5a17
	res 7,(hl)		; $5a19
	ret			; $5a1b
	call _ecom_decCounter1		; $5a1c
	jr z,_label_0d_169	; $5a1f
	ld a,(hl)		; $5a21
	cp $78			; $5a22
	ret c			; $5a24
	jp z,objectSetInvisible		; $5a25
	jp _ecom_flickerVisibility		; $5a28
_label_0d_169:
	ld l,e			; $5a2b
	ld (hl),$08		; $5a2c
	ld h,d			; $5a2e
	ld l,$b0		; $5a2f
	ld l,(hl)		; $5a31
	ld h,$ce		; $5a32
	ld a,(hl)		; $5a34
	sub d			; $5a35
	ret nz			; $5a36
	ldd (hl),a		; $5a37
	ld (hl),a		; $5a38
	ret			; $5a39
	ld a,(de)		; $5a3a
	sub $08			; $5a3b
	rst_jumpTable			; $5a3d
	ld b,(hl)		; $5a3e
	ld e,d			; $5a3f
	ld l,(hl)		; $5a40
	ld e,d			; $5a41
	add l			; $5a42
	ld e,d			; $5a43
	and l			; $5a44
	ld e,d			; $5a45
	call _ecom_decCounter1		; $5a46
	jr z,_label_0d_171	; $5a49
	inc l			; $5a4b
	dec (hl)		; $5a4c
	jr nz,_label_0d_170	; $5a4d
	call _ecom_updateCardinalAngleTowardTarget		; $5a4f
	call $5acd		; $5a52
	call getRandomNumber_noPreserveVars		; $5a55
	and $3f			; $5a58
	add $20			; $5a5a
	ld e,$87		; $5a5c
	ld (de),a		; $5a5e
_label_0d_170:
	call $5b28		; $5a5f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5a62
	ret nz			; $5a65
_label_0d_171:
	call _ecom_incState		; $5a66
	ld l,$a4		; $5a69
	res 7,(hl)		; $5a6b
	ret			; $5a6d
	call $5b05		; $5a6e
	jp nz,_ecom_flickerVisibility		; $5a71
	ld h,d			; $5a74
	ld l,$b1		; $5a75
	ld (hl),b		; $5a77
	inc l			; $5a78
	ld (hl),c		; $5a79
	ld l,$84		; $5a7a
	inc (hl)		; $5a7c
	ld l,$8f		; $5a7d
	dec (hl)		; $5a7f
	call $5af8		; $5a80
	jr _label_0d_172		; $5a83
	call $5af8		; $5a85
	call _ecom_flickerVisibility		; $5a88
	call $5ae4		; $5a8b
	jp nc,objectApplySpeed		; $5a8e
	ld l,$84		; $5a91
	inc (hl)		; $5a93
	ld l,$86		; $5a94
	ld (hl),$08		; $5a96
	ld l,$8f		; $5a98
	ld (hl),$00		; $5a9a
	call _ecom_updateCardinalAngleTowardTarget		; $5a9c
	call $5acd		; $5a9f
	jp objectSetVisiblec2		; $5aa2
	call _ecom_decCounter1		; $5aa5
	jp nz,_ecom_flickerVisibility		; $5aa8
	ld h,d			; $5aab
	ld l,e			; $5aac
	ld (hl),$08		; $5aad
	ld l,$a4		; $5aaf
	set 7,(hl)		; $5ab1
	ld bc,$7f3f		; $5ab3
	call _ecom_randomBitwiseAndBCE		; $5ab6
	ld e,$86		; $5ab9
	ld a,b			; $5abb
	add $80			; $5abc
	ld (de),a		; $5abe
	inc e			; $5abf
	ld a,c			; $5ac0
	add $10			; $5ac1
	ld (de),a		; $5ac3
	call _ecom_updateCardinalAngleTowardTarget		; $5ac4
	call $5acd		; $5ac7
	jp objectSetVisiblec2		; $5aca
_label_0d_172:
	ld e,$89		; $5acd
	ld a,(de)		; $5acf
	add $04			; $5ad0
	and $18			; $5ad2
	swap a			; $5ad4
	rlca			; $5ad6
	inc a			; $5ad7
	jp enemySetAnimation		; $5ad8
	ld e,$86		; $5adb
	ld a,(de)		; $5add
	cp $2d			; $5ade
	ret c			; $5ae0
	jp _ecom_flickerVisibility		; $5ae1
	ld h,d			; $5ae4
	ld l,$8b		; $5ae5
	ld e,$b1		; $5ae7
	ld a,(de)		; $5ae9
	sub (hl)		; $5aea
	inc a			; $5aeb
	cp $03			; $5aec
	ret nc			; $5aee
	ld l,$8d		; $5aef
	inc e			; $5af1
	ld a,(de)		; $5af2
	sub (hl)		; $5af3
	inc a			; $5af4
	cp $03			; $5af5
	ret			; $5af7
	ld h,d			; $5af8
	ld l,$b1		; $5af9
	call _ecom_readPositionVars		; $5afb
	call objectGetRelativeAngleWithTempVars		; $5afe
	ld e,$89		; $5b01
	ld (de),a		; $5b03
	ret			; $5b04
	call getRandomNumber_noPreserveVars		; $5b05
	and $70			; $5b08
	ld b,a			; $5b0a
	ldh a,(<hCameraY)	; $5b0b
	add b			; $5b0d
	and $f0			; $5b0e
	add $08			; $5b10
	ld b,a			; $5b12
_label_0d_173:
	call getRandomNumber		; $5b13
	and $f0			; $5b16
	cp $a0			; $5b18
	jr nc,_label_0d_173	; $5b1a
	ld c,a			; $5b1c
	ldh a,(<hCameraX)	; $5b1d
	add c			; $5b1f
	and $f0			; $5b20
	add $08			; $5b22
	ld c,a			; $5b24
	jp getTileCollisionsAtPosition		; $5b25
	ld e,$86		; $5b28
	ld a,(de)		; $5b2a
	and $1f			; $5b2b
	ret nz			; $5b2d
	ld b,$1f		; $5b2e
	jp _ecom_spawnProjectile		; $5b30
	push bc			; $5b33
	ld e,l			; $5b34
	ld b,$08		; $5b35
	ld c,b			; $5b37
	ld hl,$cee0		; $5b38
_label_0d_174:
	ldi a,(hl)		; $5b3b
	cp e			; $5b3c
	jr z,_label_0d_177	; $5b3d
	inc l			; $5b3f
	dec b			; $5b40
	jr nz,_label_0d_174	; $5b41
	ld l,$e0		; $5b43
_label_0d_175:
	ld a,(hl)		; $5b45
	or a			; $5b46
	jr z,_label_0d_176	; $5b47
	inc l			; $5b49
	inc l			; $5b4a
	dec c			; $5b4b
	jr nz,_label_0d_175	; $5b4c
	jr _label_0d_177		; $5b4e
_label_0d_176:
	ld (hl),e		; $5b50
	inc l			; $5b51
	ld (hl),d		; $5b52
	ld e,$b0		; $5b53
	ld a,l			; $5b55
	ld (de),a		; $5b56
	or d			; $5b57
_label_0d_177:
	pop bc			; $5b58
	ret			; $5b59


enemyCode41:
enemyCode4c:
	jr z,_label_0d_178	; $5b5a
	sub $03			; $5b5c
	ret c			; $5b5e
	jp z,enemyDie		; $5b5f
	dec a			; $5b62
	ret z			; $5b63
	jp _ecom_updateKnockbackNoSolidity		; $5b64
_label_0d_178:
	call _ecom_getSubidAndCpStateTo08		; $5b67
	jr nc,_label_0d_179	; $5b6a
	rst_jumpTable			; $5b6c
	add e			; $5b6d
	ld e,e			; $5b6e
	sub d			; $5b6f
	ld e,e			; $5b70
	sub d			; $5b71
	ld e,e			; $5b72
	sub d			; $5b73
	ld e,e			; $5b74
	sub d			; $5b75
	ld e,e			; $5b76
	bit 0,h			; $5b77
	sub d			; $5b79
	ld e,e			; $5b7a
	sub d			; $5b7b
	ld e,e			; $5b7c
_label_0d_179:
	ld a,b			; $5b7d
	rst_jumpTable			; $5b7e
	sub e			; $5b7f
	ld e,e			; $5b80
	ld d,$5c		; $5b81
	ld e,$82		; $5b83
	ld a,(de)		; $5b85
	or a			; $5b86
	jp nz,_ecom_setSpeedAndState8		; $5b87
	ld a,$32		; $5b8a
	call _ecom_setSpeedAndState8		; $5b8c
	jp objectSetVisiblec1		; $5b8f
	ret			; $5b92
	ld a,(de)		; $5b93
	sub $08			; $5b94
	rst_jumpTable			; $5b96
	sbc l			; $5b97
	ld e,e			; $5b98
	call nz,$f75b		; $5b99
	ld e,e			; $5b9c
	call _ecom_updateAngleTowardTarget		; $5b9d
	call $5cf2		; $5ba0
	ld h,d			; $5ba3
	ld l,$8b		; $5ba4
	ldh a,(<hEnemyTargetY)	; $5ba6
	sub (hl)		; $5ba8
	add $30			; $5ba9
	cp $61			; $5bab
	ret nc			; $5bad
	ld l,$8d		; $5bae
	ldh a,(<hEnemyTargetX)	; $5bb0
	sub (hl)		; $5bb2
	add $18			; $5bb3
	cp $31			; $5bb5
	ret nc			; $5bb7
	call _ecom_incState		; $5bb8
	ld l,$86		; $5bbb
	ld (hl),$19		; $5bbd
	ld l,$b0		; $5bbf
	ld (hl),$02		; $5bc1
	ret			; $5bc3
	call _ecom_updateAngleTowardTarget		; $5bc4
	call $5cf2		; $5bc7
	call _ecom_decCounter1		; $5bca
	jr z,_label_0d_180	; $5bcd
	ld a,(hl)		; $5bcf
	and $03			; $5bd0
	jr nz,_label_0d_183	; $5bd2
	ld l,$8f		; $5bd4
	dec (hl)		; $5bd6
	jr _label_0d_183		; $5bd7
_label_0d_180:
	inc l			; $5bd9
	ld (hl),$5a		; $5bda
	ld l,$84		; $5bdc
	inc (hl)		; $5bde
	ld l,$a4		; $5bdf
	set 7,(hl)		; $5be1
	call _ecom_updateAngleTowardTarget		; $5be3
	call getRandomNumber_noPreserveVars		; $5be6
	and $04			; $5be9
	jr nz,_label_0d_181	; $5beb
	ld a,$fc		; $5bed
_label_0d_181:
	ld b,a			; $5bef
	ld e,$89		; $5bf0
	ld a,(de)		; $5bf2
	add b			; $5bf3
	ld (de),a		; $5bf4
	jr _label_0d_183		; $5bf5
	call $5d09		; $5bf7
	jp nc,enemyDelete		; $5bfa
	call _ecom_decCounter2		; $5bfd
	jr z,_label_0d_182	; $5c00
	ld a,(hl)		; $5c02
	and $07			; $5c03
	jr nz,_label_0d_182	; $5c05
	call objectGetAngleTowardEnemyTarget		; $5c07
	call objectNudgeAngleTowards		; $5c0a
	call $5cf2		; $5c0d
_label_0d_182:
	call objectApplySpeed		; $5c10
_label_0d_183:
	jp enemyAnimate		; $5c13
	ld a,(de)		; $5c16
	sub $08			; $5c17
	rst_jumpTable			; $5c19
	ld h,$5c		; $5c1a
	ld d,l			; $5c1c
	ld e,h			; $5c1d
	sbc l			; $5c1e
	ld e,h			; $5c1f
	or c			; $5c20
	ld e,h			; $5c21
	bit 3,h			; $5c22
	ld ($ff00+$5c),a	; $5c24
	ld hl,$d081		; $5c26
	ld b,$00		; $5c29
_label_0d_184:
	ld a,(hl)		; $5c2b
	cp $41			; $5c2c
	jr nz,_label_0d_185	; $5c2e
	ld l,e			; $5c30
	ldd a,(hl)		; $5c31
	dec l			; $5c32
	dec l			; $5c33
	cp $09			; $5c34
	jr c,_label_0d_185	; $5c36
	inc b			; $5c38
_label_0d_185:
	inc h			; $5c39
	ld a,h			; $5c3a
	cp $e0			; $5c3b
	jr c,_label_0d_184	; $5c3d
	ld a,b			; $5c3f
	cp $02			; $5c40
	ret nc			; $5c42
	ld h,d			; $5c43
	ld l,e			; $5c44
	inc (hl)		; $5c45
	ld l,$86		; $5c46
	or a			; $5c48
	ld a,$3c		; $5c49
	jr z,_label_0d_186	; $5c4b
	ld a,$f0		; $5c4d
_label_0d_186:
	ld (hl),a		; $5c4f
	ld l,$b0		; $5c50
	ld (hl),$02		; $5c52
	ret			; $5c54
	call _ecom_decCounter1		; $5c55
	ret nz			; $5c58
	ld b,$00		; $5c59
	ldh a,(<hEnemyTargetY)	; $5c5b
	cp $40			; $5c5d
	jr c,_label_0d_187	; $5c5f
	ld b,$08		; $5c61
_label_0d_187:
	ldh a,(<hEnemyTargetX)	; $5c63
	cp $50			; $5c65
	jr c,_label_0d_188	; $5c67
	set 2,b			; $5c69
_label_0d_188:
	ld a,b			; $5c6b
	ld hl,$5d5a		; $5c6c
	rst_addAToHl			; $5c6f
	ld e,$8b		; $5c70
	ldi a,(hl)		; $5c72
	ld (de),a		; $5c73
	ldh (<hFF8F),a	; $5c74
	ld e,$8d		; $5c76
	ldi a,(hl)		; $5c78
	ld (de),a		; $5c79
	ldh (<hFF8E),a	; $5c7a
	ld e,$b2		; $5c7c
	ldi a,(hl)		; $5c7e
	ld (de),a		; $5c7f
	ld b,a			; $5c80
	inc e			; $5c81
	ld a,(hl)		; $5c82
	ld (de),a		; $5c83
	ld c,a			; $5c84
	call _ecom_updateAngleTowardTarget		; $5c85
	call _ecom_incState		; $5c88
	ld l,$a4		; $5c8b
	set 7,(hl)		; $5c8d
	ld l,$90		; $5c8f
	ld (hl),$14		; $5c91
	ld l,$8f		; $5c93
	ld (hl),$fa		; $5c95
	call $5cf2		; $5c97
	jp objectSetVisiblec1		; $5c9a
	call $5d15		; $5c9d
	jr nc,_label_0d_189	; $5ca0
	ld l,e			; $5ca2
	inc (hl)		; $5ca3
	ld l,$86		; $5ca4
	ld (hl),$3c		; $5ca6
	call _ecom_updateAngleTowardTarget		; $5ca8
	call $5cf2		; $5cab
_label_0d_189:
	jp enemyAnimate		; $5cae
	call _ecom_decCounter1		; $5cb1
	jr nz,_label_0d_189	; $5cb4
	ld (hl),$18		; $5cb6
	inc l			; $5cb8
	ld (hl),$00		; $5cb9
	ld l,e			; $5cbb
	inc (hl)		; $5cbc
	ld l,$b2		; $5cbd
	ldh a,(<hEnemyTargetY)	; $5cbf
	ldi (hl),a		; $5cc1
	ldh a,(<hEnemyTargetX)	; $5cc2
	ld (hl),a		; $5cc4
	ld l,$90		; $5cc5
	ld (hl),$05		; $5cc7
	jr _label_0d_189		; $5cc9
	call $5d46		; $5ccb
	jr nc,_label_0d_190	; $5cce
	call $5ceb		; $5cd0
	call $5d30		; $5cd3
	call objectApplySpeed		; $5cd6
	jr _label_0d_189		; $5cd9
_label_0d_190:
	call _ecom_incState		; $5cdb
	jr _label_0d_189		; $5cde
	ld h,d			; $5ce0
	ld l,e			; $5ce1
	ld (hl),$08		; $5ce2
	ld l,$a4		; $5ce4
	res 7,(hl)		; $5ce6
	jp objectSetInvisible		; $5ce8
	call _ecom_decCounter1		; $5ceb
	ret nz			; $5cee
	call _ecom_updateAngleTowardTarget		; $5cef
	ld h,d			; $5cf2
	ld l,$89		; $5cf3
	ld a,(hl)		; $5cf5
	and $0f			; $5cf6
	ret z			; $5cf8
	bit 4,(hl)		; $5cf9
	ld l,$b0		; $5cfb
	ld a,(hl)		; $5cfd
	jr nz,_label_0d_191	; $5cfe
	inc a			; $5d00
_label_0d_191:
	ld l,$b1		; $5d01
	cp (hl)			; $5d03
_label_0d_192:
	ret z			; $5d04
	ld (hl),a		; $5d05
	jp enemySetAnimation		; $5d06
	ld e,$8b		; $5d09
	ld a,(de)		; $5d0b
	cp $88			; $5d0c
	ret nc			; $5d0e
	ld e,$8d		; $5d0f
	ld a,(de)		; $5d11
	cp $a8			; $5d12
	ret			; $5d14
	ld h,d			; $5d15
	ld l,$b2		; $5d16
	call _ecom_readPositionVars		; $5d18
	sub c			; $5d1b
	inc a			; $5d1c
	cp $02			; $5d1d
	jr nc,_label_0d_193	; $5d1f
	ldh a,(<hFF8F)	; $5d21
	sub b			; $5d23
	inc a			; $5d24
	cp $02			; $5d25
	ret c			; $5d27
_label_0d_193:
	call _ecom_moveTowardPosition		; $5d28
	call $5cf2		; $5d2b
	or d			; $5d2e
	ret			; $5d2f
	ld e,$87		; $5d30
	ld a,(de)		; $5d32
	cp $7f			; $5d33
	jr z,_label_0d_194	; $5d35
	inc a			; $5d37
	ld (de),a		; $5d38
_label_0d_194:
	and $f0			; $5d39
	swap a			; $5d3b
	ld hl,$5d52		; $5d3d
	rst_addAToHl			; $5d40
	ld e,$90		; $5d41
	ld a,(hl)		; $5d43
	ld (de),a		; $5d44
	ret			; $5d45
	ld e,$8b		; $5d46
	ld a,(de)		; $5d48
	cp $88			; $5d49
	ret nc			; $5d4b
	ld e,$8d		; $5d4c
	ld a,(de)		; $5d4e
	cp $a8			; $5d4f
	ret			; $5d51
	ld a,(bc)		; $5d52
	inc d			; $5d53
	ld e,$28		; $5d54
	ldd (hl),a		; $5d56
	inc a			; $5d57
	ld b,(hl)		; $5d58
	ld d,b			; $5d59
	ld h,b			; $5d5a
	and b			; $5d5b
	ld (hl),b		; $5d5c
	sub b			; $5d5d
	ld h,b			; $5d5e
	nop			; $5d5f
	ld (hl),b		; $5d60
	stop			; $5d61
	jr nz,_label_0d_192	; $5d62
	stop			; $5d64
	sub b			; $5d65
	jr nz,_label_0d_195	; $5d66
_label_0d_195:
	stop			; $5d68
	stop			; $5d69

enemyCode43:
	call _ecom_checkHazardsNoAnimationForHoles		; $5d6a
	jr z,_label_0d_196	; $5d6d
	sub $03			; $5d6f
	ret c			; $5d71
	jp z,enemyDie		; $5d72
	ld e,$aa		; $5d75
	ld a,(de)		; $5d77
	cp $80			; $5d78
	jr nz,_label_0d_196	; $5d7a
	ld e,$84		; $5d7c
	ld a,$0c		; $5d7e
	ld (de),a		; $5d80
_label_0d_196:
	ld e,$84		; $5d81
	ld a,(de)		; $5d83
	rst_jumpTable			; $5d84
	and c			; $5d85
	ld e,l			; $5d86
	xor c			; $5d87
	ld e,l			; $5d88
	xor c			; $5d89
	ld e,l			; $5d8a
	xor c			; $5d8b
	ld e,l			; $5d8c
	xor c			; $5d8d
	ld e,l			; $5d8e
	bit 0,h			; $5d8f
	xor c			; $5d91
	ld e,l			; $5d92
	xor c			; $5d93
	ld e,l			; $5d94
	xor d			; $5d95
	ld e,l			; $5d96
	call nc,$e75d		; $5d97
	ld e,l			; $5d9a
	ld a,($ff00+c)		; $5d9b
	ld e,l			; $5d9c
	dec bc			; $5d9d
	ld e,(hl)		; $5d9e
	rla			; $5d9f
	ld e,(hl)		; $5da0
	ld e,$86		; $5da1
	ld a,$10		; $5da3
	ld (de),a		; $5da5
	jp _ecom_setSpeedAndState8AndVisible		; $5da6
	ret			; $5da9
	call _ecom_decCounter1		; $5daa
	jr nz,_label_0d_198	; $5dad
	call getRandomNumber_noPreserveVars		; $5daf
	and $07			; $5db2
	ld h,d			; $5db4
	jr nz,_label_0d_197	; $5db5
	ld l,$86		; $5db7
	ld (hl),$30		; $5db9
	ld l,$84		; $5dbb
	ld (hl),$0a		; $5dbd
	ld a,$02		; $5dbf
	jp enemySetAnimation		; $5dc1
_label_0d_197:
	ld l,$86		; $5dc4
	ld (hl),$08		; $5dc6
	ld l,$84		; $5dc8
	inc (hl)		; $5dca
	ld l,$90		; $5dcb
	ld (hl),$0a		; $5dcd
	call _ecom_updateAngleTowardTarget		; $5dcf
	jr _label_0d_198		; $5dd2
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5dd4
	call _ecom_decCounter1		; $5dd7
	jr nz,_label_0d_198	; $5dda
	ld l,$84		; $5ddc
	ld (hl),$08		; $5dde
	ld l,$86		; $5de0
	ld (hl),$10		; $5de2
_label_0d_198:
	jp enemyAnimate		; $5de4
	call _ecom_decCounter1		; $5de7
	jr nz,_label_0d_198	; $5dea
	call $5e58		; $5dec
	jp _ecom_updateAngleTowardTarget		; $5def
	call _ecom_applyVelocityForSideviewEnemy		; $5df2
	ld c,$28		; $5df5
	call objectUpdateSpeedZ_paramC		; $5df7
	ret nz			; $5dfa
	ld h,d			; $5dfb
	ld l,$84		; $5dfc
	ld (hl),$08		; $5dfe
	ld l,$86		; $5e00
	ld (hl),$10		; $5e02
	ld l,$a4		; $5e04
	set 7,(hl)		; $5e06
	jp objectSetVisiblec2		; $5e08
	ld h,d			; $5e0b
	ld l,e			; $5e0c
	inc (hl)		; $5e0d
	ld l,$87		; $5e0e
	ld (hl),$78		; $5e10
	ld a,$01		; $5e12
	jp enemySetAnimation		; $5e14
	ld a,($d00b)		; $5e17
	ld e,$8b		; $5e1a
	ld (de),a		; $5e1c
	ld a,($d00d)		; $5e1d
	ld e,$8d		; $5e20
	ld (de),a		; $5e22
	call _ecom_decCounter2		; $5e23
	jr z,_label_0d_202	; $5e26
	ld a,($cc46)		; $5e28
	or a			; $5e2b
	jr z,_label_0d_200	; $5e2c
	ld a,(hl)		; $5e2e
	sub $03			; $5e2f
	jr nc,_label_0d_199	; $5e31
	ld a,$01		; $5e33
_label_0d_199:
	ld (hl),a		; $5e35
_label_0d_200:
	ld a,(hl)		; $5e36
	and $03			; $5e37
	jr nz,_label_0d_201	; $5e39
	ld l,$9a		; $5e3b
	ld a,(hl)		; $5e3d
	xor $07			; $5e3e
	ld (hl),a		; $5e40
_label_0d_201:
	ld hl,$ccef		; $5e41
	set 5,(hl)		; $5e44
	ld a,(wFrameCounter)		; $5e46
	rrca			; $5e49
	jr nc,_label_0d_198	; $5e4a
	ld hl,wLinkImmobilized		; $5e4c
	set 5,(hl)		; $5e4f
	jr _label_0d_198		; $5e51
_label_0d_202:
	call $5e72		; $5e53
	jr _label_0d_203		; $5e56
_label_0d_203:
	ld bc,$fe00		; $5e58
	call objectSetSpeedZ		; $5e5b
	ld l,$84		; $5e5e
	ld (hl),$0b		; $5e60
	ld l,$90		; $5e62
	ld (hl),$28		; $5e64
	xor a			; $5e66
	call enemySetAnimation		; $5e67
	ld a,$8f		; $5e6a
	call playSound		; $5e6c
	jp objectSetVisiblec1		; $5e6f
	ld a,($d009)		; $5e72
	bit 7,a			; $5e75
	jp nz,_ecom_setRandomAngle		; $5e77
	xor $10			; $5e7a
	ld e,$89		; $5e7c
	ld (de),a		; $5e7e
	ret			; $5e7f

enemyCode45:
	jr z,_label_0d_204	; $5e80
	sub $03			; $5e82
	ret c			; $5e84
	jp z,enemyDie		; $5e85
_label_0d_204:
	call _ecom_getSubidAndCpStateTo08		; $5e88
	jr nc,_label_0d_205	; $5e8b
	rst_jumpTable			; $5e8d
	xor c			; $5e8e
	ld e,(hl)		; $5e8f
	or b			; $5e90
	ld e,(hl)		; $5e91
	call c,$dc5e		; $5e92
	ld e,(hl)		; $5e95
	call c,$dc5e		; $5e96
	ld e,(hl)		; $5e99
	call c,$dc5e		; $5e9a
	ld e,(hl)		; $5e9d
_label_0d_205:
	dec b			; $5e9e
	ld a,b			; $5e9f
	rst_jumpTable			; $5ea0
.DB $dd				; $5ea1
	ld e,(hl)		; $5ea2
	ld a,l			; $5ea3
	ld e,a			; $5ea4
	ld a,l			; $5ea5
	ld e,a			; $5ea6
	ld a,l			; $5ea7
	ld e,a			; $5ea8
	ld a,b			; $5ea9
	or a			; $5eaa
	jp nz,_ecom_setSpeedAndState8		; $5eab
	inc a			; $5eae
	ld (de),a		; $5eaf
	ld b,$04		; $5eb0
	call checkBEnemySlotsAvailable		; $5eb2
	ret nz			; $5eb5
	ld b,$45		; $5eb6
	call _ecom_spawnUncountedEnemyWithSubid01		; $5eb8
	ld l,$80		; $5ebb
	ld e,l			; $5ebd
	ld a,(de)		; $5ebe
	ld (hl),a		; $5ebf
	call objectCopyPosition		; $5ec0
	ld c,h			; $5ec3
	call _ecom_spawnUncountedEnemyWithSubid01		; $5ec4
	call $5fc7		; $5ec7
	call _ecom_spawnUncountedEnemyWithSubid01		; $5eca
	inc (hl)		; $5ecd
	call $5fc7		; $5ece
	call _ecom_spawnUncountedEnemyWithSubid01		; $5ed1
	inc (hl)		; $5ed4
	inc (hl)		; $5ed5
	call $5fc7		; $5ed6
	jp enemyDelete		; $5ed9
	ret			; $5edc
	ld a,(de)		; $5edd
	sub $08			; $5ede
	rst_jumpTable			; $5ee0
	rst $28			; $5ee1
	ld e,(hl)		; $5ee2
.DB $fd				; $5ee3
	ld e,(hl)		; $5ee4
	dec bc			; $5ee5
	ld e,a			; $5ee6
	dec (hl)		; $5ee7
	ld e,a			; $5ee8
	ld c,e			; $5ee9
	ld e,a			; $5eea
	ld d,d			; $5eeb
	ld e,a			; $5eec
	ld l,b			; $5eed
	ld e,a			; $5eee
	ld h,d			; $5eef
	ld l,e			; $5ef0
	inc (hl)		; $5ef1
	ld e,$8b		; $5ef2
	ld l,$b1		; $5ef4
	ld a,(de)		; $5ef6
	ldi (hl),a		; $5ef7
	ld e,$8d		; $5ef8
	ld a,(de)		; $5efa
	ld (hl),a		; $5efb
	ret			; $5efc
	ld c,$28		; $5efd
	call objectCheckLinkWithinDistance		; $5eff
	ret nc			; $5f02
	ld e,$84		; $5f03
	ld a,$0a		; $5f05
	ld (de),a		; $5f07
	jp objectSetVisible82		; $5f08
	ld e,$a1		; $5f0b
	ld a,(de)		; $5f0d
	dec a			; $5f0e
	jp nz,enemyAnimate		; $5f0f
	call _ecom_incState		; $5f12
	ld l,$a4		; $5f15
	set 7,(hl)		; $5f17
	ld l,$b3		; $5f19
	ld (hl),$00		; $5f1b
	ld l,$8b		; $5f1d
	ld b,(hl)		; $5f1f
	ld l,$8d		; $5f20
	ld c,(hl)		; $5f22
	ld a,$06		; $5f23
	call tryToBreakTile		; $5f25
	call _ecom_updateAngleTowardTarget		; $5f28
	add $02			; $5f2b
	and $1c			; $5f2d
	rrca			; $5f2f
	rrca			; $5f30
	inc a			; $5f31
	jp enemySetAnimation		; $5f32
	call $5fcf		; $5f35
	ld e,$b3		; $5f38
	ld a,(de)		; $5f3a
	add $02			; $5f3b
	cp $20			; $5f3d
	jr nc,_label_0d_206	; $5f3f
	ld (de),a		; $5f41
	ret			; $5f42
_label_0d_206:
	call _ecom_incState		; $5f43
	ld l,$86		; $5f46
	ld (hl),$08		; $5f48
	ret			; $5f4a
	call _ecom_decCounter1		; $5f4b
	ret nz			; $5f4e
	ld l,e			; $5f4f
	inc (hl)		; $5f50
	ret			; $5f51
	call $5fcf		; $5f52
	ld h,d			; $5f55
	ld l,$b3		; $5f56
	dec (hl)		; $5f58
	ret nz			; $5f59
	ld l,$86		; $5f5a
	ld (hl),$1e		; $5f5c
	ld l,$84		; $5f5e
	inc (hl)		; $5f60
	ld l,$a4		; $5f61
	res 7,(hl)		; $5f63
	jp objectSetInvisible		; $5f65
	call _ecom_decCounter1		; $5f68
	ret nz			; $5f6b
	ld l,e			; $5f6c
	ld (hl),$09		; $5f6d
	ld l,$b1		; $5f6f
	ld e,$8b		; $5f71
	ldi a,(hl)		; $5f73
	ld (de),a		; $5f74
	ld e,$8d		; $5f75
	ld a,(hl)		; $5f77
	ld (de),a		; $5f78
	xor a			; $5f79
	jp enemySetAnimation		; $5f7a
	ld a,(de)		; $5f7d
	sub $08			; $5f7e
	rst_jumpTable			; $5f80
	add l			; $5f81
	ld e,a			; $5f82
	and b			; $5f83
	ld e,a			; $5f84
	ld a,$09		; $5f85
	ld (de),a		; $5f87
	ld a,$0b		; $5f88
	call objectGetRelatedObject1Var		; $5f8a
	ld e,$b1		; $5f8d
	ldi a,(hl)		; $5f8f
	ld (de),a		; $5f90
	inc l			; $5f91
	inc e			; $5f92
	ld a,(hl)		; $5f93
	ld (de),a		; $5f94
	ld e,$b4		; $5f95
	ld l,$81		; $5f97
	ld a,(hl)		; $5f99
	ld (de),a		; $5f9a
	ld a,$09		; $5f9b
	jp enemySetAnimation		; $5f9d
	ld a,$01		; $5fa0
	call objectGetRelatedObject1Var		; $5fa2
	ld e,$b4		; $5fa5
	ld a,(de)		; $5fa7
	cp (hl)			; $5fa8
	jp nz,enemyDelete		; $5fa9
	ld l,$89		; $5fac
	ld e,l			; $5fae
	ld a,(hl)		; $5faf
	ld (de),a		; $5fb0
	ld l,$ab		; $5fb1
	ld e,l			; $5fb3
	ld a,(hl)		; $5fb4
	ld (de),a		; $5fb5
	ld l,$84		; $5fb6
	ld a,(hl)		; $5fb8
	cp $0b			; $5fb9
	jr c,_label_0d_207	; $5fbb
	ld l,$9a		; $5fbd
	ld e,l			; $5fbf
	ld a,(hl)		; $5fc0
	ld (de),a		; $5fc1
_label_0d_207:
	call $5fdc		; $5fc2
	jr _label_0d_208		; $5fc5
	inc (hl)		; $5fc7
	ld l,$96		; $5fc8
	ld a,$80		; $5fca
	ldi (hl),a		; $5fcc
	ld (hl),c		; $5fcd
	ret			; $5fce
_label_0d_208:
	ld h,d			; $5fcf
	ld l,$b1		; $5fd0
	ld b,(hl)		; $5fd2
	inc l			; $5fd3
	ld c,(hl)		; $5fd4
	inc l			; $5fd5
	ld a,(hl)		; $5fd6
	ld e,$89		; $5fd7
	jp objectSetPositionInCircleArc		; $5fd9
	push hl			; $5fdc
	ld e,$82		; $5fdd
	ld a,(de)		; $5fdf
	sub $02			; $5fe0
	rst_jumpTable			; $5fe2
	jp hl			; $5fe3
	ld e,a			; $5fe4
	ld a,($ff00+c)		; $5fe5
	ld e,a			; $5fe6
	ld sp,hl		; $5fe7
	ld e,a			; $5fe8
	pop hl			; $5fe9
	call $5fff		; $5fea
	ld b,a			; $5fed
	add a			; $5fee
	add b			; $5fef
	ld (de),a		; $5ff0
	ret			; $5ff1
	pop hl			; $5ff2
	call $5fff		; $5ff3
	add a			; $5ff6
	ld (de),a		; $5ff7
	ret			; $5ff8
	pop hl			; $5ff9
	call $5fff		; $5ffa
	ld (de),a		; $5ffd
	ret			; $5ffe
	ld l,$b3		; $5fff
	ld e,l			; $6001
	ld a,(hl)		; $6002
	srl a			; $6003
	srl a			; $6005
	ret			; $6007

enemyCode4b:
	jr z,_label_0d_209	; $6008
	sub $03			; $600a
	ret c			; $600c
	jr nz,_label_0d_209	; $600d
	jp enemyDie		; $600f
_label_0d_209:
	call _ecom_seasonsFunc_4446		; $6012
	ld e,$84		; $6015
	ld a,(de)		; $6017
	rst_jumpTable			; $6018
	cpl			; $6019
	ld h,b			; $601a
	ld d,b			; $601b
	ld h,b			; $601c
	ld d,b			; $601d
	ld h,b			; $601e
	dec a			; $601f
	ld h,b			; $6020
	ld d,b			; $6021
	ld h,b			; $6022
	ld d,b			; $6023
	ld h,b			; $6024
	ld d,b			; $6025
	ld h,b			; $6026
	ld d,b			; $6027
	ld h,b			; $6028
	ld d,c			; $6029
	ld h,b			; $602a
	ld (hl),e		; $602b
	ld h,b			; $602c
	add d			; $602d
	ld h,b			; $602e
	call $60a9		; $602f
	ret nz			; $6032
	ld a,$0f		; $6033
	call _ecom_setSpeedAndState8AndVisible		; $6035
	ld l,$b1		; $6038
	ld (hl),$08		; $603a
	ret			; $603c
	inc e			; $603d
	ld a,(de)		; $603e
	rst_jumpTable			; $603f
	dec b			; $6040
	ld b,b			; $6041
	ld c,b			; $6042
	ld h,b			; $6043
	ld c,b			; $6044
	ld h,b			; $6045
	ld c,c			; $6046
	ld h,b			; $6047
	ret			; $6048
	ld e,$b1		; $6049
	ld a,(de)		; $604b
	ld b,a			; $604c
	jp _ecom_fallToGroundAndSetState		; $604d
	ret			; $6050
	ld c,$38		; $6051
	call objectCheckLinkWithinDistance		; $6053
	jr nc,_label_0d_210	; $6056
	call _ecom_incState		; $6058
	call $60ca		; $605b
	ld l,$86		; $605e
	ld (hl),$5a		; $6060
	ld l,$b0		; $6062
	inc (hl)		; $6064
	ld a,$01		; $6065
	jp enemySetAnimation		; $6067
_label_0d_210:
	call _ecom_updateAngleTowardTarget		; $606a
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $606d
_label_0d_211:
	jp enemyAnimate		; $6070
	call _ecom_decCounter1		; $6073
	jr nz,_label_0d_211	; $6076
	inc (hl)		; $6078
	ld l,e			; $6079
	inc (hl)		; $607a
	call $60ca		; $607b
	ld l,$b0		; $607e
	inc (hl)		; $6080
	ret			; $6081
	ld e,$86		; $6082
	ld a,(de)		; $6084
	or a			; $6085
	ret nz			; $6086
	ld c,$38		; $6087
	call objectCheckLinkWithinDistance		; $6089
	ld h,d			; $608c
	ld l,$84		; $608d
	jr nc,_label_0d_212	; $608f
	dec (hl)		; $6091
	call $60ca		; $6092
	ld l,$86		; $6095
	ld (hl),$5a		; $6097
	ld l,$b0		; $6099
	dec (hl)		; $609b
	ret			; $609c
_label_0d_212:
	ld (hl),$08		; $609d
	call $60ca		; $609f
	ld l,$b0		; $60a2
	xor a			; $60a4
	ld (hl),a		; $60a5
	jp enemySetAnimation		; $60a6
	ld b,$04		; $60a9
	call checkBEnemySlotsAvailable		; $60ab
	ret nz			; $60ae
	ld b,$2a		; $60af
	call _ecom_spawnProjectile		; $60b1
	ld c,h			; $60b4
	ld e,$01		; $60b5
_label_0d_213:
	call getFreePartSlot		; $60b7
	ld (hl),b		; $60ba
	inc l			; $60bb
	ld (hl),e		; $60bc
	ld l,$d6		; $60bd
	ld a,$c0		; $60bf
	ldi (hl),a		; $60c1
	ld (hl),c		; $60c2
	inc e			; $60c3
	ld a,e			; $60c4
	cp $04			; $60c5
	jr nz,_label_0d_213	; $60c7
	ret			; $60c9
	ld a,(hl)		; $60ca
	ld l,$b1		; $60cb
	ld (hl),a		; $60cd
	ret			; $60ce

enemyCode4d:
	call _ecom_checkHazards		; $60cf
	jr z,_label_0d_214	; $60d2
	sub $03			; $60d4
	ret c			; $60d6
	jp z,enemyDie		; $60d7
	dec a			; $60da
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $60db
	ret			; $60de
_label_0d_214:
	ld e,$84		; $60df
	ld a,(de)		; $60e1
	rst_jumpTable			; $60e2
	push af			; $60e3
	ld h,b			; $60e4
	ld a,($fa60)		; $60e5
	ld h,b			; $60e8
	ld a,($fa60)		; $60e9
	ld h,b			; $60ec
	bit 0,h			; $60ed
	ld a,($fa60)		; $60ef
	ld h,b			; $60f2
	ei			; $60f3
	ld h,b			; $60f4
	ld a,$0f		; $60f5
	jp _ecom_setSpeedAndState8AndVisible		; $60f7
	ret			; $60fa
	call _ecom_updateAngleTowardTarget		; $60fb
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $60fe
	jp enemyAnimate		; $6101

enemyCode4e:
	call _ecom_checkHazards		; $6104
	jr z,_label_0d_215	; $6107
	sub $03			; $6109
	ret c			; $610b
	jp z,enemyDie		; $610c
	dec a			; $610f
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6110
	ret			; $6113
_label_0d_215:
	ld e,$84		; $6114
	ld a,(de)		; $6116
	rst_jumpTable			; $6117
	ldi a,(hl)		; $6118
	ld h,c			; $6119
	ld c,b			; $611a
	ld h,c			; $611b
	ld c,b			; $611c
	ld h,c			; $611d
	inc a			; $611e
	ld h,c			; $611f
	ld c,b			; $6120
	ld h,c			; $6121
	bit 0,h			; $6122
	ld c,b			; $6124
	ld h,c			; $6125
	ld c,b			; $6126
	ld h,c			; $6127
	ld c,c			; $6128
	ld h,c			; $6129
	ld e,$b0		; $612a
	ld a,($d008)		; $612c
	add $02			; $612f
	and $03			; $6131
	ld (de),a		; $6133
	call enemySetAnimation		; $6134
	ld a,$28		; $6137
	jp _ecom_setSpeedAndState8AndVisible		; $6139
	inc e			; $613c
	ld a,(de)		; $613d
	rst_jumpTable			; $613e
	dec b			; $613f
	ld b,b			; $6140
	ld b,a			; $6141
	ld h,c			; $6142
	ld b,a			; $6143
	ld h,c			; $6144
	rst $38			; $6145
	ld b,h			; $6146
	ret			; $6147
	ret			; $6148
	ld a,($cc47)		; $6149
	inc a			; $614c
	ret z			; $614d
	add $0f			; $614e
	and $1f			; $6150
	ld e,$89		; $6152
	ld (de),a		; $6154
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6155
	ld h,d			; $6158
	ld l,$b0		; $6159
	ld a,($d008)		; $615b
	add $02			; $615e
	and $03			; $6160
	cp (hl)			; $6162
	jr z,_label_0d_216	; $6163
	ld (hl),a		; $6165
	call enemySetAnimation		; $6166
_label_0d_216:
	jp enemyAnimate		; $6169

enemyCode4f:
	call $6308		; $616c
	jr z,_label_0d_220	; $616f
	sub $03			; $6171
	ret c			; $6173
	jr z,_label_0d_217	; $6174
	dec a			; $6176
	jr nz,_label_0d_219	; $6177
	ld e,$82		; $6179
	ld a,(de)		; $617b
	dec a			; $617c
	jr nz,_label_0d_220	; $617d
	ld e,$ab		; $617f
	ld l,e			; $6181
	ld a,(de)		; $6182
	ld b,a			; $6183
	ld e,$b0		; $6184
	ld a,(de)		; $6186
	ld h,a			; $6187
	ld (hl),b		; $6188
	inc e			; $6189
	ld a,(de)		; $618a
	ld h,a			; $618b
	ld (hl),b		; $618c
	ret			; $618d
_label_0d_217:
	ld e,$82		; $618e
	ld a,(de)		; $6190
	dec a			; $6191
	jp nz,$62d8		; $6192
	ld e,$b0		; $6195
	ld a,(de)		; $6197
	ld h,a			; $6198
	call _ecom_killObjectH		; $6199
	inc e			; $619c
	ld a,(de)		; $619d
	ld h,a			; $619e
	call _ecom_killObjectH		; $619f
	ld a,($cc4c)		; $61a2
	cp $f4			; $61a5
	jr nz,_label_0d_218	; $61a7
	ld a,($cc49)		; $61a9
	or a			; $61ac
	jr nz,_label_0d_218	; $61ad
	inc a			; $61af
	ld ($cfc0),a		; $61b0
_label_0d_218:
	jp enemyDie		; $61b3
_label_0d_219:
	ld e,$82		; $61b6
	ld a,(de)		; $61b8
	dec a			; $61b9
	jr nz,_label_0d_220	; $61ba
	jp _ecom_updateKnockbackAndCheckHazards		; $61bc
_label_0d_220:
	call _ecom_getSubidAndCpStateTo08		; $61bf
	jr nc,_label_0d_221	; $61c2
	rst_jumpTable			; $61c4
	sbc $61			; $61c5
	pop af			; $61c7
	ld h,c			; $61c8
	ldi (hl),a		; $61c9
	ld h,d			; $61ca
	ldi (hl),a		; $61cb
	ld h,d			; $61cc
	ldi (hl),a		; $61cd
	ld h,d			; $61ce
	ldi (hl),a		; $61cf
	ld h,d			; $61d0
	ldi (hl),a		; $61d1
	ld h,d			; $61d2
	ldi (hl),a		; $61d3
	ld h,d			; $61d4
_label_0d_221:
	dec b			; $61d5
	ld a,b			; $61d6
	rst_jumpTable			; $61d7
	inc hl			; $61d8
	ld h,d			; $61d9
	ld l,c			; $61da
	ld h,d			; $61db
	ld l,c			; $61dc
	ld h,d			; $61dd
	ld a,b			; $61de
	or a			; $61df
	jr nz,_label_0d_222	; $61e0
	inc a			; $61e2
	ld (de),a		; $61e3
	jr _label_0d_223		; $61e4
_label_0d_222:
	call _ecom_setSpeedAndState8AndVisible		; $61e6
	ld a,b			; $61e9
	dec a			; $61ea
	ret z			; $61eb
	add $07			; $61ec
	jp enemySetAnimation		; $61ee
_label_0d_223:
	ld b,$03		; $61f1
	call checkBEnemySlotsAvailable		; $61f3
	jp nz,objectSetVisible82		; $61f6
	ld b,$4f		; $61f9
	call _ecom_spawnUncountedEnemyWithSubid01		; $61fb
	ld c,h			; $61fe
	push hl			; $61ff
	call _ecom_spawnEnemyWithSubid01		; $6200
	inc (hl)		; $6203
	call $62de		; $6204
	ld c,h			; $6207
	call _ecom_spawnEnemyWithSubid01		; $6208
	inc (hl)		; $620b
	inc (hl)		; $620c
	call $62de		; $620d
	ld b,h			; $6210
	pop hl			; $6211
	ld l,$b0		; $6212
	ld (hl),c		; $6214
	inc l			; $6215
	ld (hl),b		; $6216
	ld l,$80		; $6217
	ld e,l			; $6219
	ld a,(de)		; $621a
	ld (hl),a		; $621b
	call objectCopyPosition		; $621c
	jp enemyDelete		; $621f
	ret			; $6222
	ld a,(de)		; $6223
	sub $08			; $6224
	rst_jumpTable			; $6226
	dec hl			; $6227
	ld h,d			; $6228
	ld b,b			; $6229
	ld h,d			; $622a
	ld h,d			; $622b
	ld l,e			; $622c
	inc (hl)		; $622d
	ld l,$86		; $622e
	ld (hl),$08		; $6230
	ld l,$90		; $6232
	ld (hl),$28		; $6234
	ld l,$b3		; $6236
	ld (hl),$02		; $6238
	call _ecom_setRandomAngle		; $623a
	jp $62e7		; $623d
	call _ecom_decCounter1		; $6240
	jr nz,_label_0d_224	; $6243
	ld (hl),$08		; $6245
	ld l,$b3		; $6247
	ld e,$89		; $6249
	ld a,(de)		; $624b
	add (hl)		; $624c
	and $1f			; $624d
	ld (de),a		; $624f
	call $62e7		; $6250
	call getRandomNumber_noPreserveVars		; $6253
	and $0f			; $6256
	jr nz,_label_0d_224	; $6258
	ld e,$b3		; $625a
	ld a,(de)		; $625c
	cpl			; $625d
	inc a			; $625e
	ld (de),a		; $625f
_label_0d_224:
	call _ecom_bounceOffWallsAndHoles		; $6260
	call nz,$62e7		; $6263
	jp objectApplySpeed		; $6266
	ld e,$84		; $6269
	ld a,(de)		; $626b
	sub $08			; $626c
	rst_jumpTable			; $626e
	ld (hl),e		; $626f
	ld h,d			; $6270
	adc d			; $6271
	ld h,d			; $6272
	ld h,d			; $6273
	ld l,e			; $6274
	inc (hl)		; $6275
	ld l,$a4		; $6276
	res 7,(hl)		; $6278
	ld l,$97		; $627a
	ld h,(hl)		; $627c
	ld l,$8b		; $627d
	ld e,$b1		; $627f
	ldi a,(hl)		; $6281
	ld (de),a		; $6282
	inc e			; $6283
	inc l			; $6284
	ld a,(hl)		; $6285
	ld (de),a		; $6286
	jp $62f9		; $6287
	ld a,$00		; $628a
	call objectGetRelatedObject1Var		; $628c
	ld a,(hl)		; $628f
	or a			; $6290
	jr z,_label_0d_225	; $6291
	ld l,$8b		; $6293
	ld e,$b1		; $6295
	ld a,(de)		; $6297
	ld b,a			; $6298
	ldi a,(hl)		; $6299
	sub b			; $629a
	add $08			; $629b
	swap a			; $629d
	ld b,a			; $629f
	inc e			; $62a0
	inc l			; $62a1
	ld a,(de)		; $62a2
	ld c,a			; $62a3
	ld a,(hl)		; $62a4
	sub c			; $62a5
	add $08			; $62a6
	or b			; $62a8
	ld b,a			; $62a9
	ldd a,(hl)		; $62aa
	ld (de),a		; $62ab
	dec e			; $62ac
	dec l			; $62ad
	ld a,(hl)		; $62ae
	ld (de),a		; $62af
	ld e,$b0		; $62b0
	ld a,(de)		; $62b2
	add $b3			; $62b3
	ld e,a			; $62b5
	ld a,b			; $62b6
	ld (de),a		; $62b7
	ld h,d			; $62b8
	ld l,$8b		; $62b9
	ld e,$b0		; $62bb
	ld a,(de)		; $62bd
	inc a			; $62be
	and $07			; $62bf
	ld (de),a		; $62c1
	add $b3			; $62c2
	ld e,a			; $62c4
	ld a,(de)		; $62c5
	ld b,a			; $62c6
	and $f0			; $62c7
	swap a			; $62c9
	sub $08			; $62cb
	add (hl)		; $62cd
	ldi (hl),a		; $62ce
	inc l			; $62cf
	ld a,b			; $62d0
	and $0f			; $62d1
	sub $08			; $62d3
	add (hl)		; $62d5
	ld (hl),a		; $62d6
	ret			; $62d7
_label_0d_225:
	call decNumEnemies		; $62d8
	jp enemyDelete		; $62db
	ld l,$96		; $62de
	ld a,$80		; $62e0
	ldi (hl),a		; $62e2
	ld (hl),c		; $62e3
	jp objectCopyPosition		; $62e4
	ld e,$89		; $62e7
	ld a,(de)		; $62e9
	add $02			; $62ea
	and $1c			; $62ec
	rrca			; $62ee
	rrca			; $62ef
	ld h,d			; $62f0
	ld l,$b2		; $62f1
	cp (hl)			; $62f3
	ret z			; $62f4
	ld (hl),a		; $62f5
	jp enemySetAnimation		; $62f6
	ld h,d			; $62f9
	ld l,$b3		; $62fa
	ld b,$02		; $62fc
	ld a,$88		; $62fe
_label_0d_226:
	ldi (hl),a		; $6300
	ldi (hl),a		; $6301
	ldi (hl),a		; $6302
	ldi (hl),a		; $6303
	dec b			; $6304
	jr nz,_label_0d_226	; $6305
	ret			; $6307
	ld b,a			; $6308
	ld e,$82		; $6309
	ld a,(de)		; $630b
	dec a			; $630c
	jr z,_label_0d_227	; $630d
	ld a,$3f		; $630f
	call objectGetRelatedObject1Var		; $6311
	ld a,(hl)		; $6314
	and $07			; $6315
	jr nz,_label_0d_227	; $6317
	ld a,b			; $6319
	or a			; $631a
	ret			; $631b
_label_0d_227:
	ld a,b			; $631c
	jp _ecom_checkHazardsNoAnimationForHoles		; $631d

enemyCode50:
	dec a			; $6320
	ret z			; $6321
	dec a			; $6322
	ret z			; $6323
	ld e,$84		; $6324
	ld a,(de)		; $6326
	rst_jumpTable			; $6327
	inc a			; $6328
	ld h,e			; $6329
	ld c,b			; $632a
	ld h,e			; $632b
	adc c			; $632c
	ld h,e			; $632d
	adc c			; $632e
	ld h,e			; $632f
	adc c			; $6330
	ld h,e			; $6331
	adc c			; $6332
	ld h,e			; $6333
	adc c			; $6334
	ld h,e			; $6335
	adc c			; $6336
	ld h,e			; $6337
	adc d			; $6338
	ld h,e			; $6339
	sbc c			; $633a
	ld h,e			; $633b
	ld h,d			; $633c
	ld l,e			; $633d
	inc (hl)		; $633e
	ld e,$82		; $633f
	ld a,(de)		; $6341
	bit 7,a			; $6342
	ret z			; $6344
	ld (hl),$08		; $6345
	ret			; $6347
	xor a			; $6348
	ldh (<hFF8D),a	; $6349
	ld e,$8b		; $634b
	ld a,(de)		; $634d
	ld c,a			; $634e
	ld hl,$cf00		; $634f
	ld b,$b0		; $6352
_label_0d_228:
	ldi a,(hl)		; $6354
	cp c			; $6355
	jr nz,_label_0d_229	; $6356
	push bc			; $6358
	push hl			; $6359
	ld c,l			; $635a
	dec c			; $635b
	ld b,$50		; $635c
	call _ecom_spawnUncountedEnemyWithSubid01		; $635e
	jr nz,_label_0d_230	; $6361
	ld e,l			; $6363
	ld a,(de)		; $6364
	set 7,a			; $6365
	ldi (hl),a		; $6367
	ldh a,(<hFF8D)	; $6368
	inc a			; $636a
	and $03			; $636b
	ldh (<hFF8D),a	; $636d
	ld (hl),a		; $636f
	ld a,c			; $6370
	and $f0			; $6371
	add $06			; $6373
	ld l,$8b		; $6375
	ldi (hl),a		; $6377
	ld a,c			; $6378
	and $0f			; $6379
	swap a			; $637b
	add $08			; $637d
	inc l			; $637f
	ld (hl),a		; $6380
	pop hl			; $6381
	pop bc			; $6382
_label_0d_229:
	dec b			; $6383
	jr nz,_label_0d_228	; $6384
_label_0d_230:
	jp enemyDelete		; $6386
	ret			; $6389
	ld a,$09		; $638a
	ld (de),a		; $638c
	ld e,$83		; $638d
	ld a,(de)		; $638f
	ld hl,$63b6		; $6390
	rst_addAToHl			; $6393
	ld e,$86		; $6394
	ld a,(hl)		; $6396
	ld (de),a		; $6397
	ret			; $6398
	call $63ba		; $6399
	ld c,$24		; $639c
	call objectCheckLinkWithinDistance		; $639e
	ret c			; $63a1
	call _ecom_decCounter1		; $63a2
	ret nz			; $63a5
	ld b,$31		; $63a6
	call _ecom_spawnProjectile		; $63a8
	call getRandomNumber_noPreserveVars		; $63ab
	and $07			; $63ae
	add $c0			; $63b0
	ld e,$86		; $63b2
	ld (de),a		; $63b4
	ret			; $63b5
	ld c,(hl)		; $63b6
	ld a,(hl)		; $63b7
	xor (hl)		; $63b8
	sbc $1e			; $63b9
	add d			; $63bb
	ld a,(de)		; $63bc
	cp $81			; $63bd
	ret nz			; $63bf
	ld a,($cc30)		; $63c0
	or a			; $63c3
	ret nz			; $63c4
	jp enemyDelete		; $63c5

enemyCode51:
	call $653e		; $63c8
	or a			; $63cb
	jr z,_label_0d_233	; $63cc
	sub $03			; $63ce
	ret c			; $63d0
	jr z,_label_0d_231	; $63d1
	dec a			; $63d3
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $63d4
	ld e,$82		; $63d7
	ld a,(de)		; $63d9
	cp $02			; $63da
	ret nz			; $63dc
	ld e,$aa		; $63dd
	ld a,(de)		; $63df
	cp $80			; $63e0
	ret z			; $63e2
	ld h,d			; $63e3
	ld l,$84		; $63e4
	ld (hl),$0a		; $63e6
	ld l,$86		; $63e8
	ld (hl),$01		; $63ea
	ret			; $63ec
_label_0d_231:
	ld e,$82		; $63ed
	ld a,(de)		; $63ef
	dec a			; $63f0
	jr nz,_label_0d_232	; $63f1
	ld e,$97		; $63f3
	ld a,(de)		; $63f5
	or a			; $63f6
	jr z,_label_0d_232	; $63f7
	ld a,$30		; $63f9
	call objectGetRelatedObject1Var		; $63fb
	dec (hl)		; $63fe
_label_0d_232:
	jp enemyDie		; $63ff
_label_0d_233:
	call _ecom_getSubidAndCpStateTo08		; $6402
	jr nc,_label_0d_234	; $6405
	rst_jumpTable			; $6407
	ld hl,$2b64		; $6408
	ld h,h			; $640b
	ld l,c			; $640c
	ld h,h			; $640d
	ld e,b			; $640e
	ld h,h			; $640f
	ld l,c			; $6410
	ld h,h			; $6411
	ld b,h			; $6412
	ld h,h			; $6413
	ld l,c			; $6414
	ld h,h			; $6415
	ld l,c			; $6416
	ld h,h			; $6417
_label_0d_234:
	dec b			; $6418
	ld a,b			; $6419
	rst_jumpTable			; $641a
	ld l,d			; $641b
	ld h,h			; $641c
	xor (hl)		; $641d
	ld h,h			; $641e
.DB $dd				; $641f
	ld h,h			; $6420
	ld a,b			; $6421
	or a			; $6422
	ld a,$14		; $6423
	jp nz,_ecom_setSpeedAndState8		; $6425
	ld a,$01		; $6428
	ld (de),a		; $642a
	call _ecom_decCounter2		; $642b
	ret nz			; $642e
	ld c,$20		; $642f
	call objectCheckLinkWithinDistance		; $6431
	ret nc			; $6434
	ld e,$87		; $6435
	ld a,$5a		; $6437
	ld (de),a		; $6439
	ld b,$51		; $643a
	call _ecom_spawnEnemyWithSubid01		; $643c
	ret nz			; $643f
	inc (hl)		; $6440
	jp objectCopyPosition		; $6441
	call _ecom_galeSeedEffect		; $6444
	ret c			; $6447
	ld e,$97		; $6448
	ld a,(de)		; $644a
	or a			; $644b
	jr z,_label_0d_235	; $644c
	ld h,a			; $644e
	ld l,$b0		; $644f
	dec (hl)		; $6451
_label_0d_235:
	call decNumEnemies		; $6452
	jp enemyDelete		; $6455
	inc e			; $6458
	ld a,(de)		; $6459
	rst_jumpTable			; $645a
	dec b			; $645b
	ld b,b			; $645c
	ld h,e			; $645d
	ld h,h			; $645e
	ld h,e			; $645f
	ld h,h			; $6460
	ld h,h			; $6461
	ld h,h			; $6462
	ret			; $6463
	ld b,$0a		; $6464
	jp _ecom_fallToGroundAndSetState		; $6466
	ret			; $6469
	ld a,(de)		; $646a
	sub $08			; $646b
	rst_jumpTable			; $646d
	ld (hl),h		; $646e
	ld h,h			; $646f
	adc b			; $6470
	ld h,h			; $6471
	and d			; $6472
	ld h,h			; $6473
	ld h,d			; $6474
	ld l,e			; $6475
	inc (hl)		; $6476
	ld l,$a4		; $6477
	set 7,(hl)		; $6479
	ld c,$08		; $647b
	call _ecom_setZAboveScreen		; $647d
	call objectSetVisiblec1		; $6480
	ld a,$59		; $6483
	jp playSound		; $6485
	ld c,$0e		; $6488
	call objectUpdateSpeedZ_paramC		; $648a
	ret nz			; $648d
	ld l,$94		; $648e
	ldi (hl),a		; $6490
	ld (hl),a		; $6491
	ld l,$84		; $6492
	inc (hl)		; $6494
	call objectSetVisiblec2		; $6495
	ld a,$52		; $6498
	call playSound		; $649a
	call $6522		; $649d
	jr _label_0d_237		; $64a0
_label_0d_236:
	call _ecom_decCounter1		; $64a2
	call z,$6522		; $64a5
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $64a8
_label_0d_237:
	jp enemyAnimate		; $64ab
	ld a,(de)		; $64ae
	sub $08			; $64af
	rst_jumpTable			; $64b1
	cp b			; $64b2
	ld h,h			; $64b3
	push bc			; $64b4
	ld h,h			; $64b5
	and d			; $64b6
	ld h,h			; $64b7
	ld h,d			; $64b8
	ld l,e			; $64b9
	inc (hl)		; $64ba
	ld l,$86		; $64bb
	ld (hl),$1e		; $64bd
	call _ecom_updateCardinalAngleTowardTarget		; $64bf
	jp objectSetVisiblec2		; $64c2
	call _ecom_decCounter1		; $64c5
	jr nz,_label_0d_238	; $64c8
	inc (hl)		; $64ca
	ld l,e			; $64cb
	inc (hl)		; $64cc
	jr _label_0d_236		; $64cd
_label_0d_238:
	ld a,(hl)		; $64cf
	cp $16			; $64d0
	jr nz,_label_0d_239	; $64d2
	ld l,$a4		; $64d4
	set 7,(hl)		; $64d6
_label_0d_239:
	call _ecom_applyVelocityForSideviewEnemy		; $64d8
	jr _label_0d_237		; $64db
	ld a,(de)		; $64dd
	sub $08			; $64de
	rst_jumpTable			; $64e0
	rst $20			; $64e1
	ld h,h			; $64e2
	ld bc,$a265		; $64e3
	ld h,h			; $64e6
	ld h,d			; $64e7
	ld l,e			; $64e8
	inc (hl)		; $64e9
	ld l,$94		; $64ea
	ld a,$fe		; $64ec
	ldi (hl),a		; $64ee
	ld (hl),$fe		; $64ef
	ld l,$90		; $64f1
	ld (hl),$1e		; $64f3
	ld l,$89		; $64f5
	ld a,($d008)		; $64f7
	swap a			; $64fa
	rrca			; $64fc
	ld (hl),a		; $64fd
	jp objectSetVisiblec2		; $64fe
	ld c,$0e		; $6501
	call objectUpdateSpeedZAndBounce		; $6503
	jr c,_label_0d_241	; $6506
	ld a,$52		; $6508
	call z,playSound		; $650a
	ld e,$95		; $650d
	ld a,(de)		; $650f
	or a			; $6510
	jr nz,_label_0d_240	; $6511
	ld h,d			; $6513
	ld l,$a4		; $6514
	set 7,(hl)		; $6516
_label_0d_240:
	jp _ecom_applyVelocityForSideviewEnemyNoHoles		; $6518
_label_0d_241:
	call _ecom_incState		; $651b
	ld l,$90		; $651e
	ld (hl),$14		; $6520
	ld bc,$071c		; $6522
	call _ecom_randomBitwiseAndBCE		; $6525
	ld e,$89		; $6528
	ld a,c			; $652a
	ld (de),a		; $652b
	ld a,b			; $652c
	ld hl,$6536		; $652d
	rst_addAToHl			; $6530
	ld e,$86		; $6531
	ld a,(hl)		; $6533
	ld (de),a		; $6534
	ret			; $6535
	rrca			; $6536
	ld e,$1e		; $6537
	inc a			; $6539
	inc a			; $653a
	inc a			; $653b
	ld e,d			; $653c
	ld e,d			; $653d
	ld b,a			; $653e
	ld e,$84		; $653f
	ld a,(de)		; $6541
	cp $0a			; $6542
	ld a,b			; $6544
	ret c			; $6545
	ld h,d			; $6546
	ld l,$bf		; $6547
	bit 1,(hl)		; $6549
	jr z,_label_0d_242	; $654b
	ld l,$86		; $654d
	ld a,(hl)		; $654f
	cp $3b			; $6550
	jr nz,_label_0d_242	; $6552
	ld l,$97		; $6554
	ld a,(hl)		; $6556
	or a			; $6557
	jr z,_label_0d_242	; $6558
	ld h,a			; $655a
	ld l,$b0		; $655b
	dec (hl)		; $655d
_label_0d_242:
	ld a,b			; $655e
	jp _ecom_checkHazards		; $655f

enemyCode52:
	jr z,_label_0d_243	; $6562
	sub $03			; $6564
	ret c			; $6566
	jp $661c		; $6567
_label_0d_243:
	ld e,$84		; $656a
	ld a,(de)		; $656c
	rst_jumpTable			; $656d
	add (hl)		; $656e
	ld h,l			; $656f
	sub l			; $6570
	ld h,l			; $6571
	ld ($ff00+c),a		; $6572
	ld h,l			; $6573
	ld ($ff00+c),a		; $6574
	ld h,l			; $6575
	ld ($ff00+c),a		; $6576
	ld h,l			; $6577
	ld ($ff00+c),a		; $6578
	ld h,l			; $6579
	ld ($ff00+c),a		; $657a
	ld h,l			; $657b
	ld ($ff00+c),a		; $657c
	ld h,l			; $657d
.DB $e3				; $657e
	ld h,l			; $657f
	ld a,($ff00+$65)	; $6580
	ld ($1466),sp		; $6582
	ld h,(hl)		; $6585
	ld e,$82		; $6586
	ld a,(de)		; $6588
	rlca			; $6589
	ld a,$46		; $658a
	jp c,_ecom_setSpeedAndState8		; $658c
	ld e,$84		; $658f
	ld a,$01		; $6591
	ld (de),a		; $6593
	ret			; $6594
	inc e			; $6595
	ld a,(de)		; $6596
	rst_jumpTable			; $6597
	sbc h			; $6598
	ld h,l			; $6599
	cp b			; $659a
	ld h,l			; $659b
	ld h,d			; $659c
	ld l,e			; $659d
	inc (hl)		; $659e
	inc l			; $659f
	ld (hl),$78		; $65a0
	ld e,$82		; $65a2
	ld a,(de)		; $65a4
	ld hl,$663d		; $65a5
	rst_addDoubleIndex			; $65a8
	ldi a,(hl)		; $65a9
	ld h,(hl)		; $65aa
	ld l,a			; $65ab
	ld e,$83		; $65ac
	ldi a,(hl)		; $65ae
	ld (de),a		; $65af
	ld e,$b0		; $65b0
	ld a,l			; $65b2
	ld (de),a		; $65b3
	inc e			; $65b4
	ld a,h			; $65b5
	ld (de),a		; $65b6
	ret			; $65b7
	call _ecom_decCounter1		; $65b8
	ret nz			; $65bb
	ld (hl),$3c		; $65bc
	ld l,$b0		; $65be
	ldi a,(hl)		; $65c0
	ld h,(hl)		; $65c1
	ld l,a			; $65c2
	ldi a,(hl)		; $65c3
	ld c,a			; $65c4
	push hl			; $65c5
	call $65b0		; $65c6
	ld b,$52		; $65c9
	call _ecom_spawnEnemyWithSubid01		; $65cb
	jr nz,_label_0d_244	; $65ce
	ld l,$82		; $65d0
	ld e,$83		; $65d2
	ld a,(de)		; $65d4
	ld (hl),a		; $65d5
	ld l,$8b		; $65d6
	call setShortPosition_paramC		; $65d8
_label_0d_244:
	pop hl			; $65db
	ld a,(hl)		; $65dc
	or a			; $65dd
	ret nz			; $65de
	jp $6621		; $65df
	ret			; $65e2
	ld h,d			; $65e3
	ld l,e			; $65e4
	inc (hl)		; $65e5
	ld l,$a4		; $65e6
	set 7,(hl)		; $65e8
	call $6627		; $65ea
	jp objectSetVisiblec2		; $65ed
	ld h,d			; $65f0
	ld l,$8e		; $65f1
	ld a,(hl)		; $65f3
	sub $80			; $65f4
	ldi (hl),a		; $65f6
	ld a,(hl)		; $65f7
	sbc $00			; $65f8
	ld (hl),a		; $65fa
	cp $fd			; $65fb
	jr nc,_label_0d_245	; $65fd
	ld l,e			; $65ff
	inc (hl)		; $6600
	ld l,$86		; $6601
	ld (hl),$0f		; $6603
_label_0d_245:
	jp enemyAnimate		; $6605
	call _ecom_decCounter1		; $6608
	jr nz,_label_0d_245	; $660b
	ld l,e			; $660d
	inc (hl)		; $660e
	call _ecom_updateAngleTowardTarget		; $660f
	jr _label_0d_245		; $6612
	call objectApplySpeed		; $6614
	call objectCheckTileCollision_allowHoles		; $6617
	jr nc,_label_0d_245	; $661a
	ld b,$06		; $661c
	call objectCreateInteractionWithSubid00		; $661e
_label_0d_246:
	call decNumEnemies		; $6621
	jp enemyDelete		; $6624
	call objectGetShortPosition		; $6627
	ld c,a			; $662a
	ld e,$82		; $662b
	ld a,(de)		; $662d
	and $0f			; $662e
	ld hl,$6638		; $6630
	rst_addAToHl			; $6633
	ld a,(hl)		; $6634
	jp setTile		; $6635
	and b			; $6638
	di			; $6639
.DB $f4				; $663a
	ld c,h			; $663b
	and h			; $663c
	ld b,l			; $663d
	ld h,(hl)		; $663e
	ld d,e			; $663f
	ld h,(hl)		; $6640
	ld e,h			; $6641
	ld h,(hl)		; $6642
	ld a,l			; $6643
	ld h,(hl)		; $6644
	add d			; $6645
	inc (hl)		; $6646
	ld h,(hl)		; $6647
	ld b,h			; $6648
	ld d,(hl)		; $6649
	ld d,h			; $664a
	ld b,(hl)		; $664b
	ld h,h			; $664c
	ld (hl),$35		; $664d
	ld h,l			; $664f
	ld b,l			; $6650
	ld d,l			; $6651
	nop			; $6652
	add d			; $6653
	add hl,de		; $6654
	ld e,c			; $6655
	ld a,h			; $6656
	ld a,c			; $6657
	halt			; $6658
	ld (hl),e		; $6659
	sub e			; $665a
	nop			; $665b
	add b			; $665c
	ld d,a			; $665d
	ld b,(hl)		; $665e
	ld d,h			; $665f
	ld h,(hl)		; $6660
	scf			; $6661
	ld (hl),a		; $6662
	ld c,b			; $6663
	ld l,b			; $6664
	ld e,d			; $6665
	ld e,e			; $6666
	daa			; $6667
	add a			; $6668
	ld b,l			; $6669
	ld l,c			; $666a
	ld h,l			; $666b
	ld c,c			; $666c
	ld d,e			; $666d
	ld (hl),$78		; $666e
	jr c,_label_0d_248	; $6670
	ld b,h			; $6672
	ld l,d			; $6673
	ld h,h			; $6674
	ld c,d			; $6675
	ld d,l			; $6676
	ld e,c			; $6677
	ld b,a			; $6678
	ld h,a			; $6679
	ld d,(hl)		; $667a
	ld e,b			; $667b
	nop			; $667c
	add b			; $667d
	ld (hl),$76		; $667e
	jr c,_label_0d_250	; $6680
	ld b,h			; $6682
	ld h,h			; $6683
	ld c,d			; $6684
	ld l,d			; $6685
	ld h,$88		; $6686
	ld (hl),l		; $6688
	add hl,sp		; $6689
	dec (hl)		; $668a
	ld a,c			; $668b
	ld b,e			; $668c
	ld l,e			; $668d
	ld h,e			; $668e
	ld c,e			; $668f
	scf			; $6690
	add a			; $6691
	ld (hl),a		; $6692
	daa			; $6693
	ld d,e			; $6694
	inc (hl)		; $6695
	ld a,d			; $6696
	ld (hl),h		; $6697
	ldd a,(hl)		; $6698
	jr z,_label_0d_246	; $6699
	ld e,e			; $669b
	nop			; $669c

enemyCode53:
	ld e,$84		; $669d
	ld a,(de)		; $669f
	rst_jumpTable			; $66a0
	xor l			; $66a1
	ld h,(hl)		; $66a2
	add $66			; $66a3
	inc c			; $66a5
	ld h,a			; $66a6
	jr nz,$67		; $66a7
	ld b,a			; $66a9
	ld h,a			; $66aa
	ld h,d			; $66ab
	ld h,a			; $66ac
	ld a,($cc4e)		; $66ad
	cp $02			; $66b0
	jp nz,enemyDelete		; $66b2
	ld h,d			; $66b5
	ld l,e			; $66b6
	inc (hl)		; $66b7
	ld l,$82		; $66b8
	ld a,(hl)		; $66ba
	ld l,$9b		; $66bb
	ldi (hl),a		; $66bd
	ld (hl),a		; $66be
	ld l,$8f		; $66bf
	ld (hl),$f8		; $66c1
	jp objectSetVisiblec1		; $66c3
	ld h,d			; $66c6
	ld l,e			; $66c7
	inc (hl)		; $66c8
	ld l,$86		; $66c9
	ld (hl),$03		; $66cb
	ld l,$90		; $66cd
	ld (hl),$50		; $66cf
	call getRandomNumber_noPreserveVars		; $66d1
	and $06			; $66d4
	ld c,a			; $66d6
	ld b,$00		; $66d7
	ld e,$8b		; $66d9
	ld a,(de)		; $66db
	cp $40			; $66dc
	jr c,_label_0d_247	; $66de
	inc b			; $66e0
_label_0d_247:
	ld e,$8d		; $66e1
	ld a,(de)		; $66e3
	cp $50			; $66e4
	jr c,_label_0d_249	; $66e6
_label_0d_248:
	set 1,b			; $66e8
_label_0d_249:
	ld a,b			; $66ea
	ld hl,$6708		; $66eb
	rst_addAToHl			; $66ee
	ld a,(hl)		; $66ef
	add c			; $66f0
	and $1f			; $66f1
	ld e,$89		; $66f3
	ld (de),a		; $66f5
	ld e,$89		; $66f6
	ld a,(de)		; $66f8
	ld b,a			; $66f9
_label_0d_250:
	and $0f			; $66fa
	ret z			; $66fc
	ld a,b			; $66fd
	cp $10			; $66fe
	ld a,$01		; $6700
	jr c,_label_0d_251	; $6702
	dec a			; $6704
_label_0d_251:
	jp enemySetAnimation		; $6705
	ld ($1202),sp		; $6708
	jr -$33			; $670b
	ld l,h			; $670d
	ld h,a			; $670e
	jr nz,_label_0d_252	; $670f
	call _ecom_decCounter1		; $6711
	jr nz,_label_0d_253	; $6714
_label_0d_252:
	call _ecom_incState		; $6716
	ld l,$86		; $6719
	ld (hl),$0c		; $671b
_label_0d_253:
	jp enemyAnimate		; $671d
	call $676c		; $6720
	jr nz,_label_0d_254	; $6723
	call _ecom_decCounter1		; $6725
	jr z,_label_0d_254	; $6728
	ld a,(hl)		; $672a
	rrca			; $672b
	jr nc,_label_0d_253	; $672c
	ld l,$90		; $672e
	ld a,(hl)		; $6730
	sub $05			; $6731
	ld (hl),a		; $6733
	jr _label_0d_253		; $6734
_label_0d_254:
	ld e,$84		; $6736
	ld a,$04		; $6738
	ld (de),a		; $673a
	call getRandomNumber_noPreserveVars		; $673b
	and $07			; $673e
	add $18			; $6740
	ld e,$86		; $6742
	ld (de),a		; $6744
	jr _label_0d_253		; $6745
	call $676c		; $6747
	jr nz,_label_0d_255	; $674a
	call _ecom_decCounter1		; $674c
	jr nz,_label_0d_253	; $674f
_label_0d_255:
	call getRandomNumber_noPreserveVars		; $6751
	and $7f			; $6754
	add $20			; $6756
	ld e,$86		; $6758
	ld (de),a		; $675a
	ld e,$84		; $675b
	ld a,$05		; $675d
	ld (de),a		; $675f
	jr _label_0d_253		; $6760
	call _ecom_decCounter1		; $6762
	jr nz,_label_0d_253	; $6765
	ld l,e			; $6767
	ld (hl),$01		; $6768
	jr _label_0d_253		; $676a
	ld a,$02		; $676c
	call _ecom_getSideviewAdjacentWallsBitset		; $676e
	ret nz			; $6771
	call objectApplySpeed		; $6772
	xor a			; $6775
	ret			; $6776

enemyCode58:
	jr z,_label_0d_256	; $6777
	sub $03			; $6779
	ret c			; $677b
	jp z,$6817		; $677c
_label_0d_256:
	ld e,$84		; $677f
	ld a,(de)		; $6781
	rst_jumpTable			; $6782
	sub l			; $6783
	ld h,a			; $6784
.DB $fd				; $6785
	ld h,a			; $6786
	or a			; $6787
	ld h,a			; $6788
.DB $e3				; $6789
	ld h,a			; $678a
.DB $fd				; $678b
	ld h,a			; $678c
.DB $fd				; $678d
	ld h,a			; $678e
.DB $fd				; $678f
	ld h,a			; $6790
.DB $fd				; $6791
	ld h,a			; $6792
	cp $67			; $6793
	ld e,$82		; $6795
	ld a,(de)		; $6797
	ld hl,$67af		; $6798
	rst_addDoubleIndex			; $679b
	ld e,$a5		; $679c
	ldi a,(hl)		; $679e
	ld (de),a		; $679f
	ld a,(hl)		; $67a0
	call objectMimicBgTile		; $67a1
	call $6854		; $67a4
	call _ecom_setSpeedAndState8		; $67a7
	call $6839		; $67aa
	jr _label_0d_257		; $67ad
	ld a,$c4		; $67af
	ld a,$20		; $67b1
	ld c,a			; $67b3
	stop			; $67b4
	ld c,a			; $67b5
	ret nz			; $67b6
	inc e			; $67b7
	ld a,(de)		; $67b8
	rst_jumpTable			; $67b9
	jp nz,$d367		; $67ba
	ld h,a			; $67bd
	call nc,$de67		; $67be
	ld h,a			; $67c1
	ld h,d			; $67c2
	ld l,e			; $67c3
	inc (hl)		; $67c4
	ld l,$a4		; $67c5
	res 7,(hl)		; $67c7
	xor a			; $67c9
	ld (wLinkGrabState2),a		; $67ca
	call $682c		; $67cd
	jp objectSetVisible81		; $67d0
	ret			; $67d3
	ld h,d			; $67d4
	ld l,$80		; $67d5
	res 1,(hl)		; $67d7
	ld l,$8f		; $67d9
	bit 7,(hl)		; $67db
	ret nz			; $67dd
	call objectSetPriorityRelativeToLink		; $67de
	jr _label_0d_258		; $67e1
	inc e			; $67e3
	ld a,(de)		; $67e4
	rst_jumpTable			; $67e5
	xor $67			; $67e6
.DB $f4				; $67e8
	ld h,a			; $67e9
.DB $f4				; $67ea
	ld h,a			; $67eb
	push af			; $67ec
	ld h,a			; $67ed
	call $682c		; $67ee
	jp _ecom_incState2		; $67f1
	ret			; $67f4
	ld c,$20		; $67f5
	call objectUpdateSpeedZ_paramC		; $67f7
	ret nz			; $67fa
	jr _label_0d_258		; $67fb
	ret			; $67fd
	ld a,$01		; $67fe
	call objectGetRelatedObject1Var		; $6800
	ld e,$b0		; $6803
	ld a,(de)		; $6805
	cp (hl)			; $6806
	jp nz,enemyDelete		; $6807
	ld l,$83		; $680a
	ld a,(hl)		; $680c
	rlca			; $680d
	call c,objectAddToGrabbableObjectBuffer		; $680e
	call $6839		; $6811
_label_0d_257:
	jp objectSetPriorityRelativeToLink		; $6814
	call $682c		; $6817
_label_0d_258:
	ld e,$82		; $681a
	ld a,(de)		; $681c
	ld hl,$6828		; $681d
	rst_addAToHl			; $6820
	ld b,(hl)		; $6821
	call objectCreateInteractionWithSubid00		; $6822
	jp enemyDelete		; $6825
	nop			; $6828
	nop			; $6829
	ld b,$06		; $682a
	ld a,$1a		; $682c
	call objectGetRelatedObject1Var		; $682e
	set 7,(hl)		; $6831
	ld l,$98		; $6833
	xor a			; $6835
	ldi (hl),a		; $6836
	ld (hl),a		; $6837
	ret			; $6838
	ld a,$0b		; $6839
	call objectGetRelatedObject1Var		; $683b
	call objectTakePosition		; $683e
	ld l,$83		; $6841
	ld a,(hl)		; $6843
	and $03			; $6844
	ld hl,$6850		; $6846
	rst_addAToHl			; $6849
	ld e,$8f		; $684a
	ld a,(de)		; $684c
	add (hl)		; $684d
	ld (de),a		; $684e
	ret			; $684f
	nop			; $6850
.DB $fc				; $6851
	ld hl,sp-$0c		; $6852
	ld a,$01		; $6854
	call objectGetRelatedObject1Var		; $6856
	ld e,$b0		; $6859
	ld a,(hl)		; $685b
	ld (de),a		; $685c
	cp $27			; $685d
	ret nz			; $685f
	ld e,$a5		; $6860
	ld a,$4f		; $6862
	ld (de),a		; $6864
	ret			; $6865

enemyCode59:
	ld e,$84		; $6866
	ld a,(de)		; $6868
	or a			; $6869
	jr nz,_label_0d_259	; $686a
	ld a,$01		; $686c
	ld (de),a		; $686e
	call objectGetTileAtPosition		; $686f
	ld e,$b0		; $6872
	ld (de),a		; $6874
_label_0d_259:
	call objectGetTileAtPosition		; $6875
	ld h,d			; $6878
	ld l,$b0		; $6879
	cp (hl)			; $687b
	ret z			; $687c
	ld e,$82		; $687d
	ld a,(de)		; $687f
	call checkItemDropAvailable		; $6880
	jp z,enemyDelete		; $6883
	call getFreePartSlot		; $6886
	ret nz			; $6889
	ld (hl),$01		; $688a
	inc l			; $688c
	ld e,$82		; $688d
	ld a,(de)		; $688f
	ld (hl),a		; $6890
	call objectCopyPosition		; $6891
	call markEnemyAsKilledInRoom		; $6894
	jp enemyDelete		; $6897

enemyCode5a:
	ld e,$84		; $689a
	ld a,(de)		; $689c
	or a			; $689d
	jr nz,$6d		; $689e
	ld a,$01		; $68a0
	ld (de),a		; $68a2
	ld e,$82		; $68a3
	ld a,(de)		; $68a5
	ld b,a			; $68a6
	add a			; $68a7
	add b			; $68a8
	ld hl,$68fb		; $68a9
	rst_addAToHl			; $68ac
	ldi a,(hl)		; $68ad
	ldh (<hFF8B),a	; $68ae
	ldi a,(hl)		; $68b0
	ld b,a			; $68b1
	ld a,($cc4e)		; $68b2
	cp b			; $68b5
	jp nz,enemyDelete		; $68b6
	ld a,(hl)		; $68b9
	cpl			; $68ba
	ld e,$88		; $68bb
	ld (de),a		; $68bd
	ld a,($cc69)		; $68be
	and (hl)		; $68c1
	jp z,enemyDelete		; $68c2
	xor a			; $68c5
	call $68d0		; $68c6
	ld a,$01		; $68c9
	call $68d0		; $68cb
	ld a,$02		; $68ce
	ld hl,$68f5		; $68d0
	rst_addDoubleIndex			; $68d3
	ld e,$8b		; $68d4
	ld a,(de)		; $68d6
	add (hl)		; $68d7
	inc hl			; $68d8
	ld b,a			; $68d9
	ld e,$8d		; $68da
	ld a,(de)		; $68dc
	add (hl)		; $68dd
	ld c,a			; $68de
	call getFreePartSlot		; $68df
	ld (hl),$10		; $68e2
	inc l			; $68e4
	ldh a,(<hFF8B)	; $68e5
	ld (hl),a		; $68e7
	ld l,$cb		; $68e8
	ld (hl),b		; $68ea
	ld l,$cd		; $68eb
	ld (hl),c		; $68ed
	ld l,$d8		; $68ee
	ld (hl),$80		; $68f0
	inc l			; $68f2
	ld (hl),d		; $68f3
	ret			; $68f4
	ld hl,sp+$00		; $68f5
	nop			; $68f7
	ld hl,sp+$00		; $68f8
	ld ($0300),sp		; $68fa
	add b			; $68fd
	inc b			; $68fe
	ld bc,$0140		; $68ff
	nop			; $6902
	jr nz,_label_0d_260	; $6903
	ld (bc),a		; $6905
	stop			; $6906
_label_0d_260:
	inc bc			; $6907
	ld bc,$0308		; $6908
	ld bc,$1e04		; $690b
	add e			; $690e
	ld a,(de)		; $690f
	or a			; $6910
	ret z			; $6911
	ld e,$88		; $6912
	ld a,(de)		; $6914
	ld hl,$cc69		; $6915
	and (hl)		; $6918
	ld (hl),a		; $6919
	jp enemyDelete		; $691a

enemyCode5d:
	jr z,_label_0d_261	; $691d
	sub $03			; $691f
	ret c			; $6921
	ld e,$aa		; $6922
	ld a,(de)		; $6924
	cp $80			; $6925
	jr z,_label_0d_261	; $6927
	res 7,a			; $6929
	sub $02			; $692b
	cp $02			; $692d
	call c,$6980		; $692f
	call _ecom_updateCardinalAngleAwayFromTarget		; $6932
_label_0d_261:
	ld e,$84		; $6935
	ld a,(de)		; $6937
	rst_jumpTable			; $6938
	ccf			; $6939
	ld l,c			; $693a
	ld d,(hl)		; $693b
	ld l,c			; $693c
	ld e,(hl)		; $693d
	ld l,c			; $693e
	ld h,d			; $693f
	ld l,e			; $6940
	inc (hl)		; $6941
	ld l,$90		; $6942
	ld (hl),$46		; $6944
	ld l,$86		; $6946
	ld (hl),$78		; $6948
	ld l,$be		; $694a
	ld (hl),$08		; $694c
	ld a,$98		; $694e
	call playSound		; $6950
	jp objectSetVisible82		; $6953
	call _ecom_decCounter1		; $6956
	jp nz,enemyAnimate		; $6959
	ld l,e			; $695c
	inc (hl)		; $695d
	ld a,$29		; $695e
	call objectGetRelatedObject1Var		; $6960
	ld a,(hl)		; $6963
	or a			; $6964
	jr z,_label_0d_262	; $6965
	ld l,$84		; $6967
	ld a,(hl)		; $6969
	cp $0a			; $696a
	jr z,_label_0d_262	; $696c
	call objectApplySpeed		; $696e
	call _ecom_bounceOffWallsAndHoles		; $6971
	ret z			; $6974
	ld a,$50		; $6975
	jp playSound		; $6977
_label_0d_262:
	call objectCreatePuff		; $697a
	jp enemyDelete		; $697d
	ld a,($d008)		; $6980
	swap a			; $6983
	ld b,a			; $6985
	ld e,$89		; $6986
	ld a,(de)		; $6988
	add b			; $6989
	ld hl,$6997		; $698a
	rst_addAToHl			; $698d
	ld e,$89		; $698e
	ld a,(hl)		; $6990
	ld (de),a		; $6991
	ld a,$50		; $6992
	jp playSound		; $6994
	stop			; $6997
	rrca			; $6998
	ld c,$0d		; $6999
	inc c			; $699b
	dec bc			; $699c
	ld a,(bc)		; $699d
	add hl,bc		; $699e
	ld ($0607),sp		; $699f
	dec b			; $69a2
	inc b			; $69a3
	inc bc			; $69a4
	ld (bc),a		; $69a5
	ld bc,$1f00		; $69a6
	ld e,$1d		; $69a9
	inc e			; $69ab
	dec de			; $69ac
	ld a,(de)		; $69ad
	add hl,de		; $69ae
	jr $17			; $69af
	ld d,$15		; $69b1
	inc d			; $69b3
	inc de			; $69b4
	ld (de),a		; $69b5
	ld de,$0f10		; $69b6
	ld c,$0d		; $69b9
	inc c			; $69bb
	dec bc			; $69bc
	ld a,(bc)		; $69bd
	add hl,bc		; $69be
	ld ($0607),sp		; $69bf
	dec b			; $69c2
	inc b			; $69c3
	inc bc			; $69c4
	ld (bc),a		; $69c5
	ld bc,$1f00		; $69c6
	ld e,$1d		; $69c9
	inc e			; $69cb
	dec de			; $69cc
	ld a,(de)		; $69cd
	add hl,de		; $69ce
	jr $17			; $69cf
	ld d,$15		; $69d1
	inc d			; $69d3
	inc de			; $69d4
	ld (de),a		; $69d5
	ld de,$0f10		; $69d6
	ld c,$0d		; $69d9
	inc c			; $69db
	dec bc			; $69dc
	ld a,(bc)		; $69dd
	add hl,bc		; $69de
	ld ($0607),sp		; $69df
	dec b			; $69e2
	inc b			; $69e3
	inc bc			; $69e4
	ld (bc),a		; $69e5
	.db $01

enemyCode5e:
	jr z,++		; $69e7
	sub $03			; $69e9
	ret c			; $69eb
	jp z,enemyDie_uncounted		; $69ec
++
	ld a,$01		; $69ef
	call objectGetRelatedObject1Var		; $69f1
	ld a,(hl)		; $69f4
	cp $01			; $69f5
	jp nz,enemyDelete		; $69f7
	ld e,$86		; $69fa
	ld a,(de)		; $69fc
	inc a			; $69fd
	and $1f			; $69fe
	ld a,$78		; $6a00
	call z,playSound		; $6a02
	ld e,$84		; $6a05
	ld a,(de)		; $6a07
	rst_jumpTable			; $6a08
	rrca			; $6a09
	ld l,d			; $6a0a
	jr z,_label_0d_264	; $6a0b
	dec (hl)		; $6a0d
	ld l,d			; $6a0e
	ld h,d			; $6a0f
	ld l,e			; $6a10
	inc (hl)		; $6a11
	ld l,$90		; $6a12
	ld (hl),$50		; $6a14
	ld l,$87		; $6a16
	ld (hl),$50		; $6a18
	call getRandomNumber_noPreserveVars		; $6a1a
	ld e,$86		; $6a1d
	ld (de),a		; $6a1f
	ld a,$a8		; $6a20
	call playSound		; $6a22
	jp objectSetVisible82		; $6a25
	call $6a50		; $6a28
	call _ecom_decCounter2		; $6a2b
	jr nz,_label_0d_263	; $6a2e
	ld l,e			; $6a30
	inc (hl)		; $6a31
	call _ecom_updateAngleTowardTarget		; $6a32
	call $6a44		; $6a35
	jp nc,enemyDelete		; $6a38
	call $6a50		; $6a3b
	call objectApplySpeed		; $6a3e
_label_0d_263:
	jp enemyAnimate		; $6a41
	ld e,$8b		; $6a44
	ld a,(de)		; $6a46
	cp $b0			; $6a47
	ret nc			; $6a49
	ld e,$8d		; $6a4a
	ld a,(de)		; $6a4c
	cp $f0			; $6a4d
	ret			; $6a4f
	call _ecom_decCounter1		; $6a50
	ld a,(hl)		; $6a53
	and $04			; $6a54
	rrca			; $6a56
	rrca			; $6a57
	add $02			; $6a58
	ld l,$9b		; $6a5a
	ldi (hl),a		; $6a5c
	ld (hl),a		; $6a5d
	ret			; $6a5e

enemyCode60:
	ld e,$82		; $6a5f
	ld a,(de)		; $6a61
	or a			; $6a62
	ld e,$b1		; $6a63
	jr z,_label_0d_268	; $6a65
	ld a,(de)		; $6a67
	or a			; $6a68
	jr nz,_label_0d_265	; $6a69
	ld h,d			; $6a6b
	ld l,e			; $6a6c
	inc (hl)		; $6a6d
	ld l,$90		; $6a6e
	ld (hl),$50		; $6a70
	call objectSetVisible83		; $6a72
	ld a,$d3		; $6a75
_label_0d_264:
	call playSound		; $6a77
_label_0d_265:
	ld bc,$5478		; $6a7a
	ld e,$8b		; $6a7d
	ld a,(de)		; $6a7f
	ldh (<hFF8F),a	; $6a80
	ld e,$8d		; $6a82
	ld a,(de)		; $6a84
	ldh (<hFF8E),a	; $6a85
	sub c			; $6a87
	add $08			; $6a88
	cp $11			; $6a8a
	jr nc,_label_0d_266	; $6a8c
	ldh a,(<hFF8F)	; $6a8e
	sub b			; $6a90
	add $08			; $6a91
	cp $11			; $6a93
	jp c,enemyDelete		; $6a95
_label_0d_266:
	ld a,(wFrameCounter)		; $6a98
	and $07			; $6a9b
	jr nz,_label_0d_267	; $6a9d
	call objectGetRelativeAngleWithTempVars		; $6a9f
	call objectNudgeAngleTowards		; $6aa2
_label_0d_267:
	call objectApplySpeed		; $6aa5
	jp _ecom_flickerVisibility		; $6aa8
_label_0d_268:
	ld a,(de)		; $6aab
	or a			; $6aac
	jr nz,_label_0d_269	; $6aad
	ld a,($c4ab)		; $6aaf
	or a			; $6ab2
	ret nz			; $6ab3
	ld h,d			; $6ab4
	ld l,e			; $6ab5
	inc (hl)		; $6ab6
	ld l,$b0		; $6ab7
	ld (hl),$28		; $6ab9
	call hideStatusBar		; $6abb
	ldh a,(<hActiveObject)	; $6abe
	ld d,a			; $6ac0
	ld a,$0e		; $6ac1
	call fadeoutToBlackWithDelay		; $6ac3
	xor a			; $6ac6
	ld ($c4b2),a		; $6ac7
	ld ($c4b4),a		; $6aca
_label_0d_269:
	call _ecom_decCounter2		; $6acd
	ret nz			; $6ad0
	dec l			; $6ad1
	ld a,(hl)		; $6ad2
	cp $10			; $6ad3
	inc (hl)		; $6ad5
	jr nc,_label_0d_270	; $6ad6
	call $6af4		; $6ad8
	ld e,$b0		; $6adb
	ld a,(de)		; $6add
	ld e,$87		; $6ade
	ld (de),a		; $6ae0
	ld e,$b0		; $6ae1
	ld a,(de)		; $6ae3
	sub $04			; $6ae4
	cp $10			; $6ae6
	ret c			; $6ae8
	ld (de),a		; $6ae9
	ret			; $6aea
_label_0d_270:
	ld a,$06		; $6aeb
	call objectGetRelatedObject1Var		; $6aed
	inc (hl)		; $6af0
	jp enemyDelete		; $6af1
	call getFreeEnemySlot_uncounted		; $6af4
	ret nz			; $6af7
	ld (hl),$60		; $6af8
	inc l			; $6afa
	inc (hl)		; $6afb
	ld e,$86		; $6afc
	ld a,(de)		; $6afe
	and $07			; $6aff
	ld b,a			; $6b01
	add a			; $6b02
	add b			; $6b03
	ld bc,$6b18		; $6b04
	call addAToBc		; $6b07
	ld l,$8b		; $6b0a
	ld a,(bc)		; $6b0c
	ldi (hl),a		; $6b0d
	inc l			; $6b0e
	inc bc			; $6b0f
	ld a,(bc)		; $6b10
	ld (hl),a		; $6b11
	ld l,$89		; $6b12
	inc bc			; $6b14
	ld a,(bc)		; $6b15
	ld (hl),a		; $6b16
	ret			; $6b17
	ld h,b			; $6b18
	ld a,($ff00+$19)	; $6b19
	cp b			; $6b1b
	ret nc			; $6b1c
	nop			; $6b1d
	sub b			; $6b1e
	nop			; $6b1f
	ld (bc),a		; $6b20
	ld b,b			; $6b21
	ld a,($ff00+$16)	; $6b22
	cp b			; $6b24
	ld h,b			; $6b25
	ld e,$b8		; $6b26
	jr nz,_label_0d_271	; $6b28
	sub b			; $6b2a
	ld a,($ff00+$18)	; $6b2b
	ld b,b			; $6b2d
	nop			; $6b2e
_label_0d_271:
	ld b,$46		; $6b2f
	ld l,e			; $6b31
	ld d,e			; $6b32
	ld l,e			; $6b33
	ld h,b			; $6b34
	ld l,e			; $6b35
	ld l,l			; $6b36
	ld l,e			; $6b37
	ld a,d			; $6b38
	ld l,e			; $6b39
	add a			; $6b3a
	ld l,e			; $6b3b
	sub b			; $6b3c
	ld l,e			; $6b3d
	sbc c			; $6b3e
	ld l,e			; $6b3f
	and d			; $6b40
	ld l,e			; $6b41
	xor e			; $6b42
	ld l,e			; $6b43
	or h			; $6b44
	ld l,e			; $6b45
	inc d			; $6b46
	nop			; $6b47
	ld (bc),a		; $6b48
	jr c,_label_0d_272	; $6b49
	inc d			; $6b4b
	inc b			; $6b4c
	jr _label_0d_273		; $6b4d
	inc d			; $6b4f
_label_0d_272:
	nop			; $6b50
	ld c,b			; $6b51
	ld l,e			; $6b52
	inc a			; $6b53
_label_0d_273:
	nop			; $6b54
	ld (bc),a		; $6b55
	ld c,b			; $6b56
	dec b			; $6b57
	inc d			; $6b58
	inc b			; $6b59
	jr $05			; $6b5a
	inc d			; $6b5c
	nop			; $6b5d
	ld d,l			; $6b5e
	ld l,e			; $6b5f
	jr z,_label_0d_274	; $6b60
_label_0d_274:
	ld (bc),a		; $6b62
	ld c,b			; $6b63
	dec b			; $6b64
	inc d			; $6b65
	inc b			; $6b66
	jr _label_0d_275		; $6b67
	inc d			; $6b69
	nop			; $6b6a
	ld h,d			; $6b6b
	ld l,e			; $6b6c
	inc d			; $6b6d
_label_0d_275:
	nop			; $6b6e
	ld (bc),a		; $6b6f
	ld c,b			; $6b70
	dec b			; $6b71
	inc d			; $6b72
	inc b			; $6b73
	jr _label_0d_276		; $6b74
	inc d			; $6b76
	nop			; $6b77
	ld l,a			; $6b78
	ld l,e			; $6b79
	inc d			; $6b7a
_label_0d_276:
	nop			; $6b7b
	ld (bc),a		; $6b7c
	ret c			; $6b7d
	dec b			; $6b7e
	inc d			; $6b7f
	inc b			; $6b80
	cp b			; $6b81
	dec b			; $6b82
	inc d			; $6b83
	nop			; $6b84
	ld a,h			; $6b85
	ld l,e			; $6b86
	ld a,b			; $6b87
	nop			; $6b88
	ld (bc),a		; $6b89
	ld a,b			; $6b8a
	inc b			; $6b8b
	jr c,_label_0d_277	; $6b8c
_label_0d_277:
	adc c			; $6b8e
	ld l,e			; $6b8f
	ld (hl),e		; $6b90
	nop			; $6b91
	ld (bc),a		; $6b92
	ld a,b			; $6b93
	inc b			; $6b94
	jr c,_label_0d_278	; $6b95
_label_0d_278:
	sub d			; $6b97
	ld l,e			; $6b98
	ld l,(hl)		; $6b99
	nop			; $6b9a
	ld (bc),a		; $6b9b
	ld a,b			; $6b9c
	inc b			; $6b9d
	jr c,_label_0d_279	; $6b9e
_label_0d_279:
	sbc e			; $6ba0
	ld l,e			; $6ba1
	ld l,c			; $6ba2
	nop			; $6ba3
	ld (bc),a		; $6ba4
	ld a,b			; $6ba5
	inc b			; $6ba6
	jr c,_label_0d_280	; $6ba7
_label_0d_280:
	and h			; $6ba9
	ld l,e			; $6baa
	ld h,h			; $6bab
	nop			; $6bac
	ld (bc),a		; $6bad
	ld a,b			; $6bae
	inc b			; $6baf
	jr c,_label_0d_281	; $6bb0
_label_0d_281:
	xor l			; $6bb2
	ld l,e			; $6bb3
	ld e,a			; $6bb4
	nop			; $6bb5
	ld (bc),a		; $6bb6
	ld a,b			; $6bb7
	inc b			; $6bb8
	jr c,_label_0d_282	; $6bb9
_label_0d_282:
	or (hl)			; $6bbb
	ld l,e			; $6bbc

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
