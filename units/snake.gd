extends Unit

func cast_ability():
	health += 1
	current_mana = 0

func on_kill():
	get_tree().get_first_node_in_group("level").mana += 1
	attack += 1
