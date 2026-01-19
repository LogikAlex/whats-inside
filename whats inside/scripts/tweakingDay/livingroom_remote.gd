extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $Player
@onready var barrier: CollisionShape2D = $barrier/CollisionShape2D
@onready var newCollisions: CollisionPolygon2D = $newCollisions/CollisionPolygon2D
@onready var tvNoRemote: CollisionShape2D = $tvNoRemote/CollisionShape2D
@onready var tvTurnOff: CollisionShape2D = $turnOffTv/CollisionShape2D
@onready var camTrigger: CollisionShape2D = $camReturn/CollisionShape2D
@onready var tvRemoteSprite: Sprite2D = $FOR_DAY_5
@onready var ambience: CanvasModulate = $ambience
@onready var blackScreen: Sprite2D = $BlackScreen/Sprite2D

@onready var pickUpSound: AudioStreamPlayer2D = $pickUpRemoteSound
@onready var tvSound: AudioStreamPlayer2D = $tvSound

var canTurnOffTV = false

func _ready() -> void:
	$tvLight.enabled = true

func _process(_delta: float) -> void:
	if canTurnOffTV:
		tvTurnOff.disabled = false

func returnCam():
	player.can_move = true
	camTrigger.disabled = true
	newCollisions.disabled = false
	var camTween = create_tween()
	camTween.tween_property(camera, "position", Vector2(66, 18), 4).set_ease(Tween.EASE_IN_OUT)

func turnOff():
	var turnoff = create_tween()
	turnoff.set_parallel()
	turnoff.tween_property(blackScreen, "modulate:a", 1, 0.1).set_delay(2.14)
	turnoff.tween_property(ambience, "color", Color8(0, 0, 0), 0.1).set_delay(2.04)
	turnoff.tween_property($tvLight, "energy", 0, 0.1).set_delay(2).set_ease(Tween.EASE_OUT)
	turnoff.tween_property(tvSound, "pitch_scale", 0.01, 0.1).set_delay(2).set_ease(Tween.EASE_OUT)
	turnoff.tween_property($tvLight, "enabled", false, 0).set_delay(2.1)
	turnoff.tween_callback(
	func finish():
		get_tree().change_scene_to_file("res://scenes/Days/Tweaking Day/box_livingroom.tscn")
	).set_delay(2.11)

func pickUpRemote():
	remoteDisappear()
	canTurnOffTV = true
	player.can_move = true
	camTrigger.disabled = false
	pickUpSound.play()
	cam_shake()

func remoteDisappear():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(tvRemoteSprite, "position", Vector2(258.0, 18.0), 0.5)
	tween.tween_property(tvRemoteSprite, "modulate:a", 0, 0.4)
	tween.tween_property($FOR_DAY_5/ceilingLight, "energy", 0, 0.4)

func cameraShift():
	var camTween = create_tween()
	camTween.tween_property(camera, "position", Vector2(124, 18), 6).set_delay(2)\
	.set_ease(Tween.EASE_IN_OUT)
	camTween.tween_callback(
	func finish():
		player.can_move = true
		barrier.disabled = true
		tvNoRemote.disabled = true
	).set_delay(1)

func cam_shake():
	var shake_tween = create_tween()
	shake_tween.tween_property(camera, "offset", Vector2(2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(-2, 0), 0.09)
	shake_tween.tween_property(camera, "offset", Vector2(0, 0), 0.09)
