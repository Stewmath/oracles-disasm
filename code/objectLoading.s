 m_section_free "Objects_1" namespace "objectData"

.ifdef ROM_AGES
.include "objects/ages/helperData.s"
.else
.include "objects/seasons/helperData.s"
.endif

;;
; @addr{55b7}
parseObjectData: ; 55b7
	xor a			; $55b7
	ld (wNumEnemies),a		; $55b8
	ld ($cfc0),a		; $55bb
	ld hl,wTmpcec0		; $55be
	ld b,$20		; $55c1
	call clearMemory		; $55c3
	call addRoomToEnemiesKilledList		; $55c6
	call generateRandomBuffer		; $55c9

.ifdef ROM_AGES
	callab getObjectDataAddress
.else; ROM_SEASONS
	ld a,(wActiveGroup)
	ld hl,objectDataGroupTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(wActiveRoom)
	ld e,a
	ld d,$00
	add hl,de
	add hl,de
	ldi a,(hl)
	ld d,(hl)
	ld e,a
.endif

;;
; @param de Address of object data to parse
; @addr{55d4}
parseGivenObjectData: ; 55d4
	ld a,(de)		; $55d4
	cp $fe			; $55d5
	jr nz,+
	pop de			; $55d9
+
	ld a,(de)		; $55da
	cp $ff			; $55db
	ret z			; $55dd

	inc de			; $55de
	and $0f			; $55df
	rst_jumpTable			; $55e1
	.dw _objectDataOp0
	.dw _objectDataOp1
	.dw _objectDataOp2
	.dw _objectDataOp3
	.dw _objectDataOp4
	.dw _objectDataOp5
	.dw _objectDataOp6
	.dw _objectDataOp7
	.dw _objectDataOp8
	.dw _objectDataOp9
.ifdef ROM_AGES
	.dw _objectDataOpA
.endif

; Appears to be unused
_func_55f8:
	jr parseGivenObjectData	; $55f8

;;
; @addr{55fa}
_parseGivenObjectData_hl:
	ld e,l			; $55fa
	ld d,h			; $55fb
	jr parseGivenObjectData

; 1st byte is the base size of the opcode, 2nd byte is size of each subsequent
; use of the opcode (as multiple uses of the same opcode saves space)
_objectDataOpcodeSizes:
	.db $02 $00
	.db $01 $02
	.db $01 $04
	.db $03 $00
	.db $03 $00
	.db $03 $00
	.db $02 $02
	.db $02 $04
	.db $01 $03
	.db $01 $06
.ifdef ROM_AGES
	.db $02 $02 ; Item drop ($0a)
.else
	.db $00 $00
.endif
	.db $00 $00
	.db $00 $00
	.db $00 $00
	.db $01 $00
	.db $01 $00

;;
; Only use objects when certain room properties are set
; Used a lot in jabu-jabu
; @addr{561e}
_objectDataOp0: ; 561e
	ld a,(wRoomStateModifier)		; $561e
	ld hl,bitTable		; $5621
	add l			; $5624
	ld l,a			; $5625
	ld a,(hl)		; $5626
	ld b,a			; $5627
	ld a,(de)		; $5628
	inc de			; $5629
	and b			; $562a
	jp nz,parseGivenObjectData		; $562b

	ld b,$00		; $562e
	ld l,e			; $5630
	ld h,d			; $5631

@nextOpcode:
	ld a,(hl)		; $5632

	; Parse new conditionals
	cp $f0			; $5633
	jr z,_parseGivenObjectData_hl	; $5635

	; Parse return opcode
	cp $fe			; $5637
	jr z,_parseGivenObjectData_hl	; $5639

	; Check return opcode
	cp $ff			; $563b
	ret z			; $563d

	; Otherwise, skip the next opcode
	and $0f			; $563e
	ld de,_objectDataOpcodeSizes
	call addDoubleIndexToDe		; $5643
	ld a,(de)		; $5646
	ld c,a			; $5647
	add hl,bc		; $5648
	inc de			; $5649
	ld a,(de)		; $564a
	ld c,a			; $564b
-
	add hl,bc		; $564c
	bit 7,(hl)		; $564d
	jr nz,@nextOpcode
	jr -

;;
; No-value interaction
; @addr{5653}
_objectDataOp1:
	call _continueObjectLoopIfOpDone	; $5653
	call getFreeInteractionSlot		; $5656
	jr nz,_skipToOpEnd_2byte

	call _read2Bytes
	jr _objectDataOp1

;;
; @addr{5660}
_skipToOpEnd_2byte:
	inc de			; $5660
	inc de			; $5661
	ld a,(de)		; $5662
	cp $f0			; $5663
	jp c,_skipToOpEnd_2byte
	jp parseGivenObjectData		; $5668

