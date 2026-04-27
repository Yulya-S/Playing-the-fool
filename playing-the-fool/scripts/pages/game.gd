extends GameWindow

# Старт раздачи карт
func _ready() -> void: set_stage(Global.GameStates.DISTRIBUTION)

# Изменение текущего состояния игры
func set_stage(state: Global.GameStates) -> void:
	Global.game_state = state
	$Dropping.disabled = state == Global.GameStates.DISTRIBUTION
