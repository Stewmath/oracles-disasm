; ==================================================================================================
; INTERAC_PATCH
;
; Variables:
;   var38: 0 if Link has the broken tuni nut; 1 otherwise (upstairs script)
;   var39: Set by another object (subid 3) when all beetles are killed
; ==================================================================================================
interactionCode94:
	ld e,Interaction.subid
	ld a,(de)
	ld e,Interaction.state
	rst_jumpTable
	.dw patch_subid00
	.dw patch_subid01
	.dw patch_subid02
	.dw patch_subid03
	.dw patch_subid04
	.dw patch_subid05
	.dw patch_subid06
	.dw patch_subid07


; Patch in the upstairs room
patch_subid00:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	; If tuni nut's state is 1, set it back to 0 (put it back in Link's inventory if
	; the tuni nut game failed)
	ld hl,wTuniNutState
	ld a,(hl)
	dec a
	jr nz,+
	ld (hl),a
+
	; Similarly, revert the trade item back to broken sword if failed the minigame
	ld hl,wTradeItem
	ld a,(hl)
	cp TRADEITEM_DOING_PATCH_GAME
	jr nz,+
	ld (hl),TRADEITEM_BROKEN_SWORD
+
	ld a,(wTmpcfc0.patchMinigame.patchDownstairs)
	dec a
	jp z,interactionDelete

	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState

	ld l,Interaction.speed
	ld (hl),SPEED_100

	call objectSetVisiblec2
	ld a,GLOBALFLAG_PATCH_REPAIRED_EVERYTHING
	call checkGlobalFlag
	ld hl,mainScripts.patch_upstairsRepairedEverythingScript
	jr nz,@setScript

	ld a,<TX_5813
	ld (wTmpcfc0.patchMinigame.itemNameText),a
	ld a,$01
	ld (wTmpcfc0.patchMinigame.fixingSword),a

	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,@notRepairingSword
	cp TRADEITEM_BROKEN_SWORD
	jr nz,@notRepairingSword

	ld a,TREASURE_SWORD
	call checkTreasureObtained
	and $01
	ld (wTmpcfc0.patchMinigame.swordLevel),a
	ld hl,mainScripts.patch_upstairsRepairSwordScript
	jr @setScript

@notRepairingSword:
	ld a,<TX_5812
	ld (wTmpcfc0.patchMinigame.itemNameText),a
	xor a
	ld (wTmpcfc0.patchMinigame.fixingSword),a

	; Set var38 to 1 if Link doesn't have the broken tuni nut
	ld a,TREASURE_TUNI_NUT
	call checkTreasureObtained
	ld hl,mainScripts.patch_upstairsRepairTuniNutScript
	jr nc,++
	or a
	jr z,@setScript
++
	ld e,Interaction.var38
	ld a,$01
	ld (de),a
@setScript:
	jp interactionSetScript

@state1:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	ret nz
	call interactionRunScript
	jp nc,npcFaceLinkAndAnimate

	; Done the script; now load another script to move downstairs

	call interactionIncState
	ld hl,mainScripts.patch_upstairsMoveToStaircaseScript
	jp interactionSetScript


@state2:
	call interactionRunScript
	jp nc,interactionAnimate

	; Done moving downstairs; restore control to Link
	xor a
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a
	inc a
	ld (wTmpcfc0.patchMinigame.patchDownstairs),a
	jp interactionDelete


; Patch in his minigame room
patch_subid01:
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6

@state0:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	call objectSetVisiblec2

	ld hl,wTmpcfc0.patchMinigame.patchDownstairs
	ldi a,(hl)
	or a
	jp z,interactionDelete

	ldi a,(hl) ; a = [wTmpcfc0.patchMinigame.wonMinigame]
	or a
	jp nz,@alreadyWonMinigame

	xor a
	ldi (hl),a ; [wTmpcfc0.patchMinigame.gameStarted]
	ldi (hl),a ; [wTmpcfc0.patchMinigame.failedGame]
	ld (hl),a  ; [wTmpcfc0.patchMinigame.screenFadedOut]
	inc a
	ld (wDiggingUpEnemiesForbidden),a
	ld hl,mainScripts.patch_downstairsScript
	jp interactionSetScript

