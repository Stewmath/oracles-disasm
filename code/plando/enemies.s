.BANK $40 SLOT 1
.ORG 0

.include "code/enemyCommon.s"
.include "code/enemyBossCommon.s"

; TODO: fix this
.define ENEMYCOLLISION_PUMPKIN_HEAD_GHOST ENEMYCOLLISION_MOTHULA
.define ENEMYCOLLISION_PUMPKIN_HEAD_HEAD ENEMYCOLLISION_AQUAMENTUS_BODY

; ==============================================================================
; ENEMYID_PUMPKIN_HEAD
;
; Variables (body, subid 1):
;   relatedObj1: Reference to ghost
;   relatedObj2: Reference to head
;   var30: Stomp counter (stops stomping when it reaches 0)
;
; Variables (ghost, subid 2):
;   relatedObj1: Reference to body
;   var33/var34: Head's position (where ghost is moving toward)
;
; Variables (head, subid 3):
;   relatedObj1: Reference to body
;   var31: Link's direction last frame
;   var32: Head's orientation when it was picked up
; ==============================================================================
enemyCode78:
	jr z,@normalStatus	; $6192
	sub ENEMYSTATUS_NO_HEALTH			; $6194
	ret c			; $6196
	jr z,@dead	; $6197
	jr @normalStatus		; $6199

@dead:
	call _pumpkinHead_noHealth		; $619b
	ret z			; $619e

@normalStatus:
	call _ecom_getSubidAndCpStateTo08		; $619f
	jr c,@commonState	; $61a2
	dec b			; $61a4
	ld a,b			; $61a5
	rst_jumpTable			; $61a6
	.dw _pumpkinHead_body
	.dw _pumpkinHead_ghost
	.dw _pumpkinHead_head

@commonState:
	rst_jumpTable			; $61ad
	.dw _pumpkinHead_state_uninitialized
	.dw _pumpkinHead_state_spawner
	.dw _pumpkinHead_state_grabbed
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub
	.dw _pumpkinHead_state_stub


_pumpkinHead_state_uninitialized:
	ld a,b			; $61be
	or a			; $61bf
	jp nz,_ecom_setSpeedAndState8		; $61c0

	; Subid 0 (spawner)
	inc a			; $61c3
	ld (de),a ; [state] = 1
	ld a,ENEMYID_PUMPKIN_HEAD		; $61c5
	ld b,$00		; $61c7
	jp _enemyBoss_initializeRoom		; $61c9


_pumpkinHead_state_spawner:
	; Wait for doors to close
	ld a,($cc93)		; $61cc
	or a			; $61cf
	ret nz			; $61d0

	ld b,$03		; $61d1
	call checkBEnemySlotsAvailable		; $61d3
	ret nz			; $61d6

	; Spawn body
	ld b,ENEMYID_PUMPKIN_HEAD		; $61d7
	call _ecom_spawnUncountedEnemyWithSubid01		; $61d9
	call objectCopyPosition		; $61dc
	ld c,h			; $61df

	; Spawn ghost
	call _ecom_spawnUncountedEnemyWithSubid01		; $61e0
	call @commonInit		; $61e3

	ld l,Enemy.enabled		; $61e6
	ld e,l			; $61e8
	ld a,(de)		; $61e9
	ld (hl),a		; $61ea

	; [body.relatedObj1] = ghost
	ld a,h			; $61eb
	ld h,c			; $61ec
	ld l,Enemy.relatedObj1+1		; $61ed
	ldd (hl),a		; $61ef
	ld (hl),Enemy.start		; $61f0

	; Spawn head
	call _ecom_spawnUncountedEnemyWithSubid01		; $61f2
	inc (hl)		; $61f5
	call @commonInit		; $61f6

	; [body.relatedObj2] = head
	ld a,h			; $61f9
	ld h,c			; $61fa
	ld l,Enemy.relatedObj2+1		; $61fb
	ldd (hl),a		; $61fd
	ld (hl),Enemy.start		; $61fe

	; Delete spawner
	jp enemyDelete		; $6200

@commonInit:
	inc (hl) ; [subid]++

	; [relatedObj1] = body
	ld l,Enemy.relatedObj1		; $6204
	ld (hl),Enemy.start		; $6206
	inc l			; $6208
	ld (hl),c		; $6209

	jp objectCopyPosition		; $620a


_pumpkinHead_state_grabbed:
	inc e			; $620d
	ld a,(de)		; $620e
	rst_jumpTable			; $620f
	.dw @justGrabbed
	.dw @beingHeld
	.dw @released
	.dw @atRest

@justGrabbed:
	ld h,d			; $6218
	ld l,e			; $6219
	inc (hl) ; [state2]

	xor a			; $621b
	ld (wLinkGrabState2),a		; $621c

	ld l,Enemy.var31		; $621f
	ld a,(w1Link.direction)		; $6221
	ld (hl),a		; $6224

	ld l,Enemy.direction		; $6225
	ld e,Enemy.var32		; $6227
	ld a,(hl)		; $6229
	ld (de),a		; $622a

	; [ghost.state] = $13
	ld a,Object.relatedObj1+1		; $622b
	call objectGetRelatedObject1Var		; $622d
	ld h,(hl)		; $6230
	ld l,Enemy.state		; $6231
	ld a,(hl)		; $6233
	ld (hl),$13		; $6234

	cp $13			; $6236
	jr nc,++		; $6238
	ld l,Enemy.zh		; $623a
	ld (hl),$f8		; $623c
	ld l,Enemy.invincibilityCounter		; $623e
	ld (hl),$f4		; $6240
