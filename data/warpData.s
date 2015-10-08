warpDataTable: ; $1359e
	.dw group0WarpData
	.dw group1WarpData
	.dw group2WarpData
	.dw group3WarpData
	.dw group4WarpData
	.dw group5WarpData
	.dw group6WarpData
	.dw group7WarpData

group0WarpData: ; $135ae
	m_StandardWarp $04 $38 $0 $3 $06
	m_StandardWarp $08 $38 $0 $3 $06
	m_StandardWarp $01 $48 $0 $3 $07
	m_StandardWarp $02 $48 $0 $3 $07
	m_PointerWarp  $40 $48 warpData7706
	m_PointerWarp  $40 $8d warpData7716
	m_StandardWarp $00 $ba $4 $4 $04
	m_StandardWarp $00 $03 $4 $4 $05
	m_PointerWarp  $40 $0a warpData76aa
	m_StandardWarp $00 $02 $3 $4 $18
	m_StandardWarp $00 $04 $3 $4 $34
	m_StandardWarp $00 $12 $3 $4 $35
	m_StandardWarp $00 $14 $3 $4 $36
	m_StandardWarp $00 $06 $2 $4 $2d
	m_PointerWarp  $40 $09 warpData769a
	m_PointerWarp  $40 $0b warpData76b2
	m_StandardWarp $00 $0c $3 $4 $09
	m_PointerWarp  $40 $1b warpData76ce
	m_PointerWarp  $40 $1c warpData76d6
	m_PointerWarp  $40 $1d warpData76de
	m_StandardWarp $00 $27 $2 $4 $39
	m_StandardWarp $00 $37 $2 $4 $3e
	m_PointerWarp  $40 $3d warpData76f6
	m_StandardWarp $00 $45 $3 $4 $3e
	m_PointerWarp  $40 $47 warpData76fe
	m_StandardWarp $00 $4d $2 $4 $09
	m_StandardWarp $00 $53 $2 $4 $32
	m_StandardWarp $00 $55 $3 $4 $3b
	m_StandardWarp $00 $56 $2 $4 $01
	m_StandardWarp $00 $57 $3 $4 $3c
	m_StandardWarp $00 $58 $2 $4 $3b
	m_StandardWarp $00 $5d $3 $4 $37
	m_StandardWarp $00 $66 $2 $4 $33
	m_PointerWarp  $40 $68 warpData770e
	m_StandardWarp $00 $76 $4 $4 $43
	m_StandardWarp $00 $79 $2 $4 $18
	m_StandardWarp $00 $7c $2 $4 $05
	m_StandardWarp $00 $89 $2 $4 $17
	m_StandardWarp $00 $a3 $3 $4 $38
	m_StandardWarp $00 $bd $2 $4 $31
	m_StandardWarp $00 $c5 $3 $4 $27
	m_StandardWarp $00 $cd $2 $4 $29
	m_StandardWarp $00 $da $3 $4 $3a
	m_StandardWarp $00 $dd $2 $4 $08
	m_StandardWarp $00 $3a $3 $4 $1a
	m_PointerWarp  $40 $38 warpData76e6
	m_StandardWarp $00 $e0 $2 $4 $14
	m_PointerWarp  $40 $e1 warpData771e
	m_StandardWarp $00 $e2 $2 $4 $13
	m_StandardWarp $00 $f1 $5 $4 $3d
	m_PointerWarp  $40 $0d warpData76be
	m_PointerWarp  $40 $18 warpData76c6
	m_StandardWarp $00 $28 $5 $4 $1f
	m_StandardWarp $00 $2b $5 $4 $4e
	m_StandardWarp $00 $3c $1 $4 $05
	m_StandardWarp $00 $5b $5 $4 $28
	m_StandardWarp $00 $a0 $5 $4 $33
	m_StandardWarp $00 $a5 $5 $4 $3e

	m_WarpDataEnd

warpData769a:
	m_StandardWarp $00 $44 $2 $4 $19
warpData76aa:
	m_StandardWarp $00 $12 $2 $4 $23
