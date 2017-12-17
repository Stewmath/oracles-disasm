; These are values that are used when the game needs to specify a number of rupees in
; a byte instead of a word. Used with functions:
; * getRupeeValue
; * cpRupeeValue
; * removeRupeeValue


.enum 0
	
	RUPEEVAL_000	db ; $00
	RUPEEVAL_001	db ; $01
	RUPEEVAL_002	db ; $02
	RUPEEVAL_005	db ; $03
	RUPEEVAL_010	db ; $04
	RUPEEVAL_020	db ; $05
	RUPEEVAL_040	db ; $06
	RUPEEVAL_030	db ; $07
	RUPEEVAL_060	db ; $08
	RUPEEVAL_070	db ; $09
	RUPEEVAL_025	db ; $0a
	RUPEEVAL_050	db ; $0b
	RUPEEVAL_100	db ; $0c
	RUPEEVAL_200	db ; $0d
	RUPEEVAL_400	db ; $0e
	RUPEEVAL_150	db ; $0f
	RUPEEVAL_300	db ; $10
	RUPEEVAL_500	db ; $11
	RUPEEVAL_900	db ; $12
	RUPEEVAL_080	db ; $13
	RUPEEVAL_999	db ; $14

	RUPEEVAL_COUNT	db ; $15

.ende
