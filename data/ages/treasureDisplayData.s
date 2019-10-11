; Data format:
; b0: Treasure to apply this to
; b1: Address of "level" or similar variable, used as an index in a sub-table below
; b2: Which sub-table below to use
; @addr{6d41}
treasureDisplayData1:
	.db TREASURE_SEED_SATCHEL	<wSatchelSelectedSeeds $01
	.db TREASURE_SWORD		<wSwordLevel           $02
	.db TREASURE_SHIELD		<wShieldLevel          $03
	.db TREASURE_BRACELET		<wBraceletLevel        $04
	.db TREASURE_TRADEITEM		<wTradeItem            $05
	.db TREASURE_FLUTE		<wFluteIcon            $06
	.db TREASURE_SHOOTER		<wShooterSelectedSeeds $07
	.db TREASURE_HARP		<wSelectedHarpSong     $08
	.db TREASURE_TUNI_NUT		<wTuniNutState         $09
	.db TREASURE_SWITCH_HOOK	<wSwitchHookLevel      $0a
	.db $00				$00                    $00

; @addr{6d62}
treasureDisplayData2:
	.dw @standardData
	.dw @satchelData
	.dw @swordData    - 7
	.dw @shieldData   - 7
	.dw @braceletData - 7
	.dw @tradeData
	.dw @fluteData
	.dw @shooterData
	.dw @harpData
	.dw @tuniNutData
	.dw @switchHookData-7


; The parts marked as "filler" in this table aren't actually used, since they have their
; respective tables for each level of the item.
;
; Data format:
;  b0: Treasure index to get level / quantity value from (if b5 is not $ff)
;  b1: Left sprite index
;  b2: Left attribute (palette)
;  b3: Right sprite index
;  b4: Right attribute
;  b5: $00: display level
;      $01: display quantity
;      $02: display harp song?
;      $03: display nothing extra (stub?)
;      $04: display number with "x" (ie. x2). Used by slates only.
;      $ff: display nothing extra
;  b6: Low byte of text index (high byte is $09)
;
;  b1 and b3, the "sprite indices", refer to tiles in the vram layout. See gfx header $08
;  for what the vram layout will be at that time. For items which are equippable, the
;  indices correspond to a tile in "gfx_item_icons_X.bin", where X is a number from 1-3.
;
;  The index value is multiplied by two to get the final tile index, since each half
;  consists of two tiles. Also, if bit 7 of the index is set, that tells it to read the
;  graphics from vram bank 1. (It has no effect on the icons when in an equippable slot,
;  though.)

