.include "code/enemyCode/group1.s"

; ==============================================================================
; ENEMYID_ROLLING_SPIKE_TRAP
; ==============================================================================
enemyCode0f:
	dec a			; $681c
	ret z			; $681d
	dec a			; $681e
	ret z			; $681f
	call _ecom_getSubidAndCpStateTo08		; $6820
	jr nc,+			; $6823
	rst_jumpTable		; $6825
	.dw @state00
	.dw @state01
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
+
	ld a,b			; $6836
	sub $08			; $6837
	rst_jumpTable		; $6839
	.dw @state08
	.dw @state09

@state00:
	ld e,Enemy.var3e	; $683e
	ld a,$08		; $6840
	ld (de),a		; $6842
	ld a,b			; $6843
	sub $08			; $6844
	jp nc,seasonsFunc_0c_68d6		; $6846
	ld e,Enemy.state	; $6849
	ld a,$01		; $684b
	ld (de),a		; $684d

@state01:
	ld a,b			; $684e
	ld hl,@seasonsTable_0c_686e		; $684f
	rst_addAToHl		; $6852
	ld b,(hl)		; $6853
	call checkBEnemySlotsAvailable		; $6854
	ret nz			; $6857
	call copyVar03ToVar30	; $6858
	ld b,$0f		; $685b
	call _ecom_spawnUncountedEnemyWithSubid01		; $685d
	ld (hl),$08		; $6860
	call seasonsFunc_0c_68c8		; $6862
	call seasonsFunc_0c_68fa		; $6865
	call seasonsFunc_0c_6992		; $6868
	jp enemyDelete		; $686b

@seasonsTable_0c_686e:
	.db $03 $03 $03 $04 $04 $04 $05 $05

@state_stub:
	ret			; $6876

@state08:
	ld a,(de)		; $6877
	sub $08			; $6878
	rst_jumpTable			; $687a
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call seasonsFunc_0c_699d		; $687f
	ld l,$84		; $6882
	inc (hl)		; $6884
	call seasonsFunc_0c_69b4		; $6885
	ld e,Enemy.var31	; $6888
	ld a,(de)		; $688a
	ld e,$99		; $688b
	ld (de),a		; $688d
	dec e			; $688e
	ld a,$80		; $688f
	ld (de),a		; $6891

@@substate1:
	call seasonsFunc_0c_69c9		; $6892
	call seasonsFunc_0c_69d2		; $6895
	ret z			; $6898
	jp seasonsFunc_0c_69fd		; $6899

@state09:
	ld a,(de)		; $689c
	sub $08			; $689d
	rst_jumpTable			; $689f
	.dw @@substate0
	.dw @@substate1

@@substate0:
	ld h,d			; $68a4
	ld l,e			; $68a5
	inc (hl)		; $68a6
	ld l,Enemy.angle	; $68a7
	ld (hl),$08		; $68a9
	ld l,$b0		; $68ab
	ld e,Enemy.counter1	; $68ad
	ld a,(hl)		; $68af
	ld (de),a		; $68b0
	jr ++		; $68b1

@@substate1:
	call _ecom_decCounter1	; $68b3
	jr nz,+			; $68b6
	ld e,Enemy.var30	; $68b8
	ld a,(de)		; $68ba
	ld (hl),a		; $68bb
	ld l,Enemy.angle	; $68bc
	ld a,(hl)		; $68be
	xor $10			; $68bf
	ld (hl),a		; $68c1
+
	call objectApplySpeed		; $68c2
++
	jp enemyAnimate		; $68c5

seasonsFunc_0c_68c8:
	ld e,Enemy.var30	; $68c8
	ld l,e			; $68ca
	ld a,(de)		; $68cb
	ld (hl),a		; $68cc
	ld e,Enemy.subid	; $68cd
	ld l,Enemy.var03	; $68cf
	ld a,(de)		; $68d1
	ld (hl),a		; $68d2
	jp objectCopyPosition		; $68d3

seasonsFunc_0c_68d6:
	jr z,+			; $68d6
	ld e,Enemy.var31		; $68d8
	ld a,(de)		; $68da
	ld c,a			; $68db
	ld hl,seasonsTable_0c_68ed		; $68dc
	rst_addAToHl			; $68df
	ld e,Enemy.collisionRadiusY		; $68e0
	ld a,(hl)		; $68e2
	ld (de),a		; $68e3
	ld a,c			; $68e4
	call enemySetAnimation		; $68e5
	ld a,$1e		; $68e8
