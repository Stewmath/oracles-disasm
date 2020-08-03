.ifdef ROM_AGES
.define SIMPLE_SCRIPT_BANK $0c
.else
.define SIMPLE_SCRIPT_BANK $14
.endif

;;
; @param a Command to execute
; @param hl Current address of script
runScriptCommand:
	bit 7,a
	jp z,_scriptCmd_jump
	push hl
	and $7f
	rst_jumpTable
	.dw _scriptCmd_setState ; 0x80
	.dw _scriptCmd_setSubstate ; 0x81
	.dw _scriptCmd_jump ; 0x82
	.dw scriptCmd_loadScript ; 0x83
	.dw _scriptCmd_spawnInteraction ; 0x84
	.dw _scriptCmd_spawnEnemy ; 0x85
	.dw _scriptCmd_showPasswordScreen ; 0x86
	.dw _scriptCmd_jumpTable_memoryAddress ; 0x87
	.dw _scriptCmd_setCoords ; 0x88
	.dw _scriptCmd_setAngle ; 0x89
	.dw _scriptCmd_8a ; 0x8a
	.dw _scriptCmd_setSpeed ; 0x8b
	.dw _scriptCmd_checkCounter2ZeroAndReset ; 0x8c
	.dw _scriptCmd_setCollideRadii ; 0x8d
	.dw _scriptCmd_writeInteractionByte ; 0x8e
	.dw _scriptCmd_loadSprite ; 0x8f
	.dw _scriptCmd_cpLinkX ; 0x90
	.dw _scriptCmd_writeMemory ; 0x91
	.dw _scriptCmd_orMemory ; 0x92
	.dw _scriptCmd_getRandomBits ; 0x93
	.dw _scriptCmd_addinteractionByte ; 0x94
	.dw _scriptCmd_setZSpeed ; 0x95
	.dw _scriptCmd_setAngleAndExtra ; 0x96
	.dw _scriptCmd_runGenericNpc ; 0x97
	.dw _scriptCmd_showText ; 0x98
	.dw _scriptCmd_waitForText ; 0x99
	.dw _scriptCmd_showTextNonExitable ; 0x9a
	.dw _scriptCmd_checkSomething ; 0x9b
	.dw _scriptCmd_setTextID ; 0x9c
	.dw _scriptCmd_showLoadedText ; 0x9d
	.dw _scriptCmd_checkAButton ; 0x9e
	.dw _scriptCmd_showTextDifferentForLinked ; 0x9f
	.dw _scriptCmd_checkCFC0Bit ; 0xa0
	.dw _scriptCmd_checkCFC0Bit ; 0xa1
	.dw _scriptCmd_checkCFC0Bit ; 0xa2
	.dw _scriptCmd_checkCFC0Bit ; 0xa3
	.dw _scriptCmd_checkCFC0Bit ; 0xa4
	.dw _scriptCmd_checkCFC0Bit ; 0xa5
	.dw _scriptCmd_checkCFC0Bit ; 0xa6
	.dw _scriptCmd_checkCFC0Bit ; 0xa7
	.dw _scriptCmd_xorCFC0Bit ; 0xa8
	.dw _scriptCmd_xorCFC0Bit ; 0xa9
	.dw _scriptCmd_xorCFC0Bit ; 0xaa
	.dw _scriptCmd_xorCFC0Bit ; 0xab
	.dw _scriptCmd_xorCFC0Bit ; 0xac
	.dw _scriptCmd_xorCFC0Bit ; 0xad
	.dw _scriptCmd_xorCFC0Bit ; 0xae
	.dw _scriptCmd_xorCFC0Bit ; 0xaf
	.dw _scriptCmd_jumpIfRoomFlagSet ; 0xb0
	.dw _scriptCmd_orRoomFlags ; 0xb1
	.dw _scriptCmd_none ; 0xb2
	.dw _scriptCmd_jumpIfC6xxSet ; 0xb3
	.dw _scriptCmd_writeC6xx ; 0xb4
	.dw _scriptCmd_jumpIfGlobalFlagSet ; 0xb5
	.dw _scriptCmd_setOrUnsetGlobalFlag ; 0xb6
	.dw _scriptCmd_none ; 0xb7
	.dw _scriptCmd_setLinkCantMoveTo91 ; 0xb8
	.dw _scriptCmd_setLinkCantMoveTo00 ; 0xb9
	.dw _scriptCmd_setLinkCantMoveTo11 ; 0xba
	.dw _scriptCmd_disableMenu ; 0xbb
	.dw _scriptCmd_enableMenu ; 0xbc
	.dw _scriptCmd_disableInput ; 0xbd
	.dw _scriptCmd_enableInput ; 0xbe
	.dw _scriptCmd_none ; 0xbf
	.dw _scriptCmd_callScript ; 0xc0
	.dw _scriptCmd_ret ; 0xc1
	.dw _scriptCmd_none ; 0xc2
	.dw _scriptCmd_jumpIfCBA5Eq ; 0xc3
	.dw _scriptCmd_jumpRandom ; 0xc4
	.dw _scriptCmd_none ; 0xc5
	.dw _scriptCmd_jumpTable ; 0xc6
	.dw _scriptCmd_jumpIfMemorySet ; 0xc7
	.dw _scriptCmd_jumpIfSomething ; 0xc8
	.dw _scriptCmd_jumpIfNoEnemies ; 0xc9
	.dw _scriptCmd_jumpIfLinkVariableNe ; 0xca
	.dw _scriptCmd_jumpIfMemoryEq ; 0xcb
	.dw _scriptCmd_jumpIfInteractionByteEq ; 0xcc
	.dw _scriptCmd_stopIfItemFlagSet ; 0xcd
	.dw _scriptCmd_stopIfRoomFlag40Set ; 0xce
	.dw _scriptCmd_stopIfRoomFlag80Set ; 0xcf
	.dw _scriptCmd_checkCollidedWithLink_onGround ; 0xd0
	.dw _scriptCmd_checkPaletteFadeDone ; 0xd1
	.dw _scriptCmd_checkNoEnemies ; 0xd2
	.dw _scriptCmd_checkFlagSet ; 0xd3
	.dw _scriptCmd_checkInteractionByteEq ; 0xd4
	.dw _scriptCmd_checkMemoryEq ; 0xd5
	.dw _scriptCmd_checkNotCollidedWithLink_ignoreZ ; 0xd6
	.dw _scriptCmd_setCounter1 ; 0xd7
	.dw _scriptCmd_checkCounter2Zero ; 0xd8
	.dw _scriptCmd_checkHeartDisplayUpdated ; 0xd9
	.dw _scriptCmd_checkRupeeDisplayUpdated ; 0xda
	.dw _scriptCmd_checkCollidedWithLink_ignoreZ ; 0xdb
	.dw _scriptCmd_none ; 0xdc
	.dw _scriptCmd_spawnItem ; 0xdd
	.dw _scriptCmd_spawnItem ; 0xde
	.dw _scriptCmd_df ; 0xdf
	.dw scriptCmd_asmCall ; 0xe0
	.dw scriptCmd_asmCallWithParam ; 0xe1
	.dw _scriptCmd_createPuff ; 0xe2
	.dw _scriptCmd_playSound ; 0xe3
	.dw _scriptCmd_setMusic ; 0xe4
	.dw _scriptCmd_setLinkCantMove ; 0xe5
	.dw _scriptCmd_spawnEnemyHere ; 0xe6
	.dw _scriptCmd_setTile ; 0xe7
	.dw _scriptCmd_setTileHere ; 0xe8
	.dw _scriptCmd_updateLinkLocalRespawnPosition ; 0xe9
	.dw _scriptCmd_shakeScreen ; 0xea
	.dw _scriptCmd_initNpcHitbox ; 0xeb
	.dw _scriptCmd_moveNpcUp ; 0xec
	.dw _scriptCmd_moveNpcRight ; 0xed
	.dw _scriptCmd_moveNpcDown ; 0xee
	.dw _scriptCmd_moveNpcLeft ; 0xef
	.dw _scriptCmd_delay ; 0xf0
	.dw _scriptCmd_delay ; 0xf1
	.dw _scriptCmd_delay ; 0xf2
	.dw _scriptCmd_delay ; 0xf3
	.dw _scriptCmd_delay ; 0xf4
	.dw _scriptCmd_delay ; 0xf5
	.dw _scriptCmd_delay ; 0xf6
	.dw _scriptCmd_delay ; 0xf7
	.dw _scriptCmd_delay ; 0xf8
	.dw _scriptCmd_delay ; 0xf9
	.dw _scriptCmd_delay ; 0xfa
	.dw _scriptCmd_delay ; 0xfb
	.dw _scriptCmd_delay ; 0xfc

