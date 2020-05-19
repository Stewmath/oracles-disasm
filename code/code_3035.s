; For some reason this code shifts places between Ages and Seasons.

;;
; @param	hl
; @addr{3035}
objectLoadMovementScript:
	ldh a,(<hRomBank)
	push af
.ifdef ROM_AGES
	callfrombank0 bank0e.objectLoadMovementScript_body
.else
	callfrombank0 objectLoadMovementScript_body		; $3038 - bank0d
.endif
	pop af
	setrombank
	ret

;;
; @addr{3049}
objectRunMovementScript:
	ldh a,(<hRomBank)
	push af
.ifdef ROM_AGES
	callfrombank0 bank0e.objectRunMovementScript_body
.else
	callfrombank0 objectRunMovementScript_body		; $3038 - bank0d
.endif
	pop af
	setrombank
	ret

;;
; @addr{305d}
decCbb3:
	ld hl,wTmpcbb3
	dec (hl)
	ret

;;
; @addr{3062}
incCbc1:
	ld hl,$cbc1
	inc (hl)
	ret

;;
; @addr{3067}
incCbc2:
	ld hl,$cbc2
	inc (hl)
	ret

;;
; @param	e
; @addr{306c}
endgameCutsceneHandler:
	ldh a,(<hRomBank)
	push af
	callfrombank0 endgameCutsceneHandler_body
	pop af
	setrombank
	ret

;;
; @addr{3080}
getEntryFromObjectTable1:
	ldh a,(<hRomBank)
	push af
	ld a, :objectData.objectTable1
	setrombank
	ld a,b
	ld hl, objectData.objectTable1
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	pop af
	setrombank
	ret

;;
; @addr{3099}
fileSelect_redrawDecorations:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank2.fileSelect_redrawDecorationsAndSetWramBank4
	pop af
	setrombank
	xor a
	ld ($ff00+R_SVBK),a
	ret


.ifdef ROM_AGES
;;
; Does a lot of initialization, sets wActiveGroup/wActiveRoom to the given values. This
; does not load the room's objects.
;
; After calling this, the LCD needs to be re-enabled, and the Link object needs to be
; created.
;
; @param	b	Group
; @param	c	Room
; @addr{30b0}
disableLcdAndLoadRoom:
	ldh a,(<hRomBank)
	push af
	callfrombank0 disableLcdAndLoadRoom_body
	pop af
	setrombank
	ret

;;
; Plays SND_WAVE, and writes something to 'hl'.
;
; @param	hl
; @addr{30c4}
playWaveSoundAtRandomIntervals:
	ldh a,(<hRomBank)
	push af
	callfrombank0 interactionBank10.agesFunc_10_7298@playWaveSoundAtRandomIntervals_body
	pop af
	setrombank
	ret

.endif


;;
; Same as "addSpritesToOam_withOffset", except this changes the bank first.
;
; @param	bc	Sprite offset
; @param	e	Bank where the OAM data is
; @param	hl	OAM data
; @addr{30d8}
addSpritesFromBankToOam_withOffset:
	ldh a,(<hRomBank)
	push af
	ld a,e
	setrombank
	call addSpritesToOam_withOffset
	pop af
	setrombank
	ret


.ifdef ROM_AGES

;;
; Same as "addSpritesToOam", except this changes the bank first.
;
; @param	e	Bank where the OAM data is
; @param	hl	OAM data
; @addr{30eb}
addSpritesFromBankToOam:
	ldh a,(<hRomBank)
	push af
	ld a,e
	setrombank
	call addSpritesToOam
	pop af
	setrombank
	ret

.endif
