;;
; @addr{5872}
runRoomSpecificCode: ; 5872
	ld a,(wActiveRoom)		; $5872
	ld hl, _roomSpecificCodeGroupTable
	call findRoomSpecificData		; $5878
	ret nc			; $587b
	rst_jumpTable			; $587c
.dw _roomSpecificCode0
.dw _roomSpecificCode1
.dw _roomSpecificCode2
.dw _roomSpecificCode3
.dw _roomSpecificCode4
.dw _roomSpecificCode5
.dw setDeathRespawnPoint
.dw _roomSpecificCode7
.dw _roomSpecificCode8
.dw _roomSpecificCode9
.dw _roomSpecificCodeA
.dw _roomSpecificCodeB
.dw _roomSpecificCodeC

	; Random stub not called by anything?
	ret			; 5897

_roomSpecificCodeGroupTable: ; 5898
	.dw _roomSpecificCodeGroup0Table
	.dw _roomSpecificCodeGroup1Table
	.dw _roomSpecificCodeGroup2Table
	.dw _roomSpecificCodeGroup3Table
	.dw _roomSpecificCodeGroup4Table
	.dw _roomSpecificCodeGroup5Table
	.dw _roomSpecificCodeGroup6Table
	.dw _roomSpecificCodeGroup7Table

; Format: room index

_roomSpecificCodeGroup0Table: ; 58a8
	.db $93 $00
	.db $38 $06
	.db $39 $08
	.db $3a $09
	.db $00
_roomSpecificCodeGroup1Table: ; 58b1
	.db $81 $03
	.db $38 $06
	.db $97 $07
	.db $0e $0a
	.db $00
_roomSpecificCodeGroup2Table: ; 58ba
	.db $0e $05
	.db $00
_roomSpecificCodeGroup3Table: ; 58bd
	.db $0f $0b
	.db $00
_roomSpecificCodeGroup4Table: ; 58c0
	.db $60 $01
	.db $52 $02
	.db $e6 $0c
	.db $00
_roomSpecificCodeGroup5Table: ; 58c7
	.db $d2 $04
_roomSpecificCodeGroup6Table:
_roomSpecificCodeGroup7Table: ; 58c9
	.db $00

;;
; @addr{58ca}
_roomSpecificCode0: ; 58ca
	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME		; $58ca
	call checkGlobalFlag		; $58cc
	ret nz			; $58cf
	ld hl,$cfd0		; $58d0
	ld b,$10		; $58d3
	jp clearMemory		; $58d5

;;
; @addr{5cd8}
_roomSpecificCode1: ; 5cd8
	ld a, GLOBALFLAG_D3_CRYSTALS	; $5cd8
	call checkGlobalFlag		; $58da
	ret nz			; $58dd
---
	; Create spinner object
	call getFreeInteractionSlot		; $58de
	ret nz			; $58e1
	ld (hl),$7d		; $58e2
	ld l,Interaction.yh
	ld (hl),$57		; $58e6
	ld l,Interaction.xh
	ld (hl),$01		; $58ea
	ret			; $58ec

;;
; @addr{58ed}
_roomSpecificCode2: ; 58ed
	ld a,GLOBALFLAG_D3_CRYSTALS	; $58ed
	call checkGlobalFlag		; $58ef
	ret z			; $58f2
	; Create spinner if the flag is UNset
	jr ---

;;
; @addr{58f5}
_roomSpecificCode3: ; 58f5
	call getThisRoomFlags		; $58f5
	bit 6,a			; $58f8
	ret nz			; $58fa
	ld a,TREASURE_MYSTERY_SEEDS		; $58fb
	call checkTreasureObtained		; $58fd
	ret nc			; $5900
	ld hl,wcc05		; $5901
	res 1,(hl)		; $5904
	call getFreeInteractionSlot		; $5906
	ret nz			; $5909
	ld (hl),$40		; $590a
	inc l			; $590c
	ld (hl),$0a		; $590d
	ld a,$01		; $590f
	ld (wDiggingUpEnemiesForbidden),a		; $5911
	ret			; $5914

;;
; @addr{5915}
_roomSpecificCode7: ; 5915
	ld a,GLOBALFLAG_GAVE_ROPE_TO_RAFTON	; $5915
	call checkGlobalFlag		; $5917
	ret z			; $591a
	call getThisRoomFlags		; $591b
	bit 6,a			; $591e
	ret nz			; $5920
.ifdef ROM_AGES
	ld a,MUS_RALPH
.else
	ld a,$35
.endif
	ld (wActiveMusic2),a		; $5923
	ret			; $5926

;;
; @addr{5927}
_roomSpecificCode5: ; 5927
	ld a,GLOBALFLAG_SAVED_NAYRU	; $5927
	call checkGlobalFlag		; $5929
	ret nz			; $592c
	ld a,MUS_SADNESS
	ld (wActiveMusic2),a		; $592f
	ret			; $5932

;;
; Something in ambi's palace
; @addr{5933}
_roomSpecificCode4: ; 5933
	ld a,$06		; $5933
	ld (wMinimapRoom),a		; $5935
	ld hl,wPastRoomFlags+$06
	set 4,(hl)		; $593b
	ret			; $593d

;;
; Check to play ralph music for ralph entering portal cutscene
; @addr{593e}
_roomSpecificCode8: ; 593e
	ld a,(wScreenTransitionDirection)		; $593e
	cp DIR_RIGHT			; $5941
	ret nz			; $5943
	ld a, GLOBALFLAG_RALPH_ENTERED_PORTAL
	call checkGlobalFlag		; $5946
	ret nz			; $5949
.ifdef ROM_AGES
	ld a, MUS_RALPH
.else
	ld a,$35
.endif
	ld (wActiveMusic2),a		; $594c
	ret			; $594f

;;
; Play nayru music on impa's house screen, for some reason
; @addr{5950}
_roomSpecificCode9: ; 5950
	ld a,GLOBALFLAG_FINISHEDGAME		; $5950
	call checkGlobalFlag		; $5952
	ret z			; $5955
.ifdef ROM_AGES
	ld a, MUS_NAYRU
.else
	ld a,$08
.endif
	ld (wActiveMusic2),a		; $5958
	ret			; $595b

;;
; Correct minimap in mermaid's cave present
; @addr{595c}
_roomSpecificCodeA: ; 595c
	ld hl,wMinimapGroup		; $595c
	ld (hl),$00		; $595f
	inc l			; $5961
	ld (hl),$3c		; $5962
	ret			; $5964

;;
; Correct minimap in mermaid's cave past
; @addr{5965}
_roomSpecificCodeB: ; 5965
	ld hl,wMinimapGroup		; $5965
	ld (hl),$01		; $5968
	inc l			; $596a
	ld (hl),$3c		; $596b
	ret			; $596d

;;
; Something happening on vire black tower screen
; @addr{596e}
_roomSpecificCodeC: ; 596e
	ld hl,wActiveMusic		; $596e
	ld a,(hl)		; $5971
	or a			; $5972
	ret nz			; $5973
	ld (hl),$ff		; $5974
	ret			; $5976
