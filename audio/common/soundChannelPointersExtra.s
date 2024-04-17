.ifdef ROM_AGES
musAncientRuins:
	.db $00
	.dw musAncientRuinsChannel0
	.db $01
	.dw musAncientRuinsChannel1
	.db $04
	.dw musAncientRuinsChannel4
	.db $06
	.dw musAncientRuinsChannel6
	.db $ff

musCarnival:
	.db $00
	.dw musCarnivalChannel0
	.db $01
	.dw musCarnivalChannel1
	.db $04
	.dw musCarnivalChannel4
	.db $06
	.dw musCarnivalChannel6
	.db $ff

musDancingDragonDungeon:
	.db $00
	.dw musDancingDragonDungeonChannel0
	.db $01
	.dw musDancingDragonDungeonChannel1
	.db $04
	.dw musDancingDragonDungeonChannel4
	.db $06
	.dw musDancingDragonDungeonChannel6
	.db $ff

musExplorersCrypt:
	.db $00
	.dw musExplorersCryptChannel0
	.db $01
	.dw musExplorersCryptChannel1
	.db $04
	.dw musExplorersCryptChannel4
	.db $06
	.dw musExplorersCryptChannel6
	.db $ff

musGnarledRootDungeon:
	.db $00
	.dw musGnarledRootDungeonChannel0
	.db $01
	.dw musGnarledRootDungeonChannel1
	.db $04
	.dw musGnarledRootDungeonChannel4
	.db $06
	.dw musGnarledRootDungeonChannel6
	.db $ff

musHerosCave:
	.db $00
	.dw musHerosCaveChannel0
	.db $01
	.dw musHerosCaveChannel1
	.db $04
	.dw musHerosCaveChannel4
	.db $06
	.dw musHerosCaveChannel6
	.db $ff

musHideAndSeek:
	.db $00
	.dw musHideAndSeekChannel0
	.db $01
	.dw musHideAndSeekChannel1
	.db $04
	.dw musHideAndSeekChannel4
	.db $06
	.dw musHideAndSeekChannel6
	.db $ff

musHoronVillage:
	.db $00
	.dw musHoronVillageChannel0
	.db $01
	.dw musHoronVillageChannel1
	.db $04
	.dw musHoronVillageChannel4
	.db $06
	.dw musHoronVillageChannel6
	.db $ff

musPoisonMothsLair:
	.db $00
	.dw musPoisonMothsLairChannel0
	.db $01
	.dw musPoisonMothsLairChannel1
	.db $04
	.dw musPoisonMothsLairChannel4
	.db $06
	.dw musPoisonMothsLairChannel6
	.db $ff

musSamasaDesert:
	.db $00
	.dw musSamasaDesertChannel0
	.db $01
	.dw musSamasaDesertChannel1
	.db $04
	.dw musSamasaDesertChannel4
	.db $06
	.dw musSamasaDesertChannel6
	.db $ff

musSnakesRemains:
	.db $00
	.dw musSnakesRemainsChannel0
	.db $01
	.dw musSnakesRemainsChannel1
	.db $04
	.dw musSnakesRemainsChannel4
	.db $06
	.dw musSnakesRemainsChannel6
	.db $ff

musSongOfStorms:
	.db $00
	.dw musSongOfStormsChannel0
	.db $01
	.dw musSongOfStormsChannel1
	.db $04
	.dw musSongOfStormsChannel4
	.db $06
	.dw musSongOfStormsChannel6
	.db $ff

musSubrosia:
	.db $00
	.dw musSubrosiaChannel0
	.db $01
	.dw musSubrosiaChannel1
	.db $04
	.dw musSubrosiaChannel4
	.db $06
	.dw musSubrosiaChannel6
	.db $ff

musSubrosianDance:
	.db $00
	.dw musSubrosianDanceChannel0
	.db $01
	.dw musSubrosianDanceChannel1
	.db $04
	.dw musSubrosianDanceChannel4
	.db $06
	.dw musSubrosianDanceChannel6
	.db $ff

sndSubrosianShop:
	.db $00
	.dw sndSubrosianShopChannel0
	.db $01
	.dw sndSubrosianShopChannel1
	.db $04
	.dw sndSubrosianShopChannel4
	.db $06
	.dw sndSubrosianShopChannel6
	.db $ff

