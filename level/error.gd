extends CanvasLayer

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($Node, "modulate:a", 0, 1)
	await tween.finished
	queue_free()
