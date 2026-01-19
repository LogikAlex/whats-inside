extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D

@onready var whiteScreen: Sprite2D = $white

@onready var question: Label = $question
@onready var yesLabel: Label = $yes_label
@onready var noLabel: Label = $no_label

@onready var leftArrow: Sprite2D = $LeftArrow
@onready var rightArrow: Sprite2D = $RightArrow

@onready var finalDialogue: CollisionShape2D = $finalDialogue/CollisionShape2D

@onready var dramaticSound: AudioStreamPlayer2D = $dramaticSound
@onready var finalDoorSound: AudioStreamPlayer2D = $finalDoor

var arrowsUpdating = false
var canChoose = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	handleArrows()
	handleChoice()

func doorOpen():
	finalDoorSound.play()
	var tween = create_tween()
	tween.tween_property(whiteScreen, "modulate", Color.BLACK, 0).set_delay(4.4)
	tween.tween_callback(
	func finish():
		get_tree().change_scene_to_file("res://scenes/Days/Ending/credits.tscn")
	).set_delay(5)

func handleChoice():
	if canChoose:
		if Input.is_action_just_released("ui_left"):
			leave()
		if Input.is_action_just_released("ui_right"):
			stay()

func leave():
	dramaticSound.play()
	canChoose = false
	arrowsUpdating = false
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "position", Vector2(50.0, 18.0), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(1.5)
	tween.tween_property(question, "modulate:a", 0, 2)
	tween.tween_property(leftArrow, "modulate:a", 0, 2).set_delay(1.5)
	tween.tween_property(rightArrow, "modulate:a", 0, 2)
	tween.tween_property(noLabel, "modulate:a", 0, 2)
	tween.tween_property(yesLabel, "modulate:a", 0, 2).set_delay(1.5)
	tween.tween_property(whiteScreen, "modulate:a", 1, 5).set_delay(4)
	tween.tween_callback(
	func finish():
		finalDialogue.disabled = false
	).set_delay(10)

func stay():
	canChoose = false
	arrowsUpdating = false
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "position", Vector2(50.0, 18.0), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(1.5)
	tween.tween_property(question, "modulate:a", 0, 2)
	tween.tween_property(leftArrow, "modulate:a", 0, 2)
	tween.tween_property(rightArrow, "modulate:a", 0, 2).set_delay(1.5)
	tween.tween_property(noLabel, "modulate:a", 0, 2).set_delay(1.5)
	tween.tween_property(yesLabel, "modulate:a", 0, 2)
	tween.tween_callback(
	func finish():
		player.can_move = true
	).set_delay(4)

func handleArrows():
	if arrowsUpdating:
		if Input.is_action_pressed("ui_left"):
			leftArrow.frame = 1
		else:
			leftArrow.frame = 0
		if Input.is_action_pressed("ui_right"):
			rightArrow.frame = 1
		else:
			rightArrow.frame = 0

func askIfReady():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "position", Vector2(50.0, -7.0), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(question, "modulate:a", 1, 3).set_delay(0.5)
	tween.tween_property(leftArrow, "modulate:a", 1, 2).set_delay(1.5)
	tween.tween_property(rightArrow, "modulate:a", 1, 2).set_delay(1.5)
	tween.tween_property(noLabel, "modulate:a", 1, 2).set_delay(1.5)
	tween.tween_property(yesLabel, "modulate:a", 1, 2).set_delay(1.5)
	tween.tween_callback(
	func finish():
		arrowsUpdating = true
		canChoose = true
	).set_delay(3.5)
	
