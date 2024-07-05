; ==================================================================================================
; INTERAC_COMPANION_SCRIPTS
; ==================================================================================================
interactionCode71:
	ld a,(wLinkDeathTrigger)
	or a
	jr z,+
	xor a
	ld (wDisabledObjects),a
	jp interactionDelete
+
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw companionScript_subid00
	.dw companionScript_subid01
	.dw companionScript_subid02
	.dw companionScript_subid03
	.dw companionScript_subid04
	.dw companionScript_subid05
	.dw companionScript_subid06
	.dw companionScript_subid07
	.dw companionScript_subid08
	.dw companionScript_subid09

; Ricky running off after jumping up cliff in North Horon
companionScript_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
@state0:
	ld a,$01
	ld (de),a
	ld a,($cc48)
	and $01
	jr z,companionScript_delete
	ld a,($d101)
	cp $0b
	jr nz,companionScript_delete
	ld a,(wAnimalCompanion)
	cp $0b
	jp z,interactionDelete
	ld a,$0a
	ld hl,$d104
	ldi (hl),a
	ld l,$03
	ld a,$02
	ld (hl),a
	ld l,$30
	ld a,(hl)
	ld l,$3f
	ld (hl),a
	ld hl,mainScripts.companionScript_RickyLeavingYouInSpoolSwamp
	jp interactionSetScript

; Moosh being bullied in Spool
companionScript_subid01:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
	.dw companionScript_giveFlute
	.dw companionScriptFunc_6eaf
@state0:
	ld a,($d101)
	cp $0d
	jr nz,companionScript_delete
	ld a,(wAnimalCompanion)
	cp $0d
	jr nz,companionScript_delete
	ld a,$01
	ld (de),a
	ld e,$79
	ld a,$0d
	ld (de),a
	call companionScript_setSubId0AndInitGraphics
	ld e,$42
	ld a,$01
	ld (de),a
	ld a,$1c
	ld e,$4b
	ld (de),a
	ld a,$2c
	ld e,$4d
	ld (de),a
	ld hl,mainScripts.companionScript_mooshInSpoolSwamp
	call interactionSetScript
	ld a,(wMooshState)
	bit 5,a
	jr nz,companionScript_delete
	or a
	ld a,$01
	ld ($ccf4),a
	ret nz
	jp interactionAnimateAsNpc

companionScript_runScriptDeleteWhenDone:
	call interactionRunScript
	ret nc
	call setStatusBarNeedsRefreshBit1
companionScript_delete:
	jp interactionDelete

; Sunken city entrance
companionScript_subid02:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,(wLinkObjectIndex)
	and $01
	jr z,companionScript_delete
	ld a,($d101)
	cp SPECIALOBJECT_RICKY
	jr z,@func_6d72
	cp SPECIALOBJECT_MOOSH
	jr nz,companionScript_delete
	ld a,$0a
	ld hl,$d104
	ldi (hl),a
	ld l,$03
	ld a,$08
	ld (hl),a
	ld l,$3f
	ld (hl),$14
	ld hl,mainScripts.companionScript_mooshEnteringSunkenCity
	jp interactionSetScript
@func_6d72:
	ld hl,$d104
	ld a,$0a
	ldi (hl),a
	ld l,$03
	ld a,$09
	ld (hl),a
	jr companionScript_delete
@state1:
	call interactionRunScript
	jr c,companionScript_delete
	ret

; Moosh in Mt Cucco
companionScript_subid06:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,(wMooshState)
	and $80
	jr nz,companionScript_delete
	ld a,$01
	ld (de),a
	ld a,$1c
	ld e,$4b
	ld (de),a
	ld a,$2c
	ld e,$4d
	ld (de),a
	ld a,TREASURE_SPRING_BANANA
	call checkTreasureObtained
	ld a,$00
	rla
	ld e,$78
	ld (de),a
	ld hl,mainScripts.companionScript_mooshInMtCucco
	jp interactionSetScript
@state1:
	ld a,($d13d)
	or a
	jr z,@goToRunScriptThenDelete
	ld e,$78
	ld a,(de)
	or a
	jr z,@goToRunScriptThenDelete
	ld e,$7a
	ld a,(de)
	or a
	jr nz,@goToRunScriptThenDelete
	inc a
	ld (de),a
	ld ($cc02),a
	ld hl,$d000
	call objectTakePosition
	ld a,($d10b)
	ld b,a
	ld a,($d10d)
	ld c,a
	call objectGetRelativeAngle
	ld e,$49
	ld (de),a
	ld a,$02
	ld ($d108),a
	add $01
	ld ($d13f),a
@goToRunScriptThenDelete:
	jp companionScript_runScriptDeleteWhenDone
@state2:
	ld h,d
	ld l,$5a
	bit 7,(hl)
	jr nz,++
	ld l,$50
	ld (hl),$32
	ld bc,$fec0
	call objectSetSpeedZ
	call objectSetVisible80
	call companionScript_setSubId0AndInitGraphics
	ld a,$06
	ld e,Interaction.subid
	ld (de),a
	ld e,$46
	ld a,$10
	ld (de),a
