;;
; @addr{70a0}
specialObjectCode_linkInCutscene:
	ld e,SpecialObject.subid		; $70a0
	ld a,(de)		; $70a2
	rst_jumpTable			; $70a3
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
	.dw _linkCutsceneB
	.dw _linkCutsceneC


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


;;
; @addr{71cb}
_linkCutscene1:
	ld e,SpecialObject.state		; $71cb
	ld a,(de)		; $71cd
	rst_jumpTable			; $71ce
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $71d3
	ld e,SpecialObject.counter1		; $71d6
	ld a,$78		; $71d8
	ld (de),a		; $71da
	xor a			; $71db
	ld e,SpecialObject.direction		; $71dc
	ld (de),a		; $71de
	call specialObjectSetAnimation		; $71df

@state1:
	ld e,SpecialObject.state2		; $71e2
	ld a,(de)		; $71e4
	rst_jumpTable			; $71e5
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw _linkCutsceneRet

@substate0:
	call itemDecCounter1		; $71f0
	ret nz			; $71f3
	call itemIncState2		; $71f4
	ld l,SpecialObject.speed		; $71f7
	ld (hl),SPEED_100		; $71f9
	ld l,SpecialObject.xh		; $71fb
	ld a,(hl)		; $71fd
	cp $48			; $71fe
	ld a,$00		; $7200
	jr z,++			; $7202
	ld a,$18		; $7204
	jr nc,++		; $7206
	ld a,$08		; $7208
++
	ld l,SpecialObject.angle		; $720a
	ld (hl),a		; $720c
	swap a			; $720d
	rlca			; $720f
	jp specialObjectSetAnimation		; $7210

@substate1:
	ld e,SpecialObject.xh		; $7213
	ld a,(de)		; $7215
	cp $48			; $7216
	jr nz,++		; $7218
	call itemIncState2		; $721a
	ld l,SpecialObject.counter1		; $721d
	ld (hl),$04		; $721f
	ret			; $7221
++
	call objectApplySpeed		; $7222
	jp specialObjectAnimate		; $7225

@substate2:
	call itemDecCounter1		; $7228
	ret nz			; $722b
	ld (hl),$2e		; $722c
	call itemIncState2		; $722e
	ld l,SpecialObject.angle		; $7231
	ld (hl),$00		; $7233
	xor a			; $7235
	jp specialObjectSetAnimation		; $7236

@substate3:
	call specialObjectAnimate		; $7239
	call objectApplySpeed		; $723c
	call itemDecCounter1		; $723f
	ret nz			; $7242
	ld hl,$cfd0		; $7243
	ld (hl),$01		; $7246
	ld a,SND_CLINK		; $7248
	call playSound		; $724a
	jp itemIncState2		; $724d

_linkCutsceneRet:
	ret			; $7250

;;
; @addr{7251}
_linkCutscene2:
	ld e,SpecialObject.state		; $7251
	ld a,(de)		; $7253
	rst_jumpTable			; $7254
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7259
	ld bc,$3838		; $725c
	call objectGetRelativeAngle		; $725f
	ld e,SpecialObject.angle		; $7262
	ld (de),a		; $7264
	call convertAngleDeToDirection		; $7265
	jp specialObjectSetAnimation		; $7268

@state1:
	ld e,SpecialObject.state2		; $726b
	ld a,(de)		; $726d
	rst_jumpTable			; $726e
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8

@substate0:
	ld a,($cfd0)		; $7281
	cp $02			; $7284
	ret nz			; $7286

	call itemIncState2		; $7287
	ld l,SpecialObject.yh		; $728a
	ldi a,(hl)		; $728c
	cp $48			; $728d
	ld a,$18		; $728f
	ld b,$04		; $7291
	jr z,++			; $7293
	ld a,$10		; $7295
	jr c,++			; $7297

	inc l			; $7299
	ld b,$01		; $729a
	ld a,(hl)		; $729c
	cp $38			; $729d
	ld a,$00		; $729f
	jr z,++			; $72a1
	ld a,$18		; $72a3
	jr nc,++		; $72a5
	ld a,$08		; $72a7
