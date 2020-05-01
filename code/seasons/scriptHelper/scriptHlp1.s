 m_section_force Script_Helper1 NAMESPACE scriptHlp

; ==============================================================================
; INTERACID_FARORE
; ==============================================================================
faroreCheckSecretValidity:
	ld a,(wSecretInputType)		; $4000
	inc a			; $4003
	jr nz,+			; $4004
	xor a			; $4006

@setVar3f
	ld e,Interaction.var3f		; $4007
	ld (de),a		; $4009
	ret			; $400a
+
	ld a,(wTextInputResult)		; $400b
	swap a			; $400e
	and $03			; $4010
	rst_jumpTable			; $4012
.ifdef ROM_AGES
	.dw @jump0
	.dw @jump1Or2
	.dw @jump1Or2
	.dw @jump3
.else
	.dw @jump1Or2
	.dw @jump3
	.dw @jump0
	.dw @jump1Or2
.endif

@jump1Or2:
	; Wrong game
	ld a,$04		; $401b
	jr @setVar3f			; $401d

@jump0:
	; Invalid? Pressed "back"?
	ld a,$03		; $401f
	jr @setVar3f			; $4021

@jump3:
	; Check if we've already told this secret
	ld a,(wTextInputResult)		; $4023
	and $0f			; $4026
.ifdef ROM_AGES
	add GLOBALFLAG_DONE_CLOCK_SHOP_SECRET			; $4028
.else
	add GLOBALFLAG_DONE_KING_ZORA_SECRET			; $4028
.endif
	ld b,a			; $402a
	call checkGlobalFlag		; $402b
	ld a,$02		; $402e
	jr nz,@setVar3f		; $4030

	; Check if we've spoken to the npc needed to trigger the secret
	ld a,b			; $4032
	sub GLOBALFLAG_FIRST_AGES_DONE_SECRET - GLOBALFLAG_FIRST_AGES_BEGAN_SECRET
	call checkGlobalFlag		; $4035
	ld a,$01		; $4038
	jr nz,@setVar3f		; $403a
	ld a,$05		; $403c
	jr @setVar3f			; $403e


faroreShowTextForSecretHint:
	ld a,(wTextInputResult)		; $4040
	and $0f			; $4043
	add <TX_550f			; $4045
	ld c,a			; $4047
	ld b,>TX_5500		; $4048
	jp showText		; $404a


faroreSpawnSecretChest:
	call getFreeInteractionSlot		; $404d
	ret nz			; $4050
	ld (hl),INTERACID_FARORE_GIVEITEM		; $4051
	inc l			; $4053
	ld a,(wTextInputResult)		; $4054
	and $0f			; $4057
	ld (hl),a		; $4059

	ld l,Interaction.yh		; $405a
	ld c,$75		; $405c
	jp setShortPosition_paramC		; $405e

faroreGenerateGameTransferSecret:
	jpab generateGameTransferSecret		; $4061


; ==============================================================================
; INTERACID_DOOR_CONTROLLER
; ==============================================================================

; Update Link's respawn position in case it's on a door that's just about to close
doorController_updateLinkRespawn:
	call objectGetShortPosition		; $4069
	ld c,a			; $406c
	ld a,(wLinkLocalRespawnY)		; $406d
	and $f0			; $4070
	ld b,a			; $4072
	ld a,(wLinkLocalRespawnX)		; $4073
	and $f0			; $4076
	swap a			; $4078
	or b			; $407a
	cp c			; $407b
	ret nz			; $407c

	ld e,Interaction.angle		; $407d
	ld a,(de)		; $407f
	rrca			; $4080
	and $03			; $4081
	ld hl,@offsets		; $4083
	rst_addAToHl			; $4086
	ld a,(hl)		; $4087
	add c			; $4088
	ld c,a			; $4089
	and $f0			; $408a
	or $08			; $408c
	ld (wLinkLocalRespawnY),a		; $408e
	ld a,c			; $4091
	swap a			; $4092
	and $f0			; $4094
	or $08			; $4096
	ld (wLinkLocalRespawnX),a		; $4098
	ret			; $409b

