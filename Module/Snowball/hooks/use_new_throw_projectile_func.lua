tweak_data.blackmarket.projectiles.xmas_snowball.use_new_throw_projectile_func = function(them)
	if not them then return end
	them._range = tweak_data.projectiles.xmas_snowball.range
	them._timer = 3
	them._damage = tweak_data.projectiles.xmas_snowball.damage
	them._player_damage = tweak_data.projectiles.xmas_snowball.player_damage
end