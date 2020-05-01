specialObjectCode_linkInCutscene:
	ld e,SpecialObject.subid		; $6dec
	ld a,(de)		; $6dee
	rst_jumpTable			; $6def
	.dw _linkCutscene0
	.dw _linkCutscene1
	.dw _linkCutscene2
	.dw _linkCutscene3
	.dw _linkCutscene4
	.dw _linkCutscene5
	.dw _linkCutscene6
	.dw _linkCutscene7
	.dw _linkCutscene8
	.dw _linkCutscene9
	.dw _linkCutsceneA

;;
; Opening cutscene with the triforce
; @addr{70be}
_linkCutscene0:
	ld e,Item.state		; $70be
	ld a,(de)		; $70c0
	rst_jumpTable			; $70c1
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $70c6
	call objectSetVisible81		; $70c9
	xor a			; $70cc
	call specialObjectSetAnimation		; $70cd

@state1:
	ld e,SpecialObject.state2		; $70d0
	ld a,(de)		; $70d2
	rst_jumpTable			; $70d3
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw _linkCutscene0_substate6

@substate0:
	ld a,(wLinkAngle)		; $70e2
	rlca			; $70e5
	ld a,$00		; $70e6
	jp c,specialObjectSetAnimation		; $70e8

	ld h,d			; $70eb
	ld l,SpecialObject.yh		; $70ec
	ld a,(wGameKeysPressed)		; $70ee
	bit BTN_BIT_DOWN,a			; $70f1
	jr z,+			; $70f3
	inc (hl)		; $70f5
+
	bit BTN_BIT_UP,a			; $70f6
	jr z,+			; $70f8
	dec (hl)		; $70fa
+
	ld a,(hl)		; $70fb
	cp $40			; $70fc
	jp nc,specialObjectAnimate		; $70fe
	ld a,$01		; $7101
	ld (wTmpcbb9),a		; $7103
	ld a,SND_DROPESSENCE		; $7106
	call playSound		; $7108
	jp itemIncState2		; $710b

@substate1:
	ld a,(wTmpcbb9)		; $710e
	cp $02			; $7111
	ret nz			; $7113

	call itemIncState2		; $7114
	ld b,$04		; $7117
	call func_2d48		; $7119
	ld a,b			; $711c
	ld e,SpecialObject.counter1		; $711d
	ld (de),a		; $711f
	ld a,$04		; $7120
	jp specialObjectSetAnimation		; $7122

@substate2:
	call itemDecCounter1		; $7125
	jp nz,specialObjectAnimate		; $7128

	ld l,SpecialObject.speed		; $712b
	ld (hl),SPEED_20		; $712d
	ld b,$05		; $712f
	call func_2d48		; $7131
	ld a,b			; $7134
	ld e,SpecialObject.counter1		; $7135
	ld (de),a		; $7137
	jp itemIncState2		; $7138

@substate3:
	call itemDecCounter1		; $713b
	jp nz,++		; $713e

	call itemIncState2		; $7141
	ld b,$07		; $7144
	call func_2d48		; $7146
	ld a,b			; $7149
	ld e,SpecialObject.counter1		; $714a
	ld (de),a		; $714c
++
	ld hl,_linkCutscene_zOscillation0		; $714d
.ifdef ROM_AGES
	jr _linkCutscene_oscillateZ		; $7150
.else
	jp _linkCutscene_oscillateZ
.endif

@substate4:
	call itemDecCounter1		; $7152
	jp nz,_linkCutscene_oscillateZ_1		; $7155
	ld a,$03		; $7158
	ld (wTmpcbb9),a		; $715a
	call itemIncState2		; $715d

@substate5:
	ld a,(wTmpcbb9)		; $7160
	cp $06			; $7163
	jr nz,_linkCutscene_oscillateZ_1	; $7165

;;
; Creates the colored orb that appears under Link in the opening cutscene
; @addr{7167}
_linkCutscene_createGlowingOrb:
	ldbc INTERACID_SPARKLE, $06		; $7167
	call objectCreateInteraction		; $716a
	jr nz,+			; $716d
	ld l,Interaction.relatedObj1		; $716f
	ld a,SpecialObject.start		; $7171
	ldi (hl),a		; $7173
	ld (hl),d		; $7174
+
	call itemIncState2		; $7175
	ld a,$05		; $7178
	jp specialObjectSetAnimation		; $717a

;;
; @addr{717d}
_linkCutscene_oscillateZ_1:
	ld hl,_linkCutscene_zOscillation1		; $717d

;;
; @addr{7180}
_linkCutscene_oscillateZ:
	ld a,($cbb7)		; $7180
