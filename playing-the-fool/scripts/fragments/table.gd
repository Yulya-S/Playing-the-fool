extends Control

# Создание сцены
func _ready() -> void: Global.table = self

# Проверка находится ли курсор мыши в зоне стола
func mouse_hover() -> bool:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	return _check_pos(mouse_pos, 0) and _check_pos(mouse_pos, 1)

# Общая часть проверки позиции курсора мыши
func _check_pos(mouse_pos: Vector2, idx: int) -> bool:
	return mouse_pos[idx] > position[idx] and mouse_pos[idx] < position[idx] + size[idx]
