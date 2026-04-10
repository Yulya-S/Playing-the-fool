extends Control

# Открытие нового окна
func _on_window_button_down(new_window: String) -> void: Global.close_window(new_window)
