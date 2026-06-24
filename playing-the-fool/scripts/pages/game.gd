extends GameWindow
# Переменные
var steps: int = 0 # Счетчик ходов для статистики
var first_clear: bool = false # Была ли объявленна первая "бита"
var clear_table: bool = false # остановка действий во время чистки стола

# Старт раздачи карт
func _ready() -> void: set_stage(Global.GameStates.DISTRIBUTION)

# Завершение игры
func _process(_delta: float) -> void:
	if $Trash.get_child_count() == 0: clear_table = false
	for i in $Trash.get_children():
		if $Trash.position.x - i.position.x < 20: Global.delete_child($Trash, i)
	if $GameOverWindow.visible: return
	if Global.deck.card_count() == 0 and Global.table.get_child_count() == 0 and ($Hand.empty() or $Computer.empty()):
		$GameOverWindow.start_anim($Hand.empty(), $Computer.empty())

# Изменение текущего состояния игры
func set_stage(state: Global.GameStates) -> void:
	Global.game_state = state
	Global.deck.get_child(-1).paused = state == Global.GameStates.PLAY
	if state == Global.GameStates.PLAY:
		$Dropping.set_text(tr(["_ATTACK", "_PROTECT"][int(Global.player)]))
		$Hand._card_sort()
		if Global.player: $Computer._shot()
	else: steps += 1
	Global.table.card_prices = []

# Завершение хода и начало следующего
func next_step() -> void:
	clear_table = true
	first_clear = true
	Global.player = not Global.player
	for i in Global.table.get_children():
		i.reparent($Trash)
		i.new_pos.x = $Trash.position.x

# Обработка нажатия на кнопку завершения хода игрока
func _on_dropping_button_down() -> void:
	if Global.table.get_child_count() == 0 or Global.game_state != Global.GameStates.PLAY: return
	if Global.player: $Hand.taking_cards()
	elif $CISay.visible: $Computer.taking_cards()
	else: next_step()
	set_stage(Global.GameStates.DISTRIBUTION)
