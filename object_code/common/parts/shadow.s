; ==================================================================================================
; PART_SHADOW
;
; Variables:
;   relatedObj1: Object that this shadow is for
;   var30: ID of relatedObj1 (deletes self if it changes)
; ==================================================================================================
partCode07:
	ld e,Part.state
	ld a,(de)
	or a
	call z,@initialize

	; If parent's ID changed, delete self
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(de)
	cp (hl)
	jp nz,partDelete

	; Take parent's position, with offset
	ld a,Object.yh
	call objectGetRelatedObject1Var
	ld e,Part.var03
	ld a,(de)
	ld b,a
	ld c,$00
	call objectTakePositionWithOffset

	xor a
	ld (de),a ; [this.zh] = 0

	ld a,(hl) ; [parent.zh]
	or a
	jp z,objectSetInvisible

	; Flicker visibility
	ld e,Part.visible
	ld a,(de)
	xor $80
	ld (de),a

	ld e,Part.subid
	ld a,(de)
	add a
	ld bc,@animationIndices
	call addDoubleIndexToBc

	; Set shadow size based on how close the parent is to the ground
	ld a,(hl) ; [parent.zh]
	cp $e0
	jr nc,@setAnim
	inc bc
	cp $c0
	jr nc,@setAnim
	inc bc
	cp $a0
	jr nc,@setAnim
	inc bc

@setAnim:
	ld a,(bc)
	jp partSetAnimation

@animationIndices:
	.db $01 $01 $00 $00 ; Subid 0
	.db $02 $01 $01 $00 ; Subid 1
	.db $03 $02 $01 $00 ; Subid 2

@initialize:
	inc a
	ld (de),a ; [state] = 1

	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Part.var30
	ld a,(hl)
	ld (de),a

	jp objectSetVisible83
