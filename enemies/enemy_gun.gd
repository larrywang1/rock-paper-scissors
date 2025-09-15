extends Enemy

func cast_ability():
	var unit
	while $Shoot.is_colliding():
		if $Shoot.get_collider().get_parent() is Enemy:
			$Shoot.add_exception($Shoot.get_collider())
			$Shoot.force_raycast_update()
			continue
		if $Shoot.get_collider().get_parent() is Unit:
			unit = $Shoot.get_collider().get_parent()
			break
	if unit == null:
		return
	attack_unit(unit)
	current_mana = 0