.ifdef ROM_SEASONS
	ld b,a			; $6ecc
	and $07			; $6ecd
	jr nz,++		; $6ecf

	ld a,b			; $6ed1
.else
	and $07			; $7183
	jr nz,++		; $7185

	ld a,($cbb7)		; $7187
.endif
	and $38			; $718a
	swap a			; $718c
	rlca			; $718e
	rst_addAToHl			; $718f
	ld e,SpecialObject.zh		; $7190
.ifdef ROM_AGES
	ld a,(hl)		; $7192
	ld b,a			; $7193
	ld a,(de)		; $7194
	add b			; $7195
.else
	ld a,(de)		; $6eda
	add (hl)		; $6edb
.endif
	ld (de),a		; $7196
++
	jp specialObjectAnimate		; $7197

_linkCutscene_zOscillation0:
	.db $ff $fe $fe $ff $00 $01 $01 $00

_linkCutscene_zOscillation1:
	.db $ff $ff $ff $00 $01 $01 $01 $00

_linkCutscene_zOscillation2:
	.db $02 $03 $04 $03 $02 $00 $ff $00


_linkCutscene0_substate6:
	ld e,SpecialObject.animParameter		; $71b2
	ld a,(de)		; $71b4
	inc a			; $71b5
	jr nz,+			; $71b6
	ld a,$07		; $71b8
	ld (wTmpcbb9),a		; $71ba
	ret			; $71bd
+
	call specialObjectAnimate		; $71be
	ld a,($cbb7)		; $71c1
	rrca			; $71c4
	jp nc,objectSetInvisible		; $71c5
	jp objectSetVisible		; $71c8


; Dancing with Din
_linkCutscene1:
	ld e,Item.state		; $6f11
	ld a,(de)		; $6f13
	rst_jumpTable			; $6f14
	.dw @state0
	.dw @state1

@state0:
	jp _linkCutscene_initOam_setVisible_incState		; $6f19

@state1:
	ld e,Item.state2		; $6f1c
	ld a,(de)		; $6f1e
	rst_jumpTable			; $6f1f
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
	.dw @substateB
	.dw @substateC
	.dw @substateD
	.dw @substateE
	.dw @substateF
	.dw @substate10
	.dw @substate11
	.dw @substate12
	.dw @substate13
	.dw @substate14
	.dw @ret

@substate0:
	ld a,($cfd0)		; $6f4c
	or a			; $6f4f
	ret nz			; $6f50

	call itemIncState2		; $6f51
	ld l,Item.counter1		; $6f54
	ld (hl),$aa		; $6f56

	ld l,Item.yh		; $6f58
	ld a,$30		; $6f5a
	ldi (hl),a		; $6f5c
	; xh
	inc l			; $6f5d
	ld a,$50		; $6f5e
	ld (hl),a		; $6f60

	ld l,Item.relatedObj2+1		; $6f61
	ld h,(hl)		; $6f63
	ld l,Interaction.yh		; $6f64
	ld a,$30		; $6f66
	ldi (hl),a		; $6f68
	; xh
	inc l			; $6f69
	ld a,$60		; $6f6a
	ld (hl),a		; $6f6c

	ld e,Item.direction		; $6f6d
	xor a			; $6f6f
	ld (de),a		; $6f70

@seasonsFunc_06_6f71:
	ld a,$07		; $6f71
	call specialObjectSetAnimation		; $6f73
	ld a,$08		; $6f76
	jp setRelatedObj2Animation		; $6f78

@substate1:
	call itemDecCounter1		; $6f7b
	jr nz,@animateSelfAndRelatedObj2	; $6f7e
	ld (hl),$1e		; $6f80
	call itemIncState2		; $6f82
	jr @seasonsFunc_06_6f71			; $6f85

@animateSelfAndRelatedObj2:
	call specialObjectAnimate		; $6f87
	jp animateRelatedObj2		; $6f8a

@substate2:
	call itemDecCounter1		; $6f8d
	ret nz			; $6f90
	ld (hl),$28		; $6f91
	ld a,$10		; $6f93
	call specialObjectSetAnimation		; $6f95
	ld a,$0d		; $6f98
	call setRelatedObj2Animation		; $6f9a
	jp itemIncState2		; $6f9d

@substate3:
	call itemDecCounter1		; $6fa0
	ret nz			; $6fa3
	ld (hl),$3c		; $6fa4
	call itemIncState2		; $6fa6
	ld bc,TX_0c17		; $6fa9
	call checkIsLinkedGame		; $6fac
	jr z,+			; $6faf
	ld c,<TX_0c18		; $6fb1
