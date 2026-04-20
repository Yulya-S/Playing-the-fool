extends Node
class_name Hand
@export var height: float = 0
@export var start_pos: float = 120
@export var weight: float = 952
@export var show_card: bool = true

func add_card() -> void:
	get_child(-1).transfer(height)
	get_child(-1).rotation = 0.0
	if show_card:
		get_child(-1).show_card()
		get_child(-1).start_anim("growth")
	else: get_child(-1).hide_card()
	_map_shift()

func _map_shift() -> void:
	for i in range(get_child_count()):
		get_child(i).new_pos[0] = start_pos + (0.0 if get_child_count() <= 1 else (weight / (get_child_count() - 1)) * i)
