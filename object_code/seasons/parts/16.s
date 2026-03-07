; ==================================================================================================
; PART_16
; ==================================================================================================
partCode16:
	jr z,@normalStatus
	ld h,d
	ld l,$c4
	ld (hl),$02
	ld l,$c6
	ld (hl),$14
	ld l,$e4
	ld (hl),$00
	call getThisRoomFlags
	and $c0
	cp $80
	jr nz,+
	ld a,(wScrollMode)
	and $01
	jr z,+
	ld a,(wLinkDeathTrigger)
	or a
	jp nz,@normalStatus
	call func_6515
	inc a
	ld (wDisableScreenTransitions),a
	ld ($cca4),a
	ld ($cbca),a
	inc a
	ld ($cfd0),a
	ld a,$08
	ld ($cfc0),a
+
	ld a,$01
	ld ($cc36),a
@normalStatus:
	ld hl,$cfd0
	ld a,(hl)
	inc a
	jp z,partDelete
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
@state1:
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,$00
	call preventObjectHFromPassingObjectD
	jp objectSetPriorityRelativeToLink_withTerrainEffects
@state2:
	call @state1
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	ret z
	ld e,$c5
	ld a,(de)
	or a
	jr nz,+
	call partCommon_decCounter1IfNonzero
	ret nz
	ld (hl),$b4
	inc l
	ld (hl),$08
	ld l,$f0
	ld (hl),$08
	ld l,e
	inc (hl)
	ret
+
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld a,($cd00)
	and $01
	jr z,+
	ld a,($cc34)
	or a
	jp nz,+
	call func_6515
	inc a
	ld (wDisableScreenTransitions),a
	ld ($cfd0),a
	ld (wDisabledObjects),a
	ld ($cbca),a
+
	ldi a,(hl)
	cp $5a
	jr nz,+
	ld e,$f0
	ld a,$04
	ld (de),a
+
	dec (hl)
	ret nz
	ld e,$f0
	ld a,(de)
	ld (hl),a
	ld l,$dc
	ld a,(hl)
	dec a
	xor $01
	inc a
	ld (hl),a
	ret

func_6515:
	ld a,(wLinkObjectIndex)
	ld b,a
	ld c,$2b
	ld a,$80
	ld (bc),a
	ld c,$2d
	xor a
	ld (bc),a
	ret
