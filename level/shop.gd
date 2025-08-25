extends Node2D
@onready var shop_slots = [$"1",$"2",$"3",$"4",$"5"]
var shop_items = []
var odds = {"common":1,"uncommon":0,"rare":0}
var common = [preload("res://units/rock.tscn"), preload("res://units/scissor.tscn"), preload("res://units/paper.tscn")]
var uncommon = []
var rare = []
func reroll():
	for i in shop_slots:
		if i.unit != null:
			i.unit.queue_free()
	for i in shop_slots:
		var object
		var rarity = randf_range(0, 1)
		if rarity <= odds["common"]:
			object = common.pick_random()
		elif rarity <= odds["uncommon"]:
			object = uncommon.pick_random()
		elif rarity <= odds["rare"]:
			object = rare.pick_random()
		var unit = object.instantiate()
		unit.state = unit.states.SHOP
		unit.global_position = i.unit_position
		i.unit = unit
		$"../Units".add_child(unit)
		shop_items.append(unit)
func update_odds():
	pass
