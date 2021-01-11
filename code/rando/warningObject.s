; This is only for Seasons. Code for an object that shows warnings about situations that could lead
; to softlocks.

.BANK $09
.SECTION RandoWarningMessageA NAMESPACE seasonsInteractionsBank09 FREE

interactionCode61:
	; There's more free space in bank $0a
	jpab seasonsInteractionsBank0a.interactionCode61_body
.ENDS


.BANK $0a
.SECTION RandoWarningMessageB NAMESPACE seasonsInteractionsBank0a FREE

; ==============================================================================
; INTERACID_RANDO_WARNING_MESSAGE
; ==============================================================================
interactionCode61_body:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$04
	ld e,Interaction.collisionRadiusY
	ld (de),a
	inc e
	ld (de),a

	jp interactionIncState

@state1:
	call objectCheckCollidedWithLink_onGround
	ret nc

	call @checkShouldShowWarning
	; Above call may not return to here (if deleting itself)

	; Show exclamation mark
	push de

	ld a,SpecialObject.start
	ldh (<hActiveObjectType),a

	ld d,>w1Link
	ld bc,$f100
	ld a,60
	call objectCreateExclamationMark

	ld a,Interaction.start
	ldh (<hActiveObjectType),a
	pop de

	; Disable input, set delay before showing the warning
	call @disableInput
	ld e,Interaction.counter1
	ld a,60
	ld (de),a
	jp interactionIncState

@state2:
	call interactionDecCounter1
	ret nz

	call @showText
	call @enableInput
	jp interactionDelete


@checkShouldShowWarning:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid00
	.dw @subid01
	.dw @subid02
	.dw @subid03
	.dw @subid04
	.dw @subid05
	.dw @subid06

; Warning for the ledges & waterfalls from mt. cucco to sunken city.
@subid00:
	call @checkGaleSatchel
	jr c,@delete
	ld b,$15 ; sunken city / mt. cucco
	ld c,1<<SEASON_SUMMER
	call @checkSeasonAccessInArea
	jr z,@delete
	ret

; Warning for moblin keep cliff to Sunken
@subid01:
	call @checkGaleSatchel
	jr c,@delete
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECTID_DIMITRI
	jr nz,@delete
	ld a,TREASURE_FEATHER
	call checkTreasureObtained
	jr c,@delete
	ret

; Warning for the lower temple remains ledge (only exists in rando). This doesn't account for fall
; skip because it gets very complicated and conditional.
@subid02:
	call @checkGaleSatchel
	jr c,@delete
	ld a,(wFeatherLevel)
	or a
	ret z
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call checkGlobalFlag
	jr nz,@delete
	ld b,$1c ; temple remains
	ld c,1<<SEASON_AUTUMN
	call @checkSeasonAccessInArea
	ret nz
	ld a,(wObtainedSeasons)
	and 1<<SEASON_WINTER
	jr nz,@delete
	ret


@delete:
	pop bc ; Return from caller
	jp interactionDelete


; Warning for the upper temple remains ledge. This is dumb complicated just to figure out whether
; the player can for sure get back up, and *technically* it assumes you can bomb jump across the
; lava if you have feather.
@subid03:
	call @checkGaleSatchel
	jr c,@delete
	ld a,(wFeatherLevel)
	or a
	ret z
	ld a,GLOBALFLAG_TEMPLE_REMAINS_FILLED_WITH_LAVA
	call checkGlobalFlag
	ret z
	ld b,$1c ; temple remains
	ld c,1<<SEASON_SUMMER
	call @checkSeasonAccessInArea
	ret nz
	ld a,TREASURE_MAGNET_GLOVES
	call checkTreasureObtained
	jr c,@delete
	ld a,(wFeatherLevel)
	cp $02
	ret c
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	ret nc
	ld a,TREASURE_PEGASUS_SEEDS
	call checkTreasureObtained
	jr c,@delete
	ret

; Warning for the ledge from natzu to eastern suburbs.
@subid04:
	call @checkGaleSatchel
	jr c,@delete
	ld b,$11 ; eastern suburbs
	ld c,1<<SEASON_SPRING
	call @checkSeasonAccessInArea
	jr z,@delete
	ret

; warning for the diving spot from sunken city to woods of winter.
@subid05:
	ld a,(wRoomStateModifier)
	cp SEASON_WINTER
	jr z,@delete
	call @checkGaleSatchel
	jr c,@delete
	ld b,$11 ; eastern suburbs
	ld c,(1<<SEASON_SPRING) | (1<<SEASON_WINTER) ; Must have both
	call @checkSeasonAccessInArea
	jr z,@delete
	ret

; Warning for small key softlock with HSS skip. Checks and sets room flags so as not to display the
; warning more than once, ever.
@subid06:
	ld a,(wGroup5Flags + (<ROOM_SEASONS_586)) ; check if ice puzzle room is visited?
	or a
	jr nz,@delete
	call getThisRoomFlags
	bit 6,(hl)
	jr nz,@delete
	set 6,(hl)
	ret


@showText:
	ld hl,@textTable
	ld e,Interaction.subid
	ld a,(de)
	rst_addAToHl
	ld c,(hl)
	ld b,>TX_RANDO_WARNCLIFF
	jp showText

@textTable:
	.db <TX_RANDO_WARNCLIFF ; $00
	.db <TX_RANDO_WARNCLIFF ; $01
	.db <TX_RANDO_WARNCLIFF ; $02
	.db <TX_RANDO_WARNCLIFF ; $03
	.db <TX_RANDO_WARNCLIFF ; $04
	.db <TX_RANDO_WARNCLIFF ; $05
	.db <TX_RANDO_WARNKEYS ; $06


@disableInput:
	ld a,$81
	ld (wDisabledObjects),a
	ld a,$80
	ld (wMenuDisabled),a
	call clearAllParentItems
	call dropLinkHeldItem
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.invincibilityCounter
	ld (hl),$80
	ld l,<w1Link.knockbackCounter
	ld (hl),$00
	ret

@enableInput:
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	ret


;;
; ORs the default season in the room pack with the seasons the rod has, then ANDs and compares the
; results with d.
;
; @param	b	Room pack of area to check (use this offset in "roomPackSeasonTable")
; @param	c	Season bitmask to check
; @param[out]	zflag	z if you have access to that season in that area.
@checkSeasonAccessInArea:
	callab bank1.readDefaultSeason
	ld a,b
	ld hl,bitTable
	rst_addAToHl
	ld b,(hl)
	ld a,(wObtainedSeasons)
	or b
	and c
	cp c
	ret

;;
; @param[out]	cflag	c if the player has gale seeds and the seed satchel. Used for warnings for
;			cliffs and diving.
@checkGaleSatchel:
	push bc
	ld b,a
	ld a,TREASURE_SEED_SATCHEL
	call checkTreasureObtained
	jr nc,++
	ld a,TREASURE_GALE_SEEDS
	call checkTreasureObtained
++
	ld a,b
	pop bc
	ret


.ENDS
