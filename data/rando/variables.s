; Some extra variables that should be set by the randomizer. (This is in bank 0.)

; This gets written to wAnimalCompanion upon file initialization
randovar_animalCompanion:
	.db SPECIALOBJECTID_RICKY


; Boolean options will be written here and can be accessed with the "checkRandoConfig" function. See
; "constants/rando.s" for values.
randoConfig:
	.db %00000000
