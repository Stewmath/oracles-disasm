.include "code/enemyCode/group1.s"

; ==============================================================================
; ENEMYID_VERAN_SPIDER
; ==============================================================================
enemyCode0f:
	ld b,a			; $67fd

	; Kill spiders when a cutscene trigger occurs
	ld a,(wTmpcfc0.genericCutscene.cfd0)		; $67fe
	or a			; $6801
	ld a,b			; $6802
	jr z,+			; $6803
	ld a,ENEMYSTATUS_NO_HEALTH		; $6805
+
	or a			; $6807
	jr z,@normalStatus			; $6808
	sub ENEMYSTATUS_NO_HEALTH			; $680a
	ret c			; $680c
	jp z,enemyDie		; $680d
	dec a			; $6810
	jp nz,_ecom_updateKnockback		; $6811
	ret			; $6814

@normalStatus:
	call _ecom_checkScentSeedActive		; $6815
	jr z,++			; $6818
	ld e,Enemy.speed		; $681a
	ld a,SPEED_140		; $681c
	ld (de),a		; $681e
++
	ld e,Enemy.state		; $681f
	ld a,(de)		; $6821
	rst_jumpTable			; $6822
	.dw _veranSpider_state_uninitialized
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_switchHook
	.dw _veranSpider_state_scentSeed
	.dw _ecom_blownByGaleSeedState
	.dw _veranSpider_state_stub
	.dw _veranSpider_state_stub
	.dw _veranSpider_state8
	.dw _veranSpider_state9
	.dw _veranSpider_stateA


_veranSpider_state_uninitialized:
	ld a,PALH_8a		; $6839
	call loadPaletteHeader		; $683b

	; Choose a random position roughly within the current screen bounds to spawn the
	; spider at. This prevents the spider from spawning off-screen. But, the width is
	; only checked properly in the last row; if this were spawned in a small room, the
	; spiders could spawn off-screen. (Large rooms aren't a problem since there is no
	; off-screen area to the right, aside from one column, which is marked as solid.)
--
	call getRandomNumber		; $683e
	and $7f			; $6841
	cp $70 + SCREEN_WIDTH			; $6843
	jr nc,--		; $6845

	ld c,a			; $6847
	call objectSetShortPosition		; $6848

	; Adjust position to be relative to screen bounds
	ldh a,(<hCameraX)	; $684b
	add (hl)		; $684d
	ldd (hl),a		; $684e
	ld c,a			; $684f

	dec l			; $6850
	ldh a,(<hCameraY)	; $6851
	add (hl)		; $6853
	ld (hl),a		; $6854
	ld b,a			; $6855

	; If solid at this position, try again next frame.
	call getTileCollisionsAtPosition		; $6856
	ret nz			; $6859

	ld c,$08		; $685a
	call _ecom_setZAboveScreen		; $685c
	ld a,SPEED_60		; $685f
	call _ecom_setSpeedAndState8		; $6861

	ld l,Enemy.collisionType		; $6864
	set 7,(hl)		; $6866

	ld a,SND_FALLINHOLE		; $6868
	call playSound		; $686a
	jp objectSetVisiblec1		; $686d


_veranSpider_state_switchHook:
	inc e			; $6870
	ld a,(de)		; $6871
	rst_jumpTable			; $6872
	.dw _ecom_incState2
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate1:
@substate2:
	ret			; $687b

@substate3:
	ld b,$09		; $687c
	jp _ecom_fallToGroundAndSetState		; $687e


_veranSpider_state_scentSeed:
	ld a,(wScentSeedActive)		; $6881
	or a			; $6884
	jr z,_veranSpider_gotoState9	; $6885

	call _ecom_updateAngleToScentSeed		; $6887
	ld e,Enemy.angle		; $688a
	ld a,(de)		; $688c
	and $18			; $688d
	add $04			; $688f
	ld (de),a		; $6891
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6892


;;
; @addr{6895}
_veranSpider_updateAnimation:
	ld h,d			; $6895
	ld l,Enemy.animCounter		; $6896
	ld a,(hl)		; $6898
	sub $03			; $6899
	jr nc,+			; $689b
	xor a			; $689d
+
	inc a			; $689e
	ld (hl),a		; $689f
	jp enemyAnimate		; $68a0

;;
; @addr{68a3}
_veranSpider_gotoState9:
	ld h,d			; $68a3
	ld l,Enemy.state		; $68a4
	ld (hl),$09		; $68a6
	ld l,Enemy.speed		; $68a8
	ld (hl),SPEED_60		; $68aa
	ret			; $68ac


