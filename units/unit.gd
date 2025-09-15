extends Node2D
class_name Unit

enum states {SHOP, DECK, HAND, BATTLE, PICKED_UP}
var state : states

func _process(_delta: float) -> void:
	match state:
		states.PICKED_UP:
			global_position = get_global_mouse_position()
			z_index = 3
		states.HAND:
			z_index = 0
		states.BATTLE:
			z_index = 0
			if state == states.BATTLE:
				area = $AreaRayCast.get_collider()

var clashed_units = []
var area : Area2D:
	set(value):
		if area != null:
			area.unit = null
		area = value
		if area != null:
			area.unit = self
@export var health : int = 1:
	set(value):
		health = value
		if value <= 0:
			on_death()
			if area != null:
				area.unit = null
			queue_free()
		else:
			on_damaged_effect()
@export var attack : int
@export var defense : int
@export var mana_cost : int
@export var cost : int
@export var type : String
@export var name_ : String
@export var max_mana : int
@export var current_mana : int
@export var mana_regen : int
@export var can_move : bool = true
@export var mana_locked : bool = false
@export var ally : bool = true
@export var can_move_horizontally : bool = true
@export var can_inject_mana : bool = true
@export var left_ray_cast : RayCast2D
@export var right_ray_cast : RayCast2D

func update_position():
	area = $AreaRayCast.get_collider()

func call_move():
	call_deferred("move")

func move():
	clashed_units = []
	if state == states.BATTLE:
		if can_move:
			if mana_locked and current_mana == max_mana:
				cast_ability()
				return
			if !$Hitbox/UnitRayCast.is_colliding():
				global_position.y -= 35
				if global_position.y <= 0:
					area.unit = null
					queue_free()
					return
				await get_tree().process_frame
				area = $AreaRayCast.get_collider()

			elif $Hitbox/UnitRayCast.is_colliding():
				var collided_unit = $Hitbox/UnitRayCast.get_collider().get_parent()
				if collided_unit not in clashed_units and collided_unit is not Unit:
					clash(collided_unit)
		if current_mana == max_mana:
			cast_ability()
		else:
			current_mana = min(max_mana, current_mana + mana_regen)


func clash(unit):
	attack_unit(unit)
	unit.attack_unit(self)
	clashed_units.append(unit)
	unit.clashed_units.append(self)

@export var bonuses : Dictionary[String, int]
func attack_unit(unit):
	if unit == null:
		return
	on_attack_effect(unit)
	var damage = attack
	if unit.type in bonuses.keys():
		damage += bonuses[unit.type]
	damage = max(0, damage - unit.defense)
	if unit.health <= damage:
		on_kill()
	unit.health -= damage
	get_tree().get_first_node_in_group("sound").get_child(0).playing = true
	var damagefx = preload("res://level/damage_indicator.tscn").instantiate()
	damagefx.text = "-" + String.num_int64(damage)
	damagefx.global_position = unit.global_position + Vector2(0, -10)
	get_tree().get_first_node_in_group("units").add_child(damagefx)
	
func instantiate_area():
	area = $AreaRayCast.get_collider()
	

func cast_ability():
	pass
	
func on_death():
	pass

func on_attack_effect(unit):
	pass

func on_damaged_effect():
	pass
	
func on_kill():
	pass

@export var description : String
