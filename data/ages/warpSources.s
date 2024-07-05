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
	m_StandardWarp $4 $38 $06 $0 $3
	m_StandardWarp $8 $38 $06 $0 $3
	m_StandardWarp $1 $48 $07 $0 $3
	m_StandardWarp $2 $48 $07 $0 $3
	m_PointerWarp     $48 warpSource7706
	m_PointerWarp     $8d warpSource7716
	m_StandardWarp $0 $ba $04 $4 $4
	m_StandardWarp $0 $03 $05 $4 $4
	m_PointerWarp     $0a warpSource76aa
	m_StandardWarp $0 $02 $18 $3 $4
	m_StandardWarp $0 $04 $34 $3 $4
	m_StandardWarp $0 $12 $35 $3 $4
	m_StandardWarp $0 $14 $36 $3 $4
	m_StandardWarp $0 $06 $2d $2 $4
	m_PointerWarp     $09 warpSource769a
	m_PointerWarp     $0b warpSource76b2
	m_StandardWarp $0 $0c $09 $3 $4
	m_PointerWarp     $1b warpSource76ce
	m_PointerWarp     $1c warpSource76d6
	m_PointerWarp     $1d warpSource76de
	m_StandardWarp $0 $27 $39 $2 $4
	m_StandardWarp $0 $37 $3e $2 $4
	m_PointerWarp     $3d warpSource76f6
	m_StandardWarp $0 $45 $3e $3 $4
	m_PointerWarp     $47 warpSource76fe
	m_StandardWarp $0 $4d $09 $2 $4
	m_StandardWarp $0 $53 $32 $2 $4
	m_StandardWarp $0 $55 $3b $3 $4
	m_StandardWarp $0 $56 $01 $2 $4
	m_StandardWarp $0 $57 $3c $3 $4
	m_StandardWarp $0 $58 $3b $2 $4
	m_StandardWarp $0 $5d $37 $3 $4
	m_StandardWarp $0 $66 $33 $2 $4
	m_PointerWarp     $68 warpSource770e
	m_StandardWarp $0 $76 $43 $4 $4
	m_StandardWarp $0 $79 $18 $2 $4
	m_StandardWarp $0 $7c $05 $2 $4
	m_StandardWarp $0 $89 $17 $2 $4
	m_StandardWarp $0 $a3 $38 $3 $4
	m_StandardWarp $0 $bd $31 $2 $4
	m_StandardWarp $0 $c5 $27 $3 $4
	m_StandardWarp $0 $cd $29 $2 $4
	m_StandardWarp $0 $da $3a $3 $4
	m_StandardWarp $0 $dd $08 $2 $4
	m_StandardWarp $0 $3a $1a $3 $4
	m_PointerWarp     $38 warpSource76e6
	m_StandardWarp $0 $e0 $14 $2 $4
	m_PointerWarp     $e1 warpSource771e
	m_StandardWarp $0 $e2 $13 $2 $4
	m_StandardWarp $0 $f1 $3d $5 $4
	m_PointerWarp     $0d warpSource76be
	m_PointerWarp     $18 warpSource76c6
	m_StandardWarp $0 $28 $1f $5 $4
	m_StandardWarp $0 $2b $4e $5 $4
	m_StandardWarp $0 $3c $05 $1 $4
	m_StandardWarp $0 $5b $28 $5 $4
	m_StandardWarp $0 $a0 $33 $5 $4
	m_StandardWarp $0 $a5 $3e $5 $4
	m_WarpListEndNoDefault

warpSource769a:
	m_PositionWarp $44 $19 $2 $4
	m_PositionWarp $46 $1a $2 $4
	m_PositionWarp $37 $46 $5 $4
	m_PositionWarp $43 $00 $7 $4
	m_WarpListEndWithDefault

warpSource76aa:
	m_PositionWarp $12 $23 $2 $4
	m_PositionWarp $18 $06 $4 $4
	m_WarpListEndWithDefault

warpSource76b2:
	m_PositionWarp $27 $40 $2 $4
	m_PositionWarp $43 $43 $2 $4
	m_PositionWarp $41 $47 $5 $4
	m_WarpListEndWithDefault

warpSource76be:
	m_PositionWarp $42 $58 $5 $4
	m_PositionWarp $45 $59 $5 $4
	m_WarpListEndWithDefault

warpSource76c6:
	m_PositionWarp $04 $29 $5 $4
	m_PositionWarp $21 $2d $5 $4
	m_WarpListEndWithDefault

warpSource76ce:
	m_PositionWarp $08 $45 $2 $4
	m_PositionWarp $36 $0d $3 $4
	m_WarpListEndWithDefault

