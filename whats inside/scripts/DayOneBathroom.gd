extends Node2D

@onready var ambience = $ambience

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(202, 208, 229)
