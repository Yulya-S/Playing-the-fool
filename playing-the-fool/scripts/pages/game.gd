extends Control
var current_player: bool = true

# Выход из игры
func _on_button_button_down() -> void: Global.close_window("menu")