;;
; Double-value interaction
; @addr{566b}
_objectDataOp2:
	call _continueObjectLoopIfOpDone	; $566b
	call getFreeInteractionSlot		; $566e
	jr nz,_skipToOpEnd_4byte

	call _read2Bytes
	ld l,Interaction.yh
	call _readCoordinates		; $5678
	jr _objectDataOp2

_skipToOpEnd_4byte:
	inc de			; $567d
	inc de			; $567e
	inc de			; $567f
	inc de			; $5680
	ld a,(de)		; $5681
	cp $f0			; $5682
	jp c,_skipToOpEnd_4byte
	jp parseGivenObjectData		; $5687

;;
; In addition to checking wcc05, this appears to have a mechanism to prevent
; the pointer from being read if link enters from a certain direction.
; @param[out] @zflag Set if the pointer should be skipped.
; @addr{568a}
_checkSkipPointer:
.ifdef ROM_AGES
	ld a,(wcc05)		; $568a
	bit 1,a			; $568d
	ret z			; $568f
.endif

	ld a,(wcc85)		; $5690
	bit 7,a			; $5693
	jr z,++

	and $03			; $5697
	ld b,a			; $5699
	xor a			; $569a
	ld (wcc85),a		; $569b
	ld a,(wScreenTransitionDirection)		; $569e
	cp b			; $56a1
	ret z			; $56a2
-
	or d			; $56a3
	ret			; $56a4
++
	or a			; $56a5
	jr z,-

	xor a			; $56a8
	ret			; $56a9

;;
; @addr{56aa}
_skipPointer:
	inc de			; $56aa
	inc de			; $56ab
	jp parseGivenObjectData		; $56ac

;;
; @addr{56af}
_parsePointer:
	ld l,e			; $56af
	ld h,d			; $56b0
	inc de			; $56b1
	inc de			; $56b2
	push de			; $56b3
	ldi a,(hl)		; $56b4
	ld d,(hl)		; $56b5
	ld e,a			; $56b6
	jp parseGivenObjectData		; $56b7

;;
; Object pointer
; @addr{56ba}
_objectDataOp3:
	call _checkSkipPointer		; $56ba
	jr z,_skipPointer	; $56bd
	jr _parsePointer		; $56bf

;;
; Boss object pointer: use the pointer if the boss is not defeated.
; @addr{56c1}
_objectDataOp4:
	call _checkSkipPointer		; $56c1
	jr z,_skipPointer	; $56c4

	call getThisRoomFlags		; $56c6
	bit 7,a			; $56c9
	jr nz,_skipPointer	; $56cb
	jr _parsePointer		; $56cd

;;
; Anti boss object pointer: use the pointer if the boss is defeated.
; @addr{56cf}
_objectDataOp5:
	call _checkSkipPointer		; $56cf
	jr z,_skipPointer	; $56d2

	call getThisRoomFlags		; $56d4
	bit 7,a			; $56d7
	jr z,_skipPointer	; $56d9
	jr _parsePointer		; $56db

;;
; Random enemy
; @addr{56dd}
_objectDataOp6:
	; Flags
	ld a,(de)		; $56dd
	inc de			; $56de
	ld b,a			; $56df
	and $1f			; $56e0
	ldh (<hFF8B),a	; $56e2

	; Count
	ld a,b			; $56e4
	swap a			; $56e5
	rrca			; $56e7
	and $07			; $56e8
	ldh (<hFF8C),a	; $56ea

	; Main ID
	ld a,(de)		; $56ec
	inc de			; $56ed
	ldh (<hFF8F),a	; $56ee

	; Sub ID
	ld a,(de)		; $56f0
	inc de			; $56f1
	ldh (<hFF8E),a	; $56f2

@nextRandomEnemy:
	ld a,$01		; $56f4
	ldh (<hFF8D),a	; $56f6
	ldh a,(<hFF8B)	; $56f8
	and $01			; $56fa
	jr nz,+

	call _checkEnemyKilled		; $56fe
	jr nc,+++	; $5701
+
	call getFreeEnemySlot		; $5703
	jp nz,parseGivenObjectData		; $5706

	call _decEnemyCounterIfApplicable		; $5709

	; Write ID
	ldh a,(<hFF8F)	; $570c
	ldi (hl),a		; $570e
	ldh a,(<hFF8E)	; $570f
	ldi (hl),a		; $5711

	ld a,h			; $5712
	ldh (<hFF91),a	; $5713
	push de			; $5715

	call _assignRandomPositionToEnemy		; $5716

	pop de			; $5719
	ldh a,(<hFF91)	; $571a
	ld h,a			; $571c
	jr nc,++

	ld l,Enemy.enabled		; $571f
	ld (hl),$00		; $5721
	jr +++		; $5723
