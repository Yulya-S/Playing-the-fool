extends ColorRect
# Путь к объекту в сцене
@onready var Res = $Result

# Проверка завершилась ли игра
func _process(_delta: float) -> void:
	if visible: return
	if Global.deck.card_count() == 0 and Global.table.get_child_count() == 0 and (Global.PL.empty() or Global.CI.empty()):
		var values: Array = [Global.PL.empty(), Global.CI.empty()]
		$Result/AnimationPlayer.play("show")
		if Res.text == "":
			if false in values: _set_winner(values.find(true), tr("_WINNER") + ": " )
			else: _set_winner()

# Применение текста завершения игры
func _set_winner(winner: int = 2, text: String = "") -> void:
	Global.save_stats(Global.game.steps, winner, Global.PL.get_child_count())
	Res.set_text(text + tr("__USER" + str(winner)))

# Обработка нажатия кнопки новой игры
func _on_new_game_button_down() -> void: Global.game._on_window_button_down("game")
