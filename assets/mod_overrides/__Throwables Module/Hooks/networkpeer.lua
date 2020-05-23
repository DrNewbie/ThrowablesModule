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
	if type(peer) == 'number' then
		peer = managers.network:session():peer(peer)
	end
	if peer and peer.id and peer:id() then
		if _d1 == 'sync_grenades' then
			_init(peer, d2)
			local projectile_tweak = tweak_data.blackmarket.projectiles[d2]
			if projectile_tweak and projectile_tweak.custom and not _c(peer:id(), d2) then
				d2 = projectile_tweak.base_on or 'concussion'
			end
		elseif _d1 == 'sync_unit_event_id_16' and d2 and d2.name and d2:name() then
			if type(d4) == 'number' and d4 == GrenadeBase.EVENT_IDS.detonate then
				local grenade = peer:grenade_id()
				grenade = tostring(grenade)
				if grenade and grenade ~= 'nil' and tweak_data.blackmarket.projectiles[grenade] and tweak_data.blackmarket.projectiles[grenade].unit and tweak_data.blackmarket.projectiles[grenade].custom then
					if d2:name():key() == Idstring(tweak_data.blackmarket.projectiles[grenade].unit):key() then
						if not _c(peer:id(), grenade) then
							d2 = nil
						end
					end
				end
			end
		elseif _d1 == 'sync_throw_projectile' then
			if d5 then
				local projectile_entry = tostring(tweak_data.blackmarket:get_projectile_name_from_index(d5))
				local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
				if projectile_tweak and projectile_tweak.custom then
					if not _c(peer:id(), projectile_entry) then
						d5 = tweak_data.blackmarket:get_index_from_projectile_id(tweak_data.blackmarket.projectiles[projectile_entry].base_on or 'concussion')
					else
						d5 = FakeSyncFixList[peer:id()][projectile_entry]
					end
				end
			end
		elseif _d1 == 'request_throw_projectile' then
			local projectile_entry = tostring(tweak_data.blackmarket:get_projectile_name_from_index(d2))
			local projectile_tweak = tweak_data.blackmarket.projectiles[projectile_entry]
			_init(peer, projectile_entry)
			if projectile_tweak and projectile_tweak.custom then
				if not _c(peer:id(), projectile_entry) then
					d2 = tweak_data.blackmarket:get_index_from_projectile_id(tweak_data.blackmarket.projectiles[projectile_entry].base_on or 'concussion')
				else
					d2 = FakeSyncFixList[peer:id()][projectile_entry]
				end
			end
		end
	end
	return d1, d2, d3, d4, d5, ...
end

local AddOnThrowablesSync_Net_send_queued_sync = NetworkPeer.send_queued_sync

function NetworkPeer:send_queued_sync(...)
	AddOnThrowablesSync_Net_send_queued_sync(self, FakeSyncFix(self, ...))
end