extends Area2D

# Применение индекса
func set_value(idx: int) -> void:
	if idx < 4: $Pack.get_child(-1).visible = false
	$Pack.frame = idx
