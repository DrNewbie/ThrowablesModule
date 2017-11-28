local Frag_Fakbomb_IDs = 0

Hooks:PostHook(FragGrenade, "_detonate", "frag_medicbomb_detonate", function(self, ...)
	if tostring(self._new_frag) == 'frag_medicbomb' then
		local pos = self._unit:position()
		local user = self:thrower_unit() or self._unit
		local _frag_medicbomb_check = function(_c_data, _pos)
			if _c_data and _c_data.unit and alive(_c_data.unit) and mvector3.distance(_pos, _c_data.unit:position()) < tweak_data.projectiles.frag_medicbomb.range then
				return true
			end
			return false
		end
		local revive_units = {}
		for c_key, c_data in pairs(managers.groupai:state():all_player_criminals()) do
			if _frag_medicbomb_check(c_data, pos) then
				revive_units[c_data.unit:key()] = c_data.unit
			end
		end
		for c_key, c_data in pairs(managers.groupai:state():all_AI_criminals()) do
			if _frag_medicbomb_check(c_data, pos) then
				revive_units[c_data.unit:key()] = c_data.unit			
			end
		end
		for _, r_unit in pairs(revive_units) do
			if r_unit:interaction() then
				if r_unit:interaction():active() then
					r_unit:interaction():interact(user)
				end
			elseif r_unit:character_damage() and (r_unit:character_damage():need_revive() or r_unit:character_damage():arrested()) then
				r_unit:character_damage():revive(user)
			end
		end
	end
end)