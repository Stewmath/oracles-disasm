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
;
; Variables:
;   var03: If bit 0 is unset, this acts as the "spawner" for the other twinrova object.
;          Bit 7: ?
;   relatedObj1: Reference to other twinrova object
;   relatedObj2: Reference to INTERACID_PUFF
;   var30: Anglular velocity (amount to add to angle)
;   var31: Counter used for z-position bobbing
;   var32: Bit 0: Nonzero while projectile is being fired?
;          Bit 1: Signal in merging cutscene
;          Bit 2: Signal to fire a projectile
;          Bit 3: Enable/disable z-position bobbing
;          Bit 4: Signal in merging cutscene
;          Bit 5: ?
;          Bit 6: Signal to do "death cutscene" if health is 0. Set by
;                 PARTID_RED_TWINROVA_PROJECTILE or PARTID_BLUE_TWINROVA_PROJECTILE.
;          Bit 7: If set, updates draw layer relative to Link
;   var33: Movement pattern (0-3)
;   var34: Position index (within the movement pattern)
;   var35/var36: Target position?
;   var37: Counter to update facing direction when it reaches 0?
;   var38: Index in "attack pattern"? (0-7)
;   var39: Some kind of counter?
; ==============================================================================
enemyCode03:
	jr z,@normalStatus	; $4a57
	sub ENEMYSTATUS_NO_HEALTH			; $4a59
	ret c			; $4a5b
	jr nz,@normalStatus	; $4a5c

	; Dead
	ld h,d			; $4a5e
	ld l,Enemy.var32		; $4a5f
	bit 6,(hl)		; $4a61
	jr z,@normalStatus	; $4a63

	ld l,Enemy.health		; $4a65
	ld (hl),$7f		; $4a67
	ld l,Enemy.collisionType		; $4a69
	res 7,(hl)		; $4a6b

	ld l,Enemy.state		; $4a6d
	ld (hl),$0d		; $4a6f

	; Set variables in relatedObj1 (other twinrova)
	ld a,Object.health		; $4a71
	call objectGetRelatedObject1Var		; $4a73
	ld (hl),$7f		; $4a76
	ld l,Enemy.collisionType		; $4a78
	res 7,(hl)		; $4a7a
	ld l,Enemy.state		; $4a7c
	ld (hl),$0f		; $4a7e

	ld a,SNDCTRL_STOPMUSIC		; $4a80
	call playSound		; $4a82

@normalStatus:
	call _twinrova_updateZPosition		; $4a85
	call @runState		; $4a88
	ld e,Enemy.var32		; $4a8b
	ld a,(de)		; $4a8d
	bit 7,a			; $4a8e
	jp nz,objectSetPriorityRelativeToLink_withTerrainEffects		; $4a90
	ret			; $4a93

@runState:
	call _twinrova_checkFireProjectile		; $4a94
	call _ecom_getSubidAndCpStateTo08		; $4a97
	jr nc,@state8OrHigher		; $4a9a
	rst_jumpTable			; $4a9c
	.dw _twinrova_state_uninitialized
	.dw _twinrova_state_spawner
	.dw _twinrova_state_stub
	.dw _twinrova_state_stub
	.dw _twinrova_state_stub
	.dw _twinrova_state_stub
	.dw _twinrova_state_stub
	.dw _twinrova_state_stub

@state8OrHigher:
	ld a,b			; $4aad
	rst_jumpTable		; $44ae
	.dw _twinrova_subid0
	.dw _twinrova_subid1


_twinrova_state_uninitialized:
	ld a,ENEMYID_TWINROVA		; $4ab3
	ld (wEnemyIDToLoadExtraGfx),a		; $4ab5
	ld a,$01		; $4ab8
	ld (wLoadedTreeGfxIndex),a		; $4aba

	ld h,d			; $4abd
	ld l,Enemy.var03		; $4abe
	bit 0,(hl)		; $4ac0
	ld a,SPEED_100		; $4ac2
	jp nz,_twinrova_initialize		; $4ac4

	ld l,e			; $4ac7
	inc (hl) ; [state] = 1

	xor a			; $4ac9
	ld (w1Link.direction),a		; $4aca
	inc a			; $4acd
	ld (wDisabledObjects),a		; $4ace
	ld (wMenuDisabled),a		; $4ad1


_twinrova_state_spawner:
	ld b,ENEMYID_TWINROVA		; $4ad4
	call _ecom_spawnUncountedEnemyWithSubid01		; $4ad6
	ret nz			; $4ad9

	; [child.var03] = [this.var03] + 1
	inc l			; $4ada
	ld e,l			; $4adb
	ld a,(de)		; $4adc
	inc a			; $4add
	ld (hl),a		; $4ade

	; [this.relatedObj1] = child
	; [child.relatedObj1] = this
	ld l,Enemy.relatedObj1		; $4adf
	ld e,l			; $4ae1
	ld a,Enemy.start		; $4ae2
	ld (de),a		; $4ae4
	ldi (hl),a		; $4ae5
	inc e			; $4ae6
	ld a,h			; $4ae7
	ld (de),a		; $4ae8
	ld (hl),d		; $4ae9

	ld a,h			; $4aea
	cp d			; $4aeb
	ld a,SPEED_100		; $4aec
	jp nc,_twinrova_initialize		; $4aee

	; Swap the twinrova objects; subid 0 must come before subid 1?
	ld l,Enemy.enabled		; $4af1
	ld e,l			; $4af3
	ld a,(de)		; $4af4
	ld (hl),a		; $4af5

	ld l,Enemy.subid		; $4af6
	dec (hl) ; [child.subid] = 0
	ld h,d			; $4af9
	inc (hl) ; [this.subid] = 1
	inc l			; $4afb
	inc (hl) ; [this.var03] = 1
	ld l,Enemy.state		; $4afd
	dec (hl) ; [this.state] = 0
	ret			; $4b00


_twinrova_state_stub:
	ret			; $4b01


_twinrova_subid0:
	ld a,(de)		; $4b02
	sub $08			; $4b03
	rst_jumpTable			; $4b05
	.dw _twinrova_state8
	.dw _twinrova_state9
	.dw _twinrova_subid0_stateA
	.dw _twinrova_subid0_stateB
	.dw _twinrova_subid0_stateC
	.dw _twinrova_stateD
	.dw _twinrova_stateE
	.dw _twinrova_stateF
	.dw _twinrova_state10


; Cutscene before fight
_twinrova_state8:
	ld h,d			; $4b18
	ld l,e			; $4b19
	inc (hl) ; [state] = 9

	ld l,Enemy.var32		; $4b1b
	set 3,(hl)		; $4b1d
	set 7,(hl)		; $4b1f

	ld l,Enemy.counter1		; $4b21
	ld (hl),106		; $4b23

	ld l,Enemy.yh		; $4b25
	ld (hl),$08		; $4b27

	; Set initial x-position, oam flags, angle, and var30 based on subid
	ld l,Enemy.subid		; $4b29
	ld a,(hl)		; $4b2b
	add a			; $4b2c
	ld hl,@data		; $4b2d
	rst_addDoubleIndex			; $4b30

	ld e,Enemy.xh		; $4b31
	ldi a,(hl)		; $4b33
	ld (de),a		; $4b34
	ld e,Enemy.oamFlagsBackup		; $4b35
	ldi a,(hl)		; $4b37
	ld (de),a		; $4b38
	inc e			; $4b39
	ld (de),a		; $4b3a

	ld e,Enemy.angle		; $4b3b
	ldi a,(hl)		; $4b3d
	ld (de),a		; $4b3e
	ld e,Enemy.var30		; $4b3f
	ld a,(hl)		; $4b41
	ld (de),a		; $4b42

	; Subid 0 only: show text
	ld e,Enemy.subid		; $4b43
	ld a,(de)		; $4b45
	or a			; $4b46
	ld bc,TX_2f04		; $4b47
	call z,showText		; $4b4a

	call getRandomNumber_noPreserveVars		; $4b4d
	ld e,Enemy.var31		; $4b50
	ld (de),a		; $4b52
	jp _twinrova_updateAnimationFromAngle		; $4b53

; Data per subid: x-position, oam flags, angle, var30
@data:
	.db $c0 $02 $11 $01 ; Subid 0
	.db $30 $01 $0f $ff ; Subid 1


; Moving down the screen in the pre-fight cutscene
_twinrova_state9:
	inc e			; $4b5e
	ld a,(de)		; $4b5f
	rst_jumpTable			; $4b60
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call _ecom_decCounter1		; $4b6b
	jr nz,@applySpeed	; $4b6e

	ld (hl),$08 ; [counter1]
	inc l			; $4b72
	ld (hl),$12 ; [counter2]
	ld l,e			; $4b75
	inc (hl) ; [state2] = 1
	jr @animate		; $4b77

@substate1:
	call _ecom_decCounter1		; $4b79
	jr nz,@applySpeed	; $4b7c

	ld (hl),$08 ; [counter1]
	inc l			; $4b80
	dec (hl) ; [counter2]
	jr nz,@updateAngle	; $4b82

	ld l,e			; $4b84
	inc (hl) ; [state2] = 3
	inc l			; $4b86
	ld (hl),30 ; [counter1]

	call _ecom_updateAngleTowardTarget		; $4b89
	call _twinrova_calculateAnimationFromAngle		; $4b8c
	ld (hl),a		; $4b8f
	jp enemySetAnimation		; $4b90

@updateAngle:
	ld e,Enemy.angle		; $4b93
	ld l,Enemy.var30		; $4b95
	ld a,(de)		; $4b97
	add (hl)		; $4b98
	and $1f			; $4b99
	ld (de),a		; $4b9b
	call _twinrova_updateAnimationFromAngle		; $4b9c

@applySpeed:
	call objectApplySpeed		; $4b9f
@animate:
	jp enemyAnimate		; $4ba2

@substate2:
	call _ecom_decCounter1		; $4ba5
	jr nz,@animate	; $4ba8

	ld l,e			; $4baa
	inc (hl) ; [state2] = 3

	ld e,Enemy.subid		; $4bac
	ld a,(de)		; $4bae
	or a			; $4baf
	ret nz			; $4bb0
	ld bc,TX_2f05		; $4bb1
	jp showText		; $4bb4

@substate3:
	ldbc INTERACID_PUFF,$02		; $4bb7
	call objectCreateInteraction		; $4bba
	ret nz			; $4bbd
	ld a,h			; $4bbe
	ld h,d			; $4bbf
	ld l,Enemy.relatedObj2+1		; $4bc0
	ldd (hl),a		; $4bc2
	ld (hl),Interaction.start		; $4bc3

	ld l,Enemy.state2		; $4bc5
	inc (hl) ; [state2] = 4

	ld l,Enemy.var32		; $4bc8
	res 7,(hl)		; $4bca
	jp objectSetInvisible		; $4bcc

@substate4:
	; Wait for puff to finish
	ld a,Object.animParameter		; $4bcf
	call objectGetRelatedObject2Var		; $4bd1
	bit 7,(hl)		; $4bd4
	ret z			; $4bd6

	ld h,d			; $4bd7
	ld l,Enemy.var32		; $4bd8
	set 7,(hl)		; $4bda
	xor a			; $4bdc
	ld (wDisabledObjects),a		; $4bdd
	ld (wMenuDisabled),a		; $4be0

	ld a,CUTSCENE_FLAMES_FLICKERING		; $4be3
	ld (wCutsceneTrigger),a		; $4be5

	call _ecom_updateAngleTowardTarget		; $4be8
	call _twinrova_calculateAnimationFromAngle		; $4beb
	add $04			; $4bee
	ld (hl),a		; $4bf0
	jp enemySetAnimation		; $4bf1


; Fight just starting
_twinrova_subid0_stateA:
	ld h,d			; $4bf4
	ld l,e			; $4bf5
	inc (hl) ; [state] = $0b

	ld a,MUS_TWINROVA		; $4bf7
	ld (wActiveMusic),a		; $4bf9
	call playSound		; $4bfc
	jp _twinrova_subid0_updateTargetPosition		; $4bff