@offsets:
	.db $10 $ff $f0 $01


;;
; Sets wTmpcfc0.normal.doorControllerState to:
;   $00: Nothing to be done.
;   $01: Door should be opened.
;   $02: Door should be closed.
doorController_decideActionBasedOnTriggers:
	ld e,Interaction.var3d		; $40a0
	ld a,(de)		; $40a2
	ld b,a			; $40a3
	ld a,(wActiveTriggers)		; $40a4
	and b			; $40a7
	jr z,@triggerInactive	; $40a8

; If trigger is active, open the door.
	call @checkTileIsShutterDoor		; $40aa
	ld a,$01		; $40ad
	jr z,@end	; $40af
	xor a			; $40b1
	jr @end		; $40b2

; If trigger is inactive, close the door.
@triggerInactive:
	call @checkTileCollision		; $40b4
	ld a,$02		; $40b7
	jr z,@end	; $40b9
	xor a			; $40bb
@end:
	ld (wTmpcfc0.normal.doorControllerState),a		; $40bc
	ret			; $40bf


;;
; @param[out]	zflag	Set if the tile at this object's position is the expected shutter
;			door (the one facing the correct direction)
@checkTileIsShutterDoor:
	ld e,Interaction.angle		; $40c0
	ld a,(de)		; $40c2
	sub $10			; $40c3
	srl a			; $40c5
	ld hl,@tileIndices		; $40c7
	rst_addAToHl			; $40ca
	ld e,Interaction.var3e		; $40cb
	ld a,(de)		; $40cd
	ld c,a			; $40ce
	ld b,>wRoomLayout		; $40cf
	ld a,(bc)		; $40d1
	cp (hl)			; $40d2
	ret			; $40d3

@tileIndices: ; Tile indices for shutter doors
	.db $78 $79 $7a $7b


;;
; @param[out]	zflag	Set if collisions at this object's position are 0
@checkTileCollision:
	ld e,Interaction.var3e		; $40d8
	ld a,(de)		; $40da
	ld c,a			; $40db
	ld b,>wRoomCollisions		; $40dc
	ld a,(bc)		; $40de
	or a			; $40df
	ret			; $40e0


;;
; Set wTmpcfc0.normal.doorControllerState to:
;   $01 if Link is on a minecart which has collided with the door
;   $00 otherwise
doorController_checkMinecartCollidedWithDoor:
	xor a			; $40e1
	ld (wTmpcfc0.normal.doorControllerState),a		; $40e2
	ld a,(wLinkObjectIndex)		; $40e5
	rrca			; $40e8
	ret nc			; $40e9
	call objectCheckCollidedWithLink_ignoreZ		; $40ea
	ret nc			; $40ed
	ld a,$01		; $40ee
	ld (wTmpcfc0.normal.doorControllerState),a		; $40f0
	ret			; $40f3

;;
; Set wTmpcfc0.normal.doorControllerState to:
;   $01 if the tile at this position is a horizontal or vertical track
;   $00 otherwise
doorController_checkTileIsMinecartTrack:
	ld e,Interaction.var3e		; $40f4
	ld a,(de)		; $40f6
	ld c,a			; $40f7
	ld b,>wRoomLayout		; $40f8
	ld a,(bc)		; $40fa
	cp TILEINDEX_TRACK_HORIZONTAL			; $40fb
	ld b,$01		; $40fd
	jr z,+			; $40ff
	cp TILEINDEX_TRACK_VERTICAL			; $4101
	jr z,+			; $4103
	dec b			; $4105
+
	ld a,b			; $4106
	ld (wTmpcfc0.normal.doorControllerState),a		; $4107
	ret			; $410a


