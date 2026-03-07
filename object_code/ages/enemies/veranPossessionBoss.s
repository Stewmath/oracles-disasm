; ==================================================================================================
; ENEMY_VERAN_POSSESSION_BOSS
;
; Variables:
;   relatedObj1: For subid 2 (veran ghost/human), this is a reference to subid 0 or 1
;                (nayru/ambi form).
;   var30: Animation index
;   var31/var32: Target position when moving
;   var33: Number of hits remaining
;   var34: Current pillar index
;   var35: Bit 0 set if already showed veran's "taunting" text after using switch hook
; ==================================================================================================
enemyCode61:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; ENEMYSTATUS_KNOCKBACK or ENEMYSTATUS_JUST_HIT
	call veranPossessionBoss_wasHit

@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr c,@commonState
	ld a,b
	rst_jumpTable
	.dw veranPossessionBoss_subid0
	.dw veranPossessionBoss_subid1
	.dw veranPossessionBoss_subid2
	.dw veranPossessionBoss_subid3

@commonState:
	rst_jumpTable
	.dw veranPossessionBoss_state_uninitialized
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_switchHook
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub
	.dw veranPossessionBoss_state_stub


veranPossessionBoss_state_uninitialized:
	bit 1,b
	jr nz,++
	ld a,ENEMY_VERAN_POSSESSION_BOSS
	ld (wEnemyIDToLoadExtraGfx),a
++
	ld a,b
	add a
	add b
	ld e,Enemy.var30
	ld (de),a
	call enemySetAnimation

	call objectSetVisible82

	ld a,SPEED_200
	call ecom_setSpeedAndState8

	ld l,Enemy.subid
	bit 1,(hl)
	ret z

	; For subids 2-3 only
	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

	ld l,Enemy.counter1
	ld (hl),$0c

	ld l,Enemy.speed
	ld (hl),SPEED_80
	ret


veranPossessionBoss_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw enemyAnimate
	.dw enemyAnimate
	.dw @substate3

@substate0:
	ld h,d
	ld l,Enemy.collisionType
	res 7,(hl)
	jp ecom_incSubstate

@substate3:
	ld b,$0b
	call ecom_fallToGroundAndSetState
	ld l,Enemy.counter1
	ld (hl),40
	ret


veranPossessionBoss_state_stub:
	ret


; Possessed Nayru
veranPossessionBoss_subid0:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw veranPossessionBoss_nayruAmbi_state8
	.dw veranPossessionBoss_nayruAmbi_state9
	.dw veranPossessionBoss_nayruAmbi_stateA
	.dw veranPossessionBoss_nayruAmbi_stateB
	.dw veranPossessionBoss_nayru_stateC
	.dw veranPossessionBoss_nayru_stateD
	.dw veranPossessionBoss_nayruAmbi_stateE
	.dw veranPossessionBoss_nayruAmbi_stateF
	.dw veranPossessionBoss_nayruAmbi_state10
	.dw veranPossessionBoss_nayruAmbi_state11
	.dw veranPossessionBoss_nayruAmbi_state12
	.dw veranPossessionBoss_nayruAmbi_state13
	.dw veranPossessionBoss_nayru_state14


; Initialization
veranPossessionBoss_nayruAmbi_state8:
	call getFreePartSlot
	ret nz

	ld (hl),PART_SHADOW
	ld l,Part.var03
	ld (hl),$06 ; Y-offset of shadow relative to self

	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	; Go to state 9
	call veranPossessionBoss_nayruAmbi_beginMoving

	ld l,Enemy.var3f
	set 5,(hl)

	ld l,Enemy.var33
	ld (hl),$03
	inc l
	dec (hl) ; [var34] = $ff (current pillar index)

	xor a
	ld (wTmpcfc0.genericCutscene.cfd0),a

	ld a,MUS_BOSS
	ld (wActiveMusic),a
	jp playSound


; Flickering before moving
veranPossessionBoss_nayruAmbi_state9:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.zh
	ld (hl),-2
	call objectSetInvisible

	; Choose a position to move to.
	; First it chooses a pillar randomly, then it chooses the side of the pillar based
	; on where Link is in relation.

