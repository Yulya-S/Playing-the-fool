extends Area2D
class_name Card
# Переменные
var suit: int = 0 # Масть
var price: int = 0 # Цена
var trump: bool = false # Метка козырности

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
