extends AnimatedSprite2D
# Переменная
var rotate_data: Array = [false, 0] # Данные для поворота карты

# Применение карточного пака
func _ready() -> void:
	animation = str(int(Global.config.card_pack))
	var frame_size: Vector2 = sprite_frames.get_frame_texture(animation, frame).get_size()
	scale = Vector2(frame_size.x / 246., frame_size.y / 344.)

# Процесс анимации
func _process(delta: float) -> void:
	if rotate_data[0]:
		rotation = lerp_angle(rotation, deg_to_rad(rotate_data[1]), 1.2 * delta)
		if abs(fposmod(rotation_degrees, 360) - rotate_data[1]) < 1: rotate_data[0] = false

# Старт анимации поворота
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall": rotate_data = [true, randi() % 360]

# Сигнал завершения анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide": Global.delete_child(get_parent(), self)
