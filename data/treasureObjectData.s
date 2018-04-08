; Treasure objects are a kind of Interaction (type $60 interactions, to be precise).
;
; Data format:
; b0: bit 7    = next 2 bytes are a pointer
;     bits 4-6 = spawn mode
;     bit 3    = ?
;     bits 0-2 = collect mode
; b1: Parameter (value of 'c' to pass to "giveTreasure")
; b2: Low text ID on pickup ($ff for no text; high byte of ID is always $00)
; b3: Graphics to use. (Gets copied to object's subid, so graphics are determined by the
;     corresponding value for interaction $60 in data/interactionData.s.)
;
; Spawn modes:
;   0: instantaneous
;   1: appears with a puff
;   2: falls from top of screen, plays "solved puzzle" sound effect
;   3: from a chest
;   4: picked up from underwater? (that one key in dungeon 4 of seasons?)
;   5: falls toward from link when [$ccaa]=$ff?
;   6: appears at Link's position after a short delay
;
; Collect modes:
;   0: no change in animation
;   1: holds it over his head with one hand
;   2: holds it over his head with both hands
;   3: performs a spin slash
;   4: same as 1?
;   5: same as 2?
;
; See also constants/treasure.s.

; @addr{5332}
treasureObjectData:
	; 0x00
	.db $00 $00 $ff $00

	; 0x01
	.db $80
	.dw treasureObjectData01
	.db $00

	; 0x02
	.db $00 $00 $ff $00

	; 0x03
	.db $80
	.dw treasureObjectData03
	.db $00

	; 0x04
	.db $38 $00 $73 $17

	; 0x05
	.db $80
	.dw treasureObjectData05
	.db $00

	; 0x06
	.db $80
	.dw treasureObjectData06
	.db $00

	; 0x07
	.db $00 $00 $ff $00

	; 0x08
	.db $00 $00 $ff $00

	; 0x09
	.db $00 $00 $ff $00

	; 0x0a
	.db $80
	.dw treasureObjectData0a
	.db $00

	; 0x0b
	.db $00 $00 $ff $00

	; 0x0c
	.db $80
	.dw treasureObjectData0c
	.db $00

	; 0x0d
	.db $80
	.dw treasureObjectData0d
	.db $00

	; 0x0e
	.db $80
	.dw treasureObjectData0e
	.db $00

	; 0x0f
	.db $38 $01 $2e $21

	; 0x10
	.db $00 $00 $ff $00

	; 0x11
	.db $80
	.dw treasureObjectData11
	.db $00

	; 0x12
	.db $00 $00 $ff $00

	; 0x13
	.db $80 $00 $00 $00

	; 0x14
	.db $00 $00 $ff $00

	; 0x15
	.db $80
	.dw treasureObjectData15
	.db $00

	; 0x16
	.db $80
	.dw treasureObjectData16
	.db $00

	; 0x17
	.db $80
	.dw treasureObjectData17
	.db $00

	; 0x18
	.db $00 $00 $ff $00

	; 0x19
	.db $80
	.dw treasureObjectData19
	.db $00

	; 0x1a
	.db $00 $00 $ff $00

	; 0x1b
	.db $00 $00 $ff $00

	; 0x1c
	.db $00 $00 $ff $00

	; 0x1d
	.db $00 $00 $ff $00

	; 0x1e
	.db $00 $00 $ff $00

	; 0x1f
	.db $00 $00 $ff $00

	; 0x20
	.db $80
	.dw treasureObjectData20
	.db $00

	; 0x21
	.db $00 $00 $ff $00

	; 0x22
	.db $00 $00 $ff $00

	; 0x23
	.db $00 $00 $ff $00

	; 0x24
	.db $00 $00 $ff $00

	; 0x25
	.db $68 $00 $72 $69

	; 0x26
	.db $0a $00 $0a $6a

	; 0x27
	.db $0a $00 $0b $6b

	; 0x28
	.db $80
	.dw treasureObjectData28
	.db $00

	; 0x29
	.db $00 $00 $ff $00

	; 0x2a
	.db $80
	.dw treasureObjectData2a
	.db $00

	; 0x2b
	.db $80
	.dw treasureObjectData2b
	.db $00

	; 0x2c
	.db $80
	.dw treasureObjectData2c
	.db $00

	; 0x2d
	.db $80
	.dw treasureObjectData2d
	.db $00

	; 0x2e
	.db $80
	.dw treasureObjectData2e
	.db $00

	; 0x2f
	.db $02 $00 $ff $30

	; 0x30
	.db $80
	.dw treasureObjectData30
	.db $00

	; 0x31
	.db $80
	.dw treasureObjectData31
	.db $00

	; 0x32
	.db $80
	.dw treasureObjectData32
	.db $00

	; 0x33
	.db $80
	.dw treasureObjectData33
	.db $00

	; 0x34
	.db $80
	.dw treasureObjectData34
	.db $00

	; 0x35
	.db $00 $00 $ff $00

	; 0x36
	.db $02 $00 $33 $4f

	; 0x37
	.db $02 $0b $6b $2f

	; 0x38
	.db $00 $00 $ff $00

	; 0x39
	.db $00 $00 $ff $00

	; 0x3a
	.db $00 $00 $ff $00

	; 0x3b
	.db $00 $00 $ff $00

	; 0x3c
	.db $00 $00 $ff $00

	; 0x3d
	.db $00 $00 $ff $00

	; 0x3e
	.db $00 $00 $ff $00

	; 0x3f
	.db $00 $00 $ff $00

	; 0x40
	.db $80 $00 $00 $00

	; 0x41
	.db $80
	.dw treasureObjectData41
	.db $00

	; 0x42
	.db $29 $00 $23 $44

	; 0x43
	.db $09 $00 $3d $45

	; 0x44
	.db $09 $00 $42 $46

	; 0x45
	.db $80
	.dw treasureObjectData45
	.db $00

	; 0x46
	.db $02 $00 $44 $48

	; 0x47
	.db $00 $00 $ff $00

	; 0x48
	.db $51 $01 $67 $55

	; 0x49
	.db $80
	.dw treasureObjectData49
	.db $00

	; 0x4a
	.db $38 $00 $36 $27

	; 0x4b
	.db $38 $00 $48 $50

	; 0x4c
	.db $80
	.dw treasureObjectData4c
	.db $00

	; 0x4d
	.db $0a $00 $0d $3e

	; 0x4e
	.db $0a $00 $47 $51

	; 0x4f
	.db $0a $00 $56 $53

	; 0x50
	.db $00 $00 $ff $00

	; 0x51
	.db $0a $00 $55 $58

	; 0x52
	.db $0a $00 $7d $3c

	; 0x53
	.db $00 $00 $ff $00

	; 0x54
	.db $0a $00 $7c $26

	; 0x55
	.db $0a $00 $4e $52

	; 0x56
	.db $00 $00 $ff $00

	; 0x57
	.db $00 $00 $ff $00

	; 0x58
	.db $00 $00 $ff $00

	; 0x59
	.db $02 $00 $4a $49

	; 0x5a
	.db $0a $00 $41 $4a

	; 0x5b
	.db $0a $00 $0c $4b

	; 0x5c
	.db $0a $00 $3f $4c

	; 0x5d
	.db $80
	.dw treasureObjectData5d
	.db $00

	; 0x5e
	.db $80
	.dw treasureObjectData5e
	.db $00

	; 0x5f
	.db $00 $00 $ff $00

	; 0x60
	.db $0c $00 $ff $57

	; 0x61
	.db $02 $00 $6e $05

	; 0x62
	.db $02 $00 $46 $20

