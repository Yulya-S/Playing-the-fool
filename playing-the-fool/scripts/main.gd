extends Node2D
# Переменные
var user_path: String = "user://data/" # Директория хранения данных конфигурации
var conf_file_path: String = user_path + "conf.json" # Путь к файлу конфигураций
var config: Dictionary = _empty_conf() # Данные конфигураций

# Стартовое создание директорий
func _ready() -> void:
	if not DirAccess.dir_exists_absolute(user_path): DirAccess.make_dir_absolute(user_path)
	create_config()
	$Sprite2D.modulate = config.background_color

# Сохранение данных в файл
func _store_json(file_path: String, data: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
	
# Чтение данных из файла
func _read_file(file_path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	var json: JSON = JSON.new()
	if not json.parse(file.get_line()) == OK: return {}
	file.close()
	return json.data

# Проверка наличия созданного файла конфигураций
func create_config() -> void:
	if FileAccess.file_exists(conf_file_path):
		var new: Dictionary = _read_file(conf_file_path)
		if new.keys() == config.keys():
			config = new
			return
	save_config()

# Сохранение данных конфигураций в файл
func save_config() -> void: _store_json(conf_file_path, config)

# Пустой словарь конфигурации
func _empty_conf() -> Dictionary: return {"card_pack": 0, "background_color": Color.DARK_GREEN}

# Очистка данных пользователя
func clear_config() -> void:
	config = _empty_conf()
	save_config()
