extends Area2D

@export var boxObject: StaticBody2D

var canTrigger = true

func _on_area_entered(_area: Area2D) -> void:
	if canTrigger:
		canTrigger = false
		showBox()

func showBox():
	var showTween = create_tween()
	showTween.tween_property(boxObject, "modulate:a", 1, 1).set_ease(Tween.EASE_IN)
	showTween.tween_callback(
	func erase():
		pass
		#free()
	)
