extends Node2D

@onready var ambience = $ambience
@onready var day_dialogue = $DialogueArea/CollisionShape2D
@onready var night_dialogue = $DarkDialogue/CollisionShape2D

func _ready() -> void:
	if globals.is_dark:
		$sun.enabled = false
		$Spotlight.visible = false
		ambience.color = Color8(45, 51, 76)
		day_dialogue.disabled = true
		night_dialogue.disabled = false
	else:
		$sun.enabled = true
		$Spotlight.visible = true
		day_dialogue.disabled = false
		night_dialogue.disabled = true
		ambience.color = Color8(202, 208, 229)
