extends Node2D

@onready var first_dial: CollisionShape2D = $dialogueTrigger/CollisionShape2D
@onready var second_dial: CollisionShape2D = $dialogueTrigger2/CollisionShape2D
@onready var third_dial: CollisionShape2D = $dialogueTrigger3/CollisionShape2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if globals.current_dial == 2:
		first_dial.disabled = true
		second_dial.disabled = false
	if globals.current_dial == 3:
		first_dial.disabled = true
		third_dial.disabled = false
	if globals.current_dial > 3:
		first_dial.disabled = true

func stop_music():
	TweakingSong.stop()

func next_dial():
	player.can_move = true
	globals.current_dial += 1
