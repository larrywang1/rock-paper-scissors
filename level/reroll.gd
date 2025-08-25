extends Area2D

@onready var level : Node2D = $"../.."
var is_mouse_entered : bool = false
var cost : int = 3:
	set(value):
		cost = value
		$Label.text = String.num_int64(cost)

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered() -> void:
	is_mouse_entered = true

func _on_mouse_exited() -> void:
	is_mouse_entered = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and is_mouse_entered:
			if level.money >= cost:
				$"..".reroll()
				level.money -= cost
				cost += 1