+
	jp showText		; $6fb3

@substate4:
	ld a,(wTextIsActive)		; $6fb6
	or a			; $6fb9
	ret nz			; $6fba
	call itemDecCounter1		; $6fbb
	ret nz			; $6fbe
	ld (hl),$96		; $6fbf
	call @seasonsFunc_06_6f71		; $6fc1
	jp itemIncState2		; $6fc4

@substate5:
	call itemDecCounter1		; $6fc7
	jr nz,@animateSelfAndRelatedObj2	; $6fca
	ld a,$02		; $6fcc
	ld ($cfd0),a		; $6fce
	jp itemIncState2		; $6fd1

@substate6:
	ld a,($cfd0)		; $6fd4
	cp $03			; $6fd7
	jr nz,@animateSelfAndRelatedObj2	; $6fd9
	call @seasonsFunc_06_6f71		; $6fdb
	jp itemIncState2		; $6fde

@substate7:
	ld a,($cfd0)		; $6fe1
	cp $04			; $6fe4
	ret nz			; $6fe6
	call itemIncState2		; $6fe7
	ld l,Item.counter1		; $6fea
	ld (hl),$5a		; $6fec
	ld l,Item.direction		; $6fee
	ld (hl),DIR_LEFT		; $6ff0
	xor a			; $6ff2
	jp specialObjectSetAnimation		; $6ff3

@substate8:
	call itemDecCounter1		; $6ff6
	ret nz			; $6ff9
	ld (hl),$12		; $6ffa
	jp itemIncState2		; $6ffc

@substate9:
	call itemDecCounter1		; $6fff
	jr nz,+			; $7002
	ld (hl),$46		; $7004
	xor a			; $7006
	call specialObjectSetAnimation		; $7007
	jp itemIncState2		; $700a
+
	ld l,Item.xh		; $700d
	dec (hl)		; $700f
	jp specialObjectAnimate		; $7010

@substateA:
	call itemDecCounter1		; $7013
	ret nz			; $7016
	ld hl,$cfd0		; $7017
	ld (hl),$05		; $701a
	jp itemIncState2		; $701c

@substateB:
	ld hl,$cfd1		; $701f
	bit 6,(hl)		; $7022
	ret z			; $7024
@seasonsFunc_06_7025:
	ld a,$14		; $7025
	ld e,SpecialObject.counter1		; $7027
	ld (de),a		; $7029
	ld e,Item.xh		; $702a
	ld a,(de)		; $702c
	dec e			; $702d
	ld (de),a		; $702e
	jp itemIncState2		; $702f

@substateC:
	call itemDecCounter1		; $7032
	jr nz,@seasonsFunc_06_7052			; $7035
	ld h,d			; $7037
	ld l,Item.speed		; $7038
	ld (hl),SPEED_200		; $703a
	ld l,Item.angle		; $703c
	ld (hl),$0e		; $703e
	ld l,Item.xh		; $7040
	ld (hl),$40		; $7042
	ld a,$08		; $7044
	call specialObjectSetAnimation		; $7046
	ld bc,-$180		; $7049
	call objectSetSpeedZ		; $704c
	jp itemIncState2		; $704f

@seasonsFunc_06_7052:
	call getRandomNumber		; $7052
	and $0f			; $7055
	sub $08			; $7057
	ld b,a			; $7059
	ld e,$0c		; $705a
	ld a,(de)		; $705c
	inc e			; $705d
	add b			; $705e
	ld (de),a		; $705f

@ret:
	ret			; $7060

@substateD:
	call objectApplySpeed		; $7061
	ld c,$20		; $7064
	call objectUpdateSpeedZ_paramC		; $7066
	ret nz			; $7069
	call itemIncState2		; $706a
	ld l,Item.counter1		; $706d
	ld (hl),$28		; $706f
	ld a,$14		; $7071
	jp specialObjectSetAnimation		; $7073

@substateE:
	call itemDecCounter1		; $7076
	ret nz			; $7079
	ld a,$07		; $707a
	ld ($cfd0),a		; $707c
	jp itemIncState2		; $707f

@substateF:
	ld a,($cfd0)		; $7082
	cp $09			; $7085
	ret nz			; $7087
	call itemIncState2		; $7088
	ld l,Item.speedZ		; $708b
	ld (hl),$f0		; $708d
	inc l			; $708f
	ld (hl),$fd		; $7090
	; direction
	ld l,$08		; $7092
	ld (hl),DIR_DOWN		; $7094
	ld a,$0a		; $7096
	call specialObjectSetAnimation		; $7098
	ld a,SND_JUMP		; $709b
	jp playSound		; $709d

