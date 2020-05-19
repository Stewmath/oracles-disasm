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
	ld (wLoadedTreeGfxIndex),a		; $58a8
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
	call _generalOnox_subid2@func_5c3b		; $598b
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

@func_5c3b:
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
	ld (hl),PARTID_33		; $5f5f
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
	ld (hl),PARTID_4a		; $60ee
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
	jr z,@normalStatus	; $66d5
	sub $03			; $66d7
	ret c			; $66d9
	jr nz,@normalStatus	; $66da
	ld e,Enemy.subid		; $66dc
	ld a,(de)		; $66de
	dec a			; $66df
	jp z,_enemyBoss_dead		; $66e0
	ld e,$a4		; $66e3
	ld a,(de)		; $66e5
	or a			; $66e6
	jp z,enemyDie_uncounted_withoutItemDrop		; $66e7
	ld e,Enemy.subid		; $66ea
	ld a,(de)		; $66ec
	cp $02			; $66ed
	ld b,$02		; $66ef
	jr z,+			; $66f1
	ld b,$04		; $66f3
+
	ld a,$38		; $66f5
	call objectGetRelatedObject1Var		; $66f7
	ld a,(hl)		; $66fa
	or b			; $66fb
	ld (hl),a		; $66fc
	ld e,Enemy.state		; $66fd
	ld a,(de)		; $66ff
	cp $0b			; $6700
	jr nz,+			; $6702
	ld e,$83		; $6704
	ld a,(de)		; $6706
	cp $03			; $6707
	jr nc,+			; $6709
	ld e,$82		; $670b
	ld a,(de)		; $670d
	xor $01			; $670e
	add $ae			; $6710
	ld l,a			; $6712
	ld h,(hl)		; $6713
	ld l,$84		; $6714
	ld a,(hl)		; $6716
	cp $0b			; $6717
	jr nz,+			; $6719
	inc (hl)		; $671b
+
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

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $673e
	jr nc,+			; $6741
	rst_jumpTable			; $6743
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	dec b			; $6754
	ld a,b			; $6755
	rst_jumpTable			; $6756
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6
	.dw @subid7
	.dw @subid8
	.dw @subid9

@state0:
	ld a,b			; $6769
	or a			; $676a
	jp z,+			; $676b
	call _ecom_setSpeedAndState8AndVisible		; $676e
	jp _func_6c6b		; $6771
+
	inc a			; $6774
	ld (de),a		; $6775
	ld a,$06		; $6776
	ld b,$87		; $6778
	call _enemyBoss_initializeRoom		; $677a

@state1:
	ld b,$09		; $677d
	call checkBEnemySlotsAvailable		; $677f
	ret nz			; $6782
	ld b,ENEMYID_GLEEOK		; $6783
	call _ecom_spawnUncountedEnemyWithSubid01		; $6785
	ld l,$80		; $6788
	ld e,l			; $678a
	ld a,(de)		; $678b
	ld (hl),a		; $678c
	ld l,$b0		; $678d
	ld c,h			; $678f
	ld e,$08		; $6790
-
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
	jr nz,-			; $67a4
	jp enemyDelete		; $67a6

@stateStub:
	ret			; $67a9

@subid1:
	ld a,(de)		; $67aa
	sub $08			; $67ab
	rst_jumpTable			; $67ad
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	.dw @@stateF
	.dw @@stateG
	
@@state8:
	ld a,(wcc93)		; $67c0
	or a			; $67c3
	ret nz			; $67c4
	ld h,d			; $67c5
	ld l,e			; $67c6
	inc (hl)		; $67c7
	ld a,$2e		; $67c8
	ld (wActiveMusic),a		; $67ca
	jp playSound		; $67cd
	
@@state9:
	ld e,$b8		; $67d0
	ld a,(de)		; $67d2
	bit 1,a			; $67d3
	jr z,@@animate	; $67d5
	bit 2,a			; $67d7
	jr z,@@animate	; $67d9
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
	
