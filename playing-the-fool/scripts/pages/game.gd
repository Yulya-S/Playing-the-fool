extends GameWindow
# Путь к объекту в сцене


# Старт раздачи карт
func _ready() -> void: set_stage(Global.GameStates.DISTRIBUTION)

# Завершение игры
func _process(_delta: float) -> void:
	if $Deck.card_count() == 0 and Global.table.get_child_count() == 0 and ($Hand.empty() or $Computer.empty()):
		_on_window_button_down()

# Изменение текущего состояния игры
func set_stage(state: Global.GameStates) -> void:
	Global.game_state = state
	if state == Global.GameStates.PLAY:
		$Deck/Timer.stop()
		$Dropping.set_text(tr(["_ATTACK", "_PROTECT"][int(Global.player)]))
	else: $Deck/Timer.start()
	Global.table.card_prices = []

# Завершение хода и начало следующего
func next_step() -> void:
	for i in Global.table.get_children(): Global.delete_child(Global.table, i)
	set_stage(Global.GameStates.DISTRIBUTION)
	Global.player = not Global.player

# Обработка нажатия на кнопку завершения хода игрока
func _on_dropping_button_down() -> void:
	if Global.table.get_child_count() == 0 or Global.game_state != Global.GameStates.PLAY: return
	if Global.player: $Hand.taking_cards()
	elif $CISay.visible: $Computer.taking_cards()
	else:
		next_step()
		return
	set_stage(Global.GameStates.DISTRIBUTION)
