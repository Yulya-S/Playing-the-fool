extends Control

# Открытие окна статистики
func _on_statistics_button_down() -> void: get_parent().close_window("statistics")
