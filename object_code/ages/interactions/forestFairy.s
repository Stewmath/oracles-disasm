; ==================================================================================================
; INTERAC_FOREST_FAIRY
; ==================================================================================================
interactionCode49:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw forestFairy_subid00
	.dw forestFairy_subid01
	.dw forestFairy_subid02
	.dw forestFairy_subid03
	.dw forestFairy_subid04
	.dw forestFairy_subid05
	.dw forestFairy_subid06
	.dw forestFairy_subid07
	.dw forestFairy_subid08
	.dw forestFairy_subid09
	.dw forestFairy_subid0a
	.dw forestFairy_subid0b
	.dw forestFairy_subid0c
	.dw forestFairy_subid0d
	.dw forestFairy_subid0e
	.dw forestFairy_subid0f
	.dw forestFairy_subid10

forestFairy_subid00:
	ld a,(de)
	rst_jumpTable
	.dw forestFairy_subid00State0
	.dw forestFairy_subid00State1
	.dw forestFairy_subid00State2
	.dw forestFairy_subid00State3
	.dw forestFairy_deleteSelf


forestFairy_subid00State0:
forestFairy_subid03State0:
forestFairy_subid04State0:
	call interactionInitGraphics
	call forestFairy_initCollisionRadiusAndSetZAndIncState
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld l,Interaction.var3a
	ld (hl),$5a

forestFairy_loadMovementPreset:
	ld e,Interaction.var03
	ld a,(de)
	add a
	ld hl,@data
	rst_addDoubleIndex

	ld e,Interaction.yh
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.angle
	ldi a,(hl)
	and $07
	add a
	add a
	ld (de),a

	ld e,Interaction.xh
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.counter1
	ldi a,(hl)
	and $07
	inc a
	ld (de),a
	inc e
	ld (de),a

	ld e,Interaction.var38
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.direction
	ldi a,(hl)
	and $01
	ld (de),a

	ld e,Interaction.var39
	ld a,(hl)
	and $f8
	ld (de),a
	ld e,Interaction.oamFlags
	ld a,(hl)
	and $07
	ld (de),a
	dec e
	ld (de),a

	ld e,Interaction.direction
	ld a,(de)
	jp interactionSetAnimation


; Each row is data for a corresponding value of "var03".
; Data format:
;   b0: angle (bits 0-2, multiplied by 4) and y-position (bits 3-7)
;   b1: counter1/2 (bits 0-2, plus one) and x-position (bits 3-7)
;   b2: direction (bit 0) and var38 (bits 3-7)
;   b3: oamFlags (bits 0-2) and var39 (bits 3-7)
@data:
	.db $38 $6b $48 $39
	.db $29 $3b $49 $6a
	.db $5d $53 $39 $53
	.db $2e $5a $48 $51
	.db $5d $4a $49 $52
	.db $39 $2a $49 $53
	.db $4c $3c $00 $49
	.db $48 $6c $39 $8a
	.db $3a $54 $59 $03
	.db $4c $54 $00 $a1
	.db $49 $55 $91 $62
	.db $4a $53 $01 $03
	.db $4c $a4 $28 $59
	.db $60 $ac $59 $4a
	.db $03 $7c $39 $2b
	.db $97 $53 $61 $41
	.db $84 $53 $91 $81
	.db $4e $5b $89 $11
	.db $3a $7b $28 $aa
	.db $5a $7b $88 $a3
	.db $36 $ab $21 $69
	.db $86 $53 $91 $39


forestFairy_subid00State1:
	ld h,d
	ld l,Interaction.var38
	ld b,(hl)
	inc l
	ld c,(hl)
	ld l,Interaction.yh
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	sub c
	add $04
	cp $09
	jr nc,@label_09_161

	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	jr nc,@label_09_161

	ld e,Interaction.subid
	ld a,(de)
	cp $03
	jr nc,@label_09_160

	ld (hl),c
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.state
	inc (hl)

@label_09_160:
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2
	inc (hl)
	scf
	ret

@label_09_161:
	ld l,Interaction.var3a
	dec (hl)
	ld a,(hl)
	jr nz,@label_09_163

	ld (hl),$5a
	ld l,Interaction.counter2
	srl (hl)
	jr nc,@label_09_164

	inc (hl)
@label_09_163:
	and $07
	jr nz,@label_09_164

	push bc
	ldbc INTERAC_SPARKLE, $02
	call objectCreateInteraction
	pop bc

