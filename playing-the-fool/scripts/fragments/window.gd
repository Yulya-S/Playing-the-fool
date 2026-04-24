extends Control
class_name GameWindow

# Закрытие окна
func _on_window_button_down(new_window: String = "menu") -> void: Global.main.close_window(new_window)
