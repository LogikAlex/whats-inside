extends Node2D

@onready var title: Sprite2D = $TitleScreen
@onready var creditsLabels: Node2D = $creditsLabels

func _ready() -> void:
	creditsTween()

func creditsTween():
	var credits = create_tween()
	credits.set_parallel()
	credits.tween_property(title, "position", Vector2(159.9, -30.0), 10).set_delay(4)
	credits.tween_property(creditsLabels, "position", Vector2(0.0, -345.0), 35).set_delay(6)
	credits.tween_callback(
	func finish():
		get_tree().change_scene_to_file("res://scenes/MainMenu/main_menu.tscn")
	).set_delay(44)