+
	jp _ecom_setSpeedAndState8		; $68ea

seasonsTable_0c_68ed:
	.db $06 $06 $0e $16 $19

copyVar03ToVar30:
	ld h,d			; $68f2
	ld l,Enemy.var03	; $68f3
	ld e,Enemy.var30	; $68f5
	ld a,(hl)		; $68f7
	ld (de),a		; $68f8
	ret			; $68f9

seasonsFunc_0c_68fa:
	push hl			; $68fa
	ld c,h			; $68fb
	ld e,Enemy.subid	; $68fc
	ld a,(de)		; $68fe
	ld hl,seasonsTable_0c_694c		; $68ff
	rst_addDoubleIndex			; $6902
	ldi a,(hl)		; $6903
	ld h,(hl)		; $6904
	ld l,a			; $6905
	ld e,Enemy.var30		; $6906
-
	push hl			; $6908
	inc e			; $6909
	push de			; $690a
	call seasonsFunc_0c_6925		; $690b
	push bc			; $690e
	ld b,$0f		; $690f
	call _ecom_spawnEnemyWithSubid01		; $6911
	ld (hl),$09		; $6914
	pop bc			; $6916
	ld a,e			; $6917
	pop de			; $6918
	call seasonsFunc_0c_692f		; $6919
	pop hl			; $691c
	inc hl			; $691d
	inc hl			; $691e
	ld a,(hl)		; $691f
	inc a			; $6920
	jr nz,-			; $6921
	pop hl			; $6923
	ret			; $6924

seasonsFunc_0c_6925:
	ld e,Enemy.yh		; $6925
	ld a,(de)		; $6927
	add (hl)		; $6928
	ld b,a			; $6929
	ld e,c			; $692a
	inc hl			; $692b
	ld c,(hl)		; $692c
	inc hl			; $692d
	ret			; $692e

seasonsFunc_0c_692f:
	push de			; $692f
	ld l,$97		; $6930
	ldd (hl),a		; $6932
	ld (hl),$80		; $6933
	ld a,h			; $6935
	ld (de),a		; $6936
	ld l,Enemy.xh		; $6937
	ld e,l			; $6939
	ld a,(de)		; $693a
	ldd (hl),a		; $693b
	dec l			; $693c
	ld (hl),b		; $693d
	ld d,h			; $693e
	ld e,l			; $693f
	ld a,c			; $6940
	ld e,Enemy.var31	; $6941
	ld (de),a		; $6943
	call enemySetAnimation		; $6944
	call objectSetVisible82		; $6947
	pop de			; $694a
	ret			; $694b

seasonsTable_0c_694c:
	.dw @subid0
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7

@subid0: ; $695c
	.db $f8 $00
	.db $08 $01
	.db $ff
@subid1: ; $6961
	.db $f8 $02
	.db $10 $01
	.db $ff
@subid2: ; $6966
	.db $f8 $03
	.db $18 $01
	.db $ff
@subid3: ; $696b
	.db $e0 $00
	.db $00 $04
	.db $20 $01
	.db $ff ;
@subid4: ; $6972
	.db $e0 $02
	.db $08 $04
	.db $28 $01
	.db $ff
@subid5: ; $6979
	.db $e0 $03
	.db $10 $04
	.db $30 $01
	.db $ff
@subid6: ; $6980
	.db $c8 $00
	.db $e8 $04
	.db $18 $04
	.db $38 $01
	.db $ff
@subid7: ; $6989
	.db $c8 $02
	.db $f0 $04
	.db $20 $04
	.db $40 $01
	.db $ff

seasonsFunc_0c_6992:
	ld b,$04		; $6992
	ld l,Enemy.var31	; $6994
-
	ld e,l			; $6996
	ld a,(de)		; $6997
	ldi (hl),a		; $6998
	dec b			; $6999
	jr nz,-			; $699a
	ret			; $699c

seasonsFunc_0c_699d:
	ld h,d			; $699d
	ld e,Enemy.var30	; $699e
	ld l,Enemy.var31	; $69a0
