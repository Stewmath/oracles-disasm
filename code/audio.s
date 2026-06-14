.include "include/constants.s"
.include "include/macros.s"
.include "include/rominfo.s"
.include "include/musicMacros.s"

.BANK $39 SLOT 1
.ORG 0

m_section_superfree AudioCode NAMESPACE audio

;;
b39_initSound:
	jp initSound

;;
b39_updateSound:
	jp updateSound

;;
; @param	a	Sound to play
b39_playSound:
	jp playSound

;;
b39_stopSound:
	jp stopSound

;;
; Unused? (The address it jumps too doesn't seem like it would do anything useful...)
func_39_400c:
	pop af
	jp $4d3e

;;
; @param	a	Volume (0-3)
b39_updateMusicVolume:
	jp updateMusicVolume


; This is pointless?
.dw musNone


;;
initSound:
	ldh (<hSoundDataBaseBank),a
	call stopSound
	ld a,$03
	ld (wMusicVolume),a
	ld a,$00
	ld (wSoundFadeDirection),a
	ld (wSoundFadeCounter),a
	ld (wSoundDisabled),a
	ld (wMusicMuted),a
	ld a,$8f
	ld ($ff00+R_NR52),a
	ld a,$77
	ld (wSoundVolume),a
	ld ($ff00+R_NR50),a
	ld a,$ff
	ld ($ff00+R_NR51),a
	ld c,@readFunctionEnd-@readFunction+2
	ld hl,@readFunction
	ld de,wMusicReadFunction
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec c
	jr nz,-
	ret

; This function is copied to wMusicReadFunction and executed there.
@readFunction:
	ldh (<hSoundDataBaseBank2),a
	ld ($2000),a
	ldi a,(hl)
	ld c,a
	ldh a,(<hSoundDataBaseBank)
	ldh (<hSoundDataBaseBank2),a
	ld ($2000),a
	ld a,c
	ret
	ret
	ret
@readFunctionEnd:


;;
; Updates wMusicVolume and wMusicMuted and silences channels 0 and 1
; @param	a	Volume (0-3)
updateMusicVolume:
	push bc
	push de
	push hl
	push af
	call silenceSquareMusicChannels

	pop af
	ld (wMusicVolume),a
	cp $00
	jr nz,+

	ld a,$01
	jr ++
+
	ld a,$00
++
	ld (wMusicMuted),a
	pop hl
	pop de
	pop bc
	ret

;;
; Silences channels 0 and 1 if enabled
silenceSquareMusicChannels:
	; Update square 1's volume
	ld a,$00
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	call silencePlayedSound
+
	; Update square 2's volume
	ld a,$01
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	call silencePlayedSound
+
	ret

;;
stopSound:
	ld a,$00
-
	ld (wSoundChannel),a
	call channelCmdff
	ld a,(wSoundChannel)
	inc a
	cp $08
	jr nz,-
	ret

;;
silenceAllChannels:
	ld a,$00
-
	ld (wSoundChannel),a
	call silencePlayedSound
	ld a,(wSoundChannel)
	inc a
	cp $08
	jr nz,-
	ret

;;
; Disable all sound effect channels
;
stopSfx:
	; Square 1
	ld a,$02
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	call channelCmdff
+
	; Square 2
	ld a,$03
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	call channelCmdff
+
	; Wave
	ld a,$05
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	call channelCmdff
+
	; Noise
	ld a,$07
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	call channelCmdff
+
	ret

;;
updateSound:
	push bc
	push de
	push hl
	ld a,(wSoundDisabled)
	cp $00
	jr z,+
	jp @ret
+
	ld a,(wSoundVolume)
	ld ($ff00+R_NR50),a
	ld a,(wSoundFadeDirection)
	cp $00
	jr z,@updateChannels

	ld a,(wSoundFadeSpeed)
	ld b,a
	ld a,(wSoundFadeCounter)
	inc a
	ld (wSoundFadeCounter),a
	and b
	cp b
	jr nz,@updateChannels

	ld a,(wSoundFadeDirection)
	cp $0a
	jr z,@incVolume

@decVolume:
	ld a,(wSoundVolume)
	cp $00
	jr z,@stopSound

	sub $11
	ld (wSoundVolume),a
	jp @updateChannels

@incVolume:
	ld a,(wSoundVolume)
	cp $77
	jr z,@clearFadeVariables

	add $11
	ld (wSoundVolume),a
	jp @updateChannels

@stopSound:
	call stopSound

@clearFadeVariables:
	ld a,$00
	ld (wSoundFadeCounter),a
	ld (wSoundFadeDirection),a

@updateChannels:
	ld a,$00
@channelLoop:
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,@nextChannel

	ld hl,wChannelWaitCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr nz,@continueSound

	call doNextChannelCommand
	jr @nextChannel

@continueSound:
	call continuePlayingSound
@nextChannel:
	ld a,(wSoundChannel)
	inc a
	cp $08
	jr nz,@channelLoop

	ld a,(wMusicMuted)
	cp $01
	jr nz,@ret

	ld a,$02
	ld (wMusicMuted),a

@ret:
	pop hl
	pop de
	pop bc
	ret

;;
; Keep playing the current sound
continuePlayingSound:
	; Decrement wait counter
	ld hl,wChannelWaitCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	dec a
	ld (hl),a
	; Return if noise channel
	ld a,(wSoundChannel)
	cp $06
	jr nc,@ret

	; Return if channel uses length timer
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	and $40
	jr nz,@ret

	ld a,(wSoundChannel)
	cp $05
	jr nc,+
	call handleEnvelopes
+
	call updateSoundFrequencyAndPlay
@ret:
	ret

;;
; Copies the channel's frequency value from hSoundData3 to wSoundFrequencyL,H after applying sweep and vibrato
updateSoundFrequencyAndPlay:
	; Handle sweep
	ld hl,wChannelSweep
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ld c,a
	and $7f
	jr z,@handleVibrato

	ld a,c
	and $80
	jr nz,+

	ld d,$00
	jr ++
+
	ld d,$ff
++
	; Unnecessary, could just do ld a,c like a few lines above
	push de
	ld hl,wChannelSweep
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	pop de
	ld e,a
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,b
	add <hSoundData3
	ld c,a
	ld a,($ff00+c)
	inc c
	ld l,a
	ld a,($ff00+c)
	inc c
	ld h,a
	add hl,de
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,l
	ld c,<hSoundData3
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c
@handleVibrato:
	ld hl,wChannelVibratoActive
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	and $10
	jr nz,@useVibrato

	; Check vibrato wait counter
	ld hl,wChannelVibratoCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,@endVibratoWait

	; Still waiting, no vibrato applied yet
	dec a
	ld hl,wChannelVibratoCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld hl,$0000
	jp @updateSoundFrequencyWithOffset

@endVibratoWait:
	ld a,$10
	ld hl,wChannelVibratoActive
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	; Unnecessary, this value is already known to be 0
	ld a,$00
	ld hl,wChannelVibratoCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
@useVibrato:
	ld hl,wChannelVibratoCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $08
	jr nz,@determineFrequencyOffset

	; Went past the end of vibratoOffsetTable, start over
	ld a,$00
	ld hl,wChannelVibratoCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld a,$00
@determineFrequencyOffset:
	; Get next raw offset (-2, -1, 0, 1 or 2)
	ld hl,vibratoOffsetTable
	call readWordFromTable
	push hl
	; Increment index
	ld hl,wChannelVibratoCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	inc a
	ld (hl),a
	; Get vibrato intensity (0 if disabled for the channel)
	ld hl,wChannelVibratos
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	and $0f
	pop hl
	; Get final offset by multiplying raw offset with intensity
	call multiplyHlByA
@updateSoundFrequencyWithOffset:
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,b
	add <hSoundData3
	ld c,a
	ld a,($ff00+c)
	inc c
	ld e,a
	ld a,($ff00+c)
	inc c
	ld d,a
	add hl,de
	ld a,l
	ld (wSoundFrequencyL),a
	ld a,h
	ld (wSoundFrequencyH),a

;;
; When used for wave channel, hl is expected to contain wSoundFrequencyL,H and is written to NR33 and NR34
updatePlayedFrequency:
	ld a,(wSoundChannel)
	scf
	ccf
	cp $04
	jr nc,@wave

	cp $02
	jr nc,@square

	; For music, check if channel is free
	inc a
	inc a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,@square
	ret

@square:
	ld a,(wSoundChannel)
	and $01
	ld b,a
	sla a
	sla a
	add b
	ld b,a
	push bc
	ld a,(wSoundFrequencyL)
	ld c,R_NR13
	call writeIndexedHighRamAndIncrement
	ld a,(wSoundCmdEnvelope)
	ld e,a
	ld a,(wSoundFrequencyH)
	or e
	ld ($ff00+c),a
	inc c
	pop bc
	push bc
	ld hl,wChannelDutyCycles
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	pop bc
	ld c,R_NR11
	call writeIndexedHighRamAndIncrement
	ret

@wave:
	call isWaveChannelUnavailable
	cp $00
	jr nz,@ret
	ld a,l
	ld ($ff00+R_NR33),a
	ld a,h
	ld ($ff00+R_NR34),a
	ld a,$00
	ld ($ff00+R_NR31),a
@ret:
	ret

;;
; Sounds can always play, music can only play if wave channel is free and music has not been muted since previous updateSound call
; @param[out]	a	Whether wave channel registers may be written to (0 or 1)
isWaveChannelUnavailable:
	ld a,(wSoundChannel)
	cp $05
	jr z,@available

	ld a,(wChannelsEnabled+5)
	cp $00
	jr nz,@unavailable

	ld a,(wMusicMuted)
	cp $02
	jr z,@unavailable
@available:
	ld a,$00
	ret
@unavailable:
	ld a,$01
	ret

;;
getNextChannelByte:
	push bc
	push de
	push hl
	ld a,(wSoundChannel)
	sla a
	add <hSoundChannelAddresses
	ld c,a
	ld a,($ff00+c)
	inc c
	ld l,a
	ld a,($ff00+c)
	ld h,a
	ld a,(wSoundChannel)
	add <hSoundChannelBanks
	ld c,a
	ld a,($ff00+c)
	inc c
	call wMusicReadFunction
	push af
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,l
	ld c,<hSoundChannelAddresses
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c
	pop af
	pop hl
	pop de
	pop bc
	ret

;;
doNextChannelCommand:
	call getNextChannelByte
	scf
	ccf
	cp $f0
	jr nc,@cmdf0Toff

	scf
	ccf
	cp $e0
	jr c,+
	jp cmde0Toef
+
	scf
	ccf
	cp $d0
	jr c,+
	jp cmdVolume
+
	ld (wSoundCmd),a
	jp standardSoundCmd

@cmdf0Toff:
	ld e,a
	ld a,$ff
	sub e
	ld hl,@table
	call readWordFromTable
	jp hl

@table:
	.dw channelCmdff
	.dw channelCmdfe
	.dw channelCmdfd
	.dw channelCmdff
	.dw channelCmdff
	.dw channelCmdff
	.dw channelCmdf9
	.dw channelCmdf8
	.dw channelCmdff
	.dw channelCmdf6
	.dw channelCmdff
	.dw channelCmdff
	.dw channelCmdf3
	.dw channelCmdf2
	.dw channelCmdf1
	.dw channelCmdf0

;;
channelCmdf1:
	jp doNextChannelCommand
;;
channelCmdf2:
	jp doNextChannelCommand
;;
channelCmdf3:
	jp doNextChannelCommand

;;
; Vibrato
; Sets vibrato to the argument value, does nothing for noise channels
channelCmdf9:
	ld a,(wSoundChannel)
	scf
	ccf
	cp $06
	jr nc,++

	call getNextChannelByte
	ld hl,wChannelVibratos
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

;;
; Sets sweep to the argument value, does nothing for noise channels
channelCmdf8:
	ld a,(wSoundChannel)
	scf
	ccf
	cp $06
	jr nc,++

	call getNextChannelByte
	ld hl,wChannelSweep
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

;;
; Sets pitch shift to the argument value, does nothing for noise channels
channelCmdfd:
	ld a,(wSoundChannel)
	scf
	ccf
	cp $06
	jr nc,++

	call getNextChannelByte
	ld hl,wChannelPitchShift
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand
++
	call getNextChannelByte
	jp doNextChannelCommand

;;
; Sets the channel envelopes to the lower 3 bits of the command value (note start) and the argument value (note end)
; Should not be used with wave or noise channels or else wChannelEnvelopes2 and wChannelsEnabled get messed up for square channels
cmde0Toef:
	and $07
	ld hl,wChannelEnvelopes
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call getNextChannelByte
	and $07
	ld hl,wChannelEnvelopes2
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

;;
; Command $f0 takes the next byte as argument and can do various things depending on the channel:
; Channels 0-5: Enables a mode where standard commands are changed, and the note and beat macros stop working for the channel.
; Commands for playing a sound or rest must instead be of the form ".db $06 $0b $02" where, from left to right, the bytes
; correspond to the high byte of the frequency value, the low byte, and the sound length. There is no command for
; disabling this mode. The argument is written straight to wChannelDutyCycles.
; Channels 0-3: Additionally, if bits 0-5 of the argument are not all cleared, the length timer gets enabled for the channel,
; and those 6 bits determine the initial value for each played sound. Otherwise, the length timer gets disabled.
; Sweep and vibrato are ignored with length timer. Envelopes with increasing volume should not be used with length timer
; as sounds would keep increasing to volume $f if played long enough.
; Channel 7: Sets volume and envelope (argument gets written straight to NR42).
; Should not be used with channel 6 or else wChannelSweep and wChannelEnvelopeStates get messed up for channel 0
channelCmdf0:
	ld a,(wSoundChannel)
	cp $07
	jr z,@channel7

	call getNextChannelByte
	push af
	; Initial length timer value of 0 is treated as wanting to disable the length timer
	; Command $fd can be used afterwards to set the initial length timer value to 0 without disabling it
	and $3f
	jr z,@disableLengthTimer

	pop af
	ld hl,wChannelDutyCycles
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	; Enable both arbitrary frequency mode and length timer
	ld a,$41
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

@disableLengthTimer:
	pop af
	; Unnecessary, this will not change a
	and $c0
	ld hl,wChannelDutyCycles
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	; Enable arbitrary frequency mode and disable length timer
	ld a,$01
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

@channel7:
	call getNextChannelByte
	ld ($ff00+R_NR42),a
	ld a,$00
	ld ($ff00+R_NR41),a
	ld a,$80
	ld (wChannel7TriggerOnNextSound),a
	jp doNextChannelCommand

; Command $d0 to $df
; Sets volume to the lower 3 bits of the command value, does nothing for channel 4 (and is also useless for channel 5)
cmdVolume:
	push af
	ld a,(wSoundChannel)
	cp $04
	jr z,@next

	pop af
	and $0f
	ld hl,wChannelVolumes
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

@next:
	pop af
	jp doNextChannelCommand

;;
; For square channels, sets wChannelDutyCycles to the argument value shifted 6 bits to the left
; For wave channels, sets wChannelDutyCycles to the argument value and updates the waveform based on that index
; Should not be used with noise channels or else wChannelEnvelopeStates gets messed up for channel 0 or 1
channelCmdf6:
	ld a,(wSoundChannel)
	cp $04
	jr z,@wave

	cp $05
	jr z,@wave

	call getNextChannelByte
	and $03
	swap a
	sla a
	sla a
	ld hl,wChannelDutyCycles
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp doNextChannelCommand

@wave:
	call getNextChannelByte
	ld hl,wChannelDutyCycles
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld (wWaveformIndex),a
	call setWaveform
	jp doNextChannelCommand

;;
standardSoundCmd:
	ld a,(wSoundChannel)
	ld hl,@table
	call readWordFromTable
	jp hl

@table:
	.dw @channel0To3
	.dw @channel0To3
	.dw @channel0To3
	.dw @channel0To3
	.dw standardCmdChannels4To5
	.dw standardCmdChannels4To5
	.dw standardCmdChannel6
	.dw standardCmdChannel7

@channel0To3:
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+

	call getNextChannelByte
	ld l,a
	ld a,(wSoundCmd)
	ld h,a
	jp @arbitraryFrequency
+
	ld a,(wSoundCmd)
	cp $60
	jr z,@cmd60

	cp $61
	jr z,@cmd61

	jp @cmdFrequency

@cmd60:
	; If notes are set to end with an envelope, do nothing even if the last note is still audible
	ld hl,wChannelEnvelopes2
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr nz,@cmd61

	; Apply envelope to make the volume quickly decrease to 0
	ld a,$02
	ld hl,wChannelEnvelopeStates
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call getChannelVolume
	sla a
	sla a
	sla a
	sla a
	ld c,$01
	or c
	ld (wSoundCmdEnvelope),a
	call updateSquareChannelVolume
	call updateSoundFrequencyAndPlay
@cmd61:
	jp setChannelWaitCounter

@cmdFrequency:
	ld a,(wSoundCmd)
	sub $0c
	ld hl,soundFrequencyTable
	call readWordFromTable
@arbitraryFrequency:
	call setSoundFrequency
	ld a,$00
	ld hl,wChannelEnvelopeStates
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call handleEnvelopes
	ld a,$00
	ld hl,wChannelVibratoActive
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld a,$00
	ld hl,wChannelVibratos
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	and $f0
	srl a
	srl a
	srl a
	ld hl,wChannelVibratoCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call updatePlayedFrequency
;;
; Read a byte, set the channel wait counter to the value
setChannelWaitCounter:
	call getNextChannelByte
	dec a
	ld hl,wChannelWaitCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ret

;;
; Determines the time to wait until the envelope with sweep pace c is expected to have reached the volume level in b
; @param[out]	a	Number of ticks to wait for the envelope
getWaitTimeForEnvelope:
	ld hl,envelopeWaitTable
	ld a,b
	sla a
	sla a
	sla a
	add c
	ld d,$00
	ld e,a
	add hl,de
	ld a,(hl)
	ret

;;
; Sends wSoundFrequency to given value plus value in table at wChannelPitchShift.
setSoundFrequency:
	push hl
	ld hl,wChannelPitchShift
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ld d,a
	sla d
	jr c,+

	ld d,$00
	jr ++
+
	ld d,$ff
++
	ld e,a
	pop hl
	add hl,de
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,l
	ld c,<hSoundData3
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c
	ld a,l
	ld (wSoundFrequencyL),a
	ld a,h
	ld (wSoundFrequencyH),a
	ret

;;
; Handles envelopes for square channels, and redirects channel 4 to updateChannel4Volume
handleEnvelopes:
	ld a,(wSoundChannel)
	cp $04
	jr nz,+
	jp updateChannel4Volume
+
	ld hl,wChannelEnvelopeStates
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,@checkEnvelopeRequested

	cp $01
	jr z,@waitForNoteStartEnvelope

	ld a,$00
	ld (wSoundCmdEnvelope),a
	ret

@checkEnvelopeRequested:
	ld hl,wChannelEnvelopes
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,@checkAndStartNoteEndEnvelope

	; Start envelope for starting the note
	ld c,a
	; Initial volume 1 and increase over time
	or $18
	ld (wSoundCmdEnvelope),a
	push bc
	call getChannelVolume
	pop bc
	ld b,a
	call getWaitTimeForEnvelope
	ld hl,wChannelEnvelopeWaitCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld a,$01
	ld hl,wChannelEnvelopeStates
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	jp updateSquareChannelVolume

@waitForNoteStartEnvelope:
	ld hl,wChannelEnvelopeWaitCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,@checkAndStartNoteEndEnvelope

	; Unnecessary, a and hl still contain the desired values
	ld hl,wChannelEnvelopeWaitCounters
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	dec a
	ld (hl),a
	ld a,$00
	ld (wSoundCmdEnvelope),a
	ret

@checkAndStartNoteEndEnvelope:
	ld hl,wChannelEnvelopes2
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr nz,+

	ld a,$02
	jr ++
+
	ld a,$03
++
	ld hl,wChannelEnvelopeStates
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call getChannelVolume
	sla a
	sla a
	sla a
	sla a
	ld (wSoundCmdEnvelope),a
	ld hl,wChannelEnvelopes2
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ld c,a
	ld a,(wSoundCmdEnvelope)
	or c
	ld (wSoundCmdEnvelope),a
	jp updateSquareChannelVolume

;;
updateSquareChannelVolume:
	ld a,(wSoundChannel)
	cp $02
	jr nc,++

	ld a,(wMusicVolume)
	cp $00
	jr z,@ret

	ld a,(wSoundChannel)
	inc a
	inc a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,++
@ret:
	ret
++
	ld a,(wSoundChannel)
	and $01
	jr nz,+

	; Channel 1 only: sweep off
	ld a,$08
	ld ($ff00+R_NR10),a
+
	; Set channel volume
	ld a,(wSoundChannel)
	and $01
	ld b,a
	sla a
	sla a
	add b
	ld b,a
	ld a,(wSoundCmdEnvelope)
	ld c,R_NR12
	call writeIndexedHighRamAndIncrement
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	; Length enable
	and $40
	; Trigger
	or $80
	ld (wSoundCmdEnvelope),a
	ret

;;
; Updates wWaveChannelVolume+4 and, if changed, writes to R_NR32 if possible
updateChannel4Volume:
	call getWaveChannelVolume
	ld b,a
	ld a,(wWaveChannelVolume+4)
	cp b
	jr z,@ret

	; Unnecessary repeated function call, why not just ld a,b?
	call getWaveChannelVolume
	ld (wWaveChannelVolume+4),a
	call isWaveChannelUnavailable
	cp $00
	jr nz,@ret

	ld a,(wWaveChannelVolume+4)
	ld ($ff00+R_NR32),a
@ret:
	ret

;;
; Intended for use with square and noise channels, but not used by channel 7
; Channel 6 uses @affectedByMusicVolume as entry point
; @param[out]	a	Final volume of channel wSoundChannel after possible modification with wMusicVolume ($0-$f)
getChannelVolume:
	ld a,(wSoundChannel)
	scf
	ccf
	cp $02
	jr nc,@fullVolume
@affectedByMusicVolume:
	ld a,(wMusicVolume)
	cp $00
	jr z,@muted
	cp $01
	jr z,@quarterVolume
	cp $02
	jr z,@halfVolume
@fullVolume:
	ld hl,wChannelVolumes
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ret

@halfVolume:
	ld hl,wChannelVolumes
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	srl a
	ret

@quarterVolume:
	ld hl,wChannelVolumes
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	srl a
	srl a
	ret

@muted:
	ld a,$00
	ret

standardCmdChannels4To5:
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+

	call getNextChannelByte
	ld l,a
	ld a,(wSoundCmd)
	ld h,a
	jp @arbitraryFrequency
+
	ld a,(wSoundCmd)
	scf
	ccf
	cp $60
	jr nz,@freqCommand
@cmd60:
	ld a,$01
	ld hl,wChannelIsPlayingRest
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	; Unnecessary function call, this will always return 0
	call getWaveChannelVolume
	ld hl,wWaveChannelVolume
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call isWaveChannelUnavailable
	cp $00
	jr nz,+

	; Unnecessary, the volume is known to be 0 (and so is a)
	ld hl,wWaveChannelVolume
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ld ($ff00+R_NR32),a
+
	jp setChannelWaitCounter
@freqCommand:
	ld a,$00
	ld hl,wChannelIsPlayingRest
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld a,(wSoundCmd)
	ld hl,soundFrequencyTable
	call readWordFromTable
@arbitraryFrequency:
	call setSoundFrequency
	ld a,$00
	ld hl,wChannelVibratoActive
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ld a,$00
	ld hl,wChannelVibratos
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	and $f0
	srl a
	srl a
	srl a
	ld hl,wChannelVibratoCounters
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call getWaveChannelVolume
	ld hl,wWaveChannelVolume
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	call isWaveChannelUnavailable
	cp $00
	jr nz,+

	ld hl,wWaveChannelVolume
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ld ($ff00+R_NR32),a
	ld a,(wSoundFrequencyL)
	ld ($ff00+R_NR33),a
	ld a,(wSoundFrequencyH)
	ld ($ff00+R_NR34),a
+
	jp setChannelWaitCounter

;;
; @param[out]	a	Volume of channel wSoundChannel dependent of wMusicVolume, in a form that can be written to NR32
getWaveChannelVolume:
	ld hl,wChannelIsPlayingRest
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr nz,@mute
	ld a,(wSoundChannel)
	cp $05
	jr nc,@fullVolume
	ld a,(wMusicVolume)
	cp $00
	jr z,@mute
	cp $01
	jr z,@quarterVolume
	cp $02
	jr z,@halfVolume
@fullVolume:
	ld a,$20
	ret
@halfVolume:
	ld a,$40
	ret
@quarterVolume:
	ld a,$60
	ret
@mute:
	ld a,$00
	ret

;;
standardCmdChannel6:
	ld a,(wSoundCmd)
	ld c,a
	ld de,noiseFrequencyTable
-
	ld a,(de)
	inc de
	cp $ff
	jr z,@wait

	cp c
	jr z,+

	inc de
	inc de
	jr -
+
	ld a,(de)
	ld l,a
	inc de
	ld a,(de)
	ld h,a
	ld a,(wChannelsEnabled+7)
	cp $00
	jr nz,@wait

	push hl
	call getChannelVolume@affectedByMusicVolume
	pop hl
	sla a
	sla a
	sla a
	sla a
	or l
	ld ($ff00+R_NR42),a
	ld a,h
	ld ($ff00+R_NR43),a
	ld a,$80
	ld ($ff00+R_NR44),a
@wait:
	jp setChannelWaitCounter

;;
standardCmdChannel7:
	ld a,(wSoundCmd)
	ld ($ff00+R_NR43),a
	ld a,$00
	ld ($ff00+R_NR41),a
	ld a,(wChannel7TriggerOnNextSound)
	cp $00
	jr z,+
	ld ($ff00+R_NR44),a
+
	ld a,$00
	ld (wChannel7TriggerOnNextSound),a
	jp setChannelWaitCounter

;;
; Disables and silences the current channel
channelCmdff:
	ld a,$00
	ld hl,wChannelsEnabled
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
;;
; Ensures no sound is audible on the current channel by setting the volume to $0 or turning off the wave channel DAC
silencePlayedSound:
	ld a,(wSoundChannel)
	ld hl,@table
	call readWordFromTable
	jp hl

@table:
	.dw @musicSquareChannel
	.dw @musicSquareChannel
	.dw @sfxSquareChannel
	.dw @sfxSquareChannel
	.dw @musicWaveChannel
	.dw @sfxWaveChannel
	.dw @noiseChannel
	.dw @noiseChannel

@musicSquareChannel:
	; Only update if the corresponding sfx channel is not enabled
	ld a,(wSoundChannel)
	inc a
	inc a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
	ret

@sfxSquareChannel:
	; Sfx always updates (but it still does this pointless check of the corresponding
	; music channel)
	ld a,(wSoundChannel)
	dec a
	dec a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $00
	jr z,+
+
	; If an envelope is active that decreases volume over time, allow the sound to keep playing
	ld hl,wChannelEnvelopeStates
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	cp $03
	jr nz,+
	ret

+
	; Set volume to $0 and trigger channel
	ld a,$08
	ld (wSoundCmdEnvelope),a
	call updateSquareChannelVolume
	jp updatePlayedFrequency

@musicWaveChannel:
	call isWaveChannelUnavailable
	cp $00
	jr nz,+

	; Disable DAC
	ld a,$00
	ld ($ff00+R_NR30),a
+
	ret

@sfxWaveChannel:
	ld a,(wChannelsEnabled+4)
	cp $00
	jr z,++

	; Music channel is enabled
	ld a,$04
	ld e,a
	ld hl,wChannelDutyCycles
	ld d,$00
	add hl,de
	ld a,(hl)
	ld (wWaveformIndex),a
	call setWaveform
	ld a,(wWaveChannelVolume+4)
	ld ($ff00+R_NR32),a
	ret
++
	; Disable DAC
	ld a,$00
	ld ($ff00+R_NR30),a
	ret

@noiseChannel:
	; Set volume to $0 and trigger channel
	ld a,$08
	ld ($ff00+R_NR42),a
	ld a,$80
	ld ($ff00+R_NR44),a
	ret

;;
setWaveform:
	call isWaveChannelUnavailable
	cp $00
	jr z,@waitLoop
	ret

@waitLoop:
	; Wait for channel 3 to be on
	ld a,$00
	ld ($ff00+R_NR30),a
	ld a,($ff00+R_NR52)
	and $04
	jr nz,@waitLoop

	; Copy waveform to $ff30
	ld a,(wWaveformIndex)
	ld hl,waveformTable
	call readWordFromTable
	ld c,$10
	ld de,$ff30
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec c
	jr nz,-

-	; Enable channel 3
	ld a,$80
	ld ($ff00+R_NR30),a
	ld a,($ff00+R_NR30)
	and $80
	jr z,-

	; Restart channel 3 (but trashes lower frequency bits?)
	ld a,$80
	ld ($ff00+R_NR34),a
	ret

;;
; Jump to word from argument
channelCmdfe:
	call getNextChannelByte
	ld l,a
	call getNextChannelByte
	ld h,a
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,l
	ld c,<hSoundChannelAddresses
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c
	jp doNextChannelCommand

;;
multiplyHlByA:
	cp $00
	jr nz,+
	ld hl,$0000
	ret
+
	ld e,l
	ld d,h
--
	dec a
	jr z,+

	add hl,de
	jp --
+
	ret

soundFrequencyTable:
	.dw $002d
	.dw $009d
	.dw $0108
	.dw $016c
	.dw $01cb
	.dw $0224
	.dw $0279
	.dw $02c8
	.dw $0313
	.dw $0358
	.dw $039b
	.dw $03db
	.dw $0416
	.dw $044f
	.dw $0484
	.dw $04b6
	.dw $04e5
	.dw $0512
	.dw $053c
	.dw $0564
	.dw $058a
	.dw $05ac
	.dw $05ce
	.dw $05ed
	.dw $060b
	.dw $0627
	.dw $0642
	.dw $065b
	.dw $0673
	.dw $0689
	.dw $069e
	.dw $06b2
	.dw $06c5
	.dw $06d6
	.dw $06e7
	.dw $06f7
	.dw $0706
	.dw $0714
	.dw $0721
	.dw $072e
	.dw $0739
	.dw $0745
	.dw $074f
	.dw $0759
	.dw $0762
	.dw $076b
	.dw $0773
	.dw $077b
	.dw $0783
	.dw $078a
	.dw $0790
	.dw $0797
	.dw $079d
	.dw $07a2
	.dw $07a8
	.dw $07ad
	.dw $07b1
	.dw $07b6
	.dw $07ba
	.dw $07be
	.dw $07c1
	.dw $07c5
	.dw $07c8
	.dw $07cb
	.dw $07ce
	.dw $07d1
	.dw $07d4
	.dw $07d6
	.dw $07d9
	.dw $07db
	.dw $07dd
	.dw $07df
	.dw $07e1
	.dw $07e2
	.dw $07e4
	.dw $07e6
	.dw $07e7
	.dw $07e9
	.dw $07ea
	.dw $07eb
	.dw $07ec
	.dw $07ed
	.dw $07ee
	.dw $07ef
	.dw $07f0
	.dw $07f1
	.dw $07f2

; The number of audio ticks (close to the number of frames) until the envelope reaches volume V when it
; starts from 1 and has sweep pace S can be approximated with the formula (V-1)*S*8192/(137+1/7)/64
; (8192 is the timer frequency, 137 the number of timer ticks between timer interrupts, the timer is
; decremented once every 7th timer interrupt, and 64 is the envelope tick frequency). The table does fit
; this formula with V as the row index and S as the column index (with rounding to the nearest integer),
; but strangely, in the way it is indexed, it is offset by two rows. For example, the second row is indexed by
; a target volume of 1 (the same as the starting volume), so you would expect no wait, but the game using the
; second row of the table causes it to wait until the volume reaches level 3 and then jump back to volume 1.
; Should not be used with volume $e or $f or the table is indexed out of bounds
envelopeWaitTable:
	.db $00 $01 $02 $03 $04 $05 $06 $07
	.db $00 $02 $04 $06 $07 $09 $0b $0d
	.db $00 $03 $06 $08 $0b $0e $11 $14
	.db $00 $04 $07 $0b $0f $13 $16 $1a
	.db $00 $05 $09 $0e $13 $17 $1c $21
	.db $00 $06 $0b $11 $16 $1c $22 $27
	.db $00 $07 $0d $14 $1a $21 $27 $2e
	.db $00 $07 $0f $16 $1e $25 $2d $34
	.db $00 $08 $11 $19 $22 $2a $32 $3b
	.db $00 $09 $13 $1c $25 $2f $38 $41
	.db $00 $0a $15 $1f $29 $33 $3e $48
	.db $00 $0b $16 $22 $2d $38 $43 $4e
	.db $00 $0c $18 $24 $31 $3d $49 $55
	.db $00 $0d $1a $27 $34 $41 $4e $5b

; Frequency offsets that get added to the current played sound when vibrato is active
vibratoOffsetTable:
	.dw 0,1,2,1,0,-1,-2,-1

;;
; @param a The sound to play.
playSound:
	push bc
	push de
	push hl
	ld (wSoundTmp),a
	cp $00
	jr nz,+
	jp @playSoundEnd
+
	cp $f0
	jr z,@sndf0
	cp $f1
	jr z,@sndf1
	cp $f5
	jr z,@sndf5
	cp $f6
	jr z,@sndf6
	cp $f7
	jr z,@sndf7
	cp $f8
	jr z,@sndf8
	cp $f9
	jr z,@sndf9
	cp $fa
	jr z,@sndfa
	cp $fb
	jr z,@sndfb
	cp $fc
	jr z,@sndfc
	jr @normalSound

; Stop music
@sndf0:
	ld a,SNDCTRL_DE
	ld (wSoundTmp),a
	jr @normalSound

; Stop sound effects
@sndf1:
	call stopSfx
	jp @playSoundEnd

; Disable sound
@sndf5:
	call silenceAllChannels
	ld a,$01
	ld (wSoundDisabled),a
	jp @setVolumeAndEnd

; Enable sound
@sndf6:
	ld a,$00
	ld (wSoundDisabled),a
	jp @setVolumeAndEnd

; Fast fadeout
@sndfa:
	ld a,$07
	jr +

; Medium fadeout
@sndfb:
	ld a,$0f
	jr +

; Slow fadeout
@sndfc:
	ld a,$1f
+
	ld (wSoundFadeSpeed),a
	ld a,$00
	ld (wSoundFadeCounter),a
	ld a,$01
	ld (wSoundFadeDirection),a
	ld a,$77
	ld (wSoundVolume),a
	jp @playSoundEnd

; Fast fadein
@sndf7:
	ld a,$03
	jr +

; Medium fadein
@sndf8:
	ld a,$07
	jr +

; Slow fadein
@sndf9:
	ld a,$0f
+
	ld (wSoundFadeSpeed),a
	ld a,$00
	ld (wSoundFadeCounter),a
	ld a,$0a
	ld (wSoundFadeDirection),a
	ld a,$00
	ld (wSoundVolume),a
	jp @playSoundEnd

@normalSound:
	ld a,$00
	ld (wSoundFadeDirection),a
	ld a,(wSoundTmp)

	; Get a*3 in de
	ld d,$00
	ld e,a
	ld h,$00
	ld l,a
	sla l
	rl h
	add hl,de
	ld d,h
	ld e,l

	ld hl,soundPointers
	add hl,de

	; Wrapping this in a BUILD_VANILLA check because: A) it's unused, B) it can cause problems
	; if audio data gets placed into an unexpected bank (which WLA could decide to do).
