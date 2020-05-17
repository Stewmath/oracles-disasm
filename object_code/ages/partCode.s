; ==============================================================================
; PARTID_16
; Bubble spawned from Jabu Jabu?
; ==============================================================================
partCode16:
	ld e,$c4		; $5f59
	ld a,(de)		; $5f5b
	rst_jumpTable			; $5f5c
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
@state0:
	ld h,d			; $5f65
	ld l,e			; $5f66
	inc (hl)		; $5f67
	ld l,$c0		; $5f68
	set 7,(hl)		; $5f6a
	ld l,$cd		; $5f6c
	ld a,(hl)		; $5f6e
	cp $50			; $5f6f
	ld bc,$ff80		; $5f71
	jr c,+			; $5f74
	ld bc,$0080		; $5f76
+
	ld l,$d2		; $5f79
	ld (hl),c		; $5f7b
	inc l			; $5f7c
	ld (hl),b		; $5f7d
	call getRandomNumber_noPreserveVars		; $5f7e
	ld b,a			; $5f81
	and $07			; $5f82
	ld e,$c6		; $5f84
	ld (de),a		; $5f86
	ld a,b			; $5f87
	and $18			; $5f88
	swap a			; $5f8a
	rlca			; $5f8c
	ld hl,@table_5fa7		; $5f8d
	rst_addAToHl			; $5f90
	ld e,$d0		; $5f91
	ld a,(hl)		; $5f93
	ld (de),a		; $5f94
	ld a,b			; $5f95
	and $e0			; $5f96
	swap a			; $5f98
	add a			; $5f9a
	ld e,$c7		; $5f9b
	ld (de),a		; $5f9d
	ld e,$c2		; $5f9e
	ld a,(de)		; $5fa0
	call partSetAnimation		; $5fa1
	jp objectSetVisible82		; $5fa4
@table_5fa7:
	.db $1e $28
	.db $32 $3c
@state1:
	call partCommon_decCounter1IfNonzero		; $5fab
	jr nz,+			; $5fae
	inc l			; $5fb0
	ldd a,(hl)		; $5fb1
	ld (hl),a		; $5fb2
	ld l,e			; $5fb3
	inc (hl)		; $5fb4
+
	ld l,$da		; $5fb5
	ld a,(hl)		; $5fb7
	xor $80			; $5fb8
	ld (hl),a		; $5fba
	ret			; $5fbb
@state2:
	call partCommon_decCounter1IfNonzero		; $5fbc
	jr nz,+			; $5fbf
	ld l,e			; $5fc1
	inc (hl)		; $5fc2
+
	ld l,$d2		; $5fc3
	ldi a,(hl)		; $5fc5
	ld b,(hl)		; $5fc6
	ld c,a			; $5fc7
	ld l,$cc		; $5fc8
	ld e,l			; $5fca
	ldi a,(hl)		; $5fcb
	ld h,(hl)		; $5fcc
	ld l,a			; $5fcd
	add hl,bc		; $5fce
	ld a,l			; $5fcf
	ld (de),a		; $5fd0
	inc e			; $5fd1
	ld a,h			; $5fd2
	ld (de),a		; $5fd3
@state3:
	call objectApplySpeed		; $5fd4
	ld e,$cb		; $5fd7
	ld a,(de)		; $5fd9
	cp $f0			; $5fda
	jp nc,partDelete		; $5fdc
	ld h,d			; $5fdf
	ld l,$da		; $5fe0
	ld a,(hl)		; $5fe2
	xor $80			; $5fe3
	ld (hl),a		; $5fe5
	ld l,$c7		; $5fe6
	dec (hl)		; $5fe8
	and $0f			; $5fe9
	ret nz			; $5feb
	ld l,$d0		; $5fec
	ld a,(hl)		; $5fee
	sub $05			; $5fef
	cp $13			; $5ff1
	ret c			; $5ff3
	ld (hl),a		; $5ff4
	ret			; $5ff5


; ==============================================================================
; PARTID_GROTTO_CRYSTAL
; ==============================================================================
partCode24:
	jr z,_label_11_223	; $5ff6
	ld a,(wSwitchState)		; $5ff8
	ld h,d			; $5ffb
	ld l,$c2		; $5ffc
	xor (hl)		; $5ffe
	ld (wSwitchState),a		; $5fff
	ld l,$e4		; $6002
	res 7,(hl)		; $6004
	ld a,$01		; $6006
	call partSetAnimation		; $6008
	ld bc,$8280		; $600b
	jp objectCreateInteraction		; $600e
_label_11_223:
	ld e,$c4		; $6011
	ld a,(de)		; $6013
	or a			; $6014
	ret nz			; $6015
	inc a			; $6016
	ld (de),a		; $6017
	call getThisRoomFlags		; $6018
	bit 6,(hl)		; $601b
	jr z,_label_11_224	; $601d
	ld h,d			; $601f
	ld l,$e4		; $6020
	res 7,(hl)		; $6022
	ld a,$01		; $6024
	call partSetAnimation		; $6026
_label_11_224:
	call objectMakeTileSolid		; $6029
	ld h,$cf		; $602c
	ld (hl),$0a		; $602e
	jp objectSetVisible83		; $6030


; ==============================================================================
; PARTID_WALL_ARROW_SHOOTER
; ==============================================================================
partCode25:
	ld e,$c4		; $6033
	ld a,(de)		; $6035
	or a			; $6036
	jr nz,+			; $6037
	ld h,d			; $6039
	ld l,e			; $603a
	inc (hl)		; $603b
	ld l,$c2		; $603c
	ld a,(hl)		; $603e
	swap a			; $603f
	rrca			; $6041
	ld l,$c9		; $6042
	ld (hl),a		; $6044
+
	call partCommon_decCounter1IfNonzero		; $6045
	ret nz			; $6048
	ld e,$c2		; $6049
	ld a,(de)		; $604b
	bit 0,a			; $604c
	ld e,$cd		; $604e
	ldh a,(<hEnemyTargetX)	; $6050
	jr z,+			; $6052
	ld e,$cb		; $6054
	ldh a,(<hEnemyTargetY)	; $6056
+
	ld b,a			; $6058
	ld a,(de)		; $6059
	sub b			; $605a
	add $10			; $605b
	cp $21			; $605d
	ret nc			; $605f
	ld e,$c6		; $6060
	ld a,$21		; $6062
	ld (de),a		; $6064
	ld hl,_table_6080		; $6065
	
	ld e,$c2		; $6068
	ld a,(de)		; $606a
	rst_addDoubleIndex			; $606b
	ldi a,(hl)		; $606c
	ld b,a			; $606d
	ld c,(hl)		; $606e
	call getFreePartSlot		; $606f
	ret nz			; $6072
	ld (hl),PARTID_ENEMY_ARROW		; $6073
	inc l			; $6075
	inc (hl)		; $6076
	call objectCopyPositionWithOffset		; $6077
	ld l,$c9		; $607a
	ld e,l			; $607c
	ld a,(de)		; $607d
	ld (hl),a		; $607e
	ret			; $607f

_table_6080:
	.db $fc $00 ; shooting up
	.db $00 $04 ; shooting right
	.db $04 $00 ; shooting down
	.db $00 $fc ; shooting left


; ==============================================================================
; PARTID_SPARKLE
; ==============================================================================
partCode26:
	ld e,$c4		; $6088
	ld a,(de)		; $608a
	or a			; $608b
	jr z,_label_11_229	; $608c
	call partCommon_decCounter1IfNonzero		; $608e
	jr nz,_label_11_227	; $6091
	inc l			; $6093
	ldd a,(hl)		; $6094
	ld (hl),a		; $6095
	ld l,$f0		; $6096
	ld a,(hl)		; $6098
	cpl			; $6099
	add $01			; $609a
	ldi (hl),a		; $609c
	ld a,(hl)		; $609d
	cpl			; $609e
	adc $00			; $609f
	ld (hl),a		; $60a1
_label_11_227:
	ld e,$cd		; $60a2
	ld a,(de)		; $60a4
	ld b,a			; $60a5
	dec e			; $60a6
	ld a,(de)		; $60a7
	ld c,a			; $60a8
	ld l,$d2		; $60a9
	ldi a,(hl)		; $60ab
	ld h,(hl)		; $60ac
	ld l,a			; $60ad
	add hl,bc		; $60ae
	ld a,l			; $60af
	ld (de),a		; $60b0
	inc e			; $60b1
	ld a,h			; $60b2
	ld (de),a		; $60b3
	ld e,$f0		; $60b4
	ld a,(de)		; $60b6
	ld c,a			; $60b7
	inc e			; $60b8
	ld a,(de)		; $60b9
	ld b,a			; $60ba
	ld e,$d3		; $60bb
	ld a,(de)		; $60bd
	ld h,a			; $60be
	dec e			; $60bf
	ld a,(de)		; $60c0
	ld l,a			; $60c1
	add hl,bc		; $60c2
	ld a,l			; $60c3
	ld (de),a		; $60c4
	inc e			; $60c5
	ld a,h			; $60c6
	ld (de),a		; $60c7
	ld h,d			; $60c8
	ld l,$ce		; $60c9
	ld e,$d4		; $60cb
	ld a,(de)		; $60cd
	add (hl)		; $60ce
	ldi (hl),a		; $60cf
	ld a,(hl)		; $60d0
	adc $00			; $60d1
	jp z,partDelete		; $60d3
	ld (hl),a		; $60d6
	cp $e8			; $60d7
	jr c,_label_11_228	; $60d9
	ld l,$da		; $60db
	ld a,(hl)		; $60dd
	xor $80			; $60de
	ld (hl),a		; $60e0
_label_11_228:
	jp partAnimate		; $60e1
_label_11_229:
	ld h,d			; $60e4
	ld l,e			; $60e5
	inc (hl)		; $60e6
	call objectGetZAboveScreen		; $60e7
	ld l,$cf		; $60ea
	ld (hl),a		; $60ec
	ld e,$c3		; $60ed
	ld a,(de)		; $60ef
	or a			; $60f0
	jr z,_label_11_230	; $60f1
	ld (hl),$f0		; $60f3
_label_11_230:
	call getRandomNumber_noPreserveVars		; $60f5
	and $0c			; $60f8
	ld hl,$6114		; $60fa
	rst_addAToHl			; $60fd
	ld e,$f0		; $60fe
	ldi a,(hl)		; $6100
	ld (de),a		; $6101
	inc e			; $6102
	ldi a,(hl)		; $6103
	ld (de),a		; $6104
	ld e,$d4		; $6105
	ldi a,(hl)		; $6107
	ld (de),a		; $6108
	ld e,$c6		; $6109
	ld a,(hl)		; $610b
	ld (de),a		; $610c
	inc e			; $610d
	dec a			; $610e
	add a			; $610f
	ld (de),a		; $6110
	jp objectSetVisible81		; $6111
	ld a,($56ff)		; $6114
	inc c			; $6117
	rst $30			; $6118
	rst $38			; $6119
	ld d,h			; $611a
	ld a,(bc)		; $611b
	ld a,($ff00+c)		; $611c
	rst $38			; $611d
	ld e,h			; $611e
	ld c,$f5		; $611f
	rst $38			; $6121
	ld e,b			; $6122
	stop			; $6123


; ==============================================================================
; PARTID_2b
; Used by INTERACID_TIMEWARP
; ==============================================================================
partCode2b:
	ld e,$c4		; $6124
	ld a,(de)		; $6126
	or a			; $6127
	jr nz,_label_11_231	; $6128
	inc a			; $612a
	ld (de),a		; $612b
	ld h,d			; $612c
	ld l,$c0		; $612d
	set 7,(hl)		; $612f
_label_11_231:
	call objectApplySpeed		; $6131
	ld e,$cb		; $6134
	ld a,(de)		; $6136
	add $04			; $6137
	cp $f4			; $6139
	jp nc,partDelete		; $613b
	ld a,$04		; $613e
	call objectGetRelatedObject1Var		; $6140
	ld a,(hl)		; $6143
	cp $03			; $6144
	ld e,$c2		; $6146
	ld a,(de)		; $6148
	jr c,_label_11_232	; $6149
	bit 1,a			; $614b
	jp nz,partDelete		; $614d
_label_11_232:
	ld l,$61		; $6150
	xor (hl)		; $6152
	rrca			; $6153
	jp c,objectSetInvisible		; $6154
	jp objectSetVisible83		; $6157


; ==============================================================================
; PARTID_2c
; Used by INTERACID_VIRE (flame used in "donkey kong" minigame?)
; ==============================================================================
partCode2c:
	jp nz,partDelete		; $615a
	ld a,($cfd0)		; $615d
	or a			; $6160
	jr z,_label_11_233	; $6161
	call objectCreatePuff		; $6163
	jp partDelete		; $6166
_label_11_233:
	ld e,$c4		; $6169
	ld a,(de)		; $616b
	rst_jumpTable			; $616c
.dw $6177
.dw $61ac
.dw $61c2
.dw $61d2
.dw $61ff
	ld h,d			; $6177
	ld l,e			; $6178
	inc (hl)		; $6179
	ld l,$d0		; $617a
	ld (hl),$1e		; $617c
	ld e,$c2		; $617e
	ld a,(de)		; $6180
	swap a			; $6181
	add $08			; $6183
	ld l,$c9		; $6185
	ld (hl),a		; $6187
	bit 4,a			; $6188
	jr z,_label_11_234	; $618a
	ld l,$cb		; $618c
	ld (hl),$fe		; $618e
	call getRandomNumber_noPreserveVars		; $6190
	and $07			; $6193
	ld hl,$629f		; $6195
	rst_addAToHl			; $6198
	ld a,(hl)		; $6199
	ld hl,$61aa		; $619a
	rst_addAToHl			; $619d
	ld e,$cd		; $619e
	ld a,(hl)		; $61a0
	ld (de),a		; $61a1
	ld a,$01		; $61a2
	call partSetAnimation		; $61a4
_label_11_234:
	jp objectSetVisible82		; $61a7
	ret c			; $61aa
	cp b			; $61ab
	ld a,$20		; $61ac
	call objectUpdateSpeedZ_sidescroll		; $61ae
	jr nc,_label_11_235	; $61b1
	ld h,d			; $61b3
	ld l,$c4		; $61b4
	inc (hl)		; $61b6
	ld l,$f1		; $61b7
	ld (hl),$04		; $61b9
	ld l,$d4		; $61bb
	xor a			; $61bd
	ldi (hl),a		; $61be
	ld (hl),a		; $61bf
	jr _label_11_235		; $61c0
	ld h,d			; $61c2
	ld l,$f1		; $61c3
	dec (hl)		; $61c5
	jr nz,_label_11_235	; $61c6
	ld (hl),$04		; $61c8
	ld l,e			; $61ca
	inc (hl)		; $61cb
	inc l			; $61cc
	ld (hl),$00		; $61cd
_label_11_235:
	jp partAnimate		; $61cf
	ld e,$c5		; $61d2
	ld a,(de)		; $61d4
	rst_jumpTable			; $61d5
.dw $61da
.dw $61e6

_label_11_236:
	call $6248		; $61da
	call $6270		; $61dd
	ret c			; $61e0
	ld h,d			; $61e1
	ld l,$c4		; $61e2
	inc (hl)		; $61e4
	ret			; $61e5
	ld bc,$1000		; $61e6
	call objectGetRelativeTile		; $61e9
	cp $19			; $61ec
	jp z,$6248		; $61ee
	ld h,d			; $61f1
	ld l,$c5		; $61f2
	dec (hl)		; $61f4
	ld l,$c6		; $61f5
	xor a			; $61f7
	ld (hl),a		; $61f8
	ld l,$d4		; $61f9
	ldi (hl),a		; $61fb
	ld (hl),a		; $61fc
	jr _label_11_236		; $61fd
	ld e,$cb		; $61ff
	ld a,(de)		; $6201
	cp $b0			; $6202
	jp nc,partDelete		; $6204
	call $6248		; $6207
	call $6270		; $620a
	ret nc			; $620d
	ld h,d			; $620e
	ld l,$c4		; $620f
	ld (hl),$02		; $6211
	xor a			; $6213
	ld l,$d4		; $6214
_label_11_237:
	ldi (hl),a		; $6216
	ld (hl),a		; $6217
	ld l,$c6		; $6218
	ld (hl),a		; $621a
	ld e,$c2		; $621b
	ld a,(de)		; $621d
	swap a			; $621e
	rrca			; $6220
	inc l			; $6221
	add (hl)		; $6222
	inc (hl)		; $6223
	ld bc,$6238		; $6224
	call addAToBc		; $6227
	ld l,$c9		; $622a
	ld a,(bc)		; $622c
	ldd (hl),a		; $622d
	and $10			; $622e
	swap a			; $6230
	cp (hl)			; $6232
	ret z			; $6233
	ld (hl),a		; $6234
	jp partSetAnimation		; $6235
	ld ($1818),sp		; $6238
	ld ($ff08),sp		; $623b
	rst $38			; $623e
	rst $38			; $623f
	jr $18			; $6240
	ld ($1808),sp		; $6242
	jr $18			; $6245
	jr _label_11_237		; $6247
	sub (hl)		; $6249
_label_11_238:
	jr nz,_label_11_238	; $624a
	sub c			; $624c
	jr nz,_label_11_239	; $624d
	pop hl			; $624f
	call objectCreatePuff		; $6250
	jp partDelete		; $6253
_label_11_239:
	call _partCommon_getTileCollisionInFront		; $6256
	jr nz,_label_11_240	; $6259
	call objectApplySpeed		; $625b
	jp partAnimate		; $625e
_label_11_240:
	ld e,$c9		; $6261
	ld a,(de)		; $6263
	xor $10			; $6264
	ld (de),a		; $6266
	ld e,$c8		; $6267
	ld a,(de)		; $6269
	xor $01			; $626a
	ld (de),a		; $626c
	jp partSetAnimation		; $626d
	ld a,$20		; $6270
	call objectUpdateSpeedZ_sidescroll		; $6272
	ret c			; $6275
	ld a,(hl)		; $6276
	cp $02			; $6277
	jr c,_label_11_241	; $6279
	ld (hl),$02		; $627b
	dec l			; $627d
	ld (hl),$00		; $627e
_label_11_241:
	call partCommon_decCounter1IfNonzero		; $6280
	ret nz			; $6283
	ld (hl),$10		; $6284
	ld bc,$1000		; $6286
	call objectGetRelativeTile		; $6289
	sub $19			; $628c
	or a			; $628e
	ret nz			; $628f
	call getRandomNumber		; $6290
	and $07			; $6293
	ld hl,$629f		; $6295
	rst_addAToHl			; $6298
	ld e,$c5		; $6299
	ld a,(hl)		; $629b
	ld (de),a		; $629c
	rrca			; $629d
	ret			; $629e
	nop			; $629f
	nop			; $62a0
	ld bc,$0100		; $62a1
	nop			; $62a4
	.db $01 $00


; ==============================================================================
; PARTID_2d
; Used by ENEMYID_VERAN_FAIRY
; ==============================================================================
partCode2d:
	jr nz,_label_11_244	; $42a7
	ld a,$29		; $62a9
	call objectGetRelatedObject1Var		; $62ab
	ld a,(hl)		; $62ae
	or a			; $62af
	jr z,_label_11_243	; $62b0
	ld e,$c4		; $62b2
	ld a,(de)		; $62b4
	or a			; $62b5
	jr z,_label_11_242	; $62b6
	call partCommon_checkOutOfBounds		; $62b8
	jr z,_label_11_244	; $62bb
	call objectApplySpeed		; $62bd
	jp partAnimate		; $62c0
_label_11_242:
	ld h,d			; $62c3
	ld l,e			; $62c4
	inc (hl)		; $62c5
	ld l,$d0		; $62c6
	ld (hl),$3c		; $62c8
	call objectGetAngleTowardEnemyTarget		; $62ca
	ld e,$c9		; $62cd
	ld (de),a		; $62cf
	call objectSetVisible82		; $62d0
	ld a,SND_VERAN_FAIRY_ATTACK		; $62d3
	jp playSound		; $62d5
_label_11_243:
	call objectCreatePuff		; $62d8
_label_11_244:
	jp partDelete		; $62db


; ==============================================================================
; PARTID_SEA_EFFECTS
; When this object exists, it applies the effects of whirlpool and pollution tiles.
; It's a bit weird to put this functionality in an object...
; ==============================================================================
partCode2e:
	ld e,Part.state		; $62de
	ld a,(de)		; $62e0
	or a			; $62e1
	jr nz,@initialized	; $62e2

	inc a			; $62e4
	ld (de),a		; $62e5
	jp $6361		; $62e6

@initialized:
	ld a,(w1Link.state)		; $62e9
	sub LINK_STATE_NORMAL			; $62ec
	ret nz			; $62ee

	ld (wDisableScreenTransitions),a		; $62ef
	call checkLinkCollisionsEnabled		; $62f2
	jr c,+			; $62f5

	; Check if diving underwater
	ld a,(wLinkSwimmingState)		; $62f7
	rlca			; $62fa
	ret nc			; $62fb
+
	ld a,(wLinkObjectIndex)		; $62fc
	ld h,a			; $62ff
	ld l,SpecialObject.start		; $6300
	call objectTakePosition		; $6302

	ld l,SpecialObject.id		; $6305
	ld a,(hl)		; $6307
	cp SPECIALOBJECTID_RAFT			; $6308
	ld a,$05		; $630a
	jr nz,+			; $630c
	add a			; $630e
+
	ld h,d			; $630f
	ld l,Part.counter2		; $6310
	ld (hl),a		; $6312

	; Get position in bc
	ld l,Part.yh		; $6313
	ldi a,(hl)		; $6315
	ld b,a			; $6316
	inc l			; $6317
	ld c,(hl)		; $6318

	ld hl,hFF8B		; $6319
	ld (hl),$06		; $631c
--
	ld hl,hFF8B		; $631e
	dec (hl)		; $6321
	jr z,_label_11_249	; $6322
	ld h,d			; $6324
	ld l,$c7		; $6325
	dec (hl)		; $6327
	ld a,(hl)		; $6328
	ld hl,$63fc		; $6329
	rst_addDoubleIndex			; $632c
	ldi a,(hl)		; $632d
	add b			; $632e
	ld b,a			; $632f
	ld a,(hl)		; $6330
	add c			; $6331
	ld c,a			; $6332
	call getTileAtPosition		; $6333
	ld e,a			; $6336
	ld a,l			; $6337
	ldh (<hFF8A),a	; $6338
	ld hl,$6418		; $633a
	call lookupCollisionTable_paramE		; $633d
	jr nc,--		; $6340

	rst_jumpTable			; $6342
.dw $6367
.dw $6398
.dw $63a3

