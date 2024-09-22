; These are the waveforms available on the wave channel. Using the command "duty $XX" will use
; waveform number XX in this table.
;
; If adding a new waveform, remember to add a reference to it at the end of waveformTable.


.define NUM_WAVEFORMS $2e

; Table of pointers to waveform data
waveformTable:
	.rept NUM_WAVEFORMS index i
		.dw @waveform{%.2x{i}}
	.endr


@waveformUnused0:
	.db $00 $00 $00 $00 $66 $77 $88 $88 $88 $88 $88 $88 $88 $77 $66 $55

m_waveform $04, WF_TRIANGLE_HALF_04
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $99 $aa $aa $aa $aa $99 $88

m_waveform $0e, WF_SQUARE_50_VOL_8
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88

m_waveform $28, WF_TRIANGLE_HALF_28
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $55 $66 $66 $66 $66 $55 $44

m_waveform $06, WF_TRIANGLE_HALF_06
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $44 $55 $55 $55 $55 $44 $33

m_waveform $07, WF_TRIANGLE_HALF_07_CLONE
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $55 $66 $66 $66 $66 $55 $44

m_waveform $26, WF_TRIANGLE_HALF_26
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $11 $22 $33 $33 $22 $11 $00

m_waveform $09, WF_TRIANGLE_HALF_09
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $55 $55 $33 $33 $00

m_waveform $16, WF_TRIANGLE_16
	.db $01 $23 $45 $67 $89 $ab $cd $ef $ed $cb $a9 $87 $65 $43 $21 $00

m_waveform $20, WF_TRIANGLE_20
	.db $00 $01 $23 $45 $67 $89 $ab $cd $cb $a9 $87 $65 $43 $21 $00 $00

@waveformUnused1:
	.db $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88

m_waveform $0a, WF_SQUARE_50_VOL_A
	.db $00 $00 $00 $00 $00 $00 $00 $00 $cc $cc $cc $cc $cc $cc $cc $cc

m_waveform $1e, WF_SAWTOOTH_LOUD
	.db $ff $ee $dd $cc $bb $aa $99 $88 $77 $66 $55 $44 $33 $22 $11 $00

m_waveform $21, WF_21
	.db $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77 $ff $ff $ff $ff

@waveformUnused2:
	.db $ff $ee $cc $bb $99 $88 $66 $55 $cc $aa $99 $77 $66 $44 $22 $00

m_waveform $23, WF_SAWTOOTH_SOFT
	.db $77 $77 $66 $66 $55 $55 $44 $44 $cc $bb $ba $aa $a9 $99 $88 $88

@waveformUnused3:
	.db $88 $aa $cc $ee $ff $ee $dd $cc $bb $aa $99 $88 $66 $44 $22 $00

m_waveform $22, WF_22
	.db $6c $6c $6c $6c $6b $6a $69 $68 $77 $66 $55 $44 $33 $22 $11 $00

m_waveform $1f, WF_ALTERNATING_1f
	.db $11 $ff $33 $dd $55 $bb $77 $99 $88 $88 $77 $99 $55 $bb $33 $dd

m_waveform $24, WF_24
	.db $80 $ae $db $f6 $ff $f6 $db $ae $80 $4f $25 $0a $00 $0a $25 $4f

@waveformUnused4:
	.db $ff $f6 $db $ae $80 $4f $25 $0a $00 $0a $25 $4f $80 $ae $db $f6

m_waveform $25, WF_25
	.db $c0 $d2 $db $d2 $c0 $a3 $80 $5c $40 $2d $25 $2d $40 $5c $80 $a3

@waveformUnused5:
	.db $c0 $db $c0 $80 $40 $25 $40 $80 $c0 $db $c0 $80 $40 $25 $40 $80

m_waveform $1a, WF_1a
	.db $80 $db $ff $db $80 $25 $00 $25 $80 $db $ff $db $80 $25 $00 $25

m_waveform $1b, WF_1b
	.db $40 $6e $80 $6e $40 $13 $00 $13 $40 $6e $80 $6e $40 $13 $00 $13

