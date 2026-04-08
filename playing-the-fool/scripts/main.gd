extends Node2D
# Переменные
var user_path: String = "user://data/" # Директория хранения данных конфигурации
var conf_file_path: String = user_path + "conf.json" # Путь к файлу конфигураций
var stats_file_path: String = user_path + "stats.dat" # Путь к файлу статистики
var config: Dictionary = _empty_conf() # Данные конфигураций
var SECRET_KEY: String = "yunabi_save_key86549" # Ключь для шифрования игровых данных

# Стартовое создание директорий
func _ready() -> void:
	$Sprite2D.modulate = config.background_color
	if not DirAccess.dir_exists_absolute(user_path): DirAccess.make_dir_absolute(user_path)
	if not FileAccess.file_exists(stats_file_path): _store_json(stats_file_path, [])
	create_config()

# Сохранение данных в файл
func _store_json(file_path: String, data: Variant) -> void:
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, SECRET_KEY)
	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close()

# Чтение данных из файла
func _read_file(file_path: String) -> Variant:
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, SECRET_KEY)
	var json: JSON = JSON.new()
	if not json.parse(file.get_line()) == OK: return {}
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

# Сохранение данных статистики в файл
func save_stats(moves: int, winner: bool, cards_count: int) -> void:
	var data: Array = _read_file(stats_file_path)
	data.append({"moves": moves, "winner": winner, "cards_count": cards_count})
	_store_json(stats_file_path, data)

# Пустой словарь конфигурации
func _empty_conf() -> Dictionary: return {"card_pack": 0, "background_color": Color.DARK_GREEN}

# Очистка данных пользователя
func clear_config() -> void:
	config = _empty_conf()
	save_config()