.ifdef BUILD_VANILLA
	ld a,(hl)
	and $80
	jr z,@skipWeirdCall

	; This function doesn't exist, so clearly this section of code should never be executed
	call nonExistentFunction

	jp @setVolumeAndEnd

@skipWeirdCall:

.endif

	ldi a,(hl)
	ld c,a
	ldh a,(<hSoundDataBaseBank)
	add c
	ld (wLoadingSoundBank),a
	ldi a,(hl)
	ld c,a
	ld a,(hl)
	ld b,a
	ld l,c
	ld h,b

@nextSoundChannel:
	ldh a,(<hSoundDataBaseBank)
	call wMusicReadFunction
	cp $ff
	jr nz,+
	jp @setVolumeAndEnd
+
	ld (wSoundTmp),a
	and $f0
	swap a
	inc a
	ld (wSoundChannelValue),a
	ld a,(wSoundTmp)
	and $0f
	ld (wSoundTmp),a
	ld e,a
	push hl
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	pop hl
	ld c,a
	ld a,(wSoundChannelValue)
	cp c
	jr nc,+

	inc hl
	inc hl
	jp @nextSoundChannel
+
	push hl
	ld a,(wSoundTmp)
	ld e,a
	ld a,(wSoundChannelValue)
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld (hl),a
	ld a,$08
	ld hl,wChannelVolumes
	ld d,$00
	add hl,de
	ld (hl),a
	ld a,$00
	ld hl,wChannelWaitCounters
	ld d,$00
	add hl,de
	ld (hl),a
	ld a,(wSoundTmp)
	cp $00
	jr z,@squareChannel
	cp $01
	jr z,@squareChannel
	cp $02
	jr z,@squareChannel
	cp $03
	jr z,@squareChannel
	cp $04
	jr z,@waveChannel
	cp $05
	jr z,@waveChannel

	; Noise channels
	jr ++