warpData76b2:
	m_StandardWarp $00 $27 $2 $4 $40
warpData76be:
	m_StandardWarp $00 $42 $5 $4 $58
warpData76c6:
	m_StandardWarp $00 $04 $5 $4 $29
warpData76ce:
	m_StandardWarp $00 $08 $2 $4 $45
warpData76d6:
	m_StandardWarp $00 $43 $3 $4 $04
warpData76de:
	m_StandardWarp $00 $13 $5 $4 $45
warpData76e6:
	m_StandardWarp $00 $25 $5 $4 $3c
warpData76f6:
	m_StandardWarp $00 $27 $2 $4 $48
warpData76fe:
	m_StandardWarp $00 $25 $2 $4 $37
warpData7706:
	m_StandardWarp $00 $21 $4 $4 $00
warpData770e:
	m_StandardWarp $00 $25 $2 $4 $0b
warpData7716:
	m_StandardWarp $00 $26 $4 $4 $02
warpData771e:
	m_StandardWarp $00 $26 $2 $4 $10

	m_WarpDataEnd


; End at $1369a

group1WarpData: ; $13726
	m_StandardWarp $00 $48 $4 $4 $01
	m_StandardWarp $00 $83 $4 $4 $03
	m_StandardWarp $00 $5c $5 $4 $02
	m_StandardWarp $00 $38 $4 $2 $09
	m_StandardWarp $04 $38 $1 $3 $03
	m_StandardWarp $08 $38 $1 $3 $03
	m_StandardWarp $01 $48 $1 $3 $04
	m_StandardWarp $02 $48 $1 $3 $04
	m_StandardWarp $00 $0e $5 $4 $00
	m_StandardWarp $04 $0e $0 $3 $2a
	m_StandardWarp $00 $02 $3 $4 $13
	m_StandardWarp $00 $05 $5 $4 $3f
	m_StandardWarp $00 $06 $5 $4 $41
	m_StandardWarp $00 $07 $5 $4 $43
	m_StandardWarp $00 $09 $5 $4 $62
	m_PointerWarp  $40 $0b warpData7836
	m_StandardWarp $00 $0c $3 $4 $0b
	m_StandardWarp $00 $0d $2 $4 $47
	m_StandardWarp $00 $04 $3 $4 $14
	m_StandardWarp $00 $12 $3 $4 $15
	m_StandardWarp $00 $13 $5 $4 $67
	m_StandardWarp $00 $14 $3 $4 $16
	m_StandardWarp $00 $18 $5 $4 $55
	m_StandardWarp $00 $1c $3 $4 $07
	m_StandardWarp $00 $1d $3 $4 $31
	m_StandardWarp $00 $23 $3 $4 $22
	m_StandardWarp $00 $28 $5 $4 $2f
	m_StandardWarp $00 $2b $5 $4 $4c
	m_StandardWarp $00 $2d $2 $4 $42
	m_StandardWarp $00 $39 $0 $8 $28
	m_PointerWarp  $40 $3c warpData783e
	m_StandardWarp $00 $3d $2 $4 $4b
	m_StandardWarp $00 $43 $3 $4 $20
	m_StandardWarp $00 $45 $3 $4 $3f
	m_StandardWarp $00 $4d $3 $4 $33
	m_StandardWarp $00 $51 $2 $4 $15
	m_StandardWarp $00 $55 $2 $4 $07
	m_StandardWarp $00 $56 $2 $4 $3d
	m_StandardWarp $00 $57 $2 $4 $06
	m_PointerWarp  $40 $58 warpData7852
	m_StandardWarp $00 $5a $2 $4 $3f
	m_StandardWarp $00 $66 $3 $4 $3d
	m_PointerWarp  $40 $70 warpData7862
	m_StandardWarp $00 $71 $5 $4 $1e
	m_StandardWarp $00 $72 $5 $4 $1b
	m_StandardWarp $00 $74 $5 $4 $1a
	m_StandardWarp $00 $79 $2 $4 $02
	m_StandardWarp $00 $91 $5 $4 $19
	m_StandardWarp $00 $a3 $3 $4 $39
	m_StandardWarp $00 $a5 $5 $4 $57
	m_PointerWarp  $40 $a7 warpData785a
	m_StandardWarp $00 $ad $2 $4 $30
	m_StandardWarp $00 $ba $5 $4 $6b
	m_StandardWarp $00 $bb $5 $4 $5b
	m_StandardWarp $00 $bc $5 $4 $36
	m_StandardWarp $00 $bd $2 $4 $2c
	m_StandardWarp $00 $c5 $3 $4 $28
	m_StandardWarp $00 $cb $5 $4 $34
	m_PointerWarp  $40 $cd warpData786a
	m_StandardWarp $00 $d9 $5 $4 $51
	m_StandardWarp $00 $da $5 $4 $38
	m_StandardWarp $00 $db $5 $4 $39
	m_StandardWarp $00 $dd $5 $4 $6a
	m_PointerWarp  $40 $41 warpData784a
	m_StandardWarp $00 $27 $1 $2 $48
	m_StandardWarp $00 $e2 $1 $2 $19
	m_StandardWarp $00 $e0 $5 $2 $42

	m_WarpDataEnd

