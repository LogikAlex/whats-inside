extends Sprite2D

@export var isUpdating = false

func _process(_delta: float) -> void:
	if isUpdating:
		if Input.is_action_pressed("interact"):
			frame = 1
		else:
			frame = 0
	
