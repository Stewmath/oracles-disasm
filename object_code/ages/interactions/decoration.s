; ==================================================================================================
; INTERAC_DECORATION
; ==================================================================================================
interactionCode80:
	call checkInteractionState
	jr z,@state0

@state1:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw interactionAnimate
	.dw @deleteIfGotRoomItem
	.dw @deleteIfGotRoomItem
	.dw interactionAnimate
	.dw interactionAnimate

@state0:
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible83
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @stub
	.dw @deleteIfMoblinsKeepDestroyed
	.dw @stub
	.dw @stub
	.dw @deleteIfRoomFlagBit7Unset
	.dw @stub
	.dw @deleteIfRoomFlagBit7Unset
	.dw @deleteIfGotRoomItem
	.dw @deleteIfGotRoomItem
	.dw @stub
	.dw @subid0a

@stub:
	ret

; Subid $01 (moblin's keep flag)
@deleteIfMoblinsKeepDestroyed:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ret z
	jp interactionDelete

; Subid $04, $06 (scent seedling & tokay eyeball)
@deleteIfRoomFlagBit7Unset:
	call getThisRoomFlags
	bit 7,a
	ret nz
	jp interactionDelete

@deleteIfGotRoomItem:
	call getThisRoomFlags
	bit ROOMFLAG_BIT_ITEM,a
	ret z
	jp interactionDelete

; Fountain "stream": decide which palette to used based on whether this is the "ruined"
; symmetry city or not
@subid0a:
	call objectSetVisible80
	call @isSymmetryCityRoom
	jr c,@isSymmetryCity

@normalPalette:
	ld a,PALH_7d
	jp loadPaletteHeader

@isSymmetryCity:
	ld a,(wActiveGroup)
	or a
	jr nz,@ruinedSymmetryPalette
	call getThisRoomFlags
	and $01
	jr nz,@normalPalette

@ruinedSymmetryPalette:
	ld a,PALH_7c
	jp loadPaletteHeader

@isSymmetryCityRoom:
	ld a,(wActiveRoom)
	ld e,a
	ld hl,@symmetryCityRooms
	jp lookupKey

@symmetryCityRooms:
	.db $12 $00
	.db $13 $00
	.db $14 $00
	.db $00