@@stateA:
	call _ecom_decCounter2		; $680c
	jp nz,_ecom_flickerVisibility		; $680f
	ld bc,$020c		; $6812
	call _enemyBoss_spawnShadow		; $6815
	jp nz,_ecom_flickerVisibility		; $6818
	ld h,d			; $681b
	ld l,$84		; $681c
	inc (hl)		; $681e
	ld l,$86		; $681f
	ld (hl),$1e		; $6821
	ld a,$04		; $6823
	call enemySetAnimation		; $6825
	
@@stateB:
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
	
@@stateC:
	call _ecom_decCounter1		; $683f
	jr nz,+			; $6842
	ld l,e			; $6844
	inc (hl)		; $6845
	ld bc,$fdc0		; $6846
	call objectSetSpeedZ		; $6849
	jp objectSetVisible81		; $684c
+
	ld a,(hl)		; $684f
	cp $0a			; $6850
	ret c			; $6852

@@animate:
	jp enemyAnimate		; $6853
	
@@stateD:
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
	
@@stateE:
	call _ecom_decCounter1		; $6870
	jr z,+			; $6873
	ld a,(hl)		; $6875
	cp $87			; $6876
	jr c,@@animate	; $6878
	ld a,($d00f)		; $687a
	rlca			; $687d
	ret c			; $687e
	ld hl,$cc6a		; $687f
	ld a,$14		; $6882
	ldi (hl),a		; $6884
	ld (hl),$00		; $6885
	ret			; $6887
+
	ld l,e			; $6888
	inc (hl)		; $6889
	ld l,$90		; $688a
	ld (hl),$50		; $688c
	call _ecom_updateAngleTowardTarget		; $688e
	jr @@animate		; $6891
	
@@stateF:
	ld a,$01		; $6893
	call _ecom_getSideviewAdjacentWallsBitset		; $6895
	jr nz,+			; $6898
	call objectApplySpeed		; $689a
	jr @@animate		; $689d
+
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
	jr @@animate		; $68b8
	
@@stateG:
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $68ba
	ld c,$20		; $68bd
	call objectUpdateSpeedZ_paramC		; $68bf
	jr nz,@@animate	; $68c2
	ld l,$84		; $68c4
	ld (hl),$0c		; $68c6
	ld l,$86		; $68c8
	ld (hl),$3c		; $68ca
	jr @@animate		; $68cc

@subid2:
	ld a,(de)		; $68ce
	sub $08			; $68cf
	rst_jumpTable			; $68d1
	.dw @@state8
	.dw @@incStateWhenCounter1Is0
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	.dw @@stateF
	.dw @@incStateWhenCounter1Is0
	.dw @@stateH
	
@@state8:
	ld h,d			; $68e6
	ld l,Enemy.angle		; $68e7
	ld (hl),$14		; $68e9
@@incStateEnableCollisionsSetCounterAndSpeed:
	ld l,e			; $68eb
	inc (hl)		; $68ec
	ld l,Enemy.collisionType		; $68ed
	set 7,(hl)		; $68ef
	ld l,Enemy.counter1		; $68f1
	ld (hl),$3c		; $68f3
	ld l,Enemy.speed		; $68f5
	ld (hl),SPEED_80		; $68f7
	ret			; $68f9
	
@@incStateWhenCounter1Is0:
	call _ecom_decCounter1		; $68fa
	jp nz,objectApplySpeed		; $68fd
	ld l,e			; $6900
	inc (hl)		; $6901
	ret			; $6902
	
@@stateA:
	ld b,$04		; $6903
@@func_6905:
	ld a,$38		; $6905
	call objectGetRelatedObject1Var		; $6907
	ld a,(hl)		; $690a
	and b			; $690b
	ld c,$03		; $690c
	ld l,$b8		; $690e
	jr nz,+			; $6910
	bit 0,(hl)		; $6912
	jr nz,++		; $6914
	ld e,$82		; $6916
	ld a,(de)		; $6918
	cp $03			; $6919
	jr z,+			; $691b
	ld b,h			; $691d
	ld l,$b1		; $691e
	ld h,(hl)		; $6920
	ld l,$84		; $6921
	ld a,(hl)		; $6923
	cp $10			; $6924
	ld h,b			; $6926
	jr nc,+			; $6927
	ldh a,(<hEnemyTargetX)	; $6929
	cp $78			; $692b
	jr nc,++		; $692d
