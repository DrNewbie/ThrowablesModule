Hooks:PostHook(FragGrenade, "_detonate", "frag_cluster_detonate", function(self, ...)
	if tostring(self._new_frag) == 'frag_cluster' then
		local pos = self._unit:position()
		local _pos_offset = function (i)
			local ang = math.random() * 360 * math.pi * i
			local rad = math.random(30, 50)
			return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
		end
		local _l = {
			"frag",
			"frag",
			"frag",
			"frag",
			"frag",
			"frag",
			"frag",
			"frag"
		}
		local _xy = {
			Vector3(0, 0, 0),
			Vector3(0.5, 0, 0),
			Vector3(0, 0.5, 0),
			Vector3(-0.5, 0, 0),
			Vector3(0, -0.5, 0),
			Vector3(0.5, 0.5, 0),
			Vector3(-0.5, -0.5, 0),
			Vector3(0.5, -0.5, 0),
			Vector3(-0.5, 0.5, 0)
		}
		local user = self:thrower_unit() or self._unit
		for i = 1, #_l do
			DelayedCalls:Add('ClusterBomb_Spilt_'.. tostring(user:key()) ..'_' .. i, i*0.15, function()
				ProjectileBase.throw_projectile(_l[i], pos + _pos_offset(i), Vector3(0, 0, 1) + _xy[i])
			end)
		end
	end
end)