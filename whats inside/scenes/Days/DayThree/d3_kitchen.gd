extends Node2D

@onready var spilledCoffee: Sprite2D = $SpilledCoffee
@onready var player: CharacterBody2D = $Player
@onready var pictureSound: AudioStreamPlayer2D = $pictureFall
@onready var pictureTrigger: CollisionShape2D = $picture_trigger/trigger_coffee

var checkedCoffee = false

func _ready() -> void:
	spilledCoffee.modulate.a = 0.3

func _process(_delta: float) -> void:
	pass

func checkCoffee():
	player.can_move = true
	checkedCoffee = true
	pictureTrigger.disabled = false

func pictureFall():
	player.can_move = true
	pictureSound.play()
	globals.pictureFell = true
