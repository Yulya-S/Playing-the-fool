extends Hand

# Отображение количества карт в руке у компьютера
func _process(_delta: float) -> void: $"../CICardsCount".set_text(str(get_child_count()))

func shot() -> void:
	get_child(0).reparent($"../Table")
	$"../Table".get_child(0).new_pos = Vector2(40 + randi() % 994, 40 + randi() % 193)
	$"../Table".get_child(0).show_hide()
