; ==================================================================================================
; PART_ROOM_OF_RITES_FALLING_BOULDER
; ==================================================================================================
partCode54:
	ld e,$c2
	ld a,(de)
	or a
	ld e,$c4
	jp nz,func_7adb
	ld a,(de)
	or a
	jr z,func_7ad3
	call partCommon_decCounter1IfNonzero
	jp z,partDelete
	ld a,(hl)
	and $0f
	ret nz
	call getFreePartSlot
	ret nz
	ld (hl),PART_ROOM_OF_RITES_FALLING_BOULDER
	inc l
	inc (hl)
	ret
	
func_7ad3:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$96
	ret
	
func_7adb:
	ld a,(de)
	or a
	jr nz,func_7b0a
	inc a
	ld (de),a
	ldh a,(<hCameraY)
	ld b,a
	ldh a,(<hCameraX)
	ld c,a
	call getRandomNumber
	ld l,a
	and $07
	swap a
	add $28
	add c
	ld e,$cd
	ld (de),a
	ld a,l
	and $70
	add $08
	ld l,a
	add b
	ld e,$cb
	ld (de),a
	ld a,l
	cpl
	inc a
	sub $07
	ld e,$cf
	ld (de),a
	jp objectSetVisiblec1
	
func_7b0a:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	jp nz,partAnimate
	call objectReplaceWithAnimationIfOnHazard
	jr c,@delete
	ld b,INTERAC_ROCKDEBRIS
	call objectCreateInteractionWithSubid00
@delete:
	jp partDelete