@substate10:
	call specialObjectAnimate		; $70a0
	ld c,$20		; $70a3
	call objectUpdateSpeedZ_paramC		; $70a5
	ret nz			; $70a8
	call itemIncState2		; $70a9
	ld l,Item.counter1		; $70ac
	ld (hl),$1e		; $70ae
	xor a			; $70b0
	ld l,Item.direction		; $70b1
	ld (hl),a		; $70b3
	jp specialObjectSetAnimation		; $70b4

@substate11:
	call itemDecCounter1		; $70b7
	ret nz			; $70ba
	ld (hl),$19		; $70bb
	ld l,Item.speed		; $70bd
	ld (hl),SPEED_200		; $70bf
	ld l,Item.angle		; $70c1
	ld (hl),$02		; $70c3
	jp itemIncState2		; $70c5

@substate12:
	call specialObjectAnimate		; $70c8
	call objectApplySpeed		; $70cb
	call itemDecCounter1		; $70ce
	ret nz			; $70d1
	jp @seasonsFunc_06_7025		; $70d2

@substate13:
	call itemDecCounter1		; $70d5
	jp nz,@seasonsFunc_06_7052		; $70d8
	ld e,Item.speed		; $70db
	ld a,SPEED_300		; $70dd
	ld (de),a		; $70df
	ld e,Item.angle		; $70e0
	ld a,$19		; $70e2
	ld (de),a		; $70e4
	ld e,Item.direction		; $70e5
	xor a			; $70e7
	ld (de),a		; $70e8
	ld (wScrollMode),a		; $70e9
	ld a,$08		; $70ec
	call specialObjectSetAnimation		; $70ee
	jp itemIncState2		; $70f1

@substate14:
	call specialObjectAnimate		; $70f4
	call objectApplySpeed		; $70f7
	call objectApplySpeed		; $70fa
	call objectCheckWithinScreenBoundary		; $70fd
	ret c			; $7100
	ld a,$0a		; $7101
	ld ($cfd0),a		; $7103
	jp itemIncState2		; $7106


_linkCutscene2:
	ld e,SpecialObject.state		; $7109
	ld a,(de)		; $710b
	rst_jumpTable			; $710c
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7111
	ld a,$09		; $7114
	call specialObjectSetAnimation		; $7116

@state1:
	ld e,SpecialObject.state2		; $7119
	ld a,(de)		; $711b
	rst_jumpTable			; $711c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld hl,$cfd0		; $7125
	ld a,(hl)		; $7128
	cp $01			; $7129
	ret nz			; $712b
	call specialObjectAnimate		; $712c
	ld e,Item.animParameter		; $712f
	ld a,(de)		; $7131
	inc a			; $7132
	ret nz			; $7133
	call itemIncState2		; $7134
	ld l,Item.speedZ		; $7137
	ld (hl),$f0		; $7139
	inc l			; $713b
	ld (hl),$fd		; $713c
	ld l,Item.direction		; $713e
	ld (hl),DIR_DOWN		; $7140
	ld a,$0a		; $7142
	call specialObjectSetAnimation		; $7144
	ld a,SND_JUMP		; $7147
	call playSound		; $7149

@substate1:
	call seasonsFunc_06_7178		; $714c
	ret nz			; $714f
	call itemIncState2		; $7150
	ld l,Item.counter1		; $7153
	ld (hl),$1e		; $7155
	ret			; $7157

@substate2:
	call itemDecCounter1		; $7158
	ret nz			; $715b
	ld hl,$cfd0		; $715c
	ld (hl),$02		; $715f
	call itemIncState2		; $7161
	ld l,Item.direction		; $7164
	ld (hl),DIR_LEFT		; $7166
	ld a,$00		; $7168
	jp specialObjectSetAnimation		; $716a

@substate3:
	ld a,($cfd0)		; $716d
	cp $03			; $7170
	ret nz			; $7172
	ld a,$00		; $7173
	jp setLinkIDOverride		; $7175

seasonsFunc_06_7178:
	call specialObjectAnimate		; $7178
	ld c,$20		; $717b
	call objectUpdateSpeedZ_paramC		; $717d
	jr z,+			; $7180
	ld h,d			; $7182
	ld l,Item.speedZ+1		; $7183
	ld a,(hl)		; $7185
	bit 7,a			; $7186
	ret nz			; $7188
	cp $03			; $7189
	ret c			; $718b
	ld l,Item.speedZ		; $718c
	xor a			; $718e
	ldi (hl),a		; $718f
	ld a,$03		; $7190
	ld (hl),a		; $7192
	or a			; $7193
	ret			; $7194