@choosePillar:
	call getRandomNumber_noPreserveVars
	and $0e
	cp $0b
	jr nc,@choosePillar

	; Pillar must be different from last one
	ld h,d
	ld l,Enemy.var34
	cp (hl)
	jr z,@choosePillar

	ld (hl),a ; [var34]

	ld hl,@pillarList
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	push bc

	; Choose the side of the pillar that is furthest from Link
	ldh a,(<hEnemyTargetY)
	ldh (<hFF8F),a
	ldh a,(<hEnemyTargetX)
	ldh (<hFF8E),a
	call objectGetRelativeAngleWithTempVars
	add $04
	and $18
	rrca
	rrca

	ld hl,@pillarOffsets
	rst_addAToHl
	pop bc
	ldi a,(hl)
	add b
	ld e,Enemy.var31
	ld (de),a ; [var31]
	ld a,(hl)
	add c
	inc e
	ld (de),a ; [var32]

	ld a,SND_CIRCLING
	jp playSound

@pillarList:
	.db $58 $58
	.db $58 $98
	.db $38 $38
	.db $38 $b8
	.db $78 $38
	.db $78 $b8

@pillarOffsets:
	.db $e8 $00
	.db $00 $10
	.db $10 $00
	.db $00 $f0


; Moving to new position
veranPossessionBoss_nayruAmbi_stateA:
	ld h,d
	ld l,Enemy.var31
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	; Reached target position.

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.zh
	ld (hl),$00

	ld l,Enemy.counter1
	ld (hl),30
	ret


; Just reached new position
veranPossessionBoss_nayruAmbi_stateB:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	call getRandomNumber_noPreserveVars
	and $0f
	ld b,a

	ld h,d
	ld l,Enemy.subid
	ld a,(hl)
	add a
	add a
	add (hl)
	ld l,Enemy.var33
	add (hl)
	dec a

	ld hl,@attackProbabilities
	rst_addAToHl
	ld a,b
	cp (hl)
	jr c,@beginAttacking

	; Move again
	call veranPossessionBoss_nayruAmbi_beginMoving
	ld (hl),30
	jp ecom_flickerVisibility

@beginAttacking:
	call ecom_incState

	ld l,Enemy.counter1
	ld (hl),30

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.var30
	ld a,(hl)
	inc a
	call enemySetAnimation
	jp objectSetVisiblec2

; Each byte is the probability of veran attacking when she has 'n' hits left (ie. 1st byte is
; for when she has 1 hit left). Higher values mean a higher probability of attacking. If
; she doesn't attack, she moves again.
@attackProbabilities:
	.db $05 $0a $10 $10 $10 ; Nayru
	.db $05 $06 $08 $08 $08 ; Ambi


; Delay before attacking with projectiles. (Nayru only)
veranPossessionBoss_nayru_stateC:
	call ecom_decCounter1
	ret nz

	ld (hl),142 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld b,PART_VERAN_PROJECTILE
	jp ecom_spawnProjectile


; Attacking with projectiles. (This is only Nayru's state D, but Ambi's state D may call
; this if it's not spawning spiders instead.)
veranPossessionBoss_nayru_stateD:
	call ecom_decCounter1
	ret nz

veranPossessionBoss_doneAttacking:
	call veranPossessionBoss_nayruAmbi_beginMoving

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.var30
	ld a,(hl)
	jp enemySetAnimation


; Just shot with mystery seeds
veranPossessionBoss_nayruAmbi_stateE:
	call ecom_decCounter2
	ret nz

	; Spawn veran ghost form
	call getFreeEnemySlot_uncounted
	ret nz
	ld (hl),ENEMY_VERAN_POSSESSION_BOSS
	inc l
	ld (hl),$02 ; [child.subid]

	; [child.var33] = [this.var33] (remaining hits before death)
	ld l,Enemy.var33
	ld e,l
	ld a,(de)
	ld (hl),a

	ld l,Enemy.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld bc,$fc04
	call objectCopyPositionWithOffset

	call ecom_incState

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a ; [child.oamFlagsBackup]
	ld (hl),a  ; [child.oamFlags]

	jp objectSetVisible83


; Collapsed (ghost Veran is showing)
veranPossessionBoss_nayruAmbi_stateF:
	ret


; Veran just returned to nayru/ambi's body
veranPossessionBoss_nayruAmbi_state10:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.oamFlagsBackup
	ld a,$06
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]

	ld l,Enemy.counter1
	ld (hl),15
	jp objectSetVisible82


