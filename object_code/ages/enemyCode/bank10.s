; ==============================================================================
; ENEMYID_VERAN_FINAL_FORM
;
; Variables:
;   subid: 0 - turtle, 1 - spider, 2 - bee
;   var03: Attack type (for spider form); 0 - rush, 1 - jump, 2 - grab
;   var30: Current health for turtle form (saved here while in other forms)
;   var31: Spider form max health
;   var32: Bee form max health
;   var33: Nonzero if turtle form has been attacked (will transform)
;   var34: Number of times turtle has jumped (when var33 is nonzero)
;   var35: Used for deciding transformations. Value from 0-7.
;   var36/var37: Target position to move towards
;   var38: Used as a signal by "web" objects?
;   var39: Bee form: quadrant the bee entered the screen from
; ==============================================================================
enemyCode02:
	jr z,@normalStatus	; $5827
	sub ENEMYSTATUS_NO_HEALTH			; $5829
	ret c			; $582b
	jr z,@dead	; $582c
	dec a			; $582e
	jr z,@justHit	; $582f

	; ENEMYSTATUS_KNOCKBACK
	ld c,$20		; $5831
	call objectUpdateSpeedZ_paramC		; $5833
	jp _ecom_updateKnockback		; $5836

@justHit:
	ld h,d			; $5839
	ld l,Enemy.subid		; $583a
	ld a,(hl)		; $583c
	or a			; $583d
	jr nz,@notTurtleForm	; $583e

	ld l,Enemy.invincibilityCounter		; $5840
	ld a,(hl)		; $5842
	or a			; $5843
	jr z,@normalStatus	; $5844

	; Note that turtle veran's been hit and should transform soon
	ld l,Enemy.var33		; $5846
	ld (hl),$01		; $5848
	jr @normalStatus		; $584a

@notTurtleForm:
	ld l,Enemy.knockbackCounter		; $584c
	ld a,(hl)		; $584e
	or a			; $584f
	jr z,@normalStatus	; $5850

	; Only spider form takes knockback
	ld l,Enemy.state		; $5852
	ld (hl),$03		; $5854
	ld l,Enemy.counter1		; $5856
	ld (hl),105		; $5858
	ld l,Enemy.enemyCollisionMode		; $585a
	ld (hl),ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE		; $585c

	ld a,(w1Link.state)		; $585e
	cp LINK_STATE_GRABBED			; $5861
	call z,_veranFinal_grabbingLink		; $5863

	ld a,$06		; $5866
	jp enemySetAnimation		; $5868

@dead:
	call _veranFinal_dead		; $586b

@normalStatus:
	ld e,Enemy.subid		; $586e
	ld a,(de)		; $5870
	ld e,Enemy.state		; $5871
	rst_jumpTable			; $5873
	.dw _veranFinal_turtleForm
	.dw _veranFinal_spiderForm
	.dw _veranFinal_beeForm


_veranFinal_turtleForm:
	ld a,(de)		; $587a
	rst_jumpTable			; $587b
	.dw _veranFinal_turtleForm_state0
	.dw _veranFinal_turtleForm_state1
	.dw _veranFinal_turtleForm_state2
	.dw _veranFinal_turtleForm_state3
	.dw _veranFinal_turtleForm_state4
	.dw _veranFinal_turtleForm_state5
	.dw _veranFinal_turtleForm_state6
	.dw _veranFinal_turtleForm_state7
	.dw _veranFinal_turtleForm_state8
	.dw _veranFinal_turtleForm_state9
	.dw _veranFinal_turtleForm_stateA


_veranFinal_turtleForm_state0:
	ld a,$02		; $5892
	ld (wEnemyIDToLoadExtraGfx),a		; $5894
	ld a,PALH_87		; $5897
	call loadPaletteHeader		; $5899
	ld a,SNDCTRL_STOPMUSIC		; $589c
	call playSound		; $589e
	ld a,$01		; $58a1
	ld (wDisabledObjects),a		; $58a3
	ld (wMenuDisabled),a		; $58a6

	ld bc,$0208		; $58a9
	call _enemyBoss_spawnShadow		; $58ac
	ret nz			; $58af
	call _ecom_incState		; $58b0

	call checkIsLinkedGame		; $58b3
	ld l,Enemy.health		; $58b6
	ld a,(hl)		; $58b8
	ld bc,$0c18		; $58b9
	jr nz,++		; $58bc

	; Unlinked: less health (for all forms)
	ld a,$14		; $58be
	ld (hl),a		; $58c0
	ld bc,$080f		; $58c1
++
	ld l,Enemy.var30		; $58c4
	ldi (hl),a		; $58c6
	ld (hl),b ; [var31]
	inc l			; $58c8
	ld (hl),c ; [var32]
	jp objectSetVisible83		; $58ca


; Showing text before fight starts
_veranFinal_turtleForm_state1:
	inc e			; $58cd
	ld a,(de) ; [state2]
	rst_jumpTable			; $58cf
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld a,(wPaletteThread_mode)		; $58d6
	or a			; $58d9
	ret nz			; $58da
	ld a,SND_LIGHTNING		; $58db
	call playSound		; $58dd
	ld bc,TX_5614		; $58e0
	call showText		; $58e3
	jp _ecom_incState2		; $58e6

@substate1:
	ld h,d			; $58e9
	ld l,e			; $58ea
	inc (hl) ; [state2]
	xor a			; $58ec
	ld (wDisabledObjects),a		; $58ed
	ld (wMenuDisabled),a		; $58f0
	ld a,$03		; $58f3
	call enemySetAnimation		; $58f5
	ld a,MUS_FINAL_BOSS		; $58f8
	ld (wActiveMusic),a		; $58fa
	jp playSound		; $58fd

@substate2:
	call enemyAnimate		; $5900
	ld e,Enemy.animParameter		; $5903
	ld a,(de)		; $5905
	inc a			; $5906
	ret nz			; $5907
	call _ecom_incState		; $5908
	ld l,Enemy.counter1		; $590b
	ld (hl),30		; $590d
	ld l,Enemy.speed		; $590f
	ld (hl),SPEED_1c0		; $5911
	inc a			; $5913
	jp enemySetAnimation		; $5914


; About to jump
_veranFinal_turtleForm_state2:
	ld e,Enemy.animParameter		; $5917
	ld a,(de)		; $5919
	or a			; $591a
	jp nz,enemyAnimate		; $591b

	call _ecom_decCounter1		; $591e
	ret nz			; $5921
	ld l,Enemy.state		; $5922
	inc (hl)		; $5924
	ld l,Enemy.speedZ		; $5925
	ld (hl),<(-$400)		; $5927
	inc l			; $5929
	ld (hl),>(-$400)		; $592a
	call _ecom_updateAngleTowardTarget		; $592c
	call objectSetVisible81		; $592f
	ld a,SND_UNKNOWN4		; $5932
	call playSound		; $5934
	ld a,$02		; $5937
	jp enemySetAnimation		; $5939


; Jumping (until starts moving down)
_veranFinal_turtleForm_state3:
	ld c,$20		; $593c
	call objectUpdateSpeedZ_paramC		; $593e
	ldd a,(hl)		; $5941
	or (hl)			; $5942
	jp nz,_ecom_applyVelocityForTopDownEnemyNoHoles		; $5943

	inc l			; $5946
	inc (hl) ; [speedZ] = $0100

	ld l,Enemy.state		; $5948
	inc (hl)		; $594a
	ld l,Enemy.speed		; $594b
	ld (hl),SPEED_300		; $594d
	ld l,Enemy.var36		; $594f
	ldh a,(<hEnemyTargetY)	; $5951
	and $f0			; $5953
	add $08			; $5955
	ldi (hl),a		; $5957
	ldh a,(<hEnemyTargetX)	; $5958
	and $f0			; $595a
	add $08			; $595c
	ld (hl),a ; [var37]
	ld a,$01		; $595f
	jp enemySetAnimation		; $5961


; Falling and homing in on a position
_veranFinal_turtleForm_state4:
	ld c,$10		; $5964
	call objectUpdateSpeedZ_paramC		; $5966
	jr z,@nextState	; $5969
	call _veranFinal_moveTowardTargetPosition		; $596b
	ret nc			; $596e
	ld l,Enemy.yh		; $596f
	ld (hl),b		; $5971
	ld l,Enemy.xh		; $5972
	ld (hl),c		; $5974
	ret			; $5975

@nextState:
	ld a,$10		; $5976
	call setScreenShakeCounter		; $5978
	call _ecom_incState		; $597b
	ld l,Enemy.counter1		; $597e
	ld (hl),$0c		; $5980
	call objectSetVisible83		; $5982
	ld a,SND_POOF		; $5985
	call playSound		; $5987
	ld b,PARTID_VERAN_ACID_POOL		; $598a
	jp _ecom_spawnProjectile		; $598c


; Landed
_veranFinal_turtleForm_state5:
	call _ecom_decCounter1		; $598f
	ret nz			; $5992

	ld l,Enemy.speed		; $5993
	ld (hl),SPEED_1c0		; $5995
	ld l,Enemy.var33		; $5997
	bit 0,(hl)		; $5999
	ld l,Enemy.var34		; $599b
	jr z,+			; $599d
	inc (hl)		; $599f
+
	ld a,(hl)		; $59a0
	ld bc,@transformProbabilities		; $59a1
	call addAToBc		; $59a4
	ld a,(bc)		; $59a7
	ld b,a			; $59a8
	inc a			; $59a9
	ld l,e			; $59aa
	jr z,++			; $59ab

	call getRandomNumber		; $59ad
	and b			; $59b0
	jp z,_veranFinal_transformToBeeOrSpider		; $59b1

	ld e,Enemy.var33		; $59b4
	ld a,(de)		; $59b6
	rrca			; $59b7
	jr c,@jumpAgain		; $59b8
++
	call getRandomNumber		; $59ba
	cp 90			; $59bd
	jr nc,@jumpAgain		; $59bf

	; Open face
	inc (hl) ; [state2] = $06
	ld l,Enemy.counter1		; $59c2
	ld (hl),$08		; $59c4
	ld a,SND_GORON		; $59c6
	call playSound		; $59c8
	ld a,$04		; $59cb
	jp enemySetAnimation		; $59cd

@jumpAgain
	ld (hl),$02 ; [state]
	ld l,Enemy.counter1		; $59d2
	ld (hl),30		; $59d4
	ret			; $59d6

@transformProbabilities:
	.db $ff $03 $03 $01 $00


; Face is opening
_veranFinal_turtleForm_state6:
	call enemyAnimate		; $59dc
	ld h,d			; $59df
	ld l,Enemy.animParameter		; $59e0
	bit 7,(hl)		; $59e2
	jr nz,@nextState	; $59e4
	bit 0,(hl)		; $59e6
	ret z			; $59e8
	ld l,Enemy.enemyCollisionMode		; $59e9
	ld (hl),ENEMYCOLLISION_VERAN_TURTLE_FORM_VULNERABLE		; $59eb
	ret			; $59ed

@nextState:
	ld l,Enemy.state		; $59ee
	inc (hl)		; $59f0
	ld l,Enemy.counter1		; $59f1
	ld (hl),90		; $59f3
	xor a			; $59f5
	jp enemySetAnimation		; $59f6


_veranFinal_turtleForm_state7:
	call _ecom_decCounter1		; $59f9
	jp nz,enemyAnimate		; $59fc
	ld l,e			; $59ff
	inc (hl) ; [state]
	ld a,$03		; $5a01
	jp enemySetAnimation		; $5a03


_veranFinal_turtleForm_state8:
	call enemyAnimate		; $5a06
	ld h,d			; $5a09
	ld l,Enemy.animParameter		; $5a0a
	bit 7,(hl)		; $5a0c
	jr nz,@nextState	; $5a0e
	bit 0,(hl)		; $5a10
	ret z			; $5a12
	ld l,Enemy.enemyCollisionMode		; $5a13
	ld (hl),ENEMYCOLLISION_VERAN_TURTLE_FORM		; $5a15
	ret			; $5a17

@nextState:
	ld l,Enemy.state		; $5a18
	ld (hl),$02		; $5a1a
	ld l,Enemy.counter1		; $5a1c
	ld (hl),30		; $5a1e
	ld a,$01		; $5a20
	jp enemySetAnimation		; $5a22


; Just transformed back from being a spider or bee
_veranFinal_turtleForm_state9:
	call enemyAnimate		; $5a25
	ld e,Enemy.animParameter		; $5a28
	ld a,(de)		; $5a2a
	inc a			; $5a2b
	ret nz			; $5a2c

	ld h,d			; $5a2d
	ld l,Enemy.var33		; $5a2e
	ldi (hl),a ; [var33] = 0
	ld (hl),a  ; [var34] = 0

	ld l,Enemy.state		; $5a32
	dec (hl)		; $5a34
	ld l,Enemy.collisionType		; $5a35
	ld (hl),$80|ENEMYID_VERAN_FINAL_FORM
	inc l			; $5a39
	ld (hl),ENEMYCOLLISION_VERAN_TURTLE_FORM_VULNERABLE ; [enemyCollisionType]

	ld l,Enemy.oamFlagsBackup		; $5a3c
	ld a,$06		; $5a3e
	ldi (hl),a		; $5a40
	ld (hl),a		; $5a41
	ld a,$03		; $5a42
	jp enemySetAnimation		; $5a44


; Dead
_veranFinal_turtleForm_stateA:
	inc e			; $5a47
	ld a,(de)		; $5a48
	rst_jumpTable			; $5a49
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld e,Enemy.invincibilityCounter		; $5a52
	ld a,(de)		; $5a54
	or a			; $5a55
	ret nz			; $5a56
	call checkLinkVulnerable		; $5a57
	ret nc			; $5a5a

	ld a,$01		; $5a5b
	ld (wMenuDisabled),a		; $5a5d
	ld (wDisabledObjects),a		; $5a60

	call dropLinkHeldItem		; $5a63
	call clearAllParentItems		; $5a66
	call _ecom_incState2		; $5a69

	call checkIsLinkedGame		; $5a6c
	ld bc,TX_5615		; $5a6f
	jr z,+			; $5a72
	ld bc,TX_5616		; $5a74
+
	jp showText		; $5a77

@substate1:
	ld a,(wTextIsActive)		; $5a7a
	or a			; $5a7d
	ret nz			; $5a7e
	call _ecom_incState2		; $5a7f
	ld l,Enemy.counter2		; $5a82
	ld (hl),40		; $5a84
	ld l,Enemy.yh		; $5a86
	ld b,(hl)		; $5a88
	ld l,Enemy.xh		; $5a89
	ld c,(hl)		; $5a8b
	ld a,$ff		; $5a8c
	jp createEnergySwirlGoingOut		; $5a8e

@substate2:
	call _ecom_decCounter2		; $5a91
	ret nz			; $5a94
	ldbc INTERACID_MISC_PUZZLES, $21		; $5a95
	call objectCreateInteraction		; $5a98
	ret nz			; $5a9b
	jp _ecom_incState2		; $5a9c

@substate3:
	ld a,(wPaletteThread_mode)		; $5a9f
	or a			; $5aa2
	ret nz			; $5aa3
	ld hl,wGroup4Flags+(<ROOM_AGES_4fc)		; $5aa4
	set 7,(hl)		; $5aa7
	ld a,CUTSCENE_BLACK_TOWER_ESCAPE		; $5aa9
	ld (wCutsceneTrigger),a		; $5aab
	call incMakuTreeState		; $5aae
	jp enemyDelete		; $5ab1


_veranFinal_spiderForm:
	ld a,(de)		; $5ab4
	rst_jumpTable			; $5ab5
	.dw _veranFinal_spiderOrBeeForm_state0
	.dw _veranFinal_spiderForm_state1
	.dw _veranFinal_spiderForm_state2
	.dw _veranFinal_spiderForm_state3
	.dw _veranFinal_spiderForm_state4


_veranFinal_spiderOrBeeForm_state0:
	ret			; $5ac0


_veranFinal_spiderForm_state1:
	call enemyAnimate		; $5ac1
	ld e,Enemy.animParameter		; $5ac4
	ld a,(de)		; $5ac6
	inc a			; $5ac7
	ret nz			; $5ac8

	ld bc,$1010		; $5ac9
	ld e,ENEMYCOLLISION_VERAN_SPIDER_FORM		; $5acc
	ld l,Enemy.var31		; $5ace
	call _veranFinal_initializeForm		; $5ad0
	ld a,$05		; $5ad3
	call enemySetAnimation		; $5ad5

_veranFinal_spiderForm_setCounter2AndInitState2:
	ld e,Enemy.counter2		; $5ad8
	ld a,120		; $5ada
	ld (de),a		; $5adc

