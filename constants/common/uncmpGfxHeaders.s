.ENUM 0
	UNCMP_GFXH_00:    db ; $00
	UNCMP_GFXH_01:    db ; $01
	UNCMP_GFXH_02:    db ; $02
	UNCMP_GFXH_03:    db ; $03
	UNCMP_GFXH_04:    db ; $04
	UNCMP_GFXH_05:    db ; $05
	UNCMP_GFXH_06:    db ; $06
	UNCMP_GFXH_07:    db ; $07
	UNCMP_GFXH_08:    db ; $08
	UNCMP_GFXH_09:    db ; $09
	UNCMP_GFXH_0a:    db ; $0a
	UNCMP_GFXH_0b:    db ; $0b
	UNCMP_GFXH_0c:    db ; $0c
	UNCMP_GFXH_0d:    db ; $0d
	UNCMP_GFXH_0e:    db ; $0e
	UNCMP_GFXH_0f:    db ; $0f
	UNCMP_GFXH_10:    db ; $10
	UNCMP_GFXH_11:    db ; $11
	UNCMP_GFXH_12:    db ; $12
	UNCMP_GFXH_13:    db ; $13
	UNCMP_GFXH_14:    db ; $14
	UNCMP_GFXH_15:    db ; $15
	UNCMP_GFXH_16:    db ; $16
	UNCMP_GFXH_17:    db ; $17
	UNCMP_GFXH_18:    db ; $18
	UNCMP_GFXH_19:    db ; $19
	UNCMP_GFXH_1a:    db ; $1a
	UNCMP_GFXH_1b:    db ; $1b

.ifdef ROM_AGES
	UNCMP_GFXH_AGES_1c:       db ; $1c
	UNCMP_GFXH_AGES_1d:       db ; $1d
	UNCMP_GFXH_AGES_1e:       db ; $1e
	UNCMP_GFXH_AGES_1f:       db ; $1f
.else
	UNCMP_GFXH_SEASONS_1c:    db ; $1c
	UNCMP_GFXH_SEASONS_1d:    db ; $1d
	UNCMP_GFXH_SEASONS_1e:    db ; $1e
	UNCMP_GFXH_SEASONS_1f:    db ; $1f
.endif

	UNCMP_GFXH_20:    db ; $20
	UNCMP_GFXH_21:    db ; $21
	UNCMP_GFXH_22:    db ; $22
	UNCMP_GFXH_23:    db ; $23
	UNCMP_GFXH_24:    db ; $24
	UNCMP_GFXH_25:    db ; $25
	UNCMP_GFXH_26:    db ; $26
	UNCMP_GFXH_27:    db ; $27
	UNCMP_GFXH_28:    db ; $28
	UNCMP_GFXH_29:    db ; $29
	UNCMP_GFXH_2a:    db ; $2a
	UNCMP_GFXH_2b:    db ; $2b
	UNCMP_GFXH_2c:    db ; $2c
	UNCMP_GFXH_2d:    db ; $2d
	UNCMP_GFXH_2e:    db ; $2e
	UNCMP_GFXH_2f:    db ; $2f
	UNCMP_GFXH_30:    db ; $30
	UNCMP_GFXH_31:    db ; $31
	UNCMP_GFXH_32:    db ; $32
	UNCMP_GFXH_33:    db ; $33
	UNCMP_GFXH_34:    db ; $34
	UNCMP_GFXH_35:    db ; $35

.ifdef ROM_AGES

	UNCMP_GFXH_AGES_36:              db ; $36
	UNCMP_GFXH_AGES_37:              db ; $37
	UNCMP_GFXH_AGES_38:              db ; $38
	UNCMP_GFXH_AGES_39:              db ; $39 ; Same as below?
	UNCMP_GFXH_AGES_IMPA_FAINTED:    db ; $3a
	UNCMP_GFXH_AGES_3b:              db ; $3b
	UNCMP_GFXH_AGES_3c:              db ; $3c
	UNCMP_GFXH_AGES_3d:              db ; $3d
	UNCMP_GFXH_AGES_3e:              db ; $3e
	UNCMP_GFXH_AGES_3f:              db ; $3f

.else; ROM_SEASONS

	UNCMP_GFXH_SEASONS_36:           db ; $36
	UNCMP_GFXH_SEASONS_37:           db ; $37

.endif

.ENDE
