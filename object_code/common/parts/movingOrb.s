; ==================================================================================================
; PART_MOVING_ORB
;
; Variables:
;   var32: Dest Y position (from movement script)
;   var33: Dest X position (from movement script)
; ==================================================================================================
partCode0b:
	cp PARTSTATUS_JUST_HIT
	jr nz,@normalStatus

	; Just hit

	ld h,d
	ld l,Part.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a ; [oamFlags]

	ld l,Part.var03
	ld a,(wToggleBlocksState)
	xor (hl)
	ld (wToggleBlocksState),a
	ld l,Part.oamFlagsBackup
	ld a,(hl)
	dec a
	jr nz,+
	ld a,$02
+
	ldi (hl),a ; [oamFlagsBackup]
	ld (hl),a  ; [oamFlags]
	ld a,SND_SWITCH
	call playSound

@normalStatus:
	ld e,Part.state
	ld a,(de)
	sub $08
	jr c,@state0To7
	rst_jumpTable
	.dw @state8_up
	.dw @state9_right
	.dw @stateA_down
	.dw @stateB_left
	.dw @stateC_waiting

@state0To7:
.ifdef ROM_AGES
	ld hl,bank0e.orbMovementScript
.else
	ld hl,bank0d.orbMovementScript
.endif
	call objectLoadMovementScript

	ld h,d
	ld l,Part.var03
	ld b,$01
	ld a,(wToggleBlocksState)
	and (hl)
	jr z,+
	inc b
+
	ld a,b
	ld l,Part.oamFlagsBackup
	ldi (hl),a
	ld (hl),a  ; [oamFlags]
	jp objectSetVisible82

@state8_up:
	ld h,d
	ld e,Part.var32
	ld a,(de)
	ld l,Part.yh
	cp (hl)
	jp c,objectApplySpeed
	jr @runMovementScript

@state9_right:
	ld h,d
	ld e,Part.xh
	ld a,(de)
	ld l,Part.var33
	cp (hl)
	jp c,objectApplySpeed
	jr @runMovementScript

@stateA_down:
	ld h,d
	ld e,Part.yh
	ld a,(de)
	ld l,Part.var32
	cp (hl)
	jp c,objectApplySpeed
	jr @runMovementScript

@stateB_left:
	ld h,d
	ld e,Part.var33
	ld a,(de)
	ld l,Part.xh
	cp (hl)
	jp c,objectApplySpeed

@runMovementScript:
	ld a,(de)
	ld (hl),a
	jp objectRunMovementScript

@stateC_waiting:
	ld h,d
	ld l,Part.counter1
	dec (hl)
	ret nz
	jp objectRunMovementScript