;;
; Compares [wNumTorchesLit] with [Interaction.speed]. Sets [wTmpcec0] to $01 if they're
; equal, $00 otherwise.
doorController_checkEnoughTorchesLit:
	ld a,(wNumTorchesLit)		; $410b
	ld b,a			; $410e
	ld e,Interaction.speed		; $410f
	ld a,(de)		; $4111
	cp b			; $4112
	ld a,$01		; $4113
	jr z,+			; $4115
	dec a			; $4117
+
	ld (wTmpcec0),a		; $4118
	ret			; $411b


; ==============================================================================
; INTERACID_SHOPKEEPER
; ==============================================================================

;;
; @addr{411c}
shopkeeper_take10Rupees:
	ld a,RUPEEVAL_10		; $411c
	jp removeRupeeValue		; $411e

;;
; @param	d	Interaction index (should be of type INTERACID_TREASURE)
; @addr{451e}
interactionLoadTreasureData:
	ld e,Interaction.subid	; $451e
	ld a,(de)		; $4520
	ld e,Interaction.var30		; $4521
	ld (de),a		; $4523
	ld hl,treasureObjectData		; $4524
--
	call multiplyABy4		; $4527
	add hl,bc		; $452a
	bit 7,(hl)		; $452b
	jr z,+			; $452d

	inc hl			; $452f
	ldi a,(hl)		; $4530
	ld h,(hl)		; $4531
	ld l,a			; $4532
	ld e,Interaction.var03		; $4533
	ld a,(de)		; $4535
	jr --			; $4536
+
	; var31 = spawn mode
	ldi a,(hl)		; $4538
	ld b,a			; $4539
	swap a			; $453a
	and $07			; $453c
	ld e,Interaction.var31		; $453e
	ld (de),a		; $4540

	; var32 = collect mode
	ld a,b			; $4541
	and $07			; $4542
	inc e			; $4544
	ld (de),a		; $4545

	; var33 = ?
	ld a,b			; $4546
	and $08			; $4547
	inc e			; $4549
	ld (de),a		; $454a

	; var34 = parameter (value of 'c' for "giveTreasure")
	ldi a,(hl)		; $454b
	inc e			; $454c
	ld (de),a		; $454d

	; var35 = low text ID
	ldi a,(hl)		; $454e
	inc e			; $454f
	ld (de),a		; $4550

	; subid = graphics to use
	ldi a,(hl)		; $4551
	ld e,Interaction.subid		; $4552
	ld (de),a		; $4554
	ret			; $4555


seasonsFunc_15_4677:
	call getFreePartSlot		; $4677
	ret nz			; $467a
	ld (hl),PARTID_BOSS_DEATH_EXPLOSION		; $467b
	jp objectCopyPosition		; $467d


seasonsFunc_15_4680:
	ld a,(wDungeonIndex)		; $4680
	ld b,a			; $4683
	inc a			; $4684
	jr nz,+			; $4685
	ld hl,seasonsTable_15_471d		; $4687
	jr ++			; $468a
+
	ld a,b			; $468c
	ld hl,seasonsTable_15_4723		; $468d
	rst_addDoubleIndex			; $4690
	ldi a,(hl)		; $4691
	ld h,(hl)		; $4692
	ld l,a			; $4693
++
	ld e,$72		; $4694
	ld a,(de)		; $4696
	rst_addDoubleIndex			; $4697
	ldi a,(hl)		; $4698
	ld h,(hl)		; $4699
	ld l,a			; $469a
	jr seasonsFunc_15_4715		; $469b
	ld e,Interaction.relatedObj2		; $469d
	ld a,(de)		; $469f
	ld l,a			; $46a0
	inc e			; $46a1
	ld a,(de)		; $46a2
	ld h,a			; $46a3
