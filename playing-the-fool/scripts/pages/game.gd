extends GameWindow
# Путь к объекту в сцене
@onready var Dropping = $Dropping

# Старт раздачи карт
func _ready() -> void: set_stage(Global.GameStates.DISTRIBUTION)

# Изменение текущего состояния игры
func set_stage(state: Global.GameStates) -> void:
	Global.game_state = state
	Dropping.disabled = state == Global.GameStates.DISTRIBUTION
	if state == Global.GameStates.PLAY:
		$Deck/Timer.stop()
		Dropping.set_text(tr(["_ATTACK", "_PROTECT"][int(Global.player)]))
		if Global.player: $Computer.shot()
	else: $Deck/Timer.start()

# Обработка нажатия на кнопку завершения хода игрока
func _on_dropping_button_down() -> void:
	if $Table.get_child_count() == 0: return
	if Global.player: $Hand.taking_cards()
	set_stage(Global.GameStates.DISTRIBUTION)
