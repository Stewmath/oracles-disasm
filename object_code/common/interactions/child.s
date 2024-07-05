; ==================================================================================================
; INTERAC_CHILD
;
; Variables:
;   subid: personality type (0-6)
;   var03: index of script and code to run (changes based on personality and growth stage)
;   var37: animation base (depends on subid, or his personality type)
;   var39: $00 is normal; $01 gives "light" solidity (when he moves); $02 gives no solidity.
;   var3a: animation index? (added to base)
;   var3b: scratch variable for scripts
;   var3c: current index in "position list" data
;   var3d: number of entries in "position list" data (minus one)?
;   var3e/3f: pointer to "position list" data for when the child moves around
; ==================================================================================================
interactionCode35:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interac65_state1

@state0:
	call childDetermineAnimationBase
	call interactionInitGraphics
	call interactionIncState

	ld e,Interaction.var03
	ld a,(de)
	ld hl,childScriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable

	/* $00 */ .dw @initAnimation
	/* $01 */ .dw @hyperactiveStage4Or5
	/* $02 */ .dw @shyStage4Or5
	/* $03 */ .dw @curious
	/* $04 */ .dw @hyperactiveStage4Or5
	/* $05 */ .dw @shyStage4Or5
	/* $06 */ .dw @curious
	/* $07 */ .dw @hyperactiveStage6
	/* $08 */ .dw @shyStage6
	/* $09 */ .dw @curious
	/* $0a */ .dw @slacker
	/* $0b */ .dw @warrior
	/* $0c */ .dw @arborist
	/* $0d */ .dw @singer
	/* $0e */ .dw @slacker
	/* $0f */ .dw @script0f
	/* $10 */ .dw @arborist
	/* $11 */ .dw @singer
	/* $12 */ .dw @slacker
	/* $13 */ .dw @warrior
	/* $14 */ .dw @arborist
	/* $15 */ .dw @singer
	/* $16 */ .dw @val16
	/* $17 */ .dw @initAnimation
	/* $18 */ .dw @curious
	/* $19 */ .dw @slacker
	/* $1a */ .dw @initAnimation
	/* $1b */ .dw @initAnimation
	/* $1c */ .dw @singer

@initAnimation:
	ld e,Interaction.var37
	ld a,(de)
	call interactionSetAnimation
	jp childUpdateSolidityAndVisibility

@hyperactiveStage6:
	ld a,$02
	call childLoadPositionListPointer

@hyperactiveStage4Or5:
	ld h,d
	ld l,Interaction.var39
	ld (hl),$01

	ld l,Interaction.speed
	ld (hl),SPEED_180
	ld l,Interaction.angle
	ld (hl),$18

	ld a,$00

@setAnimation:
	ld h,d
	ld l,Interaction.var3a
	ld (hl),a
	ld l,Interaction.var37
	add (hl)
	call interactionSetAnimation
	jp childUpdateSolidityAndVisibility

@val16:
	call @hyperactiveStage4Or5
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ret

@shyStage4Or5:
	ld a,$00
	call childLoadPositionListPointer
	jr ++

@shyStage6:
	ld a,$01
	call childLoadPositionListPointer
++
	ld h,d
	ld l,Interaction.var39
	ld (hl),$01
	ld l,Interaction.speed
	ld (hl),SPEED_200
	ld a,$00
	jr @setAnimation

@curious:
	ld h,d
	ld l,Interaction.var39
	ld (hl),$02
	ld a,$00
	jr @setAnimation

@slacker:
	ld a,$00
	jr @setAnimation

@warrior:
	ld a,$03
	call childLoadPositionListPointer
	jr ++

@script0f:
	ld a,$04
	call childLoadPositionListPointer
++
	ld h,d
	ld l,Interaction.var39
	ld (hl),$01
	ld l,Interaction.speed
	ld (hl),SPEED_80
	ld a,$00
	jr @setAnimation

@arborist:
	ld a,$03
	jr @setAnimation

@singer:
	ld a,$00
	jr @setAnimation


interac65_state1:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable

	/* $00 */ .dw @updateAnimationAndSolidity
	/* $01 */ .dw @hyperactiveMovement
	/* $02 */ .dw @shyMovement
	/* $03 */ .dw @curiousMovement
	/* $04 */ .dw @hyperactiveMovement
	/* $05 */ .dw @shyMovement
	/* $06 */ .dw @curiousMovement
	/* $07 */ .dw @usePositionList
	/* $08 */ .dw @shyMovement
	/* $09 */ .dw @curiousMovement
	/* $0a */ .dw @slackerMovement
	/* $0b */ .dw @usePositionList
	/* $0c */ .dw @arboristMovement
	/* $0d */ .dw @singerMovement
	/* $0e */ .dw @slackerMovement
	/* $0f */ .dw @usePositionList
	/* $10 */ .dw @arboristMovement
	/* $11 */ .dw @singerMovement
	/* $12 */ .dw @slackerMovement
	/* $13 */ .dw @usePositionList
	/* $14 */ .dw @arboristMovement
	/* $15 */ .dw @singerMovement
	/* $16 */ .dw @val16
	/* $17 */ .dw @updateAnimationAndSolidity
	/* $18 */ .dw @val1b
	/* $19 */ .dw @slackerMovement
	/* $1a */ .dw @updateAnimationAndSolidity
	/* $1b */ .dw @updateAnimationAndSolidity
	/* $1c */ .dw @singerMovement