; Moving normally
_twinrova_subid0_stateB:
	ld a,(wFrameCounter)		; $4c02
	and $7f			; $4c05
	ld a,SND_FAIRYCUTSCENE		; $4c07
	call z,playSound		; $4c09

	call _twinrova_moveTowardTargetPosition		; $4c0c
	ret nc			; $4c0f
	call _twinrova_subid0_updateTargetPosition		; $4c10
	jr nz,@waypointChanged	; $4c13

	; Done this movement pattern
	call _ecom_incState ; [state] = $0c
	ld l,Enemy.counter1		; $4c18
	ld (hl),30		; $4c1a
	ret			; $4c1c

@waypointChanged:
	call _twinrova_checkAttackInProgress		; $4c1d
	ret nz			; $4c20

	ld e,Enemy.var38		; $4c21
	ld a,(de)		; $4c23
	inc a			; $4c24
	and $07			; $4c25
	ld (de),a		; $4c27
	ld hl,@attackPattern		; $4c28
	call checkFlag		; $4c2b
	jp nz,_twinrova_chooseObjectToAttack		; $4c2e
	ret			; $4c31

@attackPattern:
	.db %01110101


; Delay before choosing new movement pattern and returning to state $0b
_twinrova_subid0_stateC:
	call _ecom_decCounter1		; $4c33
	jp nz,enemyAnimate		; $4c36

	ld l,e			; $4c39
	dec (hl) ; [state] = $0b

	; Choose random movement pattern
	call getRandomNumber_noPreserveVars		; $4c3b
	and $03			; $4c3e
	ld e,Enemy.var33		; $4c40
	ld (de),a		; $4c42
	inc e			; $4c43
	xor a			; $4c44
	ld (de),a ; [var34]

	jp _twinrova_subid0_updateTargetPosition		; $4c46


; Health just reached 0
_twinrova_stateD:
	ld h,d			; $4c49
	ld l,e			; $4c4a
	inc (hl) ; [state] = $0e

	ld l,Enemy.zh		; $4c4c
	ld (hl),$00		; $4c4e
	ld l,Enemy.var32		; $4c50
	res 3,(hl)		; $4c52

	ld l,Enemy.angle		; $4c54
	bit 4,(hl)		; $4c56
	ld a,$0a		; $4c58
	jr z,+			; $4c5a
	inc a			; $4c5c
+
	jp enemySetAnimation		; $4c5d


; Delay before showing text
_twinrova_stateE:
	ld e,Enemy.animParameter		; $4c60
	ld a,(de)		; $4c62
	inc a			; $4c63
	jr nz,_twinrova_animate	; $4c64

	ld e,Enemy.direction		; $4c66
	ld a,(de)		; $4c68
	add $04			; $4c69
	call enemySetAnimation		; $4c6b

	call _ecom_incState		; $4c6e
	ld l,Enemy.zh		; $4c71
	dec (hl)		; $4c73
	ld bc,TX_2f09		; $4c74
	call showText		; $4c77
_twinrova_animate:
	jp enemyAnimate		; $4c7a


_twinrova_stateF:
	call _twinrova_rise2PixelsAboveGround		; $4c7d
	jr nz,_twinrova_animate	; $4c80

	; Wait for signal that twin has risen
	ld a,Object.var32		; $4c82
	call objectGetRelatedObject1Var		; $4c84
	bit 4,(hl)		; $4c87
	jr nz,@nextState	; $4c89

	call _ecom_updateAngleTowardTarget		; $4c8b
	call _twinrova_updateMovingAnimation		; $4c8e
	jr _twinrova_animate		; $4c91

@nextState:
	call _ecom_incState		; $4c93
	inc l			; $4c96
	ld (hl),$00 ; [state2] = 0

	ld l,Enemy.var32		; $4c99
	res 3,(hl)		; $4c9b
	jr _twinrova_animate		; $4c9d


; Merging into one
_twinrova_state10:
	inc e			; $4c9f
	ld a,(de)		; $4ca0
	rst_jumpTable			; $4ca1
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7

; Showing more text
@substate0:
	ld h,d			; $4cb2
	ld l,e			; $4cb3
	inc (hl) ; [state2] = 1

	ld l,Enemy.var32		; $4cb5
	res 1,(hl)		; $4cb7
	res 0,(hl)		; $4cb9

	ld l,Enemy.direction		; $4cbb
	ld (hl),$00		; $4cbd

	ld bc,-$3e0		; $4cbf
	call objectSetSpeedZ		; $4cc2

	ld e,Enemy.subid		; $4cc5
	ld a,(de)		; $4cc7
	or a			; $4cc8
	ret nz			; $4cc9
	ld bc,TX_2f0a		; $4cca
	jp showText		; $4ccd

; Rising up above screen
@substate1:
	ld c,$08		; $4cd0
	call objectUpdateSpeedZ_paramC		; $4cd2
	ldh a,(<hCameraY)	; $4cd5
	ld b,a			; $4cd7
	ld l,Enemy.yh		; $4cd8
	ld a,(hl)		; $4cda
	sub b			; $4cdb
	jr nc,+			; $4cdc
	ld a,(hl)		; $4cde
+
	ld b,a			; $4cdf
	ld l,Enemy.zh		; $4ce0
	ld a,(hl)		; $4ce2
	cp $80			; $4ce3
	jr c,++			; $4ce5

	add b			; $4ce7
	cp $f0			; $4ce8
	jr c,@animate	; $4cea
++
	ld l,Enemy.state2		; $4cec
	inc (hl) ; [state2] = 2

	ld l,Enemy.var32		; $4cef
	set 1,(hl)		; $4cf1
	ld l,Enemy.var32		; $4cf3
	res 7,(hl)		; $4cf5

	ld l,Enemy.counter1		; $4cf7
	ld (hl),60		; $4cf9
	jp objectSetInvisible		; $4cfb

; Waiting for both twins to finish substate 1 (rise above screen)
@substate2:
	ld e,Enemy.subid		; $4cfe
	ld a,(de)		; $4d00
	or a			; $4d01
	ret nz			; $4d02

	; Subid 0 only: wait for twin to finish substate 1
	ld a,Object.var32		; $4d03
	call objectGetRelatedObject1Var		; $4d05
	bit 1,(hl)		; $4d08
	ret z			; $4d0a

	; Increment state2 for both (now synchronized)
	ld l,Enemy.state2		; $4d0b
	inc (hl)		; $4d0d
	ld h,d			; $4d0e
	inc (hl)		; $4d0f
	ret			; $4d10

; Delay before coming back down
@substate3:
	call _ecom_decCounter1		; $4d11
	ret nz			; $4d14

	ld (hl),48 ; [counter1]
	ld l,e			; $4d17
	inc (hl) ; [state2] = 4

	ld l,Enemy.zh		; $4d19
	ld (hl),$a0		; $4d1b

	ld l,Enemy.angle		; $4d1d
	ld e,Enemy.subid		; $4d1f
	ld a,(de)		; $4d21
	or a			; $4d22
	ld (hl),$08		; $4d23
	jr z,+			; $4d25
	ld (hl),$18		; $4d27
+
	ld l,Enemy.var32		; $4d29
	set 7,(hl)		; $4d2b
	call objectSetVisiblec2		; $4d2d
	ld a,SND_WIND		; $4d30
	call playSound		; $4d32

; Circling down to ground
@substate4:
	ld bc,$5878		; $4d35
	ld e,Enemy.counter1		; $4d38
	ld a,(de)		; $4d3a
	ld e,Enemy.angle		; $4d3b
	call objectSetPositionInCircleArc		; $4d3d

	ld e,Enemy.angle		; $4d40
	ld a,(de)		; $4d42
	add $08			; $4d43
	and $1f			; $4d45
	call _twinrova_updateMovingAnimationGivenAngle		; $4d47

	ld h,d			; $4d4a
	ld l,Enemy.zh		; $4d4b
	inc (hl)		; $4d4d
	ld a,(hl)		; $4d4e
	rrca			; $4d4f
	jr c,@animate	; $4d50

	; Every other frame, increment angle
	ld l,Enemy.angle		; $4d52
	ld a,(hl)		; $4d54
	inc a			; $4d55
	and $1f			; $4d56
	ld (hl),a		; $4d58
	ld l,Enemy.counter1		; $4d59
	dec (hl)		; $4d5b
	jr nz,@animate	; $4d5c

	dec l			; $4d5e
	inc (hl) ; [state2] = 5
@animate:
	jp enemyAnimate		; $4d60

; Reached ground
@substate5:
	; Delete subid 1 (subid 0 will remain)
	ld e,Enemy.subid		; $4d63
	ld a,(de)		; $4d65
	or a			; $4d66
	jp nz,enemyDelete		; $4d67

	ld a,(wLinkDeathTrigger)		; $4d6a
	or a			; $4d6d
	ret nz			; $4d6e

	inc a			; $4d6f
	ld (wDisabledObjects),a		; $4d70
	ld (wDisableLinkCollisionsAndMenu),a		; $4d73

	ld h,d			; $4d76
	ld l,Enemy.state2		; $4d77
	inc (hl) ; [state2] = 6

	ld l,Enemy.oamFlagsBackup		; $4d7a
	xor a			; $4d7c
	ldi (hl),a		; $4d7d
	ld (hl),a		; $4d7e

	ld a,$0c		; $4d7f
	call enemySetAnimation		; $4d81
	ld a,SND_TRANSFORM		; $4d84
	call playSound		; $4d86

	ld a,$02		; $4d89
	jp fadeinFromWhiteWithDelay		; $4d8b

; Waiting for screen to fade back in from white
@substate6:
	ld a,(wPaletteThread_mode)		; $4d8e
	or a			; $4d91
	ret nz			; $4d92

	ld h,d			; $4d93
	ld l,Enemy.state2		; $4d94
	inc (hl) ; [state2] = 7

	ld l,Enemy.var32		; $4d97
	res 0,(hl)		; $4d99

	ld a,$01		; $4d9b
	ld (wLoadedTreeGfxIndex),a		; $4d9d
	ret			; $4da0

; Initiating next phase of fight
@substate7:
	; Find a free enemy slot. (Why does it do this manually instead of using
	; "getFreeEnemySlot"?)
	ld h,d			; $4da1
	ld l,Enemy.enabled		; $4da2
	inc h			; $4da4
@nextEnemy:
	ld a,(hl)		; $4da5
	or a			; $4da6
	jr z,@foundFreeSlot	; $4da7
	inc h			; $4da9
	ld a,h			; $4daa
	cp LAST_ENEMY_INDEX+1			; $4dab
	jr c,@nextEnemy	; $4dad
	ret			; $4daf

@foundFreeSlot:
	ld e,l			; $4db0
	ld a,(de)		; $4db1
	ldi (hl),a ; [child.enabled] = [this.enabled]
	ld (hl),ENEMYID_MERGED_TWINROVA ; [child.id]
	call objectCopyPosition		; $4db5

	ld a,$01		; $4db8
	ld (wLoadedTreeGfxIndex),a		; $4dba

	jp enemyDelete		; $4dbd


; Subid 1 is nearly identical to subid 0, it just doesn't do a few things like playing
; sound effects.
_twinrova_subid1:
	ld a,(de)		; $4dc0
	sub $08			; $4dc1
	rst_jumpTable			; $4dc3
	.dw _twinrova_state8
	.dw _twinrova_state9
	.dw _twinrova_subid1_stateA
	.dw _twinrova_subid1_stateB
	.dw _twinrova_subid1_stateC
	.dw _twinrova_stateD
	.dw _twinrova_stateE
	.dw _twinrova_stateF
	.dw _twinrova_state10


; Fight just starting
_twinrova_subid1_stateA:
	ld a,$0b		; $4dd6
	ld (de),a ; [state] = $0b
	jp _twinrova_subid1_updateTargetPosition		; $4dd9


; Moving normally
_twinrova_subid1_stateB:
	call _twinrova_moveTowardTargetPosition		; $4ddc
	ret nc			; $4ddf
	call _twinrova_subid1_updateTargetPosition		; $4de0
	ret nz			; $4de3

	; Done this movement pattern
	call _ecom_incState		; $4de4
	ld l,Enemy.counter1		; $4de7
	ld (hl),30		; $4de9
	ret			; $4deb


; Delay before choosing new movement pattern and returning to state $0b
_twinrova_subid1_stateC:
	call _ecom_decCounter1		; $4dec
	jp nz,enemyAnimate		; $4def

	ld l,e			; $4df2
	dec (hl) ; [state] = $0b

	; Choose random movement pattern
	call getRandomNumber_noPreserveVars		; $4df4
	and $03			; $4df7
	ld e,Enemy.var33		; $4df9
	ld (de),a		; $4dfb
	inc e			; $4dfc
	xor a			; $4dfd
	ld (de),a ; [var34]

	jp _twinrova_subid1_updateTargetPosition		; $4dff


