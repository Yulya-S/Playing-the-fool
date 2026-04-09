extends Control

# Открытие нового окна
func _on_window_button_down(new_window: String) -> void: get_parent().close_window(new_window)

# Старт игры
func _on_play_button_down() -> void:
	Global.delete_child(get_parent(), get_parent().get_child(1))
	_on_window_button_down("game")
