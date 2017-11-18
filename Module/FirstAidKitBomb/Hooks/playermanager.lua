tweak_data.projectiles.frag_fakbomb.effect_time = tweak_data.projectiles.frag_fakbomb.effect_time or 10

function PlayerManager:spawn_fak_smoke_screen(position, normal, grenade_unit)
	local time = tweak_data.projectiles.smoke_screen_grenade.duration
	self._smoke_screen_effects = self._smoke_screen_effects or {}
	table.insert(self._smoke_screen_effects,
		SmokeScreenEffect:new(
			position,
			normal,
			tweak_data.projectiles.frag_fakbomb.effect_time,
			has_dodge_bonus,
			grenade_unit
		)
	)
	if alive(self._smoke_grenade) then
		self._smoke_grenade:set_slot(0)
	end
	self._smoke_grenade = grenade_unit
end