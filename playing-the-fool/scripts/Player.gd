extends Hand
var hovered_cards: Array = []
var unhovered_cards: Array = []

func _process(_delta: float) -> void:
	if len(hovered_cards) == 0: return
	get_child(hovered_cards.max()).position.y = height - 60
	while len(unhovered_cards) != 0:
		get_child(unhovered_cards[0]).position.y = height
		hovered_cards.pop_at(hovered_cards.find(unhovered_cards.pop_front()))
