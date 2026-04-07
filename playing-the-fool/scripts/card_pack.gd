extends AnimatedSprite2D
var rotate_data: Array = [false, 0]

func _process(delta: float) -> void:
	if rotate_data[0]:
		rotation_degrees = move_toward(rotation_degrees, rotate_data[1], abs(rad_to_deg(angle_difference(deg_to_rad(rotation_degrees), deg_to_rad(rotate_data[1])))) / 1.2 * delta)
		if abs(int(rotation_degrees) - rotate_data[1]) < 10: rotate_data[0] = false

# Старт анимации поворота
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall": rotate_data = [true, randi_range(-366, 366)]

# Сигнал завершения анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide":
		queue_free()
		get_parent().remove_child(self)
