FakeSyncFixList = FakeSyncFixList or {}
FakeSyncFixInit = FakeSyncFixInit or {}

Hooks:Add("NetworkReceivedData", "NetReceived_AddOnThrowablesSync", function(sender, sync_asked, data)
	_Net = _G and _G.LuaNetworking or nil
	if sync_asked and data and _Net then
		if sync_asked == "AddOnFragAsk" then
			data = tostring(data)
			sender = tonumber(sender)
			if sender >= 1 and tweak_data.blackmarket.projectiles[data] then
				local frag_data = tweak_data.blackmarket.projectiles[data]
				local frag_index = tweak_data.blackmarket:get_index_from_projectile_id(data)
				_Net:SendToPeer(sender, "AddOnFragReply", data..',,,'..frag_index)
				FakeSyncFixList[sender] = FakeSyncFixList[sender] or {}
				FakeSyncFixList[sender][data] = frag_index
				local unit_name
				for _, unit_type in pairs({"unit", "sprint_unit", "local_unit"}) do
					if type(frag_data[unit_type]) == "string" then
						unit_name = Idstring(frag_data[unit_type])
						if DB:has(Idstring("unit"), unit_name) and not managers.dyn_resource:is_resource_ready(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
							managers.dyn_resource:load(Idstring("unit"), unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
						end
					end
				end
			end
		elseif sync_asked == "AddOnFragReply" then
			data = string.split(tostring(data), ",,,")
			sender = tonumber(sender)
			if sender >= 1 then
				FakeSyncFixList[sender] = FakeSyncFixList[sender] or {}
				FakeSyncFixList[sender][data[1]] = tonumber(data[2])
			end
		end
	end
end)