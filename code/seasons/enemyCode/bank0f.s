; ==============================================================================
; ENEMYID_MERGED_TWINROVA
;
; Variables:
;   subid: 0 or 1 for lava or ice
;   var03: 0 or 1 for two different attacks
;   var30: Counter until room will be swapped
;   var31: ?
;   var32: Value from 0-7, determines what attack to use in lava phase
;   var33: Minimum # frames of movement before attacking?
;   var34: Nonzero if dead?
;   var36: Target position index (multiple of 2)
;   var37/var38: Target position to move to?
;   var39: Room swapping is disabled while this is nonzero.
;   var3a: Counter until twinrova's vulnerability ends and room will be swapped
;   var3b: # frames to wait in place before choosing new target position
; ==============================================================================
enemyCode01:
	jr z,@normalStatus	; $4594
	sub ENEMYSTATUS_NO_HEALTH			; $4596
	ret c			; $4598
	jr nz,@collisionOccurred	; $4599

	; Dead
	ld e,Enemy.var34		; $459b
	ld a,(de)		; $459d
	or a			; $459e
	jp z,_mergedTwinrova_deathCutscene		; $459f

	ld h,d			; $45a2
	ld l,Enemy.var3a		; $45a3
	ld (hl),120		; $45a5

	ld l,Enemy.health		; $45a7
	ld (hl),20		; $45a9

	ld l,Enemy.collisionType		; $45ab
	set 7,(hl)		; $45ad

	ld l,Enemy.oamFlagsBackup		; $45af
	xor a			; $45b1
	ldi (hl),a		; $45b2
	ld (hl),a		; $45b3

	ld l,Enemy.collisionType		; $45b4
.ifdef ROM_AGES
	ld (hl),$ff		; $45b6
.else
	ld (hl),$87		; $45b6
.endif

	ld a,$09		; $45b8
	jp enemySetAnimation		; $45ba

@collisionOccurred:
	ld e,Enemy.var3a		; $45bd
	ld a,(de)		; $45bf
	or a			; $45c0
	jr z,@normalStatus	; $45c1

	; Check that the collision was with a seed.
	ld e,Enemy.var2a		; $45c3
	ld a,(de)		; $45c5
	res 7,a			; $45c6
	sub ITEMCOLLISION_MYSTERY_SEED			; $45c8
	cp ITEMCOLLISION_GALE_SEED - ITEMCOLLISION_MYSTERY_SEED + 1
	jr nc,@normalStatus	; $45cc

	ld a,SND_BOSS_DAMAGE		; $45ce
	call playSound		; $45d0

	ld h,d			; $45d3
	ld l,Enemy.invincibilityCounter		; $45d4
	ld (hl),45		; $45d6

	ld l,Enemy.var34		; $45d8
	dec (hl)		; $45da
	jr nz,@normalStatus	; $45db

	; Dead?
	ld l,Enemy.health		; $45dd
	ld (hl),$00		; $45df

	ld l,Enemy.collisionType		; $45e1
	res 7,(hl)		; $45e3

	ld l,Enemy.state2		; $45e5
	ld (hl),$00		; $45e7
	inc l			; $45e9
	ld (hl),216 ; [counter1]
	ld a,SNDCTRL_STOPMUSIC		; $45ec
	jp playSound		; $45ee

@normalStatus:
	call _mergedTwinrova_checkTimeToSwapRoomFromDamage		; $45f1
	call _mergedTwinrova_checkTimeToSwapRoomFromTimer		; $45f4
	call _ecom_getSubidAndCpStateTo08		; $45f7
	cp $0c			; $45fa
	jr nc,@stateCOrHigher	; $45fc
	rst_jumpTable			; $45fe
	.dw _mergedTwinrova_state_uninitialized
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state_stub
	.dw _mergedTwinrova_state8
	.dw _mergedTwinrova_state9
	.dw _mergedTwinrova_stateA
	.dw _mergedTwinrova_stateB

@stateCOrHigher:
	ld a,b			; $4617
	rst_jumpTable			; $4618
	.dw _mergedTwinrova_lavaRoom
	.dw _mergedTwinrova_iceRoom


; Fight just starting
_mergedTwinrova_state_uninitialized:
	ld a,ENEMYID_MERGED_TWINROVA		; $461d
	ld (wEnemyIDToLoadExtraGfx),a		; $461f

	ldh a,(<hActiveObject)	; $4622
	ld d,a			; $4624
	ld bc,$0012		; $4625
	call _enemyBoss_spawnShadow		; $4628
	ret nz			; $462b

	ld a,SPEED_180		; $462c
	call _ecom_setSpeedAndState8		; $462e

	ld l,Enemy.counter1		; $4631
	ld (hl),$08		; $4633
	ld l,Enemy.var30		; $4635
	ld (hl),210		; $4637
	ld l,Enemy.var34		; $4639
	ld (hl),$05		; $463b
	ld l,Enemy.zh		; $463d
	ld (hl),$ff		; $463f

	call objectSetVisible83		; $4641
	ld bc,TX_2f0b		; $4644
	jp showText		; $4647


_mergedTwinrova_state_stub:
	ret			; $464a


; Delay before moving to centre?
_mergedTwinrova_state8:
	call _ecom_decCounter1		; $464b
	ret nz			; $464e

	ld l,e			; $464f
	inc (hl) ; [state] = 9

	ld l,Enemy.collisionType		; $4651
	set 7,(hl)		; $4653

	call getRandomNumber_noPreserveVars		; $4655
	and $01			; $4658
	ld e,Enemy.subid		; $465a
	ld (de),a		; $465c
	ld b,a			; $465d

	xor $01			; $465e
	inc a			; $4660
	ld e,Enemy.oamFlagsBackup		; $4661
	ld (de),a		; $4663
	inc e			; $4664
	ld (de),a		; $4665

	ld a,b			; $4666
	inc a			; $4667
	call enemySetAnimation		; $4668

	xor a			; $466b
	ld (wDisabledObjects),a		; $466c
	ld (wDisableLinkCollisionsAndMenu),a		; $466f

	ld a,MUS_TWINROVA		; $4672
	ld (wActiveMusic),a		; $4674
	jp playSound		; $4677


; Moving toward centre of screen prior to swapping room
_mergedTwinrova_state9:
	ld bc,$4878		; $467a
	ld h,d			; $467d
	ld l,Enemy.yh		; $467e
	ldi a,(hl)		; $4680
	ldh (<hFF8F),a	; $4681
	inc l			; $4683
	ld a,(hl)		; $4684
	ldh (<hFF8E),a	; $4685
	call _mergedTwinrova_checkPositionsCloseEnough		; $4687
	jp nc,_ecom_moveTowardPosition		; $468a

	; Reached centre of screen.
	ld l,e			; $468d
	inc (hl) ; [state] = $0a
	inc l			; $468f
	ld (hl),$00 ; [state2]
	inc l			; $4692
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType		; $4695
	ld (hl),$80|ENEMYID_BEAMOS		; $4697

	ld l,Enemy.var39		; $4699
	ld (hl),$01		; $469b
	ld l,Enemy.var3b		; $469d
	ld (hl),$00		; $469f
	ret			; $46a1


; In the process of converting the room to lava or ice
_mergedTwinrova_stateA:
	inc e			; $46a2
	ld a,(de) ; [state2]
	rst_jumpTable			; $46a4
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call _ecom_decCounter1		; $46af
	jr z,++			; $46b2

	; Flicker palettes?
	ld l,Enemy.oamFlagsBackup		; $46b4
	ld a,(hl)		; $46b6
	xor $03			; $46b7
	ldi (hl),a		; $46b9
	ld (hl),a		; $46ba
	ret			; $46bb
++
	ld l,e			; $46bc
	inc (hl) ; [state2] = 1
	inc l			; $46be
	ld (hl),30 ; [counter1]

	; Swap subid
	ld l,Enemy.subid		; $46c1
	ld a,(hl)		; $46c3
	inc a			; $46c4
	and $01			; $46c5
	ld b,a			; $46c7
	ld (hl),a		; $46c8

	xor $01			; $46c9
	inc a			; $46cb
	ld l,Enemy.oamFlagsBackup		; $46cc
	ldi (hl),a		; $46ce
	ld (hl),a		; $46cf
	ld a,b			; $46d0
	inc a			; $46d1
	jp enemySetAnimation		; $46d2

@substate1:
	call _ecom_decCounter1		; $46d5
	jr z,++			; $46d8

	; Flicker palettes?
	ld l,Enemy.oamFlagsBackup		; $46da
	ld a,(hl)		; $46dc
	xor $03			; $46dd
	ldi (hl),a		; $46df
	ld (hl),a		; $46e0
	ret			; $46e1
++
	ld l,e			; $46e2
	inc (hl) ; [state2] = 2

	ld l,Enemy.subid		; $46e4
	ld a,(hl)		; $46e6
	xor $01			; $46e7
	inc a			; $46e9
	ld l,Enemy.oamFlagsBackup		; $46ea
	ldi (hl),a		; $46ec
	ld (hl),a		; $46ed

	ld a,$01		; $46ee
	ld (wDisableLinkCollisionsAndMenu),a		; $46f0

	call fastFadeoutToWhite		; $46f3
	ld a,SND_ENDLESS		; $46f6
	jp playSound		; $46f8

@substate2:
	ld a,$03		; $46fb
	ld (de),a ; [state2]

	call disableLcd		; $46fe

	ld e,Enemy.subid		; $4701
	ld a,(de)		; $4703
	inc a			; $4704
	ld (wTwinrovaTileReplacementMode),a		; $4705

	call func_131f		; $4708
	ld a,$02		; $470b
	call loadGfxRegisterStateIndex		; $470d
	ldh a,(<hActiveObject)	; $4710
	ld d,a			; $4712
	ret			; $4713

@substate3:
	ld a,$04		; $4714
	ld (de),a		; $4716
	jp fadeinFromWhiteWithDelay		; $4717

@substate4:
	ld a,(wPaletteThread_mode)		; $471a
	or a			; $471d
	ret nz			; $471e

	ld h,d			; $471f
	ld l,Enemy.state		; $4720
	inc (hl) ; [state] = $0b

	ld l,Enemy.collisionType		; $4723
	ld (hl),$80|ENEMYID_MERGED_TWINROVA		; $4725

	ld l,Enemy.counter1		; $4727
	ld (hl),30		; $4729
	ld l,Enemy.var30		; $472b
	ld (hl),210		; $472d

	ld l,Enemy.var39		; $472f
	xor a			; $4731
	ld (hl),a		; $4732
	ld (wDisableLinkCollisionsAndMenu),a		; $4733

	ld a,SNDCTRL_STOPSFX		; $4736
	jp playSound		; $4738


; Delay before attacking
_mergedTwinrova_stateB:
	call _ecom_decCounter1		; $473b
	ret nz			; $473e
	ld l,e			; $473f
	ld (hl),$0c ; [state]
	ret			; $4742


_mergedTwinrova_lavaRoom:
	ld a,(de)		; $4743
	sub $0c			; $4744
	rst_jumpTable			; $4746
	.dw _mergedTwinrova_lavaRoom_stateC
	.dw _mergedTwinrova_lavaRoom_stateD
	.dw _mergedTwinrova_lavaRoom_stateE


_mergedTwinrova_lavaRoom_stateC:
	call _mergedTwinrova_decVar3bIfNonzero		; $474d
	ret nz			; $4750

	ld l,Enemy.speed		; $4751
	ld (hl),SPEED_140		; $4753


_mergedTwinrova_chooseTargetPosition:
	ld l,e			; $4755
	inc (hl) ; [state]

	; Choose a target position distinct from the current position
@chooseTargetPositionIndex:
	call getRandomNumber		; $4757
	and $0e			; $475a
	ld l,Enemy.var36		; $475c
	cp (hl)			; $475e
	jr z,@chooseTargetPositionIndex	; $475f

	ld (hl),a		; $4761

	ld bc,@targetPositions		; $4762
	call addAToBc		; $4765
	ld e,Enemy.var37		; $4768
	ld a,(bc)		; $476a
	ld (de),a		; $476b
	inc e			; $476c
	inc bc			; $476d
	ld a,(bc)		; $476e
	ld (de),a		; $476f

	ld a,SND_CIRCLING		; $4770
	jp playSound		; $4772

@targetPositions: ; One of these positions in chosen randomly.
	.db $30 $40
	.db $58 $30
	.db $48 $40
	.db $30 $78
	.db $58 $78
	.db $30 $b0
	.db $58 $c0
	.db $78 $b0


; Moving toward target position
_mergedTwinrova_lavaRoom_stateD:
	ld h,d			; $4785
	ld l,Enemy.var33		; $4786
	ld a,(hl)		; $4788
	or a			; $4789
	jr z,+			; $478a
	dec (hl)		; $478c
+
	ld l,Enemy.var37		; $478d
	call _ecom_readPositionVars		; $478f
	call _mergedTwinrova_checkPositionsCloseEnough		; $4792
	jp nc,_ecom_moveTowardPosition		; $4795

	; Reached target position.

	; var33 must have reached 0 for twinrova to attack, otherwise she'll move again.
	ld l,Enemy.var33		; $4798
	ld a,(hl)		; $479a
	or a			; $479b
	ld l,Enemy.state		; $479c
	jr z,@attack			; $479e

	dec (hl) ; [state] = $0c
	ld l,Enemy.var3b		; $47a1
	ld (hl),30		; $47a3
	ret			; $47a5

@attack:
	inc (hl) ; [state] = $0e
	inc l			; $47a7
	ld (hl),$00 ; [state2]

	ld l,Enemy.var39		; $47aa
	ld (hl),$01		; $47ac

	ld l,Enemy.var32		; $47ae
	inc (hl)		; $47b0
	ld a,(hl)		; $47b1
	and $07			; $47b2
	ld (hl),a		; $47b4

	ld hl,@var03Vals		; $47b5
	rst_addAToHl			; $47b8
	ld e,Enemy.var03		; $47b9
	ld a,(hl)		; $47bb
	ld (de),a		; $47bc
	ret			; $47bd

@var03Vals:
	.db $00 $00 $01 $00 $01 $01 $00 $01


; Doing one of two attacks, depending on var03
_mergedTwinrova_lavaRoom_stateE:
	ld e,Enemy.var03		; $47c6
	ld a,(de)		; $47c8
	or a			; $47c9
	jp nz,@keeseAttack		; $47ca

	ld e,Enemy.state2		; $47cd
	ld a,(de)		; $47cf
	rst_jumpTable			; $47d0
	.dw @flameAttack_substate0
	.dw @flameAttack_substate1
	.dw @flameAttack_substate2

@flameAttack_substate0:
	ld h,d			; $47d7
	ld l,e			; $47d8
	inc (hl) ; [state2] = 1
	inc l			; $47da
	ld (hl),30 ; [counter1]

	ld a,$03		; $47dd
	call enemySetAnimation		; $47df

	call objectGetAngleTowardEnemyTarget		; $47e2
	ld b,a			; $47e5

	call getFreePartSlot		; $47e6
	ret nz			; $47e9
	ld (hl),PARTID_TWINROVA_FLAME		; $47ea
	ld l,Part.angle		; $47ec
	ld (hl),b		; $47ee
	ld bc,$1000		; $47ef
	jp objectCopyPositionWithOffset		; $47f2

@flameAttack_substate1:
	call _ecom_decCounter1		; $47f5
	jp nz,enemyAnimate		; $47f8

	ld (hl),16		; $47fb
	ld l,e			; $47fd
	inc (hl) ; [state2] = 2
	ld a,$04		; $47ff
	jp enemySetAnimation		; $4801

@flameAttack_substate2:
	call _ecom_decCounter1		; $4804
	ret nz			; $4807

@doneAttack:
	ld l,Enemy.state		; $4808
	ld (hl),$0c		; $480a
	ld l,Enemy.var3b		; $480c
	ld (hl),30		; $480e
	ld l,Enemy.var33		; $4810
	ld (hl),150		; $4812
	ld l,Enemy.var39		; $4814
	ld (hl),$00		; $4816
	ld a,$01		; $4818
	jp enemySetAnimation		; $481a


@keeseAttack:
	ld e,Enemy.state2		; $481d
	ld a,(de)		; $481f
	rst_jumpTable			; $4820
	.dw @keeseAttack_substate0
	.dw @keeseAttack_substate1
	.dw @keeseAttack_substate2

@keeseAttack_substate0:
	ld h,d			; $4827
	ld l,e			; $4828
	inc (hl) ; [state2] = 1
	inc l			; $482a
	ld (hl),$0a ; [counter1]
	inc l			; $482d
	ld (hl),$05 ; [counter2]
	ld a,$07		; $4830
	jp enemySetAnimation		; $4832

@keeseAttack_substate1:
	call _ecom_decCounter1		; $4835
	jp nz,enemyAnimate		; $4838

	ld (hl),20 ; [counter1]
	inc l			; $483d
	dec (hl) ; [counter2]
	jr z,@doneSpawningKeese	; $483f

	ld a,(hl)		; $4841
	dec a			; $4842
	ld hl,@keesePositions		; $4843
	rst_addDoubleIndex			; $4846
	ldi a,(hl)		; $4847
	ld b,a			; $4848
	ld c,(hl)		; $4849

	call getFreeEnemySlot_uncounted		; $484a
	ret nz			; $484d
	ld (hl),ENEMYID_TWINROVA_BAT		; $484e
	ld l,Enemy.relatedObj1+1		; $4850
	ld (hl),d		; $4852
	dec l			; $4853
	ld (hl),Enemy.start		; $4854

	jp objectCopyPositionWithOffset		; $4856

@doneSpawningKeese:
	dec l			; $4859
	ld (hl),180 ; [counter1]
	ld l,e			; $485c
	inc (hl) ; [state2] = 2
	ld a,$03		; $485e
	jp enemySetAnimation		; $4860

@keesePositions:
	.db $00 $20
	.db $e0 $00
	.db $00 $e0
	.db $20 $00

@keeseAttack_substate2:
	call _ecom_decCounter1		; $486b
	ret nz			; $486e
	jr @doneAttack		; $486f


_mergedTwinrova_iceRoom:
	ld a,(de)		; $4871
	sub $0c			; $4872
	rst_jumpTable			; $4874
	.dw _mergedTwinrova_iceRoom_stateC
	.dw _mergedTwinrova_iceRoom_stateD
	.dw _mergedTwinrova_iceRoom_stateE
	.dw _mergedTwinrova_iceRoom_stateF
	.dw _mergedTwinrova_iceRoom_state10


; About to start spawning ice projectiles
_mergedTwinrova_iceRoom_stateC:
	ld h,d			; $487f
	ld l,e			; $4880
	inc (hl) ; [state] = $0d
	inc l			; $4882
	ld (hl),$00 ; [state2]
	inc l			; $4885
	ld (hl),10 ; [counter1]

	ld l,Enemy.var39		; $4888
	ld (hl),$01		; $488a

	call getRandomNumber_noPreserveVars		; $488c
	and $01			; $488f
	ld e,Enemy.var35		; $4891
	ld (de),a		; $4893

	ld e,Enemy.var34		; $4894
	ld a,(de)		; $4896
	cp $02			; $4897
	ld a,$03		; $4899
	jr nc,+			; $489b
	inc a			; $489d
+
	ld e,Enemy.counter2		; $489e
	ld (de),a		; $48a0
	ld a,$05		; $48a1
	jp enemySetAnimation		; $48a3


; Spawning ice projectiles (ENEMYID_TWINROVA_ICE)
_mergedTwinrova_iceRoom_stateD:
	inc e			; $48a6
	ld a,(de) ; [state2]
	rst_jumpTable			; $48a8
	.dw @substate0
	.dw @substate1

@substate0:
	call _ecom_decCounter1		; $48ad
	jp nz,enemyAnimate		; $48b0

	ld (hl),30		; $48b3
	inc l			; $48b5
	dec (hl) ; [counter2]
	jr z,@doneSpawningProjectiles	; $48b7

	; Determine position & angle for projectile
	ld b,(hl)		; $48b9
	dec b			; $48ba
	ld l,Enemy.var34		; $48bb
	ld a,(hl)		; $48bd
	cp $02			; $48be
	ld hl,@positionData1		; $48c0
	jr nc,+			; $48c3
	ld hl,@positionData0		; $48c5
+
	ld a,b			; $48c8
	add a			; $48c9
	rst_addDoubleIndex			; $48ca
	ldi a,(hl)		; $48cb
	ld b,a			; $48cc
	ldi a,(hl)		; $48cd
	ld c,a			; $48ce
	ld e,Enemy.var35		; $48cf
	ld a,(de)		; $48d1
	or a			; $48d2
	jr z,+			; $48d3
	inc hl			; $48d5
+
	ld e,(hl)		; $48d6

	; Spawn ice projectile
	call getFreeEnemySlot_uncounted		; $48d7
	ret nz			; $48da
	ld (hl),ENEMYID_TWINROVA_ICE		; $48db
	ld l,Enemy.angle		; $48dd
	ld (hl),e		; $48df
	ld l,Enemy.relatedObj1		; $48e0
	ld (hl),Enemy.start		; $48e2
	inc l			; $48e4
	ld (hl),d		; $48e5

	jp objectCopyPositionWithOffset		; $48e6

@doneSpawningProjectiles:
	ld l,e			; $48e9
	inc (hl) ; [state2] = 1
	ld l,Enemy.counter1		; $48eb
	ld (hl),120		; $48ed
	ld l,Enemy.var39		; $48ef
	ld (hl),$00		; $48f1
	ld a,$06		; $48f3
	jp enemySetAnimation		; $48f5

@positionData0:
	.db $10 $f0 $12 $15
	.db $10 $10 $0a $0c
	.db $18 $00 $0e $12
@positionData1:
	.db $10 $e8 $16 $0d
	.db $10 $18 $0b $11

@substate1:
	call _ecom_decCounter1		; $490c
	ret nz			; $490f
	ld (hl),90		; $4910
	ld l,Enemy.state		; $4912
	inc (hl) ; [state] = $0e
	ld a,$02		; $4915
	jp enemySetAnimation		; $4917


; About to move to a position to do a snowball attack.
_mergedTwinrova_iceRoom_stateE:
	call _mergedTwinrova_decVar3bIfNonzero		; $491a
	ret nz			; $491d
	ld l,Enemy.speed		; $491e
	ld (hl),SPEED_180		; $4920
	jp _mergedTwinrova_chooseTargetPosition		; $4922


; Moving to position prior to snowball attack
_mergedTwinrova_iceRoom_stateF:
	ld h,d			; $4925
	ld l,Enemy.var37		; $4926
	call _ecom_readPositionVars		; $4928
	call _mergedTwinrova_checkPositionsCloseEnough		; $492b
	jp nc,_ecom_moveTowardPosition		; $492e

	; Reached target position. Begin charging attack.

	ld l,Enemy.state		; $4931
	inc (hl) ; [state] = $10
	inc l			; $4934
	ld (hl),$00 ; [state2]
	inc l			; $4937
	ld (hl),30 ; [counter1]

	ld l,Enemy.var39		; $493a
	ld (hl),$01		; $493c

	ld a,$08		; $493e
	call enemySetAnimation		; $4940

	call getFreePartSlot		; $4943
	ret nz			; $4946
	ld (hl),PARTID_TWINROVA_SNOWBALL		; $4947
	ld bc,$e800		; $4949
	jp objectCopyPositionWithOffset		; $494c


; Doing snowball attack?
_mergedTwinrova_iceRoom_state10:
	inc e			; $494f
	ld a,(de)		; $4950
	rst_jumpTable			; $4951
	.dw @substate0
	.dw @substate1

@substate0:
	call _ecom_decCounter1		; $4956
	jp nz,enemyAnimate		; $4959

	ld (hl),60		; $495c

	ld l,e			; $495e
	inc (hl) ; [state2] = 1

	ld a,$06		; $4960
	jp enemySetAnimation		; $4962

@substate1:
	call _ecom_decCounter1		; $4965
	ret nz			; $4968

	ld l,Enemy.state		; $4969
	ld (hl),$0e		; $496b
	ld l,Enemy.counter1		; $496d
	ld (hl),90		; $496f
	ld l,Enemy.var3b		; $4971
	ld (hl),30		; $4973
	ld l,Enemy.var39		; $4975
	ld (hl),$00		; $4977
	ld a,$02		; $4979
	jp enemySetAnimation		; $497b

;;
; @addr{497e}
_mergedTwinrova_checkTimeToSwapRoomFromTimer:
	ld a,(wFrameCounter)		; $497e
	and $03			; $4981
	ret nz			; $4983

	ld h,d			; $4984
	ld l,Enemy.var30		; $4985
	dec (hl)		; $4987
	ret nz			; $4988

	inc (hl)		; $4989
	ld e,Enemy.var39		; $498a
	ld a,(de)		; $498c
	or a			; $498d
	ret nz			; $498e

	ld (hl),210 ; [var39]
	ld l,Enemy.counter1		; $4991
	ld (hl),30		; $4993
	ld l,Enemy.state		; $4995
	ld (hl),$09		; $4997
	ret			; $4999


;;
; @param	a
; @param	bc
; @param	hFF8F
; @param[out]	cflag	c if within 2 pixels of position
; @addr{499a}
_mergedTwinrova_checkPositionsCloseEnough:
	sub c			; $499a
	add $02			; $499b
	cp $05			; $499d
	ret nc			; $499f
	ldh a,(<hFF8F)	; $49a0
	sub b			; $49a2
	add $02			; $49a3
	cp $05			; $49a5
	ret			; $49a7

;;
; Checks whether to begin changing the room. If so, it sets the state to 9 and returns
; from caller (pops return address).
; @addr{49a8}
_mergedTwinrova_checkTimeToSwapRoomFromDamage:
	ld h,d			; $49a8
	ld l,Enemy.var3a		; $49a9
	ld a,(hl)		; $49ab
	or a			; $49ac
	ret z			; $49ad

	dec (hl)		; $49ae
	jr z,++			; $49af
	pop hl			; $49b1
	ret			; $49b2
++
	ld l,Enemy.state		; $49b3
	ld (hl),$09		; $49b5

	ld e,Enemy.subid		; $49b7
	ld a,(de)		; $49b9
	ld b,a			; $49ba
	xor $01			; $49bb
	inc a			; $49bd
	ld l,Enemy.oamFlagsBackup		; $49be
	ldi (hl),a		; $49c0
	ld (hl),a		; $49c1
	ld a,b			; $49c2
	inc a			; $49c3
	jp enemySetAnimation		; $49c4


_mergedTwinrova_deathCutscene:
	ld e,Enemy.state2		; $49c7
	ld a,(de)		; $49c9
	rst_jumpTable			; $49ca
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,(wDisabledObjects)		; $49d3
	or a			; $49d6
	jr nz,++		; $49d7

	ld a,(wLinkDeathTrigger)		; $49d9
	or a			; $49dc
	ret nz			; $49dd

	inc a			; $49de
	ld (wDisableLinkCollisionsAndMenu),a		; $49df
	ld (wDisabledObjects),a		; $49e2
	call clearAllParentItems		; $49e5
++
	call _ecom_flickerVisibility		; $49e8
	call _ecom_decCounter1		; $49eb
	jr z,@doneExplosions	; $49ee

	ld a,(hl) ; [counter1]
	cp 97			; $49f1
	ret nc			; $49f3
	and $0f			; $49f4
	jp z,@createExplosion		; $49f6
	ret			; $49f9

@doneExplosions:
	ld (hl),25 ; [counter1]
	ld l,Enemy.state2		; $49fc
	inc (hl)		; $49fe

@substate1:
	call _ecom_decCounter1		; $49ff
	jp nz,_ecom_flickerVisibility		; $4a02

	ld l,e			; $4a05
	inc (hl) ; [statae2] = 2

	ld l,Enemy.oamFlagsBackup		; $4a07
	xor a			; $4a09
	ldi (hl),a		; $4a0a
	ld (hl),a		; $4a0b
	call enemySetAnimation		; $4a0c

	ld bc,TX_2f0c		; $4a0f
	jp showText		; $4a12

@substate2:
	ld a,$03		; $4a15
	ld (de),a ; [state2] = 3

	ld a,CUTSCENE_TWINROVA_SACRIFICE		; $4a18
	ld (wCutsceneTrigger),a		; $4a1a

	ld a,MUS_ROOM_OF_RITES		; $4a1d
	jp playSound		; $4a1f

@substate3:
	ret			; $4a22


@createExplosion:
	ld a,(hl)		; $4a23
	swap a			; $4a24
	dec a			; $4a26
	ld hl,@explosionPositions		; $4a27
	rst_addDoubleIndex			; $4a2a

	ld e,Enemy.yh		; $4a2b
	ld a,(de)		; $4a2d
	add (hl)		; $4a2e
	ld b,a			; $4a2f
	ld e,Enemy.xh		; $4a30
	inc hl			; $4a32
	ld a,(de)		; $4a33
	add (hl)		; $4a34
	ld c,a			; $4a35

	call getFreeInteractionSlot		; $4a36
	ret nz			; $4a39
	ld (hl),INTERACID_EXPLOSION		; $4a3a
	ld l,Interaction.yh		; $4a3c
	ld (hl),b		; $4a3e
	ld l,Interaction.xh		; $4a3f
	ld (hl),c		; $4a41
	ret			; $4a42

@explosionPositions:
	.db $f8 $f6
	.db $00 $06
	.db $02 $fe
	.db $06 $04
	.db $fc $05
	.db $fa $fc

;;
; @addr{4a4f}
_mergedTwinrova_decVar3bIfNonzero:
	ld h,d			; $4a4f
	ld l,Enemy.var3b		; $4a50
	ld a,(hl)		; $4a52
	or a			; $4a53
	ret z			; $4a54
	dec (hl)		; $4a55
	ret			; $4a56


