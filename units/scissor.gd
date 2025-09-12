extends Unit

func cast_ability():
	if !$Hitbox/UnitRayCast2.is_colliding():
		global_position.y -= 70
		var current_area = $AreaRayCast.get_collider()
		area = current_area
		if global_position.y <= 0:
			area.unit = null
			queue_free()
			return
	else:
		if !$Hitbox/UnitRayCast.is_colliding():
			global_position.y -= 35
			var current_area = $AreaRayCast.get_collider()
			area = current_area
	if $Hitbox/UnitRayCast2.is_colliding():
		var target = $Hitbox/UnitRayCast2.get_collider().get_parent()
		attack_unit(target)
	current_mana = 0
