extends Node2D

var top_card:
	set(value):
		top_card = value
		if top_card != null:
			top_card.z_index = 3
var deck = []

func draw_cards():
	var count = 1
	for i in $"../Hand".free_slots:
		if count == 1 and top_card != null:
			var card = top_card
			card.z_index = 0
			card.state = card.states.HAND
			i.unit = card
			var tween = create_tween()
			tween.tween_property(card, "global_position", i.unit_position, 0.1)
			top_card = null
		elif deck.size() > 0:
			var card = deck.pop_front()
			card.state = card.states.HAND
			i.unit = card
			var tween = create_tween()
			tween.tween_property(card, "global_position", i.unit_position, 0.1)
		count += 1
	top_card = deck.pop_front()
	
