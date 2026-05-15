extends Control
# Переменная
var card_prices: Array = [] # Значения карт на столе
var hovered_cards: Array = []
var unhovered_cards: Array = []

# Проверка находится ли курсор мыши в зоне стола
func mouse_hover() -> bool:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	return _check_pos(mouse_pos, 0) and _check_pos(mouse_pos, 1)

func _process(delta: float) -> void:
	hovered_cards = hovered_cards.filter(func(item): return item not in unhovered_cards)
	unhovered_cards = []

# Общая часть проверки позиции курсора мыши
func _check_pos(mouse_pos: Vector2, idx: int) -> bool:
	return mouse_pos[idx] > position[idx] and mouse_pos[idx] < position[idx] + size[idx]

# Сброс карты на стол, во время хода игрока
func add_card(card: Node) -> bool:
	if not Global.player and (len(card_prices) == 0 or card.price in card_prices):
		if len(card_prices) == 0: card_prices.append(card.price)
		card.reparent(self)
		get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
		get_child(-1).new_pos = get_child(-1).position
		return true
	elif Global.player and len(hovered_cards) > 0:
		if len(card_prices) == 0: card_prices.append(card.price)
		card.reparent(self)
		get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
		get_child(-1).new_pos = get_child(-1).position
		return true
	return false