+
	ld a,$00		; $7195
	jp specialObjectSetAnimation		; $7197

animateRelatedObj2:
	push de			; $719a
	ld e,Item.relatedObj2+1		; $719b
	ld a,(de)		; $719d
	ld d,a			; $719e
	call interactionAnimate		; $719f
	pop de			; $71a2
	ret			; $71a3

; @param	a	animation
setRelatedObj2Animation:
	ld b,a			; $71a4
	push de			; $71a5
	ld e,Item.relatedObj2+1		; $71a6
	ld a,(de)		; $71a8
	ld d,a			; $71a9
	ld a,b			; $71aa
	call interactionSetAnimation		; $71ab
	pop de			; $71ae
	ret			; $71af


_linkCutscene3:
	ld e,SpecialObject.state		; $71b0
	ld a,(de)		; $71b2
	rst_jumpTable			; $71b3
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $71b8
	ld l,Item.counter1		; $71bb
	ld (hl),$a8		; $71bd
	ld a,$0c		; $71bf
	jp specialObjectSetAnimation		; $71c1

@state1:
	ld e,SpecialObject.state2		; $71c4
	ld a,(de)		; $71c6
	rst_jumpTable			; $71c7
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call itemDecCounter1		; $71d0
	jr nz,+			; $71d3
	ld a,$80		; $71d5
	ld ($cfc0),a		; $71d7
	call itemIncState2		; $71da
	ld bc,-$100		; $71dd
	call objectSetSpeedZ		; $71e0
+
	jp specialObjectAnimate		; $71e3

@substate1:
	ld c,$20		; $71e6
	call objectUpdateSpeedZ_paramC		; $71e8
	ret nz			; $71eb
	call itemIncState2		; $71ec
	ld l,Item.counter1		; $71ef
	ld (hl),$0a		; $71f1
	ret			; $71f3

@substate2:
	call itemDecCounter1		; $71f4
	ret nz			; $71f7
	ld (hl),$78		; $71f8
	call itemIncState2		; $71fa
	ld a,$0c		; $71fd
	jp specialObjectSetAnimation		; $71ff

@substate3:
	call itemDecCounter1		; $7202
	ret nz			; $7205
	ld a,$01		; $7206
	ld ($cfdf),a		; $7208
	ret			; $720b


_linkCutscene4:
	ld e,SpecialObject.state		; $720c
	ld a,(de)		; $720e
	rst_jumpTable			; $720f
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7214
	ld l,Item.angle		; $7217
	ld (hl),ANGLE_UP		; $7219
	ld l,Item.speed		; $721b
	ld (hl),SPEED_100		; $721d
	ld l,Item.counter1		; $721f
	ld (hl),$80		; $7221
	ld a,$00		; $7223
	jp specialObjectSetAnimation		; $7225

@state1:
	ld e,SpecialObject.state2		; $7228
	ld a,(de)		; $722a
	rst_jumpTable			; $722b
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld a,(wPaletteThread_mode)		; $7238
	or a			; $723b
	ret nz			; $723c
	call specialObjectAnimate		; $723d
	call objectApplySpeed		; $7240
	call itemDecCounter1		; $7243
	ret nz			; $7246
	ld (hl),$06		; $7247
	jp itemIncState2		; $7249

@substate1:
	call itemDecCounter1		; $724c
	ret nz			; $724f
	ld (hl),$78		; $7250
	call itemIncState2		; $7252
	ld a,$03		; $7255
	jp specialObjectSetAnimation		; $7257

@substate2:
	call itemDecCounter1		; $725a
	ret nz			; $725d
	ld hl,$cfc0		; $725e
	ld (hl),$01		; $7261
	jp itemIncState2		; $7263

@substate3:
	ld a,($cfc0)		; $7266
	cp $02			; $7269
	ret nz			; $726b
	call itemIncState2		; $726c
	ld l,Item.angle		; $726f
	ld (hl),ANGLE_DOWN		; $7271
	ld bc,-$100		; $7273
	call objectSetSpeedZ		; $7276
	ld a,$0d		; $7279
	jp specialObjectSetAnimation		; $727b

@substate4:
	call objectApplySpeed		; $727e
	ld c,$20		; $7281
	call objectUpdateSpeedZ_paramC		; $7283
	ret nz			; $7286
	call itemIncState2		; $7287
	ld l,Item.counter1		; $728a
	ld (hl),$78		; $728c
	ld l,Item.animCounter		; $728e
	ld (hl),$01		; $7290
	ret			; $7292

