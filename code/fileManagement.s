;;
; @param c What operation to do on the file
; @param hActiveFileSlot File index
fileManagementFunction:
	ld a,c
	rst_jumpTable
	.dw _initializeFile
	.dw _saveFile
	.dw _loadFile
	.dw _eraseFile

;;
_initializeFile:
	ld hl,_initialFileVariables
	call _initializeFileVariables

	; Load in a: wFileIsHeroGame (bit 1), wFileIsLinkedGame (bit 0)
	ld hl,wFileIsHeroGame
	ldd a,(hl)
	add a
	add (hl)
	push af

	; Initialize data differently based on whether it's a linked or hero game
	ld hl,_initialFileVariablesTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call _initializeFileVariables

	; Clear unappraised rings
	pop af
	ld c,a
	ld hl,wUnappraisedRings
	ld b,$40
	ld a,$ff
	call fillMemory

	; Clear ring box contents
	ld hl,wRingBoxContents
	ld b,$06
	ld a,$ff
	call fillMemory

	; If hero game, give victory ring
	ld a,c
	cp $02
	jr nz,++

	ld hl,wObtainedTreasureFlags
	ld a,TREASURE_RING
	call setFlag
	ld a,VICTORY_RING | $40
	ld (wUnappraisedRings),a
++
	callab commonInteractions5.initializeChildOnGameStart
.ifdef ROM_AGES
	callab roomTileChanges.initializeVinePositions
.endif

;;
; In addition to saving, this is called after creating a file, as well as when it's about
; to be loaded (for some reason)
_saveFile:
	; Write $01 here for "ages", $00 for "seasons"
	ld hl,wWhichGame
.ifdef ROM_AGES
	ld (hl),$01
.else
	ld (hl),$00
.endif

	; String to verify save integrity (unique between ages/seasons)
	ld hl,wSavefileString
	ld de,_saveVerificationString
	ld b,$08
	call copyMemoryReverse

	; Calculate checksum
	ld l,<wFileStart
	call _calculateFileChecksum
	ld (hl),e
	inc l
	ld (hl),d

	; Save file
	ld l,<wFileStart
	call _getFileAddress1
	ld e,c
	ld d,b
	call _copyFileFromHlToDe

	; Save file to backup slot?
	call _getFileAddress2
	ld e,c
	ld d,b
	call _copyFileFromHlToDe

	; Redundant?
	jr _verifyFileCopies

;;
_loadFile:
	call _verifyFileCopies
	push af
	or a
	jr nz,+

	call _getFileAddress1
	jr ++
+
	call _getFileAddress2
++
	ld l,c
	ld h,b
	ld de,wFileStart
	call _copyFileFromHlToDe
	pop af
	ret

;;
_eraseFile:
	call _getFileAddress1
	call @clearFile

	call _getFileAddress2
;;
; @param bc
@clearFile:
	ld a,$0a
	ld ($1111),a
	ld l,c
	ld h,b
	call _clearFileAtHl
	xor a
	ld ($1111),a
	ret

;;
; Clear $0550 bytes at hl
_clearFileAtHl:
	ld bc,$0550
	jp clearMemoryBc

;;
; Checks both copies of the file data to see if one is valid.
; If one is valid but not the other, this also updates the invalid copy with the valid
; copy's data.
; @param[out] a $01 if copy 2 was valid while copy 1 wasn't
_verifyFileCopies:
	call _getFileAddress2
	ld l,c
	ld h,b
	call _verifyFileAtHl
	and $01
	push af

	call _getFileAddress1
	ld l,c
	ld h,b
	call _verifyFileAtHl
	pop bc
	rl b

	; bit 0 set if copy 1 failed, bit 1 set if copy 2 failed
	ld a,b
	rst_jumpTable
	.dw @bothCopiesValid
	.dw @copy1Invalid
	.dw @copy2Invalid
	.dw @bothCopiesInvalid

;;
@copy2Invalid:
	call _getFileAddress2
	ld e,c
	ld d,b
	call _getFileAddress1
	ld l,c
	ld h,b
	call _copyFileFromHlToDe

;;
@bothCopiesValid:
	xor a
	ret

;;
@copy1Invalid:
	call _getFileAddress1
	ld e,c
	ld d,b
	call _getFileAddress2
	ld l,c
	ld h,b
	call _copyFileFromHlToDe
	ld a,$01
	ret

;;
@bothCopiesInvalid:
	ld a,$ff
	ret

;;
; Copy a file ($0550 bytes) from hl to de.
; @param de Destination address
; @param hl Source address
_copyFileFromHlToDe:
	push hl
	ld a,$0a
	ld ($1111),a
	ld bc,$0550
	call copyMemoryBc
	xor a
	ld ($1111),a
	pop hl
	ret

