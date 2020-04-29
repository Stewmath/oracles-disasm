;;
; @addr{6cec}
specialObjectCode_companionCutscene:
	ld hl,w1Companion.id		; $6cec
	ld a,(hl)		; $6cef
	sub SPECIALOBJECTID_RICKY_CUTSCENE			; $6cf0
	rst_jumpTable			; $6cf2
	.dw _specialObjectCode_rickyCutscene
	.dw _specialObjectCode_dimitriCutscene
	.dw _specialObjectCode_mooshCutscene
	.dw _specialObjectCode_mapleCutscene

;;
; @addr{6cfb}
_specialObjectCode_rickyCutscene:
	ld e,SpecialObject.state		; $6cfb
	ld a,(de)		; $6cfd
	ld a,(de)		; $6cfe
	rst_jumpTable			; $6cff
	.dw @state0
	.dw _rickyCutscene_state1

@state0:
	call _companionCutsceneInitOam		; $6d04
	ld h,d			; $6d07
	ld l,SpecialObject.speed		; $6d08
	ld (hl),SPEED_200		; $6d0a
	ld l,SpecialObject.angle		; $6d0c
	ld (hl),$08		; $6d0e

_rickyCutsceneJump:
	ld bc,$fe00		; $6d10
	call objectSetSpeedZ		; $6d13
	ld a,$02		; $6d16
	jp specialObjectSetAnimation		; $6d18


;;
; @param	de	Pointer to Object.state variable
; @addr{6d1b}
_companionCutsceneInitOam:
	ld a,$01		; $6d1b
	ld (de),a		; $6d1d
	callab bank5.specialObjectSetOamVariables		; $6d1e
	jp objectSetVisiblec0		; $6d26


_rickyCutscene_state1:
	ld e,SpecialObject.subid		; $6d29
	ld a,(de)		; $6d2b
	rst_jumpTable			; $6d2c
	.dw @subid0
	.dw @subid1

@subid0:
	ret			; $6d31

@subid1:
	ld e,SpecialObject.state2		; $6d32
	ld a,(de)		; $6d34
	rst_jumpTable			; $6d35
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
	.dw @substate9
	.dw @substateA

@substate0:
	ld l,SpecialObject.state2		; $6d4c
	inc (hl)		; $6d4e

@substate1:
	call objectApplySpeed		; $6d4f

	ld e,SpecialObject.xh		; $6d52
	ld a,(de)		; $6d54
	bit 7,a			; $6d55
	jr nz,++		; $6d57

	ld hl,w1Link.xh		; $6d59
	ld b,(hl)		; $6d5c
	add $18			; $6d5d
	cp b			; $6d5f
	jr c,++			; $6d60

	call itemIncState2		; $6d62
	inc (hl)		; $6d65
	ld l,SpecialObject.z		; $6d66
	xor a			; $6d68
	ldi (hl),a		; $6d69
	ld (hl),a		; $6d6a
	ld l,SpecialObject.counter1		; $6d6b
	ld (hl),$3c		; $6d6d
	jp specialObjectAnimate		; $6d6f
++
	ld c,$40		; $6d72
	call objectUpdateSpeedZ_paramC		; $6d74
	ret nz			; $6d77
	call itemIncState2		; $6d78
	ld l,SpecialObject.counter1		; $6d7b
	ld (hl),$08		; $6d7d
	jp specialObjectAnimate		; $6d7f

@substate2:
	call itemDecCounter1		; $6d82
	ret nz			; $6d85
	ld l,SpecialObject.state2		; $6d86
	dec (hl)		; $6d88
	jp _rickyCutsceneJump		; $6d89

@substate3:
	call itemDecCounter1		; $6d8c
	ret nz			; $6d8f
	ld l,SpecialObject.state2		; $6d90
	inc (hl)		; $6d92
	ld l,SpecialObject.counter1		; $6d93
	ld (hl),$5a		; $6d95
	ld a,$14		; $6d97
	jp specialObjectSetAnimation		; $6d99

