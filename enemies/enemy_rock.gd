extends Enemy

func cast_ability():
	defense = 2
	current_mana = 0

func on_damaged_effect():
	defense = 0