_label_11_249:
	ld a,(wTilesetFlags)		; $6349
	and $01			; $634c
	jr z,_label_11_250	; $634e
	call objectGetTileAtPosition		; $6350
	ld hl,$6437		; $6353
	call lookupCollisionTable		; $6356
	jr nc,_label_11_250	; $6359
	ld c,a			; $635b
	ld b,$3c		; $635c
	call updateLinkPositionGivenVelocity		; $635e
_label_11_250:
	ld e,$c6		; $6361
	ld a,$20		; $6363
	ld (de),a		; $6365
	ret			; $6366
	ldh a,(<hFF8A)	; $6367
	call convertShortToLongPosition		; $6369
	ld e,$cb		; $636c
	ld a,(de)		; $636e
	ldh (<hFF8F),a	; $636f
	ld e,$cd		; $6371
	ld a,(de)		; $6373
	ldh (<hFF8E),a	; $6374
	call objectGetRelativeAngleWithTempVars		; $6376
	xor $10			; $6379
	ld b,a			; $637b
	ld a,(wLinkObjectIndex)		; $637c
	ld h,a			; $637f
	ld l,$2b		; $6380
	ldd a,(hl)		; $6382
	or (hl)			; $6383
	ret nz			; $6384
	ld (hl),$01		; $6385
	inc l			; $6387
	ld (hl),$18		; $6388
	inc l			; $638a
	ld (hl),b		; $638b
	inc l			; $638c
	ld (hl),$0c		; $638d
	ld l,$25		; $638f
	ld (hl),$fe		; $6391
	ld a,SND_DAMAGE_LINK		; $6393
	jp playSound		; $6395
	ld a,(wLinkObjectIndex)		; $6398
	rrca			; $639b
	jr c,_label_11_251	; $639c
	ld a,(wLinkSwimmingState)		; $639e
	or a			; $63a1
	ret z			; $63a2
_label_11_251:
	ldh a,(<hFF8A)	; $63a3
	call convertShortToLongPosition		; $63a5
	ld e,$cb		; $63a8
	ld a,(de)		; $63aa
	ldh (<hFF8F),a	; $63ab
	ld e,$cd		; $63ad
	ld a,(de)		; $63af
	ldh (<hFF8E),a	; $63b0
	sub c			; $63b2
	inc a			; $63b3
	cp $03			; $63b4
	jr nc,_label_11_252	; $63b6
	ldh a,(<hFF8F)	; $63b8
	sub b			; $63ba
	inc a			; $63bb
	cp $03			; $63bc
	jr nc,_label_11_252	; $63be
	ld a,(wLinkObjectIndex)		; $63c0
	ld h,a			; $63c3
	ld l,$0b		; $63c4
	ld (hl),b		; $63c6
	ld l,$0d		; $63c7
	ld (hl),c		; $63c9
	ld a,$02		; $63ca
	ld (wLinkForceState),a		; $63cc
	xor a			; $63cf
	ld (wLinkStateParameter),a		; $63d0
	jp clearAllParentItems		; $63d3
_label_11_252:
	ld a,$ff		; $63d6
	ld (wDisableScreenTransitions),a		; $63d8
	call objectGetRelativeAngleWithTempVars		; $63db
	ld c,a			; $63de
	call partCommon_decCounter1IfNonzero		; $63df
	ld a,(hl)		; $63e2
	and $1c			; $63e3
	rrca			; $63e5
	rrca			; $63e6
	ld hl,$6410		; $63e7
	rst_addAToHl			; $63ea
	ld a,(hl)		; $63eb
	ld b,a			; $63ec
	cp $19			; $63ed
	jr c,_label_11_253	; $63ef
	ld a,(wLinkObjectIndex)		; $63f1
	ld h,a			; $63f4
	ld l,$10		; $63f5
	ld (hl),$00		; $63f7
_label_11_253:
	jp updateLinkPositionGivenVelocity		; $63f9
	nop			; $63fc
	rst $30			; $63fd
	ld a,(bc)		; $63fe
	nop			; $63ff
	nop			; $6400
	add hl,bc		; $6401
.DB $fd				; $6402
	ei			; $6403
	nop			; $6404
	nop			; $6405
	nop			; $6406
	push af			; $6407
	dec bc			; $6408
	nop			; $6409
	nop			; $640a
	dec bc			; $640b
	ld a,($00fa)		; $640c
	nop			; $640f
	inc a			; $6410
	ldd (hl),a		; $6411
	jr z,_label_11_254	; $6412
	add hl,de		; $6414
	inc d			; $6415
	rrca			; $6416
	ld a,(bc)		; $6417
	inc h			; $6418
	ld h,h			; $6419
	jr z,$64		; $641a
	ld l,$64		; $641c
	jr z,_label_11_257	; $641e
	add hl,hl		; $6420
	ld h,h			; $6421
	ld l,$64		; $6422
.DB $eb				; $6424
	nop			; $6425
	jp hl			; $6426
	ld bc,$eb00		; $6427
	nop			; $642a
	jp hl			; $642b
	ld (bc),a		; $642c
	nop			; $642d
	inc a			; $642e
	ld (bc),a		; $642f
	dec a			; $6430
	ld (bc),a		; $6431
_label_11_254:
	ld a,$02		; $6432
	ccf			; $6434
	ld (bc),a		; $6435
_label_11_255:
	nop			; $6436
	ld c,h			; $6437
	ld h,h			; $6438
	ld d,h			; $6439
	ld h,h			; $643a
	ld b,e			; $643b
	ld h,h			; $643c
	ld d,h			; $643d
	ld h,h			; $643e
	ld d,h			; $643f
	ld h,h			; $6440
	ld b,e			; $6441
	ld h,h			; $6442
	ld d,h			; $6443
	nop			; $6444
	ld d,l			; $6445
	ld ($1056),sp		; $6446
	ld d,a			; $6449
	jr _label_11_256		; $644a
_label_11_256:
	ld ($ff00+R_P1),a	; $644c
	pop hl			; $644e
	stop			; $644f
	ld ($ff00+c),a		; $6450
	jr _label_11_255		; $6451
	.db $08 $00


; ==============================================================================
; PARTID_BABY_BALL
; Turns Link into a baby
; ==============================================================================
partCode2f:
	jp nz,partDelete		; $6455
	ld a,$29 		; $6458
	call objectGetRelatedObject1Var		; $645a
	ld a,(hl)		; $645d
	or a			; $645e
	jr z,_label_11_260	; $645f
	ld b,h			; $6461
	ld e,$c4		; $6462
	ld a,(de)		; $6464
	rst_jumpTable			; $6465
.dw $646c
.dw $647f
.dw $6493
	ld h,d			; $646c
	ld l,e			; $646d
	inc (hl)		; $646e
	ld l,$d0		; $646f
	ld (hl),$14		; $6471
	ld l,$c6		; $6473
	ld (hl),$1e		; $6475
	ld a,SND_CHARGE		; $6477
	call playSound		; $6479
	jp objectSetVisible82		; $647c
	call partCommon_decCounter1IfNonzero		; $647f
	jr nz,_label_11_259	; $6482
_label_11_257:
	ld l,e			; $6484
	inc (hl)		; $6485
	call objectGetAngleTowardEnemyTarget		; $6486
	ld e,$c9		; $6489
	ld (de),a		; $648b
	ld a,SND_BEAM2		; $648c
	call playSound		; $648e
	jr _label_11_259		; $6491
	ld c,$84		; $6493
	ld a,(bc)		; $6495
	cp $03			; $6496
	jr nz,_label_11_258	; $6498
	ld c,$83		; $649a
	ld a,(bc)		; $649c
	cp $02			; $649d
	jr nz,_label_11_258	; $649f
	ld a,(wFrameCounter)		; $64a1
	and $0f			; $64a4
	jr nz,_label_11_258	; $64a6
	call objectGetAngleTowardEnemyTarget		; $64a8
	call objectNudgeAngleTowards		; $64ab
_label_11_258:
	call partCommon_checkOutOfBounds		; $64ae
	jr z,_label_11_261	; $64b1
	call objectApplySpeed		; $64b3
_label_11_259:
	jp partAnimate		; $64b6
_label_11_260:
	call objectCreatePuff		; $64b9
_label_11_261:
	jp partDelete		; $64bc


; ==============================================================================
; PARTID_SUBTERROR_DIRT
; ==============================================================================
partCode32:
	ld e,$c4		; $64bf
	ld a,(de)		; $64c1
	rst_jumpTable			; $64c2
.dw $64c7
.dw $64cf
	ld a,$01		; $64c7
	ld (de),a		; $64c9
	ld a,SND_DIG		; $64ca
	call playSound		; $64cc
	call partAnimate		; $64cf
	ld e,$e1		; $64d2
	ld a,(de)		; $64d4
	ld e,$da		; $64d5
	ld (de),a		; $64d7
	or a			; $64d8
	ret nz			; $64d9
	jp partDelete		; $64da


; ==============================================================================
; PARTID_ROTATABLE_SEED_THING
; ==============================================================================
partCode33:
	ld e,$c2		; $64dd
	ld a,(de)		; $64df
	ld b,a			; $64e0
	and $03			; $64e1
	ld e,$c4		; $64e3
	rst_jumpTable			; $64e5
.dw $64ee
.dw $653e
.dw $6566
.dw $65c0
	ld a,(de)		; $64ee
	or a			; $64ef
	jr z,_label_11_263	; $64f0
_label_11_262:
	call partCommon_decCounter1IfNonzero		; $64f2
	ret nz			; $64f5
	ld e,$f0		; $64f6
	ld a,(de)		; $64f8
	ld (hl),a		; $64f9
	jp $657e		; $64fa
_label_11_263:
	ld c,b			; $64fd
	rlc c			; $64fe
	ld a,$01		; $6500
	jr nc,_label_11_264	; $6502
	ld a,$ff		; $6504
_label_11_264:
	ld h,d			; $6506
	ld l,$f1		; $6507
	ldd (hl),a		; $6509
	rlc c			; $650a
	ld a,$3c		; $650c
	jr nc,_label_11_265	; $650e
	add a			; $6510
_label_11_265:
	ld (hl),a		; $6511
	ld l,$c6		; $6512
	ld (hl),a		; $6514
	ld a,b			; $6515
	rrca			; $6516
	rrca			; $6517
	and $03			; $6518
	ld e,$c8		; $651a
	ld (de),a		; $651c
	call $6588		; $651d
	call objectMakeTileSolid		; $6520
	ld h,$cf		; $6523
	ld (hl),$0a		; $6525
	call objectSetVisible83		; $6527
	call getFreePartSlot		; $652a
	ret nz			; $652d
	ld (hl),$33		; $652e
	inc l			; $6530
	ld (hl),$03		; $6531
	ld l,$d6		; $6533
	ld a,$c0		; $6535
	ldi (hl),a		; $6537
	ld (hl),d		; $6538
	ld h,d			; $6539
	ld l,$c4		; $653a
	inc (hl)		; $653c
	ret			; $653d
	ld a,(de)		; $653e
	jr z,_label_11_266	; $653f
	ld h,d			; $6541
	ld l,$c3		; $6542
	ld a,(hl)		; $6544
	ld l,$d8		; $6545
	ldi a,(hl)		; $6547
	ld h,(hl)		; $6548
	ld l,a			; $6549
	and (hl)		; $654a
	ret z			; $654b
	jr _label_11_262		; $654c
_label_11_266:
	call $64fd		; $654e
	ld e,$c2		; $6551
	ld a,(de)		; $6553
	bit 4,a			; $6554
	ld hl,wToggleBlocksState		; $6556
	jr z,_label_11_267	; $6559
	ld hl,wActiveTriggers		; $655b
_label_11_267:
	ld e,$d8		; $655e
	ld a,l			; $6560
	ld (de),a		; $6561
	inc e			; $6562
	ld a,h			; $6563
	ld (de),a		; $6564
	ret			; $6565
	ld a,(de)		; $6566
	or a			; $6567
	jr z,_label_11_268	; $6568
	ld h,d			; $656a
	ld l,$f2		; $656b
	ld e,l			; $656d
	ld b,(hl)		; $656e
	ld l,$c3		; $656f
	ld c,(hl)		; $6571
	ld l,$d8		; $6572
	ldi a,(hl)		; $6574
	ld h,(hl)		; $6575
	ld l,a			; $6576
	ld a,(hl)		; $6577
	and c			; $6578
	ld c,a			; $6579
	xor b			; $657a
	ret z			; $657b
	ld a,c			; $657c
	ld (de),a		; $657d
	ld h,d			; $657e
	ld l,$f1		; $657f
	ld e,$c8		; $6581
	ld a,(de)		; $6583
	add (hl)		; $6584
	and $03			; $6585
	ld (de),a		; $6587
	ld b,a			; $6588
	ld hl,$6598		; $6589
	rst_addDoubleIndex			; $658c
	ld e,$e6		; $658d
	ldi a,(hl)		; $658f
	ld (de),a		; $6590
	inc e			; $6591
	ld a,(hl)		; $6592
	ld (de),a		; $6593
	ld a,b			; $6594
	jp partSetAnimation		; $6595
	ld b,$04		; $6598
	inc b			; $659a
	inc b			; $659b
	inc b			; $659c
	ld b,$04		; $659d
	inc b			; $659f
_label_11_268:
	ld c,b			; $65a0
	rlc c			; $65a1
	ld a,$01		; $65a3
	jr nc,_label_11_269	; $65a5
	ld a,$ff		; $65a7
_label_11_269:
	rlc c			; $65a9
	jr nc,_label_11_270	; $65ab
	add a			; $65ad
_label_11_270:
	ld h,d			; $65ae
	ld l,$f1		; $65af
	ld (hl),a		; $65b1
	call $6515		; $65b2
	call $6551		; $65b5
	ld e,$c3		; $65b8
	ld a,(de)		; $65ba
	and (hl)		; $65bb
	ld e,$f2		; $65bc
	ld (de),a		; $65be
	ret			; $65bf
	ld a,(de)		; $65c0
	or a			; $65c1
	jr z,_label_11_271	; $65c2
	ld a,$21		; $65c4
	call objectGetRelatedObject1Var		; $65c6
	ld e,l			; $65c9
	ld a,(hl)		; $65ca
	ld (de),a		; $65cb
	ld l,$e6		; $65cc
	ld e,l			; $65ce
	ldi a,(hl)		; $65cf
	ld (de),a		; $65d0
	inc e			; $65d1
	ld a,(hl)		; $65d2
	ld (de),a		; $65d3
	ret			; $65d4
_label_11_271:
	ld a,$0b		; $65d5
	call objectGetRelatedObject1Var		; $65d7
	ld bc,$0c00		; $65da
	call objectTakePositionWithOffset		; $65dd
	ld h,d			; $65e0
	ld l,$c4		; $65e1
	inc (hl)		; $65e3
	ld l,$cf		; $65e4
	ld (hl),$f2		; $65e6
	ret			; $65e8


; ==============================================================================
; PARTID_34
; Used by Ramrock (seed form)
; ==============================================================================
partCode34:
	ld e,$c4		; $65e9
	ld a,(de)		; $65eb
	cp $03			; $65ec
	jr nc,_label_11_272	; $65ee
	ld a,$0d		; $65f0
	call objectGetRelatedObject1Var		; $65f2
	ld a,(hl)		; $65f5
	ld e,$cd		; $65f6
	ld (de),a		; $65f8
_label_11_272:
	ld e,$c7		; $65f9
	ld a,(de)		; $65fb
	dec a			; $65fc
	ld (de),a		; $65fd
	and $03			; $65fe
	jr nz,_label_11_273	; $6600
	ld e,$dc		; $6602
	ld a,(de)		; $6604
	xor $01			; $6605
	ld (de),a		; $6607
_label_11_273:
	ld e,$c4		; $6608
	ld a,(de)		; $660a
	rst_jumpTable			; $660b
.dw $6616
.dw $662c
.dw $665c
.dw $666f
.dw partDelete
	ld a,$01		; $6616
	ld (de),a		; $6618
	ld h,d			; $6619
	ld l,$d0		; $661a
	ld (hl),$6e		; $661c
	ld l,$c9		; $661e
	ld (hl),$10		; $6620
	ld l,$c6		; $6622
	ld a,$07		; $6624
	ldi (hl),a		; $6626
	ld (hl),$03		; $6627
	call objectSetVisible80		; $6629
	ld e,$c3		; $662c
	ld a,(de)		; $662e
	or a			; $662f
	jr z,_label_11_274	; $6630
	call partCommon_decCounter1IfNonzero		; $6632
	jp nz,objectApplySpeed		; $6635
_label_11_274:
	ld e,$c3		; $6638
	ld a,(de)		; $663a
	cp $06			; $663b
	jr z,_label_11_275	; $663d
	call getFreePartSlot		; $663f
	ret nz			; $6642
	ld (hl),$34		; $6643
	inc l			; $6645
	ld (hl),$0e		; $6646
	ld l,e			; $6648
	ld a,(de)		; $6649
	inc a			; $664a
	ld (hl),a		; $664b
	ld e,$d6		; $664c
	ld l,e			; $664e
	ld a,$c0		; $664f
	ldi (hl),a		; $6651
	ld a,d			; $6652
	ld (hl),a		; $6653
	call objectCopyPosition		; $6654
_label_11_275:
	ld e,$c4		; $6657
	ld a,$02		; $6659
	ld (de),a		; $665b
	ld a,$02		; $665c
	call objectGetRelatedObject1Var		; $665e
	ld a,(hl)		; $6661
	cp $0e			; $6662
	ret z			; $6664
	ld e,$c4		; $6665
	ld a,$03		; $6667
	ld (de),a		; $6669
	ld e,$c6		; $666a
	ld a,$07		; $666c
	ld (de),a		; $666e
	ld e,$c3		; $666f
	ld a,(de)		; $6671
	cp $06			; $6672
	jp z,partDelete		; $6674
	call partCommon_decCounter1IfNonzero		; $6677
	jp nz,objectApplySpeed		; $667a
	ld e,$c2		; $667d
	ld (de),a		; $667f
	ld e,$c4		; $6680
	ld a,$04		; $6682
	ld (de),a		; $6684
	ret			; $6685


; ==============================================================================
; PARTID_35
; Used by Ramrock (bomb form)
; ==============================================================================
partCode35:
	ld a,$29		; $6686
	call objectGetRelatedObject1Var		; $6688
	ld a,(hl)		; $668b
	or a			; $668c
	jp z,partDelete		; $668d
	ld e,$c2		; $6690
	ld a,(de)		; $6692
	rlca			; $6693
	jr c,_label_11_276	; $6694
	ld a,(wLinkGrabState)		; $6696
	or a			; $6699
	call z,objectPushLinkAwayOnCollision		; $669a
	ld e,$c4		; $669d
	ld a,(de)		; $669f
	rst_jumpTable			; $66a0
.dw $66d2
.dw $673a
.dw $677c
.dw $680f
.dw $686d
.dw $68e2
.dw $6924

_label_11_276:
	ld e,$c6		; $66af
	ld a,(de)		; $66b1
	or a			; $66b2
	jr nz,_label_11_277	; $66b3
	ld e,$c4		; $66b5
	ld a,(de)		; $66b7
	cp $04			; $66b8
	jr z,_label_11_277	; $66ba
	ld e,$da		; $66bc
	ld a,(de)		; $66be
	xor $80			; $66bf
	ld (de),a		; $66c1
_label_11_277:
	ld e,$c4		; $66c2
	ld a,(de)		; $66c4
	rst_jumpTable			; $66c5
.dw $6705
.dw $6747
.dw $67f1
.dw $680f
.dw $68c3
.dw $690c
	call $6731		; $66d2
	ld e,$d7		; $66d5
	ld a,(de)		; $66d7
	ld e,$f0		; $66d8
	ld (de),a		; $66da
	call $6956		; $66db
	ld a,(de)		; $66de
	swap a			; $66df
	ld (de),a		; $66e1
	or $80			; $66e2
	ld (hl),a		; $66e4
	call $6992		; $66e5
	ld l,$d6		; $66e8
	ld a,$c0		; $66ea
	ldi (hl),a		; $66ec
	ld (hl),d		; $66ed
	ld e,$c2		; $66ee
	ld a,(de)		; $66f0
	swap a			; $66f1
	ld hl,$6703		; $66f3
	rst_addAToHl			; $66f6
	ld a,(hl)		; $66f7
	ld e,$c9		; $66f8
	ld (de),a		; $66fa
	ld a,SND_THROW		; $66fb
	call playSound		; $66fd
	jp objectSetVisiblec0		; $6700
	jr $08			; $6703
	call $6731		; $6705
	call $6956		; $6708
	call $6992		; $670b
	ld l,$d6		; $670e
	ld a,$c0		; $6710
	ldi (hl),a		; $6712
	ld (hl),d		; $6713
	ld l,$f0		; $6714
	ld e,l			; $6716
	ld a,(de)		; $6717
	ld (hl),a		; $6718
	ld a,$01		; $6719
	call partSetAnimation		; $671b
	ld e,$c2		; $671e
	ld a,(de)		; $6720
	and $0f			; $6721
	add $0a			; $6723
	ld e,$c6		; $6725
	ld (de),a		; $6727
	ld e,$e4		; $6728
	ld a,(de)		; $672a
	res 7,a			; $672b
	ld (de),a		; $672d
	jp objectSetVisiblec1		; $672e
	ld a,$01		; $6731
	ld (de),a		; $6733
	ld e,$cf		; $6734
	ld a,$81		; $6736
	ld (de),a		; $6738
	ret			; $6739
	ld c,$10		; $673a
	call objectUpdateSpeedZ_paramC		; $673c
	ret nz			; $673f
	ld e,$f1		; $6740
	ld a,(de)		; $6742
	or a			; $6743
	jr nz,_label_11_278	; $6744
	ret			; $6746
	call partCommon_decCounter1IfNonzero		; $6747
	ret nz			; $674a
	ld c,$10		; $674b
	call objectUpdateSpeedZ_paramC		; $674d
	ret nz			; $6750
	ld l,$c7		; $6751
	ld a,(hl)		; $6753
	or a			; $6754
	jr nz,_label_11_278	; $6755
	inc (hl)		; $6757
	ld bc,$fe80		; $6758
	jp objectSetSpeedZ		; $675b
_label_11_278:
	ld a,$78		; $675e
	jr _label_11_279		; $6760
	ld a,$14		; $6762
_label_11_279:
	ld e,$d0		; $6764
	ld (de),a		; $6766
	ld a,$31		; $6767
	call objectGetRelatedObject1Var		; $6769
	inc (hl)		; $676c
	ld e,$c4		; $676d
	ld a,$03		; $676f
	ld (de),a		; $6771
	call $693b		; $6772
	call objectGetRelativeAngle		; $6775
	ld e,$c9		; $6778
	ld (de),a		; $677a
	ret			; $677b
	inc e			; $677c
	ld a,(de)		; $677d
	rst_jumpTable			; $677e