@substate4:
	call specialObjectAnimate		; $6d9c
	call itemDecCounter1		; $6d9f
	ret nz			; $6da2
	ld l,SpecialObject.state2		; $6da3
	inc (hl)		; $6da5
	ld l,SpecialObject.counter1		; $6da6
	ld (hl),$0c		; $6da8
	ld a,$1f		; $6daa
	call specialObjectSetAnimation		; $6dac
	call getFreeInteractionSlot		; $6daf
	ret nz			; $6db2

	ld (hl),$07		; $6db3
	ld bc,$f812		; $6db5
	jp objectCopyPositionWithOffset		; $6db8

	ld l,SpecialObject.state2		; $6dbb
	ld (hl),$00		; $6dbd
	ld a,$1e		; $6dbf
	jp specialObjectSetAnimation		; $6dc1

@substate5:
	call itemDecCounter1		; $6dc4
	ret nz			; $6dc7
	ld l,SpecialObject.state2		; $6dc8
	inc (hl)		; $6dca
	ld l,SpecialObject.counter1		; $6dcb
	ld (hl),$3c		; $6dcd
	ld a,$1e		; $6dcf
	jp specialObjectSetAnimation		; $6dd1

@substate6:
	call itemDecCounter1		; $6dd4
	ret nz			; $6dd7
	ld l,SpecialObject.state2		; $6dd8
	inc (hl)		; $6dda

	; counter1
	inc l			; $6ddb
	ld (hl),$1e		; $6ddc

	ld hl,wActiveRing		; $6dde
	ld (hl),$ff		; $6de1
	ld a,$81		; $6de3
	ld (wLinkInAir),a		; $6de5
	ld hl,w1Link.speed		; $6de8
	ld (hl),SPEED_80		; $6deb
	ld l,SpecialObject.speedZ		; $6ded
	ld (hl),$00		; $6def
	inc l			; $6df1
	ld (hl),$fe		; $6df2

	ld a,$18		; $6df4
	ld (w1Link.angle),a		; $6df6
	ld a,SND_JUMP		; $6df9
	jp playSound		; $6dfb

@substate7:
	call itemDecCounter1		; $6dfe
	ret nz			; $6e01
	ld l,SpecialObject.state2		; $6e02
	inc (hl)		; $6e04
	ld l,SpecialObject.counter1		; $6e05
	ld (hl),$14		; $6e07
	xor a			; $6e09
	ld hl,w1Link.visible		; $6e0a
	ld (hl),a		; $6e0d
	inc a			; $6e0e
	ld (wDisabledObjects),a		; $6e0f
	ret			; $6e12

@substate8:
	call itemDecCounter1		; $6e13
	ret nz			; $6e16
	ld l,SpecialObject.state2		; $6e17
	inc (hl)		; $6e19
	ld l,SpecialObject.angle		; $6e1a
	ld (hl),$18		; $6e1c

@jump:
	ld a,$1c		; $6e1e
	call specialObjectSetAnimation		; $6e20
	ld bc,$fe00		; $6e23
	jp objectSetSpeedZ		; $6e26

@substate9:
	call objectApplySpeed		; $6e29
	ld e,SpecialObject.xh		; $6e2c
	ld a,(de)		; $6e2e
	sub $10			; $6e2f
	rlca			; $6e31
	jr nc,+			; $6e32
	ld hl,$cfdf		; $6e34
	ld (hl),$01		; $6e37
	ret			; $6e39
+
	ld c,$40		; $6e3a
	call objectUpdateSpeedZ_paramC		; $6e3c
	ret nz			; $6e3f
	call itemIncState2		; $6e40
	ld l,SpecialObject.counter1		; $6e43
	ld (hl),$08		; $6e45
	jp specialObjectAnimate		; $6e47

@substateA:
	call itemDecCounter1		; $6e4a
	ret nz			; $6e4d
	ld l,SpecialObject.state2		; $6e4e
	dec (hl)		; $6e50
	jp @jump		; $6e51

;;
; @addr{6e54}
_specialObjectCode_mooshCutscene:
	ld e,SpecialObject.state		; $6e54
	ld a,(de)		; $6e56
	rst_jumpTable			; $6e57
	.dw @state0
	.dw @state1

