; This code is included at the start of banks $0f-$10. Similar to "enemyCommon.s", but
; only for those two banks since they deal with boss enemies.
;
; Function names are prefixed with "enemyBoss" to show they come from here.


;;
; Enemy bosses call this when they're dead (ENEMYSTATUS_NO_HEALTH). They don't disappear
; right away, they flicker for a second, then explode.
enemyBoss_dead:
	ld h,d
	ld l,Enemy.collisionType
	ld a,(hl)
	or a
	jr z,@alreadyPlayedDeathSound

	ld (hl),$00
	ld l,Enemy.counter1
	ld (hl),120
	ld a,$01
	ld (wDisableLinkCollisionsAndMenu),a
	ld a,SND_BOSS_DEAD
	call playSound

@alreadyPlayedDeathSound:
	call ecom_decCounter1
	jp nz,ecom_flickerVisibility

	inc (hl)

	; Spawn explosion
	call getFreePartSlot
	ret nz
	ld (hl),PART_BOSS_DEATH_EXPLOSION
	inc l
	ld e,Enemy.id
	ld a,(de)
	ld (hl),a ; [Part.subid] = [Enemy.id]

	call objectCopyPosition
	call markEnemyAsKilledInRoom

	ld e,Enemy.id
	ld a,(de)
	sub $08
	cp $68
	jr c,++
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
++
	jp enemyDelete

;;
; Creates a "large shadow" object and attaches it to the enemy.
;
; @param	b	Shadow size (0-2 for small-large)
; @param	c	Y-offset of shadow relative to self
; @param[out]	zflag	z on success
enemyBoss_spawnShadow:
	call getFreePartSlot
	ret nz
	ld (hl),PART_SHADOW
	inc l
	ld (hl),b ; [subid]
	inc l
	ld (hl),c ; [var03]
	ld l,Part.relatedObj1
	ld a,Enemy.start
	ldi (hl),a
	ld (hl),d
	xor a
	ret

;;
; Loads extra graphics for enemy, palette header, stops music, forces Link to walk into
; the room.
;
; @param	a	Enemy ID for graphics to load (or $ff to not load extra graphics)
; @param	b	Palette header to load (or 0 for none)
enemyBoss_initializeRoom:
	bit 7,a
	jr nz,+
	ld (wEnemyIDToLoadExtraGfx),a
+
	ld a,b
	or a
	call nz,loadPaletteHeader

	; Fall through

;;
; Stops music, forces Link to walk into the room.
enemyBoss_initializeRoomWithoutExtraGfx:
.ifdef ROM_SEASONS
	ldh a,(<hActiveObject)
	ld d,a
.endif
	ld a,SNDCTRL_STOPMUSIC
	call playSound

	xor a
	ld (wDisableLinkCollisionsAndMenu),a
	dec a
	ld (wActiveMusic),a

	ld hl,wcc93
	set 7,(hl)

	ld a,(wScrollMode)
	and SCROLLMODE_01
	ret nz

	ld a,LINK_STATE_FORCE_MOVEMENT
	ld (wLinkForceState),a

.ifdef ROM_AGES
	ld a,$16
.else; ROM_SEASONS
	ld a,$1a
.endif
	ld (wLinkStateParameter),a

	ld hl,w1Link.direction
	ld a,(wScreenTransitionDirection)
	ldi (hl),a
	swap a
	rrca
	ld (hl),a
	ret


.ifdef ROM_AGES

;;
; Plays miniboss music, enables controls.
enemyBoss_beginMiniboss:
	ld b,MUS_MINIBOSS
	jr ++

;;
; Plays boss music, enables controls.
enemyBoss_beginBoss:
	ld b,MUS_BOSS
++
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ld a,b
	ld (wActiveMusic),a
	jp playSound


.endif ; ROM_AGES
