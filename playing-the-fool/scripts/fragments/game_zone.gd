extends Control

func mouse_hover() -> bool:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	return mouse_pos.x > position.x and mouse_pos.y > position.y and \
		mouse_pos.x < position.x + size.x and mouse_pos.y < position.y + size.y