@state0:
	call _companionCutsceneInitOam		; $6e5c
	ld h,d			; $6e5f
	ld l,SpecialObject.counter1		; $6e60
	ld (hl),$5a		; $6e62
	ld l,SpecialObject.speed		; $6e64
	ld (hl),SPEED_160		; $6e66
	ld l,SpecialObject.var36		; $6e68
	ld (hl),$05		; $6e6a
	ld l,SpecialObject.angle		; $6e6c
	ld (hl),$10		; $6e6e
	ld l,SpecialObject.z		; $6e70
	ld (hl),$ff		; $6e72
	inc l			; $6e74
	ld (hl),$e0		; $6e75

	call getFreeInteractionSlot		; $6e77
	jr nz,+			; $6e7a
	ld (hl),INTERACID_BANANA		; $6e7c
	ld l,Interaction.relatedObj1+1		; $6e7e
	ld (hl),d		; $6e80
+
	ld a,$07		; $6e81
	jp specialObjectSetAnimation		; $6e83

@state1:
	ld e,SpecialObject.state2		; $6e86
	ld a,(de)		; $6e88
	or a			; $6e89
	jr z,+			; $6e8a
	call specialObjectAnimate		; $6e8c
	call objectApplySpeed		; $6e8f
+
	ld e,SpecialObject.state2		; $6e92
	ld a,(de)		; $6e94
	rst_jumpTable			; $6e95
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	call itemDecCounter1		; $6ea0
	ret nz			; $6ea3
	ld (hl),$48		; $6ea4
	ld l,SpecialObject.state2		; $6ea6
	inc (hl)		; $6ea8
	ret			; $6ea9

@substate1:
	call itemDecCounter1		; $6eaa
	ret nz			; $6ead
	ld (hl),$06		; $6eae
	ld l,SpecialObject.state2		; $6eb0
	inc (hl)		; $6eb2
	jp _companionCutsceneFunc_7081		; $6eb3

@substate2:
	ld h,d			; $6eb6
	ld l,SpecialObject.angle		; $6eb7
	ld a,(hl)		; $6eb9
	cp $10			; $6eba
	jr z,@label_6ec2			; $6ebc
	ld l,SpecialObject.state2		; $6ebe
	inc (hl)		; $6ec0
	ret			; $6ec1

@label_6ec2:
	ld l,SpecialObject.counter1		; $6ec2
	dec (hl)		; $6ec4
	ret nz			; $6ec5
	call _companionCutsceneDecAngle		; $6ec6
	ld (hl),$06		; $6ec9
	jp _companionCutsceneFunc_7081		; $6ecb

@substate3:
	ld h,d			; $6ece
	ld l,SpecialObject.angle		; $6ecf
	ld a,(hl)		; $6ed1
	cp $10			; $6ed2
	jr nz,@label_6ec2		; $6ed4
	ld l,SpecialObject.state2		; $6ed6
	inc (hl)		; $6ed8
	ld a,$07		; $6ed9
	jp specialObjectSetAnimation		; $6edb

@substate4:
	ld e,SpecialObject.yh		; $6ede
	ld a,(de)		; $6ee0
	cp $b0			; $6ee1
	ret c			; $6ee3

	ld hl,w1Companion.id		; $6ee4
	ld b,$3f		; $6ee7
	call clearMemory		; $6ee9
	ld hl,w1Companion.id		; $6eec
	ld (hl),SPECIALOBJECTID_DIMITRI_CUTSCENE		; $6eef
	ld l,SpecialObject.yh		; $6ef1
	ld (hl),$e8		; $6ef3
	inc l			; $6ef5
	inc l			; $6ef6
	ld (hl),$28		; $6ef7
	ret			; $6ef9

;;
; @addr{6efa}
_specialObjectCode_dimitriCutscene:
	ld e,SpecialObject.state		; $6efa
	ld a,(de)		; $6efc
	rst_jumpTable			; $6efd
	.dw @state0
	.dw @state1

@state0:
	call _companionCutsceneInitOam		; $6f02
	ld h,d			; $6f05
	ld l,SpecialObject.speed		; $6f06
	ld (hl),SPEED_100		; $6f08
	ld l,SpecialObject.z		; $6f0a
	ld (hl),$e0		; $6f0c
	inc l			; $6f0e
	ld (hl),$ff		; $6f0f
	ld a,$19		; $6f11
	jp specialObjectSetAnimation		; $6f13

@state1:
	ld e,SpecialObject.state2		; $6f16
	ld a,(de)		; $6f18
	rst_jumpTable			; $6f19
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6

