; For some reason this code shifts places between Ages and Seasons.

;;
; @addr{3035}
objectFunc_3035:
	ldh a,(<hRomBank)	; $3035
	push af			; $3037
	callfrombank0 bank0e.objectfunc_6b2d		; $3038
	pop af			; $3042
	ldh (<hRomBank),a	; $3043
	ld ($2222),a		; $3045
	ret			; $3048

;;
; @addr{3049}
objectFunc_3049:
	ldh a,(<hRomBank)	; $3049
	push af			; $304b
	callfrombank0 bank0e.objectFunc_6b4c		; $304c
	pop af			; $3056
	setrombank		; $3057
	ret			; $305c

;;
; @addr{305d}
decCbb3:
	ld hl,wTmpcbb3		; $305d
	dec (hl)		; $3060
	ret			; $3061

;;
; @addr{3062}
incCbc1:
	ld hl,$cbc1		; $3062
	inc (hl)		; $3065
	ret			; $3066

;;
; @addr{3067}
incCbc2:
	ld hl,$cbc2		; $3067
	inc (hl)		; $306a
	ret			; $306b

;;
; @param	e
; @addr{306c}
func_306c:
	ldh a,(<hRomBank)	; $306c
	push af			; $306e
	callfrombank0 func_03_5414		; $306f
	pop af			; $3079
	setrombank		; $307a
	ret			; $307f

;;
; @addr{3080}
getEntryFromObjectTable1:
	ldh a,(<hRomBank)	; $3080
	push af			; $3082
	ld a, :objectData.objectTable1
	setrombank		; $3085
	ld a,b			; $308a
	ld hl, objectData.objectTable1
	rst_addDoubleIndex			; $308e
	ldi a,(hl)		; $308f
	ld h,(hl)		; $3090
	ld l,a			; $3091
	pop af			; $3092
	setrombank		; $3093
	ret			; $3098

;;
; @addr{3099}
fileSelect_redrawDecorations:
	ldh a,(<hRomBank)	; $3099
	push af			; $309b
	callfrombank0 bank2.fileSelect_redrawDecorationsAndSetWramBank4	; $309c
	pop af			; $30a6
	setrombank		; $30a7
	xor a			; $30ac
	ld ($ff00+R_SVBK),a	; $30ad
	ret			; $30af


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
	ldh a,(<hRomBank)	; $30b0
	push af			; $30b2
	callfrombank0 disableLcdAndLoadRoom_body		; $30b3
	pop af			; $30bd
	setrombank		; $30be
	ret			; $30c3

;;
; Plays SND_WAVE, and writes something to 'hl'.
;
; @param	hl
; @addr{30c4}
func_30c4:
	ldh a,(<hRomBank)	; $30c4
	push af			; $30c6
	callfrombank0 func_10_7328		; $30c7
	pop af			; $30d1
	setrombank		; $30d2
	ret			; $30d7

.else ; ROM_SEASONS

; Placeholder labels
disableLcdAndLoadRoom:
func_30c4:

.endif


;;
; Same as "addSpritesToOam_withOffset", except this changes the bank first.
;
; @param	bc	Sprite offset
; @param	e	Bank where the OAM data is
; @param	hl	OAM data
; @addr{30d8}
addSpritesFromBankToOam_withOffset:
	ldh a,(<hRomBank)	; $30d8
	push af			; $30da
	ld a,e			; $30db
	setrombank		; $30dc
	call addSpritesToOam_withOffset		; $30e1
	pop af			; $30e4
	setrombank		; $30e5
	ret			; $30ea

