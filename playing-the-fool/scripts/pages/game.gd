extends GameWindow
# Путь к объекту в сцене
@onready var Dropping = $Dropping

# Старт раздачи карт
func _ready() -> void: set_stage(Global.GameStates.DISTRIBUTION)

# Изменение текущего состояния игры
func set_stage(state: Global.GameStates) -> void:
	Global.game_state = state
	Dropping.disabled = state == Global.GameStates.DISTRIBUTION
	if state == Global.GameStates.PLAY: Dropping.set_text(tr(["_ATTACK", "_PROTECT"][int(Global.player)]))
	
