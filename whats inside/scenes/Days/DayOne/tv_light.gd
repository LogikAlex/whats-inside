extends PointLight2D

func _ready() -> void:
	if !globals.tv_off:
		_flicker()

func _flicker():
	var flicker = create_tween()
	$".".enabled = true
	flicker.set_loops()
	flicker.tween_property($".", "energy", 0.4, 0.2)
	flicker.tween_property($".", "energy", 0.6, 0.2).set_delay(0.1)

func _turn_off():
	print("BROTHER TURN OFF BROTHER")
	$"../tv_turn_off".free()
	$".".enabled = false
	globals.tv_off = true
