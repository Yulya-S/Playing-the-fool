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
	if not $"..".first_clear and get_attack_card_count() >= 6: return false
	var secure_cards_count: int = 0
	for i in get_children(): if i.state == Global.CardStates.SECURE: secure_cards_count += 1
	var current_player: Node = $"../Computer" if not Global.player else $"../Hand"
	if current_player.get_child_count() <= get_attack_card_count() - secure_cards_count: return false
	if not Global.player and zone_hovered and (len(card_prices) == 0 or card.price in card_prices):
		_reparent(card)
		card.start_anim("growth", true)
		$"../Computer"._fight()
		return true
	elif Global.player and hov_unhov.count() and card.mt(get_child(hov_unhov.max_hov())):
		set_secur(card, get_child(hov_unhov.max_hov()))
		card.start_anim("growth", true)
		#$"../Computer"._shot()
		$"../Computer".end_fight()
		return true
	return false

# Получение количества защитных карт
func get_attack_card_count() -> int:
	var attack_card_count: int = 0
	for i in get_children(): if i.state != Global.CardStates.SECURE: attack_card_count += 1
	return attack_card_count

# Применение защитной карты
func set_secur(secure, attack) -> void:
	secure.state = Global.CardStates.SECURE
	attack.state = Global.CardStates.DEFEATED
	_reparent(secure)

# Сброс карты на стол
func _reparent(card: Card) -> void:
	card.show_hide()
	if card.price not in card_prices: card_prices.append(card.price)
	card.reparent(self)
	get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
	get_child(-1).new_pos = get_child(-1).position

# Изменение состояния наведения курсора мыши на зону стола
func _on_mouse(hovered: bool) -> void: zone_hovered = hovered
