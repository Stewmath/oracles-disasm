; The data in this file specifies which rooms contain warps. For the destination, they have a
; "destination index" which refers to data in "data/{game}/warpDestinations.s".
;
; There are a couple of macros used here. For m_StandardWarp:
;
;   Param 1: half-byte
;     If 0, warp applies to the whole screen. Otherwise it's a "screen-edge" warp applying to one of
;     the four corners of the screen, depending which bits are set.
;     bit 0 = top-left, bit 1 = top-right, bit 2 = bottom-left, bit 3 = bottom-right.
;
;   Param 2: byte
;     The room index this warp source is in. (The group is implicitly known already based on which
;     table it's in.)
;
;   Param 3: byte
;     Warp Dest Index. Along with the Warp Dest Group, this is an index for the warp destination to
;     use (data/{game}/warpDestinations.s).
;
;   Param 4: half-byte
;     Warp Dest Group. Determines the map group to be warped to. Goes with Warp Dest Index above.
;
;   Param 5: half-byte
;     Transition source type. See constants/common/transitions.s.
;
; For m_PointerWarp, 1st param is the room index, 2nd param is a pointer to data for that room. Used
; for rooms with multiple warps.
;
; For m_PositionWarp, it's basically the same as m_StandardWarp, except it's missing the 1st
; parameter, and the 2nd parameter becomes the YX position instead of the room index. This can only
; be used in conjunction with m_PointerWarp (it points to the list of m_PositionWarp entries).
;
; There are three ways to end the warp lists:
;
;   m_WarpListEndWithDefault specifies that if no warp was found, the last entry is used as a default.
;
;   m_WarpListEndNoDefault specifies that if no warp was found, some fallback code should be run
;   instead. This fallback code only exists in Ages, which can handle staircases in dungeons without
;   any warp data being explicitly defined for them.
;
;   m_WarpListFallThrough doesn't actually end the list. It's used in places where the devs appear
;   to have forgotten to use their equivalent of one of the two end commands above.

warpSourcesTable:
	.dw group0WarpSources
	.dw group1WarpSources
	.dw group2WarpSources
	.dw group3WarpSources
	.dw group4WarpSources
	.dw group5WarpSources
	.dw group6WarpSources
	.dw group7WarpSources

group0WarpSources:
	m_PointerWarp     $d4 warpSource764b
	m_StandardWarp $0 $96 $02 $4 $4
	m_PointerWarp     $8d warpSource7657
	m_PointerWarp     $60 warpSource766b
	m_StandardWarp $0 $1d $05 $4 $4
	m_StandardWarp $0 $8a $06 $4 $4
	m_StandardWarp $0 $00 $07 $4 $4
	m_StandardWarp $0 $d0 $00 $5 $4
	m_StandardWarp $0 $03 $02 $5 $4
	m_StandardWarp $0 $00 $03 $5 $4
	m_StandardWarp $0 $00 $04 $5 $4
	m_StandardWarp $0 $88 $00 $3 $4
	m_StandardWarp $0 $b6 $02 $3 $4
	m_PointerWarp     $d7 warpSource75e3
	m_PointerWarp     $c5 warpSource7603
	m_StandardWarp $0 $c8 $05 $3 $4
	m_PointerWarp     $d2 warpSource763f
	m_StandardWarp $0 $e8 $15 $3 $4
	m_PointerWarp     $f6 warpSource7623
	m_StandardWarp $0 $b5 $18 $3 $4
	m_StandardWarp $0 $4d $1d $3 $4
	m_StandardWarp $0 $10 $1f $3 $4
	m_StandardWarp $0 $5e $20 $3 $4
	m_StandardWarp $0 $3f $21 $3 $4
	m_StandardWarp $0 $6d $23 $3 $4
	m_StandardWarp $0 $6f $32 $3 $4
	m_PointerWarp     $7f warpSource7637
	m_PointerWarp     $f9 warpSource762b
	m_StandardWarp $0 $e6 $2b $3 $4
	m_StandardWarp $0 $04 $30 $3 $4
	m_StandardWarp $0 $f7 $33 $3 $4
	m_StandardWarp $0 $a3 $3c $3 $4
	m_StandardWarp $0 $78 $3d $3 $4
	m_PointerWarp     $62 warpSource761b
	m_StandardWarp $0 $5d $3f $3 $4
	m_StandardWarp $0 $43 $41 $3 $4
	m_PointerWarp     $5b warpSource760b
	m_StandardWarp $0 $9a $06 $1 $8
	m_StandardWarp $0 $b0 $07 $1 $8
	m_PointerWarp     $1e warpSource75fb
	m_StandardWarp $0 $b9 $09 $1 $8
	m_StandardWarp $0 $25 $0a $1 $8
	m_StandardWarp $0 $04 $0b $1 $8
	m_StandardWarp $1 $d9 $00 $2 $3
	m_StandardWarp $2 $d9 $00 $2 $3
	m_StandardWarp $0 $7d $5e $5 $4
	m_PointerWarp     $8e warpSource765f
	m_StandardWarp $0 $da $58 $5 $2
	m_PointerWarp     $ea warpSource7673
	m_StandardWarp $0 $4f $5f $5 $4
	m_StandardWarp $0 $1b $60 $5 $4
	m_StandardWarp $0 $0b $62 $5 $4
	m_StandardWarp $0 $1c $64 $5 $4
	m_PointerWarp     $0f warpSource7683
	m_StandardWarp $0 $1f $67 $5 $4
	m_StandardWarp $0 $aa $69 $5 $4
	m_StandardWarp $0 $16 $6d $5 $4
	m_PointerWarp     $06 warpSource767b
	m_StandardWarp $0 $07 $6f $5 $4
	m_StandardWarp $0 $15 $75 $5 $4
	m_StandardWarp $0 $18 $76 $5 $4
	m_PointerWarp     $28 warpSource75f3
	m_StandardWarp $0 $39 $7b $5 $4
	m_StandardWarp $0 $09 $7f $5 $4
	m_PointerWarp     $19 warpSource768b
	m_StandardWarp $0 $29 $80 $5 $4
	m_StandardWarp $0 $31 $48 $4 $4
	m_StandardWarp $0 $f1 $4f $4 $4
	m_StandardWarp $0 $fd $50 $4 $4
	m_StandardWarp $0 $ff $52 $4 $4
	m_PointerWarp     $bf warpSource7613
	m_StandardWarp $0 $cc $56 $4 $4
	m_StandardWarp $0 $51 $57 $4 $4
	m_StandardWarp $0 $c2 $5a $4 $4
	m_StandardWarp $0 $a7 $5b $4 $4
	m_StandardWarp $0 $b3 $39 $4 $4
	m_StandardWarp $0 $87 $3a $4 $4
	m_StandardWarp $0 $d3 $5c $4 $4
	m_StandardWarp $0 $e2 $84 $5 $4
	m_StandardWarp $0 $ee $83 $5 $4
	m_StandardWarp $0 $dc $89 $5 $4
	m_StandardWarp $0 $66 $8b $5 $4
	m_StandardWarp $0 $97 $8c $5 $4
	m_StandardWarp $0 $02 $8f $5 $4
	m_StandardWarp $0 $8f $90 $5 $4
	m_StandardWarp $0 $a4 $91 $5 $4
	m_PointerWarp     $57 warpSource75eb
	m_StandardWarp $0 $69 $93 $5 $4
	m_StandardWarp $0 $79 $94 $5 $4
	m_StandardWarp $0 $59 $95 $5 $4
	m_StandardWarp $0 $49 $97 $5 $4
	m_StandardWarp $0 $a6 $9a $5 $4
	m_StandardWarp $0 $e0 $46 $3 $4
	m_StandardWarp $0 $7e $9b $5 $4
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

warpSource75e3:
	m_PositionWarp $43 $03 $3 $4
	m_PositionWarp $14 $98 $5 $4
	m_WarpListEndWithDefault

warpSource75eb:
	m_PositionWarp $32 $92 $5 $4
	m_PositionWarp $15 $99 $5 $4
	m_WarpListEndWithDefault

warpSource75f3:
	m_PositionWarp $13 $78 $5 $4
	m_PositionWarp $52 $8a $5 $4
	m_WarpListEndWithDefault

warpSource75fb:
	m_PositionWarp $12 $46 $4 $4
	m_PositionWarp $54 $08 $1 $8
	m_WarpListFallThrough

warpSource7603:
	m_PositionWarp $11 $04 $3 $4
	m_PositionWarp $14 $38 $3 $4
	m_WarpListEndWithDefault

warpSource760b:
	m_PositionWarp $33 $42 $3 $4
	m_PositionWarp $35 $43 $3 $4
	m_WarpListEndWithDefault

warpSource7613:
	m_PositionWarp $18 $54 $4 $4
	m_PositionWarp $46 $55 $4 $4
	m_WarpListEndWithDefault

warpSource761b:
	m_PositionWarp $27 $40 $4 $4
	m_PositionWarp $34 $3e $3 $4
	m_WarpListEndWithDefault

warpSource7623:
	m_PositionWarp $24 $16 $3 $4
	m_PositionWarp $26 $17 $3 $4
	m_WarpListEndWithDefault

warpSource762b:
	m_PositionWarp $62 $8e $5 $4
	m_PositionWarp $33 $29 $3 $4
	m_PositionWarp $25 $2a $3 $4
	m_WarpListEndWithDefault

warpSource7637:
	m_PositionWarp $47 $27 $3 $4
	m_PositionWarp $27 $28 $3 $9
	m_WarpListEndWithDefault

warpSource763f:
	m_PositionWarp $12 $8d $5 $4
	m_PositionWarp $24 $06 $3 $4
	m_PositionWarp $16 $07 $3 $4
	m_WarpListEndWithDefault

warpSource764b:
	m_PositionWarp $57 $01 $4 $9
	m_PositionWarp $54 $00 $4 $4
	m_WarpListEndWithDefault

warpSource7653: ; hardcoded usage of this through getLinkedHerosCaveSideEntranceRoom
	m_StandardWarp $0 $57 $52 $5 $9
	m_WarpListFallThrough

warpSource7657:
	m_PositionWarp $24 $03 $4 $4
	m_PositionWarp $18 $0c $4 $2
	m_WarpListEndWithDefault

warpSource765f:
	m_PositionWarp $12 $0d $4 $2
	m_PositionWarp $43 $5c $5 $4
	m_PositionWarp $48 $5d $5 $4
	m_WarpListEndWithDefault

warpSource766b:
	m_PositionWarp $21 $3b $4 $4
	m_PositionWarp $25 $04 $4 $4
	m_WarpListEndWithDefault

warpSource7673:
	m_PositionWarp $15 $55 $5 $4
	m_PositionWarp $07 $5a $5 $4
	m_WarpListEndWithDefault

warpSource767b:
	m_PositionWarp $13 $71 $5 $4
	m_PositionWarp $16 $72 $5 $4
	m_WarpListEndWithDefault

warpSource7683:
	m_PositionWarp $15 $65 $5 $4
	m_PositionWarp $55 $66 $5 $4
	m_WarpListEndWithDefault

warpSource768b:
	m_PositionWarp $06 $7d $5 $4
	m_PositionWarp $08 $7e $5 $4
	m_PositionWarp $22 $73 $5 $4
	m_PositionWarp $57 $81 $5 $4
	m_WarpListEndWithDefault


group1WarpSources:
	m_StandardWarp $0 $00 $01 $5 $4
	m_StandardWarp $0 $09 $48 $3 $4
	m_PointerWarp     $28 warpSource7733
	m_StandardWarp $0 $08 $9d $5 $4
	m_StandardWarp $0 $0a $9e $5 $4
	m_StandardWarp $0 $2a $9f $5 $4
	m_StandardWarp $0 $05 $1a $0 $8
	m_StandardWarp $0 $57 $1b $0 $8
	m_StandardWarp $0 $53 $1c $0 $8
	m_StandardWarp $0 $4a $1d $0 $8
	m_StandardWarp $0 $13 $1e $0 $8
	m_StandardWarp $0 $20 $2f $3 $8
	m_StandardWarp $0 $12 $74 $5 $4
	m_PointerWarp     $35 warpSource773b
	m_PointerWarp     $72 warpSource7727
	m_StandardWarp $0 $22 $13 $3 $4
	m_StandardWarp $0 $24 $19 $3 $4
	m_StandardWarp $0 $23 $1a $3 $4
	m_StandardWarp $0 $33 $1b $3 $4
	m_StandardWarp $0 $49 $22 $3 $4
	m_StandardWarp $0 $45 $24 $3 $4
	m_StandardWarp $0 $44 $25 $3 $4
	m_StandardWarp $0 $26 $26 $3 $4
	m_StandardWarp $0 $5a $31 $3 $4
	m_StandardWarp $0 $51 $3a $3 $4
	m_StandardWarp $0 $52 $3b $3 $4
	m_StandardWarp $0 $54 $06 $7 $4
	m_StandardWarp $0 $03 $4a $4 $4
	m_StandardWarp $0 $04 $4b $4 $4
	m_StandardWarp $0 $11 $4c $4 $4
	m_PointerWarp     $58 warpSource771f
	m_StandardWarp $0 $74 $82 $5 $4
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

warpSource771f:
	m_PositionWarp $25 $4d $4 $4
	m_PositionWarp $52 $4e $4 $4
	m_WarpListEndWithDefault

warpSource7727:
	m_PositionWarp $24 $34 $3 $8
	m_PositionWarp $32 $0b $3 $4
	m_PositionWarp $53 $08 $3 $4
	m_WarpListEndWithDefault

warpSource7733:
	m_PositionWarp $43 $9c $5 $4
	m_PositionWarp $55 $07 $7 $4
	m_WarpListEndWithDefault

warpSource773b:
	m_PositionWarp $43 $58 $4 $4
	m_PositionWarp $46 $59 $4 $4
	m_WarpListEndWithDefault


group2WarpSources:
	m_StandardWarp $4 $0b $19 $0 $3
	m_StandardWarp $8 $0b $19 $0 $3
	m_StandardWarp $4 $0c $19 $0 $3
	m_StandardWarp $8 $0c $19 $0 $3
	m_StandardWarp $4 $7b $19 $0 $3
	m_StandardWarp $8 $7b $19 $0 $3
	m_StandardWarp $4 $2b $19 $0 $3
	m_StandardWarp $8 $2b $19 $0 $3
	m_StandardWarp $4 $2c $19 $0 $3
	m_StandardWarp $8 $2c $19 $0 $3
	m_StandardWarp $4 $2d $19 $0 $3
	m_StandardWarp $8 $2d $19 $0 $3
	m_StandardWarp $4 $5b $19 $0 $3
	m_StandardWarp $8 $5b $19 $0 $3
	m_StandardWarp $4 $5c $19 $0 $3
	m_StandardWarp $8 $5c $19 $0 $3
	m_StandardWarp $4 $5d $19 $0 $3
	m_StandardWarp $8 $5d $19 $0 $3
	m_StandardWarp $4 $5e $19 $0 $3
	m_StandardWarp $8 $5e $19 $0 $3
	m_StandardWarp $0 $7b $41 $4 $4
	m_StandardWarp $0 $2b $41 $4 $4
	m_StandardWarp $0 $2c $41 $4 $4
	m_StandardWarp $0 $2d $41 $4 $4
	m_StandardWarp $0 $5b $41 $4 $4
	m_StandardWarp $0 $5c $41 $4 $4
	m_StandardWarp $0 $5d $41 $4 $4
	m_PointerWarp     $5e warpSource77e7
	m_PointerWarp     $6b warpSource77ef
	m_PointerWarp     $1b warpSource77ef
	m_PointerWarp     $1c warpSource77ef
	m_PointerWarp     $1d warpSource77ef
	m_PointerWarp     $4b warpSource77ef
	m_PointerWarp     $4c warpSource77ef
	m_PointerWarp     $4d warpSource77ef
	m_PointerWarp     $4e warpSource77ef
	m_StandardWarp $0 $3b $49 $4 $4
	m_StandardWarp $0 $3c $49 $4 $4
	m_StandardWarp $0 $3d $49 $4 $4
	m_StandardWarp $0 $3e $49 $4 $4
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

warpSource77e7:
	m_PositionWarp $26 $41 $4 $4
	m_PositionWarp $67 $48 $5 $4
	m_WarpListEndWithDefault

warpSource77ef:
	m_PositionWarp $06 $45 $4 $4
	m_PositionWarp $56 $43 $4 $4
	m_WarpListEndWithDefault


group3WarpSources:
	m_StandardWarp $4 $80 $0b $0 $3
	m_StandardWarp $4 $81 $0c $0 $3
	m_StandardWarp $4 $82 $0d $0 $3
	m_StandardWarp $4 $83 $11 $0 $3
	m_StandardWarp $4 $84 $0e $0 $3
	m_StandardWarp $4 $85 $10 $0 $3
	m_StandardWarp $4 $88 $45 $0 $3
	m_StandardWarp $4 $89 $46 $0 $3
	m_StandardWarp $4 $8a $19 $1 $3
	m_StandardWarp $0 $8a $0a $3 $2
	m_PointerWarp     $8b warpSource78f7
	m_StandardWarp $4 $8f $17 $1 $3
	m_StandardWarp $4 $91 $12 $0 $3
	m_StandardWarp $4 $92 $13 $0 $3
	m_StandardWarp $4 $93 $14 $0 $3
	m_StandardWarp $4 $94 $15 $0 $3
	m_StandardWarp $0 $95 $0d $1 $2
	m_StandardWarp $4 $96 $0e $1 $3
	m_StandardWarp $4 $97 $0f $1 $3
	m_StandardWarp $0 $98 $37 $4 $2
	m_StandardWarp $4 $99 $48 $0 $3
	m_StandardWarp $0 $9a $4b $0 $2
	m_StandardWarp $0 $9b $4c $0 $2
	m_StandardWarp $4 $9c $4d $0 $3
	m_StandardWarp $4 $9d $4e $0 $3
	m_StandardWarp $8 $9e $15 $1 $3
	m_StandardWarp $4 $9f $50 $0 $3
	m_StandardWarp $4 $a0 $11 $1 $3
	m_StandardWarp $4 $a1 $10 $1 $3
	m_StandardWarp $4 $a2 $12 $1 $3
	m_StandardWarp $4 $a3 $2d $0 $3
	m_StandardWarp $4 $a4 $16 $0 $3
	m_StandardWarp $4 $a5 $17 $0 $3
	m_StandardWarp $4 $a6 $18 $0 $3
	m_StandardWarp $0 $a6 $2e $3 $2
	m_PointerWarp     $a7 warpSource78ef
	m_StandardWarp $4 $a8 $3a $0 $3
	m_StandardWarp $0 $a8 $0b $1 $8
	m_StandardWarp $4 $a9 $16 $1 $3
	m_StandardWarp $4 $aa $51 $0 $3
	m_PointerWarp     $ab warpSource78ff
	m_StandardWarp $4 $af $0f $0 $3
	m_StandardWarp $0 $b0 $2d $3 $2
	m_StandardWarp $8 $b1 $13 $1 $3
	m_StandardWarp $4 $b2 $14 $1 $3
	m_StandardWarp $4 $b3 $20 $0 $3
	m_StandardWarp $4 $b4 $21 $0 $3
	m_StandardWarp $4 $b5 $22 $0 $3
	m_StandardWarp $4 $b6 $4f $0 $3
	m_StandardWarp $0 $b6 $0a $7 $2
	m_StandardWarp $0 $b7 $47 $0 $2
	m_StandardWarp $4 $b8 $53 $0 $3
	m_StandardWarp $8 $b8 $54 $0 $3
	m_StandardWarp $0 $b8 $45 $3 $2
	m_StandardWarp $0 $b9 $44 $3 $2
	m_StandardWarp $0 $ba $58 $0 $2
	m_StandardWarp $1 $ac $49 $3 $3
	m_StandardWarp $2 $ac $49 $3 $3
	m_StandardWarp $4 $bd $35 $3 $3
	m_StandardWarp $8 $bd $35 $3 $3
	m_StandardWarp $4 $bc $22 $1 $3
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

warpSource78ef:
	m_PositionWarp $11 $39 $3 $2
	m_PositionWarp $31 $2c $3 $2
	m_WarpListEndWithDefault

warpSource78f7:
	m_PositionWarp $11 $09 $3 $2
	m_PositionWarp $61 $18 $1 $2
	m_WarpListEndWithDefault

warpSource78ff:
	m_PositionWarp $66 $52 $0 $4
	m_PositionWarp $44 $0c $1 $8
	m_WarpListEndWithDefault


group4WarpSources:
	m_StandardWarp $4 $04 $00 $0 $3
	m_StandardWarp $4 $1c $01 $0 $3
	m_StandardWarp $4 $39 $02 $0 $3
	m_StandardWarp $4 $4b $03 $0 $3
	m_StandardWarp $4 $81 $04 $0 $3
	m_StandardWarp $4 $a7 $05 $0 $3
	m_StandardWarp $4 $ba $06 $0 $3
	m_StandardWarp $0 $07 $00 $6 $2
	m_StandardWarp $0 $0a $01 $6 $2
	m_StandardWarp $0 $1f $02 $6 $2
	m_StandardWarp $0 $32 $03 $6 $2
	m_StandardWarp $0 $33 $26 $0 $2
	m_StandardWarp $0 $37 $27 $0 $2
	m_StandardWarp $0 $3e $05 $6 $2
	m_PointerWarp     $3f warpSource7a5f
	m_PointerWarp     $41 warpSource7a67
	m_StandardWarp $0 $43 $19 $4 $2
	m_StandardWarp $0 $44 $06 $6 $2
	m_StandardWarp $0 $48 $1a $4 $2
	m_StandardWarp $0 $4a $1b $4 $2
	m_StandardWarp $0 $4f $0f $4 $2
	m_StandardWarp $0 $52 $11 $4 $2
	m_StandardWarp $0 $53 $13 $4 $2
	m_StandardWarp $0 $57 $15 $4 $2
	m_StandardWarp $0 $59 $16 $4 $2
	m_StandardWarp $0 $77 $1c $4 $2
	m_StandardWarp $0 $65 $1d $4 $2
	m_StandardWarp $0 $61 $1e $4 $2
	m_StandardWarp $0 $69 $1f $4 $2
	m_StandardWarp $0 $79 $20 $4 $2
	m_StandardWarp $0 $66 $21 $4 $2
	m_StandardWarp $0 $68 $08 $6 $2
	m_StandardWarp $0 $6d $09 $6 $2
	m_StandardWarp $0 $8e $0b $6 $2
	m_PointerWarp     $90 warpSource7a6f
	m_StandardWarp $0 $93 $0a $6 $2
	m_StandardWarp $0 $a1 $0c $6 $2
	m_StandardWarp $0 $9b $0f $6 $2
	m_StandardWarp $0 $aa $2e $4 $2
	m_StandardWarp $0 $ac $2f $4 $2
	m_StandardWarp $0 $ad $30 $4 $2
	m_StandardWarp $0 $b4 $31 $4 $2
	m_StandardWarp $0 $bc $2a $4 $2
	m_StandardWarp $0 $be $2b $4 $2
	m_StandardWarp $0 $bf $2c $4 $2
	m_StandardWarp $0 $c4 $2d $4 $2
	m_StandardWarp $0 $c5 $34 $4 $2
	m_StandardWarp $0 $cd $36 $4 $2
	m_StandardWarp $0 $ce $32 $4 $2
	m_StandardWarp $0 $d3 $38 $4 $2
	m_StandardWarp $0 $d4 $33 $4 $2
	m_StandardWarp $0 $d5 $1c $3 $2
	m_StandardWarp $0 $d6 $35 $4 $2
	m_StandardWarp $4 $e0 $0c $0 $3
	m_StandardWarp $4 $e1 $5a $0 $3
	m_PointerWarp     $e3 warpSource7a77
	m_PointerWarp     $e5 warpSource7a7f
	m_StandardWarp $0 $e6 $3d $4 $2
	m_StandardWarp $0 $e7 $23 $0 $2
	m_StandardWarp $8 $e8 $0a $2 $3
	m_StandardWarp $0 $e8 $44 $4 $2
	m_StandardWarp $8 $e9 $14 $2 $3
	m_StandardWarp $0 $e9 $42 $4 $2
	m_StandardWarp $4 $ea $1e $2 $3
	m_StandardWarp $4 $eb $67 $0 $3
	m_StandardWarp $4 $ed $5b $0 $3
	m_StandardWarp $4 $ee $28 $2 $3
	m_StandardWarp $4 $ef $01 $1 $3
	m_StandardWarp $4 $f0 $02 $1 $3
	m_StandardWarp $4 $f1 $03 $1 $3
	m_StandardWarp $0 $f2 $04 $1 $2
	m_StandardWarp $4 $f2 $05 $1 $3
	m_StandardWarp $4 $f3 $5d $0 $3
	m_StandardWarp $0 $f3 $5c $0 $4
	m_StandardWarp $0 $f4 $5e $0 $4
	m_StandardWarp $0 $f5 $5f $0 $4
	m_StandardWarp $0 $f6 $60 $0 $4
	m_StandardWarp $4 $f6 $61 $0 $3
	m_StandardWarp $0 $f7 $62 $0 $4
	m_StandardWarp $0 $f8 $63 $0 $4
	m_StandardWarp $4 $f9 $1b $1 $3
	m_StandardWarp $8 $f9 $1c $1 $3
	m_StandardWarp $4 $fa $64 $0 $3
	m_StandardWarp $4 $fb $65 $0 $3
	m_StandardWarp $4 $fc $66 $0 $3
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

warpSource7a5f:
	m_PositionWarp $52 $17 $4 $2
	m_PositionWarp $5d $07 $6 $2
	m_WarpListEndWithDefault

warpSource7a67:
	m_PositionWarp $1d $18 $4 $2
	m_PositionWarp $21 $04 $6 $2
	m_WarpListEndWithDefault

warpSource7a6f:
	m_PositionWarp $97 $0e $6 $2
	m_PositionWarp $9d $0d $6 $2
	m_WarpListEndWithDefault

warpSource7a77:
	m_PositionWarp $12 $24 $0 $2
	m_PositionWarp $7c $3e $4 $2
	m_WarpListEndWithDefault

warpSource7a7f:
	m_PositionWarp $7b $3f $4 $2
	m_PositionWarp $86 $3c $4 $2
	m_WarpListEndWithDefault


group5WarpSources:
	m_StandardWarp $4 $5b $07 $0 $3
	m_StandardWarp $4 $87 $00 $1 $3
	m_StandardWarp $4 $97 $08 $0 $3
	m_StandardWarp $4 $9d $09 $0 $3
	m_StandardWarp $0 $37 $17 $5 $2
	m_StandardWarp $0 $39 $18 $5 $2
	m_StandardWarp $0 $3c $1b $5 $2
	m_PointerWarp     $43 warpSource7cdb
	m_StandardWarp $0 $46 $2a $5 $2
	m_StandardWarp $0 $47 $05 $5 $2
	m_StandardWarp $0 $4a $06 $5 $2
	m_PointerWarp     $4b warpSource7d4b
	m_StandardWarp $0 $4c $07 $5 $2
	m_PointerWarp     $51 warpSource7d13
	m_StandardWarp $0 $53 $16 $5 $2
	m_PointerWarp     $57 warpSource7d53
	m_StandardWarp $0 $5e $39 $5 $2
	m_StandardWarp $0 $63 $01 $7 $2
	m_StandardWarp $0 $68 $3b $5 $2
	m_StandardWarp $0 $69 $00 $7 $2
	m_StandardWarp $0 $6a $3d $5 $2
	m_StandardWarp $0 $6b $3e $5 $2
	m_StandardWarp $0 $6c $3f $5 $2
	m_StandardWarp $0 $6e $40 $5 $2
	m_StandardWarp $0 $71 $41 $5 $2
	m_StandardWarp $0 $73 $42 $5 $2
	m_PointerWarp     $74 warpSource7d5b
	m_StandardWarp $0 $77 $2d $5 $2
	m_StandardWarp $0 $78 $02 $7 $2
	m_StandardWarp $0 $84 $2f $5 $2
	m_StandardWarp $0 $86 $03 $7 $2
	m_StandardWarp $0 $88 $31 $5 $2
	m_StandardWarp $0 $89 $32 $5 $2
	m_StandardWarp $0 $8a $33 $5 $2
	m_StandardWarp $0 $8b $34 $5 $2
	m_StandardWarp $0 $8c $35 $5 $2
	m_StandardWarp $0 $8d $36 $5 $2
	m_PointerWarp     $8e warpSource7d63
	m_StandardWarp $0 $67 $46 $5 $2
	m_StandardWarp $0 $83 $45 $5 $2
	m_StandardWarp $0 $9a $49 $5 $2
	m_StandardWarp $0 $9d $32 $2 $2
	m_StandardWarp $0 $9e $47 $5 $2
	m_StandardWarp $4 $30 $00 $0 $3
	m_StandardWarp $0 $31 $4b $5 $2
	m_StandardWarp $0 $33 $4a $5 $2
	m_StandardWarp $0 $2f $4d $5 $2
	m_StandardWarp $0 $29 $4c $5 $2
	m_StandardWarp $0 $28 $4f $5 $2
	m_StandardWarp $0 $20 $4e $5 $2
	m_StandardWarp $0 $24 $51 $5 $2
	m_StandardWarp $0 $26 $50 $5 $2
	m_StandardWarp $0 $27 $54 $5 $2
	m_StandardWarp $0 $34 $53 $5 $2
	m_StandardWarp $4 $b0 $2b $0 $3
	m_PointerWarp     $b0 warpSource7ca3
	m_PointerWarp     $b1 warpSource7cab
	m_StandardWarp $8 $b2 $2c $0 $3
	m_StandardWarp $0 $b2 $57 $5 $2
	m_StandardWarp $4 $b3 $28 $0 $3
	m_StandardWarp $8 $b3 $29 $0 $3
	m_StandardWarp $4 $b4 $25 $0 $3
	m_StandardWarp $4 $b5 $2e $0 $3
	m_StandardWarp $4 $b6 $2f $0 $3
	m_PointerWarp     $b7 warpSource7d6b
	m_StandardWarp $0 $b8 $61 $5 $2
	m_StandardWarp $8 $b9 $31 $0 $3
	m_StandardWarp $0 $ba $32 $0 $2
	m_StandardWarp $4 $ba $33 $0 $3
	m_StandardWarp $4 $bb $34 $0 $3
	m_PointerWarp     $be warpSource7d73
	m_PointerWarp     $bf warpSource7d7b
	m_StandardWarp $0 $c0 $6b $5 $2
	m_StandardWarp $4 $c1 $36 $0 $2
	m_StandardWarp $0 $c1 $70 $5 $2
	m_PointerWarp     $c2 warpSource7d83
	m_StandardWarp $0 $c3 $37 $0 $2
	m_StandardWarp $0 $c4 $38 $0 $2
	m_StandardWarp $4 $c6 $1a $1 $3
	m_StandardWarp $4 $c7 $3b $0 $3
	m_StandardWarp $8 $c8 $3c $0 $3
	m_StandardWarp $4 $c9 $3d $0 $3
	m_StandardWarp $4 $ca $3e $0 $3
	m_StandardWarp $0 $c8 $79 $5 $2
	m_PointerWarp     $c9 warpSource7cb3
	m_StandardWarp $0 $ca $7a $5 $2
	m_StandardWarp $4 $cb $40 $0 $3
	m_StandardWarp $8 $cb $41 $0 $3
	m_StandardWarp $0 $cb $3f $0 $2
	m_StandardWarp $4 $cc $44 $0 $3
	m_StandardWarp $0 $cc $43 $0 $2
	m_StandardWarp $4 $c5 $42 $0 $3
	m_PointerWarp     $cf warpSource7c9b
	m_StandardWarp $0 $d4 $55 $0 $2
	m_StandardWarp $0 $d0 $88 $5 $2
	m_StandardWarp $0 $d1 $88 $5 $2
	m_StandardWarp $0 $d2 $88 $5 $2
	m_StandardWarp $0 $d3 $85 $5 $2
	m_StandardWarp $4 $d3 $57 $0 $3
	m_StandardWarp $0 $01 $69 $0 $2
	m_StandardWarp $0 $02 $6a $0 $2
	m_StandardWarp $0 $03 $6b $0 $2
	m_StandardWarp $0 $04 $6c $0 $2
	m_StandardWarp $0 $05 $6d $0 $2
	m_StandardWarp $0 $06 $6e $0 $2
	m_StandardWarp $0 $07 $6f $0 $2
	m_StandardWarp $0 $08 $70 $0 $2
	m_StandardWarp $4 $09 $71 $0 $3
	m_StandardWarp $0 $0a $72 $0 $2
	m_StandardWarp $4 $0b $73 $0 $3
	m_StandardWarp $0 $0c $74 $0 $2
	m_StandardWarp $0 $0e $76 $0 $2
	m_StandardWarp $0 $0f $77 $0 $2
	m_StandardWarp $0 $10 $78 $0 $2
	m_StandardWarp $0 $11 $79 $0 $2
	m_StandardWarp $4 $12 $7a $0 $3
	m_StandardWarp $4 $f3 $23 $1 $3
	m_StandardWarp $4 $f6 $24 $1 $3
	m_StandardWarp $4 $f9 $25 $1 $3
	m_StandardWarp $4 $f0 $26 $1 $3
	m_StandardWarp $0 $f3 $a1 $5 $2
	m_PointerWarp     $f4 warpSource7cc3
	m_StandardWarp $0 $f5 $a2 $5 $2
	m_StandardWarp $0 $f6 $a5 $5 $2
	m_PointerWarp     $f7 warpSource7ccb
	m_StandardWarp $0 $f8 $a6 $5 $2
	m_StandardWarp $0 $f9 $a9 $5 $2
	m_PointerWarp     $fa warpSource7cd3
	m_StandardWarp $0 $fb $aa $5 $2
	m_StandardWarp $0 $f0 $ad $5 $2
	m_PointerWarp     $f1 warpSource7cbb
	m_StandardWarp $0 $f2 $ae $5 $2
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

warpSource7c9b:
	m_PositionWarp $97 $56 $0 $2
	m_PositionWarp $16 $1d $1 $2
	m_WarpListEndWithDefault

warpSource7ca3:
	m_PositionWarp $23 $59 $5 $2
	m_PositionWarp $3d $5b $5 $2
	m_WarpListEndWithDefault

warpSource7cab:
	m_PositionWarp $23 $56 $5 $2
	m_PositionWarp $78 $2a $0 $2
	m_WarpListEndWithDefault

warpSource7cb3:
	m_PositionWarp $1c $77 $5 $2
	m_PositionWarp $9d $7c $5 $2
	m_WarpListEndWithDefault

warpSource7cbb:
	m_PositionWarp $27 $ac $5 $2
	m_PositionWarp $87 $af $5 $2
	m_WarpListEndWithDefault

warpSource7cc3:
	m_PositionWarp $27 $a0 $5 $2
	m_PositionWarp $87 $a3 $5 $2
	m_WarpListEndWithDefault

warpSource7ccb:
	m_PositionWarp $27 $a4 $5 $2
	m_PositionWarp $87 $a7 $5 $2
	m_WarpListEndWithDefault

warpSource7cd3:
	m_PositionWarp $27 $a8 $5 $2
	m_PositionWarp $87 $ab $5 $2
	m_WarpListEndWithDefault

warpSource7cdb:
	m_PositionWarp $11 $1c $5 $2
	m_PositionWarp $16 $1d $5 $2
	m_PositionWarp $1b $1e $5 $2
	m_PositionWarp $41 $1f $5 $2
	m_PositionWarp $44 $20 $5 $2
	m_PositionWarp $46 $21 $5 $2
	m_PositionWarp $48 $22 $5 $2
	m_PositionWarp $4c $23 $5 $2
	m_PositionWarp $66 $24 $5 $2
	m_PositionWarp $69 $25 $5 $2
	m_PositionWarp $73 $26 $5 $2
	m_PositionWarp $7b $27 $5 $2
	m_PositionWarp $9d $28 $5 $2
	m_PositionWarp $91 $29 $5 $2
	m_WarpListEndWithDefault

warpSource7d13:
	m_PositionWarp $11 $08 $5 $2
	m_PositionWarp $16 $09 $5 $2
	m_PositionWarp $1b $0a $5 $2
	m_PositionWarp $41 $0b $5 $2
	m_PositionWarp $44 $0c $5 $2
	m_PositionWarp $46 $0d $5 $2
	m_PositionWarp $48 $0e $5 $2
	m_PositionWarp $4c $0f $5 $2
	m_PositionWarp $66 $10 $5 $2
	m_PositionWarp $69 $11 $5 $2
	m_PositionWarp $73 $12 $5 $2
	m_PositionWarp $7b $13 $5 $2
	m_PositionWarp $9d $14 $5 $2
	m_PositionWarp $91 $15 $5 $2
	m_WarpListEndWithDefault

warpSource7d4b:
	m_PositionWarp $82 $2b $5 $2
	m_PositionWarp $8c $2c $5 $2
	m_WarpListEndWithDefault

warpSource7d53:
	m_PositionWarp $82 $19 $5 $2
	m_PositionWarp $8c $1a $5 $2
	m_WarpListEndWithDefault

warpSource7d5b:
	m_PositionWarp $35 $43 $5 $2
	m_PositionWarp $6d $44 $5 $2
	m_WarpListEndWithDefault

warpSource7d63:
	m_PositionWarp $35 $37 $5 $2
	m_PositionWarp $6d $38 $5 $2
	m_WarpListEndWithDefault

warpSource7d6b:
	m_PositionWarp $24 $63 $5 $2
	m_PositionWarp $74 $30 $0 $2
	m_WarpListEndWithDefault

warpSource7d73:
	m_PositionWarp $34 $6a $5 $2
	m_PositionWarp $48 $35 $0 $2
	m_WarpListEndWithDefault

warpSource7d7b:
	m_PositionWarp $34 $68 $5 $2
	m_PositionWarp $7a $6c $5 $2
	m_WarpListEndWithDefault

warpSource7d83:
	m_PositionWarp $22 $39 $0 $2
	m_PositionWarp $3b $6e $5 $2
	m_WarpListEndWithDefault


group6WarpSources:
	m_StandardWarp $1 $01 $08 $4 $3
	m_StandardWarp $1 $09 $09 $4 $3
	m_StandardWarp $1 $1d $0a $4 $3
	m_StandardWarp $2 $1e $0b $4 $3
	m_StandardWarp $1 $3a $12 $4 $3
	m_StandardWarp $2 $3b $0e $4 $3
	m_StandardWarp $1 $3c $14 $4 $3
	m_StandardWarp $2 $3d $10 $4 $3
	m_StandardWarp $1 $5c $22 $4 $3
	m_StandardWarp $2 $5d $23 $4 $3
	m_StandardWarp $1 $84 $27 $4 $3
	m_StandardWarp $1 $85 $24 $4 $3
	m_StandardWarp $2 $86 $29 $4 $3
	m_StandardWarp $2 $87 $26 $4 $3
	m_StandardWarp $1 $a8 $25 $4 $3
	m_StandardWarp $2 $a9 $28 $4 $3
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault

group7WarpSources:
	m_StandardWarp $1 $5c $30 $5 $3
	m_StandardWarp $2 $5d $2e $5 $3
	m_StandardWarp $1 $60 $3a $5 $3
	m_StandardWarp $2 $62 $3c $5 $3
	m_StandardWarp $1 $e0 $49 $0 $3
	m_StandardWarp $2 $e1 $4a $0 $3
	m_StandardWarp $1 $e2 $1e $1 $3
	m_StandardWarp $1 $e3 $1f $1 $3
	m_StandardWarp $1 $e4 $68 $0 $3
	m_StandardWarp $1 $e6 $51 $4 $3
	m_StandardWarp $2 $e7 $53 $4 $3
	m_StandardWarp $1 $e8 $40 $3 $3
	m_StandardWarp $0 $b6 $7b $0 $4
	m_WarpListEndWithDefault
