extends Hand
# Путь к объекту в сцене
@onready var Table = $"../Table"
# Переменные
var hov_unhov: HovUnhov = HovUnhov.new() # Карты в наведении
var clicked: int = -1 # Карта на которую нажали

# Изменение позиций карт
func _process(_delta: float) -> void:
	if clicked != -1: get_child(clicked).position = get_viewport().get_mouse_position()
	else:
		if not hov_unhov.count() or hov_unhov.get_card(self) == null: return
		hov_unhov.get_card(self).position.y = height - 60
		# Сброс наведения курсора на карту

# Обработка нажатия на карту
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hov_unhov.count():
		clicked = hov_unhov.max_hov()
		get_child(clicked).mouse_treatments(true)
	elif event.is_action_released("click") and clicked != -1:
		get_child(clicked).mouse_treatments(false)
		if get_child(clicked) == null: return
		if not Table.add_card(get_child(clicked)): get_child(clicked).position = get_child(clicked).new_pos
		else:
			Table.get_child(-1).start_anim("growth", true)
			_map_shift()
		hov_unhov.array_filter(_clear_cards_array)
		clicked = -1

# Фильтр для списков карт
func _clear_cards_array(item) -> bool: return item <= clicked and item < get_child_count()
