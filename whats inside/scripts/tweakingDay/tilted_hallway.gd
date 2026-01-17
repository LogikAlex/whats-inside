extends Node2D

@onready var camera: Camera2D = $Player/Camera2D2

func _ready() -> void:
	camTween()

func camTween():
	var cam_rotate = create_tween()
	cam_rotate.set_loops()
	cam_rotate.set_parallel()
	cam_rotate.tween_property(camera, "rotation_degrees", 30.2, 3).set_ease(Tween.EASE_IN_OUT)
	cam_rotate.tween_property(camera, "position", Vector2(-67.0, -145.0), 3).set_ease(Tween.EASE_IN_OUT)
	cam_rotate.tween_property(camera, "rotation_degrees", -30.2, 3).set_delay(3).set_ease(Tween.EASE_IN_OUT)
	cam_rotate.tween_property(camera, "position", Vector2(-150.0, 45.0), 3).set_delay(3).set_ease(Tween.EASE_IN_OUT)