; ==============================================================================
; ENEMYID_TWINROVA
; ==============================================================================
enemyCode03:
	jr z,_label_0f_065	; $4a65
	sub $03			; $4a67
	ret c			; $4a69
	jr nz,_label_0f_065	; $4a6a
	ld h,d			; $4a6c
	ld l,$b2		; $4a6d
	bit 6,(hl)		; $4a6f
	jr z,_label_0f_065	; $4a71
	ld l,$a9		; $4a73
	ld (hl),$7f		; $4a75
	ld l,$a4		; $4a77
	res 7,(hl)		; $4a79
	ld l,$84		; $4a7b
	ld (hl),$0d		; $4a7d
	ld a,$29		; $4a7f
	call objectGetRelatedObject1Var		; $4a81
	ld (hl),$7f		; $4a84
	ld l,$a4		; $4a86
	res 7,(hl)		; $4a88
	ld l,$84		; $4a8a
	ld (hl),$0f		; $4a8c
	ld a,$f0		; $4a8e
	call playSound		; $4a90
_label_0f_065:
	call $4e54		; $4a93
	call $4aa2		; $4a96
	ld e,$b2		; $4a99
	ld a,(de)		; $4a9b
	bit 7,a			; $4a9c
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects		; $4a9e
	ret			; $4aa1
	call $4e7b		; $4aa2
	call _ecom_getSubidAndCpStateTo08		; $4aa5
	jr nc,_label_0f_066	; $4aa8
	rst_jumpTable			; $4aaa
	.dw $4ac1
	ld ($ff00+c),a		; $4aad
	ld c,d			; $4aae
	rrca			; $4aaf
	ld c,e			; $4ab0
	rrca			; $4ab1
	ld c,e			; $4ab2
	rrca			; $4ab3
	ld c,e			; $4ab4
	rrca			; $4ab5
	ld c,e			; $4ab6
	rrca			; $4ab7
	ld c,e			; $4ab8
	rrca			; $4ab9
	ld c,e			; $4aba
_label_0f_066:
	ld a,b			; $4abb
	rst_jumpTable			; $4abc
	.dw $4b10
	.dw $4dce
	ld a,$03		; $4ac1
	ld ($cc1c),a		; $4ac3
	ld a,$01		; $4ac6
	ld ($cc17),a		; $4ac8
	ld h,d			; $4acb
	ld l,$83		; $4acc
	bit 0,(hl)		; $4ace
	ld a,$28		; $4ad0
	jp nz,seasonsFunc_0f_4e10		; $4ad2
	ld l,e			; $4ad5
	inc (hl)		; $4ad6
	xor a			; $4ad7
	ld ($d008),a		; $4ad8
	inc a			; $4adb
	ld ($cca4),a		; $4adc
	ld ($cc02),a		; $4adf
	ld b,$03		; $4ae2
	call _ecom_spawnUncountedEnemyWithSubid01		; $4ae4
	ret nz			; $4ae7
	inc l			; $4ae8
	ld e,l			; $4ae9
	ld a,(de)		; $4aea
	inc a			; $4aeb
	ld (hl),a		; $4aec
	ld l,$96		; $4aed
	ld e,l			; $4aef
	ld a,$80		; $4af0
	ld (de),a		; $4af2
	ldi (hl),a		; $4af3
	inc e			; $4af4
	ld a,h			; $4af5
	ld (de),a		; $4af6
	ld (hl),d		; $4af7
	ld a,h			; $4af8
	cp d			; $4af9
	ld a,$28		; $4afa
	jp nc,seasonsFunc_0f_4e10		; $4afc
	ld l,$80		; $4aff
	ld e,l			; $4b01
	ld a,(de)		; $4b02
	ld (hl),a		; $4b03
	ld l,$82		; $4b04
	dec (hl)		; $4b06
	ld h,d			; $4b07
	inc (hl)		; $4b08
	inc l			; $4b09
	inc (hl)		; $4b0a
	ld l,$84		; $4b0b
	dec (hl)		; $4b0d
	ret			; $4b0e
	ret			; $4b0f
	ld a,(de)		; $4b10
	sub $08			; $4b11
	rst_jumpTable			; $4b13
	ld h,$4b		; $4b14
	ld l,h			; $4b16
	ld c,e			; $4b17
	ld (bc),a		; $4b18
	ld c,h			; $4b19
	stop			; $4b1a
	ld c,h			; $4b1b
	ld b,c			; $4b1c
	ld c,h			; $4b1d
	ld d,a			; $4b1e
	ld c,h			; $4b1f
	ld l,(hl)		; $4b20
	ld c,h			; $4b21
	adc e			; $4b22
	ld c,h			; $4b23
	xor l			; $4b24
	ld c,h			; $4b25
	ld h,d			; $4b26
	ld l,e			; $4b27
	inc (hl)		; $4b28
	ld l,$b2		; $4b29
	set 3,(hl)		; $4b2b
	set 7,(hl)		; $4b2d
	ld l,$86		; $4b2f
	ld (hl),$6a		; $4b31
	ld l,$8b		; $4b33
	ld (hl),$08		; $4b35
	ld l,$82		; $4b37
	ld a,(hl)		; $4b39
	add a			; $4b3a
	ld hl,$4b64		; $4b3b
	rst_addDoubleIndex			; $4b3e
	ld e,$8d		; $4b3f
	ldi a,(hl)		; $4b41
	ld (de),a		; $4b42
	ld e,$9b		; $4b43
	ldi a,(hl)		; $4b45
	ld (de),a		; $4b46
	inc e			; $4b47
	ld (de),a		; $4b48
	ld e,$89		; $4b49
	ldi a,(hl)		; $4b4b
	ld (de),a		; $4b4c
	ld e,$b0		; $4b4d
	ld a,(hl)		; $4b4f
	ld (de),a		; $4b50
	ld e,$82		; $4b51
	ld a,(de)		; $4b53
	or a			; $4b54
	ld bc,$2f04		; $4b55
	call z,showText		; $4b58
	call getRandomNumber_noPreserveVars		; $4b5b
	ld e,$b1		; $4b5e
	ld (de),a		; $4b60
	jp $4ee0		; $4b61
	ret nz			; $4b64
	ld (bc),a		; $4b65
	ld de,$3001		; $4b66
	ld bc,$ff0f		; $4b69
	inc e			; $4b6c
	ld a,(de)		; $4b6d
	rst_jumpTable			; $4b6e
	ld a,c			; $4b6f
	ld c,e			; $4b70
	add a			; $4b71
	ld c,e			; $4b72
	or e			; $4b73
	ld c,e			; $4b74
	push bc			; $4b75
	ld c,e			; $4b76
.DB $dd				; $4b77
	ld c,e			; $4b78
	call _ecom_decCounter1		; $4b79
	jr nz,_label_0f_068	; $4b7c
	ld (hl),$08		; $4b7e
	inc l			; $4b80
	ld (hl),$12		; $4b81
	ld l,e			; $4b83
	inc (hl)		; $4b84
	jr _label_0f_069		; $4b85
	call _ecom_decCounter1		; $4b87
	jr nz,_label_0f_068	; $4b8a
	ld (hl),$08		; $4b8c
	inc l			; $4b8e
	dec (hl)		; $4b8f
	jr nz,_label_0f_067	; $4b90
	ld l,e			; $4b92
	inc (hl)		; $4b93
	inc l			; $4b94
	ld (hl),$1e		; $4b95
	call _ecom_updateAngleTowardTarget		; $4b97
	call $4f05		; $4b9a
	ld (hl),a		; $4b9d
	jp enemySetAnimation		; $4b9e
_label_0f_067:
	ld e,$89		; $4ba1
	ld l,$b0		; $4ba3
	ld a,(de)		; $4ba5
	add (hl)		; $4ba6
	and $1f			; $4ba7
	ld (de),a		; $4ba9
	call $4ee0		; $4baa
_label_0f_068:
	call objectApplySpeed		; $4bad
_label_0f_069:
	jp enemyAnimate		; $4bb0
	call _ecom_decCounter1		; $4bb3
	jr nz,_label_0f_069	; $4bb6
	ld l,e			; $4bb8
	inc (hl)		; $4bb9
	ld e,$82		; $4bba
	ld a,(de)		; $4bbc
	or a			; $4bbd
	ret nz			; $4bbe
	ld bc,$2f05		; $4bbf
	jp showText		; $4bc2
	ld bc,$0502		; $4bc5
	call objectCreateInteraction		; $4bc8
	ret nz			; $4bcb
	ld a,h			; $4bcc
	ld h,d			; $4bcd
	ld l,$99		; $4bce
	ldd (hl),a		; $4bd0
	ld (hl),$40		; $4bd1
	ld l,$85		; $4bd3
	inc (hl)		; $4bd5
	ld l,$b2		; $4bd6
	res 7,(hl)		; $4bd8
	jp objectSetInvisible		; $4bda
	ld a,$21		; $4bdd
	call objectGetRelatedObject2Var		; $4bdf
	bit 7,(hl)		; $4be2
	ret z			; $4be4
	ld h,d			; $4be5
	ld l,$b2		; $4be6
	set 7,(hl)		; $4be8
	xor a			; $4bea
	ld ($cca4),a		; $4beb
	ld ($cc02),a		; $4bee
	ld a,$18		; $4bf1
	ld ($cc04),a		; $4bf3
	call _ecom_updateAngleTowardTarget		; $4bf6
	call $4f05		; $4bf9
	add $04			; $4bfc
	ld (hl),a		; $4bfe
	jp enemySetAnimation		; $4bff
	ld h,d			; $4c02
	ld l,e			; $4c03
	inc (hl)		; $4c04
	ld a,$33		; $4c05
	ld (wActiveMusic),a		; $4c07
	call playSound		; $4c0a
	jp $4f1a		; $4c0d
	ld a,(wFrameCounter)		; $4c10
	and $7f			; $4c13
	ld a,$91		; $4c15
	call z,playSound		; $4c17
	call $4f3d		; $4c1a
	ret nc			; $4c1d
	call $4f1a		; $4c1e
	jr nz,_label_0f_070	; $4c21
	call _ecom_incState		; $4c23
	ld l,$86		; $4c26
	ld (hl),$1e		; $4c28
	ret			; $4c2a
_label_0f_070:
	call $4f6e		; $4c2b
	ret nz			; $4c2e
	ld e,$b8		; $4c2f
	ld a,(de)		; $4c31
	inc a			; $4c32
	and $07			; $4c33
	ld (de),a		; $4c35
	ld hl,$4c40		; $4c36
	call checkFlag		; $4c39
	jp nz,seasonsFunc_0f_4f5b		; $4c3c
	ret			; $4c3f
	ld (hl),l		; $4c40
	call _ecom_decCounter1		; $4c41
	jp nz,enemyAnimate		; $4c44
	ld l,e			; $4c47
	dec (hl)		; $4c48
	call getRandomNumber_noPreserveVars		; $4c49
	and $03			; $4c4c
	ld e,$b3		; $4c4e
	ld (de),a		; $4c50
	inc e			; $4c51
	xor a			; $4c52
	ld (de),a		; $4c53
	jp $4f1a		; $4c54
	ld h,d			; $4c57
	ld l,e			; $4c58
	inc (hl)		; $4c59
	ld l,$8f		; $4c5a
	ld (hl),$00		; $4c5c
	ld l,$b2		; $4c5e
	res 3,(hl)		; $4c60
	ld l,$89		; $4c62
	bit 4,(hl)		; $4c64
	ld a,$0a		; $4c66
	jr z,_label_0f_071	; $4c68
	inc a			; $4c6a
_label_0f_071:
	jp enemySetAnimation		; $4c6b
	ld e,$a1		; $4c6e
	ld a,(de)		; $4c70
	inc a			; $4c71
	jr nz,_label_0f_072	; $4c72
	ld e,$88		; $4c74
	ld a,(de)		; $4c76
	add $04			; $4c77
	call enemySetAnimation		; $4c79
	call _ecom_incState		; $4c7c
	ld l,$8f		; $4c7f
	dec (hl)		; $4c81
	ld bc,$2f09		; $4c82
	call showText		; $4c85
_label_0f_072:
	jp enemyAnimate		; $4c88
	call $4f88		; $4c8b
	jr nz,_label_0f_072	; $4c8e
	ld a,$32		; $4c90
	call objectGetRelatedObject1Var		; $4c92
	bit 4,(hl)		; $4c95
	jr nz,_label_0f_073	; $4c97
	call _ecom_updateAngleTowardTarget		; $4c99
	call $4eeb		; $4c9c
	jr _label_0f_072		; $4c9f
_label_0f_073:
	call _ecom_incState		; $4ca1
	inc l			; $4ca4
	ld (hl),$00		; $4ca5
	ld l,$b2		; $4ca7
	res 3,(hl)		; $4ca9
	jr _label_0f_072		; $4cab
	inc e			; $4cad
	ld a,(de)		; $4cae
	rst_jumpTable			; $4caf
	ret nz			; $4cb0
	ld c,h			; $4cb1
	sbc $4c			; $4cb2
	inc c			; $4cb4
	ld c,l			; $4cb5
	rra			; $4cb6
	ld c,l			; $4cb7
	ld b,e			; $4cb8
	ld c,l			; $4cb9
	ld (hl),c		; $4cba
	ld c,l			; $4cbb
	sbc h			; $4cbc
	ld c,l			; $4cbd
	xor a			; $4cbe
	ld c,l			; $4cbf
	ld h,d			; $4cc0
	ld l,e			; $4cc1
	inc (hl)		; $4cc2
	ld l,$b2		; $4cc3
	res 1,(hl)		; $4cc5
	res 0,(hl)		; $4cc7
	ld l,$88		; $4cc9
	ld (hl),$00		; $4ccb
	ld bc,$fc20		; $4ccd
	call objectSetSpeedZ		; $4cd0
	ld e,$82		; $4cd3
	ld a,(de)		; $4cd5
	or a			; $4cd6
	ret nz			; $4cd7
	ld bc,$2f0a		; $4cd8
	jp showText		; $4cdb
	ld c,$08		; $4cde
	call objectUpdateSpeedZ_paramC		; $4ce0
	ldh a,(<hCameraY)	; $4ce3
	ld b,a			; $4ce5
	ld l,$8b		; $4ce6
	ld a,(hl)		; $4ce8
	sub b			; $4ce9
	jr nc,_label_0f_074	; $4cea
	ld a,(hl)		; $4cec
_label_0f_074:
	ld b,a			; $4ced
	ld l,$8f		; $4cee
	ld a,(hl)		; $4cf0
	cp $80			; $4cf1
	jr c,_label_0f_075	; $4cf3
	add b			; $4cf5
	cp $f0			; $4cf6
	jr c,_label_0f_077	; $4cf8
_label_0f_075:
	ld l,$85		; $4cfa
	inc (hl)		; $4cfc
	ld l,$b2		; $4cfd
	set 1,(hl)		; $4cff
	ld l,$b2		; $4d01
	res 7,(hl)		; $4d03
	ld l,$86		; $4d05
	ld (hl),$3c		; $4d07
	jp objectSetInvisible		; $4d09
	ld e,$82		; $4d0c
	ld a,(de)		; $4d0e
	or a			; $4d0f
	ret nz			; $4d10
	ld a,$32		; $4d11
	call objectGetRelatedObject1Var		; $4d13
	bit 1,(hl)		; $4d16
	ret z			; $4d18
	ld l,$85		; $4d19
	inc (hl)		; $4d1b
	ld h,d			; $4d1c
	inc (hl)		; $4d1d
	ret			; $4d1e
	call _ecom_decCounter1		; $4d1f
	ret nz			; $4d22
	ld (hl),$30		; $4d23
	ld l,e			; $4d25
	inc (hl)		; $4d26
	ld l,$8f		; $4d27
	ld (hl),$a0		; $4d29
	ld l,$89		; $4d2b
	ld e,$82		; $4d2d
	ld a,(de)		; $4d2f
	or a			; $4d30
	ld (hl),$08		; $4d31
	jr z,_label_0f_076	; $4d33
	ld (hl),$18		; $4d35
_label_0f_076:
	ld l,$b2		; $4d37
	set 7,(hl)		; $4d39
	call objectSetVisiblec2		; $4d3b
	ld a,$d3		; $4d3e
	call playSound		; $4d40
	ld bc,$5878		; $4d43
	ld e,$86		; $4d46
	ld a,(de)		; $4d48
	ld e,$89		; $4d49
	call objectSetPositionInCircleArc		; $4d4b
	ld e,$89		; $4d4e
	ld a,(de)		; $4d50
	add $08			; $4d51
	and $1f			; $4d53
	call $4eee		; $4d55
	ld h,d			; $4d58
	ld l,$8f		; $4d59
	inc (hl)		; $4d5b
	ld a,(hl)		; $4d5c
	rrca			; $4d5d
	jr c,_label_0f_077	; $4d5e
	ld l,$89		; $4d60
	ld a,(hl)		; $4d62
	inc a			; $4d63
	and $1f			; $4d64
	ld (hl),a		; $4d66
	ld l,$86		; $4d67
	dec (hl)		; $4d69
	jr nz,_label_0f_077	; $4d6a
	dec l			; $4d6c
	inc (hl)		; $4d6d
_label_0f_077:
	jp enemyAnimate		; $4d6e
	ld e,$82		; $4d71
	ld a,(de)		; $4d73
	or a			; $4d74
	jp nz,enemyDelete		; $4d75
	ld a,($cc34)		; $4d78
	or a			; $4d7b
	ret nz			; $4d7c
	inc a			; $4d7d
	ld ($cca4),a		; $4d7e
	ld ($cbca),a		; $4d81
	ld h,d			; $4d84
	ld l,$85		; $4d85
	inc (hl)		; $4d87
	ld l,$9b		; $4d88
	xor a			; $4d8a
	ldi (hl),a		; $4d8b
	ld (hl),a		; $4d8c
	ld a,$0c		; $4d8d
	call enemySetAnimation		; $4d8f
	ld a,$c0		; $4d92
	call playSound		; $4d94
	ld a,$02		; $4d97
	jp fadeinFromWhiteWithDelay		; $4d99
	ld a,($c4ab)		; $4d9c
	or a			; $4d9f
	ret nz			; $4da0
	ld h,d			; $4da1
	ld l,$85		; $4da2
	inc (hl)		; $4da4
	ld l,$b2		; $4da5
	res 0,(hl)		; $4da7
	ld a,$01		; $4da9
	ld ($cc17),a		; $4dab
	ret			; $4dae
	ld h,d			; $4daf
	ld l,$80		; $4db0
	inc h			; $4db2
_label_0f_078:
	ld a,(hl)		; $4db3
	or a			; $4db4
	jr z,_label_0f_079	; $4db5
	inc h			; $4db7
	ld a,h			; $4db8
	cp $e0			; $4db9
	jr c,_label_0f_078	; $4dbb
	ret			; $4dbd
_label_0f_079:
	ld e,l			; $4dbe
	ld a,(de)		; $4dbf
	ldi (hl),a		; $4dc0
	ld (hl),$01		; $4dc1
	call objectCopyPosition		; $4dc3
	ld a,$01		; $4dc6
	ld ($cc17),a		; $4dc8
	jp enemyDelete		; $4dcb
	ld a,(de)		; $4dce
	sub $08			; $4dcf
	rst_jumpTable			; $4dd1
	ld h,$4b		; $4dd2
	ld l,h			; $4dd4
	ld c,e			; $4dd5
.DB $e4				; $4dd6
	ld c,l			; $4dd7
	ld ($fa4d),a		; $4dd8
	ld c,l			; $4ddb
	ld d,a			; $4ddc
	ld c,h			; $4ddd
	ld l,(hl)		; $4dde
	ld c,h			; $4ddf
	adc e			; $4de0
	ld c,h			; $4de1
	xor l			; $4de2
	ld c,h			; $4de3
	ld a,$0b		; $4de4
	ld (de),a		; $4de6
	jp $4f1f		; $4de7
	call $4f3d		; $4dea
	ret nc			; $4ded
	call $4f1f		; $4dee
	ret nz			; $4df1
	call _ecom_incState		; $4df2
	ld l,$86		; $4df5
	ld (hl),$1e		; $4df7
	ret			; $4df9
	call _ecom_decCounter1		; $4dfa
	jp nz,enemyAnimate		; $4dfd
	ld l,e			; $4e00
	dec (hl)		; $4e01
	call getRandomNumber_noPreserveVars		; $4e02
	and $03			; $4e05
	ld e,$b3		; $4e07
	ld (de),a		; $4e09
	inc e			; $4e0a
	xor a			; $4e0b
	ld (de),a		; $4e0c
	jp $4f1f		; $4e0d

seasonsFunc_0f_4e10:
	ld h,d			; $4e10
	ld l,$83		; $4e11
	bit 7,(hl)		; $4e13
	jp z,_ecom_setSpeedAndState8		; $4e15
	xor a			; $4e18
	ld ($cca4),a		; $4e19
	ld ($cc02),a		; $4e1c
	ld l,$8b		; $4e1f
	ld (hl),$56		; $4e21
	ld l,$8d		; $4e23
	ld (hl),$60		; $4e25
	ld e,$82		; $4e27
	ld a,(de)		; $4e29
	or a			; $4e2a
	ld a,$02		; $4e2b
	jr z,_label_0f_080	; $4e2d
	ld (hl),$90		; $4e2f
	dec a			; $4e31
_label_0f_080:
	ld l,$9b		; $4e32
	ldi (hl),a		; $4e34
	ld (hl),a		; $4e35
	ld l,$84		; $4e36
	ld (hl),$0a		; $4e38
	ld l,$88		; $4e3a
	ld (hl),$ff		; $4e3c
	ld l,$90		; $4e3e
	ld (hl),$32		; $4e40
	ld l,$b2		; $4e42
	set 3,(hl)		; $4e44
	set 7,(hl)		; $4e46
	call _ecom_updateAngleTowardTarget		; $4e48
	call $4f05		; $4e4b
	add $04			; $4e4e
	ld (hl),a		; $4e50
	jp enemySetAnimation		; $4e51
	ld h,d			; $4e54
	ld l,$b7		; $4e55
	ld a,(hl)		; $4e57
	or a			; $4e58
	jr z,_label_0f_081	; $4e59
	dec (hl)		; $4e5b
_label_0f_081:
	ld l,$b2		; $4e5c
	bit 3,(hl)		; $4e5e
	ret z			; $4e60
	ld l,$b1		; $4e61
	dec (hl)		; $4e63
	ld a,(hl)		; $4e64
	and $07			; $4e65
	ret nz			; $4e67
	ld a,(hl)		; $4e68
	and $18			; $4e69
	swap a			; $4e6b
	rlca			; $4e6d
	ld hl,$4e77		; $4e6e
	rst_addAToHl			; $4e71
	ld e,$8f		; $4e72
	ld a,(hl)		; $4e74
	ld (de),a		; $4e75
	ret			; $4e76
.DB $fd				; $4e77
.DB $fc				; $4e78
	ei			; $4e79
.DB $fc				; $4e7a
	ld h,d			; $4e7b
	ld l,$b2		; $4e7c
	bit 0,(hl)		; $4e7e
	ret z			; $4e80
	bit 2,(hl)		; $4e81
	jr nz,_label_0f_083	; $4e83
	ld l,$a4		; $4e85
	bit 7,(hl)		; $4e87
	ret z			; $4e89
	ld l,$b9		; $4e8a
	ld a,(hl)		; $4e8c
	or a			; $4e8d
	ld e,$a1		; $4e8e
	jr z,_label_0f_082	; $4e90
	dec (hl)		; $4e92
	ld a,(de)		; $4e93
	inc a			; $4e94
	ret nz			; $4e95
_label_0f_082:
	dec a			; $4e96
	ld (de),a		; $4e97
	ld e,$89		; $4e98
	ld a,(de)		; $4e9a
	call $4f05		; $4e9b
	ld (hl),a		; $4e9e
	add $04			; $4e9f
	jp enemySetAnimation		; $4ea1
_label_0f_083:
	res 2,(hl)		; $4ea4
	ld l,$88		; $4ea6
	ld (hl),$ff		; $4ea8
	ld l,$b9		; $4eaa
	ld (hl),$f0		; $4eac
	call $4ec0		; $4eae
	call objectGetAngleTowardEnemyTarget		; $4eb1
	cp $10			; $4eb4
	ld a,$00		; $4eb6
	jr c,_label_0f_084	; $4eb8
	inc a			; $4eba
_label_0f_084:
	add $08			; $4ebb
	jp enemySetAnimation		; $4ebd
	ld b,$4b		; $4ec0
	ld e,$82		; $4ec2
	ld a,(de)		; $4ec4
	or a			; $4ec5
	jr z,_label_0f_085	; $4ec6
	ld b,$4d		; $4ec8
_label_0f_085:
	jp _ecom_spawnProjectile		; $4eca
	ld l,$8b		; $4ecd
	ld e,l			; $4ecf
	ld b,(hl)		; $4ed0
	ld a,(de)		; $4ed1
	ldh (<hFF8F),a	; $4ed2
	ld l,$8d		; $4ed4
	ld e,l			; $4ed6
	ld c,(hl)		; $4ed7
	ld a,(de)		; $4ed8
	ldh (<hFF8E),a	; $4ed9
	call _ecom_moveTowardPosition		; $4edb
	jr _label_0f_086		; $4ede
	ld e,$89		; $4ee0
	ld a,(de)		; $4ee2
	call $4f05		; $4ee3
	ret z			; $4ee6
	ld (hl),a		; $4ee7
	jp enemySetAnimation		; $4ee8
_label_0f_086:
	ld e,$89		; $4eeb
	ld a,(de)		; $4eed
	call $4f05		; $4eee
	ret z			; $4ef1
	bit 7,(hl)		; $4ef2
	ret nz			; $4ef4
	ld b,a			; $4ef5
	ld e,$b7		; $4ef6
	ld a,(de)		; $4ef8
	or a			; $4ef9
	ret nz			; $4efa
	ld a,$1e		; $4efb
	ld (de),a		; $4efd
	ld a,b			; $4efe
	ld (hl),a		; $4eff
	add $04			; $4f00
	jp enemySetAnimation		; $4f02
	ld c,a			; $4f05
	add $04			; $4f06
	and $18			; $4f08
	swap a			; $4f0a
	rlca			; $4f0c
	ld b,a			; $4f0d
	ld h,d			; $4f0e
	ld l,$88		; $4f0f
	ld a,c			; $4f11
	and $07			; $4f12
	cp $04			; $4f14
	ld a,b			; $4f16
	ret z			; $4f17
	cp (hl)			; $4f18
	ret			; $4f19
	ld hl,$4fa3		; $4f1a
	jr _label_0f_087		; $4f1d
	ld hl,$5007		; $4f1f
_label_0f_087:
	ld e,$b7		; $4f22
	xor a			; $4f24
	ld (de),a		; $4f25
	ld e,$b4		; $4f26
	ld a,(de)		; $4f28
	ld b,a			; $4f29
	inc a			; $4f2a
	ld (de),a		; $4f2b
	dec e			; $4f2c
	ld a,(de)		; $4f2d
	rst_addDoubleIndex			; $4f2e
	ldi a,(hl)		; $4f2f
	ld h,(hl)		; $4f30
	ld l,a			; $4f31
	ld a,b			; $4f32
	rst_addDoubleIndex			; $4f33
	ld e,$b5		; $4f34
	ldi a,(hl)		; $4f36
	or a			; $4f37
	ret z			; $4f38
	ld (de),a		; $4f39
	inc e			; $4f3a
	ld a,(hl)		; $4f3b
	ld (de),a		; $4f3c
	ld h,d			; $4f3d
	ld l,$b5		; $4f3e
	call _ecom_readPositionVars		; $4f40
	sub c			; $4f43
	inc a			; $4f44
	cp $03			; $4f45
	jr nc,_label_0f_088	; $4f47
	ldh a,(<hFF8F)	; $4f49
	sub b			; $4f4b
	inc a			; $4f4c
	cp $03			; $4f4d
	ret c			; $4f4f
_label_0f_088:
	call _ecom_moveTowardPosition		; $4f50
	call $4eeb		; $4f53
	call enemyAnimate		; $4f56
	or d			; $4f59
	ret			; $4f5a

seasonsFunc_0f_4f5b:
	call getRandomNumber_noPreserveVars		; $4f5b
	rrca			; $4f5e
	ld h,d			; $4f5f
	ld l,$b2		; $4f60
	jr nc,_label_0f_090	; $4f62
	ld a,$32		; $4f64
_label_0f_089:
	call objectGetRelatedObject1Var		; $4f66
_label_0f_090:
	ld a,(hl)		; $4f69
	or $05			; $4f6a
	ld (hl),a		; $4f6c
_label_0f_091:
	ret			; $4f6d
	ld h,d			; $4f6e
	ld l,$b2		; $4f6f
	bit 0,(hl)		; $4f71
	jr nz,_label_0f_092	; $4f73
	ld a,$32		; $4f75
	call objectGetRelatedObject1Var		; $4f77
	bit 0,(hl)		; $4f7a
	ret z			; $4f7c
_label_0f_092:
	ld l,$88		; $4f7d
	bit 7,(hl)		; $4f7f
	ret nz			; $4f81
	ld l,$b2		; $4f82
_label_0f_093:
	res 0,(hl)		; $4f84
	or d			; $4f86
	ret			; $4f87
	ld h,d			; $4f88
_label_0f_094:
	ld l,$8f		; $4f89
	ld a,(hl)		; $4f8b
	cp $fe			; $4f8c
	jr c,_label_0f_095	; $4f8e
	dec (hl)		; $4f90
	ret			; $4f91
_label_0f_095:
	ld l,$b2		; $4f92
_label_0f_096:
	ld a,(hl)		; $4f94
	or $18			; $4f95
	ld (hl),a		; $4f97
	xor a			; $4f98
	ret			; $4f99
	ld a,$05		; $4f9a
	call objectGetRelatedObject1Var		; $4f9c
	inc (hl)		; $4f9f
	ld h,d			; $4fa0
	inc (hl)		; $4fa1
	ret			; $4fa2
	xor e			; $4fa3
	ld c,a			; $4fa4
	jp nz,$dd4f		; $4fa5
	ld c,a			; $4fa8
	xor $4f			; $4fa9
