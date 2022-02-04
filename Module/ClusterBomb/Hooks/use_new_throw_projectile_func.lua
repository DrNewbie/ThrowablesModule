tweak_data.blackmarket.projectiles.frag_cluster.use_new_throw_projectile_func = function(them)
	if not them then return end
	them._range = 800
	them._timer = 3
	them._damage = 10
	them._player_damage = 1
end