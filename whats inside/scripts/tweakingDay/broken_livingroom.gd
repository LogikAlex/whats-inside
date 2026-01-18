extends Node2D

@onready var first_dial: CollisionShape2D = $dialogueTrigger/CollisionShape2D
@onready var second_dial: CollisionShape2D = $dialogueTrigger2/CollisionShape2D
@onready var third_dial: CollisionShape2D = $dialogueTrigger3/CollisionShape2D
@onready var countUpArea: CollisionShape2D = $counter/CollisionShape2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if globals.current_dial < 4:
		countUpArea.disabled = false
	if globals.current_dial == 4:
		first_dial.disabled = false
	if globals.current_dial == 5:
		second_dial.disabled = false
	if globals.current_dial == 6:
		third_dial.disabled = false

func stop_music():
	TweakingSong.stop()

func next_dial():
	player.can_move = true
	globals.current_dial += 1
