extends Node2D

var hovered_area : Area2D:
	set(value):
		hovered_area = value
		if unit_in_hand == null:
			if hovered_area != null:
				if hovered_area.unit != null:
					var unit = hovered_area.unit
					$Info/Name.text = unit.name_
					$Info/Class.text = unit.type.capitalize()
					$Info/Cost.text = String.num_int64(unit.mana_cost)
					$Info/HP.text = "HP:" + String.num_int64(unit.health)
					$Info/ATK.text = "ATK:" + String.num_int64(unit.attack)
					$Info/DEF.text = "DEF:" + String.num_int64(unit.defense)
					$Info/Mana.text = String.num_int64(unit.current_mana) + "/" + String.num_int64(unit.max_mana)
					$Info/Description.text = unit.description
				else:
					$Info/Name.text = ""
					$Info/Class.text = ""
					$Info/Cost.text = ""
					$Info/HP.text = ""
					$Info/ATK.text = ""
					$Info/DEF.text = ""
					$Info/Mana.text = ""
					$Info/Description.text = ""
			else:
				$Info/Name.text = ""
				$Info/Class.text = ""
				$Info/Cost.text = ""
				$Info/HP.text = ""
				$Info/ATK.text = ""
				$Info/DEF.text = ""
				$Info/Mana.text = ""
				$Info/Description.text = ""
var hovered_button : Area2D
var unit_in_hand : Node2D
var area_grabbed_from : Node2D

func _input(event):
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if hovered_area != null:
				if hovered_area.unit != null:
					if hovered_area in $Hand.slots:
						hovered_area.unit.state = hovered_area.unit.states.PICKED_UP
						unit_in_hand = hovered_area.unit
						hovered_area.unit = null
						area_grabbed_from = hovered_area
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			if unit_in_hand and hovered_area in $Hand.slots and hovered_area.unit == null:
				hovered_area.unit =  unit_in_hand
				unit_in_hand.state = unit_in_hand.states.HAND
				unit_in_hand.global_position = hovered_area.unit_position
				unit_in_hand = null
			elif unit_in_hand and hovered_area in $Battlefield.placable_slots and hovered_area.unit == null:
				if unit_in_hand.cost > mana:
					area_grabbed_from.unit =  unit_in_hand
					unit_in_hand.state = unit_in_hand.states.HAND
					unit_in_hand.global_position = area_grabbed_from.unit_position
					unit_in_hand = null
					add_child(preload("res://level/error.tscn").instantiate())
					return
				mana -= unit_in_hand.cost
				hovered_area.unit = unit_in_hand
				unit_in_hand.state = unit_in_hand.states.BATTLE
				unit_in_hand.global_position = hovered_area.unit_position
				unit_in_hand.area = hovered_area
				unit_in_hand = null
			elif unit_in_hand and hovered_area in $Hand.slots and hovered_area.unit != null:
				area_grabbed_from.unit = hovered_area.unit
				area_grabbed_from.unit.global_position = area_grabbed_from.unit_position
				hovered_area.unit =  unit_in_hand
				unit_in_hand.state = unit_in_hand.states.HAND
				unit_in_hand.global_position = hovered_area.unit_position
				unit_in_hand = null
			elif unit_in_hand:
				area_grabbed_from.unit =  unit_in_hand
				unit_in_hand.state = unit_in_hand.states.HAND
				unit_in_hand.global_position = area_grabbed_from.unit_position
				unit_in_hand = null
			elif hovered_area in $Shop.shop_slots and hovered_area.unit != null:
				if money >= hovered_area.unit.cost:
					$Shop.shop_items.remove_at($Shop.shop_items.find(hovered_area.unit))
					money -= hovered_area.unit.cost
					$Hand.find_free_slots()
					if $Hand.free_slots.size() >= 1:
						var unit = hovered_area.unit
						hovered_area.unit = null
						unit.state = unit.states.HAND
						$Hand.free_slots[0].unit = unit
						var tween = create_tween()
						tween.tween_property(unit, "global_position", $Hand.free_slots[0].unit_position, 0.2)
					else:
						if $Deck.top_card == null:
							var unit = hovered_area.unit
							hovered_area.unit = null
							unit.state = unit.states.DECK
							$Deck.top_card = unit
							var tween = create_tween()
							tween.tween_property(unit, "global_position", $Deck/Marker2D.global_position, 0.2)
						else:
							var unit = hovered_area.unit
							hovered_area.unit = null
							unit.state = unit.states.DECK
							$Deck.deck.append(unit)
							$Deck.deck.shuffle()
							var tween = create_tween()
							tween.tween_property(unit, "global_position", $Deck/Marker2D.global_position, 0.2)
				else:
					add_child(preload("res://level/money_error.tscn").instantiate())

func _process(_delta):
	$Background/Timer.value = $Background/Timer2.time_left

@export var mana : int = 0:
	set(value):
		mana = value
		call_deferred("update_stats")
@export var max_mana : int = 10:
	set(value):
		max_mana = value
		call_deferred("update_stats")
var mana_regen : int = 1:
	set(value):
		mana_regen = value
		call_deferred("update_stats")
var wave = 0
@export var money : int =10000:
	set(value):
		money = value
		call_deferred("update_stats")
@export var health : int = 0:
	set(value):
		health = value
		call_deferred("update_stats")

func update_stats():
	$Background/Mana.text = String.num_int64(mana) + "/" + String.num_int64(max_mana)
	$Background/ManaRegen.text = String("+" + String.num_int64(mana_regen))
	$Background/Health.text = String.num_int64(health)
	$Background/Money.text = String.num_int64(money)

func move():
	wave += 1
	mana = min(max_mana, mana + mana_regen)
	$Hand.find_free_slots()
	$Shop.update_odds()
	$Shop.reroll()
	$Shop/Reroll.cost = 3
	$Deck.draw_cards()
	var units = []
	for i in $Battlefield.get_children():
		units.append(i.unit)
	for i in units:
		if i != null:
			await get_tree().process_frame
			i.move()
