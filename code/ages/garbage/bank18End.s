.ifdef INCLUDE_GARBAGE

.ifdef REGION_US
	; Leftovers from seasons
	.incbin {"{BUILD_DIR}/gfx/spr_credits_sprites_2.cmp"} SKIP 3+$1e
.endif ; REGION_US

.endif
