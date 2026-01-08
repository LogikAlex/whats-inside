extends Sprite2D

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		frame = 1
	else:
		frame = 0
