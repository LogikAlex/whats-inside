extends StaticBody2D

@export var interactable = true

@onready var space_sprite = $Sprite2D
@onready var collisions = $CollisionPolygon2D

func _process(_delta: float) -> void:
	if interactable:
		if Input.is_action_pressed("interact"):
			space_sprite.frame = 1
			collisions.disabled = true
		else:
			space_sprite.frame = 0
			collisions.disabled = false
		if Input.is_action_just_released("interact"):
			$"../spaceRelease".play()
		if Input.is_action_just_pressed("interact"):
			$"../spaceClick".play()
