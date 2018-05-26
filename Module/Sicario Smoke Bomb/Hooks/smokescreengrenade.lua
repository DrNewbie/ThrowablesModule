local frag_smoke_ply_detonate = SmokeScreenGrenade._detonate

function SmokeScreenGrenade:_detonate(...)
	if self._unit and tostring(self._new_frag) == 'frag_smoke_ply' then
		self._unit:base()._projectile_entry = "smoke_screen_grenade"
		if Network:is_server() then
			managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
		end
		managers.player:spawn_smoke_screen(self._unit:position(), math.UP, self._unit, true)
		return
	end
	frag_smoke_ply_detonate(self, ...)
end