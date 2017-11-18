ThrowablesModule = ThrowablesModule or class(ItemModuleBase)

ThrowablesModule.type_name = "Throwables"

function ThrowablesModule:init(core_mod, config)
	if not ThrowablesModule.super.init(self, core_mod, config) then
		return false
	end
	return true
end

function ThrowablesModule:RegisterHook()
	local dlc
	Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", self._config.id .. "AddThrowablesData", function(bm_self, tweak_data)
		if bm_self.projectiles[self._config.id] then
			BeardLib:log("[ERROR] Throwables weapon with id '%s' already exists!", self._config.id)
			return
		end
		
		local icon = self._config.icon and "mods_"..BeardLib.Utils.Path:GetFileNameWithoutExtension(self._config.icon)
		if icon then
			tweak_data.hud_icons[icon] = {texture = self._config.icon, texture_rect = self._config.icon_rect or false, custom = true}
		end
		
		local data = table.merge(deep_clone(self._config.based_on and (bm_self.projectiles[self._config.based_on] ~= nil and bm_self.projectiles[self._config.based_on]) or bm_self.projectiles.kabar), table.merge({
			name_id = "bm_throw_" .. self._config.id,
			dlc = self.defaults.dlc,
			custom = true,
			free = true,
			base_on = self._config.based_on,
			icon = icon or "pd2_question"
		}, self._config.item or self._config))
		dlc = data.dlc
		if not self._config.texture_bundle_folder then
			data.texture_bundle_folder = nil
		end
		bm_self.projectiles[self._config.id] = data
		bm_self.custom_projectiles = bm_self.custom_projectiles or {}
		bm_self.custom_projectiles[Idstring(self._config.unit):key()] = self._config.unit
		
		if not table.contains(bm_self._projectiles_index, self._config.id) then
			table.insert(bm_self._projectiles_index, self._config.id)
		end		

		if dlc then
			TweakDataHelper:ModifyTweak({self._config.id}, "dlc", dlc, "content", "upgrades")
		end
	end)

	Hooks:PostHook(UpgradesTweakData, "init", self._config.id .. "AddThrowablesUpgradesData", function(u_self)
		if not table.contains(u_self.level_tree[1].upgrades, self._config.id) then
			table.insert(u_self.level_tree[1].upgrades, self._config.id)
		end
		u_self.definitions[self._config.id] = {
			category = "grenade",
			dlc = dlc
		}
	end)
end

BeardLib:RegisterModule(ThrowablesModule.type_name, ThrowablesModule)