.include "code/enemyCode/group2.s"

; unknown use
seasonsTable_0d_6b30:
	.dw @index0
	.dw @index1
	.dw @index2
	.dw @index3
	.dw @index4
	.dw @index5
	.dw @index6
	.dw @index7
	.dw @index8
	.dw @index9
	.dw @indexA

@index0:
	.db $14 $00 $02 $38
	.db $05 $14 $04 $18
	.db $05 $14 $00 $48
	.db $6b

@index1:
	.db $3c $00 $02 $48
	.db $05 $14 $04 $18
	.db $05 $14 $00 $55
	.db $6b

@index2:
	.db $28 $00 $02 $48
	.db $05 $14 $04 $18
	.db $05 $14 $00 $62
	.db $6b

@index3:
	.db $14 $00 $02 $48
	.db $05 $14 $04 $18
	.db $05 $14 $00 $6f
	.db $6b

@index4:
	.db $14 $00 $02 $d8
	.db $05 $14 $04 $b8
	.db $05 $14 $00 $7c
	.db $6b

@index5:
	.db $78 $00 $02 $78
	.db $04 $38 $00 $89
	.db $6b

@index6:
	.db $73 $00 $02 $78
	.db $04 $38 $00 $92
	.db $6b

@index7:
	.db $6e $00 $02 $78
	.db $04 $38 $00 $9b
	.db $6b

@index8:
	.db $69 $00 $02 $78
	.db $04 $38 $00 $a4
	.db $6b

@index9:
	.db $64 $00 $02 $78
	.db $04 $38 $00 $ad
	.db $6b

@indexA:
	.db $5f $00 $02 $78
	.db $04 $38 $00 $b6
	.db $6b


; ==============================================================================
; ENEMYID_MAGUNESU
; ==============================================================================
enemyCode3c:
	jr z,+			; $6bbd
	sub $03			; $6bbf
	ret c			; $6bc1
	jp z,enemyDie		; $6bc2
	dec a			; $6bc5
	jp nz,_ecom_updateKnockback		; $6bc6
	ret			; $6bc9
+
	call magunesuFunc_0d_6ccd		; $6bca
	call magunesuFunc_0d_6ce6		; $6bcd
	ld e,Enemy.state		; $6bd0
	ld a,(de)		; $6bd2
	rst_jumpTable			; $6bd3
	.dw @state0
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD
	.dw @stateE

@state0:
	call magunesuFunc_0d_6d06		; $6bf2
	ld a,$14		; $6bf5
	call _ecom_setSpeedAndState8AndVisible		; $6bf7
	jr @magunesuFunc_0d_6c54		; $6bfa

@state_stub:
	ret			; $6bfc

@state8:
	call magunesuFunc_0d_6d18		; $6bfd
	call _ecom_decCounter1		; $6c00
	jp nz,_ecom_applyVelocityForTopDownEnemy		; $6c03
	ld l,Enemy.state		; $6c06
	inc (hl)		; $6c08
	ld a,$01		; $6c09
	jp enemySetAnimation		; $6c0b

@state9:
	call enemyAnimate		; $6c0e
	ld e,$a1		; $6c11
	ld a,(de)		; $6c13
	or a			; $6c14
	ret z			; $6c15
	dec a			; $6c16
	ld a,$05		; $6c17
	jp nz,magunesuFunc_0d_6ca9		; $6c19
	ld h,d			; $6c1c
	ld l,$83		; $6c1d
	ld (hl),$02		; $6c1f
	ld l,$9b		; $6c21
	ld a,$02		; $6c23
	ldi (hl),a		; $6c25
	ld (hl),a		; $6c26
	ret			; $6c27

@stateA:
	call magunesuFunc_0d_6cb7		; $6c28
	ret nz			; $6c2b
	ld l,e			; $6c2c
	inc (hl)		; $6c2d
	call magunesuFunc_0d_6d06		; $6c2e
	ld a,$03		; $6c31
	jp enemySetAnimation		; $6c33

@stateB:
	call magunesuFunc_0d_6d18		; $6c36
	call _ecom_decCounter1		; $6c39
	jp nz,_ecom_applyVelocityForTopDownEnemy		; $6c3c
	ld l,$84		; $6c3f
	inc (hl)		; $6c41
	ld a,$04		; $6c42
	jp enemySetAnimation		; $6c44

@stateC:
	call enemyAnimate		; $6c47
	ld e,$a1		; $6c4a
	ld a,(de)		; $6c4c
	or a			; $6c4d
	ret z			; $6c4e
	dec a			; $6c4f
	ld a,$02		; $6c50
	jr nz,magunesuFunc_0d_6ca9	; $6c52

@magunesuFunc_0d_6c54:
	ld h,d			; $6c54
	ld l,$83		; $6c55
	ld (hl),$00		; $6c57
	ld l,$9b		; $6c59
	ld a,$01		; $6c5b
	ldi (hl),a		; $6c5d
	ld (hl),a		; $6c5e
	ret			; $6c5f

@stateD:
	call magunesuFunc_0d_6cb7		; $6c60
	ret nz			; $6c63
	ld l,e			; $6c64
	ld (hl),$08		; $6c65
	call magunesuFunc_0d_6d06		; $6c67
	xor a			; $6c6a
	jp enemySetAnimation		; $6c6b

@stateE:
	call _ecom_decCounter2		; $6c6e
	jr nz,+			; $6c71
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
+
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
	jr z,+			; $6c95
	ld a,$f8		; $6c97
+
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

magunesuFunc_0d_6ca9:
	ld h,d			; $6ca9
	ld l,$84		; $6caa
	inc (hl)		; $6cac
	ld l,$86		; $6cad
	ld (hl),$1e		; $6caf
	call enemySetAnimation		; $6cb1
	jp _ecom_setRandomCardinalAngle		; $6cb4

magunesuFunc_0d_6cb7:
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

magunesuFunc_0d_6ccd:
	ld a,(wFrameCounter)		; $6ccd
	and $38			; $6cd0
	swap a			; $6cd2
	rlca			; $6cd4
	ld hl,magunesuTable_0d_6cde		; $6cd5
	rst_addAToHl			; $6cd8
	ld e,$8f		; $6cd9
	ld a,(hl)		; $6cdb
	ld (de),a		; $6cdc
	ret			; $6cdd

magunesuTable_0d_6cde:
	.db $fe $fd
	.db $fc $fb
	.db $fa $fb
	.db $fc $fd

magunesuFunc_0d_6ce6:
	ld a,(wMagnetGloveState)		; $6ce6
	or a			; $6ce9
	ret z			; $6cea
	call magunesuFunc_0d_6cf3		; $6ceb
	ld b,$46		; $6cee
	jp _ecom_applyGivenVelocity		; $6cf0

magunesuFunc_0d_6cf3:
	call objectGetAngleTowardEnemyTarget		; $6cf3
	ld c,a			; $6cf6
	ld h,d			; $6cf7
	ld l,$83		; $6cf8
	ld a,(wMagnetGloveState)		; $6cfa
	add (hl)		; $6cfd
	bit 1,a			; $6cfe
	ret nz			; $6d00
	ld a,c			; $6d01
	xor $10			; $6d02
	ld c,a			; $6d04
	ret			; $6d05

