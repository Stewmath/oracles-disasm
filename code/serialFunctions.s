 m_section_free serialCode NAMESPACE serialCode

;;
func_4000:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret z
	ldh a,(<SVBK)
	push af
	ld a,SERIAL_WRAM_BANK
	ldh (<SVBK),a
	push de
	call _func_4036
	pop de
	ldh a,(<SC)
	rlca
	jr c,++
	ldh a,(<hSerialInterruptBehaviour)
	cp SERIAL_UPPER_NIBBLE + $d0
	jr z,+
	ld a,($d98b)
	or a
	jr nz,++
	ld a,($d983)
	xor $01
	ld ($d983),a
	jr z,++
	ldh a,(<hSerialInterruptBehaviour)
+
	and $81
	call writeToSC
++
	pop af
	ldh (<SVBK),a
	ret


_func_4036:
	ldh a,(<hFFBE)
	rst_jumpTable
	.dw _FFBE_00
	.dw _FFBE_01
	.dw _FFBE_02
	.dw _FFBE_03
	.dw _FFBE_04


_func_4043:
	call _waitForSerialByte
	cp $80
	ret z


;;
; Send the byte [w4PacketBuffer+[w4PacketByteIndex]] over the link cable.
_sendPacketByte:
	ld a,(w4PacketByteIndex)
	ld hl,w4PacketBuffer
	rst_addAToHl
	ld a,(w4PacketByteIndex)
	or a
	jr nz,@nextByte
	ld a,(hl)
	or a
	jr nz,@getNumBytes
	inc a
	ld ($d98b),a
	ret

@getNumBytes:
	ld (w4NumPacketBytes),a
	xor a
	ld (w4PacketChecksum),a

@nextByte:
	inc a
	ld (w4PacketByteIndex),a
	ld a,(w4NumPacketBytes)
	dec a
	ld (w4NumPacketBytes),a
	ldi a,(hl)
	jr nz,+

	; Finished receiving packet
	xor a
	ld (w4WaitingForNextByte),a
	ld a,(w4PacketChecksum)
+
	ldh (<SB),a ; Send: # of bytes remaining to be read, or [w4PacketChecksum] if finished
	ld hl,w4PacketChecksum
	add (hl)
	ld (hl),a
	xor a
	ld ($d98b),a
	ret


_func_4087:
	ldh a,(<hReceivedSerialByte)
	or a
	ret z
	ld a,$01
	ld ($d98b),a
	xor a
	ld ($ff00+R_SB),a
	ldh (<hReceivedSerialByte),a
	ret


_func_4096:
	call _waitForSerialByte
	cp $80
	jp z,disableSerialPort
	jp _prepareForNextPacket

;;
_disableSerialIfByteReceived:
	call _waitForSerialByte
	jp disableSerialPort


;;
; If available, receive another byte and write it to w4PacketBuffer+[w4PacketByteIndex].
_receivePacketByte:
	xor a
	ld ($d98b),a
	call _waitForSerialByte
	cp $80
	ret z

	ld a,(w4PacketByteIndex)
	ld b,a
	or a
	jr nz,@gotPacketByte

	; Receiving first byte (length)
	ldh a,(<hSerialByte)
	cp $ff
	jr z,+
	or a
	jr nz,@gotPacketLength
+
	; Received $00 or $ff for "length" byte.
	ld a,(w4DisableLinkTimeout)
	or a
	ret nz
	ld hl,$d984
	inc (hl)
	ret nz
	ld a,$86
	ldh (<hFFBD),a
	xor a
	ld (w4WaitingForNextByte),a
	ret

@gotPacketLength:
	ld (w4NumPacketBytes),a

@gotPacketByte:
	ld hl,w4NumPacketBytes
	dec (hl)
	jr nz,@getNextByte

	ldh a,(<hSerialByte)
	ld hl,w4PacketChecksum
	cp (hl)
	jr z,+

	; Checksum failure
	ld a,$81
	ldh (<hFFBD),a
+
	xor a
	ld (w4WaitingForNextByte),a
	ld ($d984),a
	ld ($ff00+R_SB),a
	ret

@getNextByte:
	ld a,b
	ld de,w4PacketBuffer
	call addAToDe
	ld a,b
	inc a
	ld (w4PacketByteIndex),a
	ldh a,(<hSerialByte)
	ld (de),a
	ld hl,w4PacketChecksum
	add (hl)
	ld (hl),a
	xor a
	ld ($ff00+R_SB),a
	ld ($d984),a
	ret