+
	ld l,$b8		; $692f
	set 0,(hl)		; $6931
	ld c,$00		; $6933
++
	ldh a,(<hEnemyTargetY)	; $6935
	cp $58			; $6937
	ld b,$00		; $6939
	jr c,+			; $693b
	ld b,$02		; $693d
	sub $70			; $693f
	cp $40			; $6941
	jr c,+			; $6943
	call getRandomNumber		; $6945
	and $01			; $6948
	inc a			; $694a
	ld b,a			; $694b
+
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
	
@@stateB:
	ld e,Enemy.var03		; $6959
	ld a,(de)		; $695b
	ld e,Enemy.state2		; $695c
	rst_jumpTable			; $695e
	.dw @@@var03_00
	.dw @@@var03_01
	.dw @@@var03_02
	.dw @@@var03_03
	.dw @@@var03_04
	.dw @@@var03_05

@@@var03_00:
	ld a,(de)		; $696b
	rst_jumpTable			; $696c
	.dw @@@@substate0
	.dw @@@@substate1
	.dw @@@@substate2
	
@@@@substate0:
	ld bc,$3a60		; $6973
	ld h,d			; $6976
	ld l,$82		; $6977
	ld a,(hl)		; $6979
	cp $02			; $697a
	jr z,+			; $697c
	ld c,$90		; $697e
+
	ld l,$8b		; $6980
	ldi a,(hl)		; $6982
	ldh (<hFF8F),a		; $6983
	inc l			; $6985
	ld a,(hl)		; $6986
	ldh (<hFF8E),a		; $6987
	cp c			; $6989
	jr nz,+			; $698a
	ldh a,(<hFF8F)		; $698c
	cp b			; $698e
	jr z,++			; $698f
+
	jp _ecom_moveTowardPosition		; $6991
++
	ld l,e			; $6994
	inc (hl)		; $6995
	ret			; $6996
	
@@@@substate1:
	ld h,d			; $6997
	ld l,e			; $6998
	inc (hl)		; $6999
	inc l			; $699a
	ld (hl),$1e		; $699b
	ld a,$01		; $699d
	jp enemySetAnimation		; $699f
	
@@@@substate2:
	call _ecom_decCounter1		; $69a2
	jr z,+			; $69a5
	ld a,(hl)		; $69a7
	cp $08			; $69a8
	ret nz			; $69aa
	ld l,$8b		; $69ab
	ld a,(hl)		; $69ad
	sub $04			; $69ae
	ld (hl),a		; $69b0
	ld b,PARTID_43		; $69b1
	jp _ecom_spawnProjectile		; $69b3
+
	ld l,$8b		; $69b6
	ld a,(hl)		; $69b8
	add $04			; $69b9
	ld (hl),a		; $69bb
@@@func_69bc:
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
	jr nz,+			; $69d3
	inc (hl)		; $69d5
+
	ld h,d			; $69d6
	ld e,l			; $69d7
	inc (hl)		; $69d8
	ld l,$82		; $69d9
	ld a,(hl)		; $69db
	cp $02			; $69dc
	ret nz			; $69de
	jp @@stateC		; $69df

@@@var03_01:
	ld a,(de)		; $69e2
	rst_jumpTable			; $69e3
	.dw @@@@substate0
	.dw @@@@substate1
	.dw @@@@substate2
	
@@@@substate0:
	ld h,d			; $69ea
	ld l,e			; $69eb
	inc (hl)		; $69ec
	ld l,$86		; $69ed
	ld (hl),$28		; $69ef
	ld a,$01		; $69f1
	jp enemySetAnimation		; $69f3
	
@@@@substate1:
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
	
