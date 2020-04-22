 m_section_superfree "File_Management" namespace "fileManagement"

;;
; @param c What operation to do on the file
; @param hActiveFileSlot File index
; @addr{4000}
fileManagementFunction:
	ld a,c			; $4000
	rst_jumpTable			; $4001
	.dw _initializeFile
	.dw _saveFile
	.dw _loadFile
	.dw _eraseFile

;;
; @addr{400a}
_initializeFile:
	ld hl,_initialFileVariables		; $400a
	call _initializeFileVariables		; $400d

	; Load in a: wFileIsHeroGame (bit 1), wFileIsLinkedGame (bit 0)
	ld hl,wFileIsHeroGame		; $4010
	ldd a,(hl)		; $4013
	add a			; $4014
	add (hl)		; $4015
	push af			; $4016

	; Initialize data differently based on whether it's a linked or hero game
	ld hl,_initialFileVariablesTable		; $4017
	rst_addDoubleIndex			; $401a
	ldi a,(hl)		; $401b
	ld h,(hl)		; $401c
	ld l,a			; $401d
	call _initializeFileVariables		; $401e

	; Clear unappraised rings
	pop af			; $4021
	ld c,a			; $4022
	ld hl,wUnappraisedRings		; $4023
	ld b,$40		; $4026
	ld a,$ff		; $4028
	call fillMemory		; $402a

	; Clear ring box contents
	ld hl,wRingBoxContents		; $402d
	ld b,$06		; $4030
	ld a,$ff		; $4032
	call fillMemory		; $4034

	; If hero game, give victory ring
	ld a,c			; $4037
	cp $02			; $4038
	jr nz,++		; $403a

	ld hl,wObtainedTreasureFlags		; $403c
	ld a,TREASURE_RING		; $403f
	call setFlag		; $4041
	ld a,VICTORY_RING | $40		; $4044
	ld (wUnappraisedRings),a		; $4046
++
.ifdef ROM_AGES
	callab interactionBank0b.initializeChildOnGameStart		; $4049
	callab initializeVinePositions		; $4051
.else
    callab initializeChildOnGameStart		; $4049
.endif

;;
; In addition to saving, this is called after creating a file, as well as when it's about
; to be loaded (for some reason)
; @addr{4059}
_saveFile:
	; Write $01 here for "ages"
	ld hl,wWhichGame		; $4059
.ifdef ROM_AGES
	ld (hl),$01		; $405c
.else
    ld (hl),$00
.endif

	; String to verify save integrity (unique between ages/seasons)
	ld hl,wSavefileString		; $405e
	ld de,_saveVerificationString		; $4061
	ld b,$08		; $4064
	call copyMemoryReverse		; $4066

	; Calculate checksum
	ld l,<wFileStart		; $4069
	call _calculateFileChecksum		; $406b
	ld (hl),e		; $406e
	inc l			; $406f
	ld (hl),d		; $4070

	; Save file
	ld l,<wFileStart		; $4071
	call _getFileAddress1		; $4073
	ld e,c			; $4076
	ld d,b			; $4077
	call _copyFileFromHlToDe		; $4078

	; Save file to backup slot?
	call _getFileAddress2		; $407b
	ld e,c			; $407e
	ld d,b			; $407f
	call _copyFileFromHlToDe		; $4080

	; Redundant?
	jr _verifyFileCopies		; $4083

;;
; @addr{4085}
_loadFile:
	call _verifyFileCopies		; $4085
	push af			; $4088
	or a			; $4089
	jr nz,+			; $408a

	call _getFileAddress1		; $408c
	jr ++			; $408f
+
	call _getFileAddress2		; $4091
++
	ld l,c			; $4094
	ld h,b			; $4095
	ld de,wFileStart		; $4096
	call _copyFileFromHlToDe		; $4099
	pop af			; $409c
	ret			; $409d

;;
; @addr{409e}
_eraseFile:
	call _getFileAddress1		; $409e
	call @clearFile		; $40a1

	call _getFileAddress2		; $40a4
;;
; @param bc
; @addr{40a7}
@clearFile:
	ld a,$0a		; $40a7
	ld ($1111),a		; $40a9
	ld l,c			; $40ac
	ld h,b			; $40ad
	call _clearFileAtHl		; $40ae
	xor a			; $40b1
	ld ($1111),a		; $40b2
	ret			; $40b5

;;
; Clear $0550 bytes at hl
; @addr{40b6}
_clearFileAtHl:
	ld bc,$0550		; $40b6
	jp clearMemoryBc		; $40b9

;;
; Checks both copies of the file data to see if one is valid.
; If one is valid but not the other, this also updates the invalid copy with the valid
; copy's data.
; @param[out] a $01 if copy 2 was valid while copy 1 wasn't
; @addr{40bc}
_verifyFileCopies:
	call _getFileAddress2		; $40bc
	ld l,c			; $40bf
	ld h,b			; $40c0
	call _verifyFileAtHl		; $40c1
	and $01			; $40c4
	push af			; $40c6

	call _getFileAddress1		; $40c7
	ld l,c			; $40ca
	ld h,b			; $40cb
	call _verifyFileAtHl		; $40cc
	pop bc			; $40cf
	rl b			; $40d0

	; bit 0 set if copy 1 failed, bit 1 set if copy 2 failed
	ld a,b			; $40d2
	rst_jumpTable			; $40d3
	.dw @bothCopiesValid
	.dw @copy1Invalid
	.dw @copy2Invalid
	.dw @bothCopiesInvalid

