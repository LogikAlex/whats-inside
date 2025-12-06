extends Node2D

@onready var coffeeDialog = $coffee_dialog/trigger_coffee
@onready var coffeeTimer = $CoffeeTimer
@onready var mugTimer = $MugTimer
@onready var player = $Player

func _ready() -> void:
	if globals.coffeeDialog:
		coffeeDialog.disabled = false
	else:
		coffeeDialog.disabled = true

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
