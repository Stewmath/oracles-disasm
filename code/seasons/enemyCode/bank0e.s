; ==============================================================================
; ENEMYID_BROTHER_GORIYAS
; ==============================================================================
enemyCode70:
	jr z,+			; $45a2
	sub $03			; $45a4
	ret c			; $45a6
	jp z,$477a		; $45a7
	dec a			; $45aa
	jp nz,_ecom_updateKnockback		; $45ab
+
	call _ecom_getSubidAndCpStateTo08		; $45ae
	jr nc,_label_0e_043	; $45b1
	rst_jumpTable			; $45b3
	jp z,$0c45		; $45b4
	ld b,(hl)		; $45b7
	inc c			; $45b8
	ld b,(hl)		; $45b9
	inc c			; $45ba
	ld b,(hl)		; $45bb
	inc c			; $45bc
	ld b,(hl)		; $45bd
	inc c			; $45be
	ld b,(hl)		; $45bf
	inc c			; $45c0
	ld b,(hl)		; $45c1
	inc c			; $45c2
	ld b,(hl)		; $45c3
_label_0e_043:
	ld a,b			; $45c4
	rst_jumpTable			; $45c5
	dec c			; $45c6
	ld b,(hl)		; $45c7
	ld a,$47		; $45c8
	ld e,$97		; $45ca
	ld a,(de)		; $45cc
	or a			; $45cd
	jr nz,_label_0e_044	; $45ce
	ld b,$70		; $45d0
	call _ecom_spawnEnemyWithSubid01		; $45d2
	ret nz			; $45d5
	ld l,$96		; $45d6
	ld e,l			; $45d8
	ld a,$80		; $45d9
	ldi (hl),a		; $45db
	ld (de),a		; $45dc
	inc e			; $45dd
	ld (hl),d		; $45de
	ld a,h			; $45df
	ld (de),a		; $45e0
	call objectCopyPosition		; $45e1
	ld a,d			; $45e4
	cp h			; $45e5
	jr c,_label_0e_044	; $45e6
	ld l,$82		; $45e8
	xor a			; $45ea
	ld (hl),a		; $45eb
	ld e,l			; $45ec
	inc a			; $45ed
	ld (de),a		; $45ee
	ret			; $45ef
_label_0e_044:
	ld a,$32		; $45f0
	call _ecom_setSpeedAndState8AndVisible		; $45f2
	ld e,$82		; $45f5
	ld a,(de)		; $45f7
	or a			; $45f8
	jr z,_label_0e_045	; $45f9
	ld e,$8d		; $45fb
	ld a,(de)		; $45fd
	cpl			; $45fe
	inc a			; $45ff
	ld (de),a		; $4600
	ret			; $4601
_label_0e_045:
	ld e,$b0		; $4602
	inc a			; $4604
	ld (de),a		; $4605
	ld b,$00		; $4606
	dec a			; $4608
	jp _enemyBoss_initializeRoom		; $4609
	ret			; $460c
	ld a,(de)		; $460d
	sub $08			; $460e
	rst_jumpTable			; $4610
	add hl,de		; $4611
	ld b,(hl)		; $4612
	adc e			; $4613
	ld b,(hl)		; $4614
	add sp,$46		; $4615
	inc hl			; $4617
	ld b,a			; $4618
	inc e			; $4619
	ld a,(de)		; $461a
	rst_jumpTable			; $461b
	ldi (hl),a		; $461c
	ld b,(hl)		; $461d
	dec (hl)		; $461e
	ld b,(hl)		; $461f
	ld b,b			; $4620
	ld b,(hl)		; $4621
	ld a,($d00b)		; $4622
	cp $78			; $4625
	ret nc			; $4627
	ld h,d			; $4628
	ld l,e			; $4629
	inc (hl)		; $462a
	ld l,$a4		; $462b
	set 7,(hl)		; $462d
	ld bc,$2f00		; $462f
	jp showText		; $4632
	ld a,$02		; $4635
	ld (de),a		; $4637
	ld a,$2d		; $4638
	ld (wActiveMusic),a		; $463a
	call playSound		; $463d
	ld a,($d00d)		; $4640
	sub $28			; $4643
	ld c,a			; $4645
	ld a,($d00b)		; $4646
	ld b,a			; $4649
	ld e,$8b		; $464a
	ld a,(de)		; $464c
	ldh (<hFF8F),a	; $464d
	ld e,$8d		; $464f
	ld a,(de)		; $4651
	ldh (<hFF8E),a	; $4652
	sub $18			; $4654
	cp $c0			; $4656
	jr nc,_label_0e_046	; $4658
	ldh a,(<hFF8F)	; $465a
	sub b			; $465c
	add $08			; $465d
	cp $11			; $465f
	jr nc,_label_0e_047	; $4661
	ldh a,(<hFF8E)	; $4663
	sub c			; $4665
	add $08			; $4666
	cp $11			; $4668
	jr nc,_label_0e_047	; $466a
_label_0e_046:
	call getRandomNumber_noPreserveVars		; $466c
	and $30			; $466f
	add $60			; $4671
	ld h,d			; $4673
	ld l,$84		; $4674
	inc (hl)		; $4676
	ld l,$b1		; $4677
	ld (hl),$08		; $4679
	ld l,$86		; $467b
	ld (hl),a		; $467d
	inc l			; $467e
	ld (hl),$3c		; $467f
	ret			; $4681
_label_0e_047:
	call _ecom_moveTowardPosition		; $4682
	call _ecom_updateAnimationFromAngle		; $4685
_label_0e_048:
	jp enemyAnimate		; $4688
	call $4809		; $468b
	jr z,_label_0e_048	; $468e
	ld e,$90		; $4690
	ld a,$23		; $4692
	ld (de),a		; $4694
	call $4797		; $4695
	jr c,_label_0e_050	; $4698
	call _ecom_decCounter2		; $469a
	jr nz,_label_0e_049	; $469d
	ld (hl),$3c		; $469f
	call $46a9		; $46a1
_label_0e_049:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $46a4
	jr nz,_label_0e_048	; $46a7
	call _ecom_setRandomCardinalAngle		; $46a9
	jp _ecom_updateAnimationFromAngle		; $46ac
_label_0e_050:
	ld a,$09		; $46af
	call objectGetRelatedObject1Var		; $46b1
	ld e,l			; $46b4
	ld a,(de)		; $46b5
	add $10			; $46b6
	and $1f			; $46b8
	sub (hl)		; $46ba
	and $1f			; $46bb
	ld c,$28		; $46bd
	jr z,_label_0e_051	; $46bf
	ld c,$32		; $46c1
	cp $10			; $46c3
	jr c,_label_0e_051	; $46c5
	ld c,$1e		; $46c7
_label_0e_051:
	ld e,$90		; $46c9
	ld a,c			; $46cb
	ld (de),a		; $46cc
	call $47c0		; $46cd
	call objectGetRelativeAngle		; $46d0
	ld b,a			; $46d3
	ld e,$b1		; $46d4
	ld a,(de)		; $46d6
	add b			; $46d7
	and $1f			; $46d8
	ld e,$89		; $46da
	ld (de),a		; $46dc
	call _ecom_updateAnimationFromAngle		; $46dd
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $46e0
	call $47d0		; $46e3
	jr _label_0e_053		; $46e6
	ld e,$b0		; $46e8
	ld a,(de)		; $46ea
	or a			; $46eb
	jr nz,_label_0e_052	; $46ec
	ld e,$84		; $46ee
	ld a,$09		; $46f0
	ld (de),a		; $46f2
	jr _label_0e_053		; $46f3
_label_0e_052:
	ld b,$38		; $46f5
	call _ecom_spawnProjectile		; $46f7
	jr nz,_label_0e_053	; $46fa
	ld l,$f0		; $46fc
	ldh a,(<hEnemyTargetY)	; $46fe
	ldi (hl),a		; $4700
	ldh a,(<hEnemyTargetX)	; $4701
	ld (hl),a		; $4703
	ld l,$d8		; $4704
	ld a,$80		; $4706
	ldi (hl),a		; $4708
	ld e,$97		; $4709
	ld a,(de)		; $470b
	ld (hl),a		; $470c
	ld h,a			; $470d
	ld l,$84		; $470e
	ld a,$0b		; $4710
	ld (hl),a		; $4712
	ld e,l			; $4713
	ld (de),a		; $4714
	ld e,$b0		; $4715
	xor a			; $4717
	ld (de),a		; $4718
	ld l,e			; $4719
	inc a			; $471a
	ld (hl),a		; $471b
	ld l,$99		; $471c
	ld (hl),$01		; $471e
_label_0e_053:
	jp enemyAnimate		; $4720
	ld e,$99		; $4723
	ld a,(de)		; $4725
	or a			; $4726
	jr z,_label_0e_054	; $4727
	dec a			; $4729
	call z,$47a5		; $472a
	jr _label_0e_053		; $472d
_label_0e_054:
	ld a,$19		; $472f
	call objectGetRelatedObject1Var		; $4731
	dec (hl)		; $4734
	ld l,$84		; $4735
	ld a,$09		; $4737
	ld (hl),a		; $4739
	ld e,l			; $473a
	ld (de),a		; $473b
	jr _label_0e_053		; $473c
	ld a,(de)		; $473e
	sub $08			; $473f
	rst_jumpTable			; $4741
	ld c,d			; $4742
	ld b,a			; $4743
	ld h,(hl)		; $4744
	ld b,a			; $4745
	add sp,$46		; $4746
	inc hl			; $4748
	ld b,a			; $4749
	inc e			; $474a
	ld a,(de)		; $474b
	or a			; $474c
	jr z,_label_0e_055	; $474d
	ld a,($d00d)		; $474f
	add $28			; $4752
	ld c,a			; $4754
	jp $4646		; $4755
_label_0e_055:
	ld a,($d00b)		; $4758
	cp $78			; $475b
	ret nc			; $475d
	ld h,d			; $475e
	ld l,e			; $475f
	inc (hl)		; $4760
	ld l,$a4		; $4761
	set 7,(hl)		; $4763
	ret			; $4765
	call $4809		; $4766
	jp z,enemyAnimate		; $4769
	ld e,$90		; $476c
	ld a,$28		; $476e
	ld (de),a		; $4770
	call $4797		; $4771
	jp c,$46af		; $4774
	jp $469a		; $4777
	ld e,$97		; $477a
	ld a,(de)		; $477c
	or a			; $477d
	jr z,_label_0e_056	; $477e
	call _ecom_killRelatedObj1		; $4780
	ld e,$97		; $4783
	xor a			; $4785
	ld (de),a		; $4786
_label_0e_056:
	ld e,$99		; $4787
	ld a,(de)		; $4789
	sub $02			; $478a
	jr c,_label_0e_057	; $478c
	ld h,a			; $478e
	ld l,$d7		; $478f
	xor a			; $4791
	ld (hl),a		; $4792
	ld (de),a		; $4793
_label_0e_057:
	jp _enemyBoss_dead		; $4794
	ldh a,(<hEnemyTargetY)	; $4797
	sub $40			; $4799
	cp $30			; $479b
	ret nc			; $479d
	ldh a,(<hEnemyTargetX)	; $479e
	sub $40			; $47a0
	cp $70			; $47a2
	ret			; $47a4
	ld a,(wFrameCounter)		; $47a5
	and $07			; $47a8
	ret nz			; $47aa
	ld a,$19		; $47ab
	call objectGetRelatedObject1Var		; $47ad
	ld h,(hl)		; $47b0
	ld l,$cb		; $47b1
	ld b,(hl)		; $47b3
	ld l,$cd		; $47b4
	ld c,(hl)		; $47b6
	call objectGetRelativeAngle		; $47b7
	ld e,$89		; $47ba
	ld (de),a		; $47bc
	jp _ecom_updateAnimationFromAngle		; $47bd
	ld b,$58		; $47c0
	ld c,b			; $47c2
	ldh a,(<hEnemyTargetX)	; $47c3
	cp $60			; $47c5
	ret c			; $47c7
	ld c,$78		; $47c8
	cp $90			; $47ca
	ret c			; $47cc
	ld c,$98		; $47cd
	ret			; $47cf
	call objectGetAngleTowardEnemyTarget		; $47d0
	ld c,a			; $47d3
	ld h,d			; $47d4
	ld l,$8b		; $47d5
	ldh a,(<hEnemyTargetY)	; $47d7
	sub (hl)		; $47d9
	jr nc,_label_0e_058	; $47da
	cpl			; $47dc
	inc a			; $47dd
_label_0e_058:
	ld b,a			; $47de
	ld l,$8d		; $47df
	ldh a,(<hEnemyTargetX)	; $47e1
	sub (hl)		; $47e3
	jr nc,_label_0e_059	; $47e4
	cpl			; $47e6
	inc a			; $47e7
_label_0e_059:
	add b			; $47e8
	cp $30			; $47e9
	jr c,_label_0e_060	; $47eb
	cp $60			; $47ed
	ret c			; $47ef
	ld l,$90		; $47f0
	ld (hl),$0a		; $47f2
	ld a,c			; $47f4
	ld e,$89		; $47f5
	ld (de),a		; $47f7
	jr _label_0e_061		; $47f8
_label_0e_060:
	ld l,$90		; $47fa
	ld (hl),$14		; $47fc
	ld a,c			; $47fe
	add $10			; $47ff
	and $1f			; $4801
	ld e,$89		; $4803
	ld (de),a		; $4805
_label_0e_061:
	jp _ecom_applyVelocityForSideviewEnemyNoHoles		; $4806
	ld e,$86		; $4809
	ld a,(de)		; $480b
	or a			; $480c
	jr z,_label_0e_062	; $480d
	dec a			; $480f
	ld (de),a		; $4810
	ret nz			; $4811
_label_0e_062:
	ld bc,$0130		; $4812
	call _ecom_randomBitwiseAndBCE		; $4815
	ld e,$86		; $4818
	ld a,$20		; $481a
	add c			; $481c
	ld (de),a		; $481d
	ld c,a			; $481e
	ld a,b			; $481f
	or a			; $4820
	ret nz			; $4821
	ld h,d			; $4822
	ld l,$84		; $4823
	inc (hl)		; $4825
	ld l,$97		; $4826
	ld h,(hl)		; $4828
	ld l,$86		; $4829
	ld (hl),c		; $482b
	call _ecom_updateAngleTowardTarget		; $482c
	call _ecom_updateAnimationFromAngle		; $482f
	xor a			; $4832
	ret			; $4833

; ==============================================================================
; ENEMYID_FACADE
; ==============================================================================
enemyCode71:
	jr z,_label_0e_063	; $4834
	sub $03			; $4836
	ret c			; $4838
	ret nz			; $4839
	ld e,$a4		; $483a
	ld a,(de)		; $483c
	or a			; $483d
	call nz,$49eb		; $483e
	ld e,$82		; $4841
	ld a,(de)		; $4843
	or a			; $4844
	jp nz,enemyDie		; $4845
	jp _enemyBoss_dead		; $4848
_label_0e_063:
	ld e,$84		; $484b
	ld a,(de)		; $484d
	rst_jumpTable			; $484e
	ld l,c			; $484f
	ld c,b			; $4850
	add a			; $4851
	ld c,b			; $4852
	add a			; $4853
	ld c,b			; $4854
	add a			; $4855
	ld c,b			; $4856
	add a			; $4857
	ld c,b			; $4858
	add a			; $4859
	ld c,b			; $485a
	add a			; $485b
	ld c,b			; $485c
	add a			; $485d
	ld c,b			; $485e
	adc b			; $485f
	ld c,b			; $4860
	sbc e			; $4861
	ld c,b			; $4862
	ret z			; $4863
	ld c,b			; $4864
	rst_addDoubleIndex			; $4865
	ld c,b			; $4866
	halt			; $4867
	ld c,c			; $4868
	call _ecom_setSpeedAndState8		; $4869
	ld l,$8b		; $486c
	ld (hl),$58		; $486e
	ld l,$8d		; $4870
	ld (hl),$78		; $4872
	ld e,$82		; $4874
	ld a,(de)		; $4876
	or a			; $4877
	ld a,$ff		; $4878
	ld b,$00		; $487a
	jp z,_enemyBoss_initializeRoom		; $487c
	ld l,$86		; $487f
	ld (hl),$3c		; $4881
	ld l,$84		; $4883
	inc (hl)		; $4885
	ret			; $4886
	ret			; $4887
	ldh a,(<hEnemyTargetY)	; $4888
	cp $58			; $488a
	ret c			; $488c
	ld h,d			; $488d
	ld l,e			; $488e
	inc (hl)		; $488f
	ld l,$86		; $4890
	inc (hl)		; $4892
	ld a,$2d		; $4893
	ld (wActiveMusic),a		; $4895
	jp playSound		; $4898
	call _ecom_decCounter1		; $489b
	ret nz			; $489e
	ld a,$78		; $489f
	ld (hl),a		; $48a1
	ld l,e			; $48a2
	inc (hl)		; $48a3
	ld l,$a4		; $48a4
	set 7,(hl)		; $48a6
	call setScreenShakeCounter		; $48a8
	call getRandomNumber_noPreserveVars		; $48ab
	and $03			; $48ae
	ld hl,$48c4		; $48b0
	rst_addAToHl			; $48b3
	ld e,$83		; $48b4
	ld a,(hl)		; $48b6
	ld (de),a		; $48b7
	ld a,$b8		; $48b8
	call playSound		; $48ba
	xor a			; $48bd
	call enemySetAnimation		; $48be
	jp objectSetVisible83		; $48c1
	nop			; $48c4
	ld bc,$0202		; $48c5
	call _ecom_decCounter1		; $48c8
	jr z,_label_0e_064	; $48cb
	ld a,(hl)		; $48cd
	and $1f			; $48ce
	ld a,$b8		; $48d0
	call z,playSound		; $48d2
	jr _label_0e_065		; $48d5
_label_0e_064:
	ld l,e			; $48d7
	inc (hl)		; $48d8
	inc l			; $48d9
	ld (hl),$00		; $48da
_label_0e_065:
	jp enemyAnimate		; $48dc
	call enemyAnimate		; $48df
	ld e,$83		; $48e2
	ld a,(de)		; $48e4
	rst_jumpTable			; $48e5
.DB $ec				; $48e6
	ld c,b			; $48e7
	add hl,de		; $48e8
	ld c,c			; $48e9
	ld c,h			; $48ea
	ld c,c			; $48eb
	ld e,$85		; $48ec
	ld a,(de)		; $48ee
	rst_jumpTable			; $48ef
	or $48			; $48f0
.DB $fd				; $48f2
	ld c,b			; $48f3
	ld b,$49		; $48f4
	ld h,d			; $48f6
	ld l,e			; $48f7
	inc (hl)		; $48f8
	inc l			; $48f9
	ld (hl),$14		; $48fa
	ret			; $48fc
	call _ecom_decCounter1		; $48fd
	ret nz			; $4900
	ld (hl),$46		; $4901
	ld l,e			; $4903
	inc (hl)		; $4904
	ret			; $4905
	call _ecom_decCounter1		; $4906
	jp z,$49e3		; $4909
	ld a,(hl)		; $490c
	and $0f			; $490d
	ret nz			; $490f
	ld l,$b0		; $4910
	ld a,(hl)		; $4912
	cp $05			; $4913
	ret nc			; $4915
	jp $498c		; $4916
	ld e,$85		; $4919
	ld a,(de)		; $491b
	rst_jumpTable			; $491c
	inc hl			; $491d
	ld c,c			; $491e
	ldi a,(hl)		; $491f
	ld c,c			; $4920
	ccf			; $4921
	ld c,c			; $4922
	ld a,$01		; $4923
	ld (de),a		; $4925
	inc a			; $4926
	jp enemySetAnimation		; $4927
	ld h,d			; $492a
	ld l,$a1		; $492b
	bit 7,(hl)		; $492d
	jp z,enemyAnimate		; $492f
	ld l,e			; $4932
	inc (hl)		; $4933
	ld l,$86		; $4934
	ld (hl),$b4		; $4936
	ld l,$a4		; $4938
	res 7,(hl)		; $493a
	jp objectSetInvisible		; $493c
	call _ecom_decCounter1		; $493f
	jp z,$49e3		; $4942
	ld a,(hl)		; $4945
	and $1f			; $4946
	ret nz			; $4948
	jp $49b2		; $4949
	ld e,$85		; $494c
	ld a,(de)		; $494e
	rst_jumpTable			; $494f
	ld d,h			; $4950
	ld c,c			; $4951
	ld e,a			; $4952
	ld c,c			; $4953
	ld h,d			; $4954
	ld l,e			; $4955
	inc (hl)		; $4956
	inc l			; $4957
	ld (hl),$f0		; $4958
	ld a,$01		; $495a
	jp enemySetAnimation		; $495c
	call _ecom_decCounter1		; $495f
	jp z,$49e3		; $4962
	ld a,(hl)		; $4965
	and $0f			; $4966
	ret nz			; $4968
	ld e,$a1		; $4969
	ld a,(de)		; $496b
	dec a			; $496c
	ret nz			; $496d
	ld a,$51		; $496e
	call playSound		; $4970
	jp $49d9		; $4973
	ld h,d			; $4976
	ld l,$a1		; $4977
	bit 7,(hl)		; $4979
	jp z,enemyAnimate		; $497b
	ld l,e			; $497e
	ld (hl),$09		; $497f
	ld l,$86		; $4981
	ld (hl),$78		; $4983
	ld l,$a4		; $4985
	res 7,(hl)		; $4987
	jp objectSetInvisible		; $4989
	ld b,$51		; $498c
	call _ecom_spawnEnemyWithSubid01		; $498e
	ret nz			; $4991
	ld l,$96		; $4992
	ld a,$80		; $4994
	ldi (hl),a		; $4996
	ld (hl),d		; $4997
	ld e,$b0		; $4998
	ld a,(de)		; $499a
	inc a			; $499b
	ld (de),a		; $499c
	call getRandomNumber		; $499d
	ld c,a			; $49a0
	and $70			; $49a1
	add $20			; $49a3
	ld l,$8b		; $49a5
	ldi (hl),a		; $49a7
	inc l			; $49a8
	ld a,c			; $49a9
	and $07			; $49aa
	swap a			; $49ac
	add $40			; $49ae
	ld (hl),a		; $49b0
	ret			; $49b1
	ld b,$2e		; $49b2
	call _ecom_spawnProjectile		; $49b4
	ret nz			; $49b7
	push hl			; $49b8
	ld bc,$1f1f		; $49b9
	call _ecom_randomBitwiseAndBCE		; $49bc
	pop hl			; $49bf
	ldh a,(<hEnemyTargetY)	; $49c0
	add b			; $49c2
	sub $10			; $49c3
	and $f0			; $49c5
	add $08			; $49c7
	ld l,$cb		; $49c9
	ld (hl),a		; $49cb
	ldh a,(<hEnemyTargetX)	; $49cc
	add c			; $49ce
	sub $10			; $49cf
	and $f0			; $49d1
	add $08			; $49d3
	ld l,$cd		; $49d5
	ld (hl),a		; $49d7
	ret			; $49d8
	ld b,$11		; $49d9
	call _ecom_spawnProjectile		; $49db
	ret nz			; $49de
	ld l,$c2		; $49df
	inc (hl)		; $49e1
	ret			; $49e2
	ld l,$84		; $49e3
	inc (hl)		; $49e5
	ld a,$02		; $49e6
	jp enemySetAnimation		; $49e8
	ld hl,$d080		; $49eb
_label_0e_066:
	ld l,$81		; $49ee
	ld a,(hl)		; $49f0
	cp $51			; $49f1
	call z,_ecom_killObjectH		; $49f3
	inc h			; $49f6
	ld a,h			; $49f7
	cp $e0			; $49f8
	jr c,_label_0e_066	; $49fa
	ret			; $49fc

; ==============================================================================
; ENEMYID_OMUAI
; ==============================================================================
enemyCode72:
	jr z,_label_0e_071	; $49fd
	sub $03			; $49ff
	ret c			; $4a01
	jr nz,_label_0e_070	; $4a02
	ld e,$a4		; $4a04
	ld a,(de)		; $4a06
	or a			; $4a07
	jr z,_label_0e_069	; $4a08
	ld hl,$d081		; $4a0a
_label_0e_067:
	ld a,(hl)		; $4a0d
	cp $72			; $4a0e
	jr nz,_label_0e_068	; $4a10
	ld a,h			; $4a12
	cp d			; $4a13
	jp nz,enemyDie_withoutItemDrop		; $4a14
_label_0e_068:
	inc h			; $4a17
	ld a,h			; $4a18
	cp $e0			; $4a19
	jr c,_label_0e_067	; $4a1b
_label_0e_069:
	jp _enemyBoss_dead		; $4a1d
_label_0e_070:
	ld e,$aa		; $4a20
	ld a,(de)		; $4a22
	res 7,a			; $4a23
	cp $04			; $4a25
	jr c,_label_0e_071	; $4a27
	ld e,$b5		; $4a29
	ld a,$01		; $4a2b
	ld (de),a		; $4a2d
_label_0e_071:
	ld e,$84		; $4a2e
	ld a,(de)		; $4a30
	rst_jumpTable			; $4a31
	ld d,(hl)		; $4a32
	ld c,d			; $4a33
	sbc $4a			; $4a34
	ld h,b			; $4a36
	ld c,d			; $4a37
	sbc $4a			; $4a38
	call nz,$de4a		; $4a3a
	ld c,d			; $4a3d
	sbc $4a			; $4a3e
	sbc $4a			; $4a40
	rst_addDoubleIndex			; $4a42
	ld c,d			; $4a43
	di			; $4a44
	ld c,d			; $4a45
	dec e			; $4a46
	ld c,e			; $4a47
	scf			; $4a48
	ld c,e			; $4a49
	ld e,(hl)		; $4a4a
	ld c,e			; $4a4b
	ld a,d			; $4a4c
	ld c,e			; $4a4d
	sbc e			; $4a4e
	ld c,e			; $4a4f
	adc $4b			; $4a50
	ld de,$2b4c		; $4a52
	ld c,h			; $4a55
	ld b,$00		; $4a56
	ld a,$72		; $4a58
	call _enemyBoss_initializeRoom		; $4a5a
	jp _ecom_setSpeedAndState8		; $4a5d
	inc e			; $4a60
	ld a,(de)		; $4a61
	rst_jumpTable			; $4a62
	ld l,e			; $4a63
	ld c,d			; $4a64
	add l			; $4a65
	ld c,d			; $4a66
	sbc c			; $4a67
	ld c,d			; $4a68
	sbc a			; $4a69
	ld c,d			; $4a6a
	ld a,$30		; $4a6b
	ld (wLinkGrabState2),a		; $4a6d
	ld h,d			; $4a70
	ld l,e			; $4a71
	inc (hl)		; $4a72
	inc l			; $4a73
	ld (hl),$78		; $4a74
	ld l,$a4		; $4a76
	res 7,(hl)		; $4a78
	call $4c7f		; $4a7a
	ld a,$03		; $4a7d
	call enemySetAnimation		; $4a7f
	jp objectSetVisiblec1		; $4a82
	call _ecom_decCounter1		; $4a85
	jr z,_label_0e_072	; $4a88
	ld a,(hl)		; $4a8a
	cp $2d			; $4a8b
	call c,enemyAnimate		; $4a8d
	jp enemyAnimate		; $4a90
_label_0e_072:
	ld l,e			; $4a93
	ld (hl),$03		; $4a94
	jp dropLinkHeldItem		; $4a96
	call $4c3c		; $4a99
	jp enemyAnimate		; $4a9c
	ld h,d			; $4a9f
	ld l,$84		; $4aa0
	ld (hl),$0c		; $4aa2
	ld l,$86		; $4aa4
	ld (hl),$8c		; $4aa6
	ld l,$a4		; $4aa8
	set 7,(hl)		; $4aaa
	inc l			; $4aac
	ld (hl),$42		; $4aad
	call getRandomNumber_noPreserveVars		; $4aaf
	and $1f			; $4ab2
	ld e,$89		; $4ab4
	ld (de),a		; $4ab6
	ld h,d			; $4ab7
	ld l,$90		; $4ab8
	ld (hl),$1e		; $4aba
	ld l,$94		; $4abc
	ld a,$00		; $4abe
	ldi (hl),a		; $4ac0
	ld (hl),$fe		; $4ac1
	ret			; $4ac3
	ld a,($ccf0)		; $4ac4
	or a			; $4ac7
	jp z,$4c65		; $4ac8
	ld e,$a1		; $4acb
	ld a,(de)		; $4acd
	or a			; $4ace
	call nz,$4d54		; $4acf
	ld hl,$d000		; $4ad2
	call preventObjectHFromPassingObjectD		; $4ad5
	call objectAddToGrabbableObjectBuffer		; $4ad8
	jp enemyAnimate		; $4adb
	ret			; $4ade
	ld a,(wcc93)		; $4adf
	or a			; $4ae2
	ret nz			; $4ae3
	ld h,d			; $4ae4
	ld l,e			; $4ae5
	inc (hl)		; $4ae6
	ld l,$86		; $4ae7
	ld (hl),$5a		; $4ae9
	ld a,$2d		; $4aeb
	ld (wActiveMusic),a		; $4aed
	jp playSound		; $4af0
	call _ecom_decCounter1		; $4af3
	ret nz			; $4af6
	inc (hl)		; $4af7
	call getRandomNumber_noPreserveVars		; $4af8
	and $7f			; $4afb
	add $10			; $4afd
	ld c,a			; $4aff
	ld b,$cf		; $4b00
	ld a,(bc)		; $4b02
	cp $fa			; $4b03
	ret nz			; $4b05
	call objectSetShortPosition		; $4b06
	ld a,$fe		; $4b09
	ld (bc),a		; $4b0b
	ld l,$b0		; $4b0c
	ld (hl),c		; $4b0e
	ld l,$84		; $4b0f
	inc (hl)		; $4b11
	ld l,$86		; $4b12
	ld (hl),$5a		; $4b14
	xor a			; $4b16
	call enemySetAnimation		; $4b17
	jp objectSetVisible82		; $4b1a
	ld hl,$d000		; $4b1d
	call preventObjectHFromPassingObjectD		; $4b20
	call _ecom_decCounter1		; $4b23
	jr nz,_label_0e_074	; $4b26
	ld l,$84		; $4b28
	inc (hl)		; $4b2a
	ld l,$a4		; $4b2b
	set 7,(hl)		; $4b2d
	inc l			; $4b2f
	ld (hl),$59		; $4b30
	ld a,$01		; $4b32
	jp enemySetAnimation		; $4b34
	ld a,($ccf0)		; $4b37
	or a			; $4b3a
	jr z,_label_0e_073	; $4b3b
	ld e,$84		; $4b3d
	ld a,$04		; $4b3f
	ld (de),a		; $4b41
	ld a,$06		; $4b42
	jp enemySetAnimation		; $4b44
_label_0e_073:
	ld hl,$d000		; $4b47
	call preventObjectHFromPassingObjectD		; $4b4a
	call objectAddToGrabbableObjectBuffer		; $4b4d
	ld e,$a1		; $4b50
	ld a,(de)		; $4b52
	inc a			; $4b53
	jp z,$4c65		; $4b54
	dec a			; $4b57
	call nz,$4d54		; $4b58
_label_0e_074:
	jp enemyAnimate		; $4b5b
	call _ecom_decCounter1		; $4b5e
	jr z,_label_0e_075	; $4b61
	ld c,$12		; $4b63
	call objectUpdateSpeedZ_paramC		; $4b65
	call z,$4aaf		; $4b68
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $4b6b
	jr _label_0e_074		; $4b6e
_label_0e_075:
	ld l,e			; $4b70
	inc (hl)		; $4b71
	ld l,$94		; $4b72
	ld a,$80		; $4b74
	ldi (hl),a		; $4b76
	ld (hl),$fe		; $4b77
	ret			; $4b79
	ld c,$10		; $4b7a
	call objectUpdateSpeedZ_paramC		; $4b7c
	jr z,_label_0e_076	; $4b7f
	ldd a,(hl)		; $4b81
	or a			; $4b82
	ret nz			; $4b83
	ld a,(hl)		; $4b84
	or a			; $4b85
	ret nz			; $4b86
	ld a,$04		; $4b87
	jp enemySetAnimation		; $4b89
_label_0e_076:
	call $4cb6		; $4b8c
	ld l,$84		; $4b8f
	inc (hl)		; $4b91
	ld l,$90		; $4b92
	ld (hl),$28		; $4b94
	call objectSetVisible82		; $4b96
	jr _label_0e_074		; $4b99
	call enemyAnimate		; $4b9b
	ld h,d			; $4b9e
	ld l,$b2		; $4b9f
	call _ecom_readPositionVars		; $4ba1
	cp c			; $4ba4
	jr nz,_label_0e_078	; $4ba5
	ldh a,(<hFF8F)	; $4ba7
	cp b			; $4ba9
	jr nz,_label_0e_078	; $4baa
	ld l,$84		; $4bac
	inc (hl)		; $4bae
	ld e,$b5		; $4baf
	ld a,(de)		; $4bb1
	or a			; $4bb2
	jr z,_label_0e_077	; $4bb3
	inc (hl)		; $4bb5
_label_0e_077:
	ld l,$94		; $4bb6
	ld a,$60		; $4bb8
	ldi (hl),a		; $4bba
	ld (hl),$fe		; $4bbb
	ld l,$90		; $4bbd
	ld (hl),$19		; $4bbf
	call objectSetVisiblec1		; $4bc1
	ld a,$05		; $4bc4
	call enemySetAnimation		; $4bc6
	jr _label_0e_082		; $4bc9
_label_0e_078:
	jp _ecom_moveTowardPosition		; $4bcb
	ld e,$a1		; $4bce
	ld a,(de)		; $4bd0
	inc a			; $4bd1
	jr nz,_label_0e_083	; $4bd2
	ld c,$10		; $4bd4
	call objectUpdateSpeedZ_paramC		; $4bd6
	jr z,_label_0e_079	; $4bd9
	call $4d36		; $4bdb
	jr nc,_label_0e_078	; $4bde
	ret			; $4be0
_label_0e_079:
	call $4b72		; $4be1
	ld l,$b5		; $4be4
	bit 0,(hl)		; $4be6
	jr nz,_label_0e_080	; $4be8
	ld l,$86		; $4bea
	ld a,(hl)		; $4bec
	cp $03			; $4bed
	jr c,_label_0e_081	; $4bef
_label_0e_080:
	ld l,$84		; $4bf1
_label_0e_081:
	inc (hl)		; $4bf3
	ld a,$05		; $4bf4
	call enemySetAnimation		; $4bf6
_label_0e_082:
	ld e,$b4		; $4bf9
	ld a,(de)		; $4bfb
	inc a			; $4bfc
	and $03			; $4bfd
	ld (de),a		; $4bff
	ld hl,$4c09		; $4c00
	rst_addDoubleIndex			; $4c03
	ld e,$b2		; $4c04
	jp add16BitRefs		; $4c06
	ld a,($ff00+$10)	; $4c09
	stop			; $4c0b
	stop			; $4c0c
	stop			; $4c0d
	ld a,($ff00+$f0)	; $4c0e
	ld a,($ff00+$62)	; $4c10
	ld l,e			; $4c12
	inc (hl)		; $4c13
	ld l,$a4		; $4c14
	res 7,(hl)		; $4c16
	ld l,$90		; $4c18
	ld (hl),$14		; $4c1a
	ld l,$b4		; $4c1c
	ld a,(hl)		; $4c1e
	inc a			; $4c1f
	and $03			; $4c20
	swap a			; $4c22
	rrca			; $4c24
	ld l,$89		; $4c25
	ld (hl),a		; $4c27
_label_0e_083:
	jp enemyAnimate		; $4c28
	ld e,$a1		; $4c2b
	ld a,(de)		; $4c2d
	inc a			; $4c2e
	jr nz,_label_0e_083	; $4c2f
	ld c,$18		; $4c31
	call objectUpdateSpeedZ_paramC		; $4c33
	jp nz,objectApplySpeed		; $4c36
	jp $4c65		; $4c39
	ld e,$8f		; $4c3c
	ld a,(de)		; $4c3e
	or a			; $4c3f
	ret nz			; $4c40
	ld hl,$d081		; $4c41
_label_0e_084:
	ld a,(hl)		; $4c44
	cp $72			; $4c45
	jr nz,_label_0e_085	; $4c47
	ld a,h			; $4c49
	cp d			; $4c4a
	jr z,_label_0e_085	; $4c4b
	push hl			; $4c4d
	call $4c88		; $4c4e
	pop hl			; $4c51
	jr z,_label_0e_086	; $4c52
_label_0e_085:
	inc h			; $4c54
	ld a,h			; $4c55
	cp $e0			; $4c56
	jr c,_label_0e_084	; $4c58
	call objectGetTileAtPosition		; $4c5a
	cp $fb			; $4c5d
	jr z,_label_0e_086	; $4c5f
	cp $fa			; $4c61
	ret nz			; $4c63
_label_0e_086:
	pop hl			; $4c64
	ld b,$03		; $4c65
	call objectCreateInteractionWithSubid00		; $4c67
	ld h,d			; $4c6a
	ld l,$84		; $4c6b
	ld (hl),$09		; $4c6d
	ld l,$a4		; $4c6f
	res 7,(hl)		; $4c71
	ld l,$b5		; $4c73
	ld (hl),$00		; $4c75
	ld l,$86		; $4c77
	ld (hl),$78		; $4c79
	ld l,$9a		; $4c7b
	res 7,(hl)		; $4c7d
	ld l,$b0		; $4c7f
	ld c,(hl)		; $4c81
	ld b,$cf		; $4c82
	ld a,$fa		; $4c84
	ld (bc),a		; $4c86
	ret			; $4c87
	push de			; $4c88
	ld d,h			; $4c89
	ld e,$8b		; $4c8a
	call getShortPositionFromDE		; $4c8c
	ld c,a			; $4c8f
	pop de			; $4c90
	call objectGetShortPosition		; $4c91
	cp c			; $4c94
	ret nz			; $4c95
	push hl			; $4c96
	call objectGetTileAtPosition		; $4c97
	pop hl			; $4c9a
	cp $fe			; $4c9b
	ret nz			; $4c9d
	call $4c6b		; $4c9e
	ld l,$8b		; $4ca1
	ld b,(hl)		; $4ca3
	ld l,$8d		; $4ca4
	ld c,(hl)		; $4ca6
	call getFreeInteractionSlot		; $4ca7
	jr nz,_label_0e_087	; $4caa
	ld (hl),$03		; $4cac
	ld l,$4b		; $4cae
	ld (hl),b		; $4cb0
	ld l,$4d		; $4cb1
	ld (hl),c		; $4cb3
_label_0e_087:
	xor a			; $4cb4
	ret			; $4cb5
	call objectGetTileAtPosition		; $4cb6
	ld c,l			; $4cb9
	ld hl,$cf00		; $4cba
	ld e,$b1		; $4cbd
	ld b,$ff		; $4cbf
_label_0e_088:
	ld a,(hl)		; $4cc1
	cp $fa			; $4cc2
	call z,$4d10		; $4cc4
	inc l			; $4cc7
	ld a,l			; $4cc8
	cp $b0			; $4cc9
	jr c,_label_0e_088	; $4ccb
	ld a,(de)		; $4ccd
	ld l,a			; $4cce
	ld (hl),$fb		; $4ccf
	ld e,$b0		; $4cd1
	ld (de),a		; $4cd3
	call $4cf8		; $4cd4
	ldh (<hFF8E),a	; $4cd7
	ld a,(hl)		; $4cd9
	ldh (<hFF8F),a	; $4cda
	ld l,$8b		; $4cdc
	ld b,(hl)		; $4cde
	ld l,$8d		; $4cdf
	ld c,(hl)		; $4ce1
	call objectGetRelativeAngleWithTempVars		; $4ce2
	add $04			; $4ce5
	and $18			; $4ce7
	swap a			; $4ce9
	rlca			; $4ceb
	ld e,$b4		; $4cec
	ld (de),a		; $4cee
	ld hl,$4d0c		; $4cef
	rst_addAToHl			; $4cf2
	ld e,$b1		; $4cf3
	ld a,(de)		; $4cf5
	add (hl)		; $4cf6
	ld (de),a		; $4cf7
	ld h,d			; $4cf8
	ld l,$b2		; $4cf9
	ld e,$b1		; $4cfb
	ld a,(de)		; $4cfd
	and $f0			; $4cfe
	add $08			; $4d00
	ldi (hl),a		; $4d02
	ld a,(de)		; $4d03
	and $0f			; $4d04
	swap a			; $4d06
	add $08			; $4d08
	ldd (hl),a		; $4d0a
	ret			; $4d0b
	ld a,($ff00+$01)	; $4d0c
	stop			; $4d0e
	rst $38			; $4d0f
	push de			; $4d10
	ld a,c			; $4d11
	and $f0			; $4d12
	swap a			; $4d14
	ld d,a			; $4d16
	ld a,l			; $4d17
	and $f0			; $4d18
	swap a			; $4d1a
	sub d			; $4d1c
	jr nc,_label_0e_089	; $4d1d
	cpl			; $4d1f
	inc a			; $4d20
_label_0e_089:
	ld d,a			; $4d21
	ld a,c			; $4d22
	and $0f			; $4d23
	ld e,a			; $4d25
	ld a,l			; $4d26
	and $0f			; $4d27
	sub e			; $4d29
	jr nc,_label_0e_090	; $4d2a
	cpl			; $4d2c
	inc a			; $4d2d
_label_0e_090:
	add d			; $4d2e
	pop de			; $4d2f
	cp b			; $4d30
	ret nc			; $4d31
	ld b,a			; $4d32
	ld a,l			; $4d33
	ld (de),a		; $4d34
	ret			; $4d35
	ld h,d			; $4d36
	ld e,$8b		; $4d37
	ld a,(de)		; $4d39
	ldh (<hFF8F),a	; $4d3a
	ld l,$b2		; $4d3c
	ldi a,(hl)		; $4d3e
	sub $02			; $4d3f
	ld b,a			; $4d41
	ld e,$8d		; $4d42
	ld a,(de)		; $4d44
	ldh (<hFF8E),a	; $4d45
	ld c,(hl)		; $4d47
	sub c			; $4d48
	inc a			; $4d49
	cp $02			; $4d4a
	ret nc			; $4d4c
	ldh a,(<hFF8F)	; $4d4d
	sub b			; $4d4f
	inc a			; $4d50
	cp $02			; $4d51
	ret			; $4d53
	xor a			; $4d54
	ld (de),a		; $4d55
	ld b,$31		; $4d56
	call _ecom_spawnProjectile		; $4d58
	ret nz			; $4d5b
	ld l,$c2		; $4d5c
	inc (hl)		; $4d5e
	ld l,$cb		; $4d5f
	ld a,(hl)		; $4d61
	sub $04			; $4d62
	ld (hl),a		; $4d64
	ret			; $4d65

; ==============================================================================
; ENEMYID_AGUNIMA
; ==============================================================================
enemyCode73:
	jr z,_label_0e_095	; $4d66
	sub $04			; $4d68
	jr z,_label_0e_092	; $4d6a
	inc a			; $4d6c
	ret nz			; $4d6d
	ld e,$b0		; $4d6e
	ld a,(de)		; $4d70
	bit 7,a			; $4d71
	jp z,enemyDelete		; $4d73
	ld a,(wFrameCounter)		; $4d76
	and $0f			; $4d79
	jr nz,_label_0e_091	; $4d7b
	ld e,$b3		; $4d7d
	ld a,(de)		; $4d7f
	sub $04			; $4d80
	and $0c			; $4d82
	ld (de),a		; $4d84
	call enemySetAnimation		; $4d85
_label_0e_091:
	jp _enemyBoss_dead		; $4d88
_label_0e_092:
	ld e,$a5		; $4d8b
	ld a,(de)		; $4d8d
	cp $5a			; $4d8e
	jr z,_label_0e_095	; $4d90
	ld a,$29		; $4d92
	call objectGetRelatedObject1Var		; $4d94
	ld e,l			; $4d97
	ld a,(de)		; $4d98
	cp (hl)			; $4d99
	jr z,_label_0e_095	; $4d9a
	ld e,$b0		; $4d9c
	ld a,(de)		; $4d9e
	bit 7,a			; $4d9f
	jr z,_label_0e_095	; $4da1
	ld l,$b1		; $4da3
	ld e,$a9		; $4da5
	ld a,(de)		; $4da7
	ld c,a			; $4da8
_label_0e_093:
	push hl			; $4da9
	ld h,(hl)		; $4daa
	ld l,$a9		; $4dab
	ld (hl),c		; $4dad
	ld l,$84		; $4dae
	ld (hl),$0e		; $4db0
	ld l,$a4		; $4db2
	res 7,(hl)		; $4db4
	ld l,$86		; $4db6
	ld (hl),$01		; $4db8
	pop hl			; $4dba
	inc l			; $4dbb
	ld a,$b4		; $4dbc
	cp l			; $4dbe
	jr nz,_label_0e_093	; $4dbf
	ld l,$a9		; $4dc1
	ld (hl),c		; $4dc3
	ld e,$99		; $4dc4
	ld a,(de)		; $4dc6
	or a			; $4dc7
	jr z,_label_0e_094	; $4dc8
	ld h,a			; $4dca
	ld l,$d7		; $4dcb
	ld (hl),$ff		; $4dcd
_label_0e_094:
	ld a,c			; $4dcf
	or a			; $4dd0
	ld h,d			; $4dd1
	ret z			; $4dd2
	ld l,$ab		; $4dd3
	ld a,$4b		; $4dd5
	ldi (hl),a		; $4dd7
	inc l			; $4dd8
	ld (hl),a		; $4dd9
	ret			; $4dda
_label_0e_095:
	call _ecom_getSubidAndCpStateTo08		; $4ddb
	jr c,_label_0e_096	; $4dde
	dec b			; $4de0
	jp z,$4e29		; $4de1
	jp $4eeb		; $4de4
_label_0e_096:
	rst_jumpTable			; $4de7
	ld hl,sp+$4d		; $4de8
	inc b			; $4dea
	ld c,(hl)		; $4deb
	jr z,_label_0e_098	; $4dec
	jr z,_label_0e_099	; $4dee
	jr z,_label_0e_100	; $4df0
	jr z,_label_0e_101	; $4df2
	jr z,$4e		; $4df4
	jr z,_label_0e_102	; $4df6
	ld a,b			; $4df8
	or a			; $4df9
	jp nz,_ecom_setSpeedAndState8		; $4dfa
	inc a			; $4dfd
	ld (de),a		; $4dfe
	ld a,$73		; $4dff
	jp _enemyBoss_initializeRoom		; $4e01
	ld b,$04		; $4e04
	call checkBEnemySlotsAvailable		; $4e06
	ret nz			; $4e09
	ld b,$73		; $4e0a
	call _ecom_spawnUncountedEnemyWithSubid01		; $4e0c
	ld l,$b1		; $4e0f
	ld c,h			; $4e11
	ld e,$03		; $4e12
_label_0e_097:
	push hl			; $4e14
	call _ecom_spawnUncountedEnemyWithSubid01		; $4e15
	inc (hl)		; $4e18
	ld l,$96		; $4e19
	ld a,$80		; $4e1b
	ldi (hl),a		; $4e1d
	ld (hl),c		; $4e1e
	ld a,h			; $4e1f
	pop hl			; $4e20
	ldi (hl),a		; $4e21
	dec e			; $4e22
	jr nz,_label_0e_097	; $4e23
	jp enemyDelete		; $4e25
	ret			; $4e28
	ld a,(de)		; $4e29
	sub $08			; $4e2a
	rst_jumpTable			; $4e2c
	inc sp			; $4e2d
	ld c,(hl)		; $4e2e
	jp z,$e24e		; $4e2f
	ld c,(hl)		; $4e32
	inc e			; $4e33
	ld a,(de)		; $4e34
	rst_jumpTable			; $4e35
	ld b,d			; $4e36
	ld c,(hl)		; $4e37
	ld d,(hl)		; $4e38
	ld c,(hl)		; $4e39
	ld l,d			; $4e3a
	ld c,(hl)		; $4e3b
_label_0e_098:
	ld a,c			; $4e3c
	ld c,(hl)		; $4e3d
_label_0e_099:
	and h			; $4e3e
	ld c,(hl)		; $4e3f
_label_0e_100:
	or h			; $4e40
	ld c,(hl)		; $4e41
_label_0e_101:
	ld a,(wcc93)		; $4e42
	or a			; $4e45
_label_0e_102:
	ret nz			; $4e46
	ld bc,$010c		; $4e47
	call _enemyBoss_spawnShadow		; $4e4a
	ret nz			; $4e4d
	inc a			; $4e4e
	ld (de),a		; $4e4f
	ld bc,$2f02		; $4e50
	jp showText		; $4e53
	ld a,$2d		; $4e56
	ld (wActiveMusic),a		; $4e58
	call playSound		; $4e5b
	ld h,d			; $4e5e
	ld l,$86		; $4e5f
	ld (hl),$3c		; $4e61
	ld a,$b1		; $4e63
	ld bc,loadTilesetGraphics		; $4e65
	jr _label_0e_103		; $4e68
	call _ecom_decCounter1		; $4e6a
	ret nz			; $4e6d
	ld l,$b0		; $4e6e
	ld (hl),$00		; $4e70
	ld a,$b2		; $4e72
	ld bc,$7437		; $4e74
	jr _label_0e_103		; $4e77
	ld h,d			; $4e79
	ld l,$b0		; $4e7a
	bit 0,(hl)		; $4e7c
	ret z			; $4e7e
	ld (hl),$00		; $4e7f
	ld a,$b3		; $4e81
	ld bc,$7a74		; $4e83
_label_0e_103:
	ld l,e			; $4e86
	inc (hl)		; $4e87
	ld l,a			; $4e88
	ld h,(hl)		; $4e89
	ld l,$b0		; $4e8a
	ld (hl),$01		; $4e8c
	ld l,$8b		; $4e8e
	call setShortPosition_paramC		; $4e90
	ld l,$b1		; $4e93
	ld a,b			; $4e95
	and $f0			; $4e96
	add $08			; $4e98
	ldi (hl),a		; $4e9a
	ld a,b			; $4e9b
	and $0f			; $4e9c
	swap a			; $4e9e
	add $08			; $4ea0
	ld (hl),a		; $4ea2
	ret			; $4ea3
	ld h,d			; $4ea4
	ld l,$b0		; $4ea5
	bit 0,(hl)		; $4ea7
	ret z			; $4ea9
	ld (hl),$00		; $4eaa
	ld l,e			; $4eac
	inc (hl)		; $4ead
	inc l			; $4eae
	ld (hl),$3c		; $4eaf
	jp $502a		; $4eb1
	call _ecom_decCounter1		; $4eb4
	ret nz			; $4eb7
	ld l,$84		; $4eb8
	inc (hl)		; $4eba
	ld e,$b1		; $4ebb
	ld l,$b0		; $4ebd
	ld b,$03		; $4ebf
_label_0e_104:
	ld a,(de)		; $4ec1
	ld h,a			; $4ec2
	set 0,(hl)		; $4ec3
	inc e			; $4ec5
	dec b			; $4ec6
	jr nz,_label_0e_104	; $4ec7
	ret			; $4ec9
	ld e,$b1		; $4eca
	ld l,$b0		; $4ecc
	ld b,$03		; $4ece
_label_0e_105:
	ld a,(de)		; $4ed0
	ld h,a			; $4ed1
	ld a,(hl)		; $4ed2
	or a			; $4ed3
	ret nz			; $4ed4
	inc e			; $4ed5
	dec b			; $4ed6
	jr nz,_label_0e_105	; $4ed7
	ld h,d			; $4ed9
	ld l,$84		; $4eda
	inc (hl)		; $4edc
	ld l,$86		; $4edd
	ld (hl),$3c		; $4edf
	ret			; $4ee1
	call _ecom_decCounter1		; $4ee2
	ret nz			; $4ee5
	ld l,e			; $4ee6
	dec (hl)		; $4ee7
	jp $5007		; $4ee8
	call $5104		; $4eeb
	call $5122		; $4eee
	call $512b		; $4ef1
	ld e,$84		; $4ef4
	ld a,(de)		; $4ef6
	sub $08			; $4ef7
	rst_jumpTable			; $4ef9
	ld ($284f),sp		; $4efa
	ld c,a			; $4efd
	sub d			; $4efe
	ld c,a			; $4eff
	and e			; $4f00
	ld c,a			; $4f01
	cp d			; $4f02
	ld c,a			; $4f03
	jp nc,$e94f		; $4f04
	ld c,a			; $4f07
	ld h,d			; $4f08
	ld l,e			; $4f09
	inc (hl)		; $4f0a
	ld l,$a5		; $4f0b
	ld (hl),$5a		; $4f0d
	ld l,$90		; $4f0f
	ld (hl),$14		; $4f11
	ld l,$8f		; $4f13
	ld (hl),$fc		; $4f15
	call getRandomNumber_noPreserveVars		; $4f17
	ld e,$b5		; $4f1a
	ld (de),a		; $4f1c
	ld e,$87		; $4f1d
	ldh a,(<hRng2)	; $4f1f
	ld (de),a		; $4f21
	call objectSetVisible81		; $4f22
	jp objectSetInvisible		; $4f25
	inc e			; $4f28
	ld a,(de)		; $4f29
	rst_jumpTable			; $4f2a
	ld sp,$614f		; $4f2b
	ld c,a			; $4f2e
	ld (hl),h		; $4f2f
	ld c,a			; $4f30
	ld h,d			; $4f31
	ld l,$b0		; $4f32
	bit 0,(hl)		; $4f34
	ret z			; $4f36
	ld l,e			; $4f37
	inc (hl)		; $4f38
	ld l,$b0		; $4f39
	set 1,(hl)		; $4f3b
	call $4f55		; $4f3d
	ld a,$08		; $4f40
	jr z,_label_0e_106	; $4f42
	call objectGetRelativeAngleWithTempVars		; $4f44
	add $04			; $4f47
	and $18			; $4f49
	rrca			; $4f4b
_label_0e_106:
	ld e,$b3		; $4f4c
	ld (de),a		; $4f4e
	call enemySetAnimation		; $4f4f
	jp $507e		; $4f52
	ld h,d			; $4f55
	ld l,$b1		; $4f56
	call _ecom_readPositionVars		; $4f58
	cp c			; $4f5b
	ret nz			; $4f5c
	ldh a,(<hFF8F)	; $4f5d
	cp b			; $4f5f
	ret			; $4f60
	call $4f55		; $4f61
	jp nz,_ecom_moveTowardPosition		; $4f64
	ld l,e			; $4f67
	inc (hl)		; $4f68
	ld l,$b0		; $4f69
	res 0,(hl)		; $4f6b
	ld l,$97		; $4f6d
	ld h,(hl)		; $4f6f
	ld l,$b0		; $4f70
	ld (hl),$01		; $4f72
	call $5131		; $4f74
	ld h,d			; $4f77
	ld l,$b0		; $4f78
	bit 0,(hl)		; $4f7a
	jp z,$5071		; $4f7c
	ld l,$84		; $4f7f
	ld (hl),$0c		; $4f81
	ld l,$a4		; $4f83
	set 7,(hl)		; $4f85
	ld l,$b0		; $4f87
	res 1,(hl)		; $4f89
	ld l,$86		; $4f8b
	ld (hl),$14		; $4f8d
	jp objectSetVisible81		; $4f8f
	ld h,d			; $4f92
	ld l,$b0		; $4f93
	bit 0,(hl)		; $4f95
	ret z			; $4f97
	set 1,(hl)		; $4f98
	ld l,e			; $4f9a
	inc (hl)		; $4f9b
	ld l,$86		; $4f9c
	ld (hl),$3c		; $4f9e
	jp $5071		; $4fa0
	call _ecom_decCounter1		; $4fa3
	jp nz,$506b		; $4fa6
	ld l,e			; $4fa9
	inc (hl)		; $4faa
	ld l,$a4		; $4fab
	set 7,(hl)		; $4fad
	ld l,$b0		; $4faf
	res 1,(hl)		; $4fb1
	ld l,$86		; $4fb3
	ld (hl),$08		; $4fb5
	jp objectSetVisible81		; $4fb7
	call _ecom_decCounter1		; $4fba
	jp nz,$506b		; $4fbd
	inc (hl)		; $4fc0
	ld b,$39		; $4fc1
	call _ecom_spawnProjectile		; $4fc3
	jp nz,$506b		; $4fc6
	ld h,d			; $4fc9
	ld l,$86		; $4fca
	ld (hl),$98		; $4fcc
	ld l,$84		; $4fce
	inc (hl)		; $4fd0
	ret			; $4fd1
	call _ecom_decCounter1		; $4fd2
	jp nz,$50cf		; $4fd5
	ld h,d			; $4fd8
	ld l,$84		; $4fd9
	inc (hl)		; $4fdb
	ld l,$a4		; $4fdc
	res 7,(hl)		; $4fde
	ld l,$b0		; $4fe0
	set 1,(hl)		; $4fe2
	ld l,$86		; $4fe4
	ld (hl),$3c		; $4fe6
	ret			; $4fe8
	call _ecom_decCounter1		; $4fe9
	ret nz			; $4fec
	ld l,e			; $4fed
	ld (hl),$0a		; $4fee
	ld l,$b0		; $4ff0
	ld (hl),$00		; $4ff2
	ld l,$a5		; $4ff4
	ld a,(hl)		; $4ff6
	cp $43			; $4ff7
	jr nz,_label_0e_107	; $4ff9
	ld (hl),$5a		; $4ffb
	ld l,$97		; $4ffd
	ld h,(hl)		; $4fff
	ld l,$8f		; $5000
	ld (hl),$00		; $5002
_label_0e_107:
	jp objectSetInvisible		; $5004
	call getRandomNumber_noPreserveVars		; $5007
	and $03			; $500a
	ld b,a			; $500c
	add a			; $500d
	add b			; $500e
	ld hl,$5053		; $500f
	rst_addDoubleIndex			; $5012
	ld e,$b1		; $5013
_label_0e_108:
	ld a,(de)		; $5015
	ld b,a			; $5016
_label_0e_109:
	ld c,$8b		; $5017
	ldi a,(hl)		; $5019
	ld (bc),a		; $501a
	ld c,$8d		; $501b
	ldi a,(hl)		; $501d
	ld (bc),a		; $501e
	ld c,$b0		; $501f
	ld a,$01		; $5021
	ld (bc),a		; $5023
	inc e			; $5024
	ld a,$b4		; $5025
	cp e			; $5027
	jr nz,_label_0e_108	; $5028
_label_0e_110:
	call getRandomNumber_noPreserveVars		; $502a
	and $03			; $502d
	cp $03			; $502f
	jr z,_label_0e_110	; $5031
	add $b1			; $5033
	ld e,a			; $5035
	ld a,(de)		; $5036
	ld h,a			; $5037
	ld l,$b0		; $5038
	set 7,(hl)		; $503a
	ld l,$89		; $503c
	ld a,(hl)		; $503e
	swap a			; $503f
	rlca			; $5041
	ld bc,$50cb		; $5042
	call addAToBc		; $5045
	ld l,$8b		; $5048
	ld e,l			; $504a
	ldi a,(hl)		; $504b
	ld (de),a		; $504c
	inc l			; $504d
	ld e,l			; $504e
	ld a,(bc)		; $504f
	add (hl)		; $5050
	ld (de),a		; $5051
	ret			; $5052
	jr c,_label_0e_116	; $5053
	ld a,b			; $5055
	ld c,b			; $5056
	ld a,b			; $5057
	xor b			; $5058
	jr c,_label_0e_114	; $5059
	jr c,-$58		; $505b
	ld a,b			; $505d
	ld a,b			; $505e
	jr nc,_label_0e_113	; $505f
	ld e,b			; $5061
	ld b,b			; $5062
	add b			; $5063
	ld b,b			; $5064
	jr nc,_label_0e_109	; $5065
	ld e,b			; $5067
	or b			; $5068
	add b			; $5069
	or b			; $506a
	ld a,(wFrameCounter)		; $506b
	and $07			; $506e
	ret nz			; $5070
	call _ecom_updateCardinalAngleTowardTarget		; $5071
	rrca			; $5074
	ld h,d			; $5075
	ld l,$b3		; $5076
	cp (hl)			; $5078
	ret z			; $5079
	ld (hl),a		; $507a
	call enemySetAnimation		; $507b
_label_0e_111:
	ld e,$89		; $507e
	ld a,(de)		; $5080
	bit 3,a			; $5081
	ld b,$08		; $5083
	jr z,_label_0e_112	; $5085
	ld b,$05		; $5087
_label_0e_112:
	ld e,$a7		; $5089
	ld a,b			; $508b
	ld (de),a		; $508c
	call $50ab		; $508d
	ld e,$b0		; $5090
	ld a,(de)		; $5092
	bit 7,a			; $5093
	ret z			; $5095
	ld e,$89		; $5096
	ld a,(de)		; $5098
	swap a			; $5099
	rlca			; $509b
	ld hl,$50cb		; $509c
	rst_addAToHl			; $509f
	ld c,(hl)		; $50a0
_label_0e_113:
	ld b,$00		; $50a1
_label_0e_114:
	ld a,$0b		; $50a3
	call objectGetRelatedObject1Var		; $50a5
	jp objectCopyPositionWithOffset		; $50a8
	ld e,$b3		; $50ab
	ld a,(de)		; $50ad
	inc a			; $50ae
	and $03			; $50af
	ret nz			; $50b1
	ld e,$8d		; $50b2
	ld a,(de)		; $50b4
	add $03			; $50b5
	and $f8			; $50b7
	ld (de),a		; $50b9
	ld h,d			; $50ba
	ld l,$89		; $50bb
	bit 3,(hl)		; $50bd
	ret z			; $50bf
	bit 4,(hl)		; $50c0
	ld b,$03		; $50c2
	jr z,_label_0e_115	; $50c4
	ld b,$fd		; $50c6
_label_0e_115:
	add b			; $50c8
	ld (de),a		; $50c9
	ret			; $50ca
	nop			; $50cb
.DB $fd				; $50cc
_label_0e_116:
	nop			; $50cd
	inc bc			; $50ce
	call $50f2		; $50cf
	ld e,$b4		; $50d2
	ld a,b			; $50d4
	ld (de),a		; $50d5
	ld e,$87		; $50d6
	ld a,(de)		; $50d8
	dec a			; $50d9
	ld (de),a		; $50da
	and $07			; $50db
	call z,_ecom_updateCardinalAngleTowardTarget		; $50dd
	ld e,$89		; $50e0
	ld a,(de)		; $50e2
	rrca			; $50e3
	ld h,d			; $50e4
	ld l,$b4		; $50e5
	add (hl)		; $50e7
	ld l,$b3		; $50e8
	cp (hl)			; $50ea
	ret z			; $50eb
	ld (hl),a		; $50ec
	call enemySetAnimation		; $50ed
	jr _label_0e_111		; $50f0
	ld e,$86		; $50f2
	ld a,(de)		; $50f4
	ld b,$00		; $50f5
	cp $8e			; $50f7
	ret nc			; $50f9
	inc b			; $50fa
	cp $84			; $50fb
	ret nc			; $50fd
	inc b			; $50fe
	cp $7a			; $50ff
	ret nc			; $5101
	inc b			; $5102
	ret			; $5103
	ld h,d			; $5104
	ld l,$b5		; $5105
	dec (hl)		; $5107
	ld a,(hl)		; $5108
	and $0f			; $5109
	ret nz			; $510b
	ld a,(hl)		; $510c
	and $70			; $510d
	swap a			; $510f
	ld hl,$511a		; $5111
	rst_addAToHl			; $5114
	ld e,$8f		; $5115
	ld a,(hl)		; $5117
	ld (de),a		; $5118
	ret			; $5119
.DB $fc				; $511a
	ei			; $511b
	ld a,($fcfb)		; $511c
.DB $fd				; $511f
	cp $fd			; $5120
	ld e,$b0		; $5122
	ld a,(de)		; $5124
	bit 1,a			; $5125
	ret z			; $5127
	jp _ecom_flickerVisibility		; $5128
	ld e,$84		; $512b
	ld a,(de)		; $512d
	cp $0b			; $512e
	ret c			; $5130
	ld h,d			; $5131
	ld l,$b0		; $5132
	bit 7,(hl)		; $5134
	ret z			; $5136
	ld a,($cca9)		; $5137
	cp $02			; $513a
	ld a,$5a		; $513c
	ld b,$00		; $513e
	jr nz,_label_0e_117	; $5140
	ld a,$43		; $5142
	ld b,$fc		; $5144
_label_0e_117:
	ld e,$a5		; $5146
	ld (de),a		; $5148
	ld a,$0f		; $5149
	call objectGetRelatedObject1Var		; $514b
	ld (hl),b		; $514e
	ret			; $514f

; ==============================================================================
; ENEMYID_SYGER
; ==============================================================================
enemyCode74:
	jr z,_label_0e_121	; $5150
	sub $03			; $5152
	ret c			; $5154
	sub $01			; $5155
	jr z,_label_0e_119	; $5157
	jr nc,_label_0e_121	; $5159
	ld e,$82		; $515b
	ld a,(de)		; $515d
	dec a			; $515e
	jr nz,_label_0e_121	; $515f
	ld a,$04		; $5161
	call objectGetRelatedObject2Var		; $5163
	ld a,$0a		; $5166
	cp (hl)			; $5168
	jr c,_label_0e_118	; $5169
	ld (hl),a		; $516b
	ld a,$d1		; $516c
	call playSound		; $516e
_label_0e_118:
	jp _enemyBoss_dead		; $5171
_label_0e_119:
	ld e,$82		; $5174
	ld a,(de)		; $5176
	dec a			; $5177
	jr z,_label_0e_121	; $5178
	ld a,$2b		; $517a
	call objectGetRelatedObject1Var		; $517c
	ld e,l			; $517f
	ld a,(de)		; $5180
	ld (hl),a		; $5181
	ld l,$84		; $5182
	ld a,(hl)		; $5184
	cp $09			; $5185
	jr nz,_label_0e_120	; $5187
	ld l,$86		; $5189
	ld (hl),$1c		; $518b
_label_0e_120:
	ld l,$a9		; $518d
	ld e,l			; $518f
	ld a,(de)		; $5190
	ld (hl),a		; $5191
	or a			; $5192
	jr nz,_label_0e_121	; $5193
	ld l,$a4		; $5195
	res 7,(hl)		; $5197
_label_0e_121:
	call _ecom_getSubidAndCpStateTo08		; $5199
	jr c,_label_0e_122	; $519c
	dec b			; $519e
	jp z,$51e8		; $519f
	jp $542e		; $51a2
_label_0e_122:
	rst_jumpTable			; $51a5
	or (hl)			; $51a6
	ld d,c			; $51a7
	push bc			; $51a8
	ld d,c			; $51a9
	rst $20			; $51aa
	ld d,c			; $51ab
	rst $20			; $51ac
	ld d,c			; $51ad
	rst $20			; $51ae
	ld d,c			; $51af
	rst $20			; $51b0
	ld d,c			; $51b1
	rst $20			; $51b2
	ld d,c			; $51b3
	rst $20			; $51b4
	ld d,c			; $51b5
	ld a,$01		; $51b6
	ld (de),a		; $51b8
	ld e,$82		; $51b9
	ld a,(de)		; $51bb
	or a			; $51bc
	jp nz,_ecom_setSpeedAndState8		; $51bd
	ld a,$74		; $51c0
	jp _enemyBoss_initializeRoom		; $51c2
	ld b,$02		; $51c5
	call checkBEnemySlotsAvailable		; $51c7
	ret nz			; $51ca
	ld b,$74		; $51cb
	call _ecom_spawnUncountedEnemyWithSubid01		; $51cd
	ld c,h			; $51d0
	call _ecom_spawnUncountedEnemyWithSubid01		; $51d1
	inc (hl)		; $51d4
	ld l,$96		; $51d5
	ld a,$80		; $51d7
	ldi (hl),a		; $51d9
	ld (hl),c		; $51da
	ld b,h			; $51db
	ld h,c			; $51dc
	ld l,$98		; $51dd
	ldi (hl),a		; $51df
	ld (hl),b		; $51e0
	call objectCopyPosition		; $51e1
	jp enemyDelete		; $51e4
	ret			; $51e7
	ld e,$84		; $51e8
	ld a,(de)		; $51ea
	sub $08			; $51eb
	cp $03			; $51ed
	jr c,_label_0e_123	; $51ef
	call $54b5		; $51f1
	ld e,$b5		; $51f4
	ld a,(de)		; $51f6
	ld e,$84		; $51f7
	rst_jumpTable			; $51f9
	cp h			; $51fa
	ld d,d			; $51fb
.DB $fd				; $51fc
	ld d,d			; $51fd
	ld (hl),h		; $51fe
	ld d,e			; $51ff
_label_0e_123:
	rst_jumpTable			; $5200
	rlca			; $5201
	ld d,d			; $5202
	ld h,(hl)		; $5203
	ld d,d			; $5204
	sub d			; $5205
	ld d,d			; $5206
	inc e			; $5207
	ld a,(de)		; $5208
	rst_jumpTable			; $5209
	stop			; $520a
	ld d,d			; $520b
	add hl,hl		; $520c
	ld d,d			; $520d
	ld c,h			; $520e
	ld d,d			; $520f
	ld bc,$0108		; $5210
	call _enemyBoss_spawnShadow		; $5213
	ret nz			; $5216
	call _ecom_setZAboveScreen		; $5217
	ld l,$85		; $521a
	inc (hl)		; $521c
	ld l,$a5		; $521d
	ld (hl),$5b		; $521f
	ld a,$02		; $5221
	call $5512		; $5223
	jp objectSetVisible81		; $5226
	ld c,$18		; $5229
	call objectUpdateSpeedZAndBounce		; $522b
	jr nz,_label_0e_127	; $522e
	jr nc,_label_0e_124	; $5230
	ld h,d			; $5232
	ld l,$85		; $5233
	inc (hl)		; $5235
	inc l			; $5236
	ld (hl),$5a		; $5237
	xor a			; $5239
	call $5512		; $523a
	ld a,$2d		; $523d
	ld (wActiveMusic),a		; $523f
	call playSound		; $5242
_label_0e_124:
	ld a,$8f		; $5245
	call playSound		; $5247
	jr _label_0e_127		; $524a
	call _ecom_decCounter1		; $524c
	jr z,_label_0e_125	; $524f
	ld a,(hl)		; $5251
	cp $46			; $5252
	ld a,$d1		; $5254
	call z,playSound		; $5256
	jr _label_0e_127		; $5259
_label_0e_125:
	ld l,e			; $525b
	ld (hl),$00		; $525c
	dec l			; $525e
	ld (hl),$0b		; $525f
	call $556f		; $5261
	jr _label_0e_127		; $5264
	call _ecom_decCounter1		; $5266
	jr nz,_label_0e_126	; $5269
	inc l			; $526b
	ldd a,(hl)		; $526c
	ld (hl),a		; $526d
	ld l,e			; $526e
	inc (hl)		; $526f
	dec a			; $5270
	jr z,_label_0e_127	; $5271
	ld l,$90		; $5273
	ld (hl),$78		; $5275
	ld a,$02		; $5277
	ld l,$87		; $5279
	ld (hl),a		; $527b
	jp $5512		; $527c
_label_0e_126:
	ld l,$86		; $527f
	ld a,(hl)		; $5281
	cp $96			; $5282
	jr nc,_label_0e_127	; $5284
	call $554a		; $5286
	call _ecom_bounceOffWallsAndHoles		; $5289
	call objectApplySpeed		; $528c
_label_0e_127:
	jp enemyAnimate		; $528f
	call _ecom_decCounter1		; $5292
	jr z,_label_0e_128	; $5295
	ld c,$12		; $5297
	call objectUpdateSpeedZ_paramC		; $5299
	jp nz,$5523		; $529c
	ld a,$8f		; $529f
	call playSound		; $52a1
	ld h,d			; $52a4
	ld l,$87		; $52a5
	dec (hl)		; $52a7
	jr z,_label_0e_128	; $52a8
	dec l			; $52aa
	ld (hl),$f0		; $52ab
	ld l,$94		; $52ad
	ld a,$40		; $52af
	ldi (hl),a		; $52b1
	ld (hl),$fe		; $52b2
	jr _label_0e_127		; $52b4
_label_0e_128:
	ld l,$84		; $52b6
	inc (hl)		; $52b8
	jp $556f		; $52b9
	inc e			; $52bc
	ld a,(de)		; $52bd
	rst_jumpTable			; $52be
	push bc			; $52bf
	ld d,d			; $52c0
	sub $52			; $52c1
.DB $ec				; $52c3
	ld d,d			; $52c4
	ld h,d			; $52c5
	ld l,e			; $52c6
	inc (hl)		; $52c7
	inc l			; $52c8
	ld (hl),$1e		; $52c9
	ld l,$a6		; $52cb
	ld a,$09		; $52cd
	ldi (hl),a		; $52cf
	ld (hl),a		; $52d0
	ld a,$03		; $52d1
	call $5512		; $52d3
	call _ecom_decCounter1		; $52d6
	jp nz,$557b		; $52d9
	ld (hl),$78		; $52dc
	inc l			; $52de
	ld (hl),$02		; $52df
	ld l,e			; $52e1
	inc (hl)		; $52e2
	ld l,$90		; $52e3
	ld (hl),$46		; $52e5
	call _ecom_updateAngleTowardTarget		; $52e7
	jr _label_0e_127		; $52ea
	call _ecom_decCounter1		; $52ec
	jr nz,_label_0e_129	; $52ef
	ld (hl),$2d		; $52f1
	inc l			; $52f3
	dec (hl)		; $52f4
	jp z,$54c6		; $52f5
	call _ecom_updateAngleTowardTarget		; $52f8
	jr _label_0e_127		; $52fb
	inc e			; $52fd
	ld a,(de)		; $52fe
	rst_jumpTable			; $52ff
	ld b,$53		; $5300
	dec de			; $5302
	ld d,e			; $5303
	ld b,l			; $5304
	ld d,e			; $5305
	ld h,d			; $5306
	ld l,e			; $5307
	inc (hl)		; $5308
	inc l			; $5309
	ld (hl),$0f		; $530a
	ld l,$a6		; $530c
	ld a,$09		; $530e
	ldi (hl),a		; $5310
	ld (hl),a		; $5311
	ld l,$90		; $5312
	ld (hl),$78		; $5314
	ld a,$03		; $5316
	call $5512		; $5318
	call $557b		; $531b
	call _ecom_decCounter1		; $531e
	ret nz			; $5321
	ld l,$85		; $5322
	inc (hl)		; $5324
	call getRandomNumber_noPreserveVars		; $5325
	and $01			; $5328
	ld hl,$55ab		; $532a
	rst_addDoubleIndex			; $532d
	ldi a,(hl)		; $532e
	ld h,(hl)		; $532f
	ld l,a			; $5330
	ld e,$89		; $5331
	ldi a,(hl)		; $5333
	ld (de),a		; $5334
	ld e,$b8		; $5335
	ldi a,(hl)		; $5337
	ld (de),a		; $5338
	ld e,$86		; $5339
	ldi a,(hl)		; $533b
	ld (de),a		; $533c
	ld e,$b1		; $533d
	ld a,l			; $533f
	ld (de),a		; $5340
	inc e			; $5341
	ld a,h			; $5342
	ld (de),a		; $5343
	ret			; $5344
	call _ecom_decCounter1		; $5345
	jp nz,$5365		; $5348
	ld e,$b1		; $534b
	ld a,(de)		; $534d
	ld l,a			; $534e
	inc e			; $534f
	ld a,(de)		; $5350
	ld h,a			; $5351
	ld a,(hl)		; $5352
	inc a			; $5353
	jp z,$54c6		; $5354
	ld e,$b8		; $5357
	ld a,(de)		; $5359
	ld b,a			; $535a
	ld e,$89		; $535b
	ld a,(de)		; $535d
	add b			; $535e
	and $1f			; $535f
	ld (de),a		; $5361
	call $5339		; $5362
_label_0e_129:
	call $5563		; $5365
	call _ecom_bounceOffWallsAndHoles		; $5368
	call objectApplySpeed		; $536b
	call $556f		; $536e
	jp $557b		; $5371
	inc e			; $5374
	ld a,(de)		; $5375
	rst_jumpTable			; $5376
	add e			; $5377
	ld d,e			; $5378
	sub e			; $5379
	ld d,e			; $537a
	call $ed53		; $537b
	ld d,e			; $537e
	rrca			; $537f
	ld d,h			; $5380
	rra			; $5381
	ld d,h			; $5382
	ld h,d			; $5383
	ld l,e			; $5384
	inc (hl)		; $5385
	inc l			; $5386
	ld (hl),$3c		; $5387
	inc l			; $5389
	ld (hl),$04		; $538a
	ld l,$a6		; $538c
	ld a,$09		; $538e
	ldi (hl),a		; $5390
	ld (hl),a		; $5391
	ret			; $5392
	call _ecom_decCounter2		; $5393
	ld l,$94		; $5396
	ld a,$80		; $5398
	ldi (hl),a		; $539a
	ld (hl),$fe		; $539b
	ld l,e			; $539d
	jr nz,_label_0e_130	; $539e
	ld (hl),$05		; $53a0
	ret			; $53a2
_label_0e_130:
	inc (hl)		; $53a3
	ld l,$90		; $53a4
	ld (hl),$64		; $53a6
	ld l,$87		; $53a8
	ld a,(hl)		; $53aa
	dec a			; $53ab
	ld bc,$55a8		; $53ac
	call addAToBc		; $53af
	ld l,$b6		; $53b2
	ld a,(bc)		; $53b4
	ldi (hl),a		; $53b5
	ldh a,(<hEnemyTargetX)	; $53b6
	ld b,$18		; $53b8
	cp b			; $53ba
	jr c,_label_0e_131	; $53bb
	ld b,$d8		; $53bd
	cp b			; $53bf
	jr nc,_label_0e_131	; $53c0
	ld b,a			; $53c2
_label_0e_131:
	ld (hl),b		; $53c3
	ld e,$87		; $53c4
	ld a,(de)		; $53c6
	and $01			; $53c7
	inc a			; $53c9
	jp $5512		; $53ca
	ld c,$12		; $53cd
	call objectUpdateSpeedZ_paramC		; $53cf
	jp nz,$5518		; $53d2
	ld l,$85		; $53d5
	inc (hl)		; $53d7
	inc l			; $53d8
	ld (hl),$1e		; $53d9
	ld l,$87		; $53db
	ld a,(hl)		; $53dd
	and $01			; $53de
	swap a			; $53e0
	ld l,$89		; $53e2
	ld (hl),a		; $53e4
	ld a,$8f		; $53e5
	call playSound		; $53e7
_label_0e_132:
	jp enemyAnimate		; $53ea
	call _ecom_decCounter1		; $53ed
	jr z,_label_0e_134	; $53f0
	ld a,(hl)		; $53f2
	cp $14			; $53f3
	jr nc,_label_0e_133	; $53f5
	call enemyAnimate		; $53f7
	ld a,(wFrameCounter)		; $53fa
	and $07			; $53fd
	ld a,$6b		; $53ff
	call z,playSound		; $5401
_label_0e_133:
	jr _label_0e_132		; $5404
_label_0e_134:
	ld l,e			; $5406
	inc (hl)		; $5407
	ld a,$bb		; $5408
	call playSound		; $540a
	jr _label_0e_132		; $540d
	call enemyAnimate		; $540f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $5412
	call nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $5415
	ret nz			; $5418
	ld e,$85		; $5419
	ld a,$01		; $541b
	ld (de),a		; $541d
	ret			; $541e
	ld c,$12		; $541f
	call objectUpdateSpeedZ_paramC		; $5421
	jr nz,_label_0e_132	; $5424
	ld a,$8f		; $5426
	call playSound		; $5428
	jp $54c9		; $542b
	ld a,(de)		; $542e
	sub $08			; $542f
	rst_jumpTable			; $5431
	ldd a,(hl)		; $5432
	ld d,h			; $5433
	ld c,c			; $5434
	ld d,h			; $5435
	sub (hl)		; $5436
	ld d,h			; $5437
	and h			; $5438
	ld d,h			; $5439
	ld h,d			; $543a
	ld l,e			; $543b
	inc (hl)		; $543c
	ld l,$a6		; $543d
	ld (hl),$03		; $543f
	inc l			; $5441
	ld (hl),$08		; $5442
	ld a,$04		; $5444
	jp enemySetAnimation		; $5446
	call enemyAnimate		; $5449
	ld a,$30		; $544c
	call objectGetRelatedObject1Var		; $544e
	ld a,(hl)		; $5451
	or a			; $5452
	ld e,$b0		; $5453
	jr z,_label_0e_135	; $5455
	ld a,$01		; $5457
	ld (de),a		; $5459
	ld h,d			; $545a
	ld l,$a4		; $545b
	res 7,(hl)		; $545d
	jp objectSetInvisible		; $545f
_label_0e_135:
	ld a,(de)		; $5462
	dec a			; $5463
	jr nz,_label_0e_136	; $5464
	ld (de),a		; $5466
	call getRandomNumber		; $5467
	and $01			; $546a
	inc a			; $546c
	xor $01			; $546d
	ld bc,$559c		; $546f
	call addAToBc		; $5472
	ld e,$b1		; $5475
	ld a,(bc)		; $5477
	ld (de),a		; $5478
	inc e			; $5479
	inc bc			; $547a
	ld a,(bc)		; $547b
	ld (de),a		; $547c
	inc bc			; $547d
	ld a,(bc)		; $547e
	push hl			; $547f
	call enemySetAnimation		; $5480
	pop hl			; $5483
_label_0e_136:
	ld e,$b1		; $5484
	ld a,(de)		; $5486
	ld b,a			; $5487
	inc e			; $5488
	ld a,(de)		; $5489
	ld c,a			; $548a
	call objectTakePositionWithOffset		; $548b
	ld h,d			; $548e
	ld l,$a4		; $548f
	set 7,(hl)		; $5491
	jp objectSetVisible82		; $5493
	ld h,d			; $5496
	ld l,$9a		; $5497
	bit 7,(hl)		; $5499
	jp z,enemyDelete		; $549b
	ld l,$a4		; $549e
	res 7,(hl)		; $54a0
	ld l,e			; $54a2
	inc (hl)		; $54a3
	ld a,$01		; $54a4
	call objectGetRelatedObject1Var		; $54a6
	ld a,(hl)		; $54a9
	cp $74			; $54aa
	jp nz,enemyDelete		; $54ac
	ld l,$9a		; $54af
	ld e,l			; $54b1
	ld a,(hl)		; $54b2
	ld (de),a		; $54b3
	ret			; $54b4
	ld e,$b5		; $54b5
	ld a,(de)		; $54b7
	cp $02			; $54b8
	ret z			; $54ba
	ld a,(wFrameCounter)		; $54bb
	and $07			; $54be
	ret nz			; $54c0
	ld a,$6d		; $54c1
	jp playSound		; $54c3
	call $5563		; $54c6
	ld bc,$1f01		; $54c9
	call _ecom_randomBitwiseAndBCE		; $54cc
	ld h,d			; $54cf
	ld l,$90		; $54d0
	ld (hl),$14		; $54d2
	ld l,$89		; $54d4
	ld (hl),b		; $54d6
	ld e,$b5		; $54d7
	ld a,(de)		; $54d9
	add a			; $54da
	add c			; $54db
	ld hl,$55a2		; $54dc
	rst_addAToHl			; $54df
	ld e,$b5		; $54e0
	ld a,(hl)		; $54e2
	ld (de),a		; $54e3
	dec a			; $54e4
	jr z,_label_0e_137	; $54e5
	call $556f		; $54e7
	ld l,$84		; $54ea
	ld (hl),$09		; $54ec
	inc l			; $54ee
	ld (hl),$00		; $54ef
	ld l,$86		; $54f1
	ld (hl),$b4		; $54f3
	inc l			; $54f5
	ld (hl),$01		; $54f6
	jr _label_0e_138		; $54f8
	call $5563		; $54fa
_label_0e_137:
	ld bc,$fe20		; $54fd
	call objectSetSpeedZ		; $5500
	ld l,$84		; $5503
	ld (hl),$09		; $5505
	inc l			; $5507
	ld (hl),$00		; $5508
	ld l,$86		; $550a
	ld (hl),$78		; $550c
	inc l			; $550e
	ld (hl),$f0		; $550f
_label_0e_138:
	xor a			; $5511
	ld e,$b0		; $5512
	ld (de),a		; $5514
	jp enemySetAnimation		; $5515
	call enemyAnimate		; $5518
	ld h,d			; $551b
	ld l,$b6		; $551c
	call _ecom_readPositionVars		; $551e
	jr _label_0e_139		; $5521
	call enemyAnimate		; $5523
	ld bc,$3878		; $5526
	ld h,d			; $5529
	ld l,$8b		; $552a
	ldi a,(hl)		; $552c
	ldh (<hFF8F),a	; $552d
	inc l			; $552f
	ld a,(hl)		; $5530
	ldh (<hFF8E),a	; $5531
_label_0e_139:
	sub c			; $5533
	add $02			; $5534
	cp $05			; $5536
	jp nc,_ecom_moveTowardPosition		; $5538
	ldh a,(<hFF8F)	; $553b
	sub b			; $553d
	add $02			; $553e
	cp $05			; $5540
	jp nc,_ecom_moveTowardPosition		; $5542
	ld (hl),c		; $5545
	ld l,$8b		; $5546
	ld (hl),b		; $5548
	ret			; $5549
	ld a,($ccf0)		; $554a
	or a			; $554d
	jr nz,_label_0e_140	; $554e
	ld a,(wFrameCounter)		; $5550
	and $3f			; $5553
	ret nz			; $5555
	call getRandomNumber_noPreserveVars		; $5556
	and $1f			; $5559
	ld e,$89		; $555b
	ld (de),a		; $555d
	ret			; $555e
_label_0e_140:
	inc (hl)		; $555f
	jp _ecom_updateAngleToScentSeed		; $5560
	ld h,d			; $5563
	ld l,$b3		; $5564
	ld e,$8b		; $5566
	ldi a,(hl)		; $5568
	ld (de),a		; $5569
	ld e,$8d		; $556a
	ld a,(hl)		; $556c
	ld (de),a		; $556d
	ret			; $556e
	ld h,d			; $556f
	ld l,$b3		; $5570
	ld e,$8b		; $5572
	ld a,(de)		; $5574
	ldi (hl),a		; $5575
	ld e,$8d		; $5576
	ld a,(de)		; $5578
	ld (hl),a		; $5579
	ret			; $557a
	call enemyAnimate		; $557b
	call $5563		; $557e
	ld e,$a1		; $5581
	ld a,(de)		; $5583
	ld hl,$5594		; $5584
	rst_addAToHl			; $5587
	ld e,$8b		; $5588
	ld a,(de)		; $558a
	add (hl)		; $558b
	ld (de),a		; $558c
	inc hl			; $558d
	ld e,$8d		; $558e
	ld a,(de)		; $5590
	add (hl)		; $5591
	ld (de),a		; $5592
	ret			; $5593
	inc b			; $5594
	inc b			; $5595
	inc b			; $5596
.DB $fc				; $5597
.DB $fc				; $5598
.DB $fc				; $5599
.DB $fc				; $559a
	inc b			; $559b
	or $10			; $559c
	inc b			; $559e
	or $f0			; $559f
	dec b			; $55a1
	ld bc,$0002		; $55a2
	ld (bc),a		; $55a5
	nop			; $55a6
	ld bc,$941c		; $55a7
	inc e			; $55aa
	xor a			; $55ab
	ld d,l			; $55ac
	cp a			; $55ad
	ld d,l			; $55ae
	stop			; $55af
	ld hl,sp+$0a		; $55b0
	rlca			; $55b2
	dec b			; $55b3
	ld c,$0a		; $55b4
	dec de			; $55b6
	inc d			; $55b7
	jr z,_label_0e_141	; $55b8
	ldd (hl),a		; $55ba
	ld hl,$253b		; $55bb
	rst $38			; $55be
	inc c			; $55bf
	ld (bc),a		; $55c0
	ld b,b			; $55c1
	rlca			; $55c2
	rlca			; $55c3
	rlca			; $55c4
	ld h,$0b		; $55c5
	inc c			; $55c7
	inc c			; $55c8
	dec l			; $55c9
	dec b			; $55ca
	dec b			; $55cb
	dec b			; $55cc
	dec l			; $55cd
	ld a,(bc)		; $55ce
	ld a,(bc)		; $55cf
	ld a,(bc)		; $55d0
	ld b,(hl)		; $55d1
	rst $38			; $55d2

; ==============================================================================
; ENEMYID_VIRE
; ==============================================================================
enemyCode75:
	jr z,_label_0e_145	; $55d3
	sub $03			; $55d5
	ret c			; $55d7
_label_0e_141:
	jr z,_label_0e_143	; $55d8
	ld e,$82		; $55da
	ld a,(de)		; $55dc
	or a			; $55dd
	ld e,$a9		; $55de
	ld a,(de)		; $55e0
	jr z,_label_0e_142	; $55e1
	or a			; $55e3
	ret z			; $55e4
	jr _label_0e_145		; $55e5
_label_0e_142:
	ld h,d			; $55e7
	ld l,$b3		; $55e8
	cp (hl)			; $55ea
	jr z,_label_0e_145	; $55eb
	ld (hl),a		; $55ed
	or a			; $55ee
	ret z			; $55ef
	ld l,$84		; $55f0
	ld (hl),$0e		; $55f2
	inc l			; $55f4
	ld (hl),$00		; $55f5
	ret			; $55f7
_label_0e_143:
	ld e,$82		; $55f8
	ld a,(de)		; $55fa
	or a			; $55fb
	jr z,_label_0e_144	; $55fc
	call objectCreatePuff		; $55fe
	ld a,$34		; $5601
	call objectGetRelatedObject1Var		; $5603
	dec (hl)		; $5606
	call z,objectCopyPosition		; $5607
	jp enemyDelete		; $560a
_label_0e_144:
	ld h,d			; $560d
	ld l,$84		; $560e
	ld a,(hl)		; $5610
	cp $0f			; $5611
	jp z,_enemyBoss_dead		; $5613
	ld (hl),$0f		; $5616
	inc l			; $5618
	ld (hl),$00		; $5619
	inc l			; $561b
	ld (hl),$14		; $561c
	ld l,$a9		; $561e
	ld (hl),$01		; $5620
	ld l,$88		; $5622
	xor a			; $5624
	ld (hl),a		; $5625
	call enemySetAnimation		; $5626
_label_0e_145:
	call _ecom_getSubidAndCpStateTo08		; $5629
	jr c,_label_0e_146	; $562c
	ld a,b			; $562e
	or a			; $562f
	jp z,$565d		; $5630
	jp $59cc		; $5633
_label_0e_146:
	ld e,$84		; $5636
	ld a,(de)		; $5638
	rst_jumpTable			; $5639
	ld c,d			; $563a
	ld d,(hl)		; $563b
	ld e,h			; $563c
	ld d,(hl)		; $563d
	ld e,h			; $563e
	ld d,(hl)		; $563f
	ld e,h			; $5640
	ld d,(hl)		; $5641
	ld e,h			; $5642
	ld d,(hl)		; $5643
	ld e,h			; $5644
	ld d,(hl)		; $5645
	ld e,h			; $5646
	ld d,(hl)		; $5647
	ld e,h			; $5648
	ld d,(hl)		; $5649
	ld a,$1e		; $564a
	call _ecom_setSpeedAndState8		; $564c
	ld a,b			; $564f
	or a			; $5650
	ret nz			; $5651
	ld l,$8f		; $5652
	ld (hl),$fc		; $5654
	dec a			; $5656
	ld b,$00		; $5657
	jp _enemyBoss_initializeRoom		; $5659
	ret			; $565c
	ld e,$88		; $565d
	ld a,(de)		; $565f
	or a			; $5660
	jr z,_label_0e_147	; $5661
	ld h,d			; $5663
	ld l,$b2		; $5664
	inc (hl)		; $5666
	ld a,(hl)		; $5667
	cp $18			; $5668
	jr c,_label_0e_147	; $566a
	xor a			; $566c
	ld (hl),a		; $566d
	ld l,e			; $566e
	ld (hl),a		; $566f
	call enemySetAnimation		; $5670
_label_0e_147:
	ld e,$84		; $5673
	ld a,(de)		; $5675
	sub $08			; $5676
	rst_jumpTable			; $5678
	adc c			; $5679
	ld d,(hl)		; $567a
	dec bc			; $567b
	ld d,a			; $567c
	ccf			; $567d
	ld d,a			; $567e
	add e			; $567f
	ld d,a			; $5680
	rst $30			; $5681
	ld d,a			; $5682
	dec sp			; $5683
	ld e,b			; $5684
	cp (hl)			; $5685
	ld e,b			; $5686
	ld bc,$1c59		; $5687
	ld a,(de)		; $568a
	rst_jumpTable			; $568b
	sub h			; $568c
	ld d,(hl)		; $568d
	jp nz,$d456		; $568e
	ld d,(hl)		; $5691
	add sp,$56		; $5692
	ldh a,(<hEnemyTargetY)	; $5694
	sub $38			; $5696
	cp $41			; $5698
	ret nc			; $569a
	ldh a,(<hEnemyTargetX)	; $569b
	sub $50			; $569d
	cp $51			; $569f
	ret nc			; $56a1
	ld a,($cc34)		; $56a2
	or a			; $56a5
	ret nz			; $56a6
	ld bc,$0502		; $56a7
	call objectCreateInteraction		; $56aa
	ret nz			; $56ad
	ld e,$99		; $56ae
	ld a,h			; $56b0
	ld (de),a		; $56b1
	dec e			; $56b2
	ld a,$40		; $56b3
	ld (de),a		; $56b5
	ld e,$85		; $56b6
	ld a,$01		; $56b8
	ld (de),a		; $56ba
	ld ($cca4),a		; $56bb
	ld ($cbca),a		; $56be
	ret			; $56c1
	ld a,$21		; $56c2
	call objectGetRelatedObject2Var		; $56c4
	bit 7,(hl)		; $56c7
	ret z			; $56c9
	ld h,d			; $56ca
	ld l,$85		; $56cb
	inc (hl)		; $56cd
	inc l			; $56ce
	ld (hl),$08		; $56cf
	jp objectSetVisiblec1		; $56d1
	call _ecom_decCounter1		; $56d4
	jp nz,enemyAnimate		; $56d7
	ld l,e			; $56da
	inc (hl)		; $56db
	ld bc,$2f12		; $56dc
	call checkIsLinkedGame		; $56df
	jr z,_label_0e_148	; $56e2
	inc c			; $56e4
_label_0e_148:
	jp showText		; $56e5
	call objectCreatePuff		; $56e8
	ret nz			; $56eb
	ld ($cca4),a		; $56ec
	ld ($cbca),a		; $56ef
	ld h,d			; $56f2
	ld l,$84		; $56f3
	inc (hl)		; $56f5
	inc l			; $56f6
	ldi (hl),a		; $56f7
	ld (hl),$5a		; $56f8
	ld l,$a9		; $56fa
	ld a,(hl)		; $56fc
	ld l,$b3		; $56fd
	ld (hl),a		; $56ff
	call objectSetInvisible		; $5700
	ld a,$2d		; $5703
	ld (wActiveMusic),a		; $5705
	jp playSound		; $5708
	call _ecom_decCounter1		; $570b
	ret nz			; $570e
	ld e,$a9		; $570f
	ld a,(de)		; $5711
	ld c,$08		; $5712
	cp $0a			; $5714
	jr c,_label_0e_149	; $5716
	ld c,$04		; $5718
	cp $10			; $571a
	jr c,_label_0e_149	; $571c
	ld c,$00		; $571e
_label_0e_149:
	call getRandomNumber		; $5720
	and $07			; $5723
	add c			; $5725
	ld hl,$572f		; $5726
	rst_addAToHl			; $5729
	ld a,(hl)		; $572a
	ld e,$84		; $572b
	ld (de),a		; $572d
	ret			; $572e
	ld a,(bc)		; $572f
	ld a,(bc)		; $5730
	dec bc			; $5731
	dec c			; $5732
	ld a,(bc)		; $5733
	ld a,(bc)		; $5734
	ld a,(bc)		; $5735
	ld a,(bc)		; $5736
	dec bc			; $5737
	dec bc			; $5738
	inc c			; $5739
	dec c			; $573a
	ld a,(bc)		; $573b
	dec bc			; $573c
	inc c			; $573d
	dec c			; $573e
	inc e			; $573f
	ld a,(de)		; $5740
	rst_jumpTable			; $5741
	ld c,b			; $5742
	ld d,a			; $5743
	ld d,e			; $5744
	ld d,a			; $5745
	ld (hl),c		; $5746
	ld d,a			; $5747
	call $5abe		; $5748
	inc l			; $574b
	ld (hl),$14		; $574c
	ld l,$90		; $574e
	ld (hl),$28		; $5750
	ret			; $5752
	call _ecom_decCounter1		; $5753
	jp nz,$5b72		; $5756
	ld l,e			; $5759
	inc (hl)		; $575a
	ld l,$90		; $575b
	ld (hl),$50		; $575d
	call _ecom_updateAngleTowardTarget		; $575f
	call getRandomNumber_noPreserveVars		; $5762
	and $03			; $5765
	sub $02			; $5767
	ld b,a			; $5769
	ld e,$89		; $576a
	ld a,(de)		; $576c
	add b			; $576d
	and $1f			; $576e
	ld (de),a		; $5770
	call $5b11		; $5771
	jp nc,$5aff		; $5774
	call _ecom_decCounter1		; $5777
	ld a,(hl)		; $577a
	and $1f			; $577b
	call z,$5b8d		; $577d
	jp $5b72		; $5780
	inc e			; $5783
	ld a,(de)		; $5784
	rst_jumpTable			; $5785
	adc (hl)		; $5786
	ld d,a			; $5787
	and c			; $5788
	ld d,a			; $5789
	rst_jumpTable			; $578a
	ld d,a			; $578b
.DB $e3				; $578c
	ld d,a			; $578d
	call $5abe		; $578e
	inc l			; $5791
	ld (hl),$78		; $5792
	call getRandomNumber_noPreserveVars		; $5794
	and $08			; $5797
	jr nz,_label_0e_150	; $5799
	ld a,$f8		; $579b
_label_0e_150:
	ld e,$b0		; $579d
	ld (de),a		; $579f
	ret			; $57a0
	ld a,(wFrameCounter)		; $57a1
	and $03			; $57a4
	jr nz,_label_0e_151	; $57a6
	call _ecom_decCounter1		; $57a8
	jr z,_label_0e_152	; $57ab
	ld a,(hl)		; $57ad
	and $1f			; $57ae
	ld b,$01		; $57b0
	call z,$5b94		; $57b2
_label_0e_151:
	call $5b78		; $57b5
	jp nc,$5b1d		; $57b8
_label_0e_152:
	ld l,$85		; $57bb
	inc (hl)		; $57bd
	ld l,$90		; $57be
	ld (hl),$50		; $57c0
	call _ecom_updateAngleTowardTarget		; $57c2
	jr _label_0e_154		; $57c5
	call $5b78		; $57c7
	jr c,_label_0e_153	; $57ca
	ld a,($cc7a)		; $57cc
	or a			; $57cf
	jr nz,_label_0e_153	; $57d0
	call $5b11		; $57d2
	jp nc,$5aff		; $57d5
	jp $5b72		; $57d8
_label_0e_153:
	ld l,e			; $57db
	inc (hl)		; $57dc
	call _ecom_updateCardinalAngleAwayFromTarget		; $57dd
_label_0e_154:
	jp enemyAnimate		; $57e0
	call $5b11		; $57e3
	jp nc,$5aff		; $57e6
	call _ecom_decCounter1		; $57e9
	ld a,(hl)		; $57ec
	and $1f			; $57ed
	ld b,$01		; $57ef
	call z,$5b94		; $57f1
	jp $5b72		; $57f4
	inc e			; $57f7
	ld a,(de)		; $57f8
	rst_jumpTable			; $57f9
	ld (bc),a		; $57fa
	ld e,b			; $57fb
	dec c			; $57fc
	ld e,b			; $57fd
	ld e,$58		; $57fe
	ldd (hl),a		; $5800
	ld e,b			; $5801
	call $5abe		; $5802
	inc l			; $5805
	ld (hl),$1c		; $5806
	ld l,$90		; $5808
	ld (hl),$28		; $580a
	ret			; $580c
	call _ecom_decCounter1		; $580d
	jp nz,$5b72		; $5810
	ld (hl),$0c		; $5813
	ld l,e			; $5815
	inc (hl)		; $5816
	ld b,$03		; $5817
	call $5b94		; $5819
	jr _label_0e_155		; $581c
	call _ecom_decCounter1		; $581e
	jr nz,_label_0e_155	; $5821
	ld l,e			; $5823
	inc (hl)		; $5824
	ld l,$89		; $5825
	ld a,(hl)		; $5827
	xor $10			; $5828
	ld (hl),a		; $582a
	ld l,$90		; $582b
	ld (hl),$50		; $582d
_label_0e_155:
	jp enemyAnimate		; $582f
	call $5b11		; $5832
	jp nc,$5aff		; $5835
	jp $5b72		; $5838
	inc e			; $583b
	ld a,(de)		; $583c
	rst_jumpTable			; $583d
	adc (hl)		; $583e
	ld d,a			; $583f
	ld c,d			; $5840
	ld e,b			; $5841
	ld (hl),c		; $5842
	ld e,b			; $5843
	adc a			; $5844
	ld e,b			; $5845
	and l			; $5846
	ld e,b			; $5847
	or l			; $5848
	ld e,b			; $5849
	ld a,(wFrameCounter)		; $584a
	and $03			; $584d
	jr nz,_label_0e_156	; $584f
	call _ecom_decCounter1		; $5851
	jr z,_label_0e_157	; $5854
	ld a,(hl)		; $5856
	and $1f			; $5857
	ld b,$01		; $5859
	call z,$5b94		; $585b
_label_0e_156:
	call $5b78		; $585e
	jp nc,$5b1d		; $5861
_label_0e_157:
	ld l,$85		; $5864
	inc (hl)		; $5866
	ld l,$90		; $5867
	ld (hl),$50		; $5869
	call _ecom_updateAngleTowardTarget		; $586b
_label_0e_158:
	jp enemyAnimate		; $586e
	ld a,($cc7a)		; $5871
	or a			; $5874
	jr z,_label_0e_159	; $5875
	ld h,d			; $5877
	ld l,e			; $5878
	inc (hl)		; $5879
	inc l			; $587a
	ld (hl),$0c		; $587b
	ld l,$90		; $587d
	ld (hl),$78		; $587f
	call _ecom_updateCardinalAngleAwayFromTarget		; $5881
	jr _label_0e_158		; $5884
_label_0e_159:
	call $5b11		; $5886
	jp nc,$5aff		; $5889
	jp $5b72		; $588c
	call _ecom_decCounter1		; $588f
	jp nz,$5b72		; $5892
	ld (hl),$0c		; $5895
	ld l,e			; $5897
	inc (hl)		; $5898
	ld b,$3a		; $5899
	call _ecom_spawnProjectile		; $589b
	ld a,$87		; $589e
	call playSound		; $58a0
	jr _label_0e_158		; $58a3
	call _ecom_decCounter1		; $58a5
	jr nz,_label_0e_158	; $58a8
	ld l,e			; $58aa
	inc (hl)		; $58ab
	ld l,$90		; $58ac
	ld (hl),$46		; $58ae
	call _ecom_updateCardinalAngleAwayFromTarget		; $58b0
	jr _label_0e_158		; $58b3
	call $5b11		; $58b5
	jp nc,$5aff		; $58b8
	jp $5b72		; $58bb
	inc e			; $58be
	ld a,(de)		; $58bf
	rst_jumpTable			; $58c0
	rst_jumpTable			; $58c1
	ld e,b			; $58c2
	sbc $58			; $58c3
	or l			; $58c5
	ld e,b			; $58c6
	ld h,d			; $58c7
	ld l,e			; $58c8
	inc (hl)		; $58c9
	inc l			; $58ca
	ld (hl),$14		; $58cb
	ld l,$90		; $58cd
	ld (hl),$78		; $58cf
	call _ecom_updateCardinalAngleAwayFromTarget		; $58d1
	ld e,$88		; $58d4
	xor a			; $58d6
	ld (de),a		; $58d7
	ld e,$b2		; $58d8
	ld (de),a		; $58da
	jp enemySetAnimation		; $58db
	call _ecom_decCounter1		; $58de
	jp nz,enemyAnimate		; $58e1
	ld l,e			; $58e4
	inc (hl)		; $58e5
	ld l,$a9		; $58e6
	ld a,(hl)		; $58e8
	cp $10			; $58e9
	ret nc			; $58eb
	ld b,$01		; $58ec
	cp $0a			; $58ee
	jr nc,_label_0e_160	; $58f0
	inc b			; $58f2
_label_0e_160:
	ld a,b			; $58f3
	ld l,$b7		; $58f4
	cp (hl)			; $58f6
	ret z			; $58f7
	ld (hl),a		; $58f8
	add $13			; $58f9
	ld c,a			; $58fb
	ld b,$2f		; $58fc
	jp showText		; $58fe
	inc e			; $5901
	ld a,(de)		; $5902
	rst_jumpTable			; $5903
	stop			; $5904
	ld e,c			; $5905
	inc e			; $5906
	ld e,c			; $5907
	ld d,e			; $5908
	ld e,c			; $5909
	ld h,(hl)		; $590a
	ld e,c			; $590b
	ld (hl),e		; $590c
	ld e,c			; $590d
	adc a			; $590e
	ld e,c			; $590f
	call _ecom_decCounter1		; $5910
	ret nz			; $5913
	ld l,e			; $5914
	inc (hl)		; $5915
	ld bc,enemyCodeTable		; $5916
	jp showText		; $5919
	ld b,$02		; $591c
	call checkBEnemySlotsAvailable		; $591e
	jp nz,enemyAnimate		; $5921
	ld h,d			; $5924
	ld l,$85		; $5925
	inc (hl)		; $5927
	ld l,$b4		; $5928
	ld (hl),$02		; $592a
	call objectSetInvisible		; $592c
	call objectCreatePuff		; $592f
	ld b,$75		; $5932
	call _ecom_spawnUncountedEnemyWithSubid01		; $5934
	call $593e		; $5937
	call _ecom_spawnUncountedEnemyWithSubid01		; $593a
	inc a			; $593d
	inc l			; $593e
	ld (hl),a		; $593f
	rrca			; $5940
	swap a			; $5941
	jr nz,_label_0e_161	; $5943
	ld a,$f8		; $5945
_label_0e_161:
	ld l,$b0		; $5947
	ld (hl),a		; $5949
	ld l,$96		; $594a
	ld a,$80		; $594c
	ldi (hl),a		; $594e
	ld (hl),d		; $594f
	jp objectCopyPosition		; $5950
	ld e,$b4		; $5953
	ld a,(de)		; $5955
	or a			; $5956
	jp nz,_ecom_decCounter2		; $5957
	ld h,d			; $595a
	ld l,$85		; $595b
	inc (hl)		; $595d
	inc l			; $595e
	ld (hl),$3c		; $595f
	ld a,$f0		; $5961
	jp playSound		; $5963
	call _ecom_decCounter1		; $5966
	jp nz,_ecom_flickerVisibility		; $5969
	ld (hl),$10		; $596c
	ld l,e			; $596e
	inc (hl)		; $596f
	jp objectSetVisiblec1		; $5970
	call _ecom_decCounter1		; $5973
	jp nz,enemyAnimate		; $5976
	ld l,e			; $5979
	inc (hl)		; $597a
	ld l,$89		; $597b
	ld (hl),$06		; $597d
	ld l,$90		; $597f
	ld (hl),$78		; $5981
	ld bc,$2f17		; $5983
	call checkIsLinkedGame		; $5986
	jr z,_label_0e_162	; $5989
	inc c			; $598b
_label_0e_162:
	jp showText		; $598c
	call checkIsLinkedGame		; $598f
	jr z,_label_0e_163	; $5992
	ld e,$a9		; $5994
	xor a			; $5996
	ld (de),a		; $5997
	ret			; $5998
_label_0e_163:
	ld e,$b8		; $5999
	ld a,(de)		; $599b
	or a			; $599c
	jr nz,_label_0e_164	; $599d
	inc a			; $599f
	ld (de),a		; $59a0
	ld b,$01		; $59a1
	call _ecom_spawnProjectile		; $59a3
_label_0e_164:
	call enemyAnimate		; $59a6
	ld h,d			; $59a9
	ld l,$8e		; $59aa
	ld a,(hl)		; $59ac
	sub $80			; $59ad
	ldi (hl),a		; $59af
	ld a,(hl)		; $59b0
	sbc $00			; $59b1
	ld (hl),a		; $59b3
	call $5b11		; $59b4
	jp c,objectApplySpeed		; $59b7
	call markEnemyAsKilledInRoom		; $59ba
	call decNumEnemies		; $59bd
	ld a,($cc62)		; $59c0
	ld (wActiveMusic),a		; $59c3
	call playSound		; $59c6
	jp enemyDelete		; $59c9
	ld a,(de)		; $59cc
	sub $08			; $59cd
	rst_jumpTable			; $59cf
	call c,$f759		; $59d0
	ld e,c			; $59d3
	ldi a,(hl)		; $59d4
	ld e,d			; $59d5
	ld e,d			; $59d6
	ld e,d			; $59d7
	ld l,l			; $59d8
	ld e,d			; $59d9
	sbc a			; $59da
	ld e,d			; $59db
	ld h,d			; $59dc
	ld l,e			; $59dd
	inc (hl)		; $59de
	ld l,$b0		; $59df
	ld a,(hl)		; $59e1
	and $1f			; $59e2
	ld l,$89		; $59e4
	ld (hl),a		; $59e6
	ld l,$86		; $59e7
	ld (hl),$10		; $59e9
	ld l,$a9		; $59eb
	ld (hl),$01		; $59ed
	ld a,$02		; $59ef
	call enemySetAnimation		; $59f1
	jp objectSetVisiblec1		; $59f4
	call _ecom_decCounter1		; $59f7
	jr z,_label_0e_166	; $59fa
	ld l,$8f		; $59fc
	ldd a,(hl)		; $59fe
	cp $f0			; $59ff
	jr c,_label_0e_165	; $5a01
	ld a,(hl)		; $5a03
	sub $c0			; $5a04
	ldi (hl),a		; $5a06
	ld a,(hl)		; $5a07
	sbc $00			; $5a08
	ld (hl),a		; $5a0a
_label_0e_165:
	call objectApplySpeed		; $5a0b
	jr _label_0e_168		; $5a0e
_label_0e_166:
	ld l,e			; $5a10
	ld (hl),$0a		; $5a11
	ld l,$90		; $5a13
	ld (hl),$14		; $5a15
	ld l,$a4		; $5a17
	set 7,(hl)		; $5a19
	call getRandomNumber_noPreserveVars		; $5a1b
	ld e,$86		; $5a1e
	ld (de),a		; $5a20
	ld a,$07		; $5a21
	call objectGetRelatedObject1Var		; $5a23
	ld (hl),$b4		; $5a26
	jr _label_0e_168		; $5a28
	call $5bd2		; $5a2a
	ld a,$07		; $5a2d
	call objectGetRelatedObject1Var		; $5a2f
	ld a,(hl)		; $5a32
	or a			; $5a33
	jr nz,_label_0e_167	; $5a34
	ld h,d			; $5a36
	ld l,$84		; $5a37
	inc (hl)		; $5a39
	ld l,$86		; $5a3a
	ld (hl),$08		; $5a3c
	ret			; $5a3e
_label_0e_167:
	call $5bb2		; $5a3f
	call objectGetAngleTowardEnemyTarget		; $5a42
	ld b,a			; $5a45
	ld e,$b0		; $5a46
	ld a,(de)		; $5a48
	add b			; $5a49
	and $1f			; $5a4a
	ld e,$89		; $5a4c
	ld (de),a		; $5a4e
	ld a,$02		; $5a4f
	call _ecom_getSideviewAdjacentWallsBitset		; $5a51
	call z,objectApplySpeed		; $5a54
_label_0e_168:
	jp enemyAnimate		; $5a57
	call _ecom_decCounter1		; $5a5a
	ret nz			; $5a5d
	ld l,e			; $5a5e
	inc (hl)		; $5a5f
	ld l,$90		; $5a60
	ld (hl),$50		; $5a62
	ld l,$b5		; $5a64
	ldh a,(<hEnemyTargetY)	; $5a66
	ldi (hl),a		; $5a68
	ldh a,(<hEnemyTargetX)	; $5a69
	ld (hl),a		; $5a6b
	ret			; $5a6c
	ld h,d			; $5a6d
	ld l,$b5		; $5a6e
	call _ecom_readPositionVars		; $5a70
	sub c			; $5a73
	add $08			; $5a74
	cp $11			; $5a76
	jr nc,_label_0e_169	; $5a78
	ldh a,(<hFF8F)	; $5a7a
	sub b			; $5a7c
	add $08			; $5a7d
	cp $11			; $5a7f
	jr nc,_label_0e_169	; $5a81
	ld l,$8f		; $5a83
	ld a,(hl)		; $5a85
	cp $fa			; $5a86
	jr c,_label_0e_169	; $5a88
	ld l,e			; $5a8a
	inc (hl)		; $5a8b
	ld l,$86		; $5a8c
	ld (hl),$14		; $5a8e
	jr _label_0e_168		; $5a90
_label_0e_169:
	ld l,$8f		; $5a92
	ld a,(hl)		; $5a94
	cp $fe			; $5a95
	jr nc,_label_0e_170	; $5a97
	inc (hl)		; $5a99
_label_0e_170:
	call _ecom_moveTowardPosition		; $5a9a
	jr _label_0e_168		; $5a9d
	call _ecom_decCounter1		; $5a9f
	jp z,$5a10		; $5aa2
	ld l,$8f		; $5aa5
	ldd a,(hl)		; $5aa7
	cp $f0			; $5aa8
	jr c,_label_0e_171	; $5aaa
	ld a,(hl)		; $5aac
	sub $c0			; $5aad
	ldi (hl),a		; $5aaf
	ld a,(hl)		; $5ab0
	sbc $00			; $5ab1
	ld (hl),a		; $5ab3
_label_0e_171:
	ld a,$02		; $5ab4
	call _ecom_getSideviewAdjacentWallsBitset		; $5ab6
	call z,objectApplySpeed		; $5ab9
	jr _label_0e_168		; $5abc
	call getRandomNumber_noPreserveVars		; $5abe
	and $07			; $5ac1
	ld b,a			; $5ac3
	add a			; $5ac4
	add b			; $5ac5
	ld hl,$5ae7		; $5ac6
	rst_addAToHl			; $5ac9
	ld e,$8b		; $5aca
	ldh a,(<hCameraY)	; $5acc
	add (hl)		; $5ace
	ld (de),a		; $5acf
	inc hl			; $5ad0
	ld e,$8d		; $5ad1
	ldh a,(<hCameraX)	; $5ad3
	add (hl)		; $5ad5
	ld (de),a		; $5ad6
	inc hl			; $5ad7
	ld e,$89		; $5ad8
	ld a,(hl)		; $5ada
	ld (de),a		; $5adb
	ld h,d			; $5adc
	ld l,$a4		; $5add
	set 7,(hl)		; $5adf
	ld l,$85		; $5ae1
	inc (hl)		; $5ae3
	jp objectSetVisiblec1		; $5ae4
	ld hl,sp+$10		; $5ae7
	stop			; $5ae9
	ld hl,sp-$70		; $5aea
	stop			; $5aec
	stop			; $5aed
	ld hl,sp+$08		; $5aee
	stop			; $5af0
	xor b			; $5af1
	jr _label_0e_175		; $5af2
	ld hl,sp+$08		; $5af4
	ld (hl),b		; $5af6
	xor b			; $5af7
	jr -$78			; $5af8
	stop			; $5afa
	nop			; $5afb
	adc b			; $5afc
	sub b			; $5afd
	nop			; $5afe
	ld h,d			; $5aff
	ld l,$84		; $5b00
	ld (hl),$09		; $5b02
	inc l			; $5b04
	ld (hl),$00		; $5b05
	inc l			; $5b07
	ld (hl),$5a		; $5b08
	ld l,$a4		; $5b0a
	res 7,(hl)		; $5b0c
	jp objectSetInvisible		; $5b0e
	ld e,$8b		; $5b11
	ld a,(de)		; $5b13
	cp $b8			; $5b14
	ret nc			; $5b16
	ld e,$8d		; $5b17
	ld a,(de)		; $5b19
	cp $f0			; $5b1a
	ret			; $5b1c
	ldh a,(<hCameraY)	; $5b1d
	add $44			; $5b1f
	ld b,a			; $5b21
	ldh a,(<hCameraX)	; $5b22
	add $50			; $5b24
	ld c,a			; $5b26
	push bc			; $5b27
	call objectGetRelativeAngle		; $5b28
	pop bc			; $5b2b
	ld h,a			; $5b2c
	ld e,$8b		; $5b2d
	ld a,(de)		; $5b2f
	sub b			; $5b30
	jr nc,_label_0e_172	; $5b31
	cpl			; $5b33
	inc a			; $5b34
_label_0e_172:
	ld b,a			; $5b35
	cp $3e			; $5b36
	ld a,h			; $5b38
	jr nc,_label_0e_174	; $5b39
	ld e,$8d		; $5b3b
	ld a,(de)		; $5b3d
	sub c			; $5b3e
	jr nc,_label_0e_173	; $5b3f
	cpl			; $5b41
	inc a			; $5b42
_label_0e_173:
	ld c,a			; $5b43
	cp $3e			; $5b44
	ld a,h			; $5b46
	jr nc,_label_0e_174	; $5b47
	ld a,b			; $5b49
	add c			; $5b4a
	sub $42			; $5b4b
	cp $08			; $5b4d
	jr c,_label_0e_175	; $5b4f
	rlca			; $5b51
	ld a,h			; $5b52
	jr nc,_label_0e_174	; $5b53
	xor $10			; $5b55
_label_0e_174:
	push hl			; $5b57
	ld e,$89		; $5b58
	ld (de),a		; $5b5a
	ld e,$90		; $5b5b
	ld a,$0a		; $5b5d
	ld (de),a		; $5b5f
	call objectApplySpeed		; $5b60
	pop hl			; $5b63
_label_0e_175:
	ld e,$b0		; $5b64
	ld a,(de)		; $5b66
	add h			; $5b67
	and $1f			; $5b68
	ld e,$89		; $5b6a
	ld (de),a		; $5b6c
	ld e,$90		; $5b6d
	ld a,$23		; $5b6f
	ld (de),a		; $5b71
	call objectApplySpeed		; $5b72
	jp enemyAnimate		; $5b75
	ld h,d			; $5b78
	ld l,$8b		; $5b79
	ldh a,(<hEnemyTargetY)	; $5b7b
	sub (hl)		; $5b7d
	add $1e			; $5b7e
	cp $3d			; $5b80
	ret nc			; $5b82
	ld l,$8d		; $5b83
	ldh a,(<hEnemyTargetX)	; $5b85
	sub (hl)		; $5b87
	add $1e			; $5b88
	cp $3d			; $5b8a
	ret			; $5b8c
	call getRandomNumber_noPreserveVars		; $5b8d
	and $01			; $5b90
	inc a			; $5b92
	ld b,a			; $5b93
	call getFreePartSlot		; $5b94
	ret nz			; $5b97
	ld (hl),$3a		; $5b98
	inc l			; $5b9a
	ld (hl),b		; $5b9b
	ld l,$d7		; $5b9c
	ld (hl),d		; $5b9e
	dec l			; $5b9f
	ld (hl),$80		; $5ba0
	call objectCopyPosition		; $5ba2
	ld a,$87		; $5ba5
	call playSound		; $5ba7
	ld e,$88		; $5baa
	ld a,$01		; $5bac
	ld (de),a		; $5bae
	jp enemySetAnimation		; $5baf
	ld h,d			; $5bb2
	ld l,$8b		; $5bb3
	ldh a,(<hEnemyTargetY)	; $5bb5
	sub (hl)		; $5bb7
	add $0c			; $5bb8
	cp $19			; $5bba
	ret nc			; $5bbc
	ld l,$8d		; $5bbd
	ldh a,(<hEnemyTargetX)	; $5bbf
	sub (hl)		; $5bc1
	add $0c			; $5bc2
	cp $19			; $5bc4
	ret nc			; $5bc6
	call objectGetAngleTowardEnemyTarget		; $5bc7
	xor $10			; $5bca
	ld c,a			; $5bcc
	ld b,$50		; $5bcd
	jp _ecom_applyGivenVelocity		; $5bcf
	call _ecom_decCounter1		; $5bd2
	ld a,(hl)		; $5bd5
	and $1c			; $5bd6
	rrca			; $5bd8
	rrca			; $5bd9
	ld hl,$5be3		; $5bda
	rst_addAToHl			; $5bdd
	ld e,$8f		; $5bde
	ld a,(hl)		; $5be0
	ld (de),a		; $5be1
	ret			; $5be2
	ld a,($ff00+$f1)	; $5be3
	ld a,($ff00+$ef)	; $5be5
	xor $ed			; $5be7
	xor $ef			; $5be9

; ==============================================================================
; ENEMYID_POE_SISTERS_1
; ==============================================================================
enemyCode76:
	jr z,_label_0e_177	; $5beb
	sub $03			; $5bed
	ret c			; $5bef
	jr nz,_label_0e_176	; $5bf0
	ld bc,$0a07		; $5bf2
	jp $5f7e		; $5bf5
_label_0e_176:
	call $5fc2		; $5bf8
	ret z			; $5bfb
_label_0e_177:
	call $604b		; $5bfc
	call $602e		; $5bff
	ld e,$84		; $5c02
	ld a,(de)		; $5c04
	rst_jumpTable			; $5c05
	ldi a,(hl)		; $5c06
	ld e,h			; $5c07
	sub a			; $5c08
	ld e,h			; $5c09
	sub a			; $5c0a
	ld e,h			; $5c0b
	sub a			; $5c0c
	ld e,h			; $5c0d
	sub a			; $5c0e
	ld e,h			; $5c0f
	add (hl)		; $5c10
	ld e,h			; $5c11
	sub a			; $5c12
	ld e,h			; $5c13
	sub a			; $5c14
	ld e,h			; $5c15
	sbc b			; $5c16
	ld e,h			; $5c17
	xor c			; $5c18
	ld e,h			; $5c19
	or (hl)			; $5c1a
	ld e,h			; $5c1b
	push de			; $5c1c
	ld e,h			; $5c1d
	ld a,($ff00+$5c)	; $5c1e
	ei			; $5c20
	ld e,h			; $5c21
	inc c			; $5c22
	ld e,l			; $5c23
	ei			; $5c24
	ld e,h			; $5c25
	inc l			; $5c26
	ld e,l			; $5c27
	ld e,b			; $5c28
	ld e,l			; $5c29
	ld a,$76		; $5c2a
	ld ($cc1c),a		; $5c2c
	call getRandomNumber_noPreserveVars		; $5c2f
	ld e,$b8		; $5c32
	ld (de),a		; $5c34
	ld h,d			; $5c35
	ld l,$88		; $5c36
	ld (hl),$ff		; $5c38
	ld l,$90		; $5c3a
	ld (hl),$46		; $5c3c
	ld l,$82		; $5c3e
	ld a,(hl)		; $5c40
	or a			; $5c41
	jr z,_label_0e_180	; $5c42
	call getFreePartSlot		; $5c44
	ret nz			; $5c47
	ld (hl),$08		; $5c48
	ld l,$c6		; $5c4a
	ld a,$04		; $5c4c
	ldi (hl),a		; $5c4e
	ld (hl),a		; $5c4f
	ld ($cca9),a		; $5c50
	ld hl,$d081		; $5c53
_label_0e_178:
	ld a,(hl)		; $5c56
	cp $7e			; $5c57
	jr z,_label_0e_179	; $5c59
	inc h			; $5c5b
	jr _label_0e_178		; $5c5c
_label_0e_179:
	ld e,$96		; $5c5e
	ld l,e			; $5c60
	ld a,$80		; $5c61
	ld (de),a		; $5c63
	ldi (hl),a		; $5c64
	inc e			; $5c65
	ld a,h			; $5c66
	ld (de),a		; $5c67
	ld (hl),d		; $5c68
	ld h,d			; $5c69
	jp $5dd5		; $5c6a
_label_0e_180:
	ld l,$84		; $5c6d
	ld (hl),$0b		; $5c6f
	ld l,$a5		; $5c71
	ld (hl),$5c		; $5c73
	ld l,$86		; $5c75
	ld (hl),$3c		; $5c77
	ld a,$01		; $5c79
	ld ($cc17),a		; $5c7b
	call objectSetVisible82		; $5c7e
	ld a,$02		; $5c81
	jp enemySetAnimation		; $5c83
	call _ecom_galeSeedEffect		; $5c86
	jp nc,enemyDelete		; $5c89
	ld e,$87		; $5c8c
	ld a,(de)		; $5c8e
	dec a			; $5c8f
	ret nz			; $5c90
	ld bc,$0a08		; $5c91
	jp showText		; $5c94
	ret			; $5c97
	ld a,(wcc93)		; $5c98
	or a			; $5c9b
	ret nz			; $5c9c
	inc a			; $5c9d
	ld ($cca4),a		; $5c9e
	ld h,d			; $5ca1
	ld l,e			; $5ca2
	inc (hl)		; $5ca3
	ld l,$86		; $5ca4
	ld (hl),$2d		; $5ca6
	ret			; $5ca8
	call _ecom_decCounter1		; $5ca9
	jp nz,_ecom_flickerVisibility		; $5cac
	ld (hl),$1f		; $5caf
	ld l,e			; $5cb1
	inc (hl)		; $5cb2
	jp objectSetVisible82		; $5cb3
	call _ecom_decCounter1		; $5cb6
	jr z,_label_0e_181	; $5cb9
	ld a,(hl)		; $5cbb
	dec a			; $5cbc
	jr nz,_label_0e_184	; $5cbd
	xor a			; $5cbf
	ld ($cca4),a		; $5cc0
	ld bc,$0a05		; $5cc3
	jp showText		; $5cc6
_label_0e_181:
	ld (hl),$2d		; $5cc9
	ld l,e			; $5ccb
	inc (hl)		; $5ccc
	ld a,$2d		; $5ccd
	ld (wActiveMusic),a		; $5ccf
	jp playSound		; $5cd2
	call _ecom_decCounter1		; $5cd5
	jp nz,_ecom_flickerVisibility		; $5cd8
	ld (hl),$10		; $5cdb
	ld l,e			; $5cdd
	inc (hl)		; $5cde
	ld l,$b7		; $5cdf
	bit 1,(hl)		; $5ce1
	jr z,_label_0e_182	; $5ce3
	res 1,(hl)		; $5ce5
	ld l,$86		; $5ce7
	ld a,(hl)		; $5ce9
	add $2c			; $5cea
	ld (hl),a		; $5cec
_label_0e_182:
	jp objectSetInvisible		; $5ced
	call _ecom_decCounter1		; $5cf0
	ret nz			; $5cf3
	ld (hl),$18		; $5cf4
	ld l,e			; $5cf6
	inc (hl)		; $5cf7
	jp $5e45		; $5cf8
	call _ecom_decCounter1		; $5cfb
	jp nz,_ecom_flickerVisibility		; $5cfe
	ld (hl),$30		; $5d01
	ld l,e			; $5d03
	inc (hl)		; $5d04
	ld l,$a4		; $5d05
	set 7,(hl)		; $5d07
	jp objectSetVisible82		; $5d09
	call _ecom_decCounter1		; $5d0c
	jp z,$5f3b		; $5d0f
	ld a,(hl)		; $5d12
	and $07			; $5d13
	jr nz,_label_0e_183	; $5d15
	ld l,$89		; $5d17
	ld e,$b1		; $5d19
	ld a,(de)		; $5d1b
	add (hl)		; $5d1c
	and $1f			; $5d1d
	ld (hl),a		; $5d1f
	call _ecom_updateAnimationFromAngle		; $5d20
_label_0e_183:
	call $5f49		; $5d23
	call objectApplySpeed		; $5d26
_label_0e_184:
	jp enemyAnimate		; $5d29
	ld h,d			; $5d2c
	ld l,$b4		; $5d2d
	call _ecom_readPositionVars		; $5d2f
	sub c			; $5d32
	add $0c			; $5d33
	cp $19			; $5d35
	jr nc,_label_0e_185	; $5d37
	ldh a,(<hFF8F)	; $5d39
	sub b			; $5d3b
	add $07			; $5d3c
	cp $0f			; $5d3e
	jr nc,_label_0e_185	; $5d40
	ld l,e			; $5d42
	inc (hl)		; $5d43
	ld l,$89		; $5d44
	ld a,(hl)		; $5d46
	and $10			; $5d47
	swap a			; $5d49
	add $04			; $5d4b
	ld l,$88		; $5d4d
	ld (hl),a		; $5d4f
	jp enemySetAnimation		; $5d50
_label_0e_185:
	call _ecom_moveTowardPosition		; $5d53
	jr _label_0e_184		; $5d56
	call enemyAnimate		; $5d58
	ld e,$a1		; $5d5b
	ld a,(de)		; $5d5d
	inc a			; $5d5e
	jp z,$5f3b		; $5d5f
	sub $02			; $5d62
	ret nz			; $5d64
	call $5f54		; $5d65
	ret nz			; $5d68
	ld e,$a1		; $5d69
	ld a,$02		; $5d6b
	ld (de),a		; $5d6d
	ret			; $5d6e

; ==============================================================================
; ENEMYID_POE_SISTERS_2
; ==============================================================================
enemyCode7e:
	jr z,_label_0e_187	; $5d6f
	sub $03			; $5d71
	ret c			; $5d73
	jr nz,_label_0e_186	; $5d74
	ld bc,$0a06		; $5d76
	jp $5f7e		; $5d79
_label_0e_186:
	call $5fc2		; $5d7c
	ret z			; $5d7f
_label_0e_187:
	call $5d86		; $5d80
	jp $5fec		; $5d83
	call $604b		; $5d86
	call $602e		; $5d89
	ld e,$84		; $5d8c
	ld a,(de)		; $5d8e
	rst_jumpTable			; $5d8f
	or h			; $5d90
	ld e,l			; $5d91
	sub a			; $5d92
	ld e,h			; $5d93
	sub a			; $5d94
	ld e,h			; $5d95
	sub a			; $5d96
	ld e,h			; $5d97
	sub a			; $5d98
	ld e,h			; $5d99
	add (hl)		; $5d9a
	ld e,h			; $5d9b
	sub a			; $5d9c
	ld e,h			; $5d9d
	sub a			; $5d9e
	ld e,h			; $5d9f
	sbc b			; $5da0
	ld e,h			; $5da1
	xor c			; $5da2
	ld e,h			; $5da3
	xor $5d			; $5da4
	push de			; $5da6
	ld e,h			; $5da7
	ld hl,sp+$5d		; $5da8
	ld b,$5e		; $5daa
	add hl,sp		; $5dac
	ld e,(hl)		; $5dad
	ld b,$5e		; $5dae
	inc l			; $5db0
	ld e,l			; $5db1
	ld e,b			; $5db2
	ld e,l			; $5db3
	ld a,$7e		; $5db4
	ld ($cc1c),a		; $5db6
	ld b,$3b		; $5db9
	call _ecom_spawnProjectile		; $5dbb
	ret nz			; $5dbe
	call getRandomNumber_noPreserveVars		; $5dbf
	ld e,$b8		; $5dc2
	ld (de),a		; $5dc4
	ld h,d			; $5dc5
	ld l,$88		; $5dc6
	ld (hl),$ff		; $5dc8
	ld l,$90		; $5dca
	ld (hl),$3c		; $5dcc
	ld e,$82		; $5dce
	ld a,(de)		; $5dd0
	or a			; $5dd1
	jp z,$5c6d		; $5dd2
	ld l,$84		; $5dd5
	ld (hl),$08		; $5dd7
	ld l,$a9		; $5dd9
	ld a,(hl)		; $5ddb
	add $06			; $5ddc
	ld (hl),a		; $5dde
	ld l,$b6		; $5ddf
	ld (hl),a		; $5de1
	ld a,$76		; $5de2
	ld b,$00		; $5de4
	call _enemyBoss_initializeRoom		; $5de6
	ld a,$03		; $5de9
	jp enemySetAnimation		; $5deb
	call _ecom_decCounter1		; $5dee
	jr nz,_label_0e_191	; $5df1
	ld (hl),$2d		; $5df3
	ld l,e			; $5df5
	inc (hl)		; $5df6
	ret			; $5df7
	call _ecom_decCounter1		; $5df8
	ret nz			; $5dfb
	ld (hl),$30		; $5dfc
	ld l,e			; $5dfe
	inc (hl)		; $5dff
	call $5e7b		; $5e00
	jp objectSetVisible82		; $5e03
	call _ecom_decCounter1		; $5e06
	jr nz,_label_0e_188	; $5e09
	ld (hl),$30		; $5e0b
	ld l,e			; $5e0d
	inc (hl)		; $5e0e
	ld l,$a4		; $5e0f
	set 7,(hl)		; $5e11
	ld l,$b9		; $5e13
	ld e,$8b		; $5e15
	ldi a,(hl)		; $5e17
	ld (de),a		; $5e18
	ld e,$8d		; $5e19
	ld a,(hl)		; $5e1b
	ld (de),a		; $5e1c
	ret			; $5e1d
_label_0e_188:
	ld a,(hl)		; $5e1e
	and $3c			; $5e1f
	rrca			; $5e21
	rrca			; $5e22
	bit 1,(hl)		; $5e23
	jr z,_label_0e_189	; $5e25
	cpl			; $5e27
	inc a			; $5e28
_label_0e_189:
	ld l,$88		; $5e29
	bit 0,(hl)		; $5e2b
	ld l,$b9		; $5e2d
	ld e,$8b		; $5e2f
	jr nz,_label_0e_190	; $5e31
	inc l			; $5e33
	ld e,$8d		; $5e34
_label_0e_190:
	add (hl)		; $5e36
	ld (de),a		; $5e37
	ret			; $5e38
	call _ecom_decCounter1		; $5e39
	jp z,$5f3b		; $5e3c
	call objectApplySpeed		; $5e3f
_label_0e_191:
	jp enemyAnimate		; $5e42
	ld bc,$5e6b		; $5e45
	call $5ea3		; $5e48
	jr z,_label_0e_194	; $5e4b
	ldh a,(<hEnemyTargetY)	; $5e4d
	cp $58			; $5e4f
_label_0e_192:
	ld a,$fe		; $5e51
	ld c,$00		; $5e53
	jr c,_label_0e_193	; $5e55
	ld a,$02		; $5e57
	inc c			; $5e59
_label_0e_193:
	ld e,$b1		; $5e5a
	ld (de),a		; $5e5c
	ld a,b			; $5e5d
	add c			; $5e5e
	ld hl,$5e73		; $5e5f
	rst_addAToHl			; $5e62
	ld b,(hl)		; $5e63
_label_0e_194:
	ld e,$89		; $5e64
	ld a,b			; $5e66
	ld (de),a		; $5e67
	jp _ecom_updateAnimationFromAngle		; $5e68
	ld ($ff00+$20),a	; $5e6b
	jr nz,$20		; $5e6d
	jr nz,_label_0e_192	; $5e6f
	ld ($ff00+$e0),a	; $5e71
	jr _label_0e_195		; $5e73
	nop			; $5e75
	jr $08			; $5e76
	nop			; $5e78
	stop			; $5e79
	ld ($9b01),sp		; $5e7a
	ld e,(hl)		; $5e7d
	call $5ea3		; $5e7e
	jr z,_label_0e_196	; $5e81
	ld a,b			; $5e83
	add a			; $5e84
_label_0e_195:
	add a			; $5e85
	xor $10			; $5e86
	ld b,a			; $5e88
_label_0e_196:
	ld e,$89		; $5e89
	ld a,b			; $5e8b
	ld (de),a		; $5e8c
	ld h,d			; $5e8d
	ld l,$b9		; $5e8e
	ld e,$8b		; $5e90
	ld a,(de)		; $5e92
	ldi (hl),a		; $5e93
	ld e,$8d		; $5e94
	ld a,(de)		; $5e96
	ld (hl),a		; $5e97
	jp _ecom_updateAnimationFromAngle		; $5e98
	ret c			; $5e9b
	nop			; $5e9c
	nop			; $5e9d
	jr z,_label_0e_198	; $5e9e
	nop			; $5ea0
	nop			; $5ea1
	ret c			; $5ea2
	push bc			; $5ea3
	ld e,$82		; $5ea4
	ld a,(de)		; $5ea6
	or a			; $5ea7
	jr z,_label_0e_199	; $5ea8
	ld e,$b2		; $5eaa
	ld a,(de)		; $5eac
	inc a			; $5ead
	and $0f			; $5eae
	ld (de),a		; $5eb0
	ld hl,$5f35		; $5eb1
	call checkFlag		; $5eb4
	jr z,_label_0e_199	; $5eb7
	call getRandomNumber_noPreserveVars		; $5eb9
	and $03			; $5ebc
	ld b,a			; $5ebe
	ld c,$05		; $5ebf
_label_0e_197:
	dec c			; $5ec1
	jr z,_label_0e_199	; $5ec2
	ld a,b			; $5ec4
	inc a			; $5ec5
	and $03			; $5ec6
_label_0e_198:
	ld b,a			; $5ec8
	ld hl,$5f37		; $5ec9
	rst_addAToHl			; $5ecc
	ld l,(hl)		; $5ecd
	ld h,$cf		; $5ece
	ld a,(hl)		; $5ed0
	cp $09			; $5ed1
	jr nz,_label_0e_197	; $5ed3
	ld (hl),$08		; $5ed5
	ld c,l			; $5ed7
	ld e,$b3		; $5ed8
	ld a,l			; $5eda
	ld (de),a		; $5edb
	and $06			; $5edc
	pop hl			; $5ede
	rst_addAToHl			; $5edf
	ld e,$b4		; $5ee0
	ld a,c			; $5ee2
	and $f0			; $5ee3
	add $08			; $5ee5
	ld (de),a		; $5ee7
	ld e,$8b		; $5ee8
	add (hl)		; $5eea
	ld (de),a		; $5eeb
	ld e,$b5		; $5eec
	inc hl			; $5eee
	ld a,c			; $5eef
	and $0f			; $5ef0
	swap a			; $5ef2
	add $08			; $5ef4
	ld (de),a		; $5ef6
	ld e,$8d		; $5ef7
	add (hl)		; $5ef9
	ld (de),a		; $5efa
	ld h,d			; $5efb
	ld l,$84		; $5efc
	ld (hl),$0f		; $5efe
	ld l,$b4		; $5f00
	call _ecom_readPositionVars		; $5f02
	call objectGetRelativeAngleWithTempVars		; $5f05
	ld b,a			; $5f08
	xor a			; $5f09
	ret			; $5f0a
_label_0e_199:
	call getRandomNumber_noPreserveVars		; $5f0b
	and $06			; $5f0e
	ld b,a			; $5f10
	pop hl			; $5f11
	push hl			; $5f12
	rst_addAToHl			; $5f13
	ldh a,(<hEnemyTargetY)	; $5f14
	add (hl)		; $5f16
	cp $b0			; $5f17
	jr nc,_label_0e_199	; $5f19
	ld e,$8b		; $5f1b
	ld (de),a		; $5f1d
	inc hl			; $5f1e
	ldh a,(<hEnemyTargetX)	; $5f1f
	ld c,a			; $5f21
	add (hl)		; $5f22
	cp $f0			; $5f23
	jr nc,_label_0e_199	; $5f25
	ld e,$8d		; $5f27
	ld (de),a		; $5f29
	sub c			; $5f2a
	jr nc,_label_0e_200	; $5f2b
	cpl			; $5f2d
	inc a			; $5f2e
_label_0e_200:
	rlca			; $5f2f
	jr c,_label_0e_199	; $5f30
	pop hl			; $5f32
	or d			; $5f33
	ret			; $5f34
	ld l,d			; $5f35
	or l			; $5f36
	ldd a,(hl)		; $5f37
	ld a,d			; $5f38
	ld (hl),h		; $5f39
	inc (hl)		; $5f3a
	ld h,d			; $5f3b
	ld l,$84		; $5f3c
	ld (hl),$0b		; $5f3e
	ld l,$a4		; $5f40
	res 7,(hl)		; $5f42
	ld l,$86		; $5f44
	ld (hl),$18		; $5f46
	ret			; $5f48
	ld e,$86		; $5f49
	ld a,(de)		; $5f4b
	and $07			; $5f4c
	ret nz			; $5f4e
	ld b,$3c		; $5f4f
	jp _ecom_spawnProjectile		; $5f51
	call getFreePartSlot		; $5f54
	ret nz			; $5f57
	ld (hl),$06		; $5f58
	ld e,$b3		; $5f5a
	ld a,(de)		; $5f5c
	and $f0			; $5f5d
	add $08			; $5f5f
	ld l,$cb		; $5f61
	ldi (hl),a		; $5f63
	ld a,(de)		; $5f64
	and $0f			; $5f65
	swap a			; $5f67
	add $08			; $5f69
	inc l			; $5f6b
	ld (hl),a		; $5f6c
	ld hl,$cca9		; $5f6d
	ld a,(hl)		; $5f70
	or a			; $5f71
	jr z,_label_0e_201	; $5f72
	dec (hl)		; $5f74
_label_0e_201:
	ld a,(de)		; $5f75
	ld c,a			; $5f76
	ld a,$08		; $5f77
	call setTile		; $5f79
	xor a			; $5f7c
	ret			; $5f7d
	ld e,$82		; $5f7e
	ld a,(de)		; $5f80
	or a			; $5f81
	jr z,_label_0e_203	; $5f82
	ld e,$a4		; $5f84
	ld a,(de)		; $5f86
	or a			; $5f87
	jr z,_label_0e_202	; $5f88
	ld a,($cba0)		; $5f8a
	or a			; $5f8d
	ret nz			; $5f8e
	call showText		; $5f8f
	call objectSetInvisible		; $5f92
_label_0e_202:
	ld a,$00		; $5f95
	call objectGetRelatedObject1Var		; $5f97
	ld a,(hl)		; $5f9a
	or a			; $5f9b
	jp z,_enemyBoss_dead		; $5f9c
	jp enemyDie_withoutItemDrop		; $5f9f
_label_0e_203:
	ld e,$a4		; $5fa2
	ld a,(de)		; $5fa4
	or a			; $5fa5
	jr z,_label_0e_205	; $5fa6
	xor a			; $5fa8
	ld (de),a		; $5fa9
	ld bc,$0a04		; $5faa
	ld e,$81		; $5fad
	ld a,(de)		; $5faf
	cp $76			; $5fb0
	jr z,_label_0e_204	; $5fb2
	ld c,$02		; $5fb4
_label_0e_204:
	jp showText		; $5fb6
_label_0e_205:
	call objectCreatePuff		; $5fb9
	call decNumEnemies		; $5fbc
	jp enemyDelete		; $5fbf
	ld h,d			; $5fc2
	ld l,$a9		; $5fc3
	ld a,(hl)		; $5fc5
	ld l,$b6		; $5fc6
	cp (hl)			; $5fc8
	ret z			; $5fc9
	ld (hl),a		; $5fca
	ld l,$b7		; $5fcb
	set 1,(hl)		; $5fcd
	ld e,$84		; $5fcf
	ld a,(de)		; $5fd1
	cp $0f			; $5fd2
	ccf			; $5fd4
	ret nc			; $5fd5
	ld e,$a1		; $5fd6
	ld a,(de)		; $5fd8
	cp $02			; $5fd9
	jr z,_label_0e_206	; $5fdb
	ld l,$b3		; $5fdd
	ld l,(hl)		; $5fdf
	ld h,$cf		; $5fe0
	ld (hl),$09		; $5fe2
_label_0e_206:
	call $5f3b		; $5fe4
	ld e,$a9		; $5fe7
	ld a,(de)		; $5fe9
	or a			; $5fea
	ret			; $5feb
	call objectGetAngleTowardEnemyTarget		; $5fec
	ld b,a			; $5fef
	ld e,$88		; $5ff0
	ld a,(de)		; $5ff2
	cp $04			; $5ff3
	jr c,_label_0e_207	; $5ff5
	sub $04			; $5ff7
	add a			; $5ff9
	inc a			; $5ffa
_label_0e_207:
	add a			; $5ffb
	add a			; $5ffc
	ld hl,$601e		; $5ffd
	rst_addAToHl			; $6000
	ld a,b			; $6001
	call checkFlag		; $6002
	ld h,d			; $6005
	ld l,$b7		; $6006
	ld e,$a4		; $6008
	jr z,_label_0e_208	; $600a
	ld a,(de)		; $600c
	and $80			; $600d
	or $7e			; $600f
	ld (de),a		; $6011
	res 2,(hl)		; $6012
	ret			; $6014
_label_0e_208:
	ld a,(de)		; $6015
	and $80			; $6016
	or $76			; $6018
	ld (de),a		; $601a
	set 2,(hl)		; $601b
	ret			; $601d
	rra			; $601e
	nop			; $601f
	nop			; $6020
	nop			; $6021
	nop			; $6022
	rra			; $6023
	nop			; $6024
	nop			; $6025
	nop			; $6026
	nop			; $6027
	rra			; $6028
	nop			; $6029
	nop			; $602a
	nop			; $602b
	ld a,($ff00+$01)	; $602c
	ld h,d			; $602e
	ld l,$84		; $602f
	ld a,(hl)		; $6031
	cp $08			; $6032
	ret c			; $6034
	ld l,$b8		; $6035
	dec (hl)		; $6037
	ld a,(hl)		; $6038
	and $18			; $6039
	swap a			; $603b
	rlca			; $603d
	ld hl,$6047		; $603e
	rst_addAToHl			; $6041
	ld e,$8f		; $6042
	ld a,(hl)		; $6044
	ld (de),a		; $6045
	ret			; $6046
	rst $38			; $6047
	cp $fd			; $6048
	cp $1e			; $604a
	add d			; $604c
	ld a,(de)		; $604d
	or a			; $604e
	ret z			; $604f
	ld h,d			; $6050
	ld l,$b7		; $6051
	ld a,($cca9)		; $6053
	or a			; $6056
	jr z,_label_0e_209	; $6057
	res 0,(hl)		; $6059
	ret			; $605b
_label_0e_209:
	bit 0,(hl)		; $605c
	jr nz,_label_0e_210	; $605e
	set 0,(hl)		; $6060
	ld l,$b0		; $6062
	ld (hl),$18		; $6064
_label_0e_210:
	ld l,$b0		; $6066
	dec (hl)		; $6068
	ret nz			; $6069
	ld a,($cc34)		; $606a
	or a			; $606d
	ret nz			; $606e
	ld a,($cc67)		; $606f
	or a			; $6072
	ret nz			; $6073
	ld a,$8d		; $6074
	call playSound		; $6076
	ld hl,$607f		; $6079
	jp setWarpDestVariables		; $607c
	add l			; $607f
	ld e,e			; $6080
	nop			; $6081
	ld d,a			; $6082
	inc bc			; $6083

; ==============================================================================
; ENEMYID_FRYPOLAR
; ==============================================================================
enemyCode77:
	jr z,_label_0e_212	; $6084
	sub $03			; $6086
	ret c			; $6088
	jp z,_enemyBoss_dead		; $6089
	dec a			; $608c
	jp nz,_ecom_updateKnockbackNoSolidity		; $608d
	ld e,$b2		; $6090
	ld a,(de)		; $6092
	or a			; $6093
	jr nz,_label_0e_212	; $6094
	ld e,$aa		; $6096
	ld a,(de)		; $6098
	cp $9a			; $6099
	jr z,_label_0e_211	; $609b
	cp $9b			; $609d
	jr nz,_label_0e_212	; $609f
	ld e,$82		; $60a1
	ld a,(de)		; $60a3
	or a			; $60a4
	jr z,_label_0e_212	; $60a5
	ld a,$63		; $60a7
	call playSound		; $60a9
	ld h,d			; $60ac
	ld l,$ab		; $60ad
	ld (hl),$3c		; $60af
	ld l,$a9		; $60b1
	dec (hl)		; $60b3
	jr nz,_label_0e_211	; $60b4
	ld l,$a4		; $60b6
	res 7,(hl)		; $60b8
_label_0e_211:
	ld e,$b2		; $60ba
	ld a,$1e		; $60bc
	ld (de),a		; $60be
	ld a,$83		; $60bf
	call playSound		; $60c1
_label_0e_212:
	call $6257		; $60c4
	call $6273		; $60c7
	call _ecom_getSubidAndCpStateTo08		; $60ca
	cp $0a			; $60cd
	jr nc,$15		; $60cf
	rst_jumpTable			; $60d1
	rst $28			; $60d2
	ld h,b			; $60d3
	inc b			; $60d4
	ld h,c			; $60d5
	inc b			; $60d6
	ld h,c			; $60d7
	inc b			; $60d8
	ld h,c			; $60d9
	inc b			; $60da
	ld h,c			; $60db
	inc b			; $60dc
	ld h,c			; $60dd
	inc b			; $60de
	ld h,c			; $60df
	inc b			; $60e0
	ld h,c			; $60e1
	dec b			; $60e2
	ld h,c			; $60e3
	jp z,$cd61		; $60e4
	or c			; $60e7
	ld h,d			; $60e8
	ld a,b			; $60e9
	rst_jumpTable			; $60ea
.DB $d3				; $60eb
	ld h,c			; $60ec
	rra			; $60ed
	ld h,d			; $60ee
	ld bc,$010c		; $60ef
	call _enemyBoss_spawnShadow		; $60f2
	ret nz			; $60f5
	call _ecom_setSpeedAndState8		; $60f6
	ld l,$bf		; $60f9
	set 5,(hl)		; $60fb
	ld b,$00		; $60fd
	ld a,$77		; $60ff
	jp _enemyBoss_initializeRoom		; $6101
	ret			; $6104
	inc e			; $6105
	ld a,(de)		; $6106
	rst_jumpTable			; $6107
	stop			; $6108
	ld h,c			; $6109
	dec de			; $610a
	ld h,c			; $610b
	adc c			; $610c
	ld h,c			; $610d
	sbc a			; $610e
	ld h,c			; $610f
	ld a,(wcc93)		; $6110
	or a			; $6113
	ret nz			; $6114
	inc a			; $6115
	ld (de),a		; $6116
	ld ($cca4),a		; $6117
	ret			; $611a
	call _ecom_decCounter2		; $611b
	ret nz			; $611e
	ld b,$02		; $611f
	call checkBPartSlotsAvailable		; $6121
	ret nz			; $6124
	ld e,$86		; $6125
	ld a,(de)		; $6127
	ld hl,$6169		; $6128
	rst_addDoubleIndex			; $612b
	ldi a,(hl)		; $612c
	ld c,(hl)		; $612d
	ld b,a			; $612e
	call getFreePartSlot		; $612f
	ld (hl),$3d		; $6132
	inc l			; $6134
	ld (hl),$03		; $6135
	inc l			; $6137
	inc (hl)		; $6138
	ld l,$cb		; $6139
	ld (hl),b		; $613b
	ld l,$cd		; $613c
	ld (hl),c		; $613e
	call getFreePartSlot		; $613f
	ld (hl),$3e		; $6142
	ld l,$c3		; $6144
	inc (hl)		; $6146
	ld l,$cb		; $6147
	ld a,$58		; $6149
	sub b			; $614b
	add $58			; $614c
	ldi (hl),a		; $614e
	inc l			; $614f
	ld a,$78		; $6150
	sub c			; $6152
	add $78			; $6153
	ld (hl),a		; $6155
	ld l,$d6		; $6156
	ld a,$80		; $6158
	ldi (hl),a		; $615a
	ld (hl),d		; $615b
	ld h,d			; $615c
	ld l,$87		; $615d
	ld (hl),$0f		; $615f
	dec l			; $6161
	inc (hl)		; $6162
	ldd a,(hl)		; $6163
	cp $10			; $6164
	ret c			; $6166
	inc (hl)		; $6167
	ret			; $6168
	jr nz,$78		; $6169
	jr z,$50		; $616b
	inc a			; $616d
	jr nc,$58		; $616e
	jr nz,_label_0e_213	; $6170
	inc (hl)		; $6172
	ld a,h			; $6173
	ld e,b			; $6174
	add b			; $6175
	ld a,b			; $6176
	ld (hl),b		; $6177
	and b			; $6178
	ld e,b			; $6179
	cp b			; $617a
	ld b,b			; $617b
	and b			; $617c
	jr c,_label_0e_214	; $617d
	ld b,b			; $617f
	ld h,b			; $6180
	ld e,b			; $6181
	ld c,b			; $6182
	ld h,h			; $6183
	ld e,h			; $6184
	ld l,b			; $6185
	ld (hl),b		; $6186
	ld e,h			; $6187
	add h			; $6188
	call _ecom_decCounter1		; $6189
	ret nz			; $618c
	ld bc,$0502		; $618d
	call objectCreateInteraction		; $6190
	ret nz			; $6193
	ld a,h			; $6194
	ld h,d			; $6195
	ld l,$99		; $6196
	ldd (hl),a		; $6198
	ld (hl),$40		; $6199
	ld l,$85		; $619b
	inc (hl)		; $619d
	ret			; $619e
	ld a,$21		; $619f
	call objectGetRelatedObject2Var		; $61a1
	bit 7,(hl)		; $61a4
	ret z			; $61a6
	ld h,d			; $61a7
	ld l,$84		; $61a8
	inc (hl)		; $61aa
	ld l,$a4		; $61ab
	set 7,(hl)		; $61ad
	ld l,$86		; $61af
	ld (hl),$3c		; $61b1
	ld l,$8b		; $61b3
	ld (hl),$56		; $61b5
	ld l,$8f		; $61b7
	ld (hl),$fe		; $61b9
	call objectSetVisible83		; $61bb
	xor a			; $61be
	ld ($cca4),a		; $61bf
	ld a,$2d		; $61c2
	ld (wActiveMusic),a		; $61c4
	jp playSound		; $61c7
	call _ecom_decCounter1		; $61ca
	jp nz,enemyAnimate		; $61cd
	ld l,e			; $61d0
	inc (hl)		; $61d1
	ret			; $61d2
	ld a,(de)		; $61d3
	sub $0a			; $61d4
	rst_jumpTable			; $61d6
	rst_addDoubleIndex			; $61d7
	ld h,c			; $61d8
	ld a,($ff00+$61)	; $61d9
	inc bc			; $61db
	ld h,d			; $61dc
	dec d			; $61dd
	ld h,d			; $61de
	ld h,d			; $61df
	ld l,e			; $61e0
	inc (hl)		; $61e1
_label_0e_213:
	ld l,$90		; $61e2
	ld (hl),$55		; $61e4
	ld l,$b4		; $61e6
	ldh a,(<hEnemyTargetY)	; $61e8
	ldi (hl),a		; $61ea
	ldh a,(<hEnemyTargetX)	; $61eb
	ld (hl),a		; $61ed
	jr _label_0e_215		; $61ee
	ld a,(wFrameCounter)		; $61f0
	and $0f			; $61f3
	ld a,$ae		; $61f5
_label_0e_214:
	call z,playSound		; $61f7
	call $62cc		; $61fa
	call nc,_ecom_moveTowardPosition		; $61fd
_label_0e_215:
	jp enemyAnimate		; $6200
	call _ecom_decCounter1		; $6203
	jr z,_label_0e_216	; $6206
	call $62f3		; $6208
	jr _label_0e_215		; $620b
_label_0e_216:
	call $62e8		; $620d
	call $6304		; $6210
	jr _label_0e_215		; $6213
	call _ecom_decCounter1		; $6215
	jr nz,_label_0e_215	; $6218
	ld l,e			; $621a
	ld (hl),$0a		; $621b
	jr _label_0e_215		; $621d
	ld a,(de)		; $621f
	sub $0a			; $6220
	rst_jumpTable			; $6222
	dec hl			; $6223
	ld h,d			; $6224
	ld a,($ff00+$61)	; $6225
	dec (hl)		; $6227
	ld h,d			; $6228
	ld c,d			; $6229
	ld h,d			; $622a
	ld h,d			; $622b
	ld l,e			; $622c
	inc (hl)		; $622d
	ld l,$90		; $622e
	ld (hl),$6e		; $6230
	jp $6326		; $6232
	call _ecom_decCounter1		; $6235
	jr z,_label_0e_217	; $6238
	call $62f3		; $623a
	jr _label_0e_218		; $623d
_label_0e_217:
	call $62e8		; $623f
	ld b,$3e		; $6242
	call _ecom_spawnProjectile		; $6244
_label_0e_218:
	jp enemyAnimate		; $6247
	call _ecom_decCounter1		; $624a
	jr nz,_label_0e_218	; $624d
	ld l,e			; $624f
	ld (hl),$0b		; $6250
	call $6326		; $6252
	jr _label_0e_218		; $6255
	ld e,$b0		; $6257
	ld a,(de)		; $6259
	cp $04			; $625a
	ret c			; $625c
	call _ecom_decCounter1		; $625d
	jr z,_label_0e_219	; $6260
	pop hl			; $6262
	jp enemyAnimate		; $6263
_label_0e_219:
	ld l,$b0		; $6266
	ld (hl),$00		; $6268
	ld l,$b2		; $626a
	ld (hl),$5a		; $626c
	ld a,$83		; $626e
	jp playSound		; $6270
	ld h,d			; $6273
	ld l,$b2		; $6274
	ld a,(hl)		; $6276
	or a			; $6277
	ret z			; $6278
	ld e,$ab		; $6279
	ld a,(de)		; $627b
	or a			; $627c
	jr z,_label_0e_220	; $627d
	pop bc			; $627f
	ret			; $6280
_label_0e_220:
	dec (hl)		; $6281
	jr z,_label_0e_222	; $6282
	pop bc			; $6284
	ld a,(hl)		; $6285
	and $03			; $6286
	jr nz,_label_0e_221	; $6288
	ld l,$9b		; $628a
	ld a,(hl)		; $628c
	and $01			; $628d
	inc a			; $628f
	ldi (hl),a		; $6290
	ld (hl),a		; $6291
_label_0e_221:
	jp enemyAnimate		; $6292
_label_0e_222:
	ld l,$82		; $6295
	ld a,(hl)		; $6297
	inc a			; $6298
	and $01			; $6299
	ld (hl),a		; $629b
	ld b,a			; $629c
	ld a,$02		; $629d
	sub b			; $629f
	ld l,$9b		; $62a0
	ldi (hl),a		; $62a2
	ld (hl),a		; $62a3
	ld l,$84		; $62a4
	ld (hl),$0a		; $62a6
	ld l,$a4		; $62a8
	set 7,(hl)		; $62aa
	ld l,$b0		; $62ac
	ld (hl),$00		; $62ae
	ret			; $62b0
	ld h,d			; $62b1
	ld l,$b1		; $62b2
	dec (hl)		; $62b4
	ld a,(hl)		; $62b5
	and $0f			; $62b6
	ret nz			; $62b8
	ld a,(hl)		; $62b9
	and $30			; $62ba
	swap a			; $62bc
	ld hl,$62c8		; $62be
	rst_addAToHl			; $62c1
	ld a,(hl)		; $62c2
	ld h,d			; $62c3
	ld l,$8f		; $62c4
	ld (hl),a		; $62c6
	ret			; $62c7
	rst $38			; $62c8
	cp $fd			; $62c9
	cp $62			; $62cb
	ld l,$b4		; $62cd
	call _ecom_readPositionVars		; $62cf
	sub c			; $62d2
	add $02			; $62d3
	cp $05			; $62d5
	ret nc			; $62d7
	ldh a,(<hFF8F)	; $62d8
	sub b			; $62da
	add $02			; $62db
	cp $05			; $62dd
	ret nc			; $62df
	ld l,$84		; $62e0
	inc (hl)		; $62e2
	ld l,$86		; $62e3
	ld (hl),$28		; $62e5
	ret			; $62e7
	ld (hl),$78		; $62e8
	inc l			; $62ea
	ld (hl),$96		; $62eb
	ld l,e			; $62ed
	inc (hl)		; $62ee
	ld l,$b0		; $62ef
	inc (hl)		; $62f1
	ret			; $62f2
	ld a,(hl)		; $62f3
	and $03			; $62f4
	ld hl,$6300		; $62f6
	rst_addAToHl			; $62f9
	ld e,$8d		; $62fa
	ld a,(de)		; $62fc
	add (hl)		; $62fd
	ld (de),a		; $62fe
	ret			; $62ff
	rst $38			; $6300
	ld bc,$ff01		; $6301
	call objectGetAngleTowardEnemyTarget		; $6304
	ld b,a			; $6307
	call getRandomNumber		; $6308
	cp $55			; $630b
	ld a,b			; $630d
	jr c,_label_0e_223	; $630e
	sub $02			; $6310
	and $1f			; $6312
	call $631a		; $6314
	ld a,b			; $6317
	add $04			; $6318
_label_0e_223:
	push af			; $631a
	ld b,$3d		; $631b
	call _ecom_spawnProjectile		; $631d
	pop bc			; $6320
	ret nz			; $6321
	ld l,$c9		; $6322
	ld (hl),b		; $6324
	ret			; $6325
_label_0e_224:
	call getRandomNumber_noPreserveVars		; $6326
	and $0e			; $6329
	ld h,d			; $632b
	ld l,$b3		; $632c
	cp (hl)			; $632e
	jr z,_label_0e_224	; $632f
	ld (hl),a		; $6331
	ld hl,$633e		; $6332
	rst_addAToHl			; $6335
	ld e,$b4		; $6336
	ldi a,(hl)		; $6338
	ld (de),a		; $6339
	inc e			; $633a
	ld a,(hl)		; $633b
	ld (de),a		; $633c
	ret			; $633d
	jr nz,$78		; $633e
	ld b,b			; $6340
	jr c,$78		; $6341
	ld e,b			; $6343
	ld e,b			; $6344
	ld a,b			; $6345
	ld a,b			; $6346
	sbc b			; $6347
	ld b,b			; $6348
	cp b			; $6349
	ld l,b			; $634a
	jr c,$68		; $634b
	cp b			; $634d


; ==============================================================================
; ENEMYID_AQUAMENTUS
;
; Variables (subid 1, main body):
;   var31: Affects collision box?
;   var32/var33: Target position?
;   var34: Reference to subid 2 (sprites only)
;   var35: Reference to subid 3 (the horn)
;   var36: Counter for playing footstep sound
;   var37: ?
;
; Variables (subid 2, sprites only):
;   relatedObj1: Reference to subid 1 (main body)
;   relatedObj2: Reference to subid 3 (horn)
;   var30: Current animation
;
; Variables (subid 3, horn):
;   relatedObj2: Reference to subid 2 (sprites)
;   var30: Current animation
; ==============================================================================
enemyCode78:
	jr z,@normalStatus	; $634e
	sub ENEMYSTATUS_NO_HEALTH			; $6350
	ret c			; $6352
	dec a			; $6353
	jr z,@justHit	; $6354
	dec a			; $6356
	jr z,@normalStatus	; $6357

	; Dead
	ld e,Enemy.subid		; $6359
	ld a,(de)		; $635b
	sub $02			; $635c
	jp z,_enemyBoss_dead		; $635e
	dec a			; $6361
	jp nz,enemyDelete		; $6362
	call _ecom_killRelatedObj1		; $6365
	call _ecom_killRelatedObj2		; $6368
	jp enemyDie_uncounted_withoutItemDrop		; $636b

@justHit:
	ld e,Enemy.subid		; $636e
	ld a,(de)		; $6370
	sub $03			; $6371
	jr nz,@normalStatus	; $6373

	ld a,Object.invincibilityCounter		; $6375
	call objectGetRelatedObject2Var		; $6377
	ld e,l			; $637a
	ld a,(de)		; $637b
	ld (hl),a		; $637c

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $637d
	jr nc,@state8OrHigher	; $6380
	rst_jumpTable			; $6382
	.dw _aquamentus_state_uninitialized
	.dw _aquamentus_state_spawner
	.dw _aquamentus_state_stub
	.dw _aquamentus_state_stub
	.dw _aquamentus_state_stub
	.dw _aquamentus_state_stub
	.dw _aquamentus_state_stub
	.dw _aquamentus_state_stub

@state8OrHigher
	dec b			; $6393
	ld a,b			; $6394
	rst_jumpTable			; $6395
	.dw _aquamentus_subid1
	.dw _aquamentus_subid2
	.dw _aquamentus_subid3


_aquamentus_state_uninitialized:
	ld c,$20		; $639c
	call _ecom_setZAboveScreen		; $639e

	; Check subid
	ld a,b			; $63a1
	or a			; $63a2
	jp nz,_ecom_setSpeedAndState8		; $63a3

	; Subid is 0; go to state 1
	ld l,e			; $63a6
	inc (hl) ; [state] = 1
	ld a,ENEMYID_AQUAMENTUS		; $63a8
	ld b,SEASONS_PALH_80		; $63aa
	jp _enemyBoss_initializeRoom		; $63ac


_aquamentus_state_spawner:
	ld a,(wcc93)		; $63af
	or a			; $63b2
	ret nz			; $63b3

	ld b,$03		; $63b4
	call checkBEnemySlotsAvailable		; $63b6
	ret nz			; $63b9

	ld b,ENEMYID_AQUAMENTUS		; $63ba
	call _ecom_spawnUncountedEnemyWithSubid01		; $63bc
	ld c,h			; $63bf

	call _ecom_spawnUncountedEnemyWithSubid01		; $63c0
	inc (hl) ; [child.subid] = 2
	call _aquamentus_initializeChildObject		; $63c4

	push hl			; $63c7
	call _ecom_spawnUncountedEnemyWithSubid01		; $63c8
	ld (hl),$03 ; [child.subid] = 3
	call _aquamentus_initializeChildObject		; $63cd

	ld e,h			; $63d0
	pop hl			; $63d1
	ld a,h			; $63d2
	ld h,c			; $63d3
	ld l,Enemy.var34		; $63d4
	ldi (hl),a ; [body.var34] = subid2
	ld (hl),e  ; [body.var35] = horn
	call objectCopyPosition		; $63d8
	jp enemyDelete		; $63db


_aquamentus_state_stub:
	ret			; $63de


; Body hitbox + general logic
_aquamentus_subid1:
	ld a,(de)		; $63df
	sub $08			; $63e0
	rst_jumpTable			; $63e2
	.dw _aquamentus_body_state8
	.dw _aquamentus_body_state9
	.dw _aquamentus_body_stateA
	.dw _aquamentus_body_stateB
	.dw _aquamentus_body_stateC
	.dw _aquamentus_body_stateD
	.dw _aquamentus_body_stateE
	.dw _aquamentus_body_stateF

; Initialization
_aquamentus_body_state8:
	ld bc,$020c		; $63f3
	call _enemyBoss_spawnShadow		; $63f6
	ret nz			; $63f9

	ld h,d			; $63fa
	ld l,Enemy.state		; $63fb
	inc (hl)		; $63fd

	ld l,Enemy.enemyCollisionMode		; $63fe
	ld (hl),ENEMYCOLLISION_AQUAMENTUS_BODY		; $6400

	ld l,Enemy.var32		; $6402
	ld a,$50		; $6404
	ldi (hl),a  ; [var32]
	ld (hl),$c0 ; [var33]

	ld l,Enemy.var31		; $6409
	ld (hl),$01		; $640b
	ld l,Enemy.counter1		; $640d
	ld (hl),90		; $640f
	ret			; $6411


; Lowering down
_aquamentus_body_state9:
	ld e,Enemy.zh		; $6412
	ld a,(de)		; $6414
	cp $f4			; $6415
	jr nc,@doneLowering	; $6417

	; Lower aquamentus based on his current height
	and $f0			; $6419
	swap a			; $641b
	ld hl,_aquamentus_fallingSpeeds		; $641d
	rst_addAToHl			; $6420
	dec e			; $6421
	ld a,(de)		; $6422
	add (hl)		; $6423
	ld (de),a		; $6424
	inc e			; $6425
	ld a,(de)		; $6426
	adc $00			; $6427
	ld (de),a		; $6429
	jp _aquamentus_playHoverSoundEvery32Frames		; $642a

@doneLowering:
	ld h,d			; $642d
	ld l,Enemy.state		; $642e
	inc (hl) ; [state] = $0a

	ld l,Enemy.var31		; $6431
	ld (hl),$02		; $6433
	ret			; $6435


; Hovering in place before landing
_aquamentus_body_stateA:
	call _ecom_decCounter1		; $6436
	jp nz,_aquamentus_playHoverSoundEvery32Frames		; $6439

	; Time to land on the ground

	ld (hl),60		; $643c
	ld l,Enemy.zh		; $643e
	ld (hl),$00		; $6440

	ld l,e			; $6442
	inc (hl) ; [state] = $0b

	ld l,Enemy.var31		; $6444
	ld (hl),$04		; $6446

	; Check whether to play boss music?
	ld l,Enemy.var37		; $6448
	bit 0,(hl)		; $644a
	jr nz,++		; $644c
	inc (hl)		; $644e
	ld a,MUS_BOSS		; $644f
	ld (wActiveMusic),a		; $6451
	call playSound		; $6454
++
	ld a,$20		; $6457

;;
; @addr{6459}
_aquamentus_body_pound:
	call setScreenShakeCounter		; $6459
	ld a,SND_STRONG_POUND		; $645c
	jp playSound		; $645e


; Standing in place
_aquamentus_body_stateB:
	call _ecom_decCounter1		; $6461
	ret nz			; $6464
	ld (hl),150		; $6465
	inc l			; $6467
	ld (hl),$04 ; [counter2]

	ld l,Enemy.var36		; $646a
	ld (hl),$18		; $646c
	jp _aquamentus_decideNextAttack		; $646e


; Moving forward
_aquamentus_body_stateC:
	call _aquamentus_body_playFootstepSoundEvery24Frames		; $6471
	call _aquamentus_body_6694		; $6474
	call _ecom_decCounter1		; $6477
	jr nz,@applySpeed	; $647a

	inc l			; $647c
	ldd a,(hl) ; [counter2]
	ld bc,_aquamentus_projectileFireDelayCounters		; $647e
	call addAToBc		; $6481
	ld a,(bc)		; $6484
	ldi (hl),a ; [counter1]
	dec (hl)   ; [counter2]--
	jr nz,@fireProjectiles	; $6487

	ld l,Enemy.state		; $6489
	inc (hl) ; [state] = $0d

	ld l,Enemy.var31		; $648c
	ld (hl),$08		; $648e
	ld l,Enemy.speed		; $6490
	ld (hl),SPEED_80		; $6492
	ret			; $6494

@fireProjectiles:
	call _aquamentus_body_chooseRandomLeftwardAngle		; $6495
	call _aquamentus_fireProjectiles		; $6498
@applySpeed:
	jp objectApplySpeed		; $649b


; Walking back to original position
_aquamentus_body_stateD:
	call _aquamentus_body_playFootstepSoundEvery18Frames		; $649e
	call _aquamentus_body_6694		; $64a1
	call _aquamentus_body_checkReachedTargetPosition		; $64a4
	jr c,@gotoStateB	; $64a7

	call _ecom_decCounter1		; $64a9
	call z,_aquamentus_fireProjectiles		; $64ac
	jp _ecom_moveTowardPosition		; $64af

@gotoStateB:
	ld l,Enemy.counter1		; $64b2
	ld (hl),30		; $64b4
	ld l,Enemy.state		; $64b6
	ld (hl),$0b		; $64b8
	ld l,Enemy.var31		; $64ba
	ld (hl),$04		; $64bc
	ret			; $64be


; Charge attack
_aquamentus_body_stateE:
	call _ecom_decCounter2		; $64bf
	ret nz			; $64c2

	ld e,Enemy.xh		; $64c3
	ld a,(de)		; $64c5
	cp $1c			; $64c6
	jr c,@onLeftSide	; $64c8

	; Begin charge

	ld a,(wFrameCounter)		; $64ca
	and $1f			; $64cd
	ld a,SND_SWORDSPIN		; $64cf
	call z,playSound		; $64d1
	ld a,(wFrameCounter)		; $64d4
	and $07			; $64d7
	jr nz,@applySpeed	; $64d9

	call getFreeInteractionSlot		; $64db
	jr nz,@applySpeed	; $64de

	; Create dust
	ld (hl),INTERACID_FALLDOWNHOLE		; $64e0
	inc l			; $64e2
	inc (hl) ; [subid] = 1
	ld bc,$1010		; $64e4
	call objectCopyPositionWithOffset		; $64e7

@applySpeed:
	jp objectApplySpeed		; $64ea

@onLeftSide:
	call _ecom_decCounter1		; $64ed
	dec (hl)		; $64f0
	jr z,@gotoStateF	; $64f1

	; Play "pound" sound effect when he reaches the wall
	ld a,(hl)		; $64f3
	cp 148			; $64f4
	ret nz			; $64f6
	ld a,70		; $64f7
	jp _aquamentus_body_pound		; $64f9

@gotoStateF:
	ld (hl),240 ; [counter1]
	inc l			; $64fe
	ld (hl),60 ; [counter2]

	ld l,Enemy.state		; $6501
	inc (hl) ; [state] = $0f

	ld l,Enemy.zh		; $6504
	ld (hl),$f8		; $6506

	ld l,Enemy.var31		; $6508
	ld (hl),$01		; $650a

	ld l,Enemy.angle		; $650c
	ld (hl),$08		; $650e
	ld l,Enemy.speed		; $6510
	ld (hl),SPEED_c0		; $6512
	ret			; $6514


_aquamentus_body_stateF:
	call _aquamentus_playHoverSoundEvery32Frames		; $6515
	call _ecom_decCounter2		; $6518
	jr z,@moveBack	; $651b

	; Rising up
	ld l,Enemy.zh		; $651d
	ld a,(hl)		; $651f
	cp $e8			; $6520
	ret c			; $6522
	ld b,$80		; $6523
	jp _aquamentus_body_subZ		; $6525

@moveBack:
	call _ecom_decCounter1		; $6528
	jr z,@lowerDown	; $652b

	; Moving back to original position (and maybe still rising up)
	ld a,(hl) ; [counter1]
	cp 210			; $652e
	ld b,$c0		; $6530
	call nc,_aquamentus_body_subZ		; $6532
	call _aquamentus_body_checkReachedTargetPosition		; $6535
	ret c			; $6538
	jp _ecom_moveTowardPosition		; $6539

@lowerDown:
	ld l,Enemy.state		; $653c
	ld (hl),$09		; $653e
	ld l,Enemy.counter1		; $6540
	ld (hl),30		; $6542
	ret			; $6544


; All sprites except horn
_aquamentus_subid2:
	ld a,(de) ; [state]
	sub $08			; $6546
	jr z,@state8	; $6548

@state9:
	ld a,Object.var31		; $654a
	call objectGetRelatedObject1Var		; $654c
	ld b,(hl)		; $654f

	; Copy main body's position
	ld a,d			; $6550
	ld d,h			; $6551
	ld h,a			; $6552
	call objectCopyPosition		; $6553
	ld d,h			; $6556

	ld a,b			; $6557
	call getHighestSetBit		; $6558
	jr nc,_aquamentus_animate	; $655b

	ld hl,_aquamentus_animations		; $655d
	rst_addAToHl			; $6560
	ld e,Enemy.var30		; $6561
	ld a,(de)		; $6563
	cp (hl)			; $6564
	jr z,_aquamentus_animate	; $6565

	ld a,(hl)		; $6567
	ld (de),a		; $6568
	jp enemySetAnimation		; $6569

@state8:
	ld h,d			; $656c
	ld l,Enemy.state		; $656d
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType		; $6570
	res 7,(hl)		; $6572

	; Copy parent's horn reference to relatedObj2
	ld l,Enemy.relatedObj1+1		; $6574
	ld h,(hl)		; $6576
	ld l,Enemy.var35		; $6577
	ld e,Enemy.relatedObj2+1		; $6579
	ld a,(hl)		; $657b
	ld (de),a		; $657c
	jp objectSetVisible81		; $657d


; Horn & horn hitbox
_aquamentus_subid3:
	ld a,(de)		; $6580
	sub $08			; $6581
	jr z,_aquamentus_subid3_state8	; $6583


_aquamentus_subid3_state9:
	; Only draw the horn if the main sprite is also visible
	ld a,Object.visible		; $6585
	call objectGetRelatedObject2Var		; $6587
	ld e,l			; $658a
	ld a,(hl)		; $658b
	and $80			; $658c
	ld b,a			; $658e
	ld a,(de)		; $658f
	and $7f			; $6590
	or b			; $6592
	ld (de),a		; $6593

	call _aquamentus_horn_updateAnimation		; $6594

	; Get parent's position
	ld a,Object.yh		; $6597
	call objectGetRelatedObject1Var		; $6599
	ld b,(hl)		; $659c
	ld l,Enemy.xh		; $659d
	ld c,(hl)		; $659f

	; [horn.zh] = [body.zh] - 7
	ld l,Enemy.zh		; $65a0
	ld e,l			; $65a2
	ld a,(hl)		; $65a3
	sub $07			; $65a4
	ld (de),a		; $65a6

	; Y/X offsets for horn vary based on subid 2's animParameter
	ld l,Enemy.var34		; $65a7
	ld h,(hl)		; $65a9
	ld l,Enemy.animParameter		; $65aa
	ld a,(hl)		; $65ac
	cp $09			; $65ad
	jr c,+			; $65af
	ld a,$05		; $65b1
+
	ld hl,_aquamentus_hornXYOffsets		; $65b3
	rst_addDoubleIndex			; $65b6
	ld e,Enemy.yh		; $65b7
	ldi a,(hl)		; $65b9
	add b			; $65ba
	ld (de),a		; $65bb

	ld e,Enemy.xh		; $65bc
	ld a,(hl)		; $65be
	add c			; $65bf
	ld (de),a		; $65c0

_aquamentus_animate:
	jp enemyAnimate		; $65c1


_aquamentus_subid3_state8:
	ld h,d			; $65c4
	ld l,e			; $65c5
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionRadiusY		; $65c7
	ld (hl),$06		; $65c9
	inc l			; $65cb
	ld (hl),$03		; $65cc

	; Copy parent's subid2 reference to relatedObj2
	ld l,Enemy.relatedObj1+1		; $65ce
	ld h,(hl)		; $65d0
	ld l,Enemy.var34		; $65d1
	ld e,Enemy.relatedObj2+1		; $65d3
	ld a,(hl)		; $65d5
	ld (de),a		; $65d6
	jp objectSetVisible81		; $65d7


;;
; @param	h	Child object
; @addr{65da}
_aquamentus_initializeChildObject:
	ld l,Enemy.relatedObj1		; $65da
	ld a,Enemy.start		; $65dc
	ldi (hl),a		; $65de
	ld (hl),c		; $65df
	inc l			; $65e0
	ld (hl),a		; $65e1
	jp objectCopyPosition		; $65e2

;;
; Chooses whether to charge (state $0e) or move forward (state $0c)
; @addr{65e5}
_aquamentus_decideNextAttack:
	ld e,Enemy.xh		; $65e5
	ld a,(de)		; $65e7
	ld b,a			; $65e8
	ldh a,(<hEnemyTargetX)	; $65e9
	cp b			; $65eb
	ld a,$0c		; $65ec
	jr nc,@setState	; $65ee

	call getRandomNumber_noPreserveVars		; $65f0
	and $07			; $65f3
	ld c,a			; $65f5
	ldh a,(<hEnemyTargetX)	; $65f6
	rlca			; $65f8
	rlca			; $65f9
	and $03			; $65fa
	ld hl,_aquamentus_chargeProbabilities		; $65fc
	rst_addAToHl			; $65ff
	ld a,c			; $6600
	call checkFlag		; $6601
	ld a,$0c		; $6604
	jr z,@setState	; $6606
	ld a,$0e		; $6608

@setState:
	ld e,Enemy.state		; $660a
	ld (de),a		; $660c
	cp $0c			; $660d
	jr z,@initializeMovement	; $660f

	; Initialize charge attack
	call _aquamentus_body_calculateAngleForCharge		; $6611
	ld e,Enemy.counter2		; $6614
	ld a,30		; $6616
	ld (de),a		; $6618

	ld a,$20		; $6619
	ld e,SPEED_1c0		; $661b

@setVar31AndSpeed:
	ld h,d			; $661d
	ld l,Enemy.var31		; $661e
	ld (hl),a		; $6620
	ld l,Enemy.speed		; $6621
	ld (hl),e		; $6623

	ld e,Enemy.var31		; $6624
	ld a,(de)		; $6626
	call getHighestSetBit		; $6627
	ret nc			; $662a

	ld hl,_aquamentus_collisionBoxSizes		; $662b
	rst_addDoubleIndex			; $662e
	ld e,Enemy.collisionRadiusY		; $662f
	ldi a,(hl)		; $6631
	ld (de),a		; $6632
	inc e			; $6633
	ld a,(hl)		; $6634
	ld (de),a		; $6635
	ret			; $6636

@initializeMovement:
	call _aquamentus_body_chooseRandomLeftwardAngle		; $6637
	ld a,$04		; $663a
	ld e,SPEED_40		; $663c
	jr @setVar31AndSpeed		; $663e


;;
; @addr{6640}
_aquamentus_body_chooseRandomLeftwardAngle:
	call getRandomNumber_noPreserveVars		; $6640
	and $07			; $6643
	cp $07			; $6645
	jr nz,+			; $6647
	ld a,$03		; $6649
+
	add $15			; $664b
	ld e,Enemy.angle		; $664d
	ld (de),a		; $664f
	ret			; $6650

;;
; Sets angle to move left, slightly up or down, depending on Link's position
; @addr{6651}
_aquamentus_body_calculateAngleForCharge:
	ld b,$02		; $6651
	ldh a,(<hEnemyTargetY)	; $6653
	cp $48			; $6655
	jr c,@setAngle	; $6657
	dec b			; $6659
	cp $68			; $665a
	jr c,@setAngle	; $665c
	dec b			; $665e

@setAngle:
	ld a,$17		; $665f
	add b			; $6661
	ld e,Enemy.angle		; $6662
	ld (de),a		; $6664
	ret			; $6665

;;
; @param[out]	cflag	c if within 2 pixels of target position
; @addr{6666}
_aquamentus_body_checkReachedTargetPosition:
	ld h,d			; $6666
	ld l,Enemy.var32		; $6667
	call _ecom_readPositionVars		; $6669
	sub c			; $666c
	add $02			; $666d
	cp $05			; $666f
	ret nc			; $6671
	ldh a,(<hFF8F)	; $6672
	sub b			; $6674
	add $02			; $6675
	cp $05			; $6677
	ret			; $6679

;;
; @param	b	Amount to subtract z value by (subpixels)
; @addr{667a}
_aquamentus_body_subZ:
	ld e,Enemy.z		; $667a
	ld a,(de)		; $667c
	sub b			; $667d
	ld (de),a		; $667e
	inc e			; $667f
	ld a,(de)		; $6680
	sbc $00			; $6681
	ld (de),a		; $6683
	ret			; $6684

;;
; @addr{6685}
_aquamentus_fireProjectiles:
	ld e,Enemy.var31		; $6685
	ld a,$10		; $6687
	ld (de),a		; $6689
	ld a,SND_DODONGO_OPEN_MOUTH		; $668a
	call playSound		; $668c
	ld b,PARTID_AQUAMENTUS_PROJECTILE		; $668f
	jp _ecom_spawnProjectile		; $6691

;;
; @addr{6694}
_aquamentus_body_6694:
	ld e,Enemy.var34		; $6694
	ld a,(de)		; $6696
	ld h,a			; $6697
	ld l,Enemy.animParameter		; $6698
	ld a,(hl)		; $669a
	inc a			; $669b
	ret nz			; $669c

	ld e,Enemy.state		; $669d
	ld a,(de)		; $669f
	cp $0c			; $66a0
	ld a,$04		; $66a2
	jr z,+			; $66a4
	add a			; $66a6
+
	ld e,Enemy.var31		; $66a7
	ld (de),a		; $66a9
	ret			; $66aa


;;
; @addr{66ab}
_aquamentus_playHoverSoundEvery32Frames:
	ld a,(wFrameCounter)		; $66ab
	and $1f			; $66ae
	ret nz			; $66b0

	ld a,SND_AQUAMENTUS_HOVER		; $66b1
	jr _aquamentus_playSound		; $66b3

;;
; @addr{66b5}
_aquamentus_body_playFootstepSoundEvery18Frames:
	ld a,$12		; $66b5
	jr ++		; $66b7

;;
; @addr{66b9}
_aquamentus_body_playFootstepSoundEvery24Frames:
	ld a,$18		; $66b9
++
	ld h,d			; $66bb
	ld l,Enemy.var36		; $66bc
	dec (hl)		; $66be
	ret nz			; $66bf

	ld (hl),a		; $66c0
	ld a,SND_ROLLER		; $66c1

_aquamentus_playSound:
	jp playSound		; $66c3

;;
; @addr{66c6}
_aquamentus_horn_updateAnimation:
	ld a,Object.var34		; $66c6
	call objectGetRelatedObject1Var		; $66c8
	ld h,(hl)		; $66cb

	ld l,Enemy.animParameter		; $66cc
	ld a,(hl)		; $66ce
	inc a			; $66cf
	ld hl,@animations		; $66d0
	rst_addAToHl			; $66d3

	ld a,(hl)		; $66d4
	ld h,d			; $66d5
	ld l,Enemy.var30		; $66d6
	cp (hl)			; $66d8
	ret z			; $66d9

	ld (hl),a		; $66da
	jp enemySetAnimation		; $66db

@animations:
	.db $06 $05 $05 $05 $05 $06 $06 $06
	.db $07 $08

_aquamentus_projectileFireDelayCounters:
	.db 0, 100, 60, 180, 180


; Each byte corresponds to one horizontal quarter of the screen. Aquamentus will charge if
; a randomly chosen bit from that byte is set. (Doesn't apply if Link is behind
; aquamentus.)
_aquamentus_chargeProbabilities:
	.db $03 $31 $13 $33


_aquamentus_collisionBoxSizes:
	.db $16 $08
	.db $16 $08
	.db $0a $0d
	.db $0a $0d
	.db $0a $0d
	.db $0c $14

_aquamentus_animations:
	.db $00 $00 $01 $02 $03 $04


; Each byte is a z value to add depending on aquamentus's current height.
_aquamentus_fallingSpeeds:
	.db $00 $f0 $f0 $f0 $f0 $f0 $f0 $e0
	.db $e0 $e0 $e0 $c0 $c0 $a0 $60 $30

_aquamentus_hornXYOffsets:
	.db $d8 $f4
	.db $d7 $f4
	.db $e8 $f2
	.db $e7 $f2
	.db $e8 $f2
	.db $e8 $f8
	.db $e5 $f4
	.db $e8 $f2
	.db $0f $e8


; ==============================================================================
; ENEMYID_DODONGO
;
; Variables:
;   var30: Animation base?
;   var31: Corresponds to direction Link was facing when he picked Dodongo up
;   var32: Index in the "attack pattern" ($00-$0f).
;   var33: Animation index?
; ==============================================================================
enemyCode79:
	jr z,@normalStatus		; $6725
	sub ENEMYSTATUS_NO_HEALTH			; $6727
	ret c			; $6729
	jp z,_enemyBoss_dead		; $672a

@normalStatus:
	ld e,Enemy.state		; $672d
	ld a,(de)		; $672f
	rst_jumpTable			; $6730
	.dw _dodongo_state_uninitialized
	.dw _dodongo_state_stub
	.dw _dodongo_state_grabbed
	.dw _dodongo_state_stub
	.dw _dodongo_state_stub
	.dw _dodongo_state_stub
	.dw _dodongo_state_stub
	.dw _dodongo_state_stub
	.dw _dodongo_state8
	.dw _dodongo_state9
	.dw _dodongo_stateA
	.dw _dodongo_stateB
	.dw _dodongo_stateC
	.dw _dodongo_stateD

_dodongo_state_uninitialized:
	ld bc,$0208		; $674d
	call _enemyBoss_spawnShadow		; $6750
	ret nz			; $6753

	ld a,ENEMYID_DODONGO		; $6754
	ld b,SEASONS_PALH_81		; $6756
	call _enemyBoss_initializeRoom		; $6758

	ld e,Enemy.var33		; $675b
	ld a,$04		; $675d
	ld (de),a		; $675f
	call enemySetAnimation		; $6760

	call _ecom_setSpeedAndState8		; $6763
	jp objectSetVisible82		; $6766


_dodongo_state_grabbed:
	inc e			; $6769
	ld a,(de) ; [state2]
	rst_jumpTable			; $676b
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @landed

@justGrabbed:
	ld h,d			; $6774
	ld l,e			; $6775
	inc (hl) ; [state2]

	ld a,$20		; $6777
	ld (wLinkGrabState2),a		; $6779

	ld l,Enemy.var31		; $677c
	ld a,(w1Link.direction)		; $677e
	add a			; $6781
	add a			; $6782
	ld (hl),a		; $6783

	ld l,Enemy.collisionType		; $6784
	res 7,(hl)		; $6786

	ld l,Enemy.counter2		; $6788
	ld (hl),$01		; $678a

	ld l,Enemy.var30		; $678c
	ld (hl),$ff		; $678e

	jp objectSetVisible81		; $6790

@beingHeld:
	call _dodongo_updateAnimationWhileHeld		; $6793
	jr z,@dropDodongo			; $6796

	; Slow down Link's movement
	ld a,(wFrameCounter)		; $6798
	and $03			; $679b
	ret z			; $679d
	ld hl,wLinkImmobilized		; $679e
	set 5,(hl)		; $67a1
	ret			; $67a3

@dropDodongo:
	call dropLinkHeldItem		; $67a4
	ld h,d			; $67a7
	ld l,Enemy.state2		; $67a8
	ld (hl),$03		; $67aa
	inc l			; $67ac
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType		; $67af
	set 7,(hl)		; $67b1
	ld l,Enemy.direction		; $67b3
	ld a,(hl)		; $67b5
	jp enemySetAnimation		; $67b6

@released:
	ld h,d			; $67b9
	ld l,Enemy.collisionType		; $67ba
	bit 7,(hl)		; $67bc
	jr nz,++		; $67be

	; Re-enable collisions, change animation?
	set 7,(hl)		; $67c0
	ld e,Enemy.direction		; $67c2
	ld a,(de)		; $67c4
	add $02			; $67c5
	call enemySetAnimation		; $67c7
++
	call _dodongo_setInvincibilityAndPlaySoundIfInSpikes		; $67ca
	ret nz			; $67cd
	jr @inSpikes		; $67ce

@landed:
	ld c,$20		; $67d0
	call objectUpdateSpeedZ_paramC		; $67d2
	ret nz			; $67d5

	call _dodongo_setInvincibilityAndPlaySoundIfInSpikes		; $67d6
	jp nz,_dodongo_resetMovement		; $67d9

@inSpikes:
	ld h,d			; $67dc
	ld l,Enemy.var33		; $67dd
	dec (hl)		; $67df
	call z,_ecom_killObjectH		; $67e0

	ld l,Enemy.state		; $67e3
	ld (hl),$0c		; $67e5

	ld l,Enemy.counter2		; $67e7
	ld (hl),$04		; $67e9
	dec l			; $67eb
	ld (hl),30 ; [counter1]

	; If angle value not set, calculate angle based on direction?
	ld l,Enemy.angle		; $67ee
	bit 7,(hl)		; $67f0
	jr z,++			; $67f2
	dec l			; $67f4
	ldi a,(hl) ; [direction]
	add a			; $67f6
	xor $10			; $67f7
	ld (hl),a		; $67f9
++
	jp objectSetVisible82		; $67fa


_dodongo_state_stub:
	ret			; $67fd


; Waiting for Link to enter room
_dodongo_state8:
	ld a,(wcc93)		; $67fe
	or a			; $6801
	ret nz			; $6802

	ld a,$09		; $6803
	ld (de),a ; [state]

	ld a,MUS_BOSS		; $6806
	ld (wActiveMusic),a		; $6808
	call playSound		; $680b


; Deciding what direction to walk in
_dodongo_state9:
	call _dodongo_turnTowardLinkIfPossible		; $680e
	ret nc			; $6811

	ld h,d			; $6812
	ld l,Enemy.state		; $6813
	inc (hl) ; [state] = $0a

	ld l,Enemy.speed		; $6816
	ld (hl),SPEED_40		; $6818

	; Decide how long to walk for
	call getRandomNumber_noPreserveVars		; $681a
	and $07			; $681d
	ld hl,@counter1Vals		; $681f
	rst_addAToHl			; $6822
	ld e,Enemy.counter1		; $6823
	ld a,(hl)		; $6825
	ld (de),a		; $6826

	; Set animation
	ld e,Enemy.angle		; $6827
	ld a,(de)		; $6829
	rrca			; $682a
	dec e			; $682b
	ld (de),a ; [direction]
	call enemySetAnimation		; $682d

	; Set collision box based on facing direction
	ld e,Enemy.angle		; $6830
	ld a,(de)		; $6832
	and $08			; $6833
	rrca			; $6835
	rrca			; $6836
	ld hl,@collisionRadii		; $6837
	rst_addAToHl			; $683a
	ld e,Enemy.collisionRadiusY		; $683b
	ldi a,(hl)		; $683d
	ld (de),a		; $683e
	inc e			; $683f
	ld a,(hl)		; $6840
	ld (de),a		; $6841
	ret			; $6842

@collisionRadii:
	.db $0c $08 ; Up/down
	.db $08 $10 ; Left/right

@counter1Vals: ; Potential lengths of time to walk for before attacking
	.db 160, 160, 120, 160, 120, 120, 120, 120


; Walking
_dodongo_stateA:
	call _dodongo_playStompSoundAtInterval		; $684f
	call _ecom_decCounter1		; $6852
	jr nz,@walking	; $6855

	call _dodongo_updateAngleTowardLink		; $6857
	jp c,_dodongo_initiateNextAttack		; $685a

	; Reset movement if Link is no longer lined up well
	jp _dodongo_resetMovement		; $685d

@walking:
	; If counter2 is nonzero, he's charging up, not moving
	call _ecom_decCounter2		; $6860
	jr nz,_dodongo_doubleAnimate	; $6863

	call _dodongo_checkTileInFront		; $6865
	jp nc,_dodongo_resetMovement		; $6868

	call objectApplySpeed		; $686b
	ld e,Enemy.speed		; $686e
	ld a,(de)		; $6870
	cp SPEED_40			; $6871
	jr z,_dodongo_animate	; $6873

_dodongo_doubleAnimate:
	call enemyAnimate		; $6875
_dodongo_animate:
	jp enemyAnimate		; $6878


; Opening mouth, preparing to fire
_dodongo_stateB:
	ld e,Enemy.animParameter		; $687b
	ld a,(de)		; $687d
	dec a			; $687e
	jp z,_dodongo_checkEatBomb		; $687f

	dec a			; $6882
	jr nz,@animate	; $6883

	ld (de),a ; [animParameter] = 0

	; Fire projectile
	ld b,PARTID_DODONGO_FIREBALL		; $6886
	call _ecom_spawnProjectile		; $6888

	ld a,SND_BEAM2		; $688b
	call playSound		; $688d

	jr _dodongo_animate		; $6890

@animate:
	add $03			; $6892
	jr nz,_dodongo_animate	; $6894
	jr _dodongo_resetMovement		; $6896


; In spikes?
_dodongo_stateC:
	ld h,d			; $6898
	ld l,Enemy.invincibilityCounter		; $6899
	ld a,(hl)		; $689b
	or a			; $689c
	ret nz			; $689d

	; Delay before moving back
	call _ecom_decCounter2		; $689e
	ret nz			; $68a1

	ld l,Enemy.counter1		; $68a2
	ld a,(hl)		; $68a4
	cp 30			; $68a5
	jr nz,@moveBack	; $68a7

	ld l,Enemy.speed		; $68a9
	ld (hl),SPEED_140		; $68ab

	; Reverse angle
	ld l,Enemy.angle		; $68ad
	ld a,(hl)		; $68af
	xor $10			; $68b0
	ldd (hl),a		; $68b2

	rrca			; $68b3
	ld (hl),a ; [direction]
	call enemySetAnimation		; $68b5

@moveBack:
	call _dodongo_playStompSoundAtInterval		; $68b8
	call _ecom_decCounter1		; $68bb
	jr nz,++		; $68be

	call _dodongo_checkInSpikes		; $68c0
	jr nz,_dodongo_resetMovement	; $68c3

	ld e,Enemy.counter1		; $68c5
	ld a,$0a		; $68c7
	ld (de),a		; $68c9
++
	call objectApplySpeed		; $68ca
	jr _dodongo_doubleAnimate		; $68cd


; Just ate a bomb
_dodongo_stateD:
	call objectAddToGrabbableObjectBuffer		; $68cf
	call objectPushLinkAwayOnCollision		; $68d2

	; When counter2 reaches 0, dodongo begins getting up
	call _ecom_decCounter2		; $68d5
	ret nz			; $68d8

	call _dodongo_updateAnimationWhileSlimmingDown		; $68d9
	jr z,_dodongo_resetMovement	; $68dc

	ld l,Enemy.direction		; $68de


;;
; @param	hl	Pointer to Enemy.direction
; @addr{68e0}
_dodongo_updateAnimation:
	ld e,Enemy.var30		; $68e0
	ld a,(de)		; $68e2
	and $01			; $68e3
	add $02			; $68e5
	add (hl)		; $68e7
	jp enemySetAnimation		; $68e8

;;
; @addr{68eb}
_dodongo_resetMovement:
	ld h,d			; $68eb
	ld l,Enemy.state		; $68ec
	ld (hl),$09		; $68ee

	ld l,Enemy.collisionType		; $68f0
	set 7,(hl)		; $68f2

	ld l,Enemy.counter1		; $68f4
	xor a			; $68f6
	ldi (hl),a		; $68f7
	ld (hl),a ; [counter2]

	ld l,Enemy.direction		; $68f9
	ld a,(hl)		; $68fb
	jp enemySetAnimation		; $68fc


;;
; Either turns toward Link or, if facing a wall, turns in some other random direction.
;
; @param[out]	c	c if wasn't able to turn in any valid direction
; @addr{68ff}
_dodongo_turnTowardLinkIfPossible:
	call _ecom_updateCardinalAngleTowardTarget		; $68ff
	call _dodongo_checkTileInFront		; $6902
	ret c			; $6905
	call _ecom_setRandomCardinalAngle		; $6906

	; Fall through

;;
; @param[out]	cflag	c if tile in front of dodongo is not a spike
; @addr{6909}
_dodongo_checkTileInFront:
	ld h,d			; $6909
	ld l,Enemy.yh		; $690a
	ld b,(hl)		; $690c
	ld l,Enemy.xh		; $690d
	ld c,(hl)		; $690f
	ld e,Enemy.angle		; $6910
	ld a,(de)		; $6912
	rrca			; $6913
	rrca			; $6914
	ld hl,@positionOffsets		; $6915
	rst_addAToHl			; $6918

	ldi a,(hl)		; $6919
	add b			; $691a
	ld b,a			; $691b
	ld a,(hl)		; $691c
	add c			; $691d
	ld c,a			; $691e
	call getTileAtPosition		; $691f
	cp $a4			; $6922
	scf			; $6924
	ret z			; $6925

	sub TILEINDEX_RESPAWNING_BUSH_CUT			; $6926
	cp TILEINDEX_RESPAWNING_BUSH_READY - TILEINDEX_RESPAWNING_BUSH_CUT + 1
	ret			; $692a

@positionOffsets:
	.db -13,  0
	.db   4, 17
	.db  13,  0
	.db   4,-17

;;
; @addr{6933}
_dodongo_playStompSoundAtInterval:
	ld e,Enemy.speed		; $6933
	ld a,(de)		; $6935
	cp SPEED_40			; $6936
	ld b,$1f		; $6938
	jr z,+			; $693a
	ld b,$0f		; $693c
+
	ld a,(wFrameCounter)		; $693e
	and b			; $6941
	ret nz			; $6942
	ld a,SND_SCENT_SEED		; $6943
	jp playSound		; $6945

;;
; @param[out]	c	c if Link is at a good angle to charge him
; @addr{6948}
_dodongo_updateAngleTowardLink:
	ld c,$0c		; $6948
	call objectCheckCenteredWithLink		; $694a
	ret nc			; $694d

	call objectGetAngleTowardEnemyTarget		; $694e
	ld b,a			; $6951
	ld e,Enemy.angle		; $6952
	ld a,(de)		; $6954
	sub b			; $6955
	add $04			; $6956
	cp $09			; $6958
	ret			; $695a


;;
; @param[out]	zflag	z if dodongo is ready to continue moving
; @addr{695b}
_dodongo_updateAnimationWhileSlimmingDown:
	ld e,Enemy.var30		; $695b
	ld a,(de)		; $695d
	inc a			; $695e
	ld (de),a		; $695f
	cp $11			; $6960
	ret z			; $6962

	ld l,Enemy.counter2		; $6963
	cp $07			; $6965
	jr c,++			; $6967
	ld (hl),$08		; $6969
	or d			; $696b
	ret			; $696c
++
	ld bc,@counter2Vals		; $696d
	call addAToBc		; $6970
	ld a,(bc)		; $6973
	ld (hl),a ; [counter2]
	or d			; $6975
	ret			; $6976

@counter2Vals:
	.db 180, 20, 20, 16, 16, 10, 10

;;
; @addr{697e}
_dodongo_checkEatBomb:
	; Check bomb 1
	ld c,ITEMID_BOMB		; $697e
	call findItemWithID		; $6980
	jr nz,@animate	; $6983
	call @checkBombInRangeToEat		; $6985
	jr z,@eatBomb	; $6988

	; Check bomb 2
	ld c,ITEMID_BOMB		; $698a
	call findItemWithID_startingAfterH		; $698c
	jr nz,@animate	; $698f
	call @checkBombInRangeToEat		; $6991
	jr z,@eatBomb	; $6994
@animate:
	jp enemyAnimate		; $6996

@eatBomb:
	; Signal bomb's deletion
	ld l,Item.var2f		; $6999
	set 5,(hl)		; $699b

	ld h,d			; $699d
	ld l,Enemy.var30		; $699e
	ld (hl),$00		; $69a0

	ld l,Enemy.collisionType		; $69a2
	res 7,(hl)		; $69a4

	ld l,Enemy.state		; $69a6
	ld (hl),$0d		; $69a8

	ld l,Enemy.direction		; $69aa
	ldd a,(hl)		; $69ac
	ld (hl),120		; $69ad

	add $02			; $69af
	call enemySetAnimation		; $69b1

	ld a,SND_DODONGO_EAT		; $69b4
	jp playSound		; $69b6

;;
; @param	h	Bomb object
; @param[out]	zflag	z if bomb shall be eaten
; @addr{69b9}
@checkBombInRangeToEat:
	; Is bomb being held?
	ld l,Item.var2f		; $69b9
	ld a,(hl)		; $69bb
	bit 6,a			; $69bc
	jr z,@notEaten	; $69be

	; Don't eat if it's exploding or slated for delation?
	and $b0			; $69c0
	jr nz,@notEaten	; $69c2

	; Don't eat if it's being held
	ld l,Item.state2		; $69c4
	ld a,(hl)		; $69c6
	cp $02			; $69c7
	jr c,@notEaten	; $69c9

	; Get position at dodongo's mouth (based on direction it's moving in)
	push hl			; $69cb
	ld e,Enemy.angle		; $69cc
	ld a,(de)		; $69ce
	rrca			; $69cf
	rrca			; $69d0
	ld hl,@positionOffsets		; $69d1
	rst_addAToHl			; $69d4
	ldi a,(hl)		; $69d5
	ld c,(hl)		; $69d6
	ld h,d			; $69d7
	ld l,Enemy.yh		; $69d8
	add (hl)		; $69da
	ld b,a			; $69db
	ld l,Enemy.xh		; $69dc
	ld a,(hl)		; $69de
	add c			; $69df
	ld c,a			; $69e0

	; Check for collision with bomb
	pop hl			; $69e1
	ld l,Item.yh		; $69e2
	ld a,(hl)		; $69e4
	sub b			; $69e5
	add $0c			; $69e6
	cp $19			; $69e8
	jr nc,@notEaten	; $69ea

	ld l,Item.xh		; $69ec
	ld a,(hl)		; $69ee
	sub c			; $69ef
	add $08			; $69f0
	cp $11			; $69f2
	jr nc,@notEaten	; $69f4

	xor a			; $69f6
	ret			; $69f7

@notEaten:
	or d			; $69f8
	ret			; $69f9

@positionOffsets:
	.db -6,  0
	.db  0, 12
	.db 12,  0
	.db  0,-12

;;
; Determines next attack.
; @addr{6a02}
_dodongo_initiateNextAttack:
	ld e,Enemy.var32		; $6a02
	ld a,(de)		; $6a04
	inc a			; $6a05
	and $0f			; $6a06
	ld (de),a		; $6a08
	ld hl,@attackPattern		; $6a09
	call checkFlag		; $6a0c
	ld h,d			; $6a0f
	jr z,@chargeAttack	; $6a10

	; Fireball attack (opening mouth)
	ld l,Enemy.state		; $6a12
	ld (hl),$0b		; $6a14
	ld l,Enemy.direction		; $6a16
	ld a,(hl)		; $6a18
	inc a			; $6a19
	call enemySetAnimation		; $6a1a
	ld a,SND_DODONGO_OPEN_MOUTH		; $6a1d
	jp playSound		; $6a1f

@chargeAttack:
	ld l,Enemy.speed		; $6a22
	ld (hl),SPEED_140		; $6a24
	ld l,Enemy.counter2		; $6a26
	ld (hl),45		; $6a28
	dec l			; $6a2a
	ld (hl),128 ; [counter1]
	ret			; $6a2d

@attackPattern:
	dbrev %01101011, %00010110


;;
; @param[out]	zflag	z if in spikes
; @addr{6a30}
_dodongo_setInvincibilityAndPlaySoundIfInSpikes:
	call _dodongo_checkInSpikes		; $6a30
	ret nz			; $6a33

	ld e,Enemy.invincibilityCounter		; $6a34
	ld a,$30		; $6a36
	ld (de),a		; $6a38
	ld a,SND_BOSS_DAMAGE		; $6a39
	call playSound		; $6a3b
	xor a			; $6a3e
	ret			; $6a3f

;;
; @param[out]	zflag	z if in spikes
; @addr{6a40}
_dodongo_checkInSpikes:
	ld h,d			; $6a40
	ld l,Enemy.zh		; $6a41
	bit 7,(hl)		; $6a43
	ret nz			; $6a45
	ld l,Enemy.yh		; $6a46
	ldi a,(hl)		; $6a48
	add $05			; $6a49
	ld b,a			; $6a4b
	inc l			; $6a4c
	ld c,(hl)		; $6a4d
	call getTileAtPosition		; $6a4e
	cp TILEINDEX_SPIKES			; $6a51
	ret			; $6a53

;;
; @param[out]	zflag	z if king dodongo has regained normal weight and is ready to move
; @addr{6a54}
_dodongo_updateAnimationWhileHeld:
	ld h,d			; $6a54
	ld l,Enemy.counter2		; $6a55
	dec (hl)		; $6a57
	jr nz,++		; $6a58
	call _dodongo_updateAnimationWhileSlimmingDown		; $6a5a
	ret z			; $6a5d
++
	; Update animation based on Link's direction
	ld l,Enemy.var31		; $6a5e
	ld a,(w1Link.direction)		; $6a60
	add a			; $6a63
	add a			; $6a64
	ld b,a			; $6a65
	sub (hl)		; $6a66
	ld (hl),b		; $6a67

	ld l,Enemy.direction		; $6a68
	add (hl)		; $6a6a
	and $0c			; $6a6b
	ld (hl),a		; $6a6d

	call _dodongo_updateAnimation		; $6a6e
	or d			; $6a71
	ret			; $6a72


; ==============================================================================
; ENEMYID_MOTHULA
;
; Variables:
;   var30: Angular speed (amount to add to angle; clockwise / counterclockwise)
;   var31: Index used to decide turning speed while circling around room
;   var32/var33: Target position
;   var34: Counter until mothula stops circling around room
;   var35: Counter to delay updating angle toward target position
;   var36: If nonzero, spawns baby moths instead of ring of fire
;   var37: Counter until mothula will shoot a fireball (while circling around room)
; ==============================================================================
enemyCode7a:
	jr z,@normalStatus	; $6a73
	sub ENEMYSTATUS_NO_HEALTH			; $6a75
	ret c			; $6a77
	jr z,@dead	; $6a78

@normalStatus:
	ld e,Enemy.state		; $6a7a
	ld a,(de)		; $6a7c
	rst_jumpTable			; $6a7d
	.dw _mothula_state_uninitialized
	.dw _mothula_state_stub
	.dw _mothula_state_stub
	.dw _mothula_state_stub
	.dw _mothula_state_stub
	.dw _mothula_state_stub
	.dw _mothula_state_stub
	.dw _mothula_state_stub
	.dw _mothula_state8
	.dw _mothula_state9
	.dw _mothula_stateA
	.dw _mothula_stateB
	.dw _mothula_stateC
	.dw _mothula_stateD
	.dw _mothula_stateE
	.dw _mothula_stateF

@dead:
	call getThisRoomFlags		; $6a9e
	set 7,(hl)		; $6aa1

	; Set bit 7 of room flag in room 1 floor below
	ld a,(wDungeonFlagsAddressH)		; $6aa3
	ld h,a			; $6aa6
	ld l,$43		; $6aa7
	set 7,(hl)		; $6aa9
	jp _enemyBoss_dead		; $6aab


_mothula_state_uninitialized:
	ld a,ENEMYID_MOTHULA		; $6aae
	ld b,SEASONS_PALH_82		; $6ab0
	call _enemyBoss_initializeRoom		; $6ab2

	ld bc,$0108		; $6ab5
	call _enemyBoss_spawnShadow		; $6ab8
	ret nz			; $6abb

	call _ecom_setSpeedAndState8		; $6abc
	ld c,$10		; $6abf
	jp _ecom_setZAboveScreen		; $6ac1


_mothula_state_stub:
	ret			; $6ac4


_mothula_state8:
	call objectSetVisible81		; $6ac5

	ld a,(wFrameCounter)		; $6ac8
	and $1f			; $6acb
	ld a,SND_AQUAMENTUS_HOVER		; $6acd
	call z,playSound		; $6acf

	; Move down
	ld c,$04		; $6ad2
	call objectUpdateSpeedZ_paramC		; $6ad4
	ld l,Enemy.zh		; $6ad7
	ld a,(hl)		; $6ad9
	cp $fe			; $6ada
	jr c,_mothula_animate	; $6adc

	; Reached ground
	ld l,Enemy.state		; $6ade
	inc (hl) ; [state] = 9

	ld l,Enemy.counter1		; $6ae1
	ld (hl),60		; $6ae3
	call _mothula_setTargetPositionToLeftOrRightSide		; $6ae5

	ld a,MUS_BOSS		; $6ae8
	ld (wActiveMusic),a		; $6aea
	jp playSound		; $6aed


; Delay before moving
_mothula_state9:
	call _ecom_decCounter1		; $6af0
	jr nz,_mothula_animate	; $6af3

	inc l			; $6af5
	ld (hl),10 ; [counter2]
	ld l,e			; $6af8
	inc (hl) ; [state] = $0a
	call _mothula_spawnChild		; $6afa


; Just beginning to move
_mothula_stateA:
	call _mothula_checkReachedTargetPosition		; $6afd
	jr nc,_mothula_moveTowardTargetPosition	; $6b00

	ld l,Enemy.state		; $6b02
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter1		; $6b05
	ld (hl),14
	ld l,Enemy.var37		; $6b09
	ld (hl),$50		; $6b0b

	call _mothula_initializeStateB		; $6b0d
	jr _mothula_stateB		; $6b10


; Circling around normally
_mothula_stateB:
	call _mothula_decVar34Every4Frames		; $6b12
	jr nz,@circlingAround	; $6b15

	; Time to return to center of room (state $0c)
	ld l,e			; $6b17
	inc (hl) ; [state] = $0c
	ld l,Enemy.counter1		; $6b19
	ld (hl),$00		; $6b1b

	call _mothula_chooseTargetPositionWithinHoles		; $6b1d
	jr _mothula_animate		; $6b20

@circlingAround:
	ld h,d			; $6b22
	ld l,Enemy.var37		; $6b23
	dec (hl)		; $6b25
	call z,_mothula_spawnFireball		; $6b26

	; Increase speed every 10 frames
	call _ecom_decCounter2		; $6b29
	jr nz,+++		; $6b2c

	ld (hl),10 ; [counter2]
	ld l,Enemy.speed		; $6b30
	ld a,(hl)		; $6b32
	add SPEED_40			; $6b33
	cp SPEED_300 + 1			; $6b35
	jr nc,+++		; $6b37
	ld (hl),a		; $6b39
+++
	call _ecom_decCounter1		; $6b3a
	jr nz,_mothula_applySpeedAndAnimate	; $6b3d

	; Turn clockwise or counterclockwise
	ld l,Enemy.var30		; $6b3f
	ld e,Enemy.angle		; $6b41
	ld a,(de)		; $6b43
	add (hl)		; $6b44
	and $1f			; $6b45
	ld (de),a		; $6b47
	call _mothula_updateAnimation		; $6b48
	call _mothula_updateCounter1ForCirclingRoom		; $6b4b
	jr nz,_mothula_applySpeedAndAnimate	; $6b4e

	ld e,Enemy.var31		; $6b50
	ld a,$0e		; $6b52
	ld (de),a		; $6b54
	call _mothula_updateCounter1ForCirclingRoom		; $6b55

_mothula_applySpeedAndAnimate:
	call objectApplySpeed		; $6b58
_mothula_animate:
	jp enemyAnimate		; $6b5b


; Returning to one of the two center spots
_mothula_stateC:
	call _mothula_checkReachedTargetPosition		; $6b5e
	jr nc,_mothula_moveTowardTargetPosition	; $6b61

	ld l,Enemy.state		; $6b63
	inc (hl) ; [state] = $0d
	xor a			; $6b66
	jp enemySetAnimation		; $6b67


_mothula_moveTowardTargetPosition:
	call _mothula_updateAngleTowardTargetPosition		; $6b6a
	jr _mothula_applySpeedAndAnimate		; $6b6d


; Deciding how long to stand in place?
_mothula_stateD:
	ld h,d			; $6b6f
	ld l,e			; $6b70
	inc (hl) ; [state] = $0e

	ld bc,$0840		; $6b72
	call _ecom_randomBitwiseAndBCE		; $6b75
	ld e,Enemy.var36		; $6b78
	ld a,b			; $6b7a
	ld (de),a		; $6b7b

	ld e,Enemy.counter1		; $6b7c
	ld a,120		; $6b7e
	add c			; $6b80
	ld (de),a		; $6b81
	jr _mothula_animate		; $6b82


; Standing in place
_mothula_stateE:
	call _ecom_decCounter1		; $6b84
	jr z,++			; $6b87
	call _mothula_updateZPosAndOamFlagsForStateE		; $6b89
	jr _mothula_animate		; $6b8c
++
	inc l			; $6b8e
	ld (hl),30 ; [counter1]
	ld l,e			; $6b91
	inc (hl) ; [state] = $0f

	ld l,Enemy.zh		; $6b93
	ld (hl),$fe		; $6b95

	ld l,Enemy.oamFlags		; $6b97
	ld a,$06		; $6b99
	ldd (hl),a		; $6b9b
	ld (hl),a		; $6b9c

	call _mothula_spawnSomethingAfterStandingStill		; $6b9d
	ld a,$08		; $6ba0
	jp enemySetAnimation		; $6ba2


; Delay before circling around room again
_mothula_stateF:
	call _ecom_decCounter2		; $6ba5
	jr nz,_mothula_animate	; $6ba8

	ld l,e			; $6baa
	ld (hl),$0a ; [state] = $0a

	ld l,Enemy.counter2		; $6bad
	ld (hl),10		; $6baf
	dec l			; $6bb1
	ld (hl),$00 ; [counter1]

	jp _mothula_setTargetPositionToLeftOrRightSide		; $6bb4


;;
; @param	hl	var37 (counter to spawn projectile)
; @addr{6bb7}
_mothula_spawnFireball:
	ld (hl),$50		; $6bb7
	ld b,PARTID_MOTHULA_PROJECTILE_1		; $6bb9
	jp _ecom_spawnProjectile		; $6bbb

;;
; Decides what to spawn after state $0e (small moth or ring of fireballs).
; @addr{6bbe}
_mothula_spawnSomethingAfterStandingStill:
	ld e,Enemy.var36		; $6bbe
	ld a,(de)		; $6bc0
	or a			; $6bc1
	jr nz,_mothula_spawnChild	; $6bc2

	ld b,PARTID_MOTHULA_PROJECTILE_2		; $6bc4
	call _ecom_spawnProjectile		; $6bc6
	ret nz			; $6bc9

	ld l,Part.subid		; $6bca

;;
; Sets child object's subid to $80 normally, or $81 if mothula's health is $10 or less
;
; @param	hl	Pointer to child object's subid
; @addr{6bcc}
_mothula_initChild:
	ld b,$80		; $6bcc
	ld e,Enemy.health		; $6bce
	ld a,(de)		; $6bd0
	cp $10			; $6bd1
	jr nc,+			; $6bd3
	inc b			; $6bd5
+
	ld (hl),b		; $6bd6
	ret			; $6bd7

;;
; @addr{6bd8}
_mothula_spawnChild:
	ld b,ENEMYID_MOTHULA_CHILD		; $6bd8
	call _ecom_spawnUncountedEnemyWithSubid01		; $6bda
	ret nz			; $6bdd
	call _mothula_initChild		; $6bde
	jp objectCopyPosition		; $6be1

;;
; Update mothula "bouncing" in place for state $0e
;
; @param	hl	counter1
; @addr{6be4}
_mothula_updateZPosAndOamFlagsForStateE:
	ld a,(hl)		; $6be4
	cp 90			; $6be5
	ret nc			; $6be7

	and $0e			; $6be8
	rrca			; $6bea
	ld bc,@zPositions		; $6beb
	call addAToBc		; $6bee

	ld l,Enemy.zh		; $6bf1
	ld a,(bc)		; $6bf3
	ld (hl),a		; $6bf4

	ld l,Enemy.var36		; $6bf5
	ld b,(hl)		; $6bf7
	srl b			; $6bf8
	srl b			; $6bfa
	ld l,Enemy.counter1		; $6bfc
	ld a,(hl)		; $6bfe
	and $01			; $6bff
	add b			; $6c01
	ld bc,@oamFlags		; $6c02
	call addAToBc		; $6c05
	ld l,Enemy.oamFlags		; $6c08
	ld a,(bc)		; $6c0a
	ldd (hl),a		; $6c0b
	ld (hl),a		; $6c0c
	ret			; $6c0d

@zPositions:
	.db $ff $fe $fd $fc $fb $fc $fd $fe

@oamFlags:
	.db $06 $04 ; Spawning baby moths
	.db $06 $05 ; Spawning ring of fire


;;
; @param[out]	cflag	c if reached target position
; @addr{6c1a}
_mothula_checkReachedTargetPosition:
	ld h,d			; $6c1a
	ld l,Enemy.var32		; $6c1b
	call _ecom_readPositionVars		; $6c1d
	sub c			; $6c20
	add $04			; $6c21
	cp $09			; $6c23
	ret nc			; $6c25
	ldh a,(<hFF8F)	; $6c26
	sub b			; $6c28
	add $04			; $6c29
	cp $09			; $6c2b
	ret			; $6c2d


;;
; @addr{6c2e}
_mothula_setTargetPositionToLeftOrRightSide:
	call getRandomNumber_noPreserveVars		; $6c2e
	and $01			; $6c31
	jr nz,+			; $6c33
	dec a			; $6c35
+
	ld h,d			; $6c36
	ld l,Enemy.var30		; $6c37
	ld (hl),a		; $6c39

	ld a,$32		; $6c3a
	ld b,$ba		; $6c3c
	bit 7,(hl)		; $6c3e
	jr z,+			; $6c40
	ld b,$36		; $6c42
+
	ld l,Enemy.var32		; $6c44
	ldi (hl),a		; $6c46
	ld (hl),b		; $6c47

	ld l,Enemy.angle		; $6c48
	ld (hl),$00		; $6c4a
	ld l,Enemy.speed		; $6c4c
	ld (hl),SPEED_100		; $6c4e

	ld l,Enemy.var31		; $6c50
	ld (hl),$00		; $6c52
	ld l,Enemy.var35		; $6c54
	ld (hl),$06		; $6c56
	jr _mothula_updateAnimation		; $6c58

;;
; Chooses a position in one of the two center areas
; @addr{6c5a}
_mothula_chooseTargetPositionWithinHoles:
	call getRandomNumber_noPreserveVars		; $6c5a
	rrca			; $6c5d
	ld a,$50		; $6c5e
	ld b,$68		; $6c60
	jr c,+			; $6c62
	ld b,$88		; $6c64
+
	ld h,d			; $6c66
	ld l,Enemy.var32		; $6c67
	ldi (hl),a		; $6c69
	ld (hl),b		; $6c6a
	ld l,Enemy.speed		; $6c6b
	ld (hl),SPEED_100		; $6c6d
	ret			; $6c6f

;;
; @addr{6c70}
_mothula_updateAngleTowardTargetPosition:
	ld h,d			; $6c70
	ld l,Enemy.var35		; $6c71
	dec (hl)		; $6c73
	ret nz			; $6c74

	ld (hl),$06		; $6c75

	call objectGetRelativeAngleWithTempVars		; $6c77
	ld c,a			; $6c7a
	call objectNudgeAngleTowards		; $6c7b

;;
; @addr{6c7e}
_mothula_updateAnimation:
	ld h,d			; $6c7e
	ld l,Enemy.angle		; $6c7f
	ldd a,(hl)		; $6c81
	add $02			; $6c82
	and $1c			; $6c84
	rrca			; $6c86
	rrca			; $6c87
	cp (hl) ; [direction]
	ret z			; $6c89
	ld (hl),a		; $6c8a
	jp enemySetAnimation		; $6c8b

;;
; Updates counter1 to decide how long until the angle will next be updated. This allows
; mothula to move in an oval pattern.
;
; @param[out]	zflag	z if completed a full circle (var31 should be reset)
; @addr{6c8e}
_mothula_updateCounter1ForCirclingRoom:
	ld h,d			; $6c8e
	ld l,Enemy.var31		; $6c8f
	ld a,(hl)		; $6c91
	inc (hl)		; $6c92
	ld b,a			; $6c93
	srl a			; $6c94
	ld hl,@counterVals		; $6c96
	rst_addAToHl			; $6c99
	ld a,(hl)		; $6c9a
	rrc b			; $6c9b
	jr c,+			; $6c9d
	swap a			; $6c9f
+
	and $0f			; $6ca1
	ret z			; $6ca3
	ld e,Enemy.counter1		; $6ca4
	ld (de),a		; $6ca6
	ret			; $6ca7

; Each half-byte is a value for counter1, determining how fast mothula turns at various
; points during her movement.
@counterVals:
	.db $33 $48 $55 $66 $77 $7f $55 $54
	.db $32 $36 $32 $34 $55 $8f $76 $00


;;
; @param[out]	zflag	z if var34 reached 0
; @addr{6cb8}
_mothula_decVar34Every4Frames:
	ld a,(wFrameCounter)		; $6cb8
	and $03			; $6cbb
	ret nz			; $6cbd
	ld h,d			; $6cbe
	ld l,Enemy.var34		; $6cbf
	dec (hl)		; $6cc1
	ret			; $6cc2


;;
; Calculates appropriate angle, and decides how long to remain in state $0b (circling
; around room).
; @addr{6cc3}
_mothula_initializeStateB:
	call getRandomNumber_noPreserveVars		; $6cc3
	and $03			; $6cc6
	ld hl,@var34Vals		; $6cc8
	rst_addAToHl			; $6ccb
	ld e,Enemy.var34		; $6ccc
	ld a,(hl)		; $6cce
	ld (de),a		; $6ccf

	ld e,Enemy.var30		; $6cd0
	ld a,(de)		; $6cd2
	dec a			; $6cd3
	ld a,$0c		; $6cd4
	jr z,+			; $6cd6
	ld a,$14		; $6cd8
+
	ld e,Enemy.angle		; $6cda
	ld (de),a		; $6cdc
	jr _mothula_updateAnimation		; $6cdd

; Potential lengths of time for Mothula to circle around the room
@var34Vals:
	.db $35 $5b $5b $82


; ==============================================================================
; ENEMYID_GOHMA
;
; Variables for subid 1 (main body):
;   relatedObj2: Reference to subid 3 (claw)
;   var30: ?
;   var31: Affects animation?
;   var32: Number of "children" spawned (ENEMYID_GOHMA_GEL)
;
; Variables for subid 2 (body hitbox):
;   relatedObj1: Reference to subid 1
;
; Variables for subid 3 (claw):
;   relatedObj1: Reference to subid 1
;   var30: Nonzero if Link was caught?
; ==============================================================================
enemyCode7b:
	jr z,@normalStatus	; $6ce3
	sub ENEMYSTATUS_NO_HEALTH			; $6ce5
	ret c			; $6ce7
	jr nz,@collisionOccurred	; $6ce8

	; Health is 0 (might just be moving to next phase)
	ld e,Enemy.subid		; $6cea
	ld a,(de)		; $6cec
	dec a			; $6ced
	jp z,_gohma_subid1_dead		; $6cee

	ld e,Enemy.animParameter		; $6cf1
	ld a,(de)		; $6cf3
	cp $80			; $6cf4
	jp nz,_gohma_subid3_dead		; $6cf6

	ld a,Object.health		; $6cf9
	call objectGetRelatedObject1Var		; $6cfb
	ld a,(hl)		; $6cfe
	or a			; $6cff
	jr z,++			; $6d00
	ld (hl),10		; $6d02
	ld l,Enemy.state		; $6d04
	inc (hl)		; $6d06
	inc l			; $6d07
	ld (hl),$00		; $6d08
++
	jp enemyDie_uncounted		; $6d0a

@collisionOccurred:
	ld e,Enemy.subid		; $6d0d
	ld a,(de)		; $6d0f
	cp $01			; $6d10
	jr nz,++		; $6d12

	ld a,Object.id		; $6d14
	call objectGetRelatedObject2Var		; $6d16
	ld a,(hl)		; $6d19
	cp ENEMYID_GOHMA			; $6d1a
	jr nz,@normalStatus	; $6d1c

	ld l,Enemy.invincibilityCounter		; $6d1e
	ld e,l			; $6d20
	ld a,(de)		; $6d21
	ld (hl),a		; $6d22
	jr @normalStatus		; $6d23
++
	cp $03			; $6d25
	jr nz,@normalStatus	; $6d27

	ld e,Enemy.var2a		; $6d29
	ld a,(de)		; $6d2b
	res 7,a			; $6d2c
	cp ITEMCOLLISION_L1_SWORD			; $6d2e
	jr nc,@normalStatus	; $6d30

	; Link or shield collision
	ld e,Enemy.enemyCollisionMode		; $6d32
	ld a,(de)		; $6d34
	cp ENEMYCOLLISION_GOHMA_CLAW_LUNGING			; $6d35
	jr nz,@normalStatus	; $6d37

	ld e,Enemy.var30		; $6d39
	ld a,$01		; $6d3b
	ld (de),a		; $6d3d

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $6d3e
	jr nc,@state8OrHigher	; $6d41
	rst_jumpTable			; $6d43
	.dw _gohma_state_uninitialized
	.dw _gohma_state_spawner
	.dw _gohma_state_stub
	.dw _gohma_state_stub
	.dw _gohma_state_stub
	.dw _gohma_state_stub
	.dw _gohma_state_stub
	.dw _gohma_state_stub

@state8OrHigher:
	dec b			; $6d54
	ld a,b			; $6d55
	rst_jumpTable			; $6d56
	.dw _gohma_subid1
	.dw _gohma_subid2
	.dw _gohma_subid3


_gohma_state_uninitialized:
	ld a,b			; $6d5d
	or a			; $6d5e
	jp nz,_ecom_setSpeedAndState8		; $6d5f

	; Subid 0
	inc a			; $6d62
	ld (de),a ; [state] = 1
	ld a,ENEMYID_GOHMA		; $6d64
	call _enemyBoss_initializeRoom		; $6d66


_gohma_state_spawner:
	ld b,$03		; $6d69
	call checkBEnemySlotsAvailable		; $6d6b
	ret nz			; $6d6e

	ld b,ENEMYID_GOHMA		; $6d6f
	call _ecom_spawnUncountedEnemyWithSubid01		; $6d71
	call objectCopyPosition		; $6d74

	ld l,Enemy.enabled		; $6d77
	ld e,l			; $6d79
	ld a,(de)		; $6d7a
	ld (hl),a		; $6d7b

	ld c,h			; $6d7c
	ld e,$02		; $6d7d
	call @spawnChild		; $6d7f

	ld e,$03		; $6d82
	call @spawnChild		; $6d84

	ld a,h			; $6d87
	ld h,c			; $6d88
	ld l,Enemy.relatedObj2+1		; $6d89
	ldd (hl),a		; $6d8b
	ld (hl),$80		; $6d8c
	jp enemyDelete		; $6d8e

@spawnChild:
	call _ecom_spawnUncountedEnemyWithSubid01		; $6d91
	ld (hl),e ; [subid] = e
	ld l,Enemy.relatedObj1		; $6d95
	ld a,Enemy.start		; $6d97
	ldi (hl),a		; $6d99
	ld (hl),c		; $6d9a
	ret			; $6d9b


_gohma_state_stub:
	ret			; $6d9c


; Main body
_gohma_subid1:
	ld a,(de) ; [state]
	sub $08			; $6d9e
	rst_jumpTable			; $6da0
	.dw _gohma_subid1_state8
	.dw _gohma_subid1_state9
	.dw _gohma_subid1_stateA
	.dw _gohma_subid1_stateB
	.dw _gohma_subid1_stateC
	.dw _gohma_subid1_stateD


; Initialization
_gohma_subid1_state8:
	ld bc,$0208		; $6dad
	call _enemyBoss_spawnShadow		; $6db0
	ret nz			; $6db3

	ld h,d			; $6db4
	ld l,Enemy.state		; $6db5
	inc (hl) ; [state] = 9

	ld l,Enemy.enemyCollisionMode		; $6db8
	ld (hl),ENEMYCOLLISION_GOHMA_BODY		; $6dba

	ld l,Enemy.counter1		; $6dbc
	ld (hl),30		; $6dbe
	ld l,Enemy.var31		; $6dc0
	ld (hl),$02		; $6dc2

	ld c,$08		; $6dc4
	jp _ecom_setZAboveScreen		; $6dc6


; Following Link from the ceiling
_gohma_subid1_state9:
	call _ecom_decCounter1		; $6dc9
	jr nz,@updatePosition	; $6dcc

	ld (hl),30 ; [counter1]
	ld c,$28		; $6dd0
	call objectCheckLinkWithinDistance		; $6dd2
	jr nc,@updatePosition	; $6dd5

	; Time to fall down
	ld l,Enemy.state		; $6dd7
	inc (hl) ; [state] = $0a

	ld a,Object.visible		; $6dda
	call objectGetRelatedObject2Var		; $6ddc
	set 7,(hl)		; $6ddf

	call objectSetVisible81		; $6de1
	ld c,$08		; $6de4
	call _ecom_setZAboveScreen		; $6de6

@updatePosition:
	call _ecom_updateCardinalAngleTowardTarget		; $6de9
	call _gohma_updateSpeedWhileFalling		; $6dec
	call objectApplySpeed		; $6def

	; Check that x-position is contained in the room
	ld e,Enemy.xh		; $6df2
	ld a,(de)		; $6df4
	cp $20			; $6df5
	jr nc,++		; $6df7
	ld a,$20		; $6df9
	ld (de),a		; $6dfb
	ret			; $6dfc
++
	cp $d0			; $6dfd
	ret c			; $6dff
	ld a,$d0		; $6e00
	ld (de),a		; $6e02
	ret			; $6e03


; Falling down
_gohma_subid1_stateA:
	ld c,$10		; $6e04
	call objectUpdateSpeedZ_paramC		; $6e06
	jr z,@hitGround	; $6e09

	ld a,(de)		; $6e0b
	cp $f9			; $6e0c
	ret c			; $6e0e
	ld a,$02		; $6e0f
	jp _gohma_setAnimation		; $6e11

@hitGround:
	ld l,Enemy.state		; $6e14
	inc (hl) ; [state] = $0b
	ld l,Enemy.counter1		; $6e17
	ld (hl),60		; $6e19

	ld a,MUS_BOSS		; $6e1b
	ld (wActiveMusic),a		; $6e1d
	call playSound		; $6e20
	ld a,SND_STRONG_POUND		; $6e23
	call playSound		; $6e25

	ld a,$28		; $6e28
	call setScreenShakeCounter		; $6e2a
	jp objectSetVisible83		; $6e2d


; Standing in place
_gohma_subid1_stateB:
	call _ecom_decCounter1		; $6e30
	ret nz			; $6e33

	inc (hl) ; [counter1] = 1
	ld l,e			; $6e35
	inc (hl) ; [state] = $0c

	ld l,Enemy.var30		; $6e37
	ld (hl),45		; $6e39
	ret			; $6e3b


; Phase 1 of fight: claw still intact
_gohma_subid1_stateC:
	call _gohma_subid1_updateAnimationsAndCollisions		; $6e3c
	ld e,Enemy.state2		; $6e3f
	ld a,(de)		; $6e41
	rst_jumpTable			; $6e42
	.dw @substate0
	.dw @substate1
	.dw _gohma_stateC_substate2
	.dw _gohma_stateC_substate3
	.dw _gohma_stateC_substate4

; Standing in place before deciding which way to move
@substate0:
	call _ecom_decCounter1		; $6e4d
	ret nz			; $6e50
	ld l,e			; $6e51
	inc (hl) ; [state2] = 1
	call _gohma_phase1_decideAngle		; $6e53
	call _gohma_decideMovementDuration		; $6e56
	call _gohma_decideAnimation		; $6e59
	jp _gohma_updateSpeedWhileFalling		; $6e5c

; Walking in some direction
@substate1:
	call enemyAnimate		; $6e5f
	call _ecom_decCounter2		; $6e62

	; Jump if Link is in front of gohma within $28 pixels?
	ld h,d			; $6e65
	ld l,Enemy.yh		; $6e66
	ld a,(w1Link.yh)		; $6e68
	sub (hl)		; $6e6b
	cp $28			; $6e6c
	jr nc,_gohma_movingNormally	; $6e6e

	; Jump if Link isn't close to gohma horizontally
	ld l,Enemy.xh		; $6e70
	ld a,(w1Link.xh)		; $6e72
	sub (hl)		; $6e75
	add $18			; $6e76
	cp $25			; $6e78
	jr nc,_gohma_movingNormally	; $6e7a

	; Charge at Link if counter2 is zero?
	ld l,Enemy.counter2		; $6e7c
	ld a,(hl)		; $6e7e
	or a			; $6e7f
	jr z,_gohma_beginLungeTowardLink	; $6e80

_gohma_movingNormally:
	call _gohma_checkWallsAndPlayWalkingSound		; $6e82
	call _ecom_decCounter1		; $6e85
	ret nz			; $6e88

	; [state2] = 0 (stop moving for a moment)
	ld l,Enemy.state2		; $6e89
	dec (hl)		; $6e8b
	call getRandomNumber_noPreserveVars		; $6e8c
	and $07			; $6e8f
	ld hl,_gohma_counter1Vals		; $6e91
	rst_addAToHl			; $6e94
	ld e,Enemy.counter1		; $6e95
	ld a,(hl)		; $6e97
	ld (de),a		; $6e98
	ret			; $6e99

_gohma_beginLungeTowardLink:
	ld l,Enemy.state2		; $6e9a
	inc (hl) ; [state2] = 2
	inc l			; $6e9d
	ld (hl),31 ; [counter1]

	ld l,Enemy.speed		; $6ea0
	ld (hl),SPEED_300		; $6ea2

	; Check if claw was destroyed?
	ld a,Object.health		; $6ea4
	call objectGetRelatedObject2Var		; $6ea6
	ld a,(hl)		; $6ea9
	or a			; $6eaa
	jr z,++			; $6eab

	ld l,Enemy.state		; $6ead
	ld (hl),$0c		; $6eaf
	ld l,Enemy.collisionType		; $6eb1
	set 7,(hl)		; $6eb3
++
	ld a,$09		; $6eb5

_gohma_setAnimation:
	ld e,Enemy.direction		; $6eb7
	ld (de),a		; $6eb9
	jp enemySetAnimation		; $6eba


; Lunging toward Link (or moving back) with claw
_gohma_stateC_substate2:
	call enemyAnimate		; $6ebd
	ld e,Enemy.animParameter		; $6ec0
	ld a,(de)		; $6ec2
	inc a			; $6ec3
	jr z,@doneLunge			; $6ec4

	res 7,a			; $6ec6
	dec a			; $6ec8
	ret z			; $6ec9
	jp _gohma_updateLunge		; $6eca

@doneLunge:
	; Check if grabbed Link
	ld a,(w1Link.state)		; $6ecd
	cp LINK_STATE_GRABBED			; $6ed0
	jr z,_gohma_stateC_setSubstate4			; $6ed2

	ld h,d			; $6ed4
	ld l,Enemy.state2		; $6ed5
	inc (hl) ; [state2] = 3
	inc l			; $6ed8
	ld (hl),20 ; [counter1]
	ret			; $6edb

; Grabbed Link
_gohma_stateC_setSubstate4:
	ld e,Enemy.state2		; $6edc
	ld a,$04		; $6ede
	ld (de),a		; $6ee0
	ld a,$0a		; $6ee1
	jr _gohma_setAnimation		; $6ee3


; Standing in place after lunge
_gohma_stateC_substate3:
	ld a,(w1Link.state)		; $6ee5
	cp LINK_STATE_GRABBED			; $6ee8
	jr z,_gohma_stateC_setSubstate4			; $6eea

	call _ecom_decCounter1		; $6eec
	ret nz			; $6eef

	inc (hl) ; [counter1] = 1
	inc l			; $6ef1
	ld (hl),40 ; [counter2]

	ld l,e			; $6ef4
	ld (hl),$00 ; [state2]

	ld l,Enemy.var31		; $6ef7
	ld (hl),$02		; $6ef9
	ret			; $6efb


; Holding Link
_gohma_stateC_substate4:
	call enemyAnimate		; $6efc
	ld h,d			; $6eff
	ld l,Enemy.animParameter		; $6f00
	bit 7,(hl)		; $6f02
	ret z			; $6f04

	ld l,Enemy.state2		; $6f05
	ld (hl),$00		; $6f07
	inc l			; $6f09
	ld (hl),60 ; [counter1]

	ld l,Enemy.var31		; $6f0c
	ld (hl),$02		; $6f0e
	ret			; $6f10


; Phase 2 of fight: claw destroyed
_gohma_subid1_stateD:
	call _gohma_subid1_updateAnimationsAndCollisions		; $6f11
	ld e,Enemy.state2		; $6f14
	ld a,(de)		; $6f16
	rst_jumpTable			; $6f17
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call getRandomNumber_noPreserveVars		; $6f1e
	and $03			; $6f21
	jr nz,@chooseNextMovement	; $6f23

	ld h,d			; $6f25
	ld l,Enemy.var32		; $6f26
	ld a,(hl)		; $6f28
	cp $05			; $6f29
	jr nc,@chooseNextMovement	; $6f2b

	ld l,Enemy.state2		; $6f2d
	ld (hl),$02		; $6f2f
	inc l			; $6f31
	ld (hl),$01 ; [counter1]

	ld a,$0b		; $6f34
	jp _gohma_setAnimation		; $6f36

@chooseNextMovement:
	call _ecom_setRandomCardinalAngle		; $6f39
	ld e,Enemy.state2		; $6f3c
	ld a,$01		; $6f3e
	ld (de),a		; $6f40
	call _gohma_decideMovementDuration		; $6f41
	call _gohma_decideAnimation		; $6f44
	jp _gohma_updateSpeedWhileFalling		; $6f47


@substate1:
	call enemyAnimate		; $6f4a
	jp _gohma_movingNormally		; $6f4d

@substate2:
	ld e,Enemy.animParameter		; $6f50
	ld a,(de)		; $6f52
	inc a			; $6f53
	jr z,@chooseNextMovement	; $6f54

	res 7,a			; $6f56
	dec a			; $6f58
	jr z,@animate		; $6f59
	call _ecom_decCounter1		; $6f5b
	call z,_gohma_phase2_spawnGelChild		; $6f5e
@animate:
	jp enemyAnimate		; $6f61


; Collision box for body?
_gohma_subid2:
	ld a,(de)		; $6f64
	sub $08			; $6f65
	rst_jumpTable			; $6f67
	.dw @state8
	.dw @state9

@state8:
	ld h,d			; $6f6c
	ld l,e			; $6f6d
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $6f6f
	set 7,(hl)		; $6f71

	; Save id in var30 (never actually used though?)
	ld a,Object.id		; $6f73
	call objectGetRelatedObject1Var		; $6f75
	ld e,Enemy.var30		; $6f78
	ld a,(hl)		; $6f7a
	ld (de),a		; $6f7b

@state9:
	ld a,Object.health		; $6f7c
	call objectGetRelatedObject1Var		; $6f7e
	ld a,(hl)		; $6f81
	or a			; $6f82
	jp z,enemyDelete		; $6f83

	; Copy position of parent
	ld bc,$ff00		; $6f86
	ld a,Object.enabled		; $6f89
	call objectGetRelatedObject1Var		; $6f8b
	jp objectTakePositionWithOffset		; $6f8e


; Claw
_gohma_subid3:
	ld a,(de)		; $6f91
	sub $08			; $6f92
	rst_jumpTable			; $6f94
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE
	.dw @stateF

; Uninitialized
@state8:
	ld a,$09		; $6fa5
	ld (de),a ; [state]

	call objectSetVisible81		; $6fa8
	call objectSetInvisible		; $6fab
	ld a,$0c		; $6fae
	jp enemySetAnimation		; $6fb0


; Falling from ceiling along with main body
@state9:
	ld a,Object.state		; $6fb3
	call objectGetRelatedObject1Var		; $6fb5
	ld a,(hl)		; $6fb8
	cp $0a			; $6fb9
	jr z,@falling	; $6fbb
	ret c			; $6fbd

	; Landed
	ld h,d			; $6fbe
	ld l,Enemy.state		; $6fbf
	inc (hl)		; $6fc1

	ld l,Enemy.enemyCollisionMode		; $6fc2
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW		; $6fc4
	ld l,Enemy.zh		; $6fc6
	ld (hl),$00		; $6fc8
	jp objectSetVisible82		; $6fca

@falling:
	ld l,Enemy.zh		; $6fcd
	ld a,(hl)		; $6fcf
	cp $f9			; $6fd0
	jr nc,@closeToGround	; $6fd2

	ld bc,$f806		; $6fd4
	jp objectTakePositionWithOffset		; $6fd7

@closeToGround:
	ld a,$0d		; $6fda
	call enemySetAnimation		; $6fdc
	jr @updateNormalPosition		; $6fdf


; Standing in place
@stateA:
	call _gohma_checkShouldBlock		; $6fe1
	call _gohma_updateCollisionsEnabled		; $6fe4
	call @updateNormalPosition		; $6fe7
	jp enemyAnimate		; $6fea


; Blocking eye with claw
@stateB:
	call _ecom_decCounter1		; $6fed
	jp nz,_gohma_claw_updateBlockingPosition		; $6ff0

@gotoStateA:
	ld h,d			; $6ff3
	ld l,Enemy.state		; $6ff4
	ld (hl),$0a		; $6ff6
	ld l,Enemy.enemyCollisionMode		; $6ff8
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW		; $6ffa
	ld a,$0d		; $6ffc
	call enemySetAnimation		; $6ffe

@updateNormalPosition:
	ld bc,$08fa		; $7001
	ld a,Object.start		; $7004
	call objectGetRelatedObject1Var		; $7006
	jp objectTakePositionWithOffset		; $7009


; Beginning attack with claw (being held behind gohma)
@stateC:
	ld h,d			; $700c
	ld l,e			; $700d
	inc (hl) ; [state] = $0c

	ld l,Enemy.var30		; $700f
	ld (hl),$00		; $7011

	ld a,$0f		; $7013
	call enemySetAnimation		; $7015

	ld a,SND_SWORDSLASH		; $7018
	call playSound		; $701a

	jp _gohma_claw_updatePositionInLunge		; $701d


; Claw in the process of attacking
@stateD:
	call enemyAnimate		; $7020

	ld h,d			; $7023
	ld l,Enemy.animParameter		; $7024
	bit 7,(hl)		; $7026
	jr nz,@label_0e_308	; $7028

	bit 0,(hl)		; $702a
	jr z,++			; $702c

	res 0,(hl)		; $702e
	ld l,Enemy.enemyCollisionMode		; $7030
	ld (hl),ENEMYCOLLISION_GOHMA_CLAW_LUNGING		; $7032
++
	call _gohma_claw_updatePositionInLunge		; $7034
	ld e,Enemy.var30		; $7037
	ld a,(de)		; $7039
	or a			; $703a
	ret z			; $703b
	jr @linkCaught		; $703c

@label_0e_308:
	ld e,Enemy.var30		; $703e
	ld a,(de)		; $7040
	or a			; $7041
	jp z,@gotoStateA		; $7042

	xor a			; $7045
	call _gohma_claw_setPositionInLunge		; $7046

@linkCaught:
	ld a,$10		; $7049
	call enemySetAnimation		; $704b

	; Mess with Link's animation?
	ld hl,w1Link.var31		; $704e
	ld (hl),$0d		; $7051
	ld l,<w1Link.animMode		; $7053
	ld (hl),$00		; $7055

	ld l,SpecialObject.collisionType		; $7057
	res 7,(hl)		; $7059

	ld h,d			; $705b
	ld l,Enemy.state		; $705c
	inc (hl) ; [state] = $0e

	ld l,Enemy.animParameter		; $705f
	ld (hl),$08		; $7061
	jr @updateLinkPosition		; $7063


; Claw grabbed Link and is pulling him back
@stateE:
	; Wait for main body to move back into position
	ld a,Object.state2		; $7065
	call objectGetRelatedObject1Var		; $7067
	ld a,(hl)		; $706a
	cp $04			; $706b
	jr z,@donePullingBack	; $706d

	call _gohma_claw_updatePositionInLunge		; $706f
	jr @updateLinkPosition		; $7072

@donePullingBack:
	ld h,d			; $7074
	dec l			; $7075
	inc (hl) ; [state] = $0f
	ld l,Enemy.animParameter		; $7077
	ld (hl),$00		; $7079
	ret			; $707b


; Claw is slamming Link into the ground
@stateF:
	call enemyAnimate		; $707c

	; Check slam is done
	ld h,d			; $707f
	ld l,Enemy.animParameter		; $7080
	bit 7,(hl)		; $7082
	jp nz,@gotoStateA		; $7084

	bit 2,(hl)		; $7087
	jr z,@label_0e_311	; $7089

	bit 4,(hl)		; $708b
	jp z,_gohma_updateClawPositionDuringSlamAttack		; $708d

	res 4,(hl)		; $7090
	ld hl,w1Link.state2		; $7092
	ld (hl),$02		; $7095
	ld l,<w1Link.collisionType		; $7097
	set 7,(hl)		; $7099
	jp _gohma_updateClawPositionDuringSlamAttack		; $709b

@label_0e_311:
	bit 4,(hl)		; $709e
	jr z,++			; $70a0

	; A slam occurs now; play sound, apply damage, etc.
	res 4,(hl)		; $70a2
	ld a,SND_EXPLOSION		; $70a4
	call playSound		; $70a6
	ld a,$14		; $70a9
	call setScreenShakeCounter		; $70ab
	ld a,$0a		; $70ae
	ld (w1Link.invincibilityCounter),a		; $70b0
	ld a,-6		; $70b3
	ld (w1Link.damageToApply),a		; $70b5
	ld h,d			; $70b8
	ld l,Enemy.animParameter		; $70b9
++
	call _gohma_updateLinkAnimAndClawPositionDuringSlamAttack		; $70bb

@updateLinkPosition:
	ld bc,$0002		; $70be
	ld hl,w1Link		; $70c1
	jp objectCopyPositionWithOffset		; $70c4


;;
; Updates speed while falling to be fast vertically, slow horizontally.
; @addr{70c7}
_gohma_updateSpeedWhileFalling:
	ld h,d			; $70c7
	ld l,Enemy.angle		; $70c8
	bit 3,(hl)		; $70ca
	ld l,Enemy.speed		; $70cc
	ld (hl),SPEED_80		; $70ce
	ret z			; $70d0
	ld (hl),SPEED_180		; $70d1
	ret			; $70d3

;;
; Reverses direction if gohma hits a wall, and plays walking sound.
; @addr{70d4}
_gohma_checkWallsAndPlayWalkingSound:
	ld h,d			; $70d4
	ld l,Enemy.yh		; $70d5
	ld b,(hl)		; $70d7
	ld l,Enemy.xh		; $70d8
	ld c,(hl)		; $70da

	; Add offset to position based on direction we're moving in
	ld e,Enemy.angle		; $70db
	ld a,(de)		; $70dd
	rrca			; $70de
	rrca			; $70df
	ld hl,_gohma_positionOffsets		; $70e0
	rst_addAToHl			; $70e3
	ldi a,(hl)		; $70e4
	add b			; $70e5
	ld b,a			; $70e6
	ld a,(hl)		; $70e7
	add c			; $70e8
	ld c,a			; $70e9

	; Check for wall in front of gohma
	call getTileCollisionsAtPosition		; $70ea
	jr z,_gohma_updateMovement			; $70ed

	; Reverse direction
	ld e,Enemy.angle		; $70ef
	ld a,(de)		; $70f1
	xor $10			; $70f2
	ld (de),a		; $70f4

;;
; @addr{70f5}
_gohma_updateMovement:
	; If moving down, don't allow gohma to pass a certain point?
	ld e,Enemy.angle		; $70f5
	ld a,(de)		; $70f7
	sub $09			; $70f8
	cp $0f			; $70fa
	jr nc,++		; $70fc
	ld e,Enemy.yh		; $70fe
	ld a,(de)		; $7100
	cp $98			; $7101
	jr nc,@updateWalkingSound	; $7103
++
	call objectApplySpeed		; $7105

@updateWalkingSound:
	ld e,Enemy.angle		; $7108
	ld a,(de)		; $710a
	bit 3,a			; $710b
	ld b,$07		; $710d
	jr nz,+			; $710f
	ld b,$0f		; $7111
+
	ld a,(wFrameCounter)		; $7113
	and b			; $7116
	ret nz			; $7117

	ld a,SND_LAND		; $7118
	jp playSound		; $711a

_gohma_positionOffsets:
	.db $f7 $00
	.db $00 $18
	.db $08 $00
	.db $00 $e7


;;
; Used by subid 1 (body) and 3 (claw)?
; @addr{7125}
_gohma_updateCollisionsEnabled:
	ld e,Enemy.health		; $7125
	ld a,(de)		; $7127
	or a			; $7128
	ret z			; $7129

	call objectGetAngleTowardEnemyTarget		; $712a
	add $06			; $712d
	and $1f			; $712f
	cp $0d			; $7131
	ld h,d			; $7133
	ld l,Enemy.collisionType		; $7134
	jr c,++			; $7136
	set 7,(hl)		; $7138
	ret			; $713a
++
	res 7,(hl)		; $713b
	ret			; $713d

;;
; Main body has died (health is 0).
; @addr{713e}
_gohma_subid1_dead:
	ld e,Enemy.collisionType		; $713e
	ld a,(de)		; $7140
	or a			; $7141
	jr z,@dead	; $7142

	; Kill all gels that gohma may have spawned
	ld h,FIRST_ENEMY_INDEX		; $7144
@nextEnemy:
	ld l,Enemy.id		; $7146
	ld a,(hl)		; $7148
	cp ENEMYID_GOHMA_GEL			; $7149
	call z,_ecom_killObjectH		; $714b
	inc h			; $714e
	ld a,h			; $714f
	cp LAST_ENEMY_INDEX+1			; $7150
	jr c,@nextEnemy	; $7152

	; Kill claw
	ld a,Object.id		; $7154
	call objectGetRelatedObject2Var		; $7156
	ld a,(hl)		; $7159
	cp ENEMYID_GOHMA			; $715a
	jr nz,@dead	; $715c

	call _ecom_killObjectH		; $715e
	ld l,Enemy.animParameter		; $7161
	ld (hl),$80		; $7163
@dead:
	jp _enemyBoss_dead		; $7165


;;
; Claw is dead
; @addr{7168}
_gohma_subid3_dead:
	ld h,d			; $7168
	ld l,Enemy.collisionType		; $7169
	ld a,(hl)		; $716b
	or a			; $716c
	jr z,+++		; $716d

	ld (hl),$00		; $716f
	ld l,Enemy.speed		; $7171
	ld (hl),SPEED_c0		; $7173
	ld l,Enemy.angle		; $7175
	ld (hl),$18		; $7177
	ld bc,-$e0		; $7179
	call objectSetSpeedZ		; $717c
	ld a,$11		; $717f
	call enemySetAnimation		; $7181
+++
	ld c,$0a		; $7184
	call objectUpdateSpeedZ_paramC		; $7186
	call objectApplySpeed		; $7189
	jp enemyAnimate		; $718c


;;
; @addr{718f}
_gohma_subid1_updateAnimationsAndCollisions:
	ld e,Enemy.state2		; $718f
	ld a,(de)		; $7191
	dec a			; $7192
	jr nz,@updateCollision	; $7193

	; [state2] == 1

	ld h,d			; $7195
	ld l,Enemy.var30		; $7196
	dec (hl)		; $7198
	jr nz,@updateCollision	; $7199

	call getRandomNumber_noPreserveVars		; $719b
	and $30			; $719e
	add $a0			; $71a0
	ld b,a			; $71a2
	ld e,Enemy.var31		; $71a3
	ld a,(de)		; $71a5
	sub $02			; $71a6
	swap a			; $71a8
	cpl			; $71aa
	inc a			; $71ab
	rrca			; $71ac
	add b			; $71ad
	ld e,Enemy.var30		; $71ae
	ld (de),a		; $71b0

	ld h,d			; $71b1
	ld l,Enemy.counter1		; $71b2
	ld a,(hl)		; $71b4
	add $18			; $71b5
	ld (hl),a		; $71b7

	ld l,Enemy.var31		; $71b8
	ld a,(hl)		; $71ba
	xor $04			; $71bb
	ld (hl),a		; $71bd

	ld e,Enemy.angle		; $71be
	ld a,(de)		; $71c0
	swap a			; $71c1
	rlca			; $71c3
	and $02			; $71c4
	add (hl) ; [var31]
	dec e			; $71c7
	ld (de),a ; [direction]
	dec a			; $71c9
	call enemySetAnimation		; $71ca

@updateCollision:
	ld e,Enemy.animParameter		; $71cd
	ld a,(de)		; $71cf
	rlca			; $71d0
	jp c,_gohma_updateCollisionsEnabled		; $71d1

	ld e,Enemy.collisionType		; $71d4
	ld a,(de)		; $71d6
	res 7,a			; $71d7
	ld (de),a		; $71d9
	ret			; $71da


;;
; @addr{71db}
_gohma_phase1_decideAngle:
	ld b,$00		; $71db
	ld h,d			; $71dd
	ld l,Enemy.yh		; $71de
	ld a,(hl)		; $71e0
	cp $60			; $71e1
	jr nc,@setAngle	; $71e3

	call getRandomNumber		; $71e5
	and $07			; $71e8
	jp z,_ecom_setRandomCardinalAngle		; $71ea

	ld a,(w1Link.yh)		; $71ed
	sub (hl)		; $71f0
	cp $20			; $71f1
	jr c,@checkHorizontal	; $71f3

	ld b,$10		; $71f5
	cp $80			; $71f7
	jr c,@setAngle	; $71f9

	ld b,$00		; $71fb
	cp $e0			; $71fd
	jr c,@setAngle	; $71ff

@checkHorizontal:
	ld l,Enemy.xh		; $7201
	ld a,(w1Link.xh)		; $7203
	cp (hl)			; $7206
	ld b,$18		; $7207
	jr c,@setAngle	; $7209

	ld b,$08		; $720b
@setAngle:
	ld l,Enemy.angle		; $720d
	ld (hl),b		; $720f
	ret			; $7210

;;
; Sets counter1 to something.
; @addr{7211}
_gohma_decideMovementDuration:
	call getRandomNumber_noPreserveVars		; $7211
	and $03			; $7214
	ld hl,@counter1Vals		; $7216
	rst_addAToHl			; $7219

	; Horizontal movement has less duration
	ld e,Enemy.angle		; $721a
	ld a,(de)		; $721c
	and $08			; $721d
	add a			; $721f
	add a			; $7220
	cpl			; $7221
	inc a			; $7222
	add (hl)		; $7223
	ld e,Enemy.counter1		; $7224
	ld (de),a		; $7226
	ret			; $7227

@counter1Vals:
	.db $60 $70 $80 $50

;;
; @addr{722c}
_gohma_decideAnimation:
	ld h,d			; $722c
	ld l,Enemy.var31		; $722d
	ld e,Enemy.angle		; $722f
	ld a,(de)		; $7231
	swap a			; $7232
	rlca			; $7234
	and $02			; $7235
	add (hl)		; $7237
	ld l,Enemy.direction		; $7238
	cp (hl)			; $723a
	ret z			; $723b
	ld (hl),a		; $723c
	jp enemySetAnimation		; $723d

;;
; Updates movement for "lunge" at Link with claw
; @addr{7240}
_gohma_updateLunge:
	call _ecom_decCounter1		; $7240
	ret z			; $7243

	ld a,(hl)		; $7244
	cp 30			; $7245
	push af			; $7247
	call z,_gohma_initAngleForLungeAtLink		; $7248

	pop af			; $724b
	cp 15			; $724c
	jp nz,_gohma_updateMovement		; $724e

	; Begin moving back
	ld e,Enemy.angle		; $7251
	ld a,(de)		; $7253
	xor $10			; $7254
	ld (de),a		; $7256
	jp _gohma_updateMovement		; $7257

;;
; Decides angle to use while charging toward Link, and plays sound effect.
; @addr{725a}
_gohma_initAngleForLungeAtLink:
	ld b,$00		; $725a
	ld a,Object.xh		; $725c
	call objectGetRelatedObject2Var		; $725e
	ld a,(w1Link.xh)		; $7261
	sub (hl)		; $7264
	add $06			; $7265
	cp $0d			; $7267
	jr c,@setAngle	; $7269

	ld b,$fe		; $726b
	cp $86			; $726d
	jr c,@setAngle	; $726f

	ld b,$02		; $7271

@setAngle:
	ld e,Enemy.angle		; $7273
	ld a,$10		; $7275
	add b			; $7277
	ld (de),a		; $7278

	ld a,SND_BEAM2		; $7279
	jp playSound		; $727b

;;
; @param	hl	Pointer to counter1
; @addr{727e}
_gohma_phase2_spawnGelChild:
	ld (hl),$07		; $727e
	ld l,Enemy.var32		; $7280
	ld a,(hl)		; $7282
	cp $05			; $7283
	ret nc			; $7285

	call getRandomNumber_noPreserveVars		; $7286
	and $03			; $7289
	ld c,a			; $728b
	ld b,ENEMYID_GOHMA_GEL		; $728c
	call _ecom_spawnUncountedEnemyWithSubid01		; $728e
	ret nz			; $7291

	ld (hl),c ; [subid] = c (random number from 0 to 3)
	call objectCopyPosition		; $7293
	ld l,Enemy.relatedObj1		; $7296
	ld a,Enemy.start		; $7298
	ldi (hl),a		; $729a
	ld (hl),d		; $729b

	ld h,d			; $729c
	ld l,Enemy.var32		; $729d
	inc (hl)		; $729f
	ld a,SND_HEART_LADX		; $72a0
	jp playSound		; $72a2

_gohma_counter1Vals:
	.db $05 $0f $0f $19 $19 $19 $23 $23

;;
; If Link is using something and a certain item type is active, block eye with claw
; @addr{2ad}
_gohma_checkShouldBlock:
	ld a,(wLinkUsingItem1)		; $72ad
	and $f0			; $72b0
	ret z			; $72b2

	ld a,Object.yh		; $72b3
	call objectGetRelatedObject1Var		; $72b5
	ld a,(w1Link.yh)		; $72b8
	sub (hl)		; $72bb
	cp $2c			; $72bc
	ret c			; $72be

	; Check if any item with ID above ITEMID_DUST is active?
	ld h,FIRST_ITEM_INDEX		; $72bf
@nextItem:
	ld l,Item.id		; $72c1
	ld a,(hl)		; $72c3
	cp ITEMID_DUST			; $72c4
	jr nc,@beginBlock	; $72c6
	inc h			; $72c8
	ld a,h			; $72c9
	cp $e0			; $72ca
	jr c,@nextItem	; $72cc
	ret			; $72ce

@beginBlock:
	ld h,d			; $72cf
	ld l,Enemy.state		; $72d0
	inc (hl) ; [state] = $0b

	ld l,Enemy.counter1		; $72d3
	ld (hl),60		; $72d5

	ld a,$0e		; $72d7
	call enemySetAnimation		; $72d9

_gohma_claw_updateBlockingPosition:
	ld bc,$07ff		; $72dc
	ld a,Object.enabled		; $72df
	call objectGetRelatedObject1Var		; $72e1
	jp objectTakePositionWithOffset		; $72e4

;;
; @addr{72e7}
_gohma_claw_updatePositionInLunge:
	ld e,Enemy.animParameter		; $72e7
	ld a,(de)		; $72e9

;;
; @param	a	Position index
; @addr{72ea}
_gohma_claw_setPositionInLunge:
	ld hl,@positions		; $72ea
	rst_addAToHl			; $72ed
	ldi a,(hl)		; $72ee
	ld b,a			; $72ef
	ld c,(hl)		; $72f0
	ld a,$00		; $72f1
	call objectGetRelatedObject1Var		; $72f3
	jp objectTakePositionWithOffset		; $72f6

@positions:
	.db $08 $fa
	.db $05 $f3
	.db $fd $f3
	.db $ef $f8
	.db $09 $fb

;;
; @param	hl	Pointer to w1Link.animParameter?
; @addr{7303}
_gohma_updateLinkAnimAndClawPositionDuringSlamAttack:
	; Update Link's animation?
	ld a,(hl)		; $7303
	ld hl,_gohma_linkVar31Stuff		; $7304
	rst_addAToHl			; $7307
	ld a,(hl)		; $7308
	ld (w1Link.var31),a		; $7309

_gohma_updateClawPositionDuringSlamAttack:
	ld e,Enemy.animParameter		; $730c
	ld a,(de)		; $730e
	and $03			; $730f
	ld hl,_gohma_clawSlamPositionOffsets		; $7311
	rst_addDoubleIndex			; $7314
	ldi a,(hl)		; $7315
	ld b,a			; $7316
	ld c,(hl)		; $7317
	ld a,$00		; $7318
	call objectGetRelatedObject1Var		; $731a
	jp objectTakePositionWithOffset		; $731d


_gohma_linkVar31Stuff:
	.db $0d $0e $0f $0e

_gohma_clawSlamPositionOffsets:
	.db $08 $fa
	.db $fd $f3
	.db $ef $f8
	.db $05 $f3

; ==============================================================================
; ENEMYID_DIGDOGGER
; ==============================================================================
enemyCode7c:
	jr z,_label_0e_332	; $732c
	sub $03			; $732e
	ret c			; $7330
	jr z,_label_0e_329	; $7331
	dec a			; $7333
	jr z,_label_0e_332	; $7334
	call enemyAnimate		; $7336
	jp _ecom_updateKnockback		; $7339
_label_0e_329:
	ld e,$82		; $733c
	ld a,(de)		; $733e
	dec a			; $733f
	jr z,_label_0e_331	; $7340
	ld e,$a4		; $7342
	ld a,(de)		; $7344
	or a			; $7345
	ld a,$09		; $7346
	jr z,_label_0e_330	; $7348
	call enemySetAnimation		; $734a
	call _ecom_killRelatedObj1		; $734d
_label_0e_330:
	jp _enemyBoss_dead		; $7350
_label_0e_331:
	ld e,$84		; $7353
	ld a,(de)		; $7355
	cp $0a			; $7356
	jr nz,_label_0e_332	; $7358
	call objectCreatePuff		; $735a
	jp enemyDelete		; $735d
_label_0e_332:
	call _ecom_getSubidAndCpStateTo08		; $7360
	jr nc,_label_0e_333	; $7363
	rst_jumpTable			; $7365
	ld a,l			; $7366
	ld (hl),e		; $7367
	sbc a			; $7368
	ld (hl),e		; $7369
.DB $e4				; $736a
	ld (hl),e		; $736b
.DB $e4				; $736c
	ld (hl),e		; $736d
.DB $e4				; $736e
	ld (hl),e		; $736f
.DB $e4				; $7370
	ld (hl),e		; $7371
.DB $e4				; $7372
	ld (hl),e		; $7373
.DB $e4				; $7374
	ld (hl),e		; $7375
_label_0e_333:
	dec b			; $7376
	ld a,b			; $7377
	rst_jumpTable			; $7378
	push hl			; $7379
	ld (hl),e		; $737a
	sbc c			; $737b
	ld (hl),h		; $737c
	ld a,b			; $737d
	or a			; $737e
	jr nz,_label_0e_334	; $737f
	inc a			; $7381
	ld (de),a		; $7382
	ld a,$7c		; $7383
	ld b,$84		; $7385
	call _enemyBoss_initializeRoom		; $7387
	jr _label_0e_336		; $738a
_label_0e_334:
	dec a			; $738c
	jr nz,_label_0e_335	; $738d
	ld e,$be		; $738f
	ld a,$08		; $7391
	ld (de),a		; $7393
	ld a,$08		; $7394
	call enemySetAnimation		; $7396
_label_0e_335:
	call _ecom_setSpeedAndState8		; $7399
_label_0e_336:
	jp objectSetVisible82		; $739c
	ld e,$86		; $739f
	ld a,(de)		; $73a1
	or a			; $73a2
	jp nz,enemyDelete		; $73a3
	ld b,$02		; $73a6
	call checkBEnemySlotsAvailable		; $73a8
	ret nz			; $73ab
	ld b,$7c		; $73ac
	call _ecom_spawnUncountedEnemyWithSubid01		; $73ae
	ld l,$8b		; $73b1
	ld (hl),$28		; $73b3
	ld l,$8d		; $73b5
	ld (hl),$d8		; $73b7
	ld l,$8f		; $73b9
	ld (hl),$e8		; $73bb
	ld c,h			; $73bd
	push hl			; $73be
	call _ecom_spawnUncountedEnemyWithSubid01		; $73bf
	inc (hl)		; $73c2
	ld l,$8b		; $73c3
	call objectCopyPosition		; $73c5
	ld l,$80		; $73c8
	ld e,l			; $73ca
	ld a,(de)		; $73cb
	ld (hl),a		; $73cc
	ld l,$96		; $73cd
	ld (hl),e		; $73cf
	inc l			; $73d0
	ld (hl),c		; $73d1
	ld l,$b0		; $73d2
	ld (hl),$04		; $73d4
	ld c,h			; $73d6
	pop hl			; $73d7
	ld l,$96		; $73d8
	ld a,$80		; $73da
	ldi (hl),a		; $73dc
	ld (hl),c		; $73dd
	ld e,$86		; $73de
	ld a,$01		; $73e0
	ld (de),a		; $73e2
	ret			; $73e3
	ret			; $73e4
	call $779b		; $73e5
	ld e,$84		; $73e8
	ld a,(de)		; $73ea
	sub $08			; $73eb
	rst_jumpTable			; $73ed
	ld hl,sp+$73		; $73ee
	dec de			; $73f0
	ld (hl),h		; $73f1
	dec hl			; $73f2
	ld (hl),h		; $73f3
	ld e,b			; $73f4
	ld (hl),h		; $73f5
	ld a,d			; $73f6
	ld (hl),h		; $73f7
	ld a,$04		; $73f8
	call objectGetRelatedObject1Var		; $73fa
	ld a,(hl)		; $73fd
	cp $09			; $73fe
	ret c			; $7400
	ld a,($cc79)		; $7401
	or a			; $7404
	ret z			; $7405
	bit 1,a			; $7406
	ret z			; $7408
	ld bc,$0008		; $7409
	call _enemyBoss_spawnShadow		; $740c
	ret nz			; $740f
	ld h,d			; $7410
	ld l,$84		; $7411
	inc (hl)		; $7413
	ld l,$90		; $7414
	ld (hl),$28		; $7416
	jp _ecom_updateAngleTowardTarget		; $7418
	ld c,$10		; $741b
	call objectUpdateSpeedZ_paramC		; $741d
	jp nz,objectApplySpeed		; $7420
	ld l,$84		; $7423
	inc (hl)		; $7425
	ld l,$8f		; $7426
	ld (hl),$ff		; $7428
	ret			; $742a
	call $7757		; $742b
	ret c			; $742e
	ld a,($cc79)		; $742f
	or a			; $7432
	ret z			; $7433
	ld e,$a9		; $7434
	ld a,(de)		; $7436
	or a			; $7437
	ret z			; $7438
	call _ecom_updateAngleTowardTarget		; $7439
	ld a,($cc79)		; $743c
	bit 1,a			; $743f
	jr nz,_label_0e_337	; $7441
	ld e,$89		; $7443
	ld a,(de)		; $7445
	xor $10			; $7446
	ld (de),a		; $7448
_label_0e_337:
	ld h,d			; $7449
	ld l,$84		; $744a
	ld (hl),$0b		; $744c
	ld l,$90		; $744e
	ld (hl),$50		; $7450
	ld l,$86		; $7452
	ld (hl),$00		; $7454
	scf			; $7456
	ret			; $7457
	call $7757		; $7458
	jr c,_label_0e_338	; $745b
	ld e,$a9		; $745d
	ld a,(de)		; $745f
	or a			; $7460
	jr z,_label_0e_338	; $7461
	ld a,($cc79)		; $7463
	or a			; $7466
	jr nz,_label_0e_339	; $7467
_label_0e_338:
	ld h,d			; $7469
	ld l,$84		; $746a
	inc (hl)		; $746c
	jr _label_0e_342		; $746d
_label_0e_339:
	call $7737		; $746f
	call $770e		; $7472
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $7475
	jr _label_0e_342		; $7478
	ld h,d			; $747a
	ld l,$86		; $747b
	ld a,(hl)		; $747d
	or a			; $747e
	jr z,_label_0e_340	; $747f
	dec (hl)		; $7481
	jr nz,_label_0e_341	; $7482
_label_0e_340:
	ld l,e			; $7484
	ld (hl),$0a		; $7485
	ld l,$90		; $7487
	ld (hl),$00		; $7489
	ret			; $748b
_label_0e_341:
	call $742f		; $748c
	ret c			; $748f
	call $7740		; $7490
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $7493
_label_0e_342:
	jp $7763		; $7496
	ld a,(de)		; $7499
	sub $08			; $749a
	rst_jumpTable			; $749c
	or l			; $749d
	ld (hl),h		; $749e
	call nc,$f374		; $749f
	ld (hl),h		; $74a2
	jr z,$75		; $74a3
	ld d,h			; $74a5
	ld (hl),l		; $74a6
	ld a,l			; $74a7
	ld (hl),l		; $74a8
	jp $f275		; $74a9
	ld (hl),l		; $74ac
	stop			; $74ad
	halt			; $74ae
	dec l			; $74af
	halt			; $74b0
	ld (hl),l		; $74b1
	halt			; $74b2
	adc (hl)		; $74b3
	halt			; $74b4
	ld a,(wcc93)		; $74b5
	or a			; $74b8
	ret nz			; $74b9
	ld bc,$0208		; $74ba
	call _enemyBoss_spawnShadow		; $74bd
	ret nz			; $74c0
	ld h,d			; $74c1
	ld l,$84		; $74c2
	inc (hl)		; $74c4
	ld l,$86		; $74c5
	inc (hl)		; $74c7
	ld l,$b1		; $74c8
	ld (hl),$06		; $74ca
	ld a,$2e		; $74cc
	ld (wActiveMusic),a		; $74ce
	jp playSound		; $74d1
	call _ecom_decCounter1		; $74d4
	jp nz,enemyAnimate		; $74d7
	inc (hl)		; $74da
	inc l			; $74db
	ld (hl),$06		; $74dc
	ld l,e			; $74de
	inc (hl)		; $74df
	ld e,$b1		; $74e0
	ld a,(de)		; $74e2
	dec a			; $74e3
	ld hl,$74ed		; $74e4
	rst_addAToHl			; $74e7
	ld e,$90		; $74e8
	ld a,(hl)		; $74ea
	ld (de),a		; $74eb
	ret			; $74ec
	ld b,(hl)		; $74ed
	inc a			; $74ee
	ldd (hl),a		; $74ef
	jr z,$1e		; $74f0
	ld e,$cd		; $74f2
	sbc d			; $74f4
	ld b,e			; $74f5
	ret nz			; $74f6
	ld l,e			; $74f7
	inc (hl)		; $74f8
	ld l,$94		; $74f9
	ld a,$80		; $74fb
	ldi (hl),a		; $74fd
	ld (hl),$fe		; $74fe
	call _ecom_updateAngleTowardTarget		; $7500
	call getRandomNumber_noPreserveVars		; $7503
	and $03			; $7506
	ld hl,$7524		; $7508
	rst_addAToHl			; $750b
	ld e,$89		; $750c
	ld a,(de)		; $750e
	add $02			; $750f
	and $1c			; $7511
	add (hl)		; $7513
	and $1f			; $7514
	ld (de),a		; $7516
	ld a,$98		; $7517
	call playSound		; $7519
	ld a,$04		; $751c
	call enemySetAnimation		; $751e
	jp objectSetVisible81		; $7521
.DB $fc				; $7524
	nop			; $7525
	inc b			; $7526
	stop			; $7527
	ld c,$0c		; $7528
	call objectUpdateSpeedZ_paramC		; $752a
	jp nz,$76de		; $752d
	ld a,$85		; $7530
	call playSound		; $7532
	call objectSetVisible82		; $7535
	ld h,d			; $7538
	ld l,$86		; $7539
	ld (hl),$10		; $753b
	inc l			; $753d
	dec (hl)		; $753e
	jr z,_label_0e_343	; $753f
	ld l,$84		; $7541
	dec (hl)		; $7543
	ld a,$01		; $7544
	jp enemySetAnimation		; $7546
_label_0e_343:
	dec l			; $7549
	ld (hl),$0c		; $754a
	ld l,$84		; $754c
	inc (hl)		; $754e
	ld a,$02		; $754f
	jp enemySetAnimation		; $7551
	call _ecom_decCounter1		; $7554
	jr z,_label_0e_344	; $7557
	ld a,(hl)		; $7559
	cp $04			; $755a
	ret nz			; $755c
	xor a			; $755d
	jp enemySetAnimation		; $755e
_label_0e_344:
	ld l,e			; $7561
	inc (hl)		; $7562
	ld l,$90		; $7563
	ld (hl),$32		; $7565
	ld bc,$fc00		; $7567
	call objectSetSpeedZ		; $756a
	ld a,$98		; $756d
	call playSound		; $756f
	call _ecom_updateAngleTowardTarget		; $7572
	call objectSetVisible81		; $7575
	ld a,$03		; $7578
	jp enemySetAnimation		; $757a
	ld c,$10		; $757d
	call objectUpdateSpeedZ_paramC		; $757f
	ldh a,(<hCameraY)	; $7582
	ld b,a			; $7584
	ld l,$8f		; $7585
	ld e,$8b		; $7587
	ld a,(de)		; $7589
	add (hl)		; $758a
	sub b			; $758b
	cp $b0			; $758c
	jp c,$76bc		; $758e
	ld l,$84		; $7591
	inc (hl)		; $7593
	ld l,$a4		; $7594
	res 7,(hl)		; $7596
	ld l,$86		; $7598
	ld (hl),$3c		; $759a
	ld l,$8f		; $759c
	ld (hl),$00		; $759e
	call objectSetInvisible		; $75a0
	ld e,$b1		; $75a3
	ld a,(de)		; $75a5
	dec a			; $75a6
	ld hl,$75b7		; $75a7
	rst_addDoubleIndex			; $75aa
	ld e,$94		; $75ab
	xor a			; $75ad
	ld (de),a		; $75ae
	inc e			; $75af
	ldi a,(hl)		; $75b0
	ld (de),a		; $75b1
	ld e,$87		; $75b2
	ld a,(hl)		; $75b4
	ld (de),a		; $75b5
	ret			; $75b6
	ld (bc),a		; $75b7
	ld a,(bc)		; $75b8
	ld (bc),a		; $75b9
	ld (de),a		; $75ba
	ld (bc),a		; $75bb
	inc d			; $75bc
	ld bc,$011c		; $75bd
	ld e,$01		; $75c0
	ld h,$cd		; $75c2
	sbc d			; $75c4
	ld b,e			; $75c5
	jr z,_label_0e_345	; $75c6
	ld a,(hl)		; $75c8
	inc l			; $75c9
	cp (hl)			; $75ca
	ld c,$10		; $75cb
	call c,_ecom_setZAboveScreen		; $75cd
	ret nz			; $75d0
	ld l,$8b		; $75d1
	ld a,($d00b)		; $75d3
	and $f0			; $75d6
	add $08			; $75d8
	ldi (hl),a		; $75da
	inc l			; $75db
	ld a,($d00d)		; $75dc
	and $f0			; $75df
	add $08			; $75e1
	ld (hl),a		; $75e3
	ret			; $75e4
_label_0e_345:
	ld l,e			; $75e5
	inc (hl)		; $75e6
	ld l,$a4		; $75e7
	set 7,(hl)		; $75e9
	ld l,$a8		; $75eb
	ld (hl),$f8		; $75ed
	jp objectSetVisible81		; $75ef
	ld c,$20		; $75f2
	call objectUpdateSpeedZ_paramC		; $75f4
	ret nz			; $75f7
	ld l,$84		; $75f8
	ld (hl),$09		; $75fa
	ld l,$86		; $75fc
	ld (hl),$77		; $75fe
	ld l,$a8		; $7600
	ld (hl),$fc		; $7602
	ld a,$85		; $7604
	call playSound		; $7606
	call objectSetVisible82		; $7609
	xor a			; $760c
	jp enemySetAnimation		; $760d
	ld h,d			; $7610
	ld l,e			; $7611
	inc (hl)		; $7612
	ld l,$86		; $7613
	ld (hl),$1e		; $7615
	ld l,$a4		; $7617
	res 7,(hl)		; $7619
	ld l,$8e		; $761b
	xor a			; $761d
	ldi (hl),a		; $761e
	ld (hl),a		; $761f
	ld l,$ab		; $7620
	ld (hl),$2d		; $7622
	ld l,$ad		; $7624
	ld (hl),$12		; $7626
	ld a,$05		; $7628
	jp enemySetAnimation		; $762a
	call _ecom_decCounter1		; $762d
	jp nz,enemyAnimate		; $7630
	ld e,$b0		; $7633
	ld a,(de)		; $7635
	or a			; $7636
	jr nz,_label_0e_348	; $7637
	inc (hl)		; $7639
	ld l,$b1		; $763a
	ld b,(hl)		; $763c
	call checkBEnemySlotsAvailable		; $763d
	ret nz			; $7640
	ld e,$97		; $7641
	ld a,(de)		; $7643
	ldh (<hFF8B),a	; $7644
	ld e,$b1		; $7646
	ld a,(de)		; $7648
	ld c,a			; $7649
_label_0e_346:
	ld b,$55		; $764a
	call _ecom_spawnUncountedEnemyWithSubid01		; $764c
	call objectCopyPosition		; $764f
	ld l,$96		; $7652
	ld a,$80		; $7654
	ldi (hl),a		; $7656
	ld (hl),d		; $7657
	ld l,$b1		; $7658
	ldh a,(<hFF8B)	; $765a
	ld (hl),a		; $765c
	ld a,c			; $765d
	add $b2			; $765e
	ld e,a			; $7660
	ld a,h			; $7661
	ld (de),a		; $7662
	dec c			; $7663
	jr nz,_label_0e_346	; $7664
	ld h,d			; $7666
	ld l,$84		; $7667
	inc (hl)		; $7669
	ld l,$86		; $766a
	ld (hl),$a0		; $766c
	ld l,$b1		; $766e
	ldi a,(hl)		; $7670
	ld (hl),a		; $7671
	jp objectSetInvisible		; $7672
	ld a,(wFrameCounter)		; $7675
	and $03			; $7678
	ret nz			; $767a
	call _ecom_decCounter1		; $767b
	ret nz			; $767e
	ld (hl),$19		; $767f
	ld l,e			; $7681
	inc (hl)		; $7682
	call $76e4		; $7683
	ld a,$06		; $7686
	call enemySetAnimation		; $7688
	jp objectSetVisible82		; $768b
	ld e,$86		; $768e
	ld a,(de)		; $7690
	or a			; $7691
	jr z,_label_0e_347	; $7692
	dec a			; $7694
	ld (de),a		; $7695
	jr nz,_label_0e_347	; $7696
	ld a,$07		; $7698
	call enemySetAnimation		; $769a
_label_0e_347:
	ld e,$b2		; $769d
	ld a,(de)		; $769f
	or a			; $76a0
	ret nz			; $76a1
	ld a,$c0		; $76a2
	call playSound		; $76a4
	ld h,d			; $76a7
	ld l,$b0		; $76a8
	ld (hl),$04		; $76aa
_label_0e_348:
	ld l,$a4		; $76ac
	set 7,(hl)		; $76ae
	ld l,$84		; $76b0
	ld (hl),$09		; $76b2
	ld l,$86		; $76b4
	ld (hl),$69		; $76b6
	xor a			; $76b8
	jp enemySetAnimation		; $76b9
	ld l,$94		; $76bc
	ldi a,(hl)		; $76be
	or a			; $76bf
	jr nz,_label_0e_349	; $76c0
	ld a,(hl)		; $76c2
	or a			; $76c3
	jr nz,_label_0e_349	; $76c4
	ld (hl),$02		; $76c6
	ld l,$90		; $76c8
	ld (hl),$14		; $76ca
	ld a,$04		; $76cc
	call enemySetAnimation		; $76ce
_label_0e_349:
	ld a,(wFrameCounter)		; $76d1
	and $03			; $76d4
	jr nz,_label_0e_350	; $76d6
	call objectGetAngleTowardEnemyTarget		; $76d8
	call objectNudgeAngleTowards		; $76db
_label_0e_350:
	call _ecom_bounceOffWallsAndHoles		; $76de
	jp objectApplySpeed		; $76e1
	ld e,$b2		; $76e4
_label_0e_351:
	inc e			; $76e6
	ld a,(de)		; $76e7
	ld h,a			; $76e8
	ld l,$80		; $76e9
	ld a,(hl)		; $76eb
	or a			; $76ec
	jr z,_label_0e_351	; $76ed
	ld e,$b3		; $76ef
	ld b,h			; $76f1
	ld c,$06		; $76f2
_label_0e_352:
	ld a,(de)		; $76f4
	ld h,a			; $76f5
	ld l,$80		; $76f6
	ld a,(hl)		; $76f8
	or a			; $76f9
	jr z,_label_0e_353	; $76fa
	ld l,$98		; $76fc
	ld a,$80		; $76fe
	ldi (hl),a		; $7700
	ld (hl),b		; $7701
_label_0e_353:
	inc e			; $7702
	dec c			; $7703
	jr nz,_label_0e_352	; $7704
	ld h,b			; $7706
	ld l,$84		; $7707
	ld (hl),$0c		; $7709
	jp objectTakePosition		; $770b
	ld a,(wFrameCounter)		; $770e
	and $03			; $7711
	ret nz			; $7713
	ld a,($cc79)		; $7714
	bit 1,a			; $7717
	jr z,_label_0e_354	; $7719
	call objectGetAngleTowardEnemyTarget		; $771b
	ld b,a			; $771e
	jr _label_0e_355		; $771f
_label_0e_354:
	call objectGetAngleTowardEnemyTarget		; $7721
	xor $10			; $7724
	ld b,a			; $7726
_label_0e_355:
	ld e,$89		; $7727
	ld a,(de)		; $7729
	sub b			; $772a
	add $02			; $772b
	cp $05			; $772d
	ld a,b			; $772f
	jp nc,objectNudgeAngleTowards		; $7730
	ld e,$89		; $7733
	ld (de),a		; $7735
	ret			; $7736
	ld e,$86		; $7737
	ld a,(de)		; $7739
	cp $28			; $773a
	jr nc,_label_0e_356	; $773c
	inc a			; $773e
	ld (de),a		; $773f
_label_0e_356:
	ld e,$86		; $7740
	ld a,(de)		; $7742
	and $38			; $7743
	rlca			; $7745
	swap a			; $7746
	ld hl,$7751		; $7748
	rst_addAToHl			; $774b
	ld e,$90		; $774c
	ld a,(hl)		; $774e
	ld (de),a		; $774f
	ret			; $7750
	ld a,(bc)		; $7751
	inc d			; $7752
	jr z,$3c		; $7753
	ld b,(hl)		; $7755
	ld d,b			; $7756
	xor a			; $7757
	ld a,($cc79)		; $7758
	bit 1,a			; $775b
	ret z			; $775d
	ld c,$0c		; $775e
	jp objectCheckLinkWithinDistance		; $7760
	ld e,$90		; $7763
	ld a,(de)		; $7765
	cp $3c			; $7766
	ret c			; $7768
	ld a,$2b		; $7769
	call objectGetRelatedObject1Var		; $776b
	ld a,(hl)		; $776e
	or a			; $776f
	ret nz			; $7770
	ld l,$a4		; $7771
	bit 7,(hl)		; $7773
	ret z			; $7775
	ld l,$8f		; $7776
	ld a,(hl)		; $7778
	dec a			; $7779
	cp $f5			; $777a
	ret c			; $777c
	call checkObjectsCollided		; $777d
	ret nc			; $7780
	ld l,$b0		; $7781
	dec (hl)		; $7783
	ld l,$84		; $7784
	ld (hl),$10		; $7786
	ld l,$8b		; $7788
	ld b,(hl)		; $778a
	ld l,$8d		; $778b
	ld c,(hl)		; $778d
	push hl			; $778e
	call objectGetRelativeAngle		; $778f
	pop hl			; $7792
	ld l,$ac		; $7793
	ld (hl),a		; $7795
	ld a,$63		; $7796
	jp playSound		; $7798
	ld a,$0b		; $779b
	call objectGetRelatedObject1Var		; $779d
	ld e,l			; $77a0
	ld a,(de)		; $77a1
	cp (hl)			; $77a2
	jp c,objectSetVisible83		; $77a3
	jp objectSetVisible82		; $77a6

; ==============================================================================
; ENEMYID_MANHANDLA
; ==============================================================================
enemyCode7d:
	jr z,_label_0e_358	; $77a9
	sub $03			; $77ab
	ret c			; $77ad
	dec a			; $77ae
	jr z,_label_0e_357	; $77af
	dec a			; $77b1
	jr z,_label_0e_358	; $77b2
	ld e,$82		; $77b4
	ld a,(de)		; $77b6
	dec a			; $77b7
	jp z,_enemyBoss_dead		; $77b8
	dec a			; $77bb
	call z,_ecom_killRelatedObj1		; $77bc
	jp enemyDie_uncounted		; $77bf
_label_0e_357:
	call $7a44		; $77c2
_label_0e_358:
	call _ecom_getSubidAndCpStateTo08		; $77c5
	jr nc,_label_0e_359	; $77c8
	rst_jumpTable			; $77ca
	ld ($2e77),a		; $77cb
	ld a,b			; $77ce
	halt			; $77cf
	ld a,b			; $77d0
	halt			; $77d1
	ld a,b			; $77d2
	halt			; $77d3
	ld a,b			; $77d4
	halt			; $77d5
	ld a,b			; $77d6
	halt			; $77d7
	ld a,b			; $77d8
	halt			; $77d9
	ld a,b			; $77da
_label_0e_359:
	dec b			; $77db
	ld a,b			; $77dc
	rst_jumpTable			; $77dd
	ld (hl),a		; $77de
	ld a,b			; $77df
	ld (hl),d		; $77e0
	ld a,c			; $77e1
.DB $dd				; $77e2
	ld a,c			; $77e3
.DB $dd				; $77e4
	ld a,c			; $77e5
.DB $dd				; $77e6
	ld a,c			; $77e7
.DB $dd				; $77e8
	ld a,c			; $77e9
	ld a,b			; $77ea
	or a			; $77eb
	jr nz,_label_0e_360	; $77ec
	ld a,$7d		; $77ee
	ld b,$85		; $77f0
	call _enemyBoss_initializeRoom		; $77f2
	jr _label_0e_363		; $77f5
_label_0e_360:
	dec a			; $77f7
	ld hl,$7828		; $77f8
	rst_addAToHl			; $77fb
	ld e,$b0		; $77fc
	ld a,(hl)		; $77fe
	ld (de),a		; $77ff
	call enemySetAnimation		; $7800
	call _ecom_setSpeedAndState8		; $7803
	ld e,$82		; $7806
	ld a,(de)		; $7808
	cp $03			; $7809
	jr nc,_label_0e_361	; $780b
	dec a			; $780d
	jr z,_label_0e_362	; $780e
	jp objectSetInvisible		; $7810
_label_0e_361:
	call $7a14		; $7813
	ld e,$b1		; $7816
	ld a,$03		; $7818
	ld (de),a		; $781a
	ld e,$82		; $781b
	ld a,(de)		; $781d
	sub $04			; $781e
	cp $02			; $7820
	jp c,objectSetVisible82		; $7822
_label_0e_362:
	jp objectSetVisible83		; $7825
	nop			; $7828
	dec b			; $7829
	add hl,bc		; $782a
	dec c			; $782b
	dec bc			; $782c
	rlca			; $782d
_label_0e_363:
	ld b,$06		; $782e
	call checkBEnemySlotsAvailable		; $7830
	ret nz			; $7833
	ld b,$7d		; $7834
	call _ecom_spawnUncountedEnemyWithSubid01		; $7836
	ld l,$80		; $7839
	ld e,l			; $783b
	ld a,(de)		; $783c
	ld (hl),a		; $783d
	call objectCopyPosition		; $783e
	push hl			; $7841
	ld c,h			; $7842
	call _ecom_spawnUncountedEnemyWithSubid01		; $7843
	inc (hl)		; $7846
	call objectCopyPosition		; $7847
	call $7a3d		; $784a
	ld a,h			; $784d
	ld hl,$ff8a		; $784e
	ldi (hl),a		; $7851
	ld a,$04		; $7852
_label_0e_364:
	ldh (<hFF8F),a	; $7854
	push hl			; $7856
	call _ecom_spawnUncountedEnemyWithSubid01		; $7857
	call $7a1f		; $785a
	ld a,h			; $785d
	pop hl			; $785e
	ldi (hl),a		; $785f
	ldh a,(<hFF8F)	; $7860
	dec a			; $7862
	jr nz,_label_0e_364	; $7863
	pop hl			; $7865
	ld bc,$ff8a		; $7866
	ld l,$b1		; $7869
	ld e,$05		; $786b
_label_0e_365:
	ld a,(bc)		; $786d
	ldi (hl),a		; $786e
	inc c			; $786f
	dec e			; $7870
	jr nz,_label_0e_365	; $7871
	jp enemyDelete		; $7873
	ret			; $7876
	call $7ac8		; $7877
	ld e,$84		; $787a
	ld a,(de)		; $787c
	sub $08			; $787d
	rst_jumpTable			; $787f
	adc (hl)		; $7880
	ld a,b			; $7881
	or h			; $7882
	ld a,b			; $7883
	jp z,$fe78		; $7884
	ld a,b			; $7887
	dec de			; $7888
	ld a,c			; $7889
	inc (hl)		; $788a
	ld a,c			; $788b
	ld c,c			; $788c
	ld a,c			; $788d
	ld a,(wcc93)		; $788e
	or a			; $7891
	ret nz			; $7892
	ld h,d			; $7893
	ld l,$90		; $7894
	ld (hl),$0a		; $7896
	ld l,$a5		; $7898
	ld (hl),$61		; $789a
	ld l,$b6		; $789c
	ld (hl),$04		; $789e
	inc l			; $78a0
	ld (hl),$58		; $78a1
	inc l			; $78a3
	ld (hl),$78		; $78a4
	inc l			; $78a6
	ld (hl),$ff		; $78a7
	call $78ce		; $78a9
	ld a,$2e		; $78ac
	ld (wActiveMusic),a		; $78ae
	jp playSound		; $78b1
	call _ecom_decCounter1		; $78b4
	jr nz,_label_0e_366	; $78b7
	ld (hl),$78		; $78b9
	ld l,e			; $78bb
	inc (hl)		; $78bc
	xor a			; $78bd
	call enemySetAnimation		; $78be
_label_0e_366:
	call _ecom_bounceOffWallsAndHoles		; $78c1
	call objectApplySpeed		; $78c4
_label_0e_367:
	jp enemyAnimate		; $78c7
	call _ecom_decCounter1		; $78ca
	ret nz			; $78cd
	ld l,e			; $78ce
	ld (hl),$09		; $78cf
	call getRandomNumber_noPreserveVars		; $78d1
	and $07			; $78d4
	ld hl,$78f6		; $78d6
	rst_addAToHl			; $78d9
	ld e,$86		; $78da
	ld a,(hl)		; $78dc
	ld (de),a		; $78dd
	ld bc,$5078		; $78de
	call objectGetRelativeAngle		; $78e1
	push af			; $78e4
	call getRandomNumber_noPreserveVars		; $78e5
	and $01			; $78e8
	pop af			; $78ea
	jr z,_label_0e_368	; $78eb
	sub $02			; $78ed
	and $1f			; $78ef
_label_0e_368:
	ld e,$89		; $78f1
	ld (de),a		; $78f3
	jr _label_0e_367		; $78f4
	and b			; $78f6
	or b			; $78f7
	ret nz			; $78f8
	ret nc			; $78f9
	ret nc			; $78fa
	ld ($ff00+$f0),a	; $78fb
	nop			; $78fd
	call $7ab4		; $78fe
	jr nc,_label_0e_369	; $7901
	ld l,e			; $7903
	inc (hl)		; $7904
	ld l,$89		; $7905
	ld (hl),$00		; $7907
	ld l,$86		; $7909
	ld (hl),$04		; $790b
	ld l,$90		; $790d
	ld (hl),$55		; $790f
	jr _label_0e_367		; $7911
_label_0e_369:
	call objectGetRelativeAngleWithTempVars		; $7913
	ld e,$89		; $7916
	ld (de),a		; $7918
	jr _label_0e_366		; $7919
	call _ecom_decCounter1		; $791b
	jr nz,_label_0e_366	; $791e
	ld (hl),$04		; $7920
	ld l,$b9		; $7922
	ld e,$89		; $7924
	ld a,(de)		; $7926
	add (hl)		; $7927
	and $1f			; $7928
	ld (de),a		; $792a
	or a			; $792b
	jr nz,_label_0e_366	; $792c
	ld a,(hl)		; $792e
	cpl			; $792f
	inc a			; $7930
	ld (hl),a		; $7931
	jr _label_0e_366		; $7932
	call _ecom_decCounter1		; $7934
	jr nz,_label_0e_372	; $7937
	ld (hl),$3c		; $7939
	ld l,$b0		; $793b
	ld a,(hl)		; $793d
	dec a			; $793e
	ld (hl),a		; $793f
	jr nz,_label_0e_370	; $7940
	ld l,$84		; $7942
	ld (hl),$0b		; $7944
_label_0e_370:
	jp enemySetAnimation		; $7946
	call _ecom_decCounter1		; $7949
	jr nz,_label_0e_371	; $794c
	inc (hl)		; $794e
	ld l,$84		; $794f
	dec (hl)		; $7951
	ld l,$a4		; $7952
	ld (hl),$fd		; $7954
	ld l,$b0		; $7956
	dec (hl)		; $7958
	ld a,(hl)		; $7959
	call enemySetAnimation		; $795a
	jp objectSetVisible82		; $795d
_label_0e_371:
	ld a,(hl)		; $7960
	cp $78			; $7961
	jr nz,_label_0e_372	; $7963
	ld l,$b0		; $7965
	inc (hl)		; $7967
	ld a,(hl)		; $7968
	jp enemySetAnimation		; $7969
_label_0e_372:
	call enemyAnimate		; $796c
	jp _ecom_updateMovingPlatform		; $796f
	call $7ad6		; $7972
	ld e,$84		; $7975
	ld a,(de)		; $7977
	sub $08			; $7978
	rst_jumpTable			; $797a
	add c			; $797b
	ld a,c			; $797c
	adc h			; $797d
	ld a,c			; $797e
	xor (hl)		; $797f
	ld a,c			; $7980
	ld h,d			; $7981
	ld l,e			; $7982
	inc (hl)		; $7983
	ld l,$a4		; $7984
	res 7,(hl)		; $7986
	inc l			; $7988
	ld (hl),$63		; $7989
	ret			; $798b
	ld a,$04		; $798c
	call objectGetRelatedObject1Var		; $798e
	ld a,(hl)		; $7991
	cp $0e			; $7992
	ret nz			; $7994
	ld h,d			; $7995
	ld l,$84		; $7996
	inc (hl)		; $7998
	ld l,$a4		; $7999
	set 7,(hl)		; $799b
	ld l,$8f		; $799d
	ld (hl),$f9		; $799f
	ld l,$94		; $79a1
	xor a			; $79a3
	ldi (hl),a		; $79a4
	ld (hl),a		; $79a5
	call objectSetVisible81		; $79a6
	ld a,$05		; $79a9
	jp enemySetAnimation		; $79ab
	ld a,$04		; $79ae
	call objectGetRelatedObject1Var		; $79b0
	ld a,(hl)		; $79b3
	cp $0d			; $79b4
	jr nz,_label_0e_373	; $79b6
	ld h,d			; $79b8
	ld l,$84		; $79b9
	dec (hl)		; $79bb
	ld l,$a4		; $79bc
	res 7,(hl)		; $79be
	jp objectSetInvisible		; $79c0
_label_0e_373:
	ld l,$86		; $79c3
	ld a,(hl)		; $79c5
	cp $78			; $79c6
	ret nc			; $79c8
	add $03			; $79c9
	and $0c			; $79cb
	rrca			; $79cd
	rrca			; $79ce
	ld hl,$79d9		; $79cf
	rst_addAToHl			; $79d2
	ld e,$8d		; $79d3
	ld a,(de)		; $79d5
	add (hl)		; $79d6
	ld (de),a		; $79d7
	ret			; $79d8
	nop			; $79d9
	ld (bc),a		; $79da
	nop			; $79db
	cp $1a			; $79dc
	sub $08			; $79de
	rst_jumpTable			; $79e0
	push hl			; $79e1
	ld a,c			; $79e2
.DB $fc				; $79e3
	ld a,c			; $79e4
	call _ecom_decCounter1		; $79e5
	jr nz,_label_0e_375	; $79e8
	call $7b1c		; $79ea
	jr c,_label_0e_375	; $79ed
_label_0e_374:
	call getRandomNumber_noPreserveVars		; $79ef
	and $50			; $79f2
	add $5a			; $79f4
	ld e,$86		; $79f6
	ld (de),a		; $79f8
_label_0e_375:
	jp $7ad6		; $79f9
	call _ecom_decCounter1		; $79fc
	jr z,_label_0e_376	; $79ff
	ld a,(hl)		; $7a01
	cp $5a			; $7a02
	jr nz,_label_0e_375	; $7a04
	ld b,$31		; $7a06
	call _ecom_spawnProjectile		; $7a08
	jr _label_0e_375		; $7a0b
_label_0e_376:
	ld l,$b0		; $7a0d
	dec (hl)		; $7a0f
	ld a,(hl)		; $7a10
	call enemySetAnimation		; $7a11
	ld h,d			; $7a14
	ld l,$84		; $7a15
	ld (hl),$08		; $7a17
	ld l,$a5		; $7a19
	ld (hl),$0a		; $7a1b
	jr _label_0e_374		; $7a1d
	push bc			; $7a1f
	push hl			; $7a20
	ldh a,(<hFF8F)	; $7a21
	ld b,a			; $7a23
	ld a,$07		; $7a24
	sub b			; $7a26
	ld (hl),a		; $7a27
	call $7af2		; $7a28
	ld e,$8b		; $7a2b
	ld a,(de)		; $7a2d
	add (hl)		; $7a2e
	ld b,a			; $7a2f
	inc hl			; $7a30
	ld e,$8d		; $7a31
	ld a,(de)		; $7a33
	add (hl)		; $7a34
	ld c,a			; $7a35
	pop hl			; $7a36
	ld l,e			; $7a37
	ld (hl),c		; $7a38
	ld l,$8b		; $7a39
	ld (hl),b		; $7a3b
	pop bc			; $7a3c
	ld l,$96		; $7a3d
	ld a,$80		; $7a3f
	ldi (hl),a		; $7a41
	ld (hl),c		; $7a42
	ret			; $7a43
	ld h,d			; $7a44
	ld l,$aa		; $7a45
	ld e,$82		; $7a47
	ld a,(de)		; $7a49
	dec a			; $7a4a
	jr z,_label_0e_378	; $7a4b
	dec a			; $7a4d
	ret z			; $7a4e
	ld l,$a9		; $7a4f
	ld a,(hl)		; $7a51
	or a			; $7a52
	ret nz			; $7a53
	ld a,$36		; $7a54
	call objectGetRelatedObject1Var		; $7a56
	dec (hl)		; $7a59
	jr z,_label_0e_377	; $7a5a
	ld l,$90		; $7a5c
	ld a,(hl)		; $7a5e
	add $14			; $7a5f
	ld (hl),a		; $7a61
	ret			; $7a62
_label_0e_377:
	ld l,$84		; $7a63
	ld (hl),$0b		; $7a65
	ld l,$90		; $7a67
	ld (hl),$50		; $7a69
	ld l,$a5		; $7a6b
	ld (hl),$4c		; $7a6d
	ret			; $7a6f
_label_0e_378:
	ld l,$aa		; $7a70
	ld a,(hl)		; $7a72
	cp $a0			; $7a73
	jr nz,_label_0e_379	; $7a75
	ld l,$ba		; $7a77
	ld (hl),$3c		; $7a79
_label_0e_379:
	ld l,$a9		; $7a7b
	ld (hl),$40		; $7a7d
	ld l,$b6		; $7a7f
	ld a,(hl)		; $7a81
	or a			; $7a82
	ret nz			; $7a83
	ld l,$aa		; $7a84
	ld a,(hl)		; $7a86
	cp $96			; $7a87
	ret nz			; $7a89
	ld l,$b0		; $7a8a
	ld a,(hl)		; $7a8c
	inc a			; $7a8d
	cp $03			; $7a8e
	ld (hl),a		; $7a90
	jr nc,_label_0e_380	; $7a91
	ld l,$86		; $7a93
	ld (hl),$3c		; $7a95
	ld l,$84		; $7a97
	ld (hl),$0d		; $7a99
	call enemySetAnimation		; $7a9b
	jp objectSetVisible81		; $7a9e
_label_0e_380:
	ld (hl),$03		; $7aa1
	ld l,$84		; $7aa3
	ld (hl),$0e		; $7aa5
	ld l,$86		; $7aa7
	ld (hl),$b4		; $7aa9
	ld l,$a4		; $7aab
	ld (hl),$a9		; $7aad
	ld a,$03		; $7aaf
	jp enemySetAnimation		; $7ab1
	ld h,d			; $7ab4
	ld l,$b7		; $7ab5
	call _ecom_readPositionVars		; $7ab7
	sub c			; $7aba
	add $04			; $7abb
	cp $09			; $7abd
	ret nc			; $7abf
	ldh a,(<hFF8F)	; $7ac0
	sub b			; $7ac2
	add $04			; $7ac3
	cp $09			; $7ac5
	ret			; $7ac7
	ld h,d			; $7ac8
	ld l,$ba		; $7ac9
	ld a,(hl)		; $7acb
	or a			; $7acc
	ret z			; $7acd
	pop bc			; $7ace
	dec (hl)		; $7acf
	ret nz			; $7ad0
	ld l,$a4		; $7ad1
	set 7,(hl)		; $7ad3
	ret			; $7ad5
	ld a,$0b		; $7ad6
	call objectGetRelatedObject1Var		; $7ad8
	ld b,(hl)		; $7adb
	ld l,$8d		; $7adc
	ld c,(hl)		; $7ade
	ld l,$a1		; $7adf
	ld e,$82		; $7ae1
	ld a,(de)		; $7ae3
	call $7af2		; $7ae4
	ld e,$8b		; $7ae7
	ldi a,(hl)		; $7ae9
	add b			; $7aea
	ld (de),a		; $7aeb
	ld e,$8d		; $7aec
	ld a,(hl)		; $7aee
	add c			; $7aef
	ld (de),a		; $7af0
	ret			; $7af1
	sub $02			; $7af2
	ld e,a			; $7af4
	add a			; $7af5
	add e			; $7af6
	add a			; $7af7
	add (hl)		; $7af8
	ld hl,$7afe		; $7af9
	rst_addAToHl			; $7afc
	ret			; $7afd
	ld a,(bc)		; $7afe
	nop			; $7aff
	ld a,(bc)		; $7b00
	nop			; $7b01
	ld a,(bc)		; $7b02
	nop			; $7b03
	ld a,($ff00+$0a)	; $7b04
	ld a,($ff00+c)		; $7b06
	ld a,(bc)		; $7b07
	pop af			; $7b08
	ld a,(bc)		; $7b09
	nop			; $7b0a
	dec bc			; $7b0b
	ld (bc),a		; $7b0c
	dec bc			; $7b0d
	ld bc,$000b		; $7b0e
	push af			; $7b11
	ld bc,$02f5		; $7b12
	push af			; $7b15
	ld a,($ff00+$f6)	; $7b16
	pop af			; $7b18
	or $f2			; $7b19
	or $cd			; $7b1b
	ld d,d			; $7b1d
	ld e,$47		; $7b1e
	ld e,$82		; $7b20
	ld a,(de)		; $7b22
	sub $03			; $7b23
	swap a			; $7b25
	rrca			; $7b27
	sub b			; $7b28
	cp $f8			; $7b29
	ret nc			; $7b2b
	ld h,d			; $7b2c
	ld l,$84		; $7b2d
	inc (hl)		; $7b2f
	ld l,$a5		; $7b30
	ld (hl),$62		; $7b32
	ld l,$86		; $7b34
	ld (hl),$78		; $7b36
	ld l,$b0		; $7b38
	inc (hl)		; $7b3a
	ld a,(hl)		; $7b3b
	call enemySetAnimation		; $7b3c
	scf			; $7b3f
	ret			; $7b40

; ==============================================================================
; ENEMYID_MEDUSA_HEAD
; ==============================================================================
enemyCode7f:
	jr z,_label_0e_386	; $7b41
	sub $03			; $7b43
	jr c,_label_0e_381	; $7b45
	jp z,_enemyBoss_dead		; $7b47
	dec a			; $7b4a
	jr z,_label_0e_383	; $7b4b
_label_0e_381:
	ld h,d			; $7b4d
	ld l,$ad		; $7b4e
	ld a,(hl)		; $7b50
	or a			; $7b51
	ret z			; $7b52
	dec (hl)		; $7b53
	ld l,$a1		; $7b54
	bit 0,(hl)		; $7b56
	jr z,_label_0e_382	; $7b58
	ld l,$a0		; $7b5a
	ld (hl),$01		; $7b5c
	call enemyAnimate		; $7b5e
_label_0e_382:
	jp _ecom_updateKnockback		; $7b61
_label_0e_383:
	ld h,d			; $7b64
	ld l,$aa		; $7b65
	ld a,(hl)		; $7b67
	res 7,a			; $7b68
	sub $04			; $7b6a
	jr c,_label_0e_386	; $7b6c
	sub $06			; $7b6e
	jr nc,_label_0e_384	; $7b70
	ld l,$b0		; $7b72
	ld (hl),$01		; $7b74
	ld l,$ae		; $7b76
	ld (hl),$00		; $7b78
	ret			; $7b7a
_label_0e_384:
	sub $13			; $7b7b
	jr nz,_label_0e_385	; $7b7d
	ld l,$ad		; $7b7f
	ld (hl),$0d		; $7b81
	inc l			; $7b83
	ld (hl),$2d		; $7b84
	call objectGetAngleTowardEnemyTarget		; $7b86
	xor $10			; $7b89
	ld e,$ac		; $7b8b
	ld (de),a		; $7b8d
	ld a,$4e		; $7b8e
	jp playSound		; $7b90
_label_0e_385:
	ld l,$ae		; $7b93
	ld a,(hl)		; $7b95
	or a			; $7b96
	ret nz			; $7b97
_label_0e_386:
	ld e,$84		; $7b98
	ld a,(de)		; $7b9a
	rst_jumpTable			; $7b9b
	or (hl)			; $7b9c
	ld a,e			; $7b9d
	call z,$107b		; $7b9e
	ld a,h			; $7ba1
	stop			; $7ba2
	ld a,h			; $7ba3
	stop			; $7ba4
	ld a,h			; $7ba5
	stop			; $7ba6
	ld a,h			; $7ba7
	stop			; $7ba8
	ld a,h			; $7ba9
	stop			; $7baa
	ld a,h			; $7bab
	ld de,$637c		; $7bac
	ld a,h			; $7baf
	ld a,d			; $7bb0
	ld a,h			; $7bb1
	rlca			; $7bb2
	ld a,l			; $7bb3
	ret nc			; $7bb4
	ld a,l			; $7bb5
	ld e,$82		; $7bb6
	ld a,(de)		; $7bb8
	or a			; $7bb9
	ld a,$3c		; $7bba
	jp nz,_ecom_setSpeedAndState8		; $7bbc
	ld a,$7f		; $7bbf
	ld b,$88		; $7bc1
	call _enemyBoss_initializeRoom		; $7bc3
	ld e,$84		; $7bc6
	ld a,$01		; $7bc8
	ld (de),a		; $7bca
	ret			; $7bcb
	ld a,(wcc93)		; $7bcc
	or a			; $7bcf
	ret nz			; $7bd0
	ld b,$04		; $7bd1
	call checkBEnemySlotsAvailable		; $7bd3
	ret nz			; $7bd6
	ld bc,$7f04		; $7bd7
_label_0e_387:
	call _ecom_spawnUncountedEnemyWithSubid01		; $7bda
	ld (hl),c		; $7bdd
	ld a,c			; $7bde
	dec a			; $7bdf
	ld e,a			; $7be0
	add a			; $7be1
	add e			; $7be2
	ld de,$7c04		; $7be3
	call addAToDe		; $7be6
	ld l,$8b		; $7be9
	ld a,(de)		; $7beb
	ldi (hl),a		; $7bec
	inc de			; $7bed
	inc l			; $7bee
	ld a,(de)		; $7bef
	ld (hl),a		; $7bf0
	inc de			; $7bf1
	ld l,$89		; $7bf2
	ld a,(de)		; $7bf4
	ld (hl),a		; $7bf5
	dec c			; $7bf6
	jr nz,_label_0e_387	; $7bf7
	ldh a,(<hActiveObject)	; $7bf9
	ld d,a			; $7bfb
	ld l,$80		; $7bfc
	ld e,l			; $7bfe
	ld a,(de)		; $7bff
	ld (hl),a		; $7c00
	jp enemyDelete		; $7c01
	ld ($0078),sp		; $7c04
	ld e,b			; $7c07
	ret c			; $7c08
	ld ($78a8),sp		; $7c09
	stop			; $7c0c
	ld e,b			; $7c0d
	jr $18			; $7c0e
	ret			; $7c10
	inc e			; $7c11
	ld a,(de)		; $7c12
	or a			; $7c13
	jr nz,_label_0e_388	; $7c14
	ld h,d			; $7c16
	ld l,e			; $7c17
	inc (hl)		; $7c18
	inc l			; $7c19
	ld (hl),$70		; $7c1a
	ld l,$8f		; $7c1c
	ld (hl),$fe		; $7c1e
	ld l,$82		; $7c20
	ld a,(hl)		; $7c22
	dec a			; $7c23
	ld a,$8d		; $7c24
	call z,playSound		; $7c26
_label_0e_388:
	call _ecom_flickerVisibility		; $7c29
	ld a,(wFrameCounter)		; $7c2c
	rrca			; $7c2f
	ret c			; $7c30
	call _ecom_decCounter1		; $7c31
	jr z,_label_0e_389	; $7c34
	ld a,(hl)		; $7c36
	ld e,$89		; $7c37
	ld bc,$5878		; $7c39
	call objectSetPositionInCircleArc		; $7c3c
	ld e,$89		; $7c3f
	ld a,(de)		; $7c41
	inc a			; $7c42
	and $1f			; $7c43
	ld (de),a		; $7c45
	ret			; $7c46
_label_0e_389:
	ld e,$82		; $7c47
	ld a,(de)		; $7c49
	dec a			; $7c4a
	jp nz,enemyDelete		; $7c4b
	ld (hl),$1e		; $7c4e
	ld l,$84		; $7c50
	inc (hl)		; $7c52
	call objectSetVisible83		; $7c53
	ld a,$73		; $7c56
	call playSound		; $7c58
	ld a,$2e		; $7c5b
	ld (wActiveMusic),a		; $7c5d
	jp playSound		; $7c60
	call _ecom_decCounter1		; $7c63
	ret nz			; $7c66
	inc (hl)		; $7c67
	ld bc,$020b		; $7c68
	call _enemyBoss_spawnShadow		; $7c6b
	ret nz			; $7c6e
	ld h,d			; $7c6f
	ld l,e			; $7c70
	inc (hl)		; $7c71
	inc l			; $7c72
	ld (hl),$00		; $7c73
	ld l,$a4		; $7c75
	set 7,(hl)		; $7c77
	ret			; $7c79
	inc e			; $7c7a
	ld a,(de)		; $7c7b
	rst_jumpTable			; $7c7c
	add l			; $7c7d
	ld a,h			; $7c7e
	xor h			; $7c7f
	ld a,h			; $7c80
	jp $f97c		; $7c81
	ld a,h			; $7c84
	ld h,d			; $7c85
	ld l,e			; $7c86
	inc (hl)		; $7c87
	inc l			; $7c88
	ld (hl),$b4		; $7c89
	inc l			; $7c8b
	ld (hl),$5a		; $7c8c
	ld l,$90		; $7c8e
	ld (hl),$46		; $7c90
	ld l,$b4		; $7c92
	ld (hl),$08		; $7c94
	ld l,$b0		; $7c96
	ld (hl),$00		; $7c98
	ld l,$b6		; $7c9a
	ld a,(hl)		; $7c9c
	ld (hl),$00		; $7c9d
	or a			; $7c9f
	jr z,_label_0e_391	; $7ca0
	ld b,$46		; $7ca2
	call _ecom_spawnProjectile		; $7ca4
	ld a,$01		; $7ca7
	jp enemySetAnimation		; $7ca9
	ld c,$40		; $7cac
	call objectCheckLinkWithinDistance		; $7cae
	jr c,_label_0e_390	; $7cb1
	call _ecom_updateAngleTowardTarget		; $7cb3
	call objectApplySpeed		; $7cb6
	jr _label_0e_391		; $7cb9
_label_0e_390:
	ld e,$85		; $7cbb
	ld a,$02		; $7cbd
	ld (de),a		; $7cbf
_label_0e_391:
	jp enemyAnimate		; $7cc0
	call $7e84		; $7cc3
	jr nz,_label_0e_392	; $7cc6
	ld l,e			; $7cc8
	inc (hl)		; $7cc9
	jr _label_0e_391		; $7cca
_label_0e_392:
	call $7ece		; $7ccc
	jr nz,_label_0e_391	; $7ccf
	call _ecom_decCounter1		; $7cd1
	call z,$7eb5		; $7cd4
	call objectGetAngleTowardEnemyTarget		; $7cd7
	ld c,a			; $7cda
	ld e,$b4		; $7cdb
	ld a,(de)		; $7cdd
	add c			; $7cde
	and $1f			; $7cdf
	ld e,$89		; $7ce1
	ld (de),a		; $7ce3
	call $7e8d		; $7ce4
	call $414c		; $7ce7
	jr nz,_label_0e_391	; $7cea
	ld e,$b4		; $7cec
	ld a,(de)		; $7cee
	cpl			; $7cef
	inc a			; $7cf0
	ld (de),a		; $7cf1
	ld a,$c9		; $7cf2
	call playSound		; $7cf4
	jr _label_0e_391		; $7cf7
	ld h,d			; $7cf9
	ld l,e			; $7cfa
	ld (hl),$00		; $7cfb
	dec l			; $7cfd
	inc (hl)		; $7cfe
	call getRandomNumber		; $7cff
	cp $60			; $7d02
	ret nc			; $7d04
	inc (hl)		; $7d05
	ret			; $7d06
	inc e			; $7d07
	ld a,(de)		; $7d08
	rst_jumpTable			; $7d09
	ld a,(de)		; $7d0a
	ld a,l			; $7d0b
	inc h			; $7d0c
	ld a,l			; $7d0d
	ld c,l			; $7d0e
	ld a,l			; $7d0f
	ld e,d			; $7d10
	ld a,l			; $7d11
	ld l,e			; $7d12
	ld a,l			; $7d13
	ld a,(hl)		; $7d14
	ld a,l			; $7d15
	sub d			; $7d16
	ld a,l			; $7d17
	jp nz,$627d		; $7d18
	ld l,e			; $7d1b
	inc (hl)		; $7d1c
	inc l			; $7d1d
	ld (hl),$1e		; $7d1e
	ld l,$a4		; $7d20
	res 7,(hl)		; $7d22
	call _ecom_decCounter1		; $7d24
	jp nz,_ecom_flickerVisibility		; $7d27
	ld (hl),$14		; $7d2a
	ld l,e			; $7d2c
	inc (hl)		; $7d2d
	ld l,$8f		; $7d2e
	ld (hl),$00		; $7d30
	ld l,$8d		; $7d32
	ld a,(hl)		; $7d34
	cp $78			; $7d35
	ld c,$20		; $7d37
	ld a,$d4		; $7d39
	jr c,_label_0e_393	; $7d3b
	ld c,a			; $7d3d
	ld a,$1c		; $7d3e
_label_0e_393:
	ld (hl),c		; $7d40
	ld l,$b2		; $7d41
	ldd (hl),a		; $7d43
	ld (hl),$20		; $7d44
	ld l,$8b		; $7d46
	ld (hl),$20		; $7d48
	jp objectSetInvisible		; $7d4a
	call _ecom_decCounter1		; $7d4d
	ret nz			; $7d50
	ld (hl),$1e		; $7d51
	ld l,e			; $7d53
	inc (hl)		; $7d54
	ld l,$8f		; $7d55
	ld (hl),$fe		; $7d57
	ret			; $7d59
	call _ecom_decCounter1		; $7d5a
	jp nz,_ecom_flickerVisibility		; $7d5d
	ld (hl),$0f		; $7d60
	ld l,e			; $7d62
	inc (hl)		; $7d63
	ld l,$a4		; $7d64
	set 7,(hl)		; $7d66
	jp objectSetVisible83		; $7d68
	call _ecom_decCounter1		; $7d6b
	jr nz,_label_0e_396	; $7d6e
	ld (hl),$05		; $7d70
	ld l,e			; $7d72
	inc (hl)		; $7d73
	ld b,$45		; $7d74
	call _ecom_spawnProjectile		; $7d76
	ld a,$02		; $7d79
	jp enemySetAnimation		; $7d7b
	call _ecom_decCounter1		; $7d7e
	jr nz,_label_0e_395	; $7d81
	ld l,e			; $7d83
	inc (hl)		; $7d84
	call getRandomNumber_noPreserveVars		; $7d85
	and $03			; $7d88
	ld hl,$7edf		; $7d8a
	rst_addAToHl			; $7d8d
	ld e,$90		; $7d8e
	ld a,(hl)		; $7d90
	ld (de),a		; $7d91
	ld h,d			; $7d92
	ld l,$b1		; $7d93
	call _ecom_readPositionVars		; $7d95
	sub c			; $7d98
	add $02			; $7d99
	cp $05			; $7d9b
	jr nc,_label_0e_394	; $7d9d
	ldh a,(<hFF8F)	; $7d9f
	sub b			; $7da1
	add $02			; $7da2
	cp $05			; $7da4
	jr nc,_label_0e_394	; $7da6
	ld l,$85		; $7da8
	inc (hl)		; $7daa
	inc l			; $7dab
	ld (hl),$08		; $7dac
	xor a			; $7dae
	jp enemySetAnimation		; $7daf
_label_0e_394:
	call _ecom_moveTowardPosition		; $7db2
_label_0e_395:
	ld a,(wFrameCounter)		; $7db5
	and $07			; $7db8
	ld a,$a8		; $7dba
	call z,playSound		; $7dbc
_label_0e_396:
	jp enemyAnimate		; $7dbf
	call _ecom_decCounter1		; $7dc2
	jr nz,_label_0e_395	; $7dc5
	ld l,e			; $7dc7
	xor a			; $7dc8
	ldd (hl),a		; $7dc9
	inc (hl)		; $7dca
	call _ecom_killRelatedObj2		; $7dcb
	jr _label_0e_396		; $7dce
	inc e			; $7dd0
	ld a,(de)		; $7dd1
	rst_jumpTable			; $7dd2
	push hl			; $7dd3
	ld a,l			; $7dd4
	pop af			; $7dd5
	ld a,l			; $7dd6
	ld (bc),a		; $7dd7
	ld a,(hl)		; $7dd8
	ld d,$7e		; $7dd9
	ldi a,(hl)		; $7ddb
	ld a,(hl)		; $7ddc
	jr c,_label_0e_398	; $7ddd
	ld c,b			; $7ddf
	ld a,(hl)		; $7de0
	ld l,b			; $7de1
	ld a,(hl)		; $7de2
	halt			; $7de3
	ld a,(hl)		; $7de4
	ld h,d			; $7de5
	ld l,e			; $7de6
	inc (hl)		; $7de7
	inc l			; $7de8
	ld (hl),$1e		; $7de9
	ld l,$a4		; $7deb
	res 7,(hl)		; $7ded
	jr _label_0e_397		; $7def
	call _ecom_decCounter1		; $7df1
	jp nz,_ecom_flickerVisibility		; $7df4
	ld (hl),$14		; $7df7
	ld l,e			; $7df9
	inc (hl)		; $7dfa
	ld l,$8f		; $7dfb
	ld (hl),$00		; $7dfd
	jp objectSetInvisible		; $7dff
	call _ecom_decCounter1		; $7e02
	ret nz			; $7e05
	ld (hl),$1e		; $7e06
	ld l,e			; $7e08
	inc (hl)		; $7e09
	ld l,$8b		; $7e0a
	ld (hl),$58		; $7e0c
	ld l,$8d		; $7e0e
	ld (hl),$78		; $7e10
	ld l,$8f		; $7e12
	ld (hl),$fe		; $7e14
	call _ecom_decCounter1		; $7e16
	jp nz,_ecom_flickerVisibility		; $7e19
	ld (hl),$14		; $7e1c
	ld l,e			; $7e1e
	inc (hl)		; $7e1f
	ld l,$a4		; $7e20
	set 7,(hl)		; $7e22
	call objectSetVisible83		; $7e24
_label_0e_397:
	jp enemyAnimate		; $7e27
	call _ecom_decCounter1		; $7e2a
	jr nz,_label_0e_397	; $7e2d
	ld (hl),$14		; $7e2f
	ld l,e			; $7e31
	inc (hl)		; $7e32
	ld a,$04		; $7e33
	jp enemySetAnimation		; $7e35
	call _ecom_decCounter1		; $7e38
	jr nz,_label_0e_397	; $7e3b
	ld (hl),$20		; $7e3d
	ld l,e			; $7e3f
	inc (hl)		; $7e40
	ld a,$d2		; $7e41
	call playSound		; $7e43
	jr _label_0e_397		; $7e46
	call _ecom_decCounter1		; $7e48
	jr z,_label_0e_399	; $7e4b
	ld a,(hl)		; $7e4d
	rrca			; $7e4e
	jr nc,_label_0e_397	; $7e4f
	ld b,$44		; $7e51
	call _ecom_spawnProjectile		; $7e53
	jr nz,_label_0e_397	; $7e56
	ld e,$86		; $7e58
	ld a,(de)		; $7e5a
	dec a			; $7e5b
	rrca			; $7e5c
_label_0e_398:
	ld l,$c2		; $7e5d
	ld (hl),a		; $7e5f
	jr _label_0e_397		; $7e60
_label_0e_399:
	ld (hl),$0c		; $7e62
	ld l,e			; $7e64
	inc (hl)		; $7e65
	jr _label_0e_397		; $7e66
	call _ecom_decCounter1		; $7e68
	jr nz,_label_0e_397	; $7e6b
	ld (hl),$0f		; $7e6d
	ld l,e			; $7e6f
	inc (hl)		; $7e70
	ld a,$03		; $7e71
	jp enemySetAnimation		; $7e73
	call _ecom_decCounter1		; $7e76
	jp nz,$7e27		; $7e79
	ld l,e			; $7e7c
	xor a			; $7e7d
	ldd (hl),a		; $7e7e
	ld (hl),$0a		; $7e7f
	jp enemySetAnimation		; $7e81
	ld a,(wFrameCounter)		; $7e84
	and $07			; $7e87
	ret nz			; $7e89
	jp _ecom_decCounter2		; $7e8a
	ld h,d			; $7e8d
	ld l,$8b		; $7e8e
	ldh a,(<hEnemyTargetY)	; $7e90
	sub (hl)		; $7e92
	jr nc,_label_0e_400	; $7e93
	cpl			; $7e95
	inc a			; $7e96
_label_0e_400:
	ld b,a			; $7e97
	ld l,$8d		; $7e98
	ldh a,(<hEnemyTargetX)	; $7e9a
	sub (hl)		; $7e9c
	jr nc,_label_0e_401	; $7e9d
	cpl			; $7e9f
	inc a			; $7ea0
_label_0e_401:
	add b			; $7ea1
	and $f0			; $7ea2
	cp $50			; $7ea4
	ret z			; $7ea6
	cp $40			; $7ea7
	ret z			; $7ea9
	jr nc,_label_0e_402	; $7eaa
	ld a,c			; $7eac
	xor $10			; $7ead
	ld c,a			; $7eaf
_label_0e_402:
	ld b,$1e		; $7eb0
	jp _ecom_applyGivenVelocity		; $7eb2
	ld (hl),$3c		; $7eb5
	inc l			; $7eb7
	ldd a,(hl)		; $7eb8
	cp $0f			; $7eb9
	ret c			; $7ebb
	call getRandomNumber		; $7ebc
	cp $60			; $7ebf
	ret nc			; $7ec1
	ld (hl),$5a		; $7ec2
	ld b,$46		; $7ec4
	call _ecom_spawnProjectile		; $7ec6
	ld a,$01		; $7ec9
	jp enemySetAnimation		; $7ecb
	ld h,d			; $7ece
	ld l,$a1		; $7ecf
	ld a,(hl)		; $7ed1
	dec a			; $7ed2
	ret z			; $7ed3
	ld l,$b0		; $7ed4
	bit 0,(hl)		; $7ed6
	ret z			; $7ed8
	ld (hl),$00		; $7ed9
	ld l,$85		; $7edb
	inc (hl)		; $7edd
	ret			; $7ede
	ld e,d			; $7edf
	ld h,h			; $7ee0
	ld l,(hl)		; $7ee1
	ld a,b			; $7ee2