magunesuFunc_0d_6d06:
	call getRandomNumber_noPreserveVars		; $6d06
	and $03			; $6d09
	ld hl,magunesuTable_0d_6d14		; $6d0b
	rst_addAToHl			; $6d0e
	ld e,$86		; $6d0f
	ld a,(hl)		; $6d11
	ld (de),a		; $6d12
	ret			; $6d13

magunesuTable_0d_6d14:
	.db $3c $78
	.db $78 $b4

magunesuFunc_0d_6d18:
	ld c,$30		; $6d18
	call objectCheckLinkWithinDistance		; $6d1a
	ret nc			; $6d1d
	pop hl			; $6d1e
	ld h,d			; $6d1f
	ld l,Enemy.state	; $6d20
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


; ==============================================================================
; Leftover garbage template code?
; ==============================================================================
	ret			; $6d37
	jr z,+			; $6d38
	sub $03			; $6d3a
	ret c			; $6d3c
	jp z,enemyDie		; $6d3d
	dec a			; $6d40
	jp nz,_ecom_updateKnockbackNoSolidity		; $6d41
	ret			; $6d44
+

enemyCodeTemplate0:
	ld e,Enemy.state	; $6d45
	ld a,(de)		; $6d47
	rst_jumpTable			; $6d48
	.dw @state0
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state2

@state0:
	jp _ecom_setSpeedAndState8AndVisible		; $6d5b

@state_stub:
	ret			; $6d5e

@state2:
	jp enemyAnimate		; $6d5f
	call _ecom_checkHazards		; $6d62
	jr z,+			; $6d65
	sub $03			; $6d67
	ret c			; $6d69
	jp z,enemyDie		; $6d6a
	dec a			; $6d6d
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6d6e
	ret			; $6d71
+

enemyCodeTemplate1:
	ld e,Enemy.state		; $6d72
	ld a,(de)		; $6d74
	rst_jumpTable			; $6d75
	.dw @state0
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub

@state0:
	jp enemyDelete		; $6d86

@state_stub:
	ret			; $6d89

; ==============================================================================
; ENEMYID_GOHMA_GEL
; ==============================================================================
enemyCode46:
	jr z,++			; $6d8a
	sub $03			; $6d8c
	ret c			; $6d8e
	jr nz,+			; $6d8f
	ld a,$32		; $6d91
	call objectGetRelatedObject1Var		; $6d93
	dec (hl)		; $6d96
	ld e,$82		; $6d97
	ld a,(de)		; $6d99
	dec a			; $6d9a
	jp nz,enemyDie_uncounted		; $6d9b
	jp enemyDie_uncounted_withoutItemDrop		; $6d9e
+
	ld e,$82		; $6da1
	ld a,(de)		; $6da3
	cp $02			; $6da4
	jr nz,++		; $6da6
	ld e,$aa		; $6da8
	ld a,(de)		; $6daa
	cp $80			; $6dab
	jr nz,++		; $6dad
	ld e,Enemy.state		; $6daf
	ld a,$0d		; $6db1
	ld (de),a		; $6db3
++
	call _ecom_getSubidAndCpStateTo08		; $6db4
	cp $0a			; $6db7
	jr nc,+			; $6db9
	rst_jumpTable			; $6dbb
	.dw _gohma_gel_state0
	.dw _gohma_gel_state_stub
	.dw _gohma_gel_state_stub
	.dw _gohma_gel_state_stub
	.dw _gohma_gel_state_stub
	.dw _gohma_gel_state5
	.dw _gohma_gel_state_stub
	.dw _gohma_gel_state_stub
	.dw _gohma_gel_state8
	.dw _gohma_gel_state9
+
	ld a,b
	rst_jumpTable
	.dw _gohma_gel_subid0
	.dw _gohma_gel_subid1
	.dw _gohma_gel_subid2
	.dw _gohma_gel_subid3

_gohma_gel_state0:
	call _ecom_setSpeedAndState8		; $6dda
	ld l,$82		; $6ddd
	ld a,(hl)		; $6ddf
	cp $02			; $6de0
	jr nz,+			; $6de2
	ld l,$a5		; $6de4
	ld (hl),$31		; $6de6
+
	jp objectSetVisiblec1		; $6de8

_gohma_gel_state5:
	call _ecom_galeSeedEffect		; $6deb
	ret c			; $6dee
	ld a,$32		; $6def
	call objectGetRelatedObject1Var		; $6df1
	dec (hl)		; $6df4
	jp enemyDelete		; $6df5

_gohma_gel_state_stub:
	ret			; $6df8

_gohma_gel_state8:
	ld bc,$ff00		; $6df9
	call objectSetSpeedZ		; $6dfc
	ld l,e			; $6dff
	inc (hl)		; $6e00
	ld l,$90		; $6e01
	ld (hl),$1e		; $6e03
	call _ecom_setRandomAngle		; $6e05

_gohma_gel_state9:
	ld c,$0e		; $6e08
	call objectUpdateSpeedZ_paramC		; $6e0a
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $6e0d
	ld l,$84		; $6e10
	inc (hl)		; $6e12
	ret			; $6e13

_gohma_gel_subid0:
	ld a,(de)		; $6e14
	sub $0a			; $6e15
	rst_jumpTable			; $6e17
	.dw @stateA
	.dw @stateB
	.dw @stateC

@stateA:
	ld h,d			; $6e1e
	ld l,$90		; $6e1f
	ld (hl),$28		; $6e21
	jr ++			; $6e23

@stateB:
	call enemyAnimate		; $6e25
	ld c,$0c		; $6e28
	call objectUpdateSpeedZ_paramC		; $6e2a
	jr z,+			; $6e2d
	call _ecom_bounceOffWallsAndHoles		; $6e2f
	jp objectApplySpeed		; $6e32
+
	call getRandomNumber_noPreserveVars		; $6e35
	and $07			; $6e38
	ld hl,@gohma_gel_seasonsTable_0d_6e4a		; $6e3a
	rst_addAToHl			; $6e3d
	ld e,$86		; $6e3e
	ld a,(hl)		; $6e40
	ld (de),a		; $6e41
	ld e,$84		; $6e42
	ld a,$0c		; $6e44
	ld (de),a		; $6e46
	jp objectSetVisible82		; $6e47

@gohma_gel_seasonsTable_0d_6e4a:
	.db $01 $01
	.db $01 $30
	.db $30 $30
	.db $30 $30

@stateC:
	call enemyAnimate			; $6e52
	call _ecom_decCounter1		; $6e55
	ret nz			; $6e58
	call objectSetVisiblec1		; $6e59
++
	ld l,$84		; $6e5c
	ld (hl),$0b		; $6e5e
	ld l,$94		; $6e60
	ld a,$80		; $6e62
	ldi (hl),a		; $6e64
	ld (hl),$fe		; $6e65
	jp _ecom_updateAngleTowardTarget		; $6e67

_gohma_gel_subid1:
	ld a,(de)		; $6e6a
	sub $0a			; $6e6b
	rst_jumpTable			; $6e6d
	.dw @stateA
	.dw @stateB
	.dw @stateC
	.dw @stateD

@stateA:
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
	jr +++			; $6e8a

@stateB:
	call _ecom_decCounter1		; $6e8c
	jr z,++			; $6e8f
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6e91
	jr +++			; $6e94

