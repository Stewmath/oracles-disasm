; ==================================================================================================
; PART_BALL
; Ball for the shooting gallery
; ==================================================================================================
partCode38:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp z,partDelete
	ld h,d
	ld l,$c4
	ld a,(hl)
	cp $02
	jr nc,@normalStatus
	ld (hl),$02
@normalStatus:
	ld h,d
	ld l,$c6
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	ret
+
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	
@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c9
	ld (hl),$10
	call objectSetVisible81
	call getRandomNumber
	and $0f
	ld hl,@table_6ad7
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,$d0
	or a
	jr nz,@func_6ad0
	ld (hl),$64
	ld a,SND_THROW
	jp playSound
; 1/4 chance of being a slow ball
@func_6ad0:
	ld (hl),$3c
	ld a,SND_FALLINHOLE
	jp playSound
@table_6ad7:
	.db $01 $01 $01 $01
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	.db $00 $00 $00 $00
	
@state1:
	call objectCheckWithinScreenBoundary
	jp nc,func_6c17
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,@objectApplySpeed
	call @func_6b00
	jr nc,@objectApplySpeed
	jp z,func_6c17
	jp func_6bf6
	
@objectApplySpeed:
	jp objectApplySpeed
	
@func_6b00:
	scf
	push af
	ld a,(hl)
	cp $0f
	jr z,+
	pop af
	ccf
	ret
+
	pop af
	ret
	
@state2:
	ld a,$03
	ld (de),a
	ld a,SND_CLINK
	call playSound
	ld h,d
	ld l,$c6
	ld (hl),$00
	ld l,$d0
	ld (hl),$78
	ld l,$ec
	ld a,(hl)
	ld l,$c9
	ld (hl),a
	ret
	
@state3:
	call objectCheckWithinScreenBoundary
	jp nc,func_6c17
	ld b,$ff
	call func_6b5f
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	call @func_6b00
	jr nc,+
	jp z,func_6c17
	call func_6c02
+
	ld b,$02
	call func_6b5f
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	call @func_6b00
	jr nc,+
	jp z,func_6c17
	call func_6c08
+
	ld b,$ff
	call func_6b5f
	call partAnimate
	jp objectApplySpeed
	
func_6b5f:
	ld e,$cd
	ld a,(de)
	add b
	ld (de),a
	ret
	
func_6b65:
	call objectGetTileAtPosition
	ld a,l
	ldh (<hFF8C),a
	ld c,(hl)
	call func_6b71
	jr func_6bca
	
func_6b71:
	ld a,$ff
	ld ($cfd5),a
	xor a
func_6b77:
	ldh (<hFF8B),a
	ld hl,table_6bab
	rst_addAToHl
	ld a,(hl)
	cp c
	jr nz,func_6b9f
	ld a,($ccd6)
	and $7f
	cp $01
	ldh a,(<hFF8B)
	ld ($cfd5),a
	jr z,+
	add $04
+
	ld hl,bitTable
	add l
	ld l,a
	ld a,($ccd4)
	or (hl)
	ld ($ccd4),a
	jr func_6baf

func_6b9f:
	ldh a,(<hFF8B)
	inc a
	cp $04
	jr nz,func_6b77
	ld hl,$ccd6
	dec (hl)
	ret
	
table_6bab:
	.db $d9
	.db $d7
	.db $dc
	.db $d8

func_6baf:
	call objectGetShortPosition
	ld c,a
	ld a,$a0
	call setTile
	ld h,d
	ld l,$c6
	ld (hl),$03
	ld a,($ccd6)
	and $7f
	cp $01
	ret nz
	ld a,SND_SWITCH
	jp playSound

func_6bca:
	ld a,($cfd5)
	cp $ff
	ret z
	ld a,$04
--
	ldh (<hFF8B),a
	ldbc, INTERAC_FALLING_ROCK $04
	ld a,($cfd5)
	cp $02
	jr c,+
	ldbc, INTERAC_FALLING_ROCK $05
+
	call objectCreateInteraction
	jr nz,+
	ld l,$4b
	ldh a,(<hFF8C)
	call setShortPosition
	ld l,$49
	ldh a,(<hFF8B)
	dec a
	ld (hl),a
	jr nz,--
+
	ret

func_6bf6:
	ld a,SND_STRIKE
	call playSound
	ld a,$01
	ld ($cfd6),a
	jr func_6c27

func_6c02:
	call func_6c0e
	jp func_6b65
	
func_6c08:
	call func_6c0e
	jp func_6b65

func_6c0e:
	xor a
	ld ($cfd6),a
	ld hl,$ccd6
	inc (hl)
	ret
	
func_6c17:
	xor a
	ld ($cfd6),a
	ld a,($ccd6)
	and $7f
	jr nz,func_6c27
	ld a,SND_ERROR
	call playSound
func_6c27:
	ld hl,$ccd6
	set 7,(hl)
	jp partDelete
