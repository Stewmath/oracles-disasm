; ==================================================================================================
; ENEMY_MAKU_TREE_BUBBLE
;
; Variables:
;   $cfc0: bit 7 set when popped
; ==================================================================================================
enemyCode56:
	jr z,@normalStatus
	ld e,Enemy.state
	ld a,$02
	ld (de),a
@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	ld a,$01
	ld (de),a
	call objectSetVisible80
	jr @snore

@state1:
	ld e,Enemy.subid
	ld a,(de)
	jr z,+
	ld hl,$cfc0
	bit 7,(hl)
	jr z,+
	ld e,Enemy.state
	ld a,$02
	ld (de),a
+
	call enemyAnimate

@snore:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	ld e,Enemy.state
	ld a,(de)
	cp $01
	jr nz,+
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	jr nz,++
	ld e,Enemy.animCounter
	ld a,(de)
	cp $01
	jr nz,+
	ld a,SND_MAKU_TREE_SNORE
	call playSound
+
	ld e,Enemy.animParameter
	ld a,(de)
++
	add a
	ld hl,@bubbleOffsetAndCollisionRadius
	rst_addDoubleIndex
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Enemy.xh
	ldi a,(hl)
	add c
	ld (de),a
	ld e,Enemy.zh
	ld a,$f8
	ld (de),a
	ld e,Enemy.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ld (de),a
	ret

@bubbleOffsetAndCollisionRadius:
	.db $d8 $e0 $00 $00
	.db $06 $f6 $00 $00
	.db $08 $f0 $06 $00
	.db $04 $ec $08 $00
	.db $07 $f0 $06 $00
	.db $05 $f6 $00 $00

@state2:
	ld h,d
	ld l,Enemy.substate
	ld a,(hl)
	or a
	jr nz,+
	inc (hl)
	ld l,Enemy.collisionType
	ld b,Enemy.var2f-Enemy.collisionType
	; all counters, collision, damage and health
	call clearMemory
	ld l,Enemy.health
	inc (hl)
	ld l,Enemy.oamFlagsBackup
	ld a,$01
	ldi (hl),a
	; oamFlags
	ld (hl),a
	ld a,$01
	call enemySetAnimation
	ld hl,$cfc0
	set 7,(hl)
	jr @snore
+
	ld l,Enemy.animParameter
	bit 7,(hl)
	jp z,enemyAnimate
	xor a
	ld (hl),a
	ld l,Enemy.substate
	ldd (hl),a
	inc (hl)
	jp @snore

@state3:
	call enemyAnimate
	ld e,Enemy.animParameter
	ld a,(de)
	or a
	ret z
	rlca
	jp c,enemyDelete
	ld h,d
	ld l,Enemy.yh
	inc (hl)
	ret