treasureObjectData01:
	.db $0a $01 $1f $13
	.db $0a $02 $20 $14
	.db $0a $03 $21 $15
	.db $0a $03 $ff $15

treasureObjectData03:
	.db $38 $10 $4d $05
	.db $30 $10 $4d $05
	.db $02 $10 $4d $05
	.db $38 $30 $4d $05
	.db $09 $00 $76 $05
	.db $02 $20 $7e $05

treasureObjectData05:
	.db $09 $01 $1c $10
	.db $09 $02 $1d $11
	.db $09 $03 $1e $12
	.db $03 $01 $ff $10
	.db $03 $02 $ff $11
	.db $03 $03 $ff $12
	.db $01 $01 $75 $10

treasureObjectData06:
	.db $0a $01 $22 $1c
	.db $10 $01 $22 $1c
	.db $02 $01 $22 $1c

treasureObjectData0a:
	.db $38 $01 $30 $1f
	.db $38 $02 $28 $1f

treasureObjectData0c:
	.db $02 $00 $6f $25
	.db $30 $00 $6f $25

treasureObjectData0d:
	.db $0a $10 $32 $24
	.db $30 $10 $32 $24
	.db $02 $10 $32 $24

treasureObjectData0e:
	.db $0a $0b $3b $23
	.db $0a $0c $3b $23
	.db $0a $0d $3b $23

treasureObjectData11:
	.db $0a $00 $71 $68
	.db $0a $01 $78 $68

treasureObjectData15:
	.db $0a $00 $25 $1b
	.db $0a $00 $74 $1b
	.db $0a $00 $25 $1b

treasureObjectData16:
	.db $0a $01 $26 $19
	.db $0a $01 $77 $19
	.db $38 $02 $2f $1a
	.db $0a $01 $26 $19

treasureObjectData17:
	.db $0a $01 $27 $16
	.db $0a $01 $79 $16
	.db $0a $01 $27 $16

treasureObjectData19:
	.db $0a $01 $2d $20
	.db $0a $00 $7b $20
	.db $29 $00 $2d $20
	.db $09 $00 $2d $20
	.db $01 $00 $80 $20

treasureObjectData20:
	.db $30 $04 $4f $06

treasureObjectData34:
	.db $02 $01 $4b $0d
	.db $38 $01 $4b $0d
	.db $52 $01 $4b $0d
	.db $02 $01 $4b $0d
	.db $0a $01 $4b $0d
	.db $4a $01 $4b $0d
	.db $10 $01 $4b $0d
	.db $0a $01 $4b $0d
	.db $0a $01 $4b $0d

