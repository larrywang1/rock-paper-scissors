extends Area2D

@export var level : Node2D
@export var unit : Node2D:
	set(value):
		unit = value
		if unit == null and self in $"..".free_slots:
			$"..".free_slots.remove_at($"..".free_slots.find(self))
		if unit != null and self not in $"..".free_slots:
			$"..".free_slots.append(self)
			
@export var unit_position : Vector2

func _on_mouse_entered() -> void:
	level.hovered_area = self

func _on_mouse_exited() -> void:
	if level.hovered_area == self:
		level.hovered_area = null
