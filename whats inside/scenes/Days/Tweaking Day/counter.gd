extends Area2D

var can = true

func _on_area_entered(_area: Area2D) -> void:
	if can:
		can = false
		globals.current_dial += 1