@substate0:
	ld h,d			; $6f28
	ld l,SpecialObject.state2		; $6f29
	inc (hl)		; $6f2b
	ld l,SpecialObject.counter2		; $6f2c
	ld a,(hl)		; $6f2e
	cp $02			; $6f2f
	jr nz,+			; $6f31

	push af			; $6f33
	ld a,$1a		; $6f34
	call specialObjectSetAnimation		; $6f36
	pop af			; $6f39
+
	ld b,a			; $6f3a
	add a			; $6f3b
	add b			; $6f3c
	ld hl,@@data		; $6f3d
	rst_addAToHl			; $6f40
	ldi a,(hl)		; $6f41
	ld e,SpecialObject.angle		; $6f42
	ld (de),a		; $6f44
	ld c,(hl)		; $6f45
	inc hl			; $6f46
	ld b,(hl)		; $6f47
	jp objectSetSpeedZ		; $6f48


; b0: angle
; b1/b2: speedZ
@@data:
	dbw $0c $fd40
	dbw $0c $fda0
	dbw $13 $fe80


@substate1:
	call specialObjectAnimate		; $6f54
	call objectApplySpeed		; $6f57
	ld c,$18		; $6f5a
	call objectUpdateSpeedZ_paramC		; $6f5c
	ret nz			; $6f5f

	ld h,d			; $6f60
	ld l,SpecialObject.counter2		; $6f61
	inc (hl)		; $6f63
	ld a,(hl)		; $6f64
	ld l,SpecialObject.state2		; $6f65
	cp $03			; $6f67
	jr z,+			; $6f69
	dec (hl)		; $6f6b
	ld l,SpecialObject.counter1		; $6f6c
	ld (hl),$08		; $6f6e
	ret			; $6f70
+
	inc (hl)		; $6f71
	ld l,SpecialObject.counter1		; $6f72
	ld (hl),$06		; $6f74
	ret			; $6f76

@substate2:
	call itemDecCounter1		; $6f77
	ret nz			; $6f7a
	ld l,SpecialObject.state2		; $6f7b
	inc (hl)		; $6f7d
	ld l,SpecialObject.counter1		; $6f7e
	ld (hl),$14		; $6f80
	ld a,$27		; $6f82
	jp specialObjectSetAnimation		; $6f84

@substate3:
	call itemDecCounter1		; $6f87
	ret nz			; $6f8a
	ld l,SpecialObject.state2		; $6f8b
	inc (hl)		; $6f8d
	ld l,SpecialObject.counter1		; $6f8e
	ld (hl),$78		; $6f90
	ret			; $6f92

@substate4:
	call specialObjectAnimate		; $6f93
	call itemDecCounter1		; $6f96
	ret nz			; $6f99
	ld l,SpecialObject.state2		; $6f9a
	inc (hl)		; $6f9c
	ld l,SpecialObject.counter1		; $6f9d
	ld (hl),$3c		; $6f9f
	ld l,SpecialObject.angle		; $6fa1
	ld (hl),$0b		; $6fa3
	ld l,SpecialObject.speed		; $6fa5
	ld (hl),SPEED_80		; $6fa7
	ret			; $6fa9

@substate5:
	call itemDecCounter1		; $6faa
	ret nz			; $6fad
	ld l,SpecialObject.state2		; $6fae
	inc (hl)		; $6fb0
	ld a,$26		; $6fb1
	jp specialObjectSetAnimation		; $6fb3

@substate6:
	call specialObjectAnimate		; $6fb6
	call objectApplySpeed		; $6fb9
	ld e,SpecialObject.xh		; $6fbc
	ld a,(de)		; $6fbe
	cp $78			; $6fbf
	jr nz,+			; $6fc1
	ld a,$05		; $6fc3
	jp specialObjectSetAnimation		; $6fc5
+
	cp $b0			; $6fc8
	ret c			; $6fca

	ld hl,w1Companion.id		; $6fcb
	ld b,$3f		; $6fce
	call clearMemory		; $6fd0
	ld hl,w1Companion.id		; $6fd3
	ld (hl),SPECIALOBJECTID_RICKY_CUTSCENE		; $6fd6
	inc l			; $6fd8
	ld (hl),$01		; $6fd9
	ld l,SpecialObject.yh		; $6fdb
	ld (hl),$48		; $6fdd
	inc l			; $6fdf
	inc l			; $6fe0
	ld (hl),$d8		; $6fe1
	ret			; $6fe3