_veranFinal_spiderForm_initState2:
	ld h,d			; $5add
	ld l,Enemy.state		; $5ade
	ld (hl),$02		; $5ae0
	ld l,Enemy.speed		; $5ae2
	ld (hl),SPEED_c0		; $5ae4

	call getRandomNumber_noPreserveVars		; $5ae6
	and $03			; $5ae9
	ld hl,@counter1Vals		; $5aeb
	rst_addAToHl			; $5aee
	ld e,Enemy.counter1		; $5aef
	ld a,(hl)		; $5af1
	ld (de),a		; $5af2
	call _veranFinal_spiderForm_decideAngle		; $5af3
	jr _veranFinal_spiderForm_animate		; $5af6

@counter1Vals:
	.db 60,80,100,120


_veranFinal_spiderForm_state2:
	call _ecom_decCounter2		; $5afc
	jr nz,++		; $5aff
	ld (hl),120		; $5b01
	call _veranFinal_spiderForm_decideWhetherToAttack		; $5b03
	ret c			; $5b06
++
	call _ecom_decCounter1		; $5b07
	jr z,_veranFinal_spiderForm_initState2	; $5b0a

_veranFinal_spiderForm_updateMovement:
	call _ecom_bounceOffWallsAndHoles		; $5b0c
	call objectApplySpeed		; $5b0f

_veranFinal_spiderForm_animate:
	jp enemyAnimate		; $5b12


_veranFinal_spiderForm_state3:
	ld e,Enemy.zh		; $5b15
	ld a,(de)		; $5b17
	rlca			; $5b18
	ld c,$20		; $5b19
	jp c,objectUpdateSpeedZ_paramC		; $5b1b

	call _ecom_decCounter1		; $5b1e
	jr z,@gotoState2	; $5b21

	ld a,(hl)		; $5b23
	rrca			; $5b24
	ret c			; $5b25
	ld l,Enemy.zh		; $5b26
	ld a,(hl)		; $5b28
	xor $02			; $5b29
	ld (hl),a		; $5b2b
	ret			; $5b2c

@gotoState2:
	ld l,Enemy.zh		; $5b2d
	ld (hl),$00		; $5b2f
	call objectSetVisible83		; $5b31
	call _veranFinal_spiderForm_resetCollisionData		; $5b34
	jr _veranFinal_spiderForm_initState2		; $5b37


; Doing an attack
_veranFinal_spiderForm_state4:
	ld e,Enemy.var03		; $5b39
	ld a,(de)		; $5b3b
	ld e,Enemy.state2		; $5b3c
	rst_jumpTable			; $5b3e
	.dw _veranFinal_spiderForm_rushAttack
	.dw _veranFinal_spiderForm_jumpAttack
	.dw _veranFinal_spiderForm_webAttack


; Rush toward Link for 1 second
_veranFinal_spiderForm_rushAttack:
	ld a,(de)		; $5b45
	or a			; $5b46
	jr z,@substate0	; $5b47

@substate1:
	call _ecom_decCounter1		; $5b49
	jr z,_veranFinal_spiderForm_setCounter2AndInitState2	; $5b4c
	call _veranFinal_spiderForm_updateMovement		; $5b4e
	jp enemyAnimate		; $5b51

@substate0:
	call _ecom_incState2		; $5b54
	inc l			; $5b57
	ld (hl),60 ; [counter1]
	ld l,Enemy.speed		; $5b5a
	ld (hl),SPEED_180		; $5b5c

	call _ecom_updateAngleTowardTarget		; $5b5e
	and $18			; $5b61
	add $04			; $5b63
	ld (de),a		; $5b65
	jr _veranFinal_spiderForm_animate		; $5b66


; Jumps up and crashes back down onto the ground
_veranFinal_spiderForm_jumpAttack:
	ld a,(de)		; $5b68
	rst_jumpTable			; $5b69
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld b,PARTID_VERAN_SPIDERWEB		; $5b74
	call _ecom_spawnProjectile		; $5b76
	ret nz			; $5b79
	call _ecom_incState2		; $5b7a
	ld l,Enemy.var38		; $5b7d
	ld (hl),$00		; $5b7f
	call _veranFinal_spiderForm_setVulnerableCollisionData		; $5b81
	jp objectSetVisible81		; $5b84

@substate1:
	; Wait for signal from child object?
	ld e,Enemy.var38		; $5b87
	ld a,(de)		; $5b89
	or a			; $5b8a
	ret z			; $5b8b

	ld h,d			; $5b8c
	ld l,Enemy.zh		; $5b8d
	ld a,(hl)		; $5b8f
	sub $03			; $5b90
	ld (hl),a		; $5b92
	bit 7,a			; $5b93
	jr z,++			; $5b95

	cp $e0			; $5b97
	ret nc			; $5b99

	ldh a,(<hCameraY)	; $5b9a
	ld b,a			; $5b9c
	ld a,(hl)		; $5b9d
	ld l,Enemy.yh		; $5b9e
	add (hl)		; $5ba0
	sub b			; $5ba1
	cp $b0			; $5ba2
	ret c			; $5ba4
++
	ld l,Enemy.state2		; $5ba5
	inc (hl)		; $5ba7
	inc l			; $5ba8
	ld (hl),90 ; [counter1]
	ld l,Enemy.collisionType		; $5bab
	res 7,(hl)		; $5bad
	ld l,Enemy.zh		; $5baf
	ld (hl),$00		; $5bb1
	jp objectSetInvisible		; $5bb3

@substate2:
	call _ecom_decCounter1		; $5bb6
	ret nz			; $5bb9
	ld l,e			; $5bba
	inc (hl) ; [state2]
	ld l,Enemy.collisionType		; $5bbc
	set 7,(hl)		; $5bbe
	ld l,Enemy.speedZ		; $5bc0
	xor a			; $5bc2
	ldi (hl),a		; $5bc3
	ld (hl),$01		; $5bc4

	ld l,Enemy.yh		; $5bc6
	ldh a,(<hEnemyTargetY)	; $5bc8
	ldi (hl),a		; $5bca
	inc l			; $5bcb
	ldh a,(<hEnemyTargetX)	; $5bcc
	ld (hl),a		; $5bce
	ld c,$08		; $5bcf
	call _ecom_setZAboveScreen		; $5bd1
	call _veranFinal_spiderForm_resetCollisionData		; $5bd4
	jp objectSetVisible81		; $5bd7

@substate3:
	ld c,$20		; $5bda
	call objectUpdateSpeedZ_paramC		; $5bdc
	ret nz			; $5bdf

	; Landed
	ld l,Enemy.state2		; $5be0
	inc (hl)		; $5be2
	inc l			; $5be3
	ld (hl),120 ; [counter1]
	ld a,SND_STRONG_POUND		; $5be6
	call playSound		; $5be8
	ld a,90		; $5beb
	call setScreenShakeCounter		; $5bed
	jp objectSetVisible83		; $5bf0

@substate4:
	call _ecom_decCounter1		; $5bf3
	ret nz			; $5bf6
	jp _veranFinal_spiderForm_setCounter2AndInitState2		; $5bf7


; Shoots out web to try and catch Link
_veranFinal_spiderForm_webAttack:
	ld a,(de)		; $5bfa
	rst_jumpTable			; $5bfb
	.dw _veranFinal_spiderForm_webAttack_substate0
	.dw _veranFinal_spiderForm_webAttack_substate1
	.dw _veranFinal_spiderForm_webAttack_substate2
	.dw _veranFinal_spiderForm_webAttack_substate3
	.dw _veranFinal_spiderForm_webAttack_substate4
	.dw _veranFinal_spiderForm_webAttack_substate5
	.dw _veranFinal_spiderForm_webAttack_substate6
	.dw _veranFinal_spiderForm_webAttack_substate7


_veranFinal_spiderForm_webAttack_substate0:
	ld h,d			; $5c0c
	ld l,e			; $5c0d
	inc (hl) ; [state2]
	inc l			; $5c0f
	ld (hl),30 ; [counter1]
	ld l,Enemy.var38		; $5c12
	ld (hl),$00		; $5c14

_veranFinal_spiderForm_resetCollisionData:
	ld h,d			; $5c16
	ld l,Enemy.enemyCollisionMode		; $5c17
	ld (hl),ENEMYCOLLISION_VERAN_SPIDER_FORM		; $5c19
	ld l,Enemy.collisionRadiusY		; $5c1b
	ld (hl),$10		; $5c1d
	ld a,$05		; $5c1f
	jp enemySetAnimation		; $5c21


_veranFinal_spiderForm_webAttack_substate1:
	call _ecom_decCounter1		; $5c24
	ret nz			; $5c27
	inc l			; $5c28
	ld (hl),$08 ; [counter2]
	ld l,e			; $5c2b
	inc (hl) ; [state2]

_veranFinal_spiderForm_setVulnerableCollisionData:
	ld h,d			; $5c2d
	ld l,Enemy.enemyCollisionMode		; $5c2e
	ld (hl),ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE		; $5c30
	ld l,Enemy.collisionRadiusY		; $5c32
	ld (hl),$08		; $5c34
	ld a,$06		; $5c36
	jp enemySetAnimation		; $5c38


_veranFinal_spiderForm_webAttack_substate2:
	call _ecom_decCounter2		; $5c3b
	ret nz			; $5c3e

	ld b,PARTID_VERAN_SPIDERWEB		; $5c3f
	call _ecom_spawnProjectile		; $5c41
	ret nz			; $5c44
	ld l,Part.subid		; $5c45
	inc (hl) ; [subid] = 1
	call _ecom_incState2		; $5c48
	inc l			; $5c4b
	ld (hl),90 ; [counter1]
	jr _veranFinal_spiderForm_resetCollisionData		; $5c4e


; Web coming back?
_veranFinal_spiderForm_webAttack_substate3:
	ld e,Enemy.var38		; $5c50
	ld a,(de)		; $5c52
	or a			; $5c53
	ret z			; $5c54

	call _ecom_decCounter1		; $5c55
	ret nz			; $5c58

	ld a,(w1Link.state)		; $5c59
	cp LINK_STATE_GRABBED			; $5c5c
	jp nz,_veranFinal_spiderForm_setCounter2AndInitState2		; $5c5e

	; Grabbed
	call _ecom_incState2		; $5c61
	inc l			; $5c64
	ld (hl),$10		; $5c65
	ld a,$06		; $5c67
	call enemySetAnimation		; $5c69
	ld b,$f8		; $5c6c

_veranFinal_spiderForm_webAttack_updateLinkPosition:
	ld hl,w1Link		; $5c6e
	ld c,$00		; $5c71
	jp objectCopyPositionWithOffset		; $5c73


_veranFinal_spiderForm_webAttack_substate4:
	call _ecom_decCounter1		; $5c76
	ret nz			; $5c79

	ld (hl),$04 ; [counter1]
	ld l,e			; $5c7c
	inc (hl) ; [state2]
	ld a,$05		; $5c7e
	call enemySetAnimation		; $5c80
	ld a,$04		; $5c83
	call setScreenShakeCounter		; $5c85
	ld b,$14		; $5c88
	call _veranFinal_spiderForm_webAttack_updateLinkPosition		; $5c8a
	ldbc -6,$08		; $5c8d

_veranFinal_spiderForm_webAttack_applyDamageToLink:
	ld l,<w1Link.damageToApply		; $5c90
	ld (hl),b		; $5c92
	ld l,<w1Link.invincibilityCounter		; $5c93
	ld (hl),c		; $5c95
	ld a,SND_STRONG_POUND		; $5c96
	jp playSound		; $5c98


_veranFinal_spiderForm_webAttack_substate5:
	call _ecom_decCounter1		; $5c9b
	ret nz			; $5c9e
	ld (hl),$08		; $5c9f
	ld l,e			; $5ca1
	inc (hl)		; $5ca2
	ld a,$06		; $5ca3
	call enemySetAnimation		; $5ca5
	ld b,$f6		; $5ca8
	jr _veranFinal_spiderForm_webAttack_updateLinkPosition		; $5caa


_veranFinal_spiderForm_webAttack_substate6:
	call _ecom_decCounter1		; $5cac
	ret nz			; $5caf
	ld (hl),$0f		; $5cb0
	ld l,e			; $5cb2
	inc (hl)		; $5cb3
	ld a,$05		; $5cb4
	call enemySetAnimation		; $5cb6
	ld a,$14		; $5cb9
	call setScreenShakeCounter		; $5cbb
	ld b,$14		; $5cbe
	call _veranFinal_spiderForm_webAttack_updateLinkPosition		; $5cc0
	ldbc -10,$18		; $5cc3
	jr _veranFinal_spiderForm_webAttack_applyDamageToLink		; $5cc6


_veranFinal_spiderForm_webAttack_substate7:
	call _ecom_decCounter1		; $5cc8
	ret nz			; $5ccb
	ld l,Enemy.collisionType		; $5ccc
	set 7,(hl)		; $5cce
	call _veranFinal_spiderForm_setCounter2AndInitState2		; $5cd0


_veranFinal_grabbingLink:
	ld hl,w1Link.state2		; $5cd3
	ld (hl),$02		; $5cd6
	ld l,<w1Link.collisionType		; $5cd8
	set 7,(hl)		; $5cda
	ret			; $5cdc


_veranFinal_beeForm:
	ld a,(de)		; $5cdd
	rst_jumpTable			; $5cde
	.dw _veranFinal_spiderOrBeeForm_state0
	.dw _veranFinal_beeForm_state1
	.dw _veranFinal_beeForm_state2
	.dw _veranFinal_beeForm_state3
	.dw _veranFinal_beeForm_state4
	.dw _veranFinal_beeForm_state5
	.dw _veranFinal_beeForm_state6
	.dw _veranFinal_beeForm_state7
	.dw _veranFinal_beeForm_state8
	.dw _veranFinal_beeForm_state9
	.dw _veranFinal_beeForm_stateA
	.dw _veranFinal_beeForm_stateB


_veranFinal_beeForm_state1:
	call enemyAnimate		; $5cf7
	ld e,Enemy.animParameter		; $5cfa
	ld a,(de)		; $5cfc
	inc a			; $5cfd
	ret nz			; $5cfe
	ld a,$07		; $5cff
	call enemySetAnimation		; $5d01
	call _ecom_incState		; $5d04
	ld l,Enemy.speed		; $5d07
	ld (hl),SPEED_200		; $5d09
	ld bc,$100c		; $5d0b
	ld e,ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE		; $5d0e
	ld l,Enemy.var32		; $5d10


;;
; @param	bc	collisionRadiusY/X
; @param	e	enemyCollisionMode
; @param	l	Pointer to health value
; @addr{5d12}
_veranFinal_initializeForm:
	ld h,d			; $5d12
	ld a,(hl)		; $5d13
	ld l,Enemy.health		; $5d14
	ld (hl),a		; $5d16

	ld l,Enemy.collisionType		; $5d17
	ld (hl),$80|ENEMYID_VERAN_FINAL_FORM
	inc l			; $5d1b
	ld (hl),e		; $5d1c

	ld l,Enemy.collisionRadiusY		; $5d1d
	ld (hl),b		; $5d1f
	inc l			; $5d20
	ld (hl),c		; $5d21

	ld l,Enemy.oamFlagsBackup		; $5d22
	ld a,$06		; $5d24
	ldi (hl),a		; $5d26
	ld (hl),a		; $5d27
	ret			; $5d28


_veranFinal_beeForm_state2:
	ld e,Enemy.yh		; $5d29
	ld a,(de)		; $5d2b
	ldh (<hFF8F),a	; $5d2c
	ld e,Enemy.xh		; $5d2e
	ld a,(de)		; $5d30
	ldh (<hFF8E),a	; $5d31
	ldbc LARGE_ROOM_HEIGHT<<3, LARGE_ROOM_WIDTH<<3		; $5d33
	sub c			; $5d36
	add $02			; $5d37
	cp $05			; $5d39
	jr nc,@updateMovement	; $5d3b
	ldh a,(<hFF8F)	; $5d3d
	sub b			; $5d3f
	add $02			; $5d40
	cp $05			; $5d42
	jr nc,@updateMovement	; $5d44

	; In middle of room
	call _ecom_incState		; $5d46
	jp _veranFinal_beeForm_chooseRandomTargetPosition		; $5d49

@updateMovement:
	call _ecom_moveTowardPosition		; $5d4c

_veranFinal_beeForm_animate:
	jp enemyAnimate		; $5d4f


_veranFinal_beeForm_state3:
	call _veranFinal_moveTowardTargetPosition		; $5d52
	jr nc,_veranFinal_beeForm_animate	; $5d55

	ld l,Enemy.yh		; $5d57
	ld (hl),b		; $5d59
	ld l,Enemy.xh		; $5d5a
	ld (hl),c		; $5d5c
	call _veranFinal_beeForm_nextTargetPosition		; $5d5d
	call _ecom_decCounter2		; $5d60
	jr nz,_veranFinal_beeForm_animate	; $5d63

	; Time to move off screen
	ld l,Enemy.state		; $5d65
	inc (hl)		; $5d67
	ld l,Enemy.counter1		; $5d68
	ld (hl),$01		; $5d6a
	ld l,Enemy.xh		; $5d6c
	bit 7,(hl)		; $5d6e
	ld a,$00		; $5d70
	jr nz,+			; $5d72
	ld a,$f0		; $5d74
