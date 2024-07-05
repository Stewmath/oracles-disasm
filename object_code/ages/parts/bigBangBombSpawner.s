; ==================================================================================================
; PART_BIGBANG_BOMB_SPAWNER
; ==================================================================================================
partCode49:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	
@state0:
	ld h,d
	ld l,$c2
	ld a,(hl)
	cp $ff
	jr nz,@func_7754
	ld l,$c4
	ld (hl),$05
	jp func_77f0
@func_7754:
	ld l,$c4
	inc (hl)
	call func_78e3
	call func_793b
	ld a,SND_POOF
	call playSound
	call objectSetVisiblec1
	
@state1:
	call objectApplySpeed
	ld h,d
	ld l,$f1
	ld c,(hl)
	call objectUpdateSpeedZAndBounce
	jr c,@@noBounce
	jr nz,@@inAir
	ld e,$d0
	ld a,(de)
	srl a
	ld (de),a
@@inAir:
	jp partAnimate
@@noBounce:
	ld h,d
	ld l,$c4
	ld (hl),$03
	ld l,$c6
	ld (hl),$14
	jp partAnimate
	
@state2:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substateStub
	.dw @@substateStub
	.dw @@substate3
@@substate0:
	xor a
	ld (wLinkGrabState2),a
	inc a
	ld (de),a
	jp objectSetVisiblec1
@@substateStub:
	ret
@@substate3:
	call objectSetVisiblec2
	jr @func_77b1
	
@state3:
	ld h,d
	ld l,$c6
	dec (hl)
	jr z,@func_77b1
	call partAnimate
	call func_79ab
	jp objectAddToGrabbableObjectBuffer
@func_77b1:
	ld h,d
	ld l,$c4
	ld (hl),$04
	ld l,$e4
	set 7,(hl)
	ld l,$db
	ld a,$0a
	ldi (hl),a
	ldi (hl),a
	ld (hl),$0c
	ld a,$01
	call partSetAnimation
	ld a,SND_EXPLOSION
	call playSound
	jp objectSetVisible83
	
@state4:
	call partAnimate
	ld e,$e1
	ld a,(de)
	inc a
	jp z,partDelete
	dec a
	ld e,$e6
	ld (de),a
	inc e
	ld (de),a
	ret
	
@state5:
	ld h,d
	ld l,$f0
	dec (hl)
	ret nz
	ld l,$c6
	inc (hl)
	call func_77f0
	jp z,partDelete
	jr func_7858
	
func_77f0:
	ld h,d
	ld l,$c6
	ld a,(hl)
	ld bc,table_780f
	call addDoubleIndexToBc
	ld a,(bc)
	cp $ff
	jr nz,func_7805
	ld a,$01
	ld ($cfc0),a
	ret
	
func_7805:
	ld l,$f0
	ld (hl),a
	inc bc
	ld a,(bc)
	ld l,$f5
	ld (hl),a
	or d
	ret
	
table_780f:
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $3c $01
	.db $28 $01
	.db $28 $01
	.db $28 $01
	.db $28 $01
	.db $28 $01
	.db $1e $01
	.db $1e $01
	.db $1e $01
	.db $1e $01
	.db $1e $01
	.db $14 $01
	.db $14 $01
	.db $14 $01
	.db $14 $01
	.db $14 $01
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $14 $02
	.db $b4 $02
	.db $ff
	
func_7858:
	xor a
	ld e,$f2
	ld (de),a
	inc e
	ld (de),a
	call func_78bd
	ld e,$f5
	ld a,(de)
-
	ldh (<hFF92),a
	call func_786f
	ldh a,(<hFF92)
	dec a
	jr nz,-
	ret

func_786f:
	ld e,$f4
	ld a,(de)
	add a
	add a
	ld bc,table_789d
	call addDoubleIndexToBc
	call getRandomNumber
	and $07
	call addAToBc
	ld a,(bc)
	ldh (<hFF8B),a
	ld h,d
	ld l,$f2
	call checkFlag
	jr nz,func_786f
	call getFreePartSlot
	ret nz
	ld (hl),PART_BIGBANG_BOMB_SPAWNER
	inc l
	ldh a,(<hFF8B)
	ld (hl),a
	ld h,d
	ld l,$f2
	jp setFlag
	
