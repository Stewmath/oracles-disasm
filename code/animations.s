;;
; @addr{58e4}
initializeAnimations:
	ld a,(wTilesetAnimation)		; $58e4
	cp $ff			; $58e7
	ret z			; $58e9

	call loadAnimationData		; $58ea
.ifdef ROM_AGES
	call @locFunc		; $58ed
	ld hl,wAnimationState		; $58f0
	set 7,(hl)		; $58f3
	call @locFunc		; $58f5
	ld hl,wAnimationState		; $58f8
	set 7,(hl)		; $58fb
.endif
@locFunc:
	call updateAnimationData		; $58fd
-
	call updateAnimationQueue		; $5900
	jr nz, -
	ret			; $5905

;;
; @addr{5906}
updateAnimations:
	ld hl,wAnimationState		; $5906
	res 6,(hl)		; $5909
	ld a,(wTilesetAnimation)		; $590b
	inc a			; $590e
	ret z			; $590f

	ld a,(wScrollMode)		; $5910
	and $01			; $5913
	ret z			; $5915

	call updateAnimationQueue		; $5916
	jr updateAnimationData		; $5919

;;
; Read the next index off of the animation queue, set zero flag if there's
; nothing more to be read.
; @addr{591b}
updateAnimationQueue:
	ld a,(wAnimationQueueHead)		; $591b
	ld b,a			; $591e
	ld a,(wAnimationQueueTail)		; $591f
	cp b			; $5922
	ret z			; $5923

	inc b			; $5924
	ld a,b			; $5925
	and $1f			; $5926
	ld (wAnimationQueueHead),a		; $5928
	ld hl,w2AnimationQueue		; $592b
	rst_addAToHl			; $592e
	ld a,:w2AnimationQueue
	ld ($ff00+R_SVBK),a	; $5931
	ld b,(hl)		; $5933
	xor a			; $5934
	ld ($ff00+R_SVBK),a	; $5935
	ld a,b			; $5937
	call loadAnimationGfxIndex		; $5938
	ld hl,wAnimationState		; $593b
	set 6,(hl)		; $593e
	or h			; $5940
	ret			; $5941

;;
; @addr{5942}
updateAnimationData:
	ld hl,wAnimationCounter1		; $5942
	ld a,(wAnimationState)		; $5945
	bit 0,a			; $5948
	call nz,updateAnimationDataPointer		; $594a
	ld hl,wAnimationCounter2		; $594d
	ld a,(wAnimationState)		; $5950
	bit 1,a			; $5953
	call nz,updateAnimationDataPointer		; $5955
	ld hl,wAnimationCounter3		; $5958
	ld a,(wAnimationState)		; $595b
	bit 2,a			; $595e
	call nz,updateAnimationDataPointer		; $5960
	ld hl,wAnimationCounter4		; $5963
	ld a,(wAnimationState)		; $5966
	bit 3,a			; $5969
	call nz,updateAnimationDataPointer		; $596b

	; Unset force update bit
	ld a,(wAnimationState)		; $596e
	and $7f			; $5971
	ld (wAnimationState),a		; $5973
	ret			; $5976

;;
; Update animation data pointed to by hl
; @addr{5977}
updateAnimationDataPointer:
	; If bit 7 set, force update
	ld a,(wAnimationState)		; $5977
	bit 7,a			; $597a
	jr nz, +

	; Otherwise, decrement counter
	dec (hl)		; $597e
	ret nz			; $597f
+
	; Load hl with a pointer to the animationData structure
	push hl			; $5980
	inc hl			; $5981
	ldi a,(hl)		; $5982
	ld h,(hl)		; $5983
	ld l,a			; $5984

	; e = animation gfx index
	ld e,(hl)		; $5985
	inc hl			; $5986
	; If next byte is 0xff, it jumps several bytes back, otherwise the data
	; structure continues
	ldi a,(hl)		; $5987
	cp $ff			; $5988
	jr nz, +
	ld b,a			; $598c
	ld c,(hl)		; $598d
	add hl,bc		; $598e
	ldi a,(hl)		; $598f
+
	ld c,l			; $5990
	ld b,h			; $5991
	pop hl			; $5992
	ldi (hl),a		; $5993
	ld (hl),c		; $5994
	inc hl			; $5995
	ld (hl),b		; $5996

	; Set animation index to be loaded
	ld b,e			; $5997
	ld a,(wAnimationQueueTail)		; $5998
	inc a			; $599b
	and $1f			; $599c
	ld e,a			; $599e
	ld a,(wAnimationQueueHead)		; $599f
	cp e			; $59a2
	ret z			; $59a3

	ld a,e			; $59a4
	ld (wAnimationQueueTail),a		; $59a5
	ld a,:w2AnimationQueue
	ld ($ff00+R_SVBK),a	; $59aa
	ld a,e			; $59ac
	ld hl,w2AnimationQueue		; $59ad
	rst_addAToHl			; $59b0
	ld (hl),b		; $59b1
	xor a			; $59b2
	ld ($ff00+R_SVBK),a	; $59b3
	or h			; $59b5
	ret			; $59b6

;;
; Load animation index a
; @addr{59b7}
loadAnimationGfxIndex:
	ld c,$06		; $59b7
	call multiplyAByC		; $59b9
	ld bc, animationGfxHeaders
	add hl,bc		; $59bf
	ldi a,(hl)		; $59c0
	ld c,a			; $59c1
	ldi a,(hl)		; $59c2
	ld d,a			; $59c3
	ldi a,(hl)		; $59c4
	ld e,a			; $59c5
	push de			; $59c6
	ldi a,(hl)		; $59c7
	ld d,a			; $59c8
	ldi a,(hl)		; $59c9
	ld e,a			; $59ca
	ld b,(hl)		; $59cb
	pop hl			; $59cc
	jp queueDmaTransfer		; $59cd
