AddonProjectileBase = AddonProjectileBase or class(ProjectileBase)
AddonProjectileBase.time_cheat = {}
local mvec1 = Vector3()
local mvec2 = Vector3()
local mrot1 = Rotation()

function AddonProjectileBase.throw_projectile(projectile_type, pos, dir, owner_peer_id)
	if not ProjectileBase.check_time_cheat(projectile_type, owner_peer_id) then
		return
	end
	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	if not tweak_entry then
		return
	end
	if not tweak_entry.local_unit then
		return
	end
	local unit_name = tweak_entry.local_unit and Idstring(tweak_entry.local_unit) or Idstring(tweak_entry.unit)
	local unit = safe_spawn_unit(unit_name, pos, Rotation())
	if unit then
		if type(tweak_entry.use_new_throw_projectile_func) == "function" then
			if unit.base and unit:base() then
				tweak_entry.use_new_throw_projectile_func(unit:base())
			end
		end
		if owner_peer_id and managers.network:session() then
			local peer = managers.network:session():peer(owner_peer_id)
			local thrower_unit = peer and peer:unit()
			if alive(thrower_unit) then
				unit:base():set_thrower_unit(thrower_unit)
				if not tweak_entry.throwable and thrower_unit:movement() and thrower_unit:movement():current_state() then
					unit:base():set_weapon_unit(thrower_unit:movement():current_state()._equipped_unit)
				end
			end
		end
		unit:base():throw({
			dir = dir,
			projectile_entry = projectile_type
		})
		if unit:base().set_owner_peer_id then
			unit:base():set_owner_peer_id(owner_peer_id)
		end
		if tweak_data.blackmarket.projectiles[projectile_type].impact_detonation then
			unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
			unit:base():create_sweep_data()
		end
	end
	return unit
end