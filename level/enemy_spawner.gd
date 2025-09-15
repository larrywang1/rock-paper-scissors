extends Node2D

@onready var spawn_slots = [$"../Battlefield/A1",$"../Battlefield/A2",$"../Battlefield/A3",$"../Battlefield/A4",$"../Battlefield/A5",$"../Battlefield/B1",$"../Battlefield/B2",$"../Battlefield/B3",$"../Battlefield/B4",$"../Battlefield/B5"]
var enemies1 = [preload("res://enemies/enemy_paper.tscn"), preload("res://enemies/enemy_rock.tscn"), preload("res://enemies/enemy_scissors.tscn")]
var enemies2 = [preload("res://enemies/enemy_paper.tscn"), preload("res://enemies/enemy_rock.tscn"), preload("res://enemies/enemy_scissors.tscn"),preload("res://enemies/enemy_paper.tscn"), preload("res://enemies/enemy_rock.tscn"), preload("res://enemies/enemy_scissors.tscn"),preload("res://enemies/enemy_gun.tscn"),preload("res://enemies/enemy_circle.tscn"),preload("res://enemies/enemy_snake.tscn")]

var count = 3
var open_slots = []
var upgraded = false
func spawn():
	open_slots = []
	for i in spawn_slots:
		if i.unit == null:
			open_slots.append(i)
	for i in range(count):
		if open_slots == []:
			break
		var j = open_slots.pick_random()
		var unit
		if !upgraded:
			unit = enemies1.pick_random().instantiate()
		else:
			unit = enemies2.pick_random().instantiate()
		unit.global_position = j.get_child(0).global_position
		open_slots.erase(j)
		j.unit = unit
		$"../Units".add_child(unit)

func update(wave):
	if wave == 50:
		upgraded = true
		count = 4
	if wave == 250:
		$"..".threshold = 2
	if wave == 100:
		count = 5
	if wave == 150:
		count = 6


func _ready() -> void:
	spawn()
	$"../Shop".reroll()
