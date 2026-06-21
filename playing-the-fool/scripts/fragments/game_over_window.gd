extends ColorRect

# Отображения окна победы
func start_anim(player: bool, CI: bool) -> void:
	$Result/AnimationPlayer.play("show")
	var winner: int = 0 if player else 1
	if winner == 0 and CI: $Result.set_text(tr("__USER2"))
	else: $Result.set_text(tr("_WINNER") + ": " + tr("__USER"+str(winner)))

# Обработка нажатия кнопки новой игры
func _on_new_game_button_down() -> void:
	$".."._on_window_button_down("game")