_label_0f_097:
	ld d,b			; $4fab
	ld e,b			; $4fac
	sub b			; $4fad
	and b			; $4fae
	sub b			; $4faf
	cp b			; $4fb0
	ld e,b			; $4fb1
	ret nc			; $4fb2
	jr nz,_label_0f_091	; $4fb3
	jr nz,-$60		; $4fb5
	sub b			; $4fb7
	ld b,b			; $4fb8
	sub b			; $4fb9
	jr z,_label_0f_107	; $4fba
	jr _label_0f_100		; $4fbc
	jr z,_label_0f_101	; $4fbe
	ld b,b			; $4fc0
	nop			; $4fc1
	ld d,b			; $4fc2
	ld e,b			; $4fc3
	ld (hl),b		; $4fc4
	ret nz			; $4fc5
	add b			; $4fc6
	ret nz			; $4fc7
	sub b			; $4fc8
	sub b			; $4fc9
	sub b			; $4fca
	ld h,b			; $4fcb
_label_0f_098:
	add b			; $4fcc
	jr nc,_label_0f_111	; $4fcd
	jr nc,_label_0f_106	; $4fcf
	ret nz			; $4fd1
	jr nc,_label_0f_096	; $4fd2
	jr nz,_label_0f_089	; $4fd4
	jr nz,$60		; $4fd6
	jr nc,$30		; $4fd8
	ld b,b			; $4fda
	jr nc,_label_0f_099	; $4fdb
_label_0f_099:
	ld d,b			; $4fdd
_label_0f_100:
	ld e,b			; $4fde
	add b			; $4fdf
_label_0f_101:
	add b			; $4fe0
	add b			; $4fe1
	and b			; $4fe2
	ld l,b			; $4fe3
	ret nz			; $4fe4
	jr c,-$40		; $4fe5
	jr nz,_label_0f_094	; $4fe7
	jr nz,$50		; $4fe9
_label_0f_102:
	jr nc,_label_0f_109	; $4feb
	nop			; $4fed
	ld d,b			; $4fee
_label_0f_103:
	ld e,b			; $4fef
	ld h,b			; $4ff0
	ld (hl),b		; $4ff1
	add b			; $4ff2
	ld (hl),b		; $4ff3
	sub b			; $4ff4
	ld b,b			; $4ff5
	ld h,b			; $4ff6
	jr z,$50		; $4ff7
	ld e,b			; $4ff9
	ld d,b			; $4ffa
	sbc b			; $4ffb
	ld h,b			; $4ffc
	ret z			; $4ffd
_label_0f_104:
	adc b			; $4ffe
	cp b			; $4fff
	adc b			; $5000
_label_0f_105:
	and b			; $5001
	jr nz,_label_0f_093	; $5002
	jr nz,_label_0f_113	; $5004
	nop			; $5006
	rrca			; $5007
	ld d,b			; $5008
	ld h,$50		; $5009
	ld b,c			; $500b
	ld d,b			; $500c
	ld d,d			; $500d
	ld d,b			; $500e
	ld d,b			; $500f
	sbc b			; $5010
_label_0f_106:
	sub b			; $5011
	ld d,b			; $5012
	sub b			; $5013
_label_0f_107:
	jr c,$58		; $5014
	jr nz,$20		; $5016
	jr c,_label_0f_110	; $5018
_label_0f_108:
	ld d,b			; $501a
	sub b			; $501b
	cp b			; $501c
	sub b			; $501d
	ret z			; $501e
	ld e,b			; $501f
	ret c			; $5020
	jr nz,_label_0f_102	; $5021
	jr nz,_label_0f_099	; $5023
	nop			; $5025
	ld d,b			; $5026
	sbc b			; $5027
	ld (hl),b		; $5028
	jr nc,_label_0f_097	; $5029
	jr nc,-$70		; $502b
_label_0f_109:
	ld h,b			; $502d
	sub b			; $502e
	sub b			; $502f
	add b			; $5030
	ret nz			; $5031
	ld (hl),b		; $5032
	ret nz			; $5033
	ld b,b			; $5034
	jr nc,$30		; $5035
	jr nc,_label_0f_112	; $5037
	ld h,b			; $5039
_label_0f_110:
	jr nz,_label_0f_098	; $503a
	jr nc,_label_0f_104	; $503c
	ld b,b			; $503e
_label_0f_111:
	ret nz			; $503f
	nop			; $5040
	ld d,b			; $5041
	sbc b			; $5042
	add b			; $5043
	ld (hl),b		; $5044
	add b			; $5045
	ld d,b			; $5046
	ld l,b			; $5047
	jr nc,_label_0f_114	; $5048
	jr nc,$20		; $504a
	ld d,b			; $504c
	jr nz,_label_0f_103	; $504d
	jr nc,_label_0f_105	; $504f
	nop			; $5051
	ld d,b			; $5052
	sbc b			; $5053
	ld d,b			; $5054
	ld e,b			; $5055
	ld a,b			; $5056
	ld c,b			; $5057
	sub b			; $5058
_label_0f_112:
	ld a,b			; $5059
	ld a,b			; $505a
	xor b			; $505b
	ld d,b			; $505c
	jr nz,_label_0f_115	; $505d
	jr nz,$28		; $505f
	ld b,b			; $5061
	ld h,b			; $5062
	and b			; $5063
	ld d,b			; $5064
	ret nc			; $5065
	jr nc,-$30		; $5066
	jr z,_label_0f_108	; $5068
	nop			; $506a

; ==============================================================================
; ENEMYID_GANON
; ==============================================================================
enemyCode04:
	jr z,_label_0f_116	; $506b
	sub $03			; $506d
	ret c			; $506f
	jr nz,_label_0f_116	; $5070
	call checkLinkVulnerable		; $5072
	ret nc			; $5075
_label_0f_113:
	ld h,d			; $5076
	ld l,$a9		; $5077
	ld (hl),$40		; $5079
	ld l,$84		; $507b
	ld (hl),$0e		; $507d
	inc l			; $507f
	ld (hl),$00		; $5080
_label_0f_114:
	inc l			; $5082
	ld (hl),$78		; $5083
	ld a,$01		; $5085
	ld ($cbca),a		; $5087
	ld a,$67		; $508a
	call playSound		; $508c
_label_0f_115:
	ld a,$b4		; $508f
	call $56ec		; $5091
	ld a,$0e		; $5094
	call enemySetAnimation		; $5096
	call getThisRoomFlags		; $5099
	set 7,(hl)		; $509c
	ld l,$9a		; $509e
	set 7,(hl)		; $50a0
	ld l,$9e		; $50a2
	set 7,(hl)		; $50a4
	ld a,$f0		; $50a6
	call playSound		; $50a8
	ld bc,$2f0e		; $50ab
	jp showText		; $50ae
_label_0f_116:
	ld e,$84		; $50b1
	ld a,(de)		; $50b3
	rst_jumpTable			; $50b4
.DB $d3				; $50b5
	ld d,b			; $50b6
	ld h,b			; $50b7
	ld d,c			; $50b8
	ld (hl),h		; $50b9
	ld d,c			; $50ba
	adc l			; $50bb
	ld d,c			; $50bc
	xor a			; $50bd
	ld d,c			; $50be
	rst_addAToHl			; $50bf
	ld d,c			; $50c0
	or $51			; $50c1
	add hl,de		; $50c3
	ld d,d			; $50c4
	inc h			; $50c5
	ld d,d			; $50c6
	push bc			; $50c7
	ld d,d			; $50c8
	ld h,d			; $50c9
	ld d,e			; $50ca
	daa			; $50cb
	ld d,h			; $50cc
	add hl,hl		; $50cd
	ld d,l			; $50ce
	ld e,e			; $50cf
	ld d,(hl)		; $50d0
	ld a,c			; $50d1
	ld d,(hl)		; $50d2
	ld h,d			; $50d3
	ld l,e			; $50d4
	inc (hl)		; $50d5
	ld l,$9d		; $50d6
	ld (hl),$00		; $50d8
	ld l,$8b		; $50da
	ld (hl),$48		; $50dc
	ld l,$8d		; $50de
	ld (hl),$78		; $50e0
	ld l,$8f		; $50e2
	dec (hl)		; $50e4
	ld hl,$d00b		; $50e5
	ld (hl),$88		; $50e8
	ld l,$0d		; $50ea
	ld (hl),$78		; $50ec
	ld l,$08		; $50ee
	ld (hl),$00		; $50f0
	ld l,$00		; $50f2
	ld (hl),$03		; $50f4
	ld hl,$cc07		; $50f6
	ld a,$01		; $50f9
	ld (hl),$16		; $50fb
	inc l			; $50fd
	ldi (hl),a		; $50fe
	ld (hl),$18		; $50ff
	inc l			; $5101
	ldi (hl),a		; $5102
	ld (hl),$19		; $5103
	inc l			; $5105
	ldi (hl),a		; $5106
	ld (hl),$1a		; $5107
	inc l			; $5109
	ldi (hl),a		; $510a
	ld (hl),$1b		; $510b
	inc l			; $510d
	ldi (hl),a		; $510e
	xor a			; $510f
	ldi (hl),a		; $5110
	ldi (hl),a		; $5111
	ldi (hl),a		; $5112
	ldi (hl),a		; $5113
	ldi (hl),a		; $5114
	ldi (hl),a		; $5115
	ld bc,$0012		; $5116
	call _enemyBoss_spawnShadow		; $5119
	ld e,$98		; $511c
	ld a,$c0		; $511e
	ld (de),a		; $5120
	inc e			; $5121
	ld a,h			; $5122
	ld (de),a		; $5123
	call disableLcd		; $5124
	ld a,$9e		; $5127
	ld ($cc4c),a		; $5129
	ld a,$03		; $512c
	ld ($ccc4),a		; $512e
	call loadScreenMusicAndSetRoomPack		; $5131
	call loadTilesetData		; $5134
	call loadTilesetGraphics		; $5137
	call func_131f		; $513a
	call resetCamera		; $513d
	call loadCommonGraphics		; $5140
	ld a,$8b		; $5143
	call loadPaletteHeader		; $5145
	ld a,$b1		; $5148
	ld ($cbe3),a		; $514a
	ld a,$b0		; $514d
	call loadGfxHeader		; $514f
	ld a,$02		; $5152
	call loadGfxRegisterStateIndex		; $5154
	ldh a,(<hActiveObject)	; $5157
	ld d,a			; $5159
	call objectSetVisible83		; $515a
	jp fadeinFromWhite		; $515d
	call getFreeEnemySlot_uncounted		; $5160
	ret nz			; $5163
	ld (hl),$60		; $5164
	ld l,$96		; $5166
	ld (hl),$80		; $5168
	inc l			; $516a
	ld (hl),d		; $516b
	call _ecom_incState		; $516c
	ld l,$87		; $516f
	ld (hl),$3c		; $5171
	ret			; $5173
	ld e,$86		; $5174
	ld a,(de)		; $5176
	or a			; $5177
	ret z			; $5178
	call _ecom_decCounter2		; $5179
	jp nz,_ecom_flickerVisibility		; $517c
	dec l			; $517f
	ld (hl),$c1		; $5180
	ld l,$84		; $5182
	inc (hl)		; $5184
	ld a,$0d		; $5185
	call enemySetAnimation		; $5187
	jp objectSetVisible83		; $518a
	call _ecom_decCounter1		; $518d
	jr z,_label_0f_117	; $5190
	ld a,(hl)		; $5192
	and $3f			; $5193
	ld a,$b8		; $5195
	call z,playSound		; $5197
	jp enemyAnimate		; $519a
_label_0f_117:
	ld l,e			; $519d
	inc (hl)		; $519e
	ld l,$8f		; $519f
	ld (hl),$00		; $51a1
	ld a,$02		; $51a3
	call objectGetRelatedObject2Var		; $51a5
	ld (hl),$02		; $51a8
	ld a,$01		; $51aa
	jp enemySetAnimation		; $51ac
	ld e,$a1		; $51af
	ld a,(de)		; $51b1
	inc a			; $51b2
	jp nz,enemyAnimate		; $51b3
	call _ecom_incState		; $51b6
	ld l,$86		; $51b9
	ld (hl),$0f		; $51bb
	ld a,$b1		; $51bd
	call loadGfxHeader		; $51bf
	ld a,UNCMP_GFXH_32		; $51c2
	call loadUncompressedGfxHeader		; $51c4
	ld hl,$cc09		; $51c7
	ld (hl),$17		; $51ca
	inc l			; $51cc
	ld (hl),$01		; $51cd
	ldh a,(<hActiveObject)	; $51cf
	ld d,a			; $51d1
	ld a,$02		; $51d2
	jp enemySetAnimation		; $51d4
	call _ecom_decCounter1		; $51d7
	ret nz			; $51da
	ld a,$78		; $51db
	ld (hl),a		; $51dd
	ld ($cd18),a		; $51de
	ld l,e			; $51e1
	inc (hl)		; $51e2
	ld a,$67		; $51e3
	call playSound		; $51e5
	ld a,$03		; $51e8
	call enemySetAnimation		; $51ea
	call showStatusBar		; $51ed
	ldh a,(<hActiveObject)	; $51f0
	ld d,a			; $51f2
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $51f3
	call _ecom_decCounter1		; $51f6
	jp nz,enemyAnimate		; $51f9
	ld (hl),$1e		; $51fc
	ld l,e			; $51fe
	inc (hl)		; $51ff
	ld hl,$cc0d		; $5200
	xor a			; $5203
	ldi (hl),a		; $5204
	ldi (hl),a		; $5205
	ldi (hl),a		; $5206
	ldi (hl),a		; $5207
	ld ($cbca),a		; $5208
	ld ($cca4),a		; $520b
	ld bc,$2f0d		; $520e
	call showText		; $5211
	ld a,$02		; $5214
	jp enemySetAnimation		; $5216
	ld a,$34		; $5219
	ld (wActiveMusic),a		; $521b
	call playSound		; $521e
	jp $574e		; $5221
	inc e			; $5224
	ld a,(de)		; $5225
	rst_jumpTable			; $5226
	scf			; $5227
	ld d,d			; $5228
	ld a,$52		; $5229
	ld c,h			; $522b
	ld d,d			; $522c
	ld d,l			; $522d
	ld d,d			; $522e
	ld l,h			; $522f
	ld d,d			; $5230
	ld a,c			; $5231
	ld d,d			; $5232
	adc (hl)		; $5233
	ld d,d			; $5234
	cp (hl)			; $5235
	ld d,d			; $5236
	call $571b		; $5237
	ld l,$85		; $523a
	inc (hl)		; $523c
	ret			; $523d
	call _ecom_decCounter1		; $523e
	jp nz,seasonsFunc_0f_5704		; $5241
	ld l,e			; $5244
	inc (hl)		; $5245
	call $5795		; $5246
	jp objectSetInvisible		; $5249
	call _ecom_decCounter1		; $524c
	ret nz			; $524f
	ld l,e			; $5250
	inc (hl)		; $5251
	jp $571b		; $5252
	call _ecom_decCounter1		; $5255
	jp nz,seasonsFunc_0f_5730		; $5258
	ld (hl),$08		; $525b
	ld l,e			; $525d
	inc (hl)		; $525e
	ld l,$b0		; $525f
	ld a,(hl)		; $5261
	ld l,$8d		; $5262
	ld (hl),a		; $5264
	ld l,$a4		; $5265
	set 7,(hl)		; $5267
	jp objectSetVisible83		; $5269
	call _ecom_decCounter1		; $526c
	ret nz			; $526f
	ld (hl),$02		; $5270
	ld l,e			; $5272
	inc (hl)		; $5273
	ld a,$b3		; $5274
	jp $56ec		; $5276
	call _ecom_decCounter1		; $5279
	ret nz			; $527c
	ld (hl),$2d		; $527d
	ld l,e			; $527f
	inc (hl)		; $5280
	ld a,$05		; $5281
	call enemySetAnimation		; $5283
	call _ecom_updateAngleTowardTarget		; $5286
	ld bc,$003c		; $5289
	jr _label_0f_119		; $528c
	call _ecom_decCounter1		; $528e
	jr nz,_label_0f_118	; $5291
	ld (hl),$3c		; $5293
	ld l,e			; $5295
	inc (hl)		; $5296
	ld a,$02		; $5297
	jp enemySetAnimation		; $5299
_label_0f_118:
	ld a,(hl)		; $529c
	cp $19			; $529d
	ret nz			; $529f
	ld bc,$0264		; $52a0
	call $52a9		; $52a3
	ld bc,$fe64		; $52a6
_label_0f_119:
	ld e,$52		; $52a9
	call $57d2		; $52ab
	ret nz			; $52ae
	ld l,$c9		; $52af
	ld e,$89		; $52b1
	ld a,(de)		; $52b3
	add b			; $52b4
	and $1f			; $52b5
	ld (hl),a		; $52b7
	ld l,$d0		; $52b8
	ld (hl),c		; $52ba
	jp objectCopyPosition		; $52bb
	call _ecom_decCounter1		; $52be
	ret nz			; $52c1
	jp $5736		; $52c2
	inc e			; $52c5
	ld a,(de)		; $52c6
	rst_jumpTable			; $52c7
	ret c			; $52c8
	ld d,d			; $52c9
	rst_addDoubleIndex			; $52ca
	ld d,d			; $52cb
	ld c,h			; $52cc
	ld d,d			; $52cd
.DB $f4				; $52ce
	ld d,d			; $52cf
	dec b			; $52d0
	ld d,e			; $52d1
	inc a			; $52d2
	ld d,e			; $52d3
	ld c,(hl)		; $52d4
	ld d,e			; $52d5
	ld e,e			; $52d6
	ld d,e			; $52d7
	call $571b		; $52d8
	ld l,$85		; $52db
	inc (hl)		; $52dd
	ret			; $52de
	call _ecom_decCounter1		; $52df
	jp nz,seasonsFunc_0f_5704		; $52e2
	ld (hl),$78		; $52e5
	ld l,e			; $52e7
	inc (hl)		; $52e8
	ld l,$8b		; $52e9
	ld (hl),$58		; $52eb
	ld l,$8d		; $52ed
	ld (hl),$78		; $52ef
	jp objectSetInvisible		; $52f1
	call _ecom_decCounter1		; $52f4
	jp nz,seasonsFunc_0f_5730		; $52f7
	ld (hl),$08		; $52fa
	ld l,e			; $52fc
	inc (hl)		; $52fd
	ld l,$a4		; $52fe
	set 7,(hl)		; $5300
	jp objectSetVisible83		; $5302
	call _ecom_decCounter1		; $5305
	ret nz			; $5308
	ld (hl),$28		; $5309
	ld l,e			; $530b
	inc (hl)		; $530c
	ld a,$b6		; $530d
	call $56ec		; $530f
	ld a,$09		; $5312
	call enemySetAnimation		; $5314
	ld b,$1c		; $5317
	call $5328		; $5319
	ld b,$14		; $531c
	call $5328		; $531e
	ld b,$0c		; $5321
	call $5328		; $5323
	ld b,$04		; $5326
	ld e,$52		; $5328
	call $57d2		; $532a
	ld l,$c2		; $532d
	inc (hl)		; $532f
	ld l,$c9		; $5330
	ld (hl),b		; $5332
	ld l,$d7		; $5333
	ld (hl),d		; $5335
	dec l			; $5336
	ld (hl),$80		; $5337
	jp objectCopyPosition		; $5339
	call _ecom_decCounter1		; $533c
	ret nz			; $533f
	ld (hl),$28		; $5340
	ld l,e			; $5342
	inc (hl)		; $5343
	ld a,$b2		; $5344
	call $56ec		; $5346
	ld a,$07		; $5349
	jp enemySetAnimation		; $534b
	call _ecom_decCounter1		; $534e
	ret nz			; $5351
	ld (hl),$50		; $5352
	ld l,e			; $5354
	inc (hl)		; $5355
	ld a,$02		; $5356
	jp enemySetAnimation		; $5358
	call _ecom_decCounter1		; $535b
	ret nz			; $535e
	jp $5736		; $535f
	inc e			; $5362
	ld a,(de)		; $5363
	rst_jumpTable			; $5364
	ret c			; $5365
	ld d,d			; $5366
	ld (hl),l		; $5367
	ld d,e			; $5368
	add d			; $5369
	ld d,e			; $536a
	or l			; $536b
	ld d,e			; $536c
	jp nc,$e753		; $536d
	ld d,e			; $5370
.DB $fd				; $5371
	ld d,e			; $5372
	dec de			; $5373
	ld d,h			; $5374
	call _ecom_decCounter1		; $5375
	jp nz,seasonsFunc_0f_5704		; $5378
	ld (hl),$78		; $537b
	ld l,e			; $537d
	inc (hl)		; $537e
	jp objectSetInvisible		; $537f
	call _ecom_decCounter1		; $5382
	ret nz			; $5385
	ld l,e			; $5386
	inc (hl)		; $5387
	ldh a,(<hEnemyTargetX)	; $5388
	cp $78			; $538a
	ld bc,$0328		; $538c
	jr c,_label_0f_120	; $538f
	ld bc,$00d8		; $5391
_label_0f_120:
	ld l,$b2		; $5394
	ld (hl),b		; $5396
	add c			; $5397
	ld l,$8d		; $5398
	ldd (hl),a		; $539a
	ldh a,(<hEnemyTargetY)	; $539b
	cp $30			; $539d
	jr c,_label_0f_121	; $539f
	sub $18			; $53a1
_label_0f_121:
	dec l			; $53a3
	ld (hl),a		; $53a4
	ld a,$b2		; $53a5
	call $56ec		; $53a7
	ld e,$b2		; $53aa
	ld a,(de)		; $53ac
	add $07			; $53ad
	call enemySetAnimation		; $53af
	jp $571b		; $53b2
	call _ecom_decCounter1		; $53b5
	jp nz,seasonsFunc_0f_5730		; $53b8
	ld (hl),$02		; $53bb
	ld l,e			; $53bd
	inc (hl)		; $53be
	ld l,$a4		; $53bf
	set 7,(hl)		; $53c1
	ld l,$90		; $53c3
	ld (hl),$78		; $53c5
	call _ecom_updateAngleTowardTarget		; $53c7
	ld e,$50		; $53ca
	call $57d2		; $53cc
	jp objectSetVisible83		; $53cf
	call _ecom_decCounter1		; $53d2
	ret nz			; $53d5
	ld (hl),$04		; $53d6
	ld l,e			; $53d8
	inc (hl)		; $53d9
	ld a,$b7		; $53da
	call $56ec		; $53dc
	ld e,$b2		; $53df
	ld a,(de)		; $53e1
	add $08			; $53e2
	call enemySetAnimation		; $53e4
	call _ecom_decCounter1		; $53e7
	jr nz,_label_0f_122	; $53ea
	ld (hl),$10		; $53ec
	ld l,e			; $53ee
	inc (hl)		; $53ef
	ld a,$b6		; $53f0
	call $56ec		; $53f2
	ld e,$b2		; $53f5
	ld a,(de)		; $53f7
	add $09			; $53f8
	jp enemySetAnimation		; $53fa
	call _ecom_decCounter1		; $53fd
	jr nz,_label_0f_122	; $5400
	ld l,e			; $5402
	inc (hl)		; $5403
	inc l			; $5404
	ld (hl),$1e		; $5405
	ret			; $5407
_label_0f_122:
	ld e,$8b		; $5408
	ld a,(de)		; $540a
	sub $18			; $540b
	cp $80			; $540d
	ret nc			; $540f
	ld e,$8d		; $5410
	ld a,(de)		; $5412
	sub $18			; $5413
	cp $c0			; $5415
	ret nc			; $5417
	jp objectApplySpeed		; $5418
	call _ecom_decCounter1		; $541b
	ret nz			; $541e
	ld a,$02		; $541f
	call enemySetAnimation		; $5421
	jp $5736		; $5424
	inc e			; $5427
	ld a,(de)		; $5428
	rst_jumpTable			; $5429
	ret c			; $542a
	ld d,d			; $542b
	ld b,b			; $542c
	ld d,h			; $542d
	ld c,l			; $542e
	ld d,h			; $542f
	ld l,b			; $5430
	ld d,h			; $5431
	add l			; $5432
	ld d,h			; $5433
	sbc h			; $5434
	ld d,h			; $5435
	call nz,$e954		; $5436
	ld d,h			; $5439
	nop			; $543a
	ld d,l			; $543b
	dec d			; $543c
	ld d,l			; $543d
	ldi (hl),a		; $543e
	ld d,l			; $543f
	call _ecom_decCounter1		; $5440
	jp nz,seasonsFunc_0f_5704		; $5443
	ld (hl),$b4		; $5446
	ld l,e			; $5448
	inc (hl)		; $5449
	jp objectSetInvisible		; $544a
	call _ecom_decCounter1		; $544d
	ret nz			; $5450
	ld l,e			; $5451
	inc (hl)		; $5452
	ld l,$8b		; $5453
	ld (hl),$28		; $5455
	ld l,$8d		; $5457
	ld (hl),$78		; $5459
	ld a,$b2		; $545b
	call $56ec		; $545d
	ld a,$04		; $5460
	call enemySetAnimation		; $5462
	jp $571b		; $5465
	call _ecom_decCounter1		; $5468
	jp nz,seasonsFunc_0f_5730		; $546b
	ld (hl),$40		; $546e
	ld l,e			; $5470
	inc (hl)		; $5471
	ld l,$a4		; $5472
	set 7,(hl)		; $5474
	call objectSetVisible83		; $5476
	ld e,$51		; $5479
	call $57d2		; $547b
	ret nz			; $547e
	ld bc,$f810		; $547f
	jp objectCopyPositionWithOffset		; $5482
	call _ecom_decCounter1		; $5485
	ret nz			; $5488
	ld l,e			; $5489
	inc (hl)		; $548a
	ld l,$94		; $548b
	ld a,$40		; $548d
	ldi (hl),a		; $548f
	ld (hl),$fe		; $5490
	ld a,$b3		; $5492
	call $56ec		; $5494
	ld a,$05		; $5497
	jp enemySetAnimation		; $5499
	ld c,$20		; $549c
	call objectUpdateSpeedZ_paramC		; $549e
	jr z,_label_0f_123	; $54a1
	ldd a,(hl)		; $54a3
	or a			; $54a4
	ret nz			; $54a5
	ld a,(hl)		; $54a6
	cp $c0			; $54a7
	ret nz			; $54a9
	ld a,$b5		; $54aa
	call $56ec		; $54ac
	ld a,$06		; $54af
	jp enemySetAnimation		; $54b1
_label_0f_123:
	ld l,$86		; $54b4
	ld a,$78		; $54b6
	ld (hl),a		; $54b8
	ld ($cd18),a		; $54b9
	ld l,$85		; $54bc
	inc (hl)		; $54be
	ld a,$6f		; $54bf
	jp playSound		; $54c1
	call _ecom_decCounter1		; $54c4
	jr z,_label_0f_124	; $54c7
	ld a,(hl)		; $54c9
	cp $69			; $54ca
	ret c			; $54cc
	ld a,($d00f)		; $54cd
	rlca			; $54d0
	ret c			; $54d1
	ld hl,$cc6a		; $54d2
	ld a,$14		; $54d5
	ldi (hl),a		; $54d7
	ld (hl),$00		; $54d8
	ret			; $54da
_label_0f_124:
	ld (hl),$04		; $54db
	ld l,e			; $54dd
	inc (hl)		; $54de
	ld a,$b2		; $54df
	call $56ec		; $54e1
	ld a,$04		; $54e4
	jp enemySetAnimation		; $54e6
	call _ecom_decCounter1		; $54e9
	ret nz			; $54ec
	ld (hl),$18		; $54ed
	ld l,e			; $54ef
	inc (hl)		; $54f0
	ld e,$51		; $54f1
	call $57d2		; $54f3
	ret nz			; $54f6
	ld l,$c2		; $54f7
	inc (hl)		; $54f9
	ld bc,$f810		; $54fa
	jp objectCopyPositionWithOffset		; $54fd
	call _ecom_decCounter1		; $5500
	ret nz			; $5503
	ld (hl),$3c		; $5504
	ld l,e			; $5506
	inc (hl)		; $5507
	call objectCreatePuff		; $5508
	ld a,$b3		; $550b
	call $56ec		; $550d
	ld a,$05		; $5510
	jp enemySetAnimation		; $5512
	call _ecom_decCounter1		; $5515
	ret nz			; $5518
	ld (hl),$3c		; $5519
	ld l,e			; $551b
	inc (hl)		; $551c
	ld a,$02		; $551d
	jp enemySetAnimation		; $551f
	call _ecom_decCounter1		; $5522
	ret nz			; $5525
	jp $5736		; $5526
	inc e			; $5529
	ld a,(de)		; $552a
	rst_jumpTable			; $552b
	ret c			; $552c
	ld d,d			; $552d
	ld b,d			; $552e
	ld d,l			; $552f
	ld c,h			; $5530
	ld d,d			; $5531
	ld d,a			; $5532
	ld d,l			; $5533
	ld l,l			; $5534
	ld d,l			; $5535
	sub a			; $5536
	ld d,l			; $5537
	and a			; $5538
	ld d,l			; $5539
	call $0555		; $553a
	ld d,(hl)		; $553d
	dec sp			; $553e
	ld d,(hl)		; $553f
	ld d,b			; $5540
	ld d,(hl)		; $5541
	call _ecom_decCounter1		; $5542
	jp nz,seasonsFunc_0f_5704		; $5545
	ld (hl),$5a		; $5548
	ld l,e			; $554a
	inc (hl)		; $554b
	ld l,$8b		; $554c
	ld (hl),$58		; $554e
	ld l,$8d		; $5550
	ld (hl),$78		; $5552
	jp objectSetInvisible		; $5554
	call _ecom_decCounter1		; $5557
	jp nz,seasonsFunc_0f_5730		; $555a
	ld (hl),$5a		; $555d
	ld l,e			; $555f
	inc (hl)		; $5560
	ld l,$a4		; $5561
	set 7,(hl)		; $5563
	call objectSetVisible83		; $5565
	ld a,$b4		; $5568
	jp playSound		; $556a
	call _ecom_decCounter1		; $556d
	jr z,_label_0f_125	; $5570
	ld a,(hl)		; $5572
	cp $3c			; $5573
	ret nc			; $5575
	and $03			; $5576
	ret nz			; $5578
	ld l,$9b		; $5579
	ld a,(hl)		; $557b
	xor $05			; $557c
	ldi (hl),a		; $557e
	ld (hl),a		; $557f
	ret			; $5580
