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


; Uncomment this to enable bugfixes (even some that weren't in any release).
;.define ENABLE_BUGFIXES


; US/EU versions had many bugfixes. Enable them with either the "REGION_US"/REGION_EU" defines, or
; the "ENABLE_BUGFIXES" define. "ENABLE_BUGFIXES" will also enable bugfixes that were not present
; in any release.
.ifdef REGION_US
	.define ENABLE_US_BUGFIXES
.endif
.ifdef REGION_EU
	.define ENABLE_EU_BUGFIXES
.endif
.ifdef ENABLE_BUGFIXES
	.ifndef ENABLE_US_BUGFIXES
		.define ENABLE_US_BUGFIXES
	.endif
	.ifndef ENABLE_EU_BUGFIXES
		.define ENABLE_EU_BUGFIXES
	.endif
.endif
