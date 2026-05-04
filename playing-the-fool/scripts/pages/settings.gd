extends GameWindow
# Путь к объекту в сцене
@onready var Language = $Language

# Применение цвета
func _ready() -> void:
	$ColorPicker.color = Color("#"+Global.config.background_color)
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
	Global.main.get_child(0).modulate = color
	_save_config("background_color", color.to_html())
