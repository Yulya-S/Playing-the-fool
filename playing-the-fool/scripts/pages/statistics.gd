extends GameWindow
# Путь к объекту в сцене
@onready var LinesContainer = $ScrollContainer/VBoxContainer
# Переменные
var file: Resource = load("res://scenes/fragments/statistic.tscn") # Путь объекту списка статистики
var lines: Array = [] # Значения строк статистики

# Получения значений строк для создания статистики
func _ready() -> void:
	Global.add_obj(LinesContainer, file)
	lines = Global.read_file(Global.stats_file_path)

# Постепенное создание строк статистики
func _process(_delta: float) -> void:
	if len(lines) != 0:
		Global.add_obj(LinesContainer, file)
		# Применение значения для строки статистики
		var value: Dictionary = lines.pop_front()
		for i in LinesContainer.get_child(-1).get_children():
			if i.name.to_lower() in value.keys(): i.set_text(str(int(value[i.name.to_lower()])))
		LinesContainer.get_child(-1).get_child(1).set_text("_USER" + LinesContainer.get_child(-1).get_child(1).text)
