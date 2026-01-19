extends Node2D

@onready var first_dial: CollisionShape2D = $dialogueTrigger/CollisionShape2D
@onready var second_dial: CollisionShape2D = $dialogueTrigger2/CollisionShape2D
@onready var third_dial: CollisionShape2D = $dialogueTrigger3/CollisionShape2D
@onready var countUpArea: CollisionShape2D = $counter/CollisionShape2D

@onready var boxSound: AudioStreamPlayer2D = $boxSound
@onready var boxSound2: AudioStreamPlayer2D = $boxSound2
@onready var boxInteract: CollisionShape2D = $boxDialogue/CollisionShape2D
@onready var boxDialogue2: CollisionShape2D = $boxDialogue2/CollisionShape2D
@onready var boxDialogue3: CollisionShape2D = $boxDialogue3/CollisionShape2D
@onready var whiteFlashSprite: Sprite2D = $whiteFlash
@onready var whiteScreen: Sprite2D = $WhiteScreen

@onready var camera: Camera2D = $Camera2D
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
	if globals.current_dial >= 7:
		boxInteract.disabled = false

func _process(_delta: float) -> void:
	if globals.current_dial >= 7:
		boxInteract.disabled = false

func enable_second_dial():
	white_flash()
	cam_shake()
	boxSound.play()
	var tween = create_tween()
	tween.tween_property(boxDialogue2, "disabled", false, 0).set_delay(2)

func enable_third_dial():
	white_flash()
	cam_shake()
	boxSound2.play()
	var tween = create_tween()
	tween.tween_property(boxDialogue3, "disabled", false, 0).set_delay(4)

func toWhite():
	boxSound2.pitch_scale = 0.5
	boxSound2.play()
	var tween = create_tween()
	tween.tween_property(whiteScreen, "modulate:a", 1, 1).set_ease(Tween.EASE_OUT).set_delay(0.2)
	tween.tween_callback(
	func finalScene():
		get_tree().change_scene_to_file("res://scenes/Days/Ending/final_scene.tscn")
	).set_delay(3.5)

func white_flash():
	whiteFlashSprite.modulate.a = 1
	var flash = create_tween()
	flash.tween_property(whiteFlashSprite, "modulate:a", 0, 1).set_ease(Tween.EASE_OUT)

func stop_music():
	TweakingSong.stop()

func next_dial():
	player.can_move = true
	globals.current_dial += 1

func cam_shake():
	var shake_tween = create_tween()
	shake_tween.tween_property(camera, "offset", Vector2(2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(-2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(0, 0), 0.09)