-
	ldi a,(hl)		; $69a2
	ld b,a			; $69a3
	ld c,$81		; $69a4
	ld a,(bc)		; $69a6
	cp $0f			; $69a7
	jr nz,+	; $69a9
	ld c,e			; $69ab
	ld a,(de)		; $69ac
	ld (bc),a		; $69ad
+
	ld a,$b5		; $69ae
	cp l			; $69b0
	jr nz,-	; $69b1
	ret			; $69b3

seasonsFunc_0c_69b4:
	ld e,Enemy.var03	; $69b4
	ld a,(de)		; $69b6
	ld hl,seasonsTable_0c_69c1		; $69b7
	rst_addAToHl			; $69ba
	ld e,Enemy.yh		; $69bb
	ld a,(de)		; $69bd
	add (hl)		; $69be
	ld (de),a		; $69bf
	ret			; $69c0

seasonsTable_0c_69c1:
	.db $f8 $f0 $e8 $e0 $d8 $d0 $c8 $c0

seasonsFunc_0c_69c9:
	ld a,$0d		; $69c9
	call objectGetRelatedObject2Var		; $69cb
	ld e,l			; $69ce
	ld a,(hl)		; $69cf
	ld (de),a		; $69d0
	ret			; $69d1

seasonsFunc_0c_69d2:
	ld a,$09		; $69d2
	call objectGetRelatedObject2Var		; $69d4
	ld c,$f7		; $69d7
	bit 4,(hl)		; $69d9
	jr nz,+	; $69db
	ld c,$08		; $69dd
+
	ld e,Enemy.xh		; $69df
	ld a,(de)		; $69e1
	add c			; $69e2
	ld c,a			; $69e3
	ld e,Enemy.yh		; $69e4
	ld a,(de)		; $69e6
	ld b,a			; $69e7
	ld e,Enemy.var03	; $69e8
	ld a,(de)		; $69ea
	add $02			; $69eb
	ld e,a			; $69ed
-
	call getTileCollisionsAtPosition		; $69ee
	dec a			; $69f1
	cp $0f			; $69f2
	ret c			; $69f4
	ld a,b			; $69f5
	add $10			; $69f6
	ld b,a			; $69f8
	dec e			; $69f9
	jr nz,-			; $69fa
	ret			; $69fc

seasonsFunc_0c_69fd:
	ld h,d			; $69fd
	ld l,Enemy.var31	; $69fe
-
	ldi a,(hl)		; $6a00
	ld b,a			; $6a01
	ld c,$81		; $6a02
	ld a,(bc)		; $6a04
	cp $0f			; $6a05
	jr nz,+	; $6a07
	ld c,$86		; $6a09
	ld a,$01		; $6a0b
	ld (bc),a		; $6a0d
+
	ld a,$b5		; $6a0e
	cp l			; $6a10
	jr nz,-	; $6a11
	ret			; $6a13


; ==============================================================================
; ENEMYID_POKEY
; ==============================================================================
enemyCode11:
	jr z,++			; $6a14
	sub $03			; $6a16
	ret c			; $6a18
	jr nz,+			; $6a19
	ld e,Enemy.var03	; $6a1b
	ld a,(de)		; $6a1d
	cp $03			; $6a1e
	jp nz,_pokeyFunc_0c_6ba8		; $6a20
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
+
	ld e,Enemy.var2a	; $6a3a
	ld a,(de)		; $6a3c
	cp $9a			; $6a3d
	call z,_pokeyFunc_0c_6bfe		; $6a3f
	call _pokeyFunc_0c_6c3e		; $6a42
	ld e,Enemy.collisionType		; $6a45
	ld a,(de)		; $6a47
	rlca			; $6a48
	ret nc			; $6a49
++
	call _ecom_getSubidAndCpStateTo08		; $6a4a
	jr nc,+			; $6a4d
	rst_jumpTable			; $6a4f
	.dw _pokey_state_0
	.dw _pokey_state_stub
	.dw _pokey_state_stub
	.dw _pokey_state_stub
	.dw _pokey_state_stub
	.dw _pokey_state_stub
	.dw _pokey_state_stub
	.dw _pokey_state_stub
