extends Node2D

@onready var door_dialogue = $door_dialog/CollisionShape2D
@onready var ambience = $ambience

func _ready() -> void:
	if globals.is_dark:
		door_dialogue.disabled = true
		ambience.color = Color8(45, 51, 76)
	else:
		door_dialogue.disabled = false
		ambience.color = Color8(202, 208, 229)
