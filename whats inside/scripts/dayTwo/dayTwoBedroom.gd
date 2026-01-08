extends Node2D

@onready var table: Sprite2D = $BedroomTable
@onready var ambience = $ambience
@onready var bed: StaticBody2D = $bed
@onready var bedSprite = bed.get_node("Sprite2D")
@onready var player = $Player
@onready var z_sprite = preload("res://scenes/Objects/z_sprite.tscn")
@onready var blackScreen = $CanvasLayer/bScreen
@onready var wakeUpDial = $wakeUpDialogue/CollisionShape2D
@onready var workDialogue = $workDialog/CollisionShape2D
@onready var workDialogue2 = $workDialog2/CollisionShape2D
@onready var workInteract = $work_func/CollisionShape2D
@onready var sleepInteract = $sleep_func/CollisionShape2D
@onready var bedDialogue = $bed_dialog/CollisionShape2D
@onready var deskDialogue = $deskDialogue/CollisionShape2D
@onready var sleepDialogue = $sleep_dialogue/CollisionShape2D
@onready var sleepDialogue2 = $sleep_dialogue2/CollisionShape2D
@onready var interactIndicator: Sprite2D = $InteractIndicator

@onready var typeIndicator = $InteractIndicatorType
@onready var rand_letter = preload("res://scenes/Objects/randLetter.tscn")
@onready var camera: Camera2D = $Camera2D

var canType = false
var ended = true
var spawned_letter: Sprite2D
var rand_letter_tween: Tween

var canWake = false
var spawned_z: Sprite2D
var z_head_tween: Tween

func _ready() -> void:
	if globals.cleanedCoffee and !globals.worked:
		workInteract.disabled = false
		deskDialogue.disabled = true
	if globals.worked:
		deskDialogue.disabled = false
		workInteract.disabled = true
	if globals.is_dark:
		$PointLight2D.enabled = false
		sleepInteract.disabled = false
		bedDialogue.disabled = true
		ambience.color = Color8(45, 51, 76)
	else:
		$PointLight2D.enabled = true
		ambience.color = Color8(202, 208, 229)
	_check_if_woke_up()

func _start_sleep_timer():
	$SleepTimer.start()

func _on_sleep_timer_timeout() -> void:
	bed.get_node("Sprite2D").frame = 1
	player.can_move = false
	player.visible = false
	$SleepDialogueTimer.start()

func _on_sleep_dialogue_timer_timeout() -> void:
	sleepDialogue.disabled = false

func _fade_out_sequence():
	var ftween = create_tween()
	blackScreen.visible = true
	blackScreen.modulate.a = 0
	ftween.set_parallel()
	ftween.tween_property(NightSong, "volume_db", -45, 3).set_delay(3)
	ftween.tween_property(blackScreen, "modulate:a", 1, 6)
	ftween.tween_property(sleepDialogue2, "disabled", false, 0).set_delay(8.5)


func _on_dream_sq_timeout() -> void:
	globals.wantedPlayerPos = Vector2(38, 100)
	get_tree().change_scene_to_file("res://scenes/Days/Dream/starting_point.tscn")

func dreamTimer():
	$DreamSq.start()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("interact") and canWake:
		canWake = false
		standUp()
	if Input.is_action_just_released("interact") and ended:
		if canType and camera.zoom < Vector2(1.6, 1.6):
			letter_tween()
			typingCam()
			$keyboard_sounds.play()
		if canType and camera.zoom >= Vector2(1.6, 1.6):
			canType = false
			zoomOut()

func _work_timer():
	$WorkTimer.start()

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

func _on_work_dialogue_timer_2_timeout() -> void:
	workDialogue2.disabled = false

func _on_work_timer_timeout() -> void:
	_work()

func _check_if_woke_up():
	if !globals.wokeUp:
		globals.coffeeDialog = false
		globals.cleanedDialog = true
		globals.cleanedCoffee = false
		globals.tv_off = true
		globals.worked = false
		globals.brushedTeeth = false
		blackScreen.visible = true
		player.position = Vector2(24, 10)
		player.current_dir = player.directions.DOWN
		z_tween()
		wakeUp()
		player.can_move = false
		bedSprite.frame = 1
		player.visible = false
	else:
		blackScreen.visible = false
		player.position = globals.wantedPlayerPos
		player.can_move = true
		bedSprite.frame = 0
		player.visible = true

func wakeUp():
	var wakeUpTween = create_tween()
	wakeUpTween.tween_property(blackScreen, "modulate:a", 0, 5).set_delay(2)
	wakeUpTween.tween_property(interactIndicator, "modulate:a", 1, 1.5).set_delay(2)
	wakeUpTween.tween_callback(
	func canStand():
		canWake = true
		interactIndicator.isUpdating = true
	).set_delay(0.1)

func startMusic():
	player.can_move = true
	MainSong.isPlaying = true
	MainSong.stop()
	MainSong.play()
	MainSong.volume_db = -5.5

func standUp():
	wakeUpDial.disabled = false
	var intTween = create_tween()
	intTween.tween_property(interactIndicator, "modulate:a", 0, 0.5)
	z_head_tween.kill()
	if spawned_z:
		spawned_z.free()
	globals.wokeUp = true
	player.position = Vector2(24, 10)
	bedSprite.frame = 0
	player.visible = true

func startWakeUpTimer():
	$standUpTimer.start()

func _on_stand_up_timer_timeout() -> void:
	standUp()

func _stand_up_timer():
	$standUpDeskTimer.start()

func _on_stand_up_desk_timer_timeout() -> void:
	$PlayerWorking.visible = false
	player.visible = true
	player.can_move = true

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
