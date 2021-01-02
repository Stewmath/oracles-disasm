; Text for shops which should be overwritten by the randomizer. In namespace "bank3f".
;
; Make sure that all of these are 17 characters long (including the null terminator). The randomizer
; assumes it has that much space.


; For both games
randoText_shop150Rupees:
	.db "Strange Flute\0..."


.ifdef ROM_SEASONS

randoText_membersShop1:
	.db "Seed Satchel\0...."

randoText_membersShop2:
	.db "Gasha Seed\0......"

randoText_membersShop3:
	.db "Treasure Map\0...."

randoText_subrosiaMarket1stItem:
	.db "Ribbon\0.........."

randoText_subrosiaMarket2ndItem:
	.db "Rare Peach Stone\0"

randoText_subrosiaMarket5thItem:
	.db "Member's Card\0..."


; For text in text.yaml, the "call" opcode has been modified so that parameters 0xf0-0xfb will
; show the corresponding text from this table.
randoTextSubstitutionTable:
	.dw randoText_shop150Rupees ; 0xf0
	.dw randoText_membersShop1  ; 0xf1
	.dw randoText_membersShop2  ; 0xf2
	.dw randoText_membersShop3  ; 0xf3
	.dw randoText_membersShop3  ; 0xf4
	.dw randoText_subrosiaMarket1stItem ; 0xf5
	.dw randoText_subrosiaMarket2ndItem ; 0xf6
	.dw randoText_subrosiaMarket5thItem ; 0xf7


.else; ROM_AGES

randoTextSubstitutionTable:
	.dw randoText_shop150Rupees ; 0xf0

.endif
