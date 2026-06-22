extends Hand
# Переменные
var hov_unhov: HovUnhov = HovUnhov.new() # Карты в наведении
var clicked: int = -1 # Карта на которую нажали

# Изменение позиций карт
func _process(_delta: float) -> void:
	if clicked != -1: get_child(clicked).position = get_viewport().get_mouse_position()
	elif hov_unhov.count() and hov_unhov.get_card(self) != null: 
		hov_unhov.get_card(self).position.y = height - 60

# Сортировка карт в руке игрока
func _card_sort() -> void:
	for i in range(get_child_count() - 1, -1, -1):
		for l in range(i, -1, -1):
			if get_child(i).price < get_child(l).price:
				move_child(get_child(l), i)
	_map_shift()

# Обработка нажатия на карту
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and hov_unhov.count():
		clicked = hov_unhov.max_hov()
		get_child(clicked).mouse_treatments(true)
	elif event.is_action_released("click") and clicked != -1 and get_child(clicked) != null:
		get_child(clicked).mouse_treatments(false)
		if not Global.table.add_card(get_child(clicked)): get_child(clicked).position = get_child(clicked).new_pos
		else:
			Global.table.get_child(-1).start_anim("growth", true)
			_map_shift()
		hov_unhov.array_filter(func(item): return item <= clicked and item < get_child_count())
		clicked = -1