seasonsFunc_15_46a4:
	ldi a,(hl)		; $46a4
	push hl			; $46a5
	rst_jumpTable			; $46a6
	.dw seasonsFunc_15_46bf
	.dw seasonsFunc_15_46ca
	.dw seasonsFunc_15_46d6
	.dw seasonsFunc_15_46dd
	.dw seasonsFunc_15_46e4
	.dw seasonsFunc_15_46ec
	.dw seasonsFunc_15_46bf
	.dw seasonsFunc_15_46bf
	.dw seasonsFunc_15_4702
	.dw seasonsFunc_15_4706
	.dw seasonsFunc_15_470a
	.dw seasonsFunc_15_470e

seasonsFunc_15_46bf:
	pop hl			; $46bf
	ldi a,(hl)		; $46c0
	ld e,$46		; $46c1
	ld (de),a		; $46c3
	ld e,$45		; $46c4
	xor a			; $46c6
	ld (de),a		; $46c7
	jr seasonsFunc_15_4715		; $46c8

seasonsFunc_15_46ca:
	pop hl			; $46ca
	ldi a,(hl)		; $46cb
	ld e,$46		; $46cc
	ld (de),a		; $46ce
	ld e,$45		; $46cf
	ld a,$01		; $46d1
	ld (de),a		; $46d3
	jr seasonsFunc_15_4715		; $46d4

seasonsFunc_15_46d6:
	pop hl			; $46d6
	ldi a,(hl)		; $46d7
	ld e,$49		; $46d8
	ld (de),a		; $46da
	jr seasonsFunc_15_46a4		; $46db

seasonsFunc_15_46dd:
	pop hl			; $46dd
	ldi a,(hl)		; $46de
	ld e,$50		; $46df
	ld (de),a		; $46e1
	jr seasonsFunc_15_46a4		; $46e2

seasonsFunc_15_46e4:
	pop hl			; $46e4
	ld a,(hl)		; $46e5
	call s8ToS16		; $46e6
	add hl,bc		; $46e9
	jr seasonsFunc_15_46a4		; $46ea

seasonsFunc_15_46ec:
	pop hl			; $46ec
	ld a,($ccb0)		; $46ed
	cp d			; $46f0
	jr nz,_label_15_051	; $46f1
	inc hl			; $46f3
	jr seasonsFunc_15_46a4		; $46f4
_label_15_051:
	dec hl			; $46f6
	ld a,$01		; $46f7
	ld e,$46		; $46f9
	ld (de),a		; $46fb
	xor a			; $46fc
	ld e,$45		; $46fd
	ld (de),a		; $46ff
	jr seasonsFunc_15_4715		; $4700

seasonsFunc_15_4702:
	ld a,$00		; $4702
	jr _label_15_052		; $4704

seasonsFunc_15_4706:
	ld a,$08		; $4706
	jr _label_15_052		; $4708

seasonsFunc_15_470a:
	ld a,$10		; $470a
	jr _label_15_052		; $470c

seasonsFunc_15_470e:
	ld a,$18		; $470e
_label_15_052:
	ld e,$49		; $4710
	ld (de),a		; $4712
	jr seasonsFunc_15_46ca		; $4713

seasonsFunc_15_4715:
	ld e,Interaction.relatedObj2		; $4715
	ld a,l			; $4717
	ld (de),a		; $4718
	inc e			; $4719
	ld a,h			; $471a
	ld (de),a		; $471b
	ret			; $471c

seasonsTable_15_471d:
.DB $d3				; $471d
	ld c,b			; $471e
.DB $ed				; $471f
	ld c,b			; $4720
	rst $30			; $4721
	ld c,b			; $4722