@label_09_164:
	call interactionDecCounter1
	jr nz,forestFairy_updateMovement

	inc l
	ldd a,(hl)
	ld (hl),a
	call objectGetRelativeAngleWithTempVars
	call objectNudgeAngleTowards

forestFairy_updateMovement:
	call objectApplySpeed
	ld a,(wFrameCounter)
	and $1f
	ld a,SND_MAGIC_POWDER
	call z,playSound

forestFairy_animate:
	call interactionAnimate
	or d
	ret


forestFairy_subid00State2:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)
	or a
	jr nz,forestFairy_animate

	ld e,Interaction.var03
	ld a,(de)
	cp $06
	jr nc,@createPuffAndDelete

	add $06
	ld (de),a
	call interactionIncState
	jp forestFairy_loadMovementPreset

@createPuffAndDelete:
	call objectCreatePuff
	jr forestFairy_deleteSelf

forestFairy_subid00State3:
	call forestFairy_subid00State1
	jr c,forestFairy_deleteSelf
	ld e,Interaction.yh
	ld a,(de)
	cp $80
	jr nc,++

	ld e,Interaction.xh
	ld a,(de)
	cp $a0
	ret c
++
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2
	inc (hl)

forestFairy_deleteSelf:
	jp interactionDelete


forestFairy_subid01:
	ld a,(de)
	or a
	jr z,@stateZero

	ld a,($cfd0)
	or a
	jp z,interactionDelete

	ld hl,w1Link
	call preventObjectHFromPassingObjectD
	call interactionAnimate
	jp interactionRunScript

@stateZero:
	ld e,Interaction.var03
	ld a,(de)
	ld hl,$cfd1
	call checkFlag
	jp z,interactionDelete

	ld a,($cfd1)
	call getNumSetBits
	dec a
	ld hl,forestFairyDiscoveredScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	call interactionInitGraphics

	; Set color based on index
	ld e,Interaction.var03
	ld a,(de)
	ld b,a
	inc a
	ld e,Interaction.oamFlags
	ld (de),a
	dec e
	ld (de),a

	ld a,b
	ld hl,forestFairy_discoveredPositions
	rst_addDoubleIndex
	ld e,Interaction.yh
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.xh
	ld a,(hl)
	ld (de),a
	ld a,b
	or a
	jr z,+
	ld a,$01
+
	call interactionSetAnimation

forestFairy_initCollisionRadiusAndSetZAndIncState:
	call interactionIncState
	ld l,Interaction.collisionRadiusY
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld l,Interaction.zh
	ld (hl),$fc
	jp objectSetVisiblec1


; Scripts used for fairy NPCs after being discovered
forestFairyDiscoveredScriptTable:
	.dw mainScripts.forestFairyScript_firstDiscovered
	.dw mainScripts.forestFairyScript_secondDiscovered
	.dw mainScripts.stubScript

forestFairy_discoveredPositions:
	.db $48 $38
	.db $48 $68
	.db $28 $50


forestFairy_subid02:
	jp interactionDelete

forestFairy_subid03:
	ld a,(de)
	rst_jumpTable
	.dw forestFairy_subid03State0
	.dw forestFairy_subid03State1
	.dw forestFairy_subid03State2
	.dw forestFairy_subid03State3
	.dw forestFairy_subid00State3

forestFairy_subid04:
	ld a,(de)
	rst_jumpTable
	.dw forestFairy_subid04State0
	.dw forestFairy_subid04State1
	.dw forestFairy_subid00State3

forestFairy_subid03State1:
	call forestFairy_subid00State1
	ret nc
	call interactionIncState
	ld a,$02
	ld l,Interaction.counter1
	ldi (hl),a
	ldi (hl),a
	ld l,Interaction.var3b
	ld (hl),$20
	ret

forestFairy_subid03State2:
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	ld a,(hl)
	and $07
	jr nz,++

	push bc
	ldbc INTERAC_SPARKLE, $02
	call objectCreateInteraction
	pop bc
++
	call interactionDecCounter2
	jr nz,@updateMovement

	dec l
	ldi a,(hl)
	ldi (hl),a

	; [direction]++ (wrapping $20 to $00)
	inc l
	ld a,(hl)
	inc a
	and $1f
	ld (hl),a

	ld l,Interaction.var3b
	dec (hl)
	jr nz,@updateMovement

	ld l,e
	inc (hl)
	ld hl,wTmpcfc0.fairyHideAndSeek.cfd2
	inc (hl)
	ret

@updateMovement:
	jp forestFairy_updateMovement

