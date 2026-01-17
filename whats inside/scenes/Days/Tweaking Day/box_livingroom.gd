extends Node2D

@onready var blackScreen: Sprite2D = $BlackScreen/Sprite2D
@onready var ambience: CanvasModulate = $ambience
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	blackScreen.modulate.a = 1
	ambience.color = Color8(0, 0, 0)
	player.can_move = false
	player.current_dir = player.directions.RIGHT
	player.position = Vector2(107.0, 24.0)
	fadeIn()

func fadeIn():
	var bScreen = create_tween()
	bScreen.set_parallel()
	bScreen.tween_property(blackScreen, "modulate:a", 0, 0.1).set_delay(2)
	bScreen.tween_property(ambience, "color", Color8(41, 31, 78), 0.15).set_delay(2.05)
	bScreen.tween_callback(
	func finish():
		player.can_move = true
		TweakingSong.play()
	).set_delay(2.05)

func _process(_delta: float) -> void:
	pass