; "game link" option, maybe also ring linking?
_FFBE_04:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw _gameLink_getFile1
	.dw _waitForNextPacket
	.dw _gameLink_getFile2
	.dw _waitForNextPacket
	.dw _gameLink_getFile3
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _func_4087
	.dw _gameLinkState08
	.dw _gameLinkState09
	.dw _func_438e
	.dw _gameLinkState0b
	.dw _gameLinkState0c
	.dw _gameLinkState0d
	.dw _func_438e
	.dw _gameLinkState0f
	.dw _waitForNextPacket
	.dw _func_4096
	.dw _gameLinkState12
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _sendAckPacket
	.dw _waitForNextPacket
	.dw _func_4096
	.dw _func_437b


; Game is in "receive" mode (titlescreen or earlier)
_FFBE_03:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw _receiveLinkState00
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _receiveLinkState03
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _receiveLinkState06
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _sendAckPacket
	.dw _waitForNextPacket
	.dw _receiveLinkState0b
	.dw _waitForNextPacket
	.dw _disableSerialIfByteReceived
	.dw _waitForNextPacket
	.dw _func_4096
	.dw _receiveLinkState10
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _receiveLinkState13
	.dw _sendAckPacket
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _func_437b


_receiveLinkState00:
	xor a
	jr ++

_receiveLinkState03:
	ld a,$01
	jr ++

_receiveLinkState06:
	ld a,$02
++
	ldh (<hActiveFileSlot),a
	call loadFile
	ldh (<hFF8B),a

;;
; Sends the "header" of the file (information necessary to display the file, also the first $16
; bytes of data starting at $c600)
_sendFileHeader:
	call _prepareForNextPacket
	ld hl,w4PacketBuffer
	ld a,$21
	ldi (hl),a		; w4PacketBuffer
	ld c,a
	ldh a,(<hFF8B)		; File index
	ldi (hl),a		; w4PacketBuffer+1
	ldi (hl),a		; w4PacketBuffer+2
	add a
	add c
	ld c,a
	ld a,(wLinkMaxHealth)
	ldi (hl),a		; w4PacketBuffer+3
	ldi (hl),a		; w4PacketBuffer+4
	add a
	add c
	ld c,a
	ld a,(wDeathCounter)
	ldi (hl),a		; w4PacketBuffer+5
	add c
	ld c,a
	ld a,(wDeathCounter+1)
	ldi (hl),a		; w4PacketBuffer+6
	add c
	ld c,a
	ld a,(wFileIsLinkedGame)
	ldi (hl),a		; w4PacketBuffer+7
	add c
	ld c,a
	ld a,(wFileIsHeroGame)
	add a
	ld e,a
	ld a,(wFileIsCompleted)
	or e
	ldi (hl),a		; w4PacketBuffer+8
	add c
	ld c,a
	ld de,wGameID
	ld b,$16
--
	ld a,(de)
	ldi (hl),a		; w4PacketBuffer+9
	add c
	ld c,a
	inc e
	dec b
	jr nz,--

.ifdef ROM_AGES
	ld a,SERIAL_UPPER_NIBBLE + $91
.else
	ld a,SERIAL_UPPER_NIBBLE + $90
.endif
	ldi (hl),a		; w4PacketBuffer+$1f
	add c
	ld c,a
	ldh a,(<hActiveFileSlot)
	ld (hl),a		; w4PacketBuffer+$20
	add c
	ldi (hl),a		; w4PacketBuffer+$20
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp _sendPacketByte


;;
; Returns from caller if no new byte has been read from the serial port.
;
; @param[out]	a	$80 if timeout occurred.
_waitForSerialByte:
	ldh a,(<hReceivedSerialByte)
	or a
	jr nz,@byteReceived
	ld a,(w4DisableLinkTimeout)
	or a
	jr nz,+
	ld hl,w4FileLinkTimer
	call decHlRef16WithCap
	jr z,@timeout
+
	pop af
	ret

@timeout:
	xor a
	ld (w4WaitingForNextByte),a
	ld a,$80
	ldh (<hFFBD),a
	ret

@byteReceived:
	ld (w4WaitingForNextByte),a
	xor a
	ldh (<hReceivedSerialByte),a
	ldh (<hFFBD),a

_setLinkTimerTo180:
	ld a,180
	ld (w4FileLinkTimer),a
	ld a,$00
	ld (w4FileLinkTimer+1),a
	ret