@stateC:
	ld h,d			; $6e96
	ld l,$b0		; $6e97
	call _ecom_readPositionVars		; $6e99
	cp c			; $6e9c
	jr nz,+			; $6e9d
	ldh a,(<hFF8F)		; $6e9f
	cp b			; $6ea1
	jr nz,+			; $6ea2
	ld l,e			; $6ea4
	inc (hl)		; $6ea5
	call seasonsFunc_0d_6f87		; $6ea6
	jr +++			; $6ea9
+
	call objectGetRelativeAngleWithTempVars		; $6eab
	ld e,$89		; $6eae
	ld (de),a		; $6eb0
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6eb1
	jr z,+			; $6eb4
	jr +++			; $6eb6
+
	call _ecom_decCounter1		; $6eb8
	jr nz,+++		; $6ebb
	jr ++			; $6ebd

@stateD:
	call _ecom_decCounter1		; $6ebf
	jr nz,+++		; $6ec2
++
	ld l,$84		; $6ec4
	ld (hl),$0c		; $6ec6
	ld l,$86		; $6ec8
	ld (hl),$08		; $6eca
	ld l,$b0		; $6ecc
	ldh a,(<hEnemyTargetY)	; $6ece
	ldi (hl),a		; $6ed0
	ldh a,(<hEnemyTargetX)	; $6ed1
	ld (hl),a		; $6ed3
+++
	jp enemyAnimate		; $6ed4

_gohma_gel_subid2:
	ld a,(de)		; $6ed7
	sub $0a			; $6ed8
	rst_jumpTable			; $6eda
	.dw _gohma_gel_subid0@stateA
	.dw _gohma_gel_subid0@stateB
	.dw _gohma_gel_subid0@stateC
	.dw @stateD
	.dw @seasonsFunc_0d_6f33

@stateD:
	ld a,($d00b)		; $6ee5
	ld e,$8b		; $6ee8
	ld (de),a		; $6eea
	ld a,($d00d)		; $6eeb
	ld e,$8d		; $6eee
	ld (de),a		; $6ef0
	call _ecom_decCounter1		; $6ef1
	jr z,++			; $6ef4
	ld a,($cc46)		; $6ef6
	or a			; $6ef9
	jr z,+			; $6efa
	dec (hl)		; $6efc
	jr z,++			; $6efd
	dec (hl)		; $6eff
	jr z,++			; $6f00
+
	ld a,(wFrameCounter)		; $6f02
	rrca			; $6f05
	jr nc,+++		; $6f06
	ld hl,wLinkImmobilized		; $6f08
	set 5,(hl)		; $6f0b
	jr +++			; $6f0d
++
	call @seasonsFunc_0d_6f25		; $6f0f
	ld bc,$ff20		; $6f12
	call objectSetSpeedZ		; $6f15
	ld l,$84		; $6f18
	inc (hl)		; $6f1a
	ld a,$8f		; $6f1b
	call playSound		; $6f1d
	call objectSetVisiblec1		; $6f20
	jr +++			; $6f23

@seasonsFunc_0d_6f25:
	ld a,($d009)		; $6f25
	bit 7,a			; $6f28
	jp nz,_ecom_setRandomAngle		; $6f2a
	xor $10			; $6f2d
	ld e,$89		; $6f2f
	ld (de),a		; $6f31
	ret			; $6f32

@seasonsFunc_0d_6f33:
	ld c,$0e		; $6f33
	call objectUpdateSpeedZ_paramC		; $6f35
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $6f38
	ld l,$84		; $6f3b
	ld (hl),$0b		; $6f3d
	ld l,$a4		; $6f3f
	set 7,(hl)		; $6f41
+++
	jp enemyAnimate		; $6f43

_gohma_gel_subid3:
	ld a,(de)		; $6f46
	sub $0a			; $6f47
	rst_jumpTable			; $6f49
	.dw @stateA
	.dw @stateB
	.dw @stateC

@stateA:
	ld h,d			; $6f50
	ld l,e			; $6f51
	inc (hl)		; $6f52
	ld l,$90		; $6f53
	ld (hl),$1e		; $6f55

@stateB:
	ld h,d			; $6f57
	ld l,e			; $6f58
	inc (hl)		; $6f59
	ld l,$86		; $6f5a
	ld (hl),$5a		; $6f5c
	call _ecom_updateAngleTowardTarget		; $6f5e
	call getRandomNumber_noPreserveVars		; $6f61
	and $01			; $6f64
	ld hl,@seasonsTable_0d_6f73		; $6f66
	rst_addAToHl			; $6f69
	ld e,$89		; $6f6a
	ld a,(de)		; $6f6c
	add (hl)		; $6f6d
	and $1f			; $6f6e
	ld (de),a		; $6f70
	jr ++			; $6f71

@seasonsTable_0d_6f73:
	.db $04 $fc

@stateC:
	call _ecom_decCounter1		; $6f75
	jr nz,+			; $6f78
	ld l,e			; $6f7a
	dec (hl)		; $6f7b
	jr ++			; $6f7c
+
	call _ecom_bounceOffWallsAndHoles		; $6f7e
	call objectApplySpeed		; $6f81
++
	jp enemyAnimate		; $6f84

seasonsFunc_0d_6f87:
	call getRandomNumber_noPreserveVars		; $6f87
	and $0f			; $6f8a
	ld hl,seasonsTable_0d_6f95		; $6f8c
	rst_addAToHl			; $6f8f
	ld e,$86		; $6f90
	ld a,(hl)		; $6f92
	ld (de),a		; $6f93
	ret			; $6f94

seasonsTable_0d_6f95:
	.db $01 $01 $14 $14
	.db $14 $14 $14 $3c
	.db $3c $3c $3c $3c
	.db $3c $5a $5a $5a


; ==============================================================================
; ENEMYID_MOTHULA_CHILD
; ==============================================================================
enemyCode47:
	jr z,+			; $6fa5
	sub $03			; $6fa7
	ret c			; $6fa9
	jp z,enemyDie_uncounted		; $6faa
	dec a			; $6fad
	jp nz,_ecom_updateKnockbackNoSolidity		; $6fae
	ret			; $6fb1
+
	call _ecom_getSubidAndCpStateTo08		; $6fb2
	jr nc,+			; $6fb5
	rst_jumpTable			; $6fb7
	.dw @state0
	.dw @state1
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state5
        .dw @state_stub
        .dw @state_stub
+
	ld a,b			; $6fc8
	rst_jumpTable			; $6fc9
        .dw @subid0
        .dw @subid1
        .dw @subid2
        .dw @subid3

@state0:
	bit 7,b			; $6fd2
	ld a,$46		; $6fd4
	jp z,_ecom_setSpeedAndState8AndVisible		; $6fd6
	ld a,$01		; $6fd9
	ld (de),a		; $6fdb

@state1:
	bit 0,b			; $6fdc
	ld bc,$0400		; $6fde
	jr z,+			; $6fe1
	ld bc,$0604		; $6fe3
+
	push bc			; $6fe6
	call checkBEnemySlotsAvailable		; $6fe7
	pop bc			; $6fea
	ret nz			; $6feb
	ld a,b			; $6fec
	ldh (<hFF8B),a	; $6fed
	ld a,c			; $6fef
	ld bc,@seasonsTable_0d_7017		; $6ff0
	call addAToBc		; $6ff3
