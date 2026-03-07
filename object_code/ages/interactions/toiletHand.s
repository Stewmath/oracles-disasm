; ==================================================================================================
; INTERAC_TOILET_HAND
; ==================================================================================================
interactionCode5b:
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	call @loadScriptAndInitGraphics
	call interactionSetAlwaysUpdateBit
	callab commonInteractions1.clearFallDownHoleEventBuffer


; Normal script is running; waiting for Link to talk or for something to fall into a hole.
@state1:
	call @respondToObjectInHole
	jr c,@droppedSomethingIntoHole

	call interactionRunScript
	ld h,d
	ld l,Interaction.visible
	bit 7,(hl)
	ret z
	jp interactionAnimateAsNpc

@droppedSomethingIntoHole:
	ld hl,mainScripts.toiletHandScript_reactToObjectInHole
	call interactionSetScript
	jp interactionIncState


; Running the "object fell in a hole" script; returns to state 1 when that's done.
@state2:
	ld a,(wTextIsActive)
	or a
	ret nz

	call interactionRunScript
	jr c,@scriptEnded

	ld h,d
	ld l,Interaction.visible
	bit 7,(hl)
	ret z
	call interactionAnimateAsNpc
	jp interactionAnimate

@scriptEnded:
	call @loadScript
	callab commonInteractions1.clearFallDownHoleEventBuffer
	ld e,Interaction.state
	ld a,$01
	ld (de),a
	ret


@unusedFunc_6c0d:
	call interactionInitGraphics
	jp interactionIncState


@loadScriptAndInitGraphics:
	call interactionInitGraphics
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	call interactionIncState

@loadScript:
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	jp interactionSetScript

;;
; Reads from the "object fallen in hole" buffer at $cfd8 to decide on a reaction. Sets
; var38 to an index based on which item it was to be used in a script later.
;
; @param[out]	cflag	c if there is a defined reaction to the object that fell in the
;                       hole (and something did indeed fall in).
@respondToObjectInHole:
	ld a,(wTextIsActive)
	or a
	ret nz

	ld a,($cfd8)
	inc a
	ld e,a
	ld hl,@objectTypeTable
	call lookupKey
	ret nc

	ld hl,@objectReactionTable
	rst_addDoubleIndex
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,($cfd9)
	ld e,a
	call lookupKey
	ret nc
	ld e,Interaction.var38
	ld (de),a
	ret

@objectTypeTable:
	.db Item.id,        $00
	.db Interaction.id, $01
	.db $00

@objectReactionTable:
	.dw @items
	.dw @interactions

; First byte is the object ID to detect; second is an index that the script will use later
; (gets written to var38).
@items:
	.db ITEM_BOMB,          $00
	.db ITEM_BOMBCHUS,      $01
	.db ITEM_18,            $02
	.db ITEM_EMBER_SEED,    $03
	.db ITEM_SCENT_SEED,    $04
	.db ITEM_GALE_SEED,     $05
	.db ITEM_MYSTERY_SEED,  $06
	.db ITEM_BRACELET,      $07
	.db $00

@interactions:
	.db INTERAC_PUSHBLOCK,  $07
	.db $00

@scriptTable:
	.dw mainScripts.toiletHandScript