;;
_scriptCmd_none:
	pop hl
	ret

;;
_scriptCmd_stopIfItemFlagSet:
	ld b,ROOMFLAG_ITEM
	jr _scriptFunc_checkRoomFlag
;;
_scriptCmd_stopIfRoomFlag40Set:
	ld b,ROOMFLAG_40
	jr _scriptFunc_checkRoomFlag
;;
_scriptCmd_stopIfRoomFlag80Set:
	ld b,ROOMFLAG_80
_scriptFunc_checkRoomFlag:
	call getThisRoomFlags
	and b
	jp z,_scriptFunc_popHlAndInc
	pop hl
	ld hl,stubScript
	scf
	ret

;;
_scriptCmd_showPasswordScreen:
	pop hl
	inc hl
	ldi a,(hl)
	push hl
	cp $ff
	jr z,@openSecretMenu

	ld b,a
	swap a
	and $03
	rst_jumpTable

.ifdef ROM_AGES
	.dw @askForSecret
	.dw @generateSecret
	.dw @generateSecret
	.dw @askForSecret
.else; ROM_SEASONS
	.dw @generateSecret
	.dw @askForSecret
	.dw @askForSecret
	.dw @generateSecret
.endif

;;
@askForSecret:
	ld a,b
	or $80
;;
@openSecretMenu:
	call openSecretInputMenu
	jr ++