;;
; @param hl Address of file
; @param[out] a Equals $ff if verification failed
; @param[out] cflag Set if verification failed
_verifyFileAtHl:
	push hl
	ld a,$0a
	ld ($1111),a

	; Verify checksum
	call _calculateFileChecksum
	ldi a,(hl)
	cp e
	jr nz,@verifyFailed
	ldi a,(hl)
	cp d
	jr nz,@verifyFailed

	; Verify the savefile string
	ld de,_saveVerificationString
	ld b,$08
@nextChar:
	ld a,(de)
	cp (hl)
	jr nz,@verifyFailed

	inc de
	inc hl
	dec b
	jr nz,@nextChar

@verifyDone:
	xor a
	ld ($1111),a
	pop hl
	ld a,b
	rrca
	ret

	; Clear the save data
@verifyFailed:
	pop hl
	push hl
	call _clearFileAtHl
	ld b,$ff
	jr @verifyDone

;;
; Calculate a checksum over $550 bytes (excluding the first 2) for a save file
; @param hl Address to start at
; @param[out] de Checksum
_calculateFileChecksum:
	push hl
	ld a,$02
	rst_addAToHl
	ld bc,$02a7
	ld de,$0000
--
	ldi a,(hl)
	add e
	ld e,a
	ldi a,(hl)
	adc d
	ld d,a
	dec bc
	ld a,b
	or c
	jr nz,--

	pop hl
	ret

;;
; Get the first address of the save data
; @param hActiveFileSlot Save slot
; @param[out] bc Address
_getFileAddress1:
	ld c,$00
	jr +

;;
; Get the second (backup?) address of the save data
; @param hActiveFileSlot Save slot
; @param[out] bc Address
_getFileAddress2:
	ld c,$03
+
	push hl
	ldh a,(<hActiveFileSlot)
	add c
	ld hl,@saveFileAddresses
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	pop hl
	ret

@saveFileAddresses:
	.dw $a010
	.dw $a560
	.dw $aab0

	.dw $b000
	.dw $b550
	.dw $baa0

;;
; @param hl Address of initial values (should point to _initialFileVariables or some
; variant)
_initializeFileVariables:
	ld d,>wc600Block
--
	ldi a,(hl)
	or a
	jr z,+

	ld e,a
	ldi a,(hl)
	ld (de),a
	jr --
+
	ret

; Table to distinguish initial file data based on whether it's a standard, linked, or hero
; game.
_initialFileVariablesTable:
	.dw _initialFileVariables_standardGame
	.dw _initialFileVariables_linkedGame
	.dw _initialFileVariables_heroGame
	.dw _initialFileVariables_linkedGame

; Initial values for variables in the c6xx block.
_initialFileVariables:
	.db <wTextSpeed				$02
	.db <wc608				$01
	.db <wLinkName+5			$00 ; Ensure names have null terminator
	.db <wKidName+5				$00
	.db <wObtainedTreasureFlags		1<<TREASURE_PUNCH
	.db <wMaxBombs				$10
	.db <wLinkHealth			$10 ; 4 hearts (gets overwritten in standard game)
	.db <wLinkMaxHealth			$10
.ifdef ROM_AGES
	.db <wDeathRespawnBuffer.group		$00
	.db <wDeathRespawnBuffer.room		$8a
	.db <wDeathRespawnBuffer.y		$38
	.db <wDeathRespawnBuffer.x		$48
	.db <wDeathRespawnBuffer.facingDir	$00
	.db <wJabuWaterLevel			$21
	.db <wPortalGroup			$ff
	.db <wPirateShipRoom			$b6
	.db <wPirateShipY			$48
	.db <wPirateShipX			$48
	.db <wPirateShipAngle			$02
.else
	.db <wDeathRespawnBuffer.group		$00
	.db <wDeathRespawnBuffer.room       $a7
	.db <wDeathRespawnBuffer.y          $38
	.db <wDeathRespawnBuffer.x          $48
	.db <wDeathRespawnBuffer.facingDir  $02
.endif
	.db $00

; Standard game (not linked or hero)
_initialFileVariables_standardGame:
	.db <wLinkHealth			$0c
	.db <wLinkMaxHealth			$0c
	; Continue reading the following data

; Hero game (not linked+hero game)
_initialFileVariables_heroGame:
	.db <wChildStatus			$00
	.db <wShieldLevel			$01
.ifdef ROM_AGES
	.db <wAnimalCompanion			$00
.else
	.db <wAnimalCompanion			$0b
.endif
	.db $00

; Linked game, or linked+hero game
_initialFileVariables_linkedGame:
	.db <wSwordLevel			$01
	.db <wShieldLevel			$01
	.db <wInventoryStorage			ITEMID_SWORD
	.db <wObtainedTreasureFlags,		(1<<TREASURE_PUNCH) | (1<<TREASURE_SWORD)
.ifdef ROM_AGES
	.db <wPirateShipY			$58
	.db <wPirateShipX			$78
.endif
	.db $00

; This string is different in ages and seasons.
_saveVerificationString:
.ifdef ROM_AGES
	.ASC "Z21216-0"
.else
	.ASC "Z11216-0"
.endif
