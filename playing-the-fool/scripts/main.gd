extends Node2D
# Переменная
var file: Resource = load("res://scenes/fragments/pack.tscn") # Путь к паку с картачными колодами

# Стартовое создание директорий
func _ready() -> void:
	if not DirAccess.dir_exists_absolute(Global.user_path): DirAccess.make_dir_absolute(Global.user_path)
	if not FileAccess.file_exists(Global.stats_file_path): Global.store_json(Global.stats_file_path, [])
	Global.create_config()
	$Sprite2D.modulate = Color("#"+Global.config.background_color)

# Открытие нового окна
func close_window(new_window: String) -> void:
	Global.delete_child(self, get_child(-1))
	Global.add_obj(self, load("res://scenes/pages/"+new_window+".tscn"))

# Таймер для анимации
func _on_timer_timeout() -> void:
	Global.add_obj($Animation, file)
	$Animation.get_child(-1).position = Vector2(50 + randi() % 1050, 50 + randi() % 550)
	$Animation.get_child(-1).frame = 4 + randi() % 36
	$Animation.get_child(-1).modulate.a = 0.
	$Animation.get_child(-1).get_child(-1).play("fall")
	if $Animation.get_child_count() > 11: $Animation.get_child(1 + randi() % 5).get_child(-1).play("hide")
