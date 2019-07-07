; Switch hook
sounda1Start:
; @addr{ebada}
sounda1Channel2:
	duty $02
	vol $d
	env $1 $00
	cmdf8 $00
	note $30 $04
	vol $c
	note $34 $04
	vol $d
	note $38 $04
	vibrato $51
	env $1 $01
	vol $b
	note $3c $14
	cmdff


; Black tower
sound24Start:
; @addr{f1ec7}
sound24Channel1:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1ece:
	vol $6
	note $20 $24
	note $1f $24
	note $23 $36
	note $22 $12
	note $20 $12
	note $1f $12
	note $23 $12
	note $22 $12
	note $20 $12
	note $1f $12
	note $23 $12
	note $22 $12
	note $27 $24
	note $26 $24
	note $2a $36
	note $29 $12
	note $27 $12
	note $26 $12
	note $2a $12
	note $29 $12
	note $27 $12
	note $26 $12
	note $2e $12
	note $2c $12
	note $2e $24
	note $2d $24
	note $31 $36
	note $30 $12
	note $2e $12
	note $2d $12
	note $31 $12
	note $30 $12
	note $2e $12
	note $2d $12
	note $35 $12
	note $34 $12
	note $35 $36
	note $36 $12
	note $34 $12
	note $36 $12
	note $35 $12
	note $34 $12
	note $35 $28
	wait1 $0e
	note $35 $04
	wait1 $01
	note $39 $05
	wait1 $03
	note $3c $05
	vol $5
	note $41 $04
	wait1 $05
	vol $4
	note $41 $04
	wait1 $05
	vol $3
	note $41 $04
	wait1 $05
	vol $2
	note $41 $04
	wait1 $29
	vol $6
	note $22 $1b
	note $29 $09
	note $28 $1b
	wait1 $09
	note $22 $1b
	note $27 $09
	note $25 $1b
	wait1 $09
	note $22 $1b
	note $29 $09
	note $28 $1b
	note $22 $04
	wait1 $05
	note $22 $1b
	note $27 $09
	note $25 $1b
	wait1 $09
	note $29 $12
	note $28 $12
	note $29 $12
	note $2c $24
	note $2b $12
	note $29 $12
	note $28 $12
	note $29 $6c
	wait1 $24
	goto musicf1ece
	cmdff
; $f1f7e
; @addr{f1f7e}
sound24Channel0:
	cmdf2
	vibrato $e1
	env $0 $00
	duty $02