+
	ld e,Enemy.var03	; $6a60
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
	.dw _pokey_6b05
	.dw _pokey_6b2e
	.dw _pokey_6b35
	.dw _pokey_6b3c
	.dw _pokey_state_stub

_pokey_state_0:
	ld a,b			; $6a7c
	or a			; $6a7d
	jr nz,+			; $6a7e
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
-
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
	jr nz,-			; $6ab6
	ld h,a			; $6ab8
	ld l,$80		; $6ab9
	ld e,l			; $6abb
	ld a,(de)		; $6abc
	ld (hl),a		; $6abd
	jp enemyDelete		; $6abe
+
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
	jr z,+++		; $6ad6
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
	jr z,++			; $6aeb
	dec b			; $6aed
	ld a,$f3		; $6aee
	jr z,+			; $6af0
	add a			; $6af2
+
	ld e,$8f		; $6af3
	ld (de),a		; $6af5
++
	jp objectSetVisible82		; $6af6
+++
	ld l,$a4		; $6af9
	res 7,(hl)		; $6afb
	call getRandomNumber_noPreserveVars		; $6afd
	ld e,$86		; $6b00
	ld (de),a		; $6b02
	ret			; $6b03

_pokey_state_stub:
	ret			; $6b04

_pokey_6b05:
	ld e,$8f		; $6b05
	ld a,(de)		; $6b07
	or a			; $6b08
	jr z,+			; $6b09
	ld c,$0e		; $6b0b
	call objectUpdateSpeedZ_paramC		; $6b0d
	jp nz,objectSetVisiblec2		; $6b10
	ld l,$94		; $6b13
	xor a			; $6b15
	ldi (hl),a		; $6b16
	ld (hl),a		; $6b17
+
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

_pokey_6b2e:
	ld b,$f3		; $6b2e
	call $6b8e		; $6b30
	jr +			; $6b33

_pokey_6b35:
	ld b,$e6		; $6b35
	call $6b8e		; $6b37
	jr +			; $6b3a

_pokey_6b3c:
	ld b,$d9		; $6b3c
	call $6b8e		; $6b3e

+
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
	ld hl,_pokeyTable_0c_6b6a		; $6b55
	rst_addAToHl			; $6b58
	ld b,(hl)		; $6b59
	call _pokeyFunc_0c_6b82		; $6b5a
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

_pokeyTable_0c_6b6a:
	.db $ff $ff $00 $00 $01 $01 $00 $00
	.db $01 $02 $01 $00 $ff $fe $ff $00
	.db $ff $fe $ff $00 $01 $02 $01 $00

_pokeyFunc_0c_6b82:
	ld e,$af		; $6b82
	ld l,$82		; $6b84
-
	inc e			; $6b86
	ld a,(de)		; $6b87
	ld h,a			; $6b88
	ld a,(hl)		; $6b89
	dec a			; $6b8a
	jr nz,-			; $6b8b
	ret			; $6b8d
	ld h,d			; $6b8e
	ld l,$8f		; $6b8f
	ld a,(hl)		; $6b91
	cp b			; $6b92
	ret z			; $6b93
	or a			; $6b94
	jr z,+			; $6b95
	ld c,$0e		; $6b97
	call objectUpdateSpeedZ_paramC		; $6b99
	ld l,$8f		; $6b9c
	ld a,(hl)		; $6b9e
	cp b			; $6b9f
	ret c			; $6ba0
+
	ld (hl),b		; $6ba1
	ld l,$94		; $6ba2
	xor a			; $6ba4
	ldi (hl),a		; $6ba5
	ld (hl),a		; $6ba6
	ret			; $6ba7

_pokeyFunc_0c_6ba8:
	ld a,$33		; $6ba8
	call objectGetRelatedObject1Var		; $6baa
	ld a,(hl)		; $6bad
	or a			; $6bae
	jr nz,+			; $6baf
	ld e,$82		; $6bb1
	ld a,(de)		; $6bb3
	cp $05			; $6bb4
	jp nz,enemyDie_uncounted_withoutItemDrop		; $6bb6
	jp enemyDelete		; $6bb9
