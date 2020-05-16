; Pirate ship departing
objectData_sandPuffsFromShipDigging:
	obj_SpecificEnemyA $02 $5b00 $34 $44
	obj_SpecificEnemyA     $5b00 $30 $56
	obj_SpecificEnemyA     $5b00 $30 $68
	obj_SpecificEnemyA     $5b00 $30 $7a
	obj_SpecificEnemyA     $5b00 $34 $8c
	obj_End

objectData_leavingSamasaDesert:
	obj_Interaction $7400 $28 $78
	obj_Interaction $b107 $f8 $f8
	obj_End

objectData_pirateShipEnteringWestCoast:
	obj_Interaction $7401 $f8 $68
	obj_Interaction $7403 $78 $68
	obj_Interaction $7408 $a8 $50
	obj_Interaction $7409 $a8 $80
	obj_Interaction $7405 $f8 $68
	obj_Interaction $7406 $18 $98
	obj_End

objectData_insidePirateShipLeavingSubrosia:
	obj_Interaction $b101 $00 $00
	obj_Interaction $b200 $58 $60
	obj_Interaction $b103 $48 $88
	obj_Interaction $b103 $38 $58
	obj_Interaction $b103 $28 $78
	obj_Interaction $b103 $28 $88
	obj_End

objectData_sickPiratiansInShip:
	obj_Interaction $b108 $f8 $00
	obj_Interaction $b109 $f8 $00
	obj_Interaction $b10d $28 $78
	obj_Interaction $b10e $28 $88
	obj_End


; Onox castle essence cutscene
objectData7e40:
	obj_Interaction $b301 $48 $50
	obj_Interaction $b303 $48 $50
	obj_End


; In Sokra interaction code
objectData7e4a:
	obj_Pointer objectData4468
	obj_End


; Din dancing NPCs
objectData7e4e:
	obj_Interaction $4e00 $29 $18
	obj_Interaction $4e01 $59 $52
	obj_Interaction $4e02 $49 $74
	obj_Interaction $4e03 $59 $74
	obj_Interaction $4e04 $68 $38
	obj_Interaction $4e05 $45 $58
	obj_Interaction $4e06 $10 $48
	obj_End


; Subrosian dancers
objectData7e6c:
	obj_Interaction $6a01 $38 $88
	obj_Interaction $6a02 $21 $00
	obj_Interaction $6a02 $41 $01
	obj_Interaction $6a02 $61 $02
	obj_Interaction $6a02 $63 $03
	obj_Interaction $6a02 $65 $04
	obj_Interaction $6a02 $56 $05
	obj_Interaction $6a02 $16 $06
	obj_Interaction $6a02 $14 $07
	obj_Interaction $6a02 $12 $08
	obj_End


; D4 miniboss room - N door controller and dark room handler
objectData7e96:
	obj_Interaction $1e14 $07 $00
	obj_Part $0800 $00
	obj_End


; Spawned by interactioncode95 inside King Moblin rest house
objectData7ea0:
	obj_Interaction $9b00
	obj_Interaction $9600 $28 $28
	obj_Part $1600 $68 $80 $00
	obj_End

