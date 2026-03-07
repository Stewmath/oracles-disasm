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
	call func_4036
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


func_4036:
	ldh a,(<hFFBE)
	rst_jumpTable
	.dw FFBE_00
	.dw FFBE_01
	.dw FFBE_02
	.dw FFBE_03
	.dw FFBE_04


func_4043:
	call waitForSerialByte
	cp $80
	ret z


;;
; Send the byte [w4PacketBuffer+[w4PacketByteIndex]] over the link cable.
sendPacketByte:
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


func_4087:
	ldh a,(<hReceivedSerialByte)
	or a
	ret z
	ld a,$01
	ld ($d98b),a
	xor a
	ld ($ff00+R_SB),a
	ldh (<hReceivedSerialByte),a
	ret


func_4096:
	call waitForSerialByte
	cp $80
	jp z,disableSerialPort
	jp prepareForNextPacket

;;
disableSerialIfByteReceived:
	call waitForSerialByte
	jp disableSerialPort


;;
; If available, receive another byte and write it to w4PacketBuffer+[w4PacketByteIndex].
receivePacketByte:
	xor a
	ld ($d98b),a
	call waitForSerialByte
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
FFBE_04:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw gameLink_getFile1
	.dw waitForNextPacket
	.dw gameLink_getFile2
	.dw waitForNextPacket
	.dw gameLink_getFile3
	.dw waitForNextPacket
	.dw func_438e
	.dw func_4087
	.dw gameLinkState08
	.dw gameLinkState09
	.dw func_438e
	.dw gameLinkState0b
	.dw gameLinkState0c
	.dw gameLinkState0d
	.dw func_438e
	.dw gameLinkState0f
	.dw waitForNextPacket
	.dw func_4096
	.dw gameLinkState12
	.dw waitForNextPacket
	.dw func_438e
	.dw sendAckPacket
	.dw waitForNextPacket
	.dw func_4096
	.dw func_437b


; Game is in "receive" mode (titlescreen or earlier)
FFBE_03:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw receiveLinkState00
	.dw waitForNextPacket
	.dw func_438e
	.dw receiveLinkState03
	.dw waitForNextPacket
	.dw func_438e
	.dw receiveLinkState06
	.dw waitForNextPacket
	.dw func_438e
	.dw sendAckPacket
	.dw waitForNextPacket
	.dw receiveLinkState0b
	.dw waitForNextPacket
	.dw disableSerialIfByteReceived
	.dw waitForNextPacket
	.dw func_4096
	.dw receiveLinkState10
	.dw waitForNextPacket
	.dw func_438e
	.dw receiveLinkState13
	.dw sendAckPacket
	.dw waitForNextPacket
	.dw func_438e
	.dw func_437b


receiveLinkState00:
	xor a
	jr ++

receiveLinkState03:
	ld a,$01
	jr ++

receiveLinkState06:
	ld a,$02
++
	ldh (<hActiveFileSlot),a
	call loadFile
	ldh (<hFF8B),a

;;
; Sends the "header" of the file (information necessary to display the file, also the first $16
; bytes of data starting at $c600)
sendFileHeader:
	call prepareForNextPacket
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
	jp sendPacketByte


;;
; Returns from caller if no new byte has been read from the serial port.
;
; @param[out]	a	$80 if timeout occurred.
waitForSerialByte:
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

setLinkTimerTo180:
	ld a,180
	ld (w4FileLinkTimer),a
	ld a,$00
	ld (w4FileLinkTimer+1),a
	ret


FFBE_00:
FFBE_01:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw sendFileHeader
	.dw waitForNextPacket
	.dw func_438e
	.dw func_4293
	.dw waitForNextPacket
	.dw func_4096
	.dw determineRingFortuneRing


FFBE_02:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	.dw func_4293
	.dw waitForNextPacket
	.dw func_4096
	.dw sendFileHeader
	.dw waitForNextPacket
	.dw func_438e
	.dw determineRingFortuneRing


;;
determineRingFortuneRing:
	call disableSerialPort
	xor a
	ldh (<hFFBD),a

	; Can't do ring fortune if name & GameID of files are the same?
	call compareFileHeader
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
	ld hl,ringFortuneTable
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
prepareForNextPacket:
	ldh a,(<hSerialLinkState)
	inc a
	ldh (<hSerialLinkState),a
func_426e:
	xor a
	ld (w4PacketByteIndex),a
	ldh (<hFFBD),a
	ld (w4PacketChecksum),a
	ld ($d984),a
	inc a
	ld (w4WaitingForNextByte),a
	jr setLinkTimerTo180


;;
waitForNextPacket:
	call func_4043
	call returnIfPacketNotComplete
	ld a,(w4LinkRetryCounter)
	or a
	jr z,prepareForNextPacket
	ldh a,(<hSerialLinkState)
	dec a
	ldh (<hSerialLinkState),a
	jr func_426e


;;
func_4293:
	call receivePacketByte
	call returnIfPacketNotComplete
	ld hl,w4RingFortuneStuff
	ld de,w4PacketBuffer+9
	ld b,$07
	call copyMemoryReverse
	jp sendAckPacket


;;
receiveLinkState0b:
	ld a,(w4PacketByteIndex)
	or a
	ld a,$00
	jr nz,+
	inc a
+
	ld (w4DisableLinkTimeout),a
	call receivePacketByte
	ld a,(w4WaitingForNextByte)
	or a
	ret nz
	ld a,(w4PacketBuffer+1)
	cp $c0
	jr nz,func_42c5
	jp sendAckPacket