+
	ld e,$83		; $6bbc
	ld a,(de)		; $6bbe
	add $b1			; $6bbf
	ld l,a			; $6bc1
	ld h,d			; $6bc2
	ld c,$82		; $6bc3
	sub $b3			; $6bc5
	jr z,+			; $6bc7
	inc a			; $6bc9
	call nz,_pokeyFunc_0c_6bf5		; $6bca
	call _pokeyFunc_0c_6bf5		; $6bcd
+
	call _pokeyFunc_0c_6bf5		; $6bd0
	ld l,$a4		; $6bd3
	res 7,(hl)		; $6bd5
	ld l,$a9		; $6bd7
	ld (hl),$05		; $6bd9
	ld l,$82		; $6bdb
	ld (hl),$05		; $6bdd
	ld b,$02		; $6bdf
	call _ecom_spawnProjectile		; $6be1
	jr nz,+			; $6be4
	ld l,$c7		; $6be6
	ld (hl),$80		; $6be8
	ld a,$73		; $6bea
	call playSound		; $6bec
+
	call objectSetInvisible		; $6bef
	jp _pokeyFunc_0c_6c3e		; $6bf2

_pokeyFunc_0c_6bf5:
	ld b,(hl)		; $6bf5
	inc l			; $6bf6
	ld a,(bc)		; $6bf7
	cp $05			; $6bf8
	ret nc			; $6bfa
	dec a			; $6bfb
	ld (bc),a		; $6bfc
	ret			; $6bfd

_pokeyFunc_0c_6bfe:
	ld h,d			; $6bfe
	ld l,$b3		; $6bff
	ld c,$82		; $6c01
	ld b,(hl)		; $6c03
-
	ld a,(bc)		; $6c04
	ld e,a			; $6c05
	dec l			; $6c06
	ld a,$af		; $6c07
	cp l			; $6c09
	ret nc			; $6c0a
	ld b,(hl)		; $6c0b
	ld a,(bc)		; $6c0c
	cp $05			; $6c0d
	jr nz,-			; $6c0f
	ld h,e			; $6c11
	push hl			; $6c12
	call _pokeyFunc_0c_6b82	; $6c13
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
-
	inc l			; $6c2f
	ld a,$b3		; $6c30
	cp l			; $6c32
	ret c			; $6c33
	ld b,(hl)		; $6c34
	ld a,(bc)		; $6c35
	cp $05			; $6c36
	jr z,-			; $6c38
	inc a			; $6c3a
	ld (bc),a		; $6c3b
	jr -			; $6c3c

_pokeyFunc_0c_6c3e:
	ld bc,$0404		; $6c3e
	ld l,$82		; $6c41
	ld e,$b4		; $6c43
-
	dec e			; $6c45
	ld a,(de)		; $6c46
	ld h,a			; $6c47
	ld a,(hl)		; $6c48
	cp $05			; $6c49
	jr z,+			; $6c4b
	dec b			; $6c4d
+
	dec c			; $6c4e
	jr nz,-			; $6c4f
	ld a,b			; $6c51
	ld bc,_pokeyTable_0c_6c5d		; $6c52
	call addAToBc		; $6c55
	ld l,$90		; $6c58
	ld a,(bc)		; $6c5a
	ld (hl),a		; $6c5b
	ret			; $6c5c

_pokeyTable_0c_6c5d:
	.db $0a $0f $1e $3c


; ==============================================================================
; ENEMYID_IRON_MASK
; ==============================================================================
enemyCode1c:
	call _ecom_checkHazards		; $6c61
	jr z,@normalStatus	; $6c64
	sub ENEMYSTATUS_NO_HEALTH			; $6c66
	ret c			; $6c68
	jp z,enemyDie		; $6c69
	dec a			; $6c6c
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6c6d

	ld e,Enemy.subid	; $6c70
	ld a,(de)		; $6c72
	or a			; $6c73
	ret z			; $6c74
	ld e,Enemy.var2a	; $6c75
	ld a,(de)		; $6c77
	cp $80			; $6c78
	ret nz			; $6c7a
	jp enemyDelete		; $6c7b

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $6c7e
	jr nc,+	; $6c81

@commonState:
	rst_jumpTable			; $6c83
	.dw _ironMask_state_uninitialized
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub

+
	ld a,b			; $6c94
	rst_jumpTable			; $6c95
	.dw _ironMask_subid00
	.dw _ironMask_subid01

_ironMask_state_uninitialized:
	bit 0,b			; $6c9a
	jp nz,_ecom_setSpeedAndState8		; $6c9c
	ld a,$14		; $6c9f
	call _ecom_setSpeedAndState8AndVisible		; $6ca1
	ld l,Enemy.counter1	; $6ca4
	inc (hl)		; $6ca6
	ret			; $6ca7


_ironMask_state_stub:
	ret			; $6ca8


; Iron mask with mask on
_ironMask_subid00:
	ld a,(de)		; $6ca9
	sub $08			; $6caa
	rst_jumpTable			; $6cac
	.dw @state8
	.dw @state9
	.dw @stateA


; Standing in place
@state8:
	call _ironMask_magnetGloveCheck		; $6cb3
	call _ecom_decCounter1		; $6cb6
	jp nz,_ironMask_updateCollisionsFromLinkRelativeAngle		; $6cb9
	ld l,Enemy.state	; $6cbc
	inc (hl)		; $6cbe
	call _ironMask_chooseRandomAngleAndCounter1		; $6cbf

; Moving in some direction for [counter1] frames
@state9:
	call _ironMask_magnetGloveCheck		; $6cc2
	call _ecom_decCounter1		; $6cc5
	jr nz,+				; $6cc8
	ld l,Enemy.state		; $6cca
	dec (hl)		; $6ccc
	call _ironMask_chooseAmountOfTimeToStand		; $6ccd
+
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6cd0
	call _ironMask_updateCollisionsFromLinkRelativeAngle		; $6cd3
	jp enemyAnimate		; $6cd6

; This enemy has turned into the mask that was removed; will delete self after [counter1]
; frames.
@stateA:
	call _ecom_decCounter1		; $6cd9
	call z,_ironMask_chooseRandomAngleAndCounter1		; $6cdc
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6cdf
	jp enemyAnimate		; $6ce2


; Iron mask without mask on
_ironMask_subid01:
	ld a,(de)		; $6ce5
	sub $08			; $6ce6
	rst_jumpTable			; $6ce8
	.dw @state8
	.dw @state9
	.dw @stateA

@state8:
	ld h,d			; $6cef
	ld l,e			; $6cf0
	inc (hl)		; $6cf1
	ld l,Enemy.speed	; $6cf2
	ld (hl),$50		; $6cf4
	ld l,Enemy.enemyCollisionMode		; $6cf6
	ld (hl),$05		; $6cf8
	ld a,$05		; $6cfa
	call enemySetAnimation		; $6cfc
	call objectSetVisible82		; $6cff

@state9:
	ld a,(wMagnetGloveState)		; $6d02
	or a			; $6d05
	jr z,+			; $6d06
	call _ecom_updateAngleTowardTarget		; $6d08
	jp objectApplySpeed		; $6d0b
+
	ld h,d			; $6d0e
	ld l,e			; $6d0f
	inc (hl)		; $6d10
	ld l,Enemy.counter1	; $6d11
	ld (hl),$1e		; $6d13

@stateA:
	call _ecom_decCounter1		; $6d15
	jp nz,_ecom_flickerVisibility		; $6d18
	jp enemyDelete		; $6d1b


;;
; Modifies this object's enemyCollisionMode based on if Link is directly behind the iron
; mask or not.
; @addr{6d1e}
_ironMask_updateCollisionsFromLinkRelativeAngle:
	call objectGetAngleTowardEnemyTarget		; $6d1e
	ld h,d			; $6d21
	ld l,Enemy.angle		; $6d22
	sub (hl)		; $6d24
	and $1f			; $6d25
	sub $0c			; $6d27
	cp $09			; $6d29
	ld l,Enemy.enemyCollisionMode		; $6d2b
	jr c,++			; $6d2d
	ld (hl),ENEMYCOLLISION_IRON_MASK		; $6d2f
	ret			; $6d31
++
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK		; $6d32
	ret			; $6d34


