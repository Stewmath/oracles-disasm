specialObjectCode_companionCutscene:
	ld hl,w1Companion.id
	ld a,(hl)
	sub $0f
	rst_jumpTable
	.dw rickyCutscenes
	.dw dimitriCutscenes
	.dw mooshCutscenes
	.dw mapleCutscenes

rickyCutscenes:
	ld e,Object.state
	ld a,(de)
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw _rickyState1

@state0:
	call _incState
	ld h,d
	ld l,Object.subid
	ld a,(hl)
	or a
	jr z,_func_69fe
	ld l,$10
	ld (hl),$50
	ld l,$09
	ld (hl),$08

_func_69f3:
	ld bc,$fe00
	call objectSetSpeedZ
	ld a,$02
	jp specialObjectSetAnimation

_func_69fe:
	xor a
	ld ($cbb5),a
	ld a,$1e
	jp specialObjectSetAnimation

_incState:
	ld a,$01
	ld (de),a
	callab bank5.specialObjectSetOamVariables
	jp objectSetVisiblec0

_rickyState1:
	ld e,Object.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,Object.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1

@@substate0:
	call specialObjectAnimate
	ld h,d
	ld l,$21
	ld a,(hl)
	or a
	jr z,+
	ld a,$01
	ld ($cbb5),a
	ld l,$05
	inc (hl)
+
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld bc,$ff20
	jp objectSetSpeedZ

@@substate1:
	call specialObjectAnimate
	ld h,d
	ld l,$21
	ld a,(hl)
	or a
	ret z
	ld (hl),$00
	inc a
	jr z,+

@clink:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_CLINK
	ld bc,$f812
	jp objectCopyPositionWithOffset

+
	ld l,$05
	ld (hl),$00
	jp _func_69fe

@subid1:
	ld e,Object.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6
	.dw @@substate7
	.dw @@substate8
	.dw @@substate9
	.dw @@substateA

@@substate0:
	ld l,$05
	inc (hl)

@@substate1:
	call objectApplySpeed
	ld e,$0d
	ld a,(de)
	bit 7,a
	jr nz,+
	ld hl,$d00d
	ld b,(hl)
	add $18
	cp b
	jr c,+
	call itemIncSubstate
	inc (hl)
	inc l
	ld (hl),$3c
	ld l,$0e
	xor a
	ldi (hl),a
	ld (hl),a
	jp specialObjectAnimate
+
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,$06
	ld (hl),$08
	jp specialObjectAnimate

@@substate2:
	call itemDecCounter1
	ret nz
	dec l
	dec (hl)
	jp _func_69f3

@@substate3:
	call itemDecCounter1
	ret nz
	ld (hl),$5a
	dec l
	inc (hl)
	ld a,$14
	jp specialObjectSetAnimation

@@substate4:
	call specialObjectAnimate
	call itemDecCounter1
	ret nz
	ld (hl),$0c
	dec l
	inc (hl)
	ld a,$1f
	call specialObjectSetAnimation
	jp @clink

@@substate5:
	call itemDecCounter1
	ret nz
	ld (hl),$3c
	dec l
	inc (hl)
	ld a,$1e
	jp specialObjectSetAnimation

@@substate6:
	call itemDecCounter1
	ret nz
	ld (hl),$1e
	dec l
	inc (hl)
	ld hl,wActiveRing
	ld (hl),$ff
	ld a,$81
	ld ($cc77),a
	ld hl,$d010
	ld (hl),$14
	ld l,$14
	ld (hl),$00
	inc l
	ld (hl),$fe
	ld a,$18
	ld ($d009),a
	ld a,$53
	jp playSound

@@substate7:
	call itemDecCounter1
	ret nz
	ld (hl),$14
	dec l
	inc (hl)
	xor a
	ld hl,$d01a
	ld (hl),a
	inc a
	ld ($cca4),a
	ret

@@substate8:
	call itemDecCounter1
	ret nz
	dec l
	inc (hl)
	ld l,$09
	ld (hl),$18

@@func_6b2e:
	ld a,$1c
	call specialObjectSetAnimation
	ld bc,$fe00
	jp objectSetSpeedZ