@substate5:
	call itemDecCounter1		; $7293
	jp nz,specialObjectAnimate		; $7296
	ld hl,$cfdf		; $7299
	ld (hl),$01		; $729c
	ret			; $729e


; Sokra?
_linkCutscene5:
	ld e,SpecialObject.state		; $729f
	ld a,(de)		; $72a1
	rst_jumpTable			; $72a2
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $72a7
	ld l,Item.counter1		; $72aa
	ld (hl),$f0		; $72ac
	ld a,$03		; $72ae
	jp specialObjectSetAnimation		; $72b0

@state1:
	ld e,SpecialObject.state2		; $72b3
	ld a,(de)		; $72b5
	rst_jumpTable			; $72b6
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,(wPaletteThread_mode)		; $72bb
	or a			; $72be
	ret nz			; $72bf
	call itemDecCounter1		; $72c0
	ret nz			; $72c3
	ld l,Item.counter1		; $72c4
	ld (hl),$3c		; $72c6
	call itemIncState2		; $72c8
	ld hl,$cfc0		; $72cb
	ld (hl),$01		; $72ce
@seasonsFunc_06_72d0:
	ld bc,$f804		; $72d0
	ld a,$ff		; $72d3
	call objectCreateExclamationMark		; $72d5
	ld l,Interaction.subid		; $72d8
	ld (hl),$01		; $72da
	ld a,$0e		; $72dc
	jp specialObjectSetAnimation		; $72de

@substate1:
	call itemDecCounter1		; $72e1
	ret nz			; $72e4
	ld hl,$cfdf		; $72e5
	ld (hl),$01		; $72e8

@ret:
	ret			; $72ea


;;
; Link being kissed by Zelda in ending cutscene - cutsceneA in ages
;
; @addr{75e0}
_linkCutscene6:
	ld e,SpecialObject.state		; $75e0
	ld a,(de)		; $75e2
	rst_jumpTable			; $75e3
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $75e8
	call objectSetInvisible		; $75eb

	call @checkShieldEquipped		; $75ee
	ld a,$0b		; $75f1
	jr nz,+			; $75f3
	ld a,$0f		; $75f5
+
	jp specialObjectSetAnimation		; $75f7

;;
; @param[out]	zflag	Set if shield equipped
; @addr{75fa}
@checkShieldEquipped:
	ld hl,wInventoryB		; $75fa
	ld a,ITEMID_SHIELD		; $75fd
	cp (hl)			; $75ff
	ret z			; $7600
	inc l			; $7601
	cp (hl)			; $7602
	ret			; $7603

@state1:
	ld e,SpecialObject.state2		; $7604
	ld a,(de)		; $7606
	rst_jumpTable			; $7607
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	ld a,($cfc0)		; $7610
	cp $01			; $7613
	ret nz			; $7615

	call itemIncState2		; $7616
.ifdef ROM_AGES
	jp objectSetVisible82		; $7619
.else
	jp objectSetVisible		; $7619
.endif

@substate1:
	ld a,($cfc0)		; $761c
	cp $07			; $761f
	ret nz			; $7621

	call itemIncState2		; $7622
	call @checkShieldEquipped		; $7625
	ld a,$10		; $7628
	jr nz,+			; $762a
	inc a			; $762c
+
	jp specialObjectSetAnimation		; $762d

@substate2:
	ld a,($cfc0)		; $7630
	cp $08			; $7633
	ret nz			; $7635

	call itemIncState2		; $7636
	ld l,SpecialObject.counter1		; $7639
	ld (hl),$68		; $763b
	inc l			; $763d
	ld (hl),$01		; $763e
	ld b,$02		; $7640
--
	call getFreeInteractionSlot		; $7642
	jr nz,@@setAnimation	; $7645
	ld (hl),INTERACID_KISS_HEART		; $7647
	inc l			; $7649
	ld a,b			; $764a
	dec a			; $764b
	ld (hl),a		; $764c
	call objectCopyPosition		; $764d
	dec b			; $7650
	jr nz,--		; $7651

@@setAnimation:
	ld a,$12		; $7653
	jp specialObjectSetAnimation		; $7655

@substate3:
	call specialObjectAnimate		; $7658
	ld h,d			; $765b
	ld l,SpecialObject.counter1		; $765c
	call decHlRef16WithCap		; $765e
	ret nz			; $7661

	ld hl,$cfc0		; $7662
	ld (hl),$09		; $7665
	ret			; $7667


