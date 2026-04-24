extends AnimatedSprite2D
class_name Card
# Переменные
var suit: int = 0 # Масть
var price: int = 0 # Цена
var trump: bool = false # Метка козырности
# Переменные для плавного движения
var rotate_data: Array = [false, 0] # Данные для поворота карты
var new_pos: Vector2 = Vector2(0, 0)

# Применение карточного пака
func _ready() -> void: animation = str(int(Global.config.card_pack))

# Процесс анимации
func _process(delta: float) -> void:
	# Вращение
	if rotate_data[0]:
		rotation = lerp_angle(rotation, rotate_data[1], 1.2 * delta)
		if abs(fposmod(rotation, TAU) - rotate_data[1]) < 0.05: rotate_data[0] = false
	# Перемещение
	if new_pos != position and get_parent() is Hand:
		position = position.move_toward(new_pos, (1000.0 if new_pos.y != position.y else 500.0) * delta)

# Применение значения карты
func set_value(idx: int) -> void:
	price = int((3. + idx) / 4. + 5.)
	suit = (3 + idx) % 4
	hide_card()
	if get_parent().get_child_count() == 1:
		rotation_degrees = 90
		position.x += 25
		show_card()
		trump = true
	elif get_parent().get_child(0).suit == suit: trump = true

# Переворот карты
func show_card() -> void: frame = (price - 5) * 4 + suit

func hide_card() -> void: frame = 40

# Перемещение карты
func transfer(height: float) -> void: new_pos = Vector2(position.x, height)

# Обработка наведения курсора мыши
func _on_mouse(entered: bool = true) -> void:
	if get_parent().name == "Hand" and Global.game_state == Global.GameStates.PLAY:
		if entered and position.y >= get_parent().height: get_parent().hovered_cards.append(get_index())
		elif not entered and get_index() in get_parent().hovered_cards: get_parent().unhovered_cards.append(get_index())

# Запуск анимации
func start_anim(anim_name: String, backward: bool = false) -> void:
	if not backward: $AnimationPlayer.play(anim_name)
	else: $AnimationPlayer.play_backwards(anim_name)

# Старт анимации поворота
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall": rotate_data = [true, randf_range(0., TAU)]

# Сигнал завершения анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide": Global.delete_child(get_parent(), self)