@@substate9:
	call objectApplySpeed
	ld e,$0d
	ld a,(de)
	sub $10
	rlca
	jr nc,+
	ld hl,$cfdf
	ld (hl),$01
	ret
+
	ld c,$40
	call objectUpdateSpeedZ_paramC
	ret nz
	call itemIncSubstate
	ld l,$06
	ld (hl),$08
	jp specialObjectAnimate

@@substateA:
	call itemDecCounter1
	ret nz
	ld l,$05
	dec (hl)
	jp @@func_6b2e


mooshCutscenes:
	ld e,Object.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call _incState
	ld h,d
	ld l,$06
	ld (hl),$5a
	ld l,$10
	ld (hl),$37
	ld l,$36
	ld (hl),$05
	ld l,$09
	ld (hl),$10
	ld l,$0e
	ld (hl),$ff
	inc l
	ld (hl),$e0
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERACID_BANANA
	ld l,$57
	ld (hl),d
+
	ld a,$07
	jp specialObjectSetAnimation

@state1:
	ld e,Object.substate
	ld a,(de)
	or a
	jr z,+
	call specialObjectAnimate
	call objectApplySpeed
+
	ld e,Object.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4

@@substate0:
	call itemDecCounter1
	ret nz
	ld (hl),$48
	ld l,$05
	inc (hl)
	ret

@@substate1:
	call itemDecCounter1
	ret nz
	ld (hl),$06
	ld l,$05
	inc (hl)
	jp seasonsFunc_06_6d89

@@substate2:
	ld h,d
	ld l,$09
	ld a,(hl)
	cp $10
	jr z,@@func_6bd2
	ld l,$05
	inc (hl)
	ret
@@func_6bd2:
	ld l,$06
	dec (hl)
	ret nz
	call seasonsFunc_06_6da0
	ld (hl),$06
	jp seasonsFunc_06_6d89

@@substate3:
	ld h,d
	ld l,$09
	ld a,(hl)
	cp $10
	jr nz,@@func_6bd2
	ld l,$05
	inc (hl)
	ld a,$07
	jp specialObjectSetAnimation

@@substate4:
	ld e,$0b
	ld a,(de)
	cp $b0
	ret c
	ld hl,$d101
	ld b,$3f
	call clearMemory
	ld hl,$d101
	ld (hl),$10
	ld l,$0b
	ld (hl),$e8
	inc l
	inc l
	ld (hl),$28
	ret


dimitriCutscenes:
	ld e,Object.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call _incState
	ld h,d
	ld l,$10
	ld (hl),$28
	ld l,$0e
	ld (hl),$e0
	inc l
	ld (hl),$ff
	ld a,$19
	jp specialObjectSetAnimation

@state1:
	ld e,Object.substate
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3
	.dw @@substate4
	.dw @@substate5
	.dw @@substate6

@@substate0:
	ld h,d
	ld l,$05
	inc (hl)
	ld l,$07
	ld a,(hl)
	cp $02
	jr nz,+
	push af
	ld a,$1a
	call specialObjectSetAnimation
	pop af
+
	ld b,a
	add a
	add b
	ld hl,@@table_6c5b
	rst_addAToHl
	ldi a,(hl)
	ld e,$09
	ld (de),a
	ld c,(hl)
	inc hl
	ld b,(hl)
	jp objectSetSpeedZ

@@table_6c5b:
	.db $0c $40 $fd
	.db $0c $a0 $fd
	.db $13 $80 $fe

@@substate1:
	call specialObjectAnimate
	call objectApplySpeed
	ld c,$18
	call objectUpdateSpeedZ_paramC
	ret nz
	ld h,d
	ld l,$07
	inc (hl)
	ld a,(hl)
	ld l,$05
	cp $03
	jr z,+
	dec (hl)
	ld l,$06
	ld (hl),$08
	ret
+
	inc (hl)
	ld l,$06
	ld (hl),$06
	ret

@@substate2:
	call itemDecCounter1
	ret nz
	ld l,$05
	inc (hl)
	ld l,$06
	ld (hl),$14
	ld a,$27
	jp specialObjectSetAnimation