; Waiting for Link to talk to Patch to start the minigame
@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call interactionRunScript
	jp nc,npcFaceLinkAndAnimate

	; Script ended, meaning the minigame will begin now

	ld a,$01
	ld (wTmpcfc0.patchMinigame.gameStarted),a

	ld a,SND_WHISTLE
	call playSound
	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	call playSound

	; Spawn subid 3, a "manager" for the beetle enemies.
	ldbc INTERAC_PATCH, $03
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d

	; Update the tuni nut or trade item state
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	or a
	ld hl,wTuniNutState
	ld a,$01
	jr z,++
	ld hl,wTradeItem
	ld a,TRADEITEM_DOING_PATCH_GAME
++
	ld (hl),a

	ld a,$06
	call interactionSetAnimation
	call interactionIncState
	ld l,Interaction.var39
	ld (hl),$00
	ld hl,mainScripts.patch_duringMinigameScript
	call interactionSetScript

; The minigame is running; wait for all enemies to be killed?
@state2:
	ld a,(wTmpcfc0.patchMinigame.failedGame)
	or a
	jr z,@gameRunning

	; Failed minigame

.ifdef ENABLE_US_BUGFIXES
	; This code fixes minor bugs with Patch. In the japanese version, it's possible to open the
	; menu and then move around after the minecart hits the tuni nut. Also, dying as the tuni
	; nut gets hit by the minecart causes graphical glitches.
	call checkLinkCollisionsEnabled
	ret nc
	ld a,DISABLE_LINK
	ld (wDisabledObjects),a

	ld e,Interaction.state
.endif

	ld a,$05
	ld (de),a
	dec a
	jp fadeoutToWhiteWithDelay

@gameRunning:
	; Subid 3 sets var39 to nonzero when all beetles are killed; wait for the signal.
	ld e,Interaction.var39
	ld a,(de)
	or a
	jr z,@runScriptAndAnimate

	; Link won the game.
	xor a
	ld (wTmpcfc0.patchMinigame.gameStarted),a
	ld (w1Link.knockbackCounter),a
	call checkLinkVulnerable
	ret nc

	ld a,DISABLE_ALL_BUT_INTERACTIONS
	ld (wDisabledObjects),a
	ld (wMenuDisabled),a

	; Spawn the repaired item
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	add $06
	ld c,a
	ld b,INTERAC_PATCH
	call objectCreateInteraction
	ret nz
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d

	call interactionIncState
	ld hl,mainScripts.patch_linkWonMinigameScript
	call interactionSetScript
	ld a,SND_SOLVEPUZZLE_2
	call playSound
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	jp playSound

@runScriptAndAnimate:
	call interactionRunScript
	jp interactionAnimateAsNpc

; Just won the game
@state3:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,+
	ld a,(wTextIsActive)
	or a
	jr z,++
+
	jp interactionAnimate
++
	call interactionRunScript
	jr nc,@faceLinkAndAnimate

	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	or a
	ld a,GLOBALFLAG_PATCH_REPAIRED_EVERYTHING
	call nz,setGlobalFlag

@alreadyWonMinigame:
	ld e,Interaction.state
	ld a,$04
	ld (de),a
	ld hl,mainScripts.patch_downstairsAfterBeatingMinigameScript
	jp interactionSetScript

; NPC after winning the game
@state4:
	call interactionRunScript
@faceLinkAndAnimate:
	jp npcFaceLinkAndAnimate

; Failed the game
@state5:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; Delete all the enemies
	ldhl FIRST_ENEMY_INDEX, Enemy.id
@nextEnemy:
	ld a,(hl)
	cp ENEMY_HARMLESS_HARDHAT_BEETLE
	jr nz,++
	push hl
	ld d,h
	ld e,Enemy.start
	call objectDelete_de
	pop hl
++
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	ldh a,(<hActiveObject)
	ld d,a

	; Give back the broken item
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	or a
	ld hl,wTuniNutState
	jr z,+
	ld hl,wTradeItem
	ld a,TRADEITEM_BROKEN_SWORD