++
	jp objectSetVisiblec1		; $6242

@beingHeld:
	; Update animation based on Link's facing direction
	ld a,(w1Link.direction)		; $6245
	ld h,d			; $6248
	ld l,Enemy.var31		; $6249
	cp (hl)			; $624b
	ret z			; $624c

	ld (hl),a		; $624d

	ld l,Enemy.var32		; $624e
	add (hl)		; $6250
	and $03			; $6251
	add a			; $6253
	ld l,Enemy.direction		; $6254
	ld (hl),a		; $6256
	jp enemySetAnimation		; $6257

@released:
	ret			; $625a

@atRest:
	; [ghost.state] = $15
	ld a,Object.relatedObj1+1		; $625b
	call objectGetRelatedObject1Var		; $625d
	ld h,(hl)		; $6260
	ld l,Enemy.state		; $6261
	ld (hl),$15		; $6263

	; [head.state] = $16
	ld h,d			; $6265
	ld (hl),$16		; $6266

	jp objectSetVisiblec2		; $6268


_pumpkinHead_state_stub:
	ret			; $626b


_pumpkinHead_body:
	ld a,(de)		; $626c
	sub $08			; $626d
	rst_jumpTable			; $626f
	.dw _pumpkinHead_body_state08
	.dw _pumpkinHead_body_state09
	.dw _pumpkinHead_body_state0a
	.dw _pumpkinHead_body_state0b
	.dw _pumpkinHead_body_state0c
	.dw _pumpkinHead_body_state0d
	.dw _pumpkinHead_body_state0e
	.dw _pumpkinHead_body_state0f
	.dw _pumpkinHead_body_state10
	.dw _pumpkinHead_body_state11
	.dw _pumpkinHead_body_state12
	.dw _pumpkinHead_body_state13


; Initialization
_pumpkinHead_body_state08:
	ld bc,$0106		; $6288
	call _enemyBoss_spawnShadow		; $628b
	ret nz			; $628e

	ld h,d			; $628f
	ld l,e			; $6290
	inc (hl) ; [state]

	ld l,Enemy.oamFlags		; $6292
	ld a,$01		; $6294
	ldd (hl),a		; $6296
	ld (hl),a		; $6297

	call objectSetVisible83		; $6298

	ld c,$08		; $629b
	call _ecom_setZAboveScreen		; $629d

	ld a,$0d		; $62a0
	jp enemySetAnimation		; $62a2


; Falling from ceiling
_pumpkinHead_body_state09:
	ld c,$10		; $62a5
	call objectUpdateSpeedZ_paramC		; $62a7
	ret nz			; $62aa

	ld l,Enemy.state		; $62ab
	inc (hl)		; $62ad

	ld l,Enemy.counter1		; $62ae
	ld (hl),30		; $62b0

	ld l,Enemy.angle		; $62b2
	ld (hl),ANGLE_DOWN		; $62b4

	ld a,30		; $62b6

_pumpkinHead_body_shakeScreen:
	call setScreenShakeCounter		; $62b8
	ld a,SND_DOORCLOSE		; $62bb
	jp playSound		; $62bd


; Waiting for head to catch up with body
_pumpkinHead_body_state0a:
	ld a,Object.zh		; $62c0
	call objectGetRelatedObject2Var		; $62c2
	ld a,(hl)		; $62c5
	cp $f0			; $62c6
	ret c			; $62c8

	call _ecom_decCounter1		; $62c9
	ret nz			; $62cc

	call _pumpkinHead_body_chooseRandomStompTimerAndCount		; $62cd
	jr _pumpkinHead_body_beginMoving		; $62d0


; Walking around
_pumpkinHead_body_state0b:
	call pumpkinHead_body_countdownUntilStomp		; $62d2
	ret z			; $62d5

	call _ecom_decCounter1		; $62d6
	jr z,_pumpkinHead_body_chooseNextAction	; $62d9

	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $62db
	jr z,_pumpkinHead_body_chooseNextAction	; $62de

	jp enemyAnimate		; $62e0


_pumpkinHead_body_chooseNextAction:
	call objectGetAngleTowardEnemyTarget		; $62e3
	add $04			; $62e6
	and $18			; $62e8
	ld b,a			; $62ea

	ld e,Enemy.angle		; $62eb
	ld a,(de)		; $62ed
	cp b			; $62ee
	jr nz,_pumpkinHead_body_beginMoving	; $62ef

	; Currently facing toward Link. 1 in 4 chance of head firing projectiles.
	call getRandomNumber_noPreserveVars		; $62f1
	cp $40			; $62f4
	jr c,_pumpkinHead_body_beginMoving	; $62f6

	; Head will fire projectiles.
	call _ecom_incState		; $62f8
	ld l,Enemy.counter1		; $62fb
	ld (hl),$38		; $62fd

	; [head.state] = $0b
	ld a,Object.state		; $62ff
	call objectGetRelatedObject2Var		; $6301
	inc (hl)		; $6304

	jr _pumpkinHead_body_updateAnimationFromAngle		; $6305


