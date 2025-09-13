extends Enemy

func _ready() -> void:
	await get_tree().process_frame
	instantiate_area()
