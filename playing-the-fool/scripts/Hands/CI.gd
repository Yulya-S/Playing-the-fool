extends Hand
# Перечисление стратегий КИ
enum CIStrategy {COMBINATION, GREEDY, SMALLER}
# Путь к объекту в сцене
@onready var Say = $"../CISay"
var strategy: CIStrategy = CIStrategy[CIStrategy.keys().pick_random()]

# Сохранение пути к сцене
func _ready() -> void: Global.CI = self

# Отображение количества карт и смещение их к центру
func _process(_delta: float) -> void:
	$"../CICardsCount".set_text(str(get_child_count()))
	_map_shift()

# Процесс защиты
func secure() -> void:
	if not Say.visible and Global.table.get_child_count() > 0:
		for i in Global.table.get_children():
			if i.state == Global.CardStates.ATTACK:
				var select_card: Node = _find_min_card(i)
				if select_card == null:
					$"../CISay/AnimationPlayer".play("show_CISay")
					Global.game.Drop.set_text(tr("_GIVE_AWAY"))
					return
				Global.table.set_secur(select_card, i)
				select_card.new_pos = Vector2(i.position.x+10, i.position.y+20)
				select_card.rotate_data = [true, 0]

# Очистка состояний по окончанию хода
func taking_cards() -> void:
	super.taking_cards()
	Say.visible = false

# Завершение атаки игрока
func fight() -> void:
	var secure_card_count: int = 0
	for i in Global.table.get_children(): if i.state == Global.CardStates.SECURE: secure_card_count += 1
	if secure_card_count != Global.table.get_attack_card_count(): return
	Global.game.set_stage(Global.GameStates.DISTRIBUTION)
	Global.game.next_step()

# Поис меньших карт
# Поиск меньшей карты в руке для защиты
func min_card_to_secure(card: Node) -> Node:
	var select_card: Node = null
	for i in get_children():
		if i.mt(card) and (select_card == null or select_card.mt(i)): select_card = i
	return select_card

# Поиск меньшей карты в руке для атаки
func min_card_to_attack() -> Node:
	var select_card: Node = null
	for i in get_children(): if select_card == null or select_card.mt(i): select_card = i
	return select_card

#КИ
func _check_null(card: Node, result: Node) -> bool:
	match strategy:
		CIStrategy.COMBINATION: return Global.deck.card_count() > 8 and (result.real_price() - card.real_price() > 1 or card.trump)
		CIStrategy.GREEDY: return Global.deck.card_count() > 8
		CIStrategy.SMALLER: return Global.deck.card_count() != 0 and (result.real_price() - card.real_price() > 3 or card.trump)
	return false

# Поиск карты с наименьшей ценой в руке компьютера
func _find_min_card(card: Node) -> Node:
	var result: Node = min_card_to_secure(card)
	if result == null or _check_null(card, result): return null
	return result

# Ход компьютера
func attack() -> void:
	if get_child_count() == 0: return
	if Global.table.get_child_count() == 0: Global.table.add_CI_card(min_card_to_attack())
	if strategy != CIStrategy.SMALLER and Global.deck.card_count() > 8: return
	for i in get_children():
		if not Global.game.first_clear and Global.table.get_attack_card_count() >= 6: return
		if Global.table.check_enemy_card_count(): return
		if i.price in Global.table.card_prices and not i.trump: Global.table.add_CI_card(i)
