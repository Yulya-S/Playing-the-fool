extends Hand

# Отображение количества карт в руке у компьютера
func _process(_delta: float) -> void: $"../CICardsCount".set_text(str(get_child_count()))
