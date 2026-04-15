extends Area2D
class_name Card
# Переменные
var suit: int = 0 # Масть
var price: int = 0 # Цена
var trump: bool = false # Метка козырности

var new_pos: Vector2 = Vector2(0, 0)

func _process(delta: float) -> void:
	if new_pos != position and get_parent() is Hand:
		position = position.move_toward(new_pos, (1000.0 if new_pos.y != position.y else 500.0) * delta)

# Применение индекса
func set_value(idx: int) -> void:
	suit = (3 + idx) % 4
	price = (3 + idx) / 4 + 5
	hide_card()
	if get_parent().get_child_count() == 1:
		rotation_degrees = 90
		position.x += 25
		show_card()
	if get_parent().get_child_count() == 1 or get_parent().get_child(0).suit == suit: trump = true

# Переворот карты
func show_card() -> void: $Pack.frame = (price - 5) * 4 + suit

func hide_card() -> void: $Pack.frame = 40

# Перемещение карты
func transfer(height: float) -> void: new_pos = Vector2(position.x, height)