warpSource76d6:
	m_PositionWarp $43 $04 $3 $4
	m_PositionWarp $37 $12 $3 $4
	m_WarpListEndWithDefault

warpSource76de:
	m_PositionWarp $13 $45 $5 $4
	m_PositionWarp $27 $11 $3 $4
	m_WarpListEndWithDefault

warpSource76e6:
	m_PositionWarp $25 $3c $5 $4
	m_PositionWarp $26 $3c $5 $4
	m_PositionWarp $52 $0a $4 $4
	m_PositionWarp $57 $17 $5 $4
	m_WarpListEndWithDefault

warpSource76f6:
	m_PositionWarp $27 $48 $2 $4
	m_PositionWarp $13 $10 $3 $4
	m_WarpListEndWithDefault

warpSource76fe:
	m_PositionWarp $25 $37 $2 $4
	m_PositionWarp $27 $38 $2 $4
	m_WarpListEndWithDefault

warpSource7706:
	m_PositionWarp $21 $00 $4 $4
	m_PositionWarp $28 $07 $4 $4
	m_WarpListEndWithDefault

warpSource770e:
	m_PositionWarp $25 $0b $2 $4
	m_PositionWarp $27 $0c $2 $4
	m_WarpListFallThrough

warpSource7716:
	m_PositionWarp $26 $02 $4 $4
	m_PositionWarp $61 $66 $5 $4
	m_WarpListEndWithDefault

warpSource771e:
	m_PositionWarp $26 $10 $2 $4
	m_PositionWarp $53 $11 $2 $4
	m_WarpListEndWithDefault


group1WarpSources:
	m_StandardWarp $0 $48 $01 $4 $4
	m_StandardWarp $0 $83 $03 $4 $4
	m_StandardWarp $0 $5c $02 $5 $4
	m_StandardWarp $0 $38 $09 $4 $2
	m_StandardWarp $4 $38 $03 $1 $3
	m_StandardWarp $8 $38 $03 $1 $3
	m_StandardWarp $1 $48 $04 $1 $3
	m_StandardWarp $2 $48 $04 $1 $3
	m_StandardWarp $0 $0e $00 $5 $4
	m_StandardWarp $4 $0e $2a $0 $3
	m_StandardWarp $0 $02 $13 $3 $4
	m_StandardWarp $0 $05 $3f $5 $4
	m_StandardWarp $0 $06 $41 $5 $4
	m_StandardWarp $0 $07 $43 $5 $4
	m_StandardWarp $0 $09 $62 $5 $4
	m_PointerWarp     $0b warpSource7836
	m_StandardWarp $0 $0c $0b $3 $4
	m_StandardWarp $0 $0d $47 $2 $4
	m_StandardWarp $0 $04 $14 $3 $4
	m_StandardWarp $0 $12 $15 $3 $4
	m_StandardWarp $0 $13 $67 $5 $4
	m_StandardWarp $0 $14 $16 $3 $4
	m_StandardWarp $0 $18 $55 $5 $4
	m_StandardWarp $0 $1c $07 $3 $4
	m_StandardWarp $0 $1d $31 $3 $4
	m_StandardWarp $0 $23 $22 $3 $4
	m_StandardWarp $0 $28 $2f $5 $4
	m_StandardWarp $0 $2b $4c $5 $4
	m_StandardWarp $0 $2d $42 $2 $4
	m_StandardWarp $0 $39 $28 $0 $8
	m_PointerWarp     $3c warpSource783e
	m_StandardWarp $0 $3d $4b $2 $4
	m_StandardWarp $0 $43 $20 $3 $4
	m_StandardWarp $0 $45 $3f $3 $4
	m_StandardWarp $0 $4d $33 $3 $4
	m_StandardWarp $0 $51 $15 $2 $4
	m_StandardWarp $0 $55 $07 $2 $4
	m_StandardWarp $0 $56 $3d $2 $4
	m_StandardWarp $0 $57 $06 $2 $4
	m_PointerWarp     $58 warpSource7852
	m_StandardWarp $0 $5a $3f $2 $4
	m_StandardWarp $0 $66 $3d $3 $4
	m_PointerWarp     $70 warpSource7862
	m_StandardWarp $0 $71 $1e $5 $4
	m_StandardWarp $0 $72 $1b $5 $4
	m_StandardWarp $0 $74 $1a $5 $4
	m_StandardWarp $0 $79 $02 $2 $4
	m_StandardWarp $0 $91 $19 $5 $4
	m_StandardWarp $0 $a3 $39 $3 $4
	m_StandardWarp $0 $a5 $57 $5 $4
	m_PointerWarp     $a7 warpSource785a
	m_StandardWarp $0 $ad $30 $2 $4
	m_StandardWarp $0 $ba $6b $5 $4
	m_StandardWarp $0 $bb $5b $5 $4
	m_StandardWarp $0 $bc $36 $5 $4
	m_StandardWarp $0 $bd $2c $2 $4
	m_StandardWarp $0 $c5 $28 $3 $4
	m_StandardWarp $0 $cb $34 $5 $4
	m_PointerWarp     $cd warpSource786a
	m_StandardWarp $0 $d9 $51 $5 $4
	m_StandardWarp $0 $da $38 $5 $4
	m_StandardWarp $0 $db $39 $5 $4
	m_StandardWarp $0 $dd $6a $5 $4
	m_PointerWarp     $41 warpSource784a
	m_StandardWarp $0 $27 $48 $1 $2
	m_StandardWarp $0 $e2 $19 $1 $2
	m_StandardWarp $0 $e0 $42 $5 $2
	m_WarpListEndNoDefault

