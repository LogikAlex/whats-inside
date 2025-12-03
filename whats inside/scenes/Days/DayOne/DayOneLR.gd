extends Node2D


func _ready() -> void:
	if globals.tv_off:
		$tv_turn_off.free()
		$tv_left_on.free()