_veranSpider_state_stub:
	ret			; $68ad


; Falling from sky
_veranSpider_state8:
	ld c,$0e		; $68ae
	call objectUpdateSpeedZ_paramC		; $68b0
	ret nz			; $68b3

	; Landed on ground
	ld l,Enemy.speedZ		; $68b4
	ldi (hl),a		; $68b6
	ld (hl),a		; $68b7

	ld l,Enemy.state		; $68b8
	inc (hl)		; $68ba

	; Enable scent seeds
	ld l,Enemy.var3f		; $68bb
	set 4,(hl)		; $68bd

	call objectSetVisiblec2		; $68bf
	ld a,SND_BOMB_LAND		; $68c2
	call playSound		; $68c4

	call _veranSpider_setRandomAngleAndCounter1		; $68c7
	jr _veranSpider_animate		; $68ca


; Moving in some direction for [counter1] frames
_veranSpider_state9:
	; Check if Link is along a diagonal relative to self?
	call objectGetAngleTowardEnemyTarget		; $68cc
	and $07			; $68cf
	sub $04			; $68d1
	inc a			; $68d3
	cp $03			; $68d4
	jr nc,@moveNormally	; $68d6

	; He is on a diagonal; if counter2 is zero, go to state $0a (charge at Link).
	ld e,Enemy.counter2		; $68d8
	ld a,(de)		; $68da
	or a			; $68db
	jr nz,@moveNormally	; $68dc

	call _ecom_updateAngleTowardTarget		; $68de
	and $18			; $68e1
	add $04			; $68e3
	ld (de),a		; $68e5

	call _ecom_incState		; $68e6
	ld l,Enemy.speed		; $68e9
	ld (hl),SPEED_140		; $68eb
	ld l,Enemy.counter1		; $68ed
	ld (hl),120		; $68ef
	ret			; $68f1

@moveNormally:
	call _ecom_decCounter2		; $68f2
	dec l			; $68f5
	dec (hl) ; [counter1]--
	call nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $68f7
	jp z,_veranSpider_setRandomAngleAndCounter1		; $68fa

_veranSpider_animate:
	jp enemyAnimate		; $68fd


; Charging in some direction for [counter1] frames
_veranSpider_stateA:
	call _ecom_decCounter1		; $6900
	jr z,++			; $6903
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6905
	jp nz,_veranSpider_updateAnimation		; $6908
++
	call _veranSpider_gotoState9		; $690b
	ld l,Enemy.counter2		; $690e
	ld (hl),$40		; $6910


;;
; @addr{6912}
_veranSpider_setRandomAngleAndCounter1:
	ld bc,$1870		; $6912
	call _ecom_randomBitwiseAndBCE		; $6915
	ld e,Enemy.angle		; $6918
	ld a,b			; $691a
	add $04			; $691b
	ld (de),a		; $691d
	ld e,Enemy.counter1		; $691e
	ld a,c			; $6920
	add $70			; $6921
	ld (de),a		; $6923
	ret			; $6924


; ==============================================================================
; ENEMYID_EYESOAR_CHILD
;
; Variables:
;   relatedObj1: Pointer to ENEMYID_EYESOAR
;   relatedObj2: Pointer to INTERACID_0b?
;   var30: Distance away from Eyesoar (position in "circle arc")
;   var31: "Target" distance away from Eyesoar (var30 is moving toward this value)
;   var32: Angle offset for this child (each subid is a quarter circle apart)
;
; See also ENEMYID_EYESOAR variables.
; ==============================================================================
enemyCode11:
	jr z,@normalStatus	; $6925
	sub ENEMYSTATUS_NO_HEALTH			; $6927
	ret c			; $6929
	jr nz,@normalStatus	; $692a

	ld a,Object.health		; $692c
	call objectGetRelatedObject1Var		; $692e
	ld a,(hl)		; $6931
	or a			; $6932
	jp z,enemyDie_uncounted		; $6933

	call objectCreatePuff		; $6936
	ld h,d			; $6939
	ld l,Enemy.state		; $693a
	ld (hl),$0c		; $693c

	ld l,Enemy.counter1		; $693e
	ld (hl),30		; $6940

	ld l,Enemy.var30		; $6942
	ld (hl),$00		; $6944

	ld l,Enemy.collisionType		; $6946
	res 7,(hl)		; $6948

	ld l,Enemy.health		; $694a
	ld (hl),$04		; $694c
	call objectSetInvisible		; $694e

