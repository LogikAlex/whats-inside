extends Node2D

@onready var table: Sprite2D = $BedroomTable
@onready var b_table: StaticBody2D = $bedsideCabinet
@onready var cutsceneCam = $CutsceneCam
@onready var blackScreen = $CutsceneCam/BlackScreen
@onready var interactIndicator = $InteractIndicator
@onready var typeIndicator = $InteractIndicatorType
@onready var bed: StaticBody2D = $bed
@onready var bedSprite = bed.get_node("Sprite2D")
@onready var player = $Player
@onready var camera: Camera2D = $Camera2D

@onready var z_sprite = preload("res://scenes/Objects/z_sprite.tscn")
@onready var rand_letter = preload("res://scenes/Objects/randLetter.tscn")

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

var typeLimit = 20
var typeCount = 0
var canType = false
var ended = true

var spawned_letter: Sprite2D
var spawned_z: Sprite2D
var z_head_tween: Tween
var rand_letter_tween: Tween

func _ready() -> void:
	#globals.wokeUp = true
	if globals.cleanedCoffee and !globals.worked:
		workInteract.disabled = false
		deskDialogue.disabled = true
	if globals.worked:
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
	if Input.is_action_just_released("interact") and ended:
		if canType and camera.zoom < Vector2(2.0, 2.0):
			letter_tween()
			typingCam()
			$keyboard_sounds.play()
		if canType and camera.zoom >= Vector2(2.0, 2.0):
			canType = false
			zoomOut()

func _sleep_timer():
	$SleepTimer.start()

func _work_timer():
	$WorkTimer.start()

func _stand_up_timer():
	$StandUpTimer.start()

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
	$WorkDialogueTimer.start()

func _on_work_dialogue_timer_timeout() -> void:
	workDialogue.disabled = false

func _on_stand_up_timer_timeout() -> void:
	$PlayerWorking.visible = false
	player.visible = true
	player.can_move = true

func _end_day():
	var bScreen = $CanvasLayer/bScreen
	var bTween = create_tween()
	globals.wokeUp = false
	bTween.set_parallel()
	bTween.tween_property(bScreen, "modulate:a", 1, 6)
	bTween.tween_property(NightSong, "volume_db", -45, 6).set_delay(3)
	bTween.tween_callback(func end():
		globals.is_dark = false
		get_tree().change_scene_to_file("res://scenes/Days/DayTwo/d2_bedroom.tscn")
	).set_delay(7)
	
func _go_to_sleep():
	bedSprite.frame = 1
	player.visible = false
	var imOkayTween = create_tween()
	imOkayTween.tween_property(imOkayDialogue, "disabled", false, 0).set_delay(4.5)

func _on_sleep_timer_timeout() -> void:
	_go_to_sleep()

func _on_work_timer_timeout() -> void:
	_work()

func _check_if_woke_up():
	if !globals.wokeUp:
		globals.tv_off = false
		blackScreen.visible = true
		fade_in_tween()
		z_tween()
		player.can_move = false
		player.current_dir = player.directions.DOWN
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
	if !globals.wokeUp and event.is_action_released("interact") and tweensFinished:
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
	tween.tween_property(cutsceneCam, "global_position", Vector2(42, 18), 0.3).set_trans(Tween.TRANS_SINE)
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
	bs_tween.set_ease(Tween.EASE_OUT)
	bs_tween.tween_property(blackScreen, "modulate:a", 0, 8)
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

func zoomOut():
	var zoomTween = create_tween()
	zoomTween.set_parallel()
	zoomTween.tween_property(typeIndicator, "modulate:a", 0, 0.30)
	zoomTween.tween_property(camera, "zoom", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT)
	zoomTween.tween_callback(
	func enableDialog():
		workDialogue2.disabled = false
	).set_delay(1.5)

func typingCam():
	var camTween = create_tween()
	camTween.tween_property(camera, "zoom", camera.zoom + Vector2(0.03, 0.03), 0.15).set_ease(Tween.EASE_OUT)

func letter_tween():
	ended = false
	typeCount += 1
	
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

func _start_song():
	MainSong.isPlaying = true
	player.can_move = true