seasonsTable_15_4723:
	dec (hl)		; $4723
	ld b,a			; $4724
	dec (hl)		; $4725
	ld b,a			; $4726
	dec (hl)		; $4727
	ld b,a			; $4728
	and c			; $4729
	ld b,a			; $472a
	ret			; $472b
	ld b,a			; $472c
	dec (hl)		; $472d
	ld b,a			; $472e
	rst $20			; $472f
	ld b,a			; $4730
	ld b,c			; $4731
	ld c,b			; $4732
	or a			; $4733
	ld c,b			; $4734
	ld b,e			; $4735
	ld b,a			; $4736
	ld d,c			; $4737
	ld b,a			; $4738
	ld e,a			; $4739
	ld b,a			; $473a
	ld l,l			; $473b
	ld b,a			; $473c
	ld a,l			; $473d
	ld b,a			; $473e
	adc c			; $473f
	ld b,a			; $4740
	sub l			; $4741
	ld b,a			; $4742
	nop			; $4743
	stop			; $4744
	dec bc			; $4745
	ld b,b			; $4746
	nop			; $4747
	stop			; $4748
	add hl,bc		; $4749
	and b			; $474a
	nop			; $474b
	stop			; $474c
	dec bc			; $474d
	and b			; $474e
	inc b			; $474f
	rst $30			; $4750
	nop			; $4751
	stop			; $4752
	ld ($0040),sp		; $4753
	stop			; $4756
	ld a,(bc)		; $4757
	and b			; $4758
	nop			; $4759
	stop			; $475a
	ld ($04a0),sp		; $475b
	rst $30			; $475e
	nop			; $475f
	stop			; $4760
	add hl,bc		; $4761
	ld b,b			; $4762
	nop			; $4763
	stop			; $4764
	dec bc			; $4765
	and b			; $4766
	nop			; $4767
	stop			; $4768
	add hl,bc		; $4769
	and b			; $476a
	inc b			; $476b
	rst $30			; $476c
	inc bc			; $476d
	jr z,_label_15_054	; $476e
_label_15_054:
	jr nz,_label_15_055	; $4770
	ld b,b			; $4772
	nop			; $4773
	jr nz,_label_15_056	; $4774
	ld d,b			; $4776
	nop			; $4777
	jr nz,_label_15_057	; $4778
	ld d,b			; $477a
	inc b			; $477b
	rst $30			; $477c
_label_15_055:
	add hl,bc		; $477d
	ret nz			; $477e
_label_15_056:
	nop			; $477f
	stop			; $4780
	dec bc			; $4781
	ld ($ff00+$00),a	; $4782
	stop			; $4784
_label_15_057:
	add hl,bc		; $4785
	ld ($ff00+$04),a	; $4786
	rst $30			; $4788
	dec bc			; $4789
	ld d,b			; $478a
	nop			; $478b
	stop			; $478c
	add hl,bc		; $478d
	ld ($ff00+$00),a	; $478e
	stop			; $4790
	dec bc			; $4791
	ld ($ff00+$04),a	; $4792
	rst $30			; $4794
	add hl,bc		; $4795
	ld d,b			; $4796
	nop			; $4797
	stop			; $4798
	dec bc			; $4799
	ld ($ff00+$00),a	; $479a
	stop			; $479c
	add hl,bc		; $479d
	ld ($ff00+$04),a	; $479e
	rst $30			; $47a0
	and a			; $47a1
	ld b,a			; $47a2
	or e			; $47a3
	ld b,a			; $47a4
	cp a			; $47a5
	ld b,a			; $47a6
	add hl,bc		; $47a7
	ld b,b			; $47a8
	nop			; $47a9
	jr nz,$0b		; $47aa
	add b			; $47ac
	nop			; $47ad
	jr nz,_label_15_058	; $47ae
	add b			; $47b0
	inc b			; $47b1
	rst $30			; $47b2
	ld a,(bc)		; $47b3
	ld h,b			; $47b4
	nop			; $47b5
	ld ($c008),sp		; $47b6
_label_15_058:
	nop			; $47b9
	ld ($c00a),sp		; $47ba
	inc b			; $47bd
	rst $30			; $47be
	dec bc			; $47bf
	ld h,b			; $47c0
	nop			; $47c1
	jr nz,_label_15_060	; $47c2
	ld h,b			; $47c4
	nop			; $47c5
	jr nz,_label_15_059	; $47c6
	rst $30			; $47c8
	bit 0,a			; $47c9
	inc bc			; $47cb