; Head is firing projectiles; waiting for it to finish.
_pumpkinHead_body_state0c:
	call _ecom_decCounter1		; $6307
	ret nz			; $630a

_pumpkinHead_body_beginMoving:
	ld h,d			; $630b
	ld l,Enemy.state		; $630c
	ld (hl),$0b		; $630e

	ld l,Enemy.speed		; $6310
	ld (hl),SPEED_80		; $6312

	; Random duration of time to walk
	call getRandomNumber_noPreserveVars		; $6314
	and $0f			; $6317
	ld hl,_pumpkinHead_body_walkDurations		; $6319
	rst_addAToHl			; $631c
	ld e,Enemy.counter1		; $631d
	ld a,(hl)		; $631f
	ld (de),a		; $6320

	call _ecom_setRandomCardinalAngle		; $6321

_pumpkinHead_body_updateAnimationFromAngle:
	ld e,Enemy.angle		; $6324
	ld a,(de)		; $6326
	swap a			; $6327
	rlca			; $6329
	ld b,a			; $632a

	ld hl,_pumpkinHead_body_collisionRadiusXVals		; $632b
	rst_addAToHl			; $632e
	ld e,Enemy.collisionRadiusX		; $632f
	ld a,(hl)		; $6331
	ld (de),a		; $6332

	ld a,b			; $6333
	add $0b			; $6334
	jp enemySetAnimation		; $6336


_pumpkinHead_body_walkDurations:
	.db 30, 30, 60, 60, 60, 60,  60,  90
	.db 90, 90, 90, 90, 90, 120, 120, 120

_pumpkinHead_body_collisionRadiusXVals:
	.db $0c $08 $0c $08


; Preparing to stomp
_pumpkinHead_body_state0d:
	call _ecom_decCounter1		; $634d
	jr z,_pumpkinHead_body_beginStomp	; $6350

	ld a,(hl)		; $6352
	rrca			; $6353
	ret nc			; $6354
	call _ecom_updateCardinalAngleTowardTarget		; $6355
	jr _pumpkinHead_body_updateAnimationFromAngle		; $6358

_pumpkinHead_body_beginStomp:
	ld l,Enemy.state		; $635a
	ld (hl),$0e		; $635c

	ld l,Enemy.speedZ		; $635e
	ld a,<(-$3a0)		; $6360
	ldi (hl),a		; $6362
	ld (hl),>(-$3a0)		; $6363

	ld l,Enemy.speed		; $6365
	ld (hl),SPEED_100		; $6367

	; [ghost.state] = $0c
	ld a,Object.state		; $6369
	call objectGetRelatedObject1Var		; $636b
	ld (hl),$0c		; $636e

	; [head.state] = $0e
	ld a,Object.state		; $6370
	call objectGetRelatedObject2Var		; $6372
	ld (hl),$0e		; $6375

	; Update angle based on direction toward Link
	call _ecom_updateAngleTowardTarget		; $6377
	add $04			; $637a
	and $18			; $637c
	swap a			; $637e
	rlca			; $6380
	ld b,a			; $6381
	ld hl,_pumpkinHead_body_collisionRadiusXVals		; $6382
	rst_addAToHl			; $6385
	ld e,Enemy.collisionRadiusX		; $6386
	ld a,(hl)		; $6388
	ld (de),a		; $6389

	ld a,b			; $638a
	add $0b			; $638b
	call enemySetAnimation		; $638d
	jp objectSetVisible81		; $6390


; In midair during stomp
_pumpkinHead_body_state0e:
	ld c,$30		; $6393
	call objectUpdateSpeedZ_paramC		; $6395
	jp nz,_ecom_applyVelocityForSideviewEnemyNoHoles		; $6398

	; Hit ground

	ld l,Enemy.state		; $639b
	inc (hl)		; $639d

	ld e,Enemy.var30		; $639e
	ld a,(de)		; $63a0
	dec a			; $63a1
	ld a,15		; $63a2
	jr nz,+			; $63a4
	ld a,30		; $63a6
+
	ld l,Enemy.counter1		; $63a8
	ld (hl),a		; $63aa

	ld a,20		; $63ab
	call _pumpkinHead_body_shakeScreen		; $63ad
	jp objectSetVisible83		; $63b0


; Landed after a stomp
_pumpkinHead_body_state0f:
	call _ecom_decCounter1		; $63b3
	ret nz			; $63b6

	ld l,Enemy.var30		; $63b7
	dec (hl)		; $63b9
	jr nz,_pumpkinHead_body_beginStomp	; $63ba
	jp _pumpkinHead_body_beginMoving		; $63bc


; Body has been destroyed
_pumpkinHead_body_state10:
	ret			; $63bf


; Head has moved up, body will now regenerate
_pumpkinHead_body_state11:
	ld h,d			; $63c0
	ld l,e			; $63c1
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $63c3
	ld (hl),$08		; $63c5
	ld l,Enemy.angle		; $63c7
	ld (hl),$10		; $63c9
	jp objectCreatePuff		; $63cb


