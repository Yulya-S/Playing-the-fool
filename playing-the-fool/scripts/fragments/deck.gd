extends Node2D
# Пути к объектам в сцене
@onready var DeckTimer = $Timer
@onready var Cards = $Cards
# Участники игры
@onready var Player = $"../Hand"
@onready var CI = $"../Computer"
# Переменная
var user_idx: bool = true # Порядок передачи карты

# Создание сцены
func _ready() -> void:
	var card: Resource = load("res://scenes/fragments/card.tscn") # Путь к сцене карты
	Global.deck = self
	# Создание и перемешивание калоды
	var card_array: Array = Array(range(0, 36))
	while len(card_array) > 0:
		Global.add_obj(Cards, card)
		Cards.get_child(-1).set_value(card_array.pop_at(randi() % len(card_array)))
		Cards.get_child(-1).position.x += (36 - len(card_array)) * 0.5
		Cards.get_child(-1).position.y -= (36 - len(card_array)) * 0.5
	# Обновление графических данных
	$Suit.frame = Cards.get_child(0).suit

# Включение и отключение таймера раздачи карт
func _process(_delta: float) -> void:
	if Global.game_state == Global.GameStates.DISTRIBUTION and ((Player.cards_enough() and CI.cards_enough()) or Cards.get_child_count() == 0):
			get_parent().set_stage(Global.GameStates.PLAY)

# Раздача карт
func _on_timer_timeout() -> void:
	if CI.cards_enough() and Player.cards_enough(): return
	elif CI.cards_enough(): user_idx = true
	elif Player.cards_enough(): user_idx = false
	(Player if user_idx else CI).add_card()
	user_idx = not user_idx
	$CardsCount.set_text(str(Cards.get_child_count()))

# Получение количества оставшихся в колоде карт
func card_count() -> int: return Cards.get_child_count()
