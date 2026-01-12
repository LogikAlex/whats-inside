extends Node2D

@onready var table: Sprite2D = $BedroomTable
@onready var whiteScreenCanvasLayer: CanvasLayer = $WhiteScreen
@onready var whiteScreen: Sprite2D = $WhiteScreen/Sprite2D
@onready var bedPlayerSprite: Sprite2D = $bed.get_node("Sprite2D")
@onready var player: CharacterBody2D = $Player
@onready var spaceIndicator: Sprite2D = $InteractIndicator
@onready var typeIndicator: Sprite2D = $InteractIndicatorType
@onready var workDialog: CollisionShape2D = $workDialog/CollisionShape2D
@onready var workTrigger: CollisionShape2D = $work_func/CollisionShape2D
@onready var deskDialog: CollisionShape2D = $deskDialogue/CollisionShape2D
@onready var ambience: CanvasModulate = $ambience
@onready var balconyLight: PointLight2D = $balconyLight

@onready var rand_letter = preload("res://scenes/Objects/randLetter.tscn")
@onready var camera: Camera2D = $Camera2D

var canType = false
var ended = true
var spawned_letter: Sprite2D
var rand_letter_tween: Tween

var canWakeUp = false

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
		balconyLight.enabled = false
	else:
		ambience.color = Color8(184, 185, 209)
		balconyLight.enabled = true
	if globals.canWork:
		deskDialog.disabled = true
		workTrigger.disabled = false
	if !globals.wokeFromDream:
		globals.is_dark = false
		globals.worked = false
		globals.brushedTeeth = false
		fadeInWhite()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact") and canWakeUp:
		canWakeUp = false
		globals.wokeFromDream = true
		bedPlayerSprite.frame = 0
		player.visible = true
		player.can_move = true
		fadeOutInteract()
		MainSong.isPlaying = true
		MainSong.volume_db = -3.0
		MainSong.pitch_scale = 0.93
	if Input.is_action_just_released("interact") and ended:
		if canType and camera.zoom < Vector2(1.1, 1.1):
			letter_tween()
			typingCam()
			$keyboard_sounds.play()
		if canType and camera.zoom >= Vector2(1.1, 1.1):
			canType = false
			globals.canWork = false
			zoomOut()

func _work_timer():
	$WorkTimer.start()

func _stand_up_timer():
	$standUpDeskTimer.start()

func _on_stand_up_desk_timer_timeout() -> void:
	$PlayerWorking.visible = false
	player.visible = true
	player.can_move = true

func _type():
	var interactTween = create_tween()
	interactTween.tween_property(typeIndicator, "modulate:a", 1, 1)
	interactTween.tween_callback(
	func letHimType():
		canType = true
		typeIndicator.isUpdating = true
	).set_delay(0.1)

func _work():
	globals.worked = true
	$PlayerWorking.visible = true
	player.visible = false
	_type()
	#$WorkDialogueTimer.start()

func _on_work_timer_timeout() -> void:
	_work()

func fadeInWhite():
	whiteScreenCanvasLayer.visible = true
	bedPlayerSprite.frame = 1
	player.visible = false
	player.can_move = false
	player.position = Vector2(24.0, 10.0)
	var fadeIn = create_tween()
	fadeIn.tween_property(whiteScreen, "modulate:a", 0, 4).set_delay(0.5)
	fadeIn.tween_property(spaceIndicator, "modulate:a", 1, 2).set_delay(4)
	fadeIn.tween_callback(
	func letHimUp():
		spaceIndicator.isUpdating = true
		canWakeUp = true
	).set_delay(0.1)

func fadeOutInteract():
	var fadeOut = create_tween()
	fadeOut.tween_property(spaceIndicator, "modulate:a", 0, 1)

func zoomOut():
	var zoomTween = create_tween()
	zoomTween.set_parallel()
	zoomTween.tween_property(typeIndicator, "modulate:a", 0, 0.30)
	zoomTween.tween_property(camera, "zoom", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT)
	zoomTween.tween_callback(
	func enableDialog():
		workDialog.disabled = false
	).set_delay(1.5)

func typingCam():
	var camTween = create_tween()
	camTween.tween_property(camera, "zoom", camera.zoom + Vector2(0.03, 0.03), 0.15).set_ease(Tween.EASE_OUT)

func letter_tween():
	ended = false
	
	var letter: Sprite2D = rand_letter.instantiate()
	add_child(letter)
	
	letter.modulate.a = 0
	letter.position.x = table.position.x + 0.5
	letter.position.y = table.position.y - 8
	letter.rotation_degrees = 0
	
	var l_tween = create_tween()
	var tween_rotaton = randf_range(-25, 35)
	var x_offset = randf_range(-3, 3)
	var wanted_x = (table.position.x + 0.5) + x_offset
	
	l_tween.set_parallel()
	l_tween.tween_property(letter, "modulate:a", 1, 0.3)
	l_tween.tween_property(letter, "position:x", wanted_x, 0.8)
	l_tween.tween_property(letter, "position:y", table.position.y - 13, 0.8)
	l_tween.tween_property(letter, "rotation_degrees", tween_rotaton, 0.8)
	l_tween.tween_property(letter, "modulate:a", 0, 0.4).set_delay(0.4)
	l_tween.tween_callback(
	func canAgain():
		ended = true
	).set_delay(0.15)