; Delay before making body visible
_pumpkinHead_body_state12:
	call _ecom_decCounter1		; $63ce
	ret nz			; $63d1

	ld (hl),30 ; [counter1]
	ld l,e			; $63d4
	inc (hl) ; [state]

	call objectSetVisible83		; $63d6

	ld a,$0d		; $63d9
	jp enemySetAnimation		; $63db


; Body has regenerated, waiting a moment before resuming
_pumpkinHead_body_state13:
	call _ecom_decCounter1		; $63de
	ret nz			; $63e1

	ld l,Enemy.collisionType		; $63e2
	set 7,(hl)		; $63e4

	call _pumpkinHead_body_chooseRandomStompTimerAndCount		; $63e6
	jp _pumpkinHead_body_beginMoving		; $63e9


_pumpkinHead_ghost:
	ld a,(de)		; $63ec
	sub $08			; $63ed
	rst_jumpTable			; $63ef
	.dw _pumpkinHead_ghost_state08
	.dw _pumpkinHead_ghost_state09
	.dw _pumpkinHead_ghost_state0a
	.dw _pumpkinHead_ghost_state0b
	.dw _pumpkinHead_ghost_state0c
	.dw _pumpkinHead_ghost_state0d
	.dw _pumpkinHead_ghost_state0e
	.dw _pumpkinHead_ghost_state0f
	.dw _pumpkinHead_ghost_state10
	.dw _pumpkinHead_ghost_state11
	.dw _pumpkinHead_ghost_state12
	.dw _pumpkinHead_ghost_state13
	.dw _pumpkinHead_ghost_state14
	.dw _pumpkinHead_ghost_state15
	.dw _pumpkinHead_ghost_state16
	.dw _pumpkinHead_ghost_state17


; Initialization
_pumpkinHead_ghost_state08:
	ld h,d			; $6410
	ld l,e			; $6411
	inc (hl) ; [state]

	ld l,Enemy.enemyCollisionMode		; $6413
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_GHOST		; $6415

	ld l,Enemy.oamFlags		; $6417
	ld a,$05		; $6419
	ldd (hl),a		; $641b
	ld (hl),a		; $641c

	ld l,Enemy.collisionType		; $641d
	res 7,(hl)		; $641f

	ld l,Enemy.collisionRadiusY		; $6421
	ld a,$06		; $6423
	ldi (hl),a		; $6425
	ld (hl),a		; $6426

	call objectSetVisible83		; $6427
	ld c,$20		; $642a
	call _ecom_setZAboveScreen		; $642c

	ld a,$0a		; $642f
	jp enemySetAnimation		; $6431


; Falling from ceiling. (Also called by "head" state 9.)
_pumpkinHead_ghost_state09:
	ld c,$10		; $6434
	call objectUpdateSpeedZ_paramC		; $6436
	ld l,Enemy.zh		; $6439
	ld a,(hl)		; $643b
	cp $f0			; $643c
	ret c			; $643e

	ld (hl),$f0		; $643f
	ld l,Enemy.state		; $6441
	inc (hl)		; $6443
	ret			; $6444


; Waiting for head to fall into place
_pumpkinHead_ghost_state0a:
	; Check [head.zh]
	ld a,Object.relatedObj2+1		; $6445
	call objectGetRelatedObject1Var		; $6447
	ld h,(hl)		; $644a
	ld l,Enemy.zh		; $644b
	ld a,(hl)		; $644d
	cp $f0			; $644e
	ret nz			; $6450

	ld e,Enemy.state		; $6451
	ld a,$0b		; $6453
	ld (de),a		; $6455
	call objectSetInvisible		; $6456


; Copy body's position
_pumpkinHead_ghost_state0b:
	ld a,Object.enabled		; $6459
	call objectGetRelatedObject1Var		; $645b
	jp objectTakePosition		; $645e


; Body just began stomping; is moving upward
_pumpkinHead_ghost_state0c:
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingUp		; $6461
	ret nz			; $6464

	call _ecom_incState		; $6465
	ld l,Enemy.speedZ		; $6468
	xor a			; $646a
	ldi (hl),a		; $646b
	ld (hl),a		; $646c
	call objectSetVisible81		; $646d


; Body is stomping; moving downward
_pumpkinHead_ghost_state0d:
	ld c,$28		; $6470
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingDown		; $6472
	ret c			; $6475

	ld (hl),$f0 ; [zh]
	ld l,Enemy.state		; $6478
	inc (hl)		; $647a
	jp objectSetVisible83		; $647b


; Reached target z-position after stomping; waiting for head to catch up
_pumpkinHead_ghost_state0e:
	ld a,Object.relatedObj2+1		; $647e
	call objectGetRelatedObject1Var		; $6480
	ld h,(hl)		; $6483
	ld l,Enemy.zh		; $6484
	ld a,(hl)		; $6486
	cp $ee			; $6487
	ret c			; $6489

	ld e,Enemy.state		; $648a
	ld a,$0b		; $648c
	ld (de),a		; $648e
	jp objectSetInvisible		; $648f


