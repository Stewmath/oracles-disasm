.include "object_code/common/partCode/itemDrop.s"
.include "object_code/common/partCode/enemyDestroyed.s"
.include "object_code/common/partCode/orb.s"
.include "object_code/common/partCode/bossDeathExplosion.s"
.include "object_code/common/partCode/switch.s"
.include "object_code/common/partCode/lightableTorch.s"
.include "object_code/common/partCode/shadow.s"
.include "object_code/common/partCode/darkRoomHandler.s"
.include "object_code/common/partCode/button.s"
.include "object_code/common/partCode/movingOrb.s"
.include "object_code/common/partCode/bridgeSpawner.s"
.include "object_code/common/partCode/detectionHelper.s"
.include "object_code/common/partCode/respawnableBush.s"
.include "object_code/common/partCode/seedOnTree.s"
.include "object_code/common/partCode/volcanoRock.s"
.include "object_code/common/partCode/flame.s"
.include "object_code/common/partCode/owlStatue.s"
.include "object_code/common/partCode/itemFromMaple.s"
.include "object_code/common/partCode/gashaTree.s"
.include "object_code/common/partCode/octorokProjectile.s"
.include "object_code/common/partCode/fireProjectiles.s"
.include "object_code/common/partCode/enemyArrow.s"
.include "object_code/common/partCode/lynelBeam.s"
.include "object_code/common/partCode/stalfosBone.s"
.include "object_code/common/partCode/enemySword.s"
.include "object_code/common/partCode/dekuScrubProjectile.s"
.include "object_code/common/partCode/wizzrobeProjectile.s"
.include "object_code/common/partCode/fire.s"
.include "object_code/common/partCode/moblinBoomerang.s"
.include "object_code/common/partCode/cuccoAttacker.s"
.include "object_code/common/partCode/fallingFire.s"
.include "object_code/common/partCode/lighting.s"
.include "object_code/common/partCode/smallFairy.s"
.include "object_code/common/partCode/beam.s"
.include "object_code/common/partCode/spikedBall.s"
.include "object_code/common/partCode/greatFairyHeart.s"
.include "object_code/common/partCode/twinrovaProjectile.s"
.include "object_code/common/partCode/twinrovaFlame.s"
.include "object_code/common/partCode/twinrovaSnowball.s"
.include "object_code/common/partCode/ganonTrident.s"
.include "object_code/common/partCode/51.s"
.include "object_code/common/partCode/52.s"
.include "object_code/common/partCode/blueEnergyBead.s"

.ifdef ROM_SEASONS
.ends

.include "code/roomInitialization.s"

 m_section_free Part_Code_2 NAMESPACE partCode
.endif


label_11_212:
	ld d,$d0
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,$c0
	ld a,(de)
	or a
	jr z,++
	rlca
	jr c,+
	ld e,$c4
	ld a,(de)
	or a
	jr nz,++
+
	call func_11_5e8a
++
	inc d
	ld a,d
	cp $e0
	jr c,-
	ret

;;
updateParts:
	ld a,$c0
	ldh (<hActiveObjectType),a
	ld a,(wScrollMode)
	cp $08
	jr z,label_11_212
	ld a,(wTextIsActive)
	or a
	jr nz,label_11_212

	ld a,(wDisabledObjects)
	and $88
	jr nz,label_11_212

	ld d,FIRST_PART_INDEX
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,Part.enabled
	ld a,(de)
	or a
	jr z,+

	call func_11_5e8a
	ld h,d
	ld l,Part.var2a
	res 7,(hl)
+
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,-
	ret

;;
func_11_5e8a:
	call partCommon_standardUpdate

	; hl = partCodeTable + [Part.id] * 2
	ld e,Part.id
	ld a,(de)
	add a
	add <partCodeTable
	ld l,a
	ld a,$00
	adc >partCodeTable
	ld h,a

	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,c
	or a
	jp hl