warpSource7836:
	m_PositionWarp $41 $63 $5 $4
	m_PositionWarp $27 $41 $2 $4
	m_WarpListEndWithDefault

warpSource783e:
	m_PositionWarp $33 $00 $3 $4
	m_PositionWarp $34 $01 $3 $4
	m_PositionWarp $35 $02 $3 $4
	m_WarpListEndWithDefault

warpSource784a:
	m_PositionWarp $51 $53 $5 $4
	m_PositionWarp $57 $54 $5 $4
	m_WarpListEndWithDefault

warpSource7852:
	m_PositionWarp $32 $36 $2 $4
	m_PositionWarp $35 $41 $3 $4
	m_WarpListEndWithDefault

warpSource785a:
	m_PositionWarp $24 $03 $2 $4
	m_PositionWarp $26 $04 $2 $4
	m_WarpListEndWithDefault

warpSource7862:
	m_PositionWarp $22 $1c $5 $4
	m_PositionWarp $27 $1d $5 $4
	m_WarpListEndWithDefault

warpSource786a:
	m_PositionWarp $34 $2e $2 $4
	m_PositionWarp $21 $27 $2 $4
	m_WarpListEndWithDefault


group2WarpSources:
	m_StandardWarp $0 $90 $01 $5 $4
	m_StandardWarp $4 $0e $33 $0 $3
	m_StandardWarp $4 $0f $34 $1 $3
	m_StandardWarp $4 $1e $38 $1 $3
	m_StandardWarp $4 $1f $39 $1 $3
	m_StandardWarp $0 $2e $3d $0 $4
	m_StandardWarp $4 $2f $29 $1 $3
	m_StandardWarp $8 $3e $27 $1 $3
	m_StandardWarp $4 $3f $47 $0 $3
	m_StandardWarp $0 $4e $30 $0 $4
	m_StandardWarp $4 $4f $25 $3 $3
	m_StandardWarp $4 $5e $39 $0 $3
	m_StandardWarp $8 $5e $3a $0 $3
	m_StandardWarp $0 $5e $0e $2 $2
	m_PointerWarp     $5f warpSource798a
	m_StandardWarp $4 $6e $4a $0 $3
	m_StandardWarp $4 $6f $49 $0 $3
	m_StandardWarp $0 $7e $0f $2 $2
	m_StandardWarp $4 $7f $4b $0 $3
	m_StandardWarp $4 $8e $48 $0 $3
	m_StandardWarp $4 $8f $26 $1 $3
	m_StandardWarp $0 $8f $52 $5 $2
	m_StandardWarp $4 $9e $3e $0 $3
	m_StandardWarp $0 $9e $3c $0 $4
	m_StandardWarp $0 $9f $1d $2 $2
	m_StandardWarp $4 $9f $0e $0 $3
	m_StandardWarp $8 $9f $0f $0 $3
	m_StandardWarp $0 $a1 $5d $5 $4
	m_PointerWarp     $ae warpSource7992
	m_StandardWarp $0 $af $1e $2 $2
	m_StandardWarp $0 $b7 $32 $3 $4
	m_StandardWarp $0 $ba $40 $3 $4
	m_StandardWarp $0 $be $03 $7 $2
	m_StandardWarp $0 $bf $06 $7 $2
	m_StandardWarp $4 $bf $12 $0 $3
	m_StandardWarp $0 $c0 $23 $3 $4
	m_StandardWarp $0 $c1 $2b $3 $4
	m_PointerWarp     $ce warpSource799a
	m_StandardWarp $4 $cf $45 $0 $3
	m_PointerWarp     $d0 warpSource79a2
	m_StandardWarp $4 $de $3e $1 $3
	m_StandardWarp $4 $df $0b $0 $3
	m_StandardWarp $4 $e3 $41 $1 $3
	m_StandardWarp $0 $e3 $28 $2 $2
	m_StandardWarp $4 $e4 $3a $1 $3
	m_StandardWarp $4 $e5 $43 $0 $3
	m_StandardWarp $8 $e6 $31 $0 $3
	m_StandardWarp $4 $e7 $38 $0 $3
	m_PointerWarp     $e8 warpSource79aa
	m_StandardWarp $4 $e9 $2a $1 $3
	m_StandardWarp $4 $ea $2e $0 $3
	m_StandardWarp $4 $eb $2f $0 $3
	m_StandardWarp $4 $ec $21 $0 $3
	m_StandardWarp $4 $ee $35 $0 $3
	m_StandardWarp $4 $f3 $28 $1 $3
	m_StandardWarp $4 $f4 $24 $0 $3
	m_StandardWarp $4 $f5 $2c $1 $3
	m_StandardWarp $4 $f6 $15 $0 $3
	m_StandardWarp $4 $f7 $0f $1 $3
	m_StandardWarp $4 $f8 $1c $1 $3
	m_StandardWarp $4 $f9 $14 $0 $3
	m_StandardWarp $0 $fa $46 $2 $2
	m_StandardWarp $0 $fb $44 $2 $2
	m_StandardWarp $4 $fb $1c $0 $3
	m_StandardWarp $4 $fc $11 $1 $3
	m_StandardWarp $8 $fd $2c $0 $3
	m_StandardWarp $0 $fd $49 $5 $2
	m_StandardWarp $8 $ff $20 $1 $3
	m_StandardWarp $0 $ff $4b $5 $2
	m_WarpListEndNoDefault