@@@@substate2:
	call _ecom_decCounter1		; $6a07
	jr z,@@@func_69bc	; $6a0a
	ld a,(hl)		; $6a0c
	and $0f			; $6a0d
	jr z,+			; $6a0f
	cp $08			; $6a11
	ret nz			; $6a13
	ld l,$8b		; $6a14
	ld a,(hl)		; $6a16
	add $02			; $6a17
	ld (hl),a		; $6a19
	ret			; $6a1a
+
	ld l,$8b		; $6a1b
	ld a,(hl)		; $6a1d
	sub $02			; $6a1e
	ld (hl),a		; $6a20
	call getFreePartSlot		; $6a21
	ret nz			; $6a24
	ld (hl),PARTID_43		; $6a25
	inc l			; $6a27
	inc (hl)		; $6a28
	ld e,$86		; $6a29
	ld a,(de)		; $6a2b
	and $30			; $6a2c
	swap a			; $6a2e
	ld bc,@@@@table_6a54		; $6a30
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
	ld (hl),INTERACID_PUFF		; $6a4c
	ld bc,$0800		; $6a4e
	jp objectCopyPositionWithOffset		; $6a51

@@@@table_6a54:
	.db $ec $00
	.db $00 $ec
	.db $00 $14
	.db $14 $00

@@@var03_02:
	ld a,(de)		; $6a5c
	rst_jumpTable			; $6a5d
	.dw @@@@substate0
	.dw @@@@substate1
	.dw @@@@substate2

@@@@substate0:
	ld h,d			; $6a64
	ld l,e			; $6a65
	inc (hl)		; $6a66
	inc l			; $6a67
	ld (hl),$08		; $6a68
	inc l			; $6a6a
	ld (hl),$02		; $6a6b
	ld a,$01		; $6a6d
	jp enemySetAnimation		; $6a6f

@@@@substate1:
	call _ecom_decCounter1		; $6a72
	ret nz			; $6a75
	ld l,e			; $6a76
	inc (hl)		; $6a77
	ret			; $6a78

@@@@substate2:
	ld b,PARTID_43		; $6a79
	call _ecom_spawnProjectile		; $6a7b
	ret nz			; $6a7e
	ld l,$c2		; $6a7f
	ld (hl),$02		; $6a81
	call _ecom_decCounter2		; $6a83
	jp z,@@@func_69bc		; $6a86
	dec l			; $6a89
	ld (hl),$14		; $6a8a
	dec l			; $6a8c
	dec (hl)		; $6a8d
	ret			; $6a8e

@@@var03_03:
	ld a,(de)		; $6a8f
	rst_jumpTable			; $6a90
	.dw @@@var03_00@substate0
	.dw @@@@ret
@@@@ret:
	ret			; $6a95

@@@var03_04:
@@@var03_05:
	call @@@func_6a9f		; $6a96
	call z,_func_6cf6		; $6a99
	jp objectApplySpeed		; $6a9c
@@@func_6a9f:
	ld h,d			; $6a9f
	ld l,$b1		; $6aa0
	ld a,(hl)		; $6aa2
	or a			; $6aa3
	ret z			; $6aa4
	dec (hl)		; $6aa5
	ret			; $6aa6
	
@@stateC:
	ld h,d			; $6aa7
	ld l,e			; $6aa8
	inc (hl)		; $6aa9
	ld l,$87		; $6aaa
	ld (hl),$78		; $6aac
	ld l,$83		; $6aae
	ld a,(hl)		; $6ab0
	or a			; $6ab1
	jr z,+			; $6ab2
	cp $03			; $6ab4
	jr nz,++		; $6ab6
+
	ld l,$b0		; $6ab8
	xor a			; $6aba
	ldi (hl),a		; $6abb
	ld (hl),a		; $6abc
++
	xor a			; $6abd
	jp enemySetAnimation		; $6abe
	
@@stateD:
	call _ecom_decCounter2		; $6ac1
	jr nz,@@stateB@var03_04	; $6ac4
	ld l,e			; $6ac6
	ld (hl),$0a		; $6ac7
	ret			; $6ac9
	