-
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
	jr nz,-			; $7012
	jp enemyDelete		; $7014

@seasonsTable_0d_7017:
        .db $04 $0c $14 $1c $00
        .db $05 $0b $10 $15 $1b

@state5:
	call _ecom_galeSeedEffect		; $7021
	ret c			; $7024
	jp enemyDelete		; $7025

@state_stub:
	ret			; $7028

@subid0:
	ld a,(de)		; $7029
	sub $08			; $702a
	rst_jumpTable			; $702c
        .dw @@state8
        .dw @@state9

@@state8:
	ld h,d			; $7031
	ld l,e			; $7032
	inc (hl)		; $7033
	ld l,$a4		; $7034
	set 7,(hl)		; $7036
	ld l,$86		; $7038
	ld (hl),$04		; $703a
	inc l			; $703c
	ld (hl),$3c		; $703d
	call seasonsFunc_0d_7089		; $703f
	jp objectSetVisible82		; $7042

@@state9:
	call _ecom_decCounter2		; $7045
	jr z,+			; $7048
	call _ecom_decCounter1		; $704a
	jr nz,+			; $704d
	ld (hl),$04		; $704f
	call objectGetAngleTowardEnemyTarget		; $7051
	call objectNudgeAngleTowards		; $7054
	call seasonsFunc_0d_7089		; $7057
+
	call objectApplySpeed		; $705a
	call seasonsFunc_0d_7078		; $705d
	jp enemyAnimate		; $7060

@subid1:
	ld a,(de)		; $7063
	sub $08			; $7064
	rst_jumpTable			; $7066
	.dw @ret1
@ret1:
	ret			; $7069

@subid2:
	ld a,(de)		; $706a
	sub $08			; $706b
	rst_jumpTable			; $706d
	.dw @ret2
@ret2:
	ret			; $7070

@subid3:
	ld a,(de)		; $7071
	sub $08			; $7072
	rst_jumpTable			; $7074
	.dw @ret3
@ret3:
	ret			; $7077

seasonsFunc_0d_7078:
	ld e,$8b		; $7078
	ld a,(de)		; $707a
	cp $b8			; $707b
	jr nc,+			; $707d
	ld e,$8d		; $707f
	ld a,(de)		; $7081
	cp $f8			; $7082
	ret c			; $7084
+
	pop hl			; $7085
	jp enemyDelete		; $7086

seasonsFunc_0d_7089:
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

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode54:
	jr z,+			; $7099
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
	jr nc,+			; $70ae
	call seasonsFunc_0d_73df		; $70b0
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
	jr z,+			; $70c3
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
+
	call seasonsFunc_0d_7323		; $70dd
	ld a,($cced)		; $70e0
	cp $02			; $70e3
	jr z,+			; $70e5
	ld e,$84		; $70e7
	ld a,(de)		; $70e9
	or a			; $70ea
	jp nz,seasonsFunc_0d_7312		; $70eb
+
	ld e,Enemy.state		; $70ee
	ld a,(de)		; $70f0
	rst_jumpTable			; $70f1
        .dw @state0
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state8
        .dw @state9
        .dw @stateA
        .dw @stateB
        .dw @stateC
        .dw @stateD
        .dw @stateE
        .dw @stateF

@state0:
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
	call seasonsFunc_0d_736d		; $7127
	ld e,$b0		; $712a
	ld a,$01		; $712c
	ld (de),a		; $712e
	call enemySetAnimation		; $712f
	jp objectSetVisiblec2		; $7132

@state_stub:
	ret			; $7135

@state8:
	call seasonsFunc_0d_72d4		; $7136
	inc a			; $7139
	jr z,+			; $713a
	ld e,$84		; $713c
	ld a,$0d		; $713e
	ld (de),a		; $7140
	jr @animate		; $7141
+
	call seasonsFunc_0d_73b1		; $7143
	ld a,$09		; $7146
	jr nc,+			; $7148
	ld a,$0b		; $714a
+
	ld e,$84		; $714c
	ld (de),a		; $714e
	jr @animate		; $714f

@state9:
	ld a,$0a		; $7151
	ld (de),a		; $7153
	jp seasonsFunc_0d_7350		; $7154

@stateA:
	call seasonsFunc_0d_7312		; $7157
	call z,seasonsFunc_0d_736d		; $715a
	call objectApplySpeed		; $715d

@animate:
	jp enemyAnimate		; $7160

@stateB:
	ld a,$0c		; $7163
	ld (de),a		; $7165
	inc e			; $7166
	xor a			; $7167
	ld (de),a		; $7168
	call seasonsFunc_0d_737f		; $7169
	ld e,$83		; $716c
	ld a,b			; $716e
	ld (de),a		; $716f
	ld e,$b1		; $7170
	inc a			; $7172
	ld (de),a		; $7173
	ret			; $7174

@stateC:
	ld e,Enemy.var03		; $7175
	ld a,(de)		; $7177
	ld e,Enemy.state2		; $7178
	rst_jumpTable			; $717a
        .dw @stateCvar03_0
        .dw @stateCvar03_1
        .dw @stateCvar03_2
        .dw @stateCvar03_3
        .dw @stateCvar03_4

@stateD:
	ld h,d			; $7185
	ld l,e			; $7186
	inc (hl)		; $7187
	inc l			; $7188
	ld (hl),$00		; $7189
	ld l,$90		; $718b
	ld (hl),$2d		; $718d
	call seasonsFunc_0d_7395		; $718f
	ret nc			; $7192
	ld e,$b2		; $7193
	ld a,(de)		; $7195
	ld hl,seasonsTable_0d_73d7		; $7196
	rst_addAToHl			; $7199
	ld e,$89		; $719a
	ld a,(hl)		; $719c
	ld (de),a		; $719d
	ret			; $719e

@stateE:
	inc e			; $719f
	ld a,(de)		; $71a0
	rst_jumpTable			; $71a1
        .dw @stateEcont
        .dw @stateA

@stateEcont:
	call seasonsFunc_0d_7312		; $71a6
	jr z,+			; $71a9
	call objectApplySpeed		; $71ab
	jr @animate		; $71ae
+
	ld e,$85		; $71b0
	ld a,$01		; $71b2
	ld (de),a		; $71b4
	ld bc,$4050		; $71b5
	call objectGetRelativeAngle		; $71b8
	ld e,$89		; $71bb
	ld (de),a		; $71bd
	ret			; $71be

@stateF:
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
	jp seasonsFunc_0d_736d		; $71da

@stateCvar03_0:
	call seasonsFunc_0d_7312		; $71dd
	jp z,seasonsFunc_0d_736d		; $71e0
	jp enemyAnimate		; $71e3

@stateCvar03_1:
	ld a,(de)		; $71e6
	rst_jumpTable			; $71e7
        .dw @@state0
        .dw @@state1

@@state0:
	ld h,d			; $71ec
	ld l,e			; $71ed
	inc (hl)		; $71ee
	inc l			; $71ef
	ld (hl),$3c		; $71f0

@@state1:
	call _ecom_decCounter1		; $71f2
	ret nz			; $71f5
	jp seasonsFunc_0d_736d		; $71f6

@stateCvar03_2:
	ld a,(de)		; $71f9
	rst_jumpTable			; $71fa
        .dw @@substate0
        .dw @@substate1
        .dw @@substate2
        .dw @@substate3
        .dw @@substate4

