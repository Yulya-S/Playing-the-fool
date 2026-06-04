extends Hand

# Отображение количества карт в руке у компьютера
func _process(_delta: float) -> void:
	$"../CICardsCount".set_text(str(get_child_count()))
	if not Global.player and $"../Table".get_child_count() > 0 and not $"../CISay/".visible:
		$"../CISay/AnimationPlayer".play("show_CISay")

func shot() -> void:
	if get_child(0) == null: return
	get_child(0).reparent($"../Table")
	$"../Table".get_child(0).new_pos = Vector2(100 + randi() % 874, 130)
	$"../Table".get_child(0).show_hide()
