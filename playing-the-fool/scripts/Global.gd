extends Node
# Главная сцена
var main = null
# Переменная
var config: Dictionary = _empty_conf() # Данные конфигураций
var user_path: String = "user://data/" # Директория хранения данных конфигурации
var conf_file_path: String = user_path + "conf.json" # Путь к файлу конфигураций
var stats_file_path: String = user_path + "stats.dat" # Путь к файлу статистики
var SECRET_KEY: String = "yunabi_save_key86549" # Ключь для шифрования игровых данных

# Работа с файлами
# Сохранение данных в файл
func _store_json(file_path: String, data: Variant) -> void:
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, SECRET_KEY)
	var json_string = JSON.stringify(data)
	file.store_string(json_string)
	file.close()

# Чтение данных из файла
func read_file(file_path: String) -> Variant:
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, SECRET_KEY)
	var json: JSON = JSON.new()
	if not json.parse(file.get_line()) == OK: return {}
	return json.data

# Проверка наличия созданного файла конфигураций
func create_config() -> void:
	if FileAccess.file_exists(conf_file_path):
		var new: Dictionary = read_file(conf_file_path)
		if new.keys() == config.keys():
			Global.config = new
			return
	save_config()

# Сохранение данных конфигураций в файл
func save_config() -> void: _store_json(conf_file_path, config)

# Сохранение данных статистики в файл
func save_stats(moves: int, winner: bool, cards_count: int) -> void:
	var data: Array = read_file(stats_file_path)
	data.append({"moves": moves, "winner": winner, "cards_count": cards_count})
	_store_json(stats_file_path, data)

# Пустой словарь конфигурации
func _empty_conf() -> Dictionary: return {"background_color": Color.DARK_GREEN.to_html(), "card_pack": 0}

# Очистка данных пользователя
func clear_config() -> void:
	config = _empty_conf()
	save_config()

# Работа со сценами
# Удаление объекта сцены
func delete_child(parent: Variant, child: Variant) -> void:
	child.queue_free()
	parent.remove_child(child)

# Добавление дочернего объекта
func add_obj(parent: Node, path: Resource) -> void:
	parent.add_child(path.instantiate())

# Открытие нового окна
func close_window(new_window: String) -> void:
	delete_child(main, main.get_child(-1))
	add_obj(main, load("res://scenes/pages/"+new_window+".tscn"))