++
	call retIfTextIsActive
	ld c,$40
	call objectUpdateSpeedZ_paramC
	jp nz,objectApplySpeed
	call interactionDecCounter1
	ret nz
	ld l,$44
	dec (hl)
	ld a,TREASURE_SPRING_BANANA
	call loseTreasure
	jp objectSetInvisible

; Ricky in North Horon
companionScript_subid03:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
	.dw @state2
	.dw companionScriptFunc_6eaf
@state0:
	ld a,(wRickyState)
	and $80
	jp nz,companionScript_delete2
	ld a,$01
	ld (de),a
	ld e,$79
	ld a,$0b
	ld (de),a
	call interactionSetAlwaysUpdateBit
	ld hl,mainScripts.companionScript_RickyInNorthHoron
	jp interactionSetScript
@state2:
	ld a,TREASURE_RICKY_GLOVES
	call loseTreasure
companionScript_giveFlute:
	ld a,$01
	ld ($cc02),a
	call interactionIncState
	ld e,$79
	ld a,(de)
	ld c,a
	cp $0d
	jr z,+
	ld hl,wLastAnimalMountPointY
	rst_addAToHl
	set 7,(hl)
+
	ld a,c
	ld hl,wAnimalCompanion
	cp (hl)
	ret nz
	sub $0a
	ld l,<wFluteIcon
	ld (hl),a
	ld a,(de)
	ld c,a
	ld a,TREASURE_FLUTE
	call giveTreasure
	ld hl,$cbea
	set 0,(hl)
	ld e,Interaction.subid
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,$03
	ld (de),a
	ld e,$79
	ld a,(de)
	sub $0a
	ld c,a
	and $01
	add a
	xor c
	ld e,$5c
	ld (de),a
	ld hl,$cc6a
	ld a,$04
	ldi (hl),a
	ld (hl),$01
	ld hl,$d000
	ld bc,$f200
	call objectTakePositionWithOffset
	call objectSetVisible80
	jp interactionRunScript

companionScriptFunc_6eaf:
	call retIfTextIsActive
	ld ($cca4),a
	call objectSetInvisible
	ld a,($cc48)
	and $0f
	add a
	swap a
	ld ($cca4),a
	call interactionRunScript
	ret nc
	xor a
	ld ($cca4),a
	ld ($cc02),a
	jr companionScript_delete2

; Dimitri in Spool Swamp
companionScript_subid04:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
	.dw companionScript_giveFlute
	.dw companionScriptFunc_6eaf
@state0:
	ld a,(wDimitriState)
	and $80
	jr nz,companionScript_delete2
	ld a,(wAnimalCompanion)
	cp $0c
	jr nz,companionScript_delete2
	ld a,$01
	ld (de),a
	ld e,$79
	ld a,$0c
	ld (de),a
	ld hl,mainScripts.companionScript_dimitriInSpoolSwamp
	jp interactionSetScript

; Dimitri being bullied
companionScript_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw companionScript_runScriptDeleteWhenDone
@state0:
	ld a,(wDimitriState)
	and $80
	jr nz,companionScript_delete2
	ld a,(wAnimalCompanion)
	cp $0c
	jr z,companionScript_delete2
	ld a,$01
	ld (de),a
	ld hl,mainScripts.companionScript_dimitriBeingBullied
	jp interactionSetScript

; Moblin rest house
companionScript_subid07:
	ld a,(wDimitriState)
	or $20
	ld (wDimitriState),a
companionScript_delete2:
	jp interactionDelete

; Sunken city entrance
companionScript_subid08:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	ld a,($d101)
	cp SPECIALOBJECT_DIMITRI
	jr nz,companionScript_delete2
	ld a,(wAnimalCompanion)
	cp SPECIALOBJECT_DIMITRI
	jr z,companionScript_delete2
@state1:
	ld a,($cd00)
	and $0e
	ret nz
	ld hl,$d10b
	ldi a,(hl)
	cp $50
	ret nc
	cp $30
	ret c
	inc l
	ld a,(hl)
	cp $10
	ret nc
	ld a,$10
	ld (hl),a
	ld l,$04
	ld a,(hl)
	cp $08
	jr z,+
	cp $02
	jr nz,+
	ld (hl),$01
	call dropLinkHeldItem
+
	ld l,$04
	ld (hl),$0d
	ld bc,TX_211e
	jp showText

; 1st screen of North Horon from Eyeglass lake area
companionScript_subid09:
	ld h,>wc600Block
	call checkIsLinkedGame
	jr nz,+
	ld a,TREASURE_FLUTE
	call checkTreasureObtained
	jr c,+
	ld l,<wAnimalCompanion
	ld (hl),SPECIALOBJECT_RICKY
+
	ld l,<wRickyState
	set 5,(hl)
	jr companionScript_delete2

companionScript_setSubId0AndInitGraphics:
	ld e,Interaction.subid
	xor a
	ld (de),a
	jp interactionInitGraphics
