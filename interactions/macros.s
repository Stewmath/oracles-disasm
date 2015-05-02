.DEFINE M_LASTOPCODE 17

.MACRO Interac0
	.IF M_LASTOPCODE != 0
	.db $f0
	.ENDIF
	.db \1
	.REDEFINE M_LASTOPCODE 0
.ENDM
.MACRO NoValue
	.IF M_LASTOPCODE != 1
	.db $f1
	.ENDIF
	.db \1>>8 \1&$ff
	.REDEFINE M_LASTOPCODE 1
.ENDM
.MACRO DoubleValue
	.IF M_LASTOPCODE != 2
	.db $f2
	.ENDIF
	.db \1>>8 \1&$ff
	.db \2 \3
	.REDEFINE M_LASTOPCODE 2
.ENDM
.MACRO Pointer
	.db $f3
	.dw \1
	.REDEFINE M_LASTOPCODE 3
.ENDM
.MACRO BossPointer
	.db $f4
	.dw \1
	.REDEFINE M_LASTOPCODE 4
.ENDM
.MACRO Conditional
	.IF M_LASTOPCODE != 5
	.db $f5
	.ENDIF
	.db \1>>8 \1&$ff
	.REDEFINE M_LASTOPCODE 5
.ENDM
.MACRO RandomEnemy
	.db $f6
	.db \1
	.db \2>>8 \2&$ff
	.REDEFINE M_LASTOPCODE 6
.ENDM
.MACRO SpecificEnemy
	.IF NARGS == 4
	.db $f7
	.db \1
	.db \2>>8 \2&$ff
	.db \3 \4
	.ELSE
	.db \1>>8 \1&$ff
	.db \2 \3
	.ENDIF
	.REDEFINE M_LASTOPCODE 7
.ENDM
.MACRO Part
	.IF M_LASTOPCODE != 8
	.db $f8
	.ENDIF
	.db \1>>8 \1&$ff
	.db \2
	.REDEFINE M_LASTOPCODE 8
.ENDM
.MACRO QuadrupleValue
	.IF M_LASTOPCODE != 9
	.db $f9
	.ENDIF
	.db \1>>8 \1&$ff
	.db \2 \3 \4 \5
	.REDEFINE M_LASTOPCODE 9
.ENDM
.MACRO InteracA
	.IF NARGS == 3
	.db $fa
	.db \1 \2 \3
	.ELSE
	.db \1 \2
	.ENDIF
	.REDEFINE M_LASTOPCODE 10
.ENDM
.MACRO InteracEnd
	.db $ff
	.REDEFINE M_LASTOPCODE 17
.ENDM
.MACRO InteracEndPointer
	.db $fe
	.REDEFINE M_LASTOPCODE 17
.ENDM


