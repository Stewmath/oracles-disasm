; Tree refill data is also used for the child and an event in room $2f7.
;
; It waits for you to visit 8 unique rooms in the overworld, then sets the bit
; in wSeedTreeRefilledBitset when you next visit that screen.
;
; For trees, each index corresponds to an enemy object with id "5aXX".

; Arg 1: group / room ($05b for group 0 room $5b, 18a for group 1 room $8a)
; Arg 2: low byte of data location
.macro m_TreeRefillData
	.db \1&$ff \2|(\1>>8)
.endm

seedTreeRefillLocations: ; $6036
	m_TreeRefillData $10b (<w2SeedTreeRefillData+$00)
	m_TreeRefillData $047 (<w2SeedTreeRefillData+$08)
	m_TreeRefillData $000 (<w2SeedTreeRefillData+$10)
	m_TreeRefillData $000 (<w2SeedTreeRefillData+$18)
	m_TreeRefillData $008 (<w2SeedTreeRefillData+$20)
	m_TreeRefillData $013 (<w2SeedTreeRefillData+$28)
	m_TreeRefillData $078 (<w2SeedTreeRefillData+$30)
	m_TreeRefillData $0ac (<w2SeedTreeRefillData+$38)
	m_TreeRefillData $0c1 (<w2SeedTreeRefillData+$40)
	m_TreeRefillData $108 (<w2SeedTreeRefillData+$48)
	m_TreeRefillData $125 (<w2SeedTreeRefillData+$50)
	m_TreeRefillData $12d (<w2SeedTreeRefillData+$58)
	m_TreeRefillData $178 (<w2SeedTreeRefillData+$60)
	m_TreeRefillData $180 (<w2SeedTreeRefillData+$68)
	m_TreeRefillData $1c1 (<w2SeedTreeRefillData+$70)
	m_TreeRefillData $000 (<w2SeedTreeRefillData+$78)
