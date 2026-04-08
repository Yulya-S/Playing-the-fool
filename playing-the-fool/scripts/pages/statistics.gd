extends Control
# Путь к объекту в сцене
@onready var LinesContainer = $ScrollContainer/VBoxContainer
# Переменные
var file: Resource = load("res://scenes/fragments/statistic.tscn") # Путь объекту списка статистики
var lines: Array = [] # Значения строк статистики

# Получения значений строк для создания статистики
func _ready() -> void: lines = get_parent().read_file(get_parent().stats_file_path)

# Постепенное создание строк статистики
func _process(_delta: float) -> void:
	if len(lines) != 0:
		Global.add_obj(LinesContainer, file)
		set_value(lines.pop_front())

# Применение значения для 
func set_value(value: Dictionary) -> void:
	for i in LinesContainer.get_child(-1).get_children():
		if i.name.to_lower() in value.keys(): i.set_text(str(int(value[i.name.to_lower()])))
	LinesContainer.get_child(-1).get_child(1).set_text("_USER" + LinesContainer.get_child(-1).get_child(1).text)

# Закрытие окна статистики
func _on_button_button_down() -> void: get_parent().close_window("menu")
