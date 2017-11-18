local FAKBomb_check_smoke_shot = NPCRaycastWeaponBase._check_smoke_shot

function NPCRaycastWeaponBase:_check_smoke_shot(user_unit, target_unit)
	if not user_unit:movement() or not user_unit:movement().in_smoke or not alive(target_unit) then
		return
	end
	if managers.groupai:state():is_unit_team_AI(user_unit) then
		return
	end
	local in_smoke, variant = user_unit:movement():in_smoke()
	if variant == 'frag_fakbomb' or not tweak_data.projectiles[variant] then
		return
	end
	return FAKBomb_check_smoke_shot(self, user_unit, target_unit)
end