@@stateE:
	ld a,(wFrameCounter)		; $6aca
	rrca			; $6acd
	jr c,+			; $6ace
	call _ecom_decCounter1		; $6ad0
	jr nz,+			; $6ad3
	ld l,e			; $6ad5
	inc (hl)		; $6ad6
	ld l,$90		; $6ad7
	ld (hl),$28		; $6ad9
+
	call objectApplySpeed		; $6adb
	jp _ecom_bounceOffScreenBoundary		; $6ade
	
@@stateF:
	ld h,d			; $6ae1
	ld l,$82		; $6ae2
	ld a,(hl)		; $6ae4
	cp $02			; $6ae5
	ld bc,$2476		; $6ae7
	jr z,+	; $6aea
	ld c,$7a		; $6aec
+
	ld l,$8b		; $6aee
	ldi a,(hl)		; $6af0
	ldh (<hFF8F),a	; $6af1
	inc l			; $6af3
	ld a,(hl)		; $6af4
	ldh (<hFF8E),a	; $6af5
	cp c			; $6af7
	jr nz,+	; $6af8
	ldh a,(<hFF8F)	; $6afa
	cp b			; $6afc
	jr z,++	; $6afd
+
	jp _ecom_moveTowardPosition		; $6aff
++
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
	jr z,+	; $6b1e
	ld a,$0c		; $6b20
	ld b,$04		; $6b22
+
	ld l,$89		; $6b24
	ld (hl),a		; $6b26
	ld a,$38		; $6b27
	call objectGetRelatedObject1Var		; $6b29
	ld a,(hl)		; $6b2c
	xor b			; $6b2d
	ld (hl),a		; $6b2e
	ret			; $6b2f
	
@@stateH:
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
	jr nc,+	; $6b42
	cp $0a			; $6b44
	jp nz,@@stateB@var03_04		; $6b46
+
	ld h,d			; $6b49
	ld (hl),$0a		; $6b4a
	ld l,$82		; $6b4c
	ld a,(hl)		; $6b4e
	cp $02			; $6b4f
	ret nz			; $6b51
	jp @@stateA		; $6b52

@subid3:
	ld a,(de)		; $6b55
	sub $08			; $6b56
	rst_jumpTable			; $6b58
	.dw @@state8
	.dw @subid2@incStateWhenCounter1Is0
	.dw @@stateA
	.dw @subid2@stateB
	.dw @subid2@stateC
	.dw @subid2@stateD
	.dw @subid2@stateE
	.dw @subid2@stateF
	.dw @subid2@incStateWhenCounter1Is0
	.dw @subid2@stateH

@@state8:
	ld h,d			; $6b6d
	ld l,$89		; $6b6e
	ld (hl),$0c		; $6b70
	jp @subid2@incStateEnableCollisionsSetCounterAndSpeed		; $6b72

@@stateA:
	ld b,$02		; $6b75
	jp @subid2@func_6905		; $6b77

@subid4:
@subid5:
	ld a,(de)		; $6b7a
	sub $08			; $6b7b
	rst_jumpTable			; $6b7d
	.dw @@state8
	.dw @@state9
	.dw @@stateA

@@state8:
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

@@state9:
	call _func_6cb2		; $6b9d
	call _func_6cbf		; $6ba0
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
	jr z,+			; $6bb3
	ld b,$7a		; $6bb5
+
	ld a,c			; $6bb7
	add a			; $6bb8
	add c			; $6bb9
	add b			; $6bba
	ld e,$8d		; $6bbb
	ld (de),a		; $6bbd
	ret			; $6bbe

@@stateA:
	call _func_6cb2		; $6bbf
	ld e,$82		; $6bc2
	ld a,(de)		; $6bc4
	rrca			; $6bc5
	ld bc,$0276		; $6bc6
	jr nc,+			; $6bc9
	ld bc,$047a		; $6bcb
+
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

@subid6:
@subid7:
	ld a,(de)		; $6be8
	sub $08			; $6be9
	rst_jumpTable			; $6beb
	.dw @@state8
	.dw @@state9
	.dw @subid5@stateA

@@state8:
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

