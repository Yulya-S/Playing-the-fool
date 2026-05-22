extends GameWindow
# Пути к объектам в сцене
@onready var Language = $Language
@onready var Picker = $ColorPicker

# Применение цвета
func _ready() -> void:
	Picker.color = Color("#"+Global.config.background_color)
	$DeckType.selected = Global.config.card_pack
	# Заполнение списка языков для выбора
	for i in DirAccess.get_files_at("res://data/lang/"):
		if "csv" not in i:
			Language.add_item(i.split(".")[1])
			if i.split(".")[1] == Global.config.lang: Language.selected = Language.item_count - 1

# Сохранение изменений
func _save_config(param_name: String, value: Variant) -> void:
	Global.config[param_name] = value
	Global.save_config()

# Изменение языка
func _on_language_item_selected(index: int) -> void:
	TranslationServer.set_locale(Language.get_item_text(index))
	_save_config("lang", Language.get_item_text(index))

# Изменение карточного пака
func _on_deck_type_item_selected(index: int) -> void: _save_config("card_pack", index)

# Изменение цвета фона
func _on_color_picker_color_changed(color: Color) -> void:
	Picker.color = color
	Global.main.get_child(0).modulate = color
	_save_config("background_color", color.to_html())