@normalStatus:
	ld a,Object.var39		; $6951
	call objectGetRelatedObject1Var		; $6953
	bit 1,(hl)		; $6956
	ld b,h			; $6958

	ld e,Enemy.state		; $6959
	jr z,@runState	; $695b
	ld a,(de)		; $695d
	cp $0f			; $695e
	jr nc,@runState	; $6960
	cp $0c			; $6962
	ld h,d			; $6964
	jr z,++		; $6965

	ld l,e			; $6967
	ld (hl),$0f ; [state]
	ld l,Enemy.counter1		; $696a
	ld (hl),$f0		; $696c
++
	ld l,Enemy.var31		; $696e
	ld (hl),$18		; $6970

@runState:
	; Note: b == parent (ENEMYID_EYESOAR), which is used in some of the states below.
	ld a,(de)		; $6972
	rst_jumpTable			; $6973
	.dw _eyesoarChild_state_uninitialized
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state_stub
	.dw _eyesoarChild_state8
	.dw _eyesoarChild_state9
	.dw _eyesoarChild_stateA
	.dw _eyesoarChild_stateB
	.dw _eyesoarChild_stateC
	.dw _eyesoarChild_stateD
	.dw _eyesoarChild_stateE
	.dw _eyesoarChild_stateF
	.dw _eyesoarChild_state10


_eyesoarChild_state_uninitialized:
	ld a,Object.yh		; $6996
	call objectGetRelatedObject1Var		; $6998
	ld b,(hl)		; $699b
	ld l,Enemy.xh		; $699c
	ld c,(hl)		; $699e

	ld e,Enemy.subid		; $699f
	ld a,(de)		; $69a1
	ld hl,@initialAnglesForSubids		; $69a2
	rst_addAToHl			; $69a5

	ld e,Enemy.angle		; $69a6
	ld a,(hl)		; $69a8
	ld (de),a		; $69a9
	ld e,Enemy.var32		; $69aa
	ld (de),a		; $69ac
	ld a,$18		; $69ad
	call objectSetPositionInCircleArc		; $69af

	ld e,Enemy.counter1		; $69b2
	ld a,90		; $69b4
	ld (de),a		; $69b6
	ld a,SPEED_100		; $69b7
	jp _ecom_setSpeedAndState8		; $69b9

@initialAnglesForSubids:
	.db ANGLE_UP, ANGLE_RIGHT, ANGLE_DOWN, ANGLE_LEFT



_eyesoarChild_state_stub:
	ret			; $69c0


; Wait for [counter1] frames before becoming visible
_eyesoarChild_state8:
	call _ecom_decCounter1		; $69c1
	ret nz			; $69c4
	ldbc INTERACID_0b,$02		; $69c5
	call objectCreateInteraction		; $69c8
	ret nz			; $69cb
	ld e,Enemy.relatedObj2		; $69cc
	ld a,Interaction.start		; $69ce
	ld (de),a		; $69d0
	inc e			; $69d1
	ld a,h			; $69d2
	ld (de),a		; $69d3

	jp _ecom_incState		; $69d4


_eyesoarChild_state9:
	ld a,Object.animParameter		; $69d7
	call objectGetRelatedObject2Var		; $69d9
	bit 7,(hl)		; $69dc
	ret z			; $69de

	call _ecom_incState		; $69df
	ld l,Enemy.counter1		; $69e2
	ld (hl),$f0		; $69e4
	ld l,Enemy.zh		; $69e6
	ld (hl),$fe		; $69e8
	ld l,Enemy.var30		; $69ea
	ld (hl),$18		; $69ec
	jp objectSetVisiblec2		; $69ee


; Moving around Eyesoar in a circle
_eyesoarChild_stateA:
	ld h,b			; $69f1
	ld l,Enemy.var39		; $69f2
	bit 2,(hl)		; $69f4
	jr z,_eyesoarChild_updatePosition			; $69f6

	ld l,Enemy.var38		; $69f8
	ld a,(hl)		; $69fa
	and $f8			; $69fb
	ld e,Enemy.var31		; $69fd
	ld (de),a		; $69ff
	ld e,Enemy.state		; $6a00
	ld a,$0b		; $6a02
	ld (de),a		; $6a04

