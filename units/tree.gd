extends Unit
@onready var level = get_tree().get_first_node_in_group("level")
func cast_ability():
	level.mana = min(level.max_mana, level.mana + level.mana_regen)

func on_death():
	level.max_mana += 1