++
	ld l,Enemy.enabled		; $5725
	ldh a,(<hFF8D)	; $5727
	ld (hl),a		; $5729
+++
	ldh a,(<hFF8C)	; $572a
	dec a			; $572c
	ldh (<hFF8C),a	; $572d
	jr nz,@nextRandomEnemy
	jp parseGivenObjectData		; $5731

;;
; Specific position enemy
; @addr{5734}
_objectDataOp7:
	; Flags
	ld a,(de)		; $5734
	inc de			; $5735
	ldh (<hFF8B),a	; $5736

@nextSpecificEnemy:
	ld a,(de)		; $5738
	bit 7,a			; $5739
	jp nz,parseGivenObjectData		; $573b

	; Default value for "enabled" byte
	ld a,$01		; $573e
	ldh (<hFF8D),a	; $5740

	ldh a,(<hFF8B)	; $5742
	and $01			; $5744
	jr nz,+

	call _checkEnemyKilled		; $5748
	jr c,+

	inc de			; $574d
	inc de			; $574e
	inc de			; $574f
	inc de			; $5750
	jr @nextSpecificEnemy		; $5751
+
	call getFreeEnemySlot		; $5753
	jp nz,_skipToOpEnd_4byte		; $5756

	call _decEnemyCounterIfApplicable		; $5759

	; Get ID
	call _read2Bytes

	; Get X/Y
	ld l,Enemy.yh
	call _readCoordinates		; $5761

	; l = Enemy.xh
	ldd a,(hl)		; $5764
	and $f0			; $5765
	swap a			; $5767
	ld c,a			; $5769
	; l = Enemy.yh
	dec l			; $576a
	ld a,(hl)		; $576b
	and $f0			; $576c
	or c			; $576e
	ld c,a			; $576f

	; c now contains the object's tile / shortened position (YX)
	call _addPositionToPlacedEnemyPositions		; $5770

	ld l,Enemy.enabled
	ldh a,(<hFF8D)	; $5775
	ld (hl),a		; $5777
	jr @nextSpecificEnemy		; $5778

;;
; "Parts" (owl statues etc)
; @addr{577a}
_objectDataOp8: ; 577a
	ld a,(de)		; $577a
	bit 7,a			; $577b
	jp nz,parseGivenObjectData		; $577d

	call getFreePartSlot		; $5780
	jp nz,++

	call _read2Bytes
	ld a,(de)		; $5789
	ld c,a			; $578a
	inc de			; $578b
	ld l,Part.yh
	call setShortPosition		; $578e
	call _addPositionToPlacedEnemyPositions		; $5791
	jr _objectDataOp8		; $5794
++
	inc de			; $5796
	inc de			; $5797
	inc de			; $5798
	jr _objectDataOp8		; $5799

;;
; Object with parameter
; @addr{579b}
_objectDataOp9:
	call _continueObjectLoopIfOpDone	; $579b
	call @allocateObjectType
	jr nz,@allocationFailure

	; Read ID
	inc de			; $57a3
	ld a,(de)		; $57a4
	inc de			; $57a5
	ldi (hl),a		; $57a6
	ld a,(de)		; $57a7
	inc de			; $57a8
	ldi (hl),a		; $57a9

	; Read Object.var03
	ld a,(de)		; $57aa
	inc de			; $57ab
	ldi (hl),a		; $57ac

	; Read Y
	ld a,l			; $57ad
	and $c0			; $57ae
	add Object.yh
	ld l,a			; $57b2
	ld a,(de)		; $57b3
	inc de			; $57b4
	ldi (hl),a		; $57b5

	; Read X
	inc l			; $57b6
	ld a,(de)		; $57b7
	inc de			; $57b8
	ld (hl),a		; $57b9

	jr _objectDataOp9		; $57ba

@allocationFailure:
	ld a,$06		; $57bc
	call addAToDe		; $57be
	jr _objectDataOp9		; $57c1

@allocateObjectType:
	ld a,(de)		; $57c3
	rst_jumpTable			; $57c4
	.dw getFreeInteractionSlot
	.dw getFreeEnemySlot_uncounted
	.dw getFreePartSlot


.ifdef ROM_AGES
;;
; Item drops
; @addr{57cb}
_objectDataOpA:
	ld a,(de)		; $57cb
	inc de			; $57cc
	ldh (<hFF8B),a	; $57cd