warpSource798a:
	m_PositionWarp $31 $0d $2 $2
	m_PositionWarp $11 $12 $2 $2
	m_WarpListEndWithDefault

warpSource7992:
	m_PositionWarp $15 $1b $2 $2
	m_PositionWarp $61 $1f $2 $2
	m_WarpListEndWithDefault

warpSource799a:
	m_PositionWarp $11 $42 $1 $4
	m_PositionWarp $18 $2f $2 $2
	m_WarpListEndWithDefault

warpSource79a2:
	m_PositionWarp $22 $2d $3 $4
	m_PositionWarp $25 $2e $3 $4
	m_WarpListEndWithDefault

warpSource79aa:
	m_PositionWarp $61 $64 $5 $2
	m_PositionWarp $68 $65 $5 $2
	; Last entry doesn't set the end bit like it should
	m_WarpListFallThrough


group3WarpSources:
	m_StandardWarp $0 $0f $06 $5 $4
	m_StandardWarp $4 $0f $1f $1 $3
	m_StandardWarp $8 $0f $1f $1 $3
	m_StandardWarp $4 $1e $1d $0 $3
	m_PointerWarp     $1e warpSource7aae
	m_StandardWarp $4 $1f $16 $1 $3
	m_StandardWarp $0 $1f $4a $5 $2
	m_StandardWarp $4 $2e $16 $0 $3
	m_StandardWarp $0 $2e $4f $5 $2
	m_StandardWarp $4 $2f $10 $1 $3
	m_StandardWarp $0 $2f $4d $5 $2
	m_StandardWarp $4 $3f $1b $0 $3
	m_PointerWarp     $4e warpSource7ab6
	m_StandardWarp $4 $4f $2b $0 $3
	m_StandardWarp $4 $5e $20 $0 $3
	m_StandardWarp $4 $5f $1e $0 $3
	m_StandardWarp $4 $6e $08 $1 $3
	m_StandardWarp $4 $6f $09 $1 $3
	m_StandardWarp $4 $7e $12 $1 $3
	m_StandardWarp $8 $7f $14 $1 $3
	m_StandardWarp $0 $8c $08 $7 $4
	m_StandardWarp $4 $8e $09 $0 $3
	m_StandardWarp $0 $8f $09 $7 $2
	m_StandardWarp $4 $9e $29 $0 $3
	m_StandardWarp $0 $9e $1c $3 $2
	m_PointerWarp     $9f warpSource7abe
	m_StandardWarp $0 $a1 $60 $5 $4
	m_StandardWarp $0 $ae $1d $3 $2
	m_StandardWarp $4 $af $23 $1 $3
	m_StandardWarp $0 $be $50 $5 $2
	m_StandardWarp $4 $be $18 $1 $3
	m_StandardWarp $4 $bf $25 $2 $3
	m_StandardWarp $0 $c1 $2c $3 $4
	m_StandardWarp $0 $c5 $0a $2 $4
	m_StandardWarp $0 $c7 $42 $3 $4
	m_StandardWarp $4 $ce $44 $0 $3
	m_StandardWarp $4 $cf $3f $1 $3
	m_PointerWarp     $d0 warpSource7ac6
	m_StandardWarp $4 $de $26 $2 $3
	m_StandardWarp $4 $df $24 $3 $3
	m_StandardWarp $4 $e3 $2a $2 $3
	m_StandardWarp $4 $e4 $2b $2 $3
	m_StandardWarp $4 $e5 $29 $3 $3
	m_StandardWarp $4 $e6 $2a $3 $3
	m_StandardWarp $4 $e7 $17 $1 $3
	m_StandardWarp $4 $e8 $20 $2 $3
	m_StandardWarp $0 $e9 $25 $1 $4
	m_StandardWarp $4 $ea $0a $0 $3
	m_StandardWarp $4 $eb $0c $0 $3
	m_StandardWarp $8 $ec $0d $0 $3
	m_StandardWarp $4 $ed $37 $0 $3
	m_StandardWarp $4 $ee $41 $0 $3
	m_StandardWarp $4 $ef $36 $1 $3
	m_StandardWarp $4 $f6 $46 $0 $3
	m_StandardWarp $4 $f7 $32 $0 $3
	m_StandardWarp $4 $f8 $34 $0 $3
	m_StandardWarp $4 $fa $2d $1 $3
	m_StandardWarp $4 $fb $2d $0 $3
	m_StandardWarp $4 $fc $24 $1 $3
	m_StandardWarp $4 $fd $21 $2 $3
	m_StandardWarp $4 $fe $2b $1 $3
	m_StandardWarp $4 $ff $26 $3 $3
	m_WarpListEndNoDefault

