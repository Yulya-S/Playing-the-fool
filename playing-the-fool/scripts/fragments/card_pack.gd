extends AnimatedSprite2D
# Переменная
var rotate_data: Array = [false, 0] # Данные для поворота карты

func _process(delta: float) -> void:
	if rotate_data[0]:
		rotation = lerp_angle(rotation, deg_to_rad(rotate_data[1]), 1.2 * delta)
		if abs(fposmod(rotation_degrees, 360) - rotate_data[1]) < 1: rotate_data[0] = false

# Старт анимации поворота
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall": rotate_data = [true, randi() % 360]

# Сигнал завершения анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide":
		queue_free()
		get_parent().remove_child(self)