+
	ld l,Enemy.var37		; $5d76
	ldd (hl),a		; $5d78
	ld (hl),$e0		; $5d79
	jr _veranFinal_beeForm_animate		; $5d7b


; Moving off screen
_veranFinal_beeForm_state4:
	call _ecom_decCounter1		; $5d7d
	jr nz,++		; $5d80

	ld (hl),$06 ; [counter1]
	ld l,Enemy.var36		; $5d84
	call _ecom_readPositionVars		; $5d86
	call objectGetRelativeAngleWithTempVars		; $5d89
	call objectNudgeAngleTowards		; $5d8c
++
	call objectApplySpeed		; $5d8f
	ld e,Enemy.yh		; $5d92
	ld a,(de)		; $5d94
	cp (LARGE_ROOM_HEIGHT+1)<<4			; $5d95
	jr c,_veranFinal_beeForm_animate	; $5d97

	; Off screen
	call _ecom_incState		; $5d99
	ld l,Enemy.counter1		; $5d9c
	ld (hl),30		; $5d9e
	jp objectSetInvisible		; $5da0


; About to re-emerge on screen
_veranFinal_beeForm_state5:
	call _ecom_decCounter1		; $5da3
	ret nz			; $5da6

	ld (hl),$0f ; [counter1]
	ld l,e			; $5da9
	inc (hl) ; [state]
	ld l,Enemy.yh		; $5dab
	ld (hl),$20		; $5dad

	call getRandomNumber		; $5daf
	and $10			; $5db2
	ldbc $08,$e8		; $5db4
	jr z,++			; $5db7
	ld b,c			; $5db9
	ld c,$08		; $5dba
++
	add $08			; $5dbc
	ld l,Enemy.angle		; $5dbe
	ld (hl),a		; $5dc0
	ld l,Enemy.xh		; $5dc1
	ld (hl),b		; $5dc3
	ld l,Enemy.var37		; $5dc4
	ld (hl),c		; $5dc6
	jp objectSetVisible83		; $5dc7


; Moving horizontally across screen while attacking
_veranFinal_beeForm_state6:
	call _ecom_decCounter1		; $5dca
	jr nz,++		; $5dcd
	ld (hl),$0f ; [counter1]
	ld b,PARTID_VERAN_BEE_PROJECTILE		; $5dd1
	call _ecom_spawnProjectile		; $5dd3
++
	call objectApplySpeed		; $5dd6
	ld e,Enemy.xh		; $5dd9
	ld a,(de)		; $5ddb
	ld h,d			; $5ddc
	ld l,Enemy.var37		; $5ddd
	sub (hl)		; $5ddf
	inc a			; $5de0
	cp $03			; $5de1
	jp nc,enemyAnimate		; $5de3

	; Reached other side
	call _ecom_incState		; $5de6
	ld l,Enemy.counter1		; $5de9
	ld (hl),60		; $5deb
	ld l,Enemy.collisionType		; $5ded
	res 7,(hl)		; $5def
	jp objectSetInvisible		; $5df1


; About to re-emerge from some corner of the screen
_veranFinal_beeForm_state7:
	call _ecom_decCounter1		; $5df4
	ret nz			; $5df7

	; Choose which corner to emerge from (not the current one)
	call _veranFinal_getQuadrant		; $5df8
--
	call getRandomNumber		; $5dfb
	ld c,a			; $5dfe
	and $03			; $5dff
	cp b			; $5e01
	jr z,--			; $5e02

	ld e,Enemy.var39		; $5e04
	ld (de),a		; $5e06
	add a			; $5e07
	ld hl,_veranFinal_beeForm_screenCornerEntrances		; $5e08
	rst_addDoubleIndex			; $5e0b
	ld e,Enemy.var36		; $5e0c
	ldi a,(hl)		; $5e0e
	ld (de),a		; $5e0f
	inc e			; $5e10
	ldi a,(hl)		; $5e11
	ld (de),a		; $5e12

	ld e,Enemy.yh		; $5e13
	ldi a,(hl)		; $5e15
	ld (de),a		; $5e16
	ld e,Enemy.xh		; $5e17
	ld a,(hl)		; $5e19
	ld (de),a		; $5e1a

	ld a,c			; $5e1b
	and $30			; $5e1c
	swap a			; $5e1e
	add $02			; $5e20
	ld e,Enemy.counter2		; $5e22
	ld (de),a		; $5e24

	call _ecom_incState		; $5e25
	ld l,Enemy.collisionType		; $5e28
	set 7,(hl)		; $5e2a
	jp objectSetVisible83		; $5e2c


_veranFinal_beeForm_state8:
	call _veranFinal_moveTowardTargetPosition		; $5e2f
	jr nc,_veranFinal_beeForm_animate2	; $5e32
	ld l,Enemy.yh		; $5e34
	ld (hl),b		; $5e36
	ld l,Enemy.xh		; $5e37
	ld (hl),c		; $5e39
	ld l,Enemy.state		; $5e3a
	inc (hl)		; $5e3c
	ld l,Enemy.counter1		; $5e3d
	ld (hl),30		; $5e3f
	jr _veranFinal_beeForm_animate2		; $5e41


_veranFinal_beeForm_state9:
	call _ecom_decCounter1		; $5e43
	jr nz,_veranFinal_beeForm_animate2	; $5e46
	ld (hl),25 ; [counter1]
	ld l,e			; $5e4a
	inc (hl) ; [state2]

_veranFinal_beeForm_animate2:
	jp enemyAnimate		; $5e4c


; Shooting out bees
_veranFinal_beeForm_stateA:
	call _ecom_decCounter1		; $5e4f
	jr z,_label_10_173	; $5e52

	ld a,(hl) ; [counter1]
	and $07			; $5e55
	jr nz,_veranFinal_beeForm_animate2	; $5e57

	; Spawn child bee
	ld a,(hl)		; $5e59
	and $18			; $5e5a
	swap a			; $5e5c
	rlca			; $5e5e
	dec a			; $5e5f
	ld b,a			; $5e60
	call getFreeEnemySlot		; $5e61
	jr nz,_veranFinal_beeForm_animate2	; $5e64

	ld (hl),ENEMYID_VERAN_CHILD_BEE		; $5e66
	inc l			; $5e68
	ld (hl),b ; [child.subid]
	call objectCopyPosition		; $5e6a
	ld a,SND_BEAM1		; $5e6d
	call playSound		; $5e6f
	jr _veranFinal_beeForm_animate2		; $5e72

_label_10_173:
	ld (hl),20 ; [counter1]
	inc l			; $5e76
	dec (hl) ; [counter2]
	ld l,e			; $5e78
	jr z,+			; $5e79
	inc (hl) ; [state] = $0b
	jr _veranFinal_beeForm_animate2		; $5e7c
+
	ld (hl),$02 ; [state] = $02
	jr _veranFinal_beeForm_animate2		; $5e80


_veranFinal_beeForm_stateB:
	call _ecom_decCounter1		; $5e82
	jr nz,_veranFinal_beeForm_animate2	; $5e85

	ld l,e			; $5e87
	ld (hl),$08 ; [state]

	call _veranFinal_getQuadrant		; $5e8a
@chooseQuadrant:
	call getRandomNumber		; $5e8d
	and $03			; $5e90
	cp b			; $5e92
	jr z,@chooseQuadrant	; $5e93
	ld h,d			; $5e95
	ld l,Enemy.var39		; $5e96
	cp (hl)			; $5e98
	jr z,@chooseQuadrant	; $5e99

	ld (hl),a ; [var39]
	add a			; $5e9c
	ld hl,_veranFinal_beeForm_screenCornerEntrances		; $5e9d
	rst_addDoubleIndex			; $5ea0
	ld e,Enemy.var36		; $5ea1
	ldi a,(hl)		; $5ea3
	ld (de),a		; $5ea4
	inc e			; $5ea5
	ld a,(hl)		; $5ea6
	ld (de),a		; $5ea7
	jr _veranFinal_beeForm_animate2		; $5ea8


_veranFinal_beeForm_screenCornerEntrances:
	.db $2c $3c $00 $00
	.db $2c $b4 $00 $f0
	.db $84 $3c $b0 $00
	.db $84 $b4 $b0 $f0


;;
; @param	hl	Enemy.state
; @addr{5eba}
_veranFinal_transformToBeeOrSpider:
	ld (hl),$01		; $5eba
	ld l,Enemy.collisionType		; $5ebc
	ld (hl),$80|ENEMYID_BEAMOS		; $5ebe

	ld l,Enemy.health		; $5ec0
	ld a,(hl)		; $5ec2
	ld l,Enemy.var30		; $5ec3
	ld (hl),a		; $5ec5

	ld l,Enemy.oamFlagsBackup		; $5ec6
	ld a,$07		; $5ec8
	ldi (hl),a		; $5eca
	ld (hl),a		; $5ecb

	call getRandomNumber_noPreserveVars		; $5ecc
	and $03			; $5ecf
	ld b,a			; $5ed1
	ld e,Enemy.var35		; $5ed2
	ld a,(de)		; $5ed4
	ld c,a			; $5ed5
	inc a			; $5ed6
	and $07			; $5ed7
	ld (de),a		; $5ed9

	ld a,c			; $5eda
	add a			; $5edb
	add a			; $5edc
	add b			; $5edd
	ld hl,@transformSequence		; $5ede
	call checkFlag		; $5ee1
	jr z,+			; $5ee4
	ld a,$01		; $5ee6
+
	inc a			; $5ee8
	ld e,Enemy.subid		; $5ee9
	ld (de),a		; $5eeb
	add $09			; $5eec
	call enemySetAnimation		; $5eee
	ld a,SND_TRANSFORM		; $5ef1
	jp playSound		; $5ef3

; Each 4 bits is a set of possible values (0=spider, 1=bee).
; [var35] determines which set of 4 bits is randomly chosen from.
; So, for instance, veran always turns into a spider in round 2 due to the 4 '0's?
@transformSequence:
	dbrev %11000000 %11111110 %11101100 %00001111


;;
; @param	b	Distance
; @param[out]	cflag	c if Link is within 'b' pixels of self
; @addr{5efa}
_veranFinal_spiderForm_checkLinkWithinDistance:
	ld a,b			; $5efa
	add a			; $5efb
	inc a			; $5efc
	ld c,a			; $5efd
	ld a,(w1Link.yh)		; $5efe
	ld h,d			; $5f01
	ld l,Enemy.yh		; $5f02
	sub (hl)		; $5f04
	add b			; $5f05
	cp c			; $5f06
	ret nc			; $5f07
	ld a,(w1Link.xh)		; $5f08
	ld l,Enemy.xh		; $5f0b
	sub (hl)		; $5f0d
	add b			; $5f0e
	cp c			; $5f0f
	ret			; $5f10


;;
; @param[out]	cflag	c if will do an attack (state changed to 4)
; @addr{5f11}
_veranFinal_spiderForm_decideWhetherToAttack:
	call objectGetAngleTowardLink		; $5f11
	ld e,a			; $5f14

@considerRushAttack:
	ld b,$60		; $5f15
	call _veranFinal_spiderForm_checkLinkWithinDistance		; $5f17
	jr nc,@considerJumpAttack	; $5f1a

	; BUG: is this supposed to 'ld a,e' first? This would check that Link is at a relatively
	; diagonal angle. Instead, this seems to compare their difference in x-positions modulo 8.
	and $07			; $5f1c
	sub $03			; $5f1e
	cp $03			; $5f20
	ld a,$00		; $5f22
	jr c,@doAttack	; $5f24

@considerJumpAttack:
	ld b,$50		; $5f26
	call _veranFinal_spiderForm_checkLinkWithinDistance		; $5f28
	jr c,@considerGrabAttack	; $5f2b

	; Check that Link is diagonal relative to the spider.
	; That shouldn't really matter for this attack, though...
	ld a,e			; $5f2d
	and $07			; $5f2e
	sub $03			; $5f30
	cp $03			; $5f32
	ccf			; $5f34
	ld a,$01		; $5f35
	jr c,@doAttack	; $5f37

@considerGrabAttack:
	; Check that Link is below the spider
	ld a,e			; $5f39
	sub $0c			; $5f3a
	cp $09			; $5f3c
	ret nc			; $5f3e

	; Grab attack
	ld a,$02		; $5f3f

@doAttack:
	ld e,Enemy.var03		; $5f41
	ld (de),a		; $5f43
	ld h,d			; $5f44
	ld l,Enemy.state		; $5f45
	ld (hl),$04		; $5f47
	inc l			; $5f49
	ld (hl),$00 ; [state2]
	scf			; $5f4c
	ret			; $5f4d


;;
; @addr{5f4e}
_veranFinal_dead:
	ld e,Enemy.subid		; $5f4e
	ld a,(de)		; $5f50
	or a			; $5f51
	jr nz,@transformed	; $5f52

	; Not transformed; dead for real
	ld h,d			; $5f54
	ld l,Enemy.state		; $5f55
	ld (hl),$0a		; $5f57
	inc l			; $5f59
	ld (hl),$00		; $5f5a
	ld l,Enemy.health		; $5f5c
	inc (hl)		; $5f5e
	ld a,SNDCTRL_STOPMUSIC		; $5f5f
	jp playSound		; $5f61

@transformed:
	ld b,a			; $5f64
	ld h,d			; $5f65
	ld l,e			; $5f66
	ld (hl),$00 ; [subid]
	ld l,Enemy.state		; $5f69
	ld (hl),$09		; $5f6b

	; Restore turtle health
	ld l,Enemy.var30		; $5f6d
	ld a,(hl)		; $5f6f
	ld l,Enemy.health		; $5f70
	ld (hl),a		; $5f72

	ld l,Enemy.collisionType		; $5f73
	ld (hl),$80|ENEMYID_BEAMOS		; $5f75

	ld l,Enemy.collisionRadiusY		; $5f77
	ld (hl),$08		; $5f79
	inc l			; $5f7b
	ld (hl),$0a ; [collisionRadiusX]

	ld l,Enemy.oamFlagsBackup		; $5f7e
	ld a,$07		; $5f80
	ldi (hl),a		; $5f82
	ld (hl),a		; $5f83

	ld a,b ; [subid]
	add $07			; $5f85
	call enemySetAnimation		; $5f87
	ld a,SND_TRANSFORM		; $5f8a
	jp playSound		; $5f8c


_veranFinal_spiderForm_decideAngle:
	ld b,$00		; $5f8f
	ld e,Enemy.yh		; $5f91
	ld a,(de)		; $5f93
	cp (LARGE_ROOM_HEIGHT<<4)/2
	jr c,+			; $5f96
	ld b,$10		; $5f98
+
	ld e,Enemy.xh		; $5f9a
	ld a,(de)		; $5f9c
	cp (LARGE_ROOM_WIDTH<<4)/2
	jr c,+			; $5f9f
	set 3,b			; $5fa1
+
	call getRandomNumber		; $5fa3
	and $07			; $5fa6
	add b			; $5fa8
	ld hl,@angles		; $5fa9
	rst_addAToHl			; $5fac
	ld e,Enemy.angle		; $5fad
	ld a,(hl)		; $5faf
	ld (de),a		; $5fb0
	ret			; $5fb1

@angles:
	.db $04 $04 $0c $0c $0c $14 $14 $1c
	.db $04 $0c $0c $14 $14 $14 $1c $1c
	.db $04 $04 $04 $0c $0c $14 $1c $1c
	.db $04 $04 $0c $14 $14 $1c $1c $1c

;;
; @addr{5fd2}
_veranFinal_beeForm_chooseRandomTargetPosition:
	ld bc,$0801		; $5fd2
	call _ecom_randomBitwiseAndBCE		; $5fd5
	ld e,Enemy.counter1		; $5fd8
	ld a,b			; $5fda
	ld (de),a		; $5fdb

	ld a,c			; $5fdc
	ld hl,_veranFinal_beeForm_counter2Vals		; $5fdd
	rst_addAToHl			; $5fe0
	ld e,Enemy.counter2		; $5fe1
	ld a,(hl)		; $5fe3
	ld (de),a		; $5fe4

;;
; @addr{5fe5}
_veranFinal_beeForm_nextTargetPosition:
	ld e,Enemy.counter1		; $5fe5
	ld a,(de)		; $5fe7
	ld b,a			; $5fe8
	inc a			; $5fe9
	and $0f			; $5fea
	ld (de),a		; $5fec
	ld a,b			; $5fed
	ld hl,_veranFinal_beeForm_targetPositions		; $5fee
	rst_addDoubleIndex			; $5ff1
	ld e,Enemy.var36		; $5ff2
	ldi a,(hl)		; $5ff4
	ld (de),a		; $5ff5
	inc e			; $5ff6
	ld a,(hl)		; $5ff7
	ld (de),a ; [var37]
	ret			; $5ff9

