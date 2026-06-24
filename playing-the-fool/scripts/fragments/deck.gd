extends Node2D
# Путь к объекту в сцене
@onready var Cards = $Cards
# Переменная
var user_idx: bool = true # Порядок передачи карты

# Создание сцены
func _ready() -> void:
	Global.deck = self # Сохранение сцены в глобальном скрипте
	# Создание и перемешивание калоды
	var card_array: Array = Array(range(0, 36))
	while len(card_array) > 0:
		Global.add_obj(Cards, Global.card_scene)
		Cards.get_child(-1).set_value(card_array.pop_at(randi() % len(card_array)))
		var value = (36 - len(card_array)) * 0.5
		Cards.get_child(-1).position += Vector2(value, -value)
	# Обновление графических данных
	$Suit.frame = Cards.get_child(0).suit

# Включение и отключение таймера раздачи карт
func _process(_delta: float) -> void:
	if Global.game_state == Global.GameStates.DISTRIBUTION and (_cards_enough() or Cards.get_child_count() == 0):
			get_parent().set_stage(Global.GameStates.PLAY)

# Проверка что количество карт у всех игроков >= 6
func _cards_enough() -> bool: return Global.PL.cards_enough() and Global.CI.cards_enough()

# Получение количества оставшихся в колоде карт
func card_count() -> int: return Cards.get_child_count()

# Раздача карт
func _on_timer_timeout() -> void:
	if Cards.get_child_count() <= 24: user_idx = Global.player
	if _cards_enough(): return
	elif Global.CI.cards_enough(): user_idx = true
	elif Global.PL.cards_enough(): user_idx = false
	(Global.PL if user_idx else Global.CI).add_card()
	user_idx = not user_idx
	$CardsCount.set_text(str(Cards.get_child_count()))
