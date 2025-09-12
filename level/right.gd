extends Area2D
@onready var level : Node2D = $"../.."
var is_mouse_entered : bool = false
func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered() -> void:
	is_mouse_entered = true
	level.lock_clicking_off = true

func _on_mouse_exited() -> void:
	is_mouse_entered = false
	level.lock_clicking_off = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and is_mouse_entered:
			level.right()
