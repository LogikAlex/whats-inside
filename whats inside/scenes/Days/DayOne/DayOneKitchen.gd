extends Node2D

@onready var coffeeDialog = $coffee_dialog/trigger_coffee

func _ready() -> void:
	if globals.coffeeDialog:
		coffeeDialog.disabled = false
	else:
		coffeeDialog.disabled = true