forestFairy_subid03State3:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)
	or a
	jp nz,forestFairy_animate

	call interactionIncState
	ld l,Interaction.var03
	inc (hl)
	ld l,Interaction.yh
	ldi a,(hl)
	inc l
	ld c,(hl)
	ld b,a
	push bc
	call forestFairy_loadMovementPreset
	pop bc
	ld h,d
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	ret

forestFairy_subid04State1:
	ld a,(wTmpcfc0.fairyHideAndSeek.cfd2)
	or a
	jp nz,forestFairy_animate
	call interactionIncState
	jp forestFairy_loadMovementPreset


; Generic NPC (between completing the maze and entering jabu)
forestFairy_subid05:
forestFairy_subid06:
forestFairy_subid07:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp z,interactionDelete

	; Check if jabu-jabu is opened?
	ld a,(wPresentRoomFlags+$90)
	bit 6,a
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $05
	ld hl,forestFairy_subid5To7NpcData
	rst_addDoubleIndex

;;
; @param	hl	Pointer to 2 bytes (see example data below)
forestFairy_initNpcFromData:
	push hl
	call interactionInitGraphics
	pop hl

	ld e,Interaction.textID
	ldi a,(hl)
	ld (de),a

	ld e,Interaction.oamFlagsBackup
	ld a,(hl)
	and $0f
	ld (de),a
	inc e
	ld (de),a

	ld a,(hl)
	and $f0
	swap a
	call interactionSetAnimation

	call objectMarkSolidPosition
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$fc

	ld l,Interaction.textID+1
	ld (hl),>TX_1100
	ld hl,mainScripts.forestFairyScript_genericNpc
	call interactionSetScript
	jp objectSetVisiblec1


; Index is [subid]-5 (for subids $05-$07).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
forestFairy_subid5To7NpcData:
	.db <TX_110d, $01
	.db <TX_1110, $12
	.db <TX_1113, $13

forestFairy_standardUpdate:
	call interactionRunScript
	call interactionAnimate
	jp objectPreventLinkFromPassing


; Generic NPC (between jabu and finishing the game)
forestFairy_subid08:
forestFairy_subid09:
forestFairy_subid0a:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_WON_FAIRY_HIDING_GAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp z,interactionDelete

	ld a,(wPresentRoomFlags+$90)
	bit 6,a
	jp z,interactionDelete

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $08
	ld hl,@npcData
	rst_addDoubleIndex
	jp forestFairy_initNpcFromData

; Index is [subid]-8 (for subids $08-$0a).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_110e, $01
	.db <TX_1111, $12
	.db <TX_1114, $13


; NPC in unlinked game who takes a secret
forestFairy_subid0b:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	call interactionInitGraphics
	call objectMarkSolidPosition
	call interactionIncState
	ld l,Interaction.zh
	ld (hl),$fc

	ld l,Interaction.oamFlags
	ld a,$01
	ldd (hl),a
	ld (hl),a
	ld hl,mainScripts.forestFairyScript_heartContainerSecret
	call interactionSetScript
	jp objectSetVisiblec1


; Generic NPC (after beating game)
forestFairy_subid0c:
forestFairy_subid0d:
	call checkInteractionState
forestFairy_standardUpdate_2:
	jr nz,forestFairy_standardUpdate

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp z,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $0c
	ld hl,@npcData
	rst_addDoubleIndex
	jp forestFairy_initNpcFromData

; Index is [subid]-$0c (for subids $0c-$0d).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_1112, $12
	.db <TX_1115, $13


; Generic NPC (while looking for companion trapped in woods)
forestFairy_subid0e:
forestFairy_subid0f:
forestFairy_subid10:
	call checkInteractionState
	jr nz,forestFairy_standardUpdate_2

	ld a,GLOBALFLAG_GOT_FLUTE
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_FOREST_UNSCRAMBLED
	call checkGlobalFlag
	jp nz,interactionDelete

	ld a,GLOBALFLAG_COMPANION_LOST_IN_FOREST
	call checkGlobalFlag
	jp z,interactionDelete

	ld e,Interaction.subid
	ld a,(de)
	sub $0e
	ld hl,@npcData
	rst_addDoubleIndex
	jp forestFairy_initNpcFromData

; Index is [subid]-$0e (for subids $0e-$10).
;  b0: Low byte of textID
;  b1: oamFlags (bits 0-3), animation index (bits 4-7)
@npcData:
	.db <TX_1127, $01
	.db <TX_1128, $12
	.db <TX_1129, $13
