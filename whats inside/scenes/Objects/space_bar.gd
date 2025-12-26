extends StaticBody2D

@onready var space_sprite = $Sprite2D
@onready var collisions = $CollisionPolygon2D

func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		space_sprite.frame = 1
		collisions.disabled = true
	else:
		space_sprite.frame = 0
		collisions.disabled = false
