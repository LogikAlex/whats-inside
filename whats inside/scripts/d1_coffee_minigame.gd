extends Node2D

var idle_cursor = load("res://assets/misc/cursor1.png")
var grab_cursor = load("res://assets/misc/cursor2.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(idle_cursor, Input.CURSOR_ARROW, Vector2(8, 8))

func _process(_delta: float) -> void:
	if Input.is_action_pressed("click"):
		Input.set_custom_mouse_cursor(grab_cursor, Input.CURSOR_ARROW, Vector2(8, 8))
	else:
		Input.set_custom_mouse_cursor(idle_cursor, Input.CURSOR_ARROW, Vector2(8, 8))
