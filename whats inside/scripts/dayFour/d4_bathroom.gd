extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var blameDialogue: CollisionShape2D = $blameDialog/CollisionShape2D

func _ready() -> void:
	if globals.bathroomBlame:
		blameDialogue.disabled = false

func set_false():
	globals.bathroomBlame = false
	player.can_move = true