musSunkenCity:
	.db $00
	.dw musSunkenCityChannel0
	.db $01
	.dw musSunkenCityChannel1
	.db $04
	.dw musSunkenCityChannel4
	.db $06
	.dw musSunkenCityChannel6
	.db $ff

musSwordAndShieldMaze:
	.db $00
	.dw musSwordAndShieldMazeChannel0
	.db $01
	.dw musSwordAndShieldMazeChannel1
	.db $04
	.dw musSwordAndShieldMazeChannel4
	.db $06
	.dw musSwordAndShieldMazeChannel6
	.db $ff

musTarmRuins:
	.db $00
	.dw musTarmRuinsChannel0
	.db $01
	.dw musTarmRuinsChannel1
	.db $04
	.dw musTarmRuinsChannel4
	.db $06
	.dw musTarmRuinsChannel6
	.db $ff

musTempleRemains:
	.db $00
	.dw musTempleRemainsChannel0
	.db $01
	.dw musTempleRemainsChannel1
	.db $04
	.dw musTempleRemainsChannel4
	.db $06
	.dw musTempleRemainsChannel6
	.db $ff

musUnicornsCave:
	.db $00
	.dw musUnicornsCaveChannel0
	.db $01
	.dw musUnicornsCaveChannel1
	.db $04
	.dw musUnicornsCaveChannel4
	.db $06
	.dw musUnicornsCaveChannel6
	.db $ff

musUnused1:
	.db $00
	.dw musUnused1Channel0
	.db $01
	.dw musUnused1Channel1
	.db $04
	.dw musUnused1Channel4
	.db $06
	.dw musUnused1Channel6
	.db $ff

musUnused2:
	.db $00
	.dw musUnused2Channel0
	.db $01
	.dw musUnused2Channel1
	.db $04
	.dw musUnused2Channel4
	.db $06
	.dw musUnused2Channel6
	.db $ff

.else ;ROM_SEASONS
musAmbiPalace:
	.db $00
	.dw musAmbiPalaceChannel0
	.db $01
	.dw musAmbiPalaceChannel1
	.db $04
	.dw musAmbiPalaceChannel4
	.db $06
	.dw musAmbiPalaceChannel6
	.db $ff

musAncientTomb:
	.db $00
	.dw musAncientTombChannel0
	.db $01
	.dw musAncientTombChannel1
	.db $04
	.dw musAncientTombChannel4
	.db $06
	.dw musAncientTombChannel6
	.db $ff

musBlackTower:
	.db $00
	.dw musBlackTowerChannel0
	.db $01
	.dw musBlackTowerChannel1
	.db $04
	.dw musBlackTowerChannel4
	.db $06
	.dw musBlackTowerChannel6
	.db $ff

musCrescent:
	.db $00
	.dw musCrescentChannel0
	.db $01
	.dw musCrescentChannel1
	.db $04
	.dw musCrescentChannel4
	.db $06
	.dw musCrescentChannel6
	.db $ff

musCrownDungeon:
	.db $00
	.dw musCrownDungeonChannel0
	.db $01
	.dw musCrownDungeonChannel1
	.db $04
	.dw musCrownDungeonChannel4
	.db $06
	.dw musCrownDungeonChannel6
	.db $ff

musFairyForest:
	.db $00
	.dw musFairyForestChannel0
	.db $01
	.dw musFairyForestChannel1
	.db $04
	.dw musFairyForestChannel4
	.db $06
	.dw musFairyForestChannel6
	.db $ff

musJabuJabusBelly:
	.db $00
	.dw musJabuJabusBellyChannel0
	.db $01
	.dw musJabuJabusBellyChannel1
	.db $04
	.dw musJabuJabusBellyChannel4
	.db $06
	.dw musJabuJabusBellyChannel6
	.db $ff

musLynnaCity:
	.db $00
	.dw musLynnaCityChannel0
	.db $01
	.dw musLynnaCityChannel1
	.db $04
	.dw musLynnaCityChannel4
	.db $06
	.dw musLynnaCityChannel6
	.db $ff