_label_15_059:
	ld d,b			; $47cc
_label_15_060:
	nop			; $47cd
	inc a			; $47ce
	dec bc			; $47cf
	jr nc,_label_15_061	; $47d0
	jr c,_label_15_063	; $47d2
	jr z,_label_15_064	; $47d4
	jr c,$09		; $47d6
	jr z,_label_15_065	; $47d8
_label_15_061:
	jr c,_label_15_066	; $47da
	jr z,_label_15_062	; $47dc
_label_15_062:
	inc a			; $47de
_label_15_063:
	ld a,(bc)		; $47df
_label_15_064:
	jr _label_15_067		; $47e0
_label_15_065:
	ld ($200a),sp		; $47e2
_label_15_066:
	inc b			; $47e5
	rst $20			; $47e6
	ei			; $47e7
	ld b,a			; $47e8
	dec b			; $47e9
	ld c,b			; $47ea
_label_15_067:
	rrca			; $47eb
	ld c,b			; $47ec
	rrca			; $47ed
	ld c,b			; $47ee
	add hl,de		; $47ef
	ld c,b			; $47f0
	inc hl			; $47f1
	ld c,b			; $47f2
	dec l			; $47f3
	ld c,b			; $47f4
	dec l			; $47f5
	ld c,b			; $47f6
	scf			; $47f7
	ld c,b			; $47f8
	dec sp			; $47f9
	ld c,b			; $47fa
	add hl,bc		; $47fb
	ld h,b			; $47fc
	nop			; $47fd
	stop			; $47fe
	dec bc			; $47ff
	ld h,b			; $4800
	nop			; $4801
	stop			; $4802
	inc b			; $4803
	rst $30			; $4804
	ld a,(bc)		; $4805
	add b			; $4806
	nop			; $4807
	stop			; $4808
	ld ($0080),sp		; $4809
	stop			; $480c
	inc b			; $480d
	rst $30			; $480e
	ld ($0020),sp		; $480f
	stop			; $4812
	ld a,(bc)		; $4813
	jr nz,_label_15_068	; $4814
_label_15_068:
	stop			; $4816
	inc b			; $4817
	rst $30			; $4818
	ld (jpHl),sp		; $4819
	stop			; $481c
	ld a,(bc)		; $481d
	and b			; $481e
	nop			; $481f
	stop			; $4820
	inc b			; $4821
	rst $30			; $4822
	ld ($00c0),sp		; $4823
	stop			; $4826
	ld a,(bc)		; $4827
	ret nz			; $4828
	nop			; $4829
	stop			; $482a
	inc b			; $482b
	rst $30			; $482c
	dec bc			; $482d
	ld h,b			; $482e
	nop			; $482f
	stop			; $4830
	add hl,bc		; $4831
	ld h,b			; $4832
	nop			; $4833
	stop			; $4834
	inc b			; $4835
	rst $30			; $4836
	ld a,(bc)		; $4837
	ld ($ff00+$00),a	; $4838
	stop			; $483a
	ld ($00e0),sp		; $483b
	stop			; $483e
	inc b			; $483f
	rst $30			; $4840
	ld c,l			; $4841
	ld c,b			; $4842
	ld (hl),c		; $4843
	ld c,b			; $4844
	ld a,e			; $4845
	ld c,b			; $4846
	adc a			; $4847
	ld c,b			; $4848
	sbc e			; $4849
	ld c,b			; $484a
	xor l			; $484b
	ld c,b			; $484c
	inc bc			; $484d
	ld d,b			; $484e
	nop			; $484f
	inc a			; $4850
	ld a,(bc)		; $4851
	jr nz,$0b		; $4852
	ld c,b			; $4854
	ld ($0920),sp		; $4855
	jr _label_15_069		; $4858
	ld ($1809),sp		; $485a
	ld ($0018),sp		; $485d
	jr z,_label_15_070	; $4860
	jr $0b			; $4862
