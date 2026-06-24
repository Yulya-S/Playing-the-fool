extends Node
class_name Hand
# Настройки руки
@export var height: float = 0 # Расположение по высоте
@export var start_pos: float = 120 # Отступ от левого края
@export var max_weight: float = 952 # Ширина
@export var show_card: bool = true # Будет ли показываться цена карты

# Сохранение пути к сцене
func _ready() -> void: Global.PL = self

# Проверка что в руке карт больше 6
func cards_enough() -> bool: return get_child_count() >= 6

# Проверка что рука пуста
func empty() -> bool: return get_child_count() == 0

# Добавление карты в руку
func add_card() -> void:
	Global.deck.Cards.get_child(-1).reparent(self)
	_update_card_pos()

# Изменение позиции карты при переносе карты в руку
func _update_card_pos() -> void:
	get_child(-1).transfer(height)
	get_child(-1).rotation = 0.0
	get_child(-1).show_hide(show_card)
	if show_card: get_child(-1).start_anim("growth")
	_map_shift()

# Забрать карты со стола
func taking_cards() -> void:
	for i in Global.table.get_children():
		i.reparent(self)
		i.rotate_data = [true, 0]
		_update_card_pos()

# Изменение позиции карты
func _map_shift() -> void:
	# Получение значения шага между картами
	var step: float = 0.0
	if get_child_count() > 0:
		var weight: float = 100 * (get_child_count() - 1)
		if weight > max_weight: weight = max_weight
		step = weight / (get_child_count())
	# Применение новой позиции
	for i in range(get_child_count()):
		get_child(i).new_pos[0] = start_pos + (max_weight - step * (get_child_count() - 1)) / 2 + step * i
