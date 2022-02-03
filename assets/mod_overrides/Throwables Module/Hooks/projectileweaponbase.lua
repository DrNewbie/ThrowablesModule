Hooks:PostHook(ProjectileWeaponBase, "init", "AddThrowablesClientAuthoritative", function(self)
	local projectile_type = self._projectile_type
	if projectile_type and tweak_data.blackmarket.projectiles[projectile_type] and tweak_data.blackmarket.projectiles[projectile_type].custom then
		self._client_authoritative = true
	end
end)