_veranFinal_beeForm_counter2Vals:
	.db $14 $24

_veranFinal_beeForm_targetPositions:
	.db $38 $80
	.db $20 $90
	.db $20 $b8
	.db $38 $c8
	.db $78 $c8
	.db $90 $b8
	.db $90 $90
	.db $78 $80
	.db $38 $70
	.db $20 $60
	.db $20 $38
	.db $38 $28
	.db $78 $28
	.db $90 $38
	.db $90 $60
	.db $78 $70


;;
; @addr{601c}
_veranFinal_moveTowardTargetPosition:
	ld h,d			; $601c
	ld l,Enemy.var36		; $601d
	call _ecom_readPositionVars		; $601f
	sub c			; $6022
	add $02			; $6023
	cp $05			; $6025
	jr nc,++		; $6027
	ldh a,(<hFF8F)	; $6029
	sub b			; $602b
	add $02			; $602c
	cp $05			; $602e
	ret c			; $6030
++
	call _ecom_moveTowardPosition		; $6031
	or d			; $6034
	ret			; $6035

;;
; @param[out]	b	Value from 0-3 corresponding to screen quadrant
; @addr{6036}
_veranFinal_getQuadrant:
	ld b,$00		; $6036
	ldh a,(<hEnemyTargetY)	; $6038
	cp LARGE_ROOM_HEIGHT*16/2			; $603a
	jr c,+			; $603c
	ld b,$02		; $603e
+
	ldh a,(<hEnemyTargetX)	; $6040
	cp LARGE_ROOM_WIDTH*16/2			; $6042
	ret c			; $6044
	inc b			; $6045
	ret			; $6046


; ==============================================================================
; ENEMYID_RAMROCK_ARMS
;
; Variables:
;   subid: ?
;   relatedObj1: ENEMYID_RAMROCK
;   var30: ?
;   var32: Shields (subid 4): x-position relative to ramrock
;   var35: Number of times he's been hit in current phase
;   var36: ?
;   var37: ?
;   var38: Used by bomb phase?
; ==============================================================================
enemyCode05:
	ld e,Enemy.state		; $6047
	ld a,(de)		; $6049
	rst_jumpTable			; $604a
	.dw _ramrockArm_state0
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state_stub
	.dw _ramrockArm_state8

_ramrockArm_state0:
	ld e,Enemy.subid		; $605d
	ld a,(de)		; $605f
	and $7f			; $6060
	rst_jumpTable			; $6062
	.dw @initSubid0
	.dw @initSubid0
	.dw @initSubid2
	.dw @initSubid2
	.dw @initSubid4
	.dw @initSubid4

@initSubid0:
	ld a,(de)		; $606f
	ld b,a			; $6070

	ld hl,_ramrockArm_subid0And1XPositions		; $6071
	rst_addAToHl			; $6074
	ld a,(hl)		; $6075
	ld h,d			; $6076
	ld l,Enemy.xh		; $6077
	ld (hl),a		; $6079
	ld l,Enemy.yh		; $607a
	ld (hl),$10		; $607c
	ld l,Enemy.zh		; $607e
	ld (hl),$f9		; $6080

	ld l,Enemy.angle		; $6082
	ld (hl),ANGLE_DOWN		; $6084
	ld l,Enemy.counter1		; $6086
	ld (hl),$08		; $6088
	ld a,$00		; $608a
	add b			; $608c
	call enemySetAnimation		; $608d
	ld a,SPEED_180		; $6090

@commonInit:
	call _ecom_setSpeedAndState8		; $6092
	jp objectSetVisiblec0		; $6095

@initSubid2:
	ld a,(de)		; $6098
	add $02 ; [subid]
	call enemySetAnimation		; $609b
	call _ramrockArm_setRelativePosition		; $609e
	ld l,Enemy.zh		; $60a1
	ld (hl),$81		; $60a3
	jr @commonInit		; $60a5

@initSubid4:
	ld a,(de)		; $60a7
	sub $04			; $60a8
	ld b,a			; $60aa
	ld hl,_ramrockArm_subid4And5Angles		; $60ab
	rst_addAToHl			; $60ae
	ld c,(hl)		; $60af

	ld a,b			; $60b0
	ld hl,_ramrockArm_subid4And5XPositions		; $60b1
	rst_addAToHl			; $60b4
	ld a,(hl)		; $60b5
	ld h,d			; $60b6
	ld l,Enemy.xh		; $60b7
	ldd (hl),a		; $60b9
	dec l			; $60ba
	ld (hl),$4e ; [yh]

	ld l,Enemy.angle		; $60bd
	ld (hl),c		; $60bf
	ld l,Enemy.zh		; $60c0
	ld (hl),$81		; $60c2

	ld l,Enemy.var32		; $60c4
	ld (hl),$04		; $60c6

	ld a,(de) ; [subid]
	add $02			; $60c9
	call enemySetAnimation		; $60cb
	jr @commonInit		; $60ce


_ramrockArm_state_stub:
	ret			; $60d0


_ramrockArm_state8:
	ld e,Enemy.subid		; $60d1
	ld a,(de)		; $60d3
	and $7f			; $60d4
	rst_jumpTable			; $60d6
	.dw _ramrockArm_subid0
	.dw _ramrockArm_subid0
	.dw _ramrockArm_subid2
	.dw _ramrockArm_subid2
	.dw _ramrockArm_subid4
	.dw _ramrockArm_subid4


; "Shields" in first phase
_ramrockArm_subid0:
	ld a,Object.subid		; $60e3
	call objectGetRelatedObject1Var		; $60e5
	ld a,(hl)		; $60e8
	cp $04			; $60e9
	jr nz,@runStates	; $60eb

	ld e,Enemy.var31		; $60ed
	ld a,(de)		; $60ef
	or a			; $60f0
	jr nz,@runStates	; $60f1

	inc a			; $60f3
	ld (de),a		; $60f4
	ld e,Enemy.state2		; $60f5
	ld a,$06		; $60f7
	ld (de),a		; $60f9
	ld a,60		; $60fa
	ld e,Enemy.counter1		; $60fc
	ld (de),a		; $60fe

@runStates:
	ld e,Enemy.state2		; $60ff
	ld a,(de)		; $6101
	rst_jumpTable			; $6102
	.dw _ramrockArm_subid0_substate0
	.dw _ramrockArm_subid0_substate1
	.dw _ramrockArm_subid0_substate2
	.dw _ramrockArm_subid0_substate3
	.dw _ramrockArm_subid0_substate4
	.dw _ramrockArm_subid0_substate5
	.dw _ramrockArm_subid0_substate6


_ramrockArm_subid0_substate0:
	call enemyAnimate		; $6111
	call objectApplySpeed		; $6114
	call _ecom_decCounter1		; $6117
	ret nz			; $611a

	ld (hl),$08 ; [counter1]
	ld e,Enemy.subid		; $611d
	ld a,(de)		; $611f
	or a			; $6120
	jr nz,+			; $6121
	dec a			; $6123
+
	ld l,Enemy.angle		; $6124
	add (hl)		; $6126
	and $1f			; $6127
	ld (hl),a		; $6129
	and $0f			; $612a
	cp $08			; $612c
	ret nz			; $612e

	; Angle is now directly left or right
	ld l,Enemy.state2		; $612f
	inc (hl)		; $6131
	ld l,Enemy.subid		; $6132
	ld b,(hl)		; $6134
	ld l,Enemy.relatedObj1+1		; $6135
	ld h,(hl)		; $6137
	ld l,Enemy.subid		; $6138
	inc (hl)		; $613a
	ld a,$02		; $613b
	add b			; $613d
	jp enemySetAnimation		; $613e


_ramrockArm_subid0_substate1:
	call enemyAnimate		; $6141
	call _ramrockArm_setRelativePosition		; $6144
	ld l,Enemy.relatedObj1+1		; $6147
	ld h,(hl)		; $6149
	ld l,Enemy.subid		; $614a
	ld a,$03		; $614c
	cp (hl)			; $614e
	ret nz			; $614f
	jr _ramrockArm_subid0_moveBackToRamrock		; $6150


_ramrockArm_subid0_substate2:
	call enemyAnimate		; $6152
	call _ramrockArm_setRelativePosition		; $6155
	call _ecom_decCounter2		; $6158
	ret nz			; $615b

	ld b,$04		; $615c
	call objectCheckCenteredWithLink		; $615e
	ret nc			; $6161
	call objectGetAngleTowardLink		; $6162
	cp $10			; $6165
	ret nz			; $6167

	call _ecom_incState2		; $6168
	ld l,Enemy.angle		; $616b
	ld (hl),a		; $616d
	ld l,Enemy.counter1		; $616e
	ld (hl),$06		; $6170
	ld l,Enemy.var30		; $6172
	ld (hl),$00		; $6174
	ld l,Enemy.speed		; $6176
	ld (hl),SPEED_100		; $6178
	ld l,Enemy.subid		; $617a
	ld a,$00		; $617c
	add (hl)		; $617e
	call enemySetAnimation		; $617f
	ld a,SND_BIGSWORD		; $6182
	jp playSound		; $6184


_ramrockArm_subid0_substate3:
	call objectApplySpeed		; $6187
	ld e,Enemy.var2a		; $618a
	ld a,(de)		; $618c
	cp $80|ITEMCOLLISION_LINK
	jr z,_ramrockArm_subid0_moveBackToRamrock	; $618f
	cp $80|ITEMCOLLISION_L1_SWORD
	jr z,@sword	; $6193
	cp $80|ITEMCOLLISION_L2_SWORD
	jr z,@sword	; $6197
	cp $80|ITEMCOLLISION_L3_SWORD
	jr nz,@moveTowardLink	; $619b

@sword:
	ld e,Enemy.state2		; $619d
	ld a,$05		; $619f
	ld (de),a		; $61a1

	ld a,SPEED_200		; $61a2
	ld e,Enemy.speed		; $61a4
	ld (de),a		; $61a6
	ld e,Enemy.angle		; $61a7
	ld a,(de)		; $61a9
	xor $10			; $61aa
	ld (de),a		; $61ac
	ret			; $61ad

@moveTowardLink:
	call _ecom_getSideviewAdjacentWallsBitset		; $61ae
	jr nz,_ramrockArm_subid0_moveBackToRamrock	; $61b1
	call _ecom_decCounter1		; $61b3
	ret nz			; $61b6
	ld (hl),$06		; $61b7
	call objectGetAngleTowardLink		; $61b9
	jp objectNudgeAngleTowards		; $61bc


_ramrockArm_subid0_moveBackToRamrock:
	ld e,Enemy.state2		; $61bf
	ld a,$04		; $61c1
	ld (de),a		; $61c3
	ld e,Enemy.speed		; $61c4
	ld a,SPEED_180		; $61c6
	ld (de),a		; $61c8

_ramrockArm_subid0_setAngleTowardRamrock:
	call _ramrockArm_getRelativePosition		; $61c9
	call objectGetRelativeAngle		; $61cc
	ld e,Enemy.angle		; $61cf
	ld (de),a		; $61d1
	ret			; $61d2


; Moving back towards Ramrock
_ramrockArm_subid0_substate4:
	call objectApplySpeed		; $61d3
	call _ramrockArm_subid0_setAngleTowardRamrock		; $61d6
	call _ramrockArm_subid0_checkReachedRamrock		; $61d9
	ret nz			; $61dc
	ld a,SND_BOMB_LAND		; $61dd
	call playSound		; $61df
	ld e,Enemy.state2		; $61e2
	ld a,$02		; $61e4
	ld (de),a		; $61e6
	ld e,Enemy.counter2		; $61e7
	ld a,60		; $61e9
	ld (de),a		; $61eb
	ld e,Enemy.subid		; $61ec
	ld a,(de)		; $61ee
	add $02			; $61ef
	jp enemySetAnimation		; $61f1


; Being knocked back after hit by sword
_ramrockArm_subid0_substate5:
	call enemyAnimate		; $61f4
	ld e,Enemy.var30		; $61f7
	ld a,(de)		; $61f9
	or a			; $61fa
	jr nz,@noDamage	; $61fb
	ld a,Object.start		; $61fd
	call objectGetRelatedObject1Var		; $61ff
	call checkObjectsCollided		; $6202
	jr nc,@noDamage	; $6205

	ld e,Enemy.var30		; $6207
	ld a,$01		; $6209
	ld (de),a		; $620b

	ld l,Enemy.invincibilityCounter		; $620c
	ld a,(hl)		; $620e
	or a			; $620f
	jr nz,@noDamage	; $6210

	ld (hl),60		; $6212
	ld l,Enemy.var35		; $6214
	inc (hl)		; $6216
	ld a,SND_BOSS_DAMAGE		; $6217
	call playSound		; $6219

@noDamage:
	xor a			; $621c
	call _ecom_getSideviewAdjacentWallsBitset		; $621d
	jp z,objectApplySpeed		; $6220

	ld e,Enemy.animParameter		; $6223
	ld a,(de)		; $6225
	or a			; $6226
	ret z			; $6227
	jr _ramrockArm_subid0_moveBackToRamrock		; $6228


_ramrockArm_subid0_substate6:
	ld e,Enemy.subid		; $622a
	ld a,(de)		; $622c
	add $04			; $622d
	ld b,a			; $622f
	ld a,Object.subid		; $6230
	call objectGetRelatedObject1Var		; $6232
	ld a,(hl)		; $6235
	cp b			; $6236
	ret nz			; $6237
	call _ecom_decCounter1		; $6238
	ret nz			; $623b

	call objectCreatePuff		; $623c
	ld a,Object.subid		; $623f
	call objectGetRelatedObject1Var		; $6241
	inc (hl)		; $6244
	jp _ramrockArm_deleteSelf		; $6245


; Bomb grabber hands
_ramrockArm_subid2:
	ld e,Enemy.state2		; $6248
	ld a,(de)		; $624a
	rst_jumpTable			; $624b
	.dw _ramrockArm_subid2_substate0
	.dw _ramrockArm_subid2_substate1
	.dw _ramrockArm_subid2_substate2

_ramrockArm_subid2_substate0:
	ld c,$10		; $6252
	call objectUpdateSpeedZ_paramC		; $6254
	ret nz			; $6257

	ld a,Object.subid		; $6258
	call objectGetRelatedObject1Var		; $625a
	ld (hl),$07		; $625d

	ld a,SND_SCENT_SEED		; $625f
	call playSound		; $6261
	jp _ecom_incState2		; $6264

_ramrockArm_subid2_substate1:
	ld a,Object.subid		; $6267
	call objectGetRelatedObject1Var		; $6269
	ld a,(hl)		; $626c
	cp $08			; $626d
	ret nz			; $626f

	ld h,d			; $6270
	ld a,(hl)		; $6271
	rrca			; $6272
	jr c,_ramrockArm_deleteSelf	; $6273

	ld l,Enemy.visible		; $6275
	res 7,(hl)		; $6277
	jp _ecom_incState2		; $6279

_ramrockArm_subid2_substate2:
	call _ramrockArm_subid2_copyRamrockPosition		; $627c
	ld l,Enemy.collisionType		; $627f
	res 7,(hl)		; $6281

	ld a,Object.subid		; $6283
	call objectGetRelatedObject1Var		; $6285
	ld a,(hl)		; $6288
	cp $0a			; $6289
	jr z,@relatedSubid0a	; $628b
	cp $09			; $628d
	ret nz			; $628f

@relatedSubid09:
	ld h,d			; $6290
	ld l,Enemy.collisionType		; $6291
	set 7,(hl)		; $6293

	ld c,ITEMID_BOMB		; $6295
	call findItemWithID		; $6297
	ret nz			; $629a

	ld l,Item.yh		; $629b
	ld b,(hl)		; $629d
	ld l,Item.xh		; $629e
	ld c,(hl)		; $62a0
	push hl			; $62a1
	ld e,$06		; $62a2
	call _ramrockArm_checkPositionAtRamrock		; $62a4
	pop hl			; $62a7
	ret nz			; $62a8

	ld l,Item.zh		; $62a9
	ld a,(hl)		; $62ab
	or a			; $62ac
	jr z,++			; $62ad
	cp $fc			; $62af
	ret c			; $62b1
++
	; Bomb is close enough
	ld l,Item.var2f		; $62b2
	set 4,(hl) ; Delete bomb

	ld a,Object.invincibilityCounter		; $62b6
	call objectGetRelatedObject1Var		; $62b8
	ld a,(hl)		; $62bb
	or a			; $62bc
	ret nz			; $62bd
	ld (hl),60		; $62be
	ld l,Enemy.var35		; $62c0
	inc (hl)		; $62c2
	ret			; $62c3

