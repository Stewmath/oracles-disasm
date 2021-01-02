; Some extra variables that should be set by the randomizer. (This is in bank 0.)

; This gets written to wAnimalCompanion upon file initialization
randovar_animalCompanion:
	.db SPECIALOBJECTID_RICKY

; Determines default cursor position for satchel / shooter / slingshot, and which seeds you get upon
; obtaining any of those items. This should be the same as the starting tree's seeds.
randovar_initialSeedType:
	.db $00

; Boolean options will be written here and can be accessed with the "checkRandoConfig" function. See
; "constants/rando.s" for values.
randoConfig:
	.db %00000000