warpData7836:
	m_StandardWarp $00 $41 $5 $4 $63
warpData783e:
	m_StandardWarp $00 $33 $3 $4 $00
warpData784a:
	m_StandardWarp $00 $51 $5 $4 $53
warpData7852:
	m_StandardWarp $00 $32 $2 $4 $36
warpData785a:
	m_StandardWarp $00 $24 $2 $4 $03
warpData7862:
	m_StandardWarp $00 $22 $5 $4 $1c
warpData786a:
	m_StandardWarp $00 $34 $2 $4 $2e

	m_WarpDataEnd


; End at $13836

group2WarpData: ; $13872
	m_StandardWarp $00 $90 $5 $4 $01
	m_StandardWarp $04 $0e $0 $3 $33
	m_StandardWarp $04 $0f $1 $3 $34
	m_StandardWarp $04 $1e $1 $3 $38
	m_StandardWarp $04 $1f $1 $3 $39
	m_StandardWarp $00 $2e $0 $4 $3d
	m_StandardWarp $04 $2f $1 $3 $29
	m_StandardWarp $08 $3e $1 $3 $27
	m_StandardWarp $04 $3f $0 $3 $47
	m_StandardWarp $00 $4e $0 $4 $30
	m_StandardWarp $04 $4f $3 $3 $25
	m_StandardWarp $04 $5e $0 $3 $39
	m_StandardWarp $08 $5e $0 $3 $3a
	m_StandardWarp $00 $5e $2 $2 $0e
	m_PointerWarp  $40 $5f warpData798a
	m_StandardWarp $04 $6e $0 $3 $4a
	m_StandardWarp $04 $6f $0 $3 $49
	m_StandardWarp $00 $7e $2 $2 $0f
	m_StandardWarp $04 $7f $0 $3 $4b
	m_StandardWarp $04 $8e $0 $3 $48
	m_StandardWarp $04 $8f $1 $3 $26
	m_StandardWarp $00 $8f $5 $2 $52
	m_StandardWarp $04 $9e $0 $3 $3e
	m_StandardWarp $00 $9e $0 $4 $3c
	m_StandardWarp $00 $9f $2 $2 $1d
	m_StandardWarp $04 $9f $0 $3 $0e
	m_StandardWarp $08 $9f $0 $3 $0f
	m_StandardWarp $00 $a1 $5 $4 $5d
	m_PointerWarp  $40 $ae warpData7992
	m_StandardWarp $00 $af $2 $2 $1e
	m_StandardWarp $00 $b7 $3 $4 $32
	m_StandardWarp $00 $ba $3 $4 $40
	m_StandardWarp $00 $be $7 $2 $03
	m_StandardWarp $00 $bf $7 $2 $06
	m_StandardWarp $04 $bf $0 $3 $12
	m_StandardWarp $00 $c0 $3 $4 $23
	m_StandardWarp $00 $c1 $3 $4 $2b
	m_PointerWarp  $40 $ce warpData799a
	m_StandardWarp $04 $cf $0 $3 $45
	m_PointerWarp  $40 $d0 warpData79a2
	m_StandardWarp $04 $de $1 $3 $3e
	m_StandardWarp $04 $df $0 $3 $0b
	m_StandardWarp $04 $e3 $1 $3 $41
	m_StandardWarp $00 $e3 $2 $2 $28
	m_StandardWarp $04 $e4 $1 $3 $3a
	m_StandardWarp $04 $e5 $0 $3 $43
	m_StandardWarp $08 $e6 $0 $3 $31
	m_StandardWarp $04 $e7 $0 $3 $38
	m_PointerWarp  $40 $e8 warpData79aa
	m_StandardWarp $04 $e9 $1 $3 $2a
	m_StandardWarp $04 $ea $0 $3 $2e
	m_StandardWarp $04 $eb $0 $3 $2f
	m_StandardWarp $04 $ec $0 $3 $21
	m_StandardWarp $04 $ee $0 $3 $35
	m_StandardWarp $04 $f3 $1 $3 $28
	m_StandardWarp $04 $f4 $0 $3 $24
	m_StandardWarp $04 $f5 $1 $3 $2c
	m_StandardWarp $04 $f6 $0 $3 $15
	m_StandardWarp $04 $f7 $1 $3 $0f
	m_StandardWarp $04 $f8 $1 $3 $1c
	m_StandardWarp $04 $f9 $0 $3 $14
	m_StandardWarp $00 $fa $2 $2 $46
	m_StandardWarp $00 $fb $2 $2 $44
	m_StandardWarp $04 $fb $0 $3 $1c
	m_StandardWarp $04 $fc $1 $3 $11
	m_StandardWarp $08 $fd $0 $3 $2c
	m_StandardWarp $00 $fd $5 $2 $49
	m_StandardWarp $08 $ff $1 $3 $20
	m_StandardWarp $00 $ff $5 $2 $4b

	m_WarpDataEnd

