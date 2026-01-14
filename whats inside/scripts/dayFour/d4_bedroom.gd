extends Node2D

@onready var blackScreenCanvas: CanvasLayer = $BlackScreen
@onready var blackScreen: Sprite2D = $BlackScreen/Sprite2D
@onready var bedPlayerSprite: Sprite2D = $bed.get_node("Sprite2D")
@onready var player: CharacterBody2D = $Player
@onready var interactIndicator: Sprite2D = $InteractIndicator
@onready var wFlash: Sprite2D = $whiteFlash

var canWake = false
var canTryAgain = true
var tries = 1

func _ready() -> void:
	#globals.wokeD4 = true
	if !globals.wokeD4:
		player.position = Vector2(24.0, 9.0)
		globals.is_dark = false
		wakeUp()

func _process(_delta: float) -> void:
	if canTryAgain and canWake:
		if Input.is_action_just_released("interact"):
			if tries < 3:
				whiteFlash()
			else:
				globals.wokeD4 = true
				player.current_dir = player.directions.DOWN
				player.visible = true
				player.can_move = true
				bedPlayerSprite.frame = 0
				fadeOutInteract()

func wakeUp():
	var wakeTween = create_tween()
	bedPlayerSprite.frame = 1
	player.can_move = false
	player.visible = false
	blackScreenCanvas.visible = true
	blackScreen.modulate.a = 1
	wakeTween.tween_property(blackScreen, "modulate:a", 0, 4)
	wakeTween.tween_property(interactIndicator, "modulate:a", 1, 2).set_delay(2)
	wakeTween.tween_callback(
	func enableInteract():
		interactIndicator.isUpdating = true
		canWake = true
	).set_delay(0.1)

func whiteFlash():
	canTryAgain = false
	var flash = create_tween()
	wFlash.visible = true
	wFlash.modulate.a = 1
	flash.tween_property(interactIndicator, "isUpdating", false, 0)
	flash.tween_property(wFlash, "modulate:a", 0, 1)
	flash.tween_property(interactIndicator, "modulate:a", 0, 1)
	flash.tween_property(interactIndicator, "modulate:a", 1, 1).set_delay(3)
	flash.tween_property(interactIndicator, "isUpdating", true, 0)
	flash.tween_callback(
	func tryAgain():
		tries += 1
		canTryAgain = true
	).set_delay(0.1)

func fadeOutInteract():
	var fadeOut = create_tween()
	fadeOut.tween_property(interactIndicator, "modulate:a", 0, 1)
