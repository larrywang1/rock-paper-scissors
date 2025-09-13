extends Unit

func on_attack_effect(_unit):
	if $Left.is_colliding():
		var collided_unit = $Left.get_collider().get_parent()
		if collided_unit not in clashed_units and collided_unit is not Unit:
			attack_unit(collided_unit)
	if $Right.is_colliding():
		var collided_unit = $Right.get_collider().get_parent()
		if collided_unit not in clashed_units and collided_unit is not Unit:
			attack_unit(collided_unit)

func attack_unit(unit):
	var damage = attack
	if unit.type in bonuses.keys():
		damage += bonuses[unit.type]
	damage = max(0, damage - unit.defense)
	unit.health -= damage
	var damagefx = preload("res://level/damage_indicator.tscn").instantiate()
	damagefx.text = "-" + String.num_int64(damage)
	damagefx.global_position = unit.global_position + Vector2(0, -10)
	get_tree().get_first_node_in_group("units").add_child(damagefx)
