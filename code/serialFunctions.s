 m_section_force serialCode NAMESPACE serialCode

;;
; @addr{4000}
func_4000:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret z
	ldh a,(<SVBK)
	push af
	ld a,$04
	ldh (<SVBK),a
	push de
	call _func_4036
	pop de
	ldh a,(<SC)
	rlca
	jr c,++
	ldh a,(<hSerialInterruptBehaviour)
	cp $e0
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
	call _func_41dc
	cp $80
	ret z


_func_4049:
	ld a,($d981)
	ld hl,$d9e5
	rst_addAToHl
	ld a,($d981)
	or a
	jr nz,_func_4066
	ld a,(hl)
	or a
	jr nz,_func_405f
	inc a
	ld ($d98b),a
	ret


_func_405f:
	ld ($d987),a
	xor a
	ld ($d982),a
_func_4066:
	inc a
	ld ($d981),a
	ld a,($d987)
	dec a
	ld ($d987),a
	ldi a,(hl)
	jr nz,+
	xor a
	ld ($d988),a
	ld a,($d982)
+
	ldh (<SB),a
	ld hl,$d982
	add (hl)
	ld (hl),a
	xor a
	ld ($d98b),a
	ret


_func_4087:
	ldh a,(<hSerialRead)
	or a
	ret z
	ld a,$01
	ld ($d98b),a
	xor a
	ld ($ff00+R_SB),a
	ldh (<hSerialRead),a
	ret


_func_4096:
	call _func_41dc
	cp $80
	jp z,serialFunc_0c7e
	jp _func_4269
_func_40a1:
	call _func_41dc
	jp serialFunc_0c7e
	

_func_40a7:
	xor a
	ld ($d98b),a
	call _func_41dc
	cp $80
	ret z
	ld a,($d981)
	ld b,a
	or a
	jr nz,_func_40d7
	ldh a,(<hSerialByte)
	cp $ff
	jr z,+
	or a
	jr nz,_func_40d4
+
	ld a,($d985)
	or a
	ret nz
	ld hl,$d984
	inc (hl)
	ret nz
	ld a,$86
	ldh (<hFFBD),a
	xor a
	ld ($d988),a
	ret


_func_40d4:
	ld ($d987),a
_func_40d7:
	ld hl,$d987
	dec (hl)
	jr nz,_func_40f3
	ldh a,(<hSerialByte)
	ld hl,$d982
	cp (hl)
	jr z,+
	ld a,$81
	ldh (<hFFBD),a
+
	xor a
	ld ($d988),a
	ld ($d984),a
	ld ($ff00+R_SB),a
	ret


_func_40f3:
	ld a,b
	ld de,$d9e5
	call addAToDe
	ld a,b
	inc a
	ld ($d981),a
	ldh a,(<hSerialByte)
	ld (de),a
	ld hl,$d982
	add (hl)
	ld (hl),a
	xor a
	ld ($ff00+R_SB),a
	ld ($d984),a
	ret


_FFBE_04:
	ldh a,(<hFFBF)
	rst_jumpTable
	.dw _FFBE_04_FFBF_00
	.dw _func_4280
	.dw _FFBE_04_FFBF_02
	.dw _func_4280
	.dw _FFBE_04_FFBF_04
	.dw _func_4280
	.dw _func_438e
	.dw _func_4087
	.dw _FFBE_04_FFBF_08
	.dw _FFBE_04_FFBF_09
	.dw _func_438e
	.dw _FFBE_04_FFBF_0b
	.dw _FFBE_04_FFBF_0c
	.dw _FFBE_04_FFBF_0d
	.dw _func_438e
	.dw _FFBE_04_FFBF_0f
	.dw _func_4280
	.dw _func_4096
	.dw _FFBE_04_FFBF_12
	.dw _func_4280
	.dw _func_438e
	.dw _func_43f5
	.dw _func_4280
	.dw _func_4096
	.dw _func_437b


