extends Enemy

func cast_ability():
	health += 1
	current_mana = 0

func on_kill():
	attack += 1