;;
; @addr{6d35}
_ironMask_chooseRandomAngleAndCounter1:
	ld bc,$0703		; $6d35
	call _ecom_randomBitwiseAndBCE		; $6d38
	ld a,b			; $6d3b
	ld hl,@counter1Vals		; $6d3c
	rst_addAToHl			; $6d3f

	ld e,Enemy.counter1		; $6d40
	ld a,(hl)		; $6d42
	ld (de),a		; $6d43

	ld e,Enemy.state		; $6d44
	ld a,(de)		; $6d46
	cp $0a			; $6d47
	jp z,_ecom_setRandomCardinalAngle		; $6d49

	; Subid 0 only: 1 in 4 chance of turning directly toward Link, otherwise just
	; choose a random angle
	call @chooseAngle		; $6d4c
	swap a			; $6d4f
	rlca			; $6d51
	ld h,d			; $6d52
	ld l,Enemy.var31		; $6d53
	cp (hl)			; $6d55
	ret z			; $6d56
	ld (hl),a		; $6d57
	jp enemySetAnimation		; $6d58

@chooseAngle:
	ld a,c			; $6d5b
	or a			; $6d5c
	jp z,_ecom_updateCardinalAngleTowardTarget		; $6d5d
	jp _ecom_setRandomCardinalAngle		; $6d60

@counter1Vals:
	.db $19 $1e $23 $28 $2d $32 $37 $3c


;;
; @addr{6d6b}
_ironMask_chooseAmountOfTimeToStand:
	call getRandomNumber_noPreserveVars		; $6d6b
	and $03			; $6d6e
	ld hl,@counter1Vals		; $6d70
	rst_addAToHl			; $6d73
	ld e,Enemy.counter1		; $6d74
	ld a,(hl)		; $6d76
	ld (de),a		; $6d77
	ret			; $6d78

@counter1Vals:
	.db $0f $1e $2d $3c


_ironMask_magnetGloveCheck:
	ld a,(wMagnetGloveState)		; $6d7d
	or a			; $6d80
	jr z,+			; $6d81
	ld c,$40		; $6d83
	call objectCheckLinkWithinDistance		; $6d85
	jr nc,+			; $6d88
	rrca			; $6d8a
	xor $02			; $6d8b
	ld b,a			; $6d8d
	ld a,(w1Link.direction)	; $6d8e
	cp b			; $6d91
	jr z,++	; $6d92
+
	ld e,Enemy.var32		; $6d94
	ld a,$3c		; $6d96
	ld (de),a		; $6d98
	ret			; $6d99
++
	pop hl			; $6d9a
	ld h,d			; $6d9b
	ld l,Enemy.var32		; $6d9c
	dec (hl)		; $6d9e
	jr z,++			; $6d9f
	ld a,(hl)		; $6da1
	and $03			; $6da2
	sub $01			; $6da4
	jr nc,+			; $6da6
	cpl			; $6da8
	inc a			; $6da9
+
	dec a			; $6daa
	bit 0,b			; $6dab
	jr z,+			; $6dad
	ld l,Enemy.xh		; $6daf
	add (hl)		; $6db1
	ld (hl),a		; $6db2
	ret			; $6db3
+
	ld l,Enemy.yh		; $6db4
	add (hl)		; $6db6
	ld (hl),a		; $6db7
	ret			; $6db8
++
	ld l,Enemy.state	; $6db9
	ld (hl),$0a		; $6dbb
	ld l,Enemy.enemyCollisionMode		; $6dbd
	ld (hl),$50		; $6dbf
	ld a,$04		; $6dc1
	call enemySetAnimation		; $6dc3
	ld b,$1c		; $6dc6
	call _ecom_spawnUncountedEnemyWithSubid01		; $6dc8
	ret nz			; $6dcb
	jp objectCopyPosition		; $6dcc
	jr z,+			; $6dcf
	sub $03			; $6dd1
	ret c			; $6dd3
	jp z,enemyDie		; $6dd4
	dec a			; $6dd7
	jp nz,_ecom_updateKnockback		; $6dd8
	ret			; $6ddb
+
	ld e,Enemy.state		; $6ddc
	ld a,(de)		; $6dde
	rst_jumpTable			; $6ddf
	.dw @enemyDelete
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
	.dw @ret
@enemyDelete:
	jp enemyDelete		; $6df0
@ret:
	ret			; $6df3
	; left over
	jp enemyDelete		; $6df4
