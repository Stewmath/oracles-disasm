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
.ifdef ROM_AGES
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