;;
; @addr{6a05}
_eyesoarChild_updatePosition:
	ld l,Enemy.yh		; $6a05
	ld b,(hl)		; $6a07
	ld l,Enemy.xh		; $6a08
	ld c,(hl)		; $6a0a

	; [this.var32] += [parent.var3b] (update angle by rotation speed)
	ld l,Enemy.var3b		; $6a0b
	ld e,Enemy.var32		; $6a0d
	ld a,(de)		; $6a0f
	add (hl)		; $6a10
	and $1f			; $6a11
	ld e,Enemy.angle		; $6a13
	ld (de),a		; $6a15

	ld h,d			; $6a16
	ld l,Enemy.var30		; $6a17
	ld a,(hl)		; $6a19
	call objectSetPositionInCircleArc		; $6a1a
	jp enemyAnimate		; $6a1d


_eyesoarChild_stateB:
	; Check if we're the correct distance away
	ld h,d			; $6a20
	ld l,Enemy.var31		; $6a21
	ldd a,(hl)		; $6a23
	cp (hl) ; [var30]
	jr nz,_eyesoarChild_incOrDecHL	; $6a25

	ld l,e			; $6a27
	dec (hl) ; [state]

	; Mark flag in parent indicating we're in position
	ld h,b			; $6a29
	ld l,Enemy.var3a		; $6a2a
	ld e,Enemy.subid		; $6a2c
	ld a,(de)		; $6a2e
	call setFlag		; $6a2f
	jr _eyesoarChild_updatePosition		; $6a32


_eyesoarChild_incOrDecHL:
	ld a,$01		; $6a34
	jr nc,+			; $6a36
	ld a,$ff		; $6a38
+
	add (hl)		; $6a3a
	ld (hl),a		; $6a3b
	ld h,b			; $6a3c
	jr _eyesoarChild_updatePosition		; $6a3d


; Was just "killed"; waiting a bit before reappearing
_eyesoarChild_stateC:
	ld h,b			; $6a3f
	ld l,Enemy.var39		; $6a40
	bit 0,(hl)		; $6a42
	jr nz,@stillInvisible	; $6a44
	call _ecom_decCounter1		; $6a46
	jr nz,@stillInvisible	; $6a49

	ld l,e			; $6a4b
	inc (hl) ; [state]

	ld l,Enemy.collisionType		; $6a4d
	set 7,(hl)		; $6a4f
	call objectSetVisiblec2		; $6a51
	ld h,b			; $6a54
	jr _eyesoarChild_updatePosition		; $6a55

@stillInvisible:
	ld h,b			; $6a57
	ld e,Enemy.subid		; $6a58
	ld a,(de)		; $6a5a
	ld bc,@data		; $6a5b
	call addAToBc		; $6a5e
	ld a,(bc)		; $6a61
	ld l,Enemy.var3a		; $6a62
	or (hl)			; $6a64
	ld (hl),a		; $6a65
	ret			; $6a66

@data:
	.db $11 $22 $44 $88


; Just reappeared
_eyesoarChild_stateD:
	; Update position relative to eyesoar
	ld h,b			; $6a6b
	ld l,Enemy.var38		; $6a6c
	ld a,(hl)		; $6a6e
	and $f8			; $6a6f
	ld h,d			; $6a71
	ld l,Enemy.var30		; $6a72
	cp (hl)			; $6a74
	jr nz,_eyesoarChild_incOrDecHL	; $6a75

	; Reached desired position, go back to state $0a
	ld l,Enemy.state		; $6a77
	ld (hl),$0a		; $6a79

	ld h,b			; $6a7b
	jp _eyesoarChild_updatePosition		; $6a7c


_eyesoarChild_stateE:
	ld h,b			; $6a7f
	ld l,Enemy.var39		; $6a80
	bit 4,(hl)		; $6a82
	jp nz,_eyesoarChild_updatePosition		; $6a84

	ld a,$0b		; $6a87
	ld (de),a ; [state]
	jp _eyesoarChild_updatePosition		; $6a8a


; Moving around randomly
_eyesoarChild_stateF:
	ld h,b			; $6a8d
	ld l,Enemy.var39		; $6a8e
	bit 3,(hl)		; $6a90
	jr nz,@stillMovingRandomly	; $6a92

	; Calculate the angle relative to Eyesoar it should move to
	ld l,Enemy.var3b		; $6a94
	ld e,Enemy.var32		; $6a96
	ld a,(de)		; $6a98
	add (hl)		; $6a99
	and $1f			; $6a9a
	ld e,Enemy.angle		; $6a9c
	ld (de),a		; $6a9e

	call _ecom_incState		; $6a9f

	; $18 units away from Eyesoar
	ld l,Enemy.var30		; $6aa2
	ld (hl),$18		; $6aa4

	jr _eyesoarChild_animate		; $6aa6