warpSource7aae:
	m_PositionWarp $12 $48 $5 $2
	m_PositionWarp $17 $0e $3 $2
	m_WarpListEndWithDefault

warpSource7ab6:
	m_PositionWarp $52 $06 $3 $2
	m_PositionWarp $27 $5a $5 $2
	m_WarpListEndWithDefault

warpSource7abe:
	m_PositionWarp $11 $1f $3 $2
	m_PositionWarp $22 $1b $3 $2
	m_WarpListEndWithDefault

warpSource7ac6:
	m_PositionWarp $22 $2f $3 $4
	m_PositionWarp $25 $30 $3 $4
	; Last entry doesn't set the end bit like it should
	m_WarpListFallThrough

group4WarpSources:
	m_StandardWarp $4 $24 $01 $0 $3
	m_StandardWarp $4 $46 $01 $1 $3
	m_StandardWarp $4 $66 $02 $0 $3
	m_StandardWarp $4 $91 $03 $0 $3
	m_StandardWarp $4 $bb $04 $0 $3
	m_StandardWarp $4 $ce $05 $0 $3
	m_StandardWarp $4 $04 $00 $0 $3
	m_StandardWarp $4 $0d $00 $1 $3
	m_StandardWarp $0 $09 $00 $6 $2
	m_StandardWarp $0 $07 $1d $1 $4
	m_StandardWarp $0 $01 $26 $0 $4
	m_StandardWarp $0 $1b $01 $6 $2
	m_StandardWarp $0 $32 $02 $6 $2
	m_PointerWarp     $37 warpSource7b8e
	m_StandardWarp $0 $47 $03 $6 $2
	m_StandardWarp $0 $48 $04 $6 $2
	m_StandardWarp $0 $6c $08 $6 $2
	m_StandardWarp $0 $86 $07 $6 $2
	m_StandardWarp $0 $99 $0f $6 $2
	m_StandardWarp $0 $9b $10 $6 $2
	m_StandardWarp $0 $a0 $0d $6 $2
	m_StandardWarp $0 $a2 $0a $6 $2
	m_StandardWarp $0 $a3 $0e $6 $2
	m_StandardWarp $0 $ad $0b $6 $2
	m_PointerWarp     $9c warpSource7c36
	m_PointerWarp     $a4 warpSource7c3e
	m_StandardWarp $0 $c2 $11 $6 $2
	m_StandardWarp $0 $c3 $12 $6 $2
	m_StandardWarp $4 $d0 $46 $4 $3
	m_PointerWarp     $d0 warpSource7b96
	m_PointerWarp     $d1 warpSource7bd2
	m_PointerWarp     $d2 warpSource7c12
	m_PointerWarp     $d3 warpSource7c1e
	m_StandardWarp $4 $e6 $3b $0 $3
	m_StandardWarp $8 $e6 $3b $0 $3
	m_StandardWarp $0 $e6 $15 $7 $2
	m_StandardWarp $4 $e7 $33 $1 $3
	m_StandardWarp $8 $e7 $33 $1 $3
	m_StandardWarp $0 $ea $1d $4 $4
	m_StandardWarp $0 $eb $4d $4 $2
	m_PointerWarp     $f0 warpSource7c2e
	m_StandardWarp $0 $f2 $4b $4 $2
	m_StandardWarp $0 $fb $4a $4 $2
	m_StandardWarp $0 $fd $47 $4 $2
	m_StandardWarp $4 $f3 $33 $1 $3
	m_StandardWarp $8 $f3 $33 $1 $3
	m_StandardWarp $4 $fe $49 $4 $3
	m_WarpListEndNoDefault