_label_15_069:
	jr $08			; $4864
	ld (makeActiveObjectFollowLink),sp		; $4866
	ld a,(bc)		; $4869
	jr nz,_label_15_071	; $486a
_label_15_070:
	ld c,b			; $486c
	ld ($0420),sp		; $486d
	rst_addDoubleIndex			; $4870
	nop			; $4871
	ld ($8009),sp		; $4872
_label_15_071:
	nop			; $4875
	ld ($800b),sp		; $4876
	inc b			; $4879
	rst $30			; $487a
	inc bc			; $487b
	ld d,b			; $487c
	nop			; $487d
	ld ($380b),sp		; $487e
	nop			; $4881
	ld ($3008),sp		; $4882
	nop			; $4885
	ld ($3809),sp		; $4886
	nop			; $4889
	ld ($300a),sp		; $488a
	inc b			; $488d
	rst $28			; $488e
	ld a,(bc)		; $488f
	ld h,b			; $4890
	nop			; $4891
	ld ($8008),sp		; $4892
	nop			; $4895
	ld ($800a),sp		; $4896
	inc b			; $4899
	rst $30			; $489a
	nop			; $489b
	ld ($a00b),sp		; $489c
	nop			; $489f
	ld ($a008),sp		; $48a0
	nop			; $48a3
	ld ($a009),sp		; $48a4
	nop			; $48a7
	ld ($a00a),sp		; $48a8
	inc b			; $48ab
	rst $28			; $48ac
	nop			; $48ad
	ld ($8008),sp		; $48ae
	nop			; $48b1
	ld ($800a),sp		; $48b2
	inc b			; $48b5
	rst $30			; $48b6
	cp a			; $48b7
	ld c,b			; $48b8
	ret			; $48b9
	ld c,b			; $48ba
	cp a			; $48bb
	ld c,b			; $48bc
	ret			; $48bd
	ld c,b			; $48be
	add hl,bc		; $48bf
	ld ($ff00+$00),a	; $48c0
	stop			; $48c2
	dec bc			; $48c3
	ld ($ff00+$00),a	; $48c4
	stop			; $48c6
	inc b			; $48c7
	rst $30			; $48c8
	dec bc			; $48c9
	ld ($ff00+$00),a	; $48ca
	stop			; $48cc
	add hl,bc		; $48cd
	ld ($ff00+$00),a	; $48ce
	stop			; $48d0
	inc b			; $48d1
	rst $30			; $48d2
	inc bc			; $48d3
	ld d,b			; $48d4
	nop			; $48d5
	inc a			; $48d6
	dec bc			; $48d7
	inc e			; $48d8
	nop			; $48d9
	rrca			; $48da
	ld ($0030),sp		; $48db
	rrca			; $48de
	add hl,bc		; $48df
	jr c,_label_15_072	; $48e0
_label_15_072:
	rrca			; $48e2
	ld a,(bc)		; $48e3
	jr nc,_label_15_073	; $48e4
_label_15_073:
	rrca			; $48e6
	dec bc			; $48e7
	inc e			; $48e8
	nop			; $48e9
	inc a			; $48ea
	inc b			; $48eb
	jp hl			; $48ec
	nop			; $48ed
	ld ($4009),sp		; $48ee
	nop			; $48f1
	ld ($400b),sp		; $48f2
	inc b			; $48f5
	rst $30			; $48f6
	nop			; $48f7
	ld ($400b),sp		; $48f8
	nop			; $48fb
	ld ($4009),sp		; $48fc
	inc b			; $48ff
	rst $30			; $4900

seasonsFunc_15_4901:
	call objectGetPosition		; $4901
	ld a,$ff		; $4904
	jp createEnergySwirlGoingIn		; $4906