@stillMovingRandomly:
	ld a,(wFrameCounter)		; $6aa8
	and $0f			; $6aab
	jr nz,+			; $6aad
	call objectGetAngleTowardEnemyTarget		; $6aaf
	call objectNudgeAngleTowards		; $6ab2
+
	call objectApplySpeed		; $6ab5
	call _ecom_bounceOffScreenBoundary		; $6ab8

_eyesoarChild_animate:
	jp enemyAnimate		; $6abb


; Moving back toward Eyesoar
_eyesoarChild_state10:
	; Load into wTmpcec0 the position offset relative to Eyesoar where we should be
	; moving to
	ld h,b			; $6abe
	ld l,Enemy.var3b		; $6abf
	ld a,(hl)		; $6ac1
	ld e,Enemy.var32		; $6ac2
	ld a,(de)		; $6ac4
	add (hl)		; $6ac5
	and $1f			; $6ac6
	ld c,a			; $6ac8
	ld a,$18		; $6ac9
	ld b,SPEED_100		; $6acb
	call getScaledPositionOffsetForVelocity		; $6acd

	; Get parent.position + offset in bc
	ld a,Object.yh		; $6ad0
	call objectGetRelatedObject1Var		; $6ad2
	ld a,(wTmpcec0+1)		; $6ad5
	add (hl)		; $6ad8
	ld b,a			; $6ad9
	ld l,Enemy.xh		; $6ada
	ld a,(wTmpcec0+3)		; $6adc
	add (hl)		; $6adf
	ld c,a			; $6ae0

	; Store current position
	ld e,l			; $6ae1
	ld a,(de)		; $6ae2
	ldh (<hFF8E),a	; $6ae3
	ld e,Enemy.yh		; $6ae5
	ld a,(de)		; $6ae7
	ldh (<hFF8F),a	; $6ae8

	; Check if we've reached the target position
	cp b			; $6aea
	jr nz,++		; $6aeb
	ldh a,(<hFF8E)	; $6aed
	cp c			; $6aef
	jr z,@reachedTargetPosition	; $6af0
++
	call _ecom_moveTowardPosition		; $6af2
	jr _eyesoarChild_animate		; $6af5

@reachedTargetPosition:
	; Wait for signal to change state
	ld l,Enemy.var39		; $6af7
	bit 1,(hl)		; $6af9
	ret nz			; $6afb

	ld e,Enemy.state		; $6afc
	ld a,$0e		; $6afe
	ld (de),a		; $6b00

	; Set flag in parent's var3a indicating we're good to go?
	ld e,Enemy.subid		; $6b01
	ld a,(de)		; $6b03
	add $04			; $6b04
	ld l,Enemy.var3a		; $6b06
	jp setFlag		; $6b08


; ==============================================================================
; ENEMYID_IRON_MASK
; ==============================================================================
enemyCode1c:
	call _ecom_checkHazards		; $6b0b
	jr z,@normalStatus	; $6b0e
	sub ENEMYSTATUS_NO_HEALTH			; $6b10
	ret c			; $6b12
	jp z,enemyDie		; $6b13
	dec a			; $6b16
	jp nz,_ecom_updateKnockbackAndCheckHazards		; $6b17

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $6b1a
	jr c,@commonState	; $6b1d
	bit 0,b			; $6b1f
	jp z,_ironMask_subid00		; $6b21
	jp _ironMask_subid01		; $6b24

@commonState:
	rst_jumpTable			; $6b27
	.dw _ironMask_state_uninitialized
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub
	.dw _ironMask_state_switchHook
	.dw _ironMask_state_stub
	.dw _ecom_blownByGaleSeedState
	.dw _ironMask_state_stub
	.dw _ironMask_state_stub


_ironMask_state_uninitialized:
	ld a,SPEED_80		; $6b38
	call _ecom_setSpeedAndState8AndVisible		; $6b3a

	ld l,Enemy.counter1		; $6b3d
	inc (hl)		; $6b3f

	bit 0,b			; $6b40
	ret z			; $6b42

	; Subid 1 only
	ld l,Enemy.enemyCollisionMode		; $6b43
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK		; $6b45
	ld l,Enemy.knockbackCounter		; $6b47
	ld (hl),$10		; $6b49
	ld l,Enemy.invincibilityCounter		; $6b4b
	ld (hl),$e8		; $6b4d
	ld a,$04		; $6b4f
	jp enemySetAnimation		; $6b51