;;
@generateSecret:
	ld a,b
	ld (wShortSecretIndex),a
	ld bc,$0003
	call secretFunctionCaller
++
	pop hl
	xor a
	ret

;;
_scriptCmd_disableInput:
	ld a,$81
	ld (wDisabledObjects),a
_scriptCmd_disableMenu:
	ld a,$80
	ld (wMenuDisabled),a
	call clearAllParentItems
	call dropLinkHeldItem
	call _func_0c_4177
_scriptFunc_popHlAndInc:
	pop hl
	inc hl
	scf
	ret

;;
_scriptCmd_enableInput:
	xor a
	ld (wDisabledObjects),a
_scriptCmd_enableMenu:
	xor a
	ld (wMenuDisabled),a
	jr _scriptFunc_popHlAndInc

_scriptCmd_setLinkCantMoveTo91:
	ld a,$91
_scriptFunc_setLinkCantMove:
	ld (wDisabledObjects),a
	pop hl
	inc hl
	ret

;;
_scriptCmd_setLinkCantMoveTo00:
	xor a
	jr _scriptFunc_setLinkCantMove
;;
_scriptCmd_setLinkCantMoveTo11:
	ld a,$11
	jr _scriptFunc_setLinkCantMove

;;
_func_0c_4177:
	push hl
	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,<w1Link.invincibilityCounter
	ld (hl),$80
	ld l,<w1Link.knockbackCounter
	ld (hl),$00
	pop hl
	ret

;;
_scriptCmd_setState:
	pop hl
	inc hl
	ld e,Interaction.state
;;
_scriptFunc_setState:
	ldi a,(hl)
	cp $ff
	jr z,++

	ld (de),a
	xor a
	ret
++
	ld a,(de)
	inc a
	ld (de),a
	xor a
	ret

;;
_scriptCmd_setSubstate:
	pop hl
	inc hl
	ld e,Interaction.substate
	jr _scriptFunc_setState

;;
; This is for all commands under $80.
_scriptCmd_jump:

.ifdef ROM_AGES
	ld a,h
	cp $80
	jr c,++

	ldh a,(<hScriptAddressL)
	ld c,a
	ldh a,(<hScriptAddressH)
	ld b,a
	inc hl
	ldd a,(hl)
	sub c
	ld e,a
	ld a,(hl)
	sbc b
	or a
	jr nz,++

	ld l,e
	ld h,>wBigBuffer
	ret
++
.endif
	ldi a,(hl)
	ld l,(hl)
	ld h,a
	scf
	ret

;;
_scriptCmd_spawnInteraction:
	pop hl
	inc hl
	call _scriptFunc_loadBcAndDe
	push hl
	call getFreeInteractionSlot
	jr nz,_scriptFunc_restoreActiveObject

	ld a,Interaction.yh
	call _scriptFunc_initializeObject
