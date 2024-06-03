.ifdef INCLUDE_GARBAGE
	; Leftovers from seasons
	; @addr{799e}
	.incbin {"{BUILD_DIR}/gfx/spr_credits_sprites_2.cmp"} SKIP 1+$1e
.endif
