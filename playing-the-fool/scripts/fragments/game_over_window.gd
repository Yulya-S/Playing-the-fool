extends ColorRect
# Переменная

# Отображения окна победы
func start_anim(player: bool, CI: bool) -> void:
	$Result/AnimationPlayer.play("show")
	if $Result.text == "":
		if player and CI: _set_winner(2, tr("__USER2"))
		else: _set_winner(int(not player), tr("_WINNER") + ": " + tr("__USER"+str(int(not player))))

# Применение текста завершения игры
func _set_winner(winner: int, text: String) -> void:
	Global.save_stats($"..".steps, winner, $"../Hand".get_child_count())
	$Result.set_text(text)

# Обработка нажатия кнопки новой игры
func _on_new_game_button_down() -> void: $".."._on_window_button_down("game")
