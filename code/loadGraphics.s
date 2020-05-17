;;
; @addr{4000}
initGbaModePaletteData:
	ld a,($ff00+R_SVBK)	; $4000
	push af			; $4002
	ld a,:w2GbaModePaletteData		; $4003
	ld ($ff00+R_SVBK),a	; $4005

	ld hl,_gbaModePaletteData	; $4007
	ld de,w2GbaModePaletteData		; $400a
	ld b,$80		; $400d
	call copyMemory		; $400f

	pop af			; $4012
	ld ($ff00+R_SVBK),a	; $4013
	ret			; $4015

;;
; Redraw dirty palettes
; @addr{4016}
refreshDirtyPalettes:
	ld a,$02		; $4016
	ld ($ff00+R_SVBK),a	; $4018

	ldh a,(<hDirtyBgPalettes)	; $401a
	ld d,a			; $401c
	ldh a,(<hBgPaletteSources)	; $401d
	ld e,a			; $401f
	ld l,<w2TilesetBgPalettes	; $4020
	call @refresh		; $4022

	ldh a,(<hDirtySprPalettes)	; $4025
	ld d,a			; $4027
	ldh a,(<hSprPaletteSources)	; $4028
	ld e,a			; $402a
	ld l,<w2TilesetSprPalettes	; $402b
;;
; @param d Bitset of dirty palettes
; @param e Bitset of where to get the palettes from
; @param l $80 for background, $c0 for sprites
; @addr{402d}
@refresh:
	ld a,d			; $402d
	or a			; $402e
	ret z			; $402f

	srl d			; $4030
	jr nc,@nextPalette	; $4032

	ld h,>w2TilesetBgPalettes	; $4034
	srl e			; $4036
	jr nc,+			; $4038

	; h = >w2FadingBgPalettes (or equivalently, >w2FadingSprPalettes)
	inc h			; $403a
+
	ldh a,(<hGameboyType)	; $403b
	inc a			; $403d
	jr nz,@gbcMode			; $403e

@gbaMode:
	call @gbaBrightenPalette		; $4040
	call @gbaBrightenPalette		; $4043
	call @gbaBrightenPalette		; $4046
	call @gbaBrightenPalette		; $4049
	jr @refresh	; $404c

@gbcMode:
	push de			; $404e
	ld b,>w2BgPalettesBuffer	; $404f
	ld c,l			; $4051
	res 7,c			; $4052
	ld e,$08		; $4054
-
	ldi a,(hl)		; $4056
	ld (bc),a		; $4057
	inc c			; $4058
	dec e			; $4059
	jr nz,-			; $405a

	pop de			; $405c
	jr @refresh	; $405d

@nextPalette:
	ld a,l			; $405f
	add $08			; $4060
	ld l,a			; $4062
	srl e			; $4063
	jr @refresh	; $4065

;;
; @addr{4067}
@gbaBrightenPalette:
	ldi a,(hl)		; $4067
	ld c,a			; $4068
	and $e0			; $4069
	ld b,a			; $406b
	ld a,(hl)		; $406c
	and $03			; $406d
	or b			; $406f
	swap a			; $4070
	ld b,a			; $4072
	ldd a,(hl)		; $4073
	and $7c			; $4074
	rrca			; $4076
	rrca			; $4077
	push hl			; $4078
	ld hl,w2GbaModePaletteData+$60		; $4079
	rst_addAToHl			; $407c
	ld a,b			; $407d
	ld b,(hl)		; $407e
	ld hl,w2GbaModePaletteData+$21		; $407f
	rst_addAToHl			; $4082
	ldd a,(hl)		; $4083
	or b			; $4084
	ld b,a			; $4085
	ld a,c			; $4086
	and $1f			; $4087
	ld c,(hl)		; $4089
	ld hl,w2GbaModePaletteData		; $408a
	rst_addAToHl			; $408d
	ld a,(hl)		; $408e
	or c			; $408f
	pop hl			; $4090
	ld c,h			; $4091
	res 7,l			; $4092
	ld h,$df		; $4094
	ldi (hl),a		; $4096
	ld a,b			; $4097
	ldi (hl),a		; $4098
	set 7,l			; $4099
	ld h,c			; $409b
	ret			; $409c