@@substate3:
	call itemDecCounter1
	ret nz
	ld l,$05
	inc (hl)
	ld l,$06
	ld (hl),$78
	ret

@@substate4:
	call specialObjectAnimate
	call itemDecCounter1
	ret nz
	ld l,$05
	inc (hl)
	ld l,$06
	ld (hl),$3c
	ld l,$09
	ld (hl),$0b
	ld l,$10
	ld (hl),$14
	ret

@@substate5:
	call itemDecCounter1
	ret nz
	ld l,$05
	inc (hl)
	ld a,$26
	jp specialObjectSetAnimation

@@substate6:
	call specialObjectAnimate
	call objectApplySpeed
	ld e,$0d
	ld a,(de)
	cp $78
	jr nz,+
	ld a,$05
	jp specialObjectSetAnimation
+
	cp $b0
	ret c
	ld hl,$d101
	ld b,$3f
	call clearMemory
	ld hl,$d101
	ld (hl),$0f
	inc l
	ld (hl),$01
	ld l,$0b
	ld (hl),$48
	inc l
	inc l
	ld (hl),$d8
	ret


mapleCutscenes:
	ld e,Object.state
	ld a,(de)
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call _incState
	ld h,d
	ld l,$10
	ld (hl),$32
	ld l,$36
	ld (hl),$04
	ld l,$02
	ld a,(hl)
	or a
	ld a,$f0
	jr z,+
	ld a,d
	ld ($cc48),a
	ld a,$d0
+
	ld l,$0f
	ld (hl),a
	ld l,$09
	ld (hl),$18
	ld l,$02
	ld a,(hl)
	jp seasonsFunc_06_6d78

@state1:
	ld e,Object.subid
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1

@@subid1:
	ld e,Object.substate
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw seasonsFunc_06_6d62
	.dw _ret

@@@substate0:
	ld a,($cfc0)
	or a
	jr z,@@subid0
	call itemIncSubstate
	ld bc,$ff00
	call objectSetSpeedZ
	ld l,$09
	ld (hl),$0e
	ld l,$10
	ld (hl),$14
	ld a,$1b
	jp specialObjectSetAnimation

@@subid0:
	ld h,d
	ld l,$02
	ld a,(hl)
	ld l,$06
	dec (hl)
	call z,seasonsFunc_06_6d78
	call objectApplySpeed
	jp specialObjectAnimate

seasonsFunc_06_6d62:
	call objectApplySpeed
	ld c,$20
	call objectUpdateSpeedZAndBounce
	jp nc,seasonsFunc_06_6d74
	call itemIncSubstate
	ld l,$20
	ld (hl),$01

seasonsFunc_06_6d74:
	jp specialObjectAnimate

_ret:
	ret

seasonsFunc_06_6d78:
	ld hl,seasonsTable_06_6da8
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call seasonsFunc_06_6da0
	ld b,a
	rst_addAToHl
	ld a,(hl)
	ld e,$06
	ld (de),a
	ld a,b

seasonsFunc_06_6d89:
	sub $04
	and $07
	ret nz
	ld e,$09
	call convertAngleDeToDirection
	dec a
	and $03
	ld h,d
	ld l,$08
	ld (hl),a
	ld l,$36
	add (hl)
	jp specialObjectSetAnimation

seasonsFunc_06_6da0:
	ld e,$09
	ld a,(de)
	dec a
	and $1f
	ld (de),a
	ret

seasonsTable_06_6da8:
	.dw seasonsTable_06_6dac
	.dw seasonsTable_06_6dcc

seasonsTable_06_6dac:
	.db $06 $06 $06 $06 $07 $08 $09 $0a
	.db $0b $0a $09 $08 $07 $06 $06 $06
	.db $06 $06 $06 $06 $07 $08 $09 $0a
	.db $0b $0a $09 $08 $07 $06 $06 $06

seasonsTable_06_6dcc:
	.db $02 $02 $02 $02 $04 $06 $08 $0a
	.db $0d $0a $08 $06 $04 $02 $02 $02
	.db $02 $02 $02 $02 $04 $06 $08 $0a
	.db $0d $0a $08 $06 $04 $02 $02 $02