@@state9:
	call _func_6cb2		; $6c0b
	call _func_6cbf		; $6c0e
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
	jr z,+			; $6c20
	ld b,$7a		; $6c22
+
	ld a,c			; $6c24
	add a			; $6c25
	add b			; $6c26
	ld e,$8d		; $6c27
	ld (de),a		; $6c29
	ret			; $6c2a

@subid8:
@subid9:
	ld a,(de)		; $6c2b
	sub $08			; $6c2c
	rst_jumpTable			; $6c2e
	.dw @@state8
	.dw @@state9
	.dw @subid5@stateA
	
@@state8:
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
	
@@state9:
	call _func_6cb2		; $6c4e
	call _func_6cbf		; $6c51
	ret nz			; $6c54
	ld e,$8b		; $6c55
	ld a,b			; $6c57
	add $24			; $6c58
	ld (de),a		; $6c5a
	ld e,$82		; $6c5b
	ld a,(de)		; $6c5d
	cp $08			; $6c5e
	ld a,$76		; $6c60
	jr z,+			; $6c62
	ld a,$7a		; $6c64
+
	add c			; $6c66
	ld e,$8d		; $6c67
	ld (de),a		; $6c69
	ret			; $6c6a

_func_6c6b:
	dec b			; $6c6b
	jr z,_func_6c8a	; $6c6c
	ld c,$76		; $6c6e
	ld l,$82		; $6c70
	bit 0,(hl)		; $6c72
	jr z,+			; $6c74
	ld c,$7a		; $6c76
+
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
	
_func_6c8a:
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

_func_6cb2:
	ld a,$01		; $6cb2
	call objectGetRelatedObject2Var		; $6cb4
	ld a,(hl)		; $6cb7
	cp $06			; $6cb8
	ret z			; $6cba
	pop hl			; $6cbb
	jp enemyDelete		; $6cbc

_func_6cbf:
	ld l,$84		; $6cbf
	ld a,(hl)		; $6cc1
	cp $0e			; $6cc2
	jr nz,_func_6cd8	; $6cc4
	ld h,d			; $6cc6
	inc (hl)		; $6cc7
	ld l,$a4		; $6cc8
	res 7,(hl)		; $6cca
	ld e,$9a		; $6ccc
	ld a,(de)		; $6cce
	rlca			; $6ccf
	ld b,INTERACID_KILLENEMYPUFF		; $6cd0
	call c,objectCreateInteractionWithSubid00		; $6cd2
	jp objectSetInvisible		; $6cd5
	
_func_6cd8:
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
	jr nc,+			; $6ce9
	ld c,$7a		; $6ceb
+
	ld a,(hl)		; $6ced
	sub c			; $6cee
	sra a			; $6cef
	sra a			; $6cf1
	ld c,a			; $6cf3
	xor a			; $6cf4
	ret			; $6cf5
	
_func_6cf6:
	ld e,$b0		; $6cf6
	ld a,(de)		; $6cf8
	and $1f			; $6cf9
	jr nz,+			; $6cfb
	call getRandomNumber		; $6cfd
	and $20			; $6d00
	ld (de),a		; $6d02
+
	ld a,(de)		; $6d03
	ld hl,_table_6d14		; $6d04
	rst_addAToHl			; $6d07
	ld e,Enemy.angle		; $6d08
	ld a,(hl)		; $6d0a
	ld (de),a		; $6d0b
	ld h,d			; $6d0c
	ld l,Enemy.var30		; $6d0d
	inc (hl)		; $6d0f
	inc l			; $6d10
	ld (hl),$06		; $6d11
	ret			; $6d13

_table_6d14:
	.db $15 $16 $17 $17 $19 $19 $1a $1b
	.db $05 $06 $07 $07 $09 $09 $0a $0b
	.db $0b $0a $09 $09 $07 $07 $06 $05
	.db $1b $1a $19 $19 $17 $17 $16 $15
	.db $08 $08 $09 $09 $0a $0a $0b $0c
	.db $14 $15 $16 $16 $17 $17 $18 $18
	.db $18 $18 $19 $19 $1a $1a $1b $1c
	.db $04 $05 $06 $06 $07 $07 $08 $08

