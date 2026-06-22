extends ColorRect
# Переменная
var winner: int = 0 # Победитель в игре

# Отображения окна победы
func start_anim(player: bool, CI: bool) -> void:
	$Result/AnimationPlayer.play("show")
	winner = 2 if player and CI else not int(player)
	if winner == 2: $Result.set_text(tr("__USER2"))
	else: $Result.set_text(tr("_WINNER") + ": " + tr("__USER"+str(winner)))

# Сохранение статистики по завершению анимации
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Global.save_stats($"..".steps, winner, $"../Hand".get_child_count())

# Обработка нажатия кнопки новой игры
func _on_new_game_button_down() -> void:
	$".."._on_window_button_down("game")
