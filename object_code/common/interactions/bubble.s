; ==================================================================================================
; INTERAC_BUBBLE
;
; Variables:
;   var30: Value to add to angle
;   var31: Number of times to add [var30] to angle before switching direction
; ==================================================================================================
interactionCode91:
	ld e,Interaction.subid
	ld a,(de)
	or a
	ld e,Interaction.state
	ld a,(de)
	jp nz,@subid01

@subid00:
	or a
	jr z,@@state0

@@state1:
	call @checkDelete
	jp c,interactionDelete

	call objectApplySpeed
	ld e,Interaction.yh
	ld a,(de)
	cp $f0
	jp nc,interactionDelete

	call interactionDecCounter1
	ret nz

	ld (hl),$04
	ld l,Interaction.var31
	dec (hl)
	jr nz,++

	ld (hl),$08
	ld l,Interaction.var30
	ld a,(hl)
	cpl
	inc a
	ld (hl),a
++
	ld e,Interaction.angle
	ld a,(de)
	ld l,Interaction.var30
	add (hl)
	and $1f
	ld (de),a
	ret

@@state0:
	call @checkDelete
	jp c,interactionDelete

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.speed
	ld (hl),SPEED_80

	ld l,Interaction.counter1
	ld a,$04
	ldi (hl),a
	ld (hl),180 ; [counter2] = 180

	ld l,Interaction.var31
	inc a
	ldd (hl),a
	call getRandomNumber
	and $01
	jr nz,+
	dec a
+
	ld (hl),a
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp nz,objectSetVisible83

@randomNumberFrom0To4:
	call getRandomNumber_noPreserveVars
	and $07
	cp $05
	jr nc,@randomNumberFrom0To4

	; Set random initial angle
	sub $02
	and $1f
	ld e,Interaction.angle
	ld (de),a
	jp objectSetVisible81

@subid01:
	or a
	jr z,@@state0

@@state1:
	ld a,Object.collisionType
	call objectGetRelatedObject1Var
	bit 7,(hl)
	jp z,interactionDelete
	call objectTakePosition
	call interactionDecCounter1
	ret nz
	ld (hl),90
	ld b,INTERAC_BUBBLE
	jp objectCreateInteractionWithSubid00

@@state0:
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),30
	ret

;;
; @param[out]	cflag	c if bubble should be deleted (no longer in water)
@checkDelete:
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jp nz,@@sidescrolling

@@topDown:
	call interactionDecCounter2
	ld a,(hl)
	cp 60
	ret nc
	or a
	scf
	ret z

	; In last 60 frames, flicker
	ld l,Interaction.visible
	ld a,(hl)
	xor $80
	ld (hl),a
	ret

@@sidescrolling:
	; Check if it's still in water
	call objectGetTileAtPosition
	ld hl,hazardCollisionTable
	call lookupCollisionTable
	ccf
	ret