table_789d:
	.db $00 $01 $05 $06 $0a $0b $0f $00
	.db $01 $02 $06 $07 $0b $0c $0d $01
	.db $03 $04 $05 $09 $0a $0e $0f $03
	.db $02 $03 $07 $08 $09 $0d $0e $02

func_78bd:
	ld a,(w1Link.xh)
	cp $50
	jr nc,func_78d2
	ld a,(w1Link.yh)
	cp $40
	jr nc,func_78ce
	xor a
	jr ++
	
func_78ce:
	ld a,$01
	jr ++

func_78d2:
	ld a,(w1Link.yh)
	cp $40
	jr nc,func_78dd
	ld a,$02
	jr ++
	
func_78dd:
	ld a,$03
++
	ld e,$f4
	ld (de),a
	ret

func_78e3:
	ld h,d
	ld l,$c2
	ld a,(hl)
	ld hl,table_791b
	rst_addDoubleIndex
	ld e,$cb
	ldi a,(hl)
	ld (de),a
	ld e,$cd
	ldi a,(hl)
	ld (de),a
	call objectGetAngleTowardLink
	ld e,$c9
	ld (de),a
	call getRandomNumber
	and $0f
	ld hl,table_790b
	rst_addAToHl
	ld b,(hl)
	ld e,$c9
	ld a,(de)
	add b
	and $1f
	ld (de),a
	ret

table_790b:
	.db $01 $02 $03 $ff
	.db $fe $fd $00 $00
	.db $01 $02 $02 $ff
	.db $fe $00 $00 $00

table_791b:
	.db $00 $00
	.db $00 $28
	.db $00 $50
	.db $00 $78
	.db $00 $a0
	.db $20 $a0
	.db $40 $a0
	.db $60 $a0
	.db $80 $a0
	.db $80 $78
	.db $80 $50
	.db $80 $28
	.db $80 $00
	.db $60 $00
	.db $40 $00
	.db $20 $00

func_793b:
	call func_78bd
	ld e,$c2
	ld a,(de)
	add a
	ld hl,table_7962
	rst_addDoubleIndex
	ld e,$f4
	ld a,(de)
	rst_addAToHl
	ld a,(hl)
	ld bc,table_79a2
	call addAToBc
	ld a,(bc)
	ld h,d
	ld l,$d0
	ld (hl),a
	ld l,$f1
	ld (hl),$20
	ld l,$d4
	ld (hl),$80
	inc l
	ld (hl),$fd
	ret

table_7962:
	.db $01 $04 $05 $08
	.db $00 $03 $04 $05
	.db $00 $04 $00 $04
	.db $03 $05 $00 $04
	.db $05 $08 $01 $04
	.db $05 $06 $00 $02
	.db $05 $05 $00 $00
	.db $06 $05 $02 $00
	.db $08 $05 $04 $01
	.db $05 $03 $04 $00
	.db $04 $00 $04 $00
	.db $04 $00 $05 $03
	.db $04 $01 $08 $05
	.db $02 $00 $06 $05
	.db $00 $00 $04 $04
	.db $00 $02 $05 $06

table_79a2:
	.db $28 $32 $3c
	.db $46 $50 $5a
	.db $64 $6e $78

func_79ab:
	call objectGetShortPosition
	ld hl,wRoomLayout
	rst_addAToHl
	ld a,(hl)
	cp $54
	jr z,func_79c4
	cp $55
	jr z,func_79cb
	cp $56
	jr z,func_79d2
	cp $57
	jr z,func_79d9
	ret
	
func_79c4:
	ld hl,table_79e3
	ld e,$ca
	jr ++
	
func_79cb:
	ld hl,table_79e1
	ld e,$cc
	jr ++
	
func_79d2:
	ld hl,table_79e1
	ld e,$ca
	jr ++
	
func_79d9:
	ld hl,table_79e3
	ld e,$cc
++
	jp add16BitRefs

table_79e1:
	.db $00 $01

table_79e3:
	.db $00 $ff