;;
; @param	a	Speed
; @addr{4e02}
_twinrova_initialize:
	ld h,d			; $4e02
	ld l,Enemy.var03		; $4e03
	bit 7,(hl)		; $4e05
	jp z,_ecom_setSpeedAndState8		; $4e07

	xor a			; $4e0a
	ld (wDisabledObjects),a		; $4e0b
	ld (wMenuDisabled),a		; $4e0e
	ld l,Enemy.yh		; $4e11
	ld (hl),$56		; $4e13
	ld l,Enemy.xh		; $4e15
	ld (hl),$60		; $4e17

	ld e,Enemy.subid		; $4e19
	ld a,(de)		; $4e1b
	or a			; $4e1c
	ld a,$02		; $4e1d
	jr z,++			; $4e1f
	ld (hl),$90 ; [xh]
	dec a			; $4e23
++
	ld l,Enemy.oamFlagsBackup		; $4e24
	ldi (hl),a		; $4e26
	ld (hl),a		; $4e27

	ld l,Enemy.state		; $4e28
	ld (hl),$0a		; $4e2a

	ld l,Enemy.direction		; $4e2c
	ld (hl),$ff		; $4e2e
	ld l,Enemy.speed		; $4e30
	ld (hl),SPEED_140		; $4e32

	ld l,Enemy.var32		; $4e34
	set 3,(hl)		; $4e36
	set 7,(hl)		; $4e38

	call _ecom_updateAngleTowardTarget		; $4e3a
	call _twinrova_calculateAnimationFromAngle		; $4e3d
	add $04			; $4e40
	ld (hl),a		; $4e42
	jp enemySetAnimation		; $4e43

;;
; @addr{4e46}
_twinrova_updateZPosition:
	ld h,d			; $4e46
	ld l,Enemy.var37		; $4e47
	ld a,(hl)		; $4e49
	or a			; $4e4a
	jr z,+			; $4e4b
	dec (hl)		; $4e4d
+
	ld l,Enemy.var32		; $4e4e
	bit 3,(hl)		; $4e50
	ret z			; $4e52

	ld l,Enemy.var31		; $4e53
	dec (hl)		; $4e55
	ld a,(hl)		; $4e56
	and $07			; $4e57
	ret nz			; $4e59

	ld a,(hl)		; $4e5a
	and $18			; $4e5b
	swap a			; $4e5d
	rlca			; $4e5f
	ld hl,@levitationZPositions		; $4e60
	rst_addAToHl			; $4e63
	ld e,Enemy.zh		; $4e64
	ld a,(hl)		; $4e66
	ld (de),a		; $4e67
	ret			; $4e68

@levitationZPositions:
	.db -3, -4, -5, -4

;;
; @addr{4e6d}
_twinrova_checkFireProjectile:
	ld h,d			; $4e6d
	ld l,Enemy.var32		; $4e6e
	bit 0,(hl)		; $4e70
	ret z			; $4e72

	bit 2,(hl)		; $4e73
	jr nz,@fireProjectile	; $4e75

	ld l,Enemy.collisionType		; $4e77
	bit 7,(hl)		; $4e79
	ret z			; $4e7b

	ld l,Enemy.var39		; $4e7c
	ld a,(hl)		; $4e7e
	or a			; $4e7f
	ld e,Enemy.animParameter		; $4e80
	jr z,@var39Zero	; $4e82

	dec (hl) ; [var39]
	ld a,(de) ; [animParameter]
	inc a			; $4e86
	ret nz			; $4e87

@var39Zero:
	dec a			; $4e88
	ld (de),a ; [animParameter] = $ff

	ld e,Enemy.angle		; $4e8a
	ld a,(de)		; $4e8c
	call _twinrova_calculateAnimationFromAngle		; $4e8d
	ld (hl),a		; $4e90
	add $04			; $4e91
	jp enemySetAnimation		; $4e93

@fireProjectile:
	res 2,(hl) ; [var32]

	ld l,Enemy.direction		; $4e98
	ld (hl),$ff		; $4e9a
	ld l,Enemy.var39		; $4e9c
	ld (hl),240		; $4e9e

	call @spawnProjectile		; $4ea0
	call objectGetAngleTowardEnemyTarget		; $4ea3
	cp $10			; $4ea6
	ld a,$00		; $4ea8
	jr c,+			; $4eaa
	inc a			; $4eac
+
	add $08			; $4ead
	jp enemySetAnimation		; $4eaf

;;
; @addr{4eb2}
@spawnProjectile:
	ld b,PARTID_RED_TWINROVA_PROJECTILE		; $4eb2
	ld e,Enemy.subid		; $4eb4
	ld a,(de)		; $4eb6
	or a			; $4eb7
	jr z,+			; $4eb8
	ld b,PARTID_BLUE_TWINROVA_PROJECTILE		; $4eba
+
	jp _ecom_spawnProjectile		; $4ebc

;;
; Unused?
;
; @param	h	Object to set target position to
; @addr{4ebf}
_twinrova_setTargetPositionToObject:
	ld l,Enemy.yh		; $4ebf
	ld e,l			; $4ec1
	ld b,(hl)		; $4ec2
	ld a,(de)		; $4ec3
	ldh (<hFF8F),a	; $4ec4
	ld l,Enemy.xh		; $4ec6
	ld e,l			; $4ec8
	ld c,(hl)		; $4ec9
	ld a,(de)		; $4eca
	ldh (<hFF8E),a	; $4ecb
	call _ecom_moveTowardPosition		; $4ecd
	jr _twinrova_updateMovingAnimation		; $4ed0


;;
; @addr{4ed2}
_twinrova_updateAnimationFromAngle:
	ld e,Enemy.angle		; $4ed2
	ld a,(de)		; $4ed4
	call _twinrova_calculateAnimationFromAngle		; $4ed5
	ret z			; $4ed8
	ld (hl),a		; $4ed9
	jp enemySetAnimation		; $4eda

;;
; @addr{4edd}
_twinrova_updateMovingAnimation:
	ld e,Enemy.angle		; $4edd
	ld a,(de)		; $4edf

;;
; @param	a	angle
; @addr{4ee0}
_twinrova_updateMovingAnimationGivenAngle:
	call _twinrova_calculateAnimationFromAngle		; $4ee0
	ret z			; $4ee3

	bit 7,(hl)		; $4ee4
	ret nz			; $4ee6

	ld b,a			; $4ee7
	ld e,Enemy.var37		; $4ee8
	ld a,(de)		; $4eea
	or a			; $4eeb
	ret nz			; $4eec

	ld a,30		; $4eed
	ld (de),a ; [var37]

	ld a,b			; $4ef0
	ld (hl),a ; [direction]
	add $04			; $4ef2
	jp enemySetAnimation		; $4ef4


;;
; @param	a	Angle value
; @param[out]	hl	Enemy.direction
; @param[out]	zflag	z if calculated animation is the same as current animation
; @addr{4ef7}
_twinrova_calculateAnimationFromAngle:
	ld c,a			; $4ef7
	add $04			; $4ef8
	and $18			; $4efa
	swap a			; $4efc
	rlca			; $4efe
	ld b,a			; $4eff
	ld h,d			; $4f00
	ld l,Enemy.direction		; $4f01
	ld a,c			; $4f03
	and $07			; $4f04
	cp $04			; $4f06
	ld a,b			; $4f08
	ret z			; $4f09
	cp (hl)			; $4f0a
	ret			; $4f0b

;;
; @param[out]	zflag	z if reached the end of the movement pattern
; @addr{4f0c}
_twinrova_subid0_updateTargetPosition:
	ld hl,_twinrova_subid0_targetPositions		; $4f0c
	jr ++			; $4f0f

;;
; @addr{4f11}
_twinrova_subid1_updateTargetPosition:
	ld hl,_twinrova_subid1_targetPositions		; $4f11
++
	ld e,Enemy.var37		; $4f14
	xor a			; $4f16
	ld (de),a		; $4f17

	ld e,Enemy.var34		; $4f18
	ld a,(de)		; $4f1a
	ld b,a			; $4f1b
	inc a			; $4f1c
	ld (de),a		; $4f1d

	dec e			; $4f1e
	ld a,(de) ; [var33]
	rst_addDoubleIndex			; $4f20
	ldi a,(hl)		; $4f21
	ld h,(hl)		; $4f22
	ld l,a			; $4f23

	ld a,b			; $4f24
	rst_addDoubleIndex			; $4f25
	ld e,Enemy.var35		; $4f26
	ldi a,(hl)		; $4f28
	or a			; $4f29
	ret z			; $4f2a

	ld (de),a		; $4f2b
	inc e			; $4f2c
	ld a,(hl)		; $4f2d
	ld (de),a		; $4f2e

;;
; @param[out]	cflag	c if reached target position
; @addr{4f2f}
_twinrova_moveTowardTargetPosition:
	ld h,d			; $4f2f
	ld l,Enemy.var35		; $4f30
	call _ecom_readPositionVars		; $4f32
	sub c			; $4f35
	inc a			; $4f36
	cp $03			; $4f37
	jr nc,@moveToward	; $4f39

	ldh a,(<hFF8F)	; $4f3b
	sub b			; $4f3d
	inc a			; $4f3e
	cp $03			; $4f3f
	ret c			; $4f41

@moveToward:
	call _ecom_moveTowardPosition		; $4f42
	call _twinrova_updateMovingAnimation		; $4f45
	call enemyAnimate		; $4f48
	or d			; $4f4b
	ret			; $4f4c

;;
; Randomly chooses either this object or its twin to begin an attack
; @addr{4f4d}
_twinrova_chooseObjectToAttack:
	call getRandomNumber_noPreserveVars		; $4f4d
	rrca			; $4f50
	ld h,d			; $4f51
	ld l,Enemy.var32		; $4f52
	jr nc,++		; $4f54

	ld a,Object.var32		; $4f56
	call objectGetRelatedObject1Var		; $4f58
++
	ld a,(hl)		; $4f5b
	or $05			; $4f5c
	ld (hl),a		; $4f5e
	ret			; $4f5f


;;
; Checks if an attack is in progress, unsets bit 0 of var32 when attack is done?
;
; @param[out]	zflag	nz if either twinrova is currently doing an attack
; @addr{4f60}
_twinrova_checkAttackInProgress:
	ld h,d			; $4f60
	ld l,Enemy.var32		; $4f61
	bit 0,(hl)		; $4f63
	jr nz,++		; $4f65

	ld a,Object.var32		; $4f67
	call objectGetRelatedObject1Var		; $4f69
	bit 0,(hl)		; $4f6c
	ret z			; $4f6e
++
	ld l,Enemy.direction		; $4f6f
	bit 7,(hl)		; $4f71
	ret nz			; $4f73

	ld l,Enemy.var32		; $4f74
	res 0,(hl)		; $4f76
	or d			; $4f78
	ret			; $4f79

;;
; @param[out]	zflag	z if Twinrova's risen to the desired height (-2)
; @addr{4f7a}
_twinrova_rise2PixelsAboveGround:
	ld h,d			; $4f7a
	ld l,Enemy.zh		; $4f7b
	ld a,(hl)		; $4f7d
	cp $fe			; $4f7e
	jr c,++			; $4f80
	dec (hl)		; $4f82
	ret			; $4f83
++
	ld l,Enemy.var32		; $4f84
	ld a,(hl)		; $4f86
	or $18			; $4f87
	ld (hl),a		; $4f89
	xor a			; $4f8a
	ret			; $4f8b

;;
; Unused?
; @addr{4f8c}
_twinrova_incState2ForSelfAndTwin:
	ld a,Object.state2		; $4f8c
	call objectGetRelatedObject1Var		; $4f8e
	inc (hl)		; $4f91
	ld h,d			; $4f92
	inc (hl)		; $4f93
	ret			; $4f94


_twinrova_subid0_targetPositions:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $50 $58
	.db $90 $a0
	.db $90 $b8
	.db $58 $d0
	.db $20 $b8
	.db $20 $a0
	.db $90 $40
	.db $90 $28
	.db $58 $18
	.db $20 $28
	.db $20 $40
	.db $00