; @addr{6d78}
@standardData:
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_NONE (0x00)
	.db $00				$07 $00 $00 $00 $00 <TX_0900 ; (filler) TREASURE_SHIELD (0x01)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_PUNCH (0x02)
	.db TREASURE_BOMBS		$9e $04 $00 $00 $01 <TX_0926 ; TREASURE_BOMBS (0x03)
	.db $00				$97 $02 $00 $00 $ff <TX_093c ; TREASURE_CANE_OF_SOMARIA (0x04)
	.db $00				$07 $00 $07 $00 $00 <TX_0900 ; (filler) TREASURE_SWORD (0x05)
	.db TREASURE_BOOMERANG		$9c $05 $00 $00 $ff <TX_0927 ; TREASURE_BOOMERANG (0x06)
	.db TREASURE_ROD_OF_SEASONS	$98 $02 $00 $00 $02 <TX_0900 ; TREASURE_ROD_OF_SEASONS (0x07)
	.db $00				$07 $00 $07 $00 $ff <TX_0900 ; TREASURE_MAGNET_GLOVES (0x08)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_SWITCH_HOOK_HELPER (0x09)
	.db $00				$07 $00 $07 $00 $00 <TX_0900 ; (filler) TREASURE_SWITCH_HOOK (0x0a)
	.db $00				$00 $02 $00 $00 $ff <TX_0900 ; TREASURE_SWITCH_HOOK_CHAIN (0x0b)
	.db $00				$a1 $03 $a2 $03 $ff <TX_0928 ; TREASURE_BIGGORON_SWORD (0x0c)
	.db TREASURE_BOMBCHUS		$a0 $05 $00 $00 $01 <TX_0929 ; TREASURE_BOMBCHUS (0x0d)
	.db $00				$07 $00 $07 $00 $ff <TX_0900 ; (filler) TREASURE_FLUTE (0x0e)
	.db $00				$88 $00 $00 $00 $ff <TX_0940 ; (filler) TREASURE_SHOOTER (0x0f)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_10 (0x10)
	.db TREASURE_HARP		$00 $00 $00 $00 $02 <TX_0941 ; (filler) TREASURE_HARP (0x11)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_12 (0x12)
	.db $00				$07 $00 $07 $00 $ff <TX_0900 ; TREASURE_SLINGSHOT (0x13)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_14 (0x14)
	.db $00				$9b $04 $00 $00 $ff <TX_092a ; TREASURE_SHOVEL (0x15)
	.db TREASURE_BRACELET		$99 $05 $00 $00 $00 <TX_092b ; (filler) TREASURE_BRACELET (0x16)
	.db TREASURE_FEATHER		$96 $04 $00 $00 $ff <TX_092c ; TREASURE_FEATHER (0x17)
	.db $00				$00 $03 $00 $00 $ff <TX_0900 ; TREASURE_18 (0x18)
	.db $00				$07 $00 $07 $00 $01 <TX_0900 ; (filler) TREASURE_SEED_SATCHEL (0x19)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_1a (0x1a)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_1b (0x1b)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_1c (0x1c)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_MINECART_COLLISION (0x1d)
	.db TREASURE_FOOLS_ORE		$9a $00 $00 $00 $ff <TX_0900 ; TREASURE_FOOLS_ORE (0x1e)
	.db $00				$9a $00 $9a $00 $ff <TX_0900 ; TREASURE_1f (0x1f)
	.db TREASURE_EMBER_SEEDS 	$80 $00 $83 $00 $ff <TX_0932 ; TREASURE_EMBER_SEEDS (0x20)
	.db TREASURE_SCENT_SEEDS 	$80 $00 $84 $00 $ff <TX_0933 ; TREASURE_SCENT_SEEDS (0x21)
	.db TREASURE_PEGASUS_SEEDS	$80 $00 $85 $00 $ff <TX_0934 ; TREASURE_PEGASUS_SEEDS (0x22)
	.db TREASURE_GALE_SEEDS		$80 $00 $86 $00 $ff <TX_0935 ; TREASURE_GALE_SEEDS (0x23)
	.db TREASURE_MYSTERY_SEEDS	$80 $00 $87 $00 $ff <TX_0936 ; TREASURE_MYSTERY_SEEDS (0x24)
	.db $00				$3a $00 $3b $00 $ff <TX_0942 ; TREASURE_TUNE_OF_ECHOES (0x25)
	.db $00				$3c $00 $3d $00 $ff <TX_0943 ; TREASURE_TUNE_OF_CURRENTS (0x26)
	.db $00				$3e $00 $3f $00 $ff <TX_0944 ; TREASURE_TUNE_OF_AGES (0x27)
	.db TREASURE_RUPEES		$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_RUPEES (0x28)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_HEART_REFILL (0x29)
	.db TREASURE_HEART_CONTAINER	$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_HEART_CONTAINER (0x2a)
	.db TREASURE_HEART_PIECE	$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_HEART_PIECE (0x2b)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_RING_BOX (0x2c)
	.db TREASURE_RING		$24 $00 $00 $00 $01 <TX_0917 ; TREASURE_RING (0x2d)
	.db TREASURE_FLIPPERS		$22 $05 $23 $05 $ff <TX_0918 ; TREASURE_FLIPPERS (0x2e)
	.db TREASURE_POTION		$20 $02 $21 $02 $ff <TX_0919 ; TREASURE_POTION (0x2f)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_SMALL_KEY (0x30)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_BOSS_KEY (0x31)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_COMPASS (0x32)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_MAP (0x33)
	.db TREASURE_GASHA_SEED 	$25 $01 $00 $00 $01 <TX_0916 ; TREASURE_GASHA_SEED (0x34)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_35 (0x35)
	.db TREASURE_MAKU_SEED		$00 $00 $00 $00 $ff <TX_0915 ; TREASURE_MAKU_SEED (0x36)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_ORE_CHUNKS (0x37)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_38 (0x38)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_39 (0x39)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_3a (0x3a)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_3b (0x3b)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_3c (0x3c)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_3d (0x3d)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_3e (0x3e)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_3f (0x3f)
	.db $00				$07 $00 $07 $00 $ff <TX_0900 ; TREASURE_ESSENCE (0x40)
	.db TREASURE_TRADEITEM		$07 $00 $07 $00 $ff <TX_0900 ; (filler) TREASURE_TRADEITEM (0x41)
	.db TREASURE_GRAVEYARD_KEY	$37 $05 $00 $00 $ff <TX_094a ; TREASURE_GRAVEYARD_KEY (0x42)
	.db TREASURE_CROWN_KEY		$38 $02 $00 $00 $ff <TX_094c ; TREASURE_CROWN_KEY (0x43)
	.db TREASURE_OLD_MERMAID_KEY	$39 $05 $00 $00 $ff <TX_0951 ; TREASURE_OLD_MERMAID_KEY (0x44)
	.db TREASURE_MERMAID_KEY	$39 $04 $00 $00 $ff <TX_0952 ; TREASURE_MERMAID_KEY (0x45)
	.db TREASURE_LIBRARY_KEY	$3a $00 $00 $00 $ff <TX_0953 ; TREASURE_LIBRARY_KEY (0x46)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_47 (0x47)
	.db TREASURE_RICKY_GLOVES	$de $05 $df $05 $ff <TX_091b ; TREASURE_RICKY_GLOVES (0x48)
	.db TREASURE_BOMB_FLOWER	$f5 $05 $f5 $25 $ff <TX_091a ; TREASURE_BOMB_FLOWER (0x49)
	.db $00				$2b $04 $2c $04 $ff <TX_0945 ; TREASURE_MERMAID_SUIT (0x4a)
	.db TREASURE_SLATE		$ec $03 $00 $00 $04 <TX_0955 ; TREASURE_SLATE (0x4b)
	.db TREASURE_TUNI_NUT		$07 $00 $07 $00 $ff <TX_0900 ; (filler) TREASURE_TUNI_NUT (0x4c)
	.db TREASURE_SCENT_SEEDLING	$f0 $00 $f1 $00 $ff <TX_0948 ; TREASURE_SCENT_SEEDLING (0x4d)
	.db TREASURE_ZORA_SCALE		$d6 $04 $d7 $04 $ff <TX_0954 ; TREASURE_ZORA_SCALE (0x4e)
	.db TREASURE_TOKAY_EYEBALL	$ed $05 $00 $00 $ff <TX_095a ; TREASURE_TOKAY_EYEBALL (0x4f)
	.db TREASURE_EMPTY_BOTTLE	$e8 $03 $e8 $23 $ff <TX_0900 ; TREASURE_EMPTY_BOTTLE (0x50)
	.db TREASURE_FAIRY_POWDER	$e9 $03 $e9 $23 $ff <TX_0959 ; TREASURE_FAIRY_POWDER (0x51)
	.db TREASURE_CHEVAL_ROPE	$d8 $03 $d9 $03 $ff <TX_0946 ; TREASURE_CHEVAL_ROPE (0x52)
	.db TREASURE_MEMBERS_CARD	$26 $01 $27 $01 $ff <TX_091c ; TREASURE_MEMBERS_CARD (0x53)
	.db TREASURE_ISLAND_CHART	$da $04 $db $04 $ff <TX_0947 ; TREASURE_ISLAND_CHART (0x54)
	.db TREASURE_BOOK_OF_SEALS	$3b $01 $3c $01 $ff <TX_0958 ; TREASURE_BOOK_OF_SEALS (0x55)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_56 (0x56)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_57 (0x57)
	.db TREASURE_BOMB_FLOWER	$f7 $04 $f8 $04 $ff <TX_091a ; TREASURE_58 (0x58)
	.db TREASURE_GORON_LETTER	$ea $03 $eb $03 $ff <TX_0956 ; TREASURE_GORON_LETTER (0x59)
	.db TREASURE_LAVA_JUICE		$e4 $05 $e5 $05 $ff <TX_0950 ; TREASURE_LAVA_JUICE (0x5a)
	.db TREASURE_BROTHER_EMBLEM	$e0 $03 $e1 $03 $ff <TX_0949 ; TREASURE_BROTHER_EMBLEM (0x5b)
	.db TREASURE_GORON_VASE		$e6 $05 $e6 $25 $ff <TX_094e ; TREASURE_GORON_VASE (0x5c)
	.db TREASURE_GORONADE		$e7 $01 $e7 $21 $ff <TX_094f ; TREASURE_GORONADE (0x5d)
	.db TREASURE_ROCK_BRISKET	$e2 $05 $e3 $05 $ff <TX_094d ; TREASURE_ROCK_BRISKET (0x5e)
	.db $00				$00 $00 $00 $00 $ff <TX_0900 ; TREASURE_5f (0x5f)

	; Treasures $60-$67 don't have display data apparently? (they seem to represent
	; upgrades)