++
	ld l,SpecialObject.state2		; $72a9
	ld (hl),b		; $72ab
	ld l,SpecialObject.angle		; $72ac
	ld (hl),a		; $72ae
	swap a			; $72af
	rlca			; $72b1
	jp specialObjectSetAnimation		; $72b2

@substate1:
	call specialObjectAnimate		; $72b5
	call _linkCutscene_cpxTo38		; $72b8
	jp nz,objectApplySpeed		; $72bb

	call itemIncState2		; $72be
	ld l,SpecialObject.counter1		; $72c1
	ld (hl),$08		; $72c3
	ret			; $72c5

@substate2:
	ld b,$00		; $72c6

@label_72c8:
	call itemDecCounter1		; $72c8
	ret nz			; $72cb

@label_72cc:
	call itemIncState2		; $72cc
	ld l,SpecialObject.angle		; $72cf
	ld (hl),b		; $72d1
	ld a,b			; $72d2
	swap a			; $72d3
	rlca			; $72d5
	jp specialObjectSetAnimation		; $72d6

@substate3:
	call specialObjectAnimate		; $72d9
	call _linkCutscene_cpyTo48		; $72dc
	jp nz,objectApplySpeed		; $72df

@gotoState7:
	ld h,d			; $72e2
	ld l,SpecialObject.state2		; $72e3
	ld (hl),$07		; $72e5
	ld l,SpecialObject.counter1		; $72e7
	ld (hl),$3c		; $72e9
	xor a			; $72eb
	jp specialObjectSetAnimation		; $72ec

@substate4:
	call specialObjectAnimate		; $72ef
	call _linkCutscene_cpyTo48		; $72f2
	jp nz,objectApplySpeed		; $72f5
	call itemIncState2		; $72f8
	ld l,SpecialObject.counter1		; $72fb
	ld (hl),$08		; $72fd
	ret			; $72ff

@substate5:
	ld b,$18		; $7300
	jp @label_72c8		; $7302

@substate6:
	call specialObjectAnimate		; $7305
	call _linkCutscene_cpxTo38		; $7308
	jp nz,objectApplySpeed		; $730b
	jr @gotoState7			; $730e

@substate7:
	call itemDecCounter1		; $7310
	ret nz			; $7313
	ld (hl),$10		; $7314
	ld b,$00		; $7316
	call @label_72cc		; $7318
	ld hl,$cfd0		; $731b
	ld (hl),$03		; $731e
	ret			; $7320

@substate8:
	ret			; $7321

;;
; @addr{7322}
_linkCutscene3:
	ld e,SpecialObject.state		; $7322
	ld a,(de)		; $7324
	rst_jumpTable			; $7325
.dw @state0
.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $732a
	ld a,$01		; $732d
	jp specialObjectSetAnimation		; $732f

@state1:
	ld e,SpecialObject.state2		; $7332
	ld a,(de)		; $7334
	rst_jumpTable			; $7335
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

@substate0:
	ld a,($cfd0)		; $734a
	cp $09			; $734d
	ret nz			; $734f

	call itemIncState2		; $7350
	ld l,SpecialObject.yh		; $7353
	ld a,$30		; $7355
	ldi (hl),a		; $7357
	inc l			; $7358
	ld a,$78		; $7359
	ld (hl),a		; $735b
	ld a,$01		; $735c
	jp specialObjectSetAnimation		; $735e

@substate1:
	ld a,($cfd0)		; $7361
	cp $0a			; $7364
	ret nz			; $7366
	call itemIncState2		; $7367
	ld l,SpecialObject.counter1		; $736a
	ld (hl),$1e		; $736c
	ret			; $736e

@substate2:
	call itemDecCounter1		; $736f
	ret nz			; $7372
	call itemIncState2		; $7373
	xor a			; $7376
	jp specialObjectSetAnimation		; $7377