.dw $6787
.dw $67b7
.dw $67b0
.dw $67b0
	ld h,d			; $6787
	ld l,e			; $6788
	inc (hl)		; $6789
	ld a,$90		; $678a
	ld (wLinkGrabState2),a		; $678c
	xor a			; $678f
	ld l,$ca		; $6790
	ldd (hl),a		; $6792
	ld ($d00a),a		; $6793
	ld (hl),$10		; $6796
	ld l,$d0		; $6798
	ld (hl),$14		; $679a
	ld l,$c7		; $679c
	ld (hl),$60		; $679e
	call $69a5		; $67a0
	ld l,$b7		; $67a3
	ld e,$c2		; $67a5
	ld a,(de)		; $67a7
	swap a			; $67a8
	jp unsetFlag		; $67aa
_label_11_280:
	call dropLinkHeldItem		; $67ad
	ld a,SND_BIGSWORD		; $67b0
	call playSound		; $67b2
	jr _label_11_278		; $67b5
	call $69a5		; $67b7
	ldi a,(hl)		; $67ba
	cp $11			; $67bb
	jr z,_label_11_280	; $67bd
	ld a,($d221)		; $67bf
	or a			; $67c2
	jr nz,_label_11_281	; $67c3
	ld e,$f3		; $67c5
	ld (de),a		; $67c7
	ret			; $67c8
_label_11_281:
	ld h,d			; $67c9
	ld l,$c7		; $67ca
	ld a,(hl)		; $67cc
	or a			; $67cd
	ret z			; $67ce
	dec (hl)		; $67cf
	jr nz,_label_11_282	; $67d0
	dec l			; $67d2
	ld (hl),$14		; $67d3
	ld l,$f2		; $67d5
	inc (hl)		; $67d7
_label_11_282:
	ld l,$f3		; $67d8
	ld a,(hl)		; $67da
	or a			; $67db
	jr nz,_label_11_283	; $67dc
	ld a,SND_MOVEBLOCK		; $67de
	ld (hl),a		; $67e0
	call playSound		; $67e1
_label_11_283:
	ld h,d			; $67e4
	ld l,$c9		; $67e5
	ld c,(hl)		; $67e7
	ld l,$d0		; $67e8
	ld b,(hl)		; $67ea
	call updateLinkPositionGivenVelocity		; $67eb
	jp objectApplySpeed		; $67ee
	ld a,$0b		; $67f1
	call objectGetRelatedObject1Var		; $67f3
	ld e,$cb		; $67f6
	ld a,(de)		; $67f8
	sub (hl)		; $67f9
	cpl			; $67fa
	inc a			; $67fb
	cp $10			; $67fc
	jr c,_label_11_284	; $67fe
	ld a,(de)		; $6800
	inc a			; $6801
	ld (de),a		; $6802
_label_11_284:
	ld a,$04		; $6803
	call objectGetRelatedObject1Var		; $6805
	ld a,(hl)		; $6808
	cp $02			; $6809
	ret z			; $680b
	jp $675e		; $680c
	ld e,$c6		; $680f
	ld a,(de)		; $6811
	or a			; $6812
	jr z,_label_11_285	; $6813
	dec a			; $6815
	ld (de),a		; $6816
	jp objectApplySpeed		; $6817
_label_11_285:
	call $693b		; $681a
	call objectGetRelativeAngle		; $681d
	ld e,$c9		; $6820
	ld (de),a		; $6822
	call objectApplySpeed		; $6823
	call $6970		; $6826
	ret nz			; $6829
	ld e,$c2		; $682a
	ld a,(de)		; $682c
	rlca			; $682d
	jr c,_label_11_287	; $682e
	ld h,d			; $6830
	ld l,$e4		; $6831
	set 7,(hl)		; $6833
	ld e,$f2		; $6835
	ld a,(de)		; $6837
	or a			; $6838
	jr z,_label_11_286	; $6839
	xor a			; $683b
	ld (de),a		; $683c
	call $69a5		; $683d
	ld l,$ab		; $6840
	ld a,(hl)		; $6842
	or a			; $6843
	jr nz,_label_11_286	; $6844
	ld (hl),$3c		; $6846
	ld l,$b5		; $6848
	inc (hl)		; $684a
	ld a,SND_BOSS_DAMAGE		; $684b
	call playSound		; $684d
_label_11_286:
	ld e,$c6		; $6850
	ld a,$3c		; $6852
	ld (de),a		; $6854
	call $69a5		; $6855
	ld l,$b7		; $6858
	ld e,$c2		; $685a
	ld a,(de)		; $685c
	swap a			; $685d
	call setFlag		; $685f
	jr _label_11_288		; $6862
_label_11_287:
	call objectSetInvisible		; $6864
_label_11_288:
	ld e,$c4		; $6867
	ld a,$04		; $6869
	ld (de),a		; $686b
	ret			; $686c
	ld h,d			; $686d
	ld l,$e4		; $686e
	set 7,(hl)		; $6870
	call $68d7		; $6872
	call partCommon_decCounter1IfNonzero		; $6875
	ret nz			; $6878
	call $69a5		; $6879
	ldi a,(hl)		; $687c
	cp $12			; $687d
	ret nz			; $687f
	ld a,(hl)		; $6880
	bit 5,a			; $6881
	jr nz,_label_11_289	; $6883
	ld e,$c2		; $6885
	ld a,(de)		; $6887
	cp (hl)			; $6888
	jr z,_label_11_289	; $6889
	call objectGetAngleTowardLink		; $688b
	cp $10			; $688e
	ret nz			; $6890
	ld a,(w1Link.direction)		; $6891
	or a			; $6894
	ret nz			; $6895
	ld h,d			; $6896
	ld l,$e4		; $6897
	res 7,(hl)		; $6899
	jp objectAddToGrabbableObjectBuffer		; $689b
_label_11_289:
	ld a,SND_EXPLOSION		; $689e
	call playSound		; $68a0
	call objectGetAngleTowardLink		; $68a3
	ld h,d			; $68a6
	ld l,$c9		; $68a7
	ld (hl),a		; $68a9
	ld l,$c4		; $68aa
	ld (hl),$05		; $68ac
	ld l,$c6		; $68ae
	ld (hl),$02		; $68b0
	ld l,$d0		; $68b2
	ld (hl),$78		; $68b4
	call $69a5		; $68b6
	ld l,$b7		; $68b9
	ld e,$c2		; $68bb
	ld a,(de)		; $68bd
	swap a			; $68be
	jp unsetFlag		; $68c0
	ld a,$04		; $68c3
	call objectGetRelatedObject1Var		; $68c5
	ld a,(hl)		; $68c8
	cp $04			; $68c9
	jr z,_label_11_290	; $68cb
	ld e,l			; $68cd
	ld (de),a		; $68ce
	ld l,$c9		; $68cf
	ld e,l			; $68d1
	ld a,(hl)		; $68d2
	ld (de),a		; $68d3
	jp objectSetVisible		; $68d4
_label_11_290:
	call $693b		; $68d7
	ld h,d			; $68da
	ld l,$cb		; $68db
	ld (hl),b		; $68dd
	ld l,$cd		; $68de
	ld (hl),c		; $68e0
	ret			; $68e1
	call _partCommon_getTileCollisionInFront		; $68e2
	jr nz,_label_11_292	; $68e5
	call objectApplySpeed		; $68e7
	call partCommon_decCounter1IfNonzero		; $68ea
	ret nz			; $68ed
	ld (hl),$03		; $68ee
	ld e,$d0		; $68f0
	ld a,(de)		; $68f2
	or a			; $68f3
	jp z,$68fe		; $68f4
	sub $0a			; $68f7
	jr nc,_label_11_291	; $68f9
	xor a			; $68fb
_label_11_291:
	ld (de),a		; $68fc
	ret			; $68fd
_label_11_292:
	ld h,d			; $68fe
	ld l,$c4		; $68ff
	ld (hl),$06		; $6901
	ld l,$c6		; $6903
	ld (hl),$3c		; $6905
	ld l,$d0		; $6907
	ld (hl),$00		; $6909
	ret			; $690b
	ld a,$10		; $690c
	call objectGetRelatedObject1Var		; $690e
	ld e,l			; $6911
	ld a,(hl)		; $6912
	sub $19			; $6913
	jr nc,_label_11_293	; $6915
	xor a			; $6917
_label_11_293:
	ld (de),a		; $6918
	ld l,$c4		; $6919
	ld a,(hl)		; $691b
	cp $03			; $691c
	jp nz,objectApplySpeed		; $691e
	jp $6762		; $6921
	call partCommon_decCounter1IfNonzero		; $6924
	ret nz			; $6927
	ld l,$e4		; $6928
	res 7,(hl)		; $692a
	call $69a5		; $692c
	inc l			; $692f
	ld a,(hl)		; $6930
	bit 5,a			; $6931
	jr z,_label_11_294	; $6933
	ld a,$80		; $6935
	ld (hl),a		; $6937
_label_11_294:
	jp $6762		; $6938
	ld e,$c2		; $693b
	ld a,(de)		; $693d
	swap a			; $693e
	ld c,$0c		; $6940
	rrca			; $6942
	jr nc,_label_11_295	; $6943
	ld c,$f4		; $6945
_label_11_295:
	ld e,$f0		; $6947
	ld a,(de)		; $6949
	ld h,a			; $694a
	ld l,$8b		; $694b
	ldi a,(hl)		; $694d
	add $0c			; $694e
	ld b,a			; $6950
	inc l			; $6951
	ld a,(hl)		; $6952
	add c			; $6953
	ld c,a			; $6954
	ret			; $6955
	ld e,$c2		; $6956
	ld a,(de)		; $6958
	and $0f			; $6959
	cp $02			; $695b
	ret z			; $695d
	call getFreePartSlot		; $695e
	ld a,$35		; $6961
	ldi (hl),a		; $6963
	ld a,(de)		; $6964
	inc a			; $6965
	ld (hl),a		; $6966
	ld e,$f0		; $6967
	ld l,e			; $6969
	ld a,(de)		; $696a
	ld (hl),a		; $696b
	ld l,$c2		; $696c
	ld e,l			; $696e
	ret			; $696f
	call $693b		; $6970
	ld e,$03		; $6973
	ld h,d			; $6975
	ld l,$cb		; $6976
	ld a,e			; $6978
	add b			; $6979
	cp (hl)			; $697a
	jr c,_label_11_296	; $697b
	sub e			; $697d
	sub e			; $697e
	cp (hl)			; $697f
	jr nc,_label_11_296	; $6980
	ld l,$cd		; $6982
	ld a,e			; $6984
	add c			; $6985
	cp (hl)			; $6986
	jr c,_label_11_296	; $6987
	sub e			; $6989
	sub e			; $698a
	cp (hl)			; $698b
	jr nc,_label_11_296	; $698c
	xor a			; $698e
	ret			; $698f
_label_11_296:
	or d			; $6990
	ret			; $6991
	push hl			; $6992
	ld a,(hl)		; $6993
	and $10			; $6994
	swap a			; $6996
	ld hl,$69a3		; $6998
	rst_addAToHl			; $699b
	ld c,(hl)		; $699c
	ld b,$fc		; $699d
	pop hl			; $699f
	jp objectCopyPositionWithOffset		; $69a0
	ld hl,sp+$08		; $69a3
	ld e,$f0		; $69a5
	ld a,(de)		; $69a7
	ld h,a			; $69a8
	ld l,$82		; $69a9
	ret			; $69ab


; ==============================================================================
; PARTID_CANDLE_FLAME
; ==============================================================================
partCode36:
	ld a,Object.id		; $69ac
	call objectGetRelatedObject1Var		; $69ae
	ld a,(hl)		; $69b1
	cp ENEMYID_CANDLE			; $69b2
	jp nz,partDelete		; $69b4

	ld b,h			; $69b7
	ld e,Part.state		; $69b8
	ld a,(de)		; $69ba
	rst_jumpTable			; $69bb
	.dw @state0
	.dw @state1
	.dw @state2


@state0:
	ld h,d			; $69c2
	ld l,e			; $69c3
	inc (hl) ; [state]
	call objectSetVisible81		; $69c5

@state1:
	; Check parent's speed
	ld h,b			; $69c8
	ld l,Enemy.speed		; $69c9
	ld a,(hl)		; $69cb
	cp SPEED_100			; $69cc
	jr z,@state2	; $69ce

	ld a,$02		; $69d0
	ld (de),a ; [state]

	push bc			; $69d3
	dec a			; $69d4
	call partSetAnimation		; $69d5
	pop bc			; $69d8

@state2:
	ld h,b			; $69d9
	ld l,Enemy.enemyCollisionMode		; $69da
	ld a,(hl)		; $69dc
	cp ENEMYCOLLISION_PODOBOO			; $69dd
	jp z,partDelete		; $69df

	call objectTakePosition		; $69e2
	ld e,Part.zh		; $69e5
	ld a,$f3		; $69e7
	ld (de),a		; $69e9
	jp partAnimate		; $69ea


; ==============================================================================
; PARTID_VERAN_PROJECTILE
; ==============================================================================
partCode37:
	jp nz,partDelete		; $69ed

	ld e,Part.subid		; $69f0
	ld a,(de)		; $69f2
	or a			; $69f3
	jp nz,_veranProjectile_subid1		; $69f4


; The "core" projectile spawner
_veranProjectile_subid0:
	ld a,Object.collisionType		; $69f7
	call objectGetRelatedObject1Var		; $69f9
	bit 7,(hl)		; $69fc
	jr z,@delete	; $69fe

	ld e,Part.state		; $6a00
	ld a,(de)		; $6a02
	rst_jumpTable			; $6a03
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6a0a
	ld l,e			; $6a0b
	inc (hl) ; [state]

	ld l,Part.zh		; $6a0d
	ld (hl),$fc		; $6a0f
	jp objectSetVisible81		; $6a11


; Moving upward
@state1:
	ld h,d			; $6a14
	ld l,Part.zh		; $6a15
	dec (hl)		; $6a17

	ld a,(hl)		; $6a18
	cp $f0			; $6a19
	jr nz,@animate	; $6a1b

	; Moved high enough to go to next state

	ld l,e			; $6a1d
	inc (hl) ; [state]

	ld l,Part.counter1		; $6a1f
	ld (hl),129		; $6a21
	jr @animate		; $6a23


; Firing projectiles every 8 frames until counter1 reaches 0
@state2:
	call partCommon_decCounter1IfNonzero		; $6a25
	jr z,@delete	; $6a28

	ld a,(hl)		; $6a2a
	and $07			; $6a2b
	jr nz,@animate	; $6a2d

	; Calculate angle in 'b' based on counter1
	ld a,(hl)		; $6a2f
	rrca			; $6a30
	rrca			; $6a31
	and $1f			; $6a32
	ld b,a			; $6a34

	; Create a projectile
	call getFreePartSlot		; $6a35
	jr nz,@animate	; $6a38
	ld (hl),PARTID_VERAN_PROJECTILE		; $6a3a
	inc l			; $6a3c
	inc (hl) ; [subid] = 1

	ld l,Part.angle		; $6a3e
	ld (hl),b		; $6a40

	call objectCopyPosition		; $6a41

@animate:
	jp partAnimate		; $6a44

@delete:
	ldbc INTERACID_PUFF,$80		; $6a47
	call objectCreateInteraction		; $6a4a
	jp partDelete		; $6a4d


; An individiual projectile
_veranProjectile_subid1:
	ld e,Part.state		; $6a50
	ld a,(de)		; $6a52
	rst_jumpTable			; $6a53
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6a5a
	ld l,e			; $6a5b
	inc (hl) ; [state]

	ld l,Part.speed		; $6a5d
	ld (hl),SPEED_280		; $6a5f

	ld l,Part.collisionRadiusY		; $6a61
	ld a,$04		; $6a63
	ldi (hl),a		; $6a65
	ld (hl),a		; $6a66

	call objectSetVisible81		; $6a67

	ld a,SND_VERAN_PROJECTILE		; $6a6a
	call playSound		; $6a6c

	ld a,$01		; $6a6f
	jp partSetAnimation		; $6a71


; Moving to ground as well as in normal direction
@state1:
	ld h,d			; $6a74
	ld l,Part.zh		; $6a75
	inc (hl)		; $6a77
	jr nz,@state2	; $6a78

	ld l,e			; $6a7a
	inc (hl) ; [state]


; Just moving normally
@state2:
	call objectApplySpeed		; $6a7c
	call partCommon_checkTileCollisionOrOutOfBounds		; $6a7f
	ret nz			; $6a82
	jp partDelete		; $6a83


; ==============================================================================
; PARTID_BALL
; Ball for the shooting gallery
; ==============================================================================
partCode38:
	jr z,_label_11_301	; $6a86
	ld e,$ea		; $6a88
	ld a,(de)		; $6a8a
	cp $80			; $6a8b
	jp z,partDelete		; $6a8d
	ld h,d			; $6a90
	ld l,$c4		; $6a91
	ld a,(hl)		; $6a93
	cp $02			; $6a94
	jr nc,_label_11_301	; $6a96
	ld (hl),$02		; $6a98
_label_11_301:
	ld h,d			; $6a9a
	ld l,$c6		; $6a9b
	ld a,(hl)		; $6a9d
	or a			; $6a9e
	jr z,_label_11_302	; $6a9f
	dec (hl)		; $6aa1
	ret			; $6aa2
_label_11_302:
	ld e,$c4		; $6aa3
	ld a,(de)		; $6aa5
	rst_jumpTable			; $6aa6
.dw $6aaf
.dw $6ae7
.dw $6b0c
.dw $6b24
	ld h,d			; $6aaf
	ld l,e			; $6ab0
	inc (hl)		; $6ab1
	ld l,$c9		; $6ab2
	ld (hl),$10		; $6ab4
	call objectSetVisible81		; $6ab6
	call getRandomNumber		; $6ab9
	and $0f			; $6abc
	ld hl,$6ad7		; $6abe
	rst_addAToHl			; $6ac1
	ld a,(hl)		; $6ac2
	ld h,d			; $6ac3
	ld l,$d0		; $6ac4
	or a			; $6ac6
	jr nz,_label_11_303	; $6ac7
	ld (hl),$64		; $6ac9
	ld a,SND_THROW		; $6acb
	jp playSound		; $6acd
_label_11_303:
	ld (hl),$3c		; $6ad0
	ld a,SND_FALLINHOLE		; $6ad2
	jp playSound		; $6ad4
	ld bc,$0101		; $6ad7
	ld bc,$0000		; $6ada
	nop			; $6add
	nop			; $6ade
	nop			; $6adf
	nop			; $6ae0
	nop			; $6ae1
	nop			; $6ae2
	nop			; $6ae3
	nop			; $6ae4
	nop			; $6ae5
	nop			; $6ae6
	call objectCheckWithinScreenBoundary		; $6ae7
	jp nc,$6c17		; $6aea
	call partCommon_checkTileCollisionOrOutOfBounds		; $6aed
	jr nc,_label_11_304	; $6af0
	call $6b00		; $6af2
	jr nc,_label_11_304	; $6af5
	jp z,$6c17		; $6af7
	jp $6bf6		; $6afa
_label_11_304:
	jp objectApplySpeed		; $6afd
	scf			; $6b00
	push af			; $6b01
	ld a,(hl)		; $6b02
	cp $0f			; $6b03
	jr z,_label_11_305	; $6b05
	pop af			; $6b07
	ccf			; $6b08
	ret			; $6b09
_label_11_305:
	pop af			; $6b0a
	ret			; $6b0b
	ld a,$03		; $6b0c
	ld (de),a		; $6b0e
	ld a,SND_CLINK		; $6b0f
	call playSound		; $6b11
	ld h,d			; $6b14
	ld l,$c6		; $6b15
	ld (hl),$00		; $6b17
	ld l,$d0		; $6b19
	ld (hl),$78		; $6b1b
	ld l,$ec		; $6b1d
	ld a,(hl)		; $6b1f
	ld l,$c9		; $6b20
	ld (hl),a		; $6b22
	ret			; $6b23
	call objectCheckWithinScreenBoundary		; $6b24
	jp nc,$6c17		; $6b27
	ld b,$ff		; $6b2a
	call $6b5f		; $6b2c
	call partCommon_checkTileCollisionOrOutOfBounds		; $6b2f
	jr nc,_label_11_306	; $6b32
	call $6b00		; $6b34
	jr nc,_label_11_306	; $6b37
	jp z,$6c17		; $6b39
	call $6c02		; $6b3c
_label_11_306:
	ld b,$02		; $6b3f
	call $6b5f		; $6b41
	call partCommon_checkTileCollisionOrOutOfBounds		; $6b44
	jr nc,_label_11_307	; $6b47
	call $6b00		; $6b49
	jr nc,_label_11_307	; $6b4c
	jp z,$6c17		; $6b4e
	call $6c08		; $6b51
_label_11_307:
	ld b,$ff		; $6b54
	call $6b5f		; $6b56
	call partAnimate		; $6b59
	jp objectApplySpeed		; $6b5c
	ld e,$cd		; $6b5f
	ld a,(de)		; $6b61
	add b			; $6b62
	ld (de),a		; $6b63
	ret			; $6b64
	call objectGetTileAtPosition		; $6b65
	ld a,l			; $6b68
	ldh (<hFF8C),a	; $6b69
	ld c,(hl)		; $6b6b
	call $6b71		; $6b6c
	jr _label_11_311		; $6b6f
	ld a,$ff		; $6b71
	ld ($cfd5),a		; $6b73
	xor a			; $6b76
_label_11_308:
	ldh (<hFF8B),a	; $6b77
	ld hl,$6bab		; $6b79
	rst_addAToHl			; $6b7c
	ld a,(hl)		; $6b7d
	cp c			; $6b7e
	jr nz,_label_11_310	; $6b7f
	ld a,($ccd6)		; $6b81
	and $7f			; $6b84
	cp $01			; $6b86
	ldh a,(<hFF8B)	; $6b88
	ld ($cfd5),a		; $6b8a
	jr z,_label_11_309	; $6b8d
	add $04			; $6b8f
_label_11_309:
	ld hl,bitTable		; $6b91
	add l			; $6b94
	ld l,a			; $6b95
	ld a,($ccd4)		; $6b96
	or (hl)			; $6b99
	ld ($ccd4),a		; $6b9a
	jr $10			; $6b9d
_label_11_310:
	ldh a,(<hFF8B)	; $6b9f
	inc a			; $6ba1
	cp $04			; $6ba2
	jr nz,_label_11_308	; $6ba4
	ld hl,$ccd6		; $6ba6
	dec (hl)		; $6ba9
	ret			; $6baa
	reti			; $6bab
	rst_addAToHl			; $6bac
	call c,$cdd8		; $6bad
	sub (hl)		; $6bb0
	jr nz,_label_11_315	; $6bb1
	ld a,$a0		; $6bb3
	call setTile		; $6bb5
	ld h,d			; $6bb8
	ld l,$c6		; $6bb9
	ld (hl),$03		; $6bbb
	ld a,($ccd6)		; $6bbd
	and $7f			; $6bc0
	cp $01			; $6bc2
	ret nz			; $6bc4
	ld a,SND_SWITCH		; $6bc5
	jp playSound		; $6bc7
