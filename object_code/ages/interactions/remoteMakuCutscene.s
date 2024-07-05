; ==================================================================================================
; INTERAC_REMOTE_MAKU_CUTSCENE
;
; Variables:
;   var3e: Doesn't do anything
;   var3f: Text to show
; ==================================================================================================
interactionCode8a:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
@subid1:
	call checkInteractionState
	jr nz,@state1

@state0:
	call returnIfScrollMode01Unset
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.var3d
	ld (de),a
	call @checkConditionsAndSetText
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete

	call @loadScript

@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret

@checkConditionsAndSetText:
	ld e,Interaction.var03
	ld a,(de)
	rst_jumpTable
	.dw @val00
	.dw @val01
	.dw @val02
	.dw @val03
	.dw @val04
	.dw @val05
	.dw @val06
	.dw @val07
	.dw @val08
	.dw @val09
	.dw @val0a
	.dw @val0b

@val00:
	xor a
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b0
	jp @setTextForScript

@val01:
	ldbc $00, <TX_05b1
	jp @setTextForScript

@val02:
	ld a,TREASURE_HARP
	call checkTreasureObtained
	jp nc,@deleteSelfAndReturn
	ldbc $00, <TX_05b2
	jp @setTextForScript

@val03:
	ld a,$01
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b3
	jp @setTextForScript

@val04:
	ld a,$02
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn

	ld hl,wPastRoomFlags+$76
	set 0,(hl)
	call checkIsLinkedGame
	ld a,GLOBALFLAG_CAN_BUY_FLUTE
	call z,setGlobalFlag
	ldbc $00, <TX_05b4
	jp @setTextForScript

@val05:
	ld a,$03
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b5
	jp @setTextForScript

@val06:
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b6
	jp @setTextForScript

@val07:
	ld a,$04
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b7
	jp @setTextForScript

@val08:
	ld a,$05
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b8
	jp @setTextForScript

@val09:
	ld a,$06
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05b9
	jp @setTextForScript

@val0a:
	ld a,$07
	call @checkEssenceObtained
	jp z,@deleteSelfAndReturn
	ldbc $00, <TX_05ba
	jp @setTextForScript

@val0b:
	ldbc $00, <TX_05bb
	jp @setTextForScript


@deleteSelfAndReturn:
	pop af
	jp interactionDelete

@setTextForScript:
	ld h,d
	ld l,Interaction.var3e
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
; @param	a	Essence number
@checkEssenceObtained:
	ld hl,wEssencesObtained
	jp checkFlag


@initGraphicsAndIncState: ; Unused
	call interactionInitGraphics
	jp interactionIncState

@initGraphicsAndLoadScript: ; Unused
	call interactionInitGraphics

@loadScript:
	ld a,>TX_0500
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.remoteMakuCutsceneScript
	.dw mainScripts.remoteMakuCutsceneScript
