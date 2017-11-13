function NetworkPeer:send_queued_sync(...)
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
	if not self._ip_verified then
		Application:error("[NetworkPeer:send_queued_sync] ip unverified:", ...)
		return
	end
	if self._synced or self._syncing then
		self:_send_queued("sync", FakeSyncFix(...))
	end
end