@waveChannel:
	ld a,(wSoundTmp)
	ld e,a
	ld a,$00
	ld hl,wChannelVibratos
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelSweep
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelPitchShift
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	ld d,$00
	add hl,de
	ld (hl),a
	jr ++

@squareChannel:
	ld a,(wSoundTmp)
	ld e,a

	; Clear a bunch of variables
	ld a,$00
	ld hl,wChannelEnvelopes
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelEnvelopes2
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelDutyCycles
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelVibratos
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelSweep
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelPitchShift
	ld d,$00
	add hl,de
	ld (hl),a
	ld hl,wChannelFrequencyModeAndLengthTimerEnabled
	ld d,$00
	add hl,de
	ld (hl),a
++
	; Write the bank for this sound channel into hSoundChannelBanks
	pop hl
	ld a,(wSoundTmp)
	ld b,a
	ld a,(wLoadingSoundBank)
	ld c,<hSoundChannelBanks
	call writeIndexedHighRamAndIncrement

	; Write the address for this sound channel into hSoundChannelAddresses
	ld a,(wSoundTmp)
	sla a
	ld b,a
	push bc
	ldh a,(<hSoundDataBaseBank)
	call wMusicReadFunction
	pop bc
	ld c,<hSoundChannelAddresses
	call writeIndexedHighRamAndIncrement
	push bc
	ldh a,(<hSoundDataBaseBank)
	call wMusicReadFunction
	pop bc
	ld ($ff00+c),a
	inc c
	jp @nextSoundChannel

@setVolumeAndEnd:
	ld a,$77
	ld (wSoundVolume),a
@playSoundEnd:
	pop hl
	pop de
	pop bc
	ret

;;
; Reads a word at hl+a*2 into de and hl. Index can't be higher than $7f.
readWordFromTable:
	sla a
	ld d,$00
	ld e,a
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld h,d
	ld l,e
	ret

;;
; Adds b to c, writes a to ($ff00+c), increments c.
writeIndexedHighRamAndIncrement:
	push af
	ld a,b
	add c
	ld c,a
	pop af
	ld ($ff00+c),a
	inc c
	ret

	push af
	ld a,(wSoundChannel)
	ld b,a
	ld a,b
	add c
	ld c,a
	pop af
	ld ($ff00+c),a
	ret


; A function which doesn't exist. Call this if you want your game to crash.
nonExistentFunction:


.include "audio/common/noise.s"
.include "audio/common/waveforms.s"
.include {"audio/{GAME}/soundChannelPointers.s"}
.include {"audio/{GAME}/soundPointers.s"}

.ends ; End of section AudioCode


.include {"audio/{GAME}/soundChannelData.s"}
