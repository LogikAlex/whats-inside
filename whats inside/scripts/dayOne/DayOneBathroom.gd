extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var ambience = $ambience
@onready var teethBrush = $sink_func/CollisionShape2D
@onready var mirrorDialogue = $mirror_dialog/CollisionShape2D
@onready var brushRemind = $brushDialogue/CollisionShape2D
@onready var arrowKeys: Node2D = $Player/arrow_keys

var brushCount = 0
var right = false
var brushing = false
var first = true

func _ready() -> void:
	if globals.brushedTeeth:
		teethBrush.disabled = true
		mirrorDialogue.disabled = false
		brushRemind.disabled = true
	else:
		brushRemind.disabled = false
		teethBrush.disabled = false
		mirrorDialogue.disabled = true
	
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(202, 208, 229)

func _process(_delta: float) -> void:
	if brushing and brushCount < 13:
		camTween()
	if brushing and brushCount >= 13:
		endBrushing()

func camTween():
	if Input.is_action_just_released("ui_left") and right or \
	Input.is_action_just_released("ui_left") and first:
		var tween = create_tween()
		tween.tween_property(camera, "offset", Vector2(-5, 0.0), 0.15)
		tween.tween_callback(
		func changeState():
			$brush_sound.play()
			first = false
			right = false
			brushCount += 1
		)
	if Input.is_action_just_released("ui_right") and !right:
		var tween = create_tween()
		tween.tween_property(camera, "offset", Vector2(5, 0.0), 0.15)
		tween.tween_callback(
		func changeState():
			$brush_sound.play()
			right = true
			first = false
			brushCount += 1
		)

func showArrowKeys():
	var keysTween = create_tween()
	keysTween.tween_property(arrowKeys, "modulate:a", 1, 1)

func _brush():
	player.current_dir = player.directions.UP
	globals.brushedTeeth = true
	brushing = true
	showArrowKeys()
	$Stand.get_node("Sprite2D").frame = 1

func endBrushing():
	brushing = false
	var fadeOut = create_tween()
	fadeOut.set_parallel()
	fadeOut.tween_property(arrowKeys, "modulate:a", 0, 0.6)
	fadeOut.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.5)
	fadeOut.tween_callback(
	func setFree():
		$Player.can_move = true
		$Stand.get_node("Sprite2D").frame = 0
		mirrorDialogue.disabled = false
	).set_delay(1.5)
