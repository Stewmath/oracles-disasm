; ==================================================================================================
; INTERAC_MOBLIN
; ==================================================================================================
interactionCode96:
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw objectSetVisible82
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
@@subid0:
	ld hl,table_57d0
--
	call func_57ba
	jr @state1
@@subid1:
	call objectSetVisible81
	ld hl,table_57d6
	jr --
@@subid3:
	ld a,$02
	call interactionSetAnimation
	jp objectSetVisible80
@@subid4:
	ld hl,mainScripts.script7421
	call interactionSetScript
	ld e,$43
	ld a,(de)
	or a
	jr z,+
	inc a
+
	inc a
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@@subid5:
@@subid6:
	ld e,$43
	ld a,(de)
	ld hl,table_57dc
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	call interactionSetScript
	ld e,$43
	ld a,(de)
	ld hl,@table_5630
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,$5c
	ld (de),a
	ld a,(hl)
	call interactionSetAnimation
	jp interactionAnimateAsNpc
@table_5630:
	.db $02 $08
	.db $02 $0a
	.db $01 $02
	.db $01 $02
@state1:
	ld e,$42
	ld a,(de)
	rst_jumpTable
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
@@subid0:
@@subid1:
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @@@substate0
	.dw @@@substate1
	.dw @@@substate2
	.dw @@@substate3
	.dw @@@substate4
	.dw @@@substate5
	.dw @@@substate6
	.dw @@@substate7
@@@substate0:
	ld hl,$cfd0
	ld a,(hl)
	cp $02
	jp z,func_5768
	inc a
	jp z,interactionDelete
	call interactionRunScript
	ld e,$42
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	ld e,$47
	ld a,(de)
	or a
	call nz,interactionAnimate
	ld e,$71
	ld a,(de)
	or a
	jr z,+
	xor a
	ld (de),a
	ld bc,TX_3801
	call showText
+
	call interactionAnimate
	jp objectPreventLinkFromPassing
@@@substate1:
	call interactionAnimate
	call interactionAnimate
	call interactionDecCounter1
	jp nz,objectApplyComponentSpeed
	ld a,$08
	call setLinkIDOverride
	ld l,$02
	ld (hl),$09
	jp interactionIncSubstate
@@@substate2:
	ld hl,$cfd1
	ld a,(hl)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionIncSubstate
	ld l,$42
	ld a,(hl)
	add $0b
	jp interactionSetAnimation
@@@substate3:
	call interactionAnimate
	ld e,$61
	ld a,(de)
	inc a
	ret nz
	jp interactionIncSubstate
@@@substate4:
	ld e,$42
	ld a,(de)
	inc a
	ld b,a
	ld hl,$cfd1
	ld a,(hl)
	cp b
	jp nz,npcFaceLinkAndAnimate
	call interactionIncSubstate
	ld l,$50
	ld (hl),$28
	ld l,$4d
	ld a,(hl)
	cp $50
	jr z,@@@func_56fe
	ld a,$18
	jr nc,+
	ld a,$08
+
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	jp interactionSetAnimation
@@@substate5:
	call objectApplySpeed
	cp $50
	jr nz,+
	call interactionIncSubstate
	ld l,$46
	ld (hl),$05
+
	call interactionAnimate
	jp interactionAnimate
@@@substate6:
	call interactionDecCounter1
	jp nz,interactionAnimate
@@@func_56fe:
	ld l,$45
	ld (hl),$07
	ld l,$49
	ld (hl),$10
	ld a,$02
	jp interactionSetAnimation
@@@substate7:
	call interactionAnimate
	call interactionAnimate
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	ld hl,$cfd1
	ld e,$42
	ld a,(de)
	add $02
	ld (hl),a
	jp interactionDelete
@@subid2:
	call interactionAnimate
	call checkInteractionSubstate
	jr nz,+
	call interactionDecCounter1
	ret nz
	ld l,$50
	ld (hl),$50
	jp interactionIncSubstate
+
	call interactionAnimate
	call interactionCode95@state1@func_557c
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	ret c
	jp interactionDelete
@@subid3:
	call interactionAnimate
	ld hl,$cfd0
	ld a,(hl)
	inc a
	ret nz
	jp interactionDelete
@@subid4:
@@subid5:
@@subid6:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
func_5768:
	call interactionIncSubstate
	ld l,$46
	ld (hl),$20
	ld l,$4b
	ld a,(hl)
	ld b,a
	ld hl,w1Link.yh
	ld a,(hl)
	sub b
	call func_57ad
	ld h,d
	ld l,$50
	ld (hl),c
	inc l
	ld (hl),b
	ld l,$4d
	ld a,(hl)
	ld b,a
	ld hl,w1Link.xh
	ld a,(hl)
	ld c,a
	ld e,$42
	ld a,(de)
	or a
	ld a,$0c
	jr nz,+
	ld a,$f4
+
	add c
	sub b
	call func_57ad
	ld h,d
	ld l,$52
	ld (hl),c
	inc l
	ld (hl),b
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call convertAngleDeToDirection
	dec e
	ld (de),a
	jp interactionSetAnimation
func_57ad:
	ld b,a
	ld c,$00
	ld a,$05
-
	sra b
	rr c
	dec a
	jr nz,-
	ret
func_57ba:
	push hl
	call getThisRoomFlags
	ld b,a
	xor a
	sla b
	adc $00
	sla b
	adc $00
	pop hl
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript
table_57d0:
	.dw mainScripts.script73f3
	.dw mainScripts.script73f3
	.dw mainScripts.script73f3
table_57d6:
	.dw mainScripts.script73f6
	.dw mainScripts.script73f6
	.dw mainScripts.script73f6
table_57dc:
	.dw mainScripts.script7443
	.dw mainScripts.script7456
	.dw mainScripts.script7469
	.dw mainScripts.script7469