@pattern1:
	.db $50 $58
	.db $70 $c0
	.db $80 $c0
	.db $90 $90
	.db $90 $60
	.db $80 $30
	.db $70 $30
	.db $40 $c0
	.db $30 $c0
	.db $20 $90
	.db $20 $60
	.db $30 $30
	.db $40 $30
	.db $00
@pattern2:
	.db $50 $58
	.db $80 $80
	.db $80 $a0
	.db $68 $c0
	.db $38 $c0
	.db $20 $a0
	.db $20 $50
	.db $30 $40
	.db $00
@pattern3:
	.db $50 $58
	.db $60 $70
	.db $80 $70
	.db $90 $40
	.db $60 $28
	.db $50 $58
	.db $50 $98
	.db $60 $c8
	.db $88 $b8
	.db $88 $a0
	.db $20 $80
	.db $20 $70
	.db $00


_twinrova_subid1_targetPositions:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $50 $98
	.db $90 $50
	.db $90 $38
	.db $58 $20
	.db $20 $38
	.db $20 $50
	.db $90 $b8
	.db $90 $c8
	.db $58 $d8
	.db $20 $c8
	.db $20 $b8
	.db $00
@pattern1:
	.db $50 $98
	.db $70 $30
	.db $80 $30
	.db $90 $60
	.db $90 $90
	.db $80 $c0
	.db $70 $c0
	.db $40 $30
	.db $30 $30
	.db $20 $60
	.db $20 $90
	.db $30 $c0
	.db $40 $c0
	.db $00
@pattern2:
	.db $50 $98
	.db $80 $70
	.db $80 $50
	.db $68 $30
	.db $38 $30
	.db $20 $50
	.db $20 $a0
	.db $30 $b0
	.db $00
@pattern3:
	.db $50 $98
	.db $50 $58
	.db $78 $48
	.db $90 $78
	.db $78 $a8
	.db $50 $20
	.db $30 $20
	.db $28 $40
	.db $60 $a0
	.db $50 $d0
	.db $30 $d0
	.db $28 $b0
	.db $00


; ==============================================================================
; ENEMYID_GANON
;
; Variables:
;   relatedObj1: ENEMYID_GANON_REVIVAL_CUTSCENE
;   relatedObj2: PARTID_SHADOW object
;   var30: Base x-position during teleport
;   var32: Related to animation for state A?
;   var35+: Pointer to sequence of attack states to iterate through
; ==============================================================================
enemyCode04:
	jr z,@normalStatus	; $505d
	sub ENEMYSTATUS_NO_HEALTH			; $505f
	ret c			; $5061
	jr nz,@normalStatus	; $5062

	; Dead
	call checkLinkVulnerable		; $5064
	ret nc			; $5067
	ld h,d			; $5068
	ld l,Enemy.health		; $5069
	ld (hl),$40		; $506b
	ld l,Enemy.state		; $506d
	ld (hl),$0e		; $506f
	inc l			; $5071
	ld (hl),$00 ; [state2]
	inc l			; $5074
	ld (hl),120 ; [counter1]

	ld a,$01		; $5077
	ld (wDisableLinkCollisionsAndMenu),a		; $5079

	ld a,SND_BOSS_DEAD		; $507c
	call playSound		; $507e

	ld a,GFXH_b4		; $5081
	call ganon_loadGfxHeader		; $5083

	ld a,$0e		; $5086
	call enemySetAnimation		; $5088

	call getThisRoomFlags		; $508b
	set 7,(hl)		; $508e
.ifdef ROOM_AGES
	ld l,<ROOM_AGES_5f1		; $5090
.else
	ld l,<ROOM_SEASONS_59a
.endif
	set 7,(hl)		; $5092
	ld l,<ROOM_TWINROVA_FIGHT		; $5094
	set 7,(hl)		; $5096

	ld a,SNDCTRL_STOPMUSIC		; $5098
	call playSound		; $509a
	ld bc,TX_2f0e		; $509d
	jp showText		; $50a0

@normalStatus:
	ld e,Enemy.state		; $50a3
	ld a,(de)		; $50a5
	rst_jumpTable			; $50a6
	.dw _ganon_state_uninitialized
	.dw _ganon_state1
	.dw _ganon_state2
	.dw _ganon_state3
	.dw _ganon_state4
	.dw _ganon_state5
	.dw _ganon_state6
	.dw _ganon_state7
	.dw _ganon_state8
	.dw _ganon_state9
	.dw _ganon_stateA
	.dw _ganon_stateB
	.dw _ganon_stateC
	.dw _ganon_stateD
	.dw _ganon_stateE


_ganon_state_uninitialized:
	ld h,d			; $50c5
	ld l,e			; $50c6
	inc (hl) ; [state] = 1

	ld l,Enemy.oamTileIndexBase		; $50c8
	ld (hl),$00		; $50ca
	ld l,Enemy.yh		; $50cc
	ld (hl),$48		; $50ce
	ld l,Enemy.xh		; $50d0
	ld (hl),$78		; $50d2
	ld l,Enemy.zh		; $50d4
	dec (hl)		; $50d6

	ld hl,w1Link.yh		; $50d7
	ld (hl),$88		; $50da
	ld l,<w1Link.xh		; $50dc
	ld (hl),$78		; $50de
	ld l,<w1Link.direction		; $50e0
	ld (hl),DIR_UP		; $50e2
	ld l,<w1Link.enabled		; $50e4
	ld (hl),$03		; $50e6

	; Load extra graphics for ganon
	ld hl,wLoadedObjectGfx		; $50e8
	ld a,$01		; $50eb
	ld (hl),OBJGFXH_16		; $50ed
	inc l			; $50ef
	ldi (hl),a		; $50f0
	ld (hl),OBJGFXH_18		; $50f1
	inc l			; $50f3
	ldi (hl),a		; $50f4
	ld (hl),OBJGFXH_19		; $50f5
	inc l			; $50f7
	ldi (hl),a		; $50f8
	ld (hl),OBJGFXH_1a		; $50f9
	inc l			; $50fb
	ldi (hl),a		; $50fc
	ld (hl),OBJGFXH_1b		; $50fd
	inc l			; $50ff
	ldi (hl),a		; $5100
	xor a			; $5101
	ldi (hl),a		; $5102
	ldi (hl),a		; $5103
	ldi (hl),a		; $5104
	ldi (hl),a		; $5105
	ldi (hl),a		; $5106
	ldi (hl),a		; $5107

	; Shadow as relatedObj2
	ld bc,$0012		; $5108
	call _enemyBoss_spawnShadow		; $510b
	ld e,Enemy.relatedObj2		; $510e
	ld a,Part.start		; $5110
	ld (de),a		; $5112
	inc e			; $5113
	ld a,h			; $5114
	ld (de),a		; $5115

	call disableLcd		; $5116
	ld a,<ROOM_TWINROVA_FIGHT		; $5119
	ld (wActiveRoom),a		; $511b
	ld a,$03		; $511e
	ld (wTwinrovaTileReplacementMode),a		; $5120

	call loadScreenMusicAndSetRoomPack		; $5123
	call loadTilesetData		; $5126
	call loadTilesetGraphics		; $5129
	call func_131f		; $512c
	call resetCamera		; $512f
	call loadCommonGraphics		; $5132

.ifdef ROM_AGES
	ld a,PALH_8b		; $5135
.else
	ld a,SEASONS_PALH_8b
.endif
	call loadPaletteHeader		; $5137
.ifdef ROM_AGES
	ld a,PALH_b1		; $513a
.else
	ld a,SEASONS_PALH_b1
.endif
	ld (wExtraBgPaletteHeader),a		; $513c
	ld a,GFXH_b0		; $513f
	call loadGfxHeader		; $5141
	ld a,$02		; $5144
	call loadGfxRegisterStateIndex		; $5146

	ldh a,(<hActiveObject)	; $5149
	ld d,a			; $514b
	call objectSetVisible83		; $514c

	jp fadeinFromWhite		; $514f


; Spawning ENEMYID_GANON_REVIVAL_CUTSCENE
_ganon_state1:
	call getFreeEnemySlot_uncounted		; $5152
	ret nz			; $5155
	ld (hl),ENEMYID_GANON_REVIVAL_CUTSCENE		; $5156
	ld l,Enemy.relatedObj1		; $5158
	ld (hl),Enemy.start		; $515a
	inc l			; $515c
	ld (hl),d		; $515d

	call _ecom_incState		; $515e
	ld l,Enemy.counter2		; $5161
	ld (hl),60		; $5163
	ret			; $5165


_ganon_state2:
	; Wait for signal?
	ld e,Enemy.counter1		; $5166
	ld a,(de)		; $5168
	or a			; $5169
	ret z			; $516a
	call _ecom_decCounter2		; $516b
	jp nz,_ecom_flickerVisibility		; $516e

	dec l			; $5171
	ld (hl),193 ; [counter1]
	ld l,Enemy.state		; $5174
	inc (hl)		; $5176
	ld a,$0d		; $5177
	call enemySetAnimation		; $5179
	jp objectSetVisible83		; $517c


; Rumbling while "skull" is on-screen
_ganon_state3:
	call _ecom_decCounter1		; $517f
	jr z,@nextState	; $5182

	ld a,(hl) ; [counter1]
	and $3f			; $5185
	ld a,SND_RUMBLE2		; $5187
	call z,playSound		; $5189
	jp enemyAnimate		; $518c

@nextState:
	ld l,e			; $518f
	inc (hl)		; $5190
	ld l,$8f		; $5191
	ld (hl),$00		; $5193
	ld a,$02		; $5195
	call objectGetRelatedObject2Var		; $5197
	ld (hl),$02		; $519a
	ld a,$01		; $519c
	jp enemySetAnimation		; $519e


; "Ball-like" animation, then ganon himself appears
_ganon_state4:
	ld e,Enemy.animParameter		; $51a1
	ld a,(de)		; $51a3
	inc a			; $51a4
	jp nz,enemyAnimate		; $51a5

	call _ecom_incState		; $51a8
	ld l,Enemy.counter1		; $51ab
	ld (hl),15		; $51ad

	ld a,GFXH_b1		; $51af
	call loadGfxHeader		; $51b1
	ld a,UNCMP_GFXH_32		; $51b4
	call loadUncompressedGfxHeader		; $51b6

	ld hl,wLoadedObjectGfx+2		; $51b9
	ld (hl),OBJGFXH_17		; $51bc
	inc l			; $51be
	ld (hl),$01		; $51bf

	ldh a,(<hActiveObject)	; $51c1
	ld d,a			; $51c3
	ld a,$02		; $51c4
	jp enemySetAnimation		; $51c6


; Brief delay
_ganon_state5:
	call _ecom_decCounter1		; $51c9
	ret nz			; $51cc

	ld a,120		; $51cd
	ld (hl),a ; [counter1]
	ld (wScreenShakeCounterY),a		; $51d0

	ld l,e			; $51d3
	inc (hl) ; [state] = 6

	ld a,SND_BOSS_DEAD	; $51d5
	call playSound		; $51d7

	ld a,$03		; $51da
	call enemySetAnimation		; $51dc

	call showStatusBar		; $51df
	ldh a,(<hActiveObject)	; $51e2
	ld d,a			; $51e4
	jp clearPaletteFadeVariablesAndRefreshPalettes		; $51e5


; "Roaring" as fight is about to begin
_ganon_state6:
	call _ecom_decCounter1		; $51e8
	jp nz,enemyAnimate		; $51eb

	ld (hl),30 ; [counter1]		; $51ee
	ld l,e			; $51f0
	inc (hl) ; [state] = 7

	ld hl,wLoadedObjectGfx+6		; $51f2
	xor a			; $51f5
	ldi (hl),a		; $51f6
	ldi (hl),a		; $51f7
	ldi (hl),a		; $51f8
	ldi (hl),a		; $51f9

	ld (wDisableLinkCollisionsAndMenu),a		; $51fa
	ld (wDisabledObjects),a		; $51fd

	ld bc,TX_2f0d		; $5200
	call showText		; $5203

	ld a,$02		; $5206
	jp enemySetAnimation		; $5208


; Fight begins
_ganon_state7:
	ld a,MUS_GANON		; $520b
	ld (wActiveMusic),a		; $520d
	call playSound		; $5210
	jp _ganon_decideNextMove		; $5213


