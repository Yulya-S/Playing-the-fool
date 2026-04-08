extends Node2D
# Переменная
var file: Resource = load("res://scenes/fragments/pack.tscn") # Путь к паку с картачными колодами

# Таймер для анимации
func _on_timer_timeout() -> void:
	add_child(file.instantiate())
	get_child(-1).position = Vector2(50 + randi() % 1050, 50 + randi() % 550)
	get_child(-1).frame = 4 + randi() % 36
	get_child(-1).modulate.a = 0.
	get_child(-1).get_child(0).play("fall")
	if get_child_count() > 11: get_child(1 + randi() % 5).get_child(0).play("hide")