_scriptFunc_restoreActiveObject:
	ldh a,(<hActiveObject)
	ld d,a
	pop hl
	ret

;;
; Loads bc and de from hl (bc first, de second, big-endian).
_scriptFunc_loadBcAndDe:
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld e,a
	ret

;;
; @param[in] a Address of object's YH variable
; @param[in] bc ID of the object
; @param[in] de YX coordinates
; @param[in] hl Address of object
_scriptFunc_initializeObject:
	ld (hl),b
	inc l
	ld (hl),c
	inc l
	ld l,a
	ld (hl),d
	inc l
	inc l
	ld (hl),e
	ret

;;
_scriptCmd_spawnEnemy:
	pop hl
	inc hl
	call _scriptFunc_loadBcAndDe
	push hl
	call getFreeEnemySlot
	jr nz,_scriptFunc_restoreActiveObject

	ld a,Enemy.yh
	call _scriptFunc_initializeObject
	jr _scriptFunc_restoreActiveObject

_scriptCmd_spawnEnemyHere:
	pop hl
	inc hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	push hl
	ld e,Interaction.yh
	ld a,(de)
	ld l,a
	ld e,Interaction.xh
	ld a,(de)
	ld e,a
	ld d,l
	call getFreeEnemySlot
	jr nz,_scriptFunc_restoreActiveObject
	ld a,Enemy.yh
	call _scriptFunc_initializeObject
	jr _scriptFunc_restoreActiveObject

_scriptCmd_jumpTable_memoryAddress:
	pop hl
	inc hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ld a,(bc)
	rst_addDoubleIndex
	jp scriptFunc_jump

_scriptCmd_setCoords:
	pop hl
	inc hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	push hl
	ld h,d
	ld l,Interaction.yh
	ld (hl),b
	ld l,Interaction.xh
	ld (hl),c
	pop hl
	ret

_scriptCmd_setAngle:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a
	ret

_scriptCmd_setSpeed:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,Interaction.speed
	ld (de),a
	ret

_scriptCmd_setZSpeed:
	pop hl
	inc hl
	ld e,Interaction.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	scf
	ret

_scriptCmd_checkCounter2ZeroAndReset:
	pop hl
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret nz

	inc hl
	ldi a,(hl)
	ld (de),a
	ret

_scriptCmd_setCollideRadii:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,Interaction.collisionRadiusY
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	ret

_scriptCmd_writeInteractionByte:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld (de),a
	ret

_scriptCmd_addinteractionByte:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld b,a
	ld a,(de)
	add b
	ld (de),a
	scf
	ret

_scriptCmd_getRandomBits:
	pop hl
	inc hl
	call getRandomNumber
	ld b,a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	and b
	ld (de),a
	ret

_scriptCmd_loadSprite:
	pop hl
	inc hl
	ldi a,(hl)
	cp $ff
	jr nz,+

	ld e,Interaction.angle
	call convertAngleDeToDirection
	jr ++
+
	cp $fe
	jr nz,++

	ldi a,(hl)
	ld e,a
	ld a,(de)
++
	push hl
	call interactionSetAnimation
	pop hl
	ld a,:_scriptCmd_loadSprite
	setrombank
	ret

_scriptCmd_8a:
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	swap a
	rlca
	call interactionSetAnimation
	jp _scriptFunc_popHlAndInc

_scriptCmd_setAngleAndExtra:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,Interaction.angle
	ld (de),a
	call convertAngleDeToDirection
	push hl
	call interactionSetAnimation
	pop hl
	scf
	ret

_scriptCmd_runGenericNpc:
	pop hl
	inc hl
	call _scriptFunc_getTextIndex
	ld a,c
	ld e,Interaction.textID
	ld (de),a
	ld a,b
	inc e
	ld (de),a
	ld hl,genericNpcScript
	ret

;;
_scriptFunc_getTextIndex:
	ld e,Interaction.useTextID
	ld a,(de)
	or a
	jr z,+

	ld e,Interaction.textID+1
	ld a,(de)
	ld b,a
	jr ++
+
	ldi a,(hl)
	ld b,a
++
	ldi a,(hl)
	ld c,a
	ret

