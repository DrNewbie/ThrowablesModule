Hooks:PostHook(FragGrenade, "_detonate", "frag_taser_detonate", function(self, ...)
	if tostring(self._new_frag) == "frag_taser" then
		_params.damage = 5
		_params._is_taser = true
	end
end)