; @addr{409d}
_gbaModePaletteData:
	.db $00 $05 $07 $08 $0a $0b $0c $0e
	.db $10 $11 $12 $13 $14 $15 $16 $17
	.db $18 $19 $1a $1b $1b $1c $1c $1d
	.db $1d $1e $1e $1e $1f $1f $1f $1f
	.db $00 $00 $a0 $00 $e0 $00 $00 $01
	.db $40 $01 $60 $01 $80 $01 $c0 $01
	.db $00 $02 $20 $02 $40 $02 $60 $02
	.db $80 $02 $a0 $02 $c0 $02 $e0 $02
	.db $00 $03 $20 $03 $40 $03 $60 $03
	.db $60 $03 $80 $03 $80 $03 $a0 $03
	.db $a0 $03 $c0 $03 $c0 $03 $c0 $03
	.db $e0 $03 $e0 $03 $e0 $03 $e0 $03
	.db $00 $14 $1c $20 $28 $2c $30 $38
	.db $40 $44 $48 $4c $50 $54 $58 $5c
	.db $60 $64 $68 $6c $6c $70 $70 $74
	.db $74 $78 $78 $78 $7c $7c $7c $7c

;;
; @addr{411d}
_resumeThreadNextFrameIfLcdIsOn:
	ld a,($ff00+R_LCDC)	; $411d
	rlca			; $411f
	ret nc			; $4120

	call resumeThreadNextFrameAndSaveBank		; $4121
	ret			; $4124

;;
; Goes through wLoadedObjectGfx, and reloads each entry. This is called when closing
; the inventory screen and things like that.
; @addr{4125}
reloadObjectGfx:
	ld a,(wLoadedItemGraphic1)		; $4125
	or a			; $4128
	call nz,loadUncompressedGfxHeader		; $4129

	ld a,(wLoadedItemGraphic2)		; $412c
	or a			; $412f
	call nz,loadUncompressedGfxHeader		; $4130
agesFunc_3f_4133:
	ld hl,wLoadedObjectGfx		; $4133
--
	ldi a,(hl)		; $4136
	ld e,a			; $4137
	ld d,(hl)		; $4138
	dec l			; $4139
	or a			; $413a
	jr z,+			; $413b

	call _insertIndexIntoLoadedObjectGfx		; $413d
	call _resumeThreadNextFrameIfLcdIsOn		; $4140
+
	inc l			; $4143
	ld (hl),d		; $4144
	inc l			; $4145
	ld a,l			; $4146
	cp <wLoadedObjectGfxEnd			; $4147
	jr c,--			; $4149

	; Also reload the tree graphics

	ld hl,wLoadedTreeGfxActive	; $414b
	ld e,(hl)		; $414e
	ld (hl),$00		; $414f
	jp loadTreeGfx_body		; $4151

;;
; @addr{4154}
refreshObjectGfx_body:
	call _markAllLoadedObjectGfxUnused		; $4154

	; Re-check which object gfx indices are in use by checking all objects of
	; all types.

	; Check enemies
	ld d,FIRST_ENEMY_INDEX		; $4157
@nextEnemy:
	call _enemyGetObjectGfxIndex		; $4159
	call _markLoadedObjectGfxUsed		; $415c
	inc d			; $415f
	ld a,d			; $4160
	cp LAST_ENEMY_INDEX+1			; $4161
	jr c,@nextEnemy			; $4163

	; Check parts
	ld d,FIRST_PART_INDEX		; $4165
@nextPart:
	call _partGetObjectGfxIndex		; $4167
	call _markLoadedObjectGfxUsed		; $416a
	inc d			; $416d
	ld a,d			; $416e
	cp LAST_PART_INDEX+1			; $416f
	jr c,@nextPart			; $4171

	; Check interactions
	ld d,FIRST_INTERACTION_INDEX		; $4173
