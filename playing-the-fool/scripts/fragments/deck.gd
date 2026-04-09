extends Node2D
@onready var Cards = $Cards
# Переменная
var card: Resource = load("res://scenes/fragments/card.tscn")

func _ready() -> void:
	var card_array: Array = Array(range(1, 37))
	while len(card_array) > 0:
		Global.add_obj(Cards, card)
		Cards.get_child(-1).get_child(0).frame = 3 + card_array.pop_at(randi() % len(card_array))
		Cards.get_child(-1).position.x += (36 - len(card_array)) * 1.
		Cards.get_child(-1).position.y -= (36 - len(card_array)) * 1.
	$Pack.frame = (Cards.get_child(-1).get_child(0).frame) % 4
	$Pack.hide_shadow()
