extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var playerOnCouch: Sprite2D = $Player_on_couch
@onready var interactIndicator: Sprite2D = $InteractIndicator
@onready var blackScreen: Sprite2D = $BlackScreen/Sprite2D

var canGetUp = false

func _ready() -> void:
	player.can_move = false
	player.position = Vector2(57, 28)
	indicatorAppear()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact") and canGetUp:
		getUp()

func indicatorAppear():
	blackScreen.modulate.a = 1
	var appear = create_tween()
	appear.tween_property(blackScreen, "modulate:a", 0, 4).set_delay(2)
	appear.tween_property(interactIndicator, "modulate:a", 1, 2).set_delay(4)
	appear.tween_callback(
	func finish():
		canGetUp = true
		interactIndicator.isUpdating = true
	).set_delay(0.1)

func indicatorDisappear():
	var disappear = create_tween()
	interactIndicator.isUpdating = false
	interactIndicator.frame = 0
	disappear.tween_property(interactIndicator, "modulate:a", 0, 1)

func getUp():
	indicatorDisappear()
	player.can_move = true
	player.visible = true
	player.current_dir = player.directions.RIGHT
	playerOnCouch.visible = false
