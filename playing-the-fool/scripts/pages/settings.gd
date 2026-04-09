extends Control
# Путь к объекту в сцене
@onready var Picker = $ColorPicker

# Применение цвета
func _ready() -> void:
	Picker.color = Color("#"+Global.config.background_color)
	$OptionButton.selected = Global.config.card_pack

# Изменение цвета фона
func _on_color_picker_color_changed(color: Color) -> void:
	get_parent().get_child(0).modulate = color
	Global.config.background_color = color.to_html()
	Global.save_config()

# Сброс цвета
func _on_reset_color_button_down() -> void:
	_on_color_picker_color_changed(Color("#"+Global._empty_conf().background_color))
	_ready()

# Изменение карточного пака
func _on_option_button_item_selected(index: int) -> void:
	Global.config.card_pack = index
	Global.save_config()

# Закрытие окна статистики
func _on_button_button_down() -> void: get_parent().close_window("menu")
