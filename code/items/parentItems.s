;;
; ITEMID_MAGNET_GLOVES ($08)
; @addr{5358}
_parentItemCode_magnetGloves:
	call _checkNoOtherParentItemsInUse		; $5358
--
	push hl			; $535b
	call nz,_clearParentItemH		; $535c
	pop hl			; $535f
	call _checkNoOtherParentItemsInUse@nextItem		; $5360
	jr nz,--		; $5363
	ret			; $5365