warpSource7b8e:
	m_PositionWarp $63 $05 $6 $2
	m_PositionWarp $6a $06 $6 $2
	m_WarpListEndWithDefault

warpSource7b96:
	m_PositionWarp $11 $2e $4 $2
	m_PositionWarp $17 $2f $4 $2
	m_PositionWarp $19 $30 $4 $2
	m_PositionWarp $1d $31 $4 $2
	m_PositionWarp $31 $32 $4 $2
	m_PositionWarp $35 $33 $4 $2
	m_PositionWarp $39 $34 $4 $2
	m_PositionWarp $51 $35 $4 $2
	m_PositionWarp $55 $36 $4 $2
	m_PositionWarp $59 $37 $4 $2
	m_PositionWarp $5d $38 $4 $2
	m_PositionWarp $71 $39 $4 $2
	m_PositionWarp $77 $3a $4 $2
	m_PositionWarp $91 $3b $4 $2
	m_PositionWarp $9d $3c $4 $2
	m_WarpListEndWithDefault

warpSource7bd2:
	m_PositionWarp $57 $3d $4 $2
	m_PositionWarp $11 $1e $4 $2
	m_PositionWarp $17 $1f $4 $2
	m_PositionWarp $19 $20 $4 $2
	m_PositionWarp $1d $21 $4 $2
	m_PositionWarp $31 $22 $4 $2
	m_PositionWarp $35 $23 $4 $2
	m_PositionWarp $39 $24 $4 $2
	m_PositionWarp $51 $25 $4 $2
	m_PositionWarp $55 $26 $4 $2
	m_PositionWarp $59 $27 $4 $2
	m_PositionWarp $5d $28 $4 $2
	m_PositionWarp $71 $29 $4 $2
	m_PositionWarp $77 $2a $4 $2
	m_PositionWarp $91 $2b $4 $2
	m_PositionWarp $9d $2c $4 $2
	m_WarpListEndWithDefault

warpSource7c12:
	m_PositionWarp $57 $2d $4 $2
	m_PositionWarp $8a $3f $4 $2
	m_PositionWarp $00 $41 $4 $2
	m_WarpListEndWithDefault

warpSource7c1e:
	m_PositionWarp $07 $48 $4 $2
	m_PositionWarp $57 $3e $4 $2
	m_PositionWarp $22 $2d $4 $2
	m_PositionWarp $2c $41 $4 $2
	m_WarpListEndWithDefault

warpSource7c2e:
	m_PositionWarp $77 $42 $4 $2
	m_PositionWarp $27 $4c $4 $4
	m_WarpListEndWithDefault

warpSource7c36:
	m_PositionWarp $87 $0c $6 $2
	m_WarpListEndNoDefault

warpSource7c3e:
	m_PositionWarp $64 $09 $6 $2
	m_WarpListEndNoDefault


