function BaseNetworkSession:check_send_outfit(peer)
	local FakeSyncFixOutfit = function(d1, d2, ...)
		if tostring(d1) == 'sync_outfit' then
			local _blackmarket_outfit = managers.blackmarket:unpack_outfit_from_string(d2)
			local _grenade_id = tostring(_blackmarket_outfit.grenade)
			if tweak_data.blackmarket.projectiles[_grenade_id].custom then
				_blackmarket_outfit.grenade = tweak_data.blackmarket.projectiles[_grenade_id].base_on or 'concussion'
				d2 = managers.blackmarket:outfit_string_from_list(_blackmarket_outfit)
			end
		end
		return d1, d2, ...
	end
	if managers.blackmarket:signature() then
		local d1, d2 = FakeSyncFixOutfit("sync_outfit", managers.blackmarket:outfit_string())
		if peer then
			peer:send_queued_sync(d1, d2, self:local_peer():outfit_version(), managers.blackmarket:signature())
		else
			self:send_to_peers_loaded(d1, d2, self:local_peer():outfit_version(), managers.blackmarket:signature())
		end
	end
end