_FFBE_03:
	ldh a,(<hFFBF)
	rst_jumpTable
	.dw _FFBE_03_FFBF_00
	.dw _func_4280
	.dw _func_438e
	.dw _FFBE_03_FFBF_03
	.dw _func_4280
	.dw _func_438e
	.dw _FFBE_03_FFBF_06
	.dw _func_4280
	.dw _func_438e
	.dw _func_43f5
	.dw _func_4280
	.dw _FFBE_03_FFBF_0b
	.dw _func_4280
	.dw _func_40a1
	.dw _func_4280
	.dw _func_4096
	.dw _FFBE_03_FFBF_10
	.dw _func_4280
	.dw _func_438e
	.dw _FFBE_03_FFBF_13
	.dw _func_43f5
	.dw _func_4280
	.dw _func_438e
	.dw _func_437b


_FFBE_03_FFBF_00:
	xor a
	jr ++
	
_FFBE_03_FFBF_03:
	ld a,$01
	jr ++
	
_FFBE_03_FFBF_06:
	ld a,$02
++
	ldh (<hActiveFileSlot),a; $417f
	call loadFile
	ldh (<hFF8B),a
_func_4186:
	call _func_4269
	ld hl,$d9e5
	ld a,$21
	ldi (hl),a		; $418e [hl = $d9e5]
	ld c,a
	ldh a,(<hFF8B)
	ldi (hl),a		; $4192 [hl = $d9e6]
	ldi (hl),a		; $4193 [hl = $d9e7]
	add a
	add c
	ld c,a
	ld a,(wLinkMaxHealth)
	ldi (hl),a		; $419a [hl = $d9e8]
	ldi (hl),a		; $419b [hl = $d9e9]
	add a
	add c
	ld c,a
	ld a,(wDeathCounter)
	ldi (hl),a		; $41a2 [hl = $d9ea]
	add c
	ld c,a
	ld a,(wDeathCounter+1)
	ldi (hl),a		; $41a8 [hl = $d9eb]
	add c
	ld c,a
	ld a,(wFileIsLinkedGame); $41ab
	ldi (hl),a		; $41ae [hl = $d9ec]
	add c
	ld c,a
	ld a,(wFileIsHeroGame)
	add a
	ld e,a
	ld a,(wFileIsCompleted)
	or e
	ldi (hl),a		; $41ba [hl = $d9ed]
	add c
	ld c,a
	ld de,wGameID
	ld b,$16
--
	ld a,(de)
	ldi (hl),a		; $41c3 [hl = $d9ee-$da03]
	add c
	ld c,a
	inc e
	dec b
	jr nz,--
.ifdef ROM_AGES
	ld a,$a1
.else
	ld a,$a0
.endif
	ldi (hl),a		; $41cc [hl = $da04]
	add c
	ld c,a
	ldh a,(<hActiveFileSlot); $41cf
	ld (hl),a		; $41d1 [hl = $da05]
	add c
	ldi (hl),a		; $41d3 [hl = $da05]
	ld a,$01
	ld ($d988),a
	jp _func_4049


_func_41dc:
	ldh a,(<hSerialRead)
	or a
	jr nz,_func_41fa
	ld a,($d985)
	or a
	jr nz,+
	ld hl,$d989
	call decHlRef16WithCap
	jr z,_func_41f1
+
	pop af
	ret


_func_41f1:
	xor a
	ld ($d988),a
	ld a,$80
	ldh (<hFFBD),a
	ret


_func_41fa:
	ld ($d988),a
	xor a
	ldh (<hSerialRead),a
	ldh (<hFFBD),a
_set_d989to00b4:
	ld a,$b4
	ld ($d989),a
	ld a,$00
	ld ($d98a),a
	ret
	

_FFBE_00:
_FFBE_01:
	ldh a,(<hFFBF)
	rst_jumpTable
	.dw _func_4186
	.dw _func_4280
	.dw _func_438e
	.dw _func_4293
	.dw _func_4280
	.dw _func_4096
	.dw _func_422f


_FFBE_02:
	ldh a,(<hFFBF)
	rst_jumpTable
	.dw _func_4293
	.dw _func_4280
	.dw _func_4096
	.dw _func_4186
	.dw _func_4280
	.dw _func_438e
	.dw _func_422f


_func_422f:
	call serialFunc_0c7e
	xor a
	ldh (<hFFBD),a
	call _func_44ec
	jr z,_setBDto84
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
	ld hl,_table_4503
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl
	ld a,($d98e)
	add c
	and $07
	rst_addAToHl
	ld a,(hl)
	ld (w4RingFortuneStuff),a
	ret
	
	
