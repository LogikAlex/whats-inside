extends Node2D

@onready var b_table: StaticBody2D = $bedsideCabinet
@onready var cutsceneCam = $CutsceneCam
@onready var blackScreen = $CutsceneCam/BlackScreen
@onready var interactIndicator = $InteractIndicator
@onready var bed: StaticBody2D = $bed
@onready var bedSprite = bed.get_node("Sprite2D")
@onready var player = $Player
@onready var z_sprite = preload("res://scenes/Objects/z_sprite.tscn")
@onready var ambience = $ambience
@onready var anotherDayDialog = $anotherDayDialog/CollisionShape2D
@onready var gottaSleepDialog = $gottaSleepDialogue/CollisionShape2D
@onready var sleepInteract = $sleep_func/CollisionShape2D
@onready var bedInteract = $bed_dialog/CollisionShape2D
@onready var workInteract = $work_func/CollisionShape2D
@onready var workDialogue = $workDialogue/CollisionShape2D
@onready var workDialogue2 = $workDialogue2/CollisionShape2D
@onready var imOkayDialogue = $imOkay/CollisionShape2D
@onready var deskDialogue = $deskDialogue/CollisionShape2D

var tweensFinished = false

var tween: Tween

var spawned_z: Sprite2D
var z_head_tween: Tween

func _ready() -> void:
	#globals.wokeUp = true
	if globals.cleanedCoffee and !globals.workedD1:
		workInteract.disabled = false
		deskDialogue.disabled = true
	if globals.workedD1:
		deskDialogue.disabled = false
		workInteract.disabled = true
	if globals.is_dark:
		NightSong.isPlaying = true
		ambience.color = Color8(45, 51, 76)
		$PointLight2D.enabled = false
		gottaSleepDialog.disabled = false
		sleepInteract.disabled = false
		bedInteract.disabled = true
	else:
		ambience.color = Color8(202, 208, 229)
		$PointLight2D.enabled = true
	_check_if_woke_up()

func _process(_delta: float) -> void:
	pass

func _sleep_timer():
	$SleepTimer.start()

func _work_timer():
	$WorkTimer.start()

func _stand_up_timer():
	$StandUpTimer.start()

func _work_dialogue_2_timer():
	$keyboard_sounds.play()
	$WorkDialogueTimer2.start()

func _work():
	globals.workedD1 = true
	$PlayerWorking.visible = true
	player.visible = false
	$WorkDialogueTimer.start()

func _on_work_dialogue_timer_timeout() -> void:
	workDialogue.disabled = false

func _on_work_dialogue_timer_2_timeout() -> void:
	workDialogue2.disabled = false

func _on_stand_up_timer_timeout() -> void:
	$PlayerWorking.visible = false
	player.visible = true
	player.can_move = true

func _end_day():
	var bScreen = $CanvasLayer/bScreen
	var bTween = create_tween()
	bTween.tween_property(bScreen, "modulate:a", 1, 6)
	bTween.tween_property(NightSong, "volume_db", -80, 6)
func _go_to_sleep():
	bedSprite.frame = 1
	player.visible = false
	var imOkayTween = create_tween()
	imOkayTween.tween_property(imOkayDialogue, "disabled", false, 0).set_delay(3)

func _on_sleep_timer_timeout() -> void:
	_go_to_sleep()

func _on_work_timer_timeout() -> void:
	_work()

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
	tween.set_ease(Tween.EASE_IN_OUT)
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

func _start_song():
	MainSong.isPlaying = true
	player.can_move = true