_scriptCmd_showText:
	pop hl
	inc hl
	call _scriptFunc_getTextIndex
	push hl
	call showText
	pop hl
	ret

_scriptCmd_showTextDifferentForLinked:
	pop hl
	inc hl
	ldi a,(hl)
	ld b,a
	call checkIsLinkedGame
	jr nz,@linked
@unlinked:
	ldi a,(hl)
	inc hl
	jr ++
@linked:
	inc hl
	ldi a,(hl)
++
	ld c,a
	push hl
	call showText
	pop hl
	ret

_scriptCmd_showTextNonExitable:
	pop hl
	inc hl
	call _scriptFunc_getTextIndex
	push hl
	call showTextNonExitable
	pop hl
	ret

_scriptCmd_waitForText:
	pop hl
	ld a,(wTextIsActive)
	or a
	ret nz
	inc hl
	ret

_scriptCmd_setCounter1:
	pop hl
	inc hl
	ldi a,(hl)
_scriptFunc_4310:
	ld e,Interaction.counter1
	ld (de),a
	xor a
	ret

_scriptCmd_cpLinkX:
	pop hl
	inc hl
	push hl
	ld e,Interaction.xh
	ld a,(de)
	ld hl,w1Link.xh
	cp (hl)
	pop hl
	ldi a,(hl)
	ld e,a
	ld a,$00
	jr nc,+
	inc a
+
	ld (de),a
	scf
	ret

_scriptCmd_shakeScreen:
	pop hl
	inc hl
	ldi a,(hl)
	ld (wScreenShakeCounterX),a
	ret

_scriptCmd_writeMemory:
	pop hl
	inc hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld (bc),a
	scf
	ret

_scriptCmd_checkPaletteFadeDone:
	pop hl
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	inc hl
	ret

_scriptCmd_checkCFC0Bit:
	pop hl
	ld a,(hl)
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld b,a
	ld a,($cfc0)
	and b
	ret z
	inc hl
	ret

_scriptCmd_xorCFC0Bit:
	pop hl
	ld a,(hl)
	and $07
	ld bc,bitTable
	add c
	ld c,a
	ld a,(bc)
	ld b,a
	ld a,($cfc0)
	xor b
	ld ($cfc0),a
	inc hl
	ret

_scriptCmd_jumpIfNoEnemies:
	pop hl
	ld a,(wNumEnemies)
	or a
	jp nz,scriptFunc_add3ToHl
	inc hl
	jp scriptFunc_jump

_scriptCmd_jumpIfC6xxSet:
	pop hl
	inc hl
	ld b,$c6
	ld c,(hl)
	inc hl
	ld a,(bc)
	and (hl)
	jp z,scriptFunc_add3ToHl
	inc hl
	jp scriptFunc_jump

_scriptCmd_playSound:
	pop hl
	inc hl
	ldi a,(hl)
	push hl
	call playSound
	pop hl
	ret

_scriptCmd_updateLinkLocalRespawnPosition:
	call updateLinkLocalRespawnPosition
	pop hl
	inc hl
	ret

_scriptCmd_jumpIfLinkVariableNe:
	pop hl
	inc hl
	ldi a,(hl)
	ld d,LINK_OBJECT_INDEX
	ld e,a
	ld a,(de)
	cp (hl)
	jr z,+

	inc hl
	jp scriptFunc_jump
+
	ld bc,$0003
	add hl,bc
	ldh a,(<hActiveObject)
	ld d,a
	ret

_scriptCmd_jumpIfMemoryEq:
	pop hl
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl
	ld a,(bc)
--
	cp (hl)
	jp nz,scriptFunc_add3ToHl_scf
	inc hl
	jp scriptFunc_jump_scf

_scriptCmd_jumpIfInteractionByteEq:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,a
	ld a,(de)
	jr --

_scriptCmd_jumpIfRoomFlagSet:
	pop hl
	inc hl
	ldi a,(hl)
	ld b,a
	push hl
	call getThisRoomFlags
	and b
	jr nz,@flagset
@flagunset:
	pop hl
	inc hl
	inc hl
	scf
	ret
@flagset:
	pop hl
	jp scriptFunc_jump_scf

_scriptCmd_orRoomFlags:
	pop hl
	inc hl
	ldi a,(hl)
	ld b,a
	push hl
	call getThisRoomFlags
	or b
	ld (hl),a
	pop hl
	ret