group5WarpSources:
	m_StandardWarp $4 $26 $06 $1 $3
	m_StandardWarp $0 $20 $0e $7 $2
	m_StandardWarp $0 $25 $0d $7 $2
	m_StandardWarp $4 $44 $03 $3 $3
	m_StandardWarp $0 $33 $10 $7 $2
	m_StandardWarp $0 $35 $0f $7 $2
	m_StandardWarp $4 $56 $00 $2 $3
	m_StandardWarp $0 $4b $11 $7 $2
	m_StandardWarp $0 $4c $12 $7 $2
	m_StandardWarp $0 $4d $13 $7 $2
	m_StandardWarp $0 $4e $14 $7 $2
	m_StandardWarp $4 $aa $02 $1 $3
	m_PointerWarp     $79 warpSource7e06
	m_StandardWarp $0 $7e $1a $7 $2
	m_StandardWarp $0 $84 $19 $7 $2
	m_StandardWarp $0 $87 $18 $7 $2
	m_StandardWarp $0 $88 $17 $7 $2
	m_StandardWarp $0 $8a $1b $7 $2
	m_StandardWarp $0 $8c $16 $7 $2
	m_StandardWarp $0 $f1 $18 $5 $2
	m_StandardWarp $0 $f4 $27 $0 $2
	m_StandardWarp $0 $f5 $16 $5 $2
	m_StandardWarp $0 $b0 $35 $1 $4
	m_StandardWarp $0 $b2 $32 $1 $4
	m_StandardWarp $0 $b3 $31 $1 $4
	m_PointerWarp     $b4 warpSource7dba
	m_StandardWarp $0 $b5 $30 $1 $4
	m_StandardWarp $8 $b9 $22 $0 $3
	m_PointerWarp     $ba warpSource7dc2
	m_StandardWarp $0 $bb $2b $5 $2
	m_PointerWarp     $bc warpSource7dce
	m_StandardWarp $0 $be $36 $0 $4
	m_StandardWarp $4 $c0 $19 $0 $3
	m_PointerWarp     $c0 warpSource7dde
	m_StandardWarp $0 $c1 $25 $5 $2
	m_PointerWarp     $c2 warpSource7de6
	m_StandardWarp $8 $c3 $1a $1 $3
	m_StandardWarp $0 $c4 $32 $5 $2
	m_StandardWarp $0 $c5 $56 $5 $2
	m_StandardWarp $0 $c6 $30 $5 $2
	m_StandardWarp $4 $c7 $40 $0 $3
	m_StandardWarp $4 $cc $40 $1 $3
	m_PointerWarp     $cc warpSource7dee
	m_StandardWarp $4 $cd $44 $1 $3
	m_StandardWarp $8 $cd $45 $1 $3
	m_PointerWarp     $cd warpSource7df6
	m_StandardWarp $8 $cf $25 $0 $3
	m_StandardWarp $0 $cf $4c $0 $4
	m_StandardWarp $4 $d0 $42 $0 $3
	m_StandardWarp $4 $d1 $0a $1 $3
	m_StandardWarp $0 $d1 $44 $5 $2
	m_StandardWarp $0 $d2 $47 $1 $2
	m_StandardWarp $4 $d2 $0b $1 $3
	m_StandardWarp $4 $d3 $0c $1 $3
	m_StandardWarp $0 $d4 $40 $5 $2
	m_StandardWarp $4 $d8 $1f $0 $3
	m_StandardWarp $4 $da $10 $0 $3
	m_StandardWarp $8 $db $13 $0 $3
	m_StandardWarp $0 $dc $05 $3 $2
	m_StandardWarp $0 $dd $49 $2 $2
	m_StandardWarp $0 $de $08 $3 $2
	m_StandardWarp $0 $df $4c $2 $2
	m_StandardWarp $4 $e0 $1b $1 $3
	m_StandardWarp $0 $e1 $0c $3 $2
	m_StandardWarp $4 $e2 $23 $0 $3
	m_StandardWarp $0 $e3 $0a $3 $2
	m_StandardWarp $4 $e5 $0d $1 $3
	m_StandardWarp $8 $e6 $0e $1 $3
	m_StandardWarp $0 $e8 $21 $3 $2
	m_StandardWarp $4 $e9 $43 $1 $3
	m_StandardWarp $0 $ea $16 $2 $2
	m_StandardWarp $4 $ea $21 $1 $3
	m_StandardWarp $8 $ea $22 $1 $3
	m_StandardWarp $4 $eb $15 $1 $3
	m_StandardWarp $0 $eb $31 $5 $2
	m_StandardWarp $4 $ec $37 $1 $3
	m_StandardWarp $0 $ed $3f $0 $4
	m_StandardWarp $4 $ee $17 $0 $3
	m_StandardWarp $8 $ee $18 $0 $3
	m_StandardWarp $0 $ee $0f $3 $2
	m_StandardWarp $8 $ca $3c $1 $3
	m_StandardWarp $0 $ab $5e $5 $2
	m_StandardWarp $4 $ac $1c $2 $3
	m_StandardWarp $0 $ac $5c $5 $2
	m_StandardWarp $0 $ad $61 $5 $2
	m_StandardWarp $4 $ae $1e $3 $3
	m_StandardWarp $0 $ae $5f $5 $2
	m_StandardWarp $4 $f6 $13 $1 $3
	m_PointerWarp     $f6 warpSource7dfe
	m_StandardWarp $4 $f7 $46 $1 $3
	m_StandardWarp $4 $f9 $3b $1 $3
	m_StandardWarp $0 $fb $07 $7 $2
	m_WarpListEndNoDefault

warpSource7dba:
	m_PositionWarp $22 $2e $1 $4
	m_PositionWarp $8b $2f $1 $4
	m_WarpListEndWithDefault

