 m_section_free Bank_15 NAMESPACE scriptHelp

; ==============================================================================
; INTERACID_FARORE
; ==============================================================================
faroreCheckSecretValidity:
	ld a,(wSecretInputType)
	inc a
	jr nz,+
	xor a

@setVar3f
	ld e,Interaction.var3f
	ld (de),a
	ret
+
	ld a,(wTextInputResult)
	swap a
	and $03
	rst_jumpTable
.ifdef ROM_AGES
	.dw @jump0
	.dw @jump1Or2
	.dw @jump1Or2
	.dw @jump3
.else
	.dw @jump1Or2
	.dw @jump3
	.dw @jump0
	.dw @jump1Or2
.endif

@jump1Or2:
	; Wrong game
	ld a,$04
	jr @setVar3f

@jump0:
	; Invalid? Pressed "back"?
	ld a,$03
	jr @setVar3f

@jump3:
	; Check if we've already told this secret
	ld a,(wTextInputResult)
	and $0f
.ifdef ROM_AGES
	add GLOBALFLAG_DONE_CLOCK_SHOP_SECRET
.else
	add GLOBALFLAG_DONE_KING_ZORA_SECRET
.endif
	ld b,a
	call checkGlobalFlag
	ld a,$02
	jr nz,@setVar3f

	; Check if we've spoken to the npc needed to trigger the secret
	ld a,b
	sub GLOBALFLAG_FIRST_AGES_DONE_SECRET - GLOBALFLAG_FIRST_AGES_BEGAN_SECRET
	call checkGlobalFlag
	ld a,$01
	jr nz,@setVar3f
	ld a,$05
	jr @setVar3f


faroreShowTextForSecretHint:
	ld a,(wTextInputResult)
	and $0f
	add <TX_550f
	ld c,a
	ld b,>TX_5500
	jp showText


faroreSpawnSecretChest:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERACID_FARORE_GIVEITEM
	inc l
	ld a,(wTextInputResult)
	and $0f
	ld (hl),a

	ld l,Interaction.yh
	ld c,$75
	jp setShortPosition_paramC

faroreGenerateGameTransferSecret:
	jpab bank3.generateGameTransferSecret


; ==============================================================================
; INTERACID_DOOR_CONTROLLER
; ==============================================================================

; Update Link's respawn position in case it's on a door that's just about to close
doorController_updateLinkRespawn:
	call objectGetShortPosition
	ld c,a
	ld a,(wLinkLocalRespawnY)
	and $f0
	ld b,a
	ld a,(wLinkLocalRespawnX)
	and $f0
	swap a
	or b
	cp c
	ret nz

	ld e,Interaction.angle
	ld a,(de)
	rrca
	and $03
	ld hl,@offsets
	rst_addAToHl
	ld a,(hl)
	add c
	ld c,a
	and $f0
	or $08
	ld (wLinkLocalRespawnY),a
	ld a,c
	swap a
	and $f0
	or $08
	ld (wLinkLocalRespawnX),a
	ret

@offsets:
	.db $10 $ff $f0 $01


;;
; Sets wTmpcfc0.normal.doorControllerState to:
;   $00: Nothing to be done.
;   $01: Door should be opened.
;   $02: Door should be closed.
doorController_decideActionBasedOnTriggers:
	ld e,Interaction.var3d
	ld a,(de)
	ld b,a
	ld a,(wActiveTriggers)
	and b
	jr z,@triggerInactive

; If trigger is active, open the door.
	call @checkTileIsShutterDoor
	ld a,$01
	jr z,@end
	xor a
	jr @end

; If trigger is inactive, close the door.
@triggerInactive:
	call @checkTileCollision
	ld a,$02
	jr z,@end
	xor a
@end:
	ld (wTmpcfc0.normal.doorControllerState),a
	ret


;;
; @param[out]	zflag	Set if the tile at this object's position is the expected shutter
;			door (the one facing the correct direction)
@checkTileIsShutterDoor:
	ld e,Interaction.angle
	ld a,(de)
	sub $10
	srl a
	ld hl,@tileIndices
	rst_addAToHl
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp (hl)
	ret

@tileIndices: ; Tile indices for shutter doors
	.db $78 $79 $7a $7b


;;
; @param[out]	zflag	Set if collisions at this object's position are 0
@checkTileCollision:
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld b,>wRoomCollisions
	ld a,(bc)
	or a
	ret