@substate3:
	ld b,$0e		; $737a
	ld c,$02		; $737c
	ld a,($cfd0)		; $737e
	cp b			; $7381
	ret nz			; $7382
	call itemIncState2		; $7383
	ld a,c			; $7386
	jp specialObjectSetAnimation		; $7387

@substate4:
	ld a,($cfd0)		; $738a
	cp $11			; $738d
	ret nz			; $738f

	call itemIncState2		; $7390
	ld l,SpecialObject.angle		; $7393
	ld (hl),$18		; $7395
	ld l,SpecialObject.speed		; $7397
	ld (hl),SPEED_180		; $7399
	ld l,SpecialObject.counter1		; $739b
	ld (hl),$16		; $739d
	ld a,SND_UNKNOWN5		; $739f
	call playSound		; $73a1
	ld a,$03		; $73a4
	jp specialObjectSetAnimation		; $73a6

@substate5:
	call _linkCutscene_animateAndDecCounter1		; $73a9
	jp nz,objectApplySpeed		; $73ac
	call itemIncState2		; $73af
	ld l,SpecialObject.counter1		; $73b2
	ld (hl),$06		; $73b4

@substate9:
	ret			; $73b6

@substate6:
	call itemDecCounter1		; $73b7
	ret nz			; $73ba
	ld (hl),$08		; $73bb
	ld l,SpecialObject.angle		; $73bd
	ld (hl),$10		; $73bf
	ld a,$02		; $73c1
	ld l,SpecialObject.direction		; $73c3
	ld (hl),a		; $73c5
	call specialObjectSetAnimation		; $73c6
	jp itemIncState2		; $73c9

@substate7:
	call _linkCutscene_animateAndDecCounter1		; $73cc
	jp nz,objectApplySpeed		; $73cf
	ld a,SND_UNKNOWN5		; $73d2
	call playSound		; $73d4
	jp itemIncState2		; $73d7

@substate8:
	ld a,($cfd2)		; $73da
	or a			; $73dd
	jr z,_linkCutsceneFunc_73e8			; $73de

	ld a,$03		; $73e0
	call specialObjectSetAnimation		; $73e2
	jp itemIncState2		; $73e5

;;
; @addr{73e8}
_linkCutsceneFunc_73e8:
	ld a,(wFrameCounter)		; $73e8
	and $07			; $73eb
	ret nz			; $73ed

	callab interactionBank0a.func_0a_7877		; $73ee
	call objectGetRelativeAngle		; $73f6
	call convertAngleToDirection		; $73f9
	ld h,d			; $73fc
	ld l,SpecialObject.direction		; $73fd
	cp (hl)			; $73ff
	ret z			; $7400
	ld (hl),a		; $7401
	jp specialObjectSetAnimation		; $7402

;;
; @addr{7405}
_linkCutscene4:
	ld e,SpecialObject.state		; $7405
	ld a,(de)		; $7407
	rst_jumpTable			; $7408
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $740d
	ld l,SpecialObject.yh		; $7410
	ld a,$38		; $7412
	ldi (hl),a		; $7414
	inc l			; $7415
	ld a,$58		; $7416
	ld (hl),a		; $7418
	xor a			; $7419
	jp specialObjectSetAnimation		; $741a

@state1:
	ld e,SpecialObject.state2		; $741d
	ld a,(de)		; $741f
	rst_jumpTable			; $7420
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5

@substate0:
	ld a,($cfd0)		; $742d
	cp $1f			; $7430
	ret nz			; $7432
	jp itemIncState2		; $7433

@substate1:
	ld a,($cfd0)		; $7436
	cp $20			; $7439
	jp nz,_linkCutsceneFunc_73e8		; $743b
	call itemIncState2		; $743e
	ld l,SpecialObject.counter1		; $7441
	ld (hl),$50		; $7443
	ret			; $7445

