extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var box: Sprite2D = $BoxFinal
@onready var player: Sprite2D = $PlayerFinal

@onready var realPlayer: CharacterBody2D = $Player
@onready var whiteScreen: Sprite2D = $WhiteScreen2/Sprite2D
@onready var suspenseSound: AudioStreamPlayer2D = $suspense

@onready var dialogueBox: CollisionShape2D = $DialogueAreaWhite/CollisionShape2D
@onready var finishDialogue: CollisionShape2D = $DialogueAreaWhiter/CollisionShape2D

func _ready() -> void:
	realPlayer.position = Vector2(-64.0, 27.0)
	#realPlayer.can_move = false
	fadeIn()
	cameraLoop()

func change_scene():
	var tweenScene = create_tween()
	tweenScene.tween_property(whiteScreen, "modulate:a", 0, 2)
	tweenScene.tween_callback(
	func changeScene():
		get_tree().change_scene_to_file("res://scenes/Days/Ending/final_bedroom.tscn")
	)

func boxDisappear():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(box, "modulate:a", 0, 4).set_ease(Tween.EASE_OUT).set_delay(2)
	tween.tween_property(camera, "position", Vector2(168.0, 92.0), 4).set_ease(Tween.EASE_IN).set_delay(6)
	tween.tween_property(player, "modulate:a", 0, 4).set_ease(Tween.EASE_OUT).set_delay(10)
	tween.tween_callback(func dialogue_last(): finishDialogue.disabled = false).set_delay(16)
	tween.tween_callback(func play_music(): suspenseSound.play()).set_delay(9)

func fadeIn():
	var tween = create_tween()
	tween.tween_property(whiteScreen, "modulate:a", 0, 3).set_ease(Tween.EASE_OUT).set_delay(1)
	tween.tween_property(dialogueBox, "disabled", false, 0).set_delay(2)

func cameraLoop():
	var camTween = create_tween()
	camTween.set_loops()
	camTween.tween_property(camera, "offset", Vector2(2, 1), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	camTween.tween_property(camera, "offset", Vector2(-2, 3), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	camTween.tween_property(camera, "offset", Vector2(0, 0), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