; Body just destroyed
_pumpkinHead_ghost_state0f:
	ld h,d			; $6492
	ld l,e			; $6493
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $6495
	ld a,<(-$120)		; $6497
	ldi (hl),a		; $6499
	ld (hl),>(-$120)		; $649a

	jp objectSetInvisible		; $649c


; Falling to ground after body disappeared
_pumpkinHead_ghost_state10:
	ld c,$28		; $649f
	call objectUpdateSpeedZ_paramC		; $64a1
	ret nz			; $64a4

	ld l,Enemy.state		; $64a5
	inc (hl)		; $64a7
	ld l,Enemy.counter1		; $64a8
	ld (hl),$08		; $64aa
	ret			; $64ac


; Delay before going to next state?
_pumpkinHead_ghost_state11:
	call _ecom_decCounter1		; $64ad
	ret nz			; $64b0
	ld l,e			; $64b1
	inc (hl) ; [state]
	ret			; $64b3


; Waiting for head to be picked up
_pumpkinHead_ghost_state12:
	ret			; $64b4


; Link just grabbed the head; ghost runs away
_pumpkinHead_ghost_state13:
	ld h,d			; $64b5
	ld l,e			; $64b6
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $64b8
	ld (hl),60		; $64ba

	ld l,Enemy.speed		; $64bc
	ld (hl),SPEED_140		; $64be
	ld l,Enemy.speedZ		; $64c0
	xor a			; $64c2
	ldi (hl),a		; $64c3
	ld (hl),a		; $64c4

	ld l,Enemy.collisionType		; $64c5
	set 7,(hl)		; $64c7
	call objectSetVisiblec2		; $64c9

	call _ecom_updateCardinalAngleAwayFromTarget		; $64cc

	ld a,$0a		; $64cf
	jp enemySetAnimation		; $64d1


; Falling to ground, then running away with angle computed earlier
_pumpkinHead_ghost_state14:
	ld c,$20		; $64d4
	call objectUpdateSpeedZ_paramC		; $64d6
	ret nz			; $64d9

	call _ecom_decCounter1		; $64da
	jr nz,++		; $64dd

	ld l,Enemy.state		; $64df
	inc (hl)		; $64e1
	call objectSetVisible82		; $64e2
++
	call _ecom_applyVelocityForSideviewEnemyNoHoles		; $64e5
	jp enemyAnimate		; $64e8


; Stopped running away, or head just landed on ground
_pumpkinHead_ghost_state15:
	ld h,d			; $64eb
	ld l,e			; $64ec
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $64ee
	ld (hl),120		; $64f0
	ld a,$09		; $64f2
	jp enemySetAnimation		; $64f4


; After [counter1] frames, will choose which direction to move in next
_pumpkinHead_ghost_state16:
	call _ecom_decCounter1		; $64f7
	jr nz,@checkHeadOnGround	; $64fa

	ld (hl),60 ; [counter1]
	ld l,e			; $64fe
	dec (hl)		; $64ff
	dec (hl) ; [state] = $14

	call getRandomNumber_noPreserveVars		; $6501
	and $1c			; $6504
	ld e,Enemy.angle		; $6506
	ld (de),a		; $6508
	jr @setAnim		; $6509

@checkHeadOnGround:
	; Check [head.state] to see if head is at rest on the ground
	ld a,Object.relatedObj2+1		; $650b
	call objectGetRelatedObject1Var		; $650d
	ld h,(hl)		; $6510
	ld l,Enemy.state		; $6511
	ld a,(hl)		; $6513
	cp $02			; $6514
	jp z,enemyAnimate		; $6516

	ld h,d			; $6519
	inc (hl) ; [this.state]

	; Copy head's position, use that as target position to move toward.
	; [this.var33] = [head.yh]
	ld a,Object.relatedObj2+1		; $651b
	call objectGetRelatedObject1Var		; $651d
	ld h,(hl)		; $6520
	ld l,Enemy.yh		; $6521
	ld e,Enemy.var33		; $6523
	ldi a,(hl)		; $6525
	ld (de),a		; $6526

	; [this.var34] = [head.xh]
	inc l			; $6527
	inc e			; $6528
	ld a,(hl)		; $6529
	ld (de),a		; $652a

@setAnim:
	ld a,$0a		; $652b
	jp enemySetAnimation		; $652d


; Moving toward head (or where head used to be)
_pumpkinHead_ghost_state17:
	ld h,d			; $6530
	ld l,Enemy.var33		; $6531
	call _ecom_readPositionVars		; $6533
	sub c			; $6536
	add $08			; $6537
	cp $11			; $6539
	jr nc,@moveTowardHead	; $653b
	ldh a,(<hFF8F)	; $653d
	sub b			; $653f
	add $08			; $6540
	cp $11			; $6542
	jr nc,@moveTowardHead	; $6544

	; Reached head.

	; Check [head.state] to see if it's being held
	ld a,Object.relatedObj2+1		; $6546
	call objectGetRelatedObject1Var		; $6548
	ld h,(hl)		; $654b
	ld l,Enemy.state		; $654c
	ld a,(hl)		; $654e
	cp $02			; $654f
	ret z			; $6551

	ld (hl),$13 ; [head.state] = $13

	ld h,d			; $6554
	ld (hl),$0b ; [this.state] = $0b

	ld l,Enemy.collisionType		; $6557
	res 7,(hl)		; $6559
	jp objectSetInvisible		; $655b

