extends Node2D
# Пути к объектам в сцене
@onready var CardsCount = $CardsCount
@onready var DeckTimer = $Timer
@onready var Cards = $Cards
# Участники игры
@onready var Player = $"../Hand"
@onready var CI = $"../Computer"
# Переменные
var card: Resource = load("res://scenes/fragments/card.tscn") # Путь к сцене карты
var user_idx: bool = true # Порядок передачи карты

# Включение и отключение таймера раздачи карт
func _process(_delta: float) -> void:
	if Global.game_state == Global.GameStates.DISTRIBUTION:
		if DeckTimer.paused: DeckTimer.start()
		elif (Player.cards_enough() and CI.cards_enough()) or Cards.get_child_count() == 0:
			Global.game_state = Global.GameStates.PLAY
			DeckTimer.stop()

# Создание сцены
func _ready() -> void:
	Global.deck = self
	# Создание и перемешивание калоды
	var card_array: Array = Array(range(1, 37))
	while len(card_array) > 0:
		Global.add_obj(Cards, card)
		Cards.get_child(-1).set_value(card_array.pop_at(randi() % len(card_array)))
		Cards.get_child(-1).position.x += (36 - len(card_array)) * 0.5
		Cards.get_child(-1).position.y -= (36 - len(card_array)) * 0.5
	# Обновление графических данных
	CardsCount.set_text(str(Cards.get_child_count()))
	$Suit.hide_shadow(Cards.get_child(0).suit)

# Раздача карт
func _on_timer_timeout() -> void:
	(Player if user_idx else CI).add_card()
	user_idx = not user_idx
	if CI.cards_enough(): user_idx = true
	elif Player.cards_enough(): user_idx = false
	CardsCount.set_text(str(Cards.get_child_count()))