warpData798a:
	m_StandardWarp $00 $31 $2 $2 $0d
warpData7992:
	m_StandardWarp $00 $15 $2 $2 $1b
warpData799a:
	m_StandardWarp $00 $11 $1 $4 $42
warpData79a2:
	m_StandardWarp $00 $22 $3 $4 $2d
warpData79aa:
	m_StandardWarp $00 $61 $5 $2 $64

	m_WarpDataEnd


; End at $1398a

group3WarpData: ; $139b2
	m_StandardWarp $00 $0f $5 $4 $06
	m_StandardWarp $04 $0f $1 $3 $1f
	m_StandardWarp $08 $0f $1 $3 $1f
	m_StandardWarp $04 $1e $0 $3 $1d
	m_PointerWarp  $40 $1e warpData7aae
	m_StandardWarp $04 $1f $1 $3 $16
	m_StandardWarp $00 $1f $5 $2 $4a
	m_StandardWarp $04 $2e $0 $3 $16
	m_StandardWarp $00 $2e $5 $2 $4f
	m_StandardWarp $04 $2f $1 $3 $10
	m_StandardWarp $00 $2f $5 $2 $4d
	m_StandardWarp $04 $3f $0 $3 $1b
	m_PointerWarp  $40 $4e warpData7ab6
	m_StandardWarp $04 $4f $0 $3 $2b
	m_StandardWarp $04 $5e $0 $3 $20
	m_StandardWarp $04 $5f $0 $3 $1e
	m_StandardWarp $04 $6e $1 $3 $08
	m_StandardWarp $04 $6f $1 $3 $09
	m_StandardWarp $04 $7e $1 $3 $12
	m_StandardWarp $08 $7f $1 $3 $14
	m_StandardWarp $00 $8c $7 $4 $08
	m_StandardWarp $04 $8e $0 $3 $09
	m_StandardWarp $00 $8f $7 $2 $09
	m_StandardWarp $04 $9e $0 $3 $29
	m_StandardWarp $00 $9e $3 $2 $1c
	m_PointerWarp  $40 $9f warpData7abe
	m_StandardWarp $00 $a1 $5 $4 $60
	m_StandardWarp $00 $ae $3 $2 $1d
	m_StandardWarp $04 $af $1 $3 $23
	m_StandardWarp $00 $be $5 $2 $50
	m_StandardWarp $04 $be $1 $3 $18
	m_StandardWarp $04 $bf $2 $3 $25
	m_StandardWarp $00 $c1 $3 $4 $2c
	m_StandardWarp $00 $c5 $2 $4 $0a
	m_StandardWarp $00 $c7 $3 $4 $42
	m_StandardWarp $04 $ce $0 $3 $44
	m_StandardWarp $04 $cf $1 $3 $3f
	m_PointerWarp  $40 $d0 warpData7ac6
	m_StandardWarp $04 $de $2 $3 $26
	m_StandardWarp $04 $df $3 $3 $24
	m_StandardWarp $04 $e3 $2 $3 $2a
	m_StandardWarp $04 $e4 $2 $3 $2b
	m_StandardWarp $04 $e5 $3 $3 $29
	m_StandardWarp $04 $e6 $3 $3 $2a
	m_StandardWarp $04 $e7 $1 $3 $17
	m_StandardWarp $04 $e8 $2 $3 $20
	m_StandardWarp $00 $e9 $1 $4 $25
	m_StandardWarp $04 $ea $0 $3 $0a
	m_StandardWarp $04 $eb $0 $3 $0c
	m_StandardWarp $08 $ec $0 $3 $0d
	m_StandardWarp $04 $ed $0 $3 $37
	m_StandardWarp $04 $ee $0 $3 $41
	m_StandardWarp $04 $ef $1 $3 $36
	m_StandardWarp $04 $f6 $0 $3 $46
	m_StandardWarp $04 $f7 $0 $3 $32
	m_StandardWarp $04 $f8 $0 $3 $34
	m_StandardWarp $04 $fa $1 $3 $2d
	m_StandardWarp $04 $fb $0 $3 $2d
	m_StandardWarp $04 $fc $1 $3 $24
	m_StandardWarp $04 $fd $2 $3 $21
	m_StandardWarp $04 $fe $1 $3 $2b
	m_StandardWarp $04 $ff $3 $3 $26

	m_WarpDataEnd

