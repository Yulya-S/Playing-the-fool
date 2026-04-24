extends Hand
@onready var GameZone = $"../GameZone"
var hovered_cards: Array = []
var unhovered_cards: Array = []
var clicked: int = -1

func _process(_delta: float) -> void:
	if clicked != -1:
		if clicked < get_child_count(): get_child(clicked).position = get_viewport().get_mouse_position()
		return
	if len(hovered_cards) == 0 or get_child(hovered_cards.max()) == null: return
	get_child(hovered_cards.max()).position.y = height - 60
	while len(unhovered_cards) != 0:
		if unhovered_cards[0] >= get_child_count():
			unhovered_cards.pop_front()
			continue
		get_child(unhovered_cards[0]).position.y = height
		hovered_cards.pop_at(hovered_cards.find(unhovered_cards.pop_front()))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and len(hovered_cards) > 0: clicked = hovered_cards.max()
	if event.is_action_released("click") and clicked != -1:
		if get_child(clicked) == null: return
		if GameZone.mouse_hover():
			get_child(clicked).reparent(GameZone)
			GameZone.get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
			GameZone.get_child(-1).get_child(-1).play_backwards("growth")
			_map_shift()
		else:
			if get_child(clicked).position.y <= height: hovered_cards.pop_at(hovered_cards.find(clicked))
			get_child(clicked).position = get_child(clicked).new_pos
		hovered_cards = hovered_cards.filter(func(item): return item < clicked and item < get_child_count())
		unhovered_cards = unhovered_cards.filter(func(item): return item < clicked and item < get_child_count())
		clicked = -1