_FFBE_00:
_FFBE_01:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw _sendFileHeader
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _func_4293
	.dw _waitForNextPacket
	.dw _func_4096
	.dw _determineRingFortuneRing


_FFBE_02:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw _func_4293
	.dw _waitForNextPacket
	.dw _func_4096
	.dw _sendFileHeader
	.dw _waitForNextPacket
	.dw _func_438e
	.dw _determineRingFortuneRing


;;
_determineRingFortuneRing:
	call disableSerialPort
	xor a
	ldh (<hFFBD),a

	; Can't do ring fortune if name & GameID of files are the same?
	call _compareFileHeader
	jr z,@sameFileLineage

	; Add high bytes of GameIDs together to determine which set of rings to pull from?
	ld hl,wGameID
	ld a,(w4RingFortuneStuff)
	add (hl)
	and $7f
	ld b,$00
	and $7c
	jr z,+
	inc b
	and $60
	jr z,+
	inc b
+
	inc l
	ld c,(hl)
	ld a,b
	ld hl,_ringFortuneTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; Use the low byte of the other file's GameID to determine which of the rings to get from
	; the set?
	ld a,(w4RingFortuneStuff+1)
	add c
	and $07
	rst_addAToHl
	ld a,(hl)
	ld (w4RingFortuneStuff),a
	ret

@sameFileLineage:
	ld a,$84
	ldh (<hFFBD),a
	ret


;;
; Increment hSerialLinkState, clear various variables in preparation for a new packet?
_prepareForNextPacket:
	ldh a,(<hSerialLinkState)
	inc a
	ldh (<hSerialLinkState),a
_func_426e:
	xor a
	ld (w4PacketByteIndex),a
	ldh (<hFFBD),a
	ld (w4PacketChecksum),a
	ld ($d984),a
	inc a
	ld (w4WaitingForNextByte),a
	jr _setLinkTimerTo180


;;
_waitForNextPacket:
	call _func_4043
	call _returnIfPacketNotComplete
	ld a,(w4LinkRetryCounter)
	or a
	jr z,_prepareForNextPacket
	ldh a,(<hSerialLinkState)
	dec a
	ldh (<hSerialLinkState),a
	jr _func_426e


;;
_func_4293:
	call _receivePacketByte
	call _returnIfPacketNotComplete
	ld hl,w4RingFortuneStuff
	ld de,w4PacketBuffer+9
	ld b,$07
	call copyMemoryReverse
	jp _sendAckPacket


;;
_receiveLinkState0b:
	ld a,(w4PacketByteIndex)
	or a
	ld a,$00
	jr nz,+
	inc a
+
	ld (w4DisableLinkTimeout),a
	call _receivePacketByte
	ld a,(w4WaitingForNextByte)
	or a
	ret nz
	ld a,(w4PacketBuffer+1)
	cp $c0
	jr nz,_func_42c5
	jp _sendAckPacket


_func_42c5:
	cp $b0
	jp nz,_sendRetryPacket
	ld a,(w4PacketBuffer+2)
	ldh (<hActiveFileSlot),a
	cp $03
	jp nc,disableSerialPort
	call loadFile
	ld a,$0d
	ldh (<hSerialLinkState),a
	jp _sendAckPacket


_receiveLinkState10:
	call _prepareForNextPacket
	ld hl,w4RingFortuneStuff
	ld de,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jr _func_4350


_gameLinkState08:
	call _prepareForNextPacket
	ld hl,w4PacketBuffer
	ld a,$03
	ldi (hl),a
	ld a,$c0
	ldi (hl),a
	ld a,$c3
	ld (hl),a
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp _sendPacketByte


_gameLinkState09:
_gameLinkState0d:
	call _func_4043
	call _returnIfPacketNotComplete
	jp _prepareForNextPacket


_receiveLinkState13:
	call _receivePacketByte
	call _returnIfPacketNotComplete

	; Check if previous packet's checksum failed
	ldh a,(<hFFBD)
	cp $81
	jp z,_prepareForNextPacket

	ld hl,w4RingFortuneStuff
	ld de,w4PacketBuffer+1
	ld b,$08
	call copyMemoryReverse
	jp _prepareForNextPacket


_gameLinkState0f:
	call _receivePacketByte
	call _returnIfPacketNotComplete
	ld hl,wRingsObtained
	ld de,w4PacketBuffer+1
	ld b,$08
-
	ld a,(de)
	or (hl)
	ld (de),a
	inc hl
	inc de
	dec b
	jr nz,-
	ld hl,w4RingFortuneStuff
	ld de,w4PacketBuffer+1
	ld b,$08
	call copyMemoryReverse
	jp _sendAckPacket


