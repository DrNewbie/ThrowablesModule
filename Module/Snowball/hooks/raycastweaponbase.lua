InstantSnowballBase = InstantSnowballBase or class(InstantExplosiveBulletBase)
InstantSnowballBase.id = "xmas_snowball"
InstantSnowballBase.CURVE_POW = tweak_data.projectiles.xmas_snowball.curve_pow
InstantSnowballBase.PLAYER_DMG_MUL = tweak_data.projectiles.xmas_snowball.player_dmg_mul
InstantSnowballBase.RANGE = tweak_data.projectiles.xmas_snowball.range
InstantSnowballBase.ALERT_RADIUS = tweak_data.projectiles.xmas_snowball.alert_radius
InstantSnowballBase.EFFECT_PARAMS = {
	on_unit = true,
	sound_muffle_effect = true,
	effect = tweak_data.projectiles.xmas_snowball.effect_name,
	sound_event = tweak_data.projectiles.xmas_snowball.sound_event,
	feedback_range = tweak_data.projectiles.xmas_snowball.feedback_range,
	camera_shake_max_mul = tweak_data.projectiles.xmas_snowball.camera_shake_max_mul,
	idstr_decal = tweak_data.projectiles.xmas_snowball.idstr_decal,
	idstr_effect = tweak_data.projectiles.xmas_snowball.idstr_effect
}