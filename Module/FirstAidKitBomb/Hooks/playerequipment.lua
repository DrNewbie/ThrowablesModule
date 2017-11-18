Hooks:PostHook(PlayerEquipment, "throw_grenade", "frag_fakbomb_sayline", function(self)
	if managers.blackmarket:equipped_grenade() == 'frag_fakbomb' then
		PlayerStandard.say_line(self, "s12")
	end
end)