; @addr{7018}
@satchelData:
	.db TREASURE_EMBER_SEEDS	$80 $05 $83 $02 $01 <TX_092d ; Ember seeds
	.db TREASURE_SCENT_SEEDS	$80 $05 $84 $03 $01 <TX_092d ; Scent seeds
	.db TREASURE_PEGASUS_SEEDS	$80 $05 $85 $01 $01 <TX_092d ; Pegasus seeds
	.db TREASURE_GALE_SEEDS		$80 $05 $86 $01 $01 <TX_092d ; Gale seeds
	.db TREASURE_MYSTERY_SEEDS	$80 $05 $87 $00 $01 <TX_092d ; Mystery seeds

; @addr{703b}
@shooterData:
	.db TREASURE_EMBER_SEEDS	$81 $05 $83 $02 $01 <TX_0940 ; Ember seeds
	.db TREASURE_SCENT_SEEDS	$81 $05 $84 $03 $01 <TX_0940 ; Scent seeds
	.db TREASURE_PEGASUS_SEEDS	$81 $05 $85 $01 $01 <TX_0940 ; Pegasus seeds
	.db TREASURE_GALE_SEEDS		$81 $05 $86 $01 $01 <TX_0940 ; Gale seeds
	.db TREASURE_MYSTERY_SEEDS	$81 $05 $87 $00 $01 <TX_0940 ; Mystery seeds

