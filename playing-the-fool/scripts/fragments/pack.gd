extends AnimatedSprite2D
class_name Card
# Переменные
var suit: int = 0 # Масть
var price: int = 0 # Цена
var trump: bool = false # Метка козырности

var new_pos: Vector2 = Vector2(0, 0)

# Применение индекса
func set_value(idx: int) -> void:
	suit = (3 + idx) % 4
	price = int((3. + idx) / 4. + 5.)
	hide_card()
	if get_parent().get_child_count() == 1:
		rotation_degrees = 90
		position.x += 25
		show_card()
	if get_parent().get_child_count() == 1 or get_parent().get_child(0).suit == suit: trump = true

# Переворот карты
func show_card() -> void: frame = (price - 5) * 4 + suit

func hide_card() -> void: frame = 40

# Перемещение карты
func transfer(height: float) -> void: new_pos = Vector2(position.x, height)

# Запуск анимации
func start_anim(anim_name: String) -> void: $AnimationPlayer.play(anim_name)

func _on_mouse_entered() -> void:
	if get_parent().name == "Hand" and position.y >= get_parent().height:
		get_parent().hovered_cards.append(get_index())

func _on_mouse_exited() -> void:
	if get_parent().name == "Hand" and get_index() in get_parent().hovered_cards:
		get_parent().unhovered_cards.append(get_index())

# Переменная
var rotate_data: Array = [false, 0] # Данные для поворота карты

# Применение карточного пака
func _ready() -> void: animation = str(int(Global.config.card_pack))

# Процесс анимации
func _process(delta: float) -> void:
	if rotate_data[0]:
		rotation = lerp_angle(rotation, deg_to_rad(rotate_data[1]), 1.2 * delta)
		if abs(fposmod(rotation_degrees, 360) - rotate_data[1]) < 1: rotate_data[0] = false
	if new_pos != position and get_parent() is Hand:
		position = position.move_toward(new_pos, (1000.0 if new_pos.y != position.y else 500.0) * delta)

# Скрытие тени карыт
func hide_shadow(idx: int) -> void:
	$Line2D.visible = false
	frame = idx

# Старт анимации поворота
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall": rotate_data = [true, randi() % 360]

# Сигнал завершения анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide": Global.delete_child(get_parent(), self)