func_42c5:
	cp $b0
	jp nz,sendRetryPacket
	ld a,(w4PacketBuffer+2)
	ldh (<hActiveFileSlot),a
	cp $03
	jp nc,disableSerialPort
	call loadFile
	ld a,$0d
	ldh (<hSerialLinkState),a
	jp sendAckPacket


receiveLinkState10:
	call prepareForNextPacket
	ld hl,w4RingFortuneStuff
	ld de,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jr func_4350


gameLinkState08:
	call prepareForNextPacket
	ld hl,w4PacketBuffer
	ld a,$03
	ldi (hl),a
	ld a,$c0
	ldi (hl),a
	ld a,$c3
	ld (hl),a
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp sendPacketByte


gameLinkState09:
gameLinkState0d:
	call func_4043
	call returnIfPacketNotComplete
	jp prepareForNextPacket


receiveLinkState13:
	call receivePacketByte
	call returnIfPacketNotComplete

	; Check if previous packet's checksum failed
	ldh a,(<hFFBD)
	cp $81
	jp z,prepareForNextPacket

	ld hl,w4RingFortuneStuff
	ld de,w4PacketBuffer+1
	ld b,$08
	call copyMemoryReverse
	jp prepareForNextPacket


gameLinkState0f:
	call receivePacketByte
	call returnIfPacketNotComplete
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
	jp sendAckPacket


gameLinkState12:
	call prepareForNextPacket
func_4350:
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
	jp sendPacketByte


gameLinkState0b:
	call waitForSerialByte
	cp $80
	jp z,disableSerialPort
	jp disableSerialPort


func_437b:
	call disableSerialPort
	ldh (<hFFBD),a
	ld de,w4RingFortuneStuff
	ld hl,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jp saveFile


func_438e:
	call func_439a
	call returnIfPacketNotComplete
	call prepareForNextPacket
	jp func_4036


func_439a:
	call receivePacketByte
	ld a,(w4WaitingForNextByte)
	or a
	ret nz
	ldh a,(<hFFBD)
	or a
	jr z,func_43ab
	pop af
	jp disableSerialPort


func_43ab:
	ld a,(w4PacketBuffer+1)
	cp SERIAL_UPPER_NIBBLE + $a1
	jr nz,func_43bd
	xor a
	ld (w4LinkRetryCounter),a
	ldh a,(<hSerialLinkState)
	sub $02
	ldh (<hSerialLinkState),a
	ret


func_43bd:
	cp SERIAL_UPPER_NIBBLE + $a0
	ret z
	ld a,$82
	ldh (<hFFBD),a
	ret


gameLinkState0c:
	call prepareForNextPacket
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
	jp sendPacketByte


;;
; This seems to be used when something fails and the game tries again?
sendRetryPacket:
	ld hl,retryPacket
	ld a,(w4LinkRetryCounter)
	inc a
	ld (w4LinkRetryCounter),a
	cp $05
	jr c,setPacketBuffer
	ld a,$80
	ldh (<hFFBD),a
	jp disableSerialPort


;;
; TODO: I don't know if this actually represents an ACK
sendAckPacket:
	xor a
	ld (w4LinkRetryCounter),a
	ld hl,ackPacket

;;
; @param	hl	Packet data to send (copied to w4PacketBuffer; 1st byte is size)
setPacketBuffer:
	call prepareForNextPacket
	ld a,(hl)
	ld b,a
	ld de,w4PacketBuffer
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-
	jp sendPacketByte


gameLink_getFile1:
	ld a,$00
	jr ++

gameLink_getFile2:
	ld a,$01
	jr ++

gameLink_getFile3:
	ld a,$02
++
	ldh (<hFF8B),a
	call receivePacketByte
	call returnIfPacketNotComplete

	ldh a,(<hFF8B) ; File index
	ld hl,w4PacketBuffer+32
	jr nz,sendRetryPacket

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
	call compareFileIDsAndNames
	jr nz,markFileAsBlank
	ld hl,w4PacketBuffer+27 ; wFileIsLinkedGame
	ldi a,(hl)
	or (hl) ; w4PacketBuffer+28 (wFileIsHeroGame)
	inc l
	or (hl) ; w4PacketBuffer+29 (wFileIsCompleted)
	jr z,markFileAsBlank
	jp sendAckPacket


; Ignore file (mark as "blank") if wrong game, or if not completed
@gameLink:
	ld a,(w4PacketBuffer+31)
.ifdef ROM_AGES
	cp SERIAL_UPPER_NIBBLE + $90
.else
	cp SERIAL_UPPER_NIBBLE + $91
.endif
	jr nz,markFileAsBlank
	ld a,(w4PacketBuffer+29) ; wFileIsCompleted
	or a
	jr z,markFileAsBlank
	jp sendAckPacket


;;
; This is used when the game chooses to ignore a file, ie. because it's not completed or the GameID
; is wrong.
markFileAsBlank:
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
	jp sendAckPacket

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
	call setLinkTimerTo180

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
returnIfPacketNotComplete:
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
	jp z,sendRetryPacket

	pop af
	jp disableSerialPort


;;
compareFileHeader:
	ld de,w4RingFortuneStuff

;;
; @param	de	Pointer to first 7 bytes of some file data
;
; @param[out]	zflag	z if it matches the current file
compareFileIDsAndNames:
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


ackPacket:
	.db $03, SERIAL_UPPER_NIBBLE + $a0, SERIAL_UPPER_NIBBLE + $a3

retryPacket:
	.db $03, SERIAL_UPPER_NIBBLE + $a1, SERIAL_UPPER_NIBBLE + $a4


ringFortuneTable:
	dbrel @rings0
	dbrel @rings1
	dbrel @rings2

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