;;
; Set wTmpcfc0.normal.doorControllerState to:
;   $01 if Link is on a minecart which has collided with the door
;   $00 otherwise
doorController_checkMinecartCollidedWithDoor:
	xor a
	ld (wTmpcfc0.normal.doorControllerState),a
	ld a,(wLinkObjectIndex)
	rrca
	ret nc
	call objectCheckCollidedWithLink_ignoreZ
	ret nc
	ld a,$01
	ld (wTmpcfc0.normal.doorControllerState),a
	ret

;;
; Set wTmpcfc0.normal.doorControllerState to:
;   $01 if the tile at this position is a horizontal or vertical track
;   $00 otherwise
doorController_checkTileIsMinecartTrack:
	ld e,Interaction.var3e
	ld a,(de)
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)
	cp TILEINDEX_TRACK_HORIZONTAL
	ld b,$01
	jr z,+
	cp TILEINDEX_TRACK_VERTICAL
	jr z,+
	dec b
+
	ld a,b
	ld (wTmpcfc0.normal.doorControllerState),a
	ret


;;
; Compares [wNumTorchesLit] with [Interaction.speed]. Sets [wTmpcec0] to $01 if they're
; equal, $00 otherwise.
doorController_checkEnoughTorchesLit:
	ld a,(wNumTorchesLit)
	ld b,a
	ld e,Interaction.speed
	ld a,(de)
	cp b
	ld a,$01
	jr z,+
	dec a
+
	ld (wTmpcec0),a
	ret


; ==============================================================================
; INTERACID_SHOPKEEPER
; ==============================================================================

;;
shopkeeper_take10Rupees:
	ld a,RUPEEVAL_10
	jp removeRupeeValue

.ends


.ifdef ROM_SEASONS
	.include "code/loadTreasureData.s"
.endif


 m_section_free Bank_15_2 NAMESPACE scriptHelp

.ifdef ROM_SEASONS

createBossDeathExplosion:
	call getFreePartSlot
	ret nz
	ld (hl),PARTID_BOSS_DEATH_EXPLOSION
	jp objectCopyPosition
.endif


; ==============================================================================
; INTERACID_MOVING_PLATFORM
; ==============================================================================

;;
; The moving platform has a custom "script format".
movingPlatform_loadScript:
	ld a,(wDungeonIndex)
	ld b,a
	inc a
	jr nz,@inDungeon

	; Not in dungeon
.ifdef ROM_AGES
	ld hl,movingPlatform_scriptTable
.else
	ld hl,movingPlatform_nonDungeonScriptTable
.endif
	jr @loadScript

@inDungeon:
	ld a,b
	ld hl,movingPlatform_scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a

@loadScript:
	ld e,Interaction.var32
	ld a,(de)
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jr movingPlatform_setScript

movingPlatform_runScript:
	ld e,Interaction.scriptPtr
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a

@nextOpcode:
	ldi a,(hl)
	push hl
	rst_jumpTable
	.dw @opcode00
	.dw @opcode01
	.dw @opcode02
	.dw @opcode03
	.dw @opcode04
	.dw @opcode05
	.dw @opcode06
	.dw @opcode07
	.dw @opcode08
	.dw @opcode09
	.dw @opcode0a
	.dw @opcode0b

; Wait for the given number of frames
@opcode00:
@opcode06:
@opcode07:
	pop hl
	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld e,Interaction.substate
	xor a
	ld (de),a
	jr movingPlatform_setScript

; Move at the current angle for the given number of frames
@opcode01:
	pop hl
	ldi a,(hl)
	ld e,Interaction.counter1
	ld (de),a
	ld e,Interaction.substate
	ld a,$01
	ld (de),a
	jr movingPlatform_setScript

; Set angle
@opcode02:
	pop hl
	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a
	jr @nextOpcode

; Set speed
@opcode03:
	pop hl
	ldi a,(hl)
	ld e,Interaction.speed
	ld (de),a
	jr @nextOpcode

; Jump somewhere (used for looping)
@opcode04:
	pop hl
	ld a,(hl)
	call s8ToS16
	add hl,bc
	jr @nextOpcode

; Hold execution until Link is on
@opcode05:
	pop hl
	ld a,(wLinkRidingObject)
	cp d
	jr nz,@@linkNotOn
	inc hl
	jr @nextOpcode

@@linkNotOn:
	dec hl
	ld a,$01
	ld e,Interaction.counter1
	ld (de),a
	xor a
	ld e,Interaction.substate
	ld (de),a
	jr movingPlatform_setScript

; Move up
@opcode08:
	ld a,$00
	jr @moveAtAngle

; Move right
@opcode09:
	ld a,$08
	jr @moveAtAngle

 ; Move down
