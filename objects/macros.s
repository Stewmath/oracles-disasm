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
;   obj_Interaction ID, subID
; OR
;   obj_Interaction ID, subID, YY, XX
; OR
;   obj_Interaction ID, subID, YY, XX, Var03
.MACRO obj_Interaction
	.IF NARGS == 2
		.IF M_LASTOPCODE != 1
		.db $f1
		.ENDIF
		.db \1, \2
		.REDEFINE M_LASTOPCODE 1
	.ELSE
	.IF NARGS == 4
		.IF M_LASTOPCODE != 2
		.db $f2
		.ENDIF
		.db \1, \2
		.db \3, \4
		.REDEFINE M_LASTOPCODE 2
	.ELSE
	.IF NARGS == 5
		.IF M_LASTOPCODE != 9
		.db $f9
		.ENDIF
		.db 0
		.db \1, \2
		.db \5, \3, \4
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
;   obj_RandomEnemy Flags, ID, subID
.MACRO obj_RandomEnemy
	.db $f6
	.db \1
	.db \2, \3
	.REDEFINE M_LASTOPCODE 6
.ENDM

; Args:
;   obj_SpecificEnemyA Flags, ID, subID, YY, XX
; First parameter (flags) may be omitted, in which case the value for the last defined
; "obj_SpecificEnemyA" will be used.
.MACRO obj_SpecificEnemyA
	.IF NARGS == 5
		.db $f7
		.db \1
		.db \2, \3
		.db \4, \5
	.ELSE
		.IF M_LASTOPCODE != 7
			.PRINTT "ERROR: Bad # of arguments to obj_SpecificEnemy.\n"
			.FAIL
		.ENDIF
		.db \1, \2
		.db \3, \4
	.ENDIF
	.REDEFINE M_LASTOPCODE 7
.ENDM

; Args:
;   obj_Part ID, subID, YX
; OR
;   obj_Part ID, subID, YY, XX, Var03
;
; NOTE: The above 2 versions are subtly different. The first version will prevent random position
; enemies from spawning at that position, while the second version won't. This is because they're
; technically 2 different "opcodes", handled differently. Currently LynnaLab doesn't attempt to
; account for this difference, and aggressively optimizes the 2nd version into the 1st version when
; possible.
.MACRO obj_Part
	.IF NARGS == 3
		.IF M_LASTOPCODE != 8
			.db $f8
		.ENDIF
		.db \1, \2
		.db \3
		.REDEFINE M_LASTOPCODE 8
	.ELSE
		.IF M_LASTOPCODE != 9
			.db $f9
		.ENDIF
		.db 2
		.db \1, \2
		.db \5, \3, \4
		.REDEFINE M_LASTOPCODE 9
	.ENDIF
.ENDM

; Args:
;   obj_SpecificEnemyB ID, subID, YY, XX, Var03
.MACRO obj_SpecificEnemyB
	.IF M_LASTOPCODE != 9
		.db $f9
	.ENDIF
	.db 1
	.db \1, \2
	.db \5, \3, \4
	.REDEFINE M_LASTOPCODE 9
.ENDM

; Args:
;   obj_ItemDrop Flags, Item, YX
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
