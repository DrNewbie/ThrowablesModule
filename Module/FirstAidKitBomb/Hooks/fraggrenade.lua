local Frag_Fakbomb_IDs = 0

Hooks:PostHook(FragGrenade, "_detonate", "frag_fakbomb_detonate", function(self, ...)
	if tostring(self._new_frag) == 'frag_fakbomb' then
		local _c = function(_c_data, _pos)
			if _c_data and _c_data.unit and alive(_c_data.unit) and mvector3.distance(_pos, _c_data.unit:position()) < tweak_data.projectiles.frag_fakbomb.range then
				return true
			end
			return false
		end
		local pos = self._unit:position()
		managers.player:spawn_fak_smoke_screen(pos, math.UP, self._unit)
		
		local user = self:thrower_unit() or self._unit
		local _ut = 10
		local _dt = tweak_data.projectiles.frag_fakbomb.effect_time / _ut
		Frag_Fakbomb_IDs = Frag_Fakbomb_IDs + 1
		if Frag_Fakbomb_IDs > 50 then Frag_Fakbomb_IDs = 1 end
		for i = 1, _ut do
			DelayedCalls:Add('FirstAidKitBomb_'..Idstring(Frag_Fakbomb_IDs..';'..user:name():key()..';'..i):key(), i*_dt, function()
				for c_key, c_data in pairs(managers.groupai:state():all_player_criminals()) do
					if _c(c_data, pos) then
						if c_data.unit == managers.player:player_unit() then
							local damage_ext = c_data.unit:character_damage()
							if not damage_ext:need_revive() and not damage_ext:dead() then
								if damage_ext:restore_health(0.07) then
									c_data.unit:sound():play("pickup_ammo_health_boost", nil, true)
								end
							end
						else
							local peer = managers.network:session():peer_by_unit(c_data.unit)
							if peer then
								if peer ~= managers.network:session():local_peer() then
									local HP_Unit = safe_spawn_unit(Idstring("units/pickups/ammo/ammo_pickup"), Vector3(1, 1, -9999), Rotation())
									managers.network:session():send_to_peer_synched(peer, "sync_unit_event_id_16", HP_Unit, "pickup", 2 + 13)
									World:delete_unit(HP_Unit)
								end
							end
						end
					end
				end
			end)
		end
		for c_key, c_unit in pairs(managers.groupai:state():all_converted_enemies()) do
			if _c({unit = c_unit}, pos) then
				local cop_dmg = c_unit:character_damage()
				cop_dmg._health = cop_dmg._HEALTH_INIT
				cop_dmg._health_ratio = 1
				if not c_unit:character_damage():dead() and c_unit:contour() then
					c_unit:contour():add("medic_heal", true)
					c_unit:contour():flash("medic_heal", 0.2)
				end
			end
		end
	end
end)