@hyperactiveMovement:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,+
	call childUpdateHyperactiveMovement
+

@arboristMovement:
	call interactionRunScript

@updateAnimationAndSolidity:
	jp childUpdateAnimationAndSolidity

@val16:
	call childUpdateUnknownMovement
	jp childUpdateAnimationAndSolidity

@shyMovement:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,+
	call childUpdateShyMovement
+
	jr @runScriptAndUpdateAnimation

@usePositionList:
	ld e,Interaction.counter1
	ld a,(de)
	or a
	jr nz,++
	call childUpdateAngleAndApplySpeed
	call childCheckAnimationDirectionChanged
	call childCheckReachedDestination
	call c,childIncPositionIndex
++
	jr @runScriptAndUpdateAnimation

@curiousMovement:
	call childUpdateCuriousMovement
	ld e,Interaction.var3d
	ld a,(de)
	or a
	call z,interactionRunScript

@val1b:
	jp childUpdateAnimationAndSolidity

@slackerMovement:
	ld a,(wFrameCounter)
	and $1f
	jr nz,++
	ld e,Interaction.animParameter
	ld a,(de)
	and $01
	ld c,$08
	jr nz,+
	ld c,$fc
+
	ld b,$f4
	call objectCreateFloatingMusicNote
++
	jr @runScriptAndUpdateAnimation

@singerMovement:
	ld a,(wFrameCounter)
	and $1f
	jr nz,@runScriptAndUpdateAnimation
	ld e,Interaction.direction
	ld a,(de)
	or a
	ld c,$fc
	jr z,+
	ld c,$00
+
	ld b,$fc
	call objectCreateFloatingMusicNote

@runScriptAndUpdateAnimation:
	call interactionRunScript
	jp childUpdateAnimationAndSolidity


;;
childUpdateAnimationAndSolidity:
	call interactionAnimate

;;
childUpdateSolidityAndVisibility:
	ld e,Interaction.var39
	ld a,(de)
	cp $01
	jr z,++
	cp $02
	jp z,objectSetPriorityRelativeToLink_withTerrainEffects
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects
++
	call objectPushLinkAwayOnCollision
	jp objectSetPriorityRelativeToLink_withTerrainEffects

;;
; Writes the "base" animation index to var37 based on subid (personality type)?
childDetermineAnimationBase:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@animations
	rst_addAToHl
	ld a,(hl)
	ld e,Interaction.var37
	ld (de),a
	ret

@animations:
	.db $00 $02 $05 $08 $0b $11 $15 $17

;;
childUpdateHyperactiveMovement:
	call objectApplySpeed
	ld h,d
	ld l,Interaction.xh
	ld a,(hl)
	sub $29
	cp $40
	ret c
	bit 7,a
	jr nz,+
	dec (hl)
	dec (hl)
+
	inc (hl)
	ld l,Interaction.var3c
	ld a,(hl)
	inc a
	and $03
	ld (hl),a
	ld bc,childHyperactiveMovementAngles
	call addAToBc
	ld a,(bc)
	ld l,Interaction.angle
	ld (hl),a

childFlipAnimation:
	ld l,Interaction.var3a
	ld a,(hl)
	xor $01
	ld (hl),a
	ld l,Interaction.var37
	add (hl)
	jp interactionSetAnimation

childHyperactiveMovementAngles:
	.db $18 $0a $18 $06

;;
childUpdateUnknownMovement:
	call objectApplySpeed
	ld e,Interaction.xh
	ld a,(de)
	sub $14
	cp $28
	ret c
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	jr childFlipAnimation

;;
; Updates movement for "shy" personality type (runs away when Link approaches)
childUpdateShyMovement:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

@substate0:
	ld c,$18
	call objectCheckLinkWithinDistance
	ret nc

	call interactionIncSubstate

@substate1:
	call childUpdateAngleAndApplySpeed
	call childCheckReachedDestination
	ret nc

	ld h,d
	ld l,Interaction.substate
	ld (hl),$00
	jp childIncPositionIndex

;;
childUpdateAngleAndApplySpeed:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	ld b,a
	ld e,Interaction.var3f
	ld a,(de)
	ld l,a
	ld e,Interaction.var3e
	ld a,(de)
	ld h,a
	ld a,b
	rst_addAToHl
	ld b,(hl)
	inc hl
	ld c,(hl)
	call objectGetRelativeAngle
	ld e,Interaction.angle
	ld (de),a
	jp objectApplySpeed