; Time to die
@relatedSubid0a:
	ld e,Enemy.subid		; $62c4
	ld a,$01		; $62c6
	ld (de),a		; $62c8
@nextPuff:
	call getFreeInteractionSlot		; $62c9
	ld (hl),INTERACID_PUFF		; $62cc
	push hl			; $62ce
	call _ramrockArm_setRelativePosition		; $62cf
	pop hl			; $62d2
	call objectCopyPosition		; $62d3
	ld e,Enemy.subid		; $62d6
	ld a,(de)		; $62d8
	dec a			; $62d9
	ld (de),a		; $62da
	jr z,@nextPuff	; $62db

	ld a,$02		; $62dd
	ld (de),a ; [this.subid]

_ramrockArm_deleteSelf:
	call decNumEnemies		; $62e0
	jp enemyDelete		; $62e3


; Shield hands
_ramrockArm_subid4:
	ld e,Enemy.state2		; $62e6
	ld a,(de)		; $62e8
	rst_jumpTable			; $62e9
	.dw _ramrockArm_subid4_substate0
	.dw _ramrockArm_subid4_substate1
	.dw _ramrockArm_subid4_substate2
	.dw _ramrockArm_subid4_substate3


_ramrockArm_subid4_substate0:
	ld c,$10		; $62f2
	call objectUpdateSpeedZ_paramC		; $62f4
	ret nz			; $62f7
	ld a,$06		; $62f8
	call objectSetCollideRadius		; $62fa
	ld bc,-$80		; $62fd
	call objectSetSpeedZ		; $6300
	ld l,Enemy.speed		; $6303
	ld (hl),SPEED_100		; $6305
	ld l,Enemy.counter2		; $6307
	ld (hl),62		; $6309
	jp _ecom_incState2		; $630b


_ramrockArm_subid4_substate1:
	ld e,Enemy.zh		; $630e
	ld a,(de)		; $6310
	cp $f9			; $6311
	ld c,$00		; $6313
	jp nz,objectUpdateSpeedZ_paramC		; $6315
	call _ecom_decCounter2		; $6318
	jp nz,objectApplySpeed		; $631b

	call _ecom_incState2		; $631e
	ld e,Enemy.subid		; $6321
	ld a,(de)		; $6323
	rrca			; $6324
	ret nc			; $6325

	ld a,Object.subid		; $6326
	call objectGetRelatedObject1Var		; $6328
	ld (hl),$0c		; $632b

	ld a,PALH_84		; $632d
	jp loadPaletteHeader		; $632f


_ramrockArm_subid4_substate2:
	ld a,Object.state2		; $6332
	call objectGetRelatedObject1Var		; $6334
	ld a,(hl)		; $6337
	dec a			; $6338
	jr z,@updateXPosition	; $6339

	ld e,Enemy.var2a		; $633b
	ld a,(de)		; $633d
	rlca			; $633e
	jr c,_ramrockArm_subid4_collisionOccurred	; $633f

	ld a,$02		; $6341
	call objectGetRelatedObject1Var		; $6343
	ld a,(hl)		; $6346
	cp $0d			; $6347
	jr z,_ramrockArm_subid4_collisionOccurred	; $6349

	cp $10			; $634b
	jr nz,@updateXPosition	; $634d

	call objectCreatePuff		; $634f
	jr _ramrockArm_deleteSelf		; $6352

@updateXPosition:
	ld e,Enemy.var32		; $6354
	ld a,(de)		; $6356
	ld b,a			; $6357
	cp $0c			; $6358
	jr z,_ramrockArm_subid4_updateXPosition			; $635a
	inc a			; $635c
	ld (de),a		; $635d
	ld b,a			; $635e

; @param	b	X-offset
_ramrockArm_subid4_updateXPosition:
	ld e,Enemy.subid		; $635f
	ld a,(de)		; $6361
	rrca			; $6362
	jr c,++			; $6363
	ld a,b			; $6365
	cpl			; $6366
	inc a			; $6367
	ld b,a			; $6368
++
	ld a,Object.xh		; $6369
	call objectGetRelatedObject1Var		; $636b
	ld a,(hl)		; $636e
	add b			; $636f
	ld e,l			; $6370
	ld (de),a		; $6371
	ret			; $6372

_ramrockArm_subid4_collisionOccurred:
	ld a,Object.subid		; $6373
	call objectGetRelatedObject1Var		; $6375
	ld (hl),Object.xh		; $6378
	ld l,Enemy.var36		; $637a
	ld (hl),$10		; $637c
	jp _ecom_incState2		; $637e


_ramrockArm_subid4_substate3:
	ld e,Enemy.var2a		; $6381
	ld a,(de)		; $6383
	rlca			; $6384
	jr nc,++		; $6385

	ld a,Object.var36		; $6387
	call objectGetRelatedObject1Var		; $6389
	ld (hl),$10		; $638c
++
	ld e,Enemy.var32		; $638e
	ld a,(de)		; $6390
	sub $02			; $6391
	cp $04			; $6393
	jr nc,+			; $6395
	ld b,$04		; $6397
	jr ++			; $6399
+
	ld (de),a		; $639b
	ld b,a			; $639c
	jr _ramrockArm_subid4_updateXPosition		; $639d
++
	ld a,Object.subid		; $639f
	call objectGetRelatedObject1Var		; $63a1
	ld a,(hl)		; $63a4
	cp $0d			; $63a5
	jr z,_ramrockArm_subid4_updateXPosition	; $63a7

	ld e,Enemy.state2		; $63a9
	ld a,$02		; $63ab
	ld (de),a		; $63ad
	jr _ramrockArm_subid4_updateXPosition		; $63ae


;;
; @addr{63b0}
_ramrockArm_setRelativePosition:
	call _ramrockArm_getRelativePosition		; $63b0
	ld h,d			; $63b3
	ld l,Enemy.yh		; $63b4
	ld (hl),b		; $63b6
	ld l,Enemy.xh		; $63b7
	ld (hl),c		; $63b9
	ret			; $63ba

;;
; @param[out]	zflag
; @addr{63bb}
_ramrockArm_subid0_checkReachedRamrock:
	call _ramrockArm_getRelativePosition		; $63bb
	ld e,$02		; $63be

;;
; @param	bc	Position
; @param	e
; @addr{63c0}
_ramrockArm_checkPositionAtRamrock:
	ld h,d			; $63c0
	ld l,Enemy.yh		; $63c1
	ld a,e			; $63c3
	add b			; $63c4
	cp (hl)			; $63c5
	jr c,_label_10_212	; $63c6
	sub e			; $63c8
_label_10_211:
	sub e			; $63c9
	cp (hl)			; $63ca
	jr nc,_label_10_212	; $63cb
	ld l,Enemy.xh		; $63cd
	ld a,e			; $63cf
	add c			; $63d0
	cp (hl)			; $63d1
	jr c,_label_10_212	; $63d2
	sub e			; $63d4
	sub e			; $63d5
	cp (hl)			; $63d6
	jr nc,_label_10_212	; $63d7
	xor a			; $63d9
	ret			; $63da
_label_10_212:
	or d			; $63db
	ret			; $63dc

;;
; @param[out]	bc	Relative position
; @addr{63dd}
_ramrockArm_getRelativePosition:
	ld e,Enemy.subid		; $63dd
	ld a,(de)		; $63df
	ld c,$0e		; $63e0
	rrca			; $63e2
	jr nc,+			; $63e3
	ld c,-$0e		; $63e5
+
	ld a,Object.yh		; $63e7
	call objectGetRelatedObject1Var		; $63e9
	ldi a,(hl)		; $63ec
	add $08			; $63ed
	ld b,a			; $63ef
	inc l			; $63f0
	ld a,(hl) ; [object.xh]
	add c			; $63f2
	ld c,a			; $63f3
	ret			; $63f4

;;
; @addr{63f5}
_ramrockArm_subid2_copyRamrockPosition:
	ld a,Object.yh		; $63f5
	call objectGetRelatedObject1Var		; $63f7
	ldi a,(hl)		; $63fa
	add $08			; $63fb
	ld b,a			; $63fd
	inc l			; $63fe
	ld a,(hl)		; $63ff
	ld h,d			; $6400
	ld l,Enemy.xh		; $6401
	ldd (hl),a		; $6403
	dec l			; $6404
	ld (hl),b		; $6405
	ret			; $6406

_ramrockArm_subid0And1XPositions:
	.db $30 $c0

_ramrockArm_subid4And5XPositions:
	.db $37 $b9

_ramrockArm_subid4And5Angles:
	.db $08 $18


; ==============================================================================
; ENEMYID_VERAN_FAIRY
;
; Variables:
;   var03: Attack index
;   var30: Movement pattern index (0-3)
;   var31/var32: Pointer to movement pattern
;   var33/var34: Target position to move to
;   var35: Number from 0-2 based on health (lower means more health)
;   var36: ?
;   var38: Timer to stay still after doing a movement pattern
; ==============================================================================
enemyCode06:
	jr z,@normalStatus	; $640d
	sub ENEMYSTATUS_NO_HEALTH			; $640f
	ret c			; $6411
	jr nz,@justHit	; $6412

	; No health
	ld e,Enemy.invincibilityCounter		; $6414
	ld a,(de)		; $6416
	ret nz			; $6417
	call checkLinkCollisionsEnabled		; $6418
	ret nc			; $641b

	ld a,DISABLE_LINK		; $641c
	ld (wDisabledObjects),a		; $641e
	ld (wMenuDisabled),a		; $6421
	ld h,d			; $6424
	ld l,Enemy.health		; $6425
	inc (hl)		; $6427
	ld l,Enemy.state		; $6428
	ld (hl),$05		; $642a
	inc l			; $642c
	ld (hl),$00 ; [state2]
	ld l,Enemy.counter1		; $642f
	ld (hl),60		; $6431
	jr @normalStatus		; $6433

@justHit:
	call _veranFairy_updateVar35BasedOnHealth		; $6435
	ld hl,_veranFairy_speedTable		; $6438
	rst_addAToHl			; $643b
	ld e,Enemy.speed		; $643c
	ld a,(hl)		; $643e
	ld (de),a		; $643f

@normalStatus:
	ld e,Enemy.state		; $6440
	ld a,(de)		; $6442
	rst_jumpTable			; $6443
	.dw _veranFairy_state0
	.dw _veranFairy_state1
	.dw _veranFairy_state2
	.dw _veranFairy_state3
	.dw _veranFairy_state4
	.dw _veranFairy_state5

_veranFairy_state0:
	ld a,ENEMYID_VERAN_FAIRY		; $6450
	ld (wEnemyIDToLoadExtraGfx),a		; $6452
	call _ecom_incState		; $6455
	ld l,Enemy.counter1		; $6458
	ld (hl),60		; $645a
	ld l,Enemy.speed		; $645c
	ld (hl),SPEED_140		; $645e
	ld l,Enemy.var30		; $6460
	dec (hl)		; $6462
	ld a,$02		; $6463
	call enemySetAnimation		; $6465
	jp objectSetVisible82		; $6468

; Cutscene just prior to fairy form
_veranFairy_state1:
	inc e			; $646b
	ld a,(de)		; $646c
	rst_jumpTable			; $646d
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA
	.dw @substateB
	.dw @substateC

@substate0:
	call _ecom_decCounter1		; $6488
	jp nz,_ecom_flickerVisibility		; $648b
	ld (hl),$08		; $648e
	ld l,e			; $6490
	inc (hl) ; [state2]
	jp objectSetVisible83		; $6492

@substate1:
	call _ecom_decCounter1		; $6495
	ret nz			; $6498
	ld l,e			; $6499
	inc (hl) ; [state2]
	ld bc,TX_560f		; $649b
	jp showText		; $649e

@substate2:
	call _ecom_incState2		; $64a1
	ld l,Enemy.counter1		; $64a4
	ld (hl),30		; $64a6
	ld a,$04		; $64a8
	jp enemySetAnimation		; $64aa

@substate3:
	ld c,$33		; $64ad

@strikeLightningAfterCountdown:
	call _ecom_decCounter1		; $64af
	ret nz			; $64b2
	ld (hl),10 ; [counter1]
	ld l,e			; $64b5
	inc (hl) ; [state2]

@strikeLightning:
	call getFreePartSlot		; $64b7
	ret nz			; $64ba
	ld (hl),PARTID_LIGHTNING		; $64bb
	ld l,Part.yh		; $64bd
	jp setShortPosition_paramC		; $64bf

@substate4:
	ld c,$7b		; $64c2
	jr @strikeLightningAfterCountdown		; $64c4

@substate5:
	ld c,$55		; $64c6
	jr @strikeLightningAfterCountdown		; $64c8

@substate6:
	ld c,$3b		; $64ca
	jr @strikeLightningAfterCountdown		; $64cc

@substate7:
	ld c,$73		; $64ce
	jr @strikeLightningAfterCountdown		; $64d0

@substate8:
	call _ecom_decCounter1		; $64d2
	ret nz			; $64d5
	ld l,e			; $64d6
	inc (hl) ; [state2]
	ld c,$59		; $64d8
	call @strikeLightning		; $64da
	jp fadeoutToWhite		; $64dd

; Remove pillar tiles
@substate9:
	ld b,$0c		; $64e0
	ld hl,@pillarPositions		; $64e2
@loop
	push bc			; $64e5
	ldi a,(hl)		; $64e6
	ld c,a			; $64e7
	ld a,$a5		; $64e8
	push hl			; $64ea
	call setTile		; $64eb
	pop hl			; $64ee
	pop bc			; $64ef
	dec b			; $64f0
	jr nz,@loop	; $64f1
	jp _ecom_incState2		; $64f3

@pillarPositions:
	.db $23 $33 $63 $73 $45 $55 $49 $59
	.db $2b $3b $6b $7b

; Spawn mimics
@substateA:
	ld b,$04		; $6502
	ld hl,@mimicPositions		; $6504

@nextMimic:
	ldi a,(hl)		; $6507
	ld c,a			; $6508
	push hl			; $6509
	call getFreeEnemySlot		; $650a
	jr nz,++		; $650d
	ld (hl),ENEMYID_LINK_MIMIC		; $650f
	ld l,Enemy.yh		; $6511
	call setShortPosition_paramC		; $6513
++
	pop hl			; $6516
	dec b			; $6517
	jr nz,@nextMimic	; $6518

	call _ecom_incState2		; $651a
	ld l,Enemy.counter1		; $651d
	ld (hl),30		; $651f

	ld l,Enemy.oamFlagsBackup		; $6521
	xor a			; $6523
	ldi (hl),a		; $6524
	ld (hl),a		; $6525

	ld l,Enemy.zh		; $6526
	dec (hl)		; $6528
	call objectSetVisible83		; $6529
	ld a,$05		; $652c
	call enemySetAnimation		; $652e
	ld a,$04		; $6531
	jp fadeinFromWhiteWithDelay		; $6533

@mimicPositions:
	.db $33 $73 $3b $7b

@substateB:
	ld a,(wPaletteThread_mode)		; $653a
	or a			; $653d
	ret nz			; $653e
	call _ecom_decCounter1		; $653f
	ret nz			; $6542
	ld l,e			; $6543
	inc (hl)		; $6544
	ld bc,TX_5610		; $6545
	jp showText		; $6548

@substateC:
	ld h,d			; $654b
	ld l,Enemy.state		; $654c
	inc (hl)		; $654e
	ld l,Enemy.counter2		; $654f
	ld (hl),120		; $6551
	jp _enemyBoss_beginBoss		; $6553


; Choosing a movement pattern and attack
_veranFairy_state2:
	call getRandomNumber_noPreserveVars		; $6556
	and $07			; $6559
	ld b,a			; $655b
	ld e,Enemy.var35		; $655c
	ld a,(de)		; $655e
	swap a			; $655f
	rrca			; $6561
	add b			; $6562
	ld hl,_veranFairy_attackTable		; $6563
	rst_addAToHl			; $6566
	ld e,Enemy.var03		; $6567
	ld a,(hl)		; $6569
	ld (de),a		; $656a

	call _ecom_incState		; $656b
	ld l,Enemy.var38		; $656e
	ld (hl),60		; $6570
	ld l,Enemy.var36		; $6572
	ld (hl),$00		; $6574
--
	call getRandomNumber		; $6576
	and $03			; $6579
	ld l,Enemy.var30		; $657b
	cp (hl)			; $657d
	jr z,--			; $657e
	ld (hl),a		; $6580

	ld hl,_veranFairy_movementPatternTable		; $6581
	rst_addDoubleIndex			; $6584
	ldi a,(hl)		; $6585
	ld h,(hl)		; $6586
	ld l,a			; $6587
	ld e,Enemy.var33		; $6588
	ldi a,(hl)		; $658a
	ld (de),a		; $658b
	inc e			; $658c
	ldi a,(hl) ; [var34]
	ld (de),a		; $658e

