function BaseNetworkSession:check_send_outfit(peer)
	local FakeSyncFix = function(d1, d2, ...)
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
		local d1, d2 = FakeSyncFix("sync_outfit", managers.blackmarket:outfit_string())
		if peer then
			peer:send_queued_sync(d1, d2, self:local_peer():outfit_version(), managers.blackmarket:signature())
		else
			self:send_to_peers_loaded(d1, d2, self:local_peer():outfit_version(), managers.blackmarket:signature())
		end
	end
end

function BaseNetworkSession:send_to_peers_synched(...)
	local FakeSyncFix = function(d1, d2, ...)
		if tostring(d1) == 'sync_grenades' then
			if tweak_data.blackmarket.projectiles[d2].custom then
				d2 = tweak_data.blackmarket.projectiles[d2].base_on or 'concussion'
			end
		end
		if tostring(d1) == 'sync_unit_event_id_16' and d2 and d2.name and d2:name() then
			local _d2 = tostring(d2:name():key())
			if tweak_data.blackmarket.custom_projectiles[_d2] then
				d2 = nil
			end
		end
		return d1, d2, ...
	end
	for peer_id, peer in pairs(self._peers) do
		peer:send_queued_sync(FakeSyncFix(...))
	end
end