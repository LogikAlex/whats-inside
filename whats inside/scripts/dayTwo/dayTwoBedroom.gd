extends Node2D

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
	ftween.tween_property(blackScreen, "modulate:a", 1, 6)
	ftween.tween_property(sleepDialogue2, "disabled", false, 0).set_delay(2.5)


func _on_dream_sq_timeout() -> void:
	globals.wantedPlayerPos = Vector2(38, 100)
	get_tree().change_scene_to_file("res://scenes/Days/Dream/coffee_river.tscn")

func dreamTimer():
	$DreamSq.start()

func _process(_delta: float) -> void:
	pass

func _work_timer():
	$WorkTimer.start()

func _work_dialogue_2_timer():
	$keyboard_sounds.play()
	$WorkDialogueTimer2.start()

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
	wakeUpTween.tween_callback(wakeUpDialogue).set_delay(4)

func wakeUpDialogue():
	wakeUpDial.disabled = false
	z_head_tween.kill()
	if spawned_z:
		spawned_z.free()

func standUp():
	globals.wokeUp = true
	MainSong.isPlaying = true
	MainSong.stop()
	MainSong.play()
	MainSong.volume_db = -5.5
	player.position = Vector2(24, 10)
	player.can_move = true
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
