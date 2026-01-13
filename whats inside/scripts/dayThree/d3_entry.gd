extends Node2D

@onready var ambience: CanvasModulate = $ambience

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(184, 185, 209)