@nextInteraction:
	call _interactionGetObjectGfxIndex		; $4175
	call _markLoadedObjectGfxUsed		; $4178
	inc d			; $417b
	ld a,d			; $417c
	cp LAST_INTERACTION_INDEX+1			; $417d
	jr c,@nextInteraction			; $417f

	; Check items
	ld d,FIRST_ITEM_INDEX	; $4181
@nextItem:
	call _itemGetObjectGfxIndex		; $4183
	call _markLoadedObjectGfxUsed		; $4186
	inc d			; $4189
	ld a,d			; $418a
	cp LAST_ITEM_INDEX+1			; $418b
	jr c,@nextItem			; $418d

; Now check whether to load extra gfx for an interaction or enemy.

	ld a,(wEnemyIDToLoadExtraGfx)		; $418f
	or a			; $4192
	jr z,+			; $4193

	call _getObjectGfxIndexForEnemy		; $4195
	jr ++			; $4198
+
	ld hl,wInteractionIDToLoadExtraGfx		; $419a
	ldi a,(hl)		; $419d
	or a			; $419e
	ret z			; $419f
	ld e,(hl)		; $41a0
	ld (hl),$00		; $41a1
	call _getDataForInteraction		; $41a3
	ld a,(hl)		; $41a6
++
	call _addIndexToLoadedObjectGfx		; $41a7
	call _resumeThreadNextFrameIfLcdIsOn		; $41aa
	ld a,e			; $41ad
	call _findIndexInLoadedObjectGfx		; $41ae
	ld a,l			; $41b1
	sub <wLoadedObjectGfx			; $41b2
	srl a			; $41b4

@nextExtraGfxIndex:
	inc a			; $41b6
	and $07			; $41b7
	ld b,a			; $41b9
	ld hl,wLoadedObjectGfx+1		; $41ba
	rst_addDoubleIndex			; $41bd

	; Remember old values, they may need to be moved to another spot
	ldd a,(hl)		; $41be
	ld d,a			; $41bf
	ld c,(hl)		; $41c0
	inc e			; $41c1

	; Load the next gfx index
	call _insertIndexIntoLoadedObjectGfx		; $41c2

	; If there was something here before, reload it into another slot
	ld a,d			; $41c5
	or a			; $41c6
	jr z,+			; $41c7
	ld a,c			; $41c9
	push de			; $41ca
	call _addIndexToLoadedObjectGfx		; $41cb
	pop de			; $41ce
+
	call _updateTileIndexBaseForAllObjects		; $41cf

	; Check if bit 7 in the second parameter of objectGfxHeaderTable is set (indicating
	; the end of the data)
	ld d,$00		; $41d2
	ld hl,objectGfxHeaderTable+1		; $41d4
	add hl,de		; $41d7
	add hl,de		; $41d8
	add hl,de		; $41d9
	bit 7,(hl)		; $41da
	ld a,b			; $41dc
	jr z,@nextExtraGfxIndex			; $41dd

	ld (wLoadedObjectGfxIndex),a		; $41df
	xor a			; $41e2
	ld (wEnemyIDToLoadExtraGfx),a		; $41e3
	ld (wInteractionIDToLoadExtraGfx),a		; $41e6
	jp _incLoadedObjectGfxIndex		; $41e9

;;
; Forces an object gfx header to be loaded into slot 4 (address 0:8800). Handy way to load
; extra graphics, but uses up object slots. Used by the pirate ship and various things in
; seasons, but apparently unused in ages.
;
; @param	e	Object gfx header (minus 1)
; @addr{41ec}
loadObjectGfxHeaderToSlot4_body:
	push de			; $41ec
	call refreshObjectGfx_body		; $41ed
	pop de			; $41f0
	ld a,$03		; $41f1
	jr refreshObjectGfx_body@nextExtraGfxIndex			; $41f3

;;
; @param	e	Tree gfx index
; @addr{41f5}
loadTreeGfx_body:
	ld hl,wLoadedTreeGfxActive		; $41f5
	ld a,e			; $41f8
	cp (hl)			; $41f9
	ret z			; $41fa

	call _insertIndexIntoLoadedObjectGfx		; $41fb
	jp _resumeThreadNextFrameIfLcdIsOn		; $41fe

