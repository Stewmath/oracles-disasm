; ==================================================================================================
; INTERAC_HOLLY
; ==================================================================================================
interactionCode70:
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@subid1
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld a,(wWarpDestPos)
	cp $04
	ld hl,mainScripts.hollyScript_enteredFromChimney
	jr z,@setScript
	ld hl,mainScripts.hollyScript_enteredNormally
@setScript:
	call interactionSetScript
	call interactionInitGraphics
	jp objectSetVisiblec2
@state1:
	call interactionRunScript
	ld c,$0e
	call objectUpdateSpeedZ_paramC
	jp npcFaceLinkAndAnimate
@subid1:
	call returnIfScrollMode01Unset
	call interactionDeleteAndRetIfEnabled02
	ld a,$d9
	call findTileInRoom
	jr nz,+
	ld b,$00
-
	inc b
	dec l
	call backwardsSearch
	jr z,-
	ld a,b
	cp $04
	jr z,++
+
	ld a,GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED
	jp setGlobalFlag
++
	ld a,GLOBALFLAG_ALL_HOLLYS_SNOW_SHOVELLED
	jp unsetGlobalFlag