; ==============================================================================
; ENEMYID_KING_MOBLIN
; ==============================================================================
enemyCode07:
	jr z,@normalStatus		; $6d54
	sub ENEMYSTATUS_NO_HEALTH			; $6d56
	ret c			; $6d58
	jr z,@dead	; $6d59
	dec a			; $6d5b
	; just hit
	ret nz			; $6d5c
	; knockback
	ld e,$aa		; $6d5d
	ld a,(de)		; $6d5f
	cp $97			; $6d60
	jr nz,@normalStatus	; $6d62
	ld e,$a9		; $6d64
	ld a,(de)		; $6d66
	or a			; $6d67
	call nz,_func_6f20		; $6d68
	ld a,$63		; $6d6b
	jp playSound		; $6d6d
@dead:
	ld h,d			; $6d70
	ld l,$84		; $6d71
	ld (hl),$0e		; $6d73
	inc l			; $6d75
	ld (hl),$00		; $6d76
	ld l,$a4		; $6d78
	res 7,(hl)		; $6d7a
@normalStatus:
	ld e,Enemy.state		; $6d7c
	ld a,(de)		; $6d7e
	rst_jumpTable			; $6d7f
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE

@state0:
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

@stateStub:
	ret			; $6db8

@state8:
	ld hl,$cfc0		; $6db9
	bit 0,(hl)		; $6dbc
	jp z,enemyAnimate		; $6dbe
	ld (hl),$00		; $6dc1
	ld h,d			; $6dc3
	ld l,e			; $6dc4
	inc (hl)		; $6dc5
	ld l,$90		; $6dc6
	ld (hl),$14		; $6dc8

@state9:
	call getRandomNumber_noPreserveVars		; $6dca
	and $07			; $6dcd
	cp $07			; $6dcf
	jr z,@state9	; $6dd1
	ld h,d			; $6dd3
	ld l,$b0		; $6dd4
	cp (hl)			; $6dd6
	jr z,@state9	; $6dd7
	ld (hl),a		; $6dd9
	ld hl,@table_6e03		; $6dda
	rst_addAToHl			; $6ddd
	ld e,$8d		; $6dde
	ld a,(de)		; $6de0
	cp (hl)			; $6de1
	jr z,@state9	; $6de2
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
	jr nc,+			; $6df6
	ld a,$01		; $6df8
	ld b,$08		; $6dfa
+
	ld l,$88		; $6dfc
	ldi (hl),a		; $6dfe
	ld (hl),b		; $6dff
	jp enemySetAnimation		; $6e00

@table_6e03:
	.db $50
	.db $20
	.db $30
	.db $40
	.db $60
	.db $70
	.db $80

@stateA:
	call objectApplySpeed		; $6e0a
	ld h,d			; $6e0d
	ld l,$8d		; $6e0e
	ld a,(hl)		; $6e10
	ld l,$b1		; $6e11
	sub (hl)		; $6e13
	inc a			; $6e14
	cp $03			; $6e15
	jr nc,@animate	; $6e17
	ld l,$84		; $6e19
	inc (hl)		; $6e1b
	call _func_6f2e		; $6e1c
	ld e,$88		; $6e1f
	xor a			; $6e21
	ld (de),a		; $6e22
	jp enemySetAnimation		; $6e23

@stateB:
	call _ecom_decCounter1		; $6e26
	jr nz,@animate	; $6e29
	inc (hl)		; $6e2b
	ld b,PARTID_KING_MOBLIN_BOMB		; $6e2c
	call _ecom_spawnProjectile		; $6e2e
	ret nz			; $6e31
	ld e,$84		; $6e32
	ld a,$0c		; $6e34
	ld (de),a		; $6e36
	ld e,$88		; $6e37
	ld a,$04		; $6e39
	ld (de),a		; $6e3b
	jp enemySetAnimation		; $6e3c