_label_0f_125:
	ld l,$a9		; $5581
	ld a,(hl)		; $5583
	or a			; $5584
	ret z			; $5585
	ld l,e			; $5586
	inc (hl)		; $5587
	ld l,$a4		; $5588
	res 7,(hl)		; $558a
	ld l,$9b		; $558c
	ld a,$01		; $558e
	ldi (hl),a		; $5590
	ld (hl),a		; $5591
	ld a,$02		; $5592
	jp fadeoutToBlackWithDelay		; $5594
	ld a,($c4ab)		; $5597
	or a			; $559a
	ret nz			; $559b
	ld a,$06		; $559c
	ld (de),a		; $559e
	ld a,$04		; $559f
	call $582a		; $55a1
	jp $57df		; $55a4
	ld h,d			; $55a7
	ld l,e			; $55a8
	inc (hl)		; $55a9
	inc l			; $55aa
	ld (hl),$3c		; $55ab
	ld l,$a4		; $55ad
	set 7,(hl)		; $55af
	ld l,$90		; $55b1
	ld (hl),$14		; $55b3
	call getRandomNumber_noPreserveVars		; $55b5
	and $07			; $55b8
	ld hl,$55c5		; $55ba
	rst_addAToHl			; $55bd
	ld e,$87		; $55be
	ld a,(hl)		; $55c0
	ld (de),a		; $55c1
	jp fadeinFromBlack		; $55c2
	ldd (hl),a		; $55c5
	ld d,b			; $55c6
	ld d,b			; $55c7
	ld e,d			; $55c8
	ld e,d			; $55c9
	ld e,d			; $55ca
	ld e,d			; $55cb
	sub (hl)		; $55cc
	ld a,$02		; $55cd
	ld ($cbc3),a		; $55cf
	ld a,(wFrameCounter)		; $55d2
	and $03			; $55d5
	jr nz,_label_0f_126	; $55d7
	call _ecom_decCounter2		; $55d9
	jr nz,_label_0f_126	; $55dc
	ld l,$85		; $55de
	inc (hl)		; $55e0
	inc (hl)		; $55e1
	ld l,$a4		; $55e2
	res 7,(hl)		; $55e4
	jp fastFadeoutToWhite		; $55e6
_label_0f_126:
	call _ecom_decCounter1		; $55e9
	jr nz,_label_0f_127	; $55ec
	ld l,e			; $55ee
	inc (hl)		; $55ef
	ld l,$86		; $55f0
	ld (hl),$50		; $55f2
	ld a,$b3		; $55f4
	jp $56ec		; $55f6
_label_0f_127:
	call _ecom_updateAngleTowardTarget		; $55f9
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $55fc
	call enemyAnimate		; $55ff
	jp $580b		; $5602
	ld a,$02		; $5605
	ld ($cbc3),a		; $5607
	call $580b		; $560a
	ld a,(wFrameCounter)		; $560d
	and $03			; $5610
	call z,_ecom_decCounter2		; $5612
	call _ecom_decCounter1		; $5615
	jr z,_label_0f_128	; $5618
	ld a,(hl)		; $561a
	cp $3c			; $561b
	ret nz			; $561d
	ld a,$05		; $561e
	call enemySetAnimation		; $5620
	ld e,$52		; $5623
	call $57d2		; $5625
	ret nz			; $5628
	ld l,$c2		; $5629
	ld (hl),$02		; $562b
	jp objectCopyPosition		; $562d
_label_0f_128:
	ld l,$85		; $5630
	dec (hl)		; $5632
	inc l			; $5633
	ld (hl),$3c		; $5634
	ld a,$02		; $5636
	jp enemySetAnimation		; $5638
	ld a,($c4ab)		; $563b
	or a			; $563e
	ret nz			; $563f
	ld a,$0a		; $5640
	ld (de),a		; $5642
	ld a,$03		; $5643
	call $582a		; $5645
	ld a,$b1		; $5648
	ld ($cbe3),a		; $564a
	jp loadPaletteHeader		; $564d
	ld h,d			; $5650
	ld l,$a4		; $5651
	set 7,(hl)		; $5653
	call clearPaletteFadeVariablesAndRefreshPalettes		; $5655
	jp $5736		; $5658
	inc e			; $565b
	ld a,(de)		; $565c
	rst_jumpTable			; $565d
	scf			; $565e
	ld d,d			; $565f
	ld a,$52		; $5660
	ld c,h			; $5662
	ld d,d			; $5663
	ld l,b			; $5664
	ld d,(hl)		; $5665
	ld (hl),$57		; $5666
	call _ecom_decCounter1		; $5668
	jp nz,seasonsFunc_0f_5730		; $566b
	ld l,e			; $566e
	inc (hl)		; $566f
	ld l,$b0		; $5670
	ld a,(hl)		; $5672
	ld l,$8d		; $5673
	ld (hl),a		; $5675
	jp objectSetVisible83		; $5676
	inc e			; $5679
	ld a,(de)		; $567a
	rst_jumpTable			; $567b
	add h			; $567c
	ld d,(hl)		; $567d
	or e			; $567e
	ld d,(hl)		; $567f
	push bc			; $5680
	ld d,(hl)		; $5681
	reti			; $5682
	ld d,(hl)		; $5683
	call _ecom_decCounter1		; $5684
	jp nz,_ecom_flickerVisibility		; $5687
	inc (hl)		; $568a
	ld e,$04		; $568b
	call $57d2		; $568d
	ret nz			; $5690
	ld l,$c2		; $5691
	inc (hl)		; $5693
	call objectCopyPosition		; $5694
	ld e,$98		; $5697
	ld a,$c0		; $5699
	ld (de),a		; $569b
	inc e			; $569c
	ld a,h			; $569d
	ld (de),a		; $569e
	ld hl,$cc30		; $569f
	inc (hl)		; $56a2
	ld h,d			; $56a3
	ld l,$85		; $56a4
	inc (hl)		; $56a6
	ld l,$8f		; $56a7
	ld (hl),$00		; $56a9
	call objectSetInvisible		; $56ab
	ld a,$bc		; $56ae
	jp playSound		; $56b0
	ld a,$21		; $56b3
	call objectGetRelatedObject2Var		; $56b5
	bit 7,(hl)		; $56b8
	ret z			; $56ba
	ld h,d			; $56bb
	ld l,$85		; $56bc
	inc (hl)		; $56be
	inc l			; $56bf
	ld (hl),$08		; $56c0
	jp fastFadeoutToWhite		; $56c2
	call _ecom_decCounter1		; $56c5
	ret nz			; $56c8
	ld (hl),$1e		; $56c9
	ld l,e			; $56cb
	inc (hl)		; $56cc
	xor a			; $56cd
	ld ($cbe3),a		; $56ce
	call $582a		; $56d1
	ld a,$02		; $56d4
	jp fadeinFromWhiteWithDelay		; $56d6
	ld a,($c4ab)		; $56d9
	or a			; $56dc
	ret nz			; $56dd
	call _ecom_decCounter1		; $56de
	ret nz			; $56e1
	xor a			; $56e2
	ld ($cbca),a		; $56e3
	call decNumEnemies		; $56e6
	jp enemyDelete		; $56e9
	push af			; $56ec
	call loadGfxHeader		; $56ed
	ld a,UNCMP_GFXH_33		; $56f0
	call loadUncompressedGfxHeader		; $56f2
	pop af			; $56f5
	sub $b2			; $56f6
	add $1e			; $56f8
	ld hl,$cc0b		; $56fa
	ldi (hl),a		; $56fd
	ld (hl),$01		; $56fe
	ldh a,(<hActiveObject)	; $5700
	ld d,a			; $5702
	ret			; $5703

seasonsFunc_0f_5704:
	ld a,(hl)		; $5704
	and $3e			; $5705
	rrca			; $5707
	ld b,a			; $5708
	ld a,$20		; $5709
	sub b			; $570b
_label_0f_129:
	bit 1,(hl)		; $570c
	jr z,_label_0f_130	; $570e
	cpl			; $5710
	inc a			; $5711
_label_0f_130:
	ld l,$b0		; $5712
	add (hl)		; $5714
	ld l,$8d		; $5715
	ld (hl),a		; $5717
	jp _ecom_flickerVisibility		; $5718
	ld a,$8d		; $571b
	call playSound		; $571d
	ld h,d			; $5720
	ld l,$a4		; $5721
	res 7,(hl)		; $5723
	ld l,$86		; $5725
	ld (hl),$3c		; $5727
	ld l,$8d		; $5729
	ld a,(hl)		; $572b
	ld l,$b0		; $572c
	ld (hl),a		; $572e
	ret			; $572f

seasonsFunc_0f_5730:
	ld a,(hl)		; $5730
	and $3e			; $5731
	rrca			; $5733
	jr _label_0f_129		; $5734
	ld h,d			; $5736
	ld l,$b5		; $5737
	ldi a,(hl)		; $5739
	ld h,(hl)		; $573a
	ld l,a			; $573b
	ldi a,(hl)		; $573c
	or a			; $573d
	jr z,_label_0f_132	; $573e
_label_0f_131:
	ld e,$84		; $5740
	ld (de),a		; $5742
	inc e			; $5743
	xor a			; $5744
	ld (de),a		; $5745
	ld e,$b5		; $5746
	ld a,l			; $5748
	ld (de),a		; $5749
	inc e			; $574a
	ld a,h			; $574b
	ld (de),a		; $574c
	ret			; $574d
_label_0f_132:
	ld e,$a9		; $574e
	ld a,(de)		; $5750
	cp $41			; $5751
	ld c,$00		; $5753
	jr nc,_label_0f_133	; $5755
	ld c,$04		; $5757
_label_0f_133:
	call getRandomNumber		; $5759
	and $03			; $575c
	add c			; $575e
	ld hl,$5769		; $575f
	rst_addDoubleIndex			; $5762
	ldi a,(hl)		; $5763
	ld h,(hl)		; $5764
	ld l,a			; $5765
	ldi a,(hl)		; $5766
	jr _label_0f_131		; $5767
	ld a,c			; $5769
	ld d,a			; $576a
	ld a,l			; $576b
	ld d,a			; $576c
	ld a,a			; $576d
	ld d,a			; $576e
	add h			; $576f
_label_0f_134:
	ld d,a			; $5770
	add a			; $5771
	ld d,a			; $5772
	adc c			; $5773
	ld d,a			; $5774
	adc (hl)		; $5775
	ld d,a			; $5776
	sub e			; $5777
	ld d,a			; $5778
	ld ($090a),sp		; $5779
	nop			; $577c
	add hl,bc		; $577d
	nop			; $577e
	ld a,(bc)		; $577f
	ld ($0a09),sp		; $5780
	nop			; $5783
	ld a,(bc)		; $5784
	ld ($0c00),sp		; $5785
	nop			; $5788
	dec bc			; $5789
	dec c			; $578a
	ld ($000a),sp		; $578b
	dec bc			; $578e
	inc c			; $578f
	add hl,bc		; $5790
	ld a,(bc)		; $5791
	nop			; $5792
	dec c			; $5793
	nop			; $5794
	ld bc,$0e0f		; $5795
	call _ecom_randomBitwiseAndBCE		; $5798
	ld a,b			; $579b
	ld hl,$57b2		; $579c
	rst_addAToHl			; $579f
	ld e,$8b		; $57a0
	ldi a,(hl)		; $57a2
	ld (de),a		; $57a3
	ld e,$8d		; $57a4
	ld a,(hl)		; $57a6
	ld (de),a		; $57a7
	ld a,c			; $57a8
	ld hl,$57c2		; $57a9
	rst_addAToHl			; $57ac
	ld e,$86		; $57ad
	ld a,(hl)		; $57af
	ld (de),a		; $57b0
	ret			; $57b1
	jr nc,$38		; $57b2
	jr nc,$78		; $57b4
	jr nc,_label_0f_134	; $57b6
	ld e,b			; $57b8
	ld e,b			; $57b9
	ld e,b			; $57ba
	sbc b			; $57bb
	add b			; $57bc
	jr c,-$80		; $57bd
	ld a,b			; $57bf
	add b			; $57c0
	cp b			; $57c1
	jr z,$28		; $57c2
	jr z,$3c		; $57c4
	inc a			; $57c6
	inc a			; $57c7
	inc a			; $57c8
	inc a			; $57c9
	inc a			; $57ca
	ld e,d			; $57cb
	ld e,d			; $57cc
	ld e,d			; $57cd
	ld e,d			; $57ce
	ld e,d			; $57cf
	ld a,b			; $57d0
	ld a,b			; $57d1
	call getFreePartSlot		; $57d2
	ret nz			; $57d5
	ld (hl),e		; $57d6
	ld l,$d6		; $57d7
	ld (hl),$80		; $57d9
	inc l			; $57db
	ld (hl),d		; $57dc
	xor a			; $57dd
	ret			; $57de
	ld hl,$ce10		; $57df
	ld b,$09		; $57e2
_label_0f_135:
	ld (hl),$0f		; $57e4
	ld a,l			; $57e6
	add $10			; $57e7
	ld l,a			; $57e9
	dec b			; $57ea
	jr nz,_label_0f_135	; $57eb
	ld l,$1e		; $57ed
	ld b,$09		; $57ef
_label_0f_136:
	ld (hl),$0f		; $57f1
	ld a,l			; $57f3
	add $10			; $57f4
	ld l,a			; $57f6
	dec b			; $57f7
	jr nz,_label_0f_136	; $57f8
	ld l,$00		; $57fa
	ld a,$0f		; $57fc
	ld b,a			; $57fe
_label_0f_137:
	ldi (hl),a		; $57ff
	dec b			; $5800
	jr nz,_label_0f_137	; $5801
	ld l,$a0		; $5803
	ld b,a			; $5805
_label_0f_138:
	ldi (hl),a		; $5806
	dec b			; $5807
	jr nz,_label_0f_138	; $5808
	ret			; $580a
	ld a,($cd00)		; $580b
	and $01			; $580e
	ret z			; $5810
	ld a,($c4ab)		; $5811
	or a			; $5814
	ret nz			; $5815
	ld a,(wFrameCounter)		; $5816
	rrca			; $5819
	ret c			; $581a
	ld h,d			; $581b
	ld l,$b7		; $581c
	ld a,(hl)		; $581e
	inc (hl)		; $581f
	and $07			; $5820
	add $b1			; $5822
	ld ($cbe3),a		; $5824
	jp loadPaletteHeader		; $5827
	ld ($ccc4),a		; $582a
	call func_131f		; $582d
	ldh a,(<hActiveObject)	; $5830
	ld d,a			; $5832
	ret			; $5833


enemyCode00:
	ret			; $5834


; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode02:
	jr z,_label_0f_142	; $5835
	sub $03			; $5837
	ret c			; $5839
	jr nz,_label_0f_141	; $583a
	ld e,$a4		; $583c
	ld a,(de)		; $583e
	or a			; $583f
	jr z,_label_0f_139	; $5840
	ld a,$f0		; $5842
	call playSound		; $5844
_label_0f_139:
	ld e,$b2		; $5847
	ld a,(de)		; $5849
	or a			; $584a
	jr nz,_label_0f_140	; $584b
	call checkLinkCollisionsEnabled		; $584d
	jr nc,_label_0f_140	; $5850
	ld a,$ff		; $5852
	ld ($cbca),a		; $5854
	ld ($cc02),a		; $5857
	ld h,d			; $585a
	ld l,$a4		; $585b
	ld (hl),$00		; $585d
	ld l,$b2		; $585f
	inc (hl)		; $5861
	ld l,$86		; $5862
	ld (hl),$78		; $5864
	ld a,$67		; $5866
	call playSound		; $5868
_label_0f_140:
	jp _enemyBoss_dead		; $586b
_label_0f_141:
	ld e,$82		; $586e
	ld a,(de)		; $5870
	or a			; $5871
	call z,$5c75		; $5872
_label_0f_142:
	call _ecom_getSubidAndCpStateTo08		; $5875
	jr nc,_label_0f_143	; $5878
	rst_jumpTable			; $587a
	sub e			; $587b
	ld e,b			; $587c
	push bc			; $587d
	ld e,b			; $587e
	push bc			; $587f
	ld e,b			; $5880
	push bc			; $5881
	ld e,b			; $5882
	push bc			; $5883
	ld e,b			; $5884
	push bc			; $5885
	ld e,b			; $5886
	push bc			; $5887
	ld e,b			; $5888
	push bc			; $5889
	ld e,b			; $588a
_label_0f_143:
	ld a,b			; $588b
	rst_jumpTable			; $588c
	add $58			; $588d
	ld e,l			; $588f
	ld e,d			; $5890
	and (hl)		; $5891
	ld e,e			; $5892
	ld a,b			; $5893
	cp $02			; $5894
	jr z,_label_0f_144	; $5896
	ld bc,$0210		; $5898
	call _enemyBoss_spawnShadow		; $589b
	ret nz			; $589e
	ld a,$02		; $589f
	ld b,$89		; $58a1
	call _enemyBoss_initializeRoom		; $58a3
	ld a,$01		; $58a6
	ld ($cc17),a		; $58a8
	ld a,$0a		; $58ab
	jp _ecom_setSpeedAndState8		; $58ad
_label_0f_144:
	ld a,$89		; $58b0
	call loadPaletteHeader		; $58b2
	ld a,$01		; $58b5
	ld ($cfcf),a		; $58b7
	ld ($cbca),a		; $58ba
	call _ecom_setSpeedAndState8		; $58bd
	ld a,$53		; $58c0
	jp playSound		; $58c2
	ret			; $58c5
	ld a,(de)		; $58c6
	sub $08			; $58c7
	rst_jumpTable			; $58c9
	call nc,$ed58		; $58ca
	ld e,b			; $58cd
	ld e,a			; $58ce
	ld e,c			; $58cf
	ld l,h			; $58d0
	ld e,c			; $58d1
	ld e,$5a		; $58d2
	ld b,$47		; $58d4
	call _ecom_spawnProjectile		; $58d6
	ret nz			; $58d9
	ld h,d			; $58da
	ld l,$84		; $58db
	inc (hl)		; $58dd
	ld l,$89		; $58de
	ld (hl),$10		; $58e0
	ld l,$8b		; $58e2
	ld (hl),$18		; $58e4
	ld l,$8d		; $58e6
	ld (hl),$78		; $58e8
	jp objectSetVisible83		; $58ea
	inc e			; $58ed
	ld a,(de)		; $58ee
	rst_jumpTable			; $58ef
	ld hl,sp+$58		; $58f0
	add hl,bc		; $58f2
	ld e,c			; $58f3
	add hl,hl		; $58f4
	ld e,c			; $58f5
	inc a			; $58f6
	ld e,c			; $58f7
	ld a,$05		; $58f8
	call objectGetRelatedObject2Var		; $58fa
	ld a,(hl)		; $58fd
	cp $04			; $58fe
	ret nz			; $5900
	ld h,d			; $5901
	ld l,$85		; $5902
	inc (hl)		; $5904
	ld l,$87		; $5905
	ld (hl),$1e		; $5907
	call _ecom_decCounter2		; $5909
	ret nz			; $590c
	ld a,(wFrameCounter)		; $590d
	and $1f			; $5910
	ld a,$70		; $5912
	call z,playSound		; $5914
	call objectApplySpeed		; $5917
	ld e,$8b		; $591a
	ld a,(de)		; $591c
	cp $48			; $591d
	jp nz,enemyAnimate		; $591f
	ld h,d			; $5922
	ld l,$85		; $5923
	inc (hl)		; $5925
	inc l			; $5926
	ld (hl),$08		; $5927
	call _ecom_decCounter1		; $5929
	ret nz			; $592c
	ld l,e			; $592d
	inc (hl)		; $592e
	ld bc,$501c		; $592f
	call checkIsLinkedGame		; $5932
	jr z,_label_0f_145	; $5935
	ld c,$20		; $5937
_label_0f_145:
	jp showText		; $5939
	ld e,$90		; $593c
	ld a,$0f		; $593e
	ld (de),a		; $5940
	ld a,$2e		; $5941
	ld (wActiveMusic),a		; $5943
	call playSound		; $5946
	ld a,$04		; $5949
	call objectGetRelatedObject2Var		; $594b
	inc (hl)		; $594e
	ld h,d			; $594f
	ld l,$84		; $5950
	ld (hl),$0a		; $5952
	inc l			; $5954
	ld (hl),$00		; $5955
	inc l			; $5957
	ld (hl),$2d		; $5958
	ld a,$02		; $595a
	jp enemySetAnimation		; $595c
	call _ecom_decCounter1		; $595f
	ret nz			; $5962
	ld (hl),$b4		; $5963
	inc l			; $5965
	ld (hl),$0a		; $5966
	ld l,e			; $5968
	inc (hl)		; $5969
	jr _label_0f_148		; $596a
	inc e			; $596c
	ld a,(de)		; $596d
	rst_jumpTable			; $596e
	ld (hl),l		; $596f
	ld e,c			; $5970
	jp $fe59		; $5971
	ld e,c			; $5974
	call _ecom_decCounter1		; $5975
	jr nz,_label_0f_146	; $5978
	ld a,$24		; $597a
	call objectGetRelatedObject2Var		; $597c
	res 7,(hl)		; $597f
	ld l,$da		; $5981
	res 7,(hl)		; $5983
	ld l,$c4		; $5985
	ld (hl),$08		; $5987
	jr _label_0f_149		; $5989
_label_0f_146:
	call $5c3b		; $598b
	jr nc,_label_0f_147	; $598e
	call enemyAnimate		; $5990
	call _ecom_decCounter2		; $5993
	jr nz,_label_0f_148	; $5996
	ld a,$09		; $5998
	call objectGetRelatedObject2Var		; $599a
	ld a,(hl)		; $599d
	sub $0e			; $599e
	cp $07			; $59a0
	jr nc,_label_0f_148	; $59a2
	ld l,$c4		; $59a4
	inc (hl)		; $59a6
	ld e,$85		; $59a7
	ld a,$01		; $59a9
	ld (de),a		; $59ab
	ld a,$05		; $59ac
	jp enemySetAnimation		; $59ae
_label_0f_147:
	ld l,$87		; $59b1
	ld (hl),$0a		; $59b3
	ld a,(wFrameCounter)		; $59b5
	and $07			; $59b8
	call z,$5c4e		; $59ba
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $59bd
_label_0f_148:
	jp enemyAnimate		; $59c0
	ld a,$09		; $59c3
	call objectGetRelatedObject2Var		; $59c5
	ld a,(hl)		; $59c8
	cp $03			; $59c9
	ret nz			; $59cb
	ld l,$c4		; $59cc
	inc (hl)		; $59ce
	ld l,$e8		; $59cf
	ld (hl),$f8		; $59d1
	ld l,$c9		; $59d3
	ld (hl),$0e		; $59d5
	ld l,$c6		; $59d7
	ld (hl),$00		; $59d9
	ld l,$cb		; $59db
	ld e,$8b		; $59dd
	ld a,(de)		; $59df
	sub $10			; $59e0
	ld (hl),a		; $59e2
	ld l,$f0		; $59e3
	add $21			; $59e5
	ld (hl),a		; $59e7
	ld l,$cd		; $59e8
	ld e,$8d		; $59ea
	ld a,(de)		; $59ec
	add $08			; $59ed
	ld (hl),a		; $59ef
	ld l,$f1		; $59f0
	add $f9			; $59f2
	ld (hl),a		; $59f4
	ld e,$85		; $59f5
	ld a,$02		; $59f7
	ld (de),a		; $59f9
	inc a			; $59fa
	jp enemySetAnimation		; $59fb
	ld a,$24		; $59fe
	call objectGetRelatedObject2Var		; $5a00
	bit 7,(hl)		; $5a03
	ret nz			; $5a05
_label_0f_149:
	call getRandomNumber_noPreserveVars		; $5a06
	cp $8c			; $5a09
	jp c,$594f		; $5a0b
	ld h,d			; $5a0e
	ld l,$84		; $5a0f
	inc (hl)		; $5a11
	inc l			; $5a12
	ld (hl),$00		; $5a13
	ld l,$86		; $5a15
	ld (hl),$10		; $5a17
	ld a,$04		; $5a19
	jp enemySetAnimation		; $5a1b
	inc e			; $5a1e
	ld a,(de)		; $5a1f
	rst_jumpTable			; $5a20
	daa			; $5a21
	ld e,d			; $5a22
	inc a			; $5a23
	ld e,d			; $5a24
	ld d,(hl)		; $5a25
	ld e,d			; $5a26
	call _ecom_decCounter1		; $5a27
	ret nz			; $5a2a
	ld l,e			; $5a2b
	inc (hl)		; $5a2c
	ld l,$94		; $5a2d
	ld a,$c0		; $5a2f
	ldi (hl),a		; $5a31
	ld (hl),$fd		; $5a32
	ld a,$81		; $5a34
	call playSound		; $5a36
	jp objectSetVisible81		; $5a39
	ld c,$20		; $5a3c
	call objectUpdateSpeedZ_paramC		; $5a3e
	ret nz			; $5a41
	ld l,$85		; $5a42
	inc (hl)		; $5a44
	inc l			; $5a45
	ld a,$b4		; $5a46
	ld (hl),a		; $5a48
	call setScreenShakeCounter		; $5a49
	call objectSetVisible83		; $5a4c
	call getFreePartSlot		; $5a4f
	ret nz			; $5a52
	ld (hl),$48		; $5a53
	ret			; $5a55
	call _ecom_decCounter1		; $5a56
	ret nz			; $5a59
	jp $594f		; $5a5a
	ld a,(de)		; $5a5d
	sub $08			; $5a5e
	rst_jumpTable			; $5a60
	ld l,l			; $5a61
	ld e,d			; $5a62
	adc h			; $5a63
	ld e,d			; $5a64
	ld e,a			; $5a65
	ld e,c			; $5a66
.DB $fc				; $5a67
	ld e,d			; $5a68
	ld e,e			; $5a69
	ld e,e			; $5a6a
	ld l,e			; $5a6b
	ld e,e			; $5a6c
	ld c,$20		; $5a6d
	call objectUpdateSpeedZ_paramC		; $5a6f
	ret nz			; $5a72
	ld l,$84		; $5a73
	inc (hl)		; $5a75
	inc l			; $5a76
	xor a			; $5a77
	ld (hl),a		; $5a78
	ld ($cd18),a		; $5a79
	ld ($cd19),a		; $5a7c
	ld l,$b0		; $5a7f
	dec a			; $5a81
	ldi (hl),a		; $5a82
	ld (hl),a		; $5a83
	ld a,$01		; $5a84
	call enemySetAnimation		; $5a86
	jp objectSetVisible83		; $5a89
	inc e			; $5a8c
	ld a,(de)		; $5a8d
	rst_jumpTable			; $5a8e
	sub l			; $5a8f
	ld e,d			; $5a90
	xor a			; $5a91
	ld e,d			; $5a92
	sub $5a			; $5a93
	ld e,$ab		; $5a95
	ld a,(de)		; $5a97
	or a			; $5a98
	ret nz			; $5a99
	ld a,($cc34)		; $5a9a
	or a			; $5a9d
	ret nz			; $5a9e
	inc a			; $5a9f
	ld ($cca4),a		; $5aa0
	ld ($cbca),a		; $5aa3
	ld e,$85		; $5aa6
	ld (de),a		; $5aa8
	ld bc,$501d		; $5aa9
	jp showText		; $5aac
	ld h,d			; $5aaf
	ld l,e			; $5ab0
	inc (hl)		; $5ab1
	inc l			; $5ab2
	ld (hl),$64		; $5ab3
	ld a,$00		; $5ab5
	call objectGetRelatedObject1Var		; $5ab7
	ld bc,$18f8		; $5aba
	call objectCopyPositionWithOffset		; $5abd
	ldh a,(<hCameraY)	; $5ac0
	ld b,a			; $5ac2
	ld l,$cb		; $5ac3
	ld a,(hl)		; $5ac5
	sub b			; $5ac6
	cpl			; $5ac7
	inc a			; $5ac8
	sub $10			; $5ac9
	ld l,$cf		; $5acb
	ld (hl),a		; $5acd
	ld l,$da		; $5ace
	ld (hl),$81		; $5ad0
	ld l,$c4		; $5ad2
	inc (hl)		; $5ad4
	ret			; $5ad5
	call _ecom_decCounter1		; $5ad6
	ret nz			; $5ad9
	ld l,$a4		; $5ada
	set 7,(hl)		; $5adc
	xor a			; $5ade
	ld ($cca4),a		; $5adf
	ld ($cbca),a		; $5ae2
