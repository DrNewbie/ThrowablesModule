Hooks:PostHook(PlayerEquipment, "throw_grenade", "frag_medicbomb_sayline", function(self)
	if managers.blackmarket:equipped_grenade() == 'frag_medicbomb' then
		PlayerStandard.say_line(self, "s02x_plu")
	end
end)