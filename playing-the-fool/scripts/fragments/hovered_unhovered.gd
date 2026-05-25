extends Node
class_name HovUnhov
# Переменные
var hovered_cards: Array = [] # Карты под курсором мыши

# Добавление элемента в список
func add(obj) -> void: hovered_cards.append(obj.get_index())

# Проверка есть ли элемент в списке наведения
func have_index(obj) -> bool: return obj.get_index() in hovered_cards

# Получение карты у родителя
func get_card(obj) -> Node: return obj.get_child(max_hov())

# Получение количества карт
func count() -> bool: return len(hovered_cards) > 0

# Получение максимального объекта из hovered
func max_hov() -> int: return hovered_cards.max()

func del(obj) -> void: hovered_cards = hovered_cards.filter(func(item): return item != obj.get_index())

# Запуск фильтрации
func array_filter(filter_func) -> void: hovered_cards = hovered_cards.filter(filter_func)
