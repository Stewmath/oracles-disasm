; See data/ages/treasureDisplayData.s for documentation.

treasureDisplayData1:
	.db TREASURE_SEED_SATCHEL,  <wSatchelSelectedSeeds,  $01
	.db TREASURE_SWORD,         <wSwordLevel,            $04
	.db TREASURE_SHIELD,        <wShieldLevel,           $05
	.db TREASURE_TRADEITEM,     <wTradeItem,             $08
	.db TREASURE_FLUTE,         <wFluteIcon,             $0b
	.db TREASURE_SLINGSHOT,     <wShooterSelectedSeeds,  $02
	.db TREASURE_SLINGSHOT,     <wShooterSelectedSeeds,  $03
	.db TREASURE_FEATHER,       <wFeatherLevel,          $06
	.db TREASURE_BOOMERANG,     <wBoomerangLevel,        $07
	.db TREASURE_PIRATES_BELL,  <wPirateBellState,       $09
	.db TREASURE_MAGNET_GLOVES, <wMagnetGlovePolarity,   $0a
	.db $00,                    $00,                     $00

treasureDisplayData2:
	.dw treasureDisplayData_standard
	.dw treasureDisplayData_satchel
	.dw treasureDisplayData_slingshot
	.dw treasureDisplayData_hyperSlingshot
	.dw treasureDisplayData_sword     - 7
	.dw treasureDisplayData_shield    - 7
	.dw treasureDisplayData_feather   - 7
	.dw treasureDisplayData_boomerang - 7
	.dw treasureDisplayData_tradeItem
	.dw treasureDisplayData_pirateBell
	.dw treasureDisplayData_magnetGlove
	.dw treasureDisplayData_flute

	.dw treasureDisplayData_sword