_label_11_311:
	ld a,($cfd5)		; $6bca
	cp $ff			; $6bcd
	ret z			; $6bcf
	ld a,$04		; $6bd0
_label_11_312:
	ldh (<hFF8B),a	; $6bd2
	ld bc,$9204		; $6bd4
	ld a,($cfd5)		; $6bd7
	cp $02			; $6bda
	jr c,_label_11_313	; $6bdc
	ld bc,$9205		; $6bde
_label_11_313:
	call objectCreateInteraction		; $6be1
	jr nz,_label_11_314	; $6be4
	ld l,$4b		; $6be6
	ldh a,(<hFF8C)	; $6be8
	call setShortPosition		; $6bea
	ld l,$49		; $6bed
	ldh a,(<hFF8B)	; $6bef
	dec a			; $6bf1
	ld (hl),a		; $6bf2
	jr nz,_label_11_312	; $6bf3
_label_11_314:
	ret			; $6bf5
	ld a,SND_STRIKE		; $6bf6
	call playSound		; $6bf8
	ld a,$01		; $6bfb
	ld ($cfd6),a		; $6bfd
	jr _label_11_316		; $6c00
_label_11_315:
	call $6c0e		; $6c02
	jp $6b65		; $6c05
	call $6c0e		; $6c08
	jp $6b65		; $6c0b
	xor a			; $6c0e
	ld ($cfd6),a		; $6c0f
	ld hl,$ccd6		; $6c12
	inc (hl)		; $6c15
	ret			; $6c16
	xor a			; $6c17
	ld ($cfd6),a		; $6c18
	ld a,($ccd6)		; $6c1b
	and $7f			; $6c1e
	jr nz,_label_11_316	; $6c20
	ld a,SND_ERROR		; $6c22
	call playSound		; $6c24
_label_11_316:
	ld hl,$ccd6		; $6c27
	set 7,(hl)		; $6c2a
	jp partDelete		; $6c2c


; ==============================================================================
; PARTID_HEAD_THWOMP_FIREBALL
; ==============================================================================
partCode39:
	ld e,$c4		; $6c2f
	ld a,(de)		; $6c31
	rst_jumpTable			; $6c32
.dw $6c39
.dw $6c6a
.dw $6caa
	ld h,d			; $6c39
	ld l,e			; $6c3a
	inc (hl)		; $6c3b
	ld l,$c6		; $6c3c
	ld (hl),$1e		; $6c3e
	ld l,$d4		; $6c40
	ld a,$20		; $6c42
	ldi (hl),a		; $6c44
	ld (hl),$fc		; $6c45
	call getRandomNumber_noPreserveVars		; $6c47
	and $10			; $6c4a
	add $08			; $6c4c
	ld e,$c9		; $6c4e
	ld (de),a		; $6c50
	call getRandomNumber_noPreserveVars		; $6c51
	and $03			; $6c54
	ld hl,$6c66		; $6c56
	rst_addAToHl			; $6c59
	ld e,$d0		; $6c5a
	ld a,(hl)		; $6c5c
	ld (de),a		; $6c5d
	call objectSetVisible82		; $6c5e
	ld a,SND_FALLINHOLE		; $6c61
	jp playSound		; $6c63
	rrca			; $6c66
	add hl,de		; $6c67
	inc hl			; $6c68
	dec l			; $6c69
	call objectApplySpeed		; $6c6a
	ld h,d			; $6c6d
	ld l,$d4		; $6c6e
	ld e,$ca		; $6c70
	call add16BitRefs		; $6c72
	dec l			; $6c75
	ld a,(hl)		; $6c76
	add $20			; $6c77
	ldi (hl),a		; $6c79
	ld a,(hl)		; $6c7a
	adc $00			; $6c7b
	ld (hl),a		; $6c7d
	call partCommon_decCounter1IfNonzero		; $6c7e
	jr nz,_label_11_317	; $6c81
	ld a,(de)		; $6c83
	cp $b0			; $6c84
	jp nc,partDelete		; $6c86
	add $06			; $6c89
	ld b,a			; $6c8b
	ld l,$cd		; $6c8c
	ld c,(hl)		; $6c8e
	call checkTileCollisionAt_allowHoles		; $6c8f
	jr nc,_label_11_317	; $6c92
	ld h,d			; $6c94
	ld l,$c4		; $6c95
	inc (hl)		; $6c97
	ld l,$db		; $6c98
	ld a,$0b		; $6c9a
	ldi (hl),a		; $6c9c
	ldi (hl),a		; $6c9d
	ld (hl),$26		; $6c9e
	ld a,$01		; $6ca0
	call partSetAnimation		; $6ca2
	ld a,SND_BREAK_ROCK		; $6ca5
	jp playSound		; $6ca7
	ld e,$e1		; $6caa
	ld a,(de)		; $6cac
	bit 7,a			; $6cad
	jp nz,partDelete		; $6caf
	ld hl,$6cc0		; $6cb2
	rst_addAToHl			; $6cb5
	ld e,$e6		; $6cb6
	ldi a,(hl)		; $6cb8
	ld (de),a		; $6cb9
	inc e			; $6cba
	ld a,(hl)		; $6cbb
	ld (de),a		; $6cbc
_label_11_317:
	jp partAnimate		; $6cbd
	inc b			; $6cc0
	add hl,bc		; $6cc1
	ld b,$0b		; $6cc2
	add hl,bc		; $6cc4
	inc c			; $6cc5
	ld a,(bc)		; $6cc6
	dec c			; $6cc7
	dec bc			; $6cc8
	.db $0e


; ==============================================================================
; PARTID_VIRE_PROJECTILE
; ==============================================================================
partCode3a:
	jr z,+	 		; $6cca
	ld e,$ea		; $6ccc
	ld a,(de)		; $6cce
	res 7,a			; $6ccf
	cp $04			; $6cd1
	jp c,partDelete		; $6cd3
	jp $6e4a		; $6cd6
+
	ld e,$c2		; $6cd9
	ld a,(de)		; $6cdb
	ld e,$c4		; $6cdc
	rst_jumpTable			; $6cde
.dw $6ce7
.dw $6d06
.dw $6d39
.dw $6dfd
	ld a,(de)		; $6ce7
	or a			; $6ce8
	jr z,_label_11_319	; $6ce9
_label_11_318:
	call partCommon_checkOutOfBounds		; $6ceb
	jp z,partDelete		; $6cee
	call objectApplySpeed		; $6cf1
	jp partAnimate		; $6cf4
_label_11_319:
	call $6e50		; $6cf7
	call objectGetAngleTowardEnemyTarget		; $6cfa
	ld e,$c9		; $6cfd
	ld (de),a		; $6cff
	call $6e5d		; $6d00
	jp objectSetVisible80		; $6d03
	ld a,(de)		; $6d06
	or a			; $6d07
	jr nz,_label_11_318	; $6d08
	call $6e50		; $6d0a
	call $6e2f		; $6d0d
	ld e,$c3		; $6d10
	ld a,(de)		; $6d12
	or a			; $6d13
	ret nz			; $6d14
	call objectGetAngleTowardEnemyTarget		; $6d15
	ld e,$c9		; $6d18
	ld (de),a		; $6d1a
	sub $02			; $6d1b
	and $1f			; $6d1d
	ld b,a			; $6d1f
	ld e,$01		; $6d20
	call getFreePartSlot		; $6d22
	ld (hl),$3a		; $6d25
	inc l			; $6d27
	ld (hl),e		; $6d28
	inc l			; $6d29
	inc (hl)		; $6d2a
	ld l,$c9		; $6d2b
	ld (hl),b		; $6d2d
	ld l,$d6		; $6d2e
	ld e,l			; $6d30
	ld a,(de)		; $6d31
	ldi (hl),a		; $6d32
	inc e			; $6d33
	ld a,(de)		; $6d34
	ld (hl),a		; $6d35
	jp objectCopyPosition		; $6d36
	ld a,(de)		; $6d39
	rst_jumpTable			; $6d3a
.dw $6d43
.dw $6d84
.dw $6dc6
.dw $6ceb
	ld h,d			; $6d43
	ld l,$db		; $6d44
	ld a,$03		; $6d46
	ldi (hl),a		; $6d48
	ld (hl),a		; $6d49
	ld l,$c3		; $6d4a
	ld a,(hl)		; $6d4c
	or a			; $6d4d
	jr z,_label_11_320	; $6d4e
	ld l,e			; $6d50
	ld (hl),$03		; $6d51
	call $6e5d		; $6d53
	ld a,$01		; $6d56
	call partSetAnimation		; $6d58
	jp objectSetVisible82		; $6d5b
_label_11_320:
	call $6e50		; $6d5e
	ld l,$f0		; $6d61
	ldh a,(<hEnemyTargetY)	; $6d63
	ldi (hl),a		; $6d65
	ldh a,(<hEnemyTargetX)	; $6d66
	ld (hl),a		; $6d68
	ld a,$29		; $6d69
	call objectGetRelatedObject1Var		; $6d6b
	ld a,(hl)		; $6d6e
	ld b,$19		; $6d6f
	cp $10			; $6d71
	jr nc,_label_11_321	; $6d73
	ld b,$2d		; $6d75
	cp $0a			; $6d77
	jr nc,_label_11_321	; $6d79
	ld b,$41		; $6d7b
_label_11_321:
	ld e,$d0		; $6d7d
	ld a,b			; $6d7f
	ld (de),a		; $6d80
	jp objectSetVisible80		; $6d81
	ld h,d			; $6d84
	ld l,$f0		; $6d85
	ld b,(hl)		; $6d87
	inc l			; $6d88
	ld c,(hl)		; $6d89
	ld l,$cb		; $6d8a
	ldi a,(hl)		; $6d8c
	ldh (<hFF8F),a	; $6d8d
	inc l			; $6d8f
	ld a,(hl)		; $6d90
	ldh (<hFF8E),a	; $6d91
	sub c			; $6d93
	add $02			; $6d94
	cp $05			; $6d96
	jr nc,_label_11_322	; $6d98
	ldh a,(<hFF8F)	; $6d9a
	sub b			; $6d9c
	add $02			; $6d9d
	cp $05			; $6d9f
	jr nc,_label_11_322	; $6da1
	ld bc,$0502		; $6da3
	call objectCreateInteraction		; $6da6
	ret nz			; $6da9
	ld e,$d8		; $6daa
	ld a,$40		; $6dac
	ld (de),a		; $6dae
	inc e			; $6daf
	ld a,h			; $6db0
	ld (de),a		; $6db1
	ld e,$c4		; $6db2
	ld a,$02		; $6db4
	ld (de),a		; $6db6
	jp objectSetInvisible		; $6db7
_label_11_322:
	call objectGetRelativeAngleWithTempVars		; $6dba
	ld e,$c9		; $6dbd
	ld (de),a		; $6dbf
	call objectApplySpeed		; $6dc0
	jp partAnimate		; $6dc3
	ld a,$21		; $6dc6
	call objectGetRelatedObject2Var		; $6dc8
	bit 7,(hl)		; $6dcb
	ret z			; $6dcd
	ld b,$05		; $6dce
	call checkBPartSlotsAvailable		; $6dd0
	ret nz			; $6dd3
	ld c,$05		; $6dd4
_label_11_323:
	ld a,c			; $6dd6
	dec a			; $6dd7
	ld hl,$6df8		; $6dd8
	rst_addAToHl			; $6ddb
	ld b,(hl)		; $6ddc
	ld e,$02		; $6ddd
	call $6d22		; $6ddf
	dec c			; $6de2
	jr nz,_label_11_323	; $6de3
	ld h,d			; $6de5
	ld l,$c4		; $6de6
	inc (hl)		; $6de8
	ld l,$c9		; $6de9
	ld (hl),$1d		; $6deb
	call $6e5d		; $6ded
	ld a,$01		; $6df0
	call partSetAnimation		; $6df2
	jp objectSetVisible82		; $6df5
	inc bc			; $6df8
	ld ($130d),sp		; $6df9
	jr $1a			; $6dfc
	or a			; $6dfe
	jr z,_label_11_325	; $6dff
	call partCommon_decCounter1IfNonzero		; $6e01
	jp z,$6e4a		; $6e04
	inc l			; $6e07
	dec (hl)		; $6e08
	jr nz,_label_11_324	; $6e09
	ld (hl),$07		; $6e0b
	call objectGetAngleTowardEnemyTarget		; $6e0d
	call objectNudgeAngleTowards		; $6e10
_label_11_324:
	call objectApplySpeed		; $6e13
	jp partAnimate		; $6e16
_label_11_325:
	call $6e50		; $6e19
	ld l,$c6		; $6e1c
	ld (hl),$f0		; $6e1e
	inc l			; $6e20
	ld (hl),$07		; $6e21
	ld l,$db		; $6e23
	ld a,$02		; $6e25
	ldi (hl),a		; $6e27
	ld (hl),a		; $6e28
	call objectGetAngleTowardEnemyTarget		; $6e29
	ld e,$c9		; $6e2c
	ld (de),a		; $6e2e
	ld a,$29		; $6e2f
	call objectGetRelatedObject1Var		; $6e31
	ld a,(hl)		; $6e34
	ld b,$1e		; $6e35
	cp $10			; $6e37
	jr nc,_label_11_326	; $6e39
	ld b,$2d		; $6e3b
	cp $0a			; $6e3d
	jr nc,_label_11_326	; $6e3f
	ld b,$3c		; $6e41
_label_11_326:
	ld e,$d0		; $6e43
	ld a,b			; $6e45
	ld (de),a		; $6e46
	jp objectSetVisible80		; $6e47
	call objectCreatePuff		; $6e4a
	jp partDelete		; $6e4d
	ld h,d			; $6e50
	ld l,e			; $6e51
	inc (hl)		; $6e52
	ld l,$cf		; $6e53
	ld a,(hl)		; $6e55
	ld (hl),$00		; $6e56
	ld l,$cb		; $6e58
	add (hl)		; $6e5a
	ld (hl),a		; $6e5b
	ret			; $6e5c
	ld a,$29		; $6e5d
	call objectGetRelatedObject1Var		; $6e5f
	ld a,(hl)		; $6e62
	ld b,$3c		; $6e63
	cp $10			; $6e65
	jr nc,_label_11_327	; $6e67
	ld b,$5a		; $6e69
	cp $0a			; $6e6b
	jr nc,_label_11_327	; $6e6d
	ld b,$78		; $6e6f
_label_11_327:
	ld e,$d0		; $6e71
	ld a,b			; $6e73
	ld (de),a		; $6e74
	ret			; $6e75


; ==============================================================================
; PARTID_3b
; Used by head thwomp (purple face); a boulder.
; ==============================================================================
partCode3b:
	ld e,$c2		; $6e76
	ld a,(de)		; $6e78
	ld e,$c4		; $6e79
	or a			; $6e7b
	jr z,_label_11_328	; $6e7c
	jp $6ef3		; $6e7e
_label_11_328:
	ld a,(de)		; $6e81
	rst_jumpTable			; $6e82
.dw $6e89
.dw $6eae
.dw $6ed3
	ld h,d			; $6e89
	ld l,e			; $6e8a
	inc (hl)		; $6e8b
	ld l,$d5		; $6e8c
	ld (hl),$02		; $6e8e
	ld l,$cb		; $6e90
	ldh a,(<hCameraY)	; $6e92
	ldi (hl),a		; $6e94
	inc l			; $6e95
	ld a,(hl)		; $6e96
	or a			; $6e97
	jr nz,_label_11_329	; $6e98
	call getRandomNumber_noPreserveVars		; $6e9a
	and $7c			; $6e9d
	ld b,a			; $6e9f
	ldh a,(<hCameraX)	; $6ea0
	add b			; $6ea2
	ld e,$cd		; $6ea3
	ld (de),a		; $6ea5
_label_11_329:
	call objectSetVisible82		; $6ea6
	ld a,SND_FALLINHOLE		; $6ea9
	jp playSound		; $6eab
	ld a,$20		; $6eae
	call objectUpdateSpeedZ_sidescroll		; $6eb0
	jr c,_label_11_330	; $6eb3
	ld a,(de)		; $6eb5
	cp $b0			; $6eb6
	jr c,_label_11_331	; $6eb8
	jp partDelete		; $6eba
_label_11_330:
	ld h,d			; $6ebd
	ld l,$c4		; $6ebe
	inc (hl)		; $6ec0
	ld l,$db		; $6ec1
	ld a,$0b		; $6ec3
	ldi (hl),a		; $6ec5
	ldi (hl),a		; $6ec6
	ld (hl),$02		; $6ec7
	ld a,$01		; $6ec9
	call partSetAnimation		; $6ecb
	ld a,SND_BREAK_ROCK		; $6ece
	jp playSound		; $6ed0
	ld e,$e1		; $6ed3
	ld a,(de)		; $6ed5
	bit 7,a			; $6ed6
	jp nz,partDelete		; $6ed8
	ld hl,$6ee9		; $6edb
	rst_addAToHl			; $6ede
	ld e,$e6		; $6edf
	ldi a,(hl)		; $6ee1
	ld (de),a		; $6ee2
	inc e			; $6ee3
	ld a,(hl)		; $6ee4
	ld (de),a		; $6ee5
_label_11_331:
	jp partAnimate		; $6ee6
	inc b			; $6ee9
	add hl,bc		; $6eea
	ld b,$0b		; $6eeb
	add hl,bc		; $6eed
	inc c			; $6eee
	ld a,(bc)		; $6eef
	dec c			; $6ef0
	dec bc			; $6ef1
	ld c,$1a		; $6ef2
	rst_jumpTable			; $6ef4
.dw $6efb
.dw $6f23
.dw $6ed3
	ld h,d			; $6efb
	ld l,e			; $6efc
	inc (hl)		; $6efd
	ld l,$d5		; $6efe
	ld (hl),$02		; $6f00
	ld l,$cb		; $6f02
	ldi a,(hl)		; $6f04
	inc l			; $6f05
	or (hl)			; $6f06
	jr nz,_label_11_332	; $6f07
	call getRandomNumber_noPreserveVars		; $6f09
	and $7c			; $6f0c
	ld b,a			; $6f0e
	ldh a,(<hRng2)	; $6f0f
	and $7c			; $6f11
	ld c,a			; $6f13
	ld e,$cb		; $6f14
	ldh a,(<hCameraY)	; $6f16
	add b			; $6f18
	ld (de),a		; $6f19
	ld e,$cd		; $6f1a
	ldh a,(<hCameraX)	; $6f1c
	add c			; $6f1e
	ld (de),a		; $6f1f
_label_11_332:
	jp objectSetVisiblec2		; $6f20
	ld c,$20		; $6f23
	call objectUpdateSpeedZ_paramC		; $6f25
	jr nz,_label_11_331	; $6f28
	jr _label_11_330		; $6f2a


; ==============================================================================
; PARTID_3c
; Used by head thwomp
; ==============================================================================
partCode3c:
	jp nz,partDelete		; $6f2c
	ld e,$c4		; $6f2f
	ld a,(de)		; $6f31
	or a			; $6f32
	jr z,_label_11_334	; $6f33
	call partCommon_checkOutOfBounds		; $6f35
	jp z,partDelete		; $6f38
	call partCommon_decCounter1IfNonzero		; $6f3b
	jr nz,_label_11_333	; $6f3e
	inc l			; $6f40
	ld e,$f0		; $6f41
	ld a,(de)		; $6f43
	inc a			; $6f44
	and $01			; $6f45
	ld (de),a		; $6f47
	add (hl)		; $6f48
	ldd (hl),a		; $6f49
	ld (hl),a		; $6f4a
	ld l,$c9		; $6f4b
	ld e,$c2		; $6f4d
	ld a,(de)		; $6f4f
	add (hl)		; $6f50
	and $1f			; $6f51
	ld (hl),a		; $6f53
_label_11_333:
	call objectApplySpeed		; $6f54
	jp partAnimate		; $6f57
_label_11_334:
	ld h,d			; $6f5a
	ld l,e			; $6f5b
	inc (hl)		; $6f5c
	ld l,$c6		; $6f5d
	ld a,$02		; $6f5f
	ldi (hl),a		; $6f61
	ld (hl),a		; $6f62
	ld l,$d0		; $6f63
	ld (hl),$64		; $6f65
	call objectSetVisible82		; $6f67
	ld a,SND_BEAM		; $6f6a
	jp playSound		; $6f6c


; ==============================================================================
; PARTID_BLUE_STALFOS_PROJECTILE
;
; Variables:
;   var03: 0 for reflectable ball type, 1 otherwise
;   relatedObj1: Instance of ENEMYID_BLUE_STALFOS
; ==============================================================================
partCode3d:
	jr z,@normalStatus	; $6f6f

	ld h,d			; $6f71
	ld l,Part.subid		; $6f72
	ldi a,(hl)		; $6f74
	or (hl)			; $6f75
	jr nz,@normalStatus	; $6f76

	; Check if hit Link
	ld l,Part.var2a		; $6f78
	ld a,(hl)		; $6f7a
	res 7,a			; $6f7b
	or a ; ITEMCOLLISION_LINK
	jp z,_blueStalfosProjectile_hitLink		; $6f7e

	; Check if hit Link's sword
	sub ITEMCOLLISION_L1_SWORD			; $6f81
	cp ITEMCOLLISION_SWORDSPIN - ITEMCOLLISION_L1_SWORD + 1			; $6f83
	jr nc,@normalStatus	; $6f85

	; Reflect the ball if not already reflected
	ld l,Part.state		; $6f87
	ld a,(hl)		; $6f89
	cp $04			; $6f8a
	jr nc,@normalStatus	; $6f8c

	ld (hl),$04		; $6f8e
	ld l,Part.speed		; $6f90
	ld (hl),SPEED_200		; $6f92
	ld a,SND_UNKNOWN3		; $6f94
	call playSound		; $6f96

@normalStatus:
	ld e,Part.subid		; $6f99
	ld a,(de)		; $6f9b
	rst_jumpTable			; $6f9c
	.dw _blueStalfosProjectile_subid0
	.dw _blueStalfosProjectile_subid1


_blueStalfosProjectile_subid0:
	ld e,Part.state		; $6fa1
	ld a,(de)		; $6fa3
	rst_jumpTable			; $6fa4
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