seasonsFunc_15_4909:
	ld a,$01		; $4909
	ld ($cd2d),a		; $490b
	ret			; $490e

seasonsFunc_15_490f:
	call getFreeInteractionSlot		; $490f
	ld bc,$2c00		; $4912
	ld (hl),$60		; $4915
	inc l			; $4917
	ld (hl),b		; $4918
	inc l			; $4919
	ld (hl),c		; $491a
	ld l,$4b		; $491b
	ld a,($d00b)		; $491d
	ldi (hl),a		; $4920
	inc l			; $4921
	ld a,($d00d)		; $4922
	ld (hl),a		; $4925
	ret			; $4926

seasonsFunc_15_4927:
	ld ($cbd3),a		; $4927
	ld a,$01		; $492a
	ld ($cca4),a		; $492c
	ld a,$04		; $492f
	jp openMenu		; $4931

seasonsFunc_15_4934:
	ld a,$02		; $4934
	jp openSecretInputMenu		; $4936

seasonsFunc_15_4939:
	ld a,$31		; $4939
	call setGlobalFlag		; $493b
	ld bc,$0002		; $493e
	jp secretFunctionCaller		; $4941

seasonsFunc_15_4944:
	ld e,$44		; $4944
	ld a,$05		; $4946
	ld (de),a		; $4948
	xor a			; $4949
	inc e			; $494a
	ld (de),a		; $494b
	ld b,$03		; $494c
	call secretFunctionCaller		; $494e
	call serialFunc_0c85		; $4951
	ld a,($cba5)		; $4954
	ld e,$79		; $4957
	ld (de),a		; $4959
	ld bc,$300e		; $495a
	or a			; $495d
	jr z,_label_15_074	; $495e
	ld e,$45		; $4960
	ld a,$03		; $4962
	ld (de),a		; $4964
	ld bc,$3028		; $4965
_label_15_074:
	jp showText		; $4968

seasonsFunc_15_496b:
	ld a,$00		; $496b
	call $498d		; $496d
	jr nz,_label_15_076	; $4970
	ld a,$01		; $4972
	call $498d		; $4974
	jr nz,_label_15_076	; $4977
	ld a,$02		; $4979
	call $498d		; $497b
	jr nz,_label_15_076	; $497e
	ld a,$03		; $4980
_label_15_075:
	ld e,$7b		; $4982
	ld (de),a		; $4984
	ret			; $4985
_label_15_076:
	ld e,$7a		; $4986
	ld (de),a		; $4988
	sub $34			; $4989
	jr _label_15_075		; $498b
	ld c,a			; $498d
	call checkGlobalFlag		; $498e
	jr z,_label_15_077	; $4991
	ld a,c			; $4993
	add $04			; $4994
	ld c,a			; $4996
	call checkGlobalFlag		; $4997
	jr nz,_label_15_077	; $499a
	ld a,c			; $499c
	call setGlobalFlag		; $499d
	ld a,c			; $49a0
	add $30			; $49a1
	ret			; $49a3
_label_15_077:
	xor a			; $49a4
	ret			; $49a5

seasonsFunc_15_49a6:
	ld a,$00		; $49a6
	jr _label_15_078		; $49a8

seasonsFunc_15_49aa:
	ld a,$38		; $49aa
	jr _label_15_078		; $49ac

seasonsFunc_15_49ae:
	ld e,$7a		; $49ae
	ld a,(de)		; $49b0
_label_15_078:
	ld b,a			; $49b1
	ld c,$00		; $49b2
	jp giveRingToLink		; $49b4

seasonsFunc_15_49b7:
	xor a			; $49b7
	ld ($c63e),a		; $49b8
	inc a			; $49bb
	ld ($c614),a		; $49bc
	ld a,$28		; $49bf
	jp setGlobalFlag		; $49c1

.ends
