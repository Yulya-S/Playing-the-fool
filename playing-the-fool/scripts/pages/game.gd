extends GameWindow
var current_player: bool = true

func _ready() -> void: Global.game_state = Global.GameStates.DISTRIBUTION