treasureDisplayData_standard:
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_NONE
	.db $00,                         $07, $00, $00, $00, $00, <TX_0900 ; X TREASURE_SHIELD
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_PUNCH
	.db TREASURE_BOMBS,              $9e, $04, $00, $00, $01, <TX_0926 ; TREASURE_BOMBS
	.db $00,                         $97, $02, $00, $00, $ff, <TX_0900 ; TREASURE_CANE_OF_SOMARIA
	.db $00,                         $07, $00, $07, $00, $00, <TX_0900 ; X TREASURE_SWORD
	.db $06,                         $07, $00, $07, $00, $00, <TX_0900 ; X TREASURE_BOOMERANG
	.db TREASURE_ROD_OF_SEASONS,     $98, $02, $00, $00, $02, <TX_0941 ; TREASURE_ROD_OF_SEASONS
	.db $00,                         $07, $00, $07, $00, $03, <TX_0900 ; X TREASURE_MAGNET_GLOVES
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_SWITCH_HOOK_HELPER
	.db TREASURE_SWITCH_HOOK,        $9f, $04, $00, $00, $00, <TX_0900 ; TREASURE_SWITCH_HOOK
	.db $00,                         $00, $02, $00, $00, $ff, <TX_0900 ; TREASURE_SWITCH_HOOK_CHAIN
	.db $00,                         $a1, $03, $a2, $03, $ff, <TX_0928 ; TREASURE_BIGGORON_SWORD
	.db TREASURE_BOMBCHUS,           $a0, $05, $00, $00, $01, <TX_0929 ; TREASURE_BOMBCHUS
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_FLUTE
	.db $00,                         $88, $00, $00, $00, $ff, <TX_0900 ; TREASURE_SHOOTER
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_10
	.db $00,                         $00, $00, $00, $00, $00, <TX_0900 ; TREASURE_HARP
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_12
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_SLINGSHOT
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_14
	.db $00,                         $9b, $04, $00, $00, $ff, <TX_092a ; TREASURE_SHOVEL
	.db $00,                         $99, $05, $00, $00, $ff, <TX_092b ; TREASURE_BRACELET
	.db $00,                         $07, $00, $07, $00, $00, <TX_0900 ; X TREASURE_FEATHER
	.db $00,                         $00, $03, $00, $00, $ff, <TX_0900 ; TREASURE_18
	.db $00,                         $07, $00, $07, $00, $01, <TX_0900 ; X TREASURE_SEED_SATCHEL
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_1a
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_1b
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_1c
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_MINECART_COLLISION
	.db TREASURE_FOOLS_ORE,          $9a, $00, $00, $00, $ff, <TX_093f ; TREASURE_FOOLS_ORE
	.db $00,                         $9a, $00, $9a, $00, $ff, <TX_0900 ; TREASURE_1f
	.db $20,                         $80, $00, $83, $00, $ff, <TX_0932 ; TREASURE_EMBER_SEEDS
	.db TREASURE_SCENT_SEEDS,        $80, $00, $84, $00, $ff, <TX_0933 ; TREASURE_SCENT_SEEDS
	.db TREASURE_PEGASUS_SEEDS,      $80, $00, $85, $00, $ff, <TX_0934 ; TREASURE_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS,         $80, $00, $86, $00, $ff, <TX_0935 ; TREASURE_GALE_SEEDS
	.db TREASURE_MYSTERY_SEEDS,      $80, $00, $87, $00, $ff, <TX_0936 ; TREASURE_MYSTERY_SEEDS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_TUNE_OF_ECHOES
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_TUNE_OF_CURRENTS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_TUNE_OF_AGES
	.db TREASURE_RUPEES,             $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_RUPEES
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_HEART_REFILL
	.db TREASURE_HEART_CONTAINER,    $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_HEART_CONTAINER
	.db TREASURE_HEART_PIECE,        $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_HEART_PIECE
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_RING_BOX
	.db TREASURE_RING,               $24, $00, $00, $00, $01, <TX_0917 ; TREASURE_RING
	.db TREASURE_FLIPPERS,           $22, $05, $23, $05, $ff, <TX_0918 ; TREASURE_FLIPPERS
	.db TREASURE_POTION,             $20, $02, $21, $02, $ff, <TX_0919 ; TREASURE_POTION
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_SMALL_KEY
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_BOSS_KEY
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_COMPASS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_MAP
	.db TREASURE_GASHA_SEED,         $25, $01, $00, $00, $01, <TX_0916 ; TREASURE_GASHA_SEED
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_35
	.db TREASURE_MAKU_SEED,          $00, $00, $00, $00, $ff, <TX_0915 ; TREASURE_MAKU_SEED
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_ORE_CHUNKS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_38
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_39
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3a
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3b
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3c
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3d
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3e
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3f
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; TREASURE_ESSENCE
	.db TREASURE_TRADEITEM,          $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_TRADEITEM
	.db TREASURE_GNARLED_KEY,        $37, $05, $00, $00, $ff, <TX_0944 ; TREASURE_GNARLED_KEY
	.db TREASURE_FLOODGATE_KEY,      $38, $04, $00, $00, $ff, <TX_0945 ; TREASURE_FLOODGATE_KEY
	.db TREASURE_DRAGON_KEY,         $39, $01, $00, $00, $ff, <TX_0946 ; TREASURE_DRAGON_KEY
	.db TREASURE_STAR_ORE,           $f0, $03, $f1, $03, $ff, <TX_094c ; TREASURE_STAR_ORE
	.db TREASURE_RIBBON,             $e6, $02, $e7, $02, $ff, <TX_094d ; TREASURE_RIBBON
	.db TREASURE_SPRING_BANANA,      $e8, $03, $e9, $03, $ff, <TX_0947 ; TREASURE_SPRING_BANANA
	.db TREASURE_RICKY_GLOVES,       $de, $05, $df, $05, $ff, <TX_091b ; TREASURE_RICKY_GLOVES
	.db TREASURE_BOMB_FLOWER,        $f5, $05, $f5, $25, $ff, <TX_091a ; TREASURE_BOMB_FLOWER
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_PIRATES_BELL
	.db TREASURE_TREASURE_MAP,       $ea, $03, $eb, $03, $ff, <TX_094a ; TREASURE_TREASURE_MAP
	.db TREASURE_ROUND_JEWEL,        $e2, $00, $00, $00, $ff, <TX_094b ; TREASURE_ROUND_JEWEL
	.db TREASURE_PYRAMID_JEWEL,      $e3, $02, $00, $00, $ff, <TX_094b ; TREASURE_PYRAMID_JEWEL
	.db TREASURE_SQUARE_JEWEL,       $e4, $01, $00, $00, $ff, <TX_094b ; TREASURE_SQUARE_JEWEL
	.db TREASURE_X_SHAPED_JEWEL,     $e5, $03, $00, $00, $ff, <TX_094b ; TREASURE_X_SHAPED_JEWEL
	.db TREASURE_RED_ORE,            $f2, $02, $00, $00, $ff, <TX_094e ; TREASURE_RED_ORE
	.db TREASURE_BLUE_ORE,           $f2, $01, $00, $00, $ff, <TX_094f ; TREASURE_BLUE_ORE
	.db TREASURE_HARD_ORE,           $f3, $00, $f4, $00, $ff, <TX_0950 ; TREASURE_HARD_ORE
	.db TREASURE_MEMBERS_CARD,       $26, $01, $27, $01, $ff, <TX_091c ; TREASURE_MEMBERS_CARD
	.db TREASURE_MASTERS_PLAQUE,     $26, $03, $27, $03, $ff, <TX_0943 ; TREASURE_MASTERS_PLAQUE
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_55
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_56
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_57
	.db TREASURE_BOMB_FLOWER,        $f7, $04, $f8, $04, $ff, <TX_091a ; TREASURE_BOMB_FLOWER_LOWER_HALF