@moveTowardHead:
	call _ecom_moveTowardPosition		; $655e
	jp enemyAnimate		; $6561


_pumpkinHead_head:
	ld a,(de)		; $6564
	sub $08			; $6565
	rst_jumpTable			; $6567
	.dw _pumpkinHead_head_state08
	.dw _pumpkinHead_head_state09
	.dw _pumpkinHead_head_state0a
	.dw _pumpkinHead_head_state0b
	.dw _pumpkinHead_head_state0c
	.dw _pumpkinHead_head_state0d
	.dw _pumpkinHead_head_state0e
	.dw _pumpkinHead_head_state0f
	.dw _pumpkinHead_head_state10
	.dw _pumpkinHead_head_state11
	.dw _pumpkinHead_head_state12
	.dw _pumpkinHead_head_state13
	.dw _pumpkinHead_head_state14
	.dw _pumpkinHead_head_state15
	.dw _pumpkinHead_head_state16


; Initialization
_pumpkinHead_head_state08:
	ld h,d			; $6586
	ld l,e			; $6587
	inc (hl) ; [state]

	ld l,Enemy.angle		; $6589
	ld (hl),$ff		; $658b

	ld l,Enemy.enemyCollisionMode		; $658d
	ld (hl),ENEMYCOLLISION_PUMPKIN_HEAD_HEAD		; $658f

	ld l,Enemy.collisionRadiusY		; $6591
	ld (hl),$06		; $6593

	call objectSetVisible82		; $6595
	ld c,$30		; $6598
	call _ecom_setZAboveScreen		; $659a

	ld a,$04		; $659d
	ld b,$00		; $659f

;;
; @addr{65a1}
_pumpkinHead_head_setAnimation:
	ld e,Enemy.direction		; $65a1
	ld (de),a		; $65a3
	add b			; $65a4
	ld b,a			; $65a5
	srl a			; $65a6
	ld hl,@collisionRadiusXVals		; $65a8
	rst_addAToHl			; $65ab
	ld e,Enemy.collisionRadiusX		; $65ac
	ld a,(hl)		; $65ae
	ld (de),a		; $65af
	ld a,b			; $65b0
	jp enemySetAnimation		; $65b1

@collisionRadiusXVals:
	.db $08 $06 $08 $06


_pumpkinHead_head_state09:
	call _pumpkinHead_ghost_state09		; $65b8
	ret c			; $65bb

	ld a,MUS_BOSS		; $65bc
	ld (wActiveMusic),a		; $65be
	jp playSound		; $65c1


; Head follows body. Called by other states.
_pumpkinHead_head_state0a:
	call objectSetPriorityRelativeToLink		; $65c4

	ld a,Object.animParameter		; $65c7
	call objectGetRelatedObject1Var		; $65c9
	ld a,(hl)		; $65cc
	push hl			; $65cd
	ld hl,@headZOffsets		; $65ce
	rst_addAToHl			; $65d1
	ldi a,(hl)		; $65d2
	ld c,a			; $65d3
	ld b,$00		; $65d4
	ld a,(hl)		; $65d6
	pop hl			; $65d7
	push af			; $65d8
	call objectTakePositionWithOffset		; $65d9

	pop af			; $65dc
	ld e,Enemy.zh		; $65dd
	ld (de),a		; $65df

	; Check whether body's angle is different from head's angle
	ld l,Enemy.angle		; $65e0
	ld e,l			; $65e2
	ld a,(de)		; $65e3
	cp (hl)			; $65e4
	jp z,enemyAnimate		; $65e5

	ld a,(hl)		; $65e8
	ld (de),a		; $65e9
	rrca			; $65ea
	rrca			; $65eb
	ld b,$00		; $65ec
	jr _pumpkinHead_head_setAnimation		; $65ee

; Offsets for head relative to body. Indexed by body's animParameter.
;   b0: Y offset
;   b1: Z position
@headZOffsets:
	.db $00 $f0
	.db $01 $f0
	.db $00 $ef


; Preparing to fire projectiles
_pumpkinHead_head_state0b:
	ld h,d			; $65f6
	ld l,e			; $65f7
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $65f9
	ld (hl),20		; $65fb

	call _pumpkinHead_head_state0a		; $65fd

	ld e,Enemy.angle		; $6600
	ld a,(de)		; $6602
	rrca			; $6603
	rrca			; $6604
	ld b,$01		; $6605
	jp _pumpkinHead_head_setAnimation		; $6607


; Delay before firing projectile
_pumpkinHead_head_state0c:
	call _ecom_decCounter1		; $660a
	jp nz,objectSetPriorityRelativeToLink		; $660d

	; Fire projectile
	ld (hl),36 ; [counter1]
	ld l,e			; $6612
	inc (hl) ; [state]

	ld l,Enemy.angle		; $6614
	ld a,(hl)		; $6616
	rrca			; $6617
	rrca			; $6618
	ld b,$00		; $6619
	call _pumpkinHead_head_setAnimation		; $661b
	call getFreePartSlot		; $661e
	ret nz			; $6621

	ld (hl),PARTID_PUMPKIN_HEAD_PROJECTILE		; $6622
	ld l,Part.angle		; $6624
	ld e,Enemy.angle		; $6626
	ld a,(de)		; $6628
	ld (hl),a		; $6629
	call objectCopyPosition		; $662a

	ld a,SND_VERAN_FAIRY_ATTACK		; $662d
	jp playSound		; $662f


