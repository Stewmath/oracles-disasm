; ==================================================================================================
; INTERAC_ZORA
;
; Variables:
;   var03: ?
;   var38: ?
; ==================================================================================================
interactionCodeab:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw zora_subid00
	.dw zora_subid01
	.dw zora_subid02
	.dw zora_subid03
	.dw zora_subid04
	.dw zora_subid05
	.dw zora_subid06
	.dw zora_subid07
	.dw zora_subid08
	.dw zora_subid09
	.dw zora_subid0A
	.dw zora_subid0B
	.dw zora_subid0C
	.dw zora_subid0D
	.dw zora_subid0E
	.dw zora_subid0F
	.dw zora_subid10
	.dw zora_subid11
	.dw zora_subid12
	.dw zora_subid13
	.dw zora_subid14
	.dw zora_subid15
	.dw zora_subid16
	.dw zora_subid17
	.dw zora_subid18
	.dw zora_subid19
	.dw zora_subid1A
	.dw zora_subid1B


zora_subid00:
zora_subid01:
zora_subid02:
zora_subid03:
zora_subid04:
zora_subid05:
zora_subid06:
zora_subid07:
zora_subid08:
zora_subid09:
zora_subid0F:
	call checkInteractionState
	jr z,@state0

@state1:
	call zora_getWorldState
	ld e,Interaction.subid
	ld a,(de)
	add a
	add a
	add b
	ld hl,zora_textIndices
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@state0:
	call zora_getWorldState
	ld a,b
	or a
	ld e,Interaction.subid
	ld a,(de)
	jr nz,++
	cp $06
	jp nc,interactionDelete
++
	ld hl,mainScripts.genericNpcScript

zora_commonInitWithScript:
	call interactionSetScript

zora_commonInit:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld l,Interaction.textID+1
	ld (hl),>TX_3400
	jp objectSetVisiblec2


zora_subid0C:
zora_subid0D:
	call checkInteractionState
	jr z,@state0

@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jr nc,++
	ld hl,wTmpcfc0.genericCutscene.state
	set 7,(hl)
++
	jp interactionAnimate

@state0:
	ld e,Interaction.speed
	ld a,SPEED_180
	ld (de),a
	ld e,Interaction.subid
	ld a,(de)
	cp $0c
	ld hl,mainScripts.zoraSubid0cScript
	jr z,zora_commonInitWithScript
	ld hl,mainScripts.zoraSubid0dScript
	jr zora_commonInitWithScript


zora_subid0A:
zora_subid0B:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	call zora_commonInit
	ld l,Interaction.counter1
	ld (hl),30
	ld l,Interaction.subid
	ldi a,(hl)
	sub $0a
	swap a
	rrca
	ld (hl),a ; [var03]
	ret

@state1:
	call interactionDecCounter1
	ret nz
	ld (hl),120 ; [counter1]
	inc l
	inc (hl) ; [counter2]
	jp interactionIncState

@state2:
	call interactionDecCounter1
	jr nz,++
	ld (hl),90
	ld a,$02
	call interactionSetAnimation
	jp interactionIncState
++
	inc l
	dec (hl) ; [counter2]
	ret nz

	ld (hl),20

	ld l,Interaction.var38
	ld a,(hl)
	inc a
	and $07
	ld (hl),a

	ld l,Interaction.var03
	add (hl)
	ld hl,@animationTable
	rst_addAToHl
	ld a,(hl)
	jp interactionSetAnimation

@animationTable:
	.db $00 $03 $01 $02 $00 $01 $03 $02
	.db $03 $01 $03 $00 $03 $02 $00 $01

@state3:
	call interactionDecCounter1
	jr nz,++
	ld hl,wTmpcfc0.genericCutscene.state
	set 7,(hl)
++
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	ld l,Interaction.speedZ
	ld a,<(-$180)
	ldi (hl),a
	ld (hl),>(-$180)
	ret


zora_subid10:
zora_subid11:
zora_subid12:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call objectSetVisible82
	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	sub $10
	ld b,a
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript

	ld a,b
	rst_jumpTable
	.dw @subid10
	.dw @subid11
	.dw @subid12