_veranFairy_saveMovementPatternPointer:
	ld e,Enemy.var31		; $658f
	ld a,l			; $6591
	ld (de),a		; $6592
	inc e			; $6593
	ld a,h			; $6594
	ld (de),a		; $6595
	ret			; $6596


; Moving and attacking
_veranFairy_state3:
	call _veranFairy_66ed		; $6597

	ld h,d			; $659a
	ld l,Enemy.var33		; $659b
	call _ecom_readPositionVars		; $659d
	sub c			; $65a0
	add $02			; $65a1
	cp $05			; $65a3
	jr nc,@updateMovement	; $65a5
	ldh a,(<hFF8F)	; $65a7
	sub b			; $65a9
	add $02			; $65aa
	cp $05			; $65ac
	jr nc,@updateMovement	; $65ae

	; Reached target position
	ld l,Enemy.yh		; $65b0
	ld (hl),b		; $65b2
	ld l,Enemy.xh		; $65b3
	ld (hl),c		; $65b5
	call _veranFairy_checkLoopAroundScreen		; $65b6

	; Get next target position
	ld h,d			; $65b9
	ld l,Enemy.var31		; $65ba
	ldi a,(hl)		; $65bc
	ld h,(hl)		; $65bd
	ld l,a			; $65be
	ldi a,(hl)		; $65bf
	or a			; $65c0
	jr nz,++			; $65c1
	ld a,$05		; $65c3
	call enemySetAnimation		; $65c5
	jp _ecom_incState		; $65c8
++
	ld e,Enemy.var33		; $65cb
	ld (de),a		; $65cd
	ld b,a			; $65ce
	inc e			; $65cf
	ldi a,(hl)		; $65d0
	ld (de),a ; [var34]
	ld c,a			; $65d2
	call _veranFairy_saveMovementPatternPointer		; $65d3
@updateMovement:
	call _ecom_moveTowardPosition		; $65d6
_veranFairy_animate:
	jp enemyAnimate		; $65d9


_veranFairy_state4:
	ld h,d			; $65dc
	ld l,Enemy.var38		; $65dd
	dec (hl)		; $65df
	jr nz,_veranFairy_animate	; $65e0
	ld l,e			; $65e2
	ld (hl),$02 ; [state]
	jr _veranFairy_animate		; $65e5


; Dead
_veranFairy_state5:
	inc e			; $65e7
	ld a,(de)		; $65e8
	rst_jumpTable			; $65e9
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call _ecom_decCounter1		; $65f0
	jp nz,_ecom_flickerVisibility		; $65f3
	ld l,e			; $65f6
	inc (hl)		; $65f7
	jp objectSetVisible82		; $65f8

@substate1:
	call _ecom_incState2		; $65fb
	ld l,Enemy.counter2		; $65fe
	ld (hl),65		; $6600
	ld bc,TX_5612		; $6602
	jp showText		; $6605

@substate2:
	call _ecom_decCounter2		; $6608
	jr z,@triggerCutscene	; $660b

	ld a,(hl) ; [counter2]
	and $0f			; $660e
	ret nz			; $6610
	ld a,(hl) ; [counter2]
	and $f0			; $6612
	swap a			; $6614
	dec a			; $6616
	push af			; $6617
	dec a			; $6618
	call z,fadeoutToWhite		; $6619
	pop af			; $661c
	ld hl,@explosionPositions		; $661d
	rst_addDoubleIndex			; $6620
	ldi a,(hl)		; $6621
	ld c,(hl)		; $6622
	ld b,a			; $6623
	call getFreeInteractionSlot		; $6624
	ret nz			; $6627
	ld (hl),INTERACID_EXPLOSION		; $6628
	ld l,Interaction.var03		; $662a
	inc (hl) ; [explosion.var03] = $01
	jp objectCopyPositionWithOffset		; $662d

@triggerCutscene:
	ld a,(wPaletteThread_mode)		; $6630
	or a			; $6633
	ret nz			; $6634
	call clearAllParentItems		; $6635
	call dropLinkHeldItem		; $6638
	ld a,CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT		; $663b
	ld (wCutsceneTrigger),a		; $663d
	jp enemyDelete		; $6640

@explosionPositions:
	.db $f0 $f0
	.db $10 $08
	.db $f8 $04
	.db $08 $f8


