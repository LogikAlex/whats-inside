extends PointLight2D

func _ready() -> void:
	_flicker()
	if !globals.tv_off:
		$".".enabled = true
	else:
		$".".enabled = false

func _flicker():
	var flicker = create_tween()
	flicker.set_loops()
	flicker.tween_property($".", "energy", 0.4, 0.2)
	flicker.tween_property($".", "energy", 0.6, 0.2).set_delay(0.1)

func _turn_off():
	print("BROTHER TURN OFF BROTHER")
	$"../Player".can_move = true
	$"../tv_turn_off".free()
	$".".enabled = false
	$"../tv_sound".stop()
	globals.tv_off = true
	globals.coffeeDialog = true
