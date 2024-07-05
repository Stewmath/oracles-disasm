; ==================================================================================================
; ENEMY_LINK_MIMIC
;
; Shares code with ENEMY_ARM_MIMIC.
; ==================================================================================================
enemyCode64:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state_switchHook
	.dw armMimic_state_stub
	.dw ecom_blownByGaleSeedState
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw linkMimic_state8


@state_uninitialized:
	ld a,PALH_82
	call loadPaletteHeader
	call armMimic_uninitialized
	jp objectSetVisible83


linkMimic_state8:
	ld a,(wDisabledObjects)
	or a
	ret nz
	jr armMimic_state8