_label_0f_150:
	ld h,d			; $5ae5
	ld l,$84		; $5ae6
	ld (hl),$0a		; $5ae8
	inc l			; $5aea
	ld (hl),$00		; $5aeb
	ld l,$86		; $5aed
	ld (hl),$2d		; $5aef
	ld l,$b1		; $5af1
	ldd a,(hl)		; $5af3
	ldi (hl),a		; $5af4
	ld (hl),$00		; $5af5
	ld a,$02		; $5af7
	jp enemySetAnimation		; $5af9
	inc e			; $5afc
	ld a,(de)		; $5afd
	rst_jumpTable			; $5afe
	dec b			; $5aff
	ld e,e			; $5b00
	jp $1a59		; $5b01
	ld e,e			; $5b04
	call _ecom_decCounter1		; $5b05
	jp nz,_label_0f_146		; $5b08
	ld a,$24		; $5b0b
	call objectGetRelatedObject2Var		; $5b0d
	res 7,(hl)		; $5b10
	ld l,$da		; $5b12
	res 7,(hl)		; $5b14
	ld l,$c4		; $5b16
	ld (hl),$08		; $5b18
	ld a,$24		; $5b1a
	call objectGetRelatedObject2Var		; $5b1c
	bit 7,(hl)		; $5b1f
	ret nz			; $5b21
	ld h,d			; $5b22
	ld l,$b0		; $5b23
	ldi a,(hl)		; $5b25
	cp (hl)			; $5b26
	ld l,$85		; $5b27
	ld (hl),$00		; $5b29
	jr z,_label_0f_151	; $5b2b
	call getRandomNumber		; $5b2d
	rrca			; $5b30
	jr c,_label_0f_150	; $5b31
	ld h,d			; $5b33
	dec l			; $5b34
	ld (hl),$0d		; $5b35
	ld l,$b1		; $5b37
	ldd a,(hl)		; $5b39
	ldi (hl),a		; $5b3a
	ld (hl),$02		; $5b3b
	call $5c63		; $5b3d
	ld e,$86		; $5b40
	ld a,(de)		; $5b42
	dec a			; $5b43
	ret z			; $5b44
	xor a			; $5b45
	jp enemySetAnimation		; $5b46
_label_0f_151:
	dec l			; $5b49
	ld (hl),$0c		; $5b4a
	ld l,$86		; $5b4c
	ld (hl),$10		; $5b4e
	ld l,$b1		; $5b50
	ldd a,(hl)		; $5b52
	ldi (hl),a		; $5b53
	ld (hl),$01		; $5b54
	ld a,$04		; $5b56
	jp enemySetAnimation		; $5b58
	inc e			; $5b5b
	ld a,(de)		; $5b5c
	rst_jumpTable			; $5b5d
	daa			; $5b5e
	ld e,d			; $5b5f
	inc a			; $5b60
	ld e,d			; $5b61
	ld h,h			; $5b62
	ld e,e			; $5b63
	call _ecom_decCounter1		; $5b64
	ret nz			; $5b67
	jp $5ae5		; $5b68
	inc e			; $5b6b
	ld a,(de)		; $5b6c
	rst_jumpTable			; $5b6d
	ld (hl),h		; $5b6e
	ld e,e			; $5b6f
	adc l			; $5b70
	ld e,e			; $5b71
	ldi (hl),a		; $5b72
	ld e,e			; $5b73
	call _ecom_decCounter1		; $5b74
	jr nz,_label_0f_152	; $5b77
	inc (hl)		; $5b79
	inc l			; $5b7a
	ld (hl),$04		; $5b7b
	ld l,e			; $5b7d
	inc (hl)		; $5b7e
	ld a,$03		; $5b7f
	jp enemySetAnimation		; $5b81
_label_0f_152:
	call _ecom_updateAngleTowardTarget		; $5b84
	call objectApplySpeed		; $5b87
	jp enemyAnimate		; $5b8a
	call _ecom_decCounter1		; $5b8d
	ret nz			; $5b90
	ld (hl),$2d		; $5b91
	inc l			; $5b93
	dec (hl)		; $5b94
	jr z,_label_0f_153	; $5b95
	call getFreePartSlot		; $5b97
	ret nz			; $5b9a
	ld (hl),$49		; $5b9b
	ld bc,$19f9		; $5b9d
	jp objectCopyPositionWithOffset		; $5ba0
_label_0f_153:
	ld l,e			; $5ba3
	inc (hl)		; $5ba4
	ret			; $5ba5
	ld a,(de)		; $5ba6
	sub $08			; $5ba7
	rst_jumpTable			; $5ba9
	or h			; $5baa
	ld e,e			; $5bab
	ld ($ff00+$5b),a	; $5bac
	di			; $5bae
	ld e,e			; $5baf
	daa			; $5bb0
	ld e,h			; $5bb1
	cpl			; $5bb2
	ld e,h			; $5bb3
	ld a,($cc77)		; $5bb4
	or a			; $5bb7
	ret nz			; $5bb8
	ld ($cfcf),a		; $5bb9
	inc a			; $5bbc
	ld ($cca4),a		; $5bbd
	ld h,d			; $5bc0
	ld l,$8b		; $5bc1
	ld (hl),$50		; $5bc3
	ld l,$8d		; $5bc5
	ld (hl),$50		; $5bc7
	ld bc,$0b02		; $5bc9
	call objectCreateInteraction		; $5bcc
	ret nz			; $5bcf
	ld e,$98		; $5bd0
	ld a,$40		; $5bd2
	ld (de),a		; $5bd4
	inc e			; $5bd5
	ld a,h			; $5bd6
	ld (de),a		; $5bd7
	ld e,$84		; $5bd8
	ld a,$09		; $5bda
	ld (de),a		; $5bdc
	jp clearAllParentItems		; $5bdd
	ld a,$21		; $5be0
	call objectGetRelatedObject2Var		; $5be2
	bit 7,(hl)		; $5be5
	ret z			; $5be7
	ld h,d			; $5be8
	ld l,$84		; $5be9
	inc (hl)		; $5beb
	ld l,$86		; $5bec
	ld (hl),$5a		; $5bee
	call objectSetVisible82		; $5bf0
	call _ecom_decCounter1		; $5bf3
	jr z,_label_0f_154	; $5bf6
	ld a,(hl)		; $5bf8
	and $1c			; $5bf9
	rrca			; $5bfb
	rrca			; $5bfc
	ld hl,$5c1f		; $5bfd
	rst_addAToHl			; $5c00
	ld e,$8b		; $5c01
	ld a,(hl)		; $5c03
	ld (de),a		; $5c04
	ret			; $5c05
_label_0f_154:
	ld (hl),$5a		; $5c06
	ld l,e			; $5c08
	inc (hl)		; $5c09
	ld a,$30		; $5c0a
	ld ($cd08),a		; $5c0c
	ld a,$08		; $5c0f
	ld ($cbae),a		; $5c11
	ld a,$06		; $5c14
	ld ($cbac),a		; $5c16
	ld bc,$5022		; $5c19
	jp showText		; $5c1c
	ld d,b			; $5c1f
	ld d,c			; $5c20
	ld d,d			; $5c21
	ld d,e			; $5c22
	ld d,d			; $5c23
	ld d,c			; $5c24
	ld d,b			; $5c25
	ld c,a			; $5c26
	ld e,$84		; $5c27
	ld a,$0c		; $5c29
	ld (de),a		; $5c2b
	jp fadeoutToWhite		; $5c2c
	ld a,($c4ab)		; $5c2f
	or a			; $5c32
	ret nz			; $5c33
	ld hl,$cfc8		; $5c34
	inc (hl)		; $5c37
	jp enemyDelete		; $5c38
	ld h,d			; $5c3b
	ld l,$8b		; $5c3c
	ldh a,(<hEnemyTargetY)	; $5c3e
	sub (hl)		; $5c40
	cp $30			; $5c41
	ret nc			; $5c43
	ld l,$8d		; $5c44
	ldh a,(<hEnemyTargetX)	; $5c46
	sub (hl)		; $5c48
	add $10			; $5c49
	cp $21			; $5c4b
	ret			; $5c4d
	ldh a,(<hEnemyTargetY)	; $5c4e
	sub $18			; $5c50
	cp $98			; $5c52
	jr c,_label_0f_155	; $5c54
	ld a,$10		; $5c56
_label_0f_155:
	ld b,a			; $5c58
	ldh a,(<hEnemyTargetX)	; $5c59
	ld c,a			; $5c5b
	call objectGetRelativeAngle		; $5c5c
	ld e,$89		; $5c5f
	ld (de),a		; $5c61
	ret			; $5c62
	call getRandomNumber_noPreserveVars		; $5c63
	and $03			; $5c66
	ld hl,$5c71		; $5c68
	rst_addAToHl			; $5c6b
	ld e,$86		; $5c6c
	ld a,(hl)		; $5c6e
	ld (de),a		; $5c6f
	ret			; $5c70
	ld bc,$3c1e		; $5c71
	ld e,d			; $5c74
	ld e,$a9		; $5c75
	ld a,(de)		; $5c77
	cp $28			; $5c78
	ret nc			; $5c7a
	ld h,d			; $5c7b
	ld l,$82		; $5c7c
	inc (hl)		; $5c7e
	ld l,$84		; $5c7f
	ld (hl),$08		; $5c81
	ld l,$a4		; $5c83
	res 7,(hl)		; $5c85
	ld a,$24		; $5c87
	call objectGetRelatedObject2Var		; $5c89
	res 7,(hl)		; $5c8c
	ld l,$da		; $5c8e
	res 7,(hl)		; $5c90
	ld l,$c4		; $5c92
	ld (hl),$08		; $5c94
	ld a,$67		; $5c96
	jp playSound		; $5c98

; ==============================================================================
; ENEMYID_DRAGON_ONOX
;
; Variables:
;   var2a:
;   var2f:
;   var30:
;   var31:
;   var32:
;   var33:
;   var34:
;   var35:
;   var36:
;   var37:
;   var38:
;   $cfc8 - near end
;   $cfc9
;   $cfca
;   $cfcb
;   $cfcc
;   $cfcd
;   $cfd7 - Pointer to main body (subid $01)
;   $cfd8 - Pointer to left shoulder (subid $02)
;   $cfd9 - Pointer to right shoulder (subid $03)
;   $cfda - Pointer to left claw (subid $04)
;   $cfdb - Pointer to right claw (subid $05)
;   $cfdc - Pointer to left claw sphere (subid $06)
;   $cfdd - Pointer to right claw sphere (subid $07)
;   $cfde - Pointer to left shoulder sphere (subid $08)
;   $cfdf - Pointer to right shoulder sphere (subid $09)
; ==============================================================================
enemyCode05:
	jr z,@normalStatus	; $5c9b
	sub ENEMYSTATUS_NO_HEALTH		; $5c9d
	ret c			; $5c9f
	jr nz,@justHit		; $5ca0

	ld h,d			; $5ca2
	ld l,Enemy.collisionType		; $5ca3
	res 7,(hl)		; $5ca5
	xor a			; $5ca7
	ld l,Enemy.state2	; $5ca8
	ldd (hl),a		; $5caa
	; state $0e
	ld (hl),$0e		; $5cab
	ld l,Enemy.health	; $5cad
	inc a			; $5caf
	ld (hl),a		; $5cb0
	ld (wDisableLinkCollisionsAndMenu),a		; $5cb1
	jr @normalStatus		; $5cb4

@justHit:
	ld e,Enemy.subid		; $5cb6
	ld a,(de)		; $5cb8
	dec a			; $5cb9
	jr nz,@normalStatus	; $5cba

	; main body
	ld e,Enemy.var2a	; $5cbc
	ld a,(de)		; $5cbe
	res 7,a			; $5cbf
	sub $04			; $5cc1
	cp $06			; $5cc3
	jr nc,@normalStatus	; $5cc5

	ld h,d			; $5cc7
	ld l,Enemy.invincibilityCounter		; $5cc8
	ld (hl),$3c		; $5cca
	; var30 - $06
	; var31 - $06
	; var32 - $04
	; var37 - $01
	; $cfc9 - $86
	ld l,Enemy.var37	; $5ccc
	ld (hl),$01		; $5cce
	ld l,Enemy.var31	; $5cd0
	ld (hl),$06		; $5cd2
	inc l			; $5cd4
	ld (hl),$04		; $5cd5
	ld a,$06		; $5cd7
	call dragonOnoxLoadaIntoVar30Andcfc9		; $5cd9

@normalStatus:
	ld e,Enemy.subid		; $5cdc
	ld a,(de)		; $5cde
	ld b,a			; $5cdf
	ld e,Enemy.state		; $5ce0
	ld a,b			; $5ce2
	rst_jumpTable			; $5ce3
	.dw dragonOnox_bodyPartSpawner
	.dw dragonOnox_mainBody
	.dw dragonOnox_leftShoulder
	.dw dragonOnox_rightShoulder
	.dw dragonOnox_leftClaw
	.dw dragonOnox_rightClaw
	.dw dragonOnox_leftClawSphere
	.dw dragonOnox_rightClawSphere
	.dw dragonOnox_leftShoulderSphere
	.dw dragonOnox_rightShoulderSphere

dragonOnox_bodyPartSpawner:
	ld a,ENEMYID_DRAGON_ONOX		; $5cf8
	ld b,$8a		; $5cfa
	call _enemyBoss_initializeRoom		; $5cfc
	xor a			; $5cff
	ld (wLinkForceState),a		; $5d00
	inc a			; $5d03
	ld (wLoadedTreeGfxIndex),a		; $5d04
	ld (wDisableLinkCollisionsAndMenu),a		; $5d07
	ld b,$09		; $5d0a
	call checkBEnemySlotsAvailable		; $5d0c
	ret nz			; $5d0f
	ld b,ENEMYID_DRAGON_ONOX		; $5d10
	call _ecom_spawnUncountedEnemyWithSubid01		; $5d12
	ld l,Enemy.enabled		; $5d15
	ld e,l			; $5d17
	ld a,(de)		; $5d18
	ld (hl),a		; $5d19
	ld a,h			; $5d1a
	; store in $cfd7 a pointer to Dragon Onox with subid $01
	ld hl,$cfd7		; $5d1b
	ldi (hl),a		; $5d1e
	ld c,$08		; $5d1f
-
	push hl			; $5d21
	call _ecom_spawnUncountedEnemyWithSubid01		; $5d22
	; spawn from subids $02 to $09, storing in $cfd8 to $cfdf
	ld a,$0a		; $5d25
	sub c			; $5d27
	ld (hl),a		; $5d28
	ld a,h			; $5d29
	pop hl			; $5d2a
	ldi (hl),a		; $5d2b
	dec c			; $5d2c
	jr nz,-			; $5d2d
	jp enemyDelete		; $5d2f

dragonOnox_mainBody:
	ld e,Enemy.state		; $5d32
	ld a,(de)		; $5d34
	sub $02			; $5d35
	cp $0c			; $5d37
	jr nc,+			; $5d39
	; state $02 to $0d
	ld a,(wFrameCounter)		; $5d3b
	and $3f			; $5d3e
	ld a,SND_AQUAMENTUS_HOVER		; $5d40
	call z,playSound		; $5d42
+
	call dragonOnox_checkTransitionState		; $5d45
	call z,dragonOnox_mainBodyStateHandler		; $5d48
	call seasonsFunc_0f_65c7		; $5d4b
	jp seasonsFunc_0f_65fc		; $5d4e

dragonOnox_mainBodyStateHandler:
	ld e,Enemy.state	; $5d51
	ld a,(de)		; $5d53
	rst_jumpTable			; $5d54
	.dw dragonOnox_mainBody_state0
	.dw dragonOnox_mainBody_state1
	.dw dragonOnox_mainBody_state2
	.dw dragonOnox_mainBody_state3
	.dw dragonOnox_mainBody_state4
	.dw dragonOnox_mainBody_state5
	.dw dragonOnox_mainBody_state6
	.dw dragonOnox_mainBody_state7
	.dw dragonOnox_mainBody_state8
	.dw dragonOnox_mainBody_state9
	.dw dragonOnox_mainBody_stateA
	.dw dragonOnox_mainBody_stateB
	.dw dragonOnox_mainBody_stateC
	.dw dragonOnox_mainBody_stateD
	.dw dragonOnox_mainBody_stateE

dragonOnox_checkTransitionState:
	ld e,Enemy.state		; $5d73
	ld a,(de)		; $5d75
	cp $0e			; $5d76
	ret z			; $5d78

	ld b,a			; $5d79
	ld e,Enemy.invincibilityCounter		; $5d7a
	ld a,(de)		; $5d7c
	or a			; $5d7d
	ret z			; $5d7e

	; Continue once invincibilityCounter about to end
	dec a			; $5d7f
	ret nz			; $5d80

	ld a,b			; $5d81
	cp $08			; $5d82
	jr nz,+			; $5d84

	ld e,Enemy.state2		; $5d86
	ld a,(de)		; $5d88
	sub $02			; $5d89
	cp $02			; $5d8b
	jr nc,+			; $5d8d

	; state2 with value $02 or $03
	ld e,Enemy.angle		; $5d8f
	ld a,(de)		; $5d91
	bit 4,a			; $5d92
	ld a,$08		; $5d94
	jr nz,++		; $5d96
	ld a,$09		; $5d98
	jr ++			; $5d9a
+
	; non-state $08 goes here
	; or non-state2 of $02/$03
	ld e,Enemy.var30		; $5d9c
	ld a,(de)		; $5d9e
	and $01			; $5d9f
	add $00			; $5da1
++
	; non-state 8
	;	var30 - bit 0 of previous var30
	;	$cfc9 - $80|bit 0 of previous var30
	; state 8, state2 of $02/$03, bit 4 of angle set (ANGLE_DOWN/ANGLE_LEFT)
	;	var30 - $08
	;	$cfc9 - $88
	; state 8, state2 of $02/$03, bit 4 of angle not set (ANGLE_UP/ANGLE_RIGHT)
	;	var30 - $09
	;	$cfc9 - $89
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $5da3

dragonOnox_mainBody_state0:
	ld h,d			; $5da6
	ld l,e			; $5da7
	; next state
	inc (hl)		; $5da8

	ld l,Enemy.counter1		; $5da9
	ld (hl),$5a		; $5dab
	ld l,Enemy.speed		; $5dad
	ld (hl),SPEED_80		; $5daf
	ld l,Enemy.collisionType		; $5db1
	set 7,(hl)		; $5db3
	ld l,Enemy.oamFlagsBackup		; $5db5
	ld a,$05		; $5db7
	ldi (hl),a		; $5db9
	ld (hl),a		; $5dba
	; var31 - $14
	; var32 - $0c
	ld l,Enemy.var31		; $5dbb
	ld (hl),$14		; $5dbd
	inc l			; $5dbf
	ld (hl),$0c		; $5dc0
	call checkIsLinkedGame		; $5dc2
	jr nz,+			; $5dc5
	ld l,Enemy.health		; $5dc7
	ld (hl),$22		; $5dc9
+
	call objectSetVisible83		; $5dcb
	ld a,$04		; $5dce
	jp fadeinFromWhiteWithDelay		; $5dd0

dragonOnox_mainBody_state1:
	inc e			; $5dd3
	ld a,(de)		; $5dd4
	or a			; $5dd5
	jr nz,++		; $5dd6

	; state2 is 0
	call _ecom_decCounter1		; $5dd8
	jr z,+			; $5ddb
	ld a,(hl)		; $5ddd
	cp $3c			; $5dde
	ret nz			; $5de0
	ld a,SND_AQUAMENTUS_HOVER		; $5de1
	jp playSound		; $5de3
+
	ld l,e			; $5de6
	inc (hl)		; $5de7
	ld a,$08		; $5de8
	ld (wTextboxFlags),a		; $5dea
	ld a,$06		; $5ded
	ld (wTextboxPosition),a		; $5def
	ld bc,TX_501e		; $5df2
	jp showText		; $5df5
++
	ld h,d			; $5df8
	ld l,e			; $5df9
	xor a			; $5dfa
	ldd (hl),a		; $5dfb
	inc (hl)		; $5dfc

	; start fight
	xor a			; $5dfd
	ld (wDisableLinkCollisionsAndMenu),a		; $5dfe
	ld (wDisabledObjects),a		; $5e01
	ld (wMenuDisabled),a		; $5e04
	ld a,MUS_FINAL_BOSS		; $5e07
	ld (wActiveMusic),a		; $5e09
	jp playSound		; $5e0c

dragonOnox_mainBody_state2:
	; Every substate here starts with (hl)=Enemy.var37
	ld h,d			; $5e0f
	ld l,Enemy.var37		; $5e10
	bit 0,(hl)		; $5e12
	jr z,+			; $5e14
	ld (hl),$00		; $5e16
	ld l,Enemy.counter2		; $5e18
	ld (hl),$00		; $5e1a
+
	inc e			; $5e1c
	ld a,(de)		; $5e1d
	rst_jumpTable			; $5e1e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld h,d			; $5e29
	ld l,e			; $5e2a
	; next substate
	inc (hl)		; $5e2b
	; counter1
	inc l			; $5e2c
	ld (hl),$1e		; $5e2d
	; counter2
	inc l			; $5e2f
	ld (hl),$10		; $5e30

	ld l,Enemy.speed		; $5e32
	ld (hl),SPEED_c0		; $5e34
	ld l,Enemy.var33		; $5e36
	ld (hl),$00		; $5e38
	call getRandomNumber_noPreserveVars		; $5e3a
	and $01			; $5e3d
	ld b,ANGLE_UP		; $5e3f
	jr nz,+			; $5e41
	dec a			; $5e43
	ld b,ANGLE_DOWN		; $5e44
+
	ld e,Enemy.var34		; $5e46
	ld (de),a		; $5e48
	ld e,Enemy.angle		; $5e49
	ld a,b			; $5e4b
	ld (de),a		; $5e4c
	ret			; $5e4d

@substate1:
	call _ecom_decCounter2		; $5e4e
	jp z,seasonsFunc_0f_665c		; $5e51
	ld l,e			; $5e54
	; go to substate2
	ld (hl),$02		; $5e55
	call seasonsFunc_0f_6637		; $5e57
	
@substate2:
	call _ecom_decCounter1		; $5e5a
	jr nz,+			; $5e5d
	ld (hl),$1e		; $5e5f
	ld a,($cfcc)		; $5e61
	sub $10			; $5e64
	cp $40			; $5e66
	jr c,+			; $5e68
	call getRandomNumber		; $5e6a
	cp $a0			; $5e6d
	jr nc,+			; $5e6f
	ld l,e			; $5e71
	inc (hl)		; $5e72
	ret			; $5e73
+
	ld l,Enemy.var35		; $5e74
	ld b,(hl)		; $5e76
	; var36
	inc l			; $5e77
	ld c,(hl)		; $5e78
	ld a,($cfcc)		; $5e79
	ld h,a			; $5e7c
	ld a,($cfcd)		; $5e7d
	ld l,a			; $5e80
	sub c			; $5e81
	add $06			; $5e82
	cp $0d			; $5e84
	jr nc,+			; $5e86
	ld a,h			; $5e88
	sub b			; $5e89
	add $06			; $5e8a
	cp $0d			; $5e8c
	jr c,@substate1	; $5e8e
+
	ld e,Enemy.counter1		; $5e90
	ld a,(de)		; $5e92
	rrca			; $5e93
	jr c,+			; $5e94
	call seasonsFunc_0f_6529		; $5e96
	call objectNudgeAngleTowards		; $5e99
+
	jp seasonsFunc_0f_650d		; $5e9c

@substate3:
	call _ecom_decCounter1		; $5e9f
	ret nz			; $5ea2
	ld l,e			; $5ea3
	inc (hl)		; $5ea4
	ld l,Enemy.xh		; $5ea5
	ld a,(w1Link.xh)		; $5ea7
	cp (hl)			; $5eaa
	; dragon Onox subid 4
	ld hl,$cfda		; $5eab
	jr c,+			; $5eae
	; subid 5
	inc l			; $5eb0
+
	; choose claw to action
	ld h,(hl)		; $5eb1
	ld l,Enemy.var30		; $5eb2
	ld (hl),$01		; $5eb4
	ret			; $5eb6

@substate4:
	ld h,d			; $5eb7
	ld l,Enemy.counter1		; $5eb8
	bit 0,(hl)		; $5eba
	ret z			; $5ebc
	ld (hl),$96		; $5ebd
	ld l,e			; $5ebf
	; back to substate 2
	ld (hl),$02		; $5ec0
	ret			; $5ec2

dragonOnox_mainBody_state3:
dragonOnox_mainBody_state6:
dragonOnox_mainBody_state9:
dragonOnox_mainBody_stateC:
	call _ecom_decCounter1		; $5ec3
	jr nz,@seasonsFunc_0f_5ecb	; $5ec6
	ld l,e			; $5ec8
	inc (hl)		; $5ec9
	ret			; $5eca

@seasonsFunc_0f_5ecb:
	ld l,Enemy.var35		; $5ecb
	ldi a,(hl)		; $5ecd
	; var36
	ld c,(hl)		; $5ece
	ld b,a			; $5ecf
	call seasonsFunc_0f_66aa		; $5ed0
	ret nz			; $5ed3
	jp seasonsFunc_0f_6680		; $5ed4

dragonOnox_mainBody_state4:
	call getRandomNumber_noPreserveVars		; $5ed7
	ld b,a			; $5eda
	call dragonOnoxLowHealthThresholdIntoC		; $5edb
	ld e,Enemy.health		; $5ede
	ld a,(de)		; $5ee0
	cp c			; $5ee1
	ld a,b			; $5ee2
	jr nc,@seasonsFunc_0f_5ee8	; $5ee3
	rrca			; $5ee5
	jr +			; $5ee6

@seasonsFunc_0f_5ee8:
	cp $a0			; $5ee8
+
	ld a,$05		; $5eea
	jr c,+			; $5eec
	ld a,$08		; $5eee
+
	ld e,Enemy.state		; $5ef0
	ld (de),a		; $5ef2
	inc e			; $5ef3
	xor a			; $5ef4
	ld (de),a		; $5ef5
	ld e,Enemy.var37		; $5ef6
	ld (de),a		; $5ef8
	ret			; $5ef9

dragonOnox_mainBody_state5:
	ld h,d			; $5efa
	ld l,Enemy.var37		; $5efb
	bit 0,(hl)		; $5efd
	jr z,+			; $5eff
	ld (hl),$00		; $5f01
	ld l,Enemy.counter2		; $5f03
	ld (hl),$00		; $5f05
+
	inc e			; $5f07
	ld a,(de)		; $5f08
	rst_jumpTable			; $5f09
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $5f12
	ld l,e			; $5f13
	; go to substate1
	inc (hl)		; $5f14
	inc l			; $5f15
	; counter1
	ld (hl),$2d		; $5f16
	inc l			; $5f18
	; counter2
	ld (hl),$04		; $5f19
	ld l,Enemy.speed		; $5f1b
	ld (hl),SPEED_a0		; $5f1d
	ret			; $5f1f

@substate1:
	call _ecom_decCounter1		; $5f20
	jr z,+			; $5f23
	ld a,(w1Link.xh)		; $5f25
	sub $50			; $5f28
	ld c,a			; $5f2a
	ld b,$00		; $5f2b
	jp seasonsFunc_0f_66aa		; $5f2d
+
	ld (hl),$1e		; $5f30
	ld l,e			; $5f32
	inc (hl)		; $5f33
	ld l,Enemy.var30		; $5f34
	ld a,(hl)		; $5f36
	and $01			; $5f37
	add $02			; $5f39
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $5f3b

@substate2:
	call _ecom_decCounter1		; $5f3e
	ret nz			; $5f41
	ld l,e			; $5f42
	inc (hl)		; $5f43
	ld l,Enemy.counter1		; $5f44
	ld (hl),$1e		; $5f46
	ld l,$b0		; $5f48
	ld a,(hl)		; $5f4a
	and $01			; $5f4b
	add $04			; $5f4d
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $5f4f

@substate3:
	call _ecom_decCounter1		; $5f52
	jr z,@seasonsFunc_0f_5f6c	; $5f55
	ld a,(hl)		; $5f57
	cp $14			; $5f58
	ret nz			; $5f5a
	call getFreePartSlot		; $5f5b
	ret nz			; $5f5e
	ld (hl),$33		; $5f5f
	ld bc,$1800		; $5f61
	call objectCopyPositionWithOffset		; $5f64
	ld a,SND_DODONGO_OPEN_MOUTH		; $5f67
	jp playSound		; $5f69

@seasonsFunc_0f_5f6c:
	ld l,Enemy.var30		; $5f6c
	ld a,(hl)		; $5f6e
	and $01			; $5f6f
	add $00			; $5f71
	call dragonOnoxLoadaIntoVar30Andcfc9		; $5f73
	call _ecom_decCounter2		; $5f76
	jp z,seasonsFunc_0f_665c		; $5f79
	; var2f
	dec l			; $5f7c
	ld (hl),$2d		; $5f7d
	; stunCounter
	dec l			; $5f7f
	ld (hl),$01		; $5f80
	ret			; $5f82

dragonOnox_mainBody_state7:
	call dragonOnoxLowHealthThresholdIntoC		; $5f83
	ld e,Enemy.health		; $5f86
	ld a,(de)		; $5f88
	cp c			; $5f89
	ld a,$08		; $5f8a
	jr nc,+			; $5f8c
	ld a,$0b		; $5f8e
+
	ld e,Enemy.state		; $5f90
	; go to state $08 if health is high, else $0b
	; reset state2, and var37
	ld (de),a		; $5f92
	inc e			; $5f93
	xor a			; $5f94
	ld (de),a		; $5f95
	ld e,Enemy.var37		; $5f96
	ld (de),a		; $5f98
	ret			; $5f99

dragonOnox_mainBody_state8:
	inc e			; $5f9a
	ld a,(de)		; $5f9b
	rst_jumpTable			; $5f9c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	ld h,d			; $5fab
	ld l,e			; $5fac
	inc (hl)		; $5fad
	ld l,Enemy.speed		; $5fae
	ld (hl),SPEED_c0		; $5fb0
	ld bc,$20c0		; $5fb2
	ld l,Enemy.xh		; $5fb5
	ld a,(hl)		; $5fb7
	cp $50			; $5fb8
	jr c,+			; $5fba
	ld c,$40		; $5fbc