; Delay after firing projectile
_pumpkinHead_head_state0d:
	call _ecom_decCounter1		; $6632
	jp nz,objectSetPriorityRelativeToLink		; $6635

	ld l,e			; $6638
	ld (hl),$0a ; [state]
	jr _pumpkinHead_head_state0a		; $663b


; Began a stomp; moving up
_pumpkinHead_head_state0e:
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingUp		; $663d
	jr z,@movingDown	; $6640

	; Update angle
	ld l,Enemy.angle		; $6642
	ld e,l			; $6644
	ld a,(de)		; $6645
	cp (hl)			; $6646
	ret z			; $6647
	ld a,(hl)		; $6648
	ld (de),a		; $6649
	add $04			; $664a
	and $18			; $664c
	rrca			; $664e
	rrca			; $664f
	ld b,$00		; $6650
	jp _pumpkinHead_head_setAnimation		; $6652

@movingDown:
	call _ecom_incState		; $6655
	ld l,Enemy.speedZ		; $6658
	xor a			; $665a
	ldi (hl),a		; $665b
	ld (hl),a		; $665c
	call objectSetVisible80		; $665d


; Body is stomping; moving down
_pumpkinHead_head_state0f:
	ld c,$20		; $6660
	call _pumpkinHead_ghostOrHead_updatePositionWhileStompingDown		; $6662
	ret c			; $6665

	; Reached target position
	ld (hl),$f0 ; [zh]
	ld l,Enemy.state		; $6668
	ld (hl),$0a		; $666a
	jp objectSetVisible82		; $666c


; Body just destroyed
_pumpkinHead_head_state10:
	ld h,d			; $666f
	ld l,e			; $6670
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $6672
	ld a,<(-$120)		; $6674
	ldi (hl),a		; $6676
	ld (hl),>(-$120)		; $6677
	jp objectSetVisiblec2		; $6679


; Head falling down after body destroyed
_pumpkinHead_head_state11:
	ld c,$20		; $667c
	call objectUpdateSpeedZ_paramC		; $667e
	ret nz			; $6681

	ld l,Enemy.state		; $6682
	inc (hl)		; $6684
	ld l,Enemy.counter1		; $6685
	ld (hl),120		; $6687
	ret			; $6689


; Head is grabbable for 120 frames
_pumpkinHead_head_state12:
	call _ecom_decCounter1		; $668a
	jp nz,_pumpkinHead_head_state16		; $668d

	ld l,e			; $6690
	inc (hl) ; [state]

	; [ghost.state] = $0b
	ld a,Object.relatedObj1+1		; $6692
	call objectGetRelatedObject1Var		; $6694
	ld h,(hl)		; $6697
	ld l,Enemy.state		; $6698
	ld (hl),$0b		; $669a
	ret			; $669c


; Ghost just re-entered head, or head timed out before Link grabbed it
_pumpkinHead_head_state13:
	ld h,d			; $669d
	ld l,e			; $669e
	inc (hl) ; [state]

	ld l,Enemy.counter1		; $66a0
	ld (hl),$10		; $66a2

	ld l,Enemy.collisionRadiusX		; $66a4
	ld (hl),$0a		; $66a6

	ld a,$08		; $66a8
	jp enemySetAnimation		; $66aa


; Delay before moving back up, respawning body
_pumpkinHead_head_state14:
	call _ecom_decCounter1		; $66ad
	ret nz			; $66b0

	ld l,e			; $66b1
	inc (hl) ; [state]

	ld l,Enemy.speedZ		; $66b3
	ld a,<(-$200)		; $66b5
	ldi (hl),a		; $66b7
	ld (hl),>(-$200)		; $66b8

	ld l,Enemy.collisionRadiusX		; $66ba
	ld (hl),$06		; $66bc
	ld a,$04		; $66be
	jp enemySetAnimation		; $66c0


; Head moving up
_pumpkinHead_head_state15:
	ld c,$20		; $66c3
	call objectUpdateSpeedZ_paramC		; $66c5

	ld l,Enemy.zh		; $66c8
	ld a,(hl)		; $66ca
	cp $f1			; $66cb
	ret nc			; $66cd

	; Head has gone up high enough; respawn body now.

	ld (hl),$f0 ; [zh]

	ld l,Enemy.state		; $66d0
	ld (hl),$0a		; $66d2

	ld l,Enemy.collisionRadiusX		; $66d4
	ld (hl),$0c		; $66d6

	call objectSetVisible82		; $66d8

	; [body.state] = $11
	ld a,Object.state		; $66db
	call objectGetRelatedObject1Var		; $66dd
	ld (hl),$11		; $66e0

	; Copy head's position to ghost
	call objectCopyPosition		; $66e2

	; [ghost.zh]
	ld l,Enemy.zh		; $66e5
	ld (hl),$00		; $66e7

	ld a,$04		; $66e9
	ld b,$00		; $66eb
	jp _pumpkinHead_head_setAnimation		; $66ed


