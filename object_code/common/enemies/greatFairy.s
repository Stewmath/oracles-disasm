; ==================================================================================================
; ENEMY_GREAT_FAIRY
;
; Variables:
;   relatedObj2: Reference to INTERAC_PUFF
;   var30: Counter used to update Z-position as she floats up and down
;   var31: Number of hearts spawned (the ones that circle around Link)
; ==================================================================================================
enemyCode38:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw greatFairy_state_uninitialized
	.dw greatFairy_state1
	.dw greatFairy_state2
	.dw greatFairy_state3
	.dw greatFairy_state4
	.dw greatFairy_state5
	.dw greatFairy_state6
	.dw greatFairy_state7
	.dw greatFairy_state8
	.dw greatFairy_state9


greatFairy_state_uninitialized:
	ld h,d
	ld l,e
	inc (hl) ; [state]
	ld l,Enemy.zh
	ld (hl),$f0
	ret


; Create puff
greatFairy_state1:
	call greatFairy_createPuff
	ret nz

	ld l,Enemy.state
	inc (hl)

	ld l,Enemy.counter1
	ld (hl),$11
	ld a,MUS_FAIRY_FOUNTAIN
	ld (wActiveMusic),a
	ret


; Waiting for puff to disappear
greatFairy_state2:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z

	call ecom_incState


; Waiting for Link to approach
greatFairy_state3:
	call greatFairy_checkLinkApproached
	jr nc,greatFairy_animate

	ld a,$80
	ld (wMenuDisabled),a

	ld a,DISABLE_COMPANION|DISABLE_LINK
	ld (wDisabledObjects),a

	ld hl,wLinkHealth
	ldi a,(hl)
	cp (hl)
	ld a,$04
	ld bc,TX_4100
	jr nz,++

	; Full health already
	ld e,Enemy.counter1
	ld a,30
	ld (de),a
	ld a,$08
	ld bc,TX_4105
++
	ld e,Enemy.state
	ld (de),a
	call showText

greatFairy_animate:
	call greatFairy_updateZPosition
	call enemyAnimate
	ld e,Enemy.yh
	ld a,(de)
	ld b,a
	ldh a,(<hEnemyTargetY)
	cp b
	jp c,objectSetVisiblec1
	jp objectSetVisiblec2


; Begin healing Link
greatFairy_state4:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter1
	ld (hl),$0c
	inc l
	ld (hl),$09 ; [counter2]


; Spawning hearts
greatFairy_state5:
	call greatFairy_playSoundEvery8Frames
	call ecom_decCounter1
	jr nz,greatFairy_animate

	ld (hl),$0c ; [counter1]
	inc l
	dec (hl) ; [counter2]
	jr z,@spawnedAllHearts
	call greatFairy_spawnCirclingHeart
	jr greatFairy_animate

@spawnedAllHearts:
	dec l
	ld (hl),30 ; [counter1]

	ld l,Enemy.state
	inc (hl)
	jr greatFairy_animate


; Hearts have all spawned, are now circling around Link
greatFairy_state6:
	call greatFairy_playSoundEvery8Frames
	call ecom_decCounter1
	jr nz,greatFairy_animate
	ld l,Enemy.state
	inc (hl)
	ld a,TREASURE_HEART_REFILL
	ld c,MAX_LINK_HEALTH
	call giveTreasure


; Waiting for all hearts to disappear
greatFairy_state7:
	call greatFairy_playSoundEvery8Frames
	ld e,Enemy.var31
	ld a,(de)
	or a
	jr nz,greatFairy_animate

	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),30


; About to disappear; staying in place for 30 frames
greatFairy_state8:
	call ecom_decCounter1
	jr nz,greatFairy_animate

	ld (hl),60 ; [counter1]
	ld l,e
	inc (hl) ; [state]

	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	ld a,SND_FAIRYCUTSCENE
	call playSound


; Disappearing
greatFairy_state9:
	call ecom_decCounter1
	jp z,enemyDelete

	call greatFairy_animate

	; Flicker visibility
	ld h,d
	ld l,Enemy.counter1
	bit 0,(hl)
	ret nz
	ld l,Enemy.visible
	res 7,(hl)
	ret


;;
greatFairy_updateZPosition:
	ld h,d
	ld l,Enemy.var30
	dec (hl)
	ld a,(hl)
	and $07
	ret nz

	ld a,(hl)
	and $18
	swap a
	rlca
	sub $02
	bit 5,(hl)
	jr nz,++
	cpl
	inc a
++
	sub $10
	ld l,Enemy.zh
	ld (hl),a
	ret


;;
; @param[out]	cflag	c if Link approached
greatFairy_checkLinkApproached:
	call checkLinkVulnerable
	ret nc

	ld h,d
	ld l,Enemy.yh
	ldh a,(<hEnemyTargetY)
	sub (hl)
	sub $10
	cp $21
	ret nc

	ld l,Enemy.xh
	ldh a,(<hEnemyTargetX)
	sub (hl)
	add $18
	cp $31
	ret

;;
greatFairy_spawnCirclingHeart:
	call getFreePartSlot
	ret nz

	ld (hl),PART_GREAT_FAIRY_HEART
	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d

	ld h,d
	ld l,Enemy.var31
	inc (hl)
	ret


;;
greatFairy_createPuff:
	ldbc INTERAC_PUFF,$02
	call objectCreateInteraction
	ret nz

	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.start
	xor a
	ret

;;
greatFairy_playSoundEvery8Frames:
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,SND_FAIRY_HEAL
	jp playSound