_gameLinkState12:
	call _prepareForNextPacket
_func_4350:
	ld a,$0a
	ld c,a
	ld (w4PacketBuffer),a
	ld de,w4PacketBuffer+1
	ld hl,w4RingFortuneStuff
	ld b,$08
-
	ldi a,(hl)
	ld (de),a
	inc de
	add c
	ld c,a
	dec b
	jr nz,-
	ld a,c
	ld (de),a
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp _sendPacketByte


_gameLinkState0b:
	call _waitForSerialByte
	cp $80
	jp z,disableSerialPort
	jp disableSerialPort


_func_437b:
	call disableSerialPort
	ldh (<hFFBD),a
	ld de,w4RingFortuneStuff
	ld hl,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jp saveFile


_func_438e:
	call _func_439a
	call _returnIfPacketNotComplete
	call _prepareForNextPacket
	jp _func_4036


_func_439a:
	call _receivePacketByte
	ld a,(w4WaitingForNextByte)
	or a
	ret nz
	ldh a,(<hFFBD)
	or a
	jr z,_func_43ab
	pop af
	jp disableSerialPort


_func_43ab:
	ld a,(w4PacketBuffer+1)
	cp SERIAL_UPPER_NIBBLE + $a1
	jr nz,_func_43bd
	xor a
	ld (w4LinkRetryCounter),a
	ldh a,(<hSerialLinkState)
	sub $02
	ldh (<hSerialLinkState),a
	ret


_func_43bd:
	cp SERIAL_UPPER_NIBBLE + $a0
	ret z
	ld a,$82
	ldh (<hFFBD),a
	ret


_gameLinkState0c:
	call _prepareForNextPacket
	ld hl,w4PacketBuffer
	ld a,$04
	ldi (hl),a
	ld a,$b0
	ldi (hl),a
	ld a,(wTmpcbbc)
	ldi (hl),a
	add $b4
	ldi (hl),a
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp _sendPacketByte


;;
; This seems to be used when something fails and the game tries again?
_sendRetryPacket:
	ld hl,_retryPacket
	ld a,(w4LinkRetryCounter)
	inc a
	ld (w4LinkRetryCounter),a
	cp $05
	jr c,_setPacketBuffer
	ld a,$80
	ldh (<hFFBD),a
	jp disableSerialPort


;;
; TODO: I don't know if this actually represents an ACK
_sendAckPacket:
	xor a
	ld (w4LinkRetryCounter),a
	ld hl,_ackPacket

;;
; @param	hl	Packet data to send (copied to w4PacketBuffer; 1st byte is size)
_setPacketBuffer:
	call _prepareForNextPacket
	ld a,(hl)
	ld b,a
	ld de,w4PacketBuffer
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-
	jp _sendPacketByte


_gameLink_getFile1:
	ld a,$00
	jr ++

_gameLink_getFile2:
	ld a,$01
	jr ++

_gameLink_getFile3:
	ld a,$02
++
	ldh (<hFF8B),a
	call _receivePacketByte
	call _returnIfPacketNotComplete

	ldh a,(<hFF8B) ; File index
	ld hl,w4PacketBuffer+32
	jr nz,_sendRetryPacket

	; Copy file display variables to w4FileDisplayVariables + fileIndex * 8
	swap a
	rrca
	ld hl,w4FileDisplayVariables
	rst_addAToHl
	ld de,w4PacketBuffer+1
	ld b,$08
-
	ld a,(de)
	ldi (hl),a
	inc de
	dec b
	jr nz,-

	; Copy name of file to w4NameBuffer + fileIndex * 6
	ldh a,(<hFF8B)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld de,w4PacketBuffer+11
	ld b,$06
	call copyMemoryReverse

	; Copy the first $16 bytes of the file data ($c600-$c615) to another buffer
	ldh a,(<hFF8B)
	inc a
	ld hl,w4RingFortuneStuff
	ld bc,$0016
-
	dec a
	jr z,++
	add hl,bc
	jr -
++
	ld b,$16
	ld de,w4PacketBuffer+9
	call copyMemoryReverse

	; Decide whether to display the file
	ld a,(wOpenedMenuType)
	cp MENU_RING_LINK
	jr nz,@gameLink

