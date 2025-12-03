extends Node2D

@onready var b_table: StaticBody2D = $bedsideCabinet
@onready var cutsceneCam = $CutsceneCam
@onready var blackScreen = $CutsceneCam/BlackScreen
@onready var interactIndicator = $InteractIndicator
@onready var bed: StaticBody2D = $bed
@onready var bedSprite = bed.get_node("Sprite2D")
@onready var player = $Player
@onready var z_sprite = preload("res://scenes/Objects/z_sprite.tscn")

@onready var anotherDayDialog = $anotherDayDialog/CollisionShape2D

var tweensFinished = false

var tween: Tween

var spawned_z: Sprite2D
var z_head_tween: Tween

func _ready() -> void:
	#globals.wokeUp = true
	_check_if_woke_up()

func _process(_delta: float) -> void:
	pass

func _check_if_woke_up():
	if !globals.wokeUp:
		blackScreen.visible = true
		fade_in_tween()
		z_tween()
		player.can_move = false
		bedSprite.frame = 1
		player.visible = false
	else:
		player.position = globals.wantedPlayerPos
		anotherDayDialog.disabled = true
		cutsceneCam.free()
		$Camera2D.enabled = true
		player.can_move = true
		bedSprite.frame = 0
		player.visible = true

func _input(event: InputEvent) -> void:
	if !globals.wokeUp and event.is_action_pressed("interact") and tweensFinished:
		globals.wokeUp = true
		cam_shift()
		z_head_tween.kill()
		if spawned_z:
			spawned_z.free()
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
	tween.tween_property(cutsceneCam, "global_position", Vector2(42, 19), 0.3).set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(interactIndicator, "modulate:a", 0, 0.5)
	tween.tween_callback(
	func switch_to_player_cam():
		cutsceneCam.free()
		$Camera2D.enabled = true
	).set_delay(0.3)
	tween.tween_callback(
	func show_dialog():
		anotherDayDialog.disabled = false
	).set_delay(0.5)
	
func fade_in_tween():
	reset_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(cutsceneCam, "zoom", Vector2(1, 1), 8)
	var bs_tween := create_tween()
	bs_tween.set_ease(Tween.EASE_IN_OUT)
	bs_tween.tween_property(blackScreen, "modulate:a", 0, 5)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(interactIndicator, "modulate:a", 1, 1.5).set_delay(2)
	tween.tween_callback(
	func tweens_finished():
		tweensFinished = true
		interactIndicator.isUpdating = true
	)
func z_tween():
	spawned_z = z_sprite.instantiate()
	add_child(spawned_z)
	var pos_x = bed.position.x + 8
	var pos_y = bed.position.y + 3
	
	var tween_time = randf_range(2, 4)
	var tween_rotaton = randf_range(-25, 35)
	
	spawned_z.position = Vector2(pos_x, pos_y)
	spawned_z.modulate.a = 0
	spawned_z.scale = Vector2(0.5, 0.5)
	spawned_z.rotation_degrees = 0
	
	z_head_tween = create_tween()
	z_head_tween.set_parallel()
	z_head_tween.tween_property(spawned_z, "modulate:a", 1, 1)
	z_head_tween.tween_property(spawned_z, "rotation_degrees", tween_rotaton, tween_time)
	z_head_tween.tween_property(spawned_z, "scale", Vector2(1, 1), tween_time)
	z_head_tween.tween_property(spawned_z, "position", Vector2(pos_x + 5, pos_y - 5), tween_time)
	z_head_tween.tween_property(spawned_z, "modulate:a", 0, 1).set_delay(tween_time - 1)
	z_head_tween.tween_property(spawned_z, "rotation_degrees", -12, 0).set_delay(tween_time)
	z_head_tween.tween_property(spawned_z, "scale", Vector2(0.5, 0.5), 0).set_delay(tween_time)
	z_head_tween.tween_property(spawned_z, "position", Vector2(pos_x, pos_y), 0).set_delay(tween_time)
	z_head_tween.tween_callback(
	func reset_z():
		if !globals.wokeUp:
			z_head_tween.kill()
			spawned_z.free()
			z_tween()
	).set_delay(tween_time)

func pick_up_pixels():
	b_table.get_node("Sprite2D").frame = 0
