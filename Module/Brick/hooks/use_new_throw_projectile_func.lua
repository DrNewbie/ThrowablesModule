tweak_data.blackmarket.projectiles.wpn_prj_brick.use_new_throw_projectile_func = function(them)
	if not them then return end
	them._range = tweak_data.projectiles.wpn_prj_brick.range
	them._timer = 3
	them._damage = tweak_data.projectiles.wpn_prj_brick.damage
	them._player_damage = tweak_data.projectiles.wpn_prj_brick.player_damage
	them._mass_look_up_modifier  = tweak_data.projectiles.wpn_prj_brick.mass_look_up_modifier
end