warpData7aae:
	m_StandardWarp $00 $12 $5 $2 $48
warpData7ab6:
	m_StandardWarp $00 $52 $3 $2 $06
warpData7abe:
	m_StandardWarp $00 $11 $3 $2 $1f
warpData7ac6:
	m_StandardWarp $00 $22 $3 $4 $2f

	m_WarpDataEnd


; End at $13aae

group4WarpData: ; $13ace
	m_StandardWarp $04 $24 $0 $3 $01
	m_StandardWarp $04 $46 $1 $3 $01
	m_StandardWarp $04 $66 $0 $3 $02
	m_StandardWarp $04 $91 $0 $3 $03
	m_StandardWarp $04 $bb $0 $3 $04
	m_StandardWarp $04 $ce $0 $3 $05
	m_StandardWarp $04 $04 $0 $3 $00
	m_StandardWarp $04 $0d $1 $3 $00
	m_StandardWarp $00 $09 $6 $2 $00
	m_StandardWarp $00 $07 $1 $4 $1d
	m_StandardWarp $00 $01 $0 $4 $26
	m_StandardWarp $00 $1b $6 $2 $01
	m_StandardWarp $00 $32 $6 $2 $02
	m_PointerWarp  $40 $37 warpData7b8e
	m_StandardWarp $00 $47 $6 $2 $03
	m_StandardWarp $00 $48 $6 $2 $04
	m_StandardWarp $00 $6c $6 $2 $08
	m_StandardWarp $00 $86 $6 $2 $07
	m_StandardWarp $00 $99 $6 $2 $0f
	m_StandardWarp $00 $9b $6 $2 $10
	m_StandardWarp $00 $a0 $6 $2 $0d
	m_StandardWarp $00 $a2 $6 $2 $0a
	m_StandardWarp $00 $a3 $6 $2 $0e
	m_StandardWarp $00 $ad $6 $2 $0b
	m_PointerWarp  $40 $9c warpData7c36
	m_PointerWarp  $40 $a4 warpData7c3e
	m_StandardWarp $00 $c2 $6 $2 $11
	m_StandardWarp $00 $c3 $6 $2 $12
	m_StandardWarp $04 $d0 $4 $3 $46
	m_PointerWarp  $40 $d0 warpData7b96
	m_PointerWarp  $40 $d1 warpData7bd2
	m_PointerWarp  $40 $d2 warpData7c12
	m_PointerWarp  $40 $d3 warpData7c1e
	m_StandardWarp $04 $e6 $0 $3 $3b
	m_StandardWarp $08 $e6 $0 $3 $3b
	m_StandardWarp $00 $e6 $7 $2 $15
	m_StandardWarp $04 $e7 $1 $3 $33
	m_StandardWarp $08 $e7 $1 $3 $33
	m_StandardWarp $00 $ea $4 $4 $1d
	m_StandardWarp $00 $eb $4 $2 $4d
	m_PointerWarp  $40 $f0 warpData7c2e
	m_StandardWarp $00 $f2 $4 $2 $4b
	m_StandardWarp $00 $fb $4 $2 $4a
	m_StandardWarp $00 $fd $4 $2 $47
	m_StandardWarp $04 $f3 $1 $3 $33
	m_StandardWarp $08 $f3 $1 $3 $33
	m_StandardWarp $04 $fe $4 $3 $49

	m_WarpDataEnd