warpSource7dc2:
	m_PositionWarp $82 $24 $5 $2
	m_PositionWarp $99 $26 $5 $2
	m_PositionWarp $2c $27 $5 $2
	m_WarpListEndWithDefault

warpSource7dce:
	m_PositionWarp $82 $20 $5 $2
	m_PositionWarp $27 $2c $5 $2
	m_PositionWarp $99 $21 $5 $2
	m_PositionWarp $2c $22 $5 $2
	m_WarpListEndWithDefault

warpSource7dde:
	m_PositionWarp $21 $2e $5 $2
	m_PositionWarp $57 $23 $5 $2
	m_WarpListEndWithDefault

warpSource7de6:
	m_PositionWarp $2b $2a $5 $2
	m_PositionWarp $24 $1a $0 $4
	m_WarpListEndWithDefault

warpSource7dee:
	m_PositionWarp $2d $0a $7 $2
	m_PositionWarp $1c $3d $1 $4
	m_WarpListEndWithDefault

warpSource7df6:
	m_PositionWarp $42 $0b $7 $2
	m_PositionWarp $49 $0c $7 $2
	m_WarpListEndWithDefault

warpSource7dfe:
	m_PositionWarp $93 $34 $2 $2
	m_PositionWarp $9b $35 $2 $2
	m_WarpListEndWithDefault

warpSource7e06:
	m_PositionWarp $57 $1c $7 $2
	m_WarpListEndNoDefault


group6WarpSources:
	m_StandardWarp $1 $05 $08 $4 $3
	m_StandardWarp $1 $10 $0b $4 $3
	m_StandardWarp $4 $27 $0c $4 $3
	m_StandardWarp $1 $29 $0f $4 $3
	m_StandardWarp $2 $2a $10 $4 $3
	m_StandardWarp $4 $2b $0d $4 $3
	m_StandardWarp $8 $2b $0e $4 $3
	m_StandardWarp $1 $68 $12 $4 $3
	m_StandardWarp $8 $68 $11 $4 $3
	m_StandardWarp $1 $93 $19 $4 $3
	m_StandardWarp $2 $94 $17 $4 $3
	m_StandardWarp $1 $95 $1a $4 $3
	m_StandardWarp $8 $96 $15 $4 $3
	m_StandardWarp $1 $97 $16 $4 $3
	m_StandardWarp $2 $97 $18 $4 $3
	m_StandardWarp $1 $98 $13 $4 $3
	m_StandardWarp $2 $98 $14 $4 $3
	m_StandardWarp $1 $c0 $1b $4 $3
	m_StandardWarp $2 $c0 $1c $4 $3
	m_WarpListEndNoDefault


group7WarpSources:
	m_StandardWarp $1 $01 $11 $0 $3
	m_StandardWarp $2 $01 $02 $7 $3
	m_StandardWarp $4 $02 $01 $7 $3
	m_StandardWarp $2 $02 $22 $2 $3
	m_StandardWarp $2 $03 $05 $7 $3
	m_StandardWarp $4 $04 $04 $7 $3
	m_StandardWarp $2 $04 $24 $2 $3
	m_StandardWarp $1 $08 $6c $5 $3
	m_StandardWarp $2 $08 $17 $3 $3
	m_StandardWarp $1 $09 $07 $1 $3
	m_StandardWarp $2 $0a $19 $3 $3
	m_StandardWarp $1 $05 $37 $5 $3
	m_StandardWarp $2 $05 $35 $5 $3
	m_StandardWarp $1 $07 $3a $5 $3
	m_StandardWarp $2 $07 $3b $5 $3
	m_StandardWarp $1 $10 $08 $5 $3
	m_StandardWarp $2 $11 $07 $5 $3
	m_StandardWarp $1 $29 $0a $5 $3
	m_StandardWarp $2 $2a $09 $5 $3
	m_StandardWarp $1 $47 $0b $5 $3
	m_StandardWarp $2 $48 $0c $5 $3
	m_StandardWarp $1 $49 $0d $5 $3
	m_StandardWarp $2 $4a $0e $5 $3
	m_StandardWarp $1 $73 $15 $5 $3
	m_StandardWarp $2 $73 $13 $5 $3
	m_StandardWarp $1 $74 $12 $5 $3
	m_StandardWarp $2 $74 $11 $5 $3
	m_StandardWarp $2 $75 $10 $5 $3
	m_StandardWarp $1 $76 $14 $5 $3
	m_StandardWarp $8 $76 $0f $5 $3
	m_StandardWarp $4 $ef $44 $4 $3
	m_WarpListEndNoDefault