; Remains collapsed on the floor for a few frames before moving again
veranPossessionBoss_nayruAmbi_state11:
	call ecom_decCounter1
	ret nz

	ld l,Enemy.var30
	ld a,(hl)
	call enemySetAnimation


veranPossessionBoss_nayruAmbi_beginMoving:
	ld h,d
	ld l,Enemy.state
	ld (hl),$09

	ld l,Enemy.counter1
	ld (hl),60
	ret


; Veran was just defeated.
veranPossessionBoss_nayruAmbi_state12:
	ld a,(wTextIsActive)
	or a
	ret nz
	call ecom_incState
	ld a,$02
	jp fadeoutToWhiteWithDelay


; Waiting for screen to go white
veranPossessionBoss_nayruAmbi_state13:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call ecom_incState
	jpab clearAllItemsAndPutLinkOnGround


; Delete all objects (including self), resume cutscene with a newly created object
veranPossessionBoss_nayru_state14:
	call clearWramBank1

	ld hl,w1Link.enabled
	ld (hl),$03

	call getFreeInteractionSlot
	ld (hl),INTERAC_NAYRU_SAVED_CUTSCENE
	ret


; Possessed Ambi
veranPossessionBoss_subid1:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw veranPossessionBoss_nayruAmbi_state8
	.dw veranPossessionBoss_nayruAmbi_state9
	.dw veranPossessionBoss_nayruAmbi_stateA
	.dw veranPossessionBoss_nayruAmbi_stateB
	.dw veranPossessionBoss_ambi_stateC
	.dw veranPossessionBoss_ambi_stateD
	.dw veranPossessionBoss_nayruAmbi_stateE
	.dw veranPossessionBoss_nayruAmbi_stateF
	.dw veranPossessionBoss_nayruAmbi_state10
	.dw veranPossessionBoss_nayruAmbi_state11
	.dw veranPossessionBoss_nayruAmbi_state12
	.dw veranPossessionBoss_nayruAmbi_state13
	.dw veranPossessionBoss_ambi_state14


; Delay before attacking with projectiles or spawning spiders. (Ambi only)
veranPossessionBoss_ambi_stateC:
	call ecom_decCounter1
	ret nz

	ld (hl),142 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	call getRandomNumber_noPreserveVars
	and $0f
	ld b,a

	ld e,Enemy.var33
	ld a,(de)
	dec a
	ld hl,@spiderSpawnProbabilities
	rst_addAToHl
	ld a,b
	cp (hl)

	; Set [var03] to 1 if we're spawning spiders, 0 otherwise
	ld h,d
	ld l,Enemy.var03
	ld (hl),$01
	ret nc

	dec (hl)
	ld b,PART_VERAN_PROJECTILE
	jp ecom_spawnProjectile

; Each byte is the probability of veran spawning spiders when she has 'n' hits left (ie.
; 1st byte is for when she has 1 hit left). Lower values mean a higher probability of
; spawning spiders. If she doesn't spawn spiders, she fires projectiles.
@spiderSpawnProbabilities:
	.db $08 $08 $0a $0a $0a


; Attacking with projectiles or spiders. (Ambi only)
veranPossessionBoss_ambi_stateD:
	; Jump to Nayru's state D if we're firing projectiles
	ld e,Enemy.var03
	ld a,(de)
	or a
	jp z,veranPossessionBoss_nayru_stateD

	; Spawning spiders

	call ecom_decCounter1
	jp z,veranPossessionBoss_doneAttacking

	; Spawn spider every 32 frames
	ld a,(hl) ; [counter1]
	and $1f
	ret nz

	ld a,(wNumEnemies)
	cp $06
	ret nc

	ld b,ENEMY_VERAN_SPIDER
	jp ecom_spawnEnemyWithSubid01


