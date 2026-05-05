extends AnimatedSprite2D
class_name Card
# Пути к объектам в сцене
@onready var v1 = $Value1
@onready var v2 = $Value2
# Переменные
var suit: int = 0 # Масть
var price: int = 0 # Цена
var trump: bool = false # Метка козырности
# Переменные для хранения данных для плавного движения карты
var rotate_data: Array = [false, 0] # Поворот
var new_pos: Vector2 = Vector2(0, 0) # Перемещение

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

# Получение "реальной" цены карты
func _get_price() -> int: return price + 20 * int(trump)

# Функции сравнения
# Карта меньше другой
func lt(other: Card) -> bool: return _get_price() < other._get_price()

# Карта больше другой
func mt(other: Card) -> bool: return _get_price() > other._get_price()

# Равенство масти
func es(other: Card) -> bool: return suit == other.suit

# Прочие функции
# Отображение цены и масти карты
func _set_price_suit(idx: int) -> void:
	for i in [v1, v2]:
		i.get_child(1).frame = idx % 4
		i.get_child(0).set_text(str(int(idx / 4. + 6.)))
		if int(idx / 4. + 6.) > 10:
			i.get_child(0).set_text(tr(["_J", "_Q", "_K","_A"][int(idx / 4. + 6.) - 11]))

# Изменение текстуры карты
func set_new_frame(idx: int) -> void:
	_set_price_suit(idx)
	frame = idx

# Применение значения карты
func set_value(idx: int) -> void:
	_set_price_suit(idx)
	price = int(idx / 4. + 6.)
	suit = idx % 4
	hide_card()
	if get_parent().get_child_count() == 1:
		rotation_degrees = 90
		position.x += 25
		show_card()
		trump = true
	elif get_parent().get_child(0).suit == suit: trump = true

# Переворот карты
func show_card() -> void:
	frame = (price - 6) * 4 + suit
	for i in [v1, v2]: i.visible = true

func hide_card() -> void:
	frame = 40
	for i in [v1, v2]: i.visible = false

# Перемещение карты
func transfer(height: float) -> void: new_pos = Vector2(position.x, height)

# Обработка наведения курсора мыши
func _on_mouse(entered: bool = true) -> void:
	if get_parent().name == "Hand" and Global.game_state == Global.GameStates.PLAY:
		if entered and position.y >= get_parent().height: get_parent().hovered_cards.append(get_index())
		elif not entered and get_index() in get_parent().hovered_cards: get_parent().unhovered_cards.append(get_index())

# Работа с анимациями
# Запуск
func start_anim(anim_name: String, backward: bool = false) -> void:
	$Control/AnimationPlayer.play(anim_name, -1, [1., -1.][int(backward)], backward)

# Сигнал начала
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall":
		modulate.a = 0.
		rotate_data = [true, randf_range(0., TAU)]

# Сигнал завершения
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide": Global.delete_child(get_parent(), self)