_scriptCmd_checkSomething:
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	pop hl
	jr nc,+
	inc hl
+
	ret

_scriptCmd_showLoadedText:
	ld e,Interaction.textID
	ld a,(de)
	ld c,a
	inc e
	ld a,(de)
	ld b,a
	call showText
	pop hl
	inc hl
	ret

_scriptCmd_setTextID:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,Interaction.textID
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	scf
	ret

_scriptCmd_setMusic:
	pop hl
	inc hl
	ldi a,(hl)
	cp $ff
	jr nz,+
	ld a,(wActiveMusic2)
+
	ld (wActiveMusic),a
	push hl
	call playSound
	pop hl
	ret

_scriptCmd_orMemory:
	pop hl
	inc hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ld a,(bc)
	or (hl)
	ld (bc),a
	inc hl
	scf
	ret

_scriptCmd_spawnItem:
	pop hl
	ld e,(hl)
	inc hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	push hl
	call getFreeInteractionSlot
	jp nz,_scriptFunc_restoreActiveObject
	ld (hl),INTERACID_TREASURE
	inc l
	ld (hl),b
	inc l
	ld (hl),c
	ld a,e
	cp $de
	jr z,+
	call objectCopyPosition
	jp _scriptFunc_restoreActiveObject
+
	ld e,Interaction.counter1
	ld a,$03
	ld (de),a
	ld de,w1Link.yh
	call objectCopyPosition_rawAddress
	jp _scriptFunc_restoreActiveObject

_scriptCmd_df:
	pop hl
	inc hl
	ldi a,(hl)
	call checkTreasureObtained
	ld ($cfc1),a
	jr nc,+
	jp scriptFunc_jump
+
	inc hl
	inc hl
	ret

_scriptCmd_jumpIfSomething:
	pop hl
	inc hl
	ld a,TREASURE_TRADEITEM
	call checkTreasureObtained
	jr nc,++

	ld b,a
	ldi a,(hl)
	dec a
	cp b
	jr nz,+++
	jp scriptFunc_jump
++
	inc hl
+++
	inc hl
	inc hl
	ret

_scriptCmd_setLinkCantMove:
	pop hl
	inc hl
	ldi a,(hl)
	ld (wDisabledObjects),a
	ret

_scriptCmd_checkCounter2Zero:
	pop hl
	ld e,Interaction.counter2
	ld a,(de)
	or a
	ret nz
	inc hl
	ret

_scriptCmd_setTile:
	pop hl
	inc hl
	ldi a,(hl)
--
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	scf
	ret

_scriptCmd_setTileHere:
	pop hl
	inc hl
	call objectGetShortPosition
	jr --

_scriptCmd_callScript:
	pop hl
	inc hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ld e,Interaction.scriptRet
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a
	ld l,c
	ld h,b
	ret

_scriptCmd_ret:
	pop hl
	ld e,Interaction.scriptRet
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a
	ret

--
	inc hl
	jp scriptFunc_jump_scf
_scriptCmd_jumpIfCBA5Eq:
	pop hl
	inc hl
	ld a,(wSelectedTextOption)
	cp (hl)
	jr z,--
	jp scriptFunc_add3ToHl_scf

_scriptCmd_jumpRandom:
.ifdef ROM_AGES
	pop hl
	inc hl
	jp scriptFunc_jump_scf

.else; ROM_SEASONS
	pop hl
	inc hl
	call getRandomNumber
	and $01
	add a
	rst_addAToHl
	jp scriptFunc_jump_scf
.endif

_scriptCmd_jumpTable:
	pop hl
	inc hl
	ldi a,(hl)
	ld e,a
	ld a,(de)
	rst_addDoubleIndex
	jp scriptFunc_jump

_scriptCmd_jumpIfMemorySet:
	pop hl
	inc hl
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	inc hl
	ld a,(bc)
	and (hl)
	jp z,scriptFunc_add3ToHl
	inc hl
	jp scriptFunc_jump_scf

_scriptCmd_writeC6xx:
	pop hl
	inc hl
	ld b,$c6
	ld c,(hl)
	inc hl
	ldi a,(hl)
	ld (bc),a
	ret

_scriptCmd_checkCollidedWithLink_ignoreZ:
	call objectCheckCollidedWithLink_ignoreZ
	pop hl
	ret nc
	jr ++