;;
; @addr{6fe4}
_specialObjectCode_mapleCutscene:
	ld e,SpecialObject.state		; $6fe4
	ld a,(de)		; $6fe6
	rst_jumpTable			; $6fe7
	.dw @state0
	.dw @state1

@state0:
	call _companionCutsceneInitOam		; $6fec
	ld h,d			; $6fef
	ld l,SpecialObject.zh		; $6ff0
	ld (hl),$f0		; $6ff2
	ld l,SpecialObject.angle		; $6ff4
	ld (hl),$08		; $6ff6
	ld l,SpecialObject.counter1		; $6ff8
	ld (hl),$5a		; $6ffa
	ret			; $6ffc

@initPositionSpeedAnimation:
	ld l,SpecialObject.counter2		; $6ffd
	ld a,(hl)		; $6fff
	add a			; $7000
	ld hl,@@data		; $7001
	rst_addDoubleIndex			; $7004
	ldi a,(hl)		; $7005
	ld e,SpecialObject.speed		; $7006
	ld (de),a		; $7008
	ldi a,(hl)		; $7009
	ld e,SpecialObject.counter1		; $700a
	ld (de),a		; $700c
	ldi a,(hl)		; $700d
	ld e,SpecialObject.yh		; $700e
	ld (de),a		; $7010
	ld a,(hl)		; $7011
	jp specialObjectSetAnimation		; $7012


; b0: speed
; b1: counter1
; b2: yh
; b3: animation
@@data:
	.db SPEED_200 $60 $78 $05
	.db SPEED_1c0 $6e $70 $07
	.db SPEED_180 $7d $68 $05
	.db SPEED_040 $e6 $2c $05


@state1:
	call specialObjectAnimate		; $7025
	call objectOscillateZ		; $7028
	ld e,SpecialObject.state2		; $702b
	ld a,(de)		; $702d
	rst_jumpTable			; $702e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,(wPaletteThread_mode)		; $7037
	or a			; $703a
	call z,itemDecCounter1		; $703b
	ret nz			; $703e
	call itemIncState2		; $703f
	jr @initPositionSpeedAnimation		; $7042

@substate1:
	call itemDecCounter1		; $7044
	jp nz,objectApplySpeed		; $7047
	ld (hl),$5a		; $704a
	inc l			; $704c
	inc (hl)		; $704d
	jp itemIncState2		; $704e

@substate2:
	call itemDecCounter1		; $7051
	ret nz			; $7054

	; Check counter2
	inc l			; $7055
	ld a,(hl)		; $7056
	cp $04			; $7057
	jr nz,++		; $7059

	; Set counter1
	dec l			; $705b
	ld (hl),$1e		; $705c

	call itemIncState2		; $705e
	ld a,$07		; $7061
	jp specialObjectSetAnimation		; $7063
++
	ld l,SpecialObject.state2		; $7066
	dec (hl)		; $7068
	ld l,SpecialObject.angle		; $7069
	ld a,(hl)		; $706b
	xor $10			; $706c
	ld (hl),a		; $706e
	jr @initPositionSpeedAnimation		; $706f

@substate3:
	call itemDecCounter1		; $7071
	jr z,+			; $7074
	ld c,$02		; $7076
	jp objectUpdateSpeedZ_paramC		; $7078
+
	ld a,$ff		; $707b
	ld ($cfdf),a		; $707d
	ret			; $7080

;;
; @param	a	Angle
; @addr{7081}
_companionCutsceneFunc_7081:
	sub $04			; $7081
	and $07			; $7083
	ret nz			; $7085
	ld e,SpecialObject.angle		; $7086
	call convertAngleDeToDirection		; $7088
	dec a			; $708b
	and $03			; $708c
	ld h,d			; $708e
	ld l,SpecialObject.direction		; $708f
	ld (hl),a		; $7091
	ld l,SpecialObject.var36		; $7092
	add (hl)		; $7094
	jp specialObjectSetAnimation		; $7095

;;
; @addr{7098}
_companionCutsceneDecAngle:
	ld e,SpecialObject.angle		; $7098
	ld a,(de)		; $709a
	dec a			; $709b
	and $1f			; $709c
	ld (de),a		; $709e
	ret			; $709f