_setBDto84:
	ld a,$84
	ldh (<hFFBD),a
	ret


_func_4269:
	ldh a,(<hFFBF)
	inc a
	ldh (<hFFBF),a
_func_426e:
	xor a
	ld ($d981),a
	ldh (<hFFBD),a
	ld ($d982),a
	ld ($d984),a
	inc a
	ld ($d988),a
	jr _set_d989to00b4
	
	
_func_4280:
	call _func_4043
	call _func_44d7
	ld a,($d986)
	or a
	jr z,_func_4269
	ldh a,(<hFFBF)
	dec a
	ldh (<hFFBF),a
	jr _func_426e
	
	
_func_4293:
	call _func_40a7
	call _func_44d7
	ld hl,w4RingFortuneStuff
	ld de,$d9ee
	ld b,$07
	call copyMemoryReverse
	jp _func_43f5
	
	
_FFBE_03_FFBF_0b:
	ld a,($d981)
	or a
	ld a,$00
	jr nz,+
	inc a
+
	ld ($d985),a
	call _func_40a7
	ld a,($d988)
	or a
	ret nz
	ld a,($d9e6)
	cp $c0
	jr nz,_func_42c5
	jp _func_43f5
	
	
_func_42c5:
	cp $b0
	jp nz,_func_43e0
	ld a,($d9e7)
	ldh (<hActiveFileSlot),a
	cp $03
	jp nc,serialFunc_0c7e
	call loadFile
	ld a,$0d
	ldh (<hFFBF),a
	jp _func_43f5
	
	
_FFBE_03_FFBF_10:
	call _func_4269
	ld hl,w4RingFortuneStuff
	ld de,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jr _func_4350
	
	
_FFBE_04_FFBF_08:
	call _func_4269
	ld hl,$d9e5
	ld a,$03
	ldi (hl),a
	ld a,$c0
	ldi (hl),a
	ld a,$c3
	ld (hl),a
	ld a,$01
	ld ($d988),a
	jp _func_4049
	
	
_FFBE_04_FFBF_09:
_FFBE_04_FFBF_0d:
	call _func_4043
	call _func_44d7
	jp _func_4269
	
	
_FFBE_03_FFBF_13:
	call _func_40a7
	call _func_44d7
	ldh a,(<hFFBD)
	cp $81
	jp z,_func_4269
	ld hl,w4RingFortuneStuff
	ld de,$d9e6
	ld b,$08
	call copyMemoryReverse
	jp _func_4269
	
	
_FFBE_04_FFBF_0f:
	call _func_40a7
	call _func_44d7
	ld hl,wRingsObtained
	ld de,$d9e6
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
	ld de,$d9e6
	ld b,$08
	call copyMemoryReverse
	jp _func_43f5
	
	
_FFBE_04_FFBF_12:
	call _func_4269
_func_4350:
	ld a,$0a
	ld c,a
	ld ($d9e5),a
	ld de,$d9e6
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
	ld ($d988),a
	jp _func_4049
	
	
_FFBE_04_FFBF_0b:
	call _func_41dc
	cp $80
	jp z,serialFunc_0c7e
	jp serialFunc_0c7e
	
	
_func_437b:
	call serialFunc_0c7e
	ldh (<hFFBD),a
	ld de,w4RingFortuneStuff
	ld hl,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jp saveFile
	
	
_func_438e:
	call _func_439a
	call _func_44d7
	call _func_4269
	jp _func_4036
	
	
_func_439a:
	call _func_40a7
	ld a,($d988)
	or a
	ret nz
	ldh a,(<hFFBD)
	or a
	jr z,_func_43ab
	pop af
	jp serialFunc_0c7e
	
	
_func_43ab:
	ld a,($d9e6)
	cp $b1
	jr nz,_func_43bd
	xor a
	ld ($d986),a
	ldh a,(<hFFBF)
	sub $02
	ldh (<hFFBF),a
	ret
	
	
_func_43bd:
	cp $b0
	ret z
	ld a,$82
	ldh (<hFFBD),a
	ret
	
	