+
	ld (hl),a

	call interactionIncState
	ld a,(wActiveMusic2)
	ld (wActiveMusic),a
	call playSound
	ld hl,mainScripts.patch_linkFailedMinigameScript
	jp interactionSetScript

@state6:
	call interactionRunScript
	jr nc,@faceLinkAndAnimate
	ld e,Interaction.state
	xor a
	ld (de),a
	jr @faceLinkAndAnimate


; The minecart in Patch's minigame
patch_subid02:
	ld a,(wActiveTriggers)
	ld (wSwitchState),a
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3

@state0:
	; Spawn the object that will toggle the minecart track when the button is down
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_SWITCH_TILE_TOGGLER
	inc l
	ld (hl),$01
	ld l,Interaction.yh
	ld (hl),$05
	ld l,Interaction.xh
	ld (hl),$0b

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.angle
	ld (hl),ANGLE_RIGHT
	ld l,Interaction.speed
	ld (hl),SPEED_100
	ld a,$06
	call objectSetCollideRadius
	jp objectSetVisible82

; Wait for game to start
@state1:
	ld a,(wTmpcfc0.patchMinigame.gameStarted)
	or a
	ret z

	; Spawn the broken item sprite (INTERAC_PATCH subid 4 or 5)
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PATCH
	inc l
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	add $04
	ld (hl),a
	ld l,Interaction.relatedObj1
	ld a,Interaction.start
	ldi (hl),a
	ld (hl),d
	jp interactionIncState

; Game is running
@state2:
	ld hl,wTmpcfc0.patchMinigame.gameStarted
	ldi a,(hl)
	or a
	jr z,@incState

	; Check if the game is failed; if so, wait for the screen to fade out.
	ldi a,(hl) ; a = [wTmpcfc0.patchMinigame.failedGame]
	or a
	jr z,@gameStillGoing
	ld a,(hl)  ; a = [wTmpcfc0.patchMinigame.screenFadedOut]
	or a
	ret z

	; Reset position
	ld h,d
	ld l,Interaction.yh
	ld (hl),$08
	ld l,Interaction.xh
	ld (hl),$68
@incState:
	jp interactionIncState

@gameStillGoing:
	call objectApplySpeed
	call interactionAnimate

	; Check if it's reached the center of a new tile
	ld h,d
	ld l,Interaction.yh
	ldi a,(hl)
	and $0f
	cp $08
	ret nz
	inc l
	ld a,(hl)
	and $0f
	cp $08
	ret nz

	; Determine the new angle to move in
	call objectGetTileAtPosition
	ld e,a
	ld a,l
	cp $15
	ld a,$08
	jr z,+
	ld hl,@trackTable
	call lookupKey
	ret nc
+
	ld e,Interaction.angle
	ld (de),a
	bit 3,a
	ld a,$07
	jr z,+
	inc a
+
	jp interactionSetAnimation

@trackTable:
	.db TILEINDEX_TRACK_TR, ANGLE_DOWN
	.db TILEINDEX_TRACK_BR, ANGLE_LEFT
	.db TILEINDEX_TRACK_BL, ANGLE_UP
	.db TILEINDEX_TRACK_TL, ANGLE_RIGHT
	.db $00

; Stop moving until the game starts up again
@state3:
	ld a,(wTmpcfc0.patchMinigame.gameStarted)
	or a
	ret nz
	inc a
	ld (de),a
	ret


; Subid 3 = Beetle "manager"; spawns them and check when they're killed.
;
; Variables:
;   counter1: Number of beetles to be killed (starts at 4 or 8)
;   var3a: Set to 1 when another beetle should be spawned
;   var3b: Number of extra beetles spawned so far
patch_subid03:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	callab commonInteractions1.clearFallDownHoleEventBuffer
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),60
	ret

@state1:
	call interactionDecCounter1
	ret nz

	; Determine total number of beetles (4 or 8) and write that to counter1
	ld a,(wTmpcfc0.patchMinigame.fixingSword)
	add a
	add a
	add $04
	ld (hl),a
	call interactionIncState

	ld c,$44
	call @spawnBeetle
	ld c,$4a
	call @spawnBeetle
	ld c,$75
	call @spawnBeetle
	ld c,$78
