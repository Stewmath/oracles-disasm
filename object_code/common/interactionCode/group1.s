 m_section_free Interaction_Code_Group1 NAMESPACE commonInteractions1

.include "object_code/common/interactionCode/breakTileDebris.s"
.include "object_code/common/interactionCode/fallDownHole.s"
.include "object_code/common/interactionCode/farore.s"
.include "object_code/common/interactionCode/dungeonStuff.s"
.include "object_code/common/interactionCode/pushblockTrigger.s"
.include "object_code/common/interactionCode/pushblock.s"
.include "object_code/common/interactionCode/minecart.s"
.include "object_code/common/interactionCode/dungeonKeySprite.s"
.include "object_code/common/interactionCode/overworldKeySprite.s"
.include "object_code/common/interactionCode/faroresMemory.s"

.ifdef ROM_SEASONS
.include "object_code/seasons/interactionCode/rupeeRoomRupees.s"
.endif

.include "object_code/common/interactionCode/doorController.s"

.ends
