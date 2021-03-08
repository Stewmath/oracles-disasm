; Pick one. (For now, the regions other than "US" only activate code changes, not asset changes, and
; they aren't complete.)
;.define REGION_JP
.define REGION_US
;.define REGION_EU


; "AGES_ENGINE" is like "ROM_AGES", but anything wrapped in this define could potentially be used in
; Seasons as well. Generally this enables extra engine features added in Ages. However, it could
; also cause subtle differences in how certain things work.
; I might enable this by default in the hack-base branch for seasons.
.ifdef ROM_AGES
	.define AGES_ENGINE
.endif

