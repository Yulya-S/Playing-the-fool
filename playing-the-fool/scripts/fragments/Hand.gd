extends Node
class_name Hand
@export var height: float = 0
@export var start_pos: float = 180
@export var weight: float = 952
@export var show_card: bool = true

func add_card() -> void:
	get_child(-1).transfer(height)
	get_child(-1).rotation = 0.0
	if show_card:
		get_child(-1).show_card()
		get_child(-1).start_anim("growth")
	else: get_child(-1).hide_card()
	for i in range(get_child_count()): get_child(i).new_pos[0] = start_pos + (weight / get_child_count() * i)