warpData7b8e:
	m_StandardWarp $00 $63 $6 $2 $05
warpData7b96:
	m_StandardWarp $00 $11 $4 $2 $2e
warpData7bd2:
	m_StandardWarp $00 $57 $4 $2 $3d
warpData7c12:
	m_StandardWarp $00 $57 $4 $2 $2d
warpData7c1e:
	m_StandardWarp $00 $07 $4 $2 $48
warpData7c2e:
	m_StandardWarp $00 $77 $4 $2 $42
warpData7c36:
	m_StandardWarp $00 $87 $6 $2 $0c
warpData7c3e:
	m_StandardWarp $00 $64 $6 $2 $09

	m_WarpDataEnd


; End at $13b8e

group5WarpData: ; $13c46
	m_StandardWarp $04 $26 $1 $3 $06
	m_StandardWarp $00 $20 $7 $2 $0e
	m_StandardWarp $00 $25 $7 $2 $0d
	m_StandardWarp $04 $44 $3 $3 $03
	m_StandardWarp $00 $33 $7 $2 $10
	m_StandardWarp $00 $35 $7 $2 $0f
	m_StandardWarp $04 $56 $2 $3 $00
	m_StandardWarp $00 $4b $7 $2 $11
	m_StandardWarp $00 $4c $7 $2 $12
	m_StandardWarp $00 $4d $7 $2 $13
	m_StandardWarp $00 $4e $7 $2 $14
	m_StandardWarp $04 $aa $1 $3 $02
	m_PointerWarp  $40 $79 warpData7e06
	m_StandardWarp $00 $7e $7 $2 $1a
	m_StandardWarp $00 $84 $7 $2 $19
	m_StandardWarp $00 $87 $7 $2 $18
	m_StandardWarp $00 $88 $7 $2 $17
	m_StandardWarp $00 $8a $7 $2 $1b
	m_StandardWarp $00 $8c $7 $2 $16
	m_StandardWarp $00 $f1 $5 $2 $18
	m_StandardWarp $00 $f4 $0 $2 $27
	m_StandardWarp $00 $f5 $5 $2 $16
	m_StandardWarp $00 $b0 $1 $4 $35
	m_StandardWarp $00 $b2 $1 $4 $32
	m_StandardWarp $00 $b3 $1 $4 $31
	m_PointerWarp  $40 $b4 warpData7dba
	m_StandardWarp $00 $b5 $1 $4 $30
	m_StandardWarp $08 $b9 $0 $3 $22
	m_PointerWarp  $40 $ba warpData7dc2
	m_StandardWarp $00 $bb $5 $2 $2b
	m_PointerWarp  $40 $bc warpData7dce
	m_StandardWarp $00 $be $0 $4 $36
	m_StandardWarp $04 $c0 $0 $3 $19
	m_PointerWarp  $40 $c0 warpData7dde
	m_StandardWarp $00 $c1 $5 $2 $25
	m_PointerWarp  $40 $c2 warpData7de6
	m_StandardWarp $08 $c3 $1 $3 $1a
	m_StandardWarp $00 $c4 $5 $2 $32
	m_StandardWarp $00 $c5 $5 $2 $56
	m_StandardWarp $00 $c6 $5 $2 $30
	m_StandardWarp $04 $c7 $0 $3 $40
	m_StandardWarp $04 $cc $1 $3 $40
	m_PointerWarp  $40 $cc warpData7dee
	m_StandardWarp $04 $cd $1 $3 $44
	m_StandardWarp $08 $cd $1 $3 $45
	m_PointerWarp  $40 $cd warpData7df6
	m_StandardWarp $08 $cf $0 $3 $25
	m_StandardWarp $00 $cf $0 $4 $4c
	m_StandardWarp $04 $d0 $0 $3 $42
	m_StandardWarp $04 $d1 $1 $3 $0a
	m_StandardWarp $00 $d1 $5 $2 $44
	m_StandardWarp $00 $d2 $1 $2 $47
	m_StandardWarp $04 $d2 $1 $3 $0b
	m_StandardWarp $04 $d3 $1 $3 $0c
	m_StandardWarp $00 $d4 $5 $2 $40
	m_StandardWarp $04 $d8 $0 $3 $1f
	m_StandardWarp $04 $da $0 $3 $10
	m_StandardWarp $08 $db $0 $3 $13
	m_StandardWarp $00 $dc $3 $2 $05
	m_StandardWarp $00 $dd $2 $2 $49
	m_StandardWarp $00 $de $3 $2 $08
	m_StandardWarp $00 $df $2 $2 $4c
	m_StandardWarp $04 $e0 $1 $3 $1b
	m_StandardWarp $00 $e1 $3 $2 $0c
	m_StandardWarp $04 $e2 $0 $3 $23
	m_StandardWarp $00 $e3 $3 $2 $0a
	m_StandardWarp $04 $e5 $1 $3 $0d
	m_StandardWarp $08 $e6 $1 $3 $0e
	m_StandardWarp $00 $e8 $3 $2 $21
	m_StandardWarp $04 $e9 $1 $3 $43
	m_StandardWarp $00 $ea $2 $2 $16
	m_StandardWarp $04 $ea $1 $3 $21
	m_StandardWarp $08 $ea $1 $3 $22
	m_StandardWarp $04 $eb $1 $3 $15
	m_StandardWarp $00 $eb $5 $2 $31
	m_StandardWarp $04 $ec $1 $3 $37
	m_StandardWarp $00 $ed $0 $4 $3f
	m_StandardWarp $04 $ee $0 $3 $17
	m_StandardWarp $08 $ee $0 $3 $18
	m_StandardWarp $00 $ee $3 $2 $0f
	m_StandardWarp $08 $ca $1 $3 $3c
	m_StandardWarp $00 $ab $5 $2 $5e
	m_StandardWarp $04 $ac $2 $3 $1c
	m_StandardWarp $00 $ac $5 $2 $5c
	m_StandardWarp $00 $ad $5 $2 $61
	m_StandardWarp $04 $ae $3 $3 $1e
	m_StandardWarp $00 $ae $5 $2 $5f
	m_StandardWarp $04 $f6 $1 $3 $13
	m_PointerWarp  $40 $f6 warpData7dfe
	m_StandardWarp $04 $f7 $1 $3 $46
	m_StandardWarp $04 $f9 $1 $3 $3b
	m_StandardWarp $00 $fb $7 $2 $07

	m_WarpDataEnd