;;
; @addr{4201}
_updateTileIndexBaseForAllObjects:
	push bc			; $4201
	push de			; $4202
	push hl			; $4203

	; Enemies
	ld a,Enemy.enabled		; $4204
	ldh (<hActiveObjectType),a	; $4206
	ld d,FIRST_ENEMY_INDEX		; $4208
@nextEnemy:
	call _enemyGetObjectGfxIndex		; $420a
	call @updateTileIndexBase		; $420d
	inc d			; $4210
	ld a,d			; $4211
	cp LAST_ENEMY_INDEX+1			; $4212
	jr c,@nextEnemy	; $4214

	; Parts
	ld a,Part.enabled		; $4216
	ldh (<hActiveObjectType),a	; $4218
	ld d,FIRST_PART_INDEX		; $421a
@nextPart:
	call _partGetObjectGfxIndex		; $421c
	call @updateTileIndexBase		; $421f
	inc d			; $4222
	ld a,d			; $4223
	cp LAST_PART_INDEX+1			; $4224
	jr c,@nextPart	; $4226

	; Interactions
	ld a,Interaction.enabled		; $4228
	ldh (<hActiveObjectType),a	; $422a
	ld d,FIRST_DYNAMIC_INTERACTION_INDEX		; $422c
@nextInteraction:
	call _interactionGetObjectGfxIndex		; $422e
	call @updateTileIndexBase		; $4231
	inc d			; $4234
	ld a,d			; $4235
	cp LAST_INTERACTION_INDEX+1			; $4236
	jr c,@nextInteraction	; $4238

	; Items
	ld a,Item.enabled		; $423a
	ldh (<hActiveObjectType),a	; $423c
	ld d,FIRST_ITEM_INDEX		; $423e
@nextItem:
	call _itemGetObjectGfxIndex		; $4240
	call @updateTileIndexBase		; $4243
	inc d			; $4246
	ld a,d			; $4247
	cp LAST_ITEM_INDEX+1			; $4248
	jr c,@nextItem	; $424a

	call drawAllSpritesUnconditionally		; $424c
	call _resumeThreadNextFrameIfLcdIsOn		; $424f
	pop hl			; $4252
	pop de			; $4253
	pop bc			; $4254
	ret			; $4255

;;
; Updates the oamTileIndexBase for an object (after graphics may have changed places).
;
; @param	a	Object gfx index
; @param	d	Object index
; @addr{4256}
@updateTileIndexBase:
	or a			; $4256
	ret z			; $4257

	call _findIndexInLoadedObjectGfx		; $4258
	ldh a,(<hActiveObjectType)	; $425b
	ld e,a			; $425d
	ld a,(de)		; $425e
	or a			; $425f
	ret z			; $4260

	; If sprite uses vram bank 1, don't readjust oamTileIndexBase
	ld a,e			; $4261
	add Object.oamFlags			; $4262
	ld e,a			; $4264
	ld a,(de)		; $4265
	bit 3,a			; $4266
	ret nz			; $4268

	; e = Object.oamTileIndexBase
	inc e			; $4269
	ld a,(de)		; $426a
	and $1f			; $426b
	add c			; $426d
	ld (de),a		; $426e
	ret			; $426f

;;
; Finds the given object gfx index in wLoadedObjectGfx and marks it as in use, or
; sets the carry flag if it's not found.
;
; @param	a	Object gfx index
; @param[out]	c
; @param[out]	hl	Address where gfx is loaded (if it is loaded)
; @param[out]	cflag	nc if index is loaded
; @addr{4270}
_findIndexInLoadedObjectGfx:
	or a			; $4270
	ret z			; $4271

	ld hl,wLoadedObjectGfx		; $4272
	ld b,$08		; $4275
	ld c,a			; $4277
--
	ldi a,(hl)		; $4278
	cp c			; $4279
	jr z,+			; $427a

	inc l			; $427c
	dec b			; $427d
	jr nz,--		; $427e

	ld c,$01		; $4280
	scf			; $4282
	ret			; $4283
