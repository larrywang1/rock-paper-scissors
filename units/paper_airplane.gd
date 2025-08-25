extends Unit

func _ready() -> void:
	await get_tree().process_frame
	instantiate_area()
	state = states.BATTLE