treasureObjectData28:
	.db $38 $01 $01 $28
	.db $38 $03 $02 $29
	.db $38 $04 $03 $2a
	.db $38 $05 $04 $2b
	.db $38 $07 $05 $2b
	.db $38 $0b $06 $2c
	.db $38 $0c $07 $2d
	.db $38 $0f $08 $2d
	.db $38 $0d $09 $2e
	.db $30 $01 $01 $28
	.db $18 $01 $ff $2e
	.db $08 $05 $ff $2b
	.db $08 $07 $05 $2b
	.db $30 $04 $03 $2a
	.db $01 $05 $04 $2b
	.db $01 $0b $06 $2c
	.db $01 $0c $07 $2d
	.db $10 $0b $06 $2c
	.db $10 $0c $07 $2d
	.db $10 $07 $05 $2b
	.db $00 $04 $ff $2a
	.db $00 $01 $ff $28
	.db $0a $0d $09 $2e

treasureObjectData2b:
	.db $0a $01 $17 $3a
	.db $38 $01 $17 $3a
	.db $02 $01 $17 $3a

treasureObjectData2a:
	.db $1a $04 $16 $3b
	.db $30 $04 $16 $3b
	.db $02 $04 $16 $3b

treasureObjectData2c:
	.db $02 $01 $57 $33
	.db $02 $02 $34 $34
	.db $02 $03 $34 $35
	.db $02 $02 $58 $34
	.db $02 $03 $59 $35

treasureObjectData2d:
	.db $09 $ff $54 $0e
	.db $29 $ff $54 $0e
	.db $49 $ff $54 $0e
	.db $59 $ff $54 $0e
	.db $38 $28 $54 $0e
	.db $38 $2b $54 $0e
	.db $38 $10 $54 $0e
	.db $38 $0c $54 $0e
	.db $38 $0d $54 $0e
	.db $38 $2a $54 $0e
	.db $38 $23 $54 $0e
	.db $38 $05 $54 $0e
	.db $30 $15 $54 $0e
	.db $30 $13 $54 $0e
	.db $38 $01 $54 $0e
	.db $38 $03 $54 $0e
	.db $38 $2d $54 $0e
	.db $38 $1d $54 $0e
	.db $10 $12 $ff $0e
	.db $10 $23 $ff $0e
	.db $01 $12 $54 $0e
	.db $01 $23 $54 $0e
	.db $38 $26 $54 $0e
	.db $38 $04 $54 $0e
	.db $38 $32 $54 $0e
	.db $38 $17 $54 $0e
	.db $38 $1b $54 $0e
	.db $38 $02 $54 $0e
	.db $38 $1c $54 $0e
	.db $38 $22 $54 $0e
	.db $38 $11 $54 $0e
	.db $38 $06 $54 $0e
	.db $38 $1a $54 $0e
	.db $38 $1e $54 $0e
	.db $38 $20 $54 $0e
	.db $38 $39 $54 $0e
	.db $38 $0f $54 $0e
	.db $38 $3e $54 $0e
	.db $38 $12 $54 $0e
	.db $38 $08 $54 $0e
	.db $38 $2c $54 $0e

treasureObjectData2e:
	.db $0a $00 $31 $31
	.db $0a $00 $7a $31

treasureObjectData30:
	.db $18 $01 $ff $42
	.db $28 $01 $ff $42
	.db $49 $01 $1a $42
	.db $38 $01 $1a $42

treasureObjectData31:
	.db $19 $00 $1b $43
	.db $29 $00 $1b $43
	.db $49 $00 $1b $43
	.db $38 $00 $1b $43

treasureObjectData32:
	.db $1a $00 $19 $41
	.db $2a $00 $19 $41
	.db $68 $00 $19 $41

treasureObjectData33:
	.db $1a $00 $18 $40
	.db $2a $00 $18 $40
	.db $68 $00 $18 $40

treasureObjectData41:
	.db $0a $00 $5a $70
	.db $0a $01 $5b $71
	.db $0a $02 $5c $72
	.db $0a $03 $5d $73
	.db $0a $04 $5e $74
	.db $0a $05 $5f $75
	.db $0a $06 $60 $76
	.db $0a $07 $61 $77
	.db $0a $08 $62 $78
	.db $0a $09 $63 $79
	.db $0a $0a $64 $7a
	.db $0a $0b $65 $7b

treasureObjectData45:
	.db $09 $00 $43 $47
	.db $19 $00 $43 $47

treasureObjectData49:
	.db $0a $00 $3c $56
	.db $00 $00 $ff $56

treasureObjectData4c:
	.db $0a $00 $37 $5b
	.db $0a $02 $37 $5c

treasureObjectData5d:
	.db $0a $00 $40 $4d
	.db $10 $00 $ff $4d

treasureObjectData5e:
	.db $0a $00 $3e $4e
	.db $10 $00 $3e $4e

