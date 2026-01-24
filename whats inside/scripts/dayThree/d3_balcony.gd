extends Node2D

@onready var ambience: CanvasModulate = $ambience
@onready var nightSound: AudioStreamPlayer2D = $night_ambience
@onready var sun: PointLight2D = $sun
@onready var light: Sprite2D = $Spotlight

@onready var dayDialogue: CollisionShape2D = $dayDialogue/CollisionShape2D
@onready var nightDialogue: CollisionShape2D = $nightDialogue/CollisionShape2D

func _ready() -> void:
	if globals.is_dark:
		dayDialogue.disabled = true
		nightDialogue.disabled = false
		ambience.color = Color8(45, 51, 76)
		nightSound.play()
		NightSong.isPlaying = false
		sun.enabled = false
		light.visible = false
	else:
		ambience.color = Color8(179, 180, 190)