; Initialization, deciding which ball type this should be
@state0:
	ld h,d			; $6fb3
	ld l,e			; $6fb4
	inc (hl) ; [state]

	ld l,Part.counter1		; $6fb6
	ld (hl),40		; $6fb8

	ld l,Part.yh		; $6fba
	ld a,(hl)		; $6fbc
	sub $18			; $6fbd
	ld (hl),a		; $6fbf

	ld l,Part.speed		; $6fc0
	ld (hl),SPEED_180		; $6fc2

	push hl			; $6fc4
	ld a,Object.var32		; $6fc5
	call objectGetRelatedObject1Var		; $6fc7
	ld a,(hl)		; $6fca
	inc a			; $6fcb
	and $07			; $6fcc
	ld (hl),a		; $6fce

	ld hl,@ballPatterns		; $6fcf
	call checkFlag		; $6fd2
	pop hl			; $6fd5
	jr z,++			; $6fd6

	; Non-reflectable ball
	ld (hl),SPEED_200		; $6fd8
	ld l,Part.enemyCollisionMode		; $6fda
	ld (hl),ENEMYCOLLISION_PODOBOO		; $6fdc
	ld l,Part.var03		; $6fde
	inc (hl)		; $6fe0
++
	ld a,SND_CHARGE		; $6fe1
	call playSound		; $6fe3
	jp objectSetVisible81		; $6fe6

; A bit being 0 means the ball will be reflectable. Cycles through the next bit every time
; a projectile is created.
@ballPatterns:
	.db %10101101


; Charging
@state1:
	call partCommon_decCounter1IfNonzero		; $6fea
	jr nz,@animate	; $6fed

	ld (hl),40 ; [counter1]
	inc l			; $6ff1
	inc (hl) ; [counter2]
	ld a,(hl)		; $6ff3
	cp $03			; $6ff4
	jp c,partSetAnimation		; $6ff6

	; Done charging
	ld (hl),20 ; [counter2]
	dec l			; $6ffb
	ld (hl),$00 ; [counter1]

	ld l,e			; $6ffe
	inc (hl) ; [state]

	ld l,Part.collisionType		; $7000
	set 7,(hl)		; $7002

	call objectGetAngleTowardEnemyTarget		; $7004
	ld e,Part.angle		; $7007
	ld (de),a		; $7009

	ld e,Part.var03		; $700a
	ld a,(de)		; $700c
	add $02			; $700d
	call partSetAnimation		; $700f
	ld a,SND_BEAM1		; $7012
	call playSound		; $7014
	jr @animate		; $7017


; Ball is moving (either version)
@state2:
	ld h,d			; $7019
	ld l,Part.counter2		; $701a
	dec (hl)		; $701c
	jr nz,+			; $701d
	ld l,e			; $701f
	inc (hl) ; [state]
+
	call _blueStalfosProjectile_checkShouldExplode		; $7021
	jr _blueStalfosProjectile_applySpeed		; $7024


; Ball is moving (baby ball only)
@state3:
	call _blueStalfosProjectile_checkShouldExplode		; $7026
	jr _blueStalfosProjectile_applySpeedAndDeleteIfOffScreen		; $7029


; Ball was just reflected (baby ball only)
@state4:
	ld h,d			; $702b
	ld l,e			; $702c
	inc (hl) ; [state]

	call objectGetAngleTowardEnemyTarget		; $702e
	xor $10			; $7031
	ld e,Part.angle		; $7033
	ld (de),a		; $7035
@animate:
	jp partAnimate		; $7036


; Ball is moving after being reflected (baby ball only)
@state5:
	call _blueStalfosProjectile_checkCollidedWithStalfos		; $7039
	jp c,partDelete		; $703c
	jr _blueStalfosProjectile_applySpeedAndDeleteIfOffScreen		; $703f


; Splits into 6 smaller projectiles (subid 1)
@state6:
	ld b,$06		; $7041
	call checkBPartSlotsAvailable		; $7043
	ret nz			; $7046
	call _blueStalfosProjectile_explode		; $7047
	ld a,SND_BEAM		; $704a
	call playSound		; $704c
	jp partDelete		; $704f


; Smaller projectile created from the explosion of the larger one
_blueStalfosProjectile_subid1:
	ld e,Part.state		; $7052
	ld a,(de)		; $7054
	or a			; $7055
	jr z,_blueStalfosProjectile_subid1_uninitialized	; $7056

_blueStalfosProjectile_applySpeedAndDeleteIfOffScreen:
	call partCommon_checkOutOfBounds		; $7058
	jp z,partDelete		; $705b

_blueStalfosProjectile_applySpeed:
	call objectApplySpeed		; $705e
	jp partAnimate		; $7061


_blueStalfosProjectile_subid1_uninitialized:
	ld h,d			; $7064
	ld l,e			; $7065
	inc (hl) ; [state]

	ld l,Part.collisionType		; $7067
	set 7,(hl)		; $7069
	ld l,Part.enemyCollisionMode		; $706b
	ld (hl),ENEMYCOLLISION_PODOBOO		; $706d

	ld l,Part.speed		; $706f
	ld (hl),SPEED_1c0		; $7071

	ld l,Part.damage		; $7073
	ld (hl),-4		; $7075

	ld l,Part.collisionRadiusY		; $7077
	ld a,$02		; $7079
	ldi (hl),a		; $707b
	ld (hl),a		; $707c

	add a ; a = 4
	call partSetAnimation		; $707e
	jp objectSetVisible81		; $7081


;;
; Explodes the projectile (sets state to 6) if it's the correct type and is close to Link.
; Returns from caller if so.
; @addr{7084}
_blueStalfosProjectile_checkShouldExplode:
	ld a,(wFrameCounter)		; $7084
	and $07			; $7087
	ret nz			; $7089

	call partCommon_decCounter1IfNonzero		; $708a
	ret nz			; $708d

	ld c,$28		; $708e
	call objectCheckLinkWithinDistance		; $7090
	ret nc			; $7093

	ld h,d			; $7094
	ld l,Part.counter1		; $7095
	dec (hl)		; $7097
	ld e,Part.var03		; $7098
	ld a,(de)		; $709a
	or a			; $709b
	ret z			; $709c

	pop bc ; Discard return address

	ld l,Part.collisionType		; $709e
	res 7,(hl)		; $70a0
	ld l,Part.state		; $70a2
	ld (hl),$06		; $70a4
	ret			; $70a6


;;
; @param[out]	cflag	c on collision
; @addr{70a7}
_blueStalfosProjectile_checkCollidedWithStalfos:
	ld a,Object.enabled		; $70a7
	call objectGetRelatedObject1Var		; $70a9
	call checkObjectsCollided		; $70ac
	ret nc			; $70af

	ld l,Enemy.invincibilityCounter		; $70b0
	ld (hl),30		; $70b2
	ld l,Enemy.state		; $70b4
	ld (hl),$14		; $70b6
	ret			; $70b8


;;
; Explodes into six parts
; @addr{70b9}
_blueStalfosProjectile_explode:
	ld c,$06		; $70b9
@next:
	call getFreePartSlot		; $70bb
	ld (hl),PARTID_BLUE_STALFOS_PROJECTILE		; $70be
	inc l			; $70c0
	inc (hl) ; [subid] = 1

	call objectCopyPosition		; $70c2

	; Copy ENEMYID_BLUE_STALFOS reference to new projectile
	ld l,Part.relatedObj1		; $70c5
	ld e,l			; $70c7
	ld a,(de)		; $70c8
	ldi (hl),a		; $70c9
	ld e,l			; $70ca
	ld a,(de)		; $70cb
	ld (hl),a		; $70cc

	; Set angle
	ld b,h			; $70cd
	ld a,c			; $70ce
	ld hl,@angleVals		; $70cf
	rst_addAToHl			; $70d2
	ld a,(hl)		; $70d3
	ld h,b			; $70d4
	ld l,Part.angle		; $70d5
	ld (hl),a		; $70d7

	dec c			; $70d8
	jr nz,@next	; $70d9
	ret			; $70db

@angleVals:
	.db $00 $00 $05 $0b $10 $15 $1b

_blueStalfosProjectile_hitLink:
	; [blueStalfos.state] = $10
	ld a,Object.state		; $70e3
	call objectGetRelatedObject1Var		; $70e5
	ld (hl),$10		; $70e8

	jp partDelete		; $70ea


; ==============================================================================
; PARTID_3e
; ==============================================================================
partCode3e:
	ld e,$c4		; $70ed
	ld a,(de)		; $70ef
	rst_jumpTable			; $70f0
.dw $70f9
.dw $7110
.dw $7129
.dw $714b
	ld h,d			; $70f9
	ld l,e			; $70fa
	inc (hl)		; $70fb
	ld e,$f0		; $70fc
	ld hl,$d081		; $70fe
_label_11_343:
	ld a,(hl)		; $7101
	cp $54			; $7102
	jr nz,_label_11_344	; $7104
	ld a,h			; $7106
	ld (de),a		; $7107
	inc e			; $7108
_label_11_344:
	inc h			; $7109
	ld a,h			; $710a
	cp $e0			; $710b
	jr c,_label_11_343	; $710d
	ret			; $710f
	ld hl,$d700		; $7110
_label_11_345:
	ld l,$24		; $7113
	ld a,(hl)		; $7115
	cp $98			; $7116
	jr z,_label_11_346	; $7118
	inc h			; $711a
	ld a,h			; $711b
	cp $dc			; $711c
	jr c,_label_11_345	; $711e
	ret			; $7120
_label_11_346:
	ld a,$02		; $7121
	ld (de),a		; $7123
	ld e,$d9		; $7124
	ld a,h			; $7126
	ld (de),a		; $7127
	ret			; $7128
	ld h,d			; $7129
	ld l,$c4		; $712a
	inc (hl)		; $712c
	ld l,$c6		; $712d
	ld (hl),$3c		; $712f
	ld l,$d9		; $7131
	ld b,(hl)		; $7133
	ld e,$f0		; $7134
_label_11_347:
	ld a,(de)		; $7136
	or a			; $7137
	ret z			; $7138
	ld h,a			; $7139
	ld l,$ba		; $713a
	ld (hl),$ff		; $713c
	ld l,$98		; $713e
	ld (hl),$00		; $7140
	inc l			; $7142
	ld (hl),b		; $7143
	inc e			; $7144
	ld a,e			; $7145
	cp $f4			; $7146
	jr c,_label_11_347	; $7148
	ret			; $714a
	call partCommon_decCounter1IfNonzero		; $714b
	ret nz			; $714e
	ld l,e			; $714f
	ld (hl),$01		; $7150
	ret			; $7152


; ==============================================================================
; PARTID_KING_MOBLIN_BOMB
;
; Variables:
;   relatedObj1: Instance of ENEMYID_KING_MOBLIN
;   var30: If nonzero, damage has been applied to Link
;   var31: Number of red flashes before it explodes
; ==============================================================================
partCode3f:
	ld e,Part.state		; $7153
	ld a,(de)		; $7155
	rst_jumpTable			; $7156
	.dw _kingMoblinBomb_state0
	.dw _common_kingMoblinBomb_state1
	.dw _kingMoblinBomb_state2
	.dw _kingMoblinBomb_state3
	.dw _kingMoblinBomb_state4
	.dw _kingMoblinBomb_state5
	.dw _kingMoblinBomb_state6
	.dw _kingMoblinBomb_state7
	.dw _kingMoblinBomb_state8


_kingMoblinBomb_state0:
	ld h,d			; $7169
	ld l,e			; $716a
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $716c
	ld (hl),SPEED_220		; $716e

	ld l,Part.yh		; $7170
	ld a,(hl)		; $7172
	add $08			; $7173
	ld (hl),a		; $7175

	call getRandomNumber_noPreserveVars		; $7176
	and $03			; $7179
	ld hl,@counter1Values		; $717b
	rst_addAToHl			; $717e
	ld e,Part.counter1		; $717f
	ld a,(hl)		; $7181
	ld (de),a		; $7182

	ld a,Object.health		; $7183
	call objectGetRelatedObject1Var		; $7185
	ld a,(hl)		; $7188
	dec a			; $7189
	ld hl,@numRedFlashes		; $718a
	rst_addAToHl			; $718d
	ld e,Part.var31		; $718e
	ld a,(hl)		; $7190
	ld (de),a		; $7191

	jp objectSetVisiblec2		; $7192

@counter1Values: ; One of these is chosen randomly.
	.db 120, 135, 160, 180

@numRedFlashes: ; Indexed by [kingMoblin.health] - 1.
	.db $06 $07 $08 $09 $0a $0c


; Bomb isn't doing anything except waiting to explode.
; This state's code is called by other states (2-4).
_common_kingMoblinBomb_state1:
	ld e,Part.counter1		; $719f
	ld a,(de)		; $71a1
	or a			; $71a2
	jr z,++			; $71a3
	ld a,(wFrameCounter)		; $71a5
	rrca			; $71a8
	ret c			; $71a9
++
	call partCommon_decCounter1IfNonzero		; $71aa
	ret nz			; $71ad

	ld l,Part.animParameter		; $71ae
	bit 0,(hl)		; $71b0
	jr z,@animate	; $71b2

	ld (hl),$00		; $71b4
	ld l,Part.counter2		; $71b6
	inc (hl)		; $71b8

	ld a,(hl)		; $71b9
	ld l,Part.var31		; $71ba
	cp (hl)			; $71bc
	jr nc,_kingMoblinBomb_explode	; $71bd

@animate:
	jp partAnimate		; $71bf

	; Unused code snippet?
	or d			; $71c2
	ret			; $71c3

_kingMoblinBomb_explode:
	ld l,Part.state		; $71c4
	ld (hl),$05		; $71c6

.ifdef ROM_SEASONS
	ld l,Part.collisionType		; $6fd2
	res 7,(hl)		; $6fd4
.endif

	ld l,Part.oamFlagsBackup		; $71c8
	ld a,$0a		; $71ca
	ldi (hl),a		; $71cc
	ldi (hl),a		; $71cd
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01		; $71d0
	call partSetAnimation		; $71d2
	call objectSetVisible82		; $71d5
	ld a,SND_EXPLOSION		; $71d8
	call playSound		; $71da
	xor a			; $71dd
	ret			; $71de


; Being held by Link
_kingMoblinBomb_state2:
	inc e			; $71df
	ld a,(de)		; $71e0
	rst_jumpTable			; $71e1
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld a,$01		; $71ea
	ld (de),a ; [state2] = 1
	xor a			; $71ed
	ld (wLinkGrabState2),a		; $71ee
.ifdef ROM_AGES
	call objectSetVisiblec1		; $71f1
.else
	jp objectSetVisiblec1
.endif

@beingHeld:
	call _common_kingMoblinBomb_state1		; $71f4
	ret nz			; $71f7
	jp dropLinkHeldItem		; $71f8

