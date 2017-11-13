local NewProjectiles_OutfitString_Block = BlackMarketManager.outfit_string

function BlackMarketManager:outfit_string()
	local s = NewProjectiles_OutfitString_Block(self)
	local _grenade = self:equipped_grenade()
	if tweak_data.blackmarket.projectiles[_grenade].custom then
		s = s:gsub(_grenade, tweak_data.blackmarket.projectiles[_grenade].base_on or 'concussion')
	end
	return s
end