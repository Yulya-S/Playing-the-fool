extends Hand
var hovered_cards: Array = []
var unhovered_cards: Array = []
var clicked: int = 0

func _process(_delta: float) -> void:
	if clicked != 0:
		get_child(clicked).position = get_viewport().get_mouse_position()
		return
	if len(hovered_cards) == 0: return
	get_child(hovered_cards.max()).position.y = height - 60
	while len(unhovered_cards) != 0:
		get_child(unhovered_cards[0]).position.y = height
		hovered_cards.pop_at(hovered_cards.find(unhovered_cards.pop_front()))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and len(hovered_cards) > 0: clicked = hovered_cards.max()
	if event.is_action_released("click") and clicked != 0:
		if get_child(clicked).position.y <= height: hovered_cards.pop_at(hovered_cards.find(clicked))
		get_child(clicked).position = get_child(clicked).new_pos
		clicked = 0
		
