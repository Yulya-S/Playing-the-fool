extends Control
# Переменная
var zone_hovered: bool = false # Определение курсора мыши в зоне стола
# Данные карт
var card_prices: Array = [] # Значения карт на столе
var hov_unhov: HovUnhov = HovUnhov.new() # Карты в наведении

# Сброс карты на стол, во время хода игрока
func add_card(card: Node) -> bool:
	if not Global.player and zone_hovered and (len(card_prices) == 0 or card.price in card_prices):
		return _reparent(card)
	elif Global.player and hov_unhov.count() and card.mt(get_child(hov_unhov.max_hov())):
		card.attack = false
		get_child(hov_unhov.max_hov()).security_card = true
		return _reparent(card)
	return false

# Сброс карты на стол
func _reparent(card: Card) -> bool:
	if card.price not in card_prices: card_prices.append(card.price)
	card.reparent(self)
	get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
	get_child(-1).new_pos = get_child(-1).position
	return true

# Изменение состояния наведения курсора мыши на зону стола
func _on_mouse(hovered: bool) -> void: zone_hovered = hovered
