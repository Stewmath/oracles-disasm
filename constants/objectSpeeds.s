; These are valid values for Object.speed variables.
;
; If the value for Object.speed is not a multiple of 5, it may move in the wrong
; direction, and possibly with unbalanced y/x speed values (only for angles between $18
; and $1f).
;
; SPEED_100 is a speed of 1 pixel per frame, if moving directly on one axis (not
; diagonal).

.enum 0
	SPEED_0		dsb 5 ; 0x00
	SPEED_20	dsb 5 ; 0x05
	SPEED_40	dsb 5 ; 0x0a
	SPEED_60	dsb 5 ; 0x0f
	SPEED_80	dsb 5 ; 0x14
	SPEED_a0	dsb 5 ; 0x19
	SPEED_c0	dsb 5 ; 0x1e
	SPEED_e0	dsb 5 ; 0x23
	SPEED_100	dsb 5 ; 0x28
	SPEED_120	dsb 5 ; 0x2d
	SPEED_140	dsb 5 ; 0x32
	SPEED_160	dsb 5 ; 0x37
	SPEED_180	dsb 5 ; 0x3c
	SPEED_1a0	dsb 5 ; 0x41
	SPEED_1c0	dsb 5 ; 0x46
	SPEED_1e0	dsb 5 ; 0x4b
	SPEED_200	dsb 5 ; 0x50
	SPEED_220	dsb 5 ; 0x55
	SPEED_240	dsb 5 ; 0x5a
	SPEED_260	dsb 5 ; 0x5f
	SPEED_280	dsb 5 ; 0x64
	SPEED_2a0	dsb 5 ; 0x69
	SPEED_2c0	dsb 5 ; 0x6e
	SPEED_2e0	dsb 5 ; 0x73
	SPEED_300	dsb 5 ; 0x78
.ende

.define SPEED_00	SPEED_0
.define SPEED_000	SPEED_0
.define SPEED_020	SPEED_20
.define SPEED_040	SPEED_40
.define SPEED_060	SPEED_60
.define SPEED_080	SPEED_80
.define SPEED_0a0	SPEED_a0
.define SPEED_0c0	SPEED_c0
.define SPEED_0e0	SPEED_e0