;;
; @param[out]	cflag	Set if the child's reached the position he's moving toward (or is
;			within 1 pixel from the destination on both axes)
childCheckReachedDestination:
	ld h,d
	ld l,Interaction.var3c
	ld a,(hl)
	add a
	push af

	ld e,Interaction.var3f
	ld a,(de)
	ld c,a
	ld e,Interaction.var3e
	ld a,(de)
	ld b,a

	pop af
	call addAToBc
	ld l,Interaction.yh
	ld a,(bc)
	sub (hl)
	add $01
	cp $03
	ret nc
	inc bc
	ld l,Interaction.xh
	ld a,(bc)
	sub (hl)
	add $01
	cp $03
	ret

;;
; Updates animation if the child's direction has changed?
childCheckAnimationDirectionChanged:
	ld h,d
	ld l,Interaction.angle
	ld a,(hl)
	swap a
	and $01
	xor $01
	ld l,Interaction.direction
	cp (hl)
	ret z
	ld (hl),a
	ld l,Interaction.var3a
	add (hl)
	ld l,Interaction.var37
	add (hl)
	jp interactionSetAnimation

;;
childIncPositionIndex:
	ld h,d
	ld l,Interaction.var3d
	ld a,(hl)
	ld l,Interaction.var3c
	inc (hl)
	cp (hl)
	ret nc
	ld (hl),$00
	ret

;;
; Loads address of position list into var3e/var3f, and the number of positions to loop
; through (minus one) into var3d.
;
; @param	a	Data index
childLoadPositionListPointer:
	add a
	add a
	ld hl,@positionTable
	rst_addAToHl
	ld e,Interaction.var3f
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3e
	ldi a,(hl)
	ld (de),a
	ld e,Interaction.var3d
	ldi a,(hl)
	ld (de),a
	ret


; Data format:
;  word: pointer to position list
;  byte: number of entries in the list (minus one)
;  byte: unused
@positionTable:
	dwbb @list0 $07 $00
	dwbb @list1 $03 $00
	dwbb @list2 $0b $00
	dwbb @list3 $01 $00
	dwbb @list4 $03 $00

; Each 2 bytes is a position the child will move to.
@list0:
	.db $68 $18
	.db $68 $68
	.db $28 $68
	.db $68 $18
	.db $38 $18
	.db $68 $68
	.db $28 $68
	.db $38 $18

@list1:
	.db $18 $18
	.db $58 $18
	.db $58 $48
	.db $18 $48

@list2:
	.db $28 $48
	.db $18 $44
	.db $18 $28
	.db $20 $18
	.db $2c $0c
	.db $38 $08
	.db $44 $0c
	.db $50 $18
	.db $58 $28
	.db $58 $44
	.db $48 $48
	.db $38 $4c

@list3:
	.db $48 $18
	.db $48 $68
@list4:
	.db $18 $30
	.db $58 $30
	.db $58 $48
	.db $18 $48

;;
childUpdateCuriousMovement:
	ld e,Interaction.substate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2

@substate0:
	ld h,d
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld l,Interaction.angle
	ld (hl),$18

@gotoSubstate1AndJump:
	ld h,d
	ld l,Interaction.substate
	ld (hl),$01
	ld l,Interaction.var3d
	ld (hl),$01

	ld l,Interaction.speedZ
	ld (hl),$00
	inc hl
	ld (hl),$fb
	ld a,SND_JUMP
	jp playSound

@substate1:
	ld c,$50
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed

	call interactionIncSubstate

	ld l,Interaction.var3d
	ld (hl),$00
	ld l,Interaction.var3c
	ld (hl),$78

	ld l,Interaction.angle
	ld a,(hl)
	xor $10
	ld (hl),a
	ret

@substate2:
	ld h,d
	ld l,Interaction.var3c
	dec (hl)
	ret nz
	jr @gotoSubstate1AndJump


childScriptTable:
	.dw mainScripts.childScript00
	.dw mainScripts.childScript_stage4_hyperactive
	.dw mainScripts.childScript_stage4_shy
	.dw mainScripts.childScript_stage4_curious
	.dw mainScripts.childScript_stage5_hyperactive
	.dw mainScripts.childScript_stage5_shy
	.dw mainScripts.childScript_stage5_curious
	.dw mainScripts.childScript_stage6_hyperactive
	.dw mainScripts.childScript_stage6_shy
	.dw mainScripts.childScript_stage6_curious
	.dw mainScripts.childScript_stage7_slacker
	.dw mainScripts.childScript_stage7_warrior
	.dw mainScripts.childScript_stage7_arborist
	.dw mainScripts.childScript_stage7_singer
	.dw mainScripts.childScript_stage8_slacker
	.dw mainScripts.childScript_stage8_warrior
	.dw mainScripts.childScript_stage8_arborist
	.dw mainScripts.childScript_stage8_singer
	.dw mainScripts.childScript_stage9_slacker
	.dw mainScripts.childScript_stage9_warrior
	.dw mainScripts.childScript_stage9_arborist
	.dw mainScripts.childScript_stage9_singer
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
	.dw mainScripts.childScript00