; 3-projectile attack
_ganon_state8:
	inc e			; $5216
	ld a,(de) ; [state2]
	rst_jumpTable			; $5218
	.dw _ganon_state8_substate0
	.dw _ganon_state8_substate1
	.dw _ganon_state8_substate2
	.dw _ganon_state8_substate3
	.dw _ganon_state8_substate4
	.dw _ganon_state8_substate5
	.dw _ganon_state8_substate6
	.dw _ganon_state8_substate7

; Also used by state D
_ganon_state8_substate0:
	call _ganon_updateTeleportVarsAndPlaySound		; $5229
	ld l,Enemy.state2		; $522c
	inc (hl)		; $522e
	ret			; $522f

; Disappearing. Also used by state D
_ganon_state8_substate1:
	call _ecom_decCounter1		; $5230
	jp nz,_ganon_updateTeleportAnimationGoingOut		; $5233
	ld l,e			; $5236
	inc (hl) ; [state2]
	call _ganon_decideTeleportLocationAndCounter		; $5238
	jp objectSetInvisible		; $523b

; Delay before reappearing. Also used by state 9, C, D
_ganon_state8_substate2:
	call _ecom_decCounter1		; $523e
	ret nz			; $5241
	ld l,e			; $5242
	inc (hl) ; [state2]
	jp _ganon_updateTeleportVarsAndPlaySound		; $5244

; Reappearing.
_ganon_state8_substate3:
	call _ecom_decCounter1		; $5247
	jp nz,_ganon_updateTeleportAnimationComingIn		; $524a

	; Done teleporting, he will become solid again
	ld (hl),$08 ; [counter1]
	ld l,e			; $524f
	inc (hl) ; [state2]

	ld l,Enemy.var30		; $5251
	ld a,(hl)		; $5253
	ld l,Enemy.xh		; $5254
	ld (hl),a		; $5256

	ld l,Enemy.collisionType		; $5257
	set 7,(hl)		; $5259
	jp objectSetVisible83		; $525b

_ganon_state8_substate4:
	call _ecom_decCounter1		; $525e
	ret nz			; $5261
	ld (hl),$02		; $5262
	ld l,e			; $5264
	inc (hl) ; [state2]
	ld a,GFXH_b3		; $5266
	jp ganon_loadGfxHeader		; $5268

_ganon_state8_substate5:
	call _ecom_decCounter1		; $526b
	ret nz			; $526e
	ld (hl),45		; $526f
	ld l,e			; $5271
	inc (hl)		; $5272
	ld a,$05		; $5273
	call enemySetAnimation		; $5275
	call _ecom_updateAngleTowardTarget		; $5278
	ldbc $00,SPEED_180		; $527b
	jr _ganon_state8_spawnProjectile		; $527e

_ganon_state8_substate6:
	call _ecom_decCounter1		; $5280
	jr nz,++		; $5283
	ld (hl),60		; $5285
	ld l,e			; $5287
	inc (hl) ; [state2]
	ld a,$02		; $5289
	jp enemySetAnimation		; $528b
++
	ld a,(hl)		; $528e
	cp $19			; $528f
	ret nz			; $5291

	ldbc $02,SPEED_280		; $5292
	call _ganon_state8_spawnProjectile		; $5295

	ldbc $fe,SPEED_280		; $5298

_ganon_state8_spawnProjectile:
	ld e,PARTID_52		; $529b
	call _ganon_spawnPart		; $529d
	ret nz			; $52a0
	ld l,Part.angle		; $52a1
	ld e,Enemy.angle		; $52a3
	ld a,(de)		; $52a5
	add b			; $52a6
	and $1f			; $52a7
	ld (hl),a		; $52a9
	ld l,Part.speed		; $52aa
	ld (hl),c		; $52ac
	jp objectCopyPosition		; $52ad

_ganon_state8_substate7:
	call _ecom_decCounter1		; $52b0
	ret nz			; $52b3
	jp _ganon_finishAttack		; $52b4


; Projectile attack (4 projectiles turn into 3 smaller ones each)
_ganon_state9:
	inc e			; $52b7
	ld a,(de)		; $52b8
	rst_jumpTable			; $52b9
	.dw _ganon_state9_substate0
	.dw _ganon_state9_substate1
	.dw _ganon_state8_substate2
	.dw _ganon_state9_substate3
	.dw _ganon_state9_substate4
	.dw _ganon_state9_substate5
	.dw _ganon_state9_substate6
	.dw _ganon_state9_substate7

; Also used by state A, B, C
_ganon_state9_substate0:
	call _ganon_updateTeleportVarsAndPlaySound		; $52ca
	ld l,Enemy.state2		; $52cd
	inc (hl)		; $52cf
	ret			; $52d0

_ganon_state9_substate1:
	call _ecom_decCounter1		; $52d1
	jp nz,_ganon_updateTeleportAnimationGoingOut		; $52d4
	ld (hl),120 ; [counter1]
	ld l,e			; $52d9
	inc (hl) ; [state2]
	ld l,Enemy.yh		; $52db
	ld (hl),$58		; $52dd
	ld l,Enemy.xh		; $52df
	ld (hl),$78		; $52e1
	jp objectSetInvisible		; $52e3

_ganon_state9_substate3:
	call _ecom_decCounter1		; $52e6
	jp nz,_ganon_updateTeleportAnimationComingIn		; $52e9
	ld (hl),$08 ; [counter1]
	ld l,e			; $52ee
	inc (hl) ; [state2]
	ld l,Enemy.collisionType		; $52f0
	set 7,(hl)		; $52f2
	jp objectSetVisible83		; $52f4

_ganon_state9_substate4:
	call _ecom_decCounter1		; $52f7
	ret nz			; $52fa
	ld (hl),40 ; [counter1]
	ld l,e			; $52fd
	inc (hl) ; [state2]
	ld a,GFXH_b6		; $52ff
	call ganon_loadGfxHeader		; $5301
	ld a,$09		; $5304
	call enemySetAnimation		; $5306

	ld b,$1c		; $5309
	call @spawnProjectile		; $530b
	ld b,$14		; $530e
	call @spawnProjectile		; $5310
	ld b,$0c		; $5313
	call @spawnProjectile		; $5315
	ld b,$04		; $5318

@spawnProjectile:
	ld e,PARTID_52		; $531a
	call _ganon_spawnPart		; $531c
	ld l,Part.subid		; $531f
	inc (hl) ; [subid] = 1
	ld l,Part.angle		; $5322
	ld (hl),b		; $5324
	ld l,Part.relatedObj1+1		; $5325
	ld (hl),d		; $5327
	dec l			; $5328
	ld (hl),Enemy.start		; $5329
	jp objectCopyPosition		; $532b

_ganon_state9_substate5:
	call _ecom_decCounter1		; $532e
	ret nz			; $5331
	ld (hl),40 ; [counter1]
	ld l,e			; $5334
	inc (hl)		; $5335
	ld a,GFXH_b2		; $5336
	call ganon_loadGfxHeader		; $5338
	ld a,$07		; $533b
	jp enemySetAnimation		; $533d

_ganon_state9_substate6:
	call _ecom_decCounter1		; $5340
	ret nz			; $5343
	ld (hl),80		; $5344
	ld l,e			; $5346
	inc (hl)		; $5347
	ld a,$02		; $5348
	jp enemySetAnimation		; $534a

_ganon_state9_substate7:
	call _ecom_decCounter1		; $534d
	ret nz			; $5350
	jp _ganon_finishAttack		; $5351


; "Slash" move
_ganon_stateA:
	inc e			; $5354
	ld a,(de) ; [state2]
	rst_jumpTable			; $5356
	.dw _ganon_state9_substate0
	.dw _ganon_stateA_substate1
	.dw _ganon_stateA_substate2
	.dw _ganon_stateA_substate3
	.dw _ganon_stateA_substate4
	.dw _ganon_stateA_substate5
	.dw _ganon_stateA_substate6
	.dw _ganon_stateA_substate7

; Teleporting out
_ganon_stateA_substate1:
	call _ecom_decCounter1		; $5367
	jp nz,_ganon_updateTeleportAnimationGoingOut		; $536a

	ld (hl),120		; $536d
	ld l,e			; $536f
	inc (hl) ; [state2]
	jp objectSetInvisible		; $5371

; Delay before reappearing
_ganon_stateA_substate2:
	call _ecom_decCounter1		; $5374
	ret nz			; $5377

	ld l,e			; $5378
	inc (hl) ; [state2]

	ldh a,(<hEnemyTargetX)	; $537a
	cp (LARGE_ROOM_WIDTH<<4)/2			; $537c
	ldbc $03,$28		; $537e
	jr c,+			; $5381
	ldbc $00,-$28		; $5383
+
	ld l,Enemy.var32		; $5386
	ld (hl),b		; $5388
	add c			; $5389
	ld l,Enemy.xh		; $538a
	ldd (hl),a		; $538c
	ldh a,(<hEnemyTargetY)	; $538d
	cp $30			; $538f
	jr c,+			; $5391
	sub $18			; $5393
+
	dec l			; $5395
	ld (hl),a ; [yh]

	ld a,GFXH_b2		; $5397
	call ganon_loadGfxHeader		; $5399
	ld e,Enemy.var32		; $539c
	ld a,(de)		; $539e
	add $07			; $539f
	call enemySetAnimation		; $53a1
	jp _ganon_updateTeleportVarsAndPlaySound		; $53a4

_ganon_stateA_substate3:
	call _ecom_decCounter1		; $53a7
	jp nz,_ganon_updateTeleportAnimationComingIn		; $53aa
	ld (hl),$02		; $53ad
	ld l,e			; $53af
	inc (hl) ; [state2]
	ld l,Enemy.collisionType		; $53b1
	set 7,(hl)		; $53b3
	ld l,Enemy.speed		; $53b5
	ld (hl),SPEED_300		; $53b7
	call _ecom_updateAngleTowardTarget		; $53b9
	ld e,PARTID_50		; $53bc
	call _ganon_spawnPart		; $53be
	jp objectSetVisible83		; $53c1

_ganon_stateA_substate4:
	call _ecom_decCounter1		; $53c4
	ret nz			; $53c7
	ld (hl),$04		; $53c8
	ld l,e			; $53ca
	inc (hl) ; [state2]
	ld a,Enemy.var37		; $53cc
	call ganon_loadGfxHeader		; $53ce
	ld e,Enemy.var32		; $53d1
	ld a,(de)		; $53d3
	add $08			; $53d4
	call enemySetAnimation		; $53d6

_ganon_stateA_substate5:
	call _ecom_decCounter1		; $53d9
	jr nz,+++		; $53dc
	ld (hl),16		; $53de
	ld l,e			; $53e0
	inc (hl) ; [state2]
	ld a,GFXH_b6		; $53e2
	call ganon_loadGfxHeader		; $53e4
	ld e,Enemy.var32		; $53e7
	ld a,(de)		; $53e9
	add $09			; $53ea
	jp enemySetAnimation		; $53ec

_ganon_stateA_substate6:
	call _ecom_decCounter1		; $53ef
	jr nz,+++		; $53f2
	ld l,e			; $53f4
	inc (hl) ; [state2]
	inc l			; $53f6
	ld (hl),30 ; [counter1]
	ret			; $53f9
+++
	ld e,Enemy.yh		; $53fa
	ld a,(de)		; $53fc
	sub $18			; $53fd
	cp $80			; $53ff
	ret nc			; $5401
	ld e,Enemy.xh		; $5402
	ld a,(de)		; $5404
	sub $18			; $5405
	cp $c0			; $5407
	ret nc			; $5409
	jp objectApplySpeed		; $540a

_ganon_stateA_substate7:
	call _ecom_decCounter1		; $540d
	ret nz			; $5410
	ld a,$02		; $5411
	call enemySetAnimation		; $5413
	jp _ganon_finishAttack		; $5416


; The attack with the big exploding ball
_ganon_stateB:
	inc e			; $5419
	ld a,(de)		; $541a
	rst_jumpTable			; $541b
	.dw _ganon_state9_substate0
	.dw _ganon_stateB_substate1
	.dw _ganon_stateB_substate2
	.dw _ganon_stateB_substate3
	.dw _ganon_stateB_substate4
	.dw _ganon_stateB_substate5
	.dw _ganon_stateB_substate6
	.dw _ganon_stateB_substate7
	.dw _ganon_stateB_substate8
	.dw _ganon_stateB_substate9
	.dw _ganon_stateB_substateA

