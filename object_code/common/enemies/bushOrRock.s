; ==================================================================================================
; ENEMY_BUSH_OR_ROCK
;
; Variables:
;   var30: Enemy ID of parent object
; ==================================================================================================
enemyCode58:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,@destroyed

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_grabbed
	.dw @state_switchHook
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8


@state_uninitialized:
	; Initialize enemyCollisionMode and load tile to mimic
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@collisionAndTileData
	rst_addDoubleIndex

	ld e,Enemy.enemyCollisionMode
	ldi a,(hl)
	ld (de),a

	ld a,(hl)
	call objectMimicBgTile

	call @checkDisableDestruction
	call ecom_setSpeedAndState8
	call @copyParentPosition
	jr @setPriorityRelativeToLink


@collisionAndTileData:
	.db ENEMYCOLLISION_BUSH, TILEINDEX_OVERWORLD_BUSH_1 ; Subid 0
	.db ENEMYCOLLISION_BUSH, TILEINDEX_DUNGEON_BUSH     ; Subid 1
	.db ENEMYCOLLISION_ROCK, TILEINDEX_DUNGEON_POT      ; Subid 2
	.db ENEMYCOLLISION_ROCK, TILEINDEX_OVERWORLD_ROCK   ; Subid 3



@state_grabbed:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0: ; Just picked up
	ld h,d
	ld l,e
	inc (hl)

	ld l,Enemy.collisionType
	res 7,(hl)

	xor a
	ld (wLinkGrabState2),a
	call @makeParentEnemyVisibleAndRemoveReference
	jp objectSetVisible81

@@substate1: ; Being held
	ret

@@substate2: ; Being thrown
	ld h,d

	; No longer persist between screens
	ld l,Enemy.enabled
	res 1,(hl)

	ld l,Enemy.zh
	bit 7,(hl)
	ret nz

@@substate3:
	call objectSetPriorityRelativeToLink
	jr @makeDebrisAndDelete


@state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	call @makeParentEnemyVisibleAndRemoveReference
	jp ecom_incSubstate

@@substate1:
@@substate2:
	ret

@@substate3:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	jr @makeDebrisAndDelete


@state_stub:
	ret


@state8:
	; Check if parent object's type has changed, if so, delete self?
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(de)
	cp (hl)
	jp nz,enemyDelete

	ld l,Enemy.var03
	ld a,(hl)
	rlca
	call c,objectAddToGrabbableObjectBuffer
	call @copyParentPosition

@setPriorityRelativeToLink:
	jp objectSetPriorityRelativeToLink


@destroyed:
	call @makeParentEnemyVisibleAndRemoveReference

@makeDebrisAndDelete:
	ld e,Enemy.subid
	ld a,(de)
	ld hl,@debrisTypes
	rst_addAToHl
	ld b,(hl)
	call objectCreateInteractionWithSubid00
	jp enemyDelete

; Debris for each subid (0-3)
@debrisTypes:
	.db INTERAC_GRASSDEBRIS
	.db INTERAC_GRASSDEBRIS
	.db INTERAC_ROCKDEBRIS
	.db INTERAC_ROCKDEBRIS

;;
; Make parent visible, remove self from Parent.relatedObj2
@makeParentEnemyVisibleAndRemoveReference:
	ld a,Object.visible
	call objectGetRelatedObject1Var
	set 7,(hl)
	ld l,Enemy.relatedObj2
	xor a
	ldi (hl),a
	ld (hl),a
	ret

;;
; Copies parent position, with a Z offset determined by parent.var03.
@copyParentPosition:
	ld a,Object.yh
	call objectGetRelatedObject1Var
	call objectTakePosition

	ld l,Enemy.var03
	ld a,(hl)
	and $03
	ld hl,@zVals
	rst_addAToHl
	ld e,Enemy.zh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@zVals:
	.db $00 $fc $f8 $f4

;;
; Disable bush destruction for deku scrubs only.
@checkDisableDestruction:
	ld a,Object.id
	call objectGetRelatedObject1Var
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a

	; Don't allow destruction of bush for deku scrubs
	cp ENEMY_DEKU_SCRUB
	ret nz
	ld e,Enemy.enemyCollisionMode
	ld a,ENEMYCOLLISION_ROCK
	ld (de),a
	ret
