; Tree refill data is also used for the child and an event in room $6f (king moblin?).
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

seedTreeRefillLocations:
	m_TreeRefillData $f8 (<wxSeedTreeRefillData+$00)
	m_TreeRefillData $9e (<wxSeedTreeRefillData+$08)
	m_TreeRefillData $67 (<wxSeedTreeRefillData+$10)
	m_TreeRefillData $72 (<wxSeedTreeRefillData+$18)
	m_TreeRefillData $5f (<wxSeedTreeRefillData+$20)
	m_TreeRefillData $10 (<wxSeedTreeRefillData+$28)
	m_TreeRefillData $6f (<wxSeedTreeRefillData+$30) ; king moblin?
	m_TreeRefillData $f6 (<wxSeedTreeRefillData+$38) ; child