@substate2:
	call itemDecCounter1		; $7446
	ret nz			; $7449
	ld (hl),$30		; $744a
	ld l,SpecialObject.speed		; $744c
	ld (hl),SPEED_100		; $744e
	ld b,$10		; $7450
	jp _linkCutscene2@label_72cc		; $7452

@substate3:
	call _linkCutscene_animateAndDecCounter1		; $7455
	jp nz,objectApplySpeed		; $7458
	ld (hl),$08		; $745b
	jp itemIncState2		; $745d

@substate4:
	call itemDecCounter1		; $7460
	ret nz			; $7463
	ld (hl),$10		; $7464
	ld b,$18		; $7466
	jp _linkCutscene2@label_72cc		; $7468

@substate5:
	call _linkCutscene_animateAndDecCounter1		; $746b
	jp nz,objectApplySpeed		; $746e
	ld a,$21		; $7471
	ld ($cfd0),a		; $7473
	ld a,$81		; $7476
	ld (wMenuDisabled),a		; $7478
	ld (wDisabledObjects),a		; $747b
	ld e,SpecialObject.direction		; $747e
	ld a,$03		; $7480
	ld (de),a		; $7482
	lda SPECIALOBJECTID_LINK			; $7483
	jp setLinkIDOverride		; $7484

;;
; @addr{7487}
_linkCutscene_cpyTo48:
	ld e,SpecialObject.yh		; $7487
	ld a,(de)		; $7489
	cp $48			; $748a
	ret			; $748c

;;
; @addr{748d}
_linkCutscene_cpxTo38:
	ld e,SpecialObject.xh		; $748d
	ld a,(de)		; $748f
	cp $38			; $7490
	ret			; $7492

;;
; @addr{7493}
_linkCutscene_initOam_setVisible_incState:
	callab bank5.specialObjectSetOamVariables		; $7493
	call objectSetVisiblec1		; $749b
	jp itemIncState		; $749e

;;
; @addr{74a1}
_linkCutscene_animateAndDecCounter1:
	call specialObjectAnimate		; $74a1
	jp itemDecCounter1		; $74a4

;;
; @addr{74a7}
_linkCutscene5:
	ld e,SpecialObject.state		; $74a7
	ld a,(de)		; $74a9
	rst_jumpTable			; $74aa
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $74af
	ld l,SpecialObject.speed		; $74b2
	ld (hl),SPEED_100		; $74b4
	ld l,SpecialObject.var3d		; $74b6
	ld (hl),$00		; $74b8
	ld l,SpecialObject.direction		; $74ba
	ld (hl),$ff		; $74bc

@state1:
	call _linkCutscene_updateAngleOnPath		; $74be
	jr z,+			; $74c1
	call specialObjectAnimate		; $74c3
	jp objectApplySpeed		; $74c6
+
	ld a,SPECIALOBJECTID_LINK		; $74c9
	jp setLinkIDOverride		; $74cb

;;
; @addr{74ce}
_linkCutscene6:
	ld e,SpecialObject.state		; $74ce
	ld a,(de)		; $74d0
	rst_jumpTable			; $74d1
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $74d6
	ld l,SpecialObject.speed		; $74d9
	ld (hl),SPEED_80		; $74db
	ld b,$16		; $74dd
	ld l,SpecialObject.angle		; $74df
	ld a,(hl)		; $74e1
	cp $08			; $74e2
	jr z,+			; $74e4
	ld b,$15		; $74e6
+
	ld a,b			; $74e8
	call specialObjectSetAnimation		; $74e9

@state1:
	ld e,SpecialObject.state2		; $74ec
	ld a,(de)		; $74ee
	rst_jumpTable			; $74ef
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	call specialObjectAnimate		; $74f6
	call getThisRoomFlags		; $74f9
	and $c0			; $74fc
	jp z,objectApplySpeed		; $74fe
	jp itemIncState2		; $7501

