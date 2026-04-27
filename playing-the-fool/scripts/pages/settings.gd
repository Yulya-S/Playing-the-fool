extends GameWindow
@onready var Language = $Language

# Применение цвета
func _ready() -> void:
	for i in DirAccess.get_files_at("res://data/lang/"):
		if "csv" not in i:
			Language.add_item(i.split(".")[1])
			if i.split(".")[1] == Global.config.lang: Language.selected = Language.item_count - 1
	$ColorPicker.color = Color("#"+Global.config.background_color)
	$DeckType.selected = Global.config.card_pack

# Изменение языка
func _on_language_item_selected(index: int) -> void:
	TranslationServer.set_locale(Language.get_item_text(index))
	Global.config.lang = Language.get_item_text(index)
	Global.save_config()

# Изменение карточного пака
func _on_deck_type_item_selected(index: int) -> void:
	Global.config.card_pack = index
	Global.save_config()

# Изменение цвета фона
func _on_color_picker_color_changed(color: Color) -> void:
	Global.main.get_child(0).modulate = color
	Global.config.background_color = color.to_html()
	Global.save_config()

# Сброс цвета
func _on_reset_color_button_down() -> void:
	_on_color_picker_color_changed(Color("#"+Global._empty_conf().background_color))
	_ready()