; Ignore file (mark as "blank") if the gameIDs don't match, or if it's not completed, not linked,
; and not a hero game
@ringLink:
	ld de,w4PacketBuffer+9
	call _compareFileIDsAndNames
	jr nz,_markFileAsBlank
	ld hl,w4PacketBuffer+27 ; wFileIsLinkedGame
	ldi a,(hl)
	or (hl) ; w4PacketBuffer+28 (wFileIsHeroGame)
	inc l
	or (hl) ; w4PacketBuffer+29 (wFileIsCompleted)
	jr z,_markFileAsBlank 
	jp _sendAckPacket


; Ignore file (mark as "blank") if wrong game, or if not completed
@gameLink:
	ld a,(w4PacketBuffer+31)
.ifdef ROM_AGES
	cp SERIAL_UPPER_NIBBLE + $90
.else
	cp SERIAL_UPPER_NIBBLE + $91
.endif
	jr nz,_markFileAsBlank
	ld a,(w4PacketBuffer+29) ; wFileIsCompleted
	or a
	jr z,_markFileAsBlank
	jp _sendAckPacket


;;
; This is used when the game chooses to ignore a file, ie. because it's not completed or the GameID
; is wrong.
_markFileAsBlank:
	ldh a,(<hFF8B)
	ld d,FileDisplayStruct.b0
	swap a
	rrca
	add d
	ld hl,w4FileDisplayVariables
	rst_addAToHl
	set 7,(hl) ; Mark as "blank file"
	ldh a,(<hFF8B)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld b,$06
	call clearMemory
	jp _sendAckPacket

;;
; Called upon selecting "Game Link" in file select, and other things. "Initializes" linking?
func_44ac:
	ldh a,(<SVBK)
	push af
	ld a,SERIAL_WRAM_BANK
	ldh (<SVBK),a

	xor a
	ld hl,$d980
	ldi (hl),a ; $d980
	ldi (hl),a ; w4PacketByteIndex
	ldi (hl),a ; w4PacketChecksum
	ldi (hl),a ; $d983
	ldi (hl),a ; $d984
	ldi (hl),a ; w4DisableLinkTimeout
	ldi (hl),a ; w4LinkRetryCounter
	ldh (<hFFBE),a
	ldh (<hSerialLinkState),a
	ldh (<hFFBD),a
	call _setLinkTimerTo180

	ld a,SERIAL_UPPER_NIBBLE + $d1
	ldh (<R_SB),a
	ld a,$80
	ld (w4WaitingForNextByte),a
	call writeToSC

	pop af
	ldh (<SVBK),a
	ret


;;
; This returns from the caller until a packet has been fully received, or there was an error?
;
; @param[out]	zflag	z on success; nz if there was a problem receiving the data.
_returnIfPacketNotComplete:
	ld a,(w4WaitingForNextByte)
	or a
	jr z,++
	pop af
	ret
++
	ldh a,(<hFFBD)
	or a
	ret z

	; Check if previous packet's checksum failed
	cp $81
	jp z,_sendRetryPacket

	pop af
	jp disableSerialPort


;;
_compareFileHeader:
	ld de,w4RingFortuneStuff

;;
; @param	de	Pointer to first 7 bytes of some file data
;
; @param[out]	zflag	z if it matches the current file
_compareFileIDsAndNames:
	ld hl,wGameID
	ld b,$07
-
	ld a,(de)
	cp (hl)
	ret nz
	inc de
	inc l
	dec b
	jr nz,-
	ret


_ackPacket:
	.db $03, SERIAL_UPPER_NIBBLE + $a0, SERIAL_UPPER_NIBBLE + $a3

_retryPacket:
	.db $03, SERIAL_UPPER_NIBBLE + $a1, SERIAL_UPPER_NIBBLE + $a4


_ringFortuneTable:
	.db @rings0 - CADDR
	.db @rings1 - CADDR
	.db @rings2 - CADDR

; Good rings
@rings0:
	.db MAPLES_RING, FIRST_GEN_RING, FIRST_GEN_RING, BOMBPROOF_RING
	.db ENERGY_RING, DBL_EDGED_RING, MAPLES_RING,    RED_LUCK_RING

; OK rings
@rings1:
	.db PEACE_RING, HEART_RING_L2, RED_JOY_RING, RED_JOY_RING
	.db GASHA_RING, PEACE_RING,    TOSS_RING,    ZORA_RING

; Bad rings
@rings2:
	.db CURSED_RING,    GREEN_LUCK_RING,  BLUE_LUCK_RING, GREEN_HOLY_RING
	.db BLUE_HOLY_RING, RED_HOLY_RING,    CURSED_RING,    WHISP_RING

.ends
