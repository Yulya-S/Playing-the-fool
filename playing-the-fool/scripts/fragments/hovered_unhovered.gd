extends Node
class_name HovUnhov
# Переменные
var hovered_cards: Array = [] # Карты под курсором мыши

# Добавление элемента в список
func add(obj) -> void:
	if obj.state != Global.CardStates.ATTACK: return
	hovered_cards.append(obj.get_index())

# Получение карты у родителя
func get_card(obj) -> Node: return obj.get_child(max_hov())

# Получение количества карт
func count() -> bool: return len(hovered_cards) > 0

# Получение максимального объекта из hovered
func max_hov() -> int: return hovered_cards.max()

# Запуск фильтрации
func array_filter(filter_func) -> void: hovered_cards = hovered_cards.filter(filter_func)