@substate1:
	ld a,($cfd0)		; $7504
	cp $07			; $7507
	ret nz			; $7509
	call itemIncState2		; $750a
	ld a,$02		; $750d
	jp specialObjectSetAnimation		; $750f

@substate2:
	ret			; $7512

;;
; @addr{7513}
_linkCutscene7:
	ld e,SpecialObject.state		; $7513
	ld a,(de)		; $7515
	rst_jumpTable			; $7516
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $751b
	ld l,SpecialObject.counter1		; $751e
	ld (hl),$f0		; $7520
	ld a,$14		; $7522
	jp specialObjectSetAnimation		; $7524

@state1:
	call specialObjectAnimate		; $7527
	call itemDecCounter1		; $752a
	ret nz			; $752d
	lda SPECIALOBJECTID_LINK			; $752e
	call setLinkIDOverride		; $752f
	ld l,SpecialObject.direction		; $7532
	ld (hl),$02		; $7534
	ld a,$01		; $7536
	ld (wUseSimulatedInput),a		; $7538
	ld (wMenuDisabled),a		; $753b
	ret			; $753e

;;
; @addr{753f}
_linkCutscene8:
	ld e,SpecialObject.state		; $753f
	ld a,(de)		; $7541
	rst_jumpTable			; $7542
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7547
	ld l,SpecialObject.yh		; $754a
	ld (hl),$68		; $754c
	ld l,SpecialObject.xh		; $754e
	ld (hl),$50		; $7550
	ld a,$00		; $7552
	call specialObjectSetAnimation		; $7554
	jp objectSetInvisible		; $7557

@state1:
	ld e,SpecialObject.state2		; $755a
	ld a,(de)		; $755c
	rst_jumpTable			; $755d
	.dw @substate0
	.dw @substate1

@substate0:
	ld a,($cfd0)		; $7562
	cp $03			; $7565
	jr z,+			; $7567
	ld a,($cfd0)		; $7569
	cp $01			; $756c
	ret nz			; $756e
+
	call itemIncState2		; $756f
	jp objectSetVisiblec2		; $7572

@substate1:
	ret			; $7575

;;
; @addr{7576}
_linkCutscene9:
	ld e,SpecialObject.state		; $7576
	ld a,(de)		; $7578
	rst_jumpTable			; $7579
	.dw @state0
	.dw @state1

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $757e
	ld a,$02		; $7581
	call specialObjectSetAnimation		; $7583
	jp objectSetInvisible		; $7586

@state1:
	ld e,SpecialObject.state2		; $7589
	ld a,(de)		; $758b
	rst_jumpTable			; $758c
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4

@substate0:
	ld a,($cfc0)		; $7597
	cp $01			; $759a
	ret nz			; $759c
	call itemIncState2		; $759d
	jp objectSetVisible82		; $75a0

@substate1:
	ld a,($cfc0)		; $75a3
	cp $03			; $75a6
	ret nz			; $75a8
	call itemIncState2		; $75a9

@substate2:
	ld a,($cfc0)		; $75ac
	cp $06			; $75af
	jp nz,_linkCutsceneFunc_73e8		; $75b1

	call itemIncState2		; $75b4
	ld bc,$fe40		; $75b7
	call objectSetSpeedZ		; $75ba
	ld a,$0d		; $75bd
	jp specialObjectSetAnimation		; $75bf

@substate3:
	ld c,$20		; $75c2
	call objectUpdateSpeedZ_paramC		; $75c4
	ret nz			; $75c7

	call itemIncState2		; $75c8
	ld l,SpecialObject.counter1		; $75cb
	ld (hl),$78		; $75cd
	ld l,SpecialObject.animCounter		; $75cf
	ld (hl),$01		; $75d1
	ret			; $75d3

@substate4:
	call itemDecCounter1		; $75d4
	jp nz,specialObjectAnimate		; $75d7
	ld hl,$cfdf		; $75da
	ld (hl),$ff		; $75dd
	ret			; $75df