musLynnaVillage:
	.db $00
	.dw musLynnaVillageChannel0
	.db $01
	.dw musLynnaVillageChannel1
	.db $04
	.dw musLynnaVillageChannel4
	.db $06
	.dw musLynnaVillageChannel6
	.db $ff

musMakuPath:
	.db $00
	.dw musMakuPathChannel0
	.db $01
	.dw musMakuPathChannel1
	.db $04
	.dw musMakuPathChannel4
	.db $06
	.dw musMakuPathChannel6
	.db $ff

musMermaidsCave:
	.db $00
	.dw musMermaidsCaveChannel0
	.db $01
	.dw musMermaidsCaveChannel1
	.db $04
	.dw musMermaidsCaveChannel4
	.db $06
	.dw musMermaidsCaveChannel6
	.db $ff

musMoonlitGrotto:
	.db $00
	.dw musMoonlitGrottoChannel0
	.db $01
	.dw musMoonlitGrottoChannel1
	.db $04
	.dw musMoonlitGrottoChannel4
	.db $06
	.dw musMoonlitGrottoChannel6
	.db $ff

musNayru:
	.db $00
	.dw musNayruChannel0
	.db $01
	.dw musNayruChannel1
	.db $04
	.dw musNayruChannel4
	.db $06
	.dw musNayruChannel6
	.db $ff

musOverworldPast:
	.db $00
	.dw musOverworldPastChannel0
	.db $01
	.dw musOverworldPastChannel1
	.db $04
	.dw musOverworldPastChannel4
	.db $06
	.dw musOverworldPastChannel6
	.db $ff

musRalph:
	.db $00
	.dw musRalphChannel0
	.db $01
	.dw musRalphChannel1
	.db $04
	.dw musRalphChannel4
	.db $06
	.dw musRalphChannel6
	.db $ff

musSkullDungeon:
	.db $00
	.dw musSkullDungeonChannel0
	.db $01
	.dw musSkullDungeonChannel1
	.db $04
	.dw musSkullDungeonChannel4
	.db $06
	.dw musSkullDungeonChannel6
	.db $ff

musSpiritsGrave:
	.db $00
	.dw musSpiritsGraveChannel0
	.db $01
	.dw musSpiritsGraveChannel1
	.db $04
	.dw musSpiritsGraveChannel4
	.db $06
	.dw musSpiritsGraveChannel6
	.db $ff

musSymmetryPast:
	.db $00
	.dw musSymmetryPastChannel0
	.db $01
	.dw musSymmetryPastChannel1
	.db $04
	.dw musSymmetryPastChannel4
	.db $06
	.dw musSymmetryPastChannel6
	.db $ff

musSymmetryPresent:
	.db $00
	.dw musSymmetryPresentChannel0
	.db $01
	.dw musSymmetryPresentChannel1
	.db $04
	.dw musSymmetryPresentChannel4
	.db $06
	.dw musSymmetryPresentChannel6
	.db $ff

musTokayHouse:
	.db $00
	.dw musTokayHouseChannel0
	.db $01
	.dw musTokayHouseChannel1
	.db $04
	.dw musTokayHouseChannel4
	.db $06
	.dw musTokayHouseChannel6
	.db $ff

musUnderwater:
	.db $00
	.dw musUnderwaterChannel0
	.db $01
	.dw musUnderwaterChannel1
	.db $04
	.dw musUnderwaterChannel4
	.db $06
	.dw musUnderwaterChannel6
	.db $ff

musWingDungeon:
	.db $00
	.dw musWingDungeonChannel0
	.db $01
	.dw musWingDungeonChannel1
	.db $04
	.dw musWingDungeonChannel4
	.db $06
	.dw musWingDungeonChannel6
	.db $ff

musZoraVillage:
	.db $00
	.dw musZoraVillageChannel0
	.db $01
	.dw musZoraVillageChannel1
	.db $04
	.dw musZoraVillageChannel4
	.db $06
	.dw musZoraVillageChannel6
	.db $ff
.endif

musLinebeck:
	.db $00
	.dw musLinebeckChannel0
	.db $01
	.dw musLinebeckChannel1
	.db $04
	.dw musLinebeckChannel4
	.db $06
	.dw musLinebeckChannel6
	.db $ff

