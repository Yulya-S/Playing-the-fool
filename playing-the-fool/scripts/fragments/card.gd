extends AnimatedSprite2D
class_name Card
# Пути к объектам в сцене
@onready var v1 = $CardValue1
@onready var v2 = $CardValue2
# Переменные
var suit: int = 0 # Масть
var price: int = 0 # Цена
var trump: bool = false # Метка козырности
# Переменные для хранения данных для плавного движения карты
var rotate_data: Array = [false, 0] # Поворот
var new_pos: Vector2 = Vector2(0, 0) # Перемещение
# Переменне для проверки "Покрытия" карты
var attack: bool = true # Атакующая ли карта
var security_card: Card = null # Привязка карты "защитника"

# Применение карточного пака
func _ready() -> void: animation = str(int(Global.config.card_pack))

# Процесс анимации
func _process(delta: float) -> void:
	# Вращение
	if rotate_data[0]:
		rotation = lerp_angle(rotation, rotate_data[1], 1.2 * delta)
		if abs(fposmod(rotation, TAU) - rotate_data[1]) < 0.05: rotate_data[0] = false
	# Перемещение
	if new_pos != position and get_parent().name not in ["Cards", "Animation"]:
		position = position.move_toward(new_pos, (1000.0 if new_pos.y != position.y else 500.0) * delta)

# Вывод значения карты в понятном виде
func _to_string() -> String: return str(price) + " " + str(suit)

# Проверка что карта больше другой
func mt(other: Card) -> bool: return (price >= other.price and suit == other.suit) or (trump and not other.trump)

# Прочие функции
# Отображение цены и масти карты
func _set_price_suit(idx: int) -> void:
	for i in [v1, v2]:
		var value: int = int(idx / 4. + 6.)
		i.get_child(1).frame = idx % 4
		i.get_child(0).set_text(str(value))
		if value > 10: i.get_child(0).set_text(tr(["_J", "_Q", "_K","_A"][value - 11]))

# Изменение текстуры карты
func set_new_frame(idx: int) -> void:
	_set_price_suit(idx)
	frame = idx

# Применение значения карты
func set_value(idx: int) -> void:
	_set_price_suit(idx)
	price = int(idx / 4. + 6.)
	suit = idx % 4
	show_hide(false)
	if get_parent().get_child_count() == 1:
		rotation_degrees = 90
		position.x += 25
		show_hide()
		trump = true
	elif get_parent().get_child(0).suit == suit: trump = true

# Поворот карты (значением вверх, шапкой вверх)
func show_hide(show_card: bool = true) -> void:
	frame = ((price - 6) * 4 + suit) if show_card else 40
	for i in [v1, v2]: i.visible = show_card

# Перемещение карты
func transfer(height: float) -> void: new_pos = Vector2(position.x, height)

# Остановка определения наведения курсора мыши на карту
func mouse_treatments(stop_processing: bool) -> void: $Control.mouse_filter = Control.MOUSE_FILTER_IGNORE if stop_processing else Control.MOUSE_FILTER_STOP

# Обработка наведения курсора мыши
func _on_mouse(entered: bool = true) -> void:
	if get_parent().name in ["Hand", "Table"] and Global.game_state == Global.GameStates.PLAY:
		if not entered: get_parent().hov_unhov.array_filter(func(item): return item != get_index())
		else: get_parent().hov_unhov.add(self)

# Работа с анимациями
# Запуск
func start_anim(anim_name: String, backward: bool = false) -> void:
	$Control/AnimationPlayer.play(anim_name, -1, -1 if backward else 1, backward)

# Сигнал начала
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "fall":
		modulate.a = 0.
		rotate_data = [true, randf_range(0., TAU)]

# Сигнал завершения
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hide": Global.delete_child(get_parent(), self)