@waveformUnused6:
	.db $20 $37 $40 $37 $20 $0a $00 $0a $20 $37 $40 $37 $20 $0a $00 $0a

m_waveform $27, WF_TRIANGLE_27
	.db $00 $00 $00 $00 $99 $bb $dd $ee $ff $ff $ee $dd $bb $99 $00 $00

m_waveform $01, WF_SQUARE_80_VOL_8
	.db $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88

m_waveform $02, WF_SQUARE_75_VOL_F
	.db $00 $00 $00 $00 $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff

m_waveform $1c, WF_1c
	.db $ff $bb $00 $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb

m_waveform $1d, WF_SAWTOOTH_DOUBLEFREQ
	.db $77 $66 $55 $44 $33 $22 $11 $00 $77 $66 $55 $44 $33 $22 $11 $00

m_waveform $14, WF_TRIANGLE_14
	.db $30 $00 $00 $00 $00 $00 $00 $00 $03 $34 $45 $55 $55 $55 $54 $43

m_waveform $13, WF_SQUARE_78_VOL_7
	.db $00 $00 $00 $07 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77

m_waveform $15, WF_15
	.db $50 $00 $00 $00 $00 $00 $00 $00 $05 $46 $67 $77 $77 $77 $76 $65

m_waveform $12, WF_12
	.db $00 $00 $00 $09 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99

@waveformUnused7:
	.db $01 $23 $45 $67 $89 $ab $cd $ef $fe $dc $ba $98 $76 $54 $32 $10

m_waveform $0c, WF_SQUARE_50_VOL_1
	.db $00 $00 $00 $00 $00 $00 $00 $00 $11 $11 $11 $11 $11 $11 $11 $11

m_waveform $0d, WF_SQUARE_50_VOL_3
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33

m_waveform $0f, WF_SQUARE_50_VOL_3_ALT
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33

m_waveform $10, WF_SQUARE_50_VOL_7
	.db $00 $00 $00 $00 $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77

m_waveform $11, WF_SQUARE_50_VOL_8_ALT
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88

m_waveform $17, WF_SQUARE_50_VOL_5
	.db $00 $00 $00 $00 $00 $00 $00 $00 $55 $55 $55 $55 $55 $55 $55 $55

m_waveform $18, WF_SQUARE_50_VOL_9
	.db $00 $00 $00 $00 $00 $00 $00 $00 $99 $99 $99 $99 $99 $99 $99 $99

m_waveform $19, WF_SQUARE_62_VOL_7
	.db $00 $00 $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77

m_waveform $08, WF_TRIANGLE_SOFT
	.db $00 $00 $11 $12 $22 $33 $34 $44 $44 $43 $33 $22 $21 $11 $00 $00

m_waveform $00, WF_TRIANGLE_MEDIUM
	.db $11 $22 $33 $44 $55 $66 $78 $9a $a9 $88 $77 $66 $55 $44 $33 $22

m_waveform $05, WF_TRIANGLE_MEDIUM_ALT
	.db $11 $22 $33 $44 $55 $66 $78 $9a $a9 $88 $77 $66 $55 $44 $33 $22

m_waveform $03, WF_TRIANGLE_LOUD
	.db $11 $33 $55 $77 $99 $bb $dd $ff $ff $dd $bb $99 $77 $55 $33 $11

m_waveform $0b, WF_SQUARE_90_VOL_D
	.db $00 $0d $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd

m_waveform $2b, WF_SQUARE_50_VOL_4
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $44 $44 $44 $44 $44 $44 $44

m_waveform $2c, WF_SQUARE_50_VOL_2
	.db $00 $00 $00 $00 $00 $00 $00 $00 $22 $22 $22 $22 $22 $22 $22 $22

m_waveform $29, WF_SQUARE_75_VOL_2
	.db $00 $00 $00 $00 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22

m_waveform $2a, WF_SQUARE_75_VOL_3
	.db $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33

m_waveform $2d, WF_2d
	.db $9b $df $ff $fe $dc $ba $98 $76 $21 $00 $01 $23 $22 $22 $23 $23