;;
; @addr{40dc}
@copy2Invalid:
	call _getFileAddress2		; $40dc
	ld e,c			; $40df
	ld d,b			; $40e0
	call _getFileAddress1		; $40e1
	ld l,c			; $40e4
	ld h,b			; $40e5
	call _copyFileFromHlToDe		; $40e6

;;
; @addr{40e9}
@bothCopiesValid:
	xor a			; $40e9
	ret			; $40ea

;;
; @addr{40eb}
@copy1Invalid:
	call _getFileAddress1		; $40eb
	ld e,c			; $40ee
	ld d,b			; $40ef
	call _getFileAddress2		; $40f0
	ld l,c			; $40f3
	ld h,b			; $40f4
	call _copyFileFromHlToDe		; $40f5
	ld a,$01		; $40f8
	ret			; $40fa

;;
; @addr{40fb}
@bothCopiesInvalid:
	ld a,$ff		; $40fb
	ret			; $40fd

;;
; Copy a file ($0550 bytes) from hl to de.
; @param de Destination address
; @param hl Source address
; @addr{40fe}
_copyFileFromHlToDe:
	push hl			; $40fe
	ld a,$0a		; $40ff
	ld ($1111),a		; $4101
	ld bc,$0550		; $4104
	call copyMemoryBc		; $4107
	xor a			; $410a
	ld ($1111),a		; $410b
	pop hl			; $410e
	ret			; $410f

;;
; @param hl Address of file
; @param[out] a Equals $ff if verification failed
; @param[out] cflag Set if verification failed
; @addr{4110}
_verifyFileAtHl:
	push hl			; $4110
	ld a,$0a		; $4111
	ld ($1111),a		; $4113

	; Verify checksum
	call _calculateFileChecksum		; $4116
	ldi a,(hl)		; $4119
	cp e			; $411a
	jr nz,@verifyFailed	; $411b
	ldi a,(hl)		; $411d
	cp d			; $411e
	jr nz,@verifyFailed	; $411f

	; Verify the savefile string
	ld de,_saveVerificationString		; $4121
	ld b,$08		; $4124
@nextChar:
	ld a,(de)		; $4126
	cp (hl)			; $4127
	jr nz,@verifyFailed	; $4128

	inc de			; $412a
	inc hl			; $412b
	dec b			; $412c
	jr nz,@nextChar		; $412d

@verifyDone:
	xor a			; $412f
	ld ($1111),a		; $4130
	pop hl			; $4133
	ld a,b			; $4134
	rrca			; $4135
	ret			; $4136

	; Clear the save data
@verifyFailed:
	pop hl			; $4137
	push hl			; $4138
	call _clearFileAtHl		; $4139
	ld b,$ff		; $413c
	jr @verifyDone		; $413e

;;
; Calculate a checksum over $550 bytes (excluding the first 2) for a save file
; @param hl Address to start at
; @param[out] de Checksum
; @addr{4140}
_calculateFileChecksum:
	push hl			; $4140
	ld a,$02		; $4141
	rst_addAToHl			; $4143
	ld bc,$02a7		; $4144
	ld de,$0000		; $4147
--
	ldi a,(hl)		; $414a
	add e			; $414b
	ld e,a			; $414c
	ldi a,(hl)		; $414d
	adc d			; $414e
	ld d,a			; $414f
	dec bc			; $4150
	ld a,b			; $4151
	or c			; $4152
	jr nz,--		; $4153

	pop hl			; $4155
	ret			; $4156

;;
; Get the first address of the save data
; @param hActiveFileSlot Save slot
; @param[out] bc Address
; @addr{4157}
_getFileAddress1:
	ld c,$00		; $4157
	jr +			; $4159

;;
; Get the second (backup?) address of the save data
; @param hActiveFileSlot Save slot
; @param[out] bc Address
; @addr{415b}
_getFileAddress2:
	ld c,$03		; $415b
+
	push hl			; $415d
	ldh a,(<hActiveFileSlot)	; $415e
	add c			; $4160
	ld hl,@saveFileAddresses		; $4161
	rst_addDoubleIndex			; $4164
	ldi a,(hl)		; $4165
	ld b,(hl)		; $4166
	ld c,a			; $4167
	pop hl			; $4168
	ret			; $4169

; @addr{416a}
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
; @addr{4176}
_initializeFileVariables:
	ld d,>wc600Block		; $4176
--
	ldi a,(hl)		; $4178
	or a			; $4179
	jr z,+			; $417a

	ld e,a			; $417c
	ldi a,(hl)		; $417d
	ld (de),a		; $417e
	jr --			; $417f
+
	ret			; $4181

; Table to distinguish initial file data based on whether it's a standard, linked, or hero
; game.
; @addr{4182}
_initialFileVariablesTable:
	.dw _initialFileVariables_standardGame
	.dw _initialFileVariables_linkedGame
	.dw _initialFileVariables_heroGame
	.dw _initialFileVariables_linkedGame

; Initial values for variables in the c6xx block.
; @addr{418a}
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
; @addr{41b1}
_initialFileVariables_standardGame:
	.db <wLinkHealth			$0c
	.db <wLinkMaxHealth			$0c
	; Continue reading the following data

; Hero game (not linked+hero game)
; @addr{41b5}
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
; @addr{41bc}
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
; @addr{41c9}
_saveVerificationString:
.ifdef ROM_AGES
	.ASC "Z21216-0"
.else
    .ASC "Z11216-0"
.endif

.ends