; @addr{705e}
@swordData:
	.db TREASURE_SWORD $90 $00 $00 $00 $00 <TX_0923 ; L1
	.db TREASURE_SWORD $91 $05 $00 $00 $00 <TX_0924 ; L2
	.db TREASURE_SWORD $92 $04 $00 $00 $00 <TX_0925 ; L3

; @addr{7073}
@shieldData:
	.db TREASURE_SHIELD $93 $00 $00 $00 $00 <TX_0920 ; L1
	.db TREASURE_SHIELD $94 $05 $00 $00 $00 <TX_0921 ; L2
	.db TREASURE_SHIELD $95 $04 $00 $00 $00 <TX_0922 ; L3

; @addr{7088}
@braceletData:
	.db TREASURE_BRACELET $99 $05 $00 $00 $00 <TX_092b ; L1
	.db TREASURE_BRACELET $98 $05 $00 $00 $00 <TX_093f ; L2

; @addr{7096}
@tradeData:
	.db TREASURE_TRADEITEM $c0 $05 $c1 $05 $ff <TX_0909 ; Poe clock
	.db TREASURE_TRADEITEM $c2 $02 $c2 $22 $ff <TX_090a ; Stationery
	.db TREASURE_TRADEITEM $c3 $00 $c4 $00 $ff <TX_090b ; Stink bag
	.db TREASURE_TRADEITEM $c5 $03 $c6 $03 $ff <TX_090c ; Tasty meat
	.db TREASURE_TRADEITEM $c7 $03 $c8 $03 $ff <TX_090d ; Doggy mask
	.db TREASURE_TRADEITEM $c9 $01 $ca $01 $ff <TX_090e ; Dumbbell
	.db TREASURE_TRADEITEM $cb $03 $cb $23 $ff <TX_090f ; Cheesy mustache
	.db TREASURE_TRADEITEM $cc $03 $cc $23 $ff <TX_0910 ; Funny joke
	.db TREASURE_TRADEITEM $cd $01 $ce $01 $ff <TX_0911 ; Touching book
	.db TREASURE_TRADEITEM $d0 $03 $d1 $03 $ff <TX_0912 ; Magic oar
	.db TREASURE_TRADEITEM $d2 $03 $d3 $03 $ff <TX_0913 ; Sea ukulele
	.db TREASURE_TRADEITEM $d4 $01 $d5 $01 $ff <TX_0914 ; Broken sword
	.db TREASURE_TRADEITEM $00 $00 $00 $00 $ff <TX_0900 ; Nothing (sequence done)

; @addr{70f1}
@fluteData:
	.db TREASURE_FLUTE $8b $00 $8c $00 $ff <TX_092e ; Strange flute
	.db TREASURE_FLUTE $8b $03 $8d $03 $ff <TX_092f ; Ricky's flute
	.db TREASURE_FLUTE $8b $02 $8e $02 $ff <TX_0930 ; Dimitri's flute
	.db TREASURE_FLUTE $8b $01 $8f $01 $ff <TX_0931 ; Moosh's flute

; @addr{710d}
@harpData:
	.db $00 $02 $04 $02 $00 $02 <TX_0941 ; No song?
	.db $00 $a3 $00 $a4 $00 $02 <TX_0941 ; Tune of echoes
	.db $00 $a7 $03 $a8 $03 $02 <TX_0941 ; Tune of currents
	.db $00 $ab $01 $ac $01 $02 <TX_0941 ; Tune of ages
; @addr{7129}
@tuniNutData:
	.db TREASURE_TUNI_NUT $f3 $05 $f4 $05 $ff <TX_0957 ; Broken
	.db TREASURE_TUNI_NUT $00 $00 $00 $00 $ff <TX_0900 ; Invisible (during the ceremony?)
	.db TREASURE_TUNI_NUT $f2 $05 $f2 $25 $ff <TX_094b ; Fixed

; @addr{713e}
@switchHookData:
	.db TREASURE_SWITCH_HOOK $9f $04 $00 $00 $00 <TX_093d ; L1
	.db TREASURE_SWITCH_HOOK $9f $04 $00 $00 $00 <TX_093e ; L2


