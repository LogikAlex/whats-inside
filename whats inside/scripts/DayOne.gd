extends Node2D

@onready var zAnim = $z_above_head_anim
@onready var cutsceneCam = $CutsceneCam
@onready var blackScreen = $CutsceneCam/BlackScreen
@onready var interactIndicator = $InteractIndicator
@onready var bedSprite = $bed.get_node("Sprite2D")
@onready var player = $Player

var wokeUp = false
var tweensFinished = false

var tween := create_tween()

func _ready() -> void:
	blackScreen.visible = true
	fade_in_tween()
	player.canMove = false

func _physics_process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and tweensFinished:
		if !wokeUp:
			wokeUp = true
			cam_shift()
			zAnim.stop()
			bedSprite.frame = 0
			player.visible = true
func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()
func cam_shift():
	reset_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cutsceneCam, "global_position", player.position, 0.3).set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(interactIndicator, "modulate:a", 0, 1)
	tween.tween_callback(
	func switch_to_player_cam():
		cutsceneCam.free()
		player.canMove = true
	).set_delay(0.3)
func fade_in_tween():
	reset_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(cutsceneCam, "zoom", Vector2(1, 1), 8)
	var bs_tween := create_tween()
	bs_tween.set_ease(Tween.EASE_IN_OUT)
	bs_tween.tween_property(blackScreen, "modulate:a", 0, 5)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(interactIndicator, "modulate:a", 1, 2.5).set_delay(2)
	tween.tween_callback(
	func tweens_finished():
		tweensFinished = true
		interactIndicator.isUpdating = true
	)
