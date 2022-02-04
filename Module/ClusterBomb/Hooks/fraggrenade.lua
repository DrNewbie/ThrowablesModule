ClusterBombFragGrenade = ClusterBombFragGrenade or class(FragGrenade)

Hooks:PreHook(ClusterBombFragGrenade, "_detonate", "frag_cluster_detonate", function(self, ...)
	if tostring(self._new_frag) == "frag_cluster" and not self.__small_one and AddonProjectileBase then
		local pos = self._unit:position()
		local _pos_offset = function (i)
			local ang = math.random() * 360 * math.pi * i
			local rad = math.random(30, 50)
			return Vector3(math.cos(ang) * rad, math.sin(ang) * rad, 0)
		end
		local _l = {
			"frag_cluster",
			"frag_cluster",
			"frag_cluster",
			"frag_cluster",
			"frag_cluster",
			"frag_cluster",
			"frag_cluster",
			"frag_cluster"
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
			DelayedCalls:Add('ClusterBomb_Spilt_'.. tostring(user) ..'_' .. i, i*0.15, function()
				local small_one = AddonProjectileBase.throw_projectile(_l[i], pos + _pos_offset(i), Vector3(0, 0, 0.5) + _xy[i], managers.network:session():local_peer():id())
				if small_one and small_one.base and small_one:base() then
					small_one:base().__small_one = true
					small_one:base()._range = 400
					small_one:base()._timer = 2
					small_one:base()._damage = 5
					small_one:base()._player_damage = 1
				end
			end)
		end
	end
end)

function ClusterBombFragGrenade:bullet_hit()

end