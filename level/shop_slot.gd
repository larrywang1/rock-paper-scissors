extends Area2D

@onready var level : Node2D = $"../.."
@export var unit : Node2D:
	set(value):
		unit = value
		if unit != null:
			$Label.text = String.num_int64(unit.cost)
		else:
			$Label.text = ""
@export var unit_position : Vector2

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
func _on_mouse_entered() -> void:
	level.hovered_area = self

func _on_mouse_exited() -> void:
	if level.hovered_area == self:
		level.hovered_area = null