@released:
	; Drastically reduce speed when Y < $30 (on moblin's platform), Z = 0,
	; and subid = 0.
	ld e,Part.yh		; $71fb
	ld a,(de)		; $71fd
	cp $30			; $71fe
	jr nc,@beingHeld	; $7200

	ld h,d			; $7202
	ld l,Part.zh		; $7203
	ld e,Part.subid		; $7205
	ld a,(de)		; $7207
	or (hl)			; $7208
	jr nz,@beingHeld	; $7209

	; Reduce speed
	ld hl,w1ReservedItemC.speedZ+1		; $720b
	sra (hl)		; $720e
	dec l			; $7210
	rr (hl)			; $7211
	ld l,Item.speed		; $7213
	ld (hl),SPEED_40		; $7215

	jp _common_kingMoblinBomb_state1		; $7217

@atRest:
	ld e,Part.state		; $721a
	ld a,$04		; $721c
	ld (de),a		; $721e

	call objectSetVisiblec2		; $721f
	jr _kingMoblinBomb_state4		; $7222


; Being thrown. (King moblin sets the state to this.)
_kingMoblinBomb_state3:
	call _common_kingMoblinBomb_state1		; $7224
	ret z			; $7227

	ld c,$20		; $7228
	call objectUpdateSpeedZAndBounce		; $722a
	jr c,@doneBouncing	; $722d

	ld a,SND_BOMB_LAND		; $722f
	call z,playSound		; $7231
	jp objectApplySpeed		; $7234

@doneBouncing:
	ld a,SND_BOMB_LAND		; $7237
	call playSound		; $7239
	ld h,d			; $723c
	ld l,Part.state		; $723d
	inc (hl) ; [state] = 4


; Waiting to be picked up (by link or king moblin)
_kingMoblinBomb_state4:
	call _common_kingMoblinBomb_state1		; $7240
	ret z			; $7243
	jp objectAddToGrabbableObjectBuffer		; $7244


; Exploding
_kingMoblinBomb_state5:
	ld h,d			; $7247
	ld l,Part.animParameter		; $7248
	ld a,(hl)		; $724a
	inc a			; $724b
	jp z,partDelete		; $724c

	dec a			; $724f
	jr z,@animate	; $7250

	ld l,Part.collisionRadiusY		; $7252
	ldi (hl),a		; $7254
	ld (hl),a		; $7255
	call _kingMoblinBomb_checkCollisionWithLink		; $7256
	call _kingMoblinBomb_checkCollisionWithKingMoblin		; $7259
@animate:
	jp partAnimate		; $725c


; States 6-8 might be unused? Bomb is chucked way upward, then explodes on the ground.
_kingMoblinBomb_state6:
	ld bc,-$240		; $725f
	call objectSetSpeedZ		; $7262

	ld l,e			; $7265
	inc (hl) ; [state] = 7

	ld l,Part.speed		; $7267
	ld (hl),SPEED_c0		; $7269

	ld l,Part.counter1		; $726b
	ld (hl),$07		; $726d

	; Decide angle to throw at based on king moblin's position
	ld a,Object.xh		; $726f
	call objectGetRelatedObject1Var		; $7271
	ld a,(hl)		; $7274
	cp $50			; $7275
	ld a,$07		; $7277
	jr c,+			; $7279
	ld a,$19		; $727b
+
	ld e,Part.angle		; $727d
	ld (de),a		; $727f
	ret			; $7280


_kingMoblinBomb_state7:
	call partCommon_decCounter1IfNonzero		; $7281
	ret nz			; $7284

	ld l,e			; $7285
	inc (hl) ; [state] = 8


_kingMoblinBomb_state8:
	ld c,$20		; $7287
	call objectUpdateSpeedZAndBounce		; $7289
	jp nc,objectApplySpeed		; $728c

	ld h,d			; $728f
	jp _kingMoblinBomb_explode		; $7290

;;
; @addr{7293}
_kingMoblinBomb_checkCollisionWithLink:
	ld e,Part.var30		; $7293
	ld a,(de)		; $7295
	or a			; $7296
	ret nz			; $7297

	call checkLinkVulnerable		; $7298
	ret nc			; $729b

	call objectCheckCollidedWithLink_ignoreZ		; $729c
	ret nc			; $729f

	call objectGetAngleTowardEnemyTarget		; $72a0

	ld hl,w1Link.knockbackCounter		; $72a3
	ld (hl),$10		; $72a6
	dec l			; $72a8
	ldd (hl),a ; [w1Link.knockbackAngle]
	ld (hl),20 ; [w1Link.invincibilityCounter]
	dec l			; $72ac
	ld (hl),$01 ; [w1Link.var2a] (TODO: what does this mean?)

	ld e,Part.damage		; $72af
	ld l,<w1Link.damageToApply		; $72b1
	ld a,(de)		; $72b3
	ld (hl),a		; $72b4

	ld e,Part.var30		; $72b5
	ld a,$01		; $72b7
	ld (de),a		; $72b9
	ret			; $72ba

;;
; @addr{72bb}
_kingMoblinBomb_checkCollisionWithKingMoblin:
	ld e,Part.relatedObj1+1		; $72bb
	ld a,(de)		; $72bd
	or a			; $72be
	ret z			; $72bf

	; Check king moblin's collisions are enabled
	ld a,Object.collisionType		; $72c0
	call objectGetRelatedObject1Var		; $72c2
	bit 7,(hl)		; $72c5
	ret z			; $72c7

	ld l,Enemy.invincibilityCounter		; $72c8
	ld a,(hl)		; $72ca
	or a			; $72cb
	ret nz			; $72cc

	call checkObjectsCollided		; $72cd
	ret nc			; $72d0

	ld l,Enemy.var2a		; $72d1
	ld (hl),$80|ITEMCOLLISION_BOMB		; $72d3
	ld l,Enemy.invincibilityCounter		; $72d5
	ld (hl),30		; $72d7

	ld l,Enemy.health		; $72d9
	dec (hl)		; $72db
	ret			; $72dc


; ==============================================================================
; PARTID_40
; Used with bomb drop with head thwomp?
; relatedObj1 is a reference to a PARTID_ITEM_DROP instance.
; ==============================================================================
partCode40:
	ld a,$01		; $72dd
	call objectGetRelatedObject1Var		; $72df
	ld a,(hl)		; $72e2
	cp $01			; $72e3
	jp nz,partDelete		; $72e5
	ld e,$c4		; $72e8
	ld a,(de)		; $72ea
	or a			; $72eb
	jr z,_label_11_356	; $72ec
	ld a,$20		; $72ee
	call objectUpdateSpeedZ_sidescroll		; $72f0
	jp c,partDelete		; $72f3
	call objectApplySpeed		; $72f6
	ld a,$00		; $72f9
	call objectGetRelatedObject1Var		; $72fb
	jp objectCopyPosition		; $72fe
_label_11_356:
	ld h,d			; $7301
	ld l,e			; $7302
	inc (hl)		; $7303
	call getRandomNumber_noPreserveVars		; $7304
	ld b,a			; $7307
	and $03			; $7308
	ld hl,$732c		; $730a
	rst_addAToHl			; $730d
	ld e,$d0		; $730e
	ld a,(hl)		; $7310
	ld (de),a		; $7311
	ld a,b			; $7312
	and $60			; $7313
	swap a			; $7315
	ld hl,$7330		; $7317
	rst_addAToHl			; $731a
	ld e,$d4		; $731b
	ldi a,(hl)		; $731d
	ld (de),a		; $731e
	inc e			; $731f
	ld a,(hl)		; $7320
	ld (de),a		; $7321
	ldh a,(<hRng2)	; $7322
	and $10			; $7324
	add $08			; $7326
	ld e,$c9		; $7328
	ld (de),a		; $732a
	ret			; $732b
	inc d			; $732c
	add hl,de		; $732d
	ld e,$23		; $732e
	nop			; $7330
.DB $fd				; $7331
	ld ($ff00+$fc),a	; $7332
	ret nz			; $7334
.DB $fc				; $7335
	and b			; $7336
.DB $fc				; $7337


; ==============================================================================
; PARTID_SHADOW_HAG_SHADOW
; ==============================================================================
partCode41:
	ld e,Part.state		; $7338
	ld a,(de)		; $733a
	rst_jumpTable			; $733b
	.dw @state0
	.dw @state1
	.dw @state2
	.dw partDelete

; Initialization
@state0:
	ld h,d			; $7344
	ld l,e			; $7345
	inc (hl) ; [state]

	ld l,Part.counter1		; $7347
	ld (hl),$08		; $7349

	ld l,Part.speed		; $734b
	ld (hl),SPEED_100		; $734d

	ld e,Part.angle		; $734f
	ld a,(de)		; $7351
	ld hl,@angles		; $7352
	rst_addAToHl			; $7355
	ld a,(hl)		; $7356
	ld (de),a		; $7357

	call objectSetVisible82		; $7358
	ld a,$01		; $735b
	jp partSetAnimation		; $735d

@angles:
	.db $04 $0c $14 $1c


; Shadows chasing Link
@state1:
	; If [shadowHag.counter1] == $ff, the shadows should converge to her position.
	ld a,Object.counter1		; $7364
	call objectGetRelatedObject1Var		; $7366
	ld a,(hl)		; $7369
	inc a			; $736a
	jr nz,++		; $736b

	ld e,Part.state		; $736d
	ld a,$02		; $736f
	ld (de),a		; $7371
++
	call partCommon_decCounter1IfNonzero		; $7372
	jr nz,++		; $7375

	ld (hl),$08		; $7377
	call objectGetAngleTowardEnemyTarget		; $7379
	call objectNudgeAngleTowards		; $737c
++
	jp objectApplySpeed		; $737f


; Shadows converging back to shadow hag
@state2:
	ld a,Object.yh		; $7382
	call objectGetRelatedObject1Var		; $7384
	ld b,(hl)		; $7387
	ld l,Enemy.xh		; $7388
	ld c,(hl)		; $738a

	ld e,Part.yh		; $738b
	ld a,(de)		; $738d
	ldh (<hFF8F),a	; $738e
	ld e,Part.xh		; $7390
	ld a,(de)		; $7392
	ldh (<hFF8E),a	; $7393

	; Check if already close enough
	sub c			; $7395
	add $04			; $7396
	cp $09			; $7398
	jr nc,@updateAngleAndApplySpeed	; $739a
	ldh a,(<hFF8F)	; $739c
	sub b			; $739e
	add $04			; $739f
	cp $09			; $73a1
	jr nc,@updateAngleAndApplySpeed	; $73a3

	; We're close enough.

	; [shadowHag.counter2]--
	ld l,Enemy.counter2		; $73a5
	dec (hl)		; $73a7
	; [shadowHag.visible] = true
	ld l,Enemy.visible		; $73a8
	set 7,(hl)		; $73aa

	ld e,Part.state		; $73ac
	ld a,$03		; $73ae
	ld (de),a		; $73b0

@updateAngleAndApplySpeed:
	call objectGetRelativeAngleWithTempVars		; $73b1
	ld e,Part.angle		; $73b4
	ld (de),a		; $73b6
	jp objectApplySpeed		; $73b7


; ==============================================================================
; PARTID_PUMPKIN_HEAD_PROJECTILE
; ==============================================================================
partCode42:
	jp nz,partDelete		; $73ba
	ld e,$c4		; $73bd
	ld a,(de)		; $73bf
	rst_jumpTable			; $73c0
.dw $73c7
.dw $742c
.dw $7436
	ld h,d			; $73c7
	ld l,e			; $73c8
	inc (hl)		; $73c9
	ld l,$c6		; $73ca
	ld (hl),$08		; $73cc
	ld l,$d0		; $73ce
	ld (hl),$3c		; $73d0
	ld e,$cb		; $73d2
	ld l,$cf		; $73d4
	ld a,(de)		; $73d6
	add (hl)		; $73d7
	ld (de),a		; $73d8
	ld (hl),$00		; $73d9
	ld e,$c2		; $73db
	ld a,(de)		; $73dd
	ld bc,$7421		; $73de
	call addAToBc		; $73e1
	ld l,$c9		; $73e4
	ld a,(bc)		; $73e6
	add (hl)		; $73e7
	and $1f			; $73e8
	ld (hl),a		; $73ea
	ld a,(de)		; $73eb
	or a			; $73ec
	jr nz,_label_11_361	; $73ed
	ld a,(hl)		; $73ef
	rrca			; $73f0
	rrca			; $73f1
	ld hl,$7424		; $73f2
	rst_addAToHl			; $73f5
	ld e,$cb		; $73f6
	ld a,(de)		; $73f8
	add (hl)		; $73f9
	ld (de),a		; $73fa
	ld e,$cd		; $73fb
	inc hl			; $73fd
	ld a,(de)		; $73fe
	add (hl)		; $73ff
	ld (de),a		; $7400
	ld b,$02		; $7401
_label_11_360:
	call getFreePartSlot		; $7403
	jr nz,_label_11_361	; $7406
	ld (hl),$42		; $7408
	inc l			; $740a
	ld (hl),b		; $740b
	ld l,$c9		; $740c
	ld e,l			; $740e
	ld a,(de)		; $740f
	ld (hl),a		; $7410
	call objectCopyPosition		; $7411
	dec b			; $7414
	jr nz,_label_11_360	; $7415
_label_11_361:
	ld e,$c9		; $7417
	ld a,(de)		; $7419
	or a			; $741a
	jp z,objectSetVisible82		; $741b
	jp objectSetVisible81		; $741e
	nop			; $7421
	ld (bc),a		; $7422
	cp $fc			; $7423
	nop			; $7425
	ld (bc),a		; $7426
	inc b			; $7427
	inc b			; $7428
	nop			; $7429
	ld (bc),a		; $742a
.DB $fc				; $742b
	call partCommon_decCounter1IfNonzero		; $742c
	jr nz,_label_11_362	; $742f
	ld l,e			; $7431
	inc (hl)		; $7432
	call objectSetVisible82		; $7433
_label_11_362:
	call partAnimate		; $7436
	call objectApplySpeed		; $7439
	call partCommon_checkTileCollisionOrOutOfBounds		; $743c
	ret nc			; $743f
	jp partDelete		; $7440


; ==============================================================================
; PARTID_PLASMARINE_PROJECTILE
; ==============================================================================
partCode43:
	jr nz,@delete	; $7443

	ld a,Object.id		; $7445
	call objectGetRelatedObject1Var		; $7447
	ld a,(hl)		; $744a
	cp ENEMYID_PLASMARINE			; $744b
	jr nz,@delete	; $744d

	ld e,Part.state		; $744f
	ld a,(de)		; $7451
	or a			; $7452
	jr z,@state0	; $7453

@state1:
	; If projectile's color is different from plasmarine's color...
	ld l,Enemy.var32		; $7455
	ld e,Part.subid		; $7457
	ld a,(de)		; $7459
	cp (hl)			; $745a
	jr z,@noCollision		; $745b

	; Check for collision.
	call checkObjectsCollided		; $745d
	jr c,@collidedWithPlasmarine	; $7460

@noCollision:
	ld a,(wFrameCounter)		; $7462
	rrca			; $7465
	jr c,@updateMovement	; $7466

	call partCommon_decCounter1IfNonzero		; $7468
	jp z,partDelete		; $746b

	; Flicker visibility for 30 frames or less remaining
	ld a,(hl)		; $746e
	cp 30			; $746f
	jr nc,++		; $7471
	ld e,Part.visible		; $7473
	ld a,(de)		; $7475
	xor $80			; $7476
	ld (de),a		; $7478
++
	; Slowly home in on Link
	inc l			; $7479
	dec (hl) ; [this.counter2]--
	jr nz,@updateMovement	; $747b
	ld (hl),$10		; $747d
	call objectGetAngleTowardEnemyTarget		; $747f
	call objectNudgeAngleTowards		; $7482

@updateMovement:
	call objectApplySpeed		; $7485
	call partCommon_checkOutOfBounds		; $7488
	jp nz,partAnimate		; $748b
	jr @delete		; $748e

@collidedWithPlasmarine:
	ld l,Enemy.invincibilityCounter		; $7490
	ld a,(hl)		; $7492
	or a			; $7493
	jr nz,@noCollision	; $7494

	ld (hl),24
	ld l,Enemy.health		; $7498
	dec (hl)		; $749a
	jr nz,++		; $749b

	; Plasmarine is dead
	ld l,Enemy.collisionType		; $749d
	res 7,(hl)		; $749f
++
	ld a,SND_BOSS_DAMAGE		; $74a1
	call playSound		; $74a3
@delete:
	jp partDelete		; $74a6


@state0:
	ld l,Enemy.health		; $74a9
	ld a,(hl)		; $74ab
	cp $03			; $74ac
	ld a,SPEED_80		; $74ae
	jr nc,+			; $74b0
	ld a,SPEED_e0		; $74b2
+
	ld h,d			; $74b4
	ld l,e			; $74b5
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $74b7
	ld (hl),a		; $74b9

	ld l,Part.counter1		; $74ba
	ld (hl),150 ; [counter1] (lifetime counter)
	inc l			; $74be
	ld (hl),$08 ; [counter2]

	; Set color & animation
	ld l,Part.subid		; $74c1
	ld a,(hl)		; $74c3
	inc a			; $74c4
	ld l,Part.oamFlags		; $74c5
	ldd (hl),a		; $74c7
	ld (hl),a		; $74c8
	dec a			; $74c9
	call partSetAnimation		; $74ca

	; Move toward Link
	call objectGetAngleTowardEnemyTarget		; $74cd
	ld e,Part.angle		; $74d0
	ld (de),a		; $74d2

	jp objectSetVisible82		; $74d3


; ==============================================================================
; PARTID_TINGLE_BALLOON
; ==============================================================================
partCode44:
	jr nz,@beenHit	; $74d6

	ld e,Part.state		; $74d8
	ld a,(de)		; $74da
	or a			; $74db
	jr nz,@state1	; $74dc

@state0:
	ld h,d			; $74de
	ld l,e			; $74df
	inc (hl) ; [state] = 1

	ld l,Part.counter1		; $74e1
	ld (hl),$38		; $74e3
	inc l			; $74e5
	ld (hl),$ff ; [counter2]

	ld l,Part.zh		; $74e8
	ld (hl),$f1		; $74ea
	ld bc,-$10		; $74ec
	call objectSetSpeedZ		; $74ef

	xor a			; $74f2
	call partSetAnimation		; $74f3
	call objectSetVisible81		; $74f6

@state1:
	call partCommon_decCounter1IfNonzero		; $74f9
	jr nz,++		; $74fc

	; Reverse floating direction
	ld (hl),$38 ; [counter1]
	ld l,Part.speedZ		; $7500
	ld a,(hl)		; $7502
	cpl			; $7503
	inc a			; $7504
	ldi (hl),a		; $7505
	ld a,(hl)		; $7506
	cpl			; $7507
	ld (hl),a		; $7508
++
	ld c,$00		; $7509
	call objectUpdateSpeedZ_paramC		; $750b

	; Update Tingle's z position
	ld a,Object.zh		; $750e
	call objectGetRelatedObject1Var		; $7510
	ld e,Part.zh		; $7513
	ld a,(de)		; $7515
	ld (hl),a		; $7516
	ret			; $7517

@beenHit:
	ld a,Object.state		; $7518
	call objectGetRelatedObject1Var		; $751a
	inc (hl) ; [tingle.state] = 2

	; Spawn explosion
	call getFreeInteractionSlot		; $751e
	ld (hl),INTERACID_EXPLOSION		; $7521
	ld l,Interaction.var03		; $7523
	ld (hl),$01 ; Give it a higher draw priority?
	ld bc,$f000		; $7527
	call objectCopyPositionWithOffset		; $752a

	jp partDelete		; $752d


; ==============================================================================
; PARTID_45
; Falling boulder spawner?
; ==============================================================================
partCode45:
	ld e,$c4		; $7530
	ld a,(de)		; $7532
	rst_jumpTable			; $7533
.dw $753a
.dw $7562
.dw $758b
	ld h,d			; $753a
	ld l,e			; $753b
	inc (hl)		; $753c
	ld l,$d0		; $753d
	ld (hl),$32		; $753f
	ld l,$cb		; $7541
	ld a,(hl)		; $7543
	sub $08			; $7544
	jr z,_label_11_374	; $7546
	add $04			; $7548
_label_11_374:
	ldi (hl),a		; $754a
	ld e,$f0		; $754b
	ld (de),a		; $754d
	inc e			; $754e
	inc l			; $754f
	ld a,(hl)		; $7550
	ld (de),a		; $7551
	ld e,$c2		; $7552
	ld a,(de)		; $7554
	ld hl,$755e		; $7555
	rst_addAToHl			; $7558
	ld e,$c6		; $7559
	ld a,(hl)		; $755b
	ld (de),a		; $755c
	ret			; $755d
	dec l			; $755e
	ld e,d			; $755f
	add a			; $7560
	or h			; $7561
	call partCommon_decCounter1IfNonzero		; $7562
	ret nz			; $7565
	ld l,e			; $7566
	inc (hl)		; $7567
	ld l,$e4		; $7568
	set 7,(hl)		; $756a
	ld l,$d4		; $756c
	ld a,$60		; $756e
	ldi (hl),a		; $7570
	ld (hl),$fe		; $7571
_label_11_375:
	call getRandomNumber_noPreserveVars		; $7573
	and $07			; $7576
	cp $07			; $7578
	jr nc,_label_11_375	; $757a
	sub $03			; $757c
	add $10			; $757e
	ld e,$c9		; $7580
	ld (de),a		; $7582
	call objectSetVisiblec1		; $7583
	ld a,SND_RUMBLE		; $7586
	jp playSound		; $7588
	ld c,$20		; $758b
	call objectUpdateSpeedZ_paramC		; $758d
	call z,$756c		; $7590
	call objectApplySpeed		; $7593
	ld e,$cb		; $7596
	ld a,(de)		; $7598
	cp $88			; $7599
	jp c,partAnimate		; $759b
	ld h,d			; $759e
	ld l,$c4		; $759f
	dec (hl)		; $75a1
	ld l,$e4		; $75a2
	res 7,(hl)		; $75a4
	ld l,$c6		; $75a6
	ld (hl),$b4		; $75a8
	ld e,$f0		; $75aa
	ld l,$cb		; $75ac
	ld a,(de)		; $75ae
	ldi (hl),a		; $75af
	inc e			; $75b0
	inc l			; $75b1
	ld a,(de)		; $75b2
	ld (hl),a		; $75b3
	jp objectSetInvisible		; $75b4


; ==============================================================================
; PARTID_46
; ==============================================================================
partCode46:
	jr z,_label_11_376	; $75b7
	ld h,d			; $75b9
	ld l,$c6		; $75ba
	ld (hl),$2d		; $75bc
	ld l,$c2		; $75be
	ld a,(hl)		; $75c0
	and $07			; $75c1
	ld hl,wActiveTriggers		; $75c3
	call setFlag		; $75c6
	call objectSetVisible83		; $75c9
_label_11_376:
	ld e,$c4		; $75cc
	ld a,(de)		; $75ce
	or a			; $75cf
	jr z,_label_11_377	; $75d0
	call partCommon_decCounter1IfNonzero		; $75d2
	ret nz			; $75d5
	ld e,$c2		; $75d6
	ld a,(de)		; $75d8
	ld hl,wActiveTriggers		; $75d9
	call unsetFlag		; $75dc
	jp objectSetInvisible		; $75df
_label_11_377:
	inc a			; $75e2
	ld (de),a		; $75e3
	ret			; $75e4


; ==============================================================================
; PARTID_BOMB
; ==============================================================================
partCode47:
	ld e,Part.state		; $75e5
	ld a,(de)		; $75e7
	rst_jumpTable			; $75e8
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld h,d			; $75f1
	ld l,e			; $75f2
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $75f4
	ld (hl),SPEED_200		; $75f6

	ld l,Part.speedZ		; $75f8
	ld a,<(-$280)		; $75fa
	ldi (hl),a		; $75fc
	ld (hl),>(-$280)		; $75fd

	call objectSetVisiblec1		; $75ff

; Waiting to be thrown
@state1:
	ld a,$00		; $7602
	call objectGetRelatedObject1Var		; $7604
	jp objectTakePosition		; $7607

; Being thrown
@state2:
	call objectApplySpeed		; $760a
	ld c,$20		; $760d
	call objectUpdateSpeedZ_paramC		; $760f
	jp nz,partAnimate		; $7612

	; Landed on ground; time to explode

	ld l,Part.state		; $7615
	inc (hl) ; [state] = 4

	ld l,Part.collisionType		; $7618
	set 7,(hl)		; $761a

	ld l,Part.oamFlagsBackup		; $761c
	ld a,$0a		; $761e
	ldi (hl),a		; $7620
	ldi (hl),a		; $7621
	ld (hl),$0c ; [oamTileIndexBase]

	ld a,$01		; $7624
	call partSetAnimation		; $7626

	ld a,SND_EXPLOSION		; $7629
	call playSound		; $762b

	jp objectSetVisible83		; $762e

; Exploding
@state3:
	call partAnimate		; $7631
	ld e,Part.animParameter		; $7634
	ld a,(de)		; $7636
	inc a			; $7637
	jp z,partDelete		; $7638

	dec a			; $763b
	ld e,Part.collisionRadiusY		; $763c
	ld (de),a		; $763e
	inc e			; $763f
	ld (de),a		; $7640
	ret			; $7641


; ==============================================================================
; PARTID_OCTOGON_DEPTH_CHARGE
;
; Variables:
;   var30: gravity
; ==============================================================================
partCode48:
	jr z,@normalStatus	; $7642

	; For subid 1 only, delete self on collision with anything?
	ld e,Part.subid		; $7644
	ld a,(de)		; $7646
	or a			; $7647
	jp nz,partDelete		; $7648

@normalStatus:
	ld e,Part.subid		; $764b
	ld a,(de)		; $764d
	or a			; $764e
	ld e,Part.state		; $764f
	jr z,_octogonDepthCharge_subid0	; $7651


; Small (split) projectile
_octogonDepthCharge_subid1:
	ld a,(de)		; $7653
	or a			; $7654
	jr z,@state0	; $7655

@state1:
	call objectApplySpeed		; $7657
	call partCommon_checkTileCollisionOrOutOfBounds		; $765a
	jp nz,partAnimate		; $765d
	jp partDelete		; $7660

@state0:
	ld h,d			; $7663
	ld l,e			; $7664
	inc (hl) ; [state] = 1

	ld l,Part.collisionRadiusY		; $7666
	ld a,$02		; $7668
	ldi (hl),a		; $766a
	ld (hl),a		; $766b

	ld l,Part.speed		; $766c
	ld (hl),SPEED_180		; $766e
	ld a,$01		; $7670
	call partSetAnimation		; $7672
	jp objectSetVisible82		; $7675


; Large projectile, before being split into 4 smaller ones (subid 1)
_octogonDepthCharge_subid0:
	ld a,(de)		; $7678
	rst_jumpTable			; $7679
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,Object.visible		; $7682
	call objectGetRelatedObject1Var		; $7684
	ld a,(hl)		; $7687

	ld h,d			; $7688
	ld l,Part.state		; $7689
	inc (hl)		; $768b

	rlca			; $768c
	jr c,@aboveWater		; $768d

@belowWater:
	inc (hl) ; [state] = 2 (skips the "moving up" part)
	ld l,Part.counter1		; $7690
	inc (hl)		; $7692

	ld l,Part.zh		; $7693
	ld (hl),$b8		; $7695
	ld l,Part.var30		; $7697
	ld (hl),$10		; $7699

	; Choose random position to spawn at
	call getRandomNumber_noPreserveVars		; $769b
	and $06			; $769e
	ld hl,@positionCandidates		; $76a0
	rst_addAToHl			; $76a3
	ld e,Part.yh		; $76a4
	ldi a,(hl)		; $76a6
	ld (de),a		; $76a7
	ld e,Part.xh		; $76a8
	ld a,(hl)		; $76aa
	ld (de),a		; $76ab

	ld a,SND_SPLASH		; $76ac
	call playSound		; $76ae
	jr @setVisible81		; $76b1

@positionCandidates:
	.db $38 $48
	.db $38 $a8
	.db $78 $48
	.db $78 $a8

@aboveWater:
	; Is shot up before coming back down
	ld l,Part.var30		; $76bb
	ld (hl),$20		; $76bd

	ld l,Part.yh		; $76bf
	ld a,(hl)		; $76c1
	sub $10			; $76c2
	ld (hl),a		; $76c4

	ld a,SND_SCENT_SEED		; $76c5
	call playSound		; $76c7

@setVisible81:
	jp objectSetVisible81		; $76ca


; Above water: being shot up
@state1:
	ld h,d			; $76cd
	ld l,Part.zh		; $76ce
	dec (hl)		; $76d0
	dec (hl)		; $76d1

	ld a,(hl)		; $76d2
	cp $d0			; $76d3
	jr nc,@animate	; $76d5

	cp $b8			; $76d7
	jr nc,@flickerVisibility	; $76d9

	ld l,e			; $76db
	inc (hl) ; [state] = 2

	ld l,Part.counter1		; $76dd
	ld (hl),30		; $76df

	ld l,Part.collisionType		; $76e1
	res 7,(hl)		; $76e3

	ld l,Part.yh		; $76e5
	ldh a,(<hEnemyTargetY)	; $76e7
	ldi (hl),a		; $76e9
	inc l			; $76ea
	ldh a,(<hEnemyTargetX)	; $76eb
	ld (hl),a		; $76ed

	jp objectSetInvisible		; $76ee

@flickerVisibility:
	ld l,Part.visible		; $76f1
	ld a,(hl)		; $76f3
	xor $80			; $76f4
	ld (hl),a		; $76f6

@animate:
	jp partAnimate		; $76f7


; Delay before falling to ground
@state2:
	call partCommon_decCounter1IfNonzero		; $76fa
	ret nz			; $76fd

	ld l,e			; $76fe
	inc (hl) ; [state] = 3

	ld l,Part.collisionType		; $7700
	set 7,(hl)		; $7702
	jp objectSetVisiblec1		; $7704


; Falling to ground
@state3:
	ld e,Part.var30		; $7707
	ld a,(de)		; $7709
	call objectUpdateSpeedZ		; $770a
	jr nz,@animate	; $770d

	; Hit ground; split into four, then delete self.
	call getRandomNumber_noPreserveVars		; $770f
	and $04			; $7712
	ld b,a			; $7714
	ld c,$04		; $7715

@spawnNext:
	call getFreePartSlot		; $7717
	jr nz,++		; $771a
	ld (hl),PARTID_OCTOGON_DEPTH_CHARGE		; $771c
	inc l			; $771e
	inc (hl) ; [subid] = 1
	ld l,Part.angle		; $7720
	ld (hl),b		; $7722
	call objectCopyPosition		; $7723
	ld a,b			; $7726
	add $08			; $7727
	ld b,a			; $7729
++
	dec c			; $772a
	jr nz,@spawnNext	; $772b

	ld a,SND_UNKNOWN3		; $772d
	call playSound		; $772f
	jp partDelete		; $7732


; ==============================================================================
; PARTID_BIGBANG_BOMB_SPAWNER
; ==============================================================================
partCode49:
	ld e,$c4		; $7735
	ld a,(de)		; $7737
	rst_jumpTable			; $7738
.dw $7745
.dw $7765
.dw $7788
.dw $77a2
.dw $77cf
.dw $77e0
	ld h,d			; $7745
	ld l,$c2		; $7746
	ld a,(hl)		; $7748
	cp $ff			; $7749
	jr nz,_label_11_388	; $774b
	ld l,$c4		; $774d
	ld (hl),$05		; $774f
	jp $77f0		; $7751
_label_11_388:
	ld l,$c4		; $7754
	inc (hl)		; $7756
	call $78e3		; $7757
	call $793b		; $775a
	ld a,SND_POOF		; $775d
	call playSound		; $775f
	call objectSetVisiblec1		; $7762
	call objectApplySpeed		; $7765
	ld h,d			; $7768
	ld l,$f1		; $7769
	ld c,(hl)		; $776b
	call objectUpdateSpeedZAndBounce		; $776c
	jr c,_label_11_390	; $776f
	jr nz,_label_11_389	; $7771
	ld e,$d0		; $7773
	ld a,(de)		; $7775
	srl a			; $7776
	ld (de),a		; $7778
_label_11_389:
	jp partAnimate		; $7779
_label_11_390:
	ld h,d			; $777c
	ld l,$c4		; $777d
	ld (hl),$03		; $777f
	ld l,$c6		; $7781
	ld (hl),$14		; $7783
	jp partAnimate		; $7785
	inc e			; $7788
	ld a,(de)		; $7789
	rst_jumpTable			; $778a
.dw $7793
.dw $779c
.dw $779c
.dw $779d
	xor a			; $7793
	ld (wLinkGrabState2),a		; $7794
	inc a			; $7797
	ld (de),a		; $7798
	jp objectSetVisiblec1		; $7799
	ret			; $779c
	call objectSetVisiblec2		; $779d
	jr _label_11_391		; $77a0
	ld h,d			; $77a2
	ld l,$c6		; $77a3
	dec (hl)		; $77a5
	jr z,_label_11_391	; $77a6
	call partAnimate		; $77a8
	call $79ab		; $77ab
	jp objectAddToGrabbableObjectBuffer		; $77ae
_label_11_391:
	ld h,d			; $77b1
	ld l,$c4		; $77b2
	ld (hl),$04		; $77b4
	ld l,$e4		; $77b6
	set 7,(hl)		; $77b8
	ld l,$db		; $77ba
	ld a,$0a		; $77bc
	ldi (hl),a		; $77be
	ldi (hl),a		; $77bf
	ld (hl),$0c		; $77c0
	ld a,$01		; $77c2
	call partSetAnimation		; $77c4
	ld a,SND_EXPLOSION		; $77c7
	call playSound		; $77c9
	jp objectSetVisible83		; $77cc
	call partAnimate		; $77cf
	ld e,$e1		; $77d2
	ld a,(de)		; $77d4
	inc a			; $77d5
	jp z,partDelete		; $77d6
	dec a			; $77d9
	ld e,$e6		; $77da
	ld (de),a		; $77dc
	inc e			; $77dd
	ld (de),a		; $77de
	ret			; $77df
	ld h,d			; $77e0
	ld l,$f0		; $77e1
	dec (hl)		; $77e3
	ret nz			; $77e4
	ld l,$c6		; $77e5
	inc (hl)		; $77e7
	call $77f0		; $77e8
	jp z,partDelete		; $77eb
	jr _label_11_393		; $77ee
	ld h,d			; $77f0
	ld l,$c6		; $77f1
	ld a,(hl)		; $77f3
	ld bc,$780f		; $77f4
	call addDoubleIndexToBc		; $77f7
	ld a,(bc)		; $77fa
	cp $ff			; $77fb
	jr nz,_label_11_392	; $77fd
	ld a,$01		; $77ff
	ld ($cfc0),a		; $7801
	ret			; $7804
_label_11_392:
	ld l,$f0		; $7805
	ld (hl),a		; $7807
	inc bc			; $7808
	ld a,(bc)		; $7809
	ld l,$f5		; $780a
	ld (hl),a		; $780c
	or d			; $780d
	ret			; $780e
	inc a			; $780f
	ld bc,$013c		; $7810
	inc a			; $7813
	ld bc,$013c		; $7814
	inc a			; $7817
	ld bc,$013c		; $7818
	jr z,$01		; $781b
	jr z,$01		; $781d
	jr z,$01		; $781f
	jr z,$01		; $7821
	jr z,$01		; $7823
	ld e,$01		; $7825
	ld e,$01		; $7827
	ld e,$01		; $7829
	ld e,$01		; $782b
	ld e,$01		; $782d
	inc d			; $782f
	ld bc,$0114		; $7830
	inc d			; $7833
	ld bc,$0114		; $7834
	inc d			; $7837
	ld bc,$0214		; $7838
	inc d			; $783b
	ld (bc),a		; $783c
	inc d			; $783d
	ld (bc),a		; $783e
	inc d			; $783f
	ld (bc),a		; $7840
	inc d			; $7841
	ld (bc),a		; $7842
	inc d			; $7843
	ld (bc),a		; $7844
	inc d			; $7845
	ld (bc),a		; $7846
	inc d			; $7847
	ld (bc),a		; $7848
	inc d			; $7849
	ld (bc),a		; $784a
	inc d			; $784b
	ld (bc),a		; $784c
	inc d			; $784d
	ld (bc),a		; $784e
	inc d			; $784f
	ld (bc),a		; $7850
	inc d			; $7851
	ld (bc),a		; $7852
	inc d			; $7853
	ld (bc),a		; $7854
	or h			; $7855
	ld (bc),a		; $7856
	rst $38			; $7857
_label_11_393:
	xor a			; $7858
	ld e,$f2		; $7859
	ld (de),a		; $785b
	inc e			; $785c
	ld (de),a		; $785d
	call $78bd		; $785e
	ld e,$f5		; $7861
	ld a,(de)		; $7863
_label_11_394:
	ldh (<hFF92),a	; $7864
	call $786f		; $7866
	ldh a,(<hFF92)	; $7869
	dec a			; $786b
	jr nz,_label_11_394	; $786c
	ret			; $786e
_label_11_395:
	ld e,$f4		; $786f
	ld a,(de)		; $7871
	add a			; $7872
	add a			; $7873
	ld bc,$789d		; $7874
	call addDoubleIndexToBc		; $7877
	call getRandomNumber		; $787a
	and $07			; $787d
	call addAToBc		; $787f
	ld a,(bc)		; $7882
	ldh (<hFF8B),a	; $7883
	ld h,d			; $7885
	ld l,$f2		; $7886
	call checkFlag		; $7888
	jr nz,_label_11_395	; $788b
	call getFreePartSlot		; $788d
	ret nz			; $7890
	ld (hl),$49		; $7891
	inc l			; $7893
	ldh a,(<hFF8B)	; $7894
	ld (hl),a		; $7896
	ld h,d			; $7897
	ld l,$f2		; $7898
	jp setFlag		; $789a
	nop			; $789d
	ld bc,$0605		; $789e
	ld a,(bc)		; $78a1
	dec bc			; $78a2
	rrca			; $78a3
	nop			; $78a4
	ld bc,$0602		; $78a5
	rlca			; $78a8
	dec bc			; $78a9
	inc c			; $78aa
	dec c			; $78ab
	ld bc,$0403		; $78ac
	dec b			; $78af
	add hl,bc		; $78b0
	ld a,(bc)		; $78b1
	ld c,$0f		; $78b2
_label_11_396:
	inc bc			; $78b4
	ld (bc),a		; $78b5
	inc bc			; $78b6
	rlca			; $78b7
	ld ($0d09),sp		; $78b8
	ld c,$02		; $78bb
	ld a,(w1Link.xh)		; $78bd
	cp $50			; $78c0
	jr nc,_label_11_399	; $78c2
	ld a,(w1Link.yh)		; $78c4
_label_11_397:
	cp $40			; $78c7
	jr nc,_label_11_398	; $78c9
	xor a			; $78cb
	jr _label_11_401		; $78cc
_label_11_398:
	ld a,$01		; $78ce
	jr _label_11_401		; $78d0
_label_11_399:
	ld a,(w1Link.yh)		; $78d2
	cp $40			; $78d5
	jr nc,_label_11_400	; $78d7
	ld a,$02		; $78d9
	jr _label_11_401		; $78db
_label_11_400:
	ld a,$03		; $78dd
_label_11_401:
	ld e,$f4		; $78df
	ld (de),a		; $78e1
	ret			; $78e2
	ld h,d			; $78e3
	ld l,$c2		; $78e4
	ld a,(hl)		; $78e6
	ld hl,$791b		; $78e7
	rst_addDoubleIndex			; $78ea
	ld e,$cb		; $78eb
	ldi a,(hl)		; $78ed
	ld (de),a		; $78ee
	ld e,$cd		; $78ef
	ldi a,(hl)		; $78f1
	ld (de),a		; $78f2
	call objectGetAngleTowardLink		; $78f3
	ld e,$c9		; $78f6
	ld (de),a		; $78f8
	call getRandomNumber		; $78f9
	and $0f			; $78fc
	ld hl,$790b		; $78fe
	rst_addAToHl			; $7901
	ld b,(hl)		; $7902
	ld e,$c9		; $7903
	ld a,(de)		; $7905
	add b			; $7906
	and $1f			; $7907
	ld (de),a		; $7909
	ret			; $790a
	ld bc,$0302		; $790b
	rst $38			; $790e
	cp $fd			; $790f
	nop			; $7911
	nop			; $7912
	ld bc,$0202		; $7913
	rst $38			; $7916
	cp $00			; $7917
	nop			; $7919
	nop			; $791a
	nop			; $791b
	nop			; $791c
	nop			; $791d
	jr z,_label_11_402	; $791e
_label_11_402:
	ld d,b			; $7920
	nop			; $7921
	ld a,b			; $7922
	nop			; $7923
	and b			; $7924
	jr nz,_label_11_397	; $7925
	ld b,b			; $7927
	and b			; $7928
	ld h,b			; $7929
	and b			; $792a
	add b			; $792b
	and b			; $792c
	add b			; $792d
	ld a,b			; $792e
	add b			; $792f
	ld d,b			; $7930
	add b			; $7931
	jr z,_label_11_396	; $7932
	nop			; $7934
	ld h,b			; $7935
	nop			; $7936
	ld b,b			; $7937
	nop			; $7938
	jr nz,_label_11_403	; $7939
_label_11_403:
	call $78bd		; $793b
	ld e,$c2		; $793e
	ld a,(de)		; $7940
	add a			; $7941
	ld hl,$7962		; $7942
	rst_addDoubleIndex			; $7945
	ld e,$f4		; $7946
	ld a,(de)		; $7948
	rst_addAToHl			; $7949
	ld a,(hl)		; $794a
	ld bc,$79a2		; $794b
	call addAToBc		; $794e
	ld a,(bc)		; $7951
	ld h,d			; $7952
	ld l,$d0		; $7953
	ld (hl),a		; $7955
	ld l,$f1		; $7956
	ld (hl),$20		; $7958
	ld l,$d4		; $795a
	ld (hl),$80		; $795c
	inc l			; $795e
	ld (hl),$fd		; $795f
	ret			; $7961
	ld bc,$0504		; $7962
	ld ($0300),sp		; $7965
	inc b			; $7968
	dec b			; $7969
	nop			; $796a
	inc b			; $796b
	nop			; $796c
	inc b			; $796d
	inc bc			; $796e
	dec b			; $796f
	nop			; $7970
	inc b			; $7971
	dec b			; $7972
	ld ($0401),sp		; $7973
	dec b			; $7976
	ld b,$00		; $7977
	ld (bc),a		; $7979
	dec b			; $797a
	dec b			; $797b
	nop			; $797c
	nop			; $797d
	ld b,$05		; $797e
	ld (bc),a		; $7980
	nop			; $7981
	ld ($0405),sp		; $7982
	ld bc,$0305		; $7985
	inc b			; $7988
	nop			; $7989
	inc b			; $798a
	nop			; $798b
	inc b			; $798c
	nop			; $798d
	inc b			; $798e
	nop			; $798f
	dec b			; $7990
	inc bc			; $7991
	inc b			; $7992
	ld bc,$0508		; $7993
	ld (bc),a		; $7996
	nop			; $7997
	ld b,$05		; $7998
	nop			; $799a
	nop			; $799b
	inc b			; $799c
	inc b			; $799d
	nop			; $799e
	ld (bc),a		; $799f
	dec b			; $79a0
	ld b,$28		; $79a1
	ldd (hl),a		; $79a3
	inc a			; $79a4
	ld b,(hl)		; $79a5
	ld d,b			; $79a6
	ld e,d			; $79a7
	ld h,h			; $79a8
	ld l,(hl)		; $79a9
	ld a,b			; $79aa
	call objectGetShortPosition		; $79ab
	ld hl,wRoomLayout		; $79ae
	rst_addAToHl			; $79b1
	ld a,(hl)		; $79b2
	cp $54			; $79b3
	jr z,_label_11_404	; $79b5
	cp $55			; $79b7
	jr z,_label_11_405	; $79b9
	cp $56			; $79bb
	jr z,_label_11_406	; $79bd
	cp $57			; $79bf
	jr z,_label_11_407	; $79c1
	ret			; $79c3
_label_11_404:
	ld hl,$79e3		; $79c4
	ld e,$ca		; $79c7
	jr _label_11_408		; $79c9
_label_11_405:
	ld hl,$79e1		; $79cb
	ld e,$cc		; $79ce
	jr _label_11_408		; $79d0
_label_11_406:
	ld hl,$79e1		; $79d2
	ld e,$ca		; $79d5
	jr _label_11_408		; $79d7
_label_11_407:
	ld hl,$79e3		; $79d9
	ld e,$cc		; $79dc
_label_11_408:
	jp add16BitRefs		; $79de
	nop			; $79e1
	ld bc,$ff00		; $79e2


; ==============================================================================
; PARTID_SMOG_PROJECTILE
; ==============================================================================
partCode4a:
	ld e,Part.state		; $79e5
	ld a,(de)		; $79e7
	rst_jumpTable			; $79e8
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01		; $79ef
	ld (de),a ; [state] = 1

	call objectSetVisible81		; $79f2

	call objectGetAngleTowardLink		; $79f5
	ld e,Part.angle		; $79f8
	ld (de),a		; $79fa
	ld c,a			; $79fb

	ld a,SPEED_c0		; $79fc
	ld e,Part.speed		; $79fe
	ld (de),a		; $7a00

	; Check if this is a projectile from a large smog or a small smog
	ld e,Part.subid		; $7a01
	ld a,(de)		; $7a03
	or a			; $7a04
	jr z,@setAnimation	; $7a05

	; If from a large smog, change some properties
	ld a,SPEED_100		; $7a07
	ld e,Part.speed		; $7a09
	ld (de),a		; $7a0b

	ld a,$05		; $7a0c
	ld e,Part.oamFlags		; $7a0e
	ld (de),a		; $7a10

	ld e,Part.enemyCollisionMode		; $7a11
	ld a,ENEMYCOLLISION_PODOBOO		; $7a13
	ld (de),a		; $7a15

	ld a,c			; $7a16
	call convertAngleToDirection		; $7a17
	and $01			; $7a1a
	add $02			; $7a1c

@setAnimation:
	call partSetAnimation		; $7a1e

@state1:
	; Delete self if boss defeated
	call getThisRoomFlags		; $7a21
	bit 6,a			; $7a24
	jr nz,@delete	; $7a26

	ld a,(wNumEnemies)		; $7a28
	dec a			; $7a2b
	jr z,@delete	; $7a2c

	call objectCheckWithinScreenBoundary		; $7a2e
	jr nc,@delete	; $7a31

	call objectApplySpeed		; $7a33

	; If large smog's projectile, return (it passes through everything)
	ld e,Part.subid		; $7a36
	ld a,(de)		; $7a38
	or a			; $7a39
	ret nz			; $7a3a

	; Check for collision with items
	ld e,Part.var2a		; $7a3b
	ld a,(de)		; $7a3d
	or a			; $7a3e
	jr nz,@beginDestroyAnimation	; $7a3f

	; Check for collision with wall
	call _partCommon_getTileCollisionInFront		; $7a41
	jr z,@state2	; $7a44

@beginDestroyAnimation:
	ld h,d			; $7a46
	ld l,Part.collisionType		; $7a47
	res 7,(hl)		; $7a49

	ld a,$02		; $7a4b
	ld l,Part.state		; $7a4d
	ld (hl),a		; $7a4f

	dec a			; $7a50
	call partSetAnimation		; $7a51


@state2:
	call partAnimate		; $7a54
	ld e,Part.animParameter		; $7a57
	ld a,(de)		; $7a59
	or a			; $7a5a
	ret z			; $7a5b
@delete:
	jp partDelete		; $7a5c


; ==============================================================================
; PARTID_4f
; Used by Ramrock (seed form)
; ==============================================================================
partCode4f:
	ld e,$c4		; $7a5f
	ld a,(de)		; $7a61
	rst_jumpTable			; $7a62
.dw $7a69
.dw $7a78
.dw $7a99
	ld a,$01		; $7a69
	ld (de),a		; $7a6b
	inc a			; $7a6c
	call partSetAnimation		; $7a6d
	ld e,$c6		; $7a70
	ld a,$28		; $7a72
	ld (de),a		; $7a74
	jp objectSetVisible80		; $7a75
	call partAnimate		; $7a78
	ld a,$02		; $7a7b
	call objectGetRelatedObject1Var		; $7a7d
	ld a,(hl)		; $7a80
	cp $0f			; $7a81
	jr nz,_label_11_414	; $7a83
	call partCommon_decCounter1IfNonzero		; $7a85
	ret nz			; $7a88
	call objectGetAngleTowardLink		; $7a89
	ld e,$c9		; $7a8c
	ld (de),a		; $7a8e
	ld a,$50		; $7a8f
	ld e,$d0		; $7a91
	ld (de),a		; $7a93
	ld e,$c4		; $7a94
	ld a,$02		; $7a96
	ld (de),a		; $7a98
	call partAnimate		; $7a99
	call partCommon_decCounter1IfNonzero		; $7a9c
	jr nz,_label_11_413	; $7a9f
	ld (hl),$0a		; $7aa1
	call objectGetAngleTowardLink		; $7aa3
	jp objectNudgeAngleTowards		; $7aa6
_label_11_413:
	call objectApplySpeed		; $7aa9
	call objectCheckWithinScreenBoundary		; $7aac
	ret c			; $7aaf
_label_11_414:
	jp partDelete		; $7ab0


; ==============================================================================
; PARTID_54
; Boulder - falls from above when escaping Room of Rites collapse
; ==============================================================================
partCode54:
	ld e,$c2		; $7ab3
	ld a,(de)		; $7ab5
	or a			; $7ab6
	ld e,$c4		; $7ab7
	jp nz,$7adb		; $7ab9
	ld a,(de)		; $7abc
	or a			; $7abd
	jr z,_label_11_415	; $7abe
	call partCommon_decCounter1IfNonzero		; $7ac0
	jp z,partDelete		; $7ac3
	ld a,(hl)		; $7ac6
	and $0f			; $7ac7
	ret nz			; $7ac9
	call getFreePartSlot		; $7aca
	ret nz			; $7acd
	ld (hl),$54		; $7ace
	inc l			; $7ad0
	inc (hl)		; $7ad1
	ret			; $7ad2
_label_11_415:
	ld h,d			; $7ad3
	ld l,e			; $7ad4
	inc (hl)		; $7ad5
	ld l,$c6		; $7ad6
	ld (hl),$96		; $7ad8
	ret			; $7ada
	ld a,(de)		; $7adb
	or a			; $7adc
	jr nz,_label_11_416	; $7add
	inc a			; $7adf
	ld (de),a		; $7ae0
	ldh a,(<hCameraY)	; $7ae1
	ld b,a			; $7ae3
	ldh a,(<hCameraX)	; $7ae4
	ld c,a			; $7ae6
	call getRandomNumber		; $7ae7
	ld l,a			; $7aea
	and $07			; $7aeb
	swap a			; $7aed
	add $28			; $7aef
	add c			; $7af1
	ld e,$cd		; $7af2
	ld (de),a		; $7af4
	ld a,l			; $7af5
	and $70			; $7af6
	add $08			; $7af8
	ld l,a			; $7afa
	add b			; $7afb
	ld e,$cb		; $7afc
	ld (de),a		; $7afe
	ld a,l			; $7aff
	cpl			; $7b00
	inc a			; $7b01
	sub $07			; $7b02
	ld e,$cf		; $7b04
	ld (de),a		; $7b06
	jp objectSetVisiblec1		; $7b07
_label_11_416:
	ld c,$20		; $7b0a
	call objectUpdateSpeedZ_paramC		; $7b0c
	jp nz,partAnimate		; $7b0f
	call objectReplaceWithAnimationIfOnHazard		; $7b12
	jr c,_label_11_417	; $7b15
	ld b,$06		; $7b17
	call objectCreateInteractionWithSubid00		; $7b19
_label_11_417:
	jp partDelete		; $7b1c


; ==============================================================================
; PARTID_OCTOGON_BUBBLE
; ==============================================================================
partCode55:
	jr z,@normalStatus	; $7b1f

	; Collision occured with something. Check if it was Link.
	ld e,Part.var2a		; $7b21
	ld a,(de)		; $7b23
	cp $80|ITEMCOLLISION_LINK			; $7b24
	jp nz,@gotoState2		; $7b26

	call checkLinkVulnerable		; $7b29
	jr nc,@normalStatus	; $7b2c

	; Immobilize Link
	ld hl,wLinkForceState		; $7b2e
	ld a,LINK_STATE_COLLAPSED		; $7b31
	ldi (hl),a		; $7b33
	ld (hl),$01 ; [wcc50]

	ld h,d			; $7b36
	ld l,Part.state		; $7b37
	ld (hl),$03		; $7b39

	ld l,Part.zh		; $7b3b
	ld (hl),$00		; $7b3d

	ld l,Part.collisionType		; $7b3f
	res 7,(hl)		; $7b41
	call objectSetVisible81		; $7b43

@normalStatus:
	ld e,Part.state		; $7b46
	ld a,(de)		; $7b48
	rst_jumpTable			; $7b49
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3


; Uninitialized
@state0:
	ld h,d			; $7b52
	ld l,e			; $7b53
	inc (hl) ; [state] = 1

	ld l,Part.speed		; $7b55
	ld (hl),SPEED_80		; $7b57

	ld l,Part.counter1		; $7b59
	ld (hl),180		; $7b5b
	jp objectSetVisible82		; $7b5d


; Moving forward
@state1:
	call partCommon_decCounter1IfNonzero		; $7b60
	jr z,@gotoState2	; $7b63

	ld a,(wFrameCounter)		; $7b65
	and $18			; $7b68
	rlca			; $7b6a
	swap a			; $7b6b
	ld hl,@zPositions		; $7b6d
	rst_addAToHl			; $7b70
	ld e,Part.zh		; $7b71
	ld a,(hl)		; $7b73
	ld (de),a		; $7b74
	call objectApplySpeed		; $7b75
@animate:
	jp partAnimate		; $7b78

@zPositions:
	.db $ff $fe $ff $00


; Stopped in place, waiting for signal from animation to delete self
@state2:
	call partAnimate		; $7b7f
	ld e,Part.animParameter		; $7b82
	ld a,(de)		; $7b84
	inc a			; $7b85
	ret nz			; $7b86
	jp partDelete		; $7b87


; Collided with Link
@state3:
	ld hl,w1Link		; $7b8a
	call objectTakePosition		; $7b8d

	ld a,(wLinkForceState)		; $7b90
	cp LINK_STATE_COLLAPSED			; $7b93
	ret z			; $7b95

	ld l,<w1Link.state		; $7b96
	ldi a,(hl)		; $7b98
	cp LINK_STATE_COLLAPSED			; $7b99
	jr z,@animate	; $7b9b

@gotoState2:
	ld h,d			; $7b9d
	ld l,Part.state		; $7b9e
	ld (hl),$02		; $7ba0

	ld l,Part.collisionType		; $7ba2
	res 7,(hl)		; $7ba4

	ld a,$01		; $7ba6
	jp partSetAnimation		; $7ba8


; ==============================================================================
; PARTID_VERAN_SPIDERWEB
; ==============================================================================
partCode56:
	jr z,_label_11_421	; $7bab
	ld e,$ea		; $7bad
	ld a,(de)		; $7baf
	cp $80			; $7bb0
	jr nz,_label_11_421	; $7bb2
	ld hl,$d031		; $7bb4
	ld (hl),$10		; $7bb7
	ld l,$30		; $7bb9
	ld (hl),$00		; $7bbb
	ld l,$24		; $7bbd
	res 7,(hl)		; $7bbf
	ld bc,$fa00		; $7bc1
	call objectCopyPositionWithOffset		; $7bc4
	ld h,d			; $7bc7
	ld l,$f0		; $7bc8
	ld (hl),$01		; $7bca
	ld l,$c4		; $7bcc
	ldi a,(hl)		; $7bce
	dec a			; $7bcf
	jr nz,_label_11_421	; $7bd0
	inc l			; $7bd2
	ld a,$01		; $7bd3
	ldi (hl),a		; $7bd5
	ld (hl),a		; $7bd6
_label_11_421:
	ld e,$c2		; $7bd7
	ld a,(de)		; $7bd9
	ld e,$c4		; $7bda
	rst_jumpTable			; $7bdc
.dw $7be5
.dw $7c3c
.dw $7d1f
.dw $7d42
	ld a,(de)		; $7be5
	or a			; $7be6
	jr z,_label_11_424	; $7be7
	call partCommon_decCounter1IfNonzero		; $7be9
	jr nz,_label_11_422	; $7bec
	ld (hl),$04		; $7bee
	call getFreePartSlot		; $7bf0
	jr nz,_label_11_422	; $7bf3
	ld (hl),$56		; $7bf5
	inc l			; $7bf7
	ld (hl),$02		; $7bf8
	ld l,$d6		; $7bfa
	ld e,l			; $7bfc
	ld a,(de)		; $7bfd
	ldi (hl),a		; $7bfe
	inc e			; $7bff
	ld a,(de)		; $7c00
	ld (hl),a		; $7c01
	call objectCopyPosition		; $7c02
_label_11_422:
	ld a,$02		; $7c05
	call objectGetRelatedObject1Var		; $7c07
	ld a,(hl)		; $7c0a
	dec a			; $7c0b
	jp nz,$7c28		; $7c0c
	ld c,h			; $7c0f
	ldh a,(<hCameraY)	; $7c10
	ld b,a			; $7c12
	ld e,$cf		; $7c13
	ld a,(de)		; $7c15
	sub $04			; $7c16
	ld (de),a		; $7c18
	ld h,d			; $7c19
	ld l,$cb		; $7c1a
	add (hl)		; $7c1c
	sub b			; $7c1d
	cp $b0			; $7c1e
	ret c			; $7c20
	ld h,c			; $7c21
	ld l,$b8		; $7c22
	inc (hl)		; $7c24
	jp partDelete		; $7c25
_label_11_423:
	call objectCreatePuff		; $7c28
	jp partDelete		; $7c2b
_label_11_424:
	ld h,d			; $7c2e
	ld l,e			; $7c2f
	inc (hl)		; $7c30
	ld l,$c6		; $7c31
	inc (hl)		; $7c33
	call objectSetVisible80		; $7c34
_label_11_425:
	ld a,SND_BEAM2		; $7c37
	jp playSound		; $7c39
	ld a,$02		; $7c3c
	call objectGetRelatedObject1Var		; $7c3e
	ld a,(hl)		; $7c41
	dec a			; $7c42
	jr nz,_label_11_423	; $7c43
	ld l,$ad		; $7c45
	ld a,(hl)		; $7c47
	or a			; $7c48
	jr nz,_label_11_423	; $7c49
	ld e,$c4		; $7c4b
	ld a,(de)		; $7c4d
	rst_jumpTable			; $7c4e
.dw $7c59
.dw $7c92
.dw $7cc9
.dw $7cd1
.dw $7d10
	ld h,d			; $7c59
	ld l,e			; $7c5a
	inc (hl)		; $7c5b
	ld l,$c6		; $7c5c
	ld (hl),$01		; $7c5e
	inc l			; $7c60
	ld (hl),$05		; $7c61
	ld l,$e4		; $7c63
	set 7,(hl)		; $7c65
	ld l,$d0		; $7c67
	ld (hl),$50		; $7c69
	ld l,$f1		; $7c6b
	ld e,$cb		; $7c6d
	ld a,(de)		; $7c6f
	add $10			; $7c70
	ldi (hl),a		; $7c72
	ld (de),a		; $7c73
	ld e,$cd		; $7c74
	ld a,(de)		; $7c76
	ld (hl),a		; $7c77
	call objectGetAngleTowardLink		; $7c78
	cp $0e			; $7c7b
	ld b,$0c		; $7c7d
	jr c,_label_11_426	; $7c7f
	ld b,$10		; $7c81
	cp $13			; $7c83
	jr c,_label_11_426	; $7c85
	ld b,$14		; $7c87
_label_11_426:
	ld e,$c9		; $7c89
	ld a,b			; $7c8b
	ld (de),a		; $7c8c
	call objectSetVisible81		; $7c8d
	jr _label_11_425		; $7c90
	call partCommon_decCounter1IfNonzero		; $7c92
	jr nz,_label_11_427	; $7c95
	ld (hl),$08		; $7c97
	inc l			; $7c99
	dec (hl)		; $7c9a
	jr z,_label_11_428	; $7c9b
	call getFreePartSlot		; $7c9d
	jr nz,_label_11_427	; $7ca0
	ld (hl),$56		; $7ca2
	inc l			; $7ca4
	ld (hl),$03		; $7ca5
	ld l,$d6		; $7ca7
	ld a,$c0		; $7ca9
	ldi (hl),a		; $7cab
	ld (hl),d		; $7cac
	call objectCopyPosition		; $7cad
_label_11_427:
	call partCommon_checkTileCollisionOrOutOfBounds		; $7cb0
	jp nc,objectApplySpeed		; $7cb3
_label_11_428:
	ld h,d			; $7cb6
	ld l,$c4		; $7cb7
	inc (hl)		; $7cb9
	ld l,$c6		; $7cba
	ld (hl),$1e		; $7cbc
	ld l,$d0		; $7cbe
	ld (hl),$3c		; $7cc0
	ld l,$c9		; $7cc2
	ld a,(hl)		; $7cc4
	xor $10			; $7cc5
	ld (hl),a		; $7cc7
	ret			; $7cc8
	call partCommon_decCounter1IfNonzero		; $7cc9
	ret nz			; $7ccc
	ld l,$c4		; $7ccd
	inc (hl)		; $7ccf
	ret			; $7cd0
	call objectApplySpeed		; $7cd1
	ld e,$f0		; $7cd4
	ld a,(de)		; $7cd6
	or a			; $7cd7
	jr z,_label_11_429	; $7cd8
	ld bc,$fa00		; $7cda
	ld hl,$d000		; $7cdd
	call objectCopyPositionWithOffset		; $7ce0
_label_11_429:
	ld h,d			; $7ce3
	ld l,$f1		; $7ce4
	ld e,$cb		; $7ce6
	ld a,(de)		; $7ce8
	sub (hl)		; $7ce9
	add $02			; $7cea
	cp $05			; $7cec
	ret nc			; $7cee
	ld l,$f2		; $7cef
	ld e,$cd		; $7cf1
	ld a,(de)		; $7cf3
	sub (hl)		; $7cf4
	add $02			; $7cf5
	cp $05			; $7cf7
	ret nc			; $7cf9
	ld a,$38		; $7cfa
	call objectGetRelatedObject1Var		; $7cfc
	inc (hl)		; $7cff
	ld e,$f0		; $7d00
	ld a,(de)		; $7d02
	or a			; $7d03
	jp z,partDelete		; $7d04
	ld l,$86		; $7d07
	ld (hl),$08		; $7d09
	ld h,d			; $7d0b
	ld l,$c4		; $7d0c
	inc (hl)		; $7d0e
	ret			; $7d0f
	ld hl,$d005		; $7d10
	ld a,(hl)		; $7d13
	cp $02			; $7d14
	jp z,partDelete		; $7d16
	ld bc,$0600		; $7d19
	jp objectTakePositionWithOffset		; $7d1c
	ld a,(de)		; $7d1f
	or a			; $7d20
	jr z,_label_11_431	; $7d21
	ld a,$1a		; $7d23
	call objectGetRelatedObject1Var		; $7d25
	bit 7,(hl)		; $7d28
	jr z,_label_11_430	; $7d2a
	ld l,$8f		; $7d2c
	ld b,(hl)		; $7d2e
	dec b			; $7d2f
	ld e,$cf		; $7d30
	ld a,(de)		; $7d32
	dec a			; $7d33
	cp b			; $7d34
	ret c			; $7d35
_label_11_430:
	jp partDelete		; $7d36
_label_11_431:
	inc a			; $7d39
	ld (de),a		; $7d3a
	inc a			; $7d3b
	call partSetAnimation		; $7d3c
	jp objectSetVisible80		; $7d3f
	ld a,(de)		; $7d42
	or a			; $7d43
	jr z,_label_11_433	; $7d44
	ld a,$01		; $7d46
	call objectGetRelatedObject1Var		; $7d48
	ld a,(hl)		; $7d4b
	cp $56			; $7d4c
	jr nz,_label_11_432	; $7d4e
	ld l,$cb		; $7d50
	ld e,l			; $7d52
	ld a,(de)		; $7d53
	cp (hl)			; $7d54
	ret c			; $7d55
_label_11_432:
	jp partDelete		; $7d56
_label_11_433:
	inc a			; $7d59
	ld (de),a		; $7d5a
	ld a,$09		; $7d5b
	call objectGetRelatedObject1Var		; $7d5d
	ld a,(hl)		; $7d60
	sub $0c			; $7d61
	rrca			; $7d63
	rrca			; $7d64
	inc a			; $7d65
	call partSetAnimation		; $7d66
	jp objectSetVisible83		; $7d69


; ==============================================================================
; PARTID_57
; Used by ENEMYID_VERAN_FINAL_FORM
; ==============================================================================
partCode57:
	ld e,$c4		; $7d6c
	ld a,(de)		; $7d6e
	rst_jumpTable			; $7d6f
.dw $7d7e
.dw $7d9c
.dw $7dad
.dw $7dc7
.dw $7dcf
.dw $7dd6
.dw $7e10
	call objectCenterOnTile		; $7d7e
	call objectGetShortPosition		; $7d81
	ld e,$f0		; $7d84
	ld (de),a		; $7d86
	ld e,$c6		; $7d87
	ld a,$04		; $7d89
	ld (de),a		; $7d8b
	ld a,SND_UNKNOWN3		; $7d8c
	call playSound		; $7d8e
	ld hl,$7d98		; $7d91
	ld a,$60		; $7d94
	jr _label_11_434		; $7d96
	ld a,($ff00+R_IE)	; $7d98
	ld bc,wScreenScrollRow		; $7d9a
	and a			; $7d9d
	ld b,b			; $7d9e
	ret nz			; $7d9f
	ld (hl),$04		; $7da0
	ld hl,$7da9		; $7da2
	ld a,$60		; $7da5
	jr _label_11_434		; $7da7
	rst $28			; $7da9
	pop af			; $7daa
	rrca			; $7dab
	ld de,$a7cd		; $7dac
	ld b,b			; $7daf
	ret nz			; $7db0
	ld (hl),$2d		; $7db1
	ld l,e			; $7db3
	inc (hl)		; $7db4
	ld l,$60		; $7db5
	ld e,$f0		; $7db7
	ld a,(de)		; $7db9
	ld c,a			; $7dba
	ld b,$cf		; $7dbb
	ld a,(bc)		; $7dbd
	sub $02			; $7dbe
	cp $03			; $7dc0
	ret c			; $7dc2
	ld a,l			; $7dc3
	jp setTile		; $7dc4
	call partCommon_decCounter1IfNonzero		; $7dc7
	ret nz			; $7dca
	ld (hl),$04		; $7dcb
	ld l,e			; $7dcd
	inc (hl)		; $7dce
	ld hl,$7da9		; $7dcf
	ld a,$a0		; $7dd2
	jr _label_11_434		; $7dd4
	call partCommon_decCounter1IfNonzero		; $7dd6
	ret nz			; $7dd9
	ld (hl),$04		; $7dda
	ld hl,$7d98		; $7ddc
	ld a,$a0		; $7ddf
_label_11_434:
	ldh (<hFF8B),a	; $7de1
	ld e,$f0		; $7de3
	ld a,(de)		; $7de5
	ld c,a			; $7de6
	ld b,$04		; $7de7
_label_11_435:
	push bc			; $7de9
	ldi a,(hl)		; $7dea
	add c			; $7deb
	ld c,a			; $7dec
	ld b,$cf		; $7ded
	ld a,(bc)		; $7def
	cp $da			; $7df0
	jr z,_label_11_436	; $7df2
	sub $02			; $7df4
	cp $03			; $7df6
	jr c,_label_11_437	; $7df8
	ld b,$ce		; $7dfa
	ld a,(bc)		; $7dfc
	or a			; $7dfd
	jr nz,_label_11_437	; $7dfe
_label_11_436:
	ldh a,(<hFF8B)	; $7e00
	push hl			; $7e02
	call setTile		; $7e03
	pop hl			; $7e06
_label_11_437:
	pop bc			; $7e07
	dec b			; $7e08
	jr nz,_label_11_435	; $7e09
	ld h,d			; $7e0b
	ld l,$c4		; $7e0c
	inc (hl)		; $7e0e
	ret			; $7e0f
	call partCommon_decCounter1IfNonzero		; $7e10
	ret nz			; $7e13
	ld l,$a0		; $7e14
	call $7db7		; $7e16
	jp partDelete		; $7e19


; ==============================================================================
; PARTID_VERAN_BEE_PROJECTILE
; ==============================================================================
partCode58:
	jr z,_label_11_438	; $7e1c
	ld e,$ea		; $7e1e
	ld a,(de)		; $7e20
	cp $80			; $7e21
	jr nz,_label_11_438	; $7e23
	ld h,d			; $7e25
	ld l,$e4		; $7e26
	res 7,(hl)		; $7e28
	ld l,$c4		; $7e2a
	ld (hl),$03		; $7e2c
	ld l,$c6		; $7e2e
	ld (hl),$f0		; $7e30
	call objectSetInvisible		; $7e32
_label_11_438:
	ld e,$c4		; $7e35
	ld a,(de)		; $7e37
	rst_jumpTable			; $7e38
.dw $7e41
.dw $7e58
.dw $7e6a
.dw $7e76
	ld h,d			; $7e41
	ld l,e			; $7e42
	inc (hl)		; $7e43
	ld l,$c9		; $7e44
	ld (hl),$10		; $7e46
	ld l,$d0		; $7e48
	ld (hl),$78		; $7e4a
	ld l,$c6		; $7e4c
	ld (hl),$09		; $7e4e
	ld a,SND_BEAM		; $7e50
	call playSound		; $7e52
	call objectSetVisible83		; $7e55
	call partCommon_decCounter1IfNonzero		; $7e58
	jr z,_label_11_439	; $7e5b
	ld a,$0b		; $7e5d
	call objectGetRelatedObject1Var		; $7e5f
	ld bc,$1400		; $7e62
	jp objectTakePositionWithOffset		; $7e65
_label_11_439:
	ld l,e			; $7e68
	inc (hl)		; $7e69
	call objectApplySpeed		; $7e6a
	ld e,$cb		; $7e6d
	ld a,(de)		; $7e6f
	cp $b0			; $7e70
	ret c			; $7e72
	jp partDelete		; $7e73
	call partCommon_decCounter1IfNonzero		; $7e76
	jp z,partDelete		; $7e79
	ld a,(wGameKeysJustPressed)		; $7e7c
	or a			; $7e7f
	jr z,_label_11_441	; $7e80
	ld a,(hl)		; $7e82
	sub $0a			; $7e83
	jr nc,_label_11_440	; $7e85
	ld a,$01		; $7e87
_label_11_440:
	ld (hl),a		; $7e89
_label_11_441:
	ld hl,wccd8		; $7e8a
	set 5,(hl)		; $7e8d
	ld a,(wFrameCounter)		; $7e8f
	rrca			; $7e92
	ret nc			; $7e93
	ld hl,wLinkImmobilized		; $7e94
	set 5,(hl)		; $7e97
	ret			; $7e99


; ==============================================================================
; PARTID_59
; ==============================================================================
partCode59:
	ld e,$c4		; $7e9a
	ld a,(de)		; $7e9c
	rst_jumpTable			; $7e9d
.dw $7eaa
.dw $7ec1
.dw $7edc
.dw $7ee7
.dw $7f03
.dw $7f30
	ld h,d			; $7eaa
	ld l,e			; $7eab
	inc (hl)		; $7eac
	ld l,$d0		; $7ead
	ld (hl),$14		; $7eaf
	ld l,$c2		; $7eb1
	ld a,(hl)		; $7eb3
	ld hl,$7ebd		; $7eb4
	rst_addAToHl			; $7eb7
	ld e,$c6		; $7eb8
	ld a,(hl)		; $7eba
	ld (de),a		; $7ebb
	ret			; $7ebc
	ld bc,$2814		; $7ebd
	inc a			; $7ec0
	call partCommon_decCounter1IfNonzero		; $7ec1
	ret nz			; $7ec4
	ld l,e			; $7ec5
	inc (hl)		; $7ec6
	ld l,$c2		; $7ec7
	ld a,(hl)		; $7ec9
	xor $03			; $7eca
	ld hl,$7ebd		; $7ecc
	rst_addAToHl			; $7ecf
	ld e,$c6		; $7ed0
	ld a,(hl)		; $7ed2
	ld (de),a		; $7ed3
	ld a,SND_LIGHTTORCH		; $7ed4
	call playSound		; $7ed6
	jp objectSetVisible83		; $7ed9
	call partCommon_decCounter1IfNonzero		; $7edc
	jr nz,_label_11_444	; $7edf
	ld (hl),$14		; $7ee1
	ld l,e			; $7ee3
	inc (hl)		; $7ee4
	jr _label_11_444		; $7ee5
	call partCommon_decCounter1IfNonzero		; $7ee7
	jr nz,_label_11_444	; $7eea
	callab bank10.agesFunc_10_6dbc
	ld h,d			; $7ef4
	ld l,$c4		; $7ef5
	inc (hl)		; $7ef7
	ld a,b			; $7ef8
	or a			; $7ef9
	jr nz,_label_11_444	; $7efa
	inc (hl)		; $7efc
	ld l,$c6		; $7efd
	ld (hl),$10		; $7eff
	jr _label_11_444		; $7f01
	ld h,d			; $7f03
	ld l,$f0		; $7f04
	ldi a,(hl)		; $7f06
	ld b,a			; $7f07
	ld c,(hl)		; $7f08
	ld l,$cb		; $7f09
	ldi a,(hl)		; $7f0b
	ldh (<hFF8F),a	; $7f0c
	inc l			; $7f0e
	ld a,(hl)		; $7f0f
	ldh (<hFF8E),a	; $7f10
	cp c			; $7f12
	jr nz,_label_11_442	; $7f13
	ldh a,(<hFF8F)	; $7f15
	cp b			; $7f17
	jr nz,_label_11_442	; $7f18
	ld l,e			; $7f1a
	dec (hl)		; $7f1b
	ld l,$c6		; $7f1c
	ld (hl),$10		; $7f1e
	inc l			; $7f20
	inc (hl)		; $7f21
	jr _label_11_444		; $7f22
_label_11_442:
	call objectGetRelativeAngleWithTempVars		; $7f24
	ld e,$c9		; $7f27
	ld (de),a		; $7f29
	call objectApplySpeed		; $7f2a
_label_11_444:
	jp partAnimate		; $7f2d
	call partCommon_decCounter1IfNonzero		; $7f30
	jr nz,_label_11_444	; $7f33
	call objectCreatePuff		; $7f35
	jp partDelete		; $7f38


; ==============================================================================
; PARTID_TRIFORCE_STONE
; Stone blocking path to Nayru at the start of the game (only after being moved)
; ==============================================================================
partCode5a:
	ld e,Part.state		; $7f3b
	ld a,(de)		; $7f3d
	or a			; $7f3e
	ret nz			; $7f3f

	inc a			; $7f40
	ld (de),a		; $7f41

	call getThisRoomFlags		; $7f42
	and $c0			; $7f45
	jp z,partDelete		; $7f47

	and $40			; $7f4a
	ld a,$28		; $7f4c
	jr nz,+			; $7f4e
	ld a,$48		; $7f50
+
	ld e,Part.xh		; $7f52
	ld (de),a		; $7f54
	call objectMakeTileSolid		; $7f55
	ld h,>wRoomLayout		; $7f58
	ld (hl),$00		; $7f5a
	ld a,PALH_98		; $7f5c
	call loadPaletteHeader		; $7f5e
	jp objectSetVisible83		; $7f61
