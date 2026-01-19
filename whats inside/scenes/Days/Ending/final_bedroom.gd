extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var whiteScreen: Sprite2D = $WhiteScreen/Sprite2D

func _ready() -> void:
	if !globals.finalBedroomFade:
		globals.finalBedroomFade = true
		whiteScreen.visible = true
		player.current_dir = player.directions.DOWN
		player.can_move = false
		player.position = Vector2(41.0, 25.0)
		fadeOut()
	else:
		whiteScreen.visible = false

func fadeOut():
	var tween = create_tween()
	tween.tween_property(whiteScreen, "modulate:a", 0, 6)
	tween.tween_callback(
	func end():
		player.can_move = true
	)
