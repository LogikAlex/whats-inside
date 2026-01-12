extends Node2D

@onready var ambience: CanvasModulate = $ambience
@onready var nightSound: AudioStreamPlayer2D = $night_ambience
@onready var sun: PointLight2D = $sun
@onready var light: Sprite2D = $Spotlight

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
		nightSound.play()
		sun.enabled = false
		light.visible = false
	else:
		ambience.color = Color8(179, 180, 190)