+
	ld (hl),$01		; $4284
	dec l			; $4286
	ld a,l			; $4287
	sub <wLoadedObjectGfx	; $4288
	swap a			; $428a
	ld c,a			; $428c
	ret			; $428d

;;
; Gets the first unused entry of wLoadedObjectGfx it finds?
; @param[out]	c	Relative position in wLoadedObjectGfx which is free
; @param[out]	hl
; @param[out]	cflag	Set on failure.
; @addr{428e}
_findUnusedIndexInLoadedObjectGfx:
	ld b,$08		; $428e
--
	call _getAddressOfLoadedObjectGfxIndex		; $4290
	inc l			; $4293
	ldd a,(hl)		; $4294
	or a			; $4295
	jr z,+			; $4296

	call _incLoadedObjectGfxIndex		; $4298
	dec b			; $429b
	jr nz,--		; $429c

	ld c,$01		; $429e
	scf			; $42a0
	ret			; $42a1
+
	ld a,l			; $42a2
	sub <wLoadedObjectGfx	; $42a3
	swap a			; $42a5
	ld c,a			; $42a7
	ret			; $42a8

;;
; @addr{42a9}
_incLoadedObjectGfxIndex:
	ld a,(wLoadedObjectGfxIndex)		; $42a9
	inc a			; $42ac
	and $07			; $42ad
	ld (wLoadedObjectGfxIndex),a		; $42af
	ret			; $42b2

;;
; Gets an address in wLoadedObjectGfx based on wLoadedObjectGfxIndex.
; @addr{42b3}
_getAddressOfLoadedObjectGfxIndex:
	ld a,(wLoadedObjectGfxIndex)		; $42b3
	ld hl,wLoadedObjectGfx		; $42b6
	rst_addDoubleIndex			; $42b9
	ret			; $42ba

;;
; Adds the given index into wLoadedObjectGfx if it's not in there already.
;
; @param	a	Object gfx index
; @param[out]	a	Relative position where it's placed in wLoadedObjectGfx
; @param[out]	cflag	Set if graphics were queued to be loaded and lcd is
;			currently on
; @addr{42bb}
_addIndexToLoadedObjectGfx:
	or a			; $42bb
	ret z			; $42bc

	push hl			; $42bd
	push bc			; $42be
	ld e,a			; $42bf
	call _findIndexInLoadedObjectGfx		; $42c0
	jr nc,+			; $42c3

	call _findUnusedIndexInLoadedObjectGfx		; $42c5
	call nc,_insertIndexIntoLoadedObjectGfx		; $42c8
+
	ld a,c			; $42cb
	pop bc			; $42cc
	pop hl			; $42cd
	ret			; $42ce

;;
; Adds index "e" into the wLoadedObjectGfx buffer at the specified position, or into
; wLoadedTreeGfx if that's what hl is pointing to.
;
; Also performs the actual loading of the gfx, and removes any duplicates in
; the list.
;
; @param	e	Object gfx index
; @param	hl	Address in wLoadedObjectGfx?
; @addr{42cf}
_insertIndexIntoLoadedObjectGfx:
	ld a,l			; $42cf
	cp <wLoadedTreeGfxActive		; $42d0
	jr nc,++		; $42d2

	; First, remove any references to it if it's already loaded (to prevent
	; redundancy)
	push hl			; $42d4
	ld hl,wLoadedObjectGfx		; $42d5
-
	ldi a,(hl)		; $42d8
	cp e			; $42d9
	jr nz,+			; $42da

	xor a			; $42dc
	ldd (hl),a		; $42dd
	ldi (hl),a		; $42de
+
	inc l			; $42df
	ld a,l			; $42e0
	cp <wLoadedObjectGfxEnd		; $42e1
	jr c,-			; $42e3

	pop hl			; $42e5
++
	push bc			; $42e6
	push de			; $42e7
	push hl			; $42e8
	ld (hl),e		; $42e9
	inc l			; $42ea
	ld (hl),$01		; $42eb
	dec l			; $42ed
	ld a,l			; $42ee
	cp <wLoadedTreeGfxActive	; $42ef
	jr c,@object		; $42f1

