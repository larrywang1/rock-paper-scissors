extends Node2D

@export var level : Node2D
@onready var slots = [$"1",$"2",$"3",$"4",$"5"]

var free_slots = []

func find_free_slots():
	free_slots = []
	for i in get_children():
		if i.unit == null:
			free_slots.append(i)