_ironMask_state_switchHook:
	inc e			; $6b54
	ld a,(de)		; $6b55
	rst_jumpTable			; $6b56
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

; Using switch hook may cause this enemy's mask to be removed.
@substate0:
	ld e,Enemy.subid		; $6b5f
	ld a,(de)		; $6b61
	or a			; $6b62
	jr nz,@dontRemoveMask	; $6b63

	ld e,Enemy.enemyCollisionMode		; $6b65
	ld a,(de)		; $6b67
	cp ENEMYCOLLISION_UNMASKED_IRON_MASK			; $6b68
	jr z,@dontRemoveMask	; $6b6a

	ld b,ENEMYID_IRON_MASK		; $6b6c
	call _ecom_spawnUncountedEnemyWithSubid01		; $6b6e
	jr nz,@dontRemoveMask	; $6b71

	; Transfer "index" from enabled byte to new enemy
	ld l,Enemy.enabled		; $6b73
	ld e,l			; $6b75
	ld a,(de)		; $6b76
	ld (hl),a		; $6b77

	ld l,Enemy.knockbackAngle		; $6b78
	ld e,l			; $6b7a
	ld a,(de)		; $6b7b
	ld (hl),a		; $6b7c
	call objectCopyPosition		; $6b7d

	ld a,$05		; $6b80
	call enemySetAnimation		; $6b82

	ld a,SND_BOMB_LAND		; $6b85
	call playSound		; $6b87

	ld a,60		; $6b8a
	jr ++			; $6b8c

@dontRemoveMask:
	ld a,16		; $6b8e
++
	ld e,Enemy.counter1		; $6b90
	ld (de),a		; $6b92
	jp _ecom_incState2		; $6b93

@substate1:
@substate2:
	ret			; $6b96

@substate3:
	ld e,Enemy.subid		; $6b97
	ld a,(de)		; $6b99
	or a			; $6b9a
	jp nz,_ecom_fallToGroundAndSetState8		; $6b9b

	ld e,Enemy.enemyCollisionMode		; $6b9e
	ld a,(de)		; $6ba0
	cp ENEMYCOLLISION_IRON_MASK			; $6ba1
	jp nz,_ecom_fallToGroundAndSetState8		; $6ba3

	ld b,$0a		; $6ba6
	call _ecom_fallToGroundAndSetState		; $6ba8

	ld l,Enemy.collisionType		; $6bab
	res 7,(hl)		; $6bad
	ret			; $6baf


_ironMask_state_stub:
	ret			; $6bb0


; Iron mask with mask on
_ironMask_subid00:
	ld a,(de)		; $6bb1
	sub $08			; $6bb2
	rst_jumpTable			; $6bb4
	.dw @state8
	.dw @state9
	.dw @stateA


; Standing in place
@state8:
	call _ecom_decCounter1		; $6bbb
	jp nz,_ironMask_updateCollisionsFromLinkRelativeAngle		; $6bbe
	ld l,e			; $6bc1
	inc (hl) ; [state]
	call _ironMask_chooseRandomAngleAndCounter1		; $6bc3

; Moving in some direction for [counter1] frames
@state9:
	call _ecom_decCounter1		; $6bc6
	jr nz,++		; $6bc9
	ld l,e			; $6bcb
	dec (hl) ; [state]
	call _ironMask_chooseAmountOfTimeToStand		; $6bcd
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6bd0
	call _ironMask_updateCollisionsFromLinkRelativeAngle		; $6bd3
	jp enemyAnimate		; $6bd6

; This enemy has turned into the mask that was removed; will delete self after [counter1]
; frames.
@stateA:
	call _ecom_decCounter1		; $6bd9
	jp nz,_ecom_flickerVisibility		; $6bdc
	jp enemyDelete		; $6bdf


; Iron mask without mask on
_ironMask_subid01:
	call _ecom_decCounter1		; $6be2
	call z,_ironMask_chooseRandomAngleAndCounter1		; $6be5
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $6be8
	jp enemyAnimate		; $6beb


