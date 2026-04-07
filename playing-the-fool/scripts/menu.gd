extends Control
@onready var AnimationN = $Animation
var file: Resource = load("res://scenes/card_pack.tscn")

# Таймер для анимации меню
func _on_timer_timeout() -> void:
	AnimationN.add_child(file.instantiate())
	AnimationN.get_child(-1).position = Vector2(50 + randi() % 1050, 50 + randi() % 550)
	AnimationN.get_child(-1).frame = 4 + randi() % 36
	AnimationN.get_child(-1).modulate.a = 0.
	AnimationN.get_child(-1).get_child(0).play("fall")
	if AnimationN.get_child_count() > 10: AnimationN.get_child(randi() % 5).get_child(0).play("hide")
