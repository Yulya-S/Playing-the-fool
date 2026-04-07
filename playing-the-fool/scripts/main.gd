extends Node2D
# Переменные
var user_path: String = "user://data/" # Директория хранения данных конфигурации
var conf_file_path: String = user_path + "conf.json" # Путь к файлу конфигураций
var stats_file_path: String = user_path + "stats.dat" # Путь к файлу статистики
var config: Dictionary = _empty_conf() # Данные конфигураций
var SECRET_KEY: String = "yunabi_save_key86549" # Ключь для шифрования игровых данных

# Стартовое создание директорий
func _ready() -> void:
	if not DirAccess.dir_exists_absolute(user_path): DirAccess.make_dir_absolute(user_path)
	create_config()
	$Sprite2D.modulate = config.background_color

# Сохранение данных в файл
func _store_json(file_path: String, data: Dictionary) -> void:
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, SECRET_KEY)
	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close()

# Чтение данных из файла
func _read_file(file_path: String) -> Dictionary:
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, SECRET_KEY)
	var json: JSON = JSON.new()
	if not json.parse(file.get_line()) == OK: return {}
	return json.data
	
	
	#var json = JSON.new()
	#json = json.parse(file.get_as_text())
	#file.close()
	#if not json == OK: return {}
	#print(json)
	#return {}
	#return json.get_data()

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