;;
; Modifies this object's enemyCollisionMode based on if Link is directly behind the iron
; mask or not.
; @addr{6bee}
_ironMask_updateCollisionsFromLinkRelativeAngle:
	call objectGetAngleTowardEnemyTarget		; $6bee
	ld h,d			; $6bf1
	ld l,Enemy.angle		; $6bf2
	sub (hl)		; $6bf4
	and $1f			; $6bf5
	sub $0c			; $6bf7
	cp $09			; $6bf9
	ld l,Enemy.enemyCollisionMode		; $6bfb
	jr c,++			; $6bfd
	ld (hl),ENEMYCOLLISION_IRON_MASK		; $6bff
	ret			; $6c01
++
	ld (hl),ENEMYCOLLISION_UNMASKED_IRON_MASK		; $6c02
	ret			; $6c04


;;
; @addr{6c05}
_ironMask_chooseRandomAngleAndCounter1:
	ld bc,$0703		; $6c05
	call _ecom_randomBitwiseAndBCE		; $6c08
	ld a,b			; $6c0b
	ld hl,@counter1Vals		; $6c0c
	rst_addAToHl			; $6c0f

	ld e,Enemy.counter1		; $6c10
	ld a,(hl)		; $6c12
	ld (de),a		; $6c13

	ld e,Enemy.subid		; $6c14
	ld a,(de)		; $6c16
	or a			; $6c17
	jp nz,_ecom_setRandomCardinalAngle		; $6c18

	; Subid 0 only: 1 in 4 chance of turning directly toward Link, otherwise just
	; choose a random angle
	call @chooseAngle		; $6c1b
	swap a			; $6c1e
	rlca			; $6c20
	ld h,d			; $6c21
	ld l,Enemy.direction		; $6c22
	cp (hl)			; $6c24
	ret z			; $6c25
	ld (hl),a		; $6c26
	jp enemySetAnimation		; $6c27

@chooseAngle:
	ld a,c			; $6c2a
	or a			; $6c2b
	jp z,_ecom_updateCardinalAngleTowardTarget		; $6c2c
	jp _ecom_setRandomCardinalAngle		; $6c2f

@counter1Vals:
	.db 25 30 35 40 45 50 55 60

;;
; @addr{6c3a}
_ironMask_chooseAmountOfTimeToStand:
	call getRandomNumber_noPreserveVars		; $6c3a
	and $03			; $6c3d
	ld hl,@counter1Vals		; $6c3f
	rst_addAToHl			; $6c42
	ld e,Enemy.counter1		; $6c43
	ld a,(hl)		; $6c45
	ld (de),a		; $6c46
	ret			; $6c47

@counter1Vals:
	.db 15 30 45 60


; ==============================================================================
; ENEMYID_VERAN_CHILD_BEE
; ==============================================================================
enemyCode1f:
	jr z,@normalStatus	; $6c4c
	sub ENEMYSTATUS_NO_HEALTH			; $6c4e
	ret c			; $6c50
	jp z,enemyDie		; $6c51
	dec a			; $6c54
	jp nz,_ecom_updateKnockbackNoSolidity		; $6c55
	ret			; $6c58

@normalStatus:
	ld e,Enemy.state		; $6c59
	ld a,(de)		; $6c5b
	rst_jumpTable			; $6c5c
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw _ecom_blownByGaleSeedState
	.dw @state_stub
	.dw @state_stub
	.dw @state8
	.dw @state9
	.dw @stateA


@state_uninitialized:
	ld a,SPEED_200		; $6c73
	call _ecom_setSpeedAndState8		; $6c75
	ld l,Enemy.counter1		; $6c78
	ld (hl),$10		; $6c7a

	ld e,Enemy.subid		; $6c7c
	ld a,(de)		; $6c7e
	ld hl,@angleVals		; $6c7f
	rst_addAToHl			; $6c82
	ld e,Enemy.angle		; $6c83
	ld a,(hl)		; $6c85
	ld (de),a		; $6c86
	jp objectSetVisible83		; $6c87

@angleVals:
	.db $10 $16 $0a


@state_stub:
	ret			; $6c8d


@state8:
	call _ecom_decCounter1		; $6c8e
	jr z,++			; $6c91
	call objectApplySpeed		; $6c93
	jr @animate		; $6c96
++
	ld (hl),$0c ; [counter1]
	ld l,e			; $6c9a
	inc (hl) ; [state]
@animate:
	jp enemyAnimate		; $6c9c


@state9:
	call _ecom_decCounter1		; $6c9f
	jr nz,@animate	; $6ca2
	ld l,e			; $6ca4
	inc (hl) ; [state]
	call _ecom_updateAngleTowardTarget		; $6ca6