warpData7dba:
	m_StandardWarp $00 $22 $1 $4 $2e
warpData7dc2:
	m_StandardWarp $00 $82 $5 $2 $24
warpData7dce:
	m_StandardWarp $00 $82 $5 $2 $20
warpData7dde:
	m_StandardWarp $00 $21 $5 $2 $2e
warpData7de6:
	m_StandardWarp $00 $2b $5 $2 $2a
warpData7dee:
	m_StandardWarp $00 $2d $7 $2 $0a
warpData7df6:
	m_StandardWarp $00 $42 $7 $2 $0b
warpData7dfe:
	m_StandardWarp $00 $93 $2 $2 $34
warpData7e06:
	m_StandardWarp $00 $57 $7 $2 $1c

	m_WarpDataEnd


; End at $13dba

group6WarpData: ; $13e0e
	m_StandardWarp $01 $05 $4 $3 $08
	m_StandardWarp $01 $10 $4 $3 $0b
	m_StandardWarp $04 $27 $4 $3 $0c
	m_StandardWarp $01 $29 $4 $3 $0f
	m_StandardWarp $02 $2a $4 $3 $10
	m_StandardWarp $04 $2b $4 $3 $0d
	m_StandardWarp $08 $2b $4 $3 $0e
	m_StandardWarp $01 $68 $4 $3 $12
	m_StandardWarp $08 $68 $4 $3 $11
	m_StandardWarp $01 $93 $4 $3 $19
	m_StandardWarp $02 $94 $4 $3 $17
	m_StandardWarp $01 $95 $4 $3 $1a
	m_StandardWarp $08 $96 $4 $3 $15
	m_StandardWarp $01 $97 $4 $3 $16
	m_StandardWarp $02 $97 $4 $3 $18
	m_StandardWarp $01 $98 $4 $3 $13
	m_StandardWarp $02 $98 $4 $3 $14
	m_StandardWarp $01 $c0 $4 $3 $1b
	m_StandardWarp $02 $c0 $4 $3 $1c

	m_WarpDataEnd


	m_WarpDataEnd


