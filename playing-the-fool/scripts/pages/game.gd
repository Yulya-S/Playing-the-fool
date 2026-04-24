extends GameWindow

# Старт раздачи карт
func _ready() -> void: Global.game_state = Global.GameStates.DISTRIBUTION
