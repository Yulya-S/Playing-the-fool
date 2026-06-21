extends Control
# Переменные
var zone_hovered: bool = false # Определение курсора мыши в зоне стола
# Данные карт
var card_prices: Array = [] # Значения карт на столе
var hov_unhov: HovUnhov = HovUnhov.new() # Карты в наведении

# Сохранения стола как глобального элемента
func _ready() -> void: Global.table = self

# Сброс карты на стол, во время хода игрока
func add_card(card: Node) -> bool:
	if not Global.player and zone_hovered and (len(card_prices) == 0 or card.price in card_prices):
		return _reparent(card)
	elif Global.player and hov_unhov.count() and card.mt(get_child(hov_unhov.max_hov())):
		return set_secur(card, get_child(hov_unhov.max_hov()))
	return false

func set_secur(secure, attack) -> bool:
	secure.attack = false
	attack.security_card = true
	return _reparent(secure)

# Сброс карты на стол
func _reparent(card: Card) -> bool:
	card.show_hide()
	if card.price not in card_prices: card_prices.append(card.price)
	card.reparent(self)
	get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
	get_child(-1).new_pos = get_child(-1).position
	return true

# Изменение состояния наведения курсора мыши на зону стола
func _on_mouse(hovered: bool) -> void: zone_hovered = hovered