@tree:
	ld b,$92		; $42f3
	ld hl,treeGfxHeaderTable
	jr ++			; $42f8

@object:
	sub <wLoadedObjectGfx	; $42fa
	or $80			; $42fc
	ld b,a			; $42fe
	ld hl,objectGfxHeaderTable
++
	ld d,$00		; $4302
	add hl,de		; $4304
	add hl,de		; $4305
	add hl,de		; $4306
	call loadObjectGfx
	pop hl			; $430a
	pop de			; $430b
	pop bc			; $430c
	ret			; $430d

;;
; Mark a particular object gfx index as used. This doesn't insert the index into
; wLoadedObjectGfx if it's not found, though.
; @param a Object gfx index to mark as used
; @addr{430e}
_markLoadedObjectGfxUsed:
	or a			; $430e
	ret z			; $430f

	push bc			; $4310
	push hl			; $4311
	ld hl,wLoadedObjectGfx		; $4312
	ld c,a			; $4315
-
	ldi a,(hl)		; $4316
	cp c			; $4317
	jr z,@found		; $4318

	inc l			; $431a
	ld a,l			; $431b
	cp <wLoadedObjectGfxEnd	; $431c
	jr c,-		; $431e

	jr @end			; $4320

@found:
	ld (hl),$01		; $4322
@end:
	pop hl			; $4324
	pop bc			; $4325
	ret			; $4326

;;
; Sets the 2nd byte of every entry in the wLoadedObjectGfx buffer to $00,
; indicating that they are not being used.
; @addr{4327}
_markAllLoadedObjectGfxUnused:
	push bc			; $4327
	push hl			; $4328
	ld hl,wLoadedObjectGfx		; $4329
	ld b,$08		; $432c
	xor a			; $432e
-
	inc l			; $432f
	ldi (hl),a		; $4330
	dec b			; $4331
	jr nz,-			; $4332

	pop hl			; $4334
	pop bc			; $4335
	ret			; $4336

;;
; Get an enemy's gfx index, as well as a pointer to the rest of its data.
; @param[out]	a	Object gfx index
; @param[out]	hl	Pointer to 3 more bytes of enemy data
; @addr{4337}
_enemyGetObjectGfxIndex:
	ld e,Enemy.id		; $4337
	ld a,(de)		; $4339

;;
; @param	a	Enemy ID
; @addr{433a}
_getObjectGfxIndexForEnemy:
	push bc			; $433a
	add a			; $433b
	ld c,a			; $433c
	ld b,$00		; $433d
	ld hl,enemyData		; $433f
	add hl,bc		; $4342
	add hl,bc		; $4343
	pop bc			; $4344
	ldi a,(hl)		; $4345
	ret			; $4346

;;
; @param[out]	a	Object gfx index
; @param[out]	hl	Pointer to 7 more bytes of part data
; @addr{4347}
_partGetObjectGfxIndex:
	push bc			; $4347
	ld e,Part.id		; $4348
	ld a,(de)		; $434a
	call multiplyABy8		; $434b
	ld hl,partData		; $434e
	add hl,bc		; $4351
	pop bc			; $4352
	ldi a,(hl)		; $4353
	ret			; $4354

;;
; @addr{4355}
_interactionGetObjectGfxIndex:
	push bc			; $4355
	call _interactionGetData		; $4356
	pop bc			; $4359
	ldi a,(hl)		; $435a
	ret			; $435b

;;
; @addr{435c}
_itemGetObjectGfxIndex:
	ld e,Item.id		; $435c
	ld a,(de)		; $435e

	; a *= 3
	ld l,a			; $435f
	add a			; $4360
	add l			; $4361

	ld hl,itemData		; $4362
	rst_addAToHl			; $4365
	ldi a,(hl)		; $4366
	ret			; $4367

;;
; Loading an enemy?
; @addr{4368}
enemyLoadGraphicsAndProperties:
	call _enemyGetObjectGfxIndex		; $4368
	call _addIndexToLoadedObjectGfx		; $436b
	ld c,a			; $436e
	call c,_resumeThreadNextFrameIfLcdIsOn		; $436f
	ld e,Enemy.id		; $4372
	ld a,(de)		; $4374
	ld e,Enemy.collisionType		; $4375
	bit 7,(hl)		; $4377
	jr z,+			; $4379
	set 7,a			; $437b
