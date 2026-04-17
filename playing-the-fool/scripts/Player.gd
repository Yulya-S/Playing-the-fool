extends Node
var hovered_cards: Array = []

func _process(delta: float) -> void:
	hovered_cards.max()
	
	print(hovered_cards)
	#var index = 0
	#for i in hovered_cards:
		#if i.get_parent(): pass
		#
		#i.
