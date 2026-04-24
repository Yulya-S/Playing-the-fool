extends Hand
# Путь к объекту в сцене
@onready var Table = $"../Table"
# Переменные
var hovered_cards: Array = [] # Карты под курсором мыши
var unhovered_cards: Array = [] # Карт с которых снято наведение курсора мыши
var clicked: int = -1 # Карта на которую нажали

# Изменение позиций карт
func _process(_delta: float) -> void:
	if clicked != -1: get_child(clicked).position = get_viewport().get_mouse_position()
	else:
		if len(hovered_cards) == 0 or get_child(hovered_cards.max()) == null: return
		get_child(hovered_cards.max()).position.y = height - 60
		# Сброс наведения курсора на карту
		if hovered_cards.max() in unhovered_cards: get_child(hovered_cards.max()).position.y = height
		hovered_cards = hovered_cards.filter(func(item): return item not in unhovered_cards)
		unhovered_cards = []

# Обработка нажатия на карту
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and len(hovered_cards) > 0: clicked = hovered_cards.max()
	elif event.is_action_released("click") and clicked != -1:
		if get_child(clicked) == null: return
		if not Table.mouse_hover(): get_child(clicked).position = get_child(clicked).new_pos
		else:
			get_child(clicked).reparent(Table)
			Table.get_child(-1).rotate_data = [true, randf_range(-0.2, 0.2)]
			Table.get_child(-1).start_anim("growth", true)
			_map_shift()
		hovered_cards = hovered_cards.filter(_clear_cards_array)
		unhovered_cards = unhovered_cards.filter(_clear_cards_array)
		clicked = -1

# Фильтр для списков карт
func _clear_cards_array(item) -> bool: return item <= clicked and item < get_child_count()