+
	ld l,Enemy.var35		; $5fbe
	ld (hl),b		; $5fc0
	; var36
	inc l			; $5fc1
	ld (hl),c		; $5fc2
	ret			; $5fc3

@substate1:
	ld h,d			; $5fc4
	ld l,Enemy.var35		; $5fc5
	ld b,(hl)		; $5fc7
	; var36
	inc l			; $5fc8
	ld c,(hl)		; $5fc9
	call seasonsFunc_0f_66aa		; $5fca
	ret nz			; $5fcd
	ld h,d			; $5fce
	ld l,Enemy.state2		; $5fcf
	inc (hl)		; $5fd1
	; counter1
	inc l			; $5fd2
	ld (hl),$1e		; $5fd3
	ld l,Enemy.var36		; $5fd5
	bit 7,(hl)		; $5fd7
	ld a,$09		; $5fd9
	ld bc,ANGLE_RIGHT<<8|$48		; $5fdb
	jr nz,+			; $5fde
	ld a,$08		; $5fe0
	ld bc,ANGLE_LEFT<<8|$b8		; $5fe2
+
	ld (hl),c		; $5fe5
	ld l,Enemy.angle		; $5fe6
	ld (hl),b		; $5fe8
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $5fe9

@substate2:
	call _ecom_decCounter1		; $5fec
	ret nz			; $5fef
	ld l,e			; $5ff0
	inc (hl)		; $5ff1
	ld l,Enemy.speed		; $5ff2
	ld (hl),SPEED_240		; $5ff4
	ld l,Enemy.var36		; $5ff6
	bit 7,(hl)		; $5ff8
	; dragon Onox subid 4
	ld hl,$cfda		; $5ffa
	jr z,+			; $5ffd
	inc l			; $5fff
+
	; choose claw to action
	ld h,(hl)		; $6000
	ld l,Enemy.var30		; $6001
	ld (hl),$02		; $6003
	ld a,SND_DODONGO_OPEN_MOUTH		; $6005
	jp playSound		; $6007

@substate3:
	ld h,d			; $600a
	ld l,Enemy.var36		; $600b
	ld a,($cfcd)		; $600d
	sub (hl)		; $6010
	add $02			; $6011
	cp $05			; $6013
	jp nc,seasonsFunc_0f_650d		; $6015
	ld l,e			; $6018
	inc (hl)		; $6019
	ld l,Enemy.speed		; $601a
	ld (hl),SPEED_c0		; $601c
	ld a,$00		; $601e
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $6020

@substate4:
	call _ecom_decCounter1		; $6023
	ld a,(hl)		; $6026
	and $03			; $6027
	jr nz,+			; $6029
	xor a			; $602b
	call objectNudgeAngleTowards		; $602c
+
	call seasonsFunc_0f_650d		; $602f
	ld a,($cfcc)		; $6032
	cp $d0			; $6035
	ret nz			; $6037
	ld h,d			; $6038
	ld l,Enemy.state2		; $6039
	inc (hl)		; $603b
	inc l			; $603c
	ld (hl),$00		; $603d
	ret			; $603f

@substate5:
	call _ecom_decCounter1		; $6040
	ld bc,$b000		; $6043
	ld a,($cfcd)		; $6046
	or a			; $6049
	jr nz,+			; $604a
	ld l,e			; $604c
	inc (hl)		; $604d
	ret			; $604e
+
	ld l,a			; $604f
	ld a,($cfcc)		; $6050
	ld h,a			; $6053
	ld e,Enemy.counter1		; $6054
	ld a,(de)		; $6056
	and $03			; $6057
	jr nz,+			; $6059
	call seasonsFunc_0f_6529		; $605b
	call objectNudgeAngleTowards		; $605e
+
	jp seasonsFunc_0f_650d		; $6061

@substate6:
	ld hl,$cfcc		; $6064
	inc (hl)		; $6067
	ret nz			; $6068
	ld h,d			; $6069
	jp seasonsFunc_0f_665c		; $606a

dragonOnox_mainBody_stateA:
	call dragonOnoxLowHealthThresholdIntoC		; $606d
	ld e,Enemy.health		; $6070
	ld a,(de)		; $6072
	cp c			; $6073
	ld a,$02		; $6074
	jr nc,+			; $6076
	ld a,$0b		; $6078
+
	; go to state $02 if health is high, else $0b
	ld e,Enemy.state		; $607a
	ld (de),a		; $607c
	inc e			; $607d
	xor a			; $607e
	ld (de),a		; $607f
	ld e,Enemy.var37		; $6080
	ld (de),a		; $6082
	ret			; $6083

dragonOnox_mainBody_stateB:
	ld h,d			; $6084
	ld l,Enemy.var37		; $6085
	bit 0,(hl)		; $6087
	jr z,+			; $6089
	ld l,Enemy.state		; $608b
	inc (hl)		; $608d
	ret			; $608e
+
	inc e			; $608f
	ld a,(de)		; $6090
	rst_jumpTable			; $6091
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld h,d			; $609a
	ld l,e			; $609b
	inc (hl)		; $609c
	ld l,Enemy.speed		; $609d
	ld (hl),SPEED_c0		; $609f
	ret			; $60a1

@substate1:
	ld bc,$f800		; $60a2
	call seasonsFunc_0f_66aa		; $60a5
	ret nz			; $60a8
	ld h,d			; $60a9
	ld l,Enemy.state2		; $60aa
	inc (hl)		; $60ac
	; counter1
	inc l			; $60ad
	ld (hl),$3c		; $60ae
	ld l,Enemy.var30		; $60b0
	ld a,(hl)		; $60b2
	and $01			; $60b3
	add $02			; $60b5
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $60b7

@substate2:
	call _ecom_decCounter1		; $60ba
	jr z,+			; $60bd
	ld a,(hl)		; $60bf
	cp $1e			; $60c0
	ret nz			; $60c2
	ld l,Enemy.var30		; $60c3
	ld a,(hl)		; $60c5
	and $01			; $60c6
	add $04			; $60c8
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $60ca
+
	inc (hl)		; $60cd
	; var38
	inc l			; $60ce
	ld (hl),$18		; $60cf
	ld l,e			; $60d1
	inc (hl)		; $60d2
	call getRandomNumber_noPreserveVars		; $60d3
	and $18			; $60d6
	ld e,Enemy.var33		; $60d8
	ld (de),a		; $60da
	ret			; $60db

@substate3:
	call _ecom_decCounter1		; $60dc
	ret nz			; $60df
	ld (hl),$14		; $60e0
	ld l,Enemy.var33		; $60e2
	ld a,(hl)		; $60e4
	ld hl,@seasonsTable_0f_6116		; $60e5
	rst_addAToHl			; $60e8
	ld c,(hl)		; $60e9
	; fireballs?
	call getFreePartSlot		; $60ea
	ret nz			; $60ed
	ld (hl),$4a		; $60ee
	ld l,Part.var31		; $60f0
	ld (hl),c		; $60f2
	ld bc,$1800		; $60f3
	call objectCopyPositionWithOffset		; $60f6
	ld a,SND_BEAM		; $60f9
	call playSound		; $60fb
	ld e,Enemy.var33		; $60fe
	ld a,(de)		; $6100
	inc a			; $6101
	and $1f			; $6102
	ld (de),a		; $6104
	call _ecom_decCounter2		; $6105
	ret nz			; $6108
	ld l,Enemy.state		; $6109
	inc (hl)		; $610b
	ld l,Enemy.var30		; $610c
	ld a,(hl)		; $610e
	and $01			; $610f
	add $00			; $6111
	jp dragonOnoxLoadaIntoVar30Andcfc9		; $6113

@seasonsTable_0f_6116:
	.db $08 $a0 $18 $90 $28 $80 $38 $70
	.db $48 $60 $58 $50 $68 $40 $78 $30
	.db $88 $20 $98 $10 $00 $50 $30 $70
	.db $10 $90 $40 $60 $20 $80 $08 $98

dragonOnox_mainBody_stateD:
	ld e,Enemy.state		; $6136
	ld a,$02		; $6138
	ld (de),a		; $613a
	inc e			; $613b
	xor a			; $613c
	ld (de),a		; $613d
	ld e,Enemy.var37		; $613e
	ld (de),a		; $6140
	ret			; $6141

dragonOnox_mainBody_stateE:
	; defeated
	inc e			; $6142
	ld a,(de)		; $6143
	rst_jumpTable			; $6144
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d			; $614b
	ld l,e			; $614c
	inc (hl)		; $614d
	; counter1
	inc l			; $614e
	ld (hl),$00		; $614f
	ld l,Enemy.angle		; $6151
	ld (hl),ANGLE_DOWN		; $6153
	ld l,Enemy.speed		; $6155
	ld (hl),$0a		; $6157
	ld l,Enemy.collisionType		; $6159
	res 7,(hl)		; $615b
	; dragon Onox subid 4 - left claw
	ld a,($cfda)		; $615d
	ld h,a			; $6160
	res 7,(hl)		; $6161
	; dragon Onox subid 5 - right claw
	ld a,($cfdb)		; $6163
	ld h,a			; $6166
	res 7,(hl)		; $6167

	ld a,$04		; $6169
	ld ($cfc8),a		; $616b
	ld a,SNDCTRL_STOPMUSIC		; $616e
	call playSound		; $6170
	ld a,($cfcd)		; $6173
	cpl			; $6176
	inc a			; $6177
	ld (wScreenOffsetX),a		; $6178
	ld a,($cfcc)		; $617b
	cpl			; $617e
	inc a			; $617f
	ld (wScreenOffsetY),a		; $6180
	ld a,$08		; $6183
	ld (wTextboxFlags),a		; $6185
	ld a,$04		; $6188
	ld (wTextboxPosition),a		; $618a
	ld bc,TX_501f		; $618d
	jp showTextNonExitable		; $6190

@substate1:
	ld a,$02		; $6193
	ld (de),a		; $6195
	ld a,SND_BIG_EXPLOSION_2		; $6196
	jp playSound		; $6198

@substate2:
	ld a,(wFrameCounter)		; $619b
	and $0f			; $619e
	ld a,SND_RUMBLE		; $61a0
	call z,playSound		; $61a2
	call _ecom_decCounter1		; $61a5
	ld a,(hl)		; $61a8
	and $03			; $61a9
	ld hl,@seasonsTable_0f_61b9		; $61ab
	rst_addAToHl			; $61ae
	ld a,($cfcd)		; $61af
	add (hl)		; $61b2
	ld ($cfcd),a		; $61b3
	jp seasonsFunc_0f_650d		; $61b6

@seasonsTable_0f_61b9:
	.db $fd $06 $fc $01

dragonOnox_leftShoulder:
	ld a,(de)		; $61bd
	rst_jumpTable			; $61be
	.dw @animate
	.dw @offsetBasedOncfca

@animate:
	ld h,d			; $61c3
	ld l,e			; $61c4
	inc (hl)		; $61c5
	ld a,$09		; $61c6
	call enemySetAnimation		; $61c8
	call objectSetVisible83		; $61cb

@offsetBasedOncfca:
	ld a,($cfca)		; $61ce
	cp $08			; $61d1
	ld bc,$603a		; $61d3
	jr c,+			; $61d6
	ld bc,$5238		; $61d8
	jr z,+			; $61db
	ld bc,$6640		; $61dd
+
	; $00-$07	bc = $603a
	; $08		bc = $5238
	; $09+		bc = $6640
	ld e,Enemy.yh		; $61e0
	ld a,($cfcc)		; $61e2
	add b			; $61e5
	ld (de),a		; $61e6

	ld e,Enemy.xh		; $61e7
	ld a,($cfcd)		; $61e9
	add c			; $61ec
	ld (de),a		; $61ed
	ret			; $61ee

dragonOnox_rightShoulder:
	ld a,(de)		; $61ef
	rst_jumpTable			; $61f0
	.dw @animate
	.dw @offsetBasedOncfca

@animate:
	ld h,d			; $61f5
	ld l,e			; $61f6
	inc (hl)		; $61f7
	ld a,$0a		; $61f8
	call enemySetAnimation		; $61fa
	call objectSetVisible83		; $61fd

@offsetBasedOncfca:
	ld a,($cfca)		; $6200
	cp $08			; $6203
	ld bc,$6066		; $6205
	jr c,+			; $6208
	ld bc,$6660		; $620a
	jr z,+			; $620d
	ld bc,$5268		; $620f
+
	; $00-$07	bc = $6066
	; $08		bc = $6660
	; $09+		bc = $5268
	ld e,Enemy.yh		; $6212
	ld a,($cfcc)		; $6214
	add b			; $6217
	ld (de),a		; $6218

	ld e,Enemy.xh		; $6219
	ld a,($cfcd)		; $621b
	add c			; $621e
	ld (de),a		; $621f
	ret			; $6220

dragonOnox_leftClaw:
	ld a,(de)		; $6221
	rst_jumpTable			; $6222
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $622b
	ld l,e			; $622c
	inc (hl)		; $622d
	ld l,Enemy.collisionType		; $622e
	set 7,(hl)		; $6230
	; enemyCollisionMode
	inc l			; $6232
	ld (hl),$65		; $6233
	; collisionRadiusY
	inc l			; $6235
	ld (hl),$05		; $6236
	; collisionRadiusX
	inc l			; $6238
	ld (hl),$09		; $6239
	; damage
	inc l			; $623b
	ld (hl),$fc		; $623c
	ld l,Enemy.relatedObj1+1		; $623e
	; dragon Onox subid 1
	ld a,($cfd7)		; $6240
	ldd (hl),a		; $6243
	ld (hl),$80		; $6244
	ld a,$03		; $6246
	call enemySetAnimation		; $6248
	call objectSetVisible82		; $624b

@state1:
	ld e,Enemy.var30		; $624e
	ld a,(de)		; $6250
	or a			; $6251
	call nz,@seasonsFunc_0f_6277		; $6252
	ld a,$00		; $6255
	call objectGetRelatedObject1Var		; $6257
	ld bc,$30d8		; $625a
	ld a,($cfca)		; $625d
	cp $06			; $6260
	jr c,+			; $6262
	sub $09			; $6264
	jr z,+			; $6266
	ld bc,$18d0		; $6268
	inc a			; $626b
	jr z,+			; $626c
	ld bc,$30e1		; $626e
+
	; $01-$05	bc = $30d8
	; $06-$07	bc = $30e1
	; $08		bc = $18d0
	; $09		bc = $30d8
	call objectTakePositionWithOffset		; $6271
	jp seasonsFunc_0f_6557		; $6274

@seasonsFunc_0f_6277:
	ld h,d			; $6277
	ld l,e			; $6278
	; clear var30
	ld (hl),$00		; $6279
	ld l,Enemy.state		; $627b
	add (hl)		; $627d
	ld (hl),a		; $627e
	; state2
	inc l			; $627f
	ld (hl),$00		; $6280
	; counter1
	inc l			; $6282
	ld (hl),$1e		; $6283
	ld l,Enemy.subid		; $6285
	ld a,(hl)		; $6287
	cp $04			; $6288
	ld a,$d8		; $628a
	jr z,+			; $628c
	ld a,$28		; $628e
+
	ld l,Enemy.var38		; $6290
	ldd (hl),a		; $6292
	; var37
	ld (hl),$30		; $6293
	ret			; $6295

@state2:
	ld a,($cfca)		; $6296
	sub $06			; $6299
	cp $02			; $629b
	jr c,+			; $629d
	call @seasonsFunc_0f_62a5		; $629f
	jp seasonsFunc_0f_6557		; $62a2

@seasonsFunc_0f_62a5:
	inc e			; $62a5
	ld a,(de)		; $62a6
	rst_jumpTable			; $62a7
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
+
	ld a,$00		; $62b6
	call objectGetRelatedObject1Var		; $62b8
	ld e,Enemy.var37		; $62bb
	ld a,(de)		; $62bd
	ld b,a			; $62be
	inc e			; $62bf
	ld a,(de)		; $62c0
	ld c,a			; $62c1
	jp objectTakePositionWithOffset		; $62c2

@@substate0:
	call _ecom_decCounter1		; $62c5
	ret nz			; $62c8
	; counter1 set to $14
	ld (hl),$14		; $62c9
	ld l,e			; $62cb
	inc (hl)		; $62cc
	ld l,Enemy.speed		; $62cd
	ld (hl),SPEED_100		; $62cf
	ld l,Enemy.angle		; $62d1
	ld (hl),ANGLE_UP		; $62d3
	ld l,Enemy.damage		; $62d5
	ld (hl),$f8		; $62d7
	ld a,SND_SWORDSLASH		; $62d9
	jp playSound		; $62db

@@substate1:
	call _ecom_decCounter1		; $62de
	jr nz,+			; $62e1
	ld (hl),$06		; $62e3
	ld l,e			; $62e5
	inc (hl)		; $62e6
	ret			; $62e7
+
	call objectApplySpeed		; $62e8
	jp @@seasonsFunc_0f_6386		; $62eb

@@substate2:
	call _ecom_decCounter1		; $62ee
	jr z,+			; $62f1
	ld a,(hl)		; $62f3
	cp $04			; $62f4
	ret nz			; $62f6
	; counter1 = $04
	ld l,Enemy.var36		; $62f7
	ld a,(w1Link.xh)		; $62f9
	ldd (hl),a		; $62fc
	; var35
	ld (hl),$a5		; $62fd
	ret			; $62ff
+
	ld l,e			; $6300
	inc (hl)		; $6301
	ld l,Enemy.speed		; $6302
	ld (hl),SPEED_300		; $6304
	ld l,Enemy.collisionRadiusX		; $6306
	ld (hl),$0e		; $6308
	ld e,Enemy.subid		; $630a
	ld a,(de)		; $630c
	inc a			; $630d
	jp enemySetAnimation		; $630e

@@substate3:
	ld h,d			; $6311
	ld l,Enemy.var35		; $6312
	call _ecom_readPositionVars		; $6314
	call _ecom_moveTowardPosition		; $6317
	call @@seasonsFunc_0f_6386		; $631a
	ld e,Enemy.yh		; $631d
	ld a,(de)		; $631f
	cp $a0			; $6320
	ret c			; $6322
	ld a,$1e		; $6323
	ld (wScreenShakeCounterY),a		; $6325
	ld h,d			; $6328
	ld l,Enemy.state2		; $6329
	inc (hl)		; $632b
	; counter1
	inc l			; $632c
	ld (hl),$3c		; $632d
	ld a,SND_EXPLOSION		; $632f
	jp playSound		; $6331

@@substate4:
	call _ecom_decCounter1		; $6334
	jr z,+			; $6337
	ld a,(hl)		; $6339
	cp $0a			; $633a
	ret nz			; $633c
	ld l,Enemy.collisionRadiusX		; $633d
	ld (hl),$09		; $633f
	ld e,Enemy.subid		; $6341
	ld a,(de)		; $6343
	dec a			; $6344
	jp enemySetAnimation		; $6345
+
	ld l,e			; $6348
	inc (hl)		; $6349
	ld l,Enemy.speed		; $634a
	ld (hl),SPEED_c0		; $634c
	ret			; $634e

@@substate5:
	ld a,Enemy.yh-Enemy		; $634f
	call objectGetRelatedObject1Var		; $6351
	ldi a,(hl)		; $6354
	add $30			; $6355
	ld b,a			; $6357
	inc l			; $6358
	ld e,Enemy.subid		; $6359
	ld a,(de)		; $635b
	cp $04			; $635c
	ld c,$28		; $635e
	jr z,+			; $6360
	ld c,$78		; $6362
+
	; left claw	c = 28
	; right claw	c = 78
	ld a,(hl)		; $6364
	add c			; $6365
	ld c,a			; $6366
	ld h,d			; $6367
	ldd a,(hl)		; $6368
	add $50			; $6369
	ldh (<hFF8E),a	; $636b
	dec l			; $636d
	ld a,(hl)		; $636e
	ldh (<hFF8F),a	; $636f
	cp b			; $6371
	jr nz,+			; $6372
	ldh a,(<hFF8E)	; $6374
	cp c			; $6376
	jr nz,+			; $6377
	ld l,Enemy.state2		; $6379
	inc (hl)		; $637b
	ret			; $637c
+
	call objectGetRelativeAngleWithTempVars		; $637d
	ld e,Enemy.angle		; $6380
	ld (de),a		; $6382
	call objectApplySpeed		; $6383
@@seasonsFunc_0f_6386:
	ld a,Enemy.yh-Enemy		; $6386
	call objectGetRelatedObject1Var		; $6388
	ld e,l			; $638b
	ld a,(de)		; $638c
	sub (hl)		; $638d
	ld e,Enemy.var37		; $638e
	ld (de),a		; $6390
	ld l,Enemy.xh		; $6391
	ld e,l			; $6393
	ld a,(de)		; $6394
	sub (hl)		; $6395
	ld e,Enemy.var38		; $6396
	ld (de),a		; $6398
	ret			; $6399

@@substate6:
	ld h,d			; $639a
	ld l,Enemy.state		; $639b
	dec (hl)		; $639d
	ld l,Enemy.damage		; $639e
	ld (hl),$fc		; $63a0
	ld a,$06		; $63a2
	call objectGetRelatedObject1Var		; $63a4
	inc (hl)		; $63a7
	ret			; $63a8

@state3:
	inc e			; $63a9
	ld a,(de)		; $63aa
	rst_jumpTable			; $63ab
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d			; $63b0
	ld l,e			; $63b1
	inc (hl)		; $63b2
	ld l,Enemy.collisionRadiusY		; $63b3
	ld (hl),$0e		; $63b5
	; collisionRadiusY
	inc l			; $63b7
	ld (hl),$0a		; $63b8
	ld l,Enemy.damage		; $63ba
	ld (hl),$f8		; $63bc
	ld e,Enemy.subid		; $63be
	ld a,(de)		; $63c0
	add $03			; $63c1
	call enemySetAnimation		; $63c3

@@substate1:
	ld a,($cfca)		; $63c6
	or a			; $63c9
	call z,@@seasonsFunc_0f_63e1		; $63ca
	ld a,$00		; $63cd
	call objectGetRelatedObject1Var		; $63cf
	ld bc,$30d8		; $63d2
	ld e,Enemy.subid		; $63d5
	ld a,(de)		; $63d7
	cp $04			; $63d8
	jr z,+			; $63da
	ld c,$28		; $63dc
+
	jp objectTakePositionWithOffset		; $63de

@@seasonsFunc_0f_63e1:
	ld h,d			; $63e1
	ld l,Enemy.state		; $63e2
	ld (hl),$01		; $63e4
	ld l,Enemy.collisionRadiusY		; $63e6
	ld (hl),$05		; $63e8
	; collisionRadiusX
	inc l			; $63ea
	ld (hl),$09		; $63eb
	ld l,Enemy.damage		; $63ed
	ld (hl),$fc		; $63ef
	ld e,Enemy.subid		; $63f1
	ld a,(de)		; $63f3
	dec a			; $63f4
	jp enemySetAnimation		; $63f5

dragonOnox_rightClaw:
	ld a,(de)		; $63f8
	rst_jumpTable			; $63f9
	.dw @state0
	.dw @state1
	.dw dragonOnox_leftClaw@state2
	.dw dragonOnox_leftClaw@state3

@state0:
	ld h,d			; $6402
	ld l,e			; $6403
	inc (hl)		; $6404
	ld l,Enemy.collisionType		; $6405
	set 7,(hl)		; $6407
	inc l			; $6409
	; enemyCollisionMode
	ld (hl),$65		; $640a
	inc l			; $640c
	; collisionRadiusY
	ld (hl),$05		; $640d
	inc l			; $640f
	; collisionRadiusX
	ld (hl),$09		; $6410
	inc l			; $6412
	; damage
	ld (hl),$fc		; $6413

	ld l,Enemy.relatedObj1+1		; $6415
	; dragon Onox subid 1
	ld a,($cfd7)		; $6417
	ldd (hl),a		; $641a
	ld (hl),$80		; $641b
	ld a,$04		; $641d
	call enemySetAnimation		; $641f
	call objectSetVisible82		; $6422
	jp @state1		; $6425

@state1:
	ld e,Enemy.var30		; $6428
	ld a,(de)		; $642a
	or a			; $642b
	call nz,dragonOnox_leftClaw@seasonsFunc_0f_6277		; $642c
	ld a,Enemy.enabled-Enemy		; $642f
	call objectGetRelatedObject1Var		; $6431
	ld bc,$3028		; $6434
	ld a,($cfca)		; $6437
	cp $06			; $643a
	jr c,+			; $643c
	sub $08			; $643e
	jr z,+			; $6440
	ld bc,$1830		; $6442
	dec a			; $6445
	jr z,+			; $6446
	ld bc,$3031		; $6448
+
	; $00-$05	bc = $3028
	; $06-$07	bc = $3031
	; $08		bc = $3028
	; $09		bc = $1830
	call objectTakePositionWithOffset		; $644b
	jp seasonsFunc_0f_6557		; $644e

dragonOnox_leftClawSphere:
	ld a,(de)		; $6451
	rst_jumpTable			; $6452
	.dw @linkPartsAndAnimate
	.dw @connectParts

@linkPartsAndAnimate:
	ld h,d			; $6457
	ld l,e			; $6458
	; go to state 1
	inc (hl)		; $6459

	ld l,Enemy.relatedObj1+1		; $645a
	; dragon Onox subid 4
	ld a,($cfda)		; $645c
	ldd (hl),a		; $645f
	ld (hl),$80		; $6460

	ld l,Enemy.relatedObj2+1		; $6462
	; dragon Onox subid 2
	ld a,($cfd8)		; $6464
	ldd (hl),a		; $6467
	ld (hl),$80		; $6468

	ld a,$0d		; $646a
	call enemySetAnimation		; $646c
	call objectSetVisible82		; $646f

@connectParts:
	; keeps self 1/4 of the way from relatedObj1 (claw) to relatedObj2 (shoulder)
	call dragonOnoxDistanceToRelatedObjects		; $6472
	ld e,l			; $6475
	sra b			; $6476
	ld a,b			; $6478
	sra b			; $6479
	add b			; $647b
	add (hl)		; $647c
	ld (de),a		; $647d

	ld l,Enemy.xh		; $647e
	ld e,l			; $6480
	sra c			; $6481
	ld a,c			; $6483
	sra c			; $6484
	add c			; $6486
	add (hl)		; $6487
	ld (de),a		; $6488
	ret			; $6489

dragonOnox_rightClawSphere:
	ld a,(de)		; $648a
	rst_jumpTable			; $648b
	.dw @linkPartsAndAnimate
	.dw dragonOnox_leftClawSphere@connectParts

@linkPartsAndAnimate:
	ld h,d			; $6490
	ld l,e			; $6491
	inc (hl)		; $6492
	ld l,Enemy.relatedObj1+1		; $6493
	; dragon Onox subid 5
	ld a,($cfdb)		; $6495
	ldd (hl),a		; $6498
	ld (hl),$80		; $6499
	ld l,Enemy.relatedObj2+1		; $649b
	; dragon Onox subid 3
	ld a,($cfd9)		; $649d
	ldd (hl),a		; $64a0
	ld (hl),$80		; $64a1
	ld a,$0e		; $64a3
	call enemySetAnimation		; $64a5
	call objectSetVisible82		; $64a8
	jr dragonOnox_leftClawSphere@connectParts		; $64ab

dragonOnox_leftShoulderSphere:
	ld a,(de)		; $64ad
	rst_jumpTable			; $64ae
	.dw @linkPartsAndAnimate
	.dw @connectParts

@linkPartsAndAnimate:
	ld h,d			; $64b3
	ld l,e			; $64b4
	inc (hl)		; $64b5

	ld l,Enemy.relatedObj1+1		; $64b6
	; dragon Onox subid 4
	ld a,($cfda)		; $64b8
	ldd (hl),a		; $64bb
	ld (hl),$80		; $64bc

	ld l,Enemy.relatedObj2+1		; $64be
	; dragon Onox subid 2
	ld a,($cfd8)		; $64c0
	ldd (hl),a		; $64c3
	ld (hl),$80		; $64c4

	ld a,$0b		; $64c6
	call enemySetAnimation		; $64c8
	call objectSetVisible82		; $64cb

@connectParts:
	; keeps self 1/3 of the way from relatedObj2 (claw) to relatedObj1 (shoulder)
	call dragonOnoxDistanceToRelatedObjects		; $64ce
	ld e,l			; $64d1
	sra b			; $64d2
	sra b			; $64d4
	ld a,b			; $64d6
	sra b			; $64d7
	add b			; $64d9
	add (hl)		; $64da
	ld (de),a		; $64db

	ld l,Enemy.xh		; $64dc
	ld e,l			; $64de
	sra c			; $64df
	sra c			; $64e1
	ld a,c			; $64e3
	sra c			; $64e4
	add c			; $64e6
	add (hl)		; $64e7
	ld (de),a		; $64e8
	ret			; $64e9

dragonOnox_rightShoulderSphere:
	ld a,(de)		; $64ea
	rst_jumpTable			; $64eb
	.dw @linkPartsAndAnimate
	.dw dragonOnox_leftShoulderSphere@connectParts

@linkPartsAndAnimate:
	ld h,d			; $64f0
	ld l,e			; $64f1
	inc (hl)		; $64f2
	ld l,Enemy.relatedObj1+1		; $64f3
	; dragon Onox subid 5
	ld a,($cfdb)		; $64f5
	ldd (hl),a		; $64f8
	ld (hl),$80		; $64f9
	ld l,Enemy.relatedObj2+1		; $64fb
	; dragon Onox subid 3
	ld a,($cfd9)		; $64fd
	ldd (hl),a		; $6500
	ld (hl),$80		; $6501
	ld a,$0c		; $6503
	call enemySetAnimation		; $6505
	call objectSetVisible82		; $6508
	jr dragonOnox_leftShoulderSphere@connectParts		; $650b