@opcode0a:
	ld a,$10
	jr @moveAtAngle

 ; Move left
@opcode0b:
	ld a,$18

@moveAtAngle:
	ld e,Interaction.angle
	ld (de),a
	jr @opcode01

;;
movingPlatform_setScript:
	ld e,Interaction.scriptPtr
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ret

.include "build/data/movingPlatformScriptTable.s"

; ==============================================================================
; INTERACID_ESSENCE
; ==============================================================================

;;
essence_createEnergySwirl:
	call objectGetPosition
	ld a,$ff
	jp createEnergySwirlGoingIn

;;
essence_stopEnergySwirl:
	ld a,$01
	ld (wDeleteEnergyBeads),a
	ret

; ==============================================================================
; INTERACID_VASU
; ==============================================================================

;;
vasu_giveRingBox:
	call getFreeInteractionSlot
	ldbc TREASURE_RING_BOX, $00
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld l,Interaction.yh
	ld a,(w1Link.yh)
	ldi (hl),a
	inc l
	ld a,(w1Link.xh)
	ld (hl),a
	ret

;;
; @param	a	$00 to display unappraised rings, $01 for appraised ring list
vasu_openRingMenu:
	ld (wRingMenu_mode),a
	ld a,$01
	ld (wDisabledObjects),a
	ld a,$04
	jp openMenu

;;
redSnake_openSecretInputMenu:
	ld a,$02
	jp openSecretInputMenu

;;
redSnake_generateRingSecret:
	ld a,GLOBALFLAG_RING_SECRET_GENERATED
	call setGlobalFlag
	ldbc SECRETFUNC_GENERATE_SECRET, $02
	jp secretFunctionCaller

;;
blueSnake_linkOrFortune:
	ld e,Interaction.state
	ld a,$05
	ld (de),a
	xor a
	inc e
	ld (de),a

	; Initialize gameID if necessary
	ld b,$03
	call secretFunctionCaller

	call serialFunc_0c85
	ld a,(wSelectedTextOption)
	ld e,Interaction.var39
	ld (de),a

	ld bc,TX_300e
	or a
	jr z,@showText

	ld e,Interaction.substate
	ld a,$03
	ld (de),a
	ld bc,TX_3028
@showText:
	jp showText

;;
; Checks for 1000 enemies ring, 1000 rupee ring, victory ring. Writes a value to var3b
; indicating the action to be taken, and a ring index to var3a if applicable.
vasu_checkEarnedSpecialRing:
	ld a,GLOBALFLAG_1000_ENEMIES_KILLED
	call @checkFlagSet
	jr nz,@setRingAndAction

	ld a,GLOBALFLAG_10000_RUPEES_COLLECTED
	call @checkFlagSet
	jr nz,@setRingAndAction

	ld a,GLOBALFLAG_BEAT_GANON
	call @checkFlagSet
	jr nz,@setRingAndAction

	ld a,$03
@setAction:
	ld e,Interaction.var3b
	ld (de),a
	ret

@setRingAndAction:
	ld e,Interaction.var3a
	ld (de),a
	sub SLAYERS_RING ; WEALTH_RING should be right after
	jr @setAction

; @param[otu]	a	Ring to give (if earned)
; @param[out]	zflag	nz if ring should be given
@checkFlagSet:
	; Check if ring earned
	ld c,a
	call checkGlobalFlag
	jr z,@flagNotSet

	; Check if ring obtained already
	ld a,c
	add $04
	ld c,a
	call checkGlobalFlag
	jr nz,@flagNotSet
	ld a,c
	call setGlobalFlag
	ld a,c
	add $30
	ret
@flagNotSet:
	xor a
	ret

;;
vasu_giveFriendshipRing:
	ld a,FRIENDSHIP_RING
	jr ++

vasu_giveHundredthRing:
	ld a,HUNDREDTH_RING
	jr ++

vasu_giveRingInVar3a:
	ld e,Interaction.var3a
	ld a,(de)
++
	ld b,a
	ld c,$00
	jp giveRingToLink


; ==============================================================================
; INTERACID_GAME_COMPLETE_DIALOG
; ==============================================================================
gameCompleteDialog_markGameAsComplete:
	xor a
	ld (wMapleKillCounter),a
	inc a
	ld (wFileIsCompleted),a
.ifdef ROM_AGES
	ld a,<TX_051c
	ld (wMakuMapTextPresent),a
	ld a,<TX_058c
	ld (wMakuMapTextPast),a
.endif
	ld a,GLOBALFLAG_FINISHEDGAME
	jp setGlobalFlag

.ends