musInTheFields:
	.db $00
	.dw musInTheFieldsChannel0
	.db $01
	.dw musInTheFieldsChannel1
	.db $04
	.dw musInTheFieldsChannel4
	.db $06
	.dw musInTheFieldsChannel6
	.db $ff

musSacredGrove:
	.db $00
	.dw musSacredGroveChannel0
	.db $01
	.dw musSacredGroveChannel1
	.db $04
	.dw musSacredGroveChannel4
	.db $06
	.dw musSacredGroveChannel6
	.db $ff

musGerudoValley:
	.db $00
	.dw musGerudoValleyChannel0
	.db $01
	.dw musGerudoValleyChannel1
	.db $04
	.dw musGerudoValleyChannel4
	.db $06
	.dw musGerudoValleyChannel6
	.db $ff

musLostWoods:
	.db $00
	.dw musLostWoodsChannel0
	.db $01
	.dw musLostWoodsChannel1
	.db $04
	.dw musLostWoodsChannel4
	.db $06
	.dw musLostWoodsChannel6
	.db $ff

musDragonRoostIsland:
	.db $00
	.dw musDragonRoostIslandChannel0
	.db $01
	.dw musDragonRoostIslandChannel1
	.db $04
	.dw musDragonRoostIslandChannel4
	.db $06
	.dw musDragonRoostIslandChannel6
	.db $ff

musSanctuary:
	.db $00
	.dw musSanctuaryChannel0
	.db $01
	.dw musSanctuaryChannel1
	.db $04
	.dw musSanctuaryChannel4
	.db $06
	.dw musSanctuaryChannel6
	.db $ff

musFallingRain:
	.db $00
	.dw musFallingRainChannel0
	.db $01
	.dw musFallingRainChannel1
	.db $04
	.dw musFallingRainChannel4
	.db $06
	.dw musFallingRainChannel6
	.db $ff

musAttackingVahNaboris:
	.db $00
	.dw musAttackingVahNaborisChannel0
	.db $01
	.dw musAttackingVahNaborisChannel1
	.db $04
	.dw musAttackingVahNaborisChannel4
	.db $06
	.dw musAttackingVahNaborisChannel6
	.db $ff

musKassThemeShort:
	.db $00
	.dw musKassThemeShortChannel0
	.db $01
	.dw musKassThemeShortChannel1
	.db $04
	.dw musKassThemeShortChannel4
	.db $06
	.dw musKassThemeShortChannel6
	.db $ff
	
musOverthereStair:
	.db $00
	.dw musOverthereStairChannel0
	.db $01
	.dw musOverthereStairChannel1
	.db $04
	.dw musOverthereStairChannel4
	.db $06
	.dw musOverthereStairChannel6
	.db $ff

musTheGreatPalace:
	.db $00
	.dw musTheGreatPalaceChannel0
	.db $01
	.dw musTheGreatPalaceChannel1
	.db $04
	.dw musTheGreatPalaceChannel4
	.db $06
	.dw musTheGreatPalaceChannel6
	.db $ff

musLightWorldDungeon:
	.db $00
	.dw musLightWorldDungeonChannel0
	.db $01
	.dw musLightWorldDungeonChannel1
	.db $04
	.dw musLightWorldDungeonChannel4
	.db $06
	.dw musLightWorldDungeonChannel6
	.db $ff

musBlackMist:
	.db $00
	.dw musBlackMistChannel0
	.db $01
	.dw musBlackMistChannel1
	.db $04
	.dw musBlackMistChannel4
	.db $06
	.dw musBlackMistChannel6
	.db $ff

musOutsetIsland:
	.db $00
	.dw musOutsetIslandChannel0
	.db $01
	.dw musOutsetIslandChannel1
	.db $04
	.dw musOutsetIslandChannel4
	.db $06
	.dw musOutsetIslandChannel6
	.db $ff

musTalTalHeights:
	.db $00
	.dw musTalTalHeightsChannel0
	.db $01
	.dw musTalTalHeightsChannel1
	.db $04
	.dw musTalTalHeightsChannel4
	.db $06
	.dw musTalTalHeightsChannel6
	.db $ff