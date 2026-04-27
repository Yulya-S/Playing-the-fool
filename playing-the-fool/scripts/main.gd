extends Node2D
# Путь к объекту в сцене
@onready var CardAnimation = $Animation
# Переменная
var file: Resource = load("res://scenes/fragments/card.tscn") # Путь к паку с картачными колодами

# Создание сцены
func _ready() -> void:
	# Настройки
	Global.main = self
	$Sprite2D.modulate = Color("#"+Global.config.background_color)
	# Создание файлов и директорий
	if not DirAccess.dir_exists_absolute(Global.user_path): DirAccess.make_dir_absolute(Global.user_path)
	if not FileAccess.file_exists(Global.stats_file_path): Global.store_json(Global.stats_file_path, [])
	Global.create_config()
	TranslationServer.set_locale(Global.config.lang)
	
# Таймер для анимации
func _on_timer_timeout() -> void:
	Global.add_obj(CardAnimation, file)
	CardAnimation.get_child(-1).position = Vector2(randi_range(50, 1100), randi_range(50, 550))
	CardAnimation.get_child(-1).frame = 4 + randi() % 36
	CardAnimation.get_child(-1).modulate.a = 0.
	CardAnimation.get_child(-1).start_anim("fall")
	if CardAnimation.get_child_count() > 11: CardAnimation.get_child(1).start_anim("hide")

# Открытие нового окна
func close_window(new_window: String) -> void:
	Global.delete_child(self, get_child(-1))
	Global.add_obj(self, load("res://scenes/pages/"+new_window+".tscn"))
	CardAnimation.visible = not (new_window == "game")
	$Animation/Timer.set_paused(new_window == "game")