_ganon_stateB_substate1:
	call _ecom_decCounter1		; $5432
	jp nz,_ganon_updateTeleportAnimationGoingOut		; $5435
	ld (hl),180		; $5438
	ld l,e			; $543a
	inc (hl) ; [state2]
	jp objectSetInvisible		; $543c

_ganon_stateB_substate2:
	call _ecom_decCounter1		; $543f
	ret nz			; $5442
	ld l,e			; $5443
	inc (hl) ; [state2]
	ld l,Enemy.yh		; $5445
	ld (hl),$28		; $5447
	ld l,Enemy.xh		; $5449
	ld (hl),$78		; $544b
	ld a,GFXH_b2		; $544d
	call ganon_loadGfxHeader		; $544f
	ld a,$04		; $5452
	call enemySetAnimation		; $5454
	jp _ganon_updateTeleportVarsAndPlaySound		; $5457

_ganon_stateB_substate3:
	call _ecom_decCounter1		; $545a
	jp nz,_ganon_updateTeleportAnimationComingIn		; $545d
	ld (hl),$40 ; [counter1]
	ld l,e			; $5462
	inc (hl) ; [state2]
	ld l,Enemy.collisionType		; $5464
	set 7,(hl)		; $5466
	call objectSetVisible83		; $5468
	ld e,PARTID_51		; $546b
	call _ganon_spawnPart		; $546d
	ret nz			; $5470
	ld bc,$f810		; $5471
	jp objectCopyPositionWithOffset		; $5474

_ganon_stateB_substate4:
	call _ecom_decCounter1		; $5477
	ret nz			; $547a
	ld l,e			; $547b
	inc (hl) ; [state2]
	ld l,Enemy.speedZ		; $547d
	ld a,<(-$1c0)		; $547f
	ldi (hl),a		; $5481
	ld (hl),>(-$1c0)		; $5482
	ld a,GFXH_b3		; $5484
	call ganon_loadGfxHeader		; $5486
	ld a,$05		; $5489
	jp enemySetAnimation		; $548b

_ganon_stateB_substate5:
	ld c,$20		; $548e
	call objectUpdateSpeedZ_paramC		; $5490
	jr z,++			; $5493
	ldd a,(hl)		; $5495
	or a			; $5496
	ret nz			; $5497
	ld a,(hl)		; $5498
	cp $c0			; $5499
	ret nz			; $549b
	ld a,GFXH_b5		; $549c
	call ganon_loadGfxHeader		; $549e
	ld a,$06		; $54a1
	jp enemySetAnimation		; $54a3
++
	ld l,Enemy.counter1		; $54a6
	ld a,120		; $54a8
	ld (hl),a		; $54aa
	ld (wScreenShakeCounterY),a		; $54ab
	ld l,Enemy.state2		; $54ae
	inc (hl)		; $54b0
	ld a,SND_EXPLOSION		; $54b1
	jp playSound		; $54b3

_ganon_stateB_substate6:
	call _ecom_decCounter1		; $54b6
	jr z,++			; $54b9
	ld a,(hl)		; $54bb
	cp 105			; $54bc
	ret c			; $54be
	ld a,(w1Link.zh)		; $54bf
	rlca			; $54c2
	ret c			; $54c3
	ld hl,wLinkForceState		; $54c4
	ld a,LINK_STATE_COLLAPSED		; $54c7
	ldi (hl),a		; $54c9
	ld (hl),$00 ; [wcc50]
	ret			; $54cc
++
	ld (hl),$04		; $54cd
	ld l,e			; $54cf
	inc (hl)		; $54d0
	ld a,GFXH_b2		; $54d1
	call ganon_loadGfxHeader		; $54d3
	ld a,$04		; $54d6
	jp enemySetAnimation		; $54d8

_ganon_stateB_substate7:
	call _ecom_decCounter1		; $54db
	ret nz			; $54de
	ld (hl),24 ; [counter1]
	ld l,e			; $54e1
	inc (hl) ; [state2]
	ld e,PARTID_51		; $54e3
	call _ganon_spawnPart		; $54e5
	ret nz			; $54e8
	ld l,Part.subid		; $54e9
	inc (hl)		; $54eb
	ld bc,$f810		; $54ec
	jp objectCopyPositionWithOffset		; $54ef

_ganon_stateB_substate8:
	call _ecom_decCounter1		; $54f2
	ret nz			; $54f5
	ld (hl),60		; $54f6
	ld l,e			; $54f8
	inc (hl) ; [state2]
	call objectCreatePuff		; $54fa
	ld a,GFXH_b3		; $54fd
	call ganon_loadGfxHeader		; $54ff
	ld a,$05		; $5502
	jp enemySetAnimation		; $5504

_ganon_stateB_substate9:
	call _ecom_decCounter1		; $5507
	ret nz			; $550a
	ld (hl),60		; $550b
	ld l,e			; $550d
	inc (hl)		; $550e
	ld a,$02		; $550f
	jp enemySetAnimation		; $5511

_ganon_stateB_substateA:
	call _ecom_decCounter1		; $5514
	ret nz			; $5517
	jp _ganon_finishAttack		; $5518


; Inverted controls
_ganon_stateC:
	inc e			; $551b
	ld a,(de)		; $551c
	rst_jumpTable			; $551d
	.dw _ganon_state9_substate0
	.dw _ganon_stateC_substate1
	.dw _ganon_state8_substate2
	.dw _ganon_stateC_substate3
	.dw _ganon_stateC_substate4
	.dw _ganon_stateC_substate5
	.dw _ganon_stateC_substate6
	.dw _ganon_stateC_substate7
	.dw _ganon_stateC_substate8
	.dw _ganon_stateC_substate9
	.dw _ganon_stateC_substateA

_ganon_stateC_substate1:
	call _ecom_decCounter1		; $5534
	jp nz,_ganon_updateTeleportAnimationGoingOut		; $5537
	ld (hl),90 ; [counter1]
	ld l,e			; $553c
	inc (hl) ; [state2]
	ld l,Enemy.yh		; $553e
	ld (hl),$58		; $5540
	ld l,Enemy.xh		; $5542
	ld (hl),$78		; $5544
	jp objectSetInvisible		; $5546

_ganon_stateC_substate3:
	call _ecom_decCounter1		; $5549
	jp nz,_ganon_updateTeleportAnimationComingIn		; $554c
	ld (hl),90 ; [counter1]
	ld l,e			; $5551
	inc (hl) ; [state2]
	ld l,Enemy.collisionType		; $5553
	set 7,(hl)		; $5555
	call objectSetVisible83		; $5557
	ld a,SND_FADEOUT		; $555a
	jp playSound		; $555c

_ganon_stateC_substate4:
	call _ecom_decCounter1		; $555f
	jr z,@nextSubstate	; $5562
	ld a,(hl) ; [counter1]
	cp 60			; $5565
	ret nc			; $5567

	and $03			; $5568
	ret nz			; $556a
	ld l,Enemy.oamFlagsBackup		; $556b
	ld a,(hl)		; $556d
	xor $05			; $556e
	ldi (hl),a		; $5570
	ld (hl),a		; $5571
	ret			; $5572

@nextSubstate:
	ld l,Enemy.health		; $5573
	ld a,(hl)		; $5575
	or a			; $5576
	ret z			; $5577

	ld l,e			; $5578
	inc (hl) ; [state2]
	ld l,Enemy.collisionType		; $557a
	res 7,(hl)		; $557c
	ld l,Enemy.oamFlagsBackup		; $557e
	ld a,$01		; $5580
	ldi (hl),a		; $5582
	ld (hl),a		; $5583
	ld a,$02		; $5584
	jp fadeoutToBlackWithDelay		; $5586

_ganon_stateC_substate5:
	ld a,(wPaletteThread_mode)		; $5589
	or a			; $558c
	ret nz			; $558d
	ld a,$06		; $558e
	ld (de),a ; [state2]
	ld a,$04		; $5591
	call _ganon_setTileReplacementMode		; $5593
	jp _ganon_makeRoomBoundarySolid		; $5596

_ganon_stateC_substate6:
	ld h,d			; $5599
	ld l,e			; $559a
	inc (hl) ; [state2]
	inc l			; $559c
	ld (hl),60 ; [counter1]

	ld l,Enemy.collisionType		; $559f
	set 7,(hl)		; $55a1
	ld l,Enemy.speed		; $55a3
	ld (hl),SPEED_80		; $55a5

	call getRandomNumber_noPreserveVars		; $55a7
	and $07			; $55aa
	ld hl,@counter2Vals		; $55ac
	rst_addAToHl			; $55af
	ld e,Enemy.counter2		; $55b0
	ld a,(hl)		; $55b2
	ld (de),a		; $55b3
	jp fadeinFromBlack		; $55b4

@counter2Vals:
	.db 50,80,80,90,90,90,90,150

_ganon_stateC_substate7:
	ld a,$02		; $55bf
	ld (wUseSimulatedInput),a		; $55c1
	ld a,(wFrameCounter)		; $55c4
	and $03			; $55c7
	jr nz,++		; $55c9
	call _ecom_decCounter2		; $55cb
	jr nz,++		; $55ce

	ld l,Enemy.state2		; $55d0
	inc (hl)		; $55d2
	inc (hl) ; [state2] = 9
	ld l,Enemy.collisionType		; $55d4
	res 7,(hl)		; $55d6
	jp fastFadeoutToWhite		; $55d8
++
	call _ecom_decCounter1		; $55db
	jr nz,++		; $55de
	ld l,e			; $55e0
	inc (hl) ; [state2] = 8
	ld l,Enemy.counter1		; $55e2
	ld (hl),80		; $55e4
	ld a,GFXH_b3		; $55e6
	jp ganon_loadGfxHeader		; $55e8
++
	call _ecom_updateAngleTowardTarget		; $55eb
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $55ee
	call enemyAnimate		; $55f1
	jp _ganon_updateSeizurePalette		; $55f4

_ganon_stateC_substate8:
	ld a,$02		; $55f7
	ld (wUseSimulatedInput),a		; $55f9
	call _ganon_updateSeizurePalette		; $55fc

	ld a,(wFrameCounter)		; $55ff
	and $03			; $5602
	call z,_ecom_decCounter2		; $5604
	call _ecom_decCounter1		; $5607
	jr z,@nextSubstate	; $560a

	ld a,(hl) ; [counter1]
	cp 60			; $560d
	ret nz			; $560f

	ld a,$05		; $5610
	call enemySetAnimation		; $5612
	ld e,PARTID_52		; $5615
	call _ganon_spawnPart		; $5617
	ret nz			; $561a
	ld l,Part.subid		; $561b
	ld (hl),$02		; $561d
	jp objectCopyPosition		; $561f

@nextSubstate:
	ld l,Enemy.state2		; $5622
	dec (hl)		; $5624
	inc l			; $5625
	ld (hl),60		; $5626
	ld a,$02		; $5628
	jp enemySetAnimation		; $562a

_ganon_stateC_substate9:
	ld a,(wPaletteThread_mode)		; $562d
	or a			; $5630
	ret nz			; $5631
	ld a,$0a		; $5632
	ld (de),a ; [state2]
	ld a,$03		; $5635
	call _ganon_setTileReplacementMode		; $5637
.ifdef ROM_AGES
	ld a,PALH_b1		; $563a
.else
	ld a,SEASONS_PALH_b1
.endif
	ld (wExtraBgPaletteHeader),a		; $563c
	jp loadPaletteHeader		; $563f

_ganon_stateC_substateA:
	ld h,d			; $5642
	ld l,Enemy.collisionType		; $5643
	set 7,(hl)		; $5645
	call clearPaletteFadeVariablesAndRefreshPalettes		; $5647
	jp _ganon_finishAttack		; $564a


; Teleports in an out without doing anything
_ganon_stateD:
	inc e			; $564d
	ld a,(de)		; $564e
	rst_jumpTable			; $564f
	.dw _ganon_state8_substate0
	.dw _ganon_state8_substate1
	.dw _ganon_state8_substate2
	.dw _ganon_stateD_substate3
	.dw _ganon_finishAttack

_ganon_stateD_substate3:
	call _ecom_decCounter1		; $565a
	jp nz,_ganon_updateTeleportAnimationComingIn		; $565d
	ld l,e			; $5660
	inc (hl) ; [state2]
	ld l,Enemy.var30		; $5662
	ld a,(hl)		; $5664
	ld l,Enemy.xh		; $5665
	ld (hl),a		; $5667
	jp objectSetVisible83		; $5668


