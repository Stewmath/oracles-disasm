;;
; Called after all other file initialization is done
randoInitializeFile:
	; Global flags
	push hl
	ld hl,@initialGlobalFlags
@loop:
	ldi a,(hl)
	cp a,$ff
	jr z,@done
	push hl
	call setGlobalFlag
	pop hl
	jr @loop
@done:
	pop hl
	
	; animal vars
	ld a,(randovar_animalCompanion)
	ld (wAnimalCompanion),a
	ld a,$ff
	ld (wCompanionTutorialTextShown),a
	
	; room flags 4 | 6
	ld a,$50
	ld (wPresentRoomFlags+$a7),a ; start
	
	; room flags 3 | 5 | 6 | 7
	ld a,$e8
	ld (wPresentRoomFlags+$9a),a ; rosa portal
	
	; room flags 6 | 7
	ld a,$c0
	ld (wPresentRoomFlags+$98),a ; troupe
	ld (wPresentRoomFlags+$cb),a ; first rosa encounter
	
	; room flag 6
	ld a,$40
	ld (wPresentRoomFlags+$00),a ; d6 entrance
	ld (wPresentRoomFlags+$1d),a ; d4 entrance
	ld (wPresentRoomFlags+$60),a ; d3 entrance
	ld (wPresentRoomFlags+$8a),a ; d5 entrance
	ld (wPresentRoomFlags+$8d),a ; d2 entrance
	ld (wPresentRoomFlags+$96),a ; d1 entrance
	ld (wPresentRoomFlags+$9b),a ; sokra stump
	ld (wPresentRoomFlags+$b6),a ; impa's house
	ld (wPresentRoomFlags+$d0),a ; d7 entrance
	ld (wPresentRoomFlags+$e9),a ; sokra in town
	ld (wPastRoomFlags+$00),a ; d8 entrance
	ld (wPastRoomFlags+$29),a ; temple of seasons "gate"
	ld (wPastRoomFlags+$2a),a ; winter tower
	
	; room flag 0
	ld a,$01
	ld (wPresentRoomFlags+$01),a ; flag determines whether flower/rock tile exists (d6)

	; Initial satchel / slingshot / seed shooter selection
	ld a,(randovar_initialSeedType)
	ld (wSatchelSelectedSeeds),a
	ld (wShooterSelectedSeeds),a
	
	; give L-3 ring box
	ld hl,wObtainedTreasureFlags + TREASURE_RING_BOX / 8
	set (TREASURE_RING_BOX & 7),(hl)
	ld a,$03
	ld (wRingBoxLevel),a

	; Fix initial season
	ld hl,bank1.roomPackSeasonTable+$10 ; North Horon season
	ld e,:bank1.roomPackSeasonTable
	call readByte
	ld a,e
	ld (wDeathRespawnBuffer.stateModifier),a
	
	; linked start item (RANDO-TODO)
	;ld a,(wIsLinkedGame)
	;or a
	;call nz,giveLinkedStartItem
	
	ret


.ifdef ROM_SEASONS

@initialGlobalFlags:
	.db GLOBALFLAG_INTRO_DONE, GLOBALFLAG_WITCHES_1_SEEN, $ff

.else

; RANDO-TODO
@initialGlobalFlags:
	.db $ff

.endif
