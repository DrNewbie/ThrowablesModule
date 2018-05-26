Hooks:PostHook(FragGrenade, "_detonate", "frag_smoke_ply_detonate", function(self)
	if self._unit and tostring(self._new_frag) == 'frag_smoke_ply' then
		managers.player:spawn_smoke_screen(self._unit:position(), math.UP, self._unit, true)
	end
end)