@stateC:
	call _func_6f40		; $6e3f
	ret nc			; $6e42
	inc a			; $6e43
	ret nz			; $6e44
	ld e,$84		; $6e45
	ld a,$0d		; $6e47
	ld (de),a		; $6e49
	call _func_6f2e		; $6e4a
	ld e,$88		; $6e4d
	ld a,$02		; $6e4f
	ld (de),a		; $6e51
	jp enemySetAnimation		; $6e52

@stateD:
	call _ecom_decCounter1		; $6e55
	jr nz,@animate	; $6e58
	ld l,e			; $6e5a
	ld (hl),$09		; $6e5b
@animate:
	jp enemyAnimate		; $6e5d

@stateE:
	inc e			; $6e60
	ld a,(de)		; $6e61
	rst_jumpTable			; $6e62
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substateStub
	
@substate0:
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
	jr nz,+			; $6e85
	ld l,$c4		; $6e87
	ld a,(hl)		; $6e89
	dec a			; $6e8a
	jr nz,+			; $6e8b
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
+
	ld a,$05		; $6ea2
	jp enemySetAnimation		; $6ea4
	
@substate1:
	call _ecom_decCounter2		; $6ea7
	ret nz			; $6eaa
	ld l,$b3		; $6eab
	bit 0,(hl)		; $6ead
	jr z,+			; $6eaf
	ld l,e			; $6eb1
	inc (hl)		; $6eb2
	ret			; $6eb3
+
	ld l,$a4		; $6eb4
	set 7,(hl)		; $6eb6
	ld l,$84		; $6eb8
	ld (hl),$09		; $6eba
	ld l,$b4		; $6ebc
	bit 0,(hl)		; $6ebe
	ret nz			; $6ec0
	inc (hl)		; $6ec1
	; You can't beat me this way
	ld bc,TX_3f06		; $6ec2
	jp showText		; $6ec5
	
@substate2:
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
	
@substate3:
	call _ecom_decCounter1		; $6edc
	ret nz			; $6edf
	inc (hl)		; $6ee0
	inc l			; $6ee1
	ld a,(hl)		; $6ee2
	dec a			; $6ee3
	ld hl,@table_6f13		; $6ee4
	rst_addDoubleIndex			; $6ee7
	ldi a,(hl)		; $6ee8
	ld c,(hl)		; $6ee9
	ld b,a			; $6eea
	call getFreeInteractionSlot		; $6eeb
	ret nz			; $6eee
	ld (hl),INTERACID_EXPLOSION		; $6eef
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

@table_6f13:
	.db $08 $78
	.db $0c $38
	.db $0a $60
	.db $08 $48
	.db $04 $24
	.db $06 $5a

@substateStub:
	ret			; $6f1f

_func_6f20:
	dec a			; $6f20
	ld hl,_table_6f20		; $6f21
	rst_addAToHl			; $6f24
	ld e,$90		; $6f25
	ld a,(hl)		; $6f27
	ld (de),a		; $6f28
	ret			; $6f29

_table_6f20:
	.db SPEED_200
	.db SPEED_180
	.db SPEED_100
	.db SPEED_0c0
	
_func_6f2e:
	ld e,$a9		; $6f2e
	ld a,(de)		; $6f30
	dec a			; $6f31
	ld hl,_table_6f3b		; $6f32
	rst_addAToHl			; $6f35
	ld e,$86		; $6f36
	ld a,(hl)		; $6f38
	ld (de),a		; $6f39
	ret			; $6f3a

_table_6f3b:
	.db $14
	.db $1e
	.db $28
	.db $32
	.db $3c
	
_func_6f40:
	call enemyAnimate		; $6f40
	ld e,$a1		; $6f43
	ld a,(de)		; $6f45
	rlca			; $6f46
	ret c			; $6f47
	cp $06			; $6f48
	jr nz,+			; $6f4a
	ld a,$80		; $6f4c
	ld (de),a		; $6f4e
	ld a,$04		; $6f4f
	call objectGetRelatedObject2Var		; $6f51
	ld (hl),$03		; $6f54
	ld l,$e4		; $6f56
	set 7,(hl)		; $6f58
	ret			; $6f5a
+
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
