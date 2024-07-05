; ==================================================================================================
; INTERAC_CREATE_OBJECT_AT_EACH_TILEINDEX
; ==================================================================================================
interactionCodec7:
	ld e,Interaction.subid
	ld a,(de)
	ld c,a
	ld hl,wRoomLayout
	ld b,LARGE_ROOM_HEIGHT*$10
--
	ld a,(hl)
	cp c
	call z,@createObject
	inc l
	dec b
	jr nz,--
	jp interactionDelete

@createObject:
	push hl
	push bc
	ld b,l
	ld e,Interaction.xh
	ld a,(de)
	and $f0
	swap a
	call @spawnObjectType
	jr nz,@ret

	ld e,Interaction.yh
	ld a,(de)
	ldi (hl),a
	ld e,Interaction.xh
	ld a,(de)
	and $0f
	ld (hl),a

	ld a,l
	add Object.yh-Object.subid
	ld l,a
	ld a,b
	and $f0
	add $08
	ldi (hl),a
	inc l
	ld a,b
	and $0f
	swap a
	add $08
	ld (hl),a

@ret:
	pop bc
	pop hl
	ret

;;
; @param	a	0 for enemy; 1 for part; 2 for interaction
; @param[out]	hl	Spawned object
@spawnObjectType:
	or a
	jp z,getFreeEnemySlot
	dec a
	jp z,getFreePartSlot
	dec a
	jp z,getFreeInteractionSlot
	ret
