extends Control
var current_player: bool = true

func _ready() -> void: Global.game_state = Global.GameStates.DISTRIBUTION

# Выход из игры
func _on_button_button_down() -> void: Global.close_window("menu")
