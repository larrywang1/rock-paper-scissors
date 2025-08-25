extends Unit

var wait_one_turn = false
var airplane = preload("res://units/paper_airplane.tscn")
func cast_ability():
	if !$Hitbox/UnitRayCast.is_colliding() and global_position.y != 26:
		var airplane_instance = airplane.instantiate()
		airplane_instance.global_position = global_position + Vector2(0, -35)
		get_tree().get_first_node_in_group("units").add_child(airplane_instance)
		await get_tree().process_frame
		airplane_instance.instantiate_area()
	else:
		if global_position.y == 26:
			current_mana = 0
		return
	current_mana = 0
	wait_one_turn = true

func move():
	clashed_units = []
	if state == states.BATTLE:
		if can_move:
			if !$Hitbox/UnitRayCast.is_colliding() and current_mana != max_mana and !wait_one_turn:
				global_position.y -= 35
				if global_position.y <= 0:
					area.unit = null
					queue_free()
					return
				await get_tree().process_frame
				var current_area = $AreaRayCast.get_collider()
				area = current_area

			elif $Hitbox/UnitRayCast.is_colliding():
				var collided_unit = $Hitbox/UnitRayCast.get_collider().get_parent()
				if collided_unit not in clashed_units and collided_unit is not Unit:
					clash(collided_unit)
		if current_mana == max_mana:
			cast_ability()
		else:
			current_mana = min(max_mana, current_mana + mana_regen)
		wait_one_turn = false
