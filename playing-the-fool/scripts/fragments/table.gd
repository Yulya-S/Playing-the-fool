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
	if not Global.player and check_enemy_card_count(): return false
	# Ход игрока
	if not Global.player and zone_hovered and (len(card_prices) == 0 or card.price in card_prices):
		_reparent(card)
		Global.CI.secure()
	elif Global.player and hov_unhov.count() and card.mt(get_child(hov_unhov.max_hov())):
		set_secur(card, get_child(hov_unhov.max_hov()))
		card.new_pos[1] = get_child(hov_unhov.max_hov()).position.y + 20
		Global.CI.attack()
		Global.CI.fight()
	else: return false
	hov_unhov.hovered_cards = []
	card.start_anim("growth", true)
	return true

# Добавление карты из руки компьютера
func add_CI_card(card: Node) -> void:
	if card.price not in card_prices: card_prices.append(card.price)
	card.reparent(self)
	get_child(-1).new_pos = Vector2(50 + get_attack_card_count() * 130, 130)
	if get_child(-1).new_pos[0] > 950:
		get_child(-1).new_pos = Vector2(80 + (get_attack_card_count() - 7) * 130, 180)
	get_child(-1).show_hide()

# Получение количества атакующих карт и карт в руке противника
func check_enemy_card_count() -> bool:
	var secure_cards_count: int = 0
	for i in get_children(): if i.state == Global.CardStates.SECURE: secure_cards_count += 1
	var current_player: Node = Global.CI if not Global.player else Global.PL
	if current_player.get_child_count() <= get_attack_card_count() - secure_cards_count:
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
	card.rotate_data = [true, randf_range(-0.2, 0.2)]
	card.new_pos = get_child(-1).position

# Изменение состояния наведения курсора мыши на зону стола
func _on_mouse(hovered: bool) -> void: zone_hovered = hovered
