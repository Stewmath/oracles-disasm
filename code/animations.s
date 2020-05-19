;;
; @addr{58e4}
initializeAnimations:
	ld a,(wTilesetAnimation)
	cp $ff
	ret z

	call loadAnimationData
.ifdef ROM_AGES
	call @locFunc
	ld hl,wAnimationState
	set 7,(hl)
	call @locFunc
	ld hl,wAnimationState
	set 7,(hl)
.endif
@locFunc:
	call updateAnimationData
-
	call updateAnimationQueue
	jr nz, -
	ret

;;
; @addr{5906}
updateAnimations:
	ld hl,wAnimationState
	res 6,(hl)
	ld a,(wTilesetAnimation)
	inc a
	ret z

	ld a,(wScrollMode)
	and $01
	ret z

	call updateAnimationQueue
	jr updateAnimationData

;;
; Read the next index off of the animation queue, set zero flag if there's
; nothing more to be read.
; @addr{591b}
updateAnimationQueue:
	ld a,(wAnimationQueueHead)
	ld b,a
	ld a,(wAnimationQueueTail)
	cp b
	ret z

	inc b
	ld a,b
	and $1f
	ld (wAnimationQueueHead),a
	ld hl,w2AnimationQueue
	rst_addAToHl
	ld a,:w2AnimationQueue
	ld ($ff00+R_SVBK),a
	ld b,(hl)
	xor a
	ld ($ff00+R_SVBK),a
	ld a,b
	call loadAnimationGfxIndex
	ld hl,wAnimationState
	set 6,(hl)
	or h
	ret

;;
; @addr{5942}
updateAnimationData:
	ld hl,wAnimationCounter1
	ld a,(wAnimationState)
	bit 0,a
	call nz,updateAnimationDataPointer
	ld hl,wAnimationCounter2
	ld a,(wAnimationState)
	bit 1,a
	call nz,updateAnimationDataPointer
	ld hl,wAnimationCounter3
	ld a,(wAnimationState)
	bit 2,a
	call nz,updateAnimationDataPointer
	ld hl,wAnimationCounter4
	ld a,(wAnimationState)
	bit 3,a
	call nz,updateAnimationDataPointer

	; Unset force update bit
	ld a,(wAnimationState)
	and $7f
	ld (wAnimationState),a
	ret

;;
; Update animation data pointed to by hl
; @addr{5977}
updateAnimationDataPointer:
	; If bit 7 set, force update
	ld a,(wAnimationState)
	bit 7,a
	jr nz, +

	; Otherwise, decrement counter
	dec (hl)
	ret nz
+
	; Load hl with a pointer to the animationData structure
	push hl
	inc hl
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	; e = animation gfx index
	ld e,(hl)
	inc hl
	; If next byte is 0xff, it jumps several bytes back, otherwise the data
	; structure continues
	ldi a,(hl)
	cp $ff
	jr nz, +
	ld b,a
	ld c,(hl)
	add hl,bc
	ldi a,(hl)
+
	ld c,l
	ld b,h
	pop hl
	ldi (hl),a
	ld (hl),c
	inc hl
	ld (hl),b

	; Set animation index to be loaded
	ld b,e
	ld a,(wAnimationQueueTail)
	inc a
	and $1f
	ld e,a
	ld a,(wAnimationQueueHead)
	cp e
	ret z

	ld a,e
	ld (wAnimationQueueTail),a
	ld a,:w2AnimationQueue
	ld ($ff00+R_SVBK),a
	ld a,e
	ld hl,w2AnimationQueue
	rst_addAToHl
	ld (hl),b
	xor a
	ld ($ff00+R_SVBK),a
	or h
	ret

;;
; Load animation index a
; @addr{59b7}
loadAnimationGfxIndex:
	ld c,$06
	call multiplyAByC
	ld bc, animationGfxHeaders
	add hl,bc
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	push de
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	ld b,(hl)
	pop hl
	jp queueDmaTransfer
