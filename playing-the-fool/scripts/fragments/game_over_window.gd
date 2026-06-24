extends ColorRect
# Пути к объектам в сцене
@onready var PL = $"../Hand"
@onready var CI = $"../Computer"
@onready var Res = $Result

# Проверка завершилась ли игра
func _process(delta: float) -> void:
	if visible: return
	if Global.deck.card_count() == 0 and Global.table.get_child_count() == 0 and (PL.empty() or CI.empty()):
		var values: Array = [PL.empty(), CI.empty()]
		$Result/AnimationPlayer.play("show")
		if Res.text == "":
			if false in values: _set_winner(values.find(true), tr("_WINNER") + ": " )
			else: _set_winner()

# Применение текста завершения игры
func _set_winner(winner: int = 2, text: String = "") -> void:
	Global.save_stats($"..".steps, winner, PL.get_child_count())
	Res.set_text(text + tr("__USER" + str(winner)))

# Обработка нажатия кнопки новой игры
func _on_new_game_button_down() -> void: $".."._on_window_button_down("game")
