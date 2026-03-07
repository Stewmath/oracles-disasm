; This file should be the first thing included in any of the main code files (ages.s, seasons.s, and
; audio.s). It is included at the top of "constants.s" for this reason.


; Pick one. (For now, the regions other than "US" only activate code changes, not asset changes, and
; they aren't complete.)
;.define REGION_JP
.define REGION_US
;.define REGION_EU


; FORCE_SECTIONS causes all sections to be of type "FORCE", preventing the linker from moving them.
; This will allow us to build a vanilla ROM.
.if defined(BUILD_VANILLA) && !defined(FORCE_SECTIONS)
	.define FORCE_SECTIONS
.endif


; "AGES_ENGINE" is like "ROM_AGES", but anything wrapped in this define could potentially be used in
; Seasons as well. Generally this enables extra engine features added in Ages. However, it could
; also cause subtle differences in how certain things work. In general though I'm trying to be
; conservative with using this, so as not to risk breaking anything.
;
; This is enabled by default in the hack-base branch for seasons.
.if defined(ROM_AGES) && !defined(AGES_ENGINE)
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


; Oracle of Ages has some "garbage" data, possibly a side-effect of the build process that caused
; data from previous builds (even from seasons!) to leak into the final ROM. We'll include that data
; only when building vanilla ROMs.
.if defined(BUILD_VANILLA) && defined(REGION_US)
	.define INCLUDE_GARBAGE
.endif



; Define to help with building directory strings, maybe other stuff
.ifdef ROM_SEASONS
	.define GAME "seasons"
.else
	.define GAME "ages"
.endif

; Game-specific data directory location
.define GAME_DATA_DIR "data/" GAME "/"