_FFBE_04_FFBF_0c:
	call _func_4269
	ld hl,$d9e5
	ld a,$04
	ldi (hl),a
	ld a,$b0
	ldi (hl),a
	ld a,(wTmpcbbc)
	ldi (hl),a
	add $b4
	ldi (hl),a
	ld a,$01
	ld ($d988),a
	jp _func_4049
	
	
_func_43e0:
	ld hl,_table_4500
	ld a,($d986)
	inc a
	ld ($d986),a
	cp $05
	jr c,_func_43fc
	ld a,$80
	ldh (<hFFBD),a
	jp serialFunc_0c7e
	
	
_func_43f5:
	xor a
	ld ($d986),a
	ld hl,_table_44fd
_func_43fc:
	call _func_4269
	ld a,(hl)
	ld b,a
	ld de,$d9e5
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-
	jp _func_4049
	
	
_FFBE_04_FFBF_00:
	ld a,$00
	jr ++
	
_FFBE_04_FFBF_02:
	ld a,$01
	jr ++
	
_FFBE_04_FFBF_04:
	ld a,$02
++
	ldh (<hFF8B),a
	call _func_40a7
	call _func_44d7
	ldh a,(<hFF8B)
	ld hl,$da05
	jr nz,_func_43e0
	swap a
	rrca
	ld hl,$d780
	rst_addAToHl
	ld de,$d9e6
	ld b,$08
-
	ld a,(de)
	ldi (hl),a
	inc de
	dec b
	jr nz,-
	ldh a,(<hFF8B)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld de,$d9f0
	ld b,$06
	call copyMemoryReverse
	ldh a,(<hFF8B)
	inc a
	ld hl,w4RingFortuneStuff
	ld bc,$0016
-
	dec a
	jr z,_func_4459
	add hl,bc
	jr -
	
	
_func_4459:
	ld b,$16
	ld de,$d9ee
	call copyMemoryReverse
	ld a,(wOpenedMenuType)
	cp $08
	jr nz,_func_447c
	ld de,$d9ee
	call _func_44ef
	jr nz,_func_448c
	ld hl,$da00
	ldi a,(hl)
	or (hl)
	inc l
	or (hl)
	jr z,_func_448c
	jp _func_43f5
	
	
_func_447c:
	ld a,($da04)
.ifdef ROM_AGES
	cp $a0
.else
	cp $a1
.endif
	jr nz,_func_448c
	ld a,($da02)
	or a
	jr z,_func_448c
	jp _func_43f5


_func_448c:
	ldh a,(<hFF8B)
	ld d,$00
	swap a
	rrca
	add d
	ld hl,$d780
	rst_addAToHl
	set 7,(hl)
	ldh a,(<hFF8B)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld b,$06
	call clearMemory
	jp _func_43f5

;;
; @addr{44ac}
func_44ac:
	ldh a,(<SVBK)
	push af
	ld a,$04
	ldh (<SVBK),a
	
	xor a
	ld hl,$d980
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldh (<hFFBE),a
	ldh (<hFFBF),a
	ldh (<hFFBD),a
	call _set_d989to00b4

	ld a,$e1
	ldh (<R_SB),a
	ld a,$80
	ld (w4Filler1+8),a
	call writeToSC
	
	pop af
	ldh (<SVBK),a
	ret


_func_44d7:
	ld a,($d988)
	or a
	jr z,_func_44df
	pop af
	ret


_func_44df:
	ldh a,(<hFFBD)
	or a
	ret z
	cp $81
	jp z,_func_43e0
	pop af
	jp serialFunc_0c7e


_func_44ec:
	ld de,w4RingFortuneStuff
_func_44ef:
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


_table_44fd:
	; bytes to copy to $d9e5, incl itself
	.db $03 $b0 $b3

_table_4500:
	.db $03 $b1 $b4

_table_4503:
	.db _table_4506-CADDR
	.db _table_450e-CADDR
	.db _table_4516-CADDR

_table_4506:
	.db $0f $2e $2e $30
	.db $31 $32 $0f $1d

_table_450e:
	.db $3b $14 $24 $24
	.db $3a $3b $12 $3c

_table_4516:
	.db $0a $1a $1b $1e
	.db $1f $20 $0a $39

.ends