@@substate0:
	ld h,d			; $7205
	ld l,e			; $7206
	inc (hl)		; $7207
	inc l			; $7208
	ld (hl),$1e		; $7209
	ld l,$90		; $720b
	ld (hl),$0a		; $720d
	call seasonsFunc_0d_73cd		; $720f
	xor $10			; $7212
	ld (de),a		; $7214

@@substate1:
	call _ecom_decCounter1		; $7215
	jp nz,objectApplySpeed		; $7218
	ld (hl),$04		; $721b
	ld l,e			; $721d
	inc (hl)		; $721e

@@substate2:
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

@@substate3:
	call _ecom_decCounter1		; $7231
	jr z,+			; $7234
	ld a,(hl)		; $7236
	cp $1a			; $7237
	jp nc,objectApplySpeed		; $7239
	ret			; $723c
+
	ld (hl),$1e		; $723d
	ld l,e			; $723f
	inc (hl)		; $7240

@@substate4:
	call _ecom_decCounter1		; $7241
	ret nz			; $7244
	jp seasonsFunc_0d_736d		; $7245

@stateCvar03_3:
	ld a,(de)		; $7248
	rst_jumpTable			; $7249
        .dw @@substate0
        .dw @@substate1
        .dw @@substate2
        .dw @@substate3

@@substate0:
	ld h,d			; $7252
	ld l,e			; $7253
	inc (hl)		; $7254
	inc l			; $7255
	ld (hl),$03		; $7256

@@substate1:
	call seasonsFunc_0d_7312		; $7258
	ret nz			; $725b
	call _ecom_decCounter1		; $725c
	ret nz			; $725f
	ld (hl),$0a		; $7260
	dec l			; $7262
	inc (hl)		; $7263
	ld l,$90		; $7264
	ld (hl),$28		; $7266
	call seasonsFunc_0d_73cd		; $7268

@@substate2:
	call _ecom_decCounter1		; $726b
	jp nz,objectApplySpeed		; $726e
	ld (hl),$28		; $7271
	ld l,e			; $7273
	inc (hl)		; $7274

@@substate3:
	call _ecom_decCounter1		; $7275
	ret nz			; $7278
	jp seasonsFunc_0d_736d		; $7279

@stateCvar03_4:
	ld a,(de)		; $727c
	rst_jumpTable			; $727d
        .dw @@substate0
        .dw @@substate1
        .dw @@substate2

@@substate0:
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

@@substate1:
	call seasonsFunc_0d_7312		; $7297
	jr z,+			; $729a
	call objectApplySpeed		; $729c
	jr ++			; $729f
+
	ld h,d			; $72a1
	ld l,$85		; $72a2
	inc (hl)		; $72a4
	ld l,$94		; $72a5
	ld a,$c0		; $72a7
	ldi (hl),a		; $72a9
	ld (hl),$fc		; $72aa
	ld l,$90		; $72ac
	ld (hl),$0f		; $72ae

@@substate2:
	ld c,$28		; $72b0
	call objectUpdateSpeedZ_paramC		; $72b2
	jr nz,+			; $72b5
	ld e,$b0		; $72b7
	ld a,$02		; $72b9
	ld (de),a		; $72bb
	call enemySetAnimation		; $72bc
	jp seasonsFunc_0d_736d		; $72bf
+
	ld e,$95		; $72c2
	ld a,(de)		; $72c4
	or a			; $72c5
	jr nz,+			; $72c6
	ld h,d			; $72c8
	ld l,$a4		; $72c9
	set 7,(hl)		; $72cb
+
	rla			; $72cd
	call c,objectApplySpeed		; $72ce
++
	jp enemyAnimate		; $72d1

seasonsFunc_0d_72d4:
	call seasonsFunc_0d_72dc		; $72d4
	ld e,$b2		; $72d7
	ld a,b			; $72d9
	ld (de),a		; $72da
	ret			; $72db

seasonsFunc_0d_72dc:
	ld b,$ff		; $72dc
	ld e,$8b		; $72de
	ld a,(de)		; $72e0
	sub $20			; $72e1
	cp $36			; $72e3
	jr nc,++		; $72e5
	ld e,$8d		; $72e7
	ld a,(de)		; $72e9
	sub $30			; $72ea
	cp $40			; $72ec
	ret c			; $72ee
	ld b,$02		; $72ef
	ld a,(de)		; $72f1
	cp $50			; $72f2
	jr c,+			; $72f4
	inc b			; $72f6
+
	ld e,$8b		; $72f7
	ld a,(de)		; $72f9
	cp $39			; $72fa
	ret c			; $72fc
	ld a,b			; $72fd
	add $02			; $72fe
	ld b,a			; $7300
	ret			; $7301
++
	inc b			; $7302
	ld a,(de)		; $7303
	cp $39			; $7304
	jr c,+			; $7306
	ld b,$06		; $7308
+
	ld e,$8d		; $730a
	ld a,(de)		; $730c
	cp $50			; $730d
	ret c			; $730f
	inc b			; $7310
	ret			; $7311

seasonsFunc_0d_7312:
	ld c,$0e		; $7312
	ld e,$8f		; $7314
	ld a,(de)		; $7316
	or a			; $7317
	jp nz,objectUpdateSpeedZ_paramC		; $7318
	dec a			; $731b
	ld (de),a		; $731c
	ld bc,$ff80		; $731d
	jp objectSetSpeedZ		; $7320

seasonsFunc_0d_7323:
	call seasonsFunc_0d_7340		; $7323
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

seasonsFunc_0d_7340:
	ld e,$84		; $7340
	ld a,(de)		; $7342
	cp $0c			; $7343
	ret nz			; $7345
	ld e,$b1		; $7346
	ld a,(de)		; $7348
	dec a			; $7349
	jr z,+			; $734a
	xor a			; $734c
	ret			; $734d
+
	or d			; $734e
	ret			; $734f

seasonsFunc_0d_7350:
	ld c,$20		; $7350
	call objectCheckLinkWithinDistance		; $7352
	jp nc,_ecom_updateAngleTowardTarget		; $7355
	call getRandomNumber_noPreserveVars		; $7358
	and $01			; $735b
	ld b,$f8		; $735d
	jr z,+			; $735f
	ld b,$08		; $7361
+
	push bc			; $7363
	call objectGetAngleTowardLink		; $7364
	pop bc			; $7367
	ld e,$89		; $7368
	add b			; $736a
	ld (de),a		; $736b
	ret			; $736c

seasonsFunc_0d_736d:
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

seasonsFunc_0d_737f:
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

seasonsFunc_0d_7395:
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

seasonsFunc_0d_73b1:
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

seasonsFunc_0d_73cd:
	ld e,$b0		; $73cd
	ld a,(de)		; $73cf
	rrca			; $73d0
	swap a			; $73d1
	ld e,$89		; $73d3
	ld (de),a		; $73d5
	ret			; $73d6

seasonsTable_0d_73d7:
	add hl,bc		; $73d7
	rla			; $73d8
	rrca			; $73d9
	ld de,$1f01		; $73da
	rlca			; $73dd
	add hl,de		; $73de