; Just died
_ganon_stateE:
	inc e			; $566b
	ld a,(de) ; [state2]
	rst_jumpTable			; $566d
	.dw _ganon_stateE_substate0
	.dw _ganon_stateE_substate1
	.dw _ganon_stateE_substate2
	.dw _ganon_stateE_substate3

_ganon_stateE_substate0:
	call _ecom_decCounter1		; $5676
	jp nz,_ecom_flickerVisibility		; $5679

	inc (hl)		; $567c
	ld e,PARTID_BOSS_DEATH_EXPLOSION		; $567d
	call _ganon_spawnPart		; $567f
	ret nz			; $5682
	ld l,Part.subid		; $5683
	inc (hl) ; [subid] = 1
	call objectCopyPosition		; $5686
	ld e,Enemy.relatedObj2		; $5689
	ld a,Part.start		; $568b
	ld (de),a		; $568d
	inc e			; $568e
	ld a,h			; $568f
	ld (de),a		; $5690
	ld hl,wNumEnemies		; $5691
	inc (hl)		; $5694

	ld h,d			; $5695
	ld l,Enemy.state2		; $5696
	inc (hl)		; $5698
	ld l,Enemy.zh		; $5699
	ld (hl),$00		; $569b

	call objectSetInvisible		; $569d
	ld a,SND_BIG_EXPLOSION_2		; $56a0
	jp playSound		; $56a2

_ganon_stateE_substate1:
	ld a,Object.animParameter		; $56a5
	call objectGetRelatedObject2Var		; $56a7
	bit 7,(hl)		; $56aa
	ret z			; $56ac
	ld h,d			; $56ad
	ld l,Enemy.state2		; $56ae
	inc (hl)		; $56b0
	inc l			; $56b1
	ld (hl),$08 ; [counter1]
	jp fastFadeoutToWhite		; $56b4

_ganon_stateE_substate2:
	call _ecom_decCounter1		; $56b7
	ret nz			; $56ba
	ld (hl),30 ; [counter1]
	ld l,e			; $56bd
	inc (hl) ; [state2]
	xor a			; $56bf
	ld (wExtraBgPaletteHeader),a		; $56c0
	call _ganon_setTileReplacementMode		; $56c3
	ld a,$02		; $56c6
	jp fadeinFromWhiteWithDelay		; $56c8

_ganon_stateE_substate3:
	ld a,(wPaletteThread_mode)		; $56cb
	or a			; $56ce
	ret nz			; $56cf
	call _ecom_decCounter1		; $56d0
	ret nz			; $56d3
	xor a			; $56d4
	ld (wDisableLinkCollisionsAndMenu),a		; $56d5
	call decNumEnemies		; $56d8
	jp enemyDelete		; $56db

;;
; @addr{56de}
ganon_loadGfxHeader:
	push af			; $56de
	call loadGfxHeader		; $56df
	ld a,UNCMP_GFXH_33		; $56e2
	call loadUncompressedGfxHeader		; $56e4
	pop af			; $56e7
	sub GFXH_b2			; $56e8
	add OBJGFXH_1e			; $56ea
	ld hl,wLoadedObjectGfx+4		; $56ec
	ldi (hl),a		; $56ef
	ld (hl),$01		; $56f0
	ldh a,(<hActiveObject)	; $56f2
	ld d,a			; $56f4
	ret			; $56f5

;;
; X-position alternates left & right each frame while teleporting.
;
; @param	hl	counter1?
; @addr{56f6}
_ganon_updateTeleportAnimationGoingOut:
	ld a,(hl)		; $56f6
	and $3e			; $56f7
	rrca			; $56f9
	ld b,a			; $56fa
	ld a,$20		; $56fb
	sub b			; $56fd

_ganon_updateFlickeringXPosition:
	bit 1,(hl)		; $56fe
	jr z,+			; $5700
	cpl			; $5702
	inc a			; $5703
+
	ld l,Enemy.var30		; $5704
	add (hl)		; $5706
	ld l,Enemy.xh		; $5707
	ld (hl),a		; $5709
	jp _ecom_flickerVisibility		; $570a

;;
; @addr{570d}
_ganon_updateTeleportVarsAndPlaySound:
	ld a,SND_TELEPORT		; $570d
	call playSound		; $570f

	ld h,d			; $5712
	ld l,Enemy.collisionType		; $5713
	res 7,(hl)		; $5715

	ld l,Enemy.counter1		; $5717
	ld (hl),60		; $5719
	ld l,Enemy.xh		; $571b
	ld a,(hl)		; $571d
	ld l,Enemy.var30		; $571e
	ld (hl),a		; $5720
	ret			; $5721

;;
; @param	hl	counter1?
; @addr{5722}
_ganon_updateTeleportAnimationComingIn:
	ld a,(hl)		; $5722
	and $3e			; $5723
	rrca			; $5725
	jr _ganon_updateFlickeringXPosition		; $5726

;;
; @addr{5728}
_ganon_finishAttack:
	ld h,d			; $5728
	ld l,Enemy.var35		; $5729
	ldi a,(hl)		; $572b
	ld h,(hl)		; $572c
	ld l,a			; $572d
	ldi a,(hl)		; $572e
	or a			; $572f
	jr z,_ganon_decideNextMove	; $5730

_label_10_135:
	ld e,Enemy.state		; $5732
	ld (de),a		; $5734
	inc e			; $5735
	xor a			; $5736
	ld (de),a ; [state2]
	ld e,Enemy.var35		; $5738
	ld a,l			; $573a
	ld (de),a		; $573b
	inc e			; $573c
	ld a,h			; $573d
	ld (de),a		; $573e
	ret			; $573f


;;
; Sets state to something randomly?
; @addr{5740}
_ganon_decideNextMove:
	ld e,Enemy.health		; $5740
	ld a,(de)		; $5742
	cp $41			; $5743
	ld c,$00		; $5745
	jr nc,+			; $5747
	ld c,$04		; $5749
+
	call getRandomNumber		; $574b
	and $03			; $574e
	add c			; $5750
	ld hl,@stateTable		; $5751
	rst_addDoubleIndex			; $5754
	ldi a,(hl)		; $5755
	ld h,(hl)		; $5756
	ld l,a			; $5757
	ldi a,(hl)		; $5758
	jr _label_10_135		; $5759

@stateTable:
	.dw @choice0
	.dw @choice1
	.dw @choice2
	.dw @choice3
	.dw @choice4
	.dw @choice5
	.dw @choice6
	.dw @choice7

; This is a list of states (attack parts) to iterate through. When it reaches the 0 terminator, it
; calls the above function again to make a new choice.
;
; 0-3 are for Ganon at high health.
@choice0:
	.db $08 $0a $09
	.db $00
@choice1:
	.db $09
	.db $00
@choice2:
	.db $0a $08 $09 $0a
	.db $00
@choice3:
	.db $0a $08
	.db $00

; 4-7 are for Ganon at low health.
@choice4:
	.db $0c
	.db $00
@choice5:
	.db $0b $0d $08 $0a
	.db $00
@choice6:
	.db $0b $0c $09 $0a
	.db $00
@choice7:
	.db $0d
	.db $00


;;
; @addr{5787}
_ganon_decideTeleportLocationAndCounter:
	ld bc,$0e0f		; $5787
	call _ecom_randomBitwiseAndBCE		; $578a
	ld a,b			; $578d
	ld hl,@teleportTargetTable		; $578e
	rst_addAToHl			; $5791
	ld e,Enemy.yh		; $5792
	ldi a,(hl)		; $5794
	ld (de),a		; $5795
	ld e,Enemy.xh		; $5796
	ld a,(hl)		; $5798
	ld (de),a		; $5799

	ld a,c			; $579a
	ld hl,@counter1Vals		; $579b
	rst_addAToHl			; $579e
	ld e,Enemy.counter1		; $579f
	ld a,(hl)		; $57a1
	ld (de),a		; $57a2
	ret			; $57a3

; List of valid positions to teleport to
@teleportTargetTable:
	.db $30 $38
	.db $30 $78
	.db $30 $b8
	.db $58 $58
	.db $58 $98
	.db $80 $38
	.db $80 $78
	.db $80 $b8

@counter1Vals:
	.db 40 40 40 60 60 60 60 60
	.db 60 90 90 90 90 90 120 120


;;
; @param	e	Part ID
; @addr{57c4}
_ganon_spawnPart:
	call getFreePartSlot		; $57c4
	ret nz			; $57c7
	ld (hl),e		; $57c8
	ld l,Part.relatedObj1		; $57c9
	ld (hl),Enemy.start		; $57cb
	inc l			; $57cd
	ld (hl),d		; $57ce
	xor a			; $57cf
	ret			; $57d0

;;
; Sets the boundaries of the room to be solid when "reversed controls" happen; most likely because
; the wall tiles are removed when in this state, so collisions must be set manually.
; @addr{57d1}
_ganon_makeRoomBoundarySolid:
	ld hl,wRoomCollisions+$10		; $57d1
	ld b,LARGE_ROOM_HEIGHT-2		; $57d4
--
	ld (hl),$0f		; $57d6
	ld a,l			; $57d8
	add $10			; $57d9
	ld l,a			; $57db
	dec b			; $57dc
	jr nz,--

	ld l,$0f + LARGE_ROOM_WIDTH		; $57df
	ld b,LARGE_ROOM_HEIGHT-2		; $57e1
--
	ld (hl),$0f		; $57e3
	ld a,l			; $57e5
	add $10			; $57e6
	ld l,a			; $57e8
	dec b			; $57e9
	jr nz,--

	ld l,$00		; $57ec
	ld a,$0f		; $57ee
	ld b,a ; LARGE_ROOM_WIDTH
--
	ldi (hl),a		; $57f1
	dec b			; $57f2
	jr nz,--

	ld l,(LARGE_ROOM_HEIGHT-1)<<4		; $57f5
	ld b,a			; $57f7
--
	ldi (hl),a		; $57f8
	dec b			; $57f9
	jr nz,--		; $57fa
	ret			; $57fc

;;
; Updates palettes in reversed-control mode
; @addr{57fd}
_ganon_updateSeizurePalette:
	ld a,(wScrollMode)		; $57fd
	and $01			; $5800
	ret z			; $5802
	ld a,(wPaletteThread_mode)		; $5803
	or a			; $5806
	ret nz			; $5807
	ld a,(wFrameCounter)		; $5808
	rrca			; $580b
	ret c			; $580c
	ld h,d			; $580d
	ld l,$b7		; $580e
	ld a,(hl)		; $5810
	inc (hl)		; $5811
	and $07			; $5812
.ifdef ROM_AGES
	add a,PALH_b1		; $5814
.else
	add a,SEASONS_PALH_b1
.endif
	ld (wExtraBgPaletteHeader),a		; $5816
	jp loadPaletteHeader		; $5819


;;
; @addr{581c}
_ganon_setTileReplacementMode:
	ld (wTwinrovaTileReplacementMode),a		; $581c
	call func_131f		; $581f
	ldh a,(<hActiveObject)	; $5822
	ld d,a			; $5824
	ret			; $5825

;;
; @addr{5826}
enemyCode00:
	ret			; $5826


; ==============================================================================
; ENEMYID_GENERAL_ONOX
; ==============================================================================
enemyCode02:
	jr z,@normalStatus	; $5835
	sub ENEMYSTATUS_NO_HEALTH			; $5837
	ret c			; $5839
	jr nz,@justHit	; $583a
	; dead
	ld e,$a4		; $583c
	ld a,(de)		; $583e
	or a			; $583f
	jr z,@dying	; $5840
	ld a,$f0		; $5842
	call playSound		; $5844
@dying:
	ld e,$b2		; $5847
	ld a,(de)		; $5849
	or a			; $584a
	jr nz,@dead	; $584b
	call checkLinkCollisionsEnabled		; $584d
	jr nc,@dead	; $5850
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
@dead:
	jp _enemyBoss_dead		; $586b
@justHit:
	ld e,$82		; $586e
	ld a,(de)		; $5870
	or a			; $5871
	call z,_generalOnox_func_5c75		; $5872
@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $5875
	jr nc,+			; $5878
	rst_jumpTable			; $587a
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	ld a,b			; $588b
	rst_jumpTable			; $588c
	.dw _generalOnox_subid0
	.dw _generalOnox_subid1
	.dw _generalOnox_subid2

