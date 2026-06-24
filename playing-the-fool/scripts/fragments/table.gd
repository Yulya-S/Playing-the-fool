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
	# Проверка что это не первый сброс в 6 карт
	if not Global.game.first_clear and get_attack_card_count() >= 6: return false
	# Проверка что количество карт не больше чем может побить противник
	if not Global.player:
		var secure_cards_count: int = 0
		for i in get_children():
			if i.state == Global.CardStates.SECURE: secure_cards_count += 1
		var current_player: Node = Global.CI if not Global.player else Global.PL
		if current_player.get_child_count() <= get_attack_card_count() - secure_cards_count:
			return false
	# Ход игрока
	if not Global.player and zone_hovered and (len(card_prices) == 0 or card.price in card_prices):
		_reparent(card)
		Global.CI.secure()
	elif Global.player and hov_unhov.count() and card.mt(get_child(hov_unhov.max_hov())):
		set_secur(card, get_child(hov_unhov.max_hov()))
		#Global.CI.attack()
		Global.CI.fight()
	else: return false
	card.start_anim("growth", true)
	return true

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