seasonsFunc_0d_73df:
	ld a,$2b		; $73df
	call objectGetRelatedObject2Var		; $73e1
	ld e,$ab		; $73e4
	ld a,(de)		; $73e6
	ld (hl),a		; $73e7
	ret			; $73e8

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode55:
	jr z,+++		; $73e9
	sub $03			; $73eb
	ret c			; $73ed
	jr nz,+++		; $73ee
	ld h,d			; $73f0
	ld l,$b2		; $73f1
	bit 0,(hl)		; $73f3
	jr nz,+			; $73f5
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
	jr z,++			; $7409
	ld a,$04		; $740b
	call enemySetAnimation		; $740d
+
	call _ecom_decCounter1		; $7410
	ret nz			; $7413
	jp enemyDie_uncounted		; $7414
++
	ld l,$a9		; $7417
	ld (hl),$00		; $7419
	call objectCopyPosition		; $741b
	jp enemyDelete		; $741e
+++
	ld e,$84		; $7421
	ld a,(de)		; $7423
	rst_jumpTable			; $7424
        .dw @state0
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state_stub
        .dw @state8
        .dw @state9
        .dw @stateA
        .dw @stateB
        .dw @stateC

@state0:
	ld bc,$011f		; $743f
	call _ecom_randomBitwiseAndBCE		; $7442
	ld e,$89		; $7445
	ld a,c			; $7447
	ld (de),a		; $7448
	ld a,b			; $7449
	ld hl,@seasonsTable_0d_7462		; $744a
	rst_addAToHl			; $744d
	ld e,$87		; $744e
	ld a,(hl)		; $7450
	ld (de),a		; $7451
	call seasonsFunc_0d_74ce		; $7452
	ld h,d			; $7455
	ld l,$94		; $7456
	ld a,$80		; $7458
	ldi (hl),a		; $745a
	ld (hl),$fe		; $745b
	ld a,$32		; $745d
	jp _ecom_setSpeedAndState8AndVisible		; $745f

@seasonsTable_0d_7462:
	.db $3c $50

@state_stub:
	ret			; $7464

@state8:
	ld c,$0e		; $7465
	call objectUpdateSpeedZ_paramC		; $7467
	jr nz,@bounceOffWallsAndHoles	; $746a
	ld l,$84		; $746c
	inc (hl)		; $746e
	ld l,$94		; $746f
	ld a,$00		; $7471
	ldi (hl),a		; $7473
	ld (hl),$ff		; $7474
	ret			; $7476

@state9:
	call seasonsFunc_0d_7523		; $7477
	ld c,$0f		; $747a
	call objectUpdateSpeedZ_paramC		; $747c
	jr nz,@bounceOffWallsAndHoles	; $747f
	ld l,$84		; $7481
	inc (hl)		; $7483
	ld l,$87		; $7484
	ld a,(hl)		; $7486
	ld l,$90		; $7487
	ld (hl),a		; $7489
	ret			; $748a

@stateA:
	call seasonsFunc_0d_7547		; $748b
	call seasonsFunc_0d_7523		; $748e
	call seasonsFunc_0d_74e1		; $7491
	call @bounceOffWallsAndHoles		; $7494
	jp enemyAnimate		; $7497

@stateB:
	ld c,$10		; $749a
	call objectUpdateSpeedZ_paramC		; $749c
	ld l,$95		; $749f
	ldd a,(hl)		; $74a1
	or a			; $74a2
	jr nz,+			; $74a3
	ldi a,(hl)		; $74a5
	or a			; $74a6
	jr nz,+			; $74a7
	ld (hl),$02		; $74a9
	ld l,$90		; $74ab
	ld (hl),$6e		; $74ad
+
	ld l,$97		; $74af
	ld h,(hl)		; $74b1
	call seasonsFunc_0d_74fe		; $74b2
	jr nc,@animateAndApplySpeed	; $74b5
	ld e,$8f		; $74b7
	ld a,(de)		; $74b9
	or a			; $74ba
	ret nz			; $74bb

@stateC:
	ld a,$32		; $74bc
	call objectGetRelatedObject1Var		; $74be
	dec (hl)		; $74c1
	jp enemyDelete		; $74c2

@bounceOffWallsAndHoles:
	call _ecom_bounceOffWallsAndHoles		; $74c5

@animateAndApplySpeed:
	call seasonsFunc_0d_74ce		; $74c8
	jp objectApplySpeed		; $74cb

seasonsFunc_0d_74ce:
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

seasonsFunc_0d_74e1:
	ld e,$99		; $74e1
	ld a,(de)		; $74e3
	or a			; $74e4
	ret z			; $74e5
	ld h,d			; $74e6
	ld l,$84		; $74e7
	inc (hl)		; $74e9
	cp h			; $74ea
	jr nz,+			; $74eb
	inc (hl)		; $74ed
+
	ld l,$90		; $74ee
	ld (hl),$28		; $74f0
	ld l,$94		; $74f2
	ld a,$c0		; $74f4
	ldi (hl),a		; $74f6
	ld (hl),$fc		; $74f7
	ld a,$59		; $74f9
	jp playSound		; $74fb

seasonsFunc_0d_74fe:
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
	jr nc,+			; $7511
	ldh a,(<hFF8F)	; $7513
	sub b			; $7515
	add $02			; $7516
	cp $05			; $7518
	ret c			; $751a
+
	call objectGetRelativeAngleWithTempVars		; $751b
	ld e,$89		; $751e
	ld (de),a		; $7520
	or d			; $7521
	ret			; $7522

seasonsFunc_0d_7523:
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

seasonsFunc_0d_7547:
	ld a,(wFrameCounter)		; $7547
	and $07			; $754a
	ret nz			; $754c
	ld a,$a3		; $754d
	jp playSound		; $754f

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode56:
	jr z,+			; $7552
	ld e,$84		; $7554
	ld a,$02		; $7556
	ld (de),a		; $7558
+
	ld e,$84		; $7559
	ld a,(de)		; $755b
	rst_jumpTable			; $755c
        .dw @state0
        .dw @state1
        .dw @state2
        .dw @state3

@state0:
	ld a,$01		; $7565
	ld (de),a		; $7567
	call objectSetVisible80		; $7568
	jr @seasonsFunc_0d_7581		; $756b

@state1:
	ld e,$82		; $756d
	ld a,(de)		; $756f
	jr z,+			; $7570
	ld hl,$cfc0		; $7572
	bit 7,(hl)		; $7575
	jr z,+			; $7577
	ld e,$84		; $7579
	ld a,$02		; $757b
	ld (de),a		; $757d
+
	call enemyAnimate		; $757e

@seasonsFunc_0d_7581:
	ld a,$0b		; $7581
	call objectGetRelatedObject2Var		; $7583
	ldi a,(hl)		; $7586
	ld b,a			; $7587
	inc l			; $7588
	ld c,(hl)		; $7589
	ld e,$84		; $758a
	ld a,(de)		; $758c
	cp $01			; $758d
	jr nz,+			; $758f
	ld e,$a1		; $7591
	ld a,(de)		; $7593
	or a			; $7594
	jr nz,++		; $7595
	ld e,$a0		; $7597
	ld a,(de)		; $7599
	cp $01			; $759a
	jr nz,+			; $759c
	ld a,$92		; $759e
	call playSound		; $75a0
+
	ld e,$a1		; $75a3
	ld a,(de)		; $75a5