@state0:
	ld a,b			; $5893
	cp $02			; $5894
	jr z,+			; $5896
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
+
	ld a,$89		; $58b0
	call loadPaletteHeader		; $58b2
	ld a,$01		; $58b5
	ld ($cfcf),a		; $58b7
	ld ($cbca),a		; $58ba
	call _ecom_setSpeedAndState8		; $58bd
	ld a,$53		; $58c0
	jp playSound		; $58c2
	
@stateStub:
	ret			; $58c5
	
_generalOnox_subid0:
	ld a,(de)		; $58c6
	sub $08			; $58c7
	rst_jumpTable			; $58c9
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state8:
	ld b,PARTID_47		; $58d4
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

@state9:
	inc e			; $58ed
	ld a,(de)		; $58ee
	rst_jumpTable			; $58ef
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
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
	
@@substate1:
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
	
@@substate2:
	call _ecom_decCounter1		; $5929
	ret nz			; $592c
	ld l,e			; $592d
	inc (hl)		; $592e
	ld bc,TX_501c		; $592f
	call checkIsLinkedGame		; $5932
	jr z,+			; $5935
	ld c,<TX_5020		; $5937
+
	jp showText		; $5939
	
@@substate3:
	ld e,$90		; $593c
	ld a,$0f		; $593e
	ld (de),a		; $5940
	ld a,$2e		; $5941
	ld (wActiveMusic),a		; $5943
	call playSound		; $5946
	ld a,$04		; $5949
	call objectGetRelatedObject2Var		; $594b
	inc (hl)		; $594e

@func_594f:
	ld h,d			; $594f
	ld l,$84		; $5950
	ld (hl),$0a		; $5952
	inc l			; $5954
	ld (hl),$00		; $5955
	inc l			; $5957
	ld (hl),$2d		; $5958
	ld a,$02		; $595a
	jp enemySetAnimation		; $595c
	
@stateA:
	call _ecom_decCounter1		; $595f
	ret nz			; $5962
	ld (hl),$b4		; $5963
	inc l			; $5965
	ld (hl),$0a		; $5966
	ld l,e			; $5968
	inc (hl)		; $5969
	jr @stateB@func_59c0		; $596a
	
@stateB:
	inc e			; $596c
	ld a,(de)		; $596d
	rst_jumpTable			; $596e
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
	call _ecom_decCounter1		; $5975
	jr nz,@@func_598b	; $5978
	ld a,$24		; $597a
	call objectGetRelatedObject2Var		; $597c
	res 7,(hl)		; $597f
	ld l,$da		; $5981
	res 7,(hl)		; $5983
	ld l,$c4		; $5985
	ld (hl),$08		; $5987
	jr @func_5a06		; $5989

@@func_598b:
	call $5c3b		; $598b
	jr nc,+			; $598e
	call enemyAnimate		; $5990
	call _ecom_decCounter2		; $5993
	jr nz,@@func_59c0	; $5996
	ld a,$09		; $5998
	call objectGetRelatedObject2Var		; $599a
	ld a,(hl)		; $599d
	sub $0e			; $599e
	cp $07			; $59a0
	jr nc,@@func_59c0	; $59a2
	ld l,$c4		; $59a4
	inc (hl)		; $59a6
	ld e,$85		; $59a7
	ld a,$01		; $59a9
	ld (de),a		; $59ab
	ld a,$05		; $59ac
	jp enemySetAnimation		; $59ae
+
	ld l,$87		; $59b1
	ld (hl),$0a		; $59b3
	ld a,(wFrameCounter)		; $59b5
	and $07			; $59b8
	call z,_generalOnox_func_59c0		; $59ba
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $59bd

@@func_59c0:
	jp enemyAnimate		; $59c0

@@substate1:
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

@@substate2:
	ld a,$24		; $59fe
	call objectGetRelatedObject2Var		; $5a00
	bit 7,(hl)		; $5a03
	ret nz			; $5a05
@func_5a06:
	call getRandomNumber_noPreserveVars		; $5a06
	cp $8c			; $5a09
	jp c,@func_594f		; $5a0b
	ld h,d			; $5a0e
	ld l,$84		; $5a0f
	inc (hl)		; $5a11
	inc l			; $5a12
	ld (hl),$00		; $5a13
	ld l,$86		; $5a15
	ld (hl),$10		; $5a17
	ld a,$04		; $5a19
	jp enemySetAnimation		; $5a1b
	
@stateC:
	inc e			; $5a1e
	ld a,(de)		; $5a1f
	rst_jumpTable			; $5a20
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
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

@@substate1:
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
	ld (hl),PARTID_48		; $5a53
	ret			; $5a55

@@substate2:
	call _ecom_decCounter1		; $5a56
	ret nz			; $5a59
	jp @func_594f		; $5a5a
	
_generalOnox_subid1:
	ld a,(de)		; $5a5d
	sub $08			; $5a5e
	rst_jumpTable			; $5a60
	.dw @state8
	.dw @state9
	.dw _generalOnox_subid0@stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD

@state8:
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

@state9:
	inc e			; $5a8c
	ld a,(de)		; $5a8d
	rst_jumpTable			; $5a8e
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2

@@substate0:
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
	ld bc,TX_501d		; $5aa9
	jp showText		; $5aac

@@substate1:
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

@@substate2:
	call _ecom_decCounter1		; $5ad6
	ret nz			; $5ad9
	ld l,$a4		; $5ada
	set 7,(hl)		; $5adc
	xor a			; $5ade
	ld ($cca4),a		; $5adf
	ld ($cbca),a		; $5ae2

@func_5ae5:
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

@stateB:
	inc e			; $5afc
	ld a,(de)		; $5afd
	rst_jumpTable			; $5afe
	.dw @@substate0
	.dw _generalOnox_subid0@stateB@substate1
	.dw @@substate2

@@substate0:
	call _ecom_decCounter1		; $5b05
	jp nz,_generalOnox_subid0@stateB@func_598b		; $5b08
	ld a,$24		; $5b0b
	call objectGetRelatedObject2Var		; $5b0d
	res 7,(hl)		; $5b10
	ld l,$da		; $5b12
	res 7,(hl)		; $5b14
	ld l,$c4		; $5b16
	ld (hl),$08		; $5b18

@@substate2:
	ld a,$24		; $5b1a
	call objectGetRelatedObject2Var		; $5b1c
	bit 7,(hl)		; $5b1f
	ret nz			; $5b21

@func_5b22:
	ld h,d			; $5b22
	ld l,$b0		; $5b23
	ldi a,(hl)		; $5b25
	cp (hl)			; $5b26
	ld l,$85		; $5b27
	ld (hl),$00		; $5b29
	jr z,+			; $5b2b
	call getRandomNumber		; $5b2d
	rrca			; $5b30
	jr c,@func_5ae5	; $5b31
	ld h,d			; $5b33
	dec l			; $5b34
	ld (hl),$0d		; $5b35
	ld l,$b1		; $5b37
	ldd a,(hl)		; $5b39
	ldi (hl),a		; $5b3a
	ld (hl),$02		; $5b3b
	call _generalOnox_func_5c63		; $5b3d
	ld e,$86		; $5b40
	ld a,(de)		; $5b42
	dec a			; $5b43
	ret z			; $5b44
	xor a			; $5b45
	jp enemySetAnimation		; $5b46
+
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

@stateC:
	inc e			; $5b5b
	ld a,(de)		; $5b5c
	rst_jumpTable			; $5b5d
	.dw _generalOnox_subid0@stateC@substate0
	.dw _generalOnox_subid0@stateC@substate1
	.dw @@substate2

@@substate2:
	call _ecom_decCounter1		; $5b64
	ret nz			; $5b67
	jp @func_5ae5		; $5b68

@stateD:
	inc e			; $5b6b
	ld a,(de)		; $5b6c
	rst_jumpTable			; $5b6d
	.dw @@substate0
	.dw @@substate1
	.dw @func_5b22

@@substate0:
	call _ecom_decCounter1		; $5b74
	jr nz,+			; $5b77
	inc (hl)		; $5b79
	inc l			; $5b7a
	ld (hl),$04		; $5b7b
	ld l,e			; $5b7d
	inc (hl)		; $5b7e
	ld a,$03		; $5b7f
	jp enemySetAnimation		; $5b81
+
	call _ecom_updateAngleTowardTarget		; $5b84
	call objectApplySpeed		; $5b87
	jp enemyAnimate		; $5b8a

@@substate1:
	call _ecom_decCounter1		; $5b8d
	ret nz			; $5b90
	ld (hl),$2d		; $5b91
	inc l			; $5b93
	dec (hl)		; $5b94
	jr z,+			; $5b95
	call getFreePartSlot		; $5b97
	ret nz			; $5b9a
	ld (hl),PARTID_49		; $5b9b
	ld bc,$19f9		; $5b9d
	jp objectCopyPositionWithOffset		; $5ba0
+
	ld l,e			; $5ba3
	inc (hl)		; $5ba4
	ret			; $5ba5
	
_generalOnox_subid2:
	ld a,(de)		; $5ba6
	sub $08			; $5ba7
	rst_jumpTable			; $5ba9
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC

@state8:
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
	ldbc INTERACID_0b $02		; $5bc9
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

@state9:
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

@stateA:
	call _ecom_decCounter1		; $5bf3
	jr z,+			; $5bf6
	ld a,(hl)		; $5bf8
	and $1c			; $5bf9
	rrca			; $5bfb
	rrca			; $5bfc
	ld hl,@table_5c1f		; $5bfd
	rst_addAToHl			; $5c00
	ld e,Enemy.yh		; $5c01
	ld a,(hl)		; $5c03
	ld (de),a		; $5c04
	ret			; $5c05
+
	ld (hl),$5a		; $5c06
	ld l,e			; $5c08
	inc (hl)		; $5c09
	ld a,$30		; $5c0a
	ld ($cd08),a		; $5c0c
	ld a,$08		; $5c0f
	ld ($cbae),a		; $5c11
	ld a,$06		; $5c14
	ld ($cbac),a		; $5c16
	ld bc,TX_5022		; $5c19
	jp showText		; $5c1c

@table_5c1f:
	.db $50
	.db $51
	.db $52
	.db $53
	.db $52
	.db $51
	.db $50
	.db $4f

@stateB:
	ld e,$84		; $5c27
	ld a,$0c		; $5c29
	ld (de),a		; $5c2b
	jp fadeoutToWhite		; $5c2c

@stateC:
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

_generalOnox_func_59c0:
	ldh a,(<hEnemyTargetY)	; $5c4e
	sub $18			; $5c50
	cp $98			; $5c52
	jr c,+			; $5c54
	ld a,$10		; $5c56
+
	ld b,a			; $5c58
	ldh a,(<hEnemyTargetX)	; $5c59
	ld c,a			; $5c5b
	call objectGetRelativeAngle		; $5c5c
	ld e,$89		; $5c5f
	ld (de),a		; $5c61
	ret			; $5c62

_generalOnox_func_5c63:
	call getRandomNumber_noPreserveVars		; $5c63
	and $03			; $5c66
	ld hl,@table_5c71		; $5c68
	rst_addAToHl			; $5c6b
	ld e,$86		; $5c6c
	ld a,(hl)		; $5c6e
	ld (de),a		; $5c6f
	ret			; $5c70

@table_5c71:
	.db $01
	.db $1e
	.db $3c
	.db $5a
	
_generalOnox_func_5c75:
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
	.dw $6e6d
	.dw $6ea7
	.dw $6ec8
	.dw $6edc
	.dw $6f1f
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
	ld hl,_table_6f13		; $6ee4
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

_table_6f13:
	.db $08 $78
	.db $0c $38
	.db $0a $60
	.db $08 $48
	.db $04 $24
	.db $06 $5a


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
	ld hl,_table_6f6f		; $6f5e
	rst_addDoubleIndex			; $6f61
	ldi a,(hl)		; $6f62
	ld b,a			; $6f63
	ld c,(hl)		; $6f64
	ld a,$0b		; $6f65
	call objectGetRelatedObject2Var		; $6f67
	call objectCopyPositionWithOffset		; $6f6a
	or d			; $6f6d
	ret			; $6f6e

_table_6f6f:
	.db $08 $00
	.db $f6 $00
	.db $ee $00