; Ambi-specific cutscene after Veran defeated
veranPossessionBoss_ambi_state14:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Deletes all objects, including self
	call clearWramBank1

	ld a,$01
	ld (wNumEnemies),a

	ld hl,w1Link.enabled
	ld (hl),$03

	ld l,<w1Link.yh
	ld (hl),$58
	ld l,<w1Link.xh
	ld (hl),$78

	call setCameraFocusedObjectToLink
	call resetCamera

	; Spawn subid 3 of this object
	call getFreeEnemySlot_uncounted
	ld (hl),ENEMY_VERAN_POSSESSION_BOSS
	inc l
	ld (hl),$03 ; [subid]

	ld l,Enemy.yh
	ld (hl),$48
	ld l,Enemy.xh
	ld (hl),$78
	ret


; Veran emerged in human form
veranPossessionBoss_subid2:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw veranPossessionBoss_humanForm_state8
	.dw veranPossessionBoss_humanForm_state9
	.dw veranPossessionBoss_humanForm_stateA
	.dw veranPossessionBoss_humanForm_stateB
	.dw veranPossessionBoss_humanForm_stateC
	.dw veranPossessionBoss_humanForm_stateD
	.dw veranPossessionBoss_humanForm_stateE
	.dw veranPossessionBoss_humanForm_stateF
	.dw veranPossessionBoss_humanForm_state10


; Moving upward just after spawning
veranPossessionBoss_humanForm_state8:
	call objectApplySpeed
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	ld (hl),120 ; [counter1]
	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.collisionType
	set 7,(hl)

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_GHOST

	; If this is Nayru, and we haven't shown veran's taunting text yet, show it.
	ld a,Object.subid
	call objectGetRelatedObject1Var
	ld a,(hl)
	or a
	jr nz,veranPossessionBoss_animate

	ld l,Enemy.var35
	bit 0,(hl)
	jr nz,veranPossessionBoss_animate

	inc (hl) ; [var35] |= 1

	ld bc,TX_2f2a
	call showText
	jr veranPossessionBoss_animate


; Waiting for Link to use switch hook
veranPossessionBoss_humanForm_state9:
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	ld (hl),12 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.angle
	ld (hl),ANGLE_DOWN

	ld l,Enemy.collisionType
	res 7,(hl)

veranPossessionBoss_animate:
	jp enemyAnimate


; Moving down to re-possess her victim
veranPossessionBoss_humanForm_stateA:
	call objectApplySpeed
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	ld l,Enemy.collisionType
	res 7,(hl)

veranPossessionBoss_humanForm_returnToHost:
	; Send parent to state $10
	ld a,Object.state
	call objectGetRelatedObject1Var
	inc (hl)

	; Update parent's "hits remaining" counter
	ld l,Enemy.var33
	ld e,l
	ld a,(de)
	ld (hl),a

	jp enemyDelete


; Just finished using switch hook on ghost. Flickering between ghost and human forms.
veranPossessionBoss_humanForm_stateB:
	call ecom_decCounter1
	jr nz,@flickerBetweenForms

	ld (hl),120 ; [counter1]

	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_VERAN_HUMAN

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	set 7,(hl)

	; NOTE: hl is supposed to be [counter1] for below, which it isn't. It only affects
	; the animation though, so no big deal...

@flickerBetweenForms:
	ld a,(hl) ; [counter1]
	rrca
	ld a,$09
	jr c,+
	ld a,$06
+
	jp enemySetAnimation


; Veran is vulnerable to attacks.
veranPossessionBoss_humanForm_stateC:
	call ecom_decCounter1
	jr nz,veranPossessionBoss_animate

	; Time to return to host

	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.speed
	ld (hl),SPEED_280

	ld l,Enemy.speedZ
	ld a,<(-$280)
	ldi (hl),a
	ld (hl),>(-$280)

	call objectSetVisiblec1

	; Set target position to be the nayru/ambi's position.
	; [this.var31] = [parent.yh], [this.var32] = [parent.xh]
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld e,Enemy.var31
	ldi a,(hl)
	ld (de),a ; [this.var31]
	inc e
	inc l
	ld a,(hl)
	ld (de),a ; [this.var32]

	jr veranPossessionBoss_animate


; Moving back to nayru/ambi
veranPossessionBoss_humanForm_stateD:
	ld c,$20
	call objectUpdateSpeedZ_paramC

	ld l,Enemy.var31
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	jp nc,ecom_moveTowardPosition

	; Reached nayru/ambi.

	ld l,Enemy.yh
	ld (hl),b
	ld l,Enemy.xh
	ld (hl),c

	; Wait until reached ground
	ld e,Enemy.zh
	ld a,(de)
	or a
	ret nz

	jp veranPossessionBoss_humanForm_returnToHost


