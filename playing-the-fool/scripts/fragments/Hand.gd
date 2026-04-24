extends Node
class_name Hand
# Настройки руки
@export var height: float = 0 # Расположение руки по высоте
@export var start_pos: float = 120 # Отступ руки от левого края
@export var weight: float = 952 # Ширина руки
@export var show_card: bool = true # Будут ли показываться цена карты

# Проверка что в руке карт больше 6
func cards_enough() -> bool: return get_child_count() >= 6

# Добавление карты в руку
func add_card() -> void:
	Global.deck.Cards.get_child(-1).reparent(self)
	get_child(-1).transfer(height)
	get_child(-1).rotation = 0.0
	if not show_card: get_child(-1).hide_card()
	else: get_child(-1).start_anim("growth")
	_map_shift()

func _map_shift() -> void:
	for i in range(get_child_count()):
		get_child(i).new_pos[0] = start_pos + (0.0 if get_child_count() <= 1 else (weight / (get_child_count() - 1)) * i)