@stateA:
	call objectApplySpeed		; $6ca9
	call objectCheckWithinRoomBoundary		; $6cac
	jr c,@animate	; $6caf
	call decNumEnemies		; $6cb1
	jp enemyDelete		; $6cb4


; ==============================================================================
; ENEMYID_ANGLER_FISH_BUBBLE
; ==============================================================================
enemyCode26:
	jr z,@normalStatus	; $6cb7
	sub ENEMYSTATUS_NO_HEALTH			; $6cb9
	ret c			; $6cbb
	call @popBubble		; $6cbc

@normalStatus:
	ld e,Enemy.state		; $6cbf
	ld a,(de)		; $6cc1
	rst_jumpTable			; $6cc2
	.dw @state0
	.dw @state1
	.dw @state2


; Initialization
@state0:
	ld h,d			; $6cc9
	ld l,e			; $6cca
	inc (hl) ; [state]

	; Can bounce off walls 5 times before popping
	ld l,Enemy.counter1		; $6ccc
	ld (hl),$05		; $6cce

	ld l,Enemy.speed		; $6cd0
	ld (hl),SPEED_100		; $6cd2

	ld a,Object.direction		; $6cd4
	call objectGetRelatedObject1Var		; $6cd6
	bit 0,(hl)		; $6cd9
	ld c,$f4		; $6cdb
	jr z,+			; $6cdd
	ld c,$0c		; $6cdf
+
	ld b,$00		; $6ce1
	call objectTakePositionWithOffset		; $6ce3
	call _ecom_updateAngleTowardTarget		; $6ce6
	jp objectSetVisible81		; $6ce9


; Bubble moving around
@state1:
	ld a,Object.id		; $6cec
	call objectGetRelatedObject1Var		; $6cee
	ld a,(hl)		; $6cf1
	cp ENEMYID_ANGLER_FISH			; $6cf2
	jr nz,@popBubble	; $6cf4

	call objectApplySpeed		; $6cf6
	call _ecom_bounceOffWallsAndHoles		; $6cf9
	jr z,@animate	; $6cfc

	; Each time it bounces off a wall, decrement counter1
	call _ecom_decCounter1		; $6cfe
	jr z,@popBubble	; $6d01

@animate:
	jp enemyAnimate		; $6d03

@popBubble:
	ld h,d			; $6d06
	ld l,Enemy.state		; $6d07
	ld (hl),$02		; $6d09

	ld l,Enemy.counter1		; $6d0b
	ld (hl),$08		; $6d0d

	ld l,Enemy.collisionType		; $6d0f
	res 7,(hl)		; $6d11

	ld l,Enemy.knockbackCounter		; $6d13
	ld (hl),$00		; $6d15

	; 1 in 4 chance of item drop
	call getRandomNumber_noPreserveVars		; $6d17
	cp $40			; $6d1a
	jr nc,++		; $6d1c

	call getFreePartSlot		; $6d1e
	jr nz,++		; $6d21
	ld (hl),PARTID_ITEM_DROP		; $6d23
	inc l			; $6d25
	ld (hl),ITEM_DROP_SCENT_SEEDS		; $6d26

	ld l,Part.invincibilityCounter		; $6d28
	ld (hl),$f0		; $6d2a
	call objectCopyPosition		; $6d2c
++
	; Bubble pop animation
	ld a,$01		; $6d2f
	call enemySetAnimation		; $6d31
	jp objectSetVisible83		; $6d34


; Bubble in the process of popping
@state2:
	call _ecom_decCounter1		; $6d37
	jr nz,@animate	; $6d3a
	jp enemyDelete		; $6d3c


; ==============================================================================
; ENEMYID_ENABLE_SIDESCROLL_DOWN_TRANSITION
; ==============================================================================
enemyCode2b:
	ld e,Enemy.state		; $6d3f
	ld a,(de)		; $6d41
	or a			; $6d42
	jp z,_ecom_incState		; $6d43

	ld hl,w1Link.xh		; $6d46
	ld a,(hl)		; $6d49
	cp $d0			; $6d4a
	ret c			; $6d4c

	ld l,<w1Link.yh		; $6d4d
	ld a,(hl)		; $6d4f
	ld l,<w1Link.speedZ+1		; $6d50
	add (hl)		; $6d52
	cp LARGE_ROOM_HEIGHT<<4 - 8			; $6d53
	ret c			; $6d55

	ld a,$80|DIR_DOWN		; $6d56
	ld (wScreenTransitionDirection),a		; $6d58
	ret			; $6d5b
