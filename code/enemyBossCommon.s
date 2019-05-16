; This code is included at the start of banks $0f-$10. Similar to "enemyCommon.s", but
; only for those two banks since they deal with boss enemies.
;
; Function names are prefixed with "_enemyBoss" to show they come from here.


;;
; Enemy bosses call this when they're dead (ENEMYSTATUS_NO_HEALTH). They don't disappear
; right away, they flicker for a second, then explode.
; @addr{44f0}
_enemyBoss_dead:
	ld h,d			; $44f0
	ld l,Enemy.collisionType		; $44f1
	ld a,(hl)		; $44f3
	or a			; $44f4
	jr z,@alreadyPlayedDeathSound	; $44f5

	ld (hl),$00		; $44f7
	ld l,Enemy.counter1		; $44f9
	ld (hl),120		; $44fb
	ld a,$01		; $44fd
	ld (wDisableLinkCollisionsAndMenu),a		; $44ff
	ld a,SND_BOSS_DEAD		; $4502
	call playSound		; $4504

@alreadyPlayedDeathSound:
	call _ecom_decCounter1		; $4507
	jp nz,_ecom_flickerVisibility		; $450a

	inc (hl)		; $450d

	; Spawn explosion
	call getFreePartSlot		; $450e
	ret nz			; $4511
	ld (hl),PARTID_04		; $4512
	inc l			; $4514
	ld e,Enemy.id		; $4515
	ld a,(de)		; $4517
	ld (hl),a ; [Part.subid] = [Enemy.id]

	call objectCopyPosition		; $4519
	call markEnemyAsKilledInRoom		; $451c

	ld e,Enemy.id		; $451f
	ld a,(de)		; $4521
	sub $08			; $4522
	cp $68			; $4524
	jr c,++			; $4526
	ld a,(wActiveMusic2)		; $4528
	ld (wActiveMusic),a		; $452b
	call playSound		; $452e
++
	jp enemyDelete		; $4531

;;
; Creates a "large shadow" object and attaches it to the enemy.
;
; @param	b	Shadow size (0-2 for small-large)
; @param	c	Y-offset of shadow relative to self
; @param[out]	zflag	z on success
; @addr{4534}
_enemyBoss_spawnShadow:
	call getFreePartSlot		; $4534
	ret nz			; $4537
	ld (hl),PARTID_SHADOW		; $4538
	inc l			; $453a
	ld (hl),b ; [subid]
	inc l			; $453c
	ld (hl),c ; [var03]
	ld l,Part.relatedObj1		; $453e
	ld a,Enemy.start		; $4540
	ldi (hl),a		; $4542
	ld (hl),d		; $4543
	xor a			; $4544
	ret			; $4545

;;
; Loads extra graphics for enemy, palette header, stops music, forces Link to walk into
; the room.
;
; @param	a	Enemy ID for graphics to load (or $ff to not load extra graphics)
; @param	b	Palette header to load (or 0 for none)
; @addr{4546}
_enemyBoss_initializeRoom:
	bit 7,a			; $4546
	jr nz,+			; $4548
	ld (wEnemyIDToLoadExtraGfx),a		; $454a
+
	ld a,b			; $454d
	or a			; $454e
	call nz,loadPaletteHeader		; $454f

	; Fall through

;;
; Stops music, forces Link to walk into the room.
; @addr{4552}
_enemyBoss_initializeRoomWithoutExtraGfx:
.ifdef ROM_SEASONS
	ldh a,(<hActiveObject)	; $4571
	ld d,a			; $4573
.endif
	ld a,SNDCTRL_STOPMUSIC		; $4552
	call playSound		; $4554

	xor a			; $4557
	ld (wDisableLinkCollisionsAndMenu),a		; $4558
	dec a			; $455b
	ld (wActiveMusic),a		; $455c

	ld hl,wcc93		; $455f
	set 7,(hl)		; $4562

	ld a,(wScrollMode)		; $4564
	and SCROLLMODE_01			; $4567
	ret nz			; $4569

	ld a,LINK_STATE_FORCE_MOVEMENT		; $456a
	ld (wLinkForceState),a		; $456c

.ifdef ROM_AGES
	ld a,$16		; $456f
.else; ROM_SEASONS
	ld a,$1a
.endif
	ld (wLinkStateParameter),a		; $4571

	ld hl,w1Link.direction		; $4574
	ld a,(wScreenTransitionDirection)		; $4577
	ldi (hl),a		; $457a
	swap a			; $457b
	rrca			; $457d
	ld (hl),a		; $457e
	ret			; $457f


.ifdef ROM_AGES

;;
; Plays miniboss music, enables controls.
; @addr{4580}
_enemyBoss_beginMiniboss:
	ld b,MUS_MINIBOSS		; $4580
	jr ++			; $4582

;;
; Plays boss music, enables controls.
; @addr{4584}
_enemyBoss_beginBoss:
	ld b,MUS_BOSS		; $4584
++
	xor a			; $4586
	ld (wDisabledObjects),a		; $4587
	ld (wMenuDisabled),a		; $458a
	ld a,b			; $458d
	ld (wActiveMusic),a		; $458e
	jp playSound		; $4591


.endif ; ROM_AGES
