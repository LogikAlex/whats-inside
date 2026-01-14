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
	turnoff.tween_property($tvLight, "enabled", false, 0).set_delay(2.1)

func pickUpRemote():
	tvRemoteSprite.visible = false
	canTurnOffTV = true
	player.can_move = true
	camTrigger.disabled = false

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
