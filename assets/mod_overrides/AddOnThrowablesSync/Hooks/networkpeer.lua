FakeSyncFixList = FakeSyncFixList or {}
FakeSyncFixInit = FakeSyncFixInit or {}

function FakeSyncFix(peer, d1, d2, d3, d4, d5, ...)
	local _c = function(pid, frag)
		if FakeSyncFixList[pid] and FakeSyncFixList[pid][frag] then
			return true
		end
		return false
	end
	local _init = function(_peer, _frage)
		if _peer and _frage and not FakeSyncFixInit['ID_'.._peer:user_id()] then
			FakeSyncFixInit['ID_'.._peer:user_id()] = true
			_Net = _G and _G.LuaNetworking or nil
			if _Net then
				FakeSyncFixList[_peer:id()] = {}
				_Net:SendToPeer(_peer:id(), "AddOnFragAsk", _frage)
			end
		end
	end
	local _d1 = tostring(d1)
	if _d1 == 'sync_grenades' and not _c(peer:id(), d2) then
		_init(peer, d2)
		local projectile_tweak = tweak_data.blackmarket.projectiles[d2]
		if projectile_tweak and projectile_tweak.custom then
			d2 = projectile_tweak.base_on or 'concussion'
		end
	elseif _d1 == 'sync_unit_event_id_16' and d2 and d2.name and d2:name() then
		local _d2 = tostring(d2:name():key())
		local _p = tweak_data.blackmarket.custom_projectiles[_d2]
		if _p and not _c(peer:id(), _p) then
			d2 = nil
		end
	elseif _d1 == 'sync_throw_projectile' then
		if d2 and d2.name and d2:name() then
			local _d2 = tostring(d2:name():key())
			local _p = tweak_data.blackmarket.custom_projectiles[_d2]
			if _p and not _c(peer:id(), _p) then
				d2 = nil
			end
		end
		if d5 then
			local projectile_entry = tostring(tweak_data.blackmarket:get_projectile_name_from_index(d5))
			local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
			if projectile_tweak and not _c(peer:id(), projectile_entry) and projectile_tweak.custom then
				d5 = tweak_data.blackmarket:get_index_from_projectile_id(tweak_data.blackmarket.projectiles[projectile_entry].base_on or 'concussion')
			end
		end
	elseif _d1 == 'request_throw_projectile' then
		if type(peer) == 'number' then
			peer = managers.network:session():peer(peer)
		end
		local projectile_entry = tostring(tweak_data.blackmarket:get_projectile_name_from_index(d2))
		local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
		_init(peer, projectile_entry)
		if projectile_tweak and not _c(peer:id(), projectile_entry) and projectile_tweak.custom then
			d2 = tweak_data.blackmarket:get_index_from_projectile_id(tweak_data.blackmarket.projectiles[projectile_entry].base_on or 'concussion')
		end
	end
	return d1, d2, d3, d4, d5, ...
end

function NetworkPeer:send_queued_sync(...)
	if not self._ip_verified then
		Application:error("[NetworkPeer:send_queued_sync] ip unverified:", ...)
		return
	end
	if self._synced or self._syncing then
		self:_send_queued("sync", FakeSyncFix(self, ...))
	end
end