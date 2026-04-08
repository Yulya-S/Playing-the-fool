extends Node

# Удаление объекта сцены
func delete_child(parent: Variant, child: Variant) -> void:
	child.queue_free()
	parent.remove_child(child)

# Добавление дочернего объекта
func add_obj(parent: Node, path: Resource) -> void:
	parent.add_child(path.instantiate())
