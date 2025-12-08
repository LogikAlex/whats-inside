extends Node2D

@onready var minigame = preload("res://scenes/Days/DayOne/d1_coffee_minigame.tscn")

@onready var coffeeDialog = $coffee_dialog/trigger_coffee
@onready var coffeeTimer = $CoffeeTimer
@onready var mugTimer = $MugTimer
@onready var player = $Player

var cleaned = false

func _ready() -> void:
	if globals.coffeeDialog:
		coffeeDialog.disabled = false
	else:
		coffeeDialog.disabled = true

func _process(_delta: float) -> void:
	if globals.cleanedCoffee and !cleaned:
		cleaned = true
		_fade_in()
		player.can_move = true
		$SpilledCoffee.free()
		$didnt_drink_bruh.free()

func _spill_coffee():
	$SpilledCoffee.visible = true
	$Mug.frame = 1
	#player.can_move = true

func _start_cofe_tajmr():
	coffeeTimer.start()
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
		add_child(_minigame)
		_minigame.global_position = Vector2(0, 0)
	).set_delay(2.1)
	
func _fade_in():
	var tween = create_tween()
	tween.tween_property(player.get_node("BlackScreen").get_node("Sprite2D"), "modulate:a", 0, 1.5)