seasonsFunc_0f_650d:
	ld e,Enemy.yh		; $650d
	ld a,($cfcc)		; $650f
	ld (de),a		; $6512
	ld e,Enemy.xh		; $6513
	ld a,($cfcd)		; $6515
	ld (de),a		; $6518
	call objectApplySpeed		; $6519
	ld e,Enemy.yh		; $651c
	ld a,(de)		; $651e
	ld ($cfcc),a		; $651f
	ld e,Enemy.xh		; $6522
	ld a,(de)		; $6524
	ld ($cfcd),a		; $6525
	ret			; $6528

seasonsFunc_0f_6529:
	ld a,h			; $6529
	add $60			; $652a
	ldh (<hFF8F),a	; $652c
	ld a,l			; $652e
	add $50			; $652f
	ldh (<hFF8E),a	; $6531
	ld a,b			; $6533
	add $60			; $6534
	ld b,a			; $6536
	ld a,c			; $6537
	add $50			; $6538
	ld c,a			; $653a
	jp objectGetRelativeAngleWithTempVars		; $653b


; @param[out]	b	relatedObj1.yh - relatedObj2.yh
; @param[out]	c	relatedObj1.xh - relatedObj2.xh
; @param[out]	hl	relatedObj2.yh
dragonOnoxDistanceToRelatedObjects:
	ld a,Enemy.yh-Enemy		; $653e
	call objectGetRelatedObject2Var		; $6540
	push hl			; $6543
	ld b,(hl)		; $6544
	ld l,Enemy.xh		; $6545
	ld c,(hl)		; $6547

	ld a,Enemy.yh-Enemy		; $6548
	call objectGetRelatedObject1Var		; $654a
	ld a,(hl)		; $654d
	sub b			; $654e
	; b now yh delta
	ld b,a			; $654f
	ld l,Enemy.xh		; $6550
	ld a,(hl)		; $6552

	sub c			; $6553
	; c now xh delta
	ld c,a			; $6554

	; now relatedObject2.yh
	pop hl			; $6555
	ret			; $6556

seasonsFunc_0f_6557:
	ld h,d			; $6557
	ld l,Enemy.collisionType		; $6558
	bit 7,(hl)		; $655a
	ret z			; $655c
	ld a,(w1Link.speedZ+1)		; $655d
	rlca			; $6560
	jr c,seasonsFunc_0f_65b7	; $6561
	ld l,Enemy.collisionRadiusX		; $6563
	ld a,(hl)		; $6565
	add $06			; $6566
	ld b,a			; $6568
	add a			; $6569
	inc a			; $656a
	ld c,a			; $656b
	ld l,Enemy.xh		; $656c
	ld a,(w1Link.xh)		; $656e
	sub (hl)		; $6571
	add b			; $6572
	cp c			; $6573
	jr nc,seasonsFunc_0f_65b7	; $6574
	ld l,Enemy.collisionRadiusY		; $6576
	ld a,(w1Link.collisionRadiusY)		; $6578
	add (hl)		; $657b
	add $03			; $657c
	ld b,a			; $657e
	ld e,Enemy.yh		; $657f
	ld a,(de)		; $6581
	sub b			; $6582
	ld c,a			; $6583
	ld a,(w1Link.yh)		; $6584
	sub c			; $6587
	inc a			; $6588
	cp $03			; $6589
	jr nc,seasonsFunc_0f_65b7	; $658b
	ld a,d			; $658d
	ld (wLinkRidingObject),a		; $658e
	ld l,Enemy.var31		; $6591
	bit 0,(hl)		; $6593
	jr nz,+			; $6595
	inc (hl)		; $6597
	call seasonsFunc_0f_65bb		; $6598
+
	ld a,c			; $659b
	ld (w1Link.yh),a		; $659c
	ld l,Enemy.xh		; $659f
	ld a,(hl)		; $65a1
	ld l,Enemy.var33		; $65a2
	sub (hl)		; $65a4
	ld e,a			; $65a5
	ld a,(w1Link.xh)		; $65a6
	add e			; $65a9
	sub $05			; $65aa
	cp Enemy.relatedObj1+1			; $65ac
	jr nc,seasonsFunc_0f_65bb	; $65ae
	add $05			; $65b0
	ld (w1Link.xh),a		; $65b2
	jr seasonsFunc_0f_65bb		; $65b5

seasonsFunc_0f_65b7:
	ld l,Enemy.var31		; $65b7
	ld (hl),$00		; $65b9
seasonsFunc_0f_65bb:
	ld e,Enemy.yh		; $65bb
	ld a,(de)		; $65bd
	ld l,Enemy.var32		; $65be
	ld (hl),a		; $65c0
	ld e,Enemy.xh		; $65c1
	ld a,(de)		; $65c3
	; var33
	inc l			; $65c4
	ld (hl),a		; $65c5
	ret			; $65c6

seasonsFunc_0f_65c7:
	ld a,($cfca)		; $65c7
	and $0e			; $65ca
	ld b,a			; $65cc
	rrca			; $65cd
	add b			; $65ce
	ld hl,seasonsTable_0f_65ed		; $65cf
	rst_addAToHl			; $65d2
	ld e,Enemy.yh		; $65d3
	ld a,($cfcc)		; $65d5
	add (hl)		; $65d8
	ld (de),a		; $65d9
	ld e,Enemy.xh		; $65da
	inc hl			; $65dc
	ld a,($cfcd)		; $65dd
	add (hl)		; $65e0
	ld (de),a		; $65e1
	inc hl			; $65e2
	ld e,Enemy.direction		; $65e3
	ld a,(de)		; $65e5
	cp (hl)			; $65e6
	ret z			; $65e7
	ld a,(hl)		; $65e8
	ld (de),a		; $65e9
	jp enemySetAnimation		; $65ea

seasonsTable_0f_65ed:
	.db $48 $50 $00
	.db $41 $50 $01
	.db $41 $50 $01
	.db $41 $47 $02
	.db $48 $50 $00

seasonsFunc_0f_65fc:
	ld h,d			; $65fc
	ld l,Enemy.var31		; $65fd
	dec (hl)		; $65ff
	ld e,Enemy.invincibilityCounter		; $6600
	jr nz,++		; $6602
	ld a,(de)		; $6604
	or a			; $6605
	ld b,$14		; $6606
	jr z,+			; $6608
	ld b,$06		; $660a
+
	ld (hl),b		; $660c
	ld e,Enemy.var30		; $660d
	ld a,(de)		; $660f
	cp $08			; $6610
	jr nc,+			; $6612
	xor $01			; $6614
	ld (de),a		; $6616
+
	or $80			; $6617
	ld ($cfc9),a		; $6619
++
	; Enemy.var32
	inc l			; $661c
	dec (hl)		; $661d
	ret nz			; $661e
	ld a,(de)		; $661f
	or a			; $6620
	ld b,$0c		; $6621
	jr z,+			; $6623
	ld b,$04		; $6625
+
	ld (hl),b		; $6627
	ld a,($cfcb)		; $6628
	inc a			; $662b
	cp $06			; $662c
	jr c,+			; $662e
	xor a			; $6630
+
	or $80			; $6631
	ld ($cfcb),a		; $6633
	ret			; $6636

seasonsFunc_0f_6637:
	; var33 - += var34 % 8
	; var34 - n/a
	; var35 - 1st value in table below, indexed by var33
	; var36 - 2nd value in table below, indexed by var33
	ld l,Enemy.var34		; $6637
	ld e,Enemy.var33		; $6639
	ld a,(de)		; $663b
	add (hl)		; $663c
	and $07			; $663d
	ld (de),a		; $663f
	ld hl,seasonsTable_0f_664c		; $6640
	rst_addDoubleIndex			; $6643
	ld e,Enemy.var35		; $6644
	ldi a,(hl)		; $6646
	ld (de),a		; $6647
	; var36
	inc e			; $6648
	ld a,(hl)		; $6649
	ld (de),a		; $664a
	ret			; $664b

seasonsTable_0f_664c:
	.db $00 $00
	.db $f8 $10
	.db $00 $20
	.db $08 $10
	.db $00 $00
	.db $f8 $f0
	.db $00 $e0
	.db $08 $f0

seasonsFunc_0f_665c:
	ld l,Enemy.state		; $665c
	inc (hl)		; $665e
	ld l,Enemy.var33		; $665f
	ld (hl),$ff		; $6661
	ld l,Enemy.speed		; $6663
	ld (hl),SPEED_80		; $6665
	call seasonsFunc_0f_6680		; $6667
	call getRandomNumber_noPreserveVars		; $666a
	and $07			; $666d
	ld hl,seasonsTable_0f_6678		; $666f
	rst_addAToHl			; $6672
	ld e,Enemy.counter1		; $6673
	ld a,(hl)		; $6675
	ld (de),a		; $6676
	ret			; $6677

seasonsTable_0f_6678:
	.db $1e
	.db $3c
	.db $3c
	.db $5a
	.db $5a
	.db $5a
	.db $78
	.db $78

seasonsFunc_0f_6680:
	call getRandomNumber_noPreserveVars		; $6680
	and $07			; $6683
	ld b,a			; $6685
	ld e,Enemy.var33		; $6686
	ld a,(de)		; $6688
	cp b			; $6689
	jr z,seasonsFunc_0f_6680	; $668a
	ld a,b			; $668c
	ld (de),a		; $668d
	ld hl,seasonsTable_0f_669a		; $668e
	rst_addDoubleIndex			; $6691
	ld e,Enemy.var35		; $6692
	ldi a,(hl)		; $6694
	ld (de),a		; $6695
	; var36
	inc e			; $6696
	ld a,(hl)		; $6697
	ld (de),a		; $6698
	ret			; $6699

seasonsTable_0f_669a:
	.db $f8 $f0
	.db $08 $f0
	.db $f8 $fc
	.db $08 $fc
	.db $f8 $04
	.db $08 $04
	.db $f8 $10
	.db $08 $10

seasonsFunc_0f_66aa:
	ld a,($cfcc)		; $66aa
	ld h,a			; $66ad
	ld a,($cfcd)		; $66ae
	ld l,a			; $66b1
	cp c			; $66b2
	jr nz,+			; $66b3
	ld a,h			; $66b5
	cp b			; $66b6
	ret z			; $66b7
+
	call seasonsFunc_0f_6529		; $66b8
	ld e,Enemy.angle		; $66bb
	ld (de),a		; $66bd
	call seasonsFunc_0f_650d		; $66be
	or d			; $66c1
	ret			; $66c2

dragonOnoxLoadaIntoVar30Andcfc9:
	ld e,Enemy.var30		; $66c3
	ld (de),a		; $66c5
	or $80			; $66c6
	ld ($cfc9),a		; $66c8
	ret			; $66cb

dragonOnoxLowHealthThresholdIntoC:
	call checkIsLinkedGame		; $66cc
	ld c,$11		; $66cf
	ret z			; $66d1
	ld c,$18		; $66d2
	ret			; $66d4

; ==============================================================================
; ENEMYID_GLEEOK
; ==============================================================================
enemyCode06:
	jr z,_label_0f_219	; $66d5
	sub $03			; $66d7
	ret c			; $66d9
	jr nz,_label_0f_219	; $66da
	ld e,$82		; $66dc
	ld a,(de)		; $66de
	dec a			; $66df
	jp z,_enemyBoss_dead		; $66e0
	ld e,$a4		; $66e3
	ld a,(de)		; $66e5
	or a			; $66e6
	jp z,enemyDie_uncounted_withoutItemDrop		; $66e7
	ld e,$82		; $66ea
	ld a,(de)		; $66ec
	cp $02			; $66ed
	ld b,$02		; $66ef
	jr z,_label_0f_217	; $66f1
	ld b,$04		; $66f3
_label_0f_217:
	ld a,$38		; $66f5
	call objectGetRelatedObject1Var		; $66f7
	ld a,(hl)		; $66fa
	or b			; $66fb
	ld (hl),a		; $66fc
	ld e,$84		; $66fd
	ld a,(de)		; $66ff
	cp $0b			; $6700
	jr nz,_label_0f_218	; $6702
	ld e,$83		; $6704
	ld a,(de)		; $6706
	cp $03			; $6707
	jr nc,_label_0f_218	; $6709
	ld e,$82		; $670b
	ld a,(de)		; $670d
	xor $01			; $670e
	add $ae			; $6710
	ld l,a			; $6712
	ld h,(hl)		; $6713
	ld l,$84		; $6714
	ld a,(hl)		; $6716
	cp $0b			; $6717
	jr nz,_label_0f_218	; $6719
	inc (hl)		; $671b
_label_0f_218:
	ld h,d			; $671c
	ld l,$84		; $671d
	ld (hl),$0e		; $671f
	ld l,$a4		; $6721
	set 7,(hl)		; $6723
	inc l			; $6725
	ld (hl),$04		; $6726
	ld l,$a9		; $6728
	ld (hl),$19		; $672a
	ld l,$ac		; $672c
	ld a,(hl)		; $672e
	ld l,$89		; $672f
	ld (hl),a		; $6731
	ld l,$90		; $6732
	ld (hl),$50		; $6734
	ld l,$86		; $6736
	ld (hl),$96		; $6738
	xor a			; $673a
	jp enemySetAnimation		; $673b
_label_0f_219:
	call _ecom_getSubidAndCpStateTo08		; $673e
	jr nc,_label_0f_220	; $6741
	rst_jumpTable			; $6743
	ld l,c			; $6744
	ld h,a			; $6745
	ld a,l			; $6746
	ld h,a			; $6747
	xor c			; $6748
	ld h,a			; $6749
	xor c			; $674a
	ld h,a			; $674b
	xor c			; $674c
	ld h,a			; $674d
	xor c			; $674e
	ld h,a			; $674f
	xor c			; $6750
	ld h,a			; $6751
	xor c			; $6752
	ld h,a			; $6753
_label_0f_220:
	dec b			; $6754
	ld a,b			; $6755
	rst_jumpTable			; $6756
	xor d			; $6757
	ld h,a			; $6758
	adc $68			; $6759
	ld d,l			; $675b
	ld l,e			; $675c
	ld a,d			; $675d
	ld l,e			; $675e
	ld a,d			; $675f
	ld l,e			; $6760
	add sp,$6b		; $6761
	add sp,$6b		; $6763
	dec hl			; $6765
	ld l,h			; $6766
	dec hl			; $6767
	ld l,h			; $6768
	ld a,b			; $6769
	or a			; $676a
	jp z,$6774		; $676b
	call _ecom_setSpeedAndState8AndVisible		; $676e
	jp $6c6b		; $6771
	inc a			; $6774
	ld (de),a		; $6775
	ld a,$06		; $6776
	ld b,$87		; $6778
	call _enemyBoss_initializeRoom		; $677a
	ld b,$09		; $677d
	call checkBEnemySlotsAvailable		; $677f
	ret nz			; $6782
	ld b,$06		; $6783
	call _ecom_spawnUncountedEnemyWithSubid01		; $6785
	ld l,$80		; $6788
	ld e,l			; $678a
	ld a,(de)		; $678b
	ld (hl),a		; $678c
	ld l,$b0		; $678d
	ld c,h			; $678f
	ld e,$08		; $6790
_label_0f_221:
	push hl			; $6792
	call _ecom_spawnUncountedEnemyWithSubid01		; $6793
	ld a,$0a		; $6796
	sub e			; $6798
	ld (hl),a		; $6799
	ld l,$96		; $679a
	ld a,$80		; $679c
	ldi (hl),a		; $679e
	ld (hl),c		; $679f
	ld a,h			; $67a0
	pop hl			; $67a1
	ldi (hl),a		; $67a2
	dec e			; $67a3
	jr nz,_label_0f_221	; $67a4
	jp enemyDelete		; $67a6
	ret			; $67a9
	ld a,(de)		; $67aa
	sub $08			; $67ab
	rst_jumpTable			; $67ad
	ret nz			; $67ae
	ld h,a			; $67af
	ret nc			; $67b0
	ld h,a			; $67b1
	inc c			; $67b2
	ld l,b			; $67b3
	jr z,_label_0f_222	; $67b4
	ccf			; $67b6
	ld l,b			; $67b7
	ld d,(hl)		; $67b8
	ld l,b			; $67b9
	ld (hl),b		; $67ba
	ld l,b			; $67bb
	sub e			; $67bc
	ld l,b			; $67bd
	cp d			; $67be
	ld l,b			; $67bf
	ld a,(wcc93)		; $67c0
	or a			; $67c3
	ret nz			; $67c4
	ld h,d			; $67c5
	ld l,e			; $67c6
	inc (hl)		; $67c7
	ld a,$2e		; $67c8
	ld (wActiveMusic),a		; $67ca
	jp playSound		; $67cd
	ld e,$b8		; $67d0
	ld a,(de)		; $67d2
	bit 1,a			; $67d3
	jr z,_label_0f_224	; $67d5
	bit 2,a			; $67d7
	jr z,_label_0f_224	; $67d9
	ld h,d			; $67db
	ld l,$84		; $67dc
	inc (hl)		; $67de
	ld l,$87		; $67df
	ld (hl),$3c		; $67e1
	ld e,$b0		; $67e3
	ld a,(de)		; $67e5
	ld h,a			; $67e6
	ld l,$a9		; $67e7
	xor a			; $67e9
	ld (hl),a		; $67ea
	ld l,$a4		; $67eb
	ld (hl),a		; $67ed
	inc e			; $67ee
	ld a,(de)		; $67ef
	ld h,a			; $67f0
	xor a			; $67f1
	ld (hl),a		; $67f2
	ld l,$a9		; $67f3
	ld (hl),a		; $67f5
	ld hl,$ce16		; $67f6
	xor a			; $67f9
	ldi (hl),a		; $67fa
	ldi (hl),a		; $67fb
	ld (hl),a		; $67fc
	ld l,$26		; $67fd
	ldi (hl),a		; $67ff
	ldi (hl),a		; $6800
	ld (hl),a		; $6801
	ld a,$67		; $6802
	call playSound		; $6804
	ld a,$f0		; $6807
	jp playSound		; $6809
	call _ecom_decCounter2		; $680c
	jp nz,_ecom_flickerVisibility		; $680f
	ld bc,$020c		; $6812
	call _enemyBoss_spawnShadow		; $6815
	jp nz,_ecom_flickerVisibility		; $6818
	ld h,d			; $681b
	ld l,$84		; $681c
_label_0f_222:
	inc (hl)		; $681e
	ld l,$86		; $681f
	ld (hl),$1e		; $6821
	ld a,$04		; $6823
	call enemySetAnimation		; $6825
	call _ecom_decCounter1		; $6828
	jp nz,_ecom_flickerVisibility		; $682b
	inc (hl)		; $682e
	ld l,e			; $682f
	inc (hl)		; $6830
	ld l,$a4		; $6831
	set 7,(hl)		; $6833
	ld a,$2e		; $6835
	ld (wActiveMusic),a		; $6837
	call playSound		; $683a
	ld e,$84		; $683d
	call _ecom_decCounter1		; $683f
	jr nz,_label_0f_223	; $6842
	ld l,e			; $6844
	inc (hl)		; $6845
	ld bc,$fdc0		; $6846
	call objectSetSpeedZ		; $6849
	jp objectSetVisible81		; $684c
_label_0f_223:
	ld a,(hl)		; $684f
	cp $0a			; $6850
	ret c			; $6852
_label_0f_224:
	jp enemyAnimate		; $6853
	ld c,$20		; $6856
	call objectUpdateSpeedZ_paramC		; $6858
	ret nz			; $685b
	ld l,$84		; $685c
	inc (hl)		; $685e
	ld l,$86		; $685f
	ld (hl),$96		; $6861
	ld a,$78		; $6863
	call setScreenShakeCounter		; $6865
	call objectSetVisible82		; $6868
	ld a,$81		; $686b
	jp playSound		; $686d
	call _ecom_decCounter1		; $6870
	jr z,_label_0f_225	; $6873
	ld a,(hl)		; $6875
	cp $87			; $6876
	jr c,_label_0f_224	; $6878
	ld a,($d00f)		; $687a
	rlca			; $687d
	ret c			; $687e
	ld hl,$cc6a		; $687f
	ld a,$14		; $6882
	ldi (hl),a		; $6884
	ld (hl),$00		; $6885
	ret			; $6887
_label_0f_225:
	ld l,e			; $6888
	inc (hl)		; $6889
	ld l,$90		; $688a
	ld (hl),$50		; $688c
	call _ecom_updateAngleTowardTarget		; $688e
	jr _label_0f_224		; $6891
	ld a,$01		; $6893
	call _ecom_getSideviewAdjacentWallsBitset		; $6895
	jr nz,_label_0f_226	; $6898
	call objectApplySpeed		; $689a
	jr _label_0f_224		; $689d
_label_0f_226:
	ld a,$28		; $689f
	call setScreenShakeCounter		; $68a1
	ld h,d			; $68a4
	ld l,$84		; $68a5
	inc (hl)		; $68a7
	ld l,$90		; $68a8
	ld (hl),$14		; $68aa
	ld l,$89		; $68ac
	ld a,(hl)		; $68ae
	xor $10			; $68af
	ld (hl),a		; $68b1
	ld bc,$fe80		; $68b2
	call objectSetSpeedZ		; $68b5
	jr _label_0f_224		; $68b8
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $68ba
	ld c,$20		; $68bd
	call objectUpdateSpeedZ_paramC		; $68bf
	jr nz,_label_0f_224	; $68c2
	ld l,$84		; $68c4
	ld (hl),$0c		; $68c6
	ld l,$86		; $68c8
	ld (hl),$3c		; $68ca
	jr _label_0f_224		; $68cc
	ld a,(de)		; $68ce
	sub $08			; $68cf
	rst_jumpTable			; $68d1
	.dw $68e6
	.dw $68fa
	.dw $6903
	.dw $6959
	.dw $6aa7
	.dw $6ac1
	.dw $6aca
	.dw $6ae1
	.dw $68fa
	.dw $6b30
	ld h,d			; $68e6
	ld l,$89		; $68e7
	ld (hl),$14		; $68e9
	ld l,e			; $68eb
	inc (hl)		; $68ec
	ld l,$a4		; $68ed
	set 7,(hl)		; $68ef
	ld l,$86		; $68f1
	ld (hl),$3c		; $68f3
	ld l,$90		; $68f5
	ld (hl),$14		; $68f7
	ret			; $68f9
	call _ecom_decCounter1		; $68fa
	jp nz,objectApplySpeed		; $68fd
	ld l,e			; $6900
	inc (hl)		; $6901
	ret			; $6902
	ld b,$04		; $6903
	ld a,$38		; $6905
	call objectGetRelatedObject1Var		; $6907
	ld a,(hl)		; $690a
	and b			; $690b
	ld c,$03		; $690c
	ld l,$b8		; $690e
	jr nz,_label_0f_227	; $6910
	bit 0,(hl)		; $6912
	jr nz,_label_0f_228	; $6914
	ld e,$82		; $6916
	ld a,(de)		; $6918
	cp $03			; $6919
	jr z,_label_0f_227	; $691b
	ld b,h			; $691d
	ld l,$b1		; $691e
	ld h,(hl)		; $6920
	ld l,$84		; $6921
	ld a,(hl)		; $6923
	cp $10			; $6924
	ld h,b			; $6926
	jr nc,_label_0f_227	; $6927
	ldh a,(<hEnemyTargetX)	; $6929
	cp $78			; $692b
	jr nc,_label_0f_228	; $692d
_label_0f_227:
	ld l,$b8		; $692f
	set 0,(hl)		; $6931
	ld c,$00		; $6933
_label_0f_228:
	ldh a,(<hEnemyTargetY)	; $6935
	cp $58			; $6937
	ld b,$00		; $6939
	jr c,_label_0f_229	; $693b
	ld b,$02		; $693d
	sub $70			; $693f
	cp $40			; $6941
	jr c,_label_0f_229	; $6943
	call getRandomNumber		; $6945
	and $01			; $6948
	inc a			; $694a
	ld b,a			; $694b
_label_0f_229:
	ld h,d			; $694c
	ld l,$83		; $694d
	ld a,c			; $694f
	add b			; $6950
	ld (hl),a		; $6951
	ld l,$84		; $6952
	inc (hl)		; $6954
	inc l			; $6955
	ld (hl),$00		; $6956
	ret			; $6958
	ld e,$83		; $6959
	ld a,(de)		; $695b
	ld e,$85		; $695c
	rst_jumpTable			; $695e
	ld l,e			; $695f
	ld l,c			; $6960
	ld ($ff00+c),a		; $6961
	ld l,c			; $6962
	ld e,h			; $6963
	ld l,d			; $6964
	adc a			; $6965
	ld l,d			; $6966
	sub (hl)		; $6967
	ld l,d			; $6968
	sub (hl)		; $6969
	ld l,d			; $696a
	ld a,(de)		; $696b
	rst_jumpTable			; $696c
	ld (hl),e		; $696d
	ld l,c			; $696e
	sub a			; $696f
	ld l,c			; $6970
	and d			; $6971
	ld l,c			; $6972
	ld bc,$3a60		; $6973
	ld h,d			; $6976
	ld l,$82		; $6977
	ld a,(hl)		; $6979
	cp $02			; $697a
	jr z,_label_0f_230	; $697c
	ld c,$90		; $697e
_label_0f_230:
	ld l,$8b		; $6980
	ldi a,(hl)		; $6982
	ldh (<hFF8F),a	; $6983
	inc l			; $6985
	ld a,(hl)		; $6986
	ldh (<hFF8E),a	; $6987
	cp c			; $6989
	jr nz,_label_0f_231	; $698a
	ldh a,(<hFF8F)	; $698c
	cp b			; $698e
	jr z,_label_0f_232	; $698f
_label_0f_231:
	jp _ecom_moveTowardPosition		; $6991
_label_0f_232:
	ld l,e			; $6994
	inc (hl)		; $6995
	ret			; $6996
	ld h,d			; $6997
	ld l,e			; $6998
	inc (hl)		; $6999
	inc l			; $699a
	ld (hl),$1e		; $699b
	ld a,$01		; $699d
	jp enemySetAnimation		; $699f
	call _ecom_decCounter1		; $69a2
	jr z,_label_0f_233	; $69a5
	ld a,(hl)		; $69a7
	cp $08			; $69a8
	ret nz			; $69aa
	ld l,$8b		; $69ab
	ld a,(hl)		; $69ad
	sub $04			; $69ae
	ld (hl),a		; $69b0
	ld b,$43		; $69b1
	jp _ecom_spawnProjectile		; $69b3
_label_0f_233:
	ld l,$8b		; $69b6
	ld a,(hl)		; $69b8
	add $04			; $69b9
	ld (hl),a		; $69bb
_label_0f_234:
	ld a,$38		; $69bc
	call objectGetRelatedObject1Var		; $69be
	res 0,(hl)		; $69c1
	ld e,$82		; $69c3
	ld a,(de)		; $69c5
	sub $02			; $69c6
	xor $01			; $69c8
	add $b0			; $69ca
	ld l,a			; $69cc
	ld h,(hl)		; $69cd
	ld l,$84		; $69ce
	ld a,(hl)		; $69d0
	cp $0b			; $69d1
	jr nz,_label_0f_235	; $69d3
	inc (hl)		; $69d5
_label_0f_235:
	ld h,d			; $69d6
	ld e,l			; $69d7
	inc (hl)		; $69d8
	ld l,$82		; $69d9
	ld a,(hl)		; $69db
	cp $02			; $69dc
	ret nz			; $69de
	jp $6aa7		; $69df
	ld a,(de)		; $69e2
	rst_jumpTable			; $69e3
	ld ($f669),a		; $69e4
	ld l,c			; $69e7
	rlca			; $69e8
	ld l,d			; $69e9
	ld h,d			; $69ea
	ld l,e			; $69eb
	inc (hl)		; $69ec
	ld l,$86		; $69ed
	ld (hl),$28		; $69ef
	ld a,$01		; $69f1
	jp enemySetAnimation		; $69f3
	call _ecom_decCounter1		; $69f6
	ret nz			; $69f9
	ld (hl),$41		; $69fa
	ld l,e			; $69fc
	inc (hl)		; $69fd
	ld l,$b9		; $69fe
	ldh a,(<hEnemyTargetY)	; $6a00
	ldi (hl),a		; $6a02
	ldh a,(<hEnemyTargetX)	; $6a03
	ld (hl),a		; $6a05
	ret			; $6a06
	call _ecom_decCounter1		; $6a07
	jr z,_label_0f_234	; $6a0a
	ld a,(hl)		; $6a0c
	and $0f			; $6a0d
	jr z,_label_0f_236	; $6a0f
	cp $08			; $6a11
	ret nz			; $6a13
	ld l,$8b		; $6a14
	ld a,(hl)		; $6a16
	add $02			; $6a17
	ld (hl),a		; $6a19
	ret			; $6a1a
_label_0f_236:
	ld l,$8b		; $6a1b
	ld a,(hl)		; $6a1d
	sub $02			; $6a1e
	ld (hl),a		; $6a20
	call getFreePartSlot		; $6a21
	ret nz			; $6a24
	ld (hl),$43		; $6a25
	inc l			; $6a27
	inc (hl)		; $6a28
	ld e,$86		; $6a29
	ld a,(de)		; $6a2b
	and $30			; $6a2c
	swap a			; $6a2e
	ld bc,$6a54		; $6a30
	call addDoubleIndexToBc		; $6a33
	ld e,$b9		; $6a36
	ld a,(de)		; $6a38
	ld e,a			; $6a39
	ld a,(bc)		; $6a3a
	add e			; $6a3b
	ld l,$cb		; $6a3c
	ldi (hl),a		; $6a3e
	inc l			; $6a3f
	inc bc			; $6a40
	ld e,$ba		; $6a41
	ld a,(de)		; $6a43
	ld e,a			; $6a44
	ld a,(bc)		; $6a45
	add e			; $6a46
	ldi (hl),a		; $6a47
	call getFreeInteractionSlot		; $6a48
	ret nz			; $6a4b
	ld (hl),$05		; $6a4c
	ld bc,$0800		; $6a4e
	jp objectCopyPositionWithOffset		; $6a51