+
	ld (de),a		; $437d

	; e = Enemy.enemyCollisionMode
	inc e			; $437e
	ldi a,(hl)		; $437f
	and $7f			; $4380
	ld (de),a		; $4382
	bit 7,(hl)		; $4383
	jr z,+			; $4385

	; If bit 7 is set, read the next 2 bytes as the address of a table.
	; Each entry in the table is for a particular subID. hl will be set to
	; [the table's start address] + (subID*2), or the first entry without
	; bit 7 set, whichever comes first.
	ldi a,(hl)		; $4387
	and $7f			; $4388
	ld l,(hl)		; $438a
	ld h,a			; $438b
	ld e,Enemy.subid	; $438c
	ld a,(de)		; $438e
	ld b,a			; $438f
	ld e,$00		; $4390
-
	bit 7,(hl)		; $4392
	jr z,+			; $4394

	ld a,e			; $4396
	cp b			; $4397
	jr z,+			; $4398

	inc hl			; $439a
	inc hl			; $439b
	inc e			; $439c
	jr -			; $439d
+
	ldi a,(hl)		; $439f
	push hl			; $43a0
	add a			; $43a1
	ld hl,extraEnemyData	; $43a2
	rst_addDoubleIndex			; $43a5
	ld e,$a6		; $43a6
	ldi a,(hl)		; $43a8
	ld (de),a		; $43a9
	inc e			; $43aa
	ldi a,(hl)		; $43ab
	ld (de),a		; $43ac
	inc e			; $43ad
	ldi a,(hl)		; $43ae
	ld (de),a		; $43af
	inc e			; $43b0
	ldi a,(hl)		; $43b1
	ld (de),a		; $43b2
	pop hl			; $43b3
	ld a,(hl)		; $43b4
	and $0f			; $43b5
	add a			; $43b7
	add c			; $43b8
	ld e,Enemy.oamTileIndexBase		; $43b9
	ld (de),a		; $43bb
	ld a,(hl)		; $43bc
	swap a			; $43bd
	and $0f			; $43bf
	dec e			; $43c1
	ld (de),a		; $43c2
	dec e			; $43c3
	ld (de),a		; $43c4
	xor a			; $43c5
	jp enemySetAnimation		; $43c6

;;
; Loading a part?
; @addr{43c9}
partLoadGraphicsAndProperties:
	call _partGetObjectGfxIndex		; $43c9
	call _addIndexToLoadedObjectGfx		; $43cc
	ld c,a			; $43cf
	call c,_resumeThreadNextFrameIfLcdIsOn		; $43d0
	ld e,Part.id		; $43d3
	ld a,(de)		; $43d5
	bit 7,(hl)		; $43d6
	jr z,+			; $43d8
	set 7,a			; $43da
+
	ld e,Part.collisionType		; $43dc
	ld (de),a		; $43de

	; e = Part.enemyCollisionMode
	inc e			; $43df
	ldi a,(hl)		; $43e0
	and $7f			; $43e1
	ld (de),a		; $43e3

	; e = Part.collisionRadiusY
	inc e			; $43e4
	ld a,(hl)		; $43e5
	swap a			; $43e6
	and $0f			; $43e8
	ld (de),a		; $43ea

	; e = Part.collisionRadiusX
	inc e			; $43eb
	ldi a,(hl)		; $43ec
	and $0f			; $43ed
	ld (de),a		; $43ef

	; e = Part.damage
	inc e			; $43f0
	ldi a,(hl)		; $43f1
	ld (de),a		; $43f2

	; e = Part.health
	inc e			; $43f3
	ldi a,(hl)		; $43f4
	ld (de),a		; $43f5

	ld e,Part.oamTileIndexBase		; $43f6
	ldi a,(hl)		; $43f8
	add c			; $43f9
	ld (de),a		; $43fa

	; e = Part.oamFlags
	dec e			; $43fb
	ldi a,(hl)		; $43fc
	ld (de),a		; $43fd

	; Also write to Part.oamFlagsBackup
	dec e			; $43fe
	ld (de),a		; $43ff

	xor a			; $4400
	jp partSetAnimation		; $4401

;;
; Load the object gfx index for an interaction, and get the values for the
; Interaction.oam variables.
;
; @param	d	Interaction index
; @param[out]	a	Initial animation index to use
; @addr{4404}
interactionLoadGraphics:
	call _interactionGetObjectGfxIndex		; $4404
	call _addIndexToLoadedObjectGfx		; $4407
	ld c,a			; $440a

	; If LCD is on and graphics are queued, wait until they're loaded
	call c,_resumeThreadNextFrameIfLcdIsOn		; $440b

	; Calculate Interaction.oamTileIndexBase, which is the offset to add to
	; the tile index of all sprites in its animation. "c" currently
	; contains the offset where the graphics are loaded.
	ldi a,(hl)		; $440e
	and $7f			; $440f
	add c			; $4411
	ld e,Interaction.oamTileIndexBase		; $4412
	ld (de),a		; $4414

	; Write palette into Interaction.oamFlags
	ld a,(hl)		; $4415
	swap a			; $4416
	and $0f			; $4418
	dec e			; $441a
	ld (de),a		; $441b

	; Also write it into Interaction.oamFlagsBackup
	dec e			; $441c
	ld (de),a		; $441d

	; Return the animation index to start on
	ld a,(hl)		; $441e
	and $0f			; $441f
	ret			; $4421

;;
; Same as above function, but for items.
; @param d Item index
; @addr{4422}
itemLoadGraphics:
	call _itemGetObjectGfxIndex		; $4422
	call _addIndexToLoadedObjectGfx		; $4425
	ld c,a			; $4428

	; If LCD is on and graphics are queued, wait until they're loaded
	call c,_resumeThreadNextFrameIfLcdIsOn		; $4429

	; Calculate Item.oamTileIndexBase
	ldi a,(hl)		; $442c
	add c			; $442d
	ld e,Item.oamTileIndexBase		; $442e
	ld (de),a		; $4430

	; Write palette / flags into Item.oamFlags
	ld a,(hl)		; $4431
	dec e			; $4432
	ld (de),a		; $4433

	; Also write it into Item.oamFlagsBackup
	dec e			; $4434
	ld (de),a		; $4435
	ret			; $4436

;;
; @addr{4437}
_interactionGetData:
	ld h,d			; $4437
	ld l,Interaction.id		; $4438
	ldi a,(hl)		; $443a
	ld e,(hl)		; $443b

;;
; @param	a	Interaction ID
; @param	e	Interaction subID
; @addr{443c}
_getDataForInteraction:
	ld c,a			; $443c
	ld b,$00		; $443d
	ld hl,interactionData+1	; $443f
	add hl,bc		; $4442
	add hl,bc		; $4443
	add hl,bc		; $4444
	ldd a,(hl)		; $4445
	rlca			; $4446
	ret nc			; $4447

	ldi a,(hl)		; $4448
	inc hl			; $4449
	ld h,(hl)		; $444a
	ld l,a			; $444b
	ld c,$03		; $444c

	; a = subID
	ld a,e			; $444e
	or a			; $444f
	ret z			; $4450
-
	inc hl			; $4451
	bit 7,(hl)		; $4452
	dec hl			; $4454
	ret nz			; $4455

	add hl,bc		; $4456
	dec a			; $4457
	jr nz,-			; $4458
	ret			; $445a

;;
; @param e Uncompressed gfx header to load
; @addr{445b}
loadWeaponGfx:
	ld hl,wLoadedItemGraphic1		; $445b
	ld a,e			; $445e
	cp UNCMP_GFXH_1a			; $445f
	jr nc,+			; $4461
	inc l			; $4463
+
	cp (hl)			; $4464
	ret z			; $4465

	ld (hl),a		; $4466
	push de			; $4467
	call loadUncompressedGfxHeader		; $4468
	pop de			; $446b
	ret			; $446c