@spawnBeetle:
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_PUFF
	ld l,Interaction.yh
	call setShortPosition_paramC
	call getFreeEnemySlot
	ret nz
	ld (hl),ENEMY_HARMLESS_HARDHAT_BEETLE
	ld l,Enemy.yh
	call setShortPosition_paramC
	xor a
	ret

@state2:
	ld a,(wTmpcfc0.patchMinigame.failedGame)
	or a
	jr nz,@delete

	; Check which objects have fallen into holes
	ld hl,wTmpcfc0.fallDownHoleEvent.cfd8+1
	ld b,$04
---
	ldi a,(hl)
	cp ENEMY_HARMLESS_HARDHAT_BEETLE
	jr nz,@nextFallenObject

	push hl
	call interactionDecCounter1
	jr z,@allBeetlesKilled
	ld a,(hl)
	cp $04
	jr c,++
	ld l,Interaction.var3a
	inc (hl)
++
	pop hl

@nextFallenObject:
	inc l
	dec b
	jr nz,---

	ld e,Interaction.var3a
	ld a,(de)
	or a
	jr z,++

	; Killed one of the first 4 beetles; spawn another.
	ld e,Interaction.var3b
	ld a,(de)
	ld hl,@extraBeetlePositions
	rst_addAToHl
	ld c,(hl)
	call @spawnBeetle
	jr nz,++
	ld h,d
	ld l,Interaction.var3a
	dec (hl)
	inc l
	inc (hl)
++
	jpab commonInteractions1.clearFallDownHoleEventBuffer

@allBeetlesKilled:
	; Set parent object's "var39" to indicate that the game's over
	pop hl
	ld a,Object.var39
	call objectGetRelatedObject1Var
	inc (hl)
@delete:
	jp interactionDelete

@extraBeetlePositions:
	.db $4a $57 $75 $78



; Broken tuni nut (4) or sword (5) sprite
patch_subid04:
patch_subid05:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call interactionInitGraphics
	call interactionIncState

	ld l,Interaction.yh
	ld (hl),$18
	ld l,Interaction.xh
	ld (hl),$78
	ld bc,$0606
	call objectSetCollideRadii
	jp objectSetVisible83

@state1:
	; When a "palette fade" occurs, assume the game's ended (go to state 2)
	ld a,(wPaletteThread_mode)
	or a
	jp nz,interactionIncState

	; Check if relatedObj1 (the minecart) has collided with it
	ld a,Object.start
	call objectGetRelatedObject1Var
	call checkObjectsCollided
	ret nc

	; Collision occured; game failed.
	ld a,$01
	ld (wTmpcfc0.patchMinigame.failedGame),a
	ld b,INTERAC_EXPLOSION
	call objectCreateInteractionWithSubid00
	ret nz
	ld l,Interaction.var03
	inc (hl)
	ld l,Interaction.xh
	ld a,(hl)
	sub $08
	ld (hl),a
	jp interactionIncState

@state2:
	ld a,(wTmpcfc0.patchMinigame.screenFadedOut)
	or a
	ret z
	jp interactionDelete



; Fixed tuni nut (6) or sword (7) sprite
patch_subid06:
patch_subid07:
	call checkInteractionState
	jr z,@state0

@state1:
	call interactionDecCounter1
	ret nz
	jp interactionDelete

@state0:
	ld a,(wTmpcfc0.patchMinigame.wonMinigame)
	or a
	ret z

	call interactionInitGraphics
	call interactionIncState
	ld l,Interaction.counter1
	ld (hl),60

	; If this is the L3 sword, need to change the palette & animation
	ld l,Interaction.subid
	ld a,(hl)
	cp $06
	jr z,@getPosition
	ld a,(wTmpcfc0.patchMinigame.swordLevel)
	or a
	jr nz,@getPosition

	ld l,Interaction.oamFlagsBackup
	ld a,$04
	ldi (hl),a
	ld (hl),a
	ld a,$0c
	call interactionSetAnimation

@getPosition:
	; Copy position from relatedObj1 (patch)
	ld a,Object.start
	call objectGetRelatedObject1Var
	ld bc,$f2f8
	call objectTakePositionWithOffset
	jp objectSetVisible81