; Health is zero; about to begin cutscene.
veranPossessionBoss_humanForm_stateE:
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a
	ret nz

	call checkLinkCollisionsEnabled
	ret nc

	ldbc INTERAC_PUFF,$02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start

	ld l,Enemy.state
	inc (hl)

	ld a,DISABLE_LINK
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	jp objectSetInvisible


; Waiting for puff to finish its animation
veranPossessionBoss_humanForm_stateF:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	jp ecom_incState


; Sets nayru/ambi's state to $12, shows text, then deletes self
veranPossessionBoss_humanForm_state10:
	ld a,Object.state
	call objectGetRelatedObject1Var
	ld (hl),$12

	ld l,Enemy.subid
	bit 0,(hl)
	ld bc,TX_560b
	jr z,+
	ld bc,TX_5611
+
	call showText
	jp enemyDelete



; Collapsed Ambi after the fight.
veranPossessionBoss_subid3:
	ld a,(de)
	cp $08
	jr nz,@state9


; Waiting for palette to fade out
@state8:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call ecom_incState

	ld l,Enemy.counter2
	ld (hl),60

	ld a,$05
	call enemySetAnimation

	jp fadeinFromWhite


; Waiting for palette to fade in; then spawn the real Ambi object and delete self.
@state9:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	call ecom_decCounter2
	ret nz

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_AMBI
	inc l
	ld (hl),$07 ; [subid]

	call objectCopyPosition

	ld a,TREE_GFXH_01
	ld (wLoadedTreeGfxIndex),a

	jp enemyDelete


;;
veranPossessionBoss_wasHit:
	ld h,d
	ld l,Enemy.knockbackCounter
	ld (hl),$00

	ld e,Enemy.subid
	ld a,(de)
	cp $02
	ld l,Enemy.var2a
	ld a,(hl)
	jr z,@subid2

	; Subid 0 or 1 (possessed Nayru or Ambi)

	res 7,a
	cp ITEMCOLLISION_MYSTERY_SEED
	jr z,@mysterySeed

	; Direct attacks from Link cause damage to Link, not Veran
	sub ITEMCOLLISION_L1_SWORD
	ret c
	cp ITEMCOLLISION_SHOVEL - ITEMCOLLISION_L1_SWORD + 1
	ret nc

	ld l,Enemy.invincibilityCounter
	ld (hl),-24
	ld hl,w1Link.invincibilityCounter
	ld (hl),40

	; [w1Link.knockbackAngle] = [this.knockbackAngle] ^ $10
	inc l
	ld e,Enemy.knockbackAngle
	ld a,(de)
	xor $10
	ldi (hl),a

	ld (hl),21 ; [w1Link.knockbackCounter]

	ld l,<w1Link.damageToApply
	ld (hl),-8
	ret

@mysterySeed:
	ld l,Enemy.state
	ld (hl),$0e

	ld l,Enemy.counter2
	ld (hl),30

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.var30
	ld a,(hl)
	add $02
	jp enemySetAnimation

@subid2:
	; Collisions on emerged Veran (ghost/human form)
	; Check if a direct attack occurred
	res 7,a
	cp ITEMCOLLISION_L1_SWORD
	ret c
	cp ITEMCOLLISION_EXPERT_PUNCH + 1
	ret nc

	ld l,Enemy.enemyCollisionMode
	ld a,(hl)
	cp ENEMYCOLLISION_VERAN_GHOST
	jr nz,++

	; No effect on ghost form
	ld l,Enemy.invincibilityCounter
	ld (hl),-8
	ret
++
	ld l,Enemy.counter1
	ld (hl),$08
	ld l,Enemy.var33
	dec (hl)
	ret nz

	; Veran has been hit enough times to die now.

	ld l,Enemy.health
	ld (hl),$80

	ld l,Enemy.collisionType
	res 7,(hl)

	ld l,Enemy.state
	ld (hl),$0e

	ld a,$01
	ld (wTmpcfc0.genericCutscene.cfd0),a

	ld a,SNDCTRL_STOPMUSIC
	jp playSound