++
	add a			; $75a6
	ld hl,@seasonsTable_0d_75c1		; $75a7
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

@seasonsTable_0d_75c1:
        .db $d8 $e0 $00 $00
        .db $06 $f6 $00 $00
        .db $08 $f0 $06 $00
        .db $04 $ec $08 $00
        .db $07 $f0 $06 $00
        .db $05 $f6 $00 $00

@state2:
	ld h,d			; $75d9
	ld l,$85		; $75da
	ld a,(hl)		; $75dc
	or a			; $75dd
	jr nz,+			; $75de
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
	jr @seasonsFunc_0d_7581		; $75fb
+
	ld l,$a1		; $75fd
	bit 7,(hl)		; $75ff
	jp z,enemyAnimate		; $7601
	xor a			; $7604
	ld (hl),a		; $7605
	ld l,$85		; $7606
	ldd (hl),a		; $7608
	inc (hl)		; $7609
	jp @seasonsFunc_0d_7581		; $760a

@state3:
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

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode5b:
	ld e,$84		; $761e
	ld a,(de)		; $7620
	rst_jumpTable			; $7621
        .dw @state0
        .dw @state1
        .dw enemyAnimate

@state0:
	ld a,$01		; $7628
	ld (de),a		; $762a
	call getRandomNumber		; $762b
	and $07			; $762e
	inc a			; $7630
	ld e,$86		; $7631
	ld (de),a		; $7633
	ld a,$b0		; $7634
	jp loadPaletteHeader		; $7636

@state1:
	call _ecom_decCounter1		; $7639
	ret nz			; $763c
	ld l,e			; $763d
	inc (hl)		; $763e
	jp objectSetVisible83		; $763f

; ==============================================================================
; ENEMYID_WALL_FLAME_SHOOTER
; ==============================================================================
enemyCode5c:
	dec a			; $7642
	ret z			; $7643
	dec a			; $7644
	ret z			; $7645
	ld e,$84		; $7646
	ld a,(de)		; $7648
	rst_jumpTable			; $7649
        .dw @state0
        .dw @state1

@state0:
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

@state1:
	call _ecom_decCounter2		; $765f
	ret nz			; $7662
	ld (hl),$10		; $7663
	call getFreePartSlot		; $7665
	ret nz			; $7668
	ld (hl),$26		; $7669
	ld bc,$0600		; $766b
	jp objectCopyPositionWithOffset		; $766e

; ==============================================================================
; ENEMYID_???
; ==============================================================================
enemyCode5f:
	jr z,++			; $7671
	call seasonsFunc_0d_7986		; $7673
	ld e,$a5		; $7676
	ld a,(de)		; $7678
	cp $40			; $7679
	jr nz,++		; $767b
	ld e,$aa		; $767d
	ld a,(de)		; $767f
	res 7,a			; $7680
	sub $0a			; $7682
	cp $02			; $7684
	jr nc,++		; $7686
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
	ld a,$2b		; $769a
	call objectGetRelatedObject1Var		; $769c
	ld (hl),$f8		; $769f
	ld l,Enemy.z		; $76a1
	xor a			; $76a3
	ldi (hl),a		; $76a4
	ld (hl),a		; $76a5
++
	call seasonsFunc_0d_785c		; $76a6
	ld e,Enemy.state		; $76a9
	ld a,(de)		; $76ab
	rst_jumpTable			; $76ac
        .dw @state0
        .dw @state1
        .dw @state2
        .dw @state3

@state0:
	ld a,$01		; $76b5
	ld (de),a		; $76b7

@state1:
	call seasonsFunc_0d_786d		; $76b8
	ld b,h			; $76bb
	ld e,Enemy.state2		; $76bc
	ld a,(hl)		; $76be
	rst_jumpTable			; $76bf
        .dw @seasonsFunc_0d_76fa
        .dw @seasonsFunc_0d_76fa
        .dw @state1zh2
        .dw @state1zh3
        .dw @state1zh4
        .dw @state1zh5

@state2:
	call _ecom_decCounter2		; $76cc
	jr z,+			; $76cf
	ld a,$2e		; $76d1
	call objectGetRelatedObject1Var		; $76d3
	ld (hl),$02		; $76d6
	ld l,$a5		; $76d8
	ld (hl),$3b		; $76da
	jr ++			; $76dc
+
	ld l,e			; $76de
	dec (hl)		; $76df
	ld l,$a4		; $76e0
	set 7,(hl)		; $76e2
	ld a,$25		; $76e4
	call objectGetRelatedObject1Var		; $76e6
	ld (hl),$56		; $76e9
++
	jp seasonsFunc_0d_796d		; $76eb

@state3:
	ld a,$2b		; $76ee
	call objectGetRelatedObject1Var		; $76f0
	ld e,$ab		; $76f3
	ld a,(hl)		; $76f5
	ld (de),a		; $76f6
	jp seasonsFunc_0d_796d		; $76f7

@seasonsFunc_0d_76fa:
	ld h,b			; $76fa
	jp seasonsFunc_0d_7883		; $76fb

@state1zh2:
	ld a,(de)		; $76fe
	rst_jumpTable			; $76ff
        .dw @@substate0
        .dw @@substate1

@@substate0:
	ld h,d			; $7704
	ld l,e			; $7705
	inc (hl)		; $7706
	ld l,$a5		; $7707
	ld (hl),$57		; $7709

@@substate1:
	call @seasonsFunc_0d_76fa		; $770b
	ld l,$b0		; $770e
	ld a,(hl)		; $7710
	add a			; $7711
	add a			; $7712
	ld b,a			; $7713
	ld a,(wFrameCounter)		; $7714
	and $04			; $7717
	rrca			; $7719
	add b			; $771a
	ld hl,@seasonsTable_0d_772b		; $771b
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

@seasonsTable_0d_772b:
        .db $f8 $00 $fb $00
        .db $00 $08 $00 $05
        .db $08 $00 $05 $00
        .db $00 $f8 $00 $fb

@state1zh3:
	ld a,(de)		; $773b
	rst_jumpTable			; $773c
        .dw @@substate0
        .dw @@substate1
        .dw @@substate2
        .dw @@substate3
        .dw @@substate4
        .dw @@substate5

@@substate0:
	ld h,d			; $7749
	ld l,e			; $774a
	inc (hl)		; $774b
	ld l,$a5		; $774c
	ld (hl),$04		; $774e
	ld l,$90		; $7750
	ld (hl),$0a		; $7752
	ld l,$87		; $7754
	ld (hl),$1e		; $7756
	call @seasonsFunc_0d_76fa		; $7758
	ld l,$b0		; $775b
	ld a,(hl)		; $775d
	rrca			; $775e
	swap a			; $775f
	xor $10			; $7761
	ld e,$89		; $7763
	ld (de),a		; $7765
	call seasonsFunc_0d_78ce		; $7766

@@substate1:
	call _ecom_decCounter2		; $7769
	jp nz,seasonsFunc_0d_78bc		; $776c
	ld (hl),$04		; $776f
	ld l,e			; $7771
	inc (hl)		; $7772

@@substate2:
	call _ecom_decCounter2		; $7773
	jp nz,seasonsFunc_0d_78ab		; $7776
	ld (hl),$0a		; $7779
	ld l,e			; $777b
	inc (hl)		; $777c
	ld l,$90		; $777d
	ld (hl),$78		; $777f
	ld l,$89		; $7781
	ld a,(hl)		; $7783
	xor $10			; $7784
	ld (hl),a		; $7786