; Sokra?
_linkCutscene7:
	ld e,SpecialObject.state		; $7373
	ld a,(de)		; $7375
	rst_jumpTable			; $7376
	.dw @state0		; $7377
	.dw _linkCutscene5@ret		; $7379

@state0:
	call _linkCutscene_initOam_setVisible_incState			; $737b
	jp _linkCutscene5@seasonsFunc_06_72d0		; $737e

_linkCutscene_initOam_setVisible_incState:
	callab bank5.specialObjectSetOamVariables	; $7381
	call objectSetVisiblec1		; $7389
	jp itemIncState		; $738c


_linkCutscene8:
	ld e,SpecialObject.state		; $738f
	ld a,(de)		; $7391
	rst_jumpTable			; $7392
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7397
	ld l,Item.speed		; $739a
	ld (hl),SPEED_100		; $739c
	ld a,$00		; $739e
	call specialObjectSetAnimation		; $73a0

@state1:
	call specialObjectAnimate		; $73a3
	call angleToY48X50		; $73a6
	call moveToAngleSnapToGrid		; $73a9
	call checkCloseToY48X50		; $73ac
	ret nc			; $73af
	ld a,$00		; $73b0
	jp setLinkIDOverride		; $73b2


_linkCutscene9:
	ld e,SpecialObject.state		; $73b5
	ld a,(de)		; $73b7
	rst_jumpTable			; $73b8
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $73bd
	push de			; $73c0
	call clearItems		; $73c1
	pop de			; $73c4
	ld a,$13		; $73c5
	jp specialObjectSetAnimation		; $73c7

@state1:
	ld e,SpecialObject.state2		; $73ca
	ld a,(de)		; $73cc
	rst_jumpTable			; $73cd
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @ret

@substate0:
	ld a,($cfd1)		; $73dc
	or a			; $73df
	ret z			; $73e0
	call itemIncState2		; $73e1
	ld l,Item.counter1		; $73e4
	ld (hl),$28		; $73e6
	ld l,Item.speed		; $73e8
	ld (hl),SPEED_20		; $73ea
	ld l,Item.angle		; $73ec
	ld (hl),ANGLE_DOWN		; $73ee
	ret			; $73f0

@substate1:
	call itemDecCounter1		; $73f1
	jp nz,objectApplySpeed		; $73f4
	ld (hl),$19		; $73f7
	jp itemIncState2		; $73f9

@substate2:
	call itemDecCounter1		; $73fc
	ret nz			; $73ff
	call itemIncState2		; $7400
	ld l,Item.speed		; $7403
	ld (hl),SPEED_300		; $7405
	ld l,Item.angle		; $7407
	xor a			; $7409
	ld (hl),a		; $740a
	ld l,Item.zh		; $740b
	ld (hl),$fa		; $740d
@animate:
	ld l,Item.animCounter		; $740f
	ld (hl),$01		; $7411
	jp specialObjectAnimate		; $7413

@substate3:
	call objectApplySpeed		; $7416
	ld e,Item.yh		; $7419
	ld a,(de)		; $741b
	cp $10			; $741c
	ret nc			; $741e
	ld a,SND_ROLLER		; $741f
	call playSound		; $7421
	call itemIncState2		; $7424
	ld l,Item.counter1		; $7427
	ld (hl),$1e		; $7429
	jr @animate		; $742b

@substate4:
	call itemDecCounter1		; $742d
	jr nz,+	; $7430
	call itemIncState2		; $7432
	ld bc,-$c0		; $7435
	jp objectSetSpeedZ		; $7438

@substate5:
	ld c,$10		; $743b
	call objectUpdateSpeedZ_paramC		; $743d
	ret nz			; $7440
	call itemIncState2		; $7441
	jr @animate		; $7444
+
	ld a,(wFrameCounter)		; $7446
	and $03			; $7449
	ret nz			; $744b
	ld a,$04		; $744c
	ld (wScreenShakeCounterY),a		; $744e

@ret:
	ret			; $7451


;;
; Cutscene played on starting a new game ("accept our quest, hero") - cutsceneA in ages
;
; @addr{7668}
_linkCutsceneA:
	ld e,SpecialObject.state		; $7668
	ld a,(de)		; $766a
	rst_jumpTable			; $766b
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7670
	call objectSetVisible81		; $7673

	ld l,SpecialObject.counter1		; $7676
	ld (hl),$2c		; $7678
	inc hl			; $767a
	ld (hl),$01		; $767b
	ld l,SpecialObject.yh		; $767d
	ld (hl),$d0		; $767f
	ld l,SpecialObject.xh		; $7681
	ld (hl),$50		; $7683

	ld a,$08		; $7685
	call specialObjectSetAnimation		; $7687
	xor a			; $768a
	ld (wTmpcbb9),a		; $768b