.DB $ec				; $6a54
	nop			; $6a55
	nop			; $6a56
.DB $ec				; $6a57
	nop			; $6a58
	inc d			; $6a59
	inc d			; $6a5a
	nop			; $6a5b
	ld a,(de)		; $6a5c
	rst_jumpTable			; $6a5d
	ld h,h			; $6a5e
	ld l,d			; $6a5f
	ld (hl),d		; $6a60
	ld l,d			; $6a61
	ld a,c			; $6a62
	ld l,d			; $6a63
	ld h,d			; $6a64
	ld l,e			; $6a65
	inc (hl)		; $6a66
	inc l			; $6a67
	ld (hl),$08		; $6a68
	inc l			; $6a6a
	ld (hl),$02		; $6a6b
	ld a,$01		; $6a6d
	jp enemySetAnimation		; $6a6f
	call _ecom_decCounter1		; $6a72
	ret nz			; $6a75
	ld l,e			; $6a76
	inc (hl)		; $6a77
	ret			; $6a78
	ld b,$43		; $6a79
	call _ecom_spawnProjectile		; $6a7b
	ret nz			; $6a7e
	ld l,$c2		; $6a7f
	ld (hl),$02		; $6a81
	call _ecom_decCounter2		; $6a83
	jp z,$69bc		; $6a86
	dec l			; $6a89
	ld (hl),$14		; $6a8a
	dec l			; $6a8c
	dec (hl)		; $6a8d
	ret			; $6a8e
	ld a,(de)		; $6a8f
	rst_jumpTable			; $6a90
	ld (hl),e		; $6a91
	ld l,c			; $6a92
	sub l			; $6a93
	ld l,d			; $6a94
	ret			; $6a95
_label_0f_237:
	call $6a9f		; $6a96
	call z,$6cf6		; $6a99
	jp objectApplySpeed		; $6a9c
	ld h,d			; $6a9f
	ld l,$b1		; $6aa0
	ld a,(hl)		; $6aa2
	or a			; $6aa3
	ret z			; $6aa4
	dec (hl)		; $6aa5
	ret			; $6aa6
	ld h,d			; $6aa7
	ld l,e			; $6aa8
	inc (hl)		; $6aa9
	ld l,$87		; $6aaa
	ld (hl),$78		; $6aac
	ld l,$83		; $6aae
	ld a,(hl)		; $6ab0
	or a			; $6ab1
	jr z,_label_0f_238	; $6ab2
	cp $03			; $6ab4
	jr nz,_label_0f_239	; $6ab6
_label_0f_238:
	ld l,$b0		; $6ab8
	xor a			; $6aba
	ldi (hl),a		; $6abb
	ld (hl),a		; $6abc
_label_0f_239:
	xor a			; $6abd
	jp enemySetAnimation		; $6abe
	call _ecom_decCounter2		; $6ac1
	jr nz,_label_0f_237	; $6ac4
	ld l,e			; $6ac6
	ld (hl),$0a		; $6ac7
	ret			; $6ac9
	ld a,(wFrameCounter)		; $6aca
	rrca			; $6acd
	jr c,_label_0f_240	; $6ace
	call _ecom_decCounter1		; $6ad0
	jr nz,_label_0f_240	; $6ad3
	ld l,e			; $6ad5
	inc (hl)		; $6ad6
	ld l,$90		; $6ad7
	ld (hl),$28		; $6ad9
_label_0f_240:
	call objectApplySpeed		; $6adb
	jp _ecom_bounceOffScreenBoundary		; $6ade
	ld h,d			; $6ae1
	ld l,$82		; $6ae2
	ld a,(hl)		; $6ae4
	cp $02			; $6ae5
	ld bc,$2476		; $6ae7
	jr z,_label_0f_241	; $6aea
	ld c,$7a		; $6aec
_label_0f_241:
	ld l,$8b		; $6aee
	ldi a,(hl)		; $6af0
	ldh (<hFF8F),a	; $6af1
	inc l			; $6af3
	ld a,(hl)		; $6af4
	ldh (<hFF8E),a	; $6af5
	cp c			; $6af7
	jr nz,_label_0f_242	; $6af8
	ldh a,(<hFF8F)	; $6afa
	cp b			; $6afc
	jr z,_label_0f_243	; $6afd
_label_0f_242:
	jp _ecom_moveTowardPosition		; $6aff
_label_0f_243:
	ld l,e			; $6b02
	inc (hl)		; $6b03
	ld l,$a5		; $6b04
	ld (hl),$0d		; $6b06
	ld l,$90		; $6b08
	ld (hl),$14		; $6b0a
	ld l,$86		; $6b0c
	ld (hl),$3c		; $6b0e
	ld l,$b0		; $6b10
	xor a			; $6b12
	ldi (hl),a		; $6b13
	ld (hl),a		; $6b14
	ld l,$82		; $6b15
	ld a,(hl)		; $6b17
	cp $02			; $6b18
	ld a,$14		; $6b1a
	ld b,$02		; $6b1c
	jr z,_label_0f_244	; $6b1e
	ld a,$0c		; $6b20
	ld b,$04		; $6b22
_label_0f_244:
	ld l,$89		; $6b24
	ld (hl),a		; $6b26
	ld a,$38		; $6b27
	call objectGetRelatedObject1Var		; $6b29
	ld a,(hl)		; $6b2c
	xor b			; $6b2d
	ld (hl),a		; $6b2e
	ret			; $6b2f
	ld e,$82		; $6b30
	ld a,(de)		; $6b32
	sub $02			; $6b33
	xor $01			; $6b35
	add $30			; $6b37
	call objectGetRelatedObject1Var		; $6b39
	ld h,(hl)		; $6b3c
	ld l,$84		; $6b3d
	ld a,(hl)		; $6b3f
	cp $0e			; $6b40
	jr nc,_label_0f_245	; $6b42
	cp $0a			; $6b44
	jp nz,_label_0f_237		; $6b46
_label_0f_245:
	ld h,d			; $6b49
	ld (hl),$0a		; $6b4a
	ld l,$82		; $6b4c
	ld a,(hl)		; $6b4e
	cp $02			; $6b4f
	ret nz			; $6b51
	jp $6903		; $6b52
	ld a,(de)		; $6b55
	sub $08			; $6b56
	rst_jumpTable			; $6b58
	.dw $6b6d
	.dw $68fa
	.dw $6b75
	.dw $6959
	.dw $6aa7
	.dw $6ac1
	.dw $6aca
	.dw $6ae1
	.dw $68fa
	.dw $6b30
	ld h,d			; $6b6d
	ld l,$89		; $6b6e
	ld (hl),$0c		; $6b70
	jp $68eb		; $6b72
	ld b,$02		; $6b75
	jp $6905		; $6b77
	ld a,(de)		; $6b7a
	sub $08			; $6b7b
	rst_jumpTable			; $6b7d
	add h			; $6b7e
	ld l,e			; $6b7f
	sbc l			; $6b80
	ld l,e			; $6b81
	cp a			; $6b82
	ld l,e			; $6b83
	ld h,d			; $6b84
	ld l,e			; $6b85
	inc (hl)		; $6b86
	ld l,$a5		; $6b87
	ld (hl),$04		; $6b89
	ld e,$82		; $6b8b
	ld a,(de)		; $6b8d
	sub $04			; $6b8e
	add $30			; $6b90
	call objectGetRelatedObject1Var		; $6b92
	ld e,$99		; $6b95
	ld a,(hl)		; $6b97
	ld (de),a		; $6b98
	dec e			; $6b99
	ld a,$80		; $6b9a
	ld (de),a		; $6b9c
	call $6cb2		; $6b9d
	call $6cbf		; $6ba0
	ret nz			; $6ba3
	ld e,$8b		; $6ba4
	ld a,b			; $6ba6
	add a			; $6ba7
	add b			; $6ba8
	add $24			; $6ba9
	ld (de),a		; $6bab
	ld e,$82		; $6bac
	ld a,(de)		; $6bae
	cp $04			; $6baf
	ld b,$76		; $6bb1
	jr z,_label_0f_246	; $6bb3
	ld b,$7a		; $6bb5
_label_0f_246:
	ld a,c			; $6bb7
	add a			; $6bb8
	add c			; $6bb9
	add b			; $6bba
	ld e,$8d		; $6bbb
	ld (de),a		; $6bbd
	ret			; $6bbe
	call $6cb2		; $6bbf
	ld e,$82		; $6bc2
	ld a,(de)		; $6bc4
	rrca			; $6bc5
	ld bc,$0276		; $6bc6
	jr nc,_label_0f_247	; $6bc9
	ld bc,$047a		; $6bcb
_label_0f_247:
	ld a,$38		; $6bce
	call objectGetRelatedObject1Var		; $6bd0
	ld a,(hl)		; $6bd3
	and b			; $6bd4
	ret nz			; $6bd5
	ld h,d			; $6bd6
	ld l,$84		; $6bd7
	dec (hl)		; $6bd9
	ld l,$a4		; $6bda
	set 7,(hl)		; $6bdc
	ld l,$8b		; $6bde
	ld (hl),$24		; $6be0
	ld l,$8d		; $6be2
	ld (hl),c		; $6be4
	jp objectSetVisible82		; $6be5
	ld a,(de)		; $6be8
	sub $08			; $6be9
	rst_jumpTable			; $6beb
	ld a,($ff00+c)		; $6bec
	ld l,e			; $6bed
	dec bc			; $6bee
	ld l,h			; $6bef
	cp a			; $6bf0
	ld l,e			; $6bf1
	ld h,d			; $6bf2
	ld l,e			; $6bf3
	inc (hl)		; $6bf4
	ld l,$a5		; $6bf5
	ld (hl),$04		; $6bf7
	ld e,$82		; $6bf9
	ld a,(de)		; $6bfb
	sub $06			; $6bfc
	add $30			; $6bfe
	call objectGetRelatedObject1Var		; $6c00
	ld e,$99		; $6c03
	ld a,(hl)		; $6c05
	ld (de),a		; $6c06
	dec e			; $6c07
	ld a,$80		; $6c08
	ld (de),a		; $6c0a
	call $6cb2		; $6c0b
	call $6cbf		; $6c0e
	ret nz			; $6c11
	ld e,$8b		; $6c12
	ld a,b			; $6c14
	add a			; $6c15
	add $24			; $6c16
	ld (de),a		; $6c18
	ld e,$82		; $6c19
	ld a,(de)		; $6c1b
	cp $06			; $6c1c
	ld b,$76		; $6c1e
	jr z,_label_0f_248	; $6c20
	ld b,$7a		; $6c22
_label_0f_248:
	ld a,c			; $6c24
	add a			; $6c25
	add b			; $6c26
	ld e,$8d		; $6c27
	ld (de),a		; $6c29
	ret			; $6c2a
	ld a,(de)		; $6c2b
	sub $08			; $6c2c
	rst_jumpTable			; $6c2e
	dec (hl)		; $6c2f
	ld l,h			; $6c30
	ld c,(hl)		; $6c31
	ld l,h			; $6c32
	cp a			; $6c33
	ld l,e			; $6c34
	ld h,d			; $6c35
	ld l,e			; $6c36
	inc (hl)		; $6c37
	ld l,$a5		; $6c38
	ld (hl),$04		; $6c3a
	ld e,$82		; $6c3c
	ld a,(de)		; $6c3e
	sub $08			; $6c3f
	add $30			; $6c41
	call objectGetRelatedObject1Var		; $6c43
	ld e,$99		; $6c46
	ld a,(hl)		; $6c48
	ld (de),a		; $6c49
	dec e			; $6c4a
	ld a,$80		; $6c4b
	ld (de),a		; $6c4d
	call $6cb2		; $6c4e
	call $6cbf		; $6c51
	ret nz			; $6c54
	ld e,$8b		; $6c55
	ld a,b			; $6c57
	add $24			; $6c58
	ld (de),a		; $6c5a
	ld e,$82		; $6c5b
	ld a,(de)		; $6c5d
	cp $08			; $6c5e
	ld a,$76		; $6c60
	jr z,_label_0f_249	; $6c62
	ld a,$7a		; $6c64
_label_0f_249:
	add c			; $6c66
	ld e,$8d		; $6c67
	ld (de),a		; $6c69
	ret			; $6c6a
	dec b			; $6c6b
	jr z,_label_0f_251	; $6c6c
	ld c,$76		; $6c6e
	ld l,$82		; $6c70
	bit 0,(hl)		; $6c72
	jr z,_label_0f_250	; $6c74
	ld c,$7a		; $6c76
_label_0f_250:
	ld l,$8b		; $6c78
	ld (hl),$24		; $6c7a
	ld l,$8d		; $6c7c
	ld (hl),c		; $6c7e
	ld l,$82		; $6c7f
	ld a,(hl)		; $6c81
	cp $04			; $6c82
	ret c			; $6c84
	ld a,$02		; $6c85
	jp enemySetAnimation		; $6c87
_label_0f_251:
	ld l,$a4		; $6c8a
	res 7,(hl)		; $6c8c
	ld l,$a6		; $6c8e
	ld (hl),$0c		; $6c90
	inc l			; $6c92
	ld (hl),$0e		; $6c93
	ld l,$8b		; $6c95
	ld (hl),$20		; $6c97
	ld l,$8d		; $6c99
	ld (hl),$78		; $6c9b
	ld hl,$ce16		; $6c9d
	ld a,$0f		; $6ca0
	ldi (hl),a		; $6ca2
	ldi (hl),a		; $6ca3
	ld (hl),a		; $6ca4
	ld l,$26		; $6ca5
	ldi (hl),a		; $6ca7
	ldi (hl),a		; $6ca8
	ld (hl),a		; $6ca9
	ld a,$03		; $6caa
	call enemySetAnimation		; $6cac
	jp objectSetVisible83		; $6caf
	ld a,$01		; $6cb2
	call objectGetRelatedObject2Var		; $6cb4
	ld a,(hl)		; $6cb7
	cp $06			; $6cb8
	ret z			; $6cba
	pop hl			; $6cbb
	jp enemyDelete		; $6cbc
	ld l,$84		; $6cbf
	ld a,(hl)		; $6cc1
	cp $0e			; $6cc2
	jr nz,_label_0f_252	; $6cc4
	ld h,d			; $6cc6
	inc (hl)		; $6cc7
	ld l,$a4		; $6cc8
	res 7,(hl)		; $6cca
	ld e,$9a		; $6ccc
	ld a,(de)		; $6cce
	rlca			; $6ccf
	ld b,$08		; $6cd0
	call c,objectCreateInteractionWithSubid00		; $6cd2
	jp objectSetInvisible		; $6cd5
_label_0f_252:
	ld l,$8b		; $6cd8
	ldi a,(hl)		; $6cda
	sub $24			; $6cdb
	sra a			; $6cdd
	sra a			; $6cdf
	ld b,a			; $6ce1
	inc l			; $6ce2
	ld e,$82		; $6ce3
	ld a,(de)		; $6ce5
	rrca			; $6ce6
	ld c,$76		; $6ce7
	jr nc,_label_0f_253	; $6ce9
	ld c,$7a		; $6ceb
_label_0f_253:
	ld a,(hl)		; $6ced
	sub c			; $6cee
	sra a			; $6cef
	sra a			; $6cf1
	ld c,a			; $6cf3
	xor a			; $6cf4
	ret			; $6cf5
	ld e,$b0		; $6cf6
	ld a,(de)		; $6cf8
	and $1f			; $6cf9
	jr nz,_label_0f_254	; $6cfb
	call getRandomNumber		; $6cfd
	and $20			; $6d00
	ld (de),a		; $6d02
_label_0f_254:
	ld a,(de)		; $6d03
	ld hl,$6d14		; $6d04
	rst_addAToHl			; $6d07
	ld e,$89		; $6d08
	ld a,(hl)		; $6d0a
	ld (de),a		; $6d0b
	ld h,d			; $6d0c
	ld l,$b0		; $6d0d
	inc (hl)		; $6d0f
	inc l			; $6d10
	ld (hl),$06		; $6d11
	ret			; $6d13
	dec d			; $6d14
	ld d,$17		; $6d15
	rla			; $6d17
	add hl,de		; $6d18
	add hl,de		; $6d19
	ld a,(de)		; $6d1a
	dec de			; $6d1b
	dec b			; $6d1c
	ld b,$07		; $6d1d
	rlca			; $6d1f
	add hl,bc		; $6d20
	add hl,bc		; $6d21
	ld a,(bc)		; $6d22
	dec bc			; $6d23
	dec bc			; $6d24
	ld a,(bc)		; $6d25
	add hl,bc		; $6d26
	add hl,bc		; $6d27
	rlca			; $6d28
	rlca			; $6d29
	ld b,$05		; $6d2a
	dec de			; $6d2c
	ld a,(de)		; $6d2d
	add hl,de		; $6d2e
	add hl,de		; $6d2f
	rla			; $6d30
	rla			; $6d31
	ld d,$15		; $6d32
	ld ($0908),sp		; $6d34
	add hl,bc		; $6d37
	ld a,(bc)		; $6d38
	ld a,(bc)		; $6d39
	dec bc			; $6d3a
	inc c			; $6d3b
	inc d			; $6d3c
	dec d			; $6d3d

	ld d,$16		; $6d3e
	rla			; $6d40
	rla			; $6d41
	jr _label_0f_255		; $6d42
.db $18 $18 $19 $19 $1a $1a $1b $1c
.db $04 $05 $06 $06 $07 $07 $08 $08

; ==============================================================================
; ENEMYID_KING_MOBLIN
; ==============================================================================
enemyCode07:
	jr z,_label_0f_257		; $6d54
	sub $03			; $6d56
	ret c			; $6d58
	jr z,_label_0f_256	; $6d59
	dec a			; $6d5b
_label_0f_255:
	ret nz			; $6d5c
	ld e,$aa		; $6d5d
	ld a,(de)		; $6d5f
	cp $97			; $6d60
	jr nz,_label_0f_257	; $6d62
	ld e,$a9		; $6d64
	ld a,(de)		; $6d66
	or a			; $6d67
	call nz,$6f20		; $6d68
	ld a,$63		; $6d6b
	jp playSound		; $6d6d
_label_0f_256:
	ld h,d			; $6d70
	ld l,$84		; $6d71
	ld (hl),$0e		; $6d73
	inc l			; $6d75
	ld (hl),$00		; $6d76
	ld l,$a4		; $6d78
	res 7,(hl)		; $6d7a
_label_0f_257:
	ld e,$84		; $6d7c
	ld a,(de)		; $6d7e
	rst_jumpTable			; $6d7f
	sbc (hl)		; $6d80
	ld l,l			; $6d81
	cp b			; $6d82
	ld l,l			; $6d83
	cp b			; $6d84
	ld l,l			; $6d85
	cp b			; $6d86
	ld l,l			; $6d87
	cp b			; $6d88
	ld l,l			; $6d89
	cp b			; $6d8a
	ld l,l			; $6d8b
	cp b			; $6d8c
	ld l,l			; $6d8d
	cp b			; $6d8e
	ld l,l			; $6d8f
	cp c			; $6d90
	ld l,l			; $6d91
	jp z,$0a6d		; $6d92
	ld l,(hl)		; $6d95
	ld h,$6e		; $6d96
	ccf			; $6d98
	ld l,(hl)		; $6d99
	ld d,l			; $6d9a
	ld l,(hl)		; $6d9b
	ld h,b			; $6d9c
	ld l,(hl)		; $6d9d
	ld a,$07		; $6d9e
	ld ($cc1c),a		; $6da0
	ld a,$8c		; $6da3
	call loadPaletteHeader		; $6da5
	ld a,$14		; $6da8
	call _ecom_setSpeedAndState8		; $6daa
	ld e,$88		; $6dad
	ld a,$02		; $6daf
	ld (de),a		; $6db1
	call enemySetAnimation		; $6db2
	jp objectSetVisible83		; $6db5
	ret			; $6db8
	ld hl,$cfc0		; $6db9
	bit 0,(hl)		; $6dbc
	jp z,enemyAnimate		; $6dbe
	ld (hl),$00		; $6dc1
	ld h,d			; $6dc3
	ld l,e			; $6dc4
	inc (hl)		; $6dc5
	ld l,$90		; $6dc6
	ld (hl),$14		; $6dc8
_label_0f_258:
	call getRandomNumber_noPreserveVars		; $6dca
	and $07			; $6dcd
	cp $07			; $6dcf
	jr z,_label_0f_258	; $6dd1
	ld h,d			; $6dd3
	ld l,$b0		; $6dd4
	cp (hl)			; $6dd6
	jr z,_label_0f_258	; $6dd7
	ld (hl),a		; $6dd9
	ld hl,$6e03		; $6dda
	rst_addAToHl			; $6ddd
	ld e,$8d		; $6dde
	ld a,(de)		; $6de0
	cp (hl)			; $6de1
	jr z,_label_0f_258	; $6de2
	ld e,$b1		; $6de4
	ld a,(hl)		; $6de6
	ld (de),a		; $6de7
	ld h,d			; $6de8
	ld l,$84		; $6de9
	inc (hl)		; $6deb
	ld l,$8d		; $6dec
	ld a,(hl)		; $6dee
	ld l,$b1		; $6def
	cp (hl)			; $6df1
	ld a,$03		; $6df2
	ld b,$18		; $6df4
	jr nc,_label_0f_259	; $6df6
	ld a,$01		; $6df8
	ld b,$08		; $6dfa
_label_0f_259:
	ld l,$88		; $6dfc
	ldi (hl),a		; $6dfe
	ld (hl),b		; $6dff
	jp enemySetAnimation		; $6e00
	ld d,b			; $6e03
	jr nz,_label_0f_260	; $6e04
	ld b,b			; $6e06
	ld h,b			; $6e07
	ld (hl),b		; $6e08
	add b			; $6e09
	call objectApplySpeed		; $6e0a
	ld h,d			; $6e0d
	ld l,$8d		; $6e0e
	ld a,(hl)		; $6e10
	ld l,$b1		; $6e11
	sub (hl)		; $6e13
	inc a			; $6e14
	cp $03			; $6e15
	jr nc,_label_0f_261	; $6e17
	ld l,$84		; $6e19
	inc (hl)		; $6e1b
	call $6f2e		; $6e1c
	ld e,$88		; $6e1f
	xor a			; $6e21
	ld (de),a		; $6e22
	jp enemySetAnimation		; $6e23
	call _ecom_decCounter1		; $6e26
	jr nz,_label_0f_261	; $6e29
	inc (hl)		; $6e2b
	ld b,$3f		; $6e2c
	call _ecom_spawnProjectile		; $6e2e
	ret nz			; $6e31
	ld e,$84		; $6e32
	ld a,$0c		; $6e34
_label_0f_260:
	ld (de),a		; $6e36
	ld e,$88		; $6e37
	ld a,$04		; $6e39
	ld (de),a		; $6e3b
	jp enemySetAnimation		; $6e3c
	call $6f40		; $6e3f
	ret nc			; $6e42
	inc a			; $6e43
	ret nz			; $6e44
	ld e,$84		; $6e45
	ld a,$0d		; $6e47
	ld (de),a		; $6e49
	call $6f2e		; $6e4a
	ld e,$88		; $6e4d
	ld a,$02		; $6e4f
	ld (de),a		; $6e51
	jp enemySetAnimation		; $6e52
	call _ecom_decCounter1		; $6e55
	jr nz,_label_0f_261	; $6e58
	ld l,e			; $6e5a
	ld (hl),$09		; $6e5b
_label_0f_261:
	jp enemyAnimate		; $6e5d
	inc e			; $6e60
	ld a,(de)		; $6e61
	rst_jumpTable			; $6e62
	ld l,l			; $6e63
	ld l,(hl)		; $6e64
	and a			; $6e65
	ld l,(hl)		; $6e66
	ret z			; $6e67
	ld l,(hl)		; $6e68
	call c,$1f6e		; $6e69
	ld l,a			; $6e6c
	call checkLinkCollisionsEnabled		; $6e6d
	ret nc			; $6e70
	ld h,d			; $6e71
	ld l,$85		; $6e72
	inc (hl)		; $6e74
	ld l,$87		; $6e75
	ld (hl),$3c		; $6e77
	ld l,$a9		; $6e79
	ld (hl),$01		; $6e7b
	ld a,$01		; $6e7d
	call objectGetRelatedObject2Var		; $6e7f
	ld a,(hl)		; $6e82
	cp $3f			; $6e83
	jr nz,_label_0f_262	; $6e85
	ld l,$c4		; $6e87
	ld a,(hl)		; $6e89
	dec a			; $6e8a
	jr nz,_label_0f_262	; $6e8b
	ld (hl),$06		; $6e8d
	ld l,$cb		; $6e8f
	ld e,$8b		; $6e91
	ld a,(de)		; $6e93
	sub $10			; $6e94
	ld (hl),a		; $6e96
	ld e,$b3		; $6e97
	ld a,$01		; $6e99
	ld (de),a		; $6e9b
	ld ($cc02),a		; $6e9c
	ld ($cca4),a		; $6e9f
_label_0f_262:
	ld a,$05		; $6ea2
	jp enemySetAnimation		; $6ea4
	call _ecom_decCounter2		; $6ea7
	ret nz			; $6eaa
	ld l,$b3		; $6eab
	bit 0,(hl)		; $6ead
	jr z,_label_0f_263	; $6eaf
	ld l,e			; $6eb1
	inc (hl)		; $6eb2
	ret			; $6eb3
_label_0f_263:
	ld l,$a4		; $6eb4
	set 7,(hl)		; $6eb6
	ld l,$84		; $6eb8
	ld (hl),$09		; $6eba
	ld l,$b4		; $6ebc
	bit 0,(hl)		; $6ebe
	ret nz			; $6ec0
	inc (hl)		; $6ec1
	ld bc,$3f06		; $6ec2
	jp showText		; $6ec5
	ld a,$04		; $6ec8
	call objectGetRelatedObject2Var		; $6eca
	ld a,(hl)		; $6ecd
	cp $05			; $6ece
	ret nz			; $6ed0
	ld h,d			; $6ed1
	ld l,$85		; $6ed2
	inc (hl)		; $6ed4
	inc l			; $6ed5
	ld (hl),$01		; $6ed6
	inc l			; $6ed8
	ld (hl),$06		; $6ed9
	ret			; $6edb
	call _ecom_decCounter1		; $6edc
	ret nz			; $6edf
	inc (hl)		; $6ee0
	inc l			; $6ee1
	ld a,(hl)		; $6ee2
	dec a			; $6ee3
	ld hl,$6f13		; $6ee4
	rst_addDoubleIndex			; $6ee7
	ldi a,(hl)		; $6ee8
	ld c,(hl)		; $6ee9
	ld b,a			; $6eea
	call getFreeInteractionSlot		; $6eeb
	ret nz			; $6eee
	ld (hl),$56		; $6eef
	ld l,$4b		; $6ef1
	ld (hl),b		; $6ef3
	ld l,$4d		; $6ef4
	ld (hl),c		; $6ef6
	ld a,c			; $6ef7
	and $f0			; $6ef8
	swap a			; $6efa
	ld c,a			; $6efc
	ld a,$ac		; $6efd
	call setTile		; $6eff
	call _ecom_decCounter2		; $6f02
	ld l,$86		; $6f05
	ld (hl),$0f		; $6f07
	ret nz			; $6f09
	ld l,$85		; $6f0a
	inc (hl)		; $6f0c
	ld a,$01		; $6f0d
	ld ($cfc0),a		; $6f0f
	ret			; $6f12
	ld ($0c78),sp		; $6f13
	jr c,$0a		; $6f16
	ld h,b			; $6f18
	ld ($0448),sp		; $6f19
	inc h			; $6f1c
	ld b,$5a		; $6f1d
	ret			; $6f1f
	dec a			; $6f20
	ld hl,$6f2a		; $6f21
	rst_addAToHl			; $6f24
	ld e,$90		; $6f25
	ld a,(hl)		; $6f27
	ld (de),a		; $6f28
	ret			; $6f29
	ld d,b			; $6f2a
	inc a			; $6f2b
	jr z,_label_0f_264	; $6f2c
	ld e,$a9		; $6f2e
	ld a,(de)		; $6f30
	dec a			; $6f31
	ld hl,$6f3b		; $6f32
	rst_addAToHl			; $6f35
	ld e,$86		; $6f36
	ld a,(hl)		; $6f38
	ld (de),a		; $6f39
	ret			; $6f3a
	inc d			; $6f3b
	ld e,$28		; $6f3c
	ldd (hl),a		; $6f3e
	inc a			; $6f3f
	call enemyAnimate		; $6f40
	ld e,$a1		; $6f43
	ld a,(de)		; $6f45
	rlca			; $6f46
	ret c			; $6f47
	cp $06			; $6f48
	jr nz,_label_0f_265	; $6f4a
_label_0f_264:
	ld a,$80		; $6f4c
	ld (de),a		; $6f4e
	ld a,$04		; $6f4f
	call objectGetRelatedObject2Var		; $6f51
	ld (hl),$03		; $6f54
	ld l,$e4		; $6f56
	set 7,(hl)		; $6f58
	ret			; $6f5a
_label_0f_265:
	ld e,$a1		; $6f5b
	ld a,(de)		; $6f5d
	ld hl,$6f6f		; $6f5e
	rst_addDoubleIndex			; $6f61
	ldi a,(hl)		; $6f62
	ld b,a			; $6f63
	ld c,(hl)		; $6f64
	ld a,$0b		; $6f65
	call objectGetRelatedObject2Var		; $6f67
	call objectCopyPositionWithOffset		; $6f6a
	or d			; $6f6d
	ret			; $6f6e
	ld ($f600),sp		; $6f6f
	nop			; $6f72
	xor $00			; $6f73