; End at $13e5e

group7WarpData: ; $13e5e
	m_StandardWarp $01 $01 $0 $3 $11
	m_StandardWarp $02 $01 $7 $3 $02
	m_StandardWarp $04 $02 $7 $3 $01
	m_StandardWarp $02 $02 $2 $3 $22
	m_StandardWarp $02 $03 $7 $3 $05
	m_StandardWarp $04 $04 $7 $3 $04
	m_StandardWarp $02 $04 $2 $3 $24
	m_StandardWarp $01 $08 $5 $3 $6c
	m_StandardWarp $02 $08 $3 $3 $17
	m_StandardWarp $01 $09 $1 $3 $07
	m_StandardWarp $02 $0a $3 $3 $19
	m_StandardWarp $01 $05 $5 $3 $37
	m_StandardWarp $02 $05 $5 $3 $35
	m_StandardWarp $01 $07 $5 $3 $3a
	m_StandardWarp $02 $07 $5 $3 $3b
	m_StandardWarp $01 $10 $5 $3 $08
	m_StandardWarp $02 $11 $5 $3 $07
	m_StandardWarp $01 $29 $5 $3 $0a
	m_StandardWarp $02 $2a $5 $3 $09
	m_StandardWarp $01 $47 $5 $3 $0b
	m_StandardWarp $02 $48 $5 $3 $0c
	m_StandardWarp $01 $49 $5 $3 $0d
	m_StandardWarp $02 $4a $5 $3 $0e
	m_StandardWarp $01 $73 $5 $3 $15
	m_StandardWarp $02 $73 $5 $3 $13
	m_StandardWarp $01 $74 $5 $3 $12
	m_StandardWarp $02 $74 $5 $3 $11
	m_StandardWarp $02 $75 $5 $3 $10
	m_StandardWarp $01 $76 $5 $3 $14
	m_StandardWarp $08 $76 $5 $3 $0f
	m_StandardWarp $04 $ef $4 $3 $44

	m_WarpDataEnd


	m_WarpDataEnd


; End at $13ede