.ifdef ROM_AGES
	ldbc INTERACID_SPARKLE, $0d		; $768e
.else
	ldbc INTERACID_SPARKLE, $09		; $768e
.endif
	call objectCreateInteraction		; $7691
	jr nz,@state1	; $7694
	ld l,Interaction.relatedObj1		; $7696
	ld a,SpecialObject.start		; $7698
	ldi (hl),a		; $769a
	ld (hl),d		; $769b

@state1:
	ld a,(wFrameCounter)		; $769c
	ld ($cbb7),a		; $769f
	ld e,SpecialObject.state2		; $76a2
	ld a,(de)		; $76a4
	rst_jumpTable			; $76a5
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3

@substate0:
	call _linkCutscene_oscillateZ_2		; $76ae
	ld hl,w1Link.counter1		; $76b1
	call decHlRef16WithCap		; $76b4
	ret nz			; $76b7

	ld (hl),$3c		; $76b8
	jp itemIncState2		; $76ba

@substate1:
	call _linkCutscene_oscillateZ_2		; $76bd
	call itemDecCounter1		; $76c0
	ret nz			; $76c3

	call itemIncState2		; $76c4
.ifdef ROM_AGES
	ld bc,TX_1213		; $76c7
.else
	ld bc,TX_0c16		; $76c7
.endif
	jp showText		; $76ca

@substate2:
	ld hl,_linkCutscene_zOscillation1		; $76cd
	call _linkCutscene_oscillateZ		; $76d0
	ld a,(wTextIsActive)		; $76d3
	or a			; $76d6
	ret nz			; $76d7

	ld a,$06		; $76d8
	ld (wTmpcbb9),a		; $76da
	ld a,SND_FAIRYCUTSCENE		; $76dd
	call playSound		; $76df
	jp _linkCutscene_createGlowingOrb		; $76e2

@substate3:
	ld e,SpecialObject.animParameter		; $76e5
	ld a,(de)		; $76e7
	inc a			; $76e8
	jr nz,+			; $76e9
	ld a,$07		; $76eb
	ld (wTmpcbb9),a		; $76ed
	ret			; $76f0
+
	call specialObjectAnimate		; $76f1
	ld a,(wFrameCounter)		; $76f4
	rrca			; $76f7
	jp nc,objectSetInvisible		; $76f8
	jp objectSetVisible		; $76fb


_linkCutscene_oscillateZ_2:
	ld hl,_linkCutscene_zOscillation2		; $74e8
	jp _linkCutscene_oscillateZ		; $74eb


angleToY48X50:
	ld e,Item.var03		; $74ee
	ld a,(de)		; $74f0
	ld hl,checkCloseToY48X50@destination		; $74f1
	rst_addDoubleIndex			; $74f4
	ld b,(hl)		; $74f5
	inc hl			; $74f6
	ld c,(hl)		; $74f7
	call objectGetRelativeAngle		; $74f8
	ld e,Item.angle		; $74fb
	ld (de),a		; $74fd
	jp objectApplySpeed		; $74fe

checkCloseToY48X50:
	ld e,Item.var03		; $7501
	ld a,(de)		; $7503
	ld bc,@destination		; $7504
	call addDoubleIndexToBc		; $7507
	ld h,d			; $750a
	ld l,Item.yh		; $750b
	ld a,(bc)		; $750d
	sub (hl)		; $750e
	add $01			; $750f
	cp $03			; $7511
	ret nc			; $7513
	inc bc			; $7514
	ld l,Item.xh		; $7515
	ld a,(bc)		; $7517
	sub (hl)		; $7518
	add $01			; $7519
	cp $03			; $751b
	ret			; $751d
@destination:
	.db $48 $50

moveToAngleSnapToGrid:
	ld a,(wFrameCounter)		; $7520
	and $07			; $7523
	ret nz			; $7525
	; Every 8 frames
	ld e,Item.angle		; $7526
	ld a,(de)		; $7528
	ld hl,angleToDirectionTable		; $7529
	rst_addAToHl			; $752c
	ld a,(hl)		; $752d
	ld e,Item.direction		; $752e
	ld (de),a		; $7530
	ret			; $7531
angleToDirectionTable:
	.db $00 $00 $01 $01 $01 $01 $01 $01
	.db $01 $01 $01 $01 $01 $01 $01 $02
	.db $02 $02 $03 $03 $03 $03 $03 $03
	.db $03 $03 $03 $03 $03 $03 $03 $00
