extends Node2D

@onready var spilledCoffee: Sprite2D = $SpilledCoffee
@onready var player: CharacterBody2D = $Player
@onready var pictureSound: AudioStreamPlayer2D = $pictureFall
@onready var pictureTrigger: CollisionShape2D = $picture_trigger/trigger_coffee
@onready var coffeeCheck: CollisionShape2D = $coffee_dialog/trigger_coffee
@onready var coffeeRemind: CollisionShape2D = $coffee_remind/trigger_coffee
@onready var ambience: CanvasModulate = $ambience

var checkedCoffee = false

func _ready() -> void:
	spilledCoffee.modulate.a = 0.3
	if globals.checkedCoffee:
		coffeeRemind.disabled = true
	if globals.brushedTeeth and !globals.checkedCoffee:
		coffeeRemind.disabled = false
		coffeeCheck.disabled = false
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(156, 169, 158)

func _process(_delta: float) -> void:
	pass

func checkCoffee():
	globals.checkedCoffee = true
	player.can_move = true
	checkedCoffee = true
	pictureTrigger.disabled = false

func pictureFall():
	player.can_move = true
	MainSong.isPlaying = false
	pictureSound.play()
	globals.pictureFell = true