; Head has just come to rest after being thrown.
; Called by other states (to make it grabbable).
_pumpkinHead_head_state16:
	ld a,Object.health		; $66f0
	call objectGetRelatedObject1Var		; $66f2
	ld a,(hl)		; $66f5
	or a			; $66f6
	ret z			; $66f7
	call objectAddToGrabbableObjectBuffer		; $66f8
	jp objectPushLinkAwayOnCollision		; $66fb


;;
; @param[out]	zflag	z if time to stomp
; @addr{66fe}
pumpkinHead_body_countdownUntilStomp:
	ld a,(wFrameCounter)		; $66fe
	rrca			; $6701
	ret c			; $6702
	call _ecom_decCounter2		; $6703
	ret nz			; $6706

	ld l,Enemy.state		; $6707
	ld (hl),$0d		; $6709
	ld l,Enemy.counter1		; $670b
	ld (hl),60		; $670d

;;
; Randomly sets the duration until a stomp occurs, and the number of stomps to perform.
; @addr{670f}
_pumpkinHead_body_chooseRandomStompTimerAndCount:
	ld bc,$0701		; $670f
	call _ecom_randomBitwiseAndBCE		; $6712
	ld a,b			; $6715
	ld hl,@counter2Vals		; $6716
	rst_addAToHl			; $6719

	ld e,Enemy.counter2		; $671a
	ld a,(hl)		; $671c
	ld (de),a		; $671d

	ld e,Enemy.var30		; $671e
	ld a,c			; $6720
	add $02			; $6721
	ld (de),a		; $6723
	xor a			; $6724
	ret			; $6725

@counter2Vals:
	.db 90, 120, 120, 120, 150, 150, 150, 180

;;
; @param[out]	zflag	z if body is moving down
; @addr{672e}
_pumpkinHead_ghostOrHead_updatePositionWhileStompingUp:
	ld a,Object.speedZ+1		; $672e
	call objectGetRelatedObject1Var		; $6730
	bit 7,(hl)		; $6733
	ret z			; $6735

	call objectTakePosition		; $6736
	ld e,Enemy.zh		; $6739
	ld a,(de)		; $673b
	sub $10			; $673c
	ld (de),a		; $673e
	ret			; $673f

;;
; @param	c	Gravity
; @param[out]	hl	Enemy.zh
; @param[out]	cflag	nc if reached target z-position
; @addr{6740}
_pumpkinHead_ghostOrHead_updatePositionWhileStompingDown:
	call objectUpdateSpeedZ_paramC		; $6740
	ld l,Enemy.zh		; $6743
	ld a,(hl)		; $6745
	cp $f0			; $6746
	ret nc			; $6748

	push af			; $6749
	ld a,Object.enabled		; $674a
	call objectGetRelatedObject1Var		; $674c
	call objectTakePosition		; $674f
	pop af			; $6752
	ld e,Enemy.zh		; $6753
	ld (de),a		; $6755
	ret			; $6756


;;
; @addr{6757}
_pumpkinHead_noHealth:
	ld e,Enemy.subid		; $6757
	ld a,(de)		; $6759
	dec a			; $675a
	jr z,@bodyHealthZero	; $675b
	dec a			; $675d
	jr z,@ghostHealthZero	; $675e

@headHealthZero:
	call objectCreatePuff		; $6760
	ld h,d			; $6763
	ld l,Enemy.state		; $6764
	ldi a,(hl)		; $6766
	cp $02			; $6767
	jr nz,@delete	; $6769

	ld a,(hl) ; [state2]
	cp $02			; $676c
	call c,dropLinkHeldItem		; $676e
@delete:
	jp enemyDelete		; $6771

@ghostHealthZero:
	ld e,Enemy.collisionType		; $6774
	ld a,(de)		; $6776
	or a			; $6777
	jr nz,++		; $6778
	call _ecom_killRelatedObj1		; $677a
	ld l,Enemy.relatedObj2+1		; $677d
	ld h,(hl)		; $677f
	call _ecom_killObjectH		; $6780
++
	call _enemyBoss_dead		; $6783
	xor a			; $6786
	ret			; $6787

@bodyHealthZero:
	; Delete self if ghost's health is 0
	ld a,Object.health		; $6788
	call objectGetRelatedObject1Var		; $678a
	ld a,(hl)		; $678d
	or a			; $678e
	jp z,enemyDelete		; $678f

	; Otherwise, the body just disappears temporarily
	ld h,d			; $6792
	ld l,Enemy.health		; $6793
	ld (hl),$08		; $6795

	ld l,Enemy.state		; $6797
	ld (hl),$10		; $6799

	ld l,Enemy.zh		; $679b
	ld (hl),$00		; $679d

	; [ghost.state] = $0f
	ld a,Object.state		; $679f
	call objectGetRelatedObject1Var		; $67a1
	ld (hl),$0f		; $67a4

	; [head.state] = $10
	ld a,Object.state		; $67a6
	call objectGetRelatedObject2Var		; $67a8
	ld (hl),$10		; $67ab

	call objectCreatePuff		; $67ad
	jp objectSetInvisible		; $67b0
