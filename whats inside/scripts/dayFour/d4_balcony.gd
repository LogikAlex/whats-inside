extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var blameDialogue: CollisionShape2D = $blameDialog/CollisionShape2D

func _ready() -> void:
	if globals.balconyBlame:
		blameDialogue.disabled = false

func set_false():
	globals.balconyBlame = false
	player.can_move = true