treasureDisplayData_satchel:
	.db TREASURE_EMBER_SEEDS,        $80, $05, $83, $02, $01, <TX_092d
	.db TREASURE_SCENT_SEEDS,        $80, $05, $84, $03, $01, <TX_092d
	.db TREASURE_PEGASUS_SEEDS,      $80, $05, $85, $01, $01, <TX_092d
	.db TREASURE_GALE_SEEDS,         $80, $05, $86, $01, $01, <TX_092d
	.db TREASURE_MYSTERY_SEEDS,      $80, $05, $87, $00, $01, <TX_092d

treasureDisplayData_slingshot:
	.db TREASURE_EMBER_SEEDS,        $81, $04, $83, $02, $01, <TX_093c
	.db TREASURE_SCENT_SEEDS,        $81, $04, $84, $03, $01, <TX_093c
	.db TREASURE_PEGASUS_SEEDS,      $81, $04, $85, $01, $01, <TX_093c
	.db TREASURE_GALE_SEEDS,         $81, $04, $86, $01, $01, <TX_093c
	.db TREASURE_MYSTERY_SEEDS,      $81, $04, $87, $00, $01, <TX_093c

treasureDisplayData_hyperSlingshot:
	.db TREASURE_EMBER_SEEDS,        $82, $05, $83, $02, $01, <TX_093d
	.db TREASURE_SCENT_SEEDS,        $82, $05, $84, $03, $01, <TX_093d
	.db TREASURE_PEGASUS_SEEDS,      $82, $05, $85, $01, $01, <TX_093d
	.db TREASURE_GALE_SEEDS,         $82, $05, $86, $01, $01, <TX_093d
	.db TREASURE_MYSTERY_SEEDS,      $82, $05, $87, $00, $01, <TX_093d

treasureDisplayData_sword:
	.db TREASURE_SWORD,              $90, $00, $00, $00, $00, <TX_0923
	.db TREASURE_SWORD,              $91, $05, $00, $00, $00, <TX_0924
	.db TREASURE_SWORD,              $92, $04, $00, $00, $00, <TX_0925

treasureDisplayData_shield:
	.db TREASURE_SHIELD,             $93, $00, $00, $00, $00, <TX_0920
	.db TREASURE_SHIELD,             $94, $05, $00, $00, $00, <TX_0921
	.db TREASURE_SHIELD,             $95, $04, $00, $00, $00, <TX_0922

treasureDisplayData_feather:
	.db TREASURE_FEATHER,            $96, $04, $00, $00, $00, <TX_092c
	.db TREASURE_FEATHER,            $97, $05, $00, $00, $00, <TX_093e

treasureDisplayData_boomerang:
	.db TREASURE_BOOMERANG,          $9c, $05, $00, $00, $00, <TX_0927
	.db TREASURE_BOOMERANG,          $9d, $04, $00, $00, $00, <TX_0940

treasureDisplayData_tradeItem:
	.db TREASURE_TRADEITEM,          $c0, $00, $c1, $00, $ff, <TX_0909
	.db TREASURE_TRADEITEM,          $c2, $03, $c2, $23, $ff, <TX_090a
	.db TREASURE_TRADEITEM,          $c3, $00, $c4, $00, $ff, <TX_090b
	.db TREASURE_TRADEITEM,          $c5, $04, $c6, $04, $ff, <TX_090c
	.db TREASURE_TRADEITEM,          $da, $05, $db, $05, $ff, <TX_090d
	.db TREASURE_TRADEITEM,          $c7, $05, $c8, $05, $ff, <TX_090e
	.db TREASURE_TRADEITEM,          $c9, $01, $ca, $01, $ff, <TX_090f
	.db TREASURE_TRADEITEM,          $d0, $01, $d1, $01, $ff, <TX_0910
	.db TREASURE_TRADEITEM,          $d2, $05, $d3, $05, $ff, <TX_0911
	.db TREASURE_TRADEITEM,          $d4, $03, $d5, $03, $ff, <TX_0912
	.db TREASURE_TRADEITEM,          $d6, $01, $d7, $01, $ff, <TX_0913
	.db TREASURE_TRADEITEM,          $d8, $00, $d9, $00, $ff, <TX_0914

treasureDisplayData_pirateBell:
	.db TREASURE_PIRATES_BELL,       $ec, $02, $ed, $02, $ff, <TX_0948
	.db TREASURE_PIRATES_BELL,       $ee, $01, $ef, $01, $ff, <TX_0949

treasureDisplayData_magnetGlove:
	.db TREASURE_MAGNET_GLOVES,      $88, $01, $89, $00, $03, <TX_0942
	.db TREASURE_MAGNET_GLOVES,      $88, $02, $00, $00, $03, <TX_0942

treasureDisplayData_flute:
	.db TREASURE_FLUTE,              $8b, $00, $8c, $00, $ff, <TX_092e
	.db TREASURE_FLUTE,              $8b, $03, $8d, $03, $ff, <TX_092f
	.db TREASURE_FLUTE,              $8b, $02, $8e, $02, $ff, <TX_0930
	.db TREASURE_FLUTE,              $8b, $01, $8f, $01, $ff, <TX_0931
