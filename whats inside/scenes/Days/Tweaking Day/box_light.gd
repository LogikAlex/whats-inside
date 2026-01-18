extends PointLight2D

func _ready() -> void:
	if globals.current_dial > 6:
		lightPulse()

func lightAppear():
	var tween = create_tween()
	tween.tween_property($".", "energy", 0.4, 1)
	tween.tween_callback(
	func finish():
		lightPulse()
	)

func lightPulse():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($".", "energy", 0.4, 1)
	tween.tween_property($".", "energy", 0.2, 1)
