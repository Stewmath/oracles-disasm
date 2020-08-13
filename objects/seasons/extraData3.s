; Pirate ship departing
objectData_sandPuffsFromShipDigging:
	obj_SpecificEnemyA $02 $5b $00 $34 $44
	obj_SpecificEnemyA     $5b $00 $30 $56
	obj_SpecificEnemyA     $5b $00 $30 $68
	obj_SpecificEnemyA     $5b $00 $30 $7a
	obj_SpecificEnemyA     $5b $00 $34 $8c
	obj_End

objectData_leavingSamasaDesert:
	obj_Interaction $74 $00 $28 $78
	obj_Interaction $b1 $07 $f8 $f8
	obj_End

objectData_pirateShipEnteringWestCoast:
	obj_Interaction $74 $01 $f8 $68
	obj_Interaction $74 $03 $78 $68
	obj_Interaction $74 $08 $a8 $50
	obj_Interaction $74 $09 $a8 $80
	obj_Interaction $74 $05 $f8 $68
	obj_Interaction $74 $06 $18 $98
	obj_End

objectData_insidePirateShipLeavingSubrosia:
	obj_Interaction $b1 $01 $00 $00
	obj_Interaction $b2 $00 $58 $60
	obj_Interaction $b1 $03 $48 $88
	obj_Interaction $b1 $03 $38 $58
	obj_Interaction $b1 $03 $28 $78
	obj_Interaction $b1 $03 $28 $88
	obj_End

objectData_sickPiratiansInShip:
	obj_Interaction $b1 $08 $f8 $00
	obj_Interaction $b1 $09 $f8 $00
	obj_Interaction $b1 $0d $28 $78
	obj_Interaction $b1 $0e $28 $88
	obj_End


; Onox castle essence cutscene
objectData7e40:
	obj_Interaction $b3 $01 $48 $50
	obj_Interaction $b3 $03 $48 $50
	obj_End


; In Sokra interaction code
objectData7e4a:
	obj_Pointer objectData4468
	obj_End


; Din dancing NPCs
objectData7e4e:
	obj_Interaction $4e $00 $29 $18
	obj_Interaction $4e $01 $59 $52
	obj_Interaction $4e $02 $49 $74
	obj_Interaction $4e $03 $59 $74
	obj_Interaction $4e $04 $68 $38
	obj_Interaction $4e $05 $45 $58
	obj_Interaction $4e $06 $10 $48
	obj_End


; Subrosian dancers
objectData7e6c:
	obj_Interaction $6a $01 $38 $88
	obj_Interaction $6a $02 $21 $00
	obj_Interaction $6a $02 $41 $01
	obj_Interaction $6a $02 $61 $02
	obj_Interaction $6a $02 $63 $03
	obj_Interaction $6a $02 $65 $04
	obj_Interaction $6a $02 $56 $05
	obj_Interaction $6a $02 $16 $06
	obj_Interaction $6a $02 $14 $07
	obj_Interaction $6a $02 $12 $08
	obj_End


; D4 miniboss room - N door controller and dark room handler
objectData7e96:
	obj_Interaction $1e $14 $07 $00
	obj_Part $08 $00 $00
	obj_End


; Spawned by interactioncode95 inside King Moblin rest house
objectData7ea0:
	obj_Interaction $9b $00
	obj_Interaction $96 $00 $28 $28
	obj_Part $16 $00 $68 $80 $00
	obj_End

