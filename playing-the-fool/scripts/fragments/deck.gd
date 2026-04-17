extends Node2D
@onready var Cards = $Cards
# Переменная
var card: Resource = load("res://scenes/fragments/pack.tscn")
var user_idx: bool = true

func _ready() -> void:
	var card_array: Array = Array(range(1, 37))
	while len(card_array) > 0:
		Global.add_obj(Cards, card)
		Cards.get_child(-1).set_value(card_array.pop_at(randi() % len(card_array)))
		Cards.get_child(-1).position.x += (36 - len(card_array)) * 0.5
		Cards.get_child(-1).position.y -= (36 - len(card_array)) * 0.5
	$Label.set_text(str(Cards.get_child_count()))
	$Pack.hide_shadow(Cards.get_child(0).suit)

func dealing_cards(user: Hand) -> void:
	Cards.get_child(-1).reparent(user)
	user.add_card()

func _on_timer_timeout() -> void:
	dealing_cards($"../Hand" if user_idx else $"../Computer")
	user_idx = not user_idx
	if $"../Computer".get_child_count() >= 6: user_idx = true
	if $"../Hand".get_child_count() >= 6: user_idx = false
	if ($"../Hand".get_child_count() >= 6 and $"../Computer".get_child_count() >= 6) or \
		Cards.get_child_count() == 0:
			$Timer.stop()
	$Label.set_text(str(Cards.get_child_count()))
