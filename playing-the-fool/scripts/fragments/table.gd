extends Control
# Переменная
var zone_hovered: bool = false # Определение курсора мыши в зоне стола
# Данные карт
var card_prices: Array = [] # Значения карт на столе
var hovered_cards: Array = [] # Карты под наведением
var unhovered_cards: Array = [] # Карты, с которых наведение снято

# Обработка карт на столе на которые наведена мышь
func _process(delta: float) -> void:
	hovered_cards = hovered_cards.filter(func(item): return item not in unhovered_cards)
	unhovered_cards = []
	
# Сброс карты на стол, во время хода игрока
func add_card(card: Node) -> bool:
	if not Global.player and (len(card_prices) == 0 or card.price in card_prices):
		if len(card_prices) == 0: card_prices.append(card.price)
		card.reparent(self)
		get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
		get_child(-1).new_pos = get_child(-1).position
		return true
	elif Global.player and len(hovered_cards) > 0 and card.mt(get_child(hovered_cards.max())):
		if len(card_prices) == 0: card_prices.append(card.price)
		card.reparent(self)
		get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
		get_child(-1).new_pos = get_child(-1).position
		return true
	return false

# Изменение состояния наведения курсора мыши на зону стола
func _on_mouse(hovered: bool) -> void: zone_hovered = hovered
