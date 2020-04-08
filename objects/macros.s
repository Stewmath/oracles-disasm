.DEFINE M_LASTOPCODE 17

; Args:
;   obj_Condition Condition[byte]
.MACRO obj_Condition
	.IF M_LASTOPCODE != 0
	.db $f0
	.ENDIF
	.db \1
	.REDEFINE M_LASTOPCODE 0
.ENDM

; Args:
;   obj_Interaction ID[word]
; OR
;   obj_Interaction ID[word], YY[byte], XX[byte]
; OR
;   obj_Interaction ID[word], YY[byte], XX[byte], Var03[byte]
.MACRO obj_Interaction
	.IF NARGS == 1
		.IF M_LASTOPCODE != 1
		.db $f1
		.ENDIF
		dwbe \1
		.REDEFINE M_LASTOPCODE 1
	.ELSE
	.IF NARGS == 3
		.IF M_LASTOPCODE != 2
		.db $f2
		.ENDIF
		dwbe \1
		.db \2, \3
		.REDEFINE M_LASTOPCODE 2
	.ELSE
	.IF NARGS == 4
		.IF M_LASTOPCODE != 9
		.db $f9
		.ENDIF
		.db 0
		dwbe \1
		.db \4, \2, \3
		.REDEFINE M_LASTOPCODE 9
	.ELSE
		.FAIL
	.ENDIF
	.ENDIF
	.ENDIF
.ENDM

; Args:
;   obj_Pointer Pointer[word]
.MACRO obj_Pointer
	.db $f3
	.dw \1
	.REDEFINE M_LASTOPCODE 3
.ENDM

; Args:
;   obj_BeforeEvent Pointer[word]
.MACRO obj_BeforeEvent
	.db $f4
	.dw \1
	.REDEFINE M_LASTOPCODE 4
.ENDM

; Args:
;   obj_AfterEvent Pointer[word]
.MACRO obj_AfterEvent
	.IF M_LASTOPCODE != 5
	.db $f5
	.ENDIF
	.dw \1
	.REDEFINE M_LASTOPCODE 5
.ENDM

; Args:
;   obj_RandomEnemy Flags[byte], ID[word]
.MACRO obj_RandomEnemy
	.db $f6
	.db \1
	dwbe \2
	.REDEFINE M_LASTOPCODE 6
.ENDM

; Args:
;   obj_SpecificEnemyA Flags[byte], ID[word], YY[byte], XX[byte]
; First parameter (flags) may be omitted, in which case the value for the last defined
; "obj_SpecificEnemyA" will be used.
.MACRO obj_SpecificEnemyA
	.IF NARGS == 4
		.db $f7
		.db \1
		dwbe \2
		.db \3, \4
	.ELSE
		.IF M_LASTOPCODE != 7
			.PRINTT "ERROR: Bad # of arguments to obj_SpecificEnemy.\n"
			.FAIL
		.ENDIF
		dwbe \1
		.db \2, \3
	.ENDIF
	.REDEFINE M_LASTOPCODE 7
.ENDM

; Args:
;   obj_Part ID[word], YX[byte]
; OR
;   obj_Part ID[word], YY[byte], XX[byte], Var03[byte]
.MACRO obj_Part
	.IF NARGS == 2
		.IF M_LASTOPCODE != 8
			.db $f8
		.ENDIF
		dwbe \1
		.db \2
		.REDEFINE M_LASTOPCODE 8
	.ELSE
		.IF M_LASTOPCODE != 9
			.db $f9
		.ENDIF
		.db 2
		dwbe \1
		.db \4, \2, \3
		.REDEFINE M_LASTOPCODE 9
	.ENDIF
.ENDM

; Args:
;   obj_SpecificEnemyB ID[word], YY[byte], XX[byte], Var03[byte]
.MACRO obj_SpecificEnemyB
	.IF M_LASTOPCODE != 9
		.db $f9
	.ENDIF
	.db 1
	dwbe \1
	.db \4, \2, \3
	.REDEFINE M_LASTOPCODE 9
.ENDM

; Args:
;   obj_ItemDrop Flags[byte], Item[byte], YX[byte]
; First parameter (flags) may be omitted, in which case the value for the last defined
; "obj_ItemDrop" will be used.
.MACRO obj_ItemDrop
	.IF NARGS == 3
		.db $fa
		.db \1, \2, \3
	.ELSE
		.IF M_LASTOPCODE != 10
			.PRINTT "ERROR: Bad # of arguments to obj_ItemDrop.\n"
			.FAIL
		.ENDIF
		.db \1, \2
	.ENDIF
	.REDEFINE M_LASTOPCODE 10
.ENDM

.MACRO obj_End
	.db $ff
	.REDEFINE M_LASTOPCODE 17
.ENDM

.MACRO obj_EndPointer
	.db $fe
	.REDEFINE M_LASTOPCODE 17
.ENDM


; Used for bits of "garbage" data in Seasons. We use this instead of ".db" so that LynnaLab can
; easily detect these (and remove them since they do nothing).
.MACRO obj_Garbage
	.REPEAT NARGS
	.db \1
	.shift
	.ENDR
.ENDM