@subid10:
	call getThisRoomFlags
	and $20
	jp nz,interactionDelete
	ld a,(wEssencesObtained)
	bit 6,a
	jp z,interactionDelete
	ld a,$03
	call interactionSetAnimation
	jp interactionIncState

@subid11:
	call checkIsLinkedGame
	jp nz,interactionDelete
	jr @deleteIfFlagSet

@subid12:
	call checkIsLinkedGame
	jp z,interactionDelete

@deleteIfFlagSet:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ret

@scriptTable:
	.dw mainScripts.zoraSubid10Script
	.dw mainScripts.zoraSubid11And12Script
	.dw mainScripts.zoraSubid11And12Script

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate

@state2:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimate


zora_subid0E:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.textID+1
	ld (hl),>TX_3400
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld a,<TX_3433
	jr z,+
	ld a,<TX_3434
+
	ld e,Interaction.textID
	ld (de),a
	xor a
	call interactionSetAnimation
	call objectSetVisiblec2
	ld hl,mainScripts.zoraSubid0eScript
	jp interactionSetScript


zora_subid13:
zora_subid14:
zora_subid15:
zora_subid16:
zora_subid17:
zora_subid18:
zora_subid19:
zora_subid1A:
zora_subid1B:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@state0:
	call zora_commonInit
	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld b,$00
	jr z,+
	inc b
+
	ld e,Interaction.subid
	ld a,(de)
	sub $13
	add a
	add b
	ld hl,@textTable
	rst_addAToHl
	ld e,Interaction.textID
	ld a,(hl)
	ld (de),a
	ld hl,mainScripts.genericNpcScript
	jp interactionSetScript


; Table of text to show before/after water pollution is fixed for each zora
@textTable:
	.db <TX_3447, <TX_3448 ; $13 == [subid]
	.db <TX_3449, <TX_344a ; $14
	.db <TX_344b, <TX_344c ; $15
	.db <TX_3446, <TX_3446 ; $16
	.db <TX_3440, <TX_3441 ; $17
	.db <TX_3442, <TX_3443 ; $18
	.db <TX_3444, <TX_3445 ; $19
	.db <TX_344d, <TX_344d ; $1a
	.db <TX_344e, <TX_344e ; $1b

;;
; @param[out]	b	0 if king zora is uncured;
;			1 if he's cured;
;			2 if pollution is fixed;
;			3 if beat Jabu (except it's bugged and this doesn't happen)
zora_getWorldState:
	ld a,GLOBALFLAG_KING_ZORA_CURED
	call checkGlobalFlag
	ld b,$00
	ret z

	ld a,GLOBALFLAG_WATER_POLLUTION_FIXED
	call checkGlobalFlag
	ld b,$01
	ret z

	ld a,(wEssencesObtained)
	bit 6,a
	ld b,$02
	ret nc
	; BUG: this should be "ret z"

	inc b
	ret


; Text 0: Before healing king
; Text 1: After healing king
; Text 2: After fixing pollution
; Text 3: After beating jabu (bugged to never have this text read)
zora_textIndices:
	.db <TX_3410, <TX_3411, <TX_3412, <TX_3412 ; 0 == [subid]
	.db <TX_3413, <TX_3414, <TX_3414, <TX_3414 ; 1
	.db <TX_3415, <TX_3416, <TX_3416, <TX_3416 ; 2
	.db <TX_3417, <TX_3418, <TX_3419, <TX_3419 ; 3
	.db <TX_341a, <TX_341b, <TX_341b, <TX_341b ; 4
	.db <TX_3420, <TX_3421, <TX_3422, <TX_3423 ; 5
	.db <TX_3424, <TX_3424, <TX_3424, <TX_3424 ; 6
	.db <TX_3425, <TX_3425, <TX_3426, <TX_3426 ; 7
	.db <TX_3427, <TX_3427, <TX_3427, <TX_3427 ; 8
	.db <TX_3428, <TX_3428, <TX_3429, <TX_3429 ; 9
