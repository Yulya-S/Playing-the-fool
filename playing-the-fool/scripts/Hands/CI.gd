extends Hand
# Переменная
var end_step: bool = false

func _process(_delta: float) -> void:
	$"../CICardsCount".set_text(str(get_child_count()))
	_map_shift()

func _fight() -> void:
	if not end_step and Global.table.get_child_count() > 0:
		for i in Global.table.get_children():
			if i.state == Global.CardStates.ATTACK:
				var select_card: Node = find_min(i)
				if select_card == null:
					$"../CISay/AnimationPlayer".play("show_CISay")
					$"../Dropping".set_text(tr("_GIVE_AWAY"))
					end_step = true
					return
				Global.table.set_secur(select_card, i)
				select_card.new_pos = Vector2(i.position.x+10, i.position.y+20)
				select_card.rotate_data = [true, 0]

func end_fight() -> void:
	for i in Global.table.get_children(): if i.state == Global.CardStates.ATTACK: return
	$"..".set_stage(Global.GameStates.DISTRIBUTION)
	$"..".next_step()

# Очистка состояний по окончанию хода
func taking_cards() -> void:
	super.taking_cards()
	end_step = false
	$"../CISay".visible = false

# Поиск карты с наименьшей ценой в руке компьютера
func find_min(card: Node) -> Node:
	var select_card: Node = null
	for i in get_children():
		if i.mt(card) and (select_card == null or select_card.mt(i)):
			select_card = i
	return select_card

# Ход компьютера
func _shot() -> void:
	if get_child_count() == 0 or get_child(0) == null: return
	get_child(0).reparent(Global.table)
	Global.table.get_child(0).new_pos = Vector2(100 + randi() % 874, 130)
	Global.table.get_child(0).show_hide()