@@substate3:
	call _ecom_decCounter2		; $7787
	jp nz,seasonsFunc_0d_78bc		; $778a
	ld (hl),$14		; $778d
	ld l,e			; $778f
	inc (hl)		; $7790

@@substate4:
	call _ecom_decCounter2		; $7791
	jp nz,seasonsFunc_0d_78ab		; $7794
	ld (hl),$14		; $7797
	ld l,e			; $7799
	inc (hl)		; $779a
	ld l,$90		; $779b
	ld (hl),$28		; $779d
	ld l,$89		; $779f
	ld a,(hl)		; $77a1
	xor $10			; $77a2
	ld (hl),a		; $77a4

@@substate5:
	call _ecom_decCounter2		; $77a5
	jp nz,seasonsFunc_0d_78bc		; $77a8
	jp @seasonsFunc_0d_76fa		; $77ab

@state1zh4:
	ld a,(de)		; $77ae
	rst_jumpTable			; $77af
        .dw @@substate0
        .dw @@substate1
        .dw @@substate2
        .dw @@substate3

@@substate0:
	ld h,d			; $77b8
	ld l,e			; $77b9
	inc (hl)		; $77ba
	ld l,$a5		; $77bb
	ld (hl),$57		; $77bd

@@substate1:
	call @seasonsFunc_0d_76fa		; $77bf
	ld a,$05		; $77c2
	call objectGetRelatedObject1Var		; $77c4
	ld a,(hl)		; $77c7
	cp $02			; $77c8
	ret c			; $77ca
	ld l,$89		; $77cb
	ld e,$89		; $77cd
	ld a,(hl)		; $77cf
	ld (de),a		; $77d0
	call seasonsFunc_0d_78ce		; $77d1
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

@@substate2:
	call _ecom_decCounter2		; $77e9
	jr nz,+			; $77ec
	ld (hl),$08		; $77ee
	ld l,e			; $77f0
	inc (hl)		; $77f1
	ld l,$90		; $77f2
	ld (hl),$64		; $77f4
	ld l,$89		; $77f6
	ld a,(hl)		; $77f8
	xor $10			; $77f9
	ld (hl),a		; $77fb
+
	call seasonsFunc_0d_78bc		; $77fc
	jp seasonsFunc_0d_78e1		; $77ff

@@substate3:
	call _ecom_decCounter2		; $7802
	jp z,@seasonsFunc_0d_76fa		; $7805
	ld l,$8f		; $7808
	inc (hl)		; $780a
	inc (hl)		; $780b
	jp seasonsFunc_0d_78bc		; $780c

@state1zh5:
	ld a,(de)		; $780f
	rst_jumpTable			; $7810
        .dw @@substate0
        .dw @@substate1
        .dw @@substate2

@@substate0:
	ld h,d			; $7817
	ld l,$85		; $7818
	inc (hl)		; $781a
	ld l,$a4		; $781b
	res 7,(hl)		; $781d
	inc l			; $781f
	ld (hl),$58		; $7820

@@substate1:
	ld a,$05		; $7822
	call objectGetRelatedObject1Var		; $7824
	ld a,(hl)		; $7827
	cp $02			; $7828
	jp c,seasonsFunc_0d_78f8		; $782a
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

@@substate2:
	call _ecom_decCounter2		; $7846
	jr z,+			; $7849
	ld l,$a6		; $784b
	ld a,$06		; $784d
	ldi (hl),a		; $784f
	ld (hl),a		; $7850
+
	call seasonsFunc_0d_7915		; $7851
	call seasonsFunc_0d_78f8		; $7854
	ld c,$34		; $7857
	jp objectUpdateSpeedZ_paramC		; $7859

seasonsFunc_0d_785c:
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

seasonsFunc_0d_786d:
	ld a,$31		; $786d
	call objectGetRelatedObject1Var		; $786f
	ld e,Enemy.var31		; $7872
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

seasonsFunc_0d_7883:
	ld l,$b0		; $7883
	ld a,(hl)		; $7885
	push hl			; $7886
	ld hl,seasonsTable_0d_78a3		; $7887
	rst_addDoubleIndex			; $788a
	ldi a,(hl)		; $788b
	ld c,(hl)		; $788c
	ld b,a			; $788d
	pop hl			; $788e
	ld l,$8f		; $788f
	ld e,$8f		; $7891
	ld a,(hl)		; $7893
	ld (de),a		; $7894

seasonsFunc_0d_7895:
	call objectTakePositionWithOffset		; $7895

seasonsFunc_0d_7898:
	ld l,$b0		; $7898
	ld a,(hl)		; $789a
	cp $02			; $789b
	jp c,objectSetVisible82		; $789d
	jp objectSetVisible81		; $78a0

seasonsTable_0d_78a3:
        .db $fb $fc $01 $06
        .db $04 $04 $01 $fc

seasonsFunc_0d_78ab:
	ld l,$b2		; $78ab
	ld b,(hl)		; $78ad
	inc l			; $78ae
	ld c,(hl)		; $78af
	ld a,$0b		; $78b0
	call objectGetRelatedObject1Var		; $78b2
	push hl			; $78b5
	call seasonsFunc_0d_7895		; $78b6
	pop hl			; $78b9
	jr seasonsFunc_0d_78ce		; $78ba

seasonsFunc_0d_78bc:
	ld l,$b2		; $78bc
	ld b,(hl)		; $78be
	inc l			; $78bf
	ld c,(hl)		; $78c0
	ld a,$0b		; $78c1
	call objectGetRelatedObject1Var		; $78c3
	push hl			; $78c6
	call seasonsFunc_0d_7895		; $78c7
	call objectApplySpeed		; $78ca
	pop hl			; $78cd

seasonsFunc_0d_78ce:
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

seasonsFunc_0d_78e1:
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

seasonsFunc_0d_78f8:
	ld a,$21		; $78f8
	call objectGetRelatedObject1Var		; $78fa
	push hl			; $78fd
	ld a,(hl)		; $78fe
	ld hl,seasonsTable_0d_78a3		; $78ff
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

seasonsFunc_0d_7915:
	call seasonsFunc_0d_795c		; $7915
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
	ld hl,seasonsTable_0d_7954		; $7940
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

seasonsTable_0d_7954:
        .db $fc $00 $00 $04
        .db $04 $00 $00 $fc

seasonsFunc_0d_795c:
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

seasonsFunc_0d_796d:
	ld a,$30		; $796d
	call objectGetRelatedObject1Var		; $796f
	ld a,(hl)		; $7972
	push hl			; $7973
	ld hl,seasonsTable_0d_7982		; $7974
	rst_addAToHl			; $7977
	ld c,(hl)		; $7978
	ld b,$f8		; $7979
	pop hl			; $797b
	call objectTakePositionWithOffset		; $797c
	jp seasonsFunc_0d_7898		; $797f

seasonsTable_0d_7982:
        .db $fb $fc $05 $04

seasonsFunc_0d_7986:
	ld e,$ab		; $7986
	ld a,(de)		; $7988
	bit 7,a			; $7989
	ret z			; $798b
	xor a			; $798c
	ld (de),a		; $798d
	ret			; $798e