_scriptCmd_checkCollidedWithLink_onGround:
	call objectCheckCollidedWithLink_onGround
	pop hl
	ret nc
++
	call _func_0c_4177
	inc hl
	ret

_scriptCmd_checkAButton:
	ld e,Interaction.pressedAButton
	ld a,(de)
	or a
	pop hl
	ret z

	xor a
	ld (de),a
	call _func_0c_4177
	inc hl
	scf
	ret

_scriptCmd_checkNoEnemies:
	pop hl
	ld a,(wNumEnemies)
	or a
	ret nz
	inc hl
	ret

_scriptCmd_checkFlagSet:
	pop hl
	push hl
	inc hl
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,b
	call checkFlag
	pop hl
	ret z
	ld bc,$0004
	add hl,bc
	scf
	ret

_scriptCmd_checkInteractionByteEq:
	pop hl
	push hl
	inc hl
	ldi a,(hl)
	ld e,a
	ld a,(de)
	cp (hl)
	jr z,+

	pop hl
	xor a
	ret
+
	pop bc
	inc hl
	ret

_scriptCmd_checkMemoryEq:
	pop hl
	push hl
	inc hl
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld b,a
	ld a,(bc)
	cp (hl)
	jr z,+

	pop hl
	xor a
	ret
+
	pop bc
	inc hl
	ret

_scriptCmd_checkHeartDisplayUpdated:
	pop hl
	ld a,(wDisplayedHearts)
	ld b,a
	ld a,(wLinkHealth)
	cp b
	jr z,+
	xor a
	ret
+
	inc hl
	scf
	ret

_scriptCmd_checkRupeeDisplayUpdated:
	ld hl,wNumRupees
	ld a,(wDisplayedRupees)
	cp (hl)
	jr nz,+

	inc l
	ld a,(wDisplayedRupees+1)
	cp (hl)
	jp z,_scriptFunc_popHlAndInc
+
	pop hl
	xor a
	ret

_scriptCmd_checkNotCollidedWithLink_ignoreZ:
	call objectCheckCollidedWithLink_ignoreZ
	pop hl
	jr c,+
	inc hl
	ret
+
	xor a
	ret

_scriptCmd_createPuff:
	call objectCreatePuff
	pop hl
	inc hl
	ret

_scriptCmd_jumpIfGlobalFlagSet:
	pop hl
	inc hl
	ldi a,(hl)
	push hl
	call checkGlobalFlag
	pop hl
	jr z,+
	jp scriptFunc_jump_scf
+
	inc hl
	inc hl
	scf
	ret

_scriptCmd_setOrUnsetGlobalFlag:
	pop hl
	inc hl
	ldi a,(hl)
	bit 7,a
	jr nz,@unset
@set:
	push hl
	call setGlobalFlag
	pop hl
	scf
	ret
@unset:
	and $7f
	push hl
	call unsetGlobalFlag
	pop hl
	scf
	ret

_scriptCmd_initNpcHitbox:
.ifdef ROM_AGES
	ld e,Interaction.collisionRadiusY
	ld a,(de)
	or a
	jr nz,+
.endif

	ld a,$06
	call objectSetCollideRadius
+
	ld e,Interaction.pressedAButton
	call objectRemoveFromAButtonSensitiveObjectList
	ld e,Interaction.pressedAButton
	call objectAddToAButtonSensitiveObjectList
	pop hl
	ret nc

	inc hl
	scf
	ret

_scriptCmd_moveNpcUp:
	ld a,$00
--
	ld e,Interaction.angle
	ld (de),a
	call convertAngleDeToDirection
	call interactionSetAnimation
	pop hl
	inc hl
	ldi a,(hl)
	ld e,Interaction.counter2
	ld (de),a
	xor a
	ret

_scriptCmd_moveNpcRight:
	ld a,$08
	jr --

_scriptCmd_moveNpcDown:
	ld a,$10
	jr --

_scriptCmd_moveNpcLeft:
	ld a,$18
	jr --

_scriptCmd_delay:
	pop hl
	ldi a,(hl)
	and $0f
	ld bc,@delayLengths
	call addAToBc
	ld a,(bc)
	jp _scriptFunc_4310

@delayLengths:
	.db 1 4 8 10 15 20 30 40 60 90 120 180 240
