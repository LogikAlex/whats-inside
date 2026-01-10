extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var minigame = preload("res://scenes/Days/DayTwo/d2_coffee_minigame.tscn")
@onready var ambience = $ambience
@onready var coffeeDialog = $coffee_dialog/trigger_coffee
@onready var cleanedDialog = $cleaned_dialogue/colbody2d
@onready var spilledDialog = $spilled_dialogue/colbody2d
@onready var coffeeTimer = $CoffeeTimer
@onready var mugTimer = $MugTimer
@onready var player = $Player

var cleaned = false

func _ready() -> void:
	if globals.is_dark:
		ambience.color = Color8(45, 51, 76)
	else:
		ambience.color = Color8(169, 181, 171)
	
	if globals.cleanedCoffee:
		$SpilledCoffee.visible = true
		$SpilledCoffee.modulate.a = 0.3
		coffeeDialog.disabled = true
	
	if globals.brushedTeeth and !globals.cleanedCoffee:
		coffeeDialog.disabled = false
		$making_coffee/coffe.disabled = false
	else:
		$making_coffee/coffe.disabled = true
		coffeeDialog.disabled = true

func _process(_delta: float) -> void:
	if globals.cleanedCoffee and !cleaned:
		if globals.cleanedDialog:
			cleanedDialog.disabled = false
			globals.cleanedDialog = false
		cleaned = true
		globals.coffeeDialog = false
		#_fade_in()
		#player.can_move = true
		$making_coffee/coffe.disabled = true
		$Mug.frame = 1
		$Mug.visible = true
		$thedark.visible = true
		$SpilledCoffee.modulate.a = 0.25
		$didnt_drink_bruh.free()
		$StaticBody2D.free()

func cameraShake():
	var camShake = create_tween()
	camShake.tween_property(camera, "offset", Vector2(3.0, 0.0), 0.09)
	camShake.tween_property(camera, "offset", Vector2(-3.0, 0.0), 0.1)
	camShake.tween_property(camera, "offset", Vector2(0.0, 0.0), 0.1)

func _spill_coffee():
	cameraShake()
	$SpilledCoffee.visible = true
	$Mug.visible = false
	$Mug.frame = 1
	$spill_sfx.play()
	MainSong.isPlaying = false
	$SpillTimer.start()
	#player.can_move = true

func _on_spill_timer_timeout() -> void:
	spilledDialog.disabled = false

func _start_cofe_tajmr():
	coffeeTimer.start()
	$coffee_sfx.play()
	player.can_move = false

func _on_coffee_timer_timeout() -> void:
	$CoffeeMachine.frame = 1
	mugTimer.start()

func _on_mug_timer_timeout() -> void:
	$CoffeeMachine.frame = 0
	$Mug.visible = true
	$taking_coffee/take_trigger.disabled = false
	$didnt_drink_bruh/trigger.disabled = false
	$StaticBody2D/CollisionShape2D.disabled = false
	player.can_move = true

func _start_minigame():
	print("START MINIGAME")
	var tween = create_tween()
	tween.tween_property(player.get_node("BlackScreen").get_node("Sprite2D"), "modulate:a", 1, 2)
	tween.tween_callback(
	func _finish():
		var tween_fade_out = create_tween()
		tween_fade_out.tween_property(player.get_node("BlackScreen").get_node("Sprite2D"), "modulate:a", 0, 1)
		var _minigame: Node2D = minigame.instantiate()
		$thedark.visible = false
		add_child(_minigame)
		_minigame.global_position = Vector2(0, 0)
	).set_delay(2.1)
	
func _fade_in():
	var tween = create_tween()
	tween.tween_property(player.get_node("BlackScreen").get_node("Sprite2D"), "modulate:a", 0, 1.5)
