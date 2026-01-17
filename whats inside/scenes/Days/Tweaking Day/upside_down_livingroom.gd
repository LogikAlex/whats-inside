extends Node2D

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	camera_stretch()

func camera_stretch():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(camera, "zoom", Vector2(0.6, 0.5), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "zoom", Vector2(1.2, 1.3), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
