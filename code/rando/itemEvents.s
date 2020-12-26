; This file is included by "object_code/common/interactionCode/treasure.s" which puts it in the
; "treasureInteraction" namespace.

;;
; Run certain actions depending on what item was picked up and where. This has to be explicitly
; called if an item is given by an interaction other than ID 60. Parameters to this are the same as
; the "giveTreasure" function (a, c).
handleGetItem:
	ld e,a

	push de
	ld e,Interaction.var33 ; nonzero if interaction should set item room flag
	ld a,(de)
	or a
	pop de

.ifdef ROM_SEASONS
	jr z,@giveTreasure

	ld a,(wActiveGroup)
	cp $01
	jr z,@subrosia
	cp $02
	jr z,@indoors
	jr @giveTreasure

@subrosia:
	; RANDO-TODO
	;ld a,(wActiveRoom)
	;ld hl,starOreRooms
	;call searchValue
	;ret nz
	;ld hl,c694
	;set 2,(hl)
	ret

@indoors:
	; RANDO-TODO
	;ld a,(wActiveRoom)
	;ld hl,makuTreeRooms
	;call searchValue
	;ret nz
	;ld hl,c693
	;set 2,(hl)
	ret

.else; ROM_AGES
	push af
	; RANDO-TODO
	;call satchelRefillSeeds
	;call seedShooterGiveSeeds
	;call activateFlute
	pop af
	jr z,@incoming

@outgoing:
	; RANDO-TODO ("Item obtained" flag doesn't work for these slots?)
	;call dirtSetFakeId
	;call tingleSetFakeId
	;call symmetryBrotherSetFakeId
	;call goronDanceSetFakeId
	;call kingZoraSetFakeId

@incoming:
	; RANDO-TODO
	;call setD6BossKey
	;call makuSeedResetTreeState
.endif

@giveTreasure:
	ld a,e
	jp giveTreasure
