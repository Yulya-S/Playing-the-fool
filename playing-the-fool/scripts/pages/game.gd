extends GameWindow
# Переменная
var steps: int = 0 # Счетчик ходов для статистики

# Старт раздачи карт
func _ready() -> void: set_stage(Global.GameStates.DISTRIBUTION)

# Завершение игры
func _process(_delta: float) -> void:
	if Global.deck.card_count() == 0 and Global.table.get_child_count() == 0 and ($Hand.empty() or $Computer.empty()):
		_on_window_button_down()

# Изменение текущего состояния игры
func set_stage(state: Global.GameStates) -> void:
	Global.game_state = state
	Global.deck.get_child(-1).paused = state == Global.GameStates.PLAY
	if state == Global.GameStates.PLAY: $Dropping.set_text(tr(["_ATTACK", "_PROTECT"][int(Global.player)]))
	else: steps += 1
	Global.table.card_prices = []

# Завершение хода и начало следующего
func next_step() -> void:
	for i in Global.table.get_children(): Global.delete_child(Global.table, i)
	Global.player = not Global.player

# Обработка нажатия на кнопку завершения хода игрока
func _on_dropping_button_down() -> void:
	if Global.table.get_child_count() == 0 or Global.game_state != Global.GameStates.PLAY: return
	set_stage(Global.GameStates.DISTRIBUTION)
	if Global.player: $Hand.taking_cards()
	elif $CISay.visible: $Computer.taking_cards()
	else: next_step()
