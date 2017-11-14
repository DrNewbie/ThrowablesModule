FakeSyncFixList = FakeSyncFixList or {}
FakeSyncFixInit = FakeSyncFixInit or {}

Hooks:Add("NetworkReceivedData", "NetReceived_AddOnThrowablesSync", function(sender, sync_asked, data)
	_Net = _G and _G.LuaNetworking or nil
	if sync_asked and data and _Net then
		if sync_asked == "AddOnFragAsk" then
			data = tostring(data)
			sender = tonumber(sender)
			if sender >= 1 and tweak_data.blackmarket.projectiles[data] then
				_Net:SendToPeer(sender, "AddOnFragReply", data)
			end
		elseif sync_asked == "AddOnFragReply" then
			data = tostring(data)
			sender = tonumber(sender)
			if sender >= 1 then
				FakeSyncFixList[sender] = FakeSyncFixList[sender] or {}
				FakeSyncFixList[sender][data] = true
			end
		end
	end
end)