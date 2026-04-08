extends Control

# Открытие нового окна
func _on_window_button_down(new_window: String) -> void: get_parent().close_window(new_window)

# Выход из приложения
func _on_exit_button_down() -> void: get_tree().quit()