;;
; Link being kissed by Zelda in ending cutscene - cutscene 6 in seasons
;
; @addr{75e0}
_linkCutsceneA:
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

;;
; Cutscene played on starting a new game ("accept our quest, hero") - cutsceneB in seasons
;
; @addr{7668}
_linkCutsceneB:
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

;;
; @addr{76fe}
_linkCutsceneC:
	ld e,SpecialObject.state		; $76fe
	ld a,(de)		; $7700
	rst_jumpTable			; $7701
	.dw @state0
	.dw _linkCutsceneRet

@state0:
	call _linkCutscene_initOam_setVisible_incState		; $7706
	ld bc,$f804		; $7709
	ld a,$ff		; $770c
	call objectCreateExclamationMark		; $770e
	ld l,Interaction.subid		; $7711
	ld (hl),$01		; $7713
	ld a,$06		; $7715
	jp specialObjectSetAnimation		; $7717

;;
; @addr{771a}
_linkCutscene_oscillateZ_2:
	ld hl,_linkCutscene_zOscillation2		; $771a
	jp _linkCutscene_oscillateZ		; $771d

;;
; Update Link's angle to follow a certain path. Which path it is depends on var03 (value
; from 0-2).
;
; @param[out]	zflag	Set if reached the destination
; @addr{7720}
_linkCutscene_updateAngleOnPath:
	ld e,SpecialObject.var03		; $7720
	ld a,(de)		; $7722
	ld hl,@paths		; $7723
	rst_addDoubleIndex			; $7726
	ldi a,(hl)		; $7727
	ld h,(hl)		; $7728
	ld l,a			; $7729

	ld e,SpecialObject.var3d		; $772a
	ld a,(de)		; $772c
	add a			; $772d
	rst_addAToHl			; $772e
	ldi a,(hl)		; $772f
	cp $ff			; $7730
	ret z			; $7732

	or a			; $7733
	jr nz,@checkX		; $7734

	ld e,SpecialObject.yh		; $7736
	ld a,(de)		; $7738
	sub (hl)		; $7739
	ld b,$00		; $773a
	jr nc,+			; $773c
	ld b,$02		; $773e
+
	jr nz,@updateDirection	; $7740
	jr @next		; $7742

@checkX:
	ld e,SpecialObject.xh		; $7744
	ld a,(de)		; $7746
	sub (hl)		; $7747
	ld b,$03		; $7748
	jr nc,+			; $774a
	ld b,$01		; $774c
+
	jr nz,@updateDirection	; $774e

@next:
	ld h,d			; $7750
	ld l,SpecialObject.var3d		; $7751
	inc (hl)		; $7753
	call @updateDirection		; $7754
	jr _linkCutscene_updateAngleOnPath		; $7757

;;
; @param	b	Direction value
; @param[out]	zflag	Unset
; @addr{7759}
@updateDirection:
	ld e,SpecialObject.direction		; $7759
	ld a,(de)		; $775b
	cp b			; $775c
	jr z,@ret		; $775d

	ld a,b			; $775f
	ld (de),a		; $7760
	call specialObjectSetAnimation		; $7761
	ld e,SpecialObject.direction		; $7764
	ld a,(de)		; $7766
	swap a			; $7767
	rrca			; $7769
	ld e,SpecialObject.angle		; $776a
	ld (de),a		; $776c

@ret:
	or d			; $776d
	ret			; $776e


@paths:
	.dw @@path0
	.dw @@path1
	.dw @@path2

; Data format:
;  b0: 0 for y, 1 for x
;  b1: Target position to walk to

@@path0: ; Just saved the maku sapling, moving toward her
	.db $00 $38
	.db $01 $50
	.db $00 $38
	.db $ff

@@path1: ; Just freed the goron elder, moving toward him
	.db $01 $38
	.db $00 $60
	.db $ff

@@path2: ; Funny joke cutscene in trading sequence
	.db $00 $48
	.db $ff
