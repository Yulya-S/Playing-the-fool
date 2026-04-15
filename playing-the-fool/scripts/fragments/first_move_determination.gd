extends Sprite2D
# Путь к объекту в сцене
@onready var Result = $"../Result"
@onready var RAnimationPlayer = $"../Result/AnimationPlayer"

# Анимация стрелки
func _ready() -> void:
	# Расчет "победителя"
	var final_rotation = rotation + (TAU * 2) + randf_range(0, TAU)
	var deg: int = int(rad_to_deg(final_rotation)) % 360
	Result.set_text("_USER"+str(int(deg < 90 or deg > 270)))
	Result.add_theme_color_override("font_outline_color", Color("#fe0033") if deg < 90 or deg > 270 else Color("#0092d6"))
	$"../..".current_player = deg < 90 or deg > 270
	# Анимация вращения стрелки
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation", final_rotation, 3.0)
	await tween.finished
	# Запуск отображения первого игрока
	RAnimationPlayer.play("show")

# Обработка окончания анимации
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "show": RAnimationPlayer.play("hide")
	else: Global.delete_child($"../..", $"..")
