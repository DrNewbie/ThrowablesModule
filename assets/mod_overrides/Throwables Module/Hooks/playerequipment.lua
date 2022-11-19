local old_throw_grenade = PlayerEquipment.throw_grenade

function PlayerEquipment:throw_grenade(...)
	local grenade_name = managers.blackmarket:equipped_grenade()
	if grenade_name and tweak_data.blackmarket.projectiles[grenade_name] and tweak_data.blackmarket.projectiles[grenade_name].custom then
		local grenade_tweak = tweak_data.blackmarket.projectiles[grenade_name]
		if grenade_tweak.use_new_throw_projectile_func then
			local from = self._unit:movement():m_head_pos()
			local pos = from + self._unit:movement():m_head_rot():y() * 30 + Vector3(0, 0, 0)
			local dir = self._unit:movement():m_head_rot():y()
			if not grenade_tweak.no_shouting then
				self._unit:sound():play("g43", nil, true)
			end
			local grenade_index = tweak_data.blackmarket:get_index_from_projectile_id(grenade_name)
			AddonProjectileBase.throw_projectile(grenade_name, pos, dir, managers.network:session():local_peer():id())
			--managers.player:verify_grenade(managers.network:session():local_peer():id())
			managers.player:on_throw_grenade()
			return
		end
	end
	old_throw_grenade(self, ...)
end

local old_throw_projectile = PlayerEquipment.throw_projectile

function PlayerEquipment:throw_projectile(...)
	local projectile_entry = managers.blackmarket:equipped_projectile()
	if projectile_entry and tweak_data.blackmarket.projectiles[projectile_entry] and tweak_data.blackmarket.projectiles[projectile_entry].custom then
		local projectile_data = tweak_data.blackmarket.projectiles[projectile_entry]
		if projectile_data.use_new_throw_projectile_func then
			local from = self._unit:movement():m_head_pos()
			local pos = from + self._unit:movement():m_head_rot():y() * 30 + Vector3(0, 0, 0)
			local dir = self._unit:movement():m_head_rot():y()
			local say_line = projectile_data.throw_shout or "g43"
			if say_line and say_line ~= true then
				self._unit:sound():play(say_line, nil, true)
			end
			local projectile_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_entry)
			AddonProjectileBase.throw_projectile(projectile_entry, pos, dir, managers.network:session():local_peer():id())
			--managers.player:verify_grenade(managers.network:session():local_peer():id())
			managers.player:on_throw_grenade()
			return
		end
	end
	old_throw_projectile(self, ...)
end