@nextOpA:
	ld a,(de)		; $57cf
	bit 7,a			; $57d0
	jp nz,parseGivenObjectData		; $57d2

	; Default value for "enabled" byte
	ld a,$01		; $57d5
	ldh (<hFF8D),a	; $57d7

	ldh a,(<hFF8B)	; $57d9
	and $01			; $57db
	jr nz,++

	call _checkEnemyKilled		; $57df
	jr c,++

	inc de			; $57e4
	inc de			; $57e5
	jr @nextOpA
++
	call getFreeEnemySlot_uncounted		; $57e8
	jp nz,_skipToOpEnd_2byte

	; Set ID
	ld (hl),ENEMYID_ITEM_DROP_PRODUCER		; $57ee
	inc l			; $57f0
	ld a,(de)		; $57f1
	inc de			; $57f2
	ld (hl),a		; $57f3

	; Set YX
	ld l,Enemy.yh
	ld a,(de)		; $57f6
	inc de			; $57f7
	call setShortPosition		; $57f8

	call _addPositionToPlacedEnemyPositions		; $57fb
	ld l,Enemy.enabled		; $57fe
	ldh a,(<hFF8D)	; $5800
	ld (hl),a		; $5802
	jr @nextOpA
.endif

;;
; @addr{5805}
_continueObjectLoopIfOpDone:
	ld a,(de)		; $5805
	cp $f0			; $5806
	ret c			; $5808

	pop bc			; $5809
	jp parseGivenObjectData		; $580a

;;
; @param de Source
; @param hl Destination
; @addr{580d}
_read2Bytes: ; 580d
	ld a,(de)		; $580d
	inc de			; $580e
	ldi (hl),a		; $580f
	ld a,(de)		; $5810
	inc de			; $5811
	ld (hl),a		; $5812
	ret			; $5813

;;
; @param de Source
; @param hl Destination (an Object.yh variable)
; @addr{5814}
_readCoordinates:
	ld a,(de)		; $5814
	inc de			; $5815
	ldi (hl),a		; $5816
	inc l			; $5817
	ld a,(de)		; $5818
	inc de			; $5819
	ld (hl),a		; $581a
	ret			; $581b

;;
; @param hFF8B Flags that came with the enemy data
; @addr{581c}
_decEnemyCounterIfApplicable:
	ldh a,(<hFF8B)	; $581c
	and $02			; $581e
	ret z			; $5820

	ld a,(wNumEnemies)		; $5821
	dec a			; $5824
	ld (wNumEnemies),a		; $5825
	ret			; $5828

;;
; @param	c	Enemy position?
; @addr{5829}
_addPositionToPlacedEnemyPositions:
	push hl			; $5829
	ld a,(wEnemyPlacement.numEnemies)		; $582a
	ld hl,wEnemyPlacement.placedEnemyPositions		; $582d
	rst_addAToHl			; $5830
	ld (hl),c		; $5831

	ld a,(wEnemyPlacement.numEnemies)		; $5832
	inc a			; $5835
	and $0f			; $5836
	ld (wEnemyPlacement.numEnemies),a		; $5838

	pop hl			; $583b
	ret			; $583c

;;
; @param[out]	cflag	c if a valid position couldn't be found
; @addr{583d}
_assignRandomPositionToEnemy:
	call getRandomPositionForEnemy		; $583d
	ret c			; $5840

	ld a,(wEnemyPlacement.enemyPos)		; $5841
	ld c,a			; $5844
	call _addPositionToPlacedEnemyPositions		; $5845
	ldh a,(<hFF91)	; $5848
	ld h,a			; $584a
	ld l,Enemy.yh
	call setShortPosition_paramC		; $584d
	xor a			; $5850
	ret			; $5851

;;
; Calculates the value for an enemy's "enabled" byte (stored in hFF8D) such that the enemy
; is assigned an index, which allows the game to remember which enemies have been killed.
;
; @param[out]	cflag	nc if the enemy has been killed already (so it shouldn't spawn)
; @addr{5852}
_checkEnemyKilled:
	ld a,(wEnemyPlacement.numKillableEnemies)		; $5852
	cp $07			; $5855
	jr nc,+

	inc a			; $5859
	ld (wEnemyPlacement.numKillableEnemies),a		; $585a

	ld hl,bitTable		; $585d
	add l			; $5860
	ld l,a			; $5861
	ld a,(wEnemyPlacement.killedEnemiesBitset)		; $5862
	and (hl)		; $5865
	ret nz			; $5866

	; Calculate the value for the "enabled" byte, which contains the enemy's index.
	ld a,(wEnemyPlacement.numKillableEnemies)		; $5867
	swap a			; $586a
	or $01			; $586c
	ldh (<hFF8D),a	; $586e
+
	scf			; $5870
	ret			; $5871

.ends
