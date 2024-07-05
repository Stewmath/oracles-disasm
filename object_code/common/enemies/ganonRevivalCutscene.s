; ==================================================================================================
; ENEMY_GANON_REVIVAL_CUTSCENE
;
; Variables:
;   var30: Copied to counter2?
;   var31: Nonzero if initialization has occurred? (spawner only)
; ==================================================================================================
enemyCode60:
	ld e,Enemy.subid
	ld a,(de)
	or a
	ld e,Enemy.var31
	jr z,ganonRevivalCutscene_controller

	; This is an individual shadow in the cutscene.

	ld a,(de)
	or a
	jr nz,label_266

	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.speed
	ld (hl),SPEED_200

	call objectSetVisible83

	ld a,SND_WIND
	call playSound

label_266:
	ld bc,$5478
	ld e,Enemy.yh
	ld a,(de)
	ldh (<hFF8F),a
	ld e,Enemy.xh
	ld a,(de)
	ldh (<hFF8E),a
	sub c
	add $08
	cp $11
	jr nc,label_267

	ldh a,(<hFF8F)
	sub b
	add $08
	cp $11
	jp c,enemyDelete

label_267:
	; Nudge toward target every 8 frames
	ld a,(wFrameCounter)
	and $07
	jr nz,++
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards
++
	call objectApplySpeed
	jp ecom_flickerVisibility


ganonRevivalCutscene_controller:
	ld a,(de) ; [var31]
	or a
	jr nz,label_270

	; Just starting the cutscene

	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld h,d
	ld l,e
	inc (hl) ; [var31] = 1

	ld l,Enemy.var30
	ld (hl),$28

	call hideStatusBar

	ldh a,(<hActiveObject)
	ld d,a
	ld a,$0e
	call fadeoutToBlackWithDelay

	xor a
	ld (wDirtyFadeSprPalettes),a
	ld (wFadeSprPaletteSources),a

label_270:
	call ecom_decCounter2
	ret nz

	; Check number of shadows spawned already
	dec l
	ld a,(hl) ; [counter1]
	cp $10
	inc (hl)
	jr nc,@delete

	call ganonRevivalCutscene_spawnShadow

	ld e,Enemy.var30
	ld a,(de)
	ld e,Enemy.counter2
	ld (de),a

	ld e,Enemy.var30
	ld a,(de)
	sub $04
	cp $10
	ret c
	ld (de),a
	ret

@delete:
	; Signal parent to move to next phase of cutscene?
	ld a,Object.counter1
	call objectGetRelatedObject1Var
	inc (hl)
	jp enemyDelete

;;
ganonRevivalCutscene_spawnShadow:
	call getFreeEnemySlot_uncounted
	ret nz

	ld (hl),ENEMY_GANON_REVIVAL_CUTSCENE
	inc l
	inc (hl) ; [child.subid] = 1

	ld e,Enemy.counter1
	ld a,(de)
	and $07
	ld b,a
	add a
	add b
	ld bc,@shadowVariables
	call addAToBc

	ld l,Enemy.yh
	ld a,(bc)
	ldi (hl),a
	inc l
	inc bc
	ld a,(bc)
	ld (hl),a ; [xh]

	ld l,Enemy.angle
	inc bc
	ld a,(bc)
	ld (hl),a
	ret

; Byte 0: yh
; Byte 1: xh
; Byte 2: angle
@shadowVariables:
	.db $60 $f0 $19
	.db $b8 $d0 $00
	.db $90 $00 $02
	.db $40 $f0 $16
	.db $b8 $60 $1e
	.db $b8 $20 $05
	.db $90 $f0 $18
	.db $40 $00 $06