; BUG(?): $00 acts as a terminator, but it's also used as a position value, meaning one movement
; pattern stops early? (Doesn't apply if $00 is in the first row.)
_veranFairy_movementPatternTable:
	.dw @pattern0
	.dw @pattern1
	.dw @pattern2
	.dw @pattern3

@pattern0:
	.db $00 $78
	.db $00 $f7 ; Terminates early here?
	.db $c0 $e0
	.db $58 $78
	.db $00
@pattern1:
	.db $00 $f7
	.db $58 $78
	.db $58 $f7
	.db $c0 $f7
	.db $58 $78
	.db $00
@pattern2:
	.db $58 $f7
	.db $30 $f7
	.db $c0 $38
	.db $c0 $b8
	.db $58 $78
	.db $00
@pattern3:
	.db $00 $f7
	.db $c0 $f7
	.db $10 $f7
	.db $90 $f7
	.db $58 $78
	.db $00


_veranFairy_attackTable:
	.db $00 $00 $00 $00 $00 $00 $01 $01 ; High health
	.db $00 $00 $00 $00 $00 $01 $01 $02 ; Mid health
	.db $00 $00 $01 $01 $01 $02 $02 $02 ; Low health


_veranFairy_speedTable:
	.db SPEED_140, SPEED_1c0, SPEED_200

;;
; @addr{6698}
_veranFairy_checkLoopAroundScreen:
	call objectGetShortPosition		; $6698
	ld e,a			; $669b
	ld hl,@data1		; $669c
	call lookupKey		; $669f
	ret nc			; $66a2

	ld hl,@data2		; $66a3
	rst_addAToHl			; $66a6
	ld e,Enemy.yh		; $66a7
	ldi a,(hl)		; $66a9
	ld (de),a		; $66aa
	ldh (<hFF8F),a	; $66ab
	ld e,Enemy.xh		; $66ad
	ld a,(hl)		; $66af
	ld (de),a		; $66b0
	ldh (<hFF8E),a	; $66b1
	ret			; $66b3

@data1:
	.db $07 $00
	.db $0f $02
	.db $1f $04
	.db $3f $06
	.db $5f $08
	.db $9f $0a
	.db $c3 $0c
	.db $cb $0a
	.db $ce $0e
	.db $cf $00
	.db $00

@data2:
	.db $c0 $00
	.db $00 $00
	.db $90 $00
	.db $00 $38
	.db $30 $00
	.db $58 $00
	.db $00 $b8
	.db $c0 $78

;;
; @param[out]	a	Value written to var35
; @addr{66d9}
_veranFairy_updateVar35BasedOnHealth:
	ld b,$00		; $66d9
	ld e,Enemy.health		; $66db
	ld a,(de)		; $66dd
	cp 20			; $66de
	jr nc,++		; $66e0
	inc b			; $66e2
	cp 10			; $66e3
	jr nc,++		; $66e5
	inc b			; $66e7
++
	ld e,Enemy.var35		; $66e8
	ld a,b			; $66ea
	ld (de),a		; $66eb
	ret			; $66ec

;;
; @addr{66ed}
_veranFairy_66ed:
	call _ecom_decCounter2		; $66ed
	ret nz			; $66f0
	ld e,Enemy.var03		; $66f1
	ld a,(de)		; $66f3
	rst_jumpTable			; $66f4
	.dw attack0
	.dw attack1
	.dw attack2

; Shooting occasional projectiles
attack0:
	ld e,Enemy.var36		; $66fb
	ld a,(de)		; $66fd
	or a			; $66fe
	jr nz,@label_10_227	; $66ff

	call getRandomNumber_noPreserveVars		; $6701
	and $0f			; $6704
	ld b,a			; $6706
	ld h,d			; $6707
	ld l,Enemy.var35		; $6708
	ld a,(hl)		; $670a
	add a			; $670b
	add $08			; $670c
	cp b			; $670e
	ld l,Enemy.counter2		; $670f
	ld (hl),60		; $6711
	ret nc			; $6713

	xor a			; $6714
	ldd (hl),a		; $6715
	inc a			; $6716
	ld (hl),a		; $6717
	ld l,Enemy.var36		; $6718
	ld (hl),a		; $671a
	ld l,Enemy.var37		; $671b
	ld (hl),$04		; $671d

@label_10_227:
	call _ecom_decCounter1		; $671f
	jr z,@label_10_228	; $6722
	ld a,(hl)		; $6724
	cp $0e			; $6725
	ret nz			; $6727
	ld a,$05		; $6728
	jp enemySetAnimation		; $672a

@label_10_228:
	call _veranFairy_checkWithinBoundary		; $672d
	ret nc			; $6730
	ld l,Enemy.var37		; $6731
	dec (hl)		; $6733
	jr z,@label_10_229	; $6734

	ld l,Enemy.counter1		; $6736
	ld (hl),30		; $6738

	ld b,PARTID_VERAN_FAIRY_PROJECTILE		; $673a
	call _ecom_spawnProjectile		; $673c
	ld a,$06		; $673f
	jp enemySetAnimation		; $6741

@label_10_229:
	ld l,Enemy.counter2		; $6744
	ld (hl),90		; $6746
	ld l,Enemy.var36		; $6748
	ld (hl),$00		; $674a
	ret			; $674c

; Circular projectile attack
attack1:
	ld e,Enemy.var36		; $674d
	ld a,(de)		; $674f
	or a			; $6750
	jr nz,@label_10_230	; $6751

	call _veranFairy_checkWithinBoundary		; $6753
	ret nc			; $6756

	call getRandomNumber_noPreserveVars		; $6757
	and $0f			; $675a
	ld b,a			; $675c
	ld h,d			; $675d
	ld l,Enemy.var35		; $675e
	ld a,(hl)		; $6760
	add a			; $6761
	add $06			; $6762
	cp b			; $6764
	ld l,Enemy.counter2		; $6765
	ld (hl),90		; $6767
	ret nc			; $6769

	ld (hl),$00 ; [counter2]
	dec l			; $676c
	ld (hl),180 ; [counter1]
	ld l,Enemy.var36		; $676f
	ld (hl),$01		; $6771

	ld b,PARTID_VERAN_PROJECTILE		; $6773
	call _ecom_spawnProjectile		; $6775
	ld a,$06		; $6778
	call enemySetAnimation		; $677a

@label_10_230:
	pop hl			; $677d
	call _ecom_decCounter1		; $677e
	jp nz,enemyAnimate		; $6781

	inc l			; $6784
	ld (hl),120 ; [counter2]
	ld l,Enemy.var36		; $6787
	ld (hl),$00		; $6789
	ld a,$05		; $678b
	jp enemySetAnimation		; $678d

; Baby ball attack
attack2:
	ld h,d			; $6790
	ld l,Enemy.var36		; $6791
	bit 0,(hl)		; $6793
	jr nz,@label_10_231	; $6795

	call _veranFairy_checkWithinBoundary		; $6797
	ret nc			; $679a

	ld (hl),$01		; $679b
	ld l,Enemy.counter1		; $679d
	ld (hl),30		; $679f
	ld b,PARTID_BABY_BALL		; $67a1
	call _ecom_spawnProjectile		; $67a3
	ld a,$06		; $67a6
	call enemySetAnimation		; $67a8

@label_10_231:
	pop hl			; $67ab
	call _ecom_decCounter1		; $67ac
	jp nz,enemyAnimate		; $67af

	inc l			; $67b2
	ld (hl),$f0		; $67b3
	ld l,Enemy.var36		; $67b5
	ld (hl),$00		; $67b7
	ld a,$05		; $67b9
	jp enemySetAnimation		; $67bb

;;
; @param[out]	cflag	nc if veran is outside the room boundary
; @addr{67be}
_veranFairy_checkWithinBoundary:
	ld e,Enemy.yh		; $67be
	ld a,(de)		; $67c0
	sub $10			; $67c1
	cp $90			; $67c3
	ret nc			; $67c5
	ld e,Enemy.xh		; $67c6
	ld a,(de)		; $67c8
	sub $10			; $67c9
	cp $d0			; $67cb
	ret			; $67cd


; ==============================================================================
; ENEMYID_RAMROCK
;
; Variables:
;   var30: Set to $01 by hands when they collide with ramrock
;   var35: Incremented by hands when hit by bomb?
;   var36: Written to by shield hands?
; ==============================================================================
enemyCode07:
	ld e,Enemy.state		; $67ce
	ld a,(de)		; $67d0
	rst_jumpTable			; $67d1
	.dw _ramrock_state0
	.dw _ramrock_state_stub
	.dw _ramrock_state_stub
	.dw _ramrock_state_stub
	.dw _ramrock_state_stub
	.dw _ramrock_state_stub
	.dw _ramrock_state_stub
	.dw _ramrock_state_stub
	.dw _ramrock_state8
	.dw _ramrock_swordPhase
	.dw _ramrock_bombPhase
	.dw _ramrock_seedPhase
	.dw _ramrock_glovePhase


_ramrock_state0:
	ld a,ENEMYID_RAMROCK		; $67ec
	ld b,PALH_83		; $67ee
	call _enemyBoss_initializeRoom		; $67f0
	ld a,SPEED_100		; $67f3
	call _ecom_setSpeedAndState8		; $67f5
	ld a,$04		; $67f8
	call enemySetAnimation		; $67fa
	ld b,$00		; $67fd
	ld c,$0c		; $67ff
	call _enemyBoss_spawnShadow		; $6801
	jp objectSetVisible81		; $6804


_ramrock_state_stub:
	ret			; $6807


; Cutscene before fight
_ramrock_state8:
	inc e			; $6808
	ld a,(de)		; $6809
	rst_jumpTable			; $680a
	.dw _ramrock_state8_substate0
	.dw _ramrock_state8_substate1
	.dw _ramrock_state8_substate2
	.dw _ramrock_state8_substate3
	.dw _ramrock_state8_substate4
	.dw _ramrock_state8_substate5

_ramrock_state8_substate0:
	ld a,DISABLE_LINK		; $6817
	ld (wDisabledObjects),a		; $6819
	ld (wMenuDisabled),a		; $681c
	ld a,($cc93)		; $681f
	or a			; $6822
	ret nz			; $6823

	ld e,Enemy.stunCounter		; $6824
	ld a,60		; $6826
	ld (de),a		; $6828
	jp _ecom_incState2		; $6829

_ramrock_state8_substate1:
	ld e,Enemy.stunCounter		; $682c
	ld a,(de)		; $682e
	or a			; $682f
	ret nz			; $6830

	ld bc,-$80		; $6831
	call objectSetSpeedZ		; $6834
	ld c,$00		; $6837
	call objectUpdateSpeedZ_paramC		; $6839
	ld e,Enemy.zh		; $683c
	ld a,(de)		; $683e
	cp $f9			; $683f
	ret nz			; $6841

	ld c,$01		; $6842
@spawnArm:
	ld b,ENEMYID_RAMROCK_ARMS		; $6844
	call _ecom_spawnEnemyWithSubid01		; $6846
	ld l,Enemy.subid		; $6849
	ld (hl),c		; $684b
	ld l,Enemy.relatedObj1		; $684c
	ld (hl),Enemy.start		; $684e
	inc l			; $6850
	ld (hl),d		; $6851
	dec c			; $6852
	jr z,@spawnArm	; $6853

	jp _ecom_incState2		; $6855

_ramrock_state8_substate2:
	ld e,Enemy.subid		; $6858
	ld a,(de)		; $685a
	cp $02			; $685b
	ret nz			; $685d
	ld e,Enemy.counter1		; $685e
	ld a,$02		; $6860
	ld (de),a		; $6862
	call _ecom_incState2		; $6863
	ld a,PALH_84		; $6866
	jp loadPaletteHeader		; $6868

_ramrock_state8_substate3:
	call _ecom_decCounter1		; $686b
	ret nz			; $686e
	call _ecom_incState2		; $686f
	ld a,SND_SWORD_OBTAINED		; $6872
	call playSound		; $6874
	ld l,Enemy.subid		; $6877
	inc (hl)		; $6879
	ld a,PALH_83		; $687a
	jp loadPaletteHeader		; $687c

_ramrock_state8_substate4:
	call enemyAnimate		; $687f
	ld e,Enemy.animParameter		; $6882
	ld a,(de)		; $6884
	or a			; $6885
	ret z			; $6886
	call _ecom_incState2		; $6887
	ld l,Enemy.angle		; $688a
	ld (hl),$00		; $688c
	ld a,$00		; $688e
	call enemySetAnimation		; $6890

_ramrock_state8_substate5:
	call enemyAnimate		; $6893
	call objectApplySpeed		; $6896
	ld e,Enemy.yh		; $6899
	ld a,(de)		; $689b
	cp $41			; $689c
	ret nc			; $689e

	; Fight begins
	xor a			; $689f
	ld (wDisabledObjects),a		; $68a0
	ld (wMenuDisabled),a		; $68a3
	call _ecom_incState		; $68a6
	ld l,$89		; $68a9
	ld (hl),$08		; $68ab
	ld l,$82		; $68ad
	ld (hl),$03		; $68af
	ld a,MUS_BOSS		; $68b1
	jp playSound		; $68b3


; "Fist" phase
_ramrock_swordPhase:
	call enemyAnimate		; $68b6
	ld e,Enemy.var35		; $68b9
	ld a,(de)		; $68bb
	cp $03			; $68bc
	jr nc,+			; $68be
	jp _ramrock_updateHorizontalMovement		; $68c0
+
	xor a			; $68c3
	ld (de),a		; $68c4
	ld bc,$0000		; $68c5
	call objectSetSpeedZ		; $68c8
	call _ecom_incState		; $68cb
	inc l			; $68ce
	ld (hl),$00		; $68cf
	ld l,Enemy.subid		; $68d1
	inc (hl)		; $68d3
	ld l,Enemy.counter2		; $68d4
	ld (hl),30		; $68d6
	ld a,$04		; $68d8
	jp enemySetAnimation		; $68da


; "Bomb" phase
_ramrock_bombPhase:
	call @func_68fe		; $68dd

	; Stop movement of any bombs that touch ramrock
	ld c,ITEMID_BOMB		; $68e0
	call findItemWithID		; $68e2
	ret nz			; $68e5
	call checkObjectsCollided		; $68e6
	jr nc,++		; $68e9
	ld l,Item.angle		; $68eb
	ld (hl),$ff		; $68ed
++
	ld c,ITEMID_BOMB		; $68ef
	call findItemWithID_startingAfterH		; $68f1
	ret nz			; $68f4
	call checkObjectsCollided		; $68f5
	ret nc			; $68f8
	ld l,Item.angle		; $68f9
	ld (hl),$ff		; $68fb
	ret			; $68fd

@func_68fe:
	inc e			; $68fe
	ld a,(de)		; $68ff
	rst_jumpTable			; $6900
	.dw _ramrock_bombPhase_substate0
	.dw _ramrock_bombPhase_substate1
	.dw _ramrock_bombPhase_substate2
	.dw _ramrock_bombPhase_substate3
	.dw _ramrock_bombPhase_substate4

_ramrock_bombPhase_substate0:
	ld c,$10		; $690b
	call objectUpdateSpeedZ_paramC		; $690d
	ld e,Enemy.subid		; $6910
	ld a,(de)		; $6912
	cp $06			; $6913
	ret nz			; $6915
	call _ecom_decCounter2		; $6916
	ret nz			; $6919

	; Spawn arms
	ld b,ENEMYID_RAMROCK_ARMS		; $691a
	call _ecom_spawnEnemyWithSubid01		; $691c
	ld l,Enemy.subid		; $691f
	ld (hl),$02		; $6921
	ld l,Enemy.relatedObj1		; $6923
	ld (hl),Enemy.start		; $6925
	inc l			; $6927
	ld (hl),d		; $6928

	ld b,ENEMYID_RAMROCK_ARMS		; $6929
	call _ecom_spawnEnemyWithSubid01		; $692b
	ld l,Enemy.subid		; $692e
	ld (hl),$03		; $6930
	ld l,Enemy.relatedObj1		; $6932
	ld (hl),Enemy.start		; $6934
	inc l			; $6936
	ld (hl),d		; $6937

	jp _ecom_incState2		; $6938

_ramrock_bombPhase_substate1:
	ld e,Enemy.subid		; $693b
	ld a,(de)		; $693d
	cp $07			; $693e
	ret nz			; $6940

	call enemyAnimate		; $6941
	ld e,Enemy.animParameter		; $6944
	ld a,(de)		; $6946
	or a			; $6947
	ret z			; $6948
	ld bc,-$80		; $6949
	call objectSetSpeedZ		; $694c
	ld l,Enemy.subid		; $694f
	ld (hl),$08		; $6951
	ld a,$01		; $6953
	call enemySetAnimation		; $6955
	jp _ecom_incState2		; $6958

_ramrock_bombPhase_substate2:
	ld c,$00		; $695b
	call objectUpdateSpeedZ_paramC		; $695d
	ld e,Enemy.zh		; $6960
	ld a,(de)		; $6962
	cp $f9			; $6963
	ret nz			; $6965

	ld a,SND_SWORD_OBTAINED		; $6966
	call playSound		; $6968

_ramrock_bombPhase_gotoSubstate3:
	ld h,d			; $696b
	ld l,Enemy.counter1		; $696c
	ld a,$04		; $696e
	ldi (hl),a		; $6970
	ld (hl),50 ; [counter2]
	ld l,Enemy.state2		; $6973
	ld (hl),$03		; $6975
	ret			; $6977

_ramrock_bombPhase_substate3:
	ld e,Enemy.var38		; $6978
	ld a,(de)		; $697a
	sub $01			; $697b
	ld (de),a		; $697d
	jr nc,++		; $697e
	ld a,30			; $6980
	ld (de),a		; $6982
	ld a,SND_BEAM1		; $6983
	call playSound		; $6985
++
	ld e,Enemy.var35		; $6988
	ld a,(de)		; $698a
	cp $03			; $698b
	jr nc,_label_10_237	; $698d

	call enemyAnimate		; $698f
	call _ecom_applyVelocityForSideviewEnemy		; $6992
	call _ecom_decCounter2		; $6995
	jr z,_label_10_236	; $6998

	call _ecom_decCounter1		; $699a
	ret nz			; $699d

	ld (hl),$04		; $699e
	call objectGetAngleTowardLink		; $69a0
	jp objectNudgeAngleTowards		; $69a3

_label_10_236:
	call _ecom_incState2		; $69a6
	ld a,$02		; $69a9
	jp enemySetAnimation		; $69ab

_label_10_237:
	call _ecom_incState		; $69ae
	inc l			; $69b1
	xor a			; $69b2
	ld (hl),a		; $69b3
	ld l,Enemy.var35		; $69b4
	ld (hl),a		; $69b6
	ld l,Enemy.subid		; $69b7
	ld (hl),$0a		; $69b9
	ld a,$04		; $69bb
	jp enemySetAnimation		; $69bd

_ramrock_bombPhase_substate4:
	call enemyAnimate		; $69c0
	ld h,d			; $69c3
	ld l,Enemy.subid		; $69c4
	ld (hl),$08		; $69c6
	ld e,Enemy.animParameter		; $69c8
	ld a,(de)		; $69ca
	cp $01			; $69cb
	jr nz,++		; $69cd
	ld l,Enemy.subid		; $69cf
	ld (hl),$09		; $69d1
	ld a,SND_STRONG_POUND		; $69d3
	jp playSound		; $69d5
++
	rla			; $69d8
	ret nc			; $69d9
	ld a,$01		; $69da
	call enemySetAnimation		; $69dc
	jp _ramrock_bombPhase_gotoSubstate3		; $69df


; "Seed" phase
_ramrock_seedPhase:
	ld h,d			; $69e2
	ld l,Enemy.state2		; $69e3
	ld a,(hl)		; $69e5
	or a			; $69e6
	jr z,@runSubstate	; $69e7
	dec a			; $69e9
	jr z,@runSubstate	; $69ea

	ld e,Enemy.var2a		; $69ec
	ld a,(de)		; $69ee
	cp $80|ITEMCOLLISION_MYSTERY_SEED			; $69ef
	jr c,@noSeedCollision	; $69f1
	cp $80|ITEMCOLLISION_GALE_SEED+1			; $69f3
	jr c,@seedCollision	; $69f5

@noSeedCollision:
	rlca			; $69f7
	jr nc,@noCollision	; $69f8

@otherCollision:
	ld l,Enemy.subid		; $69fa
	ld (hl),$0d		; $69fc
	ld l,Enemy.var36		; $69fe
	ld (hl),$10		; $6a00
	jr @runSubstate		; $6a02

@seedCollision:
	ld l,Enemy.invincibilityCounter		; $6a04
	ld a,(hl)		; $6a06
	or a			; $6a07
	jr nz,@otherCollision	; $6a08

	ld (hl),60 ; [invincibilityCounter]
	ld l,Enemy.var35		; $6a0c
	ld a,(hl)		; $6a0e
	cp $03			; $6a0f
	jr z,@seedPhaseEnd	; $6a11

	inc (hl)		; $6a13
	ld a,SND_BOSS_DAMAGE		; $6a14
	call playSound		; $6a16
	jr @runSubstate		; $6a19

@noCollision:
	ld l,Enemy.var36		; $6a1b
	ld a,(hl)		; $6a1d
	or a			; $6a1e
	jr z,@runSubstate	; $6a1f
	dec (hl)		; $6a21
	jr nz,@runSubstate	; $6a22

	ld l,Enemy.subid		; $6a24
	ld (hl),$0c		; $6a26

@runSubstate:
	ld e,Enemy.state2		; $6a28
	ld a,(de)		; $6a2a
	rst_jumpTable			; $6a2b
	.dw _ramrock_seedPhase_substate0
	.dw _ramrock_seedPhase_substate1
	.dw _ramrock_seedPhase_substate2
	.dw _ramrock_seedPhase_substate3
	.dw _ramrock_seedPhase_substate4
	.dw _ramrock_seedPhase_substate5
	.dw _ramrock_seedPhase_substate6

@seedPhaseEnd:
	ld l,Enemy.subid		; $6a3a
	ld (hl),$10		; $6a3c
	call _ecom_incState		; $6a3e
	inc l			; $6a41
	xor a			; $6a42
	ld (hl),a		; $6a43
	ld l,Enemy.var35		; $6a44
	ld (hl),a		; $6a46
	ret			; $6a47

_ramrock_seedPhase_substate0:
	ld h,d			; $6a48
	ld bc,$4878		; $6a49
	ld l,Enemy.yh		; $6a4c
	ldi a,(hl)		; $6a4e
	cp b			; $6a4f
	jr nz,@updateMovement	; $6a50

	inc l			; $6a52
	ld a,(hl)		; $6a53
	cp c			; $6a54
	jr nz,@updateMovement	; $6a55

	ld l,Enemy.subid		; $6a57
	inc (hl)		; $6a59
	ld l,Enemy.counter2		; $6a5a
	ld (hl),$02		; $6a5c

	ld c,$04		; $6a5e
@spawnArm:
	ld b,ENEMYID_RAMROCK_ARMS		; $6a60
	call _ecom_spawnEnemyWithSubid01		; $6a62
	ld l,Enemy.subid		; $6a65
	ld (hl),c		; $6a67
	ld l,Enemy.relatedObj1		; $6a68
	ld (hl),Enemy.start		; $6a6a
	inc l			; $6a6c
	ld (hl),d		; $6a6d
	inc c			; $6a6e
	ld a,c			; $6a6f
	cp $05			; $6a70
	jr z,@spawnArm	; $6a72

	jp _ecom_incState2		; $6a74

@updateMovement:
	call objectGetRelativeAngle		; $6a77
	ld e,Enemy.angle		; $6a7a
	ld (de),a		; $6a7c
	jp objectApplySpeed		; $6a7d

_ramrock_seedPhase_substate1:
	ld e,Enemy.subid		; $6a80
	ld a,(de)		; $6a82
	cp $0c			; $6a83
	ret nz			; $6a85

	ld e,Enemy.counter2		; $6a86
	ld a,(de)		; $6a88
	or a			; $6a89
	jr nz,_label_10_248	; $6a8a

	call enemyAnimate		; $6a8c
	ld e,Enemy.animParameter		; $6a8f
	ld a,(de)		; $6a91
	or a			; $6a92
	ret z			; $6a93

_ramrock_seedPhase_6a94:
	ld e,Enemy.subid		; $6a94
	ld a,$0c		; $6a96
	ld (de),a		; $6a98

_ramrock_seedPhase_resumeNormalMovement:
	ld h,d			; $6a99
	ld l,Enemy.state2		; $6a9a
	ld (hl),$02		; $6a9c
	ld l,Enemy.counter2		; $6a9e
	ld (hl),120		; $6aa0
	ld a,$00		; $6aa2
	jp enemySetAnimation		; $6aa4

_label_10_248:
	call _ecom_decCounter2		; $6aa7
	ret nz			; $6aaa
	ld l,Enemy.angle		; $6aab
	ld (hl),$08		; $6aad
	ld a,PALH_83		; $6aaf
	call loadPaletteHeader		; $6ab1
	ld a,SND_SWORD_OBTAINED		; $6ab4
	jp playSound		; $6ab6

; Moving normally
_ramrock_seedPhase_substate2:
	call enemyAnimate		; $6ab9
	call _ramrock_updateHorizontalMovement		; $6abc

	call getRandomNumber		; $6abf
	rrca			; $6ac2
	ret nc			; $6ac3
	call _ecom_decCounter2		; $6ac4
	ret nz			; $6ac7

	ld e,Enemy.subid		; $6ac8
	ld a,(de)		; $6aca
	cp $0c			; $6acb
	ret nz			; $6acd

	call getRandomNumber		; $6ace
	and $03			; $6ad1
	ld l,e			; $6ad3
	jr z,@gotoNextSubstate	; $6ad4

	ld (hl),$0f ; [counter2]
	ld l,Enemy.state2		; $6ad8
	ld (hl),$06		; $6ada
	ld l,Enemy.counter1		; $6adc
	ld (hl),60		; $6ade

	ld b,PARTID_RAMROCK_SEED_FORM_ORB		; $6ae0
	call _ecom_spawnProjectile		; $6ae2
	ld bc,$1000		; $6ae5
	call objectCopyPositionWithOffset		; $6ae8
	jr @setAnimation0		; $6aeb

@gotoNextSubstate:
	ld (hl),$0e		; $6aed
	ld l,Enemy.angle		; $6aef
	ld (hl),$18		; $6af1
	call _ecom_incState2		; $6af3

@setAnimation0:
	ld a,$00		; $6af6
	jp enemySetAnimation		; $6af8

_ramrock_seedPhase_substate3:
	ld e,Enemy.subid		; $6afb
	ld a,(de)		; $6afd
	cp $0e			; $6afe
	jr nz,_ramrock_seedPhase_resumeNormalMovement	; $6b00
	call _ramrock_updateHorizontalMovement		; $6b02
	ret nz			; $6b05

	call _ecom_incState2		; $6b06
	ld l,Enemy.counter1		; $6b09
	ld (hl),180		; $6b0b
	inc l			; $6b0d
	ld (hl),30 ; [counter2]

	ld b,PARTID_RAMROCK_SEED_FORM_LASER		; $6b10
	call _ecom_spawnProjectile		; $6b12
	ld l,Part.subid		; $6b15
	ld (hl),$0e		; $6b17
	ld bc,$0400		; $6b19
	jp objectCopyPositionWithOffset		; $6b1c

; Firing energy beam
_ramrock_seedPhase_substate4:
	ld e,Enemy.subid		; $6b1f
	ld a,(de)		; $6b21
	cp $0e			; $6b22
	jp nz,_ramrock_seedPhase_resumeNormalMovement		; $6b24

	call _ecom_decCounter2		; $6b27
	ret nz			; $6b2a
	call _ecom_decCounter1		; $6b2b
	jr z,@gotoNextSubstate	; $6b2e

	ld a,(hl)		; $6b30
	and $07			; $6b31
	ld a,SND_SWORDBEAM		; $6b33
	call z,playSound		; $6b35
	jp _ramrock_updateHorizontalMovement		; $6b38

@gotoNextSubstate:
	call _ecom_incState2		; $6b3b
	ld l,Enemy.counter1		; $6b3e
	ld (hl),90		; $6b40
	ld l,Enemy.subid		; $6b42
	ld (hl),$0c		; $6b44

_ramrock_seedPhase_substate5:
	call _ecom_decCounter1		; $6b46
	ret nz			; $6b49
	jp _ramrock_seedPhase_resumeNormalMovement		; $6b4a

_ramrock_seedPhase_substate6:
	ld e,Enemy.subid		; $6b4d
	ld a,(de)		; $6b4f
	cp $0f			; $6b50
	jr nz,++		; $6b52
	call _ecom_decCounter1		; $6b54
	ret nz			; $6b57
++
	jp _ramrock_seedPhase_6a94		; $6b58


; "Bomb" phase
_ramrock_glovePhase:
	inc e			; $6b5b
	ld a,(de)		; $6b5c
	rst_jumpTable			; $6b5d
	.dw _ramrock_glovePhase_substate0
	.dw _ramrock_glovePhase_substate1
	.dw _ramrock_glovePhase_substate2
	.dw _ramrock_glovePhase_substate3
	.dw _ramrock_glovePhase_substate4

_ramrock_glovePhase_substate0:
	ld h,d			; $6b68
	ld bc,$4878		; $6b69
	ld l,Enemy.yh		; $6b6c
	ldi a,(hl)		; $6b6e
	cp b			; $6b6f
	jr nz,@updateMovement	; $6b70

	inc l			; $6b72
	ld a,(hl)		; $6b73
	cp c			; $6b74
	jr nz,@updateMovement	; $6b75
	call _ecom_incState2		; $6b77

	ld bc,$e001		; $6b7a
@spawnArm:
	push bc			; $6b7d
	ld b,PARTID_RAMROCK_GLOVE_FORM_ARM		; $6b7e
	call _ecom_spawnProjectile		; $6b80
	ld l,Part.subid		; $6b83
	ld (hl),c		; $6b85
	pop bc			; $6b86
	push bc			; $6b87
	ld c,b			; $6b88
	ld b,$18		; $6b89
	call objectCopyPositionWithOffset		; $6b8b
	pop bc			; $6b8e
	dec c			; $6b8f
	ld a,$04		; $6b90
	jp nz,enemySetAnimation		; $6b92
	ld a,b			; $6b95
	cpl			; $6b96
	inc a			; $6b97
	ld b,a			; $6b98
	jr @spawnArm		; $6b99

@updateMovement:
	call objectGetRelativeAngle		; $6b9b
	ld e,Enemy.angle		; $6b9e
	ld (de),a		; $6ba0
	jp objectApplySpeed		; $6ba1

_ramrock_glovePhase_substate1:
	ld c,$10		; $6ba4
	call objectUpdateSpeedZ_paramC		; $6ba6
	ld e,Enemy.var37		; $6ba9
	ld a,(de)		; $6bab
	cp $03			; $6bac
	ret nz			; $6bae
	call _ecom_incState2		; $6baf
	ld l,Enemy.counter2		; $6bb2
	ld (hl),$02		; $6bb4
	ld a,PALH_84		; $6bb6
	jp loadPaletteHeader		; $6bb8

_ramrock_glovePhase_substate2:
	call _ecom_decCounter2		; $6bbb
	jr z,++			; $6bbe
	ld a,SND_SWORD_OBTAINED		; $6bc0
	call playSound		; $6bc2
	ld a,PALH_83		; $6bc5
	call loadPaletteHeader		; $6bc7
++
	call enemyAnimate		; $6bca
	ld e,Enemy.animParameter		; $6bcd
	ld a,(de)		; $6bcf
	or a			; $6bd0
	ret nz			; $6bd1
	ld a,$03		; $6bd2
	call enemySetAnimation		; $6bd4

_ramrock_glovePhase_gotoSubstate3:
	ld bc,-$80		; $6bd7
	call objectSetSpeedZ		; $6bda
	ld l,Enemy.subid		; $6bdd
	ld (hl),$11		; $6bdf
	ld l,Enemy.state2		; $6be1
	ld (hl),$03		; $6be3
	ld l,Enemy.angle		; $6be5
	ld (hl),$08		; $6be7
	ld l,Enemy.counter2		; $6be9
	ld (hl),120		; $6beb
	ret			; $6bed

_ramrock_glovePhase_substate3:
	call enemyAnimate		; $6bee
	ld e,Enemy.zh		; $6bf1
	ld a,(de)		; $6bf3
	cp $f9			; $6bf4
	ld c,$00		; $6bf6
	call nz,objectUpdateSpeedZ_paramC		; $6bf8

	call _ramrock_glovePhase_updateMovement		; $6bfb
	call _ecom_decCounter2		; $6bfe
	jr nz,_ramrock_glovePhase_reverseDirection	; $6c01

	ld c,$50		; $6c03
	call objectCheckLinkWithinDistance		; $6c05
	jr nc,_ramrock_glovePhase_reverseDirection	; $6c08

	ld h,d			; $6c0a
	ld l,Enemy.subid		; $6c0b
	ld a,$12		; $6c0d
	ldi (hl),a		; $6c0f
	call getRandomNumber		; $6c10
	and $01			; $6c13
	swap a			; $6c15
	ld (hl),a		; $6c17
	call getRandomNumber		; $6c18
	and $0f			; $6c1b
	jr nz,+			; $6c1d
	set 5,(hl)		; $6c1f
+
	ld l,Enemy.state2		; $6c21
	ld (hl),$04		; $6c23
	ret			; $6c25

_ramrock_glovePhase_substate4:
	ld e,Enemy.var35		; $6c26
	ld a,(de)		; $6c28
	cp $03			; $6c29
	jr z,@dead	; $6c2b

	call enemyAnimate		; $6c2d
	ld e,Enemy.var37		; $6c30
	ld a,(de)		; $6c32
	cp $03			; $6c33
	ret nz			; $6c35
	jr _ramrock_glovePhase_gotoSubstate3		; $6c36

@dead:
	ld e,Enemy.health		; $6c38
	xor a			; $6c3a
	ld (de),a		; $6c3b
	jp _enemyBoss_dead		; $6c3c

;;
; Moves from side to side of the screen
; @addr{6c3f}
_ramrock_updateHorizontalMovement:
	call _ecom_applyVelocityForSideviewEnemy		; $6c3f
	ret nz			; $6c42
	ld e,Enemy.angle		; $6c43
	ld a,(de)		; $6c45
	xor $10			; $6c46
	ld (de),a		; $6c48
	xor a			; $6c49
	ret			; $6c4a

_ramrock_glovePhase_reverseDirection:
	ld h,d			; $6c4b
	ld l,Enemy.xh		; $6c4c
	ld a,$c0		; $6c4e
	cp (hl)			; $6c50
	jr c,++			; $6c51
	ld a,$28		; $6c53
	cp (hl)			; $6c55
	jr c,@applySpeed	; $6c56
	inc a			; $6c58
++
	ld (hl),a ; [xh]
	ld e,Enemy.angle		; $6c5a
	ld a,(de)		; $6c5c
	xor $10			; $6c5d
	ld (de),a		; $6c5f
	xor a			; $6c60
@applySpeed:
	jp objectApplySpeed		; $6c61

;;
; @addr{6c64}
_ramrock_glovePhase_updateMovement:
	ld hl,w1Link.yh		; $6c64
	ld e,Enemy.yh		; $6c67
	ld a,(de)		; $6c69
	cp (hl)			; $6c6a
	jr nc,@label_10_262	; $6c6b

	ld c,a			; $6c6d
	ld a,(hl)		; $6c6e
	sub c			; $6c6f
	cp $40			; $6c70
	jr z,@ret	; $6c72
	jr c,@label_10_262	; $6c74

	ld a,(de)		; $6c76
	cp $50			; $6c77
	ld c,ANGLE_DOWN		; $6c79
	jr nc,@ret	; $6c7b
	jr @moveInDirection		; $6c7d

@label_10_262:
	ld a,(de) ; [yh]
	cp $41			; $6c80
	ld c,ANGLE_UP		; $6c82
	jr c,@ret	; $6c84

@moveInDirection:
	ld b,SPEED_80		; $6c86
	ld e,Enemy.angle		; $6c88
	call objectApplyGivenSpeed		; $6c8a
@ret:
	ret			; $6c8d


; ==============================================================================
; ENEMYID_KING_MOBLIN_MINION
;
; Variables:
;   relatedObj1: Instance of ENEMYID_KING_MOBLIN
;   relatedObj2: Instance of PARTID_BOMB (smaller bomb thrown by this object)
; ==============================================================================
enemyCode56_body:
	ld e,Enemy.state		; $6c8e
	ld a,(de)		; $6c90
	rst_jumpTable			; $6c91
	.dw _kingMoblinMinion_state0
	.dw enemyAnimate
	.dw _kingMoblinMinion_state2
	.dw _kingMoblinMinion_state3
	.dw _kingMoblinMinion_state4
	.dw _kingMoblinMinion_state5
	.dw _kingMoblinMinion_state6
	.dw _kingMoblinMinion_state7
	.dw _kingMoblinMinion_state8
	.dw _kingMoblinMinion_state9
	.dw _kingMoblinMinion_stateA


_kingMoblinMinion_state0:
	ld h,d			; $6ca8
	ld l,e			; $6ca9
	inc (hl) ; [state] = 1

	ld l,Enemy.speed		; $6cab
	ld (hl),SPEED_200		; $6cad

	ld e,Enemy.subid		; $6caf
	ld a,(de)		; $6cb1
	add a			; $6cb2
	ld hl,@data		; $6cb3
	rst_addDoubleIndex			; $6cb6

	ld e,Enemy.counter1		; $6cb7
	ldi a,(hl)		; $6cb9
	ld (de),a		; $6cba
	ld e,Enemy.direction		; $6cbb
	ldi a,(hl)		; $6cbd
	ld (de),a		; $6cbe
	ld e,Enemy.yh		; $6cbf
	ldi a,(hl)		; $6cc1
	ld (de),a		; $6cc2
	ld e,Enemy.xh		; $6cc3
	ld a,(hl)		; $6cc5
	ld (de),a		; $6cc6

	ld a,$02		; $6cc7
	call enemySetAnimation		; $6cc9
	jp objectSetVisiblec2		; $6ccc

; Data format: counter1, direction, yh, xh
@data:
	.db  30, $03, $08, $18
	.db 150, $01, $08, $88



; Fight just started
_kingMoblinMinion_state2:
	ld h,d			; $6cd7
	ld l,e			; $6cd8
	inc (hl) ; [state] = 3

	ld l,Enemy.counter2		; $6cda
	ld (hl),$0c		; $6cdc
	ld e,Enemy.direction		; $6cde
	ld a,(de)		; $6ce0
	jp enemySetAnimation		; $6ce1


; Delay before spawning bomb
_kingMoblinMinion_state3:
	call _ecom_decCounter2		; $6ce4
	jr nz,_kingMoblinMinion_animate	; $6ce7

	ld b,PARTID_BOMB		; $6ce9
	call _ecom_spawnProjectile		; $6ceb
	ret nz			; $6cee

	call _ecom_incState		; $6cef

	ld a,$02		; $6cf2
	jp enemySetAnimation		; $6cf4


; Holding bomb for a bit
_kingMoblinMinion_state4:
	call _ecom_decCounter1		; $6cf7
	ld l,e			; $6cfa
	jr z,@jump	; $6cfb

	ld a,(wScreenShakeCounterY)		; $6cfd
	or a			; $6d00
	jr z,_kingMoblinMinion_animate	; $6d01

	ld (hl),$07 ; [counter1]
	jr _kingMoblinMinion_animate		; $6d05

@jump:
	inc (hl) ; [state] = 5
	ld l,Enemy.speedZ		; $6d08
	ld a,<(-$180)		; $6d0a
	ldi (hl),a		; $6d0c
	ld (hl),>(-$180)		; $6d0d

_kingMoblinMinion_animate:
	jp enemyAnimate		; $6d0f


; Jumping in air
_kingMoblinMinion_state5:
	ld c,$20		; $6d12
	call objectUpdateSpeedZ_paramC		; $6d14
	jr z,@landed	; $6d17

	; Check for the peak of the jump
	ldd a,(hl)		; $6d19
	or (hl)			; $6d1a
	ret nz			; $6d1b

	call objectGetAngleTowardEnemyTarget		; $6d1c
	ld b,a			; $6d1f

	; [bomb.state]++
	ld a,Object.state		; $6d20
	call objectGetRelatedObject2Var		; $6d22
	inc (hl)		; $6d25

	; Set bomb to move toward Link
	ld l,Part.angle		; $6d26
	ld (hl),b		; $6d28
	ret			; $6d29

@landed:
	ld l,Enemy.state		; $6d2a
	inc (hl) ; [state] = 6

	ld l,Enemy.counter1		; $6d2d
	ld (hl),$10		; $6d2f
	jr _kingMoblinMinion_animate		; $6d31


; Delay before pulling out next bomb
_kingMoblinMinion_state6:
	call _ecom_decCounter1		; $6d33
	jr nz,_kingMoblinMinion_animate	; $6d36

	ld (hl),200 ; [counter1]
	ld l,e			; $6d3a
	ld (hl),$02 ; [state]

	jr _kingMoblinMinion_animate		; $6d3d


; ENEMYID_KING_MOBLIN sets this object's state to 7 when defeated.
_kingMoblinMinion_state7:
	ld h,d			; $6d3f
	ld l,e			; $6d40
	inc (hl) ; [state] = 8

	ld l,Enemy.counter1		; $6d42
	ld (hl),24		; $6d44

	; Calculate animation, store it in 'c'
	ld l,Enemy.subid		; $6d46
	ld a,(hl)		; $6d48
	add a			; $6d49
	inc a			; $6d4a
	ld c,a			; $6d4b

	; Get angle to throw bomb at
	ld a,(hl)		; $6d4c
	ld hl,@subidBombThrowAngles		; $6d4d
	rst_addAToHl			; $6d50
	ld b,(hl)		; $6d51

	ld a,Object.state		; $6d52
	call objectGetRelatedObject2Var		; $6d54
	inc (hl)		; $6d57

	ld l,Part.angle		; $6d58
	ld (hl),b		; $6d5a

	ld l,Part.speed		; $6d5b
	ld (hl),SPEED_160		; $6d5d

	ld l,Part.speedZ		; $6d5f
	ld a,<(-$100)		; $6d61
	ldi (hl),a		; $6d63
	ld (hl),>(-$100)		; $6d64

	ld l,Part.visible		; $6d66
	ld (hl),$81		; $6d68

	ld a,c			; $6d6a
	jp enemySetAnimation		; $6d6b

@subidBombThrowAngles:
	.db $0a $16


; Delay before hopping
_kingMoblinMinion_state8:
	call _ecom_decCounter1		; $6d70
	ret nz			; $6d73

	ld l,e			; $6d74
	inc (hl) ; [state] = 9

	ld l,Enemy.speedZ		; $6d76
	ld a,<(-$140)		; $6d78
	ldi (hl),a		; $6d7a
	ld (hl),>(-$140)		; $6d7b

	ld l,Enemy.subid		; $6d7d
	bit 0,(hl)		; $6d7f
	ld c,$f4		; $6d81
	jr z,+			; $6d83
	ld c,$0c		; $6d85
+
	ld b,$f8		; $6d87
	ld a,30		; $6d89
	call objectCreateExclamationMark		; $6d8b


; Waiting to land on ground
_kingMoblinMinion_state9:
	ld c,$20		; $6d8e
	call objectUpdateSpeedZ_paramC		; $6d90
	ret nz			; $6d93

	ld l,Enemy.state		; $6d94
	inc (hl) ; [state] = $0a

	ld l,Enemy.counter1		; $6d97
	ld (hl),12		; $6d99
	inc l			; $6d9b
	ld (hl),$08 ; [counter2]

	xor a			; $6d9e
	jp enemySetAnimation		; $6d9f


; Running away
_kingMoblinMinion_stateA:
	call _ecom_decCounter2		; $6da2
	jr nz,@animate	; $6da5

	call _ecom_decCounter1		; $6da7
	jr z,@delete	; $6daa

	call objectApplySpeed		; $6dac
@animate:
	jp enemyAnimate		; $6daf

@delete:
	; Write to var33 on ENEMYID_KING_MOBLIN to request the screen transition to begin
	ld a,Object.var33		; $6db2
	call objectGetRelatedObject1Var		; $6db4
	ld (hl),$01		; $6db7
	jp enemyDelete		; $6db9

agesFunc_10_6dbc:
	ld e,$c2		; $6dbc
	ld a,(de)		; $6dbe
	ld hl,@table		; $6dbf
	rst_addDoubleIndex			; $6dc2
	ldi a,(hl)		; $6dc3
	ld h,(hl)		; $6dc4
	ld l,a			; $6dc5
	ld e,$c7		; $6dc6
	ld a,(de)		; $6dc8
	rst_addAToHl			; $6dc9
	ld b,(hl)		; $6dca
	ld a,b			; $6dcb
	and $f0			; $6dcc
	add $08			; $6dce
	ld e,$f0		; $6dd0
	ld (de),a		; $6dd2
	inc e			; $6dd3
	ld a,b			; $6dd4
	and $0f			; $6dd5
	swap a			; $6dd7
	add $08			; $6dd9
	ld (de),a		; $6ddb
	ret			; $6ddc

; @addr{6ddd}
@table:
	.dw @data0
	.dw @data1
	.dw @data2
	.dw @data3

; @addr{6de5}
@data0:
	.db $51 $91 $93 $13 $19 $39 $3d $9d
	.db $97 $77 $7a $8a $00

; @addr{6df2}
@data1:
	.db $17 $13 $73 $7d $3d $39 $99 $91
	.db $61 $62 $00

; @addr{6dfd}
@data2:
	.db $5d $9d $95 $55 $51 $11 $1b $3b
	.db $35 $25 $26 $00

; @addr{6e09}
@data3:
	.db $97 $99 $79 $7d $9d $9b $3b $3d
	.db $1d $1b $3b $35 $55 $53 $93 $98
	.db $88 $00