musicf1f85:
	vol $6
	note $1c $24
	vol $6
	note $1b $24
	note $1f $36
	note $1e $12
	note $1c $12
	note $1b $12
	note $1f $12
	note $1e $12
	note $1c $12
	note $1b $12
	note $1f $12
	note $1e $12
	note $23 $24
	note $22 $24
	note $27 $36
	note $26 $12
	note $24 $12
	note $23 $12
	note $27 $12
	note $26 $12
	note $20 $12
	note $1f $12
	note $26 $12
	note $25 $12
	note $26 $24
	note $25 $24
	note $2b $36
	note $2a $12
	note $28 $12
	note $27 $12
	note $2b $12
	note $2a $12
	note $28 $12
	note $27 $12
	note $31 $12
	note $30 $12
	vol $6
	note $24 $09
	note $25 $09
	note $23 $09
	note $24 $09
	note $25 $09
	note $23 $09
	note $25 $09
	note $24 $09
	note $24 $12
	note $25 $12
	note $24 $12
	note $23 $12
	note $1c $09
	note $1d $09
	note $23 $09
	note $24 $09
	note $28 $09
	note $29 $09
	note $2f $09
	note $30 $09
	note $34 $09
	note $35 $09
	note $2f $09
	note $30 $09
	note $33 $04
	note $31 $05
	note $2f $04
	note $2d $05
	note $2c $04
	note $2a $05
	note $27 $04
	note $26 $05
	vol $6
	note $1d $09
	vol $6
	note $22 $09
	vol $6
	note $1d $09
	note $25 $09
	note $24 $12
	note $1d $09
	vol $6
	note $23 $09
	vol $6
	note $1d $09
	vol $6
	note $22 $09
	vol $6
	note $1d $09
	note $24 $09
	note $22 $12
	note $1d $09
	vol $6
	note $1c $09
	vol $6
	note $1d $09
	vol $6
	note $22 $09
	vol $6
	note $1d $09
	note $25 $09
	note $24 $12
	note $1d $09
	note $1c $09
	note $1d $12
	note $1c $09
	note $23 $09
	note $22 $1b
	wait1 $09
	note $25 $12
	note $24 $12
	note $25 $12
	note $31 $04
	note $32 $05
	note $33 $04
	note $34 $05
	note $35 $12
	note $34 $12
	note $32 $12
	note $34 $15
	wait1 $01
	note $34 $05
	note $35 $04
	note $30 $05
	note $31 $04
	note $2d $05
	note $2e $04
	note $28 $05
	note $29 $04
	note $24 $05
	note $25 $04
	note $21 $05
	note $22 $04
	note $1c $05
	note $1d $04
	note $1c $05
	note $1d $09
	note $1c $03
	wait1 $03
	vol $5
	note $1c $03
	vol $6
	note $22 $09
	note $21 $03
	wait1 $03
	vol $4
	note $21 $03
	vol $6
	note $25 $09
	note $24 $03
	wait1 $03
	vol $4
	note $24 $03
	vol $6
	note $2a $09
	note $29 $03
	wait1 $03
	vol $4
	note $29 $03
	goto musicf1f85
	cmdff
; $f20b0
; @addr{f20b0}
sound24Channel4:
musicf20b0:
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	note $0d $09
	duty $0f
	note $0d $09
	duty $18
	note $0d $09
	duty $0f
	note $0d $09
	wait1 $5a
	duty $18
	note $0d $04
	wait1 $05
	note $0d $04
	wait1 $05
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $08 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $09 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $0b $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $08 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $09 $09
	vol $8
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	note $05 $04
	wait1 $05
	duty $18
	note $0b $09
	vol $8
	note $05 $04
	wait1 $05
	duty $18
	note $0c $09
	vol $8
	note $05 $04
	wait1 $05
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $24
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $12
	duty $18
	note $0a $04
	wait1 $05
	note $0a $04
	wait1 $05
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $24
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	duty $18
	note $0a $09
	duty $0f
	note $0a $09
	wait1 $12
	duty $18
	note $0a $04
	wait1 $05
	note $0a $04
	wait1 $05
	note $00 $09
	duty $0f
	note $00 $09
	duty $18
	note $00 $09
	duty $0f
	note $00 $09
	wait1 $24
	duty $18
	note $0c $09
	duty $0f
	note $0c $09
	duty $18
	note $0c $09
	duty $0f
	note $0c $09
	wait1 $24
	duty $18
	note $11 $12
	duty $0f
	note $11 $12
	duty $18
	note $11 $12
	duty $0f
	note $11 $12
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	duty $18
	note $11 $09
	duty $0f
	note $11 $09
	goto musicf20b0
	cmdff
; $f2286
; @addr{f2286}
sound24Channel6:
musicf2286:
	vol $6
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $12
	note $24 $12
	wait1 $5a
	note $24 $09
	note $24 $09
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $24
	note $24 $09
	vol $2
	note $2e $09
	wait1 $09
	vol $2
	note $2e $09
	vol $6
	note $24 $09
	vol $2
	note $2e $09
	wait1 $09
	vol $2
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	vol $6
	note $24 $09
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	wait1 $09
	vol $3
	note $2e $09
	wait1 $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	note $2e $09
	vol $6
	note $24 $09
	vol $3
	note $2e $09
	wait1 $09
	note $2e $09
	goto musicf2286
	cmdff
